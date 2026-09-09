;use  TASM.EXE V2.01 or later
;
;      TASM /jSMART /jJUMPS /uM520 /jLOCALS /m8 /t
;

.386P
CGROUP	GROUP TEXT, _TEXT

TEXT SEGMENT BYTE PUBLIC 'CODE' USE16

	EXTRN	C preInitHimem_:NEAR
	EXTRN	C maskNMI_:NEAR
	EXTRN	C unmaskNMI_:NEAR
	EXTRN	C readHimemByte_:NEAR
	EXTRN	C writeHimemByte_:NEAR
	EXTRN	C readHimemWord_:NEAR
	EXTRN	C writeHimemWord_:NEAR
	EXTRN	C readHimemLong_:NEAR
	EXTRN	C writeHimemLong_:NEAR
	EXTRN	C readHimemBlockByte_:NEAR
	EXTRN	C writeHimemBlockByte_:NEAR
	EXTRN	C readHimemBlockWord_:NEAR
	EXTRN	C writeHimemBlockWord_:NEAR
	EXTRN	C readHimemBlockLong_:NEAR
	EXTRN	C writeHimemBlockLong_:NEAR
	EXTRN	C copyHimemByte_:NEAR
	EXTRN	C copyHimemWord_:NEAR
	EXTRN	C copyHimemLong_:NEAR
	EXTRN	C fillHimemByte_:NEAR
	EXTRN	C fillHimemWord_:NEAR
	EXTRN	C fillHimemLong_:NEAR
	EXTRN	C getCpuMode_:NEAR

TEXT ENDS

_TEXT SEGMENT BYTE PUBLIC 'CODE' USE16
     ASSUME  CS:CGROUP,DS:NOTHING,ES:NOTHING

;**************************
; Pre-Initialize the Himem access functions
;
; int _preInitHimem()
;
;       ì¸óÕ    None
;       èoóÕ    AX	0)Success
;                      -1)False
;       îjâÛ    None
;**************************
_preInitHimem PROC C NEAR PUBLIC USES BX ES

	CALL	preInitHimem_
	RET

_preInitHimem ENDP

;**************************
; mask NMI
;
; void _maskNMI();
;
;       ì¸óÕ    Nothing
;       èoóÕ    Nothing
;       îjâÛ    Nothing
;**************************
_maskNMI PROC C NEAR PUBLIC

	JMP	maskNMI_

_maskNMI ENDP

;**************************
; unmask NMI
;
; void _unmaskNMI();
;
;       ì¸óÕ    Nothing
;       èoóÕ    Nothing
;       îjâÛ    Nothing
;**************************
_unmaskNMI PROC C NEAR PUBLIC

	JMP	unmaskNMI_

_unmaskNMI ENDP

;**************************
; read byte data from Himem
;
; unsigned char _readHimemByte(unsigned long Address)
;
;       ì¸óÕ    [SP-2].L	Read address
;       èoóÕ    AL
;       îjâÛ    Ç»Çµ
;**************************
_readHimemByte PROC C NEAR PUBLIC USES BX ES,address:DWORD

	MOV	AX, WORD PTR address
	MOV	BX, WORD PTR address+2
	CALL	readHimemByte_
	RET

_readHimemByte ENDP

;**************************
; write byte data to Himem
;
; void _writeHimemByte(unsigned long Address,unsigned char Data)
;
;       ì¸óÕ    [SP-2].L	write address
;		[SP-6].B	write data
;       èoóÕ    Ç»Çµ
;       îjâÛ    Ç»Çµ
;**************************
_writeHimemByte PROC C NEAR PUBLIC USES AX BX CX ES,address:DWORD,data:BYTE

	MOV	AX, WORD PTR address
	MOV	BX, WORD PTR address+2
	MOV	CL, data
	CALL	writeHimemByte_
	RET

_writeHimemByte ENDP


;**************************
; read word data from Himem
;
; unsigned short int _readHimemWord(unsigned long Address)
;
;       ì¸óÕ    [SP-2].L	Read address
;       èoóÕ    AX
;       îjâÛ    Ç»Çµ
;**************************
_readHimemWord PROC C NEAR PUBLIC USES BX ES,address:DWORD

	MOV	AX, WORD PTR address
	MOV	BX, WORD PTR address+2
	CALL	readHimemWord_
	RET

