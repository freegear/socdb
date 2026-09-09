;
;  Copyright (c) Microsoft Corporation.  All rights reserved.
;
;
;  Use of this source code is subject to the terms of the Microsoft end-user
;  license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
;  If you did not accept the terms of the EULA, you are not authorized to use
;  this source code. For a copy of the EULA, please see the LICENSE.RTF on your
;  install media.
;
;------------------------------------------------------------------------------
;
;   File:  startup.s
;
;   Kernel startup routine for SMT SKYWALKER board. Hardware is
;   initialized in boot loader - so there isn't much code at all.
;
;------------------------------------------------------------------------------

            INCLUDE kxarm.h
            INCLUDE smt926a.inc

            IMPORT  OALClearUTLB
            IMPORT  OALFlushICache
            IMPORT  OALFlushDCache

;
; The following macro value is refer to oemaddrtab_cfg.inc file and SkyWaker register spec
; Need to modified by DJKIM 2006/10/16
vGPIOBASE	EQU	0xb1600000	;Port A control. uncached VA.
oGPFCON		EQU	0x50            ;Port F control
oGPFDAT		EQU 0x54
oGSTATUS3	EQU	0xb8            ;Saved data0(32-bit) before entering POWER_OFF mode
oGSTATUS4	EQU	0xbc            ;Saved data0(32-bit) before entering POWER_OFF mode

vINTBASE	EQU	0xb0a00000	;Interrupt request status. uncached VA.
oSRCPND     EQU	0x00	        ;Interrupt request status
oINTMSK		EQU	0x08	        ;Interrupt mask control
oINTPND		EQU	0x10	        ;Interrupt request status

vMISCCR		EQU	0xb1600080	;Miscellaneous control
vCLKCON     EQU	0xb0c0000c	;Clock generator control
vREFRESH	EQU	0xb0800024	;DRAM/SDRAM refresh


; Data Cache Characteristics.
;
; ARM920T
;DCACHE_LINES_PER_SET_BITS      EQU     6
;DCACHE_LINES_PER_SET			EQU     64
;DCACHE_NUM_SETS				EQU     8
;DCACHE_SET_INDEX_BIT			EQU     (32 - DCACHE_LINES_PER_SET_BITS)
;DCACHE_LINE_SIZE				EQU     32

; ARM926EJ-S
DCACHE_LINES_PER_SET_BITS       EQU		2		; way bit width [31:30]
DCACHE_LINES_PER_SET			EQU		4		; 4way
DCACHE_NUM_SETS					EQU		8	; Temp value 8.. x; D cache set number	Need to modify by DJKIM 2006/10/16
DCACHE_SET_INDEX_BIT			EQU		(32 - DCACHE_LINES_PER_SET_BITS) ;
DCACHE_LINE_SIZE				EQU		32		; cache line 32bytes



; Need to modified by DJKIM 2006/10/16
SLEEPDATA_BASE_VIRTUAL          EQU	0xAC028000  ; Uncached VA. keep in sync w/ config.bib
SLEEPDATA_BASE_PHYSICAL         EQU	0x30028000  ; Refer to oemaddrtab_cfg.inc & config.bib

; Need to modified by DJKIM 2006/10/16
; How do we fix this ???    -> Just this define use???
; Definition area               -> Refer to config.bib
; Where are these macros stored??? -> Refer to OALCPUPowerOff()

SleepState_Data_Start		EQU     (0)

