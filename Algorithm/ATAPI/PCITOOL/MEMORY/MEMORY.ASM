;use  TASM.EXE V2.01 or later
;
;      TASM /jSMART /jJUMPS /uM520 /jLOCALS /m8 /t
;
DATA SEGMENT AT 0
DATA ENDS

.586P
.MODEL  SMALL,PASCAL
CODE SEGMENT PARA PUBLIC 'CODE' USE16
     ASSUME  CS:CODE,DS:CODE,ES:CODE,SS:CODE

FILE_BUF_SIZE EQU 16384

        ORG     81H
CMDLIN  LABEL BYTE

        ORG    100H

MAIN PROC NEAR

    ASSUME  CS:CODE,DS:CODE,ES:CODE

;ｺﾏﾝﾄﾞﾗｲﾝ取得
;--------------------------
        CALL    GET_CMDLIN
        JC      @@USAGE
;ﾃﾝﾎﾟﾗﾘﾌｧｲﾙ名作成
;--------------------------
        .IF [FLAG] & @FILE
            CALL    SET_TMP_NAME
        .ENDIF

;動作環境チェック
;---------------------------
        ;ﾒﾓﾘ開放
        ;-----------------
        MOV     SP,OFFSET STACK_BOTTOM
        MOV     AH,4AH
        MOV     BX,OFFSET STACK_BOTTOM+15
        MOV     CL,4
        SHR     BX,CL
        INT     21H

        ;表示ﾓｰﾄﾞﾁｪｯｸ
        ;-------------------
        CALL    CHK_LANG

        ;CPU動作状態ﾁｪｯｸ
        ;-------------------
        CALL    CHK_CPU_MODE
        JC      ERROR_END

        CALL    GET_INT24
        JC      ERROR_END

;表示初期化
;---------------------------
        MOV     AX,0003H
        INT     10H

        MOV     AH,03H
        XOR     BH,BH
        INT     10H
        MOV     [CURSOR_SHAPE],CX

        OR      [FLAG],@UPDATE_CURSOR OR @UPDATE_ALL
        MOV     ESI,[EDIT_ADRS]
        MOV     [FILE_NAME],0
        MOV     [FILL_STR],0
        MOV     [SEARCH_STR],0
        MOV     [SEARCH_LEN],0
        MOV     [FillEndAdrsStr],0
        MOV     [SearchEndAdrsStr],0
        PUSH    DS
        MOV     DS,[DATA_SEL]
        OR      BYTE PTR DS:[417H],1 SHL 7
        POP     DS

;キー入力
;---------------------------
        XOR     DX,DX
        CALL    KEYIN

        CALL    CloseTmp
        CALL    FREE_INT24
;終了
;---------------------------
        MOV     AX,0003H
        INT     10H

        MOV     AX,4C00H
        INT     21H

@@USAGE:
        MOV     DX,OFFSET USAGE_MSG
        MOV     AH,9
        INT     21H
        MOV     AX,4CFFH
        INT     21H

ERROR_END:

        PUSH    DX
        CALL    CloseTmp
        CALL    FREE_INT24
        POP     DX
        MOV     AH,9
        INT     21H
        MOV     AX,4CFFH
        INT     21H

MAIN ENDP
;***************************
;キー入力
;
;       入力    ESI     アドレス
;       出力    なし
;       破壊    なし
;***************************
KEYIN PROC NEAR

    ASSUME  DS:CODE,ES:CODE

@@KEYIN_LOOP:

        CALL    REDISP_WINDOW

        MOV     AH,1
        INT     16H
        JNZ     @@KEYIN_OCCUR

        TEST    [FLAG],@POLLING
        JZ      @@NO_POLLING

        OR      [FLAG],@UPDATE
        JMP     @@KEYIN_LOOP

@@NO_POLLING:
@@KEYIN_OCCUR:
        MOV     AH,0
        INT     16H

        PUSH    OFFSET @@KEYIN_LOOP

        CMP     AX,5100H
        JE      PAGE_DOWN
        CMP     AX,4900H
        JE      PAGE_UP
        CMP     AX,7600H
        JE      PAGE_DOWN
        CMP     AX,8400H
        JE      PAGE_UP

        CMP     AX,4800H
        JE      UP
        CMP     AX,5000H
        JE      DOWN

        CMP     AX,4B00H
        JE      LEFT
        CMP     AX,4D00H
        JE      RIGHT
        CMP     AX,4700H
        JE      KEYIN_HOME
        CMP     AX,4F00H
        JE      KEYIN_END_KEY

        CMP     AX,7800H
        JE      KEYIN_BYTE
        CMP     AX,7900H
        JE      KEYIN_WORD
        CMP     AX,7B00H
        JE      KEYIN_DWORD
        CMP     AX,1600H
        JE      KEYIN_UPDATE_FILE
        CMP     AX,1900H
        JE      POLLING
        CMP     AX,1F00H
        JE      KEYIN_SEARCH
        CMP     AX,3100H
        JE      KEYIN_SEARCH_NEXT
        CMP     AX,2100H
        JE      KEYIN_FILL
        CMP     AX,1100H
        JE      KEYIN_FWRITE
        CMP     AX,2600H
        JE      KEYIN_FREAD
        CMP     AX,3200H
        JE      KEYIN_MORE

        CMP     AX,0F09H
        JE      KEYIN_TAB
        CMP     AX,0F00H
        JE      KEYIN_SHIFT_TAB
        CMP     AH,1CH
        JE      KEYIN_ENTER
        CMP     AH,01H
        JE      KEYIN_CANCEL
        CMP     AX,2D00H
        JNE     KEYIN_CHAR

@@KEYIN_END:
        CALL    UPDATE_MEM
        CALL    CHK_UPDATE_FILE
        POP     AX
        RET

KEYIN ENDP

;***************************
;文字直接入力
;***************************
KEYIN_CHAR PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CMP     [EDIT_MODE],@EDIT_CHAR
        JNE     @@HEX_VAL

        CALL    GET_CURSOR_POS
        MOV     BL,7
        MOV     CX,1
        CALL    DISP_CHAR
        JMP     @@VAL

;16進文字列入力
;----------------------------
@@HEX_VAL:
        CMP     AL,'0'
        JB      @@END
        CMP     AL,'9'
        JBE     @@DEC
        AND     AL,0DFH
        CMP     AL,'A'
        JB      @@END
        CMP     AL,'F'
        JBE     @@HEX
@@END:
        RET

;A-Fの入力
;-------------------
@@HEX:
        CALL    GET_CURSOR_POS
        MOV     BL,7
        MOV     CX,1
        CALL    DISP_CHAR
        SUB     AL,'A'-10
        JMP     @@VAL

;0-9の入力
;-------------------
@@DEC:
        CALL    GET_CURSOR_POS
        MOV     BL,7
        MOV     CX,1
        CALL    DISP_CHAR
        SUB     AL,'0'
@@VAL:
        MOV     DX,WORD PTR [CURSOR]
        CMP     [EDIT_MODE],@EDIT_ADRS
        JE      @@ADRS
        CALL    GET_OFFSET_FROM_CURSOR
        AND     [MEM_BUF+BX],AH
        OR      [MEM_BUF+BX],AL

        MOV     [EDIT_OFFSET],BX
        OR      [FLAG],@EDIT
        JMP     RIGHT

        ;ｱﾄﾞﾚｽ入力の場合
        ;-------------------------
@@ADRS:
        MOV     CL,DL
        XOR     CL,7
        SHL     CL,2
        MOVZX   EAX,AL
        MOV     EDX,0FFFFFFF0H
        SHL     EAX,CL
        ROL     EDX,CL
        AND     DWORD PTR [EDIT_ADRS],EDX
        OR      DWORD PTR [EDIT_ADRS],EAX
        JMP     RIGHT

KEYIN_CHAR ENDP
;**************************
;Shift+Tabｷｰ
;**************************
KEYIN_SHIFT_TAB PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CALL    UPDATE_MEM
        MOV     AL,[EDIT_MODE]
        MOV     AH,AL
        DEC     AL
        JNS     KEYIN_TAB_1
        MOV     AL,@EDIT_MAX
        JMP     KEYIN_TAB_1

KEYIN_SHIFT_TAB ENDP
;**************************
;Tabｷｰ
;**************************
KEYIN_TAB PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CMP     [EDIT_MODE],@EDIT_ADRS
        JE      @@ENTER_ADRS

        CALL    UPDATE_MEM
        OR      [FLAG],@UPDATE
        JMP	_KEYIN_TAB

@@ENTER_ADRS:
        MOV     ESI,DWORD PTR [EDIT_ADRS]
        OR      [FLAG],@UPDATE OR @UPDATE_ADRS OR @UPDATE_CURSOR
        XOR     DX,DX
_KEYIN_TAB:
        MOV     AL,[EDIT_MODE]
        MOV     AH,AL
        INC     AL
        CMP     AL,@EDIT_MAX
        JBE     KEYIN_TAB_1
        XOR     AL,AL
KEYIN_TAB_1:
        MOV     DX,WORD PTR [CURSOR]
        OR      [FLAG],@UPDATE_CURSOR
        MOV     [EDIT_MODE],AL
        CMP     AL,@EDIT_ADRS
        JE      @@ADRS

        CMP     AH,@EDIT_ADRS
        JNE     @@RET

    ;16進入力に切り替える
    ;-------------------
        MOV     DX,[CURSOR_BAK]
        RET

    ;ｱﾄﾞﾚｽ入力に切り替える
    ;-------------------
@@ADRS:
        MOV     [EDIT_OFFSET],0
        MOV     DWORD PTR [EDIT_ADRS],ESI
        MOV     [CURSOR_BAK],DX
        XOR     DX,DX
@@RET:
        RET

KEYIN_TAB ENDP


;**************************
;Homeｷｰ
;**************************
KEYIN_HOME PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CALL    UPDATE_MEM
        MOV     DX,WORD PTR [CURSOR]
        TEST    DL,DL
        JZ      @@ROW
        XOR     DL,DL
        JMP     @@UPDATE

@@ROW:
        CMP     [EDIT_MODE],@EDIT_ADRS
        JE      @@END

        TEST    DH,DH
        JZ      @@END
        XOR     DH,DH
@@UPDATE:
        OR      [FLAG],@UPDATE_CURSOR
@@END:
        RET

KEYIN_HOME ENDP

;**************************
;Endｷｰ
;**************************
KEYIN_END_KEY PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CALL    UPDATE_MEM
        MOV     DX,WORD PTR [CURSOR]

        CMP     [EDIT_MODE],@EDIT_ADRS
        JE      @@ADRS

        CMP     DL,31
        JE      @@ROW
        MOV     DL,31
        JMP     @@UPDATE

@@ROW:
        CMP     DH,15
        JE      @@END
        MOV     DH,15
        JMP     @@UPDATE

@@ADRS:
        CMP     DL,7
        JE      @@END
        MOV     DL,7
@@UPDATE:
        OR      [FLAG],@UPDATE_CURSOR
@@END:
        RET

KEYIN_END_KEY ENDP

;***************************
;入力確定
;***************************
KEYIN_ENTER PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CMP     [EDIT_MODE],@EDIT_ADRS
        JE      @@ADRS

        CALL    UPDATE_MEM
        OR      [FLAG],@UPDATE
        RET

@@ADRS:
        MOV     ESI,DWORD PTR [EDIT_ADRS]
        OR      [FLAG],@UPDATE OR @UPDATE_ADRS OR @UPDATE_CURSOR
        JMP     _KEYIN_TAB
;        XOR     DX,DX
;        RET

KEYIN_ENTER ENDP

;***************************
;入力拒否
;***************************
KEYIN_CANCEL PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CMP     [EDIT_MODE],@EDIT_ADRS
        JE      @@ADRS

        AND     [FLAG],NOT @EDIT
        OR      [FLAG],@UPDATE
        RET

@@ADRS:
        OR      [FLAG],@UPDATE_ADRS OR @UPDATE_CURSOR
        XOR     DX,DX
        RET

KEYIN_CANCEL ENDP


;**************************
;カーソル上
;**************************
UP PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CALL    UPDATE_MEM
        MOV     DX,WORD PTR [CURSOR]
        CMP     [EDIT_MODE],@EDIT_ADRS
        JNE     UP_1LINE
        MOV     ESI,DWORD PTR [EDIT_ADRS]
        SUB     ESI,10H
        MOV     DWORD PTR [EDIT_ADRS],ESI
        JMP     @@UPDATE

UP_1LINE:
        OR      [FLAG],@UPDATE_CURSOR
        DEC     DH
        JNS     @@END
        SUB     ESI,10H
        XOR     DH,DH
@@UPDATE:
        OR      [FLAG],@UPDATE OR @UPDATE_ADRS
@@END:
        RET

UP ENDP
;**************************
;カーソル下
;**************************
DOWN PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CALL    UPDATE_MEM
        MOV     DX,WORD PTR [CURSOR]

        CMP     [EDIT_MODE],@EDIT_ADRS
        JNE     DOWN_1LINE
        MOV     ESI,DWORD PTR [EDIT_ADRS]
        ADD     ESI,10H
        MOV     DWORD PTR [EDIT_ADRS],ESI
        JMP     @@UPDATE

DOWN_1LINE:
        OR      [FLAG],@UPDATE_CURSOR
        INC     DH
        CMP     DH,16
        JB      @@END
        ADD     ESI,10H
        MOV     DH,15
@@UPDATE:
        OR      [FLAG],@UPDATE OR @UPDATE_ADRS
@@END:
        RET

DOWN ENDP
;**************************
;カーソル左
;**************************
LEFT PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CMP     [EDIT_MODE],@EDIT_ADRS
        JE      @@ADRS

        CALL    GET_DATA_MASK
        TEST    [CURSOR],AL
        JNZ     @@1
        CALL    UPDATE_MEM
@@1:
        MOV     DX,WORD PTR [CURSOR]
        CMP     [EDIT_MODE],@EDIT_CHAR
        JNE     @@2
        DEC     DL
@@2:
        OR      [FLAG],@UPDATE_CURSOR
        DEC     DL
        JNS     @@END
        AND     DL,31
        JMP     UP_1LINE

@@ADRS:
        MOV     DX,WORD PTR [CURSOR]
        DEC     DL
        AND     DL,7
        OR      [FLAG],@UPDATE_CURSOR
@@END:
        RET

LEFT ENDP
;**************************
;カーソル右
;**************************
RIGHT PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CMP     [EDIT_MODE],@EDIT_ADRS
        JE      @@ADRS

        CALL    GET_DATA_MASK
        MOV     AH,AL
        AND     AL,[CURSOR]
        CMP     AH,AL
        JNE     @@1
        CALL    UPDATE_MEM
@@1:
        MOV     DX,WORD PTR [CURSOR]
        CMP     [EDIT_MODE],@EDIT_CHAR
        JNE     @@2
        INC     DL
@@2:
        OR      [FLAG],@UPDATE_CURSOR
        INC     DL
        CMP     DL,32
        JB      @@END
        AND     DL,31
        JMP     DOWN_1LINE

@@ADRS:
        MOV     DX,WORD PTR [CURSOR]
        INC     DL
        AND     DL,7
        OR      [FLAG],@UPDATE_CURSOR
@@END:
        RET

RIGHT ENDP
;**************************
;ページ下
;**************************
PAGE_DOWN PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CALL    UPDATE_MEM

        MOV     EDX,1

PAGE_CHG:
        CMP     [EDIT_MODE],@EDIT_ADRS
        JNE     @@1
        MOV     ESI,DWORD PTR [EDIT_ADRS]
@@1:
        PUSH    DS
        MOV     DS,[DATA_SEL]
        MOV     AL,DS:[417H]
        POP     DS
        MOV     CL,0
        TEST    AL,11B
        JZ      @@NO_SHIFT
        OR      CL,1
@@NO_SHIFT:
        TEST    AL,100B
        JZ      @@NO_CTRL
        OR      CL,2
@@NO_CTRL:
        SHL     CL,2
        ADD     CL,8
        SHL     EDX,CL
        ADD     ESI,EDX

        MOV     DWORD PTR [EDIT_ADRS],ESI
        OR      [FLAG],@UPDATE OR @UPDATE_ADRS
        RET

PAGE_DOWN ENDP
;**************************
;ページ上
;**************************
PAGE_UP PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CALL    UPDATE_MEM
        MOV     EDX,-1
        JMP     PAGE_CHG

PAGE_UP ENDP
;**************************
;バイト表示切り替え
;**************************
KEYIN_BYTE PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     AL,@DAT_BYTE
        JMP     KEYIN_CHG_SIZE

KEYIN_BYTE ENDP
;**************************
;ワード表示切り替え
;**************************
KEYIN_WORD PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     AL,@DAT_WORD
        JMP     KEYIN_CHG_SIZE

KEYIN_WORD ENDP
;**************************
;ダブルワード表示切り替え
;**************************
KEYIN_DWORD PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     AL,@DAT_DWORD
KEYIN_CHG_SIZE:
        CMP     [DAT_SIZE],AL
        JE      @@END
        MOV     [DAT_SIZE],AL
        CALL    UPDATE_MEM
        OR      [FLAG],@UPDATE
        CALL    CLEAR_DUMP_AREA
@@END:
        RET

KEYIN_DWORD ENDP
;**************************
;ポーリング切り替え
;**************************
POLLING PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        XOR     [FLAG],@POLLING
        RET

POLLING ENDP
;**************************
;使い方表示ﾍﾟｰｼﾞ切り替え
;**************************
KEYIN_MORE PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     AL,[INFO_PAGE]
        INC     AX
        AND     AL,1
        MOV     [INFO_PAGE],AL
        OR      [FLAG],@UPDATE_ALL
        RET

KEYIN_MORE ENDP

;**************************
;  編集ﾌｧｲﾙの内容を書き出す
;
;   入力
;   出力
;**************************
KEYIN_UPDATE_FILE PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        .IF [FLAG] & @FILE
            PUSH    ESI
            CALL    UPDATE_FILE
            POP     ESI
            AND     [FLAG],NOT @EDITED
        .ENDIF
        RET

KEYIN_UPDATE_FILE ENDP

