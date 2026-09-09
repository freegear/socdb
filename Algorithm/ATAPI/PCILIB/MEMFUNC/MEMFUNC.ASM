;use  TASM.EXE V2.01 or later
;
;      TASM /jSMART /jJUMPS /uM520 /jLOCALS /m8 /t
;

ERROR_MEMORY	EQU -1 ;Out Of Memory(needs 32KB or more)
ERROR_DRV	EQU -2 ;This V86 driver is not support VCPI or DPMI
ERROR_CPU	EQU -3 ;Not Support 80286 or before
ERROR_EMM	EQU -4 ;EMM386's Device name not found(EMMXXXX0)
ERROR_VCPI_PROT	EQU -5 ;VCPI can't enter protect mode
ERROR_DPMI_PROT	EQU -6 ;DPMI can't enter protect mode
ERROR_VCPI	EQU -7 ;Error in VCPI Function 1 or 0Ch
ERROR_DPMI	EQU -8 ;Error in DPMI Function 2,7,8,9 or 800h

.586P
CGROUP	GROUP TEXT,_TEXT

_TEXT SEGMENT BYTE PUBLIC 'CODE' USE16
_TEXT ENDS

TEXT SEGMENT BYTE PUBLIC 'CODE' USE16
     ASSUME  CS:CGROUP,DS:NOTHING,ES:NOTHING

;**************************
; Pre-Initialize the Himem access functions
;
; int preInitHimem()
;
;       入力    Nothing
;       出力    AX	0)Success
;                      -1)False
;       破壊    BX,ES
;**************************
preInitHimem_ PROC C NEAR PUBLIC USES CX DX SI DI BP DS ES

	CALL	CHK_CPU_MODE
	SBB	AX, AX
	JNZ	@@EXIT
	PUSH	AX
        CALL    A20_ON
	POP	AX
@@EXIT:
	RET

preInitHimem_ ENDP

;**************************
; mask NMI
;
; void _maskNMI();
;
;       入力    Nothing
;       出力    Nothing
;       破壊    Nothing
;**************************
maskNMI_ PROC C NEAR PUBLIC USES ax

	IN	AL,61H
	OR	AL,1100B
	OUT	61H,AL
	MOV	AL,80H
	OUT	70H,AL
	RET

maskNMI_ ENDP

;**************************
; unmask NMI
;
; void _unmaskNMI();
;
;       入力    Nothing
;       出力    Nothing
;       破壊    Nothing
;**************************
unmaskNMI_ PROC C NEAR PUBLIC USES ax

	IN	AL,61H
	AND	AL,NOT 1100B
	OUT	61H,AL
	IN	AL, 61h
	MOV	AL, 00H
	OUT	70H, AL
	RET

unmaskNMI_ ENDP

;**************************
; read byte data from Himem
;
; unsigned char readHimemByte(unsigned long Address)
;
;       入力    BX:AX	Read address
;       出力    AL
;       破壊    BX,ES
;**************************
readHimemByte_ PROC C NEAR PUBLIC USES CX DX ESI DS

	PUSH	BX
	PUSH	AX
	POP	ESI

        CALL    ENTER_PROTECT
	MOV	ECX, 1
	CALL	GET_SORC_SEL
	MOV	AL,DS:[ESI]
	CALL	FREE_SORC_SEL
	CALL	LEAVE_PROTECT
	RET

readHimemByte_ ENDP

;**************************
; write byte data to Himem
;
; void writeHimemByte(unsigned long Address,unsigned char Data)
;
;       入力    BX:AX	write address
;		CL	write data
;       出力    none
;       破壊    BX,ES
;**************************
writeHimemByte_ PROC C NEAR PUBLIC USES CX DX ESI DS

	PUSH	BX
	PUSH	AX
	POP	ESI
	PUSH	CX
        CALL    ENTER_PROTECT
	MOV	ECX, 1
	CALL	GET_SORC_SEL
	POP	AX
	MOV	DS:[ESI],AL
	CALL	FREE_SORC_SEL
	CALL	LEAVE_PROTECT
	RET

writeHimemByte_ ENDP


;**************************
; read word data from Himem
;
; unsigned short int readHimemWord(unsigned long Address)
;
;       入力    BX:AX	Read address
;       出力    AX
;       破壊    BX,ES
;**************************
readHimemWord_ PROC C NEAR PUBLIC USES CX DX ESI DS

	PUSH	BX
	PUSH	AX
	POP	ESI

        CALL    ENTER_PROTECT
	MOV	ECX, 2
	CALL	GET_SORC_SEL
	MOV	AX,DS:[ESI]
	CALL	FREE_SORC_SEL
	CALL	LEAVE_PROTECT
	RET

readHimemWord_ ENDP

;**************************
; write word data to Himem
;
; void writeHimemWord(unsigned long Address,unsigned int Data)
;
;       入力    BX:AX	write address
;		CX	write data
;       出力    none
;       破壊    BX,ES
;**************************
writeHimemWord_ PROC C NEAR PUBLIC USES CX DX ESI DS

	PUSH	BX
	PUSH	AX
	POP	ESI
	PUSH	CX
        CALL    ENTER_PROTECT
	MOV	ECX, 2
	CALL	GET_SORC_SEL
	POP	WORD PTR DS:[ESI]
	CALL	FREE_SORC_SEL
	CALL	LEAVE_PROTECT
	RET

writeHimemWord_ ENDP

;**************************
; read long data from Himem
;
; unsigned long readHimemLong(unsigned long Address)
;
;       入力    BX:AX	Read address
;       出力    BX:AX	Read Data
;       破壊    ES
;**************************
readHimemLong_ PROC C NEAR PUBLIC USES CX DX ESI DS

	PUSH	BX
	PUSH	AX
	POP	ESI

        CALL    ENTER_PROTECT
	MOV	ECX, 4
	CALL	GET_SORC_SEL
	MOV	EAX,DS:[ESI]
	PUSH	EAX
	POP	AX
	POP	BX
	CALL	FREE_SORC_SEL
	CALL	LEAVE_PROTECT
	RET

readHimemLong_ ENDP

;**************************
; write long data to Himem
;
; void writeHimemLong(unsigned long Address,unsigned long Data)
;
;       入力    BX:AX	write address
;		DX:CX	write data
;       出力    none
;       破壊    AX,BX,ES
;**************************
writeHimemLong_ PROC C NEAR PUBLIC USES CX DX ESI DS

	PUSH	BX
	PUSH	AX
	POP	ESI
	PUSH	DX
	PUSH	CX
        CALL    ENTER_PROTECT
	MOV	ECX, 4
	CALL	GET_SORC_SEL
	POP	DWORD PTR DS:[ESI]
	CALL	FREE_SORC_SEL
	CALL	LEAVE_PROTECT
	RET

writeHimemLong_ ENDP

;**************************
; read block byte data from Himem
;
; unsigned int readHimemBlockByte(unsigned long Address,unsigned char *Buffer,unsigned int bytes)
;
;       入力    BX:AX	Read address
;		DS:CX	Buffer address
;		DX	Read Size
;       出力    AX	Read Size
;       破壊    nothing
;**************************
readHimemBlockByte_ PROC C NEAR PUBLIC USES ECX DX ESI EDI DS ES

	PUSH	BX
	PUSH	AX
	POP	ESI

	MOV	AX,DS
	MOV	BL,AH
	SHR	BL,4
	SHL	AX,4
	ADD	AX,CX
	ADC	BL, 0
	XOR	BH, BH
	PUSH	BX
	PUSH	AX
	POP	EDI
	MOVZX	ECX,DX

        CALL    ENTER_PROTECT
	CALL	GET_SORC_SEL
	CLD
	PUSH	DSEL_FULL
	POP	ES
	PUSH	CX
	POP	AX
	REP	MOVS BYTE PTR ES:[EDI],BYTE PTR DS:[ESI]
	CALL	FREE_SORC_SEL
	CALL	LEAVE_PROTECT
	RET

readHimemBlockByte_ ENDP

