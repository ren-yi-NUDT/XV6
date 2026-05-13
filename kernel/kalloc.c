// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

struct{
  struct spinlock lock;
  int cnt[(PHYSTOP - KERNBASE) / PGSIZE]; 
} refcount;

void refcount_inc(uint64 pa){
  acquire(&refcount.lock);
  refcount.cnt[(pa - KERNBASE) / PGSIZE]++;
  release(&refcount.lock);
}

void refcount_dec(uint64 pa){
  acquire(&refcount.lock);
  refcount.cnt[(pa - KERNBASE) / PGSIZE]--;
  release(&refcount.lock);
}

int get_cow_saved(void){
  acquire(&refcount.lock);
  int saved = 0;
  for (int i = 0; i < (PHYSTOP - KERNBASE) / PGSIZE; i++){
    if (refcount.cnt[i] > 1)
      saved += (refcount.cnt[i] - 1) * PGSIZE;
  }
  release(&refcount.lock);
  return saved;
}

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  initlock(&refcount.lock, "refcount");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    refcount.cnt[((uint64)p - KERNBASE) / PGSIZE] = 1;
    kfree(p);
  }
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");
  acquire(&refcount.lock);
  int idx = ((uint64)pa - KERNBASE) / PGSIZE;
  if (--refcount.cnt[idx] > 0){
    release(&refcount.lock);
    return;
  }
  release(&refcount.lock);

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  if(r) 
    refcount.cnt[((uint64)r - KERNBASE) / PGSIZE] = 1;
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
