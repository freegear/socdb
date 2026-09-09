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
//  File: interrupt.c
//
//  This file implement major part of interrupt module for SMT926 SoC.
//
#include <windows.h>
#include <ceddk.h>
#include <nkintr.h>
#include <oal.h>
#include <smt926a.h>
#include <smt926a_intr.h>
#include <intr.h>
 
extern volatile UINT32 g_oalLastSysIntr; 


//------------------------------------------------------------------------------
//
//  Globals:  g_pIntrRegs/g_pPortRegs
//
//  The global variables are storing virual address for interrupt and port
//  registers for use in interrupt handling to avoid possible time consumig
//  call to OALPAtoVA function.
//
static SMT926A_INTR_REG *g_pIntrRegs; 
static SMT926A_IOPORT_REG *g_pPortRegs;

//  Function pointer to profiling timer ISR routine.
//
PFN_PROFILER_ISR g_pProfilerISR = NULL;
 

//------------------------------------------------------------------------------
//
//  Function:  OALIntrInit
//
//  This function initialize interrupt mapping, hardware and call platform
//  specific initialization.
//
BOOL OALIntrInit()
{
    BOOL rc = FALSE;
    
    OALMSG( OAL_FUNC&&OAL_INTR, (L"+OALInterruptInit\r\n") );

    // Initialize interrupt mapping
    OALIntrMapInit();

    // First get uncached virtual addresses
    g_pIntrRegs = (SMT926A_INTR_REG*)OALPAtoVA(
        SMT926A_BASE_REG_PA_INTR, FALSE
    );
    g_pPortRegs = (SMT926A_IOPORT_REG*)OALPAtoVA(
        SMT926A_BASE_REG_PA_IOPORT, FALSE
    );

    // Mask and clear external interrupts
    OUTREG32(&g_pPortRegs->EINTMASK, 0xFFFFFFFF);
    OUTREG32(&g_pPortRegs->EINTPEND, 0xFFFFFFFF);

    // Mask and clear internal interrupts
    OUTREG32(&g_pIntrRegs->INTMSK, 0xFFFFFFFF);
    OUTREG32(&g_pIntrRegs->SRCPND, 0xFFFFFFFF);

    // SMT926A developer notice (page 4) warns against writing a 1 to any
    // 0 bit field in the INTPND register.  Instead we'll write the INTPND
    // value itself.
    OUTREG32(&g_pIntrRegs->INTPND, INREG32(&g_pIntrRegs->INTPND));

    // Unmask the system tick timer interrupt
    CLRREG32(&g_pIntrRegs->INTMSK, 1 << IRQ_TIMER4);

#ifdef OAL_BSP_CALLBACKS
    // Give BSP change to initialize subordinate controller
    rc = BSPIntrInit();
#else
    rc = TRUE;
#endif

    OALMSG(OAL_INTR&&OAL_FUNC, (L"-OALInterruptInit(rc = %d)\r\n", rc));
    return rc;
}



//------------------------------------------------------------------------------
//
//  Function:  OALIntrRequestIrqs
//
//  This function returns IRQs for CPU/SoC devices based on their
//  physical address.
//
BOOL OALIntrRequestIrqs(DEVICE_LOCATION *pDevLoc, UINT32 *pCount, UINT32 *pIrqs)
{
    BOOL rc = FALSE;

    OALMSG(OAL_INTR&&OAL_FUNC, (
        L"+OALIntrRequestIrqs(0x%08x->%d/%d/0x%08x/%d, 0x%08x, 0x%08x)\r\n",
        pDevLoc, pDevLoc->IfcType, pDevLoc->BusNumber, pDevLoc->LogicalLoc,
        pDevLoc->Pin, pCount, pIrqs
    ));

    // This shouldn't happen
    if (*pCount < 1) goto cleanUp;

#ifdef OAL_BSP_CALLBACKS
    rc = BSPIntrRequestIrqs(pDevLoc, pCount, pIrqs);
#endif    

cleanUp:        
    OALMSG(OAL_INTR&&OAL_FUNC, (L"-OALIntrRequestIrqs(rc = %d)\r\n", rc));
    return rc;
}


