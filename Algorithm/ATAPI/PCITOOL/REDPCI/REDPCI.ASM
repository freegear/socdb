;Assembler
;           TASM.EXE   Ver.4.1
;        or TASMX.EXE  Ver.4.1
;        or TASM32.EXE Ver.5.0
;
;Assemble Option
;
;  /jSMART /jJUMPS /uM520 /jLOCALS /m8 /t
;
.586P
CODE SEGMENT BYTE PUBLIC 'CODE' USE16
     ASSUME  CS:CODE,DS:CODE,ES:CODE,SS:CODE

PNP_HEAD                STRUC
                        DD      ?
PNP_REV                 DB      ?     ;PnP BIOSのレビジョン
PNP_SIZE                DB      ?     ;このストラクチャのｻｲｽﾞ
PNP_EVENT_CNT           DW      ?     ;イベント通知機能の情報(00H=イベント通知機能をサポートしない)
                                      ;                       01H=Pollingでｲﾍﾞﾝﾄ通知を行う
PNP_CHKSUM              DB      ?     ;チェックサム
PNP_EVENT_FLG_ADRS      DD      ?     ;イベント通知フラグアドレス
PNP_REAL_ENTRY_OFFSET   DW      ?     ;リアルモード用RUNTIME先頭ｵﾌｾｯﾄ
PNP_REAL_ENTRY_SEGMENT  DW      ?     ;リアルモード用RUNTIME先頭ｾｸﾞﾒﾝﾄ
PNP_PROTECT_ENTRY_OFFSET DW     ?     ;プロテクトモード用RUNTIME先頭ｵﾌｾｯﾄ
PNP_PROTECT_ENTRY_SEGMENT DD    ?     ;プロテクトモード用RUNTIME先頭ｱﾄﾞﾚｽ
PNP_DEV_ID              DD      ?     ;デバイスＩＤ
PNP_REAL_DATA_SEGMENT   DW      ?     ;リアルモード用DATA先頭ｾｸﾞﾒﾝﾄｱﾄﾞﾚｽ
PNP_PROTECT_DATA_SEGMENT DD     ?     ;プロテクトモード用DATAｾｸﾞﾒﾝﾄﾍﾞｰｽｱﾄﾞﾚｽ

PNP_HEAD                ENDS

;PnP用ﾃﾞﾊﾞｲｽID定義ﾏｸﾛ
;--------------------
$DEV_ID	MACRO	ID
	LOCAL	DEV_PRES,STRING_LENGTH,STRING
	ID1 SUBSTR <ID>,1,1
	ID2 SUBSTR <ID>,2,1
	ID3 SUBSTR <ID>,3,1
	ID4 SUBSTR <ID>,4,2
	ID5 SUBSTR <ID>,6,2
	DEV_STR1 CATSTR <'>,ID1,<'>
	DEV_STR2 CATSTR <'>,ID2,<'>
	DEV_STR3 CATSTR <'>,ID3,<'>
	DEV_HEX1 CATSTR <0>,ID4,<H>
	DEV_HEX2 CATSTR <0>,ID5,<H>
	DEV_PRES EQU (DEV_STR1-40H) SHL 10 OR\
		     (DEV_STR2-40H) SHL  5 OR\
		     (DEV_STR3-40H)
	ID EQU (DEV_HEX2 SHL 24) OR \
	       (DEV_HEX1 SHL 16) OR \
	       (LOW  DEV_PRES SHL 8) OR \
	       (HIGH DEV_PRES)
	ENDM

	$DEV_ID	PNP0A03

        ORG 81H
CMDLIN  LABEL BYTE

        ORG 100H
MAIN PROC NEAR

;ｺﾏﾝﾄﾞﾗｲﾝ取得
;--------------------------
        CALL    GET_CMDLIN
        JC      @@USAGE

;PCI BIOSｻﾎﾟｰﾄﾁｪｯｸ
;--------------------------
        CALL    CHK_PCI_SUPPORT
        JC      @@NOT_EXIST

;PCIﾃﾞﾊﾞｲｽ表示
;------------------------------
    ;ﾒﾓﾘ開放
    ;-----------------------------
        MOV     SP,OFFSET STACK_BOTTOM
        MOV     BX,OFFSET STACK_BOTTOM+15
        SHR     BX,4
        MOV     AH,4AH
        INT     21H
        JC      @@MEMORY_ERROR

    ;ﾚｼﾞｽﾀ相手かな？
    ;-----------------------
        PUSH    OFFSET @@EXIT
        CMP     [ARG_NUM],4
        JA      SET_REG_DAT
        JE      DISP_REG_DAT

    ;Vendor ID,Class Code一覧取得
    ;-----------------------------
        CALL    GET_INI

        CMP     [ARG_NUM],2
        JA      DISP_REG_DUMP
        JE      DISP_FNC_LIST

        CMP     [ARG_NUM],0
        JA      DISP_DEV_LIST
        JMP     DISP_ALL_LIST
@@EXIT:
        MOV     AX,4C00H
        INT     21H

@@USAGE:
        MOV     DX,OFFSET USAGE_MSG
        MOV     CX,SIZE_USAGE_MSG
        CALL    DISP_MSG_CX
        JMP     @@ERROR_END

@@MEMORY_ERROR:
        MOV     DX,OFFSET MEM_BRK_MSG
        CMP     AX,7
        JE      @@DISP_ERROR_END
        MOV     DX,OFFSET MEM_NOT_ENOUGH_MSG
        JMP     @@DISP_ERROR_END

@@NOT_EXIST:
        MOV     DX,OFFSET NOT_EXIST_PCI_BIOS_MSG
        .IF AX == -2
            MOV     DX,OFFSET HIDDEN_PCI_BIOS_MSG
        .ENDIF
@@DISP_ERROR_END:
        CALL    DISP_MSG
@@ERROR_END:
        MOV     AX,4CFFH
        INT     21H

MAIN ENDP

;********************************************************
;	ｺﾏﾝﾄﾞﾗｲﾝ ﾊﾟﾗﾒｰﾀ取得
;
;	INPUT	なし
;	OUTPUT  CY     0)正常   1)正しいﾊﾟﾗﾒｰﾀではない
;	BREAK	AX,BX,CX,EDX
;
;********************************************************
GET_CMDLIN PROC NEAR

        MOV     SI,OFFSET CMDLIN
@@ARG_LOOP:
        CALL    GET_ARG
        JCXZ    @@GET_ARG_END

        CMP     BYTE PTR [SI],'/'
        JE      @@GET_OPTION

        INC     [ARG_NUM]

        CMP     [ARG_NUM],5
        JA      @@USAGE
        JE      @@GET_DAT

        CMP     [ARG_NUM],3
        JA      @@GET_REG
        JE      @@GET_FNC

        CMP     [ARG_NUM],1
        JA      @@GET_DEV

@@GET_BUS:
        CALL    GET_VALUE
        JC      @@USAGE
        TEST    EAX,0FFFFFF00H
        JNZ     @@USAGE
        MOV     [BUS_NUM],AL
        JMP     @@ARG_LOOP

@@GET_DEV:
        CALL    GET_VALUE
        JC      @@USAGE
        TEST    EAX,0FFFFFFE0H
        JNZ     @@USAGE
        MOV     [DEV_NUM],AL
        JMP     @@ARG_LOOP

@@GET_FNC:
        CALL    GET_VALUE
        JC      @@USAGE
        TEST    EAX,0FFFFFFF8H
        JNZ     @@USAGE
        MOV     [FNC_NUM],AL
        JMP     @@ARG_LOOP

@@GET_REG:
        CALL    GET_HEX_VALUE
        JC      @@USAGE
        TEST    EAX,0FFFFFF00H
        JNZ     @@USAGE
        MOV     [REG_NUM],AL
        JMP     @@ARG_LOOP

@@GET_DAT:
        CALL    GET_HEX_VALUE
        JC      @@USAGE
        MOV     [DAT_VAL],EAX
        MOV     [DAT_SIZE],CL
        JMP     @@ARG_LOOP

@@GET_OPTION:
        INC     SI
        DEC     CX
        JZ      @@USAGE
        MOV     AL,[SI]
        AND     AL,0DFH
        CMP     AL,'F'
        JNE     @@GET_OPTION_D
        OR      [FLAG],@FORM_REG
        JMP     @@SkipRemainingChars
@@GET_OPTION_D:
        CMP     AL,'D'
        JNE     @@GET_OPTION_A
        OR      [FLAG],@DUMP_REG

        INC     SI
        DEC     CX
        JZ      @@SkipRemainingChars

        MOV     AL,[SI]
        CMP     AL,'1'
        JNE     @@getOptionDW
        OR      [FLAG],@dumpByte
        JMP     @@SkipRemainingChars
@@getOptionDW:
        CMP     AL,'2'
        JNE     @@getOptionDD
        OR      [FLAG],@dumpWord
        JMP     @@SkipRemainingChars
@@getOptionDD:
        CMP     AL,'4'
        JNE     @@USAGE
        AND     [FLAG],NOT(@dumpByte OR @dumpWord)
        JMP     @@SkipRemainingChars

@@GET_OPTION_A:
	CMP	AL, 'A'
	JNE	@@getOptionM
	OR	[FLAG],@ADV_REG or @FORM_REG
        JMP     @@SkipRemainingChars

@@getOptionM:
	CMP	AL, 'M'
	JNE	@@USAGE
	OR	[FLAG],@searchAll

@@SkipRemainingChars:
        ADD     SI,CX
	JMP	@@ARG_LOOP

@@GET_ARG_END:

        CLC
        RET

@@USAGE:
        STC
        RET

GET_CMDLIN ENDP
;********************************************************
;	PCI BIOSｻﾎﾟｰﾄ判定
;
;	INPUT	なし
;	OUTPUT 	CY 0)有り
;                  1)無し
;                    AX = -1  PCI BIOS not support
;                       = -2  PCI BIOS hidden by OS
;	BREAK	BX,CX,EDX
;
;********************************************************
CHK_PCI_SUPPORT PROC NEAR

        MOV     AX,0B101H
        INT     1AH
        .IF (!CARRY?) || !(AH & AH)
            .IF EDX == ' ICP'
                ;ｻﾎﾟｰﾄしている場合
                ;----------------------
                MOV     [LAST_BUS_NUM],CL
                .IF [ARG_NUM] == 0
                    ;H/W情報表示
                    ;-----------------------------
                    MOV     DX,OFFSET CYC2_MSG
                    CALL    DISP_MSG
                    TEST    AL,1 SHL 5
                    CALL    DISP_SUPPORT_IF_NZ
                    MOV     DX,OFFSET CYC1_MSG
                    CALL    DISP_MSG
                    TEST    AL,1 SHL 4
                    CALL    DISP_SUPPORT_IF_NZ

                    MOV     DX,OFFSET CNF2_MSG
                    CALL    DISP_MSG
                    TEST    AL,1 SHL 1
                    CALL    DISP_SUPPORT_IF_NZ

                    MOV     DX,OFFSET CNF1_MSG
                    CALL    DISP_MSG
                    TEST    AL,1 SHL 0
                    CALL    DISP_SUPPORT_IF_NZ

                    ;PCI BIOS Version表示
                    ;-----------------------------
                    MOV     DI,OFFSET PCI_BIOS_VER_STR
                    MOV     AL,BH
                    CALL    IntToHex8
                    ADD     DI,3
                    MOV     AL,BL
                    CALL    IntToHex8
                    MOV     DX,OFFSET PCI_BIOS_IF_LVL_MSG
                    CALL    DISP_MSG

                    ;最終ﾊﾞｽ番号表示
                    ;----------------------------
                    MOV     DI,OFFSET LAST_BUS_NUM_STR
                    MOV     AL,CL
                    CALL    IntToStr83
                    MOV     DX,OFFSET LAST_BUS_NUM_MSG
                    CALL    DISP_MSG
                .ENDIF
                CLC
                RET
            .ENDIF
        .ENDIF
