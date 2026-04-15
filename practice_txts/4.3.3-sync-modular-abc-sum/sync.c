#include "common_threads.h"
#include "sync.h"

void sync_init(synchronizer_t *s) {
    s->done = 0;
    Mutex_init(&s->m);
    Cond_init(&s->c);
}

void sync_signal(synchronizer_t *s) {
    Mutex_lock(&s->m);
    s->done = 1;
    Cond_signal(&s->c);
    Mutex_unlock(&s->m);
}

void sync_wait(synchronizer_t *s) {
    Mutex_lock(&s->m);
    while (s->done == 0) 
	Cond_wait(&s->c, &s->m); 
    s->done = 0; // reset for next use
    Mutex_unlock(&s->m);
}

