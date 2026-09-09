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

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "wdt.h"


/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

#define PRESCALE_MIN		0x1FF
//#define PRESCALE_MAX		0xFFFFUL
#define PRESCALE_MAX		0xFFFUL

#define WDT_MIN_LDRER		0x1FF
//#define WDT_MAX_LDRER		0xFFFFUL
#define WDT_MAX_LDRER		0xFFFUL

#define WDTDIV_16				0x0
#define WDTDIV_32				0x1
#define WDTDIV_64				0x2
#define WDTDIV_128				0x3

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
static void ISRWDT(smtUint32 irq);

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
static volatile smtUint8 wdtFlag = 0;

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

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

#if 0
	// TEST1 : Register R/W
	errCode = RegisterWDT();
	if (errCode != SMT_SUCCESS)
		return SMT_ERROR;
#endif

	// TEST2 : Operation
	// 1) Prescaler : min / max test
	WDTpreScaleTest(PRESCALE_MIN, PRESCALE_MAX);

	// 2) Loader : min max test
	WDTReloadTest(WDT_MIN_LDRER, WDT_MAX_LDRER);

	// 3) Divider & Clock select test
	WDTDivideTest();

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: WDTpreScaleTest()
	Prototype		: void WDTpreScaleTest(smtUint16 min, smtUint16 max)
	Return		:
	Argument	:
	Comments	:
		WDT prescale test

		Reload value	- Fix
		Divide		- Fix
		Clk select	- Fix
----------------------------------------------------------*/
void WDTpreScaleTest(smtUint16 min, smtUint16 max)
{
	smtUint16 value;
	WdtProperty wdt;

	// WDT interrupt enable and ISR regist
	RequestIRQ(IRQ_WDT, ISRWDT);

	for (value = min; value < max; value+=0x50)
	{
		// WDT setting
		wdt.preScale = value;
		wdt.reloadValue = WDT_MIN_LDRER;
		wdt.div = WDTDIV_16;
		wdt.clkSel = 0x1;		// Prescale and divide clock use
		wdt.intEn = 0x1;		// interrupt enable
		wdt.rstEn = 0x0;		// reset disable
		wdt.wdtEn = 0x1;		// wdt enable

		smtWDTSetMode(&wdt);

		while(1)
		{
			if (wdtFlag == 1)
			 break;
		}

		wdtFlag = 0;

		wdt.intEn = 0;
		wdt.wdtEn = 0;
		smtWDTSetMode(&wdt);

		smt2UARTPrint(CFG_UART_CH, "WDT preScale Test : 0x%x\n", value);
	}

	ReleaseIRQ(IRQ_WDT);
	smt2UARTPrint(CFG_UART_CH, "WDT preScale Test done\n");
}

/*----------------------------------------------------------
	Function name	: WDTReloadTest()
	Prototype		: void WDTReloadTest(smtUint16 min, smtUint16 max)
	Return		:
	Argument	:
	Comments	:
		WDT reload test

		Prescale value	- Fix
		Divide		- Fix
		Clk select	- Fix
----------------------------------------------------------*/
void WDTReloadTest(smtUint16 min, smtUint16 max)
{
	smtUint16 value;
	WdtProperty wdt;

	// WDT interrupt enable and ISR regist
	RequestIRQ(IRQ_WDT, ISRWDT);

	for (value = min; value < max; value+=0x50)
	{
		// WDT setting
		wdt.preScale = 0x2;
		wdt.reloadValue = value;
		wdt.div = WDTDIV_16;
		wdt.clkSel = 0x1;		// Prescale and divide clock use
		wdt.intEn = 0x1;		// interrupt enable
		wdt.rstEn = 0x0;		// reset disable
		wdt.wdtEn = 0x1;		// wdt enable

		smtWDTSetMode(&wdt);

		while(1)
		{
			if (wdtFlag == 1)
			 break;
		}

		wdtFlag = 0;

		wdt.intEn = 0;
		wdt.wdtEn = 0;
		smtWDTSetMode(&wdt);

		smt2UARTPrint(CFG_UART_CH, "WDT Reload Test : 0x%x\n", value);
	}

	ReleaseIRQ(IRQ_WDT);
	smt2UARTPrint(CFG_UART_CH, "WDT Reload Test done\n");
}

/*----------------------------------------------------------
	Function name	: WDTDivideTest()
	Prototype		: void WDTDivideTest(void)
	Return		:
	Argument	:
	Comments	:
		WDT reload test

		Prescale value	- Fix
		Reload  value	- Fix
----------------------------------------------------------*/
void WDTDivideTest(void)
{
	smtUint8 clkSel;
	smtUint16 value;
	WdtProperty wdt;

	// WDT interrupt enable and ISR regist
	RequestIRQ(IRQ_WDT, ISRWDT);

	for (clkSel = 0; clkSel < 2; clkSel++)
		for (value = 0; value < 4; value++)
		{
			// WDT setting
			wdt.preScale = PRESCALE_MIN;
			wdt.reloadValue = WDT_MIN_LDRER;
			wdt.div = value;
			wdt.clkSel = 0x1;		// Prescale and divide clock use
			wdt.intEn = 0x1;		// interrupt enable
			wdt.rstEn = 0x0;		// reset disable
			wdt.wdtEn = 0x1;		// wdt enable

			smtWDTSetMode(&wdt);

			while(1)
			{
				if (wdtFlag == 1)
				 break;
			}

			wdtFlag = 0;

			wdt.intEn = 0;
			wdt.wdtEn = 0;
			smtWDTSetMode(&wdt);

			smt2UARTPrint(CFG_UART_CH, "WDT Divide Test : 0x%x\n", value);
		}

	ReleaseIRQ(IRQ_WDT);
	smt2UARTPrint(CFG_UART_CH, "WDT Divide Test done\n");
}



/*----------------------------------------------------------
	Function name	: ISRWDT()
	Prototype		: void ISRWDT()
	Return		: void
	Argument	:
	Comments	: For checking the interval mode in timer function
-----------------------------------------------------------*/
static void ISRWDT(smtUint32 irq)
{
	smt2UARTPrint(CFG_UART_CH, "WDT ISR\n");

	smtWDTClearISR();		// WDT interrupt clear
	wdtFlag = 1;
}

