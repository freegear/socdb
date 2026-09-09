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
; * File:     tstpl192.s,v
; * Revision: 1.4
; * ----------------------------------------------------------------
; * 
; *  ----------------------------------------
; *  Version and Release Control Information:
; * 
; *  File Name              : tstpl192.s.rca
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

    IF ( ( apINT_VERSION:AND:apVERSION_VECTORED ) <> 0 )


;/* Following should be defined as 1 to get dispatcher to detect and
; * prevent the called interrupt handlers from causing the interrupt
; * table to be re-generated - which they mustn't do.
; */

; /* Constants used in the code */

CPSRModeMask EQU 0x1F       ;// Mask for CPSR bits relating to mode
CPSRModeSYS  EQU 0x1F       ;// CPSR bits for SYS mode
CPSRModeSVC  EQU 0x13       ;// CPSR bits for SVC mode
CPSRBitIRQ   EQU 0x80       ;// CPSR bit for IRQ disable
CPSRBitFIQ   EQU 0x40       ;// CPSR bit for FIQ disable

;/*
; * The dispatchers - should be directly called by the ARM IRQ & FIQ vectors.
; */

    IF ( apINT_VERSION <> apVERSION_VIC_ON_LM_FIQ )

    EXPORT  VIC_RawHandler_0
    EXPORT  VIC_RawHandler_1
    EXPORT  VIC_RawHandler_2
    EXPORT  VIC_RawHandler_3
    EXPORT  VIC_RawHandler_4
    EXPORT  VIC_RawHandler_5
    EXPORT  VIC_RawHandler_6
    EXPORT  VIC_RawHandler_7
    EXPORT  VIC_RawHandler_8
    EXPORT  VIC_RawHandler_9
    EXPORT  VIC_RawHandler_10
    EXPORT  VIC_RawHandler_11
    EXPORT  VIC_RawHandler_12
    EXPORT  VIC_RawHandler_13
    EXPORT  VIC_RawHandler_14
    EXPORT  VIC_RawHandler_15
    EXPORT  VIC_RawHandler_16
    EXPORT  VIC_RawHandler_17
    EXPORT  VIC_RawHandler_18
    EXPORT  VIC_RawHandler_19
    EXPORT  VIC_RawHandler_20
    EXPORT  VIC_RawHandler_21
    EXPORT  VIC_RawHandler_22
    EXPORT  VIC_RawHandler_23
    EXPORT  VIC_RawHandler_24
    EXPORT  VIC_RawHandler_25
    EXPORT  VIC_RawHandler_26
    EXPORT  VIC_RawHandler_27
    EXPORT  VIC_RawHandler_28
    EXPORT  VIC_RawHandler_29
    EXPORT  VIC_RawHandler_30
    EXPORT  VIC_RawHandler_31

    EXPORT  VIC_ChRawHandler_0
    EXPORT  VIC_ChRawHandler_1
    EXPORT  VIC_ChRawHandler_2
    EXPORT  VIC_ChRawHandler_3
    EXPORT  VIC_ChRawHandler_4
    EXPORT  VIC_ChRawHandler_5
    EXPORT  VIC_ChRawHandler_6
    EXPORT  VIC_ChRawHandler_7
    EXPORT  VIC_ChRawHandler_8
    EXPORT  VIC_ChRawHandler_9
    EXPORT  VIC_ChRawHandler_10
    EXPORT  VIC_ChRawHandler_11
    EXPORT  VIC_ChRawHandler_12
    EXPORT  VIC_ChRawHandler_13
    EXPORT  VIC_ChRawHandler_14
    EXPORT  VIC_ChRawHandler_15
    EXPORT  VIC_ChRawHandler_16
    EXPORT  VIC_ChRawHandler_17
    EXPORT  VIC_ChRawHandler_18
    EXPORT  VIC_ChRawHandler_19
    EXPORT  VIC_ChRawHandler_20
    EXPORT  VIC_ChRawHandler_21
    EXPORT  VIC_ChRawHandler_22
    EXPORT  VIC_ChRawHandler_23
    EXPORT  VIC_ChRawHandler_24
    EXPORT  VIC_ChRawHandler_25
    EXPORT  VIC_ChRawHandler_26
    EXPORT  VIC_ChRawHandler_27
    EXPORT  VIC_ChRawHandler_28
    EXPORT  VIC_ChRawHandler_29
    EXPORT  VIC_ChRawHandler_30
    EXPORT  VIC_ChRawHandler_31

    IMPORT  VIC_RawFunction
    IMPORT  VIC_ChRawFunction

    ENDIF   ;// ( apINT_VERSION <> apVERSION_VIC_ON_LM_FIQ )
    
