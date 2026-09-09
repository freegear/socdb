        ;// ---------------------------------------------------------------------
        ;//
        ;// Copyright: 
        ;// ----------------------------------------------------------------
        ;// This confidential and proprietary software may be used only as
        ;// authorised by a licensing agreement from ARM Limited
        ;//   (C) COPYRIGHT 2000,2001,2002 ARM Limited
        ;//       ALL RIGHTS RESERVED
        ;// The entire notice above must be reproduced on all authorised
        ;// copies and copies may only be made to the extent permitted
        ;// by a licensing agreement from ARM Limited.
        ;// ----------------------------------------------------------------
        ;// File:     vectors.s,v
        ;// Revision: 1.11
        ;// ----------------------------------------------------------------
        ;// 
        ;//  ----------------------------------------
        ;//  Version and Release Control Information:
        ;// 
        ;//  File Name              : vectors.s.rca
        ;//  File Revision          : 1.10
        ;// 
        ;//  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
        ;//  ----------------------------------------
        ;//
        ;// This file provides the default exception vectors. These call
        ;// the vector handlers which are elsewhere. Either a boot routine needs
        ;// to copy these vectors to address 0, or this area needs to be
        ;// linked to be loaded at address 0.
        ;//
        ;// ---------------------------------------------------------------------

        ; /* Include the macros to allow common headers */
 	    INCLUDE ../apcommon/asmacros.h
 	
        ; /* Include the peripheral versions - for the interrupt controller type. */
	    INCLUDE	../apos/apintcfg.h

        ;// Export the start and end (inclusive) addresses for this
        ;// block of code - this is so the code can be manually copied 
        ;// by the user down over the vectors at start up, if it hasn't
        ;// been linked to be there already
        EXPORT  VECTOR_StartAddress
        EXPORT  VECTOR_EndAddress

        ;// Import the functions to be called for each of the 
        ;// exceptions. 
        ;// Some are commented out, with dummy values.
        
        IMPORT  apBOOT_BootCode
       ;// IMPORT  apVECTOR_UndefinedHandler
       ;// IMPORT  apSWI_Handler
       ;// IMPORT  apVECTOR_PrefetchAbortHandler
       ;// IMPORT  apVECTOR_DataAbortHandler
       ;// IMPORT  apVECTOR_ReservedHandler
;// apBOOT_BootCode                EQU 0
apVECTOR_UndefinedHandler      EQU 0
apSWI_Handler                  EQU 0
apVECTOR_PrefetchAbortHandler  EQU 0
apVECTOR_DataAbortHandler      EQU 0
apVECTOR_ReservedHandler       EQU 0


        ;// Addresses of the soft vectors, these are exported in case
        ;// the vector addresses need to be updated on the fly.
        EXPORT  VECTOR_Reset
        EXPORT  VECTOR_Undef
        EXPORT  VECTOR_SWI
        EXPORT  VECTOR_PAbort
        EXPORT  VECTOR_DAbort
        EXPORT  VECTOR_Unused
        EXPORT  VECTOR_IRQ
        EXPORT  VECTOR_FIQ

        ;// Default ARM hardware exception vectors
        AREA    |VECTOR|, CODE, READONLY

        CODE32
        
;//We use 'KEEP' rather than 'ENTRY' to keep SDT compatibility
;//        ENTRY
        KEEP    VECTOR_StartAddress

        ;//
        ;// After initialisation the following vectors *MUST* start at
        ;// 0x00000000 (an ARM processor requirement).
        ;//
        ;// The following vectors load the address of the relevent
        ;// exception handler from an address table.  This makes it
        ;// possible for these handlers to be anywhere in the address space.
        ;//
        ;// To bootstrap the ARM, some form of ROM is present at
        ;// 0x00000000 during reset.  Often the startup code performs
        ;// some target specific magic to remap RAM to address
        ;// zero. The ROM based Read/Write data and BSS must then be
        ;// copied to the relevant RAM address during the Angel ROM
        ;// initialisation.
        ;//

