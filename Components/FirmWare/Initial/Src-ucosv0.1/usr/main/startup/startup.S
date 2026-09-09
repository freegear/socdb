;****************************************************************************
;* file name	: Startup.s
;* Date			: 07. 04. 2006
;* Version		: 1.0
;* Description	: Startup code
;*				  
;****************************************************************************/

	GET smt926addr.inc
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Pre-defined constants

USERMODE    EQU 	0x10
FIQMODE     EQU 	0x11
IRQMODE     EQU 	0x12
SVCMODE     EQU 	0x13
ABORTMODE   EQU 	0x17
UNDEFMODE   EQU 	0x1b
MODEMASK    EQU 	0x1f
NOINT       EQU 	0xc0
R1_I	EQU	(1<<12)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;The location of stacks		- Further work

;				Size
; UserStack		14KB
; SVCStack		10KB
; UndefStack	9KB
; AbortStack	8KB
; IRQStack		4KB
; FIQStack		0KB

;_STACK_BASEADDRESS		EQU	0x20020000	; When using internal SRAM
_STACK_BASEADDRESS		EQU	0x60B00000	; When using DDR SDRAM
;_STACK_BASEADDRESS		EQU	0x63700000	; When using DDR SDRAM


UserStack	EQU	(_STACK_BASEADDRESS-10240) ; '2k'
;SVCStack	EQU	(_STACK_BASEADDRESS-8192)  ;
SVCStack	EQU	(_STACK_BASEADDRESS-10240) ;
UndefStack	EQU	(_STACK_BASEADDRESS-6144)  ;
AbortStack	EQU	(_STACK_BASEADDRESS-4096)  ;
IRQStack    EQU	(_STACK_BASEADDRESS-2048)  ;
FIQStack    EQU	(_STACK_BASEADDRESS-0x0)   ;


;_STACK_BASEADDRESS		EQU	0x6001fffc
;UserStack	EQU	(_STACK_BASEADDRESS-0x3800)  ;
;SVCStack	EQU	(_STACK_BASEADDRESS-0x2800)  ;
;UndefStack	EQU	(_STACK_BASEADDRESS-0x2400)  ;
;AbortStack	EQU	(_STACK_BASEADDRESS-0x2000)  ;
;IRQStack    EQU	(_STACK_BASEADDRESS-0x1000)  ;
;FIQStack    EQU	(_STACK_BASEADDRESS-0x0)   ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	IMPORT  |Image$$RO$$Limit|	; End of ROM code (=start of ROM data)
	IMPORT  |Image$$RW$$Base|	; Base of RAM to initialise
	IMPORT  |Image$$ZI$$Base|	; Base and limit of area
	IMPORT  |Image$$ZI$$Limit|	; to zero initialise

	IMPORT 	HandlerUndef
	IMPORT 	HandlerPabort
	IMPORT 	HandlerDabort
	IMPORT 	InterruptHandler
	IMPORT 	HandlerFIQ					
;===============================================================================
;20070510-shkim : [UCOS PT]
    IMPORT	OSIntEnter
    IMPORT	OSIntExit
	IMPORT	_IntCtxSw
	IMPORT	OSIntCtxSwFlag
;===============================================================================	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	AREA    Init,CODE,READONLY
	ENTRY

    b	ResetHandler
	b	HandlerUndef		; handler for Undefined mode
	b	HandlerSWI			; handler for SWI interrupt
	b	HandlerPabort		; handler for PAbort
	b	HandlerDabort		; handler for DAbort
	b	.					; reserved
	b	irq_handler			; handler for IRQ interrupt
	b	HandlerFIQ			; handler for FIQ interrupt

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ENTRY
ResetHandler

	
    ;--------------------------------------------------------------------
 	; Initialize stacks
 	;==================
	bl	InitStacks

