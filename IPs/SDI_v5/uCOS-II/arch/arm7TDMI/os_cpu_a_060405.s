;//********************************************************************************************************
;//                                               uC/OS-II
;//                                         The Real-Time Kernel
;//
;//                                       PXA255 Specific code
;//
;//                                       ARM Compatible Target
;//********************************************************************************************************


;#include "sysreg.h"
;#include "registeraddr.h"

REGISTERBASE			EQU		0x01FF0000
REG_I_ISPR				EQU		0x01FF8B3C
REG_I_ISPC				EQU		0x01FF8B40
REG_F_ISPR				EQU		0x01FF8B6C
REG_F_ISPC				EQU		0x01FF8B70

IRQ_TIMER0_TMC			EQU		7
;INT_TIMER0_TMC_MASK	EQU		((0x1UL)<<IRQ_TIMER0_TMC)
INT_TIMER0_TMC_MASK		EQU		0x00000080


PERIOD_VALUE_1MS		EQU		3686
PERIOD_VALUE_10MS		EQU		36864
PERIOD_VALUE_100MS		EQU		368640
PERIOD_VALUE_1000MS		EQU		3686400


        AREA KERNEL, CODE, READONLY
        CODE32
        ALIGN
;//*****************************************************************************
;//
;// The undefined instruction handler.  This is called when an instruction
;// reaches the execute stage of the ARM pipeline, but is not an instruction
;// which is recognized by the ARM processor.  We don't do anything special to
;// try and recover.
;//
;//*****************************************************************************
	EXPORT  UndefHandler
	EXPORT  SWIHandler
	EXPORT  PAbortHandler
	EXPORT  DAbortHandler
	EXPORT  UnusedHandler
	EXPORT  IRQHandler
	EXPORT  FIQHandler


UndefHandler
	movs    pc, lr

;//*****************************************************************************
;//
;// The software interrupt handler. 0x00 value is uC/OS-II Kernel Interrupt. 
;//
;//*****************************************************************************

SWIHandler
	movs	pc, lr


;//*****************************************************************************
;//
;// The instruction pre-fetch abort handler.  This is called when an instruction
;// reaches the execute state of the ARM pipeline, but the pre-fetch of the
;// instruction failed due to a MMU error.  This doesn't need to do a whole lot
;// unless we are implementing virtual memory.
;//
;//*****************************************************************************
PAbortHandler
	subs    pc, lr, #4

;//*****************************************************************************
;//
;// The data abort handler.  This is called when a load or store instruction is
;// executed and the memory access failed due to a MMU error.  This doesn't need
;// to do a whole lot unless we are implementing virtual memory.
;//
;//*****************************************************************************
DAbortHandler
	subs    pc, lr, #8

;//*****************************************************************************
;//
;// The unused vector handler.  This is a legacy vector which existed on older
;// ARM processors but is unused by the ARM7 processor.  This vector should
;// never be called.
;//
;//*****************************************************************************
UnusedHandler
	movs    pc, lr

;//*****************************************************************************
;//
;// The IRQ interrupt handler.  This is called when the IRQ line going into the
;// ARM processor goes high, indicating an external device is requesting the
;// attention of the processor.
;//
;//*****************************************************************************
        IMPORT  IsrIRQHW    ; For SDI V5 other interrupt jumpping except for Timer interrupt. 2006/04/04

IRQHandler
	stmfd	sp!, {r0-r3}
    ;mov		r1, #REG_I_ISPR			 ; Interrupt service pending register
    ldr		r1, =REG_I_ISPR			 ; Interrupt service pending register
    ldr		r0, [r1]
    tst		r0, #INT_TIMER0_TMC_MASK ; Timer0 match interrupt
    bne		Timer0IRQ				 ; Check the Timer0 interrupt

    bl              IsrIRQHW                            ; SDI V5 other interrupt vectors except for Timer interrupt
    ldmfd   sp!, {r0-r3}
    subs    pc, lr, #4

Timer0IRQ
    ldr     r2, =REG_I_ISPC			 ; Timer0 Interrupt Clear
    str     r0, [r2]

    mov     r2, sp                   ; copy IRQ's sp -> r2
    add     sp, sp,#16               ; recover IRQ's sp
    sub     r3, lr,#4                ; copy return address -> r3

    LDR     r0, =IRQ_svcMode
    MOVS    pc, r0					 ; Mode change. IRQ -> Supervisor mode
