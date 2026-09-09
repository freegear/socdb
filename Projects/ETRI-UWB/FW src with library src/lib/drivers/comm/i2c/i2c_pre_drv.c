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
/*
//////////////////////////////////////////////////////////////////////////////
        INCLUDE
//////////////////////////////////////////////////////////////////////////////
*/
#include "sysinc.h"
#include "structdef.h"
#include "commonmacro.h"

#include "i2c_pre_drv.h"

/*
//////////////////////////////////////////////////////////////////////////////
        DEFINITIOIN
//////////////////////////////////////////////////////////////////////////////
*/


/*
//////////////////////////////////////////////////////////////////////////////
        FUNCTION
//////////////////////////////////////////////////////////////////////////////
*/

/*----------------------------------------------------------
	Function name	: smtI2CSetCtrl
	Prototype		: void smtI2CSetCtrl(I2C_CTRL_STRUCT i2cCtrl)
	Return		: void
	Argument	:
-----------------------------------------------------------*/
void smtI2CSetCtrl(I2C_CTRL_STRUCT i2cCtrl)
{
	// I2C Controller Setting
	SMT_WRITE(I2CCON,
		(1<<12)
		| ((i2cCtrl.txPrescale & 0xfff)	<< 4)
		| ((i2cCtrl.intPendFlag & 0x1)	<< 3)	// not interrupt pending clear
		| ((i2cCtrl.opMode	& 0x1)		<< 2)	// Master TX Mode
		| ((i2cCtrl.ackEn & 0x1)		<< 1)	// Send Ack
		| ((i2cCtrl.txRxIntEn & 0x1)		<< 0) );	// Interrupt Enable
}

/*----------------------------------------------------------
	Function name	: smtI2CGetCtrl
	Prototype		: void smtI2CGetCtrl(I2C_CTRL_STRUCT i2cCtrl)
	Return		: void
	Argument	:
-----------------------------------------------------------*/
void smtI2CGetCtrl(I2C_CTRL_STRUCT *i2cCtrl)
{
	smtUint32 rdData;
	rdData = SMT_READ(I2CCON);

	i2cCtrl->txPrescale	= (rdData >> 4) & 0xFFF;	// Prescaler
	i2cCtrl->intPendFlag	= (rdData >> 3) & 0x1;		// Pending status
	i2cCtrl->opMode	= (rdData >> 2) & 0x1;		// Master Tx Mode
	i2cCtrl->ackEn		= (rdData >> 1) & 0x1;		// Send Ack
	i2cCtrl->txRxIntEn	= (rdData >> 0) & 0x1;		// Interrupt Enable
}

/*----------------------------------------------------------
	Function name	: smtI2CSWReset
	Prototype		: void smtI2CSWReset(void)
	Return		: void
	Argument	:
-----------------------------------------------------------*/
void smtI2CSWReset(void)
{
	smtUint32 rdData;
	rdData = SMT_READ(I2CCON);

	SMT_WRITE(I2CSTA, rdData | (0x1 << 16) );
}

/*----------------------------------------------------------
	Function name	: smtI2CGetStatus
	Prototype		: void smtI2CGetStatus(I2C_STATUS_STRUCT i2cStat)
	Return		: void
	Argument	:
-----------------------------------------------------------*/
void smtI2CGetStatus(I2C_STATUS_STRUCT *i2cStat)
{
	smtUint32 rdData;
	rdData = SMT_READ(I2CSTA);

	//i2cStat->outputEn	= (rdData >> 5) & 0x1;		// OutputEn
	//i2cStat->startStop	= (rdData >> 4) & 0x1;		// StartStop
	i2cStat->busBusy	= (rdData >> 3) & 0x1;		// BusBusy
	i2cStat->arbitSta	= (rdData >> 2) & 0x1;		// ArbitSta
	i2cStat->ackValue	= (rdData >> 1) & 0x1;		// AckValue
	i2cStat->busError	= (rdData >> 0) & 0x1;		// BusError
}

