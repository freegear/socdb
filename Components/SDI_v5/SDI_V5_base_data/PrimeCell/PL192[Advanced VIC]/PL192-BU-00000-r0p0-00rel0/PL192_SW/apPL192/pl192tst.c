/*
 * $Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2002 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     pl192tst.c,v
 * Revision: 1.12
 * ----------------------------------------------------------------
 * $
 *
 * Test code for the VIC (Vectored Interrupt Controller) code.
 * This code relies on there being a VIC on the LM, which
 * is wired up to interrupt source apOS_INT_EXP0 on the
 * integrator interrupt controller.
 *
 */

/*
 * --------Included Headers--------
 * These headers assume a search path including the parent directory
 * for this source file.
 */

#include <string.h>

#include "../apcommon/aptypes.h"
#include "../aptest/aptest.h"           /* Test header */
#include "../apos/apos.h"

#if (apINT_VERSION & apVERSION_VECTORED )

#include "appl192.h"                      /* API (public) header */

// The following macro allows us to include the private header file, without picking up all the
// private function prototypes - which gives us access to some handy constant macros.

#define VIC_NO_PRIVATE_FUNCTION_PROTOTYPES

#include "pl192.h"

// See if the VIC is built to operate re-entrantly (nested interrupts), and if so
// define a handy macro for use later

#ifdef apOS_CONFIG_INT_REENTRANT
    #if( apOS_CONFIG_INT_REENTRANT == 1 )
        #define VIC_NESTED
    #endif
#endif

/*
 * Type definitions
 */ 

typedef struct VIC_xRawEntry
{
    apOS_INT_rRawISR          *rVIC_RawHandler;
    apOS_INT_oInterruptSource oSource;    

} VIC_sRawEntry;

/*
 * Description:
 * Forward declaration of protected items
 */

// Functions

extern IRQ void VIC_RawHandler_0( void );
extern IRQ void VIC_RawHandler_1( void );
extern IRQ void VIC_RawHandler_2( void );
extern IRQ void VIC_RawHandler_3( void );
extern IRQ void VIC_RawHandler_4( void );
extern IRQ void VIC_RawHandler_5( void );
extern IRQ void VIC_RawHandler_6( void );
extern IRQ void VIC_RawHandler_7( void );
extern IRQ void VIC_RawHandler_8( void );
extern IRQ void VIC_RawHandler_9( void );
extern IRQ void VIC_RawHandler_10( void );
extern IRQ void VIC_RawHandler_11( void );
extern IRQ void VIC_RawHandler_12( void );
extern IRQ void VIC_RawHandler_13( void );
extern IRQ void VIC_RawHandler_14( void );
extern IRQ void VIC_RawHandler_15( void );
extern IRQ void VIC_RawHandler_16( void );
extern IRQ void VIC_RawHandler_17( void );
extern IRQ void VIC_RawHandler_18( void );
extern IRQ void VIC_RawHandler_19( void );
extern IRQ void VIC_RawHandler_20( void );
extern IRQ void VIC_RawHandler_21( void );
extern IRQ void VIC_RawHandler_22( void );
extern IRQ void VIC_RawHandler_23( void );
extern IRQ void VIC_RawHandler_24( void );
extern IRQ void VIC_RawHandler_25( void );
extern IRQ void VIC_RawHandler_26( void );
extern IRQ void VIC_RawHandler_27( void );
extern IRQ void VIC_RawHandler_28( void );
extern IRQ void VIC_RawHandler_29( void );
extern IRQ void VIC_RawHandler_30( void );
extern IRQ void VIC_RawHandler_31( void );


extern IRQ void VIC_ChRawHandler_0( void );
extern IRQ void VIC_ChRawHandler_1( void );
extern IRQ void VIC_ChRawHandler_2( void );
extern IRQ void VIC_ChRawHandler_3( void );
extern IRQ void VIC_ChRawHandler_4( void );
extern IRQ void VIC_ChRawHandler_5( void );
extern IRQ void VIC_ChRawHandler_6( void );
extern IRQ void VIC_ChRawHandler_7( void );
extern IRQ void VIC_ChRawHandler_8( void );
extern IRQ void VIC_ChRawHandler_9( void );
extern IRQ void VIC_ChRawHandler_10( void );
extern IRQ void VIC_ChRawHandler_11( void );
extern IRQ void VIC_ChRawHandler_12( void );
extern IRQ void VIC_ChRawHandler_13( void );
extern IRQ void VIC_ChRawHandler_14( void );
extern IRQ void VIC_ChRawHandler_15( void );
extern IRQ void VIC_ChRawHandler_16( void );
extern IRQ void VIC_ChRawHandler_17( void );
extern IRQ void VIC_ChRawHandler_18( void );
extern IRQ void VIC_ChRawHandler_19( void );
extern IRQ void VIC_ChRawHandler_20( void );
extern IRQ void VIC_ChRawHandler_21( void );
extern IRQ void VIC_ChRawHandler_22( void );
extern IRQ void VIC_ChRawHandler_23( void );
extern IRQ void VIC_ChRawHandler_24( void );
extern IRQ void VIC_ChRawHandler_25( void );
extern IRQ void VIC_ChRawHandler_26( void );
extern IRQ void VIC_ChRawHandler_27( void );
extern IRQ void VIC_ChRawHandler_28( void );
extern IRQ void VIC_ChRawHandler_29( void );
extern IRQ void VIC_ChRawHandler_30( void );
extern IRQ void VIC_ChRawHandler_31( void );

#endif /* apINT_VERSION & apVERSION_VECTORED */

// Function Prototypes

PROTECTED apTEST_eResult apVIC_SelfTest( UWORD32 Id,
                                         UWORD32 RegBase,
                                         UWORD32 NumSources,
                                         CONST apOS_INT_oInterruptSource * CONST Int );

#if (apINT_VERSION & apVERSION_VECTORED )

PRIVATE apTEST_eResult VIC_Test( apOS_VIC_oId oId );

PRIVATE apTEST_eResult VIC_TestReEntrant( apOS_VIC_oId oCtrlr, apVIC_eInterruptType eType );

PRIVATE void VIC_CleanUp( apOS_VIC_oId oCtrlr );

PROTECTED void VIC_RecursiveHandler( CONST apOS_INT_oInterruptSource oldSource,
                                     UWORD32                         Parameter );
                                  
PRIVATE INLINE apOS_INT_oInterruptSource VIC_oSourceCreate( apOS_VIC_oId oCtrlr, UWORD32 Src );

PRIVATE INLINE UWORD32 VIC_SourceGet( CONST apOS_INT_oInterruptSource oSource );

PRIVATE INLINE apOS_VIC_oId VIC_ControllerGet( CONST apOS_INT_oInterruptSource oSource );

PRIVATE INLINE UWORD32 VIC_MaskGet( CONST apOS_INT_oInterruptSource oSource );

PRIVATE BOOL VIC_FirstOccurence( CONST apOS_INT_oInterruptSource oSource );

PROTECTED void VIC_ReentrantHandler( CONST apOS_INT_oInterruptSource oldSource,
                                     UWORD32                         Parameter );
                                  
PROTECTED void VIC_FIQReentrantHandler( CONST apOS_INT_oInterruptSource oldSource,
                                        UWORD32                         Parameter );

PRIVATE apTEST_eResult VIC_GeneralTest( apOS_VIC_oId oCtrlr );

PRIVATE apTEST_eResult VIC_GlobalTest( apOS_VIC_oId oMaster, apOS_VIC_oId oSlave );

PRIVATE apTEST_eResult VIC_TestRawReEntrant( apOS_VIC_oId oCtrlr );

PROTECTED void VIC_RawFunction( apOS_INT_oInterruptSource oSource );

PROTECTED void VIC_ChRawFunction( apOS_INT_oInterruptSource oSource );

PROTECTED void VIC_SingleHandler( CONST apOS_INT_oInterruptSource oldSource,
                                  UWORD32                         Parameter );

PRIVATE apTEST_eResult VIC_TestMaskPriority( apOS_VIC_oId oCtrlr );

