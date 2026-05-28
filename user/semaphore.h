struct sem {
  int value;
  int cond;  //条件变量描述符
  int lock;  //锁描述符
};

int sem_init(struct sem *s, int value);
void sem_wait(struct sem *s);
void sem_post(struct sem *s);
