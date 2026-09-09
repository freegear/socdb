/***************************************************************************
 * Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
 * Copyright © ARM Limited 1998, 1999.  All rights reserved.
 ***************************************************************************/
/*****************************************************************************
 *
 *  This file contains all the drivers etc. to interface with the timers on
 *  a ARM target. The aim of these routines is to provide a standard
 *  mechanism to access the timer(s) hiding any target-specific code.
 *
 *	$Id: timer.c,v 1.3 1999/08/02 15:21:14 mquinn Exp $
 *
 *****************************************************************************/

#include	"uhal.h" 
#include	"except_h.h" 
#include	"errno.h"



unsigned int		uHALiv_TimerVectors[MAX_TIMER + 1] = TIMER_VECTORS ;
struct uHALis_Timer	uHALiv_TimerStatus[MAX_TIMER + 1] ;


/* This routine returns the type of the given timer
 *
 * Returns:	-1 if timer is out of range
 *		else, T_FREE, T_ONESHOT, T_INTERVAL
 */
int uHALr_GetTimerState(unsigned int timer)
{
    if (timer == 0 || timer > MAX_TIMER)
	return -1 ;

    return (uHALiv_TimerStatus[timer].state) ;
}

/* This routine sets the type of the given timer
 *
 * Returns:	-1 if timer is out of range
 *		OK otherwise
 */
int uHALr_SetTimerState(unsigned int timer, enum uHALe_TimerState state)
{
    if (timer == 0 || timer > MAX_TIMER)
	return -1 ;

    uHALiv_TimerStatus[timer].state = state ;

    return OK;
}


/* This routine returns the interval for the given timer (NOT the current
 * hardware timer count).
 *
 * Returns:	-1 if timer is out of range
 *		value otherwise
 */
int uHALr_GetTimerInterval(unsigned int timer)
{
    if (timer == 0 || timer > MAX_TIMER)
	return -1 ;

    return (uHALiv_TimerStatus[timer].period) ;
}


/* This routine stores the interval for the given timer. NOTE: The actual
 * timer count is not altered.
 *
 * Returns:	-1 if timer is out of range
 *		OK otherwise
 */
int uHALr_SetTimerInterval(unsigned int timer, unsigned int interval)
{
struct uHALis_Timer *action ;

#ifdef DEBUG
    uHALr_printf("uHALr_SetTimerInterval(%d, %d)\n", timer, interval) ;
#endif

    if (timer == 0 || timer > MAX_TIMER)
	return -1 ;

    if (interval > MAX_PERIOD)
	return -1 ;

    action = &uHALiv_TimerStatus[timer] ;
    action->period = interval ;

    /*
    ** Force a H/W interval timer to be re-enabled next
    ** time it goes off so that it picks up this change.
    */
    action->hw_interval = 0; 

    return (OK) ;
}


/* This routine stops the specified timer hardware. */
void uHALir_DisableTimer(unsigned int timer)
{
struct uHALis_Timer *action ;
unsigned int	     mode ;

    if (timer == 0 || timer > MAX_TIMER)
	return ;

    action = &uHALiv_TimerStatus[timer] ;
    action->state = T_FREE ;	/* Free the timer */

    /* disable IRQs and FIQs */
    mode = uHALir_ReadMode() ;
    uHALir_WriteMode(mode | NoFIQ | NoIRQ) ;

    /* call the platform specific timer code */
    uHALir_PlatformDisableTimer(timer) ;

    /* restore the previous mode */
    uHALir_WriteMode(mode) ;
}


/* Start-up routine to initialise the timers to a known state */
void uHALr_InitTimers(void)
{
unsigned int	i;

#ifdef DEBUG
    uHALr_printf("uHALr_InitTimers()\n") ;
#endif

    for (i = 1; i <= MAX_TIMER; i++) {
#if defined(SEMIHOSTED) && defined(HOST_TIMER)
      /* Don't stomp on the debugger's timer */
      if (i == HOST_TIMER) {
	/* Block access to this timer */
	uHALr_SetTimerState(i, T_LOCKED) ;
	continue;	/* Next timer */
      }
      else
#endif
	/* If not DEMON, disable all timers */
	uHALir_DisableTimer(i) ;
      /* Default time period is 1 mS */
      uHALr_SetTimerInterval(i, mSEC_1) ;
    }

}


/* Routine to return the Interrupt number for the given timer.
 *
 * Returns -1 if invalid timer, else IRQ number.
 */
int uHALir_GetTimerInterrupt(unsigned int timer)
{
#ifdef DEBUG
    uHALr_printf("uHALir_GetTimerInterrupt(%d)\n", timer) ;
#endif

    if (timer == 0 || timer > MAX_TIMER)
	return -1 ;

    return (uHALiv_TimerVectors[timer]) ;
}


/* This routine starts the specified timer hardware. */
void uHALr_EnableTimer(unsigned int timer)
{
unsigned int	mode ;

#ifdef DEBUG
	uHALr_printf("uHALr_EnableTimer(%d)\n", timer) ;
#endif

    if (timer == 0 || timer > MAX_TIMER)
	   return ;

    /* disable IRQs and FIQs */
    mode = uHALir_ReadMode() ;
    uHALir_WriteMode(mode | NoFIQ | NoIRQ) ;

    /* call the platform specific code */
    uHALir_PlatformEnableTimer(timer) ;

    /* restore the mode */
    uHALir_WriteMode(mode) ;
}


