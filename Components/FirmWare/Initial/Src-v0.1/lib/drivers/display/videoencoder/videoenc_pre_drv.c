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

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "global.h"
#include "commonmacro.h"
#include "videoenc_post_drv.h"
#include "videoenc_pre_drv.h"

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////*/

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
		SMT_WRITE(VIDEOENC_CONTROL, 
			  ((vCtrl->DAC	   & 0x01)	<< 0)
			| ((vCtrl->DAC	   & 0x01)	<< 1)
			| ((vCtrl->DAC	   & 0x01)	<< 2)
			| ((vCtrl->SqPixel & 0x01)	<< 25)
			| ((vCtrl->sanning & 0x01)	<< 26)
			| ((vCtrl->encMode & 0x04)	<< 29)
		);
	}

	if(vInternal != 0x0)
	{
		SMT_WRITE(VIDEOENC_INTERNAL, 
			  ((vInternal->lFilter& 0x02)	<< 4)
			| ((vInternal->CFilter& 0x02)	<< 6)
			| ((vInternal->color	   & 0x01)	<< 11)
			| ((vInternal->resetSCH    & 0x01)	<< 12)
			| ((vInternal->pattern     & 0x02)	<< 14)
			| ((vInternal->patternMode & 0x01)	<< 15)
			| ((vInternal->cDelay	  & 0x02)	<< 18)
			| ((vInternal->lDelay	  & 0x02)	<< 21)
			| ((vInternal->burstWidth & 0x02)	<< 24)
			| ((vInternal->hSyncWidth & 0x02)	<< 26)
		);
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
