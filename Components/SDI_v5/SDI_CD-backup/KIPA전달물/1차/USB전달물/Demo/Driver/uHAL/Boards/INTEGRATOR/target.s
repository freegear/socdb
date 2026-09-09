;/***************************************************************************
; * Copyright © ARM Limited 1998, 1999.  All rights reserved.
; ***************************************************************************/

	SUBT	Integrator board description and Angel support > INTEGRATOR/target.s
	; ---------------------------------------------------------------------
	; This file defines the Integrator manifests and macros required
	; to support the Angel world. It is not a complete description
	; of the board, only the information necessary for Angel. It
	; is envisaged that individual device drivers or application
	; code will hold the necessary definitions for the other board
	; features.
	;
	; NOTE: To help keep the main Angel source as generic as
	; possible, heavy use is made of macros. However, it is likely
	; that the use of macros will hide some very obvious and
	; simple optimisations. If optimised Angel source is required,
	; then a fixed target version should be created by the porting
	; developer. The aim of Angel is to be as simple and quick to
	; port as possible.
	;
	; $Revision: 1.29.2.2 $
	;	$Author: asims $
	;	$Date: 2000/01/21 18:55:08 $
	;
	;
	;
	; ---------------------------------------------------------------------

      IF :DEF: OPT
	ASSERT  (listopts_s)
old_opt SETA	{OPT}
	OPT	(opt_off)	; disable listing of include files
      ENDIF

	; ---------------------------------------------------------------------

	IF :LNOT: :DEF: INTEGRATOR_target_s

		GBLL	INTEGRATOR_target_s
INTEGRATOR_target_s	SETL	{TRUE}

	; ---------------------------------------------------------------------
	; The "ROMonly" build variable controls whether the system
	; being built supports a system where only ROM is mapped at
	; zero, and RAM cannot be mapped there. i.e. where the ARM
	; vectors are hard-wired in ROM. We create this variable
	; un-conditionally, to ensure that if an attempt is made to
	; define it elsewhere then a build error will occur.
	
		GBLL	ROMonly	; depends on target