;**************************
; write block byte data from Himem
;
; unsigned int writeHimemBlockByte(unsigned long Address,unsigned char *Buffer,unsigned int bytes)
;
;       入力    BX:AX	Read address
;		DS:CX	Buffer address
;		DX	Write Size
;       出力    AX	Write Size
;       破壊    nothing
;**************************
writeHimemBlockByte_ PROC C NEAR PUBLIC USES ECX DX ESI EDI DS ES

	PUSH	BX
	PUSH	AX
	POP	ESI

	MOV	AX,DS
	MOV	BL,AH
	SHR	BL,4
	SHL	AX,4
	ADD	AX,CX
	ADC	BL, 0
	XOR	BH, BH
	PUSH	BX
	PUSH	AX
	POP	EDI
	MOVZX	ECX,DX

        CALL    ENTER_PROTECT
	CALL	GET_SORC_SEL
	CLD
	PUSH	DS
	POP	ES
	PUSH	DSEL_FULL
	POP	DS
	PUSH	CX
	POP	AX
	XCHG	ESI,EDI
	REP	MOVS BYTE PTR ES:[EDI],BYTE PTR DS:[ESI]
	CALL	FREE_SORC_SEL
	CALL	LEAVE_PROTECT
	RET

writeHimemBlockByte_ ENDP

;**************************
; read block word data from Himem
;
; unsigned int readHimemBlockWord(unsigned long Address,unsigned char *Buffer,unsigned int words)
;
;       入力    BX:AX	Read address
;		DS:CX	Buffer address
;		DX	Read Size(unit word)
;       出力    AX	Read Size(unit word)
;       破壊    nothing
;**************************
readHimemBlockWord_ PROC C NEAR PUBLIC USES ECX DX ESI EDI DS ES

	AND	AL, NOT 1
	PUSH	BX
	PUSH	AX
	POP	ESI

	MOV	AX,DS
	MOV	BL,AH
	SHR	BL,4
	SHL	AX,4
	ADD	AX,CX
	ADC	BL, 0
	XOR	BH, BH
	PUSH	BX
	PUSH	AX
	POP	EDI
	MOVZX	ECX,DX

        CALL    ENTER_PROTECT
	CALL	GET_SORC_SEL
	CLD
	PUSH	DSEL_FULL
	POP	ES
	PUSH	CX
	POP	AX
	REP	MOVS WORD PTR ES:[EDI],WORD PTR DS:[ESI]
	CALL	FREE_SORC_SEL
	CALL	LEAVE_PROTECT
	RET

readHimemBlockWord_ ENDP

;**************************
; write block word data from Himem
;
; unsigned int writeHimemBlockWord(unsigned long Address,unsigned char *Buffer,unsigned int words)
;
;       入力    BX:AX	Write address
;		DS:CX	Buffer address
;		DX	Write Size(unit word)
;       出力    AX	Write Size(unit word)
;       破壊    nothing
;**************************
writeHimemBlockWord_ PROC C NEAR PUBLIC USES ECX DX ESI EDI DS ES

	AND	AL, NOT 1
	PUSH	BX
	PUSH	AX
	POP	ESI

	MOV	AX,DS
	MOV	BL,AH
	SHR	BL,4
	SHL	AX,4
	ADD	AX,CX
	ADC	BL, 0
	XOR	BH, BH
	PUSH	BX
	PUSH	AX
	POP	EDI
	MOVZX	ECX,DX

        CALL    ENTER_PROTECT
	CALL	GET_SORC_SEL
	CLD
	PUSH	DS
	POP	ES
	PUSH	DSEL_FULL
	POP	DS
	PUSH	CX
	POP	AX
	XCHG	ESI,EDI
	REP	MOVS WORD PTR ES:[EDI],WORD PTR DS:[ESI]
	CALL	FREE_SORC_SEL
	CALL	LEAVE_PROTECT
	RET

writeHimemBlockWord_ ENDP

;**************************
; read block long word data from Himem
;
; unsigned int readHimemBlockLong(unsigned long Address,unsigned char *Buffer,unsigned int longWords)
;
;       入力    BX:AX	Read address
;		DS:CX	Buffer address
;		DX	Read Size(unit long word)
;       出力    AX	Read Size(unit long word)
;       破壊    nothing
;**************************
readHimemBlockLong_ PROC C NEAR PUBLIC USES ECX DX ESI EDI DS ES

	AND	AL, NOT 11B
	PUSH	BX
	PUSH	AX
	POP	ESI

	MOV	AX,DS
	MOV	BL,AH
	SHR	BL,4
	SHL	AX,4
	ADD	AX,CX
	ADC	BL, 0
	XOR	BH, BH
	PUSH	BX
	PUSH	AX
	POP	EDI
	MOVZX	ECX,DX

        CALL    ENTER_PROTECT
	CALL	GET_SORC_SEL
	CLD
	PUSH	DSEL_FULL
	POP	ES
	PUSH	CX
	POP	AX
	REP	MOVS DWORD PTR ES:[EDI],DWORD PTR DS:[ESI]
	CALL	FREE_SORC_SEL
	CALL	LEAVE_PROTECT
	RET

readHimemBlockLong_ ENDP

;**************************
; write block long word data from Himem
;
; unsigned int writeHimemBlockLong(unsigned long Address,unsigned char *Buffer,unsigned int longWords)
;
;       入力    BX:AX	Write address
;		DS:CX	Buffer address
;		DX	Write Size(unit long word)
;       出力    AX	Write Size(unit long word)
;       破壊    nothing
;**************************
writeHimemBlockLong_ PROC C NEAR PUBLIC USES ECX DX ESI EDI DS ES

	AND	AL, NOT 11B
	PUSH	BX
	PUSH	AX
	POP	ESI

	MOV	AX,DS
	MOV	BL,AH
	SHR	BL,4
	SHL	AX,4
	ADD	AX,CX
	ADC	BL, 0
	XOR	BH, BH
	PUSH	BX
	PUSH	AX
	POP	EDI
	MOVZX	ECX,DX

        CALL    ENTER_PROTECT
	CALL	GET_SORC_SEL
	CLD
	PUSH	DS
	POP	ES
	PUSH	DSEL_FULL
	POP	DS
	PUSH	CX
	POP	AX
	XCHG	ESI,EDI
	REP	MOVS DWORD PTR ES:[EDI],DWORD PTR DS:[ESI]
	CALL	FREE_SORC_SEL
	CALL	LEAVE_PROTECT
	RET

writeHimemBlockLong_ ENDP

;**************************
; copy from himem to himem by byte
;
; unsigned int copyHimemByte(unsigned long SourceAddress,unsigned long DestAddress,unsigned int bytes)
;
;       入力    BX:AX	Source address
;		DX:CX	Destination address
;		[SP-2].l copy Size(unit byte)
;       出力    BX:AX	copied Size(unit byte)
;       破壊    nothing
;**************************
copyHimemByte_ PROC C NEAR PUBLIC USES ECX DX ESI EDI DS ES,bytes:DWORD

        PUSH    BX
        PUSH    AX
        POP     ESI
        PUSH    DX
        PUSH    CX
        POP     EDI
	MOV	ECX, bytes

;コピー方向をチェック
;----------------------
	XOR	DX, DX		;DX=0アドレス増加方向へコピー
	MOV	EAX, EDI
	SUB	EAX, ESI
	JBE	@@endCheckDirection
	CMP	EAX, ECX
	JAE	@@endCheckDirection
	INC	DX		;DX!=0アドレス減少方向へコピー
@@endCheckDirection:

;memory managerの種類で動作を変える
;------------------------
        TEST    CS:[FLAG],@VCPI
        JNZ     @@VCPI		;VCPIの場合は、細切れにコピー

        CALL    ENTER_PROTECT
	JC	@@error
	CALL	GET_SORC_SEL
	CALL	GET_DEST_SEL

	PUSH	ECX
	CLD
	TEST	DX, DX
	JZ	@@copy		;アドレス増加方向へ
	STD			;アドレス減少方向へ
	LEA	ESI,[ESI+ECX-1]
	LEA	EDI,[EDI+ECX-1]
@@copy:
	REP	MOVS BYTE PTR ES:[EDI],BYTE PTR DS:[ESI]
	JMP	@@success

	;VCPIの場合、256KB転送毎にページへのメモリ割り当てを更新
	;-----------------------
@@VCPI:
        CALL    ENTER_PROTECT
	JC	@@error

	PUSH	ECX

	TEST	DX, DX
	JNZ	@@vcpiReverseCopy ;アドレス減少方向

	;アドレス増加方向へ
	;--------------------
@@vcpiLoopNormalCopy:
	PUSH	ECX
	PUSH	ESI
	PUSH	EDI
	CMP	ECX, 40000H
	JBE	@@vcpiLastNormalCopy
	MOV	ECX, 40000H
