;******************************************************************************
; Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
; Copyright © ARM Limited 1998, 1999.  All rights reserved.
;******************************************************************************
;/*****************************************************************************

;  General IRQ change code. NewIRQ installs the given 'C' routine as the
; high level handler for interrupt as well as the actual vector. Routines
; to en/disable IRQs.

;	$Id: irqlib.s,v 1.5 1999/09/23 12:08:48 dbrooke Exp $

;******************************************************************************/

	INCLUDE	sizes.s
	INCLUDE except_h.s
	INCLUDE mmumacro.s

	IMPORT	uHALp_HandleIRQ
	IMPORT	uHALir_TrapIRQ		; Simple IRQ Trap Handler
	IMPORT	uHALir_CleanDCacheEntry
	IMPORT	uHALir_EnterSvcMode	; Enter Supervisor mode.
	IMPORT	uHALir_ExitSvcMode	; Exit Supervisor mode.

	EXPORT	uHALir_NewVector
	EXPORT	uHALir_NewIRQ		; Routine to install 'C' routine
	EXPORT	uHALir_DisableInt	; Disable IRQ.
	EXPORT	uHALir_EnableInt
	EXPORT  uHALir_DoSWI

	AREA	uHAL_IRQs, CODE, READONLY


; ------------------------------------------------------------------
; int uHALir_NewVector(void *vector, pHandler newHandler)

; Vector substitution mechanism (from NewIRQ), replaces the specified
; exception vector handler with the newHandler. Returns 0 for fail.
;
; NOTE: This routine is not ACPS-compliant as it may be called before
; stacks etc. are defined. Must be called in Supervisor mode.

uHALir_NewVector
	MOV	r2, r0
	MOV	r0, #0			; Default retval = 0
        ; Many programs don't put the vectors straight after the jump
	; table (the table may be in ROM, with the vectors in RAM). By
	; reading the real offset, we can be sure we're putting the vector
	; in the right place.
        LDR     r4, [r2]                ; Read the instruction
        LDR     r5, =0x0FFF
        LDR     r7, =0xE59FF000         ; Bit pattern for LDR PC, ... 
        BIC     r6, r4, r5              ; Clear bottom 12 bits (the offset)
        CMP     r7, r6			; Is the vector a LDR PC
        BNE     %F2
        AND     r4, r4, r5		; Clear all but the offset
        ADD     r4, r4, r2		; Add vector to calculate real address
        ADD     r4, r4, #8		; Add pipeline offset
	MOV	r0, #1			; Set return status
        B       %F3

	; The exception vector was not a LDR PC so there is no indirect
	; vector to overwrite. Instead we will try and construct a branch
	; instruction and write this into the exception vector. This will
	; only work if handler routine we are trying to install is within
	; the first 32M of memory.
	; According to the Architectural Reference Manual, branch back
	; past 0 is unpredictable.

2	SUB     r7, r1, r2		; Subtract vector and pipeline offset
	SUB     r7, r7, #8
        CMP     r7, #SZ_32M             ; Is the routine within first 32M
	BGE	%F4                     ; Fail if it isn't
        MOV     r7, r7, LSR #2          ; Shift right and mask
        BIC     r7, r7, #0xFF000000
        ORR     r1, r7, #0xEA000000     ; Build branch instruction
	MOV	r4, r2
	MOV	r0, #2			; Set return status

3	LDR     r2, [r4]		; Make a note of the old vector
        STR     r1, [r4]		; Overwrite with new vector

	MOV     r5, #0

	; Drain write buffer & caches to make sure everything is flushed.
	WRCACHE_CleanDCentry	r4

	WRCACHE_DrainWriteBuffer	r5

	WRCACHE_FlushIC		r4	; Flush ICache

	; Now check that instruction wrote correctly
	LDR	r6, [r4]
	CMP	r6, r1
	MOVNE	r0, #0			; No, must be read-only retval = 0

