#ifndef __X86_CPU_H__
#define __X86_CPU_H__

//#include "common.h"

/* 将CPU置入休眠状态直到下次中断到来 */
static inline void
wait_for_interrupt() {
//	asm volatile("int $0x80"::"a"(5));
	asm volatile("hlt");
}

/* 修改IDRT */
static inline void
save_idt(void *addr, uint32_t size) {
	static volatile uint16_t data[3];
	data[0] = size - 1;
	data[1] = (uint32_t)addr;
	data[2] = ((uint32_t)addr) >> 16;
	asm volatile("lidt (%0)" : : "r"(data));
}

/* 打开外部中断 */
static inline void
enable_interrupt(void) {
	asm volatile("int $0x80"::"a"(5));
	//asm volatile("sti");
}

/* 关闭外部中断 */
static inline void
disable_interrupt(void) {
	asm volatile("int $0x80"::"a"(6));
	//asm volatile("cli");
}

#define NR_IRQ    256

#endif
