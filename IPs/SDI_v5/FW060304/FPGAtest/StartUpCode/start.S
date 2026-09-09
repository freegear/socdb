/*
 * start.S: blob start code
 *
 * Copyright (C) 1999 2000 2001 Erik Mouw (J.A.K.Mouw@its.tudelft.nl) and
 *                     Jan-Derk Bakker (J.D.Bakker@its.tudelft.nl)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */
/*
 * This is the blob start code. The SA-1100 jumps to address 0x00000000
 * after a reset. We put a single branch code at this position which jumps
 * to a safe region to do the actual setup. All other vectors just point
 * to an endless loop for the moment.
 *
 * Documentation:
 * [1] Intel Corporation, "Intel StrongARM SA-1100 Microprocessor
 *     Developer's Manual", April 1999
 * [2] S. Furber, "ARM System Architecture", Addison Wesley Longman
 *     Ltd., Essex, England, 1996.
 * [3] Intel Corporation, "Intel StrongARM SA-1110 Microprocessor
 *     Advanced Developer's manual, December 1999"
 */


/* Jump vector table as in table 3.1 in [1] */
.globl _start

_start:	b	reset
	ldr	pc, _undefined_instruction
	ldr	pc, _software_interrupt
	ldr	pc, _prefetch_abort
	ldr	pc, _data_abort
	ldr	pc, _not_used
	ldr	pc, _irq
	ldr	pc, _fiq

_undefined_instruction:	.word undefined_instruction
_software_interrupt:	.word software_interrupt
_prefetch_abort:	.word prefetch_abort
_data_abort:		.word data_abort
_not_used:		.word not_used
_irq:			.word irq
_fiq:			.word fiq



	
/*************************************************/

