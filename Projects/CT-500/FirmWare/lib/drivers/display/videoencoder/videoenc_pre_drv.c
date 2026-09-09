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
	Function name	: smtVENCSetCtrlNInternal()
	Prototype		: void smtVENCSetCtrlNInternal(VEncCtrl *vCtrl, VEncInternal *vInternal)
	Return			: none
	Argument		: VIDEOENC_CONTROL, VIDEO_INTERNAL
	Comments		: 
-----------------------------------------------------------*/
void smtVENCSetCtrlNInternal(VEncCtrl *vCtrl, VEncInternal *vInternal)
{
	if(vCtrl != 0x0)
	{
		SMT_WRITE(VIDEOENC_CONTROL,(\
			  ((vCtrl->DAC0	   		& 0x01)	<< 0)\
			| ((vCtrl->DAC1	   		& 0x01)	<< 1)\
			| ((vCtrl->DAC2	   		& 0x01)	<< 2)\
			| ((vCtrl->inv_hsync	& 0x01)	<< 3)\
			| ((vCtrl->inv_blank	& 0x01)	<< 4)\
			| ((vCtrl->inv_field	& 0x01)	<< 5)\
			| ((vCtrl->inv_cbcr		& 0x01)	<< 6)\
			| ((vCtrl->SqPixel 		& 0x01)	<< 25)\
			| ((vCtrl->sanning 		& 0x01)	<< 26)\
			| ((vCtrl->encMode 		& 0x07)	<< 29))
		);
	}

	if(vInternal != 0x0)
	{
		SMT_WRITE(VIDEOENC_INTERNAL,(\
			  ((vInternal->CFilter& 0x03)<<4) |((vInternal->lFilter &0x03)<<6)\
			| ((vInternal->color  & 0x01)<<11)|((vInternal->resetSCH&0x01)<< 12)\
			| ((vInternal->patternMode& 0x07)<<13)|((vInternal->pattern & 0x01)<<16)\
			| ((vInternal->cDelay	  & 0x07)	<< 18)\
			| ((vInternal->lDelay	  & 0x07)	<< 21)\
			| ((vInternal->burstWidth & 0x03)	<< 24)\
			| ((vInternal->hSyncWidth & 0x07)	<< 26))
		);
	}
}

/*----------------------------------------------------------
	Function name	: smtVENCGetCtrlNInternal()
	Prototype		: void smtVENCGetCtrlNInternal(VEncCtrl *vCtrl, VEncInternal *vInternal)
	Return			: none
	Argument		: VIDEOENC_CONTROL, VIDEO_INTERNAL
	Comments		: 
-----------------------------------------------------------*/
void smtVENCGetCtrlNInternal(VEncCtrl *vCtrl, VEncInternal *vInternal)
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
		vInternal->patternMode	= ((regData >> 13) & 0x07);
		vInternal->pattern		= ((regData >> 16) & 0x01);
		vInternal->cDelay		= ((regData >> 18) & 0x07);
		vInternal->lDelay		= ((regData >> 21) & 0x07);
		vInternal->burstWidth	= ((regData >> 24) & 0x03);
		vInternal->hSyncWidth	= ((regData >> 26) & 0x07);
	}
}

