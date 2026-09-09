/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: i2s.c 
	Description	: I2S test code
	Created by	: SHMT SW Team
-----------------------------------------------------------*/
//-----------------------------------------------------------
//	I2S test sequence
//-----------------------------------------------------------	
//	1. TX/RX transmit	
//	2. TX/RX bitwidth
//	3. TX/RX samplerate
//	4. TX/RX event 
//-----------------------------------------------------------
/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/
#include <string.h>
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq.h"
#include "i2s.h"
#include "global.h"
#include "i2s_pre_drv.h"
#include "l3inf.h"

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
extern 	smtUint32 	smt2UARTPrint(smtUint8 uartCh, smtInt8 *format, ...);
extern	void 		Enable_IRQ(void);
extern	void 		Disable_IRQ(void);
extern 	void 		DCacheFlushing(void);
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

//-----------------------------------------------------------
// I2S interface configuration definition
//-----------------------------------------------------------
#define I2S_DTO_RATIO(b, s)														\
	((unsigned)(((float)(b)*256)*((float)(0x00040000))/((float)(s))))

// I2S clock
#define I2S_SYS_CLK					(100*1000*1000)						// 100MHz system clock for I2S 
#define	I2ST_DTO_11025				I2S_DTO_RATIO(11025, I2S_SYS_CLK)	// DTO ratio for 11025Hz 
#define	I2ST_DTO_22050				I2S_DTO_RATIO(22050, I2S_SYS_CLK)	// DTO ratio for 22050Hz 
#define	I2ST_DTO_44100				I2S_DTO_RATIO(44100, I2S_SYS_CLK)	// DTO ratio for 44100Hz 
#define	I2ST_DTO_48000				I2S_DTO_RATIO(48000, I2S_SYS_CLK)	// DTO ratio for 48000Hz 

// I2S bitwidth
#define	I2ST_BW_08BIT				(0x0)								
#define	I2ST_BW_16BIT				(0x1)
#define	I2ST_BW_24BIT				(0x2)
#define	I2ST_BW_32BIT				(0x3)

// I2S etc
#define	I2ST_FIFO_TH				(0x8)
#define	I2ST_SAMPLE_LEN				(0x1000)
#define	I2ST_TX_PERI_IDX			(0x3)
#define	I2ST_RX_PERI_IDX			(0x4)
#define	I2ST_TX_DMC_CH				(0x3)
#define	I2ST_RX_DMC_CH				(0x4)

// I2S & DMA interrupt
#define	I2ST_INT_NUM				(IRQ_I2S)
#define	I2ST_TX_DMC_INT_NUM			(IRQ_DMA3)
#define	I2ST_RX_DMC_INT_NUM			(IRQ_DMA4)

// I2S time out value
#define	I2S_TO_RDREADY				(0x7FFFFFF)
#define	I2S_TO_WRREADY				(0x7FFFFFF)
#define	I2S_TO_DMA					(0x7FFFFFF)
#define	I2S_TO_UNDERRUNEVENT		(0x7FFFFFF)
#define	I2S_TO_OVERRUNEVENT			(0x7FFFFFF)

// I2S error code
#define	I2S_EC_NONE					(1<<0)
#define	I2S_EC_RDREADY				(1<<1)
#define	I2S_EC_WRREADY				(1<<2)
#define	I2S_EC_DMA					(1<<3)
#define	I2S_EC_PUNDERRUNEVENT		(1<<4)
#define	I2S_EC_IUNDERRUNEVENT		(1<<5)
#define	I2S_EC_POVERRUNEVENT		(1<<6)
#define	I2S_EC_IOVERRUNEVENT		(1<<7)

// I2S test code debug printf
#define I2SDPRINTF					smt2UARTPrint

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/

// I2S TX event flag
static volatile smtBoolean	underRunFlag 	= 0;
static volatile int 		gTXDMAEnd 		= 0;

// I2S RX event flag
static volatile smtBoolean	overRunFlag 	= 0;
static volatile int		 	gRXDMAEnd 		= 0;

// I2S TX test raw wave
extern const unsigned int 	sounddata[];

// I2S RX DMA test temporal buffer
static smtUint32 			dmaBuffer[(32*1024)/4];
/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: I2SOverRunHandler
	Prototype		: static void I2SOverRunHandler(smtUint32 irq);
	Return			: none
	Argument		: requested system interrupt number
	Comments		: I2S FIFO overrun interrupt handler
