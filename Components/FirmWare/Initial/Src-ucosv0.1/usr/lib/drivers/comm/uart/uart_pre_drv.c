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

/*
//////////////////////////////////////////////////////////////////////////////
        INCLUDE
//////////////////////////////////////////////////////////////////////////////
*/

#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "uart_pre_drv.h"

/*
//////////////////////////////////////////////////////////////////////////////
        DEFINITIOIN
//////////////////////////////////////////////////////////////////////////////
*/

/*
//////////////////////////////////////////////////////////////////////////////
        FUNCTION
//////////////////////////////////////////////////////////////////////////////
*/

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
		uartBaseAddr = UART0_BASEADDR;
	else if(uartCh == UART_CHANNEL1)
		uartBaseAddr = UART1_BASEADDR;
	else if(uartCh == UART_CHANNEL2)
		uartBaseAddr = UART2_BASEADDR;
	else if(uartCh == UART_CHANNEL3)
		uartBaseAddr = UART3_BASEADDR;
	else 
		return SMT_ERROR;

	//set/get uart register based on uart channel
	switch(mode)
	{
		case SET_UARTMASTER:
			/*Set Uart Master Command Register*/
			regValue = 
				((pUart->uartMaster.uartEn		<<SHIFT_DN_FROM_MASK(MASTER_EN_UART)) 		& MASTER_EN_UART)		|
				((pUart->uartMaster.intEn		<<SHIFT_DN_FROM_MASK(MASTER_EN_INT)) 		& MASTER_EN_INT)		|
				((pUart->uartMaster.rxTimeoutEn	<<SHIFT_DN_FROM_MASK(MASTER_EN_RX_TIMEOUT)) & MASTER_EN_RX_TIMEOUT)	|
				((pUart->uartMaster.swReset		<<SHIFT_DN_FROM_MASK(MASTER_SW_RESET)) 		& MASTER_SW_RESET)		|
				((pUart->uartMaster.dmaReqEn	<<SHIFT_DN_FROM_MASK(MASTER_EN_DMA_REQ)) 	& MASTER_EN_DMA_REQ)	|
				((pUart->uartMaster.parity		<<SHIFT_DN_FROM_MASK(MASTER_PARITY)) 		& MASTER_PARITY)		|
				((pUart->uartMaster.dataBit		<<SHIFT_DN_FROM_MASK(MASTER_DATA_BIT)) 		& MASTER_DATA_BIT)		|
				((pUart->uartMaster.stopBit		<<SHIFT_DN_FROM_MASK(MASTER_STOP_BIT)) 		& MASTER_STOP_BIT)		|
				((pUart->uartMaster.loopbackEn	<<SHIFT_DN_FROM_MASK(MASTER_EN_LOOPBACK)) 	& MASTER_EN_LOOPBACK)	|
				((pUart->uartMaster.txIntEn		<<SHIFT_DN_FROM_MASK(MASTER_TX_FIFO_INT_EN))& MASTER_TX_FIFO_INT_EN)|	
				((pUart->uartMaster.rxIntEn		<<SHIFT_DN_FROM_MASK(MASTER_RX_FIFO_INT_EN))& MASTER_RX_FIFO_INT_EN)|		
				((pUart->uartMaster.txWaterLev	<<SHIFT_DN_FROM_MASK(MASTER_TX_WATER_LEV)) 	& MASTER_TX_WATER_LEV)	|
				((pUart->uartMaster.rxWaterLev	<<SHIFT_DN_FROM_MASK(MASTER_RX_WATER_LEV)) 	& MASTER_RX_WATER_LEV);

			SMT_WRITE(*(volatile unsigned *)(uartBaseAddr + UART_OFFSET_MASTER), regValue);
			break;
		
		case SET_UARTBRD :
			/* Set UART Baudrate Generation register */
			SMT_WRITE(*(volatile unsigned *)(uartBaseAddr + UART_OFFSET_BRD),
 				((pUart->uartBaudGen << SHIFT_DN_FROM_MASK(UART_BAUDRATE_GEN)) & UART_BAUDRATE_GEN));
			break;
			
		case SET_UARTRXTIMEOUT :
			/* Set UART receive timeout register */			
			SMT_WRITE(*(volatile unsigned *)(uartBaseAddr + UART_OFFSET_RXTIMEOUT),
 				((pUart->uartRxTimeout << SHIFT_DN_FROM_MASK(RX_TIME_OUT)) & RX_TIME_OUT));
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
		uartBaseAddr = UART0_BASEADDR;
	else if(uartCh == UART_CHANNEL1)
		uartBaseAddr = UART1_BASEADDR;
	else if(uartCh == UART_CHANNEL2)
		uartBaseAddr = UART2_BASEADDR;
	else if(uartCh == UART_CHANNEL3)
		uartBaseAddr = UART3_BASEADDR;
	else
		return SMT_ERROR;

	//set/get uart register based on uart channel
	switch(mode)
	{
		case GET_UARTMASTER :
			/*Get Uart Master Command Register*/
			regValue = SMT_READ(*(volatile unsigned *)(uartBaseAddr + UART_OFFSET_MASTER));
			pUart->uartMaster.uartEn 		= ((regValue & MASTER_EN_UART) 		>>SHIFT_DN_FROM_MASK(MASTER_EN_UART));
			pUart->uartMaster.intEn			= ((regValue & MASTER_EN_INT)		>>SHIFT_DN_FROM_MASK(MASTER_EN_INT));
			pUart->uartMaster.rxTimeoutEn	= ((regValue & MASTER_EN_RX_TIMEOUT)>>SHIFT_DN_FROM_MASK(MASTER_EN_RX_TIMEOUT));
			pUart->uartMaster.swReset		= 0;
			pUart->uartMaster.dmaReqEn		= ((regValue & MASTER_EN_DMA_REQ) 	>>SHIFT_DN_FROM_MASK(MASTER_EN_DMA_REQ));
			pUart->uartMaster.parity		= ((regValue & MASTER_PARITY) 		>>SHIFT_DN_FROM_MASK(MASTER_PARITY));
			pUart->uartMaster.dataBit		= ((regValue & MASTER_DATA_BIT) 	>>SHIFT_DN_FROM_MASK(MASTER_DATA_BIT));
			pUart->uartMaster.stopBit		= ((regValue & MASTER_STOP_BIT) 	>>SHIFT_DN_FROM_MASK(MASTER_STOP_BIT));
			pUart->uartMaster.loopbackEn	= ((regValue & MASTER_EN_LOOPBACK) 	>>SHIFT_DN_FROM_MASK(MASTER_EN_LOOPBACK));
			pUart->uartMaster.txIntEn		= ((regValue & MASTER_TX_FIFO_INT_EN)>>SHIFT_DN_FROM_MASK(MASTER_TX_FIFO_INT_EN));
			pUart->uartMaster.rxIntEn		= ((regValue & MASTER_RX_FIFO_INT_EN)>>SHIFT_DN_FROM_MASK(MASTER_RX_FIFO_INT_EN));
			pUart->uartMaster.txWaterLev	= ((regValue & MASTER_TX_WATER_LEV) >>SHIFT_DN_FROM_MASK(MASTER_TX_WATER_LEV));
			pUart->uartMaster.rxWaterLev	= ((regValue & MASTER_RX_WATER_LEV) >>SHIFT_DN_FROM_MASK(MASTER_RX_WATER_LEV));
			break;
		
		case GET_UARTSTATUS :
			/* Get UART Status register */
			regValue = SMT_READ(*(volatile unsigned *)(uartBaseAddr + UART_OFFSET_STATUS));
			
			pUart->uartStatus.interrupt 	= ((regValue & STATUS_INTERRUPT)		>>SHIFT_DN_FROM_MASK(STATUS_INTERRUPT));
			pUart->uartStatus.maxFifoDepth 	= ((regValue & STATUS_MAX_FIFO_DEPTH)	>>SHIFT_DN_FROM_MASK(STATUS_MAX_FIFO_DEPTH));
			pUart->uartStatus.txBusy 		= ((regValue & STATUS_TX_BUSY)			>>SHIFT_DN_FROM_MASK(STATUS_TX_BUSY));
			pUart->uartStatus.rxBusy 		= ((regValue & STATUS_RX_BUSY)			>>SHIFT_DN_FROM_MASK(STATUS_RX_BUSY));
			pUart->uartStatus.parityErr 	= ((regValue & STATUS_PARITY_ERR)		>>SHIFT_DN_FROM_MASK(STATUS_PARITY_ERR));
			pUart->uartStatus.frameErr 		= ((regValue & STATUS_FRAME_ERR)		>>SHIFT_DN_FROM_MASK(STATUS_FRAME_ERR));
			pUart->uartStatus.overrunErr 	= ((regValue & STATUS_OVERRUN_ERR)		>>SHIFT_DN_FROM_MASK(STATUS_OVERRUN_ERR));
			pUart->uartStatus.rxTimeout 	= ((regValue & STATUS_RX_TIMEOUT)		>>SHIFT_DN_FROM_MASK(STATUS_RX_TIMEOUT));
			pUart->uartStatus.txFifoDMAReq 	= ((regValue & STATUS_TX_FIFO_DMA_REQ)	>>SHIFT_DN_FROM_MASK(STATUS_TX_FIFO_DMA_REQ));
			pUart->uartStatus.txFifoCnt 	= ((regValue & STATUS_TX_FIFO_CNT)		>>SHIFT_DN_FROM_MASK(STATUS_TX_FIFO_CNT));
			pUart->uartStatus.rxFifoDMAReq 	= ((regValue & STATUS_RX_FIFO_DAM_REQ)	>>SHIFT_DN_FROM_MASK(STATUS_RX_FIFO_DAM_REQ));
			pUart->uartStatus.rxFifoCnt 	= ((regValue & STATUS_RX_FIFO_CNT)		>>SHIFT_DN_FROM_MASK(STATUS_RX_FIFO_CNT));
			pUart->uartStatus.txFifoInt		= ((regValue & STATUS_TX_FIFO_INT)		>>SHIFT_DN_FROM_MASK(STATUS_TX_FIFO_INT));
			pUart->uartStatus.rxFifoInt		= ((regValue & STATUS_RX_FIFO_INT)		>>SHIFT_DN_FROM_MASK(STATUS_RX_FIFO_INT));
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
}

/*------------------------------------------------------------------------------
	Function name	: smtUartReadRxFifo()
	Prototype		: smtUint8 smtUartReadRxFifo(UartChannel uartCh)
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
	else if(uartCh == UART_CHANNEL2)
		regRead = (smtUint8)SMT_READ(UART2RXFIFO);
	else if(uartCh == UART_CHANNEL3)
		regRead = (smtUint8)SMT_READ(UART3RXFIFO);
	return regRead;
}
/*------------------------------------------------------------------------------
	Function name	: smtUartWriteTxFifo()
	Prototype		: void smtUartWriteTxFifo(UartChannel uartCh, smtUint8 txData)
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
	else if(uartCh == UART_CHANNEL2)
	{
		SMT_WRITE(UART2TXFIFO, txData);
	}
	else if(uartCh == UART_CHANNEL3)
	{
		SMT_WRITE(UART3TXFIFO, txData);
	}
	
}

/*-----------------------------------------------------------------------
    Function name   : smtUartDataAvailable()
    Prototype       : smtUint32 smtUartDataAvailable(void)
    Return          : 1 when you can read Uart RX Data
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
smtUint32 smtUartDataAvailable(void)
{
	return ((SMT_READ(UART0STATUS) & 0x0000003f) != 0x00000000);
}