;**************************
;  下部Windowの項目入力処理
;
;   入力
;   出力
;**************************
ItemInfo STRUC

ItemPosX   DB  ?   ;表示開始位置
ItemPosY   DB  ?   ;表示開始位置
ItemMsg    DW  ?   ;表示ﾒｯｾｰｼﾞｱﾄﾞﾚｽ
ItemCreate DW  ?   ;初期化処理
ItemEnter  DW  ?   ;入力処理
ItemExit   DW  ?   ;終了処理

ItemInfo ENDS

ControlItem PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CALL    UPDATE_MEM
        MOV     DWORD PTR [EDIT_ADRS],ESI

;各項目初期化
;----------------------
        MOV     SI,[ENTER_INFO]
        .WHILE WORD PTR [SI].ItemPosX!=-1
            MOV     AX,[SI].ItemCreate
            .IF AX & AX
                PUSH    SI
                CALL    AX
                POP     SI
            .ENDIF
            ADD     SI,SIZE ItemInfo
        .ENDW

        MOV     SI,[ENTER_INFO]
        .WHILE 1
            .BREAK .IF [SI].ItemEnter!=0
            ADD     SI,SIZE ItemInfo
        .ENDW
        MOV     [CurItem],SI

;各項目表示
;----------------------
@@REDISP_ITEMS:
        CALL    GET_LANG_WAKU
        MOV     BL,7
        CALL    DISP_UNDER_WINDOW
        MOV     SI,[ENTER_INFO]
        .WHILE 1
            MOV     DX,WORD PTR [SI].ItemPosX
            .BREAK .IF DX == -1
            MOV     DI,[SI].ItemMsg
            .IF DI & DI
                PUSH    SI
                CALL    DISP_MSG
                POP     SI
            .ENDIF
            ADD     SI,SIZE ItemInfo
        .ENDW

;各項目の入力処理
;--------------------------
@@INPUT_ITEMS:
        MOV     BL,7
        PUSH    OFFSET @@CHK_RESULT
        MOV     SI,[CurItem]
        JMP     [SI].ItemEnter

@@CHK_RESULT:
        CMP     AL,1BH
        JE      @@Cancel
        CMP     AH,1CH
        JE      @@Enter
        CMP     AX,0F09H
        JE      @@Tab
        CMP     AX,5000H
        JE      @@Tab
        CMP     AX,0F00H
        JE      @@ShiftTab
        CMP     AX,4800H
        JE      @@ShiftTab
        JMP     @@INPUT_ITEMS

@@Tab:
        MOV     SI,[CurItem]
        .REPEAT
            ADD     SI,SIZE ItemInfo
            .IF WORD PTR [SI].ItemPosX==-1
                MOV     SI,[ENTER_INFO]
            .ENDIF
        .UNTIL [SI].ItemEnter!=0
        MOV     [CurItem],SI
        JMP     @@INPUT_ITEMS

@@ShiftTab:
        MOV     SI,[CurItem]
        .REPEAT
            SUB     SI,SIZE ItemInfo
            .IF SI < [ENTER_INFO]
                MOV     SI,[ENTER_INFO]
                .REPEAT
                     ADD     SI,SIZE ItemInfo
                .UNTIL WORD PTR [SI].ItemPosX==-1
                SUB     SI,SIZE ItemInfo
            .ENDIF
        .UNTIL [SI].ItemEnter!=0
        MOV     [CurItem],SI
        JMP     @@INPUT_ITEMS

@@Enter:
;各項目終了処理
;----------------------
        CALL    SET_CURSOR_HOME
        MOV     SI,[ENTER_INFO]
        .WHILE WORD PTR [SI].ItemPosX!=-1
            MOV     AX,[SI].ItemExit
            .IF AX & AX
                PUSH    SI
                CALL    AX
                POP     SI
                .IF CARRY?
                    JMP     @@REDISP_ITEMS
                .ENDIF
            .ENDIF
            ADD     SI,SIZE ItemInfo
        .ENDW

;終了処理
;-------------------------
@@Cancel:
        CALL    GET_LANG_WAKU
        MOV     BL,7
        CALL    DISP_UNDER_WINDOW
        CALL    DISP_UNDER_MSG_EDIT

        MOV     ESI,DWORD PTR [EDIT_ADRS]
        MOV     DX,WORD PTR [CURSOR]
        OR      [FLAG],@UPDATE_CURSOR OR @UPDATE_ALL
        RET

ControlItem ENDP
;**************************
;  指定位置にﾌｧｲﾙ読み込み
;
;   入力
;   出力
;**************************
FREAD_INFO LABEL BYTE
          ItemInfo< 1,20,FREAD_MSG1,0,0,0>
          ItemInfo< 1,21,FREAD_MSG2,0,0,0>
          ItemInfo< 1,23,FREAD_MSG4,0,0,0>
RNameItem ItemInfo<18,20,FILE_NAME     ,0          ,EnterName,ExitIfExistString>
          ItemInfo<18,21,START_ADRS_STR,InitCurAdrs,EnterAdrs,ExitIfExistString>
          ItemInfo<29,21,END_ADRS_STR  ,InitNull   ,EnterAdrs,ExitStoreFileSize>
          ItemInfo<33,22,0,0,0,ExitFRead>
          DW      -1

KEYIN_FREAD PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     [ENTER_INFO],OFFSET FREAD_INFO
        JMP     ControlItem

EnterAdrs:
        MOV     [ENTER_MODE],@ENTER_HEX
        MOV     [ENTER_LEN],8
        JMP     @@ENTER_SUB
EnterName:
        MOV     [ENTER_MODE],@ENTER_STR
        MOV     [ENTER_LEN],48
@@ENTER_SUB:
        MOV     DX,WORD PTR [SI].ItemPosX
        MOV     SI,[SI].ItemMsg
        JMP     ENTER_1LINE

ExitIfExistString:
        MOV     BX,[SI].ItemMsg
        .IF BYTE PTR [BX]==0
            MOV     [CurItem],SI
            STC
            RET
        .ENDIF
        CLC
        RET

ExitStoreFileSize:
        MOV     DX,OFFSET FILE_NAME
        CALL    _ExitEndAdrs
        .IF CARRY?
            .IF AX==-2
                MOV     [CurItem],OFFSET RNameItem
            .ENDIF
            STC
        .ENDIF
        RET

_ExitEndAdrs:
        CALL    ExitIfExistString
        .IF CARRY?
            MOV     [CurItem],SI
            CALL    SET_CURSOR_HOME
            ;ﾌｧｲﾙｻｲｽﾞ取得
            ;-----------------------------
            MOV     AX,3D00H
            INT     21H
            .IF !CARRY?
                MOV     BX,AX
                XOR     CX,CX
                XOR     DX,DX
                MOV     AX,4202H
                INT     21H
                PUSH    DX
                PUSH    AX
                MOV     AH,3EH
                INT     21H

                ;最終ｱﾄﾞﾚｽ計算
                ;-------------------------------
                MOV     SI,OFFSET START_ADRS_STR
                MOV     CX,8
                CALL    GET_HEX_VALUE
                POP     EDX
                SUB     EDX,1
                .IF !CARRY?
                    ADD     EAX,EDX
                .ENDIF
                MOV     SI,[CurItem]
                MOV     SI,[SI].ItemMsg
                CALL    IntToStr32
                MOV     AX,-1
                STC
            .ELSE
                MOV     DI,OFFSET FileNotFoundMsg
                CALL    DISP_ERROR_WINDOW
                MOV     AX,-2
            .ENDIF
        .ENDIF
        RET

KEYIN_FREAD ENDP

;**************************
;開始ｱﾄﾞﾚｽ初期化
;
;   入力
;   出力
;**************************
InitCurAdrs PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     DX,WORD PTR [CURSOR]
        CALL    GET_OFFSET_FROM_CURSOR
        MOVZX   EAX,BX
        CMP     [DAT_SIZE],@DAT_WORD
        .IF !CARRY?
            .IF !ZERO?
                AND     AL,NOT 11B
            .ENDIF
            AND     AL,NOT 01B
        .ENDIF
        ADD     EAX,[EDIT_ADRS]
        MOV     SI,[SI].ItemMsg
        JMP     IntToStr32

InitCurAdrs ENDP

;**************************
;終了ｱﾄﾞﾚｽ初期化
;
;   入力
;   出力
;**************************
InitNull PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     SI,[SI].ItemMsg
        MOV     BYTE PTR [SI],0
        RET

InitNull ENDP

;**************************
;範囲指定の文字列を16進に変換
;
;   入力
;   出力   CY     1)領域開始ｱﾄﾞﾚｽが終了ｱﾄﾞﾚｽより大きい
;**************************
ReadAccessRange PROC USES DX,@StartStr:WORD,@EndStr:WORD

    ASSUME  DS:CODE,ES:CODE

        MOV     SI,[@StartStr]
        MOV     CX,8
        CALL    GET_HEX_VALUE
        MOV     [ACCESS_AREA],EAX

        MOV     SI,[@EndStr]
        MOV     CX,8
        CALL    GET_HEX_VALUE
        MOV     [ACCESS_AREA+4],EAX
        CMP     EAX,[ACCESS_AREA]
        RET

ReadAccessRange ENDP
;**************************
;ﾌｧｲﾙ読み込み
;
;   入力
;   出力
;**************************
ExitFRead PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        ;読み込み領域設定
        ;----------------------
        CALL    ReadAccessRange PASCAL,OFFSET START_ADRS_STR,OFFSET END_ADRS_STR
        JC      ErrorRange

        MOV     BL,0F0H
        MOV     DX,WORD PTR [SI].ItemPosX
        MOV     DI,OFFSET ReadingFileMsg
        CALL    DISP_MSG

        ;Open
        ;------------------
        MOV     DX,OFFSET FILE_NAME
        MOV     AX,3D00H
        INT     21H
        JC      @@FileNotFound
        MOV     BX,AX

        ;Read
        ;------------------
        MOV     ESI,[ACCESS_AREA]
        MOV     ECX,[ACCESS_AREA+4]
        SUB     ECX,ESI
        INC     ECX    ;ECX=0の場合、4GBとして扱う
        .REPEAT
            MOV     DX,OFFSET FILE_BUF
            PUSH    ECX
            .IF !(ECX & ECX) || (ECX > FILE_BUF_SIZE)
                MOV     ECX,FILE_BUF_SIZE
            .ENDIF
            MOV     AH,3FH
            INT     21H
            AND     EAX,0FFFFH
            JZ      @@End
            MOV     ECX,EAX
            XOR     EDI,EDI
            MOV     DI,OFFSET FILE_BUF
            CALL    PUT_MEM
            POP     ECX
            ADD     ESI,EAX
            SUB     ECX,EAX
        .UNTIL ZERO?
        PUSH    ECX

        ;Close
        ;------------------
@@End:
        POP     ECX
        MOV     AH,3EH
        INT     21H
        CLC
        RET

@@FileNotFound:
        MOV     [CurItem],OFFSET RNameItem
        MOV     DI,OFFSET FileNotFoundMsg
        JMP     DISP_ERROR_WINDOW

ErrorRange:
        MOV     DI,OFFSET ErrorRangeMsg
        XOR     DX,DX
        JMP     DISP_ERROR_WINDOW

ExitfRead ENDP
;**************************
;  指定領域をﾌｧｲﾙに書き出す
;
;   入力
;   出力
;**************************
FWRITE_INFO LABEL BYTE

          ItemInfo< 1,20,FWRITE_MSG1,0,0,0>
          ItemInfo< 1,21,FWRITE_MSG2,0,0,0>
          ItemInfo< 1,23,FWRITE_MSG4,0,0,0>
WNameItem ItemInfo<19,20,FILE_NAME     ,0          ,EnterName,ExitIfExistString>
          ItemInfo<19,21,START_ADRS_STR,InitCurAdrs,EnterAdrs,ExitIfExistString>
          ItemInfo<30,21,END_ADRS_STR  ,InitNull   ,EnterAdrs,ExitIfExistString>
          ItemInfo<32,22,0,0,0,ExitFWrite>
          DW      -1

KEYIN_FWRITE PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     [ENTER_INFO],OFFSET FWRITE_INFO
        JMP     ControlItem

KEYIN_FWRITE ENDP
;**************************
;ﾌｧｲﾙ書き込み
;
;   入力
;   出力
;**************************
ExitFWrite PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     DX,OFFSET FILE_NAME
        CALL    ExitFWriteSub
        .IF CARRY?
            MOV     [CurItem],OFFSET WNameItem
        .ENDIF
        RET

ExitFWriteSub:

    ASSUME  DS:CODE,ES:CODE

;読み込み領域設定
;----------------------
        CALL    ReadAccessRange PASCAL,OFFSET START_ADRS_STR,OFFSET END_ADRS_STR
        JC      ErrorRange

        PUSH    DX
        MOV     BL,0F0H
        MOV     DX,WORD PTR [SI].ItemPosX
        MOV     DI,OFFSET WritingFileMsg
        CALL    DISP_MSG

;ﾌｧｲﾙ書き込み
;--------------------------
        ;Create
        ;------------------
        POP     DX
        MOV     AH,3CH
        MOV     CX,0
        INT     21H
        JC      @@CantCreateFile
        MOV     BX,AX

        ;Write
        ;-------------------
        MOV     ESI,[ACCESS_AREA]
        MOV     ECX,[ACCESS_AREA+4]
        SUB     ECX,ESI
        INC     ECX    ;ECX=0の場合、4GBとして扱う
        .REPEAT
            PUSH    ECX
            .IF !(ECX & ECX) || (ECX > FILE_BUF_SIZE)
                MOV     ECX,FILE_BUF_SIZE
            .ENDIF
            XOR     EDI,EDI
            MOV     DI,OFFSET FILE_BUF
            CALL    GET_MEM

            MOV     DX,OFFSET FILE_BUF
            MOV     AH,40H
            INT     21H
            CMP     AX,CX
            POP     ECX
            JNE     @@CantWriteFile

            MOVZX   EAX,AX
            ADD     ESI,EAX
            SUB     ECX,EAX
        .UNTIL ZERO?
@@END:
        MOV     AH,3EH
        INT     21H
        CLC
        RET

@@CantCreateFile:

        MOV     DI,OFFSET CantCreateFileMsg
        JMP     DISP_ERROR_WINDOW

@@CantWriteFile:

        MOV     AH,3EH
        INT     21H
        MOV     DX,OFFSET FILE_NAME
        MOV     DI,OFFSET CantWriteFileMsg
        JMP     DISP_ERROR_WINDOW

ExitFWrite ENDP
;**************************
;  ﾌｧｲﾙ更新されていたら、ﾌｧｲﾙに書き出すか問う
;
;  入力    なし
;  出力    なし
;  破壊
;**************************
FUPDATE_INFO LABEL BYTE

          ItemInfo< 1,20,FSAVE_MSG1,0,0,0>
          ItemInfo< 1,21,FSAVE_MSG2,0,0,0>
          ItemInfo< 1,23,FSAVE_MSG4,0,0,0>
UNameItem ItemInfo<18,20,EDIT_FILE_NAME,0               ,EnterName,ExitIfExistString>
          ItemInfo<18,21,START_ADRS_STR,InitAdrs00000000,EnterAdrs,ExitIfExistString>
          ItemInfo<29,21,END_ADRS_STR  ,InitMaxAdrs     ,EnterAdrs,ExitIfExistString>
          ItemInfo<32,22,0,0,0,ExitUpdateFile>
          DW      -1

CHK_UPDATE_FILE PROC NEAR

    ASSUME  DS:CODE,ES:CODE

;変更内容がﾌｧｲﾙに書き出されていない場合、書き出すか聞く
;-----------------------
        .IF ([FLAG] & @FILE) && ([FLAG] & @EDITED)
UPDATE_FILE:
            MOV     [ENTER_INFO],OFFSET FUPDATE_INFO
            CALL    ControlItem
        .ENDIF
        RET

CHK_UPDATE_FILE ENDP

;**************************
;編集ファイル更新
;
;   入力
;   出力
;**************************
ExitUpdateFile PROC NEAR

    ASSUME  DS:CODE,ES:CODE

;編集ﾌｧｲﾙのﾊﾞｯｸｱｯﾌﾟ作成
;------------------------
        PUSH    SI
        CALL    MAKE_BACKUP_FILENAME
        MOV     SI,OFFSET EDIT_FILE_NAME
        MOV     DI,OFFSET BACK_FILE_NAME
        CALL    COPY_FILE
        .IF DI & DI
            .IF DI != OFFSET FileNotFoundMsg
                 POP     SI
                 JMP     DISP_ERROR_WINDOW
            .ENDIF
        .ENDIF
;ﾃﾝﾎﾟﾗﾘﾌｧｲﾙの内容を編集ﾌｧｲﾙにｺﾋﾟｰする
;------------------------
        POP     SI
        MOV     DX,OFFSET EDIT_FILE_NAME
        CALL    ExitFWriteSub
        .IF CARRY?
            MOV     [CurItem],OFFSET UNameItem
        .ENDIF
        RET

ExitUpdateFile ENDP
;**************************
;  ﾌｧｲﾙｺﾋﾟｰ
;
;   入力  SI   ｺﾋﾟｰ元ﾌｧｲﾙ名
;         DI   ｺﾋﾟｰ先ﾌｧｲﾙ名
;   出力  DI   0)正常終了
;              0以外)ｴﾗｰﾒｯｾｰｼﾞｱﾄﾞﾚｽ
;**************************
COPY_FILE PROC NEAR

    ASSUME  DS:CODE,ES:CODE

;ｺﾋﾟｰ元ﾌｧｲﾙｵｰﾌﾟﾝ
;-----------------------
        MOV     DX,SI
        MOV     AX,3D40H
        INT     21H
        JNC     @@FromOpen

        MOV     DI,OFFSET FileNotFoundMsg
        CMP     AX,2
        JE      @@EndCopy
        MOV     DI,OFFSET CantOpenFileMsg
        JMP     @@EndCopy
@@FromOpen:
        MOV     [FROM_HANDLE],AX
