/*#pragma pack(0)
unsigned char bitmap[512*256];
struct dirent
{
	char filename[56];
	unsigned int file_size;
	unsigned int inode_offset;
};

struct dirent dir[512/sizeof(struct dirent)];

struct inode
{
	unsigned int block_offset[512/sizeof(unsigned int)];
};
struct block
{
	unsigned char data[512];
};
#pragma pack()
struct FCB
{
	int name,pointer,state,size;
	unsigned int infoblock[512/4];
};

void file_init();
void initfileread(unsigned char *,int ,int );
void filefind(struct FCB*,char*);
void fileread(unsigned char* loc,int cnt,int offset,struct FCB*dest);
void filewrite(unsigned char*,int,int,struct FCB*);
void fcb_init();*/
#ifndef __FS_H__
#define __FS_H__
enum seek_type{SEEK_SET,SEEK_CUR,SEEK_END};
#define NR_FILES 8
#pragma pack(0)
struct Super
{
	unsigned int nblocks;
	unsigned int pad[512/4-1];
}super;
struct Bitmap
{
	unsigned char mask[512*256];
}bitmap;
struct dirent
{
	char filename[64-sizeof(int)*4-sizeof(struct dirent*)];
	unsigned int time;
	unsigned int file_size;
	unsigned int inode_offset;
	unsigned int type;
	struct dirent *di;
};
struct Dir
{
	struct dirent entries[512/sizeof(struct dirent)];
}dir,douglas[100];
struct inode
{
	unsigned int block_offset[512/4-1];
	unsigned int offset2;
};
#pragma pack()
#define INR 2
typedef struct
{
	int opened;
	unsigned int offset;
	int id;
	struct Dir* di;
	char filename[64-sizeof(int)*4-sizeof(struct dirent*)];
}Fstate;
struct Dir* curdi;
//Fstate file[NR_FILES];
int fs_open(const char *);
int fs_walk(const char *,struct Dir*);
int fs_walk2(const char *,struct Dir*);
int fs_read(int,void*,int);
int fs_write(int,void *,int);
int fs_close(int);
int fs_lseek(int,int,int);
void fs_rewind(int);
int dircnt;
#endif
