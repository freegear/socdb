/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: registercheck.c
	Description	: Register check routine file
	Created by	: SHMT SOC Team
----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "sysinc.h"
#include "commonmacro.h"

#include "lib.h"
//#include "irq.h"
#include "registeraddr.h"

#include <stdlib.h>
#include <time.h>

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

#define TOGGLE_DATA			0x55555555


#define CHK_UART				1
#define CHK_I2C					1
#define CHK_TIMER				1
#define CHK_WDT					1
#define CHK_GPIO				1
#define CHK_VIC					1
#define CHK_POWER				1
#define	CHK_I2S					1
#define	CHK_SMC				1
#define	CHK_DMC				1


#define REG_BITMASK_32			0xFFFFFFFF
#define REG_BITMASK_24			0x00FFFFFF
#define REG_BITMASK_23			0x007FFFFF
#define REG_BITMASK_22			0x003FFFFF
#define REG_BITMASK_20			0x000FFFFF
#define REG_BITMASK_17			0x0001FFFF
#define REG_BITMASK_16			0x0000FFFF
#define REG_BITMASK_14			0x00003FFF
#define REG_BITMASK_13			0x00001FFF
#define REG_BITMASK_12			0x00000FFF
#define REG_BITMASK_11			0x000007FF
#define REG_BITMASK_10			0x000003FF
#define REG_BITMASK_9			0x000001FF
#define REG_BITMASK_8			0x000000FF
#define REG_BITMASK_7			0x0000007F
#define REG_BITMASK_6			0x0000003F
#define REG_BITMASK_4			0x0000000F
#define REG_BITMASK_3			0x00000007
#define REG_BITMASK_2			0x00000003
#define REG_BITMASK_1			0x00000001
#define REG_BITMASK_0			0x00000000

/* E-DMA */
#define REG_DMA_MASK_CTRL		0xE777FFFF
#define REG_DMA_MASK_DESC		0xFFFFFFFD
#define REG_DMA_MASK_STA		0x00000010	// 0x8000001F : [31] enable bit

/* I2C */

/* Power management */
#define REG_PM_CLKCON_MASK	0x0000	//0x0007 : [2:0] power manage enable bits
#define REG_PM_CLKDIV_MASK	0xF73F
#define REG_PM_SYSPLL_MASK	0x3FF1	//0x13FF1 : [16] SYS pll enable
#define REG_PM_USBPLL_MASK	0x3FFB	//0x13FFB : [16] USB pll enable
#define REG_PM_RSTCON_MASK	0xFFFF	//0x1FFFF : [16] pll locked status

/* Timer */
#define REG_TIMER_TCON_MASK	0x4

/* UART */

#define REG_UARTMASTER_MASK		0x6FC01F1F //[31] EnUART [28] S/W Reset [21:13][7:5] reserved

/* VIC */
#define REG_VIC_INTCON_MASK	0xF

/* WDT */
#define REG_WDT_WDTCON_MASK	0x38

/* I2S */
#define	REG_I2S_CLKCTRL_MASK	0xC0003FFF
#define	REG_I2S_CTRL_MASK		0x073F073F
#define	REG_I2S_STATUS_MASK		REG_BITMASK_0
#define	REG_I2S_DATA_MASK		REG_BITMASK_32

/* SMC */
#define	REG_SMC_B0_CON_MASK		REG_BITMASK_20
#define	REG_SMC_B1_CON_MASK		REG_BITMASK_20
#define	REG_SMC_B2_CON_MASK		REG_BITMASK_20
#define	REG_SMC_B3_CON_MASK		REG_BITMASK_20

/* DMC */
#define	REG_DMC_TCON_MASK		REG_BITMASK_16
#define	REG_SDR_CON_MASK		REG_BITMASK_16
#define	REG_SDR_PCON_MASK		REG_BITMASK_16
#define	REG_SDR_REF_MASK		REG_BITMASK_16


/*
/////////////////////////////////////////////////////////
        VARIABLE DEFINITION
///////////////////////////////////////////////////////// 
*/

static smtUint32 regListDMA[][3] = {
	/* Source / Destination / Control / Descriptor / Status */
	{READ_WRITE,	REG_DMA_SRC,		REG_BITMASK_32},
	{READ_WRITE,	REG_DMA_DST,		REG_BITMASK_32},
	{READ_WRITE,	REG_DMA_CTRL,		REG_DMA_MASK_CTRL},
	{READ_WRITE,	REG_DMA_DESC,		REG_DMA_MASK_DESC},	            	          			
	{READ_WRITE,	REG_DMA_STATUS,	REG_DMA_MASK_STA},

	{READ_WRITE,	0,					REG_BITMASK_32}
	// End of register list
};

