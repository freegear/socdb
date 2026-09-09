/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: dmc_pre_drv.c.h
	Description		: 
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "dmc_pre_drv.h"

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////*/

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
/*----------------------------------------------------------
	Function name	: smtDMCGetTimingControl
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtDMCGetTimingControl(DMC_TIMING *ptiming)
{
	smtUint32	reg = SMT_READ(SDRTCON);
	
	ptiming->tRC	= ((reg >> 12) 	& 0xF);
	ptiming->tRAS	= ((reg >> 8) 	& 0xF);
	ptiming->tCL	= ((reg >> 4) 	& 0x7);
	ptiming->tRCD	= ((reg >> 2) 	& 0x3);
	ptiming->tRP	= ((reg >> 0) 	& 0x3);
	
	
}
/*----------------------------------------------------------
	Function name	: smtDMCSetTimingControl
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtDMCSetTimingControl(DMC_TIMING *ptiming)
{
	
	SMT_WRITE(
		SDRTCON,
		 ((ptiming->tRC		& 0xF) << 12)
		|((ptiming->tRAS	& 0xF) << 8)
		|((ptiming->tCL		& 0x7) << 4)
		|((ptiming->tRCD	& 0x3) << 2)
		|((ptiming->tRP		& 0x3) << 0)
	);
}
/*----------------------------------------------------------
	Function name	: smtDMCGetControl
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtDMCGetControl(DMC_CTRL *pcontrol)
{
	smtUint32	reg = SMT_READ(SDRCON);

	pcontrol->port16BitSel	= ((reg >> 7) & 0x1);
	pcontrol->colAddrSiz	= ((reg >> 4) & 0x3);
	pcontrol->AddrSwapEn	= ((reg >> 1) & 0x1);
	pcontrol->SDREn			= ((reg >> 0) & 0x1);
	
}
/*----------------------------------------------------------
	Function name	: smtDMCSetControl
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtDMCSetControl(DMC_CTRL *pcontrol)
{
	
	SMT_WRITE(
		SDRCON,
		 ((pcontrol->port16BitSel	& 0x1) << 7)
		|((pcontrol->colAddrSiz		& 0x3) << 4)
		|((pcontrol->AddrSwapEn		& 0x1) << 1)
		|((pcontrol->SDREn			& 0x1) << 0)
	);	
}
/*----------------------------------------------------------
	Function name	: smtDMCGetPowerControl
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtDMCGetPowerControl(DMC_POWER *ppower)
{
	smtUint32	reg = SMT_READ(SDRPCON);

	ppower->SelfRefEn	= ((reg >> 31) 	& 0x1);
	ppower->PwDnEn		= ((reg >> 16) 	& 0x1);
	ppower->RefDnRef	= ((reg >> 0) 	& 0xFFFF);
}
/*----------------------------------------------------------
	Function name	: smtDMCSetPowerControl
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtDMCSetPowerControl(DMC_POWER *ppower)
{
	
	SMT_WRITE(
		SDRCON,
		 ((ppower->SelfRefEn	& 0x1) 		<< 31)
		|((ppower->PwDnEn		& 0x1) 		<< 16)
		|((ppower->RefDnRef		& 0xFFFF)	<< 0)
	);		
}
/*----------------------------------------------------------
	Function name	: smtDMCGetRefreshControl
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtDMCGetRefreshControl(DMC_REFRESH *prefresh)
{
	smtUint32	reg = SMT_READ(SDRREF);
	
	prefresh->RefNo		= ((reg >> 16)	& 0xF);
	prefresh->RefCount	= ((reg >> 0) 	& 0xFFFF);
}
/*----------------------------------------------------------
	Function name	: smtDMCSetRefreshControl
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtDMCSetRefreshControl(DMC_REFRESH *prefresh)
{
	SMT_WRITE(
		SDRREF,
		 ((prefresh->RefNo		& 0xF) 		<< 16)
		|((prefresh->RefCount	& 0xFFFF) 	<< 0)
	);		
}
