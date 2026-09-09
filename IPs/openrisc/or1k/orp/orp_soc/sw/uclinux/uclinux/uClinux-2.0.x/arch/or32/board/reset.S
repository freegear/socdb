#include <asm/spr_defs.h>
#include <asm/board.h>
#include <asm/mc.h>

#undef IC_ENABLE
#define IC_ENABLE 1

        .extern _reset_support
        .extern _src_beg
        .extern _dst_beg
        .extern _dst_end        
        .extern _c_reset
 
        .global start
        .global _lolev_ie
        .global _str

        .section .stack
        .space 0x30000
_stack:

        .section .reset, "a"

        .org 0x100
start:
_reset:
        l.addi  r3,r0,SPR_SR_SM
        l.mtspr r0,r3,SPR_SR
        l.movhi r3,hi(_start)
        l.ori   r3,r3,lo(_start)
        l.jr    r3
        l.nop

        .section .text

_start:
        l.jal   init_mc
        l.nop

.if IC_ENABLE
        l.jal   _ic_enable
        l.nop
.endif

      	/* Copy form flash to sram */
.if 1
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
.endif

        l.movhi r1,hi(_stack)
        l.addi  r1,r1,lo(_stack)
        l.addi  r1,r1,-4
 
        l.movhi r3,hi(_linux_start)
        l.ori   r3,r3,lo(_linux_start)
        l.addi  r4,r0,0
        l.jal   _decompress
        l.nop

        l.addi  r2,r0,0x100
        l.jr    r2
        l.addi  r2,r0,0

init_mc:

        l.movhi r3,hi(MC_BASE_ADD)
        l.ori   r3,r3,lo(MC_BASE_ADD)
 
        l.addi  r4,r3,MC_CSC(0)
        l.movhi r5,hi(FLASH_BASE_ADD)
        l.srai  r5,r5,5
        l.ori   r5,r5,0x0025
        l.sw    0(r4),r5
 
        l.addi  r4,r3,MC_TMS(0)
        l.movhi r5,hi(FLASH_TMS_VAL)
        l.ori   r5,r5,lo(FLASH_TMS_VAL)
        l.sw    0(r4),r5
 
        l.addi  r4,r3,MC_BA_MASK
        l.addi  r5,r0,MC_MASK_VAL
        l.sw    0(r4),r5
 
        l.addi  r4,r3,MC_CSR
        l.movhi r5,hi(MC_CSR_VAL)
        l.ori   r5,r5,lo(MC_CSR_VAL)
        l.sw    0(r4),r5

        l.addi  r4,r3,MC_TMS(1)
        l.movhi r5,hi(SDRAM_TMS_VAL)
        l.ori   r5,r5,lo(SDRAM_TMS_VAL)
        l.sw    0(r4),r5

        l.addi  r4,r3,MC_CSC(1)
        l.movhi r5,hi(SDRAM_BASE_ADD)
        l.srai  r5,r5,5
        l.ori   r5,r5,0x0411
        l.sw    0(r4),r5
 
        l.jr    r9
        l.nop

_ic_enable:
        /* Disable IC */
        l.mfspr r13,r0,SPR_SR
        l.addi  r11,r0,-1
        l.xori  r11,r11,SPR_SR_ICE
        l.and   r11,r13,r11
        l.mtspr r0,r11,SPR_SR
      
        /* Invalidate IC */
        l.addi  r13,r0,0
        l.addi  r11,r0,IC_SIZE
1:
        l.mtspr r0,r13,SPR_ICBIR
        l.sfne  r13,r11
        l.bf    1b
        l.addi  r13,r13,IC_LINE
        
        /* Enable IC */
        l.mfspr r13,r0,SPR_SR
        l.ori   r13,r13,SPR_SR_ICE
        l.mtspr r0,r13,SPR_SR
        l.nop
        l.nop
        l.nop
        l.nop
        l.nop
        
        l.jr    r9
        l.nop

 	.global __print
__print:
	l.lwz	r3,0(r1)
	l.addi	r4,r1,4
#	l.sys	202
        l.nop 3
	l.jr	r9
	l.nop



