/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2002 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     pl192.c,v
 * Revision: 1.11
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : pl192.c.rca
 *  File Revision          : 1.4
 * 
 *  Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
 *  ----------------------------------------
 *
 * Code for the Vectored Interrupt Controller PL192 Module device drivers.
 *
 *
 * IMPORTANT NOTE:
 *
 * The VIC mini-dispatcher (inside pl192wrapper.s) code must have access to static data
 * in order to service interrupts. Therefore the VIC driver always creates static 
 * data irrespective of how apOS_NO_STATIC_STATE is defined.
 *
 */

#include "../apcommon/aptypes.h"
#include "../apcommon/apbitops.h"
#include "../apos/apos.h"
#include "appl192.h"
#include "pl192.h"

/* 
 * Description:
 * Internal state for the interrupt module.
 *
 */

PROTECTED VIC_sIntState VIC_sState;

/* Description:
 * Data shared in both driver and mini-dispatcher
 */

extern UWORD32 apVIC_WrapperStart;
extern UWORD32 apVIC_WrapperEnd;
extern UWORD32 apVIC_VectorRegister;
extern UWORD32 apVIC_NonVectDispatcher;

/*
 * Flag that indicates if this is the first time the driver has been
 * intialised. The driver has data relating to all VICs which must only
 * be intialised once, hence this flag.
 */

PRIVATE BOOL VIC_Initialized_Flag = FALSE;


/*=======================================================================*/
/* Public functions - defines the API to the drivers.                    */
/*=======================================================================*/

/*=See appl192.h for documentation=========================================*/

PUBLIC apError apVIC_Initialize( apOS_VIC_oId                    oId,
                                 apOS_System_eBaseAddress        eBase,
                                 UWORD32                         Interrupts,
                                 CONST apOS_INT_oInterruptSource *pSources,
                                 apVIC_sInitialData              *pInitial )
{
    VIC_sControllerState  *pState;
    VIC_sSourceEntry      *pTable, *pSourceEntry;
    VIC_sSourceParameters *pParams;
    UWORD32 			  I;

    IGNORE( pSources );
    IGNORE( Interrupts );
	IGNORE( pInitial );
	
    /*
     * Check that the controller specified isn't out of the 
     * current implementation's range, currently uses bytes,
     */

    if( ( oId > VIC_MAXIMUM_CONTROLLERS ) || ( oId > 0xFF ) )
    {
        // Return an error.
        
        return apERR_BAD_PARAMETER;
    }

    // Get pointer to this interrupt controller's state.

    pState  = &VIC_sState.sControllers[ oId ];
    pTable  = VIC_sState.sTable;
    pParams = VIC_sState.sParameters;

    // Set up the state structure.(apart from the actual tables).

    pState->Table           = pTable;                     // This copy used by the dispatcher
    pState->LeaveHardware   = FALSE;
    pState->IntRouting      = 0;                          // Mark all sources as IRQ
    pState->pBaseAddress    = (VIC_sRegisters *) eBase;
    pState->pNextController = (VIC_sControllerState *) aNULL;

    // Mark all (IRQ and FIQ) sources as disabled.

    pState->IntEnabled      = 0;
 
    // Link to the dispatcher (PL192WRAPPERS.S).

    {
        extern UWORD32 apVIC_VectorRegister;

#if !(defined(apOS_CONFIG_VIC_0_BLOCKING_MODE) && (apOS_CONFIG_VIC_0_BLOCKING_MODE))

        // For Non-blocking mode link every VIC.

        *(UWORD32 *)(&apVIC_VectorRegister + oId) = (UWORD32) &(((VIC_sRegisters *) eBase)->Address);

#else
        if( oId == apOS_VIC_0 )
        {
            // For VIC 0 Blocking mode link only master VIC #0.

            apVIC_VectorRegister = (UWORD32) &(((VIC_sRegisters *) eBase)->Address);
        }    
#endif  /* !(defined(apOS_CONFIG_VIC_0_BLOCKING_MODE) && (apOS_CONFIG_VIC_0_BLOCKING_MODE)) */
    }

    // Link to the previous VIC, if it's a slave daisy chained.
    
    if( oId > apOS_VIC_0 )
    {
        (pState - 1)->pNextController = pState;
    }
    
    /*
     * Now we shall check that the main interrupt table has been 
     * initialized, and if not, then we'll initialize it.
     */

    if( VIC_Initialized_Flag == FALSE )
    {
        // Set the default Pre and Post Dispatch Handlers.

        VIC_sState.rIRQPreDispatchCode  = (apVIC_rDispatchHandler *) aRNULL;
        VIC_sState.rIRQPostDispatchCode = (apVIC_rDispatchHandler *) aRNULL;

        // Set the fast FIQ - single source entry pointer to aNULL.

        VIC_sState.FIQOnlyEntry = (VIC_sSourceEntry *) aNULL;

        // Set the count of the number of active IRQ / FIQs being serviced to 0.

        VIC_sState.IRQServiceCount = 0;
        VIC_sState.FIQServiceCount = 0;

        // Set a dummy source and handler for all entries.
        // Mark all sources as IRQ and UNUSED and set priorities to the lowest level.
        
        for( I = 0; I <= VIC_MAXIMUM_SOURCES; )
        {
            pSourceEntry = &pTable[ I ];

            pSourceEntry->InterruptType = apVIC_IRQ_VECTORED;
            pSourceEntry->Parameter     = 0;
            pSourceEntry->rHandler      = VIC_DefaultHandler;
            pSourceEntry->oSource       = VIC_UNUSED_SOURCE;
            pParams[ I++ ].Priority     = apVIC_IRQ_LOWEST_PRIORITY;
        }

        // The first source is reserved.

        pTable[ 0 ].oSource   = VIC_DEFAULT_SOURCE;
        pParams[ 0 ].Priority = 0;

        // Set the table initialized flag.

        VIC_Initialized_Flag = TRUE;
    }

    /*
     * Now to actually initialize the hardware.
     */

    // Disable all interrupts

    VIC_DisableAll( (VIC_sRegisters *) eBase );

    /*
     * Generate the (currently empty) dispatch tables for this controller.
     */

    VIC_GenerateTables( (UWORD32) oId );

    // Make sure it's not in test mode by clearing bit 0.
    
    ((VIC_sRegisters *) eBase)->TestCntrl &= ~1;

    // Clear any soft interrupts that might be active.
    
    ((VIC_sRegisters *) eBase)->SoftIntClear = 0xFFFFFFFF;

    // Set all interrupts to be routed to IRQ by default.

    ((VIC_sRegisters *) eBase)->IntSelect = 0x00000000;

    // Set reset value for Software Priority Mask register, VICSWPriorityMask.

    ((VIC_sRegisters *) eBase)->SWPriorityMask = 0x0000FFFF;

    // Set reset value for Vector Priority for Daisy Chain register, VICVectPriorityDaisy.

    ((VIC_sRegisters *) eBase)->VectPriorityDaisy = 0x0000000F;

    // Make sure the VIC internal interrupt logic is cleared - in case
    // it 'thinks' its currently handling an interrupt, otherwise it
    // won't raise any lower priority interrupts. Since the worst case
    // would be that it currently 'thinks' it is handling all of the
    // interrupt sources, this code has to behave as if all interrupts
    // are active.

    ((VIC_sRegisters *) eBase)->Address = 0;

    for( I = 1; I < VIC_NUM_INT_SOURCES; I++ )
    {
        // Read the vector address to tell the VIC we're handling the interrupt.
        // Write to the vector address, to tell the VIC we've handled the interrupt.

        ((VIC_sRegisters *) eBase)->Address = ((VIC_sRegisters *) eBase)->Address;
    }

    return apERR_NONE;
}

