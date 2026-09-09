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
 * File:     apint.h,v
 * Revision: 1.27
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : apint.h.rca
 *  File Revision          : 1.8
 * 
 *  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
 *  ----------------------------------------
 *
 * Public API header for the Interrupt Controller Module device drivers.
 */


/* 
 * Description:
 * All public Interrupt Module functions, types, and enums
 * have the prefix "apINT_"
 *
 * Implementation:
 * The functions have designed such that there are two sorts
 * of functions, those designed to be called by the central system
 * at initialisation:
 *
 *  + apINT_Initialize
 *  + apINT_PrioritySet
 *  + apINT_SenseSet
 *
 * and those designed to be called by individual peripheral drivers
 * during their initialisation and operation:
 *
 *  + apINT_HandlerSet
 *  + apINT_InterruptEnable
 *  + apINT_InterruptClear
 *  + apINT_InterruptDisable
 *  + apINT_HandlerRemove
 *
 * System Initialization:
 * The function apINT_Initialize() must be called before any
 * of the other functions in this module (or any of the other
 * interrupt driven peripheral drivers). This call sets the
 * defaults for the interrupt module, and resets the internal
 * state for the drivers.
 *
 * To initialise each individual interrupt source the following
 * functions must be called by the system:
 *  + apINT_PrioritySet
 *  + apINT_SenseSet
 *
 * The above two functions do not have to be called for those sources
 * for which the default sense and priority (as set by apINT_Initialize)
 * were correct for this particular source.
 *
 * Peripheral Drivers:
 * At initialisation each peripheral driver should register and enable an
 * interrupt handler by calling the following two functions:
 *  + apINT_HandlerRegister
 *  + apINT_InterruptEnable
 *
 * During the handling of an interrupt, the peripheral driver should:
 *  + call apINT_InterruptDisable
 *  + handle the interrupt in the peripheral to cancel the interrupt source
 *  + call apINT_InterruptClear, to clear the interrupt in the interrupt module.
 *  + call apINT_InterruptEnable, to re-enable the interrupt again.
 *
 */

#ifndef APINT_H
#define APINT_H

#include "../apcommon/cmacros.h" /* This is required to include apintcfg.h */
#include "../apos/apintcfg.h"    /*Interrupt configuration file*/

