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
; File Name           :mem_ctrl.s,v
; File Revision       :1.7
;
; Release Information :ADK_REL1v1
;
;-----------------------------------------------------------------------------
; Purpose             : Enable MMU or PU  
;                       
; Reference           : ARM ARM: "The System Control Coprocessor",
;                                "Memory Management Unit" and
;                                "Protection Unit" sections
;
;                       Technical Reference Manual for specific cores
;
; Note                : Any cache(s) are enabled from main() 
;
; Warning             : Ensure that FCLK has stabilized before switching to 
;                       Synchronous or Asynchronous core clocking modes.
;
;-----------------------------------------------------------------------------


; Definitions used with System Control Coprocessor ID register
 
ARM92X       EQU  0x9200
CORE_ID_MASK EQU  0xFF00

; Definitions used with System Control Coprocessor Control register

CTRL_CLKA  EQU  0xC0000000  ; Asynchronous clock select
CTRL_M     EQU  0x01        ; MMU/PU enable/disable

; Definitions used with System Control Coprocessor Domain Access Control
; register

DOM_CLIENT          EQU  0x01 
DOM_ALL_NO_ACCESS   EQU  0x00

; Definitions used with the System Control Coprocessor Protection Area 
; Control register

PAC_4KB    EQU  2_01011
PAC_8KB    EQU  2_01100
PAC_16KB   EQU  2_01101
PAC_32KB   EQU  2_01110
PAC_64KB   EQU  2_01111
PAC_128KB  EQU  2_10000
PAC_256KB  EQU  2_10001
PAC_512KB  EQU  2_10010
PAC_1MB    EQU  2_10011
PAC_2MB    EQU  2_10100
PAC_4MB    EQU  2_10101
PAC_8MB    EQU  2_10110
PAC_16MB   EQU  2_10111
PAC_32MB   EQU  2_11000
PAC_64MB   EQU  2_11001
PAC_128MB  EQU  2_11010
PAC_256MB  EQU  2_11011
PAC_512MB  EQU  2_11100
PAC_1GB    EQU  2_11101
PAC_2GB    EQU  2_11110
PAC_4GB    EQU  2_11111

PAC_E      EQU  1

; Definitions used with the System Control Coprocessor Cachability  
; Bits and Bufferability bits registers

CB_0  EQU  0x01
CB_1  EQU  0x02
CB_2  EQU  0x04
CB_3  EQU  0x08
CB_4  EQU  0x10
CB_5  EQU  0x20
CB_6  EQU  0x40
CB_7  EQU  0x80


; Definitions used with the System Control Coprocessor Access Permission  
; Bits register

AP_NO_ACC      EQU  0   
AP_SVC_RW      EQU  1
AP_NO_USR_W    EQU  2
AP_ALL_ACC     EQU  3


; Definitions to differentiate between Instruction and Data protection
; regions 

PR_DATA  EQU 0
PR_INSTR EQU 1

;-----------------------------------------------------------------------------
; Macro to enable the MMU
;-----------------------------------------------------------------------------

  MACRO
  EnableMMU
	
  IMPORT mmutable_level1        ; MMU Level 1 translation table

  LDR    r0, =mmutable_level1   ; Load TTB register with MMU table
  MCR    p15,0,r0,c2,c0,0

  MCR    p15,0,r0,c8,c7,0       ; Invalidate(flush) TLB(s) 

  MRC    p15,0,r0,c1,c0,0       ; Read Control Register  

  ORR    r0, r0, #CTRL_CLKA     ; Set clocking mode
  ORR    r0, r0, #CTRL_M        ; enable MMU

  MCR    p15,0,r0,c1,c0,0       ; Program Control register

  MEND

;-----------------------------------------------------------------------------
; Macro to setup the Domain Access control bits 
;
; $domains  - determines the domain access control
;
;-----------------------------------------------------------------------------

  MACRO
  SetDomainAccess $domains

  LDR    r0, = $domains         
  MCR    p15,0,r0,c3,c0,0
	
  MEND

;-----------------------------------------------------------------------------
; Macro to enable the PU
;-----------------------------------------------------------------------------

  MACRO
  EnablePU

  MRC    p15,0,R0,c1,c0,0       ; Read Control Register  

  ORR    R0, R0, #CTRL_CLKA     ; Set clocking mode
  ORR    R0, R0, #CTRL_M        ; enable PU

  MCR    p15,0,R0,c1,c0,0       ; Program Control register

	
  MEND

