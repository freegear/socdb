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

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "sysinc.h"
#include "commonmacro.h"
#include "lcd.h"
#include "global.h"

//#include "lcd_post_drv.h"
#include "videoenc_post_drv.h"

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

// Edit your code

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

smtUint32 VideoEncTest(void);
smtBoolean VEncSetLCD(void);
smtBoolean VEncSetVideoPlane(void);

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
#if 0
/*----------------------------------------------------------
	Function name	: VideoEncTest()
	Prototype		: smtUint32 VideoEncTest(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 VideoEncTest(void)
{
	VEncCfg vEncCfg;
	
	VEncSetLCD();
	VEncSetVideoPlane();
	
	smt2VEncInit(0, 0, 0);

	vEncCfg.rCtrl.set = VENC_VALUE_UNSET;
	vEncCfg.rInternal.set = VENC_VALUE_UNSET;
	smt2VencSetControl(&vEncCfg);

	while(1)
	{
		smt2VEncRun();
	}
	
	return SMT_TRUE;
}



/*-----------------------------------------------------------------------
    Function name   : 
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean VEncSetVideoPlane(void)
{	
	DMCtrl dmMasterCtrl;
	DMVideoPlane videoPlaneCfg;
	DMGraphicPlane graphicCfg;
	DMCursorPlane cursorCfg;	

	// Init Global control register
	dmMasterCtrl.swReset = 0;
	dmMasterCtrl.startIntEn	= 0x1;
	dmMasterCtrl.endIntEn	= 0x0;
	dmMasterCtrl.errIntEn = 1;
	dmMasterCtrl.prioritySel = 0;	
	smtDMSetMasterCtrl(&dmMasterCtrl);

	//set BackGround plane color	
	smt2DMSetBGColor(0xff00fcfb);
		
	// VCON(Video Surface Control) Register 
	videoPlaneCfg.ctrl.sWidth			= 1;
	videoPlaneCfg.ctrl.sHeight			= 1;
	videoPlaneCfg.ctrl.pixFmt			= 1;
	videoPlaneCfg.ctrl.gammaEn			= 1;
	videoPlaneCfg.ctrl.vPlaneIFEn		= 1;
	videoPlaneCfg.ctrl.vPlaneN2PUpEn	= 1;

	videoPlaneCfg.vAddr  	= 0;
	videoPlaneCfg.vAddr2 	= 0;

	videoPlaneCfg.blnd.colKey	= 0;
	videoPlaneCfg.blnd.alpha	= 0;
	
	videoPlaneCfg.blndMode.xPos		= 0;
	videoPlaneCfg.blndMode.yPos		= 0;
	videoPlaneCfg.blndMode.colKeyEn	= 0;
	videoPlaneCfg.blndMode.blendMod	= 0;
		
	videoPlaneCfg.pVGammaLUT	= 0;
	videoPlaneCfg.vPlaneXRef	= 0;

	videoPlaneCfg.ctrl.xEn	= SMT_TRUE;

	// Enable Graphic Plane
	smt2DMSetVideoPlane(&videoPlaneCfg);
	
	// Disable Cursor Plane
	cursorCfg.ctrl.xEn = 0;
	smt2DMSetCursorPlane(&cursorCfg);

	// Disable Graphic Plane	
	graphicCfg.ctrl.xEn = 0;	
	smt2DMSetGraphicPlane(&graphicCfg);	
	
	return SMT_TRUE;
}


/*-----------------------------------------------------------------------
    Function name   : 
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean VEncSetLCD(void)
{
#define L_LCD_HFP		31
#define L_LCD_HSW		122
#define L_LCD_HBP		((122*2)-121)
#define L_LCD_CPL		(720 *2)

#define L_LCD_VSW 3
#define L_LCD_LPS 240
#define L_LCD_VBP 16
#define L_LCD_VFP 3

#define L_LCD_IVS 1	    
#define L_LCD_IHS 1	    
#define L_LCD_IEO 0	    
#define L_LCD_BCD 1	    
#define L_LCD_BPP 2	    
#define L_LCD_BGR 0

	DMLcdIFCtrl dmLcdIFCfg;

	// Setting LCD IF
	dmLcdIFCfg.hSync0Ctrl.tHFrontPorch		= L_LCD_HFP;
	dmLcdIFCfg.hSync0Ctrl.tHBackPorch		= L_LCD_HBP;
	dmLcdIFCfg.hSync1Ctrl.tHPulsWidth		= L_LCD_HSW;
	dmLcdIFCfg.hSync1Ctrl.tHDspPixPerLine	= L_LCD_CPL;
	dmLcdIFCfg.vSync0Ctrl.tVFrontPorch		= L_LCD_VFP;
	dmLcdIFCfg.vSync0Ctrl.tVBackPorch		= L_LCD_VBP;
	dmLcdIFCfg.vSync1Ctrl.tVPulsWidth		= L_LCD_VSW;
	dmLcdIFCfg.vSync1Ctrl.tVDspPeriod		= L_LCD_LPS;
	
	dmLcdIFCfg.lcdCtrl.lcdEn 		= 1;
	dmLcdIFCfg.lcdCtrl.lcdPwrEn		= 1;
	dmLcdIFCfg.lcdCtrl.rbSwap		= 0;
	dmLcdIFCfg.lcdCtrl.lcdBpp		= 2;
	dmLcdIFCfg.lcdCtrl.invertVSync	= 1;
	dmLcdIFCfg.lcdCtrl.invertHSync	= 1;	
	smt2DMSetLCDIF(&dmLcdIFCfg);

	return SMT_TRUE;
	
}
#endif
