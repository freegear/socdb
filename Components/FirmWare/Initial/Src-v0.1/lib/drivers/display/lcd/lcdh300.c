/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : lcdrgbif.c 
	Description : API for display
	Created by  : SHMT SOC Team
------------------------------------------------------------------------------*/
/*//////////////////////////////////////////////////////////////////////////////
        INCLUDE
//////////////////////////////////////////////////////////////////////////////*/
#include "config.h"
//#include "cpu.h"
#include "lcd.h"
//#include "kernel.h"
//#include "thread.h"
#include <string.h>
#include <stdlib.h>
//#include "file.h"
//#include "debug.h"
//#include "system.h"
#include "font.h"
#include "bidi.h"
#include "lcd_post_drv.h"

/*//////////////////////////////////////////////////////////////////////////////
        DEFINITION
//////////////////////////////////////////////////////////////////////////////*/

#define DRAM_GRAPHIC_START	  0x41E00000 
#if 0 //shkim-20061214 : further work for cpu interface LCD
/* register defines */
#define R_START_OSC             0x00
#define R_DRV_OUTPUT_CONTROL    0x01
#define R_DRV_WAVEFORM_CONTROL  0x02
#define R_ENTRY_MODE            0x03
#define R_COMPARE_REG1          0x04
#define R_COMPARE_REG2          0x05

#define R_DISP_CONTROL1     0x07
#define R_DISP_CONTROL2     0x08
#define R_DISP_CONTROL3     0x09

#define R_FRAME_CYCLE_CONTROL 0x0b
#define R_EXT_DISP_IF_CONTROL 0x0c

#define R_POWER_CONTROL1    0x10
#define R_POWER_CONTROL2    0x11
#define R_POWER_CONTROL3    0x12
#define R_POWER_CONTROL4    0x13

#define R_RAM_ADDR_SET  0x21
#define R_WRITE_DATA_2_GRAM 0x22

#define R_GAMMA_FINE_ADJ_POS1   0x30
#define R_GAMMA_FINE_ADJ_POS2   0x31
#define R_GAMMA_FINE_ADJ_POS3   0x32
#define R_GAMMA_GRAD_ADJ_POS    0x33

#define R_GAMMA_FINE_ADJ_NEG1   0x34
#define R_GAMMA_FINE_ADJ_NEG2   0x35
#define R_GAMMA_FINE_ADJ_NEG3   0x36
#define R_GAMMA_GRAD_ADJ_NEG    0x37

#define R_GAMMA_AMP_ADJ_RES_POS     0x38
#define R_GAMMA_AMP_AVG_ADJ_RES_NEG 0x39 

#define R_GATE_SCAN_POS         0x40
#define R_VERT_SCROLL_CONTROL   0x41
#define R_1ST_SCR_DRV_POS       0x42
#define R_2ND_SCR_DRV_POS       0x43
#define R_HORIZ_RAM_ADDR_POS    0x44
#define R_VERT_RAM_ADDR_POS     0x45

#define LCD_CMD  (*(volatile unsigned short *)0xf0000000)
#define LCD_DATA (*(volatile unsigned short *)0xf0000002)
#endif
/*//////////////////////////////////////////////////////////////////////////////
        VARIABLE DECLARATION
//////////////////////////////////////////////////////////////////////////////*/

static bool display_on = false; /* is the display turned on? */
static bool display_flipped = false;
static int xoffset = 0; /* needed for flip */

/*//////////////////////////////////////////////////////////////////////////////
        FUNCTION
//////////////////////////////////////////////////////////////////////////////*/

/*------------------------------------------------------------------------------
    Function name   : 
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
/* called very frequently - inline! */
static inline void lcd_write_reg(int reg, int val)
{
	(void)reg;
	(void)val;
#if 0//shkim-20061214 : further work for cpu interface LCD	
    LCD_CMD = reg;
    LCD_DATA = val;
#endif    
}
/*------------------------------------------------------------------------------
    Function name   : lcd_set_backdrop
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
/* called very frequently - inline! */
static inline void lcd_begin_write_gram(void)
{
#if 0 //shkim-20061214 : further work for cpu interface LCD
    LCD_CMD = R_WRITE_DATA_2_GRAM;
#endif    
}