;PnP BIOSより、PCI Busが存在確認出来たら、PCI BIOSがOSにより隠されていると判断
;----------------------------
	;PnPｲﾝｽﾄｰﾙｽﾄﾗｸﾁｬｰ検索
	;-----------------------
	PUSH    DS
        MOV     AX,0F000H
        MOV     DS,AX
    ASSUME  DS:NOTHING
        XOR     SI,SI
        ;'$PnP'を検索
        ;------------------------
        .REPEAT
            .IF (WORD PTR DS:[SI]=='P$') && \
                (WORD PTR DS:[SI+2]=='Pn')
                ;'$PnP'が見つかったので、ｽﾄﾗｸﾁｬのﾁｪｯｸｻﾑ計算
                ;------------------------
                XOR     CH,CH
                MOV     CL,DS:[SI].PNP_SIZE
                XOR     AL,AL
                MOV     DI,SI
                .REPEAT
                    ADD     AL,DS:[DI]
                    INC     DI
                .UNTILCXZ
                .IF !(AL & AL)
                    ;ﾁｪｯｸｻﾑが合ったのでﾍｯﾀﾞｻｲｽﾞ確認
                    ;-------------------------
                    CMP     DS:[SI].PNP_SIZE,SIZE PNP_HEAD
                    JB      NOT_SUPPORT                     ;ﾍｯﾀﾞｻｲｽﾞが小さいのでｻﾎﾟｰﾄ出来まへん
                    ;ﾍｯﾀﾞ情報をｺﾋﾟｰ
                    ;-------------------------
                    MOV     DI,OFFSET PNP_HEAD_COPY
                    MOV     CX,SIZE PNP_HEAD
                    CLD
                    REP     MOVSB
                    JMP     FOUND_PNP_HEAD
                .ENDIF
            .ENDIF
            ADD     SI,16
        .UNTIL ZERO?
NOT_SUPPORT:
        POP     DS
        JMP     NOT_FOUND_PNP

FOUND_PNP_HEAD:

        POP     DS
    ASSUME  DS:CODE
	;PCI BusのNodeを検索
	;---------------------------------
        MOV     [NODE_NUM], 0
        .REPEAT
            PUSH    [PNP_HEAD_COPY].PNP_REAL_DATA_SEGMENT
            PUSH    0002H
            PUSH    DS
            PUSH    OFFSET NODE_BUFFER
            PUSH    DS
            PUSH    OFFSET NODE_NUM
            PUSH    0001H
            CALL    DWORD PTR [PNP_HEAD_COPY].PNP_REAL_ENTRY_OFFSET
            ADD     SP, 14
            .BREAK .IF AX >= 80h
            .IF DWORD PTR [NODE_BUFFER+3] == PNP0A03
                MOV     AX, -2
                STC
                RET
            .ENDIF
        .UNTIL [NODE_NUM] == 255

NOT_FOUND_PNP:
        MOV     AX, -1
        STC
        RET

CHK_PCI_SUPPORT ENDP

;********************************************************
;       INIﾌｧｲﾙ取得
;
;       INPUT   なし
;       OUTPUT  なし
;	BREAK
;********************************************************
GET_INI PROC NEAR

;ﾌｧｲﾙ読込ﾊﾞｯﾌｧ取得
;------------------------
        MOV    AH,48H
        MOV    BX,4000H/16
        INT    21H
        JC     @@END                 ;ﾒﾓﾘが足りない
        MOV    [REDBUF_SEG],AX

;Vendor名,Chip名,Class Codeﾌｧｲﾙのﾊﾟｽ取得
;------------------------
        MOV    SI,OFFSET INI_NAME
        CALL   GET_MY_PATH
GET_INI_PATH_LOOP:
        DEC    SI
        MOV    AL,[SI]
        CMP    AL,':'
        JE     GET_INI_PATH_END
        CMP    AL,'\'
        JE     GET_INI_PATH_END
        CMP    SI,OFFSET INI_NAME
        JA     GET_INI_PATH_LOOP
        DEC    SI
GET_INI_PATH_END:
        INC    SI
        MOV    [PATH_ADRS],SI

    ;Vendor名情報取得
    ;------------------------
        MOV    DX,OFFSET VEND_TXT
        CALL   READ_INI_FILE
        MOV    [VENDOR_SEG],ES
        MOV    [VENDOR_SIZE],DI

    ;Chip名情報取得
    ;------------------------
        MOV    DX,OFFSET CHIP_TXT
        CALL   READ_INI_FILE
        MOV    [CHIP_SEG],ES
        MOV    [CHIP_SIZE],DI

    ;Class情報取得
    ;------------------------
        MOV    DX,OFFSET CLASS_TXT
        CALL   READ_INI_FILE
        MOV    [CLASS_SEG],ES
        MOV    [CLASS_SIZE],DI
@@END:
        RET

GET_INI ENDP
;********************************************************
;	PCI ﾃﾞﾊﾞｲｽ一覧表示
;
;	INPUT	なし
;	OUTPUT 	CY     0)有り  1)無し
;	BREAK	AX,BX,CX,EDX
;
;********************************************************
DISP_ALL_LIST PROC NEAR

        MOV     DX,OFFSET LIST_ITEM_MSG
        CALL    DISP_MSG

        MOV     BX,0000H
@@LIST_LOOP:
        CALL    DISP_FNC_SUB
        AND     BL,NOT 111B
        ADD     BX,1 SHL 3
        JC      @@END
        TEST    [FLAG],@searchAll
        JNZ     @@LIST_LOOP
        CMP     BH,[LAST_BUS_NUM]
        JBE     @@LIST_LOOP
@@END:
        RET

DISP_ALL_LIST ENDP

;********************************************************
;	PCI 指定ﾊﾞｽ ﾃﾞﾊﾞｲｽ一覧表示
;
;	INPUT	なし
;	OUTPUT 	CY     0)有り  1)無し
;	BREAK	AX,BX,CX,EDX
;
;********************************************************
DISP_DEV_LIST PROC NEAR

        MOV     DX,OFFSET LIST_ITEM_MSG
        CALL    DISP_MSG

        XOR     BL,BL
        MOV     BH,[BUS_NUM]
@@LIST_LOOP:
        CALL    DISP_FNC_SUB
        AND     BL,NOT 111B
        ADD     BL,1 SHL 3
        JNC     @@LIST_LOOP
        RET

DISP_DEV_LIST ENDP

;********************************************************
;	PCI 指定ﾊﾞｽ ﾃﾞﾊﾞｲｽ一覧表示
;
;	INPUT	なし
;	OUTPUT 	CY     0)有り  1)無し
;	BREAK	AX,BX,CX,EDX
;
;********************************************************
DISP_FNC_LIST PROC NEAR

        MOV     DX,OFFSET LIST_ITEM_MSG
        CALL    DISP_MSG

        MOV     BL,[DEV_NUM]
        SHL     BL,3
        MOV     BH,[BUS_NUM]
        JMP     DISP_FNC_SUB

DISP_FNC_LIST ENDP

;********************************************************
;	PCI 指定ﾊﾞｽ 指定ﾃﾞﾊﾞｲｽ ﾌｧﾝｸｼｮﾝ一覧表示
;
;	INPUT	BX     Bus,Dev Number
;	OUTPUT 	CY     0)有り  1)無し
;	BREAK	AX,CX,EDX
;
;********************************************************
DISP_FNC_SUB PROC NEAR

        PUSH     BX
        .REPEAT
            CALL    DISP_DEV_INFO
            .IF CARRY?
                .BREAK .IF !(BL & 111B)
            .ELSE
                MOV     DI,0EH
                CALL    READ_PCI_BYTE
                AND     CL, NOT(1 SHL 7)
                .IF !ZERO?                      ;0ならﾌﾞﾘｯｼﾞﾃﾞﾊﾞｲｽではない
                    .IF CL <= 02h               ;1,2はﾌﾞﾘｯｼﾞﾃﾞﾊﾞｲｽである
                        MOV     DI, 1Ah
                        CALL    READ_PCI_BYTE
                        .IF [LAST_BUS_NUM] < CL
                            MOV    [LAST_BUS_NUM], CL
                        .ENDIF
                    .ENDIF
                .ENDIF
;                .IF [FLAG] & @searchAll
;                    INC    BL
;                    .CONTINUE
;                .ENDIF
            .ENDIF
            .IF !(BL & 111B)
                MOV     DI,0EH
                CALL    READ_PCI_BYTE
                .BREAK .IF !(CL & (1 SHL 7))
            .ENDIF
            INC     BL
        .UNTIL !(BL & 111B)
        POP      BX
        RET

DISP_FNC_SUB ENDP
;********************************************************
;	PCI 指定ﾃﾞﾊﾞｲｽ 情報表示
;
;	INPUT	BX     Bus,Dev,Func Number
;	OUTPUT 	CY     0)有り  1)無し
;	BREAK	AX,CX,EDX
;
;********************************************************
DISP_DEV_INFO PROC NEAR

        CALL    GET_DEV_ID
        .IF !CARRY?
            CALL    DISP_DEV_INFO_SUB
            .IF [FLAG] & (@DUMP_REG OR @FORM_REG)
                CALL    DUMP_REG_SUB
                CALL    CRLF
                CLC
            .ENDIF
        .ENDIF
        RET

DISP_DEV_INFO ENDP
;********************************************************
;       PCI 指定ﾃﾞﾊﾞｲｽ Device ID,Vendor ID取得
;
;       INPUT   BX     Bus,Dev,Func Number
;       OUTPUT  CY     0)有り  1)無し
;               [VENDOR_ID] Device ID,Vendor ID
;               ECX         Device ID,Vendor ID
;                           [VENDOR_ID]=-1の場合は、2nd ID
;       BREAK   AX,EDX
;********************************************************
GET_DEV_ID PROC NEAR

        MOV     DI,0
        CALL    READ_PCI_DWORD
        MOV     [VENDOR_ID],ECX
        .IF CX == -1
            ;ﾃﾞﾊﾞｲｽが無いような感じなので、本当にﾃﾞﾊﾞｲｽが無いかﾁｪｯｸ
            ;---------------------
            MOV     DI,4
            CALL    READ_PCI_DWORD
            CMP     ECX,-1
            JE      @@NOT_FOUND          ;本当にﾃﾞﾊﾞｲｽ無し

            ;ﾍｯﾀﾞﾀｲﾌﾟより、ｻﾌﾞﾍﾞﾝﾀﾞIDの場所を取得
            ;---------------------
            MOV     DI,0EH
            CALL    READ_PCI_BYTE
            MOV     DI,2CH
            AND     CL,NOT(1 SHL 7)
            .IF !ZERO?
                CMP     CL,2
                JNE     @@NO_2ND_ID     ;ｻﾌﾞﾍﾞﾝﾀﾞID無し
                MOV     DI,40H
            .ENDIF
            CALL    READ_PCI_DWORD
            .IF !(ECX & ECX)
@@NO_2ND_ID:
                XOR     ECX,ECX
            .ENDIF
@@FOUND_DEV:
        .ENDIF
        CLC
        RET

@@NOT_FOUND:
        STC
        RET

GET_DEV_ID ENDP
;********************************************************
;	PCI 指定ﾃﾞﾊﾞｲｽ 情報表示
;
;	INPUT	BX     Bus,Dev,Func Number
;               ECX    Device ID,Vendor ID
;	OUTPUT 	なし
;	BREAK	AX,CX,EDX
;
;********************************************************
DISP_DEV_INFO_SUB PROC NEAR

;Bus,Device,Function Number
;------------------------
        MOV     AL,BH
        MOV     DI,OFFSET @@StrBus
        CALL    IntToStr83

        MOV     AL,BL
        SHR     AL,3
        MOV     DI,OFFSET @@StrDev
        CALL    IntToStr83

        MOV     AL,BL
        AND     AL,111B
        MOV     DI,OFFSET @@StrFunc
        CALL    IntToStr83

;DeviceID,Vendor ID
;------------------------
        ;ｻﾌﾞﾍﾞﾝﾀﾞIDが無しの場合、仕方が無いので、ﾍﾞﾝﾀﾞIDを表示
        ;------------------------
        .IF ECX & ECX
            PUSH    ECX
        .ELSE
            PUSH    [VENDOR_ID]
        .ENDIF
        POP     AX
        MOV     DI,OFFSET @@StrVendor
        CALL    IntToHex16
        POP     AX
        MOV     DI,OFFSET @@StrDevice
        CALL    IntToHex16

;Revision
;-----------------------
        PUSH    ECX
        MOV     DI,8
        CALL    READ_PCI_DWORD
        MOV     [CLASS_CODE],ECX
        MOV     AL,CL
        MOV     DI,OFFSET @@StrRev
        CALL    IntToHex8
        POP     ECX
        MOV     DX,OFFSET MsgDevInfo
        CALL    DISP_MSG

