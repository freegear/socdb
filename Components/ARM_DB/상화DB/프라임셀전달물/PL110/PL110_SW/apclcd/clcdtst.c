/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2000,2001,2002,2003 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     clcdtst.c,v
 * Revision: 1.31
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : clcdtst.c.rca
 *  File Revision          : 1.4
 * 
 *  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
 *  ----------------------------------------
  +
  +          PrimeCell Color LCD Device Drivers test code
  +          ============================================
*/

#include <stdio.h>
#include <stdlib.h>
#include "../apcommon/aptypes.h"
#include "../apcommon/apbitops.h"
#include "../apos/apos.h"
#include "../aptest/aptest.h"
#include "apclcd.h"
#include "apdraw.h"
#include "clR8x8.h"

#if (defined (apCLCD_VERSION) && (apCLCD_VERSION ==  PL111))
extern void CLCD_CursorInitialize(apOS_CLCD_oId oId, apCLCD_eCursorSize eCursorSize);
extern void CLCD_CursorMove(apOS_CLCD_oId oId, WORD32 X, WORD32 Y);
extern void CLCD_CursorDisable(apOS_CLCD_oId oId);
extern void CLCD_CursorChangeSize(apOS_CLCD_oId oId, apCLCD_eCursorSize eCursorSize);
#endif

/******************************************************************************\
* System parameters                                                            *
\******************************************************************************/

// Declarations defining specific LCD panels
#define CLCD_LTM10C209H   1
#define CLCD_CITIZEN38    2
#define CLCD_SHARPLQ084V1DG21 3
// Add more here as needed

    /*** Select the one we're using ***/
//#define PANEL CLCD_CITIZEN38
//#define PANEL CLCD_LTM10C209H
#define PANEL CLCD_SHARPLQ084V1DG21

#define FRAME_RATE (45)

// The memory area that the PrimeCell uses for its screen data
#define CLCD_SCREEN_BASE   ((UWORD32)0xc2000000)
// NOTES:
//  Care should be taken selecting the location of the memory used for
//  the frame buffer. The prototype Integrator version can only DMA from the
//  onboard SSRAM on the logic module.

// The test program either loops through all possible Bits Per Pixel (BPP)
// values, or can be compiled to use a single setting.
// In the latter case FIXED_BPP should be set to the value required
// eg:
#define FIXED_BPP 4                  // Test only 4 BPP

/* Function prototype for Test entry function */
PROTECTED apTEST_eResult apCLCD_SelfTest( UWORD32 Id,
                                          UWORD32 uCellBase,
                                          UWORD32 NumSources,
                                          CONST apOS_INT_oInterruptSource * CONST pInt);
                                       
// To allow the user to handle interrupts as he wishes, we put in a handler
//PRIVATE void CLCD_IntCallback(apCLCD_eInterrupts condition);


/**********************************************\
** Static variables
\**********************************************/

PRIVATE WORD32 BaseCount = 0;               // Counter for Base Address Interrupts
PRIVATE WORD32 FrameCount = 0;              // Counter for VComp Interrupts
PRIVATE volatile BOOL Event = FALSE;

/******************************************************************************\
*                           PANEL DESCRIPTIONS                                 *
* Declaration of the parameters for the LCD panels in use.                     *
* This structure should be fully populated, and is kept up to date by the      *
* driver if calls are made to alter the configuration.                         *
* The only values that are up dated at run-time are eBpp and eRefresh          *
\******************************************************************************/


#if PANEL == CLCD_SHARPLQ084V1DG21

/******************************************************************************\
* Start of Sharp LQ084V1DG21 declarations                                     *
\******************************************************************************/

//#define LCD_CLOCK_SPEED (5 * 1000 * 1000)   // 5MHz clock in use for the panel
//#define LCD_CLOCK_SPEED (15 * 1000 * 1000)  // 15MHz clock in use for the panel
#define LCD_CLOCK_SPEED (25 * 1000 * 1000)  // 25MHz clock in use for the panel

#define SCREEN_WIDTH    (640)
#define SCREEN_HEIGHT   (480)

#define POWER_UP_DEL    (20)
#define POWER_DOWN_DEL  (20)

#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
PRIVATE void SharpPreamble(void);
PRIVATE void SharpSwitchOff(void);
PRIVATE void SharpSwitchOn(void);
#endif

