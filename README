# Lab 4: Copy-on-Write Fork

## 一、实验目标

在 xv6 中实现 Copy-on-Write (COW) fork。原始 `fork()` 会复制父进程的所有物理页面给子进程，开销巨大。COW fork 让父子进程共享同一份物理页面，仅当某一方尝试写入时才真正复制该页面，从而大幅减少内存占用和 fork 耗时。

同时实现 `cowstats` 系统调用，返回 COW 机制节省的物理内存总量。

## 二、设计思路

COW 机制需要协调以下组件：

```
fork (uvmcopy)
  ├── 不复制物理页面，改为共享
  ├── 对可写页清除 PTE_W，设置 PTE_COW 标记
  └── 增加物理页面的引用计数

page fault (usertrap, scause=15)
  ├── 检查是否为 COW 页（有 PTE_COW 标记）
  ├── 分配新物理页，复制内容
  ├── 更新 PTE：恢复 PTE_W，清除 PTE_COW
  └── 释放旧页面的引用（引用计数 -1）

copyout（内核写用户空间）
  ├── 检测目标页是否为 COW 页
  ├── 若是，执行与 page fault 相同的 COW 处理
  └── 若不是，直接写入物理地址
```

核心数据结构：为每个物理页面维护一个 **引用计数**，记录有多少个进程的页表指向该物理页。仅当引用计数降为 0 时才真正释放物理页面。

## 三、实现步骤

### 步骤 1：添加 PTE_COW 标志位

**文件**: `kernel/riscv.h`

RISC-V PTE 的 bit 8-9 是 RSW（Reserved for Software）位，可供操作系统自由使用。

```c
#define PTE_COW (1L << 8)  // bit 8 用作 COW 标记
```

### 步骤 2：实现物理页面引用计数

**文件**: `kernel/kalloc.c`

新增引用计数数组，索引为 `(物理地址 - KERNBASE) / PGSIZE`。

```c
struct {
  struct spinlock lock;
  int cnt[(PHYSTOP - KERNBASE) / PGSIZE];
} refcount;
```

需要修改的函数：

- **`kinit()`**: 初始化 `refcount.lock`
- **`freerange()`**: 在 `kfree` 前将每个页面的引用计数设为 1
- **`kalloc()`**: 分配页面时将引用计数设为 1
- **`kfree()`**: 先将引用计数减 1，仅当减至 0 时才真正释放页面

新增的辅助函数：

- **`refcount_inc(pa)`**: 将指定物理页面的引用计数加 1
- **`get_cow_saved()`**: 遍历所有页面，累计 `(refcount[i] - 1) * PGSIZE` 作为 COW 节省的内存

### 步骤 3：修改 fork 的页面复制逻辑

**文件**: `kernel/vm.c` — `uvmcopy()`

原始 `uvmcopy` 为每个页面 `kalloc` 新页并 `memmove` 复制内容。改为：

1. 将父进程的物理页面直接映射到子进程的页表中（不复制）
2. 对含有 `PTE_W` 的页面，清除 `PTE_W` 并设置 `PTE_COW`（父子进程的 PTE 都要改）
3. 对不含 `PTE_W` 的页面（如代码页），保持原样共享
4. 对每个共享页面调用 `refcount_inc`

```c
if (flags & PTE_W) {
  flags = (flags | PTE_COW) & ~PTE_W;
  *pte = (*pte | PTE_COW) & ~PTE_W;  // 修改父进程 PTE
}
mappages(new, i, PGSIZE, pa, flags);  // 子进程映射到同一物理页
refcount_inc(pa);
```

### 步骤 4：处理 COW 页面写缺页

**文件**: `kernel/trap.c` — `usertrap()`

在 `usertrap` 的 else 分支中，对 `scause == 15`（store page fault）进行处理：

```c
if (r_scause() == 15 && fault_va < MAXVA) {
  pte_t *pte = walk(p->pagetable, PGROUNDDOWN(fault_va), 0);
  if (pte && (*pte & PTE_V) && (*pte & PTE_COW)) {
    char *mem = kalloc();
    if (mem == 0) {
      setkilled(p);  // 内存不足，杀死进程
    } else {
      uint64 pa = PTE2PA(*pte);
      memmove(mem, (char*)pa, PGSIZE);     // 复制内容到新页
      *pte = PA2PTE((uint64)mem) | (PTE_FLAGS(*pte) & ~PTE_COW) | PTE_W;
      kfree((void*)pa);                    // 释放旧页引用
    }
  } else {
    // 非 COW 页面触发的写缺页，属于非法访问
    setkilled(p);
  }
}
```

**注意**: 必须检查 `fault_va < MAXVA`，否则 `walk()` 会对 `>= MAXVA` 的地址触发 panic。

### 步骤 5：修改 copyout 处理 COW

