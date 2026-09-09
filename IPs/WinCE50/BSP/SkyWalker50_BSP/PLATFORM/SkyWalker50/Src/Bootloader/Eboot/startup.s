;
; Copyright (c) Microsoft Corporation.  All rights reserved.
;
;
; Use of this source code is subject to the terms of the Microsoft end-user
; license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
; If you did not accept the terms of the EULA, you are not authorized to use
; this source code. For a copy of the EULA, please see the LICENSE.RTF on your
; install media.
;


                INCLUDE kxarm.h
                INCLUDE armmacros.s
                INCLUDE smt926a.inc

; Refer to PUBLIC\COMMON\SDK\INC\ directory to kxarm.h and armmacros.s
; Refer to PUBLIC\COMMON\OAK\CSP\ARM\SMT\SMT926A\Inc\ directory for smt926a.inc

;-------------------------------------------------------------------------------
; Need to be modified by DJKIM 2006/10/09
MemoryMap       EQU     0x2a4
BANK_SIZE       EQU     0x00100000      ; 1MB per bank in MemoryMap array
BANK_SHIFT      EQU     20


;   Define RAM space for the Page Tables:
;
PHYBASE         EQU     0x30000000      ; physical start
PTs             EQU     0x30010000      ; 1st level page table address (PHYBASE + 0x10000)
                                        ; save room for interrupt vectors.

;-------------------------------------------------------------------------------

        TEXTAREA

        IMPORT  main

; Set up the MMU and Dcache for bootloader.
;
; This routine will initialize the first-level page table based up the contents
; of the MemoryMap array and enable the MMU and caches.
;
; Copy the image to RAM if it's not already running there.
;
; Include Files 



; Defines 

;------------------------------------------------------------------------------
; BUGBUG - ?
; Need to be modified by DJKIM 2006/10/09
PLLVAL      EQU     (((0x6e << 12) + (0x3 << 4) + 0x1))	; SMT926A

;------------------------------------------------------------------------------
; Cache Configuration

;-----------------------------
; Data Cache Characteristics.
;
;	cache size	cache line	way	lock down	write buffer
;	4~128 I/D	8word(32B)	4	1/4			16word			: ARM926EJ-S
;	16 I/D		8word(32B)	64	1/64		16word			: ARM920T
;
; cp15:c7 Register format
;
;	31		26	25						8 7	5 4		0
;	-------------------------------------------------
;	|	way				SBZ				  set	SBZ	        |	        : ARM920T
;	-------------------------------------------------
;	31	30	29			y x					5 4		0
;	-------------------------------------------------
;	|way		SBZ					Set			SBZ	|		: ARM926EJ-S
;	-------------------------------------------------

; ARM920T
;DCACHE_LINES_PER_SET_BITS      EQU     (6)
;DCACHE_LINES_PER_SET			EQU     (64)
;DCACHE_NUM_SETS				EQU     (8)
;DCACHE_SET_INDEX_BIT			EQU     (32 - DCACHE_LINES_PER_SET_BITS)
;DCACHE_LINE_SIZE				EQU     (32)

; ARM926EJ-S
DCACHE_LINES_PER_SET_BITS       EQU		2		; way bit width [31:30]
DCACHE_LINES_PER_SET			EQU		4		; 4way
DCACHE_NUM_SETS					EQU		8	; Temp value 8.. x; D cache set number	Need to modify by DJKIM 2006/10/09
DCACHE_SET_INDEX_BIT			EQU		(32 - DCACHE_LINES_PER_SET_BITS) ;
DCACHE_LINE_SIZE				EQU		32		; cache line 32bytes


; External Variables 

; External Functions 

; Global Variables 
 
; Local Variables 
 
; Local Functions 

;-------------------------------------------------------------------------------
;   Function: Startup
;
;   Main entry point for CPU initialization.
;

        STARTUPTEXT
        LEAF_ENTRY      StartUp
    
        ; Jump over power-off code. 
        b       ResetHandler

        ; Other interrupt handler???? by DJKIM 2006/10/14

