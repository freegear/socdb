;/***************************************************************************
; * Copyright © ARM Limited 1998, 1999.  All rights reserved.
; ***************************************************************************/
;/*****************************************************************************
;
;   This file contains dummy COPROCESSOR macros for MMU access on
;	processors which don't have one.
;
;	$Id: nommu.s,v 1.2 1999/07/07 16:56:03 drusling Exp $
;
;******************************************************************************/

;Default is this processor does not have an MMU
;
	MACRO
	NO_CHECK_FOR_MMU	$tmp
	BICS	$tmp, $tmp, $tmp	; Default - Clear tmp & set Z (FALSE)
	MEND

;Default is this processor does not have an MPU
;
	MACRO
	NO_CHECK_FOR_MPU	$tmp
	BICS	$tmp, $tmp, $tmp	; Default - Clear tmp & set Z (FALSE)
	MEND

;Default is this processor does not have a Cache
;
	MACRO
	NO_CHECK_CACHE	$tmp
	BICS	$tmp, $tmp, $tmp	; Default - Clear tmp & set Z (FALSE)
	MEND

;Default is this processor does not have a unified cache
;
	MACRO
	NO_CHECK_UNIFIED	$tmp
	BICS	$tmp, $tmp, $tmp	; Default - Clear tmp & set Z (FALSE)
	MEND

;Default is to compare processor ID with ARM 7
;
	MACRO
	NO_CHECK_CPUID	$id, $tmp
	NO_RDCPU_ID	$id, $tmp
	CMP	$tmp, #0x7		; set Z if it is an ARM 7
	MEND

;Default is to compare this processor Vendor ID with 'A'RM
;
	MACRO
	NO_CHECK_VENDOR	$id, $tmp
	NO_RDCPU_VENDOR	$id, $tmp
	CMP	$tmp, #0x41		; I'll have an 'A' please, Bob.
	MEND

;------------------------------------------------------------------
;Macros to hide the internals of cache implementation on each processor
;
	MACRO
	NO_CLEAR_IDC	$state
	MEND

	MACRO
	NO_CLEAR_ICACHE	$state
	MEND

	MACRO
	NO_CLEAR_DCACHE	$state
	MEND

	MACRO
	NO_CLEAR_WBUFFER	$state
	MEND

	MACRO
	NO_CLEAR_MMU	$state
	MEND

	MACRO
	NO_CLEAR_BIGEND	$state
	MEND


	MACRO
        NO_SET_IDC	$state
	MEND

	MACRO
        NO_SET_ICACHE	$state
	MEND

	MACRO
        NO_SET_DCACHE	$state
	MEND

	MACRO
	NO_SET_WBUFFER	$state
	MEND

	MACRO
	NO_SET_MMU	$state
	MEND

	MACRO
	NO_SET_BIGEND	$state
	MEND

	MACRO
	NO_TEST_MMU	$tmp
	BICS	$tmp, $tmp, $tmp	; Default - Clear tmp & set Z (FALSE)
	MEND

	MACRO
	NO_TEST_BIGEND	$tmp
	BICS	$tmp, $tmp, $tmp	; Default - Clear tmp & set Z (FALSE)
	MEND

;------------------------------------------------------------------
;Coprocessor read of ID register 
;
	MACRO
	NO_RDCPU_CODE	$reg
	MOV	$reg, #0x00000070	; Pretend it's a 7T
	ORR	$reg, $reg, #0x41000000	; Pretend it's an 'A'RM
	MEND

	MACRO
	NO_RDCPU_ID	$reg, $val
	MOV	$val, #0x7		; Pretend it's a 7T
	MEND

	MACRO
	NO_RDCPU_VENDOR	$reg, $val
	MOV	$val, #0x41		; Pretend it's an 'A'RM
	MEND

;Coprocessor read of ID register (cache line sizes)
;
	MACRO
	NO_RDCACHE_SIZES $reg_number
	MOV	$reg_number, #0			; Pretend 0 size cache
	MEND

;Coprocessor read of Control register 
;
	MACRO
	NO_RDMMU_STATE $reg_number
	MOV	$reg_number, #0			; Pretend all off
	MEND

;Coprocessor write of Control register 
;
	MACRO 
	NO_WRMMU_STATE $reg_number
	MEND

