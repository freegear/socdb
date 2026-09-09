/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: lcd.c 
	Description	: LCD test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
//#include "irq.h"
#include "lcd.h"
#include "global.h"
#include "lcd_pre_drv.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

#define NTSC
#ifdef NTSC
#define MODE         0
#define FRAME_WIDTH  720
#define FRAME_HEIGHT 240
#define LCD_HFP	(31)	        // Horizontal Front Porch(2 clock)
#define LCD_HBP	((122*2)-121)	// Horizontal Back Porch(2 clock)
#define LCD_HSW	(122)	        // Horizontal Sync Width(41 clock)
#define LCD_CPL (720 *2)	    // active clocks per line

#define LCD_VBP (16)	// Vertical Back Porch(4 line)
#define LCD_VFP (3)	    // Vertical Front Porch(4 line)
#define LCD_VSW (3)	    // Vertical Sync Width(10 line)
#define LCD_LPS (240)	// active lines per screen

#define LCD_IVS (1)	    
#define LCD_IHS (1)	    
#define LCD_IEO (0)	    
#define LCD_BCD (1)	    
#define LCD_BPP (2)	    
#define LCD_BGR (0)	    
#define LCD_IPS (1)
#define LCD_VIDEO_SYNC_EN (0)
#else
#define MODE         4
#define FRAME_WIDTH  720
#define FRAME_HEIGHT 288

#define LCD_HFP	(23)	        // Horizontal Front Porch(2 clock)
#define LCD_HSW	(132)	        // Horizontal Sync Width(41 clock)
#define LCD_HBP	((132*2)-131)	// Horizontal Back Porch(2 clock)
#define LCD_CPL (720 *2)	    // active clocks per line

#define LCD_VSW (2)	    // Vertical Sync Width(10 line)
#define LCD_LPS (288)	// active lines per screen
#define LCD_VBP (20)	// Vertical Back Porch(4 line)
#define LCD_VFP (2)	    // Vertical Front Porch(4 line)

#define LCD_IVS (1)	    
#define LCD_IHS (1)	    
#define LCD_IEO (0)	    
#define LCD_BCD (1)	    
#define LCD_BPP (2)	    
#define LCD_BGR (0)	    
#define LCD_IPS (1)
#endif


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
smtUint32 DMTest(void);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