;ｺﾋﾟｰ先ﾌｧｲﾙｵｰﾌﾟﾝ
;-----------------------
        MOV     DX,DI
        XOR     CX,CX
        MOV     AH,3CH
        INT     21H
        MOV     DI,OFFSET CantCreateFileMsg
        JC      @@EndCopy2
        MOV     [TO_HANDLE],AX

;ｺﾋﾟｰ
;-------------------------
@@CopyLoop:
        MOV     AH,3FH
        MOV     BX,[FROM_HANDLE]
        MOV     CX,FILE_BUF_SIZE
        MOV     DX,OFFSET FILE_BUF
        INT     21H
        TEST    AX,AX
        JZ      @@FileClose

        MOV     DX,OFFSET FILE_BUF
        MOV     CX,AX
        MOV     BX,[TO_HANDLE]
        MOV     AH,40H
        INT     21H
        CMP     AX,CX
        JE      @@CopyLoop

        MOV     DX,DI
        MOV     DI,OFFSET CantWriteFileMsg
        JMP     @@EndCopy3

@@FileClose:

        XOR     DI,DI

@@EndCopy3:

        PUSH    DX
        MOV     BX,[FROM_HANDLE]
        MOV     AX,5700H
        INT     21H
        MOV     BX,[TO_HANDLE]
        MOV     AX,5701H
        INT     21H
        POP     DX

        MOV     AH,3EH
        MOV     BX,[TO_HANDLE]
        INT     21H
@@EndCopy2:
        MOV     AH,3EH
        MOV     BX,[FROM_HANDLE]
        INT     21H
@@EndCopy:
        RET

COPY_FILE ENDP
;**************************
;開始ｱﾄﾞﾚｽ初期化
;
;   入力
;   出力
;**************************
InitAdrs00000000 PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     SI,[SI].ItemMsg
        XOR     EAX,EAX
        JMP     IntToStr32

InitAdrs00000000 ENDP
;**************************
;終了ｱﾄﾞﾚｽ初期化
;
;   入力
;   出力
;**************************
InitMaxAdrs PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        .IF [FLAG] & @FILE
            ;編集中のﾌｧｲﾙｻｲｽﾞ取得
            ;---------------------------
            MOV     BX,[EDIT_HANDLE]
            XOR     CX,CX
            XOR     DX,DX
            MOV     AX,4202H
            INT     21H
            PUSH    DX
            PUSH    AX
            POP     EAX
            SUB     EAX,1
            .IF CARRY?
                INC     EAX
            .ENDIF
        .ELSE
            MOV     EAX,-1
        .ENDIF
        MOV     SI,[SI].ItemMsg
        JMP     IntToStr32

InitMaxAdrs ENDP

;**************************
;  指定領域を指定ﾊﾟﾀｰﾝで埋める
;
;   入力
;   出力
;**************************
FILL_INFO LABEL BYTE
          ItemInfo< 1,20,FILL_MSG1,0,0,0>
          ItemInfo< 1,21,FILL_MSG2,0,0,0>
          ItemInfo< 1,23,FILL_MSG4,0,0,0>
          ItemInfo<27,20,FILL_STR      ,0          ,EnterName,ExitFillString>
          ItemInfo<13,21,START_ADRS_STR,InitCurAdrs,EnterAdrs,ExitIfExistString>
          ItemInfo<24,21,FillEndAdrsStr,0          ,EnterAdrs,ExitIfExistString>
          ItemInfo<32,22,0,0,0,ExitFill>
          DW      -1

KEYIN_FILL PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     [ENTER_INFO],OFFSET FILL_INFO
        JMP     ControlItem

ExitFillString:

    ASSUME  DS:CODE,ES:CODE

        MOV     DI,OFFSET FILL_VAL
_ExitFillStr:
        CALL    ExitIfExistString
        .IF !CARRY?
            PUSH    SI
            MOV     SI,[SI].ItemMsg
            CALL    ConvHexStrings
            POP     SI
            .IF CARRY?
                MOV     [CurItem],SI
            .ENDIF
        .ENDIF
        RET

ExitFill:

    ASSUME  DS:CODE,ES:CODE

        CALL    ReadAccessRange PASCAL,OFFSET START_ADRS_STR,OFFSET FillEndAdrsStr
        JC      ErrorRange

;FillするﾃﾞｰﾀをFILE_BUFにまとめて作成
;--------------------------
        MOV     DI,OFFSET FILE_BUF
        MOV     AX,FILE_BUF_SIZE
        CLD
        .REPEAT
            MOV     CX,[FILL_VAL]
            SUB     AX,CX
            MOV     SI,OFFSET FILL_VAL+2
            REP     MOVSB
        .UNTIL AX < [FILL_VAL]
        MOV    EDX,FILE_BUF_SIZE
        SUB    DX,AX             ;DX=一度に書き込める最大のFillﾃﾞｰﾀﾊﾞｲﾄ数

;Fillﾃﾞｰﾀ書き込み
;--------------------------
        MOV     ECX,[ACCESS_AREA+4]
        SUB     ECX,[ACCESS_AREA]
        INC     ECX              ;ECX=0の場合4GBとして扱う
        XOR     EDI,EDI
        MOV     DI,OFFSET FILE_BUF
        MOV     ESI,[ACCESS_AREA]
        .REPEAT
            PUSH    ECX
            .IF !(ECX & ECX) || (ECX > EDX)
                MOV     ECX,EDX
            .ENDIF
            PUSH    EDX
            CALL    PUT_MEM
            POP     EDX
            ADD     ESI,ECX
            MOV     EAX,ECX
            POP     ECX
            SUB     ECX,EAX
        .UNTIL ZERO?
        CLC
        RET

KEYIN_FILL ENDP
;**************************
;  指定領域内に指定ﾊﾟﾀｰﾝがあるか検索する
;
;   入力
;   出力
;**************************
SEARCH_INFO LABEL BYTE
          ItemInfo< 1,20,SEARCH_MSG1,0,0,0>
          ItemInfo< 1,21,SEARCH_MSG2,0,0,0>
          ItemInfo< 1,23,SEARCH_MSG4,0,0,0>
SNameItem ItemInfo<29,20,SEARCH_STR    ,0                  ,EnterName,ExitSearchString>
          ItemInfo<15,21,START_ADRS_STR  ,InitCurAdrs      ,EnterAdrs,ExitIfExistString>
          ItemInfo<26,21,SearchEndAdrsStr,ExitEndAdrsSearch,EnterAdrs,ExitEndAdrsSearch>
          ItemInfo<32,22,0,0,0,ExitSearch>
          DW      -1

KEYIN_SEARCH PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     [ENTER_INFO],OFFSET SEARCH_INFO
        JMP     ControlItem

ExitSearchString:

    ASSUME  DS:CODE,ES:CODE

        MOV     DI,OFFSET SEARCH_VAL
        JMP     _ExitFillStr

ExitEndAdrsSearch:

    ASSUME  DS:CODE,ES:CODE

        CALL    ExitIfExistString
        .IF CARRY?
            CALL    InitMaxAdrs
            STC
        .ENDIF
        RET

ExitSearch:

    ASSUME  DS:CODE,ES:CODE

        CALL    ReadAccessRange PASCAL,OFFSET START_ADRS_STR,OFFSET SearchEndAdrsStr
        JC      ErrorRange

        MOV     EAX,[ACCESS_AREA]
        MOV     [SEARCH_AREA],EAX
        MOV     EAX,[ACCESS_AREA+4]
        MOV     [SEARCH_AREA+4],EAX
        MOV     ESI,[SEARCH_AREA]
        CALL    SearchSub
        MOV     ESI,[EDIT_ADRS]
        CLC
        RET

SearchSub:

    ASSUME  DS:CODE,ES:CODE

        CALL    GetTimerVal
        MOV     [StartTimer],AX
        MOV     [CurTimer],AX

        MOV     ECX,[SEARCH_AREA+4]
        SUB     ECX,ESI
        INC     ECX         ;ECX=0の場合、4GBとして扱う
        .REPEAT
            ;検索中ﾒｯｾｰｼﾞ表示処理
            ;--------------------------
            CALL    GetTimerVal
            MOV     DX,AX
            SUB     AX,[StartTimer]
            .IF AX > 13
                MOV   AX,[CurTimer]
                SUB   DX,AX
                .IF DX > 3
                    ADD    AX,DX
                    MOV    [CurTimer],AX
                    PUSH   ESI
                    PUSH   ECX
                    MOV    EAX,ESI
                    MOV    SI,OFFSET MsgSearchAdrs
                    CALL   IntToStr32
                    MOV    DI,OFFSET MsgSearching
                    MOV    DX,OFFSET MsgSearchAdrs
                    MOV    BL,0F0H
                    CALL   DISP_MSG_WINDOW
                    MOV     DI,OFFSET MsgEscCancel
                    CALL    CalcCenterMsgWind
                    CALL    DISP_MSG
                    POP    ECX
                    POP    ESI
                    MOV    AH,1
                    INT    16H
                    .IF !ZERO?
                        MOV     AH,0
                        INT     16H
                        CMP     AH,01H
                        JE      @@Break
                    .ENDIF
                .ENDIF
            .ENDIF
            ;
            ;--------------------------------
            MOVZX   EAX,[SEARCH_VAL]
            .BREAK .IF (ECX & ECX) && (EAX > ECX) ;検索領域が検索文字列より小さいので終了
            PUSH    ECX
            MOV     AX,FILE_BUF_SIZE
            .IF !(ECX & ECX) || (ECX > EAX)
                MOV     ECX,EAX       ;ﾌｧｲﾙﾊﾞｯﾌｧｻｲｽﾞ分だけ読み込む
            .ENDIF
            XOR     EDI,EDI
            MOV     DI,OFFSET FILE_BUF
            CALL    GET_MEM
            PUSH    ECX
            MOV     BX,OFFSET FILE_BUF
            MOV     DX,[EDIT_LIMIT+2]
            MOV     AX,DX
            ADD     DX,BX
            SUB     AX,[EDIT_LIMIT]
            ADD     BX,[EDIT_LIMIT]
            .IF AX >= [SEARCH_VAL]
                SUB     DX,[SEARCH_VAL]   ;DX=検索終了ｱﾄﾞﾚｽ=(読み込みﾃﾞｰﾀ最終ｱﾄﾞﾚｽ)-(検索文字列長)
                PUSH    SI
                .REPEAT
                    MOV     SI,BX
                    MOV     CX,[SEARCH_VAL]
                    MOV     DI,OFFSET SEARCH_VAL+2
                    .REPEAT
                        MOV     AL,[SI]
                        .BREAK .IF AL !=[DI]
                        INC    SI
                        INC    DI
                        DEC    CX
                    .UNTIL ZERO?
                    JZ      @@Found
                    INC     BX
                .UNTIL BX > DX
                POP    SI
            .ENDIF
            POP     EAX
            SUB     AX,[SEARCH_VAL]
            INC     AX
            ADD     ESI,EAX
            POP     ECX
            SUB     ECX,EAX
        .UNTIL ZERO?
        ;見つからなかった
        ;----------------------
        MOV     DI,OFFSET MsgNotFound
        XOR     DX,DX
        JMP     DISP_ERROR_WINDOW


@@Found:
        POP     SI
        POP     ECX
        POP     ECX
        MOVZX   EBX,BX
        SUB     BX,OFFSET FILE_BUF
        ADD     ESI,EBX
        MOV     DX,SI
        AND     DX,000FH
        AND     SI,0FFF0H
        ADD     DX,DX
        MOV     WORD PTR [CURSOR],DX
        MOV     [EDIT_ADRS],ESI
@@Break:
        CLC
        RET

KEYIN_SEARCH ENDP

;**************************
;  指定文字列内の、16進文字列や''でくくられた文字列を、ﾊﾞｲﾅﾘﾃﾞｰﾀに変換する
;
;   入力     SI    文字列
;            DI    変換ﾃﾞｰﾀ格納ｱﾄﾞﾚｽ
;                  DI+0.W    変換ﾃﾞｰﾀｻｲｽﾞ
;                  DI+2.B～  変換ﾃﾞｰﾀ
;   出力     CY    0)変換成功  1)変換できない文字列がある
;   破壊     AX,BX,CX,SI,DI
;**************************
ConvHexStrings PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        ADD     DI,2
        MOV     CX,DI
        .WHILE 1
            MOV     AL,[SI]
            .BREAK .IF !(AL & AL)

            .IF (AL == "'") || (AL=='"')
                MOV     AH,AL
                INC     SI
                .WHILE 1
                     MOV     AL,[SI]
                     TEST    AL,AL
                     JZ      @@MissingEndQuate
                     .BREAK .IF AL == AH
                     MOV     [DI],AL
                     INC     SI
                     INC     DI
                .ENDW
            .ELSEIF AL != ' '
                ;16進文字列の場合
                ;-------------------------------
                MOV     BX,SI
                .IF ((AL >='0') && (AL <='9'))|| \
                    (((AL >='A') && (AL <='F'))|| \
                     ((AL >='a') && (AL <='f')))
                    INC     SI
                    ;16進文字列が何文字続くか検索する
                    ;-------------------------------
                    .WHILE 1
                         MOV     AL,[SI]
                         .BREAK .IF !(AL & AL) || (AL==' ')
                         .BREAK .IF  ((AL<'0') || (AL>'9')) && \
                                    (((AL<'A') || (AL>'F')) && \
                                     ((AL<'a') || (AL>'f')))
                         INC     SI
                    .ENDW
                    ;16進文字列の最後から、ﾊﾞｲﾅﾘﾃﾞｰﾀに変換していく
                    ;-------------------------------
                    PUSH    SI
                    .REPEAT
                        DEC     SI
                        MOV     AL,[SI]
                        SUB     AL,'0'
                        .IF AL >9
                             ADD     AL, '0'
                             AND     AL, 0DFh
                             SUB     AL,'A'-10
                        .ENDIF
                        MOV     [DI],AL
                        .IF SI == BX
                            INC     DI
                            .BREAK
                        .ENDIF
                        DEC     SI
                        MOV     AL,[SI]
                        SUB     AL,'0'
                        .IF AL >9
                             ADD     AL, '0'
                             AND     AL, 0DFh
                             SUB     AL,'A'-10
                        .ENDIF
                        SHL     AL,4
                        OR      [DI],AL
                        INC     DI
                    .UNTIL SI == BX
                    POP     SI
                    .CONTINUE
                .ENDIF
                JMP     @@NotHexString
            .ENDIF
            INC     SI
        .ENDW
        SUB     DI,CX
        MOV     BX,CX
        MOV     [BX-2],DI
        CLC
        RET

@@NotHexString:

        MOV      DI,OFFSET MsgNotHexString
        XOR      DX,DX
        JMP      DISP_ERROR_WINDOW

@@MissingEndQuate:

        MOV      DI,OFFSET MsgMissingEndQuate
        XOR      DX,DX
        JMP      DISP_ERROR_WINDOW


ConvHexStrings ENDP

;**************************
;  現在のｼｽﾃﾑﾀｲﾏｰｶｳﾝﾄ値取得
;
;   入力
;   出力   AX
;**************************
GetTimerVal PROC NEAR

    ASSUME  DS:NOTHING

        PUSH    DS
        MOV     DS,[DATA_SEL]
    ASSUME  DS:DATA
        MOV     AX,WORD PTR DS:[46CH]
        POP     DS
    ASSUME  DS:NOTHING
        RET

GetTimerVal ENDP
;**************************
;  次のﾊﾟﾀｰﾝ検索
;
;   入力
;   出力
;**************************
KEYIN_SEARCH_NEXT PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        .IF [SEARCH_VAL]!=0
            MOV     DX,WORD PTR [CURSOR]
            CALL    GET_OFFSET_FROM_CURSOR
            MOVZX   ESI,BX
            ADD     ESI,[EDIT_ADRS]
            INC     ESI
            MOV     EAX,[SEARCH_AREA]
            .IF EAX > [SEARCH_AREA+4]
                CMP     ESI,[SEARCH_AREA]
                JAE     @@Search
                CMP     ESI,[SEARCH_AREA+4]
                JBE     @@Search
                RET
            .ENDIF
            .IF (ESI >= [SEARCH_AREA])
                CMP     ESI,[SEARCH_AREA+4]
                JBE     @@Search
            .ENDIF
        .ENDIF
        RET
@@Search:

    ASSUME  DS:CODE,ES:CODE

        CALL    SearchSub
        MOV     ESI,[EDIT_ADRS]
        OR      [FLAG],@UPDATE_ALL
        RET


KEYIN_SEARCH_NEXT ENDP
;**************************
; 1ﾗｲﾝ入力
;**************************
ENTER_1LINE PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     DI,SI
        CALL    DISP_MSG2
@@LOOP:
        XOR     BH,BH
        MOV     AH,02H
        INT     10H

        MOV     AH,0
        INT     16H

        CMP     AL,8
        JE      @@BkSp
        CMP     AH,01H
        JE      @@RET
        CMP     AH,0FH
        JE      @@RET
        CMP     AH,1CH
        JE      @@RET
        CMP     AX,5000H
        JE      @@RET
        CMP     AX,4700H
        JE      @@Home
        CMP     AX,4800H
        JE      @@RET
        CMP     AX,4B00H
        JE      @@Left
        CMP     AX,4D00H
        JE      @@Right
        CMP     AX,4F00H
        JE      @@End
        CMP     AX,5200H
        JE      @@LOOP ;Insert
        CMP     AX,5300H
        JE      @@Del

        CMP     AL,' '
        JB      @@LOOP

        CMP     [ENTER_MODE],@ENTER_STR
        JE      @@PutChar

        CMP     AL,'0'
        JB      @@LOOP
        CMP     AL,'9'
        JBE     @@PutChar
        AND     AL,0DFH
        CMP     AL,'A'
        JB      @@LOOP
        CMP     AL,'F'
        JA      @@LOOP

