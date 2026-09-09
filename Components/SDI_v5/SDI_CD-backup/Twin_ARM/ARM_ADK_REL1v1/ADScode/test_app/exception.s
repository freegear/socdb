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
; File Name           :exception.s,v
; File Revision       :1.10
;
; Release Information :ADK_REL1v1
;
;-----------------------------------------------------------------------------
; Purpose             : Exception generation and handling
;
; Reference           : ARM Developer Suite   Version 1.1
;                       Developer Guide
;                       Chapter 5 Handling Processor Exceptions
;
; Warning             : These exception handlers do not perform stack checking
;
;-----------------------------------------------------------------------------

  AREA Except, CODE, READONLY


  EXPORT undefined_Handler
  EXPORT swi_Handler
  EXPORT prefetchAbort_Handler
  EXPORT dataAbort_Handler

  EXPORT undefined
  EXPORT prefetchAbort


  IMPORT setUndefinedFlag
  IMPORT setSwiFlag
  IMPORT setPrefetchAbortFlag
  IMPORT setDataAbortFlag
    
; define Thumb bit in status register
T_bit EQU 0x20


;-----------------------------------------------------------------------------
; undefined_Handler ()
; This function handles Undefined Instruction exceptions.
;
; Ref: ARM ARM 2.6.2 Undefined Instruction exception
;

undefined_Handler

  STMFD     sp!,{r0-r3,lr}    ; r0 - r3 may be corrupted by subroutine call

  BL        setUndefinedFlag  ; call application exception handler

  LDMFD     sp!,{r0-r3,pc}^   ; ^ specifies CPSR is restored from SPSR

;-----------------------------------------------------------------------------
; swi_Handler ()
; This function handles Software Interrupt exceptions.
;
; This is a basic version that only reads the SWI number, no other parameters
;
; Ref: ARM ARM 2.6.3 Software Interrupt exception
;

swi_Handler

  STMFD     sp!,{r0-r3,lr}    ; r0 - r3 may be corrupted by subroutine call

  MRS     r0, spsr               ; Get spsr
  TST     r0, #T_bit             ; Occurred in Thumb state?
  LDRNEH  r0, [lr,#-2]           ; Yes: Load halfword and...
  BICNE   r0, r0, #0xFF00        ; ...extract comment field
  LDREQ   r0, [lr,#-4]           ; No: Load word and...
  BICEQ   r0, r0, #0xFF000000    ; ...extract comment field

  ; r0 now contains SWI number

  BL        setSwiFlag           ; call application exception handler

  LDMFD     sp!,{r0-r3,pc}^      ; ^ specifies CPSR is restored from SPSR


;-----------------------------------------------------------------------------
; prefetchAbort_Handler ()
; This function handles a Prefetch Abort exception.
;
; Ref: ARM ARM 2.6.4 Prefetch Abort
;
; Warning   : Returns to a specific location
;             (instead of using address saved in lr)

prefetchAbort_Handler

;; normal handler would return to aborted instruction
;;  SUB       lr,lr,#4         

; test handler: forces return to a specified location
  LDR       lr, =prefetchExit  

  STMFD     sp!,{r0-r3,lr}       ; r0 - r3 may be corrupted by subroutine call

  BL        setPrefetchAbortFlag ; call application exception handler

  LDMFD     sp!,{r0-r3,pc}^      ; ^ specifies CPSR is restored from SPSR


;-----------------------------------------------------------------------------
; dataAbort_Handler ()
; This function handles Data Abort exceptions.
;                     
; Ref: ARM ARM 2.6.5 Data Abort
;

dataAbort_Handler

;; alternative: calculate address to return to aborted instruction
;;  SUB       lr,lr,#8

; calculate return address if instruction is not to be re-executed
  SUB       lr,lr,#4

  STMFD     sp!,{r0-r3,lr}     ; r0 - r3 may be corrupted by subroutine call

  BL        setDataAbortFlag   ; call application exception handler

  LDMFD     sp!,{r0-r3,pc}^    ; ^ specifies CPSR is restored from SPSR


;-----------------------------------------------------------------------------
; undefined : Function containing an undefined instruction
;             Used to generate an Undefined Instruction exception
;
; Ref: ARM ARM 3.13.1 Undefined instruction space
; 

undefined

  NOP                   ; inserted to prevent linker warning

  ;DCD 0xE7FFFFFF        ; Undefined Inst
  DCD 0xEEEEEEEE        ; Undefined Inst

  MOV  pc, lr           ; Return


;-----------------------------------------------------------------------------
; prefetchAbort : Function used to generate a prefetch abort
; 

prefetchAbort

  IMPORT  defaultSlave

  LDR r0, =defaultSlave

  MOV pc, r0


; address for test code to return from exception
prefetchExit

  MOV  pc, lr          ; Return


  END

