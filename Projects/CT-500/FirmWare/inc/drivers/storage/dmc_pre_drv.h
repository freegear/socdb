/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: dmc_pre_drv.h
	Description		: 
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __DMC_PRE_DRV_H__
#define	__DMC_PRE_DRV_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "sysinc.h"

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        TYPEDEF
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	AUDIO_VOLUME
-----------------------------------------------------------*/

typedef struct 
{
	smtUint32	tRC;
	smtUint32	tRAS;
	smtUint32	tCL;
	smtUint32	tRCD;
	smtUint32	tRP;
} DmcTiming;

typedef struct 
{
	smtUint32	rdDataLatchPolrity;
	smtUint32	colAddrSiz;
	smtUint32	AddrSwapEn;
	smtUint32	SDREn;
} DmcCtrl;

typedef struct 
{
	smtUint32	SelfRefEn;
	smtUint32	PwDnEn;
	smtUint32	RefDnRef;
} DmcPwr;

typedef struct 
{
	smtUint32	RefNo;
	smtUint32	RefCount;
} DmcRefresh;

#endif
#ifndef __DRAM_CTRL_PRE_DRV_H__
#define	__DRAM_CTRL_PRE_DRV_H__

/*----------------------------------------------------------
	dynamic memory control
	
	# top control
		- smtDMCGetControl/smtDMCSetControl
	
	# timing
		- smtDMCGetTimingControl/smtDMCSetTimingControl
	
	# power
		- smtDMCGetPowerControl/smtDMCSetPowerControl
		
	# refresh
		- smtDMCGetRefreshControl/smtDMCSetRefreshControl
	
-----------------------------------------------------------*/
void smtDMCGetTimingControl(DmcTiming *ptiming);
void smtDMCSetTimingControl(DmcTiming *ptiming);

void smtDMCGetControl(DmcCtrl *pcontrol);
void smtDMCSetControl(DmcCtrl *pcontrol);

void smtDMCGetPowerControl(DmcPwr *ppower);
void smtDMCSetPowerControl(DmcPwr *ppower);

void smtDMCGetRefreshControl(DmcRefresh *prefresh);
void smtDMCSetRefreshControl(DmcRefresh *prefresh);


#endif
