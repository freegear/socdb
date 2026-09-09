/*----------------------------------------------------------
    File Name   : timerpwm.h
    Description : Timer & PWM header file of SDI v5
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

void TimerPwmGpioSet(void);
void TimerSetTestInterval(void);
void TimerSetTestCapture(void);
void TimerSetTestMatchOver(void);

void PwmSet0(void);
void PwmSet1(void);
void PwmSet2(void);
void PwmSet3(void);

void TimerISRMatch0(smtUint32 IRQ);
void TimerISRMatch1(smtUint32 IRQ);
void TimerISRMatch2(smtUint32 IRQ);
void TimerISRMatch3(smtUint32 IRQ);
void TimerISRMatch4(smtUint32 IRQ);
void TimerISRMatch5(smtUint32 IRQ);
void TimerISRMatch6(smtUint32 IRQ);
void TimerISRMatch7(smtUint32 IRQ);

void TimerISROver0(smtUint32 IRQ);
void TimerISROver1(smtUint32 IRQ);
void TimerISROver2(smtUint32 IRQ);
void TimerISROver3(smtUint32 IRQ);
void TimerISROver4(smtUint32 IRQ);
void TimerISROver5(smtUint32 IRQ);
void TimerISROver6(smtUint32 IRQ);
void TimerISROver7(smtUint32 IRQ);

void TimerISRMatchTCAP0(smtUint32 IRQ);
void TimerISRMatchTCAP1(smtUint32 IRQ);
void TimerISRMatchTCAP2(smtUint32 IRQ);
void TimerISRMatchTCAP3(smtUint32 IRQ);
void TimerISRMatchTCAP4(smtUint32 IRQ);
void TimerISRMatchTCAP5(smtUint32 IRQ);
void TimerISRMatchTCAP6(smtUint32 IRQ);
void TimerISRMatchTCAP7(smtUint32 IRQ);

void TimerISRMatchVIC0(smtUint32 IRQ);
void TimerISRMatchVIC1(smtUint32 IRQ);
void TimerISRMatchVIC2(smtUint32 IRQ);
void TimerISRMatchVIC3(smtUint32 IRQ);

smtUint32 ReadTDAT(smtUint32 IRQ);

#endif /* __TIMERPWM_H__ */




