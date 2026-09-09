/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		  : video_pre_drv.c
	Description		: 
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "global.h"
#include "commonmacro.h"
#include "videoenc_post_drv.h"
#include "videoenc_pre_drv.h"

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////
*/

/*----------------------------------------------------------
	Video Encoder
	

		
-----------------------------------------------------------*/

/*----------------------------------------------------------
	Function name	: smtSetVideoEncode()
	Prototype		: void smtSetVideoEncode()
	Return			: none
	Argument		: VIDEOENC_CONTROL, VIDEO_INTERNAL
	Comments		: 
-----------------------------------------------------------*/
void smtSetVideoEncode(VEncCtrl *vCtrl, VEncInternal *vInternal)
{
	if(vCtrl != 0x0)
	{
		SMT_WRITE(VIDEOENC_CONTROL,(\
			  ((vCtrl->DAC0	   & 0x01)	<< 0)\
			| ((vCtrl->DAC1	   & 0x01)	<< 1)\
			| ((vCtrl->DAC2	   & 0x01)	<< 2)\
			| ((vCtrl->inv_hsync	& 0x01)	<< 3)\
			| ((vCtrl->inv_blank	& 0x01)	<< 4)\
			| ((vCtrl->inv_field	& 0x01)	<< 5)\
			| ((vCtrl->inv_cbcr		& 0x01)	<< 6)\
			| ((vCtrl->en_dac34		& 0x01)	<< 7)\
			| ((vCtrl->bypidac		& 0x01)	<< 8)\
			| ((vCtrl->biasTest0	& 0x01)	<< 9)\
			| ((vCtrl->biasTest1	& 0x01)	<< 10)\
			| ((vCtrl->SqPixel & 0x01)	<< 25)\
			| ((vCtrl->sanning & 0x01)	<< 26)\
			| ((vCtrl->encMode & 0x07)	<< 29))
		);
	}

	if(vInternal != 0x0)
	{
		SMT_WRITE(VIDEOENC_INTERNAL,(\
			  ((vInternal->CFilter& 0x03)<<4) |((vInternal->lFilter &0x03)<<6)\
			| ((vInternal->color  & 0x01)<<11)|((vInternal->resetSCH&0x01)<< 12)\
			| ((vInternal->pattern& 0x07)<<13)|((vInternal->patternMode & 0x01)<<16)\
			| ((vInternal->cDelay	  & 0x07)	<< 18)\
			| ((vInternal->lDelay	  & 0x07)	<< 21)\
			| ((vInternal->burstWidth & 0x03)	<< 24)\
			| ((vInternal->hSyncWidth & 0x07)	<< 26))
		);
	}
}

/*----------------------------------------------------------
	Function name	: smtGetVideoEncode()
	Prototype		: void smtGetVideoEncode(VEncCtrl *vCtrl, VEncInternal *vInternal)
	Return			: none
	Argument		: VIDEOENC_CONTROL, VIDEO_INTERNAL
	Comments		: 
-----------------------------------------------------------*/
void smtGetVideoEncode(VEncCtrl *vCtrl, VEncInternal *vInternal)
{
	smtUint32 regData = 0;
	if(vCtrl != 0x0)
	{
		regData = SMT_READ(VIDEOENC_CONTROL);
	    vCtrl->DAC0			= ((regData >>  0) & 0x01);
		vCtrl->DAC1			= ((regData >>  1) & 0x01);
		vCtrl->DAC2			= ((regData >>  2) & 0x01);
		vCtrl->inv_hsync	= ((regData >>  3) & 0x01);
		vCtrl->inv_blank	= ((regData >>  4) & 0x01);
		vCtrl->inv_field	= ((regData >>  5) & 0x01);
		vCtrl->inv_cbcr		= ((regData >>  6) & 0x01);
		vCtrl->en_dac34		= ((regData >>  7) & 0x01);
		vCtrl->bypidac		= ((regData >>  8) & 0x01);
		vCtrl->biasTest0	= ((regData >>  9) & 0x01);
		vCtrl->biasTest1	= ((regData >> 10) & 0x01);
		vCtrl->SqPixel		= ((regData >> 25) & 0x01);
		vCtrl->sanning		= ((regData >> 26) & 0x01);
		vCtrl->encMode		= ((regData >> 29) & 0x07);
	}

	if(vInternal != 0x0)
	{
		regData = SMT_READ(VIDEOENC_INTERNAL);
		vInternal->CFilter		= ((regData >>  4) & 0x03);
		vInternal->lFilter		= ((regData >>  6) & 0x03);
		vInternal->color		= ((regData >> 11) & 0x01);
		vInternal->resetSCH		= ((regData >> 12) & 0x01);
		vInternal->pattern		= ((regData >> 13) & 0x07);
		vInternal->patternMode	= ((regData >> 16) & 0x01);
		vInternal->cDelay		= ((regData >> 18) & 0x07);
		vInternal->lDelay		= ((regData >> 21) & 0x07);
		vInternal->burstWidth	= ((regData >> 24) & 0x03);
		vInternal->hSyncWidth	= ((regData >> 26) & 0x07);
	}
}

