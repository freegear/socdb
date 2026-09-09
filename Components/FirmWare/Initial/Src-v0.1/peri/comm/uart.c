/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: uart.c 
	Description	: uart test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
//#include "irq.h"

#include "uart_pre_drv.h"
#include "uart.h"


/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
typedef struct 
{
	smtUint32 baudrate;
	smtUint8 uartCh;
	smtUint8 dataBit;
	smtUint8 parity;
	smtUint8 stopBit;
} UartTestPolling;

#define UART_IRQ_OFFSET_CHANNEL 8
#define APB1_CLK		(25*1000*1000) // 25 MHz
/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
static smtUint32 UARTReadWriteTest(void);
static smtUint32 UARTReadWriteLoopbackTest(UartTestPolling *testParam);
static smtUint32 UARTInterruptTest(void/*water level*/);
static smtUint32 UARTDMATest(void);
static smtUint32 UARTGetBaudrate(smtUint32 baudrate);
void ISRUART(smtUint32 irq);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
static volatile smtBoolean gUartTxInt = SMT_TRUE;
static volatile smtBoolean gUartRxInt = SMT_TRUE;
static volatile smtBoolean gUartRxTimeout = SMT_TRUE;
static volatile smtUint8 gTestChannel;	

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	Function name	: UARTTest()
	Prototype		: smtUint32 UARTTest(void)
	Return		: error code
	Argument	:
	Comments	: Return a error-code

		UART register list
			UARTXMASTER		- Master Command register(R/W)
			UARTXSTATUS		- Status register(R)
			UARTXBRD		- Baudrate(R/W) 
			UARTXTXFIFO		- TX FIFO Write register(W) 
			UARTXRXFIFO		- RX FIFO Read register(R)
			UARTXRXTIMEOUT	- RX timeout count register(R/W)
----------------------------------------------------------*/
smtUint32 UARTTest(void)
{
	smtUint32 errCode;
	
	// TEST1 : Register R/W
	(smtBoolean)errCode = RegisterUART();
	if (errCode != SMT_SUCCESS)
		return SMT_ERROR;

	// TEST2 : Read/Write Loopback Test
	errCode = UARTReadWriteTest();
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;

	// TEST3 : interrupt test
	errCode = UARTInterruptTest();
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;

	// TEST4 : DMA test
	errCode = UARTDMATest();
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;
	
}

