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
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq.h"
#include "global.h"
#include "display_test_utils.h"
#include "uart_post_drv.h"
#include "lcd_pre_drv.h"
#include "videoenc_post_drv.h"
#include "videoenc_pre_drv.h"
#include "dma_mux.h"

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
//#define __DM_PALETTE_TEST__
//#define __OVERLAY_VIDEO_IN__
#define STRESS_DMA_M2M_CH 7
#define CURSOR_PALETTE_ALPHA 	(0xFFUL)
#define GRAPHIC_PALETTE_ALPHA 	(0xFFUL)

#define BLACK				0xff000000
#define RED					0xffff0000
#define GREEN				0xff00ff00
#define YELLOW				0xffffff00
#define BLUE				0xff0000ff
#define CYAN				0xffff00ff
#define MAGENTA				0xff00ffff
#define WHITE				0xffffffff

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

static smtUint32 StressDMOverlay(void);


#ifdef __DM_PALETTE_TEST__
static smtUint32 CGVPaletteOverlay(void);
static void ISRCGVPaletteOverlay(smtUint32 irq);
static smtUint32 DMPaletteDisplay(void);
static void DisplayCursorPalette(void);
static void DisplayGraphicPalette(void);
#else
static smtUint32 CGVOverlay(void);
static void ISRCGVOverlay(smtUint32 irq);
#endif

static smtUint32 StressSEIPRecord(void);
static void ISRStressSEIPTest(smtUint32 irq);
static void ISRStressSEIPTest(smtUint32 irq);
extern void SEIP_DMA_TX_Enable(void);


static smtUint32 StressDMAM2M(void);
static void ISRStressDMAM2M(smtUint32 irq);
extern void InitSEIP(void);

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
extern unsigned short 	cursor_buffer[];
extern unsigned char	graphic_buffer[];
extern unsigned short	video_buffer[];
static smtUint32 descBuffer[4];
static smtUint32 descBufferM2M[4];
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
static smtUint32 palColorTbl[8]=
{
	BLACK,
	BLUE,
	GREEN,
	CYAN,
	RED,
	MAGENTA,
	YELLOW,
	WHITE,
};

