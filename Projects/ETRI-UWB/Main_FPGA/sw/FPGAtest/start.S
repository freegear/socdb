/*
 * start.S: start code
 *
 */

// #define INIT_CACHE

.text

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
  ldr  r1 , =0x30001008		// GPIO_OE
  ldr  r3 , =0x00001235		// 0xdead
  str  r3 , [r1]
	msr CPSR,#0xD3 ;
	
	/* Initialize Stack Area */	
	/* bl InitStacks */
	LDR  r3 , L_SVCStack	 ; /* Usr Stack Initialzie */
	mov  sp , r3 
	
		
#if 0		
	/* IRQ mode Stack */
	mov r2   ,  #0xd2           /* No Interrupt and IRQ Mode */
	MSR cpsr , r2
	LDR r13  , L_IRQStack
  
	/* User Mode Stack */
	mov r2  , #0xdf             /* Set System mode 
                                 user mode is shar register file with system mode */
	MSR cpsr , r2
	LDR r13  , L_UsrStack

#endif

/*********************************************************/
#define INIT_CACHE
#ifdef INIT_CACHE   // Kevin Im
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
	ldr	r1, =0x00000003	// region 0 : full access
	str	r1, [r0]
		
	ldr	r0, =0xffff8504	// instruction memory protection register
	ldr     r1, =0x0000000F	// region 0,1 :full access
	str     r1, [r0]
		
	ldr	r0, =0xffff8200	// Data cachable register
    ldr     r1, =0x00000000	// all region: not-cachable
	str     r1, [r0]

	ldr	r0, =0xffff8300	// Write buffer control
	ldr	r1, =0x00000000	// all region: not-bufferable
	str	r1, [r0]
	
	ldr	r0, =0xffff8204	// Instruction cachable register
	ldr     r1, =0x00000002	// region 1: cachable
	str     r1, [r0]
		
	ldr	r0, =0xffff8620	// instruction protection region 0 address
	ldr	r1, =0x0000003F	// Base(0x00000), size(4GB) region enable
	str	r1, [r0]

	ldr	r0, =0xffff8624	// instruction protection region 1 address
	ldr	r1, =0x00000033	// Base(0x00000), size(64M) region enable
	str	r1, [r0]

	ldr	r0, =0xffff8600	// data protection region 0 address
	ldr     r1, =0x0000003F	// Base(0x00000000), size(4GB) region Enable
	str     r1, [r0]

	ldr	r0, =0xffff8100	// control register
	ldr	r1, =0x00001001	// protection unit disable, DCache disable/ICache enable
				// 12 :	 I :	1 : I Cache Enable
				// 7  :	 B :	0 : Little Endian
				// 2  :	 C :	0 : Dcache Disable
				// 1  :	 A :	Alignment fault check disable
				// 0  :	 P :	1 : Protection unit Enable
	str	r1, [r0]

End_Of_Cache_init:	
#endif
	
	
	/* Disable FIQ & IRQ */
	mrs r1,cpsr
	orr r1,r1,#0xC0
	msr cpsr ,r1

#define SRAMTEST
#ifdef SRAMTEST

/* SRAMTEST */
	ldr r0, =0x10000000			// RAM Start Addr
	ldr r1, =0x00003FFF			// 16KWord(64KB)
	ldr r2, =0x00000000			// test data
	// store data
1:
	str r2, [r0]
	add r2, r2, #1
	add r0, r0, #4
	sub r3, r2, r1 
	cmp r3, #0
	bne 1b

	ldr r0, =0x10000000			// RAM Start Addr
	ldr r2, =0x00000000			// test data
2:
	ldr r3, [r0]
	sub r3, r2, r3
	cmp r3, #0
	bne 3f						// error !
	add r2, r2, #1
	add r0, r0, #4
	sub r3, r2, r1
	cmp r3, #0
	bne 2b

	b 4f
3:
	ldr  r1 , =0x30001008		// GPIO_OE
	ldr  r3 , =0x0000deae		// 0xdead
	str  r3 , [r1]
	b 3b
4:

#endif



#if 0
/*InitializeDDRCtrl*/

	ldr 	r1, =0x20002000 // DDR BASE ADDRESS
	ldr	r2, =0x0001b92a // DDRTCON setting value

	str 	r2, [r1]	// DDRTCON setting

	ldr	r2, =0x10	// DDRDLL register
	add	r2, r1, r2	// DDRDLL register

	ldr	r3, =0x24	// DDRDLL setting value

	str	r3, [r2]	// DDRDLL setting

	ldr	r2, =0x0c	// DDRREF register
	add	r2, r1, r2	// DDRREF register

	ldr	r3, =0x410	// DDRREF setting value
	
	str	r3, [r2]	// DDRREF setting

		
	ldr	r2, =0x04	// DDRCON register
	add	r2, r1, r2	// DDRCON register

	ldr  	r3, =0xA1	// DDRCON setting value

	str	r3, [r2]	// DDRCON setting


	ldr  r1 , =0x30001008		// GPIO_OE
	ldr  r3 , =0x0000ddee		// 0xdead
	str  r3 , [r1]


#endif
	/* copy data section into RAM */
	.extern ___shadow_data
	.extern ___data_reload
	.extern ___data_size

	ldr r0, =___shadow_data
	ldr r1, =___data_reload
	ldr r2, =___data_size

	mov r2, r2, lsr #2	/* divide by 4 */
	cmp r2, #0
	beq 2f
1:
	ldr r3, [r0]
	str r3, [r1]
	add r0, r0, #4
	add r1, r1, #4
	subs r2, r2, #1
	bne 1b
2:

	.extern __bss_start
	.extern __bss_end
	/* clearing BSS section */
	ldr r0, =__bss_start
	ldr r1, =__bss_end
	ldr r3, =0

	sub r2, r1, r0
	mov r2, r2, lsr #2	/* divide by 4 */
	cmp r2, #0
	beq 2f
1:
	str r3, [r0]
	add r0, r0, #4
	subs r2, r2, #1
	bne 1b
2:

.extern main
goto_main:	bl main

L_UsrStack : .word _stack
L_IRQStack : .word _irq_stack
L_SVCStack : .word _svc_stack

L_gpio_data : .word 0x2000B008
	
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

	mov	r6, #8
	b endless_blink
	/*****************************************/
/*
	stmfd sp!, {r0-r12, lr} 
	bl	InterruptServiceRoutine
	ldmfd sp!, {r0-r12, lr} 
	subs	pc, lr, #0x04
*/
	
	
fiq:
	mov	r6, #9
	
endless_blink:	
/*
  ldr  r1 , =0x30001000		// GPIO_OE
  ldr  r2 , =0x0000ffff		// output enable
  ldr  r3 , =0x0000dead		// 0xdead
  str  r2 , [r1]			// 16bit output enable
  add  r4 , r1, #0x08		// GPIO_OUTPUT
  str  r3 , [r4]
*/
	b	endless_blink

/*************************************************/
