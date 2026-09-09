/*---------------------------------------------------------------------------*/
/* This file is part of the MANIK-II Embedded processor system. It describes */
/* which peripherals are used and their base memory locations                */
/*---------------------------------------------------------------------------*/

#if !defined(MANIK_SYSTEM_H)
#include <sys_config.h>
#define MANIK_SYSTEM_H

/* if CPU configuration options */
#define INTR_SWIVEC	4
#define INTR_TMRVEC	8

/* MANIK CPU CORE Related defines */
#define	RESET_IRQ	0
#define SWINT_IRQ	1
#define TIMER_IRQ	2
#define EXTRN_IRQ	3
#define BUSERR_IRQ	4

#define RESET_ADDR	0
#define SWINT_ADDR	(SWINT_IRQ*4)
#define TIMER_ADDR	(TIMER_IRQ*4)
#define EXTRN_ADDR	(EXTRN_IRQ*4)
#define BUSERR_ADDR	(BUSERR_IRQ*4)

/* Changes made here should be replicated in GDB */

/* PSW Bits */
#define SW_FLAG (1 << 0)    /* software interrupt */
#define EI_FLAG (1 << 1)    /* External interrupt */
#define TI_FLAG (1 << 2)    /* Timer Interrupt    */
#define IP_FLAG (1 << 3)    /* Interrupt in progress */
#define TE_FLAG (1 << 4)    /* Timer enable flag  */
#define IE_FLAG (1 << 5)    /* Interrupt enable flag (global), external + timer */
#define BIP_FLAG (1 << 6)   /* Backup IP flag in PSW */
#define PD_FLAG (1 << 7)    /* power down flag */
#define TF_FLAG (1 << 8)    /* result of last compare True/False flag */
#define CY_FLAG (1 << 9)    /* carry flag */
#define BD_FLAG (1 << 10)   /* Bypass data cache */
#define II_FLAG (1 << 11)   /* invalidate Instruction cache line */
#define TR_FLAG (1 << 12)   /* Timer reload flag */
#define TU_FLAG (1 << 12)   /* Timer Underflow flag */
#define SS_FLAG (1 << 13)   /* Single step flag */
#define IBER_FLAG (1 << 15) /* Bus error fetching instruction */
#define DBER_FLAG (1 << 14) /* Bus error load/store data */
#define EI0_ENB (1 << 20)   /* enable External interrupt 0 */
#define EI1_ENB (1 << 21)   /* enable External interrupt 1 */
#define EI2_ENB (1 << 22)   /* enable External interrupt 2 */
#define EI3_ENB (1 << 23)   /* enable External interrupt 3 */
#define EI4_ENB (1 << 24)   /* enable External interrupt 4 */
#define EI5_ENB (1 << 25)   /* enable External interrupt 5 */
#define EI0_STAT (1 << 26)  /* External Interrupt 0 status */
#define EI1_STAT (1 << 27)  /* External Interrupt 1 status */
#define EI2_STAT (1 << 28)  /* External Interrupt 2 status */
#define EI3_STAT (1 << 29)  /* External Interrupt 3 status */
#define EI4_STAT (1 << 30)  /* External Interrupt 4 status */
#define EI5_STAT (1 << 31)  /* External Interrupt 5 status */

/* HW - Break/Watch point register bits */
#define HWDBG_BPENB	(1 << 0) /* HW debug BP available (RO) */
#define HWDBG_WPENB	(1 << 1) /* HW debug WP available (RO) */
#define HWDBG_BP0_ENB   (1 << 2) /* HW BP0 enable (RW) */
#define HWDBG_BP1_ENB   (1 << 3) /* HW BP1 enable (RW) */
#define HWDBG_WP0_ENB   (1 << 4) /* HW WP0 enable (RW) */
#define HWDBG_WP1_ENB   (1 << 5) /* HW WP1 enable (RW) */
#define HWDBG_BP_HIT	(1 << 6) /* HW Breakpoint hit */
#define HWDBG_WP0_HIT	(1 << 7) /* HW Watchpoint 0 hit */
#define HWDBG_WP1_HIT	(1 << 8) /* HW Watchpoint 1 hit */