;-----------------------------------------------------------------------------
; Macro to setup the Bufferability bits of the protection regions
; defined by the PU.
;
; $regions  - determines which protection regions are bufferable
;
;-----------------------------------------------------------------------------

  MACRO
  SetPUbuffer $regions

  LDR    R0, =$regions                
  MCR    p15,0,R0,c3,c0,0       
	
  MEND

;-----------------------------------------------------------------------------
; Macro to setup the cachability bits of the protection regions
; defined by the PU.
;
; $regions  - determines which protection regions are cacheable
;
; $instr    - selects data or instruction protection regions
;
;-----------------------------------------------------------------------------

  MACRO
  SetPUcache $regions, $instr

  LDR    R0, =$regions                
  MCR    p15,0,R0,c2,c0,$instr       
	
  MEND

;-----------------------------------------------------------------------------
; Macro to setup the access permission bits of the protection regions
; defined by the PU.
;
; $access   - determines access to all data or instruction protection regions
;
; $instr    - selects data or instruction protection regions
;
;-----------------------------------------------------------------------------

  MACRO
  SetPUaccess $access, $instr

  LDR    r0, = $access                               
  MCR    p15,0,r0,c5,c0,$instr       
	
  MEND


;-----------------------------------------------------------------------------
; Macro to setup the data protection regions defined by the PU.
;
; $region  - protection region number
;
; $base    - base address for protection region
;
; $size    - protection region size
;
; $instr   - selects data or instruction protection region
;
; If the PU is programmed with overlapping regions, the attributes for 
; region 7 take highest priority and those for region 0 take lowest priotiy
;-----------------------------------------------------------------------------

  MACRO
  SetPUregion $region, $base, $size, $instr

  LDR    R0, = (($base) :OR: (($size) :SHL:1) :OR: PAC_E)

  IF $region = 0
    MCR    p15,0,R0,c6,c0,$instr     ; Program data region 0      
  ENDIF

  IF $region = 1
    MCR    p15,0,R0,c6,c1,$instr     ; Program data region 2      
  ENDIF

  IF $region = 2
    MCR    p15,0,R0,c6,c2,$instr     ; Program data region 3      
  ENDIF

  IF $region = 3
    MCR    p15,0,R0,c6,c3,$instr     ; Program data region 4      
  ENDIF

  IF $region = 4
    MCR    p15,0,R0,c6,c4,$instr     ; Program data region 5      
  ENDIF

  IF $region = 5
    MCR    p15,0,R0,c6,c5,$instr     ; Program data region 6      
  ENDIF

  IF $region = 6
    MCR    p15,0,R0,c6,c6,$instr     ; Program data region 7      
  ENDIF

  IF $region = 7
    MCR    p15,0,R0,c6,c7,$instr     ; Program data region 8      
  ENDIF

  MEND

;-----------------------------------------------------------------------------
; enableMemoryCtrl()
;
; The following code is selectively assembled, depending on the assembler 
; command line flag -cpu. The built-in variable {CPU} is determined by the
; -cpu command line option.
;
; {CPU} determines whether the MMU or PU or neither are enabled.
;
; In addtion the core part number is checked prior to enabling the MMU or PU
; to ensure that the MMU/PU is present
;-----------------------------------------------------------------------------


  AREA    MemCtrl, CODE, READONLY
    
  EXPORT  enableMemoryCtrl

enableMemoryCtrl


  IF {CPU} = "ARM922T"

    MRC    p15, 0, r0, c0, c0, 0    ; Get core part number
    AND    r0, r0, #CORE_ID_MASK    ; mask part number
    CMP    r0, #ARM92X          
    BNE    return

    SetDomainAccess (DOM_ALL_NO_ACCESS :OR: DOM_CLIENT)             
    EnableMMU 

  ENDIF

  IF {CPU} = "ARM920T"

    MRC    p15, 0, r0, c0, c0, 0    ; Get core part number
    AND    r0, r0, #CORE_ID_MASK    ; mask part number
    CMP    r0, #ARM92X          
    BNE    return 

    SetDomainAccess (DOM_ALL_NO_ACCESS :OR: DOM_CLIENT)             
    EnableMMU 

  ENDIF

return
  MOV    pc,   r14         ; return

  END