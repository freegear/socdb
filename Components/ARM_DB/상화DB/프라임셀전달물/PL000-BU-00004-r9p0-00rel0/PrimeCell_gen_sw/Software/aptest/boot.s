;//----------------------------------------------------------
;// Copyright: 
;// ----------------------------------------------------------------
;// This confidential and proprietary software may be used only as
;// authorised by a licensing agreement from ARM Limited
;//   (C) COPYRIGHT 2002,2000,2001 ARM Limited
;//       ALL RIGHTS RESERVED
;// The entire notice above must be reproduced on all authorised
;// copies and copies may only be made to the extent permitted
;// by a licensing agreement from ARM Limited.
;// ----------------------------------------------------------------
;// File:     boot.s,v
;// Revision: 1.19
;// ----------------------------------------------------------------
;// 
;//  ----------------------------------------
;//  Version and Release Control Information:
;// 
;//  File Name              : boot.s.rca
;//  File Revision          : 1.10
;// 
;//  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
;//  ----------------------------------------
;//
;// This file contains the initialisation code to set up the 
;// stacks pointers for the system.
;//----------------------------------------------------------

     INCLUDE    SYSDefs.h
     
     GBLS    CACHE_BUILD
;//By default, caches are set up according to the processor specified in the build,
;//but this can be manually changed here to (e.g. "ARM920T")
CACHE_BUILD SETS    {CPU}
    
;//-------------------------------------------------------------------------------
;//----------------------------BOOT AREA------------------------------------------
;//-------------------------------------------------------------------------------

    AREA     |BOOT|, CODE, READONLY

    EXPORT   |BOOT|
    EXPORT    apBOOT_BootCode
    KEEP    apBOOT_BootCode  ;//We use 'KEEP' rather than 'ENTRY' to keep SDT compatibility
    
    ;//Import the data from the file 'mmu_mpu.s' specifying the memory configuration
    IF CACHE_BUILD="ARM940T" :LOR: CACHE_BUILD="ARM740T" :LOR: CACHE_BUILD="ARM920T" :LOR: CACHE_BUILD="ARM720T" :LOR: CACHE_BUILD="ARM926EJ-S"
        IMPORT MMU_MPU_RegionDataEnd
        IMPORT MMU_MPU_RegionData
        IMPORT NumRegions
    ENDIF
    
    ;//Calculate the stack details
Total_Stack        EQU    FIQ_Size + IRQ_Size + ABT_Size + UND_Size + SVC_Size + USR_Size
    
    ;//Import the linker labels specifying code locations
    IMPORT   |Image$$ZI$$Limit| [WEAK]              ;//defined for a non-scatterloaded build
    IMPORT   |Image$$STACK_END$$Base| [WEAK]
    IMPORT   |Image$$HEAP$$ZI$$Limit| [WEAK]
    IMPORT   |Image$$RAM$$ZI$$Limit| [WEAK]

    CODE32
    
apBOOT_BootCode

;//-------------------------------------------------------------------------------
;//----------------------------STACK SETUP----------------------------------------
;//-------------------------------------------------------------------------------

    ;//Place the top of the stack one byte below the STACK_END base
    LDR    R1,=|Image$$STACK_END$$Base|
    CMP    R1,#0
    SUB    R1,R1,#1
    BNE    StackFound
    ;//Or place the top of the stack above the heap in the HEAP area
    LDR    R1,=|Image$$HEAP$$ZI$$Limit|
    CMP    R1,#0
    ;//Or in the RAM area
    LDREQ  R1,=|Image$$RAM$$ZI$$Limit|
    CMP    R1,#0
    ;//Or in the main area
    LDREQ  R1,=|Image$$ZI$$Limit|
    CMP    R1,#0
    LDRNE    R2,=Heap_Size+Total_Stack
    ADDNE  R1,R1,R2
    BNE    StackFound
    ;//Otherwise we have nowhere to put the heap.  The code hangs here.
InvalidStackHeap
    BEQ    InvalidStackHeap
    
StackFound
;// --- Initialise stack pointer registers
;// Enter FIQ mode and set up the FIQ stack pointer
    MOV    R0, #Mode_FIQ32:OR:I_Bit:OR:F_Bit ;// No interrupts
    MSR    CPSR_cxsf, R0
    MOV    R13,R1
    SUB    R1,R1,#FIQ_Size

