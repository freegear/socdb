;-------------------------------------------------------------------------------
; Copyright 1997-1998 VAutomation Inc. Nashua NH (603)882-2282 ALL RIGHTS RESERVED.
; This software is provided under license and contains proprietary and
; confidential material which is the property of VAutomation Inc.
;-------------------------------------------------------------------------------
;
; i2c.asm
; Revision History:
; $Log: i2c.asm,v $
; Revision 1.8  1998/06/03 17:54:12  russell
; if debugging, add extra jmp.
;
; Revision 1.7  1998/05/27 13:35:03  russell
; copyright
; move RAM2EEPROM and EEPROM2RAM into this file ans conditionally
; assemble them.
; /
;
;

;	if EEPROM_WRITE is defined,
;		 you can call RAM2EEPROM
;	if EEPROM_READ is defined as not 0,
;		you can call EEPROM2RAM
;	if EEPROM_READ is defined as 0,
;		you can call EEPROM2RAM but it won't modify RAM
;	if EEPROM_DEBUG is defined as not 0,
;		checksums will be displayed every 256 bytes during read/write
;	if EEPROM_WRITE_ONCE is defined as not 0,
;		RAM2EEPROM will modify itself so it can't be called again.
;		(this is useful if the code if loaded above 0x43ff and won't survive
;		a p-fail)


.equ NEW_BYTE_CNT	1		; if 1, r67 is upp'd, so it must start negative

.ifndef EEPROM_DEBUG
.equ EEPROM_DEBUG 0			; if 1, show checksum every 256 bytes
.endif

.ifndef EEPROM_WRITE_ONCE
.equ EEPROM_WRITE_ONCE 1	; if 1, disable self after writing
.endif

; The I2C bus control lines are muxed into the upper 4 bits of
; the PSR when the I2C bus is enabled in the control register.
	.equ	SDA_IN  7
	.equ	SDA_OUT 6
	.equ	SCL_IN  5
	.equ	SCL_OUT 4
	.equ	CARRY 1

	; Load the EEPROM starting at address 0x400 (int vector table and up)
	.equ	SRAM_START_LOW  0x00
	.equ	SRAM_START_HIGH 0x04
	; EEPROM is in 2 separate EEPROM chips, 8K each but for the 2nd we need to
	; save room for the checksum.
.if NEW_BYTE_CNT
	.equ	EEPROM_BYTE_CNT_LO	0x00
	.equ	EEPROM_BYTE_CNT_HI	0xe0
.else
	.equ	EEPROM_BYTE_CNT_LO	0xFF
	.equ	EEPROM_BYTE_CNT_HI	0x1F
.endif

.rom
EEPROM_START:

.ifdef EEPROM_WRITE
RAM2EEPROM:
	jmp RAM2EEPROM2

	ldi r4, EEPROM_NOT_DONE
	ldi r5, EEPROM_NOT_DONE>>8
	jsr PRINT_STRING
	rts

EEPROM_NOT_DONE:	.string "\aEEPROM ALREADY written\r\n\0"
RAM2EEPROM_END:	

.org 0x5000
EEPROM_NOTICE:	.string "Copying SRAM to EEPROM\r\n\0"

RAM2E_ERROR2:
	jmp RAM2E_ERROR2

RAM2EEPROM2:		; find return address and overwrite the call to here
.if EEPROM_WRITE_ONCE
	xor r0
	sta r0,RAM2EEPROM
	sta r0,RAM2EEPROM+1
	sta r0,RAM2EEPROM+2
.endif

; This routine copies the contents of the RAM into the EEPROM.
; The flow of this routine is ...
; Enable I2C bus
; send control word (random write)
; IF ack, continue, else error
; write data until done, compute 16 bit checksum (crc?).
; write the checksum bytes
; Disable I2C bus