#if !defined(__ASSEMBLER__)
#define GET_SWINUM()  ({ int flag;			      \
		asm volatile ("mfsfr	%0,psw" : "=r"(flag));\
		(flag >> 16) & 0x0f})
#define GET_PSWBIT(x) ({ int flag;			      \
		asm volatile ("mfsfr	%0,psw" : "=r"(flag));\
		((flag & x) ? 1 : 0)})
#define SET_PSWBIT(x) { int flag;\
		asm volatile ("mfsfr	%0,psw" : "=r"(flag));\
		flag |= x;\
		asm volatile ("mtsfr	psw,%0" : : "r"(flag));}
#define CLR_PSWBIT(x) { int flag;\
		asm volatile ("mfsfr	%0,psw" : "=r"(flag));\
		flag &= ~x;\
		asm volatile ("mtsfr	psw,%0" : : "r"(flag));}
#define CLR_PSW() { int flag = 0;\
		asm volatile ("mtsfr	psw,%0" : : "r"(flag));}
#define IO_LOAD8(addr) ({ unsigned char lv;	\
		SET_PSWBIT(BD_FLAG);\
		asm volatile ("ldrb	%0,0(%1)" : "=r"(lv) : "r"(addr));\
		CLR_PSWBIT(BD_FLAG);lv})
#define IO_LOAD16(addr) ({ unsigned short lv;	\
		SET_PSWBIT(BD_FLAG);\
		asm volatile ("ldrh	%0,0(%1)" : "=r"(lv) : "r"(addr));\
		CLR_PSWBIT(BD_FLAG);lv})
#define IO_LOAD32(addr) ({ unsigned int lv;	\
		SET_PSWBIT(BD_FLAG);\
		asm volatile ("ldr	%0,0(%1)" : "=r"(lv) : "r"(addr));\
		CLR_PSWBIT(BD_FLAG);lv})
		
#endif /* !__ASSEMBLER__ */

/* TIMER CONFIGURATION */
#define TICKS_PER_CLK	1 
#define TICKS_PER_SEC   CLK_FREQ/TICKS_PER_CLK

#if !defined(__ASSEMBLER__)
#define TIMER_SET(x) { int timer = x;\
		asm volatile ("mtsfr	timer,%0" :: "r"(timer));}
#define TIMER_GET(x) ({ int timer;\
			asm volatile ("mfsfr	%0,timer": "=r"(timer) );\
			timer;})
#define TIMER_IRQ_START()  SET_PSWBIT(TE_FLAG|IE_FLAG)
#define TIMER_COUNT_START() SET_PSWBIT(TR_FLAG)
#define TIMER_UNDERFLOW() ({int flag ;\
			asm volatile ("mfsfr	%0,psw": "=r"(flag));	\
			flag & (1 << 12)})
#endif /* !__ASSEMBLER__ */
/* TIMER END */

#if !defined(__ASSEMBLER__)
/* register save offsets in the register save
   area used by the interrupt handler */
enum regnames { 
	R0, R1, R2, R3, R4, R5, R6, R7,
	R8, R9, R10, R11, R12, R13, R14, R15,
	PC, PSW, RA, IPC, TIMER, HWDBG,
	HWBP0, HWBP1, HWWP0, HWWP1
};

/* register ISR. 
   "type" can be TIMER_IRQ or EXTRN_IRQ 
   "isr"         pointer to isr
   "xnum" 0-5 valid only for type EXTRN_IRQ (external irq number

   return value is the old pointer
*/
static inline void register_isr(int type, void (*isr)(int *), int xnum)
{
	asm ("mov	r1,%0" :: "r"(type));
	asm ("mov	r2,%0" :: "r"(isr));
	asm ("mov	r3,%0" :: "r"(xnum));
	asm volatile("swint	0x1");
}

/* power down & wait for interrupt */
static inline void power_down()
{
	SET_PSWBIT(PD_FLAG);
}

#endif /* !__ASSEMBLER__ */

#endif