/*=See appl192.h for documentation=========================================*/

PUBLIC apError apVIC_PrioritySet( CONST apOS_INT_oInterruptSource oSource, 
                                  apVIC_eInterruptType            eType,
                                  UBYTE8                          Priority )
{
    UWORD32 			  Index, Controller;
    VIC_sControllerState  *pState;
    apVIC_eInterruptType  InterruptType;
    
    if( VIC_sState.IRQServiceCount || VIC_sState.FIQServiceCount )
    {
        apDEBUG_CRIT( "VIC - apVIC_PrioritySet() - "
                      "Called from an interrupt handler with "
                      "Source set to 0x%0lX\n", (UWORD32) oSource );

        // Return an error.

        return (apError) apERR_VIC_BAD_CALL;
    }

    // First find the right source entry.
    // It must be exactly oSource as Priority can be set up only for registered sources.

    if( !(UWORD32)(Index = VIC_FindSource( oSource )) )
    {
        // Entry not found. Return error code.
    
        apDEBUG_CRIT( "VIC - apVIC_PrioritySet() - "
                      "Unable to find entry for source 0x%0X\n",
                      oSource );

        return (apError) apERR_VIC_SOURCE_NOT_FOUND;
    }

    Controller    = VIC_ControllerGet( oSource );
    pState        = &VIC_sState.sControllers[ Controller ];
    InterruptType = VIC_sState.sTable[ Index ].InterruptType;
      
    // Check if it was an attepmt to change type of Raw interrupt source to
    // any other type. If so, return an error.
            
    if( (InterruptType == apVIC_IRQ_RAW) && (eType != apVIC_IRQ_RAW) )
    {
        return (apError) apERR_VIC_BAD_INT_TYPE;
    }

	// Check Priority parameter.
	
	if( ( Priority > apVIC_FIQ_LOWEST_PRIORITY ) ||
	   (( Priority > apVIC_IRQ_LOWEST_PRIORITY ) && ( eType != apVIC_FIQ )) )
	{
		return (apError) apERR_VIC_BAD_PRIORITY;		
	}	
	
    // Temporarily disable this interrupt source for the duration of
    // this call - must remember what was enabled.
    
    VIC_DisableAll( pState->pBaseAddress );

    // Set Interrupt type and Priority.

    VIC_sState.sTable[ Index ].InterruptType = eType;                
    VIC_sState.sParameters[ Index ].Priority = Priority;
  
    // Re-order the dispatch tables, this disables all interrupts
    // (again) and re-enables ALL software enabled interrupts
    // when its finished.
    
    VIC_GenerateTables( Controller );

    return apERR_NONE;
}

/*=See appl192.h for documentation=========================================*/