//------------------------------------------------------------------------------
//	hardware configuration
//------------------------------------------------------------------------------
/*------------------------------------------------------------------------------
    Function name   : lcd_set_contrast
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void lcd_set_contrast(int val)
{
    (void)val;
}
/*------------------------------------------------------------------------------
    Function name   : lcd_set_invert_display
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void lcd_set_invert_display(bool yesno)
{
    (void)yesno;
}
/*------------------------------------------------------------------------------
    Function name   : flip_lcd
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
static void flip_lcd(bool yesno)
{
#if 1//shkim-20061214 : further work for cpu interface LCD	
	(void)yesno;
#else
    if (yesno)
    {
        lcd_write_reg(R_DRV_OUTPUT_CONTROL, 0x031b); /* 224 lines, GS=SS=1 */
        lcd_write_reg(R_GATE_SCAN_POS, 0x0002);      /* 16 lines offset */
        lcd_write_reg(R_1ST_SCR_DRV_POS, 0xdf04);    /* 4..223 */
    }
    else
    {
        lcd_write_reg(R_DRV_OUTPUT_CONTROL, 0x001b); /* 224 lines, GS=SS=0 */
        lcd_write_reg(R_GATE_SCAN_POS, 0x0000);
        lcd_write_reg(R_1ST_SCR_DRV_POS, 0xdb00);    /* 0..219 */
    }
#endif    
}
/*------------------------------------------------------------------------------
    Function name   : lcd_set_flip
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : turn the display upside down (call lcd_update() afterwards)
------------------------------------------------------------------------------*/
void lcd_set_flip(bool yesno)
{
    display_flipped = yesno;
    xoffset = yesno ? 4 : 0;

    if (display_on)
        flip_lcd(yesno);
}
/*------------------------------------------------------------------------------
    Function name   : _display_on
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
static void _display_on(void)
{
#if 1//shkim-20061214 : further work for cpu interface LCD	
	//todo : add the code for initializing LCD
#else

    /** Sequence according to datasheet, p. 132 **/
    
    lcd_write_reg(R_START_OSC, 0x0001); /* Start Oscilation */
    sleep(1);

    /* zero everything*/
    lcd_write_reg(R_POWER_CONTROL1, 0x0000); /* STB = 0, SLP = 0 */
    lcd_write_reg(R_DISP_CONTROL1, 0x0000);  /* GON = 0, DTE = 0, D1-0 = 00b */
    lcd_write_reg(R_POWER_CONTROL3, 0x0000); /* PON = 0 */
    lcd_write_reg(R_POWER_CONTROL4, 0x0000); /* VCOMG = 0 */
    sleep(1);

    /* initialise power supply */
    
    /* DC12-10 = 000b: Step-up1 = clock/8,
     * DC02-00 = 000b: Step-up2 = clock/16,
     * VC2-0   = 010b: VciOUT = 0.87 * VciLVL */
    lcd_write_reg(R_POWER_CONTROL2, 0x0002); 
    
    /* VRH3-0 = 1000b: Vreg1OUT = REGP * 1.90 */
    lcd_write_reg(R_POWER_CONTROL3, 0x0008);
    
    /* VDV4-0 = 00110b: VcomA = Vreg1OUT * 0.76,
     * VCM4-0 = 10000b: VcomH = Vreg1OUT * 0.70*/
    lcd_write_reg(R_POWER_CONTROL4, 0x0610);     

    lcd_write_reg(R_POWER_CONTROL1, 0x0044); /* AP2-0 = 100b, DK = 1 */
    lcd_write_reg(R_POWER_CONTROL3, 0x0018); /* PON = 1 */

    sleep(4); /* Step-up circuit stabilising time */
    
    /* start power supply */

    lcd_write_reg(R_POWER_CONTROL1, 0x0540); /* BT2-0 = 101b, DK = 0 */
    lcd_write_reg(R_POWER_CONTROL4, 0x2610); /* VCOMG = 1 */

    /* other settings */

    /* B/C = 1: n-line inversion form
     * EOR = 1: polarity inversion occurs by applying an EOR to odd/even
     *          frame select signal and an n-line inversion signal.
     * FLD = 01b: 1 field interlaced scan, external display iface */
    lcd_write_reg(R_DRV_WAVEFORM_CONTROL, 0x0700);

    /* Address counter updated in vertical direction; left to right;
     * vertical increment horizontal increment.
     * data format for 8bit transfer or spi = 65k (5,6,5)
     * Reverse order of RGB to BGR for 18bit data written to GRAM
     * Replace data on writing to GRAM */
    lcd_write_reg(R_ENTRY_MODE, 0x7038);

    flip_lcd(display_flipped);

    lcd_write_reg(R_2ND_SCR_DRV_POS, 0x0000);
    lcd_write_reg(R_VERT_SCROLL_CONTROL, 0x0000);

    /* 19 clocks,no equalization */
    lcd_write_reg(R_FRAME_CYCLE_CONTROL, 0x0002);

    /* Transfer mode for RGB interface disabled
     * internal clock operation;
     * System interface/VSYNC interface */
    lcd_write_reg(R_EXT_DISP_IF_CONTROL, 0x0003);

    /* Front porch lines: 8; Back porch lines: 8; */
    lcd_write_reg(R_DISP_CONTROL2, 0x0808);

    /* Scan mode by the gate driver in the non-display area: disabled;
     * Cycle of scan by the gate driver - set to 31frames(518ms), 
     * disabled by above setting */
    lcd_write_reg(R_DISP_CONTROL3, 0x003f);

    lcd_write_reg(R_GAMMA_FINE_ADJ_POS1, 0x0003);
    lcd_write_reg(R_GAMMA_FINE_ADJ_POS2, 0x0707);
    lcd_write_reg(R_GAMMA_FINE_ADJ_POS3, 0x0007);
    lcd_write_reg(R_GAMMA_GRAD_ADJ_POS, 0x0705);
    lcd_write_reg(R_GAMMA_FINE_ADJ_NEG1, 0x0007);
    lcd_write_reg(R_GAMMA_FINE_ADJ_NEG2, 0x0000);
    lcd_write_reg(R_GAMMA_FINE_ADJ_NEG3, 0x0407);
    lcd_write_reg(R_GAMMA_GRAD_ADJ_NEG, 0x0507);
    lcd_write_reg(R_GAMMA_AMP_ADJ_RES_POS, 0x1d09);
    lcd_write_reg(R_GAMMA_AMP_AVG_ADJ_RES_NEG, 0x0303);

    display_on=true;  /* must be done before calling lcd_update() */
    lcd_update();
    
    sleep(4); /* op-amp stabilising time */
 
    /** Sequence according to datasheet, p. 130 **/

    lcd_write_reg(R_POWER_CONTROL1, 0x4540); /* SAP2-0=100, BT2-0=101, AP2-0=100 */
    lcd_write_reg(R_DISP_CONTROL1, 0x0005);  /* GON=0, DTE=0, REV=1, D1-0=01 */
    sleep(2);
    
    lcd_write_reg(R_DISP_CONTROL1, 0x0025);  /* GON=1, DTE=0, REV=1, D1-0=01 */
    lcd_write_reg(R_DISP_CONTROL1, 0x0027);  /* GON=1, DTE=0, REV=1, D1-0=11 */
    sleep(2);

    lcd_write_reg(R_DISP_CONTROL1, 0x0037);  /* GON=1, DTE=1, REV=1, D1-0=11 */