;入力文字書き込み
;-----------------------
@@PutChar:
    ;挿入ﾓｰﾄﾞかどうかﾁｪｯｸ
    ;-----------------------
        PUSH    DS
        MOV     DS,[DATA_SEL]
        TEST    BYTE PTR DS:[417H],1 SHL 7
        POP     DS
        JZ      @@OVER
      ;挿入ﾓｰﾄﾞである
      ;--------------------------
        ;文字列最終ｱﾄﾞﾚｽ取得
        ;-----------------------
        CALL    @@GetLastAdrs
        PUSH    DI
@@InsLoop:
        CMP     DI,CX
        JAE     @@CantIns      ;これ以上入らない
        MOV     AH,[DI]
        INC     DI
        TEST    AH,AH
        JNZ     @@InsLoop
        CMP     DI,CX
        JAE     @@CantIns      ;これ以上入らない

        ;一文字挿入する分、移動する
        ;--------------------------
        POP     CX
@@InsLoop2:
        MOV     AH,[DI-1]
        MOV     [DI],AH
        DEC     DI
        CMP     DI,CX
        JA      @@InsLoop2

        MOV     [DI],AL
        PUSH    DX
        PUSH    DI
        CALL    DISP_MSG2
        POP     DI
        POP     DX
        INC     DI
        INC     DL
        JMP     @@LOOP

@@CantIns:
        POP     DI
        JMP     @@LOOP

      ;上書きﾓｰﾄﾞである
      ;--------------------------
@@OVER:
        CALL    @@GetLastAdrs
        CMP     DI,CX
        JAE     @@LOOP

        MOV     AH,[DI]
        MOV     [DI],AL
        INC     DI
        TEST    AH,AH
        JNZ     @@DISP_INPUT_CHAR
        MOV     [DI],AH
@@DISP_INPUT_CHAR:
        MOV     CX,1
        CALL    DISP_CHAR
        INC     DL
        JMP     @@LOOP
@@RET:
        RET

@@Right:
        CMP     BYTE PTR [DI],0
        JE      @@LOOP
        INC     DL
        INC     DI
        JMP     @@LOOP

@@Left:
        CMP     SI,DI
        JE      @@LOOP
        DEC     DL
        DEC     DI
        JMP     @@LOOP


@@Del:
        CMP     BYTE PTR [DI],0
        JE      @@LOOP
        PUSH    DI
@@DelLoop:
        MOV     AL,[DI+1]
        MOV     [DI],AL
        INC     DI
        TEST    AL,AL
        JNZ     @@DelLoop
        POP     DI
        JMP     @@DispLastSpace


@@BkSp:
        CMP     SI,DI
        JE      @@LOOP

        PUSH    DI
@@BkSpLoop:
        MOV     AL,[DI]
        MOV     [DI-1],AL
        INC     DI
        TEST    AL,AL
        JNZ     @@BkSpLoop
        POP     DI

        DEC     DI
        DEC     DL
@@DispLastSpace:
        PUSH    DI
        PUSH    DX
        CALL    DISP_MSG2
        MOV     AL,' '
        MOV     CX,1
        CALL    DISP_CHAR
        POP     DX
        POP     DI
        JMP     @@LOOP

@@Home:
        MOV     AX,DI
        SUB     AX,SI
        SUB     DL,AL
        MOV     DI,SI
        JMP     @@LOOP

@@End:
        .WHILE BYTE PTR [DI]!=0
            INC     DL
            INC     DI
        .ENDW
        JMP     @@LOOP


@@GetLastAdrs:

        MOV     CX,[ENTER_LEN]
        ADD     CX,SI
        INC     CX
        RET

ENTER_1LINE ENDP

;**************************
;  画面再表示
;
;  入力    DX    ｶｰｿﾙ位置(@UPDATE_CURSOR設定時のみ)
;  出力    なし
;  破壊
;**************************
REDISP_WINDOW PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        .IF [FLAG] & (@UPDATE OR @UPDATE_ADRS OR @UPDATE_CURSOR OR @UPDATE_ALL)
            PUSH    DX
            .IF [FLAG] & @UPDATE_ALL
                CALL    DISP_WAKU
                CALL    DISP_UNDER_WINDOW
                CALL    DISP_UNDER_MSG_EDIT
                CALL    CLEAR_DUMP_AREA
            .ENDIF
            .IF [FLAG] & (@UPDATE_ADRS OR @UPDATE_ALL)
                CALL    DISP_ADRS
            .ENDIF
            .IF [FLAG] & (@UPDATE OR @UPDATE_ALL)
                MOV     ECX,256
                XOR     EDI,EDI
                MOV     DI,OFFSET MEM_BUF
                CALL    GET_MEM
                CALL    DISP_MEM
            .ENDIF
            POP     DX
            .IF ([FLAG] & @UPDATE_CURSOR
                MOV     WORD PTR [CURSOR],DX
            .ENDIF
            AND     [FLAG],NOT (@UPDATE OR @UPDATE_ADRS OR @UPDATE_CURSOR OR @UPDATE_ALL)

            CALL    RESET_CURSOR
        .ENDIF
        RET

REDISP_WINDOW ENDP

;**************************
;  ｶｰｿﾙ再表示
;**************************
RESET_CURSOR PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CALL    GET_CURSOR_POS
        XOR     BH,BH
        MOV     AH,02H
        INT     10H
        MOV     AH,01H
        MOV     CX,[CURSOR_SHAPE]
        INT     10H
        RET

RESET_CURSOR ENDP

;**************************
;カーソル位置設定
;
;       入力    なし
;       出力    AL         1b)バイト単位
;                         11b)ワード単位
;                        111b)ダブルワード単位
;       破壊    なし
;**************************
GET_DATA_MASK PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CMP     [EDIT_MODE],@EDIT_CHAR
        JE      @@CHAR

        CMP     [DAT_SIZE],@DAT_WORD
        JE      @@WORD
        JA      @@DWORD

        MOV     AL,1B
        RET
@@WORD:
        MOV     AL,11B
        RET
@@DWORD:
        MOV     AL,111B
        RET
@@CHAR:
        XOR     AL,AL
        RET

GET_DATA_MASK ENDP
;**************************
;カーソル位置取得
;
;       入力    なし
;       出力    DX        ｶｰｿﾙ位置
;       破壊    BX,DX
;**************************
GET_CURSOR_POS PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     DX,WORD PTR [CURSOR]
        ADD     DH,3
        CMP     [EDIT_MODE],@EDIT_ADRS
        JE      @@ADRS
        CMP     [EDIT_MODE],@EDIT_CHAR
        JE      @@CHAR

        PUSH    AX
        CMP     [DAT_SIZE],@DAT_WORD
        JE      @@WORD
        JA      @@DWORD

        MOV     AL,DL
        SHR     AL,1
        ADD     DL,AL
        ADD     DL,10
        POP     AX
        RET

@@WORD:
        MOV     AL,DL
        SHR     AL,2
        ADD     DL,AL
        ADD     DL,14
        POP     AX
        RET

@@DWORD:
        MOV     AL,DL
        SHR     AL,3
        ADD     DL,AL
        ADD     DL,16
        POP     AX
        RET

@@CHAR:
        SHR     DL,1
        ADD     DL,61
        RET

@@ADRS:
        INC     DL
        RET

GET_CURSOR_POS ENDP

;**************************
;カーソル位置より、ｵﾌｾｯﾄｱﾄﾞﾚｽ取得
;
;       入力    DX    ｶｰｿﾙ位置
;               AL    書き込む値
;       出力    BX    ｵﾌｾｯﾄ
;               AH    ﾏｽｸﾊﾟﾀｰﾝ
;               AL    書き込む値
;       破壊    なし
;**************************
GET_OFFSET_FROM_CURSOR PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        XOR     BX,BX
        CMP     [EDIT_MODE],@EDIT_ADRS
        JE      @@END

        MOV     BL,DH
        SHL     BX,5

        CMP     [EDIT_MODE],@EDIT_CHAR
        JE      @@CHAR

;16進部分
;-----------------------
        CMP     [DAT_SIZE],@DAT_WORD
        JB      @@VAL_BYTE
        JA      @@VAL_DWORD

        XOR     DL,010B
        JMP     @@VAL_BYTE
@@VAL_DWORD:
        XOR     DL,110B
@@VAL_BYTE:
        ADD     BL,DL
        ADC     BH,0
        MOV     AH,0F0H
        SHR     BX,1
        JC      @@VAL_LOW
        SHL     AL,4
        NOT     AH
@@VAL_LOW:
        RET

;文字部分
;-----------------------
@@CHAR:
        ADD     BL,[CURSOR]
        ADC     BH,0
        SHR     BX,1
        XOR     AH,AH
@@END:
        RET

GET_OFFSET_FROM_CURSOR ENDP
;**************************
;メモリ書き換え
;
;       入力    ESI
;       出力    なし
;       破壊    EAX,EBX
;**************************
UPDATE_MEM PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        TEST    [FLAG],@EDIT
        JZ      @@END

        OR      [FLAG],@EDITED
        PUSH    ECX
        PUSH    ESI
        CALL    A20_ON
        ;ﾌﾟﾛﾃｸﾄﾓｰﾄﾞに移行
        ;-------------------------
        CALL    ENTER_PROTECT
        MOV     ECX,256+4
        CALL    GET_DUMP_SEL
    ASSUME  DS:NOTHING
        JC      @@CANT_GET_SEL         ;ｴﾗｰでｾｸﾞﾒﾝﾄ取得できない

        TEST    [FLAG],@FILE
        JNZ     @@WRITE_FILE

        MOVZX   EBX,CS:[EDIT_OFFSET]
        CMP     CS:[DAT_SIZE],@DAT_WORD
        JE      @@WRITE_WORD
        JA      @@WRITE_DWORD

        MOV     AL,CS:[MEM_BUF+BX]
        MOV     DS:[EBX+ESI],AL
        JMP     @@RET_REAL

@@WRITE_WORD:
        AND     BL,NOT 1
        MOV     AX,WORD PTR CS:[MEM_BUF+BX]
        MOV     DS:[EBX+ESI],AX
        JMP     @@RET_REAL

@@WRITE_DWORD:
        AND     BL,NOT 11B
        MOV     EAX,DWORD PTR CS:[MEM_BUF+BX]
        MOV     DS:[EBX+ESI],EAX
        JMP     @@RET_REAL

@@WRITE_FILE:

        PUSH    DX
        PUSH    BX
        PUSH    ESI
        POP     DX
        POP     CX
        ADD     DX,[EDIT_OFFSET]
        ADC     CX,0
        MOV     BX,[EDIT_HANDLE]
        MOV     AX,4200H
        INT     21H
        MOV     DX,OFFSET MEM_BUF
        ADD     DX,[EDIT_OFFSET]
        MOVZX   CX,[DAT_SIZE]
        MOV     AH,40H
        INT     21H

        POP     BX
        POP     DX

@@RET_REAL:

        ;リアルモードに戻る
        ;----------------------
        CALL    FREE_DUMP_SEL
@@CANT_GET_SEL:
        CALL    LEAVE_PROTECT
    ASSUME  DS:CODE,ES:CODE
        POP     ESI
        POP     ECX

        AND     [FLAG],NOT @EDIT
        OR      [FLAG],@UPDATE
@@END:
        RET

UPDATE_MEM ENDP
;**************************
;メモリ書き込み
;
;       入力    ES:EDI  書き込みﾃﾞｰﾀ開始アドレス
;               ECX     書き込みｻｲｽﾞ
;               ESI     書き込み物理ｱﾄﾞﾚｽ
;       出力    なし
;       破壊    なし
;**************************
PUT_MEM PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        OR      [FLAG],@EDITED
        PUSH    EAX
        PUSH    EBX
        PUSH    ECX
        PUSH    ESI
        PUSH    EDI
        CALL    A20_ON

;ﾌﾟﾛﾃｸﾄﾓｰﾄﾞに移行
;-------------------------
        CALL    ENTER_PROTECT
        TEST    [FLAG],@FILE
        JNZ     @@FILE

        TEST    [FLAG],@DPMI
        JZ      @@GET_NORMAL

;DPMI
;----------------------
    ;4GBの境界をまたぐ場合、境界から二つに分けて転送する
    ;------------------------
        MOV     EAX,ESI
        NEG     EAX
        JZ      @@GET_NORMAL
        CMP     ECX,EAX
        JBE     @@GET_NORMAL

        SUB     ECX,EAX
        PUSH    ECX
        MOV     ECX,EAX
        CALL    GET_DUMP_SEL
    ASSUME  DS:NOTHING
        .IF CARRY?
            POP     ECX
            JMP     @@CANT_GET_SEL         ;ｴﾗｰでｾｸﾞﾒﾝﾄ取得できない
        .ENDIF

        PUSH    DS
        POP     ES
    ASSUME  ES:NOTHING
        MOV     AL,CS:[DAT_SIZE]
        DEC     AL
        MOV     AH,AL
        NOT     AL
        AND     AH,CL
        AND     CL,AL
        CALL    @@PUT_MEM_SUB
        MOVZX   ECX,AH
        XCHG    ESI,EDI
        REP     MOVS BYTE PTR ES:[EDI],BYTE PTR CS:[ESI]
        XCHG    ESI,EDI

        MOV     CL,CS:[DAT_SIZE]
        SUB     CL,AH
        AND     CL,AL
        POP     EAX
        ADD     ECX,EAX
        XOR     ESI,ESI
        CALL    FREE_DUMP_SEL
        CALL    GET_DUMP_SEL
    ASSUME  DS:NOTHING
        JC      @@CANT_GET_SEL      ;ｴﾗｰでｾｸﾞﾒﾝﾄ取得できない
        PUSH    DS
        POP     ES
    ASSUME  ES:NOTHING
        PUSH    ECX
        MOV     ECX,EAX
        XCHG    ESI,EDI
        REP     MOVS BYTE PTR ES:[EDI],BYTE PTR CS:[ESI]
        XCHG    ESI,EDI
        POP     ECX
        CALL    @@PUT_MEM_SUB
        JMP     @@CANT_GET_SEL

@@GET_NORMAL:
        CALL    GET_DUMP_SEL
    ASSUME  DS:NOTHING
        JC      @@CANT_GET_SEL         ;ｴﾗｰでｾｸﾞﾒﾝﾄ取得できない
        PUSH    DS
        POP     ES
    ASSUME  ES:NOTHING
        CALL    @@PUT_MEM_SUB
        ;リアルモードに戻る
        ;----------------------
@@RET_REAL:
        CALL    FREE_DUMP_SEL
@@CANT_GET_SEL:
        CALL    LEAVE_PROTECT
    ASSUME  DS:CODE,ES:CODE
        POP     EDI
        POP     ESI
        POP     ECX
        POP     EBX
        POP     EAX
        RET

;メモリ転送
;------------------------
@@PUT_MEM_SUB:
        XCHG    ESI,EDI
        CMP     CS:[DAT_SIZE],@DAT_WORD
        JE      @@READ_WORD
        JA      @@READ_DWORD
        REP     MOVS BYTE PTR ES:[EDI],BYTE PTR CS:[ESI]
        XCHG    ESI,EDI
        RET

@@READ_WORD:
        SHR     CX,1
        REP     MOVS WORD PTR ES:[EDI],WORD PTR CS:[ESI]
        XCHG    ESI,EDI
        RET

@@READ_DWORD:
        SHR     CX,2
        REP     MOVS DWORD PTR ES:[EDI],DWORD PTR CS:[ESI]
        XCHG    ESI,EDI
        RET

;ﾌｧｲﾙに書き込み
;--------------------------
@@FILE:
    ;4GBの境界をまたぐ場合、境界を境に二つに分けて転送する
    ;--------------------------
        MOV     EAX,ESI
        NEG     EAX
        JZ      @@FILE_NORMAL
        CMP     ECX,EAX
        JBE     @@FILE_NORMAL

        ;またぐ前の領域には転送しない
        ;---------------------------
        SUB     ECX,EAX
        ADD     DI,AX

        ;またいだ後の領域転送
        ;---------------------------
        PUSH    CX
        XOR     DX,DX
        XOR     CX,CX
        JMP     @@FILE_LAST

    ;またがない場合の転送
    ;------------------------
@@FILE_NORMAL:

        PUSH    CX
        PUSH    ESI
        POP     DX
        POP     CX
@@FILE_LAST:
        MOV     BX,[EDIT_HANDLE]
        MOV     AX,4200H
        INT     21H

        MOV     DX,DI
        POP     CX
        MOV     AH,40H
        INT     21H
        JMP     @@RET_REAL

PUT_MEM ENDP
;**************************
;メモリ取得
;
;       入力    ESI     取得開始アドレス
;               ECX     取得ｻｲｽﾞ
;               ES:EDI     格納ｱﾄﾞﾚｽ
;       出力    なし
;       破壊    なし
;**************************
GET_MEM PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        PUSH    EAX
        PUSH    EBX
        PUSH    ECX
        PUSH    EDX
        PUSH    ESI
        PUSH    EDI

        CALL    A20_ON

;ﾌﾟﾛﾃｸﾄﾓｰﾄﾞに移行
;-------------------------
        CALL    ENTER_PROTECT

        TEST    [FLAG],@FILE
        JNZ     @@GET_FILE

;        ADD     ECX,DWORD PTR [DAT_SIZE]
        TEST    [FLAG],@DPMI
        JZ      @@GET_NORMAL

;DPMI
;----------------------
        MOV     [EDIT_LIMIT],0
        MOV     [EDIT_LIMIT+2],FILE_BUF_SIZE

    ;4GBの境界をまたぐ場合、境界から二つに分けて転送する
    ;------------------------
        MOV     EAX,ESI
        NEG     EAX
        JZ      @@GET_NORMAL
        CMP     ECX,EAX
        JBE     @@GET_NORMAL

        SUB     ECX,EAX
        PUSH    ECX
        MOV     ECX,EAX
        CALL    GET_DUMP_SEL
    ASSUME  DS:NOTHING
        .IF CARRY?
            POP     ECX
            JMP     @@CANT_GET_SEL
        .ENDIF
        MOV     AL,CS:[DAT_SIZE]
        DEC     AL
        MOV     AH,AL
        NOT     AL
        AND     AH,CL
        AND     CL,AL
        CALL    @@GET_MEM_SUB
        MOVZX   ECX,AH
        REP     MOVS BYTE PTR ES:[EDI],BYTE PTR DS:[ESI]

        MOV     CL,CS:[DAT_SIZE]
        SUB     CL,AH
        AND     CL,AL
        POP     EAX
        ADD     ECX,EAX
        XOR     ESI,ESI
        CALL    FREE_DUMP_SEL
        CALL    GET_DUMP_SEL
    ASSUME  DS:NOTHING
        JC      @@CANT_GET_SEL
        PUSH    ECX
        MOV     ECX,EAX
        REP     MOVS BYTE PTR ES:[EDI],BYTE PTR DS:[ESI]
        POP     ECX
        CALL    @@GET_MEM_SUB
        JMP     @@RET_REAL

