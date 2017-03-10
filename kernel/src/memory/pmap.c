#include"memlayout.h"
#include"x86.h"
#include"pmap.h"
#include "assert.h"
#include "string.h"
#include "jos/env.h"
#define E_NO_MEM 4
#define npage (1<<15)			// Amount of physical memory (in pages)
//const size_t npages=(1<<15);
// These variables are set in mem_init()
pde_t *kern_pgdir;		// Kernel's initial page directory
//struct PageInfo pages[npages];		// Physical page state array
struct PageInfo * pages;		// Physical page state array
static struct PageInfo *page_free_list;	// Free list of physical pages

static void
boot_map_region(pde_t *pgdir, uintptr_t va, unsigned long size, physaddr_t pa, int perm);
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create);

// --------------------------------------------------------------
// Tracking of physical pages.
// The 'pages' array has one 'struct PageInfo' entry per physical page.
// Pages are reference counted, and free pages are kept on a linked list.
// --------------------------------------------------------------
extern pde_t entry_pgdir[1024];
extern pte_t entry_pgtable[1024];
extern char bootstack[];
static void*
boot_alloc(uint32_t n)
{
	static char *nextfree;
	char *result;
	if(!nextfree)
	{
		extern char end[];
		nextfree=ROUNDUP((char*)end,PGSIZE);
	}
	result=nextfree;
	nextfree+=((ROUNDUP(n,PGSIZE))>>PGSHIFT)*PGSIZE;
	return result;
}

void mem_init()
{

	kern_pgdir=(pde_t*)boot_alloc(PGSIZE);
	memset(kern_pgdir,0,PGSIZE);
	pages=(struct PageInfo *)boot_alloc(npages*sizeof(struct PageInfo));
//	printk("adsf\n");
	uint32_t env_size=sizeof(struct Env)*NENV;
	extern struct Env* envs;
	envs=(struct Env*)boot_alloc(env_size);
	memset(envs,0,env_size);
	page_init();
	//printk("adsf\n");
	//printk("%d\n",npages);
	boot_map_region(kern_pgdir,UPAGES,ROUNDUP(npages*sizeof(struct PageInfo),PGSIZE),PADDR(pages),PTE_W|PTE_U);
	boot_map_region(kern_pgdir,UENVS,ROUNDUP(env_size,PGSIZE),PADDR(envs),PTE_W|PTE_U);
	boot_map_region(kern_pgdir,KERNBASE-KSTKSIZE,KSTKSIZE,PADDR(bootstack),PTE_W|PTE_U);
	boot_map_region(kern_pgdir,KERNBASE,ROUNDUP((0xffffffff-KERNBASE),PGSIZE),0,PTE_W|PTE_U);
	//boot_map_region(kern_pgdir,KERNBASE,npage*PGSIZE,0,PTE_W|PTE_U);
	
	//boot_map_region(kern_pgdir,0xc0000000,0xc0400000-0xc0000000,0x0,PTE_W|PTE_U);
	boot_map_region(kern_pgdir,0x0,0x100000,0x0,PTE_W|PTE_U);
	printk("%x %x %x\n",kern_pgdir,PADDR(kern_pgdir),entry_pgdir);
	lcr3(PADDR(kern_pgdir));
	uint32_t cr0=rcr0();
	cr0|=CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_MP;
	cr0 &=~(CR0_TS|CR0_EM);
	lcr0(cr0);
//	boot_map_region(kern_pgdir,KERNBASE,npages*PGSIZE,0,PTE_W);
//	printk("adsf\n");
}
/*
void
page_init(void)
{
	extern char end[];

	printk("pageinit %x\n",page_free_list);
	printk(" the start page %x\n",pa2page((physaddr_t)(end-0xc0000000+PGSIZE+npages*sizeof(struct PageInfo)+ROUNDUP(sizeof(struct Env)*1024,PGSIZE))) );
	printk(" the end page %x\n",&pages[npages-1]);
	size_t i = npages-1;	
	while( page_free_list!=pa2page((physaddr_t)(end-KERNBASE+PGSIZE+ROUNDUP(npages*sizeof(struct PageInfo),PGSIZE)+ROUNDUP(sizeof(struct Env)*NENV,PGSIZE))) ){	
		pages[i].pp_ref = 0;
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
		i--;
	}
	page_free_list = page_free_list -> pp_link;
	printk("the first page after page init %x\n",page2pa(page_free_list));
}*/