PRIVATE apTEST_eResult VIC_TestDaisyPriority( apOS_VIC_oId oMaster, apOS_VIC_oId oSlave );

#if (( defined apOS_CONFIG_VIC_USE_PREDISPATCH_CODE ) && apOS_CONFIG_VIC_USE_PREDISPATCH_CODE )
extern apVIC_rDispatchHandler apVIC_IRQPreDispatchCode;
#endif

#if (( defined apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE ) && apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE )
extern apVIC_rDispatchHandler apVIC_IRQPostDispatchCode;
#endif

// Variables

PRIVATE volatile BOOL               VIC_InterruptTestCompleted = FALSE;
PRIVATE BOOL                        VIC_InterruptOccured[VIC_NUM_INT_SOURCES * apOS_CONFIG_VIC_NUMBER];
PRIVATE volatile apOS_VIC_oId       VIC_oTestIntCtrlr;
PRIVATE volatile BOOL               VIC_ReEntrantInts = FALSE;
PRIVATE volatile BOOL               VIC_InterruptTestFailed = FALSE;
PRIVATE apOS_INT_oInterruptSource   VIC_oNextSource;
PRIVATE volatile UWORD32            VIC_InterruptServiced[apOS_CONFIG_VIC_NUMBER];
PRIVATE VIC_sRawEntry               *pRawHandler;
PRIVATE void                       (*pVIC_RawHandler)( CONST apOS_INT_oInterruptSource oldSource,\
                                                       UWORD32                         Parameter );



// Arrays
PRIVATE VIC_sRawEntry VIC_sRawHandlers[] = {
                {(apOS_INT_rRawISR *) &VIC_RawHandler_0,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_1,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_2,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_3,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_4,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_5,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_6,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_7,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_8,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_9,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_10,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_11,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_12,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_13,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_14,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_15,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_16,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_17,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_18,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_19,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_20,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_21,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_22,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_23,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_24,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_25,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_26,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_27,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_28,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_29,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_30,},
                {(apOS_INT_rRawISR *) &VIC_RawHandler_31,}};

PRIVATE VIC_sRawEntry VIC_sChRawHandlers[] = {
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_0,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_1,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_2,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_3,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_4,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_5,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_6,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_7,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_8,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_9,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_10,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_11,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_12,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_13,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_14,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_15,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_16,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_17,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_18,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_19,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_20,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_21,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_22,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_23,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_24,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_25,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_26,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_27,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_28,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_29,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_30,},
                {(apOS_INT_rRawISR *) &VIC_ChRawHandler_31,}};

// Keep track of the last VIC we tested. Initialise to suitable values.

PRIVATE apOS_VIC_oId    VIC_oLast_Ctrlr_Tested = (apOS_VIC_oId) -1;
PRIVATE apOS_VIC_oId    VIC_oDaisy_Chained_Ctrlr = (apOS_VIC_oId) -1;
PRIVATE apOS_VIC_oId    VIC_oMain_Ctrlr = (apOS_VIC_oId) -1;
PRIVATE UWORD32         VIC_LastRegBase = 0U;
PRIVATE BOOL            VIC_FirstTest = TRUE;

// Initial status of the source interrupts

PRIVATE UWORD32 InterruptStatus[apOS_CONFIG_VIC_NUMBER];

// The parameter that will be passed by interrupt source with the highest priority.

PRIVATE UWORD32 StartParameter[apOS_CONFIG_VIC_NUMBER];

#endif /* apINT_VERSION & apVERSION_VECTORED */

/*
 * Description:
 * This is the main test routine. 
 *
 * NOTE:    This test code can be used to test multiple VICs, as long as the following
 *          requirements are met:
 *
 *              The VICs are daisy chained together
 *              The VICs are tested in the correct order, the first must be the main one,
 *              the second must be chained off the first, and so on.
 */

PROTECTED apTEST_eResult apVIC_SelfTest( UWORD32 Id,
                                         UWORD32 RegBase,
                                         UWORD32 NumSources,
                                         CONST apOS_INT_oInterruptSource * CONST pInt )
{

#if !( apINT_VERSION & apVERSION_VECTORED )

    IGNORE( Id );
    IGNORE( RegBase );
    IGNORE( NumSources );
    IGNORE( pInt );
    
    // Wrong version of interrupt controller
    
    apTEST_Print( apTEST_FAIL, "VIC Interrupt test: "
                  "apINT_VERSION set to wrong version !" );
    
    return apTEST_FAIL;
}
#else

    apTEST_eResult eTestResult;

    apOS_VIC_oId   oNewCtrlr = (apOS_VIC_oId) Id;

    IGNORE( pInt );
    IGNORE( NumSources );

    // If we are trying to test slave daisy chained VIC,
    // but master VIC #0 is not set up, exit the test.

    if(( oNewCtrlr == apOS_VIC_1) && (VIC_oMain_Ctrlr == (apOS_VIC_oId) -1))
    {
        apTEST_Report("Cannot test daisy chained VIC #1 without testing master VIC #0\n",
                       0, apTEST_FORMAT_NO_NUMBER);
        return apTEST_FAIL;
    }        

    // Lets see if this is the first VIC we've been asked to test.

    if( VIC_FirstTest )
    {
        VIC_oLast_Ctrlr_Tested = oNewCtrlr;
        VIC_FirstTest = FALSE;
    }

    // Initialise this VIC

    apVIC_Initialize( oNewCtrlr, (apOS_System_eBaseAddress) RegBase, NULL, NULL, NULL );

    if ( Id == apOS_VIC_0 )
    {
        VIC_oMain_Ctrlr = oNewCtrlr;
    }
    else
    {
        VIC_oDaisy_Chained_Ctrlr = oNewCtrlr;
    }

#if (( defined apOS_CONFIG_VIC_USE_PREDISPATCH_CODE ) && apOS_CONFIG_VIC_USE_PREDISPATCH_CODE )
    apVIC_IRQPreDispatchSet( apVIC_IRQPreDispatchCode );
#endif    

#if (( defined apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE ) && apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE )
    apVIC_IRQPostDispatchSet( apVIC_IRQPostDispatchCode );
#endif    

    // Enable both IRQ and FIQ interrupts

    apOS_CoreIRQEnable();
    apOS_CoreFIQEnable();

    // Keep track of which ctrlr we are/have tested

    VIC_oLast_Ctrlr_Tested  = oNewCtrlr;
    VIC_LastRegBase         = RegBase;

    // Now perform the actual tests.

    if(oNewCtrlr == apOS_VIC_0)
    {
        pRawHandler = VIC_sRawHandlers;
    }
    else
    {
        pRawHandler = VIC_sChRawHandlers;
    }        

#ifdef VIC_NESTED

    pVIC_RawHandler = VIC_ReentrantHandler;

#else

    pVIC_RawHandler = VIC_RecursiveHandler;

#endif  /* VIC_NESTED */

    if( VIC_Test( oNewCtrlr ) == apTEST_FAIL )
    {
        return apTEST_FAIL;
    }

    // Return if only one VIC was tested.

    if( (VIC_oMain_Ctrlr == (apOS_VIC_oId) -1) || (VIC_oDaisy_Chained_Ctrlr == (apOS_VIC_oId) -1) )
    {
        return apTEST_PASS ;
    }        

#ifdef VIC_NESTED

    // Test recursive handlers.
    
    pVIC_RawHandler = VIC_RecursiveHandler;

#endif /* VIC_NESTED */

    // Test all interrupts on both VICs.

    eTestResult = VIC_GlobalTest( VIC_oMain_Ctrlr, VIC_oDaisy_Chained_Ctrlr );
    apTEST_Print(eTestResult,"Testing all interrupts sources on both VICs");
    if (eTestResult==apTEST_FAIL)
    {
        return apTEST_FAIL;
    }

    // Test daisy-chained interrupts.
    
    eTestResult = VIC_TestDaisyPriority( VIC_oMain_Ctrlr, VIC_oDaisy_Chained_Ctrlr );
    apTEST_Print(eTestResult,"Testing Vector Priority Daisy");
        
    VIC_CleanUp( VIC_oDaisy_Chained_Ctrlr );

    VIC_CleanUp( VIC_oMain_Ctrlr );

    return eTestResult;
}

