/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : i2c_pre_drv.c 
	Description : i2c Pre-layer driver
	Created by  : SHMT SOC Team
------------------------------------------------------------------------------*/
/*//////////////////////////////////////////////////////////////////////////////
        INCLUDE
//////////////////////////////////////////////////////////////////////////////*/
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "sysinc.h"
#include "structdef.h"
#include "commonmacro.h"

#include "lib.h"
#include "i2c_pre_drv.h"

/*//////////////////////////////////////////////////////////////////////////////
        DEFINITIOIN
//////////////////////////////////////////////////////////////////////////////*/


/*//////////////////////////////////////////////////////////////////////////////
        FUNCTION
//////////////////////////////////////////////////////////////////////////////*/

/*----------------------------------------------------------
	Function name	: smtI2CSetPreScaler
	Prototype		: void smtI2CSetPreScaler(smtUint16 preScale)
	Return		: 
	Argument	: prescaler value
	Comments	: 
		Set I2C prescale value
-----------------------------------------------------------*/
void smtI2CSetPreScaler(smtUint16 preScale)
{
	smtUint32 readData;

	readData = SMT_READ(I2CCON);
	SMT_WRITE(	I2CCON,	
		readData |((preScale << SHIFT_DN_FROM_MASK(TXPRE_MASK)) & TXPRE_MASK));	
}

/*----------------------------------------------------------
	Function name	: smtI2CGetPreScaler
	Prototype		: void smtI2CGetPreScaler(smtUint16 preScale)
	Return		: 
	Argument	: prescale value
	Comments	: 
		Get I2C prescale value
-----------------------------------------------------------*/
void smtI2CGetPreScaler(smtUint16 preScale)
{
	smtUint32 readData;

	readData = SMT_READ(I2CCON);
	preScale = (readData & TXPRE_MASK) >> SHIFT_DN_FROM_MASK(TXPRE_MASK);
}

/*----------------------------------------------------------
	Function name	: smtI2CIntPendClear
	Prototype		: void smtI2CIntPendClear(void)
	Return		: 
	Argument	:
	Comments	: 
-----------------------------------------------------------*/
void smtI2CIntPendClear(void)
{
	smtUint32 readData;

	readData = SMT_READ(I2CCON);
	SMT_WRITE(	I2CCON,		// Pending clear
		readData |((0x1 << SHIFT_DN_FROM_MASK(INTPEND_MASK)) & INTPEND_MASK));	
}

/*----------------------------------------------------------
	Function name	: smtI2CSetOpMode
	Prototype		: void smtI2CSetOpMode(smtUint8 operationMode)
	Return		: 
	Argument	: I2C operation mode
	Comments	: 
		Set I2C operation mode
-----------------------------------------------------------*/
void smtI2CSetOpMode(smtUint8 operationMode)
{
	smtUint32 readData;

	readData = SMT_READ(I2CCON);
	SMT_WRITE(	I2CCON,	
		readData |((operationMode << SHIFT_DN_FROM_MASK(OPERMODE_MASK)) & OPERMODE_MASK));	
}

/*----------------------------------------------------------
	Function name	: smtI2CGetOpMode
	Prototype		: void smtI2CGetOpMode(smtUint8 operationMode)
	Return		: 
	Argument	: operation mode
	Comments	: 
		Get I2C operation mode
-----------------------------------------------------------*/
void smtI2CGetOpMode(smtUint8 operationMode)
{
	smtUint32 readData;

	readData = SMT_READ(I2CCON);

	if ((readData & OPERMODE_MASK) == 0x0)
		operationMode = MASTER_RX;
	else
		operationMode = MASTER_TX;
}

/*----------------------------------------------------------
	Function name	: smtI2CSetAckEnable
	Prototype		: void smtI2CSetAckEnable(smtUint8 ackEnable)
	Return		: 
	Argument	: ack enable
	Comments	: 
		Set I2C ack en/disable
-----------------------------------------------------------*/
void smtI2CSetAckEnable(smtUint8 ackEnable)
{
	smtUint32 readData;

	readData = SMT_READ(I2CCON);
	SMT_WRITE(	I2CCON,	
		readData |((ackEnable << SHIFT_DN_FROM_MASK(ACKEN_MASK)) & ACKEN_MASK));	
}

