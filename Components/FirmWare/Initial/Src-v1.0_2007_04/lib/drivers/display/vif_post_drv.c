/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : vif_post_drv.h 
	Description : vif post driver
	Created by  : SHMT SOC Team
------------------------------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/
#include "vif_post_drv.h"
#include "string.h"
/*
/////////////////////////////////////////////////////////
	FUNCTION
///////////////////////////////////////////////////////// 
*/

/*------------------------------------------------------------------------------
	Function name	: DMVIFEnable
	Prototype		: smtUint32 DMVIFEnable(void)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
void smt2VIFEnable(void)
{
	VifCtrl vif;
	VifProperty vifProp;

	//ADV7181BInitCompositeAltera();
	ADV7181BInitComposite();

	vifProp.vifDmaAddr	= VIDEO_BASEADDR;
	vifProp.vifXPos		= 0;
	vifProp.vifYPos		= 11;
	vifProp.vifXSize	= 720;
	vifProp.vifYSize	= 240;

	vif.i2pEn			= 1;
	vif.ycOrder			= 2;// y/cb/y/cr order
	vif.errorIntEn 		= 0;
	vif.startIntEn		= 0;// Frame start interrupt enable
	vif.endIntEn		= 1;// Frame end interrupt enable
	vif.dmaEn			= 1;// DMA enable
	vif.swReset 		= 0;
	
	smtVIFSetProperty(&vifProp);
	smtVIFSetMode(&vif);
}
/*----------------------------------------------------------
	Function name	: DMVIFDisable()
	Prototype		: void DMVIFDisable(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
void smt2VIFDisable(void)
{
	VifCtrl vif;
	memset(&vif,0x0,sizeof(vif));
	smtVIFSetMode(&vif);	
}

