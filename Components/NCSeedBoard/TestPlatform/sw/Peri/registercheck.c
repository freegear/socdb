/*-------------------------------------------------------------------
File name : registercheck.c

middle level routines
----------------------------------------------------------------------*/
/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"

#include "irq.h"
#include "registeraddr.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

#define TOGGLE_DATA         0x55555555


#if __GCC_ARM__
#define CHK_FMC         	0
#else
#define CHK_FMC         	1
#endif
#define CHK_ESMC        	1
#define CHK_UART        	1
#define CHK_I2C         	1
#define CHK_TIMER       	1
#define CHK_PWM         	1
#define CHK_WDT         	1
#define CHK_GPIO        	1
#define CHK_VIC         	1
#define CHK_ADC         	1
#define CHK_POWER       	1

#define REG_BITMASK_32		0xFFFFFFFF
#define REG_BITMASK_24		0x00FFFFFF
#define REG_BITMASK_23		0x007FFFFF
#define REG_BITMASK_16		0x0000FFFF
#define REG_BITMASK_13		0x00001FFF
#define REG_BITMASK_12		0x00000FFF
#define REG_BITMASK_11		0x000007FF
#define REG_BITMASK_10		0x000003FF
#define REG_BITMASK_9		0x000001FF
#define REG_BITMASK_8		0x000000FF
#define REG_BITMASK_7		0x0000007F
#define REG_BITMASK_6		0x0000003F
#define REG_BITMASK_4		0x0000000F
#define REG_BITMASK_1		0x00000001
#define REG_BITMASK_0		0x00000000
/* FMC */               	
#define REG_FSO_MASK		0xFFFF    
#define REG_FPO_MASK		0x08020000
#define REG_TPROG_MASK		0x007FFFFF
/* ESMC */              	
#define REG_ESMC_MASK		0x0FFC0FFF
/* I2C */
#define REG_I2C_ICCR0_MASK	0xA0
#define REG_I2C_IAR_MASK	0xFF07

// Control register mask
#define REG_FMUCON_MASK		0x3AF
#define REG_UARTCR_MASK		0xC080
#define REG_I2C_ICSR_MASK	0x10
#define REG_TCON_MASK		0x3F
#define REG_WDTCR_MASK		0x3E
#define REG_INTCON_MASK		0xF
#define REG_ADCCON_MASK		0x3F
#define REG_SYSCON_MASK		0xFFFE


/*/////////////////////////////////////////////////////////
        VARIABLE DEFINITION
///////////////////////////////////////////////////////// */
static smtUint32 regListFMC[][3] = {
	/* R/W mode		Reg addr			Bit mask */
    /* FMC */
    {READ_WRITE,	REG_FMKEY,			REG_BITMASK_32},
    {READ_WRITE,	REG_FMADDR,			REG_BITMASK_32},
    {READ_WRITE,	REG_FMDATA,			REG_BITMASK_32},
    // FMUCON address location
    {READ_ONLY,		REG_FSO,			REG_BITMASK_32},
    {READ_ONLY,		REG_FPO,			REG_BITMASK_32},

    {READ_WRITE,	REG_FMTNV,			REG_BITMASK_32}, 
    {READ_WRITE,	REG_FMTPG,			REG_BITMASK_32},
    {READ_WRITE,	REG_FMTRCV,			REG_BITMASK_32},
    {READ_WRITE,	REG_FMTPROG,		REG_BITMASK_23},
    {READ_WRITE,	REG_FMTERASE,		REG_BITMASK_32},
    {READ_WRITE,	REG_FMTME,			REG_BITMASK_32},

	// FMC control register
	{READ_WRITE,	REG_FMUCON,			REG_FMUCON_MASK},
    {READ_WRITE,	0,					REG_BITMASK_32}     // End of register list
};

static smtUint32 regListESMC[][3] = {
    /* ESMC */
    // Current main memory is bank0 external memory. So this control register don't touch.
    //{READ_WRITE,	REG_ESMC_B0_CON,	REG_ESMC_MASK},		
    {READ_WRITE,	REG_ESMC_B1_CON,	REG_ESMC_MASK},
    {READ_WRITE,	REG_ESMC_B2_CON,	REG_ESMC_MASK},
    {READ_WRITE,	REG_ESMC_B3_CON,	REG_ESMC_MASK},
    {READ_WRITE,	0,					REG_BITMASK_32}     // End of register list
};

