.386P
CODE	SEGMENT USE16
	ASSUME	CS:CODE,DS:CODE,ES:CODE,SS:CODE

	ORG	80H
CMDLINS	LABEL	BYTE

	ORG	81H
CMDLIN	LABEL	BYTE

	ORG	100h

MAIN    PROC    NEAR

	MOV	SI,OFFSET CMDLIN
ARGCHK:

	CALL	SKIP_SPACE
	JZ	STDINSTDOUT
	CALL	DATAIN
	JNC	EXIT
	MOV	DX,OFFSET ttlmsg
	CALL	MSGPRT_STDERR
	MOV	DX,OFFSET INPMSG
	CALL	MSGPRT_STDERR
EXIT:
	mov	AX,4C00H
	INT	21H

STDINSTDOUT:
	mov	dx,OFFSET ttlmsg
	CALL	MSGPRT_STDERR

KEYIN_LOOP:

	MOV	AL,'I'
	CALL	CPUT_STDERR
	MOV	AL,'O'
	CALL	CPUT_STDERR
	MOV	AL,'>'
	CALL	CPUT_STDERR
	MOV	DX,OFFSET CMDLINS
	MOV	AH,10
	MOV	BX,DX
	MOV	BYTE PTR [BX],128
	INT	21H
	CALL	CRLF

	MOV	SI,OFFSET CMDLINS
	ADD	SI,2

	CMP	BYTE PTR [SI],13
	JE	EXIT
	CMP	BYTE PTR [SI],'Q'
	JE	EXIT
	CMP	BYTE PTR [SI],'q'
	JE	EXIT
	CMP	BYTE PTR [SI],'?'
	JNE	KEYIN_1

	MOV	DX,OFFSET INPMSG
	CALL	MSGPRT_STDERR
	JMP	KEYIN_LOOP

KEYIN_1:
	CALL	DATAIN
	JNC	KEYIN_LOOP

	MOV	DX,OFFSET ERRMSG
	CALL	MSGPRT_STDERR
	JMP	KEYIN_LOOP

MAIN    ENDP



DATAIN  PROC NEAR

	MOV	[FLAG],0
	MOV	[INDEX],0
	MOV	[PORTDATA],0

	;Get Port Address
	;----------------------------
	CALL	HEXGET
	JC	DATAIN_ERR		;ﾎﾟｰﾄｱﾄﾞﾚｽが取得出来ないのでｴﾗｰ
	TEST	EAX,0FFFF0000H
	JNZ	DATAIN_ERR
	MOV	[PORT_ADRS],AX

	;Skip Space
	;----------------------------
	CALL	SKIP_SPACE
	JZ	DATAIN_PORT		;文字列終了(ポートアドレスのみ)

	;Index付き?
	;----------------------------
	CMP	BYTE PTR [SI],'.'
	JNE	DATAOUT_PORT		;Index付では無い

	;Index付きである
	;----------------------------
	OR	[FLAG],00000010B

	INC	SI
	CALL	HEXGET
	JC	DATAIN_ERR		;Index付のﾏｰｸ'.'の次に16進文字列が無いのでｴﾗｰ
	TEST	EAX,0FFFFFF00H
	JNZ	DATAIN_ERR		;ｲﾝﾃﾞｯｸｽ値が大きい
	MOV	[INDEX],AL
	MOV     [INDEX+1],0
	CALL	SKIP_SPACE
	JNZ	DATAOUT_PORT

;********************************
;DATA IN PORT
;********************************
DATAIN_PORT:

        TEST    [FLAG],1 SHL 4
        JZ      DATAIN_PORT_SINGLE

        MOV     BX,OFFSET PORT_ADRS
        TEST    [FLAG],1 SHL 1
        JZ      DATAIN_PORT_1
        MOV     BX,OFFSET INDEX
DATAIN_PORT_1:
        MOV     AX,[BX]
        CMP     AX,[END_AREA]
        JBE     DATAIN_PORT_DUMP
        XCHG    AX,[END_AREA]
        MOV     [BX],AX
DATAIN_PORT_DUMP:

        ;ﾀﾞﾝﾌﾟﾒｯｾｰｼﾞ表示
        ;--------------------------
        MOV     DI,OFFSET HEX_TBL

        MOV     CX, 5
        .IF [FLAG] & (1 SHL 1)
            MOV     CX,8
        .ENDIF

