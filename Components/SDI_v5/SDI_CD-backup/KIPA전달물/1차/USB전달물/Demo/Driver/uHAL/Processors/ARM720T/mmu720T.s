;/***************************************************************************
; * Copyright © ARM Limited 1998, 1999.  All rights reserved.
; ***************************************************************************/
;/*****************************************************************************
;
;   This file contains the COPROCESSOR access macros for the ARM720T processor
;
;******************************************************************************/


;Flag that this processor has an MMU
;
	MACRO
	CHECK_FOR_MMU_720T $tmp
	MOVS	$tmp, #1		; Set tmp & clear Z (TRUE)
	MEND

;Flag that this processor does not have an MPU
;
	MACRO
	CHECK_FOR_MPU_720T $tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Flag that this processor has a Cache
;
	MACRO
	CHECK_CACHE_720T $tmp
	MOVS	$tmp, #1		; Set tmp & clear Z (TRUE)
	MEND

;Flag that this processor has a unified cache
;
	MACRO
	CHECK_UNIFIED_720T $tmp
	MOVS	$tmp, #1		; Set tmp & clear Z (TRUE)
	MEND

;Compare processor ID with ARM 720T
;
	MACRO
	CHECK_CPUID_720T	$id, $tmp
	RDCPU_ID_720T	$id, $tmp
	CMP	$tmp, #0x720		; set Z if it is an ARM 720
	MEND

;Compare processor Vendor ID with 'A'RM.
;
	MACRO
	CHECK_VENDOR_720T	$id, $tmp
	RDCPU_VENDOR_720T	$id, $tmp
	CMP	$tmp, #0x41		; I'll have an 'A' please, Bob.
	MEND

;------------------------------------------------------------------
;Macros to hide internals of cache implementation on each processor
;
	MACRO
	CLEAR_IDC_720T	$state
	BIC     $state, $state, #EnableUcache	; No Cache
	CLEAR_WBUFFER_720T	$state
	MEND

	MACRO
	CLEAR_ICACHE_720T	$state
	CLEAR_IDC_720T	$state			; No ICache, so no cache 
	MEND

	MACRO
	CLEAR_DCACHE_720T	$state
	CLEAR_IDC_720T	$state			; No DCache, no cache
	MEND

	MACRO
	CLEAR_WBUFFER_720T	$state
	BIC     $state, $state, #EnableWB	; No Write Buffer
	MEND

	MACRO
	CLEAR_MMU_720T	$state
	BIC     $state, $state, #EnableMMU	; Disable MMU
	MEND

	MACRO
        SET_IDC_720T	$state
        SET_ICACHE_720T	$state
        SET_DCACHE_720T	$state
	SET_WBUFFER_720T	$state
	MEND

	MACRO
        SET_ICACHE_720T	$state
        ORR	$state, $state, #EnableIcache   ; Enable ICache
	MEND

	MACRO
        SET_DCACHE_720T	$state
        ORR	$state, $state, #EnableDcache   ; Enable DCache
	MEND

	MACRO
	SET_WBUFFER_720T	$state
	BIC     $state, $state, #EnableWB	; No Write Buffer
	MEND

	MACRO
	SET_MMU_720T	$state
        ORR	$state, $state, #EnableMMU	; Enable MMU
	MEND

	MACRO
	SET_BIGEND_720T	$state
        ORR	$state, $state, #EnableBigEndian	; Set BigEndian
	MEND

	MACRO
	TEST_MMU_720T	$tmp
	RDMMU_STATE_720T	$tmp
	AND	$tmp, $tmp, #EnableMMU
	TEQ	$tmp, #EnableMMU
	MEND

	MACRO
	TEST_BIGEND_720T	$tmp
	RDMMU_STATE_720T	$tmp
	AND	$tmp, $tmp, #EnableBigEndian
	TEQ	$tmp, #EnableBigEndian
	MEND

; ------------------------------------------------------------------
;Read CPU Code (ID, Vendor revision etc.) register 
;
	MACRO
	RDCPU_CODE_720T	$id, $tmp
	MRC p15, 0, $id, c0, c0 ,0
	MEND

;Extract CPU ID from CPU Code register
;
	MACRO
	RDCPU_ID_720T	$id, $tmp
	MRC p15, 0, $id, c0, c0 ,0
	MOV	$tmp, $id, LSL #16	; Clear bits 16-31
	MOV	$tmp, $tmp, LSR #20	; Move bits 15-3 to 12-0
	MEND

;Extract CPU Vendor from CPU Code register
;
	MACRO
	RDCPU_VENDOR_720T	$id, $tmp
	MRC p15, 0, $id, c0, c0 ,0
	MOV	$tmp, $id, LSR #24	; Move bits 31-24 to 7-0
	MEND

;Coprocessor read of ID register (cache line sizes)
;
	MACRO
	RDCACHE_SIZES_720T $reg_number
	MRC p15, 0, $reg_number, c0, c0 ,1
	MEND

;Coprocessor read of Control register 
;
	MACRO
	RDMMU_STATE_720T $reg_number
	MRC p15, 0, $reg_number, c1, c0 ,0
	MEND