;; disable all USB interupts
	xor r0
	sta r0,USB_BASE+0

	ldi r5,EEPROM_NOTICE>>8		; load up the pointer to the string
	ldi r4,EEPROM_NOTICE
	JSR print_string_now

	; Enable the I2C Bus
	stp SDA_OUT
	stp SCL_OUT
	ldi r0,0x01
	sta R0,CONTROL_REG
	ldi R0,0xa0
	sta R0,RAM2E_CHIP		; the control word for the first EEPROM=a0

	; init for the write loop
	ldi R2,0				; checksum goes here
	ldi R3,0
	ldi r4,SRAM_START_LOW	; Load the pointer to SRAM
	ldi R5,SRAM_START_HIGH
	ldi r6,EEPROM_BYTE_CNT_LO
	ldi r7,EEPROM_BYTE_CNT_HI

RAM2E_PAGE:	; We write the EEPROM in 64 byte pages
	; the EEPROM has a limit of one page maximum for each write 
	; Send the control word.
	jsr I2C_QBIT	; wait for a quarter of a bit
	clp SDA_OUT		; I2C START Condition
	jsr I2C_QBIT	; wait for a quarter of a bit
	lda R0,RAM2E_CHIP	; control word indicates a Write (bit0=0)
	jsr I2C_WR		; Write the control byte
	br1 SDA_IN,RAM2E_PRESTOP	; Did we get an ACK?
	; If we don't get an ACK, then the write is still in progress
	; so just try again by jumping to PRESTOP

	; send the start address for this page (SRAM location - 0x400)
	tx0 R5
	ldi r1,0x04
	stp CARRY
	sbc r1			; The data in the EEPROM is offset by 0x400
	jsr I2C_WR		; subtract the offset here.
	br1 SDA_IN,RAM2E_ERROR2	; Check that we get an ACK bit
	tx0 R4
	jsr I2C_WR
	br1 SDA_IN,RAM2E_ERROR2	; Check that we get an ACK bit
	; write the data until complete.
	ldi r1,64		; R1 is a counter of the number of bytes in the page.
RAM2E_1:
	ldx r4			; get the byte of data from RAM
	jsr I2C_WR		; Write it to EEPROM
	br1 SDA_IN,RAM2E_ERROR2	; Check that we get an ACK bit
	clp CARRY		; Compute checksum
	ldx r4			; get the byte of data from RAM again
	adc R2
	t0x R2
	xor R0
	adc R3
	t0x R3
	upp r4			; Inc Pointer


.if EEPROM_DEBUG	; every 256 bytes, dump checksum so far
	tx0 r4			; get low byte of address
	brne DONT_DUMP_CHECKSUM
	tx0 r3
	jsr print_hex
	tx0 r2
	jsr print_hex
	jsr print_space
DONT_DUMP_CHECKSUM:
.endif

.if NEW_BYTE_CNT
	upp r6
	brcs RAM2E_DONE	; we're done once we've written all the data
.else
	dec R6			; Decrement the counter
	brcs RAM2E_2
	dec R7
	brcc RAM2E_DONE	; we're done once we've written all the data
.endif
RAM2E_2:
	dec r1
	brne RAM2E_1	; write 64 bytes yet?
	clp SCL_OUT		; end the ACK bit
	jsr I2C_QBIT	; wait
	clp SDA_OUT		; prep for stop
	jsr I2C_QBIT	; wait

RAM2E_STOP:
	stp SCL_OUT		;
	jsr I2C_HBIT	; wait
	stp SDA_OUT		; SCL is high, SDA=1 indicates a stop.
	jsr I2C_HBIT	; wait
	jmp RAM2E_PAGE	; move on to the next page.

RAM2E_PRESTOP:
	clp	SCL_OUT		; SCL goes low to complete the ACK bit.
	jsr I2C_QBIT	; wait for a quarter of a bit
	clp	SDA_OUT		; SDA goes low in preparation for a STOP
	jsr I2C_QBIT	; wait for a quarter of a bit
	stp	SCL_OUT		; and high again.
	jsr I2C_HBIT	; wait
	jmp	RAM2E_STOP

RAM2E_DONE:
	; we have all of the data, the last 2 words are the checksum
	ldi r0,0xa2
	lda	r1,RAM2E_CHIP
	cmp	r1
	breq RAM2E_DONE_1	; have we done both chips?
	sta	r0,RAM2E_CHIP	; toggle the control byte to the 2nd chips addr
