;/***************************************************************************
; * Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
; * Copyright © ARM Limited 1998.  All rights reserved.
; ***************************************************************************/
;****************************************************************************
;
;  Defines for exception handling in uHAL library code.
;
;****************************************************************************/


NoIRQ		EQU	0x80		; Bit 7 of cspr
NoFIQ		EQU	0x40		; Bit 6 of cspr
NoINTS		EQU	(NoIRQ | NoFIQ) ; Both
MaskINTS	EQU	NoINTS

AllIRQs		EQU	0xFF		; Mask for interrupt controller

ResetV		EQU	0x00
UndefV		EQU	0x04
SwiV		EQU	0x08
IrqV		EQU	0x18
FiqV		EQU	0x1C

ModeMask	EQU	0x1F		; /* Processor mode in CPSR */

SVC32Mode	EQU	0x13
IRQ32Mode	EQU	0x12
FIQ32Mode	EQU	0x11
User32Mode	EQU	0x10
;; /* Error modes */
Abort32Mode	EQU	0x17
Undef32Mode	EQU	0x1B

PSR_T_bit EQU 0x20

UserStackSize	EQU	0x20000
SVCStackSize	EQU	0x4000
IRQStackSize	EQU	0x2000
UndefStackSize	EQU	0x200
;/* Not currently used, but defined anyway */
FIQStackSize	EQU	0x400
AbortStackSize	EQU	0x400

;/* SWIs known to uHAL */
SWI_Angel			EQU	0x123456
SWI_Angel_Thumb   EQU   0xAB
angel_SWI_SYS_WRITEC		EQU	0x03
angel_SWI_SYS_WRITE0		EQU	0x04
angel_SWI_SYS_READC		EQU	0x07
angel_SWI_SYS_HEAPINFO		EQU	0x16
angel_SWIreason_EnterSVC	EQU	0x17
angel_SWIreason_ReportException	EQU	0x18
ADP_Stopped_ApplicationExit	EQU	0x20026

SYS_READ_SWI EQU 0x06
SYS_WRITE_SWI EQU 0x05
SYS_FILE_CLOSE EQU 0x02
SYS_FILE_OPEN EQU 0x01
	END				; End of file
