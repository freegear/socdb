/*----------------------------------------------------------
	File Name   : pwrmanage.c 
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

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define GPIO_EINTSET    0x0


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : PWRManageTest()
    Prototype           : smtUint32 PWRManageTest(void)
    Return              : error code
    Argument        :
    Comments        : Return a error-code
-----------------------------------------------------------------------*/
smtUint32 PWRManageTest(void)
{
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
    SMT_WRITE(SYSCON, SYS_GIE_EN | STOP_CTL);
#if __GCC_ARM__

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
}
