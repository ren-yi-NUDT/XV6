# xv6 Concurrency Lab 实验报告

## 一、实验概述

本实验要求在 xv6 操作系统中实现三层并发编程原语：

```
用户级线程切换 (Uthread)
    ↓ 基础
锁 (Lock)           — 内核态，基于 sleeplock
    ↓ 基础
条件变量 (Cond)      — 内核态，基于 sleep/wakeup 机制
    ↓ 基础
信号量 (Semaphore)   — 用户态，组合锁 + 条件变量
```

---

## 二、Part 1：用户级线程切换 (uthread)

### 2.1 目标

在用户态实现线程的创建和上下文切换，三个线程轮流打印 0-99。

### 2.2 关键数据结构

**`uthread.h` — 定义线程上下文和线程结构体**

```c
// 需要保存的寄存器：RISC-V 的 callee-saved 寄存器
struct context {
  uint64 ra;    // 返回地址
  uint64 sp;    // 栈指针
  uint64 s0-s11; // 12个 callee-saved 寄存器
};

struct thread {
  char           stack[STACK_SIZE]; // 每个线程的私有栈 (8192 字节)
  int            state;             // FREE / RUNNING / RUNNABLE
  struct context ctx;               // 保存的寄存器上下文
};
```

**为什么只保存 callee-saved 寄存器？**

因为 `thread_switch` 是通过普通函数调用 (`call thread_switch`) 触发的。根据 RISC-V 调用约定，caller-saved 寄存器（a0-a7, t0-t6 等）在函数调用前已经被编译器自动保存到栈上了。只有 callee-saved 寄存器（ra, sp, s0-s11）需要在函数间手动保持不变，所以只有这些需要我们保存/恢复。

### 2.3 线程创建 — `thread_create()`

```c
void thread_create(void (*func)()){
    struct thread *t;
    // 1. 找一个 FREE 的线程槽位
    for (t = all_thread; t < all_thread + MAX_THREAD; t++){
        if (t->state == FREE) break;
    }
    t->state = RUNNABLE;
    // 2. 设置返回地址为线程函数入口
    //    当 thread_switch 恢复这个线程时，ret 指令会跳到 func
    t->ctx.ra = (uint64)func;
    // 3. 设置栈指针为线程栈的顶部（RISC-V 栈向下增长）
    t->ctx.sp = (uint64)&t->stack[STACK_SIZE];
}
```

**思考过程**：

- 新线程从未运行过，没有"上一次被切走的位置"。解决方案：把 `ra` 设为线程函数入口地址。当 `thread_switch` 恢复这个线程时，最后的 `ret` 指令会跳到 `ra` 存储的地址，也就是线程函数的开始。
- 栈指针必须指向栈数组的末尾（高地址），因为 RISC-V 栈从高向低增长。

### 2.4 线程调度 — `thread_schedule()`

```c
void thread_schedule(void){
    struct thread *t;
    struct thread *next = 0;
    // 1. 从当前线程之后开始，找下一个 RUNNABLE 线程（Round-Robin）
    for (t = current_thread + 1; t < all_thread + MAX_THREAD; t++){
        if (t->state == RUNNABLE) { next = t; break; }
    }
    // 2. 如果没找到，从头再找
    if (!next) {
        for (t = all_thread; t <= current_thread; t++){
            if (t->state == RUNNABLE) { next = t; break; }
        }
    }
    // 3. 没有可运行线程 → 结束
    if (!next) {
        if (current_thread->state == RUNNING) return;
        printf("thread_schedule: no runnable threads\n");
        exit(-1);
    }
    // 4. 切换到 next 线程
    next->state = RUNNING;
    struct thread *prev_thread = current_thread;
    current_thread = next;
    thread_switch(&prev_thread->ctx, &next->ctx);
}
```

### 2.5 上下文切换 — `uthread_switch.S`

```asm
thread_switch:
    # 保存旧线程的 callee-saved 寄存器到 old context (a0)
    sd ra, 0(a0)
    sd sp, 8(a0)
    sd s0, 16(a0)
    # ... s1-s11 ...

    # 从新线程的 context 恢复寄存器 (a1)
    ld ra, 0(a1)
    ld sp, 8(a1)
    ld s0, 16(a1)
    # ... s1-s11 ...

    ret   # 跳转到 ra（新线程的恢复点 或 新线程的函数入口）
```

**切换流程图**：

```
线程A调用 thread_yield()
  → thread_schedule()
    → thread_switch(&A.ctx, &B.ctx)
      → 保存 A 的寄存器到 A.ctx
      → 从 B.ctx 恢复寄存器
      → ret → 跳到 B 上次被切走的位置（或 B 的函数入口）
```

---

## 三、Part 2：锁 (Lock)

### 3.1 整体架构