**文件**: `kernel/vm.c` — `copyout()`

`copyout` 在内核态直接操作物理地址，绕过 MMU，因此不会触发 page fault。需要手动检测并处理 COW：

```c
pte = walk(pagetable, va0, 0);
if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
  return -1;
if ((*pte & PTE_W) == 0 && (*pte & PTE_COW) == 0)
  return -1;                    // 不可写且非 COW 页，拒绝写入
if (*pte & PTE_COW) {
  char *mem = kalloc();
  if (mem == 0) return -1;
  uint64 old_pa = PTE2PA(*pte);
  memmove(mem, (char*)old_pa, PGSIZE);
  *pte = PA2PTE((uint64)mem) | (PTE_FLAGS(*pte) & ~PTE_COW) | PTE_W;
  kfree((void*)old_pa);
}
pa0 = PTE2PA(*pte);
memmove((void*)(pa0 + (dstva - va0)), src, n);
```

### 步骤 6：修改用户程序链接脚本

**文件**: `user/user.ld`

xv6 默认将用户程序链接为单个 RWE（可读可写可执行）段，导致所有页面（包括代码页）都有 `PTE_W`。这会使 fork 后所有页面都被标记为 COW，包括本不应被写入的代码页。

修改链接脚本，将代码段和数据段分离为两个独立的 LOAD 段：

- **text 段**: `.text` + `.rodata`，权限 R+X (FLAGS=5)，无 W
- **data 段**: `.data` + `.bss`，权限 R+W (FLAGS=6)，无 X

```
PHDRS
{
  text PT_LOAD FLAGS(5);   /* R+X */
  data PT_LOAD FLAGS(6);   /* R+W */
}

SECTIONS
{
  . = 0x0;
  .text : { *(.text .text.*) } :text
  .rodata : { ... } :text
  . = ALIGN(0x1000);        /* data 段必须页对齐 */
  .data : { ... } :data
  .bss : { ... } :data
}
```

`. = ALIGN(0x1000)` 确保 data 段的虚拟地址页对齐（`exec.c` 要求 `ph.vaddr % PGSIZE == 0`）。

这样 `exec` 加载程序时，代码页只获得 `PTE_X` 权限（无 `PTE_W`），fork 时不会被标记为 COW。`copyout` 也会正确拒绝写入代码页。

### 步骤 7：添加 cowstats 系统调用

涉及文件：

| 文件 | 修改内容 |
|------|---------|
| `kernel/syscall.h` | `#define SYS_cowstats 22` |
| `kernel/syscall.c` | 添加 `extern uint64 sys_cowstats(void);` 和 syscall 表项 |
| `kernel/sysproc.c` | 实现 `sys_cowstats()`，调用 `get_cow_saved()` |
| `kernel/defs.h` | 声明 `refcount_inc`、`get_cow_saved` |
| `user/user.h` | 声明 `int cowstats(void);` |
| `user/usys.pl` | 添加 `entry("cowstats");` |

### 步骤 8：创建 time.txt

```
3
```

## 四、修改文件总览

| 文件 | 修改说明 |
|------|---------|
| `kernel/riscv.h` | 添加 `PTE_COW` 宏定义 |
| `kernel/kalloc.c` | 添加引用计数机制，修改 `kinit`/`freerange`/`kalloc`/`kfree` |
| `kernel/vm.c` | 修改 `uvmcopy` 实现 COW 共享，修改 `copyout` 处理 COW 页 |
| `kernel/trap.c` | 在 `usertrap` 中添加 scause=15 的 COW 缺页处理 |
| `kernel/syscall.h` | 添加 `SYS_cowstats` 系统调用号 |
| `kernel/syscall.c` | 注册 `sys_cowstats` |
| `kernel/sysproc.c` | 实现 `sys_cowstats` |
| `kernel/defs.h` | 添加引用计数相关函数声明 |
| `user/user.ld` | 分离 text/data 段为独立 LOAD 段 |
| `user/user.h` | 添加 `cowstats` 用户态声明 |
| `user/usys.pl` | 添加 `cowstats` 系统调用入口 |

## 五、测试结果

```
$ make grade
== Test running cowtest == (4.0s)
== Test   simple ==   simple: OK
== Test   three ==    three: OK
== Test   file ==     file: OK
== Test usertests ==  (38.0s)
== Test   usertests: copyin ==   usertests: copyin: OK
== Test   usertests: copyout ==  usertests: copyout: OK
== Test   usertests: all tests == usertests: all tests: OK
== Test running cowstats_test == (5.1s)
== Test   simple_cowstats ==   simple_cowstats: OK
== Test   three_cowstats ==   three_cowstats: OK
== Test   file_cowstats ==    file_cowstats: OK
== Test time ==   time: OK
Score: 150/150
```
