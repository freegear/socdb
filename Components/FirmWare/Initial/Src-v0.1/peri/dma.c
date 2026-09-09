/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: dma.c 
	Description	: DMA test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
//#include "irq.h"
#include "dma.h"
#include "global.h" 


/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define TEST_DMA_INT			1

#define SOUND_SIZE_RANGE		0x8000	// 32KB
#define DMA_INT_NUM			0x0


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
smtUint32 DMATest(void);
smtUint32 DMAMemToIO(void);
smtUint32 DMAIOToMem(void);
smtUint32 DMAMemToMem(smtUint8 channel, smtUint32 *src, smtUint32 *dst, smtUint32 size);
smtUint32 DMA2DMemToMem(smtUint32 *src, smtUint32 *dst, smtUint16 lineSize, smtUint32 totalSize);

smtUint32 DMAToAudio(smtUint32 ppcm, smtUint32 size);
smtUint32 DMAToStorage(smtUint32 blkAddr, smtUint32 srcAddr)	;
smtUint32 DMAFromStorage(smtUint32 blkAddr, smtUint32 tgtAddr);

static void ISRDMA(smtUint32 irq);


/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */



/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	Function name	: DMATest()
	Prototype		: smtUint32 DMATest(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 DMATest(void)
{
	smtUint32 errCode;

	// TEST1 : Register R/W
	(smtBoolean)errCode = RegisterDMA();

	if (errCode != SMT_SUCCESS)
		return SMT_ERROR;

	// TEST2 : Memory to I/O
	errCode = DMAMemToIO();
	if (errCode != SMT_SUCCESS)
		return SMT_ERROR;

	// TEST3 : I/O to Memory
	errCode = DMAIOToMem();
	if (errCode != SMT_SUCCESS)
		return SMT_ERROR;

	// TEST4 : Memoryr to Memory
	errCode = DMAMemToMem(0, 0x0, 0x0, 1024);
	if (errCode != SMT_SUCCESS)
		return SMT_ERROR;

	// TEST5 : 2D DMA register R/W
	(smtBoolean)errCode = Register2DDMA();

	// TEST6 : 2D DMA memory to memory
	errCode = DMA2DMemToMem(0x0, 0x0, 0x0, 0x0);
	if (errCode != SMT_SUCCESS)
		return SMT_ERROR;

	// TEST7 : Interrupt test
	// Interupt test is included in TEST2

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: DMAMemToIO()
	Prototype		: smtUint32 DMAMemToIO(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 DMAMemToIO(void)
{
	smtUint32 returnErr;

	smtUint32 ppcm, size;

	// 1. Memory to audio
	returnErr = DMAToAudio(ppcm, size);

	if (returnErr != SMT_SUCCESS)
		return returnErr;
	// 2. Memory to storage
	returnErr = DMAToStorage(ppcm, size);

	if (returnErr != SMT_SUCCESS)
		return returnErr;

	return SMT_SUCCESS;	
}

/*----------------------------------------------------------
	Function name	: DMAIOToMem()
	Prototype		: smtUint32 DMAIOToMem(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 DMAIOToMem(void)
{
	smtUint32 returnErr;
	smtUint32 blkAddr, targetAddr;

	// 1. Storage to memory
	returnErr = DMAFromStorage(blkAddr, targetAddr);

	if (returnErr != SMT_SUCCESS)
		return returnErr;

	return SMT_SUCCESS;	
}

/*----------------------------------------------------------
	Function name	: DMAMemToMem()
	Prototype		: smtUint32 DMAMemToMem(smtUint8 channel, smtUint32 *src, smtUint32 *dst, smtUint32 size)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 DMAMemToMem(smtUint8 channel, smtUint32 *src, smtUint32 *dst, smtUint32 size)
{
	smtUint32 i, data1, data2;

	//smt2DMAMemToMemCopy(channel, * dest, *src, nbytes);
	smt2DMAMemToMemCopy(channel,  dst,  src, size);	// Max size is 65532 currently in the MemToMem function.

	for (i=0; i<(size/4); i++)
	{
		data1 = *src++;
		data2 = *dst++;

		if (data1 != data2)
			return SMT_ERROR;
	}

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: DMA2DMemToMem()
	Prototype		: smtUint32 DMA2DMemToMem(smtUint8 channel, smtUint32 *src, smtUint32 *dst, smtUint32 size)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 DMA2DMemToMem(smtUint32 *src, smtUint32 *dst, smtUint16 lineSize, smtUint32 totalSize)
{
	smtUint32 i, data1, data2;
	smtUint32 lineNum;
	DMA2D_STRUCT dma2D;

	dma2D.src = (smtUint32)&src;
	dma2D.dst = (smtUint32)&dst;
	dma2D.count = lineSize;
	lineNum = totalSize/lineSize;
	dma2D.bytePerLine = (lineNum << SHIFT_DN_FROM_MASK(DMA2D_UPPER_MASK)) | lineSize;
	dma2D.srcIncSize = lineSize;
	dma2D.dstIncSize = lineSize;

	smt2DMA2DMemToMemCopy(dma2D);

	for (i=0; i<(totalSize/4); i++)
	{
		data1 = *src++;
		data2 = *dst++;

		if (data1 != data2)
			return SMT_ERROR;
	}

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: DMAToAudio()
	Prototype		: smtUint32 DMAToAudio(smtUint32 ppcm, smtUint32 size)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 DMAToAudio(smtUint32 ppcm, smtUint32 size)
{
	static DMA_STRUCT dma_desc_loop[500];
	static DMA_STRUCT start_dma_desc;

	smtInt32 i;

#ifdef TEST_DMA_INT
	RequestIRQ(DMA_INT_NUM, ISRDMA);	// Regist DMA interrupt
#endif

	for(i = 0; i < size/SOUND_SIZE_RANGE; i++)	// 1 MB sound data = 32 x 32KB, 32KB -> 0x8000
	{
		dma_desc_loop[i].srcAddr 	=  	(ppcm + (i*SOUND_SIZE_RANGE));	// (unsigned)&sounddata[i*0x8000/4];
		dma_desc_loop[i].dstAddr 	= 	APB1_STARTADDR+0x7000+0x0C;	//  Audio output addr
		//dma_desc_loop[i].control 	= 	0x06258000|(1<<30);	// Control register
		dma_desc_loop[i].control =
			(0x1 << SHIFT_DN_FROM_MASK(DMA_SRCINCR_MASK) ) |
			(0x2 << SHIFT_DN_FROM_MASK(DMA_SRCWIDTH_MASK) ) |
			(0x2 << SHIFT_DN_FROM_MASK(DMA_DSTWIDTH_MASK) ) |
			(0x5 << SHIFT_DN_FROM_MASK(DMA_SIZE_MASK) ) |
			(0x8000) |		// Transfer length
	#ifdef TEST_DMA_INT
			(0x1 << SHIFT_DN_FROM_MASK(DMA_STARTINTEN_MASK) ) |	// start interrupt enable
			(0x1 << SHIFT_DN_FROM_MASK(DMA_ENDINTEN_MASK) );

		// Status register - DMA stop interrupt enable
		SMT_WRITE(DMACSta(1), (0x1 << SHIFT_DN_FROM_MASK(DMA_STOPINTEN_MASK)) );
	#else
			(0x1 << SHIFT_DN_FROM_MASK(DMA_ENDINTEN_MASK) );
	#endif
		
		if (i != (size/SOUND_SIZE_RANGE)-1)
		{
			dma_desc_loop[i].descAddr = (smtUint32)&dma_desc_loop[i+1];
		}
	}

	dma_desc_loop[(size/SOUND_SIZE_RANGE)-1].descAddr = 1;

	// Use DMA descriptor
	smtDMACUseDescrp(1, (smtUint32)(&dma_desc_loop[0]));	
	
	// wait DMA end (Descriptor end flag : [0]bit)
	while(1) 
	{
		if(SMT_READ(DMACDescrp(1)) & 0x1)
		{
			break;
		}
	}	

#ifdef TEST_DMA_INT
	ReleaseIRQ(DMA_INT_NUM);
#endif

	smtDMACDisable(1);

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: DMAToStorage()
	Prototype		: smtUint32 DMAToStorage(smtUint32 blkAddr, smtUint32 srcAddr)	
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 DMAToStorage(smtUint32 blkAddr, smtUint32 srcAddr)	
{
	// Refer to Demo F/W apimmc.c(SDMMCWriteDMAtest())

	// Memory is SRAM, target device is NAND or SD/MMC
	// Edit memory setting
	// Need to NAND or SDMMC setting

	// Q&A :
	// Memory/target device address range???
	// Use descriptor or non-descriptor???

	// DMA non descriptor
	smtDMACNoDescrp(
		0,							// [CH ]: Using DMA channel
		(smtUint32) srcAddr,			// [SRC]: Source address
		0,							// [SRC]: Non increament
		2,							// [SRC]: Word data width 
		//(MMC_BASEADDR+0x44),		// [TRG]: Target address
		FLASH_BASE_ADDR,
		1,							// [TRG]: auto increamnet
		2,							// [TRG]: Word data width
		5,							// [BS ]: Burst size
		512							// [LEN]: Total transfered size
	);
	
	// wait DMA end
	while(1) 
	{
		if(SMT_READ(DMACSta(0)) & 0x08) 
		{
			break;
		}
	}

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: DMAFromStorage()
	Prototype		: smtUint32 DMAFromStorage(smtUint32 blkAddr, smtUint32 tgtAddr)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 DMAFromStorage(smtUint32 blkAddr, smtUint32 tgtAddr)
{
	// Refer to Demo F/W apimmc.c(SDMMCReadDMAtest())

	// Memory is SRAM, source device is NAND or SD/MMC
	// Edit memory setting
	// Need to NAND or SDMMC setting

	// Q&A :
	// Memory/source device address range???
	// Use descriptor or non-descriptor???

	//	
	// DMA non descriptor
	//
	smtDMACNoDescrp(
		0, 							// [CH ]: Using DMA channel
		//(MMC_BASEADDR+0x44), 	// [SRC]: Source address
		FLASH_BASE_ADDR,
		0,							// [SRC]: Non increament
		2,							// [SRC]: Word data width 
		(smtUint32) tgtAddr,			// [TRG]: Target address
		1,							// [TRG]: auto increamnet
		2,							// [TRG]: Word data width
		5,							// [BS ]: Burst size
		512							// [LEN]: Total transfered size
	);
	
	// wait DMA end
	while(1) 
	{
		if(SMT_READ(DMACSta(0))&0x08) 
		{
			break;
		}
	}

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: ISRDMA()
	Prototype		: static void ISRDMA(smtUint32 irq)
	Return		:
	Argument	:
	Comments	:
		WDT interrupt handler
----------------------------------------------------------*/
static void ISRDMA(smtUint32 irq)
{
	AckIRQ(irq);	// WDT interrupt clear
}

