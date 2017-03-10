#include "stdio.h"
#include "string.h"

int main()
{
	FILE *fp;
	char c[50]="reading test success";
	fp=fopen("test.dat","wb");
	fwrite((void*)c,1,50,fp);
	fclose(fp);
}
