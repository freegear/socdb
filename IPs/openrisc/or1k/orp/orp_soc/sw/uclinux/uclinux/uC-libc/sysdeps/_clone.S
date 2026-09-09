/* Adapted from glibc */
/* Copyright (C) 1996, 1997 Free Software Foundation, Inc. */

/* clone is even more special than fork as it mucks with stacks
   and invokes a function in the right context after its all over.  */

#include <sysdep.h>
#include <linux/errno.h>

/* int _clone(int (*fn)(void *arg), void *child_stack, int flags, void *arg); */
 
        .text
ENTRY (_clone)

        /* Sanity check arguments.  */
	l.addi	r11,r0,-EINVAL
	l.sfeqi	r3,0
	l.bf	syscall_error
	l.nop
	l.sfeqi	r4,0
	l.bf    syscall_error
        l.nop

        /* Do the system call */
        l.addi	r7,r3,0                 /* save r3 (fn) */
	l.addi	r3,r5,0
	l.addi	r11,r0,__NR_clone
	l.sys	1
	l.nop
	l.sfeqi r11,0
	l.bf	thread_start
	l.nop
	l.jr	r9
	l.nop
	
syscall_error:
	l.jr	r9
	l.nop

thread_start:
	l.addi	r3,r6,0
	l.jalr	r7
	l.nop
	l.addi	r3,r11,0
	l.addi	r11,r0,__NR_exit
	l.sys	1
	l.nop