_readHimemWord ENDP

;**************************
; write word data to Himem
;
; void _writeHimemWord(unsigned long Address,unsigned int Data)
;
;       ì¸óÕ    [SP-2].L	write address
;		[SP-6].W	write data
;       èoóÕ    Ç»Çµ
;       îjâÛ    Ç»Çµ
;**************************
_writeHimemWord PROC C NEAR PUBLIC USES AX BX CX ES,address:DWORD,data:WORD

	MOV	AX, WORD PTR address
	MOV	BX, WORD PTR address+2
	MOV	CX, data
	CALL	writeHimemWord_
	RET

_writeHimemWord ENDP

;**************************
; read long data from Himem
;
; unsigned long _readHimemLong(unsigned long Address)
;
;       ì¸óÕ    [SP-2].L	write address
;       èoóÕ    DX:AX	Read Data
;       îjâÛ    Ç»Çµ
;**************************
_readHimemLong PROC C NEAR PUBLIC USES BX ES,address:DWORD

	MOV	AX, WORD PTR address
	MOV	BX, WORD PTR address+2
	CALL	readHimemLong_
	MOV	DX, BX
	RET

_readHimemLong ENDP

;**************************
; write long data to Himem
;
; void _writeHimemLong(unsigned long Address,unsigned long Data)
;
;       ì¸óÕ	[SP-2].L	write address
;		[SP-6].L	write data
;       èoóÕ    Ç»Çµ
;       îjâÛ    Ç»Çµ
;**************************
_writeHimemLong PROC C NEAR PUBLIC USES AX BX CX ES,address:DWORD,data:DWORD

	MOV	AX, WORD PTR address
	MOV	BX, WORD PTR address+2
	MOV	CX, WORD PTR data
	MOV	DX, WORD PTR data+2
	CALL	writeHimemLong_
	RET

_writeHimemLong ENDP

;**************************
; read block byte data from Himem
;
; unsigned int _readHimemBlockByte(unsigned long Address,unsigned char *Buffer,unsigned int bytes)
;
;       ì¸óÕ    [SP-2].L	Read address
;		[SP-6].W	Buffer address
;		[SP-8].W	Read Size
;       èoóÕ    AX	Read Size
;       îjâÛ    Ç»Çµ
;**************************
_readHimemBlockByte PROC C NEAR PUBLIC USES BX CX DX,address:DWORD,buffer:WORD,bytes:WORD

	MOV	AX, WORD PTR address
	MOV	BX, WORD PTR address+2
	MOV	CX, buffer
	MOV	DX, bytes
	CALL	readHimemBlockByte_
	RET

_readHimemBlockByte ENDP

;**************************
; write block byte data to Himem
;
; unsigned int _writeHimemBlockByte(unsigned long Address,unsigned char *Buffer,unsigned int bytes)
;
;       ì¸óÕ    [SP-2].L	Write address
;		[SP-6].W	Buffer address
;		[SP-8].W	Write Size
;       èoóÕ    AX	Write Size
;       îjâÛ    Ç»Çµ
;**************************
_writeHimemBlockByte PROC C NEAR PUBLIC USES BX CX DX,address:DWORD,buffer:WORD,bytes:WORD

	MOV	AX, WORD PTR address
	MOV	BX, WORD PTR address+2
	MOV	CX, buffer
	MOV	DX, bytes
	CALL	writeHimemBlockByte_
	RET

_writeHimemBlockByte ENDP

;**************************
; read block word data from Himem
;
; unsigned int _readHimemBlockWord(unsigned long Address,unsigned char *Buffer,unsigned int words)
;
;       ì¸óÕ    [SP-2].L	Read address
;		[SP-6].W	Buffer address
;		[SP-8].W	Read Size(unit word)
;       èoóÕ    AX	Read Size(unit word)
;       îjâÛ    nothing
;**************************
_readHimemBlockWord PROC C NEAR PUBLIC USES BX CX DX,address:DWORD,buffer:WORD,words:WORD

	MOV	AX, WORD PTR address
	MOV	BX, WORD PTR address+2
	MOV	CX, buffer
	MOV	DX, words
	CALL	readHimemBlockWord_
	RET

