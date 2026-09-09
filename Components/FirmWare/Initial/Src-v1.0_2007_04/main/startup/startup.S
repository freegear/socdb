;****************************************************************************
;* file name	: Startup.s
;* Date			: 07. 04. 2006
;* Version		: 1.0
;* Description	: Startup code
;*				  
;****************************************************************************/

	GET smt926addr.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;define variables
;	GBLL NESTED_INT
	GBLL CT500_EVB
	
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
	IF :DEF:NESTED_INT
	IMPORT	AckIRQNested
	ELSE
	ENDIF
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

	IF :DEF:CT500_EVB
	; Power Management Uint Setting
	ldr r0, =0x50003000		; Clock Control
	ldr r1, =0x50003004		; Clock Divide
	ldr r2, =0x50003008		; PLL Lock Count
	ldr r3, =0x5000300C		; PLL MPS Value
	ldr r4, =0x50003010		; SWReset

	;ldr r5, =0x00ff0f00
	;str r5, [r0]

	;ldr r5, =0x00000011		; cpuclk = x1, sysclk = 1/2 mclk
	;str r5, [r1]

	;ldr r5, =0x80000380
	;str r5, [r2]
	
	;ldr r5, =0x0000252A
	;str r5, [r3]
	
	;ldr r5, =0x000FFFFC
	;str r5, [r4]

	; Function Pin-Mux Register
	ldr r0, =0x50004010		; Pin-Mux register
	ldr r1, =0x300			; UART Channel3
	str r1, [r0]
	ENDIF
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
	
	IF :DEF:CT500_EVB
	;--------------------------------------------------------------------------
	;	DDRPCON
	;--------------------------------------------------------------------------
	ldr r5, =0x0000FFFF		; Power Down
	str r5, [r2]			; store DDRPCON
	ENDIF

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

	IMPORT main1
	B main1  	

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
	
	
irq_handler
	IF :DEF:NESTED_INT
VIC_BASE_ADDR EQU 0x40014000
	stmfd sp!, {r0-r4,r12, lr} 
	mrs	r14, spsr
	stmfd sp!, {r14}	; svc's cpsr value

	; backup current INTMSK
	ldr r12, =VIC_BASE_ADDR
	ldr r4, [r12,#0x0C]

	;ack interrupt
	bl AckIRQNested
	
	msr	cpsr_c, #0x13	; switch to svc mode
	stmfd sp!, {r14}	; store the svc lr
	mov r1, r4
	bl	InterruptHandler
	ldmfd sp!, {r14}

	msr	cpsr_c, #0x92	; switch to irq mode and disable irq
	ldmfd sp!, {r14}	; restore svc's cpsr value
	msr	spsr_fsxc, r14
	ldmfd sp!, {r0-r4,r12, lr} 
	subs	pc, lr, #0x04
	
	ELSE
	stmfd sp!, {r0-r12, lr} 
	bl	InterruptHandler
	ldmfd sp!, {r0-r12, lr} 
	subs	pc, lr, #0x04
	mov pc,lr
	ENDIF	
		

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
