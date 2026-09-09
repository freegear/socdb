/***************************************************************************
 * Copyright ¸ ARM Limited 1999.  All rights reserved.
 ***************************************************************************/
/***************************************************************************

   This file contains the code used by various FIQ handling routines:
   asking for different FIQ's should be done through these routines
   instead of just grabbing them. Thus setups with different FIQ numbers
   shouldn't result in any weird surprises, and installing new handlers
   should be easier.
 
	$Id: fiq.c,v 1.1 1999/07/06 14:02:58 drusling Exp $

****************************************************************************/
 
#include "uhal.h"

/*
 * Array of fiq handlers.
 */

struct uHALis_IRQ	uHALv_FIQVector[NR_FIQS + 1] ;
int		finterrupts[NR_FIQS + 1] ;

/* Vectors to FIQ functions - initially NULL */
PrVoid	        uHALp_VectorFIQ = (PrVoid)0 ;	/* Low level trap handler */
PrVoid	        uHALp_StartFIQ  = (PrVoid)0 ;	/* Called at start of every FIQ */
PrVoid	        uHALp_HandleFIQ  = (PrVoid)0 ;	/* High-level Trap handler */
PrPrVoid	        uHALp_FinishFIQ = (PrPrVoid)0 ;/* Called at end of every FIQ */
/* The previous trap handler (maybe the FIQ for semihosted?) */
PrVoid	        uHALp_SavedFIQ  = (PrVoid)0 ;	

#if NR_FIQS > 32
#  error Unable to handle more than 32 fiq levels.
#endif

/*
 * Reserved interrupts.  These must NEVER be requested by any driver!
 * This allows chaining if we know which interrupt the other program uses
 */
#define	IS_RESERVED_FIQ(fiq)	((fiq) == NR_FIQS) 
#define	uHAL_FIQSHARED		0x80		/* Shared interrupt flag */

/* Note this routine has no effect if fiq is not in range */
void uHALr_DisableFIQ(U32 fiq)
{
	uHALir_MaskFiq(fiq) ;
	uHALv_FIQVector[fiq].handler = (PrHandler)0 ;
	/* Doesn't disable FIQ, needs to know no other interrupts active */
}

void uHALr_EnableFIQ(U32 fiq)
{
	uHALir_UnmaskFiq(fiq) ;
	uHALir_EnableInt() ;		/* Make sure the interrupt is enabled */
}


/*
 * Routine to check and install requested interrupt. Just sets up logical
 * structures, doesn't alter interrupts at all.
 */
S32 uHALr_RequestFIQ(U32 fiq,  PrHandler handler, const U8 *devname)
{
struct uHALis_IRQ	*action ;

	if (fiq >= NR_FIQS)
		return -1 ;
	if (IS_RESERVED_FIQ(fiq))
		return -1 ;
	if (handler == NULL)
		return -1 ;

	action = &uHALv_FIQVector[fiq] ;

	/* Can't share interrupts (yet) */
	if (action->handler)
		return -1 ;

	action->handler = handler ;
	action->name = devname ;
	action->flags = 0 ;
	action->mask = 0 ;
	action->next = NULL ;

	return 0 ;
}
		
/* Call this routine before trying to change the routine attached to a FIQ */
S32 uHALr_FreeFIQ(U32 fiq)
{
	if (fiq >= NR_FIQS) {
		uHALr_printf("Can't free FIQ%d\n",fiq) ;
		return -1 ;
	}
	if (IS_RESERVED_FIQ(fiq)) {
		uHALr_printf("Can't free reserved FIQ %d\n", fiq) ;
		return -1 ;
	}

	uHALr_DisableFIQ(fiq) ;
	uHALr_printf("free'd FIQ%d\n",fiq) ;

	return 0 ;
}

/* Sample routine executed when an unexpected FIQ is received */
void uHALir_UnexpectedFIQ(U32 fiq)
{
#if 0
struct uHALis_IRQ *action ;
int		 i ;

	for (i = 0 ; i < NR_FIQS ; i++) {
		action = &uHALv_FIQVector[fiq] ;
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
	uHALr_printf("Unexpected Interrupt = %d\n", fiq) ;
}


/*
 * Interrupt service routine dispatcher.
 *
 * This is the FIQ handler called when a FIQ trap is taken.
 */
void uHALr_DispatchFIQ(U32 flags)
{
    int fiq = 0;
    struct uHALis_IRQ *action;

    /*
    ** Test to see if there is a flag set, if not
    ** then don't do anything
    */
    while (flags != 0) {
        /*
        ** The following if statements will find the least significant
        ** bit that is set.  After this code has executed the flags
        ** varible will be shifted left so that the first flag will be
        ** bit zero and the fiq varible is the bit position.
        */
        if ((flags & 0xffff) == 0) {
            fiq += 16;
            flags >>= 16;
        }

        if ((flags & 0xff) == 0) {
            fiq += 8;
            flags >>= 8;
        }

        if ((flags & 0xf) == 0) {
            fiq += 4;
            flags >>= 4;
        }

        if ((flags & 0x3) == 0) {
            fiq += 2;
            flags >>= 2;
        }

        if ((flags & 0x1) == 0) {
            fiq += 1;
            flags >>= 1;
        }

        if (fiq > MAXFIQNUM)
            break;

        /*
        ** Get the vector and process the interrupt.
        */
        action = &uHALv_FIQVector[fiq];

        if (action->handler == NULL)
            uHALir_UnexpectedFIQ(fiq);
        else {
            do {
                /*
                ** Process multiple handlers if they exist.
                */
                action->handler(fiq);
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
} /* DispatchFIQ */


/*
 * Called once on start-up by projects which require one or more special
 * FIQ routines. 
 *	Start is the address of a routine called at the start of every FIQ.
 *	Finish is the address of a routine called at the end of every FIQ.
 *	 If Finish wants to do really low-level stuff (such as context
 *	 switch etc.), the FIQ routine will jump to the returned value
 *	 (if non-zero). 
 *	Trap is the address of the routine if you want to completely
 *	 replace the routine vectored to by FIQ.
 */
void uHALr_DefineFIQ(PrVoid Start, PrPrVoid Finish, PrVoid Trap)
{
	/* These vectors can be zero'd if required */
	uHALp_StartFIQ = Start;
	uHALp_FinishFIQ = Finish;

	/* Only setup the FIQ vector if it isn't zero */
	if (Trap != NULL)
		uHALp_VectorFIQ = Trap;

	/* Call NewFIQ to install the new FIQ */
}

/* Called once on start-up to initialise data structures & interrupt routines */
void uHALr_InitFIQ(void)
{
int	i ;

	/* ---- soft vectors ---------------------------------------------- */
	for (i = 0 ; i < MAXFIQNUM ; i++) {
		uHALir_MaskFiq(i) ;
		uHALv_FIQVector[i].flags	 = 0 ;
		uHALv_FIQVector[i].handler = (PrHandler)0 ;
		uHALv_FIQVector[i].next	 = NULL ;
		uHALv_FIQVector[i].name	 = 0 ;
	}	
	/* ---- install new trap handlers -------------------------------- */
	uHALp_SavedFIQ = uHALr_NewFIQ(uHALr_DispatchFIQ, uHALp_VectorFIQ) ;
}
               
