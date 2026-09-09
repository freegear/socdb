/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: i2s.c 
	Description	: I2S test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include <math.h>
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
//#include "irq.h"
#include "i2s.h"
#include "global.h"
#include "i2s_pre_drv.h"
/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define	I2ST_DTO_11025		(0x0)
#define	I2ST_DTO_22050		(0x0)
#define	I2ST_DTO_44100		(0x0)
#define	I2ST_DTO_48000		(0x0)

#define	I2ST_BW_08BIT		(0x0)
#define	I2ST_BW_16BIT		(0x0)
#define	I2ST_BW_24BIT		(0x0)
#define	I2ST_BW_32BIT		(0x0)

#define	I2ST_FIFO_TH		(0x0)
#define	I2ST_SAMPLE_LEN		(0x0)
#define	I2ST_DMC_CH			(0x0)
#define	I2ST_INT_NUM		(0x0)
#define	I2ST_UNDERRUN_TO	(0x7FFF);
/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
smtUint32 I2STest(void);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
static smtUint32 			DMABuffer[I2ST_SAMPLE_LEN];
static volatile smtBoolean	underRunFlag = 0;
// Edit your code

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	Function name	: I2SHandler
	Prototype		:
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static void I2SHandler(smtUint32 irq)
{
	static I2S_STATUS_DAT	I2SStatus;
	smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
	smtI2SFIFOClear(I2S_DIR_TX);
	underRunFlag = 1;
}
/*----------------------------------------------------------
	Function name	: SetI2SRXDefaultSetting
	Prototype		:
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static void SetI2SRXDefaultSetting(void)
{
	
	I2S_CLOCK_MODE	I2SClkMode;
	I2S_CONTROL		I2SCtrl;	
	I2S_STATUS_DAT	I2SStatus;
	
	// I2S disable for reconfigure I2S
	smtI2SEnable(I2S_DIR_TX, 0);
	
	// FIFO reset
	smtI2SFIFOReset(I2S_DIR_TX);
	
	// clock mode setting
	I2SClkMode.ClkMaster	= 0x1;					// master mode
	I2SClkMode.LRClkInv		= 0x0;					// L/R clock no inversion
	I2SClkMode.MClkOn		= 0x1;					// Mclk on
	I2SClkMode.MClkOE		= 0x1;					// Mclk enable
	I2SClkMode.DTORatio		= I2ST_DTO_44100;		// 44100 sample rate
	smtSetClockMode(I2SClkMode);
	
	// configure
	I2SCtrl.DMAIntEn		= 0x0;					// DMA disalbe
	I2SCtrl.FifoOURIntEn	= 0x0;					// underrun disable
	I2SCtrl.WLen			= I2ST_BW_16BIT;		// 16bits sample width 
	I2SCtrl.Ljust			= 0x0;					// I2S mode
	I2SCtrl.FifoTH			= I2ST_FIFO_TH;			// DMA burst length
	smtSetI2SMode(I2S_DIR_TX, I2SCtrl);
	
	// pending clear
	smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
	smtI2SFIFOClear(I2S_DIR_TX);
	
}
/*----------------------------------------------------------
	Function name	: I2STestTransmit
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void I2STestTransmit(void)
{
	I2S_CONTROL		I2SCtrl;
	I2S_STATUS_DAT	I2SStatus;
	smtUint32		tIdx;	
	smtInt16		SampleL, SampleR;
	smtUint32		Sample;
	
	//-------------------------------------------------------
	//	I2S TX test 0
	//	
	//	test transmitt test (16/44100)
	//		- dma
	//		- polling
	//-------------------------------------------------------
	
	//
	// 1, polling
	//
	
	// initialize
	SetI2SRXDefaultSetting();
	smtI2SEnable(I2S_DIR_TX, 1);
	
	// make and write sample
	for(tIdx = 0; tIdx < I2ST_SAMPLE_LEN; tIdx++)
	{
		// make sample
		SampleL = sin(tIdx);
		SampleR = sin(tIdx);
		Sample	= ((SampleR<<16)|SampleL);
	
		// check FIFO status
		// write condition is (FIFOL < 64)
		smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
		while(I2SStatus.FIFOL == 64);		
		
		//write sample
		smtI2SSetData(Sample);
	}
	// print "I2S polling test end"
	
	//
	// 2. DMA
	//
	
	SetI2SRXDefaultSetting();
	smtGetI2SMode(I2S_DIR_TX, &I2SCtrl);
	I2SCtrl.DMAIntEn	= 1;
	smtSetI2SMode(I2S_DIR_TX, I2SCtrl);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	// make sample
	for(tIdx = 0; tIdx < I2ST_SAMPLE_LEN; tIdx++)
	{
		
		SampleL 		= sin(tIdx);
		SampleR 		= sin(tIdx);
		DMABuffer[tIdx]	= ((SampleR<<16)|SampleL);
		
	}

	//DMA write sample
	smtDMACNoDescrp(
		(smtUint8)I2ST_DMC_CH, 			//	DMA channel
		(smtUint32)DMABuffer, 			//	source buffer
		true,							//	source increase
		0x2,							//	source bitwidth is WORD(32bits)
		I2S_DATA,						//	target buffer
		false, 							//	target increase
		0x2, 							//	target bitwidth is WORD(32bits)
		0x5, 							// 	burstsize 32byte
		I2ST_SAMPLE_LEN*2*sizeof(short)	// 	transfer size
	);
	
	// DMA end wait
	while(DMACSta(I2ST_DMC_CH) & (1<<27));
	

	// print "I2S DMA test end"
		
}

/*----------------------------------------------------------
	Function name	: I2STestEvent
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void I2STestEvent(void)
{
	
	I2S_CONTROL		I2SCtrl;
	I2S_STATUS_DAT	I2SStatus;
	smtUint32		tIdx;
	smtUint32		underRunTimeCnt;
	smtInt16		SampleL, SampleR;
	smtUint32		Sample;
		
	//-------------------------------------------------------
	//	I2S TX test 1
	//	
	//	test event(underrun) test (16/44100/polling)
	//		- interrupt
	//		- polling
	//-------------------------------------------------------	
	
	//
	//	1. polling test
	//
	
	// initialize
	SetI2SRXDefaultSetting();
	
	smtGetI2SMode(I2S_DIR_TX, &I2SCtrl);
	I2SCtrl.DMAIntEn		= 0x0;
	I2SCtrl.FifoOURIntEn	= 0x0;
	smtSetI2SMode(I2S_DIR_TX, I2SCtrl);
	smtI2SEnable(I2S_DIR_TX, 1);
		
	// make and write sample
	underRunTimeCnt = I2ST_UNDERRUN_TO;
	for(tIdx = 0; tIdx < I2ST_SAMPLE_LEN; tIdx++)
	{
		// make sample
		SampleL = sin(tIdx);
		SampleR = sin(tIdx);
		Sample	= ((SampleR<<16)|SampleL);
	
		// check FIFO status
		// write condition is (FIFOL < 64)
		smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
		while(I2SStatus.FIFOL == 64);
		
		
		if(tIdx == I2ST_SAMPLE_LEN/2) {
			// forced delay until occured underrun error
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
			while(1)
			{
				
				
				if(I2SStatus.FIFOURInt)
				{
					smtI2SFIFOClear(I2S_DIR_TX);
					// printf "under run polling test OK!!!"
					break;
				}
				
				if(underRunTimeCnt-- == 0)
				{
					// printf "under run polling test FAIL!!!"
					break;
				}
			
			}
			
			// end tes
			break;	
		}
		//write sample
		smtI2SSetData(Sample);
	}	
	
	
	//
	//	2. interrupt test
	//
	
	// interrupt enable
	underRunFlag = 0;
	RequestIRQ(I2ST_INT_NUM, I2SHandler);
	//EnableVIC();
	//EnableINT();
	EnableIRQ(I2ST_INT_NUM);
	
	
	// initialize
	SetI2SRXDefaultSetting();
	
	smtGetI2SMode(I2S_DIR_TX, &I2SCtrl);
	I2SCtrl.DMAIntEn		= 0x0;
	I2SCtrl.FifoOURIntEn	= 0x1;
	smtSetI2SMode(I2S_DIR_TX, I2SCtrl);
	smtI2SEnable(I2S_DIR_TX, 1);
		
	// make and write sample
	underRunTimeCnt = I2ST_UNDERRUN_TO;
	for(tIdx = 0; tIdx < I2ST_SAMPLE_LEN; tIdx++)
	{
		// make sample
		SampleL = sin(tIdx);
		SampleR = sin(tIdx);
		Sample	= ((SampleR<<16)|SampleL);
	
		// check FIFO status
		// write condition is (FIFOL < 64)
		smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
		while(I2SStatus.FIFOL == 64);
		
		
		if(tIdx == I2ST_SAMPLE_LEN/2) {
			// forced delay until occured underrun error
			
			while(1)
			{
				
				
				if(underRunFlag)
				{
					underRunFlag = 0;
					// printf "under run polling test OK!!!"
					break;
				}
				
				if(underRunTimeCnt-- == 0)
				{
					// printf "under run polling test FAIL!!!"
					break;
				}
			
			}
			
			// end tes
			break;	
		}
		//write sample
		smtI2SSetData(Sample);
	}		
	
	// disable interrupt
	//DisableINT();
	DisableIRQ(I2ST_INT_NUM);
	ReleaseIRQ(I2ST_INT_NUM);	
}
/*----------------------------------------------------------
	Function name	: I2STestBitWidth
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void I2STestBitWidth(void)
{
	
	I2S_CONTROL		I2SCtrl;
	I2S_STATUS_DAT	I2SStatus;
	smtInt8			ByteSampleL, ByteSampleR;
	smtUint32		Sample;	
	smtUint32		tIdx;
	
	//-------------------------------------------------------
	//	I2S TX test 2
	//	
	//	test bitwidth test (44100/polling)
	//		- 8bit
	//		- 16bit
	//		- 24bit
	//		- 32bit
	//-------------------------------------------------------

	//
	//	8bit
	//

	// initialize
	SetI2SRXDefaultSetting();

	// set config
	smtGetI2SMode(I2S_DIR_TX, &I2SCtrl);
	I2SCtrl.WLen			= I2ST_BW_08BIT;		
	smtSetI2SMode(I2S_DIR_TX, I2SCtrl);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	
	// make and write sample
	for(tIdx = 0; tIdx < I2ST_SAMPLE_LEN; tIdx++)
	{
		// make sample
		ByteSampleL = (smtUint8)sin(tIdx);
		ByteSampleR = (smtUint8)sin(tIdx);
		
		if(tIdx%2)
		{
			
			Sample	|= (((ByteSampleR<<8)|ByteSampleL)<<16);
			
			// check FIFO status
			// write condition is (FIFOL < 64)
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
			while(I2SStatus.FIFOL == 64);			
			
			//write sample
			smtI2SSetData(Sample);
		} 
		else
		{
			Sample	= ((ByteSampleR<<8)|ByteSampleL);
		}

		
	}			

	//
	//	16bits mode
	//

	// initialize
	SetI2SRXDefaultSetting();
	
	// set config
	smtGetI2SMode(I2S_DIR_TX, &I2SCtrl);
	I2SCtrl.WLen			= I2ST_BW_16BIT;		
	smtSetI2SMode(I2S_DIR_TX, I2SCtrl);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	
	// make and write sample
	for(tIdx = 0; tIdx < I2ST_SAMPLE_LEN; tIdx++)
	{
		// make sample
		ByteSampleL = (smtUint8)sin(tIdx);
		ByteSampleR = (smtUint8)sin(tIdx);
		
		Sample	|= ((ByteSampleR<<16)|ByteSampleL);
		
		// check FIFO status
		// write condition is (FIFOL < 64)
		smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
		while(I2SStatus.FIFOL == 64);			
		
		//write sample
		smtI2SSetData(Sample);		
		
	}			

	//
	//	24bits mode
	//

	// initialize
	SetI2SRXDefaultSetting();

	// set config
	smtGetI2SMode(I2S_DIR_TX, &I2SCtrl);
	I2SCtrl.WLen			= I2ST_BW_24BIT;		
	smtSetI2SMode(I2S_DIR_TX, I2SCtrl);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	// make and write sample
	for(tIdx = 0; tIdx < I2ST_SAMPLE_LEN; tIdx++)
	{
		
		// make sample
		ByteSampleL = (smtUint8)sin(tIdx);
		ByteSampleR = (smtUint8)sin(tIdx);
		
		// make Left channel
		Sample	= (ByteSampleL&0x00FFFFFF);
		
		// check FIFO status
		// write condition is (FIFOL < 64)
		smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
		while(I2SStatus.FIFOL == 64);			
		
		//write sample
		smtI2SSetData(Sample);		

		// make Right channel		
		Sample	= (ByteSampleR&0x00FFFFFF);

		// check FIFO status
		// write condition is (FIFOL < 64)
		smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
		while(I2SStatus.FIFOL == 64);			
		
		//write sample
		smtI2SSetData(Sample);		
		
	}	
	
	
	//
	//	32bits mode
	//

	// initialize
	SetI2SRXDefaultSetting();
	
	// set config
	smtGetI2SMode(I2S_DIR_TX, &I2SCtrl);
	I2SCtrl.WLen			= I2ST_BW_32BIT;		
	smtSetI2SMode(I2S_DIR_TX, I2SCtrl);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	// make and write sample
	for(tIdx = 0; tIdx < I2ST_SAMPLE_LEN; tIdx++)
	{
		// make sample
		ByteSampleL = (smtUint8)sin(tIdx);
		ByteSampleR = (smtUint8)sin(tIdx);
		
		// make Left channel
		Sample	= (ByteSampleL&0xFFFFFFFF);
		
		// check FIFO status
		// write condition is (FIFOL < 64)
		smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
		while(I2SStatus.FIFOL == 64);			
		
		//write sample
		smtI2SSetData(Sample);		

		// make Right channel		
		Sample	= (ByteSampleR&0xFFFFFFFF);

		// check FIFO status
		// write condition is (FIFOL < 64)
		smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
		while(I2SStatus.FIFOL == 64);			
		
		//write sample
		smtI2SSetData(Sample);		
		
	}		
}
/*----------------------------------------------------------
	Function name	: I2STestSampleRate
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void I2STestSampleRate(void)
{
	I2S_CLOCK_MODE	I2SClkMode;
	I2S_CONTROL		I2SCtrl;
	I2S_STATUS_DAT	I2SStatus;
	smtUint32		tIdx, sIdx;
	smtInt16		SampleL, SampleR;
	smtUint32		Sample;	
	
	//-------------------------------------------------------
	//	I2S TX test 3
	//	
	//	test sample rate test (44100/polling)
	//		- 11025
	//		- 22050
	//		- 44100
	//		- 48000
	//-------------------------------------------------------
	
	
	//
	//	11025 sample rate
	//

	// initialize
	smtI2SFIFOReset(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 0);
	
	// set clock mode
	smtGetClockMode(&I2SClkMode);
	I2SClkMode.DTORatio		= I2ST_DTO_11025;		
	smtSetClockMode(I2SClkMode);
	
	// set config
	smtGetI2SMode(I2S_DIR_TX, &I2SCtrl);
	I2SCtrl.DMAIntEn		= 0x0;
	I2SCtrl.FifoOURIntEn	= 0x0;
	smtSetI2SMode(I2S_DIR_TX, I2SCtrl);
	smtI2SEnable(I2S_DIR_TX, 1);
		
	// make and write sample
	for(tIdx = 0; tIdx < I2ST_SAMPLE_LEN; tIdx++)
	{
		// make sample
		SampleL = sin(tIdx);
		SampleR = sin(tIdx);
		Sample	= ((SampleR<<16)|SampleL);
	
		for(sIdx = 0; sIdx < 4; sIdx++) 
		{
			// check FIFO status
			// write condition is (FIFOL < 64)
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
			while(I2SStatus.FIFOL == 64);
			
			//write sample
			smtI2SSetData(Sample);
		}
		
	}	
			
	//
	//	11025 sample rate
	//

	// initialize
	smtI2SFIFOReset(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 0);
	
	// set clock mode
	smtGetClockMode(&I2SClkMode);
	I2SClkMode.DTORatio		= I2ST_DTO_11025;		
	smtSetClockMode(I2SClkMode);
	
	// set config
	smtGetI2SMode(I2S_DIR_TX, &I2SCtrl);
	I2SCtrl.DMAIntEn		= 0x0;
	I2SCtrl.FifoOURIntEn	= 0x0;
	smtSetI2SMode(I2S_DIR_TX, I2SCtrl);
	smtI2SEnable(I2S_DIR_TX, 1);
		
	// make and write sample
	for(tIdx = 0; tIdx < I2ST_SAMPLE_LEN; tIdx++)
	{
		// make sample
		SampleL = sin(tIdx);
		SampleR = sin(tIdx);
		Sample	= ((SampleR<<16)|SampleL);
	
		for(sIdx = 0; sIdx < 1; sIdx++) 
		{
			// check FIFO status
			// write condition is (FIFOL < 64)
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
			while(I2SStatus.FIFOL == 64);
			
			//write sample
			smtI2SSetData(Sample);
		}
		
	}	
	
	//
	//	22050 sample rate
	//

	// initialize
	smtI2SFIFOReset(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 0);
	
	// set clock mode
	smtGetClockMode(&I2SClkMode);
	I2SClkMode.DTORatio		= I2ST_DTO_22050;		
	smtSetClockMode(I2SClkMode);
	
	// set config
	smtGetI2SMode(I2S_DIR_TX, &I2SCtrl);
	I2SCtrl.DMAIntEn		= 0x0;
	I2SCtrl.FifoOURIntEn	= 0x0;
	smtSetI2SMode(I2S_DIR_TX, I2SCtrl);
	smtI2SEnable(I2S_DIR_TX, 1);
		
	// make and write sample
	for(tIdx = 0; tIdx < I2ST_SAMPLE_LEN; tIdx++)
	{
		// make sample
		SampleL = sin(tIdx);
		SampleR = sin(tIdx);
		Sample	= ((SampleR<<16)|SampleL);
	
		for(sIdx = 0; sIdx < 2; sIdx++) 
		{
			// check FIFO status
			// write condition is (FIFOL < 64)
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
			while(I2SStatus.FIFOL == 64);
			
			//write sample
			smtI2SSetData(Sample);
		}
		
	}	
	
	//
	//	44100 sample rate
	//

	// initialize
	smtI2SFIFOReset(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 0);
	
	
	// set clock mode
	smtGetClockMode(&I2SClkMode);
	I2SClkMode.DTORatio		= I2ST_DTO_44100;		
	smtSetClockMode(I2SClkMode);

	
	
	// set config
	smtGetI2SMode(I2S_DIR_TX, &I2SCtrl);
	I2SCtrl.DMAIntEn		= 0x0;
	I2SCtrl.FifoOURIntEn	= 0x0;
	smtSetI2SMode(I2S_DIR_TX, I2SCtrl);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	
	// make and write sample
	for(tIdx = 0; tIdx < I2ST_SAMPLE_LEN; tIdx++)
	{
		// make sample
		SampleL = sin(tIdx);
		SampleR = sin(tIdx);
		Sample	= ((SampleR<<16)|SampleL);
	
		for(sIdx = 0; sIdx < 4; sIdx++) 
		{
			// check FIFO status
			// write condition is (FIFOL < 64)
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
			while(I2SStatus.FIFOL == 64);
			
			//write sample
			smtI2SSetData(Sample);
		}
		
	}		
	
	//
	//	48000 sample rate
	//

	// initialize
	smtI2SFIFOReset(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 0);
	
	
	// set clock mode
	smtGetClockMode(&I2SClkMode);
	I2SClkMode.DTORatio		= I2ST_DTO_48000;		
	smtSetClockMode(I2SClkMode);

	
	
	// set config
	smtGetI2SMode(I2S_DIR_TX, &I2SCtrl);
	I2SCtrl.DMAIntEn		= 0x0;
	I2SCtrl.FifoOURIntEn	= 0x0;
	smtSetI2SMode(I2S_DIR_TX, I2SCtrl);
	smtI2SEnable(I2S_DIR_TX, 1);
	
	
	// make and write sample
	for(tIdx = 0; tIdx < I2ST_SAMPLE_LEN; tIdx++)
	{
		// make sample
		SampleL = sin(tIdx);
		SampleR = sin(tIdx);
		Sample	= ((SampleR<<16)|SampleL);
	
		for(sIdx = 0; sIdx < 4; sIdx++) 
		{
			// check FIFO status
			// write condition is (FIFOL < 64)
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);
			while(I2SStatus.FIFOL == 64);
			
			//write sample
			smtI2SSetData(Sample);
		}
		
	}				
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
	
	I2S_CLOCK_MODE	I2SClkMode;
	I2S_CONTROL		I2SCtrl;
	I2S_STATUS_DAT	I2SStatus;
	smtUint32		tIdx, sIdx;
	smtUint32		underRunTimeCnt;
	
	smtInt16		SampleL, SampleR;
	smtInt8			ByteSampleL, ByteSampleR;
	smtUint32		Sample;
	
	
	//-------------------------------------------------------
	//	I2S TX test 0
	//	
	//	test transmitt test (16/44100)
	//		- dma
	//		- polling
	//-------------------------------------------------------
	I2STestTransmit();
	
	//-------------------------------------------------------
	//	I2S TX test 1
	//	
	//	test event(underrun) test (16/44100/polling)
	//		- interrupt
	//		- polling
	//-------------------------------------------------------		
	I2STestEvent();
	
	//-------------------------------------------------------
	//	I2S TX test 2
	//	
	//	test bitwidth test (44100/polling)
	//		- 8bit
	//		- 16bit
	//		- 24bit
	//		- 32bit
	//-------------------------------------------------------
	I2STestBitWidth();
	
	//-------------------------------------------------------
	//	I2S TX test 3
	//	
	//	test sample rate test (44100/polling)
	//		- 11025
	//		- 22050
	//		- 44100
	//		- 48000
	//-------------------------------------------------------	
	I2STestSampleRate();

	
	
	return NO_ERROR;
}

