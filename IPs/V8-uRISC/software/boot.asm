;-------------------------------------------------------------------------------
; Copyright 1997-1998 VAutomation Inc. Nashua NH (603)882-2282 ALL RIGHTS RESERVED.
; This software is provided under license and contains proprietary and
; confidential material which is the property of VAutomation Inc.
;-------------------------------------------------------------------------------
;
; BOOT.ASM
;
; Description:
;  This routine loads RAM with the contents of the EEPROM.
;  If the EEPROM checksum is not correct, then the EEPROM is corrupt or
;  unprogrammed. In this case, a very crude monitor mode is entered
;  which allows the user to download EEPROM data via the serial port.
;
;  You should see the "Copyright 1996 VAutomation Inc Nashua NH"
;  message on the serial port.
; 
; Limitations:
;
; Revision History:
; $Log: boot.asm,v $
; Revision 1.10  1998/08/26 23:02:44  eric
; Oops. had a bug in the download code. Won't download properly.
;
; Revision 1.9  1998/08/20 15:15:51  eric
; Changed from the OK to mmdd> prompt.
;
; Revision 1.8  1998/08/18 18:20:52  eric
; Toggle PSR[4] when waiting for download.
;
; Revision 1.7  1998/06/02 13:39:30  eric
; R6/R6 was being trashed so we couldn't download from ROM.
;
; Revision 1.6  1998/05/29 18:29:51  eric
; Added the EQUates needed.
;
; Revision 1.5  1998/05/27 16:51:11  russell
; copyright
; move EEPROM2RAM to i2c.asm
; tighten a few loops
;
; Revision 1.4  1997/11/07 16:30:25  eric
; added 2nd EEPROM support
;
; Revision 1.3  1997/09/03 14:07:03  eric
; VUART integrated.
;
; Revision 1.2  1997/05/11 01:58:57  eric
; added checksum checking when downloading.
;
; Revision 1.1  1996/12/23 16:55:37  eric
; Initial revision
;

; Variables
	; Load the EEPROM starting at address 0x400 (int vector table and up)
	.equ	SRAM_START_LOW  0x00
	.equ	SRAM_START_HIGH 0x04

BOOT:	;;;;;;;;;;;;;;; start of the BOOT code...;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	JSR INIT_UART:	; init the UART for 19.2K baud.
	JSR EEPROM2RAM		; Copy the EEPROM to RAM
	brcc DOWNLOAD		; EEPROM checksum bad, download code from UART.
BOOT_DONE:
	jmp 0x0410		; Checksum is OK, so execute the code
					; in the EEPROM.

DOWNLOAD:
; this routine will wait for an Intel Hex file to be sent.
; The first 8K bytes of SRAM are cleared to 0,
; Then the UART is polled until the entire Intel Hex format file
; has been loaded into SRAM.
; Once the Intel hax file has been loaded, we jump to 0x0410.
;
; flow during hex file loading is ...
; wait for the character ':'
; Read in the address
; convert each byte of data and write to SRAM.
; When all data is written (control byte is 01)
; Unfortunately, there isn't enough space in the Boot ROM.
; For now we just begin executing the downloaded code. It can write the data
; to EEPROM. It would be nicer if the boot code did the following instead:
;; then copy to the EEPROM and compute the checksum.
;; then go thru reset.

	; Fill the SRAM area with zeroes. 
	ldi r5,SRAM_START_HIGH
	ldi r4,SRAM_START_LOW
	xor	r0						; Fill RAM with 0
	ldi r6,0x00
	ldi r7,0xc0
DNLD_CLEAR:
	stx	r4
	upp	r4						; inc pointer
	upp	r6
	brcc DNLD_CLEAR
	ldi r6,UART_BASE		; numerous routines rely on R6/R7
	ldi r7,UART_BASE>>8		; pointing to the UART
	ldi r5,DNLOAD_NOTICE2>>8	; load up the pointer to the string
	ldi r4,DNLOAD_NOTICE2
	JSR boot_print_string		; print out the Message for download
	; wait for the character ':'
