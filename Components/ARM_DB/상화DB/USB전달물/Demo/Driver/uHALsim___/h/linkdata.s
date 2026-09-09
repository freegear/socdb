;/***************************************************************************
; * Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
; * Copyright © ARM Limited 1998.  All rights reserved.
; ***************************************************************************/
;******************************************************************************
;
;  Divorce names used in StrongARM core code from any linker-specifics.
;
;******************************************************************************/
;

	IMPORT	|Image$$RO$$Limit|	; ROM data starts after ROM program
	IMPORT	|Image$$RO$$Base|	; Start of ROM program
	IMPORT	|Image$$RW$$Base|	; Pre-initialised variables
	IMPORT	|Image$$ZI$$Base|	; uninitialised variables
	IMPORT	|Image$$ZI$$Limit|	; End of variable RAM space
	IMPORT	|uHAL_TTentries$$Base|	; Reserved space for MMU page tables
	IMPORT	|uHAL_TTentries$$Limit|	; Which must not be zero'd out

uHAL_StartOfROM	DCD	|Image$$RO$$Base|
uHAL_TopOfROM	DCD	|Image$$RO$$Limit|
uHAL_StartOfBSS	DCD	|Image$$RW$$Base|
uHAL_ZeroBSS	DCD	|Image$$ZI$$Base|
uHAL_EndOfBSS	DCD	|Image$$ZI$$Limit|
uHAL_NonZeroBSS	DCD	|uHAL_TTentries$$Base|
uHAL_EndOfNonZ	DCD	|uHAL_TTentries$$Limit|

	END				; End of file

