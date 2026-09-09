
;; Copyright (C) 1991-2000 Altera Corporation
;; Any megafunction design, and related net list (encrypted or decrypted),
;; support information, device programming or simulation file, and any other
;; associated documentation or information provided by Altera or a partner
;; under Altera's Megafunction Partnership Program may be used only to
;; program PLD devices (but not masked PLD devices) from Altera.  Any other
;; use of such megafunction design, net list, support information, device
;; programming or simulation file, or any other related documentation or
;; information is prohibited for any other purpose, including, but not
;; limited to modification, reverse engineering, de-compiling, or use with
;; any other silicon devices, unless such use is explicitly licensed under
;; a separate agreement with Altera or a megafunction partner.  Title to
;; the intellectual property, including patents, copyrights, trademarks,
;; trade secrets, or maskworks, embodied in any such megafunction design,
;; net list, support information, device programming or simulation file, or
;; any other related documentation or information provided by Altera or a
;; megafunction partner, remains with Altera, the megafunction partner, or
;; their respective licensors.  No other licenses, including any licenses
;; needed under any third party's intellectual property, are provided herein.



;;----------------------------------------------------------------------------------;;
;;              ARM Tutorial Assembly Code  - NO INITIALISATION               ;;
;;----------------------------------------------------------------------------------;;

;;----------------------------------------------------------------------------------;;
;; *** PLEASE NOTE ***
;;
;;  The Stripe MUST NOT have been initialised for this code to work:
;;  -this code assumes that the chip's memory map and other register settings
;;   are at their default value. 
;;  
;;----------------------------------------------------------------------------------;;




    EXPORT Entry

    AREA |Code|,CODE,READONLY



Entry
    b   Start
    b   Unexpected
    b   Unexpected
    b   Unexpected
    b   Unexpected
    b   Unexpected
    b   Unexpected

    ;; Unnexpected exception handler
Unexpected
    b   Unexpected

    ;; Start of main program
Start

   
    ;; Set up the memory map
    ;;  - we are starting from the chips default values as the chip has NOT been initialised


    ;; Setup Register Base	( base addr @ reset is 7FFFC000, ie size= 16K)
    ;;
    ldr r0, =0x7FFFC080       ; Address
    ldr r1, =0x80000001       ; Data
    str r1, [r0]


    ;; Setup PLD0 Decode
    ;;
    ldr r0, =0x800000D0       ; Address
    ldr r1, =0x10000C83       ; Data
    str r1, [r0]



    ;; Read the IDCode register at its new location into R0
    ldr r1, =0x80000008                 ; =IDCODE_ADDRESS_NEW
    ldr r0,[r1]


    ;; Load register map into internal registers
    ;; 
    ldr r1, =OPERAND1_REGISTER
    ldr r2, =OPERAND2_REGISTER
    ldr r3, =OPERATION_REGISTER
    ldr r4, =RESULT_LOW_REGISTER
    ldr r5, =RESULT_HIGH_REGISTER
    
    ;; Load data values into internal registers
    ldr r6, =OPERAND1
    ldr r7, =OPERAND2
    ldr r8, =OPERATION_SUB
    
    ;; Write Data to Slave registers
    str r6, [r1]  ;; Loads OPERAND1 into OPERAND1_REGISTER
    str r7, [r2]  ;; Loads OPERAND2 into OPERAND2_REGISTER
    str r8, [r3]  ;; Loads Operation into OPERATION_REGISTER

    ; Read the slave registers back
    ldr r9, [r4]
    ldr r10, [r5]

    ldr r8, =OPERATION_ADD
    str r8, [r3]  ;; Loads Operation into OPERATION_REGISTER
    
    ; Read the slave registers back
    ldr r9, [r4]
    ldr r10, [r5]
    
    ldr r8, =OPERATION_MUL
    str r8, [r3]  ;; Loads Operation into OPERATION_REGISTER
    
    ; Read the slave registers back
    ldr r9, [r4]
    ldr r10, [r5]
    
    
    

    nop ; The first few unused memory locations are padded to prevent unknown rom contents causing Xs in simulation waveform (not actually required)
    nop
    nop
    nop




;;
;; Simulation model is NOT initialised,
;;  the following are NOT the default values of these register
;;  but have to be explicitly set-up
;;
PLD0_BASE               EQU     0x10000000




;;
;; Memory map for user-defined (PLD) registers
;;
OPERAND1_REGISTER      EQU     PLD0_BASE + 0x04
OPERAND2_REGISTER      EQU     PLD0_BASE + 0x08
OPERATION_REGISTER     EQU     PLD0_BASE + 0x0C
RESULT_LOW_REGISTER    EQU     PLD0_BASE + 0x10
RESULT_HIGH_REGISTER   EQU     PLD0_BASE + 0x14

OPERAND1    EQU     0x0000000A
OPERAND2    EQU     0x00000003
OPERATION_ADD   EQU     0x00000005
OPERATION_SUB   EQU     0x00000006
OPERATION_MUL   EQU     0x00000007


    END