/*
 * The Main test function - performs all the tests 
 */

PRIVATE apTEST_eResult VIC_Test( apOS_VIC_oId oId ) 
{
    apTEST_eResult eTestResult;

    UWORD32 Mask = 1;       // interrupt source bit mask

    // Only for test purpose - coverage
    apVIC_ControllerDisable( oId );
    apVIC_ControllerRestore( oId );
    
    // Get the status of the source interrupts.
    // If there is any interrupt asserted then exclude this interrupt source from the test.
    
    if( (UWORD32)(InterruptStatus[ oId ] = apVIC_GetInterruptStatus( oId )) ) 
    {
        apTEST_Report( "Asserted interrupts found. Interrupt Status: ",
                       InterruptStatus[ oId ], apTEST_FORMAT_LONG_HEX );
        
        // If all 32 interrupt sources asserted - report an error.
        if( InterruptStatus[ oId ] == 0xFFFFFFFF ) 
        {
            apTEST_Print( apTEST_FAIL, "Cannot perform the test. All VIC #0 interrupt sources asserted.");
            return apTEST_FAIL;
        }
    }

    // Define the 1st unasserted source which will have the highest priority.
    // Set up StartParameter to determine when all interrupts have been serviced.
    // It equals to the value of Parameter for the 1st interrupt source set up.
    // The initial value of StartParameter equals to 0.
                
    StartParameter[ oId ] = VIC_oSourceCreate( oId, 0 );
    
    while( InterruptStatus[ oId ] & Mask )
    {
        StartParameter[ oId ]++;
        Mask <<= 1;
    }

    // Raise a soft interrupt on all vectored interrupt sources to simultaneously test that the IRQ
    // is wired up to the ARM, the IRQ vector is correct, apOS is calling the VIC driver
    // correctly, the VIC generates interrupts correctly and in the correct order, and that
    // the dispatcher supports nested interrupts (if it's been built to do so). 
    
    eTestResult = VIC_TestReEntrant( oId, apVIC_IRQ_VECTORED );
    apTEST_Print(eTestResult,"Testing Vectored interrupts");
    if (eTestResult==apTEST_FAIL)
    {
        return apTEST_FAIL;
    }

    eTestResult = VIC_TestRawReEntrant( oId );
    apTEST_Print(eTestResult,"Testing Raw interrupts");
    if (eTestResult==apTEST_FAIL)
    {
        return apTEST_FAIL;
    }
    
    // Raise an FIQ on each interrupt source in turn to simultaneously test that the FIQ
    // is wired up to the ARM, the IRQ vector is correct, apOS is calling the VIC driver
    // correctly, the VIC generates FIQs correctly and in the correct order. 

    eTestResult = VIC_TestReEntrant( oId, apVIC_FIQ );
    apTEST_Print(eTestResult, "Testing FIQ interrupts" );
    if ( eTestResult == apTEST_FAIL )
    {
        return apTEST_FAIL;
    }

    VIC_CleanUp( oId );

    pVIC_RawHandler = VIC_RecursiveHandler;

    eTestResult = VIC_GeneralTest( oId );
    apTEST_Print( eTestResult, "Testing all interrupt sources" );
    if ( eTestResult == apTEST_FAIL )
    {
        return apTEST_FAIL;
    }

    // Test masking priority levels.
    eTestResult = VIC_TestMaskPriority( oId );
    apTEST_Print(eTestResult, "Testing masking priority levels" );

    // Now remove all the test interrupt handlers and disable all interrupts.

    VIC_CleanUp( oId );

    return eTestResult;
}

// Hangs around wasting time until the current VIC test has completed or 5 s have elapsed

PRIVATE BOOL VIC_TestComplete( UWORD32 MilliSecs )
{
    volatile UWORD32 WasteCount;
    volatile UWORD32 I;

    UWORD32 OrigTime = apTEST_TimeGet();

    while( VIC_InterruptTestCompleted != TRUE && (apTEST_TimeGet() < OrigTime + MilliSecs) )
    {
        // waste some time, whilst waiting.

        WasteCount = 0U;

        for( I = 0; I < 0x300; I++ )
        {
            WasteCount++;
        }
    }

    if( VIC_InterruptTestCompleted )
    {
        return TRUE;
    }

    return FALSE;
}


// Clears the interrupt occured flags

PRIVATE void VIC_ClearIntOccuredFlags( void )
{
    UWORD32 I;
    
    for( I = 0; I < VIC_NUM_INT_SOURCES * apOS_CONFIG_VIC_NUMBER; I++ )
    {
        VIC_InterruptOccured[ I ] = 0;
    }
}

/*
 * Description:
 * Test single interrupt handler for vectored interrupts.
 */

PROTECTED void VIC_SingleHandler( CONST apOS_INT_oInterruptSource oldSource,
                                  UWORD32                         Parameter )
{
    apOS_INT_oInterruptSource oSource = (apOS_INT_oInterruptSource) Parameter;
    IGNORE( oldSource );

    // Check if it is the right interrupt source and controller.
    
    if( VIC_oNextSource != oSource || VIC_oTestIntCtrlr != VIC_ControllerGet( oSource ) )
    {
        VIC_InterruptTestFailed = TRUE;
    }

    // Check if this is the first time this source has interrupted during this test

    if( !VIC_FirstOccurence( oSource ) )
    {
        // It was interrupted before !

        VIC_InterruptTestFailed = TRUE;
    }

    // A normal interrupt handler would disable the source - so we shall also; via apOS

    apVIC_InterruptDisable( oSource );

    
    // Set up Serviced Interrupt flag.
    
    VIC_InterruptServiced[VIC_ControllerGet( oSource )] |= VIC_MaskGet( oSource );
    
    // Now we have to clear the soft interrupt, a normal interrupt source would have been cleared
    // by now.

    apVIC_ProgrammedInterruptClear( oSource );

    // A normal interrupt handler would re-enable the source - so we shall also; via apOS

    apVIC_InterruptEnable( oSource );
}


/*
 * Description:
 * Test re-entrant interrupt handler. Generates an interrupt of higher priority
 * and then clears the interrupt source. 
 */

PROTECTED void VIC_ReentrantHandler( CONST apOS_INT_oInterruptSource oldSource,
                                     UWORD32                         Parameter )
{
    UWORD32 I;
    apOS_INT_oInterruptSource oSource = (apOS_INT_oInterruptSource) Parameter;
    apOS_VIC_oId oCtrlr = VIC_ControllerGet( oSource );
    UBYTE8  DaisyPriority;
    
    IGNORE( oldSource );

    // Now we have to clear the soft interrupt, a normal interrupt source would have been cleared
    // by now.

    apVIC_ProgrammedInterruptClear( oSource );

    // Check if it is the right interrupt source and controller.
    
    if( VIC_oNextSource != oSource || VIC_oTestIntCtrlr != VIC_ControllerGet( oSource ) )
    {
        VIC_InterruptTestFailed = TRUE;
    }

    // Check if this is the first time this source has interrupted during this test

    if( !VIC_FirstOccurence( oSource ) )
    {
        // It was interrupted before !

        VIC_InterruptTestFailed = TRUE;
    }

    // A normal interrupt handler would disable the source - so we shall also; via apOS

    apVIC_InterruptDisable( oSource );

    // Check which VIC it is - master or daisy-chained.

    if(VIC_ControllerGet( oSource ) == VIC_oDaisy_Chained_Ctrlr)
    {
        // It's daisy-chained VIC.

        apVIC_PriorityDaisyGet( VIC_oMain_Ctrlr, &DaisyPriority );
        
        // Increase DaisyPriority to allow intterrupts to be serviced reentrantly.

        if(DaisyPriority)
        {
            apVIC_PriorityDaisySet( VIC_oMain_Ctrlr, --DaisyPriority );
        }            
    }

    if( Parameter != StartParameter[ oCtrlr ] )
    {
        // Find the next non-asserted interrupt source.
        
#ifdef VIC_NESTED
        VIC_oNextSource = (apOS_INT_oInterruptSource) (((UWORD32) oSource) - 2);
#else
        VIC_oNextSource = (apOS_INT_oInterruptSource) (((UWORD32) VIC_oNextSource) - 1);
#endif

        while(((UWORD32) 1 << (((UWORD32) VIC_oNextSource) & \
                VIC_SOURCE_FIELD_MASK )) & InterruptStatus[ oCtrlr ])
        {        
#ifdef VIC_NESTED
            VIC_oNextSource = (apOS_INT_oInterruptSource) (((UWORD32) VIC_oNextSource) - 2);
#else
            VIC_oNextSource = (apOS_INT_oInterruptSource) (((UWORD32) VIC_oNextSource) - 1);
#endif
        }
            
        apVIC_ProgrammedInterruptSet( VIC_oNextSource );
        
        for( I = 1000; I; I-- )
        {
            if( VIC_InterruptTestCompleted )
            {
                break;
            }    
        }
          
        // If VIC_InterruptTestCompleted is still FALSE then src 0 has not been serviced, which
        // means that the interrupts are not being handled re-entrantly.
        // Note, non-vectored interrupts can not be interrupted by other non-vectored
        // interrupts and are being serviced by VIC_RecursiveHandler.

        if( !VIC_InterruptTestCompleted )
        {
            VIC_ReEntrantInts = FALSE;
        }    
    }
    else
    {
        // Reached the last source.
        
        VIC_InterruptTestCompleted = TRUE;
    }

    // A normal interrupt handler would re-enable the source - so we shall also; via apOS

    apVIC_InterruptEnable( oSource );
}


