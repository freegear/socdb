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
; File Name           :mmutable.s,v
; File Revision       :1.7
;
; Release Information :ADK_REL1v1
;
;-----------------------------------------------------------------------------
; Purpose             : Generation of MMU Level 1 Translation Table in ROM 
;                       
; Reference           : ARM Application Note 53: Configuring ARM caches
;                       ARM ARM B3.3
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; Define the descriptors - see section B3.3.4 of the ARM ARM and refer to the 
; ARMxxx processor TRMs for IMPLEMENTATION DEFINED bits 
;-----------------------------------------------------------------------------


; Access Permissions (AP) - must be shifted to correct position 
NO_ACCESS  * 0 ; Depending on the 'R' and 'S' bits
SVC_R      * 0 ; represents one of these access
ALL_R      * 0 ; permissions 
SVC_RW     * 1
NO_USR_W   * 2
ALL_ACCESS * 3


; Entry type bits in correct positions 
FINE_PAGE   * 3
SECTION     * 2
COARSE_PAGE * 1
FAULT       * 0


; U, C and B bits in correct positions
U_BIT  * 16
C_BIT  * 8
B_BIT  * 4

;-----------------------------------------------------------------------------
; Macro to generate the entries in the level 1 translation table
;-----------------------------------------------------------------------------
  
	MACRO
	L1Entry $type, $addr, $acc, $dom, $ucb
	[ $type = SECTION
	  DCD ( (($addr) :AND: &FFF00000) :OR: \
		(($acc) :SHL: 10) :OR: \
		(($dom) :SHL: 5) :OR: $ucb :OR: $type )
	  MEXIT
	]
	[ $type = COARSE_PAGE
	  DCD ( $addr :OR: \
		(($dom) :SHL: 5) :OR: $ucb :OR: $type )
	  MEXIT
	]
	[ $type = FINE_PAGE
	  DCD ( (($addr) :AND: &FFFFF000) :OR: \
		(($dom) :SHL: 5) :OR: $ucb :OR: $type )
	|
	  DCD 0 ; Invalid Level 1 Table Entry
	]

	MEND

;-----------------------------------------------------------------------------
; Global Variables
;-----------------------------------------------------------------------------
	GBLA    counter


;-----------------------------------------------------------------------------
; Generate a Level 1 MMU Translation Table in ROM using repetitive assembly
;
; The generated Translation Table has the following characteristics: 
;
;  - Vritual addresses are same as physical addresses (Flat table)
;  - Sections are associated with Domain 0
;  - Permissions for Domain 0 are set to Client access (in enableMemoryCtrl())
;  - Sections 0x3C000000 to 0x3FF00000 are write-through cached. This 
;    corresponds to the area of the address map where the External ROM resides
;  - Other sections allowing access are non-buffered and non-cached
;  - Remaining sections do not allow access
;
; The diagram summerizes the MMU permissions:
;
;  ALL       - Read/Write Supervisor/User Modes
;  NB        - Non-buffered
;  NC        - Non-cached
;  WTC       - Write-through cached
;  NO ACCESS - No Access
;
;               Normal          MMU      
;  Address    Memory Map     Permissions        
;                            
; 0xFFFFFFFF +-----------+  +------------+  
;            | Interrupt |  |    ALL     |  
;            |Controller |  |   NB/NC    |  
; 0xF0000000 +-----------+  +------------+  
;            |  Unused   |  | NO ACCESS  |  
; 0xE0000000 +-----------+  +------------+  
;            |  Retry    |  |    ALL     | 
;            |           |  |   NB/NC    |   
; 0xD0000000 +-----------+  +------------+
;            |   APB     |  |    ALL     |  
;            |Peripherals|  |   NB/NC    |  
; 0xC0000000 +-----------+  +------------+  
;            |           |  |            | 
;            |           |  |            |
;            |  Unused   |  | NO ACCESS  |  
;            |           |  |            |
; 0x80100000 +-----------+  +------------+  
;            | Exception |  |    ALL     |   See Note Below  
;            |   Test    |  |   NB/NC    |    
; 0x80000000 +-----------+  +------------+  
;            | Internal  |  |    ALL     |  
;            |  Memory   |  |   NB/NC    |  
; 0x70000000 +-----------+  +------------+  
;            |           |  |            |  
;            |           |  |            |  
;            |  Unused   |  | NO ACCESS  |  
;            |           |  |            |  
; 0x40000000 +-----------+  +------------+
;            |   ESM     |  |    ALL     |
;            |   ROM     |  |    WTC     |
; 0x3C000000 +-----------+  +------------+  
;            | External  |  |    ALL     |  
;            |  Static   |  |   NB/NC    |  
;            |  Memory   |  |            |  
; 0x30000000 +-----------+  +------------+  
;            |           |  |            |  
;            |  Unused   |  | NO ACCESS  |  
;            |           |  |            |  
; 0x10000000 +-----------+  +------------+  
;            |  Unused   |  |    ALL     |  
;            |(reserved  |  |   NB/NC    |  
;            | for SDRAM)|  |            |  
; 0x00100000 +-----------+  +------------+  
;            | Internal  |  |    ALL     | 
;            |  Memory   |  |   NB/NC    |
;            |   Alias   |  |            |
; 0x00000000 +-----------+  +------------+  
;
;
; Note for area 0x80000000 - 0x80100000
;
; This section is in an undefined area of the memory map and would normally 
; have permissions set to NO_ACCESS. However, it has been made accessible, 
; so that the error response from the AHB bus (HRESP = ERROR) rather then in 
; the MMU/MPU, may be tested.
; The AHB Default Slave generates an error response when an attempt is made
; to access an undefined area of memory. This causes either a Data Abort or 
; a Prefetch Abort exception.
;
;-----------------------------------------------------------------------------