@@vcpiLastNormalCopy:
	CALL	GET_SORC_SEL
	CALL	GET_DEST_SEL
	CLD
	REP	MOVS BYTE PTR ES:[EDI],BYTE PTR DS:[ESI]
	POP	EDI
	POP	ESI
	POP	ECX
	MOV	EAX, 40000H
	ADD	ESI, EAX
	ADD	EDI, EAX
	SUB	ECX, EAX
	JA	@@vcpiLoopNormalCopy
	JMP	@@success

	;アドレス減少方向へ
	;--------------------
@@vcpiReverseCopy:

	LEA	ESI,[ESI+ECX]
	LEA	EDI,[EDI+ECX]

@@vcpiLoopReverseCopy:
	PUSH	ECX
	CMP	ECX, 40000H
	JBE	@@vcpiLastReverseCopy
	MOV	ECX, 40000H
@@vcpiLastReverseCopy:
	PUSH	ESI
	PUSH	EDI
	SUB	ESI, ECX
	SUB	EDI, ECX
	CALL	GET_SORC_SEL
	CALL	GET_DEST_SEL
	LEA	ESI,[ESI+ECX-1]
	LEA	EDI,[EDI+ECX-1]
	STD
	REP	MOVS BYTE PTR ES:[EDI],BYTE PTR DS:[ESI]
	POP	EDI
	POP	ESI
	POP	ECX
	MOV	EAX, 40000H
	SUB	ESI, EAX
	SUB	EDI, EAX
	SUB	ECX, EAX
	JA	@@vcpiLoopNormalCopy

@@success:
	CALL	LEAVE_PROTECT
	POP	AX
	POP	BX
	JMP	@@exit

@@error:
	POP	AX
	POP	BX
	XOR	AX, AX
	XOR	BX, BX
@@exit:
	RET

copyHimemByte_ ENDP
;**************************
; copy from himem to himem by word
;
; unsigned int copyHimemWord(unsigned long SourceAddress,unsigned long DestAddress,unsigned int words)
;
;       入力    BX:AX	Source address
;		DX:CX	Destination address
;		[SP-2].L Copy Size(unit word)
;       出力    BX:AX	Copied Size(unit word)
;       破壊    nothing
;**************************
copyHimemWord_ PROC C NEAR PUBLIC USES ECX DX ESI EDI DS ES,words:DWORD

        PUSH    BX
        PUSH    AX
        POP     ESI
        PUSH    DX
        PUSH    CX
        POP     EDI
	MOV	ECX, words
	SHL	ECX, 1

;コピー方向をチェック
;----------------------
	XOR	DX, DX		;DX=0アドレス増加方向へコピー
	MOV	EAX, EDI
	SUB	EAX, ESI
	JBE	@@endCheckDirection
	CMP	EAX, ECX
	JAE	@@endCheckDirection
	INC	DX		;DX!=0アドレス減少方向へコピー
@@endCheckDirection:

;memory managerの種類で動作を変える
;------------------------
        TEST    CS:[FLAG],@VCPI
        JNZ     @@VCPI		;VCPIの場合は、細切れにコピー

        CALL    ENTER_PROTECT
	JC	@@error
	CALL	GET_SORC_SEL
	CALL	GET_DEST_SEL

	SHR	ECX, 1
	PUSH	ECX
	CLD
	TEST	DX, DX
	JZ	@@copy		;アドレス増加方向へ
	STD			;アドレス減少方向へ
	LEA	ESI,[ESI+ECX*2-2]
	LEA	EDI,[EDI+ECX*2-2]
@@copy:
	REP	MOVS WORD PTR ES:[EDI],WORD PTR DS:[ESI]
	JMP	@@success

	;VCPIの場合、256KB転送毎にページへのメモリ割り当てを更新
	;-----------------------
@@VCPI:
        CALL    ENTER_PROTECT
	JC	@@error

	SHR	ECX, 1
	PUSH	ECX

	TEST	DX, DX
	JNZ	@@vcpiReverseCopy ;アドレス減少方向

	;アドレス増加方向へ
	;--------------------
@@vcpiLoopNormalCopy:
	PUSH	ECX
	PUSH	ESI
	PUSH	EDI
	CMP	ECX, 40000H/2
	JBE	@@vcpiLastNormalCopy
	MOV	ECX, 40000H/2
@@vcpiLastNormalCopy:
	SHL	ECX, 1
	CALL	GET_SORC_SEL
	CALL	GET_DEST_SEL
	SHR	ECX, 1
	CLD
	REP	MOVS WORD PTR ES:[EDI],WORD PTR DS:[ESI]
	POP	EDI
	POP	ESI
	POP	ECX
	ADD	ESI, 40000H
	ADD	EDI, 40000H
	SUB	ECX, 40000H/2
	JA	@@vcpiLoopNormalCopy
	JMP	@@success

	;アドレス減少方向へ
	;--------------------
@@vcpiReverseCopy:

	LEA	ESI,[ESI+ECX*2]
	LEA	EDI,[EDI+ECX*2]

@@vcpiLoopReverseCopy:
	PUSH	ECX
	PUSH	ESI
	PUSH	EDI
	CMP	ECX, 40000H/2
	JBE	@@vcpiLastReverseCopy
	MOV	ECX, 40000H/2
@@vcpiLastReverseCopy:
	SHL	ECX, 1
	SUB	ESI, ECX
	SUB	EDI, ECX
	CALL	GET_SORC_SEL
	CALL	GET_DEST_SEL
	SHR	ECX, 1
	LEA	ESI,[ESI+ECX*2-2]
	LEA	EDI,[EDI+ECX*2-2]
	STD
	REP	MOVS WORD PTR ES:[EDI],WORD PTR DS:[ESI]
	POP	EDI
	POP	ESI
	POP	ECX
	SUB	ESI, 40000H
	SUB	EDI, 40000H
	SUB	ECX, 40000H/2
	JA	@@vcpiLoopNormalCopy

@@success:
	CALL	LEAVE_PROTECT
	POP	AX
	POP	BX
	JMP	@@exit

@@error:
	POP	AX
	POP	BX
	XOR	AX, AX
	XOR	BX, BX
@@exit:
	RET

copyHimemWord_ ENDP
;**************************
; copy from himem to himem by long word
;
; unsigned int copyHimemLong(unsigned long SourceAddress,unsigned long DestAddress,unsigned int longWords)
;
;       入力    BX:AX	Source address
;		DX:CX	Destination address
;		[sp-2].l Copy Size(unit long word)
;       出力    BX:AX	Copied Size(unit long word)
;       破壊    nothing
;**************************
copyHimemLong_ PROC C NEAR PUBLIC USES ECX DX ESI EDI DS ES,longWords:DWORD

        PUSH    BX
        PUSH    AX
        POP     ESI
        PUSH    DX
        PUSH    CX
        POP     EDI
	MOV	ECX, longWords
	SHL	ECX, 2

;コピー方向をチェック
;----------------------
	XOR	DX, DX		;DX=0アドレス増加方向へコピー
	MOV	EAX, EDI
	SUB	EAX, ESI
	JBE	@@endCheckDirection
	CMP	EAX, ECX
	JAE	@@endCheckDirection
	INC	DX		;DX!=0アドレス減少方向へコピー
@@endCheckDirection:

;memory managerの種類で動作を変える
;------------------------
        TEST    CS:[FLAG],@VCPI
        JNZ     @@VCPI		;VCPIの場合は、細切れにコピー

        CALL    ENTER_PROTECT
	JC	@@error
	CALL	GET_SORC_SEL
	CALL	GET_DEST_SEL

	SHR	ECX, 2
	PUSH	ECX
	CLD
	TEST	DX, DX
	JZ	@@copy		;アドレス増加方向へ
	STD			;アドレス減少方向へ
	LEA	ESI,[ESI+ECX*4-4]
	LEA	EDI,[EDI+ECX*4-4]
@@copy:
	REP	MOVS DWORD PTR ES:[EDI],DWORD PTR DS:[ESI]
	JMP	@@success

	;VCPIの場合、256KB転送毎にページへのメモリ割り当てを更新
	;-----------------------
@@VCPI:
        CALL    ENTER_PROTECT
	JC	@@error

	SHR	ECX, 2
	PUSH	ECX

	TEST	DX, DX
	JNZ	@@vcpiReverseCopy ;アドレス減少方向

	;アドレス増加方向へ
	;--------------------