.if NEW_BYTE_CNT
	ldi r6,EEPROM_BYTE_CNT_LO+2	; reload the number of bytes to write
.else
	ldi r6,EEPROM_BYTE_CNT_LO-2	; reload the number of bytes to write
.endif
	ldi r7,EEPROM_BYTE_CNT_HI	; minus 2 for checksum
	jmp	RAM2E_PRESTOP	; Issue a STOP command and start up again...

RAM2E_DONE_1:
.if EEPROM_DEBUG
	puts EEPROM_CHECKSUM_STR
	tx0 r3
	jsr print_hex
	tx0 r2
	jsr print_hex
	jsr print_crlf
.endif ;EEPROM_DEBUG

	tx0 r2
	jsr I2C_WR
	br1 SDA_IN,RAM2E_ERROR	; Check that we get an ACK bit
	tx0 r3
	jsr I2C_WR
	br1 SDA_IN,RAM2E_ERROR	; Check that we get an ACK bit
	clp SCL_OUT		; SCL goes low to complete the ACK bit.
	jsr I2C_QBIT	; wait for a quarter of a bit
	clp SDA_OUT		; SDA goes low in preparation for a STOP
	jsr I2C_QBIT	; wait for a quarter of a bit
	stp SCL_OUT		; and high again.
	jsr I2C_HBIT	; wait
	stp SDA_OUT		; STOP
	; We're Done! And the data is OK!
	stp CARRY

RAM2E_EXIT:
	; disable the I2C bus
	ldi r0,0x00
	sta R0,CONTROL_REG
	ldi r0,0xc8
	sta R0,CONTROL_REG

	ldi r4, EEPROM_DONE
	ldi r5, EEPROM_DONE>>8
	jsr PRINT_STRING
	clp 4
	clp 5
	clp 6
	clp 7
	rts

RAM2E_ERROR:
	clp SCL_OUT		; End of ACK
	jsr I2C_HBIT	; wait
	clp SDA_OUT		; SDA goes low in preparation for a STOP
	jsr I2C_HBIT	; wait
	stp SCL_OUT		; and high again.
	jsr I2C_HBIT	; wait
	stp SDA_OUT		; STOP
	clp CARRY		; We failed the test...
	brcc RAM2E_EXIT	; this is a branch always

EEPROM_DONE:	.string "\aEEPROM written\r\n\0"
.ram
RAM2E_CHIP:	.byte	0xa0	; this value toggles between 0xa0 and 0xa2 which
							; selects the first or the second EEPROM chip.
.rom

.if EEPROM_DEBUG
EEPROM_CHECKSUM_STR:	.string "Checksum=\0"
.endif ;!DEBUG_CHECKSUM
.endif ;EEPROM_WRITE

.ifdef EEPROM_READ
.if EEPROM_DEBUG
E2READ_ERROR2:
	jmp E2READ_ERROR
.endif

EEPROM2RAM:
; This routine copies the contents of the EEPROM into RAM.
; The flow of this routine is ...
; Enable I2C bus
; send control word (random write)
; IF ack, continue, else error
; send start read address (0)
; send control word
; read data until done, compute 16 bit checksum (crc?).
; Disable I2C bus
; if checksum OK, jump to code start, else error

	; Enable the I2C Bus
	stp SDA_OUT
	stp SCL_OUT
	ldi r0,0x01
	sta R0,CONTROL_REG
	ldi r1, 0xa0	; I2C Control word for the EEPROMs
	; read the data until complete.
	ldi R2,0 ; checksum goes here
	ldi R3,0
	ldi r4, SRAM_START_LOW ; Load the pointer to SRAM
.if EEPROM_READ
	ldi R5, SRAM_START_HIGH
.else ;!EEPROM_READ
	ldi R5, SRAM_START_HIGH+0x80
.endif ;!EEPROM_READ

	ldi r6, EEPROM_BYTE_CNT_LO
	ldi r7, EEPROM_BYTE_CNT_HI
E2READ_0:
	; Send the control word.
	jsr I2C_QBIT	; wait for a quarter of a bit
	clp SDA_OUT		; I2C START Condition
	jsr I2C_QBIT	; wait for a quarter of a bit
	tx0 R1			; control word indicated a Write (bit0=0)
	jsr I2C_WR		; Write the control byte
