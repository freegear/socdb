;------------------------------------------------------------------------------
; This confidential and proprietary software may be used only as
; authorised by a licensing agreement from ARM Limited
;   (C) COPYRIGHT 2001 ARM Limited
;       ALL RIGHTS RESERVED
; The entire notice above must be reproduced on all authorised
; copies and copies may only be made to the extent permitted
; by a licensing agreement from ARM Limited.
;
;------------------------------------------------------------------------------
; Version and Release Control Information:
;
; File Name           :vectors.s,v
; File Revision       :1.10
;
; Release Information :ADK_REL1v1
;
;------------------------------------------------------------------------------
; Purpose             : Exception vector table
;
;                       This file is a port of the vector.s from the ADS 1.1 
;                       rom/ledflash example. It has been ported to match the 
;                       exception handlers of the EASY world supplied in ADK.
;
; Reference           : ARM Developer Suite   Version 1.1
;                       Developer Guide
;                       Chapter 6 Writing Code for ROM
;------------------------------------------------------------------------------


  AREA Vect, CODE, READONLY

  ENTRY


; The 'load program counter' form in used here instead of a simple branch, 
; to allow long branches (at the expense of increased interrupt latency).


  LDR     PC, reset_Addr          ; 0x00
  LDR     PC, undefined_Addr      ; 0x04
  LDR     PC, swi_Addr            ; 0x08
  LDR     PC, prefetchAbort_Addr  ; 0x0C
  LDR     PC, dataAbort_Addr      ; 0x10
  NOP                             ; 0x14 Reserved vector
  LDR     PC, irq_Addr            ; 0x18

; Note: For fastest handling of the FIQ interrupt, the start of the FIQ  
; handler (rather than this branch instruction) could could be placed in the 
; FIQ vector.
  LDR     PC, fiq_Addr            ; 0x1c
        
  IMPORT  default_reset_Handler
  IMPORT  default_undefined_Handler
  IMPORT  default_swi_Handler
  IMPORT  default_prefetchAbort_Handler
  IMPORT  default_dataAbort_Handler
  IMPORT  default_irq_Handler
  IMPORT  default_fiq_Handler

  EXPORT reset_Addr
  EXPORT undefined_Addr
  EXPORT swi_Addr
  EXPORT prefetchAbort_Addr
  EXPORT dataAbort_Addr
  EXPORT irq_Addr
  EXPORT fiq_Addr
     

reset_Addr          DCD     default_reset_Handler
undefined_Addr      DCD     default_undefined_Handler
swi_Addr            DCD     default_swi_Handler
prefetchAbort_Addr  DCD     default_prefetchAbort_Handler
dataAbort_Addr      DCD     default_dataAbort_Handler
irq_Addr            DCD     default_irq_Handler
fiq_Addr            DCD     default_fiq_Handler

        
 END

