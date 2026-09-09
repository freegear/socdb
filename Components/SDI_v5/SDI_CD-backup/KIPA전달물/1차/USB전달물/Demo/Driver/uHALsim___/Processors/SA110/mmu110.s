;******************************************************************************
; Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
; Copyright © ARM Limited 1998, 1999.  All rights reserved.
;******************************************************************************
;******************************************************************************
;	Macros for SA-110 Coprocessor Access
;******************************************************************************/


;Flag that this processor has an MMU
;
	MACRO
	CHECK_FOR_MMU_110	$tmp
	MOVS	$tmp, #1		; Set tmp & clear Z (TRUE)
	MEND

;Flag that this processor does not have an MPU
;
	MACRO
	CHECK_FOR_MPU_110	$tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Flag that this processor does not have a unified cache
;
	MACRO
	CHECK_CACHE_110	$tmp
	MOVS	$tmp, #1		; Set tmp & clear Z (TRUE)
	MEND

;Flag that this processor does not have a unified cache
;
	MACRO
	CHECK_UNIFIED_110	$tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Compare (uHAL supplied) processor ID with SA 110
;
	MACRO
	CHECK_CPUID_110	$id
	RDCPU_ID_110	$id, $tmp
	CMP	$id, #0x110		; set Z if it is an SA 110
	MEND

;Compare (uHAL supplied) processor Vendor ID with 'D'IGITAL.
;
	MACRO
	CHECK_VENDOR_110	$id, $tmp
	RDCPU_VENDOR_110	$id, $tmp
	CMP	$tmp, #0x44		; I'll have an 'D' please, Bob.
	MEND

;------------------------------------------------------------------
;Macros to hide internals of cache implementation on each processor
;
	MACRO
	CLEAR_IDC_110	$state
	CLEAR_ICACHE_110	$state
	CLEAR_DCACHE_110	$state
	CLEAR_WBUFFER_110	$state
	MEND

	MACRO
	CLEAR_ICACHE_110	$state
	BIC     $state, $state, #EnableIcache	; No ICache
	MEND

	MACRO
	CLEAR_DCACHE_110	$state
	BIC     $state, $state, #EnableDcache	; No DCache
	MEND

	MACRO
	CLEAR_WBUFFER_110	$state
	BIC     $state, $state, #EnableWB	; No Write Buffer
	MEND

	MACRO
	CLEAR_MMU_110	$state
	BIC     $state, $state, #EnableMMU	; Disable MMU
	MEND

	MACRO
	CLEAR_BIGEND_110	$state
	BIC     $state, $state, #EnableMMU	; Disable BigEndian
	MEND


	MACRO
        SET_IDC_110	$state
        SET_ICACHE_110	$state
        SET_DCACHE_110	$state
        SET_WBUFFER_110	$state
	MEND

	MACRO
        SET_ICACHE_110	$state
        ORR	$state, $state, #EnableIcache   ; Enable ICache
	MEND

	MACRO
        SET_DCACHE_110	$state
        ORR	$state, $state, #EnableDcache   ; Enable DCache
	MEND

	MACRO
        SET_WBUFFER_110	$state
        ORR	$state, $state, #EnableWB	; Enable Write Buffer
	MEND

	MACRO
	SET_MMU_110	$state
        ORR	$state, $state, #EnableMMU	; Enable MMU
	MEND

	MACRO
	SET_BIGEND_110	$state
        ORR	$state, $state, #EnableBigEndian	; Set BigEndian
	MEND

	MACRO
	TEST_MMU_110	$tmp
	RDMMU_STATE_110	$tmp
	AND	$tmp, $tmp, #EnableMMU
	TEQ	$tmp, #EnableMMU
	MEND

	MACRO
	TEST_BIGEND_110	$tmp
	RDMMU_STATE_110	$tmp
	AND	$tmp, $tmp, #EnableBigEndian
	TEQ	$tmp, #EnableBigEndian
	MEND

;------------------------------------------------------------------
;Read CPU Code (ID, Vendor revision etc.) register 
;
	MACRO
	RDCPU_CODE_110	$id
	MRC p15, 0, $id, c0, c0 ,0
	MEND

;Extract CPU ID from CPU Code register
;
	MACRO
	RDCPU_ID_110	$id, $tmp
	MRC p15, 0, $id, c0, c0 ,0
	MOV	$tmp, $id, LSL #16	; Clear bits 16-31
	MOV	$tmp, $tmp, LSR #20	; Move bits 15-3 to 12-0
	MEND

;Extract CPU Vendor from CPU Code register
;
	MACRO
	RDCPU_VENDOR_110	$id, $tmp
	MRC p15, 0, $id, c0, c0 ,0
	MOV	$tmp, $id, LSR #24	; Move bits 31-24 to 7-0
	MEND

;Coprocessor read of Control register 
;
    MACRO
    RDMMU_STATE_110	$reg_number
    MRC p15, 0, $reg_number, c1, c0 ,0
    MEND

;Coprocessor write of Control register 
;
    MACRO 
    WRMMU_STATE_110 $reg_number
    MCR p15, 0, $reg_number, c1, c0 ,0
    MEND

;------------------------------------------------------------------
;Coprocessor read of Translation Table Base reg. 
;
    MACRO
    RDMMU_TTBase_110	$reg_number
    MRC p15, 0, $reg_number, c2, c0 ,0
    MEND

;Coprocessor write of Translation Table Base reg. 
;
    MACRO 
    WRMMU_TTBase_110	 $reg_number
    MCR p15, 0, $reg_number , c2, c0 ,0
    MEND

