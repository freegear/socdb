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

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"

#include "lib.h"
//#include "irq.h"
#include "registeraddr.h"

#include <stdlib.h>
#include <time.h>

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define TOGGLE_DATA			0x55555555


#define CHK_UART				1
#define CHK_I2C					1
#define CHK_TIMER				1
#define CHK_PWM					1
#define CHK_WDT					1
#define CHK_GPIO				1
#define CHK_VIC					1
#define CHK_ADC					1
#define CHK_POWER				1
#define CHK_DM					1
#define	CHK_I2S					1
#define	CHK_NAND				1
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

/* ADC */
#define REG_ADC_ADCCON_MASK	0x3F

/* E-DMA */
#define REG_DMA_MASK_CTRL		0xE777FFFF
#define REG_DMA_MASK_DESC		0xFFFFFFFD
#define REG_DMA_MASK_STA		0x00000010	// 0x8000001F : [31] enable bit

/* G-DMA */
#define REG_DMAG_MASK_STA		0x00000010	//0x80000013 : [31] enable bit


/* I2C */

/* Power management */
#define REG_PM_CLKCON_MASK	0x0000	//0x0007 : [2:0] power manage enable bits
#define REG_PM_CLKDIV_MASK	0xF73F
#define REG_PM_SYSPLL_MASK	0x3FF1	//0x13FF1 : [16] SYS pll enable
#define REG_PM_USBPLL_MASK	0x3FFB	//0x13FFB : [16] USB pll enable
#define REG_PM_RSTCON_MASK	0xFFFF	//0x1FFFF : [16] pll locked status

/* Timer */
#define REG_TIMER_TCON_MASK	0x3F

/* UART */

#define REG_UARTMASTER_MASK		0x6FC01F1F //[31] EnUART [28] S/W Reset [21:13][7:5] reserved

/* VIC */
#define REG_VIC_INTCON_MASK	0xF

/* VIF */
#define REG_VIF_VIFCON_MASK	0x36	//0xB7 : [7] swreset [0] DMA en/disable

/* WDT */
#define REG_WDT_WDTCR_MASK	0x3E

/* Display Module */
//DM master ctrl
#define REG_DMCON_MASK		0x0000000E	//[0] S/W Reset
//DM Cursor Plane
#define REG_CCON_MASK		0x181FFBFF	//[31] CPlaneEn [29][26:21] reserved
#define REG_CBMOD_MAKE		0x583FFFFF	//[31][29][26:22] reserved

//DM Graphic Plane
#define REG_GCON_MASK		0x3C3FFFFF	//[31] GPlaneEn [30][25:22] reserved
#define REG_GBMOD_MASK		0x583FFFFF	//[31][29][26:22] reserved
#define REG_GAMMA_MASK 		REG_BITMASK_24	
//DM Video Plane
#define REG_VCON_MASK		0x7C3FFFFF	//[31] VPlaneEn [25:22] reserved
#define REG_VBMOD_MASK		0x583FFFFF	//[31][29][26:22] reserved
//DM LCD IF ctrl
#define REG_LCDCON_MASK		0x400003FF	//[31] LCDEn [29:10] reserved

/* I2S */
#define	REG_I2S_CLKCTRL_MASK	0xC0003FFF
#define	REG_I2S_CTRL_MASK		0x073F073F
#define	REG_I2S_STATUS_MASK		REG_BITMASK_0
#define	REG_I2S_DATA_MASK		REG_BITMASK_32

/* NAND */
#define	REG_NAND_DATA_MASK		REG_BITMASK_32
#define	REG_NAND_CONF_MASK		REG_BITMASK_14
#define	REG_NAND_CTRL_MASK		0x00001C80
#define	REG_NAND_STAT_MASK		REG_BITMASK_0

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


