#include <jos/x86.h>
#include <jos/mmu.h>
#include <jos/error.h>
#include <jos/string.h>
#include <jos/assert.h>
#include <jos/elf.h>
#include <jos/env.h>
#include <jos/pmap.h>
#define RELOC(x) ((x)-KERNBASE)
#define ENVGENSHIFT 12
#include <jos/env.h>
#include "x86/cpu.h"
#include "list.h"
#include "system.h"
#include "string.h"
ListHead block,ready;
//#include <kern/pmap.h>
//#include <kern/trap.h>
//#include <kern/monitor.h>

extern void printk(const char*,...);
extern void env_init_percpu(void);
//struct Env ENV[NENV];
struct Env* envs;
struct Env* curenv =NULL;
static struct Env *env_free_list;
void region_alloc(pde_t*,void*,size_t);
struct PageInfo* page_alloc(int);

//

void set_tss();
struct Segdesc gdt[] =
{
	// 0x0 - unused (always faults -- for trapping NULL far pointers)
	[0] = SEG_NULL ,
	//[1 >> 3] = SEG_NULL,//SEG(STA_X | STA_R, 0x0, 0xffffffff, 0),
	//[2 >> 3] = SEG_NULL,//SEG(STA_W, 0x0, 0xffffffff, 0),

	// 0x8 - kernel code segment
	[GD_KT >> 3] = SEG(STA_X | STA_R, 0x0, 0xffffffff, 0),

	// 0x10 - kernel data segment
	[GD_KD >> 3] = SEG(STA_W, 0x0, 0xffffffff, 0),

	// 0x18 - user code segment
	[GD_UT >> 3] = SEG(STA_X | STA_R, 0x0, 0xffffffff, 3),

	// 0x20 - user data segment
	[GD_UD >> 3] = SEG(STA_W, 0x0, 0xffffffff, 3),

	// 0x28 - tss, initialized in trap_init_percpu()
	[GD_TSS0 >> 3] = SEG_NULL
};

struct Pseudodesc gdt_pd = {
	sizeof(gdt) - 1, (unsigned long) gdt
};

void
env_init(){
	//set_tss();	
	//printk("asdf\n");
	printk("%d\n",NENV);
	for(int i=NENV-1;i>=0;i--){	
		envs[i].env_id=0;
		envs[i].env_parent_id=0;
		envs[i].env_type=ENV_TYPE_IDLE;
		envs[i].env_status=0;
		envs[i].env_runs=0;
		envs[i].env_pgdir=NULL;
		envs[i].env_link = env_free_list;
		envs[i].fcnt=0;
		env_free_list = &envs[i];
		//envs[i]
	}
	//envs[NENV-1].env_status=ENV_RUNNABLE;
	curenv=&envs[NENV-1];
	//env_free_list=envs[0].env_link;
	//printk("asdf\n");

	env_init_percpu();
	set_tss();
	printk("%x\n",env_free_list);
	printk("%x\n",envs);
	list_init(&block);
	list_init(&ready);
}


void
env_init_percpu(void)
{
	lgdt(&gdt_pd);
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	asm volatile("movw %%ax,%%gs" :: "a" (GD_UD|3));
	asm volatile("movw %%ax,%%fs" :: "a" (GD_UD|3));
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" :: "a" (GD_KD));
	asm volatile("movw %%ax,%%ds" :: "a" (GD_KD));
	asm volatile("movw %%ax,%%ss" :: "a" (GD_KD));
	// Load the kernel text segment into CS.
	asm volatile("ljmp %0,$1f\n 1:\n" :: "i" (GD_KT));
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	lldt(0);
}