//------------------------------------------------------------------------------
//
//  Function:  OALIntrEnableIrqs
//
BOOL OALIntrEnableIrqs(UINT32 count, const UINT32 *pIrqs)
{
    BOOL rc = TRUE;
    UINT32 i, mask, irq;

    OALMSG(OAL_INTR&&OAL_FUNC, (
        L"+OALIntrEnableIrqs(%d, 0x%08x)\r\n", count, pIrqs
    ));

    for (i = 0; i < count; i++) {
#ifndef OAL_BSP_CALLBACKS
        irq = pIrqs[i];
#else
        // Give BSP chance to enable irq on subordinate interrupt controller
        irq = BSPIntrEnableIrq(pIrqs[i]);
#endif
        if (irq == OAL_INTR_IRQ_UNDEFINED) continue;
        // Depending on IRQ number use internal or external mask register
        if (irq <= IRQ_ADC) {
            // Use interrupt mask register
            CLRREG32(&g_pIntrRegs->INTMSK, 1 << irq);
        } else if (irq <= IRQ_EINT7) {
            // Use external mask register
            CLRREG32(&g_pIntrRegs->INTMSK, 1 << IRQ_EINT4_7);
            CLRREG32(&g_pPortRegs->EINTMASK, 1 << (irq - IRQ_EINT4 + 4));
        } else if (irq <= IRQ_EINT23) {
            // Use external mask register
            mask = 1 << (irq - IRQ_EINT4 + 4);
            OUTREG32(&g_pPortRegs->EINTPEND, mask);
            CLRREG32(&g_pPortRegs->EINTMASK, mask);
            mask = 1 << IRQ_EINT8_23;
            if ((INREG32(&g_pIntrRegs->INTPND) & mask) != 0) {
                OUTREG32(&g_pIntrRegs->INTPND, mask);
            }
            CLRREG32( &g_pIntrRegs->INTMSK, 1 << IRQ_EINT8_23);
        } else {
            rc = FALSE;
        }
    }        

    OALMSG(OAL_INTR&&OAL_FUNC, (L"-OALIntrEnableIrqs(rc = %d)\r\n", rc));
    return rc;    
}


//------------------------------------------------------------------------------
//
//  Function:  OALIntrDisableIrqs
//
VOID OALIntrDisableIrqs(UINT32 count, const UINT32 *pIrqs)
{
    UINT32 i, mask, irq;

    OALMSG(OAL_INTR&&OAL_FUNC, (
        L"+OALIntrDisableIrqs(%d, 0x%08x)\r\n", count, pIrqs
    ));

    for (i = 0; i < count; i++) {
#ifndef OAL_BSP_CALLBACKS
        irq = pIrqs[i];
#else
        // Give BSP chance to disable irq on subordinate interrupt controller
        irq = BSPIntrDisableIrq(pIrqs[i]);
        if (irq == OAL_INTR_IRQ_UNDEFINED) continue;
#endif
        // Depending on IRQ number use internal or external mask register
        if (irq <= IRQ_ADC) {
            // Use interrupt mask register
            mask = 1 << irq;
            SETREG32(&g_pIntrRegs->INTMSK, mask);
        } else if (irq <= IRQ_EINT23) {
            // Use external mask register
            mask = 1 << (irq - IRQ_EINT4 + 4);
            SETREG32(&g_pPortRegs->EINTMASK, mask);
        }
    }

    OALMSG(OAL_INTR&&OAL_FUNC, (L"-OALIntrDisableIrqs\r\n"));
}


