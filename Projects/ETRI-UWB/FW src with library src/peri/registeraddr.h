/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: registeraddr.h
	Description	: Register address header file
	Created by	: SHMT SOC Team
----------------------------------------------------------*/
#ifndef __REGISTER_H__
#define __REGISTER_H__

/*
//////////////////////////////////////////////////////////////////////////////
	INCLUDE
//////////////////////////////////////////////////////////////////////////////
*/
#include "syscfg.h"
#include "sysreg.h"

/*
/////////////////////////////////////////////////////////
        REGISTER ADDRESS DEFINITION
///////////////////////////////////////////////////////// 
*/

#define REG_DMA_BASE			DMAC_BASEADDR
#define REG_GPIO_BASE			GPIO_BASEADDR
#define REG_I2C_BASE			I2C_BASEADDR
#define REG_I2S_BASEADDR		I2S_BASEADDR
#define REG_PM_BASE			(0x00000000)
#define REG_SMC_BASE			ESMC_BASEADDR
#define REG_SDR_BASE			DDRCTL_BASEADDR
#define REG_TIMER_BASE			TIMER_BASEADDR
#define REG_UART0_BASE			UART0_BASEADDR
#define REG_UART1_BASE			UART1_BASEADDR
#define REG_VIC_BASE			VIC_BASEADDR
#define REG_WDT_BASE			WDT_BASEADDR


/* E-DMA */
#define REG_DMA_SRC			(REG_DMA_BASE + 0x00)
#define REG_DMA_DST			(REG_DMA_BASE + 0x04)
#define REG_DMA_CTRL			(REG_DMA_BASE + 0x08)
#define REG_DMA_DESC			(REG_DMA_BASE + 0x0C)
#define REG_DMA_STATUS			(REG_DMA_BASE + 0x10)

/* GPIO */
#define REG_GPIO0_OE			(REG_GPIO_BASE + 0x00)
#define REG_GPIO0_IN			(REG_GPIO_BASE + 0x04)
#define REG_GPIO0_OUT			(REG_GPIO_BASE + 0x08)
#define REG_GPIO0_INTSTAT		(REG_GPIO_BASE + 0x0C)
#define REG_GPIO0_INTEN		(REG_GPIO_BASE + 0x10)
#define REG_GPIO0_INTLEVEL		(REG_GPIO_BASE + 0x14)
#define REG_GPIO0_INTPOL		(REG_GPIO_BASE + 0x18)
#define REG_GPIO0_INTBEDGE		(REG_GPIO_BASE + 0x1C)

#define REG_GPIO1_OE			(REG_GPIO_BASE + 0x20)
#define REG_GPIO1_IN			(REG_GPIO_BASE + 0x24)
#define REG_GPIO1_OUT			(REG_GPIO_BASE + 0x28)
#define REG_GPIO1_INTSTAT		(REG_GPIO_BASE + 0x2C)
#define REG_GPIO1_INTEN		(REG_GPIO_BASE + 0x30)
#define REG_GPIO1_INTLEVEL		(REG_GPIO_BASE + 0x34)
#define REG_GPIO1_INTPOL		(REG_GPIO_BASE + 0x38)
#define REG_GPIO1_INTBEDGE		(REG_GPIO_BASE + 0x3C)

/* I2C */
#define REG_I2C_I2CCON			(REG_I2C_BASE + 0x00)
#define REG_I2C_I2CSTA  			(REG_I2C_BASE + 0x04)
#define REG_I2C_I2CDATA		(REG_I2C_BASE + 0x08)

/* I2S */                  			
#define REG_I2S_CLKCTRL			(REG_I2S_BASEADDR+0x00)
#define REG_I2S_CTRL			(REG_I2S_BASEADDR+0x04)
#define REG_I2S_STATUS			(REG_I2S_BASEADDR+0x08)
#define REG_I2S_DATA			(REG_I2S_BASEADDR+0x0C)