/*
 * Description:
 * Test re-entrant interrupt handler. Generates an interrupt of higher priority
 * and then clears the interrupt source. 
 */

PROTECTED void VIC_FIQReentrantHandler( CONST apOS_INT_oInterruptSource oldSource,
                                        UWORD32                         Parameter )
{
    UWORD32 I;
    apOS_INT_oInterruptSource oSource = (apOS_INT_oInterruptSource) Parameter;
    apOS_VIC_oId oCtrlr = VIC_ControllerGet( oSource );

    IGNORE( oldSource );

    // Check if it is the right interrupt source and controller.
    
    if( VIC_oNextSource != oSource || VIC_oTestIntCtrlr != VIC_ControllerGet( oSource ) )
    {
        VIC_InterruptTestFailed = TRUE;
    }

    // Check if this is the first time this source has interrupted during this test

    if( !VIC_FirstOccurence( oSource ) )
    {
        // It was interrupted before !

        VIC_InterruptTestFailed = TRUE;
    }

    // A normal interrupt handler would disable the source - so we shall also; via apOS

    apVIC_InterruptDisable( oSource );

    if( Parameter != StartParameter[ oCtrlr ] )
    {

#ifdef VIC_NESTED
        apOS_CoreIRQEnable();
        apOS_CoreFIQEnable();
#endif
    
        // Find the next non-asserted interrupt source.
        
        VIC_oNextSource = (apOS_INT_oInterruptSource) (((UWORD32) VIC_oNextSource) - 1);

        while(((UWORD32) 1 << (((UWORD32) VIC_oNextSource) & \
                VIC_SOURCE_FIELD_MASK )) & InterruptStatus[ oCtrlr ])
        {        
            VIC_oNextSource = (apOS_INT_oInterruptSource) (((UWORD32) VIC_oNextSource) - 1);
        }
            
        apVIC_ProgrammedInterruptSet( VIC_oNextSource );
        
        for( I = 1000; I; I-- )
        {
            if( VIC_InterruptTestCompleted )
            {
                break;
            }    
        }
          
        // If VIC_InterruptTestCompleted is still FALSE then src 0 has not been serviced, which
        // means that the interrupts are not being handled re-entrantly.
        // Note, non-vectored interrupts can not be interrupted by other non-vectored
        // interrupts and are being serviced by VIC_RecursiveHandler.

        if( !VIC_InterruptTestCompleted )
        {
            VIC_ReEntrantInts = FALSE;
        }    
    }
    else
    {
        // Reached the last source.
        
        VIC_InterruptTestCompleted = TRUE;
    }

    // Now we have to clear the soft interrupt, a normal interrupt source would have been cleared
    // by now.

    apVIC_ProgrammedInterruptClear( oSource );

    // A normal interrupt handler would re-enable the source - so we shall also; via apOS

    apVIC_InterruptEnable( oSource );
}

/*
 * Description:
 * Test recursive interrupt handler for non-vectored interrupts.
 * Generates an interrupt of higher priority
 * and then clears the interrupt source.
 */

PROTECTED void VIC_RecursiveHandler( CONST apOS_INT_oInterruptSource oldSource,
                                     UWORD32                         Parameter )
{
    apOS_INT_oInterruptSource oSource = (apOS_INT_oInterruptSource) Parameter;
    apOS_VIC_oId oCtrlr = VIC_ControllerGet( oSource );
    IGNORE( oldSource );

    // Check if it is the right interrupt source and controller.
    
    if( VIC_oNextSource != oSource || VIC_oTestIntCtrlr != VIC_ControllerGet( oSource ) )
    {
        VIC_InterruptTestFailed = TRUE;
    }

    // Check if this is the first time this source has interrupted during this test

    if( !VIC_FirstOccurence( oSource ) )
    {
        // It was interrupted before !

        VIC_InterruptTestFailed = TRUE;
    }

    // A normal interrupt handler would disable the source - so we shall also; via apOS

    apVIC_InterruptDisable( oSource );

    if( Parameter != StartParameter[ oCtrlr ] )
    {
#ifdef VIC_NESTED    
        apOS_CoreIRQEnable();
        apOS_CoreFIQEnable();
#endif
    
        // Find the next non-asserted interrupt source.
        
        VIC_oNextSource = (apOS_INT_oInterruptSource) (((UWORD32) VIC_oNextSource) - 1);

        while(((UWORD32) 1 << (((UWORD32) VIC_oNextSource) & \
                VIC_SOURCE_FIELD_MASK )) & InterruptStatus[ oCtrlr ] )
        {        
            VIC_oNextSource = (apOS_INT_oInterruptSource) (((UWORD32) VIC_oNextSource) - 1);
        }
            
        apVIC_ProgrammedInterruptSet( VIC_oNextSource );
    }
    else
    {
        // Reached the last source.
        
        VIC_InterruptTestCompleted = TRUE;
    }

#ifndef VIC_NESTED
   VIC_ReEntrantInts = FALSE;
#endif

    // Now we have to clear the soft interrupt, a normal interrupt source would have been cleared
    // by now.

    apVIC_ProgrammedInterruptClear( oSource );

    // A normal interrupt handler would re-enable the source - so we shall also; via apOS

    apVIC_InterruptEnable( oSource );
}

// ======================================================================
// A nasty re-entrant test where the interrupt handler immediately generates a soft interrupt
// on the next interrupt source (with higher priority) before clearing its own interrupt.
//