; Inserted by shkim 2007/02/13
;#ifdef DDR_BOOT
DDRInit

	ldr r0, =0x40004000		; DDRTCON
	ldr r1, =0x40004004		; DDRCON
	ldr r2, =0x40004008		; DDRPCON
	ldr r3, =0x4000400c		; DDRREF
	ldr r4, =0x40004010		; DDRDLL

	;--------------------------------------------------------------------------
	;	DDTCON
	;--------------------------------------------------------------------------
	ldr r5, =0x00037535 	;0x00017535
	str r5, [r0]			; store DDTCON

	;--------------------------------------------------------------------------
	;	DDRDLL
	;--------------------------------------------------------------------------
	ldr r5, =0x00000024		; 0x00000025	
	str r5, [r4]			; store DDRDLL

	;--------------------------------------------------------------------------
	;	DDRREF
	;--------------------------------------------------------------------------
	;ldr r5, =0x00031040		; 0x00000410	
	ldr r5, =0x00000410
	str r5, [r3]			; store DDRREF

	;--------------------------------------------------------------------------
	;	DDRCON
	;--------------------------------------------------------------------------
	ldr r5, =0x000000A1		; 
	str r5, [r1]			; store DDRCON

	;--------------------------------------------------------------------------
	;	wait 200 cycle (DDR controller clock)
	;--------------------------------------------------------------------------
	ldr r5, =0x01f00000
1	ldr r6, [r3]
	and r6, r6, r5
	cmp r6, #0
	bne %B1

    ;--------------------------------------------------------------------
	; I cache enable
   	;==================
    mrc     p15, 0, r1, c1, c0, 0
    ldr     r0, =0x00001004
    orr     r1, r0, #0
    mcr     p15, 0, r1, c1, c0, 0
	
    ;--------------------------------------------------------------------
   	; Copy and paste RW data/zero initialized data
   	;==================
	LDR     r0, =|Image$$RO$$Limit|	; Get pointer to ROM data
	LDR     r1, =|Image$$RW$$Base|	; and RAM copy
	LDR     r3, =|Image$$ZI$$Base|  
	
	; Zero init base => top of initialised data
	CMP     r0, r1			; Check that they are different
	BEQ     %F2
1       
	CMP     r1, r3			; Copy init data
	LDRCC   r2, [r0], #4	; -> LDRCC r2, [r0] + ADD r0, r0, #4         
	STRCC   r2, [r1], #4	; -> STRCC r2, [r1] + ADD r1, r1, #4
	BCC     %B1
2       
	LDR     r1, =|Image$$ZI$$Limit| ; Top of zero init segment
	MOV     r2, #0
3       
	CMP     r3, r1			; Zero init
	STRCC   r2, [r3], #4
	BCC     %B3

;'__main : copy RW, ZI to RAM
; __rt_entry : setup stack and heap base
;  main : user program'
	
;	IMPORT __main
;	B __main  	

;===============================================================================
;shkim-20070510 : [UCOS PT] branch to ucos_main
;	IMPORT main1
;	B main1  	
	IMPORT ucos_main
	B ucos_main
;===========================for uc/os-II========================================

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;function initializing stacks
InitStacks
	mrs	r0,cpsr
	bic	r0,r0,#MODEMASK
	orr	r1,r0,#UNDEFMODE|NOINT
	msr	cpsr_cxsf,r1		; UndefMode
	ldr	sp,=UndefStack

	orr	r1,r0,#ABORTMODE|NOINT
	msr	cpsr_cxsf,r1		; AbortMode
	ldr	sp,=AbortStack

	orr	r1,r0,#IRQMODE|NOINT
	msr	cpsr_cxsf,r1		; IRQMode
	ldr	sp,=IRQStack

	orr	r1,r0,#FIQMODE|NOINT
	msr	cpsr_cxsf,r1		; FIQMode
	ldr	sp,=FIQStack

	bic	r0,r0,#MODEMASK|NOINT
	orr	r1,r0,#SVCMODE
	msr	cpsr_cxsf,r1		; SVCMode
	ldr	sp,=SVCStack

	mov	pc,lr
	
;===========================for uc/os-II========================================
;shkim-20070510 : [UCOS PT] need to lessen the number of backup register
irq_handler
	stmfd sp!, {r0-r12, lr} 
	
    bl	OSIntEnter
	bl	InterruptHandler
    bl	OSIntExit

    ldr	r0,=OSIntCtxSwFlag
    ldr	r1,[r0]
    cmp	r1,#1
    beq	_IntCtxSw    
	ldmfd sp!, {r0-r12, lr} 
	subs	pc, lr, #0x04
;===============================================================================

HandlerSWI
	; r0 = 1 if SWI handled
	CMP r0, #1 				; Test if SWI has been handled.
	LDMFD sp!, {r0} 		; Unstack SPSR...
	MSR spsr_cxsf, r0 		; ...and restore it.
	LDMFD sp!, {r0-r12,lr}	; Restore registers.
	MOVEQS pc, lr			; Return if SWI handled.
;	Semi_SWI
	MOVS pc,lr				; Fall through to Multi-ICE
   	
	END
