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

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/
#include <string.h>
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "dma.h"
#include "global.h" 
#include "irq.h"
#include "uart_post_drv.h"

/*
/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// 
*/

#define IMAGE_DNBASE_ADDR	(DDR_STARTADDR+0x500000)
#define DMA_TEST_SIZE		0x100000

/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

void DmaIRQHandler(unsigned irq);

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/

volatile smtUint8 *src_addr = (smtUint8 *)0x61000000;
volatile smtUint8 *dst_addr = (smtUint8 *)0x61200000;

#define MB 					(1024*1024)
#define EDMA_DESC_SZ		(4)
#define EDMA_M2M_SRC_ADDR	(0x63000000)
#define EDMA_M2M_DES_ADDR	(EDMA_M2M_SRC_ADDR+(4*MB))
#define DMA_DAT_LOOP_SIZE	(4)

// EDMA TEST CHANNEL
#define EDMA_TEST_CH 		(1)
#define EDMA_TEST_CH_IRQ	(IRQ_DMA1)

// EDMA TEST TIME OUT
#define EDMAT_TO_WAITINT	(0x7FFFF)
#define EDMAT_TO_STOP		(0x7FFFF)

// EDMA TEST ERROR CODE
#define	EDMAT_EC_NONE		(0 << 0)
#define	EDMAT_EC_NOINT		(1 << 0)
#define EDMAT_EC_DISABLE	(1 << 1)
#define EDMAT_EC_STOPINT	(1 << 2)

// EDMA TEST DEBUG PRINT
#define EDMADPRINTF	smt2UARTPrint

static smtUint32 descBuffer[DMA_DAT_LOOP_SIZE*EDMA_DESC_SZ];

static volatile smtBoolean gDmaStart	= 0;
static volatile smtBoolean gDmaEnd		= 0;
static volatile smtBoolean gDmaStop		= 0;
static volatile smtBoolean gDmaErr		= 0;