void
page_init(void)
{
	// The example code here marks all physical pages as free.
	// However this is not truly the case.  What memory is free?
	// 

	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
//	assert(0);
	unsigned long i;
	for (i = npages-1; i >=0x1c9; i--) {
		pages[i].pp_ref = 0;
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
	}
	struct PageInfo *pp=page_free_list;
	for(i=0;i<10;i++)
		pp=pp->pp_link;
	/*extern char end[];
	pages[1].pp_link=NULL;
	struct PageInfo* s=pa2page(IOPHYSMEM)-1;
	struct PageInfo* t=pa2page((int)end- KERNBASE+PGSIZE+npages*sizeof(struct PageInfo))+1;
	t->pp_link=s;*/
}

//
// Allocates a physical page.  If (alloc_flags & ALLOC_ZERO), fills the entire
// returned physical page with '\0' bytes.  Does NOT increment the reference
// count of the page - the caller must do these if necessary (either explicitly
// or via page_insert).
//
// Be sure to set the pp_link field of the allocated page to NULL so
// page_free can check for double-free bugs.
//
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset

struct PageInfo *
page_alloc(int alloc_flags)
{
	// Fill this function in
//	return 0;
	if(page_free_list==NULL)
		return NULL;
	struct PageInfo * temp=page_free_list;
	page_free_list=page_free_list->pp_link;
	if(alloc_flags& ALLOC_ZERO)
		memset(page2kva(temp),0,PGSIZE);
	return temp;
}
/*
//
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
*/
void
page_free(struct PageInfo *pp)
{
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
//	if(pp->pp_ref!=0||pp->pp_link!=NULL) return;
	pp->pp_link=page_free_list;
	page_free_list=pp;
}
/*
//
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
*/
void
page_decref(struct PageInfo* pp)
{
	if (--pp->pp_ref == 0)
		page_free(pp);
}
/*
// Given 'pgdir', a pointer to a page directory, pgdir_walk returns
// a pointer to the page table entry (PTE) for linear address 'va'.
// This requires walking the two-level page table structure.
//
// The relevant page table page might not exist yet.
// If this is true, and create == false, then pgdir_walk returns NULL.
// Otherwise, pgdir_walk allocates a new page table page with page_alloc.
//    - If the allocation fails, pgdir_walk returns NULL.
//    - Otherwise, the new page's reference count is incremented,
//	the page is cleared,
//	and pgdir_walk returns a pointer into the new page table page.
//
// Hint 1: you can turn a Page * into the physical address of the
// page it refers to with page2pa() from pmap.h.
//
// Hint 2: the x86 MMU checks permission bits in both the page directory
// and the page table, so it's safe to leave permissions in the page
// directory more permissive than strictly necessary.
//
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
*/
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
	// Fill this function in
	//return NULL;
	pte_t * temp=NULL;
//	printk("asdf\n");	
	if(pgdir[PDX(va)]==(pte_t)NULL)
	{
		if(create==0)
			return NULL;
		else
		{
			struct PageInfo * temp2=page_alloc(ALLOC_ZERO);
			if(temp2==NULL)	
				return NULL;
			else
			{
				temp2->pp_ref++;
				pgdir[PDX(va)]=page2pa(temp2)|PTE_P|PTE_W|PTE_U;
				temp=page2kva(temp2);
			}
		}
	}
	else
	{
		pte_t temp3=pgdir[PDX(va)];
		temp3=PTE_ADDR(temp3);
		temp=page2kva(pa2page(temp3));
//		temp = page2kva(pa2page(PTE_ADDR(pgdir[PDX(va)])));
	}
