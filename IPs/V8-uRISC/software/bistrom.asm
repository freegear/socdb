;-------------------------------------------------------------------------------
; Copyright 1997-1998 VAutomation Inc. Nashua NH (603)882-2282 ALL RIGHTS RESERVED.
; This software is provided under license and contains proprietary and
; confidential material which is the property of VAutomation Inc.
;-------------------------------------------------------------------------------
;
; BISTROM.ASM
;
; Description:
;  Built-in-Self-Test and V8 Boot monitor code. Typically this code is
;  burned into 512 Bytes of ROM at address 0x0000-0x01ff. The first
;  quarter of the ROM is that BIST test. The rest is the BOOT
;  ROM that will load data from the serial EEPROM and begin executing
;  it after checking the contents.
;  See the BIST.ASM and BOOT.ASM files for more detail.
; 
; Limitations:
;
; Revision History:
; $Log: bistrom.asm,v $
; Revision 1.9  1998/08/18 18:21:23  eric
; Removed clearing the interrupt on the old VTIMER.
;
; Revision 1.8  1998/07/02 17:14:58  eric
; init the low half of the reg file in simulation.
;
; Revision 1.7  1998/07/02  14:27:56  eric
; Fix the WANT_HARDWARE again...
;
; Revision 1.6  1998/07/02  11:59:50  eric
; corrected ifdef want_hardware
;
; Revision 1.5  1998/05/27  16:46:52  russell
; copyright
; verify that code size is < 0x200
;
; Revision 1.4  1998/05/13 14:37:13  russell
; add .rom
;
; Revision 1.3  1998/04/28 20:07:52  eric
; added the WANT_HARDWARE define.
;
; Revision 1.2  1997/09/03 14:07:03  eric
; VUART integrated.
;
; Revision 1.1  1996/12/23 16:55:37  eric
; Initial revision
;

;;;;;;    Define the addresses for required resources   ;;;;;;;;;;;;;;;
.ORG 0x0200
PAGE_REG: ; Page register
.ORG 0x0202
CONTROL_REG: ; CONTROL register
.ORG 0x0240
UART_BASE: ; Base address of the uart

.ORG 0x0320
BIST_RAM: ; This test needs a few locations in RAM. 
	; Typically we use a few locations in the stack space

.rom 0x0400
INT_VEC_TABLE:	; The interrupt vector table is usually at the bottom of 
		; page 4. Just above the stack.

.rom 0x0000		; The BISTROM is normally place in low memory.
RESET_VECTOR:	; Upon reset, the V8 begins execution at 0.

.include "bist.asm";	The V8 begin execution here after being RESET.

; By default we will build the BISTROM for simulation.
; The simulation version skips the code for clearing RAM, loading from
; EEPROM and downloading from the UART. This would take forever in
; the simulator. Instead we just jump right into the regression
; test which we know is already loaded into the RAM.

; if you don't want hardware, then you want the quick version for simulation
.ifndef WANT_HARDWARE
.equ WANT_HARDWARE 0
.endif

.if WANT_HARDWARE
.include "boot.asm"	; Boot from the EEPROM or download via the UART.
.else
	clp 3		; clear the PSR I bit which will enable interrupts
			; which we shouldn't get. We also use the low 8 bank
			; of the V8s register file.
	ldi r0, 0	; initialize all of the registers to remove Xes
	t0x r1
	t0x r2
	t0x r3
	t0x r4
	t0x r5
	t0x r6
	t0x r7
	jmp 0x410	; Replace the boot code with a quick jump to
			; 0x410 when running simulations. It would take
			; many hours of simulation time to load the data
			; from the EEPROMs to the RAM and in simulation the
			; RAM is already loaded with the program we want
			; to simulate.
.endif

BISTROM_END:	; SHOULD NEVER EXCEED 01FF !!!!!!!!!!!!!!!

.if BISTROM_END>>9
	error - Code too big!!!!
.endif
