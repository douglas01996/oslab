#ifndef __X86_MEMORY_H__
#define __X86_MEMORY_H__

#define DPL_KERNEL              0
#define DPL_USER                3

//#define NR_SEGMENTS             3
#define SEG_KERNEL_CODE         1 
#define SEG_KERNEL_DATA         2

struct GateDescriptor {
	uint32_t offset_15_0      : 16;
	uint32_t segment          : 16;
	uint32_t pad0             : 8;
	uint32_t type             : 4;
	uint32_t system           : 1;
	uint32_t privilege_level  : 2;
	uint32_t present          : 1;
	uint32_t offset_31_16     : 16;
};
/*
struct TrapFrame {
	uint32_t edi, esi, ebp, xxx, ebx, edx, ecx, eax;
	int32_t irq;
	uint32_t error_code,eip,cs,eflags;
};*/

struct TrapFrame {
	uint32_t edi, esi, ebp, esp_;
	uint32_t ebx, edx, ecx, eax;   // Register saved by pushal
	uint16_t es,pad0;   // Segment register
	uint16_t ds,pad1;
	int irq;
	uint32_t err;
	uint32_t eip;
	uint16_t cs;
	uint16_t pad2;
	uint32_t eflags; // Execution state before trap 
	uint32_t esp; 
	uint32_t ss;
	uint32_t pad3;
}__attribute__((packed));
struct Trapframe {
	uint32_t edi, esi, ebp, esp_;
	uint32_t ebx, edx, ecx, eax;   // Register saved by pushal
	uint16_t es,pad0;   // Segment register
	uint16_t ds,pad1;
	int irq;
	uint32_t err;
	uint32_t eip;
	uint16_t cs;
	uint16_t pad2;
	uint32_t eflags; // Execution state before trap 
	uint32_t esp; 
	uint32_t ss;
	uint32_t pad3;
}__attribute__((packed));

#endif
