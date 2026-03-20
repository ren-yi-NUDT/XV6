#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define SLEEPTIME 20

int main(int argc, char *argv[]){
    if (argc != 2){
        sleep(SLEEPTIME);
    }
    else {
        int tick = atoi(argv[1]) * 10;
        sleep(tick);
    }
    exit(0);
}