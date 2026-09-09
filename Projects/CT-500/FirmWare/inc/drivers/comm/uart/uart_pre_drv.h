/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: uart_pre_drv.h
	Description		: uart pre driver header file
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __UART_PRE_DRV_H__
#define __UART_PRE_DRV_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "commonmacro.h"
#include "sysinc.h"

/*
/////////////////////////////////////////////////////////
        TYPEDEF
///////////////////////////////////////////////////////// 
*/

typedef enum
{
	UART_CHANNEL0,
	UART_CHANNEL1,
	UART_CHANNEL2,
	UART_CHANNEL3,
	MAX_UART_CHANNEL
} UartChannel;
typedef enum
{
	BAUD_4800		= 4800,
	BAUD_9600		= 9600,
	BAUD_14400		= 14400,
	BAUD_19200		= 19200,
	BUAD_31257		= 31257,
	BAUD_38400		= 38400,
	BAUD_115200		= 115200
} UartBaudRate;

typedef enum
{
	PARITY_DISABLE,
	PARITY_EVEN = 2,
	PARITY_ODD  = 3
} UartParity;

typedef enum
{
	ONE_STOP_BIT,
	TWO_STOP_BIT
} UartStopBit;

typedef enum
{
	DATA_7BIT,
	DATA_8BIT
} UartDataBit;

typedef struct
{
	smtBoolean 	uartEn;
	smtBoolean 	intEn;
	smtBoolean 	rxTimeoutEn;
	smtBoolean 	swReset;
	smtBoolean 	dmaReqEn;
	smtUint8	parity;
	smtUint8	dataBit;
	smtUint8	stopBit;
	smtBoolean 	loopbackEn;
	smtBoolean	txIntEn;
	smtBoolean	rxIntEn;
	smtUint8 	txWaterLev;
	smtUint8 	rxWaterLev;
}UartMaster;

typedef struct
{
	smtBoolean 	interrupt;
	smtUint8 	maxFifoDepth;
	smtBoolean 	txBusy;
	smtBoolean 	rxBusy;
	smtBoolean 	parityErr;
	smtBoolean 	frameErr;
	smtBoolean 	overrunErr;
	smtBoolean 	rxTimeout;
	smtBoolean	txFifoInt;
	smtBoolean	rxFifoInt;
	smtBoolean 	txFifoDMAReq;
	smtUint8 	txFifoCnt;
	smtBoolean 	rxFifoDMAReq;
	smtUint8 	rxFifoCnt;
}UartStatus;

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////
*/

void smtUARTSetCmd(UartChannel uartCh, UartMaster *pUartCmd);
void smtUARTGetCmd(UartChannel uartCh, UartMaster *pUartCmd);

void smtUARTSetStatus(UartChannel uartCh, UartStatus *pUartSts);
void smtUARTGetStatus(UartChannel uartCh, UartStatus *pUartSts);

void smtUARTSetBaud(UartChannel uartCh, smtUint16 baudGen);
void smtUARTGetBaud(UartChannel uartCh, smtUint16 *pBaudGen);

void smtUARTSetTxFifo(UartChannel uartCh, smtUint8 txData);
void smtUARTGetRxFifo(UartChannel uartCh, smtUint8 *pRxData);

void smtUARTSetRxTO(UartChannel uartCh, smtUint32 rxTOCnt);
void smtUARTGetRxTO(UartChannel uartCh, smtUint32 *pRxTOCnt);

#endif //__UART_PRE_DRV_H__

