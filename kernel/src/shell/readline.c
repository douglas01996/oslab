#include <jos/stdio.h>
//#include <inc/error.h>
#include "string.h"
#include "jos/monitor.h"
#define BUFLEN 1024
static char buf[BUFLEN];
bool flag1,flag2;
char *
readline(const char *prompt)
{
	int i, c, echoing;

	if (prompt != NULL)
		cprintf("%s", prompt);

	i = 0;
	echoing = iscons(0);
	//echoing=0;
	while (1) {
		c = getchar();
		//cprintf("%d\n",c);
		
		if(c==254)
		{
			if(flag1)
			{
				while(i>0)
				{
					cputchar('\b');i--;
				}
				//if(flag2) {cputchar('\b');flag2=1;}
				//else flag2=1;
			}
			flag1=0;	
			continue;
		}
		flag1=1;
		if(c==226)
		{
			//memcpy(buf,history,sizeof(history));
			//return buf;
			//int len=strlen(history[curhis]);	
			if(echoing)
			{
				while(i>0)
				{
					cputchar('\b');i--;
				}
				//while(i--)
				//	cputchar('\b');
				
				//int ii;
				//if(hisflag && curhis!=endhis-1)curhis++;
				hisflag=1;
				for(i=0;history[curhis][i]!=0;i++)
				{
					buf[i]=history[curhis][i];
					cputchar(buf[i]);
				}
				if(curhis!=endhis-1)curhis++;
			}
		}else if(c==227){
			if(curhis>0)
			{
			
				while(i--)
					cputchar('\b');
				if(!hisflag) curhis--;
				hisflag=0;
				//int ii;
				for(i=0;history[curhis-1][i]!=0;i++)
				{
					buf[i]=history[curhis-1][i];
					cputchar(buf[i]);
				}
			}
			//if(curhis!=endhis-1)curhis++;

		} /*else if (c==228) {
			i--;
		} else if (c==229) {
			i++;
		} */else if (c < 0) {
			cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
			if (echoing);
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
			if (echoing)
				cputchar(c);
			buf[i++] = c;
		} else if (c == '\n' || c == '\r') {
			if (echoing)
				cputchar('\n');
			buf[i] = 0;
			int ii;
			for(ii=endhis-1;ii>=curhis;ii--)
				memcpy(history2[ii-curhis+1],history[ii],sizeof(history[ii]));
			for(ii=1;ii<endhis-curhis+1;ii++)
			{
			//	cprintf("%d\n",ii);
				memcpy(history[ii],history2[ii],sizeof(history[ii]));
			//	cprintf("%s\n",history[ii]);
			//	cprintf("%s\n",history2[ii]);
			
			}
			memcpy(history[0],buf,sizeof(buf));
			endhis=endhis-curhis;
			if(endhis!=hislen-1) endhis++;
			//cprintf("%s\n",history[1]);
			//cprintf("%s\n",history2[1]);
			curhis=0;
			hisflag=0;
			return buf;
		}
	}
}

