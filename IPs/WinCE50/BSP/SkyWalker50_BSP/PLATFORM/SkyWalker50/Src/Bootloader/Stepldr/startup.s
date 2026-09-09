   
    OPT 2

    INCLUDE kxarm.h
    INCLUDE option.inc
    INCLUDE skywalkeraddr.inc
    INCLUDE memcfg.inc

    ; option.inc                : CLK & PLL option macro define file
    ; skywalkeraddr.inc : SkyWalker register map file
    ; memcfg.inc            : Memory bank control define file

    OPT 1
    OPT 128

;-----------------------------------------------------    
; Pre-defined constants.
;-----------------------------------------------------
USERMODE    EQU 	0x10
FIQMODE     EQU 	0x11
IRQMODE     EQU 	0x12
SVCMODE     EQU 	0x13
ABORTMODE   EQU 	0x17
UNDEFMODE   EQU 	0x1b
MODEMASK    EQU 	0x1f
NOINT       EQU 	0xc0

;-----------------------------------------------------
; Stack locations.
;-----------------------------------------------------
; How do we it decide??? by DJKIM 2006/10/14

SVCStack	EQU	(_STACK_BASEADDRESS-0x2800) 	; 0x33ff5800 ~
UserStack	EQU	(_STACK_BASEADDRESS-0x3800)	  	; 0x33ff4800 ~ 
UndefStack	EQU	(_STACK_BASEADDRESS-0x2400) 	; 0x33ff5c00 ~
AbortStack	EQU	(_STACK_BASEADDRESS-0x2000) 	; 0x33ff6000 ~
IRQStack	EQU	(_STACK_BASEADDRESS-0x1000)	  	; 0x33ff7000 ~
FIQStack	EQU	(_STACK_BASEADDRESS-0x0)	    ; 0x33ff8000 ~ 

;------------------------------------------------------------------------------
; Sleep state constants 
; 
; Location of sleep data 

; BUGBUG - this needs to be declared as a local var.

SLEEPDATA_BASE_PHYSICAL         EQU     0x30028000
WORD_SIZE						EQU		0x4
; Sleep State memory locations

SleepState_Data_Start           EQU     (0)
SleepState_WakeAddr             EQU     (SleepState_Data_Start  + 0)
SleepState_MMUCTL               EQU     (SleepState_WakeAddr    + WORD_SIZE)
SleepState_MMUTTB               EQU     (SleepState_MMUCTL      + WORD_SIZE)
SleepState_MMUDOMAIN            EQU     (SleepState_MMUTTB      + WORD_SIZE)
SleepState_SVC_SP               EQU     (SleepState_MMUDOMAIN   + WORD_SIZE)
SleepState_SVC_SPSR             EQU     (SleepState_SVC_SP      + WORD_SIZE)
SleepState_FIQ_SPSR             EQU     (SleepState_SVC_SPSR    + WORD_SIZE)
SleepState_FIQ_R8               EQU     (SleepState_FIQ_SPSR    + WORD_SIZE)
SleepState_FIQ_R9               EQU     (SleepState_FIQ_R8      + WORD_SIZE)
SleepState_FIQ_R10              EQU     (SleepState_FIQ_R9      + WORD_SIZE)
SleepState_FIQ_R11              EQU     (SleepState_FIQ_R10     + WORD_SIZE)
SleepState_FIQ_R12              EQU     (SleepState_FIQ_R11     + WORD_SIZE)
SleepState_FIQ_SP               EQU     (SleepState_FIQ_R12     + WORD_SIZE)
SleepState_FIQ_LR               EQU     (SleepState_FIQ_SP      + WORD_SIZE)
SleepState_ABT_SPSR             EQU     (SleepState_FIQ_LR      + WORD_SIZE)
SleepState_ABT_SP               EQU     (SleepState_ABT_SPSR    + WORD_SIZE)
SleepState_ABT_LR               EQU     (SleepState_ABT_SP      + WORD_SIZE)
SleepState_IRQ_SPSR             EQU     (SleepState_ABT_LR      + WORD_SIZE)
SleepState_IRQ_SP               EQU     (SleepState_IRQ_SPSR    + WORD_SIZE)
SleepState_IRQ_LR               EQU     (SleepState_IRQ_SP      + WORD_SIZE)
SleepState_UND_SPSR             EQU     (SleepState_IRQ_LR      + WORD_SIZE)
SleepState_UND_SP               EQU     (SleepState_UND_SPSR    + WORD_SIZE)
SleepState_UND_LR               EQU     (SleepState_UND_SP      + WORD_SIZE)
SleepState_SYS_SP               EQU     (SleepState_UND_LR      + WORD_SIZE)
SleepState_SYS_LR               EQU     (SleepState_SYS_SP      + WORD_SIZE)
SleepState_Data_End             EQU     (SleepState_SYS_LR      + WORD_SIZE)

