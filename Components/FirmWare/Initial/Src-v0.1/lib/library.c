/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File Name	: library.c 
	Description	: Basic peripheral library file
	Created by	: SHMT SOC Team
----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
	INCLUDE
///////////////////////////////////////////////////////// */
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "sysinc.h"
#include "structdef.h"
#include "commonmacro.h"

#include "lib.h"

#define GLOBAL_DEFINE
#include "global.h"


/*/////////////////////////////////////////////////////////
	FUNCTION
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	Function name	: smtGpioSetDir()
	Prototype		: smtBoolean smtGpioSetDir(GPIO_STRUCT gpio);
	Return			: smtBoolean
	Argument 		: GPIO type & GPIO mode
	Comments		: Set the GPIO mode
----------------------------------------------------------*/
smtBoolean smtGpioSetDir(GPIO_STRUCT gpio)
{
	// GPIO#, mode
	switch(gpio.gpioNum)
	{
		case GPIO0_TYPE :
			SMT_WRITE(GPIO0_OE, gpio.gpioMode);
			break;
		case GPIO1_TYPE :
			SMT_WRITE(GPIO1_OE, gpio.gpioMode);
			break;
		default :
			return SMT_ERROR;
	}

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smtGpioGetDir()
	Prototype		: smtUint16 smtGpioGetDir(GPIO_STRUCT gpio);
	Return			: smtUint16 - GPIO mode
	Argument 		: GPIO type
	Comments		: Get the GPIO mode
----------------------------------------------------------*/
smtBoolean smtGpioGetDir(GPIO_STRUCT gpio)
{
	// GPIO#
	switch(gpio.gpioNum)
	{
		case GPIO0_TYPE :
			gpio.gpioMode = SMT_READ(GPIO0_OE);
			break;
		case GPIO1_TYPE :
			gpio.gpioMode = SMT_READ(GPIO1_OE);
			break;
		default :
			return SMT_ERROR;
	}

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smtGpioSetData()
	Prototype		: smtBoolean smtGpioSetData(GPIO_STRUCT gpio);
	Return			: smtBoolean
	Argument		: GPIO type & GPIO data
	Comments		: Set the GPIO data
----------------------------------------------------------*/
smtBoolean smtGpioSetData(GPIO_STRUCT gpio, smtUint8 gpioData)
{
	// GPIO#, mode
	switch(gpio.gpioNum)
	{
		case GPIO0_TYPE :
			SMT_WRITE(GPIO0_OUT, gpioData); //gpio.gpioData);
			break;
		case GPIO1_TYPE :
			SMT_WRITE(GPIO1_OUT, gpioData); //gpio.gpioData);
			break;
		default :
			return SMT_ERROR;
	}

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smtGpioGetData()
	Prototype		: smtBoolean smtGpioGetData(GPIO_STRUCT gpio);
	Return			: smtUint8
	Argument		: GPIO type & GPIO mode
	Comments		: Get the GPIO data
----------------------------------------------------------*/
smtBoolean smtGpioGetData(GPIO_STRUCT gpio, smtUint8 gpioData)
{
	// GPIO#
	switch(gpio.gpioNum)
	{
		case GPIO0_TYPE :
			gpioData = SMT_READ(GPIO0_IN);
			break;
		case GPIO1_TYPE :
			gpioData = SMT_READ(GPIO1_IN);
			break;
		default :
			return SMT_ERROR;
	}

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smtADCSetMode()
	Prototype		: smtBoolean smtADCSetMode(GPIO_STRUCT gpio);
	Return			: smtBoolean
	Argument		: ADC mode & channel
	Comments		: Set ADC mode
----------------------------------------------------------*/
smtBoolean smtADCSetMode(ADC_STRUCT adc)
{
	// Standby mode
	if(adc.opMode == ADC_STANDBY)
	{
		SMT_WRITE(ADCCON, 
		SMT_READ(ADCCON) | (ADC_STANDBY<<SHIFT_DN_FROM_MASK(ADC_STBY)) );
		return SMT_SUCCESS;
	}

	// Normal operation mode
	SMT_WRITE(ADCCON, 
		0x0<<SHIFT_DN_FROM_MASK(ADENABLE) |
		adc.adcEnable<<SHIFT_DN_FROM_MASK(ADC_READ_START) |
		ADC_NORMAL<<SHIFT_DN_FROM_MASK(ADC_STBY)       |
		adc.adcChanSel<<SHIFT_DN_FROM_MASK(ADC_IN_SEL) );

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smtADCDataRead()
	Prototype		: smtUint16 smtADCDataRead(void);
	Return			: smtUint16 - ADC data
	Argument		:
	Comments		: Read ADC data
----------------------------------------------------------*/
smtUint16 smtADCDataRead(void)
{
	smtUint16 adcData;

	// When ADC standby mode is.
	if(SMT_READ(ADCCON)&ADC_STBY == SMT_TRUE)
		return SMT_ERROR;       // A/D data is garbage

	// Wait until ADC operation is finished.
	// Need to ISR routine concern
	while((ADC_FLAG & SMT_READ(ADCCON)) != 1);

	adcData = SMT_READ(ADCDAT);

	return adcData;
}

// Global variable for the power management
PM_POWER gPwr;
/*----------------------------------------------------------
	Function name	: smtPower()
	Prototype		: smtUint16 smtPower(void);
	Return			: smtUint16 - ADC data
	Argument		:
	Comments		: Set power mode
----------------------------------------------------------*/
smtBoolean smtPower(POWER_MODE pwrMode)
{
	GPIO_STRUCT gpio;

	switch(pwrMode)
	{
		case PWR_NORMAL :
			SMT_WRITE(SYSCON,
				PWR_NORMAL<<SHIFT_DN_FROM_MASK(STOP_CTL) |
				gPwr.sclkDiv<<SHIFT_DN_FROM_MASK(SYS_CLK_DIV) |
				gPwr.uclkDiv<<SHIFT_DN_FROM_MASK(UART_CLK_DIV) |
				gPwr.gie<<SHIFT_DN_FROM_MASK(SYS_GIE_EN) |
				gPwr.uartIntSel<<SHIFT_DN_FROM_MASK(UART_INT_SEL) |
				gPwr.aclkDiv<<SHIFT_DN_FROM_MASK(ADC_CLK_DIV) );
			break;

		case PWR_DOWN :     // Enable EINT, GIE enable, power-down mode start
			//SMT_WRITE(GPIO_CON0, GPIO_EINTSET);
			gpio.gpioNum = GPIO0_TYPE;
			gpio.gpioMode = GPIO0_EINT;
			smtGpioSetDir(gpio);

			if(SMT_READ(INTMSK)&0xf00f == 0)    // EINT0~7 interrupt mask check
			{
				//EnableIRQ(IRQ_EINT0);
				SMT_WRITE(INTMSK, 0xf00f);          // EINT0~7 interrupt mask enable
			}

			SMT_WRITE(SYSCON, SYS_GIE_EN | STOP_CTL);    // Power-down mode

#ifdef __ARM_GCC_USE__
			__asm__
			(
				"nop\n\t" \
				"nop\n\t" \
				"nop\n\t" \
				"nop\n\t" \
			);
#else
			__asm
			{
				nop;
				nop;
				nop;
				nop;
			}
#endif
		break;

		case PWR_SLOW :
			SMT_WRITE(SYSCON, 
			SMT_READ(SYSCON) | gPwr.sclkDiv<< SHIFT_DN_FROM_MASK(SYS_CLK_DIV) );
			break;

		default :
			return SMT_ERROR;
	}

    return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smtTimerSetMode()
	Prototype		: smtBoolean smtTimerSetMode(void);
	Return			: smtBoolean
	Argument		:
	Comments		: Set timer mode
----------------------------------------------------------*/
smtBoolean smtTimerSetMode(TIMER_STRUCT timer, TIMER_SEL timerSel)
{
	smtUint32 addr;

	addr = TPRE_START + 0x20*timerSel;
	//SMT_WRITE(TPRE0, TIMER0_PRE);
	SMT_WRITE((*(volatile unsigned*)addr), timer.prescale);

	if(!TIMER_CAPTURE)
	{
		addr = TDAT_START + 0x20*timerSel;
		//SMT_WRITE(TDAT0, TIMER0_DAT);
		SMT_WRITE((*(volatile unsigned*)addr), timer.data);
	}

	addr = TCON_START + 0x20*timerSel;

	//SMT_WRITE(TCON0, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
	SMT_WRITE((*(volatile unsigned*)addr),
		timer.phase<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) |
		timer.clk<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) |
		timer.opMode<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
		timer.timerClear<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR) );
		//timer.timerEn<<SHIFT_DN_FROM_MASK(TIMER_EN) );

    return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smtTimerOperation()
	Prototype		: smtBoolean smtTimerOperation(void);
	Return			: smtBoolean
	Argument		:
	Comments		: 
		Timer start or stop
		You need to GPIO set before use the smtTimerOperatoin().
		ex)
		GPIO_STRUCT gpio;
		gpio.gpioMode = ;
		gpio.gpioNum = ;
		smtGpioSetDir(GPIO_STRUCT gpio);

		smtTimerOperation(timer, timerSel);
----------------------------------------------------------*/
smtBoolean smtTimerOperation(TIMER_STRUCT timer, TIMER_SEL timerSel)
{
	smtUint32 addr;
	if(timer.timerEn == SMT_TRUE)       // When timer enable
		smtTimerSetMode(timer, timerSel);

	addr = TCON_START + 0x20*timerSel;
	SMT_WRITE((*(volatile unsigned*)addr),
	SMT_READ((*(volatile unsigned*)addr)) | timer.timerEn);

	return SMT_SUCCESS;
}