PRIVATE apCLCD_sDisplayParams sParams =
{
    apCLCD_TFT,                  /* eType;        LCD display type                   */
    apCLCD_RGB,                  /* eColorOrder;  RGB or BGR                         */
    apCLCD_RELOAD_EARLY,         /* eReload;      FIFO reload timing                 */
    apCLCD_INTERNAL_CLOCK,       /* eClockSource; LCD clock source                   */
    0,                           /* ACBias;       number of line clock periods       */
                                 /*               between each toggle of AC-bias pin */
    apCLCD_LCDFP_H,              /* eVSyncActive; LcdFP pin active state             */
    apCLCD_LCDLP_H,              /* eHSyncActive; LcdLP pin active state             */
    apCLCD_CLCP_R,               /* eDataDrive;   edge data driven on                */
    apCLCD_CLAC_H,               /* eTftClac;     CLAC pin setting in TFT mode       */
    0,                           /* ClleDelay;    Delay before line end pulse...     */

    apCLCD_STN_COLOR,            /* eColorType;   STN LCD color type                 */
    apCLCD_STN_4BIT,             /* eInterface;   STN LCD x-bit interface            */
    apCLCD_STN_SINGLE,           /* ePanel;       STN LCD panel type                 */
    LCD_CLOCK_SPEED,             /* Clock;        LCD controller clock in Hz         */
    25,                          /* VSync;        vertical sync pulse width          */
    7,                           /* VFront;       vertical front porch               */
    36,                          /* VBack;        vertical back porch                */
    64,                          /* HSync;        horizontal sync pulse width        */
    65,                          /* HFront;       horizontal front porch             */
    33,                          /* HBack;        horizontal back porch              */

    FRAME_RATE,                  /* Refresh;      LCD screen refresh rate in Hz      */
    apCLCD_VSYNC,                /* eVCInterTime; LCD VComp interrupt timing         */
    
    CLCD_SCREEN_BASE,            /* DMABase;      Base address of screen memory      */
    SCREEN_WIDTH,                /* LineWidth;    line length, multiple of 16 pixels */
    SCREEN_HEIGHT,               /* NumLines;     total height of the screen         */
    apCLCD_LITTLE_ENDIAN_BYTES,  /* ePixelOrder;  pixel ordering within a byte       */
    apCLCD_8BPP,         /* eBpp;         bits per pixel                     */
    
/****** Some LCD panel specific bits ******/
#ifndef apCLCD_NO_POWERUP_DELAY
    POWER_UP_DEL,       /* PwerUpDel;    Delay between LcdEn & LcdPwr on    */
#endif
    POWER_DOWN_DEL,     /* PwerDownDel;  Delay from LcdPwr off to LcdEn off */
#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
                        /**** LCD panel specific setup functions ****/
    SharpPreamble,    /* rPreamble;    Right at the start                 */
    SharpSwitchOff,   /* rSwitchOff;   Special sequence for power off     */
    SharpSwitchOn     /* rSwitchOn;    Special sequence for power on      */
#endif
};


#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
/******************************************************************************\
* Panel-specific functions                                                     *
\******************************************************************************/

/******************************************************************************\
* Start up sequence                                                            *
\******************************************************************************/

PRIVATE void SharpPreamble(void)
{   
}

/******************************************************************************\
* Power on sequence                                                            *
\******************************************************************************/
PRIVATE void SharpSwitchOn(void)
{
}

/******************************************************************************\
* Power off sequence                                                           *
\******************************************************************************/
PRIVATE void SharpSwitchOff(void)
{
}
#endif

/******************************************************************************\
* End of Sharp LQ084V1D621 declarations                                       *
\******************************************************************************/
#endif                  // End of Sharp declarations

#if PANEL == CLCD_LTM10C209H
/******************************************************************************\
* Start of Toshiba LTM10C209H declarations                                     *
\******************************************************************************/

                                // Integrator clock control registers & values
#define CLOCK_UNLOCK    ((volatile UWORD32 *)0x1100001c)
#define CLOCK_SET       ((volatile UWORD32 *)0x11000004)
#define CLK_UNLOCK_VAL  (UWORD32)(0xa05f)
#define CLK_LOCK_VAL    (0)

#define LCD_CLOCK_SPEED (16 * 1000 * 1000)          // The clock in use for the panel
#define SCREEN_WIDTH    (640)
#define SCREEN_HEIGHT   (480)
#define POWER_UP_DEL    (10)
#define POWER_DOWN_DEL  (10)

#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
// In order to accommodate specific hardware requirements on start-up, power-up
// and power-down, user-provided functions are called at these points.
// These are the prototypes.
PRIVATE void ToshibaPreamble(void);         // Called before anything happens

#endif

PRIVATE apCLCD_sDisplayParams sParams =
{
    apCLCD_TFT,                  /* eType;        LCD display type                   */
    apCLCD_RGB,                  /* eColorOrder;  RGB or BGR                         */
    apCLCD_RELOAD_EARLY,         /* eReload;      FIFO reload timing                 */
    apCLCD_INTERNAL_CLOCK,       /* eClockSource; LCD clock source                   */
    0,                           /* ACBias;       number of line clock periods       */
                                 /*               between each toggle of AC-bias pin */
    apCLCD_LCDFP_H,              /* eVSyncActive; LcdFP pin active state             */
    apCLCD_LCDLP_H,              /* eHSyncActive; LcdLP pin active state             */
    apCLCD_CLCP_R,               /* eDataDrive;   edge data driven on                */
    apCLCD_CLAC_H,               /* eTftClac;     CLAC pin setting in TFT mode       */
    0,                           /* ClleDelay;    Delay before line end pulse...     */

    apCLCD_STN_COLOR,            /* eColorType;   STN LCD color type                 */
    apCLCD_STN_4BIT,             /* eInterface;   STN LCD x-bit interface            */
    apCLCD_STN_SINGLE,           /* ePanel;       STN LCD panel type                 */
    LCD_CLOCK_SPEED,             /* Clock;        LCD controller clock in Hz         */
    10,                          /* VSync;        vertical sync pulse width          */
    7,                           /* VFront;       vertical front porch               */
    9,                           /* VBack;        vertical back porch                */
    64,                          /* HSync;        horizontal sync pulse width        */
    65,                          /* HFront;       horizontal front porch             */
    33,                          /* HBack;        horizontal back porch              */

    FRAME_RATE,                  /* Refresh;      LCD screen refresh rate in Hz      */
    apCLCD_VSYNC,                /* eVCInterTime; LCD VComp interrupt timing         */
    
    CLCD_SCREEN_BASE,            /* DMABase;      Base address of screen memory      */
    SCREEN_WIDTH,                /* LineWidth;    line length, multiple of 16 pixels */
    SCREEN_HEIGHT,               /* NumLines;     total height of the screen         */
    apCLCD_LITTLE_ENDIAN_BYTES,  /* ePixelOrder;  pixel ordering within a byte       */
    apCLCD_8BPP,         /* eBpp;         bits per pixel                     */
    
/****** Some LCD panel specific bits ******/
    POWER_UP_DEL,       /* PwerUpDel;    Delay between LcdEn & LcdPwr on    */
    POWER_DOWN_DEL,     /* PwerDownDel;  Delay from LcdPwr off to LcdEn off */
#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
                        /**** LCD panel specific setup functions ****/
    ToshibaPreamble,    /* rPreamble;    Right at the start                 */
    aRNULL,             /* rSwitchOff;   Special sequence for power off     */
    aRNULL              /* rSwitchOn;    Special sequence for power on      */
#endif
};


