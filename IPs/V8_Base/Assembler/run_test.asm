;
; For v8 base system test
;
; 2006.6.21
;
;
;

	.org   0x0000

	ldi r1, 0x03
	ldi r0, 0xff
	xsp

	ldi r0, 0x5c
	ldi r2, 0x43
	add r2
	
	psh	r2
	psh r0
	
	ldi r0, 0x31
	pop r2
	
	add r2
	psh r0

loop:
	nop
	nop
	jmp loop
