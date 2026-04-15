/* 
功能：创建2个生产者线程和2个消费者线程。
本程序包含1个整型参数，指定每个生产者线程向缓冲区中增加的节点数量。
运行画面类似如下：
```
demo@ali4nudtOS:~/bound-buffer$ ./a.out 2
main: begin
Producer 1: begin
Producer 2: begin
Consumer 1: begin
Consumer 2: begin
Consumer 1: get 1 from Producer 1
Consumer 2: get 1 from Producer 2
Consumer 1: get 2 from Producer 1
Producer 1: done
Consumer 2: get 2 from Producer 2
Producer 2: done
Consumer 1: get -1 from Producer 1
Consumer 1: done
Consumer 2: get -1 from Producer 2
Consumer 2: done
main: done
```
*/
#include <pthread.h>
#include <stdio.h>

#include "common.h"
#include "common_threads.h"
#include "bound-buffer.h"

pthread_mutex_t g_printf_mutex;
int max;
buffer_t q; // shared global variable

void *produce(void *arg) {
  int id = (long)arg;
  node_t tmp;
  tmp.id = id;
  printf("Producer %d: begin\n", id);
  
  for (int i = 1; i <= max; i++) {
    tmp.value = i;
    PUT(&q, tmp);
    usleep_random(2);
  }
  tmp.value = -1;
  PUT(&q, tmp); // end of producing

  printf("Producer %d: done\n", id);
  return NULL;
}

void *consume(void *arg) {
  int id = (long)arg;
  node_t tmp;
  myprintf((id-1)*30, "Consumer %d: begin\n", id);

  do {
    tmp = GET(&q);
    myprintf((id-1)*30, "Cons. %d: get %d from Prod. %d\n", id, tmp.value, tmp.id);
    usleep_random(2);
  } while (tmp.value != -1); 

  myprintf((id-1)*30, "Consumer %d: done\n", id);
  return NULL;
}

#define PRODUCER_NUM 2
#define CONSUMER_NUM PRODUCER_NUM

int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "usage: a.out <loopcount>\n");
    exit(1);
  }
  srand((int)time(0));
  max = atoi(argv[1]);
  INIT(&q);

  int i;
  pthread_t p[PRODUCER_NUM], c[CONSUMER_NUM];

  printf("main: begin\n");
  for(i=0; i<CONSUMER_NUM; i++)
    Pthread_create(&c[i], NULL, consume, (void *)(long)i+1);

  for(i=0; i<PRODUCER_NUM; i++)
    Pthread_create(&p[i], NULL, produce, (void *)(long)i+1);

  void *result;
  for(i=0; i<CONSUMER_NUM; i++)
    Pthread_join(c[i], &result);

  for(i=0; i<PRODUCER_NUM; i++)
    Pthread_join(p[i], &result);

  printf("main: done\n");
  return 0;
}
