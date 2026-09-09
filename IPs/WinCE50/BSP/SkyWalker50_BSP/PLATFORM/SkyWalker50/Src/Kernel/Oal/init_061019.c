//
// Copyright (c) Microsoft Corporation.  All rights reserved.
//
//
// Use of this source code is subject to the terms of the Microsoft end-user
// license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
// If you did not accept the terms of the EULA, you are not authorized to use
// this source code. For a copy of the EULA, please see the LICENSE.RTF on your
// install media.
//
//------------------------------------------------------------------------------
//
//  File:  init.c
//
//  SMT SKYWALKER board initialization code.
//
#include <bsp.h>

#include "bitmap.c" 
static void InitDisplay(void);
extern DWORD CEProcessorType;
void ConfigureGPIO(void);



//------------------------------------------------------------------------------
//
//  Function:  OEMInit
//
//  This is Windows CE OAL initialization function. It is called from kernel
//  after basic initialization is made.
//
void OEMInit()
{
    OALMSG(OAL_FUNC, (L"+OEMInit\r\n"));

    CEProcessorType=PROCESSOR_STRONGARM; // Need to be modified by DJKIM 2006/10/10

    // Set memory size for DrWatson kernel support
    dwNKDrWatsonSize = 128 * 1024;

    // Initilize cache globals
    OALCacheGlobalsInit();

    OALLogSerial(
        L"DCache: %d sets, %d ways, %d line size, %d size\r\n", 
        g_oalCacheInfo.L1DSetsPerWay, g_oalCacheInfo.L1DNumWays,
        g_oalCacheInfo.L1DLineSize, g_oalCacheInfo.L1DSize
    );
    OALLogSerial(
        L"ICache: %d sets, %d ways, %d line size, %d size\r\n", 
        g_oalCacheInfo.L1ISetsPerWay, g_oalCacheInfo.L1INumWays,
        g_oalCacheInfo.L1ILineSize, g_oalCacheInfo.L1ISize
    );
    
    // Initialize interrupts
    if (!OALIntrInit()) {
        OALMSG(OAL_ERROR, (
            L"ERROR: OEMInit: failed to initialize interrupts\r\n"
        ));
    }

    // Initialize system clock
    OALTimerInit(1, 17, 0);	//SMT926A_PCLK/245/16/1000=16.992

    ConfigureGPIO();

    InitDisplay();

    // Initialize the KITL connection if required
    OALKitlStart();

    OALMSG(OAL_FUNC, (L"-OEMInit\r\n"));
}

//------------------------------------------------------------------------------

