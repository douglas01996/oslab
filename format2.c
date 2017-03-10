#include "stdio.h"
#include "string.h"
#include "unistd.h"
//#include "dir.h"
#define INR 2
#pragma pack(0)
struct Super
{
	unsigned int nblocks;
	unsigned int pad[512/4-1];
}super;
//yige kuai 2MB
//max 4GB
struct Bitmap
{
	unsigned char mask[512*2048];
}bitmap;

struct dirent
{
	char filename[64-sizeof(unsigned int)*4-sizeof(void*)];
	unsigned int time;
	unsigned int file_size;
	unsigned int inode_offset;
	unsigned int type;
	unsigned int dircnt;
};
struct Dir
{
	struct dirent entries[512/sizeof(struct dirent)];
}dir,douglas[100];
struct inode
{
	unsigned int block_offset[512/sizeof(unsigned int)-1];
	unsigned int offset2;
};
#pragma pack()
int doff[100];
int dfile[100];
void SET_BIT(int n)
{
	int t1=n/8,t2=n%8;
	bitmap.mask[t1]|=(1<<t2);
}

void CLEAR_BIT(int n)
{
	int t1=n/8,t2=n%8;
	bitmap.mask[t1]&=(~(1<<t2));
}

int USED(int n)
{
	int t1=n/8,t2=n%8;
	return bitmap.mask[t1]&(1<<t2);
}

//#define SET_BIT(n) (bitmap[n/8]|=(0x1<<(n%8)))
//#define CLEAR_BIT(n) (bitmap[n/8]&=(~(0x1<<(n%8))))
//#define USED(n) (bitmap[n/8]&(0x1<<(n%8)))

unsigned int str2int(char * c)
{
	int i;
	int result=0;
	for(i=0;i<strlen(c);i++)
	{
		result=result*10+c[i]-'0';
	}
	return result;
	
}