-----------------------------------------------------------*/
static void I2SOverRunHandler(smtUint32 irq)
{
	smtI2SClearFIFO(I2S_DIR_RX);
	overRunFlag = 1;
}
/*----------------------------------------------------------
	Function name	: I2SUnderRunHandler
	Prototype		: static void I2SUnderRunHandler(smtUint32 irq)
	Return			: none
	Argument		: requested system interrupt number
	Comments		: I2S FIFO underrun interrupt handler
-----------------------------------------------------------*/
static void I2SUnderRunHandler(smtUint32 irq)
{
	smtI2SClearFIFO(I2S_DIR_TX);
	underRunFlag = 1;
}
/*----------------------------------------------------------
	Function name	: I2STXDMAHandler
	Prototype		: static void I2STXDMAHandler(smtUint32 irq)
	Return			: none
	Argument		: requested system interrupt number
	Comments		: I2S TX DMA end interrupt handler
-----------------------------------------------------------*/
static void I2STXDMAHandler(smtUint32 irq)
{
	SMT_WRITE(DMACSta(I2ST_TX_DMC_CH), 0xf);
	gTXDMAEnd = 1;
}
/*----------------------------------------------------------
	Function name	: I2SRXDMAHandler
	Prototype		: static void I2SRXDMAHandler(smtUint32 irq)
	Return			: none
	Argument		: requested system interrupt number
	Comments		: I2S RX DMA end interrupt handler
-----------------------------------------------------------*/
static void I2SRXDMAHandler(smtUint32 irq)
{
	SMT_WRITE(DMACSta(I2ST_RX_DMC_CH), 0xf);
	gRXDMAEnd = 1;
}
/*----------------------------------------------------------
	Function name	: I2SDefaultSettingTX
	Prototype		: static void I2SDefaultSettingTX(void)
	Return			: none
	Argument		: none
	Comments		: defult TX I2S clock and configure
-----------------------------------------------------------*/
static void I2SDefaultSettingTX(void)
{
	I2sClkMode	I2SClkMode;
	I2sCtrl		I2SCtrl;

	// I2S TX clock configure
	I2SClkMode.ClkMaster	= 0x1;					// master mode
	I2SClkMode.LRClkInv		= 0x0;					// L/R clock no inversion
	I2SClkMode.MClkOn		= 0x1;					// Mclk on
	I2SClkMode.MClkOE		= 0x1;					// Mclk enable
	I2SClkMode.DTORatio		= I2ST_DTO_44100;		// 44100 sample rate
	smtI2SSetClockMode(&I2SClkMode);
	
	// I2S TX configure
	I2SCtrl.DMAIntEn		= 0x0;					// DMA disable
	I2SCtrl.FifoOURIntEn	= 0x0;					// underrun disable
	I2SCtrl.WLen			= I2ST_BW_16BIT;		// 16bits sample width 
	I2SCtrl.Ljust			= 0x0;					// I2S mode
	I2SCtrl.FifoTH			= I2ST_FIFO_TH;			// DMA burst length
	smtI2SSetMode(I2S_DIR_TX, &I2SCtrl);		
	smtI2SEnable(I2S_DIR_TX, 0);			
}
/*----------------------------------------------------------
	Function name	: I2SDefaultSettingRX
	Prototype		: static void I2SDefaultSettingRX(void)
	Return			: none
	Argument		: none
	Comments		: defult RX I2S clock and configure
-----------------------------------------------------------*/
static void I2SDefaultSettingRX(void)
{
	I2sClkMode	I2SClkMode;
	I2sCtrl		I2SCtrl;

	// I2S RX clock configure
	I2SClkMode.ClkMaster	= 0x1;					// master mode
	I2SClkMode.LRClkInv		= 0x0;					// L/R clock no inversion
	I2SClkMode.MClkOn		= 0x1;					// Mclk on
	I2SClkMode.MClkOE		= 0x1;					// Mclk enable
	I2SClkMode.DTORatio		= I2ST_DTO_44100;		// 44100 sample rate
	smtI2SSetClockMode(&I2SClkMode);
	
	// I2S RX configure
	I2SCtrl.DMAIntEn		= 0x0;					// DMA disable
	I2SCtrl.FifoOURIntEn	= 0x0;					// overrun disable
	I2SCtrl.WLen			= I2ST_BW_16BIT;		// 16bits sample width 
	I2SCtrl.Ljust			= 0x0;					// I2S mode
	I2SCtrl.FifoTH			= I2ST_FIFO_TH;			// DMA burst length
	smtI2SSetMode(I2S_DIR_RX, &I2SCtrl);		
	smtI2SEnable(I2S_DIR_RX, 0);			
}
/*----------------------------------------------------------
	Function name	: I2STestTXTransmit
	Prototype		: smtUint32 I2STestTXTransmit(void)
	Return			: test success/fail(0, 1-2)
	Argument		: none
	Comments		: I2S TX transmit test
-----------------------------------------------------------*/
smtUint32 I2STestTXTransmit(void)
{
	I2sStatusDat	I2SStatus;
	smtUint32		tIdx;	
	smtUint32		offset;
	smtUint32		regValue;
	smtUint32		timeOut;	
	smtUint32		errorCode;
	smtUint32		tmp;
	
	// set I2S TX default setting
	I2SDefaultSettingTX();		
	errorCode = I2S_EC_NONE;
	
	//-------------------------------------------------------
	// 1, polling
	//-------------------------------------------------------
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-TRANSMIT polling test!!!\n");
	
	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);		

	// I2S run
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);	
	
	for(tIdx = 0; tIdx <  128*1024/2; tIdx++) 
	{
		// check fifo wait FIFO is not full
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);	
			if(I2SStatus.FIFOL != 32) 
			{
				break;
			}
			
			if(timeOut++ == I2S_TO_WRREADY)
			{
				errorCode = I2S_EC_WRREADY;
				goto Error;
			}
		}
		
		tmp = sounddata[tIdx];
		smtI2SSetData(&tmp);	
	}

	// I2S stop
	smtI2SEnable(I2S_DIR_TX, 0);
	
	//-------------------------------------------------------
	// 2. DMA
	//-------------------------------------------------------
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-TRANSMIT DMA test!!!\n");

	// set TX DMA MUX
	regValue 	= SMT_READ(RS_DMAMUX);
	regValue	&= ~(0xF			 <<(I2ST_TX_DMC_CH*4));
	regValue	|= (I2ST_TX_PERI_IDX <<(I2ST_TX_DMC_CH*4));	
	SMT_WRITE(RS_DMAMUX, regValue);	
	
	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);			

	// configure interrupt for I2S
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(I2ST_TX_DMC_INT_NUM, I2STXDMAHandler);
	Enable_IRQ();
	
	// I2S run
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);			
		
	offset = 0;
	for(tIdx = 0; tIdx < 8*2*2/2; tIdx++) {
		
		// cache flushing
		DCacheFlushing();
		
		// I2S TX DMA init
		SMT_WRITE(DMACSta(I2ST_TX_DMC_CH), 0xf);
		gTXDMAEnd = 0;
		
		// I2S TX DMA set source address
		SMT_WRITE (DMACSAdr(I2ST_TX_DMC_CH), 
			(smtUint32)((smtUint32)sounddata + (smtUint32)offset)
		);
		
		// I2S TX DMA set destination address
		SMT_WRITE (DMACDAdr(I2ST_TX_DMC_CH), (smtUint32)&I2S_DATA);	
					
		// I2S TX DMA set configuration, for new version
		regValue = 
		 	((0x0 << 31)				// disable start interrupt
			|(0x1 << 30)				// enable end interrupt
			|(0x0 << 29)				// using flow control(hand shaking)
			|(0x1 << 28)				// source increasement
			|(0x2 << 26)				// source WORD width
			|(0x0 << 25)				// destination increasement
			|(0x2 << 23)				// target WORD width
			|(0x5 << 20)				// burst size 32 byte
			|(64*1024-1));				// total transfer size
			
		SMT_WRITE (DMACCon(I2ST_TX_DMC_CH), regValue);
		
		// I2S TX DMA set no use descriptor
		SMT_WRITE (DMACDescrp(I2ST_TX_DMC_CH), 0x1);
		
		// I2S TX DMA Run 
		regValue = (DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK);
		SMT_WRITE(DMACSta(I2ST_TX_DMC_CH), regValue);	
			
		timeOut = 0;
		while(true)
		{
			if(gTXDMAEnd) 
			{
				break;
			}
			
			if(timeOut++ ==  I2S_TO_DMA)
			{
				errorCode = I2S_EC_DMA;
				goto Error;
			}
		}
		offset += 64*1024;
	}
	
	// I2S interrupt disable
	ReleaseIRQ(I2ST_TX_DMC_CH);	
	
	// I2S stop
	smtI2SEnable(I2S_DIR_TX, 0);	
	
	