static smtUint32 regListUART[][3] = {
    /* UART */
    {READ_WRITE,	REG_UARTDR,			REG_BITMASK_0},	// REG_BITMASK_8
    {READ_WRITE,	REG_UARTSR,			REG_BITMASK_0},	// REG_BITMASK_4
                	          			
    {READ_ONLY,	REG_UARTFR,				REG_BITMASK_9},
                	
    {READ_WRITE,	REG_UARTILPR,		REG_BITMASK_0},// REG_BITMASK_32
    {READ_WRITE,	REG_UARTIBRD,		REG_BITMASK_16},
    {READ_WRITE,	REG_UARTFBRD,		REG_BITMASK_6},
    {READ_WRITE,	REG_UARTLCR_H,		REG_BITMASK_8},
    // UARTCR address location
    {READ_WRITE,	REG_UARTIFLS,		REG_BITMASK_6},
    {READ_WRITE,	REG_UARTIMSC,		REG_BITMASK_11},
    {READ_ONLY,		REG_UARTRIS,		REG_BITMASK_11},
    {READ_ONLY,		REG_UARTMIS,		REG_BITMASK_11},
    {READ_WRITE,	REG_UARTICR,		REG_BITMASK_0},// REG_BITMASK_11
    {READ_WRITE,	REG_UARTDMACR,		REG_BITMASK_0},

	// UART control register
    {READ_WRITE,	REG_UARTCR,			REG_UARTCR_MASK},
    {READ_WRITE,	0,					REG_BITMASK_32}     // End of register list
};

static smtUint32 regListI2C[][3] = {
    /* I2C */
    {READ_WRITE,	REG_ICCR0_0,		REG_I2C_ICCR0_MASK},
    // ICSR0 address location
    {READ_WRITE,	REG_IAR0,			REG_I2C_IAR_MASK},
    {READ_WRITE,	REG_IDSR0,			REG_BITMASK_0},
    {READ_WRITE,	REG_ICCR0_1,		REG_BITMASK_7},
                	
    {READ_WRITE,	REG_ICCR1_0,		REG_I2C_ICCR0_MASK},
    // ICSR1 address location
    {READ_WRITE,	REG_IAR1,			REG_I2C_IAR_MASK},
    {READ_WRITE,	REG_IDSR1,			REG_BITMASK_0},
    {READ_WRITE,	REG_ICCR1_1,		REG_BITMASK_7},

	// I2C control register
	{READ_WRITE,	REG_ICSR0,			REG_I2C_ICSR_MASK},
	{READ_WRITE,	REG_ICSR1,			REG_I2C_ICSR_MASK},
    {READ_WRITE,	0,					REG_BITMASK_32}     // End of register list
};

static smtUint32 regListTimer[][3] = {
    /* Timer */
    {READ_WRITE,	REG_TDAT0,	REG_BITMASK_16},	{READ_WRITE, REG_TDAT1,	REG_BITMASK_16},	{READ_WRITE, REG_TDAT2,	REG_BITMASK_16},
    {READ_WRITE,	REG_TPRE0,	REG_BITMASK_8 },	{READ_WRITE, REG_TPRE1,	REG_BITMASK_8 },	{READ_WRITE, REG_TPRE2,	REG_BITMASK_8 },
    // TCON0/1/2 address location
    {READ_ONLY, 	REG_TCNT0,	REG_BITMASK_32},	{READ_ONLY, REG_TCNT1,	REG_BITMASK_32}, 	{READ_ONLY, REG_TCNT2,	REG_BITMASK_32},
    {READ_WRITE,	REG_TPWM0,	REG_BITMASK_16}, 	{READ_WRITE, REG_TPWM1,	REG_BITMASK_16},	{READ_WRITE, REG_TPWM2,	REG_BITMASK_16},
                	         	  	                        	
                	         	  	                        	
    {READ_WRITE,	REG_TDAT3,	REG_BITMASK_16},	{READ_WRITE, REG_TDAT4,	REG_BITMASK_16},	{READ_WRITE, REG_TDAT5,	REG_BITMASK_16},
    {READ_WRITE,	REG_TPRE3,	REG_BITMASK_8 },	{READ_WRITE, REG_TPRE4,	REG_BITMASK_8 },	{READ_WRITE, REG_TPRE5,	REG_BITMASK_8 },
    // TCON3/4/5 address location
    {READ_ONLY, 	REG_TCNT3,	REG_BITMASK_32},	{READ_ONLY, REG_TCNT4,	REG_BITMASK_32}, 	{READ_ONLY, REG_TCNT5,	REG_BITMASK_32},
    {READ_WRITE,	REG_TPWM3,	REG_BITMASK_16},	{READ_WRITE, REG_TPWM4,	REG_BITMASK_16},	{READ_WRITE, REG_TPWM5,	REG_BITMASK_16},
                	         	  		                  
                	         	  		                  
    {READ_WRITE,	REG_TDAT6,	REG_BITMASK_16},	{READ_WRITE, REG_TDAT7,	REG_BITMASK_16},
    {READ_WRITE,	REG_TPRE6,	REG_BITMASK_8 },	{READ_WRITE, REG_TPRE7,	REG_BITMASK_8 },
    // TCON6/7 address location
    {READ_ONLY, 	REG_TCNT6,	REG_BITMASK_32},	{READ_ONLY, REG_TCNT7,	REG_BITMASK_32},
    {READ_WRITE,	REG_TPWM6,	REG_BITMASK_16},	{READ_WRITE, REG_TPWM7,	REG_BITMASK_16},

	// Timer control register
	{READ_WRITE,	REG_TCON0,	REG_TCON_MASK },	{READ_WRITE, REG_TCON1,	REG_TCON_MASK },	{READ_WRITE, REG_TCON2,	REG_TCON_MASK },
	{READ_WRITE,	REG_TCON3,	REG_TCON_MASK },	{READ_WRITE, REG_TCON4,	REG_TCON_MASK },	{READ_WRITE, REG_TCON5,	REG_TCON_MASK },
	{READ_WRITE,	REG_TCON6,	REG_TCON_MASK },	{READ_WRITE, REG_TCON7,	REG_TCON_MASK },
    {READ_WRITE,	0,			REG_BITMASK_32}     // End of register list
};

