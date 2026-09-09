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
} DMC_TIMING;

typedef struct 
{
	smtUint32	port16BitSel;
	smtUint32	colAddrSiz;
	smtUint32	AddrSwapEn;
	smtUint32	SDREn;
} DMC_CTRL;

typedef struct 
{
	smtUint32	SelfRefEn;
	smtUint32	PwDnEn;
	smtUint32	RefDnRef;
} DMC_POWER;

typedef struct 
{
	smtUint32	RefNo;
	smtUint32	RefCount;
} DMC_REFRESH;

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
void smtDMCGetTimingControl(DMC_TIMING *ptiming);
void smtDMCSetTimingControl(DMC_TIMING *ptiming);

void smtDMCGetControl(DMC_CTRL *pcontrol);
void smtDMCSetControl(DMC_CTRL *pcontrol);

void smtDMCGetPowerControl(DMC_POWER *ppower);
void smtDMCSetPowerControl(DMC_POWER *ppower);

void smtDMCGetRefreshControl(DMC_REFRESH *prefresh);
void smtDMCSetRefreshControl(DMC_REFRESH *prefresh);


#endif
