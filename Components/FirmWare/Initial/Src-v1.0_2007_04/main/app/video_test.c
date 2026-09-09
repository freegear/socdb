/*----------------------------------------------------------
	File Name   : video_test.c 
	Description : Video Test Code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "videoenc_post_drv.h"
#include "videoenc_pre_drv.h"

#include "lcd_pre_drv.h"

#include "vif_pre_drv.h"

//FPGA GCC environment
//#include "gpio.h"
//#include "uart.h"


/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

#define NTSC 
#define IMAGE_TEST		//only ntsc
//#define LOGO_MOV		//only ntsc (IMAGE test sub function)
#define COLORBAR		//undefine --> 565COLORBAR mode
//#define SIMUL
#define USE_PALETTE


/* NTSC image */
#ifdef LOGO_MOV
#include "./test_interlace0.c"
#include "./test_interlace1.c"
#else
#include "./test565_interlace0.c"
#include "./test565_interlace1.c"
//#include "smtlogo565_interlace0.c"
//#include "smtlogo565_interlace1.c"
#endif

#define BLACK				0xff000000
#define RED					0xffff0000
#define GREEN				0xff00ff00
#define YELLOW				0xffffff00
#define BLUE				0xff0000ff
#define CYAN				0xffff00ff
#define MAGENTA				0xff00ffff
#define WHITE				0xffffffff

#define BLACK565			0x00000000
#define RED565				0xF800F800
#define GREEN565			0x07E007E0
#define MAGENTA565			0xFFE0FFE0
#define BLUE565				0x001f001f
#define CYAN565				0xf81ff81f
#define YELLOW565			0x07ff07ff
#define WHITE565			0xffffffff

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

#ifdef NTSC
#define MODE				0
#define FRAME_WIDTH			720
#define FRAME_HEIGHT		240
#define LCD_HFP				(31)	        // Horizontal Front Porch(2 clock)
#define LCD_HSW				(122)	        // Horizontal Sync Width(41 clock)
#define LCD_HBP				((122*2)-121)	// Horizontal Back Porch(2 clock)
#define LCD_CPL				(720 *2)	    // active clocks per line

#define LCD_VSW				(3)	    // Vertical Sync Width(10 line)
#define LCD_LPS				(240)	// active lines per screen
#define LCD_VBP				(16)	// Vertical Back Porch(4 line)
#define LCD_VFP				(3)	    // Vertical Front Porch(4 line)

#define LCD_IVS				(1)	    
#define LCD_IHS				(1)	    
#define LCD_IEO				(0)	    
#define LCD_BCD				(1)	    
#define LCD_BPP				(2)	    
#define LCD_BGR				(0)	    
#define LCD_IPS				(1)
#else
#define MODE				4
#define FRAME_WIDTH			720
#define FRAME_HEIGHT		288

#define LCD_HFP				(23)	        // Horizontal Front Porch(2 clock)
#define LCD_HSW				(132)	        // Horizontal Sync Width(41 clock)
#define LCD_HBP				((132*2)-131)	// Horizontal Back Porch(2 clock)
#define LCD_CPL				(720 *2)	    // active clocks per line

#define LCD_VSW				(2)	    // Vertical Sync Width(10 line)
#define LCD_LPS				(288)	// active lines per screen
#define LCD_VBP				(20)	// Vertical Back Porch(4 line)
#define LCD_VFP				(2)	    // Vertical Front Porch(4 line)

#define LCD_IVS				(1)	    
#define LCD_IHS				(1)	    
#define LCD_IEO				(0)	    
#define LCD_BCD				(1)	    
#define LCD_BPP				(2)	    
#define LCD_BGR				(0)	    
#define LCD_IPS				(1)
#endif

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
static void DMColorBar(void);
static void VideoEncoderEnable(void);
static void DMVideoEncImage(void);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
//#include "audio_skin_play.h"
//#include "video_skin_pause.h"

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

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
	smtVENCSetCtrlNInternal(&vCtrl,&vInternal);

	
	//set Video Encoder Status Register
	vStatus.vEnable		= 0x1; // enable video encoder
	vStatus.outEnable	= 0x0;
	vStatus.fieldCount	= 0x0;
	vStatus.Hcount		= 0x0;
	vStatus.Vcount		= 0x0;
	smtVENCSetStatus(&vStatus);
}