static smtUint32 regListPWM[][3] = {
    /* PWM */
    {READ_WRITE,	REG_PDAT0_0,REG_BITMASK_16},	{READ_WRITE, REG_PDAT0_1,REG_BITMASK_16},{READ_WRITE, REG_PDAT0_2,	REG_BITMASK_16},
    {READ_WRITE,	REG_PPRE0_0,REG_BITMASK_8 },	{READ_WRITE, REG_PPRE0_1,REG_BITMASK_8 },{READ_WRITE, REG_PPRE0_2,	REG_BITMASK_8 },
    // PCON0_0/1/2 address location
    {READ_ONLY, 	REG_PCNT0_0,REG_BITMASK_32},	{READ_ONLY, REG_PCNT0_1, REG_BITMASK_32},{READ_ONLY, REG_PCNT0_2,	REG_BITMASK_32},
    {READ_WRITE,	REG_PPWM0_0,REG_BITMASK_16},	{READ_WRITE, REG_PPWM0_1,REG_BITMASK_16},{READ_WRITE, REG_PPWM0_2,	REG_BITMASK_16},
                	           	  	                          	
                	           	  	                          	
    {READ_WRITE,	REG_PDAT0_3,REG_BITMASK_16},	{READ_WRITE, REG_PDAT0_4,REG_BITMASK_16},{READ_WRITE, REG_PDAT0_5,	REG_BITMASK_16},
    {READ_WRITE,	REG_PPRE0_3,REG_BITMASK_8 },	{READ_WRITE, REG_PPRE0_4,REG_BITMASK_8 },{READ_WRITE, REG_PPRE0_5,	REG_BITMASK_8 },
    // PCON0_3/4/5 address location
    {READ_ONLY, 	REG_PCNT0_3,REG_BITMASK_32},	{READ_ONLY, REG_PCNT0_4, REG_BITMASK_32},{READ_ONLY,  REG_PCNT0_5,	REG_BITMASK_32},
    {READ_WRITE,	REG_PPWM0_3,REG_BITMASK_16},	{READ_WRITE, REG_PPWM0_4,REG_BITMASK_16},{READ_WRITE, REG_PPWM0_5,	REG_BITMASK_16},
                	           	  	                          	
                	           	  	                          	
    {READ_WRITE,	REG_PDAT0_6,REG_BITMASK_16},	{READ_WRITE, REG_PDAT0_7,REG_BITMASK_16},{READ_WRITE, REG_PDAT1_0,	REG_BITMASK_16},
    {READ_WRITE,	REG_PPRE0_6,REG_BITMASK_8 },	{READ_WRITE, REG_PPRE0_7,REG_BITMASK_8 },{READ_WRITE, REG_PPRE1_0,	REG_BITMASK_8 },
    // PCON0_6/7/1_0 address location
    {READ_ONLY, 	REG_PCNT0_6,REG_BITMASK_32},	{READ_ONLY, REG_PCNT0_7, REG_BITMASK_32},{READ_ONLY,  REG_PCNT1_0,	REG_BITMASK_32},
    {READ_WRITE,	REG_PPWM0_6,REG_BITMASK_16},	{READ_WRITE, REG_PPWM0_7,REG_BITMASK_16},{READ_WRITE, REG_PPWM1_0,	REG_BITMASK_16},
                	           	  	                          	
                	           	  	                          	
    {READ_WRITE,	REG_PDAT1_1,REG_BITMASK_16},	{READ_WRITE, REG_PDAT1_2,REG_BITMASK_16},{READ_WRITE, REG_PDAT1_3,	REG_BITMASK_16},
    {READ_WRITE,	REG_PPRE1_1,REG_BITMASK_8 },	{READ_WRITE, REG_PPRE1_2,REG_BITMASK_8 },{READ_WRITE, REG_PPRE1_3,	REG_BITMASK_8 },
    // PCON1_1/2/3 address location
    {READ_ONLY, 	REG_PCNT1_1,REG_BITMASK_32},	{READ_ONLY, REG_PCNT1_2, REG_BITMASK_32},{READ_ONLY,  REG_PCNT1_3,	REG_BITMASK_32},
    {READ_WRITE,	REG_PPWM1_1,REG_BITMASK_16},	{READ_WRITE, REG_PPWM1_2,REG_BITMASK_16},{READ_WRITE, REG_PPWM1_3,	REG_BITMASK_16},
                	             	                          	
                	             	                          	
    {READ_WRITE,	REG_PDAT1_4,REG_BITMASK_16},	{READ_WRITE, REG_PDAT1_5,REG_BITMASK_16},{READ_WRITE, REG_PDAT1_6,	REG_BITMASK_16},
    {READ_WRITE,	REG_PPRE1_4,REG_BITMASK_8 },	{READ_WRITE, REG_PPRE1_5,REG_BITMASK_8 },{READ_WRITE, REG_PPRE1_6,	REG_BITMASK_8 },
    // PCON1_4/5/6 address location
    {READ_ONLY, 	REG_PCNT1_4,REG_BITMASK_32},	{READ_ONLY,  REG_PCNT1_5,REG_BITMASK_32},{READ_ONLY,  REG_PCNT1_6,	REG_BITMASK_32},
    {READ_WRITE,	REG_PPWM1_4,REG_BITMASK_16},	{READ_WRITE, REG_PPWM1_5,REG_BITMASK_16},{READ_WRITE, REG_PPWM1_6,	REG_BITMASK_16},


    {READ_WRITE,	REG_PDAT1_7,REG_BITMASK_16},	{READ_WRITE, REG_PDAT2_0,REG_BITMASK_16},{READ_WRITE, REG_PDAT2_1,	REG_BITMASK_16},
    {READ_WRITE,	REG_PPRE1_7,REG_BITMASK_8 },	{READ_WRITE, REG_PPRE2_0,REG_BITMASK_8 },{READ_WRITE, REG_PPRE2_1,	REG_BITMASK_8 },
    // PCON1_7/2_0/1 address location
    {READ_ONLY, 	REG_PCNT1_7,REG_BITMASK_32},	{READ_ONLY,  REG_PCNT2_0,REG_BITMASK_32},{READ_ONLY,  REG_PCNT2_1,	REG_BITMASK_32},
    {READ_WRITE,	REG_PPWM1_7,REG_BITMASK_16},	{READ_WRITE, REG_PPWM2_0,REG_BITMASK_16},{READ_WRITE, REG_PPWM2_1,	REG_BITMASK_16},


    {READ_WRITE,	REG_PDAT2_2,REG_BITMASK_16},	{READ_WRITE, REG_PDAT2_3,REG_BITMASK_16},{READ_WRITE, REG_PDAT2_4,	REG_BITMASK_16},
    {READ_WRITE,	REG_PPRE2_2,REG_BITMASK_8 },	{READ_WRITE, REG_PPRE2_3,REG_BITMASK_8 },{READ_WRITE, REG_PPRE2_4,	REG_BITMASK_8 },
    // PCON2_2/3/4 address location
    {READ_ONLY, 	REG_PCNT2_2,REG_BITMASK_32},	{READ_ONLY,  REG_PCNT2_3,REG_BITMASK_32},{READ_ONLY,  REG_PCNT2_4,	REG_BITMASK_32},
    {READ_WRITE,	REG_PPWM2_2,REG_BITMASK_16},	{READ_WRITE, REG_PPWM2_3,REG_BITMASK_16},{READ_WRITE, REG_PPWM2_4,	REG_BITMASK_16},


    {READ_WRITE,	REG_PDAT2_5,REG_BITMASK_16},	{READ_WRITE, REG_PDAT2_6,REG_BITMASK_16},{READ_WRITE, REG_PDAT2_7,	REG_BITMASK_16},
    {READ_WRITE,	REG_PPRE2_5,REG_BITMASK_8 },	{READ_WRITE, REG_PPRE2_6,REG_BITMASK_8 },{READ_WRITE, REG_PPRE2_7,	REG_BITMASK_8 },
    // PCON2_5/6/7 address location
    {READ_ONLY, 	REG_PCNT2_5,REG_BITMASK_32},	{READ_ONLY,  REG_PCNT2_6,REG_BITMASK_32},{READ_ONLY,  REG_PCNT2_7,	REG_BITMASK_32},
    {READ_WRITE,	REG_PPWM2_5,REG_BITMASK_16},	{READ_WRITE, REG_PPWM2_6,REG_BITMASK_16},{READ_WRITE, REG_PPWM2_7,	REG_BITMASK_16},


    {READ_WRITE,	REG_PDAT3_0,REG_BITMASK_16},	{READ_WRITE, REG_PDAT3_1,REG_BITMASK_16},{READ_WRITE, REG_PDAT3_2,	REG_BITMASK_16},
    {READ_WRITE,	REG_PPRE3_0,REG_BITMASK_8 },	{READ_WRITE, REG_PPRE3_1,REG_BITMASK_8 },{READ_WRITE, REG_PPRE3_2,	REG_BITMASK_8 },
    // PCON3_0/1/2 address location
    {READ_ONLY, 	REG_PCNT3_0,REG_BITMASK_32},	{READ_ONLY,  REG_PCNT3_1,REG_BITMASK_32},{READ_ONLY,  REG_PCNT3_2,	REG_BITMASK_32},
    {READ_WRITE,	REG_PPWM3_0,REG_BITMASK_16},	{READ_WRITE, REG_PPWM3_1,REG_BITMASK_16},{READ_WRITE, REG_PPWM3_2,	REG_BITMASK_16},


    {READ_WRITE,	REG_PDAT3_3,REG_BITMASK_16},	{READ_WRITE, REG_PDAT3_4,REG_BITMASK_16},{READ_WRITE, REG_PDAT3_5,	REG_BITMASK_16},
    {READ_WRITE,	REG_PPRE3_3,REG_BITMASK_8 },	{READ_WRITE, REG_PPRE3_4,REG_BITMASK_8 },{READ_WRITE, REG_PPRE3_5,	REG_BITMASK_8 },
    // PCON3_3/4/5 address location
    {READ_ONLY, 	REG_PCNT3_3,REG_BITMASK_32},	{READ_ONLY,  REG_PCNT3_4,REG_BITMASK_32},{READ_ONLY,  REG_PCNT3_5,	REG_BITMASK_32}, 
    {READ_WRITE,	REG_PPWM3_3,REG_BITMASK_16},	{READ_WRITE, REG_PPWM3_4,REG_BITMASK_16},{READ_WRITE, REG_PPWM3_5,	REG_BITMASK_16},


    {READ_WRITE,	REG_PDAT3_6,REG_BITMASK_16},	{READ_WRITE, REG_PDAT3_7,REG_BITMASK_16},
    {READ_WRITE,	REG_PPRE3_6,REG_BITMASK_8 },	{READ_WRITE, REG_PPRE3_7,REG_BITMASK_8 },
    // PCON3_6/7 address location
    {READ_ONLY, 	REG_PCNT3_6,REG_BITMASK_32},	{READ_ONLY,  REG_PCNT3_7,REG_BITMASK_32},
    {READ_WRITE,	REG_PPWM3_6,REG_BITMASK_16},	{READ_WRITE, REG_PPWM3_7,REG_BITMASK_16},

	// PWM control register
    {READ_WRITE,	REG_PCON0_0,REG_TCON_MASK },	{READ_WRITE, REG_PCON0_1,REG_TCON_MASK },{READ_WRITE, REG_PCON0_2,	REG_TCON_MASK },
    {READ_WRITE,	REG_PCON0_3,REG_TCON_MASK },	{READ_WRITE, REG_PCON0_4,REG_TCON_MASK },{READ_WRITE, REG_PCON0_5,	REG_TCON_MASK },
    {READ_WRITE,	REG_PCON0_6,REG_TCON_MASK },	{READ_WRITE, REG_PCON0_7,REG_TCON_MASK },{READ_WRITE, REG_PCON1_0,	REG_TCON_MASK },
    {READ_WRITE,	REG_PCON1_1,REG_TCON_MASK },	{READ_WRITE, REG_PCON1_2,REG_TCON_MASK },{READ_WRITE, REG_PCON1_3,	REG_TCON_MASK },
    {READ_WRITE,	REG_PCON1_4,REG_TCON_MASK },	{READ_WRITE, REG_PCON1_5,REG_TCON_MASK },{READ_WRITE, REG_PCON1_6,	REG_TCON_MASK },
    {READ_WRITE,	REG_PCON1_7,REG_TCON_MASK },	{READ_WRITE, REG_PCON2_0,REG_TCON_MASK },{READ_WRITE, REG_PCON2_1,	REG_TCON_MASK },
    {READ_WRITE,	REG_PCON2_2,REG_TCON_MASK },	{READ_WRITE, REG_PCON2_3,REG_TCON_MASK },{READ_WRITE, REG_PCON2_4,	REG_TCON_MASK },
    {READ_WRITE,	REG_PCON2_5,REG_TCON_MASK },	{READ_WRITE, REG_PCON2_6,REG_TCON_MASK },{READ_WRITE, REG_PCON2_7,	REG_TCON_MASK },
    {READ_WRITE,	REG_PCON3_0,REG_TCON_MASK },	{READ_WRITE, REG_PCON3_1,REG_TCON_MASK },{READ_WRITE, REG_PCON3_2,	REG_TCON_MASK },
    {READ_WRITE,	REG_PCON3_3,REG_TCON_MASK },	{READ_WRITE, REG_PCON3_4,REG_TCON_MASK },{READ_WRITE, REG_PCON3_5,	REG_TCON_MASK },
	{READ_WRITE,	REG_PCON3_6,REG_TCON_MASK },	{READ_WRITE, REG_PCON3_7,REG_TCON_MASK },
    {READ_WRITE,	0,			REG_BITMASK_32}     // End of register list
};