Error:
	switch(errorCode)
	{
	case I2S_EC_WRREADY	: return 1;
	case I2S_EC_DMA		: return 2;
	}
	
	return 0;
}
/*----------------------------------------------------------
	Function name	: I2STestTXBitWidth
	Prototype		: smtUint32 I2STestTXBitWidth(void)
	Return			: test success/fail(0, 1-2)
	Argument		: none
	Comments		: I2S TX bitwidth (8/16/24/32) bits test
-----------------------------------------------------------*/
smtUint32 I2STestTXBitWidth(void)
{
	I2sCtrl		I2SCtrl;
	I2sStatusDat	I2SStatus;
	smtInt8			ByteSampleL, ByteSampleR;
	smtUint32		Sample;	
	smtUint32		tIdx;
	smtUint32		timeOut;
	smtUint32		errorCode;
	smtUint32 		tmp;
	
	I2SDefaultSettingTX();
	errorCode = I2S_EC_NONE;
	
	//-------------------------------------------------------
	//	I2S TX 44100Hz, 8bits
	//-------------------------------------------------------
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-BITWIDTH I2S 8bits test!!!\n");

	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);		

	// I2S configure
	smtI2SGetMode(I2S_DIR_TX, &I2SCtrl);		
	I2SCtrl.WLen = I2ST_BW_08BIT;			
	smtI2SSetMode(I2S_DIR_TX, &I2SCtrl);		
	
	// I2S run
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);	
		
		
	// make and write sample
	for(tIdx = 0; tIdx <  128*1024/2; tIdx++) 
	{
		// check fifo wait FIFO is not full		
		ByteSampleL = ((sounddata[tIdx]&0xFFFF)>>8);
		ByteSampleR = (((sounddata[tIdx]>>16)&0xFFFF)>>8);
		Sample |= (((ByteSampleR<<8)|ByteSampleL) << (16*(tIdx%2)));
		if(!(tIdx%2) && tIdx) 
		{
			timeOut = 0;
			while(true) 
			{
				smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);	
				if(I2SStatus.FIFOL != 32) 
				{	
					break;
				}
				
				if(timeOut++ == I2S_TO_WRREADY)
				{
					errorCode = I2S_EC_WRREADY;
					goto Error;
				}
			}
		
			smtI2SSetData(&Sample);
			Sample = 0;
		}
		
	}	
	
	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);	

	//-------------------------------------------------------
	//	I2S TX 44100Hz, 16bits
	//-------------------------------------------------------

	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-BITWIDTH I2S 16bits test!!!\n");

	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);		

	// I2S configure
	smtI2SGetMode(I2S_DIR_TX, &I2SCtrl);		
	I2SCtrl.WLen = I2ST_BW_16BIT;			
	smtI2SSetMode(I2S_DIR_TX, &I2SCtrl);		
	
	// I2S run
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
		
	// make and write sample
	for(tIdx = 0; tIdx <  128*1024/2; tIdx++) 
	{
		// check fifo wait FIFO is not full
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);	
			if(I2SStatus.FIFOL != 32) 
			{
				break;
			}
			
			if(timeOut++ == I2S_TO_WRREADY)
			{
				errorCode = I2S_EC_WRREADY;
				goto Error;
			}
		}
		
		tmp = sounddata[tIdx];
		smtI2SSetData(&tmp);	
	}
	
	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);
	

	//-------------------------------------------------------
	//	I2S TX 44100Hz, 24bits
	//-------------------------------------------------------	
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-BITWIDTH I2S 24bits test!!!\n");

	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);		

	// I2S configure
	smtI2SGetMode(I2S_DIR_TX, &I2SCtrl);		
	I2SCtrl.WLen = I2ST_BW_24BIT;			
	smtI2SSetMode(I2S_DIR_TX, &I2SCtrl);		
	
	// I2S run
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
		
	// make and write sample
	for(tIdx = 0; tIdx <  128*1024/2; tIdx++) 
	{
		// check fifo wait FIFO is not full
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);	
			if(I2SStatus.FIFOL != 32) 
			{
				break;
			}
			
			if(timeOut++ == I2S_TO_WRREADY)
			{
				errorCode = I2S_EC_WRREADY;
				goto Error;
			}
		}
		
		tmp = (sounddata[tIdx]&0xFFFF)<<8;
		smtI2SSetData(&tmp);	
		
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);	
			if(I2SStatus.FIFOL != 32)
			{
				break;
			}
			
			if(timeOut++ == I2S_TO_WRREADY)
			{
				errorCode = I2S_EC_WRREADY;
				goto Error;
			}
		}		
		
		tmp = ((sounddata[tIdx]>>16)&0xFFFF)<<8;
		smtI2SSetData(&tmp);	
	}
	
	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);	
	
	//-------------------------------------------------------
	//	I2S TX 44100Hz, 32bits
	//-------------------------------------------------------		
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-BITWIDTH I2S 32bits test!!!\n");

	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);		

	// I2S configure
	smtI2SGetMode(I2S_DIR_TX, &I2SCtrl);		
	I2SCtrl.WLen = I2ST_BW_32BIT;			
	smtI2SSetMode(I2S_DIR_TX, &I2SCtrl);		
	
	// I2S run
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
		
	// make and write sample
	for(tIdx = 0; tIdx <  128*1024/2; tIdx++) 
	{
		// check fifo wait FIFO is not full
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);	
			if(I2SStatus.FIFOL != 32)
			{
				break;
			}
			
			if(timeOut++ == I2S_TO_WRREADY)
			{
				errorCode = I2S_EC_WRREADY;
				goto Error;
			}
		}
		
		tmp = (sounddata[tIdx]&0xffff)<<16;
		smtI2SSetData(&tmp);	
		
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);	
			if(I2SStatus.FIFOL != 32) 
			{
				break;
			}
				
			if(timeOut++ == I2S_TO_WRREADY)
			{
				errorCode = I2S_EC_WRREADY;
				goto Error;
			}
		}		
		tmp = ((sounddata[tIdx]>>16)&0xffff)<<16;
		smtI2SSetData(&tmp);	

	}
	
	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);		

Error:
	return 0;
}
/*----------------------------------------------------------
	Function name	: I2STestTXSampleRate
	Prototype		: smtUint32 I2STestTXSampleRate(void)
	Return			: test success/fail(0, 1-2)
	Argument		: none
	Comments		: I2S TX sampleRate (11025/22050/44100/48000)Hz test
-----------------------------------------------------------*/
smtUint32 I2STestTXSampleRate(void)
{
	I2sClkMode		I2SClkMode;
	I2sStatusDat	I2SStatus;
	smtUint32		tIdx;
	smtUint32		timeOut;
	smtUint32		errorCode;
	smtUint32		tmp;
	
	I2SDefaultSettingTX();
	errorCode = I2S_EC_NONE;
	
	//-------------------------------------------------------
	//	I2S TX 11025Hz, 16bits
	//-------------------------------------------------------
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-SAMPLERATE 11025Hz test!!!\n");		
	
	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);		

	// I2S clock configure
	smtI2SGetClockMode(&I2SClkMode);
	I2SClkMode.DTORatio		= I2ST_DTO_11025;		
	smtI2SSetClockMode(&I2SClkMode);
	
	// I2S run
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);	
		
	// make and write sample
	for(tIdx = 0; tIdx <  128*1024/2; tIdx+= 4) 
	{
				
	
		// check fifo wait FIFO is not full
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);	
			if(I2SStatus.FIFOL != 32) 
			{
				break;
			}
			
			if(timeOut++ == I2S_TO_WRREADY)
			{
				errorCode = I2S_EC_WRREADY;
				goto Error;
			}			
		}
		
		tmp = sounddata[tIdx];		
		smtI2SSetData(&tmp);
	}
	
	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);

	//-------------------------------------------------------
	//	I2S TX 22050Hz, 16bits
	//-------------------------------------------------------
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-SAMPLERATE 22050Hz test!!!\n");

	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);		

	// I2S clock configure
	smtI2SGetClockMode(&I2SClkMode);
	I2SClkMode.DTORatio		= I2ST_DTO_22050;		// 22050 sample rate
	smtI2SSetClockMode(&I2SClkMode);
	
	// I2S run
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
			
	// make and write sample
	for(tIdx = 0; tIdx <  128*1024/2; tIdx+= 2) 
	{
		// check fifo wait FIFO is not full
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);	
			if(I2SStatus.FIFOL != 32)
			{ 
				break;
			}
			
			if(timeOut++ == I2S_TO_WRREADY)
			{
				errorCode = I2S_EC_WRREADY;
				goto Error;
			}
		}
		
		tmp = sounddata[tIdx];
		smtI2SSetData(&tmp);
	}
	
	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);
	
	//-------------------------------------------------------
	//	I2S TX 44100Hz, 16bits
	//-------------------------------------------------------
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-SAMPLERATE 44100Hz test!!!\n");

	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);		

	// I2S clock configure
	smtI2SGetClockMode(&I2SClkMode);
	I2SClkMode.DTORatio		= I2ST_DTO_44100;		// 44100 sample rate
	smtI2SSetClockMode(&I2SClkMode);
	
	// I2S run
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
		
	// make and write sample
	for(tIdx = 0; tIdx <  128*1024/2; tIdx++) 
	{
		// check fifo wait FIFO is not full
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);	
			if(I2SStatus.FIFOL != 32) 
			{
				break;
			}
			
			if(timeOut++ == I2S_TO_WRREADY)
			{
				errorCode = I2S_EC_WRREADY;
				goto Error;
			}
		}
		
		tmp = sounddata[tIdx];
		smtI2SSetData(&tmp);
	}
	
	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);
	
	//-------------------------------------------------------
	//	I2S TX 48000Hz, 16bits
	//-------------------------------------------------------	
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-SAMPLERATE 48000Hz test!!!\n");

	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);		

	// I2S clock configure
	smtI2SGetClockMode(&I2SClkMode);
	I2SClkMode.DTORatio		= I2ST_DTO_48000;		// 48000 sample rate
	smtI2SSetClockMode(&I2SClkMode);
	
	// I2S run
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
		
	// make and write sample
	for(tIdx = 0; tIdx <  128*1024/2; tIdx++) 
	{
		// check fifo wait FIFO is not full
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);	
			if(I2SStatus.FIFOL != 32) 
			{
				break;
			}
			
			if(timeOut++ == I2S_TO_WRREADY)
			{
				errorCode = I2S_EC_WRREADY;
				goto Error;
			}
		}
		
		tmp = sounddata[tIdx];		
		smtI2SSetData(&tmp);
	}
	
	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);	
	
