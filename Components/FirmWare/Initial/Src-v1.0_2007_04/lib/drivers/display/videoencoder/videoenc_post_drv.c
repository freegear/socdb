/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : lcdpostdrv.c
	Description : lcd post-layer driver
	Created by  : SHMT SOC Team
------------------------------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "commonmacro.h"
#include "videoenc_post_drv.h"

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

// Definition for Video Encoder
#define LUMA_FILTER_SEL     0 //  0:6Mhz 1:ntsc notch 2:pal notch 3:bypass 
#define CHRO_FILTER_SEL     2 //  0: 1.35 Mhz 2: 0.67Mhz
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
#endif
#ifdef __DM_PAL_TEST__
#define MODE         4
#endif
#ifdef __DM_LCD_TEST__
#define MODE 0
#endif

smtBoolean smt2VEncInit(smtUint32 fb_addr, smtUint32 h, smtUint32 w);
smtBoolean smt2VencSetControl(VEncCfg *vEncCfg);

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/


/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
#if 0
static smtUint32 video_fb_addr;
static smtUint32 video_fb_h;
static smtUint32 video_fb_w;
#endif


/*
////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*------------------------------------------------------------------------------
	Function name	: smt2VEncEnable
	Prototype		: smtUint32 smt2VEncEnable(void)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
void smt2VEncEnable(void)
{
	VEncCtrl vCtrl;
	VEncInternal vInternal;
	VEncStatus vStatus;
	VEncImageCtrl imageCtrl;

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
	vInternal.pattern		= EN_INTERNAL_PATTERN;
	vInternal.patternMode	= COLOR_PATTERN_MODE;
	vInternal.resetSCH		= EN_REST_SCH;
	vInternal.color			= EN_COLOR_KILL;
	vInternal.CFilter		= CHRO_FILTER_SEL;
	vInternal.lFilter		= LUMA_FILTER_SEL;
	smtVENCSetCtrlNInternal(&vCtrl,&vInternal);

	smtVENCGetVideoImageCtrl(&imageCtrl);
	imageCtrl.saturationCLev = 144;
	imageCtrl.saturationYLev = 144;
	smtVENCSetVideoImageCtrl(&imageCtrl);
	
	//set Video Encoder Status Register
	vStatus.vEnable		= 0x1; // enable video encoder
	vStatus.outEnable	= 0x0;
	vStatus.fieldCount	= 0x0;
	vStatus.Hcount		= 0x0;
	vStatus.Vcount		= 0x0;
	smtVENCSetStatus(&vStatus);
}


/*----------------------------------------------------------
	Function name	: smt2VEncDisable()
	Prototype		: void smt2VEncDisable(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
void smt2VEncDisable(void)
{
	VEncStatus vStatus;

	memset(&vStatus,0x0,sizeof(vStatus));
	smtVENCSetStatus(&vStatus);
}

#if 0
/*-----------------------------------------------------------------------
    Function name   : 
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean smt2VencSetControl(VEncCfg *vEncCfg)
{
	smtSetVideoEncode(&vEncCfg->rCtrl, &vEncCfg->rInternal);

	return SMT_TRUE;
}


/*-----------------------------------------------------------------------
    Function name   : 
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean smt2VEncInit(smtUint32 fb_addr, smtUint32 h, smtUint32 w)
{
	VEncCtrl rCtrl;
	VEncInternal rInternal;

	rCtrl.set				= VENC_VALUE_SET;
	rCtrl.DAC0				= VENC_DAC0;
	rCtrl.DAC1				= VENC_DAC0;
	rCtrl.DAC2				= VENC_DAC0;
	rCtrl.SqPixel			= VENC_NORMAL_PIXEL;
	rCtrl.sanning			= VENC_NONINTERLACED;
	rCtrl.encMode			= VENC_OMODE_NTSCM;

	rInternal.set			= VENC_VALUE_SET;
	rInternal.lFilter		= VENC_LFILTER_6MHZ;
	rInternal.CFilter		= VENC_CFILTER_1450KHZ;
	rInternal.color			= VENC_OUT_COLOR_DISABLE;
	rInternal.resetSCH 		= VENC_RESET_SCH_ENABLE;
	rInternal.pattern  		= VENC_INTERNAL_PATTERN_DISABLE;
	rInternal.patternMode 	= VENC_PATTERN_COLORBAR;
	rInternal.cDelay 		= VENC_CHRODELAY_NONE;
	rInternal.lDelay 		= VENC_LDELAY_NONE;
	rInternal.burstWidth 	= VENC_BURST_WIDTH_REDUCE;
	rInternal.hSyncWidth 	= VENC_HSYNC_WIDTH_R2TS;

	video_fb_addr	= fb_addr;
	video_fb_h		= h;
	video_fb_w		= w;

	smtSetVideoEncode(&rCtrl, &rInternal);
	
	return SMT_TRUE;
}

/*-----------------------------------------------------------------------
    Function name   : 
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtBoolean smt2VEncRun(void)
{
	smtUint32 count, bcount, bcount1;
	
	while(1)
    {
	    count = (SMT_READ(VIDEOENC_STATUS)); 
        count = (count>>19) & 0x3ff; //Horizontal counter read

        //Field Address switch
        if(count == 10 && bcount == 9) {
            bcount = count;
	        SMT_WRITE(GADDR, ((unsigned)(video_fb_addr+(video_fb_h*video_fb_w*2))));	// frame address
        } else {
            bcount = count;
        }

        //Field Address switch
        if(count == 300 && bcount1 == 299) {
            bcount1 = count;
	        SMT_WRITE(GADDR, ((unsigned)video_fb_addr));	// frame address
        } else {
            bcount1 = count;
        }
    }
	return SMT_TRUE;
}

#endif
