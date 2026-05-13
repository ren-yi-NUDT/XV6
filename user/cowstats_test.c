//
// tests for copy-on-write fork() assignment.
//

#include "kernel/types.h"
#include "kernel/memlayout.h"
#include "user/user.h"

// allocate more than half of physical memory,
// then fork. this will fail in the default
// kernel, which does not support copy-on-write.

// cowstats_test

void
simpletest()
{
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = (phys_size / 3) * 2;
  
  char *p = sbrk(sz);
  if(p == (char*)0xffffffffffffffffL){
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  for(char *q = p; q < p + sz; q += 4096){
    *(int*)q = getpid();
  }

  int pid = fork();
  if(pid < 0){
    printf("fork() failed\n");
    exit(-1);
  }

  if(pid == 0){
    if(89518080 != cowstats()){
      printf("cowstats() failed: saved_memory should be 89518080 byte(s) instead of %d byte(s)\n", cowstats());
      exit(-1);
    }
    exit(0);
  }

  wait(0);
  if(0 != cowstats()){
    printf("cowstats() failed: saved_memory should be 0 byte(s) instead of %d byte(s)\n", cowstats());
    exit(-1);
  }
  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("simple: ok\n");
}

// three processes all write COW memory.
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void
threetest()
{
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;
  char *q;
  int start, end;

  char *p = sbrk(sz);
  if(p == (char*)0xffffffffffffffffL){
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  pid1 = fork();
  if(pid1 < 0){
    printf("fork failed\n");
    exit(-1);
  }
  if(pid1 == 0){
    pid2 = fork();
    if(pid2 < 0){
      printf("fork failed");
      exit(-1);
    }
    if(pid2 == 0){
      start = 0;
      end = 0;
      start = cowstats();
      // printf("start: %d, cowstats: %d\n", start, cowstats());
      for(q = p; q < p + (sz/5)*4; q += 4096){
        *(int*)q = getpid();
      }
      end = cowstats();
      if ((q - p) != (start - end)){
        printf("cowstats() failed in threetest(pid2).\n");
        exit(-1);
      }
      // printf("start - end: %d\n", start - end);
      // printf("q - p: %d\n", q - p);

      for(q = p; q < p + (sz/5)*4; q += 4096){
        if(*(int*)q != getpid()){
          printf("wrong content\n");
          exit(-1);
        }
      }
      exit(-1);
    }

    wait(0);
    start = 0;
    end = 0;
    start = cowstats();
    for(q = p; q < p + (sz/2); q += 4096){
      *(int*)q = 9999;
    }
    end = cowstats();
    if ((q - p) != (start - end)){
      printf("cowstats() failed in threetest(pid1).\n");
      exit(-1);
    }
    exit(0);
  }

  wait(0);
  if(0 != cowstats()){
    printf("cowstats() failed in threetest(pid0).\n");
    exit(-1);
  }
  for(q = p; q < p + sz; q += 4096){
    *(int*)q = getpid();
  }

  sleep(1);

  for(q = p; q < p + sz; q += 4096){
    if(*(int*)q != getpid()){
      printf("wrong content\n");
      exit(-1);
    }
  }

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("three: ok\n");
}

char junk1[4096];
int fds[2];
char junk2[4096];
char buf[4096];
char junk3[4096];

// test whether copyout() simulates COW faults.
void
filetest()
{
  int start, end;
  buf[0] = 99;

  for(int i = 0; i < 4; i++){
    if(pipe(fds) != 0){
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
    if(pid < 0){
      printf("fork failed\n");
      exit(-1);
    }
    if(pid == 0){
      sleep(1);
      start = 0;
      end = 0;
      start = cowstats();
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
        printf("error: read failed\n");
        exit(1);
      }
      end = cowstats();
      if((start - end) != 4096){
        printf("cowstats() failed in filetest(i).\n");
        exit(-1);
      }

      sleep(1);
      int j = *(int*)buf;
      if(j != i){
        printf("error: read the wrong value\n");
        exit(1);
      }
      exit(0);
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
      printf("error: write failed\n");
      exit(-1);
    }
    wait(0);
  }
  
  if(cowstats() != 0){
    printf("cowstats() failed in filetest.\n");
    exit(-1);
  }

  if(buf[0] != 99){
    printf("error: child overwrote parent\n");
    exit(1);
  }

  printf("file: ok\n");
}

int
main(int argc, char *argv[])
{
  simpletest();

  // check that the first simpletest() freed the physical memory.
  simpletest();


  threetest();
  threetest();
  threetest();

  filetest();

  printf("ALL COW TESTS PASSED\n");

  exit(0);
}
