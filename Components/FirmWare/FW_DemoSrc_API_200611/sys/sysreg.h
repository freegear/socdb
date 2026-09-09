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

/* External sram */
#define ESMC_BASEADDR		(APB0_STARTADDR+0x1000)
#define ESMC_B0_CON     	(*(volatile unsigned *)(ESMC_BASEADDR+0x00))
#define ESMC_B1_CON     	(*(volatile unsigned *)(ESMC_BASEADDR+0x04))
#define ESMC_B2_CON     	(*(volatile unsigned *)(ESMC_BASEADDR+0x08))
#define ESMC_B3_CON     	(*(volatile unsigned *)(ESMC_BASEADDR+0x0C))

/* DDRSDRAM Controller */
#define DDRCTL_BASEADDR		(APB0_STARTADDR+0x2000)
#define DDRTCON				(*(volatile unsigned *)(DDRCTL_BASEADDR+0x00))
#define DDRCON				(*(volatile unsigned *)(DDRCTL_BASEADDR+0x04))
#define DDRPCON				(*(volatile unsigned *)(DDRCTL_BASEADDR+0x08))
#define DDRREF				(*(volatile unsigned *)(DDRCTL_BASEADDR+0x0C))
#define DDRDLL				(*(volatile unsigned *)(DDRCTL_BASEADDR+0x10))

/* DMA Controller */
#define	DMAC_BASEADDR		(APB0_STARTADDR+0x0000)
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

/* DM(Display Module) */
#define DM_BASEADDR			(APB1_STARTADDR+0x6000)
#define DMCON				(*(volatile unsigned *)(DM_BASEADDR+0x000))
#define DMSTS				(*(volatile unsigned *)(DM_BASEADDR+0x004))
#define CPOS				(*(volatile unsigned *)(DM_BASEADDR+0x010))
#define GPOS				(*(volatile unsigned *)(DM_BASEADDR+0x014))
#define VPOS				(*(volatile unsigned *)(DM_BASEADDR+0x018))
#define CCON				(*(volatile unsigned *)(DM_BASEADDR+0x020))
#define CBLND				(*(volatile unsigned *)(DM_BASEADDR+0x024))
#define CBMOD				(*(volatile unsigned *)(DM_BASEADDR+0x028))
#define CBASE				(*(volatile unsigned *)(DM_BASEADDR+0x02c))
#define CADDR				(*(volatile unsigned *)(DM_BASEADDR+0x030))
#define CBLINK				(*(volatile unsigned *)(DM_BASEADDR+0x034))
#define BGCOL				(*(volatile unsigned *)(DM_BASEADDR+0x040))
#define GCON				(*(volatile unsigned *)(DM_BASEADDR+0x050))
#define GBLND				(*(volatile unsigned *)(DM_BASEADDR+0x054))
#define GBMOD				(*(volatile unsigned *)(DM_BASEADDR+0x058))
#define GBASE				(*(volatile unsigned *)(DM_BASEADDR+0x05c))
#define GADDR				(*(volatile unsigned *)(DM_BASEADDR+0x060))
#define GPALA				(*(volatile unsigned *)(DM_BASEADDR+0x064))
#define GPALM				(*(volatile unsigned *)(DM_BASEADDR+0x068))
#define VCON				(*(volatile unsigned *)(DM_BASEADDR+0x070))
#define VBLND				(*(volatile unsigned *)(DM_BASEADDR+0x074))
#define VBMOD				(*(volatile unsigned *)(DM_BASEADDR+0x078))
#define VBASE				(*(volatile unsigned *)(DM_BASEADDR+0x07c))
#define VADDR				(*(volatile unsigned *)(DM_BASEADDR+0x080))
#define VADDR2				(*(volatile unsigned *)(DM_BASEADDR+0x084))
#define SCON				(*(volatile unsigned *)(DM_BASEADDR+0x090))
#define SSIZE				(*(volatile unsigned *)(DM_BASEADDR+0x094))
#define SRATIO				(*(volatile unsigned *)(DM_BASEADDR+0x098))
#define LCDCON				(*(volatile unsigned *)(DM_BASEADDR+0x0E0))
#define LECON				(*(volatile unsigned *)(DM_BASEADDR+0x0E4))
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

