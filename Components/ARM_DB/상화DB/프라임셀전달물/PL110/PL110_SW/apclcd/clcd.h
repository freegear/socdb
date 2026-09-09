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
 * File:     clcd.h,v
 * Revision: 1.16
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : clcd.h.rca
 *  File Revision          : 1.4
 * 
 *  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
 *  ----------------------------------------
 *
 * Private header file for the CLCD (Colour Liquid Crystal Display)
 * controller code.  This file contains the headers for the internal
 * implementation of the code.
*/

#ifndef CLCD_H
#define CLCD_H

#ifdef  __cplusplus
extern "C" {    /* allow C++ to use these headers */
#endif  /* __cplusplus */

/***********************************************************\
* Local manifest constants
\***********************************************************/
/* The number of bits used for each colour */
#define CLCD_PALETTE_GUN_WIDTH   (5)

/* The number of bits we need to create to fill the byte colour values */
#define CLCD_PALETTE_PAD_BITS    (8 - CLCD_PALETTE_GUN_WIDTH)

#define CLCD_PALETTE_PAD_MASK    ((UWORD32)((1 << CLCD_PALETTE_PAD_BITS) - 1))

/* The number of bits in each (hardware) palette entry */
#define CLCD_PALETTE_ENTRY_SIZE  (16)
#define CLCD_HIGH_PALETTE_ENTRY_MASK \
 ((UWORD32)((((UWORD32)1<<CLCD_PALETTE_ENTRY_SIZE)-1)<<CLCD_PALETTE_ENTRY_SIZE))


/******************************************************************************\
* Description:  CLCD register block definition                                 *
* Usage:        Access to all PrimeCell registers                              *
\******************************************************************************/
typedef volatile struct CLCD_xRegisters
{                               /*   DESCRIPTION                          OFFSET */
    UWORD32 Timing0;            /* LCD timing register 0                   0x00  */
    UWORD32 Timing1;            /* LCD timing register 1                   0x04  */
    UWORD32 Timing2;            /* LCD timing register 2                   0x08  */
    UWORD32 Timing3;            /* LCD timing register 3                   0x0c  */
    UWORD32 UpBase;             /* LCD upper panel frame base address      0x10  */
    UWORD32 LpBase;             /* LCD lower panel frame base address      0x14  */

    UWORD32 IntrEnable;         /* LCD Interrupt enable mask register      0x18  */
    UWORD32 Control;            /* LCD control register                    0x1c  */

    UWORD32 RawIntStatus;       /* LCD raw interrupt status register       0x20  */
    UWORD32 MaskIntStatus;      /* LCD masked interrupt status register    0x24  */
#if (defined (apCLCD_VERSION) && ((apCLCD_VERSION == PL110) || (apCLCD_VERSION == PL111)))
    UWORD32 IntrClear;          /* LCD interrupt clear register            0x28  */
    UWORD32 UpCurr;             /* LCD upper panel current address         0x2c  */
    UWORD32 LpCurr;             /* LCD lower panel current address         0x30  */
    BYTE8   Pad[0x200-0x34];    /* Reserved                                0x34  */
#else
    UWORD32 UpCurr;             /* LCD upper panel current address         0x28  */
    UWORD32 LpCurr;             /* LCD lower panel current address         0x2c  */
    BYTE8   Pad[0x200-0x30];    /* Reserved                                0x30  */
#endif

    UWORD32 Palette[128];       /* 128 word-wide palette entries           0x200 */

#if (defined (apCLCD_VERSION) && (apCLCD_VERSION == PL111))
    BYTE8   Pad_1[0x800-0x400]; /* Reserved                                0x400 */
    
    UWORD32 CursorImage[256];   /* 256 word-wide image ram                 0x800 */

    UWORD32 CursorControl;      /* Cursor control register                 0xC00 */
    UWORD32 CursorConfig;       /* Cursor configuration register           0xC04 */
    UWORD32 CursorPalette0;     /* Cursor palette register                 0xC08 */
    UWORD32 CursorPalette1;     /* Cursor palette register                 0xC0C */
    UWORD32 CursorPosition;     /* Cursor XY position register             0xC10 */
    UWORD32 CursorClip;         /* Cursor clip position register           0xC14 */
    UWORD32 CursorReserved0;    /* Reserved                                0xC18 */
    UWORD32 CursorReserved1;    /* Reserved                                0xC1C */
    UWORD32 CursorIMSC;         /* Cursor interrupt mask register          0xC20 */
    UWORD32 CursorICR;          /* Cursor interrupt clear register         0xC24 */
    UWORD32 CursorRIS;          /* Cursor raw interrupt status register    0xC28 */
    UWORD32 CursorMIS;          /* Cursor masked interrupt status register 0xC2C */

    BYTE8   Pad_2[0xFE0-0xC30]; /* Reserved                                0xC30 */
#else
    BYTE8   Pad_2[0xFE0-0x400]; /* Reserved                                0x400 */
#endif
    UWORD32 PeriphID0;          // Peripheral identification register bits [7:0]
    UWORD32 PeriphID1;          // Peripheral identification register bits [15:8]
    UWORD32 PeriphID2;          // Peripheral identification register bits [23:16]
    UWORD32 PeriphID3;          // Peripheral identification register bits [31:24]
    UWORD32 PCellID0;           // PrimeCell identification register bits [7:0]
    UWORD32 PCellID1;           // PrimeCell identification register bits [15:8]
    UWORD32 PCellID2;           // PrimeCell identification register bits [23:16]
    UWORD32 PCellID3;           // PrimeCell identification register bits [31:24]

} CLCD_sRegisters;

/******************************************************************************\
* Description:  CLCD State structure                                           *
* Usage:        All data pertaining to a specific instance of a CLCD           *
\******************************************************************************/
 
typedef struct CLCD_xStateStruct
{
    CLCD_sRegisters    * pBaseAddress;  /* PrimeCell Base (registers)         */
    apCLCD_rCallback    rCallback;      /* User interrupt handler             */

/*** This is needed when manipulating DMA memory addresses                  ***/
    apCLCD_eSTN_Panel    ePanel;        /* STN LCD panel type                 */
/*** Drawing functions need these values to address DMA memory              ***/
    UWORD32              DMABase;       /* Base address of screen memory      */
    UWORD32              LineWidth;     /* line length (multiple of 16 pixels)*/
    UWORD32              NumLines;      /* total height of the screen         */
    apCLCD_ePixelOrder   ePixelOrder;   /* pixel ordering within a byte       */
    apCLCD_eBpp          eBpp;          /* bits per pixel                     */
    
/*** Parameters that affect the Vertical Compare interrupts                 ***/
    apCLCD_eVComp_ITime  eVCInterTime;  /* Vertical Compare interrupt timing  */
    UWORD32              VFront;        /* vertical front porch               */
    UWORD32              VBack;         /* vertical back porch                */
    BOOL                 WaitForVComp;  /* flag to tell interrupt handler to
                                           check for VComp                    */
    BOOL                 VCompReceived; /* Flag to be set when VComp received */
     
/*** Power switching parameters specific to the LCD panel  ***/
    UWORD32              PowerUpDel;    /* Delay between LcdEn & LcdPwr on    */
    UWORD32              PowerDownDel;  /* Delay between LcdPwr & LcdEn off   */

/*** Pointer to the original parameter structure for reconfiguration        ***/
    apCLCD_sDisplayParams * pParameters;        /* Settings for this LCD      */
#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
    /*** Apply special LCD panel requirements ***/
    /**** LCD panel specific setup functions ****/
    apCLCD_rUserFunction rSwitchOff;   /* Power off sequence                  */
    apCLCD_rUserFunction rSwitchOn;    /* Power on sequence                   */
#endif    

} CLCD_sStateStruct;

/******************************************************************************\
*                                                                              *
* PrimeCell Register bit field descriptions                                    *
*                                                                              *
\******************************************************************************/

/*********** Timing 0 register bitfields ****************/
/* Pixels per line */
#define bwCLCD_TIMING0_PPL    6
#define bsCLCD_TIMING0_PPL    2
#define bmCLCD_TIMING0_PPL    apBIT_MASK(CLCD_TIMING0_PPL)

/* Horiz. sync pulse width */
#define bwCLCD_TIMING0_HSW    8
#define bsCLCD_TIMING0_HSW    8
#define bmCLCD_TIMING0_HSW    apBIT_MASK(CLCD_TIMING0_HSW)

/* Horiz. front porch */
#define bwCLCD_TIMING0_HFP    8
#define bsCLCD_TIMING0_HFP    16
#define bmCLCD_TIMING0_HFP    apBIT_MASK(CLCD_TIMING0_HFP)

/* Horiz. back porch */
#define bwCLCD_TIMING0_HBP    8
#define bsCLCD_TIMING0_HBP    24
#define bmCLCD_TIMING0_HBP    apBIT_MASK(CLCD_TIMING0_HBP)

/*********** Timing 1 register bitfields ****************/
/* Lines per screen */
#define bwCLCD_TIMING1_LPP    10
#define bsCLCD_TIMING1_LPP    0
#define bmCLCD_TIMING1_LPP    apBIT_MASK(CLCD_TIMING1_LPP)

/* Vertical sync pulse width */
#define bwCLCD_TIMING1_VSW    6
#define bsCLCD_TIMING1_VSW    10
#define bmCLCD_TIMING1_VSW    apBIT_MASK(CLCD_TIMING1_VSW)

/* Vertical front porch */
#define bwCLCD_TIMING1_VFP    8
#define bsCLCD_TIMING1_VFP    16
#define bmCLCD_TIMING1_VFP    apBIT_MASK(CLCD_TIMING1_VFP)

/* Vertical back porch */
#define bwCLCD_TIMING1_VBP    8
#define bsCLCD_TIMING1_VBP    24
#define bmCLCD_TIMING1_VBP    apBIT_MASK(CLCD_TIMING1_VBP)

/*********** Timing 2 register bitfields ****************/
/* Panel clock divisor ls 5 bits*/
#define bwCLCD_TIMING2_PCD_LO    5
#define bsCLCD_TIMING2_PCD_LO    0
#define bmCLCD_TIMING2_PCD_LO    apBIT_MASK(CLCD_TIMING2_PCD_LO)

/* Clock selector */
#define bwCLCD_TIMING2_CLKSEL 1
#define bsCLCD_TIMING2_CLKSEL 5
#define bmCLCD_TIMING2_CLKSEL apBIT_MASK(CLCD_TIMING2_CLKSEL)

/* AC bias pin frequency */
#define bwCLCD_TIMING2_ACB    5
#define bsCLCD_TIMING2_ACB    6
#define bmCLCD_TIMING2_ACB    apBIT_MASK(CLCD_TIMING2_ACB)

/* Invert Vsync */
#define bwCLCD_TIMING2_IVS    1
#define bsCLCD_TIMING2_IVS    11
#define bmCLCD_TIMING2_IVS    apBIT_MASK(CLCD_TIMING2_IVS)

/* Interc Hsync */
#define bwCLCD_TIMING2_IHS    1
#define bsCLCD_TIMING2_IHS    12
#define bmCLCD_TIMING2_IHS    apBIT_MASK(CLCD_TIMING2_IHS)

/* Invert Panel Clock */
#define bwCLCD_TIMING2_IPC    1
#define bsCLCD_TIMING2_IPC    13
#define bmCLCD_TIMING2_IPC    apBIT_MASK(CLCD_TIMING2_IPC)

/* Invert Output Enable */
#define bwCLCD_TIMING2_IEO    1
#define bsCLCD_TIMING2_IEO    14
#define bmCLCD_TIMING2_IEO    apBIT_MASK(CLCD_TIMING2_IEO)

/* Clocks per line */
#define bwCLCD_TIMING2_CPL    10
#define bsCLCD_TIMING2_CPL    16
#define bmCLCD_TIMING2_CPL    apBIT_MASK(CLCD_TIMING2_CPL)

/* Bypass panel clock divider */
#define bwCLCD_TIMING2_BCD    1
#define bsCLCD_TIMING2_BCD    26
#define bmCLCD_TIMING2_BCD    apBIT_MASK(CLCD_TIMING2_BCD)

/* Panel clock divisor ms 5 bits*/
#define bwCLCD_TIMING2_PCD_HI    5
#define bsCLCD_TIMING2_PCD_HI    27
#define bmCLCD_TIMING2_PCD_HI    apBIT_MASK(CLCD_TIMING2_PCD_HI)

/*********** Timing 3 register bitfields ****************/
/* Frame end delay */
#define bwCLCD_TIMING3_LED    7
#define bsCLCD_TIMING3_LED    0
#define bmCLCD_TIMING3_LED    apBIT_MASK(CLCD_TIMING3_LED)

/* Frame end enable */
#define bwCLCD_TIMING3_LEE    1
#define bsCLCD_TIMING3_LEE    16
#define bmCLCD_TIMING3_LEE    apBIT_MASK(CLCD_TIMING3_LEE)

/*********** Status/Mask/Interrupt Register bitfields *************/
/* FIFO underflow */
#define bwCLCD_STATUS_FUF     1
#define bsCLCD_STATUS_FUF     1
#define bmCLCD_STATUS_FUF     apBIT_MASK(CLCD_STATUS_FUF)

/* Next base update */
#define bwCLCD_STATUS_LNBU    1
#define bsCLCD_STATUS_LNBU    2
#define bmCLCD_STATUS_LNBU    apBIT_MASK(CLCD_STATUS_LNBU)

/* Vertical compare */
#define bwCLCD_STATUS_VCOMP   1
#define bsCLCD_STATUS_VCOMP   3
#define bmCLCD_STATUS_VCOMP   apBIT_MASK(CLCD_STATUS_VCOMP)

/* Master bus error */
#define bwCLCD_STATUS_MBERROR 1
#define bsCLCD_STATUS_MBERROR 4
#define bmCLCD_STATUS_MBERROR apBIT_MASK(CLCD_STATUS_MBERROR)

/**************** Control register bitfields ***************/
/* Enable CLCD controller */
#define bwCLCD_CONTROL_LCDEN        1
#define bsCLCD_CONTROL_LCDEN        0
#define bmCLCD_CONTROL_LCDEN        apBIT_MASK(CLCD_CONTROL_LCDEN)

/* Bits per pixel */
#define bwCLCD_CONTROL_LCDBPP       3
#define bsCLCD_CONTROL_LCDBPP       1
#define bmCLCD_CONTROL_LCDBPP       apBIT_MASK(CLCD_CONTROL_LCDBPP)

/* STN LCD is monochrome */
#define bwCLCD_CONTROL_LCDBW        1
#define bsCLCD_CONTROL_LCDBW        4
#define bmCLCD_CONTROL_LCDBW        apBIT_MASK(CLCD_CONTROL_LCDBW)

/* LCD is TFT */
#define bwCLCD_CONTROL_LCDTFT       1
#define bsCLCD_CONTROL_LCDTFT       5
#define bmCLCD_CONTROL_LCDTFT       apBIT_MASK(CLCD_CONTROL_LCDTFT)

/* 4 or 8 bit interface for mono LCD */
#define bwCLCD_CONTROL_LCDMONO8     1
#define bsCLCD_CONTROL_LCDMONO8     6
#define bmCLCD_CONTROL_LCDMONO8     apBIT_MASK(CLCD_CONTROL_LCDMONO8)

/* Dual panel mode */
#define bwCLCD_CONTROL_LCDDUAL      1
#define bsCLCD_CONTROL_LCDDUAL      7
#define bmCLCD_CONTROL_LCDDUAL      apBIT_MASK(CLCD_CONTROL_LCDDUAL)

/* Swap red and blue */
#define bwCLCD_CONTROL_BGR          1
#define bsCLCD_CONTROL_BGR          8
#define bmCLCD_CONTROL_BGR          apBIT_MASK(CLCD_CONTROL_BGR)

/* Little/bigendian byte order */
#define bwCLCD_CONTROL_BEBO         1
#define bsCLCD_CONTROL_BEBO         9
#define bmCLCD_CONTROL_BEBO         apBIT_MASK(CLCD_CONTROL_BEBO)

/* Pixel order within byte*/
#define bwCLCD_CONTROL_BEPO         1
#define bsCLCD_CONTROL_BEPO         10
#define bmCLCD_CONTROL_BEPO         apBIT_MASK(CLCD_CONTROL_BEPO)

/* Power enable */
#define bwCLCD_CONTROL_LCDPWR       1
#define bsCLCD_CONTROL_LCDPWR       11
#define bmCLCD_CONTROL_LCDPWR       apBIT_MASK(CLCD_CONTROL_LCDPWR)

/* Interrupt generation */
#define bwCLCD_CONTROL_LCDVCOMP     2
#define bsCLCD_CONTROL_LCDVCOMP     12
#define bmCLCD_CONTROL_LCDVCOMP     apBIT_MASK(CLCD_CONTROL_LCDVCOMP)

/* DMA FIFO test access */
#define bwCLCD_CONTROL_LDMAFIFOTME  1
#define bsCLCD_CONTROL_LDMAFIFOTME  15
#define bmCLCD_CONTROL_LDMAFIFOTME  apBIT_MASK(CLCD_CONTROL_LDMAFIFOTME)

/* FIFO reload watermark */
#define bwCLCD_CONTROL_WATERMARK    1
#define bsCLCD_CONTROL_WATERMARK    16
#define bmCLCD_CONTROL_WATERMARK    apBIT_MASK(CLCD_CONTROL_WATERMARK)

/*********** Address register bitfields *****************/
/* This defines the valid bits in the 4 DMA base address registers */
#define bwCLCD_ADDRESS    30
#define bsCLCD_ADDRESS    2
#define bmCLCD_ADDRESS    apBIT_MASK(CLCD_ADDRESS)

/************* Palette register bitfields ****************/
/* Red */
#define bwCLCD_PALETTE_R  5
#define bsCLCD_PALETTE_R  0
#define bmCLCD_PALETTE_R  apBIT_MASK(CLCD_PALETTE_R)

/* Green */
#define bwCLCD_PALETTE_G  5
#define bsCLCD_PALETTE_G  5
#define bmCLCD_PALETTE_G  apBIT_MASK(CLCD_PALETTE_G)

/* Blue */
#define bwCLCD_PALETTE_B  5
#define bsCLCD_PALETTE_B  10
#define bmCLCD_PALETTE_B  apBIT_MASK(CLCD_PALETTE_B)

/* Intensity */
#define bwCLCD_PALETTE_I  1
#define bsCLCD_PALETTE_I  15
#define bmCLCD_PALETTE_I  apBIT_MASK(CLCD_PALETTE_I)

#if (defined (apCLCD_VERSION) && (apCLCD_VERSION == PL111))
/*********** Hardware Cursor register bitfields *****************/

/*********** Cursor Control register bitfields *****************/
#define bsCLCD_CURSOR_CONTROL_ON        0
#define bwCLCD_CURSOR_CONTROL_ON        1
#define bsCLCD_CURSOR_CONTROL_IMAGE     4
#define bwCLCD_CURSOR_CONTROL_IMAGE     2

/*********** Cursor Configuration register bitfields *****************/
#define bsCLCD_CURSOR_CONFIG_SIZE     0
#define bwCLCD_CURSOR_CONFIG_SIZE     1
#define bsCLCD_CURSOR_CONFIG_SYNC     1
#define bwCLCD_CURSOR_CONFIG_SYNC     1

/************* Cursor Palette register bitfields ****************/
/* Red */
#define bsCLCD_CURSOR_PALETTE_R  0
#define bwCLCD_CURSOR_PALETTE_R  8
#define bmCLCD_CURSOR_PALETTE_R  apBIT_MASK(CLCD_CURSOR_PALETTE_R)

/* Green */
#define bsCLCD_CURSOR_PALETTE_G  8
#define bwCLCD_CURSOR_PALETTE_G  8
#define bmCLCD_CURSOR_PALETTE_G  apBIT_MASK(CLCD_CURSOR_PALETTE_G)

/* Blue */
#define bsCLCD_CURSOR_PALETTE_B  16
#define bwCLCD_CURSOR_PALETTE_B  8
#define bmCLCD_CURSOR_PALETTE_B  apBIT_MASK(CLCD_CURSOR_PALETTE_B)

/*********** Cursor XY position register bitfields *****************/
#define bsCLCD_CURSOR_POSITION_X     0
#define bwCLCD_CURSOR_POSITION_X     12
#define bsCLCD_CURSOR_POSITION_Y     16
#define bwCLCD_CURSOR_POSITION_Y     12

/*********** Cursor clip position register bitfields *****************/
#define bsCLCD_CURSOR_CLIP_X     0
#define bwCLCD_CURSOR_CLIP_X     6
#define bsCLCD_CURSOR_CLIP_Y     8
#define bwCLCD_CURSOR_CLIP_Y     6

/****** Cursor Interrupt Mask Set and Clear Register bitfields *******/
#define bsCLCD_CURSOR_INTERRUPT     0
#define bwCLCD_CURSOR_INTERRUPT     1

#endif

#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif  /* __cplusplus */

#endif
