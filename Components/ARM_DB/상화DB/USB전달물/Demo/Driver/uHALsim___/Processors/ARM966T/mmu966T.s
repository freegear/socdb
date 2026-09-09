;/***************************************************************************
; * Copyright © ARM Limited 1998, 1999.  All rights reserved.
; ***************************************************************************/
;/*****************************************************************************
;
;   This file contains the COPROCESSOR access macros for the ARM966T processor
;
;******************************************************************************/


;Flag that this processor does not have an MMU
;
	MACRO
	CHECK_FOR_MMU_966T	$tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Flag that this processor does not have an MPU
;
	MACRO
	CHECK_FOR_MPU_966T	$tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Flag that this processor does not have a Cache
;
	MACRO
	CHECK_CACHE_966T	$tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Flag that this processor does not have a unified cache
;
	MACRO
	CHECK_UNIFIED_966T	$tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Compare (uHAL supplied) processor ID with ARM 966
;
	MACRO
	CHECK_CPUID_966T	$id, $tmp
	RDCPU_ID_966T	$id, $tmp
	SUB	$tmp, $tmp, #0x900
	CMP	$tmp, #0x66		; set Z if it is an ARM 966
	MEND

;Compare (uHAL supplied) processor Vendor ID with 'A'RM.
;
	MACRO
	CHECK_VENDOR_966T	$id, $tmp
	RDCPU_VENDOR_966T	$id, $tmp
	CMP	$tmp, #0x41		; I'll have an 'A' please, Bob.
	MEND

; ------------------------------------------------------------------
;Macros to hide internals of cache implementation on each processor
;

;
; The 966 has on chip instruction & data memory, this is enabled using the
; same bits in the CP15 control registor that would normally enable I & D caches
;
	MACRO
	CLEAR_IMEM_966T	$state
	BIC	$state, $state, #EnableICache
	MEND

	MACRO
	CLEAR_DMEM_966T	$state
	BIC	$state, $state, #EnableDCache
	MEND

	MACRO
	SET_IMEM_966T	$state
	ORR	$state, $state, #EnableICache
	MEND

	MACRO
	SET_DMEM_966T	$state
	ORR	$state, $state, #EnableDCache
	MEND

	MACRO
	SET_BIGEND_966T	$state
        ORR	$state, $state, #EnableBigEndian	; Set BigEndian
	MEND

	MACRO
	TEST_BIGEND_966T	$tmp
	RDMMU_STATE_966T	$tmp
	AND	$tmp, $tmp, #EnableBigEndian
	TEQ	$tmp, #EnableBigEndian
	MEND


;------------------------------------------------------------------
;Read CPU Code (ID, Vendor revision etc.) register 
;
	MACRO
	RDCPU_CODE_966T	$id
	MRC p15, 0, $id, c0, c0 ,0
	MEND

;Extract CPU ID from CPU Code register
;
	MACRO
	RDCPU_ID_966T	$id, $tmp
	MRC p15, 0, $id, c0, c0 ,0
	MOV	$tmp, $id, LSL #16	; Clear bits 16-31
	MOV	$tmp, $tmp, LSR #20	; Move bits 15-3 to 12-0
	MEND

;Extract CPU Vendor from CPU Code register
;
	MACRO
	RDCPU_VENDOR_966T	$id, $tmp
	MRC p15, 0, $id, c0, c0 ,0
	MOV	$tmp, $id, LSR #24	; Move bits 31-24 to 7-0
	MEND

;Coprocessor read of Control register 
;
	MACRO
	RDMMU_STATE_966T $reg_number
	MRC p15, 0, $reg_number, c1, c0 ,0
	MEND

;Coprocessor write of Control register 
;
	MACRO 
	WRMMU_STATE_966T $reg_number
	MCR p15, 0, $reg_number, c1, c0 ,0
	MEND

;-----------------------------------------------------------
;Drain Write Buffer.
;
	MACRO
	WRCACHE_DrainWriteBuffer_966T $reg_number
	MCR p15, 0, $reg_number, c7, c10, 4
	MEND

;------------------------------------------------------------------
;Coprocessor test/clock/idle control 
;Enable Clock Switching
;
	MACRO
	WRCLK_EnableClockSW_966T	$reg
	MEND

;Coprocessor test/clock/idle control 
;Disable Clock Switching
;
	MACRO
	WRCLK_DisableClockSW_966T	$reg
	MEND

;Coprocessor test/clock/idle control 
;Disable nMCLK output
;
	MACRO
	WRCLK_DisablenMCLK_966T	$reg
	MEND

;Coprocessor test/clock/idle control 
;Wait for Interrupt
;
	MACRO
	WRTEST_WaitInt_966T	$reg
	MCR p15, 0, $reg_number, c7, c0, 4
	MEND

	END