PUBLIC apError apVIC_PriorityGet( CONST apOS_INT_oInterruptSource oSource, 
                                  apVIC_eInterruptType            *pType,
                                  UBYTE8                          *Priority )
{
    UWORD32 Index;
    
    // First find the right source entry.
    // It must be exactly oSource as Priority can be got only for registered sources.

    if( !(UWORD32)(Index = VIC_FindSource( oSource )) )
    {
        // Entry not found. Return error code.
    
      apDEBUG_CRIT( "VIC - apVIC_PriorityGet() - "
                    "Unable to find entry for source 0x%0X\n",
                    oSource );

        return (apError) apERR_VIC_SOURCE_NOT_FOUND;
    }

    // Get Interrupt type and Priority

    *pType    = VIC_sState.sTable[ Index ].InterruptType;                
    *Priority = VIC_sState.sParameters[ Index ].Priority;

    return apERR_NONE;
}

/*=See appl192.h for documentation=========================================*/

PUBLIC apError apVIC_PriorityMaskSet( apOS_VIC_oId oId,
                                      UHWD16       Mask )
{
    VIC_sControllerState  *pState;

    /*
     * Check that the controller specified isn't out of the 
     * current implementation's range, currently uses bytes,
     */

    if( ( oId > VIC_MAXIMUM_CONTROLLERS ) || ( oId > 0xFF ) )
    {
        // Return an error.
        
        return apERR_BAD_PARAMETER;
    }

    // Get pointer to this interrupt controller's state.

    pState  = &VIC_sState.sControllers[ oId ];

    // Program Software priority mask of the specified interrupt controller.

    (pState->pBaseAddress)->SWPriorityMask = (UWORD32) Mask;

    return apERR_NONE;
}

/*=See appl192.h for documentation=========================================*/

PUBLIC apError apVIC_PriorityMaskGet( apOS_VIC_oId oId,
                                      UHWD16       *pMask )
{
    VIC_sControllerState  *pState;

    /*
     * Check that the controller specified isn't out of the 
     * current implementation's range, currently uses bytes,
     */

    if( ( oId > VIC_MAXIMUM_CONTROLLERS ) || ( oId > 0xFF ) )
    {
        // Return an error.
        
        return apERR_BAD_PARAMETER;
    }

    // Get pointer to this interrupt controller's state.

    pState  = &VIC_sState.sControllers[ oId ];

    // Return Software priority mask of the specified interrupt controller.

    *pMask = (UHWD16) (pState->pBaseAddress)->SWPriorityMask;

    return apERR_NONE;
}

/*=See appl192.h for documentation=========================================*/

PUBLIC apError apVIC_PriorityDaisySet( apOS_VIC_oId oId,
                                       UBYTE8       Priority )
{
    VIC_sControllerState  *pState;

    /*
     * Check that the controller specified isn't out of the 
     * current implementation's range, currently uses bytes,
     */

    if( ( oId > VIC_MAXIMUM_CONTROLLERS ) || ( oId > 0xFF ) )
    {
        // Return an error.
        
        return apERR_BAD_PARAMETER;
    }

	// Check Priority parameter.
	
	if( Priority > apVIC_IRQ_LOWEST_PRIORITY )
	{
		return (apError) apERR_VIC_BAD_PRIORITY;		
	}	
	
    // Get pointer to this interrupt controller's state.

    pState  = &VIC_sState.sControllers[ oId ];

#if (defined(apOS_CONFIG_VIC_0_BLOCKING_MODE) && (apOS_CONFIG_VIC_0_BLOCKING_MODE))

    // Check that we don't try to change Priority to the higher value
    // whilst servicing interrupt.
    
    if(( VIC_sState.IRQServiceCount || VIC_sState.FIQServiceCount ) && 
       ( Priority < (UBYTE8) (pState->pBaseAddress)->VectPriorityDaisy) )   
    {
        apDEBUG_CRIT( "VIC - apVIC_PriorityDaisySet() - "
                      "Called from an interrupt handler with "
                      "Priority to be set to 0x%0lX\n", (UWORD32) Priority );

        // Return an error.

        return (apError) apERR_VIC_BAD_CALL;
    }
    
#endif  /* (defined(apOS_CONFIG_VIC_0_BLOCKING_MODE) && (apOS_CONFIG_VIC_0_BLOCKING_MODE)) */

    // Program Vector Priority for Daisy Chain register.

    (pState->pBaseAddress)->VectPriorityDaisy = Priority;

    return apERR_NONE;
}

/*=See appl192.h for documentation=========================================*/

PUBLIC apError apVIC_PriorityDaisyGet( apOS_VIC_oId oId,
                                       UBYTE8       *pPriority )
{
    VIC_sControllerState  *pState;

    /*
     * Check that the controller specified isn't out of the 
     * current implementation's range, currently uses bytes,
     */

    if( ( oId > VIC_MAXIMUM_CONTROLLERS ) || ( oId > 0xFF ) )
    {
        // Return an error.
        
        return apERR_BAD_PARAMETER;
    }

    // Get pointer to this interrupt controller's state.

    pState  = &VIC_sState.sControllers[ oId ];

    // Return Program Vector Priority for Daisy Chain register value.

    *pPriority = (UBYTE8) (pState->pBaseAddress)->VectPriorityDaisy;

    return apERR_NONE;
}

/*=See appl192.h for documentation=========================================*/

