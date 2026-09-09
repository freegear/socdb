/*----------------------------------------------------------
    File Name   : sysreg.h
    Description : Special function register definition using ARM7TDMI core
-----------------------------------------------------------*/

#ifndef __SDI_V5_H__
#define __SDI_V5_H__

#ifdef __cplusplus
extern "C" {
#endif

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "syscfg.h"

/*/////////////////////////////////////////////////////////
        REGISTER DEFINITION
///////////////////////////////////////////////////////// */
/* MAC */
//#define MAC_SLAVE0   (*(volatile unsigned *)(AHB0_STARTADDR))
//#define MAC_SLAVE1   (*(volatile unsigned *)(AHB1_STARTADDR))


/* PCI COFIGURATION */
#define PCI_MEMORY_ACCESS   (*(volatile unsigned *)(PCI_MEM_ADDR))
#define PCI_IO_ACCESS       (*(volatile unsigned *)(PCI_IO_ADDR))
#define PCI_CONFIG_ADDR     (*(volatile unsigned *)(PCI_CONF_ADDR))
#define PCI_CONFIG_DATA     (*(volatile unsigned *)(PCI_CONF_DATA))

/* External sram */
#define ESMC_BASEADDR		(APB0_STARTADDR+0x0000)
#define ESMC_B0_CON     	(*(volatile unsigned *)(ESMC_BASEADDR+0x00))
#define ESMC_B1_CON     	(*(volatile unsigned *)(ESMC_BASEADDR+0x04))
#define ESMC_B2_CON     	(*(volatile unsigned *)(ESMC_BASEADDR+0x08))
#define ESMC_B3_CON     	(*(volatile unsigned *)(ESMC_BASEADDR+0x0C))

/* DDRSDRAM Controller */
#define DDRCTL_BASEADDR		(APB0_STARTADDR+0x4000)
#define DDRTCON				(*(volatile unsigned *)(DDRCTL_BASEADDR+0x00))
#define DDRCON				(*(volatile unsigned *)(DDRCTL_BASEADDR+0x04))
#define DDRPCON				(*(volatile unsigned *)(DDRCTL_BASEADDR+0x08))
#define DDRREF				(*(volatile unsigned *)(DDRCTL_BASEADDR+0x0C))
#define DDRDLL				(*(volatile unsigned *)(DDRCTL_BASEADDR+0x10))

/* NAND Controller */
#define NFCTRL_BASEADDR     (APB0_STARTADDR+0x8000)
#define NFOPER              (*(volatile unsigned *)(NFCTRL_BASEADDR+0x00))
#define NFDATA              (*(volatile unsigned *)(NFCTRL_BASEADDR+0x04))
#define NFCONF              (*(volatile unsigned *)(NFCTRL_BASEADDR+0x08))
#define NFCTRL              (*(volatile unsigned *)(NFCTRL_BASEADDR+0x0c))
#define NFSTAT              (*(volatile unsigned *)(NFCTRL_BASEADDR+0x10))
#define NFFIFOSTAT          (*(volatile unsigned *)(NFCTRL_BASEADDR+0x14))
#define ECCSECTOR0          (*(volatile unsigned *)(NFCTRL_BASEADDR+0x18))
#define ECCSECTOR1          (*(volatile unsigned *)(NFCTRL_BASEADDR+0x1c))
#define ECCSECTOR2          (*(volatile unsigned *)(NFCTRL_BASEADDR+0x20))
#define ECCSECTOR3          (*(volatile unsigned *)(NFCTRL_BASEADDR+0x24))
#define ECCSECTOR4          (*(volatile unsigned *)(NFCTRL_BASEADDR+0x28))
#define ECCSECTOR5          (*(volatile unsigned *)(NFCTRL_BASEADDR+0x2c))
#define ECCSECTOR6          (*(volatile unsigned *)(NFCTRL_BASEADDR+0x30))
#define ECCSECTOR7          (*(volatile unsigned *)(NFCTRL_BASEADDR+0x34))
#define ECCSECTOR8          (*(volatile unsigned *)(NFCTRL_BASEADDR+0x38))
#define ECCSECTOR9          (*(volatile unsigned *)(NFCTRL_BASEADDR+0x3c))
#define ECCSECTOR10         (*(volatile unsigned *)(NFCTRL_BASEADDR+0x40))
#define ECCSECTOR11         (*(volatile unsigned *)(NFCTRL_BASEADDR+0x44))
#define ECCSECTOR12         (*(volatile unsigned *)(NFCTRL_BASEADDR+0x48))
#define ECCSECTOR13         (*(volatile unsigned *)(NFCTRL_BASEADDR+0x4c))
#define ECCSECTOR14         (*(volatile unsigned *)(NFCTRL_BASEADDR+0x50))
#define ECCSECTOR15         (*(volatile unsigned *)(NFCTRL_BASEADDR+0x54))
#define SECCSECTOR0         (*(volatile unsigned *)(NFCTRL_BASEADDR+0x58))
#define SECCSECTOR1         (*(volatile unsigned *)(NFCTRL_BASEADDR+0x5c))
#define SECCSECTOR2         (*(volatile unsigned *)(NFCTRL_BASEADDR+0x60))
#define SECCSECTOR3         (*(volatile unsigned *)(NFCTRL_BASEADDR+0x64))
#define SECCSECTOR4         (*(volatile unsigned *)(NFCTRL_BASEADDR+0x68))
#define SECCSECTOR5         (*(volatile unsigned *)(NFCTRL_BASEADDR+0x6c))
#define SECCSECTOR6         (*(volatile unsigned *)(NFCTRL_BASEADDR+0x70))
#define SECCSECTOR7         (*(volatile unsigned *)(NFCTRL_BASEADDR+0x74))

/* DMA Controller */
#define	DMAC_BASEADDR		(APB0_STARTADDR+0xC000)
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

/* 2D DMA Controller */
#define DMA2D_BASEADDR			(APB0_STARTADDR+0x10000)
#define DMA2D_SRCADDR		(*(volatile unsigned *)(DMA2D_BASEADDR+0x00))
#define DMA2D_DSTADDR		(*(volatile unsigned *)(DMA2D_BASEADDR+0x04))
#define DMA2D_SIZE			(*(volatile unsigned *)(DMA2D_BASEADDR+0x08))
#define DMA2D_CNT			(*(volatile unsigned *)(DMA2D_BASEADDR+0x0C))
#define DMA2D_ADDRUPD		(*(volatile unsigned *)(DMA2D_BASEADDR+0x10))
#define DMA2D_STATUS		(*(volatile unsigned *)(DMA2D_BASEADDR+0x14))

/* DM(Display Module) */
#define DM_BASEADDR			(APB1_STARTADDR+0xA000)
#define DMCON				(*(volatile unsigned *)(DM_BASEADDR+0x000))
#define DMSTS				(*(volatile unsigned *)(DM_BASEADDR+0x004))

#define CCON				(*(volatile unsigned *)(DM_BASEADDR+0x010))
#define CBLND				(*(volatile unsigned *)(DM_BASEADDR+0x014))
#define CBMOD				(*(volatile unsigned *)(DM_BASEADDR+0x018))
#define CBASE				(*(volatile unsigned *)(DM_BASEADDR+0x01c))

#define CADDR				(*(volatile unsigned *)(DM_BASEADDR+0x020))
#define CPALM				(*(volatile unsigned *)(DM_BASEADDR+0x024))
#define CADDR2				(*(volatile unsigned *)(DM_BASEADDR+0x028))
#define CBLINK				(*(volatile unsigned *)(DM_BASEADDR+0x02C))

#define BGCOL				(*(volatile unsigned *)(DM_BASEADDR+0x030))

#define GCON				(*(volatile unsigned *)(DM_BASEADDR+0x040))
#define GBLND				(*(volatile unsigned *)(DM_BASEADDR+0x044))
#define GBMOD				(*(volatile unsigned *)(DM_BASEADDR+0x048))
#define GBASE				(*(volatile unsigned *)(DM_BASEADDR+0x04c))

#define GADDR				(*(volatile unsigned *)(DM_BASEADDR+0x050))
#define GPALM				(*(volatile unsigned *)(DM_BASEADDR+0x054))

#define VCON				(*(volatile unsigned *)(DM_BASEADDR+0x060))
#define VBLND				(*(volatile unsigned *)(DM_BASEADDR+0x064))
#define VBMOD				(*(volatile unsigned *)(DM_BASEADDR+0x068))
#define VBASE				(*(volatile unsigned *)(DM_BASEADDR+0x06c))
#define VADDR				(*(volatile unsigned *)(DM_BASEADDR+0x070))
#define VADDR2				(*(volatile unsigned *)(DM_BASEADDR+0x074))
#define VADDR20				(*(volatile unsigned *)(DM_BASEADDR+0x078))

#define SCON				(*(volatile unsigned *)(DM_BASEADDR+0x080))
#define SSIZE				(*(volatile unsigned *)(DM_BASEADDR+0x084))
#define SRATIO				(*(volatile unsigned *)(DM_BASEADDR+0x088))

#define LCDCON				(*(volatile unsigned *)(DM_BASEADDR+0x0E0))
#define VIDCON				(*(volatile unsigned *)(DM_BASEADDR+0x0E4))
#define HSYNC0				(*(volatile unsigned *)(DM_BASEADDR+0x0F0))
#define HSYNC1				(*(volatile unsigned *)(DM_BASEADDR+0x0F4))
#define VSYNC0				(*(volatile unsigned *)(DM_BASEADDR+0x0F8))
#define VSYNC1				(*(volatile unsigned *)(DM_BASEADDR+0x0FC))

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
#define VGAMMA00			(*(volatile unsigned *)(DM_BASEADDR+0x100))
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

/* Video Encoder */
#define VIDEOENC_BASEADDR   (APB1_STARTADDR+0xB000)
#define VIDEOENC_STATUS     (*(volatile unsigned *)(VIDEOENC_BASEADDR+0x00))
#define VIDEOENC_CONTROL    (*(volatile unsigned *)(VIDEOENC_BASEADDR+0x04))
#define VIDEOENC_INTERNAL   (*(volatile unsigned *)(VIDEOENC_BASEADDR+0x08))
#define VIDEOENC_SUBPHASE   (*(volatile unsigned *)(VIDEOENC_BASEADDR+0x0C))
#define VIDEOENC_SUBCARRIER (*(volatile unsigned *)(VIDEOENC_BASEADDR+0x10))


/* UART */
#define UART_BASEADDR		(APB1_STARTADDR+0x5000)
#define UART0_CMD			(*(volatile unsigned *)(UART_BASEADDR+0x00))
#define UART0_SR			(*(volatile unsigned *)(UART_BASEADDR+0x04))
#define UART0_BRD			(*(volatile unsigned *)(UART_BASEADDR+0x08))
#define UART0_TX			(*(volatile unsigned *)(UART_BASEADDR+0x0C))
#define UART0_RX			(*(volatile unsigned *)(UART_BASEADDR+0x10))
#define UART0_TIMEOUT		(*(volatile unsigned *)(UART_BASEADDR+0x14))
#define UART1_CMD			(*(volatile unsigned *)(UART_BASEADDR+0x20))
#define UART1_SR			(*(volatile unsigned *)(UART_BASEADDR+0x24))
#define UART1_BRD			(*(volatile unsigned *)(UART_BASEADDR+0x28))
#define UART1_TX			(*(volatile unsigned *)(UART_BASEADDR+0x2C))
#define UART1_RX			(*(volatile unsigned *)(UART_BASEADDR+0x30))
#define UART1_TIMEOUT		(*(volatile unsigned *)(UART_BASEADDR+0x34))
#define UART2_CMD			(*(volatile unsigned *)(UART_BASEADDR+0x40))
#define UART2_SR			(*(volatile unsigned *)(UART_BASEADDR+0x44))
#define UART2_BRD			(*(volatile unsigned *)(UART_BASEADDR+0x48))
#define UART2_TX			(*(volatile unsigned *)(UART_BASEADDR+0x4C))
#define UART2_RX			(*(volatile unsigned *)(UART_BASEADDR+0x50))
#define UART2_TIMEOUT		(*(volatile unsigned *)(UART_BASEADDR+0x54))
#define UART3_CMD			(*(volatile unsigned *)(UART_BASEADDR+0x60))
#define UART3_SR			(*(volatile unsigned *)(UART_BASEADDR+0x64))
#define UART3_BRD			(*(volatile unsigned *)(UART_BASEADDR+0x68))
#define UART3_TX			(*(volatile unsigned *)(UART_BASEADDR+0x6C))
#define UART3_RX			(*(volatile unsigned *)(UART_BASEADDR+0x70))
#define UART3_TIMEOUT		(*(volatile unsigned *)(UART_BASEADDR+0x74))

/* IIC0 */
#define I2C_BASEADDR		(APB1_STARTADDR+0x7000)
#define ICCR0_0             (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define ICSR0               (*(volatile unsigned *)(I2C_BASEADDR+0x04))
#define IAR0                (*(volatile unsigned *)(I2C_BASEADDR+0x08))
#define IDSR0               (*(volatile unsigned *)(I2C_BASEADDR+0x0C))
#define ICCR0_1             (*(volatile unsigned *)(I2C_BASEADDR+0x10))
#define I2C0_SRST        	(*(volatile unsigned *)(I2C_BASEADDR+0x14))
#define I2CCON              (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define I2CSTA              (*(volatile unsigned *)(I2C_BASEADDR+0x04))
#define I2CDATA             (*(volatile unsigned *)(I2C_BASEADDR+0x08))

/* IIC1 */
#define ICCR1_0             (*(volatile unsigned *)(I2C_BASEADDR+0x80))
#define ICSR1               (*(volatile unsigned *)(I2C_BASEADDR+0x84))
#define IAR1                (*(volatile unsigned *)(I2C_BASEADDR+0x88))
#define IDSR1               (*(volatile unsigned *)(I2C_BASEADDR+0x8C))
#define ICCR1_1             (*(volatile unsigned *)(I2C_BASEADDR+0x90))
#define I2C1_SRST        	(*(volatile unsigned *)(I2C_BASEADDR+0x94))

/* Timer */
#define TIMER_BASEADDR		(APB1_STARTADDR+0x0000)
#define TIMER0_DAT          (*(volatile unsigned *)(TIMER_BASEADDR+0x00))
#define TIMER0_PRE          (*(volatile unsigned *)(TIMER_BASEADDR+0x04))
#define TIMER0_CON          (*(volatile unsigned *)(TIMER_BASEADDR+0x08))
#define TIMER0_CNT          (*(volatile unsigned *)(TIMER_BASEADDR+0x0C))
#define TIMER1_DAT          (*(volatile unsigned *)(TIMER_BASEADDR+0x10))
#define TIMER1_PRE          (*(volatile unsigned *)(TIMER_BASEADDR+0x14))
#define TIMER1_CON          (*(volatile unsigned *)(TIMER_BASEADDR+0x18))
#define TIMER1_CNT          (*(volatile unsigned *)(TIMER_BASEADDR+0x1C))
#define TIMER2_DAT          (*(volatile unsigned *)(TIMER_BASEADDR+0x20))
#define TIMER2_PRE          (*(volatile unsigned *)(TIMER_BASEADDR+0x24))
#define TIMER2_CON          (*(volatile unsigned *)(TIMER_BASEADDR+0x28))
#define TIMER2_CNT          (*(volatile unsigned *)(TIMER_BASEADDR+0x2C))
#define TIMER3_DAT          (*(volatile unsigned *)(TIMER_BASEADDR+0x30))
#define TIMER3_PRE          (*(volatile unsigned *)(TIMER_BASEADDR+0x34))
#define TIMER3_CON          (*(volatile unsigned *)(TIMER_BASEADDR+0x38))
#define TIMER3_CNT          (*(volatile unsigned *)(TIMER_BASEADDR+0x3C))

/* WDT */
#define WDT_BASEADDR		(APB1_STARTADDR+0x1000)
#define WDTCON              (*(volatile unsigned *)(WDT_BASEADDR+0x00))
#define WDTPSR              (*(volatile unsigned *)(WDT_BASEADDR+0x04))
#define WDTLDR              (*(volatile unsigned *)(WDT_BASEADDR+0x08))
#define WDTCNT              (*(volatile unsigned *)(WDT_BASEADDR+0x0C))
#define WDTISR              (*(volatile unsigned *)(WDT_BASEADDR+0x10))

/* GPIO */              	
#define GPIO_BASEADDR		(APB1_STARTADDR+0x2000)
#define GPIO0_OE       		(*(volatile unsigned *)(GPIO_BASEADDR+0x00))
#define GPIO0_IN      		(*(volatile unsigned *)(GPIO_BASEADDR+0x04))
#define GPIO0_OUT      		(*(volatile unsigned *)(GPIO_BASEADDR+0x08))
#define GPIO0_INTSTAT  		(*(volatile unsigned *)(GPIO_BASEADDR+0x0C))
#define GPIO0_INTEN  		(*(volatile unsigned *)(GPIO_BASEADDR+0x10))
#define GPIO0_INTLEVEL 		(*(volatile unsigned *)(GPIO_BASEADDR+0x14))
#define GPIO0_INTPOL   		(*(volatile unsigned *)(GPIO_BASEADDR+0x18))
#define GPIO0_INTBEDGE 		(*(volatile unsigned *)(GPIO_BASEADDR+0x1C))
#define GPIO1_OE       		(*(volatile unsigned *)(GPIO_BASEADDR+0x20))
#define GPIO1_IN      		(*(volatile unsigned *)(GPIO_BASEADDR+0x24))
#define GPIO1_OUT      		(*(volatile unsigned *)(GPIO_BASEADDR+0x28))
#define GPIO1_INTSTAT  		(*(volatile unsigned *)(GPIO_BASEADDR+0x2C))
#define GPIO1_INTMASK  		(*(volatile unsigned *)(GPIO_BASEADDR+0x30))
#define GPIO1_INTLEVEL 		(*(volatile unsigned *)(GPIO_BASEADDR+0x34))
#define GPIO1_INTPOL   		(*(volatile unsigned *)(GPIO_BASEADDR+0x38))
#define GPIO1_INTBEDGE 		(*(volatile unsigned *)(GPIO_BASEADDR+0x3C))

/* Interrupt */
#define VIC_BASEADDR		(APB0_STARTADDR+0x14000)
#define INTCON              (*(volatile unsigned *)(VIC_BASEADDR+0x00))
#define INTPND              (*(volatile unsigned *)(VIC_BASEADDR+0x04))
#define INTMOD              (*(volatile unsigned *)(VIC_BASEADDR+0x08))
#define INTMSK              (*(volatile unsigned *)(VIC_BASEADDR+0x0C))
#define LEVEL               (*(volatile unsigned *)(VIC_BASEADDR+0x10))
#define I_PSLV0             (*(volatile unsigned *)(VIC_BASEADDR+0x14))
#define I_PSLV1             (*(volatile unsigned *)(VIC_BASEADDR+0x18))
#define I_PSLV2             (*(volatile unsigned *)(VIC_BASEADDR+0x1C))
#define I_PSLV3             (*(volatile unsigned *)(VIC_BASEADDR+0x20))
#define F_PSLV0             (*(volatile unsigned *)(VIC_BASEADDR+0x44))
#define F_PSLV1             (*(volatile unsigned *)(VIC_BASEADDR+0x48))
#define F_PSLV2             (*(volatile unsigned *)(VIC_BASEADDR+0x4C))
#define F_PSLV3             (*(volatile unsigned *)(VIC_BASEADDR+0x50))
#define I_PMST              (*(volatile unsigned *)(VIC_BASEADDR+0x24))
#define F_PMST              (*(volatile unsigned *)(VIC_BASEADDR+0x54))
#define ICSLV0              (*(volatile unsigned *)(VIC_BASEADDR+0x28))
#define ICSLV1              (*(volatile unsigned *)(VIC_BASEADDR+0x2C))
#define ICSLV2              (*(volatile unsigned *)(VIC_BASEADDR+0x30))
#define ICSLV3              (*(volatile unsigned *)(VIC_BASEADDR+0x34))
#define F_CSLV0             (*(volatile unsigned *)(VIC_BASEADDR+0x58))
#define F_CSLV1             (*(volatile unsigned *)(VIC_BASEADDR+0x5C))
#define F_CSLV2             (*(volatile unsigned *)(VIC_BASEADDR+0x60))
#define F_CSLV3             (*(volatile unsigned *)(VIC_BASEADDR+0x64))
#define I_CMST              (*(volatile unsigned *)(VIC_BASEADDR+0x38))
#define F_CMST              (*(volatile unsigned *)(VIC_BASEADDR+0x68))
#define I_ISPR              (*(volatile unsigned *)(VIC_BASEADDR+0x3C))
#define F_ISPR              (*(volatile unsigned *)(VIC_BASEADDR+0x6C))
#define I_ISPC              (*(volatile unsigned *)(VIC_BASEADDR+0x40))
#define F_ISPC              (*(volatile unsigned *)(VIC_BASEADDR+0x70))
#define POLARITY            (*(volatile unsigned *)(VIC_BASEADDR+0x74))
#define I_VECADDR       	(*(volatile unsigned *)(VIC_BASEADDR+0x78))
#define F_VECADDR       	(*(volatile unsigned *)(VIC_BASEADDR+0x7C))

/* SD/MMC Controller */
#define	MMC_BASEADDR		(APB1_STARTADDR+0xD000)
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

/* VIF(Video Input Processor) */
#define VIF_BASEADDR		(APB1_STARTADDR+0xC000)
#define VIFCON				(*(volatile unsigned *)(VIF_BASEADDR+0x00))
#define VIFSTS				(*(volatile unsigned *)(VIF_BASEADDR+0x04))
#define VIFPOS				(*(volatile unsigned *)(VIF_BASEADDR+0x08))
#define VIFSIZ				(*(volatile unsigned *)(VIF_BASEADDR+0x0C))
#define VIFADDR				(*(volatile unsigned *)(VIF_BASEADDR+0x10))

/* I2S Controller */
#define	I2S_BASEADDR		(APB1_STARTADDR+0x6000)
#define I2S_CLKCTRL			(*(volatile unsigned *)(I2S_BASEADDR+0x00))
#define I2S_CTRL			(*(volatile unsigned *)(I2S_BASEADDR+0x04))
#define I2S_STATUS			(*(volatile unsigned *)(I2S_BASEADDR+0x08))
#define I2S_DATA			(*(volatile unsigned *)(I2S_BASEADDR+0x0C))

/* Resource Share Controller */
#define	RS_BASEADDR			(APB1_STARTADDR+0x4000)
#define RS_SEIPMUX			(*(volatile unsigned *)(RS_BASEADDR+0x00))
#define RS_DMAMUX			(*(volatile unsigned *)(RS_BASEADDR+0x04))

/* SEIP */
#define SEIP_BASEADDR		(APB0_STARTADDR+0x18000)
#define SEIP_RXCON			(*(volatile unsigned *)(SEIP_BASEADDR+0x2000))
#define SEIP_RXSTS			(*(volatile unsigned *)(SEIP_BASEADDR+0x2004))
#define SEIP_RXDAT			(*(volatile unsigned *)(SEIP_BASEADDR+0x2008))
#define SEIP_TXCON			(*(volatile unsigned *)(SEIP_BASEADDR+0x2010))
#define SEIP_TXSTS			(*(volatile unsigned *)(SEIP_BASEADDR+0x2014))
#define SEIP_TXDAT			(*(volatile unsigned *)(SEIP_BASEADDR+0x2018))
#define SEIP_RST			(*(volatile unsigned *)(SEIP_BASEADDR+0x2020))

/* PSRAM Ctrl */
#define PSRAMCTRL_BASEADDR		(APB1_STARTADDR+0x9000)
#define PSRAMCON			(*(volatile unsigned *)(PSRAMCTRL_BASEADDR+0x00))
#define PSRAMTCON			(*(volatile unsigned *)(PSRAMCTRL_BASEADDR+0x04))
#define PSRAMTOUT			(*(volatile unsigned *)(PSRAMCTRL_BASEADDR+0x08))

/* MAC SLAV0 */
#define MACS0_0             (*(volatile unsigned *)(AHB0_STARTADDR+0x00))
#define MACS0_1             (*(volatile unsigned *)(AHB0_STARTADDR+0x04))
#define MACS0_2             (*(volatile unsigned *)(AHB0_STARTADDR+0x08))
  
/* MAC SLAV1 */
#define MACS1_0             (*(volatile unsigned *)(AHB1_STARTADDR+0x00))
#define MACS1_1             (*(volatile unsigned *)(AHB1_STARTADDR+0x04))
#define MACS1_2             (*(volatile unsigned *)(AHB1_STARTADDR+0x08))

/* PCI SLAV1 */
#define PCI0                (*(volatile unsigned *)(AHB2_STARTADDR+0x00))
#define PCI1                (*(volatile unsigned *)(AHB2_STARTADDR+0x04))
#define PCI2                (*(volatile unsigned *)(AHB2_STARTADDR+0x08))




/*/////////////////////////////////////////////////////////
        REGISTER MASK DEFINITION
///////////////////////////////////////////////////////// */

/* External sram */
// SMC_Bx_CON register
#define TACSR_MASK          (0x3UL)<<26
#define TCOSR_MASK          (0x3UL)<<24
#define TACCR_MASK          (0xfUL)<<20
#define TCOHR_MASK          (0x3UL)<<18

#define TACSW_MASK          (0x3UL)<<10
#define TCOSW_MASK          (0x3UL)<<8
#define TACCW_MASK          (0xfUL)<<4
#define TCOHW_MASK          (0x3UL)<<2

#define SHIFT_MASK          (0x1UL)<<1
#define WIDTH_MASK          (0x1UL)<<0


/* Interrupt */
// INTCON register
#define INT_GIE_EN  		(0x1UL)<<3
#define INT_VECT_EN 		(0x1UL)<<2
#define INT_IRQ_EN  		(0x1UL)<<1
#define INT_FIQ_EN  		(0x1UL)<<0

#define IRQ_DMA0      		0
#define IRQ_DMA1      		1
#define IRQ_DMA2      		2
#define IRQ_DMA3      		3
#define IRQ_DMA4      		4
#define IRQ_DMA5      		5
#define IRQ_DMA6      		6
#define IRQ_DMA7      		7
#define IRQ_UART0      		8
#define IRQ_UART1      		9
#define IRQ_UART2      		10
#define IRQ_UART3      		11
#define IRQ_TIMER0     		12
#define IRQ_TIMER1     		13
#define IRQ_TIMER2     		14
#define IRQ_TIMER3     		15
#define IRQ_WDT     		16
#define IRQ_DMA2D     		17
#define IRQ_DM 	    		18
#define IRQ_VIF	    		19
#define IRQ_I2C	    		20
#define IRQ_I2S	    		21
//#define IRQ_NAND    		22
#define IRQ_GPIO0    		23
#define IRQ_GPIO1    		24
#define IRQ_NAND    		27
#define IRQ_MMC	    		31

// INTPNC & INTMOD & INTMASK register
#define INT_MASK(x)				((0x1UL)<<(x))

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

#ifdef __cplusplus
}
#endif
#endif /*__SDI_V5_H___*/