#endif    
}
/*------------------------------------------------------------------------------
    Function name   : lcd_init_device
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void lcd_init_device(void)
{
#if 1
	DM_Config dmConfig;
	//shkim-20070115 : set DM_Config structure below
	
	//1. set Graphic plane
	dmConfig.graphicCfg.ctrl.xEn 		= 1;		//graphic plane enable
	dmConfig.graphicCfg.ctrl.pixFmt 	= 2;		// RGB565
	dmConfig.graphicCfg.ctrl.gammaEn 	= SMT_FALSE;//disable gamma
	dmConfig.graphicCfg.ctrl.sWidth		= LCD_WIDTH;
	dmConfig.graphicCfg.ctrl.sHeight	= LCD_HEIGHT;

	dmConfig.graphicCfg.blnd.alpha	= 0xFF;	// alpha blending opaque
	dmConfig.graphicCfg.blnd.colKey	= 0x0;	

	dmConfig.graphicCfg.blndMode.colKeyEn = SMT_FALSE;
	dmConfig.graphicCfg.blndMode.blendMod = 2;	// global alpha

	dmConfig.graphicCfg.gAddr	= DRAM_GRAPHIC_START;

	//set the base address of graphic plane
	dmConfig.graphicCfg.gPlaneXRef = 0;
	/*
		2. set video layer
		3. set cursor layer
	*/
	
	smt2DMInitializeHardware(&dmConfig);