Error:	
	return 0;
}
/*----------------------------------------------------------
	Function name	: I2STestTXEvent
	Prototype		: smtUint32 I2STestTXEvent(void)
	Return			: test success/fail(0, 1-2)
	Argument		: none
	Comments		: I2S TX underrun event test
-----------------------------------------------------------*/
smtUint32 I2STestTXEvent(void)
{
	I2sCtrl			I2SCtrl;
	I2sStatusDat	I2SStatus;
	smtUint32		tIdx;
	smtUint32		timeOut;
	smtUint32		errorCode;
	smtUint32		tmp;
	
	I2SDefaultSettingTX();
	errorCode = I2S_EC_NONE;
	
	//-------------------------------------------------------
	//	1. polling test
	//-------------------------------------------------------

	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);	
	
	// I2S configure
	smtI2SGetMode(I2S_DIR_TX, &I2SCtrl);		
	I2SCtrl.FifoOURIntEn	= 0x1;			// underrun enable
	smtI2SSetMode(I2S_DIR_TX, &I2SCtrl);			
		
	// I2S run
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);	
	
	
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-EVENT underrun status polling test!!!\n");
	
	// make and write sample
	for(tIdx = 0; tIdx < 128*1024/2; tIdx++)
	{
		
		if(tIdx == 128*1024/2/2) {
			
			// forced delay until occured underrun error
			timeOut = 0;
			while(1)
			{				
				
				// check underrun event
				smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
				if(I2SStatus.FIFOURInt)
				{
					smtI2SClearFIFO(I2S_DIR_TX);
					// under run polling test OK!!!
					break;
				}
				
				// check timeout of underrun event
				if(timeOut++ == I2S_TO_UNDERRUNEVENT)
				{
					// under run polling test FAIL!!!
					//return 2;
					errorCode = I2S_EC_PUNDERRUNEVENT;
					goto Error;
				}
				
			}
			
			
			break;	
		}
		
		// check FIFO status
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);	
			if(I2SStatus.FIFOL != 32) 
			{
				break;
			}
			
			if(timeOut++ == I2S_TO_WRREADY)
			{
				errorCode = I2S_EC_WRREADY;
				goto Error;
			}
		}		
		
		//write sample
		tmp = sounddata[tIdx];
		smtI2SSetData(&tmp);
	}	
	
	// I2S stop
	smtI2SEnable(I2S_DIR_TX, 0);		
	
	//-------------------------------------------------------
	//	2. interrupt test
	//-------------------------------------------------------
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-EVENT underrun status interrupt test!!!\n");
	
	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);	
	
	// I2S configure
	smtI2SGetMode(I2S_DIR_TX, &I2SCtrl);		
	I2SCtrl.FifoOURIntEn	= 0x1;			// underrun enable
	smtI2SSetMode(I2S_DIR_TX, &I2SCtrl);		
	
	// I2S interrupt configure
	underRunFlag = 0;
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(I2ST_INT_NUM, I2SUnderRunHandler);
	Enable_IRQ();		
		
	// I2S run
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);		
		
	// make and write sample
	for(tIdx = 0; tIdx <  128*1024/2; tIdx++)
	{

		if(tIdx == 128*1024/2/2) {
			
			// forced delay until occured underrun error
			timeOut = 0;
			while(1)
			{
				if(underRunFlag)
				{
					// under run polling test OK!!!
					underRunFlag = 0;
					break;
				}
				
				if(timeOut++ == I2S_TO_UNDERRUNEVENT )
				{
					// under run polling test FAIL!!!
					errorCode = I2S_EC_IUNDERRUNEVENT;
					goto Error;
					//return 2;
				}
			}
			
			break;	
		}
		
		// check FIFO status
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);	
			if(I2SStatus.FIFOL != 32) 
			{
				break;
			}
			
			if(timeOut++ == I2S_TO_WRREADY)
			{
				errorCode = I2S_EC_WRREADY;
				goto Error;
			}
		}	
		//write sample
		tmp = sounddata[tIdx];
		smtI2SSetData(&tmp);
		EnableIRQ(I2ST_INT_NUM);
	}		
	
	// I2S disable interrupt
	ReleaseIRQ(I2ST_INT_NUM);
	
	// I2S stop
	smtI2SEnable(I2S_DIR_TX, 0);	
	
	