PUBLIC apError apVIC_InterruptEnable( CONST apOS_INT_oInterruptSource oSource )
{
    VIC_sControllerState *pState = &VIC_sState.sControllers[ VIC_ControllerGet( oSource ) ];

#ifdef apDEBUG_ENABLED  /* Only do validation when compiled with debug on */
    {
    UWORD32 Index;
  
    // Check for a registered interrupt handler.

    if( !(UWORD32)(Index = VIC_FindSource( oSource )) )
    {
        apDEBUG_CRIT( "VIC - apVIC_InterruptEnable() - "
                      "Unable to find entry for source 0x%0X\n",
                      oSource );

        // Return an error.
        
        return apERR_BAD_PARAMETER;
    }
    
    if( VIC_sState.sTable[ Index ].rHandler == VIC_DefaultHandler )
    {
        apDEBUG_CRIT( "VIC - apVIC_InterruptEnable() - "
                      "Handler fn ptr set to NULL for source 0x%0X\n",
                      oSource );

        // Return an error.

        return apERR_BAD_PARAMETER;
    }
    }
#endif

    /* 
     * To ensure that no interrupt goes off in the middle while we are
     * changing the enabled interrupts (between reading the old version
     * and writing the new version) then we must disable all interrupts
     * for the duration of this exercise. If the controller is disabled
     * already then we can still do the disable call to make sure, we
     * just mustn't re-enable afterwards.
     */

    VIC_DisableAll( pState->pBaseAddress );

    /* Enable the interrupt bit in software */

    pState->IntEnabled |= VIC_MaskGet( oSource );

    /*
     * Re-enable the interrupts
     */

    if( !pState->LeaveHardware )     
    {
        VIC_ReEnable( pState->pBaseAddress, pState );
    }
    
    return apERR_NONE;
}

/*=See appl192.h for documentation=========================================*/

PUBLIC void apVIC_InterruptDisable( CONST apOS_INT_oInterruptSource oSource )
{
    VIC_sControllerState *pState = &VIC_sState.sControllers[ VIC_ControllerGet( oSource ) ];

    /* 
     * To ensure that no interrupt goes off in the middle while we are
     * changing the enabled interrupts (between reading the old version
     * and writing the new version) then we must disable all interrupts
     * for the duration of this exercise. If the controller is disabled
     * already then we can still do the disable call to make sure, we
     * just mustn't re-enable afterwards.
     */

    VIC_DisableAll( pState->pBaseAddress );

    /* Disable the interrupt bit in software */

    pState->IntEnabled &= ~VIC_MaskGet( oSource );

    /*
     * Re-enable the interrupts (if not disabled)
     */

    if( !pState->LeaveHardware )
    {
       VIC_ReEnable( pState->pBaseAddress, pState );
    }
}

/*=See appl192.h for documentation=========================================*/

/* 
 * This would normally be done by accessing the IF bits in the 
 * ARM core's mode control register, however this requires
 * us to be in a priviledged processor mode, and guaranteeing
 * that is a bit messy, so we'll just keep track of what we
 * have disabled.
 *
 * NOTE:    We set LeaveHardware AFTER disabling all interrupts - this
 *          prevents interrupt code clearing LeaveHardware before the
 *          function exits.
 *
 * Note:    This is the only function that directly sets 'LeaveHardware' to
 *          TRUE. It is PUBLIC so could be called by external functions,
 *          however it is only called within this module by :
 *
 *              VIC_GenerateTables()
 */

PUBLIC void apVIC_ControllerDisable( apOS_VIC_oId oId )
{
    VIC_sControllerState *pState = &VIC_sState.sControllers[ oId ];

    VIC_DisableAll( pState->pBaseAddress );

    pState->LeaveHardware = TRUE;
}

/*=See appl192.h for documentation=========================================*/

/* 
 * This would normally be done by accessing the IF bits in the 
 * ARM core's mode control register, however this requires
 * us to be in a priviledged processor mode, and guaranteeing
 * that is a bit messy, so we'll just keep track of what we
 * have disabled. 
 */

PUBLIC void apVIC_ControllerRestore( apOS_VIC_oId oId )
{
    VIC_sControllerState *pState = &VIC_sState.sControllers[ oId ];

    pState->LeaveHardware = FALSE;

    VIC_ReEnable( pState->pBaseAddress, pState );
}

/*=See appl192.h for documentation=========================================*/

/*
 * Clears the specified interrupt source by clearing VIC harware interrupt priority logic.
 * Should be called only at the end of Raw interrupt handler.
 */

PUBLIC void apVIC_InterruptClear( apOS_VIC_oId oId )
{
    // Indicate to the priority hardware that interrupt has been serviced.

    VIC_sState.sControllers[ oId ].pBaseAddress->Address = 0;
}
 
/*=See appl192.h for documentation=========================================*/

