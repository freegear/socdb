// timer.c
#include <intrpt.h>

#include "vauto.h"
#include "timer.h"
#include "uart.h"

#define DEBUG_IT		0

#if !defined(CLOCK_RATE)
#define CLOCK_RATE		12	// !!! IF YOU'RE NOT RUNNING AT 12MHZ CHANGE THIS !!!
#endif

typedef struct
	{
	BYTE	run:1,
			ext:1,
			spare:1,
			mxb:1,
			ret:1,
			pwm:1,
			enable:1,
			done:1;
	} TIMER_CTL_REG;

volatile BYTE			TIMER_COUNT_LO		@0x0260;
volatile BYTE			TIMER_COUNT_HI		@0x0261;
volatile TIMER_CTL_REG	TIMER_CTL			@0x0262;
volatile BYTE			TIMER_PRESCALE		@0x0263;
volatile BYTE			TIMER_MAXAL			@0x0264;
volatile BYTE			TIMER_MAXAH			@0x0265;
volatile BYTE			TIMER_MAXBL			@0x0266;
volatile BYTE			TIMER_MAXBH			@0x0267;

void interrupt InterruptTimer(void);


void TimerDisable()
{

	TIMER_CTL.run = 0;
	return;
}

volatile BOOL	bTimesUp;

void TimerWaitAMicroSecond(WORD wMicroSecond)
{
	ONION	oMicroSecond;

#if DEBUG_IT
puts("Timer waiting ");
putw(wMicroSecond);
putCrlf();
putFlush();
#endif

	oMicroSecond.w = wMicroSecond;
	bTimesUp = FALSE;
	Interrupt3 = (WORD)InterruptTimer;
	*(PBYTE)&TIMER_CTL = 0;		// clear everything
	TIMER_PRESCALE = CLOCK_RATE-1;

	TIMER_MAXAL = oMicroSecond.b.l;
	TIMER_MAXAH = oMicroSecond.b.h;
	TIMER_CTL.done = 1;		// clear done bit
	TIMER_CTL.enable = 1;	// enable timer
	TIMER_CTL.run = 1;		// go do it

	while (!TIMER_CTL.done)
		{
		}

	TIMER_CTL.enable = 0;	// disable

#if DEBUG_IT
puts("Timer done\r\n");
putFlush();
#endif

	return;
}

#pragma interrupt_level 1
void interrupt InterruptTimer()
{

	TIMER_CTL.enable = 0;	// disable
	bTimesUp = TRUE;
}

