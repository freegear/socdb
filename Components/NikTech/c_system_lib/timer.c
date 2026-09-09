#include <manik_system.h>
#include <signal.h>
#include <sys/time.h>

static unsigned int trval;

/* timer - isr called from the monitor module */
/* note should not change the PSW directly here
   since it will be over written by the caller . Change
   the values in register buffer passed by the caller */
void __timer_isr__(int *registers)
{
	
	registers[PSW] |= TE_FLAG;
	raise(SIGALRM);
	TIMER_SET(trval);
}

/* setitimer - should not be called from a interrupt context */
int setitimer(int which, const struct itimerval *ival, struct itimerval *oval)
{
	static struct itimerval citimer;
	
	if (which != ITIMER_REAL) return -1;
	if (oval) *oval = citimer;
	citimer = *ival;	
	trval = TICKS_PER_SEC*citimer.it_interval.tv_sec;
	trval += (TICKS_PER_SEC/1000000)*citimer.it_interval.tv_usec;

	/* setup the timer ISR */
	register_isr(TIMER_IRQ,__timer_isr__,0);/* defined in manik_system.h */
	
	/* start the timer */
	TIMER_SET(trval);
	TIMER_IRQ_START(); 	      
}


