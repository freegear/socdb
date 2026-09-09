/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: uart_post_drv.h
	Description		: uart post driver header file
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __UART_POST_DRV_H__
#define __UART_POST_DRV_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "commonmacro.h"
#include "sysinc.h"
#include "uart_pre_drv.h"
/*
/////////////////////////////////////////////////////////
        TYPEDEF
///////////////////////////////////////////////////////// 
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
/////////////////////////////////////////////////////////
        FUNCTION
/////////////////////////////////////////////////////////
*/

smtUint32 smt2UARTInit(UartConfig *uartInitData);
smtUint32 smt2UARTDeInit(UartChannel uartCh);
smtUint32 smt2UARTPutStr(UartChannel uartCh, smtInt8 * str);
smtUint32 smt2UARTGetStr(UartChannel uartCh,smtUint8 *pData, smtUint8 dataCnt);
smtUint32 smt2UARTPrint(UartChannel uartCh, smtInt8 *format, ...);
smtUint32 smt2UARTPutCh(UartChannel uartCh, smtUint8 ch);
smtUint32 smt2UARTGetCh(UartChannel uartCh, smtUint8 *pRxData, smtUint32 waitTime);
smtUint32 smt2UARTDataValid(UartChannel uartCh, smtUint8 *pRxFifoCnt);
#endif //__UART_POST_DRV_H__