static int
env_setup_vm(struct Env *e)
{

	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
		return -E_NO_MEM;

	// Now, set e->env_pgdir and initialize the page directory.
	//
	// Hint:
	//    - The VA space of all envs is identical above UTOP
	//	(except at UVPT, which we've set below).
	//	See inc/memlayout.h for permissions and layout.
	//	Can you use kern_pgdir as a template?  Hint: Yes.
	//	(Make sure you got the permissions right in Lab 2.)
	//    - The initial VA below UTOP is empty.
	//    - You do not need to make any more calls to page_alloc.
	//    - Note: In general, pp_ref is not maintained for
	//	physical pages mapped only above UTOP, but env_pgdir
	//	is an exception -- you need to increment env_pgdir's
	//	pp_ref for env_free to work correctly.
	//    - The functions in kern/pmap.h are handy.

	// LAB 3: Your code here.

	e->env_pgdir = page2kva(p);
	p->pp_ref++;
	memcpy(e->env_pgdir,kern_pgdir,PGSIZE);
	// UVPT maps the env's own page table read-only.
	// Permissions: kernel R, user R
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;

	return 0;
}
void set_tf(struct Env* e)
{	
	memset(&e->env_tf, 0, sizeof(e->env_tf));
	e->env_tf.ds = GD_UD | 3;
	e->env_tf.es = GD_UD | 3;
	e->env_tf.ss = GD_UD | 3;
	e->env_tf.esp = USTACKTOP;
	e->env_tf.cs = GD_UT | 3;
	e->env_tf.eflags=0x202;
	//e->env_tf.eflags=0x0;
}


int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
	int32_t generation;
	int r;
	struct Env *e;
	if (!(e = env_free_list)) return -E_NO_FREE_ENV;
	if ((r = env_setup_vm(e)) < 0)	return r;
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
	if (generation <= 0)	// Don't create a negative env_id.
		generation = 1 << ENVGENSHIFT;
	e->env_id = generation | (e - envs);
	e->env_parent_id = parent_id;
	e->env_type = ENV_TYPE_USER;
	e->env_status = ENV_RUNNABLE;
	e->env_runs = 0;
	set_tf(e);
	// You will set e->env_tf.tf_eip later.

	// commit the allocation
	env_free_list = e->env_link;
	*newenv_store = e;
//	printk("hahahahahahahahahahaha\n");
//	printk("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
}


uint32_t bootmain2(pde_t* pgdir);
uint32_t bootmain(pde_t* pgdir,int);
void region_alloc(pde_t*,void*,size_t);

void
env_pop_tf(struct TrapFrame *tf)
{
//	printk("really?\n");
	asm volatile("movl %0,%%esp\n"
		"\tpopal\n"
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "r" (tf) : "memory");
	//panic("iret failed");  /* mostly to placate the compiler */
	//printk("iret fail\n");
	while(1);
}

