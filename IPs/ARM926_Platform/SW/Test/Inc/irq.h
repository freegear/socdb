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

#define VIC_POLARITY	0x00000000	// all active high
#define VIC_LEVEL		(0x00000000|INT_UARTRX_MASK|INT_UARTTX_MASK)	// only UART is level triggered
#define VIC_INTMOD		0x00000000	// all int's routed to nIRQ

typedef void (*ISRType)(smtUint32 IRQ);

#define NO_ERROR            0
#define VIC_ERROR               1
#define TIMER_PWM_ERROR 2
#define WDT_ERROR           3
#define UART_ERROR          4
#define I2C_ERROR           5
#define GPIO_ERROR          6
#define ADC_ERROR           7
#define SMC_ERROR           8
#define FMC_ERROR           9
#define ESRAM_ERROR     10
#define REGISTER_ERROR  11

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

void EnableVIC(smtUint32 Polarity, smtUint32 Level, smtUint32 IntMod);
void DisableVIC(void);
void EnableIRQ(smtUint32 IRQ);
void DisableIRQ(smtUint32 IRQ);
void RequestIRQ(smtUint32 IRQ, ISRType ISR);
void ReleaseIRQ(smtUint32 IRQ);

void EnableINT(void);
void DisableINT(void);
void AckIRQ(smtUint32 IRQ);

#endif  /* __IRQ_H__ */
