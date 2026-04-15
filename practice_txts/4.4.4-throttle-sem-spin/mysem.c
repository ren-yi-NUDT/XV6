#include "common_threads.h"
#include "mysem.h"

void mysem_init(mysem_t *s, int value) {
  s->value = value;
  Mutex_init(&s->lock);
}

void mysem_wait(mysem_t *s) {
  Mutex_lock(&s->lock);
  //----------------------{ begin to modify
  while (s->value <= 0)
    ;
  s->value--;
  //----------------------} end
  Mutex_unlock(&s->lock);
}

void mysem_post(mysem_t *s) {
  Mutex_lock(&s->lock);
  s->value++;
  Mutex_unlock(&s->lock);
}

