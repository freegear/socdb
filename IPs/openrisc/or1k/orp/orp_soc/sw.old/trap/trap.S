#include "spr_defs.h"

        .extern main
        .extern _src_beg
        .extern _dst_beg
        .extern _dst_end        
        .extern _c_reset

.org 0x100
 
_reset:
	l.nop
	l.nop
	l.movhi r0, 0x0
        l.slli  r0,r0,16
        l.addi  r1,r0,0x0
        l.addi  r2,r0,0x0
        l.addi  r3,r0,0x0
        l.addi  r4,r0,0x0
        l.addi  r5,r0,0x0
        l.addi  r6,r0,0x0
        l.addi  r7,r0,0x0
        l.addi  r8,r0,0x0
        l.addi  r9,r0,0x1234
        l.addi  r10,r0,0x0
        l.addi  r11,r0,0x0
        l.addi  r12,r0,0x0
        l.addi  r13,r0,0x0
        l.addi  r14,r0,0x0
        l.addi  r15,r0,0x0
        l.addi  r16,r0,0x0
        l.addi  r17,r0,0x0
        l.addi  r18,r0,0x0
        l.addi  r19,r0,0x0
        l.addi  r20,r0,0x0
        l.addi  r21,r0,0x0
        l.addi  r22,r0,0x0
        l.addi  r23,r0,0x0
        l.addi  r24,r0,0x0
        l.addi  r25,r0,0x0
        l.addi  r26,r0,0x0
        l.addi  r27,r0,0x0
        l.addi  r28,r0,0x0
        l.addi  r29,r0,0x0
        l.addi  r30,r0,0x0
        l.addi  r31,r0,0x0

        l.movhi r2,hi(_main)
        l.ori   r2,r2,lo(_main)
        l.jr    r2
        l.addi  r2,r0,0

.org 0xd00
_break:
	l.nop
	l.nop
	l.rfe
	l.nop
	l.nop

.org 0xe00
_trap:
	l.nop
	l.nop
	l.rfe
	l.nop
	l.nop

.org 0x2000

_main:
	l.nop
	l.addi	r5,r0,SPR_SR_SUPV|SPR_SR_EXR
	l.mtspr r0,r5,SPR_SR
	l.nop
	l.addi r11,r0,1
	l.addi r11,r0,3
	l.addi r11,r0,5
	l.trap	1
	l.addi r11,r0,10
	l.addi r11,r0,15
	l.j _forw
	l.addi r11,r0,20
	l.addi r11,r0,25
_forw:
	l.addi r11,r0,30
	l.trap	1
	l.addi r11,r0,35
	l.nop
	l.nop
	l.sys 203
	l.nop

