/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: timerpwm.c 
	Description	: Timer & PWM test routine
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
#define TIMER_PRESCALE1	0x6000
#define TIMER_PRESCALE2	0x9000
#define TIMER_PRESCALE3	0xC000


#define PRESCALE_MIN		0x1FF	// Clock = PCLK/(Prescale+1)
#define PRESCALE_MAX		0x3FFUL

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
static void ISRTIMER(smtUint32 irq);

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
static volatile smtUint8 timerFlag = 0;
static smtUint8 timerCh = TIMER_SEL0;

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: TimerTest()
	Prototype		: void TimerTest(void)
	Return			: void
	Argument		:
	Comments		:
		Timer & PWM test function
-----------------------------------------------------------*/
smtUint32 TimerTest(void)
{
	smtBoolean boolErr;

#if 0
	// TEST1 : Register R/W
	boolErr = RegisterTimer();
	if (boolErr != SMT_SUCCESS)
		return SMT_ERROR;
#endif

	// TEST2 : Timer interval mode
	TimerIntervalTest();
	
	// TEST3 : Timer match & overflow mode
	TimerOverFlowTest();

	smt2UartPrint(11, "\nTimer test done\n");
	return SMT_SUCCESS;
	
	ERROR:
		return SMT_ERROR;
}

static void TimerIRQ(smtUint32 irq)
{
	UARTPrintf("Timer(%d) IRQ(%d)\n", irq-IRQ_TIMER0, irq);
}

/*----------------------------------------------------------
	Function name	: TimerIntervalTest()
	Prototype		: void TimerIntervalTest(void)
	Return		: void
	Argument	:
	Comments	: For checking the interval mode in timer function
		[Interval mode]

		Timer ch0 ~ ch3
		prescale min ~ prescale max
-----------------------------------------------------------*/
void TimerIntervalTest(void)
{
	smtUint32 data;
	smtUint16 prescale;
	TIMER_STRUCT timer;

	// Register IRQ
	RequestIRQ(IRQ_TIMER0, ISRTIMER);
	RequestIRQ(IRQ_TIMER1, ISRTIMER);
	RequestIRQ(IRQ_TIMER2, ISRTIMER);
	RequestIRQ(IRQ_TIMER3, ISRTIMER);

	// TIMER0 ~ 3 Prescale Test
	for (timerCh = TIMER_SEL0; timerCh < TIMER_SEL3+1; timerCh++)
		for (prescale = PRESCALE_MIN; prescale < PRESCALE_MAX; prescale+=0xA0)
		{
			// 1. Timer setting (Internal mode)
			timer.data		= TIMER_PRESCALE0 * (timerCh+1);
			timer.prescale		= prescale;
		 	timer.opMode		= TIMER_INTERVAL;
			timer.timerClear	= 0;
			timer.timerEn		= 1;

			smtTIMERSetMode(timer, timerCh);

			while(1)
			{
				if (timerFlag == 1)
					 break;
			}

			timerFlag = 0;

			timer.timerClear = 0;
			timer.timerEn = 0;
			smtTIMERSetMode(timer, timerCh);

			smt2UartPrint(11, "TIMER Interval Test : %d, 0x%x\n", timerCh, prescale);
		}

	// Release IRQ
	ReleaseIRQ(IRQ_TIMER0);
	ReleaseIRQ(IRQ_TIMER1);
	ReleaseIRQ(IRQ_TIMER2);
	ReleaseIRQ(IRQ_TIMER3);

	smt2UartPrint(11, "TIMER Interval Test done\n");
}

/*----------------------------------------------------------
	Function name	: TimerOverFlowTest()
	Prototype		: void TimerOverFlowTest()
	Return		: void
	Argument	:
	Comments	: For checking the Match & Overflow mode in timer function
		[Match & Overflow mode]

		Timer ch0 ~ ch3
		prescale min ~ prescale max
-----------------------------------------------------------*/
void TimerOverFlowTest(void)
{
	smtUint32 data;
	smtUint16 prescale;
	TIMER_STRUCT timer;

	// Register IRQ
	RequestIRQ(IRQ_TIMER0, ISRTIMER);
	RequestIRQ(IRQ_TIMER1, ISRTIMER);
	RequestIRQ(IRQ_TIMER2, ISRTIMER);
	RequestIRQ(IRQ_TIMER3, ISRTIMER);

	// TIMER0 ~ 3 Prescale Test
	for (timerCh = TIMER_SEL0; timerCh < TIMER_SEL3+1; timerCh++)
		for (prescale = PRESCALE_MIN; prescale < PRESCALE_MAX; prescale+=0xA0)
		{
			// 1. Timer setting (Match & Overflow mode)
			timer.data		= TIMER_PRESCALE0 * (timerCh+1);
			timer.prescale		= prescale;
		 	timer.opMode		= TIMER_MATCHOVER;
			timer.timerClear	= 0;
			timer.timerEn		= 1;

			smtTIMERSetMode(timer, timerCh);

			while(1)
			{
				if (timerFlag == 1)
					 break;
			}

			timerFlag = 0;

			//while(0xFFFFFFFFUL != SMT_READ(TIMERCNT(timerCh)));
			while((TIMER_PRESCALE3+0x1000) != SMT_READ(TIMERCNT(timerCh)));
				

			timer.timerClear = 0;
			timer.timerEn = 0;
			smtTIMERSetMode(timer, timerCh);

			smt2UartPrint(11, "TIMER Match & Overflow Test : %d, 0x%x\n", timerCh, prescale);
		}

	// Release IRQ
	ReleaseIRQ(IRQ_TIMER0);
	ReleaseIRQ(IRQ_TIMER1);
	ReleaseIRQ(IRQ_TIMER2);
	ReleaseIRQ(IRQ_TIMER3);

	smt2UartPrint(11, "TIMER Match & Overflow Test done\n");
}

/*----------------------------------------------------------
	Function name	: ISRTIMER()
	Prototype		: void ISRTIMER()
	Return		: void
	Argument	:
	Comments	: 
-----------------------------------------------------------*/
static void ISRTIMER(smtUint32 irq)
{
	//smtTIMERClrCount(timerCh);
	smt2UartPrint(11, "Timer ISR\n");
	timerFlag = 1;
}
