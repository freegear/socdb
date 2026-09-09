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
 * File:     pl192.h,v
 * Revision: 1.4
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : pl192.h.rca
 *  File Revision          : 1.4
 * 
 *  Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
 *  ----------------------------------------
 *
 * Private header for the Vectored Interrupt Controller Module device drivers,
 * this should not be included by any file outside the interrupt 
 * controller sources.
 */

#ifndef PL192_H
#define PL192_H

#ifdef __cplusplus
extern "C" { /* allow C++ to use these headers */
#endif /* __cplusplus */

/*
 * Description:
 * Defines the maximum number of vectored interrupt controllers allowed in
 * the system.
 *
 * Implementation:
 * Typically, most systems only have one interrupt controller. 
 * Some development systems, or complicated system on chip designs have 
 * more than one interrupt controller. Set this to the largest 
 * number you expect in your system.
 */
#define VIC_MAXIMUM_CONTROLLERS 5

/*
 * Description:
 * Defines the maximum number of interrupt sources to be used in the system.
 * This is the sum of the all the sources in all the vectored interrupt
 * controllers in the system.
 *
 * Implementation:
 * Due to the way the vectored interrupt controller has been implemented 
 * internally. this number must not exceed 256.
 * Although this number may be greater than 32, there cannot be more
 * than 32 interrupt sources per vectored interrupt controller.
 * Interrupt sources which are not used (even for setting or registering)
 * do not have to be counted.
 *
 */
#define VIC_MAXIMUM_SOURCES 64

/*
 * Description:
 * If the time between the core writing to the vectored interrupt controller 
 * registers, and the vectored interrupt controller acting on the write is 
 * significant then this must be set to 1. Else set to 0.
 *
 * Implementation:
 * This causes all critical writes to the vectored interrupt controller 
 * (enabling and disabling interrupts) to be followed by a read
 * from the same register. This ensures that the write is performed
 * (apart from rare systems where the read bypasses any write buffer).
 */
#define VIC_SLOW_CONTROLLER 0

/*
 * Description:
 * Used to mark cleared entries (in the source item) in the table of interrupt
 * sources.
 */
#define VIC_CLEARED_SOURCE 0xFF10

/*
 * Description:
 * Used to mark unused entries (in the source item) in the table of interrupt
 * sources.
 */
#define VIC_UNUSED_SOURCE 0xFF20

/*
 * Description:
 * Used to mark the first entry (in the source item) in the table of interrupt
 * sources. This entry is used as a default to which all non-registered 
 * interrupts are taken. Must be a non-valid source, and different to 
 * VIC_UNUSED_SOURCE and VIC_CLEARED_SOURCE.
 */
#define VIC_DEFAULT_SOURCE 0xFF40

/*
 * Description:
 * Number of interrupt sources on each vectored interrupt controller.
 * It should be possible to reduce this from 32, but increasing it above
 * 32 will not work, since the VIC registers and all data access can not be
 * more than 32 bits wide.
 */
#define VIC_NUM_INT_SOURCES 32

/*
 * Description:
 * Number of vector registers on each vectored interrupt controller.
 */
#define VIC_NUM_VECTOR_REGISTERS	32

/*
 * Description:
 * Number of bits to shift the ctrlr Id to get to the ctrlr field
 * in the apOS_INT_oInterruptSource.
 */
#define VIC_CTRLR_FIELD_SHIFT 8

/*
 * Description:
 * Mask of only the source bits in apOS_INT_oInterruptSource
 */
#define VIC_SOURCE_FIELD_MASK 0x1F

/*
 * Description:
 * Number of priority encoded masks in VIC_sControllerState.
 * This value is directly related to the number of interrupt sources, however
 * it should never be altered (even if there are less than 32 interrupt sources)
 */
#define NUM_PRIORITY_ENCODED_MASKS  5

/*
 * Description:
 * Reserved address space of the VIC controller (in 32 bit words)
 */
#define VIC_RESERVED_BEFORE_VECTOR_ADDRS    ((0x100 - 0x02C) >> 2)
#define VIC_RESERVED_BEFORE_VECTOR_PRIORITY ((0x200 - 0x180) >> 2)
#define	VIC_RESERVED_BEFORE_TEST_REG        ((0x300 - 0x280) >> 2)
#define VIC_RESERVED_BEFORE_ADDRESS         ((0xF00 - 0x31C) >> 2)
#define VIC_RESERVED_BEFORE_PERIPHID        ((0xFE0 - 0xF04) >> 2)

/*
 * Description:
 * Structure which maps onto the interrupt controller's hardware control
 * registers.
 * Note, all of these control registers are bit mapped, where each bit in the 
 * register represents a different interrupt source. Only change the bits you
 * need to (thus a read-modify-write is required in many cases).
 */
typedef volatile struct VIC_xRegisters
{
    UWORD32 IrqStatus;      	// IRQ Interrupt status (as seen by processor, after masking)
    UWORD32 FiqStatus;      	// FIQ Interrupt status (as seen by processor, after masking)
    UWORD32 RawIntr;           	// Raw IRQ interrupt status (before masking)
    UWORD32 IntSelect;        	// What type; IRQ or FIQ. ( 1 = FIQ, 0 = IRQ )
    UWORD32 IntEnable;         	// Interrupt enable, sets bits in enable mask (read to get mask)
    UWORD32 IntEnClear;   	    // Interrupt clear, write set bits to clear bits in mask
    UWORD32 SoftInt;         	// Writing to this generates a programmable interrupt 
    UWORD32 SoftIntClear;  		// Writing to this clears a programmable interrupt
    UWORD32 Protection;    		// Protection enable bit
    UWORD32 SWPriorityMask;		// Software priority mask
    UWORD32 VectPriorityDaisy;	// Vector priority for Daisy Chain

    UWORD32 Reserved[ VIC_RESERVED_BEFORE_VECTOR_ADDRS ];

    UWORD32 VectAddr[ VIC_NUM_VECTOR_REGISTERS ];       // Vector address registers

    UWORD32 Reserved1[ VIC_RESERVED_BEFORE_VECTOR_PRIORITY ];

    UWORD32 VectPriority[ VIC_NUM_VECTOR_REGISTERS ];	// Vector priority registers

    UWORD32 Reserved2[ VIC_RESERVED_BEFORE_TEST_REG ];

    UWORD32 TestCntrl;	      	// Test control reg
    UWORD32 TestInput1; 	    // Test input - read/set status of IRQ & FIQ daisy chain inputs
    UWORD32 Testinput2;     	// Test input - read/set the daisy chain VectAddr input
    UWORD32 TestOutput1;    	// Test output - read status of IRQ & FIQ lines going out of the VIC
    UWORD32 TestOutput2;    	// Test output - read status of daist chain VectAddr output of the VIC
    UWORD32 IntSStatus;  	  	// Sampled interrupt source status
    UWORD32 IntSStatusClear;  	// Sampled interrupt source status clear

    UWORD32 Reserved3[ VIC_RESERVED_BEFORE_ADDRESS ];

    UWORD32 Address;     	    // Current interrupt vector address

    UWORD32 Reserved4[ VIC_RESERVED_BEFORE_PERIPHID ];

    UWORD32 PeripheralId0;  	// 0xFE0
    UWORD32 PeripheralId1;
    UWORD32 PeripheralId2;
    UWORD32 PeripheralId3;
    UWORD32 CellId0;        	// 0xFF0
    UWORD32 CellId1;
    UWORD32 CellId2;
    UWORD32 CellId3;

 } VIC_sRegisters;
     

/*
 * Description:
 * Structure for each interrupt source.
 * The organisation of this must not be changed, as the interrupt dispatcher
 * relies on it. 
 */

typedef struct VIC_xSourceEntry
{
    apVIC_eInterruptType        InterruptType;  // Interrupt Type - Vectored, Non-vectored, FIQ
    UWORD32                     oSource;        // The users handle for this interrupt source
                                                // should be a apOS_INT_oInterruptSource, but the
                                                // compiler will optimise this to being a char,
                                                // causing the code to fail.
    UWORD32                     Parameter;      // The user's 32-bit parameter to pass back.
    apOS_INT_rServiceRoutine    rHandler;       // The ISR function to call if we match this ID

} VIC_sSourceEntry;

/* 
 * Description:
 * Extra source info that is not put in VIC_sSourceEntry as the dispatcher
 * does not need it, (the dispatcher uses all the info in VIC_sSourceEntry)
 */

typedef struct VIC_xSourceParameters
{
    UBYTE8      Priority;   // Interrupt priority (0 lowest, to VIC_NUM_INT_SOURCES-1)

} VIC_sSourceParameters;

/*
 * Description:
 * State structure required for each of the individual interrupt modules.
 * The first few entries (indicated) are used by the interrupt dispatcher
 * routines, do not modify the structure before these entries.
 */

typedef struct VIC_sControllerState 
{
    /* 
     * Base address of the VIC module, as supplied to the initialisation
     * function (used by the dispatcher function).
     */

    VIC_sRegisters *pBaseAddress;

    /*
     * Pointer to next VIC Controller State chained off this one.
     * Set to NULL if none.
     *
     * NOTE: Only used for FIQ chaining.
     * (used by the dispatcher function)
     */

    struct VIC_sControllerState *pNextController;

    /* 
     * Set of priority encoded masks used by the dispatcher to 
     * prioritize the incoming non-vectored IRQ & FIQ sources.
     * (used by the dispatcher function)
     */

    UWORD32 Masks[ NUM_PRIORITY_ENCODED_MASKS ];

    /*
     * Pointer to real interrupt source table (needed here for 
     * dispatching routine).
     */

    VIC_sSourceEntry *Table;

    /* 
     * Priority encoded index lookup table into the common interrupt
     * source table (which contains all the registered information for 
     * an interrupt source). This is used by the dispatcher.
     */

    UBYTE8 Indices[ VIC_NUM_INT_SOURCES ];
 
 
    /* The remaining fields are not used by the interrupt dispatcher */
 
 
    /* 
     * The software's idea of which interrupt sources are enabled at any one
     * time (non-vectored, vectored and FIQ). The user must not access the
     * hardware without going through the API or else this will become out of
     * sync. Each bit corresponds to an interrupt source. Set bits indicate
     * enabled sources.
     */

    UWORD32 IntEnabled;

    /* 
     * The software's idea of the interrupts which are routed to FIQ
     * (as opposed to IRQ). Each bit corresponds to an interrupt source.
     * A set bit indicates the source should be routed to FIQ.
     */

    UWORD32 IntRouting;

    /* 
     * Signals that only the software version of the enabled interrupts
     * should be modified. The hardware registers are left unchanged.
     */

    BOOL LeaveHardware;
   
} VIC_sControllerState;


/*
 * Description:
 * State structure for the state which is common to all VIC modules
 */

typedef struct VIC_xIntState
{
    /* Count of the number of IRQs & FIQs currently being serviced. Used to
     * prevent interrupt handlers from altering the interrupt table whilst
     * an IRQ or FIQ is being serviced
     */
    
    UWORD32 IRQServiceCount;
    UWORD32 FIQServiceCount;

    /* 
     * Pointer into main interrupt table for a source which is marked as
     * the only active registered interrupt source for FIQ. If this is
     * non-zero then this entry will always be loaded and its ISR called
     * whenever an FIQ exception occurs, whether or not the source is 
     * actually active or not (there is no source bit checking in the status
     * register if this is enabled).
     * If the table lookup is required (if there is more than one 
     * FIQ handler, or if interrupt source checking is required) then
     * set this to NULL.
     *
     * NOTE :   The dispatcher code uses apOS_CONFIG_VIC_SINGLE_FIQ in apintcfg.h,
     *          that allows to use this feature.
     */

    VIC_sSourceEntry *FIQOnlyEntry;

    /* 
     * The pre and post dispatch handler routine pointers.
     * These must be set up to point to valid dispatch
     * handlers (unless the dispatch.s routines are compiled
     * not to call these ever).
     * Note: These are not APCS compliant functions, they
     * do not return via the link register.
     */

     apVIC_rDispatchHandler *rIRQPreDispatchCode;
     apVIC_rDispatchHandler *rIRQPostDispatchCode;

    /*
     * The state required for each interrupt controller. The first
     * must be the primary VIC - the one that is first in the chain
     * (if there is a chain). Subsequent controllers can be in any 
     * order irrespective of where they occur in the chain.
     */

    VIC_sControllerState sControllers[ VIC_MAXIMUM_CONTROLLERS ];

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

    VIC_sSourceEntry sTable[ VIC_MAXIMUM_SOURCES + 1 ];

    /*
     * The interrupt source information left over from sTable (ie 
     * the info that isn't required by the dispatcher).
     */ 

    VIC_sSourceParameters sParameters[ VIC_MAXIMUM_SOURCES +1 ];

} VIC_sIntState;

#ifndef VIC_NO_PRIVATE_FUNCTION_PROTOTYPES


/* ---------------------------------------------------------------------*/
/*                      Private function prototypes                     */
 

/*
 * Description:
 * Extracts the controller number from an interrupt source enumeration.
 *
 * Inputs:
 *  oSource - The interrupt source
 */
INLINE PRIVATE UBYTE8 VIC_ControllerGet( CONST apOS_INT_oInterruptSource oSource );


/*
 * Description:
 * Creates a mask with the source bit set from an interrupt source enumeration.
 *
 * Inputs:
 *  oSource - The interrupt source
 */
INLINE PRIVATE UWORD32 VIC_MaskGet( CONST apOS_INT_oInterruptSource oSource );

/*
 * Description:
 * Default handler to be called if an interrupt goes off for an unregistered
 * interrupt.
 *
 * Since this handler is for unregistered interrupts, it totally ignores the
 * two params.
 *
 * Inputs:
 *  oSource     - The interrupt source
 *  Parameter   - The parameter
 */
PRIVATE void VIC_DefaultHandler( CONST apOS_INT_oInterruptSource oSource,
                                 UWORD32                         Parameter );

/*
 * Description:
 * Disables all IRQ and FIQ interrupts for his controller.
 *
 * This is the only function that directly writes to the VIC to
 * disable the interrupts.
 *
 * Inputs:
 *  pBase   - Ptr to base addr of the VIC to disable
 */
INLINE PRIVATE void VIC_DisableAll( VIC_sRegisters *pBase );


/*
 * Description:
 * ReEnables any interrupts which have been temporarily
 * disabled by writing to the hardware. All of the 
 * interrupts must have been disabled before this call,
 * otherwise an interrupt during a critical point can
 * break the system.
 *
 * This is the only function that directly writes to the VIC to
 * enable the interrupts.
 *
 * Inputs:
 *  pBase   - Ptr to base addr of the VIC to disable
 *  pState  - Ptr to the state struct for the specified VIC
 */
INLINE PRIVATE void VIC_ReEnable( VIC_sRegisters          *pBase,
                                  VIC_sControllerState    *pState );

/*
 * Description:
 * Finds the index of the table entry with this interrupt source,
 * returns 0 if the source was not found.
 *
 * Inputs:
 *  oSource     - The interrupt source
 *
 */
PRIVATE UWORD32 VIC_FindSource( CONST apOS_INT_oInterruptSource oSource );

/*
 * Description:
 * Finds the index of the table entry with this interrupt source,
 * returns 0 if a new entry cannot be found (table full).
 *
 * Inputs:
 *  oSource     - The interrupt source
 */
PRIVATE UWORD32 VIC_FindEntry( CONST apOS_INT_oInterruptSource oSource );

/*
 * Description:
 * Generates the new masks and indirection tables required by the dispatch
 * routine for the given interrupt controller.
 *
 * Inputs:
 *  Controller - the interrupt controller to update
 * 
 */
PRIVATE void VIC_GenerateTables( UWORD32 Controller );


#endif /* VIC_NO_PRIVATE_FUNCTION_PROTOTYPES */


/* ---------------------------------------------------------------------*/
/*                          Private Data prototypes                     */

/* 
 * Description:
 * This should be PRIVATE, but is publically exported so that the 
 * vicdispatch.s assembler code can see it (prevents compiler warning).
 */

extern VIC_sIntState VIC_sState; 


#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif /* __cplusplus */

#endif /* PL192_H */
