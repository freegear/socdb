/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2000,2001,2002 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     os.c,v
 * Revision: 1.53
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : os.c.rca
 *  File Revision          : 1.11
 * 
 *  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
 *  ----------------------------------------
 *
 * Example direct mappings of OS veneer functions to the
 * supplied interrupt (INT/VIC) and timer (TIMER) module
 * functions. 
 *
 */

#include "../apcommon/aptypes.h"
#include "../apos/apos.h"
#include "../apcommon/cmacros.h"
#include "../apos/apintcfg.h"
#include "applatfm.h"

/*if built with the C Library, we can include the time headers to access clock()*/
#if !(defined(apOS_CONFIG_USE_NO_CLIB) && (apOS_CONFIG_USE_NO_CLIB))
#include <time.h>
#endif

/*if built with timers, we can access the timer functions*/
#if !defined(apOS_PLATFORM_HAS_TIMERS) || (apOS_PLATFORM_HAS_TIMERS)
#include "../aptimer/aptimer.h"
#endif

// Include appropriate public interrupt driver header file 
#if apINT_VERSION & (apVERSION_INTEGRATOR | apVERSION_ARMULATOR)
    #include "../apint/apint.h"          /* Standard Interrupt public header */
#endif

#if apINT_VERSION & apVERSION_VECTORED

#if (apINT_VERSION == apVERSION_VECTORED_PL192)|(apINT_VERSION == apVERSION_VIC_PL192_ON_LM)
    #include "../appl192/appl192.h"     /* VIC PL192 public header */
#else
    #include "../apvic/apvic.h"         /* VIC PL190 public header */
#endif

#endif

/*
 *If we are using a buffer for storing debug messages, reserve the space here
 */
#if defined(apDEBUG_ENABLED) && defined(apDEBUG_BUFFER)
    extern  WORD32 apDEBUG_Counter;
    extern  char  apDEBUG_Working[apDEBUG_PRINTF_MAX];
    extern  char  apDEBUG_Buffer[apDEBUG_BUFFER_SIZE];
    PROTECTED  WORD32 apDEBUG_Counter=0;
    PROTECTED  char  apDEBUG_Working[apDEBUG_PRINTF_MAX];
    PROTECTED  char  apDEBUG_Buffer[apDEBUG_BUFFER_SIZE]="<#>";
#endif

/*
 *Flag for callback with apOS_TIMER_Wait
 */
#if (!apOS_NO_STATIC_STATE) && (!defined(apOS_PLATFORM_HAS_TIMERS) || apOS_PLATFORM_HAS_TIMERS)
    PRIVATE volatile BOOL TimerElapsed;
#endif

/*
 * Description:
 * If we have a VIC and an INT we must adjust the source, as the VIC will be passed as
 *  controller #1, but is VIC instance #0
 * 
 * Inputs:
 * oSource - the raw interrupt source (controllers above apOS_INT_MAXIMUM refer to the VIC)
 *
 * Outputs:
 * oSource - the corrected interrupt source (controller is the VIC or INT instance)
 *
 * Return Value:
 * + TRUE if the interrupt source refers to a VIC
 * + FALSE if the interrupt source refers to an INT
 */
INLINE BOOL OS_INT_ControllerIsVIC(apOS_INT_oInterruptSource * oSource)
{
#if (apINT_VERSION == apVERSION_VIC_ON_LM) || (apINT_VERSION == apVERSION_VIC_PL192_ON_LM)
    /*check if the source refers to the VIC*/
    if ((*oSource >> 8) >= apOS_INT_MAXIMUM)
    {
        *oSource = (apOS_INT_oInterruptSource)(*oSource - (apOS_INT_MAXIMUM << 8));
        return TRUE;
    }
    return FALSE;
#else
    IGNORE(oSource);
    return (apINT_VERSION & apVERSION_VECTORED);
#endif
}

/*=See apOS.h for documentation=========================================*/
PUBLIC void apOS_INT_InterruptEnable(CONST apOS_INT_oInterruptSource oSource)
{
apOS_INT_oInterruptSource oAdjSource=oSource;         /*local copy of interrupt source*/
    if (OS_INT_ControllerIsVIC(&oAdjSource))
    {
#if (apINT_VERSION & apVERSION_VECTORED)
        apVIC_InterruptEnable(oAdjSource);
#endif
    }
    else
    {
#if ((apINT_VERSION & apVERSION_INTEGRATOR) || (apINT_VERSION & apVERSION_ARMULATOR))
        apINT_InterruptEnable(oAdjSource);
#endif
    }
}

/*=See apOS.h for documentation=========================================*/
PUBLIC void apOS_INT_InterruptDisable(CONST apOS_INT_oInterruptSource oSource)
{
apOS_INT_oInterruptSource oAdjSource=oSource;         /*local copy of interrupt source*/
    if (OS_INT_ControllerIsVIC(&oAdjSource))
    {
#if (apINT_VERSION & apVERSION_VECTORED)
        apVIC_InterruptDisable(oAdjSource);
#endif
    }
    else
    {
#if ((apINT_VERSION & apVERSION_INTEGRATOR) || (apINT_VERSION & apVERSION_ARMULATOR))
        apINT_InterruptDisable(oAdjSource);
#endif
    }
}