/* UART */
#define UART_BASEADDR		(APB1_STARTADDR+0x2000)
#define UARTDR              (*(volatile unsigned *)(UART_BASEADDR+0x00))
#define UARTSR              (*(volatile unsigned *)(UART_BASEADDR+0x04))
#define UARTFR              (*(volatile unsigned *)(UART_BASEADDR+0x18))
#define UARTILPR            (*(volatile unsigned *)(UART_BASEADDR+0x20))
#define UARTIBRD            (*(volatile unsigned *)(UART_BASEADDR+0x24))
#define UARTFBRD            (*(volatile unsigned *)(UART_BASEADDR+0x28))
#define UARTLCR_H           (*(volatile unsigned *)(UART_BASEADDR+0x2C))
#define UARTCR              (*(volatile unsigned *)(UART_BASEADDR+0x30))
#define UARTIFLS            (*(volatile unsigned *)(UART_BASEADDR+0x34))
#define UARTIMSC            (*(volatile unsigned *)(UART_BASEADDR+0x38))
#define UARTRIS             (*(volatile unsigned *)(UART_BASEADDR+0x3C))
#define UARTMIS             (*(volatile unsigned *)(UART_BASEADDR+0x40))
#define UARTICR             (*(volatile unsigned *)(UART_BASEADDR+0x44))
#define UARTDMACR       	(*(volatile unsigned *)(UART_BASEADDR+0x48))

/* IIC0 */
#define I2C_BASEADDR		(APB1_STARTADDR+0x4000)
#define ICCR0_0             (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define ICSR0               (*(volatile unsigned *)(I2C_BASEADDR+0x04))
#define IAR0                (*(volatile unsigned *)(I2C_BASEADDR+0x08))
#define IDSR0               (*(volatile unsigned *)(I2C_BASEADDR+0x0C))
#define ICCR0_1             (*(volatile unsigned *)(I2C_BASEADDR+0x10))
#define I2C0_SRST        	(*(volatile unsigned *)(I2C_BASEADDR+0x14))

/* IIC1 */
#define ICCR1_0             (*(volatile unsigned *)(I2C_BASEADDR+0x80))
#define ICSR1               (*(volatile unsigned *)(I2C_BASEADDR+0x84))
#define IAR1                (*(volatile unsigned *)(I2C_BASEADDR+0x88))
#define IDSR1               (*(volatile unsigned *)(I2C_BASEADDR+0x8C))
#define ICCR1_1             (*(volatile unsigned *)(I2C_BASEADDR+0x90))
#define I2C1_SRST        	(*(volatile unsigned *)(I2C_BASEADDR+0x94))

/* Timer */
#define TIMER_BASEADDR		(APB1_STARTADDR+0x5000)
#define TDAT                (*(volatile unsigned *)(TIMER_BASEADDR+0x00))
#define TPRE                (*(volatile unsigned *)(TIMER_BASEADDR+0x04))
#define TCON                (*(volatile unsigned *)(TIMER_BASEADDR+0x08))
#define TCNT                (*(volatile unsigned *)(TIMER_BASEADDR+0x0C))
#define TPWM                (*(volatile unsigned *)(TIMER_BASEADDR+0x10))

/* GPIO */              	
#define GPIO_BASEADDR		(APB1_STARTADDR+0x1000)
#define GPIO_OE       		(*(volatile unsigned *)(GPIO_BASEADDR+0x00))
#define GPIO_IN       		(*(volatile unsigned *)(GPIO_BASEADDR+0x04))
#define GPIO_OUT       		(*(volatile unsigned *)(GPIO_BASEADDR+0x08))

