;
; I/O functions for IBM-AT or compatible machine's
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
; 32bit I/O Read
;
;unsigned long int  _IoReadLong(unsigned int);
;
;       ì¸óÕ    AX	I/O Address
;       èoóÕ    BX:AX	return AX value of I/O
;       îjâÛ    None
;**************************
IoReadLong_ PROC C NEAR PUBLIC USES EDX

	MOV	DX,AX
	IN	EAX,DX
	PUSH	EAX
	POP	AX
	POP	BX
	RET

IoReadLong_ ENDP

;**************************
; 32bit I/O Write
;
;void _IoWriteLong(unsigned int , unsigned long);
;
;       ì¸óÕ    AX	I/O Address
;               DX:CX	Write Data
;       èoóÕ    None
;       îjâÛ    None
;**************************
IoWriteLong_ PROC C NEAR PUBLIC USES EAX DX

	PUSH	DX
	PUSH	CX
	MOV	DX, AX
	POP	EAX
	OUT	DX,EAX
	RET

IoWriteLong_ ENDP

TEXT ENDS
     END
