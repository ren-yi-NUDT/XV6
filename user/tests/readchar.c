#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  char c, count;
  while (1) {
    count = read(0, &c, 1);
    if (count < 1 || c == 0)  // EOF
      break;
    if(c == '\n' || c == '\r')
      continue;
    printf("%c(%d)\n", c, getpid());
  }
  exit(0);
}
