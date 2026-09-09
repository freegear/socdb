;// Copyright: 
;// ----------------------------------------------------------------
;// This confidential and proprietary software may be used only as
;// authorised by a licensing agreement from ARM Limited
;//   (C) COPYRIGHT 2000,2001 ARM Limited
;//       ALL RIGHTS RESERVED
;// The entire notice above must be reproduced on all authorised
;// copies and copies may only be made to the extent permitted
;// by a licensing agreement from ARM Limited.
;// ----------------------------------------------------------------
;// File:     pagetab.s,v
;// Revision: 1.4
;// ----------------------------------------------------------------
;// 
;//  ----------------------------------------
;//  Version and Release Control Information:
;// 
;//  File Name              : pagetab.s.rca
;//  File Revision          : 1.9
;// 
;//  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
;//  ----------------------------------------
;//
;// This module reserves space for a minimal page table if an ARMx20
;//architecture is being used.  It is not otherwise required
;//

	AREA	MMU_TABLE, CODE, ALIGN=14
	EXPORT	MMU_PageTable
	
MMU_PageTable
	%	0x4000
MMU_PageTableEnd
    
    END