/*/////////////////////////////////////////////////////////
        VARIABLE DEFINITION
///////////////////////////////////////////////////////// */
static smtUint32 regListADC[][3] = {
	/* ADC */
	// ADCCON address location
	{READ_ONLY,		REG_ADC_ADCDAT,	REG_BITMASK_10},
	
	// ADC control register
	{READ_WRITE,	REG_ADC_ADCCON,	REG_ADC_ADCCON_MASK},

	{READ_WRITE,	0,					REG_BITMASK_32}
	// End of register list
};

static smtUint32 regListDM[][3]=
{
	/* Display Module */
	//DM master
	{READ_WRITE,	REG_DMCON		,REG_DMCON_MASK},			
	{READ_ONLY,		REG_DMSTS		,REG_BITMASK_0	},			
 	//DM cursor plane
	{READ_WRITE,	REG_CCON		,REG_CCON_MASK	},			
	{READ_WRITE,	REG_CBLND		,REG_BITMASK_32	},			
	{READ_WRITE,	REG_CBMOD		,REG_BITMASK_0	},			
	{READ_WRITE,	REG_CBASE		,REG_BITMASK_11	},			
	{READ_WRITE,	REG_CADDR		,REG_BITMASK_32	},			
	{READ_WRITE,	REG_CPALM		,REG_BITMASK_32	},			
	//DM back ground plane
	{READ_WRITE,	REG_BGCOL		,REG_BITMASK_24 },			
	//DM Graphic Plane
	{READ_WRITE,	REG_GCON		,REG_GCON_MASK	},			
	{READ_WRITE,	REG_GBLND		,REG_BITMASK_32	},			
	{READ_WRITE,	REG_GBMOD		,REG_GBMOD_MASK},			
	{READ_WRITE,	REG_GBASE		,REG_BITMASK_12	},			
	{READ_WRITE,	REG_GADDR		,REG_BITMASK_32	},			
	{READ_WRITE,	REG_GPALM		,REG_BITMASK_32	},			
	//DM Video Plane 
	{READ_WRITE,	REG_VCON		,REG_VCON_MASK	},			
	{READ_WRITE,	REG_VBLND		,REG_BITMASK_32	},			
	{READ_WRITE,	REG_VBMOD		,REG_VBMOD_MASK},			
	{READ_WRITE,	REG_VBASE		,REG_BITMASK_12	},			
	{READ_WRITE,	REG_VADDR		,REG_BITMASK_32	},			
	{READ_WRITE,	REG_VADDR2		,REG_BITMASK_32	},
	//DM LCD IF control 
	{READ_WRITE,	REG_LCDCON		,REG_LCDCON_MASK},			
	//{READ_WRITE,	REG_VIDCON		,REG_BITMASK_0	},//shkim-20070122 : need to check
	{READ_WRITE,	REG_HSYNC0		,REG_BITMASK_16},			
	{READ_WRITE,	REG_HSYNC1		,REG_BITMASK_20	},			
	{READ_WRITE,	REG_VSYNC0		,REG_BITMASK_16	},			
	{READ_WRITE,	REG_VSYNC1		,REG_BITMASK_17	},			
	//DM Graphic Plane Gamma
	{READ_WRITE,	REG_GGAMMA00	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA01	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA02	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA03	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA04	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA05	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA06	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA07	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA08	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA09	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA0A	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA0B	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA0C	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA0D	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA0E	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA0F	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_GGAMMA10	,REG_GAMMA_MASK},			
	//DM Video Plane Gamma
	{READ_WRITE,	REG_VGAMMA00	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA01	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA02	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA03	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA04	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA05	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA06	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA07	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA08	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA09	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA0A	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA0B	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA0C	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA0D	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA0E	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA0F	,REG_GAMMA_MASK},			
	{READ_WRITE,	REG_VGAMMA10	,REG_GAMMA_MASK},

	{READ_WRITE,	0,					REG_BITMASK_32}
	// End of register list
};

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

