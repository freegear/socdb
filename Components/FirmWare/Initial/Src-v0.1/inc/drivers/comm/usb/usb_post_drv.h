/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File name		: uart_post_drv.h
	Description		: Uart post-layer driver
------------------------------------------------------------------------------*/
#ifndef __UART_POST_DRV_H__
#define __UART_POST_DRV_H__

/*//////////////////////////////////////////////////////////////////////////////
	INCLUDE
//////////////////////////////////////////////////////////////////////////////*/
#include "global.h"
#include "commonmacro.h"

/*//////////////////////////////////////////////////////////////////////////////
        DEFINITION
//////////////////////////////////////////////////////////////////////////////*/
typedef struct
{
	smtUint8 baudRate;
	smtUint8 parity;
	smtUint8 stopBit;
	smtUint8 dataBit;
	smtUint8 rxWaterLev;
	smtUint8 txWaterLev;
	
	smtBoolean rxTimeOutEn;
	smtUint16 rxTimeOut;
	UartChannel uartCh;
	
}UartConfig;

/*//////////////////////////////////////////////////////////////////////////////
	FUNCTION DECLARATION
//////////////////////////////////////////////////////////////////////////////*/

smtBoolean 	smt2UartInit	(UartConfig uartCfg);
void 		smt2UartDeInit	(void);
smtBoolean 	smt2UartPutStr	(smtInt8 *pData);
smtBoolean 	smt2UartGetStr	(smtUint8 *pData, smtUint8 dataCnt);
smtBoolean 	smt2UartPrint	(int dispLvl, char *fmt, ...);
smtBoolean 	smt2UartPutCh	(smtInt8 data);
smtUint8 	smt2UartGetCh	(smtUint32 waitTime);

#if 0
void 		smt2UartComInit			(void);
smtBoolean 	smt2UartComOpen			(void);
void 		smt2UartComPreClose		(void);
smtBoolean 	smt2UartComClose		(void);
void 		smt2UartComDeinit		(void);
void 		smt2UartComRead			(smtUint8 *pTargetBuffer, smtUint32 BufferLength,
									smtUint32 *pBytesRead);
void 		smt2UartComWrite		(smtUint8 *pSourceBytes, smtUint32 NumberOfBytes );
void 		smt2UartComPowerUp		(void);
void 		smt2UartComPowerDown	(void);
smtBoolean 	smt2UartComIOControl	(smtUint32 dwCode, smtUint8 *pBufIn, 
									smtUint32 dwLenIn, smtUint8 *pBufOut, smtUint32 dwLenOut,
              						smtUint32 *pdwActualOut);
#endif              						
#endif

