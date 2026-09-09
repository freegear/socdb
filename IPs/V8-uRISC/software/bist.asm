;-------------------------------------------------------------------------------
; Copyright 1997-1998 VAutomation Inc. Nashua NH (603)882-2282 ALL RIGHTS RESERVED.
; This software is provided under license and contains proprietary and
; confidential material which is the property of VAutomation Inc.
;-------------------------------------------------------------------------------
;
; BIST.ASM
; Description:
; This is the Built-In-Self-Test ROM typically used in the V8.
; It provides approximately ??% fault coverage and requires only
; 128 bytes of ROM.
;
; This test executes every opcode at least once (except for the USR opcode).
; If there is a failure, the test jumps back to addr 0 and reruns the test again.
; Thus, it effectively runs in a "scope loop" if there is an error. Note that
; at the end of the test we just keep on executing. No return or anything is 
; performed. Typically a "boot" routine is placed immediately after this test.
; 
; The BIST_RAM label must be defined outside of this routine. It's the address
; of a few locations of RAM needed by this test. Typically its placed near
; the bottom of the stack.
;
; V8 opcodes are:
; Assembler notation; Description
;	inc	Rn	; Increment Rn (NZC)
;	adc	Rn	; R0= R0 + Rn + carry (NZC)
;	tx0	Rn	; Transfer Rn to register 0 (reg0 to reg0 is the nop)
;	and	Rn	; R0= R0 & Rn (NZ)
;	or	Rn	; R0= R0 | Rn (NZ)
;	xor	Rn	; R0= R0 ^ Rn (NZ)
;	rol	Rn	; rotate left Rn (NZC)
;	ror	Rn	; rotate right Rn (NZC)
;	dec	Rn	; Decrement Rn (NZC)
;	sbc	Rn	; R0= R0 - Rn - NOT carry (NZC)
;	t0x	Rn	; Transfer R0 to register Rn
;	cmp	Rn	; R0 - Rn (NZC)
;	add	Rn	; R0 = R0 + Rn (NZC)
;	btt	#	; R0 bit test	REG field specifies bit
;	stp	#	; PSR bit set	REG field specifies bit
;	clp	#	; PSR bit clear	REG field specifies bit
;	BR0	#,offset; Relative branch if PSR bit 0
;	BR1	#,offset; Relative branch if PSR bit 1
; Note, there are several MACROs in the assembler which make branches
; a little easier to understand:
; BRNE = BR0 0,	;branch if Not Equal (the Z bit is a 0)
; BREQ = BR1 0,	;branch if EQual (the Z bit is a 1)
; BRCC = BR0 1,	;branch if Carry Clear (the C bit is a 0)
; BRCS = BR1 1,	;branch if Carry Set (the C bit is a 1)
; BRPL = BR0 2,	;branch if PLus (the N bit is a 0)
; BRMI = BR1 2,	;branch if MInus (the N bit is a 1)
; BRIC = BR0 3,	;branch if Interrupt mask Clear (the I bit is a 0)
; BRIS = BR1 3,	;branch if Interrupt mask Set (the I bit is a 1)
;	JSR	addr	; absolute jump to subroutine (REG must be 0)
;	rts		 ; Return from subroutine (REG is 0)
;	RTI		 ; Return from interrupt (REG is 1)
;	USR		; User defined opcode (default is a nop)
;	USR2		; User defined opcode (default is a nop)
; Note that the USR and USR2 opcodes are not tested with this test since since
; we don't know what the functionality is.
;	INT	#	; Interrupt (push only PC & PSR) 8 vectors
;	upp	Rn	; Increment register pair
;	psh	Rn	; Push register on the stack
;	pop	Rn	; POP register from the stack
;	JMP	addr	; absolute jump (REG must be 0)
;	sta	 Rn,addr	; store Rn absolute
;	stx	 Rn	; store R0 indexed without an offset
;	sto	Rn,offset;store reg 0 indexed + offset
;	ldi	 Rn,value; Load Rn Immediate (NZ)
;	lda	Rn,addr	; Load Rn absolute (NZ)
;	ldx	 Rn	; load R0 indexed without offset (NZ)
;	ldo	Rn,offset;Load R0 indexed + offset (NZ)
;
;Rn = 3 bit register that goes in the REG field of the instruction.
;# = 3 bit encoded value of the bit being operated on.
;addr = 16 bit address
;offset = 8 bit relative offset, +127 to -128
;value = 8 bit value
;The (NZC) indicates the bits in the PSR which are updated by the opcode.
;
; Revision History:
; $Log: bist.asm,v $
; Revision 1.2  1998/05/27 16:46:20  russell
; copyright
;
; Revision 1.1  1996/12/23 16:55:37  eric
; Initial revision
;

