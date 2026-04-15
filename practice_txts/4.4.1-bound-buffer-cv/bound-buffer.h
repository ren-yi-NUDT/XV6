#ifndef __bound_buffer_h__
#define __bound_buffer_h__

#include <semaphore.h>

typedef struct __node_t {
  int value;
  int id;  //Producer No.
} node_t;

#define NODE_NUM 10
typedef struct __buffer_t {
  node_t nodes[NODE_NUM];
  int readp, writep;
  //----------------------------start to add

  pthread_mutex_t mutex;
  
  //----------------------------end
} buffer_t;

void INIT(buffer_t *b);
void PUT(buffer_t *b, node_t n);
node_t GET(buffer_t *b);

#endif // __bound_buffer_h__