DNLD2:
	jsr DN_RD_CHAR
	ldi	r1,':'
	cmp	R1
	brne DNLD2		; wait for the :
	; Read in the length of the characters on this line.
	jsr DN_RD_HEX
	t0x	r3
	; Read in the address,
	jsr DN_RD_HEX
	t0x	r5
	jsr DN_RD_HEX
	t0x	r4
	; read in the control byte, if=01 then we're done
	jsr DN_RD_HEX
	dec	r0
	breq BOOT_DONE	; once we're done downloading, execute the code
	inc	r0			; set the NZ flags
	brne DNLD2		; If the control byte is not zero, then it's not data so skip the line.
	add	r3
	add	r4
	add	r5
	t0x	r2			; R2=checksum
DNLD3:
	jsr DN_RD_HEX	; read the data
	stx	R4			; store it out
	add	r2			; compute the checksum
	t0x	r2
	upp	r4			; increment the pointer
	dec	r3
	brne DNLD3		; Done with the line? if not then keep reading hex bytes
	jsr DN_RD_HEX	; read the checksum byte
	add	r2
	breq DNLD2		; checksum is OK, keep going
	jmp	0x0000		; checksum is bad, reboot.

DN_RD_HEX:
; read 2 ASCII characters and convert to hex and return in R0
	psh	r1
	jsr	DN_RD_CHAR
	jsr	boot_ascii2hex
	t0x	r1
	clp	CARRY
	rol	r1
	rol	r1
	rol	r1
	rol	r1
	jsr	DN_RD_CHAR
	jsr	boot_ascii2hex
	or	r1
	pop	r1
	rts

; Read a character from the UART and return in R0. No error checking is done.
; Assumes R6&R7 have the UART base address in them.
; PSR bit 4 is toggled while waiting for a character to come in.
DN_RD_CHAR:
	psh	r4
	psh 	r5
DN_RD_CHAR1:
	upp	r4		; R4/R5 will count 64K times before toggle PSR4
	brcc	DN_RD_CHAR3
	br0	4,DN_RD_CHAR2
	clp	4
	jmp	DN_RD_CHAR3
DN_RD_CHAR2:
	stp	4
DN_RD_CHAR3:
	ldo	r6,1			; load from the Status Reg
	btt	3
	breq DN_RD_CHAR1		; wait for a byte to come in
	ldx	r6				; load the character
	pop	r5
	pop	r4
	rts

boot_ascii2hex:
; this routine takes the ACII character in R0 and blindly 
; converts it to a binary value in the low 4 bits of r0.
; No checking to done on the ASCII character, it is simply converted
; assuming the character is [0-9,a-f,A-F]
	psh	r1
	ldi	R1,0x5f
	and	r1		; AND off bit 7 which isn't ascii and bit 5 to get to upper case.
	ldi	r1,0x3f
	cmp	r1
	brcc boot_ascii2hex2:	; it's 0-9, just and off the upper 4 bits
	ldi	r1,55	; subtract 55 decimal to get the conversion of a-f
	stp	CARRY
	sbc	r1
boot_ascii2hex2:
	ldi	r1,0x0f
	and	r1
	pop	r1
	rts

;INIT_UART:
; The UART powers up in this state - no need to init it.
;	ldi r6, UART_BASE;
;	ldi r7, UART_BASE>>8;
;	ldi r0, 0x9c	; DLL=9c = 19.2K baud
;	sto r6, 2
;	ldi r0, 0x00
;	sto r6, 3	; DLM=00
;	rts;	UART is now ready to operate in polled mode.

.equ EEPROM_READ 1
.equ    SDA_IN  7
.equ    SDA_OUT 6
.equ    SCL_IN  5
.equ    SCL_OUT 4
.equ    CARRY 1
.include "i2c.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The boot_print_string routine simply sends a string of characters 
; to the UART. The string is pointed to by the R4-5 pair. The 
; string must be termintated with a NULL character.
boot_print_string:
PRINT_1:
	ldo r6,1			; read the line status register
	BTT 7
	breq PRINT_1		; Wait until the fifo is empty before sending the next character
	ldx r4
	breq PRINT_DONE		; null character signals end of string
	stx r6				; send the character
	upp r4				; increment the pointer to the string
	brcc PRINT_1		; branch always
PRINT_DONE:	rts;

;;
;; If we ever need to save another byte or two:
;;	move the breq to where the brcc is.  it will cause a null to be sent, but so what.
;;

; The string indicates the month and the day it was built
DNLOAD_NOTICE2:	..month
	..day
	.string ">\0"
