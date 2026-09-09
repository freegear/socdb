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

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
//#include "irq.h"
#include "lib.h"
#include "timerpwm.h"


/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define TIMER_PRESCALE		0x2
#define TIMER_DATA			0x7

#define INTERNAL_CLK		0
#define EXTERNAL_CLK		1

#define NORMAL_PHASE		0
#define INVERT_PHASE		1

#define NUM_TIMER_TEST		8	// Number of timer to test


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
static void ISRTIMER(smtUint32 IRQ);
static void ISRTIMEROverFlow(smtUint32 IRQ);

void TimerIntervalTest(smtUint8 prescale, smtUint16 data);
void TimerOverFlowTest(smtUint8 prescale, smtUint16 data);


/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
volatile static smtInt32 timerIntCheck[NUM_TIMER_TEST] = { 0, };
volatile static smtInt32 timerOverInt[NUM_TIMER_TEST] = { 0, };


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
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

	// TEST1 : Register R/W
	boolErr = RegisterTimer();
	if (boolErr != SMT_SUCCESS)
		return SMT_ERROR;

	// TEST2 : Timer interval mode
	TimerIntervalTest(TIMER_PRESCALE, TIMER_DATA);
	
	// TEST3 : Timer match & overflow mode
	TimerOverFlowTest(TIMER_PRESCALE, TIMER_DATA);

	// TEST4 : Interrupt test
	// Interupt test is included in TEST2/3
}

/*----------------------------------------------------------
	Function name	: TimerIntervalTest()
	Prototype		: void TimerIntervalTest()
	Return		: void
	Argument	:
	Comments	: For checking the interval mode in timer function
-----------------------------------------------------------*/
void TimerIntervalTest(smtUint8 prescale, smtUint16 data)
{
	smtUint8 count;

	TIMER_STRUCT timer;

	timer.prescale		= prescale;
	timer.data		= data;
	timer.clk			= EXTERNAL_CLK;
	timer.opMode		= TIMER_INTERVAL;
	timer.phase		= NORMAL_PHASE;
	timer.timerClear	= 1;		// Clearing the counter
	timer.timerEn		= 1;

	for(count = 0; count < NUM_TIMER_TEST; count++)
		timerIntCheck[count] = 0;

#if 0
	SMT_WRITE(TPRE0, (smtUint32)timer.prescale);
	SMT_WRITE(TPRE1, (smtUint32)timer.prescale);
	SMT_WRITE(TPRE2, (smtUint32)timer.prescale);
	SMT_WRITE(TPRE3, (smtUint32)timer.prescale);
	SMT_WRITE(TPRE4, (smtUint32)timer.prescale);
	SMT_WRITE(TPRE5, (smtUint32)timer.prescale);
	SMT_WRITE(TPRE6, (smtUint32)timer.prescale);
	SMT_WRITE(TPRE7, (smtUint32)timer.prescale);
	
	SMT_WRITE(TDAT0, (smtUint32)timer.data);
	SMT_WRITE(TDAT1, (smtUint32)timer.data);
	SMT_WRITE(TDAT2, (smtUint32)timer.data);
	SMT_WRITE(TDAT3, (smtUint32)timer.data);
	SMT_WRITE(TDAT4, (smtUint32)timer.data);
	SMT_WRITE(TDAT5, (smtUint32)timer.data);
	SMT_WRITE(TDAT6, (smtUint32)timer.data);
	SMT_WRITE(TDAT7, (smtUint32)timer.data);

	//External clock used
	SMT_WRITE(TCON0,
		timer.opMode<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
		0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
		timer.clk<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //External clock 
		);
	
	SMT_WRITE(TCON1,
		timer.opMode<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
		0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
		timer.clk<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //External clock
		);
	
	SMT_WRITE(TCON2,
		timer.opMode<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
		0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
		timer.clk<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //External clock
		);
	
	SMT_WRITE(TCON3,
		timer.opMode<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
		0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
		timer.clk<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //External clock
		);


	timer.clk = INTERNAL_CLK;
	timer.phase = INVERT_PHASE;
	//Internal clcok used
	SMT_WRITE(TCON4,
		timer.opMode<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
		0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL)          |
		0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
		timer.clk<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  
		);

	SMT_WRITE(TCON5,
		timer.opMode<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
		0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
		timer.clk<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) 
		);

	SMT_WRITE(TCON6,
		timer.opMode<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
		0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
		timer.clk<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)
		);

	//Gpio 2 port shared to used checking Error
	SMT_WRITE(TCON7,
		timer.opMode<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
		timer.phase<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL)          |
		0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
		timer.clk<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)
		);
