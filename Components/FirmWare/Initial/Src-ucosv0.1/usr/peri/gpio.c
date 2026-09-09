/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: gpio.c 
	Description	: SMC test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq.h"
#include "gpio.h"
#include "registeraddr.h"

#include "uart_pre_drv.h"
#include "uart_post_drv.h"

/*----------------------------------------------------------
Test Condition
	GPIO0 Ports are connected to GPIO1 externally.
	GPIO2 Ports are connected to GPIO3 externally.
	
	This test condition given by external testbench file.
	If you use appropriate testbench, Don't call this Test routine
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/


/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
static void GPIOISR(smtUint32 irq);

static void GPIOISR(smtUint32  GPIOPin);
static void GPIOEdgeIRQ(smtUint32  GPIOPin);
static void GPIOBEdgeIRQ(smtUint32  GPIOPin);

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
static smtUint8 gpioCh = GPIO0_TYPE;
static smtUint8 gpioNum = 24;

static smtUint8 gpioFlag = 0;

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/


/*----------------------------------------------------------
	Function name	: GPIOTest()
	Prototype		: smtUint32 GPIOTest(void)
	Return			: Return to error code
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtUint32 GPIOTest(void)
{
	smtUint32 errCode = 0;

#if 0
	// TEST1 : Register R/W
	errCode = RegisterGPIO();
	if (errCode != SMT_SUCCESS)
		return SMT_ERROR;
#endif

	// TEST2 : In/Out
	errCode = GPIOInOut();

	return errCode;
}


static ISRType GpioISRTable[32] = { 0, };	// ISR Table
/*----------------------------------------------------------
	Function name	: GPIOInOut()
	Prototype		: smtUint32 GPIOInOut(void)
	Return		: 
	Argument	:
	Comments	:
-----------------------------------------------------------*/
smtUint32 GPIOInOut(void)
{
	smtUint8 channel;
	smtUint8 number;
	smtUint32 count;

	GPIO_STRUCT gpio;
	GPIO_STRUCT gpioCmp;

	// GPIO0 port initialize
	//GpioInitInterrupt(gpio);

	for(count = 0; count < 32; count++)
		GpioISRTable[count] = 0;

	smtGPIOIntClear(GPIO0_TYPE, 24);
	RequestIRQ(IRQ_GPIO0, (ISRType)GpioIRQHandler);

	channel	= GPIO0_TYPE;
	number	= 24;

#if 0		// Set/GetProperty function test
	gpio.intLevel = 1;
	gpio.intPolarity = 1;
	gpio.intBothEdge = 0;
	gpio.gpioNum = number;

	smtGPIOSetIntProperty(channel, gpio);

	gpioCmp.gpioNum = number;
	smtGPIOGetIntProperty(channel, &gpioCmp);

	if(gpio.intLevel != gpioCmp.intLevel)
		goto gpioError;
	if(gpio.intPolarity != gpioCmp.intPolarity)
		goto gpioError;
	if(gpio.intBothEdge != gpioCmp.intBothEdge)
		goto gpioError;
#endif

#if 0		// Level interrupt
	gpio.intLevel 	 = 1;
	gpio.intPolarity = 1;
	gpio.intBothEdge = 0; 	
#endif
#if 0		// Edge active high
	gpio.intLevel 	 = 0;
	gpio.intPolarity = 1;
	gpio.intBothEdge = 0;
#endif
#if 1		// Edge active low
	gpio.intLevel 	 = 0;
	gpio.intPolarity = 0;
	gpio.intBothEdge = 0;
#endif
#if 0		// Both edge
	gpio.intLevel 	 = 0;
	gpio.intPolarity = 0;
	gpio.intBothEdge = 1;
#endif

	smt2UartPrint(11, "Press the GPIO key.. Enter '0' to escape\n");

	gpio.gpioNum	 = 24;
	smtGPIOSetIntProperty(GPIO0_TYPE, gpio);
	RequestGpioIRQ(24, GPIOISR);

	while(1)
	{
		smtInt8 uart_input;

		count = 100000;
		if(smtUartDataAvailable())
		{
			uart_input = smt2UartGetCh(0);
			if(uart_input == '0')
				break;
		}

		while(count--);
	}

	ReleaseGpioIRQ(24);
	ReleaseIRQ(IRQ_GPIO0);

	return SMT_SUCCESS;

gpioError:
	smt2UartPrint(11, "GPIO error\n");
	return SMT_ERROR;
}


/*-----------------------------------------------------------------------
    Function name   : GPIOLevelIRQ
    Prototype       : void GPIOLevelIRQ(smtUint32  GPIOPin)
    Return          : void
	Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
static void GPIOISR(smtUint32  GPIOPin)
{
	smtUint32 data;
	GPIO_STRUCT gpio;

	gpio.gpioNum = GPIOPin;
	smtGPIOGetIntProperty(gpioCh,  &gpio);

	if((gpio.intBothEdge == 1) && (gpio.intLevel == 0))
	{
		smtGPIOGetData(gpioCh, GPIOPin, &data);
		//data = SMT_READ(GPIO0_IN);

		if(data & (1UL<<GPIOPin))
			smt2UartPrint(11, "GPIO(%d) Rising edge detected\n", GPIOPin);
		else
			smt2UartPrint(11, "GPIO(%d) Falling edge detected\n", GPIOPin);
	}
	else if((gpio.intLevel == 0) && (gpio.intBothEdge == 0) && (gpio.intPolarity == 1))
		smt2UartPrint(11, "GPIO(%d) Active high edge detected\n", GPIOPin);
	else if((gpio.intLevel == 0) && (gpio.intBothEdge == 0) && (gpio.intPolarity == 0))
		smt2UartPrint(11, "GPIO(%d) Active low edge detected\n", GPIOPin);
	else if((gpio.intLevel == 1) && (gpio.intBothEdge == 0) && (gpio.intPolarity == 1))
		smt2UartPrint(11, "GPIO(%d) Level detected\n", GPIOPin);
}