/*----------------------------------------------------------
	Function name	: smtI2CGetAckEnable
	Prototype		: void smtI2CGetAckEnable(smtUint8 ackEnable)
	Return		: 
	Argument	: ack enable
	Comments	: 
		Get I2C ack en/disable
-----------------------------------------------------------*/
void smtI2CGetAckEnable(smtUint8 ackEnable)
{
	smtUint32 readData;

	readData = SMT_READ(I2CCON);

	if ((readData & ACKEN_MASK) == 0x0)
		ackEnable = SEND_NACK;
	else
		ackEnable = SEND_ACK;
}

/*----------------------------------------------------------
	Function name	: smtI2CSetTxRxIntEnable
	Prototype		: void smtI2CSetTxRxIntEnable(smtUint8 intEnable)
	Return		: 
	Argument	: interrupt enable
	Comments	: 
		Set I2C interrupt en/disable
-----------------------------------------------------------*/
void smtI2CSetTxRxIntEnable(smtUint8 intEnable)
{
	smtUint32 readData;

	readData = SMT_READ(I2CCON);
	SMT_WRITE(	I2CCON,	
		readData |((intEnable << SHIFT_DN_FROM_MASK(TXRXINTEN)) & TXRXINTEN));	
}

/*----------------------------------------------------------
	Function name	: smtI2CGetTxRxIntEnable
	Prototype		: void smtI2CGetTxRxIntEnable(smtUint8 intEnable)
	Return		: 
	Argument	: interrupt enable
	Comments	: 
		Get I2C interrupt en/disable
-----------------------------------------------------------*/
void smtI2CGetTxRxIntEnable(smtUint8 intEnable)
{
	smtUint32 readData;

	readData = SMT_READ(I2CCON);

	if ((readData & ACKEN_MASK) == 0x0)
		intEnable = INT_DISABLE;
	else
		intEnable = INT_ENABLE;
}

/*----------------------------------------------------------
	Function name	: smtI2CStart
	Prototype		: void smtI2CStart(smtBoolean startStop)
	Return		: 
	Argument	: start/stop
	Comments	: 
		I2C start/stop
-----------------------------------------------------------*/
void smtI2CStart(smtBoolean startStop)
{
	smtUint32 readData;

	readData = SMT_READ(I2CSTA);
	SMT_WRITE(	I2CSTA,	
		readData |((startStop << SHIFT_DN_FROM_MASK(START_MASK)) & START_MASK));	
}

/*----------------------------------------------------------
	Function name	: smtI2CGetStatus
	Prototype		: void smtI2CGetStatus(I2C_STATUS_STRUCT i2cStatus)
	Return		: 
	Argument	: I2C status
	Comments	: 
		Get I2C status
-----------------------------------------------------------*/
void smtI2CGetStatus(I2C_STATUS_STRUCT i2cStatus)
{
	smtUint32 readData;

	readData = SMT_READ(I2CCON);
	i2cStatus.intPendFlag	= (readData & INTPEND_MASK) >> SHIFT_DN_FROM_MASK(INTPEND_MASK);

	readData = SMT_READ(I2CSTA);
	i2cStatus.busBusy	= (readData & BUSBUSY_MASK) >> SHIFT_DN_FROM_MASK(BUSBUSY_MASK);
	i2cStatus.arbitSta		= (readData & ARBITSTA_MASK) >> SHIFT_DN_FROM_MASK(ARBITSTA_MASK);
	i2cStatus.ackValue	= (readData & ACK_MASK) >> SHIFT_DN_FROM_MASK(ACK_MASK);
}