/* DMC */
static smtUint32 regListDMC[][3] = {
	/*
	{READ_WRITE,	REG_SDR_TCON,		REG_DMC_TCON_MASK	},
	{READ_WRITE,	REG_SDR_CON,		REG_SDR_CON_MASK	},
	{READ_WRITE,	REG_SDR_PCON,		REG_SDR_PCON_MASK	},
	{READ_WRITE,	REG_SDR_REF,		REG_SDR_REF_MASK	},
	*/

	{READ_WRITE,	0,					REG_BITMASK_32		}
};

static smtUint32 regListGPIO[][3] = {
	/* GPIO */
	{READ_WRITE,	REG_GPIO0_OE,		REG_BITMASK_32},
	{READ_ONLY,		REG_GPIO0_IN,		REG_BITMASK_32},
	{READ_WRITE,	REG_GPIO0_OUT,		REG_BITMASK_32},
	{READ_WRITE,	REG_GPIO0_INTSTAT,	REG_BITMASK_0},
	{READ_WRITE,	REG_GPIO0_INTEN,	REG_BITMASK_32},
	{READ_WRITE,	REG_GPIO0_INTLEVEL,	REG_BITMASK_32},
	{READ_WRITE,	REG_GPIO0_INTPOL,	REG_BITMASK_32},
	{READ_WRITE,	REG_GPIO0_INTBEDGE,	REG_BITMASK_32},

	{READ_WRITE,	REG_GPIO1_OE,		REG_BITMASK_32},
	{READ_ONLY,		REG_GPIO1_IN,		REG_BITMASK_32},
	{READ_WRITE,	REG_GPIO1_OUT,		REG_BITMASK_32},
	{READ_WRITE,	REG_GPIO1_INTSTAT,	REG_BITMASK_0},
	{READ_WRITE,	REG_GPIO1_INTEN,	REG_BITMASK_32},
	{READ_WRITE,	REG_GPIO1_INTLEVEL,	REG_BITMASK_32},
	{READ_WRITE,	REG_GPIO1_INTPOL,	REG_BITMASK_32},
	{READ_WRITE,	REG_GPIO1_INTBEDGE,	REG_BITMASK_32},

	{READ_WRITE,	0,					REG_BITMASK_32}
	// End of register list
};

static smtUint32 regListI2C[][3] = {
	/* I2C */
	{READ_WRITE,	REG_I2C_I2CCON,		REG_BITMASK_3},
	{READ_ONLY,		REG_I2C_I2CSTA,		REG_BITMASK_0},
	{READ_WRITE,	REG_I2C_I2CDATA,	REG_BITMASK_8},

	{READ_WRITE,	0,					REG_BITMASK_32}
	// End of register list
};

/* I2S */
static smtUint32 regListI2S[][3] = {
	{READ_WRITE,	REG_I2S_CLKCTRL,	REG_I2S_CLKCTRL_MASK},
	{READ_WRITE,	REG_I2S_CTRL,		REG_I2S_CTRL_MASK},
	{READ_WRITE,	REG_I2S_STATUS,		REG_I2S_STATUS_MASK},
	{READ_WRITE,	REG_I2S_DATA,		REG_I2S_DATA_MASK},

	{READ_WRITE,	0,					REG_BITMASK_32}
};

static smtUint32 regListPower[][3] = {
	/* clkcon / clkdiv / syspll / usbpll / rstcon */
	//{READ_WRITE,	REG_PM_CLKCON,		REG_PM_CLKCON_MASK},
	{READ_WRITE,	REG_PM_CLKDIV,		REG_PM_CLKDIV_MASK},
	{READ_WRITE,	REG_PM_SYSPLL,		REG_PM_SYSPLL_MASK},
	{READ_WRITE,	REG_PM_USBPLL,		REG_PM_USBPLL_MASK},
	//{READ_WRITE,	REG_PM_RSTCON,		REG_PM_RSTCON_MASK},
	
	{READ_WRITE, 0,						REG_BITMASK_32}
	// End of register list
};

static smtUint32 regListPWM[][3] = {
	{READ_WRITE,	0,					REG_BITMASK_32}     // End of register list
};

