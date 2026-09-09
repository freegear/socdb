/*------------------------------------------------------------------------------
    File Name   : sysreg.h
    Description : Special function register definition using ARM7TDMI core
------------------------------------------------------------------------------*/

#ifndef __SDI_V5_H__
#define __SDI_V5_H__

#ifdef __cplusplus
extern "C" {
#endif

/*
//////////////////////////////////////////////////////////////////////////////
//	INCLUDE
//////////////////////////////////////////////////////////////////////////////
*/
#include "syscfg.h"

/*
//////////////////////////////////////////////////////////////////////////////
/	REGISTER DEFINITION
//////////////////////////////////////////////////////////////////////////////
*/

/* DDRSDRAM Controller */
#define DDRCTL_BASEADDR	(APB0_STARTADDR+0x4000)
#define DDRTCON				(*(volatile unsigned *)(DDRCTL_BASEADDR+0x00))
#define DDRCON				(*(volatile unsigned *)(DDRCTL_BASEADDR+0x04))
#define DDRPCON				(*(volatile unsigned *)(DDRCTL_BASEADDR+0x08))
#define DDRREF				(*(volatile unsigned *)(DDRCTL_BASEADDR+0x0C))
#define DDRDLL				(*(volatile unsigned *)(DDRCTL_BASEADDR+0x10))

/* NAND Controller */
#define	NAND_BASEADDR	(APB0_STARTADDR+0x8000)
#define	NANDNFOPER		(*(volatile unsigned *)(NAND_BASEADDR+0x00))
#define	NANDDATA            	(*(volatile unsigned *)(NAND_BASEADDR+0x04))
#define	NANDCONF			(*(volatile unsigned *)(NAND_BASEADDR+0x08))
#define	NANDCTRL            	(*(volatile unsigned *)(NAND_BASEADDR+0x0C))
#define	NANDSTAT            	(*(volatile unsigned *)(NAND_BASEADDR+0x10))
#define	NANDFIFOSTAT		(*(volatile unsigned *)(NAND_BASEADDR+0x14))

#define	ECCSECTOR0			(*(volatile unsigned *)(NAND_BASEADDR+0x18))
#define	ECCSECTOR1			(*(volatile unsigned *)(NAND_BASEADDR+0x1c))
#define	ECCSECTOR2			(*(volatile unsigned *)(NAND_BASEADDR+0x20))
#define	ECCSECTOR3			(*(volatile unsigned *)(NAND_BASEADDR+0x24))
#define	ECCSECTOR4			(*(volatile unsigned *)(NAND_BASEADDR+0x28))
#define	ECCSECTOR5			(*(volatile unsigned *)(NAND_BASEADDR+0x2c))
#define	ECCSECTOR6			(*(volatile unsigned *)(NAND_BASEADDR+0x30))
#define	ECCSECTOR7			(*(volatile unsigned *)(NAND_BASEADDR+0x34))
#define	ECCSECTOR8			(*(volatile unsigned *)(NAND_BASEADDR+0x38))
#define	ECCSECTOR9			(*(volatile unsigned *)(NAND_BASEADDR+0x3c))
#define	ECCSECTOR10		(*(volatile unsigned *)(NAND_BASEADDR+0x40))
#define	ECCSECTOR11		(*(volatile unsigned *)(NAND_BASEADDR+0x44))
#define	ECCSECTOR12		(*(volatile unsigned *)(NAND_BASEADDR+0x48))
#define	ECCSECTOR13		(*(volatile unsigned *)(NAND_BASEADDR+0x4c))
#define	ECCSECTOR14		(*(volatile unsigned *)(NAND_BASEADDR+0x50))
#define	ECCSECTOR15		(*(volatile unsigned *)(NAND_BASEADDR+0x54))

#define	SECCSECTOR0		(*(volatile unsigned *)(NAND_BASEADDR+0x58))
#define	SECCSECTOR1		(*(volatile unsigned *)(NAND_BASEADDR+0x5c))
#define	SECCSECTOR2		(*(volatile unsigned *)(NAND_BASEADDR+0x60))
#define	SECCSECTOR3		(*(volatile unsigned *)(NAND_BASEADDR+0x64))
#define	SECCSECTOR4		(*(volatile unsigned *)(NAND_BASEADDR+0x68))
#define	SECCSECTOR5		(*(volatile unsigned *)(NAND_BASEADDR+0x6c))
#define	SECCSECTOR6		(*(volatile unsigned *)(NAND_BASEADDR+0x70))
#define	SECCSECTOR7		(*(volatile unsigned *)(NAND_BASEADDR+0x74))

/* DMA Controller */
#define DMAC_BASEADDR		(APB0_STARTADDR+0xC000)
#define DMACSADR0			(*(volatile unsigned *)(DMAC_BASEADDR+0x00))
#define DMACDADR0			(*(volatile unsigned *)(DMAC_BASEADDR+0x04))
#define DMACCON0			(*(volatile unsigned *)(DMAC_BASEADDR+0x08))
#define DMACDESCRP0		(*(volatile unsigned *)(DMAC_BASEADDR+0x0C))
#define DMACSTA0			(*(volatile unsigned *)(DMAC_BASEADDR+0x10))
#define DMACSADR1			(*(volatile unsigned *)(DMAC_BASEADDR+0x20))
#define DMACDADR1			(*(volatile unsigned *)(DMAC_BASEADDR+0x24))
#define DMACCON1			(*(volatile unsigned *)(DMAC_BASEADDR+0x28))
#define DMACDESCRP1		(*(volatile unsigned *)(DMAC_BASEADDR+0x2C))
#define DMACSTA1			(*(volatile unsigned *)(DMAC_BASEADDR+0x30))
#define DMACSADR2			(*(volatile unsigned *)(DMAC_BASEADDR+0x40))
#define DMACDADR2			(*(volatile unsigned *)(DMAC_BASEADDR+0x44))
#define DMACCON2			(*(volatile unsigned *)(DMAC_BASEADDR+0x48))
#define DMACDESCRP2		(*(volatile unsigned *)(DMAC_BASEADDR+0x4C))
#define DMACSTA2			(*(volatile unsigned *)(DMAC_BASEADDR+0x50))
#define DMACSADR3			(*(volatile unsigned *)(DMAC_BASEADDR+0x60))
#define DMACDADR3			(*(volatile unsigned *)(DMAC_BASEADDR+0x64))
#define DMACCON3			(*(volatile unsigned *)(DMAC_BASEADDR+0x68))
#define DMACDESCRP3		(*(volatile unsigned *)(DMAC_BASEADDR+0x6C))
#define DMACSTA3			(*(volatile unsigned *)(DMAC_BASEADDR+0x70))
#define DMACSADR4			(*(volatile unsigned *)(DMAC_BASEADDR+0x80))
#define DMACDADR4			(*(volatile unsigned *)(DMAC_BASEADDR+0x84))
#define DMACCON4			(*(volatile unsigned *)(DMAC_BASEADDR+0x88))
#define DMACDESCRP4		(*(volatile unsigned *)(DMAC_BASEADDR+0x8C))
#define DMACSTA4			(*(volatile unsigned *)(DMAC_BASEADDR+0x90))
#define DMACSADR5			(*(volatile unsigned *)(DMAC_BASEADDR+0xA0))
#define DMACDADR5			(*(volatile unsigned *)(DMAC_BASEADDR+0xA4))
#define DMACCON5			(*(volatile unsigned *)(DMAC_BASEADDR+0xA8))
#define DMACDESCRP5		(*(volatile unsigned *)(DMAC_BASEADDR+0xAC))
#define DMACSTA5			(*(volatile unsigned *)(DMAC_BASEADDR+0xB0))
#define DMACSADR6			(*(volatile unsigned *)(DMAC_BASEADDR+0xC0))
#define DMACDADR6			(*(volatile unsigned *)(DMAC_BASEADDR+0xC4))
#define DMACCON6			(*(volatile unsigned *)(DMAC_BASEADDR+0xC8))
#define DMACDESCRP6		(*(volatile unsigned *)(DMAC_BASEADDR+0xCC))
#define DMACSTA6			(*(volatile unsigned *)(DMAC_BASEADDR+0xD0))
#define DMACSADR7			(*(volatile unsigned *)(DMAC_BASEADDR+0xE0))
#define DMACDADR7			(*(volatile unsigned *)(DMAC_BASEADDR+0xE4))
#define DMACCON7			(*(volatile unsigned *)(DMAC_BASEADDR+0xE8))
#define DMACDESCRP7		(*(volatile unsigned *)(DMAC_BASEADDR+0xEC))
#define DMACSTA7			(*(volatile unsigned *)(DMAC_BASEADDR+0xF0))
#define DMACSAdr(x)			(*(volatile unsigned *)(DMAC_BASEADDR+0x00+(x*0x20)))
#define DMACDAdr(x)			(*(volatile unsigned *)(DMAC_BASEADDR+0x04+(x*0x20)))
#define DMACCon(x)			(*(volatile unsigned *)(DMAC_BASEADDR+0x08+(x*0x20)))
#define DMACDescrp(x)		(*(volatile unsigned *)(DMAC_BASEADDR+0x0C+(x*0x20)))
#define DMACSta(x)			(*(volatile unsigned *)(DMAC_BASEADDR+0x10+(x*0x20)))

/* Interrupt */
#define VIC_BASEADDR		(APB0_STARTADDR+0x14000)
#define INTCON				(*(volatile unsigned *)(VIC_BASEADDR+0x00))
#define INTPND				(*(volatile unsigned *)(VIC_BASEADDR+0x04))
#define INTMOD				(*(volatile unsigned *)(VIC_BASEADDR+0x08))
#define INTMSK				(*(volatile unsigned *)(VIC_BASEADDR+0x0C))
#define LEVEL 				(*(volatile unsigned *)(VIC_BASEADDR+0x10))
#define I_PSLV0				(*(volatile unsigned *)(VIC_BASEADDR+0x14))
#define I_PSLV1				(*(volatile unsigned *)(VIC_BASEADDR+0x18))
#define I_PSLV2				(*(volatile unsigned *)(VIC_BASEADDR+0x1C))
#define I_PSLV3				(*(volatile unsigned *)(VIC_BASEADDR+0x20))
#define F_PSLV0				(*(volatile unsigned *)(VIC_BASEADDR+0x44))
#define F_PSLV1				(*(volatile unsigned *)(VIC_BASEADDR+0x48))
#define F_PSLV2				(*(volatile unsigned *)(VIC_BASEADDR+0x4C))
#define F_PSLV3				(*(volatile unsigned *)(VIC_BASEADDR+0x50))
#define I_PMST				(*(volatile unsigned *)(VIC_BASEADDR+0x24))
#define F_PMST				(*(volatile unsigned *)(VIC_BASEADDR+0x54))
#define ICSLV0				(*(volatile unsigned *)(VIC_BASEADDR+0x28))
#define ICSLV1				(*(volatile unsigned *)(VIC_BASEADDR+0x2C))
#define ICSLV2				(*(volatile unsigned *)(VIC_BASEADDR+0x30))
#define ICSLV3				(*(volatile unsigned *)(VIC_BASEADDR+0x34))
#define F_CSLV0				(*(volatile unsigned *)(VIC_BASEADDR+0x58))
#define F_CSLV1				(*(volatile unsigned *)(VIC_BASEADDR+0x5C))
#define F_CSLV2				(*(volatile unsigned *)(VIC_BASEADDR+0x60))
#define F_CSLV3				(*(volatile unsigned *)(VIC_BASEADDR+0x64))
#define I_CMST				(*(volatile unsigned *)(VIC_BASEADDR+0x38))
#define F_CMST				(*(volatile unsigned *)(VIC_BASEADDR+0x68))
#define I_ISPR				(*(volatile unsigned *)(VIC_BASEADDR+0x3C))
#define F_ISPR				(*(volatile unsigned *)(VIC_BASEADDR+0x6C))
#define I_ISPC				(*(volatile unsigned *)(VIC_BASEADDR+0x40))
#define F_ISPC				(*(volatile unsigned *)(VIC_BASEADDR+0x70))
#define POLARITY				(*(volatile unsigned *)(VIC_BASEADDR+0x74))
#define I_VECADDR       		(*(volatile unsigned *)(VIC_BASEADDR+0x78))
#define F_VECADDR       		(*(volatile unsigned *)(VIC_BASEADDR+0x7C))

/* Timer */
#define TIMER_BASEADDR		(APB1_STARTADDR+0x0000)
#define TIMER0_DAT			(*(volatile unsigned *)(TIMER_BASEADDR+0x00))
#define TIMER0_PRE			(*(volatile unsigned *)(TIMER_BASEADDR+0x04))
#define TIMER0_CON          	(*(volatile unsigned *)(TIMER_BASEADDR+0x08))
#define TIMER0_CNT          	(*(volatile unsigned *)(TIMER_BASEADDR+0x0C))
#define TIMER1_DAT          	(*(volatile unsigned *)(TIMER_BASEADDR+0x10))
#define TIMER1_PRE          	(*(volatile unsigned *)(TIMER_BASEADDR+0x14))
#define TIMER1_CON          	(*(volatile unsigned *)(TIMER_BASEADDR+0x18))
#define TIMER1_CNT          	(*(volatile unsigned *)(TIMER_BASEADDR+0x1C))
#define TIMER2_DAT          	(*(volatile unsigned *)(TIMER_BASEADDR+0x20))
#define TIMER2_PRE          	(*(volatile unsigned *)(TIMER_BASEADDR+0x24))
#define TIMER2_CON			(*(volatile unsigned *)(TIMER_BASEADDR+0x28))
#define TIMER2_CNT          	(*(volatile unsigned *)(TIMER_BASEADDR+0x2C))
#define TIMER3_DAT          	(*(volatile unsigned *)(TIMER_BASEADDR+0x30))
#define TIMER3_PRE          	(*(volatile unsigned *)(TIMER_BASEADDR+0x34))
#define TIMER3_CON          	(*(volatile unsigned *)(TIMER_BASEADDR+0x38))
#define TIMER3_CNT          	(*(volatile unsigned *)(TIMER_BASEADDR+0x3C))

#define TIMERDAT(x)			(*(volatile unsigned *)(TIMER_BASEADDR+0x0+(x*0x10)))
#define TIMERPRE(x)			(*(volatile unsigned *)(TIMER_BASEADDR+0x4+(x*0x10)))
#define TIMERCON(x)			(*(volatile unsigned *)(TIMER_BASEADDR+0x8+(x*0x10)))
#define TIMERCNT(x)			(*(volatile unsigned *)(TIMER_BASEADDR+0xC+(x*0x10)))

/* WDT */
#define WDT_BASEADDR		(APB1_STARTADDR+0x1000)
#define WDTCON				(*(volatile unsigned *)(WDT_BASEADDR+0x00))
#define WDTPSR				(*(volatile unsigned *)(WDT_BASEADDR+0x04))
#define WDTLDR				(*(volatile unsigned *)(WDT_BASEADDR+0x08))
#define WDTCNT				(*(volatile unsigned *)(WDT_BASEADDR+0x0C))
#define WDTISR				(*(volatile unsigned *)(WDT_BASEADDR+0x10))

/* GPIO */              	
#define GPIO_BASEADDR		(APB1_STARTADDR+0x2000)
#define GPIO0_OE       		(*(volatile unsigned *)(GPIO_BASEADDR+0x00))
#define GPIO0_IN      			(*(volatile unsigned *)(GPIO_BASEADDR+0x04))
#define GPIO0_OUT      		(*(volatile unsigned *)(GPIO_BASEADDR+0x08))
#define DBG_GPIO0_OUT      	(*(volatile unsigned *)(GPIO_BASEADDR+0x08))
#define GPIO0_INTSTAT  		(*(volatile unsigned *)(GPIO_BASEADDR+0x0C))
#define GPIO0_INTEN  		(*(volatile unsigned *)(GPIO_BASEADDR+0x10))
#define GPIO0_INTLEVEL 		(*(volatile unsigned *)(GPIO_BASEADDR+0x14))
#define GPIO0_INTPOL   		(*(volatile unsigned *)(GPIO_BASEADDR+0x18))
#define GPIO0_INTBEDGE 		(*(volatile unsigned *)(GPIO_BASEADDR+0x1C))

#define GPIO1_OE       		(*(volatile unsigned *)(GPIO_BASEADDR+0x20))
#define GPIO1_IN      			(*(volatile unsigned *)(GPIO_BASEADDR+0x24))
#define GPIO1_OUT      		(*(volatile unsigned *)(GPIO_BASEADDR+0x28))
#define GPIO1_INTSTAT  		(*(volatile unsigned *)(GPIO_BASEADDR+0x2C))
#define GPIO1_INTEN  		(*(volatile unsigned *)(GPIO_BASEADDR+0x30))
#define GPIO1_INTLEVEL 		(*(volatile unsigned *)(GPIO_BASEADDR+0x34))
#define GPIO1_INTPOL   		(*(volatile unsigned *)(GPIO_BASEADDR+0x38))
#define GPIO1_INTBEDGE 		(*(volatile unsigned *)(GPIO_BASEADDR+0x3C))

#define GPIO_OE(x)			(*(volatile unsigned *)(GPIO_BASEADDR+0x00 + (x*0x20)))
#define GPIO_IN(x)			(*(volatile unsigned *)(GPIO_BASEADDR+0x04 + (x*0x20)))
#define GPIO_OUT(x)      		(*(volatile unsigned *)(GPIO_BASEADDR+0x08 + (x*0x20)))
#define GPIO_INTSTAT(x)		(*(volatile unsigned *)(GPIO_BASEADDR+0x0C + (x*0x20)))
#define GPIO_INTEN(x)  		(*(volatile unsigned *)(GPIO_BASEADDR+0x10 + (x*0x20)))
#define GPIO_INTLEVEL(x)		(*(volatile unsigned *)(GPIO_BASEADDR+0x14 + (x*0x20)))
#define GPIO_INTPOL(x)		(*(volatile unsigned *)(GPIO_BASEADDR+0x18 + (x*0x20)))
#define GPIO_INTBEDGE(x)	(*(volatile unsigned *)(GPIO_BASEADDR+0x1C + (x*0x20)))

/* Resource Share Controller */
#define RS_BASEADDR		(APB1_STARTADDR+0x4000)
#define RS_DMAMUX			(*(volatile unsigned *)(RS_BASEADDR+0x04))

/* UART */
//UART ch0
#define UART0_BASEADDR		(APB1_STARTADDR+0x5000)
#define UART0MASTER		(*(volatile unsigned *)(UART0_BASEADDR+0x00))
#define UART0STATUS		(*(volatile unsigned *)(UART0_BASEADDR+0x04))
#define UART0BRD			(*(volatile unsigned *)(UART0_BASEADDR+0x08))
#define UART0TXFIFO			(*(volatile unsigned *)(UART0_BASEADDR+0x0C))
#define UART0RXFIFO			(*(volatile unsigned *)(UART0_BASEADDR+0x10))
#define UART0RXTIMEOUT		(*(volatile unsigned *)(UART0_BASEADDR+0x14))

//UART ch1
#define UART1_BASEADDR		(APB1_STARTADDR+0x5040)
#define UART1MASTER		(*(volatile unsigned *)(UART1_BASEADDR+0x00))
#define UART1STATUS		(*(volatile unsigned *)(UART1_BASEADDR+0x04))
#define UART1BRD			(*(volatile unsigned *)(UART1_BASEADDR+0x08))
#define UART1TXFIFO			(*(volatile unsigned *)(UART1_BASEADDR+0x0C))
#define UART1RXFIFO			(*(volatile unsigned *)(UART1_BASEADDR+0x10))
#define UART1RXTIMEOUT		(*(volatile unsigned *)(UART1_BASEADDR+0x14))

/* I2S Controller */
#define	I2S_BASEADDR		(APB1_STARTADDR+0x6000)
#define I2S_CLKCTRL			(*(volatile unsigned *)(I2S_BASEADDR+0x00))
#define I2S_CTRL				(*(volatile unsigned *)(I2S_BASEADDR+0x04))
#define I2S_STATUS			(*(volatile unsigned *)(I2S_BASEADDR+0x08))
#define I2S_DATA			(*(volatile unsigned *)(I2S_BASEADDR+0x0C))


/* IIC0 */
#define I2C_BASEADDR		(APB1_STARTADDR+0x7000)
#define ICCR0_0             		(*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define ICSR0               		(*(volatile unsigned *)(I2C_BASEADDR+0x04))
#define IAR0                		(*(volatile unsigned *)(I2C_BASEADDR+0x08))
#define IDSR0               		(*(volatile unsigned *)(I2C_BASEADDR+0x0C))
#define ICCR0_1            		(*(volatile unsigned *)(I2C_BASEADDR+0x10))
#define I2C0_SRST        		(*(volatile unsigned *)(I2C_BASEADDR+0x14))
#define I2CCON              		(*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define I2CSTA              		(*(volatile unsigned *)(I2C_BASEADDR+0x04))
#define I2CDATA            		(*(volatile unsigned *)(I2C_BASEADDR+0x08))

/* SPI */
#define SPI_BASEADDR		(APB1_STARTADDR+0x8000)
#define SPICON(x)			(*(volatile unsigned *)(SPI_BASEADDR+0x000+((x)*0x20)))
#define SPIPRE(x)			(*(volatile unsigned *)(SPI_BASEADDR+0x004+((x)*0x20)))
#define SPISTA(x)			(*(volatile unsigned *)(SPI_BASEADDR+0x008+((x)*0x20)))
#define SPIINTDMA(x)			(*(volatile unsigned *)(SPI_BASEADDR+0x00C+((x)*0x20)))
#define SPIINTSTA(x)			(*(volatile unsigned *)(SPI_BASEADDR+0x010+((x)*0x20)))
#define SPITXDAT(x)			(*(volatile unsigned *)(SPI_BASEADDR+0x014+((x)*0x20)))
#define SPIRXDAT(x)			(*(volatile unsigned *)(SPI_BASEADDR+0x018+((x)*0x20)))
// This Hidden register (confidential)
#define SPIHIDDEN(x)			(*(volatile unsigned *)(SPI_BASEADDR+0x01C+((x)*0x20)))

/* External sram */
#define ESMC_BASEADDR		(APB1_STARTADDR+0x9000)
#define ESMC_B0_CON     		(*(volatile unsigned *)(ESMC_BASEADDR+0x00))
#define ESMC_B1_CON     		(*(volatile unsigned *)(ESMC_BASEADDR+0x04))
#define ESMC_B2_CON     		(*(volatile unsigned *)(ESMC_BASEADDR+0x08))
#define ESMC_B3_CON     		(*(volatile unsigned *)(ESMC_BASEADDR+0x0C))

// PCI Bridge Configuration
#define PCI_MEMORY_ACCESS		(*(volatile unsigned *)(PCI_MEM_ADDR))
#define PCI_IO_ACCESS			(*(volatile unsigned *)(PCI_IO_ADDR))
#define PCI_CONFIG_ADDR		(*(volatile unsigned *)(PCI_CFG_ADDR))
#define PCI_CONFIG_DATA		(*(volatile unsigned *)(PCI_CFG_DATA))

/* MAC SLAV0 */
#define MACS0_0					(*(volatile unsigned *)(AHB0_STARTADDR+0x00))
#define MACS0_1					(*(volatile unsigned *)(AHB0_STARTADDR+0x04))
#define MACS0_2					(*(volatile unsigned *)(AHB0_STARTADDR+0x08))
  
/* MAC SLAV1 */
#define MACS1_0					(*(volatile unsigned *)(AHB1_STARTADDR+0x00))
#define MACS1_1					(*(volatile unsigned *)(AHB1_STARTADDR+0x04))
#define MACS1_2					(*(volatile unsigned *)(AHB1_STARTADDR+0x08))

/* PCI SLAV1 */
//#define PCI0					(*(volatile unsigned *)(AHB2_STARTADDR+0x00))
//#define PCI1					(*(volatile unsigned *)(AHB2_STARTADDR+0x04))
//#define PCI2					(*(volatile unsigned *)(AHB2_STARTADDR+0x08))


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

/*
/////////////////////////////////////////////////////////
        REGISTER MASK DEFINITION
///////////////////////////////////////////////////////// 
*/

/* External sram */
/* E-DMA */
// DMASAdr
#define DMA_SRCADDR_MASK		(0xFFFFFFFF) << 0
// DMADAdr
#define DMA_DSTADDR_MASK		(0xFFFFFFFF) << 0

// DMACCon  
#define DMA_STARTINTEN_MASK	(0x01UL) << 31
#define DMA_ENDINTEN_MASK		(0x01UL) << 30 
#define DMA_M2M_MASK			(0x01UL) << 29
#define DMA_SRCINCR_MASK		(0x01UL) << 28
#define DMA_SRCWIDTH_MASK		(0x03UL) << 26
#define DMA_DSTINCR_MASK		(0x01UL) << 25
#define DMA_DSTWIDTH_MASK	(0x03UL) << 23
#define DMA_SIZE_MASK			(0x07UL) << 20
#define DMA_TXLENGTH_MASK		(0xFFFFFUL) << 0
 
// DMACDescrp
#define DMA_DESCRADDR_MASK	(0xFFFFFFFFUL) << 2
#define DMA_DESCREND_MASK		(0x1UL) << 0
  
// DMACSta
#define DMA_ENABLE_MASK		(0x1UL) << 31
#define DMA_ACTIVE_MASK		(0x1UL) << 27
#define DMA_STOPINTEN_MASK	(0x1UL) << 4
#define DMA_STOPINT_MASK		(0x1UL) << 3
#define DMA_STARTINT_MASK		(0x1UL) << 2
#define DMA_ENDINT_MASK		(0x1UL) << 1
#define DMA_ERRORINT_MASK		(0x1UL) << 0

#define DMA2D_EN_MASK			(0x1UL)<<31
#define DMA2D_ACTIVE_MASK		(0x1UL)<<27
#define DMA2D_STOPINTEN_MASK	(0x1UL)<<3
#define DMA2D_STOPINT_MASK	(0x1UL)<<1
#define DMA2D_ERRINT_MASK		(0x1UL)<<0

/* Interrupt */
// INTCON register
#define INT_GIE_EN				(0x1UL)<<3
#define INT_VECT_EN				(0x1UL)<<2
#define INT_IRQ_EN				(0x1UL)<<1
#define INT_FIQ_EN				(0x1UL)<<0

#define IRQ_UART0      			0
#define IRQ_DM 	    				1
#define IRQ_VIF	    				2
#define IRQ_WDT     				3
#define IRQ_USB     				4
#define IRQ_SEIP     				5
#define IRQ_DMA0      				6
#define IRQ_DMA4      				7
#define IRQ_DMA1      				8
#define IRQ_DMA5      				9
#define IRQ_DMA2      				10
#define IRQ_DMA6      				11
#define IRQ_DMA3      				12
#define IRQ_DMA7      				13
#define IRQ_GPIO0    				14
#define IRQ_GPIO1    				15
#define IRQ_TIMER0     			16
#define IRQ_TIMER1     			17
#define IRQ_TIMER2     			18
#define IRQ_TIMER3     			19
#define IRQ_UART1      			20
#define IRQ_UART2      			21
#define IRQ_UART3      			22
#define IRQ_SPI					23
#define IRQ_I2S	    				24
#define IRQ_I2C	    				25
#define IRQ_MMC	    				26
#define IRQ_NAND    				27
#define IRQ_DMA2D     			28		// Just to void compile error

// PCI Bridge interrupt
#define IRQ_PCI_INTA			28
#define IRQ_PCI_INTB			29
#define IRQ_PCI_INTC			30
#define IRQ_PCI_INTD			31

// INTPNC & INTMOD & INTMASK register
#define INT_MASK(x)				((0x1UL)<<(x))

// I_PSLV/F_PSLV & I_CSLV/F_CSLV register
#define INT_PRIORITY_SEL0   		(0x7UL)<<0
#define INT_PRIORITY_SEL1   		(0x7UL)<<3
#define INT_PRIORITY_SEL2   		(0x7UL)<<6
#define INT_PRIORITY_SEL3   		(0x7UL)<<9
#define INT_PRIORITY_SEL4   		(0x7UL)<<12
#define INT_PRIORITY_SEL5   		(0x7UL)<<15
#define INT_PRIORITY_SEL6   		(0x7UL)<<18
#define INT_PRIORITY_SEL7   		(0x7UL)<<21

// I_PMST / F_PMST register
#define INT_MASTER_MODE_SEL 	(0x1UL)<<12
#define INT_SLAVE_MODE_SEL  	(0xfUL)<<8
#define INT_SLV_PRIORITY_SEL	(0xffUL)<<0
#define INT_SLV0_PRIORITY		(0x3UL)<<0
#define INT_SLV1_PRIORITY		(0x3UL)<<2
#define INT_SLV2_PRIORITY		(0x3UL)<<4
#define INT_SLV3_PRIORITY		(0x3UL)<<6

#ifdef __cplusplus
}
#endif
#endif /*__SDI_V5_H___*/