/*----------------------------------------------------------
	Function name	: smtI2CEnable
	Prototype		: void smtI2CEnable(smtUint8 enable)
	Return		: void
	Argument	:
-----------------------------------------------------------*/
void smtI2CEnable(smtUint8 enable)
{
	smtUint32 rdData;
	rdData = SMT_READ(I2CSTA);

	SMT_WRITE(I2CSTA, (smtUint32)((enable & 0x1) << 4) );
}


/*----------------------------------------------------------
	Function name	: smtI2CInterruptWait
	Prototype		: void smtI2CInterruptWait(void)
	Return		: void
	Argument	:
-----------------------------------------------------------*/
void smtI2CInterruptWait(void)
{
	smtUint32 data;
	while(1)
	{
		data = SMT_READ(I2CCON);
		if(data & (1<<3))
			break;
	}
}

/*----------------------------------------------------------
	Function name	: smtI2CInterruptPendingClear
	Prototype		: void smtI2CInterruptPendingClear(void)
	Return		: void
	Argument	:
-----------------------------------------------------------*/
void smtI2CInterruptPendingClear(void)
{
	smtUint32 data;

	data = SMT_READ(I2CCON);
	SMT_WRITE(I2CCON, data | (1<<3));
}

/*----------------------------------------------------------
	Function name	: smtI2CInterruptPended
	Prototype		: smtInt32 smtI2CInterruptPended(void)
	Return		: void
	Argument	:
-----------------------------------------------------------*/
smtInt32 smtI2CInterruptPended(void)
{
	smtUint32 data;
	data = SMT_READ(I2CCON);
	return (data & (1<<3));
}


/*----------------------------------------------------------
	Function name	: smtI2CWrite
	Prototype		: void smtI2CWrite(I2C_CTRL_STRUCT i2cCtrl, smtUint8 addr, smtUint8 data)
	Return		: void
	Argument	:
		I2C struct
		I2C slave addr
		I2C write data
	Comments	: 
		Write a data to I2C slave
-----------------------------------------------------------*/
smtUint32 smtI2CWrite(smtUint8 addr, smtUint8 subAddr, smtUint8 data)
{
	smtUint32 rdData;
	I2C_STATUS_STRUCT i2cStat;

	SMT_WRITE(I2CDATA, ((addr<<1)|0x00));

	rdData = SMT_READ(I2CSTA);	// ???
	if(smtI2CInterruptPended())
	{
		smtI2CEnable(0x1);
		smtI2CInterruptPendingClear();
	}
	else
		smtI2CEnable(0x1);

	smtI2CInterruptWait();

	// status check
	smtI2CGetStatus(&i2cStat);
	if (i2cStat.arbitSta == 0x1)
		goto arbitStaError;
	else if(i2cStat.ackValue == 0x1)
		goto nACKValue;


	SMT_WRITE(I2CDATA, subAddr);       // Sub Addr Transmitt
	smtI2CInterruptPendingClear();
	smtI2CInterruptWait();

	// status check
	smtI2CGetStatus(&i2cStat);
	if (i2cStat.arbitSta == 0x1)
		goto arbitStaError;
	else if(i2cStat.ackValue == 0x1)
		goto nACKValue;

	SMT_WRITE(I2CDATA, data);
	smtI2CInterruptPendingClear();
	smtI2CInterruptWait();

	// status check
	smtI2CGetStatus(&i2cStat);
	if (i2cStat.arbitSta == 0x1)
		goto arbitStaError;
	else if(i2cStat.ackValue == 0x1)
		goto nACKValue;

	SMT_WRITE(I2CSTA, (rdData & (~(1UL<<4))));		// Stop
	smtI2CInterruptPendingClear();
	smtI2CInterruptWait();

	return 0;

arbitStaError :
	return ARBIT_LOST;
nACKValue :
	return BUS_ERROR;
}