@@vcpiLoopNormalCopy:
	PUSH	ECX
	PUSH	ESI
	PUSH	EDI
	CMP	ECX, 40000H/4
	JBE	@@vcpiLastNormalCopy
	MOV	ECX, 40000H/4
@@vcpiLastNormalCopy:
	SHL	ECX, 2
	CALL	GET_SORC_SEL
	CALL	GET_DEST_SEL
	SHR	ECX, 2
	CLD
	REP	MOVS DWORD PTR ES:[EDI],DWORD PTR DS:[ESI]
	POP	EDI
	POP	ESI
	POP	ECX
	ADD	ESI, 40000H
	ADD	EDI, 40000H
	SUB	ECX, 40000H/4
	JA	@@vcpiLoopNormalCopy
	JMP	@@success

	;アドレス減少方向へ
	;--------------------
@@vcpiReverseCopy:

	LEA	ESI,[ESI+ECX*4]
	LEA	EDI,[EDI+ECX*4]

@@vcpiLoopReverseCopy:
	PUSH	ECX
	PUSH	ESI
	PUSH	EDI
	CMP	ECX, 40000H/4
	JBE	@@vcpiLastReverseCopy
	MOV	ECX, 40000H/4
@@vcpiLastReverseCopy:
	SHL	ECX, 2
	SUB	ESI, ECX
	SUB	EDI, ECX
	CALL	GET_SORC_SEL
	CALL	GET_DEST_SEL
	SHR	ECX, 2
	LEA	ESI,[ESI+ECX*4-4]
	LEA	EDI,[EDI+ECX*4-4]
	STD
	REP	MOVS DWORD PTR ES:[EDI],DWORD PTR DS:[ESI]
	POP	EDI
	POP	ESI
	POP	ECX
	SUB	ESI, 40000H
	SUB	EDI, 40000H
	SUB	ECX, 40000H/4
	JA	@@vcpiLoopNormalCopy

@@success:
	CALL	LEAVE_PROTECT
	POP	AX
	POP	BX
	JMP	@@exit

@@error:
	POP	AX
	POP	BX
	XOR	AX, AX
	XOR	BX, BX
@@exit:
	RET

copyHimemLong_ ENDP

;**************************
; fill from himem to himem by byte
;
; unsigned int fillHimemByte(unsigned long Address,unsigned int bytes)
;
;       入力    BX:AX	Read address
;		DX:CX	Fill Size(unit byte)
;		[SP-2].B Fill Data
;       出力    BX:AX	Filled Size(unit byte)
;       破壊    nothing
;**************************
fillHimemByte_ PROC C NEAR PUBLIC USES ECX DX EDI DS ES,writeData:BYTE

        PUSH    BX
        PUSH    AX
        POP     EDI
        PUSH    DX
        PUSH    CX
	POP	ECX

	MOV	AL, writeData

;memory managerの種類で動作を変える
;------------------------
        TEST    CS:[FLAG],@VCPI
        JNZ     @@VCPI		;VCPIの場合は、細切れにFill

	;Real,DPMIの場合
	;------------------------
	PUSH	ECX
        CALL    ENTER_PROTECT
	CALL	GET_DEST_SEL
	CLD
	REP	STOS BYTE PTR ES:[EDI]
	JMP	@@success

	;VCPIの場合
	;------------------------
@@VCPI:
        CALL    ENTER_PROTECT
	JC	@@error

	PUSH	ECX

@@vcpiLoopFill:
	PUSH	ECX
	PUSH	EDI

	CMP	ECX, 40000H
	JBE	@@vcpiLastFill
	MOV	ECX, 40000H
@@vcpiLastFill:
	CALL	GET_DEST_SEL
	CLD
	REP	STOS BYTE PTR ES:[EDI]

	POP	EDI
	POP	ECX
	ADD	EDI, 40000H
	SUB	ECX, 40000H
	JA	@@vcpiLoopFill

@@success:
	CALL	LEAVE_PROTECT
	POP	AX
	POP	BX
	JMP	@@exit

@@error:
	POP	AX
	POP	BX
	XOR	AX, AX
	XOR	BX, BX
@@exit:
	RET

fillHimemByte_ ENDP
;**************************
; fill from himem to himem by word
;
; unsigned int fillHimemByte(unsigned long Address,unsigned int words)
;
;       入力    BX:AX	Read address
;		DX:CX	Fill Size(unit word)
;		[SP-2].W Fill Data
;       出力    BX:AX	Filled Size(unit word)
;       破壊    nothing
;**************************
fillHimemWord_ PROC C NEAR PUBLIC USES ECX DX EDI DS ES,writeData:WORD

        PUSH    BX
        PUSH    AX
        POP     EDI
        PUSH    DX
        PUSH    CX
	POP	ECX

	MOV	AX, writeData

;memory managerの種類で動作を変える
;------------------------
        TEST    CS:[FLAG],@VCPI
        JNZ     @@VCPI		;VCPIの場合は、細切れにFill

	;Real,DPMIの場合
	;------------------------
	PUSH	ECX
        CALL    ENTER_PROTECT
	SHL	ECX, 1
	CALL	GET_DEST_SEL
	SHR	ECX, 1
	CLD
	REP	STOS WORD PTR ES:[EDI]
	JMP	@@success

	;VCPIの場合
	;------------------------
@@VCPI:
        CALL    ENTER_PROTECT
	JC	@@error

	PUSH	ECX

@@vcpiLoopFill:
	PUSH	ECX
	CMP	ECX, 40000H/2
	JBE	@@vcpiLastFill
	MOV	ECX, 40000H/2
@@vcpiLastFill:
	PUSH	EDI
	SHL	ECX, 1
	CALL	GET_DEST_SEL
	SHR	ECX, 1
	CLD
	REP	STOS WORD PTR ES:[EDI]
	POP	EDI
	POP	ECX
	ADD	EDI, 40000H
	SUB	ECX, 40000H/2
	JA	@@vcpiLoopFill

@@success:
	CALL	LEAVE_PROTECT
	POP	AX
	POP	BX
	JMP	@@exit

@@error:
	POP	AX
	POP	BX
	XOR	AX, AX
	XOR	BX, BX
@@exit:
	RET

fillHimemWord_ ENDP
;**************************
; fill from himem to himem by long
;
; unsigned int fillHimemByte(unsigned long Address,unsigned int longWords)
;
;       入力    BX:AX	Read address
;		DX:CX	Fill Size(unit long word)
;		[SP-2].L Fill Data
;       出力    BX:AX	Filled Size(unit long word)
;       破壊    nothing
;**************************
fillHimemLong_ PROC C NEAR PUBLIC USES ECX DX EDI DS ES,writeData:DWORD

        PUSH    BX
        PUSH    AX
        POP     EDI
        PUSH    DX
        PUSH    CX
	POP	ECX

	MOV	EAX, writeData

;memory managerの種類で動作を変える
;------------------------
        TEST    CS:[FLAG],@VCPI
        JNZ     @@VCPI		;VCPIの場合は、細切れにFill

	;Real,DPMIの場合
	;------------------------
	PUSH	ECX
        CALL    ENTER_PROTECT
	SHL	ECX, 2
	CALL	GET_DEST_SEL
	SHR	ECX, 2
	CLD
	REP	STOS DWORD PTR ES:[EDI]
	JMP	@@success

	;VCPIの場合
	;------------------------
@@VCPI:
        CALL    ENTER_PROTECT
	JC	@@error

	PUSH	ECX

@@vcpiLoopFill:
	PUSH	ECX
	CMP	ECX, 40000H/4
	JBE	@@vcpiLastFill
	MOV	ECX, 40000H/4
@@vcpiLastFill:
	PUSH	EDI
	SHL	ECX, 2
	CALL	GET_DEST_SEL
	SHR	ECX, 2
	CLD
	REP	STOS DWORD PTR ES:[EDI]
	POP	EDI
	POP	ECX
	ADD	EDI, 40000H
	SUB	ECX, 40000H/4
	JA	@@vcpiLoopFill

@@success:
	CALL	LEAVE_PROTECT
	POP	AX
	POP	BX
	JMP	@@exit

@@error:
	POP	AX
	POP	BX
	XOR	AX, AX
	XOR	BX, BX
@@exit:
	RET

fillHimemLong_ ENDP

;********************************
;CPU動作ﾓｰﾄﾞﾁｪｯｸ
;
;    入力    なし
;    出力    AX		0)Real Mode
;			1)VCPI Mode
;			2)DPMI Mode
;			-1)判定できず
;    破壊    なし
;********************************
getCpuMode_	PROC C NEAR PUBLIC USES BX CX DX DS ES

    ASSUME  DS:NOTHING,ES:NOTHING

