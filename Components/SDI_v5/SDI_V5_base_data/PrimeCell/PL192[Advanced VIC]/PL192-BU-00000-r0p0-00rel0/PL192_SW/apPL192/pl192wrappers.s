;/*
; * Copyright: 
; * ----------------------------------------------------------------
; * This confidential and proprietary software may be used only as
; * authorised by a licensing agreement from ARM Limited
; *   (C) COPYRIGHT 2002 ARM Limited
; *       ALL RIGHTS RESERVED
; * The entire notice above must be reproduced on all authorised
; * copies and copies may only be made to the extent permitted
; * by a licensing agreement from ARM Limited.
; * ----------------------------------------------------------------
; * File:     pl192wrappers.s,v
; * Revision: 1.6
; * ----------------------------------------------------------------
; * 
; *  ----------------------------------------
; *  Version and Release Control Information:
; * 
; *  File Name              : pl192wrappers.s.rca
; *  File Revision          : 1.3
; * 
; *  Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
; *  ----------------------------------------
; *
; * Vectored Interrupt Wrappers
; * This module handles the wrappers to allow standard PrimeCell driver interrupt handlers
; * to be called by a vectored interrupt controller.  Interrupt handlers designed to be
; * called directly from the IRQ or FIQ vectors will not need these wrappers.
; */

        ; /* Include the macros to allow common headers */
        INCLUDE ../apcommon/asmacros.h

        ; /* Include the peripheral versions - for the interrupt controller type. */
        INCLUDE ../apos/apintcfg.h

        ;// Export the start and end (inclusive) addresses of the wrappers
        ;// This allows the VIC to identify these and index into the locations
        ;// to store the instance number and ISR address 

        EXPORT  apVIC_IRQDispatcher         ;// Address of the dispatcher called from IRQ vector
        EXPORT  apVIC_VectorRegister        ;// Stores the address of the VIC's vector register
        EXPORT  apVIC_WrapperStart          ;// Start of VIC wrapper block (16 code blocks)
        EXPORT  apVIC_WrapperEnd            ;// End   of VIC wrapper block (16 code blocks)
        
        ;// Constants used in the code
CPSRModeMask EQU 0x1F                       ;// Mask for CPSR bits relating to mode
CPSRModeSYS  EQU 0x1F                       ;// CPSR bits for SYS mode
CPSRModeSVC  EQU 0x13                       ;// CPSR bits for SVC mode
CPSRBitIRQ   EQU 0x80                       ;// CPSR bit  for IRQ disable
CPSRBitFIQ   EQU 0x40                       ;// CPSR bit  for FIQ disable
        

    IF :DEF:apOS_CONFIG_VIC_0_BLOCKING_MODE

;// apOS_CONFIG_VIC_0_BLOCKING_MODE is already defined

    ELSE

apOS_CONFIG_VIC_0_BLOCKING_MODE EQU 0

    ENDIF

        ;// This area contains the wrappers to allow PrimeCell driver interrupt handlers
        ;// to be called by a vectored interrupt controller.  It must be writeable.

        AREA    WRAPPERS, CODE, READWRITE

        CODE32
        
        KEEP apVIC_IRQDispatcher
        
;/*
; * If the interrupt pre-dispatch and post-dispatch handlers are used
; * then the pre-dispatch handler is responsible for saving all the
; * registers that the dispatcher will use (best if it saves all of them) and
; * the post-dispatcher is responsible for restoring them all. Hence
; * The pre & post dispatcher handlers must always be used as a pair.
; */

    IF ( apOS_CONFIG_VIC_USE_PREDISPATCH_CODE = 1 )

        EXPORT  apVIC_IRQPreDispatchReturn

    ENDIF   ;// ( apOS_CONFIG_VIC_USE_PREDISPATCH_CODE = 1 )

    IF ( apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE = 1 )

        EXPORT  apVIC_IRQPostDispatchReturn

    ENDIF   ;// ( apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE = 1 )


    IF ( apOS_CONFIG_VIC_USE_PREDISPATCH_CODE = 1 ):LOR:( apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE = 1 ) 

