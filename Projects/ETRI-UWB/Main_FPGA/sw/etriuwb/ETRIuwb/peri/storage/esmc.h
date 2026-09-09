/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: esmc.h
	Description	: External SMC Test SDI v5
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef	__ESMC_H__
#define	__ESMC_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "sysinc.h"

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

smtInt32 MemoryTest(smtUint32 *start_addr, smtUint32 *end_addr);
smtInt32 BANK2Test(void);
smtInt32 SRAMTest(void);

#endif /* __ESMC_H__ */