PRIVATE apTEST_eResult VIC_TestReEntrant( apOS_VIC_oId oCtrlr, apVIC_eInterruptType eType )
{
    UBYTE8  Priority, ReadPriority;
    apVIC_eInterruptType eReadType;
    UWORD32 I;
    UWORD32 Mask;           // interrupt source bit mask
    UWORD32 NumVectores;    // number of interrupts to test
           
    apOS_INT_oInterruptSource oSource;
    apOS_INT_rServiceRoutine  rHandler;

    VIC_InterruptTestCompleted = FALSE;
    VIC_InterruptTestFailed = FALSE;
    VIC_ReEntrantInts = TRUE;

    VIC_ClearIntOccuredFlags();

    VIC_oTestIntCtrlr = oCtrlr;

    
    if ( apVIC_PriorityDaisySet( VIC_oMain_Ctrlr, apVIC_IRQ_LOWEST_PRIORITY ) != apERR_NONE )
    {
        apTEST_Print( apTEST_FAIL, "VIC_TestReEntrant(). Error calling apVIC_PriorityDaisySet()");
        return apTEST_FAIL ;
    }
    
    if( eType == apVIC_IRQ_VECTORED )
    {
        NumVectores = VIC_NUM_VECTOR_REGISTERS;

// Cannot test re-entrant interrupts in VIC 0 blocking mode 
// for daisy-chained sources.

#if( defined(apOS_CONFIG_VIC_0_BLOCKING_MODE ) && apOS_CONFIG_VIC_0_BLOCKING_MODE )

        if( oCtrlr == VIC_oDaisy_Chained_Ctrlr )
        {
            rHandler = VIC_RecursiveHandler;
        }
        else
        {
            rHandler = VIC_ReentrantHandler;
        }            
#else
        rHandler = VIC_ReentrantHandler;

#endif

    }
    else    // Non-vectored FIQ
    {
        NumVectores = VIC_NUM_INT_SOURCES;
        rHandler    = VIC_FIQReentrantHandler;
    }    
        
    for( I = 0, Mask = 1; I < NumVectores; I++, Mask <<= 1 )
    {
        oSource = VIC_oSourceCreate( oCtrlr, I );

        // Disable all interrupt sources.
        
        apVIC_InterruptDisable( oSource );

        // Change the handler for all the interrupt sources, setting
        // the priority of them such that source 0 is the highest priority
        // and source 31 has the lowest priority.

        // Don't perform these actions for interrupt sources already asserted.
        // Asserted sources have 1-s in InterruptStatus.
         
        if( !(InterruptStatus[ oCtrlr ] & Mask) )
        {
            // Set reentrant/recursive interrupt handler.
            
            if( apVIC_HandlerSet( oSource, rHandler, oSource ) != apERR_NONE )
            {
                return apTEST_FAIL;
            }
           
            if( eType == apVIC_IRQ_VECTORED )
            {
                Priority = (UBYTE8) (I >> 1);
            }
            else
            {
                Priority = (UBYTE8) I;
            }                            
            
            if( apVIC_PrioritySet( oSource, eType, Priority) != apERR_NONE)
            {
                apTEST_Print( apTEST_FAIL, "VIC_TestReEntrant(). Error calling apVIC_PrioritySet()");
                return apTEST_FAIL;
            }                                   

            // Check the priority.
            
            if( apVIC_PriorityGet( oSource, &eReadType, &ReadPriority) != apERR_NONE)
            {
                apTEST_Print( apTEST_FAIL, "VIC_TestReEntrant(). Error calling apVIC_PriorityGet()");
                return apTEST_FAIL;
            }                                   
            
            if(( eReadType != eType ) || ( ReadPriority != Priority ))
            {
                apTEST_Print( apTEST_FAIL, "VIC_TestReEntrant(). Priority or Type not set!");
                return apTEST_FAIL;
            }                                   
            
            // The priority is decreasing.
            // The last source with non-asserted interrupt will have the lowest priority.

            VIC_oNextSource = oSource;

            // Enable non-asserted interrupt.
            
            apVIC_InterruptEnable( oSource );

#if defined( apOS_CONFIG_VIC_SINGLE_FIQ ) && apOS_CONFIG_VIC_SINGLE_FIQ

            // For test coverage

            if( eType == apVIC_FIQ )
            {
                apVIC_SingleFIQSourceSet( oSource );
            }
#endif                    
        }        
    }

#ifdef VIC_NESTED
    if( eType == apVIC_IRQ_VECTORED )
    {
        VIC_oNextSource = (apOS_INT_oInterruptSource)(VIC_oNextSource - 1);
    }        
#endif
    
    // Now generate a soft interrupt on the source with the lowest priority.

    apVIC_ProgrammedInterruptSet( VIC_oNextSource );

    // Now wait for a short while for the test to complete
    
    if( VIC_TestComplete( 5000U ) )
    {
        if( VIC_InterruptTestFailed )
        {
            return apTEST_FAIL;
        }
        else
        {
            if( VIC_ReEntrantInts )
            {
            }
            else
            {
#ifdef VIC_NESTED
                // Should have been nested but were not.

                apTEST_Report( "Interrupt test: Re-entrant interrupt test failed but \n"
                               "only because the interrupts were handled sequentially.\n",
                               0, apTEST_FORMAT_NO_NUMBER );
                
                return apTEST_FAIL;
#endif
            }
        }
    }
    else
    {
#ifdef VIC_NESTED    
        apTEST_Print( apTEST_FAIL, "Interrupt test: Re-entrant Interrupts - "
                      "Test Failed to complete" );
#else                        
        apTEST_Print( apTEST_FAIL, "Interrupt test: Sequential Interrupts - "
                      "Test Failed to complete" );
#endif                        
        return apTEST_FAIL;
    }
    return apTEST_PASS;
}

// ===============================================================================================
// A nasty re-entrant test where the Raw interrupt handler immediately generates a soft interrupt
// on the next interrupt source (with higher priority) before clearing its own interrupt.
//

PRIVATE apTEST_eResult VIC_TestRawReEntrant( apOS_VIC_oId oCtrlr )
{
    UWORD32 I;
    UWORD32 Mask;               // interrupt source bit mask
    apOS_INT_oInterruptSource oSource;

    VIC_InterruptTestCompleted = FALSE;
    VIC_InterruptTestFailed = FALSE;
    VIC_ReEntrantInts = TRUE;

    VIC_ClearIntOccuredFlags();

    if ( apVIC_PriorityDaisySet( VIC_oMain_Ctrlr, apVIC_IRQ_LOWEST_PRIORITY ) != apERR_NONE )
    {
        apTEST_Print( apTEST_FAIL, "VIC_RawTestReEntrant(). Error calling apVIC_PriorityDaisySet()");
        return apTEST_FAIL ;
    }

    VIC_oTestIntCtrlr = oCtrlr;

    for( I = 0, Mask = 1; I < VIC_NUM_VECTOR_REGISTERS; I++, Mask <<= 1 )
    {
        oSource = VIC_oSourceCreate( oCtrlr, I );

        
        pRawHandler[ I ].oSource = oSource;
        
        // Disable all interrupt sources.

        apVIC_InterruptDisable( oSource );

        // Change the handler for all the interrupt sources, setting
        // the priority of them such that source 0 is the highest priority
        // and source 31 has the lowest priority.

        // Don't perform these actions for interrupt sources already asserted.
        // Asserted sources have 1-s in InterruptStatus.
         
        if( !(InterruptStatus[ oCtrlr ] & Mask) )
        {
            if( apVIC_RawHandlerSet( oSource,
                                    (apOS_INT_rRawISR ) pRawHandler[ I ].rVIC_RawHandler ) != apERR_NONE )
            {
                apTEST_Print( apTEST_FAIL, "Error calling apVIC_RawHandlerSet()");
                return apTEST_FAIL;
            }
                    
            if( apVIC_PrioritySet( oSource, apVIC_IRQ_RAW, (UBYTE8) ( I >> 1 )) != apERR_NONE)
            {
                apTEST_Print( apTEST_FAIL, "VIC_RawTestReEntrant(). Error calling apVIC_PrioritySet()");
                return apTEST_FAIL;
            }                                   
        }        
    }

    // Reset priority. Just to increase the code coverage.
    
    for( I = 0, Mask = 1; I < VIC_NUM_VECTOR_REGISTERS; I++, Mask <<= 1 )
    {
        if(!(InterruptStatus[ oCtrlr ] & Mask))
        {
            if( apVIC_PrioritySet( pRawHandler[ I ].oSource,
                                   apVIC_IRQ_RAW, 
                                   (UBYTE8) (I >> 1) ) != apERR_NONE)
            {
                apTEST_Print( apTEST_FAIL, "VIC_RawTestReEntrant(). Error calling apVIC_PrioritySet()");
                return apTEST_FAIL;
            }                                   

            // The priority is decreasing.
            // The last source with non-asserted interrupt will have the lowest priority.

            VIC_oNextSource = pRawHandler[ I ].oSource;

            // Enable non-asserted interrupt.
            
            apVIC_InterruptEnable( pRawHandler[ I ].oSource );
        }            
    }

#ifdef VIC_NESTED
    VIC_oNextSource = (apOS_INT_oInterruptSource)(VIC_oNextSource - 1);
#endif

    // Now generate a soft interrupt on the source with the lowest priority.

    apVIC_ProgrammedInterruptSet( VIC_oNextSource );

    // Now wait for a short while for the test to complete
    
    if( VIC_TestComplete( 5000U ) )
    {
        if( VIC_InterruptTestFailed )
        {
            return apTEST_FAIL;
        }
        else
        {
            if( VIC_ReEntrantInts )
            {
            }
            else
            {
#ifdef VIC_NESTED
                // Should have been nested but were not

                apTEST_Report( "Interrupt test: Re-entrant Raw interrupt test failed but \n"
                               "only because the interrupts were handled sequentially.\n",
                               0, apTEST_FORMAT_NO_NUMBER );

                return apTEST_FAIL;
#endif
            }
        }
    }
    else
    {
        return apTEST_FAIL;
    }
    return apTEST_PASS;
}