;/*--CODE----------------------------------------------------*/

    AREA |IRQCODE|, CODE, READONLY

    CODE32
    ALIGN

    IF ( apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE = 1 )

;/* ------------------------------------------------------------*/
;/* The interrupt state structure. The format of the start of this
; * structure must be as follows for the dispatcher to work:

; *     +0  : IRQ service count
; *     +4  : FIQ sercice count
; *     +8  : Single FIQ Src Entry
; *     +12 : PreDispatch handler
; *     +16 : PostDispatch handler
; *     +20 : Interrupt controller base address
; *     +24 : Pointer to next VIC Controller state struct
; *     +28 : the 5 priority sorting masks
; *     +48 : pointer to the interrupt source info table
; *     +52 : indirection table (indexes into above table)
; */

    IMPORT  VIC_sState
   
;/* ---------------------------------------------------------*/

;// Address of the interrupt state stucture, the
;// first element of which is the state for the 
;// root/primary vectored interrupt controller, as follows:
;//
;// +0  : Interrupt controller base address
;// +4  : Pointer to next VIC Controller state struct
;// +8  : Which non-vectored interrupts are enabled
;// +12 : the 5 priority sorting masks
;// +32 : pointer to the interrupt source info table
;// +36 : indirection table (indexes into above table)