锁的实现使用 xv6 已有的 **sleeplock**（睡眠锁）机制。整个系统包含三层锁：

```
自旋锁 (spinlock)    — 最底层，用于短临界区，忙等待
睡眠锁 (sleeplock)   — 中间层，基于自旋锁+sleep/wakeup，可长时间持有
用户锁 (lock)        — 最上层，给用户进程用的描述符机制，内部用 sleeplock 实现
```

### 3.2 描述符机制

用户进程通过整数描述符（类似文件描述符）来操作锁：

```
用户态                           内核态
------                           ------
int ld = createlock()    →  lockalloc() + ldalloc()
                            返回 olock[] 数组的下标

lock(ld)                 →  argld(0) 解析 olock[ld]
                            得到 struct lock*
                            acquiresleep(&l->lk)

unlock(ld)               →  releasesleep(&l->lk)

closelock(ld)            →  lockclose(), olock[ld] = 0
```

每个进程的 `struct proc` 中有 `struct lock *olock[NOLOCK]`（NOLOCK=8），存储该进程打开的锁指针。`argld()` 函数把用户传入的整数描述符映射到 `struct lock*`。

### 3.3 `sys_lock` 和 `sys_unlock` 实现

```c
uint64 sys_lock(void) {
    int ld;
    struct lock *l;
    if (argld(0, &ld, &l) < 0) return -1;
    acquiresleep(&l->lk);  // 获取睡眠锁（如果已被占用则睡眠）
    return 0;
}

uint64 sys_unlock(void) {
    int ld;
    struct lock *l;
    if (argld(0, &ld, &l) < 0) return -1;
    releasesleep(&l->lk);  // 释放睡眠锁并唤醒等待者
    return 0;
}
```

### 3.4 fork 时的锁继承

子进程通过 `fork()` 继承父进程的锁。在 `proc.c` 的 `fork()` 中：

```c
for(i = 0; i < NOLOCK; i++)
    if(p->olock[i])
        np->olock[i] = lockdup(p->olock[i]);  // 引用计数+1
```

`lockdup()` 将锁的引用计数加 1，这样父子进程共享同一个内核锁对象。`exit()` 时会 `lockclose()` 减引用计数，最后一个使用者关闭时才真正释放。

---

## 四、Part 3：条件变量 (Cond)

这是本实验最复杂的部分。

### 4.1 什么是条件变量

条件变量解决的核心问题是：**如何让进程在某个条件不满足时睡眠，条件满足时被唤醒？**

```
进程A（等待者）                    进程B（通知者）
lock(lk)                          lock(lk)
while(条件不满足)                   设置条件
  cond_wait(cond, lk)  →  睡眠    cond_signal(cond) → 唤醒A
// 条件满足了                      unlock(lk)
unlock(lk)
```

**关键难点**：`cond_wait` 必须**原子地**释放锁并睡眠。如果在释放锁和睡眠之间有间隙，进程B可能在这个间隙中发送 signal，导致进程A永远睡眠。

### 4.2 设计思路

#### 数据结构

```c
// kernel/cond.h
struct cond {
    int ref;  // 引用计数，0 表示空闲
};
```

条件变量本身非常简单——它只是一个引用计数。关键在于**等待通道（channel）**的选择：用 `struct cond` 实例自身的内存地址 `(void*)c` 作为 `sleep()`/`wakeup()` 的通道参数，保证每个条件变量有唯一的通道。

#### 条件变量表

和锁一样，使用全局表 + 描述符机制：

```c
#define NCOND 64

struct {
    struct spinlock guard;
    struct cond cond[NCOND];
} ctable;
```

每个进程有 `struct cond *ocond[NOCOND]`（NOCOND=8）存储打开的条件变量。

### 4.3 `sys_cond_wait` 的原子性问题（核心难点）

**问题**：`cond_wait(cond, lock)` 需要：
1. 释放锁 `lock`
2. 睡眠在 `cond` 的通道上
3. 这两步必须原子（中间不能被打断）

**解决方案**：直接操作 sleeplock 内部的自旋锁。

理解 sleeplock 的内部结构：

```c
struct sleeplock {
    uint locked;            // 是否被持有
    struct spinlock lk;     // 保护 locked 字段的自旋锁
    char *name;
    int pid;
};
```

正常的 `releasesleep()` 做的事：获取自旋锁 → 设 locked=0 → wakeup → 释放自旋锁。

我们的 `cond_wait` 这样做：

