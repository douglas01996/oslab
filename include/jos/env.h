/* See COPYRIGHT for copyright information. */

#ifndef JOS_INC_ENV_H
#define JOS_INC_ENV_H

#include <jos/types.h>
#include <jos/trap.h>
#include <jos/memlayout.h>
#include "x86/memory.h"
#include "fs.h"
typedef int32_t envid_t;

// An environment ID 'envid_t' has three parts:
//
// +1+---------------21-----------------+--------10--------+
// |0|          Uniqueifier             |   Environment    |
// | |                                  |      Index       |
// +------------------------------------+------------------+
//                                       \--- ENVX(eid) --/
//
// The environment index ENVX(eid) equals the environment's offset in the
// 'envs[]' array.  The uniqueifier distinguishes environments that were
// created at different times, but share the same environment index.
//
// All real environments are greater than 0 (so the sign bit is zero).
// envid_ts less than 0 signify errors.  The envid_t == 0 is special, and
// stands for the current environment.

#define LOG2NENV		5
#define NENV			(1 << LOG2NENV)
#define ENVX(envid)		((envid) & (NENV - 1))

// Values of env_status in struct Env
enum EnvState {
	ENV_FREE = 0,
	ENV_RUNNABLE,
	ENV_RUNNING,
	ENV_SLEEP,
	ENV_NOT_RUNNABLE
};

// Special environment types
enum EnvType {
	ENV_TYPE_USER = 0,
	ENV_TYPE_THREAD,
	ENV_TYPE_IDLE,
};

struct Env {
	struct TrapFrame env_tf;	// Saved registers
	struct Env *env_link;		// Next free Env
	envid_t env_id;			// Unique environment identifier
	envid_t env_parent_id;		// env_id of this env's parent
	enum EnvType env_type;		// Indicates special system environments
	//enum EnvState env_status;		// Status of the environment
	int env_status;
	uint32_t env_runs;		// Number of times environment has run
	int sleep_time;
	int thread_num;
	int fcnt;
	Fstate file[NR_FILES];
	// Address space
	pde_t *env_pgdir;		// Kernel virtual address of page dir
};
struct Env kern_env;
extern struct Env*curenv;
struct Env* env_create();
void env_run(struct Env*);
void env_run2(struct Env*);
int fork();
#endif // !JOS_INC_ENV_H
