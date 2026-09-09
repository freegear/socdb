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
//  Header: smt926a_lcd.h
//
//  Defines the LCD controller CPU register layout and definitions.
//
#ifndef __SMT926A_LCD_H
#define __SMT926A_LCD_H

#if __cplusplus
    extern "C" 
    {
#endif

//------------------------------------------------------------------------------
//  Type: SMT926A_LCD_REG    
//
//  LCD control registers. This register bank is located by the constant
//  CPU_BASE_REG_XX_LCD in the configuration file cpu_base_reg_cfg.h.
//

typedef struct {
    UINT32 LCDCON1;             // 0x00
    UINT32 LCDCON2;             // 0x04
    UINT32 LCDCON3;             // 0x08
    UINT32 LCDCON4;             // 0x0C
    UINT32 LCDCON5;             // 0x10
    UINT32 LCDSADDR1;           // 0x14
    UINT32 LCDSADDR2;           // 0x18
    UINT32 LCDSADDR3;           // 0x1C
    UINT32 REDLUT;              // 0x20
    UINT32 GREENLUT;            // 0x24
    UINT32 BLUELUT;             // 0x28
    UINT32 PAD[8];              // 0x2C - 0x48
    UINT32 DITHMODE;            // 0x4C
    UINT32 TPAL;                // 0x50
    UINT32 LCDINTPND;           // 0x54
    UINT32 LCDSRCPND;           // 0x58
    UINT32 LCDINTMSK;           // 0x5C   
    UINT32 TCONSEL;             // 0x60

	/* SMT926 LCD controller registers */
	// Inserted by DJKIM 2006/09/27
	UINT32	 LCDMCON;
	UINT32	 LCDMSTS;
	UINT32	 CSCTRL;
	UINT32	 CBBASE;
	UINT32	 CSCADR;
	UINT32	 CSADR;
	UINT32	 CSBACKADR;
	UINT32	 GSCTRL;
	UINT32	 GBBASE;
	UINT32	 GSCADR;
	UINT32	 GSADR;

	UINT32	 GFXGAM0;
	UINT32	 GFXGAM1;
	UINT32	 GFXGAM2;
	UINT32	 GFXGAM3;
	UINT32	 GFXGAM4;
	UINT32	 GFXGAM5;
	UINT32	 GFXGAM6;
	UINT32	 GFXGAM7;
	UINT32	 GFXGAM8;
	UINT32	 GFXGAM9;
	UINT32	 GFXGAM10;
	UINT32	 GFXGAM11;
	UINT32	 GFXGAM12;
	UINT32	 GFXGAM13;
	UINT32	 GFXGAM14;
	UINT32	 GFXGAM15;
	UINT32	 GFXGAM16;

	UINT32	 VSCTRL;
	UINT32	 VBBASE;
	UINT32	 VSCADR;
	UINT32	 VSADR;
	UINT32	 USADR;
	UINT32	 VADR;

	UINT32	 VIDGAM0;
	UINT32	 VIDGAM1;
	UINT32	 VIDGAM2;
	UINT32	 VIDGAM3;
	UINT32	 VIDGAM4;
	UINT32	 VIDGAM5;
	UINT32	 VIDGAM6;
	UINT32	 VIDGAM7;
	UINT32	 VIDGAM8;
	UINT32	 VIDGAM9;
	UINT32	 VIDGAM10;
	UINT32	 VIDGAM11;
	UINT32	 VIDGAM12;
	UINT32	 VIDGAM13;
	UINT32	 VIDGAM14;
	UINT32	 VIDGAM15;
	UINT32	 VIDGAM16;

	UINT32	 CSC01;
	UINT32	 CSC02;
	UINT32	 CSC03;
	UINT32	 CSC04;
	UINT32	 CSC05;

	UINT32	 LCDCON;
	UINT32	 HSYNCCON;
	UINT32	 VSYNCCON;

} SMT926A_LCD_REG, *PSMT926A_LCD_REG;


//------------------------------------------------------------------------------
//  Define: LCD_TYPE_XXX
//
//  Enumerates the types of LCD displays available.
//

#define    LCD_TYPE_STN8BPP            (1)
#define    LCD_TYPE_TFT16BPP           (2)

//------------------------------------------------------------------------------
//  Define: LCD_TYPE
//
//  Defines the active LCD type from above choices.
//

#define    LCD_TYPE                    LCD_TYPE_TFT16BPP

//------------------------------------------------------------------------------
//  Define: LCD_MODE_XXX
//
//  Defines the LCD mode.
//

#define    LCD_MODE_STN_1BIT       (1)
#define    LCD_MODE_STN_2BIT       (2)
#define    LCD_MODE_STN_4BIT       (4)
#define    LCD_MODE_CSTN_8BIT      (108)
#define    LCD_MODE_CSTN_12BIT     (112)
#define    LCD_MODE_TFT_1BIT       (201)
#define    LCD_MODE_TFT_2BIT       (202)
#define    LCD_MODE_TFT_4BIT       (204)
#define    LCD_MODE_TFT_8BIT       (208)
#define    LCD_MODE_TFT_16BIT      (216)

//------------------------------------------------------------------------------
//  Define: LCD_SCR_XXX
//
//  Screen size definitions.
//

#define    LCD_SCR_XSIZE           (640)           // virtual screen  
#define    LCD_SCR_YSIZE           (480)

#define    LCD_SCR_XSIZE_TFT       (480)           // virtual screen  
#define    LCD_SCR_YSIZE_TFT       (640)


//------------------------------------------------------------------------------
//  Define: LCD_*SIZE_XXX
//
//  Defines physical screen sizes and orientation.
//

#define    LCD_XSIZE_STN           (320)
#define    LCD_YSIZE_STN           (240)

#define    LCD_XSIZE_CSTN          (320)
#define    LCD_YSIZE_CSTN          (240)

#define    LCD_XSIZE_TFT           (240)   
#define    LCD_YSIZE_TFT           (320)


//------------------------------------------------------------------------------
//  Define: LCD_ARRAY_SIZE_XXX
//
//  Array Sizes based on screen configuration.
//

#define    LCD_ARRAY_SIZE_STN_1BIT     (LCD_SCR_XSIZE/8*LCD_SCR_YSIZE)
#define    LCD_ARRAY_SIZE_STN_2BIT     (LCD_SCR_XSIZE/4*LCD_SCR_YSIZE)
#define    LCD_ARRAY_SIZE_STN_4BIT     (LCD_SCR_XSIZE/2*LCD_SCR_YSIZE)
#define    LCD_ARRAY_SIZE_CSTN_8BIT    (LCD_SCR_XSIZE/1*LCD_SCR_YSIZE)
#define    LCD_ARRAY_SIZE_CSTN_12BIT   (LCD_SCR_XSIZE*2*LCD_SCR_YSIZE)
#define    LCD_ARRAY_SIZE_TFT_8BIT     (LCD_SCR_XSIZE/1*LCD_SCR_YSIZE)
#define    LCD_ARRAY_SIZE_TFT_16BIT    (LCD_SCR_XSIZE*2*LCD_SCR_YSIZE)

//------------------------------------------------------------------------------
//  Define: LCD_HOZVAL_XXX
//
//  Desc...
//

#define    LCD_HOZVAL_STN          (LCD_XSIZE_STN/4-1)
#define    LCD_HOZVAL_CSTN         (LCD_XSIZE_CSTN*3/8-1)
#define    LCD_HOZVAL_TFT          (LCD_XSIZE_TFT-1)

//------------------------------------------------------------------------------
//  Define: LCD_LINEVAL_XXX
//
//  Desc...
//

#define    LCD_LINEVAL_STN         (LCD_YSIZE_STN-1)
#define    LCD_LINEVAL_CSTN        (LCD_YSIZE_CSTN-1)
#define    LCD_LINEVAL_TFT         (LCD_YSIZE_TFT-1)


#define    LCD_MVAL                (13)
#define    LCD_MVAL_USED           (0)

// STN/CSTN timing parameter for LCBHBT161M(NANYA)

#define    LCD_WLH                 (3)
#define    LCD_WDLY                (3)
#define    LCD_LINEBLANK           ((1)&0xff)

// TFT timing parameter for V16C6448AB(PRIME VIEW) 

#define    LCD_VBPD                ((1)&0xff)
#define    LCD_VFPD                ((2)&0xff)
#define    LCD_VSPW                ((1)&0x3f)
#define    LCD_HBPD                ((6)&0x7f)
#define    LCD_HFPD                ((2)&0xff)
#define    LCD_HSPW                ((4)&0xff)


//------------------------------------------------------------------------------
//  Define: LCD_CLKVAL_XXX
//
//  Clock values
//

#define     CLKVAL_STN_MONO         (22)    

// 69.14hz @60Mhz,WLH=16clk,WDLY=16clk,LINEBLANK=1*8,VD=4 

#define     CLKVAL_STN_GRAY         (12)    

//124hz @60Mhz,WLH=16clk,WDLY=16clk,LINEBLANK=1*8,VD=4  

#define     CLKVAL_CSTN             (8)     

//135hz @60Mhz,WLH=16clk,WDLY=16clk,LINEBLANK=1*8,VD=8  

#define     CLKVAL_TFT              (6)

// NOTE: 1)SDRAM should have 32-bit bus width. 
//      2)HBPD,HFPD,HSPW should be optimized. 
// 44.6hz @75Mhz
// VSYNC,HSYNC should be inverted
// HBPD=48VCLK,HFPD=16VCLK,HSPW=96VCLK
// VBPD=33HSYNC,VFPD=10HSYNC,VSPW=2HSYNC

#define     M5D(n)                  ((n)&0x1fffff)


#if __cplusplus
    }
#endif

#endif 
