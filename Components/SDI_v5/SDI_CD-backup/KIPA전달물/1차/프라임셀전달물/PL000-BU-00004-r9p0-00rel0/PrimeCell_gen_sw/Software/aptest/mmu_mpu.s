;//----------------------------------------------------------
;// Copyright: 
;// ----------------------------------------------------------------
;// This confidential and proprietary software may be used only as
;// authorised by a licensing agreement from ARM Limited
;//   (C) COPYRIGHT 2001 ARM Limited
;//       ALL RIGHTS RESERVED
;// The entire notice above must be reproduced on all authorised
;// copies and copies may only be made to the extent permitted
;// by a licensing agreement from ARM Limited.
;// ----------------------------------------------------------------
;// File:     mmu_mpu.s,v
;// Revision: 1.2
;// ----------------------------------------------------------------
;// 
;//  ----------------------------------------
;//  Version and Release Control Information:
;// 
;//  File Name              : mmu_mpu.s.rca
;//  File Revision          : 1.4
;// 
;//  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
;//  ----------------------------------------
;//
;// This file contains the initialisation code to set up the 
;// stacks pointers for the system.
;//----------------------------------------------------------

;//-------------------------------------------------------------------------------
;//----------------------------MMU/MPU DATA AREA----------------------------------
;//-------------------------------------------------------------------------------
;//The data here sets up the memory management areas.  These are listed below.  Each
;//must be at least 1MB in width.  The example below is suitable for an Integrator
;//platform.

    AREA     |MMU_MPU|, DATA, READONLY

MMU_MPU_RegionData                  ;//REQUIRED LABEL AT START OF DATA
    
    ;//Insert the data here, in the format
    ;//DCD <<Start address in MB>>
    ;//DCD <<Width in MB>>
    ;//DCB <<Non-zero if cacheable>>
    ;//DCB <<Non-zero if bufferable>>
    ;//DCB <<Non-zero if readable>>
    ;//DCB <<Non-zero if writeable>>  
    
    ;//Background region coves all of memory
    DCD 0                   ;//Starting address in MB
    DCD 4096                ;//Width in MB
    DCB 0,0,1,1             ;//Cache, buffer, readable, writeable

    ;//RAM region coves normal memory
    DCD 0                   ;//Starting address in MB
    DCD 256                 ;//Width in MB
    DCB 1,0,1,1             ;//Cache, buffer, readable, writeable

    ;//ROM region coves flash
    DCD 512                 ;//Starting address in MB
    DCD 128                 ;//Width in MB
    DCB 1,0,1,0             ;//Cache, buffer, readable, writeable

MMU_MPU_RegionDataEnd               ;//REQUIRED LABEL AT END OF DATA

NumRegions         EQU    (MMU_MPU_RegionDataEnd-MMU_MPU_RegionData)/12
    EXPORT MMU_MPU_RegionData
    EXPORT MMU_MPU_RegionDataEnd
    EXPORT NumRegions

    END