#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
/******************************************************************************\
* Panel-specific functions                                                     *
\******************************************************************************/

/******************************************************************************\
* This preamble assumes the PrimeCell is clocked from the Integrator           *
\******************************************************************************/
PRIVATE void ToshibaPreamble(void)
{
    *CLOCK_UNLOCK = CLK_UNLOCK_VAL;
    *CLOCK_SET    = LCD_CLOCK_SPEED * 4 / (1000 * 1000) - 8;
    *CLOCK_UNLOCK = CLK_LOCK_VAL;
}
#endif

/******************************************************************************\
* End of Toshiba LTM10C209H declarations                                       *
\******************************************************************************/
#endif

#if PANEL == CLCD_CITIZEN38

/******************************************************************************\
* Start of Citizen K3240H-FR declarations                                      *
\******************************************************************************/
//#define LCD_CLOCK_SPEED (5 * 1000 * 1000)   // 5MHz clock in use for the panel
#define LCD_CLOCK_SPEED (15 * 1000 * 1000)  // 15MHz clock in use for the panel
#define SCREEN_WIDTH    (320)
#define SCREEN_HEIGHT   (240)

#define POWER_UP_DEL    (100)
#define POWER_DOWN_DEL  (10)

#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
PRIVATE void CitizenPreamble(void);
PRIVATE void CitizenSwitchOff(void);
PRIVATE void CitizenSwitchOn(void);
#endif

PRIVATE apCLCD_sDisplayParams sParams =
{
    apCLCD_STN,                  /* eType;        LCD display type                   */
    apCLCD_RGB,                  /* eColorOrder;  RGB or BGR                         */
    apCLCD_RELOAD_EARLY,         /* eReload;      FIFO reload timing                 */
    apCLCD_INTERNAL_CLOCK,       /* eClockSource; LCD clock source                   */
    4,                           /* ACBias;       number of line clock periods       */
                                 /*               between each toggle of AC-bias pin */

    apCLCD_LCDFP_H,              /* eVSyncActive; LcdFP pin active state             */
    apCLCD_LCDLP_H,              /* eHSyncActive; LcdLP pin active state             */
    apCLCD_CLCP_R,               /* eDataDrive;   edge data driven on                */
    apCLCD_CLAC_H,               /* eTftClac;     CLAC pin setting in TFT mode       */
    0,                           /* ClleDelay;    Delay before line end pulse...     */

    apCLCD_STN_COLOR,            /* eColorType;   STN LCD color type                 */
    apCLCD_STN_8BIT,             /* eInterface;   STN LCD x-bit interface            */
    apCLCD_STN_SINGLE,           /* ePanel;       STN LCD panel type                 */
    LCD_CLOCK_SPEED,             /* Clock;        LCD controller clock in Hz         */
    1,                           /* VSync;        vertical sync pulse width          */
    0,                           /* VFront;       vertical front porch               */
    0,                           /* VBack;        vertical back porch                */
    20,                          /* HSync;        horizontal sync pulse width        */
    20,                          /* HFront;       horizontal front porch             */
    20,                          /* HBack;        horizontal back porch              */

    FRAME_RATE,                  /* Refresh;      LCD screen refresh rate in Hz      */
    apCLCD_VSYNC,                /* eVCInterTime; LCD VComp interrupt timing         */
    
    CLCD_SCREEN_BASE,            /* DMABase;      Base address of screen memory      */
    SCREEN_WIDTH,                /* LineWidth;    line length, multiple of 16 pixels */
    SCREEN_HEIGHT,               /* NumLines;     total height of the screen         */
    apCLCD_LITTLE_ENDIAN_BYTES,  /* ePixelOrder;  pixel ordering within a byte       */
    apCLCD_4BPP,                 /* eBpp;         bits per pixel                     */

/****** Some LCD panel specific bits ******/
    POWER_UP_DEL,       /* PwerUpDel;    Delay between LcdEn & LcdPwr on    */
    POWER_DOWN_DEL,     /* PwerDownDel;  Delay from LcdPwr off to LcdEn off */
#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
                        /**** LCD panel specific setup functions ****/
    CitizenPreamble,    /* rPreamble;    Right at the start                 */
    CitizenSwitchOff,   /* rSwitchOff;   Special sequence for power off     */
    CitizenSwitchOn     /* rSwitchOn;    Special sequence for power on      */
#endif
};


#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
/******************************************************************************\
* Panel-specific functions                                                     *
\******************************************************************************/

/******************************************************************************\
* This preamble assumes the PrimeCell's  clock source is on the logic module   *
* and its oscilator divider is at 0xc0300000. It also selects a multiplexor at *
* address 0xc0300018 which alters the output connections to the display. It    *
* finally switches off the panel using another device at address 0xc030001C    *
\******************************************************************************/

