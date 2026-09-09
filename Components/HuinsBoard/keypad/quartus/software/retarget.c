/*
* 	This provides implementations of _sys_exit(), _ttywrch() and ___stackheap(), which are
*	the bare minimum required to enable use of the ARM C libraries. Only some of the 
*	functionality of the libraries is available, you may need to add more low level functions 
* 	if you get the linker error below.
*
*	Error   : L6200E: Symbol __semihosting_swi_guard multiply defined (by use_semi.o and use_no_semi.o).
*
*	Please see Chapter 4 of the ARM Developer Suite Tools guide for more information
*
*	In addition there are implementations of fputc and fgetc in the file uartcomm.c
*	so printf should be available.	
*
*	Author:	Paul 
*	=========================================================
*
* 	This is based opon the embed/rom example supplied with the ARM Developer Suite, so
*	it's partly 
*
* 	Copyright (C) ARM Limited, 1999. All rights reserved.
*
*	and partly 
*
* 	Copyright (c) Altera Corporation 2000-2001.
* 	All rights reserved.
*
*/

#include <stdio.h>
#include <rt_misc.h>

#ifdef __thumb
/* Thumb Semihosting SWI */
#define SemiSWI 0xAB
#else
/* ARM Semihosting SWI */
#define SemiSWI 0x123456
#endif

/* Exit */
__swi(SemiSWI) void _Exit(unsigned op, unsigned except);
#define Exit() _Exit (0x18,0x20026)

void _sys_exit(int return_code)
{
    Exit();         /* for debugging */

label:  goto label; /* endless loop */
}

void _ttywrch(int ch)
{
	/* 
	*	This function is supposed to output a character to the console
	*	given that we don't have one, we can't really do very much
	*/
}

__value_in_regs struct __initial_stackheap __user_initial_stackheap(
        unsigned R0, unsigned SP, unsigned R2, unsigned SL)
{
    extern unsigned int Image$$ZI$$Limit;
    
    struct __initial_stackheap config;
    
    /* Start the Heap at the end of the zero initialised data */    
    config.heap_base = (unsigned int)&Image$$ZI$$Limit;
    config.stack_base = SP;
    
    return config;
}