/*----------------------------------------------------------
	Function name	: smtVENCSetStatus()
	Prototype		: void smtVENCSetStatus(VEncStatus *vStatus)
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtVENCSetStatus(VEncStatus *vStatus)
{
	SMT_WRITE(VIDEOENC_STATUS,
		  ((vStatus->vEnable	& 0x1 ) <<31)
		| ((vStatus->outEnable	& 0x1 ) <<30)
	);
}

/*----------------------------------------------------------
	Function name	: smtVENCGetStatus()
	Prototype		: void smtVENCGetStatus(VEncStatus *vStatus)
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtVENCGetStatus(VEncStatus *vStatus)
{
	smtUint32 reg;
	
	if(vStatus != 0x0)
	{
		reg = SMT_READ(VIDEOENC_STATUS);
		
		vStatus->fieldCount = ((reg >>  0) & 0x0FF);
		vStatus->Hcount		= ((reg >>  8) & 0x7FF);
		vStatus->Vcount		= ((reg >> 19) & 0x3FF);
		vStatus->outEnable	= ((reg >> 30) & 0x001);
		vStatus->vEnable	= ((reg >> 31) & 0x001);
	}	
}


/*----------------------------------------------------------
	Function name	: smtVENCSetSubCarrier()
	Prototype		: void smtVENCSetSubCarrier()
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtVENCSetSubCarrier(smtUint16 subPhase, smtUint32 subReq)
{
	SMT_WRITE(VIDEOENC_SUBPHASE, subPhase);
	SMT_WRITE(VIDEOENC_SUBCARRIER, subReq);
}
/*----------------------------------------------------------
	Function name	: smtVENCSetVideoImageCtrl()
	Prototype		: void smtVENCSetVideoImageCtrl(VEncImageCtrl *imageCtrl)
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtVENCSetVideoImageCtrl(VEncImageCtrl *imageCtrl)
{
	SMT_WRITE(VIDEOENC_IMAGE_CTRL, 
			  ((imageCtrl->brightnessLev	& 0x3F)	<< 24)\
			| ((imageCtrl->hueLev			& 0xFF)	<< 16)\
			| ((imageCtrl->saturationCLev	& 0xFF)	<<  8)\
			| ((imageCtrl->saturationYLev	& 0xFF)	<<  0)
			);
}

/*----------------------------------------------------------
	Function name	: smtVENCGetVideoImageCtrl()
	Prototype		: void smtVENCGetVideoImageCtrl(VEncImageCtrl *imageCtrl)
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtVENCGetVideoImageCtrl(VEncImageCtrl *imageCtrl)
{
	smtUint32 regData = SMT_READ(VIDEOENC_IMAGE_CTRL);
	
	imageCtrl->brightnessLev	= ((regData >> 24) & 0x3F);
	imageCtrl->hueLev			= ((regData >> 16) & 0xFF);
	imageCtrl->saturationCLev	= ((regData >>  8) & 0xFF);
	imageCtrl->saturationYLev	= ((regData >>  0) & 0xFF);
	
}

/*----------------------------------------------------------
	Function name	: smtVENCSetVideoOutLev0()
	Prototype		: void smtVENCSetVideoOutLev0(VEncOutputLev0 *outLev0)
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtVENCSetVideoOutLev0(VEncOutputLev0 *outLev0)
{
	SMT_WRITE(VIDEOENC_OUTLEV0, 
				  ((outLev0->blankLev	& 0x3FF)	<< 16)\
				| ((outLev0->blackLev	& 0x3FF)	<<  0)
				);
}

/*----------------------------------------------------------
	Function name	: smtVENCGetVideoOutLev0()
	Prototype		: void smtVENCGetVideoOutLev0(VEncOutputLev0 *outLev0)
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtVENCGetVideoOutLev0(VEncOutputLev0 *outLev0)
{
	smtUint32 regData = SMT_READ(VIDEOENC_OUTLEV0);
	outLev0->blankLev	= ((regData >> 16) & 0x3FF);
	outLev0->blackLev	= ((regData >>  0) & 0x3FF);
}

/*----------------------------------------------------------
	Function name	: smtVENCSetVideoOutLev1()
	Prototype		: void smtVENCSetVideoOutLev1(VEncOutputLev1 *outLev1)
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtVENCSetVideoOutLev1(VEncOutputLev1 *outLev1)
{
	SMT_WRITE(VIDEOENC_OUTLEV1, 
				  ((outLev1->burstStep	& 0x1F)	<< 16)\
				| ((outLev1->burstCal	& 0xFF)	<<  8)\
				| ((outLev1->HSyncStep	& 0xFF)	<<  0)
				);
}

/*----------------------------------------------------------
	Function name	: smtVENCGetVideoOutLev1()
	Prototype		: void smtVENCGetVideoOutLev1(VEncOutputLev1 *outLev1)
	Return			: none
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtVENCGetVideoOutLev1(VEncOutputLev1 *outLev1)
{
	smtUint32 regData = SMT_READ(VIDEOENC_OUTLEV1);
	
	outLev1->burstStep	= ((regData >> 16) & 0x1F);
	outLev1->burstCal	= ((regData >>  8) & 0xFF);
	outLev1->HSyncStep	= ((regData >>  0) & 0xFF);
}

