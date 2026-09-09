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

/*
/////////////////////////////////////////////////////////
	INCLUDE
///////////////////////////////////////////////////////// 
*/
#include "sysinc.h"
#include "structdef.h"
#include "commonmacro.h"

/*
/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// 
*/
#ifdef __ARM_GCC_USE__			// When use arm-gcc compiler in the linux OS
#define IRQ_INTR
#else							// When use ADSv1.2
#define IRQ_INTR			
#endif

	
#define NO_ERROR			0
#define VIC_ERROR			1
#define TIMER_PWM_ERROR		2
#define WDT_ERROR			3
#define UART_ERROR			4
#define I2C_ERROR			5
#define GPIO_ERROR			6
#define ADC_ERROR			7
#define SMC_ERROR			8
#define FMC_ERROR			9
#define ESRAM_ERROR		10
#define REGISTER_ERROR		11


/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

smtBoolean smtDelay100us(smtInt32 time);

/*---------------------------------------------------------
	MEMORY
--------------------------------------------------------- */
/*---------------------------------------------------------
	DMA
--------------------------------------------------------- */
void DMA2Init(smtBoolean polling);
smtUint32 smt2EDMACopy(DMA_DEVICE device, EDMA_STRUCT *dma, smtUint8 descCount);
smtUint32 smt2GDMACopy(GDMA_STRUCT *gdma);
smtUint32 smt2EDMAUseDescriptor(EDMA_STRUCT *dma, smtUint8 channel, smtUint8 descCount);
smtUint32 smt2EDMANoDescriptor(EDMA_STRUCT *dma, smtUint32 channel);


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
	GPIO
--------------------------------------------------------- */
void smtGPIOSetDir(smtUint8 channel, smtUint8 gpioNum, smtUint32 mode);
void smtGPIOGetDir(smtUint8 channel, smtUint8 gpioNum, smtUint32 *mode);
void smtGPIOSetData(smtUint8 channel, smtUint8 gpioNum, smtUint32 data);
void smtGPIOGetData(smtUint8 channel, smtUint8 gpioNum, smtUint32 *data);
void smtGPIOIntrEnable(smtUint8 channel, smtUint8 enable);
void smtGPIOGetIntStatus(smtUint8 channel, smtUint8 gpioNum, smtUint32 *gpioStatus);
void smtGPIOIntClear(smtUint8 channel, smtUint8 gpioNum);
void smtGPIOSetIntProperty(smtUint8 channel, GPIO_STRUCT gpio);
void smtGPIOGetIntProperty(smtUint8 channel, GPIO_STRUCT *gpio);


/*---------------------------------------------------------
	TIMER & PWM
--------------------------------------------------------- */
void smtTIMERSetMode(TIMER_STRUCT timer, TIMER_SEL timerSel);
void smtTIMERGetMode(TIMER_STRUCT *timer, TIMER_SEL timerSel);
void smtTIMERClrCount(smtUint8 timerCh);
void smtTIMEROperation(TIMER_STRUCT timer, TIMER_SEL timerSel);

/*---------------------------------------------------------
	ADC
--------------------------------------------------------- */
smtBoolean smtADCSetMode(ADC_STRUCT adc);
smtUint16 smtADCDataRead(void);

/*---------------------------------------------------------
	POWER MANAGEMENT
--------------------------------------------------------- */
smtBoolean smtPower(PM_PWR_MODE pwrMode);

/*---------------------------------------------------------
	WDT
--------------------------------------------------------- */
void smtWDTSetMode(WDT_STRUCT wdt);
void smtWDTGetMode(WDT_STRUCT *wdt);
void smtWDTGetCount(smtUint16 *count);
void smtWDTClearISR(void);
void smtWDTGetISR(smtUint8 *intrStatus);

#endif /* __LIB_H__ */