#else

    /* GPO46 is LCD RESET */
    or_l(0x00004000, &GPIO1_OUT);
    or_l(0x00004000, &GPIO1_ENABLE);
    or_l(0x00004000, &GPIO1_FUNCTION);

    /* Reset LCD */
    and_l(~0x00004000, &GPIO1_OUT);
    sleep(1);
    or_l(0x00004000, &GPIO1_OUT);
    sleep(1);

    _display_on();
#endif    
}
/*------------------------------------------------------------------------------
    Function name   : lcd_enable
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void lcd_enable(bool on)
{
#if 1//shkim-20061214 : further work for cpu interface LCD	
	(void)on;
#else
    if(display_on!=on)
    {
        if(on)
        {
            _display_on();
        }
        else
        {
            /** Off sequence according to datasheet, p. 130 **/

            lcd_write_reg(R_FRAME_CYCLE_CONTROL, 0x0002); /* EQ=0, 18 clks/line */
            lcd_write_reg(R_DISP_CONTROL1, 0x0036);  /* GON=1, DTE=1, REV=1, D1-0=10 */
            sleep(2);

            lcd_write_reg(R_DISP_CONTROL1, 0x0026);  /* GON=1, DTE=0, REV=1, D1-0=10 */
            sleep(2);

            lcd_write_reg(R_DISP_CONTROL1, 0x0000);  /* GON=0, DTE=0, D1-0=00 */

            lcd_write_reg(R_POWER_CONTROL1, 0x0000); /* SAP2-0=000, AP2-0=000 */
            lcd_write_reg(R_POWER_CONTROL3, 0x0000); /* PON=0 */
            lcd_write_reg(R_POWER_CONTROL4, 0x0000); /* VCOMG=0 */
            
            /* datasheet p. 131 */
            lcd_write_reg(R_POWER_CONTROL1, 0x0001); /* STB=1: standby mode */

            display_on=false;
        }
    }
#endif    
}
//------------------------------------------------------------------------------
//	 update functions
//------------------------------------------------------------------------------
/*------------------------------------------------------------------------------
    Function name   : lcd_blit
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : Performance function that works with an external buffer
   					  note that by and bheight are in 8-pixel units!
------------------------------------------------------------------------------*/
void lcd_blit(const fb_data* data, int x, int by, int width,
              int bheight, int stride)
{
    /* TODO: Implement lcd_blit() */
    (void)data;
    (void)x;
    (void)by;
    (void)width;
    (void)bheight;
    (void)stride;
    /*if(display_on)*/
}
/*------------------------------------------------------------------------------
    Function name   : lcd_update_rect
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : Update the display.
					  This must be called after all other LCD functions 
					  that change the display.
------------------------------------------------------------------------------*/
void lcd_update(void)
{
#if 1//shkim-20061214
	//todo : add the code for lcd_update here
	lcd_update_rect(0, 0, LCD_WIDTH, LCD_HEIGHT);
#else
    if(display_on){
        /* reset update window */
        lcd_write_reg(R_VERT_RAM_ADDR_POS,((xoffset+219)<<8) | xoffset);

        /* Copy display bitmap to hardware */
        lcd_write_reg(R_RAM_ADDR_SET, xoffset << 8);
        lcd_begin_write_gram();

        DAR3 = 0xf0000002;
        SAR3 = (unsigned long)lcd_framebuffer;
        BCR3 = LCD_WIDTH*LCD_HEIGHT*2;
        DCR3 = DMA_AA | DMA_BWC(1)
             | DMA_SINC | DMA_SSIZE(DMA_SIZE_LINE) 
             | DMA_DSIZE(DMA_SIZE_WORD) | DMA_START;

        while (!(DSR3 & 1));
        DSR3 = 1;
    }
#endif    
}