static smtUint32 regListWDT[][3] = {
    /* WDT */
    // WDTCR address location
    {READ_WRITE,	REG_WDTPSR,	REG_BITMASK_16},
    {READ_WRITE,	REG_WDTTLDR,REG_BITMASK_16},
    {READ_ONLY, 	REG_WDTVLR,	REG_BITMASK_32},
    {READ_ONLY, 	REG_WDTISR,	REG_BITMASK_32},

	// WDT control register
    {READ_WRITE,	REG_WDTCR,	REG_WDTCR_MASK},
    {READ_WRITE,	0,			REG_BITMASK_32}     // End of register list
};

static smtUint32 regListGPIO[][3] = {
    /* GPIO */
    {READ_WRITE,	REG_GPIO_DAT0,	REG_BITMASK_8},
    {READ_WRITE,	REG_GPIO_DAT1,	REG_BITMASK_8},
    {READ_WRITE,	REG_GPIO_DAT2,	REG_BITMASK_8},
    {READ_WRITE,	REG_GPIO_DAT3,	REG_BITMASK_8},
    {READ_WRITE,	REG_GPIO_CON0,	REG_BITMASK_16},
    {READ_WRITE,	REG_GPIO_CON1,	REG_BITMASK_16},
    {READ_WRITE,	REG_GPIO_CON2,	REG_BITMASK_16},
    {READ_WRITE,	REG_GPIO_CON3,	REG_BITMASK_16},
    {READ_WRITE,	0,				REG_BITMASK_32}     // End of register list
};