;CPU動作モード判定
;------------------------
         SMSW    AX
         TEST    AL,1
         JZ      @@RealMode

;DPMIをｻﾎﾟｰﾄするかﾁｪｯｸ
;-----------------------
         MOV     AX,1687H           ;DPMI Check
         INT     2FH                ;
    ASSUME  ES:NOTHING
         TEST    AX,AX
         JZ      @@DPMIMode

;VCPIをｻﾎﾟｰﾄするかﾁｪｯｸ
;-----------------------
	;EMM386が存在するか？
	;-----------------------
        PUSH    DS
        XOR     AX,AX
        MOV     DS,AX
        MOV     DS,WORD PTR DS:[67H*4+2]
        MOV     AX,WORD PTR DS:[0AH]
        MOV     CL,BYTE PTR DS:[0AH+2]
        POP     DS
        MOV     DX,ERROR_EMM
        CMP     AX,'ME'
        JNE     @@CantRun
        CMP     CL,'M'
        JNE     @@CantRun

        MOV     AH,40H
        INT     67H
        MOV     DX,ERROR_EMM
        OR      AH,AH
        JNZ     @@CantRun

;@@@ File Handle方式は、EMSメモリ無しでEMM386を組み込んだ時、通用しない
;        MOV     DX,OFFSET CGROUP:EMM_NAME
;        MOV     AX,3D00H
;        INT     21H
;        JC      @@CantRun	;ファイルがない
;        MOV     BX,AX
;        MOV     AX,4400H
;        INT     21H
;        MOV     AX,DX
;        MOV     DX,ERROR_EMM
;        JC      @@CantRun
;        TEST    AX,80H
;        JZ      @@CantRun	;デバイスではない(ファイルである)
;;@@@ いらないかな？
;;        MOV     AX,4407H
;;        INT     21H
;;        JC      @@CantRun
;;        CMP     AL,0FFH
;;        JNE     @@CantRun	; BUSY状態
;;@@@
;        MOV     AH,3EH
;        INT     21H
;@@@

;VCPIが存在するか？
;-------------------------
        MOV     AX,0DE00H
        INT     67H
        MOV     DX,ERROR_DRV
        TEST    AH,AH
        JZ      @@VCPIMode
@@CantRun:
        MOV     AX, -1
	JMP	@@Exit

@@RealMode:
	MOV	AX, 0
	JMP	@@Exit
@@VCPIMode:
	MOV	AX, 1
	JMP	@@Exit
@@DPMIMode:
	MOV	AX, 2
@@Exit:
    ASSUME  DS:NOTHING,ES:NOTHING
        RET

getCpuMode_	ENDP

;**************************
;ﾘｱﾙﾓｰﾄﾞに戻る
;
;       入力    なし
;       出力    なし
;       破壊    EAX,EDX
;**************************
LEAVE_PROTECT PROC C NEAR USES EAX EBX EDX

    ASSUME  DS:NOTHING,ES:NOTHING

        TEST    CS:[FLAG],@DPMI
        JNZ     @@DPMI

        TEST    CS:[FLAG],@VCPI
        JNZ     @@VCPI

        MOV     AX,DSEL_CODE
        MOV     DS,AX
    ASSUME  DS:NOTHING
        MOV     ES,AX
    ASSUME  ES:NOTHING
        MOV     EAX,CR0
        AND     AL,NOT 1
        MOV     CR0,EAX
        MOV     CS:[DSEL_CODE],CS
        STI
@@DPMI:
        MOV     AX,CS:[DSEL_CODE]
        MOV     ES,AX
    ASSUME  ES:CGROUP
        MOV     DS,AX
    ASSUME  DS:CGROUP
        RET

@@VCPI:
        MOV     EDX,ESP
        MOVZX   EAX,CS:[CODE_SEG]
        MOVZX   EBX,CS:[STACK_SEG]
        PUSH    EAX    ;GS
        PUSH    EAX    ;FS
        PUSH    EAX    ;DS
        PUSH    EAX    ;ES
        PUSH    EBX    ;SS
        PUSH    EDX    ;ESP
        PUSHFD         ;EFLAGS
        PUSH    EAX    ;CS
        MOV     AX,OFFSET CGROUP:@@RET_V86
        PUSH    EAX    ;EIP
        MOV     AX,DSEL_FULL
        MOV     DS,AX
    ASSUME  DS:NOTHING
        MOV     AX,0DE0CH
        CALL    FWORD PTR CS:[VCPI_ENTRY]
        JMP     $
@@RET_V86:
    ASSUME  DS:CGROUP,ES:CGROUP
        MOV     [DSEL_CODE],CS
        RET

LEAVE_PROTECT ENDP
;**************************
;ﾌﾟﾛﾃｸﾄﾓｰﾄﾞに移行
;
;       入力    なし
;       出力    CY	0)Success
;			1)Failure
;       破壊    なし
;**************************
ENTER_PROTECT PROC C NEAR USES EAX EBX ECX EDX ESI

	PUSH	CS
	PUSH	CS
	POP	DS
	POP	ES

    ASSUME  DS:CGROUP,ES:CGROUP

        TEST    [FLAG],@DPMI
        JNZ     @@DPMI

        CLI
        MOV     [DSEL_CODE],DSEL
        TEST    [FLAG],@VCPI
        JNZ     @@VCPI

        LGDT    [GDTR_PARA]
        MOV     EAX,CR0
        OR      AL,1	;CY=0
        MOV     CR0,EAX
@@DPMI:			;DPMI NOT SUPPORT
        RET

@@VCPI:
        MOV     [STACK_BAK],SP
	MOV	[STACK_SEG],SS
        XOR     EAX,EAX
        XOR     ESI,ESI
        MOV     AX,CS
        SHL     EAX,4
        MOV     SI,OFFSET CGROUP:VCPI_PROTECT_TBL
        ADD     ESI,EAX
        MOV     AX,0DE0CH
        INT     67H
        MOV     DX,ERROR_VCPI
	STC
	RET
VCPI_ENTER_PROTECT:
	MOV	AX,DSEL
	MOV	DS,AX
    ASSUME  DS:CGROUP
	MOV	ES,AX
    ASSUME  ES:CGROUP
	MOV	FS,AX
    ASSUME  FS:CGROUP
	MOV	GS,AX
    ASSUME  GS:CGROUP
	MOV	AX,SSEL
	MOV	SS,AX
    ASSUME  SS:CGROUP
        MOVZX   ESP,[STACK_BAK]

        MOV     [DSEG_SORC].BASE,0
        MOV     [DSEG_SORC].HIBASE,40H
        MOV     [DSEG_SORC].MSBASE,0

        MOV     [DSEG_DEST].BASE,0
        MOV     [DSEG_DEST].HIBASE,48H
        MOV     [DSEG_DEST].MSBASE,0
	CLC
        RET

ENTER_PROTECT ENDP

;**************************
;DEST_SELのBASE AddressとLimitを変更
;
;       入力    ESI     Base address
;               ECX     Limit
;       出力    DS:ESI  先頭アドレス
;               CY      0)ｾｸﾞﾒﾝﾄ取得成功
;                       1)ｾｸﾞﾒﾝﾄ取得失敗
;       破壊    なし
;**************************
GET_SORC_SEL PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        PUSH    CS:[DSEL_CODE]
        POP     DS
    ASSUME  DS:CGROUP

        TEST    [FLAG],@DPMI
        JNZ     @@DPMI

        TEST    [FLAG],@VCPI
        JNZ     @@VCPI

        PUSH    EAX
        MOV     EAX,ESI
        MOV     [DSEG_SORC].BASE,AX
        SHR     EAX,16
        MOV     [DSEG_SORC].HIBASE,AL
        MOV     [DSEG_SORC].MSBASE,AH

        XOR     ESI,ESI
        MOV     DS,[SORC_SEL]
    ASSUME  DS:NOTHING
        POP     EAX
        RET

