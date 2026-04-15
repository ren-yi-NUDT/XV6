
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "common.h"
#include "common_threads.h"
#include "sync.h"


int sum1 = 0, sum2 = 0;

void p1(){
  int tmp = 0;
  for (int i = 1; i <= 100; i++)
    tmp += i;
  sum1 += tmp;
  printf("sum1: %d\n", sum1);
}

void p2(){
  int tmp = 0;
  for (int i = 101; i <= 200; i++)
    tmp += i;
  sum2 += tmp;
  printf("sum2: %d\n", sum2);
}

void p3(){
  printf("sum: %d\n", sum1 + sum2);
}

//------------{  begin to add

//------------}  end to add

void *thread1(void *arg) {
  printf("thread1: begin\n");
  sleep(1);

  p1();

  //------------{  begin to add

  //------------{  end to add

  printf("thread1: end\n");
  return NULL;
}

void *thread2(void *arg) {
  printf("thread2: begin\n");
  sleep(1);

  p2();

  //------------{  begin to add

  //------------}  end to add

  printf("thread2: end\n");
  return NULL;
}

void *thread3(void *arg) {
  printf("thread3: begin\n");

  //------------{  begin to add

  //------------}  end to add

  p3();
    
  printf("thread3: end\n");
  return NULL;
}

// number of elements in fixed-size array
#define NELEM(x) (sizeof(x)/sizeof((x)[0]))
#define THREAD_NUM NELEM(functions)

int main(int argc, char *argv[]) {
  void * (*functions[])(void *) = {
    thread3, thread2, thread1
  };
  int i;
  pthread_t t[THREAD_NUM];

  for(i=0; i<THREAD_NUM; i++)
    Pthread_create(&t[i], NULL, functions[i], NULL);

  void *result;
  for(i=0; i<THREAD_NUM; i++)
    Pthread_join(t[i], &result);
  
  return 0;
}