/*----------------------------------------------------------
	Function name	: UARTReadWriteTest()
	Prototype		: static smtUint32 UARTReadWriteTest(void)

	Return		: error code
	Argument	:
	Comments	: Return a error-code
	uart read/write test
----------------------------------------------------------*/
static smtUint32 UARTReadWriteTest(void)
{
	smtUint32 errCode;
	UartTestPolling testParam;
	smtUint8 channel[] 	= {UART_CHANNEL0,UART_CHANNEL1,UART_CHANNEL2,UART_CHANNEL3};
	smtUint32 baudrate[]= {BAUD_9600,BAUD_14400,BAUD_19200,BAUD_38400,BAUD_115200};
	smtUint8 dataBit[] 	= {DATA_7BIT, DATA_8BIT};
	smtUint8 parity[] 	= {PARITY_DISABLE, PARITY_EVEN, PARITY_ODD};
	smtUint8 stopBit[]	= {ONE_STOP_BIT, TWO_STOP_BIT};
	smtUint8 channelIdx, baudrateIdx, dataBitIdx, parityIdx, stopBitIdx;
	
	for(channelIdx=0 ; channelIdx < MAX_UART_CHANNEL; channelIdx++)
	{
		for(baudrateIdx=0 ; baudrateIdx < 6; baudrateIdx++)
		{
			for(dataBitIdx=0 ; dataBitIdx < 2 ; dataBitIdx)
			{
				for(parityIdx=0 ; parityIdx < 3 ; parityIdx)
				{
					for(stopBitIdx = 0 ; stopBitIdx < 2 ; stopBitIdx++)
					{
						testParam.uartCh	= channel[channelIdx];
						testParam.baudrate	= baudrate[baudrateIdx];
						testParam.dataBit	= dataBit[dataBitIdx];
						testParam.parity	= parity[parityIdx];
						testParam.stopBit	= stopBit[stopBitIdx];
						errCode = UARTReadWriteLoopbackTest(&testParam);
						if(errCode != SMT_SUCCESS)
						{
							//smtSetError();
							return SMT_ERROR;
						}
					}
				}
			}
		}
	}
	return SMT_SUCCESS;
}
/*----------------------------------------------------------
	Function name	: UARTReadWriteLoopbackTest()
	Prototype		: static smtUint32 UARTReadWriteLoopbackTest()
	Return		: error code
	Argument	:
	Comments	: Return a error-code
	uart loopback test
----------------------------------------------------------*/
static smtUint32 UARTReadWriteLoopbackTest(UartTestPolling *testParam)
{
	UartStruct uartCfg;
	smtUint8 uartMaxFifoSize;
	smtUint8 rxData[32]= {0,};
	smtUint32 buadrate;
	smtUint8 i;
	
	//set baud rate
	uartCfg.uartBaudGen = UARTGetBaudrate(testParam->baudrate);
	smtUartSetMode(testParam->uartCh,&uartCfg,SET_UARTBRD);
	//set uart master command
	uartCfg.uartMaster.uartEn		= 0x1;
	uartCfg.uartMaster.intEn		= 0x0;
	uartCfg.uartMaster.rxTimeoutEn	= 0x0;
	uartCfg.uartMaster.swReset		= 0x1;
	uartCfg.uartMaster.dmaReqEn		= 0x0;
	uartCfg.uartMaster.loopbackEn	= 0x1;
	uartCfg.uartMaster.parity		= testParam->parity;	//0x00:none 0x10:even 0x11:odd
	uartCfg.uartMaster.dataBit		= testParam->dataBit;	//0:7bit 1:8bit
	uartCfg.uartMaster.stopBit		= testParam->stopBit;	//0:1 stop bit 1: 2 stop bit
	//set fifo water level
	smtUartGetMode(testParam->uartCh, &uartCfg, GET_UARTSTATUS);
	uartMaxFifoSize = uartCfg.uartStatus.maxFifoDepth * 8;
	uartMaxFifoSize = (uartMaxFifoSize > 16) ? 32 : uartMaxFifoSize;
	uartCfg.uartMaster.txWaterLev = uartMaxFifoSize / 2;
	uartCfg.uartMaster.rxWaterLev = uartMaxFifoSize / 2;
	smtUartSetMode(testParam->uartCh, &uartCfg, SET_UARTMASTER);
	
	//sw reset
	
	//write char to tx fifo write register
	for(i = 0; i < uartMaxFifoSize ;i++)
	{
		// check if TX FIFO is full
		while(1)
		{
			smtUartGetMode(testParam->uartCh,&uartCfg, GET_UARTSTATUS);
			if(uartCfg.uartStatus.txFifoCnt != 32) break;
		}
		// WRITE
		smtUartWriteTxFifo(testParam->uartCh, i);
	}


	//read char from rx fifo read register
	for(i = 0 ; i < uartMaxFifoSize;i++)
	{
		// check if RX FIFO is not empty
		while(1)
		{
			smtUartGetMode(testParam->uartCh,&uartCfg, GET_UARTSTATUS);
			if(uartCfg.uartStatus.rxFifoCnt != 0) break;
		}
		// READ
		if(i != smtUartReadRxFifo(testParam->uartCh))
		{
			// smtSetError(LayerID, ID, Inform);
			return SMT_ERROR;
		}
	}

	// disable uart
	smtUartGetMode(testParam->uartCh, &uartCfg, GET_UARTMASTER);
	uartCfg.uartMaster.uartEn = 0x0;
	smtUartSetMode(testParam->uartCh, &uartCfg, SET_UARTMASTER);
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: UARTInterruptTest()
	Prototype		: static smtUint32 UARTInterruptTest(void)
	Return		: error code
	Argument	:
	Comments	: Return a error-code
	tx/rx fifo interrupt(each water level-0 ~ 31) test 
----------------------------------------------------------*/
static smtUint32 UARTInterruptTest(void/*water level*/)
{
	UartStruct uartCfg;
	UartTestPolling testParam;
	smtUint8 uartMaxFifoSize;
	smtUint8 channel,i;
	smtUint32 timeoutCnt;
	for(channel = 0 ; channel < 4; channel++)
	{
		testParam.baudrate	= BAUD_38400;
		testParam.dataBit	= DATA_8BIT;
		testParam.parity	= PARITY_DISABLE;
		testParam.stopBit	= ONE_STOP_BIT;
		testParam.uartCh = gTestChannel = channel;
		// init uart 
		//  - databit, parity, stop bit, baud rate, water level
		//  - interrupt enable
		uartCfg.uartBaudGen = UARTGetBaudrate(testParam.baudrate);
		smtUartSetMode(testParam.uartCh,&uartCfg,SET_UARTBRD);
		//set uart master command
		uartCfg.uartMaster.uartEn		= 0x1;
		uartCfg.uartMaster.intEn		= 0x1; //enable interrupt
		uartCfg.uartMaster.rxTimeoutEn	= 0x0;
		uartCfg.uartMaster.swReset		= 0x1;
		uartCfg.uartMaster.dmaReqEn		= 0x0;
		uartCfg.uartMaster.loopbackEn	= 0x1;
		uartCfg.uartMaster.parity		= testParam.parity;	//0x00:none 0x10:even 0x11:odd
		uartCfg.uartMaster.dataBit		= testParam.dataBit;	//0:7bit 1:8bit
		uartCfg.uartMaster.stopBit		= testParam.stopBit;	//0:1 stop bit 1: 2 stop bit
		//set fifo water level
		smtUartGetMode(testParam.uartCh, &uartCfg, GET_UARTSTATUS);
		uartMaxFifoSize = uartCfg.uartStatus.maxFifoDepth * 8;
		uartMaxFifoSize = (uartMaxFifoSize > 16) ? 32 : uartMaxFifoSize;
		uartCfg.uartMaster.txWaterLev = uartMaxFifoSize / 2;
		uartCfg.uartMaster.rxWaterLev = uartMaxFifoSize / 2;
		smtUartSetMode(testParam.uartCh, &uartCfg, SET_UARTMASTER);
		
		// RequestIRQ ISR
		RequestIRQ(testParam.uartCh+UART_IRQ_OFFSET_CHANNEL, ISRUART);

		// make interrupt condition 
		// - make tx fifo full
		//write char to tx fifo write register
		for(i = 0; i < uartMaxFifoSize ;i++)
		{
			// check if TX FIFO is full
			while(1)
			{
				smtUartGetMode(testParam.uartCh,&uartCfg, GET_UARTSTATUS);
				if(uartCfg.uartStatus.txFifoCnt != 32) break;
			}
			// WRITE
			smtUartWriteTxFifo(testParam.uartCh, i);
		}
		
		// check interrupt flag
		// - tx fifo interrupt
		// - rx fifo interrupt
		// - rx fifo timeout interrupt
		smtUartGetMode(testParam.uartCh, &uartCfg, GET_UARTMASTER);
		uartCfg.uartMaster.rxTimeoutEn = SMT_TRUE;
		smtUartSetMode(testParam.uartCh, &uartCfg, SET_UARTMASTER);
		
		uartCfg.uartRxTimeout = 0xFFF;
		smtUartSetMode(testParam.uartCh, &uartCfg, SET_UARTRXTIMEOUT);
		while( gUartTxInt | gUartRxInt | gUartRxTimeout )
		{
			timeoutCnt++;
			if(timeoutCnt > 0xFFFFFF)
			{
				//smtSetError();
				return SMT_ERROR;
			}
		}
		
		// ReleaseIRQ for uart
		ReleaseIRQ(testParam.uartCh+UART_IRQ_OFFSET_CHANNEL);
		
		// disable uart
		smtUartGetMode(testParam.uartCh, &uartCfg, GET_UARTMASTER);
		uartCfg.uartMaster.uartEn = 0x0;
		smtUartSetMode(testParam.uartCh, &uartCfg, SET_UARTMASTER);
	}
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: UARTDMATest()
	Prototype		: static smtUint32 UARTDMATest(void)
	Return		: error code
	Argument	:
	Comments	: Return a error-code
	get uart baudrate gen register value
----------------------------------------------------------*/
static smtUint32 UARTDMATest(void)
{


	// init dma controller for TX
	// init dma controller for RX
	// size must be set acording to the TX/RX water level
	
	// init uart

	// dma status check if DMA finished

	// then compare each TX/RX buffer
	
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

/*----------------------------------------------------------
	Function name	: ISRUART()
	Prototype		: static void ISRUART(smtUint32 irq)
	Return		: error code
	Argument	:
	Comments	: Return a error-code
	uart interrupt service routine
----------------------------------------------------------*/
void ISRUART(smtUint32 irq)
{
	UartStruct uartStatus;
	
	smtUartGetMode(gTestChannel,&uartStatus,GET_UARTSTATUS);
	
	// check UARTSTATUS
	// set flag of each state
	// - tx fifo interrupt
	// - rx fifo interrupt
	// - rx time out interrupt
	
	
	AckIRQ(irq);	// UART interrupt clear
}