@@GET_NORMAL:
        CALL    GET_DUMP_SEL
    ASSUME  DS:NOTHING
        JC      @@CANT_GET_SEL
        CALL    @@GET_MEM_SUB
        JMP     @@RET_REAL

@@CANT_GET_SEL:

        MOV     [EDIT_LIMIT],FILE_BUF_SIZE
        MOV     [EDIT_LIMIT+2],0
        JMP     @@ERROR_END

;リアルモードに戻る
;----------------------
@@RET_REAL:
        CALL    FREE_DUMP_SEL
@@ERROR_END:
        CALL    LEAVE_PROTECT
    ASSUME  DS:CODE,ES:CODE
        POP     EDI
        POP     ESI
        POP     EDX
        POP     ECX
        POP     EBX
        POP     EAX
        RET

;メモリ転送
;------------------------
@@GET_MEM_SUB:

    ASSUME  DS:NOTHING

        CMP     CS:[DAT_SIZE],@DAT_WORD
        JE      @@READ_WORD
        JA      @@READ_DWORD
        REP     MOVS BYTE PTR ES:[EDI],BYTE PTR DS:[ESI]
        RET

@@READ_WORD:
        SHR     CX,1
        REP     MOVS WORD PTR ES:[EDI],WORD PTR DS:[ESI]
        RET

@@READ_DWORD:
        SHR     CX,2
        REP     MOVS DWORD PTR ES:[EDI],DWORD PTR DS:[ESI]
        RET



;ﾌｧｲﾙから読み込み
;--------------------------
@@GET_FILE:

    ASSUME  DS:CODE,ES:CODE
    ;4GBの境界をまたぐ場合、境界を境に二つに分けて転送する
    ;--------------------------
        MOV     EAX,ESI
        NEG     EAX
        JZ      @@GET_FILE_NORMAL
        CMP     ECX,EAX
        JBE     @@GET_FILE_NORMAL

        ;またぐ前の領域は、全部０
        ;---------------------------
        SUB     ECX,EAX
        MOV     [EDIT_LIMIT],AX
        MOV     [EDIT_LIMIT+2],AX
@@Fill_1:
        MOV     BYTE PTR [DI],0
        INC     DI
        DEC     AX
        JNZ     @@Fill_1
        ;またいだ後の領域転送
        ;---------------------------
        PUSH    CX
        XOR     DX,DX
        XOR     CX,CX
        JMP     @@GET_FILE_LAST

    ;またがない場合の転送
    ;------------------------
@@GET_FILE_NORMAL:

        MOV     DWORD PTR [EDIT_LIMIT],0

        PUSH    CX
        PUSH    ESI
        POP     DX
        POP     CX
@@GET_FILE_LAST:
        MOV     BX,[EDIT_HANDLE]
        MOV     AX,4200H
        INT     21H

        MOV     DX,DI
        POP     CX
        MOV     AH,3FH
        INT     21H
        ADD     [EDIT_LIMIT+2],AX
        CMP     AX,CX
        JE      @@RET_REAL
        ADD     DI,AX
        SUB     AX,CX
@@FileFill:
        MOV     BYTE PTR [DI],0
        INC     DI
        INC     AX
        JNZ     @@FileFill
        JMP     @@RET_REAL

GET_MEM ENDP
;**************************
;ﾘｱﾙﾓｰﾄﾞに戻る
;
;       入力    なし
;       出力    なし
;       破壊    EAX,EDX
;**************************
LEAVE_PROTECT PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        TEST    CS:[FLAG],@DPMI OR @FILE
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
    ASSUME  ES:CODE
        MOV     DS,AX
    ASSUME  DS:CODE
        RET

@@VCPI:
        MOV     EDX,ESP
        MOVZX   EAX,CS:[CODE_SEG]
        PUSH    EAX    ;GS
        PUSH    EAX    ;FS
        PUSH    EAX    ;DS
        PUSH    EAX    ;ES
        PUSH    EAX    ;SS
        PUSH    EDX    ;ESP
        PUSHFD         ;EFLAGS
        PUSH    EAX    ;CS
        MOV     AX,OFFSET @@RET_V86
        PUSH    EAX    ;EIP
        MOV     AX,DSEL_FULL
        MOV     DS,AX
    ASSUME  DS:NOTHING
        MOV     AX,0DE0CH
        CALL    FWORD PTR CS:[VCPI_ENTRY]
        JMP     $
@@RET_V86:
    ASSUME  DS:CODE,ES:CODE
        MOV     [DSEL_CODE],CS
        RET

LEAVE_PROTECT ENDP
;**************************
;ﾌﾟﾛﾃｸﾄﾓｰﾄﾞに移行
;
;       入力    ESI     ﾀﾞﾝﾌﾟｱﾄﾞﾚｽ
;       出力    ESI     DSEL_DUMPをﾍﾞｰｽとしたｵﾌｾｯﾄｱﾄﾞﾚｽ
;       破壊    EAX,BX,CX,DX
;**************************
ENTER_PROTECT PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        TEST    [FLAG],@DPMI OR @FILE
        JNZ     @@DPMI

        CLI
        MOV     [DSEL_CODE],DSEL
        TEST    [FLAG],@VCPI
        JNZ     @@VCPI

        LGDT    [GDTR_PARA]
        MOV     EAX,CR0
        OR      AL,1
        MOV     CR0,EAX
@@DPMI:
        RET

@@VCPI:
        PUSH    ESI
        MOV     [STACK_BAK],SP
        XOR     EAX,EAX
        XOR     ESI,ESI
        MOV     AX,CS
        SHL     EAX,4
        MOV     SI,OFFSET VCPI_PROTECT_TBL
        ADD     ESI,EAX
        MOV     AX,0DE0CH
        INT     67H
        MOV     DX,OFFSET ERROR_VCPI
        JMP     ERROR_END
VCPI_ENTER_PROTECT:
	MOV	AX,DSEL
	MOV	DS,AX
    ASSUME  DS:CODE
	MOV	ES,AX
    ASSUME  ES:CODE
	MOV	FS,AX
    ASSUME  FS:CODE
	MOV	GS,AX
    ASSUME  GS:CODE
	MOV	SS,AX
    ASSUME  SS:CODE
        MOVZX   ESP,[STACK_BAK]
        POP     ESI

        MOV     [DSEG_DUMP].BASE,0
        MOV     [DSEG_DUMP].HIBASE,40H
        MOV     [DSEG_DUMP].MSBASE,0
        RET

ENTER_PROTECT ENDP
;**************************
;ﾀﾞﾝﾌﾟするﾒﾓﾘへのｾﾚｸﾀとｵﾌｾｯﾄｱﾄﾞﾚｽ取得
;
;       入力    ESI     ﾀﾞﾝﾌﾟｱﾄﾞﾚｽ
;               ECX     ﾀﾞﾝﾌﾟｻｲｽﾞ
;       出力    DS:ESI  ﾀﾞﾝﾌﾟ開始ｱﾄﾞﾚｽ
;               CY      0)ｾｸﾞﾒﾝﾄ取得成功
;                       1)ｾｸﾞﾒﾝﾄ取得失敗
;       破壊    EAX,BX,DX
;**************************
GET_DUMP_SEL PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        PUSH    CS:[DSEL_CODE]
        POP     DS
    ASSUME  DS:CODE

        TEST    [FLAG],@FILE
        JNZ     @@FILE

        TEST    [FLAG],@DPMI
        JNZ     @@DPMI

        TEST    [FLAG],@VCPI
        JNZ     @@VCPI

        PUSH    EAX
        MOV     EAX,ESI
        MOV     [DSEG_DUMP].BASE,AX
        SHR     EAX,16
        MOV     [DSEG_DUMP].HIBASE,AL
        MOV     [DSEG_DUMP].MSBASE,AH

        XOR     ESI,ESI
        MOV     DS,[DUMP_SEL]
    ASSUME  DS:NOTHING
        POP     EAX
@@FILE:
        RET

@@VCPI:

    ASSUME  DS:CODE

        PUSH    EAX
        MOV     AX,DSEL_PAGE
        MOV     DS,AX
    ASSUME  DS:NOTHING
        MOV     EAX,ESI
        AND     AX,0F000H
        OR      AL,7
        MOV     DS:[2000H],EAX
        ADD     EAX,1000H
        MOV     DS:[2004H],EAX
        ADD     EAX,1000H
        MOV     DS:[2008H],EAX
        ADD     EAX,1000H
        MOV     DS:[200CH],EAX
        ADD     EAX,1000H
        MOV     DS:[2010H],EAX

        MOV     DS,CS:[DUMP_SEL]
    ASSUME  DS:NOTHING
        AND     ESI,0FFFH
        POP     EAX
        RET

@@DPMI:

    ASSUME  DS:CODE

        PUSH    AX
        PUSH    ECX
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
            MOV     BX,[DUMP_SEL]
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
        POP     ECX
        POP     AX
        RET

GET_DUMP_SEL ENDP
;**************************
;ﾀﾞﾝﾌﾟするﾒﾓﾘへのｾﾚｸﾀを開放
;
;       入力    なし
;       出力    なし
;       破壊    なし
;**************************
FREE_DUMP_SEL PROC NEAR

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
        MOV     BX,CS:[DUMP_SEL]
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

FREE_DUMP_SEL ENDP

;**************************
;ｴﾗｰｳｨﾝﾄﾞｳ表示
;
;       入力    DI    ｴﾗｰﾒｯｾｰｼﾞｱﾄﾞﾚｽ
;               DX    ﾌｧｲﾙ名  0)無し
;       出力    CY    1
;       破壊    なし
;**************************
DISP_ERROR_WINDOW PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        PUSHA
        MOV     BL,0F0H
        CALL    DISP_MSG_WINDOW

        MOV     DI,OFFSET HitAnyKeyMsg
        CALL    CalcCenterMsgWind
        CALL    DISP_MSG

        MOV     AH,0
        INT     16H

        CALL    DISP_WAKU
        CALL    CLEAR_DUMP_AREA
        CALL    DISP_MEM
        POPA
        STC
        RET

DISP_ERROR_WINDOW ENDP
;**************************
;ｴﾗｰｳｨﾝﾄﾞｳ表示
;
;       入力    DI    ﾒｯｾｰｼﾞｱﾄﾞﾚｽ
;               DX    ﾒｯｾｰｼﾞｱﾄﾞﾚｽ  0)無し
;               BL    文字属性
;       出力    CY    1
;       破壊    なし
;**************************
DISP_MSG_WINDOW PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        PUSHA

        PUSH    DX
        PUSH    DI

        MOV     DX,9 SHL 8 OR 10
        MOV     CX,47
        MOV     AL,' '
        CALL    DISP_CHAR
        INC     DH
        CALL    DISP_CHAR
        INC     DH
        CALL    DISP_CHAR
        INC     DH
        CALL    DISP_CHAR

        MOV     DX,9 SHL 8 OR 47
        POP     DI
        CALL    CalcCenterMsgWind
        CALL    DISP_MSG

        MOV     DX,10 SHL 8 OR 45
        POP     DI
        .IF DI & DI
            CALL    CalcCenterMsgWind
            MOV     AL,"("
            MOV     CX,1
            CALL    DISP_CHAR
            INC     DX
            CALL    DISP_MSG2
            MOV     AL, ")"
            CALL    DISP_CHAR
        .ENDIF
        POPA
        MOV     DX,12 SHL 8 OR 47
        RET


CalcCenterMsgWind:
        CALL    StrLenDI
        SUB     DL,CL
        SHR     DL,1
        ADD     DL,10
        RET


DISP_MSG_WINDOW ENDP



;**************************
;ｱﾄﾞﾚｽ表示
;
;       入力    ESI     表示アドレス
;       出力    なし
;       破壊    なし
;**************************
DISP_ADRS PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        PUSH    ESI
        MOV     BL,7
        MOV     CX,1
        MOV     DH,03H
@@ADRS_LOOP:
        MOV     DL,1
        MOV     EAX,ESI
        CALL    DISP_HEX32
        ADD     ESI,16
        INC     DH
        CMP     DH,19
        JB      @@ADRS_LOOP
        POP     ESI
        RET

DISP_ADRS ENDP

;**************************
;メモリ表示
;
;       入力    なし
;       出力    なし
;       破壊    なし
;**************************
DISP_MEM PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     BL,7
        MOV     CX,1
        AND     [FLAG],NOT @KANJI
        MOV     DH,3
        XOR     DI,DI
@@DUMP_ROW:

        CMP     [DAT_SIZE],@DAT_WORD
        JE      @@WORD_DUMP
        JA      @@DWORD_DUMP

        MOV     DL,10
@@BYTE_DUMP_COL_HEX:

        CMP     DI,[EDIT_LIMIT]
        JB      @@BYTE_DUMP_COL_HEX_0
        CMP     DI,[EDIT_LIMIT+2]
        JB      @@BYTE_DUMP_COL_HEX_1

@@BYTE_DUMP_COL_HEX_0:
        MOV     CX,2
        MOV     AL,'?'
        CALL    DISP_CHAR
        INC     DX
        INC     DX
        JMP     @@BYTE_DUMP_COL_HEX_2

@@BYTE_DUMP_COL_HEX_1:
        MOV     AL,[MEM_BUF+DI]
        CALL    DISP_HEX8
@@BYTE_DUMP_COL_HEX_2:
        INC     DI
        INC     DX
        TEST    DI,0FH
        JNZ     @@BYTE_DUMP_COL_HEX
        JMP     @@DUMP_CHAR

@@WORD_DUMP:
        MOV     DL,14
@@WORD_DUMP_COL_HEX:

        CMP     DI,[EDIT_LIMIT]
        JB      @@WORD_DUMP_COL_HEX_0
        CMP     DI,[EDIT_LIMIT+2]
        JB      @@WORD_DUMP_COL_HEX_1

@@WORD_DUMP_COL_HEX_0:
        MOV     CX,4
        MOV     AL,'?'
        CALL    DISP_CHAR
        ADD     DL,4
        JMP     @@WORD_DUMP_COL_HEX_2

@@WORD_DUMP_COL_HEX_1:
        MOV     AX,WORD PTR [MEM_BUF+DI]
        CALL    DISP_HEX16
@@WORD_DUMP_COL_HEX_2:
        INC     DI
        INC     DI
        INC     DX
        TEST    DI,0FH
        JNZ     @@WORD_DUMP_COL_HEX
        JMP     @@DUMP_CHAR

@@DWORD_DUMP:
        MOV     DL,16
@@DWORD_DUMP_COL_HEX:

        CMP     DI,[EDIT_LIMIT]
        JB      @@DWORD_DUMP_COL_HEX_0
        CMP     DI,[EDIT_LIMIT+2]
        JB      @@DWORD_DUMP_COL_HEX_1

@@DWORD_DUMP_COL_HEX_0:
        MOV     CX,8
        MOV     AL,'?'
        CALL    DISP_CHAR
        ADD     DL,8
        JMP     @@DWORD_DUMP_COL_HEX_2

@@DWORD_DUMP_COL_HEX_1:
        MOV     EAX,DWORD PTR [MEM_BUF+DI]
        CALL    DISP_HEX32
@@DWORD_DUMP_COL_HEX_2:
        ADD     DI,4
        INC     DX
        TEST    DI,0FH
        JNZ     @@DWORD_DUMP_COL_HEX

@@DUMP_CHAR:
        SUB     DI,16
        MOV     CX,1

        MOV     DL,60
        MOV     AL,' '
        TEST    [FLAG],@KANJI
        JZ      @@SKIP_DISP_PRE_BYTE
        MOV     AL,[MEM_BUF+DI-1]
@@SKIP_DISP_PRE_BYTE:
        CALL    DISP_CHAR
        INC     DX
@@DUMP_COL_CHAR:
        MOV     AL,[MEM_BUF+DI]
        CMP     DI,[EDIT_LIMIT]
        JB      @@DUMP_COL_CHAR_0
        CMP     DI,[EDIT_LIMIT+2]
        JB      @@DUMP_COL_CHAR_1
@@DUMP_COL_CHAR_0:
        MOV     AL,0
@@DUMP_COL_CHAR_1:
        CALL    DISP_CHAR

        TEST    [FLAG],@JAPAN
        JZ      @@NO_KANJI
        TEST    [FLAG],@KANJI
        JNZ     @@END_KANJI

        CMP     AL,81H
        JB      @@NO_KANJI
        CMP     AL,9FH
        JBE     @@YES_KANJI
        CMP     AL,0E0H
        JB      @@NO_KANJI
        CMP     AL,0FCH
        JA      @@NO_KANJI
@@YES_KANJI:
        OR      [FLAG],@KANJI
        JMP     @@NO_KANJI
@@END_KANJI:
        AND     [FLAG],NOT @KANJI
@@NO_KANJI:
        INC     DI
        INC     DL
        TEST    DI,0FH
        JNZ     @@DUMP_COL_CHAR

        MOV     AL,' '
        TEST    [FLAG],@KANJI
        JZ      @@SKIP_DISP_NEXT_BYTE
	TEST	DI, 00FFH
	JZ	@@SKIP_DISP_NEXT_BYTE
        MOV     AL,[MEM_BUF+DI]
@@SKIP_DISP_NEXT_BYTE:
        CALL    DISP_CHAR

        INC      DH
        TEST     DI,00FFH
        JNZ      @@DUMP_ROW

        RET

