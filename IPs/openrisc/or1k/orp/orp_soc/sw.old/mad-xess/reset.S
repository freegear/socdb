        .section .reset
	.extern _main
        .extern _src_beg
        .extern _dst_beg
        .extern _dst_end
        .extern _main
        .extern _c_reset
 
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

	/* Copy form flash to sram */

        l.movhi r3,hi(_src_beg)
        l.ori   r3,r3,lo(_src_beg)
        l.movhi r4,hi(_dst_beg)
        l.ori   r4,r4,lo(_dst_beg)
        l.movhi r5,hi(_dst_end)
        l.ori   r5,r5,lo(_dst_end)
        l.sub   r5,r5,r4
        l.sfeqi r5,0
        l.bf    2f
        l.nop
1:      l.lwz   r6,0(r3)
        l.sw    0(r4),r6
        l.addi  r3,r3,4
        l.addi  r4,r4,4
        l.addi  r5,r5,-4
        l.sfgtsi r5,0
        l.bf   	1b
        l.nop

2:

	/* Verify sram data */
/*	l.movhi r3,hi(_src_beg)
        l.ori   r3,r3,lo(_src_beg)
	l.addi	r3,r3,4
        l.movhi r4,hi(_dst_beg)
        l.ori   r4,r4,lo(_dst_beg)
	l.addi	r4,r4,4
        l.movhi r5,hi(_dst_end)
        l.ori   r5,r5,lo(_dst_end)
        l.sub   r5,r5,r4
        l.sfeqi r5,0
        l.bf    2f
        l.nop
1:	l.lwz	r6,0(r3)
	l.lwz	r7,0(r4)
	l.sfeq	r6,r7
	l.bnf	img_err
	l.nop
	l.addi	r3,r3,4
	l.addi	r4,r4,4
	l.addi  r5,r5,-4
        l.sfgtsi r5,0
        l.bf    1b
        l.nop
2:
*/
        l.movhi r1,hi(0x80200000)
        l.addi  r1,r1,lo(0x80200000)
        l.addi  r1,r1,-4
 
        l.movhi r2,hi(_main)
        l.ori   r2,r2,lo(_main)
        l.jr    r2
        l.addi  r2,r0,0

img_err:
	l.movhi r15,hi(0x80000000)
        l.addi  r15,r15,lo(0x80000000)

	l.addi	r8,r6,0
	l.addi	r9,r7,0
	l.addi	r10,r3,0
	l.addi	r11,r4,0
	
	l.sw	0(r15),r8

	l.srli	r8,r8,8
	l.sw    0(r15),r8

        l.srli  r8,r8,8
	l.sw    0(r15),r8

        l.srli  r8,r8,8
	l.sw    0(r15),r8

	l.sw    0(r15),r10
 
        l.srli  r10,r10,8
        l.sw    0(r15),r10
 
        l.srli  r10,r10,8
        l.sw    0(r15),r10
 
        l.srli  r10,r10,8
        l.sw    0(r15),r10


	l.sw    0(r15),r9
 
        l.srli  r9,r9,8
        l.sw    0(r15),r9
 
        l.srli  r9,r9,8
        l.sw    0(r15),r9
 
        l.srli  r9,r9,8
        l.sw    0(r15),r9

        l.sw    0(r15),r11
 
        l.srli  r11,r11,8
        l.sw    0(r15),r11
 
        l.srli  r11,r11,8
        l.sw    0(r15),r11
 
        l.srli  r11,r11,8
        l.sw    0(r15),r11 

	l.addi	r8,r0,0xee
	l.sw	0(r15),r8

	l.j	img_err
	l.nop
