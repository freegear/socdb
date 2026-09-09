/***************************************************************************
 * Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
 * Copyright © ARM Limited 1998, 1999.  All rights reserved.
 ***************************************************************************/
/***************************************************************************
 *
 * This file contains the code used by various IRQ handling routines:
 * asking for different IRQ's should be done through these routines
 * instead of just grabbing them. Thus setups with different IRQ numbers
 * shouldn't result in any weird surprises, and installing new handlers
 * should be easier.
 *
 *	$Id: irq.c,v 1.3 1999/11/19 13:50:34 asims Exp $
 *
 ***************************************************************************/

#include "uhal.h"

/*
 * Array of irq handlers.
 */

struct uHALis_IRQ	uHALv_IRQVector[NR_IRQS + 1] ;
int		interrupts[NR_IRQS + 1] ;

/* Vectors to IRQ functions - initially NULL */
PrVoid	        uHALp_VectorIRQ = (PrVoid)0 ;	/* Low level trap handler */
PrVoid	        uHALp_StartIRQ  = (PrVoid)0 ;	/* Called at start of every IRQ */
PrVoid	        uHALp_HandleIRQ  = (PrVoid)0 ;	/* High-level Trap handler */
PrPrVoid	uHALp_FinishIRQ = (PrPrVoid)0 ;/* Called at end of every IRQ */
PrVoid	        uHALp_SavedIRQ  = (PrVoid)0 ;	/* The previous trap handler (semihosteds?) */

#if NR_IRQS > 32
#  error Unable to handle more than 32 irq levels.
#endif

/*
 * Reserved interrupts.  These must NEVER be requested by any driver!
 */
#define	IS_RESERVED_IRQ(irq)	((irq)==NR_IRQS) /* Demon probably wants IRQ1 */
#define	uHAL_INTSHARED		0x80		/* Shared interrupt flag */

/* Note this routine has no effect if irq is not in range */
void uHALr_DisableInterrupt(unsigned int intNum)
{
    uHALir_MaskIrq(intNum) ;
    uHALv_IRQVector[intNum].handler = (PrHandler)0 ;
    /* Doesn't disable IRQ, needs to know no other interrupts active */
}

void uHALr_EnableInterrupt(unsigned int intNum)
{
    uHALir_UnmaskIrq(intNum) ;
    uHALir_EnableInt() ;		/* Make sure the interrupt is enabled */
}


/*
 * Routine to check and install requested interrupt. Just sets up logical
 * structures, doesn't alter interrupts at all.
 */
int uHALr_RequestInterrupt(unsigned int intNum,
			PrHandler handler, const unsigned char *devname)
{
struct uHALis_IRQ	*action ;

    if (intNum >= NR_IRQS)
	return -1 ;
    if (IS_RESERVED_IRQ(intNum))
	return -1 ;
    if (!handler)
	return -1 ;

    action = &uHALv_IRQVector[intNum] ;
    
    /* Can't share interrupts (yet) */
    if (action->handler)
	return -1 ;

    action->handler = handler ;
    action->name = devname ;
    action->flags = 0 ;
    action->mask = 0 ;
    action->next = 0 ;
    
    return 0 ;
}
		
/* Call this routine before trying to change the routine attached to an IRQ */
int uHALr_FreeInterrupt(unsigned int intNum)
{
    if (intNum >= NR_IRQS) {
	uHALr_printf("Can't free Interrupt %d\n", intNum) ;
	return -1 ;
    }
    if (IS_RESERVED_IRQ(intNum)) {
	uHALr_printf("Can't free reserved Interrupt %d\n", intNum) ;
	return -1 ;
    }

    uHALr_DisableInterrupt(intNum) ;

#ifdef DEBUG
    uHALr_printf("free'd Interrupt %d\n", intNum) ;
#endif

    return 0 ;
}