/*----------------------------------------------------------
	Function name	: smtI2CRead
	Prototype		: void smtI2CRead(I2C_CTRL_STRUCT i2cCtrl, smtUint8 addr, smtUint8 data)
	Return		: void
	Argument	:
		I2C struct
		I2C slave address
		I2C read data
	Comments	: 
		Read a data from I2C slave
-----------------------------------------------------------*/
smtUint32 smtI2CRead(smtUint8 addr, smtUint8 subAddr, smtUint8 *data)
{
	smtUint32 rdData;
	I2C_STATUS_STRUCT i2cStat;
	I2C_CTRL_STRUCT i2cCtrl;

	SMT_WRITE(I2CDATA, ((addr<<1)|0x00));

	rdData = SMT_READ(I2CSTA);	// ???
	if(smtI2CInterruptPended())
	{
		smtI2CEnable(0x1);
		smtI2CInterruptPendingClear();
	}
	else
		smtI2CEnable(0x1);

	smtI2CInterruptWait();

	// status check
	smtI2CGetStatus(&i2cStat);
	if (i2cStat.arbitSta == 0x1)
		goto rxArbitStaError;
	else if(i2cStat.ackValue == 0x1)
		goto rXnACKValue;

	SMT_WRITE(I2CDATA, subAddr);       // Sub Addr Transmitt
	smtI2CInterruptPendingClear();
	smtI2CInterruptWait();

	// status check
	smtI2CGetStatus(&i2cStat);
	if (i2cStat.arbitSta == 0x1)
		goto rxArbitStaError;
	else if(i2cStat.ackValue == 0x1)
		goto rXnACKValue;

	// Repeated Stop

	SMT_WRITE(I2CDATA, ((addr<<1)|0x01));

	rdData = SMT_READ(I2CSTA);	// ???
	smtI2CEnable(0x1);
	smtI2CInterruptPendingClear();
	smtI2CInterruptWait();

	smtI2CGetStatus(&i2cStat);
	if (i2cStat.arbitSta == 0x1)
		goto rxArbitStaError;
	else if(i2cStat.ackValue == 0x1)
		goto rXnACKValue;

	smtI2CGetCtrl(&i2cCtrl);
	i2cCtrl.opMode = 0x0;			// RxMode
	i2cCtrl.ackEn = 0x0;			// Nack enable
	smtI2CSetCtrl(i2cCtrl);

	smtI2CInterruptPendingClear();

	smtI2CInterruptWait();
	*data = SMT_READ(I2CDATA);

	rdData = SMT_READ(I2CSTA);	// ???
	smtI2CEnable(0x0);
	smtI2CInterruptPendingClear();
	smtI2CInterruptWait();
	
	rdData = SMT_READ(I2CCON);
	i2cCtrl.opMode = 0x1;			// TxMode
	smtI2CSetCtrl(i2cCtrl);

	return 0;

rxArbitStaError :
	return ARBIT_LOST;
rXnACKValue :
	return BUS_ERROR;
}

/*----------------------------------------------------------
	Function name	: smtI2CInit
	Prototype		: void smtI2CInit(smtUint8 prescaler)
	Return		: 
	Argument	: Prescale value
	Comments	: 
		Initialize I2C
-----------------------------------------------------------*/
void smtI2CInit(smtUint16 prescaler)
{   
	static smtInt32 initialized = 0;
	I2C_CTRL_STRUCT i2cCtrl;

	if(initialized)	return;
	initialized = 1;

	i2cCtrl.txPrescale	= prescaler;
	i2cCtrl.intPendFlag	= 0;
	i2cCtrl.opMode	= 1;
	i2cCtrl.ackEn		= 1;
	i2cCtrl.txRxIntEn	= 1;

	// I2C Controller Setting
	SMT_WRITE(I2CCON,
		(1<<12)
		| ((i2cCtrl.txPrescale & 0xfff)	<< 4)
		| ((i2cCtrl.intPendFlag & 0x1)	<< 3)	// not interrupt pending clear
		| ((i2cCtrl.opMode	& 0x1)		<< 2)	// Master TX Mode
		| ((i2cCtrl.ackEn & 0x1)			<< 1)	// Send Ack
		| ((i2cCtrl.txRxIntEn & 0x1)		<< 0));	// Interrupt Enable
}
