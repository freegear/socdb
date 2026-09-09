               
               
;******************************************************************************
; Copyright ¸ ARM Limited 1999.  All rights reserved.
;******************************************************************************
;******************************************************************************
;  FIQ trap handling code. TrapFIQ filters the interrupt before
;  passing it on.
;******************************************************************************/


	INCLUDE platform.s
	INCLUDE except_h.s
	INCLUDE target.s

	IMPORT	uHALp_StartFIQ		; Pointers to 'C' routines.
	IMPORT	uHALp_HandleFIQ
	IMPORT	uHALp_FinishFIQ

	EXPORT	uHALr_TrapFIQ		; Simple FIQ Trap Handler

	AREA	uHal_Traps, CODE, READONLY


; Indirect pointers to FIQ handling routines.
_pStartFIQ	DCD uHALp_StartFIQ
_pHandleFIQ	DCD uHALp_HandleFIQ
_pFinishFIQ	DCD uHALp_FinishFIQ

;	uHALr_TrapFIQ - FIQ trap handler
;
; Wrapper to service the trap and call a high-level handler. This routine
; saves all the registers in an APCS compliant manner, calls a StartFIQ
; function (if defined), reads the interrupt mask & calls the high-level
; handler; calls a FinishFIQ routine (if defined) and if FinishFIQ returns a
; value, jump to it as an address to finish FIQ processing.
;
; This mechanism provides an interface to 'C' for quite complex processing
; based on FIQs, such as simple context-switching using the timer FIQ ticks.
; By not defining StartFIQ/FinishFIQ, simple FIQ processing is automatic.
;
uHALr_TrapFIQ
	; We take the cycle hit of modifying the return address here,
	; to simplify the code needed to return to the interrupted
	; thread, possibly performing a context switch on the way.
	SUB	lr, lr, #4

	; At this points FIQs are disabled, so we know that the SPSR
	; register will not be trashed by another interrupt.
        STMFD   sp!, {r0-r12, lr}       ; save registers
        MRS     v1, SPSR		; push SPSR to allow nested interrupts
        STMFD   sp!, {v1}

	LDR	a3, _pStartFIQ		; Indirect pointer to StartFIQ
	LDR	a2, [a3]		; Check for a StartFIQ routine
	CMP	a2, #0
	MOVNE	lr, pc			; arrange for a safe return here
	; Some generic task which is required at the start of an FIQ
	MOVNE	pc, a2

 	; Read which interrupt(s) is active (returns result in a1)
	READ_FIQ	a1, a2, a3

	LDR	a3, _pHandleFIQ		; Indirect pointer to FIQ Handler
	MOV     lr, pc			; arrange for a safe return here

	; The high-level handler dispatches the FIQ to the proper
	; user defined ISR.
	LDR     pc, [a3]		; call high-level handler

	LDR	a3, _pFinishFIQ		; Indirect pointer to FinishFIQ
	LDR	a1, [a3]		; Check for a FinishFIQ routine
	CMP	a1, #0
	MOVNE	lr, pc			; arrange for a safe return here
	; Some generic task which is required at the end of an FIQ
	MOVNE	pc, a1

;; !!!! NOTE: If FinishFIQ does not return 0, jump to the returned address.
;; !!!!	      So make sure your target routine matches this stack format &
;; !!!!       recovers from fiq-mode properly.

	CMP	a1, #0			; a1 is non-zero for FIQs which need
	MOVNE	pc, a1			; to do further processing

	LDMFD	sp!, {v1}		; recover SPSR value from stack
	MSREQ	SPSR_c, v1		; restore the SPSR
	LDMFD	sp!, {r0-r12, pc}^	; Restore saved registers

; /* End of TrapFIQ
;	!!!! look at uCOS/subr.s for an example which does a context switch. */

	END
               
