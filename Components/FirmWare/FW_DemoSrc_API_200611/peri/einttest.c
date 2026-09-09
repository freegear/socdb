/*----------------------------------------------------------
	File Name   : einttest.c 
	Description : External Interrupt Test
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
#define EINT_TEST       1
#define INT_I2C_TEST        0
#define INT_TIMER_TEST  0
#define INT_WDT_TEST    0
#define INT_ADC_TEST    0
#define INT_UART        0

#define NUM_EINT_TEST	8	// # of eints to test

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
smtUint32 VICTest(void);
static smtUint32 EIntTest(void);
static void EIntISR(smtUint32 IRQ);


/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
volatile static smtInt32 eintCheck[8] = { 0, };

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : VICTest()
    Prototype           : smtUint32 VICTest(void)
    Return              : void
    Argument        :
    Comments        : VIC test routine
-----------------------------------------------------------------------*/
smtUint32 VICTest(void)
{
    smtUint32 errorCode;

#if EINT_TEST
	// Call User Functions
	if(EIntTest() != SMT_SUCCESS)
	{
		errorCode = VIC_ERROR;	// errorCode must be unique.
		return errorCode;
	}
#endif

    return NO_ERROR;       // Success
}


/*-----------------------------------------------------------------------
    Function name   : EIntTest()
    Prototype       : smtUnit32 EIntTest(void)
    Return          : 0 when Succeed, infinite loop when fail
    Argument        :
    Comments        : External Interrupt Test
-----------------------------------------------------------------------*/
static smtUint32 EIntTest(void)
{
	int i;
	for(i = 0; i < NUM_EINT_TEST; i++)
		eintCheck[i] = 0;

    SMT_WRITE(GPIO_CON0, 0x00000000);	// GPIO0 : External Interrupt Mode
    // Request IRQ
    RequestIRQ(IRQ_EINT0, EIntISR);
    RequestIRQ(IRQ_EINT1, EIntISR);
    RequestIRQ(IRQ_EINT2, EIntISR);
    RequestIRQ(IRQ_EINT3, EIntISR);
    RequestIRQ(IRQ_EINT4, EIntISR);
    RequestIRQ(IRQ_EINT5, EIntISR);
    RequestIRQ(IRQ_EINT6, EIntISR);
    RequestIRQ(IRQ_EINT7, EIntISR);

	while(1)
	{
		int flag = 1;
		for(i = 0; i < NUM_EINT_TEST; i++)
		{
			if(eintCheck[i] == 0)
			{
				flag = 0;
				break;
			}
		}

		if(flag != 0)	// all interrupt detected
			break;
	}

    ReleaseIRQ(IRQ_EINT0);
    ReleaseIRQ(IRQ_EINT1);
    ReleaseIRQ(IRQ_EINT2);
    ReleaseIRQ(IRQ_EINT3);
    ReleaseIRQ(IRQ_EINT4);
    ReleaseIRQ(IRQ_EINT5);
    ReleaseIRQ(IRQ_EINT6);
    ReleaseIRQ(IRQ_EINT7);

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : EIntISR()
    Prototype       : void EIntISR(void)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
static void EIntISR(smtUint32 IRQ)
{
	if(IRQ < 4)
		eintCheck[IRQ] += 1;
	else if(IRQ >= 12 && IRQ < 16)
		eintCheck[IRQ-12+4] += 1;
}
