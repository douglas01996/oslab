#include "game.h"
#include "irq.h"
#include "x86.h"
#include "device/timer.h"
#include "device/palette.h"
#include "pmap.h"
#include "assert.h"
#include "process.h"//
#include "string.h"
#include "x86/memory.h"
#include "jos/env.h"
#include "sem.h"
#include "fs.h"
//#include "process.h"
extern void env_run(struct Env *);
extern void env_run2(struct Env *);
extern struct Env * env_create();
extern void init_segment();
//extern unsigned int loader(pde_t*);
extern unsigned int bootmain2(pde_t*);
extern pde_t entry_pgdir[NPDENTRIES];
extern void env_init();
extern void env_free();
//volatile int tick=0;
void readsect(void *dst,int offset);
void 
timer_event(void);
/*{
	tick++;
}*/
//extern void init_gdt();
//extern void load2();
//void load2(unsigned int eip)
//{
//	return;
/*	struct TrapFrame *tf=(void*)GAME_STACK_ADDR-sizeof(struct TrapFrame);
	
	tf->ds=0x20|0x3;
	tf->es=0x20|0x3;
	tf->eflags=0x246;
	tf->cs=0x18|0x3;
	tf->eip=eip;
	tf->esp=GAME_STACK_ADDR-4;
	tf->ss=0x20|0x3;

	asm volatile("movl %0,%%esp;"
		"popal;"
		"popl %%es;"
		"popl %%ds;"
		"addl $8,%%esp;"
		"iret;"::"r"(tf));	
*/
//}
/*
void load3()
{
	PCB now;
	uint32_t eflags=read_eflags();
	struct TrapFrame *tf=&(now.tf);
	set_tss_esp0((int)now.kstack+4096);
	tf->eip=eip;tf->cs=GDT_ENTRY(1);
	tf->eflags=eflags|FL_IF;tf->ss=GDT_ENTRY(2);
	asm volatile("movl %0,%%esp"::"a"((int)tf));
	asm volatile("popa;"
	"addl %0,%%esp"::"a"(8)
	"mov 24(%esp),%eax\n\t"
	"movl %eax,%ds\n\t"
	"movl %eax,%es\n\t"
	"movl %eax,%fs\n\t"
	"movl %eax,%gs\n\t"
	"iret");
}
*/
extern void i386_init();
extern void cons_init();
void
game_init(void) {
	//mem_init();
	init_segment();
//	init_gdt();
	//mem_init();
	init_serial();
	init_timer();
//printk("the answer should be:\n");
	init_idt();
	init_intr();
//	fcb_init();
	mem_init();
	//fcnt=0;
//printk("the answer should be:\n");
	env_init();
	sem_init();
//	while(1);	
//printk("the answer should be:\n");
	//mem_init();
//	page_init();
//	asm volatile("sti");
//	unsigned int eip=loader();	
//	struct PageInfo *pg=page_alloc(ALLOC_ZERO);
//	uint32_t gm_cr3=(uint32_t)page2pa(pg);
//	pde_t *gm_pgdir=page2kva(pg);
//	memcpy((void*)gm_pgdir,(void*)kern_pgdir,4096);
//	init_game();
	readsect((void*)&super,201+0);
	int nb=super.nblocks;
	printk("nblocks%d\n",nb);
	readsect((void*)dir.entries,201+1+nb);
	printk("%s\n",dir.entries[0].filename);
	dircnt=0;
	int i;
	for(i=0;i<512/sizeof(struct dirent);i++)
		printk("%s\n",dir.entries[i].filename);
	//while(1);
	//while(1);
	//kern_env.file[0].opened=true;
	//kern_env.file[0].offset=0;
	//curenv=&kern_env;
	curdi=&dir;
	curenv->file[0].opened=true;
	curenv->file[0].offset=0;
	curenv->fcnt=0;
//	set_keyboard_intr_handler(keyboard_event);
//	enable_interrupt();	
/*	printk("%%\n");
printk("Printk test begin...\n");
printk("the answer should be:\n");
printk("#######################################################\n");
printk("Hello, welcome to OSlab! I'm the body of the game. ");
printk("Bootblock loads me to the memory position of 0x100000, and Makefile also tells me that I'm at the location of 0x100000. ");
printk("~!@#$^&*()_+`1234567890-=...... ");
printk("Now I will test your printk: ");
printk("1 + 1 = 2, 123 * 456 = 56088\n0, -1, -2147483648, -1412505855, -32768, 102030\n0, ffffffff, 80000000, abcdef01, ffff8000, 18e8e\n");
printk("#######################################################\n");
printk("your answer:\n");
printk("=======================================================\n");
printk("%s %s%scome %co%s", "Hello,", "", "wel", 't', " ");
printk("%c%c%c%c%c! ", 'O', 'S', 'l', 'a', 'b');
printk("I'm the %s of %s. %s 0x%x, %s 0x%x. ", "body", "the game", "Bootblock loads me to the memory position of", 
	0x100000, "and Makefile also tells me that I'm at the location of", 0x100000);
printk("~!@#$^&*()_+`1234567890-=...... ");
printk("Now I will test your printk: ");
printk("%d + %d = %d, %d * %d = %d\n", 1, 1, 1 + 1, 123, 456, 123 * 456);
printk("%d, %d, %d, %d, %d, %d\n", 0, 0xffffffff, 0x80000000, 0xabcedf01, -32768, 102030);
printk("%x, %x, %x, %x, %x, %x\n", 0, 0xffffffff, 0x80000000, 0xabcedf01, -32768, 102030);
printk("=======================================================\n");
printk("Test end!!! Good luck!!!\n");
*/
	//printk("game start!\n");
	//asm volatile("sti");
//	unsigned int eip=loader();	
	//unsigned int eip=bootmain2(kern_pgdir-0xc0000000);
//	((void(*)(void))eip)();	
//	
//	enable_interrupt();
//	main_loop();
	//while(1);
//	load2();
//	env_create();
//	env_free(e);
	set_timer_intr_handler(timer_event);
	//enable_interrupt();
	//asm volatile("sti");
	//env_run(env_create());
	i386_init();
	cons_init();
	env_run(env_create());
	
//	while(1);
//	assert(0);
//	uint32_t tpgdir=(uint32_t)kern_pgdir-0xc0000000;
//	assert(0);
//	asm volatile("movl %0,%%cr3"::"r"(tpgdir));
	//while(1);	
	//assert(0);
//	unsigned int eip=bootmain2((pde_t *)tpgdir);
	//eip=0;
//	printk("im here\n");
//	while(1);	
//	lcr3(gm_cr3);
	//load2(eip);
//	printk("woshishagou\n");	
	//lcr3(gm_cr3);
//	printk("goto%x\n",eip);
//	while(1);	
	
//	((void(*)(void))eip)();	
//	while(1);
//	lcr3(gm_cr3);
//	load3();
//	assert(0); /* main_loop是死循环，永远无法返回这里 */
}
