#include "x86/x86.h"
#include "x86/io.h"
#include "irq.h"
#include "device/video.h"
#define SERIAL_PORT 0x3F8
#include "jos/env.h"
#include "jos/monitor.h"
#include "x86/memory.h"
#include "sem.h"
#include "fs.h"
extern int runcmd(char*,struct Trapframe *);
extern int cputchar(int);
extern void serial_printc(char);
extern int fork2(void*);
extern void thread_exit();
int __attribute__((__noinline__))
syscall(int id,...)
{
	int ret;
	int *args=&id;
	asm volatile("int $0x80":"=a"(ret):"a"(args[0]),"b"(args[1]),"c"(args[2]),"d"(args[3]));
	return ret;
}
static inline int
serial_idle(void){
	return (in_byte(SERIAL_PORT+5)&0x20)!=0;

}
extern void monitor(struct Trapframe *);
extern void mo_read();
extern void mo_run();
extern int tick;
extern int getchar();
//extern bool letter_pressed[26];
//int temp_count=0;
extern void env_sleep(struct Env*e,int sec);
extern void env_exit(struct Env*e);
extern int fork();
extern struct Env* curenv;
void do_syscall(struct TrapFrame *tf){
	char ch;
//	int x,y,color;
	switch(tf->eax)
	{
		case 0:
	//		disable_interrupt();
			set_timer_intr_handler((void*)tf->ebx);
	//		enable_interrupt();
			break;
		case 1:
			ch=tf->ecx;
			while(serial_idle()!=TRUE);
			out_byte(SERIAL_PORT,ch);
			//if(temp_count++>1000)assert(0);
		break;
//		case 2:
//			tf->eax=letter_pressed[tf->ecx];
		
//		break;
		
		case 4:
			set_keyboard_intr_handler((void*)tf->ebx);
			break;
		case 5:
//			asm volatile("sti");
			break;
		case 6:
//			asm volatile("cli");
			break;
		case 7:
			tf->eax=tick;
			break;
		case 8:
			tf->eax=fork();
			break;
		case 9:
			env_sleep(curenv,tf->ebx);
			break;
		case 10:
			env_exit(curenv);
			break;
		case 11:
			tf->eax=sem_open(tf->ebx,tf->ecx,tf->edx);
			break;
		case 12:
			tf->eax=sem_close(tf->ebx);
			break;
		case 13:
			tf->eax=sem_wait(tf->ebx);
			break;
		case 14:
			tf->eax=sem_post(tf->ebx);
			break;
		case 15:
			fork2((void*)tf->ebx);
			break;
		case 16:
			thread_exit();
			break;
		case 17:
			tf->eax=fs_open((char*)tf->ebx);
			break;
		case 18:
			tf->eax=fs_read(tf->ebx,(void*)tf->ecx,tf->edx);
			break;
		case 19:
			tf->eax=fs_write(tf->ebx,(void*)tf->ecx,tf->edx);
			break;
		case 20:
			tf->eax=fs_close(tf->ebx);
			break;
		case 21:
			tf->eax=fs_lseek(tf->ebx,tf->ecx,tf->edx);
			break;
		case 23:
			tf->eax=getchar();
			//printk("here2\n");
			break;
		case 24:
			tf->eax=runcmd((char*)tf->ebx,(struct Trapframe*)tf->ecx);
			break;
		case 22:	
			mo_read();
			break;
		case 25:
			cputchar(tf->ebx);
			break;
		case 26:
			mo_run();
			break;
		case 27:
			while(1) monitor(NULL);
			break;
		default:assert(0);
	}
}
