/*
 * start.S: start code
 *
 */
;

#define FAST_ROM

#define __INIT_MMU__
#define __INIT_CACHE__
#define __EN_I_CACHE__




.extern  smtClearUTLB
.extern  smtFlushDCache
.extern  smtFlushICache
.extern  smtEnableIcache

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
	ldr  r1 , =0x30001008		/* GPIO_OE */
  	ldr  r3 , =0x00001235		/*  */
	str  r3, [r1]

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


#ifdef FAST_ROM
	ldr r0, =0x40000000         /* static memory controller */
	ldr r1, [r0]                /* load bank0 register */
	and r1, r1, #0x0f
	str r1, [r0]
#endif


	/*******************************************/
	/* Init MMU */
#ifdef  __INIT_MMU__

	bl smtClearUTLB

#endif /* __INIT_MMU__ */ 

	/*******************************************/
	/* Init cache */
#ifdef __INIT_CACHE__	
	bl smtFlushDCache
	bl smtFlushICache
#endif /* __INIT_CACHE__ */

	/* Enable Only I-Cache */
#ifdef  __EN_I_CACHE__
	bl smtEnableIcache
#endif /* __EN_I_CACHE__ */


	/* Disable FIQ & IRQ */
	mrs r1,cpsr
	orr r1,r1,#0xC0
	msr cpsr ,r1
  
	/* Read TCM status for debugging */
	mrc p15,0,r5,c0,c0,2
	ldr r6,=___data_reload
	str r5, [r6]
	

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
  LDR  r1 , L_gpio_data;
  STR  r6 , [r1]
  	
  b	endless_blink

/*************************************************/