PUBLIC apError apVIC_HandlerSet( CONST apOS_INT_oInterruptSource oSource, 
                                 apOS_INT_rServiceRoutine        rHandler,
                                 UWORD32                         Parameter )
{
    UWORD32           Index;
    VIC_sSourceEntry  *pSourceEntry;

    if( VIC_sState.IRQServiceCount || VIC_sState.FIQServiceCount )
    {
        apDEBUG_CRIT( "VIC - apVIC_HandlerSet() - "
                      "Called from an interrupt handler with "
                      "Source set to 0x%0X\n", oSource );

        // Return an error.

        return (apError) apERR_VIC_BAD_CALL;
    }
   
    // Register the handler.
    // First find the right source entry, and update it.

    if( !(UWORD32)(Index = VIC_FindEntry( oSource )) )
    {
        // Entry not found. Return an error.
            
        return (apError) apERR_VIC_SOURCE_NOT_FOUND;
    }

    pSourceEntry = &VIC_sState.sTable[ Index ];
    
    // Set up IRQ Vectored Interrupt type, Source, Parameter and Interrupt Handler.

    pSourceEntry->InterruptType = apVIC_IRQ_VECTORED;
    pSourceEntry->oSource       = oSource;
    pSourceEntry->Parameter     = Parameter;
    pSourceEntry->rHandler      = rHandler;

    // Set up default lowest Priority
    
    VIC_sState.sParameters[ Index ].Priority = apVIC_IRQ_LOWEST_PRIORITY;
       
    // This will require a forced re-generation of 
    // the dispatcher's indirection tables.
    
    VIC_GenerateTables( VIC_ControllerGet( oSource ) );

    return apERR_NONE;
}

/*=See appl192.h for documentation=========================================*/

PUBLIC apError apVIC_RawHandlerSet( CONST apOS_INT_oInterruptSource oSource, 
                                    apOS_INT_rRawISR                rRawHandler )
{
    UWORD32           Index;
    VIC_sSourceEntry  *pSourceEntry;
    
    if( VIC_sState.IRQServiceCount || VIC_sState.FIQServiceCount )
    {
        apDEBUG_CRIT( "VIC - apVIC_HandlerSet() - "
                      "Called from an interrupt handler with "
                      "Source set to 0x%0X\n", oSource );

        // Return an error.

        return (apError) apERR_VIC_BAD_CALL;
    }

    // Register the handler.
    // First find the right source entry, and update it.
    
    if( !(UWORD32)(Index = VIC_FindEntry( oSource)) )
    {
        // Interrupt source not found.
    
        return (apError) apERR_VIC_SOURCE_NOT_FOUND;
    }
        
    pSourceEntry = &VIC_sState.sTable[ Index ];
    
    // Set up Raw Interrupt type, Source and Raw Interrupt Handler.
     
    pSourceEntry->InterruptType = apVIC_IRQ_RAW;
    pSourceEntry->oSource       = oSource;
    pSourceEntry->Parameter     = 0;
    pSourceEntry->rHandler      = (apOS_INT_rServiceRoutine) rRawHandler;

    // Set up default lowest Priority

    VIC_sState.sParameters[ Index ].Priority = apVIC_IRQ_LOWEST_PRIORITY;

    // This will require a forced re-generation of 
    // the dispatcher's indirection tables.
    
    VIC_GenerateTables( VIC_ControllerGet( oSource ) );
    
    return apERR_NONE;
}

/*=See appl192.h for documentation=========================================*/

PUBLIC apError apVIC_HandlerClear( CONST apOS_INT_oInterruptSource oSource )
{
    UWORD32               Index, Mask;
    VIC_sSourceEntry      *pSourceEntry;
    VIC_sSourceParameters *pParams = VIC_sState.sParameters;   
    VIC_sControllerState  *pState  = &VIC_sState.sControllers[ VIC_ControllerGet( oSource ) ];
    VIC_sRegisters        *pBase   = pState->pBaseAddress;

    // First find the right source entry.

    if( !(UWORD32)(Index = VIC_FindSource( oSource )) )
    {
        // Interrupt source not found
    
        return (apError) apERR_VIC_SOURCE_NOT_FOUND;
    }        
   
    // Disable the interrupt source

    apVIC_InterruptDisable( oSource );

    // Get interrupt mask of the found source
    
    Mask = VIC_MaskGet( oSource );

    pSourceEntry = &VIC_sState.sTable[ Index ];
    
    // Mark it as Vectored Interrupt source

    pSourceEntry->InterruptType = apVIC_IRQ_VECTORED;

    // Mark this entry as cleared

    pSourceEntry->oSource = VIC_CLEARED_SOURCE;
        
    // Set the handler to be the default.
    // We don't have to regenerate the table.
        
    pSourceEntry->rHandler = VIC_DefaultHandler;
  
    // Set parameter to 0.
        
    pSourceEntry->Parameter = 0;
        
    // Set priority to the lowest.
        
    pParams[ Index ].Priority = apVIC_IRQ_LOWEST_PRIORITY;
   
    // Reset the interrupt type to IRQ.

    pState->IntRouting &= ~Mask;

    pBase->IntSelect = pState->IntRouting;

    return  apERR_NONE;
}

/*=See appl192.h for documentation==========================================*/

PUBLIC void apVIC_ProgrammedInterruptSet( CONST apOS_INT_oInterruptSource oSource )
{
    // The source passed must be any of bits 0 to 3 for the bottom core 
    // module (and going up in four bit chunks for each of the stacked
    // modules).

    VIC_sState.sControllers[ VIC_ControllerGet( oSource ) ].pBaseAddress->SoftInt = VIC_MaskGet( oSource );
}

/*=See appl192.h for documentation==========================================*/

