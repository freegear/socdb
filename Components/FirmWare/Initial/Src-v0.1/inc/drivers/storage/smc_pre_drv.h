/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: smc_pre-drv.h
	Description		: 
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __SMC_PRE_DRV_H__
#define	__SMC_PRE_DRV_H__
/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
/*/////////////////////////////////////////////////////////
        TYPEDEF
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	SMC_CTRL
-----------------------------------------------------------*/
typedef struct 
{
	smtUint32	tas;
	smtUint32	tcss;
	smtUint32	tacc;
	smtUint32	tcsh;
	smtUint32	tah;
	smtUint32	width;
	smtUint32	shift;
	
} SMC_CTRL;
/*----------------------------------------------------------
	static memory control for bank 0/1/2/3
		- smtSMCGetControl
		- smtSMCSetControl
-----------------------------------------------------------*/
void smtSMCGetControl(smtUint8 bank, SMC_CTRL *pcontrol);
void smtSMCSetControl(smtUint8 bank, SMC_CTRL *pcontrol);


#endif
