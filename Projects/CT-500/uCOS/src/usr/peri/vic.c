/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: vic.c 
	Description	: Vectored Interrupt Controller test
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
//#include "irq.h"

#include "uart_pre_drv.h"
#include "uart_post_drv.h"

#include "registeraddr.h"

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

#define EINT_TEST			1
#define INT_I2C_TEST		0
#define INT_TIMER_TEST		0
#define INT_WDT_TEST		0
#define INT_ADC_TEST		0
#define INT_UART			0

#define NUM_EINT_TEST		2	// # of eints to test


/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

smtUint32 VICTest(void);

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/


/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: VICTest()
	Prototype		: smtUint32 VICTest(void)
	Return		: void
	Argument	:
	Comments	: VIC test routine
-----------------------------------------------------------*/
smtUint32 VICTest(void)
{
	smtUint32 errorCode;	

	smt2UartPrint(11, "Enter VICTest() function\n");

	// TEST1 : Register R/W
	errorCode = RegisterVIC();
	if (errorCode != SMT_SUCCESS)
		return SMT_ERROR;

	
	return SMT_SUCCESS;
}