;/* ------------------------------------------------------------*/
;/* The interrupt state structure VIC_sIntState (pl192.h).
; * The format of the start of this structure
; * must be as follows for the dispatcher to work:

; *     +0  : IRQServiceCount, IRQ service count 
; *     +4  : FIQServiceCount, FIQ sercice count
; *     +8  : FIQOnlyEntry, single FIQ Src Entry
; *     +12 : rIRQPreDispatchCode, preDispatch handler
; *     +16 : rIRQPostDispatchCode, postDispatch handler
; * 
; * VIC_sControllerState sControllers[VIC_MAXIMUM_CONTROLLERS]:
; *
; *     +20 : pBaseAddress, interrupt controller base address
; *     +24 : pNextController, pointer to next VIC Controller state struct
; *     +28 : Masks[NUM_PRIORITY_ENCODED_MASKS], the 5 priority sorting masks
; *     +48 : Table, pointer to the interrupt source info table
; *     +52 : Indices[VIC_NUM_INT_SOURCES], indirection table (indexes into above table)
; */

    IMPORT  VIC_sState
   
;/* ---------------------------------------------------------*/

;// Address of the interrupt state stucture, the
;// first element of which is the state for the 
;// root/primary vectored interrupt controller, as follows:
;//
;// +0  : pBaseAddress, interrupt controller base address
;// +4  : pNextController, pointer to next VIC Controller state struct
;// +8  : Masks[NUM_PRIORITY_ENCODED_MASKS], the 5 priority sorting masks
;// +28 : Table, pointer to the interrupt source info table
;// +32 : Indices[VIC_NUM_INT_SOURCES], indirection table (indexes into above table)


VIC_PrimaryStatePtr DCD VIC_sState + 20
       
    ENDIF   ;// ( apOS_CONFIG_VIC_USE_PREDISPATCH_CODE = 1 ):LOR:( apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE = 1 )


;//-------------------------------------------------------------------------------
;//Dispatcher.  This is called directly from the IRQ or FIQ vectors and dispatches
;//to the Vectored address.  This is not required if the VIC is at the recommended
;//location 0xFFFFF000, in which case a single load at the IRQ vector will suffice
;//as below:
;//     LDR PC,0xFFFFF030
        
