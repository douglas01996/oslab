#include "common.h"
#include "fs.h"
#include "jos/env.h"
#include "jos/string.h"
#include "jos/stdio.h"
#include "boot.h"
#include "string.h"
/*#define off_t xxx_off_t
#define bool xxx_bool
#define int8_t xxx_int8_t
#define abort xxx_bool
#define FILE int
#include <stdlib.h>
#include <malloc.h>
#undef FILE
#undef abort
#undef int8_t
#undef off_t
#undef bool*/
extern int Color;

#define SECTSIZE 512
int
ide_read(uint32_t secno, void *dst, size_t nsecs);
int
ide_write(uint32_t secno, const void *src, size_t nsecs);
void env_sleep(struct Env *e,int sec);

void waitdisk(void);
/*{
	while((in_byte(0x1F7)&0xc0)!=0x40);
}*/
void readsect(void *dst,int offset);
/*{
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
}*/
void writesect(void *src,int offset)
{
	int i;
	waitdisk();
	//out_byte
	out_byte(0x1F2, 1);
	out_byte(0x1F3, offset);
	out_byte(0x1F4, offset >> 8);
	out_byte(0x1F5, offset >> 16);
	out_byte(0x1F6, (offset >> 24) | 0xE0);
	out_byte(0x1F7, 0x30);

	waitdisk();
	for (i = 0; i < SECTSIZE / 4; i ++) {
		//((int *)dst)[i] = in_long(0x1F0);
		out_long(0x1F0,((uint32_t*)src)[i]);
	}
}


int fs_open(const char* pathname)
{
	return fs_walk(pathname,&dir);
}

int fs_walk2(const char* pathname,struct Dir* di)
{
	if(pathname[0]=='/')
	{
		curdi=&dir;
		char tempbuf[50];
		int i;
		for(i=1;i<strlen(pathname);i++)
			tempbuf[i-1]=pathname[i];
		tempbuf[i-1]='\0';
		return fs_walk(tempbuf,&dir);
	}
	if(pathname[0]=='\0') return -2;
	int i;
	int flag=strlen(pathname);
	for(i=0;i<strlen(pathname);i++)
	{
		if(pathname[i]=='/')
		{
			flag=i;
			break;
		}
	}
	char buf[50];
	for(i=0;i<flag;i++)
	{
		buf[i]=pathname[i];
	}
	buf[i]='\0';
	for(i=0;i<NR_FILES;i++)
	{
		if(strcmp(buf,di->entries[i].filename)==0)
		{
			if(di->entries[i].type==1)
			{
				Color=4<<8;
				cprintf("%s is a directory\n",di->entries[i].filename);
				Color=0;
				return -1;
				int fcnt=curenv->fcnt;	
				//printk("%d\n",i);
				//printk("opening...\n");
				curenv->file[fcnt].opened=1;
				curenv->file[fcnt].offset=0;
				curenv->file[fcnt].di=di;
				curenv->file[fcnt].id=i;
				memcpy(curenv->file[fcnt].filename,buf,sizeof(di->entries[i].filename));
				int temp=fcnt;
				curenv->fcnt++;
				return temp;
			}
			else
			{
				int j;
				for(j=flag+1;j<strlen(pathname);j++)
					buf[j-flag-1]=pathname[j];
				buf[j-flag-1]='\0';
				struct Dir* temp=curdi=&douglas[dircnt];
				dircnt++;
				readsect((void*)temp->entries,di->entries[i].inode_offset+201);
				return fs_walk(buf,temp);
				
			}
		}
	}
	printk("fs walk not find\n");
	return -1;
}
/*
inline static int min(int a,int b)
{
	return a<b?a:b;
}*/