;-----------------------
; VCPIでは、256KB分だけ割り当てる
;-----------------------
@@VCPI:

    ASSUME  DS:CGROUP

        PUSH    EAX
        PUSH    BX
        MOV     AX,DSEL_PAGE
        MOV     DS,AX
    ASSUME  DS:NOTHING
        MOV     EAX,ESI
        AND     AX,0F000H
        OR      AL,7
        MOV     BX, 2000H
        .REPEAT
            MOV     DS:[BX],EAX
            ADD     EAX,1000H
            ADD     BX,4
        .UNTIL BX>(2000H+4*(64+1)-1)

        MOV     DS,CS:[SORC_SEL]
    ASSUME  DS:NOTHING
        AND     ESI,0FFFH
	MOV	EAX, DWORD PTR CS:[VCPI_PROTECT_TBL]
	MOV	CR3, EAX	;Flush TLB cache
        POP     BX
        POP     EAX
        RET

@@DPMI:

    ASSUME  DS:CGROUP

        PUSH    AX
        PUSH    BX
        PUSH    ECX
        PUSH    DX
        PUSH    DI

        ;指定物理ﾒﾓﾘを割り当てる
        ;-----------------
        PUSH    ECX
        PUSH    ESI
        POP     CX
        POP     BX
        POP     DI
        POP     SI
        MOV     AX,800H
        INT     31H
        .IF !CARRY?
            ;指定物理ﾒﾓﾘを割り当てたｱﾄﾞﾚｽをｾｸﾞﾒﾝﾄに設定する
            ;---------------------
            MOV     DX,CX
            MOV     CX,BX
            MOV     BX,[SORC_SEL]
            MOV     AX,7
            INT     31H
            .IF CARRY?
                PUSH    ESI
                POP     CX
                POP     BX
                MOV     AX,801H
                INT     31H
                STC
            .ELSE
                MOV     DS,BX
            ASSUME  DS:NOTHING
                XOR     ESI,ESI
            .ENDIF
        .ENDIF
        POP     DI
        POP     DX
        POP     ECX
        POP     BX
        POP     AX
        RET

GET_SORC_SEL ENDP

;**************************
;DEST_SELのBASE AddressとLimitを変更
;
;       入力    EDI     Base address
;               ECX     Limit size
;       出力    ES:EDI  先頭アドレス
;               CY      0)ｾｸﾞﾒﾝﾄ取得成功
;                       1)ｾｸﾞﾒﾝﾄ取得失敗
;       破壊    なし
;**************************
GET_DEST_SEL PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        PUSH    CS:[DSEL_CODE]
        POP     ES
    ASSUME  ES:CGROUP

        TEST    ES:[FLAG],@DPMI
        JNZ     @@DPMI

        TEST    ES:[FLAG],@VCPI
        JNZ     @@VCPI

        PUSH    EAX
        MOV     EAX,EDI
        MOV     ES:[DSEG_DEST].BASE,AX
        SHR     EAX,16
        MOV     ES:[DSEG_DEST].HIBASE,AL
        MOV     ES:[DSEG_DEST].MSBASE,AH

        XOR     EDI,EDI
        MOV     ES,ES:[DEST_SEL]
    ASSUME  ES:NOTHING
        POP     EAX
        RET

;-----------------------
; VCPIでは、256KB分だけ割り当てる
;-----------------------
@@VCPI:

    ASSUME  ES:CGROUP

        PUSH    EAX
        PUSH    BX
        MOV     AX,DSEL_PAGE
        MOV     ES,AX
    ASSUME  DS:NOTHING
        MOV     EAX,EDI
        AND     AX,0F000H
        OR      AL,7
        MOV     BX, 2200H
        .REPEAT
            MOV     ES:[BX],EAX
            ADD     EAX,1000H
            ADD     BX,4
        .UNTIL BX>(2200H+4*(64+1)-1)

        MOV     ES,CS:[DEST_SEL]
    ASSUME  ES:NOTHING
        AND     EDI,0FFFH
	MOV	EAX, DWORD PTR CS:[VCPI_PROTECT_TBL]
	MOV	CR3, EAX	;Flush TLB cache
        POP     BX
        POP     EAX
        RET

@@DPMI:

    ASSUME  ES:CGROUP

        PUSH    AX
	PUSH	BX
        PUSH    ECX
	PUSH	DX
        PUSH    SI

        ;指定物理ﾒﾓﾘを割り当てる
        ;-----------------
        PUSH    ECX
        PUSH    EDI
        POP     CX
        POP     BX
        POP     DI
        POP     SI
        MOV     AX,800H
        INT     31H
        .IF !CARRY?
            ;指定物理ﾒﾓﾘを割り当てたｱﾄﾞﾚｽをｾｸﾞﾒﾝﾄに設定する
            ;---------------------
            MOV     DX,CX
            MOV     CX,BX
            MOV     BX,[DEST_SEL]
            MOV     AX,7
            INT     31H
            .IF CARRY?
                PUSH    ESI
                POP     CX
                POP     BX
                MOV     AX,801H
                INT     31H
                STC
            .ELSE
                MOV     ES,BX
            ASSUME  ES:NOTHING
                XOR     EDI,EDI
            .ENDIF
        .ENDIF
        POP     SI
	POP	DX
        POP     ECX
	POP	BX
        POP     AX
        RET

GET_DEST_SEL ENDP

;**************************
;SORC_SELに割り当てたｾﾚｸﾀを開放
;
;       入力    なし
;       出力    なし
;       破壊    なし
;**************************
FREE_SORC_SEL PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        TEST    CS:[FLAG],@DPMI
        JZ      @@END

;@@@ Win95のDPMIは Ver0.90でも 物理ﾒﾓﾘ開放ﾌｧﾝｸｼｮﾝが存在するらしいのでﾊﾞｰｼﾞｮﾝﾁｪｯｸは削除 @@@
;        CMP     CS:[DPMI_VER],100H
;        JB      @@END
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   ;DPMI V1.00以上の場合は、割り当てた物理ﾒﾓﾘを開放
   ;------------------------
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        MOV     BX,CS:[SORC_SEL]
        MOV     AX,6
        INT     31H
        .IF !CARRY?
            MOV     BX,CX
            MOV     CX,DX
            MOV     AX,0801H
            INT     31H
        .ENDIF
        POP     DX
        POP     CX
        POP     BX
        POP     AX
@@END:
        RET

FREE_SORC_SEL ENDP

;**************************
;DEST_SELに割り当てたｾﾚｸﾀを開放
;
;       入力    なし
;       出力    なし
;       破壊    なし
;**************************
FREE_DEST_SEL PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        TEST    CS:[FLAG],@DPMI
        JZ      @@END

;@@@ Win95のDPMIは Ver0.90でも 物理ﾒﾓﾘ開放ﾌｧﾝｸｼｮﾝが存在するらしいのでﾊﾞｰｼﾞｮﾝﾁｪｯｸは削除 @@@
;        CMP     CS:[DPMI_VER],100H
;        JB      @@END
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   ;DPMI V1.00以上の場合は、割り当てた物理ﾒﾓﾘを開放
   ;------------------------
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        MOV     BX,CS:[DEST_SEL]
        MOV     AX,6
        INT     31H
        .IF !CARRY?
            MOV     BX,CX
            MOV     CX,DX
            MOV     AX,0801H
            INT     31H
        .ENDIF
        POP     DX
        POP     CX
        POP     BX
        POP     AX
@@END:
        RET

FREE_DEST_SEL ENDP

;********************************
;CPU動作ﾓｰﾄﾞﾁｪｯｸ
;
;    入力    なし
;    出力    CY     1)動作できない
;    破壊    なし
;********************************
CHK_CPU_MODE	PROC C NEAR USES CX DX DS

	PUSH	CS
	PUSH	CS
	POP	DS
	POP	ES

    ASSUME  DS:CGROUP,ES:CGROUP

         MOV     [DSEL_CODE],CS

;CPU動作モード判定
;------------------------
         SMSW    AX
         TEST    AL,1
         JZ      @@REAL_MODE

;DPMIをｻﾎﾟｰﾄするかﾁｪｯｸ
;-----------------------
         MOV     AX,1687H           ;DPMI Check
         INT     2FH                ;
    ASSUME  ES:NOTHING
         TEST    AX,AX
         JNZ     @@CHK_VCPI

