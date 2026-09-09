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

typedef struct
{
	smtUint32 baudrate;
	smtUint8 uartCh;
	smtUint8 dataBit;
	smtUint8 parity;
	smtUint8 stopBit;
	smtUint8 enLoopBack;
	smtUint8 enInt;
	smtUint8 enDmaReq;
	smtUint8 enRxTimeout;
	smtUint8 txIntEn;
	smtUint8 rxIntEn;
	smtUint8 txWaterLev;
	smtUint8 rxWaterLev;
	smtUint8 swReset;
	
}UartConfig;

/*
//////////////////////////////////////////////////////////////////////////////
	FUNCTION DECLARATION
//////////////////////////////////////////////////////////////////////////////
*/

smtUint32 	smt2UartInit	(UartConfig uartCfg);
smtUint32	smt2UartDeInit	(void);
smtUint32 	smt2UartPutStr	(smtInt8 *pData);
smtUint32 	smt2UartGetStr	(smtUint8 *pData, smtUint8 dataCnt);
smtUint32 	smt2UartPrint	(smtInt32 dispLvl, smtInt8 *fmt, ...);
smtUint32 	smt2UartPutCh	(smtUint8 data);
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