```c
uint64 sys_cond_wait(void) {
    // 解析参数
    argcd(0, &cd, &c);   // 条件变量
    argld(1, &ld, &l);   // 锁

    // === 原子地释放锁 + 睡眠 ===
    acquire(&l->lk.lk);      // 1. 获取 sleeplock 的内部自旋锁
    l->lk.locked = 0;        // 2. 标记锁为释放
    l->lk.pid = 0;
    sleep((void*)c, &l->lk.lk); // 3. 原子操作：释放自旋锁 + 睡眠在 c 上
                                //    没有任何其他进程能在这个间隙中抢占

    // === 醒来后重新获取锁 ===
    while(l->lk.locked) {       // 4. 等待锁可用
        sleep(&l->lk, &l->lk.lk);
    }
    l->lk.locked = 1;           // 5. 获取锁
    l->lk.pid = myproc()->pid;
    release(&l->lk.lk);         // 6. 释放内部自旋锁

    return 0;
}
```

**为什么这是原子的？** `sleep(void *chan, struct spinlock *lk)` 的内部实现是：关闭中断 → 把当前进程加到睡眠队列 → 释放 `lk` → 切换到调度器。释放自旋锁和进入睡眠是在同一个临界区内完成的，不可能被打断。

### 4.4 `sys_cond_signal`

```c
uint64 sys_cond_signal(void) {
    int cd;
    struct cond *c;
    argcd(0, &cd, &c);
    wakeup((void*)c);    // 唤醒所有在 c 地址上睡眠的进程
    return 0;
}
```

这里用 `wakeup` 而非 `wakeup1`，即唤醒所有等待者（broadcast 语义）。

### 4.5 需要修改的文件清单

| 文件 | 修改内容 |
|------|----------|
| `kernel/cond.h` | 定义 `struct cond { int ref; }` |
| `kernel/cond.c` | 全部实现：表管理 + 4 个系统调用 |
| `kernel/param.h` | 添加 `#define NOCOND 8` |
| `kernel/proc.h` | 在 `struct proc` 中添加 `struct cond *ocond[NOCOND]` |
| `kernel/main.c` | 添加 `condinit()` 调用 |
| `kernel/proc.c` | fork 中 `conddup` ocond，exit 中 `condclose` ocond |

---

## 五、Part 4：信号量 (Semaphore)

### 5.1 设计思路

信号量是**纯用户态**实现，不需要写任何内核代码。它组合锁和条件变量：

```c
struct sem {
    int value;   // 信号量计数器
    int cond;    // 条件变量描述符
    int lock;    // 锁描述符
};
```

### 5.2 P 操作 — `sem_wait`

```c
void sem_wait(struct sem *s) {
    lock(s->lock);
    while(s->value <= 0) {         // while 不是 if！
        cond_wait(s->cond, s->lock); // 释放锁并等待
    }
    s->value--;
    unlock(s->lock);
}
```

**为什么用 while 不用 if？** 因为 `cond_signal` 唤醒所有等待者。如果有多个进程在等待，它们被唤醒后只有一个能拿到资源。其余的必须重新检查条件。这就是"虚假唤醒"问题。

### 5.3 V 操作 — `sem_post`

```c
void sem_post(struct sem *s) {
    lock(s->lock);
    s->value++;
    cond_signal(s->cond);  // 唤醒一个等待者
    unlock(s->lock);
}
```

---

## 六、测试结果

### 6.1 uthread_test（线程切换）

```
$ uthread_test
thread_a started
thread_b started
thread_c started
thread_c 0
thread_a 0
thread_b 0
...
thread_c 99
thread_a 99
thread_b 99
thread_c: exit after 100
thread_a: exit after 100
thread_b: exit after 100
thread_schedule: no runnable threads
```

**make grade**: Score 11/11

### 6.2 lock_test（锁）

```
$ lock_test
main: begin
 [*g_pcounter = 0]
B: begin
A: begin
A: end
B: end
main: end
 [*g_pcounter: 2000]
 [ (expected): 2000]
```

两个进程各对共享计数器加 1000 次（中间有 10000 次空循环制造竞态），最终结果精确为 2000，证明锁正确工作。

### 6.3 throttle 3 1（信号量）

```
$ throttle 3 1
parent: begin
child 0: start
child 0:      end
child 2: start
child 2:      end
child 1: start
child 1:      end
parent: end
```

信号量初值为 1，任何时刻最多只有 1 个 child 在执行 start-end 之间。

---

## 七、文件修改总览

```
kernel/cond.h          [新建] 条件变量结构体定义
kernel/cond.c          [重写] 条件变量完整实现（表管理 + 系统调用）
kernel/lock.c          [修改] sys_lock / sys_unlock 实现
kernel/main.c          [修改] 添加 condinit() 调用
kernel/proc.c          [修改] fork/exit 中处理 ocond
kernel/proc.h          [修改] struct proc 添加 ocond[NOCOND]
kernel/param.h         [修改] 添加 NOCOND 定义
user/uthread.c         [修改] 线程创建与调度实现
user/uthread.h         [修改] struct context / struct thread 定义
user/uthread_switch.S  [修改] 上下文切换汇编实现
user/semaphore.c       [修改] sem_wait / sem_post 实现
```
