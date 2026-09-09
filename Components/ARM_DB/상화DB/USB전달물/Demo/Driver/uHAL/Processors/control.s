;***************************************************************************
; Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
; Copyright © ARM Limited 1998.  All rights reserved.
;***************************************************************************

	GET	mmumacro.s

        EXPORT	uHALir_CpuControlWrite
        EXPORT	uHALir_CpuControlRead
        EXPORT  uHALir_CpuIdRead

	IMPORT	uHALir_EnterSvcMode	
	IMPORT	uHALir_ExitSvcMode	
	IMPORT	uHALir_ReadCPUIdFromBoard, weak

	KEEP

	AREA	uHAL_Control, CODE, READONLY


; ------------------------------------------------------------------
; void uHALir_CpuControlWrite(unsigned int)
;
;	Routine to write the given value to Coprocessor15 Reg 1

uHALir_CpuControlWrite
	STMFD	sp!, {r0, r4-r6, r14}	; save working registers
	MOV	r6, r0			; save r0  
	; destroys r4, r5, returns current mode in r0
	BL	uHALir_EnterSvcMode

	; write the control register with data now in r6
	WRMMU_STATE	r6
	BL	uHALir_ExitSvcMode	; needs old mode in r0 
 IF :DEF: THUMB_AWARE     ; if interworking is required
	LDMFD	sp!, {r0, r4-r6, lr}	; restore registers & return
   BX    lr                ; just return 
 ELSE                      ; some processors are not Thumb aware
	LDMFD	sp!, {r0, r4-r6, pc}	; restore registers & return
 ENDIF
       

; ------------------------------------------------------------------
; unsigned int uHALir_CpuControlRead(void)
;
;	Routine to read the value of Coprocessor15 Reg 1

uHALir_CpuControlRead
	STMFD	sp!, {r4-r6, lr}	; save working registers
	; destroys r4, r5, returns current mode in r0
	BL	uHALir_EnterSvcMode

	; read the control register into r6
	RDMMU_STATE	r6
	BL	uHALir_ExitSvcMode	; needs old mode in r0 
	MOV	r0, r6
 IF :DEF: THUMB_AWARE     ; if interworking is required
	LDMFD	sp!, {r4-r6, lr}	; restore registers & return
   BX    lr                ; just return 
 ELSE                      ; some processors are not Thumb aware
	LDMFD	sp!, {r4-r6, pc}	; restore registers & return
 ENDIF
        

; ------------------------------------------------------------------
; unsigned int uHALir_CpuIdRead(void)
;
;	Routine to read the value of Coprocessor15 Reg 0

uHALir_CpuIdRead

	STMFD	sp!, {r4-r6, r14}	; save working registers

	; destroys r4, r5, returns current mode in r0
	BL	uHALir_EnterSvcMode
	MOV	r4, r0

	; Look for a platform specific routine
	LDR	r0, =uHALir_ReadCPUIdFromBoard
	CMP	r0, #0
	BEQ	NoBoardId

	; If routine returns 0, read from the coprocessor!
	BL	uHALir_ReadCPUIdFromBoard
	CMP	r0, #0
	BNE	NoBoardId

	REALLY_RDCPU_CODE	r6
	B	GotBoardId
NoBoardId
	; read the ID into r6
	RDCPU_CODE	r6
GotBoardId
	MOV	r0, r4
	BL	uHALir_ExitSvcMode	; needs old mode in r0
	MOV	r0, r6
 IF :DEF: THUMB_AWARE     ; if interworking is required
	LDMFD	sp!, {r4-r6, lr}	; restore registers & return
   BX    lr                ; just return 
 ELSE                      ; some processors are not Thumb aware
	LDMFD	sp!, {r4-r6, pc}	; restore registers & return
 ENDIF
 
         END