;Coprocessor write of Control register 
;
	MACRO 
	WRMMU_STATE_720T $reg_number
	MCR p15, 0, $reg_number, c1, c0, 0
	MEND

;------------------------------------------------------------------
;Coprocessor read of Translation Table Base reg. 
;
	MACRO
	RDMMU_TTBase_720T $reg_number
	MRC p15, 0, $reg_number, c2, c0, 0
	MEND

;Coprocessor write of Translation Table Base reg. 
;
	MACRO 
	WRMMU_TTBase_720T $reg_number
	MCR p15, 0, $reg_number , c2, c0, 0
	MEND

;Coprocessor read of Domain Access Control reg. 
;
	MACRO
	RDMMU_DAControl_720T $reg_number
	MRC p15, 0, $reg_number, c3, c0, 0
	MEND

;Coprocessor write of Domain Access Control reg. 
;
	MACRO 
	WRMMU_DAControl_720T $reg_number
	MCR p15, 0, $reg_number, c3, c0, 0
	MEND

;Coprocessor read of Fault Status register 
;
    MACRO
    RDMMU_FaultStatus_720T	$reg_number
    MRC p15, 0, $reg_number, c5, c0 ,0
    MEND

;Coprocessor write of Fault Status register 
;
    MACRO 
    WRMMU_FaultStatus_720T	$reg_number
    MCR p15, 0, $reg_number, c5, c0 ,0
    MEND

;Coprocessor read of Fault Address register 
;
    MACRO
    RDMMU_FaultAddress_720T	$reg_number
    MRC p15, 0, $reg_number, c6, c0 ,0
    MEND

;Coprocessor write of Fault Address register 
;
    MACRO 
    WRMMU_FaultAddress_720T	$reg_number
    MCR p15, 0, $reg_number, c6, c0 ,0
    MEND

;------------------------------------------------------------------
;Coprocessor cache control 
;Flush I & D Caches
;
	MACRO 
	WRCACHE_FlushIDC_720T $reg_number
	MCR p15, 0, $reg_number, c7, c7, 0
	MEND

;Coprocessor cache control 
;Flush ICache
;
	MACRO 
	WRCACHE_FlushIC_720T $reg_number
	WRCACHE_FlushIDC_720T $reg_number
	MEND

;Coprocessor cache control 
;Flush DCache
;
	MACRO 
	WRCACHE_FlushDC_720T $reg_number
	WRCACHE_FlushIDC_720T $reg_number
	MEND

;Coprocessor cache control 
;Flush DCache entry
;
	MACRO 
	WRCACHE_CacheFlushDentry_720T $reg_number
	WRCACHE_FlushIDC_720T $reg_number
	MEND

;Coprocessor cache control 
;Clean DCache entry
;This only applies to a processor with a writeback cache.
;
	MACRO 
	WRCACHE_CleanDCentry_720T $reg_number
	MEND

;Coprocessor cache control 
;Clean + Flush DCache entry
;
	MACRO 
	WRCACHE_Clean_FlushDCentry_720T $reg_number
	WRCACHE_FlushIDC_720T $reg_number
	MEND

;Drain Write Buffer.
;There is a write buffer but there appears to be no way to drain it. 
;irqlib.s needs this macro...
;
	MACRO
	WRCACHE_DrainWriteBuffer_720T $reg_number
	MEND

;Clean DCache (only) from address in $reg1 to (excl) addr in $reg2
;
	MACRO
	WRCACHE_CleanDrange_720T $reg1, $reg2
	MEND

;Clean all DCache
;
	MACRO
	WRCACHE_CleanDCache_720T	$w1, $w2, $w3, $w4, $w5, $W6
	; Use reads from a reserved area to evict any dirty entries
	LDR	$w1, =CLEAN_BASE	; address for dcache loads
	ADD	$w2, $w1, #DCACHE_SIZE	; end address for clean completion
9
	; load a dcache line and increment address pointer
	LDR	$w3, [$w1], #DCACHE_LINE
	TEQ	$w2, $w1		; IF clean still in progress
	BNE	%9			; THEN loop on dcache fills

	MEND

;Flush TLB 
;
	MACRO
	WRMMU_FlushTB_720T $reg_number
	MCR p15,0,$reg_number,c8,c7,0
	MEND

;Flush Instruction TLB
;
	MACRO
	WRMMU_FlushITB_720T $reg_number
	WRMMU_FlushTB_720T $reg_number
	MEND

;Flush Data TLB
;
	MACRO
	WRMMU_FlushDTB_720T $reg_number
	WRMMU_FlushTB_720T $reg_number
	MEND

;------------------------------------------------------------------
;Coprocessor test/clock/idle control 
;Disable nMCLK output
;
	MACRO
	WRCLK_DisablenMCLK_720T $reg_number
	MEND

;Coprocessor test/clock/idle control 
;Wait for Interrupt
;
	MACRO
	WRTEST_WaitInt_720T $reg_number
	MEND

	END
