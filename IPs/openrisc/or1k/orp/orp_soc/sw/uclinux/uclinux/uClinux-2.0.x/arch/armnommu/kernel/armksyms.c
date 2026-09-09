#include <linux/config.h>
#include <linux/module.h>
#include <linux/user.h>
#include <linux/string.h>
#include <linux/mm.h>
#include <linux/mman.h>

#include <asm/ecard.h>
#include <asm/io.h>
#include <asm/delay.h>
#include <asm/dma.h>
#include <asm/pgtable.h>
#define __need_memcpy_tofs
#include <asm/segment.h>
#include <asm/semaphore.h>

extern void dump_thread(struct pt_regs *, struct user *);
extern int dump_fpu(struct pt_regs *, struct user_fp_struct *);

/*
 * libgcc functions - functions that are used internally by the
 * compiler...  (prototypes are not correct though, but that
 * doesn't really matter since they're not versioned).
 */
extern void __gcc_bcmp(void);
extern void __ashldi3(void);
extern void __ashrdi3(void);
extern void __cmpdi2(void);
extern void __divdi3(void);
extern void __divsi3(void);
extern void __lshrdi3(void);
extern void __moddi3(void);
extern void __modsi3(void);
extern void __muldi3(void);
extern void __negdi2(void);
extern void __ucmpdi2(void);
extern void __udivdi3(void);
extern void __udivmoddi4(void);
extern void __udivsi3(void);
extern void __umoddi3(void);
extern void __umodsi3(void);

extern void inswb(unsigned int port, void *to, int len);
extern void outswb(unsigned int port, const void *to, int len);

/*
 * floating point math emulator support.
 * These will not change.  If they do, then a new version
 * of the emulator will have to be compiled...
 * fp_current is never actually dereferenced - it is just
 * used as a pointer to pass back for send_sig().
 */
extern void (*fp_save)(unsigned char *);
extern void (*fp_restore)(unsigned char *);
extern void fp_setup(void);
extern void fpreturn(void);
extern void fpundefinstr(void);
extern void fp_enter(void);
#if 0
extern void fp_printk(void);
extern struct task_struct *fp_current;
extern void fp_send_sig(int);
#endif

static struct symbol_table arch_symbol_table = {
#include <linux/symtab_begin.h>
	/*
	 * platform dependent support
	 */
	X(dump_thread),
	X(dump_fpu),
	X(udelay),
	X(xchg_str),

	/*
	 * expansion card support
	 */
#ifdef CONFIG_ARCH_ACORN
	X(ecard_startfind),
	X(ecard_find),
	X(ecard_readchunk),
	X(ecard_address),
#endif

	/* processor dependencies */
	X(processor),

	/* io */
	X(outswb),
	X(outsw),
	X(inswb),
	X(insw),

#ifndef __virt_to_phys__is_a_macro
	X(__virt_to_phys),
#endif
#ifndef __phys_to_virt__is_a_macro
	X(__phys_to_virt),
#endif
#ifndef __virt_to_bus__is_a_macro
	X(__virt_to_bus),
#endif
#ifndef __bus_to_virt__is_a_macro
	X(__bus_to_virt),
#endif

	/* dma */
	X(dma_str),
	X(enable_dma),
	X(disable_dma),
	X(set_dma_addr),
	X(set_dma_count),
	X(set_dma_mode),
	X(get_dma_residue),
	X(set_dma_sg),

	/*
	 * floating point math emulator support.
	 * These symbols will never change their calling convention...
	 */
	XNOVERS(fpreturn),
	XNOVERS(fpundefinstr),
	XNOVERS(fp_enter),
	XNOVERS(fp_save),
	XNOVERS(fp_restore),
	XNOVERS(fp_setup),
#if 0
	XNOVERS(fp_printk),
	XNOVERS(fp_current),
	XNOVERS(fp_send_sig),
#endif
	/*
	 * string / mem functions
	 */
	XNOVERS(strcpy),
	XNOVERS(strncpy),
	XNOVERS(strcat),
	XNOVERS(strncat),
	XNOVERS(strcmp),
	XNOVERS(strncmp),
	XNOVERS(strchr),
	XNOVERS(strlen),
	XNOVERS(strnlen),
	XNOVERS(strspn),
	XNOVERS(strpbrk),
	XNOVERS(strtok),
	XNOVERS(strchr),
	XNOVERS(strrchr),
	XNOVERS(memset),
	XNOVERS(memcpy),
	XNOVERS(memmove),
	XNOVERS(memcmp),
	XNOVERS(memscan),
	XNOVERS(memzero),

	/* user mem (segment) */
	XNOVERS(put_user_long),
	XNOVERS(get_user_long),
	XNOVERS(put_user_word),
	XNOVERS(get_user_word),
	XNOVERS(put_user_byte),
	XNOVERS(get_user_byte),
	XNOVERS(memcpy_fromfs),
	XNOVERS(memcpy_tofs),
	XNOVERS(__memcpy_tofs),

	/* gcc lib functions */
	XNOVERS(__gcc_bcmp),
	XNOVERS(__ashldi3),
	XNOVERS(__ashrdi3),
	XNOVERS(__cmpdi2),
	XNOVERS(__divdi3),
	XNOVERS(__divsi3),
	XNOVERS(__lshrdi3),
	XNOVERS(__moddi3),
	XNOVERS(__modsi3),
	XNOVERS(__muldi3),
	XNOVERS(__negdi2),
	XNOVERS(__ucmpdi2),
	XNOVERS(__udivdi3),
	XNOVERS(__udivmoddi4),
	XNOVERS(__udivsi3),
	XNOVERS(__umoddi3),
	XNOVERS(__umodsi3),

	/* bitops */
	XNOVERS(set_bit),
	XNOVERS(clear_bit),
	XNOVERS(change_bit),
	XNOVERS(find_first_zero_bit),
	XNOVERS(find_next_zero_bit),

	/* semaphores */
	X(__down_interruptible),
#include <linux/symtab_end.h>
};

void arch_syms_export(void)
{
	register_symtab(&arch_symbol_table);
}