PRIVATE void CitizenPreamble(void)
{   
/*** The Citizen FPGA Core module has its own clock generator. Set it up ***/
    *(volatile UWORD32*)0xc0300008=0xa05f;         // pixclk unlock
//    *(volatile UWORD32*)0xc0300000=0x61C07;      // pixclk set to 5MHz
    *(volatile UWORD32*)0xc0300000=0x20807;        // pixclk set to 15MHz
/*** It also has a multiplexor to select the ouput connections ***/
    *(volatile UWORD32*)0xc0300018=0x5;            // Select LCD 2
/*** Force the way the enable & power signals work ***/
    *(volatile UWORD32*)0xc030001C=0x0;            // VDD OFF, Display OFF
}

/******************************************************************************\
* Switch on the panel via the device at address 0xc030001C on the core module  *
* This over-rides the action of the LcdEn and LcdPwr Control register bits     *
\******************************************************************************/
PRIVATE void CitizenSwitchOn(void)
{   volatile int i;

    for (i = 0; i < 30000; ++i)	
    {   *(volatile UWORD32*)0xc030001C=0x1;         // VDD ON, Display OFF
    }
    *(volatile UWORD32*)0xc030001C=0x3; // VDD ON, Display ON  
}

/******************************************************************************\
* Switch off the panel via the core module device at address 0xc030001C        *
* This over-rides the action of the LcdEn and LcdPwr Control register bits     *
\******************************************************************************/
PRIVATE void CitizenSwitchOff(void)
{   volatile int i;

    for (i = 0; i < 30000; ++i)	
    {   *(volatile UWORD32*)0xc030001C=0x1;         // VDD ON, Display OFF
    }
    *(volatile UWORD32*)0xc030001C=0x0;             // VDD OFF, Display OFF
}
#endif

/******************************************************************************\
* End of Citizen38 declarations                                                *
\******************************************************************************/
#endif


/****************** END OF PANEL DECLARATIONS *********************************/

/******************************************************************************\
* Description: Example callback to handle interrupt events. This is installed  *
* as the User callback in apCLCD_Demo()                                        *
* apCLCD_FUF and apCLCD_MBERR are not expected, and are reported, while        *
* apCLCD_NEXT_BASE_UP and apCLCD_VCOMP are specifically tested.
\******************************************************************************/
PRIVATE void CLCD_IntCallback(apCLCD_eInterrupts condition)
{
    switch (condition)
    {
        case apCLCD_FUF:
//            apTEST_BufferedPrint("Interrupt: FIFO Underflow\n");
            return;

        case apCLCD_MBERR:
            apTEST_BufferedPrint("Interrupt: Bus error\n");
            return;

        case apCLCD_NEXT_BASE_UP:
            BaseCount--;                        // Free-running count
            return;

        case apCLCD_VCOMP:       // Used here to signal a number of frames
            if(FrameCount-- == 0)               // Free-running count
                Event = TRUE;
            return;

        case apCLCD_CURSOR:
        
            return;
        
        default:
            apTEST_BufferedPrint("Interrupt: unknown callback condition");
    }
}

/******************************************************************************\
* Description: Function to generate a simple colour palette for all bpps > 2   *
* should not be called if Bpp < 4                                              *
\******************************************************************************/
PRIVATE void CLCD_PaletteInitialise(apCLCD_sPalette * palette, UWORD32 Bpp)
{
    if(Bpp == 4)                    // A simple no-nonsense approach!!
    {
        palette[0].sRgb.Red =                                   // Black
                palette[0].sRgb.Green =
                    palette[0].sRgb.Blue = 0;
        apTEST_BufferedPrint("Colour 0 is Black\n");

        palette[1].sRgb.Red =                                   // Dark Grey
                palette[1].sRgb.Green =
                    palette[1].sRgb.Blue = 85;
        apTEST_BufferedPrint("Colour 1 is Dark Grey\n");

        palette[2].sRgb.Red =                                   // Dirty White
                palette[2].sRgb.Green =
                    palette[2].sRgb.Blue = 170;
        apTEST_BufferedPrint("Colour 2 is Dirty White\n");

        palette[3].sRgb.Red =                                   // Bright white
                palette[3].sRgb.Green =
                    palette[3].sRgb.Blue = 255;
        apTEST_BufferedPrint("Colour 3 is Bright White\n");

        palette[4].sRgb.Red = 128;                              // Dark Red
        palette[4].sRgb.Green = palette[4].sRgb.Blue = 0;
        apTEST_BufferedPrint("Colour 4 is Dark Red\n");

        palette[5].sRgb.Red = 255;                              // Red
        palette[5].sRgb.Green = palette[5].sRgb.Blue = 0;
        apTEST_BufferedPrint("Colour 5 is Red\n");

        palette[6].sRgb.Green = 128;                            // Dark Green
        palette[6].sRgb.Red = palette[6].sRgb.Blue  = 0;
        apTEST_BufferedPrint("Colour 6 is Dark Green\n");

        palette[7].sRgb.Green = 255;                            // Green
        palette[7].sRgb.Red = palette[7].sRgb.Blue  = 0;
        apTEST_BufferedPrint("Colour 7 is Green\n");

        palette[8].sRgb.Blue = 128;                             // Dark Blue
        palette[8].sRgb.Green = palette[8].sRgb.Red  = 0;
        apTEST_BufferedPrint("Colour 8 is Dark Blue\n");

        palette[9].sRgb.Blue = 255;                             // Blue
        palette[9].sRgb.Green = palette[9].sRgb.Red  = 0;
        apTEST_BufferedPrint("Colour 9 is Blue\n");

        palette[10].sRgb.Green = 0;                             // Dark Magenta
        palette[10].sRgb.Red = palette[10].sRgb.Blue  = 128;
        apTEST_BufferedPrint("Colour 10 is Dark Magenta\n");

        palette[11].sRgb.Green = 0;                             // Magenta
        palette[11].sRgb.Red = palette[11].sRgb.Blue  = 255;
        apTEST_BufferedPrint("Colour 11 is Magenta\n");

        palette[12].sRgb.Blue = 0;                              // Brown
        palette[12].sRgb.Green = palette[12].sRgb.Red  = 128;
        apTEST_BufferedPrint("Colour 12 is Brown\n");

        palette[13].sRgb.Blue = 0;                              // Yellow
        palette[13].sRgb.Green = palette[13].sRgb.Red  = 255;
        apTEST_BufferedPrint("Colour 13 is Yellow\n");

        palette[14].sRgb.Red = 0;                               // Dark Cyan
        palette[14].sRgb.Green = palette[14].sRgb.Blue = 128;
        apTEST_BufferedPrint("Colour 14 is Dark Cyan\n");

        palette[15].sRgb.Red = 0;                               // Cyan
        palette[15].sRgb.Green = palette[15].sRgb.Blue = 255;
        apTEST_BufferedPrint("Colour 15 is Cyan\n");
    }        
    else    // A more sophisticated one, but we don't know what colours we get
    {
        UWORD32 gb = (Bpp + 2) / 3;         // Use 1/3 rounded up of the bits for green
        UWORD32 rb =  Bpp / 3;              // Use 1/3 of the bits for red
        UWORD32 bb =  Bpp - rb -gb;         // Use what's left for blue
        WORD32 i;

        // Define widths for a color palette spread as evenly as we can manage
        for (i = ((WORD32)1 << (rb + gb + bb)) - (WORD32)1; i >= 0; --i)
        {   
            palette[i].sRgb.Red = (UBYTE8)((255 * apBIT_GET_FIELD(i, rb, 0)) / (((UWORD32)1 << rb) - 1));
            palette[i].sRgb.Green = (UBYTE8)((255 * apBIT_GET_FIELD(i, gb, rb)) / (((UWORD32)1 << gb) - 1));
            palette[i].sRgb.Blue = (UBYTE8)((255 * apBIT_GET_FIELD(i, bb, rb + gb)) / (((UWORD32)1 << bb) -1 ));
        }
    }
}