;         MOV     WORD PTR [DPMI_ENTRY],DI
;         MOV     WORD PTR [DPMI_ENTRY+2],ES
;         MOV     [DPMI_VER],DX
;         MOV     [ADRS_FLG],BX
;         MOV     [CPU_TYPE],CL
;         MOV     [PRVDT_SZ],SI
;
;         MOV     DX,ERROR_CPU
;         CMP     CL,3
;         JB      @@CANT_RUN         ;CPUが80386より前のものである
;
;         PUSH    DS
;         POP     ES
;    ASSUME  ES:CGROUP
;         TEST    SI,SI
;         JZ      @@NO_PRVDT
;         MOV     AH,48H             ;Memory Allocate
;         MOV     BX,SI              ;  for DPMI Private Data Segment
;         INT     21H                ;
;         MOV     DX,ERROR_MEMORY
;         JC      @@CANT_RUN         ; Jump if Memory can't allocate
;@@NO_PRVDT:
;         MOV     [PRVDT_SEG],AX       ;  AX=MCB
;         MOV     ES,[PRVDT_SEG]
;    ASSUME  ES:NOTHING
;         MOV     AX,0000H
;         CALL    [DPMI_ENTRY]
;         MOV     DX,ERROR_DPMI_PROT
;         JC      @@DPMI_CANT_RUN
;
;         PUSH    DS
;         POP     ES
;    ASSUME  ES:CGROUP
;         MOV     [DSEL_CODE],DS
;
;         MOV     AX,0400H
;         INT     31H
;         MOV     [DPMI_VER],AX
;         MOV     [MPIC_VECT_NO],DH
;         MOV     [SPIC_VECT_NO],DL
;
;         ; Allocate 3 descriptors
;         ;-------------------
;         MOV     AX,0
;         MOV     CX,3
;         INT     31H
;         JC      @@DPMI_FUNC_ERROR
;         MOV     BX,AX
;         MOV     [DATA_SEL],AX       ; Save base selector
;
;         ;Change DATA_SEL limit to max.
;         ;----------------------
;         PUSH    BX
;         MOV     CX,0FFFFH
;         MOV     DX,0FFFFH
;         MOV     AX,8
;         INT     31H
;         POP     BX
;         JC      @@DPMI_FUNC_ERROR
;
;         ;Change DATA_SEL access rigit.
;         ;----------------------
;         MOV     AX,9
;         MOV     CX,8093H
;         INT     31H
;         JC      @@DPMI_FUNC_ERROR
;
;         ;Get next selector value for SORC_SEL and DEST_SEL.
;         ;----------------------
;         MOV     AX,3
;         INT     31H
;         JC      @@CANT_RUN
;         MOV     BX,[DATA_SEL]
;         ADD     BX,AX
;         MOV     [SORC_SEL],BX
;         ADD     BX,AX
;         MOV     [DEST_SEL],BX
;
;         ;Tempolary change SORC_SEL limit to max.
;         ;----------------------
;         MOV     BX, [SORC_SEL]
;         MOV     AX,8
;         MOV     CX,-1
;         MOV     DX,-1
;         INT     31H
;         JC      @@DPMI_FUNC_ERROR
;
;         ;Change SORC_SEL access rigit.
;         ;----------------------
;         MOV     AX,9
;         MOV     CX,8093H
;         INT     31H
;         JC      @@DPMI_FUNC_ERROR
;
;         ;Tempolary change DEST_SEL limit to max.
;         ;----------------------
;         MOV     BX, [DEST_SEL]
;         MOV     AX,8
;         MOV     CX,-1
;         MOV     DX,-1
;         INT     31H
;         JC      @@DPMI_FUNC_ERROR
;
;         ;Change DEST_SEL access rigit.
;         ;----------------------
;         MOV     AX,9
;         MOV     CX,8093H
;         INT     31H
;         JC      @@DPMI_FUNC_ERROR
         PUSH    DS
         POP     ES
    ASSUME  ES:CGROUP
        MOV     DX,ERROR_DPMI_PROT
        OR      [FLAG],@DPMI
        STC
        RET

;VCPIをｻﾎﾟｰﾄするかﾁｪｯｸ
;-----------------------
@@CHK_VCPI:

    ASSUME  ES:NOTHING
        PUSH    CS
        POP     ES
    ASSUME  ES:CGROUP

;EMM386が存在するか？
;-----------------------
        PUSH    DS
        XOR     AX,AX
        MOV     DS,AX
        MOV     DS,WORD PTR DS:[67H*4+2]
        MOV     AX,WORD PTR DS:[0AH]
        MOV     CL,BYTE PTR DS:[0AH+2]
        POP     DS
        MOV     DX,ERROR_EMM
        CMP     AX,'ME'
        JNE     @@CANT_RUN
        CMP     CL,'M'
        JNE     @@CANT_RUN

        MOV     AH,40H
        INT     67H
        MOV     DX,ERROR_EMM
        OR      AH,AH
        JNZ     @@CANT_RUN

;@@@ File Handle方式は、EMSメモリ無しでEMM386を組み込んだ時、通用しない
;        MOV     DX,OFFSET CGROUP:EMM_NAME
;        MOV     AX,3D00H
;        INT     21H
;        JC      @@CANT_RUN	;ファイルがない
;        MOV     BX,AX
;        MOV     AX,4400H
;        INT     21H
;        MOV     AX,DX
;        MOV     DX,ERROR_EMM
;        JC      @@CANT_RUN
;        TEST    AX,80H
;        JZ      @@CANT_RUN	;デバイスではない(ファイルである)
;;@@@ いらないかな？
;;        MOV     AX,4407H
;;        INT     21H
;;        JC      @@CANT_RUN
;;        CMP     AL,0FFH
;;        JNE     @@CANT_RUN	; BUSY状態
;;@@@
;        MOV     AH,3EH
;        INT     21H
;@@@

;VCPIが存在するか？
;-------------------------
        MOV     AX,0DE00H
        INT     67H
        MOV     DX,ERROR_DRV
        TEST    AH,AH
        JNZ     @@CANT_RUN      ;VCPI無し

    ;VCPI情報取得
    ;-------------------------
        MOV     AX,CS
        MOVZX   DX,AH
        SHL     AX,4
        SHR     DL,4
        ADD     AX,OFFSET CGROUP:PAGE_TBL_BUF+0FFFH
        ADC     DL,0
        AND     AX,0F000H
        MOV     WORD PTR [VCPI_PROTECT_TBL],AX
        MOV     BYTE PTR [VCPI_PROTECT_TBL+2],DL
        MOV     [DSEG_PAGE].BASE,AX
        MOV     [DSEG_PAGE].HIBASE,DL
        MOV     [DSEG_SORC].LIMIT,0FFFFH
        MOV     [DSEG_SORC].BASE,0
        MOV     [DSEG_SORC].HIBASE,40H
        MOV     [DSEG_DEST].LIMIT,0FFFFH
        MOV     [DSEG_DEST].BASE,0
        MOV     [DSEG_DEST].HIBASE,48H
        ;ﾍﾟｰｼﾞﾃﾞｨﾚｸﾄﾘｴﾝﾄﾘ作成
        ;------------------------
        PUSH    DX
        PUSH    AX
        POP     EAX
        MOV     EDX,EAX
        SHR     EDX,4
        MOV     ES,DX
    ASSUME  ES:NOTHING
        ADD     EAX,1007H

        MOV     DWORD PTR ES:[0],EAX
        MOV     BX,4
        ADD     EAX,1000H
        .REPEAT
            MOV     DWORD PTR ES:[BX],EAX
            ADD     BX,4
        .UNTIL !(BX & 0FFFH)

        ;ﾍﾟｰｼﾞﾃｰﾌﾞﾙｴﾝﾄﾘ作成
        ;------------------------
        MOV     EAX,00100007H
        MOV     BX,1000H
        .REPEAT
            MOV     DWORD PTR ES:[BX],EAX
            ADD     BX,4
        .UNTIL BX >=3000H

        MOV     DI,1000H
        MOV     SI,OFFSET CGROUP:VCPI_DESC
        MOV     AX,0DE01H
        INT     67H
        PUSH    CS
        POP     ES
    ASSUME  ES:CGROUP
        MOV     DX,ERROR_VCPI
        TEST    AH,AH
;        JNZ     @@CANT_RUN      ;取得できず

        MOV     [CODE_SEG],CS
        MOV     [VCPI_ENTRY],EBX
        OR      [FLAG],@VCPI

@@REAL_MODE:

    ASSUME  DS:CGROUP,ES:CGROUP
        CALL    MAKE_GDT
        CLC
        RET

@@DPMI_FUNC_ERROR:
        MOV     DX,ERROR_DPMI

@@DPMI_CANT_RUN:
	;Free Allocated Memory for DPMI
	;------------------
	MOV     ES,[PRVDT_SEG]
        MOV     AH,49H             ;Free Memory
        INT     21H

@@CANT_RUN:
        STC
        RET



