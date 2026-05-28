#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "semaphore.h"

//若初始化成功返回0，否则返回非0
int sem_init(struct sem *s, int value) {
  static int initialized = 0;
  if (1 == initialized)
    return -1;
  initialized = 1;

  s->value = value;
  s->lock = createlock();
  if (s->lock < 0) {
    printf("error in createlock()\n");
    return 1;
  }
  s->cond = createcond();
  if (s->cond < 0) {
    printf("error in createcond()\n");
    closelock(s->lock);
    return 2;
  }
  return 0;
}

void sem_wait(struct sem *s) {
  lock(s->lock);
  while(s->value <= 0) {
    cond_wait(s->cond, s->lock);
  }
  s->value--;
  unlock(s->lock);
}

void sem_post(struct sem *s) {
  lock(s->lock);
  s->value++;
  cond_signal(s->cond);
  unlock(s->lock);
}
