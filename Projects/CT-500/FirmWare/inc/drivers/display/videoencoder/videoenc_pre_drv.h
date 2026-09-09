/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		  : video_pre_drv.h
	Description		: 
	Created by		: SHMT SOC Team
----------------------------------------------------------*/
#ifndef __VIDEOENC_PRE_DRV_H__
#define	__VIDEOENC_PRE_DRV_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        TYPEDEF
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	 VIDEOENC_STATUS
----------------------------------------------------------*/


/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

extern void smtVENCSetCtrlNInternal(VEncCtrl *vCtrl
							 ,VEncInternal *vInternal);
extern void smtVENCSetStatus(VIDEOENC_STATUS *vStatus);
extern void smtVENCGetStatus(VEncStatus *vStatus);
extern void smtVENCSetSubCarrier(smtUint16 subPhase, smtUint32 subReq);													
#endif
