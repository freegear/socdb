/*
 *   FILE: ptrace.h
 * AUTHOR: kma
 *  DESCR: 
 */

#ifndef PTRACE_H
#define PTRACE_H

#ident "$Id: ptrace-kma.h,v 1.1.1.1 2001/09/10 07:44:41 simons Exp $"

/*
 * Always get the AC, PC
 */
struct pt_regs {
	long	PC;
	long	AC;
};

#endif
