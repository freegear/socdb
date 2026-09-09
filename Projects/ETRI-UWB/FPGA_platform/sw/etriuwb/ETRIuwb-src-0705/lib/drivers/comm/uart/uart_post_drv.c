/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : uart_post_drv.c 
	Description : Uart post-layer driver
	Created by  : SHMT SOC Team
------------------------------------------------------------------------------*/

/*
//////////////////////////////////////////////////////////////////////////////
        INCLUDE
//////////////////////////////////////////////////////////////////////////////
*/

#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "lib.h"
#include "uart_pre_drv.h"
#include "uart_post_drv.h"

/*
//////////////////////////////////////////////////////////////////////////////
        DEFINITIOIN
//////////////////////////////////////////////////////////////////////////////
*/

#define APB1_CLK		(25*1000*1000) // 25 MHz
#define UART_PRINTF_MAX_STRING 128

/*
//////////////////////////////////////////////////////////////////////////////
        VARIABLE
//////////////////////////////////////////////////////////////////////////////
*/

static UartChannel gUartCh;

/*
//////////////////////////////////////////////////////////////////////////////
        FUNCTION
//////////////////////////////////////////////////////////////////////////////
*/

static smtUint32 UARTGetBaudrate(smtUint32 baudrate);

/*------------------------------------------------------------------------------
	Function name	: smt2UartInit
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtUint32 smt2UartInit(UartConfig uartInitData)
{
	UartStruct uartConfig;
	
	//set baud rate
	uartConfig.uartBaudGen = UARTGetBaudrate(uartInitData.baudrate);
	smtUartSetMode(uartInitData.uartCh, &uartConfig, SET_UARTBRD);
	
	//set uart master register
	uartConfig.uartMaster.uartEn		= 0x1;
	uartConfig.uartMaster.intEn			= uartInitData.enInt;
	uartConfig.uartMaster.rxTimeoutEn	= uartInitData.enRxTimeout;
	uartConfig.uartMaster.swReset		= uartInitData.swReset;
	uartConfig.uartMaster.dmaReqEn		= uartInitData.enDmaReq;
	uartConfig.uartMaster.parity		= uartInitData.parity;
	uartConfig.uartMaster.dataBit		= uartInitData.dataBit;
	uartConfig.uartMaster.stopBit		= uartInitData.stopBit;
	uartConfig.uartMaster.loopbackEn	= uartInitData.enLoopBack;
	uartConfig.uartMaster.txIntEn		= uartInitData.txIntEn;
	uartConfig.uartMaster.rxIntEn		= uartInitData.rxIntEn;
	uartConfig.uartMaster.txWaterLev	= uartInitData.txWaterLev;
	uartConfig.uartMaster.rxWaterLev	= uartInitData.rxWaterLev;

	smtUartSetMode(uartInitData.uartCh, &uartConfig,SET_UARTMASTER);

	// rx fifo flush
	while(1)
	{
		smtUartGetMode(uartInitData.uartCh, &uartConfig, GET_UARTSTATUS);
		if(uartConfig.uartStatus.rxFifoCnt == 0)
			break;
		smtUartReadRxFifo(uartInitData.uartCh);
	}

	// uart s/w reset
	uartConfig.uartMaster.swReset		= 1;
	smtUartSetMode(uartInitData.uartCh, &uartConfig,SET_UARTMASTER);
	
	gUartCh = uartInitData.uartCh;
	return SMT_SUCCESS;
}

/*------------------------------------------------------------------------------
	Function name	: smt2UartDeInit
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtUint32 smt2UartDeInit(void)
{
	UartStruct uartConfig;
#if 1
	while(1)
	{
		smtUartGetMode(gUartCh, &uartConfig, GET_UARTSTATUS);
		if(uartConfig.uartStatus.txBusy != SMT_TRUE)
			break;
	}

#else
	while(1)
	{
		smtUartGetMode(gUartCh, &uartConfig, GET_UARTSTATUS);
		if(uartConfig.uartStatus.txFifoCnt == 0)
			break;
	}
#endif	
	//uart disable
	smtUartGetMode(gUartCh, &uartConfig, GET_UARTMASTER);
	uartConfig.uartMaster.uartEn	= 0x0;
	uartConfig.uartMaster.intEn		= 0x0;
	smtUartSetMode(gUartCh, &uartConfig, SET_UARTMASTER);

	//uart software reset twice
	uartConfig.uartMaster.swReset		= 1;
	smtUartSetMode(gUartCh, &uartConfig,SET_UARTMASTER);
	
	uartConfig.uartMaster.swReset		= 1;
	smtUartSetMode(gUartCh, &uartConfig,SET_UARTMASTER);	

	gUartCh = 0xFF;
	return SMT_SUCCESS;
}

/*------------------------------------------------------------------------------
	Function name	: smtUartPutStr()
	Prototype		: smtBoolean smtUartPutStr(smtUint8 *pData)
	Return			: error code
	Argument		: transmit data
	Comments		:
		Transmit the data as data count
------------------------------------------------------------------------------*/
smtUint32 smt2UartPutStr(smtInt8 * str)
{
	int index = 0 ;
	while( str[index] != '\000')  
	{      	
		smt2UartPutCh( (char) str[index] ) ;      
		if(str[index] == '\n')
			smt2UartPutCh('\r');
		index++;  
	}
	return SMT_SUCCESS;
}