DISP_MEM ENDP
;**************************
;ダンプ領域クリア
;
;       入力    なし
;       出力    なし
;       破壊    なし
;**************************
CLEAR_DUMP_AREA PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     BL,07H
        MOV     DX,010AH
        MOV     DI,OFFSET HEX_DAT

        CMP     [DAT_SIZE],@DAT_WORD
        JE      @@CLR_WORD
        JA      @@CLR_DWORD

;ﾊﾞｲﾄ表示の場合
;----------------------
    ;ｵﾌｾｯﾄ部分
    ;----------------------
        MOV     CX,1
        JMP     @@HEX_BYTE_START

@@HEX_BYTE_LOOP:
        MOV     AL,' '
        CALL    DISP_CHAR
        INC     DX
@@HEX_BYTE_START:
        MOV     AL,'+'
        CALL    DISP_CHAR
        INC     DX
        MOV     AL,[DI]
        CALL    DISP_CHAR
        INC     DI
        INC     DX
        CMP     DI,OFFSET HEX_DAT+16
        JB      @@HEX_BYTE_LOOP

    ;ﾒﾓﾘ内容部分
    ;----------------------
        MOV     DH,3
        MOV     CX,1
        MOV     AL,' '
@@HEX_BYTE_ROW:
        MOV     DL,12
@@HEX_BYTE_COL:

        CMP     DL,33
        JE      @@HEX_BYTE_SKIP_CENTER
        CALL    DISP_CHAR
@@HEX_BYTE_SKIP_CENTER:
        ADD     DL,3
        CMP     DL,54
        JBE     @@HEX_BYTE_COL
        INC     DH
        CMP     DH,19
        JB      @@HEX_BYTE_ROW

        RET

;ﾜｰﾄﾞ表示の場合
;----------------------
    ;ｵﾌｾｯﾄ部分
    ;----------------------
@@CLR_WORD:
        MOV     AL,' '
        MOV     CX,2
        CALL    DISP_CHAR
        ADD     DL,CL
@@HEX_WORD_LOOP:
        MOV     CX,3
        MOV     AL,' '
        CALL    DISP_CHAR
        ADD     DL,CL
        MOV     CX,1
        MOV     AL,'+'
        CALL    DISP_CHAR
        INC     DX
        MOV     AL,[DI]
        CALL    DISP_CHAR
        INC     DX
        ADD     DI,2
        CMP     DI,OFFSET HEX_DAT+16
        JB      @@HEX_WORD_LOOP

        MOV     AL,' '
        MOV     CX,5
        CALL    DISP_CHAR

    ;ﾒﾓﾘ内容部分
    ;----------------------
        MOV     DH,3
        MOV     CX,1
        MOV     AL,' '
@@HEX_WORD_ROW:
        MOV     DL,10
        MOV     CL,4
        CALL    DISP_CHAR
        MOV     DL,18
        MOV     CL,1
@@HEX_WORD_COL:
        CMP     DL,33
        JE      @@HEX_WORD_SKIP_CENTER
        CALL    DISP_CHAR
@@HEX_WORD_SKIP_CENTER:
        ADD     DL,5
        CMP     DL,48
        JBE     @@HEX_WORD_COL

        MOV     DL,53
        MOV     CL,4
        CALL    DISP_CHAR

        INC     DH
        CMP     DH,19
        JB      @@HEX_WORD_ROW

        RET


;ﾀﾞﾌﾞﾙﾜｰﾄﾞ表示の場合
;----------------------
    ;ｵﾌｾｯﾄ部分
    ;----------------------
@@CLR_DWORD:
        MOV     AL,' '
        MOV     CX,2
        CALL    DISP_CHAR
        ADD     DL,CL
@@HEX_DWORD_LOOP:
        MOV     CX,7
        MOV     AL,' '
        CALL    DISP_CHAR
        ADD     DL,CL
        MOV     AL,'+'
        CALL    DISP_CHAR
        INC     DX
        MOV     AL,[DI]
        CALL    DISP_CHAR
        INC     DX
        ADD     DI,4
        CMP     DI,OFFSET HEX_DAT+16
        JB      @@HEX_DWORD_LOOP

        MOV     AL,' '
        MOV     CX,9
        CALL    DISP_CHAR

    ;ﾒﾓﾘ内容部分
    ;----------------------
        MOV     DH,3
        MOV     CX,1
        MOV     AL,' '
@@HEX_DWORD_ROW:
        MOV     DL,10
        MOV     CL,6
        CALL    DISP_CHAR
        MOV     DL,24
        MOV     CL,1
        CALL    DISP_CHAR
        MOV     DL,42
        CALL    DISP_CHAR
        MOV     DL,51
        MOV     CL,6
        CALL    DISP_CHAR
        INC     DH
        CMP     DH,19
        JB      @@HEX_DWORD_ROW

        RET

CLEAR_DUMP_AREA ENDP
;**************************
;枠表示
;
;       入力    なし
;       出力    なし
;       破壊    なし
;**************************
DISP_WAKU PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    SI

        CALL    GET_LANG_WAKU

;一行目
;------------------------
        XOR     DH,DH
        MOV     BL,07H
        CALL    DISP_ROW_WAKU
        MOV     CX,1
        XOR     DL,DL
        MOV     AL,[SI]
        CALL    DISP_CHAR
        MOV     AL,[SI+8]
        MOV     DL,9
        CALL    DISP_CHAR
        MOV     DL,57
        CALL    DISP_CHAR
        MOV     AL,[SI+1]
        MOV     DL,79
        CALL    DISP_CHAR

        .IF [FLAG] & @FILE
            MOV     DL,10
            MOV     AL,' '
            CALL    DISP_CHAR
            INC     DX
            MOV     DI,OFFSET MsgFileName
            CALL    DISP_MSG2
            MOV     DI,OFFSET EDIT_FILE_NAME
            CALL    DISP_MSG2
            MOV     AL,' '
            CALL    DISP_CHAR
        .ENDIF

;２行目
;------------------------
        MOV     AL,[SI+4]
        MOV     DX,0100H
        CALL    DISP_CHAR
        INC     DX
        MOV     DI,OFFSET ADRS_MSG
        CALL    DISP_MSG2
        MOV     CX,9
        SUB     CL,DL
        MOV     AL,' '
        CALL    DISP_CHAR

        MOV     CX,1
        MOV     AL,[SI+4]
        MOV     DL,9
        CALL    DISP_CHAR

        MOV     DL,57
        MOV     AL,[SI+4]
        CALL    DISP_CHAR
        ADD     DL,7
        MOV     DI,OFFSET CHAR_MSG
        CALL    DISP_MSG
        MOV     AL,[SI+4]
        MOV     DL,79
        CALL    DISP_CHAR

;３行目
;------------------------
        MOV     DH,2
        CALL    DISP_ROW_WAKU
        XOR     DL,DL
        MOV     CX,1
        MOV     AL,[SI+10]
        CALL    DISP_CHAR
        MOV     AL,[SI+6]
        MOV     DL,9
        CALL    DISP_CHAR
        MOV     DL,57
        CALL    DISP_CHAR
        MOV     AL,[SI+9]
        MOV     DL,79
        CALL    DISP_CHAR

;４～１９行目
;------------------------
        MOV     DH,03H
@@ROW_LOOP:
        XOR     DL,DL
        MOV     AL,[SI+4]
        CALL    DISP_CHAR
        MOV     DL,9
        CALL    DISP_CHAR
        MOV     DL,57
        CALL    DISP_CHAR
        MOV     DL,79
        CALL    DISP_CHAR
        MOV     DL,33
        MOV     AL,'-'
        CALL    DISP_CHAR
        INC     DH
        CMP     DH,18
        JBE     @@ROW_LOOP


        POP     SI
        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET


DISP_WAKU ENDP

;**************************
;Edit部横枠表示
;
;       入力    なし
;       出力    なし
;       破壊    なし
;**************************
DISP_ROW_WAKU PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     DL,1
        MOV     AL,[SI+5]
        MOV     CX,8
        CALL    DISP_CHAR
        MOV     DL,10
        MOV     CX,47
        CALL    DISP_CHAR
        MOV     DL,58
        MOV     CX,21
        CALL    DISP_CHAR

        RET

DISP_ROW_WAKU ENDP
;**************************
;下部Window表示
;
;       入力    なし
;       出力    なし
;       破壊    なし
;**************************
DISP_UNDER_WINDOW PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        PUSH    SI
        MOV     BL,7
        CALL    GET_LANG_WAKU
;２０行目
;------------------------
        MOV     DH,19
        CALL    DISP_ROW_WAKU
        XOR     DL,DL
        MOV     CX,1
        MOV     AL,[SI+10]
        CALL    DISP_CHAR
        MOV     AL,[SI+7]
        MOV     DL,9
        CALL    DISP_CHAR
        MOV     DL,57
        CALL    DISP_CHAR
        MOV     AL,[SI+9]
        MOV     DL,79
        CALL    DISP_CHAR

;２１～２４行目
;------------------------
        MOV     DH,20
@@ROW2_LOOP:
        XOR     DL,DL
        MOV     AL,[SI+4]
        CALL    DISP_CHAR
        MOV     AL,20H
        INC     DX
        MOV     CX,78
        CALL    DISP_CHAR
        MOV     CX,1
        MOV     AL,[SI+4]
        MOV     DL,79
        CALL    DISP_CHAR
        INC     DH
        CMP     DH,23
        JBE     @@ROW2_LOOP

;２５行目
;------------------------
        MOV     DH,24
        MOV     AL,[SI+2]
        MOV     DL,0
        CALL    DISP_CHAR
        INC     DX
        MOV     CX,78
        MOV     AL,[SI+5]
        CALL    DISP_CHAR
        MOV     DL,79
        MOV     CX,1
        MOV     AL,[SI+3]
        CALL    DISP_CHAR

        POP     SI
        RET
DISP_UNDER_WINDOW ENDP


;**************************
;下部Window内ﾒｯｾｰｼﾞ表示(Edit)
;
;       入力    なし
;       出力    なし
;       破壊    なし
;**************************
DISP_UNDER_MSG_EDIT PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        PUSH    SI
        MOV     BL,7
        CALL    GET_LANG_WAKU

        .IF [INFO_PAGE]==0
            .IF [FLAG] & @FILE
                MOV     DX,23 SHL 8 OR 33
                MOV     DI,OFFSET KEY_MSG5
                CALL    DISP_MSG
            .ENDIF
            PUSH    OFFSET KEY_MSG4
            PUSH    OFFSET KEY_MSG3
            PUSH    OFFSET KEY_MSG2
            PUSH    OFFSET KEY_MSG1
        .ELSE
            PUSH    OFFSET KEY2_MSG4
            PUSH    OFFSET KEY2_MSG3
            PUSH    OFFSET KEY2_MSG2
            PUSH    OFFSET KEY2_MSG1
        .ENDIF
        MOV     BL,7
        MOV     DX,20 SHL 8 OR 1
        POP     DI
        CALL    DISP_MSG
        INC     DH
        POP     DI
        CALL    DISP_MSG
        INC     DH
        POP     DI
        CALL    DISP_MSG
        INC     DH
        POP     DI
        CALL    DISP_MSG

        MOV     DL,65
        MOV     DI,OFFSET KEY_MSG6
        CALL    DISP_MSG

        POP     SI
        RET

DISP_UNDER_MSG_EDIT ENDP

;**************************
;枠表示用文字列ｱﾄﾞﾚｽ取得
;
;       入力    なし
;       出力    SI      枠文字列
;       破壊    なし
;**************************
GET_LANG_WAKU PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     SI,OFFSET ENG_SEN
        TEST    [FLAG],@JAPAN
        JZ      @@LANG
        MOV     SI,OFFSET JPN_SEN
@@LANG:
        RET
GET_LANG_WAKU ENDP
;**************************
;表示モード判定
;
;       入力    なし
;       出力    なし
;       破壊    なし
;**************************
CHK_LANG PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        PUSH    AX
        PUSH    BX
        PUSH    DX
        PUSH    ES
        AND     [FLAG],NOT @JAPAN
;DOS/V FONT SUBSYSTEMの有無チェック
;---------------------
        MOV     AX,5000H
        MOV     BX,0100H
        MOV     DX,1010H
        XOR     BP,BP
        INT     15H
        JC      @@ENG      ;なし
    ASSUME  ES:NOTHING
;コードページが日本語かチェック
;----------------------
	MOV	AX,6601H
	INT	21H
	CMP     BX,3A4H
	JNE     @@ENG      ;日本語じゃない
        OR      CS:[FLAG],@JAPAN
@@ENG:
        POP     ES
    ASSUME  ES:CODE
        POP     DX
        POP     BX
        POP     AX
        RET

CHK_LANG ENDP

;**************************
;ﾃﾝﾎﾟﾗﾘﾌｧｲﾙ作成
;
;       入力    なし
;       出力    BX    ﾊﾝﾄﾞﾙ
;               CY    1)作成できない
;       破壊    なし
;**************************
CreateTmp PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     [TmpNumber],0

@@Loop:
        MOV     BX,OFFSET TMP_FILE_NAME
        CALL    GET_STREND
        MOV     AL,[TmpNumber]
        LEA     SI,[BX-2]
        CALL    IntToStr8

        MOV     AH,4EH
        MOV     DX,OFFSET TMP_FILE_NAME
        MOV     CX,22H
        INT     21H
        JC      @@Create

        ADD     [TmpNumber],1
        JNC     @@Loop
        RET

@@Create:
        MOV     AH,3CH
        XOR     CX,CX
        MOV     DX,OFFSET TMP_FILE_NAME
        INT     21H
        MOV     BX,AX
        RET

CreateTmp ENDP
;**************************
;ﾃﾝﾎﾟﾗﾘﾌｧｲﾙを閉じる
;
;       入力    なし
;       出力    なし
;       破壊    なし
;**************************
CloseTmp PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     BX,[EDIT_HANDLE]
        MOV     AH,3EH
        INT     21H

        MOV     DX,OFFSET TMP_FILE_NAME
        MOV     AH,41H
        INT     21H
        RET

CloseTmp ENDP
;****************************************
;
;     文字列の最終アドレスを求める
;
;     入力   BX   文字列ｱﾄﾞﾚｽ
;     出力   BX   文字列最終ｱﾄﾞﾚｽ
;     破壊   なし
;****************************************
GET_STREND PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

@@LOOP:
        CMP     BYTE PTR [BX],0
        JE      @@END
        INC     BX
        JMP     @@LOOP
@@END:
        RET

GET_STREND ENDP
;****************************************
;
;     文字列の長さを求める
;
;     入力   DI   文字列ｱﾄﾞﾚｽ
;     出力   CX   文字列の長さ
;     破壊   なし
;****************************************
StrLenDI PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        XOR     CX,CX
@@LOOP:
        CMP     BYTE PTR [DI],0
        JE      @@END
        INC     DI
        INC     CX
        JMP     @@LOOP
@@END:
        SUB     DI,CX
        RET

StrLenDI ENDP
;**************************
;32bit 16進変換
;
;       入力    EAX   変換値
;               SI    変換文字列格納ｱﾄﾞﾚｽ
;       出力    なし
;       破壊    なし
;**************************
IntToStr8 PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        ROL     AL,4
        CALL    HexStore4
        ROL     AL,4
        CALL    HexStore4
        MOV     BYTE PTR [SI],0
        RET

IntToStr8 ENDP
;**************************
;32bit 16進変換
;
;       入力    EAX   変換値
;               SI    変換文字列格納ｱﾄﾞﾚｽ
;       出力    なし
;       破壊    なし
;**************************
IntToStr32 PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        CALL    @@Store16
        CALL    @@Store16
        MOV     BYTE PTR [SI],0
        RET
@@Store16:
        CALL    @@Store8
@@Store8:
        ROL     EAX,4
        CALL    HexStore4
        ROL     EAX,4
HexStore4:
        PUSH    AX
        PUSH    BX
        MOV     BX,OFFSET HEX_DAT
        AND     AL,0FH
        XLAT    BYTE PTR CS:[BX]
        MOV     [SI],AL
        INC     SI
        POP     BX
        POP     AX
        RET

IntToStr32 ENDP
;**************************
;32bit 16進表示
;
;       入力    EAX   表示値
;               BL    アトリビュート
;               DX    表示開始位置
;       出力    DX    次の表示位置
;       破壊    なし
;**************************
DISP_HEX32    PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        ROR     EAX,16
        CALL    DISP_HEX16
        ROR     EAX,16

DISP_HEX32    ENDP
;**************************
;16bit 16進表示
;
;       入力    AX   表示値
;               BL    アトリビュート
;               DX    表示開始位置
;       出力    DX    次の表示位置
;       破壊    なし
;**************************
DISP_HEX16    PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        XCHG    AL,AH
        CALL    DISP_HEX8
        XCHG    AL,AH

DISP_HEX16    ENDP
;**************************
;8bit 16進表示
;
;       入力    AL    表示値
;               BL    アトリビュート
;               DX    表示開始位置
;       出力    DX    次の表示位置
;       破壊    なし
;**************************
DISP_HEX8    PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        ROL     AL,4
        CALL    DISP_HEX_SUB
        ROL     AL,4

DISP_HEX_SUB:

        PUSH    AX
        PUSH    CX
        PUSH    BX
        MOV     BX,OFFSET HEX_DAT
        AND     AL,0FH
        XLAT    BYTE PTR CS:[BX]
        POP     BX
        MOV     CX,1
        CALL    DISP_CHAR
        INC     DX
        POP     CX
        POP     AX
        RET

DISP_HEX8    ENDP

;**************************
;DOS文字列表示
;
;       入力    DS:DI    メッセージアドレス
;       破壊    なし
;**************************
DISP_DOS_MSG    PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        PUSH    DX
@@Loop:
        MOV     DL,[DI]
        TEST    DL,DL
        JZ      @@END
        MOV     AH,02H
        INT     21H
        INC     DI
        JMP     @@Loop
@@END:
        POP     DX
        RET

DISP_DOS_MSG    ENDP
;**************************
;文字列表示
;
;       入力    DS:DI    メッセージアドレス
;               BL    アトリビュート
;               DX    表示開始位置
;       破壊    なし
;**************************
DISP_MSG    PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        PUSH    DX
        CALL    DISP_MSG2
        POP     DX
        RET

