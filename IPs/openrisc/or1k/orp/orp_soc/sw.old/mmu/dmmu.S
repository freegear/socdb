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
_ipf_except:
_lpint_except:
_align_except:
_illegal_except:
_hpint_except:
_itlbmiss_except:
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

_dpf_except:
	l.addi	r14,r0,64
	l.movhi	r5,hi(0x80000000|SPR_DTLBMR_V)
	l.ori	r5,r5,lo(0x80000000|SPR_DTLBMR_V)
	l.mtspr	r0,r5,SPR_DTLBMR_BASE(0)
	l.movhi	r5,hi(0x80100000|SPR_DTLBTR_SWE|SPR_DTLBTR_SRE)
	l.ori	r5,r5,lo(0x80100000|SPR_DTLBTR_SWE|SPR_DTLBTR_SRE)
	l.mtspr	r0,r5,SPR_DTLBTR_BASE(0)
	l.rfe
	l.nop

_dtlbmiss_except:
	// Valid entry, but no load/store access
	l.addi	r13,r0,128
	l.movhi	r5,hi(0x80000000|SPR_DTLBMR_V)
	l.ori	r5,r5,lo(0x80000000|SPR_DTLBMR_V)
	l.mtspr	r0,r5,SPR_DTLBMR_BASE(0)
	l.ori	r5,r0,0
	l.mtspr	r0,r5,SPR_DTLBTR_BASE(0)
	l.rfe
	l.nop

//
// r4, r5	- used by exception handlers
// r7, r8	- used by main for setting TLB
// r10		- data pointer to magic words
// r11		- accumulator of magic words
// r12		- for loading/storing magic words
// r13, r14	- used ONLY by exception handlers for magic words

_main:
	l.nop
	l.addi	r11,r0,1
	l.addi	r12,r0,1024
	l.movhi	r10,hi(0x80100000)
	l.ori	r10,r10,lo(0x80100000)
	l.sw	0(r10),r12
	l.addi	r12,r0,1
	l.movhi	r10,hi(0x80000000)
	l.ori	r10,r10,lo(0x80000000)
	l.sw	0(r10),r12
	
	// Invalidate entry
	l.movhi	r7,hi(0x80010000)
	l.mtspr	r0,r7,SPR_DTLBMR_BASE(0)
	l.ori	r7,r0,0
	l.mtspr	r0,r7,SPR_DTLBTR_BASE(0)

	// Enable DMMU
	l.ori	r8,r0,SPR_SR_DME
	l.mfspr	r7,r0,SPR_SR
	l.or	r7,r7,r8
	l.mtspr	r0,r7,SPR_SR

	// Invoke DTLB miss and DPF exceptions
	l.sw	32(r10),r7

	// Magic word read
	l.add	r12,r0,r0
	l.lwz	r12,0(r10)
	l.add	r11,r11,r12
	l.add	r11,r11,r13
	l.add	r11,r11,r14

	// Set cache inhibit (CI) bit
	l.movhi	r5,hi(0x80100000|SPR_DTLBTR_SWE|SPR_DTLBTR_SRE)
	l.ori	r5,r5,lo(0x80100000|SPR_DTLBTR_SWE|SPR_DTLBTR_SRE)
	l.mtspr	r0,r5,SPR_DTLBTR_BASE(0)

	// Read from external memory (must be checked manually)
	l.lwz	r12,32(r10)

	// Exit
	l.nop
	l.movhi	r12,hi(0xdeadda6c)
	l.ori	r12,r12,lo(0xdeadda6c)
	l.xor	r3,r11,r12
	l.jal	_report
	l.nop
	l.jal	_exit
	l.nop
	l.nop