.if EEPROM_DEBUG
	br1 SDA_IN, E2READ_ERROR2	; Did we get an ACK?
.else
	br1 SDA_IN, E2READ_ERROR	; Did we get an ACK?
.endif
	; send the start address = 0;
	ldi R0,0
	jsr I2C_WR
.if EEPROM_DEBUG
	br1 SDA_IN, E2READ_ERROR2	; Did we get an ACK?
.else
	br1 SDA_IN, E2READ_ERROR	; Did we get an ACK?
.endif
	ldi R0,0
	jsr I2C_WR
.if EEPROM_DEBUG
	br1 SDA_IN, E2READ_ERROR2	; Did we get an ACK?
.else
	br1 SDA_IN, E2READ_ERROR	; Did we get an ACK?
.endif
	; send a new START
	clp SCL_OUT		; Release the ACK bit
	jsr I2C_HBIT	; wait for a quarter of a bit
	stp SCL_OUT		; raise SCL to prep for new start
	jsr I2C_HBIT	; wait for a quarter of a bit
	clp SDA_OUT		; I2C START Condition
	jsr I2C_QBIT	; wait for a quarter of a bit
	; send the READ command control word
	ldi R0,0x01
	or  r1		; calculate the control word with READ=1
	jsr I2C_WR		; Write the control byte
	br1 SDA_IN, E2READ_ERROR	; Did we get an ACK?
E2READ_1:	; top of loop reading bytes from the EEPROM
	jsr I2C_RD	; get a byte

	stx r4	; store it in RAM

	jsr E2READ_ACK		; send the ACK bit
	add R2				; Compute checksum
	t0x R2
	xor R0
	adc R3
	t0x R3
	upp r4	; Inc pointer

.if EEPROM_DEBUG
	tx0 r4
	brne EEPROM_DONT_DUMP
	tx0 r3
	jsr print_hex
	tx0 r2
	jsr print_hex
	jsr print_space
EEPROM_DONT_DUMP:
.endif ;EEPROM_DEBUG

.if NEW_BYTE_CNT
	upp r6
	brcc E2READ_1	; not done
.else
	dec R6	; Decrement the counter
	brcs E2READ_1	; done?
	dec R7
	brcs E2READ_1	; done?
.endif
	ldi r0, 0xa0	; done with this EEPROM
	cmp r1		; R1=a0 for the first chip, a2 for the second
	breq E2READ_2ND_CHIP	; switch to the 2nd EEPROM

	; we have all of the data, the last 2 words are the checksum
	jsr I2C_RD
	t0x r6				; r6 = stored checksum low
	jsr E2READ_ACK		; send the ACK bit
	jsr I2C_RD

.if EEPROM_DEBUG
	t0x r7				; r7 = stored checksum high
	puts CHECKSUM_COMPUTED
	tx0 r3
	jsr print_hex
	tx0 r2
	jsr print_hex
	puts CHECKSUM_STORED
	tx0 r7
	jsr print_hex
	tx0 r6
	jsr print_hex
	jsr print_crlf
	jsr print_flush
.endif ;EEPROM_DEBUG

	; Don't send an ACK bit as we want to STOP
	; We're Done! And the data is OK!
	stp CARRY
E2READ_EXIT:
	clp SCL_OUT		; so we can execute a STOP command.
	jsr I2C_QBIT	; wait for a quarter of a bit
	clp SDA_OUT
	jsr I2C_QBIT	; wait for a quarter of a bit
	stp SCL_OUT
	jsr I2C_HBIT	; wait for a quarter of a bit
	stp SDA_OUT		; issue the STOP command
	; disable the I2C bus
	XOR r0
	sta R0,CONTROL_REG
	rts

E2READ_ERROR:
.if EEPROM_DEBUG
	puts EEPROM_ERROR
.endif ;EEPROM_DEBUG
	clp CARRY			; We failed the test...
	brcc E2READ_EXIT	; this is a branch always