// GDMA TEST DEFINITION
#define GDMA_TEST_SRC_ADDR (0x63000000)
#define GDMA_TEST_DES_ADDR (GDMA_TEST_SRC_ADDR+(4*MB))

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: MakePattern
	Prototype		: static smtBoolean MakePattern(smtUint32 seed, smtUint32 buffer, smtUint32 size)
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static smtBoolean MakePattern(smtUint32 seed, smtUint32 buffer, smtUint32 size)
{
	smtUint32 	i;
	smtUint32	*pbuffer = (smtUint32*)buffer;
	
	
	for(i = 0; i < size/sizeof(int); i++)
	{
		pbuffer[i] = (seed | i);
	}	
	
	return 0;
}
/*----------------------------------------------------------
	Function name	: CheckPattern
	Prototype		: static smtBoolean CheckPattern(smtUint32 seed, smtUint32 buffer, smtUint32 size)
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static smtBoolean CheckPattern(smtUint32 seed, smtUint32 buffer, smtUint32 size)
{
	smtUint32 	i;
	smtUint32	pattern;
	smtUint32	*pbuffer = (smtUint32*)buffer;
	for(i = 0; i < size/4; i++)
	{
		
		pattern = (seed | i);
		if(pbuffer[i] != pattern)
		{
			EDMADPRINTF(CFG_UART_CH, "error 0x%08x[0x%08x]:0x%08x\n", 
				&pbuffer[i],pbuffer[i], pattern);
			return false;
		}
	}	
	
	return true;
}

/*----------------------------------------------------------
	Function name	: EDMAIntHandler()
	Prototype		: void EDMAIntHandler(smtUint32 irq)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void EDMAIntHandler(smtUint32 irq)
{
	smtUint32 dmaSts;
	
	smtEDMAGetStatus(EDMA_TEST_CH, &dmaSts);
	if(dmaSts & DMA_STARTINT_MASK)	//EDMA  start
	{
		gDmaStart = 1;
	}
	if(dmaSts & DMA_ENDINT_MASK)	//EDMA end
	{
		gDmaEnd = 1;
	}
	if(dmaSts & DMA_ERRORINT_MASK)	//EDMA error
	{
		gDmaErr = 1;
	}
	if(dmaSts & DMA_STOPINT_MASK)	//EDMA stop
	{
		smtEDMASetStatus(EDMA_TEST_CH,0xF);
		gDmaStop = 1;
		return;
	}
	smtEDMASetStatus(EDMA_TEST_CH, dmaSts|0xFUL);
}

/*----------------------------------------------------------
	Function name	: EDMADefaultConf()
	Prototype		: void EDMADefaultConf(EdmaStruct *edma)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void EDMADefaultConf(EdmaStruct *edma)
{
	edma->src			= EDMA_M2M_SRC_ADDR;
	edma->srcInc		= DMA_ADDR_INC;
	edma->srcWidth		= DMA_BUSWIDTH32;

	edma->dst			= EDMA_M2M_DES_ADDR;
	edma->dstInc 		= DMA_ADDR_INC;
	edma->dstWidth		= DMA_BUSWIDTH32;

	edma->startIntEn	= 0x0;
	edma->endIntEn		= 0x0;
	edma->stopIntEn		= 0x0;	

	edma->totSize		= 0xFFFFF;
	edma->transSize		= DMA_TRANSSIZE32;

	edma->enM2M			= 0x1;
	edma->descListBase	= 0x0UL;
}

/*----------------------------------------------------------
	Function name	: EDMAStartNoDescPolling()
	Prototype		: smtUint32 EDMAStartNoDescPolling(smtUint8 edmaCh, EdmaStruct edma)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 EDMAStartNoDescPolling(smtUint8 edmaCh, EdmaStruct edma)
{
	smtUint32 errCode = EDMAT_EC_NONE;
	smtUint32 timeOut, edmaSts;
	extern void DCacheFlushing(void);
	
	errCode = smt2DMADisable(EDMA_TEST_CH);
	
	if(errCode != EDMAT_EC_NONE)//Error of disabling EDMA 
		goto ERROR;

	//ARM data cache flusing
	DCacheFlushing();
	
	//start to EDMA without descriptor
	
	smtEDMANoDescrp(EDMA_TEST_CH, &edma);
	
	// polling EDMA stop status
	timeOut = 0;
	while(1)
	{
		smtEDMAGetStatus(EDMA_TEST_CH, &edmaSts);
		if(edmaSts & DMA_STOPINT_MASK)
		{
			errCode = smt2DMADisable(EDMA_TEST_CH);
			if(errCode != EDMAT_EC_NONE)
				goto ERROR;

			EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] polling catch EDMA stop status\n");
			break;
		}
		if(timeOut++ == EDMAT_TO_STOP)
		{
			errCode = EDMAT_EC_STOPINT;
			goto ERROR;
		}
	}

	return EDMAT_EC_NONE;
	
	ERROR:
	return errCode;
}

/*----------------------------------------------------------
	Function name	: EDMAStartNoDescInterrupt()
	Prototype		: smtUint32 EDMAStartNoDescInterrupt(smtUint8 edmaCh, EdmaStruct edma)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 EDMAStartNoDescInterrupt(smtUint8 edmaCh, EdmaStruct edma)
{
	smtUint32 errCode;
	smtUint32 timeOut;\
	extern void DCacheFlushing(void);

	//interrupt configuration
	timeOut		= 0;
	gDmaStart	= 0;
	gDmaEnd		= 0;
	gDmaStop	= 0;
	gDmaErr		= 0;
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(EDMA_TEST_CH_IRQ, EDMAIntHandler);
	Enable_IRQ();

	errCode = smt2DMADisable(EDMA_TEST_CH);

	if(errCode)//Error of disabling EDMA 
		goto ERROR;
	//ARM data cache flusing
	DCacheFlushing();

	//start to EDMA without descriptor
	EDMADefaultConf(&edma);
	edma.stopIntEn	= SMT_TRUE;
	edma.endIntEn	= SMT_TRUE;
	smtEDMANoDescrp(EDMA_TEST_CH, &edma);

	while(1)
	{
		if(gDmaStart)	//EDMA  start
		{
			EDMADPRINTF(CFG_UART_CH, "[EDMA TEST] Interrupt asserted	START\n");
			gDmaStart = 0;
			timeOut = 0;
		}
		if(gDmaEnd)	//EDMA end
		{
			EDMADPRINTF(CFG_UART_CH, "[EDMA TEST] Interrupt asserted	END\n");
			gDmaEnd = 0;
			timeOut = 0;
		}
		if(gDmaErr)	//EDMA error
		{
			EDMADPRINTF(CFG_UART_CH, "[EDMA TEST] Interrupt asserted	ERROR\n");
			gDmaErr = 0;
			timeOut = 0;
			break;
		}
		if(gDmaStop)	//EDMA stop
		{
			EDMADPRINTF(CFG_UART_CH, "[EDMA TEST] Interrupt asserted	STOP\n");
			gDmaStop = 0;
			timeOut = 0;
			break;
		}
		
		if(timeOut++ == EDMAT_TO_WAITINT)
		{
			errCode = EDMAT_EC_NOINT;
			goto ERROR;
		}
	}

	ReleaseIRQ(EDMA_TEST_CH_IRQ);
	return EDMAT_EC_NONE;

	ERROR:
	ReleaseIRQ(EDMA_TEST_CH_IRQ);
	return errCode;
}

/*----------------------------------------------------------
	Function name	: EDMAStartUseDescPolling()
	Prototype		: smtUint32 EDMAStartUseDescPolling(smtUint8 edmaCh, EdmaStruct edma0)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 EDMAStartUseDescPolling(smtUint8 edmaCh, EdmaStruct *edma)
{
	smtUint32 i;
	smtUint32 timeOut, errCode;
	
	smtUint32 edmaSts;
	extern void DCacheFlushing(void);
	//init descriptor 
	for(i=0;i<(DMA_DAT_LOOP_SIZE*4);i++)
	descBuffer[i] = 0;

	errCode = smt2DMADisable(EDMA_TEST_CH);
	if(errCode != EDMAT_EC_NONE)//Error of disabling EDMA 
	goto ERROR;

	DCacheFlushing();
	smtEDMAUseDescrp(edmaCh, DMA_DAT_LOOP_SIZE, edma);

	// polling EDMA stop status
	timeOut = 0;
	while(1)
	{
		smtEDMAGetStatus(EDMA_TEST_CH, &edmaSts);
		if(edmaSts & DMA_STOPINT_MASK)
		{
			errCode = smt2DMADisable(EDMA_TEST_CH);
			if(errCode != EDMAT_EC_NONE)
				goto ERROR;
			break;
		}
		if(timeOut++ == EDMAT_TO_STOP)
		{
			errCode = EDMAT_EC_STOPINT;
			goto ERROR;
		}
	}
	return EDMAT_EC_NONE;
	
	ERROR:
	return errCode;
}

/*----------------------------------------------------------
	Function name	: EDMAStartUseDescInterrupt()
	Prototype		: smtUint32 EDMAStartUseDescInterrupt(smtUint8 edmaCh, EdmaStruct edma0)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 EDMAStartUseDescInterrupt(smtUint8 edmaCh, EdmaStruct *edma)
{
	smtUint32 errCode,timeOut;
	smtUint32 i;
	extern void DCacheFlushing(void);
	
	//interrupt configuration
	timeOut		= 0;
	gDmaStart	= 0;
	gDmaEnd		= 0;
	gDmaStop	= 0;
	gDmaErr		= 0;
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(EDMA_TEST_CH_IRQ, EDMAIntHandler);
	Enable_IRQ();

	//init descriptor 
	for(i=0;i<(DMA_DAT_LOOP_SIZE*4);i++)
		descBuffer[i] = 0;


	// disable
	errCode = smt2DMADisable(EDMA_TEST_CH);
	if(errCode != EDMAT_EC_NONE)//Error of disabling EDMA 
		goto ERROR;
	
	DCacheFlushing();
	smtEDMAUseDescrp(edmaCh, DMA_DAT_LOOP_SIZE, edma);
	
	while(1)
	{
		if(gDmaStart)	//EDMA  start
		{
			EDMADPRINTF(CFG_UART_CH, "[EDMA TEST] Interrupt asserted	START\n");
			gDmaStart = 0;
			timeOut = 0;
		}
		if(gDmaEnd)		//EDMA end
		{
			EDMADPRINTF(CFG_UART_CH, "[EDMA TEST] Interrupt asserted	END\n");
			gDmaEnd = 0;
			timeOut = 0;
		}
		if(gDmaErr)		//EDMA error
		{
			EDMADPRINTF(CFG_UART_CH, "[EDMA TEST] Interrupt asserted	ERROR\n");
			gDmaErr = 0;
			timeOut = 0;
			break;
		}
		if(gDmaStop)	//EDMA stop
		{
			EDMADPRINTF(CFG_UART_CH, "[EDMA TEST] Interrupt asserted	STOP\n");
			gDmaStop = 0;
			timeOut = 0;
			break;
		}
		
		if(timeOut++ == EDMAT_TO_WAITINT)
		{
			errCode = EDMAT_EC_NOINT;
			goto ERROR;
		}
	}


	ReleaseIRQ(EDMA_TEST_CH_IRQ);
	return EDMAT_EC_NONE;
	
	ERROR:
		ReleaseIRQ(EDMA_TEST_CH_IRQ);
		return errCode;
}

/*----------------------------------------------------------
	Function name	: EDMAM2MNoDescTest()
	Prototype		: smtUint32 EDMAM2MNoDescTest(void)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 EDMAM2MNoDescTest(void)
{
	smtUint32 ret;
	EdmaStruct edma;
	smtUint32 seed = 0xAAAA0000;
	
	memset((void*)EDMA_M2M_SRC_ADDR,0x0, 4*MB);
	memset((void*)EDMA_M2M_DES_ADDR,0x0 ,4*MB);

	//--------------------------------------------------------------------------
	// EDMA TEST 1. M2M WITHOUT DESCRIPTOR POLLING
	//--------------------------------------------------------------------------
	EDMADPRINTF(CFG_UART_CH,"==============================================================\n");
	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] no descriptor polling test\n");
	EDMADPRINTF(CFG_UART_CH,"==============================================================\n");
	
	//Make pattern
	MakePattern(seed, (smtUint32)EDMA_M2M_SRC_ADDR,(1*MB)-1);
	EDMADefaultConf(&edma);

	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] SRC  ADDR[0x%08x] BUSWIDTH[%d] ADDRINC[0x%01x]\n",
					edma.src,edma.srcWidth,edma.srcInc);
	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] DEST ADDR[0x%08x] BUSWIDTH[%d] ADDRINC[0x%01x]\n",
					edma.dst,edma.dstWidth,edma.dstInc);
	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] BURST SIZE[0x%01x] TOTOAL SIZE[0x%05x]\n",
					edma.transSize,edma.totSize);
		
	ret = EDMAStartNoDescPolling(EDMA_TEST_CH, edma);
	if(ret)
	{
		EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] EDMAStartNoDescPolling ERRORCODE=[0x%08x] \n",ret);
		return SMT_ERROR;
	}
	
	//check pattern
	if(!CheckPattern(seed, (smtUint32)EDMA_M2M_DES_ADDR, (1*MB)-1))
		return SMT_ERROR;
		
	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] pattern check ok\n");	
	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] no descriptor polling test--------------[PASS]\n");
	

	//--------------------------------------------------------------------------
	// EDMA TEST 1. M2M WITHOUT DESCRIPTOR INTERRUPT
	//--------------------------------------------------------------------------

	EDMADPRINTF(CFG_UART_CH,"==============================================================\n");
	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] no descriptor interrupt test\n");
	EDMADPRINTF(CFG_UART_CH,"==============================================================\n");

	memset((void*)EDMA_M2M_SRC_ADDR,0xFF,4*MB);
	memset((void*)EDMA_M2M_DES_ADDR,0x0 ,4*MB);

	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] SRC  ADDR[0x%08x] BUSWIDTH[%d] ADDRINC[0x%01x]\n",
					edma.src,edma.srcWidth,edma.srcInc);
	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] DEST ADDR[0x%08x] BUSWIDTH[%d] ADDRINC[0x%01x]\n",
					edma.dst,edma.dstWidth,edma.dstInc);
	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] BURST SIZE[0x%01x] TOTOAL SIZE[0x%05x]\n",
					edma.transSize,edma.totSize);
	//Make pattern
	MakePattern(seed, (smtUint32)EDMA_M2M_SRC_ADDR,(1*MB)-1);

	ret = EDMAStartNoDescInterrupt(EDMA_TEST_CH, edma);
	if(ret)
	{
		EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] EDMAStartNoDescInterrupt ERRORCODE=[0x%08x] \n",ret);
		return SMT_ERROR;
	}

	if(!CheckPattern(seed, (smtUint32)EDMA_M2M_DES_ADDR, (1*MB)-1))
		return SMT_ERROR;

	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] pattern check ok\n");	
	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] no descriptor interrupt test------------[PASS]\n");

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: EDMAM2MUseDescTest()
	Prototype		: smtUint32 EDMAM2MUseDescTest(void)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 EDMAM2MUseDescTest(void)
{
	smtUint32 ret,i;
	smtUint32 seed = 0xAAAA0000;
	EdmaStruct edma[DMA_DAT_LOOP_SIZE];
	memset((void*)EDMA_M2M_SRC_ADDR,0x0 ,4*MB);
	memset((void*)EDMA_M2M_DES_ADDR,0x0 ,4*MB);

	//--------------------------------------------------------------------------
	// EDMA TEST 2 : M2M USING DESCRIPTOR POLLING
	//--------------------------------------------------------------------------
	
	EDMADPRINTF(CFG_UART_CH,"==============================================================\n");
	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] using descriptor polling test\n");
	EDMADPRINTF(CFG_UART_CH,"==============================================================\n");

	// make pattern 
	MakePattern(seed, EDMA_M2M_SRC_ADDR, 512*1024*(DMA_DAT_LOOP_SIZE));

	
	// Transfer Data : 512K * 4
	for(i = 0; i < DMA_DAT_LOOP_SIZE; i++)	
	{
		EDMADefaultConf(&edma[i]);
		edma[i].totSize			= 0x80000; // 512K	
		edma[i].src				= EDMA_M2M_SRC_ADDR+(i*512*1024);
		edma[i].dst 			= EDMA_M2M_DES_ADDR+(i*512*1024);
		edma[i].descListBase	= (smtUint32)descBuffer;

		EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] --------------DESCRIPTER #%d------------------\n",i);
		EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] SRC  ADDR[0x%08x] BUSWIDTH[%d] ADDRINC[0x%01x]\n",
						edma[i].src,edma[i].srcWidth,edma[i].srcInc);
		EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] DEST ADDR[0x%08x] BUSWIDTH[%d] ADDRINC[0x%01x]\n",
						edma[i].dst,edma[i].dstWidth,edma[i].dstInc);
		EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] BURST SIZE[0x%01x] TOTOAL SIZE[0x%05x]\n",
						edma[i].transSize,edma[i].totSize);

	}

	ret = EDMAStartUseDescPolling(EDMA_TEST_CH, edma);

	if(ret)
	{
		EDMADPRINTF(CFG_UART_CH,"\n[EDMA TEST] EDMAStartUseDescPolling ERRCODE = [0x%08x]",ret);
		return SMT_ERROR;
	}

	//check pattern
	if(!CheckPattern(seed,EDMA_M2M_DES_ADDR, 512*1024*(DMA_DAT_LOOP_SIZE)))
		return SMT_ERROR;

	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] pattern check ok\n");
	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] using descriptor polling test-----------[PASS]\n");

	//--------------------------------------------------------------------------
	// EDMA TEST 2 : M2M USING DESCRIPTOR INTERRUPT
	//--------------------------------------------------------------------------

	EDMADPRINTF(CFG_UART_CH,"==============================================================\n");
	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] using descriptor interrupt test\n");
	EDMADPRINTF(CFG_UART_CH,"==============================================================\n");

	// make pattern 
	MakePattern(seed, EDMA_M2M_SRC_ADDR, 512*1024*(DMA_DAT_LOOP_SIZE));
	
	// Transfer Data : 512K * 4
	for(i = 0; i < DMA_DAT_LOOP_SIZE; i++)	
	{
		EDMADefaultConf(&edma[i]);
		edma[i].totSize		= 0x80000; // 512K	
		edma[i].src			= EDMA_M2M_SRC_ADDR+(i*512*1024);
		edma[i].dst 		= EDMA_M2M_DES_ADDR+(i*512*1024);

		edma[i].startIntEn 	= 0x1;
		edma[i].endIntEn 	= 0x1;
		edma[i].stopIntEn 	= 0x1;	

		edma[i].descListBase = (smtUint32)descBuffer;
		
		EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] --------------DESCRIPTER #%d------------------\n",i);
		EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] SRC  ADDR[0x%08x] BUSWIDTH[%d] ADDRINC[0x%01x]\n",
						edma[i].src,edma[i].srcWidth,edma[i].srcInc);
		EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] DEST ADDR[0x%08x] BUSWIDTH[%d] ADDRINC[0x%01x]\n",
						edma[i].dst,edma[i].dstWidth,edma[i].dstInc);
		EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] BURST SIZE[0x%01x] TOTOAL SIZE[0x%05x]\n",
						edma[i].transSize,edma[i].totSize);
	}
	
	ret = EDMAStartUseDescInterrupt(EDMA_TEST_CH, edma);
	if(ret)
	{
		EDMADPRINTF(CFG_UART_CH,"\n[EDMA TEST] EDMAStartUseDescInterrupt ERRCODE = [0x%08x]",ret);
		return SMT_ERROR;
	}

	//check pattern
	if(!CheckPattern(seed,EDMA_M2M_DES_ADDR, 512*1024*(DMA_DAT_LOOP_SIZE)))
		return SMT_ERROR;
	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] pattern check ok\n");
	EDMADPRINTF(CFG_UART_CH,"[EDMA TEST] using descriptor interrupt test---------[PASS]\n");
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: GDMATest()
	Prototype		: smtUint32 GDMATest(void)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 GDMATest(void)
{
	smtUint32 seed = 0xAAAA0000;
	GdmaStruct gdma;
	
	smtUint32 errCode;

	EDMADPRINTF(CFG_UART_CH,"==============================================================\n");
	EDMADPRINTF(CFG_UART_CH,"[GDMA TEST] GDMA MEMCPY Polling test\n");
	EDMADPRINTF(CFG_UART_CH,"==============================================================\n");

	// set gdma configuartion struct
	gdma.src = (smtUint32)EDMA_M2M_SRC_ADDR;
	gdma.sWidth		= 720;
	gdma.sHeight	= 480;

	gdma.sClipX		= 0;
	gdma.sClipY		= 0;
	

	gdma.dst		= (smtUint32)EDMA_M2M_DES_ADDR;
	gdma.dWidth		= 720;
	gdma.dHeight	= 480;

	gdma.dClipX		= 0;
	gdma.dClipY		= 0;

	gdma.clipWidth	= 720;
	gdma.clipHeight	= 480;
	
	gdma.bpp		= 2;

	gdma.intFunction = 0x0;

	EDMADPRINTF(CFG_UART_CH,"[GDMA TEST] SRC_ADDR[0x%08x] SRC_SIZE[%d*%d] CLIP[%d,%d] \n"
				,gdma.src,gdma.sWidth,gdma.sHeight, gdma.sClipX,gdma.sClipY);
	EDMADPRINTF(CFG_UART_CH,"[GDMA TEST] DES_ADDR[0x%08x] DES_SIZE[%d*%d] CLIP[%d,%d] \n"
				,gdma.dst,gdma.dWidth,gdma.dHeight, gdma.dClipX,gdma.dClipY);
	EDMADPRINTF(CFG_UART_CH,"[GDMA TEST] CLIP SIZE[%d*%d] \n"
				,gdma.clipWidth ,gdma.clipHeight);


	// make pattern for src data
	MakePattern(seed, (smtUint32)EDMA_M2M_SRC_ADDR, 720*480*2);

	// enable GDMA
	errCode = smt2GDMACopy(&gdma, SMT_TRUE);	//polling

	// check pattern of dest after GDMA stopped
	if(!CheckPattern(seed,(smtUint32)EDMA_M2M_DES_ADDR, 720*480*2))
		return SMT_ERROR;
	
	EDMADPRINTF(CFG_UART_CH,"[GDMA TEST] pattern check ok\n");
	EDMADPRINTF(CFG_UART_CH,"[GDMA TEST] GDMA MEMCPY Polling test----------------[PASS]\n");

	EDMADPRINTF(CFG_UART_CH,"==============================================================\n");
	EDMADPRINTF(CFG_UART_CH,"[GDMA TEST] GDMA MEMCPY Interrupt test\n");
	EDMADPRINTF(CFG_UART_CH,"==============================================================\n");

	memset((void*)EDMA_M2M_SRC_ADDR,0x0,(4*MB));
	memset((void*)EDMA_M2M_DES_ADDR,0x0,(4*MB));

	// set gdma configuartion struct
	gdma.intFunction = DmaIRQHandler;//register interrupt handler

	EDMADPRINTF(CFG_UART_CH,"[GDMA TEST] SRC_ADDR[0x%08x] SRC_SIZE[%d*%d] CLIP[%d,%d] \n"
				,gdma.src,gdma.sWidth,gdma.sHeight, gdma.sClipX,gdma.sClipY);
	EDMADPRINTF(CFG_UART_CH,"[GDMA TEST] DES_ADDR[0x%08x] DES_SIZE[%d*%d] CLIP[%d,%d] \n"
				,gdma.dst,gdma.dWidth,gdma.dHeight, gdma.dClipX,gdma.dClipY);
	EDMADPRINTF(CFG_UART_CH,"[GDMA TEST] CLIP SIZE[%d*%d] \n"
				,gdma.clipWidth ,gdma.clipHeight);
	
	// make pattern for src data
	MakePattern(seed, (smtUint32)EDMA_M2M_SRC_ADDR, 720*480*2);

	// enable GDMA
	errCode = smt2GDMACopy(&gdma, SMT_FALSE);	//interrupt

	// check pattern of dest after GDMA stopped
	if(!CheckPattern(seed,(smtUint32)EDMA_M2M_DES_ADDR, 720*480*2))
		return SMT_ERROR;
	
	EDMADPRINTF(CFG_UART_CH,"[GDMA TEST] pattern check ok\n");
	EDMADPRINTF(CFG_UART_CH,"[GDMA TEST] GDMA MEMCPY Interrupt test--------------[PASS]\n");

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: DMATest()
	Prototype		: smtUint32 DMATest(void)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 DMATest(void)
{
	smtUint32 ret = 0 ;
	// 1. EDMA M2M TEST(no using descriptor)
	ret = EDMAM2MNoDescTest();
	if(ret != SMT_SUCCESS)
	{
		EDMADPRINTF(CFG_UART_CH,"EDMAM2M No Descriptor test failed!!\n");
		return ret;
	}
	
	// 2. EDMA M2M TEST(using descriptor)
	ret = EDMAM2MUseDescTest();
	if(ret != SMT_SUCCESS)
	{
		EDMADPRINTF(CFG_UART_CH,"EDMAM2M Using Descriptor test failed!!\n");
		return ret;
	}
	
	// 3. GDMA TEST
	ret = GDMATest();
	if(ret != SMT_SUCCESS)
	{
		EDMADPRINTF(CFG_UART_CH,"EDMAM2M GDMA test failed!!\n");
		return ret;
	}
	return SMT_SUCCESS;
}

