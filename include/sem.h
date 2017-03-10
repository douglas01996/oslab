#include "list.h"

typedef struct Sem
{
	int count;
	ListHead wait_list;
	unsigned int used;	
}Sem;
//typedef struct Sem Sem;
#define SEM_NUM 10
Sem sem[SEM_NUM];
void sem_init();
int sem_open(int,int,bool);
int sem_close(int);
int sem_wait(int);
int sem_post(int);
