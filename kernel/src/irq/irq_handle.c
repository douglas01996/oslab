#include "x86/x86.h"
#include "game.h"
//#include "x86/x86.h"
#include "x86/io.h"
#include "device/video.h"
#include "jos/env.h"

static void (*do_timer)(void);
static void (*do_keyboard)(int);
extern struct Env* curenv;
void
set_timer_intr_handler( void (*ptr)(void) ) {
	do_timer = ptr;
}
void
set_keyboard_intr_handler( void (*ptr)(int) ) {
	do_keyboard = ptr;
}
extern void do_syscall(struct TrapFrame *tf);
/* TrapFrame的定义在include/x86/memory.h
 * 请仔细理解这段程序的含义，这些内容将在后续的实验中被反复使用。 */
extern volatile int tick;
void
irq_handle(struct TrapFrame *tf) {
	curenv->env_tf= *tf;
	//int x,y,color;
	if(tf->irq==14||tf->irq==1014){
	//	return;
	//printk("#14\n");;
	//while(1);
	} else if(tf->irq==13){
	printk("#13\n");
	}else if(tf->irq ==0x80){
		do_syscall(tf);
	} else if (tf->irq == 0x81){
		asm volatile("cld; rep movsl" :: "c"(SCR_SIZE/4),"S"(tf->eax),"D"(vmem));
		//assert(0);
//		x=tf->eax;y=tf->ecx;color=tf->edx;
//		vmem[(x<<8)+(x<<6)+y]=color;
//		printk("2.%d ",y);
	//	if(temp_count++>1000)assert(0);
	
	} else if(tf->irq < 1000) {
		if(tf->irq == -1) {
			printk("%s, %d: Unhandled exception!\n", __FUNCTION__, __LINE__);
		}
		else {
			printk("%s, %d: Unexpected exception #%d!\n", __FUNCTION__, __LINE__, tf->irq);
		}
		assert(0);
	} else if (tf->irq == 1000) {
	//	tick++;
		do_timer();
	} else if (tf->irq == 1001) {
	/*	uint32_t code = in_byte(0x60);
		uint32_t val = in_byte(0x61);
		out_byte(0x61, val | 0x80);
		out_byte(0x61, val);

	//	printk("%s, %d: key code = %x\n", __FUNCTION__, __LINE__, code);
		do_keyboard(code);*/
	} //else if (tf->irq==1014)
//	{;}
	else
	{
//		assert(0);
	}
//	tf=&curenv->env_tf;
//	curenv->env_tf= *tf;
}