IRQ_svcMode                                                              
    stmfd   sp!, {r3}                ; push SVC's pc
    stmfd   sp!, {r4-r12,lr}         ; push SVC's r14, r12-r4
    mov     r4, r2
    ldmfd   r4!, {r0-r3}
    stmfd   sp!, {r0-r3}             ; push SVC's r3-r0
    mrs     r5, cpsr
    stmfd   sp!, {r5}                ; push SVC's PSR

    ldr		r0, =OSTCBCur			;// r0 <= &OSCTBCur
    ldr		r0, [r0]				;// r0 <=  OSCTBCur

    str		sp, [r0]				;// OSTCBCur->OSTCBStkPtr = sp

    b       OSTickISR                ; Real Body...

;//*****************************************************************************
;//
;// The FIQ interrupt handler. 
;//
;//*****************************************************************************
FIQHandler
	;mov		r12, #REG_F_ISPR			 ; FIQ interrupt service pending register
	ldr		r12, =REG_F_ISPR			 ; FIQ interrupt service pending register
	ldr		r11, [r12]
	ldr		r10, =INT_TIMER0_TMC_MASK 	 ; Timer0 match interrupt
	tst		r10, r11

	bne		Timer0FIQ

	subs	pc, lr,#4

Timer0FIQ
	ldr		r12, =REG_F_ISPC		 ; Timer0 interrupt clear
	str		r10, [r12]

    sub     r9, lr,#4                ; copy return address -> r9

    LDR     r8, =FIQ_svcMode
    MOVS    pc, r8					 ; Mode change. FIQ -> Supervisor mode
FIQ_svcMode                                                              
    stmfd   sp!, {r9}                ; push SVC's pc
    stmfd   sp!, {r0-r12,lr}         ; push SVC's r14, r12-r0
    mrs     r0, cpsr
    stmfd   sp!, {r0}                ; push SVC's PSR

    ldr		r0, =OSTCBCur			;// r0 <= &OSCTBCur
    ldr		r0, [r0]				;// r0 <=  OSCTBCur

    str		sp, [r0]				;// OSTCBCur->OSTCBStkPtr = sp

    b       OSTickISR                ; Real Body...
    
;//*****************************************************************************
;//
;// The mode of OSTickISR is SVC. This Routine is Critical section of code. 
;// Then, F and I bit of CPSR is set.
;//
;//*****************************************************************************
	IMPORT	OSIntNesting
	IMPORT	OSTimeTick
	IMPORT	OSIntExit
OSTickISR
	ldr		r0, =OSIntNesting;LBL_OS_IntNesting	;// Notify uC/OS-II of ISR
	ldrb	r1, [r0]
	ADD		r1, r1,#1
	strb	r1, [r0]
	
	bl		OSTimeTick				;// Process system tick
    bl		OSIntExit				;// Notify uC/OS-II of end of ISR

	ldmfd	sp!, {r0}
	msr		CPSR_cxsf, r0
	ldmfd	sp!, {r0 - r12, lr , pc};// ISR routine is executed at the svc mode for ctxsw.

;//*****************************************************************************
;//
;// Interrupt Mask Service Routine. 
;//
;//*****************************************************************************
	EXPORT	OSInterruptDisable
	EXPORT	OSInterruptEnable

OSInterruptDisable
	stmfd	sp!, {r0, lr}
	mrs		r0, CPSR
	orr		r0, r0, #0x80		;// CPSR I bit set
	msr		CPSR_c, r0
	ldmfd	sp!, {r0, lr}

OSInterruptEnable
	stmfd	sp!, {r0, lr}
	mrs		r0, CPSR
	bic		r0, r0, #0x80		;// CPSR I bit clear
	msr		CPSR_c, r0
	ldmfd	sp!, {r0, lr}

;//*****************************************************************************
;//
;// uC/OS Porting Core Function : OSStartHighRdy
;//
;//*****************************************************************************
	IMPORT	OSTaskSwHook
	IMPORT	OSRunning
	IMPORT	OSTCBHighRdy

	EXPORT	OSStartHighRdy

OSStartHighRdy 
	bl		OSTaskSwHook			;// Call user defined task switch hook

	ldr		r0, =OSRunning			;// Indicate that multitasking has started
	mov		r1, #1
	strb	r1, [r0]
	
	
	ldr		r0, =OSTCBHighRdy		;// r0 <= &OSTCBHighRdy
	ldr		r0, [r0]				;// r0 <=  OSTCBHighRdy

	ldr		sp,[r0]					;// sp <=  OSTCBHighRdy->OSTCBStkPtr

	ldmfd	sp!,{r0}				;// Load CPSR (supervisor mode)
	msr		CPSR_c,r0					;// CPSR <- r0
	ldmfd	sp!,{r0 - r12, lr, pc}	;// Load task's context & Run task

