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
 * File:     appl192.h,v
 * Revision: 1.8
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : appl192.h.rca
 *  File Revision          : 1.4
 * 
 *  Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
 *  ----------------------------------------
 *
 * Public API header for the Vectored Interrupt Controller Module device
 * drivers.
 */

/* 
 * Description:
 * All public Vectored Interrupt Module functions, types, and enums
 * have the prefix "apVIC_"
 *
 * Implementation:
 * The driver has designed such that there are two types
 * of functions, those designed to be called by the central system
 * at initialization:
 *
 *  + apVIC_Initialize()
 *
 * and those designed to be called by individual peripheral drivers
 * during their initialization and operation:
 *
 *  + apVIC_HandlerSet()
 *  + apVIC_RawHandlerSet()
 *  + apVIC_HandlerClear()
 *  + apVIC_PrioritySet()
 *  + apVIC_PriorityGet()
 *  + apVIC_PriorityDaisySet()
 *  + apVIC_PriorityDaisyGet()
 *  + apVIC_PriorityMaskSet()
 *  + apVIC_PriorityMaskGet()
 *  + apVIC_InterruptEnable()
 *  + apVIC_InterruptClear()
 *  + apVIC_InterruptDisable()
 *  + apVIC_ControllerDisable()
 *  + apVIC_ControllerRestore()
 *  + apVIC_ProgrammedInterruptSet()
 *  + apVIC_ProgrammedInterruptClear()
 *  + apVIC_IRQPreDispatchSet()
 *  + apVIC_IRQPostDispatchSet()
 *  + apVIC_GetInterruptStatus()
 *  + apVIC_SingleFIQSourceSet()
 *  + apVIC_SingleFIQSourceClear()
 *
 * System initialization:
 * The function apVIC_Initialize() must be called before any
 * of the other functions in this module (or any of the other 
 * interrupt driven peripheral drivers). This call sets the
 * defaults for the interrupt module, and resets the internal
 * state for the drivers.
 *
 * Peripheral Drivers:
 * At initialization, each peripheral driver should set up corresponding 
 * interrupt handler, interrupt type and the priority of this interrupt 
 * by calling the following three functions:
 *  + apVIC_HandlerSet() or apVIC_RawHandlerSet()
 *  + apVIC_PrioritySet()
 *  + apVIC_InterruptEnable()
 * If the priority and interrupt type are the same as the default
 * set in apVIC_Initialize(), the second step can be skipped.
 *
 * During the handling of an interrupt, the peripheral driver should:
 *  + call apVIC_InterruptDisable()
 *  + handle the interrupt in the peripheral to cancel the interrupt source
 *  + call apVIC_InterruptEnable() to reenable interrupt.
 *  + for Raw interrupt handlers call apVIC_InterruptClear(), to clear
 *  + interrupt hardware priority logic.
 * Please note, apVIC_InterruptClear() should be called only for Raw interrupt handlers.
 */

#ifndef APPL192_H
#define APPL192_H

