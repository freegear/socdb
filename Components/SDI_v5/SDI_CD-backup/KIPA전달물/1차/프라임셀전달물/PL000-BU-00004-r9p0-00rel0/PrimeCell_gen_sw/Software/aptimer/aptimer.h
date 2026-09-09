/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2000,2001 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     aptimer.h,v
 * Revision: 1.29
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : aptimer.h.rca
 *  File Revision          : 1.2
 * 
 *  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
 *  ----------------------------------------
 *
 * Timer Driver Functions, Public API.
 *
 */

#ifndef APTIMER_H
#define APTIMER_H

#ifdef  __cplusplus
extern "C" { /* allow C++ to use these headers */
#endif /* __cplusplus */

/* 
 * Description:
 * Used to define timer variant. 
 * If apTIMER_VERSION defined in applatfm.h then one of these
 * values should be specified. 
 */
#define apTIMER_AP  0x00
#define apTIMER_ADK 0x04

/*=======================================================================*/
/* Type definitions - used when passing parameters to the API functions. */
/*=======================================================================*/

/* 
 * Description:
 * If used as a repeat value as a parameter to apTIMER_IntervalSet, this 
 * indicates that the number of times to repeat the operation is infinite. 
 */
#define apTIMER_REPEAT_FOREVER 0xFFFFFFFF


/* 
 * Description:
 * Enumerates possible timer running modes. This defines where the value
 * which is loaded into the timer when it wraps around (reaches zero)
 * comes from.
 * Periodic is one of the hardware modes,the other modes are created by the driver
 * Periodic must be set to 1 as it is used by the driver to set the mode hardware bit
 * Free running is not used as WRAPAROUND, which is free running with a repeat count,
 * uses the periodic mode in hardware to control the timer.
 */
typedef enum apTIMER_xMode
{  
  apTIMER_MODE_SINGLE_SHOT,    /* The timer generates an interrupt once 
                                */  
  apTIMER_MODE_PERIODIC,       /* The timer generates an interrupt at a 
                                * constant interval, reloading the original value
                                */  
  apTIMER_MODE_WRAPAROUND,     /* The timer generates an interrupt at a 
                                * constant interval, reloading the original value
                                * for a given number of repeat cycles then loads the
                                * maximum count value and free runs forever.
                                */
  apTIMER_MODE_SQUARE_WAVE     /* The timer generates interrupts at an alternating low
                                * or high interval for a given number of repeat cycles */
}
apTIMER_eMode;


/* 
 * Description:
 * Possible timer prescale settings. Defines what value the input clock to
 * the timer block is divided by before clocking the actual timer counter.
 */
typedef enum apTIMER_xPrescale
{
  apTIMER_DIVIDE_BY_1,       /* ePrescale divide by 1 */
  apTIMER_DIVIDE_BY_16,      /* ePrescale divide by 16 */
  apTIMER_DIVIDE_BY_256      /* ePrescale divide by 256 */
}
apTIMER_ePrescale;

/*
 * Description:
 * Enum used to set the size of the timer.
 *
 */
typedef enum apTIMER_xSize
{
    apTIMER_16_BIT,         /* Default size */
    apTIMER_32_BIT          /* For use with 32bit ADK timer */
}
apTIMER_eSize;


/*
 * Description:
 * Enum used to set whether the timer is started when the interval is set
 * or whether the interval is just set and the timer not started
 */
typedef enum apTIMER_xStart
{
  apTIMER_SET_AND_START,    
  apTIMER_SET_AND_NO_START   
}
apTIMER_eStart;


/*
 * Description:
 * Used to set whether you want the timer you are initialising
 * to be reserved for you so that nobody else can use it.
 */
typedef enum apTIMER_xReserve
{
  apTIMER_RESERVE_ON_INIT,
  apTIMER_NO_RESERVE_ON_INIT

}apTIMER_eReserve;


/*
 * Description:
 * Used by apTIMER_IntervalSet to specify timer interval in alternative units
 * to default of Seconds
 */
typedef enum apTIMER_xUnits
{
  apTIMER_NANOSECONDS,
  apTIMER_MICROSECONDS,
  apTIMER_MILLISECONDS,
  apTIMER_SECONDS
}apTIMER_eUnits;


/*
 * Description:
 * This specifies the error condition code returned passed to the
 * interrupt Handler callback function
 */
typedef enum apTIMER_xCallbackCondition
{
    apTIMER_CONTINUE,    /* The timer will continue with next period */
    apTIMER_END,         /* The timer will stop */
    apTIMER_LOW_END,     /* The timer has completed lo period in square wave mode */
    apTIMER_HIGH_END     /* The timer has completed high period in square wave mode */
} apTIMER_eCallbackCondition;


/*
 * Description:
 * This is the initial data block that should be passed in when the timer is initialized.
 * It sets the Clock frequency of the timer, the prescale of the timer and whether
 * the timer should be reserved so that nobody else can initialize it.
 *
 */
typedef struct apTIMER_xInitialData
{
    UWORD32                Clock;
    apTIMER_eReserve       eReserve;
    apTIMER_eSize          eSize;
}
apTIMER_sInitialData;


/*
 * Description:
 * The interval data block is passed into interval set to describe
 * the type of interval you want to set. The mode is passed,
 * the interval is passed, the units of the interval are passed.
 * then if the mode is set to square wave the lo interval and
 * uits are passed. Finally the repeat count is passed.
 * For square wave this is the number of time to repeat both lo
 * and high intervals
 */
typedef struct apTIMER_xIntervalData
{
    apTIMER_eMode               eMode;
    UWORD32                     Interval;
    apTIMER_eUnits              eIntervalUnits;
    UWORD32                     LoInterval;
    apTIMER_eUnits              eLoIntervalUnits;
    UWORD32                     RepeatCount;
    apTIMER_eStart              eStart;
}apTIMER_sIntervalData;


/* Description:
 * Timer interrupt handler function.
 *
 * Implementation:
 * Used by various routines to define a user handler to be called
 * every time the timer interrupt occurs.
 *
 * Inputs:
 * Param    -User specified parameter to be passed to callback routine
 *           Normally used for ID of peripheral using timer.
 * eCondition - Condition code returned from interrupt handler.
 */
typedef void (*apTIMER_rCallBackHandler) (UWORD32 Param,
                                          apTIMER_eCallbackCondition eCondition);

/*=======================================================================*/
/* Main Public functions - defines the API to the drivers.               */
/*=======================================================================*/

/*
 * Description:
 * Finds the amount of space required for driver state data
 *
 * Implementation:
 * This function is required if apOS_NO_STATIC_STATE is defined as TRUE
 * as it will retrieve the size required for storage of the driver
 * state data
 *
 * Inputs:
 * None
 * 
 * Outputs:
 * None
 *
 * Return Value:
 * size (in bytes) required.
 */
PUBLIC UWORD32 apTIMER_StateSizeGet(void);


/*
 * Description:
 * Initialises the timer specified. Call this function once for
 * each timer in the system before using any of the timer driver functions.
 *
 * Implementation:
 * This ensures that the timer specified is initialised, and that all system
 * specific information required by the drivers has been passed.
 *
 * It also registers the interrupt handler for this timer with the
 * interrupt module. The interrupt handler routine does the following
 * when an interrupt occurs:
 * + Check for extended time and decrement the extended time counter if
 *   necessary (extended timer is caused by a requested interval larger
 *   than the maximum allowed by the timer hardware, so is supported using
 *   a software counter as well).
 * + Clears the interrupt by calling apTIMER_Clear()
 * + Call the user registered event handler routine if there is one, and if the
 *   event it was registered for has occured.
 * + If there was a repeat count for the event (set by apTIMER_SetInterval) then
 *   decrements the repeat count. If it decrements it to zero then it disables
 *   the current timer and its interrupt (at the interrupt mask).
 *
 * Inputs:
 * oId - Timer to initialize.
 * eBase - base address of timer registers.
 * Interrupts - Number of interrupt events recognised by handler - pass in 1.
 * pSources - Pointer to the one interrupt event.
 * pInitial - Pointer to block of initial data containing Clock Frequency,
 *            Counter size and whether or not to reserve timer
 *
 */
PUBLIC void apTIMER_Initialize (apOS_TIMER_oId oId,
                                apOS_System_eBaseAddress eBase,
                                UWORD32 Interrupts,
                                CONST apOS_INT_oInterruptSource * pSources,
                                apTIMER_sInitialData *pInitial);


/*
 * Description:
 * Sets the frequency of the specified timer to call the
 * registered user event handler <Frequency> times a second.
 * Will continue until the timer is disabled, or a new interval 
 * or frequency is set.
 * This call will supercede any previous intervals or frequencies set
 * for this particular timer.
 *
 * Inputs:
 * oId - specifies which timer to set.
 * rHandler - User defined routine to be called by interrupt handler.
 * Frequency - Timer frequency in Hz. Must be greater than zero.
 *
 * Return Value:
 * None
 *
 */
PUBLIC void apTIMER_FrequencySet (apOS_TIMER_oId oId,
                                  apTIMER_rCallBackHandler rHandler,
                                  UWORD32 HandlerParam, 
                                  double Frequency);
                                    
/*
 * Description:
 * Gets the frequency of the specified timer.
 *
 * Implementation:
 * This is the compliment to apTIMER_FrequencySet, except that the
 * actual set frequency (to the timer's best resolution) is returned
 *
 * Inputs:
 * oId - specifies which timer to use.
 *
 * Return Value:
 * The actual frequency set for the timer
 *
 */
PUBLIC double apTIMER_FrequencyGet (apOS_TIMER_oId oId);

/*
 * Description:
 * Set the timer to produce an event 
 *
 * Implementation:
 * Disables the timer.
 * Sets the timer to the periodic mode. 
 * Calculates the number of clock ticks required from the interval specified, 
 * and sets appropriate timer pre-scale and load values to achieve this
 * interval as accurately as possible.
 * 
 *
 * Note that if the timer is 16 bits and a typical value for the external
 * timer clock is 3.6864 MHz, then the maximum basic interval possible,
 * with divide-by-256 prescale, is 4.55 seconds.  However, a secondary 
 * software count has been implemented to allow extended timing of many days.
 * However, for times of longer than a minute it is recommended that the 
 * alarms from the Real Time Clock peripheral are used instead of a timer.
 * These will use less power, and will not be affected by the user powering 
 * down the system in the meantime.
 *
 * Set the repeat count for the numbre of times the interval is to be repeated.
 *
 * Add the handler.
 *
 * Re-enables the timer.
 * 
 * Note that when the timer goes off, the default interrupt handler
 * then disables the timer.
 * 
 * 
 * Inputs:
 * oId          - Specifies which timer to set.
 * rHandler     - User defined routine to be called by interrupt handler.
 * HandlerParam - Parameter to be passed to the user callback routine
 * pIntervalData - Information about the interval to set
 * Status        - Whether to set the interval ticking or not
 */
PUBLIC void apTIMER_IntervalSet (apOS_TIMER_oId  oId,
                                 apTIMER_rCallBackHandler rHandler, 
                                 UWORD32 HandlerParam, 
                                 apTIMER_sIntervalData *pIntervalData);


/*=======================================================================*/
/* Supporting Public functions - lower level API to the drivers.         */
/*=======================================================================*/

/*
 * Description:
 * Registers the user defined handler function as the function to be called 
 * when a pre-programmed timer event occurs.
 *
 * Implementation:
 * Stores the handler function pointer for use by the interrupt handler.
 * This action overwrites any previously registered function pointer.
 * Note, the registered user handler is not necessarily called every
 * time a processor timer interrupt occurs. In the case where the programmed
 * interval is longer than the maximum timer interval, multiple interrupts
 * may occur before the programmed event occurs.
 *
 * Inputs:
 * oId    - specifies which timer to set.
 * HandlerParam - Parameter to be passed to the user callback routine
 * rHandler  - User defined routine to be called by interrupt handler;
 *            setting it to aNULL will clear the callback.
 */
PUBLIC void apTIMER_CallbackSet (apOS_TIMER_oId oId,
                                 apTIMER_rCallBackHandler rHandler);


/*
 * Description:
 * Enables the specified timer.
 *
 * Implementation:
 * Enables the timer by writing to the timer control register.
 * 
 * Inputs:
 * oId - specifies which timer to enable.
 *
 */
PUBLIC void apTIMER_Start (apOS_TIMER_oId oId);


/*
 * Description:
 * Disables the specified timer.
 *
 * Implementation:
 * Disables the timer by writing to the timer control register.
 * 
 * Inputs:
 * oId - specifies which timer to disable.
 *
 */
PUBLIC void apTIMER_Stop (apOS_TIMER_oId oId);


/*
 * Description:
 * Clears the interrupt for the specified timer.
 *
 * Implementation:
 * Writes a value to the "Clear" hardware register.
 * 
 * Inputs:
 * oId - specifies which timer to set.
 *
 */
PUBLIC void apTIMER_Clear (apOS_TIMER_oId oId);


/*
 * Description:
 * Used to reserve the timer so that nobody else can come along
 * and initialize it after you already have
 * NOTE: Reservation code assumes that the code is not going to be maliscious
 *
 * Return Value:
 * apERR_NONE - If reserve has been set
 * apERR_BUSY - If already reserved or currently enabled
 * 
 */
PUBLIC apError apTIMER_SetReserve (apOS_TIMER_oId oId);


/*
 * Description:
 * Function to free the timer so that it is no longer reserved.
 * NOTE: assumes anyone who calls function is allowed to free the timer
 *
 * Return Value:
 * apERR_NONE - If free has been set
 * apERR_BUSY - If currently enabled
 * 
 */
PUBLIC apError apTIMER_SetFree (apOS_TIMER_oId oId);


/*
 * Description:
 * Function to check status of a timer.
 *
 * Return Value:
 * apERR_NONE - If free
 * apERR_BUSY - If reserved or currently enabled
 * 
 */
PUBLIC apError apTIMER_CheckStatus (apOS_TIMER_oId oId);


/*
 * Description:
 * Reads the current timer counter value.
 *
 * Implementation:
 * Reads the timer value hardware register, and returns the 32-bit 
 * value (for 16-bit timers the top 16-bits are returned as zero).
 * 
 * Inputs:
 * oId - specifies which timer to set.
 *
 * Return Value:
 * Current timer value.
 * 
 *
 */
PUBLIC UWORD32 apTIMER_ValueGet (apOS_TIMER_oId oId);


/*
 * Description:
 * Sets a new timer counter interval.
 *
 * Implementation:
 * Sets the timer load hardware register 
 * For 16-bit timers the top 16-bits must be set to zero.
 * 
 * Inputs:
 * oId - specifies which timer to set.
 * Interval - new timer interval
 *
 * Return Value:
 * None
 * 
 *
 */
PUBLIC void apTIMER_Load (apOS_TIMER_oId oId, UWORD32 Interval);

/*
 * Description:
 * For ADK timer only
 * Sets a new timer counter interval.
 *
 * Implementation:
 * Sets the timer background load hardware register 
 * 
 * Inputs:
 * oId - specifies which timer to set.
 * Interval - new timer interval
 *
 * Return Value:
 * None
 * 
 *
 */
PUBLIC void apTIMER_LoadBackground (apOS_TIMER_oId oId, UWORD32 Interval);


/*
 * Description:
 * Reads the current timer prescale value.
 *
 * Implementation:
 * Reads the currently set prescale value from the timer control 
 * hardware register. The prescale value is the value by which the clock 
 * into the timer hardware block is divided down by before being
 * used to clock the timer counters.
 * 
 * Inputs:
 * oId - specifies which timer to read
 *
 * Return Value:
 * Current timer prescale value
 * + apTIMER_DIVIDE_BY_1
 * + apTIMER_DIVIDE_BY_16 
 * + apTIMER_DIVIDE_BY_256
 * 
 */
PUBLIC apTIMER_ePrescale apTIMER_PrescaleGet (apOS_TIMER_oId oId);


/*
 * Description:
 * Sets a new timer prescale value.
 *
 * Implementation:
 * Sets the prescale value in the timer control hardware register.
 * The prescale value is the value by which the clock 
 * into the timer hardware block is divided down by before being
 * used to clock the timer counters.
 * 
 * Inputs:
 * oId - specifies which timer to set
 * ePrescale -  New timer prescale value
 *                 + apTIMER_DIVIDE_BY_1
 *                 + apTIMER_DIVIDE_BY_16 
 *                 + apTIMER_DIVIDE_BY_256
 *
 * Return Value:
 * None
 */
PUBLIC void apTIMER_PrescaleSet (apOS_TIMER_oId oId, apTIMER_ePrescale ePrescale);


/*
 * Description:
 * Sets a new mode for the timer.
 *
 * Inputs:
 * oId - specifies which timer to set
 * eMode - specifies the mode to be set
 *
 * Return Value:
 * apERR_NONE - if mode set
 * apERR_UNSUPPORTED - if mode not supported
 *                     Square wave mode not supported by this low level function.
 */
PUBLIC apError apTIMER_ModeSet (apOS_TIMER_oId oId, apTIMER_eMode eMode);


/*
 * Description:
 * This is the raw interrupt handler for the module, to be called directly
 * from the interrupt vector
 *
 * Note:
 * NOT FOR GENERAL USE.  This routine should only be executed as a branch from the IRQ vector
 *
 * Inputs:
 * none
 *
 * Outputs:
 * none
 *
 * Return Value:
 * none
 */
PUBLIC IRQ void apTIMER_RawISR(void);


/*
 * Description:
 * This is the standard interrupt handler for the module
 *
 * Note:
 * NOT FOR GENERAL USE.  This routine should only be called by an interrupt dispatcher
 *
 * Inputs:
 * oInterruptId - the ID of the interrupt
 * DeviceId - Identifier for the instance of the driver
 *
 * Outputs:
 * none
 *
 * Return Value:
 * none
 */
PUBLIC void apTIMER_IntHandler(CONST apOS_INT_oInterruptSource oInterruptId, UWORD32 DeviceId);



#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif  /* __cplusplus */

#endif // APTIMER_H