// ======================================================================
// A nasty re-entrant test where the interrupt handler immediately generates a soft interrupt
// on the next interrupt source (with higher priority) before clearing its own interrupt.
// This test uses all interrupt sources. 
// All vectored interrupts should be handled reentrantly.
// (assuming the dispatcher code has been built with 
// apOS_CONFIG_INT_REENTRANT defined to be 1).

PRIVATE apTEST_eResult VIC_GeneralTest( apOS_VIC_oId oCtrlr )
{
    UWORD32 I;
    UWORD32 Mask;               // interrupt source bit mask
    apOS_INT_oInterruptSource oSource;
    apVIC_eInterruptType      eType;

    VIC_InterruptTestCompleted = FALSE;
    VIC_InterruptTestFailed = FALSE;
    VIC_ReEntrantInts = TRUE;

    VIC_ClearIntOccuredFlags();

    VIC_oTestIntCtrlr = oCtrlr;

    // Set up Vectored and Raw interrupts
    
    for( I = 0, Mask = 1; I < VIC_NUM_VECTOR_REGISTERS; I++, Mask <<= 1 )
    {
        oSource = VIC_oSourceCreate( oCtrlr, I );

        // Disable all interrupt sources.
        
        apVIC_InterruptDisable( oSource );

        // Asserted sources have 1-s in InterruptStatus. Don't set up them.
         
        if( !(InterruptStatus[ oCtrlr ] & Mask) )
        {
            if( I & 1 )
            {
                // This will be Raw interrupt
                
                eType = apVIC_IRQ_RAW;       

                pRawHandler[ I ].oSource = oSource;
            
                // Change the handler for all the interrupt sources, setting
                // the priority of them such that source 0 is the highest priority
                // and source 31 has the lowest priority.

                if( apVIC_RawHandlerSet( oSource, (apOS_INT_rRawISR ) pRawHandler[ I ].rVIC_RawHandler ) != apERR_NONE )
                {
                    apTEST_Print( apTEST_FAIL, "Error calling apVIC_RawHandlerSet()");
                    return apTEST_FAIL;
                }
            }
            else
            {
                // This will be Vectored interrupt.

                eType = apVIC_IRQ_VECTORED;       

                // Change the handler for all the interrupt sources, setting
                // the priority of them such that source 0 is the highest priority
                // and source 31 has the lowest priority.

                if( apVIC_HandlerSet( oSource, VIC_RecursiveHandler, oSource ) != apERR_NONE )
                {
                    apTEST_Print( apTEST_FAIL, "Error calling apVIC_HandlerSet()");
                    return apTEST_FAIL ;
                }
            }
     
            if( apVIC_PrioritySet( oSource, 
                                   eType, 
                                   (UBYTE8) (I >> 1) ) != apERR_NONE)
            {
                apTEST_Print( apTEST_FAIL, "VIC_GeneralTestReEntrant(). Error calling apVIC_PrioritySet()");
                return apTEST_FAIL ;
            }

            // The priority is decreasing.
            // The last source with non-asserted interrupt will have the lowest priority.

            VIC_oNextSource = oSource;

            // Enable non-asserted interrupt.
            
            apVIC_InterruptEnable( oSource );
        }
    }        
    
#ifdef VIC_NESTED
    VIC_oNextSource = (apOS_INT_oInterruptSource)(VIC_oNextSource - 1);
#endif

    // Now generate a soft interrupt on the source with the lowest priority.

    apVIC_ProgrammedInterruptSet( VIC_oNextSource );

    // Now wait for a short while for the test to complete
    
    if( VIC_TestComplete( 5000U ) )
    {
        if( VIC_InterruptTestFailed )
        {
            return apTEST_FAIL;
        }
        else
        {
            if( VIC_ReEntrantInts )
            {
            }
            else
            {
#ifdef VIC_NESTED
                // Should have been nested but were not

                apTEST_Report( "Interrupt test: General Re-entrant interrupt test failed but \n"
                               "only because the interrupts were handled sequentially.\n",
                               0, apTEST_FORMAT_NO_NUMBER );

                return apTEST_FAIL;
#endif
            }
        }
    }
    else
    {
       return apTEST_FAIL;
    }

    return apTEST_PASS;
}


// ======================================================================
// A recursive test where the interrupt handler immediately generates a soft interrupt
// on the next interrupt source (with higher priority) before clearing its own interrupt.
// This test uses all interrupt sources of two VICs. 
// All vectored interrupts should be handled recursively.

PRIVATE apTEST_eResult VIC_GlobalTest( apOS_VIC_oId oMaster, apOS_VIC_oId oSlave )
{
    UWORD32 I;
    UWORD32 Mask;               // interrupt source bit mask
    apOS_INT_oInterruptSource oSource;
    apVIC_eInterruptType      eType;
    
    apOS_VIC_oId oCtrlr = oSlave;
    
    pRawHandler = VIC_sChRawHandlers;
    
    VIC_InterruptTestCompleted = FALSE;
    VIC_InterruptTestFailed = FALSE;
    VIC_ReEntrantInts = TRUE;
    
    VIC_ClearIntOccuredFlags();

    while( 1 )
    {
        VIC_oTestIntCtrlr = oCtrlr;

        // Set up Vectored and Raw interrupts
    
        for( I = 0, Mask = 1; I < VIC_NUM_VECTOR_REGISTERS; I++, Mask <<= 1 )
        {
            oSource = VIC_oSourceCreate( oCtrlr, I );

            // Disable all interrupt sources.
        
            apVIC_InterruptDisable( oSource );

            // Asserted sources have 1-s in InterruptStatus. Don't set up them.
         
            if( !(InterruptStatus[ oCtrlr ] & Mask) )
            {
                if( I & 1 )
                {
                    // This will be Raw interrupt
                
                    eType = apVIC_IRQ_RAW;       

                    pRawHandler[ I ].oSource = oSource;
            
                    // Change the handler for all the interrupt sources, setting
                    // the priority of them such that source 0 is the highest priority
                    // and source 31 has the lowest priority.

                    if( apVIC_RawHandlerSet( oSource, (apOS_INT_rRawISR ) pRawHandler[ I ].rVIC_RawHandler ) != apERR_NONE )
                    {
                        apTEST_Print( apTEST_FAIL, "Error calling apVIC_RawHandlerSet()");
                        return apTEST_FAIL;
                    }
                }
                else
                {
                    // This will be Vectored interrupt.

                    eType = apVIC_IRQ_VECTORED;       

                    // Change the handler for all the interrupt sources, setting
                    // the priority of them such that source 0 is the highest priority
                    // and source 31 has the lowest priority.

                    if( apVIC_HandlerSet( oSource, VIC_RecursiveHandler, oSource ) != apERR_NONE )
                    {
                        apTEST_Print( apTEST_FAIL, "Error calling apVIC_HandlerSet()");
                        return apTEST_FAIL ;
                    }
                }
     
                if( apVIC_PrioritySet( oSource, 
                                       eType, 
                                       (UBYTE8) (I >> 1) ) != apERR_NONE)
                {
                    apTEST_Print( apTEST_FAIL, "VIC_GeneralTestReEntrant(). Error calling apVIC_PrioritySet()");
                    return apTEST_FAIL ;
                }

                // The priority is decreasing.
                // The last source with non-asserted interrupt will have the lowest priority.

                VIC_oNextSource = oSource;

                // Enable non-asserted interrupt.
            
                apVIC_InterruptEnable( oSource );
            }
        }        
    
        // Now generate a soft interrupt on the source with the lowest priority.

        apVIC_ProgrammedInterruptSet( VIC_oNextSource );

        // Now wait for a short while for the test to complete
    
        if( VIC_TestComplete( 5000U ) )
        {
            if( VIC_InterruptTestFailed )
            {
                return apTEST_FAIL;
            }
        }
        else
        {
            apTEST_Print( apTEST_FAIL, "Interrupt test: Sequential Interrupts - "
                          "Test Failed to complete" );
            return apTEST_FAIL;
        }
    
        if( oCtrlr == oSlave )
        {
            oCtrlr = oMaster;
            pRawHandler = VIC_sRawHandlers;
        }
        else
        {        
            return apTEST_PASS;
        }        
    }
}

