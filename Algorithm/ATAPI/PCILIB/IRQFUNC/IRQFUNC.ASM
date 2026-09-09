;
; Interrupt vector hook functions for IBM-AT or compatible machine's & needs CPU 386 or later)
;

;use  TASM.EXE V2.01 or later
;
;      TASM /jSMART /jJUMPS /uM520 /jLOCALS /m8 /t
;
.386p
CGROUP	GROUP TEXT,_TEXT

_TEXT SEGMENT BYTE PUBLIC 'CODE' USE16
_TEXT ENDS

TEXT SEGMENT BYTE PUBLIC 'CODE' USE16
     ASSUME  CS:CGROUP,DS:NOTHING,ES:NOTHING

;**************************
; Hook IRQ vector
;
; unsigned long _hookIRQ(unsigned int IRQ,unsigned int CallBackRoutine);
;
;       ì¸óÕ    AX	IRQ Level (0-15)
;               BX      CallBackRoutine's Offset address
;       èoóÕ    BX:AX	Original Vector Address
;       îjâÛ    None
;**************************
hookIRQ_ PROC C NEAR PUBLIC USES SI DS

    ASSUME DS:NOTHING, ES:NOTHING

	PUSHF
	CLI

	CMP	AX, 16
	JA	@@Error

	MOV	CS:[userDS], DS
	ADD	AX, AX
	MOV	SI, AX
	MOV	CS:[callBackRoutineAddress+SI], BX

	ADD	AX, AX
	MOV	SI, 8*4
	CMP	AX, 8*4
	JB	@@CalcVector
	MOV	SI, (70H-8)*4
@@CalcVector:
	ADD	SI, AX
	XOR	AX, AX
	MOV	DS, AX
	MOV	AX, OFFSET CGROUP:hookedIRQHandler
	MOV	BX, CS
	XCHG	AX, DS:[SI]
	XCHG	BX, DS:[SI+2]
	JMP	@@Exit
@@Error:
	XOR	AX, AX
	XOR	BX, BX
@@Exit:
	POPF
	RET

hookIRQ_ ENDP

;**************************
; Free IRQ vector for IBM-AT
;
; void _freeIRQ(unsigned int IRQ,unsigned long OriginalVector);
;
;       ì¸óÕ    AX	IRQ Level (0-15)
;               CX      OriginalVector's Offset address
;               DX      OriginalVector's Segment address
;       èoóÕ    None
;       îjâÛ    AX
;**************************
freeIRQ_ PROC C NEAR PUBLIC USES SI DS

	PUSHF
	CLI
	CMP	AX, 16
	JA	@@Exit

	MOV	SI, 8*4
	CMP	AX, 8
	JB	@@CalcVector
	MOV	SI, (70H-8)*4
@@CalcVector:
	SHL	AX, 2
	ADD	SI, AX
	XOR	AX, AX
	MOV	DS, AX
	MOV	DS:[SI],CX
	MOV	DS:[SI+2],DX
@@Exit:
	POPF
	RET

freeIRQ_ ENDP

;**************************
; Mask/UnMask IRQ
;
;unsigned int _maskIRQ(unsigned int IRQ,unsigned int MaskStatus);
;
;       ì¸óÕ    AX	IRQ Level (0-15)
;		BX	Mask Status
;			0) UnMask
;			1) Mask
;       èoóÕ    AX	Previous mask status
;       îjâÛ    None
;**************************
maskIRQ_ PROC C NEAR PUBLIC USES CX DX

	PUSHF
	CLI
	CMP	AX, 16
	JA	@@Exit

	MOV	CL, AL
	MOV	DX, 1
	ROL	DX, CL
	SHL	BX, CL
	MOV	CX, DX
	NOT	CX

	IN	AL, 0A1H
	MOV	AH, AL
	IN	AL, 021H
	AND	DX, AX
	AND	AX, CX
	OR	AX, BX
	CMP	AH, 0FFH
	JNE	@@SetMask	; Jump if not all mask slave.
	OR	AL, 1 SHL 2
@@SetMask:
	OUT	021H, AL
	MOV	AL, AH
	OUT	0A1H, AL

	TEST	DX, DX
	SETNZ	AL
	XOR	AH, AH
@@Exit:
	POPF
	RET

maskIRQ_ ENDP

;**************************
; IRQ0 vector
;
;       ì¸óÕ    None
;       èoóÕ    None
;       îjâÛ    None
;**************************
hookedIRQHandler PROC FAR PUBLIC

    ASSUME  DS:NOTHING,ES:NOTHING,FS:NOTHING,GS:NOTHING

	PUSHAD
	PUSH	DS
	PUSH	ES
	PUSH	FS
	PUSH	GS

	MOV	AL, 0BH
	OUT	20H, AL
	OUT	0A0H, AL
	IN	AL, 0A0H
	MOV	AH, AL
	IN	AL, 20H
	
	DB	0FH,0BDH,0D8H	;BSR	BX, AX
	JZ	@@exit		; Jump if not in interrupt service

	ADD	BX, BX
	PUSH	AX
	MOV	DS, CS:[userDS]
	MOV	ES, CS:[userDS]
	CALL	CS:[callBackRoutineAddress+BX]
	POP	AX
	MOV	AL, 20H
	TEST	AH, AH
	JZ	@@EOIMaster
	OUT	0A0H, AL
@@EOIMaster:
	OUT	020H, AL

@@exit:
	POP	GS
	POP	FS
	POP	ES
	POP	DS
	POPAD
	IRET

hookedIRQHandler ENDP

userDS	DW	?
callBackRoutineAddress	DW	16 DUP(0)


TEXT ENDS

     END
