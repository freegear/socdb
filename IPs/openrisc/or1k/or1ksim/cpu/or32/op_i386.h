/* op_i386.h -- i386 specific support routines for micro operations
   Copyright (C) 2005 György `nog' Jeney, nog@sdf.lonestar.org

This file is part of OpenRISC 1000 Architectural Simulator.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. */

#define OP_JUMP(x) asm("jmp *%0" : : "rm" (x))

#define FORCE_RET asm volatile ("")

/* Does a function call (with no arguments) makeing sure that gcc doesn't peddle
 * the stack. (FIXME: Is this safe??) */
#define SPEEDY_CALL(func) asm("call "#func"\n")

/* Return out of the recompiled code */
asm(
"	.align 2\n"
"	.p2align 4,,15\n"
".globl op_do_jump\n"
"	.type	op_do_jump,@function\n"
"op_do_jump:\n"
"	ret\n"
"	ret\n"
"1:\n"
"	.size	op_do_jump,1b-op_do_jump\n"
);