// ======================================================================
// Priority Level masking test where the interrupt sources with masked priority 
// levels should not generate interrupts
//

PRIVATE apTEST_eResult VIC_TestMaskPriority( apOS_VIC_oId oCtrlr )
{
    UWORD32 I;
    UWORD32 Mask;               // interrupt source bit mask
    UWORD32 OccurMask, OrigTime;
    UHWD16  BitMask, PriorityMask;
    apOS_INT_oInterruptSource oSource;

    VIC_InterruptTestCompleted = FALSE;
    VIC_InterruptTestFailed = FALSE;
    VIC_ReEntrantInts = TRUE;

    VIC_oTestIntCtrlr = oCtrlr;

    // Set up Vectored interrupts.
    
    for ( I = 0, Mask = 1; I < VIC_NUM_VECTOR_REGISTERS; I++, Mask <<= 1 )
    {
        oSource = VIC_oSourceCreate( oCtrlr, I );

        // Disable all interrupt sources.
        
        apVIC_InterruptDisable( oSource );

        // Asserted sources have 1-s in InterruptStatus. Don't set up them.
         
        if ( !(InterruptStatus[oCtrlr] & Mask) )
        {
            // Change the handler for all the interrupt sources, setting
            // the priority of them such that source 0 is the highest priority
            // and source 31 has the lowest priority.

            if( apVIC_HandlerSet( oSource, VIC_SingleHandler, oSource ) != apERR_NONE )
            {
                apTEST_Print( apTEST_FAIL, "Error calling apVIC_HandlerSet()");
                return apTEST_FAIL ;
            }

            if( apVIC_PrioritySet( oSource, 
                                   apVIC_IRQ_VECTORED, 
                                   (UBYTE8) (I >> 1) ) != apERR_NONE)
            {
                apTEST_Print( apTEST_FAIL, "TestMaskPriority(). Error calling apVIC_PrioritySet()");
                return apTEST_FAIL ;
            }
        }
    }        

    for ( BitMask = 1, OccurMask = 3; BitMask; BitMask <<= 1, OccurMask <<= 2 )
    {
        // Set up Priority Level Mask.

        if ( apVIC_PriorityMaskSet( oCtrlr, (UHWD16) (0xFFFF & ~BitMask) ) != apERR_NONE)
        {
            apTEST_Print( apTEST_FAIL, "Error calling apVIC_PriorityMaskSet()");
            return apTEST_FAIL ;
        }
        
        // Then read it's value.

        if ( apVIC_PriorityMaskGet( oCtrlr, &PriorityMask ) != apERR_NONE)
        {
            apTEST_Print( apTEST_FAIL, "Error calling apVIC_PriorityMaskGet()");
            return apTEST_FAIL ;
        }

        // Compare with set up.

        if ( PriorityMask != (0xFFFF & ~BitMask) )        
        {
            apTEST_Print( apTEST_FAIL, "Error setting Priority Mask");
            return apTEST_FAIL ;
        }

        VIC_ClearIntOccuredFlags();

        // Clear interrupts serviced.
        
        VIC_InterruptServiced[oCtrlr] = 0;

        // Now generate a soft interrupt on all sources.

        for ( I = 0, Mask = 1; I < VIC_NUM_VECTOR_REGISTERS; I++, Mask <<= 1 )
        {
            oSource = VIC_oSourceCreate( oCtrlr, I );

            VIC_oNextSource = oSource;

            // Asserted sources have 1-s in InterruptStatus. Don't set up them.
         
            if( !(InterruptStatus[oCtrlr] & Mask) )
            {
                // Enable and set non-asserted interrupt.
                
                apVIC_InterruptEnable( oSource );
                apVIC_ProgrammedInterruptSet( oSource );
            }            
        }    
        
        // Now wait for a short while for the test to complete
    
        OrigTime = apTEST_TimeGet();
    
        while ( apTEST_TimeGet() < OrigTime + 5U ) 
        {
            if ( VIC_InterruptTestFailed == TRUE )
            {        
                return apTEST_FAIL;
            }
        }
        
        // Now disable and clear soft interrupts on all sources.

        for ( I = 0, Mask = 1; I < VIC_NUM_VECTOR_REGISTERS; I++, Mask <<= 1 )
        {
            oSource = VIC_oSourceCreate( oCtrlr, I );

            // Asserted sources have 1-s in InterruptStatus. Don't set up them.
         
            if( !(InterruptStatus[oCtrlr] & Mask) )
            {
                // Disable and clear non-asserted interrupt.
                
                apVIC_InterruptDisable( oSource );
                apVIC_ProgrammedInterruptClear( oSource );
            }            
        }    

        // Check interrupts serviced.
        
        if ( VIC_InterruptServiced[oCtrlr] != ~(InterruptStatus[oCtrlr] | OccurMask) )
        {        
            return apTEST_FAIL;
        }
    }
    
    // Restore default reset value of Software Priority Level Mask.
    
    if( apVIC_PriorityMaskSet( oCtrlr, 0xFFFF) != apERR_NONE)
    {
        apTEST_Print( apTEST_FAIL, "Error calling apVIC_PriorityMaskSet()");
        return apTEST_FAIL ;
    }

    return apTEST_PASS;
}

// ======================================================================
// Vector Priority Daisy Chain test where the interrupt sources with masked priority 
// levels should not generate interrupts.
//

