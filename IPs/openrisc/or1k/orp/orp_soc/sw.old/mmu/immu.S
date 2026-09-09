/* Basic instruction set test */
#include "../support/spr_defs.h"

.global _main
.global _buserr_except
.global _dpf_except
.global _ipf_except
.global _lpint_except
.global _align_except
.global _illegal_except
.global _hpint_except
.global _dtlbmiss_except
.global _itlbmiss_except
.global _range_except
.global _syscall_except
.global _res1_except
.global _trap_except
.global _res2_except

_buserr_except:
_dpf_except:
_lpint_except:
_align_except:
_illegal_except:
_hpint_except:
_dtlbmiss_except:
_range_except:
_syscall_except:
_res1_except:
_trap_except:
_res2_except:
	l.nop
	l.ori	r3,r0,0xeeee
	l.jal	_report
	l.nop
	l.jal	_exit
	l.nop

_ipf_except:
	// Valid entry 1, 1:1, full access
	l.addi	r14,r0,64
	l.movhi	r5,hi(0x00002000|SPR_ITLBMR_V)
	l.ori	r5,r5,lo(0x00002000|SPR_ITLBMR_V)
	l.mtspr	r0,r5,SPR_ITLBMR_BASE(0)+1
	l.movhi	r5,hi(0x00002000|SPR_ITLBTR_SXE|SPR_ITLBTR_UXE)
	l.ori	r5,r5,lo(0x00002000|SPR_ITLBTR_SXE|SPR_ITLBTR_UXE)
	l.mtspr	r0,r5,SPR_ITLBTR_BASE(0)+1
	l.rfe
	l.nop

_itlbmiss_except:
	// Valid entry 1, but no execute access
	l.addi	r13,r0,128
	l.movhi	r5,hi(0x00002000|SPR_ITLBMR_V)
	l.ori	r5,r5,lo(0x00002000|SPR_ITLBMR_V)
	l.mtspr	r0,r5,SPR_ITLBMR_BASE(0)+1
	l.ori	r5,r0,0
	l.mtspr	r0,r5,SPR_ITLBTR_BASE(0)+1
	l.rfe
	l.nop

//
// r4, r5	- used by exception handlers
// r7, r8	- used by main for setting TLB
// r11		- accumulator of magic words
// r13, r14	- used ONLY by exception handlers for magic words

_main:
	l.nop
	l.addi	r11,r0,1
	
	// Valid entry 0, 1:1, full access
	l.movhi	r5,hi(0x00000000|SPR_ITLBMR_V)
	l.ori	r5,r5,lo(0x00000000|SPR_ITLBMR_V)
	l.mtspr	r0,r5,SPR_ITLBMR_BASE(0)
	l.movhi	r5,hi(0x00000000|SPR_ITLBTR_UXE|SPR_ITLBTR_SXE)
	l.ori	r5,r5,lo(0x00000000|SPR_ITLBTR_UXE|SPR_ITLBTR_SXE)
	l.mtspr	r0,r5,SPR_ITLBTR_BASE(0)

	// Invalidate entry 1
	l.movhi	r7,hi(0x00002000)
	l.mtspr	r0,r7,SPR_ITLBMR_BASE(0)+1
	l.ori	r7,r0,0
	l.mtspr	r0,r7,SPR_ITLBTR_BASE(0)+1

	// Enable IMMU
	l.ori	r8,r0,SPR_SR_IME
	l.mfspr	r7,r0,SPR_SR
	l.or	r7,r7,r8
	l.mtspr	r0,r7,SPR_SR
	l.nop
	l.nop
	l.addi	r11,r11,16

	// Invoke ITLB miss and IPF exceptions
	l.jal	_immu_test
	l.addi	r11,r11,4

	// Some more magic words
	l.addi	r11,r11,8
	l.add	r11,r11,r13
	l.add	r11,r11,r14

	// Disable IMMU
	l.ori	r8,r0,SPR_SR_IME
	l.mfspr	r7,r0,SPR_SR
	l.xor	r7,r7,r8
	l.mtspr	r0,r7,SPR_SR
	l.nop

	// Exit
	l.nop
	l.movhi	r12,hi(0xdeadde72)
	l.ori	r12,r12,lo(0xdeadde72)
	l.xor	r3,r11,r12
	l.jal	_report
	l.nop
	l.jal	_exit
	l.nop
	l.nop


.org 0x2000

_immu_test:
	l.addi	r11,r11,2
	l.jr	r9
	l.nop
	