ResetHandler

        ;-----------------------------------------------------
        ;	Cache & TLB initialize
        ;-----------------------------------------------------
        ; Make sure that TLB & cache are consistent
        mov     r0, #0
        mcr     p15, 0, r0, c8, c7, 0           ; flush both TLB
        mcr     p15, 0, r0, c7, c5, 0           ; invalidate instruction cache (Flush ICache)
        mcr     p15, 0, r0, c7, c6, 0           ; invalidate data cache (Flush DCache)

        ;-----------------------------------------------------
        ;	GPIO & EINT setting			Need to be modified by DJKIM 2006/10/14. Why ???
        ;-----------------------------------------------------
        ldr     r0, = GPFCON                    ; GPIO F port control
        ldr     r1, = 0x55aa                    ; 7~4 : Output mode, 3~0 : EINT[3:0] mode
        str     r1, [r0]

        ;-----------------------------------------------------
        ;	Watch dog timer disable setting		Need to be modified by DJKIM 2006/10/14
        ;-----------------------------------------------------
        ldr     r0, = WTCON                     ; disable watch dog
        ldr     r1, = 0x0         
        str     r1, [r0]

        ;-----------------------------------------------------
        ;	Interrupt disable & Power control	Need to be modified by DJKIM2006/10/14
        ;-----------------------------------------------------
        ldr     r0, = INTMSK
        ldr     r1, = 0xffffffff                ; disable all interrupts
        str     r1, [r0]

        ldr     r0, = INTSUBMSK
        ldr     r1, = 0x7fff                     ; disable all sub interrupt
        str     r1, [r0]

        ldr     r0, = INTMOD
        mov     r1, #0x0                        ; set all interrupt as IRQ
        str     r1, [r0]

        ;-----------------------------------------------------
        ;	Clock divider setting		Need to be modified by DJKIM 2006/10/14
        ;-----------------------------------------------------
        ldr     r0, = CLKDIVN
        ldr     r1, = 0x7           ; 0x0 = 1:1:1,  0x1 = 1:1:2, 0x2 = 1:2:2,  0x3 = 1:2:4,
                                        ; 0x7 = 1:3:6,  0x8 = 1:4:4
        str     r1, [r0]

        ;-----------------------------------------------------
        ;	Asynchronous bus mode setting		Don't need this by DJKIM 2006/10/14
        ;-----------------------------------------------------
        ands    r1, r1, #0xe                    ; set AsyncBusMode
        beq     %F10

        mrc     p15, 0, r0, c1, c0, 0
        orr     r0, r0, #R1_nF:OR:R1_iA
        mcr     p15, 0, r0, c1, c0, 0

        ;---------------------------------------------------------------------------
        ; Clock & PLL setting	Need to be modified by DJKIM 2006/10/14
        ; FCLK	- used by ARM920T
        ; HCLK	- used for AHB
        ; PCLK	- used for APB
        ;-----------------------------
10
        ldr     r0, = LOCKTIME                  ; To reduce PLL lock time, adjust the LOCKTIME register. 
        ldr     r1, = 0xffffff
        str     r1, [r0]
    
		ldr		r0, = CAMDIVN
		ldr		r1, = 0
		str		r1, [r0]

		; UPLL부터 setting 해야하지 않나??? by DJKIM 2006/10/14 (S3C2440)
        ldr     r0, = MPLLCON                   ; Configure MPLL
                                                ; Fin=16MHz, Fout=399.65MHz
        ldr     r1, = PLLVAL
        str     r1, [r0]

        ldr     r0, = UPLLCON                   ; Fin=16MHz, Fout=48MHz
        ldr     r1, = ((0x3c << 12) + (0x4 << 4) + 0x2)		; 16Mhz
;		ldr     r1, = ((0x38 << 12) + (0x2 << 4) + 0x2)  	; 12Mhz
        str     r1, [r0]

        mov     r0, #0x2000
20   
        subs    r0, r0, #1
        bne     %B20

;------------------------------------------------------------------------------
;   Add for Power Management 

        ldr     r1, =GSTATUS2                   ; Determine Booting Mode. GSTATUS2 : Reset status reg
        ldr     r10, [r1]

