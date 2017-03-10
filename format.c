#include "stdio.h"
#include "string.h"
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
	char filename[64-sizeof(unsigned int)*3-sizeof(void*)];
	unsigned int file_size;
	unsigned int inode_offset;
	unsigned int type;
	void* di;
};
struct Dir
{
	struct dirent entries[512/sizeof(struct dirent)];
}dir,douglas;
struct inode
{
	unsigned int block_offset[512/sizeof(unsigned int)-1];
	unsigned int offset2;
};
#pragma pack()

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

int main(int argc,char** argv)
{
	//init
	memset(super.pad,0,sizeof(super.pad));
	unsigned int nb=str2int(argv[1]);
	super.nblocks=nb;
	printf("%d\n",nb);
	if(nb>=2048)
	{
		printf("too large!\n");
		while(1);
	}
	FILE* fp=fopen("data.disk","wb");
	memset(bitmap.mask,0,sizeof(bitmap.mask));
	memset(dir.entries,0,sizeof(dir.entries));
	SET_BIT(0);
	unsigned int i;
	for(i=1;i<=nb;i++)
	{
		SET_BIT(i);	
	}
	SET_BIT(nb+1);
	strcpy(dir.entries[0].filename,"douglas");
	dir.entries[0].file_size=0;
	dir.entries[0].type=0;
	dir.entries[0].inode_offset=nb+2;

	SET_BIT(nb+2);
	memset(douglas.entries,0,sizeof(douglas.entries));
	
	//bianli file list
	for(i=2;i<argc-1;i++)
	{
		//while(1);	
		//printf("%d\n",i);
		FILE* fp2=fopen(argv[i],"rb");
		strcpy(dir.entries[i-1].filename,argv[i]);
		dir.entries[i-1].type=1;
		//size
		fseek(fp2,0,SEEK_END);
		unsigned int filesz=ftell(fp2);
		fseek(fp2,0,SEEK_SET);
		printf("%d\n",filesz);	
		dir.entries[i-1].file_size=filesz;
		//inode
		dir.entries[i-1].inode_offset=alloc_block();
		unsigned int ioff=dir.entries[i-1].inode_offset;
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
		FILE* fp2=fopen(argv[i],"rb");
		strcpy(douglas.entries[0].filename,argv[i]);
		douglas.entries[0].type=1;
		//size
		fseek(fp2,0,SEEK_END);
		unsigned int filesz=ftell(fp2);
		fseek(fp2,0,SEEK_SET);
		douglas.entries[0].file_size=filesz;
		//inode
		douglas.entries[0].inode_offset=alloc_block();
		unsigned int ioff=douglas.entries[0].inode_offset;
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
	//write dir
	fseek(fp,512*(nb+2),SEEK_SET);
	fwrite(&douglas.entries,1,512,fp);
	rewind(fp);
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