/******************************************************************************\
* Description: Function to generate a simple greyscale palette for bpps < 4    *
* should not be called if Bpp > 2                                              *
\******************************************************************************/
PRIVATE void CLCD_GreyscalePalette(apCLCD_sPalette *palette, UWORD32 Bpp)
{
    int i;

    for(i = (1 << Bpp) - 1; i >= 0; --i)           // A uniform grey scale
    {
        palette[i].sRgb.Red = palette[i].sRgb.Green = palette[i].sRgb.Blue = (UBYTE8)(255 * i / ((1 << Bpp) - 1));
    }
}

/******************************************************************************\
* Description: Function that waits for the required number of VComp interrupts *
\******************************************************************************/
PRIVATE void CLCD_WaitVSyncInt(UWORD32 Syncs)
{
    Event = FALSE;
    FrameCount = Syncs;

    while(Event == FALSE)
    {   ;
    }
}

/******************************************************************************\
* Description: Checks the operation of the specified VComp interrupt           *
* The required interrupt is enabled, and a check is made whether interrupts    *
* are expected from the settings. The action is then checked.                  *
* Returns TRUE if interrupts are as expected, FALSE otherwise                  * 
\******************************************************************************/
PRIVATE BOOL CLCD_CountVComps(apOS_CLCD_oId oId, 
                                 apCLCD_eVComp_ITime eVCompEvent
                                )
{   BOOL IntExpected;

    apCLCD_InterruptEventsEnable(oId, apCLCD_VCOMP);
    IntExpected = apCLCD_VCompEventsEnable(oId, eVCompEvent);   // Select event
    if(IntExpected == FALSE)            // Front & back porches may not happen
    {
        apTEST_BufferedPrint("no interrupts expected\n");
    }
    else
    {
        apTEST_BufferedPrint("interrupts expected\n");
    }            
    FrameCount = 1000;
    apOS_TIMER_Wait(3 * 1000*1000);         // Count interrupts for 3 seconds
    if(FrameCount == 1000)                  // FrameCount unchanged?
    {                                       // No interrupts
        if(IntExpected == TRUE)
        {
            apTEST_BufferedPrint("No interrupts\n");
            return FALSE;
        }
    }
    else                                            // Interrupts detected
    {   
        if(IntExpected == FALSE)
        {
            apTEST_BufferedPrint("Got unexpected interrupts\n");
            return FALSE;
        }
    }
    apTEST_BufferedPrint("Interrupts as expected\n");
    return TRUE;
}
    

