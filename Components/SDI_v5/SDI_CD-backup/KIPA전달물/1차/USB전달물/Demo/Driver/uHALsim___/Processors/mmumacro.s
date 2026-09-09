;/***************************************************************************
; * Copyright © ARM Limited 1998, 1999.  All rights reserved.
; ***************************************************************************/
;/*****************************************************************************
;
;   Generic aliases for COPROCESSOR access macros for ARM processors.
;
;	$Id: mmumacro.s,v 1.13.2.4 2000/02/02 12:14:25 asims Exp $
;
;******************************************************************************/

 IF :LNOT: :DEF: __mmumacros
__mmumacros             EQU     1

; Bit definitions are here
	INCLUDE	mmu_h.s

; Dummy macros for processors without MMU/MPU etc.
	INCLUDE	nommu.s

; NOTE: Most (all?) macros call the NO_* macro first. These macros must
;	be non-destructive on passed parameters, as one (or more) of
;	the processor-specific macros may be called next.

 IF :DEF: ARM7T
	INCLUDE	mmu7T.s
 ENDIF

 IF :DEF: ARM720T
	INCLUDE	mmu720T.s
 ENDIF

 IF :DEF: ARM740T
	INCLUDE	mmu740T.s
 ENDIF

 IF :DEF: ARM920T
	INCLUDE	mmu920T.s
 ENDIF

 IF :DEF: ARM940T
	INCLUDE	mmu940T.s
 ENDIF

 IF :DEF: ARM966T
	INCLUDE	mmu966T.s
 ENDIF

 IF :DEF: SA110
	INCLUDE	mmu110.s
 ENDIF

;------------------------------------------------------------------
;Macro to test that the given address has a 1-to-1 mapping between
;physical and virtual memory

	MACRO
	TEST_121MAP	$addr, $tmp1, $tmp2
	RDMMU_TTBase	$tmp1
	MOV	$tmp1, $tmp1, LSR #14		; Clear bottom 14 bits
	MOV	$tmp1, $tmp1, LSL #14
	ADD	$tmp2, $tmp1, $addr, LSR #(20-2)	; page table entry
	LDR	$tmp1, [$tmp2]			; read the entry
	MOV	$tmp2, $addr, LSR #20		; addr in MB
	SUBS	$tmp2, $tmp2, $tmp1, LSR #20	; entry in
	MEND

;------------------------------------------------------------------
; For executables which are linked for a different address to the
; physically executed address:
;
; Need to adjust from the linked address of the table to a relative
; offset from here. First, work out the offset from the RO$$Base,
; then find out how far we are from our actual start. Lastly, add
; the difference to the current pc.

	MACRO
	FIND_TABLEADDR	$tmp3, $tmp4, $addr
        LDR	$tmp4, =|Image$$RO$$Base| ; get linked location of code
	SUB	$addr, $addr, $tmp4	  ; A. table offset from start
        LDR	$tmp3, =%F79
	SUB	$tmp3, $tmp3, $tmp4	  ; B. Offset to next label
	SUB	$addr, $addr, $tmp3	  ; A-B
	; ----------------------------------------------------
	; Note: no more than 2 instructions between here and
	; the label.  Since pc is here + 8, add A-B to get
	; current table address
	MOV	$tmp3, pc
	ADD	$addr, $addr, $tmp3
79
	MEND

; Macro to read the MPU MappingTable and build the region, cache, buffer
; and permissions before setting up the MPU as required
;
	MACRO
	SETUP_MPU	$tmp1, $size, $tmp2, $tmp3, $tmp4, $addr, $offset

 IF :LNOT: :DEF: MPUMaptab
	IMPORT	MPUMaptab
 ENDIF

	; Flush MPU Map to invalid
	LDR	$tmp2, =MPUMaptab
	ADD	$tmp1, $tmp2, $offset	; Real address of Level1 TTB
	MOV	$tmp3, #0		; Invalid
	LDR	$tmp4, =MPU_TABLE_ENTRIES
70
	STR	$tmp3, [$tmp1], #4
	SUBS	$tmp4, $tmp4, #1	; decrement loop count
	BNE	%B70

	; If not executing from linked address, adjust $addr
	FIND_TABLEADDR	$tmp3, $tmp4, $addr

	ADD	$tmp1, $tmp2, $offset	; Real address of Mapping Table