VIC_PrimaryStatePtr DCD VIC_sState + 20

    ENDIF   ;// ( apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE = 1 )
    
        MACRO
        VIC_RawHandler  $p1

        STMFD   SP!, {r0-r3, r12, LR}

        IF ( apOS_CONFIG_INT_REENTRANT = 1 )

            ;// In FIQ mode

            MRS     r0, SPSR                ;// Get a copy of the SPSR
            MRS     r1, CPSR                ;// Get a copy of the CPSR

            ;// Go into our chosen non-IRQ mode (currently SYS), and save any
            ;// state that we  haven't already saved. We must read the current
            ;// status as we don't know if FIQ is enabled or not...
            ;// This will re-enable the IRQ interrupt
    
            ORR     r2, r0, #CPSRModeSYS    ;// Set mode bits to SYS
            MSR     CPSR_c, r2              ;// Write to CPSR - enabling IRQs and switching to SYS
            
           ;// In SYS mode

            STMFD   SP!, {r0, r1, LR}       ;// Save the orig SPSR, CPSR & SYS LR

        ENDIF   ;// ( apOS_CONFIG_INT_REENTRANT = 1 )

        MOV     r0, #$p1
        BL      VIC_RawFunction

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
        LDR     r0, [r0, #-4]           ;// Back up to the PostHandler pointer
        CMP     r0, #0
        STRNE   r0, [SP, #-4]           ;// Put its addr on the stack above r12
        LDMNEDB SP, {r0, PC}            ;// restore r12 and set PC to PreHandler

        ;// Only gets here if the post-dispatcher handler ptr is NULL - 

    ENDIF   ;// ( apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE = 1 )              

        SUBS    PC, LR, #4        
        
        MEND            


        MACRO
        VIC_ChRawHandler  $p1

        STMFD   SP!, {r0-r3, r12, LR}

        IF ( apOS_CONFIG_INT_REENTRANT = 1 )

            ;// In FIQ mode

            MRS     r0, SPSR                ;// Get a copy of the SPSR
            MRS     r1, CPSR                ;// Get a copy of the CPSR

            ;// Go into our chosen non-IRQ mode (currently SYS), and save any
            ;// state that we  haven't already saved. We must read the current
            ;// status as we don't know if FIQ is enabled or not...
            ;// This will re-enable the IRQ interrupt
    
            ORR     r2, r0, #CPSRModeSYS    ;// Set mode bits to SYS
            MSR     CPSR_c, r2              ;// Write to CPSR - enabling IRQs and switching to SYS
            
           ;// In SYS mode

            STMFD   SP!, {r0, r1, LR}       ;// Save the orig SPSR, CPSR & SYS LR

        ENDIF   ;// ( apOS_CONFIG_INT_REENTRANT = 1 )

        MOV     r0, #$p1
        ORR     r0, r0, #0x100
        BL      VIC_ChRawFunction

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
        LDR     r0, =VIC_PrimaryStatePtr
        LDR     r0, [r0]
        LDR     r0, [r0, #-4]           ;// Back up to the PostHandler pointer
        CMP     r0, #0
        STRNE   r0, [SP, #-4]           ;// Put its addr on the stack above r12
        LDMNEDB SP, {r0, PC}            ;// restore r12 and set PC to PreHandler

        ;// Only gets here if the post-dispatcher handler ptr is NULL - 

    ENDIF   ;// ( apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE = 1 )              

        SUBS    PC, LR, #4        
        
        MEND            


    IF ( apINT_VERSION <> apVERSION_VIC_ON_LM_FIQ )

;// VIC #0

VIC_RawHandler_0
        VIC_RawHandler  0

VIC_RawHandler_1
        VIC_RawHandler  1

VIC_RawHandler_2
        VIC_RawHandler  2

VIC_RawHandler_3
        VIC_RawHandler  3

VIC_RawHandler_4
        VIC_RawHandler  4

VIC_RawHandler_5
        VIC_RawHandler  5

VIC_RawHandler_6
        VIC_RawHandler  6

VIC_RawHandler_7
        VIC_RawHandler  7

VIC_RawHandler_8
        VIC_RawHandler  8

VIC_RawHandler_9
        VIC_RawHandler  9

VIC_RawHandler_10
        VIC_RawHandler  10

VIC_RawHandler_11
        VIC_RawHandler  11

VIC_RawHandler_12
        VIC_RawHandler  12

VIC_RawHandler_13
        VIC_RawHandler  13

VIC_RawHandler_14
        VIC_RawHandler  14

VIC_RawHandler_15
        VIC_RawHandler  15

VIC_RawHandler_16
        VIC_RawHandler  16

VIC_RawHandler_17
        VIC_RawHandler  17

VIC_RawHandler_18
        VIC_RawHandler  18

VIC_RawHandler_19
        VIC_RawHandler  19

VIC_RawHandler_20
        VIC_RawHandler  20

VIC_RawHandler_21
        VIC_RawHandler  21

VIC_RawHandler_22
        VIC_RawHandler  22

VIC_RawHandler_23
        VIC_RawHandler  23

VIC_RawHandler_24
        VIC_RawHandler  24

VIC_RawHandler_25
        VIC_RawHandler  25

VIC_RawHandler_26
        VIC_RawHandler  26

VIC_RawHandler_27
        VIC_RawHandler  27

VIC_RawHandler_28
        VIC_RawHandler  28

VIC_RawHandler_29
        VIC_RawHandler  29

VIC_RawHandler_30
        VIC_RawHandler  30

VIC_RawHandler_31
        VIC_RawHandler  31

;// Daisy chained VIC #1

VIC_ChRawHandler_0
        VIC_ChRawHandler  0

VIC_ChRawHandler_1
        VIC_ChRawHandler  1

VIC_ChRawHandler_2
        VIC_ChRawHandler  2

VIC_ChRawHandler_3
        VIC_ChRawHandler  3

VIC_ChRawHandler_4
        VIC_ChRawHandler  4

VIC_ChRawHandler_5
        VIC_ChRawHandler  5

VIC_ChRawHandler_6
        VIC_ChRawHandler  6

VIC_ChRawHandler_7
        VIC_ChRawHandler  7

VIC_ChRawHandler_8
        VIC_ChRawHandler  8

VIC_ChRawHandler_9
        VIC_ChRawHandler  9

VIC_ChRawHandler_10
        VIC_ChRawHandler  10

VIC_ChRawHandler_11
        VIC_ChRawHandler  11

VIC_ChRawHandler_12
        VIC_ChRawHandler  12

VIC_ChRawHandler_13
        VIC_ChRawHandler  13

VIC_ChRawHandler_14
        VIC_ChRawHandler  14

VIC_ChRawHandler_15
        VIC_ChRawHandler  15

VIC_ChRawHandler_16
        VIC_ChRawHandler  16

VIC_ChRawHandler_17
        VIC_ChRawHandler  17

VIC_ChRawHandler_18
        VIC_ChRawHandler  18

VIC_ChRawHandler_19
        VIC_ChRawHandler  19

VIC_ChRawHandler_20
        VIC_ChRawHandler  20

VIC_ChRawHandler_21
        VIC_ChRawHandler  21

VIC_ChRawHandler_22
        VIC_ChRawHandler  22

VIC_ChRawHandler_23
        VIC_ChRawHandler  23

VIC_ChRawHandler_24
        VIC_ChRawHandler  24

VIC_ChRawHandler_25
        VIC_ChRawHandler  25

VIC_ChRawHandler_26
        VIC_ChRawHandler  26

VIC_ChRawHandler_27
        VIC_ChRawHandler  27

VIC_ChRawHandler_28
        VIC_ChRawHandler  28

VIC_ChRawHandler_29
        VIC_ChRawHandler  29

VIC_ChRawHandler_30
        VIC_ChRawHandler  30

VIC_ChRawHandler_31
        VIC_ChRawHandler  31


    ENDIF   ;// ( apINT_VERSION <> apVERSION_VIC_ON_LM_FIQ )
    
    ENDIF   ;// ( ( apINT_VERSION:AND:apVERSION_VECTORED ) <> 0 )

;/*----------------------------------------------------------*/
    
    END

