/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : video_withgdma_6.c 
	Description : video plane using gdma test functions
	Created by  : SHMT SOC Team
------------------------------------------------------------------------------*/
/*
//////////////////////////////////////////////////////////////////////////////
        INCLUDE
//////////////////////////////////////////////////////////////////////////////
*/
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "global.h"
#include "display_test_utils.h"
#include "uart_post_drv.h"
#include "lcd_pre_drv.h"
#include "videoenc_post_drv.h"
#include "videoenc_pre_drv.h"
#include "vif_pre_drv.h"

#include "jpegdec.h"
#include "PANORAMA_2.h" // raw jpeg data
#include "PANORAMA_3.h"

/*
//////////////////////////////////////////////////////////////////////////////
        DEFINITIOIN
//////////////////////////////////////////////////////////////////////////////
*/

void ISRDMVideoGDMATest(smtUint32 irq);
static smtUint32 DMChgScrEffect(void *src_addr, void *dst_addr, smtUint8 effectId);
static smtUint32 DMLoadImg(void *src_addr, void* dst_addr, smtUint32 cx, smtUint32 cy, smtUint32 ssx,smtUint32 dsx);

static volatile smtUint32 frameBaseAddr = VIDEO_BASEADDR;
/*
//////////////////////////////////////////////////////////////////////////////
        FUNCTION
//////////////////////////////////////////////////////////////////////////////
*/
/*------------------------------------------------------------------------------
	Function name	: VideoWithGDMATest()
	Prototype		: smtUint32 VideoWithGDMATest()
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtUint32 VideoWithGDMATest()
{
	GdmaStruct gdma;
	smtUint32 errCode = SMT_SUCCESS,i=0;
	smtUint32 targetScrBuf=VIDEO_SRC1_BASEADDR;
	
	smtUint8 *pjpgData = (smtUint8*)PANORAMA_2;
	
	int width = 1440, height = 480;

	JpegDecodeInit();	

	smt2UARTPrint(CFG_UART_CH,"jpeg decoding.......\n");
	JpegDecode(pjpgData, (BYTE *)VIDEO_SRC0_BASEADDR, &width, &height);
	smt2UARTPrint(CFG_UART_CH, "finished jpeg0 decoding!!\n");

	pjpgData = (smtUint8*)PANORAMA_3;
	smt2UARTPrint(CFG_UART_CH,"jpeg decoding.......\n");
	JpegDecode(pjpgData, (BYTE *)VIDEO_SRC1_BASEADDR, &width, &height);
	smt2UARTPrint(CFG_UART_CH, "finished jpeg1 decoding!!\n");
	
	//DMA2Init(SMT_TRUE);
	gdma.src = (smtUint32)VIDEO_SRC0_BASEADDR;
	gdma.sWidth = 1440;
	gdma.sHeight = 480;

	gdma.sClipX = 0;
	gdma.sClipY = 0;

	gdma.dst = (smtUint32)VIDEO_BASEADDR;//dst_addr;
	gdma.dWidth = 1440;
	gdma.dHeight = 480;

	gdma.dClipX = 0;
	gdma.dClipY = 0;

	gdma.clipWidth = 1440;
	gdma.clipHeight = 480;
	
	gdma.bpp = 2;
	gdma.intFunction = 0;
	
	errCode = smt2GDMACopy(&gdma, SMT_TRUE);	

	DMEnable();
	DMSyncEnable();
	DMVEncEnable();
	DMVideoOn(VIDEO_BASEADDR, (VIDEO_WIDTH+1440)>>1, 0x3);
	RequestIRQ(IRQ_DM,ISRDMVideoGDMATest);

	smt2UARTPrint(CFG_UART_CH,"press '0' to exit video plane test\n");
	smt2UARTPrint(CFG_UART_CH,"press 'a' or 's' to move right/left\n");
	smt2UARTPrint(CFG_UART_CH,"press 'c' to change screen\n");
	while(1)
	{
		smtUint8 uart_input = 0;
		smt2UARTDataValid(CFG_UART_CH, &uart_input);
		if(uart_input)
		{
			smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);
			if(uart_input == '0')
			{
				break;
			}
			else if(uart_input == 'a')
			{
				for(i = 0 ; i < 360 ; i++)
				{
					frameBaseAddr += 2*2;
					smtDelay100us(160);
				}
			}
			else if(uart_input == 's')
			{
				for(i = 0 ; i < 360 ; i++)
				{
					frameBaseAddr -= 2*2;
					smtDelay100us(160);
				}
			}
			else if(uart_input == 'c')
			{
				DMLoadImg((void*)frameBaseAddr, (void*)VIDEO_BASEADDR, 720, 480,0,0);
				
				for(i = 0 ; i < 360 ; i++)
				{
					DMChgScrEffect((void*)targetScrBuf,(void*)VIDEO_BASEADDR, 0);
				}
				DMLoadImg((void*)targetScrBuf, (void*)VIDEO_BASEADDR, 720, 480,720,720);
				
				if(targetScrBuf == (smtUint32)VIDEO_SRC0_BASEADDR)
					targetScrBuf = (smtUint32)VIDEO_SRC1_BASEADDR;
				else
					targetScrBuf = (smtUint32)VIDEO_SRC0_BASEADDR;
			}
		}
	}

	DMDisable(VIDEO_PLANE_DISABLE);
	DMVEncDisable();	
	ReleaseIRQ(IRQ_DM);
	return errCode;
}

/*------------------------------------------------------------------------------
	Function name	: DMChgScrEffect()
	Prototype		: smtUint32 DMChgScrEffect(void *src_addr, void *dst_addr, smtUint8 effectId)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
static smtUint32 DMChgScrEffect(void *src_addr, void *dst_addr, smtUint8 effectId)
{
	GdmaStruct gdma;
	smtUint32 errCode = SMT_SUCCESS;
	static smtUint32 idx=0; 

	gdma.src = (smtUint32)src_addr;
	gdma.sClipX = 0;
	gdma.sClipY = 0;
	
	gdma.sWidth = 1440;
	gdma.sHeight = 480;


	gdma.dst = (smtUint32)dst_addr;
	gdma.dWidth = 1440;
	gdma.dHeight = 480;
	gdma.dClipX = 720 - (idx + 1 )*2;
	gdma.dClipY = 0;

	gdma.clipWidth = (idx+1) * 2;
	gdma.clipHeight = 480;
	
	gdma.bpp = 2;
	gdma.intFunction = 0;

	errCode = smt2GDMACopy(&gdma,SMT_TRUE);
	
	if(errCode != SMT_SUCCESS)
		return errCode;
	
	frameBaseAddr = (smtUint32)dst_addr;

	if(gdma.dClipX == 0)
		idx = 0;
	else
		idx++;
	
	return errCode;
}

/*------------------------------------------------------------------------------
	Function name	: DMLoadImg()
	Prototype		: smtUint32 DMLoadImg(void *src_addr, void* dst_addr, smtUint32 cx, smtUint32 cy, smtUint32 ssx,smtUint32 dsx)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
static smtUint32 DMLoadImg(void *src_addr, void* dst_addr, smtUint32 cx, smtUint32 cy, smtUint32 ssx,smtUint32 dsx)
{
	GdmaStruct gdma;
	smtUint32 errCode;
	
	gdma.src = (smtUint32)src_addr;
	gdma.sWidth = 1440;
	gdma.sHeight = 480;

	gdma.sClipX = ssx;
	gdma.sClipY = 0;
	

	gdma.dst = (smtUint32)dst_addr;
	gdma.dWidth = 1440;
	gdma.dHeight = 480;

	gdma.dClipX = dsx;
	gdma.dClipY = 0;

	gdma.clipWidth = cx;
	gdma.clipHeight = cy;
	
	gdma.bpp = 2;
	gdma.intFunction = 0;
	
	errCode = smt2GDMACopy(&gdma, SMT_TRUE);	

	return errCode;
}

/*------------------------------------------------------------------------------
	Function name	: ISRDMVideoGDMATest()
	Prototype		: void ISRDMVideoGDMATest(smtUint32 irq)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
void ISRDMVideoGDMATest(smtUint32 irq)
{
	DMStatus dmSts;
	smtDMGetMasterStatus(&dmSts);
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
			smtDMSetVAddr((smtUint32)(frameBaseAddr+VIDEO_WIDTH*2*2));
		else
			smtDMSetVAddr((smtUint32)frameBaseAddr);
	}

}
