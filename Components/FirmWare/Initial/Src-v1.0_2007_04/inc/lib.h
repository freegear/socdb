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

void		smtEDMANoDescrp(EdmaChannel ch, EdmaStruct *pEdma);
void		smtEDMAUseDescrp(EdmaChannel ch, smtUint32 descCnt, EdmaStruct *edma);
void		smtEDMAGetStatus(EdmaChannel ch, smtUint32 *pStatus);
void		smtEDMASetStatus(EdmaChannel ch, smtUint32 status);
void		smtEDMAGetTransLength(EdmaChannel ch, smtUint32 dstAddr, smtUint32 *pTotLen);
void		smtGDMASetIntOn(smtBoolean intOn);
void		smtGDMAGetIntOn(smtBoolean *pIntOn);

smtUint32	smt2DMADisable(EdmaChannel ch);
smtUint32	smt2EDMAChAsign(smtBoolean method, smtUint16 device, EdmaChannel *ch);
smtUint32 	smt2GDMACopy(GdmaStruct * gdma, smtBoolean polling);

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
void smtGPIOSetDir(GpioChannel channel, smtUint8 gpioNum, smtUint32 mode);
void smtGPIOGetDir(GpioChannel channel, smtUint8 gpioNum, smtUint32 *pmode);
void smtGPIOSetData(GpioChannel channel, smtUint8 gpioNum, smtUint32 data);
void smtGPIOGetData(GpioChannel channel, smtUint8 gpioNum, smtUint32 *pdata);
void smtGPIOGetIntStatus(GpioChannel channel, smtUint8 gpioNum, smtUint32 *pgpioStatus);
void smtGPIOClearInt(GpioChannel channel, smtUint8 gpioNum);
void smtGPIOEnableInt(GpioChannel channel, smtUint8 enable);
void smtGPIOSetIntProperty(GpioChannel channel, GpioProperty *pgpio);
void smtGPIOGetIntProperty(GpioChannel channel, GpioProperty *pgpio);


/*---------------------------------------------------------
	TIMER & PWM
--------------------------------------------------------- */
void smtTIMERSetMode(TimerChannel channel, TimerProperty *ptimer);
void smtTIMERGetMode(TimerChannel channel, TimerProperty *ptimer);
void smtTIMERClrCount(TimerChannel channel);
void smtTIMEROperation(TimerChannel channel, TimerProperty *ptimer);

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
void smtWDTSetMode(WdtProperty *pwdt);
void smtWDTGetMode(WdtProperty *pwdt);
void smtWDTGetCount(smtUint16 *pcount);
void smtWDTClearISR(void);
void smtWDTGetISR(smtUint8 *pintrStatus);

#endif /* __LIB_H__ */