PUBLIC void apVIC_ProgrammedInterruptClear( CONST apOS_INT_oInterruptSource oSource )
{
    // Clear programmed interrupt

    VIC_sState.sControllers[ VIC_ControllerGet( oSource ) ].pBaseAddress->SoftIntClear = VIC_MaskGet( oSource );
}

/*=See appl192.h for documentation==========================================*/

PUBLIC UWORD32 apVIC_GetInterruptStatus( apOS_VIC_oId oId )
{
    // Read Raw Interrupt Status Register.
    // This will give the status of the interrupts before masking.

    return VIC_sState.sControllers[ oId ].pBaseAddress->RawIntr;
}

/*=See appl192.h for documentation==========================================*/

PUBLIC void apVIC_IRQPreDispatchSet( apVIC_rDispatchHandler rPreDispatchHandler )
{
#if defined( apOS_CONFIG_VIC_USE_PREDISPATCH_CODE ) && apOS_CONFIG_VIC_USE_PREDISPATCH_CODE
    VIC_sState.rIRQPreDispatchCode = rPreDispatchHandler;
#else
    IGNORE( rPreDispatchHandler );
#endif
}

/*=See appl192.h for documentation==========================================*/

PUBLIC void apVIC_IRQPostDispatchSet( apVIC_rDispatchHandler rPostDispatchHandler )
{
#if defined( apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE ) && apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE
    VIC_sState.rIRQPostDispatchCode = rPostDispatchHandler;
#else
    IGNORE( rPostDispatchHandler );
#endif
}

/*=See appl192.h for documentation==========================================*/

PUBLIC apError apVIC_SingleFIQSourceSet( CONST apOS_INT_oInterruptSource oSource )
{
#if defined( apOS_CONFIG_VIC_SINGLE_FIQ ) && apOS_CONFIG_VIC_SINGLE_FIQ
    UWORD32             Index;
    VIC_sSourceEntry    *pSourceEntry;

    if( VIC_sState.IRQServiceCount || VIC_sState.FIQServiceCount )
    {
        apDEBUG_CRIT( "VIC - apVIC_HandlerSet() - "
                      "Called from an interrupt handler with "
                      "Source set to 0x%0X\n", oSource );

        // Return an error.

        return (apError) apERR_VIC_BAD_CALL;
    }

    // First find the right source entry.

    if( !(UWORD32)(Index = VIC_FindSource( oSource )) )
    {
        // Interrupt source not found.
    
        return (apError) apERR_VIC_SOURCE_NOT_FOUND;
    }        
   
    pSourceEntry = &VIC_sState.sTable[ Index ];
    
    // If this interrupt source is not FIQ interrupt, return an error.
        
    if ( pSourceEntry->InterruptType != apVIC_FIQ )
    {
        return (apError) apERR_VIC_BAD_INT_TYPE;
    }
            
    // Disable the interrupt source.

    apVIC_InterruptDisable( oSource );

    // Set up the pointer.
    
    VIC_sState.FIQOnlyEntry = pSourceEntry;    
   
    // Reenable the interrupt source.

    apVIC_InterruptEnable( oSource );

#else
    IGNORE( oSource );
#endif
    return  apERR_NONE;
}    

/*=See appl192.h for documentation==========================================*/

PUBLIC void apVIC_SingleFIQSourceClear( void )
{
#if defined( apOS_CONFIG_VIC_SINGLE_FIQ ) && apOS_CONFIG_VIC_SINGLE_FIQ

    // Clear the pointer
    
    VIC_sState.FIQOnlyEntry = NULL;    
#endif
}

/*=======================================================================*/
/* Private functions - only used within this module                      */
/*=======================================================================*/

/* ----- See pl192.h for documentation--------------*/

INLINE PRIVATE UBYTE8 VIC_ControllerGet( CONST apOS_INT_oInterruptSource oSource )
{
    return (UBYTE8) (((UWORD32) oSource) >> VIC_CTRLR_FIELD_SHIFT);
}

/* ----- See pl192.h for documentation--------------*/

INLINE PRIVATE UWORD32 VIC_MaskGet( CONST apOS_INT_oInterruptSource oSource )
{
    return (UWORD32) 1 << (((UWORD32) oSource) & VIC_SOURCE_FIELD_MASK );
}

/* ----- See pl192.h for documentation--------------*/

PRIVATE void VIC_DefaultHandler( CONST apOS_INT_oInterruptSource oSource,
                                 UWORD32                         Parameter )
{
    IGNORE( oSource );
    IGNORE( Parameter );
}

/* ----- See pl192.h for documentation--------------*/

INLINE PRIVATE void VIC_DisableAll( VIC_sRegisters *pBase )
{
   /*
    * Set all the bits in the EnableClear register
    */

    pBase->IntEnClear =  0xFFFFFFFF;
    
#if( VIC_SLOW_CONTROLLER )

    (void) pBase->IntEnClear;

#endif
}

/* ----- See pl192.h for documentation--------------*/

INLINE PRIVATE void VIC_ReEnable( VIC_sRegisters       *pBase,
                                  VIC_sControllerState *pState )
{
    pBase->IntEnable = pState->IntEnabled;
    
#if( VIC_SLOW_CONTROLLER)

    (void) pBase->IntEnable; 

#endif
}

/* ----- See pl192.h for documentation--------------*/

