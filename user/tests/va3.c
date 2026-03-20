#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main (int argc, char *argv[])
{
  void *p1, *p2, *p3; 
  printf ("location of malloc(0x1000) : %p\n", (p1 = malloc (0x1000)));
  printf ("location of malloc(0x10000) : %p\n", (p2 = malloc (0x10000)));
  free(p2);
  printf ("location of malloc(0x100) : %p\n", (p3 = malloc (0x100)));
  free(p1);
  free(p3);
  return 0;
}
