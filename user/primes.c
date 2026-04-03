#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


void primes(int p[2]){
    int base;
    if(read(p[0], &base, sizeof(int)) <= 0){
        close(p[0]);
        exit(0);
    }
    printf("prime %d\n", base);

    int next[2];
    pipe(next);

    int n;
    while (read(p[0], &n, sizeof(int)) > 0){
        if (n % base != 0){
            write(next[1], &n, sizeof(int));
        }
    }

    close(p[0]);
    close(next[1]);

    int pid = fork();
    if (pid < 0){
        fprintf(2, "fork failed\n");
        exit(1);
    }
    else if (pid == 0){
        primes(next);
    }
    else{
        close(next[0]);
        wait(0);
    }
}

int main(int argc, char *argv[]){
    int p[2];
    pipe(p);

    if (argc != 2){
        for (int i = 2; i <= 35; i++){
            write(p[1], &i, sizeof(int));
        }
    }
    else{
        int upperLimit = atoi(argv[1]);
        for (int i = 2; i <= upperLimit; i++){
            write(p[1], &i, sizeof(int));
        }
    }

    
    close(p[1]);

    int pid = fork();
    if (pid < 0){
        fprintf(2, "fork failed\n");
        exit(1);
    }
    else if (pid == 0){
        primes(p);
    }
    else{
        close(p[0]);
        wait(0);
    }
    exit(0);
}