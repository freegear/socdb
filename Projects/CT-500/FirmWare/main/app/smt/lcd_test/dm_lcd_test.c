/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: dm_lcd_test.c 
	Description	: LCD test code
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
#include "lcd.h"
#include "global.h"
#include "lcd_pre_drv.h"
#include "uart_post_drv.h"
#include "display_test_utils.h"
#include "dm_lcd_test.h"

#include "cursor_480272.h"
#include "graphic_480272.c"
#include "video_480272.h"

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

static volatile smtUint8 bStartFrame = 0x0;
/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

static smtUint32 LCDCGVOverlay(void);
/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/

// Edit your code

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/
smtUint32 DMLCDTest(void)
{
	smtUint32 errCode = SMT_SUCCESS;

	// enable Display Module
	DMEnable();
	// config LCD sync
	DMSyncEnable();

	// register ISR
	DisableIRQ(IRQ_DM);
	RequestIRQ(IRQ_DM, ISRDMLCDTest);
	EnableIRQ(IRQ_DM);

	// enable C/G/V plane
	errCode = LCDCGVOverlay();
	
	// disable C/G/V plane
	DMDisable( CURSOR_PLANE_DISABLE | GRAPHIC_PLANE_DISABLE | VIDEO_PLANE_DISABLE);

	// release ISR
	ReleaseIRQ(IRQ_DM);
	return errCode;
}
/*----------------------------------------------------------
	Function name	: LCDCGVOverlay()
	Prototype		: smtUint32 CGVOverlay(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 LCDCGVOverlay(void)
{
	DMPlaneCtrl gPlaneCfg,cPlaneCfg,vPlaneCfg;
	DMPlaneBlnd gPlaneBlnd,cPlaneBlnd,vPlaneBlnd;
	DMPlaneBlndMode gPlaneBlndMode,cPlaneBlndMode,vPlaneBlndMode;
	smtUint32 i;
	smtUint8  alphaVal = 0xFF, alphaValCursor = 0;

#if 1// frame buffer variables
	smtUint16 *cFrame0 = (smtUint16 *)CURSOR_BASEADDR;
	smtUint32 *gFrame0 = (smtUint32 *)GRAPHIC_BASEADDR;
	smtUint16 *vFrame0 = (smtUint16 *)VIDEO_BASEADDR;
	smtUint32 wrData = 0;
#endif	

	//---------------------------------------------------
	//	copy source image to frame buffer
	//---------------------------------------------------
	
	// copy cursor image to DDR
	for(i = 0; i < CURSOR_HEIGHT*CURSOR_WIDTH*2; i++)
		*(cFrame0+i) = cursor_lbuffer[i];

	// copy graphic image to DDR
	for(i = 0; i < (GRAPHIC_HEIGHT*2)*GRAPHIC_WIDTH *3 ;)
	{
		wrData = 0;
		wrData = graphic_lbuffer[i++];
		wrData = wrData | (graphic_lbuffer[i++] << 8);
		wrData = wrData | (graphic_lbuffer[i++] <<16);
		*(gFrame0++) = wrData;
	}
	
	// copy video image to DDR
	for(i = 0; i < (VIDEO_HEIGHT*2)*VIDEO_WIDTH; i++)
		*(vFrame0+i) = video_lbuffer[i];	


	//---------------------------------------------------
	//	cursor plane setting
	//---------------------------------------------------

	DMCursorOn((smtUint32)cFrame0, 0, 0x3);

	smtDMGetCBlnd(&cPlaneBlnd);
	cPlaneBlnd.alpha = 0xFF;
	cPlaneBlnd.colKey = 0xF8FCF8; // set chromakey value
	smtDMSetCBlnd(&cPlaneBlnd);

	smtDMGetCBlndMode(&cPlaneBlndMode);
	cPlaneBlndMode.blendMod = 0x0;//disable alphablending
	cPlaneBlndMode.colKeyEn = 0x1;//enable chromakey
	smtDMSetCBlndMode(&cPlaneBlndMode);

	//---------------------------------------------------
	//	graphic plane setting
	//---------------------------------------------------

	gFrame0 = (smtUint32 *)(GRAPHIC_BASEADDR);
	DMGraphicOn((smtUint32)gFrame0, 0, 0x4);
	smtDMGetGBlndMode(&gPlaneBlndMode);
	gPlaneBlndMode.blendMod = 0x2;
	smtDMSetGBlndMode(&gPlaneBlndMode);

	//---------------------------------------------------
	//	video plane setting
	//---------------------------------------------------
	
	DMVideoOn((smtUint32) vFrame0, 0, 0x3);

	//---------------------------------------------------
	//	change alphablending value
	//---------------------------------------------------
	smt2UARTPrint(CFG_UART_CH,"press '0' to exit overlay test\n");
	while(1)
	{
		smtUint8 uart_input;

		if(bStartFrame)
		{
			smtDMGetGBlnd(&gPlaneBlnd);
			gPlaneBlnd.alpha	= alphaVal--;
			gPlaneBlnd.colKey	= 0xFFFFFF;
			smtDMSetGBlnd(&gPlaneBlnd);

			smtDMGetCBlnd(&cPlaneBlnd);
			cPlaneBlnd.alpha	= alphaValCursor++;
			smtDMSetCBlnd(&cPlaneBlnd);
			bStartFrame = SMT_FALSE;
		}
		smt2UARTDataValid(CFG_UART_CH, &uart_input);
		if(uart_input)
		{
			smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);
			if(uart_input == '0')
			break;
		}
	}
	return SMT_SUCCESS;
}
/*----------------------------------------------------------
	Function name	: ISRDMLCDTest()
	Prototype		: void ISRDMLCDTest(smtUint32 irq)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
void ISRDMLCDTest(smtUint32 irq)
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
		bStartFrame = SMT_TRUE;
	}

}