Error:	
	
	if(errorCode != I2S_EC_NONE) return 2;
		
	return 0;
	
}
/*----------------------------------------------------------
	Function name	: I2STestRXTransmit
	Prototype		: smtUint32 I2STestRXTransmit(void)
	Return			: test success/fail(0, 1-2)
	Argument		: none
	Comments		: RX transmit (CPU/DMA) test
-----------------------------------------------------------*/
smtUint32 I2STestRXTransmit(void)
{
	I2sCtrl		I2SCtrl;
	I2sStatusDat	I2SStatus;
	smtUint32		tIdx;	
	smtUint32		rxData;
	smtUint32 		regValue;	
	smtUint32		timeOut;
	smtUint32		errorCode;
	
	I2SDefaultSettingRX();	
	I2SDefaultSettingTX();	
	errorCode = I2S_EC_NONE;
	
	//-------------------------------------------------------
	// 1, I2S RX by CPU, 44100Hz, 16bits
	//-------------------------------------------------------
	I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-TRANSMIT polling test!!!\n");
	
	// I2S RX & TX stop 
	smtI2SEnable(I2S_DIR_TX, 0);		
	smtI2SEnable(I2S_DIR_RX, 0);		

	// I2S RX & TX configure
	smtI2SGetMode(I2S_DIR_TX, &I2SCtrl);		
	I2SCtrl.DMAIntEn = 0x0;
	smtI2SSetMode(I2S_DIR_TX, &I2SCtrl);		
	
	smtI2SGetMode(I2S_DIR_RX, &I2SCtrl);		
	I2SCtrl.DMAIntEn = 0x0;
	smtI2SSetMode(I2S_DIR_RX, &I2SCtrl);		
	
	// I2S run
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
		
	smtI2SResetFIFO(I2S_DIR_RX);
	smtI2SEnable(I2S_DIR_RX, 1);		
	
	for(tIdx = 0; tIdx <  128*1024/2; tIdx++) 
	{
		// check fifo wait FIFO is not full
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_RX, &I2SStatus);	
			if(I2SStatus.FIFOL != 0) 
			{ 
				break;
			}
			
			if(timeOut++ == I2S_TO_RDREADY)
			{
				errorCode = I2S_EC_RDREADY;
				goto Error;
			}
				
		}
		

		smtI2SGetData(&rxData);
		smtI2SSetData(&rxData);	
	}

	// I2S stop
	smtI2SEnable(I2S_DIR_TX, 0);
	smtI2SEnable(I2S_DIR_RX, 0);
	
	//-------------------------------------------------------
	// 2, I2S RX by DMA, 44100Hz, 16bits
	//-------------------------------------------------------	
	I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-TRANSMIT DMA test!!!\n");
	
	// set TX & RX DMA
	regValue 	= SMT_READ(RS_DMAMUX);
	regValue	&= ~(0xF			<<(I2ST_TX_DMC_CH*4));
	regValue	|= (I2ST_TX_PERI_IDX<<(I2ST_TX_DMC_CH*4));
	regValue	&= ~(0xF			<<(I2ST_RX_DMC_CH*4));
	regValue	|= (I2ST_RX_PERI_IDX<<(I2ST_RX_DMC_CH*4));	
	SMT_WRITE(RS_DMAMUX, regValue);		

	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);	
	smtI2SEnable(I2S_DIR_RX, 0);	
	
	// configure interrupt
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(I2ST_TX_DMC_INT_NUM, I2STXDMAHandler);
	RequestIRQ(I2ST_RX_DMC_INT_NUM, I2SRXDMAHandler);
	gRXDMAEnd = 0;
	gTXDMAEnd = 0;
	Enable_IRQ();

	// I2S run
	smtI2SResetFIFO(I2S_DIR_RX);
	smtI2SEnable(I2S_DIR_RX, 1);
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);		
	
	for(tIdx = 0; tIdx < 8; tIdx++) 
	{
		// cache flushing
		DCacheFlushing();
		
		// disable
		SMT_WRITE(DMACSta(I2ST_RX_DMC_CH), 0xf);
		
		// set source address
		SMT_WRITE (DMACSAdr(I2ST_RX_DMC_CH), (smtUint32)&I2S_DATA);
		
		// set destination address
		SMT_WRITE (DMACDAdr(I2ST_RX_DMC_CH), (smtUint32)dmaBuffer);	
					
		// set configuration, for new version
		regValue =
		 	((0x0 << 31)				// disable start interrupt
			|(0x1 << 30)				// enable end interrupt
			|(0x0 << 29)				// no using flow control(hand shaking)
			|(0x0 << 28)				// source increasement
			|(0x2 << 26)				// source WORD width
			|(0x1 << 25)				// destination increasement
			|(0x2 << 23)				// target WORD width
			|(0x5 << 20)				// burst size 32 byte
			|(32*1024));				// total transfer size
		
		SMT_WRITE (DMACCon(I2ST_RX_DMC_CH), regValue);
		
		// no use descriptor
		SMT_WRITE (DMACDescrp(I2ST_RX_DMC_CH), 0x1);
		
		// run 
		SMT_WRITE(DMACSta(I2ST_RX_DMC_CH), 
			DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK);

		timeOut = 0;
		while(true)
		{
			
			if(gRXDMAEnd)  
			{
				break;
			}
				
			if(timeOut++ == I2S_TO_DMA) 
			{
				SMT_WRITE(DMACSta(I2ST_TX_DMC_CH), 0xf);
				smtI2SEnable(I2S_DIR_TX, 0);
				
				SMT_WRITE(DMACSta(I2ST_RX_DMC_CH), 0xf);
				smtI2SEnable(I2S_DIR_RX, 0);	

				errorCode = I2S_EC_DMA;
				goto Error;
				//return 2;
			}
		}
		
		// cache flushing
		DCacheFlushing();

		// DMA disable
		SMT_WRITE(DMACSta(I2ST_TX_DMC_CH), 0xf);

		// set source address
		SMT_WRITE (
			DMACSAdr(I2ST_TX_DMC_CH), 
			(smtUint32)dmaBuffer
		);
		
		// set destination address
		SMT_WRITE (
			DMACDAdr(I2ST_TX_DMC_CH), 
			(smtUint32)&I2S_DATA
		);	
					
		// set configuration 
		regValue = 
		 	((0x0 << 31)				// disable start interrupt
			|(0x1 << 30)				// enable end interrupt
			|(0x0 << 29)				// using flow control(hand shaking)
			|(0x1 << 28)				// source increasement
			|(0x2 << 26)				// source WORD width
			|(0x0 << 25)				// destination decreasement
			|(0x2 << 23)				// target WORD width
			|(0x5 << 20)				// burst size 32 byte
			|(32*1024));				// total transfer size
			
		SMT_WRITE (DMACCon(I2ST_TX_DMC_CH), regValue);
		
		// no use descriptor
		SMT_WRITE (DMACDescrp(I2ST_TX_DMC_CH), 0x1);
		
		// run 
		SMT_WRITE(
			DMACSta(I2ST_TX_DMC_CH), 
			DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK);

		
		timeOut = 0;
		while(true)
		{
			
			if(gTXDMAEnd)  
			{
				break;
			}
				
			if(timeOut++ == I2S_TO_DMA) 
			{
				SMT_WRITE(DMACSta(I2ST_TX_DMC_CH), 0xf);
				smtI2SEnable(I2S_DIR_TX, 0);
				
				SMT_WRITE(DMACSta(I2ST_RX_DMC_CH), 0xf);
				smtI2SEnable(I2S_DIR_RX, 0);	
				
				errorCode = I2S_EC_DMA;
				goto Error;
				//return 2;
			}
		}
		
		// memory clear
		memset(dmaBuffer, 0, sizeof(dmaBuffer));
		
	}
	
	// I2S interrupt disable
	ReleaseIRQ(I2ST_RX_DMC_INT_NUM);	
	ReleaseIRQ(I2ST_TX_DMC_INT_NUM);	
	
	// I2S stop
	smtI2SEnable(I2S_DIR_RX, 0);	
	smtI2SEnable(I2S_DIR_TX, 0);	


