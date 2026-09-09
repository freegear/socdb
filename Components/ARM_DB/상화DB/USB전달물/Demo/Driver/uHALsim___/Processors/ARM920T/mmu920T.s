;/***************************************************************************
; * Copyright © ARM Limited 1998, 1999.  All rights reserved.
; ***************************************************************************/
;/*****************************************************************************
;
;   This file contains the COPROCESSOR access macros for the ARM920T processor
;
;******************************************************************************/


;Flag that this processor has an MMU
;
	MACRO
	CHECK_FOR_MMU_920T	$tmp
	MOVS	$tmp, #1		; Set tmp & clear Z (TRUE)
	MEND

;Flag that this processor does not have an MPU
;
	MACRO
	CHECK_FOR_MPU_920T	$tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Flag that this processor does not have a unified cache
;
	MACRO
	CHECK_CACHE_920T	$tmp
	MOVS	$tmp, #1		; Set tmp & clear Z (TRUE)
	MEND

;Flag that this processor does not have a unified cache
;
	MACRO
	CHECK_UNIFIED_920T	$tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Flag if this processor ID matches
;
	MACRO
	CHECK_CPUID_920T	$id, $tmp
	RDCPU_ID_920T	$id, $tmp
	CMP	$tmp, #0x920
	MEND

;Flag if this processor Vendor ID matches
;
	MACRO
	CHECK_VENDOR_920T	$id, $tmp
	RDCPU_VENDOR_920T	$id, $tmp
	CMP	$tmp, #0x41		; I'll have an 'A' please, Bob.
	MEND

;------------------------------------------------------------------
;Macros to hide internals of cache implementation on each processor
;
	MACRO
        CLEAR_IDC_920T	$state
        CLEAR_ICACHE_920T	$state
        CLEAR_DCACHE_920T	$state
	; No Write Buffer - Can't turn off on a 920
	MEND

	MACRO
        CLEAR_ICACHE_920T	$state
        BIC     $state, $state, #EnableIcache   ; No ICache
	MEND

	MACRO
        CLEAR_DCACHE_920T	$state
        BIC     $state, $state, #EnableDcache   ; No DCache
	MEND

	; No Write Buffer - Can't turn off on a 920

	MACRO
	CLEAR_MMU_920T	$state
        BIC     $state, $state, #EnableMMU	; Disable MMU
	MEND

	MACRO
	CLEAR_BIGEND_920T	$state
        BIC     $state, $state, #EnableBigEndian	; Clean BigEndian
	MEND


	MACRO
        SET_IDC_920T	$state
        SET_ICACHE_920T	$state
        SET_DCACHE_920T	$state
	; No Write Buffer - Can't turn on on a 920
	MEND

	MACRO
        SET_ICACHE_920T	$state
        ORR	$state, $state, #EnableIcache   ; Enable ICache
	MEND

	MACRO
        SET_DCACHE_920T	$state
        ORR	$state, $state, #EnableDcache   ; Enable DCache
	MEND

	; No Write Buffer - Can't turn on on a 920

	MACRO
	SET_MMU_920T	$state
        ORR	$state, $state, #EnableMMU	; Enable MMU
	MEND

	MACRO
	SET_BIGEND_920T	$state
        ORR	$state, $state, #EnableBigEndian	; Set BigEndian
	MEND

	MACRO
	TEST_MMU_920T	$tmp
	RDMMU_STATE_920T	$tmp
	AND	$tmp, $tmp, #EnableMMU
	TEQ	$tmp, #EnableMMU
	MEND

	MACRO
	TEST_BIGEND_920T	$tmp
	RDMMU_STATE_920T	$tmp
	AND	$tmp, $tmp, #EnableBigEndian
	TEQ	$tmp, #EnableBigEndian
	MEND

;------------------------------------------------------------------
;Read CPU Code (ID, Vendor revision etc.) register 
;
	MACRO
	RDCPU_CODE_920T	$id
	MRC p15, 0, $id, c0, c0 ,0
	MEND

;Extract CPU ID from CPU Code register
;
	MACRO
	RDCPU_ID_920T	$id, $tmp
	MRC p15, 0, $id, c0, c0 ,0
	MOV	$tmp, $id, LSL #16	; Clear bits 16-31
	MOV	$tmp, $tmp, LSR #20	; Move bits 15-3 to 12-0
	MEND

;Extract CPU Vendor from CPU Code register
;
	MACRO
	RDCPU_VENDOR_920T	$id, $tmp
	MRC p15, 0, $id, c0, c0 ,0
	MOV	$tmp, $id, LSR #24	; Move bits 31-24 to 7-0
	MEND

;Coprocessor read of ID register (cache line sizes)
;
	MACRO
	RDCACHE_SIZES_920T $reg_number
	MRC p15, 0, $reg_number, c0, c0 ,1
	MEND

;Coprocessor read of Control register 
;
	MACRO
	RDMMU_STATE_920T $reg_number
	MRC p15, 0, $reg_number, c1, c0 ,0
	MEND

;Coprocessor write of Control register 
;
	MACRO 
	WRMMU_STATE_920T $reg_number
	MCR p15, 0, $reg_number, c1, c0 ,0
	MEND

