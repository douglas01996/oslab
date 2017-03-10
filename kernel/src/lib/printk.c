#include "common.h"

#define de 0
#define flag 1
#define done 7

extern void serial_printc(char);
void myprint()
{
	serial_printc('-');serial_printc('2');serial_printc('1');serial_printc('4');serial_printc('7');serial_printc('4');serial_printc('8');serial_printc('3');serial_printc('6');serial_printc('4');serial_printc('8');
}
/* implement this function to support printk */
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
	
//	const char *str = __FUNCTION__;
//	for(;*str != '\0'; str ++) printer(*str);

//	str = ": vfprintf() is not implemented!\n";
//	for(;*str != '\0'; str ++) printer(*str);
//	assert(0);	
//	static char buf[256];
//	int len=vsnprintf(buf,256,ctl,args);
//	int cur=0;
	int cur=0;
	int i,j;
	char ch=*ctl++;
	int state=de;
//	char** pt2=(char**)args;
	int temp;
	char buf[100];
	bool sign=0;
	unsigned int temp2;
	while(state!=done)
	{
		if(ch=='\0')	state=done;
		
		switch(state)
		{
			case de:
				if(ch=='%') 
					state=flag;
				else 
					printer(ch);
				ch=*ctl++;
			break;
			case flag:
				switch(ch)
				{
					case 'd':
						temp=((int*)args)[cur];
						if(temp==0x80000000){myprint();break;}
						sign=0;
						if(temp<0)temp=-temp,sign=1;
						i=0;
						while(temp/10)
						{
							buf[i++]=temp%10+'0';	
							temp=temp/10;
						}
						buf[i]=temp+'0';
						if(sign)printer('-');
						for(j=i;j>=0;j--) printer(buf[j]);
					break;
					case 'x':
						temp2=((unsigned int*)args)[cur];
						//if(temp==0x80000000){myprint();break;}
						//sign=0;
						//if(temp<0)temp=-temp,sign=1;
						i=0;
						while(temp2/16)
						{
							if((temp2%16)<10) buf[i++]=temp2%16+'0';
							else buf[i++]=temp2%16-10+'a';
							temp2=temp2/16;
						}
						if(temp2<10)buf[i]=temp2+'0';
						else buf[i]=temp2-10+'a';
						//if(sign)printer('-');
						for(j=i;j>=0;j--) printer(buf[j]);
					break;
					case 's': 
						for(i=0;((char**)args)[cur][i]!='\0';i++) printer(((char**)args)[cur][i]);
					break;
					case 'c': 
						printer(((char*)args)[4*cur]);
					break;
					
					case '%':
						printer('%');
					break;
					default:
						break;
				}
				cur++;
				ch=*ctl++;
				state=de;
			break;
			case done: 
			break;		
		}
		
	}
//	for(i=0;i<cur;i++)
//		printer(buf[i]);	
}

//extern void serial_printc(char);

/* __attribute__((__noinline__))  here is to disable inlining for this function to avoid some optimization problems for gcc 4.7 */
void __attribute__((__noinline__)) 
printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}