;------------------------------------------------------------------------------
;   Add for Power Management 

        tst     r10, #0x2                           ; [2] - WDTRST [1] - SLEEPRST [0] - PWRST
        beq     BringUpWinCE                    ; Normal Mode Booting (When watch dog/power reset is)

        ; Watch dog / Sleep mode / Power reset에 따른 루틴이 필요하지 않나?
        ; Other reset??? by DJKIM 2006/10/14

;------------------------------------------------------------------------------
;   Add for Power Management ?

BringUpWinCE

;------------------------------------------------------------------------------
;   Initialize memory controller

; Need to be modified by DJKIM 2006/10/14
        add     r0, pc, #MEMCTRLTAB - (. + 8)
        ldr     r1, = BWSCON                    ; BWSCON Address
        add     r2, r0, #52                     ; End address of MEMCTRLTAB
40      ldr     r3, [r0], #4    
        str     r3, [r1], #4    
        cmp     r2, r0      
        bne     %B40
    
        ldr     r0, = GPFDAT
        mov     r1, #0x60           ; Why GPIO F port data output??? by DJKIM 2006/10/14
        str     r1, [r0]

;------------------------------------------------------------------------------
;   Copy boot loader to memory

        ands    r9, pc, #0xFF000000     ; see if we are in flash or in ram
        bne     %f20                    ; go ahead if we are already in ram

        ; This is the loop that perform copying.
        ldr     r0, = 0x38000           ; offset into the RAM. eboot ram offset addr (Refer to boot.bib)
        add     r0, r0, #PHYBASE        ; add physical base
        mov     r1, r0                  ; (r1) copy destination
        ldr     r2, =0x0                ; (r2) flash started at physical address 0
        ldr     r3, =0x10000            ; counter (0x40000/4)
10      ldr     r4, [r2], #4
        str     r4, [r1], #4
        subs    r3, r3, #1
        bne     %b10

        ; Restart from the RAM position after copying.
        mov pc, r0
        nop
        nop
        nop

        ; Shouldn't get here.
        b       .

        INCLUDE oemaddrtab_cfg.inc
 

        ; Compute physical address of the OEMAddressTable.
20      add     r11, pc, #g_oalAddressTable - (. + 8)
        ldr     r10, =PTs                ; (r10) = 1st level page table


        ;-----------------------------------------------------
        ; * Build Page Table Entry *
        ;-------------------------------
        ;
        ; Setup 1st level page table (using section descriptor)
        ; Fill in first level page table entries to create "un-mapped" regions
        ; from the contents of the MemoryMap array.
        ;
        ;	(r10) = 1st level page table
        ;	(r11) = ptr to MemoryMap array
        ;
        ;		---------
        ;		|		|
        ;		|		|
        ;		|		| 0x30012000 -> Fill this region (1st level page table)
        ;		---------
        ;		|		|
        ;		|		|
        ;		|		| 0x30010000
        ;		---------
        ;
        ;	* OEMAddressTable
        ;		VirtualAddr PhysicalAddr MB
        ;
        ;	* L1 Page Table Entry
        ;	When Section Entry case
        ;
        ;	31			20 19		12 11 10 9 8	5 4 3 2 1 0
        ;	|Base Address |   SBZ     | AP  |0|Domain|1|C|B|1|0|
        ;-----------------------------------------------------
        add     r10, r10, #0x2000       ; (r10) = ptr to 1st PTE for "unmapped space"
        mov     r0, #0x0E               ; (r0) = PTE for 0: 1MB cachable bufferable. (CB bit set/Section Entry)
        ;mov     r0, #0x1E				; 이게 맞는게 아니나??? by DJKIM 2006/10/14
        orr     r0, r0, #0x400          ; set kernel r/w permission (AP bit setting)
25      mov     r1, r11                 ; (r1) = ptr to MemoryMap array

	;-------------------------------; Build the Page Table Entry
	; Load OEMAddressTable

