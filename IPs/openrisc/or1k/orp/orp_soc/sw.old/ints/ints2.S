#include "../support/spr_defs.h"
	.global _test

#
# clear sanity counters
#
_test:
	l.addi r10,r0,0
	l.addi r11,r0,0
	l.addi r12,r0,0
	l.addi r13,r0,0
	l.addi r14,r0,0
	l.addi r7,r0,602
_loop:
	l.sfne	r11,r7
	l.sw	-0x100(r1),r11
	l.lwz	r12,-0x100(r1)
	l.bnf	_stop
	l.sfeq r11,r12
	l.bf _loop
	l.addi r11,r11,1
	l.addi r15,r15,1
	l.nop
_stop:
	l.nop
	l.ori   r8,r0,SPR_SR_EIR|SPR_SR_EXR
	l.mfspr r7,r0,SPR_SR
	l.xor   r7,r7,r8
	l.mtspr r0,r7,SPR_SR

	l.movhi r15,hi(0xdeadd9f9)
	l.ori   r15,r15,lo(0xdeadd9f9)
	l.add   r15,r15,r10
	l.add   r15,r15,r11
	l.add   r15,r15,r12
	l.add   r15,r15,r13
	l.add   r3,r15,r14
	l.jal	_report
	l.nop
	l.jal	_exit
	l.nop

