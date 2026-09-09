/*----------------------------------------------------------
	File Name   : main.c 
	Description : Application Entry Point File
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"
#include "lib.h"
#include "irq.c"
#include "gpio_irq.c"

#include "gpio.h"
#include "uart.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
extern void Enable_IRQ(void);
extern void Disable_IRQ(void);
void InterruptTest(void);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

static void TimerIRQ(unsigned irq)
{
	DPRINTF("Timer(%d) IRQ(%d)\n", irq-IRQ_TIMER0, irq);
}

static void GPIOLevelIRQ(unsigned  GPIOPin)
{
	DPRINTF("GPIO(%d) Level detected\n", GPIOPin);
}

static void GPIOEdgeIRQ(unsigned  GPIOPin)
{
	DPRINTF("GPIO(%d) Edge detected\n", GPIOPin);
}

static void GPIOBEdgeIRQ(unsigned  GPIOPin)
{
	unsigned data = SMT_READ(GPIO0_IN);

	if(data & (1UL<<GPIOPin))
		DPRINTF("GPIO(%d) Rising edge detected\n", GPIOPin);
	else
		DPRINTF("GPIO(%d) Falling edge detected\n", GPIOPin);
}

void InterruptTest(void)
{
	int i;
	int count;

	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	Enable_IRQ();
	SMT_WRITE(TIMER0_DAT, 0x3000);
	SMT_WRITE(TIMER1_DAT, 0x6000);
	SMT_WRITE(TIMER2_DAT, 0xc000);
	SMT_WRITE(TIMER3_DAT, 0xc000);
	SMT_WRITE(TIMER0_PRE, 0x03ff);
	SMT_WRITE(TIMER1_PRE, 0x03ff);
	SMT_WRITE(TIMER2_PRE, 0x03ff);
	SMT_WRITE(TIMER3_PRE, 0x03ff);
	SMT_WRITE(TIMER0_CON, 0x0001);
	SMT_WRITE(TIMER1_CON, 0x0001);
	SMT_WRITE(TIMER2_CON, 0x0001);
	SMT_WRITE(TIMER3_CON, 0x0001);

	RequestIRQ(IRQ_TIMER0, TimerIRQ);
	RequestIRQ(IRQ_TIMER1, TimerIRQ);
	RequestIRQ(IRQ_TIMER2, TimerIRQ);
	RequestIRQ(IRQ_TIMER3, TimerIRQ);

	GpioIntEnable();
	// GPIO[24] Level,Acitve high, 
	RequestGpioIRQ(24, 1, 1, 0, GPIOLevelIRQ);
	// GPIO[25] Edge,Acitve high,
	RequestGpioIRQ(25, 0, 1, 0, GPIOEdgeIRQ);
	// GPIO[26] Edge,Acitve low,
	RequestGpioIRQ(26, 0, 0, 0, GPIOEdgeIRQ);
	// GPIO[27] Both Edge
	RequestGpioIRQ(27, 0, 0, 1, GPIOBEdgeIRQ);

	i = 0;
	while(1)
	{
		char uart_input;
		count = 100000;
		GPIOWrite(i);
		i++;
		if(UartDataAvailable())
		{
			uart_input = UartGetch();
			if(uart_input == '0')
				break;
		}
		i &= 0xfffff;
		while(count--);
	}

	Disable_IRQ();
	DisableVIC();
}
