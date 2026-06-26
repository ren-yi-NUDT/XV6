#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "common.h"
#include "common_threads.h"
#include "vector.h"


// ==================== 基本操作函数 ====================
// 创建Vector
Vector* vector_create(size_t elem_size, size_t initial_capacity) {
    Vector* vec = (Vector*)malloc(sizeof(Vector));
    if (!vec) return NULL;
    
    Mutex_init(&vec->m);
    vec->capacity = (initial_capacity > 0) ? initial_capacity : 4;
    vec->size = 0;
    vec->elem_size = elem_size;
    vec->data = (void**)malloc(vec->capacity * sizeof(void*));
    
    if (!vec->data) {
        free(vec);
        return NULL;
    }
    
    return vec;
}

// 释放Vector
void vector_free(Vector* vec) {
    if (!vec) return;
    
    // 释放所有元素
    for (size_t i = 0; i < vec->size; i++) {
        free(vec->data[i]);
    }
    
    free(vec->data);
    free(vec);
}

// 确保有足够容量
static int vector_ensure_capacity(Vector* vec, size_t min_capacity) {
    if (vec->capacity >= min_capacity) return 1;
    
    size_t new_capacity = vec->capacity * 2;
    if (new_capacity < min_capacity) new_capacity = min_capacity;
    
    void** new_data = (void**)realloc(vec->data, new_capacity * sizeof(void*));
    if (!new_data) return 0;
    
    vec->data = new_data;
    vec->capacity = new_capacity;
    return 1;
}

// 在末尾添加元素
int vector_add(Vector* vec, void* element) {
    if (!vector_ensure_capacity(vec, vec->size + 1)) return 0;
    
    // 分配内存并拷贝元素
    void* new_elem = malloc(vec->elem_size);
    if (!new_elem) return 0;
    
    memcpy(new_elem, element, vec->elem_size);
    vec->data[vec->size++] = new_elem;
    return 1;
}

// 在末尾追加另一个数组的所有元素
int vector_add_all(Vector* dest, Vector* src) {
  int result = 0;

  //-----------------------{  begin to modify
  Mutex_lock(&dest->m);
  Spin(0.01);
  Mutex_lock(&src->m);
  //-----------------------}  end of modification

  if (!dest || !src || dest->elem_size != src->elem_size) goto quit;
  if (src->size == 0) {
    result = 1;
    goto quit; // 源数组为空，直接返回成功
  }
  
  // 确保目标数组有足够容量
  if (!vector_ensure_capacity(dest, dest->size + src->size)) goto quit;
    
  // 逐个拷贝元素
  for (size_t i = 0; i < src->size; i++) {
    void* new_elem = malloc(dest->elem_size);
    if (!new_elem) goto quit; // 内存不足
        
    memcpy(new_elem, src->data[i], dest->elem_size);
    dest->data[dest->size++] = new_elem;
  }
  result = 1;
  
 quit:
  Mutex_unlock(&src->m);
  Mutex_unlock(&dest->m);

  return result;
}

// ==================== 辅助函数 ====================
// 获取元素
static void* vector_get(Vector* vec, size_t index) {
    if (index >= vec->size) return NULL;
    return vec->data[index];
}

// 打印整型Vector
void vector_print_int(Vector* vec) {
    printf("[");
    for (size_t i = 0; i < vec->size; i++) {
        int* val = (int*)vector_get(vec, i);
        printf("%d", *val);
        if (i < vec->size - 1) printf(", ");
    }
    printf("]\n");
}