DISP_MSG    ENDP

;**************************
;文字列表示
;
;       入力    DS:DI    メッセージアドレス
;               BL    アトリビュート
;               DX    表示開始位置
;       出力    DX    表示終了位置
;               DI    ﾒｯｾｰｼﾞ終了ｱﾄﾞﾚｽ
;**************************
DISP_MSG2    PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        PUSH    AX
        PUSH    CX
        MOV     CX,1
@@MSG_LOOP:
        MOV     AL,[DI]
        TEST    AL,AL
        JZ      @@END

        CALL    DISP_CHAR
        INC     DI
        INC     DL
        JMP     @@MSG_LOOP
@@END:
        POP     CX
        POP     AX
        RET

DISP_MSG2    ENDP
;**************************
;文字表示
;
;       入力    AL    表示キャラクタコード
;               BL    アトリビュート
;               CX    表示回数
;               DX    表示開始位置
;       破壊    なし
;**************************
DISP_CHAR    PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        PUSH    DX

        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DS
        MOV     DS,CS:[DATA_SEL]
    ASSUME  DS:DATA
        MOV     DS:[450H],DX
        POP     DS
    ASSUME  DS:NOTHING
        POP     CX
        POP     BX
        POP     AX

        PUSH    AX
        PUSH    BX
        PUSH    CX
        XOR     BH,BH
        MOV     Ah,09H
        INT     10H
        POP     CX
        POP     BX
        POP     AX
        POP     DX
        RET

DISP_CHAR    ENDP

;**************************
;ｶｰｿﾙ位置を画面の左上に設定する
;
;       入力    なし
;       破壊    なし
;**************************
SET_CURSOR_HOME    PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        PUSH    DS
        MOV     DS,CS:[DATA_SEL]
    ASSUME  DS:DATA
        MOV     WORD PTR DS:[450H],0
        POP     DS
    ASSUME  DS:NOTHING
        RET

SET_CURSOR_HOME   ENDP
;********************************************************
;	DEMO用PCIﾃﾞﾊﾞｲｽIRQｴﾝﾄﾘ
;
;	INPUT	なし
;	OUTPUT  なし
;	BREAK	なし
;
;********************************************************
INT24_ENTRY PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        TEST    AH,1 SHL 3
        JZ      @@ORIGINAL

        MOV     AL,03H
        IRET

@@ORIGINAL:

        JMP     DWORD PTR CS:[INT24_VECTOR]

INT24_ENTRY ENDP
;********************************************************
;	INT24h用ﾍﾞｸﾀ取得
;
;	INPUT	なし
;	OUTPUT  なし
;	BREAK
;
;********************************************************
GET_INT24 PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        TEST    [FLAG],@DPMI
        JNZ     @@DPMI

;Real,VCPI,File用
;-------------------
    ;元のﾍﾞｸﾀｱﾄﾞﾚｽ取得
    ;------------------
        PUSH    ES
        MOV     AX,3524H
        INT     21H
    ASSUME ES:NOTHING
        MOV     [INT24_VECTOR],BX
        MOV     [INT24_VECTOR+2],ES
        POP     ES
    ASSUME  ES:CODE
    ;ﾍﾞｸﾀ乗っ取り
    ;----------------------
        MOV     DX,OFFSET INT24_ENTRY
        MOV     AX,2524H
        INT     21H
        JMP     @@HOOKED

;DPMI用
;--------------------
@@DPMI:
    ;元のﾍﾞｸﾀｱﾄﾞﾚｽ取得
    ;-------------------
        MOV     AX,0204H
        MOV     BL,24H
        INT     31H
        MOV     [INT24_VECTOR],DX
        MOV     [INT24_VECTOR+2],CX

    ;ﾍﾞｸﾀ乗っ取り
    ;-----------------
        MOV     AX,0205H
        MOV     BL,24H
        MOV     CX,CS
        MOV     DX,OFFSET INT24_ENTRY
        INT     31H
        JC      @@ERROR

@@HOOKED:
        OR      [FLAG],@HOOKED_INT24
@@END:
        RET
@@ERROR:
        MOV     DX,OFFSET CANT_GET_INT24_MSG
        STC
        RET

GET_INT24 ENDP
;********************************************************
;	INT24h開放
;
;	INPUT	なし
;	OUTPUT  なし
;	BREAK
;
;********************************************************
FREE_INT24 PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        PUSH    DS
        TEST    [FLAG],@HOOKED_INT24
        JZ      @@END

        AND     [FLAG],NOT @HOOKED_INT24

        TEST    [FLAG],@DPMI
        JNZ     @@DPMI

;Real,VCPI,File用ﾍﾞｸﾀ開放
;----------------------
        LDS     DX,DWORD PTR [INT24_VECTOR]
    ASSUME  DS:NOTHING
        MOV     AX,2524H
        INT     21H
        JMP     @@END

;DPMI用INT開放
;---------------------------
@@DPMI:
    ASSUME  DS:CODE

        MOV     AX,0205H
        MOV     BL,24H
        MOV     CX,[INT24_VECTOR+2]
        MOV     DX,[INT24_VECTOR]
        INT     31H
@@END:
        POP     DS
    ASSUME  DS:CODE
        RET
FREE_INT24 ENDP

;********************************************************
;	ｺﾏﾝﾄﾞﾗｲﾝ ﾊﾟﾗﾒｰﾀ取得
;
;	INPUT	なし
;	OUTPUT  CY     0)正常   1)正しいﾊﾟﾗﾒｰﾀではない
;	BREAK	AX,BX,CX,EDX
;
;********************************************************
GET_CMDLIN PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        MOV     SI,OFFSET CMDLIN
@@ARG_LOOP:
        CALL    GET_ARG
        JCXZ    @@GET_ARG_END

        CMP     BYTE PTR [SI],'/'
        JE      @@GET_OPTION

        INC     [ARG_NUM]

        CMP     BYTE PTR [SI],'@'
        JE      @@GET_FILENAME

        CALL    GET_HEX_VALUE
        JC      @@USAGE
        MOV     DWORD PTR [EDIT_ADRS],EAX
        JMP     @@ARG_LOOP

@@GET_FILENAME:

        INC     SI
        DEC     CX
        JZ      @@USAGE
        MOV     DI,OFFSET EDIT_FILE_NAME
        REP     MOVSB
        MOV     BYTE PTR [DI],0
        OR      [FLAG],@FILE
        JMP     @@ARG_LOOP

@@GET_OPTION:
        INC     SI
        DEC     CX
        JZ      @@USAGE
        MOV     AL,[SI]
        ADD     SI,CX
        AND     AL,0DFH
        JMP     @@USAGE
        JMP     @@ARG_LOOP

@@GET_ARG_END:

        CLC
        RET

@@USAGE:
        STC
        RET

GET_CMDLIN ENDP
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
GET_ARG	PROC	NEAR

    ASSUME  DS:CODE,ES:CODE

	XOR	CX,CX

;ﾊﾟﾗﾒｰﾀの前の空白文字を読み飛ばす
;-----------------------
        .REPEAT
            LODSB
            CMP     AL,0DH
            JE      @@END
        .UNTIL (AL!=' ') && (AL!=9)

;ﾊﾟﾗﾒｰﾀの文字数取得
;-------------------------
	DEC	SI
	PUSH	SI
        .REPEAT
            LODSB
            .BREAK .IF AL == 0DH
            .BREAK .IF AL == ' '
        .UNTILCXZ (AL==9)
	NEG	CX
	POP	SI
@@END:
	RET

GET_ARG	ENDP
;***********************************************
;
;       ｺﾏﾝﾄﾞﾗｲﾝより値取得
;
;	入力	DS:SI	ﾊﾟﾗﾒｰﾀ開始ｱﾄﾞﾚｽ
;		CX	最大文字数
;	出力
;               SI      入力 SI+CX
;               EAX     読み込んだ値
;               CX      値の桁数
;               CY      0)取得できた 1)取得できない
;	破壊	EDX
;***********************************************
GET_HEX_VALUE  PROC NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        JCXZ    @@ERROR
        XOR     EAX,EAX
        XOR     EDX,EDX
@@HEX_LOOP:
        MOV     DL,[SI]
        TEST    DL,DL
        JZ      @@END
        CMP     DL,' '
        JE      @@END
        CMP     DL,9
        JE      @@END

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

        ROL     EAX,4
        TEST    AL,00FH
        JNZ     @@ERROR

        ADD     EAX,EDX
        LOOP    @@HEX_LOOP

@@END:
        CLC
        RET

@@ERROR:
        STC
        RET

GET_HEX_VALUE  ENDP
;****************************************
;
;ﾊﾞｯｸｱｯﾌﾟﾌｧｲﾙ名作成
;
;
;****************************************
MAKE_BACKUP_FILENAME PROC NEAR

    ASSUME  DS:CODE

        MOV     SI,OFFSET EDIT_FILE_NAME
        MOV     DI,OFFSET BACK_FILE_NAME
        CALL    COPY_STR
        MOV     DX,DI
@@SearchPeriod:
        DEC     DI
        CMP     BYTE PTR [DI],'.'
        JE      @@FoundPeriod
        CMP     BYTE PTR [DI],'\'
        JE      @@NotFoundPeriod
        CMP     DI,OFFSET BACK_FILE_NAME
        JA      @@SearchPeriod
@@NotFoundPeriod:
        MOV     DI,DX
        DEC     DI
        MOV     BYTE PTR [DI],'.'
@@FoundPeriod:
        INC     DI
        MOV     DWORD PTR [DI],'KAB'
        RET

MAKE_BACKUP_FILENAME ENDP
;****************************************
;
;ﾃﾝﾎﾟﾗﾘﾌｧｲﾙ名作成
;
;
;****************************************
SET_TMP_NAME PROC NEAR

    ASSUME  DS:CODE,ES:CODE

        CALL    GET_ENV
        MOV     SI,OFFSET TMP_NAME
COPY_STR:
        MOV     AL,[SI]
        MOV     [DI],AL
        INC     SI
        INC     DI
        TEST    AL,AL
        JNZ     COPY_STR
	RET

SET_TMP_NAME ENDP
;********************************************************
;	環境変数取得
;
;	INPUT	なし
;	OUTPUT  DI     ﾃﾝﾎﾟﾗﾘﾌｧｲﾙﾊﾟｽの最終ｱﾄﾞﾚｽ
;	BREAK
;********************************************************
GET_ENV PROC NEAR

        MOV     SI,OFFSET TEMP_ENV_NAME
        MOV     DI,OFFSET TMP_FILE_NAME
        MOV     CX,SIZE TMP_FILE_NAME-1
        CALL    GET_ENV_STR
        JC      @@ERROR

        DEC     DI
        MOV     AL,[DI-1]
        CMP     AL,':'
        JE      @@END
        CMP     AL,'\'
        JE      @@END
        MOV     WORD PTR [DI],'\'
        INC     DI
@@END:
        RET
@@ERROR:
        MOV     DI,OFFSET TMP_FILE_NAME
        MOV     BYTE PTR [DI],0
        RET

GET_ENV ENDP
;********************************************************
;
;      GET ENVIOMENT STRING
;
;              INPUT   DS:SI...SEARCH STRING ADDRESS
;                      DS:DI...STRING STORE ADDRESS
;                      CX......STRING LENGTH
;              OUTPUT  CY=0...FOUND & STORE
;                      CY=1
;                        AH=1...NOT FOUND
;                        AH=2...STRING TOO LONG
;              BREAK   AL
;********************************************************
GET_ENV_STR     PROC    NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        PUSH    ES
        CALL    SEARCH_ENV
    ASSUME  ES:NOTHING
        JC      @@NOT_FOUND
        .REPEAT
@@LOOP:
            MOV     AL,ES:[BX]
            MOV     [DI],AL
            INC     BX
            INC     DI
        .UNTILCXZ !(AL & AL)
        JNZ     @@TOO_LONG
        CLC
@@EXIT:
        POP     ES
    ASSUME  ES:NOTHING
        RET

@@NOT_FOUND:
        MOV     AH,1
        JMP     @@ERROR
@@TOO_LONG:
        MOV     AH,2
@@ERROR:
        STC
        JMP     @@EXIT

GET_ENV_STR     ENDP
;******************************************************************************
;
;指定環境変数を取得
;
;              INPUT   DS:SI   取得する環境変数名
;              OUTPUT  CY=0    見つけた
;                      ES:BX   環境変数の内容
;                      CY=1    見つからない
;                      ES:BX   環境変数最後のアドレス
;              BREAK   AX
;******************************************************************************
SEARCH_ENV              PROC    NEAR

    ASSUME  DS:NOTHING,ES:NOTHING

        MOV     ES,CS:[02CH]    ;環境変数セグメント
    ASSUME  ES:NOTHING
        XOR     BX,BX           ;   〃   オフセット

        .REPEAT
            PUSH    SI
            ;環境変数名が一致するか？
            ;--------------------
            .REPEAT
                MOV     AL,ES:[BX]
                MOV     AH,[SI]
                INC     BX
                INC     SI
                .IF AX == '='
                    .BREAK .IF AH & AH
                    ;見つけた
                    ;-------------------
                    POP     SI
                    CLC
                    RET
                .ENDIF
                .BREAK .IF !(AH & AH)
            .UNTIL AL!=AH
            POP     SI

            ;違う環境変数なので、残りの文字列を読み飛ばす
            ;----------------------
            .REPEAT
                CMP     BYTE PTR ES:[BX],0
                JE      @@ChkEnvEnd
                INC     BX
            .UNTIL !ZERO?
            STC
            RET
@@ChkEnvEnd:
            INC     BX
        .UNTIL BYTE PTR ES:[BX]==0
        STC
        RET

SEARCH_ENV      ENDP

;********************************
;CPU動作ﾓｰﾄﾞﾁｪｯｸ
;
;    入力    なし
;    出力    CY     1)動作できない
;    破壊    AX,BX,CX,DX
;********************************
CHK_CPU_MODE	PROC	NEAR PUBLIC

    ASSUME  DS:CODE,ES:CODE

         MOV     [DSEL_CODE],CS

         TEST    [FLAG],@FILE
         JNZ     @@FILE_MODE

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

         MOV     WORD PTR [DPMI_ENTRY],DI
         MOV     WORD PTR [DPMI_ENTRY+2],ES
         MOV     [DPMI_VER],DX
         MOV     [ADRS_FLG],BX
         MOV     [CPU_TYPE],CL
         MOV     [PRVDT_SZ],SI

         MOV     DX,OFFSET ERROR_CPU
         CMP     CL,3
         JB      @@CANT_RUN         ;CPUが80386より前のものである

         PUSH    DS
         POP     ES
    ASSUME  ES:CODE
         TEST    SI,SI
         JZ      @@NO_PRVDT
         MOV     AH,48H             ;Memory Allocate
         MOV     BX,SI              ;  for DPMI Private Data Segment
         INT     21H                ;
         MOV     DX,OFFSET ERROR_MEMORY
         JC      @@CHK_VCPI
@@NO_PRVDT:
         MOV     [PRVDT_SEG],AX       ;  AX=MCB
         MOV     ES,[PRVDT_SEG]
    ASSUME  ES:NOTHING
         MOV     AX,0000H
         CALL    [DPMI_ENTRY]
         MOV     DX,OFFSET ERROR_DPMI_PROT
         JC      @@CANT_RUN

         PUSH    DS
         POP     ES
    ASSUME  ES:CODE
         MOV     [DSEL_CODE],DS

         MOV     AX,0400H
         INT     31H
         MOV     [DPMI_VER],AX
         MOV     [MPIC_VECT_NO],DH
         MOV     [SPIC_VECT_NO],DL

         MOV     AX,0
         MOV     CX,2
         INT     31H
         JC      @@DPMI_FUNC_ERROR
         MOV     BX,AX
         MOV     [DATA_SEL],AX

         PUSH    BX
         MOV     CX,0FFFFH
         MOV     DX,0FFFFH
         MOV     AX,8
         INT     31H
         POP     BX
         JC      @@DPMI_FUNC_ERROR

         MOV     AX,9
         MOV     CX,8093H
         INT     31H
         JC      @@DPMI_FUNC_ERROR

         MOV     AX,3
         INT     31H
         JC      @@CANT_RUN
         MOV     BX,[DATA_SEL]
         ADD     BX,AX
         MOV     [DUMP_SEL],BX

         MOV     AX,8
         MOV     CX,-1
         MOV     DX,-1
         INT     31H
         JC      @@DPMI_FUNC_ERROR

         MOV     AX,9
         MOV     CX,8093H
         INT     31H
         JC      @@DPMI_FUNC_ERROR

         OR      [FLAG],@DPMI
         RET

;VCPIをｻﾎﾟｰﾄするかﾁｪｯｸ
;-----------------------
@@CHK_VCPI:

    ASSUME  ES:NOTHING
        PUSH    CS
        POP     ES
    ASSUME  ES:CODE

;EMM386が存在するか？
;-----------------------
        PUSH    DS
        XOR     AX,AX
        MOV     DS,AX
    ASSUME  DS:NOTHING
        MOV     DS,WORD PTR DS:[67H*4+2]
        MOV     AX,WORD PTR DS:[0AH]
        MOV     CL,BYTE PTR DS:[0AH+2]
        POP     DS
    ASSUME  DS:CODE
        MOV     DX,OFFSET ERROR_EMM
        CMP     AX,'ME'
        JNE     @@CANT_RUN
        CMP     CL,'M'
        JNE     @@CANT_RUN

        MOV     AH,40H
        INT     67H
        MOV     DX,OFFSET ERROR_EMM
        OR      AH,AH
        JNZ     @@CANT_RUN
