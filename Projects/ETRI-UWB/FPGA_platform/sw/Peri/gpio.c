/*----------------------------------------------------------
	File Name   : gpio.c 
	Description : SMC test code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"
#include "lib.h"
#include "irq.h"
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
#define GPIO01_ERROR	1
#define GPIO23_ERROR	2

// GPIO control value
#define MAKE_GPIO_CON(x)	\
			(((x) << SHIFT_DN_FROM_MASK(GPIO_0))	\
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_1)) \
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_2)) \
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_3)) \
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_4)) \
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_5)) \
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_6)) \
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_7)))

#define MAKE_GPIO_CON2(x, y)	\
			(((x) << SHIFT_DN_FROM_MASK(GPIO_0))	\
			| ((y) << SHIFT_DN_FROM_MASK(GPIO_1)) \
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_2)) \
			| ((y) << SHIFT_DN_FROM_MASK(GPIO_3)) \
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_4)) \
			| ((y) << SHIFT_DN_FROM_MASK(GPIO_5)) \
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_6)) \
			| ((y) << SHIFT_DN_FROM_MASK(GPIO_7)))

#define GPIO0_EINT_INPUT_MODE	MAKE_GPIO_CON(0)
#define GPIO0_GPIO_INPUT_MODE	MAKE_GPIO_CON(1)
#define GPIO0_GPIO_OUTPUT_MODE	MAKE_GPIO_CON(2)
#define GPIO0_TOUT_OUTPUT_MODE	MAKE_GPIO_CON(3)
			
#define GPIO1_GPIO_INPUT_MODE	MAKE_GPIO_CON(0)
#define GPIO1_GPIO_OUTPUT_MODE	MAKE_GPIO_CON(1)
#define GPIO1_TCAP_INPUT_MODE	MAKE_GPIO_CON(2)
#define GPIO1_OTHER_OUTPUT_MODE	MAKE_GPIO_CON(3)

#define GPIO2_PWM_OUTPUT_MODE	MAKE_GPIO_CON(0)
#define GPIO2_TOUT_OUTPUT_MODE	MAKE_GPIO_CON(1)
#define GPIO2_GPIO_INPUT_MODE	MAKE_GPIO_CON(2)
#define GPIO2_GPIO_OUTPUT_MODE	MAKE_GPIO_CON(3)

#define GPIO3_GPIO_INPUT_MODE	MAKE_GPIO_CON(0)
#define GPIO3_GPIO_OUTPUT_MODE	MAKE_GPIO_CON(1)
#define GPIO3_TCLK_INPUT_MODE	MAKE_GPIO_CON(2)
#define GPIO3_OTHER_OUTPUT_MODE	MAKE_GPIO_CON(3)

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

static smtUint8 st_test_pattern[10] =
{ 0x00, 0x00, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
static smtUint32 GPIO01Test(void);
static smtUint32 GPIO23Test(void);

/*-----------------------------------------------------------------------
    Function name   : GPIOTest()
    Prototype       : smtUint32 GPIOTest(void)
    Return          : Return to error code
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
smtUint32 GPIOTest(void)
{
	smtUint32 errorCode = 0;	// Valid only last 4 bit
	
	errorCode = GPIO01Test();
	if(errorCode != NO_ERROR)
		return GPIO_ERROR;
	
	errorCode = GPIO23Test();
	if(errorCode != NO_ERROR)
	    return GPIO_ERROR;
	
	return NO_ERROR;
}

/*-----------------------------------------------------------------------
    Function name   : GPIO01Test()
    Prototype       : static smtUint32 GPIO01Test(void)
    Return          : Return to error code
    Argument        :
    Comments        :
    		GPIO 0/1 input/output mode test
-----------------------------------------------------------------------*/
static smtUint32 GPIO01Test(void)
{
	smtUint8 i;
	smtUint8 * test_pattern = &st_test_pattern[1];
	
	SMT_WRITE(GPIO_CON0, GPIO0_GPIO_INPUT_MODE);
	SMT_WRITE(GPIO_CON1, GPIO1_GPIO_OUTPUT_MODE);
	
	for(i = 0; i <= 8; i++)
	{
		SMT_WRITE(GPIO_DAT1, test_pattern[i]);
		if(SMT_READ(GPIO_DAT0) != test_pattern[i])
			return GPIO01_ERROR;
	}

	SMT_WRITE(GPIO_CON1, GPIO1_GPIO_INPUT_MODE);
	SMT_WRITE(GPIO_CON0, GPIO0_GPIO_OUTPUT_MODE);

	for(i = 0; i <= 8; i++)
	{
		SMT_WRITE(GPIO_DAT0, test_pattern[i]);
		if(SMT_READ(GPIO_DAT1) != test_pattern[i])
			return GPIO01_ERROR;
	}

	SMT_WRITE(GPIO_CON1, GPIO1_GPIO_INPUT_MODE);
	SMT_WRITE(GPIO_CON0, GPIO0_GPIO_INPUT_MODE);

	SMT_WRITE(GPIO_CON1, MAKE_GPIO_CON2(0x1, 0x0));	// 0,2,4,6 : output, 1,3,5,7 : input
	SMT_WRITE(GPIO_CON0, MAKE_GPIO_CON2(0x1, 0x2));	// 0,2,4,6 : input,  1,3,5,7 : output

	SMT_WRITE(GPIO_DAT0, 0x00);
	SMT_WRITE(GPIO_DAT1, 0x00);

	for(i = 0; i <= 8; i+=2)
	{
		SMT_WRITE(GPIO_DAT0, test_pattern[i]);
		if(SMT_READ(GPIO_DAT0) != ((test_pattern[i]&0xAA)|(test_pattern[i-1]&0x55))
			|| SMT_READ(GPIO_DAT1) != ((test_pattern[i]&0xAA)|(test_pattern[i-1]&0x55)))
			return GPIO01_ERROR;

		SMT_WRITE(GPIO_DAT1, test_pattern[i+1]);
		if(SMT_READ(GPIO_DAT0) != ((test_pattern[i]&0xAA)|(test_pattern[i+1]&0x55))
			|| SMT_READ(GPIO_DAT1) != ((test_pattern[i]&0xAA)|(test_pattern[i+1]&0x55)))
			return GPIO01_ERROR;
	}

	SMT_WRITE(GPIO_CON1, GPIO1_GPIO_INPUT_MODE);
	SMT_WRITE(GPIO_CON0, GPIO0_GPIO_INPUT_MODE);

	SMT_WRITE(GPIO_CON1, MAKE_GPIO_CON2(0x0, 0x1));	// 0,2,4,6 : input,  1,3,5,7 : output
	SMT_WRITE(GPIO_CON0, MAKE_GPIO_CON2(0x2, 0x1));	// 0,2,4,6 : output, 1,3,5,7 : input

	SMT_WRITE(GPIO_DAT0, 0x00);
	SMT_WRITE(GPIO_DAT1, 0x00);

	for(i = 0; i <= 8; i+=2)
	{
		SMT_WRITE(GPIO_DAT0, test_pattern[i]);
		if(SMT_READ(GPIO_DAT1) != ((test_pattern[i]&0x55)|(test_pattern[i-1]&0xAA))
			|| SMT_READ(GPIO_DAT0) != ((test_pattern[i]&0x55)|(test_pattern[i-1]&0xAA)))
			return GPIO01_ERROR;

		SMT_WRITE(GPIO_DAT1, test_pattern[i+1]);
		if(SMT_READ(GPIO_DAT1) != ((test_pattern[i]&0x55)|(test_pattern[i+1]&0xAA))
			|| SMT_READ(GPIO_DAT0) != ((test_pattern[i]&0x55)|(test_pattern[i+1]&0xAA)))
			return GPIO01_ERROR;
	}

	SMT_WRITE(GPIO_CON1, GPIO1_GPIO_INPUT_MODE);
	SMT_WRITE(GPIO_CON0, GPIO0_GPIO_INPUT_MODE);

	return NO_ERROR;
}

