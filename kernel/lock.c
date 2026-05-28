#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "proc.h"
#include "sleeplock.h"
#include "lock.h"

#define NLOCK 64

struct {
  struct spinlock guard;  //保护下面的lock数组
  struct lock lock[NLOCK];
}ltable;  // 所有用于分配给用户进程的锁

void
lockinit(void)
{
  struct lock *l;
  initlock(&ltable.guard, "ltable");
  for(l = ltable.lock; l < &ltable.lock[NPROC]; l++) {
    initsleeplock(&l->lk, "ltable");
    l->ref = 0;
  }
}

// Increment ref count for lock l.
struct lock*
lockdup(struct lock *l)
{
  acquire(&ltable.guard);
  if(l->ref < 1)
    panic("lockdup");
  l->ref++;
  release(&ltable.guard);
  return l;
}

// Allocate a lock structure.
struct lock*
lockalloc(void)
{
  struct lock *l;

  acquire(&ltable.guard);
  for(l = ltable.lock; l < ltable.lock + NLOCK; l++){
    if(l->ref == 0){
      l->ref = 1;
      release(&ltable.guard);
      return l;
    }
  }
  release(&ltable.guard);
  return 0;
}

// Allocate a lock descriptor for the given lock.
// Takes over lock reference from caller on success.
static int
ldalloc(struct lock *l)
{
  int ld;
  struct proc *p = myproc();

  for(ld = 0; ld < NOLOCK; ld++){
    if(p->olock[ld] == 0){
      p->olock[ld] = l;
      return ld;
    }
  }
  return -1;
}

// Close lock l.  (Decrement ref count, close when reaches 0.)
void
lockclose(struct lock *l)
{
  acquire(&ltable.guard);
  if(l->ref < 1)
    panic("lockclose");
  if(--l->ref > 0){
    release(&ltable.guard);
    return;
  }
  l->ref = 0;
  release(&ltable.guard);
}

uint64
sys_createlock(void)
{
  int ld;
  struct lock *l;
  if((l = lockalloc()) == 0 || (ld = ldalloc(l)) < 0){
    if(l)
      lockclose(l);
    return -1;
  }
  return ld;
}

// Fetch the nth word-sized system call argument as a lock descriptor
// and return both the descriptor and the corresponding struct lock.
int
argld(int n, int *pld, struct lock **pl)
{
  int ld;
  struct lock *l;

  argint(n, &ld);
  if(ld < 0 || ld >= NOLOCK || (l=myproc()->olock[ld]) == 0)
    return -1;
  if(pld)
    *pld = ld;
  if(pl)
    *pl = l;
  return 0;
}

uint64
sys_closelock(void)
{
  int ld;
  struct lock *l;

  if(argld(0, &ld, &l) < 0)
    return -1;
  myproc()->olock[ld] = 0;
  lockclose(l);
  return 0;
}

uint64
sys_lock(void)
{
  //YOUR CODE HERE
  int ld;
  struct lock *l;
  if (argld(0, &ld, &l) < 0) return -1;
  acquiresleep(&l->lk);
  return 0;
}

uint64
sys_unlock(void)
{
  //YOUR CODE HERE
  int ld;
  struct lock *l;
  if (argld(0, &ld, &l) < 0) return -1;
  releasesleep(&l->lk);
  return 0;
}