;------------------------------------------------------------------
;Coprocessor read of Translation Table Base reg. 
;
	MACRO
	RDMMU_TTBase_920T $reg_number
	MRC p15, 0, $reg_number, c2, c0 ,0
	MEND

;Coprocessor write of Translation Table Base reg. 
;
	MACRO 
	WRMMU_TTBase_920T $reg_number
	MCR p15, 0, $reg_number , c2, c0 ,0
	MEND

;Coprocessor read of Domain Access Control reg. 
;
	MACRO
	RDMMU_DAControl_920T $reg_number
	MRC p15, 0, $reg_number, c3, c0 ,0
	MEND

;Coprocessor write of Domain Access Control reg. 
;
	MACRO 
	WRMMU_DAControl_920T $reg_number
	MCR p15, 0, $reg_number, c3, c0 ,0
	MEND

;Coprocessor read of Fault Status register 
;
    MACRO
    RDMMU_FaultStatus_920T	$reg_number
    MRC p15, 0, $reg_number, c5, c0 ,0
    MEND

;Coprocessor write of Fault Status register 
;
    MACRO 
    WRMMU_FaultStatus_920T	$reg_number
    MCR p15, 0, $reg_number, c5, c0 ,0
    MEND

;Coprocessor read of Fault Address register 
;
    MACRO
    RDMMU_FaultAddress_920T	$reg_number
    MRC p15, 0, $reg_number, c6, c0 ,0
    MEND

;Coprocessor write of Fault Address register 
;
    MACRO 
    WRMMU_FaultAddress_920T	$reg_number
    MCR p15, 0, $reg_number, c6, c0 ,0
    MEND

; ------------------------------------------------------------------
;Coprocessor cache control 
;Flush I & D Caches
;
	MACRO 
	WRCACHE_FlushIDC_920T $reg_number
	WRCACHE_FlushIC_920T $reg_number
	WRCACHE_FlushDC_920T $reg_number
	MEND

;Coprocessor cache control 
;Flush ICache
;
	MACRO 
	WRCACHE_FlushIC_920T $reg_number
	MCR p15,0,$reg_number,c7,c5,0
	MEND

;Coprocessor cache control 
;Flush DCache
;
	MACRO 
	WRCACHE_FlushDC_920T $reg_number
	MCR p15,0,$reg_number,c7,c6,0
	MEND

;Coprocessor cache control 
;Flush DCache entry
;
	MACRO 
	WRCACHE_CacheFlushDentry_920T $reg_number
	MCR p15,0,$reg_number,c7,c6,1
	MEND

;Coprocessor cache control 
;Clean DCache entry
;
	MACRO 
	WRCACHE_CleanDCentry_920T $reg_number
	MCR p15,0,$reg_number,c7,c10,1
	MEND

;Coprocessor cache control 
;Clean DCache
;
	MACRO 
	WRCACHE_CleanDCache_920T	$w1, $w2, $w3, $w4, $w5, $w6
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

;Coprocessor cache control 
;Clean + Flush DCache entry
;
	MACRO 
	WRCACHE_Clean_FlushDCentry_920T $reg_number
	MCR p15,0,$reg_number,c7,c14,1
	MEND

;Drain Write Buffer.
;
	MACRO
	WRCACHE_DrainWriteBuffer_920T $reg_number
	MCR p15,0,$reg_number,c7,c10,4
	MEND

;Flush TLB 
;
	MACRO
	WRMMU_FlushTB_920T $reg_number
	WRMMU_FlushITB_920T $reg_number
	WRMMU_FlushDTB_920T $reg_number
	MEND

;Flush Instruction TLB 
;
	MACRO
	WRMMU_FlushITB_920T $reg_number
	MCR p15,0,$reg_number,c8,c5,0
	MEND

;Flush Data TLB
;
	MACRO
	WRMMU_FlushDTB_920T $reg_number
	MCR p15,0,$reg_number,c8,c6,0
	MEND

;Clean DCache (only) from address in $reg1 to (excl) addr in $reg2
;
	MACRO
	WRCACHE_CleanDrange_920T	$reg1, $reg2
1      
        WRCACHE_CleanDCentry_920T $reg1
        ADD     $reg1, $reg1, #32
        CMP     $reg1, $reg2
        BLT     %B1
	MEND

; ------------------------------------------------------------------
;Coprocessor test/clock/idle control 
;Enable Clock Switching
;
	MACRO
	WRCLK_EnableClockSW_920T $reg
	RDMMU_STATE_920T	$reg
	ORR	$reg, $reg, #0xC0000000
	WRMMU_STATE_920T	$reg
	MEND

;Coprocessor test/clock/idle control 
;Disable Clock Switching
;
	MACRO
	WRCLK_DisableClockSW_920T $reg
	RDMMU_STATE_920T	$reg
	BIC	$reg, $reg, #0xC0000000
	WRMMU_STATE_920T	$reg
	MEND

;Coprocessor test/clock/idle control 
;Disable nMCLK output
;
	MACRO
	WRCLK_DisablenMCLK_920T $reg
	MEND

;Coprocessor test/clock/idle control 
;Wait for Interrupt
;
	MACRO
	WRTEST_WaitInt_920T $reg
	MEND

	END