static void InitDisplay(void)
{
    volatile SMT926A_IOPORT_REG *smtIOP = (SMT926A_IOPORT_REG *)OALPAtoVA(SMT926A_BASE_REG_PA_IOPORT, FALSE);
    volatile SMT926A_LCD_REG    *smtLCD = (SMT926A_LCD_REG *)OALPAtoVA(SMT926A_BASE_REG_PA_LCD, FALSE);
    unsigned int clkval_calc;  // 040507
    // Set up the LCD controller registers to display a power-on bitmap image.
    //
    smtIOP->GPCUP     = 0xFFFFFFFF;
    smtIOP->GPCCON    = 0xAAAAAAAA;
                                    
    smtIOP->GPEDAT    = 0x1;
    smtIOP->GPDUP     = 0xFFFFFFFF;
    smtIOP->GPDCON    = 0xAAAAAAA1; 

    clkval_calc = (WORD)((float)(SMT926A_HCLK)/(2.0*5000000)+0.5)-1;
    smtLCD->LCDCON1   =  (clkval_calc           <<  8) |       /* VCLK = HCLK / ((CLKVAL + 1) * 2) -> About 7 Mhz  */
                           (LCD_MVAL   <<  7)  |       /* 0 : Each Frame                                   */
                           (3           <<  5) |       /* TFT LCD Pannel                                   */
                           (12          <<  1) |       /* 16bpp Mode                                       */
                           (0           <<  0) ;       /* Disable LCD Output                               */

    smtLCD->LCDCON2   =  (LCD_VBPD        << 24) |   /* VBPD          :   1                              */
                           (LCD_LINEVAL_TFT << 14) |   /* Vertical Size : 320 - 1                          */
                           (LCD_VFPD        <<  6) |   /* VFPD          :   2                              */
                           (LCD_VSPW        <<  0) ;   /* VSPW          :   1                              */

    smtLCD->LCDCON3   =  (LCD_HBPD        << 19) |   /* HBPD          :   6                              */
                           (LCD_HOZVAL_TFT  <<  8) |   /* HOZVAL_TFT    : 240 - 1                          */
                           (LCD_HFPD        <<  0) ;   /* HFPD          :   2                              */


    smtLCD->LCDCON4   =  (LCD_MVAL        <<  8) |   /* MVAL          :  13                              */
                           (LCD_HSPW        <<  0) ;   /* HSPW          :   4                              */

    smtLCD->LCDCON5   =  (0           << 12) |       /* BPP24BL       : LSB valid                        */
                           (1           << 11) |       /* FRM565 MODE   : 5:6:5 Format                     */
                           (0           << 10) |       /* INVVCLK       : VCLK Falling Edge                */
                           (1           <<  9) |       /* INVVLINE      : Inverted Polarity                */
                           (1           <<  8) |       /* INVVFRAME     : Inverted Polarity                */
                           (0           <<  7) |       /* INVVD         : Normal                           */
                           (0           <<  6) |       /* INVVDEN       : Normal                           */
                           (0           <<  5) |       /* INVPWREN      : Normal                           */
                           (0           <<  4) |       /* INVENDLINE    : Normal                           */
                           (1           <<  3) |       /* PWREN         : Disable PWREN                    */
                           (0           <<  2) |       /* ENLEND        : Disable LEND signal              */
                           (0           <<  1) |       /* BSWP          : Swap Disable                     */
                           (1           <<  0) ;       /* HWSWP         : Swap Enable                      */

    smtLCD->LCDSADDR1 = ((IMAGE_FRAMEBUFFER_DMA_BASE >> 22)     << 21) | 
                          ((M5D(IMAGE_FRAMEBUFFER_DMA_BASE >> 1)) <<  0);

    smtLCD->LCDSADDR2 = M5D((IMAGE_FRAMEBUFFER_DMA_BASE + (LCD_XSIZE_TFT * LCD_YSIZE_TFT * 2)) >> 1);

    smtLCD->LCDSADDR3 = (((LCD_XSIZE_TFT - LCD_XSIZE_TFT) / 1) << 11) | (LCD_XSIZE_TFT / 1);        

    //smtLCD->TCONSEL   |= 0x3;
    smtLCD->TCONSEL   &= (~7);
    smtLCD->TCONSEL   |= (0x1<<4);

    smtLCD->TPAL      = 0x0;        
    smtLCD->LCDCON1  |= 1;

    // Display a bitmap image on the LCD...
    //
    memcpy((void *)IMAGE_FRAMEBUFFER_UA_BASE, ScreenBitmap, LCD_ARRAY_SIZE_TFT_16BIT);

}


void ConfigureGPIO()
{
    volatile SMT926A_IOPORT_REG *smtIOP = (SMT926A_IOPORT_REG *)OALPAtoVA(SMT926A_BASE_REG_PA_IOPORT, FALSE);
    volatile SMT926A_CLKPWR_REG *smtCLKPWR = (SMT926A_CLKPWR_REG *)OALPAtoVA(SMT926A_BASE_REG_PA_CLOCK_POWER, FALSE);

    smtIOP->GPACON    = 0x7fffff;

    smtIOP->GPBDAT    = 0x62;
    smtIOP->GPBUP     = 0x7FF;
    smtIOP->GPBCON    = 0x2A96A4;

    smtIOP->GPCUP     = 0xFFFF;
    smtIOP->GPCCON    = 0xAAAAAAAA;
                                    
    smtIOP->GPEDAT    = 0x1;
    smtIOP->GPDUP     = 0xFFFF;
    smtIOP->GPDCON    = 0xAAAAAAA1;
    
    smtIOP->GPEDAT    = 0x0;
    smtIOP->GPEUP     = 0xFFFF;
    smtIOP->GPECON    = 0xAAAAAAAA;
    
    smtIOP->GPFDAT    = 0xF0;
    smtIOP->GPFUP     = 0xFF;
    smtIOP->GPFCON    = 0x55aa;
    
    smtIOP->GPGDAT    = 0x1000;
    smtIOP->GPGUP     = 0xFEFF;
    smtIOP->GPGCON    = 0x0480FFBA;
    smtIOP->GPGDAT    |= 0x1<<12;
    smtIOP->GPGUP     |= 0x1<<12;
    smtIOP->GPGCON    = (smtIOP->GPGCON & ~(0x3<<24)) | 0x1<<24;

    smtIOP->GPHDAT    = 0x0;
    smtIOP->GPHUP     = 0x7FF;
    smtIOP->GPHCON    = 0x14AAAA;

    smtIOP->GPJDAT    = 0x1000;
    smtIOP->GPJUP     = 0x1FFF;
    smtIOP->GPJCON    = 0x1AAAAA;

    smtIOP->MISCCR &= ~(7<<20);
    smtIOP->MISCCR |= (4<<20);
    smtIOP->MISCCR &= ~(7<<8);
    smtIOP->MISCCR |= (5<<8);
    smtIOP->MISCCR &= ~(7<<4);
    smtIOP->MISCCR |= (5<<4);
    smtIOP->MISCCR |= (3<<0);
}