; The Level 1 Translation Table for the MMU must reside on a 16KB boundary 

    AREA		MMUlev1, ALIGN=14, DATA, READONLY
    
	EXPORT      mmutable_level1


mmutable_level1

counter SETA 0x00000000
	; 0x00 to 0x10000000, non-cached, non-buffered
	WHILE counter < 0x100
	L1Entry SECTION, (counter:SHL:20), ALL_ACCESS, 0, U_BIT 
counter SETA counter + 1
	WEND

	; 0x10000000 to 0x30000000, no access
	WHILE counter < 0x300
	L1Entry SECTION, (counter:SHL:20), NO_ACCESS, 0, U_BIT 
counter SETA counter + 1
	WEND

	; 0x30000000 to 0x3C000000, non-cached, non-buffered
	WHILE counter < 0x3C0
	L1Entry SECTION, (counter:SHL:20), ALL_ACCESS, 0, U_BIT 
counter SETA counter + 1
	WEND

	; 0x3C000000 - 0x40000000, write-through cached
	WHILE counter < 0x400
	L1Entry SECTION, (counter:SHL:20), ALL_ACCESS, 0, (C_BIT+U_BIT) 
counter SETA counter + 1
	WEND

	; 0x40000000 to 0x70000000, no access
	WHILE counter < 0x700
	L1Entry SECTION, (counter:SHL:20), NO_ACCESS, 0, U_BIT 
counter SETA counter + 1
	WEND

	; 0x70000000 - 0x80000000  non-cached, non-buffered
	WHILE counter < 0x800
	L1Entry SECTION, (counter:SHL:20), ALL_ACCESS, 0, U_BIT 
counter SETA counter + 1
	WEND

; Default Slave area - made accessible for test purposes
	; 0x80000000 - 0x80100000  non-cached, non-buffered
	WHILE counter < 0x801
	L1Entry SECTION, (counter:SHL:20), ALL_ACCESS, 0, U_BIT 
counter SETA counter + 1
	WEND

	; 0x80100000 to 0xC0000000, no access
	WHILE counter < 0xC00
	L1Entry SECTION, (counter:SHL:20), NO_ACCESS, 0, U_BIT 
counter SETA counter + 1
	WEND

	; 0xC0000000 - 0xE00000000  non-cached, non-buffered
	WHILE counter < 0xE00
	L1Entry SECTION, (counter:SHL:20), ALL_ACCESS, 0, U_BIT 
counter SETA counter + 1
	WEND

	; 0xE0000000 to 0xF0000000, no access
	WHILE counter < 0xF00
	L1Entry SECTION, (counter:SHL:20), NO_ACCESS, 0, U_BIT 
counter SETA counter + 1
	WEND

    ; 0xF0000000 - 0xFFF00000  non-cached, non-buffered
	WHILE counter < 0x1000
	L1Entry SECTION, (counter:SHL:20), ALL_ACCESS, 0, U_BIT 
counter SETA counter + 1
	WEND

    END