DATAIN_DUMP_MSG_SPC:
        MOV     AH,2
        MOV     DL,' '
        INT     21H
        LOOP    DATAIN_DUMP_MSG_SPC

DATAIN_DUMP_MSG_COL:
        MOV     AH,2
        MOV     DL,'+'
        INT     21H
        MOV     AH,2
        MOV     DL,[DI]
        INT     21H
        INC     DI
        MOV     CX,1
        TEST    [FLAG],1 SHL 0
        JZ      DATAIN_DUMP_MSG_COL_NEXT
        INC     DI
        MOV     CX,3
        TEST    [FLAG],1 SHL 2
        JZ      DATAIN_DUMP_MSG_COL_NEXT
        ADD     DI,2
        MOV     CX,8
DATAIN_DUMP_MSG_COL_NEXT:
        CMP     DI,OFFSET HEX_TBL+16
        JB      DATAIN_DUMP_MSG_SPC
        CALL    CRLF


DATAIN_PORT_ROW_LOOP:
        ;ﾎﾟｰﾄｱﾄﾞﾚｽ表示
        ;--------------------------
        CALL    PRINT_PORT_ADRS
        MOV     AH,2
        MOV     DL,' '
        INT     21H
        ;読込ﾃﾞｰﾀ表示
        ;---------------------------
        MOV     CX,16
DATAIN_PORT_COL_LOOP:

        PUSH    BX
        CALL    READ_PORT
	MOV	[PORTDATA],EAX
	CALL	PRINT_PORT_DATA
        MOV     AH,2
        MOV     DL,' '
        INT     21H
	POP     BX
	MOV     AX,[BX]
        TEST    [FLAG],1 SHL 2
        JZ      DATAIN_NO_DWORD
	SUB     CX,4
        ADD     AX,4
        JMP     DATAIN_PORT_NEXT
DATAIN_NO_DWORD:
        TEST    [FLAG],1 SHL 0
        JZ      DATAIN_NO_WORD
	SUB     CX,2
        ADD     AX,2
        JMP     DATAIN_PORT_NEXT
DATAIN_NO_WORD:
	DEC     CX
        ADD     AX,1
DATAIN_PORT_NEXT:
        JC      DATAIN_DUMP_END
        MOV     [BX],AX
        CMP     AX,[END_AREA]
        JA      DATAIN_DUMP_END
        TEST    CX,CX
        JNZ     DATAIN_PORT_COL_LOOP
        CALL    CRLF
        JMP     DATAIN_PORT_ROW_LOOP
DATAIN_DUMP_END:
        CALL    CRLF
        JMP     DATAIN_NEXT

DATAIN_PORT_SINGLE:
	CALL	READ_PORT
	MOV	[PORTDATA],EAX
	CALL	PRINT_PORT
	JMP	DATAIN_NEXT

;********************************
;DATA OUT PORT
;********************************
DATAOUT_PORT:
		MOV	AL,BYTE PTR [SI]

        ;領域指定か?
        ;--------------------------
                CMP     AL,'-'
                JNE     NO_AREA_CMD

                ;領域指定の場合
                ;------------------------
                INC     SI
                CALL    SKIP_SPACE
                CALL    HEXGET
                JC      DATAIN_ERR         ;表示終了のｱﾄﾞﾚｽまたはｲﾝﾃﾞｯｸｽが取得できない
                MOV     CS:[END_AREA],AX
                OR      CS:[FLAG],1 SHL 4
                TEST    CS:[FLAG],1 SHL 1
                JZ      AREA_CMD           ;ｲﾝﾃﾞｯｸｽ付きではない
                TEST    EAX,0FFFFFF00H
                JNZ     DATAIN_ERR         ;ｲﾝﾃﾞｯｸｽ付きの場合、終了ｲﾝﾃﾞｯｸｽ値が大きすぎる
AREA_CMD:
                TEST    EAX,0FFFF0000H
                JNZ     DATAIN_ERR         ;ﾎﾟｰﾄｱﾄﾞﾚｽが大きすぎる

                JMP     DATAOUT_PORT