/* SMC if don't use SRAM case */
static smtUint32 regListSMC[][3] = {
	{READ_WRITE,	REG_SMC_B0_CON,		REG_SMC_B0_CON_MASK},
	{READ_WRITE,	REG_SMC_B1_CON,		REG_SMC_B1_CON_MASK},
	{READ_WRITE,	REG_SMC_B2_CON,		REG_SMC_B2_CON_MASK},
	{READ_WRITE,	REG_SMC_B3_CON,		REG_SMC_B3_CON_MASK},
	{READ_WRITE,	0,						REG_BITMASK_32}
};

static smtUint32 regListTimer[][3] = {
	/* Timer */
	{READ_WRITE,	REG_TIMER_TDAT0,	REG_BITMASK_32},
	{READ_WRITE,	REG_TIMER_TDAT1,	REG_BITMASK_32},
	{READ_WRITE,	REG_TIMER_TDAT2,	REG_BITMASK_32},
	{READ_WRITE,	REG_TIMER_TDAT3,	REG_BITMASK_32},

	{READ_WRITE,	REG_TIMER_TPRE0,	REG_BITMASK_10},
	{READ_WRITE,	REG_TIMER_TPRE1,	REG_BITMASK_10},
	{READ_WRITE,	REG_TIMER_TPRE2,	REG_BITMASK_10},
	{READ_WRITE,	REG_TIMER_TPRE3,	REG_BITMASK_10},

	// Timer control register                    
	{READ_WRITE,	REG_TIMER_TCON0,	REG_TIMER_TCON_MASK },
	{READ_WRITE,	REG_TIMER_TCON1,	REG_TIMER_TCON_MASK },
	{READ_WRITE,	REG_TIMER_TCON2,	REG_TIMER_TCON_MASK },
	{READ_WRITE,	REG_TIMER_TCON3,	REG_TIMER_TCON_MASK },

	{READ_WRITE,	0,					REG_BITMASK_32}
	// End of register list
};

static smtUint32 regListUART[][3] = {
	/* UART */
	//UART CH0
	{READ_WRITE,	REG_UART0MASTER		,REG_UARTMASTER_MASK},
	{READ_ONLY,		REG_UART0STATUS		,REG_BITMASK_0		},
	{READ_WRITE,	REG_UART0BRD		,REG_BITMASK_16		},
	{WRITE_ONLY,	REG_UART0TXFIFO		,REG_BITMASK_0		},
	{READ_ONLY,		REG_UART0RXFIFO		,REG_BITMASK_0		},
	{READ_WRITE,	REG_UART0RXTIMEOUT 	,REG_BITMASK_20		},
	//UART CH1
	{READ_WRITE,	REG_UART1MASTER		,REG_UARTMASTER_MASK},
	{READ_ONLY,		REG_UART1STATUS		,REG_BITMASK_0		},
	{READ_WRITE,	REG_UART1BRD		,REG_BITMASK_16		},
	{WRITE_ONLY,	REG_UART1TXFIFO		,REG_BITMASK_0		},
	{READ_ONLY,		REG_UART1RXFIFO		,REG_BITMASK_0		},
	{READ_WRITE,	REG_UART1RXTIMEOUT 	,REG_BITMASK_20		},

	{READ_WRITE,	0,					REG_BITMASK_32}
	// End of register list
};

