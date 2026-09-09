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
#include "global.h"
#include "jpegdec.h"
#include "PANORAMA_1.h"
#include "lcd_pre_drv.h"
#include "videoenc_post_drv.h"
#include "videoenc_pre_drv.h"
#include "smt_nand_cfg.h"
#include "display_test_utils.h"

extern smtUint32 smt2UARTPrint(smtUint8 uartCh, smtInt8 *format, ...);
void ISRDMJpegTest(smtUint32 irq);
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

#define JPEGDPRINTF				smt2UARTPrint
#define	JPEG_IMAGE_WIDTH		(1440)
#define	JPEG_IMAGE_HEIGHT		(480)
#define	JPEG_IMAGE_OUT_IN		(0x62000000)
#define	JPEG_IMAGE_OUT_ADDR		(0x62100000)

/*----------------------------------------------------------
	Function name	: JPEGTest
	Prototype		: void JPEGTest(void)
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void JPEGTest(void)
{
	int			width, height;
	smtUint32 	i, j;
	BYTE		*pjpgData	= (BYTE*)PANORAMA_1;	
	BYTE		*pbmpBuffer = (BYTE*)JPEG_IMAGE_OUT_ADDR;

	
	
	JpegDecodeInit();
	
	
	JPEGDPRINTF(CFG_UART_CH, "start JPEG Decode....\n");

	
	width  = JPEG_IMAGE_WIDTH;
	height = JPEG_IMAGE_HEIGHT;
	
	/*
	JPEGDPRINTF(CFG_UART_CH, "Load JPEG stream form NAND\n");
	NANDU_Open();
	
	for(i = 0; i < 5; i++)
	{
		NANDU_128kReader(JPG_PANORAMA_1_HANDLE+i, 
			(smtUint32)pjpgData+(smtUint32)(128*1024*i));		
	}
	smt2UARTPrint(CFG_UART_CH, "read jpeg from NAND!!!\n");
	
	NANDU_Close();
	*/
	RequestIRQ(IRQ_DM, ISRDMJpegTest);
	
	DMVEncEnable();
	DMEnable();
	DMSyncEnable();
	
	{
		volatile int i;
		smtUint8 temp;
		memset((void*)pbmpBuffer, 0, 0x100000*sizeof(int));
		JPEGDPRINTF(CFG_UART_CH, "[JPEG decoding for YUV....]\n");
		JpegDecode(pjpgData, (BYTE *)pbmpBuffer, &width, &height);

		// Video layer on
		DMVideoOn((smtUint32)pbmpBuffer, (720+1440)>>1, 0x3);
		
		JPEGDPRINTF(CFG_UART_CH, "Video layer on  > ...");
		smt2UARTGetCh(CFG_UART_CH, &temp, 0);
		JPEGDPRINTF(CFG_UART_CH, "\n");
	
		DMDisable(VIDEO_PLANE_DISABLE);
		JPEGDPRINTF(CFG_UART_CH, "Video layer off > ...\n");
	
		
		memset((void*)pbmpBuffer, 0, 0x100000*sizeof(int));
		JPEGDPRINTF(CFG_UART_CH, "[JPEG decoding for RGB....]\n");
		JpegDecode0(pjpgData, (BYTE *)pbmpBuffer, &width, &height);
	
		// Graphic layer on
		DMGraphicOn((smtUint32)pbmpBuffer,1440+720, 0x4);
		JPEGDPRINTF(CFG_UART_CH, "Graphic layer on  > ...");
		smt2UARTGetCh(CFG_UART_CH, &temp, 0);
		JPEGDPRINTF(CFG_UART_CH, "\n");		

	
		// Graphic layer off
		DMDisable(GRAPHIC_PLANE_DISABLE);
		JPEGDPRINTF(CFG_UART_CH, "Graphic layer off > ...\n");
		
	}
	DMVEncDisable();
	ReleaseIRQ(IRQ_DM);
	JPEGDPRINTF(CFG_UART_CH, "JPEG Test Done....\n");

}
void ISRDMJpegTest(smtUint32 irq)
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
		{
			smtDMSetGAddr((smtUint32)(JPEG_IMAGE_OUT_ADDR+(GRAPHIC_WIDTH*2*4)));
			smtDMSetVAddr((smtUint32)(JPEG_IMAGE_OUT_ADDR+(VIDEO_WIDTH*2*2)));
		}
		else
		{
			smtDMSetGAddr((smtUint32)JPEG_IMAGE_OUT_ADDR);
			smtDMSetVAddr((smtUint32)JPEG_IMAGE_OUT_ADDR);
		}
		//bStartFrame = SMT_TRUE;
	}

}