;//*****************************************************************************
;//
;// uC/OS Porting Core Function : OSCtxSw
;//
;//*****************************************************************************
	IMPORT	OSTCBCur
	IMPORT	OSTaskSwHook
	IMPORT	OSTCBHighRdy
	IMPORT	OSPrioCur
	IMPORT	OSPrioHighRdy

	EXPORT	OSCtxSw

OSCtxSw
	stmfd	sp!, {lr}				;// push return address
	stmfd	sp!, {r0 - r12, lr}		;// push rest context
	mrs		r0, CPSR
	;//bic		r0, r0, #0x80		;// IRQ disable
	stmfd	sp!, {r0}				;// push CPSR

	ldr		r0, =OSTCBCur			;// r0 <= &OSTCBCur
	ldr		r0, [r0]				;// r0 <=  OSTCBCur
	str		sp, [r0]				;// OSTCBCur->OSTCBStkPtr = sp

	bl		OSTaskSwHook			;// Call user defined task switch hook

	ldr		r0, =OSTCBCur			;// r0 <= &OSTCBCur
	ldr		r1, =OSTCBHighRdy		;// r1 <= &OSTCBHighRdy
	
	ldr		r2, [r1]				;// r2 <=  OSTCBHighRdy
	str		r2, [r0]				;// OSTCBCur = OSTCBHighRdy

	ldr		r0, =OSPrioCur			;// r0 <= &OSPrioCur
	ldr		r1, =OSPrioHighRdy		;// r1 <= &OSPrioHighRdy
	
	ldrb	r3, [r1]				;// r3 <=  OSPrioHighRdy
	strb	r3, [r0]				;// OSPrioCur = OSPrioHighRdy

	ldr		sp, [r2]				;// sp <=  OSTCBHighRdy->OSTCBStkPtr

	ldmfd	sp!, {r0}				;// pop CPSR
	msr		CPSR_c, r0
	ldmfd   sp!, {r0 - r12, lr, pc}	;// Load task's context & SPSR-> CPSR & Run task
	;//msr	SPSR_cxsf, r0
	;//ldmfd	sp!, {r0 - r12, lr, pc}^	// Load task's context & SPSR-> CPSR & Run task

;//*****************************************************************************
;//
;// uC/OS Porting Core Function : OSIntCtxSw
;//
;//*****************************************************************************
	IMPORT	OSTCBCur
	IMPORT	OSTaskSwHook
	IMPORT	OSTCBHighRdy
	IMPORT	OSPrioCur
	IMPORT	OSPrioHighRdy

	EXPORT	OSIntCtxSw 

OSIntCtxSw 
	add		sp, sp,#4

	;ldr		r0, =OSTCBCur			;// r0 <= &OSCTBCur
	;ldr		r0, [r0]				;// r0 <=  OSCTBCur

	;str		sp, [r0]				;// OSTCBCur->OSTCBStkPtr = sp
	
	bl		OSTaskSwHook			;// Call user defined task switch hook

	ldr		r0, =OSTCBCur			;// r0 <= &OSTCBCur
	ldr		r1, =OSTCBHighRdy		;// r1 <= &OSTCBHighRdy
	
	ldr		r2, [r1]				;// r2 <=  OSTCBHighRdy
	str		r2, [r0]				;// OSTCBCur = OSTCBHighRdy

	ldr		r0, =OSPrioCur			;// r0 <= &OSPrioCur
	ldr		r1, =OSPrioHighRdy		;// r1 <= &OSPrioHighRdy
	
	ldrb	r3, [r1]				;// r3 <=  OSPrioHighRdy
	strb	r3, [r0]				;// OSPrioCur = OSPrioHighRdy

	ldr		sp, [r2]				;// sp <=  OSTCBHighRdy->OSTCBStkPtr
	ldmfd	sp!, {r0}				;// restore CPSR
	msr		CPSR_c, r0
	ldmfd	sp!, {r0 - r12, lr, pc}	;// Load task's context & Run task
	;//msr	SPSR_cxsf, r0
	;//ldmfd	sp!, {r0 - r12, lr, pc}^;// Load task's context & Run task

;.align 4
        END