;// Also initialise FIQ registers
    MOV    r8, #0
    MOV    r9, #0
    MOV    r10, #0
    MOV    r11, #0
    MOV    r12, #0

;// Enter IRQ mode and set up the IRQ stack pointer
    MOV    R0, #Mode_IRQ32:OR:I_Bit:OR:F_Bit ;// No interrupts
    MSR    CPSR_cxsf, R0
    MOV    R13,R1
    SUB    R1,R1,#IRQ_Size
    
;// Enter Abort mode and set up the Abort stack pointer
    MOV    R0, #Mode_ABT32:OR:I_Bit:OR:F_Bit ;// No interrupts
    MSR    CPSR_cxsf, R0
    MOV    R13,R1
    SUB    R1,R1,#ABT_Size

;// Enter Undefined mode and set up the Undefined stack pointer
    MOV    R0, #Mode_UND32:OR:I_Bit:OR:F_Bit ;// No interrupts
    MSR    CPSR_cxsf, R0
    MOV    R13,R1
    SUB    R1,R1,#UND_Size

;// Set up the SVC stack pointer last and return to SVC mode
    MOV    R0, #Mode_SVC32:OR:I_Bit:OR:F_Bit ;// No interrupts
    MSR    CPSR_cxsf, R0
    MOV    R13,R1
    SUB    R1,R1,#SVC_Size
        
;// Set up the USR stack pointer last and run code in SYS mode
    MOV    R0, #Mode_SYS32:OR:I_Bit:OR:F_Bit ;// No interrupts
    MSR    CPSR_cxsf, R0
    MOV    R13,R1    

;//-------------------------------------------------------------------------------
;//----------------------------CACHE/MMU SETUP------------------------------------
;//-------------------------------------------------------------------------------
;//The caches and MMU/MPU are set up.  Note that the assembler must be set to the
;//correct core, as the code is switched by the CACHE_BUILD constant

    INFO 0,"------------------------------------"
    INFO 0,"Cache/MMU code built for ":CC:CACHE_BUILD
    INFO 0,"Change assembler options to include\ncache code for a different core"
    INFO 0,"------------------------------------"
        
;//----------------------------MPU SETUP (ARM*40T)--------------------------------
    IF CACHE_BUILD="ARM940T" :LOR: CACHE_BUILD="ARM740T"
    
        ;// Read the current value of the MMU control register 
        MRC     p15, 0, R0, c1, c0, 0
    
        ;// Set Asynchronous bus mode 
        ORR     R0, R0, #(3 << 30)
        MCR     p15, 0, R0, c1, c0, 0
    
        ;// Disable caches and MMU 
        BIC     R0, R0, #(1 << 12)
        BIC     R0, R0, #(1 << 2) :OR: (1 << 0)
        MCR     p15, 0, R0, c1, c0, 0
        NOP
        NOP
        NOP
    
        ;//Cycle through each memory region
        MOV     R9,#NumRegions          ;//region counter
        SUB     R9,R9,#1
        LDR     R12,=MMU_MPU_RegionDataEnd
    
        MOV     R2,#0                   ;//stores the caching data
        MOV     R3,#0                   ;//stores the buffering data
        MOV     R5,#0                   ;//stores the protection data
        
