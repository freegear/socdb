;------------------------------------------------------------------------------
; This confidential and proprietary software may be used only as
; authorised by a licensing agreement from ARM Limited
;   (C) COPYRIGHT 2001 ARM Limited
;       ALL RIGHTS RESERVED
; The entire notice above must be reproduced on all authorised
; copies and copies may only be made to the extent permitted
; by a licensing agreement from ARM Limited.
;
;------------------------------------------------------------------------------
; Version and Release Control Information:
;
; File Name           :rempause_h.s,v
; File Revision       :1.1
;
; Release Information :ADK_REL1v1
;
;------------------------------------------------------------------------------
; Purpose             : Remap/Pause Controller registers
;
;------------------------------------------------------------------------------

    IMPORT tube
    IMPORT remPause
    IMPORT smc

; Registers within rpc structure
RpcPause          EQU 0x000     ;Pause control bit (bit 0)
RpcRemap          EQU 0x004     ;Remap register (read)
RpcRemapClr       EQU 0x004     ;Remap register (write)
RpcResetStatus    EQU 0x008     ;Reset status (read)
RpcResetStatusSet EQU 0x008     ;Reset status set (write)
RpcResetStatusClr EQU 0x010     ;Reset status clear


RpcPeriphID0      EQU 0xFE0     ;Peripheral ID 0
RpcPeriphID1      EQU 0xFE4     ;Peripheral ID 1
RpcPeriphID2      EQU 0xFE8     ;Peripheral ID 2
RpcPeriphID3      EQU 0xFEC     ;Peripheral ID 3
RpcPCellID0       EQU 0xFF0     ;PrimeCell ID 0
RpcPCellID1       EQU 0xFF4     ;PrimeCell ID 1
RpcPCellID2       EQU 0xFF8     ;PrimeCell ID 2
RpcPCellID3       EQU 0xFFC     ;PrimeCell ID 3


RpcIdMask EQU 255
RpcIdID   EQU 0x1

RpcPauseHALT EQU 0x4

RpcResetStatusMask equ 0x1
RpcResetStatusPOR equ 0x1

RpcResetStatusClearMask equ 1
RpcResetStatusClearPOR  equ 0x1

 END
