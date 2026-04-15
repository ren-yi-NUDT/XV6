#ifndef __vector_h__
#define __vector_h__

#include <pthread.h>

// 动态数组（Vector）结构定义
typedef struct {
  void** data;        // 存储元素的数组（存储的是指针）
  size_t size;        // 当前元素数量
  size_t capacity;    // 当前容量
  size_t elem_size;   // 每个元素的大小（字节）
  pthread_mutex_t m;  // 锁，保护本结构
} Vector;

Vector* vector_create(size_t elem_size, size_t initial_capacity);
void vector_free(Vector* vec);
int vector_add(Vector* vec, void* element);
int vector_add_all(Vector* dest, Vector* src);
void vector_print_int(Vector* vec);

#endif // __vector_h__
