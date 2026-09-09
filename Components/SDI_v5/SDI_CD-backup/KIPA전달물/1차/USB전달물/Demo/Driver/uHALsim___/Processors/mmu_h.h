
/* DO NOT EDIT!! - this file automatically generated
 *                 from .s file by awk -f s2h.awk
 */
/***************************************************************************
 *  * Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
 *  * Copyright © ARM Limited 1998, 1999.  All rights reserved.
 * 
 * ****************************************************************************
 * 
 *   ARM Processor MMU/MPU specifics	- constants, registers etc.
 * 
 * 	$Id: mmu_h.h,v 1.4 1999/11/17 10:31:17 drusling Exp $
 * 
 * ***************************************************************************/


#ifndef __mmu_h
#define __mmu_h                         1

/* Sizes, used for Page Tables if Processor supports them */
#define L1_TABLE_ENTRIES                0x1000	 /*  4GB/1MB -> 4096 word entries  */
#define L2_ENTRY_SIZE                   256

/*  Allow different cache sizes - SA1100
 */
#ifndef DCACHE_SIZE
#define DCACHE_SIZE                     0x4000   /*  16kB Dcache */
#endif

#define DCACHE_LINE                     0x20	 /*  32B cache line entry */

#define L2_CONTROL                      0x1	 /*  domain0, page table pointer */

/*  Access Permissions
 *  Depending on the setup, 0 represents one of these two access permissions
 */
#define AP_NO_ACCESS                    0
#define AP_SVC_R                        0
#define AP_SVC_RW                       1
#define AP_NO_USR_W                     2
#define AP_ALL_ACCESS                   3

#define L1_NO_ACCESS                    (AP_NO_ACCESS  << 10)
#define L1_SVC_R                        (AP_SVC_R      << 10)
#define L1_SVC_RW                       (AP_SVC_RW     << 10)
#define L1_NO_USR_W                     (AP_NO_USR_W   << 10)
#define L1_ALL_ACCESS                   (AP_ALL_ACCESS << 10)

/*  Level 2 Tiny descriptors only have 1 set of Access Permissions
 */
#define L2T_NO_ACCESS                   (AP_NO_ACCESS  << 4)
#define L2T_SVC_R                       (AP_SVC_R      << 4)
#define L2T_SVC_RW                      (AP_SVC_RW     << 4)
#define L2T_NO_USR_W                    (AP_NO_USR_W   << 4)
#define L2T_ALL_ACCESS                  (AP_ALL_ACCESS << 4)

#define L2_NO_ACCESS                    L1_NO_ACCESS  + (AP_NO_ACCESS  << 8) + (AP_NO_ACCESS  << 6) + L2T_NO_ACCESS
#define L2_SVC_R                        L1_SVC_R      + (AP_SVC_R      << 8) + (AP_SVC_R      << 6) + L2T_SVC_R
#define L2_SVC_RW                       L1_SVC_RW     + (AP_SVC_RW     << 8) + (AP_SVC_RW     << 6) + L2T_SVC_RW
#define L2_NO_USR_W                     L1_NO_USR_W   + (AP_NO_USR_W   << 8) + (AP_NO_USR_W   << 6) + L2T_NO_USR_W
#define L2_ALL_ACCESS                   L1_ALL_ACCESS + (AP_ALL_ACCESS << 8) + (AP_ALL_ACCESS << 6) + L2T_ALL_ACCESS

#define PT_C_BIT                        (1 << 3)
#define PT_B_BIT                        (1 << 2)
#define PT_CB_BITS                      (PT_C_BIT + PT_B_BIT)


/*  Level1 Entry types
 */
#define PT_INVALID                      0	 /*  Fault */
#define PT_PAGE                         1	 /*  Level2 pointer */
#define PT_SECTION                      2	 /*  Simple 1MB section */
#define PT_FINE                         3	 /*  Level2 pointer to fine table */

/*  Level2 Entry types
 *  PT_PAGE tables have 256 entries (256 x 4KB = 1MB).
 * 	To use a PT_LARGE, each large descriptor must be repeated in 16
 * 	consecutive entries. NOTE: NO tiny entries!
 *  PT_FINE tables have 1024 entries (1024 x 1KB = 1MB). 
 * 	PT_LARGE thus require 64 consecutive entries and
 * 	PT_SMALL require 4 consecutive entries
 */