/*----------------------------------------------------------
	Function name	: smtSetVideoEncode()
	Prototype		: void smtSetVideoEncode()
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtSetVideoStatus(VEncStatus *vStatus)
{
	SMT_WRITE(VIDEOENC_STATUS, vStatus->Enable<<31);
}


/*----------------------------------------------------------
	Function name	: smtSetVideoEncode()
	Prototype		: void smtSetVideoEncode()
	Return			: none
	Argument		: REG_VIDEO_CONTROL, REG_VIDEO_INTERNAL structure
	Comments		: 
-----------------------------------------------------------*/
void smtGetVideoStatus(VEncStatus *vStatus)
{
	smtUint32 reg;
	
	if(vStatus != 0x0)
	{
		reg = SMT_READ(VIDEOENC_STATUS);
		
		vStatus->fieldCount = ((reg >>  0) & 0x0FF);
		vStatus->Hcount		= ((reg >>  8) & 0x7FF);
		vStatus->Vcount		= ((reg >> 19) & 0x3FF);
		vStatus->Enable		= ((reg >> 31) & 0x001);
	}	
}


/*----------------------------------------------------------
	Function name	: smtSetVideoEncode()
	Prototype		: void smtSetVideoEncode()
	Return			: none
	Argument		: REG_VIDEO_CONTROL, REG_VIDEO_INTERNAL structure
	Comments		: 
-----------------------------------------------------------*/
void smtSetVideoSubCarrier(smtUint16 subPhase, smtUint32 subReq)
{
	SMT_WRITE(VIDEOENC_SUBPHASE, subPhase);
	SMT_WRITE(VIDEOENC_SUBCARRIER, subReq);
}
/*----------------------------------------------------------
	Function name	: smtSetVideoImageCtrl()
	Prototype		: void smtSetVideoImageCtrl(VEncImageCtrl *imageCtrl)
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtSetVideoImageCtrl(VEncImageCtrl *imageCtrl)
{
	SMT_WRITE(VIDEOENC_IMAGE_CTRL, 
			  ((imageCtrl->brightnessLev	& 0x3F)	<< 24)\
			| ((imageCtrl->hueLev			& 0xFF)	<< 16)\
			| ((imageCtrl->saturationCLev	& 0xFF)	<<  8)\
			| ((imageCtrl->saturationYLev	& 0xFF)	<<  0)
			);
}

/*----------------------------------------------------------
	Function name	: smtGetVideoImageCtrl()
	Prototype		: void smtGetVideoImageCtrl(VEncImageCtrl *imageCtrl)
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtGetVideoImageCtrl(VEncImageCtrl *imageCtrl)
{
	smtUint32 regData = SMT_READ(VIDEOENC_IMAGE_CTRL);
	
	imageCtrl->brightnessLev	= ((regData >> 24) & 0x3F);
	imageCtrl->hueLev			= ((regData >> 16) & 0xFF);
	imageCtrl->saturationCLev	= ((regData >>  8) & 0xFF);
	imageCtrl->saturationYLev	= ((regData >>  0) & 0xFF);
	
}

/*----------------------------------------------------------
	Function name	: smtSetVideoOutLev0()
	Prototype		: void smtSetVideoOutLev0(VEncOutputLev0 *outLev0)
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtSetVideoOutLev0(VEncOutputLev0 *outLev0)
{
	SMT_WRITE(VIDEOENC_OUTLEV0, 
				  ((outLev0->blankLev	& 0x3FF)	<< 16)\
				| ((outLev0->blackLev	& 0x3FF)	<<  0)
				);
}

/*----------------------------------------------------------
	Function name	: smtGetVideoOutLev0()
	Prototype		: void smtGetVideoOutLev0(VEncOutputLev0 *outLev0)
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtGetVideoOutLev0(VEncOutputLev0 *outLev0)
{
	smtUint32 regData = SMT_READ(VIDEOENC_OUTLEV0);
	outLev0->blankLev	= ((regData >> 16) & 0x3FF);
	outLev0->blackLev	= ((regData >>  0) & 0x3FF);
}

/*----------------------------------------------------------
	Function name	: smtSetVideoOutLev1()
	Prototype		: void smtSetVideoOutLev1(VEncOutputLev1 *outLev1)
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtSetVideoOutLev1(VEncOutputLev1 *outLev1)
{
	SMT_WRITE(VIDEOENC_OUTLEV1, 
				  ((outLev1->burstStep	& 0x1F)	<< 16)\
				| ((outLev1->burstCal	& 0xFF)	<<  8)\
				| ((outLev1->HSyncStep	& 0xFF)	<<  0)
				);
}

/*----------------------------------------------------------
	Function name	: smtGetVideoOutLev1()
	Prototype		: void smtGetVideoOutLev1(VEncOutputLev1 *outLev1)
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtGetVideoOutLev1(VEncOutputLev1 *outLev1)
{
	smtUint32 regData = SMT_READ(VIDEOENC_OUTLEV1);
	
	outLev1->burstStep	= ((regData >> 16) & 0x1F);
	outLev1->burstCal	= ((regData >>  8) & 0xFF);
	outLev1->HSyncStep	= ((regData >>  0) & 0xFF);
}