/* Interrupt */
#define VIC_BASEADDR		(APB1_STARTADDR+0x0000)
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

#define	I2S_BASEADDR		(APB1_STARTADDR+0x7000)
#define I2S_CLKCTRL			(*(volatile unsigned *)(I2S_BASEADDR+0x00))
#define I2S_CTRL			(*(volatile unsigned *)(I2S_BASEADDR+0x04))
#define I2S_STATUS			(*(volatile unsigned *)(I2S_BASEADDR+0x08))
#define I2S_DATA			(*(volatile unsigned *)(I2S_BASEADDR+0x0C))

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


/* UART */
// UART_DR register
#define DR_OVERRUN_ERR  	(0x1UL)<<11
#define DR_BREAK_ERR    	(0x1UL)<<10
#define DR_PARITY_ERR   	(0x1UL)<<9
#define DR_FRAMING_ERR  	(0x1UL)<<8
#define DR_DATA             (0xffUL)<<0

// UARTRSR register
#define RSR_OVERUN_ERR  	(0x1UL)<<3
#define RSR_BREAK_ERR  		(0x1UL)<<2
#define RSR_PARITY_ERR  	(0x1UL)<<1
#define RSR_FRAMING_ERR  	(0x1UL)<<0

// UARTFR register
#define RING_INDICATOR  	(0x1UL)<<8
#define TXFIFO_EMPTY    	(0x1UL)<<7
#define RXFIFO_FULL     	(0x1UL)<<6
#define TXFIFO_FULL     	(0x1UL)<<5
#define RXFIFO_EMPTY    	(0x1UL)<<4
#define UART_BUSY       	(0x1UL)<<3
#define CARRIER_DETECT  	(0x1UL)<<2
#define SET_RETRY       	(0x1UL)<<1
#define CLEAR_TO_SEND  		(0x1UL)<<0

// UARTLCR_H register
#define STICK_PAR_SEL   	(0x1UL)<<7
#define WORD_LENGTH     	(0x3UL)<<5
#define EN_FIFO         	(0x1UL)<<4
#define T_STOP_BIT_SEL  	(0x1UL)<<3
#define EVEN_PARITY_SEL 	(0x1UL)<<2
#define PARITY_EN       	(0x1UL)<<1
#define SEND_BREAK      	(0x1UL)<<0

// UARTCR register
#define CTS_HW_FLOW 		(0x1UL)<<15
#define RTS_HW_FLOW 		(0x1UL)<<14
#define OUT2                (0x1UL)<<13
#define OUT1                (0x1UL)<<12
#define REQ_TO_SEND 		(0x1UL)<<11
#define DATA_TX_READY   	(0x1UL)<<10
#define RX_EN               (0x1UL)<<9
#define TX_EN               (0x1UL)<<8
#define LOOP_BACK_EN    	(0x1UL)<<7
#define UART_EN         	(0x1UL)<<0

// UARTFLS register
#define RX_INTERRUPT_LEVEL  (0x7UL)<<3
#define TX_INTERRUPT_LEVEL  (0x7UL)<<0

// UARTMSC & RIS & MIS & ICR register
#define OVERRUN_ERR_MASK 	(0x1UL)<<10
#define BREAK_ERR_MASK   	(0x1UL)<<9
#define PARITY_ERR_MASK  	(0x1UL)<<8
#define FRAMING_ERR_MASK 	(0x1UL)<<7
#define RX_TIMEOUT          (0x1UL)<<6
#define TX_INTERRUPT_MASK   (0x1UL)<<5
#define RX_INTERRUPT_MASK   (0x1UL)<<4
#define DSR_INTERRUPT_MASK  (0x1UL)<<3
#define DCD_INTERRUPT_MASK  (0x1UL)<<2
#define CTS_INTERRUPT_MASK  (0x1UL)<<1
#define RI_INTERRUPT_MASK   (0x1UL)<<0


