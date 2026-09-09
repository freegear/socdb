/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : lcd_pre_drv.h 
	Description : lcd pre-layer header file
	Created by  : SHMT SOC Team
------------------------------------------------------------------------------*/
#ifndef __VIF_PRE_DRV_H__
#define __VIF_PRE_DRV_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "global.h"
#include "commonmacro.h"
#include "sysinc.h"

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

/*------------------------------------------------------------------------------
	VIF controller
------------------------------------------------------------------------------*/
/*----------------------------------------------------------
        Video Interface Controller
-----------------------------------------------------------*/
typedef enum
{
	VIF_NO_INT			= 0x0,
	VIF_ENDFRAME		= 0x1,
	VIF_START_FRAME	= 0x2
} VifIntStatus;

typedef struct
{
	smtUint8 hBlank;
	smtUint8 vBlank;
	smtUint8 field;
	smtUint8 swReset;
	smtUint8 i2pEn;
	smtUint8 ycOrder;
	smtUint8 errorIntEn;
	smtUint8 startIntEn;
	smtUint8 endIntEn;
	smtUint8 dmaEn;
} VifCtrl;

typedef struct
{
	smtUint32 vifDmaAddr;
	smtUint16 vifXPos;
	smtUint16 vifYPos;
	smtUint16 vifXSize;
	smtUint16 vifYSize;
} VifProperty;

/*------------------------------------------------------------------------------
		VIF CONTROLLER
------------------------------------------------------------------------------*/
void smtVIFSetMode(VifCtrl *pvif);
void smtVIFGetMode(VifCtrl *pvif);
void smtVIFGetIntStatus(smtUint8 *pstatus);
void smtVIFSetProperty(VifProperty *pvifProp);
void smtVIFGetProperty(VifProperty *pvifProp);

#endif//__VIF_PRE_DRV_H__
