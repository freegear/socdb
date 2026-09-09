;/***************************************************************************
; * Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
; * Copyright © ARM Limited 1998, 1999.  All rights reserved.
;
;****************************************************************************
;
;  ARM Processor MMU/MPU specifics	- constants, registers etc.
;
;	$Id: mmu_h.s,v 1.3 1999/07/09 15:02:52 mwelsh Exp $
;
;***************************************************************************/


 IF :LNOT: :DEF: __mmu_h
__mmu_h             EQU     1

; /* Sizes, used for Page Tables if Processor supports them */
L1_TABLE_ENTRIES	EQU	0x1000	; 4GB/1MB -> 4096 word entries 
L2_ENTRY_SIZE	EQU	256

 ; Allow different cache sizes - SA1100
 IF :LNOT: :DEF: DCACHE_SIZE
DCACHE_SIZE		EQU	0x4000  ; 16kB Dcache
 ENDIF

DCACHE_LINE		EQU	0x20	; 32B cache line entry

L2_CONTROL		EQU	0x1	; domain0, page table pointer

; Access Permissions
; Depending on the setup, 0 represents one of these two access permissions
AP_NO_ACCESS		EQU	0
AP_SVC_R		EQU	0
AP_SVC_RW		EQU	1
AP_NO_USR_W		EQU	2
AP_ALL_ACCESS		EQU	3

L1_NO_ACCESS		EQU	(AP_NO_ACCESS  << 10)
L1_SVC_R		EQU	(AP_SVC_R      << 10)
L1_SVC_RW		EQU	(AP_SVC_RW     << 10)
L1_NO_USR_W		EQU	(AP_NO_USR_W   << 10)
L1_ALL_ACCESS		EQU	(AP_ALL_ACCESS << 10)

; Level 2 Tiny descriptors only have 1 set of Access Permissions
L2T_NO_ACCESS		EQU	(AP_NO_ACCESS  << 4)
L2T_SVC_R		EQU	(AP_SVC_R      << 4)
L2T_SVC_RW		EQU	(AP_SVC_RW     << 4)
L2T_NO_USR_W		EQU	(AP_NO_USR_W   << 4)
L2T_ALL_ACCESS		EQU	(AP_ALL_ACCESS << 4)

L2_NO_ACCESS		EQU	L1_NO_ACCESS  + (AP_NO_ACCESS  << 8) + (AP_NO_ACCESS  << 6) + L2T_NO_ACCESS
L2_SVC_R		EQU	L1_SVC_R      + (AP_SVC_R      << 8) + (AP_SVC_R      << 6) + L2T_SVC_R
L2_SVC_RW		EQU	L1_SVC_RW     + (AP_SVC_RW     << 8) + (AP_SVC_RW     << 6) + L2T_SVC_RW
L2_NO_USR_W		EQU	L1_NO_USR_W   + (AP_NO_USR_W   << 8) + (AP_NO_USR_W   << 6) + L2T_NO_USR_W
L2_ALL_ACCESS		EQU	L1_ALL_ACCESS + (AP_ALL_ACCESS << 8) + (AP_ALL_ACCESS << 6) + L2T_ALL_ACCESS

PT_C_BIT		EQU	(1 << 3)
PT_B_BIT		EQU	(1 << 2)
PT_CB_BITS		EQU	(PT_C_BIT + PT_B_BIT)


; Level1 Entry types
PT_INVALID		EQU	0	; Fault
PT_PAGE			EQU	1	; Level2 pointer
PT_SECTION		EQU	2	; Simple 1MB section
PT_FINE			EQU	3	; Level2 pointer to fine table

; Level2 Entry types
; PT_PAGE tables have 256 entries (256 x 4KB = 1MB).
;	To use a PT_LARGE, each large descriptor must be repeated in 16
;	consecutive entries. NOTE: NO tiny entries!
; PT_FINE tables have 1024 entries (1024 x 1KB = 1MB). 
;	PT_LARGE thus require 64 consecutive entries and
;	PT_SMALL require 4 consecutive entries
PT_LARGE		EQU	1	; 64KB
PT_SMALL		EQU	2	; 4KB each
PT_TINY			EQU	3	; 1KB each


