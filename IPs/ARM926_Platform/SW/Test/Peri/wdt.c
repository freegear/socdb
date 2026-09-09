/*----------------------------------------------------------
	File Name   : wdt.c 
	Description : WDT test code
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
#define WDT_PRS_VAL     0x4
#define WDT_LDR_VAL     0x10

#define RESET_ENABLE    0       // WDT reset enable

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
smtUint32 WDTTest(void);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : WDTTest()
    Prototype           : smtUint32 WDTTest(void)
    Return              : error code
    Argument        :
    Comments        : Return a error-code

    WDT register list
        WDTCR   - Control register  (R/W)
        WDTPSR  - Prescaler register    (R/W)
        WDTLDR  - Load register (R/W)
        WDTVLR  - Value register    (R)
        WDTISR  - Interrupt status register (R)
-----------------------------------------------------------------------*/
smtUint32 WDTTest(void)
{
    volatile smtUint32 readData;

    // WDT test
    SMT_WRITE(WDTPSR,  WDT_PRS_VAL);
    SMT_WRITE(WDTTLDR, WDT_LDR_VAL);

#if RESET_ENABLE
    // WDT interrupt enable & WDT enable & WDT reset enable
    //SMT_WRITE(WDTCR, 1<<WDT_INTEN | 1<<WDT_RSTEN | 1<<WDT_EN);
#else
    // WDT interrupt enable & WDT enable
    SMT_WRITE(WDTCR, WDT_INTEN | WDT_EN);
#endif

    // Time delay to occur WDT interrupt
    smtDelay100us(1);

    ReleaseIRQ(IRQ_WDT);

    // Just return to WDT interrupt success or fail
    // Really, the following routine is ISR routine part.
    readData = SMT_READ(WDTISR);
    if(readData == WDTISR_FLAG)      // WDT interrupt occurs.
    {
        SMT_WRITE(WDTISR, 1<<WDTISR_FLAG);   // WDT interrupt status clear.
        //SMT_WRITE(WDTCR, 0x0);      // WDT intr disable / WDT disable
        SMT_WRITE(WDTCR, (~(signed)WDT_INTEN&WDT_INTEN)|(~WDT_EN&WDT_EN));
        return NO_ERROR;
    }
    else
    {
        //SMT_WRITE(WDTCR, 0x0);      // WDT intr disable / WDT disable
        SMT_WRITE(WDTCR, (~(signed)WDT_INTEN&WDT_INTEN)|(~WDT_EN&WDT_EN));
        return WDT_ERROR;
    }
}
