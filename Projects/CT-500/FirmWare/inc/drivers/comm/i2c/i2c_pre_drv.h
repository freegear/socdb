/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File name		: uart_pre_drv.h
	Description		: Uart Pre-layer driver
------------------------------------------------------------------------------*/
#ifndef __I2C_PRE_DRV_H__
#define __I2C_PRE_DRV_H__

/*
//////////////////////////////////////////////////////////////////////////////
	INCLUDE
//////////////////////////////////////////////////////////////////////////////
*/
#include "global.h"
#include "commonmacro.h"

/*
//////////////////////////////////////////////////////////////////////////////
        DEFINITION
//////////////////////////////////////////////////////////////////////////////
*/
// Control register
#define TXPRE_MASK			(0x1FFUL)<<4
#define INTPEND_MASK		(0x1UL)<<3
#define OPERMODE_MASK		(0x1UL)<<2
#define ACKEN_MASK			(0x1UL)<<1
#define TXRXINTEN			(0x1UL)<<0

//Status register
#define OUTPUTEN_MASK		(0x1UL)<<5
#define START_MASK			(0x1UL)<<4
#define BUSBUSY_MASK		(0x1UL)<<3
#define ARBITSTA_MASK		(0x1UL)<<2
#define ACK_MASK			(0x1UL)<<1
#define BUSERROR_MASK		(0x1UL)<<0

// Data register
#define  DATA_MASK			(0xFFUL)<<0


#define BUS_ERROR 1
#define ARBIT_LOST 2


typedef struct
{
	smtUint16 txPrescale;
	smtUint8 intPendFlag;
	smtUint8 opMode;
	smtUint8 ackEn;
	smtUint8 txRxIntEn;
} I2cCtrl;

typedef struct
{
	smtBoolean outputEn;
	smtBoolean startStop;
	smtBoolean busBusy;
	smtBoolean arbitSta;
	smtBoolean ackValue;
	smtBoolean busError;
} I2cStatus;

/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

void smtI2CSetCtrl(I2cCtrl *pi2cCtrl);
void smtI2CGetCtrl(I2cCtrl *pi2cCtrl);
void smtI2CSWReset(void);
void smtI2CGetStatus(I2cStatus *pi2cStat);
void smtI2CEnable(smtUint8 enable);
void smtI2CWaitInterrupt(void);
void smtI2ClearCInterruptPending(void);
void smtI2CPendedInterrupt(smtInt32 *pstatus);
smtUint32 smt2I2CWrite(smtUint8 addr, smtUint8 subAddr, smtUint8 data);
smtUint32 smt2I2CRead(smtUint8 addr, smtUint8 subAddr, smtUint8 *pdata);
void smtI2CInit(smtUint16 prescaler);

#endif
