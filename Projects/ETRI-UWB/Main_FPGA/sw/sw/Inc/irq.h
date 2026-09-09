/*----------------------------------------------------------
	File Name   : irq.h
	Description : IRQ header file
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __IRQ_H__
#define __IRQ_H__

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */

#include "sysinc.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

#define VIC_POLARITY	(INT_MASK(IRQ_UART0) \
			            |INT_MASK(IRQ_UART1) \
			            |INT_MASK(IRQ_UART2) \
			            |INT_MASK(IRQ_UART3))		// active high except UART
#define VIC_LEVEL (0xffffffff ^ (INT_MASK(IRQ_TIMER0)	\
                                |INT_MASK(IRQ_TIMER1)	\
                                |INT_MASK(IRQ_TIMER2)	\
                                |INT_MASK(IRQ_TIMER3)	\
                                |INT_MASK(IRQ_DM)	    \
                                |INT_MASK(IRQ_VIF)      \    
                                |INT_MASK(IRQ_NAND)))		// level except TIMER/DM/VIF

#define VIC_INTMOD		0x00000000	// all int's routed to nIRQ

typedef void (*ISRType)(smtUint32 IRQ);

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

void EnableVIC(smtUint32 Polarity, smtUint32 Level, smtUint32 IntMod);
void DisableVIC(void);
void RequestIRQ(smtUint32 IRQ, ISRType ISR);
void ReleaseIRQ(smtUint32 IRQ);

void EnableINT(void);
void DisableINT(void);

// GPIO IRQ related
void GpioIntEnable(void);
void GpioIntDisable(void);
void RequestGpioIRQ(smtUint32 GPIOPin, int Level, int Polarity, int Bedge, ISRType ISR);
void ReleaseGpioIRQ(smtUint32 GPIOPin);
#endif  /* __IRQ_H__ */