/* I2C */
// ICCR0 register
#define ACK_EN          	(0x1UL)<<7
#define TX_CLK_SEL      	(0x1UL)<<6
#define INTERRUPT_EN    	(0x1UL)<<5
#define INTR_PENDING_FLAG   (0x1UL)<<4
#define TX_CLK_VALUE        (0xfUL)<<0

// ICCR1 register
#define HIGH_SPEED_CYCLE    (0x3fUL)<<0

// ICSR register
#define I2C_MODE_SEL        (0x3UL)<<6
#define TXRX_EN             (0x1UL)<<6
#define I2C_START           (0x1UL)<<5
//#define TXRX_EN             (0x1UL)<<4
//#define ARBITOR_FLAG        (0x1UL)<<3
//#define START_BIT           (0x1UL)<<2
//#define ZERO_ADDR_FLAG  	(0x1UL)<<1
//#define LAST_RX_BIT_FLAG    (0x1UL)<<0

// IAR register
#define SLAVE_ADDR_MASK 	(0x7fUL)<<1
// IDSR register        	        
#define DATA_SHIFT_MASK 	(0xffUL)<<0
                                
                                
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


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
// Just inserted to avoid compile error by DJKIM 2006/11/28
/* Internal flash */
#define FMKEY               (*(volatile unsigned *)(ESMC_BASEADDR+0x00))
#define FMADDR              (*(volatile unsigned *)(ESMC_BASEADDR+0x00))
#define FMDATA              (*(volatile unsigned *)(ESMC_BASEADDR+0x00))
#define FMUCON              (*(volatile unsigned *)(ESMC_BASEADDR+0x00))
#define FSO                 (*(volatile unsigned *)(ESMC_BASEADDR+0x00))
#define FPO                 (*(volatile unsigned *)(ESMC_BASEADDR+0x00))

#define FMTNV               (*(volatile unsigned *)(ESMC_BASEADDR+0x00))
#define FMTPG               (*(volatile unsigned *)(ESMC_BASEADDR+0x00))
#define FMTRCV              (*(volatile unsigned *)(ESMC_BASEADDR+0x00))
#define FMTPROG             (*(volatile unsigned *)(ESMC_BASEADDR+0x00))
#define FMTERASE            (*(volatile unsigned *)(ESMC_BASEADDR+0x00))
#define FMTME               (*(volatile unsigned *)(ESMC_BASEADDR+0x00))

// Just inserted to avoid compile error by DJKIM 2006/11/28
/* Timer0 */
#define TDAT0               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPRE0               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCON0               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCNT0               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPWM0               (*(volatile unsigned *)(I2C_BASEADDR+0x00))

/* Timer1 */
#define TDAT1               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPRE1               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCON1               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCNT1               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPWM1               (*(volatile unsigned *)(I2C_BASEADDR+0x00))

/* Timer2 */
#define TDAT2               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPRE2               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCON2               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCNT2               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPWM2               (*(volatile unsigned *)(I2C_BASEADDR+0x00))

/* Timer3 */
#define TDAT3               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPRE3               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCON3               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCNT3               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPWM3               (*(volatile unsigned *)(I2C_BASEADDR+0x00))

/* Timer4 */
#define TDAT4               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPRE4               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCON4               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCNT4               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPWM4               (*(volatile unsigned *)(I2C_BASEADDR+0x00))

/* Timer5 */
#define TDAT5               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPRE5               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCON5               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCNT5               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPWM5               (*(volatile unsigned *)(I2C_BASEADDR+0x00))

/* Timer6 */
#define TDAT6               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPRE6               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCON6               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCNT6               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPWM6               (*(volatile unsigned *)(I2C_BASEADDR+0x00))

