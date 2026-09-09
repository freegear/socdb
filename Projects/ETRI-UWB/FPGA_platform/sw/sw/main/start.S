/*
 * start.S: start code
 *
 */

#define ENABLE_ICACHE
//#define SRAMTEST
//#define DDR_BOOT
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
	ldr  r1 , =0x50002008		// GPIO_OUTL
	ldr  r3 , =0x00001235		// 0x1235
	str  r3 , [r1]
	msr CPSR,#0xD3 ;
	nop
	nop
	nop
	
	/* Initialize Stack Area */	
	/* bl InitStacks */
	LDR  r3 , L_SVCStack	 ; /* Usr Stack Initialzie */
	mov  sp , r3 
	
		
	/* IRQ mode Stack */
	mov r2   ,  #0xd2           /* No Interrupt and IRQ Mode */
	MSR cpsr , r2
	nop
	nop
	nop
	LDR r13  , L_IRQStack
  
	/* Undef mode Stack */
	msr cpsr, #0xdb
	nop
	nop
	nop
	LDR r13, L_UndefStack
#if 0		
	/* User Mode Stack */
	mov r2  , #0xdf             /* Set System mode 
                                 user mode is shar register file with system mode */
	MSR cpsr , r2
	LDR r13  , L_UsrStack
#endif

	msr cpsr , #0xd3			/* Back to SVC Mode */
	nop
	nop
	nop
/*********************************************************/
#ifdef ENABLE_ICACHE   // Kevin Im
	.extern smtEnableIcache
	bl smtEnableIcache
#endif
	
	
	/* Disable FIQ & IRQ */
	mrs r1,cpsr
	orr r1,r1,#0xC0
	msr cpsr ,r1
	nop
	nop
	nop
  
#ifdef SRAMTEST
	ldr r0, =0x20000000			// RAM Start Addr
	ldr r1, =0x00008000			// 32KWord(128KB)
	ldr r2, =0x00000000			// test data
	// store data
1:
	str r2, [r0]
	add r2, r2, #1
	add r0, r0, #4
	sub r3, r2, r1 
	cmp r3, #0
	bne 1b

	ldr r0, =0x20000000			// RAM Start Addr
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
	ldr  r1 , =0x50002008		// GPIO_OUTL
	ldr  r3 , =0x0000deae		// 0xdeae
	str  r3 , [r1]
	b 3b
4:
#endif
#ifdef DDR_BOOT
DDRInit:
	ldr r0, =0x40004000		// DDRTCON
	ldr r1, =0x40004004		// DDRCON
	ldr r2, =0x40004008		// DDRPCON
	ldr r3, =0x4000400c		// DDRREF
	ldr r4, =0x40004010		// DDRDLL

	ldr r5, =0x0001b93a
	str r5, [r0]
	ldr r5, =0x00000024
//	ldr r5, =0x00000025
	str r5, [r4]
//	ldr r5, =0x00000410
	ldr r5, =0x00000208
	str r5, [r3]
	ldr r5, =0x000000A1
//	ldr r5, =0x00000021
	str r5, [r1]
	ldr r5, =0x01f00000

1:	ldr r6, [r3]
	and r6, r6, r5
	cmp r6, #0
	bne 1b

.extern DDRTest0
//test: bl DDRTest0
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
L_UndefStack: .word _stack		/* Use user stack */

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
	
		
.extern UndefHandler
undefined_instruction:
	stmfd sp!, {r0-r12, lr}
	mov r0, sp
	mrs r1, spsr
	mov r2, lr
	bl UndefHandler
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
	bl	InterruptHandler
	ldmfd sp!, {r0-r12, lr} 
	subs	pc, lr, #0x04
	
fiq:
	mov	r6, #9
	
endless_blink:
	ldr  r1 , =0x50002008		// GPIO_OUTL
	ldr  r3 , =0x0000de00		// 0xdede
	orr  r3 , r3, r6
	str  r3 , [r1]
	b	endless_blink

/*************************************************/
