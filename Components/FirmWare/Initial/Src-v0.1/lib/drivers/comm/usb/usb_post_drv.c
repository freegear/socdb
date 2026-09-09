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
/*//////////////////////////////////////////////////////////////////////////////
        INCLUDE
//////////////////////////////////////////////////////////////////////////////*/
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "uart_pre_drv.h"
#include "uart_post_drv.h"

/*//////////////////////////////////////////////////////////////////////////////
        DEFINITIOIN
//////////////////////////////////////////////////////////////////////////////*/



/*//////////////////////////////////////////////////////////////////////////////
        VARIABLE
//////////////////////////////////////////////////////////////////////////////*/
static UartChannel gUartCh;


/*//////////////////////////////////////////////////////////////////////////////
        FUNCTION
//////////////////////////////////////////////////////////////////////////////*/
static smtBoolean smt2UartCheckRxFifoEmpty(void);
static smtBoolean smt2UartCheckTxFifoEmpty(void);
static smtBoolean smt2UartSetBaudrate(smtUint32 baudrate);


/*------------------------------------------------------------------------------
	Function name	: smt2UartComInit
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtBoolean smt2UartInit(UartConfig uartCfg)
{

	/*------------------------------------------------------
		//1. uart clk setting
		//2. uart interrupt setting // vic
		//3. uart etc setting
		//	- baud rate
		//	- parity/stop/data width
		//	- rx/tx water level
		//	- interrupt(uart interrupt/ rx timeout interrupt)
		//4. set post driver global variable
			- uart channel
	-------------------------------------------------------*/	
	UartStruct uartStr;
	gUartCh = uartCfg.uartCh;
	memset(&uartStr, 0x0, sizeof(uartStr));
	
	//uart clk setting

	//uart interrupt setting - vic
	
	//uart set baudrate
	smt2UartSetBaudrate(uartCfg.baudRate);

	//uart etc setting
	uartStr.uartMaster.parity = uartCfg.parity;
	uartStr.uartMaster.stopBit = uartCfg.stopBit;
	uartStr.uartMaster.dataBit = uartCfg.dataBit;
	uartStr.uartMaster.rxWaterLev = uartCfg.rxWaterLev;
	uartStr.uartMaster.txWaterLev = uartCfg.txWaterLev;
	uartStr.uartMaster.rxTimeoutEn = uartCfg.rxTimeOutEn;
	smtUartSetMode(gUartCh, &uartStr, SET_UARTMASTER);

	uartStr.uartRxTimeout = uartCfg.rxTimeOut;
	smtUartSetMode(gUartCh, &uartStr, SET_UARTMASTER);

}

/*------------------------------------------------------------------------------
	Function name	: smt2UartComInit
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void smt2UartDeInit(void)
{
	//disable uart??
}

/*------------------------------------------------------------------------------
	Function name	: smtUartPutStr()
	Prototype		: smtBoolean smtUartPutStr(smtUint8 *pData)
	Return			: error code
	Argument		: transmit data
	Comments		:
		Transmit the data as data count
------------------------------------------------------------------------------*/
smtBoolean smt2UartPutStr(smtInt8 *pData)
{
	while(*pData)
		smt2UartPutCh(*pData++);
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
smtBoolean smt2UartGetStr(smtUint8 *pData, smtUint8 dataCnt)
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
smtBoolean smt2UartPrint(int dispLvl, char *fmt, ...)
{
	va_list ap;
	smtInt8 string[255]; 
	
	if(dispLvl > 10)
	{
		va_start(ap, fmt);
		vsprintf(string, fmt, ap);
		smt2UartPutStr(string);
		va_end(ap);
	}
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
smtBoolean smt2UartPutCh(smtInt8 data)
{
	if(data =='\n')
	{
		while(!smt2UartCheckTxFifoEmpty());
		#if 0
		smtDelay100us(1);
		#endif
		smtUartWriteTxFifo(gUartCh, '\r');
		return SMT_SUCCESS;
	}
	while(!smt2UartCheckTxFifoEmpty());
	#if 0
	smtDelay100us(1);
	#endif
	smtUartWriteTxFifo(gUartCh, data);
	return SMT_SUCCESS;
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
	smtUint32 cnt = 0;
	while(smt2UartCheckRxFifoEmpty())
	{
		if(waitTime == 0 ) //WAIT_FOREVER
			continue;
		
		if(cnt++ < waitTime)
			smtDelay100us(1);
		else
			return SMT_ERROR;
	}
	return smtUartReadRxFifo(gUartCh);
}
/*------------------------------------------------------------------------------
	Function name	: smt2UartCheckRxFifoEmpty()
	Prototype		: static smtBoolean smt2UartCheckRxFifoEmpty(void)
	Return			: 
	Argument		: 
	Comments		:
------------------------------------------------------------------------------*/
static smtBoolean smt2UartCheckRxFifoEmpty(void)
{
	UartStruct uartStr;
	memset(&uartStr, 0x0, sizeof(uartStr));
	smtUartGetMode(gUartCh, &uartStr, GET_UARTSTATUS);
	if(uartStr.uartStatus.rxFifoCnt == 0)
		return SMT_TRUE;
	else
		return SMT_FALSE;
}
/*------------------------------------------------------------------------------
	Function name	: smt2UartCheckRxFifoEmpty()
	Prototype		: static smtBoolean smt2UartCheckRxFifoEmpty(void)
	Return			: 
	Argument		: 
	Comments		:
------------------------------------------------------------------------------*/
static smtBoolean smt2UartCheckTxFifoEmpty(void)
{
	UartStruct uartStr;
	memset(&uartStr, 0x0, sizeof(uartStr));
	smtUartGetMode(gUartCh, &uartStr, GET_UARTSTATUS);
	if(uartStr.uartStatus.txFifoCnt == 0)
		return SMT_TRUE;
	else
		return SMT_FALSE;
}
/*------------------------------------------------------------------------------
	Function name	: smt2UartSetBaudrate()
	Prototype		: static smtBoolean smt2UartSetBaudrate(smtUint32 baudrate)
	Return			: 
	Argument		: 
	Comments		:
------------------------------------------------------------------------------*/
static smtBoolean smt2UartSetBaudrate(smtUint32 baudrate)
{
	//shkim-20070108 : set baudrate
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
