#include "../support/spr_defs.h"
	.global _test

#
# clear sanity counters
#
_test:
	l.addi	r10,r0,0
	l.addi	r11,r0,0
	l.addi	r12,r0,0
	l.addi	r13,r0,0
	l.addi	r14,r0,0
	l.addi	r15,r0,0
	l.addi	r7,r0,300
_loop:
	l.addi	r10,r10,1
#	l.nop
	l.addi	r11,r11,1
	l.addi	r12,r12,1
	l.sfeq	r13,r7
	l.bnf	_loop
	l.addi	r13,r13,1
	l.addi	r14,r14,1

	l.ori	r8,r0,SPR_SR_EIR|SPR_SR_EXR
	l.mfspr	r7,r0,SPR_SR
	l.xor	r7,r7,r8
	l.mtspr	r0,r7,SPR_SR

	l.nop
	l.movhi	r15,hi(0xdeadd9f8)
	l.ori	r15,r15,lo(0xdeadd9f8)
	l.add	r15,r15,r10
	l.add	r15,r15,r11
	l.add	r15,r15,r12
	l.add	r15,r15,r13
	l.add	r3,r15,r14
	l.jal	_report
	l.nop
	l.jal	_exit
	l.nop

