//
// Copyright (c) Microsoft Corporation.  All rights reserved.
//
//
// Use of this source code is subject to the terms of the Microsoft end-user
// license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
// If you did not accept the terms of the EULA, you are not authorized to use
// this source code. For a copy of the EULA, please see the LICENSE.RTF on your
// install media.
//
//------------------------------------------------------------------------------
//
//  Module: timer.c           
//
//  Interface to OAL timer services.
//
#include <windows.h>
#include <nkintr.h>
#include <ceddk.h>
#include <oal.h>
#include <smt926a.h>

//------------------------------------------------------------------------------
// Local Variables 

static SMT926A_PWM_REG *g_pPWMRegs = NULL;
 
//------------------------------------------------------------------------------
//
//  Global:  g_oalLastSysIntr
//
//  This global variable is set by fake version of interrupt/timer handler
//  to last SYSINTR value.
//
volatile UINT32 g_oalLastSysIntr; 

//------------------------------------------------------------------------------
//
//  Function: OALTimerInit
//
//  This function is typically called from the OEMInit to initialize
//  Windows CE system timer. The tickMSec parameter determine timer
//  period in milliseconds. On most platform timer period will be
//  1 ms, but it can be usefull to use higher value for some
//  specific (low-power) devices.
//
//  Implementation for smt926a is using timer 4 as system timer.
//
BOOL OALTimerInit(
    UINT32 msecPerSysTick, UINT32 countsPerMSec, UINT32 countsMargin
) {
    BOOL rc = FALSE;
    UINT32 countsPerSysTick;
    UINT32 sysIntr, irq;
    UINT32 tcon;

    OALMSG(OAL_TIMER&&OAL_FUNC, (
        L"+OALTimerInit( %d, %d, %d )\r\n", 
        msecPerSysTick, countsPerMSec, countsMargin
    ));

    // Validate Input parameters
    countsPerSysTick = countsPerMSec * msecPerSysTick;
    if (
        msecPerSysTick < 1 || msecPerSysTick > 1000 ||
        countsPerSysTick < 1 || countsPerSysTick > 65535
    ) {
        OALMSG(OAL_ERROR, (
            L"ERROR: OALTimerInit: System tick period out of range..."
        ));
        goto cleanUp;
    }

    // Initialize timer state global variable    
    g_oalTimer.msecPerSysTick = msecPerSysTick;
    g_oalTimer.countsPerMSec = countsPerMSec;
    g_oalTimer.countsMargin = countsMargin;
    g_oalTimer.countsPerSysTick = countsPerSysTick;
    g_oalTimer.curCounts = 0;
    g_oalTimer.maxPeriodMSec = 0xFFFF/g_oalTimer.countsPerMSec;

	g_oalTimer.actualMSecPerSysTick = msecPerSysTick;
	g_oalTimer.actualCountsPerSysTick = countsPerSysTick;

    // Set kernel exported globals to initial values
    idleconv = countsPerMSec;
    curridlehigh = 0;
    curridlehigh = 0;

    // Initialize high resolution timer function pointers
    pQueryPerformanceFrequency = OALTimerQueryPerformanceFrequency;
    pQueryPerformanceCounter = OALTimerQueryPerformanceCounter;

    // Create SYSINTR for timer
    irq = IRQ_TIMER4;
    sysIntr = OALIntrRequestSysIntr(1, &irq, OAL_INTR_FORCE_STATIC);

    // Hardware Setup
    g_pPWMRegs = (SMT926A_PWM_REG*)OALPAtoUA(SMT926A_BASE_REG_PA_PWM);

    // Set prescaler 1 to 1 
    OUTREG32(&g_pPWMRegs->TCFG0, INREG32(&g_pPWMRegs->TCFG0) & ~0x0000FF00);
    OUTREG32(&g_pPWMRegs->TCFG0, INREG32(&g_pPWMRegs->TCFG0) | (245-1) <<8);		// charlie, Timer4 scale value
    // Select MUX input 1/2
    OUTREG32(&g_pPWMRegs->TCFG1, INREG32(&g_pPWMRegs->TCFG1) & ~(0xF << 16));
    OUTREG32(&g_pPWMRegs->TCFG1, INREG32(&g_pPWMRegs->TCFG1) | (3 << 16));	// charlie, Timer4 Division
    // Set timer register
    OUTREG32(&g_pPWMRegs->TCNTB4, g_oalTimer.countsPerSysTick);

    // Start timer in auto reload mode
    tcon = INREG32(&g_pPWMRegs->TCON) & ~(0x0F << 20);
    OUTREG32(&g_pPWMRegs->TCON, tcon | (0x2 << 20) );
    OUTREG32(&g_pPWMRegs->TCON, tcon | (0x5 << 20) );

    // Enable System Tick interrupt
    if (!OEMInterruptEnable(sysIntr, NULL, 0)) {
        OALMSG(OAL_ERROR, (
            L"ERROR: OALTimerInit: Interrupt enable for system timer failed"
        ));
        goto cleanUp;

    }

//    
// Define ENABLE_WATCH_DOG to enable watchdog timer support.
// NOTE: When watchdog is enabled, the device will reset itself if watchdog timer is not refreshed within ~4.5 second.
//       Therefore it should not be enabled when kernel debugger is connected, as the watchdog timer will not be refreshed.
//
#ifdef ENABLE_WATCH_DOG
    {
        extern void SMDKInitWatchDogTimer (void);
        SMDKInitWatchDogTimer ();
    }
#endif

    // Done        
    rc = TRUE;
    
cleanUp:
    OALMSG(OAL_TIMER && OAL_FUNC, (L"-OALTimerInit(rc = %d)\r\n", rc));
    return rc;
}


