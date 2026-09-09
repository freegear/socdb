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
#ifndef __UART_PRE_DRV_H__
#define __UART_PRE_DRV_H__

/*//////////////////////////////////////////////////////////////////////////////
	INCLUDE
//////////////////////////////////////////////////////////////////////////////*/
#include "global.h"
#include "commonmacro.h"

/*//////////////////////////////////////////////////////////////////////////////
        DEFINITION
//////////////////////////////////////////////////////////////////////////////*/
typedef enum
{
	UART_CHANNEL0,
	UART_CHANNEL1
} UartChannel;
typedef enum
{
	BAUD_2400		= 2400,
	BAUD_4800		= 4800,
	BAUD_9600		= 9600,
	BAUD_19200		= 19200,
	BAUD_38400		= 38400,
	BAUD_115200		= 115200
} UartBaudRate;

typedef enum
{
	GET_UARTMASTER,
	SET_UARTMASTER,
	GET_UARTSTATUS,
	GET_UARTBRD,
	SET_UARTBRD,
	GET_UARTRXTIMEOUT,
	SET_UARTRXTIMEOUT
} UartMode;

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

typedef enum
{
	INT_LEVEL_1BY8 = 0,
	INT_LEVEL_1BY4,
	INT_LEVEL_1BY2,
	INT_LEVEL_3BY4,
	INT_LEVEL_7BY8
} UartFifoWaterLevel;


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
	smtBoolean 	txFifoDMAReq;
	smtUint8 	txFifoCnt;
	smtBoolean 	rxFifoDMAReq;
	smtUint8 	rxFifoCnt;
}UartStatus;
typedef struct
{
	UartMaster	uartMaster;
	UartStatus	uartStatus;
	smtUint32 	uartRxTimeout;
	smtUint16	uartBaudGen;
} UartStruct;

/*//////////////////////////////////////////////////////////////////////////////
	FUNCTION DECLARATION
//////////////////////////////////////////////////////////////////////////////*/

#if 0
compiler_key	// _area
scope			// static / extern
return 			// return type
function		// function name
(
param			// param
);
#endif

smtBoolean 	smtUartSetMode		(UartChannel uartCh, UartStruct *uart, UartMode mode);
smtBoolean 	smtUartGetMode		(UartChannel uartCh, UartStruct *uart, UartMode mode);
smtUint8 	smtUartReadRxFifo	(UartChannel uartCh);
void 		smtUartWriteTxFifo	(UartChannel uartCh, smtUint8 txData);

#if 0
smtBoolean smtUartInit(void);

smtBoolean	smtUartInitXmit					(smtBoolean bInit);
void 		smtUartXmitInterruptHandler		(void);
smtUint32 	smtUartXmitComChar				(smtUint8 ComChar);
smtBoolean 	smtUartEnableXmitInterrupt		(smtBoolean fEnable);
smtBoolean 	smtUartCancelXmit				(void);
smtUint32 	smtUartGetWriteableSize			(void);

smtBoolean 	smtUartInitReceive				(smtBoolean bInit);
smtUint32 	smtUartReceiveInterruptHandler	(void);
smtUint32 	smtUartCancelReceive			(void);

smtBoolean 	smtUartInitModem				(smtBoolean bInit);
void 		smtUartModemInterruptHandler	(void);
smtUint32 	smtUartGetModemStatus			(void);
void 		smtUartSetDTR					(smtBoolean bSet);
void 		smtUartSetRTS					(smtBoolean bSet);

smtBoolean 	smtUartInitLine					(smtBoolean bInit);
void 		smtUartLineInterruptHandler		(void);
smtBoolean 	smtUartSetByteSize				(smtUint32 ByteSize);
smtBoolean 	smtUartSetStopBits				(smtUint32 StopBits);
smtBoolean 	smtUartSetParity				(smtUint32 Parity);
void 		smtUartSetBreak					(smtBoolean bSet);
smtUint8 	smtUartGetLineStatus			(void);

void 		smtUartEnableInterrupt			(smtUint32 dwInt);
void 		smtUartDisableInterrupt			(smtUint32 dwInt);
void 		smtUartClearInterrupt			(smtUint32 dwInt);
smtUint32 	smtUartGetInterruptStatus		(void);
smtUint32 	smtUartGetIntrruptMask 			(void) ;

void 		smtUartSerialRegisterBackup		(void);
void 		smtUartSerialRegisterRestore	(void);
smtBoolean 	smtUartPurgeComm				(smtUint32 fdwAction);

smtBoolean 	smtUartSetBaudRate				(smtUint32 baudRate);
smtBoolean 	smtUartSetMode					(UART_STRUCT *uart, UART_MODE mode);
smtBoolean 	smtUartCharWrite				(smtInt8 data);
smtUint8 	smtUartCharRead					(smtUint32 waitTime);
smtBoolean 	smtUartStrWrite					(smtInt8 *pData);
smtBoolean 	smtUartStrRead					(smtUint8 *pData, smtUint8 dataCnt);
smtBoolean 	smtUartPrint					(int dispLvl, char *fmt, ...);
#endif
#endif