static smtUint32 regList2DDMA[][3] = {
	/* source / destination / size / count / address update / status */
	{READ_WRITE,	REG_DMAG_SRC,		REG_BITMASK_32},
	{READ_WRITE,	REG_DMAG_DST,		REG_BITMASK_32},
	{READ_WRITE,	REG_DMAG_SIZE,		REG_BITMASK_16},
	{READ_WRITE,	REG_DMAG_CNT,		REG_BITMASK_32},	            	          			
	{READ_WRITE,	REG_DMAG_ADDRUP,	REG_BITMASK_32},
	{READ_WRITE,	REG_DMAG_STATUS,	REG_DMAG_MASK_STA},

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

/* NAND */
static smtUint32 regListNAND[][3] = {
	{WRITE_ONLY,	REG_NAND_NFOPER,		REG_BITMASK_0},
	{READ_WRITE,	REG_NAND_DATA,			REG_NAND_DATA_MASK},
	{READ_WRITE,	REG_NAND_CONF,			REG_NAND_CONF_MASK},
	{READ_WRITE,	REG_NAND_CTRL,			REG_NAND_CTRL_MASK},
	{READ_WRITE,	REG_NAND_STAT,			REG_NAND_STAT_MASK},
	{READ_ONLY,		REG_NAND_ECCSECTOR0,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCSECTOR1,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCSECTOR2,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCSECTOR3,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCSECTOR4,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCSECTOR5,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCSECTOR6,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCSECTOR7,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCSECTOR8,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCSECTOR9,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCSECTOR10,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCSECTOR11,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCSECTOR12,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCSECTOR13,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCSECTOR14,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCSECTOR15,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR0,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR1,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR2,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR3,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR4,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR5,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR6,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR7,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR8,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR9,	REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR10,REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR11,REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR12,REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR13,REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR14,REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_SECCSECTOR15,REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCERR0,		REG_BITMASK_0},
	{READ_ONLY,		REG_NAND_ECCERR1,		REG_BITMASK_0},	    

	{READ_WRITE,	0,						REG_BITMASK_32}
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
	{READ_WRITE,	REG_TIMER_TDAT0,	REG_BITMASK_16},
	{READ_WRITE,	REG_TIMER_TDAT1,	REG_BITMASK_16},
	{READ_WRITE,	REG_TIMER_TDAT2,	REG_BITMASK_16},
	{READ_WRITE,	REG_TIMER_TPRE0,	REG_BITMASK_8 },
	{READ_WRITE,	REG_TIMER_TPRE1,	REG_BITMASK_8 },
	{READ_WRITE,	REG_TIMER_TPRE2,	REG_BITMASK_8 },
	// TCON0/1/2 address location
	{READ_ONLY,		REG_TIMER_TCNT0,	REG_BITMASK_32},
	{READ_ONLY,		REG_TIMER_TCNT1,	REG_BITMASK_32},
	{READ_ONLY,		REG_TIMER_TCNT2,	REG_BITMASK_32},

	{READ_WRITE,	REG_TIMER_TPWM0,	REG_BITMASK_16},
	{READ_WRITE,	REG_TIMER_TPWM1,	REG_BITMASK_16},
	{READ_WRITE,	REG_TIMER_TPWM2,	REG_BITMASK_16},
	        	         	  	                     	
	        	         	  	                     	
	{READ_WRITE,	REG_TIMER_TDAT3,	REG_BITMASK_16},
	{READ_WRITE,	REG_TIMER_TDAT4,	REG_BITMASK_16},
	{READ_WRITE,	REG_TIMER_TDAT5,	REG_BITMASK_16},
	{READ_WRITE,	REG_TIMER_TPRE3,	REG_BITMASK_8 },
	{READ_WRITE,	REG_TIMER_TPRE4,	REG_BITMASK_8 },
	{READ_WRITE,	REG_TIMER_TPRE5,	REG_BITMASK_8 },
	// TCON3/4/5 address location
	{READ_ONLY,		REG_TIMER_TCNT3,	REG_BITMASK_32},
	{READ_ONLY,		REG_TIMER_TCNT4,	REG_BITMASK_32},
	{READ_ONLY,		REG_TIMER_TCNT5,	REG_BITMASK_32},

	{READ_WRITE,	REG_TIMER_TPWM3,	REG_BITMASK_16},
	{READ_WRITE,	REG_TIMER_TPWM4,	REG_BITMASK_16},
	{READ_WRITE,	REG_TIMER_TPWM5,	REG_BITMASK_16},
	        	         	  		               
	        	         	  		               
	{READ_WRITE,	REG_TIMER_TDAT6,	REG_BITMASK_16},
	{READ_WRITE,	REG_TIMER_TDAT7,	REG_BITMASK_16},
	{READ_WRITE,	REG_TIMER_TPRE6,	REG_BITMASK_8 },
	{READ_WRITE,	REG_TIMER_TPRE7,	REG_BITMASK_8 },
	// TCON6/7 address location
	{READ_ONLY,		REG_TIMER_TCNT6,	REG_BITMASK_32},
	{READ_ONLY,		REG_TIMER_TCNT7,	REG_BITMASK_32},

	{READ_WRITE,	REG_TIMER_TPWM6,	REG_BITMASK_16},
	{READ_WRITE,	REG_TIMER_TPWM7,	REG_BITMASK_16},
	                                         
	// Timer control register                    
	{READ_WRITE,	REG_TIMER_TCON0,	REG_TIMER_TCON_MASK },
	{READ_WRITE,	REG_TIMER_TCON1,	REG_TIMER_TCON_MASK },
	{READ_WRITE,	REG_TIMER_TCON2,	REG_TIMER_TCON_MASK },
	{READ_WRITE,	REG_TIMER_TCON3,	REG_TIMER_TCON_MASK },
	{READ_WRITE,	REG_TIMER_TCON4,	REG_TIMER_TCON_MASK },
	{READ_WRITE,	REG_TIMER_TCON5,	REG_TIMER_TCON_MASK },
	{READ_WRITE,	REG_TIMER_TCON6,	REG_TIMER_TCON_MASK },
	{READ_WRITE,	REG_TIMER_TCON7,	REG_TIMER_TCON_MASK },

	{READ_WRITE,	0,					REG_BITMASK_32}
	// End of register list
};

static smtUint32 regListUART[][3] = {
	/* UART */
	//UART CH0
	{READ_WRITE,	REG_UART0MASTER	,REG_UARTMASTER_MASK},
	{READ_ONLY,		REG_UART0STATUS	,REG_BITMASK_0		},
	{READ_WRITE,	REG_UART0BRD		,REG_BITMASK_16		},
	{WRITE_ONLY,	REG_UART0TXFIFO		,REG_BITMASK_0		},
	{READ_ONLY,		REG_UART0RXFIFO		,REG_BITMASK_0		},
	{READ_WRITE,	REG_UART0RXTIMEOUT ,REG_BITMASK_20		},
	//UART CH1
	{READ_WRITE,	REG_UART1MASTER	,REG_UARTMASTER_MASK},
	{READ_ONLY,		REG_UART1STATUS	,REG_BITMASK_0		},
	{READ_WRITE,	REG_UART1BRD		,REG_BITMASK_16		},
	{WRITE_ONLY,	REG_UART1TXFIFO		,REG_BITMASK_0		},
	{READ_ONLY,		REG_UART1RXFIFO		,REG_BITMASK_0		},
	{READ_WRITE,	REG_UART1RXTIMEOUT ,REG_BITMASK_20		},

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

static smtUint32 regListVIF[][3] = {
	/* VIF */
	// INTCON address location
	{READ_WRITE,	REG_VIF_VIFCON,		REG_VIF_VIFCON_MASK},
	{READ_ONLY,		REG_VIF_VIFSTS,		REG_BITMASK_2},
	{READ_WRITE,	REG_VIF_VIFPOS,		REG_BITMASK_22},
	{READ_WRITE,	REG_VIF_VIFSIZ,		REG_BITMASK_22},
	{READ_WRITE,	REG_VIF_VIFADDR,	REG_BITMASK_32},

	{READ_WRITE,	0,					REG_BITMASK_32}
	// End of register list
};

static smtUint32 regListWDT[][3] = {
	/* WDT */
	// WDTCR address location
	{READ_WRITE,	REG_WDT_WDTPSR,	REG_BITMASK_16},
	{READ_WRITE,	REG_WDT_WDTTLDR,	REG_BITMASK_16},
	{READ_ONLY, 	REG_WDT_WDTVLR,	REG_BITMASK_32},
	{READ_ONLY, 	REG_WDT_WDTISR,	REG_BITMASK_32},
	
	// WDT control register
	{READ_WRITE,	REG_WDT_WDTCR,	REG_WDT_WDTCR_MASK},

	{READ_WRITE,	0,					REG_BITMASK_32}
	// End of register list
};


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
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

#if CHK_ADC
	errRtn = RegisterADC();
	if(errRtn != SMT_SUCCESS)
		return REGISTER_ERROR;
#endif

#if CHK_DM
	errRtn = RegisterDM();
	if(errRtn != SMT_SUCCESS)
		return REGISTER_ERROR;
#endif

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

#if CHK_NAND
	errRtn = RegisterNAND();
	if(errRtn != SMT_SUCCESS)
		return REGISTER_ERROR;
#endif

#if CHK_POWER
	errRtn = RegisterPower();
	if(errRtn != SMT_SUCCESS)
		return REGISTER_ERROR;
#endif

#if CHK_PWM
	errRtn = RegisterPWM();
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
	Function name	: RegisterADC()
	Prototype		: smtBoolean RegisterADC(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterADC(void)
{
	smtBoolean errRtn;
	smtUint32 data;

#if 0
	errRtn = RegisterRangeCheck(regListADC, TOGGLE_DATA);
#endif

	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListADC, data);

	if(errRtn != SMT_SUCCESS)
		return SMT_ERROR;
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: RegisterDM()
	Prototype		: smtBoolean RegisterDM(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterDM(void)
{
	smtBoolean errRtn;
	smtUint32 data;
	
	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListDM, data);

	if(errRtn != SMT_SUCCESS)
		return SMT_ERROR;
	
	return SMT_SUCCESS;
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
	Function name	: Register2DDMA()
	Prototype		: smtBoolean Register2DDMA(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean Register2DDMA(void)
{
	smtBoolean errRtn;
	smtUint32 data;

#if 0
	errRtn = RegisterRangeCheck(regList2DDMA, TOGGLE_DATA);
#endif

	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regList2DDMA, data);

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
	Function name	: RegisterNAND()
	Prototype		: smtBoolean RegisterNAND(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterNAND(void)
{
	smtBoolean errRtn;
	smtUint32 data;


	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListNAND, data);

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
	Function name	: RegisterPWM()
	Prototype		: smtBoolean RegisterPWM(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterPWM(void)
{
	smtBoolean errRtn;
	smtUint32 data;

#if 0
	errRtn = RegisterRangeCheck(regListPWM, TOGGLE_DATA);
#endif

	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListPWM, data);

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
	Function name	: RegisterVIF()
	Prototype		: smtBoolean RegisterVIF(void)
	Return		: error code
	Argument	:
	Comments	: 
----------------------------------------------------------*/
smtBoolean RegisterVIF(void)
{
	smtBoolean errRtn;
	smtUint32 data;

#if 0
	errRtn = RegisterRangeCheck(regListVIF, TOGGLE_DATA);
#endif

	srand(time(NULL));
	data = rand();
	errRtn = RegisterRangeCheck(regListVIF, data);

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