NO_AREA_CMD:
		AND	AL,0DFH

		;WORD指定
		;----------------------------
		CMP	AL,'W'
		JNE	DATAIN_PORT_NO_W

		OR	[FLAG],1 SHL 0
                AND     [FLAG],NOT(1 SHL 2)
_DATAOUT_PORT_W:
		TEST	[FLAG],000001000B
		JNZ	DATAOUT_PORT_GO
		INC	SI
		CALL	SKIP_SPACE
		JZ	DATAIN_PORT
		JMP	DATAOUT_PORT

		;DWORD指定
		;----------------------------
DATAIN_PORT_NO_W:
		CMP	AL,'L'
		JNE	DATAIN_PORT_NO_L

		OR	[FLAG],000000101B
		JMP	_DATAOUT_PORT_W
DATAIN_PORT_NO_L:
        ;範囲指定有りの場合、書き込みは行わないので、I/O読込へ
        ;------------------------
                TEST    [FLAG],1 SHL 4
                JNZ     DATAIN_PORT

	;すでに書き込みﾃﾞｰﾀを読んでいたならさっさと書き込みへ行く
	;------------------------
		TEST	[FLAG],00001000B
		JNZ	DATAOUT_PORT_GO

		CMP	AL,'X'
		JE	DATAOUT_BIT
		CMP	AL,'R'
		JE	DATAOUT_BIT
		CMP	AL,'S'
		JE	DATAOUT_BIT
		CMP	AL,'H'
		JE	DATA_WAIT

;書き込みﾃﾞｰﾀ読み込み
;-----------------------
		MOV	DI,SI

	;Hexﾃﾞｰﾀではない場合、ﾏﾙﾁｽﾃｰﾄﾒﾝﾄのｾﾊﾟﾚｰﾀとする
	;-------------------------
		CALL	HEXGET
		JC	DATAIN_PORT		;解釈出来ない文字の場合は無視して、ﾎﾟｰﾄ読み込み処理
		MOV	[PORTDATA],EAX

	;WRITEﾃﾞｰﾀに'.'が付いていたら、WRITEﾃﾞｰﾀではなくINDEX付のI/Oﾎﾟｰﾄｱﾄﾞﾚｽとする
	;-------------------------
		CALL	SKIP_SPACE
		JZ	DATAOUT_PORT_GO		;文字列終了なので'.'は付いていない
		MOV	AL,BYTE PTR [SI]

		CMP	AL,'.'
		JNE	DATAOUT_PORT_1		;'.'ではない

		MOV	SI,DI
		JMP	DATAIN_PORT


	;書き込み方向のﾃﾞｰﾀである
	;--------------------------
DATAOUT_PORT_1:

		OR	[FLAG],00001000B
		JMP	DATAOUT_PORT

;;***********************************************
;;I/Oﾎﾟｰﾄの値が指定ﾊﾟﾀｰﾝになるまで待つ
;;***********************************************
DATA_WAIT:
		INC	SI
		CALL	SKIP_SPACE
		CALL	HEXGET
		JC	DATAIN_ERR
		MOV	[MASK_PATTERN],EAX

		CALL	SKIP_SPACE
		CALL	HEXGET
		JC	DATAIN_ERR
		MOV	[CMP_PATTERN],EAX

		CALL	SKIP_SPACE
		CALL	HEXGET
		JNC	DATA_WAIT_WITH_TIMEOUT

;ﾀｲﾑｱｳﾄ無しの待ち
;-------------------------------
DATA_WAIT_LOOP:
		CALL	READ_PORT
		MOV	[PORTDATA],EAX
		AND	EAX,[MASK_PATTERN]

		CMP	EAX,[CMP_PATTERN]
		JNE	DATA_WAIT_LOOP
		JMP	DATA_WAIT_END

;ﾀｲﾑｱｳﾄ付の待ち
;-------------------------------
DATA_WAIT_WITH_TIMEOUT:
	;ﾀｲﾑｱｳﾄ時間の範囲ﾁｪｯｸ
	;-----------------------
		TEST	EAX,0FFFFFF00H
		JNZ	DATAIN_ERR

		;待ち時間をBCDからHexに変換
		;-------------------
		MOV	AH,AL
		MOV	CL,4
		SHR	AH,CL
		AND	AL,0FH
		AAD

		CMP	AL,59
		JA	DATAIN_ERR
		MOV	[TIME_CNT],AL

		PUSH	DX
		MOV	AH,2CH
		INT	21H
		MOV	[TIME_BAK],DH
		POP	DX

