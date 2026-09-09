;/***************************************************************************
; * Copyright © ARM Limited 1999.  All rights reserved.
; ***************************************************************************/
;/*****************************************************************************
;
;   This file contains the COPROCESSOR access macros for the ARM7T processor
;
;******************************************************************************/

;Flag that this processor does not have an MMU
;
	MACRO
	CHECK_FOR_MMU_7T $tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Flag that this processor does not have an MPU
;
	MACRO
	CHECK_FOR_MPU_7T $tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Flag that this processor does not have a Cache
;
	MACRO
	CHECK_CACHE_7T	$tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Flag that this processor does not have a unified cache
;
	MACRO
	CHECK_UNIFIED_7T	$tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Compare (uHAL supplied) processor ID with ARM 7
;
	MACRO
	CHECK_CPUID_7T	$id, $tmp
	BICS	$tmp, $tmp, $tmp	; Clear tmp & set Z (FALSE)
	MEND

;Compare (uHAL supplied) processor Vendor ID with 'A'RM.
;
	MACRO
	CHECK_VENDOR_7T	$id, $tmp
	RDCPU_VENDOR	$id, $tmp
	CMP	$tmp, #0x41		; I'll have an 'A' please, Bob.
	MEND

;------------------------------------------------------------------
; All other macros are just the NO_BLAH defaults

	END
