/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: uart.h
	Description	: 
----------------------------------------------------------*/
#ifndef __UART_H__
#define __UART_H__

/*
/////////////////////////////////////////////////////////
	INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "sysinc.h"
#include "structdef.h"
#include "commonmacro.h"

/*
/////////////////////////////////////////////////////////
	DEFINITION
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
	smtUint8 txWaterLev;
	smtUint8 rxWaterLev;
	smtUint8 swReset;
	smtUint8 txIntEn;
	smtUint8 rxIntEn;
} UartBasicCfg;

#define DMA_UART0TX	7
#define DMA_UART0RX	8
#define DMA_UART1TX	9
#define DMA_UART1RX	10
/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

smtUint32 UARTTest(void);
void UARTPuts(char * str);
static smtUint32 UARTGetMaxFifoSz(smtUint8 uartCh, smtUint8 *uartFifoDepth);
#endif/* __UART_H__ */