;Coprocessor read of Domain Access Control reg. 
;
    MACRO
    RDMMU_DAControl_110	$reg_number
    MRC p15, 0, $reg_number, c3, c0 ,0
    MEND

;Coprocessor write of Domain Access Control reg. 
;
    MACRO 
    WRMMU_DAControl_110	$reg_number
    MCR p15, 0, $reg_number, c3, c0 ,0
    MEND

;Coprocessor read of Fault Status register 
;
    MACRO
    RDMMU_FaultStatus_110	$reg_number
    MRC p15, 0, $reg_number, c5, c0 ,0
    MEND

;Coprocessor write of Fault Status register 
;
    MACRO 
    WRMMU_FaultStatus_110	$reg_number
    MCR p15, 0, $reg_number, c5, c0 ,0
    MEND

;Coprocessor read of Fault Address register 
;
    MACRO
    RDMMU_FaultAddress_110	$reg_number
    MRC p15, 0, $reg_number, c6, c0 ,0
    MEND

;Coprocessor write of Fault Address register 
;
    MACRO 
    WRMMU_FaultAddress_110	$reg_number
    MCR p15, 0, $reg_number, c6, c0 ,0
    MEND

;------------------------------------------------------------------
;Coprocessor cache control 
;Flush ICache + DCache
;
    MACRO 
    WRCACHE_FlushIDC_110	$reg_number
    MCR p15, 0, $reg_number, c7, c7 ,0
    MEND

;Coprocessor cache control 
;Flush ICache
;
    MACRO 
    WRCACHE_FlushIC_110	$reg_number
    MCR p15, 0, $reg_number, c7, c5 ,0
    MEND

;Coprocessor cache control 
;Flush DCache
;
    MACRO 
    WRCACHE_FlushDC_110	$reg_number
    MCR p15, 0, $reg_number, c7, c6 ,0
    MEND

;Coprocessor cache control 
;Flush DCache entry
;
    MACRO 
    WRCACHE_CacheFlushDentry_110	$reg_number
    MCR p15, 0, $reg_number, c7, c6 ,1
    MEND

;Coprocessor cache control 
;Clean DCache entry
;
    MACRO 
    WRCACHE_CleanDCentry_110	$reg_number
    MCR p15, 0, $reg_number, c7, c10 ,1
    MEND

;Coprocessor cache control 
;Clean + Flush DCache entry
;
    MACRO 
    WRCACHE_Clean_FlushDCentry_110	$reg_number
    MCR p15, 0, $reg_number, c7, c14 ,1
    MEND

;Coprocessor Drain Write Buffer 
;
    MACRO 
    WRCACHE_DrainWriteBuffer_110	$reg_number
    MCR p15, 0, $reg_number, c7, c10 ,4
    MEND

;Clean DCache (only) from address in $reg1 to (excl) addr in $reg2
;
	MACRO
	WRCACHE_CleanDrange_110	$reg1, $reg2
1      
	WRCACHE_CleanDCentry_110	$reg1
	ADD     $reg1, $reg1, #32
	CMP     $reg1, $reg2
	BLT     %B1
	MEND

;Clean all DCache
;
	MACRO
	WRCACHE_CleanDCache_110	$w1, $w2, $w3, $w4, $w5, $W6
	; Use reads from a reserved area to evict any dirty entries
	LDR	$w1, =CLEAN_BASE	; address for dcache loads
	LDR	$w2, =DCACHE_SIZE	; end address for clean completion
	ADD	$w2, $w2, $w1
9
	; load a dcache line and increment address pointer
	LDR	$w3, [$w1], #DCACHE_LINE
	TEQ	$w2, $w1		; IF clean still in progress
	BNE	%9			; THEN loop on dcache fills
	MEND

;Coprocessor TLB control 
;Flush ITB + DTB
;
    MACRO 
    WRMMU_FlushTB_110	$reg_number
    MCR p15, 0, $reg_number, c8, c7 ,0
    MEND

;Coprocessor TLB control 
;Flush ITB
;
    MACRO 
    WRMMU_FlushITB_110	$reg_number
    MCR p15, 0, $reg_number, c8, c5 ,0
    MEND

;Coprocessor TLB control 
;Flush DTB
;
    MACRO 
    WRMMU_FlushDTB_110	$reg_number
    MCR p15, 0, $reg_number, c8, c6 ,0
    MEND

;Coprocessor TLB control 
;Flush DTB entry

    MACRO 
    WRMMU_FlushDTBentry_110	$reg_number
    MCR p15, 0, $reg_number, c8, c6 ,1
    MEND

;------------------------------------------------------------------
;Coprocessor test/clock/idle control 
;Enable Clock Switching
;
    MACRO 
    WRCLK_EnableClockSW_110	$reg_number
    MCR p15, 0, $reg_number, c15, c1 ,2
    MEND

;Coprocessor test/clock/idle control 
;Disable Clock Switching
;
    MACRO 
    WRCLK_DisableClockSW_110	$reg_number
    MCR p15, 0, $reg_number, c15, c2 ,2
    MEND

;Coprocessor test/clock/idle control 
;Disable nMCLK output
;
    MACRO 
    WRCLK_DisablenMCLK_110	$reg_number
    MCR p15, 0, $reg_number, c15, c4 ,2
    MEND

;Coprocessor test/clock/idle control 
;Wait for Interrupt
;
    MACRO 
    WRCLK_WaitInt_110	$reg_number
    MCR p15, 0, $reg_number, c15, c8 ,2
    MEND

    END