BIST:;;;;;;;;;;;;;;;Begin Execution here;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FAILBIST:	; if we fail, we rerun the test in a "scope loop" fashion.
	; this routine tests all of the opcodes at least once.
	ldi	r0,0	; load register 0 with a 0
	br0	0,FAILBIST:	; Zero bit of the PSR should be set
	ldi	r1,0xef; load R1 with Z=0
	btt	4	; test bit 4, Z=1
	BREQ	BIST1:	; Zero bit of the PSR should be clear
	; Note that BREQ is a macro for BR1 0, and BRNE is BR0 0,
	; We should always take this jump.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The O_JSR subroutine is very small. Simply increments R0.
; This tests both the JSR and rts opcodes
O_JSR:	inc	r0
	rts
	; Normal program flow jumps around the next couple of lines to BIST2...
NEG_BRANCH:	; we use this space for a negative branch
	jmp	BIST3:;
BIST1:	
	ldi	r7,BIST_RAM:>>8; Load R7 with the MSB of BIST_RAM
	ldi	r6,BIST_RAM:; Load R6 with the LSB of BIST_RAM
	t0x	r2	; r2 = 0
	dec	r0
	t0x	r3	; r3 = ff
	BRPL	FAILBIST:
	tx0	r7
	t0x	r5
	tx0	r6
	t0x	r4	; R4-R5 and R6-R7 have the same address
		; at this point all registers should be defined. No more
		; Xes allowed!
	cmp	 r6
	brne	FAILBIST:	; They should be the same and we should branch, Error if we don't
	tx0	R3	; R0 = ff
	inc	R3	; R3 = 0 now
	BRNE	FAILBIST:
	stp	1	; set the carry
	adc	R3	; R0 = FF + 0 + 1 = 0 and set the carry!
	BRMI	FAILBIST:
	BRCC	FAILBIST:
	clp	0	; clear the Z bit
	BRNE	NEG_BRANCH:; we should branch backwards

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The O_INT subroutine Simply decrements R0.
O_INT:	dec	r0
	rti	; note that because this is an Interrupt, 
		; the PSR should remain the same after we return.

BIST3:	ldi	r0, 0xa5	; test arithmetic ops by generating
	ldi	r1,0xc0		; a "signature" in RAM
	ldi	r2,0xfc	;
	ldi	r3,0x0f	;
	AND	R2	; R0 = a5 & FC = a4
	OR	R1	; R0 = a4 | c0 = e4
	XOR	R3	; R0 = e4 ^ 0f = eb
	rol	R0	; R0 = d7
	ror	R3	; R3 = 87
	dec	r1	; R1 = bf
	sbc	r3	; R0 = d7-87 = 50
	add	r0	; R0 = a0
	sta	r1,BIST_RAM:	; BIST_RAM = bf
	upp	r6
	stx	r6	; BIST_RAM+1 = a0
	tx0	r2
	sto	r6,1	; BIST_RAM+2 = fc
; now do some compares and test loading...
	inc	r6
	ldx	r6
	t0x	r1	; R1=fc
	dec	r6
	dec	r6
	dec	r6
	ldo	r6,1
	t0x	r2	; R2=bf
	lda	r3,BIST_RAM:+1;	R3=a0
	ldi	r0,0xa0;
	cmp	r3;
	brne	FAILBIST:
	ldi	r0,0xbf
	xor	r2	; XOR is same as CMP when testing for EQ
	brne	FAILBIST:	; using other ops gives better fault coverage.
	ldi	r0,4	; fc + 4 = 00 which sets the Z bit indicating EQ
	clp	1	; clear the Carry bit
	adc	r1	; ADC is same as CMP when testing for EQ
	brne	FAILBIST: 
; we've tested loads and stores...
; now we need to test the stack opcodes...
	psh	r6
	pop	r0
	cmp	r6
	brne	FAILBIST:	; Push and Pop are tested...
	jsr	O_JSR:
	dec	r0
	cmp	r6
	brne	FAILBIST:	; O_JSR incremented R0, if it worked that is...
	ldi	r4,0x0c
	ldi	r5,INT_VEC_TABLE>>8
	ldi	r0,O_INT:	; replace interrupt 6 with O_INT routine
	stx	r4
	ldi	r0,O_INT:>>8
	sto	r4,1
	ldi	r0,0
	INT	6	; level 6 interrupt
	brne	FAILBIST:	; PSR should be unchanged even though we decremented R0
	inc	r0
	brne	FAILBIST:	; R0 should be zero again...

;;;;;;;;;;;;;;;;;;;;;;; We're all done! works if we got to here!;;;;;;;;;;;;;;;;;;;;;;;
;; note that we just fall off the end of this test.
; It is assumed that a Boot routine immediately follows.