PRIVATE UWORD32 VIC_FindSource( CONST apOS_INT_oInterruptSource oSource )
{
    UWORD32 I, Source;
    
    // Go through each entry in the table and compare it to the one we have.
    // Remember that the first one is reserved for the default src.
    // If we reach the unused entry then we haven't found the Source.

    for( I = 1; I <= VIC_MAXIMUM_SOURCES; I++ )
    {
        Source = VIC_sState.sTable[ I ].oSource;
    
        if ( Source == oSource )
        {
            // Entry found. Return found index.

            return I;
        }

        if( Source == VIC_UNUSED_SOURCE )
        {
            // Source not found, return zero index.

            return 0;
        }    
    }

    // Source not found, return zero index.
                    
    return 0;
}

/* ----- See pl192.h for documentation--------------*/

PRIVATE UWORD32 VIC_FindEntry( CONST apOS_INT_oInterruptSource oSource )
{
    UWORD32 I, Source;

    // Go through each entry in the table and compare it to the one we have.
    // Remember that the first one is reserved for the default src.
    // If we reach the unused or cleared entry then use it.
    // We don't create an entry in the table for this source, it will be done
    // by calling fuction if it's needed.

    for( I = 1; I <= VIC_MAXIMUM_SOURCES; I++ )
    {
        Source = VIC_sState.sTable[ I ].oSource;
        
        if( (Source == oSource) || (Source == VIC_UNUSED_SOURCE) || (Source == VIC_CLEARED_SOURCE) )
        {
            // Return found index.

            return I;
        }
    }
   
    // Entry not found, return zero index.

    return 0;
}

/* ----- See pl192.h for documentation--------------*/

