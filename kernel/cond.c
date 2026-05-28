#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "proc.h"
#include "sleeplock.h"
#include "lock.h"
#include "cond.h"

extern int argld(int, int*, struct lock**);

#define NCOND 64

struct {
  struct spinlock guard;  //保护下面的cond数组
  struct cond cond[NCOND];
}ctable;  // 所有用于分配给用户进程的条件变量

void
condinit(void)
{
  struct cond *c;
  initlock(&ctable.guard, "ctable");
  for(c = ctable.cond; c < &ctable.cond[NCOND]; c++) {
    c->ref = 0;
  }
}

// Increment ref count for cond c.
struct cond*
conddup(struct cond *c)
{
  acquire(&ctable.guard);
  if(c->ref < 1)
    panic("conddup");
  c->ref++;
  release(&ctable.guard);
  return c;
}

// Allocate a cond structure.
struct cond*
condalloc(void)
{
  struct cond *c;

  acquire(&ctable.guard);
  for(c = ctable.cond; c < ctable.cond + NCOND; c++){
    if(c->ref == 0){
      c->ref = 1;
      release(&ctable.guard);
      return c;
    }
  }
  release(&ctable.guard);
  return 0;
}

// Allocate a cond descriptor for the given cond.
// Takes over cond reference from caller on success.
static int
cdalloc(struct cond *c)
{
  int cd;
  struct proc *p = myproc();

  for(cd = 0; cd < NOCOND; cd++){
    if(p->ocond[cd] == 0){
      p->ocond[cd] = c;
      return cd;
    }
  }
  return -1;
}

// Close cond c.  (Decrement ref count, close when reaches 0.)
void
condclose(struct cond *c)
{
  acquire(&ctable.guard);
  if(c->ref < 1)
    panic("condclose");
  if(--c->ref > 0){
    release(&ctable.guard);
    return;
  }
  c->ref = 0;
  release(&ctable.guard);
}

// Fetch the nth word-sized system call argument as a cond descriptor
// and return both the descriptor and the corresponding struct cond.
int
argcd(int n, int *pcd, struct cond **pc)
{
  int cd;
  struct cond *c;

  argint(n, &cd);
  if(cd < 0 || cd >= NOCOND || (c=myproc()->ocond[cd]) == 0)
    return -1;
  if(pcd)
    *pcd = cd;
  if(pc)
    *pc = c;
  return 0;
}

uint64
sys_createcond(void)
{
  int cd;
  struct cond *c;
  if((c = condalloc()) == 0 || (cd = cdalloc(c)) < 0){
    if(c)
      condclose(c);
    return -1;
  }
  return cd;
}

uint64
sys_closecond(void)
{
  int cd;
  struct cond *c;

  if(argcd(0, &cd, &c) < 0)
    return -1;
  myproc()->ocond[cd] = 0;
  condclose(c);
  return 0;
}

uint64
sys_cond_wait(void)
{
  int cd, ld;
  struct cond *c;
  struct lock *l;

  if(argcd(0, &cd, &c) < 0)
    return -1;
  if(argld(1, &ld, &l) < 0)
    return -1;

  // 原子地释放锁并睡眠在条件变量上
  // 直接操作 sleeplock 内部的自旋锁
  acquire(&l->lk.lk);
  l->lk.locked = 0;
  l->lk.pid = 0;
  // sleep() 原子地释放自旋锁并睡眠
  sleep((void*)c, &l->lk.lk);
  // 醒来后重新获取 sleeplock
  while(l->lk.locked) {
    sleep(&l->lk, &l->lk.lk);
  }
  l->lk.locked = 1;
  l->lk.pid = myproc()->pid;
  release(&l->lk.lk);

  return 0;
}

// 唤醒所有等待此条件变量的进程
uint64
sys_cond_signal(void)
{
  int cd;
  struct cond *c;

  if(argcd(0, &cd, &c) < 0)
    return -1;
  wakeup((void*)c);
  return 0;
}
