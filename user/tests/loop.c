#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int counter = 1;

void main(int argc, char *argv[])
{
  while(1)
    counter++;
}
