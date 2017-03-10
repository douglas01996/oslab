#ifndef __IRQ_H__
#define __IRQ_H__

int __attribute__((__noinline__)) syscall(int id,...);
/* 中断处理相关函数 */
void init_idt(void);
void init_intr(void);

void set_timer_intr_handler( void (*ptr)(void) );
void set_keyboard_intr_handler( void (*ptr)(int) );

#endif
