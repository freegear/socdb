	.global __text_start
	.global __main
	.global __bss_start
	.global __bss_end
	.global __ram_start
	.global __ram_end
	.global __rom_start
	.global __rom_end
	.global __data_start
	.global __data_end

	.global splash_bits
	.global _start
	.global _stext

#define DEBUG
#define ROM_OFFSET 0x10C00000
#define STACK_GAURD 0x10

	.data
splash_bits:
#include "bootlogo.rh"

	.text
	
_start:
_stext:
	/* At this point, %a0 contains a pointer to the
	   list of pages, which are in order but not
	   necessarily contiguous.  We have to move
	   things around, set up the stack and get into
	   the kernel.  PalmOS has done much of the hard
	   work for us setting up the hardware */

	movew	#0x2700, %sr            /* Exceptions off! */
	movew	#0x2400, 0xfffff200	/* PLLCR */
	movew	#0x0123, 0xfffff202	/* PLLFSR */
	moveb	#0x1f,   0xfffff207	/* Full power */

	/* Init chip registers.  PalmV specific */
        /* PalmOS has setup the device.  We just get on with it */

	movel   #splash_bits, 0xfffffA00 /* LSSA */

        moveb   #0x20,   0xfffff419	/* ForceON RS232 driver */
	moveb	#0x08,   0xfffff906	/* Ignore CTS */
	movew	#0x00c0, 0xfffff908	/* No, not Fscking IrDA */
	movew	#0x010b, 0xfffff902	/* BAUD to 9600 */
	movew	#0xe100, 0xfffff900	/* enable */

	movew	#16384, %d0  /* PLL settle wait loop */
L0:
	subw	#1, %d0
	bne	L0

	/* My parts are scattered, %a0 has a list.  Make me whole */
	moveal	#0x1400, %a2		/* FIXME: Hard coded load address */
	moveal	%a0@+, %a1		/* Move to page 1 (this is page 0) */
mvlp0:
#ifdef DEBUG
	moveq	#70, %d7		/* 'F' */
	moveb	%d7,0xfffff907          /* No absolute addresses */
pclp1:
	movew	0xfffff906, %d7
	andw	#0x2000, %d7
	beq	pclp1
#endif /* DEBUG */
	movew	#1024, %d6
	moveal	%a0@+, %a1
	movel	%a1, %d0
	beq	mvdone
mvlp1:
	movel	%a1@+, %d0
	movel	%d0, %a2@+
	subw	#1, %d6
#if 1
	bne	mvlp1
	bra	mvlp0
#endif
mvdone:

#ifdef DEBUG
	moveq	#82, %d7		/* 'R' */
	moveb	%d7,0xfffff907          /* No absolute addresses */
pclp3:
	movew	0xfffff906, %d7
	andw	#0x2000, %d7
	beq	pclp3
#endif /* DEBUG */
	moveal	#0x001ffff0, %ssp
	moveal	#__bss_start, %a0
	moveal	#__bss_end, %a1

	/* Copy 0 to %a0 until %a0 >= %a1 */
L1:
	movel	#0, %a0@+
	cmpal	%a0, %a1
	bhi	L1

#ifdef DEBUG
	moveq	#67, %d7                /* 'C' */
	jsr	putc
#endif /* DEBUG */

	pea	0
	pea	env
	pea	%sp@(4)
	pea	0

#ifdef DEBUG
	moveq	#70, %d7		/* 'F' */
	jsr	putc
#endif /* DEBUG */

lp:
	jsr	start_kernel
        jmp lp
_exit:

	jmp	_exit

__main:
	/* nothing */
	rts

#ifdef DEBUG
putc:
	moveb	%d7,0xfffff907
pclp:
	movew	0xfffff906, %d7
	andw	#0x2000, %d7
	beq	pclp
	rts
#endif /* DEBUG */

	.data
env:
	.long	0
