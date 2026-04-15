#ifndef __sync_h__
#define __sync_h__

#include <pthread.h>

//
// Simple sync "object"
//

typedef struct {
    pthread_cond_t c;
    pthread_mutex_t m;
    int done;
} synchronizer_t;

void sync_init(synchronizer_t *s);
void sync_signal(synchronizer_t *s);
void sync_wait(synchronizer_t *s);

#endif // __sync_h__