/* the actual reset code */
reset:
	msr CPSR,#0xD3 ;

	/* Initialize Stack Area */	
	/* bl InitStacks */
	LDR  r3 , L_SVCStack	 ; /* Usr Stack Initialzie */
	mov  sp , r3 
		

	/* IRQ mode Stack */
	mov r2   ,  #0xd2           /* No Interrupt and IRQ Mode */
	MSR cpsr , r2
	LDR r13  , L_IRQStack
  
	/* User Mode Stack */
	mov r2  , #0xdf             /* Set System mode 
                                 user mode is shar register file with system mode */
	MSR cpsr , r2
	LDR r13  , L_UsrStack

    mov     r2, #33292288   
    add     r2, r2, #229376 
    add     r2, r2, #256    
    mvn     r3, #-268435456 
    sub     r3, r3, #258048 
    str     r3, [r2]
    mov     r3, #33292288   
    add     r3, r3, #229376 
    add     r3, r3, #260    
    ldr     r2, [pc, #44]   
    str     r2, [r3]
    mov     r3, #33292288   
    add     r3, r3, #229376 
    add     r3, r3, #264    
    ldr     r2, [pc, #24]   
    str     r2, [r3]
    mov     r3, #33292288   
    add     r3, r3, #229376 
    add     r3, r3, #268    
    ldr     r2, [pc, #8]    
    str     r2, [r3]


CACHE_Initaizlie:	

	/* ICache enable */	
	ldr	r0, =0xffff8100	// control register
	ldr     r1, =0x00000000	// protection unit disable, DCache/ICache disable
				// 12 :	 I :	0 : I Cache Disable
				// 7  :	 B :	0 : Little Endian
				// 2  :	 C :	0 : Dcache Disable
				// 1  :	 A :	Alignment fault check disable
				// 0  :	 P :	0 : Protection unit disable
	str r1, [r0]

	ldr	r0, =0xffff8500	// data memory protection register
	ldr	r1, =0x0000003F	// region0,1,2 :full access
	str	r1, [r0]
		
	ldr	r0, =0xffff8504	// instruction memory protection register
	ldr     r1, =0x00000003	// region0 :full access
	str     r1, [r0]
		
#if 0	/* write back cache */
	ldr	r0, =0xffff8200	// Data cachable register
    ldr     r1, =0x00000001	// region0:  cachable
	str     r1, [r0]

	ldr	r0, =0xffff8300	// Write buffer control
	ldr	r1, =0x00000000	// region0:bufferable
	str	r1, [r0]
	
#else	/* write through cache */
	ldr	r0, =0xffff8200	// Data cachable register
	ldr	r1, =0x00000001	// region0:cachable
	str	r1, [r0]
		
	ldr	r0, =0xffff8300	// Write buffer control
	ldr	r1, =0x00000000	// region0:not-bufferable
	str	r1, [r0]
#endif
		
	ldr	r0, =0xffff8204	// Instruction cachable register
	ldr     r1, =0x00000001	// region0:cachable
	str     r1, [r0]
		
	ldr	r0, =0xffff8620	// instruction protection region 0 address
	ldr	r1, =0x00000037	// Base(0x00000), size(128M) region enable
	str	r1, [r0]

	#ldr	r0, =0xffff8624	// instruction protection region 1 address
	#ldr	r1, =0x0000003F	// Base(0x00000), size(4GB) region enable
	#str	r1, [r0]

	ldr	r0, =0xffff8600	// data protection region 0 address
	ldr     r1, =0x00000037	// Base(0x00000000), size(256MB) region Enable
	str     r1, [r0]

	ldr	r0, =0xffff8604	// data protection region 1 address
	ldr     r1, =0x50000037	// Base(0x50000000), size(256MB) region Enable
	str     r1, [r0]

	ldr	r0, =0xffff8608	// data protection region 2 address
	ldr     r1, =0x40000037	// Base(0x40000000), size(256MB) region Enable
	str     r1, [r0]

//	ldr	r0, =0xffff8604	// data protection region 1 address
//	ldr r1, =0x0200002A	// Base(0x02000), size(4MB : for PIC) region Disable
//	str r1, [r0]

//       ldr	r0, =0xffff8608	// data protection region 2 address
//	ldr r1, =0x0080002A	// Base(0x00800), size(4MB) region disable
//	str r1, [r0]

//		ldr	r0, =0xffff860C	// data protection region 3 address
//		ldr r1, =0x00c0002B	// Base(0x00c00), size(4MB) region enable
//		str r1, [r0]

	ldr	r0, =0xffff8100	// control register


	//ldr	r1, =0x00000000	// protection unit disable, DCache/ICache disable
	//ldr	r1, =0x00001009	// protection unit disable, DCache/ICache disable
	ldr	r1, =0x0000501b	// protection unit disable, DCache/ICache disable
				// 12 :	 I :	0 : I Cache Disable
				// 7  :	 B :	0 : Little Endian
				// 2  :	 C :	0 : Dcache Disable
				// 1  :	 A :	Alignment fault check disable
				// 0  :	 P :	0 : Protection unit disable
	str	r1, [r0]

End_Of_Cache_init:	
	
	bl Enable_IRQ 
	bl Disable_FIQ		
  
.global _etext
.extern _etext
	
	bl __main

        
goto_main:		
	/****************************************/
	/* blob is copied to ram, so jump to it */
	bl Main

L_edata :	.word _edata
L_end   :	.word _end

L_etext		:	.word _etext
L_data_reload	:	.word _data_reload

L_UsrStack : .word _stack
L_IRQStack : .word _irq_stack
L_SVCStack : .word _svc_stack


/* Disable Interrupt */

.global 	Disable_IRQ

Disable_IRQ:
	  nop
	  stmfd sp!, {r1} 
	  MRS r1 , cpsr 
	  ORR r1,r1,#0x80
	  MSR cpsr,r1
	
	  ldmfd sp!, {r1} 
	  mov pc,lr


      
.global 	Disable_FIQ
Disable_FIQ:
	  nop
	  stmfd sp!, {r1} 
	  MRS r1,cpsr
	  ORR r1,r1,#0x40
	  MSR cpsr ,r1
	  ldmfd sp!, {r1} 
	  mov pc,lr
	

.global   Enable_IRQ
Enable_IRQ:
	  nop
	  stmfd sp!, {r1} 
	  MRS r1 , cpsr 
	  BIC r1,r1,#0x80
	  MSR cpsr,r1
	
	  ldmfd sp!, {r1} 
	  mov pc,lr
	
		
undefined_instruction:
	mov	r6, #3
	b	endless_blink

software_interrupt:
	mov	r6, #4
	b	endless_blink

prefetch_abort:
	mov	r6, #5
	b	endless_blink

data_abort:
	mov	r6, #6
	b	endless_blink

not_used:
	/* we *should* never reach this */
	mov	r6, #7
	b	endless_blink

irq:
	/*****************************************/
	stmfd sp!, {r0-r12, lr} 
	bl	InterruptServiceRoutine
	ldmfd sp!, {r0-r12, lr} 
	subs	pc, lr, #0x04
	
	
fiq:
	mov	r6, #9
	
endless_blink:	
/*
  LDR  r1 , L_gpio_data;
  STR  r6 , [r1]
  */
  	
b	endless_blink

/*************************************************/