;隠れPCIﾃﾞﾊﾞｲｽ表示
;---------------------------
        .IF [VENDOR_ID]==-1
            .IF (!(ECX & ECX)) ||\ ;Vendor IDは無いがﾃﾞﾊﾞｲｽがあるようだ(ただしSub Vendor IDは無し)
                (ECX!=-1)   ;Vendor IDは無いがﾃﾞﾊﾞｲｽがあるようだ(Sub Vendor ID有り)
                MOV     DX,OFFSET HIDDEN_DEVICE_MSG
                CALL    DISP_MSG
                CALL    SPACE
            .ENDIF
            TEST    ECX,ECX
            JZ      @@SKIP_DISP_VENDOR        ;2nd IDも読めないので、Vendor名表示は行わない
        .ENDIF
;Display Vendor Name
;------------------------
        CALL    DISP_CHIP
        .IF CARRY?
            CALL    DISP_VENDOR
            CALL    SPACE
@@SKIP_DISP_VENDOR:
            ;Display Device Type
            ;------------------------
            MOV     ECX,[CLASS_CODE]
            SHR     ECX,8
            CALL    DISP_CLASS
        .ENDIF
        CALL    CRLF

;PCItoPCI Bridge または、PCItoCBUS Bridgeの場合、下位のﾊﾞｽ番号を表示
;------------------------
        .IF !([FLAG] & @FORM_REG)
            ;ﾌｫｰﾏｯﾄ付きﾚｼﾞｽﾀﾀﾞﾝﾌﾟ表示の場合は、表示しない(ﾀﾞﾝﾌﾟ表示の方で表示するから)
            ;--------------
            MOV     DI,0EH
            CALL    READ_PCI_BYTE
            AND     CL,NOT(1 SHL 7)
            .IF !ZERO?                      ;0ならﾌﾞﾘｯｼﾞﾃﾞﾊﾞｲｽではない
                .IF CL <= 2                 ;1,2はﾌﾞﾘｯｼﾞﾃﾞﾊﾞｲｽである
                    MOV     DX,OFFSET BUS_2ND_MSG
                    CALL    DISP_MSG
                    MOV     DI,19H
                    CALL    READ_PCI_BYTE
                    MOV     AL,CL
                    MOV     CH,CL
                    CALL    DECPRT8

                    MOV     DI,1AH
                    CALL    READ_PCI_BYTE
                    .IF CH != CL
                        MOV     AL,'.'
                        CALL    DISP_CHAR
                        MOV     AL,'.'
                        CALL    DISP_CHAR
                        MOV     AL,CL
                        CALL    DECPRT8
                    .ENDIF
                    CALL    CRLF
                .ENDIF
            .ENDIF
        .ENDIF
        RET

MsgDevInfo LABEL BYTE
@@StrBus    DB '--  '
@@StrDev    DB '--  '
@@StrFunc   DB '--    '
@@StrVendor DB '----h  '
@@StrDevice DB '----h '
@@StrRev    DB '--h $'

DISP_DEV_INFO_SUB ENDP
;********************************************************
;	Chip名取得
;
;	INPUT	ECX     VendorID,Device ID
;       OUTPUT  DS:DX   ﾒｯｾｰｼﾞｱﾄﾞﾚｽ
;               CX      ﾒｯｾｰｼﾞｻｲｽﾞ
;               CY      0)見つけた  1)見つからない
;	BREAK	AX,DX
;
;********************************************************
GET_CHIP_MSG PROC NEAR

        MOV     ES,[CHIP_SEG]
        MOV     DX,[CHIP_SIZE]
        JMP     getMatchedString

GET_CHIP_MSG ENDP
;********************************************************
;	Chip名表示
;
;	INPUT	ECX     VendorID,Device ID
;	OUTPUT 	なし
;	BREAK	AX,DX
;
;********************************************************
DISP_CHIP PROC NEAR

        PUSH    DS
        CALL    GET_CHIP_MSG
        .IF !CARRY?
            PUSH    CX
            CALL    StrLen
            MOV     CX,AX
            CALL    DISP_MSG_CX
            POP     CX
            .IF CX > AX
                CALL    SPACE
                INC     AX
                ADD     DX,AX
                SUB     CX,AX
                CALL    StrLen
                MOV     CX,AX
                CALL    DISP_MSG_CX
            .ENDIF
            CLC
        .ENDIF
        POP     DS
        RET

DISP_CHIP ENDP
;********************************************************
;	Vendor名取得
;
;	INPUT	CX     VendorID
;       OUTPUT  DS:DX   ﾒｯｾｰｼﾞｱﾄﾞﾚｽ
;               CX      ﾒｯｾｰｼﾞｻｲｽﾞ
;               CY      0)見つけた  1)見つからない
;	BREAK	AX
;
;********************************************************
GET_VENDOR_MSG PROC NEAR

        MOV     ES,[VENDOR_SEG]
        MOV     DX,[VENDOR_SIZE]
        MOVZX	ECX, CX
        CALL    getMatchedString
        .IF CARRY?
            MOV     DX,OFFSET UNKNOWN_VENDOR_MSG
            MOV     CX,SIZE_UNKNOWN_VENDOR_MSG
        .ENDIF
        RET

GET_VENDOR_MSG ENDP
;********************************************************
;	Vendor名表示
;
;	INPUT	CX     VendorID
;	OUTPUT 	なし
;	BREAK	AX,DX
;
;********************************************************
DISP_VENDOR PROC NEAR

        PUSH    DS
        CALL    GET_VENDOR_MSG
        CALL    DISP_MSG_CX
        POP     DS
        RET

DISP_VENDOR ENDP

;********************************************************
;       ﾃﾞﾊﾞｲｽﾀｲﾌﾟﾒｯｾｰｼﾞ取得
;
;       INPUT   ECX     Class Code
;       OUTPUT  DS:DX   ﾒｯｾｰｼﾞｱﾄﾞﾚｽ
;               CX      ﾒｯｾｰｼﾞｻｲｽﾞ
;               CY      0)見つけた  1)見つからない
;       BREAK   EAX
;********************************************************
GET_CLASS_MSG PROC NEAR

        MOV     ES,[CLASS_SEG]
        MOV     DX,[CLASS_SIZE]
        CALL    getMatchedString
        .IF CARRY?
            ;Clase Code Listに存在しなかった
            ;-----------------------
            MOV     EAX,ECX
            ROL     EAX,16
            MOV     DI,OFFSET @@StrBase
            CALL    IntToHex8
            ROL     EAX,8
            MOV     DI,OFFSET @@StrSub
            CALL    IntToHex8
            ROL     EAX,8
            MOV     DI,OFFSET @@StrProg
            CALL    IntToHex8
            MOV     DX,OFFSET @@Msg
            MOV     CX,SIZE_CLASS_MSG
            STC
        .ENDIF
        RET

@@Msg      LABEL BYTE
@@StrBase  DB '-- '
@@StrSub   DB '-- '
@@StrProg  DB '-- ??Unknown Class Code??'
SIZE_CLASS_MSG = $-@@Msg

GET_CLASS_MSG ENDP

;********************************************************
;       指定IDと一致する文字列取得
;
;       INPUT   ECX     ID
;               ES      IDテーブル
;               DX      IDテーブルサイズ
;       OUTPUT  DS:DX   ﾒｯｾｰｼﾞｱﾄﾞﾚｽ
;               CX      ﾒｯｾｰｼﾞｻｲｽﾞ
;               CY      0)見つけた  1)見つからない
;       BREAK   None
;********************************************************
getMatchedString PROC NEAR

        PUSH    EAX
        PUSH    BX
        PUSH    SI
        PUSH    DI

        XOR     BX,BX
        .REPEAT
            .BREAK .IF BX >=DX
            MOV     AL, ES:[BX+2]
            .IF !(AL & AL)
                .IF ECX == ES:[BX+2+1]
                    LEA     DX,[BX+2+1+4]
                    PUSH    ES
                    POP     DS
                    MOV     CX, DS:[BX]
                    SUB     CX, 2+1+4
                    JMP     @@End
                .ENDIF
            .ELSEIF (AL == 1)
                MOV     EAX, ECX
                AND     EAX, ES:[BX+2+1+4]
                .IF EAX == ES:[BX+2+1]
                    PUSH    BX
                    MOV     DI, OFFSET STR_BUFFER
                    .WHILE (1)
                        ADD     BX, ES:[BX]
                        .BREAK .IF CARRY?
                        .BREAK .IF BX >=DX
                        .BREAK .IF BYTE PTR ES:[BX+2] != 2
                        MOV     EAX, ECX
                        AND     EAX, ES:[BX+2+1+4]
                        .IF EAX == ES:[BX+2+1]
                            PUSH    CX
                            MOV     CX, ES:[BX]
                            LEA     SI, ES:[BX+2+1+4+4]
                            SUB     CX, 2+1+4+4
                            .IF !(ZERO?)
                                 .REPEAT
                                     MOV     AL, ES:[SI]
                                     MOV     DS:[DI], AL
                                     INC     SI
                                     INC     DI
                                 .UNTILCXZ
                                 MOV     BYTE PTR DS:[DI], ' '
                                 INC     DI
                            .ENDIF
                            POP    CX
                        .ENDIF
                    .ENDW
                    POP     BX
                    .IF DI == OFFSET STR_BUFFER
                        LEA     DX,[BX+2+1+4+4]
                        PUSH    ES
                        POP     DS
                        MOV     CX, DS:[BX]
                        SUB     CX, 2+1+4+4
                    .ELSE
                        MOV     DX, OFFSET STR_BUFFER
                        MOV     CX, DI
                        SUB     CX, DX
                        DEC     CX
                    .ENDIF
                    CLC
                    JMP     @@End
                .ENDIF
            .ENDIF
            ADD     BX,ES:[BX]
        .UNTIL CARRY?
        STC
@@End:
        POP     DI
        POP     SI
        POP     BX
        POP     EAX
        RET

getMatchedString ENDP

;********************************************************
;	ﾃﾞﾊﾞｲｽﾀｲﾌﾟ表示
;
;	INPUT	ECX     Class Code
;	OUTPUT 	なし
;	BREAK	EAX,DX,ECX
;
;********************************************************
DISP_CLASS PROC NEAR

        PUSH    DS
        CALL    GET_CLASS_MSG
        CALL    DISP_MSG_CX
        POP     DS
        RET

DISP_CLASS ENDP

