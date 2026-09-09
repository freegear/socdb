;
; Copyright (c) Microsoft Corporation.  All rights reserved.
;
;
; Use of this source code is subject to the terms of the Microsoft end-user
; license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
; If you did not accept the terms of the EULA, you are not authorized to use
; this source code. For a copy of the EULA, please see the LICENSE.RTF on your
; install media.
;
;-------------------------------------------------------------------------------
;
;  Header: smt926a.inc
;
;  This header file defines only those registers required by the startup
;  code. All addresses are based off the physical addresses (PA) defined
;  in smt926a_base_reg.h (smt926a_base_reg.inc).
;
;-------------------------------------------------------------------------------

; Include the base register definitions

	INCLUDE smt926a_base_regs.inc


;------------------------------------------------------------------------------
; General CPU constants

Mode_USR         EQU        (0x10)
Mode_FIQ         EQU        (0x11)
Mode_IRQ         EQU        (0x12)
Mode_SVC         EQU        (0x13)
Mode_ABT         EQU        (0x17)
Mode_UND         EQU        (0x1B)
Mode_SYS         EQU        (0x1F)
I_Bit            EQU        (0x80)
F_Bit            EQU        (0x40)
R1_iA            EQU        (1<<31)
R1_nF            EQU        (1<<30)

;------------------------------------------------------------------------------
;  Miscellaneous defines

WORD_SIZE       EQU         (4)
DW8             EQU         (0x0)
DW16            EQU         (0x1)
DW32            EQU         (0x2)
WAIT            EQU         (0x1<<2)
UBLB            EQU         (0x1<<3)

;------------------------------------------------------------------------------
; MMU constants

MMU_CTL_MASK     EQU        (0x3FFF0000)
MMU_TTB_MASK     EQU        (0x00003FFF)
MMU_ID_MASK      EQU        (0xFFFFFFF0)

;------------------------------------------------------------------------------
;  Interrupt Control Registers

INTMSK          EQU         (SMT926A_BASE_REG_PA_INTR        + 0x08)
INTSUBMSK       EQU         (SMT926A_BASE_REG_PA_INTR        + 0x1C)
INTMOD          EQU         (SMT926A_BASE_REG_PA_INTR        + 0x04)

;------------------------------------------------------------------------------
;  IOPort Control Registers

GPFCON          EQU         (SMT926A_BASE_REG_PA_IOPORT      + 0x50)
GPFDAT          EQU         (SMT926A_BASE_REG_PA_IOPORT      + 0x54)
MISCCR          EQU         (SMT926A_BASE_REG_PA_IOPORT      + 0x80)
GSTATUS2        EQU         (SMT926A_BASE_REG_PA_IOPORT      + 0xB4)
GSTATUS3        EQU         (SMT926A_BASE_REG_PA_IOPORT      + 0xB8)

;------------------------------------------------------------------------------
;  Watch Dog Control Registers

WTCON           EQU         (SMT926A_BASE_REG_PA_WATCHDOG    + 0x00)

;------------------------------------------------------------------------------
;  Memory configuration Control Registers

BWSCON          EQU         (SMT926A_BASE_REG_PA_MEMCTRL     + 0x00)
REFRESH         EQU         (SMT926A_BASE_REG_PA_MEMCTRL     + 0x24)

;------------------------------------------------------------------------------
;  Clock and Power Control Registers

LOCKTIME        EQU         (SMT926A_BASE_REG_PA_CLOCK_POWER + 0x00)
MPLLCON         EQU         (SMT926A_BASE_REG_PA_CLOCK_POWER + 0x04)
UPLLCON         EQU         (SMT926A_BASE_REG_PA_CLOCK_POWER + 0x08)
CLKCON          EQU         (SMT926A_BASE_REG_PA_CLOCK_POWER + 0x0C)
CLKSLOW         EQU         (SMT926A_BASE_REG_PA_CLOCK_POWER + 0x10)
CLKDIVN         EQU         (SMT926A_BASE_REG_PA_CLOCK_POWER + 0x14)
CAMDIVN         EQU         (SMT926A_BASE_REG_PA_CLOCK_POWER + 0x18)

    END
 