SleepState_WakeAddr    		EQU     (SleepState_Data_Start		    )
SleepState_MMUCTL           EQU     (SleepState_WakeAddr    + WORD_SIZE )
SleepState_MMUTTB       	EQU     (SleepState_MMUCTL  	+ WORD_SIZE )
SleepState_MMUDOMAIN    	EQU     (SleepState_MMUTTB  	+ WORD_SIZE )
SleepState_SVC_SP       	EQU     (SleepState_MMUDOMAIN   + WORD_SIZE )
SleepState_SVC_SPSR     	EQU     (SleepState_SVC_SP  	+ WORD_SIZE )
SleepState_FIQ_SPSR     	EQU     (SleepState_SVC_SPSR    + WORD_SIZE )
SleepState_FIQ_R8       	EQU     (SleepState_FIQ_SPSR    + WORD_SIZE )
SleepState_FIQ_R9       	EQU     (SleepState_FIQ_R8  	+ WORD_SIZE )
SleepState_FIQ_R10      	EQU     (SleepState_FIQ_R9  	+ WORD_SIZE )
SleepState_FIQ_R11      	EQU     (SleepState_FIQ_R10 	+ WORD_SIZE )
SleepState_FIQ_R12      	EQU     (SleepState_FIQ_R11 	+ WORD_SIZE )
SleepState_FIQ_SP       	EQU     (SleepState_FIQ_R12 	+ WORD_SIZE )
SleepState_FIQ_LR       	EQU     (SleepState_FIQ_SP  	+ WORD_SIZE )
SleepState_ABT_SPSR     	EQU     (SleepState_FIQ_LR  	+ WORD_SIZE )
SleepState_ABT_SP       	EQU     (SleepState_ABT_SPSR    + WORD_SIZE )
SleepState_ABT_LR       	EQU     (SleepState_ABT_SP  	+ WORD_SIZE )
SleepState_IRQ_SPSR     	EQU     (SleepState_ABT_LR  	+ WORD_SIZE )
SleepState_IRQ_SP       	EQU     (SleepState_IRQ_SPSR    + WORD_SIZE )
SleepState_IRQ_LR       	EQU     (SleepState_IRQ_SP  	+ WORD_SIZE )
SleepState_UND_SPSR     	EQU     (SleepState_IRQ_LR  	+ WORD_SIZE )
SleepState_UND_SP       	EQU     (SleepState_UND_SPSR    + WORD_SIZE )
SleepState_UND_LR       	EQU     (SleepState_UND_SP  	+ WORD_SIZE )
SleepState_SYS_SP       	EQU     (SleepState_UND_LR  	+ WORD_SIZE )
SleepState_SYS_LR       	EQU     (SleepState_SYS_SP  	+ WORD_SIZE )

SleepState_Data_End     	EQU     (SleepState_SYS_LR	+ WORD_SIZE )

SLEEPDATA_SIZE		    	EQU     ((SleepState_Data_End - SleepState_Data_Start) / 4)


    IMPORT  KernelStart

    TEXTAREA

    ; Include memory configuration file with g_oalAddressTable

    INCLUDE oemaddrtab_cfg.inc

    LEAF_ENTRY StartUp

    ; Compute the OEMAddressTable's physical address and 
    ; load it into r0. KernelStart expects r0 to contain
    ; the physical address of this table. The MMU isn't 
    ; turned on until well into KernelStart.  

    ;-----------------------------------------------------
    ;	Watch dog timer disable setting		Need to be modified by DJKIM 2006/10/16
    ;-----------------------------------------------------
    ldr	r0, =WTCON       ; disable the watchdog timer.
    ldr	r1, =0x0         
    str	r1, [r0]

    ;-----------------------------------------------------
    ;	Interrupt disable Need to be modified by DJKIM2006/10/16
    ;-----------------------------------------------------
    ldr	r0, =INTMSK      ; mask all first-level interrupts.
    ldr	r1, =0xffffffff
    str	r1, [r0]

    ldr	r0, =INTSUBMSK   ; mask all second-level interrupts.
    ldr	r1, =0x7fff
    str	r1, [r0]

    ;-----------------------------------------------------
    ;	Clock divider setting		Need to be modified by DJKIM 2006/10/16
    ;-----------------------------------------------------
    ldr r0,=CLKDIVN
    ldr r1,=0x7     ; 0x0 = 1:1:1  ,  0x1 = 1:1:2	, 0x2 = 1:2:2  ,  0x3 = 1:2:4,  0x4 = 1:4:4,  0x5 = 1:4:8, 0x6 = 1:3:3, 0x7 = 1:3:6
    str r1,[r0]

    ;-----------------------------------------------------
    ;	Asynchronous bus mode setting		Don't need this by DJKIM 2006/10/16
    ;-----------------------------------------------------
    ; MMU_SetAsyncBusMode FCLK:HCLK= 1:2
    ands r1, r1, #0x2
    beq %F5
    mrc p15,0,r0,c1,c0,0
    orr r0,r0,#R1_nF:OR:R1_iA
    mcr p15,0,r0,c1,c0,0

    ;---------------------------------------------------------------------------
    ; Clock & PLL setting	Need to be modified by DJKIM 2006/10/16
    ;---------------------------------------------------------------------------
    ; TODO: to reduce PLL lock time, adjust the LOCKTIME register. 
