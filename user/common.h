#define NULL 0

//自旋ticks个时钟中断周期（约100毫秒）
static inline void spin(long ticks) {
  long t = uptime();
  while ((uptime() - t) < ticks)
    ; // do nothing in loop
}