/* Timer7 */
#define TDAT7               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPRE7               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCON7               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TCNT7               (*(volatile unsigned *)(I2C_BASEADDR+0x00))
#define TPWM7               (*(volatile unsigned *)(I2C_BASEADDR+0x00))

// Just inserted to avoid compile error by DJKIM 2006/11/28
/* WDT */
#define WDTCR  		         	(*(volatile unsigned *)(TIMER_BASEADDR+0x00))
#define WDTPSR 		         	(*(volatile unsigned *)(TIMER_BASEADDR+0x00))
#define WDTTLDR		         	(*(volatile unsigned *)(TIMER_BASEADDR+0x00))
#define WDTVLR 		         	(*(volatile unsigned *)(TIMER_BASEADDR+0x00))
#define WDTISR 		         	(*(volatile unsigned *)(TIMER_BASEADDR+0x00))

//Just inserted to avoid compile error by DJKIM 2006/11/28
#define GPIO_DAT0		       	(*(volatile unsigned *)(GPIO_BASEADDR+0x00))
#define GPIO_DAT1		       	(*(volatile unsigned *)(GPIO_BASEADDR+0x00))
#define GPIO_DAT2		       	(*(volatile unsigned *)(GPIO_BASEADDR+0x00))
#define GPIO_DAT3		       	(*(volatile unsigned *)(GPIO_BASEADDR+0x00))
#define GPIO_CON0		       	(*(volatile unsigned *)(GPIO_BASEADDR+0x00))
#define GPIO_CON1		       	(*(volatile unsigned *)(GPIO_BASEADDR+0x00))
#define GPIO_CON2		       	(*(volatile unsigned *)(GPIO_BASEADDR+0x00))
#define GPIO_CON3		       	(*(volatile unsigned *)(GPIO_BASEADDR+0x00))

// Just inserted to avoid compile error by DJKIM 2006/11/28
#define WDT_DIV_SEL 		(0x3UL)<<4
#define WDT_CLKSEL  		(0x1UL)<<3
#define WDT_INTEN   		(0x1UL)<<2
#define WDT_RSTEN   		(0x1UL)<<1
#define WDT_EN      		(0x1UL)<<0


// Just inserted to avoid compile error by DJKIM 2006/11/28
/* ADC */
#define ADCCON	          	(*(volatile unsigned *)(APB1_STARTADDR+0x00))
#define ADCDAT	          	(*(volatile unsigned *)(APB1_STARTADDR+0x00))

/* Power */
#define SYSCON	          	(*(volatile unsigned *)(APB1_STARTADDR+0x00))
#define PWMCON	          	(*(volatile unsigned *)(APB1_STARTADDR+0x00))

#define DEVID               (*(volatile unsigned *)(APB1_STARTADDR+0x00))

// Just inserted to avoid compile error by DJKIM 2006/11/28
#define FLASH_MAX_SIZE       0x40000     // 256KB		// In the syscfg.h
#define FLASH_STARTADDR     0x0		// In the syscfg.h
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


// Just inserted to avoid compile error by DJKIM 2006/11/28
/* ADC */
// ADCCON register
#define ADENABLE    	(0x1UL)<<0
#define ADC_READ_START  (0x1UL)<<1
#define ADC_STBY    	(0x1UL)<<2
#define ADC_IN_SEL  	(0x7UL)<<3
#define ADC_FLAG    	(0x1UL)<<15


/* Power */
// SYSCON register
#define STOP_CTL        (0x1UL)<<0
#define SYS_CLK_DIV 	(0x7UL)<<1
#define UART_CLK_DIV    (0x3UL)<<4
#define SYS_GIE_EN      (0x1UL)<<6
#define UART_INT_SEL    (0x1UL)<<7
#define ADC_CLK_DIV 	(0xffUL)<<8

// PWMCON register
#define PWM_OUT_CTRL    (0x1UL)<<0
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////



#ifdef __cplusplus
}
#endif
#endif /*__SDI_V5_H___*/
