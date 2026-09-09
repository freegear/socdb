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

#define UART_IRQ_OFFSET_CHANNEL 8
#define APB1_CLK		(25*1000*1000) // 25 MHz
#define UART_PRINTF_MAX_STRING 128

#define BUF_SZ 32

#define UART_PARITY_ERROR	( 0x1 << 25)
#define UART_FRAME_ERROR	( 0x1 << 24)
#define UART_OVERRUN_ERROR	( 0x1 << 23)
#define UART_RX_TIMEOUT		( 0x1 << 22)
#define UART_TX_FIFO_CNT	( 0x3F<< 8)
#define UART_RX_FIFO_CNT	( 0x3F<< 0)
/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
void UARTInit(UartBasicCfg uartInitData);
void UARTDeinit(smtUint8 uartCh);
static smtUint32 UARTReadWriteTest(UartBasicCfg *testParam);
static smtUint32 UARTLoopBackTest(void);
static smtUint32 UARTInterruptTest(void);
static smtUint32 UARTDMATest(void);
static smtUint32 UARTGetBaudrate(smtUint32 baudrate);
smtUint32 UARTLoopbackTest(void);
void ISRUART(smtUint32 irq);
void UARTPrintf(const char * format, ...);
smtUint8 UARTGetch(void);
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
static smtUint8 srcAddr3[BUF_SZ] ={0,};
//static smtUint8 srcAddr2[BUF_SZ] = {0,};
volatile smtUint8 srcAddr[BUF_SZ] ={0,};
volatile smtUint8 srcAddr2[BUF_SZ] = {0,};

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
	UartBasicCfg testParam;
	smtUint8 channel[] 	= {UART_CHANNEL0}; //,UART_CHANNEL1};
	smtUint32 baudrate[]= {BAUD_9600,BAUD_14400,BAUD_19200,BAUD_38400,BAUD_115200};
	smtUint8 dataBit[] 	= {DATA_7BIT, DATA_8BIT};
	smtUint8 parity[] 	= {PARITY_DISABLE, PARITY_EVEN, PARITY_ODD};
	smtUint8 stopBit[]	= {ONE_STOP_BIT, TWO_STOP_BIT};
	smtUint8 channelIdx, baudrateIdx, dataBitIdx, parityIdx, stopBitIdx;

	for(channelIdx=0 ; channelIdx < MAX_UART_CHANNEL; channelIdx++)
	{
		for(baudrateIdx=0 ; baudrateIdx < 5; baudrateIdx++)
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
	Prototype		: static smtUint32 UARTReadWriteTest(UartBasicCfg *testParam)
	Return		: error code
	Argument	:
	Comments	: Return a error-code
	uart loopback test
----------------------------------------------------------*/
static smtUint32 UARTReadWriteTest(UartBasicCfg *testParam)
{
	UartConfig uartBasicCfg;
	UartStruct uartConfig;
	smtUint8 temp = 0, i =0, uartMaxFifoSz=0;


	// uart init
	uartBasicCfg.baudrate		= testParam->baudrate;
	uartBasicCfg.enInt			= 0x0;
	uartBasicCfg.enRxTimeout	= 0x0;
	uartBasicCfg.swReset		= 0x0;
	uartBasicCfg.enDmaReq		= 0x0;
	uartBasicCfg.parity			= testParam->parity;
	uartBasicCfg.dataBit		= testParam->dataBit;
	uartBasicCfg.stopBit		= testParam->stopBit;
	uartBasicCfg.enLoopBack		= 0x1;
	uartBasicCfg.txWaterLev		= 0x0;
	uartBasicCfg.rxWaterLev		= 0x0;
	uartBasicCfg.txIntEn		= 0x0;
	uartBasicCfg.rxIntEn		= 0x0;

	uartBasicCfg.uartCh			= testParam->uartCh;

	UARTGetMaxFifoSz(uartBasicCfg.uartCh, &uartMaxFifoSz);
	//UARTInit(uartBasicCfg);
	smt2UartInit(uartBasicCfg);
	// fill tx fifo
	for(i = 0; i < uartMaxFifoSz ;i++)
		smtUartWriteTxFifo(uartBasicCfg.uartCh, (i+'0'));

	// check rx fifo count
	while(1)
	{
		smtUartGetMode(uartBasicCfg.uartCh, &uartConfig, GET_UARTSTATUS);
		if(uartConfig.uartStatus.rxFifoCnt == uartMaxFifoSz)
			break;
	}

	// read rx fifo
	for(i = 0; i < uartMaxFifoSz ;i++)
	{
		temp = smtUartReadRxFifo(uartBasicCfg.uartCh);
		if(temp != (i+'0'))
			return SMT_ERROR;
	}

	//deinit UART
	//UARTDeinit(uartBasicCfg.uartCh);
	smt2UartDeInit();
		
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
#define UART_INT_TEST_MAX 100
smtUint8 rxFifo[32] = {0,};
static smtUint32 UARTInterruptTest(void)
{
	UartStruct uartCfg;
	UartConfig testParam;
	smtUint8 uartMaxFifoSize;
	smtUint8 channel,temp,i=0;
	smtUint32 timeoutCnt = 0;
	//for(channel = 0 ; channel < 2; channel++)
	for(channel = 0 ; channel < 1; channel++)
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
		//UARTInit(testParam);
		smt2UartInit(testParam);

		// Register UART ISR
		//RequestIRQ(testParam.uartCh*2 + UART_IRQ_OFFSET_CHANNEL, ISRUART);
		RequestIRQ(IRQ_UART0, ISRUART);

		while(1)
		{
			if(!gUartTxInt)
			{
				for(timeoutCnt = 0 ; timeoutCnt < 4 ; timeoutCnt++)
				{
					if( timeoutCnt == 2)
					{
						smtUartWriteTxFifo(channel, '\n');
						smtUartWriteTxFifo(channel, '\r');
						break;
					}
					else
						smtUartWriteTxFifo(channel, '0'+timeoutCnt);
				}
				if(i == UART_INT_TEST_MAX)
				{
					break;
				}
				else// tx interrupt enable
				{
					gUartTxInt = SMT_TRUE;
					smtUartGetMode(channel, &uartCfg,GET_UARTMASTER);
					uartCfg.uartMaster.txIntEn = 0x1;
					smtUartSetMode(channel, &uartCfg,SET_UARTMASTER);
				}
				i++;
			}

			if(!gUartRxInt)
			{
				while(1)
				{
					smtUartGetMode(channel,&uartCfg, GET_UARTSTATUS);
					if(uartCfg.uartStatus.rxFifoCnt == 0)
						break;
					temp = smtUartReadRxFifo(channel);
				}
				gUartRxInt = SMT_TRUE;
				smtUartGetMode(channel, &uartCfg,GET_UARTMASTER);
				uartCfg.uartMaster.rxIntEn = 0x1;
				smtUartSetMode(channel, &uartCfg,SET_UARTMASTER);
			}
		}
	
		// ReleaseIRQ for uart
		//ReleaseIRQ(testParam.uartCh*2+UART_IRQ_OFFSET_CHANNEL);
		ReleaseIRQ(IRQ_UART0);
		
		// DeInit uart
		//UARTDeinit(testParam.uartCh);
		smt2UartDeInit();
		i = 1;

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
	smtUint32 cnt,cnt1,i;
	//UartBasicCfg uartBasicCfg;
	UartConfig uartBasicCfg;
	smtUint32 dmaChSelector =0, rxFifoAddr =0, txFifoAddr =0;
	EDMA_STRUCT edma;
	
	//Memory write
	for(cnt=0;cnt<BUF_SZ;cnt++)
		srcAddr2[cnt] = cnt + '0';

	DMA2Init(SMT_TRUE);

	
	for(cnt = 0 ; cnt < 1 ; cnt++)
	{
		if(cnt == UART_CHANNEL0)
		{
			cnt1 = 0;
			txFifoAddr = UART0_BASEADDR + UART_TXFIFO_OFFSET;
			rxFifoAddr = UART0_BASEADDR + UART_RXFIFO_OFFSET;
			
		}
		else
		{
			cnt1 = 4;
			txFifoAddr = UART1_BASEADDR + UART_TXFIFO_OFFSET;
			rxFifoAddr = UART1_BASEADDR + UART_RXFIFO_OFFSET;
		}
		
		//uart init
		uartBasicCfg.baudrate		= 38400;
		uartBasicCfg.enInt			= 0x0;
		uartBasicCfg.enRxTimeout	= 0x0;
		uartBasicCfg.swReset		= 0x0;
		uartBasicCfg.enDmaReq		= 0x1;
		uartBasicCfg.parity			= 0x00;
		uartBasicCfg.dataBit		= 0x1;
		uartBasicCfg.stopBit		= 0x0;
		uartBasicCfg.enLoopBack		= 0x1;
		uartBasicCfg.txWaterLev		= 0x8;
		uartBasicCfg.rxWaterLev		= 0x7;
		uartBasicCfg.txIntEn		= 0x0;
		uartBasicCfg.rxIntEn		= 0x0;
		uartBasicCfg.uartCh			= cnt;	
		//UARTInit(uartBasicCfg);
		smt2UartInit(uartBasicCfg);

		edma.src = (smtUint32)srcAddr2;
		edma.dst = txFifoAddr;
		edma.nBytes = 32;
		edma.m2m = SMT_FALSE;
		edma.srcWidth = DMA_BUSWIDTH32;
		edma.dstWidth = DMA_BUSWIDTH8;
		edma.tSize = DMA_TRANSSIZE1;
		edma.srcInc = DMA_ADDR_INC;
		edma.dstInc = DMA_ADDR_NOINC;

		edma.startIntEn = SMT_FALSE;
		edma.EndIntEn = SMT_FALSE;

		edma.intFunction = 0;
		smt2EDMACopy(DMADEV_UART0TX+cnt1, &edma, 1);

		// D-Cache flushing
		{
			smtUint32 i,j;
		    for(i=0;i<4;i++)
		    	for(j=0;j<128;j++)
    			    MMU_CleanInvalidateDCacheSET((i<<30)|(j<<5));
		}

		edma.src = rxFifoAddr;
		edma.dst = (smtUint32)srcAddr;
		edma.nBytes = 32;
		edma.m2m = SMT_FALSE;
		edma.srcWidth = DMA_BUSWIDTH8;
		edma.dstWidth = DMA_BUSWIDTH32;
		edma.tSize = DMA_TRANSSIZE8;
		edma.srcInc = DMA_ADDR_NOINC;
		edma.dstInc = DMA_ADDR_INC;

		edma.startIntEn = SMT_FALSE;
		edma.EndIntEn = SMT_FALSE;

		edma.intFunction = 0;		
		smt2EDMACopy(DMADEV_UART0RX+cnt1, &edma, 1);

		// D-Cache flushing
		{
			smtUint32 i,j;
		    for(i=0;i<4;i++)
		    	for(j=0;j<128;j++)
    			    MMU_CleanInvalidateDCacheSET((i<<30)|(j<<5));
		}

		for(i = 0 ; i < 32 ; i++)
		{
			if(srcAddr[i] != srcAddr2[i])
			{
				smt2UartDeInit();
				return SMT_ERROR;
			}
		}
		
		//UARTDeinit(uartBasicCfg.uartCh);				
		smt2UartDeInit();
	}

	return SMT_SUCCESS;	
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

static smtUint32 UARTGetMaxFifoSz(smtUint8 uartCh, smtUint8 *uartFifoDepth)
{
	UartStruct uartCfg;
	smtUartGetMode(uartCh, &uartCfg, GET_UARTSTATUS);
	*uartFifoDepth = uartCfg.uartStatus.maxFifoDepth * 8;
	if(*uartFifoDepth > 16)
		*uartFifoDepth = 32;
	return SMT_SUCCESS;
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
	UartStruct uartCfg;
	DisableIRQ(irq);	// Disable UART interrupt
	
	smtUartGetMode(gTestChannel, &uartCfg, GET_UARTSTATUS);
	
	if(uartCfg.uartStatus.txFifoInt == 0x1)//tx fifo interrupt
	{
		smtUartGetMode(gTestChannel, &uartCfg, GET_UARTMASTER);
		uartCfg.uartMaster.txIntEn = 0x0;
		smtUartSetMode(gTestChannel, &uartCfg, SET_UARTMASTER);
		gUartTxInt = SMT_FALSE;
	}

	if(uartCfg.uartStatus.rxFifoInt == 0x1)//rx fifo interrupt
	{
		smtUartGetMode(gTestChannel, &uartCfg, GET_UARTMASTER);
		uartCfg.uartMaster.rxIntEn = 0x0;
		smtUartSetMode(gTestChannel, &uartCfg, SET_UARTMASTER);
		gUartRxInt	= SMT_FALSE;
	}
}
/*-----------------------------------------------------------------------
    Function name   : UartInit(void)
    Prototype       : void UartInit(void)
    Return          :
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void UARTInit(UartBasicCfg uartInitData)
{
	UartStruct uartConfig;
	// uart s/w reset
	uartConfig.uartMaster.swReset		= 1;
	smtUartSetMode(uartInitData.uartCh, &uartConfig,SET_UARTMASTER);
	// rx fifo flush
	while(1)
	{
		smtUartGetMode(uartInitData.uartCh, &uartConfig, GET_UARTSTATUS);
		if(uartConfig.uartStatus.rxFifoCnt == 0)
			break;
		smtUartReadRxFifo(uartInitData.uartCh);
	}
	
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
	uartConfig.uartMaster.txWaterLev	= uartInitData.txWaterLev;
	uartConfig.uartMaster.rxWaterLev	= uartInitData.rxWaterLev;
	uartConfig.uartMaster.txIntEn		= uartInitData.txIntEn;
	uartConfig.uartMaster.rxIntEn		= uartInitData.rxIntEn;
	smtUartSetMode(uartInitData.uartCh, &uartConfig,SET_UARTMASTER);
}
void UARTDeinit(smtUint8 uartCh)
{
	UartStruct uartConfig;

	//wait for finishing tx
	while(1)
	{
		smtUartGetMode(uartCh, &uartConfig, GET_UARTSTATUS);
		if(uartConfig.uartStatus.txBusy != SMT_TRUE)
			break;
	}
	
	smtUartGetMode(uartCh, &uartConfig, GET_UARTMASTER);
	uartConfig.uartMaster.uartEn	= 0x0;
	uartConfig.uartMaster.intEn		= 0x0;
	smtUartSetMode(uartCh, &uartConfig, SET_UARTMASTER);
}
/*-----------------------------------------------------------------------
    Function name   : UARTPutch(char ch)
    Prototype       : void UARTPutch(char ch)
    Return          :
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void UARTPutch(char ch)
{
  	UartStruct uartConfig;
	while(1)
	{
		smtUartGetMode(UART_CHANNEL0, &uartConfig, GET_UARTSTATUS);
		if(uartConfig.uartStatus.txFifoCnt	!= 0x1e)
		{
			smtUartWriteTxFifo(UART_CHANNEL0, ch);
			return;
		}
	}
}

/*-----------------------------------------------------------------------
    Function name   : UARTPuts(char *)
    Prototype       : void UARTPuts(char *)
    Return          : 
    Argument        : char *
    Comments        : Tranmit String
-----------------------------------------------------------------------*/
void UARTPuts(char * str)
{
	
	int index = 0 ;
	while( str[index] != '\000')  
	{      	
		UARTPutch( (char) str[index] ) ;      
		if(str[index] == '\n')
			UARTPutch('\r');
		index++;            
	} 
}

/*-----------------------------------------------------------------------
    Function name   : UARTPrintf(const char *format, ...)
    Prototype       : void UARTPrintf(const char *format, ...)
    Return          : 
    Argument        : const char *,...
    Comments        : Tranmit Formmatted String
-----------------------------------------------------------------------*/
void UARTPrintf(const char * format, ...)
{
	char str[UART_PRINTF_MAX_STRING];
	va_list ap;
	va_start(ap, format);
	vsnprintf(str, UART_PRINTF_MAX_STRING, format, ap);
	va_end(ap);

	UARTPuts(str);
}

/*-----------------------------------------------------------------------
    Function name   : UARTGetch()
    Prototype       : smtUint8 UARTGetch()
    Return          : 
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
smtUint8 UARTGetch()
{
	UartStruct uartConfig;
	while(1)
	{
		smtUartGetMode(UART_CHANNEL0, &uartConfig, GET_UARTSTATUS);
		if(uartConfig.uartStatus.rxFifoCnt != 0x00)
		{
			return smtUartReadRxFifo(UART_CHANNEL0);
		}
	}
}

/*-----------------------------------------------------------------------
    Function name   : UARTDataAvailable()
    Prototype       : int UARTDataAvailable()
    Return          : 
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
int UARTDataAvailable()
{
	return ((SMT_READ(UART0STATUS) & 0x0000003f) != 0x00000000);
}