DATA_WAIT_LOOP1:
		MOV	CX,100
DATA_WAIT_LOOP2:
		CALL	READ_PORT
		MOV	[PORTDATA],EAX
		AND	EAX,[MASK_PATTERN]
		CMP	EAX,[CMP_PATTERN]
		JE	DATA_WAIT_END
		LOOP	DATA_WAIT_LOOP2

		PUSH	DX
		MOV	AH,2CH
		INT	21H
		MOV	AH,DH
		POP	DX
		SUB	AH,[TIME_BAK]
		JNC	DATA_WAIT_LOOP4
		ADD	AH,60
DATA_WAIT_LOOP4:
		CMP	AH,[TIME_CNT]
		JB	DATA_WAIT_LOOP1
DATA_WAIT_END:
		CALL	PRINT_PORT
		JMP	DATAIN_NEXT

;***********************************************
;DATA OUT NO INDEX PORT WITH BIT SET/RESET/XOR
;***********************************************
DATAOUT_BIT:

		CALL	READ_PORT
		MOV	[PORTDATA],EAX
		CALL	GET_MODIFIED_BIT
		JC	DATAIN_ERR

DATAOUT_PORT_GO:

		CALL	WRITE_PORT
		CALL	PRINT_PORT

;GET NEXT PORT ADDRESS
;-----------------------------
DATAIN_NEXT:
		CALL	SKIP_SPACE
		JZ	DATAIN_OK
		MOV	AL,[SI]

		CMP	AL,'0'
		JB	DATAIN_NEXT_1
		CMP	AL,'9'
		JBE	DATAIN

DATAIN_NEXT_1:
		CMP	AL,'A'
		JB	DATAIN_NEXT_2
		CMP	AL,'F'
		JBE	DATAIN

DATAIN_NEXT_2:
		CMP	AL,'a'
		JB	DATAIN_NEXT_3
		CMP	AL,'f'
		JBE	DATAIN

DATAIN_NEXT_3:
		INC	SI
		JMP	DATAIN_NEXT

DATAIN_OK:

		CLC
		RET

DATAIN_ERR:
		STC
		RET

DATAIN          ENDP
;
;
CPUT_STDERR PROC NEAR
		PUSH	AX
		PUSH	BX
		PUSH	CX
		PUSH	DX
		MOV	[CBUF],AL
		MOV	AH,40H
		MOV	BX,2
		MOV	CX,1
		MOV	DX,OFFSET CBUF
		INT	21H
		POP	DX
		POP	CX
		POP	BX
		POP	AX
		RET
CPUT_STDERR ENDP
;

MSGPRT_STDERR PROC NEAR
		PUSH	AX
		PUSH	BX
		PUSH	CX
		PUSH	DX
		MOV	CX,0FFFFH
		MOV	BX,DX
		DEC	BX
MSGPRT_STDERR_1:
		INC	CX
		INC	BX
		CMP	BYTE PTR [BX],'$'
		JNZ	MSGPRT_STDERR_1
		MOV	AH,40H
		MOV	BX,2
		INT	21H
		POP	DX
		POP	CX
		POP	BX
		POP	AX
		RET

MSGPRT_STDERR ENDP

;************************************************
;
;	PORT READ
;
;		INPUT	DX...PORT ADDRESS
;		OUTPUT	AX...READ DATA
;		BREAK	NONE
;************************************************
READ_PORT	PROC	NEAR

		XOR	EAX,EAX
		MOV	DX,[PORT_ADRS]

		TEST	CS:[FLAG],00000010B
		JZ	READ_PORT_NO_INDEX	;ｲﾝﾃﾞｯｸｽ無しI/O

;ポート読み込みインデックス付き
;------------------------------
	;Byte 読み込み (AL)
	;-----------------------
		MOV	AL,[INDEX]

		CLI
		CALL	READ_INDEX_PORT_SUB

		TEST	CS:[FLAG],00000001B
		JZ	READ_PORT_INDEX_END	;BYTEである

	;Word 読み込み(AX)
	;----------------------
