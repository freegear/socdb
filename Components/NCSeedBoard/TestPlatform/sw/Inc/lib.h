/*-------------------------------------------------------------------
File name   : lib.h

Description : middle level routines
---------------------------------------------------------------------- */
#ifndef __LIB_H__
#define __LIB_H__

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */

#include "sysinc.h"
#include "structDef.h"
#include "Commonmacro.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

/* UART */
/*
macro_SET/GET(x,y)
	SET	-> Write data to register
	GET	-> Read data from register
	x	-> register
	y	-> data (bit mask)
macro_SET/GET(x,y,z)
	z	-> shift count
*/

#define UART_RX_ENABLE(x, y)    	{SMT_WRITE(x, (SMT_READ(x)&~(signed)y) | y)}
#define UART_TX_ENABLE(x,y)     	{SMT_WRITE(x, (SMT_READ(x)&~(signed)y) | y)}
#define UART_LOOPBACK_ENABLE(x,y)	{SMT_WRITE(x, (SMT_READ(x)&~(signed)y) | y)}
#define UART_ENABLE(x,y)			{SMT_WRITE(x, (SMT_READ(x)&~(signed)y) | y)}

#define UART_RX_DISABLE(x,y)    	{SMT_WRITE(x, (SMT_READ(x)&~(signed)y))}
#define UART_TX_DISABLE(x,y)    	{SMT_WRITE(x, (SMT_READ(x)&~(signed)y))}
#define UART_LOOPBACK_DISABLE(x,y)	{SMT_WRITE(x, (SMT_READ(x)&~(signed)y))}
#define UART_DIASBLE(x,y)			{SMT_WRITE(x, (SMT_READ(x)&~(signed)y))}

#define UART_INT_FIFO_LEVEL_SET(x, y, z)		\
	{SMT_WRITE(x, 								\
		SMT_READ(x)& ~(y<<SHIFT_DN_FROM_MASK(z))\
		| y<<SHIFT_DN_FROM_MASK(z))}

#define UART_INT_FIFO_LEVEL_GET(x, y, z)		\
	{y = ((smtUint8)(SMT_READ(x) & z))>>z;}


#define UART_INT_CLEAR(x,y)		{SMT_WRITE(x, y)}
#define UART_INT_MASK_CLR(x,y)	{SMT_WRITE(x, SMT_READ(x)&~y)}
#define UART_INT_MASK_SET(x,y)	{SMT_WRITE(x, (SMT_READ(x)&~y) |y)}
#define UART_INT_MASK_GET(x,y)  {y = (smtUint16)(SMT_READ(x));}

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

smtBoolean smtDelay100us(int time);

/*---------------------------------------------------------
        MEMORY
--------------------------------------------------------- */
/* FMC */
smtBoolean smtFMCSetMode(FMC_STRUCT fmc);
smtBoolean smtFMWrite(FM_STRUCT flashWrite);
smtUint32 smtFMRead(smtUint32 addr);
smtBoolean smt2FMProgramNormal(smtUint32 addr, smtUint32 *data, smtUint32 length);
smtBoolean smt2FMProgramOption(FM_OPTION_TYPE optionType, smtUint32 sector);
smtBoolean smt2FMErase(FM_OPERATION_MODE eraseType, smtUint32 sector);
/* ESMC */
smtBoolean smtMemoryWrite(smtUint32 addr, smtUint32 *data, smtUint32 length);
smtBoolean smtMemoryRead(smtUint32 addr, smtUint32 *data, smtUint32 length);

/*---------------------------------------------------------
        UART
--------------------------------------------------------- */
smtBoolean smtUartSetBaudRate(smtUint32 baudRate);
smtBoolean smtUartSetMode(UART_STRUCT *uart, UART_MODE mode);
smtBoolean smtUartCharWrite(smtInt8 data);
smtUint8 smtUartCharRead(smtUint32 waitTime);
smtBoolean smtUartStrWrite(smtInt8 *pData);
smtBoolean smtUartStrRead(smtUint8 *pData, smtUint8 dataCnt);
smtBoolean smtUartPrint(int dispLvl, char *fmt, ...);

/*---------------------------------------------------------
        I2C
--------------------------------------------------------- */
void smtI2CSetMode(I2C_STRUCT i2c);
smtBoolean smt2I2CWrite(smtUint8 slaveAddr, smtUint8 *data, smtUint8 length);
smtBoolean smt2I2CRead(smtUint8 slaveAddr, smtUint8 *data, smtUint8 length);
void smtI2CMasterHandler(void);
void smtI2CSlaveHandler(void);

/*---------------------------------------------------------
        TIMER & PWM
--------------------------------------------------------- */
smtBoolean smtTimerSetMode(TIMER_STRUCT timer, TIMER_SEL timerSel);
smtBoolean smtTimerOperation(TIMER_STRUCT timer, TIMER_SEL timerSel);
smtBoolean smtWDTSetMode(WDT_STRUCT wdt);
smtBoolean smtWDTOperation(WDT_STRUCT wdt);

/*---------------------------------------------------------
        GPIO
--------------------------------------------------------- */
smtBoolean smtGpioSetDir(GPIO_STRUCT gpio);
smtUint16 smtGpioGetDir(GPIO_STRUCT gpio);
smtBoolean smtGpioSetData(GPIO_STRUCT gpio, smtUint8 gpioData);
smtUint8 smtGpioGetData(GPIO_STRUCT gpio);

/*---------------------------------------------------------
        VIC (Vectored Interrupt Controller)
--------------------------------------------------------- */


/*---------------------------------------------------------
        ADC
--------------------------------------------------------- */
smtBoolean smtADCSetMode(ADC_STRUCT adc);
smtUint16 smtADCDataRead(void);

/*---------------------------------------------------------
        POWER MANAGEMENT
--------------------------------------------------------- */
smtBoolean smtPower(POWER_MODE pwrMode);

#endif /* __LIB_H__ */

