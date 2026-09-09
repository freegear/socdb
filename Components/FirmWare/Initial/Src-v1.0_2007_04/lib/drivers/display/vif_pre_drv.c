/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : lcdpredrv.c 
	Description : lcd pre-layer driver
	Created by  : SHMT SOC Team
------------------------------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/
#include "vif_pre_drv.h"

/*
/////////////////////////////////////////////////////////
	FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: smtVIFSetMode()
	Prototype		: void smtVIFSetMode(VifCtrl *pvif)
	Return		: void
	Argument	:
	Comments	: 
		Set VIF mode
-----------------------------------------------------------*/
void smtVIFSetMode(VifCtrl *pvif)
{
	smtUint32 writeData;

	if (pvif->swReset == 0x1)		// When VIF swreset
	{
		smtUint32 readData;

		readData = SMT_READ(VIFCON);
		SMT_WRITE(VIFCON, readData | (0x1 << 7));	// VIF SW reset
	}
	else
	{
		writeData =
			( (pvif->i2pEn		& 0x1) << 6)	|
			( (pvif->ycOrder		& 0x3) << 4)	|
			( (pvif->errorIntEn	& 0x1) << 3)	|
			( (pvif->startIntEn	& 0x1) << 2)	|
			( (pvif->endIntEn		& 0x1) << 1)	|
			( (pvif->dmaEn		& 0x1) );

		SMT_WRITE(VIFCON, writeData);
	}
}

/*----------------------------------------------------------
	Function name	: smtVIFGetMode()
	Prototype		: void smtVIFGetMode(VifCtrl pvif)
	Return		: void
	Argument	:
	Comments	: 
		Get VIF mode
-----------------------------------------------------------*/
void smtVIFGetMode(VifCtrl *pvif)
{
	smtUint32 readData;

	readData = SMT_READ(VIFCON);

	pvif->hBlank		= (readData >> 10) & 0x1;
	pvif->vBlank		= (readData >> 9) & 0x1;
	pvif->field		= (readData >> 8) & 0x1;
	pvif->ycOrder	= (readData >> 4) & 0x3;
	pvif->errorIntEn	= (readData >> 3) & 0x1;
	pvif->startIntEn	= (readData >> 2) & 0x1;
	pvif->endIntEn	= (readData >> 1) & 0x1;
	pvif->dmaEn		= (readData >> 0) & 0x1;
}

/*----------------------------------------------------------
	Function name	: smtVIFGetIntStatus()
	Prototype		: void smtVIFGetIntStatus(smtUint8 *pstatus)
	Return		: smtUint8
	Argument	:
	Comments	: 
		Get VIF interrupt status
-----------------------------------------------------------*/
void smtVIFGetIntStatus(smtUint8 *pstatus)
{
	smtUint32 readData;

	readData = SMT_READ(VIFSTS);

	if ( (readData & VIF_ENDFRAME) == VIF_ENDFRAME)
		*pstatus = VIF_ENDFRAME;
	else if ( (readData & VIF_START_FRAME) == VIF_START_FRAME)
		*pstatus = VIF_START_FRAME;
	else
		*pstatus = VIF_NO_INT;
}

/*----------------------------------------------------------
	Function name	: smtVIFSetProperty()
	Prototype		: void smtVIFSetProperty(VifProperty *pvifProp)
	Return		: void
	Argument	:
	Comments	: 
		Set VIF property
-----------------------------------------------------------*/
void smtVIFSetProperty(VifProperty *pvifProp)
{
	smtUint32 writeData;

	// X,Y position set
	writeData = 
		( (pvifProp->vifXPos	& 0x7FF) << 11) |
		( (pvifProp->vifYPos	& 0x7FF) );
	SMT_WRITE(VIFPOS, writeData);

	// X,Y size set
	writeData =
		( (pvifProp->vifXSize & 0x7FF) << 11) |
		( (pvifProp->vifYSize	 & 0x7FF) );
	SMT_WRITE(VIFSIZ, writeData);

	// DMA address set
	SMT_WRITE(VIFADDR, pvifProp->vifDmaAddr);
}

/*----------------------------------------------------------
	Function name	: smtVIFGetProperty()
	Prototype		: void smtVIFGetProperty(VifProperty pvifProp)
	Return		: void
	Argument	:
	Comments	: 
		Get VIF property
-----------------------------------------------------------*/
void smtVIFGetProperty(VifProperty *pvifProp)
{
	smtUint32 readData;

	// X,Y position Get
	readData = SMT_READ(VIFPOS);

	pvifProp->vifXPos	= (readData >> 11) & 0x7FF;
	pvifProp->vifYPos	= (readData & 0x7FF);

	// X,Y size Get
	readData =  SMT_READ(VIFSIZ);

	pvifProp->vifXSize	= (readData >> 11) & 0x7FF;
	pvifProp->vifYSize	= (readData & 0x7FF);

	// DMA address Get
	pvifProp->vifDmaAddr = SMT_READ(VIFADDR);
}