READ_PORT_INDEX_WORD:

		MOV	AH,AL
		MOV	AL,[INDEX]
		INC	AL
		CALL	READ_INDEX_PORT_SUB
		XCHG	AH,AL

	;Double Word 読み込み(EAX)
	;----------------------
		TEST	[FLAG],00000100B
		JZ	READ_PORT_INDEX_END	;WORDである

		ROL	EAX,16
		MOV	AL,[INDEX]
		INC	AL
		INC	AL
		MOV	AH,AL
		INC	AH
		CALL	READ_INDEX_PORT_SUB

		XCHG	AH,AL
		CALL	READ_INDEX_PORT_SUB

		XCHG	AH,AL
		ROR	EAX,16

READ_PORT_INDEX_END:

		STI
		RET

;ポート読み込みインデックス無し
;------------------------------
READ_PORT_NO_INDEX:

		TEST	[FLAG],00000100B
		JZ	READ_PORT_NO_INDEX_WORD

		IN	EAX,DX
		RET

READ_PORT_NO_INDEX_WORD:

		TEST	[FLAG],00000001B
		JZ	READ_PORT_NO_INDEX_BYTE

		IN	AX,DX
		RET

READ_PORT_NO_INDEX_BYTE:

		IN	AL,DX
		RET



;*******************
;
;	入力	DX	Port Address
;		AL	Index
;	出力	AL
;	破壊	なし
;*******************
READ_INDEX_PORT_SUB:

		OUT	DX,AL
		INC	DX
		JMP	$+2
		IN	AL,DX
		DEC	DX
		RET

READ_PORT	ENDP
;************************************************
;
;	PORT WRITE
;
;		INPUT	DX...PORT ADDRESS
;		OUTPUT	NONE
;		BREAK	AX
;************************************************
WRITE_PORT	PROC	NEAR

		MOV	DX,[PORT_ADRS]

		TEST	[FLAG],00000010B
		JZ	WRITE_PORT_NO_INDEX

;ポート書き込みインデックス付き
;------------------------------

		CLI

	;Byte 書き込み
	;-----------------------
		MOV	AL,[INDEX]
		MOV	AH,BYTE PTR [PORTDATA]
		CALL	WRITE_INDEX_PORT_SUB

	;WORD 書き込み
	;-----------------------
		TEST	[PORTDATA],0FFFFFF00H
		JNZ	WRITE_PORT_INDEX_WORD

		TEST	[FLAG],00000001B
		JZ	WRITE_PORT_INDEX_END

WRITE_PORT_INDEX_WORD:

		MOV	AL,[INDEX]
		INC	AL
		MOV	AH,BYTE PTR [PORTDATA+1]
		CALL	WRITE_INDEX_PORT_SUB

	;DWORD 書き込み
	;-----------------------
		TEST	[PORTDATA],0FFFF0000H
		JNZ	WRITE_PORT_INDEX_DWORD

		TEST	[FLAG],00000100B
		JZ	WRITE_PORT_INDEX_END

WRITE_PORT_INDEX_DWORD:

		MOV	AL,[INDEX]
		INC	AL
		INC	AL
		MOV	AH,BYTE PTR [PORTDATA+2]
		CALL	WRITE_INDEX_PORT_SUB
		MOV	AL,CS:[INDEX]
		ADD	AL,3
		MOV	AH,BYTE PTR [PORTDATA+3]
		CALL	WRITE_INDEX_PORT_SUB

WRITE_PORT_INDEX_END:

		STI
		RET

;ポート書き込みインデックス無し
;------------------------------
WRITE_PORT_NO_INDEX:

		MOV	EAX,[PORTDATA]

		TEST	EAX,0FFFF0000H
		JNZ	WRITE_PORT_DWORD

		TEST	[FLAG],00000100B
		JZ	WRITE_PORT_NO_DWORD
	;DWORD
	;------------------
WRITE_PORT_DWORD:
		OUT	DX,EAX
		RET

