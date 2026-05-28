#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/riscv.h"
#include "kernel/memlayout.h"

int g_loopcount = 1000;
int *g_pcounter;
int g_lock;  // 记录一个锁的描述符

void init(){
  g_pcounter = (int *)SHARED_PAGE;
  *g_pcounter = 0;

  g_lock = createlock(); // 创建锁
  if (g_lock < 0) {
    printf("error in createlock()\n");
    exit(1);
  }
}

void *myproc(void *arg) {
  char *name = arg;
  printf("%s: begin\n", name);
  for (int i = 0; i < g_loopcount; i++) {
    lock(g_lock);   // 加锁
    int tmp = *g_pcounter;
    for (int j = 0; j < 10000; j++) {}
    *g_pcounter = tmp + 1; 
    unlock(g_lock); // 解锁
  }
  printf("%s: end\n", name);
  return NULL;
}

int main(int argc, char *argv[]) {
  init();
  printf("main: begin\n [*g_pcounter = %d]\n", *g_pcounter);
  printf("g_pcounter: %p\n", g_pcounter);

  int pid = fork();	
  if (pid == 0) {
    myproc("A");  //子进程会继承父进程的锁
    exit(0); 
  }
  myproc("B");  

  wait(NULL);
  printf("main: end\n [*g_pcounter: %d]\n [ (expected): %d]\n",
         *g_pcounter, g_loopcount * 2);
  closelock(g_lock);  //关闭锁
  return 0;
}