;@@@ File Handle方式は、EMSメモリ無しでEMM386を組み込んだ時、通用しない
;        MOV     DX,OFFSET EMM_NAME
;        MOV     AX,3D00H
;        INT     21H
;        MOV     DX,OFFSET ERROR_EMM
;        JC      @@CANT_RUN	;ファイルがない
;        MOV     BX,AX
;        MOV     AX,4400H
;        INT     21H
;        MOV     AX,DX
;        MOV     DX,OFFSET ERROR_EMM
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
        MOV     DX,OFFSET ERROR_DRV
        TEST    AH,AH
        JNZ     @@CANT_RUN      ;VCPI無し

    ;VCPI情報取得
    ;-------------------------
        MOV     AX,CS
        MOVZX   DX,AH
        SHL     AX,4
        SHR     DL,4
        ADD     AX,OFFSET PAGE_TBL_BUF+0FFFH
        ADC     DL,0
        AND     AX,0F000H
        MOV     WORD PTR [VCPI_PROTECT_TBL],AX
        MOV     BYTE PTR [VCPI_PROTECT_TBL+2],DL
        MOV     [DSEG_PAGE].BASE,AX
        MOV     [DSEG_PAGE].HIBASE,DL
        MOV     [DSEG_DUMP].LIMIT,0FFFFH
        MOV     [DSEG_DUMP].BASE,0
        MOV     [DSEG_DUMP].HIBASE,40H
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
        MOV     SI,OFFSET VCPI_DESC
        MOV     AX,0DE01H
        INT     67H
        PUSH    CS
        POP     ES
    ASSUME  ES:CODE
        MOV     DX,OFFSET ERROR_VCPI
        TEST    AH,AH
        JNZ     @@CANT_RUN      ;取得できず

        MOV     [CODE_SEG],CS
        MOV     [VCPI_ENTRY],EBX
        OR      [FLAG],@VCPI

@@REAL_MODE:

    ASSUME  DS:CODE,ES:CODE
        CALL    MAKE_GDT
        CLC
        RET

;ﾌｧｲﾙ編集ﾓｰﾄﾞである
;-----------------------
@@FILE_MODE:

    ASSUME  DS:CODE,ES:CODE

   ;編集ﾌｧｲﾙをﾃﾝﾎﾟﾗﾘﾌｧｲﾙにｺﾋﾟｰする
   ;----------------------------
        ;ﾃﾝﾎﾟﾗﾘﾌｧｲﾙ作成
        ;-----------------------
        CALL    CreateTmp
        JC      @@CantCreateTmp
        MOV     [EDIT_HANDLE],BX

        ;編集ﾌｧｲﾙを開く
        ;-----------------------
        MOV     [ORG_HANDLE],0
        MOV     DX,OFFSET EDIT_FILE_NAME
        MOV     AX,3D20H
        INT     21H
        JNC     @@FileCopy
        CMP     AX,2
        JE      @@FileEnd
        JMP     @@CantOpenFile
@@FileCopy:
        ;ｺﾋﾟｰ
        ;-------------------------
        MOV     [ORG_HANDLE],AX
@@CopyLoop:
        MOV     AH,3FH
        MOV     BX,[ORG_HANDLE]
        MOV     CX,FILE_BUF_SIZE
        MOV     DX,OFFSET FILE_BUF
        INT     21H
        TEST    AX,AX
        JZ      @@FileClose

        MOV     DX,OFFSET FILE_BUF
        MOV     CX,AX
        MOV     BX,[EDIT_HANDLE]
        MOV     AH,40H
        INT     21H
        CMP     AX,CX
        JE      @@CopyLoop
@@FileClose:
        MOV     AH,3EH
        MOV     BX,[ORG_HANDLE]
        INT     21H

@@FileEnd:
        CLC
        RET



@@CantOpenFile:

        MOV     DI,OFFSET CantOpenFileMsg
        CALL    DISP_DOS_MSG
        MOV     DL,'('
        MOV     AH,2
        INT     21H
        MOV     DI,OFFSET EDIT_FILE_NAME
        CALL    DISP_DOS_MSG
        MOV     DL,')'
        MOV     AH,2
        INT     21H
        MOV     DX,OFFSET CRLF_MSG
        JMP     @@CANT_RUN

@@CantCreateTmp:

        MOV     DX,OFFSET CantCreateTmpMsg
        JMP     @@CANT_RUN

@@DPMI_FUNC_ERROR:
        MOV     DX,24 SHL 8
        MOV     BL,07H
        CALL    DISP_HEX16
        INC     DX
        MOV     AL,' '
        CALL    DISP_CHAR
        MOV     DX,OFFSET ERROR_DPMI
@@CANT_RUN:
        STC
        RET



CHK_CPU_MODE	ENDP
;********************************
;GDT作成
;********************************
MAKE_GDT	PROC	NEAR

    ASSUME  DS:CODE,ES:CODE

        ;GDTﾃｰﾌﾞﾙの初期化
        ;------------------------
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

    ASSUME  DS:CODE,ES:CODE

        TEST    [FLAG],@DPMI OR @FILE
        JNZ     @@END

        PUSH    AX
        PUSH    BX
        PUSH    DS
        PUSH    ES

;A20が既にOnになっている場合は、何もしない
;---------------------
        XOR     AX,AX
        MOV     ES,AX
    ASSUME  ES:DATA
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
    ASSUME  ES:DATA
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
        PUSH    OFFSET @@RET_HIMEM
        PUSH    ES
        PUSH    BX
        MOV     AH,3
        RETF
@@RET_HIMEM:
        TEST    AX,AX
        JZ      @@A20_DIRECT

@@A20_ON_END:
        POP     ES
    ASSUME  ES:CODE
        POP     DS
    ASSUME  DS:CODE
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
    ASSUME  ES:CODE
        POP     DS
    ASSUME  DS:CODE
        POP     BX
        POP     AX
        RET

A20_ON ENDP

VCPI_PROTECT_TBL LABEL BYTE

        DW      PAGE_TBL_BUF,0   ;CR3
        DW      GDTR_PARA,0
        DW      IDTR_PARA,0
        DW      0                ;LDTR
        DW      TSS_SEL       ;TR
        DW      VCPI_ENTER_PROTECT,0,CSEL16

IDTR_PARA LABEL FWORD
        DW      3FFh
        DW      0,0

GDTR_PARA LABEL	FWORD
	DW	GDT_END-GDT-1	; LIMIT
	DW	GDT,0

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
TSS_DESC  DESC<SIZE PROTECT_TSS-1,PROTECT_TSS,000h,89h,00h,000h> ;TSS
CSEG16    DESC<0FFFFH,0000h,000H,9BH,10H,000H> ;Code
DSEG      DESC<0FFFFH,0000h,000H,93H,10H,000H> ;Data(Code)
DSEG_DUMP DESC<0FFFFH,0000h,000H,93H,9FH,000H> ;Data Dump Area
DSEG_FFFF DESC<0FFFFH,0000h,000H,93H,10H,000H> ;Data First 64KB
DSEG_FULL DESC<0FFFFH,0000h,000H,93H,9FH,000H> ;Data Full
DSEG_PAGE DESC<03FFFH,0000h,000h,93h,10h,000h> ;Data Page Table
VCPI_DESC LABEL BYTE
          DESC<>                               ;VCPI Interface's Code Segment
          DESC<>                               ;for main control program
          DESC<>                               ;for main control program
GDT_END  LABEL   BYTE

TSS_SEL   EQU TSS_DESC-GDT
CSEL16    EQU CSEG16-GDT
DSEL      EQU DSEG-GDT
DSEL_DUMP EQU DSEG_DUMP-GDT
DSEL_FFFF EQU DSEG_FFFF-GDT
DSEL_FULL EQU DSEG_FULL-GDT
DSEL_PAGE EQU DSEG_PAGE-GDT
CSEL_VCPI EQU VCPI_DESC-GDT

DPMI_ENTRY   DD   ?
DPMI_VER     DW   ?
ADRS_FLG     DW   ?
CPU_TYPE     DB   ?
PRVDT_SZ     DW   ?
PRVDT_SEG    DW   ?
DUMP_SEL     DW   DSEL_DUMP
DSEL_CODE    DW   ?
DATA_SEL     DW   0
VCPI_ENTRY   DD   ?
             DW   CSEL_VCPI
STACK_BAK    DW   ?
CODE_SEG     DW   ?
PAGE_SEG     DW   ?
MPIC_VECT_NO DB   8
SPIC_VECT_NO DB   70H

ACCESS_AREA  DD   ?,?

INT24_VECTOR DW   0,0

TmpNumber    DB   0          ;ﾃﾝﾎﾟﾗﾘﾌｧｲﾙ番号
FROM_HANDLE  DW   0          ;ｺﾋﾟｰ元ﾌｧｲﾙﾊﾝﾄﾞﾙ
TO_HANDLE    DW   0          ;ｺﾋﾟｰ先ﾌｧｲﾙﾊﾝﾄﾞﾙ
ORG_HANDLE   DW   0          ;ﾊﾞｲﾅﾘﾌｧｲﾙ編集するﾌｧｲﾙのﾊﾝﾄﾞﾙ
EDIT_HANDLE  DW   0          ;ﾊﾞｲﾅﾘﾌｧｲﾙ編集用ﾃﾝﾎﾟﾗﾘﾌｧｲﾙのﾊﾝﾄﾞﾙ
EDIT_LIMIT   DW   0,FILE_BUF_SIZE
EDIT_ADRS    DD   0
EDIT_OFFSET  DW   0,0
CURSOR       DB   0,0
CURSOR_BAK   DW   0
CURSOR_SHAPE DW   0

FLAG         DW   0
@JAPAN       EQU 1 SHL 0   ;日本語表示モードである
@KANJI       EQU 1 SHL 1   ;前回表示した文字は、漢字第一バイト目である
@EDIT        EQU 1 SHL 2   ;値入力中
@UPDATE      EQU 1 SHL 3   ;ﾒﾓﾘ内容表示更新要求
@DPMI        EQU 1 SHL 4   ;DPMIでﾒﾓﾘｱｸｾｽ
@VCPI        EQU 1 SHL 5   ;VCPIでﾒﾓﾘｱｸｾｽ
@UPDATE_ADRS EQU 1 SHL 6   ;ｱﾄﾞﾚｽ表示更新要求
@POLLING     EQU 1 SHL 9   ;ﾎﾟｰﾘﾝｸﾞ表示
@UPDATE_CURSOR EQU 1 SHL 10;ｶｰｿﾙ位置更新
@FILE        EQU 1 SHL 11  ;ﾌｧｲﾙに対して編集を行う
@HOOKED_INT24 EQU 1 SHL 12 ;INT24h取得済み
@UPDATE_ALL  EQU 1 SHL 13  ;画面全体更新要求
@EDITED      EQU 1 SHL 14  ;ﾒﾓﾘ書き換え有り

INFO_PAGE    DB  0


EDIT_MODE    DB  @EDIT_HEX
@EDIT_ADRS   EQU 0   ;ｱﾄﾞﾚｽ入力中
@EDIT_HEX    EQU 1   ;16進入力中
@EDIT_CHAR   EQU 2   ;文字直接入力中
@EDIT_MAX    EQU 2   ;入力ﾓｰﾄﾞ最大値

CurItem      DW  0
ENTER_MODE   DB  0
@ENTER_STR   EQU 0   ;ﾌｧｲﾙ名入力
@ENTER_HEX   EQU 1   ;開始ｱﾄﾞﾚｽ入力
ENTER_LEN    DW  0

ENTER_INFO   DW  ?   ;入力Window情報ｱﾄﾞﾚｽ
SEARCH_LEN   DW  ?   ;検索文字列の長さ
FILL_LEN     DW  ?   ;埋め尽くす文字列の長さ

DAT_SIZE     DB   @DAT_BYTE
             DB   3 DUP(?)
@DAT_BYTE    EQU  1
@DAT_WORD    EQU  2
@DAT_DWORD   EQU  4

ARG_NUM      DB   0

TMP_NAME       DB 'MEMORY.$00',0
TEMP_ENV_NAME  DB 'TEMP',0
EMM_NAME DB    'EMMXXXX0',0
JPN_SEN  DB    001H,002H,003H,004H,005H,006H,010H,015H,016H,017H,019H
ENG_SEN  DB    0C9H,0BBH,0C8H,0BCH,0BAH,0CDH,0CEH,0CAH,0CBH,0B9H,0CCH
HEX_DAT  DB    '0123456789ABCDEF'
ADRS_MSG DB    'Address',0
CHAR_MSG DB    'Character',0
KEY_MSG1 DB    'Alt-X:Exit  Esc:Cancel  Enter:Set  Tab:ChangeWindow',0
KEY_MSG2 DB    'Alt-1:Byte   Alt-L:ReadFromFile Alt-F:Fill',0
KEY_MSG3 DB    'Alt-2:Word   Alt-W:WriteToFile  Alt-S:Search  Alt-N:SearchNext',0
KEY_MSG4 DB    'Alt-4:DWord  Alt-P:Polling',0

KEY_MSG5 DB    'Alt-U:SaveEditingFile',0
KEY_MSG6 DB    'Alt-M:MoreInfo',0

KEY2_MSG1 DB   '           PgUp/Dn:   -100h,+100h',0
KEY2_MSG2 DB   '     Shift-PgUp/Dn:  -1000h,+1000h',0
KEY2_MSG3 DB   '      Ctrl-PgUp/Dn: -10000h,+10000h',0
KEY2_MSG4 DB   'Shift-Ctrl-PgUp/Dn:-100000h,+100000h',0

FREAD_MSG1 DB  ' Read File Name:',0
FREAD_MSG2 DB  ' File Read Area:          -',0
FREAD_MSG4 DB  ' Enter:Read File   Esc:Cancel  Tab,Shift-Tab:ChangeItem',0

FWRITE_MSG1 DB ' Write File Name:',0
FWRITE_MSG2 DB ' File Write Area:          -',0
FWRITE_MSG4 DB ' Enter:Write File  Esc:Cancel  Tab,Shift-Tab:ChangeItem',0

FILL_MSG1 DB   " Fill Data(Hex or 'Str'): ",0
FILL_MSG2 DB   ' Fill Area:          -',0
FILL_MSG4 DB   ' Enter:Fill  Esc:Cancel  Tab,Shift,Tab:ChangeItem',0

SEARCH_MSG1 DB   " Search Data(Hex or 'Str'): ",0
SEARCH_MSG2 DB   ' Search Area:          -',0
SEARCH_MSG4 DB   ' Enter:Search  Esc:Cancel  Tab,Shift,Tab:ChangeItem',0


FSAVE_MSG1 DB ' Save File Name:',0
FSAVE_MSG2 DB ' File Save Area:          -',0
FSAVE_MSG4 DB ' Enter:Save & Exit  Esc:Cancel  Tab,Shift-Tab:ChangeItem',0

HitAnyKeyMsg      DB 'Hit Any Key',0
MsgFileName       DB  'File Name:',0
MsgEscCancel      DB  'Esc : Cancel',0
MsgNotFound       DB  'Not Found',0
MsgNotHexString   DB  'Error Not Hex String',0
MsgMissingEndQuate DB 'Error Missing End Quate',0
CantWriteFileMsg  DB "Can't Write File",0
CantCreateFileMsg DB "Can't Create File",0
CantOpenFileMsg   DB "Can't Open File",0
ErrorRangeMsg     DB 'Start address is bigger than end address',0
FileNotFoundMsg   DB "File Not Found",0
ReadingFileMsg    DB 'Reading File...',0
WritingFileMsg    DB 'Writing File...',0
MsgSearching      DB 'Searching...',0
MsgSearchAdrs     DB '00000000',0

ERROR_VCPI   DB 'Error in VCPI Function 1 or 0Ch',13,10,'$'
ERROR_DPMI   DB 'Error in DPMI Function 2,7,8,9 or 800h'
CRLF_MSG     DB 13,10,'$'
CantCreateTmpMsg DB "Can't Create Tmpolary File",13,10,'$'

MEM_BUF LABEL BYTE
USAGE_MSG DB   'Memory Dump for IBM PC-AT 2001/8/10 by SUGAWARA',13,10
          DB   'Usage MEMORY [Address] [@xxxx]',13,10
          DB   13,10
          DB   '    [Address]   Dump Start Address',13,10
          DB   '    [@xxxx]     xxxx is Dump File Name',13,10
          DB   13,10
          DB   '  This Program must be running on Real Mode or needs VCPI or DPMI.',13,10
          DB   '$'
ERROR_MEMORY DB 'Out Of Memory(needs 32KB or more)',13,10,'$'
ERROR_DRV    DB 'This V86 driver not supported VCPI or DPMI',13,10,'$'
ERROR_CPU    DB 'Not Support 80286 or before',13,10,'$'
ERROR_EMM    DB "Could not found EMM386 by vector law",13,10,'$'
ERROR_VCPI_PROT DB "VCPI can't enter protect mode",13,10,'$'
ERROR_DPMI_PROT DB "DPMI can't enter protect mode",13,10,'$'
CANT_GET_INT24_MSG DB "Could not Hook INT24h Vector",13,10,'$'

 MEM_BUF_COUNT = 256+5 - ($ - MEM_BUF)
 IF MEM_BUF_COUNT GT 0
   DB   MEM_BUF_COUNT DUP (?)
 ENDIF


PROTECT_TSS   DD 26 DUP(?)
PAGE_TBL_BUF  DB 4096*4 DUP(?)
EDIT_FILE_NAME  DB 128 DUP(?)
BACK_FILE_NAME  DB 128 DUP(?)
TMP_FILE_NAME   DB 64 DUP(?)
FILE_NAME       DB 64 DUP(?)
FILL_STR        DB 64 DUP(?)
FILL_VAL        DW ?
                DB 64 DUP(?)
SEARCH_STR      DB 64 DUP(?)
SEARCH_VAL      DW ?
                DB 64 DUP(?)
SEARCH_AREA     DD   ?,?
StartTimer      DW ?
CurTimer        DW ?
START_ADRS_STR  DB 9 DUP(?)
END_ADRS_STR    DB 9 DUP(?)
FillEndAdrsStr  DB 9 DUP(?)
SearchEndAdrsStr DB 9 DUP(?)
FILE_BUF        DB FILE_BUF_SIZE+4 DUP(?)
STACK_TOP     DW 512 DUP(?)
STACK_BOTTOM LABEL WORD

CODE ENDS
     END MAIN
