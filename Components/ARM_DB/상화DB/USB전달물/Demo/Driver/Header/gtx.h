////////////////////////////////////////////////////////////////////////
// gtx.h
// This file conatins MOON h/w specific definitions
// Also include Integrator board specific definitions for the convinience
////////////////////////////////////////////////////////////////////////

#define		CM_IRQ_STAT_REG		0x10000040	// used for debugger
#define		CM_IRQ_RSTAT_REG	0x10000044	// used for debugger
#define		CM_IRQ_ENSET_REG	0x10000048	// used for debugger
#define		CM_IRQ_ENCLR_REG	0x1000004c	// used for debugger

#define		LM_IRQ_STAT_REG		0xc0000020
#define		LM_IRQ_RSTAT_REG	0xc0000024
#define		LM_IRQ_ENSET_REG	0xc0000028
#define		LM_IRQ_ENCLR_REG	0xc000002c

#define		IC_IRQ0_STAT_REG	0x14000000
#define		IC_IRQ0_RSTAT_REG	0x14000004
#define		IC_IRQ0_ENSET_REG	0x14000008
#define		IC_IRQ0_ENCLR_REG	0x1400000c

