/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : uart_pre_drv.c 
	Description : Uart Pre-layer driver
	Created by  : SHMT SOC Team
------------------------------------------------------------------------------*/
/*//////////////////////////////////////////////////////////////////////////////
        INCLUDE
//////////////////////////////////////////////////////////////////////////////*/
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "uart_pre_drv.h"

/*//////////////////////////////////////////////////////////////////////////////
        DEFINITIOIN
//////////////////////////////////////////////////////////////////////////////*/

/*//////////////////////////////////////////////////////////////////////////////
        FUNCTION
//////////////////////////////////////////////////////////////////////////////*/
/*------------------------------------------------------------------------------
	Function name	: smtUartSetMode()
	Prototype		: smtBoolean smtUartSetMode(UartChannel uartCh,UART_STRUCT *uart, UART_MODE mode)
	Return			: error code
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtBoolean smtUartSetMode(UartChannel uartCh, UartStruct *pUart, UartMode mode)
{
	smtUint32 regValue;
	smtUint32 uartBaseAddr;
	
	//get the channel based address of uart
	if(uartCh == UART_CHANNEL0)
		uartBaseAddr = UART0_BASE_ADDR;
	else if(uartCh == UART_CHANNEL1)
		uartBaseAddr = UART1_BASE_ADDR;

	//set/get uart register based on uart channel
	switch(mode)
	{
		case SET_UARTMASTER:
			/*Set Uart Master Command Register*/
			SMT_WRITE(*(volatile unsigned *)(uartBaseAddr + UART_OFFSET_MASTER),
				pUart->uartMaster.uartEn			<<SHIFT_DN_FROM_MASK(MASTER_EN_UART)		|
				pUart->uartMaster.intEn			<<SHIFT_DN_FROM_MASK(MASTER_EN_INT)			|
				pUart->uartMaster.rxTimeoutEn	<<SHIFT_DN_FROM_MASK(MASTER_EN_RX_TIMEOUT)	|
				pUart->uartMaster.swReset		<<SHIFT_DN_FROM_MASK(MASTER_SW_RESET)		|
				pUart->uartMaster.dmaReqEn		<<SHIFT_DN_FROM_MASK(MASTER_EN_DMA_REQ)		|
				pUart->uartMaster.parity			<<SHIFT_DN_FROM_MASK(MASTER_PARITY)			|
				pUart->uartMaster.dataBit		<<SHIFT_DN_FROM_MASK(MASTER_DATA_BIT)		|
				pUart->uartMaster.stopBit		<<SHIFT_DN_FROM_MASK(MASTER_STOP_BIT)		|
				pUart->uartMaster.loopbackEn		<<SHIFT_DN_FROM_MASK(MASTER_EN_LOOPBACK)	|
				pUart->uartMaster.txWaterLev		<<SHIFT_DN_FROM_MASK(MASTER_TX_WATER_LEV)	|
				pUart->uartMaster.rxWaterLev		<<SHIFT_DN_FROM_MASK(MASTER_RX_WATER_LEV)	);
			break;
		
		case SET_UARTBRD :
			/* Set UART Baudrate Generation register */
			SMT_WRITE(*(volatile unsigned *)(uartBaseAddr + UART_OFFSET_BRD),
 				pUart->uartBaudGen << SHIFT_DN_FROM_MASK(UART_BAUDRATE_GEN));
			break;
			
		case SET_UARTRXTIMEOUT :
			/* Set UART receive timeout register */			
			SMT_WRITE(*(volatile unsigned *)(uartBaseAddr + UART_OFFSET_RXTIMEOUT),
 				pUart->uartRxTimeout << SHIFT_DN_FROM_MASK(RX_TIME_OUT));
			break;
		
		default :
			return SMT_ERROR;
	}
	return SMT_SUCCESS;
}
/*------------------------------------------------------------------------------
	Function name	: smtUartGetMode()
	Prototype		: smtBoolean smtUartSetMode(UartChannel uartCh,UART_STRUCT *uart, UART_MODE mode)
	Return			: error code
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtBoolean smtUartGetMode(UartChannel uartCh, UartStruct *pUart, UartMode mode)
{
	smtUint32 regValue;
	smtUint32 uartBaseAddr;
	
	//get the channel based address of uart
	if(uartCh == UART_CHANNEL0)
		uartBaseAddr = UART0_BASE_ADDR;
	else if(uartCh == UART_CHANNEL1)
		uartBaseAddr = UART1_BASE_ADDR;

	//set/get uart register based on uart channel
	switch(mode)
	{
		case GET_UARTMASTER :
			/*Get Uart Master Command Register*/
			regValue = SMT_READ(*(volatile unsigned *)(uartBaseAddr + UART_OFFSET_MASTER));
			pUart->uartMaster.uartEn 		= ((regValue & MASTER_EN_UART) 		>>SHIFT_DN_FROM_MASK(MASTER_EN_UART));
			pUart->uartMaster.intEn			= ((regValue & MASTER_EN_INT)		>>SHIFT_DN_FROM_MASK(MASTER_EN_INT));
			pUart->uartMaster.rxTimeoutEn	= ((regValue & MASTER_EN_RX_TIMEOUT)>>SHIFT_DN_FROM_MASK(MASTER_EN_RX_TIMEOUT));
			pUart->uartMaster.dmaReqEn		= ((regValue & MASTER_EN_DMA_REQ) 	>>SHIFT_DN_FROM_MASK(MASTER_EN_DMA_REQ));
			pUart->uartMaster.parity			= ((regValue & MASTER_PARITY) 		>>SHIFT_DN_FROM_MASK(MASTER_PARITY));
			pUart->uartMaster.dataBit		= ((regValue & MASTER_DATA_BIT) 	>>SHIFT_DN_FROM_MASK(MASTER_DATA_BIT));
			pUart->uartMaster.stopBit		= ((regValue & MASTER_STOP_BIT) 	>>SHIFT_DN_FROM_MASK(MASTER_STOP_BIT));
			pUart->uartMaster.loopbackEn		= ((regValue & MASTER_EN_LOOPBACK) 	>>SHIFT_DN_FROM_MASK(MASTER_EN_LOOPBACK));
			pUart->uartMaster.txWaterLev		= ((regValue & MASTER_TX_WATER_LEV) >>SHIFT_DN_FROM_MASK(MASTER_TX_WATER_LEV));
			pUart->uartMaster.rxWaterLev		= ((regValue & MASTER_RX_WATER_LEV) >>SHIFT_DN_FROM_MASK(MASTER_RX_WATER_LEV));
			break;
		
		case GET_UARTSTATUS :
			/* Get UART Status register */
			regValue = SMT_READ(*(volatile unsigned *)(uartBaseAddr + UART_OFFSET_STATUS));
			
			pUart->uartStatus.interrupt 		= ((regValue & STATUS_INTERRUPT)		>>SHIFT_DN_FROM_MASK(STATUS_INTERRUPT));
			pUart->uartStatus.maxFifoDepth 	= ((regValue & STATUS_MAX_FIFO_DEPTH)	>>SHIFT_DN_FROM_MASK(STATUS_MAX_FIFO_DEPTH));
			pUart->uartStatus.txBusy 		= ((regValue & STATUS_TX_BUSY)			>>SHIFT_DN_FROM_MASK(STATUS_TX_BUSY));
			pUart->uartStatus.rxBusy 		= ((regValue & STATUS_RX_BUSY)			>>SHIFT_DN_FROM_MASK(STATUS_RX_BUSY));
			pUart->uartStatus.parityErr 		= ((regValue & STATUS_PARITY_ERR)		>>SHIFT_DN_FROM_MASK(STATUS_PARITY_ERR));
			pUart->uartStatus.frameErr 		= ((regValue & STATUS_FRAME_ERR)		>>SHIFT_DN_FROM_MASK(STATUS_FRAME_ERR));
			pUart->uartStatus.overrunErr 	= ((regValue & STATUS_OVERRUN_ERR)		>>SHIFT_DN_FROM_MASK(STATUS_OVERRUN_ERR));
			pUart->uartStatus.rxTimeout 		= ((regValue & STATUS_RX_TIMEOUT)		>>SHIFT_DN_FROM_MASK(STATUS_RX_TIMEOUT));
			pUart->uartStatus.txFifoDMAReq 	= ((regValue & STATUS_TX_FIFO_DMA_REQ)	>>SHIFT_DN_FROM_MASK(STATUS_TX_FIFO_DMA_REQ));
			pUart->uartStatus.txFifoCnt 		= ((regValue & STATUS_TX_FIFO_CNT)		>>SHIFT_DN_FROM_MASK(STATUS_TX_FIFO_CNT));
			pUart->uartStatus.rxFifoDMAReq 	= ((regValue & STATUS_RX_FIFO_DAM_REQ)	>>SHIFT_DN_FROM_MASK(STATUS_RX_FIFO_DAM_REQ));
			pUart->uartStatus.rxFifoCnt 		= ((regValue & STATUS_RX_FIFO_CNT)		>>SHIFT_DN_FROM_MASK(STATUS_RX_FIFO_CNT));
			break;
		
		case GET_UARTBRD :
			/* Get UART Baudrate Generation register */
			regValue = SMT_READ(*(volatile unsigned *)(uartBaseAddr + UART_OFFSET_BRD));
			pUart->uartBaudGen = ((regValue & UART_BAUDRATE_GEN)>>SHIFT_DN_FROM_MASK(UART_BAUDRATE_GEN));
			break;

		case GET_UARTRXTIMEOUT :
			/* Get UART receive timeout register */
			regValue = SMT_READ(*(volatile unsigned *)(uartBaseAddr + UART_OFFSET_RXTIMEOUT));
			pUart->uartRxTimeout = ((regValue & RX_TIME_OUT)>>SHIFT_DN_FROM_MASK(RX_TIME_OUT));
			break;
		
		default :
			return SMT_ERROR;
	}
	return SMT_SUCCESS;
}/*------------------------------------------------------------------------------
	Function name	: smtUartSetBaudRate(UartChannel uartCh)
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtUint8 smtUartReadRxFifo(UartChannel uartCh)
{
	smtUint8 regRead;
	if(uartCh == UART_CHANNEL0)
		regRead = (smtUint8)SMT_READ(UART0RXFIFO);
	else if(uartCh == UART_CHANNEL1)
		regRead = (smtUint8)SMT_READ(UART1RXFIFO);
		
	return regRead;
}
/*------------------------------------------------------------------------------
	Function name	: smtUartWriteTxFifo(UartChannel uartCh)
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
void smtUartWriteTxFifo(UartChannel uartCh, smtUint8 txData)
{
	if(uartCh == UART_CHANNEL0)
	{
		SMT_WRITE(UART0TXFIFO, txData);
	}
	else if(uartCh == UART_CHANNEL1)
	{
		SMT_WRITE(UART1TXFIFO, txData);
	}
}
#if 0
// Initialize Function
/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtBoolean smtUartInit(void)
{
	smtUint32 dwCount=0;

	//shkim-20070104 : system dependent code(ex) GPIO, UART CLOCK)

	smtUartDisableInterrupt(RX_INT|TX_INT|ERROR_INT);
	// Mask all interrupt.
	while ((smtUartGetInterruptStatus() & (RX_INT|TX_INT|ERROR_INT))!=0 && 
	dwCount <MAX_RETRY) 
	{ // Interrupt.
		smtUartInitReceive(SMT_TRUE);
		smtUartInitLine(SMT_TRUE);
		smtUartClearInterrupt(RX_INT||ERROR_INT);
		dwCount++;
	}
}

// Tx Function
/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtBoolean smtUartInitXmit(smtBoolean bInit)
{
	smtBoolean bRet = SMT_TRUE;
	UART_STRUCT uartStr;
	memset(&uartStr,0x0,sizeof(uartStr));
	
    if (bInit) 
    { 
		//flush tx fifo
		smtUartSetMode(&uartStr, GET_UARTLCR);
		uartStr.lineCtrl.fifoEn = SMT_FALSE;
		smtUartSetMode(&uartStr, SET_UARTLCR);

		//set tx interrupt fifo level selector register
		smtUartSetMode(&uartStr, GET_UARTIFLS);
		uartStr.txIntLevel = INT_LEVEL_1BY8;
		smtUartSetMode(&uartStr, SET_UARTIFLS);

		//tx fifo enable
		smtUartSetMode(&uartStr, GET_UARTLCR);
		uartStr.lineCtrl.fifoEn = SMT_TRUE;
		smtUartSetMode(&uartStr, SET_UARTLCR);
		
    	//tx enable
		smtUartSetMode(&uartStr, GET_UARTCR);
		uartStr.uartCtrl.txEn = SMT_TRUE;
		uartStr.uartCtrl.uartEn = SMT_TRUE;
		smtUartSetMode(&uartStr, SET_UARTCR);
    }
    else
    {
		smtUint32 dwTicks = 0;
		smtUint32 dwUTRState;
		while(dwTicks < 1000)
		{
			smtUartSetMode(&uartStr,GET_UARTFR);
			if(uartStr.uartFlag.txFE == SMT_TRUE)
				break;
			dwTicks +=5;
		}
    }
    return SMT_TRUE;
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void    smtUartXmitInterruptHandler(void)
{
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtUint32    smtUartXmitComChar(smtUint8 ComChar)
{
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtBoolean    smtUartEnableXmitInterrupt(smtBoolean fEnable)
{
	if (fEnable)
		smtUartEnableInterrupt(TX_INT);
	else
		smtUartDisableInterrupt(TX_INT);

}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtBoolean    smtUartCancelXmit()
{
	return smtUartInitXmit(SMT_TRUE);
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtUint32   smtUartGetWriteableSize()
{
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtBoolean    smtUartInitReceive(smtBoolean bInit)
{
	smtBoolean bRet = SMT_TRUE;
	UART_STRUCT uartStr;
	memset(&uartStr,0x0,sizeof(uartStr));

    if (bInit) 
    {         
        //fifo disable.
		smtUartSetMode(&uartStr, GET_UARTLCR);
		uartStr.lineCtrl.fifoEn = SMT_FALSE;
		smtUartSetMode(&uartStr, SET_UARTLCR);

        // Set Trigger level to WaterMark.
        smtUartSetMode(&uartStr, GET_UARTIFLS);
		uartStr.rxIntLevel = INT_LEVEL_1BY8;
		smtUartSetMode(&uartStr, SET_UARTIFLS);
		
        // Enable Receive FIFO.
        smtUartSetMode(&uartStr, GET_UARTLCR);
        uartStr.lineCtrl.fifoEn = SMT_TRUE;
        smtUartSetMode(&uartStr, SET_UARTLCR);
        
		//clean line error
    	//m_pReg2440Uart->Read_UERSTAT(); // Clean Line Interrupt.
		uartStr.status = (STATUS_FRAME_ERR|STATUS_PARITY_ERR|STATUS_BREAK_ERR|STATUS_OVERRUN_ERR);
		smtUartSetMode(&uartStr,CLR_UARTSR);

		//enable rx
		smtUartSetMode(&uartStr, GET_UARTCR);
		uartStr.uartCtrl.rxEn = SMT_TRUE;
		uartStr.uartCtrl.uartEn = SMT_TRUE;
		smtUartSetMode(&uartStr, SET_UARTCR);

        smtUartEnableInterrupt( RX_INT | ERROR_INT );
    }
    else 
    {
        smtUartDisableInterrupt(RX_INT | ERROR_INT );
    }
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtUint32   smtUartReceiveInterruptHandler(void)
{
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtUint32   smtUartCancelReceive()
{
	return smtUartInitReceive(SMT_TRUE);
}

/*
	Currently, Implement to null function.
	Implementation -> Further work
*/
// Modem
/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtBoolean    smtUartInitModem(smtBoolean bInit)
{
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void    smtUartModemInterruptHandler()
{
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtUint32   smtUartGetModemStatus()
{
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void    smtUartSetDTR(smtBoolean bSet)
{
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void    smtUartSetRTS(smtBoolean bSet)
{
}

// Line Function.
/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtBoolean    smtUartInitLine(smtBoolean bInit)
{
    if  (bInit) {
        smtUartEnableInterrupt( ERROR_INT );
    }
    else {
        smtUartDisableInterrupt(ERROR_INT );
    }
    return SMT_SUCCESS;
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void    smtUartLineInterruptHandler()
{
	// write some data on [7:0] of UARTSR to clear UARTSR
	// refer to SDI spec page 32.
	smtBoolean bRet = SMT_TRUE;
	UART_STRUCT uartStr;
	memset(&uartStr,0x0,sizeof(uartStr));
	
	uartStr.status = (STATUS_FRAME_ERR|STATUS_PARITY_ERR|STATUS_BREAK_ERR|STATUS_OVERRUN_ERR);
	smtUartSetMode(&uartStr,CLR_UARTSR);
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtBoolean    smtUartSetByteSize(smtUint32 ByteSize)
{
	smtBoolean bRet = SMT_TRUE;
	UART_STRUCT uartStr;
	memset(&uartStr,0x0,sizeof(uartStr));

	smtUartSetMode(&uartStr, GET_UARTLCR);
    switch ( ByteSize ) 
    {
	    case 5: 
			uartStr.lineCtrl.wordLengh = DATA_5BIT;
	        break;
	    case 6:
			uartStr.lineCtrl.wordLengh = DATA_6BIT;
	        break;
	    case 7:
			uartStr.lineCtrl.wordLengh = DATA_7BIT;
	        break;
	    case 8:
			uartStr.lineCtrl.wordLengh = DATA_8BIT;
	        break;
	    default:
	        bRet = SMT_FALSE;
	        break;
    }
	if(bRet)
	{
		smtUartSetMode(&uartStr, SET_UARTLCR);
	}
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtBoolean    smtUartSetStopBits(smtUint32 StopBits)
{
	smtBoolean bRet = SMT_TRUE;
	UART_STRUCT uartStr;
	memset(&uartStr,0x0,sizeof(uartStr));

	smtUartSetMode(&uartStr, GET_UARTLCR);
	
    switch ( StopBits )
	{
	    case ONESTOPBIT :
			 uartStr.lineCtrl.stopSel = ONE_STOP_BIT;    
	        break;
	    case TWOSTOPBITS :
	        uartStr.lineCtrl.stopSel = TWO_STOP_BIT;
	        break;
	    default:
	        bRet = SMT_FALSE;
	        break;
    }
    if (bRet)
	{
		smtUartSetMode(&uartStr, SET_UARTLCR);
    }
    return bRet;
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtBoolean    smtUartSetParity(smtUint32 Parity)
{
	smtUint32 ulData = 0;
	smtBoolean bRet  = SMT_TRUE;
	UART_STRUCT uartStr;
	memset(&uartStr,0x0,sizeof(uartStr));

	smtUartSetMode(&uartStr,GET_UARTLCR);
	
	switch ( Parity ) 
	{	
	    case EVENPARITY:
			uartStr.lineCtrl.parityEn 		= PARITY_ENABLE;
			uartStr.lineCtrl.paritySel		= EVEN_PARITY;
			uartStr.lineCtrl.stickParitySel = SEND_BREAK_DISABLE;
	        break;
		
	    case ODDPARITY:
			uartStr.lineCtrl.parityEn 		= PARITY_ENABLE;
			uartStr.lineCtrl.paritySel		= ODD_PARITY;
			uartStr.lineCtrl.stickParitySel = SEND_BREAK_DISABLE;
			break;
			
	    case SPACEPARITY:
			uartStr.lineCtrl.parityEn 		= PARITY_ENABLE;
			uartStr.lineCtrl.paritySel		= ODD_PARITY;
			uartStr.lineCtrl.stickParitySel = SEND_BREAK_ENABLE;
	        break;
	        
	    case MARKPARITY:
			uartStr.lineCtrl.parityEn 		= PARITY_ENABLE;
			uartStr.lineCtrl.paritySel		= EVEN_PARITY;
			uartStr.lineCtrl.stickParitySel = SEND_BREAK_ENABLE;
	        break;
	        
	    case NOPARITY:
	        break;
	    default:
	        bRet = SMT_FALSE;
	        break;
	}
    if (bRet) 
    {
       smtUartSetMode(&uartStr, SET_UARTLCR);
    }
    return bRet;
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void    smtUartSetBreak(smtBoolean bSet)
{
		UART_STRUCT uartStr;
		memset(&uartStr,0x0,sizeof(uartStr));

		smtUartSetMode(&uartStr, GET_UARTLCR);

		if(bSet == SMT_TRUE)
			uartStr.lineCtrl.sendBreak = SEND_BREAK_ENABLE;
		else
			uartStr.lineCtrl.sendBreak = SEND_BREAK_DISABLE;
		
		smtUartSetMode(&uartStr, SET_UARTLCR);
}

// Line Internal Function
/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtUint8	smtUartGetLineStatus()
{
		UART_STRUCT uartStr;
		memset(&uartStr,0x0,sizeof(uartStr));

		smtUartSetMode(&uartStr, GET_UARTSR);
		return uartStr.status;
}

// Interrupt
/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void    smtUartEnableInterrupt(smtUint32 dwInt)
{ 
		UART_STRUCT uartStr;
		memset(&uartStr,0x0,sizeof(uartStr));
		
        smtUartSetMode(&uartStr, GET_UARTIMSC);
        uartStr.intMask |= dwInt;
        smtUartSetMode(&uartStr, SET_UARTIMSC);
        
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void    smtUartDisableInterrupt(smtUint32 dwInt)
{
		UART_STRUCT uartStr;
		memset(&uartStr,0x0,sizeof(uartStr));
		
        uartStr.intMask = dwInt;
        smtUartSetMode(&uartStr, CLR_UARTIMSC);
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void    smtUartClearInterrupt(smtUint32 dwInt)
{
		UART_STRUCT uartStr;
		memset(&uartStr,0x0,sizeof(uartStr));
		
        uartStr.intClear = dwInt;
        smtUartSetMode(&uartStr, SET_UARTICR);
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtUint32   smtUartGetInterruptStatus()
{
		UART_STRUCT uartStr;
		memset(&uartStr,0x0,sizeof(uartStr));
        smtUartSetMode(&uartStr, GET_UARTMIS);
        return uartStr.intMaskedSrc;
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtUint32   smtUartGetIntrruptMask () 
{
		UART_STRUCT uartStr;
		memset(&uartStr,0x0,sizeof(uartStr));
		
        smtUartSetMode(&uartStr, GET_UARTIMSC);
        return uartStr.intMask;
}

//  Power Manager Required Function.
/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void    smtUartSerialRegisterBackup()
{
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
void    smtUartSerialRegisterRestore()
{
}

/*------------------------------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
------------------------------------------------------------------------------*/
smtBoolean smtUartPurgeComm( smtUint32 fdwAction)
{
    if (fdwAction & PURGE_RXCLEAR ) {
        smtUartCancelReceive();
    }
    if (fdwAction & PURGE_TXCLEAR ) {
        smtUartCancelXmit();
    }
    return SMT_TRUE;
}

/*------------------------------------------------------------------------------
	Function name	: smtUartSetBaudRate()
	Prototype		: smtBoolean smtUartSetBaudRate(smtUint32 baudRate)
	Return			: error code
	Argument		:
	Comments		:
		Baud-rate setting
		baudDiv = 8M/(16*baudrate)
		iBRD = Integer(baudDiv)
		fBRD = baudDiv - iBRD
		m = integer(fBRD*2n+0.5)
------------------------------------------------------------------------------*/
smtBoolean smtUartSetBaudRate(smtUint32 baudRate)
{
	smtUint32 iBRD, m;
	smtFloat baudDiv, fBRD;
	
	baudDiv = (UART_CLOCK*1000000)/(16*baudRate);
	iBRD = (smtUint32)baudDiv;
	fBRD = baudDiv - iBRD;
	m = (smtUint32)(fBRD*64+0.5); // m = integer(BFDF*2n + 0.5) - n is width of UARTFBRD
	
	SMT_WRITE(UARTIBRD, iBRD);
	SMT_WRITE(UARTFBRD, m);
	//baudDiv = iBRD + m/64;
	//realBaudRate = (8*1000000)/(16*baudDiv);
	
	return SMT_SUCCESS;
}
#endif