/* Sample routine executed when an unexpected IRQ is received */
void uHALir_UnexpectedIRQ(unsigned int irq)
{
#if 0
struct uHALis_IRQ *action ;
int		 i ;

    for (i = 0 ; i < NR_IRQS ; i++) {
	action = &uHALv_IRQVector[irq] ;
	while (action && action->handler) {
	    uHALr_printf("[%s:%d] ", action->name, i) ;
	    action = action->next ;
	}
    }
    uHALr_printf("\n") ;
#endif

    uHALr_SetLED(1) ;
    uHALr_SetLED(2) ;
    uHALr_SetLED(3) ;
    uHALr_printf("Unexpected Interrupt = %d\n", irq) ;
}


/*
 * Interrupt service routine dispatcher.
 *
 * This is the IRQ handler called when an IRQ trap is taken.
 */
void uHALir_DispatchIRQ(unsigned int flags)
{
int		   irq = 0;
struct uHALis_IRQ *action;

    /*
    ** Test to see if there is a flag set, if not
    ** then don't do anything
    */
    while (flags != 0) {
        /*
        ** The follow if statements will find the least significant
        ** bit that is set.  After this code has executed the flags
        ** varible will be shifted left so that the first flag will
        ** be bit zero and the irq varible will be set to the bit 
        ** position.
        */
        if ((flags & 0xffff) == 0) {
            irq += 16;
            flags >>= 16;
        }

        if ((flags & 0xff) == 0) {
            irq += 8;
            flags >>= 8;
        }

        if ((flags & 0xf) == 0) {
            irq += 4;
            flags >>= 4;
        }

        if ((flags & 0x3) == 0) {
            irq += 2;
            flags >>= 2;
        }

        if ((flags & 0x1) == 0) {
            irq += 1;
            flags >>= 1;
        }

        if (irq > MAXIRQNUM)
            break;

        /*
        ** Get the vector and process the interrupt.
        */
        action = &uHALv_IRQVector[irq];

        if (action->handler == NULL)
            uHALir_UnexpectedIRQ(irq);
        else {
            do {
                /*
                ** Process multiple handers if they exist.
                */
                action->handler(irq);
            } while ((action = action->next) != NULL);
        }

        /*
        ** As stated above the bit that corresponds to this
        ** interrupt is now the LSB of flags.  Therefore we
        ** need to clear this bit before going around the loop
        ** again.
        */
        flags &= ~1;
    }
} /* DispatchIRQ */
 

/*
 * Called once on start-up by projects which require one or more special IRQ
 * routines. Start is the address of a routine called at the start of every
 * IRQ. Finish is the address of a routine called at the end of every IRQ. If
 * Finish wants to do really low-level stuff (such as context switch etc.),
 * the IRQ routine will jump to the returned value (if non-zero). Trap is the
 * address of the routine if you want to completely replace the routine
 * vectored to by IRQ.
 */
void uHALir_DefineIRQ(PrVoid Start, PrPrVoid Finish, PrVoid Trap)
{
    /* These vectors can be zero'd if required */
    uHALp_StartIRQ = Start;
    uHALp_FinishIRQ = Finish;

    /* Only setup the IRQ vector if it isn't zero */
    if (Trap != (PrVoid)0)
	uHALp_VectorIRQ = Trap;

    /* Call NewIRQ to install the new IRQ */
}

/* Called once on start-up to initialise data structures & interrupt routines */
void uHALr_InitInterrupts(void)
{
int	i ;

    /* ---- soft vectors ---------------------------------------------- */
    for (i = 0 ; i < MAXIRQNUM ; i++) {
	uHALir_MaskIrq(i) ;
	uHALv_IRQVector[i].flags = 0 ;
	uHALv_IRQVector[i].handler = (PrHandler)0 ;
	uHALv_IRQVector[i].next	 = NULL ;
	uHALv_IRQVector[i].name	 = 0 ;
    }	
    /* ---- install new trap handlers -------------------------------- */
    uHALp_SavedIRQ = uHALir_NewIRQ(uHALir_DispatchIRQ, uHALp_VectorIRQ) ;
}


/* Try and print something out after a program crash */
void uHALir_DebugUndefinedInst(void *Stack)
{
int	i ;
int	*pStack = (int *)Stack ;

    uHALr_printf("Undefined instruction\n Recent stack looks like this:\n") ;
    for (i = 0 ; i < 10 ; i++)
	uHALr_printf(" %x %x.\n", pStack + i, *(pStack + i)) ;
}