static smtUint32 regListVIC[][3] = {
    /* VIC */
    // INTCON address location
    {READ_ONLY,		REG_INTPND,	REG_BITMASK_32},
    {READ_WRITE,	REG_INTMOD,	REG_BITMASK_32},
    {READ_WRITE,	REG_INTMSK,	REG_BITMASK_32},
    {READ_WRITE,	REG_LEVEL,	REG_BITMASK_32},
    {READ_WRITE,	REG_I_PSLV0,REG_BITMASK_24},
    {READ_WRITE,	REG_I_PSLV1,REG_BITMASK_24},
    {READ_WRITE,	REG_I_PSLV2,REG_BITMASK_24},
    {READ_WRITE,	REG_I_PSLV3,REG_BITMASK_24},
    {READ_WRITE,	REG_I_PMST,	REG_BITMASK_13},
                                
    {READ_ONLY,		REG_ICSLV0,	REG_BITMASK_24},
    {READ_ONLY,		REG_ICSLV1,	REG_BITMASK_24},
    {READ_ONLY,		REG_ICSLV2,	REG_BITMASK_24},
    {READ_ONLY,		REG_ICSLV3,	REG_BITMASK_24},
    {READ_ONLY,		REG_I_CMST,	REG_BITMASK_8},
    {READ_ONLY,		REG_I_ISPR,	REG_BITMASK_32},

    {WRITE_ONLY,	REG_I_ISPC,	REG_BITMASK_32},
                	
    {READ_WRITE,	REG_F_PSLV0,REG_BITMASK_24},
    {READ_WRITE,	REG_F_PSLV1,REG_BITMASK_24},
    {READ_WRITE,	REG_F_PSLV2,REG_BITMASK_24},
    {READ_WRITE,	REG_F_PSLV3,REG_BITMASK_24},
    {READ_WRITE,	REG_F_PMST,	REG_BITMASK_13},
                                
    {READ_ONLY,		REG_F_CSLV0,REG_BITMASK_24},
    {READ_ONLY,		REG_F_CSLV1,REG_BITMASK_24},
    {READ_ONLY,		REG_F_CSLV2,REG_BITMASK_24},
    {READ_ONLY,		REG_F_CSLV3,REG_BITMASK_24},
    {READ_ONLY,		REG_F_CMST,	REG_BITMASK_8},
    {READ_ONLY,		REG_F_ISPR,	REG_BITMASK_32},

    {WRITE_ONLY,	REG_F_ISPC,	REG_BITMASK_32},

    {READ_WRITE,	REG_POLARITY,REG_BITMASK_32},

    {READ_ONLY,		REG_I_VECADDR,REG_BITMASK_32},
    {READ_ONLY,		REG_F_VECADDR,REG_BITMASK_32},

	// VIC control register
    {READ_WRITE,	REG_INTCON,	REG_INTCON_MASK},
    {READ_WRITE,	0,			REG_BITMASK_32}     // End of register list
};