4
	; On return:
	;	r2 - old vector / branch / NULL
	;	r1 - new vector / branch / NULL
	;	r0 - status:	0 couldn't write new exception vector
	;			1 Old exception was an LDR PC,..
	;			2 Old exception was something else

 IF :DEF: THUMB_AWARE  ; if interworking is required
   BX    lr             ; just return 
 ELSE                   ; some processors are not Thumb aware
   MOV   pc, lr	      ; return 
 ENDIF
	MOV	pc, r14


; ------------------------------------------------------------------
;void *int uHALr_NewIRQ(uHALr_DispatchIRQ, uHALp_VectorIRQ)
;	pHandler NewHandler - Address of a new high level handler.
;
;       Install a new IRQ trap wrapper in the ARM execptions vector.
;	*** Call with interrupts disabled.
;

; Indirect pointers to IRQ handling routines.
_pHandleIRQ	DCD uHALp_HandleIRQ	    

uHALir_NewIRQ
	STMFD	sp!, {r4-r7, r14}	; save working registers
	;; Store the address of the high-level handler in the vector. We
	;; use an indirect vector so we don't have to worry about branch
	;; ranges.
	LDR	r4, _pHandleIRQ
	STR	r0, [r4]

	; Cache flushes need to be in Supervisor mode (as may vector access).
	BL	uHALir_EnterSvcMode	; Returns SPSR in r0

	CMP	r1, #0			; If no low-level vector is given
					; use the one from the library.
	LDREQ	r1, =uHALir_TrapIRQ	; This is where we want to go today

	MOV	r0, #IrqV		; IRQ vector lives here

	BL	uHALir_NewVector
	CMP	r0, #0			; Check for failure
1	BEQ	%1			; What do we do now? Spin..

	BL	uHALir_ExitSvcMode	; Needs SPSR in r0
 IF :DEF: THUMB_AWARE     ; if interworking is required
	LDMFD	sp!, {r4-r7, lr}	; restore registers & return
   BX    lr                ; just return 
 ELSE                      ; some processors are not Thumb aware
	LDMFD	sp!, {r4-r7, pc}	; restore registers & return
 ENDIF

; ------------------------------------------------------------------
;	void uHALir_DisableInt(void)
;	void uHALir_EnableInt(void)
;
;	Disable and enable IRQ, preserving current CPU mode.
;
uHALir_DisableInt
	STMFD	sp!, {r4}
	MRS	r4, cpsr
	ORR	r4, r4, #NoIRQ
	MSR	cpsr_c, r4
	LDMFD	sp!, {r4}
 IF :DEF: THUMB_AWARE  ; if interworking is required
   BX    lr             ; just return 
 ELSE                   ; some processors are not Thumb aware
   MOV   pc, lr	      ; return 
 ENDIF

uHALir_EnableInt
	STMFD	sp!, {r4}
	MRS	r4, cpsr
	BIC	r4, r4, #NoIRQ
	MSR	cpsr_c, r4
	LDMFD	sp!, {r4}
 IF :DEF: THUMB_AWARE  ; if interworking is required
   BX    lr             ; just return 
 ELSE                   ; some processors are not Thumb aware
   MOV   pc, lr	      ; return 
 ENDIF


; ------------------------------------------------------------------
; Routine to process known SWIs from 'C'
; Expects SWI in r0 & parameter (if any) in r1
uHALir_DoSWI
	STMFD	sp!, {r4-r12, r14}	; save working registers

	CMP	r0, #angel_SWI_SYS_READC	; Is it a GetByte?
	SWIEQ	SWI_Angel

	CMP	r0, #angel_SWI_SYS_WRITEC	; Is it a PutByte?
	SWIEQ	SWI_Angel

 IF :DEF: THUMB_AWARE     ; if interworking is required
	LDMFD	sp!, {r4-r12, lr}	; restore registers & return
   BX    lr                ; just return 
 ELSE                      ; some processors are not Thumb aware
	LDMFD	sp!, {r4-r12, pc}	; restore registers & return
 ENDIF


	END				; End of file

