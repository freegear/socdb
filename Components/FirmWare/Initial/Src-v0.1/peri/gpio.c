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

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
//#include "irq.h"
#include "gpio.h"

/*----------------------------------------------------------
Test Condition
	GPIO0 Ports are connected to GPIO1 externally.
	GPIO2 Ports are connected to GPIO3 externally.
	
	This test condition given by external testbench file.
	If you use appropriate testbench, Don't call this Test routine
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define GPIO_ALL_OUTPUT_MODE	0xFFFFFFFF
#define GPIO_ALL_INPUT_MODE	0x00000000

#define DATA_TOGGLE			0xFFFFFFFF


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
static smtUint32 GPIOInOutTest(smtUint8 ch, smtUint32 gpioData);


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

	// TEST1 : Register R/W
	(smtBoolean)errCode = RegisterGPIO();
	if (errCode != SMT_SUCCESS)
		return SMT_ERROR;

	// TEST2 : In/Out
	#if 0	// Can test when GPIO is connected external device.
	errCode = GPIOInOutTest(0x0, 0xAAAAAAAA);	// GPIO 0
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;

	errCode = GPIOInOutTest(0x1, 0xAAAAAAAA);	// GPIO 1
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;
	#endif

	// TEST3 : Interrupt
	// Edit your code

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: GPIOInOutTest()
	Prototype		: static smtUint32 GPIOInOutTest(void)
	Return			: Return to error code
	Argument		:
	Comments		:
		GPIO input/output mode test
-----------------------------------------------------------*/
static smtUint32 GPIOInOutTest(smtUint8 ch, smtUint32 gpioData)
{
	GPIO_STRUCT gpio;
	smtUint32 data, rdData;
	smtUint8 repeat;

	data = gpioData;
	gpio.gpioNum = ch;

	for (repeat = 0; repeat<2; repeat++)
	{
		gpio.gpioMode = GPIO_ALL_OUTPUT_MODE;	// GPIO output mode
		if (smt2GPIOWriteData(gpio, data) != SMT_SUCCESS)
			return SMT_ERROR;

		gpio.gpioMode = GPIO_ALL_INPUT_MODE;		// GPIO input mode
		if (smt2GPIOReadData(gpio, rdData) != SMT_SUCCESS)
			return SMT_ERROR;

		if (data != rdData)
			return SMT_ERROR;

		data ^= DATA_TOGGLE;					// data toggle
	}

	return SMT_SUCCESS;
}