;Coprocessor read of Translation Table Base reg. 
;
	MACRO
	NO_RDMMU_TTBase $reg_number
	MEND

;Coprocessor write of Translation Table Base reg. 
;
	MACRO 
	NO_WRMMU_TTBase $reg_number
	MEND

;Coprocessor read of Domain Access Control reg. 
;
	MACRO
	NO_RDMMU_DAControl $reg_number
	MEND

;Coprocessor write of Domain Access Control reg. 
;
	MACRO 
	NO_WRMMU_DAControl $reg_number
	MEND

;Coprocessor read of Fault Status register 
;
    MACRO
    NO_RDMMU_FaultStatus $reg
    MOV	$reg, #0
    MEND

;Coprocessor write of Fault Status register 
;
    MACRO 
    NO_WRMMU_FaultStatus $reg
    MEND

;Coprocessor read of Fault Address register 
;
    MACRO
    NO_RDMMU_FaultAddress $reg
    MOV	$reg, #0
    MEND

;Coprocessor write of Fault Address register 
;
    MACRO 
    NO_WRMMU_FaultAddress $reg
    MEND

;Flush TLB 
;
	MACRO
	NO_WRMMU_FlushTB $reg_number
	MEND

;Flush Instruction TLB 
;
	MACRO
	NO_WRMMU_FlushITB $reg_number
	MEND

;Flush Data TLB
;
	MACRO
	NO_WRMMU_FlushDTB $reg_number
	MEND

;-----------------------------------------------------------
; MPU support macros:

;Coprocessor write of MPU cache bits 
;
	MACRO 
	NO_WRMPU_CacheBits $reg_number
	MEND

;Coprocessor write of MPU buffer bits 
;
	MACRO 
	NO_WRMPU_BufferBits $reg_number
	MEND

;Coprocessor write of MPU access bits 
;
	MACRO 
	NO_WRMPU_AccessBits $reg_number
	MEND

;Coprocessor write of MPU region registors 
;
	MACRO 
	NO_WRMPU_Region $region, $reg_number
	MEND

;-----------------------------------------------------------
;Coprocessor cache control 
;Flush I & D Caches
;
	MACRO 
	NO_WRCACHE_FlushIDC $reg_number
	MEND

;Coprocessor cache control 
;Flush ICache
;
	MACRO 
	NO_WRCACHE_FlushIC $reg_number
	MEND

;Coprocessor cache control 
;Flush DCache
;
	MACRO 
	NO_WRCACHE_FlushDC $reg_number
	MEND

;Coprocessor cache control 
;Flush DCache entry
;
	MACRO 
	NO_WRCACHE_CacheFlushDentry $reg_number
	MEND

;Coprocessor cache control 
;Clean DCache entry
;
	MACRO 
	NO_WRCACHE_CleanDCentry $reg_number
	MEND

;Coprocessor cache control 
;Clean + Flush DCache entry
;
	MACRO 
	NO_WRCACHE_Clean_FlushDCentry $reg_number
	MEND

;Drain Write Buffer.
;
	MACRO
	NO_WRCACHE_DrainWriteBuffer $reg_number
	MEND

;Clean DCache (only) from address in $reg1 to (excl) addr in $reg2
;
	MACRO
	NO_WRCACHE_CleanDrange	$reg1, $reg2
	MEND

;Clean all DCache 
;
	MACRO
	NO_WRCACHE_CleanDCache	$w1, $w2, $w3, $w4, $w5, $w6
	MEND
;------------------------------------------------------------------
;Coprocessor test/clock/idle control 
;Enable Clock Switching
;
	MACRO
	NO_WRCLK_EnableClockSW $reg_number
	MEND

;Coprocessor test/clock/idle control 
;Disable Clock Switching
;
	MACRO
	NO_WRCLK_DisableClockSW $reg_number
	MEND

;Coprocessor test/clock/idle control 
;Disable nMCLK output
;
	MACRO
	NO_WRCLK_DisablenMCLK $reg_number
	MEND

;Coprocessor test/clock/idle control 
;Wait for Interrupt
;
	MACRO
	NO_WRCLK_WaitInt $reg_number
	MEND

;-----------------------------------------------------------
; MPU setup macro and variables
;

	MACRO
	NO_SET_MPU_REGION	$num, $address, $size, $access
	MEND

	END
