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

/*/////////////////////////////////////////////////////////
        REGISTER ADDRESS DEFINITION
///////////////////////////////////////////////////////// */
/* ADC */
#define REG_ADC_BASE		(0x00000000)
#define REG_ADC_ADCCON		(REG_ADC_BASE + 0x00)
#define REG_ADC_ADCDAT		(REG_ADC_BASE + 0x04)

/* Display Module */
#define REG_DM_BASEADDR			(0x00000000)
#define REG_DMCON				(REG_DM_BASEADDR+0x000)
#define REG_DMSTS				(REG_DM_BASEADDR+0x004)
//Cursor Plane               
#define REG_CCON				(REG_DM_BASEADDR+0x010)
#define REG_CBLND				(REG_DM_BASEADDR+0x014)
#define REG_CBMOD				(REG_DM_BASEADDR+0x018)
#define REG_CBASE				(REG_DM_BASEADDR+0x01c)
#define REG_CADDR				(REG_DM_BASEADDR+0x020)
#define REG_CPALM				(REG_DM_BASEADDR+0x024)
//Background Plane           
#define REG_BGCOL				(REG_DM_BASEADDR+0x030)
//Graphic Plane              
#define REG_GCON				(REG_DM_BASEADDR+0x040)
#define REG_GBLND				(REG_DM_BASEADDR+0x044)
#define REG_GBMOD				(REG_DM_BASEADDR+0x048)
#define REG_GBASE				(REG_DM_BASEADDR+0x04c)
#define REG_GADDR				(REG_DM_BASEADDR+0x050)
#define REG_GPALM				(REG_DM_BASEADDR+0x054)
//Video Plane                
#define REG_VCON				(REG_DM_BASEADDR+0x060)
#define REG_VBLND				(REG_DM_BASEADDR+0x064)
#define REG_VBMOD				(REG_DM_BASEADDR+0x068)
#define REG_VBASE				(REG_DM_BASEADDR+0x06c)
#define REG_VADDR				(REG_DM_BASEADDR+0x070)
#define REG_VADDR2				(REG_DM_BASEADDR+0x078)//shkim-20070117:check the offset
//LCD control                
#define REG_LCDCON				(REG_DM_BASEADDR+0x0E0)
#define REG_VIDCON				(REG_DM_BASEADDR+0x0E4)
#define REG_HSYNC0				(REG_DM_BASEADDR+0x0F0)
#define REG_HSYNC1				(REG_DM_BASEADDR+0x0F4)
#define REG_VSYNC0				(REG_DM_BASEADDR+0x0F8)
#define REG_VSYNC1				(REG_DM_BASEADDR+0x0FC)
//Graphic Gamma              
#define REG_GGAMMA00			(REG_DM_BASEADDR+0x100)
#define REG_GGAMMA01			(REG_DM_BASEADDR+0x104)
#define REG_GGAMMA02			(REG_DM_BASEADDR+0x108)
#define REG_GGAMMA03			(REG_DM_BASEADDR+0x10C)
#define REG_GGAMMA04			(REG_DM_BASEADDR+0x110)
#define REG_GGAMMA05			(REG_DM_BASEADDR+0x114)
#define REG_GGAMMA06			(REG_DM_BASEADDR+0x118)
#define REG_GGAMMA07			(REG_DM_BASEADDR+0x11C)
#define REG_GGAMMA08			(REG_DM_BASEADDR+0x120)
#define REG_GGAMMA09			(REG_DM_BASEADDR+0x124)
#define REG_GGAMMA0A			(REG_DM_BASEADDR+0x128)
#define REG_GGAMMA0B			(REG_DM_BASEADDR+0x12C)
#define REG_GGAMMA0C			(REG_DM_BASEADDR+0x130)
#define REG_GGAMMA0D			(REG_DM_BASEADDR+0x134)
#define REG_GGAMMA0E			(REG_DM_BASEADDR+0x138)
#define REG_GGAMMA0F			(REG_DM_BASEADDR+0x13C)
#define REG_GGAMMA10			(REG_DM_BASEADDR+0x140)
//Video Gamma                
#define REG_VGAMMA00			(REG_DM_BASEADDR+0x200)
#define REG_VGAMMA01			(REG_DM_BASEADDR+0x204)
#define REG_VGAMMA02			(REG_DM_BASEADDR+0x208)
#define REG_VGAMMA03			(REG_DM_BASEADDR+0x20C)
#define REG_VGAMMA04			(REG_DM_BASEADDR+0x210)
#define REG_VGAMMA05			(REG_DM_BASEADDR+0x214)
#define REG_VGAMMA06			(REG_DM_BASEADDR+0x218)
#define REG_VGAMMA07			(REG_DM_BASEADDR+0x21C)
#define REG_VGAMMA08			(REG_DM_BASEADDR+0x220)
#define REG_VGAMMA09			(REG_DM_BASEADDR+0x224)
#define REG_VGAMMA0A			(REG_DM_BASEADDR+0x228)
#define REG_VGAMMA0B			(REG_DM_BASEADDR+0x22C)
#define REG_VGAMMA0C			(REG_DM_BASEADDR+0x230)
#define REG_VGAMMA0D			(REG_DM_BASEADDR+0x234)
#define REG_VGAMMA0E			(REG_DM_BASEADDR+0x238)
#define REG_VGAMMA0F			(REG_DM_BASEADDR+0x23C)
#define REG_VGAMMA10			(REG_DM_BASEADDR+0x240)