// Edit your code

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	Function name	: DMTest()
	Prototype		: smtUint32 LCDTest(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 DMTest(void)
{
	smtUint32 errCode;
	
	// Edit your LCD test code
	//1. init h/w
	errCode = DMInit();
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;
	//2. cursor plane
	errCode = DMCursorPlaneTest();
	if(errCode != SMT_SUCCESS)
	//3. graphic plane
	errCode = DMGraphicPlaneTest();
	if(errCode != SMT_SUCCESS)
	//4. video plane
	errCode = DMVideoPlaneTest();
	if(errCode != SMT_SUCCESS)
	return NO_ERROR;
}

static smtUint32 DMInit(void)
{
	
	DMCtrl dmCtrl;
	DMLcdCtrl dmLcdCtrl;
	DMHSync0Ctrl dmHSync0;
	DMHSync1Ctrl dmHSync1;
	DMVSync0Ctrl dmVSync0;
	DMVSync1Ctrl dmVSync1;
	
	//1. set DM control
	dmCtrl.prioritySel 	= 0x0;
	dmCtrl.swReset		= 0x0;
	dmCtrl.errIntEn 	= 0x1;
	dmCtrl.intEn		= 0x1;
	smtDMSetMasterCtrl(dmCtrl);

	//2. set Back ground Colour
	smtDMSetBGCol(0xFF0000);

	//3. set LCD IF(LCDCON, HSYNC0, HSYNC1, VSYNC0, VSYNC1)
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

	dmLcdCtrl.invertHSync	= LCD_IHS;
	dmLcdCtrl.invertVSync	= LCD_IVS;
	dmLcdCtrl.invertPixClk	= LCD_IPS;
	dmLcdCtrl.invertWrEn	= LCD_IEO;
	dmLcdCtrl.lcdBpp		= LCD_BPP;//shkim-20070201: check bit order
	dmLcdCtrl.rbSwap		= LCD_BGR;//shkim-20070201: check bit order
	dmLcdCtrl.pDiv			= 0x0;
	dmLcdCtrl.lcdPwrEn		= 0x1;
	dmLcdCtrl.lcdEn			= LCD_VIDEO_SYNC_EN; // video sync enable
	smtDMSetLCDCtrl(dmLcdCtrl);
}

static smtUint32 DMCursorPlaneTest(void)
{
	DMPlaneCtrl cPlaneCfg;
	DMPlaneBlnd cPlaneBlnd;
	DMPlaneBlndMode cPlaneBlndMode;
	DMPlanePalette	cPlanePalette;
	
	//1. set chromakey/alpha value(BLEND)
	cPlaneBlnd.alpha	= 0xFF;
	cPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetCBlnd(cPlaneBlnd);
	
	//2. set planexref/base address
	//	- BASE(stride) / ADDR register(framebuffer)
	smtDMSetCBase(0x0);
	smtDMSetCAddr(0x00000000);
	
	//3. set blenmode
	cPlaneBlndMode.xPos = 0;
	cPlaneBlndMode.yPos = 0;
	cPlaneBlndMode.colKeyEn = 0x0;
	cPlaneBlndMode.blendMod = 0x0; //0:no alpha , 2: global alpha, 3: pixel alpha
	smtDMSetCBlndMode(cPlaneBlndMode);
	
	//4. set plane control register
	cPlaneCfg.xEn 		= 0x1;
	cPlaneCfg.pixFmt 	= 0x3;//0:8BPP,1:RGB332 2:ARGB(1555) 3:RGB565
	cPlaneCfg.gammaEn	= 0x0;
	cPlaneCfg.sWidth 	= FRAME_WIDTH;
	cPlaneCfg.sHeight	= FRAME_HEIGHT;
	smtDMSetCCtrl(cPlaneCfg);	

	/*
	1.test pixel format
		-palette(8BPP)/RGB332/RGB565/ARGB1555
		
	2.test changing src width, srcStartX,Y
	
	3.test changing plane x,y position
	
	4.test alpha blending/chromakey
	*/
}
static smtUint32 DMGraphicPlaneTest(void)
{
	DMPlaneCtrl gPlaneCfg;
	DMPlaneBlnd gPlaneBlnd;
	DMPlaneBlndMode gPlaneBlndMode;
	DMPlanePalette	gPlanePalette;
	
	//1. set chromakey/alpha value(BLEND)
	//	- BLEND register
	gPlaneBlnd.alpha	= 0xFF;
	gPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetGBlnd(gPlaneBlnd);
	
	//2. set planexref/base address
	//	- BASE(stride) / ADDR register(framebuffer)

	smtDMSetGBase(0x0);
	smtDMSetGAddr(0x00000000);
	
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
	gPlaneCfg.pixFmt 	= 0x3;//0:8BPP,2:RGB565,3:ARGB1555, 4:RGB888, 5:ARGB8888
	gPlaneCfg.gammaEn	= 0x0;
	gPlaneCfg.sWidth 	= FRAME_WIDTH;
	gPlaneCfg.sHeight	= FRAME_HEIGHT;
	smtDMSetGCtrl(gPlaneCfg);	

	/*
	1.test pixel format
		-palette(8BPP)/RGB565/RGB888/ARGB8888/ARGB1555
		
	2.test changing src width, srcStartX,Y
	
	3.test changing plane x,y position
	
	4.test alpha blending/chromakey
	*/
}
static smtUint32 DMVideoPlaneTest(void)
{
	DMPlaneCtrl vPlaneCfg;
	DMPlaneBlnd vPlaneBlnd;
	DMPlaneBlndMode vPlaneBlndMode;
	DMPlanePalette	vPlanePalette;
	
	//1. set chromakey/alpha value(BLEND)
	//	- BLEND register
	vPlaneBlnd.alpha	= 0xFF;
	vPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetVBlnd(vPlaneBlnd);
	
	//2. set planexref/base address
	//	- BASE(stride) / ADDR register(framebuffer)

	smtDMSetVBase(0x0);
	smtDMSetVAddr(0x00000000);
	smtDMSetVAddr2(0x00000000);
	
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
	vPlaneCfg.pixFmt 	= 0x3;//0:8BPP,1:RGB332 2:ARGB(1555) 3:RGB565
	vPlaneCfg.vPlaneIFEn = 0x0;// interlaced video source
	vPlaneCfg.vPlaneN2PUpEn = 0x0;
	vPlaneCfg.sWidth 	= FRAME_WIDTH;
	vPlaneCfg.sHeight	= FRAME_HEIGHT;
	smtDMSetVCtrl(vPlaneCfg);
	
	/*		
	1.test pixel format
		-YUV422( U lsb, V lsb, Y0 lsb[Y0UY1V], Y0 lsb[Y0VY1U])
		
	2.test changing src width, srcStartX,Y
	//need to modify base/ address register 
	3.test changing plane x,y position
	
	4.test alpha blending/chromakey
	*/
}