30      ldr     r2, [r1], #4            ; (r2) = virtual address to map Bank at
        ldr     r3, [r1], #4            ; (r3) = physical address to map from
        ldr     r4, [r1], #4            ; (r4) = num MB to map

        cmp     r4, #0                  ; End of table?
        beq     %f40                    ; If OEMAddressTable's end, goto 40 Label

	; VA and PA alignment
        ldr     r5, =0x1FF00000
        and     r2, r2, r5              ; VA needs 512MB, 1MB aligned.                

        ldr     r5, =0xFFF00000
        and     r3, r3, r5              ; PA needs 4GB, 1MB aligned.

	; r10 = PTs(0x30010000)+0x2000 = 0x30012000
	; r2 = masked VA, r3 = masked PA, r0 = 0x40e  (Kernel R/W, Cached write-back mode)

        add     r2, r10, r2, LSR #18    ; r2=PTE's address. Why 18 shift??? by DJKIM 2006/10/14
        add     r0, r0, r3              ; (r0) = PTE for next physical page
        ;-------------------------------

	; Fill the PTE in the PTs
	; r0 = masked PA+0x40e, r2 = (masked VA>>18)+0x30012000
35      str     r0, [r2], #4                ; Store the L1 PTE to each PTs
        add     r0, r0, #0x00100000     ; (r0) = PTE for next physical page, r0=r0+0x100000(1MB)
        sub     r4, r4, #1              ; Decrement number of MB left 
        cmp     r4, #0
        bne     %b35                    ; Map next MB

        bic     r0, r0, #0xF0000000     ; Clear Section Base Address Field
        bic     r0, r0, #0x0FF00000     ; Clear Section Base Address Field
        b       %b30                    ; Get next element
        ;-------------------------------

	; r0=0x40e