/*=See apOS.h for documentation=========================================*/
PUBLIC void apOS_INT_ControllerDisable(apOS_INT_oId oId)
{
/*in order to check for INT/VIC, we convert the controller number into a dummy source*/
apOS_INT_oInterruptSource oAdjSource=(apOS_INT_oInterruptSource)(oId << 8);
    if (OS_INT_ControllerIsVIC(&oAdjSource))
    {
#if (apINT_VERSION & apVERSION_VECTORED)
        apVIC_ControllerDisable((apOS_VIC_oId)(oAdjSource >> 8));
#endif
    }
    else
    {
#if ((apINT_VERSION & apVERSION_INTEGRATOR) || (apINT_VERSION & apVERSION_ARMULATOR))
        apINT_ControllerDisable((apOS_INT_oId)(oAdjSource >> 8));
#endif
    }
}

/*=See apOS.h for documentation=========================================*/
PUBLIC void apOS_INT_ControllerRestore(apOS_INT_oId oId)
{
/*in order to check for INT/VIC, we convert the controller number into a dummy source*/
apOS_INT_oInterruptSource oAdjSource=(apOS_INT_oInterruptSource)(oId << 8);
    if (OS_INT_ControllerIsVIC(&oAdjSource))
    {
#if (apINT_VERSION & apVERSION_VECTORED)
       apVIC_ControllerRestore((apOS_VIC_oId)(oAdjSource >> 8));
#endif
    }
    else
    {
#if ((apINT_VERSION & apVERSION_INTEGRATOR) || (apINT_VERSION & apVERSION_ARMULATOR))
        apINT_ControllerRestore((apOS_INT_oId)(oAdjSource >> 8));
#endif
    }
}

/*=See apOS.h for documentation=========================================*/
PUBLIC void apOS_INT_InterruptClear(CONST apOS_INT_oInterruptSource oSource)
{
apOS_INT_oInterruptSource oAdjSource=oSource;         /*local copy of interrupt source*/
    if (OS_INT_ControllerIsVIC(&oAdjSource))
    {
        /*vectored interrupt controller clears the interrupt within the dispatcher,
         *not by using this routine.*/
    }
    else
    {
#if ((apINT_VERSION & apVERSION_INTEGRATOR) || (apINT_VERSION & apVERSION_ARMULATOR))
        apINT_InterruptClear(oAdjSource);
#endif
    }
}
 
/*=See apOS.h for documentation=========================================*/
PUBLIC void apOS_INT_HandlerSet(CONST apOS_INT_oInterruptSource oSource, 
                           apOS_INT_rServiceRoutine rHandler,
                           UWORD32 Id,
                           apOS_INT_rRawISR rRawHandler)
{
apOS_INT_oInterruptSource oAdjSource=oSource;         /*local copy of interrupt source*/
    if (OS_INT_ControllerIsVIC(&oAdjSource))
    {
#if (apINT_VERSION & apVERSION_VECTORED)
        apVIC_HandlerSet(oAdjSource, rHandler, Id);
#endif
    }
    else
    {
#if ((apINT_VERSION & apVERSION_INTEGRATOR) || (apINT_VERSION & apVERSION_ARMULATOR))
        apINT_HandlerSet(oAdjSource, rHandler, Id);
#endif
    }
    IGNORE(rRawHandler);                    /*for these interrupt controllers*/
}

/*=See apOS.h for documentation=========================================*/
PUBLIC void apOS_INT_HandlerClear(CONST apOS_INT_oInterruptSource oSource)
{
apOS_INT_oInterruptSource oAdjSource=oSource;         /*local copy of interrupt source*/
    if (OS_INT_ControllerIsVIC(&oAdjSource))
    {
#if (apINT_VERSION & apVERSION_VECTORED)
        apVIC_HandlerClear(oAdjSource);
#endif
    }
    else
    {
#if ((apINT_VERSION & apVERSION_INTEGRATOR) || (apINT_VERSION & apVERSION_ARMULATOR))
        apINT_HandlerClear(oAdjSource);
#endif
    }
}

/*=See apOS.h for documentation=========================================*/
PUBLIC apOS_INT_oInterruptSource apOS_INT_SourceGet(void)
{
    apASSERT(FALSE);                    /*not implemented with current interrupt controllers*/
    return (apOS_INT_oInterruptSource) 0;
}

/*=See apOS.h for documentation=========================================*/
PUBLIC UWORD32 apOS_INT_InstanceGet(void)
{
    apASSERT(FALSE);                    /*not implemented with current interrupt controllers*/
    return 0;
}