/*-----------------------------------------------------------------------
    Function name   : GPIO01Test()
    Prototype       : static smtUint32 GPIO23Test(void)
    Return          : Return to error code
    Argument        :
    Comments        :
    		GPIO 2/3 input/output mode test
-----------------------------------------------------------------------*/
static smtUint32 GPIO23Test(void)
{
	smtUint8 i;
	smtUint8 * test_pattern = &st_test_pattern[1];

	SMT_WRITE(GPIO_CON2, GPIO2_GPIO_INPUT_MODE);
	SMT_WRITE(GPIO_CON3, GPIO3_GPIO_OUTPUT_MODE);

	for(i = 0; i <= 8; i++)
	{
		SMT_WRITE(GPIO_DAT3, test_pattern[i]);
		if(SMT_READ(GPIO_DAT2) != test_pattern[i])
			return GPIO23_ERROR;
	}

	SMT_WRITE(GPIO_CON3, GPIO3_GPIO_INPUT_MODE);
	SMT_WRITE(GPIO_CON2, GPIO2_GPIO_OUTPUT_MODE);

	for(i = 0; i <= 8; i++)
	{
		SMT_WRITE(GPIO_DAT2, test_pattern[i]);
		if(SMT_READ(GPIO_DAT3) != test_pattern[i])
			return GPIO23_ERROR;
	}

	SMT_WRITE(GPIO_CON3, GPIO3_GPIO_INPUT_MODE);
	SMT_WRITE(GPIO_CON2, GPIO2_GPIO_INPUT_MODE);

	SMT_WRITE(GPIO_CON3, MAKE_GPIO_CON2(0x1, 0x0));	// 0,2,4,6 : output, 1,3,5,7 : input
	SMT_WRITE(GPIO_CON2, MAKE_GPIO_CON2(0x2, 0x3));	// 0,2,4,6 : input,  1,3,5,7 : output

	SMT_WRITE(GPIO_DAT2, 0x00);
	SMT_WRITE(GPIO_DAT3, 0x00);

	for(i = 0; i <= 8; i+=2)
	{
		SMT_WRITE(GPIO_DAT2, test_pattern[i]);
		if(SMT_READ(GPIO_DAT3) != ((test_pattern[i]&0xAA)|(test_pattern[i-1]&0x55))
			|| SMT_READ(GPIO_DAT2) != ((test_pattern[i]&0xAA)|(test_pattern[i-1]&0x55)))
			return GPIO23_ERROR;

		SMT_WRITE(GPIO_DAT3, test_pattern[i+1]);
		if(SMT_READ(GPIO_DAT2) != ((test_pattern[i]&0xAA)|(test_pattern[i+1]&0x55))
			|| SMT_READ(GPIO_DAT3) != ((test_pattern[i]&0xAA)|(test_pattern[i+1]&0x55)))
			return GPIO23_ERROR;
	}

	SMT_WRITE(GPIO_CON3, GPIO3_GPIO_INPUT_MODE);
	SMT_WRITE(GPIO_CON2, GPIO2_GPIO_INPUT_MODE);

	SMT_WRITE(GPIO_CON3, MAKE_GPIO_CON2(0x0, 0x1));	// 0,2,4,6 : input,  1,3,5,7 : output
	SMT_WRITE(GPIO_CON2, MAKE_GPIO_CON2(0x3, 0x2));	// 0,2,4,6 : output, 1,3,5,7 : input

	SMT_WRITE(GPIO_DAT3, 0x00);
	SMT_WRITE(GPIO_DAT2, 0x00);

	for(i = 0; i <= 8; i+=2)
	{
		SMT_WRITE(GPIO_DAT2, test_pattern[i]);
		if(SMT_READ(GPIO_DAT2) != ((test_pattern[i]&0x55)|(test_pattern[i-1]&0xAA))
			|| SMT_READ(GPIO_DAT3) != ((test_pattern[i]&0x55)|(test_pattern[i-1]&0xAA)))
			return GPIO23_ERROR;

		SMT_WRITE(GPIO_DAT3, test_pattern[i+1]);
		if(SMT_READ(GPIO_DAT2) != ((test_pattern[i]&0x55)|(test_pattern[i+1]&0xAA))
			|| SMT_READ(GPIO_DAT3) != ((test_pattern[i]&0x55)|(test_pattern[i+1]&0xAA)))
			return GPIO23_ERROR;
	}

	SMT_WRITE(GPIO_CON3, GPIO3_GPIO_INPUT_MODE);
	SMT_WRITE(GPIO_CON2, GPIO2_GPIO_OUTPUT_MODE);

	return NO_ERROR;
}