#ifdef  __cplusplus
extern "C" {    /* allow C++ to use these headers */
#endif  /* __cplusplus */

#include "../apcommon/cmacros.h"    /* This is required to include apintcfg.h */
#include "../apos/apintcfg.h"       /* Interrupt configuration file */

/*
 * Description:
 * The lowest software interrupt priority for FIQ sources.
 */
#define apVIC_FIQ_LOWEST_PRIORITY 31

/*
 * Description:
 * The lowest interrupt priority for IRQ sources.
 */
#define apVIC_IRQ_LOWEST_PRIORITY 15

/*=======================================================================*/
/* Type definitions - used to pass parameters to the API functions.      */
/*=======================================================================*/

/*
 * Description:
 * Structure for passing the intialization values
 * into the interrupt initialization function apVIC_Initialize().
 * No data passed in apVIC_sInitialData structure.
 */
typedef void apVIC_sInitialData;

/*
 * Description:
 * Enumeration of the types of processor exception the VIC can
 * generate - either IRQ or FIQ.
 */
typedef enum apVIC_xInterruptType
{
    apVIC_IRQ_VECTORED     = 0,  // Generates an vectored IRQ exception
    apVIC_IRQ_RAW          = 1,  // Generates an vectored Raw interrupt
    apVIC_FIQ              = 2   // Generates an non-vectored FIQ exception
} apVIC_eInterruptType;

/*
 * Description:
 * Function pointer type for use with apVIC_IRQPreDispatchSet() and
 * apVIC_IRQPostDispatchSet().
 *
 */
typedef void (apVIC_rDispatchHandler) ( void );

/*
 * Description:
 *  VIC Specific error return codes
 * 
 */
typedef enum apVIC_xError
{
    apERR_VIC_BAD_INT_TYPE = apERR_VIC_START,   /* Bad interrupt type                               */
    apERR_VIC_BAD_CALL,                         /* Function call whilst interrupt is being serviced */     
    apERR_VIC_SOURCE_NOT_FOUND,                 /* Interrupt source not found                       */
    apERR_VIC_BAD_PRIORITY                      /* Bad priority parameter                           */
} apVIC_eError;

/*=======================================================================*/
/* Public functions - defines the API to the drivers.                    */
/*=======================================================================*/

/*
 * Description:
 * Initializes the interrupt system, configures all the interrupt
 * sources to the same default IRQs with the default lowest priority,
 * and specifies the base address of the interrupt hardware registers.
 *
 * Implementation:
 * The specified base address is remembered for all future accesses
 * to the interrupt hardware using this API.
 * All interrupt sources are disabled, by masking out the interrupts.
 * All interrupt handlers are removed and reset to a default handler which does nothing inside.
 * All interrupts are assigned to IRQ by default, and with the lowest priority.
 * Software Priority Mask and Vector Priority for Daisy Chain registers are programmed
 * to their default reset values.
 *
 * Inputs:
 *  oId                 - The interrupt controller to initialise
 *  eBase               - The base address of the interrupt hardware registers
 *  NumberInterrupts    - Not used, pass as NULL
 *  pSources            - Not used, pass as NULL
 *  pInitial            - Not used, pass as NULL
 *
 * Return values:
 *  apERR_NONE          - The interrupt controller initialised
 *  apERR_BAD_PARAMETER - The specified controller is out of the 
 *                        current implementation's range
 */
PUBLIC apError apVIC_Initialize( apOS_VIC_oId                    oId,
                                 apOS_System_eBaseAddress        eBase,
                                 UWORD32                         NumberInterrupts,
                                 CONST apOS_INT_oInterruptSource *pSources,
                                 apVIC_sInitialData              *pInitial );

/*
 * Description:
 * Selects whether the specified interrupt source would either produce
 * an IRQ Vectored, IRQ Raw or FIQ interrupt exception.
 * Also records the priority levels of the FIQ interrupts, this is used to
 * determine which interrupts get serviced first if there are multiple
 * outstanding active interrupt sources.
 * The priority levels of IRQ interrupts are used to program priority values in
 * Vector Priority registers, VICVectPriority0-31, which will allow the order
 * the interrupts are serviced in to be dynamically changed.
 *
 * Implementation:
 * Selects the interrupt type for this interrupt source, the
 * default (if this function is not called) is that the
 * interrupt is assumed to be an IRQ, with default lowest priority
 * set up by apVIC_Initialize().
 *
 * Note: this function does not enable the interrupt. To enable
 *       the interrupt, call the function apVIC_InterruptEnable().
 *
 * Note: this causes an update of the interrupt dispatch table
 *       during which all interrupts will be temporarily disabled.
 * 
 * Note. This function must be called only after calling apVIC_HandlerSet() or
 *       apVIC_RawHandlerSet().
 *
 * Note. This function must not be called from an interrupt handler.
 *
 * Inputs:
 *  oSource     - The interrupt source to set up priority
 *  eType       - Which exception to produce, apVIC_IRQ_VECTORED
 *                apVIC_IRQ_RAW or apVIC_FIQ
 *  Priority    - The interrupt priority, integer from 0 (highest priority)
 *                to 31 (lowest priority) for FIQ (software priority)
 *                and from 0 to 15 for IRQ interrupts (hardware priority)  
 * Return values:
 *  apERR_NONE                  - Priority and interrupt type set up, no errors
 *  apERR_VIC_BAD_CALL          - The function was called whilst interrupt is being serviced
 *  apERR_VIC_SOURCE_NOT_FOUND  - Interrupt source not found
 *  apERR_VIC_BAD_INT_TYPE      - Different interrupt type was attempted to set up
 *                              - for Raw Interrupt source
 *  apERR_VIC_BAD_PRIORITY      - Priority parameter is out of range   
 */
PUBLIC apError apVIC_PrioritySet( CONST apOS_INT_oInterruptSource oSource,
                                  apVIC_eInterruptType            eType,
                                  UBYTE8                          Priority );

/*
 * Description:
 * Returns type of the specified interrupt source
 * (IRQ Vectored, Raw or FIQ interrupt) and its priority.
 *
 * Note. This function must be called only after calling apVIC_HandlerSet(),
 *       apVIC_RawHandlerSet() or apVIC_PrioritySet()
 *
 * Inputs:
 *  oSource     - The interrupt source to get interrupt type and priority
 *  pType       - Pointer to variable the interrupt type to be read in
 *  pPriority   - Pointer to variable the interrupt priority to be read in
 * 
 * Return values:
 *  apERR_NONE                  - Priority and interrupt type read, no errors
 *  apERR_VIC_SOURCE_NOT_FOUND  - Interrupt source not found
 */
PUBLIC apError apVIC_PriorityGet( CONST apOS_INT_oInterruptSource oSource, 
                                  apVIC_eInterruptType            *pType,
                                  UBYTE8                          *Priority );

/*
 * Description:
 * Sets up the mask value for the interrupt priority levels. 
 *
 * Implementation:
 * Programs Software Priority Mask register, VICSWPRIORITYMASK with
 * the specified value. 
 *
 * Inputs:
 *  oId         - The interrupt controller to set up the mask
 *  Mask        - The mask value for the interrupt priority levels
 *
 * Return values:
 *  apERR_NONE                  - Interrupt priority levels mask set up, no errors
 *  apERR_BAD_PARAMETER         - The specified controller is out of the 
 *                                current implementation's range
 */
PUBLIC apError apVIC_PriorityMaskSet( apOS_VIC_oId oId,
                                      UHWD16       Mask );

/*
 * Description:
 * Returns the mask value for the interrupt priority levels. 
 *
 * Implementation:
 * Reads and returns the current value of 
 * Programs Software Priority Mask register, VICSWPRIORITYMASK. 
 *
 * Inputs:
 *  oId         - The interrupt controller to read the mask
 *  pMask       - Pointer to variable the mask to be read in
 *
 * Return values:
 *  apERR_NONE                  - Interrupt priority levels mask read, no errors
 *  apERR_BAD_PARAMETER         - The specified controller is out of the 
 *                                current implementation's range
 */
PUBLIC apError apVIC_PriorityMaskGet( apOS_VIC_oId oId,
                                      UHWD16       *pMask );

/*
 * Description:
 * Sets up the priority for the daisy chain interrupts. 
 *
 * Implementation:
 * Programs Vector Priority for Daisy Chain register, VICVECTPRIORITYDAISY with
 * the specified value. 
 *
 * Inputs:
 *  oId         - The interrupt controller to set up the priority
 *  Priority    - The interrupt priority, integer from 0 (highest priority)
 *                to 15 (lowest priority)
 *
 * Return values:
 *  apERR_NONE                  - Daisy chain interrupt priority set up, no errors
 *  apERR_BAD_PARAMETER         - The specified controller is out of the 
 *                                current implementation's range
 *  apERR_VIC_BAD_PRIORITY      - Priority parameter is out of range   
 *  apERR_VIC_BAD_CALL          - In VIC 0 blocking mode there was an attempt to
 *                                change priority to the higher value whilst servicing
 *                                an interrupt 
 */
PUBLIC apError apVIC_PriorityDaisySet( apOS_VIC_oId oId,
                                       UBYTE8       Priority );

/*
 * Description:
 * Returns the priority for the daisy chain interrupts. 
 *
 * Implementation:
 * Reads and returns the current value of 
 * Vector Priority for Daisy Chain register, VICVECTPRIORITYDAISY.
 *
 * Inputs:
 *  oId         - The interrupt controller to read the priority
 *  pPriority   - Pointer to variable the priority to be read in
 *
 * Return values:
 *  apERR_NONE                  - Daisy chain interrupt priority read, no errors
 *  apERR_BAD_PARAMETER         - The specified controller is out of the 
 *                                current implementation's range
 */
PUBLIC apError apVIC_PriorityDaisyGet( apOS_VIC_oId oId,
                                       UBYTE8       *pPriority );

/*
 * Description:
 * Enables the specified interrupt source.
 *
 * Implementation:
 * Writes to the interrupt controller mask to enable the interrupt.
 * Whether the source generates either an IRQ or FIQ should have been
 * pre-chosen by the user by calling apVIC_PrioritySet() (otherwise the
 * default action is to assign it to IRQ).
 *
 * Always ensure that you have set an interrupt handler
 * for a particular source before enabling its interrupt. Otherwise
 * the system will try to detect that this situation has occurred and
 * ignore the request to enable the interrupt.
 * This function does not return any errors.
 *
 * Inputs:
 *  oSource     - The interrupt source to enable.
 *
 * Return values:
 *  apERR_NONE          - The interrupt source enabled, no errors
 *  apERR_BAD_PARAMETER - The specified controller is out of the 
 *                        current implementation's range
 */
PUBLIC apError apVIC_InterruptEnable( CONST apOS_INT_oInterruptSource oSource );


/*
 * Description:
 * Disables the specified interrupt source from producing an interrupt.
 *
 * Implementation:
 * Writes to the interrupt controller mask to disable the specified interrupt.
 * All other interrupt sources remain unaffected.
 * This function does not return any errors.
 * 
 * Inputs:
 *  oSource     - The interrupt source to disable
 */
PUBLIC void apVIC_InterruptDisable( CONST apOS_INT_oInterruptSource oSource );


/*
 * Description:
 * Temporarily disables all interrupts for a particular interrupt controller.
 *
 * Implementation:
 * Disables the interrupt sources for this controller in hardware
 * (keeping a software copy for re-enabling them using apVIC_ControllerRestore()).
 * All subsequent accesses to the VIC module act only on this
 * software copy, until such time as the function apVIC_ControllerRestore()
 * is called to countermand this function.
 *
 * Note: Do not nest apVIC_ControllerDisable()/apVIC_ControllerRestore() pairs.
 * If you were to for example Disable, Disable, Restore, Restore,
 * then the first call to apVIC_ControllerRestore will restore the
 * interrupts (not the second as might be expected).
 *
 * Inputs:
 *  oController - The interrupt controller to disable.
 */
PUBLIC void apVIC_ControllerDisable( apOS_VIC_oId oController );


/*
 * Description:
 * Use to return to normal operation after a call to apVIC_ControllerDisable().
 *
 * Implementation:
 * Re-enables all the interrupts which were enabled before
 * a call to apVIC_ControllerDisable().
 * Copies the software version of the interrupt sources which
 * are enabled to the hardware, and allows the other
 * interrupt functions to access the hardware directly again.
 *
 * Inputs:
 *  oController - The interrupt controller to restore.
 */
PUBLIC void apVIC_ControllerRestore( apOS_VIC_oId oController );


/*
 * Description:
 * Clears the interrupt for specified controller.
 *
 * Implementation:
 * Clears VIC harware interrupt priority logic.
 * Should be called only at the end of Raw interrupt handler.
 *
 * Inputs:
 *  oController     - The interrupt controller to clear interrupt
 */
PUBLIC void apVIC_InterruptClear( apOS_VIC_oId oController );


/*
 * Description:
 * Set an interrupt handling function for a specified interrupt
 * source. Also registers an ID number (or instance) which will be
 * passed to the interrupt handler when the interrupt occurs.
 *
 * Implementation:
 * Only one handler can be assigned to each source, and if a
 * second is assigned to a source, then the first will be removed, and
 * then the second added.
 *
 * The handler will be assigned to either Vectored IRQ or
 * non-vectored FIQ, depending on how the source was set up
 * using the function apVIC_SetPriority().
 *
 * The ID number specified to be associated with the interrupt source
 * is designed to allow the same interrupt handling function to be used
 * for multiple interrupt sources (for example in a system
 * where there are several identical timers). The ID number is passed
 * to the interrupt handling function (as the first parameter, in R0)
 * to allow it to know which of the interrupt sources has generated the
 * interrupt.
 *
 * Note: always set a handling function before enabling the corresponding
 * interrupt source.
 * 
 * Note: This function must not be called from an interrupt handler
 *
 * Inputs:
 *  oSource     - The interrupt source to attach the handler to
 *  rHandler    - The interrupt handling function.
 *  Parameter   - Parameter to be associated with this interrupt source
 *                and passed to the handler function when the interrupt
 *                occurs
 *
 * Return values:
 *  apERR_NONE                 - Interrupt Handler set up, no errors
 *  apERR_VIC_BAD_CALL         - The function was called whilst interrupt is being serviced
 *  apERR_VIC_SOURCE_NOT_FOUND - Interrupt source not found
 */
PUBLIC apError apVIC_HandlerSet( CONST apOS_INT_oInterruptSource oSource,
                                 apOS_INT_rServiceRoutine        rHandler, 
                                 UWORD32                         Parameter );

/*
 * Description:
 * Set an Raw interrupt handling function for a specified interrupt
 * source in order to speed up the interrupt handling response.
 * This function will not pass ID number to the handler so that can
 * avoid extra stacking cycles.
 *
 * Implementation:
 * Only one handler can be assigned to each source, and if a
 * second is assigned to a source, then the first will be removed, and
 * then the second added.
 *
 * Note: always set a handling function before enabling the corresponding
 * interrupt source.
 * 
 * Note: This function must not be called from an interrupt handler
 *
 * Inputs:
 *  oSource     - The interrupt source to attach the handler to
 *  rRawHandler - The RawISR function
 * 
 * Return values:
 *  apERR_NONE                 - IRQ Raw Handler set up, no errors
 *  apERR_VIC_BAD_CALL         - The function was called whilst interrupt is being serviced
 *  apERR_VIC_SOURCE_NOT_FOUND - No free interrupt source found
 */
PUBLIC apError apVIC_RawHandlerSet( CONST apOS_INT_oInterruptSource oSource,
                                    apOS_INT_rRawISR                rRawHandler );

/*
 * Description:
 * Removes the interrupt handling function for a specified interrupt
 * source and reset to default which does nothing inside. 
 *
 * Implementation:
 * As only one handler can be assigned to each source, removing it
 * will leave a default handler for a particular interrupt. Therefore,
 * this routine also disables the interrupt by calling the
 * function apVIC_InterruptDisable(). This function will also reset 
 * the interrupt type of this source as IRQ.
 *
 * Inputs:
 *  oSource     - The interrupt source to remove the handler from
 *
 * Return values:
 *  apERR_NONE                 - Handler cleared, no errors
 *  apERR_VIC_SOURCE_NOT_FOUND - Interrupt source not found
 */
PUBLIC apError apVIC_HandlerClear( CONST apOS_INT_oInterruptSource oSource );


/*
 * Description:
 * Generates a user specified programmable interrupt. This
 * will interrupt the processor if the interrupt selected
 * has been enabled.
 *
 * Implementation:
 *
 * Inputs:
 *  oSource     - The interrupt source to set
 */
PUBLIC void apVIC_ProgrammedInterruptSet( CONST apOS_INT_oInterruptSource oSource );


/*
 * Description:
 * Clears a previsouly set user specified programmable interrupt.
 *
 * Inputs:
 *  oSource     - The interrupt source to clear
 */
PUBLIC void apVIC_ProgrammedInterruptClear( CONST apOS_INT_oInterruptSource oSource );

/*
 * Description:
 * Defines status of the interrupt sources.
 * A HIGH bit in return value indicates that
 * the appropriate interrupt request is active before masking.
 *
 * Inputs:
 *  oController - The interrupt controller to define status
 *
 * Return value:
 *  Interrupt status before masking. 
 */
PUBLIC UWORD32 apVIC_GetInterruptStatus( apOS_VIC_oId oController );

/*
 * Description:
 * Registers a function to be called when an IRQ interrupt exception
 * occurs, but before the interrupt dispatcher (and the individual
 * interrupt handlers) are called.
 *
 * Implementation:
 * Registering a function supercedes any previous registered function.
 * If a NULL pointer is passed, the pre-dispatcher function will not be called.
 *
 * Note:
 * For this to have effect, the pre-processor constant 
 * apOS_CONFIG_VIC_USE_PREDISPATCH_CODE must have been #defined to 1.
 * 
 * Inputs:
 * rPreDispatchHandler - Pointer to the function to be registered
 */
PUBLIC void apVIC_IRQPreDispatchSet( apVIC_rDispatchHandler rPreDispatchHandler );


/*
 * Description:
 * Registers a function to be called when an IRQ interrupt exception
 * occurs, but after the interrupt dispatcher (and the individual
 * interrupt handlers) are called.
 *
 * Implementation:
 * Registering a function supercedes any previous registered function.
 * If a NULL pointer is passed, the post-dispatcher function will not be called.
 *
 * Note:
 * For this to have effect, the pre-processor constant 
 * apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE must have been #defined to 1.
 *
 * Inputs:
 * rPostDispatchHandler - Pointer to the function to be registered
 */
PUBLIC void apVIC_IRQPostDispatchSet( apVIC_rDispatchHandler rPostDispatchHandler );

/*
 * Description:
 * Registers a source which will be marked as the only active registered
 * interrupt source for FIQ.
 * If this pointer to the source is non-zero, then this entry will always
 * be loaded and its ISR called whenever an FIQ exception occurs.
 * If the table lookup is required (if there is more than one FIQ handler,
 * or if interrupt source checking is required) then define this switch
 * to FALSE or set the pointer to NULL by calling
 * apVIC_SingleFIQSourceClear() function.
 *
 * Implementation:
 * Registering an interrupt source supercedes any previous registered source.
 *
 * Note:
 * For this to have effect, the pre-processor constant 
 * apOS_CONFIG_VIC_SINGLE_FIQ must have been #defined to 1.
 *
 * Inputs:
 *  oSource     - The interrupt source to be registered.
 *
 * Return values:
 *  apERR_NONE                 - FIQ single source set up, no errors
 *  apERR_VIC_BAD_CALL         - The function was called whilst interrupt is being serviced
 *  apERR_VIC_SOURCE_NOT_FOUND - Interrupt source not found
 *  apERR_VIC_BAD_INT_TYPE     - The source has different interrupt type (non FIQ)
 */
PUBLIC apError apVIC_SingleFIQSourceSet( CONST apOS_INT_oInterruptSource oSource );

/*
 * Description:
 * Clears a source which was marked as the only active
 * registered interrupt source for FIQ.
 *
 * Note:
 * For this to have effect, the pre-processor constant 
 * apOS_CONFIG_VIC_SINGLE_FIQ must have been #defined to 1.
 *
 * Return values:
 *  apERR_NONE                 - FIQ single source cleared, no errors
 *  apERR_VIC_BAD_CALL         - The function was called whilst interrupt is being serviced
 *  apERR_VIC_SOURCE_NOT_FOUND - Interrupt source not found
 *  apERR_VIC_BAD_INT_TYPE     - The source has different interrupt type (non FIQ)
 */
PUBLIC void apVIC_SingleFIQSourceClear( void );


#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif  /* __cplusplus */

#endif /* APPL192_H */
