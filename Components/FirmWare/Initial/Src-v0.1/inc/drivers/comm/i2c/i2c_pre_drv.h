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

/*//////////////////////////////////////////////////////////////////////////////
	INCLUDE
//////////////////////////////////////////////////////////////////////////////*/
#include "global.h"
#include "commonmacro.h"

/*//////////////////////////////////////////////////////////////////////////////
        DEFINITION
//////////////////////////////////////////////////////////////////////////////*/

/*/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void smtI2CSetPreScaler(smtUint16 preScale);
void smtI2CGetPreScaler(smtUint16 preScale);
void smtI2CIntPendClear(void);
void smtI2CSetOpMode(smtUint8 operationMode);
void smtI2CGetOpMode(smtUint8 operationMode);
void smtI2CSetAckEnable(smtUint8 ackEnable);
void smtI2CGetAckEnable(smtUint8 ackEnable);
void smtI2CSetTxRxIntEnable(smtUint8 intEnable);
void smtI2CGetTxRxIntEnable(smtUint8 intEnable);
void smtI2CStart(smtBoolean startStop);
void smtI2CGetStatus(I2C_STATUS_STRUCT i2cStatus);
smtUint32 smt2I2CWrite(I2C_CTRL_STRUCT i2cCtrl, smtUint8 addr, smtUint8 data);
smtUint32 smt2I2CRead(I2C_CTRL_STRUCT i2cCtrl, smtUint8 addr, smtUint8 data);

#endif