; uHAL uses domain 0.
uHAL_DOMAIN		EQU	0
PT_DOMAIN		EQU	(uHAL_DOMAIN << 5)

;DRAM_ACCESS		EQU	0xC0E	; AP=11, domain0, C=1, B=1
DRAM_ACCESS		EQU	(L1_ALL_ACCESS + PT_DOMAIN + PT_CB_BITS + PT_SECTION)
; Non-cached, buffered access
NCDRAM_ACCESS		EQU	(L1_ALL_ACCESS + PT_DOMAIN + PT_B_BIT + PT_SECTION)
;FLASH_ACCESS		EQU	0x80A	; AP=10, domain0, C=1, B=0
FLASH_ACCESS		EQU	(L1_NO_USR_W + PT_DOMAIN + PT_C_BIT + PT_SECTION)
;IO_ACCESS		EQU	0xC02	; AP=11, domain0, C=0, B=0
IO_ACCESS		EQU	(L1_ALL_ACCESS + PT_DOMAIN + PT_SECTION)
SSRAM_ACCESS		EQU	0x0FFD	; AP=11, domain0, C=1, B=1
;EPROM_ACCESS		EQU	0x0AA9	; AP=10, domain0, C=1, B=0
EPROM_PAGE		EQU	(PT_DOMAIN + PT_PAGE)
EPROM_ACCESS		EQU	(L2_NO_USR_W + PT_C_BIT + PT_LARGE)


; Definitions used in conditional assembly of Icache, Dcache and Write Buffer
; options

IC_ON		EQU	0x1000
IC_OFF		EQU	0x0

DC_ON		EQU	0x4
DC_OFF		EQU	0x0

WB_ON		EQU	0x8
WB_OFF		EQU	0x0


; Bit definitions for the control register: 

; enables are logically OR'd with the control register
; use bit clears (BIC's) to disable functions 
;	*** all bits cleared on RESET ***

EnableMMU		EQU	0x1
EnableAlignFault	EQU	0x2
EnableDcache		EQU	0x4
EnableWB		EQU	0x8
EnableBigEndian		EQU	0x80
EnableMMU_S		EQU	0x100		; selects MMU access checks 
EnableMMU_R		EQU	0x200		; selects MMU access checks 
EnableIcache		EQU	0x1000

EnableUcache		EQU	0x4		; Unified Cache

;------------------------------------------------------------------
; MPU Mapping table definitions
;
MPU_REGIONS		EQU	8	; Number of MPU regions
MPU_CACHE_OFFSET	EQU	(MPU_REGIONS * 4)
MPU_BUFFER_OFFSET	EQU	((MPU_REGIONS + 1) * 4)
MPU_ACCESS_OFFSET	EQU	((MPU_REGIONS + 2) * 4)
MPU_TABLE_ENTRIES	EQU	(MPU_REGIONS + 3) ; regions + 3 bit flags

; MPU memory region sizes
;
MPU_SZ_4K	EQU 0x0B
MPU_SZ_8K	EQU 0x0C
MPU_SZ_16K	EQU 0x0D
MPU_SZ_32K	EQU 0x0E
MPU_SZ_64K	EQU 0x0F
MPU_SZ_128K	EQU 0x10
MPU_SZ_256K	EQU 0x11
MPU_SZ_512K	EQU 0x12
MPU_SZ_1M	EQU 0x13
MPU_SZ_2M	EQU 0x14
MPU_SZ_4M	EQU 0x15
MPU_SZ_8M	EQU 0x16
MPU_SZ_16M	EQU 0x17
MPU_SZ_32M	EQU 0x18
MPU_SZ_64M	EQU 0x19
MPU_SZ_128M	EQU 0x1A
MPU_SZ_256M	EQU 0x1B
MPU_SZ_512M	EQU 0x1C
MPU_SZ_1G	EQU 0x1D
MPU_SZ_2G	EQU 0x1E
MPU_SZ_4G	EQU 0x1F

 ENDIF

	END