WRITE_PORT_NO_DWORD:
		OR	AH,AH
		JNZ	WRITE_PORT_WORD

		TEST	[FLAG],00000001B
		JZ	WRITE_PORT_BYTE
	;WORD
	;------------------
WRITE_PORT_WORD:
		OUT	DX,AX
		RET

	;BYTE
	;------------------
WRITE_PORT_BYTE:
		OUT	DX,AL
		RET

;*******************
;
;	入力	DX	Port Address
;		AL	Index
;		AH	Data
;	出力	なし
;	破壊	AL
;*******************
WRITE_INDEX_PORT_SUB:

		OUT	DX,AL
		INC	DX
		JMP	$+2
		MOV	AL,AH
		OUT	DX,AL
		CMP	DX,2FH
		JNE	WRITE_PORT_NO2F
		OUT	DX,AL
WRITE_PORT_NO2F:
		DEC	DX
		RET

WRITE_PORT	ENDP

;************************************************
;
;	PRINT PORT
;
;		INPUT	[PORT_ADRS]
;			[PORTDATA]
;			[INDEX]
;		OUTPUT	無し
;		BREAK	NONE
;************************************************
PRINT_PORT	PROC	NEAR

        PUSH	AX
        PUSH	DX
        CALL    PRINT_PORT_ADRS
        MOV	AH,2
        MOV	DL,'='
        INT	21H
        CALL    PRINT_PORT_DATA
        CALL	CRLF
        POP	DX
        POP	AX
        RET

PRINT_PORT	ENDP
;************************************************
;
;	PRINT PORT
;
;		INPUT	[PORT_ADRS]
;			[PORTDATA]
;			[INDEX]
;		OUTPUT	無し
;		BREAK	NONE
;************************************************
PRINT_PORT_ADRS	PROC	NEAR

	PUSH	AX
	PUSH	DX
	MOV	AX,[PORT_ADRS]
	CALL	HEXPRT16

	TEST	[FLAG],00000010B
	JZ	PRINT_PORT_1

	MOV	AH,2
	MOV	DL,'.'
	INT	21H
	MOV	AL,[INDEX]
	CALL	HEXPRT8

PRINT_PORT_1:
	POP	DX
	POP	AX
	RET

PRINT_PORT_ADRS	ENDP
;************************************************
;
;	PRINT PORT
;
;		INPUT	[PORT_ADRS]
;			[PORTDATA]
;			[INDEX]
;		OUTPUT	無し
;		BREAK	NONE
;************************************************
PRINT_PORT_DATA	PROC	NEAR

	PUSH	AX
	PUSH	DX
	MOV	EAX,[PORTDATA]

	TEST	EAX,0FFFF0000H
	JNZ	PRINT_PORT_DWORD

	TEST	[FLAG],00000100B
	JZ	PRINT_PORT_NO_DWORD

PRINT_PORT_DWORD:
	ROL	EAX,8
	CALL	HEXPRT8
	ROL	EAX,8
	CALL	HEXPRT8

	MOV	AH,2
	MOV	DL,'_'
	INT	21H

	ROL	EAX,16
	JMP	PRINT_PORT_WORD

PRINT_PORT_NO_DWORD:

	OR	AH,AH
	JNZ	PRINT_PORT_WORD
	TEST	[FLAG],00000001B
	JZ	PRINT_PORT_BYTE

PRINT_PORT_WORD:

	XCHG	AH,AL
	CALL	HEXPRT8
	XCHG	AH,AL

PRINT_PORT_BYTE:
	CALL	HEXPRT8
	POP	DX
	POP	AX
	RET

PRINT_PORT_DATA ENDP

;************************************************
;*						*
;*	GET MODIFIED BIT			*
;*						*
;*		INPUT	DS:SI...STRING ADDRESS	*
;*			[PORTDATA]		*
;*		OUTPUT	DS:SI...STRING ADDRESS	*
;*			[PORTDATA]		*
;*			   CY...1:NG 0:OK	*
;*		BREAK	NONE			*
;************************************************
GET_MODIFIED_BIT	PROC	NEAR