/*-----------------------------------------------------------------------
    Function name   : DMColorBar()
    Prototype       : void DMColorBar(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
static void DMColorBar(void)
{
	smtInt32 i, j;
	smtUint32 *frame = (smtUint32 *)FRAME_BASEADDR;

	DMPlanePalette palette;

	DMCtrl dmCtrl;
	DMLcdCtrl dmLcdCtrl;
	DMHSync0Ctrl dmHSync0;
	DMHSync1Ctrl dmHSync1;
	DMVSync0Ctrl dmVSync0;
	DMVSync1Ctrl dmVSync1;

	DMPlaneCtrl gPlaneCfg;
	DMPlaneBlnd gPlaneBlnd;
	DMPlaneBlndMode gPlaneBlndMode;


	// Colorbar generation
#ifdef COLORBAR
#ifdef USE_PALETTE
	palette.palAddr = 0x0;
	palette.palData = BLACK & 0x00ffffff;
	smtDMSetGPalette(&palette);

	palette.palAddr = 0x1;
	palette.palData = BLUE & 0x00ffffff;
	smtDMSetGPalette(&palette);

	palette.palAddr = 0x2;
	palette.palData = GREEN & 0x00ffffff;
	smtDMSetGPalette(&palette);

	palette.palAddr = 0x3;
	palette.palData = CYAN & 0x00ffffff;
	smtDMSetGPalette(&palette);

	palette.palAddr = 0x4;
	palette.palData = RED & 0x00ffffff;
	smtDMSetGPalette(&palette);

	palette.palAddr = 0x5;
	palette.palData = MAGENTA & 0x00ffffff;
	smtDMSetGPalette(&palette);

	palette.palAddr = 0x6;
	palette.palData = YELLOW & 0x00ffffff;
	smtDMSetGPalette(&palette);

	palette.palAddr = 0x7;
	palette.palData = WHITE & 0x00ffffff;
	smtDMSetGPalette(&palette);


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
#else

	for(i = 0; i < FRAME_HEIGHT; i++)
	{
		SMT_WRITE(GPIO0_OUT, i);

		for(j = 0; j < FRAME_WIDTH/8; j++)
			*(frame+i*FRAME_WIDTH+j) = BLACK;
		for(; j < 2*FRAME_WIDTH/8; j++)
			*(frame+i*FRAME_WIDTH+j) = BLUE;
		for(; j < 3*FRAME_WIDTH/8; j++)
			*(frame+i*FRAME_WIDTH+j) = GREEN;
		for(; j < 4*FRAME_WIDTH/8; j++)
			*(frame+i*FRAME_WIDTH+j) = CYAN;
		for(; j < 5*FRAME_WIDTH/8; j++)
			*(frame+i*FRAME_WIDTH+j) = RED;
		for(; j < 6*FRAME_WIDTH/8; j++)
			*(frame+i*FRAME_WIDTH+j) = MAGENTA;
		for(; j < 7*FRAME_WIDTH/8; j++)
			*(frame+i*FRAME_WIDTH+j) = YELLOW;
		for(; j < FRAME_WIDTH; j++)
			*(frame+i*FRAME_WIDTH+j) = WHITE;
	}
#endif
#else

	for(i = 0; i < FRAME_HEIGHT; i++)
	{
		for(j = 0; j < FRAME_WIDTH/16; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;
		for(; j < 2*FRAME_WIDTH/16; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;//BLUE565;
		for(; j < 3*FRAME_WIDTH/16; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;
		for(; j < 4*FRAME_WIDTH/16; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;
		for(; j < 5*FRAME_WIDTH/16; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;
		for(; j < 6*FRAME_WIDTH/16; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;
		for(; j < 7*FRAME_WIDTH/16; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;
		for(; j < FRAME_WIDTH; j++)
			*(frame+(i*(FRAME_WIDTH/2))+j) = GREEN565;
	}

#endif

	//1. set DM control
	dmCtrl.prioritySel 	= 0x0;
	dmCtrl.swReset		= 0x0;
	dmCtrl.errIntEn 	= 0x0;
	dmCtrl.startIntEn	= 0x1;
	dmCtrl.endIntEn		= 0x0;
	smtDMSetMasterCtrl(&dmCtrl);

	//2. set Back ground Colour
	smtDMSetBGCol(0xFF0000);

	//3. set LCD IF(LCDCON, HSYNC0, HSYNC1, VSYNC0, VSYNC1)
	dmHSync0.tHFrontPorch		= LCD_HFP;
	dmHSync0.tHBackPorch		= LCD_HBP;
	smtDMSetHSync0(&dmHSync0);
		
	dmHSync1.tHDspPixPerLine	= LCD_CPL;
	dmHSync1.tHPulsWidth		= LCD_HSW;
	smtDMSetHSync1(&dmHSync1);
	
	dmVSync0.tVFrontPorch		= LCD_VFP;
	dmVSync0.tVBackPorch		= LCD_VBP;
	smtDMSetVSync0(&dmVSync0);
	
	dmVSync1.tVDspPeriod	= LCD_LPS;
	dmVSync1.tVPulsWidth	= LCD_VSW;
	smtDMSetVSync1(&dmVSync1);

	dmLcdCtrl.invertHSync	= LCD_IHS;
	dmLcdCtrl.invertVSync	= LCD_IVS;
	dmLcdCtrl.invertPixClk	= LCD_IPS;
	dmLcdCtrl.invertWrEn	= LCD_IEO;
	dmLcdCtrl.lcdBpp		= LCD_BPP;//shkim-20070201: check bit order
	dmLcdCtrl.rbSwap		= LCD_BGR;//shkim-20070201: check bit order
	dmLcdCtrl.pDiv			= 0x0;
	dmLcdCtrl.lcdPwrEn		= 0x1;
	dmLcdCtrl.lcdEn			= 0; // video sync enable
	smtDMSetLCDCtrl(&dmLcdCtrl);;


	//1. set chromakey/alpha value(BLEND)
	//	- BLEND register
	gPlaneBlnd.alpha	= 0xFF;
	gPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetGBlnd(&gPlaneBlnd);
	
	//2. set planexref/base address
	//	- BASE(stride) / ADDR register(framebuffer)
	smtDMSetGBase(0x0);
	smtDMSetGAddr((smtUint32)frame);
	



	
#ifdef USE_PALETTE
	//3. set blenmode
	//	- BLENDMODE
	//	- alpha , chromakey en/disable
	//	- plane x,y position
	gPlaneBlndMode.xPos = 0;
	gPlaneBlndMode.yPos = 0;
	gPlaneBlndMode.colKeyEn = 0x0;
	gPlaneBlndMode.blendMod = 0x0; //0:no alpha , 2: global alpha, 3: pixel alpha
	smtDMSetGBlndMode(&gPlaneBlndMode);
	
	//4. set plane control register
	//	- plane enable
	//	- plane pixel format
	//	- plane surface width , height
	gPlaneCfg.xEn 		= 0x1;
	gPlaneCfg.pixFmt 		= 0x0;//0:8BPP,2:RGB565,3:ARGB1555, 4:RGB888, 5:ARGB8888
	gPlaneCfg.gammaEn	= 0x0;
	gPlaneCfg.sWidth 	= FRAME_WIDTH;
	gPlaneCfg.sHeight	= FRAME_HEIGHT;

	smtDMSetGCtrl(&gPlaneCfg);
#else
	//3. set blenmode
	//	- BLENDMODE
	//	- alpha , chromakey en/disable
	//	- plane x,y position
	gPlaneBlndMode.xPos = 0;
	gPlaneBlndMode.yPos = 0;
	gPlaneBlndMode.colKeyEn = 0x0;
	gPlaneBlndMode.blendMod = 0x2; //0:no alpha , 2: global alpha, 3: pixel alpha
	smtDMSetGBlndMode(&gPlaneBlndMode);
	
	//4. set plane control register
	//	- plane enable
	//	- plane pixel format
	//	- plane surface width , height
	gPlaneCfg.xEn 		= 0x1;
	gPlaneCfg.pixFmt 		= 0x2;//0:8BPP,2:RGB565,3:ARGB1555, 4:RGB888, 5:ARGB8888
	gPlaneCfg.gammaEn	= 0x0;
	gPlaneCfg.sWidth 	= FRAME_WIDTH;
	gPlaneCfg.sHeight	= FRAME_HEIGHT;

	smtDMSetGCtrl(&gPlaneCfg);
#endif
}

/*-----------------------------------------------------------------------
    Function name   : DMVideoEncImage()
    Prototype       : void DMVideoEncImage(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
static void DMVideoEncImage(void)
{
	DMCtrl dmCtrl;
	DMLcdCtrl dmLcdCtrl;
	DMHSync0Ctrl dmHSync0;
	DMHSync1Ctrl dmHSync1;
	DMVSync0Ctrl dmVSync0;
	DMVSync1Ctrl dmVSync1;

	DMPlaneCtrl gPlaneCfg;
	DMPlaneBlnd gPlaneBlnd;
	DMPlaneBlndMode gPlaneBlndMode;

#ifdef IMAGE_TEST
	smtInt32 i;
	smtInt32 count, bcount, bcount1;
	smtInt16 *frame0 = (smtInt16 *)FRAME_BASEADDR;
	smtInt16 *frame1 = (smtInt16 *)(FRAME_BASEADDR+(FRAME_HEIGHT*FRAME_WIDTH*2));

	for(i = 0; i < FRAME_HEIGHT*FRAME_WIDTH; i++)
		*(frame0+i) = g_odd[i];

	for(i = 0; i < FRAME_HEIGHT*FRAME_WIDTH; i++)
		*(frame1+i) = g_even[i];


	//1. set DM control
	dmCtrl.prioritySel 	= 0x0;
	dmCtrl.swReset	= 0x0;
	dmCtrl.errIntEn 	= 0x0;
	dmCtrl.startIntEn	= 0x1;
	dmCtrl.endIntEn		= 0x0;
	smtDMSetMasterCtrl(&dmCtrl);

	//2. set Back ground Colour
	smtDMSetBGCol(0xFF0000);

	//3. set LCD IF(LCDCON, HSYNC0, HSYNC1, VSYNC0, VSYNC1)
	dmHSync0.tHFrontPorch		= LCD_HFP;
	dmHSync0.tHBackPorch		= LCD_HBP;
	smtDMSetHSync0(&dmHSync0);
		
	dmHSync1.tHDspPixPerLine	= LCD_CPL;
	dmHSync1.tHPulsWidth		= LCD_HSW;
	smtDMSetHSync1(&dmHSync1);
	
	dmVSync0.tVFrontPorch		= LCD_VFP;
	dmVSync0.tVBackPorch		= LCD_VBP;
	smtDMSetVSync0(&dmVSync0);
	
	dmVSync1.tVDspPeriod		= LCD_LPS;
	dmVSync1.tVPulsWidth		= LCD_VSW;
	smtDMSetVSync1(&dmVSync1);

	dmLcdCtrl.invertHSync		= LCD_IHS;
	dmLcdCtrl.invertVSync		= LCD_IVS;
	dmLcdCtrl.invertPixClk		= LCD_IPS;
	dmLcdCtrl.invertWrEn		= LCD_IEO;
	dmLcdCtrl.lcdBpp			= LCD_BPP;
	dmLcdCtrl.rbSwap			= LCD_BGR;
	dmLcdCtrl.pDiv			= 0x0;
	dmLcdCtrl.lcdPwrEn		= 0x1;
	dmLcdCtrl.lcdEn			= 0; // video sync enable
	smtDMSetLCDCtrl(&dmLcdCtrl);


	//1. set chromakey/alpha value(BLEND)
	//	- BLEND register
	gPlaneBlnd.alpha	= 0xFF;
	gPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetGBlnd(&gPlaneBlnd);
	
	//2. set planexref/base address
	//	- BASE(stride) / ADDR register(framebuffer)
	smtDMSetGBase(0x0);
	smtDMSetGAddr((smtUint32)frame0);
	
	//3. set blenmode
	//	- BLENDMODE
	//	- alpha , chromakey en/disable
	//	- plane x,y position
	gPlaneBlndMode.xPos = 0;
	gPlaneBlndMode.yPos = 0;
	gPlaneBlndMode.colKeyEn = 0x0;
	gPlaneBlndMode.blendMod = 0x0; //0:no alpha , 2: global alpha, 3: pixel alpha
	smtDMSetGBlndMode(&gPlaneBlndMode);
	
	//4. set plane control register
	//	- plane enable
	//	- plane pixel format
	//	- plane surface width , height
	gPlaneCfg.xEn 		= 0x1;
	gPlaneCfg.pixFmt 	= 0x2;//0:8BPP,2:RGB565,3:ARGB1555, 4:RGB888, 5:ARGB8888
	gPlaneCfg.gammaEn	= 0x0;
	gPlaneCfg.sWidth 	= FRAME_WIDTH;
	gPlaneCfg.sHeight	= FRAME_HEIGHT;

	smtDMSetGCtrl(&gPlaneCfg);


	SMT_WRITE(GPIO0_OUT, 0x2441);

	while(1)
	{
		smtUint8 uart_input;
		count = (SMT_READ(VIDEOENC_STATUS)); 
		count = (count>>19) & 0x3ff; //Horizontal counter read

		//Field Address switch
		SMT_WRITE(GPIO0_OUT, count);

		if(count == 10 && bcount == 9)
		{
		    bcount = count;
		    //SMT_WRITE(GADDR, ((smtUint32)(FRAME_BASEADDR+(FRAME_HEIGHT*FRAME_WIDTH*2))));	// frame address
		    smtDMSetGAddr( (smtUint32)(FRAME_BASEADDR+(FRAME_HEIGHT*FRAME_WIDTH*2))) ;
		}
		else
		{
		    bcount = count;
		}

		//Field Address switch
		if(count == 300 && bcount1 == 299)
		{
		    bcount1 = count;
		    //SMT_WRITE(GADDR, ((smtUint32)FRAME_BASEADDR));	// frame address
		    smtDMSetGAddr( ((smtUint32)FRAME_BASEADDR) );
		}
		else
		{
		    bcount1 = count;
		}

		smt2UARTDataValid(CFG_UART_CH, &uart_input);
		if(uart_input)
		{
			smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);
			if(uart_input == '0')
				break;
		}
	}

#endif
}

/*-----------------------------------------------------------------------
    Function name   : MEMCPY()
    Prototype       : void MEMCPY(smtInt16 *in, smtInt16 *out, smtInt32 X, smtInt32 Y)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
static void MEMCPY(smtInt16 *in, smtInt16 *out, smtInt32 X, smtInt32 Y)
{
	smtInt32 i, j, k, p;

	k = 0;
	p = 0;

	for(i = 0; i < FRAME_HEIGHT; i++)
	{
		for(j = 0; j < FRAME_WIDTH; j++)
		{
			if((j >= X && j < (X+560)) && (i >= Y && i < (Y+155)))
			{
				*(out+p) = in[k++];
				p++;
			}
			else
			{
				*(out+p) = 65535;
				p++;
			}
		}
	}
}

#define VIEWTAP  3
#define MEMBLANK (FRAME_HEIGHT*FRAME_WIDTH*2)


/*-----------------------------------------------------------------------
    Function name   : DMDisable()
    Prototype       : void DMDisable(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
static void DMDisable(void)
{
	DMPlaneCtrl dmPlaneCtrl;

	dmPlaneCtrl.xEn = 0x0;

	smtDMSetCCtrl(&dmPlaneCtrl);
	smtDMSetGCtrl(&dmPlaneCtrl);
	smtDMSetVCtrl(&dmPlaneCtrl);
}

/*-----------------------------------------------------------------------
    Function name   : VideoEncoderDisable()
    Prototype       : void VideoEncoderDisable(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
static void VideoEncoderDisable(void)
{
	//SMT_WRITE(VIDEOENC_STATUS	, 0x00000000);
	VEncStatus vStatus;

	memset(&vStatus,0x0,sizeof(vStatus));
	smtVENCSetStatus(&vStatus);	
}

/*-----------------------------------------------------------------------
    Function name   : VideoTest()
    Prototype       : void VideoTest(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void VideoTest(void)
{
	VideoEncoderEnable();
	//DMColorBar();
	DMVideoEncImage();
	DMDisable();
	VideoEncoderDisable();
}

/*-----------------------------------------------------------------------
    Function name   : DMVPlane()
    Prototype       : void DMVPlane(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
static void DMVPlane(void)
{
	DMCtrl dmCtrl;
	DMLcdCtrl dmLcdCtrl;
	DMHSync0Ctrl dmHSync0;
	DMHSync1Ctrl dmHSync1;
	DMVSync0Ctrl dmVSync0;
	DMVSync1Ctrl dmVSync1;

	DMPlaneCtrl vPlaneCfg;
	DMPlaneBlnd vPlaneBlnd;
	DMPlaneBlndMode vPlaneBlndMode;
	smtUint8 uart_input = 0;


	//1. set DM control
	dmCtrl.prioritySel 	= 0x0;
	dmCtrl.swReset	= 0x0;
	dmCtrl.errIntEn 	= 0x0;
	dmCtrl.startIntEn	= 0x1;
	dmCtrl.endIntEn		= 0x0;
	smtDMSetMasterCtrl(&dmCtrl);

	//2. set Back ground Colour
	smtDMSetBGCol(0xFF0000);

	//3. set LCD IF(LCDCON, HSYNC0, HSYNC1, VSYNC0, VSYNC1)
	dmHSync0.tHFrontPorch		= LCD_HFP;
	dmHSync0.tHBackPorch		= LCD_HBP;
	smtDMSetHSync0(&dmHSync0);
		
	dmHSync1.tHDspPixPerLine	= LCD_CPL;
	dmHSync1.tHPulsWidth		= LCD_HSW;
	smtDMSetHSync1(&dmHSync1);
	
	dmVSync0.tVFrontPorch		= LCD_VFP;
	dmVSync0.tVBackPorch		= LCD_VBP;
	smtDMSetVSync0(&dmVSync0);
	
	dmVSync1.tVDspPeriod	= LCD_LPS;
	dmVSync1.tVPulsWidth	= LCD_VSW;
	smtDMSetVSync1(&dmVSync1);

	dmLcdCtrl.invertHSync	= LCD_IHS;
	dmLcdCtrl.invertVSync	= LCD_IVS;
	dmLcdCtrl.invertPixClk	= LCD_IPS;
	dmLcdCtrl.invertWrEn	= LCD_IEO;
	dmLcdCtrl.lcdBpp		= LCD_BPP;//shkim-20070201: check bit order
	dmLcdCtrl.rbSwap		= LCD_BGR;//shkim-20070201: check bit order
	dmLcdCtrl.pDiv		= 0x0;
	dmLcdCtrl.lcdPwrEn	= 0x1;
	dmLcdCtrl.lcdEn		= 0; // video sync enable
	smtDMSetLCDCtrl(&dmLcdCtrl);


	
	//1. set chromakey/alpha value(BLEND)
	//	- BLEND register
	vPlaneBlnd.alpha	= 0xFF;
	vPlaneBlnd.colKey	= 0xFFFFFF;
	smtDMSetVBlnd(&vPlaneBlnd);
	
	//2. set planexref/base address
	//	- BASE(stride) / ADDR register(framebuffer)
	smtDMSetVBase(0x0);
	smtDMSetVAddr((smtUint32)FRAME_BASEADDR);
	//smtDMSetVAddr2(0x00000000);
	
	//3. set blenmode
	//	- BLENDMODE
	//	- alpha , chromakey en/disable
	//	- plane x,y position
	vPlaneBlndMode.xPos = 0;
	vPlaneBlndMode.yPos = 0;
	vPlaneBlndMode.colKeyEn = 0x0;
	vPlaneBlndMode.blendMod = 0x0; //0:no alpha , 2: global alpha, 3: pixel alpha
	smtDMSetVBlndMode(&vPlaneBlndMode);
	
	//4. set plane control register
	//	- plane enable
	//	- plane pixel format
	//	- plane surface width , height
	vPlaneCfg.xEn 		= 0x1;
	vPlaneCfg.pixFmt 	= 0x2;//
	vPlaneCfg.vPlaneIFEn = 0x0;// interlaced video source
	vPlaneCfg.vPlaneN2PUpEn = 0x0;
	vPlaneCfg.sWidth 	= FRAME_WIDTH;
	vPlaneCfg.sHeight	= FRAME_HEIGHT;
	smtDMSetVCtrl(&vPlaneCfg);
}

/*-----------------------------------------------------------------------
    Function name   : VIFEnable()
    Prototype       : void VIFEnable(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
static void VIFEnable(void)
{
	VifCtrl vif;
	VifProperty vifProp;

	//ADV7181BInitCompositeAltera();
	ADV7181BInitComposite();

	vifProp.vifDmaAddr= FRAME_BASEADDR;
	vifProp.vifXPos	= 0;
	vifProp.vifYPos	= 0;
	vifProp.vifXSize	= 720;
	vifProp.vifYSize	= 240;

	vif.hBlank	= 0;
	vif.vBlank	= 0;
	vif.field		= 0;
	vif.ycOrder	= 2;		// y/cb/y/cr order
	vif.startIntEn	= 1;		// Frame start interrupt enable
	vif.endIntEn	= 0;		// Frame end interrupt enable
	vif.dmaEn	= 1;		// DMA enable
	vif.swReset = 0;
	
	smtVIFSetProperty(&vifProp);
	smtVIFSetMode(&vif);
}

/*-----------------------------------------------------------------------
    Function name   : ISRVIF()
    Prototype       : void ISRVIF(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void ISRVIF(smtUint32 irq)
{
	smtUint8 vifStatus;

	DisableIRQ(irq);

	smtVIFGetIntStatus(&vifStatus);
	if ((vifStatus & 0x1) == 0x1)
		smt2UARTPrint(CFG_UART_CH, "VIF ISR : end frame\n");
	else
		smt2UARTPrint(CFG_UART_CH, "VIF ISR : start frame\n");
}

/*-----------------------------------------------------------------------
    Function name   : VIFInterruptTest()
    Prototype       : void VIFInterruptTest(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
static void VIFInterruptTest(void)
{
	smtUint8 uart_input;
	RequestIRQ(IRQ_VIF, ISRVIF);
	VIFEnable();

	smt2UARTPrint(CFG_UART_CH, "Press key to end VIF intr test\n");
	smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);

	ReleaseIRQ(19);
}

/*-----------------------------------------------------------------------
    Function name   : VideoInputTest()
    Prototype       : void VideoInputTest(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void VideoInputTest(void)
{
	//ADV7181BInitCompositeAltera();
	//while(1)
	//{
		//int count = 100000;
		//ADV7181BStatusPrint();
		//while(count--);
	//}
	
	VideoEncoderEnable();
	VIFEnable();

	// VIF interrupt test
	//VIFInterruptTest();
	
	//DMVideoEncImage();
	DMVPlane();
	while(1) ;
}
