// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <jos/stdio.h>
#include <jos/string.h>
#include <jos/memlayout.h>
#include <jos/assert.h>
#include <jos/x86.h>
#include "common.h"
#include <jos/console.h>
#include <jos/monitor.h>
//#include </kdebug.h>
#include "fs.h"
#include "jos/env.h"
#include "string.h"
#define CMDBUF_SIZE	80	// enough for one VGA text line
extern volatile int tick;
extern struct Env* seek_next();
extern void env_run(struct Env *e);
extern void env_run2(struct Env *e);
struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "ls","Display all files",mon_ls},
	{ "cat","Display a file",mon_cat},
	{ "touch","Change file's time",mon_touch},
	{ "echo","Just echo",mon_echo},
	{ "cd","Change directory",mon_cd},
	{ "r","Run",mon_r},
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s-%s\n",commands[i].name,commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	//extern char _start[], entry[], etext[], edata[], end[];
	cprintf("kerninfo\n");
	return 0;
}
int test_exe(char *arg)
{
	struct Dir*temp=curdi;
	int fd=fs_walk(arg,curdi);
	struct ELFHeader *elf=(struct ELFHeader*)0x8000;
	fs_read(fd,(void*)elf,4096);
	curdi=temp;
	fs_close(fd);
	curenv->fcnt--;
	if(*(unsigned*)elf!=0x464c457f) 
		return 0;
	return 1;
}

extern int Color;
int
mon_r(int argc, char **argv, struct Trapframe *tf)
{
	struct Dir*temp=curdi;
	if(!test_exe(argv[1]))
	{
		Color=4<<8;
		cprintf("%s is not executable\n",argv[1]);
		Color=0;
		//curdi=temp;
		//fs_close(fd);
		//curenv->fcnt--;	
		return 0;
	}
	curdi=temp;
	int fd=fs_walk(argv[1],curdi);
	env_run(env_create(fd));
	curdi=temp;
	fs_close(fd);
	curenv->fcnt--;	
	return 0;
}


int
mon_cd(int argc, char **argv, struct Trapframe *tf)
{
	int fd=fs_walk2(argv[1],curdi);
	return 0;
}
void touch(char * arg)
{
	int i;
	for(i=0;i<NR_FILES;i++)
	{
		if(strcmp(curdi->entries[i].filename,arg)==0)
		{
			curdi->entries[i].time=tick;				
			return ;
		}
	}	

}
int
mon_echo(int argc, char **argv, struct Trapframe *tf)
{
	struct Dir* temp=curdi;
	int i;
	for(i=1;i<argc;i++)
	{
		if(strcmp(argv[i],">")==0 || strcmp(argv[i],">>")==0)
			break;
	}
	if(i==argc)
	{
		for(i=1;i<argc;i++)
		{
			cprintf("%s ",argv[i]);
		}
		cprintf("\n");
	}
	else if(strcmp(argv[i],">")==0)
	{
		//char buf[500];
		touch(argv[i+1]);
		int fd=fs_walk(argv[i+1],curdi);
		fs_rewind(fd);
		int j;
		for(j=1;j<i;j++)
		{
			fs_write(fd,argv[j],strlen(argv[j])*sizeof(char));
			fs_write(fd," ",sizeof(char));
		}
		fs_write(fd,"\n\0",sizeof(char)*2);
		fs_close(fd);
		curenv->fcnt--;	
		curdi=temp;
	}
	else if(strcmp(argv[i],">>")==0)
	{
		touch(argv[i+1]);
		int fd=fs_walk(argv[i+1],curdi);
		fs_rewind(fd);
		char buf[500];
		fs_read(fd,buf,sizeof(buf));
		fs_rewind(fd);
		fs_write(fd,buf,strlen(buf)*sizeof(char));
		//fs_write(fd,"\n",sizeof(char));
		int j;
		for(j=1;j<i;j++)
		{
			fs_write(fd,argv[j],strlen(argv[j])*sizeof(char));
			fs_write(fd," ",sizeof(char));
		}
		fs_write(fd,"\n\0",2*sizeof(char));
		fs_close(fd);
		curenv->fcnt--;	
		curdi=temp;
	}
	return 0;
}
int
mon_touch(int argc, char **argv, struct Trapframe *tf)
{
	int i;
	struct Dir*temp=curdi;
	int fd=fs_walk(argv[1],curdi);
	//cprintf("%s\n",curenv->file[fd].filename);	
	for(i=0;i<NR_FILES;i++)
	{
		if(strcmp(curdi->entries[i].filename,curenv->file[fd].filename)==0)
		{
			curdi->entries[i].time=tick;				
			curdi=temp;
			fs_close(fd);
			curenv->fcnt--;	
			return 0;
		}
	}
	cprintf("no such files!\n");
	return 0;
		
}

