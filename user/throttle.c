#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/riscv.h"
#include "kernel/memlayout.h"
#include "semaphore.h"

struct sem *s;

void child(int id) {
  sem_wait(s);
  printf("child %d: start\n", id);
  sleep(10);
  printf("child %d:      end\n", id);
  sem_post(s);
}

void main(int argc, char *argv[]) {
  if (argc != 3) {
    fprintf(2, "usage: throttle <num_threads> <sem_value>\n");
    exit(1);
  }
  s = (struct sem *)SHARED_PAGE;
  int num_threads = atoi(argv[1]);
  int sem_value = atoi(argv[2]);
  sem_init(s, sem_value);

  printf("parent: begin\n");
  for (int i = 0; i < num_threads; i++) {
    if (fork() == 0) {
      child(i); // 子进程继承父进程的锁和条件变量
      exit(0);
    }
  }
  for (int i = 0; i < num_threads; i++)
    wait(NULL);
  printf("parent: end\n");
  exit(0);
}