NextRegion
        SUB     R12,R12,#12
        LDR     R0,[R12,#4]             ;//read the region width
        ;//convert into encoding used (0x26 = 1MB...)
        MOV     R1,#0x24
NextWidth        
        ADD     R1,R1,#2
        MOVS    R0,R0,LSR #1
        BNE     NextWidth
        LDR     R0,[R12,#0]             ;//read the base address
        ORR     R1,R1,R0,LSL # 20
        ORR     R1,R1,#1                ;//enabled
        
        ;//We need to write the region number into the register shown as 'c0'
        ;//in the instructions at SetRegion.  Self-modifying code saves writing
        ;//separate instructions for c0,c1,c2,...
        LDR     R7,=SetRegion
        LDR     R0,[R7]                 ;//modify the first (Icache) instruction
        BIC     R0,R0,#15
        ORR     R0,R0,R9
        STR     R0,[R7],#4
        IF CACHE_BUILD="ARM940T"        ;//A 740 has unified cache so this isn't needed
            LDR     R0,[R7]             ;//modify the second (Dcache) instruction
            BIC     R0,R0,#15
            ORR     R0,R0,R9
            STR     R0,[R7]
        ENDIF
        BL      SetRegion
        
        ;//Set up caching data
        MOV     R2,R2,LSL #1
        LDRB    R0,[R12,#8]
        CMP     R0,#0
        ORRNE   R2,R2,#1

        ;//Set up buffering data
        MOV     R3,R3,LSL #1
        LDRB    R0,[R12,#9]
        CMP     R0,#0
        ORRNE   R3,R3,#1

        ;//Set up read/write data
        MOV     R5,R5,LSL #2
        LDRB    R0,[R12,#10]
        CMP     R0,#0
        ORR     R5,R5,#2                    ;//read access
        LDRB    R0,[R12,#11]
        CMP     R0,#0
        ORRNE   R5,R5,#1                    ;//write access
        
        ;//now do the next region
        SUBS    R9,R9,#1
        BPL     NextRegion
    
        ;// Enable caching, buffering and protection
        MCR p15, 0, R2, c2, c0, 0
        MCR p15, 0, R3, c3, c0, 0
        MCR p15, 0, R5, c5, c0, 0
        IF CACHE_BUILD="ARM940T"
            MCR p15, 0, R2, c2, c0, 1
            MCR p15, 0, R3, c3, c0, 1
            MCR p15, 0, R5, c5, c0, 1
        ENDIF
    
        ;// Flush all of both caches 
        MOV     R0,#0
        MCR     p15, 0, R0, c7, c7, 0
    
        ;// Enable MPU 
        ORR     R0, R0, #(1 << 0)
        MCR     p15, 0, R0, c1, c0, 0
        NOP
        NOP
        NOP
    
        ;// Enable both caches 
        ORR     R0, R0, #(1 << 12)
        ORR     R0,R0,  #(1 << 2)
        MCR     p15, 0, R0, c1, c0, 0
        NOP
        NOP
        NOP
    ENDIF

;//----------------------------MMU SETUP (ARM*20T)--------------------------------
    IF CACHE_BUILD="ARM920T" :LOR: CACHE_BUILD="ARM720T" :LOR: CACHE_BUILD="ARM926EJ-S"
        ;//The page table is built in the area MMU_TABLE in the assembler file pagetab.s
         
        IMPORT MMU_PageTable;
        
        ;//Set basic rules of access in R2
        MOV     R2,#3 << 10             ;//Read/write access
        ORR     R2,R2, #0x2             ;//Section descriptor

        ;//Step through all the regions
        MOV     R9,#0                   ;//region counter
        LDR     R12,=MMU_MPU_RegionData

NextRegionMMU
        LDR     R0,[R12,#0]             ;//read the region base
        LDR     R1,[R12,#4]             ;//read the region width

        ;//set up the access details
        MOV     R3,#0x2                 ;//section descriptor
        
        ;//Set up caching data
        LDRB    R2,[R12,#8]
        CMP     R2,#0
        ORRNE   R3,R3,#1<<3

        ;//Set up buffering data
        LDRB    R2,[R12,#9]
        CMP     R2,#0
        ORRNE   R3,R3,#1<<2

        ;//Set up read/write data
        LDRB    R2,[R12,#11]
        CMP     R2,#0
        ORRNE   R3,R3,#3<<10            ;//writeable
        BNE     AttribDone
        LDRB    R2,[R12,#10]
        CMP     R2,#0
        ORRNE   R3,R3,#2<<10            ;//read-only
        BICEQ   R3,R3,#3                ;//no access - mark as FAULT type
AttribDone

        ;//Step through entries in the page table
        LDR     R8,=MMU_PageTable       ;//base of page table
NextSection        
        ORR     R4,R3,R0,LSL #20        ;//section address unchanged (no remapping)
        STR     R4,[R8,R0,LSL #2]       ;//store in the section pointed to by R0
        ADD     R0,R0,#1                ;//next section
        SUBS    R1,R1,#1                ;//count the sections
        BNE     NextSection
        
        ADD     R12,R12,#12             ;//Move to next region
        ADD     R9,R9,#1
        CMP     R9,#NumRegions
        BNE     NextRegionMMU
                        
        ;// Configure the MMU. This is done through coprocessor 15 
        
        ;// Read the current value of the MMU control Register 
        MRC     p15, 0, R0, c1, c0, 0

        ;// Set Asynchronous bus mode 
        ORR     R0, R0, #3 << 30
        MCR     p15, 0, R0, c1, c0, 0

       ;// Disable caches and MMU (the I cache bit is ignored for ARM720)
        BIC     R0, R0, #(1 << 12)
        BIC     R0, R0, #(1 << 2) :OR: (1 << 0)
        MCR     p15, 0, R0, c1, c0, 0
        NOP
        NOP
        NOP
                
        ;// Install page table
        LDR     R12,=MMU_PageTable 
        MCR     p15, 0, R12, c2, c0, 0
        
        ;// Allow full access to Domain 0 
        MOV     R0,#3
        MCR     p15, 0, R0, c3, c0, 0
        
        ;// Enable MMU 
        MRC     p15, 0, R0, c1, c0, 0
        ORR     R0, R0, #1 << 0
        MCR     p15, 0, R0, c1, c0, 0
        NOP
        NOP
        NOP

        ;// Enable caches (the I cache bit is ignored for ARM720)
        ORR     R0, R0, #(1 << 12)
        ORR     R0, R0, #(1 << 2)
        MCR     p15, 0, R0, c1, c0, 0
        NOP
        NOP
        NOP
       
    ENDIF


;//-------------------------------------------------------------------------------
;//----------------------------VECTOR COPY----------------------------------------
;//-------------------------------------------------------------------------------
;// Copy the vectors to address 0, unless we have the code loaded to 
;// a zero address (or are scatterloading)
    IMPORT VECTOR_StartAddress
    IMPORT   |Image$$RO$$Base| [WEAK]
    LDR     r0,=|Image$$RO$$Base|
    CMP     r0,#0
    BEQ     NoVectorCopy                    ;//base 0x0 or scatterloading
    LDR     r14,=VECTOR_StartAddress        ;//start of vector table
    MOV     r8,#0                           ;//address to copy to
    LDMIA   r14!,{r0-r7}                    ;//copy 8 words
    STMIA   r8!,{r0-r7}                     ;//and write
    LDMIA   r14!,{r0-r7}                    ;//copy 8 words
    STMIA   r8!,{r0-r7}                     ;//and write
NoVectorCopy

;//-------------------------------------------------------------------------------
;//----------------------------C LIBRARY------------------------------------------
;//-------------------------------------------------------------------------------
;//C library entry point

    IMPORT    |__main|
    LDR    pc,=|__main|

;//-------------------------------------------------------------------------------
;//----------------------------STACK AND HEAP-------------------------------------
;//-------------------------------------------------------------------------------
;// Implement a set of defined settings for the C library
;// These will set up the stack and heap locations

    EXPORT __user_initial_stackheap
__user_initial_stackheap

    ;//Place the base of the heap in the HEAP area    
    LDR    R0,=|Image$$HEAP$$ZI$$Limit|
    CMP    R0,#0
    ;//Or in the RAM area
    LDREQ  R0,=|Image$$RAM$$ZI$$Limit|
    CMP    R0,#0
    ;//Or in the main area
    LDREQ  R0,=|Image$$ZI$$Limit|
    CMP    R0,#0
    ;//Or the heap base is NULL    
    ADD     R2,R0,#Heap_Size              ;//Heap Limit
    ;//Stack base (R1) unchanged from setup above.
    SUB     R3,R1,#USR_Size               ;//Stack Limit
    ;//store the stack and heap details
    LDR     r12,=apOS_StackAndHeap
    STMIA   r12,{r0-r3}
    MOV     PC,LR

;//-------------------------------------------------------------------------------
;//----------------------------SELF-MODIFYING-------------------------------------
;//-------------------------------------------------------------------------------
;//This code is only needed if building for a core with an MPU.  We need a separate
;//coprocessor instruction for each protection area, and this is best set up using
;//self-modifying code.  This routine is therefore placed in R/W memory

    IF CACHE_BUILD="ARM940T" :LOR: CACHE_BUILD="ARM740T"
        AREA     |MPUSETUP|, CODE, READWRITE
        
SetRegion
        MCR p15, 0, R1, c6, c0, 0
        IF CACHE_BUILD="ARM940T"
            MCR p15, 0, R1, c6, c0, 1       ;//set 940 up for data
        ENDIF
        MOV PC,LR
    ENDIF
    
;//-------------------------------------------------------------------------------
;//----------------------------STACK & HEAP INFO-------------------------------------
;//-------------------------------------------------------------------------------
;//This data area stores the stack and heap locations for later debug output

    AREA     |STACKHEAPINFO|, DATA, READWRITE
    EXPORT apOS_StackAndHeap
apOS_StackAndHeap
    DCD    0,0,0,0

    END

