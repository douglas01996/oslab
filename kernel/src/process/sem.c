#include "sem.h"
#include "jos/env.h"
#include "common.h"
extern struct Env* envs;
extern struct Env* curenv;

void sem_init()
{
	int i;
	for(i=0;i<SEM_NUM;i++)
	{
		sem[i].count=0;
		list_init(&sem[i].wait_list);
		sem[i].used=0;
	}
}
int sem_open(int id,int count,bool alloc)
{
	printk("sem %d open,count %d,alloc %d\n",id,count,alloc); 
	if(alloc)
	{
		if(id<0 || id>=SEM_NUM) return -1;
		if(sem[id].used)
			sem[id].used++;
		else
		{
			sem[id].used=1;
			sem[id].count=count;
		}
		return id;
	}
	else
	{
		int i;
		for(i=0;i<SEM_NUM;i++)
		{
			if(sem[i].used==0)
			{
				sem[i].used=1;
				sem[i].count=count;
				return i;
			}
		}	
	}
	return -1;
}
int sem_close(int id)
{
	printk("sem_close\n");
	if(sem[id].used<=0) return -1;
	sem[id].used--;
	sem[id].count=0;
	return id;				
}

extern struct Env* seek_next();
extern void env_run(struct Env*);
int sem_wait(int id)
{
	//printk("sem wait\n");
	if(id<0 || id>=SEM_NUM) return -1;
	sem[id].count--;
	if(sem[id].count<0)
	{
	//	printk("P\n");
		/*int i;
		for(i=0;i<NENV;i++)
			if(envs[i].env_status==ENV_RUNNING) break;
		envs[i].env_status=ENV_NOT_RUNNABLE+id;
		*/
		curenv->env_status=ENV_NOT_RUNNABLE+id;
		struct Env* next=seek_next();
		if(next==NULL)
		{
			printk("nothing more to do\n");
			while(1);
		}
		else
		{
			env_run(next);
		}
	}
	return 1;	
}

int sem_post(int id)
{
	//printk("sem post\n");
	if(id<0 || id>=SEM_NUM) return -1;
	sem[id].count++;
	if(sem[id].count<=0)
	{
		int i;
		for(i=0;i<NENV;i++)
			if(envs[i].env_status==ENV_NOT_RUNNABLE+id) break;
		envs[i].env_status=ENV_RUNNABLE;
	}
	return 1;
}
