/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : lcd_pre_drv.h 
	Description : lcd pre-layer header file
	Created by  : SHMT SOC Team
------------------------------------------------------------------------------*/
#ifndef __LCD_PRE_DRV_H__
#define __LCD_PRE_DRV_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "global.h"
#include "commonmacro.h"
#include "sysinc.h"

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

/*------------------------------------------------------------------------------
	LCD controller
------------------------------------------------------------------------------*/
typedef enum
{
	BACKGROUND_PLANE,
	CURSOR_PLANE,
	GRAPHIC_PLANE,
	VIDEO_PLANE,
	PLANE_END
	
} DMPlane;

typedef enum
{
	GAMMA_IDX0,
	GAMMA_IDX1,
	GAMMA_IDX2,
	GAMMA_IDX3,
	GAMMA_IDX4,
	GAMMA_IDX5,
	GAMMA_IDX6,
	GAMMA_IDX7,
	GAMMA_IDX8,
	GAMMA_IDX9,
	GAMMA_IDX10,
	GAMMA_IDX11,
	GAMMA_IDX12,
	GAMMA_IDX13,
	GAMMA_IDX14,
	GAMMA_IDX15,
	GAMMA_IDX16,
	GAMMA_IDX_END

} DMGammaIdx;

typedef struct
{
	smtBoolean prioritySel;		// Plane position
	smtBoolean errIntEn;
	smtBoolean startIntEn;		// Interrupt enable
	smtBoolean endIntEn;
	smtBoolean swReset;			// SW reset
} DMCtrl;

typedef struct
{
	smtBoolean	evenFieldInt;	// Even field Interrupt
	smtBoolean	cDmaFifoErr;	// Cursor plane DMA fifo error
	smtBoolean	vDmaFifoErr;	// Video plane DMA fifo error
	smtBoolean	gDmaFifoErr;	// Graphic plane DMA fifo error

	smtBoolean	cFifoErr;		// Cursor plane fifo error
	smtBoolean	vFifoErr;		// Video plane fifo error
	smtBoolean	gFifoErr;		// Graphic plane fifo error

	// Further work by shkim 2006/12/04. bit[10:5]. Redundant bit name.

	smtBoolean	mixFifoErr;		// Mixer fifo error
	smtBoolean	startFrame;		// frame start
	smtBoolean	endFrame;		// End of frame status
	/* need padding */
} DMStatus;

//COMMON STRUCT FOR ALL PLANES (CURSOR,GRAPHIC,VIDEO).
typedef struct
{
	smtUint16	sWidth;		// Width
	smtUint16	sHeight;	// Height
	smtUint8	pixFmt;		// Pixel format
	smtBoolean	xEn;		// C/V/Graphic plane enable
	smtBoolean	gammaEn; 	// Gamma enable. Only for graphic/video plane.
	smtBoolean	gColBarEn;
	smtBoolean	vPlaneIFEn; // video plane only.
	smtBoolean	vPlaneN2PUpEn;// video plane only.
} DMPlaneCtrl;

typedef struct
{
	smtUint32	colKey;		// Color key value
	smtUint8	alpha;		// Alpha-blending value
	/* need padding */
} DMPlaneBlnd;

typedef struct
{
	smtUint16	xPos;	//plane x position
	smtUint16	yPos;	//plane y position
	smtBoolean	colKeyEn;	// Color key enable
	smtUint8	blendMod;	// Blending mode select
} DMPlaneBlndMode;

typedef struct
{
	smtUint32	palData;	// Palette data
	smtUint8	palAddr;	// Palette addr
} DMPlanePalette;

typedef struct
{
	smtBoolean	lcdEn;			// LCD sync enable
	smtBoolean	lcdPwrEn;		// LCD/Video data out enable
	smtUint8	lcdBpp;			// LCD pixel format
	smtBoolean	rbSwap;			// R/B swaP ENABLE
	smtBoolean	invertWrEn;		// Invert write enable
	smtBoolean	invertVSync;	// Invert Vsync
	smtBoolean	invertHSync;	// Invert Hsync
	smtBoolean	invertPixClk;	// Invert pixel clock
	smtUint8	pDiv;			// Phase divide
} DMLcdCtrl;

typedef struct
{
	smtUint8	tHBackPorch;	// Horizontal back porch
	smtUint8	tHFrontPorch;	// Hrrizontal front porch
} DMHSync0Ctrl;

typedef struct
{
	smtUint16	tHPulsWidth;	// Horizontal sync pulse width
	smtUint16	tHDspPixPerLine;// display pixel per line
} DMHSync1Ctrl;