71
	LDR	$offset, [$addr], #4	; Read the region
	LDR	$tmp2, [$addr], #4	; Base address
	LDR	$tmp3, [$addr], #4	; Area size

	CMP	$tmp3, #0		; All done if size is zero
	BEQ	%F74

	; Make sure address is correctly aligned (a multiple of size)
	MOV	$tmp4, #2
	MOV	$tmp4, $tmp4, LSL $tmp3
	SUB	$tmp4, $tmp4, #1
	ANDS	$tmp4, $tmp2, $tmp4
	BNE	%F80			; Failed, stop.

	; Build the region value, strip bottom 12 bits
	MOV	$tmp3, $tmp3, LSL #1	; Size is used x 2
	MOV	$tmp2, $tmp2, LSR #12
	MOV	$tmp2, $tmp2, LSL #12
	ADD	$tmp2, $tmp2, $tmp3	; Add in size
	ADD	$tmp2, $tmp2, #1	; Enable this region
	MOV	$tmp3, $offset, LSL #2	; Sotre in region * 4
	STR	$tmp2, [$tmp1, $tmp3]	; Save the region base address

	; Now add in access permissions for cache etc.
	LDR	$tmp4, [$addr], #4	; Access permissions
	MOV	$tmp4, $tmp4, LSR #2	; Access >> 2
	AND	$tmp3, $tmp4, #1
	MOV	$tmp2, $tmp3, LSL $offset
	LDR	$tmp3, [$tmp1, #MPU_BUFFER_OFFSET]
	ORR	$tmp2, $tmp2, $tmp3
	STR	$tmp2, [$tmp1, #MPU_BUFFER_OFFSET]
	MOV	$tmp4, $tmp4, LSR #1	; Access >> 3
	AND	$tmp3, $tmp4, #1
	MOV	$tmp2, $tmp3, LSL $offset
	LDR	$tmp3, [$tmp1, #MPU_CACHE_OFFSET]
	ORR	$tmp2, $tmp2, $tmp3
	STR	$tmp2, [$tmp1, #MPU_CACHE_OFFSET]
	MOV	$tmp4, $tmp4, LSR #7	; Access >> 10
	AND	$tmp3, $tmp4, #3
	MOV	$tmp3, $tmp3, LSL $offset
	MOV	$tmp2, $tmp3, LSL $offset	; region x 2
	LDR	$tmp3, [$tmp1, #MPU_ACCESS_OFFSET]
	ORR	$tmp2, $tmp2, $tmp3
	STR	$tmp2, [$tmp1, #MPU_ACCESS_OFFSET]

	B	%B71			; Next..

72	; MPU Mapping Table failure..
	B	.

74
	; The table is built, so now write the values to the MPU
	LDR	$tmp2, [$tmp1], #4
	WRMPU_Region	0, $tmp2
	LDR	$tmp2, [$tmp1], #4
	WRMPU_Region	1, $tmp2
	LDR	$tmp2, [$tmp1], #4
	WRMPU_Region	2, $tmp2
	LDR	$tmp2, [$tmp1], #4
	WRMPU_Region	3, $tmp2
	LDR	$tmp2, [$tmp1], #4
	WRMPU_Region	4, $tmp2
	LDR	$tmp2, [$tmp1], #4
	WRMPU_Region	5, $tmp2
	LDR	$tmp2, [$tmp1], #4
	WRMPU_Region	6, $tmp2
	LDR	$tmp2, [$tmp1], #4
	WRMPU_Region	7, $tmp2

 IF :DEF: ARM940T
	;
	; Convert any write back regions to write through.
	; See ARM940T Rev 1 Errata.
	;
	MRC	p15, 0, $tmp4, c0, c0, 0	; Read CPU ID
	LDR	$tmp3, =0x41029400		; Load the ARM940 ID
	BIC	$tmp2, $tmp4, #0xF		; Clear rev number
	CMP	$tmp2, $tmp3			; Is this really a ARM940T
	LDR	$tmp2, [$tmp1], #4		; Load cache bits
	LDR	$tmp3, [$tmp1], #4		; Load buffer bits
	BNE	%F75				; Skip if not a ARM940T
	AND	$tmp4, $tmp4, #0xF		; Get just the rev number
	CMP	$tmp4, #1			; Is this a Rev 1 ARM940T
	BGT	%F75				; Skip if later than a Rev 1 ARM940T
	AND	$tmp4, $tmp2, $tmp3		; Find the write back regions
	EOR	$tmp3, $tmp3, $tmp4		; And convert them to write through
75
 ELSE
	LDR	$tmp2, [$tmp1], #4		; Load cache bits
	LDR	$tmp3, [$tmp1], #4		; Load buffer bits
 ENDIF

	WRMPU_CacheBits		$tmp2
	WRMPU_BufferBits	$tmp3

	LDR	$tmp2, [$tmp1]
	WRMPU_AccessBits	$tmp2

	MEND
	
; Simple macro to clear all page table entries.
;
	MACRO
$label  INIT_PGTABLE	$count, $val, $ptr, $offset
	LDR	$ptr, =Level2tab_ROM
	ADD	$ptr, $ptr, $offset	; Real address of Level2 TTB
	LDR	$count, =L2_TABLE_ENTRIES
	CMP	$count, #0		; Check for no Level2 table
	BEQ	%F77

	LDR	$val, =L2_ENTRY_SIZE
	MUL	$count, $val, $count
	MOV	$val, #0		; Invalid
76
	STR	$val, [$ptr], #4
	SUBS	$count, $count, #1	; decrement loop count
	BGE	%B76
77
	LDR	$ptr, =Level1tab
	ADD	$ptr, $ptr, $offset	; Real address of Level1 TTB
	MOV	$val, #0		; Invalid
	LDR	$count, =L1_TABLE_ENTRIES
78
	STR	$val, [$ptr], #4
	SUBS	$count, $count, #1	; decrement loop count
	BGE	%B78

	MEND

; Build a page table from the supplied address map table.
;
; $tmp2		size of memory If this platform supports auto-memory sizing
; $addr		pointer to memory map table
; $offset	offset between physical addr & virtual addr of TTBs
;
	MACRO
$label  BUILD_PGTABLE	$tmp1, $tmp2, $tmp3, $tmp4, $tmp5, $addr, $offset

	; ----------------------------------------------------
	; First clear all TT entries - FAULT
	; ----------------------------------------------------
	INIT_PGTABLE	$tmp3, $tmp4, $tmp5, $offset

	; If not executing from linked address, adjust $addr
	FIND_TABLEADDR	$tmp3, $tmp4, $addr

	; ----------------------------------------------------
	; Check $size parameter.
	; If non-zero, size of first memory area is taken from
	; target-specific memory sizing code rather than $size
	CMP	$tmp2, #0
	BEQ	%F81		; Not autosizing, read all params

	; ----------------------------------------------------
	; Make sure given memory size is a multiple of 1MB
	; tmp3 is no. of 1MB segments
	MOV	$tmp3, $tmp2, LSR #20
	MOV	$tmp4, $tmp3, LSL #20
	CMP	$tmp4, $tmp2
	ADDNE	$tmp3, $tmp3, #1

	; Read 1st Entry from MMU table seperately to allow
	; memory sizing.
	; NOTE: 1st entry cannot abort & can't be Level2 !!
	LDR	$tmp4, =Level1tab
	ADD	$tmp4, $tmp4, $offset

	; Virtual base address -> Level1 offset in tmp2
	LDR	$tmp5, [$addr], #4
	ADD	$tmp2, $tmp4, $tmp5, LSR #(20-2)

	; Physical base address -> tmp4
	LDR	$tmp1, [$addr], #4
	; Access permissions etc -> tmp3 (NOTE: Size is skipped!)
	LDR	$tmp5, [$addr], #8

	CMP	$tmp5, #0
	BEQ	%F80			; Halt if access is zero

	TST	$tmp1, #PT_PAGE
	BNE	%F80			; Halt if Level2 table

	ADD	$tmp1, $tmp1, $tmp5	; Level1 Table Entry

	; Registers set, so build 1st entry & rest of TLB.
	B	%F83

	; All causes for error end up here
80	
 IF :DEF: ARM7T
	B	%F90			; No Page Table if no MMU
 ENDIF
	B	.

81
	LDR	$tmp4, =Level1tab
	ADD	$tmp4, $tmp4, $offset
82
	; Calculate offset to virtual base address entry -> tmp2
	LDR	$tmp1, [$addr], #4	; Virtual address
	ADD	$tmp2, $tmp4, $tmp1, LSR #(20-2)

	; Physical base address -> tmp1
	LDR	$tmp1, [$addr], #4
	; Access permissions etc -> tmp3
	LDR	$tmp3, [$addr], #4
	CMP	$tmp3, #0		; All done if access is zero
	BEQ	%F90

	TST	$tmp1, #PT_PAGE		; Check for Level2 table
	BNE	%F84			; Yes, do it

	; ----------------------------------------------------
	; Level 1 Entries, calculate size & fill table
	; ----------------------------------------------------
	ADD	$tmp1, $tmp1, $tmp3	; Level1 Table Entry
	LDR	$tmp3, [$addr], #4	; area size
	MOV	$tmp3, $tmp3, LSR #20	; no. of 1MB segments
83
	STR	$tmp1, [$tmp2], #4	; store Table Entry
	ADD	$tmp1, $tmp1, #SZ_1M	; add section number field
	SUBS	$tmp3, $tmp3, #1	; decrement loop count
	BGT	%B83
	B	%B82			; Repeat until done

84
	; Convert logical addresses to real addresses
	ADD	$tmp1, $tmp1, $offset	; Pointer to Level2 table

	; ----------------------------------------------------
	; Check for Fine table and process seperately
	; ----------------------------------------------------
	TST	$tmp3, #(PT_FINE - PT_PAGE)
	; Read size!
	LDR	$tmp5, [$addr], #4
	BIC	$tmp4, $tmp1, #0x0ff
	BNE	%F87

	; ----------------------------------------------------
	; Large Level2: Strip address of Level2 Table -> tmp4
	; ----------------------------------------------------
	BIC	$tmp4, $tmp4, #0x0300

	MOV	$tmp5, $tmp5, LSR #16	; no. of 64KB segments
	MOV	$tmp5, $tmp5, LSL #4	; no. of 4KB aliases
85
	STR	$tmp1, [$tmp2], #4	; Level1 points to Level2 entry
86
	; Add each entry aliased 16 times (64KB/4KB, so $tmp3 & 0xF == 0)
	STR	$tmp3, [$tmp4], #4	; store large L2 TT entry
	SUB	$tmp5, $tmp5, #1	; decrement page count
	TST	$tmp5, #0xF
	BNE	%B86			; upto 16 L2 entries

	; Add 16 L2 entries per L1 entry  (1MB/64KB, so $tmp3 & 0xF0 == 0)
	ADD	$tmp3, $tmp3, #SZ_64K	; next page field
	TST	$tmp5, #0xf0
	BNE	%B86			; upto 16 L2 entries

	CMP	$tmp5, #0		; All done?
	ADD	$tmp1, $tmp1, #0x400	; Next 1MB is 256 entries further down
	BNE	%B85			; No, do another L1 entry.
	B	%B81
87
	; ----------------------------------------------------
	; Fine Level2: Strip address of Level2 Table -> tmp4
	; ----------------------------------------------------
	BIC	$tmp4, $tmp4, #0x0f00

	MOV	$tmp5, $tmp5, LSR #16	; no. of 64KB segments
	MOVEQ	$tmp5, $tmp5, LSL #8	; no. of 1KB aliases
	MOVNE	$tmp5, $tmp5, LSL #4	; no. of 4KB aliases
88
	STR	$tmp1, [$tmp2], #4	; Level1 points to Level2 entry
89
	STR	$tmp3, [$tmp4], #4	; store fine L2 TT entry
	SUBS	$tmp5, $tmp5, #1	; decrement page count
	ADD	$tmp3, $tmp3, #SZ_1K	; next page field
	TST	$tmp5, #0x0ff
	BNE	%B89			; 4 x 256 L2 entries
	TST	$tmp5, #0x300
	BNE	%B89			; 3ff won't fit inside an instruction

	CMP	$tmp5, #0		; All done?
	ADD	$tmp1, $tmp1, #0x4000	; Next 1MB is 1K entries further down
	BNE	%B88			; No, do another L1 entry.
	B	%B81
90
	MEND
;------------------------------------------------------------------
;	Compulsory Macros:
;
; These are the macros which must be defined, even for processors
; without any memory management capabilities.
;
; CHECK_FOR_MMU	- return TRUE if CPU has an MMU
; CHECK_FOR_MPU	- return TRUE if CPU has an MPU
; CHECK_CACHE	- return TRUE if CPU has a Cache
; CHECK_UNIFIED	- return TRUE if CPU has a Unified Cache
; CHECK_CPUID	- return TRUE if CPU matches the expected ID
; CHECK_VENDOR	- return TRUE if CPU matches the expected Vendor ID

	MACRO
	CHECK_FOR_MMU	$reg
	NO_CHECK_FOR_MMU	$reg
 IF :DEF: ARM7T
	CHECK_FOR_MMU_7T	$reg
 ENDIF
 IF :DEF: ARM720T
	CHECK_FOR_MMU_720T	$reg
 ENDIF
 IF :DEF: ARM740T
	CHECK_FOR_MMU_740T	$reg
 ENDIF
 IF :DEF: ARM920T
	CHECK_FOR_MMU_920T	$reg
 ENDIF
 IF :DEF: ARM940T
	CHECK_FOR_MMU_940T	$reg
 ENDIF
 IF :DEF: SA110
	CHECK_FOR_MMU_110	$reg
 ENDIF
	MEND

;Macro to signal if this processor has an MPU
;
	MACRO
	CHECK_FOR_MPU	$reg
	NO_CHECK_FOR_MPU	$reg
 IF :DEF: ARM7T
	CHECK_FOR_MPU_7T	$reg
 ENDIF
 IF :DEF: ARM720T
	CHECK_FOR_MPU_720T	$reg
 ENDIF
 IF :DEF: ARM740T
	CHECK_FOR_MPU_740T	$reg
 ENDIF
 IF :DEF: ARM920T
	CHECK_FOR_MPU_920T	$reg
 ENDIF
 IF :DEF: ARM940T
	CHECK_FOR_MPU_940T	$reg
 ENDIF
 IF :DEF: SA110
	CHECK_FOR_MPU_110	$reg
 ENDIF
	MEND

;Macro to signal if this processor has a Cache
;
	MACRO
	CHECK_CACHE	$reg
	NO_CHECK_CACHE	$reg
 IF :DEF: ARM7T
	CHECK_CACHE_7T	$reg
 ENDIF
 IF :DEF: ARM720T
	CHECK_CACHE_720T	$reg
 ENDIF
 IF :DEF: ARM740T
	CHECK_CACHE_740T	$reg
 ENDIF
 IF :DEF: ARM920T
	CHECK_CACHE_920T	$reg
 ENDIF
 IF :DEF: ARM940T
	CHECK_CACHE_940T	$reg
 ENDIF
 IF :DEF: SA110
	CHECK_CACHE_110	$reg
 ENDIF
	MEND

;Macro to signal if this processor has a unified cache
;
	MACRO
	CHECK_UNIFIED	$reg
	NO_CHECK_UNIFIED	$reg
 IF :DEF: ARM7T
	CHECK_UNIFIED_7T	$reg
 ENDIF
 IF :DEF: ARM720T
	CHECK_UNIFIED_720T	$reg
 ENDIF
 IF :DEF: ARM740T
	CHECK_UNIFIED_740T	$reg
 ENDIF
 IF :DEF: ARM920T
	CHECK_UNIFIED_920T	$reg
 ENDIF
 IF :DEF: ARM940T
	CHECK_UNIFIED_940T	$reg
 ENDIF
 IF :DEF: SA110
	CHECK_UNIFIED_110	$reg
 ENDIF
	MEND

	MACRO
	CHECK_CPUID	$reg, $ret
	NO_CHECK_CPUID	$reg, $ret
 IF :DEF: ARM7T
	CHECK_CPUID_7T	$reg, $ret
 ENDIF
 IF :DEF: ARM720T
	CHECK_CPUID_720T	$reg, $ret
 ENDIF
 IF :DEF: ARM740T
	CHECK_CPUID_740T	$reg, $ret
 ENDIF
 IF :DEF: ARM920T
	CHECK_CPUID_920T	$reg, $ret
 ENDIF
 IF :DEF: ARM940T
	CHECK_CPUID_940T	$reg, $ret
 ENDIF
 IF :DEF: ARM966T
	CHECK_CPUID_966T	$reg, $ret
 ENDIF
 IF :DEF: SA110
	CHECK_CPUID_110	$reg, $ret
 ENDIF
	MEND

	MACRO
	CHECK_VENDOR	$reg, $ret
	NO_CHECK_VENDOR	$reg, $ret
 IF :DEF: ARM7T
	CHECK_VENDOR_7T	$reg, $ret
 ENDIF
 IF :DEF: ARM720T
	CHECK_VENDOR_720T	$reg, $ret
 ENDIF
 IF :DEF: ARM740T
	CHECK_VENDOR_740T	$reg, $ret
 ENDIF
 IF :DEF: ARM920T
	CHECK_VENDOR_920T	$reg, $ret
 ENDIF
 IF :DEF: ARM940T
	CHECK_VENDOR_940T	$reg, $ret
 ENDIF
 IF :DEF: ARM966T
	CHECK_VENDOR_966T	$reg, $ret
 ENDIF
 IF :DEF: SA110
	CHECK_VENDOR_110	$reg, $ret
 ENDIF
	MEND

;------------------------------------------------------------------
; Macros to hide internals of each processor's cache implementation
;
; Never set coprocessor bits directly, use the macros. To use:
;	RDMMU_STATE	$reg	; read the flags
;	CLEAR_IDC	$reg	; disable I & D caches
;	SET_MMU		$reg	; enable MMU
;	WRMMU_STATE	$reg	; update the coprocessor
;
; CLEAR_IDC	Clear Instruction & Data Cache Bits (& Write Buffer)
; CLEAR_ICACHE	Clear (at least) Instruction Cache Bits
; CLEAR_DCACHE	Clear (at least) Data Cache Bits
; CLEAR_WBUFFER	Clear Write Buffer Bits
; CLEAR_MMU	Clear MMU Enable Bits
; CLEAR_BIGEND	Clear Big Endian Enable Bits
; CLEAR_IMEM	Clear On Chip Instruction Memory Enable Bit
; CLEAR_DMEM	Clear On Chip Data Memory Enable Bit	
; SET_IDC	As above, but Set each mode
; SET_ICACHE
; SET_DCACHE
; SET_WBUFFER
; SET_MMU
; SET_BIGEND
; SET_IMEM
; SET_DMEM
; TEST_MMU	Simple tests to see if bits are already set
; TEST_BIGEND

	MACRO
	CLEAR_IDC	$state
	NO_CLEAR_IDC	$state
 IF :DEF: ARM720T
	CLEAR_IDC_720T	$state
 ENDIF
 IF :DEF: ARM740T
	CLEAR_IDC_740T	$state
 ENDIF
 IF :DEF: ARM920T
	CLEAR_IDC_920T	$state
 ENDIF
 IF :DEF: ARM940T
	CLEAR_IDC_940T	$state
 ENDIF
 IF :DEF: SA110
	CLEAR_IDC_110	$state
 ENDIF
	MEND

	MACRO
	CLEAR_ICACHE	$state
	NO_CLEAR_ICACHE	$state
 IF :DEF: ARM720T
	CLEAR_ICACHE_720T	$state
 ENDIF
 IF :DEF: ARM740T
	CLEAR_ICACHE_740T	$state
 ENDIF
 IF :DEF: ARM920T
	CLEAR_ICACHE_920T	$state
 ENDIF
 IF :DEF: ARM940T
	CLEAR_ICACHE_940T	$state
 ENDIF
 IF :DEF: SA110
	CLEAR_ICACHE_110	$state
 ENDIF
	MEND

	MACRO
	CLEAR_DCACHE	$state
	NO_CLEAR_DCACHE	$state
 IF :DEF: ARM720T
	CLEAR_DCACHE_720T	$state
 ENDIF
 IF :DEF: ARM740T
	CLEAR_DCACHE_740T	$state
 ENDIF
 IF :DEF: ARM920T
	CLEAR_DCACHE_920T	$state
 ENDIF
 IF :DEF: ARM940T
	CLEAR_DCACHE_940T	$state
 ENDIF
 IF :DEF: SA110
	CLEAR_DCACHE_110	$state
 ENDIF
	MEND

	MACRO
	CLEAR_WBUFFER	$state
	NO_CLEAR_WBUFFER	$state
 IF :DEF: ARM720T
	CLEAR_WBUFFER_720T	$state
 ENDIF
 IF :DEF: ARM740T
	CLEAR_WBUFFER_740T	$state
 ENDIF
 IF :DEF: SA110
	CLEAR_WBUFFER_110	$state
 ENDIF
	MEND

	MACRO
	CLEAR_MMU	$state
	NO_CLEAR_MMU	$state
 IF :DEF: ARM720T
	CLEAR_MMU_720T	$state
 ENDIF
 IF :DEF: ARM740T
	CLEAR_MMU_740T	$state
 ENDIF
 IF :DEF: ARM920T
	CLEAR_MMU_920T	$state
 ENDIF
 IF :DEF: ARM940T
	CLEAR_MMU_940T	$state
 ENDIF
 IF :DEF: SA110
	CLEAR_MMU_110	$state
 ENDIF
	MEND

	MACRO
	CLEAR_BIGEND	$state
	NO_CLEAR_BIGEND	$state
 IF :DEF: ARM720T
	CLEAR_BIGEND_720T	$state
 ENDIF
 IF :DEF: ARM740T
	CLEAR_BIGEND_740T	$state
 ENDIF
 IF :DEF: ARM920T
	CLEAR_BIGEND_920T	$state
 ENDIF
 IF :DEF: ARM940T
	CLEAR_BIGEND_940T	$state
 ENDIF
 IF :DEF: SA110
	CLEAR_BIGEND_110	$state
 ENDIF
	MEND

	MACRO
	CLEAR_IMEM	$state
 IF :DEF: ARM966T
	CLEAR_IMEM_966T	$state
 ENDIF
	MEND

	MACRO
	CLEAR_DMEM	$state
 IF :DEF: ARM966T
	CLEAR_DMEM_966T	$state
 ENDIF
	MEND

	MACRO
	SET_IDC	$state
	NO_SET_IDC	$state
 IF :DEF: ARM720T
	SET_IDC_720T	$state
 ENDIF
 IF :DEF: ARM740T
	SET_IDC_740T	$state
 ENDIF
 IF :DEF: ARM920T
	SET_IDC_920T	$state
 ENDIF
 IF :DEF: ARM940T
	SET_IDC_940T	$state
 ENDIF
 IF :DEF: SA110
	SET_IDC_110	$state
 ENDIF
	MEND

	MACRO
	SET_ICACHE	$state
	NO_SET_ICACHE	$state
 IF :DEF: ARM720T
	SET_ICACHE_720T	$state
 ENDIF
 IF :DEF: ARM740T
	SET_ICACHE_740T	$state
 ENDIF
 IF :DEF: ARM920T
	SET_ICACHE_920T	$state
 ENDIF
 IF :DEF: ARM940T
	SET_ICACHE_940T	$state
 ENDIF
 IF :DEF: SA110
	SET_ICACHE_110	$state
 ENDIF
	MEND

	MACRO
	SET_DCACHE	$state
	NO_SET_DCACHE	$state
 IF :DEF: ARM720T
	SET_DCACHE_720T	$state
 ENDIF
 IF :DEF: ARM740T
	SET_DCACHE_740T	$state
 ENDIF
 IF :DEF: ARM920T
	SET_DCACHE_920T	$state
 ENDIF
 IF :DEF: ARM940T
	SET_DCACHE_940T	$state
 ENDIF
 IF :DEF: SA110
	SET_DCACHE_110	$state
 ENDIF
	MEND

	MACRO
	SET_WBUFFER	$state
	NO_SET_WBUFFER	$state
 IF :DEF: ARM720T
	SET_WBUFFER_720T	$state
 ENDIF
 IF :DEF: ARM740T
	SET_WBUFFER_740T	$state
 ENDIF
 IF :DEF: SA110
	SET_WBUFFER_110	$state
 ENDIF
	MEND

	MACRO
	SET_MMU	$state
	NO_SET_MMU	$state
 IF :DEF: ARM720T
	SET_MMU_720T	$state
 ENDIF
 IF :DEF: ARM920T
	SET_MMU_920T	$state
 ENDIF
 IF :DEF: SA110
	SET_MMU_110	$state
 ENDIF
	MEND

	MACRO
	SET_BIGEND	$state
	NO_SET_BIGEND	$state
 IF :DEF: ARM720T
	SET_BIGEND_720T	$state
 ENDIF
 IF :DEF: ARM740T
	SET_BIGEND_740T	$state
 ENDIF
 IF :DEF: ARM920T
	SET_BIGEND_920T	$state
 ENDIF
 IF :DEF: ARM940T
	SET_BIGEND_940T	$state
 ENDIF
 IF :DEF: SA110
	SET_BIGEND_110	$state
 ENDIF
	MEND

	MACRO
	SET_IMEM	$state
 IF :DEF: ARM966T
	SET_IMEM_966T	$state
 ENDIF
	MEND

	MACRO
	SET_DMEM	$state
 IF :DEF: ARM966T
	SET_DMEM_966T	$state
 ENDIF
	MEND

	MACRO
	TEST_MMU	$state
	NO_TEST_MMU	$state
 IF :DEF: ARM720T
	TEST_MMU_720T	$state
 ENDIF
 IF :DEF: ARM740T
	TEST_MMU_740T	$state
 ENDIF
 IF :DEF: ARM920T
	TEST_MMU_920T	$state
 ENDIF
 IF :DEF: ARM940T
	TEST_MMU_940T	$state
 ENDIF
 IF :DEF: SA110
	TEST_MMU_110	$state
 ENDIF
	MEND

	MACRO
	TEST_BIGEND	$state
	NO_TEST_BIGEND	$state
 IF :DEF: ARM720T
	TEST_BIGEND_720T	$state
 ENDIF
 IF :DEF: ARM740T
	TEST_BIGEND_740T	$state
 ENDIF
 IF :DEF: ARM920T
	TEST_BIGEND_920T	$state
 ENDIF
 IF :DEF: ARM940T
	TEST_BIGEND_940T	$state
 ENDIF
 IF :DEF: SA110
	TEST_BIGEND_110	$state
 ENDIF
	MEND

;------------------------------------------------------------------
;Read CPU Code (ID, Vendor revision etc.) register 
;
	MACRO
	REALLY_RDCPU_CODE	$val
	MRC p15, 0, $val, c0, c0 ,0
	MEND

	MACRO
	RDCPU_CODE	$val
	NO_RDCPU_CODE	$val
 IF :DEF: ARM720T
	RDCPU_CODE_720T	$val
 ENDIF
 IF :DEF: ARM740T
	RDCPU_CODE_740T	$val
 ENDIF
 IF :DEF: ARM920T
	RDCPU_CODE_920T	$val
 ENDIF
 IF :DEF: ARM940T
	RDCPU_CODE_940T	$val
 ENDIF
 IF :DEF: SA110
	RDCPU_CODE_110	$val
 ENDIF
	MEND

;Extract CPU ID from CPU Code register
;
	MACRO
	RDCPU_ID	$w1, $val
	NO_RDCPU_ID	$w1, $val
 IF :DEF: ARM720T
	RDCPU_ID_720T	$w1, $val
 ENDIF
 IF :DEF: ARM740T
	RDCPU_ID_740T	$w1, $val
 ENDIF
 IF :DEF: ARM920T
	RDCPU_ID_920T	$w1, $val
 ENDIF
 IF :DEF: ARM940T
	RDCPU_ID_940T	$w1, $val
 ENDIF
 IF :DEF: SA110
	RDCPU_ID_110	$w1, $val
 ENDIF
	MEND

;Extract CPU Vendor from CPU Code register
;
	MACRO
	RDCPU_VENDOR	$w1, $val
	NO_RDCPU_VENDOR	$w1, $val
 IF :DEF: ARM720T
	RDCPU_VENDOR_720T	$w1, $val
 ENDIF
 IF :DEF: ARM740T
	RDCPU_VENDOR_740T	$w1, $val
 ENDIF
 IF :DEF: ARM920T
	RDCPU_VENDOR_920T	$w1, $val
 ENDIF
 IF :DEF: ARM940T
	RDCPU_VENDOR_940T	$w1, $val
 ENDIF
 IF :DEF: SA110
	RDCPU_VENDOR_110	$w1, $val
 ENDIF
	MEND

;Coprocessor read of ID register (cache line sizes)
;
	MACRO
	RDCACHE_SIZES	$reg_number
	NO_RDCACHE_SIZES	$reg_number
 IF :DEF: ARM920T
	RDCACHE_SIZES_920T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	RDCACHE_SIZES_940T	$reg_number
 ENDIF
	MEND

;Coprocessor read of Control register 
;
	MACRO
	RDMMU_STATE	$reg_number
	NO_RDMMU_STATE	$reg_number
 IF :DEF: ARM720T
	RDMMU_STATE_720T	$reg_number
 ENDIF
 IF :DEF: ARM740T
	RDMMU_STATE_740T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	RDMMU_STATE_920T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	RDMMU_STATE_940T	$reg_number
 ENDIF
 IF :DEF: SA110
	RDMMU_STATE_110	$reg_number
 ENDIF
	MEND

;Coprocessor write of Control register 
;
	MACRO 
	WRMMU_STATE	$reg_number
	NO_WRMMU_STATE	$reg_number
 IF :DEF: ARM720T
	WRMMU_STATE_720T	$reg_number
 ENDIF
 IF :DEF: ARM740T
	WRMMU_STATE_740T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	WRMMU_STATE_920T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	WRMMU_STATE_940T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRMMU_STATE_110	$reg_number
 ENDIF
	MEND

;------------------------------------------------------------------
;Coprocessor read of Translation Table Base reg. 
;
	MACRO
	RDMMU_TTBase	$reg_number
	NO_RDMMU_TTBase	$reg_number
 IF :DEF: ARM720T
	RDMMU_TTBase_720T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	RDMMU_TTBase_920T	$reg_number
 ENDIF
 IF :DEF: SA110
	RDMMU_TTBase_110	$reg_number
 ENDIF
	MEND

;Coprocessor write of Translation Table Base reg. 
;
	MACRO 
	WRMMU_TTBase	$reg_number
	NO_WRMMU_TTBase	$reg_number
 IF :DEF: ARM720T
	WRMMU_TTBase_720T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	WRMMU_TTBase_920T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRMMU_TTBase_110	$reg_number
 ENDIF
	MEND

;Coprocessor read of Domain Access Control reg. 
;
	MACRO
	RDMMU_DAControl	$reg_number
	NO_RDMMU_DAControl	$reg_number
 IF :DEF: ARM720T
	RDMMU_DAControl_720T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	RDMMU_DAControl_920T	$reg_number
 ENDIF
 IF :DEF: SA110
	RDMMU_DAControl_110	$reg_number
 ENDIF
	MEND

;Coprocessor write of Domain Access Control reg. 
;
	MACRO 
	WRMMU_DAControl	$reg_number
	NO_WRMMU_DAControl	$reg_number
 IF :DEF: ARM720T
	WRMMU_DAControl_720T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	WRMMU_DAControl_920T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRMMU_DAControl_110	$reg_number
 ENDIF
	MEND

;Coprocessor read of Fault Status register 
;
    MACRO
    RDMMU_FaultStatus	$reg
    NO_RDMMU_FaultStatus	$reg
 IF :DEF: ARM720T
    RDMMU_FaultStatus_720	$reg
 ENDIF
 IF :DEF: ARM920T
    RDMMU_FaultStatus_920	$reg
 ENDIF
 IF :DEF: SA110
    RDMMU_FaultStatus_110	$reg
 ENDIF
    MEND

;Coprocessor write of Fault Status register 
;
    MACRO 
    WRMMU_FaultStatus	$reg
    NO_WRMMU_FaultStatus	$reg
 IF :DEF: ARM720T
    WRMMU_FaultStatus_720T	$reg
 ENDIF
 IF :DEF: ARM920T
    WRMMU_FaultStatus_920T	$reg
 ENDIF
 IF :DEF: SA110
    WRMMU_FaultStatus_110	$reg
 ENDIF
    MEND

;Coprocessor read of Fault Address register 
;
    MACRO
    RDMMU_FaultAddress	$reg
    NO_RDMMU_FaultAddress	$reg
 IF :DEF: ARM720T
    RDMMU_FaultAddress_720T	$reg
 ENDIF
 IF :DEF: ARM920T
    RDMMU_FaultAddress_920T	$reg
 ENDIF
 IF :DEF: SA110
    RDMMU_FaultAddress_110	$reg
 ENDIF
    MEND

;Coprocessor write of Fault Address register 
;
    MACRO 
    WRMMU_FaultAddress	$reg
    NO_WRMMU_FaultAddress	$reg
 IF :DEF: ARM720T
    WRMMU_FaultAddress_720T	$reg
 ENDIF
 IF :DEF: ARM920T
    WRMMU_FaultAddress_920T	$reg
 ENDIF
 IF :DEF: SA110
    WRMMU_FaultAddress_110	$reg
 ENDIF
    MEND

;Flush TLB 
;
	MACRO
	WRMMU_FlushTB	$reg_number
	NO_WRMMU_FlushTB	$reg_number
 IF :DEF: ARM720T
	WRMMU_FlushTB_720T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	WRMMU_FlushTB_920T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRMMU_FlushTB_110	$reg_number
 ENDIF
	MEND

;Flush Instruction TLB 
;
	MACRO
	WRMMU_FlushITB	$reg_number
	NO_WRMMU_FlushITB	$reg_number
 IF :DEF: ARM720T
	WRMMU_FlushITB_720T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	WRMMU_FlushITB_920T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRMMU_FlushITB_110	$reg_number
 ENDIF
	MEND

;Flush Data TLB
;
	MACRO
	WRMMU_FlushDTB	$reg_number
	NO_WRMMU_FlushDTB	$reg_number
 IF :DEF: ARM720T
	WRMMU_FlushDTB_720T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	WRMMU_FlushDTB_920T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRMMU_FlushDTB_110	$reg_number
 ENDIF
	MEND

;-----------------------------------------------------------
; MPU support macros:

;Coprocessor write of MPU cache bits 
;
	MACRO 
	WRMPU_CacheBits	$reg_number
	NO_WRMPU_CacheBits	$reg_number
 IF :DEF: ARM740T
	WRMPU_CacheBits_740T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	WRMPU_CacheBits_940T	$reg_number
 ENDIF
	MEND

;Coprocessor write of MPU buffer bits 
;
	MACRO 
	WRMPU_BufferBits	$reg_number
	NO_WRMPU_BufferBits	$reg_number
 IF :DEF: ARM740T
	WRMPU_BufferBits_740T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	WRMPU_BufferBits_940T	$reg_number
 ENDIF
	MEND

;Coprocessor write of MPU access bits 
;
	MACRO 
	WRMPU_AccessBits	$reg_number
	NO_WRMPU_AccessBits	$reg_number
 IF :DEF: ARM740T
	WRMPU_AccessBits_740T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	WRMPU_AccessBits_940T	$reg_number
 ENDIF
	MEND

;Coprocessor write of MPU region registors 
;
	MACRO 
	WRMPU_Region	$region, $reg_number
	NO_WRMPU_Region	$region, $reg_number
 IF :DEF: ARM740T
	WRMPU_Region_740T	$region, $reg_number
 ENDIF
 IF :DEF: ARM940T
	WRMPU_Region_940T	$region, $reg_number
 ENDIF
	MEND

;-----------------------------------------------------------
;Coprocessor cache control 
;Flush I & D Caches
;
	MACRO 
	WRCACHE_FlushIDC	$reg_number
	NO_WRCACHE_FlushIDC	$reg_number
 IF :DEF: ARM720T
	WRCACHE_FlushIDC_720T	$reg_number
 ENDIF
 IF :DEF: ARM740T
	WRCACHE_FlushIDC_740T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	WRCACHE_FlushIDC_920T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	WRCACHE_FlushIDC_940T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRCACHE_FlushIDC_110	$reg_number
 ENDIF
	MEND

;Coprocessor cache control 
;Flush ICache
;
	MACRO 
	WRCACHE_FlushIC	$reg_number
	NO_WRCACHE_FlushIC	$reg_number
 IF :DEF: ARM720T
	WRCACHE_FlushIC_720T	$reg_number
 ENDIF
 IF :DEF: ARM740T
	WRCACHE_FlushIC_740T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	WRCACHE_FlushIC_920T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	WRCACHE_FlushIC_940T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRCACHE_FlushIC_110	$reg_number
 ENDIF
	MEND

;Coprocessor cache control 
;Flush DCache
;
	MACRO 
	WRCACHE_FlushDC	$reg_number
	NO_WRCACHE_FlushDC	$reg_number
 IF :DEF: ARM720T
	WRCACHE_FlushDC_720T	$reg_number
 ENDIF
 IF :DEF: ARM740T
	WRCACHE_FlushDC_740T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	WRCACHE_FlushDC_920T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	WRCACHE_FlushDC_940T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRCACHE_FlushDC_110	$reg_number
 ENDIF
	MEND

;Coprocessor cache control 
;Flush DCache entry
;
	MACRO 
	WRCACHE_CacheFlushDentry	$reg_number
	NO_WRCACHE_CacheFlushDentry	$reg_number
 IF :DEF: ARM720T
	WRCACHE_CacheFlushDentry_720T	$reg_number
 ENDIF
 IF :DEF: ARM740T
	WRCACHE_CacheFlushDentry_740T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	WRCACHE_CacheFlushDentry_920T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	WRCACHE_CacheFlushDentry_940T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRCACHE_CacheFlushDentry_110	$reg_number
 ENDIF
	MEND

;Coprocessor cache control 
;Clean DCache entry
;
	MACRO 
	WRCACHE_CleanDCentry	$reg_number
	NO_WRCACHE_CleanDCentry	$reg_number
 IF :DEF: ARM720T
	WRCACHE_CleanDCentry_720T	$reg_number
 ENDIF
 IF :DEF: ARM740T
	WRCACHE_CleanDCentry_740T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	WRCACHE_CleanDCentry_920T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	WRCACHE_CleanDCentry_940T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRCACHE_CleanDCentry_110	$reg_number
 ENDIF
	MEND

;Coprocessor cache control 
;Clean + Flush DCache entry
;
	MACRO 
	WRCACHE_Clean_FlushDCentry	$reg_number
	NO_WRCACHE_Clean_FlushDCentry	$reg_number
 IF :DEF: ARM720T
	WRCACHE_Clean_FlushDCentry_720T	$reg_number
 ENDIF
 IF :DEF: ARM740T
	WRCACHE_Clean_FlushDCentry_740T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	WRCACHE_Clean_FlushDCentry_920T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	WRCACHE_Clean_FlushDCentry_940T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRCACHE_Clean_FlushDCentry_110	$reg_number
 ENDIF
	MEND

;Drain Write Buffer.
;
	MACRO
	WRCACHE_DrainWriteBuffer	$reg_number
	NO_WRCACHE_DrainWriteBuffer	$reg_number
 IF :DEF: ARM720T
	WRCACHE_DrainWriteBuffer_720T	$reg_number
 ENDIF
 IF :DEF: ARM740T
	WRCACHE_DrainWriteBuffer_740T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	WRCACHE_DrainWriteBuffer_920T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	WRCACHE_DrainWriteBuffer_940T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRCACHE_DrainWriteBuffer_110	$reg_number
 ENDIF
	MEND

;Clean DCache (only) from address in $reg1 to (excl) addr in $reg2
;
	MACRO
	WRCACHE_CleanDrange	$reg1, $reg2
	NO_WRCACHE_CleanDrange	$reg1, $reg2
 IF :DEF: ARM720T
	WRCACHE_CleanDrange_720T	$reg1, $reg2
 ENDIF
 IF :DEF: ARM740T
	WRCACHE_CleanDrange_740T	$reg1, $reg2
 ENDIF
 IF :DEF: ARM920T
	WRCACHE_CleanDrange_920T	$reg1, $reg2
 ENDIF
 IF :DEF: ARM940T
	WRCACHE_CleanDrange_940T	$reg1, $reg2
 ENDIF
 IF :DEF: SA110
	WRCACHE_CleanDrange_110	$reg1, $reg2
 ENDIF
	MEND

;Clean all DCache 
;
	MACRO
	WRCACHE_CleanDCache	$w1, $w2, $w3, $w4, $w5, $w6
	NO_WRCACHE_CleanDCache	$w1, $w2, $w3, $w4, $w5, $w6
 IF :DEF: ARM720T
	WRCACHE_CleanDCache_720T	$w1, $w2, $w3, $w4, $w5, $w6
 ENDIF
 IF :DEF: ARM740T
	WRCACHE_CleanDCache_740T	$w1, $w2, $w3, $w4, $w5, $w6
 ENDIF
 IF :DEF: ARM920T
	WRCACHE_CleanDCache_920T	$w1, $w2, $w3, $w4, $w5, $w6
 ENDIF
 IF :DEF: ARM940T
	WRCACHE_CleanDCache_940T	$w1, $w2, $w3, $w4, $w5, $w6
 ENDIF
 IF :DEF: SA110
	WRCACHE_CleanDCache_110	$w1, $w2, $w3, $w4, $w5, $w6
 ENDIF
	MEND

;------------------------------------------------------------------
;Coprocessor test/clock/idle control 
;Enable Clock Switching
;
	MACRO
	WRCLK_EnableClockSW	$reg_number
	NO_WRCLK_EnableClockSW	$reg_number
 IF :DEF: ARM920T
	WRCLK_EnableClockSW_920T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	WRCLK_EnableClockSW_940T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRCLK_EnableClockSW_110	$reg_number
 ENDIF
	MEND

;Coprocessor test/clock/idle control 
;Disable Clock Switching
;
	MACRO
	WRCLK_DisableClockSW	$reg_number
	NO_WRCLK_DisableClockSW	$reg_number
 IF :DEF: ARM920T
	WRCLK_DisableClockSW_920T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	WRCLK_DisableClockSW_940T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRCLK_DisableClockSW_110	$reg_number
 ENDIF
	MEND

;Coprocessor test/clock/idle control 
;Disable nMCLK output
;
	MACRO
	WRCLK_DisablenMCLK	$reg_number
	NO_WRCLK_DisablenMCLK	$reg_number
 IF :DEF: ARM920T
	WRCLK_DisablenMCLK_920T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRCLK_DisablenMCLK_110	$reg_number
 ENDIF
	MEND

;Coprocessor test/clock/idle control 
;Wait for Interrupt
;
	MACRO
	WRTEST_WaitInt	$reg_number
	NO_WRTEST_WaitInt	$reg_number
 IF :DEF: ARM720T
	WRTEST_WaitInt_720T	$reg_number
 ENDIF
 IF :DEF: ARM740T
	WRTEST_WaitInt_740T	$reg_number
 ENDIF
 IF :DEF: ARM920T
	WRTEST_WaitInt_920T	$reg_number
 ENDIF
 IF :DEF: ARM940T
	WRTEST_WaitInt_940T	$reg_number
 ENDIF
 IF :DEF: SA110
	WRTEST_WaitInt_110	$reg_number
 ENDIF
	MEND

;-----------------------------------------------------------
; MPU setup macro and variables
;

	MACRO
	SET_MPU_REGION	$num, $address, $size, $access
	NO_SET_MPU_REGION	$num, $address, $size, $access
 IF :DEF: ARM740T
	SET_MPU_REGION_740T	$num, $address, $size, $access
 ENDIF
 IF :DEF: ARM940T
	SET_MPU_REGION_940T	$num, $address, $size, $access
 ENDIF
	MEND

 ENDIF
	END
