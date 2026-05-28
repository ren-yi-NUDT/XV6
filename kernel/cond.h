struct cond {
  int ref;                // Reference count，如果ref为0，表示当前此条件变量空闲
};
