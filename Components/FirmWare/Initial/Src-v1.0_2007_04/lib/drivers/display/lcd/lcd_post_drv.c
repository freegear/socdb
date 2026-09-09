/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : lcdpostdrv.c
	Description : lcd post-layer driver
	Created by  : SHMT SOC Team
------------------------------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "lcd_post_drv.h"
#include "string.h"

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

#define __DM_TEST_CODE__
#define __DM_TEST_CURSOR__  1

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

static smtUint8 smt2DMGetSrcStride(void *pPlaneCfg, DMPlaneX whichPlane);

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/


//static variable for cursor
static DMPoint gCursorHotspot;
static DMPoint gCursorSize;
static smtUint32 *pCursorImgBuf;
static smtBoolean gCursorDisabled;
static smtBoolean gCursorVisible;

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*-----------------------------------------------------------------------
    Function name   : smt2DMInitializeHardware
    Prototype       : void smt2DMInitializeHardware(void)
    Return          : void
    Argument        :
    Comments        : init display module
-----------------------------------------------------------------------*/
void smt2DMInitializeHardware (DM_Config *pDmConfig)
{
	DMCtrl dmMasterCtrl;
	DMLcdIFCtrl dmLcdIFCfg;

	// 1. Init Global control register
	dmMasterCtrl.startIntEn		= 0x1;
	dmMasterCtrl.endIntEn		= 0x0;
	smtDMSetMasterCtrl(&dmMasterCtrl);

	// 2. Init Plane block register
	smt2DMSetCursorPlane(&pDmConfig->cursorCfg);
	smt2DMSetGraphicPlane(&pDmConfig->graphicCfg);
	smt2DMSetVideoPlane(&pDmConfig->videoPlaneCfg);
	smt2DMSetBGColor(pDmConfig->bgColor);//set BackGround plane color

	// 3. Init LCD I/F register
	dmLcdIFCfg.hSync0Ctrl.tHFrontPorch		= LCD_HFP;
	dmLcdIFCfg.hSync0Ctrl.tHBackPorch		= LCD_HBP;
	dmLcdIFCfg.hSync1Ctrl.tHPulsWidth		= LCD_HSW;
	dmLcdIFCfg.hSync1Ctrl.tHDspPixPerLine	= LCD_CPL;
	dmLcdIFCfg.vSync0Ctrl.tVFrontPorch		= LCD_VFP;
	dmLcdIFCfg.vSync0Ctrl.tVBackPorch		= LCD_VBP;
	dmLcdIFCfg.vSync1Ctrl.tVPulsWidth		= LCD_VSW;
	dmLcdIFCfg.vSync1Ctrl.tVDspPeriod		= LCD_LPS;
	
	dmLcdIFCfg.lcdCtrl.lcdEn 		= 1;
	dmLcdIFCfg.lcdCtrl.lcdPwrEn		= 1;
	dmLcdIFCfg.lcdCtrl.rbSwap		= 0;
	dmLcdIFCfg.lcdCtrl.lcdBpp		= 2;
	dmLcdIFCfg.lcdCtrl.invertVSync	= 1;
	dmLcdIFCfg.lcdCtrl.invertHSync	= 1;

	smt2DMSetLCDIF(&dmLcdIFCfg);

	// 4. Init global variables for Cursor
	gCursorHotspot.x = 0;
	gCursorHotspot.y = 0;
	gCursorSize.x = 0;
	gCursorSize.y = 0;
	
	pCursorImgBuf 	= 0;
	gCursorVisible 	= SMT_FALSE;
	gCursorDisabled	= SMT_TRUE;
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMGetSrcStride
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
static smtUint8 smt2DMGetSrcStride(void *pPlaneCfg, DMPlaneX whichPlane)
{
	DMCursorPlane	*pCursorCfg;
	DMGraphicPlane	*pGraphicCfg;
	DMVideoPlane	*pVideoCfg;
	smtUint16 srcXRef, srcXstartRef, planeXsizeRef, divisor;
	//1. need to check param
	//	check the structure has srcStartX, srcStartY, srcWidth, srcHeight
	
	//2. calcurate stride and start address for each plane
	switch(whichPlane)
	{
		case DM_CURSOR_PLANE:
			pCursorCfg = (DMCursorPlane*)pPlaneCfg;
			if((pCursorCfg->ctrl.pixFmt & 0x02) >> 1)
				divisor = 2;//16bpp divide by 2
			else 
				divisor = 4;//8bpp divide by 4
				
			srcXRef 		= pCursorCfg->srcWidth/divisor;
			srcXstartRef 	= pCursorCfg->srcStartPos.x/divisor;
			planeXsizeRef 	= pCursorCfg->ctrl.sWidth/divisor;

			pCursorCfg->cPlaneXRef = srcXRef - planeXsizeRef;
			pCursorCfg->cAddr = DM_CUSOR_FRAME_BUF \
								+ (srcXstartRef \
								+ srcXRef * pCursorCfg->srcStartPos.y)<<2;
			break;
		
		case DM_GRAPHIC_PLANE:
			pGraphicCfg = (DMGraphicPlane*)pPlaneCfg;
			
			if((pGraphicCfg->ctrl.pixFmt & 0x04) >> 2)
				divisor = 1;//24bpp 
			else if((pGraphicCfg->ctrl.pixFmt & 0x02) >> 1)
				divisor = 2;//16bpp divide by 2
			else
				divisor = 4;//8bpp divide by 4
			
			srcXRef 		= pGraphicCfg->srcWidth/divisor;
			srcXstartRef 	= pGraphicCfg->srcStartPos.x/divisor;
			planeXsizeRef 	= pGraphicCfg->ctrl.sWidth/divisor;

			pGraphicCfg->gPlaneXRef = srcXRef - planeXsizeRef;
			pGraphicCfg->gAddr = DM_GRAPHIC_FRAME_BUF \
								+ (srcXstartRef \
								+ srcXRef * pGraphicCfg->srcStartPos.y)<<2;
			break;

		case DM_VIDEO_PLANE:
			pVideoCfg = (DMVideoPlane*)pVideoCfg;
			
			divisor = 2;//video plane only support 16bpp
			srcXRef 		= pVideoCfg->srcWidth/divisor;
			srcXstartRef 	= pVideoCfg->srcStartPos.x/divisor;
			planeXsizeRef 	= pVideoCfg->ctrl.sWidth/divisor;

			//video stride
			pVideoCfg->vPlaneXRef = srcXRef - planeXsizeRef;
			//video even address
			pVideoCfg->vAddr = DM_VIDEO_FRAME_BUF \
								+ (srcXstartRef \
								+ srcXRef * pGraphicCfg->srcStartPos.y)<<2;
			//video odd address								
			pVideoCfg->vAddr2 = pVideoCfg->vAddr\
								+ (  (pVideoCfg->srcWidth/2)\
									*(pVideoCfg->srcHeight/2)) << 2;
			break;
		default:
			// smtSetError(LayerID, ID, Inform);
			return SMT_ERROR;
	}
	return SMT_SUCCESS;
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMSetCursorPlane
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMSetCursorPlane(DMCursorPlane *pCursorCfg)
{
	//cursor plane blend		(CBLND)
	smtDMSetCBlnd(&(pCursorCfg->blnd));
	//cursor plane blend Mode	(CBMOD)
	smtDMSetCBlndMode(&(pCursorCfg->blndMode));
	
	smt2DMGetSrcStride((void*)pCursorCfg,DM_CURSOR_PLANE);
	//cursor plane framebufaddr	(CADDR)
	smtDMSetCAddr(pCursorCfg->cAddr);
	//cursor plane XRef			(CBASE)
	smtDMSetCBase(pCursorCfg->cPlaneXRef);

	
	//cursor plane control		(CCON)
	smtDMSetCCtrl(&(pCursorCfg->ctrl));
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMGetCursorPlane
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMGetCursorPlane(DMCursorPlane *pCursorConfig)
{
	//cursor plane control		(CCON)
	smtDMGetCCtrl(&pCursorConfig->ctrl);
	//cursor plane blend		(CBLND)
	smtDMGetCBlnd(&pCursorConfig->blnd);
	//cursor plane blend Mode	(CBMOD)
	smtDMGetCBlndMode(&pCursorConfig->blndMode);
	//cursor plane framebufaddr	(CADDR)
	smtDMGetCAddr(&(pCursorConfig->cAddr));
	//cursor plane stride base 	(CBASE)
	smtDMGetCBase(&(pCursorConfig->cPlaneXRef));
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMCursorOn
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMCursorOn1(void)
{
	DMPlaneCtrl		planeCtrl;
	if (!gCursorDisabled && !gCursorVisible)
	{
		smtDMGetCCtrl(&planeCtrl);
		planeCtrl.xEn = 1;
		smtDMSetCCtrl(&planeCtrl);
		gCursorVisible = SMT_TRUE;
	}
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMCursorOff
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMCursorOff(void)
{
	DMPlaneCtrl		planeCtrl;
	if (!gCursorDisabled && gCursorVisible)
	{
		smtDMGetCCtrl(&planeCtrl);
		planeCtrl.xEn = 0;
		smtDMSetCCtrl(&planeCtrl);
		gCursorVisible = SMT_FALSE;
	}
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMCursorSetPointerShape
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMCursorSetPointerShape(smtUint32 *pCursorImg, smtUint16 xHot, 
					 smtUint16 yHot, smtUint16 cX, smtUint16 cY)
{
	/*
		in cursor image data
		1. cursor off
		2. save cursor hotspot and size
		2. update cursor frame buffer
	*/
	smt2DMCursorOff();
	if (!pCursorImg)							// do we have a new cursor shape
	{
		gCursorDisabled = SMT_TRUE;		// no, so tag as disabled
	}
	else
	{
		gCursorDisabled = SMT_FALSE;		
		gCursorSize.x		= cX;
		gCursorSize.y 		= cY;
		gCursorHotspot.x	= xHot;
		gCursorHotspot.y	= yHot;
		pCursorImgBuf		= pCursorImg;
	}
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMCursorMovePointer
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMCursorMovePointer(smtInt16 xPosition, smtInt16 yPosition)
{
	smtUint16 cursorXPos,cursorYPos;
	DMPlaneBlndMode cursorBlndMode;

	if (xPosition != -1 || yPosition != -1)
	{
		cursorXPos = xPosition - gCursorHotspot.x;
		cursorYPos = yPosition - gCursorHotspot.y;
		smtDMGetCBlndMode(&cursorBlndMode);
		cursorBlndMode.xPos = cursorXPos;
		cursorBlndMode.yPos = cursorYPos;
		smtDMSetCBlndMode(&cursorBlndMode);
		smt2DMCursorOn1();
	}
}

/*------------------------------------------------------------------------------
    Function name   : GraphicSetPalette
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMCursorSetPalette(smtUint32 *colourTable)
{
	smtUint8 i;
	DMPlanePalette cursorPal;
	
	//shkim need to check the address 4byte aligned
	for( i = 0; i < 0xFF; i++)
	{
		cursorPal.palAddr	= i;
		cursorPal.palData	= *colourTable++;
		smtDMSetCPalette(&cursorPal);
	}
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMSetGraphicPlane
    Prototype       : void smt2DMSetGraphicPlane(DMGraphicPlane graphicCfg)
    Return          : void
    Argument        : DMGraphicPlane
    Comments        : set all register for graphic plane
------------------------------------------------------------------------------*/
void smt2DMSetGraphicPlane(DMGraphicPlane *pGraphicCfg)
{
	//graphic plane blend		(GBLND)
	smtDMSetGBlnd(&(pGraphicCfg->blnd));
	//graphic plane blend mode	(GBMOD)
	smtDMSetGBlndMode(&(pGraphicCfg->blndMode));

	smt2DMGetSrcStride((void*)pGraphicCfg,DM_GRAPHIC_PLANE);
	
	//graphic plane framebufaddr(GADDR)
	smtDMSetGAddr(pGraphicCfg->gAddr);
	//graphic plane base 		(GBASE)
	smtDMSetGBase(pGraphicCfg->gPlaneXRef);
	//graphic plane control		(GCON)
	smtDMSetGCtrl(&(pGraphicCfg->ctrl));
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMGetGraphicPlane
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMGetGraphicPlane(DMGraphicPlane *pGraphicCfg)
{
	//graphic plane control			(GCON)
	smtDMGetGCtrl(&pGraphicCfg->ctrl);
	//graphic plane blend			(GBLND)
	smtDMGetGBlnd(&pGraphicCfg->blnd);
	//graphic plane blend Mode		(GBMOD)
	smtDMGetGBlndMode(&pGraphicCfg->blndMode);
	//graphic plane framebufaddr	(GADDR)
	smtDMGetGAddr(&(pGraphicCfg->gAddr));
	//graphic plane stride base 	(GBASE)
	smtDMGetGBase(&(pGraphicCfg->gPlaneXRef));
}

/*------------------------------------------------------------------------------
    Function name   : GraphicSetPalette
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMGraphicSetPalette(smtUint32 *colourTable)
{
	smtUint8 i;
	DMPlanePalette graphicPal;
	
	//shkim need to check the address 4byte aligned
	for( i = 0; i < 0xFF; i++)
	{
		graphicPal.palAddr	= i;
		graphicPal.palData	= *colourTable++;
		smtDMSetGPalette(&graphicPal);
	}
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMGraphicSetGammaLUT
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMGraphicSetGammaLUT(smtUint8 gammaIdx, smtUint32 gammaVal)
{
	smtDMSetGGamma(gammaIdx, gammaVal);
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMGraphicSetAlphaBlend
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMGraphicAlphaBlending(int direction, int timeDelay)
{                            
	volatile int i,j;
	DMGraphicPlane graphicCfg;
	smt2DMGetGraphicPlane(&graphicCfg);
	//SMT_WRITE(GBMOD, 0x10000000);
	graphicCfg.blndMode.blendMod = 2; // graphic plane global alpha
	smt2DMSetGraphicPlane(&graphicCfg);
            
	switch(direction)
	{
		case 1:
			for(i=0; i<0xff; i++)
			{       
				//SMT_WRITE(GBLND, (0x00ffffff | i<<24));
				graphicCfg.blnd.alpha = i; // increase graphic alpha value
				smt2DMSetGraphicPlane(&graphicCfg);
				for(j=0; j<timeDelay; j++);
			} 
			#if 0 //shkim-20061212: debugging
			Printf("increase alpha blending \n!!!");
			UART_getch();
			#endif
		break;
              
        default:
			for(i=0xff; i>0; i--)
			{
				//SMT_WRITE(GBLND, (0x00ffffff | i<<24));
				graphicCfg.blnd.alpha = i; // decrease graphic alpha value
				smt2DMSetGraphicPlane(&graphicCfg);
				for(j=0; j<timeDelay; j++);
			}       
			#if 0 //shkim-20061212: debugging
			Printf("decrease alpha blending \n!!!");
			UART_getch();
			#endif
		break;
	}
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMSetVideoPlane
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMSetVideoPlane(DMVideoPlane *pVideoCfg)
{
	//video plane control		(VCON)
	smtDMSetVCtrl(&(pVideoCfg->ctrl));
	//video plane blend			(VBLND)
	smtDMSetVBlnd(&(pVideoCfg->blnd));
	//video plane blend mode	(VBMOD)
	smtDMSetVBlndMode(&(pVideoCfg->blndMode));

	smt2DMGetSrcStride((void*)pVideoCfg,DM_VIDEO_PLANE);

	//video plane framebufaddr	(VADDR)
	smtDMSetVAddr(pVideoCfg->vAddr);
	smtDMSetVAddr2(pVideoCfg->vAddr2);
	//video plane base		 	(VBASE)
	smtDMSetVBase(pVideoCfg->vPlaneXRef);
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMGetVideoPlane
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMGetVideoPlane(DMVideoPlane *pVideoCfg)
{
	//video plane control		(VCON)
	smtDMGetVCtrl(&pVideoCfg->ctrl);
	//video plane blend		(VBLND)
	smtDMGetVBlnd(&pVideoCfg->blnd);
	//video plane blend Mode	(VBMOD)
	smtDMGetVBlndMode(&pVideoCfg->blndMode);
	//video plane framebufaddr	(VADDR)
	smtDMGetVAddr(&(pVideoCfg->vAddr));
	//video plane framebufaddr	(VADDR)
	smtDMGetVAddr2(&(pVideoCfg->vAddr2));
	//video plane stride base 	(VBASE)
	smtDMGetVBase(&(pVideoCfg->vPlaneXRef));
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMVideoSetGammaLUT
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMVideoSetGammaLUT(smtUint8 gammaIdx, smtUint32 gammaVal)
{
	smtDMSetVGamma(gammaIdx, gammaVal);
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMSetLCDIF
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMSetLCDIF(DMLcdIFCtrl *pLcdIFCfg)
{
	smtDMSetHSync0(&(pLcdIFCfg->hSync0Ctrl));
	smtDMSetHSync1(&(pLcdIFCfg->hSync1Ctrl));
	smtDMSetVSync0(&(pLcdIFCfg->vSync0Ctrl));
	smtDMSetVSync1(&(pLcdIFCfg->vSync1Ctrl));
	// set LCD controll register
	smtDMSetLCDCtrl(&(pLcdIFCfg->lcdCtrl));
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMWaitForNotBusy
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smt2DMWaitForNotBusy()
{
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMIsBusy
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
smtBoolean smt2DMIsBusy(void)
{
	return SMT_FALSE;
}

/*------------------------------------------------------------------------------
    Function name   : smt2DMInVBlank
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
smtBoolean smt2DMInVBlank()
{
	return SMT_FALSE;
}

/*-----------------------------------------------------------------------
    Function name   : smt2DMSWReset
    Prototype       : void smt2DMSWReset(void)
    Return          : void
    Argument        :
    Comments        : init display module
-----------------------------------------------------------------------*/
void smt2DMSWReset(void)
{
	DMCtrl dmMasterCtrl;
	smtDMGetMasterCtrl(&dmMasterCtrl);

	dmMasterCtrl.swReset = 1;

	smtDMSetMasterCtrl(&dmMasterCtrl);
}

/*-----------------------------------------------------------------------
    Function name   : smt2DMSetBGColor
    Prototype       : void smt2DMSetBGColor(void)
    Return          : void
    Argument        :
    Comments        : init display module
-----------------------------------------------------------------------*/
void smt2DMSetBGColor(smtUint32 bgColor)
{
	smtDMSetBGCol(bgColor);
}

/*------------------------------------------------------------------------------
	Function name	: DMSyncEnable() 
	Prototype		: smtUint32 DMSyncEnable(void)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtUint32 smt2DMSyncEnable(void)
{
	DMLcdCtrl dmLcdCtrl;
	DMHSync0Ctrl dmHSync0;
	DMHSync1Ctrl dmHSync1;
	DMVSync0Ctrl dmVSync0;
	DMVSync1Ctrl dmVSync1;
	
	// set sync timing (HSYNC0, HSYNC1, VSYNC0, VSYNC1)
	dmHSync0.tHFrontPorch		= LCD_HFP;
	dmHSync0.tHBackPorch		= LCD_HBP;
	smtDMSetHSync0(&dmHSync0);
		
	dmHSync1.tHDspPixPerLine	= LCD_CPL;
	dmHSync1.tHPulsWidth		= LCD_HSW;
	smtDMSetHSync1(&dmHSync1);
	
	dmVSync0.tVFrontPorch		= LCD_VFP;
	dmVSync0.tVBackPorch		= LCD_VBP;
	smtDMSetVSync0(&dmVSync0);
	
	dmVSync1.tVDspPeriod	= LCD_LPS;
	dmVSync1.tVPulsWidth	= LCD_VSW;
	smtDMSetVSync1(&dmVSync1);

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
	smtDMSetLCDCtrl(&dmLcdCtrl);
	return SMT_SUCCESS;
	
}

/*------------------------------------------------------------------------------
	Function name	: smt2DMEnable
	Prototype		: smtUint32 smt2DMEnable(void)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtUint32 smt2DMEnable(void)
{
	DMCtrl dmCtrl;
	
	// set DM control
	dmCtrl.prioritySel 	= 0x1;
	dmCtrl.swReset		= 0x0;
	dmCtrl.errIntEn 	= 0x0;
	dmCtrl.startIntEn	= 0x1;
	dmCtrl.endIntEn		= 0x0;
	smtDMSetMasterCtrl(&dmCtrl);

	// set Back ground Colour
	smtDMSetBGCol(0xFF0000);
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smt2DMDisable()
	Prototype		: void smt2DMDisable(smtUint8 targetPlane)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
void smt2DMDisable(smtUint8 targetPlane)
{
	DMPlaneCtrl dmPlaneCtrl;

	memset(&dmPlaneCtrl,0x0,sizeof(dmPlaneCtrl));
	
	if(targetPlane & 0x1)
		smtDMSetCCtrl(&dmPlaneCtrl);
	if(targetPlane & 0x2)
		smtDMSetGCtrl(&dmPlaneCtrl);
	if(targetPlane & 0x4)
		smtDMSetVCtrl(&dmPlaneCtrl);
}

/*------------------------------------------------------------------------------
	Function name	: smt2DMCursorOn()
	Prototype		: smtUint32 smt2DMCursorOn(smtUint32 frameAddr, smtUint32 stride, smtUint8 pixFmt)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtUint32 smt2DMCursorOn(smtUint32 frameAddr, smtUint32 stride, smtUint8 pixFmt)
{
	DMPlaneCtrl cPlaneCfg;
	DMPlaneBlnd cPlaneBlnd;
	DMPlaneBlndMode cPlaneBlndMode;

	//1. set chromakey/alpha value(BLEND)
	cPlaneBlnd.alpha	= 0xFF;
	cPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetCBlnd(&cPlaneBlnd);
	
	//2. set planexref/base address
	//	- BASE(stride) / ADDR register(framebuffer)
	
	smtDMSetCBase(stride);
	smtDMSetCAddr((smtUint32)frameAddr);
	
	//3. set blenmode
	cPlaneBlndMode.xPos = 0;
	cPlaneBlndMode.yPos = 0;
	cPlaneBlndMode.colKeyEn = 0x0;
	cPlaneBlndMode.blendMod = 0x2; //0:no alpha , 2: global alpha, 3: pixel alpha
	smtDMSetCBlndMode(&cPlaneBlndMode);
	
	//4. set plane control register
	cPlaneCfg.xEn 		= 0x1;
	cPlaneCfg.pixFmt 	= pixFmt;//0:8BPP,1:RGB332 2:ARGB(1555) 3:RGB565
	cPlaneCfg.gammaEn	= 0x0;
	cPlaneCfg.sWidth 	= CURSOR_WIDTH;
	cPlaneCfg.sHeight	= CURSOR_HEIGHT;
	smtDMSetCCtrl(&cPlaneCfg);
	
	return SMT_SUCCESS;
}

/*------------------------------------------------------------------------------
	Function name	: smt2DMGraphicOn()
	Prototype		: smtUint32 smt2DMGraphicOn(smtUint32 frameAddr, smtUint32 stride, smtUint8 pixFmt)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtUint32 smt2DMGraphicOn(smtUint32 frameAddr, smtUint32 stride, smtUint8 pixFmt)
{
	DMPlaneCtrl gPlaneCfg;
	DMPlaneBlnd gPlaneBlnd;
	DMPlaneBlndMode gPlaneBlndMode;
	
	//1. set chromakey/alpha value(BLEND)
	//	- BLEND register
	gPlaneBlnd.alpha	= 0xFF;
	gPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetGBlnd(&gPlaneBlnd);
	
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
	smtDMSetGBlndMode(&gPlaneBlndMode);
	
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
	smtDMSetGCtrl(&gPlaneCfg);
	
	return SMT_SUCCESS;
}

/*------------------------------------------------------------------------------
	Function name	: smt2DMVideoOn()
	Prototype		: smtUint32 smt2DMVideoOn(smtUint32 frameAddr, smtUint32 stride, smtUint8 pixFmt)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtUint32 smt2DMVideoOn(smtUint32 frameAddr, smtUint32 stride, smtUint8 pixFmt)
{
	DMPlaneCtrl vPlaneCfg;
	DMPlaneBlnd vPlaneBlnd;
	DMPlaneBlndMode vPlaneBlndMode;

	//1. set chromakey/alpha value(BLEND)
	//	- BLEND register
	vPlaneBlnd.alpha	= 0xFF;
	vPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetVBlnd(&vPlaneBlnd);
	
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
	smtDMSetVBlndMode(&vPlaneBlndMode);
	
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
	smtDMSetVCtrl(&vPlaneCfg);
	
	return SMT_SUCCESS;
}
#if 0//shkim-20070116 :further work
void smt2DMNumModes(void);
void smt2DMSetMode(/*INT modeId,	HPALETTE *palette*/);
void smt2DMGetModeInfo(/*GPEMode *pMode,	INT modeNumber*/);
void smt2DMLine(/*GPELineParms *lineParameters, EGPEPhase phase*/);
void smt2DMBltPrepare(/*GPEBltParms *blitParameters*/);
void smt2DMBltComplete(/*GPEBltParms *blitParameters*/);
void smt2DMGetGraphicsCaps();
#endif