static smtUint32 stress_test[100];
static EdmaChannel rec_rx_dmach;
static volatile smtUint32 REC_InterruptFlag  = 0;
static volatile smtUint32 REC_InterruptValue = 0;

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/
/*----------------------------------------------------------
	Function name	: StressTest()
	Prototype		: smtUint32 StressTest(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 StressTest(void)
{
	smtUint32 i=0;
	smtUint8 uartInput;
	smtUint32 errCode;

	errCode = StressDMOverlay();					//1. DM enable through Palette Mode
	if(errCode != SMT_SUCCESS)
		goto ERROR;

	errCode = StressSEIPRecord();					//2. SEIP infinite EDMA loop
	if(errCode != SMT_SUCCESS)
		goto ERROR;

	errCode = StressDMAM2M();						//3. EDMA M2M infinite loop
	if(errCode != SMT_SUCCESS)
		goto ERROR;

	while(1)										//4. ARM Write
	{
		for(i = 0 ; i < 100 ; i++)
			stress_test[i] = i ;
		smt2UARTDataValid(CFG_UART_CH, &uartInput);
		if(uartInput)
		{
			smt2UARTGetCh(CFG_UART_CH,&uartInput,0);
			if(uartInput == '0')
				break;
		}
	}
	DMDisable(0xF);
	DMVEncDisable();
	smt2DMADisable(rec_rx_dmach);
	smt2DMADisable(STRESS_DMA_M2M_CH);
	smt2UARTPrint(CFG_UART_CH,"stress test completed!!\n");
	return SMT_SUCCESS;
ERROR:

	DMDisable(0xF);
	DMVEncDisable();
	smt2DMADisable(rec_rx_dmach);
	smt2DMADisable(STRESS_DMA_M2M_CH);
	smt2UARTPrint(CFG_UART_CH,"stress test failed[0x%08x]!!\n",errCode);
	return SMT_ERROR;
}

/*----------------------------------------------------------
	Function name	: StressDMOverlay()
	Prototype		: smtUint32 StressDMOverlay(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static smtUint32 StressDMOverlay(void)
{
	smtUint32 errCode = SMT_SUCCESS;

	DMVEncEnable();
	DMEnable();
	DMSyncEnable();
	#ifdef __DM_PALETTE_TEST__
	errCode = CGVPaletteOverlay();
	#else
	errCode = CGVOverlay();
	#endif
	
	return errCode;
}

/*----------------------------------------------------------
	Function name	: CGVPaletteOverlay()
	Prototype		: smtUint32 CGVPaletteOverlay(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
#ifdef __DM_PALETTE_TEST__
static smtUint32 CGVPaletteOverlay(void)
{
	DMPlaneBlndMode gBlendMode,cBlendMode;
	smtUint32 i;
	smtUint16 *vFrame0 = (smtUint16 *)VIDEO_BASEADDR;

	// copy video image to DDR
	for(i = 0; i < (VIDEO_HEIGHT*2)*VIDEO_WIDTH; i++)
		*(vFrame0+i) = video_buffer[i];	
	
	DMPaletteDisplay();

	DMVideoOn((smtUint32) vFrame0, VIDEO_WIDTH >> 1, 0x3);

	RequestIRQ(IRQ_DM,ISRCGVPaletteOverlay);

	memset((void*)&cBlendMode,0x0,sizeof(cBlendMode));
	memset((void*)&gBlendMode,0x0,sizeof(gBlendMode));
	
	cBlendMode.blendMod = 0x2;
	gBlendMode.blendMod = 0x2;
	
	smtDMSetCBlndMode(&cBlendMode);
	smtDMSetGBlndMode(&gBlendMode);
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: ISRCGVPaletteOverlay()
	Prototype		: void ISRCGVPaletteOverlay(smtUint32 irq)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
void ISRCGVPaletteOverlay(smtUint32 irq)
{
	DMStatus dmSts;
	DMPlaneBlnd gPlaneBlnd,cPlaneBlnd;
	static smtUint8 cAlpha =0,gAlpha =0;
	smtDMGetMasterStatus(&dmSts);
	//smt2UARTPrint(CFG_UART_CH,"ISR DM Stress!!!\n");
	
	if(dmSts.mixFifoErr == 1)
	{
		smt2UARTPrint(CFG_UART_CH,"Mixer FIFO Error \n");
	}
	if(dmSts.vDmaFifoErr == 1)
	{
		smt2UARTPrint(CFG_UART_CH,"Video DMA FIFO Error \n");
	}
	if(dmSts.vFifoErr == 1)
	{
		smt2UARTPrint(CFG_UART_CH,"Video FIFO Error \n");
	}
	if(dmSts.startFrame == 1)
	{
		if(dmSts.evenFieldInt == 1)
		{
			//smtDMSetCAddr((smtUint32)CURSOR_BASEADDR+(CURSOR_WIDTH*2));
			//smtDMSetGAddr((smtUint32)(GRAPHIC_BASEADDR+(GRAPHIC_WIDTH*4)));
			smtDMSetVAddr((smtUint32)(VIDEO_BASEADDR+(VIDEO_WIDTH*2)));
		}
		else
		{
			//smtDMSetCAddr((smtUint32)CURSOR_BASEADDR);
			//smtDMSetGAddr((smtUint32)GRAPHIC_BASEADDR);
			smtDMSetVAddr((smtUint32)VIDEO_BASEADDR);
			cPlaneBlnd.alpha = cAlpha++;
			gPlaneBlnd.alpha = gAlpha++;
			
			smtDMSetCBlnd(&cPlaneBlnd);
			smtDMSetGBlnd(&gPlaneBlnd);
		}
	}
}
/*----------------------------------------------------------
	Function name	: DMPaletteDisplay()
	Prototype		: smtUint32 DMPaletteDisplay(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static smtUint32 DMPaletteDisplay(void)
{
	DMPlaneBlndMode cPlaneBlndMode,gPlaneBlndMode;

	DisplayCursorPalette();
	DMCursorOn(CURSOR_BASEADDR, 0, 0x0);
	smtDMGetCBlndMode(&cPlaneBlndMode);
	cPlaneBlndMode.blendMod = 0x3;//alpha per pixel
	smtDMSetCBlndMode(&cPlaneBlndMode);

	DisplayGraphicPalette();
	DMGraphicOn(GRAPHIC_BASEADDR, 0, 0x0);
	smtDMGetGBlndMode(&gPlaneBlndMode);
	gPlaneBlndMode.blendMod = 0x3;//alpha per pixel
	smtDMSetGBlndMode(&gPlaneBlndMode);

	return SMT_SUCCESS;
}
/*----------------------------------------------------------
	Function name	: DisplayGraphicPalette()
	Prototype		: static void DisplayGraphicPalette(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static void DisplayCursorPalette(void)
{
	smtInt32 i, j;
	smtUint32 *frame = (smtUint32 *)CURSOR_BASEADDR;

	DMPlanePalette palette;
	
	for(i = 0 ; i < 8 ; i++)
	{
		// set palette memory
		palette.palAddr = i;
		palette.palData = palColorTbl[i]& 0x00ffffff;
		palette.palData |= (CURSOR_PALETTE_ALPHA << 24);
		smtDMSetCPalette(&palette);
	}

	// prepare indexed bmp
	for(i = 0; i < FRAME_HEIGHT; i++)
	{
		for(j = 0; j < FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x00000000;
		
		for(; j < 2*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x01010101;
		
		for(; j < 3*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x02020202;
		
		for(; j < 4*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x03030303;
		
		for(; j < 5*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x04040404;
		
		for(; j < 6*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x05050505;
		
		for(; j < 7*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x06060606;
		
		for(; j < FRAME_WIDTH/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x07070707;
		
	}
}
/*----------------------------------------------------------
	Function name	: DisplayGraphicPalette()
	Prototype		: static void DisplayGraphicPalette(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static void DisplayGraphicPalette(void)
{
	smtInt32 i, j;
	smtUint32 *frame = (smtUint32 *)GRAPHIC_BASEADDR;

	DMPlanePalette palette;

	for(i=0; i < 8; i++)
	{
		palette.palAddr = i;
		palette.palData = palColorTbl[i] & 0x00ffffff;
		palette.palData |= (GRAPHIC_PALETTE_ALPHA << 24);
		smtDMSetGPalette(&palette);
	}
	
	// prepare indexed bmp
	for(i = 0; i < FRAME_HEIGHT; i++)
	{
		//GPIOWrite(i);
		SMT_WRITE(GPIO0_OUT, i);

		for(j = 0; j < FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x00000000;
		
		for(; j < 2*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x01010101;
		
		for(; j < 3*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x02020202;
		
		for(; j < 4*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x03030303;
		
		for(; j < 5*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x04040404;
		
		for(; j < 6*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x05050505;
		
		for(; j < 7*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x06060606;
		
		for(; j < FRAME_WIDTH/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x07070707;
		
	}
}

#else
/*----------------------------------------------------------
	Function name	: CGVOverlay()
	Prototype		: static smtUint32 CGVOverlay(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static smtUint32 CGVOverlay(void)
{
	DMPlaneBlndMode gPlaneBlndMode;
	smtUint32 i;
	
	smtUint16 *cFrame0 = (smtUint16 *)CURSOR_BASEADDR;
	smtUint32 *gFrame0 = (smtUint32 *)GRAPHIC_BASEADDR;
	smtUint16 *vFrame0 = (smtUint16 *)VIDEO_BASEADDR;
	smtUint32 wrData = 0;

	// copy cursor image to DDR
	smt2UARTPrint(CFG_UART_CH,"start to copy cursor plane image !! \n");
	for(i = 0; i < CURSOR_HEIGHT*CURSOR_WIDTH*2; i++)
		*(cFrame0+i) = cursor_buffer[i];

	// copy graphic image to DDR
	smt2UARTPrint(CFG_UART_CH,"start to copy graphic plane image !! \n");
	for(i = 0; i < (GRAPHIC_HEIGHT*2)*GRAPHIC_WIDTH *3 ;)
	{
		wrData = 0;
		wrData = graphic_buffer[i++];
		wrData = wrData | (graphic_buffer[i++] << 8);
		wrData = wrData | (graphic_buffer[i++] <<16);
		*(gFrame0++) = wrData;
	}
	// copy video image to DDR
	smt2UARTPrint(CFG_UART_CH,"start to copy video plane image !! \n");
	for(i = 0; i < (VIDEO_HEIGHT*2)*VIDEO_WIDTH; i++)
		*(vFrame0+i) = video_buffer[i];
	#ifdef __OVERLAY_VIDEO_IN__
	DMVIFEnable();
	#endif
	smt2UARTPrint(CFG_UART_CH,"enable cursor plane !! \n");
	DMCursorOn((smtUint32)cFrame0, CURSOR_WIDTH >> 1, 0x3);

	smt2UARTPrint(CFG_UART_CH,"enable graphic plane !! \n");
	gFrame0 = (smtUint32 *)(GRAPHIC_BASEADDR);
	DMGraphicOn((smtUint32)gFrame0, GRAPHIC_WIDTH, 0x4);
	smtDMGetGBlndMode(&gPlaneBlndMode);
	gPlaneBlndMode.blendMod = 0x2;
	smtDMSetGBlndMode(&gPlaneBlndMode);

	smt2UARTPrint(CFG_UART_CH,"enable video plane !! \n");
	#ifdef __OVERLAY_VIDEO_IN__
	DMVideoOn((smtUint32) vFrame0, VIDEO_WIDTH >> 1, 0x2);
	#else
	DMVideoOn((smtUint32) vFrame0, VIDEO_WIDTH >> 1, 0x3);
	#endif

	RequestIRQ(IRQ_DM,ISRCGVOverlay);

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: ISRCGVOverlay()
	Prototype		: static void ISRCGVOverlay(smtUint32 irq)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static void ISRCGVOverlay(smtUint32 irq)
{
	DMStatus dmSts;
	DMPlaneBlnd gPlaneBlnd,cPlaneBlnd;
	static smtUint8 cAlpha =0,gAlpha =0;
	smtDMGetMasterStatus(&dmSts);
	//smt2UARTPrint(CFG_UART_CH,"ISR DM!!!\n");
	
	if(dmSts.mixFifoErr == 1)
	{
		smt2UARTPrint(CFG_UART_CH,"Mixer FIFO Error \n");
	}
	if(dmSts.gDmaFifoErr == 1)
	{
		smt2UARTPrint(CFG_UART_CH,"Graphic DMA FIFO Error \n");
	}
	if(dmSts.gFifoErr == 1)
	{
		smt2UARTPrint(CFG_UART_CH,"Graphic FIFO Error \n");
	}
	if(dmSts.vDmaFifoErr == 1)
	{
		smt2UARTPrint(CFG_UART_CH,"Video DMA FIFO Error \n");
	}
	if(dmSts.vFifoErr == 1)
	{
		smt2UARTPrint(CFG_UART_CH,"Video FIFO Error \n");
	}
	if(dmSts.startFrame == 1)
	{
		if(dmSts.evenFieldInt == 1)
		{
			smtDMSetCAddr((smtUint32)CURSOR_BASEADDR+(CURSOR_WIDTH*2));
			smtDMSetGAddr((smtUint32)(GRAPHIC_BASEADDR+(GRAPHIC_WIDTH*4)));
			smtDMSetVAddr((smtUint32)(VIDEO_BASEADDR+(VIDEO_WIDTH*2)));
		}
		else
		{
			smtDMSetCAddr((smtUint32)CURSOR_BASEADDR);
			smtDMSetGAddr((smtUint32)GRAPHIC_BASEADDR);
			smtDMSetVAddr((smtUint32)VIDEO_BASEADDR);
			cPlaneBlnd.alpha = cAlpha++;
			gPlaneBlnd.alpha = gAlpha++;
			
			smtDMSetCBlnd(&cPlaneBlnd);
			smtDMSetGBlnd(&gPlaneBlnd);
		}
	}
}

#endif
/*----------------------------------------------------------
	Function name	: StressSEIPRecord()
	Prototype		: static void StressSEIPRecord(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static smtUint32 StressSEIPRecord(void)
{
	EdmaStruct edma;
	smtUint32 regData;
	InitSEIP();
	SEIP_DMA_TX_Enable();
	
	edma.src 		= (unsigned)(&SEIP_TXDAT);
	edma.srcInc 	= DMA_ADDR_NOINC;
	edma.srcWidth 	= DMA_BUSWIDTH32;

	edma.dst 		= AUDIO_TESTADDR;
	edma.dstInc 	= DMA_ADDR_INC;
	edma.dstWidth 	= DMA_BUSWIDTH32;

	edma.startIntEn = 0x1;
	edma.endIntEn 	= 0x1;
	edma.stopIntEn 	= 0x1;	

	edma.totSize	= 0xFFFFF;
	edma.transSize	= DMA_TRANSSIZE8;

	edma.enM2M		= 0x0;

	edma.descListBase = (smtUint32)descBuffer;

	// Transfer Data : 4M
	regData  = (edma.startIntEn		&0x1)	<<31;
	regData |= (edma.endIntEn		&0x1)	<<30;
	regData |= (edma.enM2M			&0x1)	<<29;//shkim-20070418 : new EDMA 
	regData |= (edma.srcInc			&0x1)	<<28;
	regData |= (edma.srcWidth		&0x3)	<<26;
	regData |= (edma.dstInc			&0x1)	<<25;
	regData |= (edma.dstWidth		&0x3)	<<23;
	regData |= (edma.transSize		&0x7)	<<20;
	regData |= (edma.totSize)		&0xFFFFF;

	descBuffer[0] = edma.src;
	descBuffer[1] = edma.dst;
	descBuffer[2] = regData;
	descBuffer[3] = (smtUint32)descBuffer;

	
	smt2EDMAChAsign(DMA_CHALLOC, DMA_SEIPTX, &rec_rx_dmach);
	smt2UARTPrint(CFG_UART_CH,"RX channel = %d\n",rec_rx_dmach);

	regData = 0;
	regData |= ((edma.enM2M & 0x1) << 29);
	SMT_WRITE(DMACCon(rec_rx_dmach),regData);
	
	//set descriptor base address
	SMT_WRITE(DMACDescrp(rec_rx_dmach),(smtUint32)descBuffer);

	//enable EDMA
	SMT_WRITE(DMACSta(rec_rx_dmach),
		 ((DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK)
		|((edma.stopIntEn & 0x1) << 4))
		);

	Disable_IRQ();
	RequestIRQ(IRQ_DMAX[rec_rx_dmach], ISRStressSEIPTest);
	Enable_IRQ();
 	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: ISRStressSEIPTest()
	Prototype		: static void ISRStressSEIPTest(smtUint32 irq)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static void ISRStressSEIPTest(smtUint32 irq)
{
	REC_InterruptFlag = SMT_TRUE;
	REC_InterruptValue = SMT_READ(DMACSta(rec_rx_dmach));

	if(REC_InterruptValue&(1<<3))
	{
		SMT_WRITE(DMACSta(rec_rx_dmach),0x0000000F); 
		return;
	}
	
	SMT_WRITE(DMACSta(rec_rx_dmach),REC_InterruptValue|0x0000000F); 

}

/*----------------------------------------------------------
	Function name	: StressDMAM2M()
	Prototype		: static void StressDMAM2M(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static smtUint32 StressDMAM2M(void)
{
	EdmaStruct	edma;
	smtUint32 regData;
	
	edma.src 		= (smtUint32)DDRRAM_USER;
	edma.srcInc 	= DMA_ADDR_INC;
	edma.srcWidth 	= DMA_BUSWIDTH32;

	edma.dst 		= DDR_TESTREGION;
	edma.dstInc 	= DMA_ADDR_INC;
	edma.dstWidth 	= DMA_BUSWIDTH32;

	edma.startIntEn = 0x1;
	edma.endIntEn 	= 0x1;
	edma.stopIntEn 	= 0x1;	

	edma.totSize	= 0xFFFFF;
	edma.transSize	= DMA_TRANSSIZE8;

	edma.enM2M		= 0x1;

	edma.descListBase = (smtUint32)descBufferM2M;

	// Transfer Data : 4M
	regData  = (edma.startIntEn		&0x1)	<<31;
	regData |= (edma.endIntEn		&0x1)	<<30;
	regData |= (edma.enM2M			&0x1)	<<29;//shkim-20070418 : new EDMA 
	regData |= (edma.srcInc			&0x1)	<<28;
	regData |= (edma.srcWidth		&0x3)	<<26;
	regData |= (edma.dstInc			&0x1)	<<25;
	regData |= (edma.dstWidth		&0x3)	<<23;
	regData |= (edma.transSize		&0x7)	<<20;
	regData |= (edma.totSize)		&0xFFFFF;

	descBufferM2M[0] = edma.src;
	descBufferM2M[1] = edma.dst;
	descBufferM2M[2] = regData;
	descBufferM2M[3] = (smtUint32)descBufferM2M;


	//smt2EDMAChAsign(DMA_CHALLOC, DMA_SEIPTX, &rec_rx_dmach);
	//smt2UARTPrint(CFG_UART_CH,"RX channel = %d\n",rec_rx_dmach);

	regData = 0;
	regData |= ((edma.enM2M & 0x1) << 29);
	SMT_WRITE(DMACCon(STRESS_DMA_M2M_CH),regData);

	//set descriptor base address
	SMT_WRITE(DMACDescrp(STRESS_DMA_M2M_CH),(smtUint32)descBufferM2M);

	//enable EDMA
	SMT_WRITE(DMACSta(STRESS_DMA_M2M_CH),
		 ((DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK)
		|((edma.stopIntEn & 0x1) << 4))
		);

	Disable_IRQ();
	RequestIRQ(IRQ_DMAX[STRESS_DMA_M2M_CH], ISRStressDMAM2M);
	Enable_IRQ();
	return SMT_SUCCESS;

}

/*----------------------------------------------------------
	Function name	: ISRStressDMAM2M()
	Prototype		: void ISRStressDMAM2M(smtUint32 irq)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
void ISRStressDMAM2M(smtUint32 irq)
{
	static smtBoolean REC_InterruptFlag = SMT_FALSE;
	static smtUint32 REC_InterruptValue;
	
	REC_InterruptFlag = SMT_TRUE;
	REC_InterruptValue = SMT_READ(DMACSta(STRESS_DMA_M2M_CH));

	if(REC_InterruptValue&(1<<3))
	{
		SMT_WRITE(DMACSta(STRESS_DMA_M2M_CH),0x0000000F); 
		return;
	}
	
	SMT_WRITE(DMACSta(STRESS_DMA_M2M_CH),REC_InterruptValue|0x0000000F); 


}
