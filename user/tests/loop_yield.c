#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void main(int argc, char *argv[])
{
    for(int i=0; i<200; i++)
        yield();
}
