/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: uart_post_drv.c 
	Description	: uart post driver file
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/
/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "lib.h"
#include "uart_post_drv.h"

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARE
///////////////////////////////////////////////////////// 
*/
static smtUint32 smt2UARTSetBaudGen(smtUint32 baudrate , smtUint16 *baudGen);
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
//
//	Time out
//
#define	UART_TO_RXFIFO_EMPTY			(0x7FFFF)
#define	UART_TO_TX_BUSY					(0x7FFFF)
#define UART_TO_TX_FULL					(0x7FFFF)
#define UART_TO_RX_EMPTY				(0x7FFFF)
//
// Error code
//
#define	UART_EC_NONE					(0<<0)
#define UART_EC_RXFIFO_EMPTY			(1<<1)
#define UART_EC_TX_BUSY					(1<<2)
#define UART_EC_TX_FULL					(1<<3)
#define UART_EC_RX_EMPTY				(1<<3)

#define UART_PRINTF_MAX_STRING 128

/*
/////////////////////////////////////////////////////////
        TYPE DEFINITION
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
static smtUint8 uartMaxFifoDepth[4] = 
{
	0,	// FIFO NONE
	8,	// 8  DEPTH
	16, // 16 DEPTH
	32	// 32 DEPTH
};

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: smt2UARTInit
	Prototype		: smtUint32 smt2UARTInit(UartConfig *IniData)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 smt2UARTInit(UartConfig *IniData)
{
	UartMaster 	uartCmd;
	UartStatus 	uartSts;
	smtUint16 	baudGen;
	smtUint32 	errCode;
	smtUint32	timeOut;
	smtUint8 	temp;
	
	smt2UARTSetBaudGen(IniData->baudrate, &baudGen);
	
	//set baud rate
	smtUARTSetBaud(IniData->uartCh, baudGen);
	
	//set uart master register
	uartCmd.uartEn		= 0x1;
	uartCmd.intEn		= IniData->enInt;
	uartCmd.rxTimeoutEn	= IniData->enRxTimeout;
	uartCmd.swReset		= IniData->swReset;
	uartCmd.dmaReqEn	= IniData->enDmaReq;
	uartCmd.parity		= IniData->parity;
	uartCmd.dataBit		= IniData->dataBit;
	uartCmd.stopBit		= IniData->stopBit;
	uartCmd.loopbackEn	= IniData->enLoopBack;
	uartCmd.txIntEn		= IniData->txIntEn;
	uartCmd.rxIntEn		= IniData->rxIntEn;
	uartCmd.txWaterLev	= IniData->txWaterLev;
	uartCmd.rxWaterLev	= IniData->rxWaterLev;

	smtUARTSetCmd(IniData->uartCh,&uartCmd);
	
	// rx fifo flush
	timeOut = 0;
	while(1)
	{
		smtUARTGetStatus(IniData->uartCh,&uartSts);
		if(uartSts.rxFifoCnt == 0)
			break;
		smtUARTGetRxFifo(IniData->uartCh,&temp);
		
		if(timeOut++ == UART_TO_RXFIFO_EMPTY)
		{
			errCode = UART_EC_RXFIFO_EMPTY;
			goto ERROR;
		}
	}
	// uart s/w reset
	uartCmd.swReset		= 1;
	smtUARTSetCmd(IniData->uartCh, &uartCmd);
	return UART_EC_NONE;

ERROR:
	uartCmd.uartEn 	= 0x0;
	uartCmd.intEn	= 0x0;
	smtUARTSetCmd(IniData->uartCh,&uartCmd);

	uartCmd.swReset	= 0x1;
	smtUARTSetCmd(IniData->uartCh,&uartCmd);
	return errCode;
}


/*----------------------------------------------------------
	Function name	: smt2UARTDeInit
	Prototype		: smtUint32 smt2UARTDeInit(smtUint8 uartCh)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 smt2UARTDeInit(UartChannel uartCh)
{
	UartMaster uartCmd;
	UartStatus uartSts;
	smtUint32 timeOut,errCode;
	timeOut = 0;
	while(1)
	{
		smtUARTGetStatus(uartCh, &uartSts);
		if(uartSts.txBusy != SMT_TRUE)
			break;
		if(timeOut++ == UART_TO_TX_BUSY)
		{
			errCode = UART_EC_TX_BUSY;
			goto ERROR;
			
		}
	}
	
	//uart disable
	smtUARTGetCmd(uartCh, &uartCmd);
	uartCmd.uartEn	= 0x0;
	uartCmd.intEn	= 0x0;
	smtUARTSetCmd(uartCh, &uartCmd);

	//uart s/w reset
	uartCmd.swReset	= 0x1;
	smtUARTSetCmd(uartCh, &uartCmd);

	return UART_EC_NONE;

ERROR:
	return errCode;
}

/*----------------------------------------------------------
	Function name	: smt2UARTPutStr
	Prototype		: smtUint32 smt2UARTPutStr(smtUint8 uartCh, smtInt8 * str)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 smt2UARTPutStr(UartChannel uartCh, smtInt8 * str)
{
	smtUint32 index = 0 ;
	smtUint32 errCode;//,timeOut;
	
	//timeOut = 0;
	while( str[index] != '\000')  
	{      	
		errCode = smt2UARTPutCh(uartCh, (char) str[index] ) ;      
		if(errCode != UART_EC_NONE)
			goto ERROR;
		if(str[index] == '\n')
		{
			errCode = smt2UARTPutCh(uartCh, '\r');
			if(errCode != UART_EC_NONE)
				goto ERROR;
		}
		index++;
	}
	return UART_EC_NONE;

ERROR:
	return errCode;
}

/*----------------------------------------------------------
	Function name	: smt2UARTGetStr
	Prototype		: smtUint32 smt2UARTGetStr(smtUint8 uartCh,smtUint8 *pData, smtUint8 dataCnt)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 smt2UARTGetStr(UartChannel uartCh, smtUint8 *pData, smtUint8 dataCnt)
{
    smtUint32 len;
    smtUint8 input;
	smtUint32 errCode;
    len = 0;
    while(len < dataCnt-1)
    {
		errCode = smt2UARTGetCh(uartCh,&input,0);
		if(errCode != UART_EC_NONE)
			goto ERROR;

        if(input == '\b')
        {
            if(len)
            {
                len--;
                pData[len] = '\0';
                errCode = smt2UARTPutStr(uartCh,"\b \b");
				if(errCode != UART_EC_NONE)
					goto ERROR;
            }
        }
        else if(input == '\r')
        {
			errCode = smt2UARTPutStr(uartCh,"\r\n");
			if(errCode != UART_EC_NONE)
				goto ERROR;
			
			
        	pData[len] = '\0';
        	break;
        }
		else if(input == 0x09)
			continue;
        else
        {
            pData[len] = input;
            len++;
    		errCode = smt2UARTPutCh(uartCh,input);
			if(errCode != UART_EC_NONE)
				goto ERROR;

        }

    };

    pData[dataCnt-1] = '\0';

    return UART_EC_NONE;

ERROR:
	return errCode;
}


/*----------------------------------------------------------
	Function name	: smt2UARTPrint
	Prototype		: smtUint32 smt2UARTPrint(smtUint8 uartCh, smtInt32 dispLvl, smtInt8 *format, ...)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 smt2UARTPrint(UartChannel uartCh, smtInt8 *format, ...)
{
	smtUint32 errCode;
	char str[UART_PRINTF_MAX_STRING];
	va_list ap;
	va_start(ap, format);
	vsnprintf(str, UART_PRINTF_MAX_STRING, format, ap);
	va_end(ap);

	errCode = smt2UARTPutStr(uartCh, str);
	if(errCode != UART_EC_NONE)
		goto ERROR;
	
	return UART_EC_NONE;

ERROR:
	return errCode;
}

/*----------------------------------------------------------
	Function name	: smt2UARTPutCh
	Prototype		: smtUint32 smt2UARTPutCh(smtUint8 uartCh, smtUint8 ch)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 smt2UARTPutCh(UartChannel uartCh, smtUint8 ch)
{
	UartStatus	uartSts;
	smtUint32	timeOut;
	timeOut = 0;
	while(1)
	{
		smtUARTGetStatus(uartCh, &uartSts);
		
		if(uartSts.txFifoCnt != uartMaxFifoDepth[uartSts.maxFifoDepth])
		{
			smtUARTSetTxFifo(uartCh, ch);
			return UART_EC_NONE;
		}
		
		if(timeOut++ == UART_TO_TX_FULL)
			return UART_EC_TX_FULL;
	}
}

/*----------------------------------------------------------
	Function name	: smt2UARTGetCh
	Prototype		: smtUint32 smt2UARTGetCh(smtUint8 uartCh, smtUint8 *pRxData, smtUint32 waitTime)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 smt2UARTGetCh(UartChannel uartCh, smtUint8 *pRxData, smtUint32 waitTime)
{
	UartStatus uartSts;
	smtUint32 timeOut;
	timeOut = waitTime;
	while(1)
	{
		smtUARTGetStatus(uartCh, &uartSts);
		
		if(uartSts.rxFifoCnt != 0x00)
		{
			smtUARTGetRxFifo(uartCh, pRxData);
			return UART_EC_NONE;
		}
		if(waitTime && (timeOut-- == 0))
			return UART_EC_RX_EMPTY;
	}
}

/*----------------------------------------------------------
	Function name	: smt2UARTDataValid
	Prototype		: smtUint32 smt2UARTDataValid(smtUint8 uartCh, smtUint8 *pRxFifoCnt)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 smt2UARTDataValid(UartChannel uartCh, smtUint8 *pRxFifoCnt)
{
	UartStatus uartSts;
	smtUARTGetStatus(uartCh, &uartSts);
	*pRxFifoCnt = uartSts.rxFifoCnt;
	return UART_EC_NONE;
}

/*----------------------------------------------------------
	Function name	: smt2UARTSetBaudGen
	Prototype		: static smtUint32 smt2UARTSetBaudGen(smtUint32 baudrate, smtUint16 *pBaudGen)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static smtUint32 smt2UARTSetBaudGen(smtUint32 baudrate, smtUint16 *pBaudGen)
{
	*pBaudGen = (smtUint16)(((smtFloat)(baudrate*16))*65536.0/((smtFloat)APB1_CLK) + 0.5);
	return UART_EC_NONE;
}

