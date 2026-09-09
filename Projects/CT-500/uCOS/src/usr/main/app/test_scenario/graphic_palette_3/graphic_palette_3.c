/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : graphic_palette_3.c 
	Description : graphic palette test functions
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
#define BLACK				0xff000000
#define RED					0xffff0000
#define GREEN				0xff00ff00
#define YELLOW				0xffffff00
#define BLUE				0xff0000ff
#define CYAN				0xffff00ff
#define MAGENTA				0xff00ffff
#define WHITE				0xffffffff
#define __CURSOR_PALETTE_TEST__

static void DisplayGraphicPalette(void);
static void DMChgPalAlpah(smtUint8 alphaVal);
/*
//////////////////////////////////////////////////////////////////////////////
        FUNCTION
//////////////////////////////////////////////////////////////////////////////
*/
/*----------------------------------------------------------
	Function name	: graphicPaletteTest()
	Prototype		: smtUint32 graphicPaletteTest(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 graphicPaletteTest(void)
{
	smtUint32 errCode = SMT_SUCCESS;
	smtUint8 alphaVal =0;
	DMPlaneBlndMode cPlaneBlndMode,gPlaneBlndMode;
	DMPlaneCtrl cPlaneCtrl;

	DMVEncEnable();
	DMEnable();
	DMSyncEnable();
	
	DisplayGraphicPalette();
	#ifdef __CURSOR_PALETTE_TEST__
	DMCursorOn(CURSOR_BASEADDR, 0, 0x0);

	smtDMGetCBlndMode(&cPlaneBlndMode);
	cPlaneBlndMode.blendMod = 0x3;//alpha per pixel
	smtDMSetCBlndMode(cPlaneBlndMode);
	#else
	DMGraphicOn(GRAPHIC_BASEADDR, 0, 0x0);
	smtDMGetGBlndMode(&gPlaneBlndMode);
	gPlaneBlndMode.blendMod = 0x3;//alpha per pixel
	smtDMSetGBlndMode(gPlaneBlndMode);
	#endif

	smt2UartPrint(11,"press 'a' to change pixel alpha value\n");
	while(1)
	{
		smtUint8 uart_input = 0;

		if(UARTDataAvailable())
		{
			uart_input = smt2UartGetCh(0);
			if(uart_input == '0')
			{
				break;
			}
			else if(uart_input == 'a')//increase pixel alpha value
			{
				alphaVal++;
				DMChgPalAlpah(alphaVal);
				smt2UartPrint(11,"pixel alpha value [%d]\n",alphaVal);
			}
		}
	}
	#ifdef __CURSOR_PALETTE_TEST__
	DMDisable(CURSOR_PLANE_DISABLE);
	#else
	DMDisable(GRAPHIC_PLANE_DISABLE);
	#endif
	DMVEncDisable();
	return errCode;
}

/*----------------------------------------------------------
	Function name	: DisplayGraphicPalette()
	Prototype		: static void DisplayGraphicPalette(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static void DisplayGraphicPalette(void)
{
	smtInt32 i, j;
	#ifdef __CURSOR_PALETTE_TEST__
	smtUint32 *frame = (smtUint32 *)CURSOR_BASEADDR;
	#else
	smtUint32 *frame = (smtUint32 *)GRAPHIC_BASEADDR;
	#endif

	DMPlanePalette palette;

	// set palette memory
	#ifdef __CURSOR_PALETTE_TEST__
	palette.palAddr = 0x0;
	palette.palData = BLACK & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetCPalette(palette);

	palette.palAddr = 0x1;
	palette.palData = BLUE & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetCPalette(palette);

	palette.palAddr = 0x2;
	palette.palData = GREEN & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetCPalette(palette);

	palette.palAddr = 0x3;
	palette.palData = CYAN & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetCPalette(palette);

	palette.palAddr = 0x4;
	palette.palData = RED & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetCPalette(palette);

	palette.palAddr = 0x5;
	palette.palData = MAGENTA & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetCPalette(palette);

	palette.palAddr = 0x6;
	palette.palData = YELLOW & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetCPalette(palette);

	palette.palAddr = 0x7;
	palette.palData = WHITE & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetCPalette(palette);
	#else
	palette.palAddr = 0x0;
	palette.palData = BLACK & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetGPalette(palette);

	palette.palAddr = 0x1;
	palette.palData = BLUE & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetGPalette(palette);

	palette.palAddr = 0x2;
	palette.palData = GREEN & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetGPalette(palette);

	palette.palAddr = 0x3;
	palette.palData = CYAN & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetGPalette(palette);

	palette.palAddr = 0x4;
	palette.palData = RED & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetGPalette(palette);

	palette.palAddr = 0x5;
	palette.palData = MAGENTA & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetGPalette(palette);

	palette.palAddr = 0x6;
	palette.palData = YELLOW & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetGPalette(palette);

	palette.palAddr = 0x7;
	palette.palData = WHITE & 0x00ffffff;
	palette.palData |= (0xFF << 24);
	smtDMSetGPalette(palette);
	#endif
	// prepare indexed bmp
	for(i = 0; i < FRAME_HEIGHT; i++)
	{
		//GPIOWrite(i);
		SMT_WRITE(GPIO0_OUT, i);

		for(j = 0; j < FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x00000000;
		
		for(; j < 2*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x01010101;
		
		for(; j < 3*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x02020202;
		
		for(; j < 4*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x03030303;
		
		for(; j < 5*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x04040404;
		
		for(; j < 6*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x05050505;
		
		for(; j < 7*FRAME_WIDTH/8/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x06060606;
		
		for(; j < FRAME_WIDTH/4; j++)
			*(frame+i*FRAME_WIDTH/4+j) = 0x07070707;
		
	}
}
static void DMChgPalAlpah(smtUint8 alphaVal)
{
	DMPlanePalette palette;
	palette.palData = (alphaVal & 0xFF)<<24;
	#ifdef __CURSOR_PALETTE_TEST__
	palette.palAddr = 0x0;
	palette.palData |= BLACK & 0x00ffffff;
	
	smtDMSetCPalette(palette);

	palette.palAddr = 0x1;
	palette.palData = (alphaVal & 0xFF)<<24;
	palette.palData |= BLUE & 0x00ffffff;
	smtDMSetCPalette(palette);

	palette.palAddr = 0x2;
	palette.palData = (alphaVal & 0xFF)<<24;
	palette.palData |= GREEN & 0x00ffffff;
	smtDMSetCPalette(palette);

	palette.palAddr = 0x3;
	palette.palData = (alphaVal & 0xFF)<<24;
	palette.palData |= CYAN & 0x00ffffff;
	smtDMSetCPalette(palette);

	palette.palAddr = 0x4;
	palette.palData = (alphaVal & 0xFF)<<24;
	palette.palData |= RED & 0x00ffffff;
	smtDMSetCPalette(palette);

	palette.palAddr = 0x5;
	palette.palData = (alphaVal & 0xFF)<<24;
	palette.palData |= MAGENTA & 0x00ffffff;
	smtDMSetCPalette(palette);

	palette.palAddr = 0x6;
	palette.palData = (alphaVal & 0xFF)<<24;
	palette.palData |= YELLOW & 0x00ffffff;
	smtDMSetCPalette(palette);

	palette.palAddr = 0x7;
	palette.palData = (alphaVal & 0xFF)<<24;
	palette.palData |= WHITE & 0x00ffffff;
	smtDMSetCPalette(palette);
	#else
	palette.palAddr = 0x0;
	palette.palData = (alphaVal & 0xFF)<<24;
	palette.palData |= BLACK & 0x00ffffff;
	smtDMSetGPalette(palette);

	palette.palAddr = 0x1;
	palette.palData = (alphaVal & 0xFF)<<24;
	palette.palData |= BLUE & 0x00ffffff;
	smtDMSetGPalette(palette);

	palette.palAddr = 0x2;
	palette.palData = (alphaVal & 0xFF)<<24;
	palette.palData |= GREEN & 0x00ffffff;
	smtDMSetGPalette(palette);

	palette.palAddr = 0x3;
	palette.palData = (alphaVal & 0xFF)<<24;
	palette.palData |= CYAN & 0x00ffffff;
	smtDMSetGPalette(palette);

	palette.palAddr = 0x4;
	palette.palData = (alphaVal & 0xFF)<<24;
	palette.palData |= RED & 0x00ffffff;
	smtDMSetGPalette(palette);

	palette.palAddr = 0x5;
	palette.palData = (alphaVal & 0xFF)<<24;
	palette.palData |= MAGENTA & 0x00ffffff;
	smtDMSetGPalette(palette);

	palette.palAddr = 0x6;
	palette.palData = (alphaVal & 0xFF)<<24;
	palette.palData |= YELLOW & 0x00ffffff;
	smtDMSetGPalette(palette);

	palette.palAddr = 0x7;
	palette.palData = (alphaVal & 0xFF)<<24;
	palette.palData |= WHITE & 0x00ffffff;
	smtDMSetGPalette(palette);
	#endif

}
