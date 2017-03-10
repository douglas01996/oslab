/* See COPYRIGHT for copyright information. */

#include <jos/stdio.h>
#include <jos/string.h>
#include <jos/assert.h>

#include <jos/monitor.h>
#include <jos/console.h>
#include "string.h"
// Test the stack backtrace function (lab 1 only)
#include "jos/env.h"
void
test_backtrace(int x)
{
/*	cprintf("entering test_backtrace %d\n", x);
	if (x > 0)
		test_backtrace(x-1);
	else
		mon_backtrace(0, 0, 0);
	cprintf("leaving test_backtrace %d\n", x);
*/
}
extern int Color;
bool ffff=0;
void
i386_init(void)
{
	//extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	//memset(edata, 0, end - edata);

	// Initialize the console.
	// Can't call cprintf until after we do this!
	//if(!ffff) ffff=1,env_run(env_create());
	cons_init();

	//cprintf("6828 decimal is %o octal!\n", 6828);

	// Test the stack backtrace function (lab 1 only)
	//test_backtrace(5);

	// Drop into the kernel monitor.
	Color=3<<8;
	cprintf("Welcome to my os!\n");
	Color=0;

	while (1)
		monitor(NULL);
}


/*
 * Variable panicstr contains argument to first call to panic; used as flag
 * to indicate that the kernel has already called panic.
 */
const char *panicstr;

/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
	va_list ap;

	if (panicstr)
		goto dead;
	panicstr = fmt;

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");

	va_start(ap, fmt);
//	cprintf("kernel panic at %s:%d: ", file, line);
//	vcprintf(fmt, ap);
//	cprintf("\n");
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
	va_list ap;

	va_start(ap, fmt);
//	cprintf("kernel warning at %s:%d: ", file, line);
//	vcprintf(fmt, ap);
//	cprintf("\n");
	va_end(ap);
}