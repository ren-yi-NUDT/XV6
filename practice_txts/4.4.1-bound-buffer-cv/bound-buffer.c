#include "bound-buffer.h"
#include "common.h"
#include "common_threads.h"
#include <semaphore.h>
#include <stdlib.h>

#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

void put(buffer_t *b, node_t n) {
  b->nodes[b->writep] = n;
  Spin(0.001);  // delay for a while
  b->writep = (b->writep + 1) % NODE_NUM;
}

node_t get(buffer_t *b) {
  node_t tmp = b->nodes[b->readp];
  Spin(0.001);  // delay for a while
  b->readp = (b->readp + 1) % NODE_NUM;
  return tmp;
}

void INIT(buffer_t *b) {
  for (int i=0; i<NODE_NUM; i++) {
    b->nodes[i].value = 0;
    b->nodes[i].id = 0;
  }
  b->readp = b->writep = 0;
  //----------------------------start to add

  Pthread_mutex_init(&b->mutex);
  
  //----------------------------end
}

void PUT(buffer_t *b, node_t n) {
  //----------------------------start to add
  Pthread_mutex_lock(&b->mutex);
  
  put(b, n);

  Pthread_mutex_unlock(&b->mutex);
  //----------------------------end
}

node_t GET(buffer_t *b) {
  //----------------------------start to add
  Pthread_mutex_lock(&b->mutex);

  node_t result = get(b);

  Pthread_mutex_unlock(&b->mutex);
  //----------------------------end
  return result;
}