/* E-DMA */
#define REG_DMA_BASE		(0x00000000)
#define REG_DMA_SRC			(REG_DMA_BASE + 0x00)
#define REG_DMA_DST			(REG_DMA_BASE + 0x04)
#define REG_DMA_CTRL		(REG_DMA_BASE + 0x08)
#define REG_DMA_DESC		(REG_DMA_BASE + 0x0C)
#define REG_DMA_STATUS		(REG_DMA_BASE + 0x10)

/* G-DMA */
#define REG_DMAG_BASE		(0x00000000)
#define REG_DMAG_SRC		(REG_DMAG_BASE + 0x00)
#define REG_DMAG_DST		(REG_DMAG_BASE + 0x04)
#define REG_DMAG_SIZE		(REG_DMAG_BASE + 0x08)
#define REG_DMAG_CNT		(REG_DMAG_BASE + 0x0C)
#define REG_DMAG_ADDRUP		(REG_DMAG_BASE + 0x10)
#define REG_DMAG_STATUS		(REG_DMAG_BASE + 0x14)

/* GPIO */
#define REG_GPIO_BASE		(0x00000000)
#define REG_GPIO0_OE		(REG_GPIO_BASE + 0x00)
#define REG_GPIO0_IN		(REG_GPIO_BASE + 0x04)
#define REG_GPIO0_OUT		(REG_GPIO_BASE + 0x08)
#define REG_GPIO0_INTSTAT	(REG_GPIO_BASE + 0x0C)
#define REG_GPIO0_INTEN	(REG_GPIO_BASE + 0x10)
#define REG_GPIO0_INTLEVEL	(REG_GPIO_BASE + 0x14)
#define REG_GPIO0_INTPOL	(REG_GPIO_BASE + 0x18)
#define REG_GPIO0_INTBEDGE	(REG_GPIO_BASE + 0x1C)

#define REG_GPIO1_OE		(REG_GPIO_BASE + 0x20)
#define REG_GPIO1_IN		(REG_GPIO_BASE + 0x24)
#define REG_GPIO1_OUT		(REG_GPIO_BASE + 0x28)
#define REG_GPIO1_INTSTAT	(REG_GPIO_BASE + 0x2C)
#define REG_GPIO1_INTEN	(REG_GPIO_BASE + 0x30)
#define REG_GPIO1_INTLEVEL	(REG_GPIO_BASE + 0x34)
#define REG_GPIO1_INTPOL	(REG_GPIO_BASE + 0x38)
#define REG_GPIO1_INTBEDGE	(REG_GPIO_BASE + 0x3C)

/* I2C */
#define REG_I2C_BASE		(0x00000000)
#define REG_I2C_I2CCON		(REG_I2C_BASE + 0x00)
#define REG_I2C_I2CSTA  		(REG_I2C_BASE + 0x04)
#define REG_I2C_I2CDATA	(REG_I2C_BASE + 0x08)