Error:	
	
	if(errorCode != I2S_EC_NONE) return 2;

	return 0;
}
/*----------------------------------------------------------
	Function name	: I2STestRXBitWidthTest
	Prototype		: smtUint32 I2STestRXBitWidthTest(void)
	Return			: test success/fail(0, 1-2)
	Argument		: none
	Comments		: I2S RX bitwidth (8/16/24/32) bits test
-----------------------------------------------------------*/
smtUint32 I2STestRXBitWidthTest(void)
{
	I2sCtrl		I2SCtrl;
	I2sStatusDat	I2SStatus;
	smtUint32 		rxData;
	int 			i;	
	smtUint32		timeOut;
	smtUint32		errorCode;
	
	errorCode = I2S_EC_NONE;

	//-------------------------------------------------------
	//	1. I2S RX 44100Hz, 8bits
	//-------------------------------------------------------
	I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-BITWIDTH I2S 8bits test!!!\n");
	
	// I2S RX & TX default setting
	I2SDefaultSettingTX();
	I2SDefaultSettingRX();
	
	// I2S RX & TX stop
	smtI2SEnable(I2S_DIR_RX, 0);
	smtI2SEnable(I2S_DIR_TX, 0);
	
	// I2S RX & TX configure
	smtI2SGetMode(I2S_DIR_RX, &I2SCtrl);		
	I2SCtrl.WLen = I2ST_BW_08BIT;			
	smtI2SSetMode(I2S_DIR_RX, &I2SCtrl);		
	smtI2SGetMode(I2S_DIR_TX, &I2SCtrl);		
	I2SCtrl.WLen = I2ST_BW_08BIT;			
	smtI2SSetMode(I2S_DIR_TX, &I2SCtrl);		

	// I2S RX & TX run
	smtI2SResetFIFO(I2S_DIR_RX);
	smtI2SEnable(I2S_DIR_RX, 1);
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	for(i = 0; i < 32*1024; i++)
	{
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_RX, &I2SStatus);	
			if(I2SStatus.FIFOL != 0) 
			{
				break;
			}
			
			if(timeOut++ == I2S_TO_RDREADY)
			{
				errorCode = I2S_EC_RDREADY;
				goto Error;
			}
		}
	
		smtI2SGetData(&rxData);
		smtI2SSetData(&rxData);
	}

	//-------------------------------------------------------
	//	2. I2S RX 44100Hz, 16bits
	//-------------------------------------------------------	
	I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-BITWIDTH I2S 16bits test!!!\n");
		
	// I2S RX & TX stop
	smtI2SEnable(I2S_DIR_RX, 0);
	smtI2SEnable(I2S_DIR_TX, 0);
	
	// I2S RX & TX configure
	smtI2SGetMode(I2S_DIR_RX, &I2SCtrl);		
	I2SCtrl.WLen = I2ST_BW_16BIT;			
	smtI2SSetMode(I2S_DIR_RX, &I2SCtrl);		
	smtI2SGetMode(I2S_DIR_TX, &I2SCtrl);		
	I2SCtrl.WLen = I2ST_BW_16BIT;			
	smtI2SSetMode(I2S_DIR_TX, &I2SCtrl);		

	// I2S RX & TX run
	smtI2SResetFIFO(I2S_DIR_RX);
	smtI2SEnable(I2S_DIR_RX, 1);
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	for(i = 0; i < 32*1024*2; i++)
	{
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_RX, &I2SStatus);	
			if(I2SStatus.FIFOL != 0)
			{
				break;
			}
			
			if(timeOut++ == I2S_TO_RDREADY)
			{
				errorCode = I2S_EC_RDREADY;
				goto Error;
			}
				
		}
	
		smtI2SGetData(&rxData);
		smtI2SSetData(&rxData);
	}
	
	//-------------------------------------------------------
	//	3. I2S RX 44100Hz, 24bits
	//-------------------------------------------------------		
	I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-BITWIDTH I2S 24bits test!!!\n");
	
	// I2S RX & TX stop
	smtI2SEnable(I2S_DIR_RX, 0);
	smtI2SEnable(I2S_DIR_TX, 0);
	
	// I2S RX & TX configure
	smtI2SGetMode(I2S_DIR_RX, &I2SCtrl);		
	I2SCtrl.WLen = I2ST_BW_24BIT;			
	smtI2SSetMode(I2S_DIR_RX, &I2SCtrl);		
	smtI2SGetMode(I2S_DIR_TX, &I2SCtrl);		
	I2SCtrl.WLen = I2ST_BW_24BIT;			
	smtI2SSetMode(I2S_DIR_TX, &I2SCtrl);		

	// I2S RX & TX run
	smtI2SResetFIFO(I2S_DIR_RX);
	smtI2SEnable(I2S_DIR_RX, 1);
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	for(i = 0; i < 32*1024*4; i++)
	{
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_RX, &I2SStatus);	
			if(I2SStatus.FIFOL != 0)
			{ 
				break;
			}
			
			if(timeOut++ == I2S_TO_RDREADY)
			{
				errorCode = I2S_EC_RDREADY;
				goto Error;
			}
		}
		
		smtI2SGetData(&rxData);
		smtI2SSetData(&rxData);
	}
	
	//-------------------------------------------------------
	//	4. I2S RX 44100Hz, 32bits
	//-------------------------------------------------------			
	I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-BITWIDTH I2S 32bits test!!!\n");
	
	// I2S RX & TX stop
	smtI2SEnable(I2S_DIR_RX, 0);
	smtI2SEnable(I2S_DIR_TX, 0);
	
	// I2S RX & TX configure
	smtI2SGetMode(I2S_DIR_RX, &I2SCtrl);		
	I2SCtrl.WLen = I2ST_BW_32BIT;			
	smtI2SSetMode(I2S_DIR_RX, &I2SCtrl);		
	smtI2SGetMode(I2S_DIR_TX, &I2SCtrl);		
	I2SCtrl.WLen = I2ST_BW_32BIT;			
	smtI2SSetMode(I2S_DIR_TX, &I2SCtrl);		

	// I2S RX & TX run
	smtI2SResetFIFO(I2S_DIR_RX);
	smtI2SEnable(I2S_DIR_RX, 1);
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	for(i = 0; i < 32*1024*4; i++)
	{
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_RX, &I2SStatus);	
			if(I2SStatus.FIFOL != 0)
			{ 
				break;
			}
			if(timeOut++ == I2S_TO_RDREADY)
			{
				errorCode = I2S_EC_RDREADY;
				goto Error;
			}
		}
	
		smtI2SGetData(&rxData);
		smtI2SSetData(&rxData);
	}