//	printk("asdf\n");	
	return &temp[PTX(va)];

}
/*
//
// Map [va, va+size) of virtual address space to physical [pa, pa+size)
// in the page table rooted at pgdir.  Size is a multiple of PGSIZE, and
// va and pa are both page-aligned.
// Use permission bits perm|PTE_P for the entries.
//
// This function is only intended to set up the ``static'' mappings
// above UTOP. As such, it should *not* change the pp_ref field on the
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
*/
static void
boot_map_region(pde_t *pgdir, uintptr_t va, unsigned long size, physaddr_t pa, int perm)
{
	// Fill this function in
	int i;
	pte_t *pte=NULL;
	for(i=0;i<size/PGSIZE;i++)
	{
	//	printk("1\n");
		pte=pgdir_walk(pgdir,(const void *)va+i*PGSIZE,1);
//		while(1);
//		if(i==19456) 
//			printk("2\n");	
		*pte=(PTE_ADDR(pa+i*PGSIZE))|PTE_P|perm;
	}
//	assert(0);
	//printk("adsf\n");
/*	for(i=0;i<size;i+=PGSIZE)
	{
	//if(i==0) printk("=========================================eeeeeeeeeeeeeeeeeeeee\n");
	//printk("1%d\n",i);
		pte_t* pte=pgdir_walk(pgdir,(void*)va,1);
	//printk("2:%x\n",pte);
		 *pte=pa|perm|PTE_P;
		 pa+=PGSIZE;va+=PGSIZE;
	 }*/
	// printk("adsf\n");
	 
}
/*
//
// Map the physical page 'pp' at virtual address 'va'.
// The permissions (the low 12 bits) of the page table entry
// should be set to 'perm|PTE_P'.
//
// Requirements
//   - If there is already a page mapped at 'va', it should be page_remove()d.
//   - If necessary, on demand, a page table should be allocated and inserted
//     into 'pgdir'.
//   - pp->pp_ref should be incremented if the insertion succeeds.
//   - The TLB must be invalidated if a page was formerly present at 'va'.
//
// Corner-case hint: Make sure to consider what happens when the same
// pp is re-inserted at the same virtual address in the same pgdir.
// However, try not to distinguish this case in your code, as this
// frequently leads to subtle bugs; there's an elegant way to handle
// everything in one code path.
//
// RETURNS:
//   0 on success
//   -E_NO_MEM, if page table couldn't be allocated
//
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
*/
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
	// Fill this function in
	//return 0;
	//pte_t* pte;
	pte_t * pte=pgdir_walk(pgdir,va,0);
	if(pte!=NULL)	page_remove(pgdir,va);
	pte=pgdir_walk(pgdir,va,1);
	if(pte==NULL)	return -E_NO_MEM;
	*pte=page2pa(pp)|perm|PTE_P;
	pp->pp_ref++;
	tlb_invalidate(pgdir,va);
	return 0;
}
/*
//
// Return the page mapped at virtual address 'va'.
// If pte_store is not zero, then we store in it the address
// of the pte for this page.  This is used by page_remove and
// can be used to verify page permissions for syscall arguments,
// but should not be used by most callers.
//
// Return NULL if there is no page mapped at va.
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
*/
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
	// Fill this function in
	//return NULL;
	pte_t* pte=pgdir_walk(pgdir,va,0);
	if(pte==NULL)	return NULL;
	if(pte_store!=NULL)	*pte_store=pte;
	if(*pte!=0)	return pa2page(PTE_ADDR(*pte));
	else	return NULL;
}
/*
//
// Unmaps the physical page at virtual address 'va'.
// If there is no physical page at that address, silently does nothing.
//
// Details:
//   - The ref count on the physical page should decrement.
//   - The physical page should be freed if the refcount reaches 0.
//   - The pg table entry corresponding to 'va' should be set to 0.
//     (if such a PTE exists)
//   - The TLB must be invalidated if you remove an entry from
//     the page table.
//
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
*/
void
page_remove(pde_t *pgdir, void *va)
{
	// Fill this function in
	pte_t* pte=0;
	struct PageInfo* page=page_lookup(pgdir,va,&pte);
	if(page!=NULL) 
		page_decref(page);
	*pte=0;
	tlb_invalidate(pgdir,va);
	
}
/*
//
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
*/
void
tlb_invalidate(pde_t *pgdir, void *va)
{
	// Flush the entry only if we're modifying the current address space.
	// For now, there is only one address space, so always invalidate.
	invlpg(va);
}
