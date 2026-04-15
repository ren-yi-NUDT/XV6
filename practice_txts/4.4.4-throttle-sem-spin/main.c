/*
创建多个子进程，每个子进程申请信号量后受保护的程序段。
例如：创建4个子进程、最多2个同时进入受保护程序段：
demo@ali4nudtOS:~/os/practice/4.4.4-throttle-sem-spin$ ./a.out 4 2
parent: begin
child 0: in the critical section
child 1: in the critical section
child 0:   out of the critical section
child 3: in the critical section
child 2: in the critical section
child 1:   out of the critical section
child 3:   out of the critical section
child 2:   out of the critical section
parent: end
*/


#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "common.h"
#include "common_threads.h"
#include "mysem.h"

mysem_t s;

void *child(void *arg) {
  int id = (long)arg;
  mysem_wait(&s);
    
  printf("child %d: in the critical section\n", id);
  sleep(1);

  mysem_post(&s); 
  printf("child %d:   out of the critical section\n", id);

  return NULL;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
	fprintf(stderr, "usage: throttle <num_threads> <sem_value>\n");
	exit(1);
    }
    int num_threads = atoi(argv[1]);
    int sem_value = atoi(argv[2]);
    
    mysem_init(&s, sem_value); 

    printf("parent: begin\n");
    pthread_t c[num_threads];

    long i;
    for (i = 0; i < num_threads; i++) 
	Pthread_create(&c[i], NULL, child, (void *) i);

    for (i = 0; i < num_threads; i++) 
	Pthread_join(c[i], NULL);

    printf("parent: end\n");
    return 0;
}