/******************************************************************************\
* Operation:    Check the interrupts                                           *
* Parameters:   ID of the specific device attached to the PrimeCell            *
* Returns:      TRUE if all OK, FALSE otherwise                                *
* Description:  First checks the next base address uodate interrupt, then each *
*               each variety of VComp interrupt in turn. The tests are done by *
*               counting interrupts during a 3 seconds period.                 * 
\******************************************************************************/
PRIVATE BOOL CLCD_CheckInterruptsOK(apOS_CLCD_oId oId)
{
    BOOL TheResult = TRUE;                              // Assume all OK

    apCLCD_sPalette palette[256];                           // The palette
                                // Power off LCD before changing parameters...
    apCLCD_PowerDown(oId);      // ...to be sure we know where we are
    apCLCD_BppSet(oId, 2);                          // Set up driver for 2 BPP
    CLCD_GreyscalePalette(palette, 2);
    apCLCD_PaletteSet(oId, palette, 4);
    apDRAW_CLS(oId, 3);                                    // Set to white

    if( apCLCD_PowerUp(oId) != apERR_NONE)                    // Power up the color LCD (safely)
    {
        apTEST_BufferedPrint("\nVComp timeout on PowerUp\n");
        apCLCD_InterruptsDisable(oId);
        return FALSE;
    }
    apCLCD_InterruptsDisable(oId);              // Clear all interrupts
    
    apTEST_BufferedPrint("\nTesting Base address interrupts\n");
    BaseCount = 1000;                           // Set it up
    apCLCD_InterruptEventsEnable(oId, apCLCD_NEXT_BASE_UP);
    apOS_TIMER_Wait(3 * 1000*1000);        // Count interrupts for 3 seconds
    if(BaseCount == 1000)
    {
        apTEST_BufferedPrint("**** Base address interrupts failed\n");
        TheResult = FALSE;
    }
    else
    {
        apTEST_BufferedPrint("Base address interrupts OK\n");
    }
    apCLCD_InterruptEventsDisable(oId, apCLCD_NEXT_BASE_UP);
    
    apTEST_BufferedPrint("\nTesting Vertical Compare interrupts\n");

    apTEST_BufferedPrint("Vertical sync: ");
    if(CLCD_CountVComps(oId, apCLCD_VSYNC) == FALSE)
    {
        apTEST_BufferedPrint("**** Vertical Sync interrupts failed\n");
        TheResult = FALSE;              // These should always happen
    }
    else
    {
        apTEST_BufferedPrint("Vertical Sync interrupts OK\n");
    }
                                // Back porch interrupts may not happen
    apTEST_BufferedPrint("Back porch: ");
    if(CLCD_CountVComps(oId, apCLCD_BACK_P) == FALSE)
    {
        apTEST_BufferedPrint("**** Back Porch interrupts failed\n");
        TheResult = FALSE;
    }
    else
    {
        apTEST_BufferedPrint("Back Porch interrupts OK\n");
    }

    apTEST_BufferedPrint("Active video: ");
    if(CLCD_CountVComps(oId, apCLCD_ACTIVE_V) == FALSE)
    {
        apTEST_BufferedPrint("**** Active video interrupts failed\n");
        TheResult = FALSE;
    }
    else
    {
        apTEST_BufferedPrint("Active video interrupts OK\n");
    }

    apTEST_BufferedPrint("Front porch: ");
    if(CLCD_CountVComps(oId, apCLCD_FRONT_P) == FALSE)
    {
        apTEST_BufferedPrint("**** Front Porch interrupts failed\n");
        TheResult = FALSE;
    }
    else
    {
        apTEST_BufferedPrint("Front Porch interrupts OK\n");
    }
    apTEST_BufferedPrint("Vertical Compare interrupt tests complete\n");
    apCLCD_InterruptEventsDisable(oId, apCLCD_VCOMP);
    return TheResult;
}

/******************************************************************************\
* Operation: Set a sequence of refresh rates. Report the value requested and   *
*            the value actually set. Measures & reports the real frame rate.   *
* NOTE: The refresh rate is set using a clock divisor. This is a small integer *
*       and so the result can be grossly different from the value requested.   *
\******************************************************************************/
PRIVATE void CLCD_TestRefreshRates(apOS_CLCD_oId oId)
{
    UWORD32 Refresh;

    apCLCD_InterruptEventsEnable(oId, apCLCD_VCOMP);
    apCLCD_VCompEventsEnable(oId, apCLCD_VSYNC);        // Enable Vsync events

    apTEST_BufferedPrint("\nCheck a range of refresh rates\n");
    for(Refresh = 5; Refresh <= 125; Refresh += 20)
    {
        UWORD32 TheRate = apCLCD_RefreshSet(oId, Refresh);
        UWORD32 Frames;

        apTEST_Report("\nNominal:  ", Refresh, apTEST_FORMAT_LONG_DEC);
        apTEST_Report("Actual:   ", TheRate, apTEST_FORMAT_LONG_DEC);
        FrameCount = 1000;                        // Make sure it won't wrap
        apOS_TIMER_Wait(3 * 1000*1000);             // Count 3 second's worth
        Frames = 1000 - FrameCount;
        apTEST_Report("Measured: ", Frames / 3, apTEST_FORMAT_LONG_DEC);
    }
}

