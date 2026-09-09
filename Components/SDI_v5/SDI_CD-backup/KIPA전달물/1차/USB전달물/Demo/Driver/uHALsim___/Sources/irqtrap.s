;******************************************************************************
; Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
; Copyright © ARM Limited 1998, 1999.  All rights reserved.
;******************************************************************************
;******************************************************************************
; IRQ trap handling code. TrapIRQ filters the interrupt before passing it on.
;
;	$Id: irqtrap.s,v 1.3 1999/10/13 16:45:51 dbrooke Exp $
;
;******************************************************************************/


	INCLUDE platform.s
	INCLUDE except_h.s
	INCLUDE target.s

	IMPORT	uHALp_StartIRQ		; Pointers to 'C' routines.
	IMPORT	uHALp_HandleIRQ
	IMPORT	uHALp_FinishIRQ

	EXPORT	uHALir_TrapIRQ		; Simple IRQ Trap Handler

	AREA	uHal_Traps, CODE, READONLY


; Indirect pointers to IRQ handling routines.
_pStartIRQ	DCD uHALp_StartIRQ
_pHandleIRQ	DCD uHALp_HandleIRQ
_pFinishIRQ	DCD uHALp_FinishIRQ

;	uHALir_TrapIRQ - IRQ trap handler
;
; Wrapper to service the trap and call a high-level handler. This routine 
; saves all the registers in an APCS compliant manner, calls a StartIRQ
; function (if defined), reads the interrupt mask & calls the high-level
; handler; calls a FinishIRQ routine (if defined) and if FinishIRQ returns a
; value, jump to it as an address to finish IRQ processing.
;
; This mechanism provides an interface to 'C' for quite complex processing
; based on IRQs, such as simple context-switching using the timer IRQ ticks.
; By not defining StartIRQ/FinishIRQ, simple IRQ processing is automatic.
;
uHALir_TrapIRQ
	; We take the cycle hit of modifying the return address here,
	; to simplify the code needed to return to the interrupted
	; thread, possibly performing a context switch on the way.
	SUB	lr, lr, #4

	; At this points IRQs are disabled, so we know that the SPSR
	; register will not be trashed by another interrupt.
        STMFD   sp!, {r0-r12, lr}       ; save registers
        MRS     v1, SPSR		; push SPSR to allow nested interrupts
        STMFD   sp!, {v1}

	LDR	a3, _pStartIRQ		; Indirect pointer to StartIRQ
	LDR	a2, [a3]		; Check for a StartIRQ routine
	CMP	a2, #0
	MOVNE	lr, pc			; arrange for a safe return here
	                     ; Ensure that this and the next instruction
	                     ; are not separated (either of the next options)
	IF :DEF: THUMB_AWARE   ; if interworking is required
	BXNE   a2              ; Allow for Thumb code function
	ELSE
	; Some generic task which is required at the start of an IRQ
	MOVNE	pc, a2
	ENDIF

 	; Read which interrupt(s) is active (returns result in a1)
	READ_INT	a1, a2, a3

	LDR	a3, _pHandleIRQ		; Indirect pointer to IRQ Handler
	
	IF :DEF: THUMB_AWARE   ; if interworking is required
		LDR a3, [a3]      ; load the value to a register for the BX
		MOV	lr, pc			; arrange for a safe return here
		BX  a3            ; and call and change state (if required)
		                    ; The above two instructions must not be split
	ELSE
		MOV     lr, pc			; arrange for a safe return here
		; The high-level handler dispatches the IRQ to the proper
		; user defined ISR.
		LDR     pc, [a3]		; call high-level handler
	ENDIF

	LDR	a3, _pFinishIRQ		; Indirect pointer to FinishIRQ
	LDR	a1, [a3]		; Check for a FinishIRQ routine
	CMP	a1, #0
	
	MOVNE	lr, pc			; arrange for a safe return here
	
	IF :DEF: THUMB_AWARE   ; if interworking is required
		BXNE   a1              ; Allow for Thumb code function
	ELSE
	; Some generic task which is required at the end of an IRQ
		MOVNE	pc, a1
	ENDIF

;; !!!! NOTE: If FinishIRQ does not return 0, jump to the returned address.
;; !!!!	      So make sure your target routine matches this stack format &
;; !!!!       recovers from irq-mode properly.

	CMP	a1, #0			; a1 is non-zero for IRQs which need further action
	
	IF :DEF: THUMB_AWARE   ; if interworking is required
		BXNE   a1              ; Allow for Thumb code function
	ELSE
	; Some generic task which is required at the end of an IRQ
		MOVNE	pc, a1
	ENDIF

	LDMFD	sp!, {v1}		; recover SPSR value from stack
	MSREQ	SPSR_c, v1		; restore the SPSR
	LDMFD	sp!, {r0-r12, pc}^	; Restore saved registers

; /* End of TrapIRQ
;	!!!! look at uCOS/subr.s for an example which does a context switch. */

	END