;********************************************************
;	ﾚｼﾞｽﾀﾀﾞﾝﾌﾟ
;
;	INPUT	なし
;	OUTPUT 	なし
;	BREAK	AX,DX
;
;********************************************************
DISP_REG_DUMP PROC NEAR

        MOV     BH,[BUS_NUM]
        MOV     BL,[DEV_NUM]
        SHL     BL,3
        OR      BL,[FNC_NUM]
        CALL    GET_DEV_ID
        .IF (!CARRY?) || ([FLAG] & (@FORM_REG OR @DUMP_REG)
            ;/F /D指定が無い場合、/F指定とする
            ;-----------------
            .IF !([FLAG] & (@FORM_REG OR @DUMP_REG))
                OR      [FLAG],@FORM_REG
            .ENDIF

            MOV     DX,OFFSET LIST_ITEM_MSG
            CALL    DISP_MSG
            CALL    DISP_DEV_INFO_SUB
            JMP     DUMP_REG_SUB
        .ELSE
            MOV     DX,OFFSET MsgNotExistPCIDevice
            CALL    DISP_MSG
        .ENDIF
        RET

DISP_REG_DUMP ENDP

;********************************************************
;	ﾚｼﾞｽﾀﾀﾞﾝﾌﾟ
;
;	INPUT	BX    Bus,Device,Function Number
;	OUTPUT 	なし
;	BREAK	AX,ECX,DX,DI
;
;********************************************************
DUMP_FORM_REG_SUB PROC NEAR

;共通領域表示
;--------------------------
        MOV     SI,OFFSET FIX_REG_TBL
        CALL    @@FORM_DUMP

;ﾍｯﾀﾞﾀｲﾌﾟ別領域表示
;---------------------------
        MOV    DI,0EH
        CALL   READ_PCI_BYTE
        AND    CL,NOT(1 SHL 7)

	PUSH	CX

        CMP    CL,2
        JA     @@DUMP_REG_10_3F
        CMP    CL,1
        MOV    SI,OFFSET TYPE00_TBL
        JB     @@SpecDump
        MOV    SI,OFFSET TYPE01_TBL
        JE     @@SpecDump
        MOV    SI,OFFSET TYPE02_TBL
@@SpecDump:
	CALL	@@FORM_DUMP
        JMP    @@DispAdvanced
@@DUMP_REG_10_3F:
        MOV    AX,10H
        MOV    SI,3FH
        CALL   _DUMP_REG_SUB
;
; 詳細情報表示
;
@@DispAdvanced:

	POP	CX
        .IF [FLAG] & @ADV_REG
            MOV     DI, 34H
            .IF CL == 2
                MOV     DI, 14H
            .ENDIF
            PUSH    DI
            MOV     DX, OFFSET msgCommandReg
            CALL    DISP_MSG
            MOV     DI, 04H
            CALL    READ_PCI_DWORD
            MOV     SI, OFFSET commandBitTable
            CALL    dispBitField
            SHR     ECX, 16
            MOV     DX, OFFSET msgStatusReg
            CALL    DISP_MSG
            MOV     SI, OFFSET statusBitTable
            CALL    dispBitField
            MOV     DX, OFFSET msgNewFuncID
            CALL    DISP_MSG
            POP     DI
            .IF CL & (1 SHL 4)
                CALL    READ_PCI_BYTE
                AND     CL, NOT (11B)
                .IF CL >=40H
                    .REPEAT
                        MOVZX   DI, CL
                        CALL    READ_PCI_WORD
                        PUSH    CX
                        MOV     SI, OFFSET newFuncIDTable
                        .REPEAT
                            .IF [SI] == CL
                                MOV     AL, CL
                                MOV     DI, OFFSET @@msg00h
                                CALL    IntToHex8
                                MOV     DX, OFFSET @@msgNewFuncIDByte
                                CALL    DISP_MSG
                                MOVZX   CX, BYTE PTR [SI+1]
                                LEA     DX, [SI+2]
                                CALL    DISP_MSG_CX
                                JMP     @@TryNextNewFuncId
                            .ENDIF
                            MOVZX   AX, BYTE PTR [SI+1]
                            ADD     SI, AX
                            INC     SI
                            INC     SI
                        .UNTIL BYTE PTR [SI]==0
                        MOV     DX, OFFSET msgNewFuncUnknown
                        CALL    DISP_MSG
@@TryNextNewFuncId:
                        CALL    CRLF
                        POP     CX
                        AND     CH, NOT(11B)
                        MOV     CL, CH
                    .UNTIL ZERO?
                    JMP     @@EndNewFuncID
                .ENDIF
            .ENDIF
            MOV     DX, OFFSET msgNone
            CALL    DISP_MSG
@@EndNewFuncID:
        .ENDIF
	RET




@@FORM_DUMP:
        PUSH    BX
        MOVZX   CX,[SI].REG_DUMP_INFO.REG_STR_LEN
        LEA     DX,[SI].REG_DUMP_INFO.REG_STR
        CALL    DISP_MSG_CX
        POP     BX
	JCXZ	@@L3
        MOV     AX,22
        SUB     AX,CX
        JA      @@L1
        MOV     AX,1
@@L1:
        MOV    CX,AX
        .REPEAT
            MOV    AL,' '
            CALL   DISP_CHAR
        .UNTILCXZ
@@L3:
        PUSH   DI
        MOVZX  DI, [SI].REG_DUMP_INFO.REG_ADRS
        CALL   [SI].REG_DUMP_INFO.REG_DISP
        MOVZX  AX, [SI].REG_DUMP_INFO.REG_STR_LEN
        ADD    SI, AX
        ADD    SI, SIZE REG_DUMP_INFO-1
        POP    DI
        CMP    [SI].REG_DUMP_INFO.REG_ADRS,0
        JNE    @@FORM_DUMP
	RET



@@msgNewFuncIDByte DB ' '
@@msg00h           DB '00h    $'

DUMP_FORM_REG_SUB ENDP

;********************************************************
;	ﾋﾞｯﾄ表示
;
;	INPUT   ECX   Register Value
;               SI    Bit field table
;	OUTPUT 	なし
;	BREAK	AX,EBX,EDX,DI
;
;********************************************************
dispBitField PROC NEAR

        PUSH    EBX
        .WHILE 1
            MOV     EDX, [SI]
            DB      66H,0FH,0BDH,0DAH  ;BSR     EBX, EDX
            .BREAK .IF ZERO?      ;テーブル終了コード(0)である

            PUSH    ECX
            PUSH    ECX

            MOV     DI, OFFSET @@msgBitPos
            MOV     AL, BL
            CALL    IntToStr83

            DB      66H,0FH,0BCH,0CAH   ;BSF     ECX, EDX
            SUB     BX, CX
            .IF !ZERO?
                 MOV     BYTE PTR [DI],'-'
                 INC     DI
                 MOV     AL, CL
                 CALL    IntToStr8
            .ENDIF
            MOV     WORD PTR [DI],"' "
            INC     DI
            INC     DI

            POP     EDX
            SHR     EDX, CL
            MOV     DWORD PTR [DI+BX+1],"$ :'"

            .REPEAT
                SHR     EDX, 1
                MOV     AL,'0'
                ADC     AL, 0
                MOV     [DI+BX], AL
                DEC     BX
            .UNTIL SIGN?

            MOV     DX, OFFSET @@msgBit
            CALL    DISP_MSG

            MOVZX   CX,[SI+4]
            LEA     DX,[SI+5]
            ADD     SI,CX
            ADD     SI,5
            CALL    DISP_MSG_CX
            CALL    CRLF

            POP     ECX
        .ENDW
        POP     EBX
        RET

@@msgBit      DB '  Bit'
@@msgBitPos   DB "000-000 '",32 DUP('0'),"': $"

dispBitField ENDP
;********************************************************
;	ﾊﾞｲﾄ表示
;
;	INPUT	BX    Bus,Device,Function Number
;               DI    Register
;	OUTPUT 	なし
;	BREAK	AX,CL
;
;********************************************************
DISP_BYTE PROC NEAR

        CALL    DISP_BYTE_SUB
        JMP     CRLF

DISP_BYTE_SUB:
        PUSH    DX
        PUSH    DI
        MOV     AX,DI
        MOV     DI,OFFSET @@Index
        CALL    IntToHex8
        MOV     DI,AX
        CALL    READ_PCI_BYTE
        MOV     DI,OFFSET @@Data
        MOV     AL,CL
        CALL    IntToHex8
        MOV     DX,OFFSET @@Msg
        CALL    DISP_MSG
        POP     DI
        POP     DX
        RET

@@Msg     DB 'B('
@@Index   DB '00h) '
@@Data    DB '00h$'

DISP_BYTE ENDP
;********************************************************
;	ﾊﾞｲﾄ表示
;
;	INPUT	BX    Bus,Device,Function Number
;               DI    Register
;	OUTPUT 	なし
;	BREAK	AX,CL
;
;********************************************************
DISP_BYTE_NoCRLF PROC NEAR

        CALL    DISP_BYTE_SUB
        MOV     CX,10

DISP_SPACE_CX:
        PUSH    DX
        MOV     DX,OFFSET @@Space+10
        SUB     DX,CX
        CALL    DISP_MSG
        POP     DX
        RET

@@Space DB 10 DUP (' ')
        DB '$'

DISP_BYTE_NoCRLF ENDP
;********************************************************
;	ﾊﾞｲﾄ表示とClass表示
;
;	INPUT	BX    Bus,Device,Function Number
;               DI    Register
;	OUTPUT  なし
;	BREAK	AX,CX,DX
;
;********************************************************
DISP_BYTE_CLASS PROC NEAR

        CALL    DISP_BYTE_SUB
        MOV     ECX,[CLASS_CODE]
        SHR     ECX,8
        PUSH    DS
        CALL    GET_CLASS_MSG
        .IF !CARRY?
            CALL    SPACE
            MOV     AL,'['
            CALL    DISP_CHAR
            CALL    DISP_MSG_CX
            MOV     AL,']'
            CALL    DISP_CHAR
        .ENDIF
        POP     DS
        JMP     CRLF

DISP_BYTE_CLASS ENDP
;********************************************************
;	ﾜｰﾄﾞ表示
;
;	INPUT	BX    Bus,Device,Function Number
;               DI    Register
;	OUTPUT  CX    ﾚｼﾞｽﾀ値
;	BREAK	AX
;
;********************************************************
DISP_WORD PROC NEAR

        CALL    _DISP_WORD
        JMP     CRLF

_DISP_WORD:
        PUSH    DX
        PUSH    DI
        MOV     AX,DI
        MOV     DI,OFFSET @@Index
        CALL    IntToHex8
        MOV     DI,AX
        CALL    READ_PCI_WORD
        MOV     DI,OFFSET @@Data
        MOV     AX,CX
        CALL    IntToHex16
        MOV     DX,OFFSET @@Msg
        CALL    DISP_MSG
        POP     DI
        POP     DX
        RET

@@Msg   DB 'W('
@@Index DB '00h) '
@@Data  DB '0000h$'

DISP_WORD ENDP
;********************************************************
;	ﾜｰﾄﾞとVendor表示
;
;	INPUT	BX    Bus,Device,Function Number
;               DI    Register
;	OUTPUT  なし
;	BREAK	AX,CX,DX
;
;********************************************************
DISP_WORD_VENDOR PROC NEAR

        CALL    _DISP_WORD
        PUSH    DS
        CALL    GET_VENDOR_MSG
        .IF !CARRY?
            CALL    SPACE
            MOV     AL,'['
            CALL    DISP_CHAR
            CALL    DISP_MSG_CX
            MOV     AL,']'
            CALL    DISP_CHAR
        .ENDIF
        POP     DS
        JMP     CRLF

DISP_WORD_VENDOR ENDP
;********************************************************
;	ﾜｰﾄﾞとVendor表示
;
;	INPUT	BX    Bus,Device,Function Number
;               DI    Register
;	OUTPUT  なし
;	BREAK	AX,CX,DX
;
;********************************************************
DISP_WORD_DEVICE PROC NEAR

        CALL    _DISP_WORD
        SUB     DI,2
        CALL    READ_PCI_DWORD
        ADD     DI,2
        PUSH    DS
        CALL    GET_CHIP_MSG
        .IF !CARRY?
            CALL    SPACE
            MOV     AL,'['
            CALL    DISP_CHAR
            CALL    StrLen
            .IF AX < CX
                ;ﾍﾞﾝﾀﾞ名と、ﾁｯﾌﾟ名が分離している場合は、ﾁｯﾌﾟ名だけ表示する
                ;------------------------
                INC     AX
                ADD     DX,AX
                SUB     CX,AX
                CALL    StrLen
                MOV     CX,AX
            .ENDIF
            CALL    DISP_MSG_CX
            MOV     AL,']'
            CALL    DISP_CHAR
        .ENDIF
        POP     DS
        JMP     CRLF

DISP_WORD_DEVICE ENDP
;********************************************************
;	I/O Base/Limit表示
;
;	INPUT	BX    Bus,Device,Function Number
;               DI    Register
;	OUTPUT 	なし
;	BREAK	AX,CX
;
;********************************************************
DISP_IO_BASE_LIMIT PROC NEAR

        PUSH    DX
        PUSH    DI
        MOV     AX,DI
        MOV     DI,OFFSET @@Index1
        CALL    IntToHex8

        ADD     AL,2
        MOV     DI,OFFSET @@Index2
        CALL    IntToHex8

        MOV     DI,AX
        CALL    READ_PCI_WORD
        MOV     AX,CX
        MOV     DI,OFFSET @@Limit
        CALL    IntToHex16

        POP     DI
        PUSH    DI
        CALL    READ_PCI_WORD
        MOV     AX,CX
        MOV     DI,OFFSET @@Base
        CALL    IntToHex16
        MOV     DX,OFFSET @@Msg
        CALL    DISP_MSG
        POP     DI
        POP     DX
        RET

@@Msg    DB 'W('
@@Index1 DB '00/'
@@Index2 DB '00h) '
@@Base   DB '0000/'
@@Limit  DB '0000h',13,10,'$'

DISP_IO_BASE_LIMIT ENDP
;********************************************************
;	ﾜｰﾄﾞｻｲｽﾞ分ﾋﾞｯﾄﾊﾟﾀｰﾝ表示
;
;	INPUT	BX    Bus,Device,Function Number
;               DI    Register
;	OUTPUT 	なし
;	BREAK	AX,CX
;
;********************************************************
DISP_WORD_BIT PROC NEAR

        PUSH    DX
        PUSH    DI
        MOV     AX,DI
        MOV     DI,OFFSET @@Index
        CALL    IntToHex8
        MOV     DI,AX
        CALL    READ_PCI_WORD
        MOV     AX,CX
        MOV     DI,OFFSET @@Data
        CALL    IntToHex16

        MOV     AH,16
        MOV     DI,OFFSET @@Bit-1
        .REPEAT
            .IF !(AH & 11B)
                INC     DI
            .ENDIF
            MOV     AL,'0'
            ROL     CX,1
            ADC     AL,0
            MOV     [DI],AL
            INC     DI
            DEC     AH
        .UNTIL ZERO?

        MOV     DX,OFFSET @@Msg
        CALL    DISP_MSG
        POP     DI
        POP     DX
        RET

@@Msg   DB 'W('
@@Index DB '00h) '
@@Data  DB "0000h ['"
@@Bit   DB "0000 0000 0000 0000'b]",13,10,'$'

DISP_WORD_BIT ENDP

;********************************************************
;	3ﾊﾞｲﾄ表示
;
;	INPUT	BX    Bus,Device,Function Number
;               DI    Register
;	OUTPUT 	なし
;	BREAK	AX,CL
;
;********************************************************
DISP_3BYTE PROC NEAR

        CALL    DISP_3BYTE_SUB
	JMP	CRLF

DISP_3BYTE_SUB:
        PUSH    DX
        PUSH    DI
        MOV     AX,DI
        MOV     DI,OFFSET @@Index
        CALL    IntToHex8
        MOV     DI,AX
	PUSH	DI
        CALL    READ_PCI_BYTE
        MOV     DI,OFFSET @@Data1
        MOV     AL,CL
        CALL    IntToHex8
	POP	DI
	INC	DI
	INC	DI
        CALL    READ_PCI_WORD
        MOV     DI,OFFSET @@Data2
        MOV     AX,CX
        CALL    IntToHex16
        MOV     DX,OFFSET @@Msg
        CALL    DISP_MSG
        POP     DI
        POP     DX
        RET

@@Msg     DB 'T('
@@Index   DB '00h) '
@@Data2   DB '0000'
@@Data1   DB '00h$'

DISP_3BYTE ENDP
;********************************************************
;	3ﾊﾞｲﾄ表示
;
;	INPUT	BX    Bus,Device,Function Number
;               DI    Register
;	OUTPUT 	なし
;	BREAK	AX,CL
;
;********************************************************
DISP_3BYTE_NoCRLF PROC NEAR

        CALL    DISP_3BYTE_SUB
        MOV     CX,6
	JMP	DISP_SPACE_CX

DISP_3BYTE_NoCRLF ENDP
;********************************************************
;	ﾀﾞﾌﾞﾙﾜｰﾄﾞ表示
;
;	INPUT	BX    Bus,Device,Function Number
;               DI    Register
;	OUTPUT 	なし
;	BREAK	AX,ECX
;
;********************************************************
DISP_DWORD PROC NEAR

        CALL    DISP_DWORD_SUB
        JMP     CRLF

DISP_DWORD_SUB:

        PUSH    DX
        PUSH    DI
        MOV     AX,DI
        MOV     DI,OFFSET @@Index
        CALL    IntToHex8
        MOV     DI,AX
        CALL    READ_PCI_DWORD
        MOV     EAX,ECX
        MOV     DI,OFFSET @@Data
        CALL    IntToHex32
        MOV     DX,OFFSET @@Msg
        CALL    DISP_MSG
        POP     DI
        POP     DX
        RET

@@Msg   DB   'D('
@@Index DB   '00h) '
@@Data  DB   '00000000h$'

DISP_DWORD ENDP
;********************************************************
;	ﾀﾞﾌﾞﾙﾜｰﾄﾞ表示
;
;	INPUT	BX    Bus,Device,Function Number
;               DI    Register
;	OUTPUT 	なし
;	BREAK	AX,ECX
;
;********************************************************
DISP_DWORD_NoCRLF PROC NEAR

        CALL    DISP_DWORD_SUB
        MOV     CX,4
	JMP	DISP_SPACE_CX

DISP_DWORD_NoCRLF ENDP
;********************************************************
;	ﾒﾓﾘﾍﾞｰｽ/ﾘﾐｯﾄ表示
;
;	INPUT	BX    Bus,Device,Function Number
;               DI    Register
;	OUTPUT 	なし
;	BREAK	AX,ECX
;
;********************************************************
DISP_MEM_BASE_LIMIT PROC NEAR

        PUSH    DX
        PUSH    DI
        MOV     AX,DI
        MOV     DI,OFFSET @@Index1
        CALL    IntToHex8
        ADD     AL,4
        MOV     DI,OFFSET @@Index2
        CALL    IntToHex8
        MOV     DI,AX
        CALL    READ_PCI_DWORD
        MOV     EAX,ECX
        MOV     DI,OFFSET @@Limit
        CALL    IntToHex32
        POP     DI
        PUSH    DI
        CALL    READ_PCI_DWORD
        MOV     EAX,ECX
        MOV     DI,OFFSET @@Base
        CALL    IntToHex32
        MOV     DX,OFFSET @@Msg
        CALL    DISP_MSG
        POP     DI
        POP     DX
        RET

@@Msg    DB 'D('
@@Index1 DB '00/'
@@Index2 DB '00h) '
@@Base   DB '00000000/'
@@Limit  DB '00000000h',13,10,'$'

DISP_MEM_BASE_LIMIT ENDP
;********************************************************
;	ﾚｼﾞｽﾀﾀﾞﾝﾌﾟ
;
;	INPUT	BX    Bus,Device,Function Number
;	OUTPUT 	なし
;	BREAK	AX,DX
;
;********************************************************
DUMP_REG_SUB PROC NEAR

        TEST    [FLAG],@DUMP_REG
        JZ      DUMP_FORM_REG_SUB

        MOV     AX,0
        MOV     SI,0FFH
_DUMP_REG_SUB:
        .REPEAT
            MOV     DI,OFFSET @@Index
            CALL    IntToHex16
            MOV     DI,OFFSET @@Data
            .REPEAT
                PUSH    AX
                PUSH    DI
                MOV     DI,AX
                .IF [FLAG] & @dumpByte
                    CALL    READ_PCI_BYTE
                    MOV     AL,CL
                    POP     DI
                    CALL    IntToHex8
                    MOV     BYTE PTR [DI+2],' '
                    POP     AX
                    ADD     DI,3
                    ADD     AX,1
                .ELSEIF [FLAG] & @dumpWord
                    CALL    READ_PCI_WORD
                    MOV     AX,CX
                    POP     DI
                    CALL    IntToHex16
                    MOV     BYTE PTR [DI+4],' '
                    POP     AX
                    ADD     DI,5
                    ADD     AX,2
                .ELSE
                    CALL    READ_PCI_DWORD
                    MOV     EAX,ECX
                    POP     DI
                    CALL    IntToHex32
                    MOV     BYTE PTR [DI+8],' '
                    POP     AX
                    ADD     DI,9
                    ADD     AX,4
                .ENDIF
            .UNTIL !(AX & 0FH)
            MOV     WORD PTR [DI],0A0Dh
            MOV     BYTE PTR [DI+2],'$'
            MOV     DX,OFFSET @@Msg
            CALL    DISP_MSG
        .UNTIL !(AX & SI)
        RET

@@Msg  LABEL BYTE
@@Index DB '0000: '
@@Data  DB '00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00',13,10,'$'

DUMP_REG_SUB ENDP

;********************************************************
;	ﾚｼﾞｽﾀ表示
;
;	INPUT	なし
;	OUTPUT 	なし
;	BREAK	AX,DX
;
;********************************************************
DISP_REG_DAT PROC NEAR

        CALL    DISP_REG_ADRS
        MOV     BH,[BUS_NUM]
        MOV     BL,[DEV_NUM]
        SHL     BL,3
        OR      BL,[FNC_NUM]
        MOVZX   DI,[REG_NUM]
        .IF DI & 11B
            .IF DI & 1B
                ;Byte
                ;------------------
                CALL    READ_PCI_BYTE
_DISP_REG_BYTE:
                MOV     AL,CL
                MOV     DI,OFFSET @@StrB
                CALL    IntToHex8
            .ELSE
                ;Word
                ;------------------
                CALL    READ_PCI_WORD
_DISP_REG_WORD:
                MOV     AX,CX
                MOV     DI,OFFSET @@StrW
                CALL    IntToHex16
            .ENDIF
        .ELSE
            ;Dword
            ;-------------------
            CALL    READ_PCI_DWORD
_DISP_REG_DWORD:
            MOV     EAX,ECX
            MOV     DI,OFFSET @@StrD
            CALL    IntToHex32
        .ENDIF
        MOV     DX,DI
        JMP     DISP_MSG

@@StrD  DB '0000'
@@StrW  DB '00'
@@StrB  DB '00',13,10,'$'

DISP_REG_DAT ENDP

;********************************************************
;	ﾚｼﾞｽﾀ表示
;
;	INPUT	なし
;	OUTPUT 	なし
;	BREAK	AX,DX
;
;********************************************************
SET_REG_DAT PROC NEAR

        CALL    DISP_REG_ADRS

        MOV     BH,[BUS_NUM]
        MOV     BL,[DEV_NUM]
        SHL     BL,3
        OR      BL,[FNC_NUM]
        MOVZX   DI,[REG_NUM]
        MOV     ECX,[DAT_VAL]
        .IF [DAT_SIZE] < 3
            .IF [DAT_SIZE] != 2
                ;Byte
                ;------------------
                CALL    WRITE_PCI_BYTE
                JMP     _DISP_REG_BYTE
            .ENDIF
            ;Word
            ;------------------
            TEST    DI,1
            JNZ     @@ERROR
            CALL    WRITE_PCI_WORD
            JMP     _DISP_REG_WORD
        .ENDIF
        ;Dword
        ;-------------------
        TEST    DI,11B
        JNZ     @@ERROR
        CALL    WRITE_PCI_DWORD
        JMP     _DISP_REG_DWORD

@@ERROR:
        MOV     DX,OFFSET ILLEGAL_SIZE_MSG
        JMP     DISP_MSG

SET_REG_DAT ENDP

;********************************************************
;	ﾚｼﾞｽﾀ ｱﾄﾞﾚｽ表示
;
;	INPUT	なし
;	OUTPUT 	なし
;	BREAK	AX,DX,DI
;
;********************************************************
DISP_REG_ADRS PROC NEAR

        MOV     DX,OFFSET BUS_EQU_MSG
        CALL    DISP_MSG
        MOV     AL,[BUS_NUM]
        CALL    DECPRT8

        MOV     DX,OFFSET DEV_EQU_MSG
        CALL    DISP_MSG
        MOV     AL,[DEV_NUM]
        CALL    DECPRT8

        MOV     DX,OFFSET FNC_EQU_MSG
        CALL    DISP_MSG
        MOV     AL,[FNC_NUM]
        CALL    DECPRT8

        MOV     AL,[REG_NUM]
        MOV     DI,OFFSET HEX_MSG
        CALL    IntToHex8
        MOV     DX,OFFSET REG_EQU_MSG
        JMP     DISP_MSG

DISP_REG_ADRS  ENDP


READ_PCI_BYTE PROC NEAR

        MOV     AX,0B108H
        INT     1AH
        RET

READ_PCI_BYTE ENDP

READ_PCI_WORD PROC NEAR

        MOV     AX,0B109H
        INT     1AH
        RET

READ_PCI_WORD ENDP

READ_PCI_DWORD PROC NEAR

        MOV     AX,0B10AH
        INT     1AH
        RET

READ_PCI_DWORD ENDP

WRITE_PCI_BYTE PROC NEAR

        MOV     AX,0B10BH
        INT     1AH
        RET

WRITE_PCI_BYTE ENDP

WRITE_PCI_WORD PROC NEAR

        MOV     AX,0B10CH
        INT     1AH
        RET

WRITE_PCI_WORD ENDP

WRITE_PCI_DWORD PROC NEAR

        MOV     AX,0B10DH
        INT     1AH
        RET

WRITE_PCI_DWORD ENDP

DISP_CHAR PROC NEAR

        PUSH    AX
        PUSH    DX
        MOV     AH,2
        MOV     DL,AL
        INT     21H
        POP     DX
        POP     AX
        RET

DISP_CHAR ENDP

SPACE   PROC NEAR

        PUSH    AX
        PUSH    DX
        MOV     AH,2
        MOV     DL,' '
        INT     21H
        POP     DX
        POP     AX
        RET

SPACE   ENDP


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

DISP_MSG PROC NEAR
        PUSH    AX
        MOV     AH,9
        INT     21H
        POP     AX
        RET
DISP_MSG ENDP

DISP_SUPPORT_IF_NZ PROC NEAR

        MOV     DX,OFFSET SUPPORT_MSG
        JNZ     @@TRUE
        MOV     DX,OFFSET NOT_SUPPORT_MSG
@@TRUE:
        JMP     DISP_MSG

DISP_SUPPORT_IF_NZ ENDP

;************************
;
;  入力   DS:DX   ﾒｯｾｰｼﾞｱﾄﾞﾚｽ
;         CX      ﾒｯｾｰｼﾞﾊﾞｲﾄ数
;  出力   なし
;  破壊   なし
;************************
DISP_MSG_CX PROC NEAR
        PUSH    AX
        PUSH    BX
        MOV     BX,1
        MOV     AH,40H
        INT     21H
        POP     BX
        POP     AX
        RET
DISP_MSG_CX ENDP
;************************
;  ﾒｯｾｰｼﾞの長さ取得
;
;  入力   DS:DX   ﾒｯｾｰｼﾞｱﾄﾞﾚｽ
;         CX      ﾒｯｾｰｼﾞ最大ﾊﾞｲﾄ数
;  出力   AX      ﾒｯｾｰｼﾞﾊﾞｲﾄ数
;  破壊   なし
;************************
StrLen PROC NEAR

        PUSH    BX
        PUSH    CX
        PUSH    DX
        MOV     BX,DX
        XOR     AX,AX
        .REPEAT
            .BREAK .IF BYTE PTR [BX] == 0
            INC     BX
            INC     AX
        .UNTILCXZ
        POP     DX
        POP     CX
        POP     BX
        RET

StrLen ENDP
;********************************************************
;       Int To Hex
;
;       INPUT   EAX
;               DI       変換文字列格納ｱﾄﾞﾚｽ
;       OUTPUT  なし
;       BREAK   NONE
;
;********************************************************
IntToHex32 PROC  NEAR

        ADD     DI,4
        CALL    IntToHex16
        ROR     EAX,16
        SUB     DI,4
        CALL    IntToHex16
        ROR     EAX,16
        RET

IntToHex32 ENDP
;********************************************************
;       Int To Hex
;
;       INPUT   AX
;               DI       変換文字列格納ｱﾄﾞﾚｽ
;       OUTPUT  なし
;       BREAK   NONE
;
;********************************************************
IntToHex16 PROC  NEAR

        ADD     DI,2
        CALL    IntToHex8
        XCHG    AL,AH
        SUB     DI,2
        CALL    IntToHex8
        XCHG    AL,AH
        RET

IntToHex16 ENDP
;********************************************************
;       Int To Hex
;
;       INPUT   AL
;               DI       変換文字列格納ｱﾄﾞﾚｽ
;       OUTPUT  なし
;       BREAK   NONE
;
;********************************************************
IntToHex8 PROC  NEAR

        PUSH    AX
        PUSH    DX

        ADD     DI,2
        CALL    HEX_PRINT_SUB
        ROR     AL,4
        CALL    HEX_PRINT_SUB

        POP     DX
        POP     AX
        RET

IntToHex8 ENDP
;********************************************************
;
;       HEX PRINT SUBROUTINE
;
;       INPUT   AL,DI
;       OUTPUT  DI=DI-1
;       BREAK   NONE
;
;********************************************************
HEX_PRINT_SUB   PROC    NEAR

        MOV     DL,AL
        AND     DL,0FH
        ADD     DL,'0'
        CMP     DL,'9'
        JBE     HEX_PRINT_SUB_1
        ADD     DL,'A'-'0'-10

HEX_PRINT_SUB_1:
        DEC     DI
        MOV     [DI],DL
        RET

HEX_PRINT_SUB   ENDP

;************************************************
;
;	DECIMAL PRINT
;
;		INPUT	AL
;		OUTPUT	NONE
;		BREAK	NONE
;************************************************
DECPRT8	PROC	NEAR

	PUSH	AX
	PUSH	DX
	PUSH	DI

	MOV	DI,OFFSET DEC_MSG+2
@@LOOP:
        XOR     AH,AH
        MOV     DL,10
        DIV     DL
        ADD     AH,'0'
        MOV     [DI],AH
        TEST    AL,AL
        JZ      @@DISP
        DEC     DI
        JMP     @@LOOP
@@DISP:
        MOV     DX,DI
        CALL    DISP_MSG
	POP	DI
	POP	DX
	POP	AX
	RET

DECPRT8	ENDP
;************************************************
;
;       値を、10進文字列に変換
;
;               INPUT   AL
;                       DI       文字列格納ｱﾄﾞﾚｽ
;               OUTPUT  DI       終了ｱﾄﾞﾚｽ
;               BREAK   NONE
;************************************************
IntToStr83 PROC NEAR


        MOV     WORD PTR [DI],'  '
        ADD     DI,2
subIntToStr8:
	PUSH	DI
        PUSH    AX
        PUSH    DX
        .WHILE 1
            XOR     AH,AH
            MOV     DL,10
            DIV     DL
            ADD     AH,'0'
            MOV     [DI],AH
            .BREAK .IF !(AL & AL)
            DEC     DI
        .ENDW
        POP     DX
        POP     AX
	POP	DI
        INC     DI
        RET

IntToStr83 ENDP

;************************************************
;
;       値を、10進文字列に変換
;
;               INPUT   AL
;                       DI       文字列格納ｱﾄﾞﾚｽ
;               OUTPUT  DI       終了ｱﾄﾞﾚｽ
;               BREAK   NONE
;************************************************
IntToStr82 PROC NEAR


        MOV     BYTE PTR [DI],' '
        INC     DI
	JMP	subIntToStr8

IntToStr82 ENDP

;************************************************
;
;       値を、10進文字列に変換
;
;               INPUT   AL
;                       DI       文字列格納ｱﾄﾞﾚｽ
;               OUTPUT  DI       終了ｱﾄﾞﾚｽ
;               BREAK   NONE
;************************************************
IntToStr8 PROC NEAR

	PUSH	AX
	PUSH    DX

        XOR     DH, DH
        MOV     DL, 100
        .WHILE 1
            XOR     AH, AH
            DIV     DL
            .IF (AL & AL) || (DH & DH)
                ADD     AL, '0'
                MOV     [DI], AL
                INC     DI
                MOV     DH, -1
            .ENDIF
            .BREAK .IF DL == 10
            MOV     AL, AH
            MOV     DL, 10
        .ENDW
        ADD     AH,'0'
        MOV     [DI], AH
        INC     DI

        POP     DX
        POP     AX
        RET

IntToStr8 ENDP

;***********************************************
;
;	ｺﾏﾝﾄﾞﾗｲﾝﾊﾟﾗﾒｰﾀ取得
;
;	入力	SI	ｺﾏﾝﾄﾞﾗｲﾝ取得開始ｱﾄﾞﾚｽ
;	出力	CX	0)取得出来ず
;			≠0)ﾊﾟﾗﾒｰﾀの文字数
;		SI	ﾊﾟﾗﾒｰﾀ開始ｱﾄﾞﾚｽ
;	破壊	AL
;***********************************************
PUBLIC	GET_ARG
GET_ARG		PROC	NEAR

	XOR	CX,CX