static smtUint32 regListADC[][3] = {
    /* ADC */
    // ADCCON address location
    {READ_ONLY, REG_ADCDAT,	REG_BITMASK_10},

	// ADC control register
    {READ_WRITE, REG_ADCCON,	REG_ADCCON_MASK},
    {READ_WRITE, 0,				REG_BITMASK_32}     // End of register list
};

static smtUint32 regListPower[][3] = {
    /* Power */
	// SYSCON address location
    {READ_WRITE, REG_PWMCON,	REG_BITMASK_1},

	// Power control register
    {READ_WRITE, REG_SYSCON,	REG_SYSCON_MASK},
    {READ_WRITE, 0,				REG_BITMASK_32}     // End of register list
};


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : RegisterTest()
    Prototype           : smtUint32 RegisterTest(void)
    Return              : error code
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtUint32 RegisterTest(void)
{
    smtBoolean errRtn;

#if CHK_FMC
    errRtn = RegisterFMC();
    if(errRtn != SMT_SUCCESS)
        return REGISTER_ERROR;
#endif

#if CHK_ESMC
    errRtn = RegisterESMC();
    if(errRtn != SMT_SUCCESS)
        return REGISTER_ERROR;
#endif

#if CHK_UART
    errRtn = RegisterUART();
    if(errRtn != SMT_SUCCESS)
        return REGISTER_ERROR;
#endif

#if CHK_I2C
    errRtn = RegisterI2C();
    if(errRtn != SMT_SUCCESS)
        return REGISTER_ERROR;
#endif

#if CHK_TIMER
    errRtn = RegisterTimer();
    if(errRtn != SMT_SUCCESS)
        return FMC_ERROR;
#endif

#if CHK_PWM
    errRtn = RegisterPWM();
    if(errRtn != SMT_SUCCESS)
        return REGISTER_ERROR;
#endif

#if CHK_WDT
    errRtn = RegisterWDT();
    if(errRtn != SMT_SUCCESS)
        return REGISTER_ERROR;
#endif

#if CHK_GPIO
    // GPIO register test is enough in the test code of "gpio.c".
    // So, refer to "gpio.c"
    /*
    errRtn = RegisterGPIO();
    if(errRtn != SMT_SUCCESS)
        return REGISTER_ERROR;
    */
#endif

#if CHK_VIC
    errRtn = RegisterVIC();
    if(errRtn != SMT_SUCCESS)
        return REGISTER_ERROR;
#endif

#if CHK_ADC
    errRtn = RegisterADC();
    if(errRtn != SMT_SUCCESS)
        return REGISTER_ERROR;
#endif

#if CHK_POWER
    errRtn = RegisterPower();
    if(errRtn != SMT_SUCCESS)
        return REGISTER_ERROR;
#endif

    return NO_ERROR;
}