PRIVATE void VIC_GenerateTables( UWORD32 Controller )
{
    UWORD32 I, J, K, NumMinusOne, Number = 0;
    UWORD32 NumVectoredSrcs = 0;
    UWORD32 VectoredSrcMask = 0;
    UWORD32 IntRouting      = 0;
    UWORD32 TempMasks[ NUM_PRIORITY_ENCODED_MASKS ], Mask;
    UBYTE8  TempTable[ VIC_NUM_INT_SOURCES ], T1, T2;

    VIC_sSourceParameters VectoredPriority[ VIC_NUM_VECTOR_REGISTERS ];
    VIC_sSourceParameters *pTempParameters;    
    VIC_sSourceEntry      *VectoredSrcAddr[ VIC_NUM_VECTOR_REGISTERS ];
    VIC_sSourceEntry      *pTempEntry;
    VIC_sControllerState  *pState = &VIC_sState.sControllers[ Controller ];   /* Ptr to appropriate ctrlr record */
    VIC_sRegisters        *pBase = pState->pBaseAddress;
       
    BOOL StillSwapping = TRUE;

    UWORD32 Wrap_Offset = Controller * VIC_NUM_VECTOR_REGISTERS;

    UWORD32 WRAP_SEGMENT_LENGTH = ((UWORD32)(&apVIC_WrapperEnd - &apVIC_WrapperStart)+4)/(VIC_NUM_VECTOR_REGISTERS*apOS_CONFIG_VIC_NUMBER);    

    // First initialize an indirection table, which will
    // hold the index of all of the registered interrupt sources
    // for the specified controller.

    for( I = 0; I < VIC_NUM_INT_SOURCES; )
    {
        TempTable[ I++ ] = 0;
    }  

    // Then initialize the Priority Encoded Masks

    for( I = 0; I < NUM_PRIORITY_ENCODED_MASKS; )
    {
        TempMasks[ I++ ] = 0;
    }
    
    // Now search all the registered interrupt sources, 
    // and put the index of each that is on the specified ctrlr
    // into our temp table. Simultaneously find out how many FIQs
    // there are and keep track of the address of the FIQ source
    // entry.

    for( I = 1; I <= VIC_MAXIMUM_SOURCES; I++ )
    {

        if( VIC_sState.sTable[ I ].oSource == VIC_UNUSED_SOURCE )
        {
            // No more, so terminate this for loop
            
            break;  
        }
        else
        {
            // Cleared or empty interrupt entries have rHandler = VIC_DefaultHandler
            
            if( VIC_sState.sTable[ I ].rHandler != VIC_DefaultHandler )
            {
                // Check if this Src Entry is for the specified ctrlr
    
                if( Controller == VIC_ControllerGet((apOS_INT_oInterruptSource) VIC_sState.sTable[ I ].oSource) )
                {
                    if( Number < VIC_NUM_INT_SOURCES )
                    {
                        TempTable[ Number++ ] = (UBYTE8) I;
                    }
                    else
                    {
                        apDEBUG_CRIT( "VIC - VIC_GenerateTables() - "
                                      "Too many Int Srcs for ctrlr %ld\n",
                                      Controller );
                   }
                }
            }
        }
    }

    // Now to order the indirection table, in priority order.
    // Unregistered interrupts are passed to the first entry 
    // in the main interrupt table which contains dummy actions.
    // The sorting algorithm here is not pretty, and could do 
    // with optimising at some point.

    if( Number )
    {
        NumMinusOne = Number - 1;

        for( I = 0; StillSwapping && ( I < NumMinusOne ); I++ )
        {
            StillSwapping = FALSE;
    
            // Push the worst entry to the end
    
            for( J = 0; J < ( NumMinusOne - I ); J++ )
            {
                T1 = TempTable[ J ];
                T2 = TempTable[ J + 1 ];
    
                if( !T2 )
                {
                    // Index T2 is zero - which is the default entry
                    // which means we've reached the end of the valid
                    // entries in the TempTable[] so might as well
                    // BREAK out of this loop here. Although we should
                    // never have got to this entry since we only 
                    // traverse as far as entry NumMinusOne.
    
                    break;
                }
    
                if( VIC_sState.sParameters[ T1 ].Priority > VIC_sState.sParameters[ T2 ].Priority )
                {
                    TempTable[ J ]     = T2;
                    TempTable[ J + 1 ] = T1;
                    StillSwapping      = TRUE;
                }
            }
        }

        // Now to create the five dispatch masks from the above prioritised
        // indirection table, and simultaneously work out which are the 
        // vectored IRQ sources.

        for( I = 0; I < Number; I++ )
        {
            pTempEntry      = &VIC_sState.sTable[ TempTable[ I ] ];
            pTempParameters = &VIC_sState.sParameters[ TempTable[ I ] ];   
            
            Mask = VIC_MaskGet( (apOS_INT_oInterruptSource) pTempEntry->oSource );
        
            // Now determine what type of interrupt it is.
        
            if( pTempEntry->InterruptType != apVIC_FIQ )
            {
                // This one can be a Vectored or Raw.

                VectoredPriority[ NumVectoredSrcs ].Priority = pTempParameters->Priority;
                VectoredSrcAddr[ NumVectoredSrcs ] = pTempEntry;
                VectoredSrcMask |= Mask;
                NumVectoredSrcs++;
            }
            else
            {
                // This one is FIQ.

                // Update the software stored types.
    
                IntRouting |= Mask;

                if( ( I & 0x10 ) == 0 )
                {
                    TempMasks[ 0 ] |= Mask;
                }
                if( ( I & 0x08 ) == 0 )
                {
                    TempMasks[ 1 ] |= Mask;
                }
                if( ( I & 0x04 ) == 0 )
                {
                    TempMasks[ 2 ] |= Mask;
                }
                if( ( I & 0x02 ) == 0 )
                {
                    TempMasks[ 3 ] |= Mask;
                }
                if( ( I & 0x01 ) == 0 )
                {
                    TempMasks[ 4 ] |= Mask;
                }    
            }
        }
    }

    // Now we have built the tables, we need to turn off interrupts 
    // whilst we copy them over the real ones.

    VIC_DisableAll( pBase );
    
    for( I = 0; I < VIC_NUM_INT_SOURCES; I++ )
    {
        VIC_sState.sControllers[ Controller ].Indices[ I ] = TempTable[ I ];
    }
    
    for( I = 0; I < NUM_PRIORITY_ENCODED_MASKS; I++ )
    {
        VIC_sState.sControllers[ Controller ].Masks[ I ] = TempMasks[ I ];
    }

    // Update IntRouting

    pState->IntRouting = IntRouting;

    // Now change the routing (to IRQ or FIQ) in hardware
    
    pBase->IntSelect = IntRouting;

    // And now we copy the SrcTable or Interrupt Handler to the vector registers

    for( I = 0; I < VIC_NUM_VECTOR_REGISTERS; )
    {
        // Program all Vector Adress and Vector Priority registers as unused.
    
        pBase->VectAddr[ I ]       = 0;
        pBase->VectPriority[ I++ ] = apVIC_IRQ_LOWEST_PRIORITY;
    }

    // Now program Vector Adress and Vector Priority registers for used interrupt sources.

    for( I = 0; I < NumVectoredSrcs; I++ )
    {
        K = VectoredSrcAddr[ I ]->oSource & VIC_SOURCE_FIELD_MASK;
        
        J = K + Wrap_Offset;

        // Program Vector Priority registers, converting Priority values.

        pBase->VectPriority[ K ] = (UWORD32) VectoredPriority[ I ].Priority;

        // Determine what type of interrupt: Vectored or Raw it is.

        if( VectoredSrcAddr[ I ]->InterruptType == apVIC_IRQ_VECTORED )
        {
            // It is Vectored. Set up parameters that will be passed to the handler.
            
            pBase->VectAddr[ K ] = (UWORD32) (&apVIC_WrapperStart + (J++)*WRAP_SEGMENT_LENGTH);
            *(UWORD32*)(&apVIC_WrapperStart+J*WRAP_SEGMENT_LENGTH-3)=(UWORD32)VectoredSrcAddr[ I ]->oSource;
            *(UWORD32*)(&apVIC_WrapperStart+J*WRAP_SEGMENT_LENGTH-2)=(UWORD32)VectoredSrcAddr[ I ]->Parameter;
            *(UWORD32*)(&apVIC_WrapperStart+J*WRAP_SEGMENT_LENGTH-1)=(UWORD32)VectoredSrcAddr[ I ]->rHandler;
        }
        else
        {
            // It is Raw. Parameters won't be passed to the handler.
    
            pBase->VectAddr[ K ] = (UWORD32) (VectoredSrcAddr[ I ]->rHandler);
        }
    }                

    // Re-enable interrupts.

    if( !pState->LeaveHardware )
    {
       VIC_ReEnable( pBase, pState );
    }
} 
