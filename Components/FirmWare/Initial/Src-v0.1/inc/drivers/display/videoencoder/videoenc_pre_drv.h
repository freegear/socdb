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

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        TYPEDEF
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	 VIDEOENC_STATUS
----------------------------------------------------------*/


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
extern void smtSetVideoEncode(VIDEOENC_CONTROL *vCtrl
							 ,VENC_INTERNAL *vInternal);
extern void smtSetVideoStatus(VIDEOENC_STATUS *vStatus);
extern status smtGetVideoStatus(VENC_STATUS *vStatus);
extern void smtSetVideoSubCarrier(VENC_SUBPHASE *subPhase
								 ,VENC_SUBCARRIER *subReq);													
#endif
