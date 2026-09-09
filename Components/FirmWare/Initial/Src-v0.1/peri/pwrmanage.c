/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: pwrmanage.c 
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

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define GPIO_EINTSET    0x0


/*/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
	VARIABLE DECLARATION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
    Function name   : PWRManageTest()
    Prototype           : smtUint32 PWRManageTest(void)
    Return              : error code
    Argument        :
    Comments        : Return a error-code
-----------------------------------------------------------*/
smtUint32 PWRManageTest(void)
{
#if 0	// Old test code for SDI 2007/01/16 by DJKIM
	// Enable EINT0~7
	// GPIO0_0~7 -> EINT0~7 setting
	SMT_WRITE(GPIO_CON0, GPIO_EINTSET);
	
	EnableIRQ(IRQ_EINT0);
	EnableIRQ(IRQ_EINT1);
	EnableIRQ(IRQ_EINT2);
	EnableIRQ(IRQ_EINT3);
	EnableIRQ(IRQ_EINT4);
	EnableIRQ(IRQ_EINT5);
	EnableIRQ(IRQ_EINT6);
	EnableIRQ(IRQ_EINT7);
	
	// Stop mode
	SMT_WRITE(PM_CLKCON, PM_PWDN_EN);

#ifdef __ARM_GCC_USE__
	__asm__
	(
		"nop\n\t" \
		"nop\n\t" \
		"nop\n\t" \
		"nop\n\t" \
	 );
#else
	__asm
	{
		 nop;
		 nop;
		 nop;
		 nop;
	}
#endif
	return NO_ERROR;
#endif

	smtBoolean boolErr;

	// TEST1 : Register R/W
	boolErr = RegisterPower();

	// Further work - Test in the mass product. 
	// TEST2 : Slow mode
	// TEST3 : Idle mode
	// TEST4 : Power down mode
	// TEST5 : USB clock divide
	// TEST6 : UART clock divide
	// TEST7 : Peri bus clock divide
	// TEST8 : System bus clock divide

	return boolErr;
}

