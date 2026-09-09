/*
 * include/asm-or1k/processor.h
 *
 * Copyright (C) 1995 Hamish Macdonald
 */

#ifndef __ASM_OR1K_PROCESSOR_H
#define __ASM_OR1K_PROCESSOR_H

#include <linux/config.h>
#include <asm/segment.h>

/*
 * User space process size: 3.75GB. This is hardcoded into a few places,
 * so don't change it unless you know what you are doing.
 */
/*#define TASK_SIZE	(0xF0000000UL)*/

/*
 * Bus types
 */
#define EISA_bus__is_a_macro	1
#define EISA_bus 0
#define MCA_bus__is_a_macro	1
#define MCA_bus 0

/*
 * The or1k has no problems with write protection
 */
#define wp_works_ok__is_a_macro	1
#define wp_works_ok 1

/* MAX floating point unit state size (FSAVE/FRESTORE) */
#define FPSTATESIZE   (216/sizeof(unsigned char))

struct thread_struct {
	unsigned long  pc;		/* PC when last entered system */
	unsigned long  sr;		/* saved status register */
	unsigned long  ksp;		/* kernel stack pointer */
	unsigned long  usp;		/* user stack pointer */
	unsigned long  *regs;		/* pointer to saved register state */
	unsigned short fs;		/* saved fs (sfc, dfc) */
	unsigned long  crp[2];		/* cpu root pointer */
	unsigned long  esp0;		/* points to SR of stack frame */
	unsigned long  fp[8*3];
	unsigned long  fpcntl[3];	/* fp control regs */
	unsigned char  fpstate[FPSTATESIZE];  /* floating point state */
};

#define INIT_MMAP { &init_mm, 0, 0x40000000, __pgprot(_PAGE_PRESENT|_PAGE_ACCESSED), VM_READ | VM_WRITE | VM_EXEC }

#define INIT_TSS  { 	0x100,\
			(SPR_SR_EIR | SPR_SR_EXR | SPR_SR_SUPV), \
			sizeof(init_kernel_stack) + (long) init_kernel_stack, \
}

#define alloc_kernel_stack()    __get_free_page(GFP_KERNEL)
#define free_kernel_stack(page) free_page((page))

#define SR_USER (SPR_SR_EIR | SPR_SR_EXR)
/*
 * Do necessary setup to start up a newly executed thread.
 */
static inline void start_thread(struct pt_regs * regs, unsigned long pc, unsigned long usp)
{
#ifndef NO_MM
	unsigned long nilstate = 0;
#endif

	/* reads from user space */
	set_fs(USER_DS);

	regs->pc = pc;
	regs->sp = usp;
	regs->sr = SR_USER;
}

#ifndef CONFIG_COLDFIRE
static inline void tron(void)
{
	__asm__ __volatile__ ("
	oriw #0x8000, %sr
	");	
}

static inline void troncof(void)
{
	__asm__ __volatile__ ("
	oriw #0x4000, %sr
	");		
}

static inline void troff(void)
{
	__asm__ __volatile__ ("
	andiw #0x3fff, %sr
	");
}
#endif

/*
 * Return saved PC of a blocked thread.
 */
extern inline unsigned long thread_saved_pc(struct thread_struct *t)
{
	/*extern unsigned long high_memory;*/
	unsigned long frame = ((struct switch_stack *)t->ksp)->a6;
	/*if (frame > PAGE_SIZE && frame < high_memory)*/
		return ((unsigned long *)frame)[1];
	/*else
		return 0;*/
}

#endif
