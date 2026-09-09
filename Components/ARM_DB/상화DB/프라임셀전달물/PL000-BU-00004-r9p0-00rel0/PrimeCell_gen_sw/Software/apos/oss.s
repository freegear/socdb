;/*
; * Copyright: 
; * ----------------------------------------------------------------
; * This confidential and proprietary software may be used only as
; * authorised by a licensing agreement from ARM Limited
; *   (C) COPYRIGHT 2000,2001 ARM Limited
; *       ALL RIGHTS RESERVED
; * The entire notice above must be reproduced on all authorised
; * copies and copies may only be made to the extent permitted
; * by a licensing agreement from ARM Limited.
; * ----------------------------------------------------------------
; * File:     oss.s,v
; * Revision: 1.20
; * ----------------------------------------------------------------
; * 
; *  ----------------------------------------
; *  Version and Release Control Information:
; * 
; *  File Name              : oss.s.rca
; *  File Revision          : 1.9
; * 
; *  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
; *  ----------------------------------------
; *
; * System specific assembler routines - including those
; * for accessing the processor mode register to enable or
; * disable IRQ or FIQ interrupts to the core.
; */

        EXPORT    apOS_CoreIRQEnable
        EXPORT    apOS_CoreIRQDisable
        EXPORT    apOS_CoreFIQEnable
        EXPORT    apOS_CoreFIQDisable
        EXPORT    apOS_CoreIRQGet

; /* Include the macros to allow ARM/Thumb interworking  */
 	INCLUDE ../apcommon/asmacros.h
    INCLUDE ../apos/apintcfg.h

;// Set up a macro for interworking returns if the processor supports THUMB
	MACRO
	RETMOV	$reg, $cc
	IF (apCONFIG_CORE_SUPPORTS = apCONFIG_ARM_AND_THUMB)
	  BX$cc $reg
	ELSE
	  MOV$cc pc, $reg
	ENDIF
	MEND

        AREA |OSCODE|, CODE, READONLY

        CODE32
        
;/*----------------------------------------------------------*/
apOS_CoreIRQGet 
        MRS      R0, CPSR        ;// Get the current status
        ANDS     R0, R0, #0x80   ;// Mask the IRQ bit 
        MOVEQ    R0, #1         ;// Return TRUE if clear
        MOVNE    R0, #0         ;// Return FALSE if set
        RETMOV   lr

;/*----------------------------------------------------------*/
apOS_CoreIRQEnable 
        MRS      R0, CPSR        ;// Get the current status
        BIC      R0, R0, #0x80   ;// Enable IRQs now in our CPSR copy
        MSR      CPSR_c, R0      ;// Write to CPSR - enabling IRQs
        RETMOV   lr

;/*----------------------------------------------------------*/
apOS_CoreIRQDisable 
        MRS      R0, CPSR        ;// Get the current status
        ORR      R0, R0, #0x80   ;// Disable IRQs now in our CPSR copy
        MSR      CPSR_c, R0      ;// Write to CPSR - enabling IRQs
        RETMOV   lr

;/*----------------------------------------------------------*/
apOS_CoreFIQEnable 
        MRS      R0, CPSR        ;// Get the current status
        BIC      R0, R0, #0x40   ;// Enable FIQs now in our CPSR copy
        MSR      CPSR_c, R0      ;// Write to CPSR - enabling FIQs
        RETMOV   lr

;/*----------------------------------------------------------*/
apOS_CoreFIQDisable 
        MRS      R0, CPSR        ;// Get the current status
        ORR      R0, R0, #0x40   ;// Disable FIQs now in our CPSR copy
        MSR      CPSR_c, R0      ;// Write to CPSR - enabling FIQs
        RETMOV   lr

;/*----------------------------------------------------------*/

    END