/* Power Management */
#define REG_PM_CLKCON			(REG_PM_BASE + 0x00)
#define REG_PM_CLKDIV			(REG_PM_BASE + 0x04)
#define REG_PM_SYSPLL			(REG_PM_BASE + 0x08)
#define REG_PM_USBPLL			(REG_PM_BASE + 0x0C)
#define REG_PM_RSTCON			(REG_PM_BASE + 0x10)

/* SMC */
#define REG_SMC_B0_CON			(REG_SMC_BASE+0x00)
#define REG_SMC_B1_CON			(REG_SMC_BASE+0x04)
#define REG_SMC_B2_CON			(REG_SMC_BASE+0x08)
#define REG_SMC_B3_CON			(REG_SMC_BASE+0x0C)

/* DMC */
#define REG_SDR_TCON			(REG_SDR_BASE+0x00)
#define REG_SDR_CON			(REG_SDR_BASE+0x04)
#define REG_SDR_PCON			(REG_SDR_BASE+0x08)
#define REG_SDR_REF				(REG_SDR_BASE+0x0C)

/* Timer & PWM */
#define REG_TIMER_TDAT0 		(REG_TIMER_BASE + 0x00)
#define REG_TIMER_TPRE0 		(REG_TIMER_BASE + 0x04)
#define REG_TIMER_TCON0 		(REG_TIMER_BASE + 0x08)
#define REG_TIMER_TCNT0 		(REG_TIMER_BASE + 0x0C)
#define REG_TIMER_TPWM0 		(REG_TIMER_BASE + 0x10)
                  			
#define REG_TIMER_TDAT1 		(REG_TIMER_BASE + 0x20)
#define REG_TIMER_TPRE1 		(REG_TIMER_BASE + 0x24)
#define REG_TIMER_TCON1 		(REG_TIMER_BASE + 0x28)
#define REG_TIMER_TCNT1 		(REG_TIMER_BASE + 0x2C)
#define REG_TIMER_TPWM1 		(REG_TIMER_BASE + 0x30) 
                  			
#define REG_TIMER_TDAT2		(REG_TIMER_BASE + 0x40)																											
#define REG_TIMER_TPRE2		(REG_TIMER_BASE + 0x44)																											
#define REG_TIMER_TCON2		(REG_TIMER_BASE + 0x48)																											
#define REG_TIMER_TCNT2		(REG_TIMER_BASE + 0x4C)																											
#define REG_TIMER_TPWM2		(REG_TIMER_BASE + 0x50)																											 
                  			
#define REG_TIMER_TDAT3 		(REG_TIMER_BASE + 0x60)
#define REG_TIMER_TPRE3 		(REG_TIMER_BASE + 0x64)
#define REG_TIMER_TCON3 		(REG_TIMER_BASE + 0x68)
#define REG_TIMER_TCNT3 		(REG_TIMER_BASE + 0x6C) 
#define REG_TIMER_TPWM3 		(REG_TIMER_BASE + 0x70) 

/* UART */
//UART ch0
#define REG_UART0MASTER		(REG_UART0_BASE+0x00)
#define REG_UART0STATUS		(REG_UART0_BASE+0x04)
#define REG_UART0BRD			(REG_UART0_BASE+0x08)
#define REG_UART0TXFIFO		(REG_UART0_BASE+0x0C)
#define REG_UART0RXFIFO		(REG_UART0_BASE+0x10)
#define REG_UART0RXTIMEOUT	(REG_UART0_BASE+0x14)

//UART ch1
#define REG_UART1MASTER		(REG_UART1_BASE+0x00)
#define REG_UART1STATUS		(REG_UART1_BASE+0x04)
#define REG_UART1BRD			(REG_UART1_BASE+0x08)
#define REG_UART1TXFIFO		(REG_UART1_BASE+0x0C)
#define REG_UART1RXFIFO		(REG_UART1_BASE+0x10)
#define REG_UART1RXTIMEOUT	(REG_UART1_BASE+0x14)

