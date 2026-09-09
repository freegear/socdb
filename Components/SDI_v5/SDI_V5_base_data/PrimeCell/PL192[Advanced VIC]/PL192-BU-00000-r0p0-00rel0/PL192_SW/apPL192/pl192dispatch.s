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
; * File:     pl192dispatch.s,v
; * Revision: 1.5
; * ----------------------------------------------------------------
; * 
; *  ----------------------------------------
; *  Version and Release Control Information:
; * 
; *  File Name              : pl192dispatch.s.rca
; *  File Revision          : 1.3
; * 
; *  Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
; *  ----------------------------------------
; *
; * Vectored Interrupt Dispatching routines - prioritised, and table driven.
; */

; /* Include the macros to allow common headers */

    INCLUDE ../apcommon/asmacros.h

; /* Include the peripheral versions - for the defines that controls
;  * which options (re-entrant, pre/post dispatch handler support,
;  * single FIQ support) the VIC should be built to support.
;  */

    INCLUDE ../apos/apintcfg.h

;/* Vectored Interrupt Controller PL192 registers definitions */

FiqStatus   EQU 0x04

;/* Following should be defined as 1 to get dispatcher to detect and
; * prevent the called interrupt handlers from causing the interrupt
; * table to be re-generated - which they mustn't do.
; */

# define VIC_DEBUG_ENABLED 0

        ;// Constants used in the code
CPSRModeMask EQU 0x1F                       ;// Mask for CPSR bits relating to mode
CPSRModeSYS  EQU 0x1F                       ;// CPSR bits for SYS mode
CPSRModeSVC  EQU 0x13                       ;// CPSR bits for SVC mode
CPSRBitIRQ   EQU 0x80                       ;// CPSR bit  for IRQ disable
CPSRBitFIQ   EQU 0x40                       ;// CPSR bit  for FIQ disable


;/*
; * The FIQ dispatcher - should be directly called by the ARM FIQ vectors.
; */

        ;// If we use the VIC and INT together on Integrator, the VIC uses the FIQ vector
        ;// otherwise the INT or VIC have an FIQ dispatcher
        IF ( apINT_VERSION <> apVERSION_VIC_ON_LM ) 

        EXPORT  apVIC_FIQDispatcher

        ENDIF

;/*
; * Function that can be called by 'C' code to simulate an FIQ
; * interrupt. They take no parameters, so the FIQ status registers
; * of the VIC(s) should already have been set appropriately. Hence these
; * functions are only intended to be used with a test harness that is 
; * simulating a VIC, or to chain a VIC off another interrupt controller
; * that is not a VIC.
; */

        ;// If we use the VIC and INT together on Integrator, the VIC uses the FIQ vector
        ;// otherwise the INT or VIC have an FIQ dispatcher
        IF ( apINT_VERSION <> apVERSION_VIC_ON_LM ) 

    EXPORT  apVIC_CallFIQDispatcher

        ENDIF
        
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


;/*--CODE----------------------------------------------------*/

    AREA |IRQCODE|, CODE, READONLY

    CODE32
    ALIGN

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

   
;/* ---------------------------------------------------------*/

;// Address of the IRQ service count, used to keep track of how
;// many interrupts we are currently servicing (re-entrantly)
;// and also used to ensure the interrupt handlers called by
;// the dispatcher don't do anything that will cause the 
;// interrupt tables to be re-generated whilst an interrupt is
;// being serviced.

    IF ( VIC_DEBUG_ENABLED = 1 )

VIC_IRQServiceCountPtr  DCD VIC_sState

    ENDIF   ;// ( VIC_DEBUG_ENABLED = 1 )
    
;/* ---------------------------------------------------------*/

;// Address of the FIQ service flag, used to indicate that an
;// FIQ is currently being serviced. Used to ensure the interrupt
;// handlers called by the FIQ dispatcher don't do anything that
;// will cause the interrupt tables to be re-generated whilst
;// an FIQ is being serviced.

    IF ( apINT_VERSION <> apVERSION_VIC_ON_LM ) 

        IF ( VIC_DEBUG_ENABLED = 1 )

