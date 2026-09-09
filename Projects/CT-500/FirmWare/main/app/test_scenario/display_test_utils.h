/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: display_test_utils.c 
	Description	: display test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __DISPLAY_TEST_UTILLS_H__
#define __DISPLAY_TEST_UTILLS_H__
/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
// Definition for Video Encoder
#define LUMA_FILTER_SEL     2 //  0:6Mhz 1:ntsc notch 2:pal notch 3:bypass 
#define CHRO_FILTER_SEL     0 //  0: 1.35 Mhz 2: 0.67Mhz
#define EN_COLOR_KILL       0
#define EN_REST_SCH         1
#define EN_INTERNAL_PATTERN 0
#define COLOR_PATTERN_MODE  0
#define CHRO_DELAY          3 // 3Ts delay
#define LUMA_DELAY          0
#define BURST_WID           0
#define HSYNC_WID           0
#define SUB_PHASE           0
#define SUB_REQ             0
#define EN_DAC0             1
#define EN_DAC1             1
#define EN_DAC2             1
#define EN_SQPIXEL          0
#define EN_NONINTERLACE     0

#define __DM_NTSC_TEST__ 
//#define __DM_PAL_TEST__
//#define __DM_LCD_TEST__
#ifdef __DM_NTSC_TEST__
#define MODE         0

#define FRAME_WIDTH  720
#define FRAME_HEIGHT 240
#define CURSOR_WIDTH  720
#define CURSOR_HEIGHT 240
#define GRAPHIC_WIDTH  720
#define GRAPHIC_HEIGHT 240
#define VIDEO_WIDTH  720
#define VIDEO_HEIGHT 240

#define LCD_HFP	(31)	        // Horizontal Front Porch(2 clock)
#define LCD_HBP	((122*2)-121)	// Horizontal Back Porch(2 clock)
#define LCD_HSW	(122)	        // Horizontal Sync Width(41 clock)
#define LCD_CPL (720 *2)	    // active clocks per line

#define LCD_VBP (16)	// Vertical Back Porch(4 line)
#define LCD_VFP (3)	    // Vertical Front Porch(4 line)
#define LCD_VSW (3)	    // Vertical Sync Width(10 line)
#define LCD_LPS (240)	// active lines per screen

#define LCD_IVS (1)	    
#define LCD_IHS (1)	    
#define LCD_IEO (0)	    
#define LCD_BCD (1)	    
#define LCD_BPP (2)	    
#define LCD_BGR (0)	    
#define LCD_IPS (1)
#define LCD_VIDEO_SYNC_EN (0)
#endif
#ifdef __DM_PAL_TEST__
#define MODE         4
#define FRAME_WIDTH  720
#define FRAME_HEIGHT 240
#define CURSOR_WIDTH  720
#define CURSOR_HEIGHT 288
#define GRAPHIC_WIDTH  720
#define GRAPHIC_HEIGHT 288
#define VIDEO_WIDTH  720
#define VIDEO_HEIGHT 288
#define LCD_HFP	(23)	        // Horizontal Front Porch(2 clock)
#define LCD_HSW	(132)	        // Horizontal Sync Width(41 clock)
#define LCD_HBP	((132*2)-131)	// Horizontal Back Porch(2 clock)
#define LCD_CPL (720 *2)	    // active clocks per line

#define LCD_VSW (2)	    // Vertical Sync Width(10 line)
#define LCD_LPS (288)	// active lines per screen
#define LCD_VBP (20)	// Vertical Back Porch(4 line)
#define LCD_VFP (2)	    // Vertical Front Porch(4 line)

#define LCD_IVS (1)	    
#define LCD_IHS (1)	    
#define LCD_IEO (0)	    
#define LCD_BCD (1)	    
#define LCD_BPP (2)	    
#define LCD_BGR (0)	    
#define LCD_IPS (1)
#define LCD_VIDEO_SYNC_EN (0)
#endif
#ifdef __DM_LCD_TEST__
#define MODE 0
#define FRAME_WIDTH 480
#define FRAME_HEIGHT 272
#define CURSOR_WIDTH  480
#define CURSOR_HEIGHT 272
#define GRAPHIC_WIDTH  480
#define GRAPHIC_HEIGHT 272
#define VIDEO_WIDTH  480
#define VIDEO_HEIGHT 272

#define LCD_HFP	(2)	// Horizontal Front Porch(2 clock)
#define LCD_HSW	(41)	// Horizontal Sync Width(41 clock)
#define LCD_HBP	(2)	// Horizontal Back Porch(2 clock)
#define LCD_CPL (480)	// active clocks per line

#define LCD_VFP (4)	
#define LCD_VBP (4)	
#define LCD_VSW (10)	
#define LCD_LPS (272)	// active lines per screen

#define LCD_IVS (1)	    
#define LCD_IHS (1)	    
#define LCD_IEO (0)	    
#define LCD_BCD (1)	    
#define LCD_BPP (0)	    
#define LCD_BGR (0)	    
#define LCD_IPS (0)
#define LCD_VIDEO_SYNC_EN (1)
#endif

#define CURSOR_PLANE_DISABLE	0x1
#define GRAPHIC_PLANE_DISABLE	0x2
#define VIDEO_PLANE_DISABLE		0x4

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
extern smtUint32 DMSyncEnable(void);
extern smtUint32 DMEnable(void);
extern smtUint32 DMCursorOn(smtUint32 frameAddr, smtUint32 stride, smtUint8 pixFmt);
extern smtUint32 DMGraphicOn(smtUint32 frameAddr, smtUint32 stride, smtUint8 pixFmt);
extern smtUint32 DMVideoOn(smtUint32 frameAddr, smtUint32 stride, smtUint8 pixFmt);
extern smtUint32 DMVIFEnable(void);
extern smtUint32 DMVEncEnable(void);
extern void DMDisable(smtUint8 targetPlane);
extern void DMVEncDisable(void);
extern void DMVIFDisable(void);
#endif//__DISPLAY_TEST_UTILLS_H__