#endif

	// 1. Timer setting
	// Interval mode, External clk, Normal phase
	smtTIMERSetMode(timer, TIMER_SEL0);
	smtTIMERSetMode(timer, TIMER_SEL1);
	smtTIMERSetMode(timer, TIMER_SEL2);
	smtTIMERSetMode(timer, TIMER_SEL3);

	// Interval mode, Internal clk, Invert phase
	timer.clk = INTERNAL_CLK;
	timer.phase = INVERT_PHASE;
	smtTIMERSetMode(timer, TIMER_SEL4);
	smtTIMERSetMode(timer, TIMER_SEL5);
	smtTIMERSetMode(timer, TIMER_SEL6);
	smtTIMERSetMode(timer, TIMER_SEL7);

	// 2. Timer start
	smtTIMEROperation(timer, TIMER_SEL0);
	smtTIMEROperation(timer, TIMER_SEL1);
	smtTIMEROperation(timer, TIMER_SEL2);
	smtTIMEROperation(timer, TIMER_SEL3);
	smtTIMEROperation(timer, TIMER_SEL4);
	smtTIMEROperation(timer, TIMER_SEL5);
	smtTIMEROperation(timer, TIMER_SEL6);
	smtTIMEROperation(timer, TIMER_SEL7);

	// Register IRQ
	RequestIRQ(IRQ_TIMER0_TMC, ISRTIMER);
	RequestIRQ(IRQ_TIMER1_TMC, ISRTIMER);
	RequestIRQ(IRQ_TIMER2_TMC, ISRTIMER);
	RequestIRQ(IRQ_TIMER3_TMC, ISRTIMER);
	RequestIRQ(IRQ_TIMER4_TMC, ISRTIMER);
	RequestIRQ(IRQ_TIMER5_TMC, ISRTIMER);
	RequestIRQ(IRQ_TIMER6_TMC, ISRTIMER);
	RequestIRQ(IRQ_TIMER7_TMC, ISRTIMER);

	while(1)
	{
		smtUint32 flag = 1;
		for(count = 0; count < NUM_TIMER_TEST; count++)
		{
			if(timerIntCheck[count] == 0)
			{
				flag = 0;
				break;
			}
		}
		
		if(flag != 0)	// all interrupt detected
			break;
	}

	// Release IRQ
	ReleaseIRQ(IRQ_TIMER0_TMC);
	ReleaseIRQ(IRQ_TIMER1_TMC);
	ReleaseIRQ(IRQ_TIMER2_TMC);
	ReleaseIRQ(IRQ_TIMER3_TMC);
	ReleaseIRQ(IRQ_TIMER4_TMC);
	ReleaseIRQ(IRQ_TIMER5_TMC);
	ReleaseIRQ(IRQ_TIMER6_TMC);
	ReleaseIRQ(IRQ_TIMER7_TMC);
}

