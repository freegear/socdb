/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: smc_pre_drv.c.h
	Description		: 
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "smc_pre_drv.h"
#include "commonmacro.h"

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////
*/

/*----------------------------------------------------------
	Function name	: smtSMCGetControl
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtSMCGetControl(smtUint8 bank, SMC_CTRL *pcontrol)
{
	smtUint32 reg;
	switch(bank) 
	{
		case 0:
			reg = SMT_READ(ESMC_B0_CON);
			pcontrol->tas	= ((reg & 0x7) >> 17);
			pcontrol->tcss	= ((reg & 0x7) >> 14);
			pcontrol->tacc	= ((reg & 0x7) >> 10);
			pcontrol->tcsh	= ((reg & 0x7) >> 7);
			pcontrol->tah	= ((reg & 0x7) >> 4);
			pcontrol->width	= ((reg & 0x3) >> 2);
			pcontrol->shift	= ((reg & 0x3) >> 0);
			break;
			
		case 1:
			reg = SMT_READ(ESMC_B1_CON);
			pcontrol->tas	= ((reg & 0x7) >> 17);
			pcontrol->tcss	= ((reg & 0x7) >> 14);
			pcontrol->tacc	= ((reg & 0x7) >> 10);
			pcontrol->tcsh	= ((reg & 0x7) >> 7);
			pcontrol->tah	= ((reg & 0x7) >> 4);
			pcontrol->width	= ((reg & 0x3) >> 2);
			pcontrol->shift	= ((reg & 0x3) >> 0);			
			break;
			
		case 2:
			reg = SMT_READ(ESMC_B2_CON);
			pcontrol->tas	= ((reg & 0x7) >> 17);
			pcontrol->tcss	= ((reg & 0x7) >> 14);
			pcontrol->tacc	= ((reg & 0x7) >> 10);
			pcontrol->tcsh	= ((reg & 0x7) >> 7);
			pcontrol->tah	= ((reg & 0x7) >> 4);
			pcontrol->width	= ((reg & 0x3) >> 2);
			pcontrol->shift	= ((reg & 0x3) >> 0);					
			break;
			
		case 3:
			reg = SMT_READ(ESMC_B3_CON);
			pcontrol->tas	= ((reg & 0x7) >> 17);
			pcontrol->tcss	= ((reg & 0x7) >> 14);
			pcontrol->tacc	= ((reg & 0x7) >> 10);
			pcontrol->tcsh	= ((reg & 0x7) >> 7);
			pcontrol->tah	= ((reg & 0x7) >> 4);
			pcontrol->width	= ((reg & 0x3) >> 2);
			pcontrol->shift	= ((reg & 0x3) >> 0);			
			break;
	}

}
/*----------------------------------------------------------
	Function name	: smtSMCSetControl
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtSMCSetControl(smtUint8 bank, SMC_CTRL *pcontrol)
{

	switch(bank) 
	{
		case 0:
			SMT_WRITE(
				ESMC_B0_CON,
				 ((pcontrol->tas 	& 0x7) << 17)
				|((pcontrol->tcss 	& 0x7) << 14)
				|((pcontrol->tacc 	& 0x7) << 10)
				|((pcontrol->tcsh 	& 0x7) << 7)
				|((pcontrol->tah 	& 0x7) << 4)
				|((pcontrol->width 	& 0x3) << 2)
				|((pcontrol->shift 	& 0x3) << 0)
			);
			break;
			
		case 1:
			SMT_WRITE(
				ESMC_B1_CON,
				 ((pcontrol->tas 	& 0x7) << 17)
				|((pcontrol->tcss 	& 0x7) << 14)
				|((pcontrol->tacc 	& 0x7) << 10)
				|((pcontrol->tcsh 	& 0x7) << 7)
				|((pcontrol->tah 	& 0x7) << 4)
				|((pcontrol->width 	& 0x3) << 2)
				|((pcontrol->shift 	& 0x3) << 0)
			);
			break;
			
		case 2:
			SMT_WRITE(
				ESMC_B2_CON,
				 ((pcontrol->tas 	& 0x7) << 17)
				|((pcontrol->tcss 	& 0x7) << 14)
				|((pcontrol->tacc 	& 0x7) << 10)
				|((pcontrol->tcsh 	& 0x7) << 7)
				|((pcontrol->tah 	& 0x7) << 4)
				|((pcontrol->width 	& 0x3) << 2)
				|((pcontrol->shift 	& 0x3) << 0)
			);	
			break;
			
		case 3:
			SMT_WRITE(
				ESMC_B3_CON,
				 ((pcontrol->tas 	& 0x7) << 17)
				|((pcontrol->tcss 	& 0x7) << 14)
				|((pcontrol->tacc 	& 0x7) << 10)
				|((pcontrol->tcsh 	& 0x7) << 7)
				|((pcontrol->tah 	& 0x7) << 4)
				|((pcontrol->width 	& 0x3) << 2)
				|((pcontrol->shift 	& 0x3) << 0)
			);
			break;
	}	
}
