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
#include "irq.h"
//#include "irq.c"
//#include "gpio_irq.c"

#include "gpio.h"
#include "uart.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
//extern void Enable_IRQ(void);
//extern void Disable_IRQ(void);
void InterruptTest(void);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : TimerIRQ
    Prototype       : void TimerIRQ(smtUint32 irq)
    Return          : void
	Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
static void TimerIRQ(smtUint32 irq)
{
	smt2UARTPrint(CFG_UART_CH, "Timer(%d) IRQ(%d)\n", irq-IRQ_TIMER0, irq);
}

/*-----------------------------------------------------------------------
    Function name   : GPIOLevelIRQ
    Prototype       : void GPIOLevelIRQ(smtUint32  GPIOPin)
    Return          : void
	Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
static void GPIOLevelIRQ(smtUint32  GPIOPin)
{
	smt2UARTPrint(CFG_UART_CH, "GPIO(%d) Level detected\n", GPIOPin);
}

/*-----------------------------------------------------------------------
    Function name   : GPIOEdgeIRQ
    Prototype       : void GPIOEdgeIRQ(smtUint32  GPIOPin)
    Return          : void
	Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
static void GPIOEdgeIRQ(smtUint32  GPIOPin)
{
	smt2UARTPrint(CFG_UART_CH, "GPIO(%d) Edge detected\n", GPIOPin);
}

/*-----------------------------------------------------------------------
    Function name   : GPIOBEdgeIRQ
    Prototype       : void GPIOBEdgeIRQ(smtUint32  GPIOPin)
    Return          : void
	Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
static void GPIOBEdgeIRQ(smtUint32  GPIOPin)
{
	smtUint32 data = SMT_READ(GPIO0_IN);

	if(data & (1UL<<GPIOPin))
		smt2UARTPrint(CFG_UART_CH, "GPIO(%d) Rising edge detected\n", GPIOPin);
	else
		smt2UARTPrint(CFG_UART_CH, "GPIO(%d) Falling edge detected\n", GPIOPin);
}

/*-----------------------------------------------------------------------
    Function name   : InterruptTest
    Prototype       : void InterruptTest(void)
    Return          : void
	Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
void InterruptTest(void)
{
	smtInt32 i;
	smtInt32 count;
	GpioProperty gpio;

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

#if 0
	GpioIntEnable();

	// GPIO[24] Level,Acitve high,
	RequestGpioIRQ(24, 1, 1, 0, GPIOLevelIRQ);
	// GPIO[25] Edge,Acitve high,
	RequestGpioIRQ(25, 0, 1, 0, GPIOEdgeIRQ);
	// GPIO[26] Edge,Acitve low,
	RequestGpioIRQ(26, 0, 0, 0, GPIOEdgeIRQ);
	// GPIO[27] Both Edge
	RequestGpioIRQ(27, 0, 0, 1, GPIOBEdgeIRQ);
#else
	GpioInitInterrupt(gpio);

	//gpio.gpioChannel = GPIO0_TYPE;
	//gpio.gpioMode	 = GPIO_MODE_IN;
	gpio.intStatus	 = ~0;

	gpio.intLevel 	 = 1;
	gpio.intPolarity = 1;
	gpio.intBothEdge = 0; 	
	gpio.gpioNum	 = 24;
	smtGPIOSetIntProperty(GPIO0_TYPE, &gpio);
	RequestGpioIRQ(24, GPIOLevelIRQ);

	// GPIO[25] Edge,Acitve high,
	gpio.intLevel 	 = 0;
	gpio.intPolarity = 1;
	gpio.intBothEdge = 0; 	
	gpio.gpioNum	 = 25;
	smtGPIOSetIntProperty(GPIO0_TYPE, &gpio);
	RequestGpioIRQ(25, GPIOEdgeIRQ);
	

	// GPIO[26] Edge,Acitve low,
	gpio.intLevel 	 = 0;
	gpio.intPolarity = 0;
	gpio.intBothEdge = 0; 	
	gpio.gpioNum	 = 26;
	smtGPIOSetIntProperty(GPIO0_TYPE, &gpio);
	RequestGpioIRQ(26, GPIOEdgeIRQ);

	// GPIO[27] Both Edge
	gpio.intLevel 	 = 0;
	gpio.intPolarity = 0;
	gpio.intBothEdge = 1; 	
	gpio.gpioNum	 = 27;
	smtGPIOSetIntProperty(GPIO0_TYPE, &gpio);
	RequestGpioIRQ(27, GPIOBEdgeIRQ);
#endif

	i = 0;

	while(1)
	{
		smtUint8 uart_input;

		count = 100000;

		//GPIOWrite(i);
		SMT_WRITE(GPIO0_OUT, i);

		i++;
		smt2UARTDataValid(CFG_UART_CH, &uart_input);
		if(uart_input)
		{
			smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);
			if(uart_input == '0')
				break;
		}

		i &= 0xfffff;
		while(count--);
	}

	Disable_IRQ();
	DisableVIC();
}
