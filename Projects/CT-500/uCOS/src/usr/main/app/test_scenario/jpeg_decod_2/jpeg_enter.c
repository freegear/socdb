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

extern smtBoolean smt2UartPrint(int dispLvl, char *fmt, ...);
void ISRDMJpegTest(smtUint32 irq);
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

#define JPEGDPRINTF				smt2UartPrint
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
	JPEGBYTE		*pjpgData	= (JPEGBYTE*)PANORAMA_1;	
	JPEGBYTE		*pbmpBuffer = (JPEGBYTE*)JPEG_IMAGE_OUT_ADDR;

	
	
	JpegDecodeInit();
	
	
	JPEGDPRINTF(11, "start JPEG Decode....\n");

	
	width  = JPEG_IMAGE_WIDTH;
	height = JPEG_IMAGE_HEIGHT;
	
	/*
	JPEGDPRINTF(11, "Load JPEG stream form NAND\n");
	NANDU_Open();
	
	for(i = 0; i < 5; i++)
	{
		NANDU_128kReader(JPG_PANORAMA_1_HANDLE+i, 
			(smtUint32)pjpgData+(smtUint32)(128*1024*i));		
	}
	smt2UartPrint(11, "read jpeg from NAND!!!\n");
	
	NANDU_Close();
	*/
	RequestIRQ(IRQ_DM, ISRDMJpegTest);
	
	DMVEncEnable();
	DMEnable();
	DMSyncEnable();
	
	{
		volatile int i;
		
		memset((void*)pbmpBuffer, 0, 0x100000*sizeof(int));
		JPEGDPRINTF(11, "[JPEG decoding for YUV....]\n");
		JpegDecode(pjpgData, (JPEGBYTE *)pbmpBuffer, &width, &height);

		// Video layer on
		DMVideoOn((smtUint32)pbmpBuffer, (720+1440)>>1, 0x3);
		
		JPEGDPRINTF(11, "Video layer on  > ...");
		smt2UartGetCh(0);
		JPEGDPRINTF(11, "\n");
	
		DMDisable(VIDEO_PLANE_DISABLE);
		JPEGDPRINTF(11, "Video layer off > ...\n");
	
		
		memset((void*)pbmpBuffer, 0, 0x100000*sizeof(int));
		JPEGDPRINTF(11, "[JPEG decoding for RGB....]\n");
		JpegDecode0(pjpgData, (JPEGBYTE *)pbmpBuffer, &width, &height);
	
		// Graphic layer on
		DMGraphicOn((smtUint32)pbmpBuffer,1440+720, 0x4);
		JPEGDPRINTF(11, "Graphic layer on  > ...");
		smt2UartGetCh(0);
		JPEGDPRINTF(11, "\n");		

	
		// Graphic layer off
		DMDisable(GRAPHIC_PLANE_DISABLE);
		JPEGDPRINTF(11, "Graphic layer off > ...\n");
		
	}
	DMVEncDisable();
	ReleaseIRQ(IRQ_DM);
	JPEGDPRINTF(11, "JPEG Test Done....\n");

}
void ISRDMJpegTest(smtUint32 irq)
{
	DMStatus dmSts;
	smtDMGetMasterStatus(&dmSts);
	if(dmSts.mixFifoErr == 1)
	{
		smt2UartPrint(11,"Mixer FIFO Error \n");
	}
	if(dmSts.vDmaFifoErr == 1)
	{
		smt2UartPrint(11,"Video DMA FIFO Error \n");
	}
	if(dmSts.vFifoErr == 1)
	{
		smt2UartPrint(11,"Video FIFO Error \n");
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