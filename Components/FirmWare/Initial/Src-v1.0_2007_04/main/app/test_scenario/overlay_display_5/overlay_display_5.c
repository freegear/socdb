/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : overlay_display_5.c 
	Description : overlay display test functions
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


/*
//////////////////////////////////////////////////////////////////////////////
        DEFINITIOIN
//////////////////////////////////////////////////////////////////////////////
*/
//cursor image
extern unsigned short cursor_buffer[];
//graphic image
extern unsigned char graphic_buffer[];
//video image
extern unsigned short video_buffer[];

volatile smtBoolean bStartFrame = SMT_FALSE;
void ISRDMOverlayTest(smtUint32 irq);
static smtUint32 CGVOverlay(void);
//#define __DM_SCREEN_CMP_TEST__ //comparing CT500 to GMX1000
/*
//////////////////////////////////////////////////////////////////////////////
        FUNCTION
//////////////////////////////////////////////////////////////////////////////
*/
/*----------------------------------------------------------
	Function name	: OverlayDisplayTest()
	Prototype		: smtUint32 OverlayDisplayTest(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 OverlayDisplayTest(void)
{
	smtUint32 errCode = SMT_SUCCESS;

	DMVEncEnable();
	DMEnable();
	DMSyncEnable();
	RequestIRQ(IRQ_DM,ISRDMOverlayTest);
	
	errCode = CGVOverlay();

	DMDisable(CURSOR_PLANE_DISABLE|GRAPHIC_PLANE_DISABLE|VIDEO_PLANE_DISABLE);
	DMVEncDisable();
	ReleaseIRQ(IRQ_DM);
	return errCode;
}
/*----------------------------------------------------------
	Function name	: CGVOverlay()
	Prototype		: smtUint32 CGVOverlay(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static smtUint32 CGVOverlay(void)
{
	DMPlaneCtrl gPlaneCfg,cPlaneCfg,vPlaneCfg;
	DMPlaneBlnd gPlaneBlnd,cPlaneBlnd,vPlaneBlnd;
	DMPlaneBlndMode gPlaneBlndMode,cPlaneBlndMode,vPlaneBlndMode;
	smtUint32 i;
	smtUint8 cursorOnOff = 0, graphicOnOff = 0, videoOnOff = 0;
	smtUint8  alphaVal = 0xFF, alphaValCursor = 0;
	VEncImageCtrl imageCtrl;
	smtUint8 sturY = 150, sturC = 150;
	static smtUint8 lFilterString [][30]={"6Mhz","NTSC NOTCH","PAL NOTCH","BYPASS"};
	static smtUint8 cFilterString [][30]={"1.35 Mhz","0.67Mhz"};
	static smtUint8 cFilterVal[2] = {0,2};
	smtUint8 lFilterIdx = 0, cFilterIdx = 0;
	VEncInternal vInternal;
#if 1// frame buffer variables
	smtUint16 *cFrame0 = (smtUint16 *)CURSOR_BASEADDR;
	smtUint32 *gFrame0 = (smtUint32 *)GRAPHIC_BASEADDR;
	smtUint16 *vFrame0 = (smtUint16 *)VIDEO_BASEADDR;
	smtUint32 wrData = 0;
#endif	

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

	smt2UARTPrint(CFG_UART_CH,"enable cursor plane !! \n");
	DMCursorOn((smtUint32)cFrame0, CURSOR_WIDTH >> 1, 0x3);

	#ifdef __DM_SCREEN_CMP_TEST__//disable alphablening for comparing to GMX1000
	smtDMGetCBlndMode(&cPlaneBlndMode);
	cPlaneBlndMode.blendMod = 0x0;
	smtDMSetCBlndMode(&cPlaneBlndMode);
	#endif

	smt2UARTPrint(CFG_UART_CH,"enable graphic plane !! \n");
	gFrame0 = (smtUint32 *)(GRAPHIC_BASEADDR);
	DMGraphicOn((smtUint32)gFrame0, GRAPHIC_WIDTH, 0x4);
	smtDMGetGBlndMode(&gPlaneBlndMode);
	#ifdef __DM_SCREEN_CMP_TEST__//disable alphablening for comparing to GMX1000
	gPlaneBlndMode.blendMod = 0x0;
	#else
	gPlaneBlndMode.blendMod = 0x2;
	#endif
	smtDMSetGBlndMode(&gPlaneBlndMode);
	
	smt2UARTPrint(CFG_UART_CH,"enable video plane !! \n");
	DMVideoOn((smtUint32) vFrame0, VIDEO_WIDTH >> 1, 0x3);


	smt2UARTPrint(CFG_UART_CH,"press '0' to exit overlay test\n");
	#ifdef __DM_SCREEN_CMP_TEST__//on/off each plane
	smt2UARTPrint(CFG_UART_CH,"press 'c' or 'g' or 'v' to on/off each plane\n");
	smt2UARTPrint(CFG_UART_CH,"press 'y' or 'h' to change sturation Y level\n");
	smt2UARTPrint(CFG_UART_CH,"press 'u' or 'j' to change sturation C level\n");
	smt2UARTPrint(CFG_UART_CH,"press 'f' or 'd' to change luminance(f) chrominance(d) filter\n");
	#endif
	//swiching even/odd field image
	while(1)
	{
		smtUint8 uart_input;

		if(bStartFrame)
		{
			gPlaneBlnd.alpha	= alphaVal--;
			gPlaneBlnd.colKey	= 0xFFFFFF;
			smtDMSetGBlnd(&gPlaneBlnd);

			cPlaneBlnd.alpha	= alphaValCursor++;
			cPlaneBlnd.colKey	= 0x000000;
			smtDMSetCBlnd(&cPlaneBlnd);
			bStartFrame = SMT_FALSE;
		}
		if(!(++i%1000))
			smt2UARTDataValid(CFG_UART_CH, &uart_input);
			
		if(uart_input)
		{
			smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);
			#ifdef __DM_SCREEN_CMP_TEST__//on/off each plane
			switch(uart_input)
			{
				case 'c':
					smtDMGetCCtrl(&cPlaneCfg);
					cPlaneCfg.xEn = cursorOnOff;
					smtDMSetCCtrl(&cPlaneCfg);
					cursorOnOff ^=1;
					break;
				case 'g':
					smtDMGetGCtrl(&gPlaneCfg);
					gPlaneCfg.xEn = graphicOnOff;
					smtDMSetGCtrl(&gPlaneCfg);
					graphicOnOff ^=1;
					break;
				case 'v':
					smtDMGetVCtrl(&vPlaneCfg);
					vPlaneCfg.xEn = videoOnOff;
					smtDMSetVCtrl(&vPlaneCfg);
					videoOnOff ^=1;
					break;
								
				case 'y':
					smtVENCGetVideoImageCtrl(&imageCtrl);
					imageCtrl.saturationYLev = ++sturY;
					smtVENCSetVideoImageCtrl(&imageCtrl);
					smt2UARTPrint(CFG_UART_CH, "saturationYLevel = [0x%08x]\n",sturY);
					break;
				case 'h':
					smtVENCGetVideoImageCtrl(&imageCtrl);
					imageCtrl.saturationYLev = --sturY;
					smtVENCSetVideoImageCtrl(&imageCtrl);
					smt2UARTPrint(CFG_UART_CH, "saturationYLevel = [0x%08x]\n",sturY);
					break;

				case 'u':
					smtVENCGetVideoImageCtrl(&imageCtrl);
					imageCtrl.saturationCLev = ++sturC;
					smtVENCSetVideoImageCtrl(&imageCtrl);
					smt2UARTPrint(CFG_UART_CH, "saturationCLevel = [0x%08x]\n",sturC);
					break;
				case 'j':
					smtVENCGetVideoImageCtrl(&imageCtrl);
					imageCtrl.saturationCLev = --sturC;
					smtVENCSetVideoImageCtrl(&imageCtrl);
					smt2UARTPrint(CFG_UART_CH, "saturationCLevel = [0x%08x]\n",sturC);
					break;
				case 'f':
					smtVENCGetCtrlNInternal(0x0, &vInternal);
					vInternal.lFilter = lFilterIdx%4;
					smtVENCSetCtrlNInternal(0x0, &vInternal);
					smt2UARTPrint(CFG_UART_CH,"[%10s] luminance filter seleted\n ",lFilterString[lFilterIdx%4]);
					lFilterIdx++;
					break;
				case 'd':
					smtVENCGetCtrlNInternal(0x0,&vInternal);
					vInternal.CFilter	= cFilterVal[cFilterIdx%2];
					smtVENCSetCtrlNInternal(0x0,&vInternal);
					smt2UARTPrint(CFG_UART_CH,"[%10s] chrominance filter selected\n",cFilterString[cFilterIdx%2]);
					cFilterIdx++;
					break;
					
			}
			#endif			
			if(uart_input == '0')
				break;
		uart_input = 0;
		}
	}
	return SMT_SUCCESS;
}
/*----------------------------------------------------------
	Function name	: ISRDMOverlayTest()
	Prototype		: void ISRDMOverlayTest(smtUint32 irq)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
void ISRDMOverlayTest(smtUint32 irq)
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
			//smtDMSetCAddr((smtUint32)CURSOR_BASEADDR+((CURSOR_WIDTH/2)*4));
			smtDMSetCAddr((smtUint32)CURSOR_BASEADDR+(CURSOR_WIDTH*2));
			smtDMSetGAddr((smtUint32)(GRAPHIC_BASEADDR+(GRAPHIC_WIDTH*4)));
			smtDMSetVAddr((smtUint32)(VIDEO_BASEADDR+(VIDEO_WIDTH*2)));
		}
		else
		{
			smtDMSetCAddr((smtUint32)CURSOR_BASEADDR);
			smtDMSetGAddr((smtUint32)GRAPHIC_BASEADDR);
			smtDMSetVAddr((smtUint32)VIDEO_BASEADDR);
		}
		bStartFrame = SMT_TRUE;
	}

}

