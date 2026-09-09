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

/*
//////////////////////////////////////////////////////////////////////////////
	INCLUDE
//////////////////////////////////////////////////////////////////////////////
*/

#include "global.h"
#include "commonmacro.h"
#include "sysinc.h"

/*
//////////////////////////////////////////////////////////////////////////////
        DEFINITION
//////////////////////////////////////////////////////////////////////////////
*/

//UART OFFSET
#define UART_OFFSET_MASTER 		0x00
#define UART_OFFSET_STATUS 		0x04
#define UART_OFFSET_BRD 		0x08
#define UART_OFFSET_TXFIFO 		0x0C
#define UART_OFFSET_RXFIFO 		0x10
#define UART_OFFSET_RXTIMEOUT	0x14

#define MASTER_EN_UART  		(0x1UL)	<<31
#define MASTER_EN_INT    		(0x1UL) <<30
#define MASTER_EN_RX_TIMEOUT	(0x1UL) <<29
#define MASTER_SW_RESET  		(0x1UL) <<28
#define MASTER_EN_DMA_REQ   	(0x1UL) <<27
#define MASTER_PARITY			(0x3UL) <<25
#define MASTER_DATA_BIT			(0x1UL) <<24
#define MASTER_STOP_BIT			(0x1UL) <<23
#define MASTER_EN_LOOPBACK		(0x1UL) <<22
#define MASTER_TX_FIFO_INT_EN	(0x1UL) <<15
#define MASTER_TX_WATER_LEV		(0x3FUL)<<8
#define MASTER_RX_FIFO_INT_EN	(0x1UL) <<7
#define MASTER_RX_WATER_LEV		(0x3FUL)<<0

// UART_STATUS register
#define STATUS_INTERRUPT		(0x1UL)	<<31
#define STATUS_MAX_FIFO_DEPTH	(0x7UL)	<<28
#define STATUS_TX_BUSY			(0x1UL)	<<27
#define STATUS_RX_BUSY			(0x1UL)	<<26
#define STATUS_PARITY_ERR		(0x1UL)	<<25
#define STATUS_FRAME_ERR		(0x1UL)	<<24
#define STATUS_OVERRUN_ERR		(0x1UL)	<<23
#define STATUS_RX_TIMEOUT		(0x1UL)	<<22
#define STATUS_TX_FIFO_INT		(0x1UL) <<15
#define STATUS_TX_FIFO_DMA_REQ	(0x1UL)	<<14
#define STATUS_TX_FIFO_CNT		(0x3FUL)<<8
#define STATUS_RX_FIFO_INT		(0x1UL) <<7
#define STATUS_RX_FIFO_DAM_REQ	(0x1UL)	<<6
#define STATUS_RX_FIFO_CNT		(0x3FUL)<<0

// UART_BRD register
#define UART_BAUDRATE_GEN	(0xFFFFUL)<<0

//UART_TX_FIFO_WRITE register
#define TX_FIFO_WRITE		(0xFF)<<0

//UART_RX_FIFO_READ register
#define RX_FIFO_READ		(0xFF)<<0

//UART_RX_TIME_OUT
#define RX_TIME_OUT			(0xFFFFFUL)<<0


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

typedef struct
{
	UartMaster	uartMaster;
	UartStatus	uartStatus;
	smtUint32 	uartRxTimeout;
	smtUint16	uartBaudGen;
} UartStruct;

/*
//////////////////////////////////////////////////////////////////////////////
	FUNCTION DECLARATION
//////////////////////////////////////////////////////////////////////////////
*/

smtBoolean 	smtUartSetMode		(UartChannel uartCh, UartStruct *uart, UartMode mode);
smtBoolean 	smtUartGetMode		(UartChannel uartCh, UartStruct *uart, UartMode mode);
smtUint8 	smtUartReadRxFifo	(UartChannel uartCh);
void 		smtUartWriteTxFifo	(UartChannel uartCh, smtUint8 txData);
smtUint32 smtUartDataAvailable	(void);
#endif

