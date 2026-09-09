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
 * File:     timer.h,v
 * Revision: 1.12
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : timer.h.rca
 *  File Revision          : 1.2
 * 
 *  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
 *  ----------------------------------------
 *
 * Private header for ADK Timers
 */

#ifndef TIMER_H
#define TIMER_H

#ifdef __cplusplus
extern "C" { /* allow C++ to use these headers */
#endif /* __cplusplus */



/*
 * Memory mapped Timer registers
 */
typedef volatile struct TIMER_xRegisters
{
    UWORD32 Load;
    UWORD32 Value;
    UWORD32 Control;
    UWORD32 Clear;
#if defined(apTIMER_VERSION) && apTIMER_VERSION == apTIMER_ADK
    UWORD32 RawIntStatus;
    UWORD32 MaskIntStatus;
    UWORD32 BackgroundLoad;
#endif
}
TIMER_sRegisters;

/*
 * Bit definitions for control register
 */
#define bwTIMER_ENABLE           1    /* Enable */
#define bwTIMER_MODE             1    /* eMode */
#define bwTIMER_INT_ENABLE       1    /* Interrupt Enable */
#define bwTIMER_RESERVED         1    /* Reserved bit, do not modify */
#define bwTIMER_PRESCALE         2    /* ePrescale */
#define bwTIMER_SIZE             1    /* Selects 16/32 bit counter operation */
#define bwTIMER_ONE_SHOT         1    /* Selects one-shot or wrapping counter mode */

#define bsTIMER_ENABLE           7
#define bsTIMER_MODE             6
#define bsTIMER_INT_ENABLE       5
#define bsTIMER_RESERVED         4
#define bsTIMER_PRESCALE         2
#define bsTIMER_SIZE             1
#define bsTIMER_ONE_SHOT         0

/*
 * Bit definitions for timer interrupt
 */
#define bwTIMER_INTERRUPT        1

#define bsTIMER_INTERRUPT        0


/* 
 * Description:
 * Timer enabled status
 */
typedef enum TIMER_xEnable
{
    TIMER_DISABLED,         // Timer disabled
    TIMER_ENABLED           // Timer enabled
}
TIMER_eEnable;

/* 
 * Description: 
 * This sets the hardware modes that are built into the timers,
 */
typedef enum TIMER_xMode
{
    TIMER_FREE_RUNNING,     // Timer free running
    TIMER_PERIODIC          // Timer is in periodic mode
}
TIMER_eMode;

/* 
 * Description:
 * Timer interrupt enabled status
 */
typedef enum TIMER_xIntEnable
{
    TIMER_INT_DISABLED,     // Timer interrupt disabled
    TIMER_INT_ENABLED       // Timer interrupt enabled
}
TIMER_eIntEnable;

/*
 * Description:
 * Timer interval descriptions when in sqaure wave mode
 */

typedef enum TIMER_xSquareInterval
{
    TIMER_HI,
    TIMER_LO
}
TIMER_eSquareInterval;

/*
 * Description:
 * Used to tell TIMER_CalculateTime whether the interval we are calculating
 * is a normal or high interval or a lo interval so that it can set
 * the relevant entries in the relevant structures.
 *
 */
typedef enum TIMER_xInterval
{
    TIMER_STANDARD_INTERVAL,
    TIMER_LO_INTERVAL
}
TIMER_eInterval;

/*
 * Description:
 * Used to set the status of the timer, whether it is reserved or free.
 *
 */
typedef enum TIMER_xStatus
{
    TIMER_FREE,
    TIMER_RESERVED
}
TIMER_eStatus;

/*
 * Parameters for State structure:
 * pBaseAddress      - Base address of the registers for the timer
 * rHandler          - Address of callback
 * eStatus           - Stores whether the timer is reserved or free
 * eCurrentInterval  - Stores the interval currently being timed, High or Lo.
 *                      If in non square mode always set to HIGH
 * eMode             - Sets the mode of the timer periodic, wraparound,
 *                      single shot or square wave
 * HandlerParam      - The parameters that are passed to the callback
 * ClockFrequency    - Clock frequency of the timer
 * RepeatCount       - How many times to repeat the interval
 * IntervalLoadValue - The corresponding load value in ticks to load
 *                     into the timer for given interval.Saves having to re-calculate
 * eIntervalPrescale - Prescale setting set on the timer
 * ExtraLoad         - If interval is too big to fit into 16bits need to reload
 *                     value this number of times. This is used also,
 *                     to show that the extra is needed
 * ExtraCount        - This keeps track of how many extra loads are needed
 * 
 * Lo Setting        - Same as above interval when in Square wave mode
 *
 */
 
typedef volatile struct TIMER_xStateStruct
{
    TIMER_sRegisters         *pBaseAddress;
    apTIMER_rCallBackHandler rHandler;
    TIMER_eStatus            eStatus;
    TIMER_eSquareInterval    eCurrentInterval;
    apTIMER_eMode            eMode;
    apTIMER_eSize            eSize;
    UWORD32                  HandlerParam;
    UWORD32                  ClockFrequency;
    UWORD32                  RepeatCount;
    UWORD32                  IntervalLoadValue;
    apTIMER_ePrescale        eIntervalPreScale;
    UWORD32                  ExtraSaveCount;
    UWORD32                  ExtraCount;   
    UWORD32                  LoIntervalLoadValue;
    apTIMER_ePrescale        eLoIntervalPreScale;
    UWORD32                  ExtraLoSaveCount;
    UWORD32                  ExtraLoCount;

}
TIMER_sStateStruct;


/*
 * Description:
 * This function calculates the interval in ticks needed to be loaded
 * given a time in seconds for a 32 bit counter
 * 
 * Inputs:
 * oId          - The timer number that is being used, 
 *                or a void pointer if in no_static_state mode
 * Interval     - Time in the units specified in units.
 *                If frequency is being set then Interval is the number
 *                of ticks needed for that frequency.
 * IntervalType - If we are calculating an interval then this sets whether it is
 *                a LO_INTERVAL for square_wave_mode.
 */
PRIVATE void TIMER_CalculateTime32(apOS_TIMER_oId oId,
                                   long long Interval,
                                   TIMER_eInterval IntervalType);
                                   
/*
 * Description:
 * This function calculates the interval in ticks needed to be loaded
 * given a time in seconds for a 16 bit counter
 * 
 * Inputs:
 * oId          - The timer number that is being used, 
 *                or a void pointer if in no_static_state mode
 * Interval     - Time in the units specified in units.
 *                If frequency is being set then Interval is the number
 *                of ticks needed for that frequency.
 * IntervalType - If we are calculating an interval then this sets whether it is
 *                a LO_INTERVAL for square_wave_mode
 */

PRIVATE void TIMER_CalculateTime16(apOS_TIMER_oId oId,
                                   long long Interval,
                                   TIMER_eInterval IntervalType);

/*
 * Description:
 * This function converts the interval in any of the supported units 
 * to ticks per second. 
 * 
 * Inputs:
 * Interval     - Time(ticks) in the units specified.
 * Units        - Units of the requiredinterval
 *
 * Return Value:
 * Interval in ticks per second
 */
PRIVATE long long TIMER_ConvertUnits(long long Interval,
                                     apTIMER_eUnits eUnits);
                                     


#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif /* __cplusplus */

#endif
