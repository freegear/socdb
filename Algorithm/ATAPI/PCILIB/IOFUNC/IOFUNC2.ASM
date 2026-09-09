;
; I/O functions for IBM-AT or compatible machine's
;

;use  TASM.EXE V2.01 or later
;
;      TASM /jSMART /jJUMPS /uM520 /jLOCALS /m8 /t
;
.386p
CGROUP	GROUP TEXT,_TEXT
TEXT SEGMENT BYTE PUBLIC 'CODE' USE16
TEXT ENDS

_TEXT SEGMENT BYTE PUBLIC 'CODE' USE16
     ASSUME  CS:CGROUP,DS:NOTHING,ES:NOTHING

;**************************
; 32bit I/O Read
;
;unsigned long int  _IoReadLong(unsigned int);
;
;       ì¸óÕ    [SP-2].W	I/O Address
;       èoóÕ    DX:AX	return AX value of I/O
;       îjâÛ    None
;**************************
_IoReadLong PROC C NEAR PUBLIC,address:WORD

	MOV	DX,address
	IN	EAX,DX
	PUSH	EAX
	POP	AX
	POP	DX
	RET

_IoReadLong ENDP

;**************************
; 32bit I/O Write
;
;void _IoWriteLong(unsigned int , unsigned long);
;
;       ì¸óÕ    [SP-2].W	I/O Address
;               [SP-6].D	Write Data
;       èoóÕ    None
;       îjâÛ    None
;**************************
_IoWriteLong PROC C NEAR PUBLIC USES EAX DX,address:WORD,outData:DWORD

	MOV	EAX, outData
	MOV	DX, address
	OUT	DX,EAX
	RET

_IoWriteLong ENDP

_TEXT ENDS
     END