//------------------------------------------------------------------------------
//
//  Function:  OALIntrDoneIrqs
//
VOID OALIntrDoneIrqs(UINT32 count, const UINT32 *pIrqs)
{
    UINT32 i, mask, irq;

    OALMSG(OAL_INTR&&OAL_VERBOSE, (
        L"+OALIntrDoneIrqs(%d, 0x%08x)\r\n", count, pIrqs
    ));

    for (i = 0; i < count; i++) {
#ifndef OAL_BSP_CALLBACKS
        irq = pIrqs[i];
#else
        // Give BSP chance to finish irq on subordinate interrupt controller
        irq = BSPIntrDoneIrq(pIrqs[i]);
#endif    
        // Depending on IRQ number use internal or external mask register
        if (irq <= IRQ_ADC) {
            // Use interrupt mask register
            mask = 1 << irq;
            OUTREG32(&g_pIntrRegs->SRCPND, mask);
            CLRREG32(&g_pIntrRegs->INTMSK, mask);
        } else if (irq <= IRQ_EINT23) {
            // Use external mask register
            mask = 1 << (irq - IRQ_EINT4 + 4);
            OUTREG32(&g_pPortRegs->EINTPEND, mask);
            CLRREG32(&g_pPortRegs->EINTMASK, mask);
        }    
    }

    OALMSG(OAL_INTR&&OAL_VERBOSE, (L"-OALIntrDoneIrqs\r\n"));
}


//------------------------------------------------------------------------------
//
//  Function:  OEMInterruptHandler
//
ULONG OEMInterruptHandler(ULONG ra)
{
    UINT32 sysIntr = SYSINTR_NOP;
    UINT32 irq, irq2, mask;

    // Get pending interrupt(s)
    irq = INREG32(&g_pIntrRegs->INTOFFSET);

    // System timer interrupt?
    if (irq == IRQ_TIMER4) {

        // Clear the interrupt
        OUTREG32(&g_pIntrRegs->SRCPND, 1 << IRQ_TIMER4);
        OUTREG32(&g_pIntrRegs->INTPND, 1 << IRQ_TIMER4);

        // Rest is on timer interrupt handler
        sysIntr = OALTimerIntrHandler();
	}    
    // Profiling timer interrupt?
    else if (irq == IRQ_TIMER2)
    {
        // Mask and Clear the interrupt.
        mask = 1 << irq;
        SETREG32(&g_pIntrRegs->INTMSK, mask);
        OUTREG32(&g_pIntrRegs->SRCPND, mask);
        OUTREG32(&g_pIntrRegs->INTPND, mask);

        // The rest is up to the profiling interrupt handler (if profiling
        // is enabled).
        //
        if (g_pProfilerISR)
        {
            sysIntr = g_pProfilerISR(ra);
        }
    }
    else 
    {

#ifdef OAL_ILTIMING
        if (g_oalILT.active) {
            g_oalILT.isrTime1 = OALTimerCountsSinceSysTick();
            g_oalILT.savedPC = 0;
            g_oalILT.interrupts++;
        }        
#endif
    
        if (irq == IRQ_EINT4_7 || irq == IRQ_EINT8_23) { // 4 or 5

            // Find external interrupt number
            mask = INREG32(&g_pPortRegs->EINTPEND);
            mask &= ~INREG32(&g_pPortRegs->EINTMASK);
            mask = (mask ^ (mask - 1)) >> 5;
            irq2 = IRQ_EINT4;
            while (mask != 0) {
                mask >>= 1;
                irq2++;
            }

            // Mask and clear interrupt
            mask = 1 << (irq2 - IRQ_EINT4 + 4);
            SETREG32(&g_pPortRegs->EINTMASK, mask);
            OUTREG32(&g_pPortRegs->EINTPEND, mask);

            // Clear primary interrupt
            mask = 1 << irq;
            OUTREG32(&g_pIntrRegs->SRCPND, mask);
            OUTREG32(&g_pIntrRegs->INTPND, mask);

            // From now we care about this irq
            irq = irq2;

        }  else {

            // Mask and clear interrupt
            mask = 1 << irq;
            SETREG32(&g_pIntrRegs->INTMSK, mask);
            OUTREG32(&g_pIntrRegs->SRCPND, mask);
            OUTREG32(&g_pIntrRegs->INTPND, mask);

        }

        // First find if IRQ is claimed by chain
        sysIntr = NKCallIntChain((UCHAR)irq);
        if (sysIntr == SYSINTR_CHAIN || !NKIsSysIntrValid(sysIntr)) {
            // IRQ wasn't claimed, use static mapping
            sysIntr = OALIntrTranslateIrq(irq);
        }
    }

	g_oalLastSysIntr = sysIntr;
    return sysIntr;
}

//------------------------------------------------------------------------------
