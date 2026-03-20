#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main (int argc, char *argv[])
{
  char *src = "hello";	//字符串常量（在数据段分配空间） 
  char *dst;
  printf ("location of src  : %p\n", (void *) &src);
  printf ("location of dst  : %p\n", (void *) &dst);
  printf ("location of *src : %p\n", (void *) src);
  printf ("location of *dst : %p\n", (void *) dst);
  strcpy (dst, src);
  return 0;
}