PRIVATE apTEST_eResult VIC_TestDaisyPriority( apOS_VIC_oId oMaster, apOS_VIC_oId oSlave )
{
    UBYTE8  PriorityDaisy, SetPriorityDaisy;
    UWORD32 I;
    UWORD32 Mask;               // interrupt source bit mask
    UWORD32 OrigTime;
    UHWD16  BitMask, PriorityMask, SetMask;
    apOS_INT_oInterruptSource oSource;
    BOOL    MaskFlag;

    VIC_InterruptTestCompleted = FALSE;
    VIC_InterruptTestFailed = FALSE;
    VIC_ReEntrantInts = TRUE;

    VIC_oTestIntCtrlr = oSlave;

    // Set up Vectored interrupts.
    
    for( Mask = 1, I = 0; I < VIC_NUM_VECTOR_REGISTERS; I++, Mask <<= 1 )
    {
        
        oSource = VIC_oSourceCreate( oSlave, I );

        // Disable all interrupt sources.
        
        apVIC_InterruptDisable( oSource );

        // Asserted sources have 1-s in InterruptStatus. Don't set up them.
         
        if ( !(InterruptStatus[oSlave] & Mask) )
        {
            // Change the handler for all the interrupt sources, setting
            // the priority of them such that source 0 is the highest priority
            // and source 31 has the lowest priority.

            if( apVIC_HandlerSet( oSource, VIC_SingleHandler, oSource ) != apERR_NONE )
            {
                apTEST_Print( apTEST_FAIL, "Error calling apVIC_HandlerSet()");
                return apTEST_FAIL ;
            }
        }
     
        if( apVIC_PrioritySet( oSource, 
                               apVIC_IRQ_VECTORED, 
                               (UBYTE8) (I >> 1) ) != apERR_NONE)
        {
            apTEST_Print( apTEST_FAIL, "TestMaskPriority(). Error calling apVIC_PrioritySet()");
            return apTEST_FAIL ;
        }
    }        

    for( BitMask = 0x8000, PriorityDaisy = apVIC_IRQ_LOWEST_PRIORITY; PriorityDaisy; PriorityDaisy--, BitMask >>= 1 )
    {
        if ( apVIC_PriorityDaisySet( oMaster, PriorityDaisy) != apERR_NONE )
        {
            apTEST_Print( apTEST_FAIL, "Error calling apVIC_PriorityDaisySet()");
            return apTEST_FAIL ;
        }
            
        // Then read it's value.

        if ( apVIC_PriorityDaisyGet( oMaster, &SetPriorityDaisy ) != apERR_NONE )
        {
            apTEST_Print( apTEST_FAIL, "Error calling apVIC_PriorityDaisyGet()");
            return apTEST_FAIL ;
        }

        // Compare with set up.

        if ( PriorityDaisy != SetPriorityDaisy )        
        {
            apTEST_Print( apTEST_FAIL, "Error setting Priority Daisy");
            return apTEST_FAIL ;
        }

        MaskFlag = TRUE;

        while( 1 )
        {
            // Set up Priority Level Mask on master VIC.

            if (MaskFlag)
            {
                SetMask = (UHWD16) ~BitMask;
            }
            else
            {
                SetMask = BitMask;
            }                        
            
            if ( apVIC_PriorityMaskSet( oMaster, SetMask) != apERR_NONE )
            {
                apTEST_Print( apTEST_FAIL, "Error calling apVIC_PriorityMaskSet()");
                return apTEST_FAIL ;
            }
            
            // Then read it's value.

            if ( apVIC_PriorityMaskGet( oMaster, &PriorityMask ) != apERR_NONE )
            {
                apTEST_Print( apTEST_FAIL, "Error calling apVIC_PriorityMaskGet()");
                return apTEST_FAIL ;
            }

            // Compare with set up.

            if ( PriorityMask != SetMask )        
            {
                apTEST_Print( apTEST_FAIL, "Error setting Priority Mask");
                return apTEST_FAIL ;
            }

            VIC_ClearIntOccuredFlags();

            // Clear interrupts serviced.
        
            VIC_InterruptServiced[oSlave] = 0;

            // Now generate a soft interrupt on all sources on slave VIC.

            for ( I = 0, Mask = 1; I < VIC_NUM_VECTOR_REGISTERS; I++, Mask <<= 1 )
            {
                oSource = VIC_oSourceCreate( oSlave, I );

                VIC_oNextSource = oSource;

                // Asserted sources have 1-s in InterruptStatus. Don't set up them.
         
                if( !(InterruptStatus[oSlave] & Mask) )
                {
                    // Enable and set non-asserted interrupt.
                
                    apVIC_InterruptEnable( oSource );
                    apVIC_ProgrammedInterruptSet( oSource );
                }            
            }    
        
            // Now wait for a short while for the test to complete
    
            OrigTime = apTEST_TimeGet();
    
            while ( apTEST_TimeGet() < OrigTime + 5U ) 
            {
                if ( VIC_InterruptTestFailed == TRUE )
                {        
                    return apTEST_FAIL;
                }
            }
        
            // Now disable and clear soft interrupts on all sources.

            for ( I = 0, Mask = 1; I < VIC_NUM_VECTOR_REGISTERS; I++, Mask <<= 1 )
            {
                oSource = VIC_oSourceCreate( oSlave, I );

                // Asserted sources have 1-s in InterruptStatus. Don't set up them.
         
                if( !(InterruptStatus[oSlave] & Mask) )
                {
                    // Disable and clear non-asserted interrupt.
                
                    apVIC_InterruptDisable( oSource );
                    apVIC_ProgrammedInterruptClear( oSource );
                }            
            }    

            // Check interrupts serviced.
        
            if ( MaskFlag )
            {
                // Daisy chain interrupts should be masked.
        
                if ( VIC_InterruptServiced[oSlave] )
                {        
                    return apTEST_FAIL;
                }
        
                MaskFlag = FALSE;
            }
            else
            {
                if ( VIC_InterruptServiced[oSlave] != 0xFFFFFFFF )
                {        
                    return apTEST_FAIL;
                }
                    
                break;      // from while( 1 )
            }
        }    
    }
    
    // Restore default reset value of Software Priority Level Mask.
    
    if( apVIC_PriorityMaskSet( oMaster, 0xFFFF) != apERR_NONE)
    {
        apTEST_Print( apTEST_FAIL, "Error calling apVIC_PriorityMaskSet()");
        return apTEST_FAIL ;
    }

    return apTEST_PASS;
}

// Remove the interrupt handler from all the sources,
// which also disables them.

PRIVATE void VIC_CleanUp( apOS_VIC_oId oCtrlr )
{
    UWORD32 I;
    apOS_INT_oInterruptSource oSource;

    for( I = 0; I < VIC_NUM_INT_SOURCES; I++ )
    {
        oSource = VIC_oSourceCreate( oCtrlr, I );
        apVIC_HandlerClear( oSource );
    }
}


// Tests to see if the specified source is already flagged as having produced an interrupt
// and returns TRUE if this is its first interrupt. Either way the occured flag is then set
// to TRUE

PRIVATE BOOL VIC_FirstOccurence( CONST apOS_INT_oInterruptSource oSource )
{
    BOOL    First;
    UWORD32 RawSrc = VIC_SourceGet( oSource ) + ((UWORD32) VIC_NUM_INT_SOURCES) * VIC_ControllerGet( oSource );

    if( VIC_InterruptOccured[ RawSrc ] )
    {
        First = FALSE;
    }
    else
    {
        First = TRUE;
    }

    VIC_InterruptOccured[ RawSrc ] = TRUE;

    return First;
}

// Create a source Id given the ctrlr and a src number (0 to (VIC_NUM_INT_SOURCES - 1))

PRIVATE INLINE apOS_INT_oInterruptSource VIC_oSourceCreate( apOS_VIC_oId oCtrlr, UWORD32 Src )
{
     return (apOS_INT_oInterruptSource) ((((UWORD32) oCtrlr) << VIC_CTRLR_FIELD_SHIFT) | Src);
}

// Extracts & returns the Source from the supplied apOS_INT_oInterruptSource

PRIVATE INLINE UWORD32 VIC_SourceGet( CONST apOS_INT_oInterruptSource oSource )
{
    return (UWORD32) (((UWORD32) oSource) & VIC_SOURCE_FIELD_MASK);
}

// Extracts & returns the controller from the supplied apOS_INT_oInterruptSource

PRIVATE INLINE apOS_VIC_oId VIC_ControllerGet( CONST apOS_INT_oInterruptSource oSource )
{
    return (apOS_VIC_oId) (((UWORD32) oSource) >> VIC_CTRLR_FIELD_SHIFT);
}

// Returns bit mask of the supplied apOS_INT_oInterruptSource

INLINE PRIVATE UWORD32 VIC_MaskGet( CONST apOS_INT_oInterruptSource oSource )
{
    return (UWORD32) 1 << (((UWORD32) oSource) & VIC_SOURCE_FIELD_MASK );
}

PROTECTED void VIC_RawFunction( apOS_INT_oInterruptSource oSource )
{
    pVIC_RawHandler( oSource, (UWORD32) oSource );
    apVIC_InterruptClear( VIC_oMain_Ctrlr );
}

PROTECTED void VIC_ChRawFunction( apOS_INT_oInterruptSource oSource )
{
    pVIC_RawHandler( oSource, (UWORD32) oSource );

#if !(defined(apOS_CONFIG_VIC_0_BLOCKING_MODE) && (apOS_CONFIG_VIC_0_BLOCKING_MODE))
    apVIC_InterruptClear( VIC_oDaisy_Chained_Ctrlr );
#endif    

    apVIC_InterruptClear( VIC_oMain_Ctrlr );
}

#endif /* apINT_VERSION & apVERSION_VECTORED */