GET_MODIFIED_BIT_LOOP:

		CALL	SKIP_SPACE
		JZ	GET_MODIFIED_BIT_END

		MOV	AL,BYTE PTR [SI]
		AND	AL,0DFH
		CMP	AL,'X'
		JE	GET_MODIFIED_BIT_XOR	;XORパターン
		CMP	AL,'S'
		JE	GET_MODIFIED_BIT_SET	;SETパターン
		CMP	AL,'R'
		JE	GET_MODIFIED_BIT_RESET	;RESETパターン

GET_MODIFIED_BIT_END:

		CLC
		RET

GET_MODIFIED_BIT_NG:

		STC
		RET

GET_MODIFIED_BIT_RESET:

		INC	SI
		CALL	SKIP_SPACE
		JZ	GET_MODIFIED_BIT_NG
		CALL	HEXGET
		JC	GET_MODIFIED_BIT_NG
		NOT	EAX
		AND	[PORTDATA],EAX
		JMP	GET_MODIFIED_BIT_LOOP

GET_MODIFIED_BIT_XOR:

		INC	SI
		CALL	SKIP_SPACE
		JZ	GET_MODIFIED_BIT_NG
		CALL	HEXGET
		JC	GET_MODIFIED_BIT_NG
		XOR	[PORTDATA],EAX
		JMP	GET_MODIFIED_BIT_LOOP

GET_MODIFIED_BIT_SET:

		INC	SI
		CALL	SKIP_SPACE
		JZ	GET_MODIFIED_BIT_NG
		CALL	HEXGET
		JC	GET_MODIFIED_BIT_NG
		OR	[PORTDATA],EAX
		JMP	GET_MODIFIED_BIT_LOOP

GET_MODIFIED_BIT	ENDP

;************************************************
;
;	HEX GET
;
;		INPUT	DS:SI	STRING ADDRESS
;			EAX	DEFAULT NUMBER
;		OUTPUT	DS:SI	STRING ADDRESS
;			EAX	NUMBER
;			   CY	1:NG 0:OK
;		BREAK	NONE
;************************************************

HEXGET	PROC	NEAR

	PUSH	CX
	PUSH	DX

	XOR	CX,CX

HEXGET_1:

	MOV	AL,[SI]
	CMP	AL,'0'
	JB	HEXGET_2
	CMP	AL,'9'
	JBE	HEXGET_1_1

	AND	AL,0DFH
	CMP	AL,'A'
	JB	HEXGET_2
	CMP	AL,'F'
	JA	HEXGET_2

HEXGET_1_1:

	INC	SI
	INC	CX
	JMP	SHORT HEXGET_1

HEXGET_2:

	SUB	SI,CX

	OR	CX,CX
	JZ	HEXGET_ERR

	XOR	EAX,EAX

HEXGET_3:

	ROL	EAX,4
	TEST	AL,0FH
	JNZ	HEXGET_ERR
	MOV	DL,[SI]
	CMP	DL,'A'
	JB	HEXGET_4
	SUB	DL,'A'-10

HEXGET_4:
	AND	DL,0FH
	OR	AL,DL
	INC	SI
	LOOP	HEXGET_3

HEXGET_NOE:

	CLC

HEXGET_RTS:

	POP	DX
	POP	CX
	RET

HEXGET_ERR:

	STC
	JMP	SHORT HEXGET_RTS

HEXGET	ENDP

;************************************************
;
;	HEX PRINT 16
;
;		INPUT	AX
;		OUTPUT	NONE
;		BREAK	NONE
;************************************************
HEXPRT16	PROC	NEAR

	PUSH	AX
	PUSH	BX
	PUSH	DX

	MOV	BX,OFFSET HEX16_MSG+4
	CALL	HEX_PRINT_SUB
	ROR	AX,4
	CALL	HEX_PRINT_SUB
	ROR	AX,4
	CALL	HEX_PRINT_SUB
	ROR	AX,4
	CALL	HEX_PRINT_SUB

	MOV	DX,BX
	MOV	AH,9
	INT	21H

	POP	DX
	POP	BX
	POP	AX
	RET

HEXPRT16	ENDP

