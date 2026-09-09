/*------------------------------------------------------------------------------
    File Name   : sysreg.h
    Description : Special function register definition using ARM7TDMI core
------------------------------------------------------------------------------*/

#ifndef __SDI_V5_H__
#define __SDI_V5_H__

#ifdef __cplusplus
extern "C" {
#endif

/*//////////////////////////////////////////////////////////////////////////////
//	INCLUDE
//////////////////////////////////////////////////////////////////////////////*/
#include "syscfg.h"

/*//////////////////////////////////////////////////////////////////////////////
/	REGISTER DEFINITION
//////////////////////////////////////////////////////////////////////////////*/

/* DMA Controller */
#define DMAC_BASEADDR		(APB0_STARTADDR+0x0000)
#define DMACSADR0			(*(volatile unsigned *)(DMAC_BASEADDR+0x00))
#define DMACDADR0			(*(volatile unsigned *)(DMAC_BASEADDR+0x04))
#define DMACCON0			(*(volatile unsigned *)(DMAC_BASEADDR+0x08))
#define DMACDESCRP0			(*(volatile unsigned *)(DMAC_BASEADDR+0x0C))
#define DMACSTA0			(*(volatile unsigned *)(DMAC_BASEADDR+0x10))
#define DMACSADR1			(*(volatile unsigned *)(DMAC_BASEADDR+0x20))
#define DMACDADR1			(*(volatile unsigned *)(DMAC_BASEADDR+0x24))
#define DMACCON1			(*(volatile unsigned *)(DMAC_BASEADDR+0x28))
#define DMACDESCRP1			(*(volatile unsigned *)(DMAC_BASEADDR+0x2C))
#define DMACSTA1			(*(volatile unsigned *)(DMAC_BASEADDR+0x30))
#define DMACSADR2			(*(volatile unsigned *)(DMAC_BASEADDR+0x40))
#define DMACDADR2			(*(volatile unsigned *)(DMAC_BASEADDR+0x44))
#define DMACCON2			(*(volatile unsigned *)(DMAC_BASEADDR+0x48))
#define DMACDESCRP2			(*(volatile unsigned *)(DMAC_BASEADDR+0x4C))
#define DMACSTA2			(*(volatile unsigned *)(DMAC_BASEADDR+0x50))
#define DMACSADR3			(*(volatile unsigned *)(DMAC_BASEADDR+0x60))
#define DMACDADR3			(*(volatile unsigned *)(DMAC_BASEADDR+0x64))
#define DMACCON3			(*(volatile unsigned *)(DMAC_BASEADDR+0x68))
#define DMACDESCRP3			(*(volatile unsigned *)(DMAC_BASEADDR+0x6C))
#define DMACSTA3			(*(volatile unsigned *)(DMAC_BASEADDR+0x70))
#define DMACSADR4			(*(volatile unsigned *)(DMAC_BASEADDR+0x80))
#define DMACDADR4			(*(volatile unsigned *)(DMAC_BASEADDR+0x84))
#define DMACCON4			(*(volatile unsigned *)(DMAC_BASEADDR+0x88))
#define DMACDESCRP4			(*(volatile unsigned *)(DMAC_BASEADDR+0x8C))
#define DMACSTA4			(*(volatile unsigned *)(DMAC_BASEADDR+0x90))
#define DMACSADR5			(*(volatile unsigned *)(DMAC_BASEADDR+0xA0))
#define DMACDADR5			(*(volatile unsigned *)(DMAC_BASEADDR+0xA4))
#define DMACCON5			(*(volatile unsigned *)(DMAC_BASEADDR+0xA8))
#define DMACDESCRP5			(*(volatile unsigned *)(DMAC_BASEADDR+0xAC))
#define DMACSTA5			(*(volatile unsigned *)(DMAC_BASEADDR+0xB0))
#define DMACSADR6			(*(volatile unsigned *)(DMAC_BASEADDR+0xC0))
#define DMACDADR6			(*(volatile unsigned *)(DMAC_BASEADDR+0xC4))
#define DMACCON6			(*(volatile unsigned *)(DMAC_BASEADDR+0xC8))
#define DMACDESCRP6			(*(volatile unsigned *)(DMAC_BASEADDR+0xCC))
#define DMACSTA6			(*(volatile unsigned *)(DMAC_BASEADDR+0xD0))
#define DMACSADR7			(*(volatile unsigned *)(DMAC_BASEADDR+0xE0))
#define DMACDADR7			(*(volatile unsigned *)(DMAC_BASEADDR+0xE4))
#define DMACCON7			(*(volatile unsigned *)(DMAC_BASEADDR+0xE8))
#define DMACDESCRP7			(*(volatile unsigned *)(DMAC_BASEADDR+0xEC))
#define DMACSTA7			(*(volatile unsigned *)(DMAC_BASEADDR+0xF0))
#define DMACSAdr(x)			(*(volatile unsigned *)(DMAC_BASEADDR+0x00+(x*0x20)))
#define DMACDAdr(x)			(*(volatile unsigned *)(DMAC_BASEADDR+0x04+(x*0x20)))
#define DMACCon(x)			(*(volatile unsigned *)(DMAC_BASEADDR+0x08+(x*0x20)))
#define DMACDescrp(x)		(*(volatile unsigned *)(DMAC_BASEADDR+0x0C+(x*0x20)))
#define DMACSta(x)			(*(volatile unsigned *)(DMAC_BASEADDR+0x10+(x*0x20)))

/* G-DMA controller */ // Graphic-DMA
#define DMA2D_BASEADDR	(APB0_STARTADDR+0x0000)
#define DMA2D_SRCADDR		(*(volatile unsigned *)(DMA2D_BASEADDR+0x00))
#define DMA2D_DSTADDR		(*(volatile unsigned *)(DMA2D_BASEADDR+0x04))
#define DMA2D_SIZE			(*(volatile unsigned *)(DMA2D_BASEADDR+0x08))
#define DMA2D_CNT			(*(volatile unsigned *)(DMA2D_BASEADDR+0x0C))
#define DMA2D_ADDRUPD		(*(volatile unsigned *)(DMA2D_BASEADDR+0x10))
#define DMA2D_STATUS		(*(volatile unsigned *)(DMA2D_BASEADDR+0x14))

/* DM(Display Module) */
#define DM_BASEADDR			(APB1_STARTADDR+0x6000)
#define DMCON				(*(volatile unsigned *)(DM_BASEADDR+0x000))
#define DMSTS				(*(volatile unsigned *)(DM_BASEADDR+0x004))
//Cursor Plane
#define CCON				(*(volatile unsigned *)(DM_BASEADDR+0x010))
#define CBLND				(*(volatile unsigned *)(DM_BASEADDR+0x014))
#define CBMOD				(*(volatile unsigned *)(DM_BASEADDR+0x018))
#define CBASE				(*(volatile unsigned *)(DM_BASEADDR+0x01c))
#define CADDR				(*(volatile unsigned *)(DM_BASEADDR+0x020))
#define CPALM				(*(volatile unsigned *)(DM_BASEADDR+0x024))
//Background Plane
#define BGCOL				(*(volatile unsigned *)(DM_BASEADDR+0x030))
//Graphic Plane
#define GCON				(*(volatile unsigned *)(DM_BASEADDR+0x040))
#define GBLND				(*(volatile unsigned *)(DM_BASEADDR+0x044))
#define GBMOD				(*(volatile unsigned *)(DM_BASEADDR+0x048))
#define GBASE				(*(volatile unsigned *)(DM_BASEADDR+0x04c))
#define GADDR				(*(volatile unsigned *)(DM_BASEADDR+0x050))
#define GPALM				(*(volatile unsigned *)(DM_BASEADDR+0x054))
//Video Plane
#define VCON				(*(volatile unsigned *)(DM_BASEADDR+0x060))
#define VBLND				(*(volatile unsigned *)(DM_BASEADDR+0x064))
#define VBMOD				(*(volatile unsigned *)(DM_BASEADDR+0x068))
#define VBASE				(*(volatile unsigned *)(DM_BASEADDR+0x06c))
#define VADDR				(*(volatile unsigned *)(DM_BASEADDR+0x070))
#define VADDR2				(*(volatile unsigned *)(DM_BASEADDR+0x078))//shkim-20070117:check the offset
//LCD control
#define LCDCON				(*(volatile unsigned *)(DM_BASEADDR+0x0E0))
#define VIDCON				(*(volatile unsigned *)(DM_BASEADDR+0x0E4))
#define HSYNC0				(*(volatile unsigned *)(DM_BASEADDR+0x0F0))
#define HSYNC1				(*(volatile unsigned *)(DM_BASEADDR+0x0F4))
#define VSYNC0				(*(volatile unsigned *)(DM_BASEADDR+0x0F8))
#define VSYNC1				(*(volatile unsigned *)(DM_BASEADDR+0x0FC))
//Graphic Gamma
#define GGAMMA00			(*(volatile unsigned *)(DM_BASEADDR+0x100))
#define GGAMMA01			(*(volatile unsigned *)(DM_BASEADDR+0x104))
#define GGAMMA02			(*(volatile unsigned *)(DM_BASEADDR+0x108))
#define GGAMMA03			(*(volatile unsigned *)(DM_BASEADDR+0x10C))
#define GGAMMA04			(*(volatile unsigned *)(DM_BASEADDR+0x110))
#define GGAMMA05			(*(volatile unsigned *)(DM_BASEADDR+0x114))
#define GGAMMA06			(*(volatile unsigned *)(DM_BASEADDR+0x118))
#define GGAMMA07			(*(volatile unsigned *)(DM_BASEADDR+0x11C))
#define GGAMMA08			(*(volatile unsigned *)(DM_BASEADDR+0x120))
#define GGAMMA09			(*(volatile unsigned *)(DM_BASEADDR+0x124))
#define GGAMMA0A			(*(volatile unsigned *)(DM_BASEADDR+0x128))
#define GGAMMA0B			(*(volatile unsigned *)(DM_BASEADDR+0x12C))
#define GGAMMA0C			(*(volatile unsigned *)(DM_BASEADDR+0x130))
#define GGAMMA0D			(*(volatile unsigned *)(DM_BASEADDR+0x134))
#define GGAMMA0E			(*(volatile unsigned *)(DM_BASEADDR+0x138))
#define GGAMMA0F			(*(volatile unsigned *)(DM_BASEADDR+0x13C))
#define GGAMMA10			(*(volatile unsigned *)(DM_BASEADDR+0x140))
//Video Gamma
#define VGAMMA00			(*(volatile unsigned *)(DM_BASEADDR+0x200))
#define VGAMMA01			(*(volatile unsigned *)(DM_BASEADDR+0x204))
#define VGAMMA02			(*(volatile unsigned *)(DM_BASEADDR+0x208))
#define VGAMMA03			(*(volatile unsigned *)(DM_BASEADDR+0x20C))
#define VGAMMA04			(*(volatile unsigned *)(DM_BASEADDR+0x210))
#define VGAMMA05			(*(volatile unsigned *)(DM_BASEADDR+0x214))
#define VGAMMA06			(*(volatile unsigned *)(DM_BASEADDR+0x218))
#define VGAMMA07			(*(volatile unsigned *)(DM_BASEADDR+0x21C))
#define VGAMMA08			(*(volatile unsigned *)(DM_BASEADDR+0x220))
#define VGAMMA09			(*(volatile unsigned *)(DM_BASEADDR+0x224))
#define VGAMMA0A			(*(volatile unsigned *)(DM_BASEADDR+0x228))
#define VGAMMA0B			(*(volatile unsigned *)(DM_BASEADDR+0x22C))
#define VGAMMA0C			(*(volatile unsigned *)(DM_BASEADDR+0x230))
#define VGAMMA0D			(*(volatile unsigned *)(DM_BASEADDR+0x234))
#define VGAMMA0E			(*(volatile unsigned *)(DM_BASEADDR+0x238))
#define VGAMMA0F			(*(volatile unsigned *)(DM_BASEADDR+0x23C))
#define VGAMMA10			(*(volatile unsigned *)(DM_BASEADDR+0x240))

/* Internal flash */
#define FMKEY               (*(volatile unsigned *)(FLASH_BASE_ADDR+0x00))
#define FMADDR              (*(volatile unsigned *)(FLASH_BASE_ADDR+0x04))
#define FMDATA              (*(volatile unsigned *)(FLASH_BASE_ADDR+0x08))
#define FMUCON              (*(volatile unsigned *)(FLASH_BASE_ADDR+0x0C))
#define FSO                 (*(volatile unsigned *)(FLASH_BASE_ADDR+0x10))
#define FPO                 (*(volatile unsigned *)(FLASH_BASE_ADDR+0x14))

#define FMTNV               (*(volatile unsigned *)(FLASH_BASE_ADDR+0x20))
#define FMTPG               (*(volatile unsigned *)(FLASH_BASE_ADDR+0x24))
#define FMTRCV              (*(volatile unsigned *)(FLASH_BASE_ADDR+0x28))
#define FMTPROG             (*(volatile unsigned *)(FLASH_BASE_ADDR+0x2C))
#define FMTERASE            (*(volatile unsigned *)(FLASH_BASE_ADDR+0x30))
#define FMTME               (*(volatile unsigned *)(FLASH_BASE_ADDR+0x34))

/* External sram */
#define ESMC_B0_CON			(*(volatile unsigned *)(SRAM_BASE_ADDR+0x00))
#define ESMC_B1_CON			(*(volatile unsigned *)(SRAM_BASE_ADDR+0x04))
#define ESMC_B2_CON			(*(volatile unsigned *)(SRAM_BASE_ADDR+0x08))
#define ESMC_B3_CON			(*(volatile unsigned *)(SRAM_BASE_ADDR+0x0C))

/* External sdram */
#define SDRTCON			(*(volatile unsigned *)(SDRAM_BASE_ADDR+0x00))
#define SDRCON			(*(volatile unsigned *)(SDRAM_BASE_ADDR+0x04))
#define SDRPCON			(*(volatile unsigned *)(SDRAM_BASE_ADDR+0x08))
#define SDRREF			(*(volatile unsigned *)(SDRAM_BASE_ADDR+0x0C))

/* UART */
//UART ch0
#define UART0MASTER		(*(volatile unsigned *)(UART0_BASE_ADDR+0x00))
#define UART0STATUS		(*(volatile unsigned *)(UART0_BASE_ADDR+0x04))
#define UART0BRD		(*(volatile unsigned *)(UART0_BASE_ADDR+0x08))
#define UART0TXFIFO		(*(volatile unsigned *)(UART0_BASE_ADDR+0x0C))
#define UART0RXFIFO		(*(volatile unsigned *)(UART0_BASE_ADDR+0x10))
#define UART0RXTIMEOUT	(*(volatile unsigned *)(UART0_BASE_ADDR+0x14))

//UART ch1
#define UART1MASTER		(*(volatile unsigned *)(UART1_BASE_ADDR+0x00))
#define UART1STATUS		(*(volatile unsigned *)(UART1_BASE_ADDR+0x04))
#define UART1BRD		(*(volatile unsigned *)(UART1_BASE_ADDR+0x08))
#define UART1TXFIFO		(*(volatile unsigned *)(UART1_BASE_ADDR+0x0C))
#define UART1RXFIFO		(*(volatile unsigned *)(UART1_BASE_ADDR+0x10))
#define UART1RXTIMEOUT	(*(volatile unsigned *)(UART1_BASE_ADDR+0x14))

//UART OFFSET
#define UART_OFFSET_MASTER 		0x00
#define UART_OFFSET_STATUS 		0x04
#define UART_OFFSET_BRD 		0x08
#define UART_OFFSET_TXFIFO 		0x0C
#define UART_OFFSET_RXFIFO 		0x10
#define UART_OFFSET_RXTIMEOUT	0x14

/* I2C0 */
#define I2CCON			(*(volatile unsigned *)(I2C_BASE_ADDR+0x00))
#define I2CSTA			(*(volatile unsigned *)(I2C_BASE_ADDR+0x04))
#define I2CDAT			(*(volatile unsigned *)(I2C_BASE_ADDR+0x08))

/* Video Interface Controller */
#define VIFCON				(*(volatile unsigned *)(VIF_BASE_ADDR+0x00))
#define VIFSTS				(*(volatile unsigned *)(VIF_BASE_ADDR+0x04))
#define VIFPOS				(*(volatile unsigned *)(VIF_BASE_ADDR+0x08))
#define VIFSIZ				(*(volatile unsigned *)(VIF_BASE_ADDR+0x0C))
#define VIFADDR				(*(volatile unsigned *)(VIF_BASE_ADDR+0x10))

/* Timer0 */
#define TDAT0               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x00))
#define TPRE0               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x04))
#define TCON0               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x08))
#define TCNT0               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x0C))
#define TPWM0               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x10))

/* Timer1 */
#define TDAT1               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x20))
#define TPRE1               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x24))
#define TCON1               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x28))
#define TCNT1               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x2C))
#define TPWM1               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x30))

/* Timer2 */
#define TDAT2               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x40))
#define TPRE2               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x44))
#define TCON2               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x48))
#define TCNT2               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x4C))
#define TPWM2               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x50))

/* Timer3 */
#define TDAT3               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x60))
#define TPRE3               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x64))
#define TCON3               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x68))
#define TCNT3               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x6C))
#define TPWM3               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x70))

/* Timer4 */
#define TDAT4               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x80))
#define TPRE4               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x84))
#define TCON4               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x88))
#define TCNT4               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x8C))
#define TPWM4               (*(volatile unsigned *)(TIMER_BASE_ADDR+0x90))

/* Timer5 */
#define TDAT5               (*(volatile unsigned *)(TIMER_BASE_ADDR+0xA0))
#define TPRE5               (*(volatile unsigned *)(TIMER_BASE_ADDR+0xA4))
#define TCON5               (*(volatile unsigned *)(TIMER_BASE_ADDR+0xA8))
#define TCNT5               (*(volatile unsigned *)(TIMER_BASE_ADDR+0xAC))
#define TPWM5               (*(volatile unsigned *)(TIMER_BASE_ADDR+0xB0))

/* Timer6 */
#define TDAT6               (*(volatile unsigned *)(TIMER_BASE_ADDR+0xC0))
#define TPRE6               (*(volatile unsigned *)(TIMER_BASE_ADDR+0xC4))
#define TCON6               (*(volatile unsigned *)(TIMER_BASE_ADDR+0xC8))
#define TCNT6               (*(volatile unsigned *)(TIMER_BASE_ADDR+0xCC))
#define TPWM6               (*(volatile unsigned *)(TIMER_BASE_ADDR+0xD0))

/* Timer7 */
#define TDAT7               (*(volatile unsigned *)(TIMER_BASE_ADDR+0xE0))
#define TPRE7               (*(volatile unsigned *)(TIMER_BASE_ADDR+0xE4))
#define TCON7               (*(volatile unsigned *)(TIMER_BASE_ADDR+0xE8))
#define TCNT7               (*(volatile unsigned *)(TIMER_BASE_ADDR+0xEC))
#define TPWM7               (*(volatile unsigned *)(TIMER_BASE_ADDR+0xF0))

/* PWM 0-0 */
#define PDAT0_0				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x00))
#define PPRE0_0				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x04))
#define PCON0_0				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x08))
#define PCNT0_0				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x0C))
#define PPWM0_0				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x10))
                        	
/* PWM 0-1 */           	
#define PDAT0_1				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x20))
#define PPRE0_1				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x24))
#define PCON0_1				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x28))
#define PCNT0_1				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x2C))
#define PPWM0_1				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x30))
                        	
/* PWM 0-2 */           	
#define PDAT0_2				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x40))
#define PPRE0_2				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x44))
#define PCON0_2				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x48))
#define PCNT0_2				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x4C))
#define PPWM0_2				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x50))
                        	
/* PWM 0-3 */           	
#define PDAT0_3				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x60))
#define PPRE0_3				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x64))
#define PCON0_3				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x68))
#define PCNT0_3				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x6C))
#define PPWM0_3				(*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x70))

/* PWM 0-4 */
#define PDAT0_4		        (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x80))
#define PPRE0_4		        (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x84))
#define PCON0_4		        (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x88))
#define PCNT0_4		        (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x8C))
#define PPWM0_4		        (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0x90))
                        	
/* PWM 0-5 */           	
#define PDAT0_5		        (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0xA0))
#define PPRE0_5		        (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0xA4))
#define PCON0_5		        (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0xA8))
#define PCNT0_5		        (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0xAC))
#define PPWM0_5		        (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0xB0))
                        	
/* PWM 0-6 */           	
#define PDAT0_6 	        (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0xC0))
#define PPRE0_6 	        (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0xC4))
#define PCON0_6 	        (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0xC8))
#define PCNT0_6 	        (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0xCC))
#define PPWM0_6 	        (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0xD0))
                        	
/* PWM 0-7 */           	
#define PDAT0_7  		    (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0xE0))
#define PPRE0_7  		    (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0xE4))
#define PCON0_7  		    (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0xE8))
#define PCNT0_7  		    (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0xEC))
#define PPWM0_7  		    (*(volatile unsigned *)(PWM0_0_BASE_ADDR+0xF0))
                        	
/* PWM 1-0 */           	
#define PDAT1_0		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x00))
#define PPRE1_0		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x04))
#define PCON1_0		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x08))
#define PCNT1_0		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x0C))
#define PPWM1_0		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x10))

/* PWM 1-1 */
#define PDAT1_1		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x20))
#define PPRE1_1		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x24))
#define PCON1_1		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x28))
#define PCNT1_1		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x2C))
#define PPWM1_1		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x30))
                        	
/* PWM 1-2 */           	
#define PDAT1_2		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x40))
#define PPRE1_2		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x44))
#define PCON1_2		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x48))
#define PCNT1_2		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x4C))
#define PPWM1_2		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x50))
                        	
/* PWM 1-3 */           	
#define PDAT1_3		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x60))
#define PPRE1_3		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x64))
#define PCON1_3		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x68))
#define PCNT1_3		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x6C))
#define PPWM1_3		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x70))
                        	
/* PWM 1-4 */           	
#define PDAT1_4		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x80))
#define PPRE1_4		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x84))
#define PCON1_4		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x88))
#define PCNT1_4		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x8C))
#define PPWM1_4		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0x90))
                        	
/* PWM 1-5 */           	
#define PDAT1_5		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0xA0))
#define PPRE1_5		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0xA4))
#define PCON1_5		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0xA8))
#define PCNT1_5		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0xAC))
#define PPWM1_5		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0xB0))
                        	
/* PWM 1-6 */           	
#define PDAT1_6		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0xC0))
#define PPRE1_6		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0xC4))
#define PCON1_6		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0xC8))
#define PCNT1_6		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0xCC))
#define PPWM1_6		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0xD0))

/* PWM 1-7 */
#define PDAT1_7		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0xE0))
#define PPRE1_7		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0xE4))
#define PCON1_7		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0xE8))
#define PCNT1_7		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0xEC))
#define PPWM1_7		        (*(volatile unsigned *)(PWM1_0_BASE_ADDR+0xF0))
                        	
/* PWM 2-0 */
#define PDAT2_0		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x00))
#define PPRE2_0		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x04))
#define PCON2_0		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x08))
#define PCNT2_0		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x0C))
#define PPWM2_0		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x10))
                        	
/* PWM 2-1 */           	
#define PDAT2_1		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x20))
#define PPRE2_1		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x24))
#define PCON2_1		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x28))
#define PCNT2_1		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x2C))
#define PPWM2_1		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x30))
                        	
/* PWM 2-2 */           	
#define PDAT2_2		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x40))
#define PPRE2_2		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x44))
#define PCON2_2		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x48))
#define PCNT2_2		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x4C))
#define PPWM2_2		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x50))
                        	
/* PWM 2-3 */           	
#define PDAT2_3		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x60))
#define PPRE2_3		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x64))
#define PCON2_3		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x68))
#define PCNT2_3		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x6C))
#define PPWM2_3		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x70))

/* PWM 2-4 */
#define PDAT2_4		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x80))
#define PPRE2_4		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x84))
#define PCON2_4		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x88))
#define PCNT2_4		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x8C))
#define PPWM2_4		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0x90))
                        	
/* PWM 2-5 */           	
#define PDAT2_5		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0xA0))
#define PPRE2_5		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0xA4))
#define PCON2_5		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0xA8))
#define PCNT2_5		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0xAC))
#define PPWM2_5		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0xB0))
                        	
/* PWM 2-6 */           	
#define PDAT2_6		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0xC0))
#define PPRE2_6		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0xC4))
#define PCON2_6		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0xC8))
#define PCNT2_6		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0xCC))
#define PPWM2_6		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0xD0))
                        	
/* PWM 2-7 */           	
#define PDAT2_7		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0xE0))
#define PPRE2_7		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0xE4))
#define PCON2_7		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0xE8))
#define PCNT2_7		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0xEC))
#define PPWM2_7		        (*(volatile unsigned *)(PWM2_0_BASE_ADDR+0xF0))
                        	
/* PWM 3-0 */           	
#define PDAT3_0		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x00))
#define PPRE3_0		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x04))
#define PCON3_0		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x08))
#define PCNT3_0		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x0C))
#define PPWM3_0		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x10))

/* PWM 3-1 */
#define PDAT3_1		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x20))
#define PPRE3_1		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x24))
#define PCON3_1		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x28))
#define PCNT3_1		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x2C))
#define PPWM3_1		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x30))
                        	
/* PWM 3-2 */           	
#define PDAT3_2		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x40))
#define PPRE3_2		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x44))
#define PCON3_2		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x48))
#define PCNT3_2		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x4C))
#define PPWM3_2		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x50))
                        	
/* PWM 3-3 */           	
#define PDAT3_3		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x60))
#define PPRE3_3		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x64))
#define PCON3_3		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x68))
#define PCNT3_3		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x6C))
#define PPWM3_3		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x70))
                        	
/* PWM 3-4 */           	
#define PDAT3_4		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x80))
#define PPRE3_4		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x84))
#define PCON3_4		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x88))
#define PCNT3_4		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x8C))
#define PPWM3_4		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0x90))
                        	
/* PWM 3-5 */           	
#define PDAT3_5		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0xA0))
#define PPRE3_5		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0xA4))
#define PCON3_5		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0xA8))
#define PCNT3_5		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0xAC))
#define PPWM3_5		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0xB0))

/* PWM 3-6 */
#define PDAT3_6		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0xC0))
#define PPRE3_6		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0xC4))
#define PCON3_6		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0xC8))
#define PCNT3_6		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0xCC))
#define PPWM3_6		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0xD0))
                        	
/* PWM 3-7 */           	
#define PDAT3_7		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0xE0))
#define PPRE3_7		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0xE4))
#define PCON3_7		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0xE8))
#define PCNT3_7		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0xEC))
#define PPWM3_7		        (*(volatile unsigned *)(PWM3_0_BASE_ADDR+0xF0))
                        	
/* WDT */               	
#define WDTCR  		        (*(volatile unsigned *)(WDT_BASE_ADDR+0x00))
#define WDTPSR 		        (*(volatile unsigned *)(WDT_BASE_ADDR+0x04))
#define WDTTLDR		        (*(volatile unsigned *)(WDT_BASE_ADDR+0x08))
#define WDTVLR 		        (*(volatile unsigned *)(WDT_BASE_ADDR+0x0C))
#define WDTISR 		        (*(volatile unsigned *)(WDT_BASE_ADDR+0x10))
                        	
/* GPIO */
#define GPIO0_OE			(*(volatile unsigned *)(GPIO_BASE_ADDR+0x00))
#define GPIO0_IN				(*(volatile unsigned *)(GPIO_BASE_ADDR+0x04))
#define GPIO0_OUT			(*(volatile unsigned *)(GPIO_BASE_ADDR+0x08))
#define GPIO0_INTSTAT		(*(volatile unsigned *)(GPIO_BASE_ADDR+0x0C))
#define GPIO0_INTEN			(*(volatile unsigned *)(GPIO_BASE_ADDR+0x10))
#define GPIO0_INTLEVEL		(*(volatile unsigned *)(GPIO_BASE_ADDR+0x14))
#define GPIO0_INTPOL		(*(volatile unsigned *)(GPIO_BASE_ADDR+0x18))
#define GPIO0_INTBEDGE		(*(volatile unsigned *)(GPIO_BASE_ADDR+0x1C))

#define GPIO1_OE			(*(volatile unsigned *)(GPIO_BASE_ADDR+0x20))
#define GPIO1_IN				(*(volatile unsigned *)(GPIO_BASE_ADDR+0x24))
#define GPIO1_OUT			(*(volatile unsigned *)(GPIO_BASE_ADDR+0x28))
#define GPIO1_INTSTAT		(*(volatile unsigned *)(GPIO_BASE_ADDR+0x2C))
#define GPIO1_INTEN			(*(volatile unsigned *)(GPIO_BASE_ADDR+0x30))
#define GPIO1_INTLEVEL		(*(volatile unsigned *)(GPIO_BASE_ADDR+0x34))
#define GPIO1_INTPOL		(*(volatile unsigned *)(GPIO_BASE_ADDR+0x38))
#define GPIO1_INTBEDGE		(*(volatile unsigned *)(GPIO_BASE_ADDR+0x3C))

/* Interrupt */
#define INTCON              (*(volatile unsigned *)(VIC_BASE_ADDR+0x00))
#define INTPND              (*(volatile unsigned *)(VIC_BASE_ADDR+0x04))
#define INTMOD              (*(volatile unsigned *)(VIC_BASE_ADDR+0x08))
#define INTMSK              (*(volatile unsigned *)(VIC_BASE_ADDR+0x0C))
#define LEVEL               (*(volatile unsigned *)(VIC_BASE_ADDR+0x10))
#define I_PSLV0             (*(volatile unsigned *)(VIC_BASE_ADDR+0x14))
#define I_PSLV1             (*(volatile unsigned *)(VIC_BASE_ADDR+0x18))
#define I_PSLV2             (*(volatile unsigned *)(VIC_BASE_ADDR+0x1C))
#define I_PSLV3             (*(volatile unsigned *)(VIC_BASE_ADDR+0x20))
#define F_PSLV0             (*(volatile unsigned *)(VIC_BASE_ADDR+0x44)) 
#define F_PSLV1             (*(volatile unsigned *)(VIC_BASE_ADDR+0x48))
#define F_PSLV2             (*(volatile unsigned *)(VIC_BASE_ADDR+0x4C))
#define F_PSLV3             (*(volatile unsigned *)(VIC_BASE_ADDR+0x50))
#define I_PMST              (*(volatile unsigned *)(VIC_BASE_ADDR+0x24))
#define F_PMST              (*(volatile unsigned *)(VIC_BASE_ADDR+0x54))
#define ICSLV0              (*(volatile unsigned *)(VIC_BASE_ADDR+0x28))
#define ICSLV1              (*(volatile unsigned *)(VIC_BASE_ADDR+0x2C))
#define ICSLV2              (*(volatile unsigned *)(VIC_BASE_ADDR+0x30))
#define ICSLV3              (*(volatile unsigned *)(VIC_BASE_ADDR+0x34))
#define F_CSLV0             (*(volatile unsigned *)(VIC_BASE_ADDR+0x58))
#define F_CSLV1             (*(volatile unsigned *)(VIC_BASE_ADDR+0x5C))
#define F_CSLV2             (*(volatile unsigned *)(VIC_BASE_ADDR+0x60))
#define F_CSLV3             (*(volatile unsigned *)(VIC_BASE_ADDR+0x64))
#define I_CMST              (*(volatile unsigned *)(VIC_BASE_ADDR+0x38))
#define F_CMST              (*(volatile unsigned *)(VIC_BASE_ADDR+0x68))
#define I_ISPR              (*(volatile unsigned *)(VIC_BASE_ADDR+0x3C))
#define F_ISPR              (*(volatile unsigned *)(VIC_BASE_ADDR+0x6C))
#define I_ISPC              (*(volatile unsigned *)(VIC_BASE_ADDR+0x40))
#define F_ISPC              (*(volatile unsigned *)(VIC_BASE_ADDR+0x70))
#define POLARITY            (*(volatile unsigned *)(VIC_BASE_ADDR+0x74))
#define I_VECADDR		   	(*(volatile unsigned *)(VIC_BASE_ADDR+0x78))
#define F_VECADDR		    (*(volatile unsigned *)(VIC_BASE_ADDR+0x7C))

/* ADC */
#define ADCCON	          	(*(volatile unsigned *)(ADC_BASE_ADDR+0x00))
#define ADCDAT	          	(*(volatile unsigned *)(ADC_BASE_ADDR+0x04))

/* Power */
#define PM_CLKCON		(*(volatile unsigned *)(POWER_BASE_ADDR+0x00))
#define PM_CLKDIV		(*(volatile unsigned *)(POWER_BASE_ADDR+0x04))
#define PM_SYSPLL		(*(volatile unsigned *)(POWER_BASE_ADDR+0x08))
#define PM_USBPLL		(*(volatile unsigned *)(POWER_BASE_ADDR+0x0C))
#define PM_RSTCON		(*(volatile unsigned *)(POWER_BASE_ADDR+0x10))

/* I2S */
#define I2S_BASEADDR		(APB1_STARTADDR+0x7000)
#define I2S_CLKCTRL			(*(volatile unsigned *)(I2S_BASEADDR+0x00))
#define I2S_CTRL			(*(volatile unsigned *)(I2S_BASEADDR+0x04))
#define I2S_STATUS			(*(volatile unsigned *)(I2S_BASEADDR+0x08))
#define I2S_DATA			(*(volatile unsigned *)(I2S_BASEADDR+0x0C))

/* SD/MMC Controller */
#define	MMC_BASEADDR		(APB1_STARTADDR+0x3000)
#define SDCON				(*(volatile unsigned *)(MMC_BASEADDR+0x00))
#define SDPRE				(*(volatile unsigned *)(MMC_BASEADDR+0x04))
#define SDCmdArg			(*(volatile unsigned *)(MMC_BASEADDR+0x08))
#define SDCmdCon			(*(volatile unsigned *)(MMC_BASEADDR+0x0C))
#define SDCmdSta			(*(volatile unsigned *)(MMC_BASEADDR+0x10))
#define SDRSP0				(*(volatile unsigned *)(MMC_BASEADDR+0x14))
#define SDRSP1				(*(volatile unsigned *)(MMC_BASEADDR+0x18))
#define SDRSP2				(*(volatile unsigned *)(MMC_BASEADDR+0x1C))
#define SDRSP3				(*(volatile unsigned *)(MMC_BASEADDR+0x20))
#define SDDTimer			(*(volatile unsigned *)(MMC_BASEADDR+0x24))
#define SDBSize				(*(volatile unsigned *)(MMC_BASEADDR+0x28))
#define SDDatCon			(*(volatile unsigned *)(MMC_BASEADDR+0x2C))
#define SDDatCnt			(*(volatile unsigned *)(MMC_BASEADDR+0x30))
#define SDDatSta			(*(volatile unsigned *)(MMC_BASEADDR+0x34))
#define SDFSTA				(*(volatile unsigned *)(MMC_BASEADDR+0x38))
#define SDIntMsk			(*(volatile unsigned *)(MMC_BASEADDR+0x3C))
#define SDIntSta			(*(volatile unsigned *)(MMC_BASEADDR+0x40))
#define SDDAT				(*(volatile unsigned *)(MMC_BASEADDR+0x44))
#define SDAutoReadCon		(*(volatile unsigned *)(MMC_BASEADDR+0x48))
#define SDAutoReadSta		(*(volatile unsigned *)(MMC_BASEADDR+0x4C))

/* NAND Controller */
#define	NAND_BASEADDR		(APB1_STARTADDR+0x0000)
#define	NANDNFOPER			(*(volatile unsigned *)(NAND_BASEADDR+0x00))
#define	NANDDATA            (*(volatile unsigned *)(NAND_BASEADDR+0x04))
#define	NANDCONF			(*(volatile unsigned *)(NAND_BASEADDR+0x08))
#define	NANDCTRL            (*(volatile unsigned *)(NAND_BASEADDR+0x0C))
#define	NANDSTAT            (*(volatile unsigned *)(NAND_BASEADDR+0x10))
#define	ECCSECTOR0          (*(volatile unsigned *)(NAND_BASEADDR+0x14))
#define	ECCSECTOR1          (*(volatile unsigned *)(NAND_BASEADDR+0x18))
#define	ECCSECTOR2          (*(volatile unsigned *)(NAND_BASEADDR+0x1c))
#define	ECCSECTOR3          (*(volatile unsigned *)(NAND_BASEADDR+0x20))
#define	ECCSECTOR4          (*(volatile unsigned *)(NAND_BASEADDR+0x24))
#define	ECCSECTOR5          (*(volatile unsigned *)(NAND_BASEADDR+0x28))
#define	ECCSECTOR6          (*(volatile unsigned *)(NAND_BASEADDR+0x2c))
#define	ECCSECTOR7          (*(volatile unsigned *)(NAND_BASEADDR+0x30))
#define	ECCSECTOR8          (*(volatile unsigned *)(NAND_BASEADDR+0x34))
#define	ECCSECTOR9          (*(volatile unsigned *)(NAND_BASEADDR+0x38))
#define	ECCSECTOR10         (*(volatile unsigned *)(NAND_BASEADDR+0x3c))
#define	ECCSECTOR11         (*(volatile unsigned *)(NAND_BASEADDR+0x40))
#define	ECCSECTOR12         (*(volatile unsigned *)(NAND_BASEADDR+0x44))
#define	ECCSECTOR13         (*(volatile unsigned *)(NAND_BASEADDR+0x48))
#define	ECCSECTOR14         (*(volatile unsigned *)(NAND_BASEADDR+0x4c))
#define	ECCSECTOR15         (*(volatile unsigned *)(NAND_BASEADDR+0x50))
#define	SECCSECTOR0         (*(volatile unsigned *)(NAND_BASEADDR+0x54))
#define	SECCSECTOR1         (*(volatile unsigned *)(NAND_BASEADDR+0x58))
#define	SECCSECTOR2         (*(volatile unsigned *)(NAND_BASEADDR+0x5c))
#define	SECCSECTOR3         (*(volatile unsigned *)(NAND_BASEADDR+0x60))
#define	SECCSECTOR4         (*(volatile unsigned *)(NAND_BASEADDR+0x64))
#define	SECCSECTOR5         (*(volatile unsigned *)(NAND_BASEADDR+0x68))
#define	SECCSECTOR6         (*(volatile unsigned *)(NAND_BASEADDR+0x6c))
#define	SECCSECTOR7         (*(volatile unsigned *)(NAND_BASEADDR+0x70))
#define	SECCSECTOR8         (*(volatile unsigned *)(NAND_BASEADDR+0x74))
#define	SECCSECTOR9         (*(volatile unsigned *)(NAND_BASEADDR+0x78))
#define	SECCSECTOR10        (*(volatile unsigned *)(NAND_BASEADDR+0x7c))
#define	SECCSECTOR11        (*(volatile unsigned *)(NAND_BASEADDR+0x80))
#define	SECCSECTOR12        (*(volatile unsigned *)(NAND_BASEADDR+0x84))
#define	SECCSECTOR13        (*(volatile unsigned *)(NAND_BASEADDR+0x88))
#define	SECCSECTOR14        (*(volatile unsigned *)(NAND_BASEADDR+0x8c))
#define	SECCSECTOR15        (*(volatile unsigned *)(NAND_BASEADDR+0x90))
#define	ECCERR0             (*(volatile unsigned *)(NAND_BASEADDR+0x94))
#define	ECCERR1             (*(volatile unsigned *)(NAND_BASEADDR+0x98))
                                                                  
                                                                  
/*  Further work - Endian ordering  (2006/02/27)                  
// UART                                                           
#ifdef __BIG_ENDIAN
	#define rUTXH0		(*(volatile unsigned char *)0x1D00023)

#else //Little Endian
	#define rUTXH0		(*(volatile unsigned char *)0x1D00020)
#endif

// IIS
#ifdef __BIG_ENDIAN
#define rIISFIF		((volatile unsigned short *)0x1D18012)
#else //Little Endian
#define rIISFIF		((volatile unsigned short *)0x1D18010)
#endif

// RTC
#ifdef __BIG_ENDIAN
	#define rRTCCON		(*(volatile unsigned char *)0x1d70043)
 #else
	#define rRTCCON     (*(volatile unsigned char *)0x1d70040)
 #endif
*/

/*/////////////////////////////////////////////////////////
        REGISTER MASK DEFINITION
///////////////////////////////////////////////////////// */
/* E-DMA */
// DMASAdr
#define DMA_SRCADDR_MASK			(0xFFFFFFFF) << 0
// DMADAdr
#define DMA_DSTADDR_MASK			(0xFFFFFFFF) << 0

// DMACCon  
#define DMA_STARTINTEN_MASK		(0x01UL) << 31
#define DMA_ENDINTEN_MASK			(0x01UL) << 30 
#define DMA_M2M_MASK				(0x01UL) << 29
#define DMA_SRCINCR_MASK			(0x01UL) << 26
#define DMA_SRCWIDTH_MASK			(0x03UL) << 24
#define DMA_DSTINCR_MASK			(0x01UL) << 22
#define DMA_DSTWIDTH_MASK		(0x03UL) << 20
#define DMA_SIZE_MASK				(0x07UL) << 16
#define DMA_TXLENGTH_MASK			(0xFFFFUL) << 0
 
// DMACDescrp
#define DMA_DESCRADDR_MASK		(0xFFFFFFFFUL) << 2
#define DMA_DESCREND_MASK			(0x1UL) << 0
  
// DMACSta
#define DMA_ENABLE_MASK			(0x1UL) << 31
#define DMA_ACTIVE_MASK			(0x1UL) << 27
#define DMA_STOPINTEN_MASK		(0x1UL) << 4
#define DMA_STOPINT_MASK			(0x1UL) << 3
#define DMA_STARTINT_MASK			(0x1UL) << 2
#define DMA_ENDINT_MASK			(0x1UL) << 1
#define DMA_ERRORINT_MASK			(0x1UL) << 0

/* G-DMA */
// DMA2D_SIZE / DMA2D_CNT / DMA2D_ADDRUPD register
#define DMA2D_UPPER_MASK		(0xFFFFUL)<<16
#define DMA2D_LOWER_MASK		(0xFFFFUL)<<0
// DMA2D_STATUS register
#define DMA2D_EN_MASK			(0x1UL)<<31
#define DMA2D_ACTIVE_MASK		(0x1UL)<<27
#define DMA2D_STOPINTEN_MASK	(0x1UL)<<4
#define DMA2D_STOPINT_MASK	(0x1UL)<<1
#define DMA2D_ERRINT_MASK		(0x1UL)<<0


/* Internal flash*/
// FMUCON register
#define UCERSR_EN          	(0x1UL)<<0
#define USERSR_EN          	(0x1UL)<<1
#define UPGMR_EN           	(0x1UL)<<2
#define UCPUH_EN           	(0x1UL)<<3
#define UOPGMR_EN          	(0x1UL)<<5
#define USTRSTPT           	(0x1UL)<<6
#define UOSCEN_EN          	(0x1UL)<<7
#define WAIT_REG           	(0x3UL)<<8

#define FSO_MASK            (0xffffUL)<<0
#define FPO_MASK            (0xffffUL)<<0

#define FM_KEYVALUE     	(0x5a5a5a5a)<<0

#define FM_PROTECT_HW   	(0x1)<<17
#define FM_PROTECT_RD   	(0x1)<<27
#define PROTECTION_OPT  	0x0e3c
#define SMART_OPT           0x0e38


/* External sram */
// SMC_Bx_CON register
#define TAS_MASK		(0x7UL)<<17
#define TCSS_MASK		(0x7UL)<<14
#define TACC_MASK		(0xFUL)<<10
#define TCSH_MASK		(0x7UL)<<7
#define TAH_MASK		(0x7UL)<<4

#define WIDTH_MASK		(0x3UL)<<2
#define SHIFT_MASK		(0x3UL)<<0


/* External sdram */
#define TRC_MASK		(0xFUL)<<12
#define TRAS_MASK		(0xFUL)<<8
#define TCL_MASK		(0x7UL)<<4
#define TRCD_MASK		(0x3UL)<<2
#define TRP_MASK		(0x3UL)<<0

#define BIT16SEL_MASK		(0x1UL)<<7
#define COLADDRSIZ_MASK	(0x3UL)<<4
#define ADDRSWAPEN_MASK	(0x1UL)<<1
#define SDREN_MASK			(0x1UL)<<0

#define SEFLREFEN_MASK	(0x1UL)<<31
#define PWDNEN_MASK	(0x1UL)<<16
#define PWDNREF_MASK	(0xFFFFUL)<<0

#define REFNUM_MASK	(0xFUL)<<16
#define REFCOUNT_MASK	(0xFFFFUL)<<0


/* UART */
// UART_MASTER register
#define MASTER_EN_UART  		(0x1UL)	<<31
#define MASTER_EN_INT    		(0x1UL) <<30
#define MASTER_EN_RX_TIMEOUT	(0x1UL) <<29
#define MASTER_SW_RESET  		(0x1UL) <<28
#define MASTER_EN_DMA_REQ   	(0x1UL) <<27
#define MASTER_PARITY			(0x3UL) <<25
#define MASTER_DATA_BIT			(0x1UL) <<24
#define MASTER_STOP_BIT			(0x1UL) <<23
#define MASTER_EN_LOOPBACK		(0x1UL) <<22
#define MASTER_TX_WATER_LEV		(0x1FUL)<<8
#define MASTER_RX_WATER_LEV		(0x1FUL)<<0

// UART_STATUS register
#define STATUS_INTERRUPT		(0x1UL)	<<31
#define STATUS_MAX_FIFO_DEPTH	(0x7UL)	<<28
#define STATUS_TX_BUSY			(0x1UL)	<<27
#define STATUS_RX_BUSY			(0x1UL)	<<26
#define STATUS_PARITY_ERR		(0x1UL)	<<25
#define STATUS_FRAME_ERR		(0x1UL)	<<24
#define STATUS_OVERRUN_ERR		(0x1UL)	<<23
#define STATUS_RX_TIMEOUT		(0x1UL)	<<22
#define STATUS_TX_FIFO_DMA_REQ	(0x1UL)	<<14
#define STATUS_TX_FIFO_CNT		(0x3FUL)<<8
#define STATUS_RX_FIFO_DAM_REQ	(0x1UL)	<<6
#define STATUS_RX_FIFO_CNT		(0x3FUL)<<0

// UART_BRD register
#define UART_BAUDRATE_GEN	(0xFFFFUL)<<0

//UART_TX_FIFO_WRITE register
#define TX_FIFO_WRITE		(0xFF)<<0

//UART_RX_FIFO_READ register
#define RX_FIFO_READ		(0xFF)<<0

//UART_RX_TIME_OUT
#define RX_TIME_OUT			(0xFFFFFUL)<<0

/* I2C */
// Control register
#define TXPRE_MASK			(0x1FFUL)<<4
#define INTPEND_MASK		(0x1UL)<<3
#define OPERMODE_MASK		(0x1UL)<<2
#define ACKEN_MASK			(0x1UL)<<1
#define TXRXINTEN			(0x1UL)<<0

//Status register
#define OUTPUTEN_MASK		(0x1UL)<<5
#define START_MASK			(0x1UL)<<4
#define BUSBUSY_MASK		(0x1UL)<<3
#define ARBITSTA_MASK		(0x1UL)<<2
#define ACK_MASK			(0x1UL)<<1
#define BUSERROR_MASK		(0x1UL)<<0

// Data register
#define  DATA_MASK			(0xFFUL)<<0

/* Video Interface Controller */
// Control register
#define SWRST_MASK			(0x1UL)<<7
#define YCORDER_MASK		(0x3UL)<<4
#define STARTINTEN_MASK	(0x1UL)<<2
#define ENDINTEN_MASK		(0x1UL)<<1
#define DMAEN_MASK			(0x1UL)<<0

// Status register
#define STARTFRAME_MASK	(0x1UL)<<1
#define ENDFRAME_MASK		(0x1UL)<<0

// XY position, XY size register
#define X_MASK				(0x7FFUL)<<11
#define Y_MASK				(0x7FFUL)<<0


/* Timer & PWM */               
// Control register             
#define TIMER_PHASE_INVERT_SEL  (0x1UL)<<1
#define TIMER_IN_CLK_SEL        (0x1UL)<<2
#define TIMER_OP_MODE_SEL       (0x7UL)<<3
#define TIMER_CNT_CLR           (0x1UL)<<6
#define TIMER_EN                (0x1UL)<<7

#define TDAT_START       	(0x01FF8400)
#define TPRE_START       	(0x01FF8404)
#define TCON_START       	(0x01FF8408)
#define TCNT_START       	(0x01FF840C)
#define TPWM_START       	(0x01FF8410)


/* WDT */
// WDTCR register
#define WDT_DIV_SEL 		(0x3UL)<<4
#define WDT_CLKSEL  		(0x1UL)<<3
#define WDT_INTEN   		(0x1UL)<<2
#define WDT_RSTEN   		(0x1UL)<<1
#define WDT_EN      		(0x1UL)<<0

// WDTISR register
#define WDTISR_FLAG (0x1UL)<<0


/* GPIO */
#define GPIO_0  			(0x3UL)<<0
#define GPIO_1  			(0x3UL)<<2
#define GPIO_2  			(0x3UL)<<4
#define GPIO_3  			(0x3UL)<<6
#define GPIO_4  			(0x3UL)<<8
#define GPIO_5  			(0x3UL)<<10
#define GPIO_6  			(0x3UL)<<12
#define GPIO_7  			(0x3UL)<<14


/* Interrupt */
// INTCON register
#define INT_GIE_EN  		(0x1UL)<<3
#define INT_VECT_EN 		(0x1UL)<<2
#define INT_IRQ_EN  		(0x1UL)<<1
#define INT_FIQ_EN  		(0x1UL)<<0

#define IRQ_EINT0      		0
#define IRQ_EINT1      		1
#define IRQ_EINT2      		2
#define IRQ_EINT3      		3
#define IRQ_I2C0       		4
#define IRQ_I2C0_AAS   		5
#define IRQ_TIMER0_TOF 		6
#define IRQ_TIMER0_TMC 		7
#define IRQ_TIMER1_TOF 		8
#define IRQ_TIMER1_TMC 		9
                       		
#define IRQ_TIMER2_TOF 		10
#define IRQ_TIMER2_TMC 		11
#define IRQ_EINT4      		12
#define IRQ_EINT5      		13
#define IRQ_EINT6      		14
#define IRQ_EINT7      		15
#define IRQ_I2C1       		16
#define IRQ_I2C1_AAS   		17
#define IRQ_WDT        		18
#define IRQ_ADC        		19
                       		
#define IRQ_UARTRX     		20
#define IRQ_UARTTX     		21
#define IRQ_TIMER3_TOF 		22
#define IRQ_TIMER3_TMC 		23
#define IRQ_TIMER4_TOF 		24
#define IRQ_TIMER4_TMC 		25
#define IRQ_TIMER5_TOF 		26
#define IRQ_TIMER5_TMC 		27
#define IRQ_TIMER6_TOF 		28
#define IRQ_TIMER6_TMC 		29
                       		
#define IRQ_TIMER7_TOF 		30
#define IRQ_TIMER7_TMC 		31

// INTPNC & INTMOD & INTMASK register
#define INT_EINT0_MASK      	((0x1UL)<<IRQ_EINT0)
#define INT_EINT1_MASK      	((0x1UL)<<IRQ_EINT1)
#define INT_EINT2_MASK      	((0x1UL)<<IRQ_EINT2)
#define INT_EINT3_MASK      	((0x1UL)<<IRQ_EINT3)
#define INT_I2C0_MASK       	((0x1UL)<<IRQ_I2C0)
#define INT_I2C0_AAS_MASK   	((0x1UL)<<IRQ_I2C0_AAS)
#define INT_TIMER0_TOF_MASK 	((0x1UL)<<IRQ_TIMER0_TOF)
#define INT_TIMER0_TMC_MASK 	((0x1UL)<<IRQ_TIMER0_TMC)
#define INT_TIMER1_TOF_MASK 	((0x1UL)<<IRQ_TIMER1_TOF)
#define INT_TIMER1_TMC_MASK 	((0x1UL)<<IRQ_TIMER1_TMC)
                            	
#define INT_TIMER2_TOF_MASK 	((0x1UL)<<IRQ_TIMER2_TOF)
#define INT_TIMER2_TMC_MASK 	((0x1UL)<<IRQ_TIMER2_TMC)
#define INT_EINT4_MASK      	((0x1UL)<<IRQ_EINT4)
#define INT_EINT5_MASK      	((0x1UL)<<IRQ_EINT5)
#define INT_EINT6_MASK      	((0x1UL)<<IRQ_EINT6)
#define INT_EINT7_MASK      	((0x1UL)<<IRQ_EINT7)
#define INT_I2C1_MASK       	((0x1UL)<<IRQ_I2C1)
#define INT_I2C1_AAS_MASK   	((0x1UL)<<IRQ_I2C1_AAS)
#define INT_WDT_MASK        	((0x1UL)<<IRQ_WDT)
#define INT_ADC_MASK        	((0x1UL)<<IRQ_ADC)
                            	
#define INT_UARTRX_MASK     	((0x1UL)<<IRQ_UARTRX)
#define INT_UARTTX_MASK     	((0x1UL)<<IRQ_UARTTX)
#define INT_TIMER3_TOF_MASK 	((0x1UL)<<IRQ_TIMER3_TOF)
#define INT_TIMER3_TMC_MASK 	((0x1UL)<<IRQ_TIMER3_TMC)
#define INT_TIMER4_TOF_MASK 	((0x1UL)<<IRQ_TIMER4_TOF)
#define INT_TIMER4_TMC_MASK 	((0x1UL)<<IRQ_TIMER4_TMC)
#define INT_TIMER5_TOF_MASK 	((0x1UL)<<IRQ_TIMER5_TOF)
#define INT_TIMER5_TMC_MASK 	((0x1UL)<<IRQ_TIMER5_TMC)
#define INT_TIMER6_TOF_MASK 	((0x1UL)<<IRQ_TIMER6_TOF)
#define INT_TIMER6_TMC_MASK 	((0x1UL)<<IRQ_TIMER6_TMC)
                            	
#define INT_TIMER7_TOF_MASK 	((0x1UL)<<IRQ_TIMER7_TOF)
#define INT_TIMER7_TMC_MASK 	((0x1UL)<<IRQ_TIMER7_TMC)

// I_PSLV/F_PSLV & I_CSLV/F_CSLV register
#define INT_PRIORITY_SEL0   	(0x7UL)<<0
#define INT_PRIORITY_SEL1   	(0x7UL)<<3
#define INT_PRIORITY_SEL2   	(0x7UL)<<6
#define INT_PRIORITY_SEL3   	(0x7UL)<<9
#define INT_PRIORITY_SEL4   	(0x7UL)<<12
#define INT_PRIORITY_SEL5   	(0x7UL)<<15
#define INT_PRIORITY_SEL6   	(0x7UL)<<18
#define INT_PRIORITY_SEL7   	(0x7UL)<<21

// I_PMST / F_PMST register
#define INT_MASTER_MODE_SEL 	(0x1UL)<<12
#define INT_SLAVE_MODE_SEL  	(0xfUL)<<8
#define INT_SLV_PRIORITY_SEL    (0xffUL)<<0
#define INT_SLV0_PRIORITY       (0x3UL)<<0
#define INT_SLV1_PRIORITY       (0x3UL)<<2
#define INT_SLV2_PRIORITY       (0x3UL)<<4
#define INT_SLV3_PRIORITY       (0x3UL)<<6

// IRQ vector table
#define AddrEINT0        (*(smtUint32 *)(_ISR_STARTADDRESS+0x20))
#define AddrEINT1        (*(smtUint32 *)(_ISR_STARTADDRESS+0x24))
#define AddrEINT2        (*(smtUint32 *)(_ISR_STARTADDRESS+0x28))
#define AddrEINT3        (*(smtUint32 *)(_ISR_STARTADDRESS+0x2c))
#define AddrIIC0         (*(smtUint32 *)(_ISR_STARTADDRESS+0x30))
#define AddrIIC0_AAS     (*(smtUint32 *)(_ISR_STARTADDRESS+0x34))
#define AddrTIMER0_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x38))
#define AddrTIMER0_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x3c))
#define AddrTIMER1_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x40))
#define AddrTIMER1_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x44))
#define AddrTIMER2_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x48))
#define AddrTIMER2_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x4c))
#define AddrEINT4        (*(smtUint32 *)(_ISR_STARTADDRESS+0x50))
#define AddrEINT5        (*(smtUint32 *)(_ISR_STARTADDRESS+0x54))
#define AddrEINT6        (*(smtUint32 *)(_ISR_STARTADDRESS+0x58))
#define AddrEINT7        (*(smtUint32 *)(_ISR_STARTADDRESS+0x5c))
#define AddrIIC1         (*(smtUint32 *)(_ISR_STARTADDRESS+0x60))
#define AddrIIC1_AAS     (*(smtUint32 *)(_ISR_STARTADDRESS+0x64))
#define AddrWDT          (*(smtUint32 *)(_ISR_STARTADDRESS+0x68))
#define AddrADC          (*(smtUint32 *)(_ISR_STARTADDRESS+0x6c))
#define AddrUTX          (*(smtUint32 *)(_ISR_STARTADDRESS+0x70))
#define AddrURX          (*(smtUint32 *)(_ISR_STARTADDRESS+0x74))
#define AddrTIMER3_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x78))
#define AddrTIMER3_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x7c))
#define AddrTIMER4_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x80))
#define AddrTIMER4_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x84))
#define AddrTIMER5_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x88))
#define AddrTIMER5_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x8c))
#define AddrTIMER6_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x90))
#define AddrTIMER6_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x94))
#define AddrTIMER7_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x98))
#define AddrTIMER7_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x9c))


/* ADC */
// ADCCON register
#define ADENABLE    	(0x1UL)<<0
#define ADC_READ_START  (0x1UL)<<1
#define ADC_STBY    	(0x1UL)<<2
#define ADC_IN_SEL  	(0x7UL)<<3
#define ADC_FLAG    	(0x1UL)<<15


/* Power */
// PM_CLKCON register
#define PM_SLOW_EN			(0x1UL)<<2
#define PM_CPU_IDLE_EN		(0x1UL)<<1
#define PM_PWDN_EN			(0x1UL)<<0

// PM_CLKDIV register
#define PM_CCLK_DIV			(0x7UL)<<13
#define PM_BCLK_DIV			(0x1UL)<<12
#define PM_ACLK_DIV			(0x7UL)<<8
#define PM_UCLK_DIV			(0x3UL)<<4
#define PM_PCLK_DIV			(0x1UL)<<3
#define PM_SCLK_DIV			(0x7UL)<<0

// PM_SYSPLL register
#define PM_MPLL_PD			(0x1UL)<<16
#define PM_MPLL_FR			(0x3FUL)<<8
#define PM_MPLL_RR			(0xFUL)<<4
#define PM_MPLL_ODR		(0x1UL)<<0

// PM_USBPLL register
#define PM_UPLL_PD			(0x1UL)<<16
#define PM_UPLL_FR			(0x3FUL)<<8
#define PM_UPLL_RR			(0x1FUL)<<3
#define PM_UPLL_ODR			(0x3UL)<<0

// PM_RSTCON register
#define PM_PLL_LOCK			(0x1UL)<<16
#define PM_WAIT_LOCK_CNT	(0xFFFFUL)<<0

// I2S register


// NTSC PAL Video Encoder
#define VIDEOENC_BASEADDR		(APB0_STARTADDR+0x3000)
#define VIDEOENC_STATUS			(*(volatile unsigned *)(VIDEOENC_BASEADDR+0x000))
#define VIDEOENC_CONTROL		(*(volatile unsigned *)(VIDEOENC_BASEADDR+0x004))
#define VIDEOENC_INTERNAL		(*(volatile unsigned *)(VIDEOENC_BASEADDR+0x008))
#define VIDEOENC_SUBPHASE		(*(volatile unsigned *)(VIDEOENC_BASEADDR+0x00C))
#define VIDEOENC_SUBCARRIER (*(volatile unsigned *)(VIDEOENC_BASEADDR+0x010))


#ifdef __cplusplus
}
#endif
#endif /*__SDI_V5_H___*/
