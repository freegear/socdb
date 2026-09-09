/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: lcd.c 
	Description	: LCD test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "lcd.h"
#include "global.h"
#include "lcd_pre_drv.h"
#include "uart_post_drv.h"
#include "videoenc_post_drv.h"
#include "videoenc_pre_drv.h"
//#define __DM_SCREEN_CMP_TEST__
//cursor image
#if 0
#include "cursor_565_even.c"
#include "cursor_565_odd.c"
#include "cursor_565_prog.h"
#else
unsigned char *cursor_even = 0;
unsigned char *cursor_odd = 0;
//unsigned char *cursor_buffer = 0;
#ifdef __DM_SCREEN_CMP_TEST__
#include "cursor_565_gmx.h"
#else
#include "cursor_565_prog.h"
#endif
#endif

//graphic image
#if 0
#include "graphic_888_even.c"
#include "graphic_888_odd.c"
#include "graphic_888_prog.c"
#else
unsigned char *graphic_even = 0;
unsigned char *graphic_odd = 0;
//unsigned char *graphic_buffer = 0;
#ifdef __DM_SCREEN_CMP_TEST__
#include "graphic_888_gmx.c"
#else
#include "graphic_888_prog.c"
#endif
#endif
//video image
#if 0
#include "video_yuv_even.c"
#include "video_yuv_odd.c"
#include "video_yuv_prog.c"
#else
unsigned char *video_even = 0;
unsigned char *video_odd = 0;
//unsigned int *video_buffer = 0;
#include "video_yuv_prog.c"
#endif


/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

#define DM_CURSOR_PLANE_TEST	1
#define DM_GRAPHIC_PLANE_TEST	0
#define DM_VIDEO_PLANE_TEST		0
#define DM_OVERLAY_TEST			0
#define LUMA_FILTER_SEL     0
#define CHRO_FILTER_SEL     3
#define EN_COLOR_KILL       0
#define EN_REST_SCH         1
#define EN_INTERNAL_PATTERN 0
#define COLOR_PATTERN_MODE  0
#define CHRO_DELAY          0
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
#define IMAGE_TEST //only ntsc

#define NTSC
#ifdef NTSC
#define MODE         0

//#define FRAME_WIDTH  720
//#define FRAME_HEIGHT 240
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
#else
#define MODE         4
#define FRAME_WIDTH  720
#define FRAME_HEIGHT 288

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
#endif
/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

smtUint32 DMTest(void);
static smtUint32 DMInit(void);
void ISRDM(smtUint32 irq);
static void VideoEncoderEnable(void);
static smtUint32 DMCursorPlaneTest(smtBoolean bProgressive);
static smtUint32 DMGraphicPlaneTest(smtBoolean bProgressive);
static smtUint32 DMVideoPlaneTest(smtBoolean bProgressive);
static smtUint32 DMOverlayTest(smtBoolean bProgressive);
static void VideoEncoderDisable(void);
static void DMDisable(void);
extern int UARTDataAvailable(void);
/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/

