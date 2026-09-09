/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: lib.h
	Description	: Basic peripheral header file
----------------------------------------------------------*/
#ifndef __IRQ_H__
#define __IRQ_H__

/*
/////////////////////////////////////////////////////////
	INCLUDE
///////////////////////////////////////////////////////// 
*/
#include "sysinc.h"
#include "structdef.h"
#include "commonmacro.h"

/*
/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// 
*/

#define VIC_POLARITY	0x0/*(INT_MASK(IRQ_UART0) \
						|INT_MASK(IRQ_UART1) \
						|INT_MASK(IRQ_UART2) \
						|INT_MASK(IRQ_UART3))*/		// active high except UART
						
#define VIC_LEVEL (0xffffffff ^ (INT_MASK(IRQ_TIMER0)	\
								|INT_MASK(IRQ_TIMER1)	\
								|INT_MASK(IRQ_TIMER2)	\
								|INT_MASK(IRQ_TIMER3)	\
								|INT_MASK(IRQ_DM)	\
								|INT_MASK(IRQ_NAND)	\
								|INT_MASK(IRQ_VIF)))		// level except TIMER/DM/VIF

#define VIC_INTMOD		0x00000000	// all int's routed to nIRQ

typedef void (*ISRType)(smtUint32 IRQ);

/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

void EnableVIC(smtUint32 Polarity, smtUint32 Level, smtUint32 IntMod);
void DisableVIC(void);

void RequestIRQ(smtUint32 IRQ, ISRType ISR);
void ReleaseIRQ(smtUint32 IRQ);

void EnableIRQ(smtUint32 IRQ);
void DisableIRQ(smtUint32 IRQ);
void AckIRQ(smtUint32 IRQ);

void InterruptHandler(void);
void UndefHandler(int IRQ);

void RequestGpioIRQ(smtUint32 GPIOPin, ISRType ISR);
void EnableGpioIRQ(smtUint32 GPIOPin);
void DisableGpioIRQ(smtUint32 GPIOPin);
void AckGpioIRQ(smtUint32 GPIOPin);
void UnknownGpioIRQ(smtUint32 GPIOPin);
void GpioIRQHandler(smtUint32 irq);
void GpioInitInterrupt(GPIO_STRUCT gpio);

void DmaIRQHandler(smtUint32 irq);

extern void Disable_IRQ(void);
extern void Enable_IRQ(void);
#endif /* __IRQ_H__ */