_readHimemBlockWord ENDP

;**************************
; write block word data to Himem
;
; unsigned int _writeHimemBlockWord(unsigned long Address,unsigned char *Buffer,unsigned int words)
;
;       ì¸óÕ    [SP-2].L	Write address
;		[SP-6].W	Buffer address
;		[SP-8].W	Write Size(unit word)
;       èoóÕ    AX	Write Size(unit word)
;       îjâÛ    nothing
;**************************
_writeHimemBlockWord PROC C NEAR PUBLIC USES BX CX DX,address:DWORD,buffer:WORD,words:WORD

	MOV	AX, WORD PTR address
	MOV	BX, WORD PTR address+2
	MOV	CX, buffer
	MOV	DX, words
	CALL	writeHimemBlockWord_
	RET

_writeHimemBlockWord ENDP

;**************************
; read block long word data from Himem
;
; unsigned int _readHimemBlockLong(unsigned long Address,unsigned char *Buffer,unsigned int longWords)
;
;       ì¸óÕ    [SP-2].L	Read address
;		[SP-6].W	Buffer address
;		[SP-8].W	Read Size(unit long word)
;       èoóÕ    AX	Read Size(unit long word)
;       îjâÛ    nothing
;**************************
_readHimemBlockLong PROC C NEAR PUBLIC USES BX CX DX,address:DWORD,buffer:WORD,longWords:WORD

	MOV	AX, WORD PTR address
	MOV	BX, WORD PTR address+2
	MOV	CX, buffer
	MOV	DX, longWords
	CALL	readHimemBlockLong_
	RET

_readHimemBlockLong ENDP

;**************************
; write block long word data from Himem
;
; unsigned int _writeHimemBlockLong(unsigned long Address,unsigned char *Buffer,unsigned int longWords)
;
;       ì¸óÕ    [SP-2].L	Write address
;		[SP-6].W	Buffer address
;		[SP-8].W	Write Size(unit long word)
;       èoóÕ    AX	Write Size(unit long word)
;       îjâÛ    nothing
;**************************
_writeHimemBlockLong PROC C NEAR PUBLIC USES BX CX DX,address:DWORD,buffer:WORD,longWords:WORD

	MOV	AX, WORD PTR address
	MOV	BX, WORD PTR address+2
	MOV	CX, buffer
	MOV	DX, longWords
	CALL	writeHimemBlockLong_
	RET

_writeHimemBlockLong ENDP

;**************************
; copy from himem to himem by byte
;
; unsigned int _copyHimemByte(unsigned long SourceAddress,unsigned long DestAddress,unsigned int bytes)
;
;       ì¸óÕ    [SP-2].L	Source address
;		[SP-6].L	Destination address
;		[SP-10].L copy Size(unit byte)
;       èoóÕ    DX:AX	copied Size(unit byte)
;       îjâÛ    nothing
;**************************
_copyHimemByte PROC C NEAR PUBLIC USES BX CX,srcAddress:DWORD,dstAddress:DWORD,bytes:DWORD

	MOV	AX, WORD PTR srcAddress
	MOV	BX, WORD PTR srcAddress+2
	MOV	CX, WORD PTR dstAddress
	MOV	DX, WORD PTR dstAddress+2
	PUSH	bytes
	CALL	copyHimemByte_
	ADD	SP, 4
	MOV	DX, BX
	RET

_copyHimemByte ENDP
;**************************
; copy from himem to himem by word
;
; unsigned int _copyHimemWord(unsigned long SourceAddress,unsigned long DestAddress,unsigned int words)
;
;       ì¸óÕ    [SP-2].L	Source address
;		[SP-6].L	Destination address
;		[SP-10].L copy Size(unit word)
;       èoóÕ    DX:AX	copied Size(unit word)
;       îjâÛ    nothing
;**************************
_copyHimemWord PROC C NEAR PUBLIC USES BX CX,srcAddress:DWORD,dstAddress:DWORD,words:DWORD

	MOV	AX, WORD PTR srcAddress
	MOV	BX, WORD PTR srcAddress+2
	MOV	CX, WORD PTR dstAddress
	MOV	DX, WORD PTR dstAddress+2
	PUSH	words
	CALL	copyHimemWord_
	ADD	SP, 4
	MOV	DX, BX
	RET

