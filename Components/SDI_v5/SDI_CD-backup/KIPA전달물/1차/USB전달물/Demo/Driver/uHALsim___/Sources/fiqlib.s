               
               
;******************************************************************************
; Copyright ¸ ARM Limited 1999.  All rights reserved.
;******************************************************************************
;/*****************************************************************************

;  General FIQ and mode change code. NewFIQ installs the given
;  'C' routine as the high level handler for interrupt as well as the actual
;  vector. Routines to en/disable FIQs; 

;	$Id: fiqlib.s,v 1.2 1999/09/23 12:08:48 dbrooke Exp $

;******************************************************************************/

	INCLUDE	sizes.s
	INCLUDE	except_h.s
	INCLUDE	mmumacro.s

	IMPORT	uHALp_HandleFIQ
	IMPORT	uHALr_TrapFIQ		; Simple FIQ Trap Handler
	IMPORT	uHALir_CleanDCache
	IMPORT	uHALir_NewVector

	EXPORT	uHALr_NewFIQ		; Routine to install 'C' routine
	EXPORT	uHALir_DisableFiq		; Disable FIQ.
	EXPORT	uHALir_EnableFiq


	AREA	uHAL_FIQs, CODE, READONLY


;	void NewFIQ(pHandler NewHandler)
;	pHandler NewHandler - Address of a new high level handler.
;
;       Install a new FIQ trap wrapper in the ARM execptions vector.
;

; Indirect pointers to FIQ handling routines.
_pHandleFIQ	DCD uHALp_HandleFIQ	

uHALr_NewFIQ
	STMFD	sp!, {v1-v4, lr}	; save working registers
	;; Store the address of the high-level handler in the vector. We
	;; use an indirect vector so we don't have to worry about branch
	;; ranges.
	LDR	v1, _pHandleFIQ
	STR	a1, [v1]

	; Cache flushes need to be in Supervisor mode (as may vector access).
	BL	uHALir_EnterSvcMode	; Returns SPSR in a1

	CMP	a2, #0               ; If no low-level vector is given
                              ; use the one from the library.
	LDREQ	a2, =uHALr_TrapFIQ	; This is where we want to go today

	MOV	r0, #FiqV         ; IRQ vector lives here

	BL	uHALir_NewVector
	CMP	r0, #0            ; Check for failure
1	BEQ	%1                ; What do we do now? Spin..

	BL	uHALir_ExitSvcMode	; Needs SPSR in a1
 IF :DEF: THUMB_AWARE     ; if interworking is required
	LDMFD	sp!, {v1-v4, lr}	; restore registers & return
   BX    lr                ; just return 
 ELSE                      ; some processors are not Thumb aware
	LDMFD	sp!, {v1-v4, pc}  ; restore registers & return
 ENDIF


;	void uHALir_DisableFiq(void)
;	void uHALir_EnableFiq(void)
;
;	Disable and enable FIQ, preserving current CPU mode.
;
uHALir_DisableFiq
	STMFD	sp!, {v1}
	MRS	v1, cpsr
	ORR	v1, v1, #NoFIQ
	MSR	cpsr_c, v1
	LDMFD	sp!, {v1}
 IF :DEF: THUMB_AWARE  ; if interworking is required
   BX    lr             ; just return 
 ELSE                   ; some processors are not Thumb aware
   MOV   pc, lr	      ; return 
 ENDIF
 
uHALir_EnableFiq
	STMFD	sp!, {v1}
	MRS	v1, cpsr
	BIC	v1, v1, #NoFIQ
	MSR	cpsr_c, v1
	LDMFD	sp!, {v1}
 IF :DEF: THUMB_AWARE  ; if interworking is required
   BX    lr             ; just return 
 ELSE                   ; some processors are not Thumb aware
   MOV   pc, lr	      ; return 
 ENDIF

	END
