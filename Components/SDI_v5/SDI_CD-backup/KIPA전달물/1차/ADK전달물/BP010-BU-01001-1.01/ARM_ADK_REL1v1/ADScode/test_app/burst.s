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
; File Name           :burst.s,v
; File Revision       :1.4
;
; Release Information :ADK_REL1v1
;
;-----------------------------------------------------------------------------
; Purpose             : Provides ARM LDMIA and STMIA functions to C/C++
;-----------------------------------------------------------------------------

    AREA Burst, CODE, READONLY


    EXPORT BurstCopy8

;-----------------------------------------------------------------------------
; BurstCopy8 : Sequential read and write of length 8 words
;
; Inputs :       R0 holds source address of data
;                R1 holds destination address of data
; 
BurstCopy8
  STMFD   SP!, {R2-R9}  ; Push Registers 
                        ; (using pre-decrement top-down stack model)  
        
  LDMIA   R0!, {R2-R9}
  STMIA   R1!, {R2-R9}
  
  LDMFD   SP!, {R2-R9}  ; Pop Registers  
  MOV  PC, LR           ; Return

  
  END
