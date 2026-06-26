#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include "common.h"
#include "common_threads.h"

pthread_cond_t  c = PTHREAD_COND_INITIALIZER;
pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;
int done = 0;

void A() {
  printf("a()\n");
}

void B() {
  printf("b()\n");
}

void C() {
  printf("c()\n");
}

void *thread1(void *arg) {
  printf("thread1: begin\n");
  sleep(1);
  A();

  //------------{  begin to add

  
  //------------}  end to add
    
  printf("thread1: end\n");
  return NULL;
}

void *thread2(void *arg) {
  printf("thread2: begin\n");
  sleep(1);
  B();
    
  //------------{  begin to add

  
  //------------}  end to add
    
  printf("thread2: end\n");
  return NULL;
}

void *thread3(void *arg) {
  printf("thread3: begin\n");

  //------------{  begin to add

  
  //------------}  end to add
    
  C();    
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

