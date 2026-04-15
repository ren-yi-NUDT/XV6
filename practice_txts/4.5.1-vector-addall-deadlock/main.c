#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "common.h"
#include "common_threads.h"
#include "vector.h"

Vector *vec1, *vec2;
    
void *thread1(void *arg) {
  printf("add_all(vec1, vec2)\n");
  vector_add_all(vec1, vec2);
  return NULL;
}

void *thread2(void *arg) {
  printf("add_all(vec2, vec1)\n");
  vector_add_all(vec2, vec1);
  return NULL;
}

// number of elements in fixed-size array
#define NELEM(x) (sizeof(x)/sizeof((x)[0]))
#define THREAD_NUM NELEM(functions)

int main(int argc, char *argv[]) {
  void * (*functions[])(void *) = {
    thread1, thread2
  };
  int i;
  pthread_t t[THREAD_NUM];

  // 创建两个整型Vector
  vec1 = vector_create(sizeof(int), 2);
  vec2 = vector_create(sizeof(int), 3);
    
  // 添加初始数据
  int nums1[] = {1, 2, 3};
  int nums2[] = {4, 5, 6, 7};
    
  for (i = 0; i < 3; i++) {
    vector_add(vec1, &nums1[i]);
  }
    
  for (i = 0; i < 4; i++) {
    vector_add(vec2, &nums2[i]);
  }
    
  printf("initial:\n  vec1: ");
  vector_print_int(vec1);
  printf("  vec2: ");
  vector_print_int(vec2);
  printf("\n");
  
  // 追加
  for(i=0; i<THREAD_NUM; i++)
    Pthread_create(&t[i], NULL, functions[i], NULL);

  void *result;
  for(i=0; i<THREAD_NUM; i++)
    Pthread_join(t[i], &result);

  // 输出结果
  printf("\nresult:\n  vec1: ");
  vector_print_int(vec1);

  printf("  vec2: ");
  vector_print_int(vec2);

  // 清理
  vector_free(vec1);
  vector_free(vec2);
  
  return 0;
}