;********************************************************
;	HEX PRINT AL
;
;	INPUT	AL
;	OUTPUT 	NONE
;	BREAK	NONE
;
;********************************************************
HEXPRT8 PROC	NEAR

	PUSH	AX
	PUSH	BX
	PUSH	DX

	MOV	BX,OFFSET HEX8_MSG+2
	CALL	HEX_PRINT_SUB
	ROR	AL,4
	CALL	HEX_PRINT_SUB

	MOV	DX,BX
	MOV	AH,9
	INT	21H

	POP	DX
	POP	BX
	POP	AX
	RET

HEXPRT8 ENDP
;********************************************************
;
;	HEX PRINT SUBROUTINE
;
;	INPUT	AL,BX
;	OUTPUT 	BX=BX+1
;	BREAK	NONE
;
;********************************************************
HEX_PRINT_SUB	PROC	NEAR

	MOV	DL,AL
	AND	DL,0FH
	ADD	DL,'0'
	CMP	DL,'9'
	JBE	HEX_PRINT_SUB_1
	ADD	DL,'A'-'0'-10

HEX_PRINT_SUB_1:
	DEC	BX
	MOV	[BX],DL
	RET

HEX_PRINT_SUB	ENDP

;************************************************
;*						*
;*	SKIP SPACE AND TAB			*
;*						*
;*		INPUT	DS:SI...STRING ADDRESS	*
;*		OUTPUT	DS:SI...STRING ADDRESS	*
;*			ZF=1...END(FOUND 0DH)	*
;*			ZF=0...CONTINUE		*
;*		BREAK	NONE			*
;************************************************
SKIP_SPACE	PROC	NEAR

		CMP	BYTE PTR [SI],0DH
		JE	SKIP_SPACE_RTS

		CMP	BYTE PTR [SI],' '
		JE	SKIP_SPACE_1
		CMP	BYTE PTR [SI],9
		JE	SKIP_SPACE_1

SKIP_SPACE_RTS:

		RET

SKIP_SPACE_1:

		INC	SI
		JMP	SKIP_SPACE

SKIP_SPACE	ENDP

CRLF    PROC NEAR

        PUSH    AX
        PUSH    DX
        MOV     AH,2
        MOV     DL,13
        INT     21H
        MOV     AH,2
        MOV     DL,10
        INT     21H
        POP     DX
        POP     AX
        RET

CRLF    ENDP

;
;
;
ttlmsg	db 'I/O INDEX ACCESS version 1.32 1999/06/25 by SUGAWARA',13,10,'$'
INPMSG	DB	'Format		[ADDRESS][.INDEX][-END] [DATA][W|L]',13,10,13,10
	DB	'[ADDRESS]	I/O Port Address(Hex Value)',13,10
	DB	'[.INDEX]	Index Address(Hex Value)',13,10
	DB      '[-END]		Dump End Adress or Index(Hex Value)',13,10
	DB	'[DATA]		Write Data(Hex Value)',13,10
	DB	' DATA WRITE		xx',13,10
	DB	' BIT SET		Sxx',13,10
	DB	' BIT RESET		Rxx',13,10
	DB	' BIT XOR		Xxx',13,10
	DB	' WAIT PORT		Hx1 x2 [x3]  while((Reg & x1)!=x2);',13,10
	DB	'			x3....Time out (1<x3<59)(1sec/unit (error -1sec))',13,10
	DB	13,10
	DB	' Multi Statement',13,10
	DB	'  example.',13,10
	DB	'	378 ! E4.5A : EE.A0 1',13,10
	DB	'$'

ERRMSG	DB 7,'Error',13,10,'$'
HEX_TBL DB '0123456789ABCDEF'

HEX16_MSG      DB    ?
DEC_MSG        DB    ?
HEX8_MSG       DB    2 DUP(?)
               DB    '$'

PORT_ADRS	DW	?
END_AREA        DW      ?
PORTDATA	DD	?
MASK_PATTERN	DD	?
CMP_PATTERN	DD	?
FLAG		DB	?		;BIT 0....0)BYTE DATA 1)WORD DATA
					;BIT 1....0)NO INDEX 1)WITH INDEX
					;Bit 2....1)DWORD DATA
					;Bit 3....1)Write Port
					;Bit 4....1)範囲指定有り
INDEX		DB	?
                DB      0
CBUF		DB	?
TIME_BAK	DB	?
TIME_CNT	DB	?

CODE	ENDS
	END	MAIN
