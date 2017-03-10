#include "mmu.h"
#include "string.h"
#include "x86.h"
#include "mmu2.h"
#include "common.h"
/* One TSS will be enough for all processes in ring 3. It will be used in Lab3. */
static TSS tss; 


inline static void
set_tss(SegDesc *ptr) {
	tss.ss0 = SELECTOR_KERNEL(SEG_KERNEL_DATA);		// only one ring 0 stack segment

	uint32_t base = (uint32_t)&tss;
	uint32_t limit = sizeof(TSS) - 1;
	ptr->limit_15_0  = limit & 0xffff;
	ptr->base_15_0   = base & 0xffff;
	ptr->base_23_16  = (base >> 16) & 0xff;
	ptr->type = STS_T32A;
	ptr->segment_type = 0;
	ptr->privilege_level = DPL_USER;
	ptr->present = 1;
	ptr->limit_19_16 = limit >> 16;
	ptr->soft_use = 0;
	ptr->operation_size = 0;
	ptr->pad0 = 1;
	ptr->granularity = 0;
	ptr->base_31_24  = base >> 24;
}



/* GDT in the kernel's memory, whose virtual memory is greater than 0xC0000000. */
static SegDesc gdt[512];

static void
set_segment(SegDesc *ptr, uint32_t pl, uint32_t type) {
	ptr->limit_15_0  = 0xFFFF;
	ptr->base_15_0   = 0x0;
	ptr->base_23_16  = 0x0;
	ptr->type = type;
	ptr->segment_type = 1;
	ptr->privilege_level = pl;
	ptr->present = 1;
	ptr->limit_19_16 = 0xF;
	ptr->soft_use = 0;
	ptr->operation_size = 0;
	ptr->pad0 = 1;
	ptr->granularity = 1;
	ptr->base_31_24  = 0x0;
}


static inline void write_gdt(void* addr,uint32_t size)
{
	static volatile uint16_t data[3];
	data[0]=size-1;
	data[1]=(uint32_t)addr;
	data[2]=((uint32_t)addr)>>16;
	asm volatile("lgdt (%0)"::"r"(data));
}
static inline void set_tss_ss0(uint32_t esp)
{
	tss.esp0=esp;
}

void
init_segment(void) {
	memset(gdt, 0, sizeof(gdt));
	set_segment(&gdt[SEG_KERNEL_CODE], DPL_KERNEL, SEG_EXECUTABLE | SEG_READABLE);
	set_segment(&gdt[SEG_KERNEL_DATA], DPL_KERNEL, SEG_WRITABLE );
//printk("woshigou\n");
	set_segment(&gdt[SEG_USER_CODE], DPL_USER, SEG_EXECUTABLE | SEG_READABLE);
	set_segment(&gdt[SEG_USER_DATA], DPL_USER, SEG_WRITABLE );
	
	write_gdt(gdt, sizeof(gdt));

	set_tss(&gdt[SEG_TSS]);
//	set_tss_ss0(SELECTOR_KERNEL(SEG_KERNEL_DATA));
//	while(SELECTOR_USER(SEG_TSS)==0x1b);
	ltr( SELECTOR_USER(SEG_TSS) );
}