apVIC_IRQDispatcher

    IF ( apOS_CONFIG_VIC_USE_PREDISPATCH_CODE = 1 )

        STR     r0, [SP, #-8]           ;// Preserve r0 on stack
        LDR     r0, VIC_PrimaryStatePtr
        LDR     r0, [r0, #-8]           ;// Back up to the PreHandler pointer
        CMP     r0, #0                  ;// Is NULL ?
        STRNE   r0, [SP, #-4]           ;// Put its addr on the stack above r0
        LDMNEDB SP, {r0, PC}            ;// Restore r0 and set PC to PreHandler
    
apVIC_IRQPreDispatchReturn

    ;// The PreHandler must jump back to this point - 
    ;// but mustn't use normal link register return

        ;// No PreHandler.

    ENDIF   ;// ( apOS_CONFIG_VIC_USE_PREDISPATCH_CODE = 1 )

    STR     r0, [SP, #-8]               ;// Preserve r0 on stack
    LDR     r0, apVIC_VectorRegister
    LDR     r0, [r0]
    STR     r0, [SP, #-4]
    LDMDB   SP, {r0, PC}

apVIC_VectorRegister

        IF ( apOS_CONFIG_VIC_0_BLOCKING_MODE = 1 )

            DCD     0       ;// The vector register address is written into
                            ;// here on initialisation of the VIC #0

        ELSE
        
            GBLA    VIC_Cnt
            WHILE   VIC_Cnt < apOS_CONFIG_VIC_NUMBER

            DCD     0       ;// The vector register address is written into
                            ;// here on initialisation of each VIC
        
VIC_Cnt     SETA    VIC_Cnt + 1
            WEND

        ENDIF   ;// ( apOS_CONFIG_VIC_0_BLOCKING_MODE = 1 )

    ;//-------------------------------------------------------------------------------
    ;// This macro defines a single wrapper for an ISR.
    ;// The ISR prototype is the standard driver prototype as below
    ;// MOD_IntHandler(CONST apOS_INT_oInterruptSource oSource,UWORD32 oId);
    ;// This macro code is intended to be called from the IRQ vector and
    ;// to execute one such handler.
    MACRO
    ISRwrapper
        
        STMFD   SP!, {r0-r3, r12, LR}       ;// Any ISR requires the stacking of these registers
        
        ;//RE-ENTRANT HANDLER CODE

        ;//Adds 8(ARM7TDMI) or 7(ARM9TDMI) cycles with 1 stack access.
        ;//Adds 5 * 4 * 32 = 768 bytes in total.
        ;
        ;//If the handler is re-entrant, we need to do the following to save state
        ;//+ Stack the SPSR for the IRQ on the IRQ stack.
        ;//  These will be lost if a new interrupt occurs
        ;//+ Switch to a new mode (we use SYS mode here)
        ;//+ Stack the original IRQ CPSR (including mode) and LR for SYS on the SYS stack
        ;//+ Enable IRQ interrupts.

        IF ( apOS_CONFIG_INT_REENTRANT = 1 )

            ;// In IRQ mode

            MRS     r0, SPSR                ;// Get a copy of the SPSR
            MRS     r1, CPSR                ;// Get a copy of the CPSR

            ;// Go into our chosen non-IRQ mode (currently SYS), and save any
            ;// state that we  haven't already saved. We must read the saved
            ;// status as we don't know if FIQ is enabled or not...
            ;// This will re-enable the IRQ interrupt.
    
            ORR     r2, r0, #CPSRModeSYS    ;// Set mode bits to SYS
            MSR     CPSR_c, r2              ;// Write to CPSR - enabling IRQs and switching to SYS
            
           ;// In SYS mode

            STMFD   SP!, {r0, r1, LR}       ;// Save the orig SPSR, CPSR & SYS LR

        ENDIF   ;// ( apOS_CONFIG_INT_REENTRANT = 1 )

        ADR  r2, %FT0                       ;// Using local label 0, search forward within this macro       

        IF ( apOS_CONFIG_VIC_0_BLOCKING_MODE = 0 )
        
            IF ( apOS_CONFIG_VIC_NUMBER = 1 )

                ; // Need to calculate the return address to clear interrupt priority logic        

                ADRL    LR, RetAddr
            
            ELSE
                            
                ADRL    LR, RetAddr + 8 * ( apOS_CONFIG_VIC_NUMBER - 1 - (Count/32))

            ENDIF   ;// ( apOS_CONFIG_VIC_NUMBER = 1 )    
                

        ELSE
            
           ADRL    LR, RetAddr

        ENDIF   ; // ( apOS_CONFIG_VIC_0_BLOCKING_MODE = 0 )
                
        LDMIA r2, {r0, r1, PC}              
0                                           ;// Local label for data 
        DCD 0                               ;// Store the source, oSource     
        DCD 0                               ;// Store the instance number (oId), Parameter
        DCD 0                               ;// Store the ISR address, rHandler     
    MEND

apVIC_WrapperStart
        ;// This inserts 32 copies of the wrapper macro into the code.
        ;// Each one will be linked to a vector on the VIC.
        GBLA    Count
        WHILE   Count < 32 * apOS_CONFIG_VIC_NUMBER        
        ISRwrapper                          ;// Single ISR wrapper code
Count   SETA    Count + 1         
        WEND
apVIC_WrapperEnd
        
        ;// This is the common return address for all of the ISR wrappers
        ;// It clears the interrupt and returns from IRQ mode.
RetAddr 

        IF ( apOS_CONFIG_VIC_0_BLOCKING_MODE = 0 )

            GBLA    VIC_Cnt
            WHILE   VIC_Cnt < apOS_CONFIG_VIC_NUMBER - 1
            LDR     r0, apVIC_VectorRegister + 4 * ( apOS_CONFIG_VIC_NUMBER - 1 - VIC_Cnt )
            STR     r0, [r0]                        ;// Clear the daisy chained VIC interrupt
VIC_Cnt     SETA    VIC_Cnt + 1
            WEND

        ENDIF   ;// ( apOS_CONFIG_VIC_0_BLOCKING_MODE = 0 )

        LDR     r0, apVIC_VectorRegister
        STR     r0, [r0]                        ;// Clear the VIC interrupt

    ;//RE-ENTRANT HANDLER CODE
    ;//Adds 7(ARM7TDMI), 6(ARM7EJ) or 5(ARM9TDMI) cycles with 1 stack access.
    ;//Adds 3 * 4 = 12 bytes in total.
    ;//If the handler is re-entrant, we need to do the following to restore state
    ;//+ Restore the original IRQ CPSR (including mode and interrupts) and LR for SYS from the SYS stack 
    ;//+ Restore the SPSR for the IRQ mode from the IRQ stack.

    IF ( apOS_CONFIG_INT_REENTRANT = 1 )

        ;// Return to IRQ mode so we can access its stack etc).  
        ;// Need first to restore the SYS LR and then return
        ;// to the mode we were in when the dispatcher was entered -
        ;// IRQ mode with interrupts disabled.          

        ;// In SYS mode

        LDMFD   SP!, {r0, r1, LR}           ;// Restore saved SPSR, CPSR & SYS link register
        MSR     CPSR_c, r1                  ;// Write to CPSR - back to mode we were in
                                            ;// with interrupts disabled
        ;// In IRQ mode

        MSR     SPSR_cxsf, r0               ;// Write to SPSR 

    ENDIF   ;// ( apOS_CONFIG_INT_REENTRANT = 1 )

    LDMFD   SP!, {r0-r3, r12, LR}

    IF ( apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE = 1 )

        STR     r0, [SP, #-8]        
        LDR     r0, VIC_PrimaryStatePtr
        LDR     r0, [r0, #-4]               ;// Back up to the PostHandler pointer
        CMP     r0, #0
        STRNE   r0, [SP, #-4]               ;// Put its addr on the stack above r12
        LDMNEDB SP, {r0, PC}                ;// Restore r12 and set PC to PreHandler

        ;// Only gets here if the post-dispatcher handler ptr is NULL.

apVIC_IRQPostDispatchReturn

    ENDIF   ;// ( apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE = 1 )

    ;// Return as normal from an interrupt.

    SUBS    PC, LR, #4        

;/*----------------------------------------------------------*/
;/* Example of the simplest IRQ Pre-dispatcher handler - all the 
; * state must be stored safely somewhere by this function, here
; * it is pushed onto the IRQ stack.
; * Note: the dispatcher must have been compiled to use a
; * pre-dispatch handler or else this won't be called.
; */

    IF ( apOS_CONFIG_VIC_USE_PREDISPATCH_CODE = 1 )

        EXPORT  apVIC_IRQPreDispatchCode

apVIC_IRQPreDispatchCode

        STMFD   SP!, {r0-r12, LR}
        B       apVIC_IRQPreDispatchReturn

    ENDIF   ;// ( apOS_CONFIG_VIC_USE_PREDISPATCH_CODE = 1 )


;/*----------------------------------------------------------*/
;/* Example of the simplest IRQ Post-dispatcher handler. Here 
; * the state from before the interrupt is restored from the 
; * IRQ stack. In some systems you might want to restore the 
; * state from another process.
; * Note: the dispatcher must have been compiled to use a
; * post-dispatch handler or else this won't be called.
; */

    IF ( apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE = 1 )

        EXPORT  apVIC_IRQPostDispatchCode

apVIC_IRQPostDispatchCode

        LDMFD   SP!, {r0-r12, LR}
        B       apVIC_IRQPostDispatchReturn

    ENDIF   ;// ( apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE = 1 )

;/* ---------------------------------------------------------*/

        END
       