/* VIC */
#define REG_VIC_INTCON   		(REG_VIC_BASE + 0x00)
#define REG_VIC_INTPND   		(REG_VIC_BASE + 0x04)
#define REG_VIC_INTMOD   		(REG_VIC_BASE + 0x08)
#define REG_VIC_INTMSK   		(REG_VIC_BASE + 0x0C)
#define REG_VIC_LEVEL			(REG_VIC_BASE + 0x10) 
#define REG_VIC_I_PSLV0  		(REG_VIC_BASE + 0x14)
#define REG_VIC_I_PSLV1  		(REG_VIC_BASE + 0x18)
#define REG_VIC_I_PSLV2  		(REG_VIC_BASE + 0x1C)
#define REG_VIC_I_PSLV3  		(REG_VIC_BASE + 0x20)
#define REG_VIC_I_PMST   		(REG_VIC_BASE + 0x24)
#define REG_VIC_ICSLV0			(REG_VIC_BASE + 0x28)
#define REG_VIC_ICSLV1			(REG_VIC_BASE + 0x2C)
#define REG_VIC_ICSLV2			(REG_VIC_BASE + 0x30)
#define REG_VIC_ICSLV3			(REG_VIC_BASE + 0x34)
#define REG_VIC_I_CMST			(REG_VIC_BASE + 0x38)
#define REG_VIC_I_ISPR			(REG_VIC_BASE + 0x3C)
#define REG_VIC_I_ISPC			(REG_VIC_BASE + 0x40)
#define REG_VIC_F_PSLV0  		(REG_VIC_BASE + 0x44)
#define REG_VIC_F_PSLV1  		(REG_VIC_BASE + 0x48)
#define REG_VIC_F_PSLV2  		(REG_VIC_BASE + 0x4C)
#define REG_VIC_F_PSLV3  		(REG_VIC_BASE + 0x50)
#define REG_VIC_F_PMST   		(REG_VIC_BASE + 0x54)
#define REG_VIC_F_CSLV0  		(REG_VIC_BASE + 0x58)
#define REG_VIC_F_CSLV1  		(REG_VIC_BASE + 0x5C)
#define REG_VIC_F_CSLV2  		(REG_VIC_BASE + 0x60)
#define REG_VIC_F_CSLV3  		(REG_VIC_BASE + 0x64)
#define REG_VIC_F_CMST   		(REG_VIC_BASE + 0x68)
#define REG_VIC_F_ISPR			(REG_VIC_BASE + 0x6C)
#define REG_VIC_F_ISPC			(REG_VIC_BASE + 0x70)
#define REG_VIC_POLARITY 		(REG_VIC_BASE + 0x74)  
#define REG_VIC_I_VECADDR		(REG_VIC_BASE + 0x78) 
#define REG_VIC_F_VECADDR		(REG_VIC_BASE + 0x7C) 

/* WDT */          			
#define REG_WDT_WDTCON  		(REG_WDT_BASE + 0x00)
#define REG_WDT_WDTPSR 		(REG_WDT_BASE + 0x04)
#define REG_WDT_WDTLDR		(REG_WDT_BASE + 0x08)
#define REG_WDT_WDTCNT 		(REG_WDT_BASE + 0x0C)
#define REG_WDT_WDTISR 		(REG_WDT_BASE + 0x10)

/*
/////////////////////////////////////////////////////////
        STRUCTURE DEFINITION
///////////////////////////////////////////////////////// 
*/

typedef enum {
    READ_ONLY,
    WRITE_ONLY,
    READ_WRITE
} ACCESS_TYPE;


/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

smtBoolean RegisterDMA(void);
smtBoolean Register2DDMA(void);
smtBoolean RegisterDMC(void);
smtBoolean RegisterGPIO(void);
smtBoolean RegisterI2C(void);
smtBoolean RegisterI2S(void);
smtBoolean RegisterPower(void);
smtBoolean RegisterPWM(void);
smtBoolean RegisterSMC(void);
smtBoolean RegisterTimer(void);
smtBoolean RegisterUART(void);
smtBoolean RegisterVIC(void);
smtBoolean RegisterWDT(void);

smtBoolean RegisterRangeCheck(smtUint32 pRegList[][3], smtUint32 data);
smtBoolean RegisterCheck(smtUint32 registerNum, smtUint32 data, smtUint32 bitmask);

#endif /* __REGISTER_H__ */