SLEEPDATA_SIZE                  EQU     (SleepState_Data_End - SleepState_Data_Start) / 4


	IMPORT main    ; C entrypoint for Steppingstone loader.

	EXPORT MMU_EnableICache
 	EXPORT MMU_SetAsyncBusMode
  
    STARTUPTEXT
    LEAF_ENTRY StartUp
    
    b	ResetHandler  
    b	.
    b	.
    b	.		
    b	.		
    b	.		
    b	.			
    b	.

;------------------------------------------------------------------------------
PowerOffCPU     ; Where is used this function??? by DJKIM 2006/10/14
	str		r1, [r0]		; Enable SDRAM self-refresh
	str		r3, [r2]		; MISCCR Setting
	str     r5, [r4]		; Power Off !!
	b       .

;------------------------------------------------------------------------------
    ; Resume handler code.
    ;
WAKEUP_POWER_OFF
    ; Release SCLKn after wake-up from the POWER_OFF mode.
    ldr		r1, =MISCCR     ; Miscellaneous control register
    ldr		r0, [r1]
    bic		r0, r0, #(7<<17) ; SCLK0:0->SCLK, SCLK1:0->SCLK, SCKE:L->H.
    str		r0, [r1]

    ; Set up the memory control registers.
    ;
    add     r0, pc, #SMRDATA - (. + 8)
    ldr		r1, =BWSCON	     ; BWSCON Address.
    add		r2, r0, #52	     ; End address of SMRDATA.
3       
    ldr		r3, [r0], #4    
    str		r3, [r1], #4    
    cmp		r2, r0		
    bne		%B3

	mov     r0, #0x2000
4
	subs    r0, r0, #1
	bne     %B4

;------------------------------------------------------------------------------
;   Recover Process : Starting Point
;
; Where is it(SLEEPDATA_xxx) stored??? by DJKIM 2006/10/14
; Refer to kernel\oal\Startup.s
;   1. Checksum Calculation saved Data
	ldr     r5, =SLEEPDATA_BASE_PHYSICAL    ; pointer to physical address of reserved Sleep mode info data structure 
	mov     r3, r5                          ; pointer for checksum calculation
	ldr     r2, =0x0
	ldr     r0, =(SLEEPDATA_SIZE-1)             ; get size of data structure to do checksum on

	; r3 = SLEEPDATA_BASE_PHYSICAL
	; r5 = SLEEPDATA_BASE_PHYSICAL
	; r2 = check sum
	; r0 = SLEEPDATA_SIZE-1
50	
	ldr     r1, [r3], #4                    ; pointer to SLEEPDATA
	and     r1, r1, #0x1
	mov     r1, r1, ROR #31             ; ROR -> Rotate right
	add     r2, r2, r1                      ; r2 : Check sum
	subs    r0, r0, #1                      ; dec the count
	bne     %b50                            ; loop till done    

	ldr     r0,=GSTATUS3                ; GSTATUS3 : inform reg
	ldr     r3, [r0]                        ; get the Sleep data checksum from the Power Manager Scratch pad register
	cmp     r2, r3                          ; compare to what we saved before going to sleep
	bne     BringUpWinCE                    ; bad news - do a cold boot
   