int
mon_cat(int argc, char **argv, struct Trapframe *tf)
{
	struct Dir*temp=curdi;
	int fd=fs_walk(argv[1],curdi);
	int i;
	for(i=0;i<NR_FILES;i++)
	{
		//if(strcmp(curdi->entries[i].filename,argv[1])==0)
		if(strcmp(curdi->entries[i].filename,curenv->file[fd].filename)==0)
		{
			if(curdi->entries[i].type==0)
			{
				cprintf("%s is a directory\n",curdi->entries[i].filename);
				curdi=temp;
				fs_close(fd);
				curenv->fcnt--;	
			}
			else
			{
				char buf[500];
				//int fd=fs_walk(curdi->entries[i].filename,curdi);
				fs_read(fd,buf,500);
				fs_close(fd);
				curenv->fcnt--;
				if(argc==2)
					cprintf("%s",buf);	
				else if(strcmp(argv[2],">")==0)
				{
					touch(argv[3]);
					int fd=fs_walk(argv[3],curdi);
					fs_rewind(fd);
					fs_write(fd,buf,strlen(buf)*sizeof(char));
					fs_write(fd,"\0",sizeof(char));
					fs_close(fd);

				}
				else if(strcmp(argv[2],">>")==0)
				{
					touch(argv[3]);
					int fd=fs_walk(argv[3],curdi);
					fs_rewind(fd);
					char buf2[500];
					fs_read(fd,buf2,sizeof(buf2));
					fs_rewind(fd);
					fs_write(fd,buf2,strlen(buf2)*sizeof(char));
					//fs_write(fd,"\n",sizeof(char));
					fs_write(fd,buf,strlen(buf)*sizeof(char));
					fs_write(fd,"\0",sizeof(char));
					fs_close(fd);
					curenv->fcnt--;	
				}
				curdi=temp;
			}				
			return 0;
		}
	}	
	cprintf("no such files!\n");
	return 0;
}
extern int Color;
int
mon_ls(int argc, char **argv, struct Trapframe *tf)
{
	//cprintf("%d\n",argc);
	//cprintf("%s\n",argv[1]);	
	if(argc==1)
	{
		int i;
		for(i=0;i<NR_FILES;i++)
		{
			if(curdi->entries[i].inode_offset!=0 && curdi->entries[i].filename[0]!='.')
			{
				if(curdi->entries[i].type==0) Color=6<<8;
				else if(test_exe(curdi->entries[i].filename))Color=10<<8;
				cprintf("%s\t",curdi->entries[i].filename);
				Color=0;
			}
		}
		cprintf("\n");
	}
	else if(argc==2)
	{
		if(strcmp(argv[1],"-a")==0)
		{
			int i;
			for(i=0;i<NR_FILES;i++)
			{
				if(curdi->entries[i].inode_offset!=0)
				{
					if(curdi->entries[i].type==0) Color=6<<8;
					else if(test_exe(curdi->entries[i].filename))Color=10<<8;
					cprintf("%s\t",curdi->entries[i].filename);
					Color=0;
				}
			}
			cprintf("\n");	
		}
		else if(strcmp(argv[1],"-l")==0)
		{
			int i;
			for(i=0;i<NR_FILES;i++)
			{
				if(curdi->entries[i].inode_offset!=0)
					cprintf("name:%s\tsize:%d\ttime:%d\n",curdi->entries[i].filename,curdi->entries[i].file_size,curdi->entries[i].time);
			}
				
		}
		else if(strcmp(argv[1],"-h")==0)
		{
			int i;
			for(i=0;i<NR_FILES;i++)
			{
				if(curdi->entries[i].inode_offset!=0 && curdi->entries[i].filename[0]!='.')
				{
					cprintf("name:%s\tsize:%dB,%dKB,%dMB\n",curdi->entries[i].filename,curdi->entries[i].file_size/8,curdi->entries[i].file_size/8/1024,curdi->entries[i].file_size/8/1024/1024);
				}
			}
		}
		else if(strcmp(argv[1],"-t")==0)
		{
			int i,j;
			int id=0;
			bool vis[NR_FILES];
			for(i=0;i<NR_FILES;i++)
				vis[i]=0;
			for(i=0;i<NR_FILES;i++)
			{
				int min=1000000;
				bool flag=0;
				for(j=0;j<NR_FILES;j++)
				{
					if(curdi->entries[j].inode_offset!=0 && curdi->entries[j].filename[0]!='.' &&!vis[j]) 
					{
						flag=1;
						if(curdi->entries[j].time<min&&!vis[j])
						{
							 min=curdi->entries[j].time;
							 id=j;
						}
					}
				}
				if(flag)
				{
					vis[id]=1;
					if(curdi->entries[id].type==0) Color=6<<8;
					else if(test_exe(curdi->entries[id].filename))Color=10<<8;
					cprintf("%s\t",curdi->entries[id].filename);
					Color=0;
				}
				else
					break;
			}
			cprintf("\n");
		}
	}
	else if(argc==3)
	{
		if(argv[1][0]=='-'&&argv[2][0]=='-')
		{
			int i;
			for(i=0;i<NR_FILES;i++)
			{
				if(curdi->entries[i].inode_offset!=0)
					cprintf("name:%s\tsize:%d\ttime:%d\n",curdi->entries[i].filename,curdi->entries[i].file_size,curdi->entries[i].time);
			}	
		}
		else if(strcmp(argv[1],"-l")==0)
		{
			int i;
			for(i=0;i<NR_FILES;i++)
				if(strcmp(argv[2],curdi->entries[i].filename)==0)
				{
					cprintf("name:%s\tsize:%d\ttime:%d\n",curdi->entries[i].filename,curdi->entries[i].file_size,curdi->entries[i].time);	
					return 0;
				}
			cprintf("no such file!\n");		
		}
	}
	else
	{
		cprintf("too many arguments\n");
	}
	return 0;
}
int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	// Your code here.
	return 0;
}



/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16
void inc()
{
	tick+=((tick+123)*12389)%101;
}
int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too manny arguments(max%d)\n",MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("unknown command '%s'\n",argv[0]);
	return 0;
}

//extern void printk(char*);
extern char* readline(const char*);
extern int Color;
char *buf2;
void mo_read()
{
	Color=2<<8;
	buf2=readline("DOUGLAS'S SHELL>> ");
	Color=0;
}
extern void timer_event();
void mo_run()
{
	timer_event();
}
extern struct Env* env_create();
void
monitor(struct Trapframe *tf)
{
	char *buf;

	while (1) {
	//printk("im here2\n");
		inc();
		Color=2<<8;
		buf = readline("DOUGLAS'S SHELL>> ");
		if(buf[0]=='.' && buf[1]=='/')
		{
			buf[0]='r'; buf[1]=' ';
		}
		Color=0;
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
		//env_run(env_create());
		//struct Env* next=seek_next();
		//if(next!=NULL) env_run(next);	
	}
}
