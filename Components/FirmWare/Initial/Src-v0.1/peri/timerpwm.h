/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: timerpwm.h
	Description	: Timer & PWM header file of SDI v5
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef	__TIMERPWM_H__
#define	__TIMERPWM_H__

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void TimerIntervalTest(smtUint8 prescale, smtUint16 data);

void TimerIntervalTest(smtUint8 prescale, smtUint16 data);
void TimerOverFlowTest(smtUint8 prescale, smtUint16 data);

#endif /* __TIMERPWM_H__ */