int fs_walk(const char* pathname,struct Dir* di)
{
	//cprintf("%s\n",pathname);
	if(pathname[0]=='/')
	{
		curdi=&dir;
		char tempbuf[50];
		int i;
		for(i=1;i<strlen(pathname);i++)
			tempbuf[i-1]=pathname[i];
		tempbuf[i-1]='\0';
		return fs_walk(tempbuf,&dir);
	}
	if(pathname[0]=='\0') return -2;
	int i;
	int flag=strlen(pathname);
	for(i=0;i<strlen(pathname);i++)
	{
		if(pathname[i]=='/')
		{
			flag=i;
			break;
		}
	}
	char buf[50];
	for(i=0;i<flag;i++)
	{
		buf[i]=pathname[i];
	}
	buf[i]='\0';
	for(i=0;i<NR_FILES;i++)
	{
		if(strcmp(buf,di->entries[i].filename)==0)
		{
			if(di->entries[i].type==1)
			{
				int fcnt=curenv->fcnt;	
				//printk("%d\n",i);
				//printk("opening...\n");
				curenv->file[fcnt].opened=1;
				curenv->file[fcnt].offset=0;
				curenv->file[fcnt].di=di;
				curenv->file[fcnt].id=i;
				memcpy(curenv->file[fcnt].filename,buf,sizeof(di->entries[i].filename));
				int temp=fcnt;
				curenv->fcnt++;
				return temp;
			}
			else
			{
				int j;
				for(j=flag+1;j<strlen(pathname);j++)
					buf[j-flag-1]=pathname[j];
				buf[j-flag-1]='\0';
				struct Dir* temp=curdi=&douglas[dircnt];
				dircnt++;
				readsect((void*)temp->entries,di->entries[i].inode_offset+201);
				return fs_walk(buf,temp);
				
			}
		}
	}
	printk("fs walk not find\n");
	return -1;
}

inline static int min(int a,int b)
{
	return a<b?a:b;
}

int fs_read(int fd,void *buf,int len)
{
	//printk("%d\n",fd);
	//printk("offset%d\n",curenv->env_id);
	if(fd>=0&& fd<NR_FILES)
	{
		Fstate temp=curenv->file[fd];
		int id=temp.id;
		struct Dir* di=temp.di;
		//printk("%s\n",di->entries[id].filename);
		//printk("reading...\n");
		len=min(len,di->entries[id].file_size-curenv->file[fd].offset);
		uint32_t ioff=di->entries[id].inode_offset;
		//printk("ioff %d\n",len);
		struct inode node;
		readsect((void*)&node,ioff+201);
		uint32_t begin=curenv->file[fd].offset/512;
		uint32_t begin_off=curenv->file[fd].offset%512;
		uint32_t end=(curenv->file[fd].offset+len)/512;
		uint32_t end_off=(curenv->file[fd].offset+len)%512;
		if(begin==end)
		{
			while(begin>=INR)
			{
				ioff=node.offset2;
				if(ioff==0) {printk("ioff wrong\n");while(1);}
				readsect((void*)&node,ioff+201);
				begin-=INR;
			}
			unsigned char sect[512];
			readsect((void*)sect,node.block_offset[begin]+201);
			unsigned int i;
			for(i=0;i<len;i++)
				((uint8_t *)buf)[i]=sect[begin_off+i];
		}
		else
		{	
			//printk("im here\n");
			while(begin>=INR)
			{
				ioff=node.offset2;
				readsect((void*)&node,ioff+201);
				begin-=INR;
				end-=INR;
			//	printk("im here\n");
			}
			unsigned char sect[512];
			readsect((void*)sect,node.block_offset[begin]+201);
			//printk("ioff %d\n",begin_off);
			unsigned int i;
			//diyikuai duwan
			for(i=0;i<512-begin_off;i++)
			{
				((uint8_t *)buf)[i]=sect[begin_off+i];
			//	printk("%d",((uint8_t *)buf)[i]);
			}
			//printk("\n");
			buf=((uint8_t *)buf)+512-begin_off;
			//printk("imhere\n");
			
			begin+=1;
			while(end>=INR)
			{
			//	printk("imhere2\n");
				for(i=begin;i<INR;i++)
				{
					readsect(buf,node.block_offset[i]+201);
					buf=((uint8_t*)buf)+512;
				}
				begin=0;
				end-=INR;
				ioff=node.offset2;
				readsect((void*)&node,ioff+201);	
			}
			//printk("imhere\n");
			for(i=begin;i<end;i++)
			{
				readsect(buf,node.block_offset[i]+201);
				buf=((uint8_t*)buf)+512;
			}
			//printk("imhere\n");
			readsect((void*)sect,node.block_offset[end]+201);
			for(i=0;i<end_off;i++)
				((uint8_t *)buf)[i]=sect[i];
			//printk("imhere\n");
		}
		curenv->file[fd].offset+=len;
		return len;
	}
	printk("readerror\n");
	while(1);
	return -1;
}

