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

.org 0x0500
_lpint:
	l.nop
	l.nop
	
# clear TTMR[IP]
	l.addi r4,r0,SPR_TTMR
	l.movhi r5,hi(SPR_TTMR_RT | SPR_TTMR_IE)
	l.addi r5,r5,733
	l.mtspr r4,r5,0		# set TTMR

# clear entire PICSR
	l.movhi r4,hi(SPR_PICSR)
	l.addi r4,r0,lo(SPR_PICSR)
	l.addi r5,r0,0x0000
	l.mtspr r4,r5,0		# set PICSR

	l.nop
	l.rfe
	l.nop
	l.nop

.org 0x0800
_hpint:
	l.nop
	l.nop
	
# clear TTMR[IP]
	l.addi r4,r0,SPR_TTMR
	l.movhi r5,hi(SPR_TTMR_RT | SPR_TTMR_IE)
	l.addi r5,r5,733
	l.mtspr r4,r5,0		# set TTMR

# clear entire PICSR
	l.movhi r4,hi(SPR_PICSR)
	l.addi r4,r0,lo(SPR_PICSR)
	l.addi r5,r0,0x0000
	l.mtspr r4,r5,0		# set PICSR

	l.nop
	l.rfe
	l.nop
	l.nop


.org 0x2000

_main:
	l.nop
	l.nop

#
# set tick to generate an interrupt every, let say 729 cycles
#
	l.addi r4,r0,SPR_TTMR
	l.movhi r5,hi(SPR_TTMR_RT | SPR_TTMR_IE)
	l.addi r5,r5,729
	l.mtspr r4,r5,0		# set TTMR

#
# unmask all ints
#
	l.movhi r4,hi(SPR_PICMR)
	l.addi r4,r0,lo(SPR_PICMR)
	l.movhi r5,0xffff
	l.addi r5,r5,0xffff
	l.mtspr r4,r5,0		# set PICMR

#
# Enable exceptions and interrupts
#
	l.addi r5,r0,SPR_SR_SUPV|SPR_SR_EXR|SPR_SR_EIR
	l.mtspr r0,r5,SPR_SR	# set SR

#
# clear sanity counters
#
	l.addi r11,r0,0
	l.addi r12,r0,0
	l.addi r13,r0,0
	l.addi r14,r0,0
	l.addi r15,r0,0
_loop:
	l.addi r11,r11,1
	l.nop
	l.addi r12,r12,1
	l.addi r13,r13,1
	l.j _loop
	l.addi r14,r14,1
	l.addi r15,r15,1
	l.nop
	l.nop
	l.sys 203
	l.nop


