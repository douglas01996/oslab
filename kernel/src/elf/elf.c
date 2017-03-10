/* start.S的主要功能是切换在实模式工作的处理器到32位保护模式。为此需要设置正确的
 * GDT、段寄存器和CR0寄存器。C语言代码的主要工作是将磁盘上的内容装载到内存中去。
 * 磁盘镜像的结构如下：
	 +-----------+------------------.        .-----------------+
	 |   引导块   |  游戏二进制代码       ...        (ELF格式)     |
	 +-----------+------------------`        '-----------------+
 * C代码将游戏文件整个加载到物理内存0x100000的位置，然后跳转到游戏的入口执行。 */

#include "boot.h"
#include "game.h"
//#include "stdio.h"
#include "string.h"
#include "pmap.h"
#include "fs.h"
#include "mmu.h"
#define SECTSIZE 512
#define PT_LOAD 1
void readseg(unsigned char *, int, int);
void region_alloc(pde_t* pgdir,void *va,size_t len);
//extern void printk();
unsigned int
bootmain2(pde_t* pgdir) {
	struct ELFHeader *elf;
	struct ProgramHeader *ph;
//	unsigned char* pa;
//	file_init();
	//uint8_t buf[4096];
	//	printk("ad22sf\n");
	/* 因为引导扇区只有512字节，我们设置了堆栈从0x8000向下生长。
	 * 我们需要一块连续的空间来容纳ELF文件头，因此选定了0x8000。 */
	//elf = (struct ELFHeader*)0x8000;
	elf = (struct ELFHeader*)0x8000;
	//elf = (struct ELFHeader*)buf;

	/* 读入ELF文件头 */
	//readseg((unsigned char*)buf, 4096, 0);
//	while(1);
	//int fd=fs_open("game.bin");
	int fd=fs_open("game.bin");
//	while(1);
	//printk("%d\n",fd);
	fs_read(fd,(void*)elf,4096);
	fs_rewind(fd);
//	printk("ad33sf\n");
	////elf = (struct ELFHeader*)buf;
		//printk("adsf\n");
	//printk("%d\n",*(unsigned*)elf);
	if(*(unsigned*)elf!=0x464c457f) 
	{
		printk("elf error\n");
		while(1);
	}
	/* 把每个program segement依次读入内存 */
//	ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
	//eph = ph + elf->phnum;
	int i;
	for(i=0; i<elf->phnum; i ++) {
	//	printk("adsf\n");
		ph=(void*)elf+elf->phoff+i*elf->phentsize;
		///pa = (unsigned char*)ph->paddr; /* 获取物理地址 */
		//readseg(pa, ph->filesz, ph->off); /* 读入数据 */
		//for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
		if(ph->type==PT_LOAD)
		{
			region_alloc(pgdir,(void*)ph->vaddr,ph->memsz);
	//	printk("adsf1\n");
			fs_lseek(fd,ph->off,SEEK_SET);
			fs_read(fd,(void*)ph->vaddr,ph->filesz);	
		//readseg((unsigned char *)ph->vaddr,ph->filesz,ph->off);
	//	printk("adsf2\n");
			memset((void*)(ph->vaddr+ph->filesz),0,ph->memsz-ph->filesz);
	//	printk("adsf3\n");
			/*uint32_t va=ph->vaddr;
			uint32_t data_loaded=0;
			while(va<ph->vaddr+ph->memsz)
			{
				uint32_t offset=PGOFF(va);
				va=va&0xfffff000;
				struct PageInfo *pp=page_alloc(ALLOC_ZERO);
				page_insert(pgdir,pp,(void*)va,PTE_U|PTE_W);
				memset(buf,0,4096);
				uint32_t n=4096-offset;
				if((ph->filesz-data_loaded)<n)	n=ph->filesz-data_loaded;
				if(n!=0)readseg((void*)(buf+offset),n,ph->off+data_loaded);
				memcpy((void*)page2kva(pp),buf,4096);
				va+=4096;
				data_loaded+=n;
			}*/
		//	unsigned char*temp=(unsigned char*)va;
		//	for(;temp<(unsigned char *)ph->vaddr+ph->memsz;*temp++=0);
		}
	}
	region_alloc(pgdir,(void*)(USTACKTOP-8*4096),8*4096);
	region_alloc(pgdir,(void*)(USTACKTOP),8*4096);
	
/*
	uint32_t va;
	for(va=GAME_STACK_ADDR-GAME_STACK_SIZE;va<GAME_STACK_ADDR;va+=4096)
	{
		struct PageInfo* pp=page_alloc(1);
		page_insert(pgdir,pp,(void*)va,PTE_U|PTE_W);
		memset(page2kva(pp),0,4096);
	}*/
	//printk("woshigou\n");	
	volatile uint32_t entry=elf->entry;
	//printk("%x\n",entry);
	//	while(1);
	return entry;
}

void
waitdisk(void) {
	while((in_byte(0x1F7) & 0xC0) != 0x40); /* 等待磁盘完毕 */
}

/* 读磁盘的一个扇区 */
void
readsect(void *dst, int offset) {
	int i;
	waitdisk();
	out_byte(0x1F2, 1);
	out_byte(0x1F3, offset);
	out_byte(0x1F4, offset >> 8);
	out_byte(0x1F5, offset >> 16);
	out_byte(0x1F6, (offset >> 24) | 0xE0);
	out_byte(0x1F7, 0x20);

	waitdisk();
	for (i = 0; i < SECTSIZE / 4; i ++) {
		((int *)dst)[i] = in_long(0x1F0);
	}
}

/* 将位于磁盘offset位置的count字节数据读入物理地址pa */
void
readseg(unsigned char *pa, int count, int offset) {
	unsigned char *epa;
	epa = pa + count;
	pa -= offset % SECTSIZE;
	offset = (offset / SECTSIZE) + 201;
	for(; pa < epa; pa += SECTSIZE, offset ++)
		readsect(pa, offset);
}

void region_alloc(pde_t* pgdir,void *va,size_t len)
{
	struct PageInfo * page;
	uint32_t i;
	for(i=ROUNDDOWN((uint32_t)va,PGSIZE);
		i<ROUNDUP((uint32_t)va+len,PGSIZE);i+=PGSIZE)
	{
		page=page_alloc(ALLOC_ZERO);
		page_insert(pgdir,page,(void*)i,PTE_U|PTE_W);
	}
}
