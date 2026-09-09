/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : display_test_utils.c 
	Description : display test utils functions
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
/*
//////////////////////////////////////////////////////////////////////////////
        DEFINITIOIN
//////////////////////////////////////////////////////////////////////////////
*/

/*
//////////////////////////////////////////////////////////////////////////////
        FUNCTION
//////////////////////////////////////////////////////////////////////////////
*/
/*------------------------------------------------------------------------------
	Function name	: DMSyncEnable() 
	Prototype		: smtUint32 DMSyncEnable(void)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtUint32 DMSyncEnable(void)
{
	DMLcdCtrl dmLcdCtrl;
	DMHSync0Ctrl dmHSync0;
	DMHSync1Ctrl dmHSync1;
	DMVSync0Ctrl dmVSync0;
	DMVSync1Ctrl dmVSync1;
	
	// set sync timing (HSYNC0, HSYNC1, VSYNC0, VSYNC1)
	dmHSync0.tHFrontPorch		= LCD_HFP;
	dmHSync0.tHBackPorch		= LCD_HBP;
	smtDMSetHSync0(dmHSync0);
		
	dmHSync1.tHDspPixPerLine	= LCD_CPL;
	dmHSync1.tHPulsWidth		= LCD_HSW;
	smtDMSetHSync1(dmHSync1);
	
	dmVSync0.tVFrontPorch		= LCD_VFP;
	dmVSync0.tVBackPorch		= LCD_VBP;
	smtDMSetVSync0(dmVSync0);
	
	dmVSync1.tVDspPeriod	= LCD_LPS;
	dmVSync1.tVPulsWidth	= LCD_VSW;
	smtDMSetVSync1(dmVSync1);

	// set sync configuration (LCDCON)
	dmLcdCtrl.invertHSync	= LCD_IHS;
	dmLcdCtrl.invertVSync	= LCD_IVS;
	dmLcdCtrl.invertPixClk	= LCD_IPS;
	dmLcdCtrl.invertWrEn	= LCD_IEO;
	dmLcdCtrl.lcdBpp		= LCD_BPP;
	dmLcdCtrl.rbSwap		= LCD_BGR;
	dmLcdCtrl.pDiv			= 0x0;
	dmLcdCtrl.lcdPwrEn		= 0x1;
	dmLcdCtrl.lcdEn			= LCD_VIDEO_SYNC_EN; // video sync enable
	smtDMSetLCDCtrl(dmLcdCtrl);
	return SMT_SUCCESS;
	
}

/*------------------------------------------------------------------------------
	Function name	: DMEnable
	Prototype		: smtUint32 DMEnable(void)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtUint32 DMEnable(void)
{
	DMCtrl dmCtrl;
	
	// set DM control
	dmCtrl.prioritySel 	= 0x1;
	dmCtrl.swReset		= 0x0;
	dmCtrl.errIntEn 	= 0x0;
	dmCtrl.startIntEn	= 0x1;
	dmCtrl.endIntEn		= 0x0;
	smtDMSetMasterCtrl(dmCtrl);

	// set Back ground Colour
	smtDMSetBGCol(0xFF0000);
	return SMT_SUCCESS;
}

/*------------------------------------------------------------------------------
	Function name	: DMCursorOn()
	Prototype		: smtUint32 DMCursorOn(smtUint32 frameAddr, smtUint32 stride, smtUint8 pixFmt)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtUint32 DMCursorOn(smtUint32 frameAddr, smtUint32 stride, smtUint8 pixFmt)
{
	DMPlaneCtrl cPlaneCfg;
	DMPlaneBlnd cPlaneBlnd;
	DMPlaneBlndMode cPlaneBlndMode;

	//1. set chromakey/alpha value(BLEND)
	cPlaneBlnd.alpha	= 0xFF;
	cPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetCBlnd(cPlaneBlnd);
	
	//2. set planexref/base address
	//	- BASE(stride) / ADDR register(framebuffer)
	
	smtDMSetCBase(stride);
	smtDMSetCAddr((smtUint32)frameAddr);
	
	//3. set blenmode
	cPlaneBlndMode.xPos = 0;
	cPlaneBlndMode.yPos = 0;
	cPlaneBlndMode.colKeyEn = 0x0;
	cPlaneBlndMode.blendMod = 0x2; //0:no alpha , 2: global alpha, 3: pixel alpha
	smtDMSetCBlndMode(cPlaneBlndMode);
	
	//4. set plane control register
	cPlaneCfg.xEn 		= 0x1;
	cPlaneCfg.pixFmt 	= pixFmt;//0:8BPP,1:RGB332 2:ARGB(1555) 3:RGB565
	cPlaneCfg.gammaEn	= 0x0;
	cPlaneCfg.sWidth 	= CURSOR_WIDTH;
	cPlaneCfg.sHeight	= CURSOR_HEIGHT;
	smtDMSetCCtrl(cPlaneCfg);
	
	return SMT_SUCCESS;
}

/*------------------------------------------------------------------------------
	Function name	: DMGraphicOn()
	Prototype		: smtUint32 DMGraphicOn(smtUint32 frameAddr, smtUint32 stride, smtUint8 pixFmt)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtUint32 DMGraphicOn(smtUint32 frameAddr, smtUint32 stride, smtUint8 pixFmt)
{
	DMPlaneCtrl gPlaneCfg;
	DMPlaneBlnd gPlaneBlnd;
	DMPlaneBlndMode gPlaneBlndMode;
	
	//1. set chromakey/alpha value(BLEND)
	//	- BLEND register
	gPlaneBlnd.alpha	= 0xFF;
	gPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetGBlnd(gPlaneBlnd);
	
	//2. set planexref/base address
	//	- BASE(stride) / ADDR register(framebuffer)
	smtDMSetGBase(stride);
	smtDMSetGAddr((smtUint32)frameAddr);

	//3. set blenmode
	//	- BLENDMODE
	//	- alpha , chromakey en/disable
	//	- plane x,y position
	gPlaneBlndMode.xPos = 0;
	gPlaneBlndMode.yPos = 0;
	gPlaneBlndMode.colKeyEn = 0x0;
	gPlaneBlndMode.blendMod = 0x0; //0:no alpha , 2: global alpha, 3: pixel alpha
	smtDMSetGBlndMode(gPlaneBlndMode);
	
	//4. set plane control register
	//	- plane enable
	//	- plane pixel format
	//	- plane surface width , height
	gPlaneCfg.xEn 		= 0x1;
	gPlaneCfg.vPlaneN2PUpEn = 0x0;
	gPlaneCfg.gColBarEn		= 0x0;
	gPlaneCfg.pixFmt 	= pixFmt;//0:8BPP,2:RGB565,3:ARGB1555, 4:RGB888, 5:ARGB8888
	gPlaneCfg.gammaEn	= 0x0;
	gPlaneCfg.sWidth 	= GRAPHIC_WIDTH;
	gPlaneCfg.sHeight	= GRAPHIC_HEIGHT;
	smtDMSetGCtrl(gPlaneCfg);
	
	return SMT_SUCCESS;
}

/*------------------------------------------------------------------------------
	Function name	: DMVideoOn()
	Prototype		: smtUint32 DMVideoOn(smtUint32 frameAddr, smtUint32 stride, smtUint8 pixFmt)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtUint32 DMVideoOn(smtUint32 frameAddr, smtUint32 stride, smtUint8 pixFmt)
{
	DMPlaneCtrl vPlaneCfg;
	DMPlaneBlnd vPlaneBlnd;
	DMPlaneBlndMode vPlaneBlndMode;

	//1. set chromakey/alpha value(BLEND)
	//	- BLEND register
	vPlaneBlnd.alpha	= 0xFF;
	vPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetVBlnd(vPlaneBlnd);
	
	//2. set planexref/base address
	//	- BASE(stride) / ADDR register(framebuffer)
	smtDMSetVBase(stride);
	smtDMSetVAddr((smtUint32)frameAddr);
	
	//3. set blenmode
	//	- BLENDMODE
	//	- alpha , chromakey en/disable
	//	- plane x,y position
	vPlaneBlndMode.xPos = 0;
	vPlaneBlndMode.yPos = 0;
	vPlaneBlndMode.colKeyEn = 0x0;
	vPlaneBlndMode.blendMod = 0x0; //0:no alpha , 2: global alpha, 3: pixel alpha
	smtDMSetVBlndMode(vPlaneBlndMode);
	
	//4. set plane control register
	//	- plane enable
	//	- plane pixel format
	//	- plane surface width , height
	vPlaneCfg.xEn 		= 0x1;
	vPlaneCfg.pixFmt 	= pixFmt;//
	vPlaneCfg.vPlaneIFEn = 0x0;// interlaced video source
	vPlaneCfg.vPlaneN2PUpEn = 0x0;
	vPlaneCfg.sWidth 	= VIDEO_WIDTH;
	vPlaneCfg.sHeight	= VIDEO_HEIGHT;
	smtDMSetVCtrl(vPlaneCfg);
	
	return SMT_SUCCESS;
}
/*------------------------------------------------------------------------------
	Function name	: DMVIFEnable
	Prototype		: smtUint32 DMVIFEnable(void)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtUint32 DMVIFEnable(void)
{
	VIF_CTRL_STRUCT vif;
	VIF_PROP_STRUCT vifProp;

	//ADV7181BInitCompositeAltera();
	ADV7181BInitComposite();

	vifProp.vifDmaAddr= VIDEO_BASEADDR;
	vifProp.vifXPos	= 0;
	vifProp.vifYPos	= 11;
	vifProp.vifXSize	= 720;
	vifProp.vifYSize	= 240;

//	vif.hBlank	= 0;	// Read Only
//	vif.vBlank	= 0;
//	vif.field	= 0;
	vif.i2pEn	= 1;
	vif.ycOrder	= 2;		// y/cb/y/cr order
	vif.errorIntEn = 0;
	vif.startIntEn	= 0;		// Frame start interrupt enable
	vif.endIntEn	= 1;		// Frame end interrupt enable
	vif.dmaEn	= 1;		// DMA enable
	vif.swReset = 0;
	smtVIFSetProperty(vifProp);
	smtVIFSetMode(vif);
}
/*------------------------------------------------------------------------------
	Function name	: DMVEncEnable
	Prototype		: smtUint32 DMVEncEnable(void)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtUint32 DMVEncEnable(void)
{
	VEncCtrl vCtrl;
	VEncInternal vInternal;
	VEncStatus vStatus;
	VEncImageCtrl imageCtrl;

	//set Video Encoder Ctrl Register
	vCtrl.encMode	= MODE;
	vCtrl.sanning	= EN_NONINTERLACE;
	vCtrl.SqPixel	= EN_SQPIXEL;
	vCtrl.DAC0		= EN_DAC0;
	vCtrl.DAC1		= EN_DAC1;
	vCtrl.DAC2		= EN_DAC2;

	//set Video Encoder internal Register
	vInternal.hSyncWidth	= HSYNC_WID;
	vInternal.burstWidth	= BURST_WID;
	vInternal.lDelay		= LUMA_DELAY;
	vInternal.cDelay		= CHRO_DELAY;
	vInternal.patternMode	= EN_INTERNAL_PATTERN;
	vInternal.pattern		= COLOR_PATTERN_MODE;
	vInternal.resetSCH		= EN_REST_SCH;
	vInternal.color			= EN_COLOR_KILL;
	vInternal.CFilter		= CHRO_FILTER_SEL;
	vInternal.lFilter		= LUMA_FILTER_SEL;
	smtSetVideoEncode(&vCtrl,&vInternal);

	smtGetVideoImageCtrl(&imageCtrl);
	imageCtrl.saturationCLev = 144;
	imageCtrl.saturationYLev = 144;
	smtSetVideoImageCtrl(&imageCtrl);
	
	//set Video Encoder Status Register
	vStatus.Enable		= 0x1; // enable video encoder
	vStatus.fieldCount	= 0x0;
	vStatus.Hcount		= 0x0;
	vStatus.Vcount		= 0x0;
	smtSetVideoStatus(&vStatus);
}
/*----------------------------------------------------------
	Function name	: DMDisable()
	Prototype		: void DMDisable(smtUint8 targetPlane)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
void DMDisable(smtUint8 targetPlane)
{
	DMPlaneCtrl dmPlaneCtrl;

	memset(&dmPlaneCtrl,0x0,sizeof(dmPlaneCtrl));
	
	if(targetPlane & 0x1)
		smtDMSetCCtrl(dmPlaneCtrl);
	if(targetPlane & 0x2)
		smtDMSetGCtrl(dmPlaneCtrl);
	if(targetPlane & 0x4)
		smtDMSetVCtrl(dmPlaneCtrl);
}

/*----------------------------------------------------------
	Function name	: DMVEncDisable()
	Prototype		: void DMVEncDisable(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
void DMVEncDisable(void)
{
	VEncStatus vStatus;

	memset(&vStatus,0x0,sizeof(vStatus));
	smtSetVideoStatus(&vStatus);
}
/*----------------------------------------------------------
	Function name	: DMVIFDisable()
	Prototype		: void DMVIFDisable(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
void DMVIFDisable(void)
{
	VIF_CTRL_STRUCT vif;
	memset(&vif,0x0,sizeof(vif));
	smtVIFSetMode(vif);	
}
