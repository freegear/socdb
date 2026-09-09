#ifndef _OR1K_DELAY_H
#define _OR1K_DELAY_H

extern unsigned long loops_per_sec;
#include <linux/kernel.h>
#include <linux/config.h>

/*
 * Copyright (C) 1994 Hamish Macdonald
 *
 * Delay routines, using a pre-computed "loops_per_second" value.
 */


extern __inline__ void __delay(unsigned long loops)
{
	__asm__ __volatile__ ("1: l.sfeqi %0,0; \
				l.bnf	1b; \
				l.addi %0,%0,-1;"
				: "=r" (loops) : "0" (loops));
}

extern __inline__ void udelay(unsigned long usecs)
{
	/* Sigh */
	__delay(usecs);
}

#define muldiv(a, b, c)    (((a)*(b))/(c))

/*
extern __inline__ unsigned long muldiv(unsigned long a, unsigned long b, unsigned long c)
{
	unsigned long tmp;

	__asm__ ("mulul %2,%0:%1; divul %3,%0:%1"
		: "=d" (tmp), "=d" (a)
		: "d" (b), "d" (c), "1" (a));
	return a;
}
*/

#endif /* defined(_OR1K_DELAY_H) */
