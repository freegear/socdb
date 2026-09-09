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

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include <stdarg.h>
#include <stdio.h>
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq.h"
#include "uart_pre_drv.h"
#include "uart_post_drv.h"
#include "uart.h"

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
#define UART_REGISTER_RW_TEST	0
#define UART_LOOPBACK_TEST		0
#define UART_INTERRUPT_TEST		0
#define UART_DMA_TEST			1

#define UART_TXFIFO_OFFSET 0x0C
#define UART_RXFIFO_OFFSET 0x10
#define DMA_UART0TX	7
#define DMA_UART0RX	8
#define DMA_UART1TX	9
#define DMA_UART1RX	10

#define UART_INT_TEST_MAX 	100
#define BUF_SZ 				32
/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
static smtUint32 UARTReadWriteTest(UartConfig *testParam);
static smtUint32 UARTLoopBackTest(void);
static smtUint32 UARTInterruptTest(void);
static smtUint32 UARTDMATest(void);
static smtUint32 UARTGetMaxFifoSz(smtUint8 uartCh, smtUint8 *uartFifoDepth);
smtUint32 UARTLoopbackTest(void);
void ISRUART(smtUint32 irq);
extern smtBoolean RegisterUART(void);

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/

static volatile smtBoolean gUartTxInt = SMT_TRUE;
static volatile smtBoolean gUartRxInt = SMT_TRUE;
static volatile smtBoolean gUartRxTimeout = SMT_TRUE;
static volatile smtUint8 gTestChannel;	
static volatile smtUint8 gTxWaterLev = 0, gRxWaterLev = 0;
volatile smtUint8 srcAddr[BUF_SZ] ={0,};
volatile smtUint8 srcAddr2[BUF_SZ] = {0,};
static EdmaChannel uartDmaRxCh;
static EdmaChannel uartDmaTxCh;
static volatile smtBoolean gDMARXEnd = 0;
static volatile smtBoolean gDMATXEnd = 0;
static smtUint8 IRQ_DMAX[]= 
{
	IRQ_DMA0,
	IRQ_DMA1,
	IRQ_DMA2,
	IRQ_DMA3,
	IRQ_DMA4,
	IRQ_DMA5,
	IRQ_DMA6,
	IRQ_DMA7
};
smtUint8 uartTestData[32] ={0,};
smtUint8 rxFifo[32] = {0,};

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

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
	//smtUint32 i;
	#if 0
	// TEST1 : Register R/W
	errCode = RegisterUART();
	if (errCode != SMT_SUCCESS)
		return SMT_ERROR;
	#endif
	// TEST2 : Loopback Test
	errCode = UARTLoopBackTest();
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

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: UARTLoopBackTest()
	Prototype		: static smtUint32 UARTLoopBackTest(void)

	Return		: error code
	Argument	:
	Comments	: Return a error-code
	uart read/write test
