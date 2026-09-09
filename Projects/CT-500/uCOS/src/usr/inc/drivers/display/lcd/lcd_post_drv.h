/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : lcd_post_drv.h 
	Description : lcd post-layer driver header file
	Created by  : SHMT SOC Team
------------------------------------------------------------------------------*/

#ifndef	__LCD_POST_DRV_H__
#define	__LCD_POST_DRV_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "global.h"
#include "commonmacro.h"
#include "lcd_pre_drv.h"

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
// Further work by shkim 2006/12/04.
// Frame Buffer addr for each plane
#define DM_CUSOR_FRAME_BUF		0x00000000
#define DM_GRAPHIC_FRAME_BUF	0x00000000
#define DM_VIDEO_FRAME_BUF		0x00000000

// LCD size
#define LCD_WIDTH	480
#define LCD_HEIGHT	272

// LCD Sync
#define LCD_HFP	(2  -1)	// Horizontal Front Porch(2 clock)
#define LCD_HSW	(41 -1)	// Horizontal Sync Width(41 clock)
#define LCD_HBP	(2  -1)	// Horizontal Back Porch(2 clock)
#define LCD_CPL (480-1)	// active clocks per line

#define LCD_VFP (4  -1)	// Vertical Front Porch(2 line)
#define LCD_VBP (4  -1)	// Vertical Back Porch(41 line)
#define LCD_VSW (10 -1)	// Vertical Sync Width(2 line)
#define LCD_LPS (272-1)	// active lines per screen

typedef enum 
{
	GPLANE_RGB_8BPP = 0,
	GPLANE_RGB_565,
	GPLANE_RGB_555_1BIT_ALPHA,
	GPLANE_RGB_888,
	GPLANE_RGB_888_8BIT_ALPAH
} DM_GRAPHICS_PIX_FORMAT;

typedef enum
{
	CPLANE_RGB_332 = 0,
	CPLANE_RGB_555_1BIT_ALPHA
} DM_CURSOR_PIX_FORMAT;
typedef enum
{
	DM_CURSOR_PLANE,
	DM_GRAPHIC_PLANE,
	DM_VIDEO_PLANE
}DMPlaneX;
typedef struct
{
	smtUint32 x;
	smtUint32 y;
} DMPoint;

typedef struct 
{
	DMPlaneCtrl		ctrl;
	DMPlaneBlnd		blnd;
	DMPlaneBlndMode	blndMode;
	DMPoint			srcStartPos;//start point from which DM clip the src image
	//base address
	smtUint32		cAddr;
	smtUint16		srcWidth;	//the width of src for calculating stride
	//cursor base
	smtUint16		cPlaneXRef;
} DMCursorPlane;
typedef struct
{
	DMPlaneCtrl		ctrl;
	DMPlaneBlnd		blnd;
	DMPlaneBlndMode	blndMode;
	DMPoint			srcStartPos;//start point from which DM clip the src image
	//graphic plane framebuffer
	smtUint32		gAddr;
	smtUint32		*pGGammaLUT;
	//graphic base
	smtUint16		gPlaneXRef;
	smtUint16		srcWidth;	//the width of src for calculating stride
} DMGraphicPlane;
typedef struct
{
	DMPlaneCtrl		ctrl;
	DMPlaneBlnd		blnd;
	DMPlaneBlndMode	blndMode;
	DMPoint			srcStartPos;//start point from which DM clip the src image
	//video base
	smtUint16		vPlaneXRef;
	smtUint16		srcWidth;	//the width of src for calculating stride
	smtUint16		srcHeight;
	//video framebuffer
	smtUint32		vAddr;
	smtUint32		vAddr2;
	//video gamma	
	smtUint32		*pVGammaLUT;
	//video base
} DMVideoPlane;
typedef struct
{
	DMLcdCtrl		lcdCtrl;//Lcd Control Reg
	DMHSync0Ctrl	hSync0Ctrl;//HSync Control Reg
	DMHSync1Ctrl	hSync1Ctrl;
	DMVSync0Ctrl	vSync0Ctrl;//VSync Control Reg
	DMVSync1Ctrl	vSync1Ctrl;
} DMLcdIFCtrl;
typedef struct
{
//  void (*pLine)(DMLineParms*);
  smtInt32 		xStart;
  smtInt32 		yStart;
  smtInt32 		cPels;
  smtUint32		dM;
  smtUint32		dN;
  smtInt32 		llGamma;
  smtInt32 		iDir;
  smtUint32 	style;
  smtInt32 		styleState;
  smtUint32		*pDst;
#if 0 //shkim-20061206 : todo : need porting  
  COLOR solidColor;
  RECTL* prclClip;
#endif  
  smtUint16 	mix;
} DMLineParms;
typedef struct
{
	DMCursorPlane 	cursorCfg;
	DMGraphicPlane 	graphicCfg;
	DMVideoPlane	videoPlaneCfg;
	smtUint32 		bgColor;
	
}DM_Config;

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

void smt2DMInitializeHardware (DM_Config *pDmConfig);
void smt2DMSetCursorPlane(DMCursorPlane *pCursorCfg);
void smt2DMGetCursorPlane(DMCursorPlane *pCursorConfig);
void smt2DMCursorSetPalette(smtUint32 *colourTable);
void smt2DMCursorOn(void);
void smt2DMCursorOff(void);
void smt2DMCursorSetPointerShape(smtUint32 *pCursorImg, smtUint16 xHot, 
					 smtUint16 yHot, smtUint16 cX, smtUint16 cY);

void smt2DMCursorMovePointer(smtInt16 xPosition, smtInt16 yPosition);
void smt2DMSetGraphicPlane(DMGraphicPlane *pGraphicCfg);
void smt2DMGetGraphicPlane(DMGraphicPlane *pGraphicCfg);
void smt2DMGraphicSetPalette(smtUint32 *colourTable);
void smt2DMGraphicSetGammaLUT(smtUint8 gammaIdx, smtUint32 gammaVal);
void smt2DMGraphicAlphaBlending(int direction, int timeDelay);

void smt2DMSetVideoPlane(DMVideoPlane *pVideoCfg);
void smt2DMGetVideoPlane(DMVideoPlane *pVideoCfg);
void smt2DMVideoSetGammaLUT(smtUint8 gammaIdx, smtUint32 gammaVal);

void smt2DMSetLCDIF(DMLcdIFCtrl *pLcdIFCfg);
void smt2DMWaitForNotBusy(void);
smtBoolean smt2DMIsBusy(void);
smtBoolean smt2DMInVBlank(void);
void smt2DMSWReset(void);
void smt2DMSetBGColor(smtUint32 bgColor);

#endif //__LCD_POST_DRV_H__