;   2. MMU Enable
	ldr     r10, [r5, #SleepState_MMUDOMAIN] ; load the MMU domain access info
	ldr     r9,  [r5, #SleepState_MMUTTB]    ; load the MMU TTB info 
	ldr     r8,  [r5, #SleepState_MMUCTL]    ; load the MMU control info 
	ldr     r7,  [r5, #SleepState_WakeAddr ] ; load the LR address
	nop         
	nop
	nop
	nop
	nop

; if software reset     ; What is means??? (Just reg reset???) by DJKIM 2006/10/14
	mov     r1, #0
	teq     r1, r7      ; r1 ^ r7
	bne     %f60
	b      	BringUpWinCE

; wakeup routine
; MMU setting
60	mcr     p15, 0, r10, c3, c0, 0          ; setup access to domain 0, cp15:c3 -> Domain access reg
	mcr     p15, 0, r9,  c2, c0, 0          ; PT address, cp15:c2 -> TTB reg
	mcr     p15, 0, r0,  c8, c7, 0          ; flush I+D TLBs
	mcr     p15, 0, r8,  c1, c0, 0          ; restore MMU control, cp15:c1 -> Control reg

;   3. Jump to Kernel Image's fw.s (Awake_address)
	mov     pc, r7                          ;  jump to new VA (back up Power management stack)
	nop

BringUpWinCE
	; bad news, data lose, bring up wince again     ; Need to be modified by DJKIM 2006/10/14
	mov 	r0, #2
	ldr		r1, =GSTATUS2       ; GSTATUS2 = Rest status reg
	str		r0, [r1]                ; Wakeup reset in sleep mode
;------------------------------------------------------------------------------

  LTORG   
	
;-----------------------------------
; Steppingstone loader entry point.
;-----------------------------------
ResetHandler

    ; Cache & TLB intialize ??? by DJKIM 2006/10/14

    ;-----------------------------------------------------
    ;	Watch dog timer disable setting		Need to be modified by DJKIM 2006/10/14
    ;-----------------------------------------------------
    ldr		r0, =WTCON       ; disable the watchdog timer.
    ldr		r1, =0x0         
    str		r1, [r0]

    ;-----------------------------------------------------
    ;	Interrupt disable & Power control	Need to be modified by DJKIM2006/10/14
    ;-----------------------------------------------------
    ldr		r0, =INTMSK      ; mask all first-level interrupts.
    ldr		r1, =0xffffffff
    str		r1, [r0]

    ldr		r0, =INTSUBMSK   ; mask all second-level interrupts.
    ldr		r1, =0x7fff
    str		r1, [r0]

    ;-----------------------------------------------------
    ;	Clock divider setting		Need to be modified by DJKIM 2006/10/14
    ;-----------------------------------------------------
    ldr 	r0,=CLKDIVN
    ldr 	r1,=0x7     ; 0x0 = 1:1:1  ,  0x1 = 1:1:2	, 0x2 = 1:2:2  ,  0x3 = 1:2:4,  0x4 = 1:4:4,  0x5 = 1:4:8, 0x6 = 1:3:3, 0x7 = 1:3:6
    str 	r1,[r0]

    ;-----------------------------------------------------
    ;	Battery fault function setting		Need to be modified by DJKIM 2006/10/14
    ;-----------------------------------------------------
    ; BATT_FLT
    ldr		r1, =MISCCR     ; Miscellaneous control reg
    ldr		r0, [r1]
    bic		r0, r0, #(7<<20)
    orr		r0, r0, #(4<<20)
    str		r0, [r1]

    ;-----------------------------------------------------
    ;	Asynchronous bus mode setting		Need to be modified by DJKIM 2006/10/14
    ;-----------------------------------------------------
    ; MMU_SetAsyncBusMode FCLK:HCLK= 1:2    ; Don't need this by DJKIM 2006/10/14
    ands 	r1, r1, #0x2        ; Just jump 5 label (r1=MISCCR reg addr & 0x2 => 0)
    beq 	%F5
    bl		MMU_SetAsyncBusMode

    ;---------------------------------------------------------------------------
    ; Clock & PLL setting	Need to be modified by DJKIM 2006/10/14
    ; FCLK  - used by ARM920T
    ; HCLK  - used for AHB
    ; PCLK  - used for APB
    ;-----------------------------
5
; TODO: to reduce PLL lock time, adjust the LOCKTIME register.  ; Need to be modified by DJKIM 2006/10/14
    ldr		r0, =LOCKTIME
    ldr		r1, =0xffffff
    str		r1, [r0]

    ; Configure the clock PLL.
    ; Refer to option.inc : PLL_ON_START is TRUE
  	[ PLL_ON_START
	
        ldr		r0, =UPLLCON        ; UPLL - USB CLK
        ldr		r1, =((0x3c<<12)+(0x4<<4)+0x2)  ; Fin=16.9344MHz, Fout=48MHz.
        str		r1, [r0]

	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

        ldr		r0, =MPLLCON        ; MPLL - MCU CLK
        ldr		r1, =((M_MDIV<<12)+(M_PDIV<<4)+M_SDIV)  ; Fin=16.9344MHz, Fout=400MHz.
        str		r1, [r0]

    mov     r0, #0x2000
10   
    subs    r0, r0, #1
    bne     %B10
	]

    ;-----------------------------------------------------
    ; Are we waking up from a suspended state?  Need to be modified by DJKIM 2006/10/14
    ;-----------------------------------------------------
    ldr		r1, =GSTATUS2       ; Reset status reg
    ldr		r0, [r1]
    tst		r0, #0x2
    ; Sleep reset Yes?  Then go to the resume handler code...
    bne		WAKEUP_POWER_OFF    ; When wakeup in sleep mode

    ; When Power reset or WDT reset is...
    ;-----------------------------------------------------
    ; Set up the memory control registers.  Need to be modified by DJKIM 2006/10/14
    ;-----------------------------------------------------
    add     r0, pc, #SMRDATA - (. + 8)
    ldr		r1, =BWSCON	     ; BWSCON Address.
    add		r2, r0, #52	     ; End address of SMRDATA.
15       
    ldr		r3, [r0], #4    
    str		r3, [r1], #4    
    cmp		r2, r0		
    bne		%B15

    ;-----------------------------------------------------
    ; Turn on all LEDs. Don't need to this by DJKIM 2006/10/14
    ;-----------------------------------------------------
    ldr		r0, =GPFCON
    ldr		r1, =0x55aa
    str		r1, [r0]
    ldr		r0, =GPFUP
    ldr		r1, =0xff
    str		r1, [r0]
    ldr		r0, =GPFDAT
    ldr		r1, =0x0
    str		r1, [r0]

    ;-----------------------------------------------------  
    ; If this is a cold boot or a warm reset, clear RAM because the RAM filesystem may be
    ; bad.  If this is a software reboot (triggered by the watchdog timer), don't clear RAM.
    ;-----------------------------------------------------
    ; Need to be modified by DJKIM 2006/10/14

    ldr		r1, =GSTATUS2   ; Determine why we're in the startup code. Reset status reg
    ldr		r10, [r1]       ; 
    str  	r10, [r1]       ; Clear GPSTATUS2.
    tst		r10, #0x4       ; Watchdog (software) reboot?  Skip code that clears RAM.
    bne		%F30

    ;-----------------------------------------------------
    ; Clear RAM.    Need to be modified by DJKIM 2006/10/14
    ;-----------------------------------------------------
    mov 	r1,#0
    mov 	r2,#0
    mov 	r3,#0
    mov 	r4,#0
    mov 	r5,#0
    mov 	r6,#0
    mov 	r7,#0
    mov 	r8,#0
	
    ldr		r0,=0x30000000   ; Start address (physical 0x3000.0000).
    ldr		r9,=0x04000000   ; 64MB of RAM.
20	
    stmia	r0!, {r1-r8}
    subs	r9, r9, #32 
    bne		%B20

    ;-----------------------------------------------------
    ; Initialize stacks.
    ;-----------------------------------------------------
30
    mrs		r0, cpsr
    bic		r0, r0, #MODEMASK|NOINT
    orr		r1, r0, #SVCMODE
    msr		cpsr_cxsf, r1		  ; SVCMode.
    ldr		sp, =SVCStack
	
    ; Jump to main C routine.
    ;
    bl		main

	LTORG

SMRDATA DATA
    ; Memory configuration should be optimized for best performance .
    ; The following parameter is not optimized.                     
    ; Memory access cycle parameter strategy
    ; 1) The memory settings is  safe parameters even at HCLK=75Mhz.
    ; 2) SDRAM refresh period is for HCLK=75Mhz. 
    ;
    DCD (0+(B1_BWSCON<<4)+(B2_BWSCON<<8)+(B3_BWSCON<<12)+(B4_BWSCON<<16)+(B5_BWSCON<<20)+(B6_BWSCON<<24)+(B7_BWSCON<<28))
    DCD ((B0_Tacs<<13)+(B0_Tcos<<11)+(B0_Tacc<<8)+(B0_Tcoh<<6)+(B0_Tah<<4)+(B0_Tacp<<2)+(B0_PMC))   ;GCS0
    DCD ((B1_Tacs<<13)+(B1_Tcos<<11)+(B1_Tacc<<8)+(B1_Tcoh<<6)+(B1_Tah<<4)+(B1_Tacp<<2)+(B1_PMC))   ;GCS1 
    DCD ((B2_Tacs<<13)+(B2_Tcos<<11)+(B2_Tacc<<8)+(B2_Tcoh<<6)+(B2_Tah<<4)+(B2_Tacp<<2)+(B2_PMC))   ;GCS2
    DCD ((B3_Tacs<<13)+(B3_Tcos<<11)+(B3_Tacc<<8)+(B3_Tcoh<<6)+(B3_Tah<<4)+(B3_Tacp<<2)+(B3_PMC))   ;GCS3
    DCD ((B4_Tacs<<13)+(B4_Tcos<<11)+(B4_Tacc<<8)+(B4_Tcoh<<6)+(B4_Tah<<4)+(B4_Tacp<<2)+(B4_PMC))   ;GCS4
    DCD ((B5_Tacs<<13)+(B5_Tcos<<11)+(B5_Tacc<<8)+(B5_Tcoh<<6)+(B5_Tah<<4)+(B5_Tacp<<2)+(B5_PMC))   ;GCS5
    DCD ((B6_MT<<15)+(B6_Trcd<<2)+(B6_SCAN))                                                        ;GCS6
    DCD ((B7_MT<<15)+(B7_Trcd<<2)+(B7_SCAN))                                                        ;GCS7
    DCD ((REFEN<<23)+(TREFMD<<22)+(Trp<<20)+(Trc<<18)+(Tchr<<16)+REFCNT)    
    
    DCD (0x32|0x80)     ; SCLK power saving mode, BANKSIZE 128M/128M, 4-burst.

    DCD 0x20            ; MRSR6 CL=3clk.
    DCD 0x20            ; MRSR7.


;------------------------------------
; MMU Cache/TLB/etc on/off functions
;------------------------------------
R1_I	        EQU	(1<<12)
R1_C	EQU	(1<<2)
R1_A	EQU	(1<<1)
R1_M  	EQU	(1)
R1_iA	EQU	(1<<31)
R1_nF 	EQU	(1<<30)

;------------------------------------
; void MMU_EnableICache(void);

    LEAF_ENTRY MMU_EnableICache	
    
    mrc 	p15, 0, r0, c1, c0, 0
    orr 	r0, r0, #R1_I           ; R1_I - I-cache
    mcr 	p15, 0, r0, c1, c0, 0
    mov 	pc, lr

;------------------------------------
; void MMU_SetAsyncBusMode(void);
; FCLK:HCLK= 1:2
;
; Need this ??? by DJKIM 2006/10/14

    LEAF_ENTRY MMU_SetAsyncBusMode
    mrc 	p15, 0, r0, c1, c0, 0
    orr 	r0, r0, #R1_nF:OR:R1_iA
    mcr 	p15, 0, r0, c1, c0, 0
    mov 	pc, lr

;------------------------------------
; NAND code...
;
A410_BASE_ADDR	EQU	0x2000000

	MACRO
	LDR4STR1 $src,$tmp1,$tmp2	
	ldrb	$tmp1,[$src]
	ldrb	$tmp2,[$src]
	orr		$tmp1,$tmp1,$tmp2,LSL #8
	ldrb	$tmp2,[$src]
	orr		$tmp1,$tmp1,$tmp2,LSL #16
	ldrb	$tmp2,[$src]
	orr		$tmp1,$tmp1,$tmp2,LSL #24
	MEND

;------------------------------------
	EXPORT	__RdPage512
__RdPage512
	;input:a1(r0)=pPage
	stmfd	sp!,{r1-r11}

	ldr	r1,=0x4e000010  ;NFDATA - NAND flash data reg   Need to be modified by DJKIM 2006/10/14
	mov	r2,#0x200           ; 0x200 - 512
10	
	LDR4STR1 	r1,r4,r3
	LDR4STR1 	r1,r5,r3
	LDR4STR1 	r1,r6,r3
	LDR4STR1 	r1,r7,r3
	LDR4STR1 	r1,r8,r3
	LDR4STR1 	r1,r9,r3
	LDR4STR1 	r1,r10,r3
	LDR4STR1 	r1,r11,r3
	stmia		r0!,{r4-r11}
	subs		r2,r2,#32
	bne			%B10

	ldmfd		sp!,{r1-r11}
	mov			pc,lr

    END

