;-----------------------------------------------------------------------------
; This confidential and proprietary software may be used only as
; authorised by a licensing agreement from ARM Limited
;   (C) COPYRIGHT 2001 ARM Limited
;       ALL RIGHTS RESERVED
; The entire notice above must be reproduced on all authorised
; copies and copies may only be made to the extent permitted
; by a licensing agreement from ARM Limited.
;
;-----------------------------------------------------------------------------
; Version and Release Control Information:
;
; File Name           :init.s,v
; File Revision       :1.15
;
; Release Information :ADK_REL1v1
;
;-----------------------------------------------------------------------------
; Purpose             : This module performs ROM/RAM remapping (if required), 
;                       initializes stack pointers and interrupts for each 
;                       mode, enables MMU/PU if available and finally branches
;                       to __main in the C library (which eventually calls 
;                       main()).
;                       On reset, the ARM core starts up in Supervisor (SVC) 
;                       mode, in ARM state, with IRQ and FIQ disabled.
;
;                       This file is a port of the init.s from the ADS 1.1 
;                       rom/ledflash example. It has been ported to match the 
;                       memory map of the EASY world supplied in ADK
;
;                       In this example, the stacks are set up by making use 
;                       of the scatterload description file.
;
;                       Initiates test for sucessful remap by writing to word
;                       location in internal memory before remap.
;
; Reference           : ARM Developer Suite   Version 1.1
;                       Developer Guide
;                       Section 6.3 Initializing the system
;
;-----------------------------------------------------------------------------

  INCLUDE rempause_h.s

  AREA    Init, CODE, READONLY

; --- Set up if ROM/RAM remapping if required
  GBLL ROM_RAM_REMAP
ROM_RAM_REMAP    SETL {TRUE}  

; --- Set up if ROM/RAM remapping test if required 
;;  GBLL TEST_REMAP     : defined on the assembler command line, if required
;;TEST_REMAP      SETL {TRUE}

; --- Ensure no functions that use semihosting SWIs 
;     are linked in from the C library
  IMPORT __use_no_semihosting_swi

; --- Select memory model with separate regions for stack and heap
  IMPORT __use_two_region_memory
  

; --- Standard definitions of mode bits and interrupt (I & F) flags in PSRs


Mode_USR        EQU     0x10
Mode_FIQ        EQU     0x11
Mode_IRQ        EQU     0x12
Mode_SVC        EQU     0x13
Mode_ABT        EQU     0x17
Mode_UND        EQU     0x1B
Mode_SYS        EQU     0x1F ; available on ARM Arch 4 and later

I_Bit           EQU     0x80 ; when I bit is set, IRQ is disabled
F_Bit           EQU     0x40 ; when F bit is set, FIQ is disabled


; --- Test word used to check sucessful remap 
; stored at top of internal memory (default size is 1kB)
PreRemapTestBase    EQU 0x70000000
PostRemapTestBase   EQU 0x00
RemapTestOffset     EQU 0xFC
RemapTestWord       EQU 0xA5C35A3C

;-----------------------------------------------------------------------------
; initBankedRegs
;
; Macro that initializes the banked registers,
; to supress warnings from the ARM DSM
;-----------------------------------------------------------------------------

  MACRO
  initBankedRegs
	

; banked registers
  MOV r8, #0
  MOV r9, #0
  MOV r10, #0
  MOV r12, #0
;;  MOV r13, #0 ; stack - don't initialize
 
  MOV r14, #0 ; LR

  MEND

;-----------------------------------------------------------------------------


  ENTRY

; -- Put the ARM core in a known state, to supress warnings from the ARM DSM

  SUBS r0, pc, pc   ; Initialize status register

  MOV r0, #0        ; Initialize registers
  MOV r1, #0
  MOV r2, #0
  MOV r3, #0
  MOV r4, #0
  MOV r5, #0
  MOV r6, #0
  MOV r7, #0

  initBankedRegs


; --- Perform ROM/RAM remapping, if required
  IF :DEF: ROM_RAM_REMAP

  ; On reset, an aliased copy of ROM is at 0x0.
  ; Continue execution from 'real' ROM rather than aliased copy
  LDR     pc, =Instruct_2

Instruct_2

; --- Perform remap test, if required
  IF :DEF: TEST_REMAP

  ; Initialize Remap Test by writing to internal RAM at pre-remap location
    
    LDR     r0, =RemapTestWord
    MOV     r1, #PreRemapTestBase
    STR     r0, [r1, #RemapTestOffset]

  ENDIF

 ; Remap by writing to Remap register in the Remap and Pause Controller
; Note: use Byte write when accessing the Remap and Pause Controller registers 
  MOV     r0, #0
  LDR     r1, =remPause
  STRB    r0, [r1, #RpcRemap]

; --- Perform remap test, if required
  IF :DEF: TEST_REMAP

  ; Test Sucessful Remap by checking test word in internal RAM 
  ; at remapped location
    MOV     r1, #PostRemapTestBase
    LDR     r0, [r1, #RemapTestOffset]
    LDR     r1, =RemapTestWord
    TEQ     r0, r1
                
    IMPORT  remapTestFlag

    ; Set Remap Test flag 1 == PASS, 0 == FAIL
    MOVEQ   r0, #1
    MOVNE   r0, #0
    LDR     r1, =remapTestFlag
    STR     r0, [r1]

  ENDIF

        

; RAM is now at 0x0.
; The exception vectors (in vectors.s) must be copied from ROM to the RAM
; The copying is done later by the C library code inside __main


  ENDIF

  EXPORT  reset_Handler
  
reset_Handler

; --- Initialise stack pointer registers

; Enter each mode in turn and set up the stack pointer

  IMPORT topOfFiqStack
  LDR    r0, =topOfFiqStack

  MSR    CPSR_c, #Mode_FIQ:OR:I_Bit:OR:F_Bit ; No interrupts
  MOV    sp, r0
  initBankedRegs

  IMPORT topOfIrqStack
  LDR    r0, =topOfIrqStack
  MSR    CPSR_c, #Mode_IRQ:OR:I_Bit:OR:F_Bit ; No interrupts
  MOV    sp, r0
  initBankedRegs

  IMPORT topOfSvcStack
  LDR    r0, =topOfSvcStack
  MSR    CPSR_c, #Mode_SVC:OR:I_Bit:OR:F_Bit ; No interrupts
  MOV    sp, r0
  initBankedRegs

  IMPORT topOfAbtStack
  LDR    r0, =topOfAbtStack
  MSR    CPSR_c, #Mode_ABT:OR:I_Bit:OR:F_Bit ; No interrupts
  MOV    sp, r0
  initBankedRegs

  IMPORT topOfUndStack
  LDR    r0, =topOfUndStack
  MSR    CPSR_c, #Mode_UND:OR:I_Bit:OR:F_Bit ; No interrupts
  MOV    sp, r0
  initBankedRegs


; --- Initialise memory system
  IMPORT  enableMemoryCtrl
  BL      enableMemoryCtrl    ; Enable MMU/PU 

; --- Initialise critical IO devices
        ; ...

; --- Initialise interrupt system variables here
        ; ...

; --- Now change to System Mode and set up User Mode stack.
;     Note System mode used rather than User Mode to allow access to
;     CP15 when setting up Caches from C code

  IMPORT topOfUsrStack
  LDR    r0, =topOfUsrStack
  MSR    CPSR_c, #Mode_SYS ; IRQ and FIQ enabled
  MOV    sp, r0
  initBankedRegs

; --- Now enter the C code
;     note use B not BL, because an application will never return this way

  IMPORT  __main
  B      __main
     
  END