----------------------------------------------------------*/
static smtUint32 UARTLoopBackTest(void)
{
	smtUint32 errCode;
	UartConfig testParam;
	smtUint8 channel[] 	= {UART_CHANNEL0,UART_CHANNEL1,UART_CHANNEL2,UART_CHANNEL3};
	smtUint32 baudrate[]= {BAUD_9600,BAUD_14400,BAUD_19200,BUAD_31257,BAUD_38400,BAUD_115200};
	smtUint8 dataBit[] 	= {DATA_7BIT, DATA_8BIT};
	smtUint8 parity[] 	= {PARITY_DISABLE, PARITY_EVEN, PARITY_ODD};
	smtUint8 stopBit[]	= {ONE_STOP_BIT, TWO_STOP_BIT};
	smtUint8 channelIdx, baudrateIdx, dataBitIdx, parityIdx, stopBitIdx;

	for(channelIdx=0 ; channelIdx < MAX_UART_CHANNEL; channelIdx++)
	{
		for(baudrateIdx=0 ; baudrateIdx < 6; baudrateIdx++)
		{
			for(dataBitIdx=0 ; dataBitIdx < 2 ; dataBitIdx++)
			{
				for(parityIdx=0 ; parityIdx < 3 ; parityIdx++)
				{
					for(stopBitIdx = 0 ; stopBitIdx < 2 ; stopBitIdx++)
					{
						testParam.uartCh	= channel[channelIdx];
						testParam.baudrate	= baudrate[baudrateIdx];
						testParam.dataBit	= dataBit[dataBitIdx];
						testParam.parity	= parity[parityIdx];
						testParam.stopBit	= stopBit[stopBitIdx];
						errCode = UARTReadWriteTest(&testParam);
						if(errCode != SMT_SUCCESS)
						{
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
	Function name	: UARTReadWriteTest()
	Prototype		: static smtUint32 UARTReadWriteTest(UartConfig *testParam)
	Return		: error code
	Argument	:
	Comments	: Return a error-code
	uart loopback test
----------------------------------------------------------*/
static smtUint32 UARTReadWriteTest(UartConfig *testParam)
{
	UartConfig UartConfig;
	UartStatus uartSts;
	smtUint8 temp = 0, i =0, uartMaxFifoSz=0;

	// uart init
	UartConfig.baudrate		= testParam->baudrate;
	UartConfig.enInt			= 0x0;
	UartConfig.enRxTimeout	= 0x0;
	UartConfig.swReset		= 0x0;
	UartConfig.enDmaReq		= 0x0;
	UartConfig.parity			= testParam->parity;
	UartConfig.dataBit		= testParam->dataBit;
	UartConfig.stopBit		= testParam->stopBit;
	UartConfig.enLoopBack		= 0x1;
	UartConfig.txWaterLev		= 0x0;
	UartConfig.rxWaterLev		= 0x0;
	UartConfig.txIntEn		= 0x0;
	UartConfig.rxIntEn		= 0x0;

	UartConfig.uartCh			= testParam->uartCh;

	UARTGetMaxFifoSz(UartConfig.uartCh, &uartMaxFifoSz);
	smt2UARTInit(&UartConfig);
	// fill tx fifo
	for(i = 0; i < uartMaxFifoSz ;i++)
		smtUARTSetTxFifo(UartConfig.uartCh, (i+'0'));

	// check rx fifo count
	while(1)
	{
		smtUARTGetStatus(UartConfig.uartCh, &uartSts);
		if(uartSts.rxFifoCnt == uartMaxFifoSz)
			break;
	}

	// read rx fifo
	for(i = 0; i < uartMaxFifoSz ;i++)
	{
		smtUARTGetRxFifo(UartConfig.uartCh, &temp);
		if(temp != (i+'0'))
			return SMT_ERROR;
		
	}

	//deinit UART
	smt2UARTDeInit(UartConfig.uartCh);
		
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
static smtUint32 UARTInterruptTest(void)
{
	UartMaster uartCmd;
	UartStatus uartSts;
	UartConfig testParam;
	smtUint8 uartMaxFifoSize, uartIRQNum=0;
	smtUint8 channel,temp,i=0;
	smtUint32 timeoutCnt = 0;
	
	for(channel = 0 ; channel < 3; channel++)
	{
		gTestChannel = 0xFF;
		gTxWaterLev = gRxWaterLev = 0;
		gUartTxInt = gUartRxInt = gUartRxTimeout = SMT_TRUE;
		i = 0;
		testParam.baudrate	= BAUD_38400;
		testParam.enInt			= 0x1;
		testParam.enRxTimeout	= 0x0;
		testParam.swReset		= 0x0;
		testParam.enDmaReq		= 0x0;
		testParam.parity		= 0x00;
		testParam.dataBit		= 0x1;
		testParam.stopBit		= 0x0;
		testParam.enLoopBack	= 0x1;
		testParam.txWaterLev	= 0x8;
		testParam.rxWaterLev	= 0x1F;
		testParam.txIntEn	= 0x1;
		testParam.rxIntEn	= 0x1;
		testParam.uartCh = gTestChannel = channel;

		//get Max FIFO size for each uart channel
		UARTGetMaxFifoSz(testParam.uartCh, &uartMaxFifoSize);
		
		testParam.txWaterLev = gTxWaterLev = uartMaxFifoSize / 2;
		testParam.rxWaterLev = gRxWaterLev = uartMaxFifoSize / 2;
		
		// init uart 
		smt2UARTInit(&testParam);

		// Register UART ISR
		switch(testParam.uartCh)
		{
			case UART_CHANNEL0:
				uartIRQNum = IRQ_UART0;
				break;
			case UART_CHANNEL1:
				uartIRQNum = IRQ_UART1;
				break;
			case UART_CHANNEL2:
				uartIRQNum = IRQ_UART2;
				break;
			case UART_CHANNEL3:
				uartIRQNum = IRQ_UART3;
				break;
			default:
				return SMT_ERROR;
				break;
		}
		
		RequestIRQ(uartIRQNum, ISRUART);

		while(1)
		{
			if(!gUartTxInt)
			{
				for(timeoutCnt = 0 ; timeoutCnt < 4 ; timeoutCnt++)
				{
					if( timeoutCnt == 2)
					{
						smtUARTSetTxFifo(channel, '\n');
						smtUARTSetTxFifo(channel, '\r');
						break;
					}
					else
						smtUARTSetTxFifo(channel, '0'+timeoutCnt);						
				}

				if(i == UART_INT_TEST_MAX)
				{
					break;
				}
				else// tx interrupt enable
				{
					gUartTxInt = SMT_TRUE;
					smtUARTGetCmd(channel, &uartCmd);
					uartCmd.txIntEn	= 0x1;
					smtUARTSetCmd(channel, &uartCmd);
				}
				i++;
			}
			
			if(!gUartRxInt)
			{
				while(1)
				{
					smtUARTGetStatus(channel, &uartSts);
					if(uartSts.rxFifoCnt == 0)
						break;
					smtUARTGetRxFifo(channel, &temp);
				}
				gUartRxInt = SMT_TRUE;
				smtUARTGetCmd(channel, &uartCmd);
				uartCmd.rxIntEn	= 0x1;
				smtUARTSetCmd(channel, &uartCmd);
			}
		}
	
		// ReleaseIRQ for uart
		ReleaseIRQ(uartIRQNum);
		
		// DeInit uart
		smt2UARTDeInit(channel);
		i = 1;
	}
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: UARTRXDMAHandler()
	Prototype		: void UARTRXDMAHandler(smtUint32 irq)
	Return			: error code
	Argument		:
	Comments		: 
----------------------------------------------------------*/
void UARTRXDMAHandler(smtUint32 irq)
{
	SMT_WRITE(DMACSta(uartDmaRxCh), 0xf);
	gDMARXEnd = 1;
}

/*----------------------------------------------------------
	Function name	: UARTTXDMAHandler()
	Prototype		: void UARTTXDMAHandler(smtUint32 irq)
	Return			: error code
	Argument		:
	Comments		: 
----------------------------------------------------------*/
void UARTTXDMAHandler(smtUint32 irq)
{
	SMT_WRITE(DMACSta(uartDmaTxCh), 0xf);
	gDMATXEnd = 1;
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
	smtUint32 cnt,cnt1,i;
	UartConfig UartConfig;
	smtUint32 rxFifoAddr =0, txFifoAddr =0;
	EdmaStruct edma;
	smtUint16 rxDevId,txDevId;
	smtUint32 timeOut;
	extern void DCacheFlushing(void);

	//Memory write
	for(cnt=0;cnt<BUF_SZ;cnt++)
		srcAddr2[cnt] = cnt + '0';

	for(cnt = 0 ; cnt < 2 ; cnt++)
	{
		if(cnt == UART_CHANNEL0)
		{
			cnt1 = 0;
			txFifoAddr 	= UART0_BASEADDR + UART_TXFIFO_OFFSET;
			rxFifoAddr 	= UART0_BASEADDR + UART_RXFIFO_OFFSET;
			rxDevId 	= DMA_UART0RX;
			txDevId 	= DMA_UART0TX;
		}
		else
		{
			cnt1 		= 2;
			txFifoAddr	= UART1_BASEADDR + UART_TXFIFO_OFFSET;
			rxFifoAddr 	= UART1_BASEADDR + UART_RXFIFO_OFFSET;
			rxDevId 	= DMA_UART1RX;
			txDevId 	= DMA_UART1TX;
		}
		
		//uart init
		UartConfig.baudrate		= 38400;
		UartConfig.enInt			= 0x0;
		UartConfig.enRxTimeout	= 0x0;
		UartConfig.swReset		= 0x0;
		UartConfig.enDmaReq		= 0x1;
		UartConfig.parity			= 0x00;
		UartConfig.dataBit		= 0x1;
		UartConfig.stopBit		= 0x0;
		UartConfig.enLoopBack		= 0x1;
		UartConfig.txWaterLev		= 0x8;
		UartConfig.rxWaterLev		= 0x7;
		UartConfig.txIntEn		= 0x0;
		UartConfig.rxIntEn		= 0x0;
		UartConfig.uartCh			= cnt;	
		smt2UARTInit(&UartConfig);
		
		// set edma configuration
		edma.src			= (smtUint32)srcAddr2;
		edma.srcInc			= DMA_ADDR_INC;
		edma.srcWidth		= DMA_BUSWIDTH32;

		edma.dst			= txFifoAddr;
		edma.dstInc 		= DMA_ADDR_NOINC;
		edma.dstWidth		= DMA_BUSWIDTH8;

		edma.startIntEn		= 0x0;
		edma.endIntEn		= 0x1;
		edma.stopIntEn		= 0x0;	

		edma.totSize		= 32;
		edma.transSize		= DMA_TRANSSIZE16;

		edma.enM2M			= 0x0;
		edma.descListBase	= 0x0UL;

		//assign EDMA channel
		smt2EDMAChAsign(DMA_CHALLOC, txDevId, &uartDmaTxCh);

		//interrupt configuration
		Disable_IRQ();
		EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
		RequestIRQ(IRQ_DMAX[uartDmaTxCh], UARTTXDMAHandler);
		gDMATXEnd = 0;
		Enable_IRQ();

		//start EDMA
		smtEDMANoDescrp(uartDmaTxCh, &edma);

		//wait EDMA stop interrupt
		timeOut = 0;
		while(1)
		{
			if(gDMATXEnd == SMT_TRUE)
			{
				gDMATXEnd = SMT_FALSE;
				break;
			}
			
			if(timeOut++ == 0x7FFFF)
				break;
		}

		//free assigned EDMA channel
		smt2EDMAChAsign(DMA_CHDALLOC, txDevId, &uartDmaTxCh);

		//release irq
		ReleaseIRQ(IRQ_DMAX[uartDmaTxCh]);

		// set edma configuration
		edma.src			= (smtUint32)rxFifoAddr;
		edma.srcInc			= DMA_ADDR_NOINC;
		edma.srcWidth		= DMA_BUSWIDTH8;

		edma.dst			= (smtUint32)srcAddr;
		edma.dstInc 		= DMA_ADDR_INC;
		edma.dstWidth		= DMA_BUSWIDTH32;

		edma.startIntEn		= 0x0;
		edma.endIntEn		= 0x1;
		edma.stopIntEn		= 0x0;	

		edma.totSize		= 32;
		edma.transSize		= DMA_TRANSSIZE8;

		edma.enM2M			= 0x0;
		edma.descListBase	= 0x0UL;

		//assign EDMA channel
		smt2EDMAChAsign(DMA_CHALLOC, rxDevId, &uartDmaRxCh);
		
		//interrupt configuration
		Disable_IRQ();
		EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
		RequestIRQ(IRQ_DMAX[uartDmaRxCh], UARTRXDMAHandler);
		gDMARXEnd = 0;
		Enable_IRQ();

		//start EDMA
		smtEDMANoDescrp(uartDmaRxCh, &edma);

		//wait EDMA stop interrupt
		timeOut = 0;
		while(1)
		{
			if(gDMARXEnd == SMT_TRUE)
				break;
			
			if(timeOut++ == 0x7FFFF)
				break;
		}
		
		//free assigned EDMA channel
		smt2EDMAChAsign(DMA_CHDALLOC, rxDevId, &uartDmaRxCh);

		//release irq
		ReleaseIRQ(IRQ_DMAX[uartDmaRxCh]);

		
		DCacheFlushing();
		
		//check data
		for(i = 0 ; i < 32 ; i++)
		{
			if(srcAddr[i] != srcAddr2[i])
			{
				smt2UARTDeInit(UartConfig.uartCh);
				return SMT_ERROR;
			}
		}
		
		smt2UARTDeInit(UartConfig.uartCh);
	}

	return SMT_SUCCESS;	
}

/*----------------------------------------------------------
	Function name	: UARTGetMaxFifoSz()
	Prototype		: static smtUint32 UARTGetMaxFifoSz(smtUint8 uartCh, smtUint8 *uartFifoDepth)
	Return			: error code
	Argument		:
	Comments		: 
----------------------------------------------------------*/
static smtUint32 UARTGetMaxFifoSz(smtUint8 uartCh, smtUint8 *uartFifoDepth)
{
	UartStatus uartSts;
	smtUARTGetStatus(uartCh,&uartSts);
	*uartFifoDepth = uartSts.maxFifoDepth * 8;
		
	if(*uartFifoDepth > 16)
		*uartFifoDepth = 32;
	return SMT_SUCCESS;
}
/*----------------------------------------------------------
	Function name	: ISRUART()
	Prototype		: static void ISRUART(smtUint32 irq)
	Return			: error code
	Argument		:
	Comments		: 
----------------------------------------------------------*/
void ISRUART(smtUint32 irq)
{
	UartMaster uartCmd;
	UartStatus uartSts;
	
	DisableIRQ(irq);	// Disable UART interrupt
	
	smtUARTGetStatus(gTestChannel, &uartSts);
	
	if(uartSts.txFifoInt == 0x1)//tx fifo interrupt
	{
		smtUARTGetCmd(gTestChannel, &uartCmd);
		uartCmd.txIntEn	= 0x0;
		smtUARTSetCmd(gTestChannel, &uartCmd);
		gUartTxInt = SMT_FALSE;
	}

	if(uartSts.rxFifoInt == 0x1)//rx fifo interrupt
	{
		smtUARTGetCmd(gTestChannel, &uartCmd);
		uartCmd.rxIntEn = 0x0;
		smtUARTSetCmd(gTestChannel, &uartCmd);
		gUartRxInt	= SMT_FALSE;
	}
}

/*----------------------------------------------------------
	Function name	: UartMultiTest()
	Prototype		: smtUint32 UartMultiTest(void)
	Return			: uart rx fifo count
	Argument		: uart channel
	Comments		:
		
----------------------------------------------------------*/
smtUint32 UartMultiTest(void)
{
	UartConfig UartConfig;
	UartStatus uartSts;
	smtUint8 uartInput = 0x0;
	smtUint32 i=0;
	smtUint32 errCode;
	UartConfig.baudrate		= 38400;
	UartConfig.enInt			= 0x0;	// 0 : Enable int, 1 : Disable int
	UartConfig.enRxTimeout	= 0x0;
	UartConfig.swReset		= 0x0;
	UartConfig.enDmaReq		= 0x0;
	UartConfig.parity			= 0x0;
	UartConfig.dataBit		= 0x1;
	UartConfig.stopBit		= 0x0;
	UartConfig.enLoopBack		= 0x0;
	UartConfig.txWaterLev		= 0x8;
	UartConfig.rxWaterLev		= 0x8;
	UartConfig.uartCh			= UART_CHANNEL0;

	//fill uart test data 
	for(i = 0 ; i < 32 ; i++)
	{
		uartTestData[i] = '0' + i;
	}
	
	while(1)
	{
		UartConfig.enLoopBack		= 0x0;
		UartConfig.uartCh			= UART_CHANNEL0;
		smt2UARTInit(&UartConfig);// init uart channel0
		
		UartConfig.enLoopBack		= 0x1;
		UartConfig.uartCh 		= UART_CHANNEL1;
		smt2UARTInit(&UartConfig);// init uart channel1

		// fill uart channel1 rx fifo through loopback
		for(i = 0 ; i < 32 ; i++)
		{
			smt2UARTPutCh(UART_CHANNEL1, uartTestData[i]);
		}
		
		//wait for uart channel1 receiving data
		while(1)
		{
			smtUARTGetStatus(UART_CHANNEL1, &uartSts);
			if(uartSts.rxFifoCnt == 32)// uart channel 1 receive 32 byte data
				break;
		}
		
		// read rx fifo of uart channel 1 , then send it to uart channel0
		while(1)
		{
			smtUARTGetStatus(UART_CHANNEL1, &uartSts);
			if(uartSts.rxFifoCnt == 0)
				break;
			smt2UARTGetCh(UART_CHANNEL1, &uartInput,0);
			smt2UARTPutCh(UART_CHANNEL0, uartInput);
		}

		smt2UARTPrint(UART_CHANNEL0, "\n");

		errCode = smt2UARTDataValid(UART_CHANNEL0, &uartInput);
		
		// exit multi test routine
		if(uartInput)
		{
			smt2UARTGetCh(UART_CHANNEL0,&uartInput, 0);
			if(uartInput == '0')
			{
				smt2UARTPrint(UART_CHANNEL0, "exit uart multi channel test!!\n");
				smt2UARTDeInit(UART_CHANNEL0);// deinit uart channel0
				smt2UARTDeInit(UART_CHANNEL1);// deinit uart channel1
				break;
			}
		}
		smt2UARTDeInit(UART_CHANNEL0);// deinit uart channel0
		smt2UARTDeInit(UART_CHANNEL1);// deinit uart channel1
	}

	return SMT_SUCCESS;
}

