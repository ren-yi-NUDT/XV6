#ifndef __mysem_h__
#define __mysem_h__

#include <pthread.h>

typedef struct _mysem_t {
    int value;
    pthread_mutex_t lock;
} mysem_t;

void mysem_init(mysem_t *s, int value);
void mysem_wait(mysem_t *s);
void mysem_post(mysem_t *s);

#endif // __mysem_h__
