//#include "irq.h"
//#include "x86/x86.h"
int fork();
void sleep(int sec);
void exit();
int fork2();
void thread_exit();
int thread_create(void *a);
//int __attribute__((__noinline__)) syscall(int id, ...);
//void write_vmem(int,int,int);
//void serial_out(char);

//enum callTypes{SYS_write_vmem=10,SYS_serial};
//void do_syscall(struct TrapFrame *tf);