VECTOR_StartAddress              ;// Start of ARM processor vectors
        LDR     pc,VECTOR_Reset  ;// 00 - Reset
        LDR     pc,VECTOR_Undef  ;// 04 - Undefined instructions
        LDR     pc,VECTOR_SWI    ;// 08 - SWI instructions
        LDR     pc,VECTOR_PAbort ;// 0C - Instruction fetch aborts
        LDR     pc,VECTOR_DAbort ;// 10 - Data access aborts
        LDR     pc,VECTOR_Unused ;// 14 - Reserved (was address exception)
        
        ;//The standard configuration calls a dispatcher for FIQ or IRQ
        IF (apOS_CONFIG_VIC_AT_0xFFFFF000 = 0)
            LDR     pc,VECTOR_IRQ    ;// 18 - IRQ interrupts
            LDR     pc,VECTOR_FIQ    ;// 1C - FIQ interrupts
        ;//With a vectored interrupt controller at 0xFFFFF000, we can jump directly
        ;//to the vectored address
        ELSE
            LDR     pc,[pc, # - 0xFF0]    ;// 18 - IRQ interrupts
            LDR     pc,[pc, # - 0xFF4]   ;// 1C - FIQ interrupts
        ENDIF
        
        ;//
        ;// NOTE: In a normal optimised ARM system the FIQ vector would
        ;// not contain a branch to handler code, but would have an
        ;// allocation immediately following address 0x1C, with the FIQ
        ;// code being placed directly after the vector table. This
        ;// avoids the pipe-line breaks associated with indirecting to a
        ;// handler routine.

        ;// However this is designed to be a simple system so we
        ;// treat FIQ like all the other vectors, and this allows the
        ;// actual handler addresses to be stored immediately after the
        ;// ARM vectors. If optimal FIQ entry is required, then space
        ;// could be allocated at this point to hold the direct FIQ
        ;// code. The __SoftVectors table would then simply appear
        ;// higher in the RAM allocation.
        ;//
        ;// Reset - an error unless ROM always at zero.
        
VECTOR_Reset  DCD     apBOOT_BootCode               ;// 00 - Reset
VECTOR_Undef  DCD     apVECTOR_UndefinedHandler     ;// 04 - undef
VECTOR_SWI    DCD     apSWI_Handler                 ;// 08 - software interrupt
VECTOR_PAbort DCD     apVECTOR_PrefetchAbortHandler ;// 0C - prefectch abort
VECTOR_DAbort DCD     apVECTOR_DataAbortHandler     ;// 10 - data abort
VECTOR_Unused DCD     apVECTOR_ReservedHandler      ;// 14 - reserved

        ;// The primary VIC or INT is configured to use the IRQ vector
        IF (apINT_VERSION = apVERSION_VECTORED):LOR:(apINT_VERSION = apVERSION_VECTORED_PL192):LOR:(apINT_VERSION = apVERSION_VIC_PL192_ON_LM)
        IMPORT  apVIC_IRQDispatcher
VECTOR_IRQ    DCD     apVIC_IRQDispatcher           ;// 18 - IRQ
        ELSE
        IMPORT  apINT_IRQDispatcher
VECTOR_IRQ    DCD     apINT_IRQDispatcher           ;// 18 - IRQ
        ENDIF
        
        ;// If we use the VIC and INT together on Integrator, the VIC uses the FIQ vector
        ;// otherwise the INT or VIC have an FIQ dispatcher
        IF (apINT_VERSION = apVERSION_VIC_ON_LM) 
        IMPORT  apVIC_IRQDispatcher
VECTOR_FIQ    DCD     apVIC_IRQDispatcher           ;// 1C - FIQ
        ELSE
            IF (apINT_VERSION = apVERSION_VECTORED):LOR:(apINT_VERSION = apVERSION_VIC_ON_LM_FIQ):LOR:(apINT_VERSION = apVERSION_VECTORED_PL192):LOR:(apINT_VERSION = apVERSION_VIC_PL192_ON_LM)
        IMPORT  apVIC_FIQDispatcher
VECTOR_FIQ    DCD     apVIC_FIQDispatcher           ;// 1C - FIQ
            ELSE
        IMPORT  apINT_FIQDispatcher
VECTOR_FIQ    DCD     apINT_FIQDispatcher           ;// 1C - FIQ
            ENDIF
        ENDIF
VECTOR_EndAddress

        END
