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

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "commonmacro.h"
#include "videoenc_post_drv.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
smtBoolean smt2VEncInit(smtUint32 fb_addr, smtUint32 h, smtUint32 w);
smtBoolean smt2VencSetControl(VEncCfg *vEncCfg);


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
static smtUint32 video_fb_addr;
static smtUint32 video_fb_h;
static smtUint32 video_fb_w;


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */




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

	rCtrl.set		= VENC_VALUE_SET;
	rCtrl.DAC		= VENC_DAC0;
	rCtrl.SqPixel	= VENC_NORMAL_PIXEL;
	rCtrl.sanning	= VENC_NONINTERLACED;
	rCtrl.encMode	= VENC_OMODE_NTSCM;

	rInternal.set		= VENC_VALUE_SET;
	rInternal.lFilter	= VENC_LFILTER_6MHZ;
	rInternal.CFilter	= VENC_CFILTER_1450KHZ;
	rInternal.color	= VENC_OUT_COLOR_DISABLE;
	rInternal.resetSCH = VENC_RESET_SCH_ENABLE;
	rInternal.pattern  = VENC_INTERNAL_PATTERN_DISABLE;
	rInternal.patternMode = VENC_PATTERN_COLORBAR;
	rInternal.cDelay = VENC_CHRODELAY_NONE;
	rInternal.lDelay = VENC_LDELAY_NONE;
	rInternal.burstWidth = VENC_BURST_WIDTH_REDUCE;
	rInternal.hSyncWidth = VENC_HSYNC_WIDTH_R2TS;

	video_fb_addr	= fb_addr;
	video_fb_h		= h;
	video_fb_w		= w;

	smtSetVideoEncode(&rCtrl, &rInternal);
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