E2READ_ACK:
	clp SCL_OUT		; send the ACK bit
	jsr I2C_QBIT	; wait for a quarter of a bit
	clp SDA_OUT
	jsr I2C_QBIT	; wait for a quarter of a bit
	stp SCL_OUT
	rts

E2READ_2ND_CHIP:	; setup for accessing the second EEPROM
	jsr I2C_RD		; extra read cycle just to get us to the ACK bit
.ifn NEW_BYTE_CNT
	dec r7			; we jumped around this decrement
.endif
	ldi R1, 0xa2	; switch the control word to the second EEPROM
.if NEW_BYTE_CNT
	ldi R6,EEPROM_BYTE_CNT_LO+2	; 2nd EEPROM has a different number of bytes
.else
	ldi R6,EEPROM_BYTE_CNT_LO-2	; 2nd EEPROM has a different number of bytes
.endif
	ldi R7,EEPROM_BYTE_CNT_HI	; 2nd EEPROM has a different number of bytes
	clp SCL_OUT
	jsr I2C_QBIT
	clp SDA_OUT
	jsr I2C_QBIT
	stp SCL_OUT
	jsr I2C_HBIT
	stp SDA_OUT		; issue the STOP command
	jsr I2C_HBIT
	jmp E2READ_0

.if EEPROM_DEBUG
EEPROM_ERROR:		.string "\a\r\nSome kind of error\0"
CHECKSUM_COMPUTED:	.string "Computed checksum=\0"
CHECKSUM_STORED:	.string "\r\nStored checksum=\0"
.endif ;EEPROM_DEBUG

.endif ;EEPROM_READ

I2C_WR:
; Write the byte in R0 out the I2C bus
; Assumes we are at the falling edge of SCL upon entry and returns 
; at the falling edge after the ACK bit.
; Note that SCL is not driven low after the ACK bit and SDA can be
; tested immediately upon return for the status of ACK.
	psh r1
	ldi r1,0x09		; We actually send 9 bits, the ninth is the ACK.
	stp CARRY		; this will be the ACK bit which is sent by the
					; other chip. By setting the C to 1, we will
					; tristate the SDA pin during the ACK bit.
I2C_WR_1:			; Top of loop for sending a byte
	clp SCL_OUT
	jsr I2C_QBIT
	stp SDA_OUT
	rol R0
	brcs I2C_WR_2
	clp SDA_OUT
I2C_WR_2:
	jsr I2C_QBIT
	stp SCL_OUT
	jsr I2C_HBIT
	dec R1
	brne I2C_WR_1	; done with the byte?
	pop r1
	rts

.ifdef EEPROM_READ
; USED by bistrom

I2C_RD:
; Read a byte from the I2C bus and Return in R0.
; Assumes we are at the falling edge of SCL upon entry and returns 
; at the falling edge after the last bit.
; Note that we don't send the ACK bit here.
	psh r1
	ldi r1,0x08
I2C_RD_1:			; Top of loop for reading a byte
	clp SCL_OUT
	jsr I2C_QBIT
	stp SDA_OUT		; Insures we've removed the ACK bit
	jsr I2C_QBIT
	stp SCL_OUT
	jsr I2C_QBIT
	stp CARRY	; set the carry
	br1 SDA_IN,I2C_RD_2
	clp CARRY	; clear the carry to match the SDA pin
	t0x r0		; shut up lint
I2C_RD_2:
	rol R0
	jsr I2C_QBIT
	dec R1
	brne I2C_RD_1	; done with the byte?
	pop r1
	rts
.endif ;EEPROM_READ

I2C_HBIT:	; Wait for 1/2 of a I2C bit.
	jsr I2C_QBIT
	rts

I2C_QBIT:	; Wait for 1/4 of a I2C bit.
	; One I2C bit = 400Khz = 30 clocks @ 12Mhz. So, we need to wait for 8 clocks.
	; It takes 5 clocks to execute the JSR and 5 more to execute the rts
	; so we don't actully have to do any waiting in this routine, jst getting
	; here and returning takes more than enough time.
	; the JSR into this routine takes 5 clocks.
	rts		; 5 clocks, total=10 clocks.

EEPROM_END:

