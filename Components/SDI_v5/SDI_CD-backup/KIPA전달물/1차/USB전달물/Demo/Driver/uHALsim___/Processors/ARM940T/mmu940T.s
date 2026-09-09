;/***************************************************************************
; * Copyright © ARM Limited 1998, 1999.  All rights reserved.
; ***************************************************************************/
;/*****************************************************************************
;
;   This file contains the COPROCESSOR access macros for the ARM940T processor
;
;******************************************************************************/


;Flag that this processor does not have an MMU
;
	MACRO
	CHECK_FOR_MMU_940T	$tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Flag that this processor has an MPU
;
	MACRO
	CHECK_FOR_MPU_940T	$tmp
	MOVS	$tmp, #1		; Set tmp & clear Z (TRUE)
	MEND

;Flag that this processor has a Cache
;
	MACRO
	CHECK_CACHE_940T	$tmp
	MOVS	$tmp, #1		; Set tmp & clear Z (TRUE)
	MEND

;Flag that this processor does not have a unified cache
;
	MACRO
	CHECK_UNIFIED_940T	$tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Compare (uHAL supplied) processor ID with ARM 940
;
	MACRO
	CHECK_CPUID_940T	$id, $tmp
	RDCPU_ID_940T	$id, $tmp
	CMP	$tmp, #0x940		; set Z if it is an ARM 940
	MEND

;Compare (uHAL supplied) processor Vendor ID with 'A'RM.
;
	MACRO
	CHECK_VENDOR_940T	$id, $tmp
	RDCPU_VENDOR_940T	$id, $tmp
	CMP	$tmp, #0x41		; I'll have an 'A' please, Bob.
	MEND

; ------------------------------------------------------------------
;Macros to hide internals of cache implementation on each processor
;
	MACRO
        CLEAR_IDC_940T	$state
        CLEAR_ICACHE_940T	$state
        CLEAR_DCACHE_940T	$state
	; No Write Buffer - Can't turn off on a 9x0
	MEND

	MACRO
        CLEAR_ICACHE_940T	$state
        BIC     $state, $state, #EnableIcache   ; No ICache
	MEND

	MACRO
        CLEAR_DCACHE_940T	$state
        BIC     $state, $state, #EnableDcache   ; No DCache
	MEND

        ; No Write Buffer enable on 940

	MACRO
	CLEAR_MMU_940T	$state
        BIC     $state, $state, #EnableMMU	; Disable MMU
	MEND


	MACRO
        SET_IDC_940T	$state
        SET_ICACHE_940T	$state
        SET_DCACHE_940T	$state
	; No Write Buffer - Can't turn on on a 940
	MEND

	MACRO
        SET_ICACHE_940T	$state
        ORR	$state, $state, #EnableIcache   ; Enable ICache
	MEND

	MACRO
        SET_DCACHE_940T	$state
        ORR	$state, $state, #EnableDcache   ; Enable DCache
	MEND

	; No Write Buffer - Can't turn on on a 940

	MACRO
	SET_MMU_940T	$state
        ORR	$state, $state, #EnableMMU	; Enable MMU
	MEND

	MACRO
	SET_BIGEND_940T	$state
        ORR	$state, $state, #EnableBigEndian	; Set BigEndian
	MEND

	MACRO
	TEST_MMU_940T	$tmp
	RDMMU_STATE_940T	$tmp
	AND	$tmp, $tmp, #EnableMMU
	TEQ	$tmp, #EnableMMU
	MEND

	MACRO
	TEST_BIGEND_940T	$tmp
	RDMMU_STATE_940T	$tmp
	AND	$tmp, $tmp, #EnableBigEndian
	TEQ	$tmp, #EnableBigEndian
	MEND

;------------------------------------------------------------------
;Read CPU Code (ID, Vendor revision etc.) register 
;
	MACRO
	RDCPU_CODE_940T	$id
	MRC p15, 0, $id, c0, c0 ,0
	MEND

;Extract CPU ID from CPU Code register
;
	MACRO
	RDCPU_ID_940T	$id, $tmp
	MRC p15, 0, $id, c0, c0 ,0
	MOV	$tmp, $id, LSL #16	; Clear bits 16-31
	MOV	$tmp, $tmp, LSR #20	; Move bits 15-3 to 12-0
	MEND

;Extract CPU Vendor from CPU Code register
;
	MACRO
	RDCPU_VENDOR_940T	$id, $tmp
	MRC p15, 0, $id, c0, c0 ,0
	MOV	$tmp, $id, LSR #24	; Move bits 31-24 to 7-0
	MEND

;Coprocessor read of ID register (cache line sizes)
;
	MACRO
	RDCACHE_SIZES_940T $reg_number
	MRC p15, 0, $reg_number, c0, c0 ,1
	MEND

;Coprocessor read of Control register 
;
	MACRO
	RDMMU_STATE_940T $reg_number
	MRC p15, 0, $reg_number, c1, c0 ,0
	MEND

;Coprocessor write of Control register 
;
	MACRO 
	WRMMU_STATE_940T $reg_number
	MCR p15, 0, $reg_number, c1, c0 ,0
	MEND

;-----------------------------------------------------------
; MPU support macros:

;Coprocessor write of MPU cache bits 
;
	MACRO 
	WRMPU_CacheBits_940T	$reg_number
	MCR p15, 0, $reg_number, c2, c0, 0
	MCR p15, 0, $reg_number, c2, c0, 1
	MEND

;Coprocessor write of MPU buffer bits 
;
	MACRO 
	WRMPU_BufferBits_940T	$reg_number
	MCR p15, 0, $reg_number, c3, c0, 0
	MCR p15, 0, $reg_number, c3, c0, 1
	MEND

;Coprocessor write of MPU access bits 
;
	MACRO 
	WRMPU_AccessBits_940T	$reg_number
	MCR p15, 0, $reg_number, c5, c0, 0
	MCR p15, 0, $reg_number, c5, c0, 1
	MEND

;Coprocessor write of MPU region registors 
;
	MACRO 
	WRMPU_Region_940T	$region, $reg_number
	MCR p15, 0, $reg_number, c6, c$region, 0
	MCR p15, 0, $reg_number, c6, c$region, 1
	MEND

;-----------------------------------------------------------
;Coprocessor cache control 
;Flush I & D Caches
;
	MACRO 
	WRCACHE_FlushIDC_940T $reg_number
	WRCACHE_FlushIC_940T $reg_number
	WRCACHE_FlushDC_940T $reg_number
	MEND

;Coprocessor cache control 
;Flush ICache
;
	MACRO 
	WRCACHE_FlushIC_940T $reg_number
	MCR p15,0,$reg_number,c7,c5,0
	MEND

;Coprocessor cache control 
;Flush DCache
;
	MACRO 
	WRCACHE_FlushDC_940T $reg_number
	MCR p15,0,$reg_number,c7,c6,0
	MEND

;Coprocessor cache control 
;Flush DCache entry
;
	MACRO 
	WRCACHE_CacheFlushDentry_940T $reg_number
	WRCACHE_FlushDC_940T $reg_number
	MEND

;Coprocessor cache control 
;Clean DCache entry
;
; ARM940T does not have a clean cache line by address instruction
; therefore we have to clean the whole cache.  Because this requires
; more registers than we have we need to save the registors on the
; current stack.  This of course means that a stack must be set up
; when this macro is used.
;

	MACRO 
	WRCACHE_CleanDCentry_940T $reg_number
 	STMFD	sp!,{r0-r5}
	WRCACHE_CleanDCache_940T r0, r1, r2, r3, r4, r5
	LDMFD	sp!,{r0-r5}
	MEND

;Coprocessor cache control 
;Clean + Flush DCache entry
;
; See the above description for Clean DCache entry.
;
	MACRO 
	WRCACHE_Clean_FlushDCentry_940T $reg_number
 	STMFD	sp!,{r0-r5}
	WRCACHE_CleanDCache_940T r0, r1, r2, r3, r4, r5
	WRCACHE_FlushDC_940T $reg_number
	LDMFD	sp!,{r0-r5}
	MEND

;Drain Write Buffer.
;
	MACRO
	WRCACHE_DrainWriteBuffer_940T $reg_number
	MCR p15,0,$reg_number,c7,c10,4
	MEND

;Flush TLB 
;
	MACRO
	WRMMU_FlushTB_940T $reg_number
	WRMMU_FlushITB_940T $reg_number
	WRMMU_FlushDTB_940T $reg_number
	MEND

;Flush Instruction TLB 
;
	MACRO
	WRMMU_FlushITB_940T $reg_number
	MCR p15,0,$reg_number,c8,c5,0
	MEND

;Flush Data TLB
;
	MACRO
	WRMMU_FlushDTB_940T $reg_number
	MCR p15,0,$reg_number,c8,c6,0
	MEND

;Coprocessor cache control 
;Clean DCache
;
	MACRO 
	WRCACHE_CleanDCache_940T	$w1, $w2, $w3, $w4, $w5, $w6
	RDCACHE_SIZES	$w2		; Get cache information

	MOV	$w3, #7			; 3 bit mask
	AND	$w4, $w3, $w2, LSR #18	; Get Cache Size
	AND	$w5, $w3, $w2, LSR #15	; Get Cache Associativity
	AND	$w6, $w3, $w2, LSR #12	; Get Base and Line Length
	MOVS	$w3, $w6, LSR #2	; Get Base (and set flags)
	AND	$w6, $w6, #3		; Get Line Length

	; Calculate LSB of Index field
	;
	; 32 - Cache Associativity - Base
	RSB	$w2, $w5, #32
	SUB	$w2, $w2, $w3

	; Calculate MSB of Segment field
	;
	; 8 + Cache Size - Cache Associativity
	ADD	$w3, $w4, #8
	SUB	$w3, $w3, $w5

	; Calculate LSB of Segment field
	;
	; Line Length + 3
	ADD	$w4, $w6, #3

	; Calculate max value for Index field
	RSB	$w5, $w2, #32
	MOV	$w6, #1
	MOV	$w5, $w6, LSL $w5
	SUBNE	$w5, $w5, $w5, LSR #2
	SUB	$w5, $w5, #1

	; Calculate max value for Segment field
	SUB	$w3, $w3, $w4
	ADD	$w3, $w3, #1
	MOV	$w3, $w6, LSL $w3
	SUB	$w3, $w3, #1

	; Now finally clean the cache
1	MOV	$w6, $w3
2	MOV	$w1, $w5, LSL $w2
	ORR	$w1, $w1, $w6, LSL $w4
	MCR	p15, 0, $w1, c7, c10, 2	; Clean Line by Index (Not Address)
	SUBS	$w6, $w6, #1
	BGE	%B2
	SUBS	$w5, $w5, #1
	BGE	%B1

	MEND

;Clean DCache (only) from address in $reg1 to (excl) addr in $reg2
;
	MACRO
	WRCACHE_CleanDrange_940T	$reg1, $reg2
1      
        WRCACHE_CleanDCentry_940T $reg1
        ADD     $reg1, $reg1, #32
        CMP     $reg1, $reg2
        BLT     %B1
	MEND

;------------------------------------------------------------------
;Coprocessor test/clock/idle control 
;Enable Clock Switching
;
	MACRO
	WRCLK_EnableClockSW_940T	$reg
	RDMMU_STATE_940T	$reg
	ORR	$reg, $reg, #0xC0000000
	WRMMU_STATE_940T	$reg
	MEND

;Coprocessor test/clock/idle control 
;Disable Clock Switching
;
	MACRO
	WRCLK_DisableClockSW_940T	$reg
	RDMMU_STATE_940T	$reg
	BIC	$reg, $reg, #0xC0000000
	WRMMU_STATE_940T	$reg
	MEND

;Coprocessor test/clock/idle control 
;Disable nMCLK output
;
	MACRO
	WRCLK_DisablenMCLK_940T	$reg
	MEND

;Coprocessor test/clock/idle control 
;Wait for Interrupt
;
    MACRO
    WRTEST_WaitInt_940T	$reg
    MCR p15, 0, $reg_number, c15, c8 ,2
    MEND

;------------------------------------------------------------------
; MPU setup macro
;

	MACRO
	SET_MPU_REGION_940T	$num, $address, $size, $access

	;
	; Check that the address is correctly aligned, it must be
	; a multiple of size.
	;
	ASSERT (($address :AND: ((1 :SHL: ($size + 1)) - 1)) = 0)

MPU_REGION_$num	SETA (($address :AND: 0xFFFFF000) + ($size :SHL: 1) + 1)
MPU_CACHE	SETA MPU_CACHE :OR: ((($access :SHR: 3) :AND: 1) :SHL: $num)
MPU_BUFFER	SETA MPU_BUFFER :OR: ((($access :SHR: 2) :AND: 1) :SHL: $num)
MPU_ACCESS	SETA MPU_ACCESS :OR: ((($access :SHR: 10) :AND: 3) :SHL: ($num * 2))

	MEND

	END
