
/****************************************************/
/*	Initialize stacks				*/
/****************************************************/

/*Pre-defined constants*/
	
#define USERMODE    	0x10
#define FIQMODE	    	0x11
#define IRQMODE	    	0x12
#define SVCMODE	    	0x13
#define ABORTMODE   	0x17
#define UNDEFMODE   	0x1b
#define MODEMASK    	0x1f
#define NOINT	    	0xc0

.text
	
.globl	InitStacks
InitStacks:
    mrs	    r0,cpsr
    bic	    r0,r0,#MODEMASK
    orr	    r1,r0,#UNDEFMODE|NOINT
    msr	    cpsr_cxsf,r1		
    ldr	    sp,UndefStack
	
    orr	    r1,r0,#ABORTMODE|NOINT
    msr	    cpsr_cxsf,r1 	    	
    ldr	    sp,AbortStack

    orr	    r1,r0,#IRQMODE|NOINT
    msr	    cpsr_cxsf,r1 	    	
    ldr	    sp,IRQStack
	
    orr	    r1,r0,#FIQMODE|NOINT
    msr	    cpsr_cxsf,r1 	    	
    ldr	    sp,FIQStack

svc_mode_stack:	
    bic	    r0,r0,#MODEMASK|NOINT
    orr	    r1,r0,#SVCMODE
    msr	    cpsr_cxsf,r1 	    	
    ldr	    sp,SVCStack
	
    mov	    pc,lr
	
.global ticks
ticks:		.word	1
stack_end:	.word   0x01ff5e60

UserStack:   .word   0x01ff5960
SVCStack:    .word   0x01ff5a60
UndefStack:	.word   0x01ff5b60
AbortStack:	.word   0x01ff5c60
IRQStack:    .word   0x01ff5d60
FIQStack:    .word   0x01ff5e60
