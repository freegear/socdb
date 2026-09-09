
#include "../support/spr_defs.h"

        .extern _test
        .extern _test
	.global _main


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
_ipf_except:
_align_except:
_illegal_except:
_dtlbmiss_except:
_itlbmiss_except:
_range_except:
_syscall_except:
_res1_except:
_trap_except:
_res2_except:

.org 0x0500
_lpint_except:
	l.nop
	l.nop
	
# clear TTMR[IP]
	l.addi r4,r0,SPR_TTMR
	l.movhi r5,hi(SPR_TTMR_RT | SPR_TTMR_IE)
	l.addi r5,r5,233
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
_hpint_except:
	l.nop
	l.nop
	
# clear TTMR[IP]
	l.addi r4,r0,SPR_TTMR
	l.movhi r5,hi(SPR_TTMR_RT | SPR_TTMR_IE)
	l.addi r5,r5,233
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
# set tick to generate an interrupt every, let say 329 cycles
#
	l.addi r4,r0,SPR_TTMR
	l.movhi r5,hi(SPR_TTMR_RT | SPR_TTMR_IE)
	l.addi r5,r5,329
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
	l.mfspr	r5,r0,SPR_SR
	l.ori r5,r5,SPR_SR_SUPV|SPR_SR_EXR|SPR_SR_EIR
	l.mtspr r0,r5,SPR_SR	# set SR

#
# jump to main routine
#
	l.j _test
	l.nop