typedef struct
{
	smtUint8	tVBackPorch;	// Vertical back porch
	smtUint8	tVFrontPorch;	// Vertical front porch
} DMVSync0Ctrl;

typedef struct
{
	smtUint16	tVDspPeriod;	// Line display period
	smtUint8	tVPulsWidth;	// Vertical sync pulse width
} DMVSync1Ctrl;

/*------------------------------------------------------------------------------
		LCD CONTROLLER
------------------------------------------------------------------------------*/
void smtDMSetMasterCtrl(DMCtrl *pMaCtrl);
void smtDMGetMasterCtrl(DMCtrl *pMaCtrl);
void smtDMGetMasterStatus(DMStatus *pMaStat);

//CURSOR PLANE
void smtDMSetCCtrl(DMPlaneCtrl *pCtrl);
void smtDMGetCCtrl(DMPlaneCtrl *pCtrl);
void smtDMSetCBlndMode(DMPlaneBlndMode *pBlndMode);
void smtDMGetCBlndMode(DMPlaneBlndMode *pBlndMode);
void smtDMSetCBlnd(DMPlaneBlnd *pblnd);
void smtDMGetCBlnd(DMPlaneBlnd *pblnd);
void smtDMSetCBase(smtUint16 planeXRef);
void smtDMGetCBase(smtUint16 *pPlaneXRef);
void smtDMSetCAddr(smtUint32 addr);
void smtDMGetCAddr(smtUint32 *pAddr);
void smtDMSetCPalette(DMPlanePalette *pPalette);
void smtDMGetGPalette(DMPlanePalette *pPalette);

//GRAPHIC PLANE
void smtDMSetGCtrl(DMPlaneCtrl *pCtrl);
void smtDMGetGCtrl(DMPlaneCtrl *pCtrl);
void smtDMSetGBlndMode(DMPlaneBlndMode *pBlndMode);
void smtDMGetGBlndMode(DMPlaneBlndMode *pBlndMode);
void smtDMSetGBlnd(DMPlaneBlnd *pblnd);
void smtDMGetGBlnd(DMPlaneBlnd *pblnd);
void smtDMSetGBase(smtUint16 planeXRef);
void smtDMGetGBase(smtUint16 *pPlaneXRef);
void smtDMSetGAddr(smtUint32 addr);
void smtDMGetGAddr(smtUint32 *pAddr);
void smtDMSetGGamma(smtUint8 idx, smtUint32 gammaVal);
void smtDMGetGGamma(smtUint8 idx, smtUint32 *pGammaVal);
void smtDMSetGPalette(DMPlanePalette *pPalette);
void smtDMGetGPalette(DMPlanePalette *pPalette);

//VIDEO PLANE
void smtDMSetVCtrl(DMPlaneCtrl *pCtrl);
void smtDMGetVCtrl(DMPlaneCtrl *pCtrl);
void smtDMSetVBlndMode(DMPlaneBlndMode *pBlndMode);
void smtDMGetVBlndMode(DMPlaneBlndMode *pBlndMode);
void smtDMSetVBlnd(DMPlaneBlnd *pblnd);
void smtDMGetVBlnd(DMPlaneBlnd *pblnd);
void smtDMSetVBase(smtUint16 planeXRef);
void smtDMGetVBase(smtUint16 *pPlaneXRef);
void smtDMSetVAddr(smtUint32 addr);
void smtDMGetVAddr(smtUint32 *pAddr);
void smtDMSetVAddr2(smtUint32 addr2);
void smtDMGetVAddr2(smtUint32 *pAddr2);
void smtDMSetVGamma(smtUint8 idx, smtUint32 gammaVal);
void smtDMGetVGamma(smtUint8 idx, smtUint32 *pGammaVal);

void smtDMSetBGCol(smtUint32 colour);
void smtDMGetBGCol(smtUint32 *pColour);

void smtDMSetLCDCtrl(DMLcdCtrl *pCtrl);
void smtDMGetLCDCtrl(DMLcdCtrl *pCtrl);

void smtDMSetHSync0(DMHSync0Ctrl *pHSync0);
void smtDMGetHSync0(DMHSync0Ctrl *pHSync0);
void smtDMSetHSync1(DMHSync1Ctrl *pHSync1);
void smtDMGetHSync1(DMHSync1Ctrl *pHSync1);

void smtDMSetVSync0(DMVSync0Ctrl *pVSync0);
void smtDMGetVSync0(DMVSync0Ctrl *pVSync0);
void smtDMSetVSync1(DMVSync1Ctrl *pVSync1);
void smtDMGetVSync1(DMVSync1Ctrl *pVSync1);

#endif//__LCD_PRE_DRV_H__