40      tst     r0, #8                      ; r0 & 0x8 (Cache bit check)
        bic     r0, r0, #0x0C           ; clear cachable & bufferable bits in PTE
        add     r10, r10, #0x0800       ; (r10) = ptr to 1st PTE for "unmapped uncached space"
                                                ; r10= PTs+0x2000 => r10 + 0x800 = 0x30012000 + 0x800 (2048)
        bne     %b25                    ; go setup PTEs for uncached space
        sub     r10, r10, #0x3000       ; (r10) = restore address of 1st level page table
        ; * Why 0x3000 ??? by DJKIM 2006/10/14
        ;-------------------------------

        ; Setup mmu to map (VA == 0) to (PA == 0x30000000).
        ldr     r0, =PTs                ; PTE entry for VA = 0, PTs=0x30010000
        ldr     r1, =0x3000040E         ; uncache/unbuffer/rw, PA base == 0x30000000
        ;ldr		r1, =0x3000041E			; 이게 맞는거 아니나??? by DJKIM 2006/10/14
        str     r1, [r0]

        ; uncached area.
        add     r0, r0, #0x0800         ; PTE entry for VA = 0x0200.0000 , uncached     
        ldr     r1, =0x30000402         ; uncache/unbuffer/rw, base == 0x30000000
        ;ldr		r1, =0x30000412			; 이게 맞는거 아니나??? by DJKIM 2006/10/14
        str     r1, [r0]
        ;-------------------------------

        ;-------------------------------
        ; Comment:
        ; The following loop is to direct map RAM VA == PA. i.e. 
        ;   VA == 0x30XXXXXX => PA == 0x30XXXXXX for SMT926
        ; Fill in 8 entries to have a direct mapping for DRAM

        ; 64개의 1MB base PTE(cache/buffer/kernel r/w) 저장하는 루틴
        ; Why 64개 1MB base(64MB)??? by DJKIM 2006/10/14 (SDRAM 32M 2개라서??? (When S3C2440)
        ldr     r10, =PTs               ; restore address of 1st level page table, PTs=0x30010000
        ldr     r0,  =PHYBASE

        add     r10, r10, #(0x3000 / 4) ; (r10) = ptr to 1st PTE for 0x30000000

        add     r0, r0, #0x1E           ; 1MB cachable bufferable
        orr     r0, r0, #0x400          ; set kernel r/w permission
        mov     r1, #0 
        mov     r3, #64
45      mov     r2, r1                  ; (r2) = virtual address to map Bank at
        cmp     r2, #0x20000000:SHR:BANK_SHIFT  ; BANK_SHIFT = 20
        add     r2, r10, r2, LSL #BANK_SHIFT-18     ; r10=0x30010c00
        strlo   r0, [r2]                    ; r0=0x3000041e
        add     r0, r0, #0x00100000     ; (r0) = PTE for next physical page
        subs    r3, r3, #1
        add     r1, r1, #1
        bgt     %b45

        ldr     r10, =PTs               ; (r10) = restore address of 1st level page table
        ;-------------------------------

        ;-------------------------------
        ; The page tables and exception vectors are setup.
        ; Initialize the MMU and turn it on.
        ; cp15 register
        ;	c1 : Control reg	c2 : TTB reg
        ;	c3 : Domain reg		c5 : Fault status reg
        ;	c6 : Fault addr reg	c8 : TLB invalidate reg

        mov     r1, #1
        mcr     p15, 0, r1, c3, c0, 0   ; setup access to domain 0, cp15:c3 -> Domain access reg
        mcr     p15, 0, r10, c2, c0, 0  ; r10=0x30010000, cp15:c2 -> TTB reg

        mcr     p15, 0, r0, c8, c7, 0   ; flush I+D TLBs
        mov     r1, #0x0071             ; Enable: MMU
        orr     r1, r1, #0x0004         ; Enable the cache

        ldr     r0, =VirtualStart

        cmp     r0, #0                  ; make sure no stall on "mov pc,r0" below
        mcr     p15, 0, r1, c1, c0, 0	; cp15:c1 -> Control reg
        mov     pc, r0                  ;  & jump to new virtual address
        nop

        ; MMU & caches now enabled.
        ;   (r10) = physcial address of 1st level page table
        ;

VirtualStart

        mov     sp, #0x8C000000     ; Refer to boot.bib
        add     sp, sp, #0x30000        ; arbitrary initial super-page stack pointer
        b       main

        ENTRY_END
 
        LTORG

;------------------------------------------------------------------------------
; Memory Controller Configuration 
;
;   The below defines are used in the MEMCTRLTAB table
;   defined below to iniatialize the memory controller's
;   register bank.
;
; SDRAM refresh control register configuration

REFEN       EQU     (0x1)               ; Refresh enable
TREFMD      EQU     (0x0)               ; CBR(CAS before RAS)/Auto refresh
Trp         EQU     (0x2)               ; 2clk
Trc         EQU     (0x3)               ; 7clk
Tchr        EQU     (0x2)               ; 3clk
REFCNT      EQU     (1113)              ; period=15.6us, HCLK=60Mhz, (2048+1-15.6*60)

; Bank Control 
;
; Bus width and wait status control 

B1_BWSCON   EQU     (DW32)
B2_BWSCON   EQU     (DW16)
B3_BWSCON   EQU     (DW16 + WAIT + UBLB)
B4_BWSCON   EQU     (DW16)
B5_BWSCON   EQU     (DW16)
B6_BWSCON   EQU     (DW32)
B7_BWSCON   EQU     (DW32)

; Bank 0

B0_Tacs     EQU     (0x0)    ; 0clk
B0_Tcos     EQU     (0x0)    ; 0clk
B0_Tacc     EQU     (0x7)    ; 14clk
B0_Tcoh     EQU     (0x0)    ; 0clk
B0_Tah      EQU     (0x0)    ; 0clk
B0_Tacp     EQU     (0x0)    
B0_PMC      EQU     (0x0)    ; normal

; Bank 1

B1_Tacs     EQU     (0x0)    ; 0clk
B1_Tcos     EQU     (0x0)    ; 0clk
B1_Tacc     EQU     (0x7)    ; 14clk
B1_Tcoh     EQU     (0x0)    ; 0clk
B1_Tah      EQU     (0x0)    ; 0clk
B1_Tacp     EQU     (0x0)    
B1_PMC      EQU     (0x0)    ; normal

; Bank 2

B2_Tacs     EQU     (0x0)    ; 0clk
B2_Tcos     EQU     (0x0)    ; 0clk
B2_Tacc     EQU     (0x7)    ; 14clk
B2_Tcoh     EQU     (0x0)    ; 0clk
B2_Tah      EQU     (0x0)    ; 0clk
B2_Tacp     EQU     (0x0)     
B2_PMC      EQU     (0x0)    ; normal

; Bank 3

B3_Tacs     EQU     (0x0)    ; 0clk
B3_Tcos     EQU     (0x0)    ; 0clk
B3_Tacc     EQU     (0x7)    ; 14clk
B3_Tcoh     EQU     (0x0)    ; 0clk
B3_Tah      EQU     (0x0)    ; 0clk
B3_Tacp     EQU     (0x0)    
B3_PMC      EQU     (0x0)    ; normal

; Bank 4

B4_Tacs     EQU     (0x0)    ; 0clk
B4_Tcos     EQU     (0x0)    ; 0clk
B4_Tacc     EQU     (0x7)    ; 14clk
B4_Tcoh     EQU     (0x0)    ; 0clk
B4_Tah      EQU     (0x0)    ; 0clk
B4_Tacp     EQU     (0x0)    
B4_PMC      EQU     (0x0)    ; normal

; Bank 5

B5_Tacs     EQU     (0x0)    ; 0clk
B5_Tcos     EQU     (0x0)    ; 0clk
B5_Tacc     EQU     (0x7)    ; 14clk
B5_Tcoh     EQU     (0x0)    ; 0clk
B5_Tah      EQU     (0x0)    ; 0clk
B5_Tacp     EQU     (0x0)    
B5_PMC      EQU     (0x0)    ; normal

; Bank 6

B6_MT       EQU     (0x3)    ; SDRAM
B6_Trcd     EQU     (0x2)    ; 4clk
B6_SCAN     EQU     (0x1)    ; 9bit

; Bank 7
;
; Note - there is no memory connected to Bank 7

B7_MT       EQU     (0x3)    ; SDRAM
B7_Trcd     EQU     (0x2)    ; 4clk
B7_SCAN     EQU     (0x1)    ; 9bit


;------------------------------------------------------------------------------
;   Memory Controller Configuration Data Table
;
;   This data block is loaded into the memory controller's 
;   registers to configure the platform memory.
;

MEMCTRLTAB DATA
        DCD (0+(B1_BWSCON<<4)+(B2_BWSCON<<8)+(B3_BWSCON<<12)+(B4_BWSCON<<16)+(B5_BWSCON<<20)+(B6_BWSCON<<24)+(B7_BWSCON<<28))
        DCD ((B0_Tacs<<13)+(B0_Tcos<<11)+(B0_Tacc<<8)+(B0_Tcoh<<6)+(B0_Tah<<4)+(B0_Tacp<<2)+(B0_PMC))   ; BANKCON0
        DCD ((B1_Tacs<<13)+(B1_Tcos<<11)+(B1_Tacc<<8)+(B1_Tcoh<<6)+(B1_Tah<<4)+(B1_Tacp<<2)+(B1_PMC))   ; BANKCON1 
        DCD ((B2_Tacs<<13)+(B2_Tcos<<11)+(B2_Tacc<<8)+(B2_Tcoh<<6)+(B2_Tah<<4)+(B2_Tacp<<2)+(B2_PMC))   ; BANKCON2
        DCD ((B3_Tacs<<13)+(B3_Tcos<<11)+(B3_Tacc<<8)+(B3_Tcoh<<6)+(B3_Tah<<4)+(B3_Tacp<<2)+(B3_PMC))   ; BANKCON3
        DCD ((B4_Tacs<<13)+(B4_Tcos<<11)+(B4_Tacc<<8)+(B4_Tcoh<<6)+(B4_Tah<<4)+(B4_Tacp<<2)+(B4_PMC))   ; BANKCON4
        DCD ((B5_Tacs<<13)+(B5_Tcos<<11)+(B5_Tacc<<8)+(B5_Tcoh<<6)+(B5_Tah<<4)+(B5_Tacp<<2)+(B5_PMC))   ; BANKCON5
        DCD ((B6_MT<<15)+(B6_Trcd<<2)+(B6_SCAN))                                                        ; BANKCON6
        DCD ((B7_MT<<15)+(B7_Trcd<<2)+(B7_SCAN))                                                        ; BANKCON7
        DCD ((REFEN<<23)+(TREFMD<<22)+(Trp<<20)+(Trc<<18)+(Tchr<<16)+REFCNT)                            ; REFRESH
        DCD 0xB2                                                                                        ; BANKSIZE
        DCD 0x20                                                                                        ; MRSRB6
        DCD 0x20                                                                                        ; MRSRB7

        END

;-------------------------------------------------------------------------------        