#ifdef	__cplusplus
extern "C" {	/* allow C++ to use these headers */
#endif	/* __cplusplus */

/*=======================================================================*/
/* Type definitions - used to pass parameters to the API functions.      */
/*=======================================================================*/

/*
 * Description:
 * Enumeration of the possible routes by which an interrupt
 * generates a processor exception, either to IRQ or FIQ.
 */
typedef enum apINT_eInterruptType
{
  apINT_IRQ = 0, // Generates an IRQ exception
  apINT_FIQ = 1  // Generates an FIQ exception
}
apINT_eInterruptType;


/*
 * Description:
 * Enumeration of the possible combinations of polarity
 * and edge/level sensitivity of a peripheral's
 * interrupt signal.
 */
typedef enum apINT_eInterruptSense
{
  apINT_ACTIVE_LOW    = 0, // Active low (level sensitive)
  apINT_ACTIVE_HIGH   = 1, // Active high (level sensitive)
  apINT_FALLING_EDGE  = 2, // Falling edge (edge sensitive)
  apINT_RISING_EDGE   = 3, // Rising edge (edge sensitive)
  apINT_BOTH_EDGES    = 6, // Both edges (edge sensitive)
  apINT_DEFAULT_SENSE = 8  // Leave as the default reset value.
}
apINT_eInterruptSense;


/*
 * Description:
 * Structure for passing the default interrupt sense and priority
 * into the interrupt initialization function apINT_Initialize.
 */
typedef struct apINT_sInitialData
{
    apINT_eInterruptSense eSense; // the default sense to assign to all interrupts
    UBYTE8 Priority;              // the default interrupt priority, values are as
                                  // defined for the function apINT_PrioritySet
}
apINT_sInitialData;


/*
 * Description:
 * Function type for use with apINT_PreDispatchSet() and
 * apINT_PostDispatchSet().
 *
 * Implementation:
 * The pre and post dispatch handlers are intended for additional
 * processing each time an IRQ interrupt occurs. Typically, an OS will
 * save the interrupted process state, before calling the interrupt
 * handler, and then restore it afterwards. It may also choose to
 * swap out the interrupted process and schedule one of higher
 * priority.
 * Note: These are not APCS compliant functions, as they do not
 * return to the link register, but must branch directly back into
 * the interrupt dispatch code.
 */
typedef void (apINT_rDispatchHandler) (void);


/*=======================================================================*/
/* Public functions - defines the API to the drivers.                    */
/*=======================================================================*/

/*
 * Description:
 * Initialises the interrupt system, configures all the interrupt
 * sources to the same specified default, and specifies the base address
 * of the interrupt hardware registers.
 *
 * Implementation:
 * The specified base address is remembered for all future accesses
 * to the interrupt hardware using this API.
 * All interrupt sources are disabled, by masking out the interrupts.
 * All interrupt handlers are removed.
 * All interrupts are set to the specified default sense and type.
 * All interrupts are assigned to IRQ by default where physically possible,
 * and with the default priority specified.
 *
 * Inputs:
 * oId          - the interrupt controller to initialise
 * eBase        - the base address of the interrupt hardware registers.
 * Interrupts   - pass as aNULL
 * pSources     - pass as aNULL
 * pInitial     - pointer to structure containing default sense and priorities
 *                to be used for each interrupt source.
 */
PUBLIC apError apINT_Initialize(apOS_INT_oId                        oId,
                                apOS_System_eBaseAddress            eBase,
                                UWORD32                             Interrupts,
                                CONST apOS_INT_oInterruptSource     *pSources,
                                apINT_sInitialData                  *pInitial );
/*
 * Description:
 * Selects whether the specified interrupt source would either produce
 * an IRQ or FIQ interrupt exception. Also records the priority level
 * of the interrupt, this is used to determine which interrupts get
 * serviced first if there are multiple outstanding active interrupt
 * sources.
 *
 * Implementation:
 * Selects the interrupt type for this interrupt source, the
 * default (if this function is not called) is that the
 * interrupt is assumed to be an IRQ, with default priority
 * (specified when apINT_Initialize was called)
 *
 * Note:
 * This function does not enable the interrupt. To enable
 * the interrupt call the function apINT_InterruptEnable().
 *
 * This causes an update of the interrupt dispatch table
 * during which all interrupts will be temporarily disabled.
 * 
 * Inputs:
 * oSource        - the interrupt source to enable
 * eType          - which exception to produce, either apINT_FIQ or apINT_IRQ.
 * Priority       - the interrupt priority, integer from 0 (lowest priority) to
 *                  31 (highest priority).
 */
PUBLIC void apINT_PrioritySet(  CONST apOS_INT_oInterruptSource oSource,
                                apINT_eInterruptType            eType,
                                UBYTE8                          Priority );


/*
 * Description:
 * Selects the interrupt type. The type specifies whether the
 * interrupt is level low, level high, rising edge, falling edge
 * or sensistive to both edges.
 *
 * Implementation:
 * Selects the interrupt sensitivity for this interrupt source, the
 * default (if this function is not called) is determined by the
 * settings specified by the call to apINT_Initialize.
 *
 * All interrupts may be temporarily disabled, and any outstanding
 * latched edge-sensitive interrupts are cleared. Any interrupts which
 * were already enabled, are re-enabled.
 *
 * To enable an interrupt which was previously disabled,
 * call the function apINT_InterruptEnable().
 * 
 * Inputs:
 * oSource         - the interrupt source sensitivity to change
 * eSense          - the polarity and edge/level sensitivity for this source.
 *
 * Return Value:
 * Returns an error value which can be one of:
 * + apERR_NONE         - no error occured
 * + apERR_UNSUPPORTED  - the sensitivity type is not supported by this hardware
 *
 */
PUBLIC apError apINT_SenseSet(  CONST apOS_INT_oInterruptSource oSource,
                                apINT_eInterruptSense           eSense );


/*
 * Description:
 * Enables the specified interrupt source.
 *
 * Implementation:
 * Writes to the interrupt controller mask to enable the interrupt.
 * Whether the source generates either an IRQ or FIQ should have been
 * prechosen by the user by calling apINT_PrioritySet (otherwise the
 * default action is to assign it to IRQ).
 *
 * Always ensure that you have registered an interrupt handler
 * for a particular source before enabling its interrupt. Otherwise
 * the system will try to detect that this situation has occured and
 * ignore the request to enable the interrupt.
 * This function does not return any errors.
 *
 * Inputs:
 * oSource         - the interrupt source to enable.
 */
PUBLIC apError apINT_InterruptEnable( CONST apOS_INT_oInterruptSource oSource );


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
 * oSource         - the interrupt source to disable
 */
PUBLIC void apINT_InterruptDisable( CONST apOS_INT_oInterruptSource oSource );


/*
 * Description:
 * Temporarily disables all interrupts for a particular interrupt controller.
 *
 * Implementation:
 * Disables all of the interrupt sources for this controller in hardware
 * (keeping a software copy for re-enabling them using apINT_ControllerRestore).
 * All subsequent accesses to the interrupt module act only on this
 * software copy, until such time as the function apINT_ControllerRestore
 * is called to countermand this function.
 * Any other interrupt controllers which funnel into one of the interrupt sources
 * of the controller specified will be disabled by this call.
 * Do not nest apINT_ControllerDisable/apINT_ControllerRestore pairs.
 * If you were to (for example Disable,Disable,Restore,Restore)
 * then the first call to apINT_ControllerRestore will restore the
 * interrupts (not the second as might be expected).
 *
 * Inputs:
 * oId - the interrupt controller to disable.
 */
PUBLIC void apINT_ControllerDisable( apOS_INT_oId oId );


/*
 * Description:
 * Use to return to normal operation after a call to apINT_ControllerDisable.
 *
 * Implementation:
 * Re-enables all the interrupts which were enabled before a
 * call to apINT_ControllerDisable.
 * Copies the software version of the interrupt sources which
 * are enabled to the hardware, and allows the other
 * interrupt functions to access the hardware directly again.
 *
 * Inputs:
 * oId - the interrupt controller to restore.
 */
PUBLIC void apINT_ControllerRestore( apOS_INT_oId oId );


/*
 * Description:
 * Clears the specified interrupt source.
 *
 * Implementation:
 * Writes to the interrupt controller clear register to clear the
 * specified interrupt. This function does not return any errors.
 * 
 * Note, before clearing the interrupt in the interrupt controller,
 * the peripheral generating the interrupt should be serviced to
 * prevent the interrupt being asserted multiple times for the
 * same reason.
 *
 * Inputs:
 * oSource         - the interrupt source to clear
 */
PUBLIC void apINT_InterruptClear( CONST apOS_INT_oInterruptSource oSource );

 
/*
 * Description:
 * Registers an interrupt handling function for a specified interrupt
 * source. Also registers an ID number which will be passed to the
 * interrupt handler when the interrupt occurs.
 *
 * Implementation:
 * Only one handler can be assigned to each source, and if a
 * second is assigned to a source, then the first will be removed, and
 * then the second added. This function does not return any errors.
 *
 * The handler will be assigned to either IRQ or FIQ depending on
 * how the source was set up using the function apINT_SelectPriority.
 *
 * The ID number specified to be associated with the interrupt source
 * is designed to allow the same interrupt handling function to be used
 * for multiple interrupt sources (for example in a system
 * where there are several identical timers). The ID number is passed
 * to the interrupt handling function (as the first parameter, in R0)
 * to allow it to know which of the interrupt sources has generated the
 * interrupt.
 * 
 * Note:
 * Always register a handling function before enabling the
 * corresponding interrupt source.
 *
 * Inputs:
 * oSource        - the interrupt source to attach the handler to.
 * rHandler       - the interrupt handling function.
 * Parameter      - parameter to be associated with this interrupt source
 *                  and passed to the handler function when the interrupt
 *                  occurs.
 */
PUBLIC void apINT_HandlerSet(   CONST apOS_INT_oInterruptSource     oSource,
                                apOS_INT_rServiceRoutine            rHandler,
                                UWORD32                             Parameter );

/*
 * Description:
 * Removes an interrupt handling function for a specified interrupt
 * source.
 *
 * Implementation:
 * As only one handler can be assigned to each source, removing it
 * will leave no handlers for a particular interrupt. Therefore,
 * this routine also disables the interrupt by calling the
 * function apINT_InterruptDisable(). Does not return any errors.
 *
 * Inputs:
 * oSource         - the interrupt source to remove the handler from.
 */
PUBLIC void apINT_HandlerClear( CONST apOS_INT_oInterruptSource oSource );


/*
 * Description:
 * Chains an interrupt controller from an interrupt source
 * in a different interrupt controller.
 *
 * Implementation:
 * Only one controller or handler can be assigned to each source,
 * and if a second controller or handler is assigned to a source,
 * then the first will be removed, and then the second added.
 * This function does not return any errors.
 *
 * The interrupt source that the controller is chained from must be
 * subsequently enabled in order for interrupt requests from the chained
 * controller to interrupt the processor.
 *
 * The chaining can be broken by calling apINT_HandlerClear for the
 * interrupt source the controller is chained from.
 *
 * Inputs:
 * oSource        - the interrupt source to attach the handler to.
 * oId            - the interrupt controller to be chained to this source.
 *
 */
PUBLIC void apINT_HandlerChain( CONST apOS_INT_oInterruptSource oSource,
                                apOS_INT_oId                    oId );

/*
 * Description:
 * Generates a user specified programmable interrupt. This
 * will interrupt the processor, if the interrupt selected
 * has been enabled.
 *
 * Implementation:
 * Will only work if the interrupt hardware supports
 * programmable interrupts. Some hardware only partially
 * supports programmable interrupts, by providing just one
 * independent programmable interrupt source, rather than
 * allowing any interrupt source to be programmed.
 *
 * Inputs:
 * oSource         - the interrupt source to set.
 */
PUBLIC apError apINT_ProgrammedInterruptSet( CONST apOS_INT_oInterruptSource oSource );


/*
 * Description:
 * Clears a previously set user specified programmable interrupt.
 *
 * Inputs:
 * oSource         - the interrupt source to clear.
 */
PUBLIC apError apINT_ProgrammedInterruptClear( CONST apOS_INT_oInterruptSource oSource );


/*
 * Description:
 * Registers a function to be called when an IRQ interrupt exception
 * occurs, but before the interrupt dispatcher (and the individual
 * interrupt handlers) are called.
 *
 * Implementation:
 * Registering a function supercedes any previous registered function.
 * A NULL pointer should not be passed
 *
 * Note:
 * For this to have effect, the pre-processor constant 
 * apOS_CONFIG_INT_USE_PREDISPATCH_CODE must have been #defined to 1.
 * 
 * Inputs:
 * rPreDispatchHandler - pointer to the function to be registered
 */
PUBLIC void apINT_IRQPreDispatchSet( apINT_rDispatchHandler rPreDispatchHandler );


/*
 * Description:
 * Registers a function to be called when an IRQ interrupt exception
 * occurs, but after the interrupt dispatcher (and the individual
 * interrupt handlers) are called.
 *
 * Implementation:
 * Registering a function supercedes any previous registered function.
 * A NULL pointer should not be passed
 *
 * Note:
 * For this to have effect, the pre-processor constant 
 * apOS_CONFIG_INT_USE_PREDISPATCH_CODE must have been #defined to 1.
 *
 * Inputs:
 * rPostDispatchHandler - pointer to the function to be registered
 */
PUBLIC void apINT_IRQPostDispatchSet( apINT_rDispatchHandler rPostDispatchHandler );


/*
 * Description:
 * This function returns a pointer to the software version of the register
 * indicating which (IRQ) interrupts the user has asked to be enabled for
 * the root interrupt controller (number 0).
 *
 * Note:
 * This is provided for backdoor optimisations in critical pieces of assembler
 * code. It is not recommended to use this function unless you (a) really have
 * to, and (b) you really know how the rest of this code works. Don't use
 * if compiled for nested/re-entrant interrupts. Don't alter the hardware
 * register based on this if in between a apINT_ControllerDisable and
 * apINT_ControllerRestore pair. Only alter this register when all interrupts
 * are disabled.
 * 
 * Implementation:
 * For some interrupt controllers this value is for all interrupts (IRQ 
 * and FIQ), whereas for interrupt controllers with seperate IRQ and FIQ
 * enable registers it is for IRQs only.
 */
PUBLIC UWORD32 *apINT_IRQEnabledMaskPtrGet( void );


#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif	/* __cplusplus */

#endif // APINT_H