5
    ldr	r0, =LOCKTIME
    ldr	r1, =0xffffff
    str	r1, [r0]
    
    ldr     r0, = UPLLCON   ; USB PLL control reg
    ldr     r1, = ((0x3c << 12) + (0x4 << 4) + 0x2)  
    str     r1, [r0]

    nop
    nop
    nop
    nop
    nop
    nop
    nop

    ldr		r0, = MPLLCON   ; MCU PLL control reg
    ldr     r1, = ((0x6e << 12) + (0x3 << 4) + 0x1)
    str		r1, [r0]

    mov     r0, #0x2000
1	
    subs    r0, r0, #1
    bne     %B1	

    add     r0, pc, #g_oalAddressTable - (. + 8)
    bl      KernelStart     ; Refer to private\winceos\coreos\kernel\arm\armtrap.s

    ENTRY_END 


;---------------------------------------------------------------------------
    LEAF_ENTRY OALCPUPowerOff

    ;1. Push SVC state onto our stack
    stmdb   sp!, {r4-r12}
    stmdb   sp!, {lr}

    ;2. Save MMU & CPU Register to RAM
    ; cp15:c1 - MMU control reg
    ; cp15:c2 - MMU TTB(Translation Table Base) reg
    ; cp15:c3 - MMU Domain reg
    ; Refer to smt926a.inc

    ldr     r3, =SLEEPDATA_BASE_VIRTUAL     ; base of Sleep mode storage

    ldr     r2, =Awake_address              ; store Virtual return address
    str     r2, [r3], #4

    mrc     p15, 0, r2, c1, c0, 0           ; load r2 with MMU Control
    ldr     r0, =MMU_CTL_MASK               ; mask off the undefined bits
    bic     r2, r2, r0
    str     r2, [r3], #4                    ; store MMU Control data

    mrc     p15, 0, r2, c2, c0, 0           ; load r2 with TTB address.
    ldr     r0, =MMU_TTB_MASK               ; mask off the undefined bits
    bic     r2, r2, r0
    str     r2, [r3], #4                    ; store TTB address

    mrc     p15, 0, r2, c3, c0, 0           ; load r2 with domain access control.
    str     r2, [r3], #4                    ; store domain access control

    str     sp, [r3], #4                    ; store SVC stack pointer

    mrs     r2, spsr
    str     r2, [r3], #4                    ; store SVC status register

    mov     r1, #Mode_FIQ:OR:I_Bit:OR:F_Bit ; Enter FIQ mode, no interrupts
    msr     cpsr, r1
    mrs     r2, spsr
    stmia   r3!, {r2, r8-r12, sp, lr}       ; store the FIQ mode registers

    mov     r1, #Mode_ABT:OR:I_Bit:OR:F_Bit ; Enter ABT mode, no interrupts
    msr     cpsr, r1
    mrs		r0, spsr
    stmia   r3!, {r0, sp, lr}               ; store the ABT mode Registers

    mov     r1, #Mode_IRQ:OR:I_Bit:OR:F_Bit ; Enter IRQ mode, no interrupts
    msr     cpsr, r1
    mrs     r0, spsr
    stmia   r3!, {r0, sp, lr}               ; store the IRQ Mode Registers

    mov     r1, #Mode_UND:OR:I_Bit:OR:F_Bit ; Enter UND mode, no interrupts
    msr     cpsr, r1
    mrs     r0, spsr
    stmia   r3!, {r0, sp, lr}               ; store the UND mode Registers

    mov     r1, #Mode_SYS:OR:I_Bit:OR:F_Bit ; Enter SYS mode, no interrupts
    msr     cpsr, r1
    stmia   r3!, {sp, lr}                   ; store the SYS mode Registers

    mov     r1, #Mode_SVC:OR:I_Bit:OR:F_Bit ; Back to SVC mode, no interrupts
    msr     cpsr, r1

    ;3. do Checksum on the Sleepdata
    ; Need to be modified by DJKIM 2006/10/16
    ldr     r3, =SLEEPDATA_BASE_VIRTUAL	; get pointer to SLEEPDATA
    ldr     r2, =0x0
    ldr     r0, =(SLEEPDATA_SIZE-1)		; get size of data structure (in words)
