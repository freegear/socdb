#include "spr_defs.h"

        .extern main
        .extern _src_beg
        .extern _dst_beg
        .extern _dst_end        

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

.org 0x2000

_main:
	l.nop
	l.nop

_loop:
	l.addi r11,r11,1
	l.addi r11,r11,2
	l.addi r11,r11,3
	l.addi r4,r0,SPR_PC
	l.movhi r5,hi(_setpc)
	l.addi r5,r5,lo(_setpc)
	l.mtspr r4,r5,0         # set PC
	l.addi r11,r11,4
	l.j _stop
	l.addi r11,r11,5
	l.nop

.org 0x3000

_setpc:
	l.addi r12,r12,1
	l.addi r12,r12,2

_stop:
	l.addi r12,r12,3
	l.nop
	l.movhi	r15,hi(0xdeaddea1)
	l.ori	r15,r15,lo(0xdeaddea1)
	l.add	r15,r15,r11
	l.add	r15,r15,r12
	l.mtspr	r0,r15,0x1234
	l.nop
	l.sys 203
	l.nop