/* I2S */                  			
#define REG_I2S_BASEADDR	(0x00000000)
#define REG_I2S_CLKCTRL		(REG_I2S_BASEADDR+0x00)
#define REG_I2S_CTRL		(REG_I2S_BASEADDR+0x04)
#define REG_I2S_STATUS		(REG_I2S_BASEADDR+0x08)
#define REG_I2S_DATA		(REG_I2S_BASEADDR+0x0C)

/* Power Management */
#define REG_PM_BASE		(0x00000000)
#define REG_PM_CLKCON		(REG_PM_BASE + 0x00)
#define REG_PM_CLKDIV		(REG_PM_BASE + 0x04)
#define REG_PM_SYSPLL		(REG_PM_BASE + 0x08)
#define REG_PM_USBPLL		(REG_PM_BASE + 0x0C)
#define REG_PM_RSTCON		(REG_PM_BASE + 0x10)

/* SMC */
#define REG_SMC_BASE		(0x00000000)
#define REG_SMC_B0_CON		(REG_SMC_BASE+0x00)
#define REG_SMC_B1_CON		(REG_SMC_BASE+0x04)
#define REG_SMC_B2_CON		(REG_SMC_BASE+0x08)
#define REG_SMC_B3_CON		(REG_SMC_BASE+0x0C)

/* DMC */
#define REG_SDR_BASE		(0x00000000)
#define REG_SDR_TCON		(REG_SDR_BASE+0x00)
#define REG_SDR_CON		(REG_SDR_BASE+0x04)
#define REG_SDR_PCON		(REG_SDR_BASE+0x08)
#define REG_SDR_REF			(REG_SDR_BASE+0x0C)

/* SD/MMC Controller */
#define REG_MMC_BASE			(0x00000000)
#define REG_MMC_CON			(REG_MMC_BASE+0x00)
#define REG_MMC_PRE			(REG_MMC_BASE+0x04)
#define REG_MMC_CmdArg		(REG_MMC_BASE+0x08)
#define REG_MMC_CmdCon		(REG_MMC_BASE+0x0C)
#define REG_MMC_CmdSta			(REG_MMC_BASE+0x10)
#define REG_MMC_RSP0			(REG_MMC_BASE+0x14)
#define REG_MMC_RSP1			(REG_MMC_BASE+0x18)
#define REG_MMC_RSP2			(REG_MMC_BASE+0x1C)
#define REG_MMC_RSP3			(REG_MMC_BASE+0x20)
#define REG_MMC_DTimer			(REG_MMC_BASE+0x24)
#define REG_MMC_BSize			(REG_MMC_BASE+0x28)
#define REG_MMC_DatCon			(REG_MMC_BASE+0x2C)
#define REG_MMC_DatCnt			(REG_MMC_BASE+0x30)
#define REG_MMC_DatSta			(REG_MMC_BASE+0x34)
#define REG_MMC_FSTA			(REG_MMC_BASE+0x38)
#define REG_MMC_IntMsk			(REG_MMC_BASE+0x3C)
#define REG_MMC_IntSta			(REG_MMC_BASE+0x40)
#define REG_MMC_DAT			(REG_MMC_BASE+0x44)
#define REG_MMC_AutoReadCon	(REG_MMC_BASE+0x48)
#define REG_MMC_AutoReadSta	(REG_MMC_BASE+0x4C)