/*=See apOS.h for documentation=========================================*/
/*This routine sets the flag to indicate that the timer has elapsed*/
#if (!apOS_NO_STATIC_STATE) && (!defined(apOS_PLATFORM_HAS_TIMERS) || apOS_PLATFORM_HAS_TIMERS)
PRIVATE void OS_TIMER_Elapsed(UWORD32 Param)
{
    IGNORE(Param);
    TimerElapsed=TRUE;
    apTIMER_Stop ((apOS_TIMER_oId)0);
}
#endif

PUBLIC void apOS_TIMER_Wait(UWORD32 Microseconds)
{
    /*return immediately if no delay required*/
    if (!Microseconds)
    {
        return;
    }

    /*if interrupts are enabled, attempt to implement using a timeout with timer 0*/
    if (apOS_CoreIRQGet())
    {
#if (!apOS_NO_STATIC_STATE) && (!defined(apOS_PLATFORM_HAS_TIMERS) || apOS_PLATFORM_HAS_TIMERS)
        TimerElapsed=FALSE;
        if ((apOS_TIMER_TimeoutEnable(0,Microseconds,&OS_TIMER_Elapsed,0)) == apERR_NONE)
        {
            while (!TimerElapsed)
            {
            }
            return;
        }
#endif
    }
    /*if interrupts are disabled, warn about long delays in ISRs*/
    else
    {
        if (Microseconds > 100)
        {
            apDEBUG_WARN("ISR invoking delay %lu us\n",Microseconds);
        }
    }
       
/*implement the function using clock() on a debugger*/
#if !(defined(apOS_CONFIG_USE_NO_CLIB) && (apOS_CONFIG_USE_NO_CLIB))
    {
        clock_t Start;
    
        /*warn about very short delays*/
        if (Microseconds < 10000)
        {
            apDEBUG_WARN("Clock() delay %lu us (<10ms)\n",Microseconds);
        }
	    Start = clock();
	    while (((UWORD32)clock()-Start) * (UWORD32)(1000000UL/CLOCKS_PER_SEC) < Microseconds)
        {
        // Do nothing.
        }
    }
/*implement the function using a counter - these values are not for accurate code timing*/
#else
    {
    #if defined(__TARGET_CPU_ARM920T) || defined(__TARGET_CPU_ARM720T) || defined(__TARGET_CPU_ARM940T) || defined(__TARGET_CPU_ARM740T)
        volatile UWORD32 tc=Microseconds*2;
    #else
        volatile UWORD32 tc=Microseconds/4;
    #endif
        while (tc--);
    }
#endif
}

/*=See apOS.h for documentation=========================================*/
PUBLIC apError apOS_TIMER_TimeoutEnable(UWORD32 TimerNumber,
                                        UWORD32 Microseconds,
                                        void rCallback(UWORD32),
                                        UWORD32 CallbackParam)
{
#if !defined(apOS_PLATFORM_HAS_TIMERS) || (apOS_PLATFORM_HAS_TIMERS)
    apTIMER_sIntervalData sTimerData; 
 #if apOS_NO_STATIC_STATE
    /*
     * With no static state, some sort of timer dispatcher will be required
     * to match the passed parameter to an available timer
     */
    return apERR_UNSUPPORTED;
 #else
    /* check the number of timers unless we have no static state */
   if (TimerNumber >= apOS_TIMER_MAXIMUM)
    {
        return apERR_BAD_PARAMETER;
    }
 #endif
    sTimerData.eMode = apTIMER_MODE_PERIODIC;
    sTimerData.Interval = Microseconds;
    sTimerData.eIntervalUnits = apTIMER_MICROSECONDS;
    sTimerData.LoInterval = 1;
    sTimerData.eLoIntervalUnits = apTIMER_MICROSECONDS;
    sTimerData.RepeatCount = 1;
    sTimerData.eStart = apTIMER_SET_AND_START;
    
    apTIMER_IntervalSet ((apOS_TIMER_oId) TimerNumber,
                          (apTIMER_rCallBackHandler) rCallback,
                            CallbackParam,
                             &sTimerData);

    return apERR_NONE;
#else
    IGNORE(TimerNumber);
    IGNORE(Microseconds);
    IGNORE(rCallback);
    IGNORE(CallbackParam);

    return apERR_UNSUPPORTED;
#endif
}

/*=See apOS.h for documentation=========================================*/
PUBLIC void apOS_TIMER_TimeoutDisable(UWORD32 TimerNumber)
{
#if !defined(apOS_PLATFORM_HAS_TIMERS) || (apOS_PLATFORM_HAS_TIMERS)
#if apOS_NO_STATIC_STATE
    /*
     * With no static state, some sort of timer dispatcher will be required
     * to match the passed parameter to an available timer
     */
    return;
#else
    if (TimerNumber < apOS_TIMER_MAXIMUM)
#endif
    {
        apTIMER_Stop((apOS_TIMER_oId) TimerNumber);
    }
#else
    IGNORE(TimerNumber);
#endif
}