/*----------------------------------------------------------
	Function name	: TimerOverFlowTest()
	Prototype		: void TimerOverFlowTest()
	Return		: void
	Argument	:
	Comments	: For checking the interval mode in timer function
-----------------------------------------------------------*/
void TimerOverFlowTest(smtUint8 prescale, smtUint16 data)
{
	smtUint8 count;

	TIMER_STRUCT timer;

	timer.prescale		= prescale;
	timer.data		= data;
	timer.clk			= INTERNAL_CLK;
	timer.opMode		= TIMER_INTERVAL;
	timer.phase		= NORMAL_PHASE;
	timer.timerClear	= 1;		// Clearing the counter
	timer.timerEn		= 1;

	for(count = 0; count < NUM_TIMER_TEST; count++)
		timerOverInt[count] = 0;

	// 1. Timer setting
	// Interval mode, Internal clk, Normal phase
	smtTIMERSetMode(timer, TIMER_SEL0);
	smtTIMERSetMode(timer, TIMER_SEL1);
	smtTIMERSetMode(timer, TIMER_SEL2);
	smtTIMERSetMode(timer, TIMER_SEL3);
	smtTIMERSetMode(timer, TIMER_SEL4);
	smtTIMERSetMode(timer, TIMER_SEL5);
	smtTIMERSetMode(timer, TIMER_SEL6);
	smtTIMERSetMode(timer, TIMER_SEL7);

	// 2. Timer start
	smtTIMEROperation(timer, TIMER_SEL0);
	smtTIMEROperation(timer, TIMER_SEL1);
	smtTIMEROperation(timer, TIMER_SEL2);
	smtTIMEROperation(timer, TIMER_SEL3);
	smtTIMEROperation(timer, TIMER_SEL4);
	smtTIMEROperation(timer, TIMER_SEL5);
	smtTIMEROperation(timer, TIMER_SEL6);
	smtTIMEROperation(timer, TIMER_SEL7);

	// Register IRQ
	RequestIRQ(IRQ_TIMER0_TMC, ISRTIMER);
	RequestIRQ(IRQ_TIMER1_TMC, ISRTIMER);
	RequestIRQ(IRQ_TIMER2_TMC, ISRTIMER);
	RequestIRQ(IRQ_TIMER3_TMC, ISRTIMER);
	RequestIRQ(IRQ_TIMER4_TMC, ISRTIMER);
	RequestIRQ(IRQ_TIMER5_TMC, ISRTIMER);
	RequestIRQ(IRQ_TIMER6_TMC, ISRTIMER);
	RequestIRQ(IRQ_TIMER7_TMC, ISRTIMER);

	RequestIRQ(IRQ_TIMER0_TOF, ISRTIMER);
	RequestIRQ(IRQ_TIMER1_TOF, ISRTIMER);
	RequestIRQ(IRQ_TIMER2_TOF, ISRTIMER);
	RequestIRQ(IRQ_TIMER3_TOF, ISRTIMER);
	RequestIRQ(IRQ_TIMER4_TOF, ISRTIMER);
	RequestIRQ(IRQ_TIMER5_TOF, ISRTIMER);
	RequestIRQ(IRQ_TIMER6_TOF, ISRTIMER);
	RequestIRQ(IRQ_TIMER7_TOF, ISRTIMER);

	while(1)
	{
		smtUint32 flag = 1;
		for(count = 0; count < NUM_TIMER_TEST; count++)
		{
			if(timerOverInt[count] == 0)
			{
				flag = 0;
				break;
			}
		}
		
		if(flag != 0)	// all interrupt detected
			break;
	}

	// Release IRQ
	ReleaseIRQ(IRQ_TIMER0_TMC);
	ReleaseIRQ(IRQ_TIMER1_TMC);
	ReleaseIRQ(IRQ_TIMER2_TMC);
	ReleaseIRQ(IRQ_TIMER3_TMC);
	ReleaseIRQ(IRQ_TIMER4_TMC);
	ReleaseIRQ(IRQ_TIMER5_TMC);
	ReleaseIRQ(IRQ_TIMER6_TMC);
	ReleaseIRQ(IRQ_TIMER7_TMC);

	ReleaseIRQ(IRQ_TIMER0_TOF);
	ReleaseIRQ(IRQ_TIMER1_TOF);
	ReleaseIRQ(IRQ_TIMER2_TOF);
	ReleaseIRQ(IRQ_TIMER3_TOF);
	ReleaseIRQ(IRQ_TIMER4_TOF);
	ReleaseIRQ(IRQ_TIMER5_TOF);
	ReleaseIRQ(IRQ_TIMER6_TOF);
	ReleaseIRQ(IRQ_TIMER7_TOF);
}

/*----------------------------------------------------------
	Function name	: ISRTIMER()
	Prototype		: static void ISRTIMER(smtUint32 IRQ)
	Return		:
	Argument	:
	Comments	:
-----------------------------------------------------------*/
static void ISRTIMER(smtUint32 IRQ)
{
	if(IRQ < (IRQ_TIMER2_TMC+1))
		timerIntCheck[(IRQ-7)/2] += 1;
	else if(IRQ >= IRQ_TIMER3_TMC && IRQ < (IRQ_TIMER7_TMC+1))
		timerIntCheck[(IRQ -23)/2 + 3] += 1;

	AckIRQ(IRQ); // TIMER interrupt clear
}

/*----------------------------------------------------------
	Function name	: ISRTIMEROverFlow()
	Prototype		: static void ISRTIMEROverFlow(smtUint32 IRQ)
	Return		:
	Argument	:
	Comments	:
-----------------------------------------------------------*/
static void ISRTIMEROverFlow(smtUint32 IRQ)
{
	if(IRQ < (IRQ_TIMER2_TOF+1))
		timerOverInt[(IRQ-6)/2] += 1;
	else if(IRQ >= IRQ_TIMER3_TOF && IRQ < (IRQ_TIMER7_TOF+1))
		timerOverInt[(IRQ -22)/2 + 3] += 1;

	AckIRQ(IRQ); // TIMER over-flow interrupt clear
}