/******************************************************************************\
* Operation:    Check drawing and writing to the panel                         *
* Parameters:   ID of the specific device attached to the PrimeCell            *
* Description:  draws a line and some characters to the LCD                    *
\******************************************************************************/
PRIVATE void CLCD_CheckDrawing(apOS_CLCD_oId oId, UWORD32 Bpp)
{
    t2DPoint p1 = {4, 4}, p2 = {SCREEN_WIDTH - 4, SCREEN_HEIGHT / 2};
    tFont TestFont;
    UWORD32 count;
    
    TestFont['a'][0] = 0;  // ........
    TestFont['a'][1] = 56; // ..xxx...
    TestFont['a'][2] = 4;  // .....x..
    TestFont['a'][3] = 60; // ..xxxx..
    TestFont['a'][4] = 68; // .x...x..
    TestFont['a'][5] = 68; // .x...x..
    TestFont['a'][6] = 58; // ..xxx.x.
    TestFont['a'][7] = 0;  // ........

    p1.x += 1;
    apDRAW_DrawLine(oId, &p1, &p2, 0);
    apTEST_WaitKey("\nA line drawn across the top half of LCD", 3);

    p1.x = 7; p1.y = 15;
    p2.x = SCREEN_WIDTH / 2; p2.y = SCREEN_HEIGHT / 2;
    apDRAW_RectFill(oId, &p1, &p2, 0x0);
    apDRAW_SetPixelToColor(oId, &p1, 4);
    apDRAW_SetPixelToColor(oId, &p2, 4);
    apTEST_WaitKey("\nA rectangle in the top half of LCD", 3);

    p1.x = 9; p1.y = 23;
    apDRAW_FontRender(oId, &p1, 'a', TestFont, ((UWORD32)1 << Bpp)-1,0);
    apDRAW_FontRender(oId, &p1, 'a', TestFont, ((UWORD32)1 << Bpp)-1,0);

    /* Display complete font */
    for (count = 0; count < 128; count++)
    {
        p1.x = (UWORD32)((UWORD32)count & 31) * 8 + 11;
        p1.y = (UWORD32)((UWORD32)count / 32) * 8 + (SCREEN_HEIGHT * 5 / 8);
        apDRAW_FontRender(oId, &p1, (UBYTE8)count, font_clR8x8, ((UWORD32)1<<Bpp)-1,0);
    }
    apTEST_WaitKey("\nThe character set in the lower half of LCD", 3);
    
}   
/******************************************************************************\
* Description:  Perform the basic test sequence for given BPP                  *
* Parameters:   ID of the specific device attached to the PrimeCell            *
*               Resolution to be used (In BPP)                                 *
* Operation:    Sets up Bpp and writes screen to a series of colours           *
\******************************************************************************/
PRIVATE apTEST_eResult CLCD_Test(apOS_CLCD_oId oId, UWORD32 Bpp)
{
    WORD32 i;
    UWORD32 OneSec = sParams.Refresh;
    apError Result;
    
    apCLCD_sPalette palette[256];                           // The palette
                                // Power off LCD before changing parameters...
    apCLCD_PowerDown(oId);      // ...to be sure we know where we are
                                        // Do test for required BPP
    if((Result = apCLCD_BppSet(oId, Bpp)) != apERR_NONE)
    {
        apTEST_Report("\nBPP setting not available ",
                      Bpp,
                      apTEST_FORMAT_LONG_DEC
                     );
        return apTEST_FAIL;
    }
    if(Bpp < 16)                                // Will it use the palette?
    {
        if(Bpp > 2)                             // Will the palette be colour?
            CLCD_PaletteInitialise(palette, Bpp);
        else
            CLCD_GreyscalePalette(palette, Bpp);
        
        // Load new palette into the PrimeCell
        Result = apCLCD_PaletteSet(oId, palette, (UWORD32)1 << Bpp);
        if(Result != apERR_NONE)
        {
            apTEST_BufferedPrint("Attempt to set invalid palette");
            return apTEST_FAIL;
        }
    }
    apDRAW_CLS(oId, 0);

    if (apCLCD_PowerUp(oId) != apERR_NONE)                    // Power up the color LCD (safely)
    {
        apTEST_BufferedPrint("\nPower Up failed\n");
        return apTEST_FAIL;
    }
    if(Bpp < 16)                                // For these a palette is needed
    {
        WORD32 Increment = (Bpp == 8) ? 4 : 1;  // Reduce tests for large BPP
                                                // Test with selected colours
        for(i = 0; i < ((UWORD32)1 << Bpp); i += Increment)
        {
            apDRAW_CLS(oId, i);                 // Write panel to single colour
            apTEST_Report("Screen color ", i, apTEST_FORMAT_LONG_DEC);
            CLCD_WaitVSyncInt(OneSec);
        }
    }
    else                                        // Direct write for 16 & 24 BPP
    {   
        for(i = 0; i < 0x20; i += 4)                    // Quick Bluescale
        {
            apDRAW_CLS(oId, i);
            apTEST_Report("Screen color ", i, apTEST_FORMAT_LONG_DEC);
            apOS_TIMER_Wait(1000*100);          // Wait 1/10s for each color
        }
        for (i=0; i < 0x400; i+= 0x80)                  // Quick Greenscale
        {
            apDRAW_CLS(oId, i);
            apTEST_Report("Screen color ", i, apTEST_FORMAT_LONG_DEC);
            apOS_TIMER_Wait(1000*100);
        }
        for (i=0; i < 0x8000; i+= 0x100)                // Quick Redscale
        {
            apDRAW_CLS(oId, i);
            apTEST_Report("Screen color ", i, apTEST_FORMAT_LONG_DEC);
            apOS_TIMER_Wait(1000*100);
        }
    }
    
    CLCD_CheckDrawing(oId, Bpp);

#if (defined (apCLCD_VERSION) && (apCLCD_VERSION == PL111))
    // Test Hardware Cursor functions
    apDRAW_CLS(oId, 0);

    CLCD_CursorInitialize(oId, apCLCD_CURSOR_SIZE_32);
    apTEST_WaitKey("\n32x32 Cursor displayed in centre of screen ", 3);

    CLCD_CursorChangeSize(oId, apCLCD_CURSOR_SIZE_64);
    CLCD_CursorMove(oId, SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    apCLCD_CursorOn(oId);
    apTEST_WaitKey("\n64x64 Cursor displayed in centre of screen ", 3);

    CLCD_CursorMove(oId, 0, 0);
    apTEST_WaitKey("\n Cursor move to top left corner ", 3);

    CLCD_CursorMove(oId, SCREEN_WIDTH, SCREEN_HEIGHT - 2);
    apTEST_WaitKey("\n Cursor move to bottom right corner ", 3);

    CLCD_CursorDisable(oId);
#endif

    apTEST_Report("CLCD Test: FINISHED test at ", Bpp, apTEST_FORMAT_LONG_DEC);
    apOS_TIMER_Wait(1000*1000);
    return apTEST_PASS;
}


/******************************************************************************\
* Operation:    Carry out the basic test for all required BPP settings         *
* Parameters:   ID of the specific device attached to the PrimeCell            *
* Description:  Work out a sensible range of BPP and cycle through them        *
\******************************************************************************/
PRIVATE apTEST_eResult CLCD_eTestSequence(apOS_CLCD_oId oId)
{
    apTEST_eResult eTestResult = apTEST_FAIL;       // Default to test fail
    UWORD32 ThisBpp, StartBpp, EndBpp;

    if(CLCD_CheckInterruptsOK(oId) == TRUE)
    {
        eTestResult = apTEST_PASS;
    }
    else
    {
        return apTEST_FAIL;
    }
        /* Enable unexpected interrupts. They will be reported if they happen */
    apCLCD_InterruptEventsEnable(oId, apCLCD_FUF | apCLCD_MBERR);

    CLCD_TestRefreshRates(oId);

#ifdef FIXED_BPP
    StartBpp = EndBpp = FIXED_BPP;              // This is the only one to use
    if(sParams.eType == apCLCD_STN)
    {
        if(   (sParams.eColorType == apCLCD_STN_COLOR && FIXED_BPP > 16)
           || (sParams.eColorType == apCLCD_STN_MONO && FIXED_BPP > 4)
           )
        {
            EndBpp = 0;                             // Can't be done, nobble it
            eTestResult = apTEST_FAIL;
            apTEST_Report("This panel does not support the bits per pixel: ", StartBpp, apTEST_FORMAT_LONG_DEC);
        }
    }            
#else
    StartBpp = 1;                                   // Lowest possible BPP
    if(sParams.eType == apCLCD_TFT)
    {
        EndBpp = 32;                                // TFT can do then all
    }
    else if(sParams.eColorType == apCLCD_STN_COLOR)
    {
        EndBpp = 16;                                // STN colour max is 16bpp
    }
    else
    {
        EndBpp = 4;                                 // STN mono max is 4bpp
    }
#endif
                                                
    /*** The test uses the Vsync interrupt to pause for each colour ***/
    apCLCD_InterruptEventsEnable(oId, apCLCD_VCOMP);    // Allow synch updates
    apCLCD_VCompEventsEnable(oId, apCLCD_VSYNC);        // Select Vsync event

/*** Cycle through the determined BPP settings ***/
    for(ThisBpp = StartBpp; ThisBpp <= EndBpp; ThisBpp *= 2)
    {
        if(ThisBpp == 32)               // 32 doesn't exist, largest is 24
        {
            ThisBpp = 24;
            apTEST_BufferedPrint("\n Insufficient memory on logic module for test at 32 BPP \n");
            break;
        }
        apTEST_Report("\nRunning BPP test at: ", ThisBpp, apTEST_FORMAT_LONG_DEC);

        if(CLCD_Test(oId, ThisBpp) == apTEST_FAIL)      // Musn't conceal fails
        {
            apTEST_BufferedPrint("**** BPP test failed\n");
            eTestResult = apTEST_FAIL;
        }
        else
        {
            apTEST_BufferedPrint("BPP test passed\n");
        }
    }

    apCLCD_InterruptsDisable(oId);
    apCLCD_PowerDown(oId);

    return eTestResult;
}


/******************************************************************************\
* Operation:    Main entry point to the test program                           *
* Parameters:   Base address of PrimeCell (Where registers are to be found)    *
*               Pointer to interrupt source(s)                                 *
* Returns:      The test result, either pass or fail                           *
* Description:  This is called via a Macro in applatfm.h that looks like       *
*               this:                                                          *
*                   TEST_MODULE(CLCD, apOS_SYSTEM_BASE_CLCD, apOS_INT_LMCLCD); *
*               This establishes the Base address and interrupt value for the  *
*               PrimeCell and the Driver is initialised following the rules of *
*               the PrimeCell Software Drivers System Design.                  *
\******************************************************************************/
PUBLIC apTEST_eResult apCLCD_SelfTest( UWORD32 Id,UWORD32 uCellBase,UWORD32 NumSources,
                                       CONST apOS_INT_oInterruptSource * CONST pInt
                                       )
{
    apTEST_eResult eTestResult = apTEST_FAIL; 
    apOS_CLCD_oId oId=(apOS_CLCD_oId) Id;
    apError Result;
    
    apCLCD_Initialize( oId,
                       (apOS_System_eBaseAddress)uCellBase,
                       NumSources,
                       (apOS_INT_oInterruptSource *)pInt,
                       aNULL
                     );

    // Panel-specific PrimeCell initialisation    
    if((Result = apCLCD_PanelInitialize(oId, &sParams)) == apERR_NONE)
    {
        apCLCD_RegisterCallback(oId, CLCD_IntCallback);
        eTestResult = CLCD_eTestSequence(oId);
#if defined(apOS_NO_STATIC_STATE) && (apOS_NO_STATIC_STATE)
        free((void *)oId);
#endif
    }
    else if(Result == apCLCD_INCORRECT_WIDTH)
    {
        apTEST_BufferedPrint("Display line not a multiple of 16\n");
    }
    else if(Result == apCLCD_INVALID_DISPLAY_TYPE)
    {
        apTEST_BufferedPrint("Display Specified invalid or conflicting parameters\n");
    }
    else if(Result == apCLCD_NO_AC_BIAS)
    {
        apTEST_BufferedPrint("AC Bias of zero for an STN display\n");
    }
    else if(Result == apCLCD_NO_SETTING)
    {
        apTEST_BufferedPrint("A required display parameter missing\n");
    }
    return eTestResult;
}