/*------------------------------------------------------------------------------
    Function name   : lcd_update_rect
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : Performance function that works with an external buffer
------------------------------------------------------------------------------*/
void lcd_update_rect(int x, int y, int width, int height)
{
#if 1//shkim-20061214
	//todo: add the code for lcd_update_rect here.
	//unsigned short *src  = lcd_framebuffer[y][x];
	fb_data *src = ((fb_data *)lcd_framebuffer + y*LCD_WIDTH + x);
	//unsigned short *src  = LCDADDR(x, y);	// By shkim 2006/12/14
	unsigned short *dest = (unsigned short*)DRAM_GRAPHIC_START + y*LCD_WIDTH + x;
	unsigned short row,col;
	
    if(x + width > LCD_WIDTH)
    	width = LCD_WIDTH - x;    

    if (width <= 0)
    	return; /* nothing left to do, 0 is harmful to lcd_write_data() */
    	
    if(y + height >= LCD_HEIGHT)
    	height = LCD_HEIGHT - y;

    if (height <=0)
    	return;

    /* Copy specified rectange bitmap to hardware */ 

	for(row = 0; row < height; row++)
	{
		for(col = 0; col < width; col++)
		{
			*(dest++) = *(src++);
		}
		dest+= LCD_WIDTH - width;
		src += LCD_WIDTH - width;
	}
#else
    unsigned long dma_addr;

    if(display_on) {

        if(x + width > LCD_WIDTH)
            width = LCD_WIDTH - x;
        if(width <= 0) /* nothing to do */
            return;
        if(y + height > LCD_HEIGHT)
            height = LCD_HEIGHT - y;

        /* set update window */

        lcd_write_reg(R_VERT_RAM_ADDR_POS,((x+xoffset+width-1) << 8) | (x+xoffset));
        lcd_write_reg(R_RAM_ADDR_SET, ((x+xoffset) << 8) | y);
        lcd_begin_write_gram();
        
        DAR3 = 0xf0000002;
        dma_addr = (unsigned long)&lcd_framebuffer[y][x];
        width *= 2;

        for (; height > 0; height--)
        {
            SAR3 = dma_addr;
            BCR3 = width;
            DCR3 = DMA_AA | DMA_BWC(1)
                 | DMA_SINC | DMA_SSIZE(DMA_SIZE_LINE)
                 | DMA_DSIZE(DMA_SIZE_WORD) | DMA_START;

            dma_addr += LCD_WIDTH*2;

            while (!(DSR3 & 1));
            DSR3 = 1;
        }
    }
#endif    
}

#if 0
/* Line write helper function for lcd_yuv_blit. Write two lines of yuv420.
 * y should have two lines of Y back to back.
 * bu and rv should contain the Cb and Cr data for the two lines of Y.
 * Needs EMAC set to saturated, signed integer mode.
 */
extern void lcd_write_yuv420_lines(const unsigned char *y,
                                   const unsigned char *bu,
                                   const unsigned char *rv, int width);

/* Performance function to blit a YUV bitmap directly to the LCD
 * src_x, src_y, width and height should be even
 * x, y, width and height have to be within LCD bounds
 */
void lcd_yuv_blit(unsigned char * const src[3],
                  int src_x, int src_y, int stride,
                  int x, int y, int width, int height)
{
#if 1//shkim-20061214 : further work for video plane	
	(void)src;
	(void)src_x;
	(void)src_y;
	(void)stride;
	(void)x;
	(void)y;
	(void)width;
	(void)height;
#else
    /* IRAM Y, Cb and Cb buffers. */
    unsigned char y_ibuf[LCD_WIDTH*2];
    unsigned char bu_ibuf[LCD_WIDTH/2];
    unsigned char rv_ibuf[LCD_WIDTH/2];
    const unsigned char *ysrc, *usrc, *vsrc;
    const unsigned char *ysrc_max;

    if (!display_on)
        return;

    width &= ~1;  /* stay on the safe side */
    height &= ~1;

    /* Set start position and window */
    lcd_write_reg(R_VERT_RAM_ADDR_POS,((x+xoffset+width-1) << 8) | (x+xoffset));
    lcd_write_reg(R_RAM_ADDR_SET, ((x+xoffset) << 8) | y);

    lcd_begin_write_gram();

    ysrc = src[0] + src_y * stride + src_x;
    usrc = src[1] + (src_y * stride >> 2) + (src_x >> 1);
    vsrc = src[2] + (src_y * stride >> 2) + (src_x >> 1);
    ysrc_max = ysrc + height * stride;

    coldfire_set_macsr(EMAC_SATURATE);
    do
    {
        memcpy(y_ibuf, ysrc, width);
        memcpy(y_ibuf + width, ysrc + stride, width);
        memcpy(bu_ibuf, usrc, width >> 1);
        memcpy(rv_ibuf, vsrc, width >> 1);
        lcd_write_yuv420_lines(y_ibuf, bu_ibuf, rv_ibuf, width);
        ysrc += 2 * stride;
        usrc += stride >> 1;
        vsrc += stride >> 1;
    }
    while (ysrc < ysrc_max);
#endif    
}
#endif

