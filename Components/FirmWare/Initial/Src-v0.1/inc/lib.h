/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: lib.h
	Description	: Basic peripheral header file
----------------------------------------------------------*/
#ifndef __LIB_H__
#define __LIB_H__

/*/////////////////////////////////////////////////////////
	INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "structdef.h"
#include "commonmacro.h"

/*/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// */
#ifdef __ARM_GCC_USE__			// When use arm-gcc compiler in the linux OS
#define IRQ_INTR
#else							// When use ADSv1.2
#define IRQ_INTR			__irq
#endif

#define VIC_POLARITY	0x00000000	// all active high
#define VIC_LEVEL		(0x00000000|INT_UARTRX_MASK|INT_UARTTX_MASK)	// only UART is level triggered
#define VIC_INTMOD		0x00000000	// all int's routed to nIRQ

#define NO_ERROR			0
#define VIC_ERROR			1
#define TIMER_PWM_ERROR	2
#define WDT_ERROR			3
#define UART_ERROR			4
#define I2C_ERROR			5
#define GPIO_ERROR			6
#define ADC_ERROR			7
#define SMC_ERROR			8
#define FMC_ERROR			9
#define ESRAM_ERROR		10
#define REGISTER_ERROR		11

typedef void (*ISRType)(smtUint32 IRQ);

/*/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
smtBoolean smtDelay100us(int time);

/*---------------------------------------------------------
	MEMORY
--------------------------------------------------------- */
/*---------------------------------------------------------
	DMA
--------------------------------------------------------- */
// E-DMA
void smtDMACEnable(smtUint8 channel);
void smtDMACDisable(smtUint8 channel);
void smtDMACNoDescrp(
	smtUint8 channel, 
	smtUint32 SrcAddr, smtBoolean SrcIncrease, smtUint8 SWidth,
	smtUint32 DestAddr, smtBoolean DstIncrease, smtUint8 DWidth, 
	smtUint8 TransSize, smtUint16 TotalSize);
void smtDMACUseDescrp(smtUint8 channel, smtUint32 FirstDescAddr);

// G-DMA
void smtDMA2DEnable(void);
void smtDMA2DDisable(void);
void smtDMA2DEnableIntr(void);
void smtDMA2DDisableIntr(void);
void smtDMA2DClearIntr(smtUint8 clearIntr);
smtUint8 smtDMA2DGetIntrInfo(void);
void smt2DMA2DMemToMemCopy(DMA2D_STRUCT dma2D);
smtUint32 smt2DMAMemToMemCopy (
	smtUint8 channel, 
	smtUint8 *dest, 
	smtUint8 *src, 
	smtUint32 nbytes
	);

// FMC
smtBoolean smtFMCSetMode(FMC_STRUCT fmc);
smtBoolean smtFMWrite(FM_STRUCT flashWrite);
smtUint32 smtFMRead(smtUint32 addr);
smtBoolean smt2FMProgramNormal(smtUint32 addr, smtUint32 *data, smtUint32 length);
smtBoolean smt2FMProgramOption(FM_OPTION_TYPE optionType, smtUint32 sector);
smtBoolean smt2FMErase(FM_OPERATION_MODE eraseType, smtUint32 sector);
// ESMC
smtBoolean smtSRAMSetMode(ESMC_CON sramCtrl, smtUint8 bankSel);
smtBoolean smtSRAMGetMode(ESMC_CON sramCtrl, smtUint8 bankSel);
smtBoolean smtMemWrite(smtUint32 addr, smtUint32 *data, smtUint32 length);
smtBoolean smtMemRead(smtUint32 addr, smtUint32 *data, smtUint32 length);

// ESDMC
smtBoolean smtSDRAMSetTimeCtrl(ESDMC_TCON timeCtrl);
smtBoolean smtSDRAMGetTimeCtrl(ESDMC_TCON timeCtrl);
smtBoolean smtSDRAMSetCtrl(ESDMC_CON sdramCtrl);
smtBoolean smtSDRAMGetCtrl(ESDMC_CON sdramCtrl);
smtBoolean smtSDRAMSetPWRCtrl(ESDMC_PWR_CON pwrCtrl);
smtBoolean smtSDRAMGetPWRCtrl(ESDMC_PWR_CON pwrCtrl);
smtBoolean smtSDRAMSetRefreshCtrl(ESDMC_REF_CON refreshCtrl);
smtBoolean smtSDRAMGetRefreshCtrl(ESDMC_REF_CON refreshCtrl);

/*---------------------------------------------------------
	VIF (Video Interface Controller)
--------------------------------------------------------- */
void smtVIFSWReset(void);
void smtVIFStart(void);
smtBoolean smtVIFSetMode(VIF_CTRL_STRUCT vif);
smtBoolean smtVIFGetMode(VIF_CTRL_STRUCT vif);
smtUint8 smtVIFGetIntStatus(void);
smtBoolean smtVIFSetProperty(VIF_PROP_STRUCT vifProp);
smtBoolean smtVIFGetProperty(VIF_PROP_STRUCT vifProp);

/*---------------------------------------------------------
	TIMER & PWM
--------------------------------------------------------- */
smtBoolean smtTIMERSetMode(TIMER_STRUCT timer, TIMER_SEL timerSel);
smtBoolean smtTIMERGetMode(TIMER_STRUCT timer, TIMER_SEL timerSel);
smtBoolean smtTIMEROperation(TIMER_STRUCT timer, TIMER_SEL timerSel);
smtBoolean smtWDTSetMode(WDT_STRUCT wdt);
smtBoolean smtWDTOperation(WDT_STRUCT wdt);

/*---------------------------------------------------------
	GPIO
--------------------------------------------------------- */
void smtGPIOSetDir(GPIO_STRUCT gpio);
void smtGPIOGetDir(GPIO_STRUCT gpio);
void smtGPIOSetData(GPIO_STRUCT gpio, smtUint32 gpioData);
void smtGPIOGetData(GPIO_STRUCT gpio, smtUint32 gpioData);
void smtGPIOGetIntStatus(GPIO_STRUCT gpio);
void smtGPIOIntClear(GPIO_STRUCT gpio);
void smtGPIOIntEnable(GPIO_STRUCT gpio);
void smtGPIOIntDisable(GPIO_STRUCT gpio);
void smtGPIOSetIntProperty(GPIO_STRUCT gpio);
void smtGPIOGetIntProperty(GPIO_STRUCT gpio);
smtBoolean smt2GPIOWriteData(GPIO_STRUCT gpio, smtUint32 gpioData);
smtBoolean smt2GPIOReadData(GPIO_STRUCT gpio, smtUint32 gpioData);

/*---------------------------------------------------------
	VIC (Vectored Interrupt Controller)
--------------------------------------------------------- */
void EnableVIC(smtUint32 Polarity, smtUint32 Level, smtUint32 IntMod);
void DisableVIC(void);
void EnableIRQ(smtUint32 IRQ);
void DisableIRQ(smtUint32 IRQ);
void RequestIRQ(smtUint32 IRQ, ISRType ISR);
void ReleaseIRQ(smtUint32 IRQ);

void EnableINT(void);
void DisableINT(void);
void AckIRQ(smtUint32 IRQ);

/*---------------------------------------------------------
	ADC
--------------------------------------------------------- */
smtBoolean smtADCSetMode(ADC_STRUCT adc);
smtUint16 smtADCDataRead(void);

/*---------------------------------------------------------
	POWER MANAGEMENT
--------------------------------------------------------- */
smtBoolean smtPower(PM_PWR_MODE pwrMode);


#endif /* __LIB_H__ */