static void
load_icode(struct Env *e,int fd)
{
	lcr3(PADDR(e->env_pgdir));
	e->env_tf.eip=bootmain(e->env_pgdir,fd);
	lcr3(PADDR(kern_pgdir));
}
struct Env* 
env_create(int fd)
{
	struct Env* env;
	env_alloc(&env,0);
	load_icode(env,fd);
	return env;
}
void 
env_run(struct Env *e)
{
	if(curenv && curenv->env_status==ENV_RUNNING)
		curenv->env_status=ENV_RUNNABLE;
//	printk("running\n");
	if(curenv!=e)
	{
//		printk("swich\n");
//		printk("%x\n",e->env_tf.eip);
		curenv = e;
		//curenv->env_tf.eip=0x804824b;
		//printk("%x\n",curenv->env_tf.eip);
		e->env_status=ENV_RUNNING;
		e->env_runs++;
	//	set_tss();
		lcr3(PADDR(e->env_pgdir));
	}
	else
		curenv=e,curenv->env_status=ENV_RUNNING;
		//printk("afff%x\n",curenv->env_tf.eip);
	env_pop_tf(&e->env_tf);
}
void 
env_run2(struct Env *e)
{
	if(curenv && curenv->env_status==ENV_RUNNING)
		curenv->env_status=ENV_RUNNABLE;
//	printk("running\n");
	if(curenv!=e)
	{
//		printk("swich\n");
//		printk("%x\n",e->env_tf.eip);
		curenv = e;
		//curenv->env_tf.eip=0x804824b;
		//printk("%x\n",curenv->env_tf.eip);
		e->env_status=ENV_RUNNING;
		e->env_runs++;
	//	set_tss();
		lcr3(PADDR(e->env_pgdir));
	}
	else
		curenv=e,curenv->env_status=ENV_RUNNING;
	//printk("%x\n",curenv->env_tf.eip);
	((void(*)(void))curenv->env_tf.eip)();
	//printk("%x\n",curenv->env_tf.eip);
	env_pop_tf(&e->env_tf);
}
static struct Taskstate ts;
extern char bootstacktop[];
extern char bootstack[];
void set_tss()
{
	ts.ts_esp0 =(uint32_t) (bootstacktop);
	ts.ts_ss0 = GD_KD;
	gdt[GD_TSS0 >> 3] = (struct Segdesc)SEG16(STS_T32A,(uint32_t) (&ts),sizeof(struct Taskstate), 0);
	gdt[GD_TSS0 >> 3].sd_s = 0;
	ltr(GD_TSS0);
}


	
void
env_free(struct Env *e)
{
	pte_t *pt;
	uint32_t pdeno, pteno;
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
		lcr3(PADDR(kern_pgdir));

	// Note the environment's demise.
	printk("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
		if(!(e->env_pgdir[pdeno] & PTE_P)||(kern_pgdir[pdeno]&PTE_P))
			continue;
		// only look at mapped page tables
//		if (!(e->env_pgdir[pdeno] & PTE_P))
//			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
		page_decref(pa2page(pa));
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
	e->env_pgdir = 0;
	page_decref(pa2page(pa));

	// return the environment to the free list
	e->env_status = ENV_FREE;
	e->env_link = env_free_list;
	env_free_list = e;
}

int fork()
{
//	printk("fork start\n");
//	printk("%d\n",curenv->env_parent_id);
	envid_t parent_id=curenv->env_id;
	struct Env *e=NULL;
	int flag=env_alloc(&e,parent_id);
	if(flag!=0)
	{
		printk("flag=0\n");
		while(1);
		//assert(0);
	}
	int i,j;
	for(i=0;i<1024;i++)
	{
		if(!(e->env_pgdir[i]&PTE_P) && (curenv->env_pgdir[i]&PTE_P))
		{
			pte_t *pte=(pte_t*)page2kva(pa2page(curenv->env_pgdir[i]));
			for(j=0;j<1024;j++)
			{
				if(pte[j])
				{
					struct PageInfo *pp=page_alloc(1);
					page_insert(e->env_pgdir,pp,(void*)((i<<22)|(j<<12)),PTE_U|PTE_W);
				//	printk("%x\n",pp);
					memcpy((void *)page2kva(pp),(void *)page2kva(pa2page(pte[j])),4096);
				}
			}
		}
	}
	e->env_tf=curenv->env_tf;
//	printk("%x\n",curenv->env_tf.eip);
//	printk("%d\n",curenv->env_id);
	e->env_tf.eax=0;
/*	for(i=0;i<NENV;i++)
		if(envs[i].env_status==ENV_RUNNING) printk("%d ",i);
	printk("\n");
	for(i=0;i<NENV;i++)
		if(envs[i].env_status==ENV_RUNNABLE) printk("%d ",i);
	printk("\n");
*/
//	printk("fork end\n");
	return e->env_id;
}

struct Env* seek_next()
{
//	return NULL;
//	if(curenv==NULL) return NULL;
	struct Env* e;
	e=curenv;
//	if(curenv->env_status==ENV_RUNNING)
//		curenv->env_status=ENV_RUNNABLE;
	//struct Env* temp=NULL;
	int i;
	for(i=0;i<=NENV+1;i++)
	{
		//if(e->env_id==0) continue
		if(e==&envs[NENV-1])
		//if(e-envs==NENV-1)
			e=envs;
		else
			e++;
		if(e==curenv) continue;
//		if(e->env_id==0) continue;
	//	if(e->env_status==ENV_SLEEP)
	//		e->sleep_time--;
	//	if(e->sleep_time==0)
	//		e->env_status=ENV_RUNNABLE;
		if(e->env_status==ENV_RUNNABLE)
		//	if(temp==NULL)temp=e;
			return e;
	}
//	if(temp==NULL) return curenv;
	return NULL;
}
void env_sleep(struct Env *e,int sec)
{
	e->env_status=ENV_SLEEP;	
	e->sleep_time=sec;
	struct Env* next=seek_next();
	if(next!=NULL) env_run(next);	
	else
	{

		printk("nothing more to do\n");
		while(1);
	}

}

void env_exit(struct Env*e)
{
	env_free(e);
	
	struct Env* next=seek_next();
	if(next==NULL)
	{
		printk("nothing more to do\n");
		while(1);
	}
	else
	{
		printk("env_exit\n");
		printk("%d\n",e->env_id);	
		printk("%d\n",next->env_id);
		if(next!=NULL)env_run(next);
	}
}
extern void i386_init();
extern void monitor();
volatile int tick=0;
#define INTERVAL 10
extern int kbd_proc_data();
/*void timer_event()
{
	//printk("1\n");
	tick++;
}*/
void 
timer_event(void)
{
	//while(1);
	tick++;
	int i;
	int flag=0;
	kbd_proc_data();	
	for(i=0;i<NENV-1;i++)
	{
		struct Env*e=&envs[i];
		if(e->env_status==ENV_RUNNING||e->env_status==ENV_RUNNABLE)
			flag=1;
		if(e->env_status==ENV_SLEEP)
		{
			flag=1;
			e->sleep_time--;
		//	printk("here\n");
		//	while(1);
			if(e->sleep_time==0)
			e->env_status=ENV_RUNNABLE;
		}
	}
	//printk("timer event\n");
	if(tick%INTERVAL)
	//if(1)
	{
		struct Env* e=seek_next();
	//printk("im not here\n");
//	printk("%d %d\n",e->env_id,curenv->env_id);
		if(/*e==&envs[NENV-1] && e!=curenv&& */flag==0)
		{
			curenv=&envs[NENV-1];
			monitor(NULL);	
			//printk("1\n");
		}
		else if(e!=NULL && e!=curenv&& e!=&envs[NENV-1]) {env_run(e);}
	}
//	else printk("null\n");
/*	if(tick==1000) 
	{
	//	env_exit(curenv);
	//	printk("fork\n");
	}
*/	//if(e!=NULL) env_run(e);
	if(!flag)
	{
			curenv=&envs[NENV-1];
			monitor(NULL);	
		//printk("nothing more to do\n");
	//	while(1);
	}
}
int 
envid2index(int envid)
{
	int i=0;
	for(i=0;i<NENV;i++)
		if(envs[i].env_id==envid) return i;
	return -1;
}
int fork2(void *thread)
{
	envid_t parent_id=curenv->env_id;
	struct Env *e=NULL;
	int flag=env_alloc(&e,parent_id);
	if(flag!=0)
	{
		printk("flag=0\n");
		while(1);
	}
	int i;
	for(i=0;i<1024;i++)
		e->env_pgdir[i]=curenv->env_pgdir[i];
	int id=envid2index(parent_id);	
	e->env_type=ENV_TYPE_THREAD;
	e->env_tf.esp=envs[id].env_tf.esp-PGSIZE*(++envs[id].thread_num);
	e->env_tf.eip=(uint32_t)thread;
	return e->env_id;
}
extern void monitor(struct Trapframe *tf);
void thread_exit()
{
	//uint32_t pa=PADDR(curenv->env_pgdir);
	//curenv->env_pgdir=0;
	//page_decref(pa2page(pa));
	curenv->env_status=ENV_FREE;
	//curenv->env_status=ENV_NOT_RUNNABLE;
	//curenv->env_link=env_free_list;
	//envs[curenv->env_parent_id].thread_num--;
	//env_free_list=curenv;
	monitor(NULL);
}

