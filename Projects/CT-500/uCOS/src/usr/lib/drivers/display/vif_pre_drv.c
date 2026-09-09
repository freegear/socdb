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
	Prototype		: void smtVIFSetMode(VIF_CTRL_STRUCT vif)
	Return		: void
	Argument	:
	Comments	: 
		Set VIF mode
-----------------------------------------------------------*/
void smtVIFSetMode(VIF_CTRL_STRUCT vif)
{
	smtUint32 writeData;

	if (vif.swReset == 0x1)		// When VIF swreset
	{
		smtUint32 readData;

		readData = SMT_READ(VIFCON);
		SMT_WRITE(VIFCON, readData | (0x1 << 7));	// VIF SW reset
	}
	else
	{
		writeData =
			( (vif.i2pEn		& 0x1) << 6)	|
			( (vif.ycOrder		& 0x3) << 4)	|
			( (vif.errorIntEn	& 0x1) << 3)	|
			( (vif.startIntEn	& 0x1) << 2)	|
			( (vif.endIntEn		& 0x1) << 1)	|
			( (vif.dmaEn		& 0x1) );

		SMT_WRITE(VIFCON, writeData);
	}
}

/*----------------------------------------------------------
	Function name	: smtVIFGetMode()
	Prototype		: void smtVIFGetMode(VIF_CTRL_STRUCT vif)
	Return		: void
	Argument	:
	Comments	: 
		Get VIF mode
-----------------------------------------------------------*/
void smtVIFGetMode(VIF_CTRL_STRUCT *vif)
{
	smtUint32 readData;

	readData = SMT_READ(VIFCON);

	vif->hBlank		= (readData >> 10) & 0x1;
	vif->vBlank		= (readData >> 9) & 0x1;
	vif->field		= (readData >> 8) & 0x1;
	vif->ycOrder	= (readData >> 4) & 0x3;
	vif->errorIntEn	= (readData >> 3) & 0x1;
	vif->startIntEn	= (readData >> 2) & 0x1;
	vif->endIntEn	= (readData >> 1) & 0x1;
	vif->dmaEn		= (readData >> 0) & 0x1;
}

/*----------------------------------------------------------
	Function name	: smtVIFGetIntStatus()
	Prototype		: smtUint8 smtVIFGetIntStatus(smtUint8 vifStatus)
	Return		: smtUint8
	Argument	:
	Comments	: 
		Get VIF interrupt status
-----------------------------------------------------------*/
smtUint8 smtVIFGetIntStatus(void)
{
	smtUint32 readData;

	readData = SMT_READ(VIFSTS);

	if ( (readData & VIF_ENDFRAME) == VIF_ENDFRAME)
		return VIF_ENDFRAME;
	else if ( (readData & VIF_START_FRAME) == VIF_START_FRAME)
		return VIF_START_FRAME;
	else
		return VIF_NO_INT;
}

/*----------------------------------------------------------
	Function name	: smtVIFSetProperty()
	Prototype		: void smtVIFSetProperty(VIF_PROP_STRUCT vifProp)
	Return		: void
	Argument	:
	Comments	: 
		Set VIF property
-----------------------------------------------------------*/
void smtVIFSetProperty(VIF_PROP_STRUCT vifProp)
{
	smtUint32 writeData;

	// X,Y position set
	writeData = 
		( (vifProp.vifXPos	& 0x7FF) << 11) |
		( (vifProp.vifYPos	& 0x7FF) );
	SMT_WRITE(VIFPOS, writeData);

	// X,Y size set
	writeData =
		( (vifProp.vifXSize & 0x7FF) << 11) |
		( (vifProp.vifYSize	 & 0x7FF) );
	SMT_WRITE(VIFSIZ, writeData);

	// DMA address set
	SMT_WRITE(VIFADDR, vifProp.vifDmaAddr);
}

/*----------------------------------------------------------
	Function name	: smtVIFGetProperty()
	Prototype		: void smtVIFGetProperty(VIF_PROP_STRUCT vifProp)
	Return		: void
	Argument	:
	Comments	: 
		Get VIF property
-----------------------------------------------------------*/
void smtVIFGetProperty(VIF_PROP_STRUCT *vifProp)
{
	smtUint32 readData;

	// X,Y position Get
	readData = SMT_READ(VIFPOS);

	vifProp->vifXPos	= (readData >> 11) & 0x7FF;
	vifProp->vifYPos	= (readData & 0x7FF);

	// X,Y size Get
	readData =  SMT_READ(VIFSIZ);

	vifProp->vifXSize	= (readData >> 11) & 0x7FF;
	vifProp->vifYSize	= (readData & 0x7FF);

	// DMA address Get
	vifProp->vifDmaAddr = SMT_READ(VIFADDR);
}