CHK_CPU_MODE	ENDP



;********************************
;GDT作成
;********************************
MAKE_GDT	PROC	NEAR

    ASSUME  DS:CGROUP,ES:CGROUP

;GDTﾃｰﾌﾞﾙの初期化
;------------------------
	;Stack Segment初期化
	;--------------------------
        MOV	AX,SS
	MOV	DL,AH
	SHL	AX,4
	SHR	DL,4
        MOV     [SSEG].BASE,AX
        MOV     [SSEG].HIBASE,DL

        ;Code Segmen初期化
        ;--------------------------
        MOV	AX,CS
        MOV	DL,AH
        SHL	AX,4
        SHR	DL,4
        ADD     WORD PTR [GDTR_PARA+2],AX
        ADC     BYTE PTR [GDTR_PARA+4],DL
        MOV     [CSEG16].BASE,AX
        MOV     [CSEG16].HIBASE,DL
        MOV     [DSEG].BASE,AX
        MOV     [DSEG].HIBASE,DL

;VCPI用
;----------------------
        ADD     [TSS_DESC].BASE,AX
        ADC     [TSS_DESC].HIBASE,DL

        ;VCPI ﾌﾟﾛﾃｸﾄﾓｰﾄﾞ移行用ﾃｰﾌﾞﾙ初期化
        ;-------------------------
        ADD     WORD PTR [VCPI_PROTECT_TBL+4],AX
        ADC     BYTE PTR [VCPI_PROTECT_TBL+6],DL
        ADD     WORD PTR [VCPI_PROTECT_TBL+8],AX
        ADC     BYTE PTR [VCPI_PROTECT_TBL+10],DL

        RET

MAKE_GDT	ENDP

;********************************
;A20をOnにする
;********************************
A20_ON PROC NEAR

    ASSUME  DS:CGROUP,ES:CGROUP

        TEST    [FLAG],@DPMI
        JNZ     @@END

        PUSH    AX
        PUSH    BX
        PUSH    DS
        PUSH    ES

;A20が既にOnになっている場合は、何もしない
;---------------------
        XOR     AX,AX
        MOV     ES,AX
    ASSUME  ES:NOTHING
        DEC     AX
        MOV     DS,AX
    ASSUME  DS:NOTHING

        CLI
        MOV     AX,ES:[0]
        MOV     BX,DS:[10H]
        NOT     AX
        MOV     DS:[10H],AX
        CMP     AX,ES:[0]
        MOV     DS:[10H],BX
        STI
        JNE     @@A20_ON_END

        MOV     AX,4300H
        INT     2FH
        CMP     AH,80H
        JNE     @@A20_DIRECT

        XOR     BX,BX
        MOV     ES,BX
    ASSUME  ES:NOTHING
        MOV     AX,4310H
        INT     2FH
    ASSUME  ES:NOTHING
        MOV     AX,ES
        OR      AX,BX
        JZ      @@A20_DIRECT

;HIMEM.SYSを使用
;----------------------
@@USE_HIMEM:
        PUSH    CS
        PUSH    OFFSET CGROUP:@@RET_HIMEM
        PUSH    ES
        PUSH    BX
        MOV     AH,3
        RETF
@@RET_HIMEM:
        TEST    AX,AX
        JZ      @@A20_DIRECT

@@A20_ON_END:
        POP     ES
    ASSUME  ES:CGROUP
        POP     DS
    ASSUME  DS:CGROUP
        POP     BX
        POP     AX

@@END:
        RET


;直接制御
;------------------------
@@A20_DIRECT:
        CLI

@@WAIT_IBF1:
        IN      AL,64H
        TEST    AL,2
        JNZ     @@WAIT_IBF1
        MOV     AL,0D1H
        OUT     64H,AL

@@WAIT_IBF2:
        IN      AL,64H
        TEST    AL,2
        JNZ     @@WAIT_IBF2
        MOV     AL,0DFH
        OUT     60H,AL

;KBCが本当にコマンド処理終了するまで待つ
;---------------------------
    ;ダミーのコマンドを送信
    ;-------------------
@@WAIT_IBF3:
        IN      AL,64H
        TEST    AL,2
        JNZ     @@WAIT_IBF3
        MOV     AL,0FFH
        OUT     64H,AL
    ;ダミーのコマンドの処理が終わるのを待つ
    ;-------------------
@@WAIT_IBF4:
        IN      AL,64H
        TEST    AL,2
        JNZ     @@WAIT_IBF4

        STI
        POP     ES
    ASSUME  ES:CGROUP
        POP     DS
    ASSUME  DS:CGROUP
        POP     BX
        POP     AX
        RET

A20_ON ENDP


VCPI_PROTECT_TBL LABEL BYTE

        DW      CGROUP:PAGE_TBL_BUF,0   ;CR3
        DW      CGROUP:GDTR_PARA,0
        DW      CGROUP:IDTR_PARA,0
        DW      0                ;LDTR
        DW      TSS_SEL       ;TR
        DW      CGROUP:VCPI_ENTER_PROTECT,0,CSEL16

IDTR_PARA LABEL FWORD
        DW      3FFh
        DW      0,0

GDTR_PARA LABEL	FWORD
	DW	GDT_END-GDT-1	; LIMIT
	DW	CGROUP:GDT,0

DESC	STRUC

	LIMIT	DW	?
	BASE	DW	?
	HIBASE	DB	?
	ACCESS	DB	?
	HILIMIT	DB	?
	MSBASE	DB	?

DESC	ENDS

GDT	LABEL	BYTE
          DESC<>                               ;DUMMY
TSS_DESC  DESC<SIZE PROTECT_TSS-1,CGROUP:PROTECT_TSS,000h,89h,00h,000h> ;TSS
CSEG16    DESC<0FFFFH,0000h,000H,9BH,10H,000H> ;Code
DSEG      DESC<0FFFFH,0000h,000H,93H,10H,000H> ;Data(Code)
DSEG_SORC DESC<0FFFFH,0000h,000H,93H,9FH,000H> ;Source Data Area
DSEG_DEST DESC<0FFFFH,0000h,000H,93H,9FH,000H> ;Destination Data Area
DSEG_FFFF DESC<0FFFFH,0000h,000H,93H,10H,000H> ;Data First 64KB
DSEG_FULL DESC<0FFFFH,0000h,000H,93H,9FH,000H> ;Data Full
SSEG      DESC<0FFFFH,0000h,000H,93H,10H,000H> ;Stack
DSEG_PAGE DESC<03FFFH,0000h,000h,93h,10h,000h> ;Data Page Table
VCPI_DESC LABEL BYTE
          DESC<>                               ;VCPI Interface's Code Segment
          DESC<>                               ;for main control program
          DESC<>                               ;for main control program
GDT_END  LABEL   BYTE

TSS_SEL   EQU TSS_DESC-GDT
CSEL16    EQU CSEG16-GDT
DSEL      EQU DSEG-GDT
DSEL_SORC EQU DSEG_SORC-GDT
DSEL_DEST EQU DSEG_DEST-GDT
DSEL_FFFF EQU DSEG_FFFF-GDT
DSEL_FULL EQU DSEG_FULL-GDT
SSEL      EQU SSEG-GDT
DSEL_PAGE EQU DSEG_PAGE-GDT
CSEL_VCPI EQU VCPI_DESC-GDT

DPMI_ENTRY   DD   ?
DPMI_VER     DW   ?
ADRS_FLG     DW   ?
CPU_TYPE     DB   ?
PRVDT_SZ     DW   ?
PRVDT_SEG    DW   ?
SORC_SEL     DW   DSEL_SORC
DEST_SEL     DW   DSEL_DEST
DSEL_CODE    DW   ?
DATA_SEL     DW   0
VCPI_ENTRY   DD   ?
             DW   CSEL_VCPI
STACK_BAK    DW   ?
STACK_SEG    DW   ?
CODE_SEG     DW   ?
PAGE_SEG     DW   ?
MPIC_VECT_NO DB   8
SPIC_VECT_NO DB   70H

FLAG         DW   0
@DPMI        EQU 1 SHL 4   ;DPMIでﾒﾓﾘｱｸｾｽ
@VCPI        EQU 1 SHL 5   ;VCPIでﾒﾓﾘｱｸｾｽ

EMM_NAME DB    'EMMXXXX0',0

PROTECT_TSS   DD 26 DUP(?)
PAGE_TBL_BUF  DB 4096*4 DUP(?)


TEXT ENDS
     END
