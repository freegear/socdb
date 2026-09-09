/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: wdt.h
	Description	: WDT header file of SDI v5
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef	__WDT_H__
#define	__WDT_H__

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

void WDTpreScaleTest(smtUint16 min, smtUint16 max);
void WDTReloadTest(smtUint16 min, smtUint16 max);
void WDTDivideTest(void);

#endif /* __WDT_H__ */
