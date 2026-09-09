;******************************************************************************
; Copyright © ARM Limited 1999.  All rights reserved.
;******************************************************************************
;/*****************************************************************************

;  General processor mode change code. 
;  Routines to read/write Current Processor Status Register;
;	and Enter/Exit Supervisor mode.

;	$Id: cpumode.s,v 1.6 1999/11/04 15:57:10 dbrooke Exp $

;******************************************************************************/

	INCLUDE except_h.s
	INCLUDE retmacro.s

	EXPORT	uHALir_ReadMode		; Read Execution mode & IRQ.
	EXPORT	uHALir_WriteMode
	EXPORT	uHALir_EnterSvcMode	; Enter Supervisor mode.
	EXPORT	uHALir_EnterLockedSvcMode ; Enter Supervisor, disable ints.
	EXPORT	uHALir_ExitSvcMode	; Exit Supervisor mode.

	AREA	uHAL_MODE, CODE, READONLY

; ------------------------------------------------------------------
; int uHALr_ReadMode(void)
; void uHALr_WriteMode(int)
;
;	Read and write current processor mode.
;
uHALir_ReadMode
	MRS	r0, cpsr
   RETURN   lr          ;Thumb aware dependant return from retmacro.s

uHALir_WriteMode
	MSR	cpsr_c, r0		; change current psr
   RETURN   lr          ;Thumb aware dependant return from retmacro.s

; ------------------------------------------------------------------
; int uHALir_EnterSvcMode(void)
;
;	Routine to enter supervisor mode. Copies original CPSR to
;	SPSR for proper return.
;
;	Calling routine should protect SPSR and call
;	uHALir_ExitSvcMode() when done.
;
;	Corrupts r1, r2 and r3.
;
;	Standalone version Returns original SPSR in r0.
;
uHALir_EnterSvcMode
 IF :DEF: SEMIHOSTED
	STMFD	sp!, {r0, r4-r5, lr}		; save working registers

	LDR	r4, =uHALiv_SVCStackCount	; increment the SVC count
	LDR	r5, [r4]
	ADD	r5, r5, #1
	STR	r5, [r4]
	TEQ	r5, #1				; Is this the first time?
	BNE	%F1
	
	MOV	r0, #angel_SWIreason_EnterSVC	; Enter SVC mode
	SWI	SWI_Angel			; Returns EnterUSR routine in r0
	LDR	r4, =uHALiv_SVCExitRoutine	; Save return routine address
	STR	r0, [r4]
1
   POP_RETURN_EXTEND r0,r4-r5  ;Thumb aware dependant return from retmacro.s

 ELSE
	MRS	r2, spsr			; Protect saved psr
	MOV	r3, lr			; and return address

	MOV	r0, #angel_SWIreason_EnterSVC	; Enter SVC mode
	SWI	SWI_Angel		; Returns EnterUSR routine in r0
	
	MOV	r0, r2			; return old spsr

   RETURN   r3          ;Thumb aware dependant return from retmacro.s

  ENDIF


; ------------------------------------------------------------------
; int uHALir_EnterLockedSvcMode(void)
;
;	Routine to enter supervisor mode & Lock out interrupts. Works
;	the same as uHALir_EnterSvcMode, but locks out IRQs at the
;	same time (saves having to call uHALir_DisableInt after
;	uHALir_EnterSvcMode.
;
;	Calling routine should protect SPSR and call
;	uHALir_ExitSvcMode when done.
;
;	Standalone version Corrupts r1, r2 and r3.
;
;	Returns original SPSR in r0.
;
uHALir_EnterLockedSvcMode
 IF :DEF: SEMIHOSTED
	STMFD	sp!, {r0, r4-r5, lr}          ; save working registers

	LDR	r4, =uHALiv_SVCStackCount     ; increment the SVC count
	LDR	r5, [r4]
	ADD	r5, r5, #1
	STR	r5, [r4]
	TEQ	r5, #1                        ; Is this the first time?
	BNE	%F2
	
	MOV	r0, #angel_SWIreason_EnterSVC	; Enter SVC mode
	SWI	SWI_Angel			            ; Returns EnterUSR routine in r0
	LDR	r4, =uHALiv_SVCExitRoutine	   ; Save the return routine address
	STR	r0, [r4]

2

   POP_RETURN_EXTEND r0,r4-r5  ;Thumb aware dependant return from retmacro.s

 ELSE
	MRS	r2, spsr                      ; Protect saved psr
	MOV	r3, lr                        ; and return address

	MOV	r0, #angel_SWIreason_EnterSVC	; Enter SVC mode
	SWI	SWI_Angel                     ; Returns EnterUSR routine in r0
	MOV	lr, r3

	MRS	r3, cpsr                      ; get current psr
	ORR	r3, r3, #NoIRQ	               ; ..and Disable Interrupts
	ORR	r3, r3, #NoFIQ	               ; ..and FIQs
	MSR	cpsr_c, r3                    ; change current psr
	MOV	r0, r2                        ; return old spsr

   RETURN   lr                         ;Thumb aware dependant return from retmacro.s

 ENDIF


; ------------------------------------------------------------------
; void uHALir_ExitSvcMode(int spsr)
;
;	Routine to exit supervisor mode. Switches out of supervisor
;	& restores SPSR to given value. NOTE: no check is made on
;	the given spsr, so it must be valid! Interrupts are restored
;	to whatever was current before call to uHALir_EnterSvcMode().
;
;	Expects original SPSR in r0.
;
uHALir_ExitSvcMode
 IF :DEF: SEMIHOSTED
	STMFD	sp!, {r0,r4-r5, lr}		; save working registers

	LDR	r4, =uHALiv_SVCStackCount	; decrement the SVC count
	LDR	r5, [r4]
	SUB	r5, r5, #1
	STR	r5, [r4]
	TEQ	r5, #0				; Should we stay in SVC mode?
	BNE	%F4

	; Get the address of the exit routine
	LDR	r4, =uHALiv_SVCExitRoutine
	LDR	r4, [r4]
	; we didn't use the SWI to get into SVC mode
	BEQ	%F4
	
	LDR	lr, =%F4
	MOV	pc, r4				; ...and call it
4

   POP_RETURN_EXTEND r0,r4-r5 ;Thumb aware dependant return from retmacro.s
	
 ELSE
	STMFD	sp!, {r0,r4-r5, lr}	; save working registers
	MOV	r4, lr				; protect return address
	SUBS	pc, pc, #0			; move SPSR -> CPSR
	NOP
	NOP
	NOP
	MSR	SPSR_c, r0			; restore previous mode

   POP_RETURN_EXTEND r0,r4-r5 ;Thumb aware dependant return from retmacro.s

  ENDIF


 IF :DEF: SEMIHOSTED
	LTORG

	AREA uHAL_Irq, DATA

uHALiv_SVCStackCount	% 4		;  count of times we've 'entered' SVC mode
uHALiv_SVCExitRoutine	% 4		; Semihosted's exit routine to leave SVC mode
 
 ENDIF

	END				; End of file

