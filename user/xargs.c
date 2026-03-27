#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    char buf[512];      
    int buf_pos = 0;    
    char ch;
    if (argc < 2) {
        fprintf(2, "Usage: xargs command [args...]\n");
        exit(1);
    }

    while (read(0, &ch, 1) > 0) {
        if (ch == '\n') {

            buf[buf_pos] = '\0';  
    
            char *new_argv[argc + 2];  
            for (int i = 1; i < argc; i++) {
                new_argv[i - 1] = argv[i];
            }
            new_argv[argc - 1] = buf;    
            new_argv[argc] = 0;         

            if (fork() == 0) {
                exec(new_argv[0], new_argv);
                fprintf(2, "exec failed\n");
                exit(1);
            }
            wait(0);
            
            buf_pos = 0;  
        } else {
            buf[buf_pos++] = ch;
        }
    }

    exit(0);
}