/*------------------------------------------------------------------------------
	Function name	: smt2UartGetStr()
	Prototype		: smtBoolean smtUartStrRead(smtUint8 *pData, smtUint8 dataCnt)
	Return			: error code
	Argument		: Received data, receive data count
	Comments		:
		Receive the data as data count
------------------------------------------------------------------------------*/
smtUint32 smt2UartGetStr(smtUint8 *pData, smtUint8 dataCnt)
{
    smtUint32 len;
    smtUint8 input;
	
    len = 0;
    while(len < dataCnt-1)
    {
        input = smt2UartGetCh(0);

        if(input == '\b')
        {
            if(len)
            {
                len--;
                pData[len] = '\0';
                smt2UartPutStr("\b \b");
            }
        }
        else if(input == '\r')
        {
        	pData[len] = '\0';
        	break;
        }
		else if(input == 0x09)
			continue;
        else
        {
            pData[len] = input;
            len++;
            smt2UartPutCh(input);
        }

    };

    pData[dataCnt-1] = '\0';

    return SMT_SUCCESS;
}

/*------------------------------------------------------------------------------
	Function name	: smtUartPrint()
	Prototype		: void smtUartPrint(smtUint8 *fmt, ...);
	Return			: void
	Argument		: fmt  -> format operator
	Comments		: print out though console
------------------------------------------------------------------------------*/
smtUint32 smt2UartPrint(smtInt32 dispLvl, smtInt8 *format, ...)
{
	char str[UART_PRINTF_MAX_STRING];
	va_list ap;
	va_start(ap, format);
	vsnprintf(str, UART_PRINTF_MAX_STRING, format, ap);
	va_end(ap);

	smt2UartPutStr(str);
	return SMT_SUCCESS;
}

/*------------------------------------------------------------------------------
	Function name	: smt2UartPutCh()
	Prototype		: smtBoolean smt2UartPutCh(smtUint8 data)
	Return			: error code
	Argument		: data
	Comments		:
		Transmit character data
------------------------------------------------------------------------------*/
smtUint32 smt2UartPutCh(smtUint8 ch)
{
  	UartStruct uartConfig;
	while(1)
	{
		smtUartGetMode(gUartCh, &uartConfig, GET_UARTSTATUS);
		if(uartConfig.uartStatus.txFifoCnt	!= 0x1e)
		{
			smtUartWriteTxFifo(gUartCh, ch);
			return SMT_SUCCESS;
		}
	}
}


/*------------------------------------------------------------------------------
	Function name	: smtUartCharRead()
	Prototype		: smtUint8 smtUartCharRead(smtUint32 waitTime)
	Return			: Received data
	Argument		:   waitTime
	Comments		:
		Receive character data
------------------------------------------------------------------------------*/
smtUint8 smt2UartGetCh(smtUint32 waitTime)
{
	UartStruct uartConfig;
	while(1)
	{
		smtUartGetMode(gUartCh, &uartConfig, GET_UARTSTATUS);
		if(uartConfig.uartStatus.rxFifoCnt != 0x00)
		{
			return smtUartReadRxFifo(gUartCh);
		}
	}
}
/*----------------------------------------------------------
	Function name	: UARTGetBaudrate()
	Prototype		: static smtUint32 UARTGetBaudrate(smtUint32 baudrate)
	Return		: error code
	Argument	:
	Comments	: Return a error-code
	get uart baudrate gen register value
----------------------------------------------------------*/
static smtUint32 UARTGetBaudrate(smtUint32 baudrate)
{
	return (smtUint32)(((smtFloat)(baudrate*16))*65536.0/((smtFloat)APB1_CLK) + 0.5);
}

#if 0
/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtBoolean smt2UartComOpen(void)
{
	//ApplyDCB
	//smt2UartSetCommTimeouts

    smtUartSetBaudRate(9600);
    smtUartSetByteSize(8);
    smtUartSetParity(NOPARITY);
    smtUartSetStopBits(ONESTOPBIT);
    
    smtUartInitLine(SMT_TRUE);
    smtUartInitReceive(SMT_TRUE);
    smtUartInitXmit(SMT_TRUE);
	smtUartPurgeComm(PURGE_RXCLEAR);

    return SMT_TRUE;

}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtBoolean smt2UartComClose(void)
{
    smtUartInitXmit(SMT_FALSE);
    smtUartInitReceive(SMT_FALSE);
    smtUartInitLine(SMT_FALSE);
    return SMT_TRUE;
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void smt2UartComDeinit(void)
{
//	HWDeinit
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void smt2UartComRead(smtUint8 *pTargetBuffer, smtUint32 BufferLength, smtUint32 *pBytesRead)
{
	smtUartStrRead(pTargetBuffer, BufferLength);
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void smt2UartComWrite(smtUint8 *pSourceBytes, smtUint32 NumberOfBytes )
{
	smtUartPutStr(pSourceBytes);
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void smt2UartComPowerUp(void)
{
//	HWPowerOn
}	

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void smt2UartComPowerDown(void)
{
//	HWPowerOff
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtBoolean smt2UartComIOControl(smtUint32 dwCode, smtUint8 *pBufIn,
              smtUint32 dwLenIn, smtUint8 *pBufOut, smtUint32 dwLenOut,
              smtUint32 *pdwActualOut)
{

}
#endif