/* Routine to start the specified timer & enable the interrupt */
void uHALr_InstallTimer(unsigned int timer)
{
int	intNum = uHALir_GetTimerInterrupt(timer) ;

    if (intNum != -1) {
	/* Start the timer ticking */
	uHALr_EnableTimer(timer) ;
	/* Install timer interrupt routine */
	uHALr_EnableInterrupt((unsigned int) intNum) ;    
    }
}


/* Routine to return the number of counters available on this platform */
unsigned int uHALir_CountTimers(void)
{
    return(MAX_TIMER);
}


/* Routine to disable a timer and free-up the associated IRQ */
int uHALr_FreeTimer(unsigned int timer)
{
unsigned int	i ;

    if (timer == 0 || timer > MAX_TIMER)
	return -1 ;

    uHALir_DisableTimer(timer) ;	/* Stop the timer first */

    i = uHALiv_TimerVectors[timer] ;	/* then release the IRQ */
    if (uHALr_FreeInterrupt(i) != OK)
	return -1 ;

    return (OK) ;
}

/* High level interrupt routine for Timers. Determines which timer caused the
 * interrupt and calls the appropriate handler when the interval has expired.
 * If only a one-shot timer, the timer is then disabled & resources released.
 */
void uHALir_TimeHandler(unsigned int intNum)
{
unsigned int	     timer = OS_TIMER ;
struct uHALis_Timer *action = &uHALiv_TimerStatus[timer] ;

    /* Check the OS timer first */
    if (action->irq != intNum) {
	/* Find which other timer */
	timer = MAX_TIMER ;
	action = &uHALiv_TimerStatus[timer] ;
	for (; timer != 0; timer--, action--)
	    if (action->irq == intNum)
		break ;
    }

    if (timer == 0)
	return ;	/* Unknown timer */

    /* Simple timer routine, just uses timer2 & each interrupt is a tick. */
    action->handler(intNum) ;

    /*
    ** If this is a ONESHOT then free the timer.
    **
    ** For Interval timers either re-enable them or just clear
    ** the interrupt if the H/W support interval (periodic) timers.
    */
    // uHALr_FreeTimer(timer);
    /*
    if ( action->state != T_ONESHOT )	{
    	if ( !(action->hw_interval) )	{
    		// uHALr_EnableTimer(timer);
    	}
    	else if ( action->ClearInterruptRtn != NULL )	{
    		action->ClearInterruptRtn(timer);
    	}
    	else	{
    	}
    }
    else	{
    	uHALr_FreeTimer(timer);
    }
    */
    
    if (action->state == T_ONESHOT)	{
		uHALr_FreeTimer(timer) ;		
	}
    else if (!action->hw_interval)	{
	    uHALr_EnableTimer(timer);		
	}
	else if (action->ClearInterruptRtn != NULL)	{
	    action->ClearInterruptRtn(timer);	
	}
	
	/* All done, free resources */
	/* Restart timer if required */
	/* Clear the interrupt */
	return;
}

/*
 * Routine to initialise install requested timer. Stops the timer.
 */
int uHALir_InitTimer(unsigned int timer,
			PrHandler handler, const unsigned char *devname)
{
struct uHALis_Timer *action ;
unsigned int	     i ;

    i = uHALiv_TimerVectors[timer] ;

    if (uHALr_RequestInterrupt(i, uHALir_TimeHandler, devname) != OK)
	return -1 ;

    uHALir_DisableTimer(timer) ;
    action = &uHALiv_TimerStatus[timer] ;
    action->state = T_INTERVAL ;	/* Default to interval timer */
    action->handler = handler ;
    action->name = devname ;
    action->irq = i ;		/* IRQ number */
    action->next = 0 ;
    action->hw_interval = 0;	/* Assume H/W does not support interval timers */
    action->ClearInterruptRtn = NULL; /* Set up by platform dependant enable code */

    return timer ;
}

/*
 * Routine to check and install requested timer. Stops the timer if the IRQ
 * can be installed.
 */
int uHALr_RequestTimer(PrHandler handler, const unsigned char *devname)
{
unsigned int	timer ;

    /* Find a free timer */
    for (timer = MAX_TIMER; timer > 0; timer--)
    if (uHALiv_TimerStatus[timer].state == T_FREE)
	    break ;

    if (timer == 0)
	return -1 ;

    return (uHALir_InitTimer(timer, handler, devname)) ;
}


/* Routine to return the number of the system timer */
unsigned int uHALir_GetSystemTimer(void)
{
    return(OS_TIMER);
}


int uHALr_RequestSystemTimer(PrHandler handler, const unsigned char *devname)
{
    if (uHALiv_TimerStatus[OS_TIMER].state != T_FREE)
	return -1 ;

    return (uHALir_InitTimer(OS_TIMER, handler, devname)) ;
}

