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
 * File:     int.h,v
 * Revision: 1.30
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : int.h.rca
 *  File Revision          : 1.8
 * 
 *  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
 *  ----------------------------------------
 *
 * Private header for the Interrupt Controller Module device drivers,
 * this should not be included by any file outside the interrupt 
 * controller sources.
 */


#ifndef INT_H
#define INT_H

#ifdef	__cplusplus
extern "C" {	/* allow C++ to use these headers */
#endif	/* __cplusplus */

#ifndef apOS_INT_CONFIG_SOURCES_USED
/*
 * Description:
 * Defines the maximum number of interrupt sources to be used in the system.
 * This is the sum of the all the sources in all the interrupt controllers
 * in the system.
 *
 * Implementation:
 * Due to the way the interrupt controller has been implemented 
 * internally. this number must not exceed 256.
 * Although this number may be greater than 32, there cannot be more
 * than 32 interrupt sources per interrupt controller.
 * Interrupt sources which are not used (even for setting or registering)
 * do not have to be counted.
 *
 */
#define apOS_INT_CONFIG_SOURCES_USED (32 * apOS_INT_MAXIMUM)
#endif

/*
 * Description:
 * If the time between the core writing to the interrupt controller 
 * registers, and the interrupt controller acting on the write is 
 * significant then this must be set to 1. Else set to 0.
 * An example of where this should be done is the Integrator system
 * where the interrupt controller is in FPGA at the end of a slow
 * and write buffered peripheral bus.
 *
 * Implementation:
 * This causes all critical writes to the interrupt controller 
 * (enabling and disabling interrupts) to be followed by a read
 * from the same register. This ensures that the write is performed
 * (apart from rare systems where the read bypasses any write buffer).
 */
#if (apINT_VERSION & apVERSION_INTEGRATOR)
#define INT_SLOW_CONTROLLER 1
#else
#define INT_SLOW_CONTROLLER 0
#endif


/*
 * Description:
 * There are a two fundemental types of supported 
 * interrupt controllers, they either have:
 *  (a) two registers enabling interrupt 
 *      sources (one for IRQ and one for FIQ) and 
 *  (b) one single register controlling enabling for
 *      both IRQ and FIQ (routing is done via a 
 *      separate register.
 */
#if (apINT_VERSION & apVERSION_INTEGRATOR)
#define INT_SINGLE_ENABLE 0
#elif (apINT_VERSION & apVERSION_ARMULATOR)
#define INT_SINGLE_ENABLE 0
#else
#define INT_SINGLE_ENABLE 1
#endif


/*
 * Description:
 * Used to mark unused entries (in the source item) in the table of interrupt sources.
 */
#define INT_UNUSED_SOURCE 0xFF20

/*
 * Description:
 * Used to mark the first entry (in the source item) in the table of interrupt sources.
 * This entry is used as a default to which all non-registered interrupts are taken.
 * Must be a non-valid source, and different to INT_UNUSED_SOURCE.
 */
#define INT_DEFAULT_SOURCE 0xFF40

/*
 * Description:
 * Structure which maps onto the interrupt controller's hardware control registers.
 * Note, all of these control registers are bit mapped, where each bit in the 
 * register represents a different interrupt source. Only change the bits you
 * need to (thus a read-modify-write is required in many cases).
 */
 
#if (apINT_VERSION & apVERSION_INTEGRATOR)

    typedef volatile struct INT_sRegisters
    {
      UWORD32 IrqStatus;      // IRQ Interrupt status (as seen by processor, but before masking)
      UWORD32 IrqRawStatus;   // Raw IRQ interrupt status (before polarity or latching)
      UWORD32 IrqEnableSet;   // IRQ Interrupt enable, sets bits in enable mask (read to get mask)
      UWORD32 IrqEnableClr;   // IRQ Interrupt clear, write set bits to clear bits in mask
      UWORD32 IrqSoftSet;     // Writing to this generates a programmable interrupt 
      UWORD32 IrqSoftClear;   // Writing to this clears a programmable interrupt

      UWORD32 IrqReserved[2];
      
      UWORD32 FiqStatus;      // FIQ Interrupt status (as seen by processor, but before masking)
      UWORD32 FiqRawStatus;   // Raw FIQ interrupt status (before polarity or latching)
      UWORD32 FiqEnableSet;   // FIQ Interrupt enable, sets bits in enable mask (read to get mask)
      UWORD32 FiqEnableClr;   // FIQ Interrupt clear, write set bits to clear bits in mask      
     }
     INT_sRegisters;
     
 #elif (apINT_VERSION & apVERSION_ARMULATOR)
     typedef volatile struct INT_sRegisters
    {
      UWORD32 IrqStatus;      // IRQ Interrupt status (as seen by processor, but before masking)
      UWORD32 IrqRawStatus;   // Raw IRQ interrupt status (before polarity or latching)
      UWORD32 IrqEnableSet;   // IRQ Interrupt enable, sets bits in enable mask (read to get mask)
      UWORD32 IrqEnableClr;   // IRQ Interrupt enable clear, write set bits to clear bits in mask
      UWORD32 IrqSoft;        // Writing to this generates a programmable interrupt 

      UWORD32 IrqReserved[0x40-0x06];
      
      UWORD32 FiqStatus;      // FIQ Interrupt status (as seen by processor, but before masking)
      UWORD32 FiqRawStatus;   // Raw FIQ interrupt status (before polarity or latching)
      UWORD32 FiqEnableSet;   // FIQ Interrupt enable, sets bits in enable mask (read to get mask)
      UWORD32 FiqEnableClr;   // FIQ Interrupt enable clear, write set bits to clear bits in mask      
     }
     INT_sRegisters; 
 #endif

/*
 * Description:
 * Structure for each line in the interrupt source dispatching lookup table.
 * The organisation of this must not be changed, as the interrupt dispatcher
 * relies on it. 
 *
 * Remarks:
 * The interrupt dispatcher code assumes (and requires) that the table
 * has four words (16 bytes) per entry.
 */
typedef struct INT_sSourceEntry
{
    UWORD32                   oSource;         // The users handle for this interrupt source
                                               // should be a CONST apOS_INT_oInterruptSource, but the
                                               // compiler will optimise this to being a char,
                                               // causing the code to fail.
    UWORD32                   Parameter;       // The user's 32-bit parameter to pass back.
    apOS_INT_rServiceRoutine  rHandler;        // The ISR function to call if we match this ID
    UWORD32                   HigherPriorities;// Mask with bits set for those sources 
                                               // with a higher priority than this one,
                                               // used for interrupt reentrancy.
} INT_sSourceEntry;

/* 
 * Description:
 * The Sense and Routing are in fact enumerations, but are explicitly 
 * cast to UBYTE8 as this requires less storage space.
 */
typedef struct INT_sSourceParameters
{
    UBYTE8                    Priority;        // Interrrupt priority (0 lowest, to 31 highest)
    UBYTE8                    Sense;           // Sense, edge or level triggered, level high or low
    UBYTE8                    Routing;         // The routing to IRQ or FIQ,
} INT_sSourceParameters;

/*
 * Description:
 * State structure required for each of the individual interrupt modules.
 * The first few entries (indicated) are used by the interrupt dispatcher routines,
 * do not modify the structure before these entries.
 */
typedef struct INT_sControllerState 
 {

    /* 
     * Base address of interrupt module, as supplied to the initialisation function 
     * (used by the dispatcher function).
     */
    INT_sRegisters *pBaseAddress;

   #if (INT_SINGLE_ENABLE)
    /* 
     * The software's idea of the interrupts which are enabled at any one 
     * time. The user must not access the hardware without going through 
     * the API or else this will become out of sync. Each bit corresponds 
     * to an interrupt source. Set bits indicate enabled sources.
     */
    UWORD32 IntEnabled;
   #else
    /* 
     * The software's idea of which IRQ interrupts are enabled at any one 
     * time. The user must not access the hardware without going through 
     * the API or else this will become out of sync. Each bit corresponds 
     * to an interrupt source. Set bits indicate enabled sources.
     * The FIQ equivalent is at the end.
     */
    UWORD32 IrqEnabled;
   #endif
        
    /* 
     * Set of priority encoded masks used by the dispatcher to 
     * prioritize the incoming interrupt sources.
     */
    UWORD32 Masks[5];

    /*
     * Pointer to real interrupt source table (needed here for 
     * dispatching routine).
     */
    INT_sSourceEntry *pTable;

    /* 
     * Priority encoded index lookup table into the common interrupt
     * source table (which contains all the registered information for 
     * an interrupt source). This is used by the dispatcher.
     */
    UBYTE8 Indices[32];
    
    /* 
     * The software's idea of the interrupts which are routed to FIQ 
     * (as opposed to IRQ). Each bit corresponds to an interrupt source. 
     * A set bit indicates the source should be routed to FIQ.
     */
    UWORD32 IntRouting;

    /*
     * Default interrupt sense to be used for all interrupt sources for this
     * controller which do not have the sense explicitly set.
     */
    apINT_eInterruptSense eDefaultSense;


    /*
     * Default priority to be used for all interrupt sources for this controller
     * which do not have the priority explicitly set.
     */
    UBYTE8 DefaultPriority;
    
    /* 
     * Signals that only the software version of the enabled interrupts
     * should be modified. The hardware registers are left unchanged.
     */
    BOOL LeaveHardware;

    /* 
     * Pointer into main interrupt table for a source which is marked as
     * the only active registered interrupt source for FIQ. If this is non-zero 
     * then this entry will always be loaded and its ISR called
     * whenever an FIQ exception occurs, whether or not the source is 
     * actually active or not (there is no source bit checking in the status
     * register if this is enabled).
     * If the table lookup is required (if there is more than one 
     * FIQ handler, or if interrupt source checking is required) then
     * set this to zero.
     */
    INT_sSourceEntry *pFIQOnlyEntry;

   #if (!INT_SINGLE_ENABLE)
    /* 
     * The software's idea of which FIQ interrupts are enabled at any one 
     * time. The user must not access the hardware without going through 
     * the API or else this will become out of sync. Each bit corresponds 
     * to an interrupt source. Set bits indicate enabled sources.
     */
    UWORD32 FiqEnabled;    
  #endif
 }
 INT_sControllerState;
 
 
/*
 * Description:
 * State structure for the state which is common to all interrupt modules
 */
typedef struct INT_sIntState
{

    /* 
     * The pre and post dispatch handler routine pointers.
     * These must be set up to point to valid dispatch
     * handlers (unless the dispatch.s routines are compiled
     * not to call these ever).
     * Note: These are not APCS compliant functions, they
     * do not return via the link register.
     */
     apINT_rDispatchHandler *rIRQPreDispatchCode;
     apINT_rDispatchHandler *rIRQPostDispatchCode;
     
    /*
     * The state required for each interrupt controller. 
     */
    INT_sControllerState sControllers[apOS_INT_MAXIMUM];
    
    /* 
     * The actual interrupt source information table. The entries
     * are not ordered in any fashion, and each new entry is 
     * added to the end as each individual source is accessed,
     * via either the user registering an interrupt function,
     * or changing the defaults for the source. Enabling an
     * interrupt will fail unless a handler is registered.
     *
     * The size of this table is the maximum number of sources 
     * plus one for the end of table marker. This single 
     * instantiation of the table is used for all interrupt
     * controllers.
     *
     * The information in this table is used by the interrupt
     * dispatching routines.
     *
     */
    INT_sSourceEntry sTable[apOS_INT_CONFIG_SOURCES_USED+1];
    
    /*
     * The interrupt source information left over from sTable (ie 
     * the info that isn't required by the dispatcher).
     */ 
    INT_sSourceParameters sParameters[apOS_INT_CONFIG_SOURCES_USED+1];
    
} INT_sIntState;


/* 
 * Example of the simplest IRQ Pre-dispatcher handler - all the 
 * state must be stored safely somewhere by this function, here
 * it is pushed onto the IRQ stack. Note: the dispatcher must
 * have been compiled to use a pre-dispatch handler or else
 * this won't be called.
 */
extern void apINT_IRQPreDispatchCode(void);

/* Example of the simplest IRQ Pre-dispatcher handler. Here 
 * the state from before the interrupt is restored from the 
 * IRQ stack. In some systems you might want to restore the 
 * state from another process. Note: the dispatcher must
 * have been compiled to use a post-dispatch handler or else
 * this won't be called.
 */
extern void apINT_IRQPostDispatchCode(void);

/*
 * Description:
 * Prototype of the chained dispatcher function in dispatch.s,
 * required by the function apINT_HandlerChain.
 */
extern void apINT_ChainedDispatcher(CONST apOS_INT_oInterruptSource oSource,
                                      UWORD32 Parameter);


/* 
 * Description:
 * This should be PRIVATE, but is publically exported so that the 
 * dispatch.s assembler code can see it (prevents compiler warning).
 */
extern INT_sIntState INT_sState; 

#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif	/* __cplusplus */

#endif // INT_H
