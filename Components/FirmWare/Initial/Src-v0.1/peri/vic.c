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
#define EINT_TEST			1
#define INT_I2C_TEST		0
#define INT_TIMER_TEST		0
#define INT_WDT_TEST		0
#define INT_ADC_TEST		0
#define INT_UART			0

#define NUM_EINT_TEST		8	// # of eints to test


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
smtUint32 VICTest(void);
static smtUint32 EIntTest(void);
static void EIntISR(smtUint32 IRQ);


/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
volatile static smtInt32 eintCheck[NUM_EINT_TEST] = { 0, };


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
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

	// TEST1 : Register R/W
	(smtBoolean)errorCode = RegisterVIC();
	if (errorCode != SMT_SUCCESS)
		return SMT_ERROR;

	// TEST2 : External interrupt	
#if EINT_TEST
	// Call User Functions
	if(EIntTest() != SMT_SUCCESS)
	{
		//errorCode = VIC_ERROR;	// errorCode must be unique.
		//return errorCode;
		return SMT_ERROR;
	}
#endif

	// TEST3 : Round-robin
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: EIntTest()
	Prototype		: smtUnit32 EIntTest(void)
	Return		: 0 when Succeed, infinite loop when fail
	Argument	:
	Comments	: External Interrupt Test
-----------------------------------------------------------*/
static smtUint32 EIntTest(void)
{
	smtUint32 i;

	for(i = 0; i < NUM_EINT_TEST; i++)
		eintCheck[i] = 0;
	
	//SMT_WRITE(GPIO_CON0, 0x00000000);	// GPIO0 : External Interrupt Mode

	// Regist IRQ
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
		smtUint32 flag = 1;
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

	// Release IRQ
	ReleaseIRQ(IRQ_EINT0);	// 0
	ReleaseIRQ(IRQ_EINT1);	// 1
	ReleaseIRQ(IRQ_EINT2);	// 2
	ReleaseIRQ(IRQ_EINT3);	// 3
	ReleaseIRQ(IRQ_EINT4);	// 12
	ReleaseIRQ(IRQ_EINT5);	// 13
	ReleaseIRQ(IRQ_EINT6);	// 14
	ReleaseIRQ(IRQ_EINT7);	// 15
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: EIntISR()
	Prototype		: void EIntISR(smtUint32 IRQ)
	Return		: 
	Argument	:
	Comments	: 
-----------------------------------------------------------*/
static void EIntISR(smtUint32 IRQ)
{
	if(IRQ < (IRQ_EINT3+1))
		eintCheck[IRQ] += 1;
	else if(IRQ >= IRQ_EINT4 && IRQ < (IRQ_EINT7+1))
		eintCheck[IRQ -IRQ_EINT4 + 4] += 1;

	AckIRQ(IRQ);	// WDT interrupt clear
}

