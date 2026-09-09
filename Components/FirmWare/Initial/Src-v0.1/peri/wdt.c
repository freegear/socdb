/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: wdt.c 
	Description	: WDT test code
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
#define WDT_MIN_PRESCALE_VAL	0x2
#define WDT_MAX_PRESCALE_VAL	0xFFFF

#define WDT_MIN_LDRER_VAL		0x2
#define WDT_MAX_LDRER_VAL		0xFFFF

#define RESET_ENABLE			0       // WDT reset enable
#define WDT_INT_NUM			0x0


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
static void ISRWDT(smtUint32 irq);
smtUint32 WDTOperationTest(smtUint32 prescaleVal, smtUint32 loaderVal);


/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	Function name	: WDTTest()
	Prototype		: smtUint32 WDTTest(void)
	Return		: error code
	Argument	:
	Comments	: Return a error-code

		WDT register list
			WDTCR   - Control register  (R/W)
			WDTPSR  - Prescaler register    (R/W)
			WDTLDR  - Load register (R/W)
			WDTVLR  - Value register    (R)
			WDTISR  - Interrupt status register (R)
----------------------------------------------------------*/
smtUint32 WDTTest(void)
{
	smtUint32 errCode;

	// TEST1 : Register R/W
	(smtBoolean)errCode = RegisterWDT();
	if (errCode != SMT_SUCCESS)
		return SMT_ERROR;

	// TEST2 : Operation
	// 1) Prescaler : min value, Loader : max value
	errCode = WDTOperationTest(WDT_MIN_PRESCALE_VAL, WDT_MAX_LDRER_VAL);
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;

	// 2) Prescaler : max value, Loader : min value
	errCode = WDTOperationTest(WDT_MAX_PRESCALE_VAL, WDT_MIN_LDRER_VAL);
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;

	// TEST3 : Interrupt test
	// Interupt test is included in TEST2

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: WDTOperationTest()
	Prototype		: smtUint32 WDTOperationTest(smtUint32 prescaleVal, smtUint32 loaderVal)
	Return		: error code
	Argument	:
	Comments	:
		WDT operation test
----------------------------------------------------------*/
smtUint32 WDTOperationTest(smtUint32 prescaleVal, smtUint32 loaderVal)
{
	volatile smtUint32 readData;

	// WDT operation test with interrupt occurence in the fixed prescale & load value.
	SMT_WRITE(WDTPSR,  prescaleVal);
	SMT_WRITE(WDTTLDR, loaderVal);

	// WDT interrupt enable and ISR regist
	RequestIRQ(WDT_INT_NUM, ISRWDT);	// WDT ISR regist

#if RESET_ENABLE
	// WDT interrupt enable & WDT enable & WDT reset enable
	SMT_WRITE(WDTCR, 1<<WDT_INTEN | 1<<WDT_RSTEN | 1<<WDT_EN);
#else
	// WDT interrupt enable & WDT enable
	SMT_WRITE(WDTCR, WDT_INTEN | WDT_EN);
#endif

	// Time delay to occur WDT interrupt
	smtDelay100us(10);

	// WDT interrupt disable and ISR release
	//ReleaseIRQ(IRQ_WDT);
	ReleaseIRQ(WDT_INT_NUM);			// WDT ISR release

	// Just return to WDT interrupt success or fail
	// Really, the following routine is ISR routine part.
	readData = SMT_READ(WDTISR);

	if(readData == WDTISR_FLAG)      // WDT interrupt occurs.
	{
		SMT_WRITE(WDTISR, 1<<WDTISR_FLAG);   // WDT interrupt status clear.
		//SMT_WRITE(WDTCR, 0x0);      // WDT intr disable / WDT disable
		SMT_WRITE(WDTCR, (~(signed)WDT_INTEN&WDT_INTEN)|(~WDT_EN&WDT_EN));

		return SMT_SUCCESS;
	}
	else
	{
		//SMT_WRITE(WDTCR, 0x0);      // WDT intr disable / WDT disable
		SMT_WRITE(WDTCR, (~(signed)WDT_INTEN&WDT_INTEN)|(~WDT_EN&WDT_EN));

		return SMT_ERROR;
	}
}

/*----------------------------------------------------------
	Function name	: ISRWDT()
	Prototype		: static void ISRWDT(smtUint32 irq)
	Return		:
	Argument	:
	Comments	:
		WDT interrupt handler
----------------------------------------------------------*/
static void ISRWDT(smtUint32 irq)
{
	AckIRQ(irq);	// WDT interrupt clear
}