static smtUint32 regListVIC[][3] = {
	/* VIC */
	// INTCON address location
	{READ_ONLY,		REG_VIC_INTPND,		REG_BITMASK_32},
	{READ_WRITE,	REG_VIC_INTMOD,		REG_BITMASK_32},
	{READ_WRITE,	REG_VIC_INTMSK,		REG_BITMASK_32},
	{READ_WRITE,	REG_VIC_LEVEL,		REG_BITMASK_32},
	{READ_WRITE,	REG_VIC_I_PSLV0,	REG_BITMASK_24},
	{READ_WRITE,	REG_VIC_I_PSLV1,	REG_BITMASK_24},
	{READ_WRITE,	REG_VIC_I_PSLV2,	REG_BITMASK_24},
	{READ_WRITE,	REG_VIC_I_PSLV3,	REG_BITMASK_24},
	{READ_WRITE,	REG_VIC_I_PMST,		REG_BITMASK_13},
	                            
	{READ_ONLY,		REG_VIC_ICSLV0,		REG_BITMASK_24},
	{READ_ONLY,		REG_VIC_ICSLV1,		REG_BITMASK_24},
	{READ_ONLY,		REG_VIC_ICSLV2,		REG_BITMASK_24},
	{READ_ONLY,		REG_VIC_ICSLV3,		REG_BITMASK_24},
	{READ_ONLY,		REG_VIC_I_CMST,		REG_BITMASK_8},
	{READ_ONLY,		REG_VIC_I_ISPR,		REG_BITMASK_32},
	
	{WRITE_ONLY,	REG_VIC_I_ISPC,		REG_BITMASK_32},
	            	
	{READ_WRITE,	REG_VIC_F_PSLV0,	REG_BITMASK_24},
	{READ_WRITE,	REG_VIC_F_PSLV1,	REG_BITMASK_24},
	{READ_WRITE,	REG_VIC_F_PSLV2,	REG_BITMASK_24},
	{READ_WRITE,	REG_VIC_F_PSLV3,	REG_BITMASK_24},
	{READ_WRITE,	REG_VIC_F_PMST,		REG_BITMASK_13},
	                            
	{READ_ONLY,		REG_VIC_F_CSLV0,	REG_BITMASK_24},
	{READ_ONLY,		REG_VIC_F_CSLV1,	REG_BITMASK_24},
	{READ_ONLY,		REG_VIC_F_CSLV2,	REG_BITMASK_24},
	{READ_ONLY,		REG_VIC_F_CSLV3,	REG_BITMASK_24},
	{READ_ONLY,		REG_VIC_F_CMST,		REG_BITMASK_8},
	{READ_ONLY,		REG_VIC_F_ISPR,		REG_BITMASK_32},
	
	{WRITE_ONLY,	REG_VIC_F_ISPC,		REG_BITMASK_32},
	
	{READ_WRITE,	REG_VIC_POLARITY,	REG_BITMASK_32},
	
	{READ_ONLY,		REG_VIC_I_VECADDR,	REG_BITMASK_32},
	{READ_ONLY,		REG_VIC_F_VECADDR,	REG_BITMASK_32},
	
	// VIC control register
	{READ_WRITE,	REG_VIC_INTCON,		REG_VIC_INTCON_MASK},

	{READ_WRITE,	0,					REG_BITMASK_32}
	// End of register list
};

static smtUint32 regListWDT[][3] = {
	/* WDT */
	// WDTCR address location
	{READ_WRITE,	REG_WDT_WDTPSR,	REG_BITMASK_16},
	{READ_WRITE,	REG_WDT_WDTLDR,	REG_BITMASK_16},
	{READ_ONLY, 	REG_WDT_WDTCNT,	REG_BITMASK_16},
	{READ_ONLY, 	REG_WDT_WDTISR,	REG_BITMASK_2},
	
	// WDT control register
	{READ_WRITE,	REG_WDT_WDTCON,	REG_WDT_WDTCON_MASK},

	{READ_WRITE,	0,					REG_BITMASK_32}
	// End of register list
};


