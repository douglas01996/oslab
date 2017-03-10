#ifndef JOS_KERN_MONITOR_H
#define JOS_KERN_MONITOR_H
//#ifndef JOS_KERNEL
//# error "This is a JOS kernel header; user programs should not #include it"
//#endif
#define hislen 10
char history[hislen][1024];
char history2[hislen][1024];
int curhis;
int endhis;
struct Trapframe;
static bool hisflag=0;
// Activate the kernel monitor,
// optionally providing a trap frame indicating the current state
// (NULL if none).
void monitor(struct Trapframe *tf);

// Functions implementing monitor commands.
int mon_help(int argc, char **argv, struct Trapframe *tf);
int mon_r(int argc, char **argv, struct Trapframe *tf);
int mon_ls(int argc, char **argv, struct Trapframe *tf);
int mon_cd(int argc, char **argv, struct Trapframe *tf);
int mon_cat(int argc, char **argv, struct Trapframe *tf);
int mon_touch(int argc, char **argv, struct Trapframe *tf);
int mon_echo(int argc, char **argv, struct Trapframe *tf);
int mon_kerninfo(int argc, char **argv, struct Trapframe *tf);
int mon_backtrace(int argc, char **argv, struct Trapframe *tf);

#endif	// !JOS_KERN_MONITOR_H