Error:		
	return 0;		
}
/*----------------------------------------------------------
	Function name	: I2STestRXSampleRateTest
	Prototype		: smtUint32 I2STestRXSampleRateTest(void)
	Return			: test success/fail(0, 1-2)
	Argument		: none
	Comments		: I2S RX sampleRate (11025/22050/44100/48000)Hz test
-----------------------------------------------------------*/
smtUint32 I2STestRXSampleRateTest(void)
{
	I2sClkMode	I2SClkMode;
	I2sStatusDat	I2SStatus;		
	smtUint32		i;
	smtUint32 		rxData;
	smtUint32		timeOut;
	smtUint32		errorCode;
	
	I2SDefaultSettingTX();
	I2SDefaultSettingRX();
	
	errorCode = I2S_EC_NONE;
	
	//-------------------------------------------------------
	//	I2S RX 11025Hz, 16bits
	//-------------------------------------------------------		
	I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-SAMPLERATE 11025Hz test!!!\n");		
	
	smtI2SEnable(I2S_DIR_RX, 0);
	smtI2SEnable(I2S_DIR_TX, 0);
	
	smtI2SGetClockMode(&I2SClkMode);
	I2SClkMode.DTORatio		= I2ST_DTO_11025;		
	smtI2SSetClockMode(&I2SClkMode);	
	
	smtI2SResetFIFO(I2S_DIR_RX);
	smtI2SEnable(I2S_DIR_RX, 1);
	
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	for(i = 0; i < 32*1024; i++)
	{
		
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_RX, &I2SStatus);	
			if(I2SStatus.FIFOL != 0) 
			{
				break;
			}
			if(timeOut++ == I2S_TO_RDREADY)
			{
				errorCode = I2S_EC_RDREADY;
				goto Error;
			}
		}			
		smtI2SGetData(&rxData);
		smtI2SSetData(&rxData);
	}

	//-------------------------------------------------------
	//	I2S RX 22050Hz, 16bits
	//-------------------------------------------------------
	I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-SAMPLERATE 22050Hz test!!!\n");		
	
	smtI2SEnable(I2S_DIR_RX, 0);
	smtI2SEnable(I2S_DIR_TX, 0);
	
	smtI2SGetClockMode(&I2SClkMode);
	I2SClkMode.DTORatio		= I2ST_DTO_22050;		
	smtI2SSetClockMode(&I2SClkMode);	
	
	smtI2SResetFIFO(I2S_DIR_RX);
	smtI2SEnable(I2S_DIR_RX, 1);
	
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	for(i = 0; i < 32*1024*2; i++)
	{
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_RX, &I2SStatus);	
			if(I2SStatus.FIFOL != 0)
			{
				break;
			}
			
			if(timeOut++ == I2S_TO_RDREADY)
			{
				errorCode = I2S_EC_RDREADY;
				goto Error;
			}
		}			

		smtI2SGetData(&rxData);
		smtI2SSetData(&rxData);
	}
	
	//-------------------------------------------------------
	//	I2S RX 44100Hz, 16bits
	//-------------------------------------------------------	
	I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-SAMPLERATE 44100Hz test!!!\n");		
		
	smtI2SEnable(I2S_DIR_RX, 0);
	smtI2SEnable(I2S_DIR_TX, 0);
	
	smtI2SGetClockMode(&I2SClkMode);
	I2SClkMode.DTORatio		= I2ST_DTO_44100;		
	smtI2SSetClockMode(&I2SClkMode);	
	
	smtI2SResetFIFO(I2S_DIR_RX);
	smtI2SEnable(I2S_DIR_RX, 1);
	
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	for(i = 0; i < 32*1024*4; i++)
	{
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_RX, &I2SStatus);	
			if(I2SStatus.FIFOL != 0)
			{
				break;
			}
			if(timeOut++ == I2S_TO_RDREADY)
			{
				errorCode = I2S_EC_RDREADY;
				goto Error;
			}
		}			

		smtI2SGetData(&rxData);
		smtI2SSetData(&rxData);
	}
	
	smtI2SEnable(I2S_DIR_RX, 0);
	smtI2SEnable(I2S_DIR_TX, 0);
	
	smtI2SGetClockMode(&I2SClkMode);
	I2SClkMode.DTORatio		= I2ST_DTO_48000;		
	smtI2SSetClockMode(&I2SClkMode);	
	
	smtI2SResetFIFO(I2S_DIR_RX);
	smtI2SEnable(I2S_DIR_RX, 1);
	
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	for(i = 0; i < 32*1024*4; i++)
	{
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_RX, &I2SStatus);	
			if(I2SStatus.FIFOL != 0) 
			{
				break;
			}
			if(timeOut++ == I2S_TO_RDREADY)
			{
				errorCode = I2S_EC_RDREADY;
				goto Error;
			}
		}			

		smtI2SGetData(&rxData);
		smtI2SSetData(&rxData);
	}
	
Error:	
	return 0;		
	
}
/*----------------------------------------------------------
	Function name	: I2STestRXEvent
	Prototype		: smtUint32 I2STestRXEvent(void)
	Return			: test success/fail(0, 1-2)
	Argument		: none
	Comments		: I2S RX underrun event test
-----------------------------------------------------------*/
smtUint32 I2STestRXEvent(void)
{
	I2sStatusDat	I2SStatus;		
	I2sCtrl		I2SCtrl;
	smtUint32		i;
	smtUint32 		rxData;
	smtUint32		timeOut;
	smtUint32		errorCode;

	I2SDefaultSettingTX();
	I2SDefaultSettingRX();
	
	errorCode = I2S_EC_NONE;
	
	//-------------------------------------------------------
	//	1. polling test
	//-------------------------------------------------------	
	I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-EVENT overrun status polling test!!!\n");
	
	// I2S RX & TX stop
	smtI2SEnable(I2S_DIR_RX, 0);
	smtI2SEnable(I2S_DIR_TX, 0);	
	
	// I2S RX configure
	smtI2SGetMode(I2S_DIR_RX, &I2SCtrl);		
	I2SCtrl.FifoOURIntEn	= 0x1;		// overrun enable
	smtI2SSetMode(I2S_DIR_RX, &I2SCtrl);			
	
	// I2S RX & TX run
	smtI2SResetFIFO(I2S_DIR_RX);
	smtI2SEnable(I2S_DIR_RX, 1);
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	for(i = 0; i < 32*1024; i++)
	{
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_RX, &I2SStatus);	
			if(I2SStatus.FIFOL != 0) 
			{
				break;
			}
				
			if(timeOut++ == I2S_TO_RDREADY)
			{
				errorCode = I2S_EC_RDREADY;
				goto Error;
			}
		}			
		
		if(i == 32*1024/2) 
		{
			timeOut = 0;
			while(1)
			{
				// check overrun event
				smtI2SGetStatus(I2S_DIR_RX, &I2SStatus);
				if(I2SStatus.FIFOURInt)
				{
					smtI2SClearFIFO(I2S_DIR_RX);
					// overrun run polling test OK!!!
					break;
				}
				
				if(timeOut++ == I2S_TO_OVERRUNEVENT) {
					smtI2SEnable(I2S_DIR_RX, 0);
					// overrun test timeout!!!
					
					errorCode = I2S_EC_POVERRUNEVENT;
					goto Error;
					//return 1;
				}
			}
		}
	

		smtI2SGetData(&rxData);
		smtI2SSetData(&rxData);
	}

	
	smtI2SEnable(I2S_DIR_TX, 0);
	smtI2SEnable(I2S_DIR_RX, 0);
	

	//-------------------------------------------------------
	//	2. interrupt test
	//-------------------------------------------------------	
	I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-EVENT overrun status interrupt test!!!\n");
	
	// I2S RX & TX stop
	smtI2SEnable(I2S_DIR_RX, 0);
	smtI2SEnable(I2S_DIR_TX, 0);	
	
	// I2S RX configure
	smtI2SGetMode(I2S_DIR_RX, &I2SCtrl);		
	I2SCtrl.FifoOURIntEn	= 0x1;		// overrun enable
	smtI2SSetMode(I2S_DIR_RX, &I2SCtrl);			

	// I2S RX interrupt configure	
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(I2ST_INT_NUM, I2SOverRunHandler);
	overRunFlag = 0;		
	Enable_IRQ();
	
	// I2S RX & TX run
	smtI2SResetFIFO(I2S_DIR_RX);
	smtI2SEnable(I2S_DIR_RX, 1);
	smtI2SResetFIFO(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	for(i = 0; i < 32*1024; i++)
	{
		timeOut = 0;
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_RX, &I2SStatus);	
			if(I2SStatus.FIFOL != 0) 
			{
				break;
			}
			
			if(timeOut++ == I2S_TO_RDREADY)
			{
				errorCode = I2S_EC_RDREADY;
				goto Error;
			}			
		}			
		
		
		if(i == 32*1024/2) 
		{
			timeOut = 0;
			while(1)
			{
				// check overrun event
				if(overRunFlag)
				{
					overRunFlag = 0;
					break;
				}
				
			
				if(timeOut++ == I2S_TO_OVERRUNEVENT) {
					smtI2SEnable(I2S_DIR_RX, 0);
					// overrun test timeout!!!
					
					errorCode = I2S_EC_IOVERRUNEVENT;
					goto Error;
					//return 2;
				}

			}
			
		}
	

		smtI2SGetData(&rxData);
		smtI2SSetData(&rxData);
	}
	
	// I2S disable interrupt
	ReleaseIRQ(I2ST_INT_NUM);
	
	// I2S stop
	smtI2SEnable(I2S_DIR_RX, 0);
		
