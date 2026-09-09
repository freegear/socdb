/*----------------------------------------------------------
	File Name   : uarttest.c 
	Description : UART Test using PrimeCell Test Routines.
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"
#include "lib.h"
#include "irq.h"
#include "uartglobal.h"


/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define UART_BASE_ADDR	((smtUint32)(&(UARTDR)))

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
typedef void (*UARTRealISR)(void);
smtUint32 UARTTest(void);
void UARTISRConnect(UARTRealISR func);
static void UARTISR(smtUint32 IRQ);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
static UARTRealISR	realISR = (void *)0;
smtUint32 UARTProgressCount = 0;

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : UARTTest()
    Prototype       : smtUint32 UARTTest(void)
    Return          : 0 when success, other value when failure.
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtUint32 UARTTest(void)
{
    smtUint32 errorCode = 0;
	extern apTEST_eResult apUART_SelfTest(UWORD32 Id,
                                      UWORD32 RegBase,
                                      UWORD32 NumSources, 
                                      CONST apOS_INT_oInterruptSource * CONST pInt);

	// We want ORed interrupt from UART
	SMT_WRITE(SYSCON, (UCLKDIV_VALUE<<(SHIFT_DN_FROM_MASK(UART_CLK_DIV))) | SYS_GIE_EN | UART_INT_SEL);
	SMT_WRITE(GPIO_CON3, 0x0000FF00);	// GPIO3: IrDA & UART output
#if UART_TEST_DEBUG
	SMT_WRITE(GPIO_CON1, 0x00005555);	// all push_pull output
#endif

	UART_TEST_PROGRESS_CHECK();
    RequestIRQ(IRQ_UARTTX, UARTISR);	// IRQ_UART_TX is TOTAL interrupt

	if(apUART_SelfTest(0, UART_BASE_ADDR, 0, (void *)0) != apTEST_PASS)
		errorCode = UART_ERROR;

    ReleaseIRQ(IRQ_UARTTX);
	realISR = (void *)0;
    return errorCode;       // Success
}

/*-----------------------------------------------------------------------
    Function name   : UARISRConnect()
    Prototype       : void UARTISRConnect(void (*)(void))
    Return          : 
    Argument        : Real IRQ Service Routine @ PrimeCell Test Routine
    Comments        : 
-----------------------------------------------------------------------*/
void UARTISRConnect(UARTRealISR func)
{
	realISR = func;
}

/*-----------------------------------------------------------------------
    Function name   : UARTISR()
    Prototype       : void UARTISR(smtUint32 IRQ)
    Return          : 
    Argument        : IRQ => IRQ number
    Comments        : 
-----------------------------------------------------------------------*/
static void UARTISR(smtUint32 IRQ)
{
	if(realISR)
		realISR();
}