VIC_FIQServiceCountPtr  DCD VIC_sState + 4

        ENDIF   ;// ( VIC_DEBUG_ENABLED = 1 )
        
 
;/*----------------------------------------------------------*/
;/* Functions that can be called from 'C' to call the
; * FIQ dispatcher - really intended just for test purposes
; * but can also be used to chain a VIC off another interrupt
; * controller that is not a VIC.
; *
; * NOTE:   This functions do not change processor mode. Therefore
; *         the re-entrant mechanism in the IRQ dispatcher code will
; *         only work correctly if these functions are called when in
; *         supervisor mode.
; *
; * NOTE:   The FIQ function below saves regs r8-r14 as the FIQ dispatcher
; *         does not (since it does not need to when executed in FIQ mode).
; *
; * NOTE:   These two functions take special care to ensure that the CPSR
; *         and SPSR are preserved, such that when the FIQ dispatcher
; *         code returns, neither the CPSR or SPSR are changed. This means
; *         that the processor must be in IRQ, FIQ or SVC mode when
; *         these functions are called.
; */

VIC_SimulateFIQReturn

    LDMFD   SP!, {r14}              ;// Reload saved SPSR
    MSR     SPSR_cxsf, r14          ;// Stick it back in SPSR
    LDMFD   SP!, {r8-r12, PC}       ;// restore the other regs & return to caller

apVIC_CallFIQDispatcher

    STMFD   SP!, {r8-r12, LR}       ;// Store the return address and the
                                    ;// other regs that the FIQ dispatcher
                                    ;// doesn't preserve & r0 which we're
                                    ;// about to use
    
    MRS     r14, SPSR               ;// Get a copy of SPSR
    STMFD   SP!, {r14}              ;// Stack it for now
    MRS     r14, CPSR               ;// Get a copy of the CPSR
    MSR     SPSR_cxsf, r14          ;// Stick it in SPSR so that when the dispatcher
                                    ;// returns, it stays in the current mode
    
    ADR     LR, VIC_SimulateFIQReturn + 4   ;// Set up LR to return here

;// Fall through to the dispatcher

;/*----------------------------------------------------------*/

;// FIQ Dispatcher