/* NAND */
#define REG_NAND_BASE				(0x00000000)
#define REG_NAND_NFOPER			(REG_NAND_BASE+0x00)
#define REG_NAND_DATA				(REG_NAND_BASE+0x04)
#define REG_NAND_CONF				(REG_NAND_BASE+0x08)
#define REG_NAND_CTRL				(REG_NAND_BASE+0x0c)
#define REG_NAND_STAT				(REG_NAND_BASE+0x10)
#define REG_NAND_ECCSECTOR0		(REG_NAND_BASE+0x14)
#define REG_NAND_ECCSECTOR1		(REG_NAND_BASE+0x18)
#define REG_NAND_ECCSECTOR2		(REG_NAND_BASE+0x1c)
#define REG_NAND_ECCSECTOR3		(REG_NAND_BASE+0x20)
#define REG_NAND_ECCSECTOR4		(REG_NAND_BASE+0x24)
#define REG_NAND_ECCSECTOR5		(REG_NAND_BASE+0x28)
#define REG_NAND_ECCSECTOR6		(REG_NAND_BASE+0x2c)
#define REG_NAND_ECCSECTOR7		(REG_NAND_BASE+0x30)
#define REG_NAND_ECCSECTOR8		(REG_NAND_BASE+0x34)
#define REG_NAND_ECCSECTOR9		(REG_NAND_BASE+0x38)
#define REG_NAND_ECCSECTOR10		(REG_NAND_BASE+0x3c)
#define REG_NAND_ECCSECTOR11		(REG_NAND_BASE+0x40)
#define REG_NAND_ECCSECTOR12		(REG_NAND_BASE+0x44)
#define REG_NAND_ECCSECTOR13		(REG_NAND_BASE+0x48)
#define REG_NAND_ECCSECTOR14		(REG_NAND_BASE+0x4c)
#define REG_NAND_ECCSECTOR15		(REG_NAND_BASE+0x50)
#define REG_NAND_SECCSECTOR0		(REG_NAND_BASE+0x54)
#define REG_NAND_SECCSECTOR1		(REG_NAND_BASE+0x58)
#define REG_NAND_SECCSECTOR2		(REG_NAND_BASE+0x5c)
#define REG_NAND_SECCSECTOR3		(REG_NAND_BASE+0x60)
#define REG_NAND_SECCSECTOR4		(REG_NAND_BASE+0x64)
#define REG_NAND_SECCSECTOR5		(REG_NAND_BASE+0x68)
#define REG_NAND_SECCSECTOR6		(REG_NAND_BASE+0x6c)
#define REG_NAND_SECCSECTOR7		(REG_NAND_BASE+0x70)
#define REG_NAND_SECCSECTOR8		(REG_NAND_BASE+0x74)
#define REG_NAND_SECCSECTOR9		(REG_NAND_BASE+0x78)
#define REG_NAND_SECCSECTOR10		(REG_NAND_BASE+0x7c)
#define REG_NAND_SECCSECTOR11		(REG_NAND_BASE+0x80)
#define REG_NAND_SECCSECTOR12		(REG_NAND_BASE+0x84)
#define REG_NAND_SECCSECTOR13		(REG_NAND_BASE+0x88)
#define REG_NAND_SECCSECTOR14		(REG_NAND_BASE+0x8c)
#define REG_NAND_SECCSECTOR15		(REG_NAND_BASE+0x90)
#define REG_NAND_ECCERR0			(REG_NAND_BASE+0x94)
#define REG_NAND_ECCERR1			(REG_NAND_BASE+0x98)

/* Timer & PWM */
#define REG_TIMER_BASE		(0x00000000)
#define REG_TIMER_TDAT0 	(REG_TIMER_BASE + 0x00)
#define REG_TIMER_TPRE0 	(REG_TIMER_BASE + 0x04)
#define REG_TIMER_TCON0 	(REG_TIMER_BASE + 0x08)
#define REG_TIMER_TCNT0 	(REG_TIMER_BASE + 0x0C)
#define REG_TIMER_TPWM0 	(REG_TIMER_BASE + 0x10)
                  			
#define REG_TIMER_TDAT1 	(REG_TIMER_BASE + 0x20)
#define REG_TIMER_TPRE1 	(REG_TIMER_BASE + 0x24)
#define REG_TIMER_TCON1 	(REG_TIMER_BASE + 0x28)
#define REG_TIMER_TCNT1 	(REG_TIMER_BASE + 0x2C)
#define REG_TIMER_TPWM1 	(REG_TIMER_BASE + 0x30) 
                  			
#define REG_TIMER_TDAT2	(REG_TIMER_BASE + 0x40)																											
#define REG_TIMER_TPRE2	(REG_TIMER_BASE + 0x44)																											
#define REG_TIMER_TCON2	(REG_TIMER_BASE + 0x48)																											
#define REG_TIMER_TCNT2	(REG_TIMER_BASE + 0x4C)																											
#define REG_TIMER_TPWM2	(REG_TIMER_BASE + 0x50)																											 
                  			