/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: RegisterTest()
	Prototype		: smtUint32 RegisterTest(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtUint32 RegisterTest(void)
{
	smtBoolean errRtn;

#if CHK_DMC
	errRtn = RegisterDMC();
	if(errRtn != SMT_SUCCESS)
		return REGISTER_ERROR;
#endif

#if CHK_GPIO
	// GPIO register test is enough in the test code of "gpio.c".
	// So, refer to "gpio.c"
	errRtn = RegisterGPIO();
	if(errRtn != SMT_SUCCESS)
		return REGISTER_ERROR;
#endif

#if CHK_I2C
	errRtn = RegisterI2C();
	if(errRtn != SMT_SUCCESS)
		return REGISTER_ERROR;
#endif

#if CHK_POWER
	errRtn = RegisterPower();
	if(errRtn != SMT_SUCCESS)
		return REGISTER_ERROR;
#endif

#if CHK_SMC
	errRtn = RegisterSMC();
	if(errRtn != SMT_SUCCESS)
		return REGISTER_ERROR;
#endif

#if CHK_TIMER
	errRtn = RegisterTimer();
	if(errRtn != SMT_SUCCESS)
		return REGISTER_ERROR;
#endif

#if CHK_UART
	errRtn = RegisterUART();
	if(errRtn != SMT_SUCCESS)
		return REGISTER_ERROR;
#endif

#if CHK_VIC
	errRtn = RegisterVIC();
	if(errRtn != SMT_SUCCESS)
		return REGISTER_ERROR;
#endif

#if CHK_WDT
	errRtn = RegisterWDT();
	if(errRtn != SMT_SUCCESS)
		return REGISTER_ERROR;
#endif

	return NO_ERROR;
}

/*----------------------------------------------------------
	Function name	: RegisterDMA()
	Prototype		: smtBoolean RegisterDMA(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterDMA(void)
{
	smtBoolean errRtn;
	smtUint32 data;

#if 0
	errRtn = RegisterRangeCheck(regListDMA, TOGGLE_DATA);
#endif

	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListDMA, data);

	if(errRtn != SMT_SUCCESS)
		return SMT_ERROR;
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: RegisterDMC()
	Prototype		: smtBoolean RegisterDMC(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterDMC(void)
{
	smtBoolean errRtn;
	smtUint32 data;


	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListDMC, data);

	if(errRtn != SMT_SUCCESS)
		return SMT_ERROR;
	
	return SMT_SUCCESS;
}


/*----------------------------------------------------------
	Function name	: RegisterGPIO()
	Prototype		: smtBoolean RegisterGPIO(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterGPIO(void)
{
	smtBoolean errRtn;
	smtUint32 data;

#if 0
	errRtn = RegisterRangeCheck(regListGPIO, TOGGLE_DATA);
#endif

	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListGPIO, data);

	if(errRtn != SMT_SUCCESS)
		return SMT_ERROR;
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: RegisterI2C()
	Prototype		: smtBoolean RegisterI2C(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterI2C(void)
{
	smtBoolean errRtn;
	smtUint32 data;

#if 0
	errRtn = RegisterRangeCheck(regListI2C, TOGGLE_DATA);
#endif

	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListI2C, data);

	if(errRtn != SMT_SUCCESS)
		return SMT_ERROR;
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: RegisterI2S()
	Prototype		: smtBoolean RegisterI2S(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterI2S(void)
{
	smtBoolean errRtn;
	smtUint32 data;


	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListI2S, data);

	if(errRtn != SMT_SUCCESS)
		return SMT_ERROR;
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: RegisterPower()
	Prototype		: smtBoolean RegisterPower(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterPower(void)
{
	smtBoolean errRtn;
	smtUint32 data;

#if 0
	errRtn = RegisterRangeCheck(regListPower, TOGGLE_DATA);
#endif

	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListPower, data);

	if(errRtn != SMT_SUCCESS)
		return SMT_ERROR;
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: RegisterSMC()
	Prototype		: smtBoolean RegisterSMC(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterSMC(void)
{
	smtBoolean errRtn;
	smtUint32 data;


	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListSMC, data);

	if(errRtn != SMT_SUCCESS)
		return SMT_ERROR;
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: RegisterTimer()
	Prototype		: smtBoolean RegisterTimer(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterTimer(void)
{
	smtBoolean errRtn;
	smtUint32 data;

#if 0
	errRtn = RegisterRangeCheck(regListTimer, TOGGLE_DATA);
#endif

	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListTimer, data);

	if(errRtn != SMT_SUCCESS)
		return SMT_ERROR;
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: RegisterUART()
	Prototype		: smtBoolean RegisterUART(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterUART(void)
{
	smtBoolean errRtn;
	smtUint32 data;

#if 0
	errRtn = RegisterRangeCheck(regListUART, TOGGLE_DATA);
#endif

	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListUART, data);

	if(errRtn != SMT_SUCCESS)
		return SMT_ERROR;
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: RegisterVIC()
	Prototype		: smtBoolean RegisterVIC(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterVIC(void)
{
	smtBoolean errRtn;
	smtUint32 data;

#if 0
	errRtn = RegisterRangeCheck(regListVIC, TOGGLE_DATA);
#endif

	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListVIC, data);

	if(errRtn != SMT_SUCCESS)
		return SMT_ERROR;
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: RegisterWDT()
	Prototype		: smtBoolean RegisterWDT(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterWDT(void)
{
	smtBoolean errRtn;
	smtUint32 data;

#if 0
	errRtn = RegisterRangeCheck(regListWDT, TOGGLE_DATA);
#endif

	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListWDT, data);

	if(errRtn != SMT_SUCCESS)
		return SMT_ERROR;
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: RegisterRangeCheck()
	Prototype		: smtBoolean RegisterRangeCheck(smtUint32 pRegList[][3], smtUint32 data)
	Return		: error code
	Argument	:
		pRegList	-> register access mode, register addr, register bit-mask
		data		-> data to be wrtten
	Comments	: 
		register check of the range
----------------------------------------------------------*/
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

/*----------------------------------------------------------
	Function name	: RegisterCheck()
	Prototype		: smtBoolean RegisterCheck(smtUint16 registerNum, smtUint32 data, smtUint32 bitmask)
	Return		: error code
	Argument	:
		registerNum	-> register
		data		-> data to be written
		bitmask		-> register bit-mask
	Comments	 : 
		Register check
----------------------------------------------------------*/
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