ROMonly		SETL	{FALSE}	; {TRUE} if no RAM at zero


	INCLUDE platform.s
	GET	mmumacro.s

	; ---------------------------------------------------------------------
	; -- ANGEL and uHAL Support macros ------------------------------------
	; ---------------------------------------------------------------------

	; ------------------------------------------------------------------
	; STEP_ONE
	; --------
	; First instruction.
	; Normally LDR	PC, uHALip_ResetStart
	; If the uHAL application is executing from a different address
	; to the address it was built for (such as a system where 
	; memory management hasn't been turned on yet), the first
	; instruction may _have_ to be a branch relative:
	; B	uHALir_ResetGo

	MACRO
	STEP_ONE
 	LDR	PC, uHALip_ResetStart
	MEND

	; ------------------------------------------------------------------
	; CHECK_PRIMARY_CPU
	; -----------------
	; The Integrator/SDB hardware support multiple headers, however
	; uHAL is not currently multiprocessor aware. If the platform
	; supports multiple CPUs, platform-specific initialisation
	; will be required before this block can be removed.

	MACRO
	CHECK_PRIMARY_CPU
	
SELECTABLE_PRIMARY EQU 0

 IF SELECTABLE_PRIMARY <> 0
	;
	; Read switches to see which header has been choosen to be the primary.
	;
	LDR	r5, =INTEGRATOR_DBG_BASE
	LDR	r5, [r5, #INTEGRATOR_DBG_SWITCH_OFFSET] ; Read switches
	AND	r5, r5, #0x6		; We only want switches 2 & 3 (middle two).
	MOV	r5, r5, LSR #1		; Shift right one to get selected header number
 ELSE
	MOV	r5, #0			; Force to header 0.
 ENDIF

	LDR	r4, =INTEGRATOR_HDR_BASE ; Load base address of header registers
	LDR	r6, [r4, #INTEGRATOR_HDR_STAT_OFFSET] ; Load HDR_STAT
	AND	r6, r6, #0xFF		; Get header number
	CMP	r6, r5			; Is this the header select to be the primary	

	LDR	r7, [r4, #INTEGRATOR_HDR_CTRL_OFFSET]
	ORREQ	r7, r7, #INTEGRATOR_HDR_CTRL_LED ; Primary - Ensure header LED is ON
	BICNE	r7, r7, #INTEGRATOR_HDR_CTRL_LED ; Secondary - Ensure header LED is OFF
	STR	r7, [r4, #INTEGRATOR_HDR_CTRL_OFFSET]
	BEQ	%F5			; Continue

	;
	; If header zero is a secondary it will check to see if the primary exists.
	;
	CMP	r6, #0			; Is this header zero
	BNE	%F2			; Spin
	LDR	r7, =INTEGRATOR_SC_BASE
	LDR	r7, [r7, #INTEGRATOR_SC_DEC_OFFSET] ; Load decoder status
	MOV	r6, #1
	TST	r7, r6, LSL r5		; Is selected header present
	BNE	%F2 			; If yes then spin

	;
	; Selected header is not present therefore we will flash the yellow LED.
	;
	LDR	r7, =INTEGRATOR_RTC_BASE
1	LDR	r4, [r7]
	ANDS	r4, r4, #1
	MOVNE	r4, #YELLOW_LED
	SET_LEDS r4, r6 
	B	%B1

	;
	; This is not the primary header therefore we should go into a infinite
	; loop.  However if it executes this loop from flash it will create a lot
	; of system bus traffic, also if the primary tries reprogram flash the loop
	; will disappear and then things are likely to break in a big way.  Therefore
	; we need to create to loop in the local SSRAM and transfer control to it.
	;
2	LDR	pc, =%F3		; Ensure that we are executing at linked address
3	LDR	r7, [r4, #INTEGRATOR_HDR_CTRL_OFFSET]
	ORR	r7, r7, #INTEGRATOR_HDR_CTRL_REMAP	; Ensure REMAP bit is set
        STR     r7, [r4, #INTEGRATOR_HDR_CTRL_OFFSET]
	LDR	r6, =0xEAFFFFFE		; Load 'B .' instruction
	MOV	r4, #0
	STR	r6, [r4, #0x00]		; Load instruction to Reset vector
	STR	r6, [r4, #0x04]		; Load instruction to UnDef vector
	STR	r6, [r4, #0x08]		; Load instruction to SWI vector
	STR	r6, [r4, #0x0C]		; Load instruction to Prefetch Abort vector
	STR	r6, [r4, #0x10]		; Load instruction to Data Abort vector
	STR	r6, [r4, #0x18]		; Load instruction to IRQ vector
	STR	r6, [r4, #0x1C]		; Load instruction to FIQ vector
	STR	r6, [r4, #0x20]		; Load instruction address 0x20
	MOV	pc, #0x20		; Goto address 0x20

	; !!!!!!!!!!!!!!!!!!!!!!
	; Non-Primary header will not progress pass this point as it does not support
	; multiprocessors.
	; !!!!!!!!!!!!!!!!!!!!!!

	;
	; Exit path for primary
	;
5	MOV	r4, #0
	SET_LEDS r4, r5		; Ensure motherboard LED's are OFF

	MEND

        ; ------------------------------------------------------------------
	; UNMAPROM
	; --------
	; Provide code to deal with mapping the reset ROM away from zero
	; (if required).

	MACRO
$label  UNMAPROM	$w1,$w2

	LDR	$w1, =INTEGRATOR_HDR_BASE
	LDR	$w2, [$w1, #INTEGRATOR_HDR_CTRL_OFFSET]
	ORR	$w2, $w2, #INTEGRATOR_HDR_CTRL_REMAP	; Set REMAP bit
        STR     $w2, [$w1, #INTEGRATOR_HDR_CTRL_OFFSET]

	MEND

	; ---------------------------------------------------------------------
	; STARTUPCODE             ** ANGEL SPECIFIC **
	; -----------
	; Provide code to deal with the main act of mapping the reset
	; ROM away from zero (if required), and ensuring that the
	; target I/O world is suitably clean before attempting to
	; initialise the rest of Angel.
	;
	; NOTE:  do not use r4, that's $pos.
	;
	
	MACRO
$label  STARTUPCODE	$w1,$w2,$pos,$ramsize

      IF {ENDIAN} = "big"
	; Need to be in big-endian mode before any byte/half-word accesses
	MOV	$w1, #0
	SET_BIGEND	$w1
	WRMMU_STATE	$w1	; Update control register
      ENDIF

	; Okay, now initialise LEDs to a known state - off
	MOV	$w1, #0			; all off
	
	SET_LEDS	$w1, $w2

	; Wait around to allow led pattern to be seen
	LDR	r0, =0x8000
1
	SUBS	r0, r0, #1
	BNE	%B01

      IF :DEF: FLASH_BOOT_LOADER
	; Check which flash block is to be executed (and switch to it).
	BOOTLD	$w1, $w2

	; We only return here if flash block 0 was selected.
      ENDIF		; FLASH_BOOT_LOADER

	; Initialise the DRAM (if present)
	; NOTE: These macros have become so large that startrom.s cannot
	;	handle local branches around STARTUPCODE. So we need to put
	;	in an LTORG _inside_ this macro (with associated branch).
	;vvvvvvvvvvvvvvv
	B	StartMem

	LTORG		; Allows code using STARTUPCODE to do local loads

StartMem
	INIT_RAM	$w1, $w2, $ramsize

	DISABLE_INTS	$w1, $w2

	; Finally, setup PCI
      IF uHAL_PCI = 1
	SETUP_PCI	$w1, $w2, r6, r7
      ENDIF

	MOV		$w1, #1				; 001, --Y
	DO_DEBUG	$w1, $w2

	MEND


	; ---------------------------------------------------------------------
	; RAM_REG
	; -------
	; ANGEL and uHAL macro to convert the memory size into a size mask for
	; the DRAM_ADDR_SIZE registers. Looks for the LSB (since each array is
	; a power of 2 in size) and returns the number of zero's bits which is
	; the mask..
	;	$w1 -> size of array (multiple of 1MB)
	;	$w2 -> returns mask value

	MACRO
	RAM_REG	$w1, $w2		; Convert to DRAM_ADDR_SIZE mask
	MOV	$w2, #0
	CMP	$w1, $w2
	BEQ	%F02			; Empty - nothing to do
1
	ADD	$w2, $w2, #1
	TST	$w1, #1			; LSB set?
	MOV	$w1, $w1, LSR #1
	BEQ	%B01			; No, try next shuffled down bit
2
	MEND

	; ------------------------------------------------------------------
	; GOTO_ROM
	; --------
	; ANGEL and uHAL macro to switch from 0 to high alias of ROM. Some
	; systems cannot just switch to High ROM, but must set up the MMU.

	MACRO
	GOTO_ROM	$w1, $w2

        ; Loading pc with uHALip_HiReset makes sure we're running from
        ; real rom, rather than a shadowed address.

 IF :DEF: SEMIHOSTED
        LDR     pc, =uHALip_HiReset
uHALip_HiReset
 ENDIF

	LDR	$w1, =INTEGRATOR_HDR_BASE
	LDR	$w2, [$w1, #INTEGRATOR_HDR_CTRL_OFFSET]
	ORR	$w2, $w2, #INTEGRATOR_HDR_CTRL_REMAP	; Set REMAP bit
    STR     $w2, [$w1, #INTEGRATOR_HDR_CTRL_OFFSET]

	MEND

	; ---------------------------------------------------------------------
	; VALIDATE_PROCESSOR
	; ------------------
	;
	; Macro to validate that the software and hardware are compatible.
	;
	MACRO
	VALIDATE_PROCESSOR	$w1, $w2, $w3

	CHECK_VENDOR	$w1, $w2
	BNE	%F01

	; Checks to see if the h/w and s/w match.
	CHECK_CPUID	$w1, $w2
	BEQ	%F02

	; If we get here then there is a problem.  We will flash the
	; red LED on the motherboard to indicate this.
1	LDR	$w3, =INTEGRATOR_RTC_BASE
	LDR	$w1, [$w3]
	ANDS	$w1, $w1, #1
	MOVNE	$w1, #RED_LED

	SET_LEDS $w1, $w2 

	B	%B01
2

	MEND

	;---------------------------------------------------------------------
	; SETUP_ASYNC_CLOCKS
	; ------------------
	;
	; Set up asynchronous clocking (eg. core and memory clocks different)
	;
	MACRO
	SETUP_ASYNC_CLOCKS	$w1, $w2

	;
	; Read bit field in HDR_OSC to determine how to do this.
	;
	LDR	$w1, =INTEGRATOR_HDR_BASE
	LDR	$w2, [$w1, #INTEGRATOR_HDR_OSC_OFFSET]
	AND	$w2, $w2, #INTEGRATOR_HDR_OSC_BUS_MODE_MASK
	CMP	$w2, #INTEGRATOR_HDR_OSC_BUS_MODE_CM9x0

	;
	; CM9x0 (1) - Set nFastBus and asynchronous clock bits in CP15 register 1
	;
	; This can not use the macro WRCLK_EnableClockSW as it is processor
	; specific (and therefore it may be do nothing) and this code is
	; required in the generic case.
	;
	MRCEQ   p15, 0, $w2, c1, c0, 0
	ORREQ   $w2, $w2, #0xC0000000
	MCREQ   p15, 0, $w2, c1, c0, 0

	;
	; CM7x0 (0) - Ensure Fastbus bit in HDR_CTRL is cleared.
	;
	LDRLT	$w2, [$w1, #INTEGRATOR_HDR_CTRL_OFFSET]
	BICLT	$w2, $w2, #INTEGRATOR_HDR_CTRL_FASTBUS
	STRLT	$w2, [$w1, #INTEGRATOR_HDR_CTRL_OFFSET]

	;
	; CM9x6 (2)   - No set up required.
	; CM10x00 (3) - No set up required.
	;

	MEND


	; ---------------------------------------------------------------------
	; SETUP_DEFAULT_CLOCKS
	; --------------------
	;
	; Macro to set up the clock settings on Integrator depending
	; on what type of header card we are running on.
	;
	; Core clock must always be greater than memory clock.
	;
	; These are -
	;
	; Processor    Core    Memory Bus   System Bus   PCI Bus
	; =========    ====    ==========   ==========   =======
	; Unknown      40MHz      20MHz        20MHz      33MHz
	; ARM720T      50MHz      40MHz        20MHz      33MHz
	; ARM740T      50MHz      40MHz        20MHz      33MHz
	; ARM920T     100MHz      40MHz        20MHz      33MHz
	; ARM940T     100MHz      40MHz        20MHz      33MHz
	;
	MACRO
	SETUP_DEFAULT_CLOCKS	$w1, $w2, $w3

	;
	; Read HDR_PROC register, if this is non zero then there is no
	; coprocessor, in this case use the default settings.
	;
	LDR	$w2, =(INTEGRATOR_HDR_OSC_CORE_40MHz :OR: INTEGRATOR_HDR_OSC_MEM_20MHz)
	LDR	$w1, =INTEGRATOR_HDR_BASE
	LDR	$w3, [$w1, #INTEGRATOR_HDR_PROC_OFFSET]
	CMP	$w3, #0
	BNE	%F01

	; Get the processor ID. The RDCPU_ID macro will always return
	; something, even for CPUs without a coprocessor.
	;
	; If the processor type is not recognised then the default settings
	; will be used.
	RDCPU_ID	$w1, $w3
	CMP	$w3, #0x720		; Is this a 720
	CMPNE	$w3, #0x740		; or a 740
	LDREQ	$w2, =(INTEGRATOR_HDR_OSC_CORE_50MHz :OR: INTEGRATOR_HDR_OSC_MEM_40MHz)
	BEQ	%F01
	CMP	$w3, #0x920		; Is this a 920
	CMPNE	$w3, #0x940		; or a 940
	LDREQ	$w2, =(INTEGRATOR_HDR_OSC_CORE_100MHz :OR: INTEGRATOR_HDR_OSC_MEM_40MHz)

1
	;
	; Write clock settings
	;
	LDR	$w1, =INTEGRATOR_HDR_BASE
	LDR	$w3, =0xA05F
	STR	$w3, [$w1, #INTEGRATOR_HDR_LOCK_OFFSET]
	STR	$w2, [$w1, #INTEGRATOR_HDR_OSC_OFFSET]
	MOV	$w2, #0
	STR	$w2, [$w1, #INTEGRATOR_HDR_LOCK_OFFSET]

	;
	; Set up System BUS and PCI clocks
	;
	LDR	$w1, =INTEGRATOR_SC_BASE
	STR	$w3, [$w1, #INTEGRATOR_SC_LOCK_OFFSET]
	LDR	$w2, =(INTEGRATOR_SC_OSC_SYS_20MHz :OR: INTEGRATOR_SC_OSC_PCI_33MHz)
	STR	$w2, [$w1, #INTEGRATOR_SC_OSC_OFFSET]
	MOV	$w2, #0
	STR	$w2, [$w1, #INTEGRATOR_SC_LOCK_OFFSET]

	MEND



	; ---------------------------------------------------------------------
	; INIT_STATIC_MEMORY
	; ------------------
	; Macro to initialise static memory (Flash, ROM and SRAM) on startup.
	;
	MACRO
	INIT_STATIC_MEMORY	$w1, $w2, $w3

	;
	; Do nothing, the hardware will always default the EBI to sensible values.
	;


	MEND

	; ---------------------------------------------------------------------
	; INIT_RAM
	; --------
	; ANGEL and uHAL macro to initialise memory on startup.

	MACRO
	INIT_RAM	$w1, $w2, $w3

	VALIDATE_PROCESSOR	$w1, $w2, $w3

	SETUP_ASYNC_CLOCKS	$w1, $w2

	;
	; No longer try and set the clocks as it overridge the clock
	; setting in the boot monitor/switcher.
	;
	; SETUP_DEFAULT_CLOCKS	$w1, $w2, $w3

	INIT_STATIC_MEMORY	$w1, $w2, $w3

	;
	; Size SDRAM 
	;
	; Check to see if the SPD data has been loaded.  If the load has 
	; not completed we will loop upto 64K times before giving up.
	;
	LDR	$w1, =INTEGRATOR_HDR_SDRAM	; Load address of HDR_SDRAM
	MOV	$w2, #0x10000		; Load count

1	LDR	$w3, [$w1]		; Load contents of HDR_SDRAM
	TST	$w3, #INTEGRATOR_HDR_SDRAM_SPD_OK ; Check to see if SPD data is loaded
	BNE	%F02
	SUBS	$w2, $w2, #1		; Decrement the count
	BGT	%B01			; Try again	
	B	%F05

	;
	; Verify the SPD checksum
	;
2	LDR	$w1, =INTEGRATOR_HDR_SPDBASE	; Load address of the base of SPD data
	MOV	$w3, #0

3	LDRB	$w2, [$w1], #1		; Load byte
	ADD	$w3, $w3, $w2		; Add to checksum
	LDR	$w2, =(INTEGRATOR_HDR_SPDBASE + 62) ; Have we got to byte 62
	CMP	$w1, $w2
	BLS	%B03

	LDR	$w1, =INTEGRATOR_HDR_SPDBASE	; Load address of the base of SPD data
	LDRB	$w2, [$w1, #63]		; Get checksum from SPD
	AND	$w3, $w3, #0xFF		; Mask out calculated checksum
	CMP	$w2, $w3		; Are they the same

;
; We will no longer fail if the checksum calculation fails as we have
; found some DIMM's that do not have a valid checksum.
;
;	BNE	%F05


	;
	; Calculate the memory size from the SPD data.
	;
	LDRB	$w2, [$w1, #31]		; Get Module Bank Density
	MOV	$w2, $w2, LSL #2	; Multiply by 4
	LDRB	$w3, [$w1, #5]		; Get Number of Banks
	MULS	$w2, $w3, $w2		; Multiple together to get size in MBytes
	BEQ	%F05			; If zero then something has gone wrong

	;
	; The maximum SDRAM DIMM supported is 256M
	;
	CMP	$w2, #256
	BGT	%F05

	;
	; We need to convert the size in MBytes to the value the value
	; to write to the MEMSIZE field of HDR_SDRAM.  The formula to do
	; this is as follows -
	;
	; 	MEMSIZE = LOG2(SizeInMB) - 4
	;
	; All the sizes that are supported are powers of 2 so a simple
	; algorithm to find LOG2 of number is to count the number of trailing
	; zeros.
	;
	MOV	$w1, #0			; Initialise the counter
4	TST	$w2, #1			; Is the bottom bit set of the size varible
	MOVEQ	$w2, $w2, LSR #1	; If not set then divide by 2
	ADDEQ	$w1, $w1, #1		; If not set then increment the counter
	BEQ	%B04			; If not set then loop

	CMP	$w2, #1			; $w2 should now contain 1
	BNE	%F05			; If it doesn't then something has gone wrong

	LDR	$w2, =INTEGRATOR_HDR_BASE ; Load base address of header registers
	LDR	$w3, [$w2, #INTEGRATOR_HDR_SDRAM_OFFSET] ; Load contents of HDR_SDRAM
	AND	$w3, $w3, #3		; Clear the everything expect CASLAT
	SUBS	$w1, $w1, #4		; Subtract 4 from the number of trailing bits
	BMI	%F05   			; If negative then something has gone wrong
	ORR	$w3, $w3, $w1, LSL #2	; Merge it into contents of HDR_SDRAM

	LDRB	$w1, [$w2, #(INTEGRATOR_HDR_SPDBASE_OFFSET + 3)] ; No. of Rows
	AND	$w1, $w1, #0xF		; Only want bottom 4 bits
	ORR	$w3, $w3, $w1, LSL #8	; Merge into HDR_SDRAM

	LDRB	$w1, [$w2, #(INTEGRATOR_HDR_SPDBASE_OFFSET + 4)] ; No. of Columns
	AND	$w1, $w1, #0xF		; Only want bottom 4 bits
	ORR	$w3, $w3, $w1, LSL #12	; Merge into HDR_SDRAM

	LDRB	$w1, [$w2, #(INTEGRATOR_HDR_SPDBASE_OFFSET + 5)] ; No. of Banks
	AND	$w1, $w1, #0xF		; Only want bottom 4 bits
	ORR	$w3, $w3, $w1, LSL #16	; Merge into HDR_SDRAM

	STR	$w3, [$w2, #INTEGRATOR_HDR_SDRAM_OFFSET] ; Write back to HDR_SDRAM

	;
	; Now calculate the size of memory in bytes, this is done by
	; shifting 1 by MEMSIZE + 24.  The magic number 24 is the 4 we
	; subtracted earlier plus 20 to get the value is bytes (2^20
	; being 1 Mbyte).
	;
	MOV	$w1, $w3, LSR #2	; Need to extract MEMSIZE from the
	AND	$w1, $w1, #0x7		;  the value we wrote to HDR_SDRAM

	MOV	$w2, #1			; Load 1
	ADD	$w1, $w1, #24		; Add 24 to the MEMSIZE value
	MOV	$w1, $w2, LSL $w1	; Shift 1 by (24 + MEMSIZE)
	B	%F06

5	MOV	$w1, #0			; Could not find any good DRAM
	
6	LDR	$w2, =INTEGRATOR_HDR_BASE ; Load base address of header registers
	LDR	$w2, [$w2, #INTEGRATOR_HDR_STAT_OFFSET] ; Load contents of HDR_STAT
	ANDS	$w2, $w2, #0xFF0000	; Clear all but bits 23:16 to get SSRAM size
	MOVEQ	$w2, #SZ_256K		; If zero then this is a old header with 256K
	CMP	$w1, $w2		; Is there less SDRAM than the SSRAM
	MOVMI	$w1, $w2		; If so then return the size of the SSRAM
	MOV	$w3, $w1		; Need to return size in both these registers

	MEND


	; ---------------------------------------------------------------------
	; SETUP_PCI
	; ---------
	; Setup the PCI.  Assumes that we're running the V3 as host.
	;
	; The V3 PCI interface chip in Integrator provides several windows from
	; local bus memory into the PCI memory areas.   Unfortunately, there
	; are not really enough windows for our usage, therefore we reuse 
	; one of the windows for access to PCI configuration space.  The
	; memory map is as follows:
	; 
	; 	Local Bus Memory         Usage
	; 
	; 	80000000 - 8FFFFFFF      PCI memory.  256M non-prefetchable
	; 	90000000 - 9FFFFFFF      PCI memory.  256M prefetchable
	; 	B0000000 - B0FFFFFF      PCI IO.  16M
	; 	B8000000 - B8FFFFFF      PCI Configuration. 16M
	; 
	; There are three V3 windows, each described by a pair of V3 registers.
	; These are LB_BASE0/LB_MAP0, LB_BASE1/LB_MAP1 and LB_BASE2/LB_MAP2.
	; Base0 and Base1 can be used for any type of PCI memory access.   Base2
	; can be used either for PCI I/O or for I20 accesses.  By default, uHAL
	; uses this only for PCI IO space.
	; 
	; PCI Memory is mapped so that assigned addresses in PCI Memory match
	; local bus memory addresses.  In other words, if a PCI device is assigned
	; address 80200000 then that address is a valid local bus address as well
	; as a valid PCI Memory address.  PCI IO addresses are mapped to start
	; at zero.  This means that local bus address B0000000 maps to PCI IO address
	; 00000000 and so on.   Device driver writers need to be aware of this 
	; distinction.
	; 
	; Normally these spaces are mapped using the following base registers:
	; 
	; 	Usage Local Bus Memory         Base/Map registers used
	; 
	; 	Mem   80000000 - 8FFFFFFF      LB_BASE0/LB_MAP0
	; 	Mem   90000000 - 9FFFFFFF      LB_BASE1/LB_MAP1
	; 	      A0000000 - AFFFFFFF      
	; 	IO    B0000000 - B0FFFFFF      LB_BASE2/LB_MAP2
	; 	Cfg   B8000000 - B8FFFFFF      
	; 
	; This means that I20 and PCI configuration space accesses will fail.
	; When PCI configuration accesses are needed (via the uHAL PCI 
	; configuration space primitives) we must remap the spaces as follows:
	; 
	; 	Usage Local Bus Memory         Base/Map registers used
	; 
	; 	Mem   80000000 - 8FFFFFFF      LB_BASE0/LB_MAP0
	; 	Mem   90000000 - 9FFFFFFF      LB_BASE0/LB_MAP0
	; 	      A0000000 - AFFFFFFF      
	; 	IO    B0000000 - B0FFFFFF      LB_BASE2/LB_MAP2
	; 	Cfg   B8000000 - B8FFFFFF      LB_BASE1/LB_MAP1
	; 
	; To make this work, the code depends on overlapping windows working.
	; The V3 chip translates an address by checking its range within 
	; each of the BASE/MAP pairs in turn (in ascending register number
	; order).  It will use the first matching pair.   So, for example,
	; if the same address is mapped by both LB_BASE0/LB_MAP0 and
	; LB_BASE1/LB_MAP1, the V3 will use the translation from 
	; LB_BASE0/LB_MAP0.
	; 
	; To allow PCI Configuration space access, the code enlarges the
	; window mapped by LB_BASE0/LB_MAP0 from 256M to 512M.  This occludes
	; the windows currently mapped by LB_BASE1/LB_MAP1 so that it can
	; be remapped for use by configuration cycles.
	; 
	; At the end of the PCI Configuration space accesses, 
	; LB_BASE1/LB_MAP1 is reset to map PCI Memory.  Finally the window
	; mapped by LB_BASE0/LB_MAP0 is reduced in size from 512M to 256M to
	; reveal the now restored LB_BASE1/LB_MAP1 window.
	; 
	; NOTE: We do not set up I20 mapping.  I suspect that this is only
	; for an intelligent (target) device.  Using I2O disables most of
	; the mappings into PCI memory.
	;
	; NOTE:	 we load $w1 with the base address of the V3's register set
	; at the start of the macro and expect it not to change!
	MACRO
$label	SETUP_PCI	$w1, $w2, $w3, $w4

	; We must first turn on PCI
	LDR	$w1, =INTEGRATOR_SC_PCIENABLE
	LDR	$w2, =0x1
	STR	$w2, [$w1]
	
	; Load up the base address of the V3 register set
	LDR	$w1, =PCI_V3_BASE

	; we can NOT try ANY reads from the V3 bridge chip until LB_IO_BASE is written
	; we ASSUME that we've already waited for >=230us (@PCLK 25MHz) since reset
	; so that this write WILL have an effect on the V3 chip
	; Set up where the V3 registers appear in the memory map (PCI_V3_BASE)
	LDR	$w2, =PCI_V3_BASE
	MOV	$w2, $w2, LSR #16
	STRH	$w2, [$w1, #V3_LB_IO_BASE]

	; Wait for the V3 to realise that there is no SROM
	LDR	$w2, =0xAA
	LDR	$w3, =0x55
30	STRB	$w2, [$w1, #V3_MAIL_DATA]
	STRB	$w3, [$w1, #V3_MAIL_DATA + 4]
	LDRB	$w4, [$w1, #V3_MAIL_DATA]
	CMP	$w4, #0xAA
	BNE	%b30
	LDRB	$w4, [$w1, #V3_MAIL_DATA + 4]
	CMP	$w4, #0x55
	BNE	%b30
	
	; Make sure that V3 register access is not locked, if it is, unlock it.
	LDRH	$w2, [$w1, #V3_SYSTEM]
	AND	$w2, $w2, #V3_SYSTEM_M_LOCK
	CMP	$w2, #V3_SYSTEM_M_LOCK
	LDREQ	$w2, =0xA05F
	STREQH	$w2, [$w1, #V3_SYSTEM]

	; ensure that slave accesses from PCI are DISabled while we set up windows
	LDRH	$w2, [$w1, #V3_PCI_CMD]        ; get current CMD register
	BIC	$w2, $w2, #(V3_COMMAND_M_MEM_EN :OR: V3_COMMAND_M_IO_EN)
	STRH	$w2, [$w1, #V3_PCI_CMD]        ; MEM & IO now BOTH bounce
	
	; Clear RST_OUT to 0: keep the PCI bus in reset until we're finished
	LDRH	$w2, [$w1, #V3_SYSTEM]
	BIC	$w2, $w2, #V3_SYSTEM_M_RST_OUT
	STRH	$w2, [$w1, #V3_SYSTEM]
	
	; Make all accesses from PCI space retry until we're ready for them
	LDRH	$w2, [$w1, #V3_PCI_CFG]
	ORR	$w2, $w2, #V3_PCI_CFG_M_RETRY_EN
	STRH	$w2, [$w1, #V3_PCI_CFG]
	
	; Set up any V3 PCI Configuration Registers that we absolutely have to
        ; LB_CFG controls Local Bus protocol.
        ; enable LocalBus byte strobes for READ accesses too
        ; ###### need to set up timeout bits as well
        LDRH    $w2, [$w1, #V3_LB_CFG]
        ORR     $w2, $w2, #0x0C0                ; set bit7 BE_IMODE & bit6 BE_OMODE
        STRH    $w2, [$w1, #V3_LB_CFG]

        ; PCI_CMD controls overall PCI operation
        ; ###### possibly need to set up FBB_EN, SERR_EN, PAR_EN bits as well
        ; enable PCI bus master;
        ; ###### eventually need to set bit1 MEM_EN to enable PCI slave for memory but NOT I/O
        LDRH    $w2, [$w1, #V3_PCI_CMD]
        ORR     $w2, $w2, #0x04                 ; set bit2 MASTER_EN
        STRH    $w2, [$w1, #V3_PCI_CMD]

        ; PCI_HDR_CFG controls PCI master timeouts etc.
        ; ###### probably want to set bits 15-11 (latency timer) to non-zero

        ; PCI_SUB_VENDOR contains an info field for other masters
        ; ###### REQUIRED by PCIspec2.1 & Win95 (WinCE?) ... BUT what value?

        ; PCI_SUB_ID contains an info field for other masters
        ; ###### REQUIRED by PCIspec2.1 & Win95 (WinCE?) ... BUT what value?

        ; PCI_MAP0 controls where the PCI to CPU memory window is on the Local Bus
	LDR	$w2, =INTEGRATOR_BOOT_ROM_BASE  ; start of EBI memory
	MOV	$w2, $w2, LSR #20               ; clip to 12-bit field
	MOV	$w2, $w2, LSL #20               ; at top of word wide reg
	; aperture size is 512M
	ORR	$w2, $w2, #V3_PCI_MAP_M_ADR_SIZE_512M
	; PCI_BASE0 reg MUST be enabled before writing it
	; aperture itself enabled too
	ORR	$w2, $w2, #V3_PCI_MAP_M_REG_EN :OR: V3_PCI_MAP_M_ENABLE
	STR	$w2, [$w1, #V3_PCI_MAP0]        ; finally write the reg

	; PCI_BASE0 is the PCI address of the start of the window
	LDR	$w2, =INTEGRATOR_BOOT_ROM_BASE  ; 1:1 mapping to start of EBI memory
	MOV	$w2, $w2, LSR #20               ; clip to 12-bit field
	MOV	$w2, $w2, LSL #20               ; at top of word wide reg
	; read may NOT be prefetched for this aperture (MAY change for later FPGA)
	; BIC $w2, $w2, #V3_PCI_BASE_M_PREFETCH   bit already 0 => NO pre-fetch
	STR	$w2, [$w1, #V3_PCI_BASE0]

        ; ###### do we inhibit PCI read posting? (bit15)

	; PCI_MAP1 is LOCAL address of the start of the window
	LDR	$w2, =INTEGRATOR_HDR0_SDRAM_BASE; start of aliassed header memory
	MOV	$w2, $w2, LSR #20               ; clip to 12-bit field
	MOV	$w2, $w2, LSL #20               ; at top of word wide reg
	; aperture size is 1024M
	ORR	$w2, $w2, #V3_PCI_MAP_M_ADR_SIZE_1024M
	; PCI_BASE1 reg MUST be enabled before writing it
	; aperture itself enabled too
	ORR	$w2, $w2, #(V3_PCI_MAP_M_REG_EN :OR: V3_PCI_MAP_M_ENABLE)
	STR	$w2, [$w1, #V3_PCI_MAP1]        ; finally write the reg

	; PCI_BASE1 is the PCI address of the start of the window
	LDR	$w2, =INTEGRATOR_HDR0_SDRAM_BASE; 1:1 mapping to start of header memory
	MOV	$w2, $w2, LSR #20               ; clip to 12-bit field
	MOV	$w2, $w2, LSL #20               ; at top of word wide reg
	; read may NOT be prefetched for this aperture (MAY change for later FPGA)
	; BIC $w2, $w2, #V3_PCI_BASE_M_PREFETCH       ;### bit already 0
	STR	$w2, [$w1, #V3_PCI_BASE1]

        ; PCI_INT_CFG controls PCI interrupt pins
        ; ###### need to route 1 or 2 of INTx to INTy (but what are x and y on SDB?)

        ; FIFO_CFG controls V3 FIFOs in both directions
        ; ###### need to think about e.g. LBurstMax in conjunction with FPGA bridge

        ; FIFO_PRIORITY controls V3 FIFOs in both directions
        ; ###### need to think about e.g. read-flush strategies

	; Set up the windows from local bus memory into PCI configuration, I/O
	; and Memory
	; ...PCI I/O, LB_BASE2 and LB_MAP2 are used exclusively for this
	LDR	$w2, =PCI_IO_BASE
	MOV	$w2, $w2, LSR #24               ; clip to 8-bit field
	MOV	$w2, $w2, LSL #8                ; at top of half-word reg
	ORR	$w2, $w2, #V3_LB_BASE_M_ENABLE	
	STRH	$w2, [$w1, #V3_LB_BASE2]
	LDR	$w2, =0				; map to I/0 address 0 and above 
	STRH	$w2, [$w1, #V3_LB_MAP2]

	; ...PCI Configuration, use LB_BASE1/LB_MAP1.  Set up on the fly by
	;    the PCI Configuration access code in board.c
	
	; ...PCI Memory, use LB_BASE0/LB_MAP0 and LB_BASE1/LB_MAP1
	;    Map first 256Mbytes as non-prefetchable via BASE0/MAP0
	LDR	$w2, =PCI_MEM_BASE
	MOV	$w2, $w2, LSR #20               ; clip to 12-bit field
	MOV	$w2, $w2, LSL #20               ; at top of word wide reg
	ORR	$w2, $w2, #0x80			; Window size is 256 Mbytes (7:4 = 1000)
	ORR	$w2, $w2, #V3_LB_BASE_M_ENABLE
	STR	$w2, [$w1, #V3_LB_BASE0]
	LDR	$w2, =PCI_MEM_BASE		; PCI_MEM_BASE maps to PCI MEM address at PCI_MEM_BASE 
	MOV	$w2, $w2, LSR #20               ; clip to 12-bit field
	MOV	$w2, $w2, LSL #4                ; at top of half-word reg
	ORR	$w2, $w2, #0x0006       	; 3:0 = 0110 = PCI Memory read/write
	STRH	$w2, [$w1, #V3_LB_MAP0]
	;    Map second 256Mbytes as prefetchable via BASE1/MAP1
	LDR	$w2, =PCI_MEM_BASE+SZ_256M
	MOV	$w2, $w2, LSR #20               ; clip to 12-bit field
	MOV	$w2, $w2, LSL #20               ; at top of word wide reg
	ORR	$w2, $w2, #0x84			; Window size is 256 Mbytes (7:4 = 1000), prefetchable
	ORR	$w2, $w2, #V3_LB_BASE_M_ENABLE
	STR	$w2, [$w1, #V3_LB_BASE1]	
	LDR	$w2, =PCI_MEM_BASE+SZ_256M
	MOV	$w2, $w2, LSR #20               ; clip to 12-bit field
	MOV	$w2, $w2, LSL #4                ; at top of half-word reg
	LDR	$w2, =0x0006			; 3:0 = 0110 = PCI Memory read/write
	STRH	$w2, [$w1, #V3_LB_MAP1]
	
	; Allow accesses to PCI Configuration space
        ; and set up A1,A0 for type 1 config cycles
	LDRH	$w2, [$w1, #V3_PCI_CFG]
	BIC	$w2, $w2, #V3_PCI_CFG_M_RETRY_EN
	BIC	$w2, $w2, #V3_PCI_CFG_M_AD_LOW1 ; force A1=0 and
	ORR	$w2, $w2, #V3_PCI_CFG_M_AD_LOW0 ; A0=1 for config type 1
	STRH	$w2, [$w1, #V3_PCI_CFG]
	
	;now we can allow in PCI MEMORY accesses
	LDRH	$w2, [$w1, #V3_PCI_CMD]        ; get current CMD register
	ORR	$w2, $w2, #V3_COMMAND_M_MEM_EN
	STRH	$w2, [$w1, #V3_PCI_CMD]        ; MEM now accepted (IO still bounced)

	; Set RST_OUT to take the PCI bus is out of reset, PCI devices can initialise
	; ... and lock the V3 system register so that no one else can play with it
	LDRH	$w2, [$w1, #V3_SYSTEM]
	ORR	$w2, $w2, #V3_SYSTEM_M_RST_OUT
	STRH	$w2, [$w1, #V3_SYSTEM]
	ORR	$w2, $w2, #V3_SYSTEM_M_LOCK
	STRH	$w2, [$w1, #V3_SYSTEM]
	
	MEND

	; ---------------------------------------------------------------------
	; SETUPMMU
	; -------
	; Setup the memory map world for the target. This macro is called by
	; INITMMU from ANGEL if required; or by uHAL when a standalone
	; program uses the mmu.
	;
	; Level 1 entries always address 1MB each. The CPU takes the MB
	;	portion of the required address and uses it as an offset
	;	into the table. If the entry has bit 0 == 1, it looks in
	;	the level 2 table.
	; Level 2 entries can address 4KB or 1KB each. If using 64KB level 2
	;	entries, each page table entry must be duplicated 16 times
	;	(in consecutive memory locations) in a Large level 2 table.
	; In this implementation, Fine tables _must_ be 1KB entries and Large
	; tables _only_ support 64KB entries.


	MACRO
$label  SETUPMMU	$tmp1, $size, $tmp2, $tmp3, $tmp4, $tmp5, $offset


 IF :LNOT: :DEF: uHAL_AddressTable
	IMPORT	uHAL_AddressTable
 ENDIF

 IF :LNOT: :DEF: uHAL_MappingTable
	IMPORT	uHAL_MappingTable
 ENDIF


	MOV	$tmp1, #4		; DEBUG: 100, R--
	DO_DEBUG	$tmp1, $tmp3

	; Scan for MPU and set up if found
	CHECK_FOR_MPU	$tmp1
	BEQ	%F79

	; ----------------------------------------------------
	; Here lies the MPU memory map for this board. Use it
	; with the offset between physical & virtual TTBs to
	; build a valid page table.
	; To use default memory size, pass in RAM size of zero
	; ----------------------------------------------------
	ldr	$tmp5, =uHAL_MappingTable
	LDR	$offset, =0
	SETUP_MPU	$tmp1, $size, $tmp2, $tmp3, $tmp4, $tmp5, $offset

79
	; Scan for MMU and set up if found
	CHECK_FOR_MMU	$tmp1
	BEQ	%F91

	; ----------------------------------------------------
	; Here lies the MMU memory map for this board. Use it
	; with the offset between physical & virtual TTBs to
	; build a valid page table.
	; To use default memory size, pass in RAM size of zero
	; ----------------------------------------------------
	ldr	$tmp5, =uHAL_AddressTable
	LDR	$offset, =0

	BUILD_PGTABLE	$tmp1, $size, $tmp2, $tmp3, $tmp4, $tmp5, $offset

	LDR	$tmp1, =Level1tab	;TTB address is 2**14 aligned
	WRMMU_TTBase 	 $tmp1		;Initialise Translation Table Base reg.
	LDR	$tmp1, =1
	WRMMU_DAControl $tmp1		;Initialise Domain Access Control

	; ----------------------------------------------------
	; Flush everything and get ready to turn on the MMU
	; ----------------------------------------------------
	WRMMU_FlushTB		 $tmp1	; Flush TB 
	WRCACHE_FlushIDC	 $tmp1	; Flush the Caches 

	NOP				; make sure that the pipe is empty
	NOP
	NOP

91
	MOV			$tmp1, #5		; DEBUG: 101, R-Y
	DO_DEBUG		$tmp1, $tmp3

	MEND

	; ----------------------------------------------------
	;
	; ANGEL and uHAL INITMMU macro, calls the core SETUPMMU macro if
	; the MMU is enabled and then sets ICache, DCache & WBuffer as
	; required.  On certain system where the target does not have a MMU,
	; then this  macro is almost (but not quite) a NOP: It is good to know
	; the MMU/cache register has been written and just using the ICache &
	; WBuffer on their own is still a useful gain.
	;
	; ----------------------------------------------------
	MACRO
$label  INITMMU	 $tmp1, $tmp2, $tmp3, $tmp4, $tmp5, $tmp6

IntegratorInitMMU  

 IF :LNOT: :DEF: ENABLE_MMU

ENABLE_MMU	EQU	1		; Angel flags not defined in uHAL
 ENDIF
 IF :LNOT: :DEF: CACHE_SUPPORTED
CACHE_SUPPORTED	EQU	1
 ENDIF

 IF ENABLE_MMU = 1

	LDR	$tmp2, =uHAL_MEMORY_SIZE	; Pass the top of memory
        SETUPMMU        $tmp1, $tmp2, $tmp3, $tmp4, $tmp5, $tmp6, r7
        LDR     $tmp2, =0

	SET_MMU	$tmp2

 ELSE

        LDR     $tmp2, =0               ; No MMU - running out of flash @ 0

 ENDIF  ; ENABLE_MMU

        RDMMU_STATE     $tmp1		; Read current contents of control register

 IF CACHE_SUPPORTED = 1
	SET_ICACHE	$tmp2
	SET_WBUFFER	$tmp2
        ; Cannot use Data Cache without MMU
    IF ENABLE_MMU = 1
	SET_DCACHE	$tmp2
    ENDIF
 ENDIF  ; CACHE_SUPPORTED

        ORR     $tmp1, $tmp1, $tmp2

 IF {ENDIAN} = "big"

	SET_BIGEND	$tmp1

 ENDIF  ; BIG_ENDIAN

	WRMMU_STATE	$tmp1		; Update MMU state

	NOP
	NOP
	NOP

	MOV	$tmp1, #6			; 110, RG-
	DO_DEBUG	$tmp1, $tmp2

	MEND

	; ---------------------------------------------------------------------
	; INITTIMER
	; ---------
	; This macro is provided purely as a holder for any code that
	; may be required to initialise a hardware timer as part of
	; the reset sequence. Angel does not need this; it initialises
	; any timer required in other ways.
	; However, under exceptional circumstances
	; special code may be required to ensure that Angel starts
	; cleanly and that later application specific code can have
	; full control of the timer.
	;
	MACRO
$label  INITTIMER	$w1, $w2
	; Last access to LEDs is here, turn them all off..
	MOV	$w1, #0
	SET_LEDS	$w1, $w2
	MEND

	; ---------------------------------------------------------------------
	; REVERSE
	; -------
	; Quick word byte-order reversal macro. Handy for endian stuff.
	MACRO
$label  REVERSE	$w1, $w2		; w1:	 D    C    B    A
	EOR	$w2, $w1, $w1, ROR #16	; w2:	D^B, C^A, B^D, A^C
	BIC	$w2, $w2, #0xff0000	; w2:	D^B,  0 , B^D, A^C
	MOV	$w1, $w1, ROR #8	; w1:	 A    D    C    B
	EOR	$w1, $w1, $w2, LSR #8	; w2>>8: 0   D^B   0   B^D
	MEND				; w1:	 A    B    C    D


	; ---------------------------------------------------------------------
	; GETSOURCE             ** ANGEL SPECIFIC **
	; ---------
	; This macro is used to read the current interrupt source
	; activity status for the Angel device driver interrupts.
	;
	; It can return (in $re):
	;
	;                  -1 - Ghost Interrupt (no Interrupt source active)
	; DE_NUM_INT_HANDLERS - Int. source not recognised
	;            IH_<xxx> - IntHandlerID (from devconf.h) of Interrupt source
	;

THREE_ARG_GETSOURCE	EQU 1

        MACRO
$label  GETSOURCE $re, $w1, $w2
	
	IF HANDLE_INTERRUPTS_ON_IRQ <> 0
GETSOURCE_OFFSET EQU IRQ_STATUS
	ENDIF

	IF HANDLE_INTERRUPTS_ON_FIQ <> 0
GETSOURCE_OFFSET EQU FIQ_STATUS
	ENDIF

$label	LDR	$w2, =INTEGRATOR_HDR_BASE

	;
	; If DCC is support then we need to read the core module interrupt
	; controller as this is where the DCC interrupt live.
	;
        IF DCC_SUPPORTED <> 0
	  LDR	$w1, [$w2, #(INTEGRATOR_HDR_IC_OFFSET+GETSOURCE_OFFSET)]
	  MOVS	$w1, $w1, LSL #INTEGRATOR_CM_INT0
	  BNE	%F1
	ENDIF

	;
	; Now we need to calculate the address of the system controller
	; interrupt controller for this header.
	;
	LDR	$w1, [$w2, #INTEGRATOR_HDR_STAT_OFFSET] ; Get contents of HDR_STAT
	LDR	$w2, =INTEGRATOR_IC_BASE	; Get base address of the interrupt controller
	AND	$w1, $w1, #3			; Mask off header number from HDR_STAT
	ADD	$w2, $w2, $w1, LSL #6		; Calculate address of IC
	LDR	$w1, [$w2, #GETSOURCE_OFFSET]	; Read interrupt status
1

	; set result to -1, so if no other result is set (& so have a ghost int)
	; we return -1 as required.
	MVN     $re, #0

	; Now test for specific interrupts. Interrupts tested for
	; later are given higher priority.
	IF TIMER_SUPPORTED <> 0
	  TST     $w1, #INTMASK_TIMERINT2
	  MOVNE   $re, #IH_TIMER
	ENDIF

	IF  (PCI_SUPPORTED > 0)
	  TST     $w1, #INTMASK_PCIINT0
	  MOVNE   $re, #IH_PCI0

	  TST     $w1, #INTMASK_PCIINT1
	  MOVNE   $re, #IH_PCI1

	  TST     $w1, #INTMASK_PCIINT2
	  MOVNE   $re, #IH_PCI2

	  TST     $w1, #INTMASK_PCIINT3
	  MOVNE   $re, #IH_PCI3
	ENDIF

	IF  ((AMBAUART_NUM_PORTS > 1) :LOR: (LOGTERM_DEBUGGING <> 0))
	  TST     $w1, #INTMASK_UARTINT1
	  MOVNE   $re, #IH_AMBAUART_B
	ENDIF

	TST     $w1, #INTMASK_UARTINT0
	MOVNE   $re, #IH_AMBAUART_A

        MEND


	; ---------------------------------------------------------------------
	; READ_INT
	; --------
	; uHAL macro to read which interrupt(s) is active (result in $w1)

	MACRO
$label  READ_INT	$w1, $w2, $w3

	;
	; First read the core module interrupt controller, if there are no outstanding
	; interrupt then go onto the system controller interrupt controller.
	;
	LDR	$w2, =INTEGRATOR_HDR_BASE
	LDR	$w1, [$w2, #(INTEGRATOR_HDR_IC_OFFSET+IRQ_STATUS)]
	MOVS	$w1, $w1, LSL #INTEGRATOR_CM_INT0
	BNE	%F1

	;
	; Now we need to calculate the address of the system controller
	; interrupt controller for this header.
	;
	LDR	$w1, [$w2, #INTEGRATOR_HDR_STAT_OFFSET] ; Get contents of HDR_STAT
	LDR	$w2, =INTEGRATOR_IC_BASE	; Get base address of the interrupt controller
	AND	$w1, $w1, #3			; Mask off header number from HDR_STAT
	LDR	$w1, [$w2, $w1, LSL #6]		; Read interrupts
	BIC	$w1, $w1, #((:NOT:INTEGRATOR_SC_VALID_INT) :AND: 0xFF000000) ; Clear non-valid bits
	BIC	$w1, $w1, #((:NOT:INTEGRATOR_SC_VALID_INT) :AND: 0x00FF0000) ; Clear non-valid bits
1

	MEND

	; ---------------------------------------------------------------------
	; CACHE_IBR             ** ANGEL SPECIFIC **
	; ---------
	; This macro implements an instruction barrier for a range of addresses
	; (i.e. it makes instruction and data memory coherent for this range) 
	; w1 contains the start of the range , w2 the next address after the end
	; Note that w1 will be corrupted

	MACRO
$label  CACHE_IBR	$w1, $w2, $temp, $temp2

  IF CACHE_SUPPORTED = 1
  	IMPORT	Angel_EnterSVC
  	IMPORT	Angel_ExitToUSR

        ASSERT  ( $w1 = r0 )

        ; Save old mode, protect lr from the SWI
        STMFD   sp!, {lr}
 
	BL	Angel_EnterSVC
        
        ; Clean the Dcache entries
1      
        WRCACHE_CleanDCentry $w1
        ADD     $w1, $w1, #32
        CMP     $w1, $w2
        BLT     %B1

        ; Drain the write buffer
        WRCACHE_DrainWriteBuffer $w1     

        ; Flush the Icache
        MOV     $w1, #0
        WRCACHE_FlushIC $w1

        ; Clear the pipeline..
        NOP
        NOP
        NOP
        
	BL	Angel_ExitToUSR

        ; Restore mode, lr
        LDMFD   sp!, {lr}

  ENDIF

	MEND



	MACRO
$label	DISABLE_INTS	$w1, $w2

	MOV	$w1, #7
	DO_DEBUG	$w1, $w2

	;
	; Ensure that all core module interrupts are disabled.
	;
	LDR	$w1, =INTEGRATOR_HDR_BASE
	LDR	$w2, =0xFFFFFFFF
	STR	$w2, [$w1, #(INTEGRATOR_HDR_IC_OFFSET+IRQ_ENABLE_CLEAR)]
	STR	$w2, [$w1, #(INTEGRATOR_HDR_IC_OFFSET+FIQ_ENABLE_CLEAR)]

	;
	; Now we need to calculate the address of the
	; interrupt controller for this header.
	;
	LDR	$w1, [$w1, #INTEGRATOR_HDR_STAT_OFFSET] ; Get contents of HDR_STAT
	LDR	$w2, =INTEGRATOR_IC_BASE	; Get base address of the interrupt controller
	AND	$w1, $w1, #3		; Mask off header number from HDR_STAT
	ADD	$w2, $w2, $w1, LSL #6	; Calculate address of interrupt controller

	LDR	$w1, =0xFFFFFFFF
	STR	$w1, [$w2, #IRQ_ENABLE_CLEAR]	; Clear all IRQ bits
	STR	$w1, [$w2, #FIQ_ENABLE_CLEAR]	; Clear all FIQ bits

	;
	; Explicitly disable the UARTs (COM1 and COM2) from interrupting
	; This code relies on the fact that all the UART registers are
	; mapped into seperate dwords.
	;
	LDR	$w1, =INTEGRATOR_UART0_BASE
	LDR	$w2, =0                 ; disable interrupt
	STRB	$w2, [$w1, #AMBA_UARTCR]

	LDR	$w1, =INTEGRATOR_UART1_BASE
	LDR	$w2, =0                 ; disable interrupt
	STRB	$w2, [$w1, #AMBA_UARTCR]

	MEND

	; ---------------------------------------------------------------------
	; uHAL macro to initialise external interrupts when running standalone

	MACRO
$label 	INIT_INTS	$w1, $w2, $w3

      IF :LNOT: :DEF: SEMIHOSTED

	DISABLE_INTS	$w1, $w2

      ENDIF

	MEND
	; ---------------------------------------------------------------------

	; ---------------------------------------------------------------------
	; Macro used for debugging without having target-specific code in uHAL

	MACRO
$label 	DO_DEBUG	$w1, $w2, $w3

 IF :DEF: DEBUG

	SET_LEDS	$w1, $w2	; Simple LED lighting 

 ENDIF

	MEND

	; ---------------------------------------------------------------------
	; macro to set the LEDs to the value given in $w1
	; NOTE: this should be the same as SetLEDs in driver.s

	MACRO
$label 	SET_LEDS	$w1, $w2

	;
	; Mask off any invalid bits
	;
	AND	$w1, $w1, #0xF 

	;
	; Poll the scan in progress bit
	;
	; If the H/W is in the process of writing to the LED's then writing
	; to the control register will screw things up
	;
1	LDR	$w2, =INTEGRATOR_DBG_BASE
	LDR	$w2, [$w2, #INTEGRATOR_DBG_ALPHA_OFFSET]
	TST	$w2, #1
	BNE	%B01

	;
	; Now write to the LED's
	;
	LDR	$w2, =INTEGRATOR_DBG_BASE
	STRB	$w1, [$w2, #INTEGRATOR_DBG_LEDS_OFFSET]

	MEND

	; ---------------------------------------------------------------------

	ENDIF	 ; INTEGRATOR_target_s

 IF :DEF: OPT
	OPT	(old_opt)	; restore previous listing options
 ENDIF

	; ---------------------------------------------------------------------
	END	; EOF target.s

