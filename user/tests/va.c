#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int global=1;

int
main (int argc, char *argv[])
{
  printf ("location of code : %p\n", main);
  printf ("location of data : %p\n", &global);
  printf ("location of heap : %p\n", malloc (1));
  int x = 3;
  printf ("location of stack: %p\n\n", &x);
  return 0;
}