int fs_write(int fd,void*buf,int len)
{
	Fstate temp=curenv->file[fd];
	int id=temp.id;
	struct Dir* di=temp.di;
	if(fd>=0&&fd<NR_FILES)
	{
		//printk("writing...\n");
		len=min(len,di->entries[id].file_size-curenv->file[fd].offset);
		uint32_t ioff=di->entries[id].inode_offset;
		struct inode node;
		readsect((void*)node.block_offset,ioff+201);
		uint32_t begin=curenv->file[fd].offset/512;
		uint32_t begin_off=curenv->file[fd].offset%512;
		uint32_t end=(curenv->file[fd].offset+len)/512;
		uint32_t end_off=(curenv->file[fd].offset+len)%512;
		if(begin==end)
		{
			while(begin>=INR)
			{
				ioff=node.offset2;
				readsect((void*)&node,ioff+201);
				begin-=INR;
			}
			unsigned char sect[512];
			readsect((void*)sect,node.block_offset[begin]+201);
			uint32_t i;
			for(i=0;i<len;i++)
				sect[begin_off+i]=((uint8_t*)buf)[i];
			writesect((void*)sect,node.block_offset[begin]+201);
		}
		else
		{
			while(begin>=INR)
			{
				ioff=node.offset2;
				readsect((void*)&node,ioff+201);
				begin-=INR;
				end-=INR;
			}
			unsigned char sect[512];
			readsect((void*)sect,node.block_offset[begin]+201);
			uint32_t i;
			for(i=0;i<len;i++)
				sect[begin_off+i]=((uint8_t *)buf)[i];
			writesect((void*)sect,node.block_offset[begin]+201);
			buf=((uint8_t*)buf)+512-begin_off;
			
			begin+=1;
			while(end>=INR)
			{
				for(i=begin;i<INR;i++)
				{
					writesect(buf,node.block_offset[i]+201);
					buf=((uint8_t*)buf)+512;
				}
				begin=0;
				end-=INR;
				ioff=node.offset2;
				readsect((void*)&node,ioff+201);	
			}
			
			for(i=begin;i<end;i++)
			{
				writesect(buf,node.block_offset[i]+201);
				buf=((uint8_t*)buf)+512;
			}
			readsect((void*)sect,node.block_offset[end]+201);
			for(i=0;i<end_off;i++)
				sect[i]=((uint8_t*)buf)[i];
			writesect((void*)sect,node.block_offset[end]+201);
		}
		curenv->file[fd].offset+=len;
		return len;
	}
	return -1;
	
}

int fs_close(int fd)
{
	if(fd>=0&&fd<NR_FILES)
	{
	//	printk("closing...\n");
		curenv->file[fd].opened=false;
		curenv->file[fd].offset=0;
		return 0;
	}
	return -1;
}

int fs_lseek(int fd,int offset,int whence)
{
	if(fd>=0&&fd<NR_FILES)
	{
		switch(whence)
		{
			case SEEK_SET: break;
			case SEEK_CUR: offset+=curenv->file[fd].offset;
			break;
			case SEEK_END:offset+=curenv->file[fd].di->entries[curenv->file[fd].id].file_size;
			break;
			default:
				printk("111\n");
				while(1);
		}
		//printk("offset%d\n",curenv->env_id);
		Fstate t=curenv->file[fd];
		int id=t.id;
		struct Dir* temp=t.di;
		//struct Dir* temp=curenv->file[fd].di;
		//int id=curenv->file[fd].id;
		//printk("%s\n",temp->entries[id].filename);
		if(offset>=0&&offset<=temp->entries[id].file_size)
		{
			curenv->file[fd].offset=offset;
			return offset;
		}
		else if(offset<0)
		{	
			printk("offset<0\n");
			while(1);
			offset=0;
			return 0;
		}
		else
		{
			printk("offset big\n");
			while(1);
			offset=temp->entries[id].file_size;
			return offset;
		}
	}
	printk("error\n");
	while(1);
	return -1;

		
}

void fs_rewind(int fd)
{
	fs_lseek(fd,0,SEEK_SET);
}