//------------------------------------------------------------------------------
//
//  Function: OALTimerIntrHandler
//
//  This function implement timer interrupt handler. It is called from common
//  ARM interrupt handler.
//
UINT32 OALTimerIntrHandler()
{
    UINT32 sysIntr = SYSINTR_NOP;

    // Update high resolution counter
    g_oalTimer.curCounts += g_oalTimer.actualCountsPerSysTick;
                             
    // Update the millisecond counter
    CurMSec += g_oalTimer.actualMSecPerSysTick;

    // Reschedule?
    if ((int)(CurMSec - dwReschedTime) >= 0) sysIntr = SYSINTR_RESCHED;

#ifdef OAL_ILTIMING
    if (g_oalILT.active) {
        if (--g_oalILT.counter == 0) {
            sysIntr = SYSINTR_TIMING;
            g_oalILT.counter = g_oalILT.counterSet;
            g_oalILT.isrTime2 = OALTimerCountsSinceSysTick();
        }
    }        
#endif

    return sysIntr;
}


//------------------------------------------------------------------------------
//
//  Function: OALTimerCountsSinceSysTick
//
//  This function return count of hi res ticks since system tick.
//
//  Timer 4 counts down, so we should substract actual value from 
//  system tick period.
//

INT32 OALTimerCountsSinceSysTick()
{
	return (INREG32(&g_pPWMRegs->TCNTB4) - INREG32(&g_pPWMRegs->TCNTO4));
}

//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//
//  Function:   OALCPUIdle
//
//  This Idle function implements a busy idle. It is intend to be used only
//  in development (when CPU doesn't support idle mode it is better to stub
//  OEMIdle function instead use this busy loop). The busy wait is cleared by
//  an interrupt from interrupt handler setting the g_oalLastSysIntr.
//

VOID OALCPUIdle()
{
    volatile SMT926A_CLKPWR_REG *smtCLKPWR = (SMT926A_CLKPWR_REG *)OALPAtoVA(SMT926A_BASE_REG_PA_CLOCK_POWER, FALSE);
    volatile SMT926A_INTR_REG *smtINTR = (SMT926A_INTR_REG *)OALPAtoVA(SMT926A_BASE_REG_PA_INTR, FALSE);
	
    // Clear last SYSINTR global value
    g_oalLastSysIntr = SYSINTR_NOP;

    INTERRUPTS_ON();

	smtCLKPWR->CLKCON |=  (1 << 2);
    // Wait until interrupt handler set interrupt flag
    while (g_oalLastSysIntr == SYSINTR_NOP);
	smtCLKPWR->CLKCON &= ~(1 << 2);
    INTERRUPTS_OFF();
}

// Inserted by DJKIM to "lan91c.lib"
// Refer to PLATFORM\COMMON\SRC\MIPS\COMMON\TIMER\util.c
//------------------------------------------------------------------------------
//
//  Function:  OALStall
//
//  Wait for time specified in parameter in microseconds (busy wait). This
//  function can be called in hardware/kernel initialization process.
//
VOID OALStall(UINT32 microSec)
{
    UINT32 base, counts;

    while (microSec > 0) {
        if (microSec > 1000) {
            counts = g_oalTimer.countsPerMSec;
            microSec -= 1000;
        } else {
            counts = (microSec * g_oalTimer.countsPerMSec)/1000;
            microSec = 0;
        }
        //base = OALTimerGetCount();					// Comment to compile by DJKIM 2006/09/29
        base = counts;		// Just prevent to compile error by DJKIM 2006/09/29
        //while ((OALTimerGetCount() - base) < counts);	// Comment to compile by DJKIM 2006/09/29
    }
}