_copyHimemWord ENDP
;**************************
; copy from himem to himem by long word
;
; unsigned int _copyHimemLong(unsigned long SourceAddress,unsigned long DestAddress,unsigned int longWords)
;
;       ì¸óÕ    [SP-2].L	Source address
;		[SP-6].L	Destination address
;		[SP-10].L copy Size(unit long word)
;       èoóÕ    DX:AX	copied Size(unit long word)
;       îjâÛ    nothing
;**************************
_copyHimemLong PROC C NEAR PUBLIC USES BX CX,srcAddress:DWORD,dstAddress:DWORD,longWords:DWORD

	MOV	AX, WORD PTR srcAddress
	MOV	BX, WORD PTR srcAddress+2
	MOV	CX, WORD PTR dstAddress
	MOV	DX, WORD PTR dstAddress+2
	PUSH	longWords
	CALL	copyHimemLong_
	ADD	SP, 4
	MOV	DX, BX
	RET

_copyHimemLong ENDP

;**************************
; fill from himem to himem by byte
;
; unsigned int _fillHimemByte(unsigned long Address,unsigned int bytes)
;
;       ì¸óÕ    [SP-2].L	Fill address
;		[SP-6].L	Fill Size(unit byte)
;		[SP-10].B Fill Data
;       èoóÕ    DX:AX	Filled Size(unit byte)
;       îjâÛ    nothing
;**************************
_fillHimemByte PROC C NEAR PUBLIC USES BX CX,address:DWORD,fillSize:DWORD,writeData:BYTE

	MOV	AX, WORD PTR address
	MOV	BX, WORD PTR address+2
	MOV	CX, WORD PTR fillSize
	MOV	DX, WORD PTR fillSize+2
	PUSH	WORD PTR writeData
	CALL	fillHimemByte_
	ADD	SP, 2
	MOV	DX, BX
	RET

_fillHimemByte ENDP
;**************************
; fill from himem to himem by word
;
; unsigned int _fillHimemByte(unsigned long Address,unsigned int words)
;
;       ì¸óÕ    [SP-2].L	Fill address
;		[SP-6].L	Fill Size(unit word)
;		[SP-10].B Fill Data
;       èoóÕ    DX:AX	Filled Size(unit word)
;       îjâÛ    nothing
;**************************
_fillHimemWord PROC C NEAR PUBLIC USES BX CX,address:DWORD,fillSize:DWORD,writeData:WORD

	MOV	AX, WORD PTR address
	MOV	BX, WORD PTR address+2
	MOV	CX, WORD PTR fillSize
	MOV	DX, WORD PTR fillSize+2
	PUSH	writeData
	CALL	fillHimemWord_
	ADD	SP, 2
	MOV	DX, BX
	RET

_fillHimemWord ENDP
;**************************
; fill from himem to himem by long
;
; unsigned int _fillHimemByte(unsigned long Address,unsigned int longWords)
;
;       ì¸óÕ    [SP-2].L	Fill address
;		[SP-6].L	Fill Size(unit long word)
;		[SP-10].B Fill Data
;       èoóÕ    DX:AX	Filled Size(unit long word)
;       îjâÛ    nothing
;**************************
_fillHimemLong PROC C NEAR PUBLIC USES BX CX,address:DWORD,fillSize:DWORD,writeData:DWORD

	MOV	AX, WORD PTR address
	MOV	BX, WORD PTR address+2
	MOV	CX, WORD PTR fillSize
	MOV	DX, WORD PTR fillSize+2
	PUSH	writeData
	CALL	fillHimemLong_
	ADD	SP, 4
	MOV	DX, BX
	RET

_fillHimemLong ENDP

;********************************
;CPUìÆçÏ”∞ƒﬁ¡™Ø∏
;
;    ì¸óÕ    Ç»Çµ
;    èoóÕ    AX		0)Real Mode
;			1)VCPI Mode
;			2)DPMI Mode
;			-1)îªíËÇ≈Ç´Ç∏
;    îjâÛ    Ç»Çµ
;********************************
_getCpuMode	PROC C NEAR PUBLIC

	JMP	getCpuMode_

_getCpuMode	ENDP

_TEXT ENDS

     END

