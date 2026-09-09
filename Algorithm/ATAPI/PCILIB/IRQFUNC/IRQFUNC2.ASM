;
; Interrupt vector hook functions for IBM-AT or compatible machine's & needs CPU 386 or later)
;

;use  TASM.EXE V2.01 or later
;
;      TASM /jSMART /jJUMPS /uM520 /jLOCALS /m8 /t
;
.386p
CGROUP	GROUP TEXT, _TEXT

TEXT SEGMENT BYTE PUBLIC 'CODE' USE16

    EXTRN	C hookIRQ_:NEAR
    EXTRN	C freeIRQ_:NEAR
    EXTRN	C maskIRQ_:NEAR

TEXT ENDS

_TEXT SEGMENT BYTE PUBLIC 'CODE' USE16
     ASSUME  CS:CGROUP,DS:NOTHING,ES:NOTHING

;**************************
; Hook IRQ vector
;
; unsigned long _hookIRQ(unsigned int IRQ,unsigned int CallBackRoutine);
;
;       ì¸óÕ    [SP-2].W	IRQ Level (0-15)
;               [SP-6].W	CallBackRoutine's Offset address
;       èoóÕ    DX:AX	Original Vector Address
;       îjâÛ    None
;**************************
_hookIRQ PROC C NEAR PUBLIC USES BX, IRQLevel:WORD,CBAddress:WORD

	MOV	AX, IRQLevel
	MOV	BX, CBAddress
	CALL	hookIRQ_
	MOV	DX, BX
	RET

_hookIRQ ENDP

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
_freeIRQ PROC C NEAR PUBLIC USES AX CX DX, IRQLevel:WORD,OrgVectorAddress:DWORD

	MOV	AX, IRQLevel
	MOV	CX, WORD PTR OrgVectorAddress
	MOV	DX, WORD PTR OrgVectorAddress+2
	CALL	freeIRQ_
	RET

_freeIRQ ENDP

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
_maskIRQ PROC C NEAR PUBLIC USES BX, IRQLevel:WORD,maskSts:WORD

	MOV	AX, IRQLevel
	MOV	BX, maskSts
	CALL	maskIRQ_
	RET

_maskIRQ ENDP

_TEXT ENDS
     END
