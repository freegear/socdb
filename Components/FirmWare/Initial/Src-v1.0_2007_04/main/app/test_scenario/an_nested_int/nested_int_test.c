/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: nested_int_test.c 
	Description	: nested interrupt test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "sysinc.h"
#include "commonmacro.h"
#include "irq.h"
#include "lib.h"
#include "timerpwm.h"

#include "registeraddr.h"

#include "uart_pre_drv.h"
#include "uart_post_drv.h"



/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

#define TIMER_PRESCALE0	0x3000
#define PRESCALE_MAX		0x3FFUL

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
static void ISRTIMER(smtUint32 irq);
static void ISRTIMER1(smtUint32 irq);
static void ISRTIMER2(smtUint32 irq);
static void ISRTIMER3(smtUint32 irq);

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
static smtUint8 timerCh = TIMER_SEL0;

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: NestedIntTest()
	Prototype		: void NestedIntTest(void)
	Return			: void
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void NestedIntTest(void)
{
	smtUint32		data;
	smtUint16		prescale;
	TimerProperty	timer;
	smtUint8 		uartInput;

	// Register IRQ
	RequestIRQ(IRQ_TIMER0, ISRTIMER);
	RequestIRQ(IRQ_TIMER1, ISRTIMER1);
	RequestIRQ(IRQ_TIMER2, ISRTIMER2);
	RequestIRQ(IRQ_TIMER3, ISRTIMER3);

	// Enable TIMER0 ~ 3
	prescale = PRESCALE_MAX;
	for (timerCh = TIMER_SEL0; timerCh <= TIMER_SEL3; timerCh++)
	{
		if(timerCh == 0)
			timer.data		= 0xFF;
		else	
		timer.data			= TIMER_PRESCALE0 * (timerCh+1);
		timer.prescale		= prescale;
	 	timer.opMode		= TIMER_INTERVAL;
		timer.timerClear	= 0;
		timer.timerEn		= 1;
		smtTIMERSetMode(timerCh, &timer);
	}

	// Get user input
	uartInput = 0;
	smt2UARTPrint(CFG_UART_CH, "press '0' to exit the nested interrupt test \n");
	while(1)
	{
		smt2UARTDataValid(CFG_UART_CH, &uartInput);
		if(uartInput)
		{
			smt2UARTGetCh(CFG_UART_CH, &uartInput, 0);
			if(uartInput == '0')
				break;
		}
	}

	// Disable Timer
	for (timerCh = TIMER_SEL0; timerCh <= TIMER_SEL3; timerCh++)
	{
		timer.timerClear	= 0;
		timer.timerEn		= 0;
		smtTIMERSetMode(timerCh, &timer);
	}

	// Release IRQ
	ReleaseIRQ(IRQ_TIMER0);
	ReleaseIRQ(IRQ_TIMER1);
	ReleaseIRQ(IRQ_TIMER2);
	ReleaseIRQ(IRQ_TIMER3);

	smt2UARTPrint(CFG_UART_CH, "The nested interrupt test finished!! \n");
	return;
}

/*----------------------------------------------------------
	Function name	: ISRTIMER()
	Prototype		: void ISRTIMER()
	Return			: void
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static void ISRTIMER(smtUint32 irq)
{
	static smtUint32 staticCnt = 0;
	
	if(!(staticCnt++%0xFF))
	{
		GPIO0_OUT = GPIO0_OUT ^ 0x000F;
	}

}

/*----------------------------------------------------------
	Function name	: ISRTIMER1()
	Prototype		: void ISRTIMER1()
	Return			: void
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static void ISRTIMER1(smtUint32 irq)
{
	GPIO0_OUT = GPIO0_OUT ^ 0x00F0;
}

/*----------------------------------------------------------
	Function name	: ISRTIMER2()
	Prototype		: void ISRTIMER2()
	Return			: void
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static void ISRTIMER2(smtUint32 irq)
{
	GPIO0_OUT = GPIO0_OUT ^ 0x0F00;
}

/*----------------------------------------------------------
	Function name	: ISRTIMER3()
	Prototype		: void ISRTIMER3()
	Return			: void
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static void ISRTIMER3(smtUint32 irq)
{
	GPIO0_OUT = GPIO0_OUT ^ 0xF000;
}

