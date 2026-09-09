/*----------------------------------------------------------
	File Name   : apilcd.c 
	Description : LCD controller driver code
	Created by  : SHMT SoC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"
#include "lib.h"
#include "irq.h"
#include "dmac.h"
#include "global.h"

#include "apilcd.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define FRAME_WIDTH 480
#define FRAME_HEIGHT 272

#define LCD_HFP	(2-1)	// Horizontal Front Porch(2 clock)
#define LCD_HSW	(41-1)	// Horizontal Sync Width(41 clock)
#define LCD_HBP	(2-1)	// Horizontal Back Porch(2 clock)
#define LCD_CPL (480-1)	// active clocks per line

#define LCD_VFP (4-1)	// Vertical Front Porch(2 line)
#define LCD_VBP (4-1)	// Vertical Back Porch(41 line)
#define LCD_VSW (10-1)	// Vertical Sync Width(2 line)
#define LCD_LPS (272-1)	// active lines per screen

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void LCDEnable(smtUint32 enablePlane);
void LCDDisable(smtUint32 disablePlane);
void LCDInitialize(void);
void LCDSetMode(LCDSTRUCT lcdMode);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : LCDEnable()
    Prototype       : void LCDEnable(void)
    Return          : 
    Argument        :
    Comments        : Enable LCD 
-----------------------------------------------------------------------*/
void LCDEnable(smtUint32 enablePlane)
{
	smtUint32 enableValue = enablePlane;

	SMT_WRITE(CCON, 0x00000000); // Disable Cursor Plane
	SMT_WRITE(VCON, 0x00000000); // Disable Video Plane
	//SMT_WRITE(GCON, 0xA8000000|((FRAME_WIDTH)<<11)|(FRAME_HEIGHT)); // Enable Graphic Plane
}

/*-----------------------------------------------------------------------
    Function name   : LCDDisable()
    Prototype       : void LCDDisable(void)
    Return          : 
    Argument        :
    Comments        : Disable LCD
-----------------------------------------------------------------------*/
void LCDDisable(smtUint32 disablePlane)
{
	smtUint32 disableValue = disablePlane;

	SMT_WRITE(CCON, 0x00000000); // Disable Cursor Plane
	SMT_WRITE(VCON, 0x00000000); // Disable Video Plane
	SMT_WRITE(GCON, 0x00000000); // Disable Graphic Plane
}

/*-----------------------------------------------------------------------
    Function name   : LCDInitialize()
    Prototype       : void LCDInitialize(void)
    Return          : 
    Argument        :
    Comments        : Initialize the LCD controller
-----------------------------------------------------------------------*/
void LCDInitialize(void)
{
	SMT_WRITE(DMCON, 0x00000002); // Graphic>Video, Int enable
	//SMT_WRITE(BGCOL, 0xfffdfcfb); // Back-ground color
	SMT_WRITE(BGCOL, 0x00000000); // Back-ground color

	SMT_WRITE(CPOS, 0x00000000); // Cursor Position Set
	SMT_WRITE(GPOS, 0x00000000); // Graphic Position Set
	SMT_WRITE(VPOS, 0x00000000); // Video Position Set

	SMT_WRITE(CCON, 0x00000000); // Disable Cursor Plane
	SMT_WRITE(VCON, 0x80000000); // Disable Video Plane
	//SMT_WRITE(GCON, 0xA8000000|((FRAME_WIDTH)<<11)|(FRAME_HEIGHT)); // Enable Graphic Plane
	//SMT_WRITE(GCON, 0xA8000000); // Enable Graphic Plane. 8bit alpha + 24bit RGB
	//SMT_WRITE(GCON, 0xA0000000);	// 24bit RGB
	SMT_WRITE(GCON, 0x90000000); // RGB565

	SMT_WRITE(GBMOD, 0x10000000); // Color key disable, Global alpha
	SMT_WRITE(GBLND, 0xFFFFFFFF); // No alpha, Color key 0xFFFFFF
	//SMT_WRITE(GBASE, ((FRAME_WIDTH/4)<<22)); // Plane position
	SMT_WRITE(GBASE, 0x00000000); // Plane position
	SMT_WRITE(GADDR, 0x00000000); // Graphic memory address
	SMT_WRITE(SCON, 0x00000000); // Disable Scaler

	SMT_WRITE(LECON, 0);
	SMT_WRITE(HSYNC0, (LCD_HBP<<8)|LCD_HFP);
	SMT_WRITE(HSYNC1, (LCD_HSW<<11)|LCD_CPL);
	SMT_WRITE(VSYNC0, (LCD_VBP<<8)|LCD_VFP);
	SMT_WRITE(VSYNC1, (LCD_VSW<<11)|LCD_LPS);
	SMT_WRITE(LCDCON, 0xC0000230);
}

/*-----------------------------------------------------------------------
    Function name   : LCDSetMode()
    Prototype       : void LCDSetMode()
    Return          : 
    Argument        :
    Comments        : Set the LCD mode
-----------------------------------------------------------------------*/
void LCDSetMode(LCDSTRUCT lcdMode)
{
	smtUint32 readData;

	readData = SMT_READ(GCON);

	readData |= lcdMode.pixelFMT<<27;
	readData = readData | (((lcdMode.width)<<11)|(lcdMode.height));
	SMT_WRITE(GCON, readData);
	//SMT_WRITE(GCON, readData | ((lcdMode.width)<<11)|(lcdMode.height));

	SMT_WRITE(GBASE, ((lcdMode.width/4)<<22));
	SMT_WRITE(GADDR, (lcdMode.frameAddr)>>2);
}
