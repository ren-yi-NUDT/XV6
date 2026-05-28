#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "uthread.h"

struct thread all_thread[MAX_THREAD];
struct thread *current_thread;

extern void thread_switch(struct context *old, struct context *new);

void thread_init(void){
    current_thread = &all_thread[0];
    current_thread->state = RUNNING;
}

void thread_create(void (*func)()){
    struct thread *t;
    for (t = all_thread; t < all_thread + MAX_THREAD; t++){
        if (t->state == FREE) break;
    }
    t->state = RUNNABLE;
    t->ctx.ra = (uint64)func;
    t->ctx.sp = (uint64)&t->stack[STACK_SIZE];
}

void thread_yield(void){
    current_thread->state = RUNNABLE;
    thread_schedule();
}

void thread_schedule(void){
    struct thread *t;
    struct thread *next = 0;
    for (t = current_thread + 1; t < all_thread + MAX_THREAD; t++){
        if (t->state == RUNNABLE) {
            next = t;
            break;
        }
    }
    if (!next) {
        for (t = all_thread; t <= current_thread; t++){
            if (t->state == RUNNABLE) {
                next = t;
                break;
            }
        }
    }
    if (!next) {
        if (current_thread->state == RUNNING){
            return;
        }
        printf("thread_schedule: no runnable threads\n");
        exit(-1);
    }
    next->state = RUNNING;
    struct thread *prev_thread = current_thread;
    current_thread = next;
    thread_switch(&prev_thread->ctx, &next->ctx);
}