#define PT_LARGE                        1	 /*  64KB */
#define PT_SMALL                        2	 /*  4KB each */
#define PT_TINY                         3	 /*  1KB each */


/*  uHAL uses domain 0.
 */
#define uHAL_DOMAIN                     0
#define PT_DOMAIN                       (uHAL_DOMAIN << 5)

/* DRAM_ACCESS		EQU	0xC0E	; AP=11, domain0, C=1, B=1
 */
#define DRAM_ACCESS                     (L1_ALL_ACCESS + PT_DOMAIN + PT_CB_BITS + PT_SECTION)
/*  Non-cached, buffered access
 */
#define NCDRAM_ACCESS                   (L1_ALL_ACCESS + PT_DOMAIN + PT_B_BIT + PT_SECTION)
/* FLASH_ACCESS		EQU	0x80A	; AP=10, domain0, C=1, B=0
 */
#define FLASH_ACCESS                    (L1_NO_USR_W + PT_DOMAIN + PT_C_BIT + PT_SECTION)
/* IO_ACCESS		EQU	0xC02	; AP=11, domain0, C=0, B=0
 */
#define IO_ACCESS                       (L1_ALL_ACCESS + PT_DOMAIN + PT_SECTION)
#define SSRAM_ACCESS                    0x0FFD	 /*  AP=11, domain0, C=1, B=1 */
/* EPROM_ACCESS		EQU	0x0AA9	; AP=10, domain0, C=1, B=0
 */
#define EPROM_PAGE                      (PT_DOMAIN + PT_PAGE)
#define EPROM_ACCESS                    (L2_NO_USR_W + PT_C_BIT + PT_LARGE)


/*  Definitions used in conditional assembly of Icache, Dcache and Write Buffer
 *  options
 */

#define IC_ON                           0x1000
#define IC_OFF                          0x0

#define DC_ON                           0x4
#define DC_OFF                          0x0

#define WB_ON                           0x8
#define WB_OFF                          0x0


/*  Bit definitions for the control register: 
 */

/*  enables are logically OR'd with the control register
 *  use bit clears (BIC's) to disable functions 
 * 	*** all bits cleared on RESET ***
 */

#define EnableMMU                       0x1
#define EnableAlignFault                0x2
#define EnableDcache                    0x4
#define EnableWB                        0x8
#define EnableBigEndian                 0x80
#define EnableMMU_S                     0x100		 /*  selects MMU access checks  */
#define EnableMMU_R                     0x200		 /*  selects MMU access checks  */
#define EnableIcache                    0x1000

#define EnableUcache                    0x4		 /*  Unified Cache */

/* ------------------------------------------------------------------
 *  MPU Mapping table definitions
 * 
 */
#define MPU_REGIONS                     8	 /*  Number of MPU regions */
#define MPU_CACHE_OFFSET                (MPU_REGIONS * 4)
#define MPU_BUFFER_OFFSET               ((MPU_REGIONS + 1) * 4)
#define MPU_ACCESS_OFFSET               ((MPU_REGIONS + 2) * 4)
#define MPU_TABLE_ENTRIES               (MPU_REGIONS + 3)  /*  regions + 3 bit flags */

/*  MPU memory region sizes
 * 
 */
#define MPU_SZ_4K                       0x0B
#define MPU_SZ_8K                       0x0C
#define MPU_SZ_16K                      0x0D
#define MPU_SZ_32K                      0x0E
#define MPU_SZ_64K                      0x0F
#define MPU_SZ_128K                     0x10
#define MPU_SZ_256K                     0x11
#define MPU_SZ_512K                     0x12
#define MPU_SZ_1M                       0x13
#define MPU_SZ_2M                       0x14
#define MPU_SZ_4M                       0x15
#define MPU_SZ_8M                       0x16
#define MPU_SZ_16M                      0x17
#define MPU_SZ_32M                      0x18
#define MPU_SZ_64M                      0x19
#define MPU_SZ_128M                     0x1A
#define MPU_SZ_256M                     0x1B
#define MPU_SZ_512M                     0x1C
#define MPU_SZ_1G                       0x1D
#define MPU_SZ_2G                       0x1E
#define MPU_SZ_4G                       0x1F

#endif

/* 	END */