// Edit your code
volatile smtUint8 bChgEvenFrame = SMT_FALSE, bChgOddFrame = SMT_FALSE;
/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: DMTest()
	Prototype		: smtUint32 LCDTest(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 DMTest(void)
{
	
	UartConfig uartBasicCfg;
	DMPlaneCtrl dmPlaneCtrl;
	
	smtUint32 errCode;
	
	smtBoolean bProgressive = SMT_TRUE;
	// uart init
	uartBasicCfg.baudrate		= 38400;
	uartBasicCfg.enInt			= 0x0;
	uartBasicCfg.enRxTimeout	= 0x0;
	uartBasicCfg.swReset		= 0x0;
	uartBasicCfg.enDmaReq		= 0x0;
	uartBasicCfg.parity			= 0x00;
	uartBasicCfg.dataBit		= 0x1;
	uartBasicCfg.stopBit		= 0x0;
	uartBasicCfg.enLoopBack		= 0x0;
	uartBasicCfg.txWaterLev		= 0x0;
	uartBasicCfg.rxWaterLev		= 0x0;
	uartBasicCfg.uartCh			= 0;
	smt2UartInit(uartBasicCfg);

	//	Init Video Encoder
	smt2UartPrint(11,"enter to enable video encoder\n");
	smt2UartGetCh(0);
	VideoEncoderEnable();

	//	Init Display Module - master register
	smt2UartPrint(11,"enter to enable display module\n");
	smt2UartGetCh(0);
	errCode = DMInit();
	//	register Display module ISR
	smt2UartPrint(11,"Request IRQ !! \n");
	smt2UartGetCh(0);
	RequestIRQ(IRQ_DM, ISRDM);	// DM irq : 18

	//cursor plane test
	smt2UartPrint(11,"cursor plane test \n");
	bProgressive = smt2UartGetCh(0);
	errCode = DMCursorPlaneTest(bProgressive);
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;
	smtDMGetCCtrl(&dmPlaneCtrl);
	dmPlaneCtrl.xEn = 0x0;
	smtDMSetCCtrl(dmPlaneCtrl);

	//graphic plane test
	smt2UartPrint(11,"graphic plane test \n");
	bProgressive = smt2UartGetCh(0);
	errCode = DMGraphicPlaneTest(bProgressive);
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;
	smtDMGetGCtrl(&dmPlaneCtrl);
	dmPlaneCtrl.xEn = 0x0;
	smtDMSetGCtrl(dmPlaneCtrl);

	//video plane test
	smt2UartPrint(11,"video plane test \n");
	bProgressive = smt2UartGetCh(0);
	errCode = DMVideoPlaneTest(bProgressive);
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;
	smtDMGetVCtrl(&dmPlaneCtrl);
	dmPlaneCtrl.xEn = 0x0;
	smtDMSetVCtrl(dmPlaneCtrl);

	//Overlay test
	smt2UartPrint(11,"Overlay test \n");
	bProgressive = smt2UartGetCh(0);
	errCode = DMOverlayTest(bProgressive);
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;
	
	DMDisable();
	VideoEncoderDisable();

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: DMInit()
	Prototype		: static smtUint32 DMInit(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static smtUint32 DMInit(void)
{
	
	DMCtrl dmCtrl;
	DMLcdCtrl dmLcdCtrl;
	DMHSync0Ctrl dmHSync0;
	DMHSync1Ctrl dmHSync1;
	DMVSync0Ctrl dmVSync0;
	DMVSync1Ctrl dmVSync1;
	
	//1. set DM control
	dmCtrl.prioritySel 	= 0x1;
	dmCtrl.swReset		= 0x0;
	dmCtrl.errIntEn 	= 0x0;
	dmCtrl.startIntEn	= 0x1;
	dmCtrl.endIntEn		= 0x0;
	smtDMSetMasterCtrl(dmCtrl);

	//2. set Back ground Colour
	smtDMSetBGCol(0xFF0000);

	//3. set LCD IF(LCDCON, HSYNC0, HSYNC1, VSYNC0, VSYNC1)
	dmHSync0.tHFrontPorch		= LCD_HFP;
	dmHSync0.tHBackPorch		= LCD_HBP;
	smtDMSetHSync0(dmHSync0);
		
	dmHSync1.tHDspPixPerLine	= LCD_CPL;
	dmHSync1.tHPulsWidth		= LCD_HSW;
	smtDMSetHSync1(dmHSync1);
	
	dmVSync0.tVFrontPorch		= LCD_VFP;
	dmVSync0.tVBackPorch		= LCD_VBP;
	smtDMSetVSync0(dmVSync0);
	
	dmVSync1.tVDspPeriod	= LCD_LPS;
	dmVSync1.tVPulsWidth	= LCD_VSW;
	smtDMSetVSync1(dmVSync1);

	dmLcdCtrl.invertHSync	= LCD_IHS;
	dmLcdCtrl.invertVSync	= LCD_IVS;
	dmLcdCtrl.invertPixClk	= LCD_IPS;
	dmLcdCtrl.invertWrEn	= LCD_IEO;
	dmLcdCtrl.lcdBpp		= LCD_BPP;//shkim-20070201: check bit order
	dmLcdCtrl.rbSwap		= LCD_BGR;//shkim-20070201: check bit order
	dmLcdCtrl.pDiv			= 0x0;
	dmLcdCtrl.lcdPwrEn		= 0x1;
	dmLcdCtrl.lcdEn			= LCD_VIDEO_SYNC_EN; // video sync enable
	smtDMSetLCDCtrl(dmLcdCtrl);
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: DMCursorPlaneTest()
	Prototype		: static smtUint32 DMCursorPlaneTest(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static smtUint32 DMCursorPlaneTest(smtBoolean bProgressive)
{
	DMPlaneCtrl cPlaneCfg;
	DMPlaneBlnd cPlaneBlnd;
	DMPlaneBlndMode cPlaneBlndMode;
	smtUint32 i;
	smtUint8 uart_input;

	smtUint16 *frame0 = (smtUint16 *)CURSOR_BASEADDR;
	smtUint16 *frame1 = (smtUint16 *)(CURSOR_BASEADDR+(CURSOR_HEIGHT*CURSOR_WIDTH*2));
	if(bProgressive == SMT_TRUE)//bProgressive test
	{
		for(i = 0; i < CURSOR_HEIGHT*CURSOR_WIDTH*2; i++)
		*(frame0+i) = cursor_buffer[i];
	}
	else//interlaced test
	{
		for(i = 0; i < CURSOR_HEIGHT*CURSOR_WIDTH; i++)
		*(frame0+i) = cursor_even[i];

		for(i = 0; i < CURSOR_HEIGHT*CURSOR_WIDTH; i++)
		*(frame1+i) = cursor_odd[i];
	}

	//1. set chromakey/alpha value(BLEND)
	cPlaneBlnd.alpha	= 0xFF;
	cPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetCBlnd(cPlaneBlnd);
	
	//2. set planexref/base address
	//	- BASE(stride) / ADDR register(framebuffer)
	
	if(bProgressive == 1)
	{
		smtDMSetCBase(CURSOR_WIDTH >> 1);
		smtDMSetCAddr((smtUint32)frame0);
	}
	else
	{
		smtDMSetCBase(0x0);
		smtDMSetCAddr((smtUint32)frame0);
	}
	
	//3. set blenmode
	cPlaneBlndMode.xPos = 0;
	cPlaneBlndMode.yPos = 0;
	cPlaneBlndMode.colKeyEn = 0x0;
	cPlaneBlndMode.blendMod = 0x0; //0:no alpha , 2: global alpha, 3: pixel alpha
	smtDMSetCBlndMode(cPlaneBlndMode);
	
	//4. set plane control register
	cPlaneCfg.xEn 		= 0x1;
	cPlaneCfg.pixFmt 	= 0x3;//0:8BPP,1:RGB332 2:ARGB(1555) 3:RGB565
	cPlaneCfg.gammaEn	= 0x0;
	cPlaneCfg.sWidth 	= CURSOR_WIDTH;
	cPlaneCfg.sHeight	= CURSOR_HEIGHT;
	smtDMSetCCtrl(cPlaneCfg);	

	smt2UartPrint(11,"press enter to start even/odd switching\n");
	smt2UartGetCh(0);

	smt2UartPrint(11,"press '0' to exit cursor plane test\n");

	while(1)
	{
		if(bChgEvenFrame)
		{
			DBG_GPIO0_OUT 	= 0x000F;
			bChgEvenFrame 	= SMT_FALSE;
			//set start of even field
			smtDMSetCAddr((smtUint32)CURSOR_BASEADDR);
		} 
		else if(bChgOddFrame)
		{
			DBG_GPIO0_OUT 	= 0xF000;
			bChgOddFrame 	= SMT_FALSE;
			//set start of odd field
			if(bProgressive == SMT_TRUE)
				smtDMSetCAddr((smtUint32)CURSOR_BASEADDR+(CURSOR_WIDTH*2));
			else
				smtDMSetCAddr((smtUint32)CURSOR_BASEADDR+(CURSOR_HEIGHT*CURSOR_WIDTH*2));
		}
		
		if(UARTDataAvailable())
		{
			uart_input = smt2UartGetCh(0);
			if(uart_input == '0')
			{
				break;
			}
		}
	}
	/*
	1.test pixel format
		-palette(8BPP)/RGB332/RGB565/ARGB1555
		
	2.test changing src width, srcStartX,Y
	
	3.test changing plane x,y position
	
	4.test alpha blending/chromakey
	*/
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: DMGraphicPlaneTest()
	Prototype		: static smtUint32 DMGraphicPlaneTest(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static smtUint32 DMGraphicPlaneTest(smtBoolean bProgressive)
{
	DMPlaneCtrl gPlaneCfg;
	DMPlaneBlnd gPlaneBlnd;
	DMPlaneBlndMode gPlaneBlndMode;
	smtUint32 i;

	smtUint32 *frame0 = (smtUint32 *)GRAPHIC_BASEADDR;
	smtUint32 *frame1 = (smtUint32 *)(GRAPHIC_BASEADDR+(GRAPHIC_HEIGHT*GRAPHIC_WIDTH*4));
	smtUint8 uart_input =0;
	smtUint32 wrData = 0;

	if(bProgressive == SMT_TRUE)
	{
		for(i = 0; i < (GRAPHIC_HEIGHT*2)*GRAPHIC_WIDTH *3 ;)
		{
			wrData = 0;
			wrData = graphic_buffer[i++];
			wrData = wrData | (graphic_buffer[i++] << 8);
			wrData = wrData | (graphic_buffer[i++] <<16);
			*(frame0++) = wrData;
		}
	}
	else
	{
		for(i = 0; i < GRAPHIC_HEIGHT*GRAPHIC_WIDTH *3 ;)
		{
			wrData = graphic_even[i++];
			wrData = wrData | (graphic_even[i++] << 8);
			wrData = wrData | (graphic_even[i++] <<16);
			*(frame0++) = wrData;
		}

		for(i = 0; i < GRAPHIC_HEIGHT*GRAPHIC_WIDTH *3 ;)
		{
			wrData = graphic_odd[i++];
			wrData = wrData | (graphic_odd[i++] << 8);
			wrData = wrData | (graphic_odd[i++] <<16);

			*(frame1++) = wrData;
		}
	}
	frame0 = (smtUint32 *)GRAPHIC_BASEADDR;
	
	//1. set chromakey/alpha value(BLEND)
	//	- BLEND register
	gPlaneBlnd.alpha	= 0xFF;
	gPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetGBlnd(gPlaneBlnd);
	
	//2. set planexref/base address
	//	- BASE(stride) / ADDR register(framebuffer)
	if(bProgressive == SMT_TRUE)
	{
		smtDMSetGBase(720);
		smtDMSetGAddr((smtUint32)frame0);
	}
	else
	{
		smtDMSetGBase(0x0);
		smtDMSetGAddr((smtUint32)frame0);
	}
	
	//3. set blenmode
	//	- BLENDMODE
	//	- alpha , chromakey en/disable
	//	- plane x,y position
	gPlaneBlndMode.xPos = 0;
	gPlaneBlndMode.yPos = 0;
	gPlaneBlndMode.colKeyEn = 0x0;
	gPlaneBlndMode.blendMod = 0x2; //0:no alpha , 2: global alpha, 3: pixel alpha
	smtDMSetGBlndMode(gPlaneBlndMode);
	
	//4. set plane control register
	//	- plane enable
	//	- plane pixel format
	//	- plane surface width , height
	gPlaneCfg.xEn 		= 0x1;
	gPlaneCfg.pixFmt 	= 0x4;//0:8BPP,2:RGB565,3:ARGB1555, 4:RGB888, 5:ARGB8888
	gPlaneCfg.gammaEn	= 0x0;
	gPlaneCfg.sWidth 	= GRAPHIC_WIDTH;
	gPlaneCfg.sHeight	= GRAPHIC_HEIGHT;

	smtDMSetGCtrl(gPlaneCfg);
	smt2UartPrint(11,"enter to switch even/odd frame !\n");
	smt2UartGetCh(0);
	smt2UartPrint(11,"press '0' to exit graphic plane test\n");
	while(1)
	{
		if(bChgEvenFrame)
		{
			bChgEvenFrame 	= SMT_FALSE;
			smtDMSetGAddr((smtUint32)GRAPHIC_BASEADDR);			

		}
		else if(bChgOddFrame)
		{
			bChgOddFrame 	= SMT_FALSE;
			if(bProgressive == SMT_TRUE)
				smtDMSetGAddr((smtUint32)(GRAPHIC_BASEADDR+(GRAPHIC_WIDTH*4)));
			else
				smtDMSetGAddr((smtUint32)(GRAPHIC_BASEADDR+(GRAPHIC_HEIGHT*GRAPHIC_WIDTH*4)));
		}
		
		if(UARTDataAvailable())
		{
			uart_input = smt2UartGetCh(0);
			if(uart_input == '0')
			{
				break;
			}
		}
	}
	/*
	1.test pixel format
		-palette(8BPP)/RGB565/RGB888/ARGB8888/ARGB1555
		
	2.test changing src width, srcStartX,Y
	
	3.test changing plane x,y position
	
	4.test alpha blending/chromakey
	*/
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: DMVideoPlaneTest()
	Prototype		: static smtUint32 DMVideoPlaneTest(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static smtUint32 DMVideoPlaneTest(smtBoolean bProgressive)
{
	DMPlaneCtrl vPlaneCfg;
	DMPlaneBlnd vPlaneBlnd;
	DMPlaneBlndMode vPlaneBlndMode;
	smtUint32 i ;

	smtUint16 *frame0 = (smtUint16 *)VIDEO_BASEADDR;
	smtUint16 *frame1 = (smtUint16 *)(VIDEO_BASEADDR+(VIDEO_HEIGHT*VIDEO_WIDTH*2));

	
	if(bProgressive == SMT_TRUE)
	{
		for(i = 0; i < (VIDEO_HEIGHT*2)*VIDEO_WIDTH; i++)
			*(frame0+i) = video_buffer[i];	
	}
	else
	{
		for(i = 0; i < VIDEO_HEIGHT*VIDEO_WIDTH; i++)
			*(frame0+i) = video_even[i];

		for(i = 0; i < VIDEO_HEIGHT*VIDEO_WIDTH; i++)
			*(frame1+i) = video_odd[i];
	}

	//1. set chromakey/alpha value(BLEND)
	//	- BLEND register
	vPlaneBlnd.alpha	= 0xFF;
	vPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetVBlnd(vPlaneBlnd);
	
	//2. set planexref/base address
	//	- BASE(stride) / ADDR register(framebuffer)
	if(bProgressive == SMT_TRUE)
	{
		smtDMSetVBase(VIDEO_WIDTH >> 1);
		smtDMSetVAddr((smtUint32)frame0);
	}
	else
	{
		smtDMSetVBase(0x0);
		smtDMSetVAddr((smtUint32)frame0);
	}
	//smtDMSetVAddr2(0x00000000);
	
	//3. set blenmode
	//	- BLENDMODE
	//	- alpha , chromakey en/disable
	//	- plane x,y position
	vPlaneBlndMode.xPos = 0;
	vPlaneBlndMode.yPos = 0;
	vPlaneBlndMode.colKeyEn = 0x0;
	vPlaneBlndMode.blendMod = 0x0; //0:no alpha , 2: global alpha, 3: pixel alpha
	smtDMSetVBlndMode(vPlaneBlndMode);
	
	//4. set plane control register
	//	- plane enable
	//	- plane pixel format
	//	- plane surface width , height
	vPlaneCfg.xEn 		= 0x1;
	vPlaneCfg.pixFmt 	= 0x3;//
	vPlaneCfg.vPlaneIFEn = 0x0;// interlaced video source
	vPlaneCfg.vPlaneN2PUpEn = 0x0;
	vPlaneCfg.sWidth 	= VIDEO_WIDTH;
	vPlaneCfg.sHeight	= VIDEO_HEIGHT;
	smtDMSetVCtrl(vPlaneCfg);
	
	smt2UartPrint(11,"enter to switch even/odd \n");
	smt2UartGetCh(0);
	smt2UartPrint(11,"press '0' to exit video plane test\n");
	
	while(1)
	{
		smtUint8 uart_input = 0;
		
		if(bChgEvenFrame) 
		{
			DBG_GPIO0_OUT 	= 0x000F;
			bChgEvenFrame 	= SMT_FALSE;
			smtDMSetVAddr((smtUint32)VIDEO_BASEADDR);
			
		} 
		else if(bChgOddFrame)
		{
			DBG_GPIO0_OUT 	= 0xF000;
			bChgOddFrame 	= SMT_FALSE;
			if(bProgressive == SMT_TRUE)
				smtDMSetVAddr((smtUint32)(VIDEO_BASEADDR+(VIDEO_WIDTH*2)));
			else
				smtDMSetVAddr((smtUint32)(VIDEO_BASEADDR+(VIDEO_HEIGHT*VIDEO_WIDTH*2)));
		}
		if(UARTDataAvailable())
		{
			uart_input = smt2UartGetCh(0);
			if(uart_input == '0')
			{
				break;
			}
		}
	}
	
	/*		
	1.test pixel format
		-YUV422( U lsb, V lsb, Y0 lsb[Y0UY1V], Y0 lsb[Y0VY1U])
		
	2.test changing src width, srcStartX,Y
	//need to modify base/ address register 
	3.test changing plane x,y position
	
	4.test alpha blending/chromakey
	*/
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: DMOverlayTest()
	Prototype		: static smtUint32 DMOverlayTest(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static smtUint32 DMOverlayTest(smtBoolean bProgressive)
{
	DMPlaneCtrl gPlaneCfg,cPlaneCfg,vPlaneCfg;
	DMPlaneBlnd gPlaneBlnd,cPlaneBlnd,vPlaneBlnd;
	DMPlaneBlndMode gPlaneBlndMode,cPlaneBlndMode,vPlaneBlndMode;
	smtUint32 i;
	
	smtUint8  alphaVal = 0xFF, alphaValCursor = 0;
#if 1// frame buffer variables
	smtUint16 *cFrame0 = (smtUint16 *)CURSOR_BASEADDR;
	smtUint16 *cFrame1 = (smtUint16 *)(CURSOR_BASEADDR+(CURSOR_HEIGHT*CURSOR_WIDTH*2));
	smtUint32 *gFrame0 = (smtUint32 *)GRAPHIC_BASEADDR;
	smtUint32 *gFrame1 = (smtUint32 *)(GRAPHIC_BASEADDR+(GRAPHIC_HEIGHT*GRAPHIC_WIDTH*4));
	smtUint16 *vFrame0 = (smtUint16 *)VIDEO_BASEADDR;
	smtUint16 *vFrame1 = (smtUint16 *)(VIDEO_BASEADDR+(VIDEO_HEIGHT*VIDEO_WIDTH*2));
	smtUint32 wrData = 0;
#endif	

	smt2UartPrint(11,"start to copy cursor plane image !! \n");
	smt2UartGetCh(0);

#if 1 // copy cursor image to DDR
	
	if(bProgressive == SMT_TRUE)//bProgressive test
	{
		for(i = 0; i < CURSOR_HEIGHT*CURSOR_WIDTH*2; i++)
		*(cFrame0+i) = cursor_buffer[i];
	}
	else//interlaced test
	{
		for(i = 0; i < CURSOR_HEIGHT*CURSOR_WIDTH; i++)
		*(cFrame0+i) = cursor_even[i];

		for(i = 0; i < CURSOR_HEIGHT*CURSOR_WIDTH; i++)
		*(cFrame1+i) = cursor_odd[i];
	}
#endif

	smt2UartPrint(11,"start to copy graphic plane image !! \n");
	smt2UartGetCh(0);

#if 1 // copy graphic image to DDR
	if(bProgressive == SMT_TRUE)
	{
		for(i = 0; i < (GRAPHIC_HEIGHT*2)*GRAPHIC_WIDTH *3 ;)
		{
			wrData = 0;
			wrData = graphic_buffer[i++];
			wrData = wrData | (graphic_buffer[i++] << 8);
			wrData = wrData | (graphic_buffer[i++] <<16);
			*(gFrame0++) = wrData;
		}
	}
	else
	{
		for(i = 0; i < GRAPHIC_HEIGHT*GRAPHIC_WIDTH *3 ;)
		{
			wrData = graphic_even[i++];
			wrData = wrData | (graphic_even[i++] << 8);
			wrData = wrData | (graphic_even[i++] <<16);
			*(gFrame0++) = wrData;
		}

		for(i = 0; i < GRAPHIC_HEIGHT*GRAPHIC_WIDTH *3 ;)
		{
			wrData = graphic_odd[i++];
			wrData = wrData | (graphic_odd[i++] << 8);
			wrData = wrData | (graphic_odd[i++] <<16);

			*(gFrame1++) = wrData;
		}
	}
#endif

	smt2UartPrint(11,"start to copy video plane image !! \n");
	smt2UartGetCh(0);

#if 1
	if(bProgressive == SMT_TRUE)
	{
		for(i = 0; i < (VIDEO_HEIGHT*2)*VIDEO_WIDTH; i++)
			*(vFrame0+i) = video_buffer[i];	
	}
	else
	{
		for(i = 0; i < VIDEO_HEIGHT*VIDEO_WIDTH; i++)
			*(vFrame0+i) = video_even[i];

		for(i = 0; i < VIDEO_HEIGHT*VIDEO_WIDTH; i++)
			*(vFrame1+i) = video_odd[i];
	}
#endif

	smt2UartPrint(11,"start to enable cursor plane !! \n");
	smt2UartGetCh(0);

#if 1 // enable cursor plane
	//1. set chromakey/alpha value(BLEND)
	cPlaneBlnd.alpha	= 0xFF;
	cPlaneBlnd.colKey	= 0x000000;
	smtDMSetCBlnd(cPlaneBlnd);
	
	//2. set planexref/base address
	//	- BASE(stride) / ADDR register(framebuffer)
	if(bProgressive == 1)
	{
		smtDMSetCBase(CURSOR_WIDTH >> 1);
		smtDMSetCAddr((smtUint32)cFrame0);
	}
	else
	{
		smtDMSetCBase(0x0);
		smtDMSetCAddr((smtUint32)cFrame0);
	}
	
	//3. set blenmode
	cPlaneBlndMode.xPos = 0;
	cPlaneBlndMode.yPos = 0;
	cPlaneBlndMode.colKeyEn = 0x0;
	cPlaneBlndMode.blendMod = 0x2; //0:no alpha , 2: global alpha, 3: pixel alpha
	smtDMSetCBlndMode(cPlaneBlndMode);
	
	//4. set plane control register
	cPlaneCfg.xEn 		= 0x1;
	cPlaneCfg.pixFmt 	= 0x3;//0:8BPP,1:RGB332 2:ARGB(1555) 3:RGB565
	cPlaneCfg.gammaEn	= 0x0;
	cPlaneCfg.sWidth 	= CURSOR_WIDTH;
	cPlaneCfg.sHeight	= CURSOR_HEIGHT;
	smtDMSetCCtrl(cPlaneCfg);	
#endif

#if 0 // changing cursor display position 
	while(1)
	{
		smtUint32 i;
		smtUint8 inputChar;
		for(i = 0 ; i < 240 ; i++)
		{
			cPlaneBlndMode.xPos = 200;
			cPlaneBlndMode.yPos = i;
			cPlaneBlndMode.colKeyEn = 0x0;
			cPlaneBlndMode.blendMod = 0x0; //0:no alpha , 2: global alpha, 3: pixel alpha
			smtDMSetCBlndMode(cPlaneBlndMode);
		smt2UartPrint(11,"enter to change x coodination to [%d]! \n", i);
		inputChar = smt2UartGetCh(0);
		if (inputChar == '0')
			break;
		}
		if(inputChar == '0')
			break;
	}
#endif	

	smt2UartPrint(11,"start to enable graphic plane !! \n");
	smt2UartGetCh(0);

#if 1 //enable graphic plane
	gFrame0 = (smtUint32 *)(GRAPHIC_BASEADDR);
	//1. set chromakey/alpha value(BLEND)
	//	- BLEND register
	gPlaneBlnd.alpha	= 0xFF;
	gPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetGBlnd(gPlaneBlnd);
	
	//2. set planexref/base address
	if(bProgressive == SMT_TRUE)
	{
		smtDMSetGBase(GRAPHIC_WIDTH);
		smtDMSetGAddr((smtUint32)gFrame0);
	}
	else
	{
		smtDMSetGBase(0x0);
		smtDMSetGAddr((smtUint32)gFrame0);
	}
	
	//3. set blenmode
	//	- BLENDMODE
	//	- alpha , chromakey en/disable
	//	- plane x,y position
	gPlaneBlndMode.xPos = 0;
	gPlaneBlndMode.yPos = 0;
	gPlaneBlndMode.colKeyEn = 0x1;
	gPlaneBlndMode.blendMod = 0x0; //0:no alpha , 2: global alpha, 3: pixel alpha
	smtDMSetGBlndMode(gPlaneBlndMode);
	
	//4. set plane control register
	//	- plane enable
	//	- plane pixel format
	//	- plane surface width , height
	gPlaneCfg.xEn 		= 0x1;
	gPlaneCfg.pixFmt 	= 0x4;//0:8BPP,2:RGB565,3:ARGB1555, 4:RGB888, 5:ARGB8888
	gPlaneCfg.gammaEn	= 0x0;
	gPlaneCfg.sWidth 	= GRAPHIC_WIDTH;
	gPlaneCfg.sHeight	= GRAPHIC_HEIGHT;

	smtDMSetGCtrl(gPlaneCfg);
#endif

	smt2UartPrint(11,"start to enable video plane !! \n");
	//smt2UartGetCh(0);

#if 1//enable video plane
	//1. set chromakey/alpha value(BLEND)
	//	- BLEND register
	vPlaneBlnd.alpha	= 0xFF;
	vPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetVBlnd(vPlaneBlnd);
	
	//2. set planexref/base address
	//	- BASE(stride) / ADDR register(framebuffer)
	if(bProgressive == SMT_TRUE)
	{
		smtDMSetVBase(VIDEO_WIDTH >> 1);
		smtDMSetVAddr((smtUint32)vFrame0);
	}
	else
	{
		smtDMSetVBase(0x0);
		smtDMSetVAddr((smtUint32)vFrame0);
	}
	
	//3. set blenmode
	//	- BLENDMODE
	//	- alpha , chromakey en/disable
	//	- plane x,y position
	vPlaneBlndMode.xPos = 0;
	vPlaneBlndMode.yPos = 0;
	vPlaneBlndMode.colKeyEn = 0x0;
	vPlaneBlndMode.blendMod = 0x0; //0:no alpha , 2: global alpha, 3: pixel alpha
	smtDMSetVBlndMode(vPlaneBlndMode);
	
	//4. set plane control register
	//	- plane enable
	//	- plane pixel format
	//	- plane surface width , height
	vPlaneCfg.xEn 		= 0x1;
	vPlaneCfg.pixFmt 	= 0x3;//
	vPlaneCfg.vPlaneIFEn = 0x0;// interlaced video source
	vPlaneCfg.vPlaneN2PUpEn = 0x0;
	vPlaneCfg.sWidth 	= VIDEO_WIDTH;
	vPlaneCfg.sHeight	= VIDEO_HEIGHT;
	smtDMSetVCtrl(vPlaneCfg);
#endif

	smt2UartPrint(11,"start to swich even/odd field !! \n");
	//smt2UartGetCh(0);
	smt2UartPrint(11,"press '0' to exit overlay test\n");
	
	//swiching even/odd field image
	while(1)
	{
		
		smtUint8 uart_input;
		if(bChgEvenFrame)
		{
			smtDMSetCAddr((smtUint32)CURSOR_BASEADDR);
			smtDMSetGAddr((smtUint32)GRAPHIC_BASEADDR);
			smtDMSetVAddr((smtUint32)VIDEO_BASEADDR);
			bChgEvenFrame = SMT_FALSE;
		}
		else if(bChgOddFrame)
		{
			if(bProgressive == SMT_TRUE)
			{
				smtDMSetCAddr((smtUint32)CURSOR_BASEADDR+(CURSOR_WIDTH*2));
				smtDMSetGAddr((smtUint32)(GRAPHIC_BASEADDR+(GRAPHIC_WIDTH*4)));
				smtDMSetVAddr((smtUint32)(VIDEO_BASEADDR+(VIDEO_WIDTH*2)));
			}
			else
			{
				smtDMSetCAddr((smtUint32)(CURSOR_BASEADDR+(CURSOR_HEIGHT*CURSOR_WIDTH*2)));
				smtDMSetGAddr((smtUint32)(GRAPHIC_BASEADDR+(GRAPHIC_HEIGHT*GRAPHIC_WIDTH*4)));
				smtDMSetVAddr((smtUint32)(VIDEO_BASEADDR+(VIDEO_HEIGHT*VIDEO_WIDTH*2)));
			}
			bChgOddFrame = SMT_FALSE;

			#if 1
		gPlaneBlnd.alpha	= alphaVal--;
		gPlaneBlnd.colKey	= 0xFFFFFF;
		smtDMSetGBlnd(gPlaneBlnd);

		cPlaneBlnd.alpha	= alphaValCursor++;
		cPlaneBlnd.colKey	= 0x000000;
		smtDMSetCBlnd(cPlaneBlnd);
#endif		
		}


		if(UARTDataAvailable())
		{
			uart_input = smt2UartGetCh(0);
			if(uart_input == '0')
			break;
		}
	}
	
	return SMT_SUCCESS;
}
/*-----------------------------------------------------------------------
    Function name   : VideoEncoderEnable()
    Prototype       : void VideoEncoderEnable(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
static void VideoEncoderEnable(void)
{
	VEncCtrl vCtrl;
	VEncInternal vInternal;
	VEncStatus vStatus;

	//set Video Encoder Ctrl Register
	vCtrl.encMode	= MODE;
	vCtrl.sanning	= EN_NONINTERLACE;
	vCtrl.SqPixel	= EN_SQPIXEL;
	vCtrl.DAC0		= EN_DAC0;
	vCtrl.DAC1		= EN_DAC1;
	vCtrl.DAC2		= EN_DAC2;

	//set Video Encoder internal Register
	vInternal.hSyncWidth	= HSYNC_WID;
	vInternal.burstWidth	= BURST_WID;
	vInternal.lDelay		= LUMA_DELAY;
	vInternal.cDelay		= CHRO_DELAY;
	vInternal.patternMode	= EN_INTERNAL_PATTERN;
	vInternal.pattern		= COLOR_PATTERN_MODE;
	vInternal.resetSCH		= EN_REST_SCH;
	vInternal.color			= EN_COLOR_KILL;
	vInternal.CFilter		= CHRO_FILTER_SEL;
	vInternal.lFilter		= LUMA_FILTER_SEL;
	smtSetVideoEncode(&vCtrl,&vInternal);

	//set Video Encoder Status Register
	vStatus.Enable		= 0x1; // enable video encoder
	vStatus.fieldCount	= 0x0;
	vStatus.Hcount		= 0x0;
	vStatus.Vcount		= 0x0;
	smtSetVideoStatus(&vStatus);
}

/*----------------------------------------------------------
	Function name	: DMDisable()
	Prototype		: static void DMDisable(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static void DMDisable(void)
{
	DMPlaneCtrl dmPlaneCtrl;

	memset(&dmPlaneCtrl,0x0,sizeof(dmPlaneCtrl));
	smtDMSetCCtrl(dmPlaneCtrl);
	smtDMSetGCtrl(dmPlaneCtrl);
	smtDMSetVCtrl(dmPlaneCtrl);
}

/*----------------------------------------------------------
	Function name	: VideoEncoderDisable()
	Prototype		: static void VideoEncoderDisable(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static void VideoEncoderDisable(void)
{
	VEncStatus vStatus;

	memset(&vStatus,0x0,sizeof(vStatus));
	smtSetVideoStatus(&vStatus);
}

/*----------------------------------------------------------
	Function name	: ISRDM(smtUint32 irq)
	Prototype		: void ISRDM(smtUint32 irq)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void ISRDM(smtUint32 irq)
{
	// Already VIC DM interrupt bit is cleared by AckIRQ(irq).
	DMStatus dmSts;

	smtDMGetMasterStatus(&dmSts);
	if(dmSts.startFrame == 1)
	{
		if(dmSts.evenFieldInt == 1)
			bChgOddFrame = SMT_TRUE;
		else
			bChgEvenFrame = SMT_TRUE;
	}

	//smt2UartPrint(11,"Entered DM ISR status [0x%08x]\n", regData);
}