;ﾊﾟﾗﾒｰﾀの前の空白文字を読み飛ばす
;-----------------------
@@SSKIP:
	LODSB
	CMP	AL,0DH
	JE	@@END
	CMP	AL,' '
	JE	@@SSKIP
	CMP	AL,09H
	JE	@@SSKIP

;ﾊﾟﾗﾒｰﾀの文字数取得
;-------------------------
	DEC	SI
	PUSH	SI
@@COUNT:
	LODSB
	CMP	AL,0DH
	JE	@@COUNT_END
	CMP	AL,' '
	JE	@@COUNT_END
	CMP	AL,09H
	LOOPNE	@@COUNT
@@COUNT_END:
	NEG	CX
	POP	SI
@@END:
	RET

GET_ARG	ENDP

;***********************************************
;
;	ﾊﾟﾗﾒｰﾀｺﾋﾟｰ
;
;	入力	SI	ﾊﾟﾗﾒｰﾀ開始ｱﾄﾞﾚｽ
;		CX	ｺﾋﾟｰする文字数
;		DI	ｺﾋﾟｰ先
;	出力	CX	0
;		SI	SI+CX
;		DI	DI+CX
;	破壊	AL
;***********************************************
PUBLIC	COPY_ARG
COPY_ARG	PROC	NEAR