30
    ldr     r1, [r3], #4
    and     r1, r1, #0x1
    mov     r1, r1, ROR #31
    add     r2, r2, r1
    subs    r0, r0, #1
    bne     %b30

    ldr     r0, =vGPIOBASE
    ;;;add		r2, r2, #1                  ; test checksum of the Sleep data error
    str     r2, [r0, #oGSTATUS3]        ; Store in Power Manager Scratch pad register
                                                    ; GSTATUS3 : Inform reg
    ; GPIO F port output mode setting. Need to be modified by DJKIM 2006/10/16
    ldr     r0, =vGPIOBASE
    ldr     r1, =0x550a                     ; 7~4 : Output, 3~2 : Input, 1~0 : EINT[1:0]
    str     r1, [r0, #oGPFCON]

    ldr		r1, =0x30               ; Why 0x30 output??? by DJKIM 2006/10/16
    str		r1, [r0, #oGPFDAT]	

    ;4. Interrupt Disable 
    ; Need to be modified by DJKIM 2006/10/16
    ldr     r0, =vINTBASE
    mvn     r2, #0
    str     r2, [r0, #oINTMSK]
    str     r2, [r0, #oSRCPND]
    str     r2, [r0, #oINTPND]

    ;5. Cache Flush
    bl		OALClearUTLB            ; Refer to PLATFORM\COMMON\ARM\COMMON\CACHE\clearutlb.s
    bl		OALFlushICache          ; Refer to PLATFORM\COMMON\ARM\COMMON\CACHE\flushic.s
    ldr     r0, = (DCACHE_LINES_PER_SET - 1)    
    ldr     r1, = (DCACHE_NUM_SETS - 1)    
    ldr     r2, = DCACHE_SET_INDEX_BIT    
    ldr     r3, = DCACHE_LINE_SIZE     
    bl		OALFlushDCache      ; Refer to PLATFORM\COMMON\ARM\COMMON\CACHE\flushdc.s

    ;6. Setting Wakeup External Interrupt(EINT0,1,2) Mode
    ; Need to be modified by DJKIM 2006/10/16
    ldr     r0, =vGPIOBASE

    ldr     r1, =0x550a
    str     r1, [r0, #oGPFCON]

    ;ldr     r1, =0x55550100
    ;str     r1, [r0, #oGPGCON]

    ;7. Go to Power-Off Mode
    ; Need to be modified by DJKIM 2006/10/16
    ldr     r0, =vMISCCR            ; hit the TLB. MISCCR : Miscellaneous reg
    ldr     r0, [r0]
    ldr     r0, =vCLKCON            ; CLKCON : Clock control reg
    ldr     r0, [r0]

    ldr     r0, =vREFRESH           ; (DRAM or SDRAM) Refresh control reg
    ldr     r1, [r0]                        ; r1=rREFRESH	
    orr     r1, r1, #(1 << 22)      ; (1<<22) -> self-refresh

    ldr     r2, =vMISCCR
    ldr     r3, [r2]
    orr     r3, r3, #(3<<17)        ; Make sure that SCLK0:SCLK->0, SCLK1:SCLK->0, SCKE=L during boot-up 
    bic     r3, r3, #(7<<20)        ; BATT_FUNC = 0x000
    orr     r3, r3, #(6<<20)        ; Ignore BATT_FLT

    ldr     r4, =vCLKCON
    ldr     r5, =0x1ffff8            ; Power Off Mode

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sometimes it is not working in cache mode. So I modify to jump to ROM area.
;
;;;	ldr		r6, =0x92000000		; make address to 0x9200 0020
;;;	add		r6, r6, #0x20		; 
;;;	mov     pc, r6				; jump to Power off code in ROM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    b       SelfRefreshAndPowerOff

    ALIGN   32                      ; for I-Cache Line(32Byte, 8 Word)

    ; r0 = REFRESH control reg. r2 = Miscellaneous reg. r4 = Clock control reg
SelfRefreshAndPowerOff		; run with Instruction Cache's code
    str     r1, [r0]		; Enable SDRAM self-refresh
    str     r3, [r2]		; MISCCR Setting
    str     r5, [r4]		; Power Off !!
    b       .
;---------------------------------------------------------------------------

;	LTORG

; This point is called from EBOOT's step-stone loader startup code(MMU is enabled)
; in this routine, left information(REGs, INTMSK, INTSUBMSK ...)

Awake_address

    ;1. Recover CPU Registers

    ldr     r3, =SLEEPDATA_BASE_VIRTUAL		; Sleep mode information data structure
    add     r2, r3, #SleepState_FIQ_SPSR
    mov     r1, #Mode_FIQ:OR:I_Bit:OR:F_Bit		; Enter FIQ mode, no interrupts - also FIQ
    msr     cpsr, r1
    ldr     r0,  [r2], #4
    msr     spsr, r0
    ldr     r8,  [r2], #4
    ldr     r9,  [r2], #4
    ldr     r10, [r2], #4
    ldr     r11, [r2], #4
    ldr     r12, [r2], #4
    ldr     sp,  [r2], #4
    ldr     lr,  [r2], #4

    mov     r1, #Mode_ABT:OR:I_Bit			; Enter ABT mode, no interrupts
    msr     cpsr, r1
    ldr     r0, [r2], #4
    msr     spsr, r0
    ldr     sp, [r2], #4
    ldr     lr, [r2], #4

    mov     r1, #Mode_IRQ:OR:I_Bit			; Enter IRQ mode, no interrupts
    msr     cpsr, r1
    ldr     r0, [r2], #4
    msr     spsr, r0
    ldr     sp, [r2], #4
    ldr     lr, [r2], #4

    mov     r1, #Mode_UND:OR:I_Bit			; Enter UND mode, no interrupts
    msr     cpsr, r1
    ldr     r0, [r2], #4
    msr     spsr, r0
    ldr     sp, [r2], #4
    ldr     lr, [r2], #4

    mov     r1, #Mode_SYS:OR:I_Bit			; Enter SYS mode, no interrupts
    msr     cpsr, r1
    ldr     sp, [r2], #4
    ldr     lr, [r2]

    mov     r1, #Mode_SVC:OR:I_Bit					; Enter SVC mode, no interrupts - FIQ is available
    msr     cpsr, r1
    ldr     r0, [r3, #SleepState_SVC_SPSR]
    msr     spsr, r0

    ;2. Recover Last mode's REG's, & go back to caller of OALCPUPowerOff()

    ldr     sp, [r3, #SleepState_SVC_SP]
    ldr     lr, [sp], #4
    ldmia   sp!, {r4-r12}
    mov     pc, lr                          ; and now back to our sponsors

    ENTRY_END

    END
;------------------------------------------------------------------------------


