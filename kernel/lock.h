struct lock {
  struct sleeplock lk;    //内部通过睡眠锁来实现加解锁
  int ref;                //Reference count（引用计数），如果ref为0，表示当前此锁空闲
};