@@LOOP:
	LODSB
	MOV	CS:[DI],AL
	INC	DI
	LOOP	@@LOOP
	MOV	BYTE PTR CS:[DI],0
	RET
COPY_ARG	ENDP

;***********************************************
;
;       ｺﾏﾝﾄﾞﾗｲﾝより値取得
;
;	入力	SI	ﾊﾟﾗﾒｰﾀ開始ｱﾄﾞﾚｽ
;		CX	文字数
;	出力
;               SI      入力 SI+CX
;               EAX     読み込んだ値
;               CX      値の桁数
;               CY      0)取得できた 1)取得できない
;	破壊	EDX
;***********************************************
GET_VALUE  PROC NEAR

        CMP     BYTE PTR [SI],'$'
        JE      @@HEX

;10進で値取得
;--------------------
        XOR     EAX,EAX
        PUSH    CX
@@DEC_LOOP:
        MOV     EDX,10
        MUL     EDX
        TEST    EDX,EDX
        JNZ     @@ERROR

        MOV     DL,[SI]
        SUB     DL,'0'
        JB      @@ERROR
        CMP     DL,9
        JA      @@ERROR
        ADD     EAX,EDX
        INC     SI
        LOOP    @@DEC_LOOP
        JMP     @@END

;16進で値取得
;--------------------
@@HEX:
        INC     SI
        DEC     CX
        JZ      @@ERROR2

GET_HEX_VALUE:

        PUSH    CX
        XOR     EAX,EAX
        XOR     EDX,EDX
@@HEX_LOOP:
        ROL     EAX,4
        TEST    AL,00FH
        JNZ     @@ERROR
        AND     AL,0F0H

        MOV     DL,[SI]
        CMP     DL,'0'
        JB      @@ERROR
        CMP     DL,'9'
        JA      @@HEX_ALPHA
        SUB     DL,'0'
        JMP     @@HEX_ADD
@@HEX_ALPHA:
        AND     DL,0DFH
        CMP     DL,'A'
        JB      @@ERROR
        CMP     DL,'F'
        JA      @@ERROR
        SUB     DL,'A'-10
@@HEX_ADD:
        INC     SI
        ADD     EAX,EDX
        LOOP    @@HEX_LOOP

@@END:
        POP     CX
        INC     CX
        SHR     CX,1
        CLC
        RET

@@ERROR:
        POP     CX
@@ERROR2:
        STC
        RET

GET_VALUE  ENDP

;******************************************************************************
;
;       自分の起動ｺﾏﾝﾄﾞ名を取得
;
;	INPUT   DS:SI     ｺﾏﾝﾄﾞ名格納ｱﾄﾞﾚｽ
;	OUTPUT  CY        0)ｺﾏﾝﾄﾞ名を見つけた 1)見つからなかった
;               DS:SI     ｺﾏﾝﾄﾞ名文字列最終ｱﾄﾞﾚｽ(文字列終了ｺｰﾄﾞ00hの次のｱﾄﾞﾚｽ)
;	BREAK	AX,CX
;******************************************************************************
GET_MY_PATH PROC NEAR

        PUSH    ES
        MOV     AX,DS:[02CH]    ;環境変数セグメント
        DEC     AX
        MOV     ES,AX
        INC     AX
        MOV     CX,ES:[3]       ;環境変数エリアのサイズ(パラグラフ単位)
        MOV     ES,AX
        SHL     CX,4
        XOR     DI,DI           ;   〃   オフセット
        CLD
@@SEARCH:
        XOR     AL,AL
        REPNZ   SCAS   BYTE PTR ES:[DI]
        JNZ     @@NOT_FOUND
        CMP     BYTE PTR ES:[DI],0
        JNZ     @@SEARCH
        ADD     DI,3
@@COPY:
        MOV     AL,ES:[DI]
        MOV     DS:[SI],AL
        INC     DI
        INC     SI
        TEST    AL,AL
        JNZ     @@COPY

        POP     ES
        RET

@@NOT_FOUND:

        STC
        POP     ES
        RET

GET_MY_PATH ENDP

