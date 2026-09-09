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
 * File:     inttst.c,v
 * Revision: 1.29
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : inttst.c.rca
 *  File Revision          : 1.8
 * 
 *  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
 *  ----------------------------------------
 *
 * Test code for the INTC (Interrupt Controller) code.
 */

/*
 * --------Included Headers--------
 * These headers assume a search path including the parent directory
 * for this source file.
 */
#include "../apcommon/aptypes.h"
#include "../aptest/aptest.h"            /*Test header*/
#include "apint.h"                     /*API (public) header*/

PROTECTED apTEST_eResult apINT_Test (void);

/*
 * Description:
 * Forward declaration of protected items
 */
PROTECTED apTEST_eResult apINT_SelfTest( UWORD32                                 Id,
                                         UWORD32                                 RegBase,
                                         UWORD32                                 NumSources,
                                         CONST apOS_INT_oInterruptSource * CONST Int );

PRIVATE volatile BOOL    INT_ProgrammedInterruptTest;

#if (( defined apOS_CONFIG_INT_USE_PREDISPATCH_CODE ) && apOS_CONFIG_INT_USE_PREDISPATCH_CODE )
extern apINT_rDispatchHandler apINT_IRQPreDispatchCode;
#endif

#if (( defined apOS_CONFIG_INT_USE_POSTDISPATCH_CODE ) && apOS_CONFIG_INT_USE_POSTDISPATCH_CODE )
extern apINT_rDispatchHandler apINT_IRQPostDispatchCode;
#endif

/*
 * Description:
 * Test interrupt handler. Clears the interrupt, and sets a flag 
 * to indicate an interrupt has occurred.
 *
 */
PRIVATE void apINT_ProgrammedHandler( CONST apOS_INT_oInterruptSource eSource,
                                      UWORD32                         Parameter )
{
  IGNORE(eSource);
  IGNORE(Parameter);

  INT_ProgrammedInterruptTest = TRUE;
  apINT_ProgrammedInterruptClear( apOS_INT_PROGRAMMED );  
}


PROTECTED apTEST_eResult apINT_Test (void)
{
    UWORD32 Delay = 1000000;    /* an arbitrary delay within which the interrupt will have occurred */

    // Enable IRQ interrupts (possibly a bit early, but its a test).
    apOS_CoreIRQEnable();

    //Enable FIQ interrupts unless they are handled by a vectored interrupt controller
#if apINT_VERSION != apVERSION_VIC_ON_LM
    apOS_CoreFIQEnable();
#endif
    
    INT_ProgrammedInterruptTest = FALSE;
    apINT_HandlerSet( apOS_INT_PROGRAMMED, apINT_ProgrammedHandler, 0 );
    apINT_InterruptEnable( apOS_INT_PROGRAMMED );
    apINT_ProgrammedInterruptSet( apOS_INT_PROGRAMMED );
    
    while ( Delay && !INT_ProgrammedInterruptTest)
    {
        Delay--;
    }

    apINT_ProgrammedInterruptClear( apOS_INT_PROGRAMMED );  
    
    apTEST_Print( (apTEST_eResult) (Delay?apTEST_PASS:apTEST_FAIL),"Programmed Interrupt" );

    if ( !Delay )
    {
        return apTEST_FAIL;
    }
    
    return apTEST_PASS;
}


/*
 * Description:
 * This is the main test routine. 
 */
PROTECTED apTEST_eResult apINT_SelfTest( UWORD32                                 Id,
                                         UWORD32                                 RegBase,
                                         UWORD32                                 NumSources,
                                         CONST apOS_INT_oInterruptSource * CONST Int )
{
    apINT_sInitialData sInitial;

    IGNORE(Int);
    IGNORE(NumSources);

    // Initialise the interrupt system
    sInitial.eSense   = apINT_DEFAULT_SENSE;
    sInitial.Priority = 16;

    apINT_Initialize( (apOS_INT_oId) Id, (apOS_System_eBaseAddress) RegBase, 0, 0, &sInitial );

#if (( defined apOS_CONFIG_INT_USE_PREDISPATCH_CODE ) && apOS_CONFIG_INT_USE_PREDISPATCH_CODE )
    apINT_IRQPreDispatchSet( apINT_IRQPreDispatchCode );
#endif    

#if (( defined apOS_CONFIG_INT_USE_POSTDISPATCH_CODE ) && apOS_CONFIG_INT_USE_POSTDISPATCH_CODE )
    apINT_IRQPostDispatchSet( apINT_IRQPostDispatchCode );
#endif    

    return apINT_Test();
}



