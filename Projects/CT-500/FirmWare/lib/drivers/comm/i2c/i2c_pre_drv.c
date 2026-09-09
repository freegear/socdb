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
	Prototype		: void smtI2CSetCtrl(I2cCtrl *pi2cCtrl)
	Return		: void
	Argument	:
-----------------------------------------------------------*/
void smtI2CSetCtrl(I2cCtrl *pi2cCtrl)
{
	// I2C Controller Setting
	SMT_WRITE(I2CCON,
		(1<<12)
		| ((pi2cCtrl->txPrescale & 0xfff)	<< 4)
		| ((pi2cCtrl->intPendFlag & 0x1)	<< 3)	// not interrupt pending clear
		| ((pi2cCtrl->opMode	& 0x1)		<< 2)	// Master TX Mode
		| ((pi2cCtrl->ackEn & 0x1)		<< 1)	// Send Ack
		| ((pi2cCtrl->txRxIntEn & 0x1)		<< 0) );	// Interrupt Enable
}

/*----------------------------------------------------------
	Function name	: smtI2CGetCtrl
	Prototype		: void smtI2CGetCtrl(I2cCtrl *pi2cCtrl)
	Return		: void
	Argument	:
-----------------------------------------------------------*/
void smtI2CGetCtrl(I2cCtrl *pi2cCtrl)
{
	smtUint32 rdData;
	rdData = SMT_READ(I2CCON);

	pi2cCtrl->txPrescale	= (rdData >> 4) & 0xFFF;	// Prescaler
	pi2cCtrl->intPendFlag	= (rdData >> 3) & 0x1;		// Pending status
	pi2cCtrl->opMode	= (rdData >> 2) & 0x1;		// Master Tx Mode
	pi2cCtrl->ackEn		= (rdData >> 1) & 0x1;		// Send Ack
	pi2cCtrl->txRxIntEn	= (rdData >> 0) & 0x1;		// Interrupt Enable
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
	Prototype		: void smtI2CGetStatus(I2cStatus *pi2cStat)
	Return		: void
	Argument	:
-----------------------------------------------------------*/
void smtI2CGetStatus(I2cStatus *pi2cStat)
{
	smtUint32 rdData;
	rdData = SMT_READ(I2CSTA);

	//pi2cStat->outputEn	= (rdData >> 5) & 0x1;		// OutputEn
	//pi2cStat->startStop	= (rdData >> 4) & 0x1;		// StartStop
	pi2cStat->busBusy	= (rdData >> 3) & 0x1;		// BusBusy
	pi2cStat->arbitSta	= (rdData >> 2) & 0x1;		// ArbitSta
	pi2cStat->ackValue	= (rdData >> 1) & 0x1;		// AckValue
	pi2cStat->busError	= (rdData >> 0) & 0x1;		// BusError
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
	Function name	: smtI2CWaitInterrupt
	Prototype		: void smtI2CWaitInterrupt(void)
	Return		: void
	Argument	:
-----------------------------------------------------------*/
void smtI2CWaitInterrupt(void)
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
	Function name	: smtI2ClearCInterruptPending
	Prototype		: void smtI2ClearCInterruptPending(void)
	Return		: void
	Argument	:
-----------------------------------------------------------*/
void smtI2ClearCInterruptPending(void)
{
	smtUint32 data;

	data = SMT_READ(I2CCON);
	SMT_WRITE(I2CCON, data | (1<<3));
}

/*----------------------------------------------------------
	Function name	: smtI2CPendedInterrupt
	Prototype		: void smtI2CPendedInterrupt(smtInt32 *pstatus)
	Return		: void
	Argument	:
-----------------------------------------------------------*/
void smtI2CPendedInterrupt(smtInt32 *pstatus)
{
	smtUint32 data;
	data = SMT_READ(I2CCON);
	//return (data & (1<<3));
	*pstatus = (data &(1<<3));
}


/*----------------------------------------------------------
	Function name	: smt2I2CWrite
	Prototype		: void smt2I2CWrite(smtUint8 addr, smtUint8 subAddr, smtUint8 data)
	Return		: void
	Argument	:
		I2C struct
		I2C slave addr
		I2C write data
	Comments	: 
		Write a data to I2C slave
-----------------------------------------------------------*/
smtUint32 smt2I2CWrite(smtUint8 addr, smtUint8 subAddr, smtUint8 data)
{
	smtUint32 rdData;
	smtInt32 status;
	I2cStatus i2cStat;

	SMT_WRITE(I2CDATA, ((addr<<1)|0x00));

	rdData = SMT_READ(I2CSTA);	// ???
	smtI2CPendedInterrupt(&status);
	if(status)
	{
		smtI2CEnable(0x1);
		smtI2ClearCInterruptPending();
	}
	else
		smtI2CEnable(0x1);

	smtI2CWaitInterrupt();

	// status check
	smtI2CGetStatus(&i2cStat);
	if (i2cStat.arbitSta == 0x1)
		goto arbitStaError;
	else if(i2cStat.ackValue == 0x1)
		goto nACKValue;


	SMT_WRITE(I2CDATA, subAddr);       // Sub Addr Transmitt
	smtI2ClearCInterruptPending();
	smtI2CWaitInterrupt();

	// status check
	smtI2CGetStatus(&i2cStat);
	if (i2cStat.arbitSta == 0x1)
		goto arbitStaError;
	else if(i2cStat.ackValue == 0x1)
		goto nACKValue;

	SMT_WRITE(I2CDATA, data);
	smtI2ClearCInterruptPending();
	smtI2CWaitInterrupt();

	// status check
	smtI2CGetStatus(&i2cStat);
	if (i2cStat.arbitSta == 0x1)
		goto arbitStaError;
	else if(i2cStat.ackValue == 0x1)
		goto nACKValue;

	SMT_WRITE(I2CSTA, (rdData & (~(1UL<<4))));		// Stop
	smtI2ClearCInterruptPending();
	smtI2CWaitInterrupt();

	return 0;

arbitStaError :
	return ARBIT_LOST;
nACKValue :
	return BUS_ERROR;
}

/*----------------------------------------------------------
	Function name	: smt2I2CRead
	Prototype		: void smt2I2CRead(smtUint8 addr, smtUint8 subAddr, smtUint8 *pdata)
	Return		: void
	Argument	:
		I2C struct
		I2C slave address
		I2C read data
	Comments	: 
		Read a data from I2C slave
-----------------------------------------------------------*/
smtUint32 smt2I2CRead(smtUint8 addr, smtUint8 subAddr, smtUint8 *pdata)
{
	smtUint32 rdData;
	smtInt32 status;
	I2cStatus i2cStat;
	I2cCtrl i2cCtrl;

	SMT_WRITE(I2CDATA, ((addr<<1)|0x00));

	rdData = SMT_READ(I2CSTA);	// ???
	smtI2CPendedInterrupt(&status);
	if(status)
	{
		smtI2CEnable(0x1);
		smtI2ClearCInterruptPending();
	}
	else
		smtI2CEnable(0x1);

	smtI2CWaitInterrupt();

	// status check
	smtI2CGetStatus(&i2cStat);
	if (i2cStat.arbitSta == 0x1)
		goto rxArbitStaError;
	else if(i2cStat.ackValue == 0x1)
		goto rXnACKValue;

	SMT_WRITE(I2CDATA, subAddr);       // Sub Addr Transmitt
	smtI2ClearCInterruptPending();
	smtI2CWaitInterrupt();

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
	smtI2ClearCInterruptPending();
	smtI2CWaitInterrupt();

	smtI2CGetStatus(&i2cStat);
	if (i2cStat.arbitSta == 0x1)
		goto rxArbitStaError;
	else if(i2cStat.ackValue == 0x1)
		goto rXnACKValue;

	smtI2CGetCtrl(&i2cCtrl);
	i2cCtrl.opMode = 0x0;			// RxMode
	i2cCtrl.ackEn = 0x0;			// Nack enable
	smtI2CSetCtrl(&i2cCtrl);

	smtI2ClearCInterruptPending();

	smtI2CWaitInterrupt();
	*pdata = SMT_READ(I2CDATA);

	rdData = SMT_READ(I2CSTA);	// ???
	smtI2CEnable(0x0);
	smtI2ClearCInterruptPending();
	smtI2CWaitInterrupt();
	
	rdData = SMT_READ(I2CCON);
	i2cCtrl.opMode = 0x1;			// TxMode
	smtI2CSetCtrl(&i2cCtrl);

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
	I2cCtrl i2cCtrl;

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
