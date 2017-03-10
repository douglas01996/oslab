#ifndef __COMMON_H__
#define __COMMON_H__

#include "types.h"
#include "const.h"
#include "assert.h"

#define GAME_STACK_ADDR (6<<20)
#define GAME_STACK_SIZE (1<<20)
void printk(const char *ctl, ...);
void print(const char *ctl, ...);
void printk_test(void);

#endif
