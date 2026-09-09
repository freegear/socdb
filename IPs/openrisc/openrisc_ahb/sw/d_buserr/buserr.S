/* Support file for c based tests */

#include "spr_defs.h"
#include "board.h"
#include "mc.h"

	.extern _exit
	.section .vectors, "ax"
// holelee        .org    0x200
_buserr_vector:
	l.nop
    l.movhi r3,hi(0xdeaddead)
    l.ori   r3,r3,lo(0xdeaddead)
    l.nop   2
	l.jal   _exit
    l.nop

