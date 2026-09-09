;// =========================================================================
;// Real startup code. We jump here from the reset vector to set up the world.

; /*************************************
; Exception Vectors
; **************************************/
	CODE32
	AREA    Init,CODE,READONLY	
	ENTRY
	
Vectors
	LDR PC, ResetAddr
	LDR PC, UndefinedAddr
	LDR PC, SWI_Addr
	LDR PC, PrefetchAddr
	LDR PC, DataAbortAddr
	DCD .
	LDR PC, IRQ_Addr
	LDR PC, FIQ_Addr

	;LDR PC, Reset
	;LDR PC, Undefined
	;LDR PC, Swi
	;LDR PC, PrefetchAbort
	;LDR PC, DataAbort
	;b .
	;LDR PC, IRQ_Handler
	;LDR PC, FIQ_Handler


ResetAddr 		DCD Reset
UndefinedAddr	DCD Undefined
SWI_Addr 		DCD Swi
PrefetchAddr	DCD PrefetchAbort
DataAbortAddr	DCD DataAbort
FIQ_Addr		DCD FIQ_Handler
IRQ_Addr		DCD IRQ_Handler


;/*****************************************
;Reset handler
;*****************************************/

Reset
	ldr r1, =0x60100000
	bx	 r1

;/*****************************************
;Undefined instruction exception handler
;*****************************************/
Undefined
	ldr r1, =0x60100004
	bx	 r1

;/*****************************************
;Swi exception handler
;*****************************************/
Swi
	ldr r1, =0x60100008
	bx	 r1

;/*****************************************
;Prefetch abort exception handler
;*****************************************/
PrefetchAbort
	ldr r1, =0x6010000C
	bx	 r1

;/*****************************************
;Data abort exception handler
;*****************************************/
DataAbort
	ldr r1, =0x60100014
	bx	 r1

;/*****************************************
;IRQ exception handler
;*****************************************/
IRQ_Handler
	stmfd sp!, {r0-r12, lr} 

	ldr r1, =0x60100018
	bx	 r1
	;ldmfd sp!, {r0-r12, lr} 
	;subs	pc, lr, #0x04

;/****************************************
;FIQ exception handler
;****************************************/
FIQ_Handler
	ldr r1, =0x6010001C
	bx	 r1


	END