Error:	
	
	switch(errorCode)
	{
	case I2S_EC_POVERRUNEVENT	: return 1;
	case I2S_EC_IOVERRUNEVENT	: return 2;		
	case I2S_EC_RDREADY			: return 2;		
	}
	return 0;		
	
}
/*----------------------------------------------------------
	Function name	: I2STest()
	Prototype		: smtUint32 I2STest(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 I2STest(void)
{
	// Edit your I2S test code
	smtUint32		I2STestRet;	

	I2SDefaultSettingTX();
	I2SDefaultSettingRX();
	UDA1341Init();	
	

	//-------------------------------------------------------
	//	I2S RX test 0 (CPU/DMA)
	//-------------------------------------------------------
	I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-TRANSMIT test start !!!\n");
	I2STestRet = I2STestRXTransmit();
	if(I2STestRet)
	{
		switch(I2STestRet)
		{
		case 1:
			I2SDPRINTF(CFG_UART_CH, "[I2S RX ERROR]-TRANSMIT polling test fail!!!\n");
			break;
		case 2:
			I2SDPRINTF(CFG_UART_CH, "[I2S RX ERROR]-TRANSMIT DMA test fail!!!\n");
			break;
		}
		goto I2SError;
	}
	else
	{
		I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-TRANSMIT OK!!!\n");
	}	
	
	
	//-------------------------------------------------------
	//	I2S RX test 1 (overrun interrupt/polling)
	//-------------------------------------------------------	
	I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-EVENT test start !!!\n");
	I2STestRet = I2STestRXEvent();
	if(I2STestRet)
	{
		switch(I2STestRet)
		{
		case 1:
			I2SDPRINTF(CFG_UART_CH, "[I2S RX ERROR]-EVENT overrun polling test fail!!!\n");
			break;
		case 2:
			I2SDPRINTF(CFG_UART_CH, "[I2S RX ERROR]-EVENT overrun interrupt test fail!!!\n");
			break;
		}		
		goto I2SError;
	}
	else
	{
		I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-EVENT OK!!!\n");
	}
	
	//-------------------------------------------------------
	//	I2S RX test 2 bitwidth test (8/16/24/32)bits
	//-------------------------------------------------------
	I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-BITWIDTH test start !!!\n");
	I2STestRet = I2STestRXBitWidthTest();
	if(I2STestRet)
	{
		switch(I2STestRet)
		{
		default: break;
		}		
		goto I2SError;
	}
	else
	{
		I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-BITWIDTH OK!!!\n");
	}
		
	//-------------------------------------------------------
	//	I2S RX test 3 samplerate test (11025/22050/44100/48000)Hz
	//-------------------------------------------------------
	I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-SAMPLERATE test start !!!\n");
	I2STestRet = I2STestRXSampleRateTest();
	if(I2STestRet)
	{
		switch(I2STestRet)
		{
		default: break;
		}		
		goto I2SError;
	}
	else
	{
		I2SDPRINTF(CFG_UART_CH, "[I2S RX TEST]-SAMPLERATE OK!!!\n");
	}

	//-------------------------------------------------------
	//	I2S TX test 0 (CPU/DMA)
	//-------------------------------------------------------
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-TRANSMIT test start !!!\n");
	I2STestRet = I2STestTXTransmit();
	if(I2STestRet)
	{
		switch(I2STestRet)
		{
		case 1:
			I2SDPRINTF(CFG_UART_CH, "[I2S TX ERROR]-TRANSMIT polling test fail!!!\n");
			break;
		case 2:
			I2SDPRINTF(CFG_UART_CH, "[I2S TX ERROR]-TRANSMIT DMA test fail!!!\n");
			break;
		}
		goto I2SError;
	}
	else
	{
		I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-TRANSMIT OK!!!\n");
	}

	//-------------------------------------------------------
	//	I2S TX test 1 (underrun interrupt, polling)
	//-------------------------------------------------------	
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-EVENT test start !!!\n");
	I2STestRet = I2STestTXEvent();
	if(I2STestRet)
	{
		switch(I2STestRet)
		{
		case 1:
			I2SDPRINTF(CFG_UART_CH, "[I2S TX ERROR]-EVENT underrun polling test fail!!!\n");
			break;
		case 2:
			I2SDPRINTF(CFG_UART_CH, "[I2S TX ERROR]-EVENT underrun interrupt test fail!!!\n");
			break;
		}		
		goto I2SError;
	}
	else
	{
		I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-EVENT OK!!!\n");
	}
	
	//-------------------------------------------------------
	//	I2S TX test 2 bitswidth test (8/16/24/32)bits
	//-------------------------------------------------------
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-BITWIDTH test start !!!\n");
	I2STestRet = I2STestTXBitWidth();
	if(I2STestRet)
	{
		switch(I2STestRet)
		{
		case 1:
			I2SDPRINTF(CFG_UART_CH, "[I2S TX ERROR]-BITWIDTH I2S 8bit fail!!!\n");
			break;
		case 2:
			I2SDPRINTF(CFG_UART_CH, "[I2S TX ERROR]-BITWIDTH I2S 16bit test fail!!!\n");
			break;
		case 3:
			I2SDPRINTF(CFG_UART_CH, "[I2S TX ERROR]-BITWIDTH I2S 24bit test fail!!!\n");
			break;						
		case 4:
			I2SDPRINTF(CFG_UART_CH, "[I2S TX ERROR]-BITWIDTH I2S 32bit test fail!!!\n");
			break;			
		}		
		goto I2SError;
	}
	else
	{
		I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-BITWIDTH OK!!!\n");
	}

	//-------------------------------------------------------
	//	I2S TX test 3 sample rate test (11025/22050/44100/48000) Hz
	//-------------------------------------------------------	
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-SAMPLERATE test start !!!\n");
	I2STestRet = I2STestTXSampleRate();
	if(I2STestRet)
	{
		switch(I2STestRet)
		{
		case 1:
			I2SDPRINTF(CFG_UART_CH, "[I2S TX ERROR]-SAMPLERATE I2S 11025 Hz!!!\n");
			break;
		case 2:
			I2SDPRINTF(CFG_UART_CH, "[I2S TX ERROR]-SAMPLERATE I2S 22050 Hz!!!\n");
			break;
		case 3:
			I2SDPRINTF(CFG_UART_CH, "[I2S TX ERROR]-SAMPLERATE I2S 44100 Hz!!!\n");
			break;						
		case 4:
			I2SDPRINTF(CFG_UART_CH, "[I2S TX ERROR]-SAMPLERATE I2S 48000 Hz!!!\n");
			break;			
		}		
		goto I2SError;
	}
	else
	{
		I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST]-SAMPLERATE OK!!!\n");
	}
		
	
	return NO_ERROR;

I2SError:
	I2SDPRINTF(CFG_UART_CH, "[I2S TX TEST] FAIL!!!\n");
	return 	(!NO_ERROR);
}