#define REG_TIMER_TDAT3 	(REG_TIMER_BASE + 0x60)
#define REG_TIMER_TPRE3 	(REG_TIMER_BASE + 0x64)
#define REG_TIMER_TCON3 	(REG_TIMER_BASE + 0x68)
#define REG_TIMER_TCNT3 	(REG_TIMER_BASE + 0x6C) 
#define REG_TIMER_TPWM3 	(REG_TIMER_BASE + 0x70) 

#define REG_TIMER_TDAT4	(REG_TIMER_BASE + 0x80)
#define REG_TIMER_TPRE4	(REG_TIMER_BASE + 0x84)
#define REG_TIMER_TCON4	(REG_TIMER_BASE + 0x88)
#define REG_TIMER_TCNT4	(REG_TIMER_BASE + 0x8C)
#define REG_TIMER_TPWM4	(REG_TIMER_BASE + 0x90)
                 			
#define REG_TIMER_TDAT5	(REG_TIMER_BASE + 0xA0)
#define REG_TIMER_TPRE5	(REG_TIMER_BASE + 0xA4)
#define REG_TIMER_TCON5	(REG_TIMER_BASE + 0xA8)
#define REG_TIMER_TCNT5	(REG_TIMER_BASE + 0xAC)
#define REG_TIMER_TPWM5	(REG_TIMER_BASE + 0xB0)
                 			
#define REG_TIMER_TDAT6	(REG_TIMER_BASE + 0xC0)
#define REG_TIMER_TPRE6	(REG_TIMER_BASE + 0xC4)
#define REG_TIMER_TCON6	(REG_TIMER_BASE + 0xC8)
#define REG_TIMER_TCNT6	(REG_TIMER_BASE + 0xCC) 
#define REG_TIMER_TPWM6	(REG_TIMER_BASE + 0xD0) 
                 			
#define REG_TIMER_TDAT7	(REG_TIMER_BASE + 0xE0)
#define REG_TIMER_TPRE7	(REG_TIMER_BASE + 0xE4)
#define REG_TIMER_TCON7	(REG_TIMER_BASE + 0xE8)
#define REG_TIMER_TCNT7	(REG_TIMER_BASE + 0xEC)
#define REG_TIMER_TPWM7	(REG_TIMER_BASE + 0xF0)

/* UART */
#define REG_UART0_BASE		(0x00000000)
#define REG_UART1_BASE		(0x00000000)
//UART ch0
#define REG_UART0MASTER		(REG_UART0_BASE+0x00)
#define REG_UART0STATUS		(REG_UART0_BASE+0x04)
#define REG_UART0BRD		(REG_UART0_BASE+0x08)
#define REG_UART0TXFIFO		(REG_UART0_BASE+0x0C)
#define REG_UART0RXFIFO		(REG_UART0_BASE+0x10)
#define REG_UART0RXTIMEOUT	(REG_UART0_BASE+0x14)

//UART ch1
#define REG_UART1MASTER		(REG_UART1_BASE+0x00)
#define REG_UART1STATUS		(REG_UART1_BASE+0x04)
#define REG_UART1BRD		(REG_UART1_BASE+0x08)
#define REG_UART1TXFIFO		(REG_UART1_BASE+0x0C)
#define REG_UART1RXFIFO		(REG_UART1_BASE+0x10)
#define REG_UART1RXTIMEOUT	(REG_UART1_BASE+0x14)