;******************************************************************************
;
;INIﾌｧｲﾙ読込と変換
;
;	INPUT   DS     CS
;               DX     INIﾌｧｲﾙ名
;	OUTPUT  ES     変換したﾃﾞｰﾀを格納したﾊﾞｯﾌｧｾｸﾞﾒﾝﾄ
;               DI     0)ﾊﾞｯﾌｧ無し
;                      0以外)変換したﾃﾞｰﾀを格納したﾊﾞｯﾌｧのｻｲｽﾞ
;	BREAK	AH
;
;   WORD  Item Size
;   BYTE  00h(Stand alone pattern)
;   DWORD Vendor ID or Class Code or Vendor&Device ID
;   BYTES  String(Type of ASCIIZ)
;   BYTES  String(Type of ASCIIZ)
;    :
;    :
;
;   WORD  Item Size
;   BYTE  01h(Top level compare pattern)
;   DWORD Vendor ID or Class Code or Vendor&Device ID
;   DWORD Mask pattern
;   BYTES  String(Type of ASCIIZ)
;   BYTES  String(Type of ASCIIZ)
;    :
;    :
;
;   WORD  Item Size
;   BYTE  02h(Low level compare pattern)
;   DWORD Vendor ID or Class Code or Vendor&Device ID
;   DWORD Mask pattern
;   BYTES  String(Type of ASCIIZ)
;   BYTES  String(Type of ASCIIZ)
;    :
;    :
;
;******************************************************************************
READ_INI_FILE PROC NEAR

;ﾌｧｲﾙ名作成
;----------------------------
        MOV    DI,[PATH_ADRS]
        MOV    SI,DX
GET_INI_ADD_NAME:
        MOV    AL,[SI]
        MOV    [DI],AL
        INC    SI
        INC    DI
        TEST   AL,AL
        JNZ    GET_INI_ADD_NAME

;INIﾌｧｲﾙを開く
;------------------------
        MOV    DX,OFFSET INI_NAME
        MOV    AX,3D00H
        INT    21H
        MOV    DI,0
        JC     @@END
        MOV    [INI_HANDLE],AX
        MOV    [RED_SIZE],0

;ﾊﾞｯﾌｧ取得(64KB)
;------------------------
        MOV    AH,48H
        MOV    BX,1000H
        INT    21H
        JC     @@CLOSE                 ;ﾒﾓﾘが足りない
        MOV    ES,AX
        XOR    DI,DI

;ﾌｧｲﾙ変換
;-----------------------
        MOV    [RED_SIZE],0

        ;ID読込
        ;----------------------
@@GET_LINE:
        MOV	BYTE PTR ES:[DI+2], 00h
        MOV     SI, OFFSET STR_BUFFER
        CALL    GET_TXT_VALUE
        JC      @@CLOSE
        .IF !(DX & DX)
            MOV     DWORD PTR ES:[DI+2+1],EAX

            ;Mask Patternを読み込む
            ;----------------------
            MOV     SI, OFFSET STR_BUFFER
            CALL    GET_TXT_VALUE
            JC      @@CLOSE
            .IF !(DX & DX)
                MOV    BYTE PTR ES:[DI+2], 01h
                .IF ([FLAG] & @IN_KAKKO)
                    MOV    BYTE PTR ES:[DI+2], 02h
                .ENDIF
                MOV    DWORD PTR ES:[DI+2+1+4],EAX
                MOV    SI, OFFSET STR_BUFFER
                CALL    GET_TXT_VALUE
                JC      @@CLOSE

            .ENDIF
            CMP     DX, 4
            JE      @@GET_LINE

            CMP     DX, 1
            JNE     @@SKIP_LINE
            ;ﾀｲﾄﾙ読込
            ;-----------------------
            LEA     BX,[DI+2+1+4]
            .IF BYTE PTR ES:[DI+2]!=00h
                LEA     BX,[DI+2+1+4+4]
            .ENDIF
            .WHILE 1
                MOV     CX, SI
                MOV     SI, OFFSET STR_BUFFER
                SUB     CX, SI
                .IF !ZERO?
                    .REPEAT
                        MOV     AL, DS:[SI]
                        MOV     ES:[BX], AL
                        INC     SI
                        INC     BX
                        .BREAK .IF ZERO?
                    .UNTILCXZ
                    JZ      @@CLOSE
                .ENDIF
                MOV     BYTE PTR ES:[BX],0
                ;二つ目のﾀｲﾄﾙが存在するかﾁｪｯｸ
                ;----------------------
                MOV     SI, OFFSET STR_BUFFER
                CALL    GET_TXT_VALUE
                .BREAK .IF CARRY?
                .BREAK .IF DX != 1
                INC    BX
            .ENDW

            ;次の格納ｱﾄﾞﾚｽ計算
            ;------------------------
            MOV     AX,BX
            SUB     AX,DI
            MOV     ES:[DI],AX
            MOV     DI,BX
            CMP     DX, 4
            JE      @@GET_LINE
        .ELSEIF DX == 2
            ;'{'の場合
            ;------------------
            OR     [FLAG], @IN_KAKKO
        .ELSEIF DX == 3
            ;'}'の場合
            ;------------------
            AND     [FLAG], NOT @IN_KAKKO
        .ELSEIF DX == 5
            ;次の行まで読み飛ばす
            ;-----------------------
@@SKIP_LINE:
            .REPEAT
                MOV     SI, OFFSET STR_BUFFER
                CALL    GET_TXT_VALUE
                JC      @@CLOSE
            .UNTIL DX == 4
        .ENDIF
        JMP     @@GET_LINE

;ﾊﾞｯﾌｧｻｲｽﾞ更新
;------------------
@@CLOSE:
        ;INIﾌｧｲﾙを閉じる
        ;------------------------
        MOV    AH,3EH
        MOV    BX,[INI_HANDLE]
        INT    21H

        MOV    BX,DI
        ADD    BX,15
        JA     @@SIZE64KB

        SHR    BX,4
        MOV    AH,4AH          ;ﾒﾓﾘﾌﾞﾛｯｸｻｲｽﾞ変更
        JNZ    @@MEM_FREE
            MOV     AH,49H     ;ﾒﾓﾘﾌﾞﾛｯｸ開放
@@MEM_FREE:
        INT    21H
@@SIZE64KB:
@@END:
        RET

READ_INI_FILE ENDP
;******************************************************************************
;
;ﾌｧｲﾙ 16進数字読込　か　文字列読み込み
;
;	INPUT   DS:SI     文字列の場合、文字列読み込みアドレス
;	OUTPUT  CY        0)読み込めた 1)読み込めない
;               EAX       数値の場合、読み込んだ値
;		DS:SI     文字列の場合、文字列最終アドレス
;		DX        0)数値を読み込んだ
;			  1)文字列を読み込んだ
;			  2)'{'を読み込んだ
;			  3)'}'を読み込んだ
;			  4)改行を読み込んだ
;			  5)認識できず
;	BREAK	EDX
;******************************************************************************
GET_TXT_VALUE PROC NEAR

;余計な文字を読み飛ばす
;--------------------------
	.REPEAT
            CALL    GET_CHAR
            JC      @@EOF
            .IF (AL == 0Dh) || (AL == 0Ah)
                MOV     DX, 4
                CLC
                RET
            .ENDIF
        .UNTIL (AL != ' ') && \
               (AL != ',') && \
               (AL != 9)

;'{', '}', '"' もしくは '0x'確認
;----------------------------
        .IF (AL == '"')
            .WHILE 1
                CALL    GET_CHAR
                JC      @@EOF
                CMP     AL,0DH
                JE      @@NG
                CMP     AL,0AH
                JE      @@NG
                .IF AL == '"'
                    MOV     DX, 1
                    CLC
                    RET
                .ENDIF
                MOV     BYTE PTR DS:[SI],AL
                INC     SI
            .ENDW
            JMP     @@NG
        .ELSEIF AL == '0'
            CALL    GET_CHAR
            JC      @@EOF
            AND     AL,0DFH
            CMP     AL,'X'
            JNE     @@NG

;16進部分取得
;----------------------------
            XOR     EDX,EDX
@@LOOP:
            CALL    GET_CHAR
            JC      @@EOF

            CMP     AL,'0'
            JB      @@GET_VAL_END
            CMP     AL,'9'
            JBE     @@NEXT_VAL
            AND     AL,0DFH
            CMP     AL,'A'
            JB      @@GET_VAL_END
            CMP     AL,'F'
            JA      @@GET_VAL_END
            SUB     AL,'A'-10-'0'
@@NEXT_VAL:
            SUB     AL,'0'
            SHL     EDX,4
            OR      DL,AL
            JMP     @@LOOP

@@GET_VAL_END:
            MOV     EAX,EDX
            XOR     DX, DX
            CLC
        .ELSEIF (AL == '{')
            MOV     DX, 2
            CLC
        .ELSEIF (AL == '}')
            MOV     DX, 3
            CLC
        .ELSE
@@NG:
            MOV     DX, 5
            CLC
        .ENDIF
        RET

@@EOF:
        STC
        RET

GET_TXT_VALUE ENDP
;******************************************************************************
;
;ﾌｧｲﾙ 1ﾊﾞｲﾄ読込
;
;	INPUT   なし
;	OUTPUT  CY        0)読み込めた 1)読み込めない
;               AL        読み込んだ値
;	BREAK	AH
;******************************************************************************
GET_CHAR PROC NEAR

        PUSH   BX
        CMP    [RED_SIZE],0
        JNE    @@READ_BYTE
            PUSH   CX
            PUSH   DX
            PUSH   DS
            MOV    AH,3FH
            MOV    BX,[INI_HANDLE]
            MOV    CX,4000H
            XOR    DX,DX
            MOV    DS,[REDBUF_SEG]
            INT    21H
            POP    DS
            POP    DX
            POP    CX
            JC     @@NG
            TEST   AX,AX
            JZ     @@NG
            MOV    [RED_SIZE],AX
            MOV    [RED_POINT],0
@@READ_BYTE:
        MOV     BX,[RED_POINT]
        PUSH    DS
        MOV     DS,[REDBUF_SEG]
        MOV     AL,[BX]
        POP     DS
        INC     BX
        MOV     [RED_POINT],BX
        CMP     BX,[RED_SIZE]
        JB      @@READ_OK
            MOV    [RED_SIZE],0
@@READ_OK:
        CLC
        POP     BX
        RET

@@NG:
        STC
        POP     BX
        RET

GET_CHAR ENDP


USAGE_MSG LABEL BYTE
        DB  'PCI Registor Dump for AT 2001/2/28 by SUGAWARA',13,10
        DB  'Usage  REDPCI [Option] [BusNo] [DevNo] [FuncNo] [RegNo] [Data]',13,10
        DB  13,10
        DB  '   [Option]    /D[Size] Dump All Registers(0-FF)',13,10
        DB  '               [Size]    1...Read byte size',13,10
        DB  '                         2...Read word size',13,10
        DB  '                         4...Read double word size',13,10
        DB  '               /F   Dump Defined Registers(0-3F)',13,10
        DB  '               /A   Dump Detailed information',13,10
        DB  '               /M   Search all bus number (0-255)',13,10
        DB  '   [BusNo]     Bus Number     (0..255 or $0..$FF)',13,10
        DB  '   [DevNo]     Device Number  (0.. 31 or $0..$1F)',13,10
        DB  '   [FuncNo]    Function Number(0..  7 or $0..$7)',13,10
        DB  '   [RegNo]     Register Number(00..FF)',13,10
        DB  '   [Data]      Write Data',13,10
        DB  '                        0-FF        Byte Data',13,10
        DB  '                      000-FFFF      Word Data',13,10
        DB  '                    00000-FFFFFFFF  Double Word Data',13,10
        DB  13,10
        DB  ' REDPCI.COM needs VENDTBL.TXT,CHIPTBL.TXT,CLASTBL.TXT',13,10
SIZE_USAGE_MSG = $-USAGE_MSG

NOT_SUPPORT_MSG DB 'Not '
SUPPORT_MSG     DB 'Supported',13,10,'$'

NOT_EXIST_PCI_BIOS_MSG DB 'Not Exists PCI BIOS',13,10,'$'
HIDDEN_PCI_BIOS_MSG DB 'REDPCI.COM is could not run on this OS.',13,10,'$'
CNF1_MSG       DB 'Configuration Mechanism #1 : $'
CNF2_MSG       DB 'Configuration Mechanism #2 : $'
CYC1_MSG       DB 'Special Cycle Generation on Configuration Mechanism #1 : $'
CYC2_MSG       DB 'Special Cycle Generation on Configuration Mechanism #2 : $'
PCI_BIOS_IF_LVL_MSG    DB 'PCI BIOS Interface Level Version : '
PCI_BIOS_VER_STR       DB '00.00',13,10,'$'
LAST_BUS_NUM_MSG       DB 'Number of Last PCI bus : '
LAST_BUS_NUM_STR       DB '000',13,10,'$'

