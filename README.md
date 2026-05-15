======================================================================
Lab: Speed up system calls — 实验说明
======================================================================

## 目标

通过在内核和用户空间之间共享一个只读内存页，加速 getpid() 系统调用。
传统方式下，每次调用 getpid() 都需要：用户态 → 陷入内核 → 内核读取 pid → 返回用户态。
这个"内核态切换"开销不小。如果内核在进程创建时就把 pid 写到一个用户态也能直接读
的内存页里，用户程序就能直接读取 pid，完全不需要进入内核。

## 原理

xv6 的用户虚拟地址空间布局（从高到低）：

  TRAMPOLINE  (最高地址) — 内核/用户共享的跳板代码
  TRAPFRAME   (次高地址) — 陷入帧，保存寄存器等
  USYSCALL    (新增)     — 共享页，存放 struct usyscall { int pid; }
  ... 用户代码、数据、堆栈 ...

用户空间的 ugetpid() 已经实现好了，它直接读 USYSCALL 地址处的 pid：
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;

我们要做的就是在内核侧：分配这个页面、写入 pid、映射到用户页表中。

## 修改内容

### 1. kernel/proc.h — struct proc 增加 usyscall 指针

  struct usyscall *usyscall;   // shared page for speeding up syscall

为什么：struct proc 是进程控制块，每个进程都需要一个指针来记录自己对应的
usyscall 页面在哪。和 trapframe 指针的作用完全一样——记录"这一页物理内存归这个进程管"。

### 2. kernel/proc.c — allocproc() 分配 usyscall 页面

  if ((p->usyscall = (struct usyscall *)kalloc()) == 0) { ... }
  p->usyscall->pid = p->pid;

为什么：allocproc() 是创建新进程时的初始化函数。进程刚创建时就要分配好 usyscall 页面
并把 pid 写进去，这样进程一运行就能用 ugetpid()。kalloc() 分配一页 4096 字节的物理内存，
然后把当前进程的 pid 写到这个页面的开头。

### 3. kernel/proc.c — proc_pagetable() 映射 USYSCALL 页面

  if(mappages(pagetable, USYSCALL, PGSIZE,
              (uint64)(p->usyscall), PTE_R | PTE_U) < 0) { ... }

为什么：光分配物理内存还不够，用户程序访问的是虚拟地址。mappages() 把虚拟地址 USYSCALL
映射到刚分配的物理页面，这样用户程序读 USYSCALL 这个地址时就能读到 pid。
权限设为 PTE_R | PTE_U：PTE_R 表示可读，PTE_U 表示用户态可访问。
没有 PTE_W，所以用户态不能修改这个页面（防止用户伪造 pid）。

### 4. kernel/proc.c — freeproc() 释放 usyscall 页面

  if(p->usyscall)
    kfree((void*)p->usyscall);
  p->usyscall = 0;

为什么：进程退出时要释放所有资源。usyscall 页面是 kalloc() 分配的物理内存，
必须用 kfree() 归还，否则内存泄漏。指针置 0 是防御性编程，防止 dangling pointer。

### 5. kernel/proc.c — proc_freepagetable() 取消 USYSCALL 映射

  uvmunmap(pagetable, USYSCALL, 1, 0);

为什么：释放页表时要先取消所有特殊映射。uvmunmap 把 USYSCALL 虚拟地址对应的
页表项清除。最后的参数 0 表示不要释放物理内存（物理内存在 freeproc 里已经释放了），
只清除映射关系。

## 核心思想总结

整个修改就是在模仿 trapframe 的生命周期管理，给 usyscall 做同样的事：

  创建进程：kalloc 分配页面 → 写入 pid → mappages 映射到页表
  销毁进程：uvmunmap 取消映射 → kfree 释放物理内存

## 还有哪些系统调用也能这样加速？

条件：系统调用只读取进程创建时就确定、之后不变的数据，且不需要内核特权。

  - getuid() / getgid() — 用户/组 ID，进程生命周期不变
  - getppid() — 父进程 ID，通常不变
  - sched_getaffinity() — CPU 亲和性掩码

不适合的例子：gettimeofday()（时间在变）、read()（需要内核设备操作）。

## 验证

  make clean && make qemu
  # 在 xv6 shell 中：
  pgtbltest
  # ugetpid test 应该通过（创建 64 个子进程，每个验证 getpid() == ugetpid()）