/*----------------------------------------------------------
	Function name	: smt2I2CWrite
	Prototype		: smtUint32 smt2I2CWrite(I2C_CTRL_STRUCT i2cCtrl, smtUint8 addr, smtUint8 data)
	Return		: Error return
	Argument	:
		I2C struct
		I2C slave addr
		I2C write data
	Comments	: 
		Write a data to I2C slave
-----------------------------------------------------------*/
smtUint32 smt2I2CWrite(I2C_CTRL_STRUCT i2cCtrl, smtUint8 addr, smtUint8 data)
{
	I2C_STATUS_STRUCT status;

	// 1. Prescaler setting
	smtI2CSetPreScaler(i2cCtrl.txPrescale);
	smtI2CSetOpMode(0x1);			// Master Tx mode
	smtI2CSetAckEnable(i2cCtrl.ackEn);
	smtI2CSetTxRxIntEnable(i2cCtrl.txRxIntEn);

	// 2. Start addr + W bit set
	SMT_WRITE(I2CDAT, addr|0x1);
	// 3. I2C write start
	smtI2CStart(0x1);	// I2C start

	// 4. Wait until interrupt pending
	while ((SMT_READ(I2CCON) & INTPEND_MASK) == 0)
	{
		;	// Wait until interrupt pending occurs
	}

	// 5. Check error & arbitration
	smtI2CGetStatus(status);
	if (status.busBusy == 0x1)
		return SMT_ERROR;	// ???
	if (status.arbitSta == 0x1)
		return SMT_ERROR;	// ???
	if (status.ackValue == 0x1)
		return SMT_ERROR;	// ???

	// 6. Data write
	SMT_WRITE(I2CDAT, data);

	// 7. Interrupt pending clear
	smtI2CIntPendClear();

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smt2I2CRead
	Prototype		: smtUint32 smt2I2CRead(I2C_CTRL_STRUCT i2cCtrl, smtUint8 addr, smtUint8 data)
	Return		: Error return
	Argument	:
		I2C struct
		I2C slave address
		I2C read data
	Comments	: 
		Read a data from I2C slave
-----------------------------------------------------------*/
smtUint32 smt2I2CRead(I2C_CTRL_STRUCT i2cCtrl, smtUint8 addr, smtUint8 data)
{
	smtUint32 readData;
	I2C_STATUS_STRUCT status;

	// 1. Prescaler setting
	smtI2CSetPreScaler(i2cCtrl.txPrescale);
	smtI2CSetOpMode(0x1);			// Master Tx mode
	smtI2CSetAckEnable(i2cCtrl.ackEn);
	smtI2CSetTxRxIntEnable(i2cCtrl.txRxIntEn);

	// 2. Start addr + W bit set
	SMT_WRITE(I2CDAT, addr|0x1);
	// 3. I2C write start
	smtI2CStart(0x1);	// I2C start

	// 4. Wait until interrupt pending
	while ((SMT_READ(I2CCON) & INTPEND_MASK) == 0)
	{
		;	// Wait until interrupt pending occurs
	}
	//smtI2CIntPendClear();	// ???

	// 5. Check error & arbitration
	smtI2CGetStatus(status);
	if (status.busBusy == 0x1)
		return SMT_ERROR;	// ???
	if (status.arbitSta == 0x1)
		return SMT_ERROR;	// ???
	if (status.ackValue == 0x1)
		return SMT_ERROR;	// ???

	// 6. Data write
	SMT_WRITE(I2CDAT, data);

	// 7. Operation mode modify and ack bit set
	smtI2CSetOpMode(0x0);		// Master Rx mode
	// ack bit set

	// 8. Interrupt pending clear
	smtI2CIntPendClear();

	// 9. Wait until interrupt pending
	while ((SMT_READ(I2CCON) & INTPEND_MASK) == 0)
	{
		;	// Wait until interrupt pending occurs
	}
	smtI2CIntPendClear();

	// 10. Read data
	readData = SMT_READ(I2CDAT);

	data = (smtUint8)readData;

	return SMT_SUCCESS;
}