/*-----------------------------------------------------------------------
    Function name   : RegisterFMC()
    Prototype           : smtBoolean RegisterFMC(void)
    Return              : error code
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean RegisterFMC(void)
{
    smtBoolean errRtn;

    errRtn = RegisterRangeCheck(regListFMC, TOGGLE_DATA);
    if(errRtn != SMT_SUCCESS)
        return SMT_ERROR;

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : RegisterESMC()
    Prototype           : smtBoolean RegisterESMC(void)
    Return              : error code
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean RegisterESMC(void)
{
    smtBoolean errRtn;

    errRtn = RegisterRangeCheck(regListESMC, TOGGLE_DATA);
    if(errRtn != SMT_SUCCESS)
        return SMT_ERROR;

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : RegisterUART()
    Prototype           : smtBoolean RegisterUART(void)
    Return              : error code
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean RegisterUART(void)
{
    smtBoolean errRtn;

    errRtn = RegisterRangeCheck(regListUART, TOGGLE_DATA);
    if(errRtn != SMT_SUCCESS)
        return SMT_ERROR;

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : RegisterI2C()
    Prototype           : smtBoolean RegisterI2C(void)
    Return              : error code
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean RegisterI2C(void)
{
    smtBoolean errRtn;

    errRtn = RegisterRangeCheck(regListI2C, TOGGLE_DATA);
    if(errRtn != SMT_SUCCESS)
        return SMT_ERROR;

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : RegisterTimer()
    Prototype           : smtBoolean RegisterTimer(void)
    Return              : error code
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean RegisterTimer(void)
{
    smtBoolean errRtn;

    errRtn = RegisterRangeCheck(regListTimer, TOGGLE_DATA);
    if(errRtn != SMT_SUCCESS)
        return SMT_ERROR;

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : RegisterPWM()
    Prototype           : smtBoolean RegisterPWM(void)
    Return              : error code
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean RegisterPWM(void)
{
    smtBoolean errRtn;

    errRtn = RegisterRangeCheck(regListPWM, TOGGLE_DATA);
    if(errRtn != SMT_SUCCESS)
        return SMT_ERROR;

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : RegisterWDT()
    Prototype           : smtBoolean RegisterWDT(void)
    Return              : error code
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean RegisterWDT(void)
{
    smtBoolean errRtn;

    errRtn = RegisterRangeCheck(regListWDT, TOGGLE_DATA);
    if(errRtn != SMT_SUCCESS)
        return SMT_ERROR;

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : RegisterGPIO()
    Prototype           : smtBoolean RegisterGPIO(void)
    Return              : error code
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean RegisterGPIO(void)
{
    smtBoolean errRtn;

    errRtn = RegisterRangeCheck(regListGPIO, TOGGLE_DATA);
    if(errRtn != SMT_SUCCESS)
        return SMT_ERROR;

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : RegisterVIC()
    Prototype           : smtBoolean RegisterVIC(void)
    Return              : error code
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean RegisterVIC(void)
{
    smtBoolean errRtn;

    errRtn = RegisterRangeCheck(regListVIC, TOGGLE_DATA);
    if(errRtn != SMT_SUCCESS)
        return SMT_ERROR;

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : RegisterADC()
    Prototype           : smtBoolean RegisterADC(void)
    Return              : error code
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean RegisterADC(void)
{
    smtBoolean errRtn;

    errRtn = RegisterRangeCheck(regListADC, TOGGLE_DATA);
    if(errRtn != SMT_SUCCESS)
        return SMT_ERROR;

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : RegisterPower()
    Prototype           : smtBoolean RegisterPower(void)
    Return              : error code
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean RegisterPower(void)
{
    smtBoolean errRtn;

    errRtn = RegisterRangeCheck(regListPower, TOGGLE_DATA);
    if(errRtn != SMT_SUCCESS)
        return SMT_ERROR;

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : RegisterRangeCheck()
    Prototype           : smtBoolean RegisterRangeCheck(smtUint32 pRegList[][3], smtUint32 data)
    Return              : error code
    Argument        :
            pRegList    -> register access mode, register addr, register bit-mask
            data            -> data to be wrtten
    Comments        : 
            register check of the range
-----------------------------------------------------------------------*/
smtBoolean RegisterRangeCheck(smtUint32 pRegList[][3], smtUint32 data)
{
    smtBoolean rtnValue;
    smtUint16 idx;
    smtUint32 preStatusVal;

    idx = 0;

    while(pRegList[idx][1] != SMT_FALSE)
    {
        if(pRegList[idx][0] == READ_WRITE)      // Check the register access mode.(R/W register only)
        {
            preStatusVal = SMT_READ((*(volatile smtUint32 *)pRegList[idx][1])); // Store to original register value.
            rtnValue = RegisterCheck(pRegList[idx][1], data, pRegList[idx][2]);
            SMT_WRITE((*(volatile smtUint32 *)pRegList[idx][1]), preStatusVal); // Return to orignal register value.

            if(rtnValue != SMT_SUCCESS)
                return SMT_ERROR;
        }
        idx++;
    }

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : RegisterCheck()
    Prototype           : smtBoolean RegisterCheck(smtUint16 registerNum, smtUint32 data, smtUint32 bitmask)
    Return              : error code
    Argument        :
            registerNum	-> register
            data		-> data to be written
            bitmask		-> register bit-mask
    Comments        : 
            Register check
-----------------------------------------------------------------------*/
smtBoolean RegisterCheck(smtUint32 registerNum, smtUint32 data, smtUint32 bitmask)
{
    smtUint32 readData;

    SMT_WRITE((*(volatile smtUint32 *)registerNum), (data&bitmask));
    readData = SMT_READ((*(volatile smtUint32 *)registerNum));
    readData &= bitmask;

    if((data&bitmask) != readData)
        return SMT_ERROR;

    return SMT_SUCCESS;
}