unsigned int alloc_block()
{
	
	unsigned int i;
	for(i=0;i<super.nblocks*2*1024*1024;i++)
	{
		if(!USED(i))
		{
			SET_BIT(i);
			return i;
		}
	}
	printf("no more space\n");
	while(1);
	return -1;
}
//type 1 file,0 dir
void fs_open(char * name,int cnt,int);
FILE* fp;
int dircnt=0;
char dirname[100][50];
int id[100];
int main(int argc,char** argv)
{
	//init
	memset(dfile,-1,sizeof(dfile));
	int iii;
	for(iii=0;iii<100;iii++)
		dfile[iii]=1;
	memset(doff,0,sizeof(doff));
	memset(super.pad,0,sizeof(super.pad));
	unsigned int nb=str2int(argv[1]);
	super.nblocks=nb;
	printf("%d\n",nb);
	if(nb>=2048)
	{
		printf("too large!\n");
		while(1);
	}
	fp=fopen("newdisk","wb");
	memset(bitmap.mask,0,sizeof(bitmap.mask));
	memset(dir.entries,0,sizeof(dir.entries));
	SET_BIT(0);
	unsigned int i;
	for(i=1;i<=nb;i++)
	{
		SET_BIT(i);	
	}
	SET_BIT(nb+1);
	dir.entries[0].type=dir.entries[1].type=0;
	dir.entries[0].inode_offset=dir.entries[1].inode_offset=nb+1;
	strcpy(dir.entries[0].filename,".");
	strcpy(dir.entries[1].filename,"..");
	//bianli file list
	for(i=2;i<argc;i++)
	{
		//while(1);	
		int j;
		for(j=0;j<strlen(argv[i]);j++)
		{
			if(argv[i][j]=='/')	break;
		}
		if(j==strlen(argv[i]))
		{
	//	printf("%d\n",i);
			FILE* fp2=fopen(argv[i],"rb");
			strcpy(dir.entries[i].filename,argv[i]);
			dir.entries[i].type=1;
			printf("%s\n",argv[i]);
			//size
			fseek(fp2,0,SEEK_END);
			printf("%d\n",i);
			unsigned int filesz=ftell(fp2);
			fseek(fp2,0,SEEK_SET);
			printf("%d\n",filesz);	
			dir.entries[i].file_size=filesz;
			//inode
			dir.entries[i].inode_offset=alloc_block();
			unsigned int ioff=dir.entries[i].inode_offset;
			//write file
			struct inode node;
			unsigned char buf[512];
			int cnt=0;
			while(fread(buf,1,512,fp2))
			{
					//ionde
			//printf("%d\n",cnt);	
			//unsigned int offset=alloc_block();
				if(cnt<INR)
				{
					node.block_offset[cnt++]=alloc_block();
				}
				else
				{
					node.offset2=alloc_block();
					fseek(fp,512*ioff,SEEK_SET);
					fwrite(&node,1,512,fp);
				
					ioff=node.offset2;
					memset(node.block_offset,0,sizeof(node.block_offset));
					node.block_offset[0]=alloc_block();
					cnt=1;
					node.offset2=0;
				}
				fseek(fp,512*node.block_offset[cnt-1],SEEK_SET);
				fwrite(buf,1,512,fp);
				rewind(fp);
			
			}
			//write inode
			fseek(fp,512*ioff,SEEK_SET);
			fwrite(&node,1,512,fp);
			rewind(fp);
			fclose(fp2);
		}
		else
		{
			printf("%d\n",i);
			char tempbuf[50];
			int k;
			for(k=0;k<j;k++)
				tempbuf[k]=argv[i][k];
			tempbuf[k]='\0';
			int z;
			for(z=2;z<i;z++)
			{
				printf("1%s %s\n",tempbuf,dir.entries[z].filename);
				if(!strcmp(tempbuf,dir.entries[z].filename)) break;
			}
				printf("z%d\n",z);
			if(z==i)
			{
				dfile[dircnt]++;
				printf("dfile%d\n",dfile[dircnt]);
				dir.entries[i].dircnt=dircnt;
				int k;
				for(k=0;k<j;k++)
					dir.entries[i].filename[k]=argv[i][k];
				dir.entries[i].filename[k]='\0';
				printf("%s\n",dir.entries[i].filename);
				dir.entries[i].type=0;
				dir.entries[i].inode_offset=alloc_block();
				doff[dircnt]=dir.entries[i].inode_offset;
				char temp[50];
				for(k=j+1;k<strlen(argv[i]);k++)
					temp[k-j-1]=argv[i][k];
				temp[k-j-1]='\0';
				printf("%s\n",argv[i]);
			/*printf("%d\n",strlen(argv[i]));
			printf("%d\n",j);
			printf("%s\n",temp);*/	
				strcpy(douglas[dircnt].entries[0].filename,".");
				strcpy(douglas[dircnt].entries[1].filename,"..");
				douglas[dircnt].entries[0].inode_offset=doff[dircnt];
				douglas[dircnt].entries[1].inode_offset=nb+1;
				douglas[dircnt].entries[0].type=douglas[dircnt].entries[1].type=0;
				chdir(dir.entries[i].filename);
				fs_open(temp,dircnt,1);
				chdir("..");
			}
			else
			{
				dfile[dir.entries[z].dircnt]++;
				printf("imhere\n");
				printf("%s\n",dir.entries[z].filename);
				printf("hereherehere\n");
				char temp[50];
				for(k=j+1;k<strlen(argv[i]);k++)
					temp[k-j-1]=argv[i][k];
				temp[k-j-1]='\0';
				printf("hereherehere\n");
				printf("%s\n",argv[i]);
				chdir(dir.entries[z].filename);
				fs_open(temp,dir.entries[z].dircnt,0);
				chdir("..");
			}
		}
	}
	printf("dircnt%d\n",dircnt);
	for(i=0;i<dircnt;i++)
	{
		printf("%ddoff[i]\n",doff[i]);
		fseek(fp,512*doff[i],SEEK_SET);
		fwrite(&douglas[i].entries,1,512,fp);
		rewind(fp);
	}
	fseek(fp,512*(nb+1),SEEK_SET);
	fwrite(&dir.entries,1,512,fp);
	rewind(fp);
	//bitmap
	fseek(fp,512,SEEK_SET);
	fwrite(&bitmap.mask,1,512*nb,fp);
	rewind(fp);
	//super
	fseek(fp,0,SEEK_SET);
	fwrite(&super,1,512,fp);
	fclose(fp);
}
void fs_open(char * name,int count,int flags)
{
	if(flags)dircnt++;
	int j;
	for(j=0;j<strlen(name);j++)
	{
		if(name[j]=='/')	break;
	}
	printf("nnnnnnnnnn%s\n",name);
	if(j==strlen(name))
	{
			printf("imhere\n");
			int i=dfile[count];
			printf("%s\n",name);
			FILE* fp2=fopen(name,"rb");
			printf("dfile%d\n",i);
			printf("filename%s\n",douglas[count].entries[i].filename);
			strcpy(douglas[count].entries[i].filename,name);
			printf("filename%s\n",douglas[count].entries[i].filename);
			printf("%d\n",count);
			douglas[count].entries[i].type=1;
			//size
			printf("%s\n",name);
			fseek(fp2,0,SEEK_END);
			unsigned int filesz=ftell(fp2);
			fseek(fp2,0,SEEK_SET);
			printf("%d\n",filesz);	
			douglas[count].entries[i].file_size=filesz;
			//inode
			douglas[count].entries[i].inode_offset=alloc_block();
			unsigned int ioff=douglas[count].entries[i].inode_offset;
			//write file
			struct inode node;
			unsigned char buf[512];
			int cnt=0;
			while(fread(buf,1,512,fp2))
			{
					//ionde
			//printf("%d\n",cnt);	
			//unsigned int offset=alloc_block();
				if(cnt<INR)
				{
					node.block_offset[cnt++]=alloc_block();
				}
				else
				{
					node.offset2=alloc_block();
					fseek(fp,512*ioff,SEEK_SET);
					fwrite(&node,1,512,fp);
				
					ioff=node.offset2;
					memset(node.block_offset,0,sizeof(node.block_offset));
					node.block_offset[0]=alloc_block();
					cnt=1;
					node.offset2=0;
				}
				fseek(fp,512*node.block_offset[cnt-1],SEEK_SET);
				fwrite(buf,1,512,fp);
				rewind(fp);
			
			}
			//write inode
			fseek(fp,512*ioff,SEEK_SET);
			fwrite(&node,1,512,fp);
			rewind(fp);
			fclose(fp2);

	}
	else
		{
			char tempbuf[50];
			int i=dfile[count];
			printf("dfile%d\n",i);
			int k;
			for(k=0;k<j;k++)
				tempbuf[k]=name[k];
			tempbuf[k]='\0';
			int z;
			for(z=0;z<i;z++)
			{
				if(!strcmp(tempbuf,douglas[count].entries[z].filename)) break;
			}
			if(z==i)
			{
				dfile[dircnt]++;
				douglas[count].entries[i].dircnt=dircnt;
				int k;
			for(k=0;k<j;k++)
				douglas[count].entries[i].filename[k]=name[k];
			douglas[count].entries[i].filename[k]='\0';
			douglas[count].entries[i].type=0;
			douglas[count].entries[i].inode_offset=alloc_block();
			doff[dircnt]=douglas[count].entries[i].inode_offset;
				strcpy(douglas[dircnt].entries[0].filename,".");
				strcpy(douglas[dircnt].entries[1].filename,"..");
				douglas[dircnt].entries[0].inode_offset=doff[dircnt];
				douglas[dircnt].entries[1].inode_offset=douglas[count].entries[0].inode_offset;
				douglas[dircnt].entries[0].type=douglas[dircnt].entries[1].type=0;
			char temp[50];
			for(k=j+1;k<strlen(name);k++)
				temp[k-j-1]=name[k];
			temp[k-j-1]='\0';
			printf("bbbbbb%s\n",douglas[count].entries[i].filename);
			chdir(douglas[count].entries[i].filename);
			fs_open(temp,dircnt,1);
			chdir("..");
			}
			else
			{
			char temp[50];
			for(k=j+1;k<strlen(name);k++)
				temp[k-j-1]=name[k];
			temp[k-j-1]='\0';
			dfile[douglas[count].entries[z].dircnt]++;
			chdir(douglas[count].entries[z].filename);
			fs_open(temp,douglas[count].entries[z].dircnt,0);
			chdir("..");
			
			}
		}
	
	
}