apVIC_FIQDispatcher

    STMFD   SP!, {r0-r2, LR}        ;// Store all used user registers. 
                                    ;// Called interrupt handlers are reSPonsible
                                    ;// for saving r3-r7 if they use them.

    IF ( VIC_DEBUG_ENABLED = 1 )

        ;// Inc count of num FIQs being serviced
    
        LDR     r1, VIC_FIQServiceCountPtr
        LDR     r0, [r1]
        ADD     r0, r0, #1
        STR     r0, [r1]

    ENDIF   ;// ( VIC_DEBUG_ENABLED = 1 )


    ;//RE-ENTRANT HANDLER CODE

    ;//Adds 15(ARM7TDMI), 14(ARM7EJ) or 13(ARM9TDMI) cycles with 1 stack access.
    ;//Adds 6 * 4 * 32 = 768 bytes in total.
    ;
    ;//If the handler is re-entrant, we need to do the following to save state
    ;//+ Stack the SPSR for the IRQ on the IRQ stack.
    ;//  These will be lost if a new interrupt occurs
    ;//+ Switch to a new mode (we use SYS mode here)
    ;//+ Stack the original IRQ CPSR (including mode) and LR for SYS on the SYS stack
    ;//+ Enable IRQ interrupts.

    IF ( apOS_CONFIG_INT_REENTRANT = 1 )

        ;// In FIQ mode

        MRS     r0, SPSR                ;// Get a copy of the SPSR
        MRS     r1, CPSR                ;// Get a copy of the CPSR

        ;// Go into our chosen non-FIQ mode (currently SYS), and save any
        ;// state that we  haven't already saved.
        ;// FIQs and IRQs are left disabled, otherwise we will re-enter
        ;// the same interrupt handler, as this interrupt is not cleared
        ;// yet and interrupt priority hardware cannot be updated
        ;// by reading VICADDRESS register as it is done for IRQs.
            
        ORR     r2, r1, #CPSRModeSYS    ;// Set mode bits to SYS
        MSR     CPSR_c, r2              ;// Write to CPSR - switching to SYS

        ;// In SYS mode

        STMFD   SP!, {r0, r1, r8-r12, LR}   ;// Save the FIQ SPSR, CPSR, r8-r12 & SYS LR

    ENDIF   ;// ( apOS_CONFIG_INT_REENTRANT = 1 )


    LDR     r8, VIC_PrimaryStatePtr     ;// Put addr of primary VIC state struct
                                        ;// in r8 - interrupt handlers must not corrupt it.
    

    IF ( apOS_CONFIG_VIC_SINGLE_FIQ = 1 )

    ;/* This block of code should be used if the 'fast' single FIQ source
    ; * feature is to be used - however this will slow down FIQ handling
    ; * if there is more than one FIQ int source, when *FIQOnlyEntry will
    ; * be set to NULL
    ; */

        LDR     r0, [r8, #-12]          ;// Get *FIQOnlyEntry
        CMP     r0, #0                  ;// If it isn't zero then ....

        ;// Read the Int Handler params from the int src struct and
        ;// call the Int Handler

        ;// Inc r0 and then get the source ID, parameter & ISR pointer
        ;// Note - use 'Inc Before' to pre inc r0 to skip the base addr field

        LDMNEIB r0, {r0, r1, r2}
        ADRNE   LR, VIC_FIQComplete     ;// If not then set return address
        MOVNE   PC, r2                  ;// And call it

    ENDIF   ;// ( apOS_CONFIG_VIC_SINGLE_FIQ = 1 )


    ;// The FIQ Loop - the return point for the FIQ interrupt handlers.
    ;// Before calling the interrupt handler, the link register is set to
    ;// point back here.
    ;//
    ;// At this point we always expect the registers to be as follows:
    ;//
    ;// r3: as before the interrupt
    ;// r4: as before the interrupt
    ;// r5: as before the interrupt
    ;// r6: as before the interrupt
    ;// r7: as before the interrupt
    ;// r8: Address of primary VIC Ctrl Struct

VIC_FIQLoop

    MOV     r0, r8                      ;// Copy primary VIC state addr to r0

VIC_FIQReadCtrlStruct

    LDMIA   r0!, {r1, r9}               ;// Load:
                                        ;// r1  = VIC base address
                                        ;// r9  = Next VIC Ptr

    ;// See if there are pending non-vectored FIQs

    LDR     r2, [r1, #FiqStatus ]       ;// Get current FIQ status

    ;// Test for the case when there are no more active interrupts.

    CMP     r2, #0
    BEQ     VIC_FIQNextVic

    ;// So we now know that there are FIQs pending, so we need to
    ;// establish which is the highest priority one. Read the following
    ;// fields from the CtrLR state struct:
    ;//
    ;// +0  : the 5 priority sorting masks (r1,r9,r10,r11,r12)
    ;// +20 : pointer to the interrupt source info table (r14)
    ;// +24 : indirection table (indexes into above table) (r0)

    LDMIA   r0!, {r1, r9, r10, r11, r12, r14}

    ;/* 
    ; * Now to get the position in the priority ordered table
    ; * of the highest priority active non-vectored FIQ
    ; * r0 currently points to the byte wide indirection table.
    ; * (Don't use r0 for accessing the state again as it's
    ; * being moved to an indeterminate position. So load anything
    ; * from the state structure before here). 
    ; */

    TST     r2, r1                      ;// Do we have one of the top 16 priority interrupts?
    ANDNE   r2, r2, r1
    ADDEQ   r0, r0, #16

    TST     r2, r9                      ;// Out of the 16 interrupts we selected, do we have
    ANDNE   r2, r2, r9                  ;// one in the top 8 ?
    ADDEQ   r0, r0, #8

    TST     r2, r10                     ;// Of the 8 interrupts left, do we have one in the
    ANDNE   r2, r2, r10                 ;// top 4 ?
    ADDEQ   r0, r0, #4

    TST     r2, r11                     ;// Of the 4 interrupts left, do we have one in the
    ANDNE   r2, r2, r11                 ;// top 2 ?
    ADDEQ   r0, r0, #2

    TST     r2, r12                     ;// Is it the most significant?
    ADDEQ   r0, r0, #1


    ;// Now convert this into a real interrupt table entry index
    
    LDRB    r0, [r0]                    ;// Do the indirection to get the real index.
    ADD     r2, r14, r0, LSL #4         ;// Now have address of table row in register


    ;// Read the Int Handler params from the int src struct and
    ;// call the Int Handler

    ;// Inc r2 and then get the source ID, parameter & ISR pointer
    ;// Note - use 'Inc Before' to pre inc r2 to skip the base addr field

    LDMIB   r2, {r0, r1, r2}


    ;// Set up the link register for the return and call the ISR function.
    ;// Latency to this point is about ?? cycles assuming single VIC,
    ;// ARM7TDMI, no cache misses, and perfect memory etc

    ADR     LR, VIC_FIQLoop             ;// Change to VIC_FIQComplete for single FIQ
    MOV     PC, r2


    ;/*----------------------------------------------------------*/


VIC_FIQNextVic

    MOVS    r0, r9                      ;// Copy next VIC Ctrl Stuct addr to r0
    BNE     VIC_FIQReadCtrlStruct       ;// Check it

    ;// r9 was zero - last VIC in the chain - so fall through and
    ;// return from the interrupt

    ;/*----------------------------------------------------------*/


    ;// Return as normal from an interrupt

VIC_FIQComplete

    IF ( VIC_DEBUG_ENABLED = 1 )

        ;// Dec count of num FIQs being serviced
    
        LDR     r1, VIC_FIQServiceCountPtr
        LDR     r0, [r1]
        SUB     r0, r0, #1
        STR     r0, [r1]

    ENDIF   ;// ( VIC_DEBUG_ENABLED = 1 )

        ;//RE-ENTRANT HANDLER CODE
        ;//Adds 12(ARM7TDMI), 11(ARM7EJ) or 10(ARM9TDMI) cycles with 1 stack access.
        ;//Adds 3 * 4 = 12 bytes in total.
        ;//If the handler is re-entrant, we need to do the following to restore state
        ;//+ Restore the original FIQ CPSR (including mode and interrupts) and LR for SYS from the SYS stack 
        ;//+ Restore the SPSR for the FIQ mode from the FIQ stack.

        IF ( apOS_CONFIG_INT_REENTRANT = 1 )

            ;// Return to FIQ mode so we can access its stack etc).  
            ;// Need first to restore the SYS LR and then return
            ;// to the mode we were in when the dispatcher was entered -
            ;// IRQ mode with interrupts disabled.          

            ;// In SYS mode

            LDMFD   SP!, {r0, r1, r8-r12, LR}   ;// Restore saved SPSR, CPSR, r8-r12 & SYS LR
            MSR     CPSR_c, r1                  ;// Write to CPSR - back to mode we were in
                                                ;// with interrupts disabled
            ;// In FIQ mode

            MSR     SPSR_cxsf, r0               ;// Write to SPSR 

        ENDIF   ;// ( apOS_CONFIG_INT_REENTRANT = 1 )

    ;// Return

    LDMFD   SP!, {r0-r2, LR}
    SUBS    PC, LR, #4


    ENDIF   ;// (apINT_VERSION <> apVERSION_VIC_ON_LM)

;/*----------------------------------------------------------*/

    END