LIST_ITEM_MSG          DB 'Bus Dev Fnc VendorID DevID Rev',13,10,'$'
BUS_2ND_MSG            DB '  +$'
BUS_EQU_MSG            DB 'Bus = $'
DEV_EQU_MSG            DB '(d) Dev = $'
FNC_EQU_MSG            DB '(d) Fnc = $'
REG_EQU_MSG            DB '(d) Reg = '
HEX_MSG                DB '00(h)',13,10,'$'
ILLEGAL_SIZE_MSG       DB 'Illegal Write Data Size',13,10,'$'
MEM_BRK_MSG            DB 'Broken Memory Control Block',13,10,'$'
MEM_NOT_ENOUGH_MSG     DB 'Memory Not Enough',13,10,'$'
MsgNotExistPCIDevice   DB 'Not Exist PCI Device',13,10,'$'

msgCommandReg          DB 13,10,'Command Register',13,10,'$'
msgStatusReg           DB 13,10,'Status Register',13,10,'$'

$bitStr MACRO  bitMask,str
         LOCAL  STRING_LENGTH,STRING
STRING_LENGTH SIZESTR <&str>
STRING      CATSTR <">,<&str>,<">
            DD  bitMask
            DB  STRING_LENGTH
            DB  STRING
         ENDM

commandBitTable LABEL BYTE
  $bitStr <1 SHL 9>,<Fast Back-to-Back Enable>
  $bitStr <1 SHL 8>,<SERR# Enable>
  $bitStr <1 SHL 7>,<Wait Cycle Control>
  $bitStr <1 SHL 6>,<Parity Error Response>
  $bitStr <1 SHL 5>,<VGA Palette Snoop>
  $bitStr <1 SHL 4>,<Memory Write and Invalidate Enable>
  $bitStr <1 SHL 3>,<Special Cycles>
  $bitStr <1 SHL 2>,<Bus Master Enable>
  $bitStr <1 SHL 1>,<Memory Space Enable>
  $bitStr <1 SHL 0>,<I/O Space Enable>
  DD 0

statusBitTable LABEL BYTE
  $bitStr <1 SHL 15>,<Detected Parity Error>
  $bitStr <1 SHL 14>,<Signaled System Error>
  $bitStr <1 SHL 13>,<Received Master Abort>
  $bitStr <1 SHL 12>,<Received Target Abort>
  $bitStr <1 SHL 11>,<Signaled Target Abort>
  $bitStr <11b SHL 9>,<DEVSEL Timing ['00'-Fast/'01'-Medium/'10'-Slow]>
  $bitStr <1 SHL 8>,<Data Parity Error Detected>
  $bitStr <1 SHL 7>,<Fast Back-to-Back Capable>
  $bitStr <1 SHL 6>,<UDF Supported>
  $bitStr <1 SHL 5>,<66MHz Capable>
  $bitStr <1 SHL 4>,<New Capabilities>
  DD 0

msgNewFuncID      DB 13,10,'New function ID',13,10,'$'
msgNone           DB ' none',13,10,'$'
msgNewFuncUnknown DB ' Reserved/Unknown$'

$byteStr MACRO  funcID,str
         LOCAL  STRING_LENGTH,STRING
STRING_LENGTH SIZESTR <&str>
STRING      CATSTR <">,<&str>,<">
            DB  funcID
            DB  STRING_LENGTH
            DB  STRING
         ENDM

newFuncIDTable LABEL BYTE
  $byteStr 00h,<Reserved>
  $byteStr 01h,<PCI Power management>
  $byteStr 02h,<AGP Interface>
  $byteStr 03h,<Vital Product Data>
  $byteStr 04h,<PCI-PCI bridge slot identification>
  $byteStr 05h,<Message Signal Interrupt>
  $byteStr 06h,<CompactPCI HotSwap>
  DB 0


HIDDEN_DEVICE_MSG      DB '??Hidden??$'
UNKNOWN_VENDOR_MSG     DB '??Unknown Vendor??'
SIZE_UNKNOWN_VENDOR_MSG = $-UNKNOWN_VENDOR_MSG

VEND_TXT       DB    'VENDTBL.TXT',0
CHIP_TXT       DB    'CHIPTBL.TXT',0
CLASS_TXT      DB    'CLASTBL.TXT',0

REG_DUMP_INFO STRUC
REG_ADRS    DB    ?
REG_DISP    DW    ?
REG_STR_LEN DB    ?
REG_STR     DB    ?
REG_DUMP_INFO ENDS

$regStr MACRO index,dispRoutine,str
         LOCAL  STRING_LENGTH,STRING
STRING_LENGTH SIZESTR <&str>
STRING      CATSTR <'>,<&str>,<'>
            DB  index
            DW  dispRoutine
            DB  STRING_LENGTH
            DB  STRING
        ENDM

FIX_REG_TBL LABEL REG_DUMP_INFO
  $regStr 00H,DISP_WORD_VENDOR,<Vendor ID>
  $regStr 02H,DISP_WORD_DEVICE,<Device ID>
  $regStr 04H,DISP_WORD_BIT,<Command>
  $regStr 06H,DISP_WORD_BIT,<Status>
  $regStr 08H,DISP_BYTE,<Revision ID>
  $regStr 09H,DISP_BYTE_NoCRLF,<Program I/F>
  $regStr 0AH,DISP_BYTE,<Subclass Code>
  $regStr 0BH,DISP_BYTE_CLASS,<Base Class Code>
  $regStr 0CH,DISP_BYTE_NoCRLF,<Cache Line Size>
  $regStr 0DH,DISP_BYTE,<Latency Timer>
  $regStr 0EH,DISP_BYTE_NoCRLF,<Header Type>
  $regStr 0FH,DISP_BYTE,<BIST>
  DB 0

TYPE00_TBL LABEL REG_DUMP_INFO
  $regStr 10H,DISP_DWORD_NoCRLF,<Base Address Reg.0,1>
  $regStr 14H,DISP_DWORD,<>
  $regStr 18H,DISP_DWORD_NoCRLF,<Base Address Reg.2,3>
  $regStr 1CH,DISP_DWORD,<>
  $regStr 20H,DISP_DWORD_NoCRLF,<Base Address Reg.4,5>
  $regStr 24H,DISP_DWORD,<>
  $regStr 28H,DISP_DWORD,<CardBus CIS>
  $regStr 2CH,DISP_WORD_VENDOR,<SubSystem Vendor ID>
  $regStr 2EH,DISP_WORD_DEVICE,<SubSystem Device ID>
  $regStr 30H,DISP_DWORD_NoCRLF,<Expantion ROM Address>
  $regStr 34H,DISP_BYTE,<CAP_PTR>
  $regStr 35H,DISP_3BYTE_NoCRLF,<Reserved>
  $regStr 38H,DISP_DWORD,<>
  $regStr 3CH,DISP_BYTE_NoCRLF,<Interrupt Line>
  $regStr 3DH,DISP_BYTE,<Interrupt Pin>
  $regStr 3EH,DISP_BYTE_NoCRLF,<Minimum Grant>
  $regStr 3FH,DISP_BYTE,<Maximum Latency>
  DB 0

TYPE01_TBL LABEL REG_DUMP_INFO
  $regStr 10H,DISP_DWORD_NoCRLF,<Base Address Reg>
  $regStr 14H,DISP_DWORD,<>
  $regStr 18H,DISP_BYTE_NoCRLF,<Primary Bus Number>
  $regStr 19H,DISP_BYTE,<Secondary Bus Number>
  $regStr 1AH,DISP_BYTE_NoCRLF,<SubordinateBus Number>
  $regStr 1BH,DISP_BYTE,<SecondaryLatencyTimer>
  $regStr 1CH,DISP_BYTE_NoCRLF,<I/O Base>
  $regStr 1DH,DISP_BYTE,<I/O Limit>
  $regStr 1EH,DISP_WORD_BIT,<Secondary Status>
  $regStr 20H,DISP_IO_BASE_LIMIT,<Memory Base/Limit>
  $regStr 24H,DISP_IO_BASE_LIMIT,<Prefetchable Memory Base/Limit     >
  $regStr 28H,DISP_MEM_BASE_LIMIT,<Prefetchable Base/Limit Upper 32bit>
  $regStr 30H,DISP_IO_BASE_LIMIT,<I/O Base/Limit Upper 16bit         >
  $regStr 34H,DISP_BYTE_NoCRLF,<CAP_PTR>
  $regStr 35H,DISP_3BYTE,<Reserved>
  $regStr 38H,DISP_DWORD_NoCRLF,<Expantion ROM Address>
  $regStr 3CH,DISP_BYTE,<Interrupt Line>
  $regStr 3DH,DISP_BYTE_NoCRLF,<Interrupt Pin>
  $regStr 3EH,DISP_WORD,<Bridge Control>
  DB 0

TYPE02_TBL LABEL REG_DUMP_INFO
  $regStr 10H,DISP_DWORD,<PC Card-16/32 Control Registers Base Address>
  $regStr 14H,DISP_BYTE_NoCRLF,<CAP_PTR>
  $regStr 15H,DISP_3BYTE,<Reserved>
  $regStr 16H,DISP_WORD_BIT,<Secondary Status>
  $regStr 18H,DISP_BYTE_NoCRLF,<Primary Bus Number>
  $regStr 19H,DISP_BYTE,<Secondary Bus Number>
  $regStr 1AH,DISP_BYTE_NoCRLF,<SubordinateBus Number>
  $regStr 1BH,DISP_BYTE,<Reserved>
  $regStr 1CH,DISP_MEM_BASE_LIMIT,<1st Memory Window Base/Limit>
  $regStr 24H,DISP_MEM_BASE_LIMIT,<2nd Memory Window Base/Limit>
  $regStr 2CH,DISP_MEM_BASE_LIMIT,<1st I/O Window Base/Limit   >
  $regStr 34H,DISP_MEM_BASE_LIMIT,<2nd I/O Window Base/Limit   >
  $regStr 3CH,DISP_BYTE_NoCRLF,<Interrupt Line>
  $regStr 3DH,DISP_BYTE,<Interrupt Pin>
  $regStr 3EH,DISP_WORD,<Bridge Control>
  $regStr 40H,DISP_WORD_VENDOR,<SubSystem Vendor ID>
  $regStr 42H,DISP_WORD_DEVICE,<SubSystem Device ID>
  DB 0

HEX32_MSG      DB    4 DUP(?)
HEX16_MSG      DB    ?
DEC_MSG        DB    ?
HEX8_MSG       DB    2 DUP(?)
               DB    '$'

ARG_NUM        DB    0
BUS_NUM        DB    ?
DEV_NUM        DB    ?
FNC_NUM        DB    ?
REG_NUM        DB    ?
DAT_VAL        DD    ?
DAT_SIZE       DB    1
LAST_BUS_NUM   DB    ?
VENDOR_ID      DD    ?
CLASS_CODE     DD    ?
FLAG           DB    0
  @FORM_REG EQU 1 SHL 0
  @DUMP_REG EQU 1 SHL 1
  @ADV_REG  EQU 1 SHL 2
  @IN_KAKKO EQU 1 SHL 3
  @dumpByte EQU 1 SHL 4
  @dumpWord EQU 1 SHL 5
  @searchAll EQU 1 SHL 6
PATH_ADRS      DW    ?
INI_HANDLE     DW    ?
REDBUF_SEG     DW    0
RED_SIZE       DW    0
RED_POINT      DW    0
VENDOR_SEG     DW    0
VENDOR_SIZE    DW    0
CHIP_SEG       DW    0
CHIP_SIZE      DW    0
CLASS_SEG      DW    0
CLASS_SIZE     DW    0
PNP_HEAD_COPY  PNP_HEAD<>
NODE_SIZE      DW      ?
NODES          DW      ?
NODE_NUM       DW      ?
STR_BUFFER LABEL BYTE
NODE_BUFFER    DB      2048 DUP(?)
INI_NAME       DB    256 DUP(?)
               DB    0

STACK_TOP      DW    512 DUP (?)
STACK_BOTTOM LABEL WORD

CODE    ENDS
        END MAIN