/* VIC */
#define REG_VIC_BASE		(0x00000000)
#define REG_VIC_INTCON   	(REG_VIC_BASE + 0x00)
#define REG_VIC_INTPND   	(REG_VIC_BASE + 0x04)
#define REG_VIC_INTMOD   	(REG_VIC_BASE + 0x08)
#define REG_VIC_INTMSK   	(REG_VIC_BASE + 0x0C)
#define REG_VIC_LEVEL		(REG_VIC_BASE + 0x10) 
#define REG_VIC_I_PSLV0  	(REG_VIC_BASE + 0x14)
#define REG_VIC_I_PSLV1  	(REG_VIC_BASE + 0x18)
#define REG_VIC_I_PSLV2  	(REG_VIC_BASE + 0x1C)
#define REG_VIC_I_PSLV3  	(REG_VIC_BASE + 0x20)
#define REG_VIC_I_PMST   	(REG_VIC_BASE + 0x24)
#define REG_VIC_ICSLV0		(REG_VIC_BASE + 0x28)
#define REG_VIC_ICSLV1		(REG_VIC_BASE + 0x2C)
#define REG_VIC_ICSLV2		(REG_VIC_BASE + 0x30)
#define REG_VIC_ICSLV3		(REG_VIC_BASE + 0x34)
#define REG_VIC_I_CMST		(REG_VIC_BASE + 0x38)
#define REG_VIC_I_ISPR		(REG_VIC_BASE + 0x3C)
#define REG_VIC_I_ISPC		(REG_VIC_BASE + 0x40)
#define REG_VIC_F_PSLV0  	(REG_VIC_BASE + 0x44)
#define REG_VIC_F_PSLV1  	(REG_VIC_BASE + 0x48)
#define REG_VIC_F_PSLV2  	(REG_VIC_BASE + 0x4C)
#define REG_VIC_F_PSLV3  	(REG_VIC_BASE + 0x50)
#define REG_VIC_F_PMST   	(REG_VIC_BASE + 0x54)
#define REG_VIC_F_CSLV0  	(REG_VIC_BASE + 0x58)
#define REG_VIC_F_CSLV1  	(REG_VIC_BASE + 0x5C)
#define REG_VIC_F_CSLV2  	(REG_VIC_BASE + 0x60)
#define REG_VIC_F_CSLV3  	(REG_VIC_BASE + 0x64)
#define REG_VIC_F_CMST   	(REG_VIC_BASE + 0x68)
#define REG_VIC_F_ISPR		(REG_VIC_BASE + 0x6C)
#define REG_VIC_F_ISPC		(REG_VIC_BASE + 0x70)
#define REG_VIC_POLARITY 	(REG_VIC_BASE + 0x74)  
#define REG_VIC_I_VECADDR	(REG_VIC_BASE + 0x78) 
#define REG_VIC_F_VECADDR	(REG_VIC_BASE + 0x7C) 

/* VIF */
#define REG_VIF_BASE		(0x00000000)
#define REG_VIF_VIFCON		(REG_VIF_BASE + 0x00)
#define REG_VIF_VIFSTS		(REG_VIF_BASE + 0x04)
#define REG_VIF_VIFPOS		(REG_VIF_BASE + 0x08)
#define REG_VIF_VIFSIZ		(REG_VIF_BASE + 0x0C)
#define REG_VIF_VIFADDR	(REG_VIF_BASE + 0x10)

/* WDT */          			
#define REG_WDT_BASE		(0x00000000)
#define REG_WDT_WDTCR  	(REG_WDT_BASE + 0x00)
#define REG_WDT_WDTPSR 	(REG_WDT_BASE + 0x04)
#define REG_WDT_WDTTLDR	(REG_WDT_BASE + 0x08)
#define REG_WDT_WDTVLR 	(REG_WDT_BASE + 0x0C)
#define REG_WDT_WDTISR 	(REG_WDT_BASE + 0x10)


/*/////////////////////////////////////////////////////////
        STRUCTURE DEFINITION
///////////////////////////////////////////////////////// */
typedef enum {
    READ_ONLY,
    WRITE_ONLY,
    READ_WRITE
} ACCESS_TYPE;


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
smtBoolean RegisterADC(void);
smtBoolean RegisterDM(void);
smtBoolean RegisterDMA(void);
smtBoolean Register2DDMA(void);
smtBoolean RegisterDMC(void);
smtBoolean RegisterGPIO(void);
smtBoolean RegisterI2C(void);
smtBoolean RegisterI2S(void);
smtBoolean RegisterNAND(void);
smtBoolean RegisterPower(void);
smtBoolean RegisterPWM(void);
smtBoolean RegisterSMC(void);
smtBoolean RegisterTimer(void);
smtBoolean RegisterUART(void);
smtBoolean RegisterVIC(void);
smtBoolean RegisterVIF(void);
smtBoolean RegisterWDT(void);

smtBoolean RegisterRangeCheck(smtUint32 pRegList[][3], smtUint32 data);
smtBoolean RegisterCheck(smtUint32 registerNum, smtUint32 data, smtUint32 bitmask);

#endif /* __REGISTER_H__ */
