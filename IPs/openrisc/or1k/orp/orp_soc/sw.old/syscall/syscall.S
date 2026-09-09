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
_ipf_except:
_lpint_except:
_align_except:
_illegal_except:
_hpint_except:
_dtlbmiss_except:
_itlbmiss_except:
_range_except:
_syscall_except:
_res1_except:
_trap_except:
_res2_except:
	l.addi r11,r11,20
	l.addi r11,r11,21
	l.rfe
	l.addi r11,r11,22
	l.addi r11,r11,23
	l.nop

.org 0x2000

_main:
	l.nop
	l.addi r11,r0,1
_loop:
	l.addi r11,r11,1
	l.addi r11,r11,2
	l.sys 13
	l.addi r11,r11,3
	l.addi r11,r11,4
	l.addi r11,r11,5
	l.nop
	l.nop
	l.nop
        l.movhi r9,hi(0xdeadde74)
        l.ori   r9,r9,lo(0xdeadde74)
	l.add	r3,r11,r9
	l.jal	_report
	l.nop
	l.jal	_exit
	l.nop

