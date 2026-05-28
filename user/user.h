struct stat;

// system calls
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int*);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int kill(int);
int exec(const char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);
int cstart(void);
int cend(void);
int close(int);

int createlock(void);     //创建锁，返回锁描述符（一个代表该锁的整数）
int closelock(int lock);  //关闭锁lock（lock是创建时得到的锁描述符）
int lock(int lock);       //加锁
int unlock(int lock);     //解锁

int createcond(void);       //创建条件变量，返回条件变量描述符（一个代表该条件变量的整数）
int closecond(int cond);    //关闭条件变量cond（cond是创建时得到的条件变量描述符）
int cond_wait(int cond, int lock);    //在条件变量cond上等待
int cond_signal(int cond);  //唤醒在cond上等待的所有进程

// ulib.c
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void fprintf(int, const char*, ...);
void printf(const char*, ...);
char* gets(char*, int max);
uint strlen(const char*);
void* memset(void*, int, uint);
void* malloc(uint);
void free(void*);
int atoi(const char*);
int memcmp(const void *, const void *, uint);
void *memcpy(void *, const void *, uint);
