;****************************************************************************
;* file name	: Startup.s
;* Date			: 07. 04. 2006
;* Version		: 1.0
;* Description	: Startup code
;*				  
;****************************************************************************/

;	GET option.s
	GET memcfg.s
	GET smt926addr.inc

BIT_SELFREFRESH EQU	(1<<22)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Pre-defined constants

USERMODE    EQU 	0x10
FIQMODE     EQU 	0x11
IRQMODE     EQU 	0x12
SVCMODE     EQU 	0x13
ABORTMODE   EQU 	0x17
UNDEFMODE   EQU 	0x1b
MODEMASK    EQU 	0x1f
NOINT       EQU 	0xc0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;The location of stacks		- Further work

;				Size
; UserStack		14KB
; SVCStack		10KB
; UndefStack	9KB
; AbortStack	8KB
; IRQStack		4KB
; FIQStack		0KB

UserStack	EQU	(_STACK_BASEADDRESS-0x3800)	;0x31ff4800 ~  ; 32MB SDRAM
SVCStack	EQU	(_STACK_BASEADDRESS-0x2800)	;0x31ff5800 ~
UndefStack	EQU	(_STACK_BASEADDRESS-0x2400)	;0x31ff5c00 ~
AbortStack	EQU	(_STACK_BASEADDRESS-0x2000)	;0x31ff6000 ~
IRQStack    EQU	(_STACK_BASEADDRESS-0x1000)	;0x31ff7000 ~
FIQStack    EQU	(_STACK_BASEADDRESS-0x0)	;0x31ff8000 ~
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Check if tasm.exe(armasm -16 ...@ADS 1.0) is used.

	GBLL    THUMBCODE	; GBLL - Declares GLOBAL logical variable
	[ {CONFIG} = 16
THUMBCODE SETL  {TRUE}
	    CODE32
 		|
THUMBCODE SETL  {FALSE}
    ]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MACRO Definition

 		MACRO
	MOV_PC_LR
 		[ THUMBCODE
	    bx lr
 		|
	    mov	pc,lr
 		]
	MEND

 		MACRO
	MOVEQ_PC_LR
 		[ THUMBCODE
        bxeq lr
 		|
	    moveq pc,lr
 		]
	MEND

;--------------------------------------------------------------------
; Interrupt Handler MACRO Define
 		MACRO			
$HandlerLabel HANDLER $HandleLabel

$HandlerLabel
	sub	sp,sp,#4		; Decrement sp(to store jump address)
	stmfd	sp!,{r0}	; PUSH the work register to stack(lr does't push because it return to original address)
	ldr     r0,=$HandleLabel; Load the address of HandleXXX to r0
	ldr     r0,[r0]		; Load the contents(service routine start address) of HandleXXX
	str     r0,[sp,#4]	; Store the contents(ISR) of HandleXXX to stack
	ldmfd   sp!,{r0,pc}	; POP the work register and pc(jump to ISR)
	MEND
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Extern variable import

	IMPORT  |Image$$RO$$Limit|	; End of ROM code (=start of ROM data)
	IMPORT  |Image$$RW$$Base|	; Base of RAM to initialise
	IMPORT  |Image$$ZI$$Base|	; Base and limit of area
	IMPORT  |Image$$ZI$$Limit|	; to zero initialise

	IMPORT	MMU_SetAsyncBusMode
	IMPORT	Main

	EXPORT StartPointAfterSleepWakeUp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	AREA    Init,CODE,READONLY
	ENTRY

	; 1)The code, which converts to Big-endian, should be in little endian code.
	; 2)The following little endian code will be compiled in Big-Endian mode.
	;   The code byte order should be changed as the memory bus width.
	; 3)The pseudo instruction,DCD can't be used here because the linker generates error.
	ASSERT	:DEF:ENDIAN_CHANGE	; Generate an err message if ENDIAN_CHANGE is not defined(fail)
	[ ENDIAN_CHANGE				; ENDIAN_CHAGNE is true?
	    ASSERT  :DEF:ENTRY_BUS_WIDTH	; Generate an err message if ENTRY_BUS_WIDTH is not defined(fail)
	    [ ENTRY_BUS_WIDTH=32
		b	ChangeBigEndian	    ;DCD 0xea000007
	    ]

	    [ ENTRY_BUS_WIDTH=16
		andeq	r14,r7,r0,lsl #20   ;DCD 0x0007ea00
	    ]

	    [ ENTRY_BUS_WIDTH=8
		streq	r0,[r0,-r10,ror #1] ;DCD 0x070000ea
	    ]
	|
__start
	    b	ResetHandler
    ]

	b	HandlerUndef	; handler for Undefined mode
	b	HandlerSWI		; handler for SWI interrupt
	b	HandlerPabort	; handler for PAbort
	b	HandlerDabort	; handler for DAbort
	b	.				; reserved
	b	HandlerIRQ		; handler for IRQ interrupt
	b	HandlerFIQ		; handler for FIQ interrupt

;@0x20
	b	EnterPWDN		; Must be @0x20


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ENTRY
ResetHandler
    ;--------------------------------------------------------------------
    ; Watch dog timer / Interrupt disable
	;==================
	ldr	r0,=WTCON		; watch dog disable
	ldr	r1,=0x0
	str	r1,[r0]

	ldr	r0,=INTMSK
	ldr	r1,=0xffffffff	; all interrupt disable
	str	r1,[r0]

	ldr	r0,=INTSUBMSK
	ldr	r1,=0x3ff		; all sub interrupt disable
	str	r1,[r0]
    ;--------------------------------------------------------------------

    ;--------------------------------------------------------------------
    ; LED display
    ;==================
	[ {FALSE}
	; rGPFDAT = (rGPFDAT & ~(0xf<<4)) | ((~data & 0xf)<<4);
	; Led_Display
	ldr	r0,=GPFCON
	ldr	r1,=0x5500
	str	r1,[r0]
	ldr	r0,=GPFDAT
	ldr	r1,=0x10
	str	r1,[r0]
	]
    ;--------------------------------------------------------------------

    ;--------------------------------------------------------------------
	;To reduce PLL lock time, adjust the LOCKTIME register.
	;==================
	ldr	r0,=LOCKTIME	; pll lock time counter register
	ldr	r1,=0xffffff
	str	r1,[r0]
    ;--------------------------------------------------------------------

    ;--------------------------------------------------------------------
    ; PLL setting (MPLL / UPLL)
    ;==================
    [ PLL_ON_START
	; Added for confirm clock divide. for 2440.
	; Setting value Fclk:Hclk:Pclk
	ldr	r0,=CLKDIVN			; clock divider (FCLK, HCLK, PCLK)
	ldr	r1,=CLKDIV_VAL		; 0=1:1:1, 1=1:1:2, 2=1:2:2, 3=1:2:4, 4=1:4:4, 5=1:4:8, 6=1:3:3, 7=1:3:6.
	str	r1,[r0]

	[ CLKDIV_VAL>1 			; means Fclk:Hclk is not 1:1.
	bl MMU_SetAsyncBusMode
	|
	bl MMU_SetFastBusMode	; default value.
	]

	;Configure UPLL
	ldr	r0,=UPLLCON			; usb pll register
	ldr	r1,=((U_MDIV<<12)+(U_PDIV<<4)+U_SDIV)
	str	r1,[r0]
	
	nop						; Caution: After UPLL setting, 
	nop						; at least 7-clocks delay must be inserted for setting hardware be completed.
	nop
	nop
	nop
	nop
	nop

	; Configure MPLL
	ldr	r0,=MPLLCON
	ldr	r1,=((M_MDIV<<12)+(M_PDIV<<4)+M_SDIV) 
	str	r1,[r0]
    ]
    ;--------------------------------------------------------------------

    ;--------------------------------------------------------------------
    ; Check wakeup from sleep
	;==================
    ; Check if the boot is caused by the wake-up from SLEEP mode.
	ldr	r1,=GSTATUS2		; reset status register
	ldr	r0,[r1]
	tst	r0,#0x2

	bne	WAKEUP_SLEEP		; When the wake-up from SLEEP mode is
    ;--------------------------------------------------------------------

    ;--------------------------------------------------------------------
    ; Memory BANK configuration
	;==================
StartPointAfterSleepWakeUp
 	ldr	r0,=SMRDATA
	ldr	r1,=BWSCON			; BWSCON Address
	add	r2, r0, #52			; End address of SMRDATA

0
	ldr	r3, [r0], #4
	str	r3, [r1], #4		; BANK memory control setting
	cmp	r2, r0
	bne	%B0
    ;--------------------------------------------------------------------

    ;--------------------------------------------------------------------
 	; Initialize stacks
 	;==================
Init_Stack
	bl	InitStacks
    ;--------------------------------------------------------------------

    ;--------------------------------------------------------------------
  	; Setup IRQ handler
  	;==================
	ldr	r0,=HandleIRQ		; This routine is needed
	;ldr	r1,=IsrIRQ			; if there isn't 'subs pc,lr,#4' at 0x18, 0x1c
	ldr	r1, =IsrIRQHW		; H/W vectored interrupt
	str	r1,[r0]
    ;--------------------------------------------------------------------

    ;--------------------------------------------------------------------
   	; Copy and paste RW data/zero initialized data
   	;==================
	LDR     r0, =|Image$$RO$$Limit|	; Get pointer to ROM data
	LDR     r1, =|Image$$RW$$Base|	; and RAM copy
	LDR     r3, =|Image$$ZI$$Base|  
	
	; Zero init base => top of initialised data
	CMP     r0, r1			; Check that they are different
	BEQ     %F2
1       
	CMP     r1, r3			; Copy init data
	LDRCC   r2, [r0], #4	; -> LDRCC r2, [r0] + ADD r0, r0, #4         
	STRCC   r2, [r1], #4	; -> STRCC r2, [r1] + ADD r1, r1, #4
	BCC     %B1
2       
	LDR     r1, =|Image$$ZI$$Limit| ; Top of zero init segment
	MOV     r2, #0
3       
	CMP     r3, r1			; Zero init
	STRCC   r2, [r3], #4
	BCC     %B3
    ;--------------------------------------------------------------------

    ;--------------------------------------------------------------------
	; Interrupt Enable
   	;==================
	mrs		r0, cpsr
	bic		r0, r0,#MODEMASK
	orr		r1, r0,#USERMODE
	msr		cpsr_cxsf, r1	;UserMode & Enable interrupt
	ldr		sp, =UserStack	; UserStack initialize
    ;--------------------------------------------------------------------

    ;--------------------------------------------------------------------
   	; Main
   	;==================
    [ :LNOT:THUMBCODE
    	BL  Main
    	B   .                       
    ]

    [ THUMBCODE         	;for start-up code for Thumb mode
    	orr     lr,pc,#1
    	bx   	lr
    	CODE16
    	bl  	Main
    	b       .
    	CODE32
    ]
    ;--------------------------------------------------------------------
; End of Main ENTRY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;function initializing stacks
InitStacks
	; Don't use DRAM,such as stmfd,ldmfd......
	; SVCstack is initialized before
	; Under toolkit ver 2.5, 'msr cpsr,r1' can be used instead of 'msr cpsr_cxsf,r1'
	mrs	r0,cpsr
	bic	r0,r0,#MODEMASK
	orr	r1,r0,#UNDEFMODE|NOINT
	msr	cpsr_cxsf,r1		; UndefMode
	ldr	sp,=UndefStack

	orr	r1,r0,#ABORTMODE|NOINT
	msr	cpsr_cxsf,r1		; AbortMode
	ldr	sp,=AbortStack

	orr	r1,r0,#IRQMODE|NOINT
	msr	cpsr_cxsf,r1		; IRQMode
	ldr	sp,=IRQStack

	orr	r1,r0,#FIQMODE|NOINT
	msr	cpsr_cxsf,r1		; FIQMode
	ldr	sp,=FIQStack

	bic	r0,r0,#MODEMASK|NOINT
	orr	r1,r0,#SVCMODE
	msr	cpsr_cxsf,r1		; SVCMode
	ldr	sp,=SVCStack

	;USER mode has not be initialized.

	mov	pc,lr
	; The LR register won't be valid if the current mode is not SVC mode.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Exception handler routine

; **** Further work - Need to modify after spec fix by djkim 2006/07/05
	LTORG
HandlerUndef		HANDLER	HandleUndef
HandlerSWI			HANDLER	HandleSWI
HandlerPabort		HANDLER	HandlePabort
HandlerDabort		HANDLER	HandleDabort
HandlerIRQ			HANDLER	HandleIRQ
HandlerFIQ			HANDLER	HandleFIQ

HandlerEINT0		HANDLER	HandleEINT0
HandlerEINT1		HANDLER	HandleEINT1
HandlerEINT2		HANDLER	HandleEINT2
HandlerEINT3		HANDLER	HandleEINT3

HandlerIIC0			HANDLER	HandleIIC0
HandlerIIC0_AAS		HANDLER	HandleIIC0_AAS

HandlerTIMER0_TOF	HANDLER	HandleTIMER0_TOF
HandlerTIMER0_TMC	HANDLER	HandleTIMER0_TMC
HandlerTIMER1_TOF	HANDLER	HandleTIMER1_TOF
HandlerTIMER1_TMC	HANDLER	HandleTIMER1_TMC
HandlerTIMER2_TOF	HANDLER	HandleTIMER2_TOF
HandlerTIMER2_TMC	HANDLER	HandleTIMER2_TMC

HandlerEINT4		HANDLER	HandleEINT4
HandlerEINT5		HANDLER	HandleEINT5
HandlerEINT6		HANDLER	HandleEINT6
HandlerEINT7		HANDLER	HandleEINT7

HandlerIIC1			HANDLER	HandleIIC1
HandlerIIC1_AAS		HANDLER	HandleIIC1_AAS

HandlerWDT			HANDLER	HandleWDT
HandlerADC			HANDLER	HandleADC

HandlerUTX			HANDLER	HandleUTX
HandlerURX			HANDLER	HandleURX

HandlerTIMER3_TOF	HANDLER	HandleTIMER3_TOF
HandlerTIMER3_TMC	HANDLER	HandleTIMER3_TMC
HandlerTIMER4_TOF	HANDLER	HandleTIMER4_TOF
HandlerTIMER4_TMC	HANDLER	HandleTIMER4_TMC
HandlerTIMER5_TOF	HANDLER	HandleTIMER5_TOF
HandlerTIMER5_TMC	HANDLER	HandleTIMER5_TMC
HandlerTIMER6_TOF	HANDLER	HandleTIMER6_TOF
HandlerTIMER6_TMC	HANDLER	HandleTIMER6_TMC
HandlerTIMER7_TOF	HANDLER	HandleTIMER7_TOF
HandlerTIMER7_TMC	HANDLER	HandleTIMER7_TMC

;--------------------------------------------------------------------
; IRQ/FIQ interrupt service routine (H/W vectored method)
;==================
IsrIRQHW    ; usingI_VECADDR/F_VECADDR
	sub		sp,sp,#4       ;reserved for PC
	stmfd	sp!,{r8-r9}   

	;IMPORTANT CAUTION
	;if I_ISPC isn't used properly, I_ISPR can be 0 in this routine.

	ldr		r9,=I_ISPR
	ldr		r9,[r9]

	cmp		r9, #0x0	;If the IDLE mode work-around is used,
						;r9 may be 0 sometimes.
	beq		%F2

0
	ldr		r8,=I_VECADDR
	ldr		r8, [r8]
1
	ldr		r9,=HandleEINT0
	add		r9,r9,r8
	ldr		r9,[r9]
	str		r9,[sp,#8]
	ldmfd	sp!,{r8-r9,pc}

2
	ldmfd	sp!,{r8-r9}
	add		sp,sp,#4
	subs	pc,lr,#4


;--------------------------------------------------------------------
; IRQ/FIQ interrupt service routine (S/W vectored method)
;==================
;One of the following two routines can be used for non-vectored interrupt.

IsrIRQ	;using I_ISPR register.
	sub		sp,sp,#4       ;reserved for PC
	stmfd	sp!,{r8-r9}   

	;IMPORTANT CAUTION
	;if I_ISPC isn't used properly, I_ISPR can be 0 in this routine.

	ldr		r9,=I_ISPR
	ldr		r9,[r9]

	cmp		r9, #0x0	;If the IDLE mode work-around is used,
						;r9 may be 0 sometimes.
	beq		%F2

	mov		r8,#0x0
0
	movs	r9,r9,lsr #1
	bcs		%F1			; bcs - Branch if C set
	add		r8,r8,#4
	b		%B0

1
	ldr		r9,=HandleEINT0
	add		r9,r9,r8
	ldr		r9,[r9]
	str		r9,[sp,#8]
	ldmfd	sp!,{r8-r9,pc}

2
	ldmfd	sp!,{r8-r9}
	add		sp,sp,#4
	subs	pc,lr,#4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ChangeBigEndian
;@0x24
	[ ENTRY_BUS_WIDTH=32
	    DCD	0xee110f10	; 0xee110f10 => mrc p15,0,r0,c1,c0,0
	    DCD	0xe3800080	; 0xe3800080 => orr r0,r0,#0x80;  //Big-endian
	    DCD	0xee010f10	; 0xee010f10 => mcr p15,0,r0,c1,c0,0
	]
	[ ENTRY_BUS_WIDTH=16
	    DCD 0x0f10ee11
	    DCD 0x0080e380
	    DCD 0x0f10ee01
	]
	[ ENTRY_BUS_WIDTH=8
	    DCD 0x100f11ee
	    DCD 0x800080e3
	    DCD 0x100f01ee
    ]
	DCD 0xffffffff		; swinv 0xffffff is similar with NOP and run well in both endian mode.
	DCD 0xffffffff
	DCD 0xffffffff
	DCD 0xffffffff
	DCD 0xffffffff
	b ResetHandler
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function for entering power down mode
; 1. SDRAM should be in self-refresh mode.
; 2. All interrupt should be maksked for SDRAM/DRAM self-refresh.
; 3. LCD controller should be disabled for SDRAM/DRAM self-refresh.
; 4. The I-cache may have to be turned on.
; 5. The location of the following code may have not to be changed.

;--------------------------------------------------------------------
;void EnterPWDN(int CLKCON);
;==================
EnterPWDN
	mov r2,r0			; r2=rCLKCON CLKCON - clk control register
	tst r0,#0x8			; SLEEP mode?
	bne ENTER_SLEEP
;--------------------------------------------------------------------

;--------------------------------------------------------------------
ENTER_STOP
	ldr r0,=REFRESH		; REFRESH - DRAM, SRAM refresh control register
	ldr r3,[r0]			; r3=rREFRESH
	mov r1, r3
	orr r1, r1, #BIT_SELFREFRESH
	str r1, [r0]		; Enable SDRAM self-refresh

	mov r1,#16			; wait until self-refresh is issued. may not be needed.
0	subs r1,r1,#1
	bne %B0

	ldr r0,=CLKCON		; enter STOP mode
	str r2,[r0]

	mov r1,#32
0	subs r1,r1,#1		; 1) wait until the STOP mode is in effect.
	bne %B0				; 2) Or wait here until the CPU&Peripherals will be turned-off
						;    Entering SLEEP mode, only the reset by wake-up is available.

	ldr r0,=REFRESH		;exit from SDRAM self refresh mode.
	str r3,[r0]

	MOV_PC_LR
;--------------------------------------------------------------------

;--------------------------------------------------------------------
ENTER_SLEEP
	; NOTE.
	; 1) rGSTATUS3 should have the return address after wake-up from SLEEP mode.

	ldr r0,=REFRESH		; REFRESH - DRAM, SRAM refresh control register
	ldr r1,[r0]			; r1=rREFRESH
	orr r1, r1, #BIT_SELFREFRESH
	str r1, [r0]		; Enable SDRAM self-refresh

	mov r1,#16			; Wait until self-refresh is issued,which may not be needed.
0	subs r1,r1,#1
	bne %B0

	ldr	r1,=MISCCR		; Miscellaneous control register
	ldr	r0,[r1]
	orr	r0,r0,#(7<<17)	; Set SCLK0=0, SCLK1=0, SCKE=0 (SRAM clk setting)
	str	r0,[r1]

	ldr r0,=CLKCON		; Enter sleep mode
	str r2,[r0]

	b .			;CPU will die here.
;--------------------------------------------------------------------

;--------------------------------------------------------------------
WAKEUP_SLEEP
	; Release SCLKn after wake-up from the SLEEP mode.
	ldr	r1,=MISCCR
	ldr	r0,[r1]
	bic	r0,r0,#(7<<17)	; SCLK0:0->SCLK, SCLK1:0->SCLK, SCKE:0->=SCKE (SRAM clk setting)
	str	r0,[r1]

	; Set memory control registers
 	ldr	r0,=SMRDATA
	ldr	r1,=BWSCON		; BWSCON Address
	add	r2, r0, #52		; End address of SMRDATA
0
	ldr	r3, [r0], #4	; BANK memory control setting
	str	r3, [r1], #4
	cmp	r2, r0
	bne	%B0

	mov r1,#256
0	subs r1,r1,#1		; 1) wait until the SelfRefresh is released.
	bne %B0

	ldr r1,=GSTATUS3	; GSTATUS3 has the start address just after SLEEP wake-up
	ldr r0,[r1]			; GSTATUS3 - Information register

	mov pc,r0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
;=====================================================================
; Clock division test
; Assemble code, because VSYNC time is very short
;=====================================================================
	EXPORT CLKDIV124
	EXPORT CLKDIV144
	
CLKDIV124
	
	ldr     r0, = CLKDIVN
	ldr     r1, = 0x3		; 0x3 = 1:2:4
	str     r1, [r0]
;	wait until clock is stable
	nop
	nop
	nop
	nop
	nop

	ldr     r0, = REFRESH
	ldr     r1, [r0]
	bic		r1, r1, #0xff
	bic		r1, r1, #(0x7<<8)
	orr		r1, r1, #0x470	; REFCNT135
	str     r1, [r0]
	nop
	nop
	nop
	nop
	nop
	mov     pc, lr

CLKDIV144
	ldr     r0, = CLKDIVN
	ldr     r1, = 0x4		; 0x4 = 1:4:4
	str     r1, [r0]
;	wait until clock is stable
	nop
	nop
	nop
	nop
	nop

	ldr     r0, = REFRESH
	ldr     r1, [r0]
	bic		r1, r1, #0xff
	bic		r1, r1, #(0x7<<8)
	orr		r1, r1, #0x630	; REFCNT675 - 1520
	str     r1, [r0]
	nop
	nop
	nop
	nop
	nop
	mov     pc, lr


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	LTORG					; Literal pool org

SMRDATA DATA
; Memory configuration should be optimized for best performance
; The following parameter is not optimized.
; Memory access cycle parameter strategy
; 1) The memory settings is  safe parameters even at HCLK=75Mhz.
; 2) SDRAM refresh period is for HCLK<=75Mhz.

; **** Further work - Need to modify after spec fix by djkim 2006/07/05
	DCD (0+(B1_BWSCON<<4)+(B2_BWSCON<<8)+(B3_BWSCON<<12)+(B4_BWSCON<<16)+(B5_BWSCON<<20)+(B6_BWSCON<<24)+(B7_BWSCON<<28))
	DCD ((B0_Tacs<<13)+(B0_Tcos<<11)+(B0_Tacc<<8)+(B0_Tcoh<<6)+(B0_Tah<<4)+(B0_Tacp<<2)+(B0_PMC))   ;GCS0
	DCD ((B1_Tacs<<13)+(B1_Tcos<<11)+(B1_Tacc<<8)+(B1_Tcoh<<6)+(B1_Tah<<4)+(B1_Tacp<<2)+(B1_PMC))   ;GCS1
	DCD ((B2_Tacs<<13)+(B2_Tcos<<11)+(B2_Tacc<<8)+(B2_Tcoh<<6)+(B2_Tah<<4)+(B2_Tacp<<2)+(B2_PMC))   ;GCS2
	DCD ((B3_Tacs<<13)+(B3_Tcos<<11)+(B3_Tacc<<8)+(B3_Tcoh<<6)+(B3_Tah<<4)+(B3_Tacp<<2)+(B3_PMC))   ;GCS3
	DCD ((B4_Tacs<<13)+(B4_Tcos<<11)+(B4_Tacc<<8)+(B4_Tcoh<<6)+(B4_Tah<<4)+(B4_Tacp<<2)+(B4_PMC))   ;GCS4
	DCD ((B5_Tacs<<13)+(B5_Tcos<<11)+(B5_Tacc<<8)+(B5_Tcoh<<6)+(B5_Tah<<4)+(B5_Tacp<<2)+(B5_PMC))   ;GCS5
	DCD ((B6_MT<<15)+(B6_Trcd<<2)+(B6_SCAN))    ;GCS6
	DCD ((B7_MT<<15)+(B7_Trcd<<2)+(B7_SCAN))    ;GCS7
	DCD ((REFEN<<23)+(TREFMD<<22)+(Trp<<20)+(Trc<<18)+(Tchr<<16)+REFCNT)

	DCD 0x32	    ;SCLK power saving mode, BANKSIZE 128M/128M

	DCD 0x30	    ;MRSR6 CL=3clk
	DCD 0x30	    ;MRSR7 CL=3clk
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ALIGN

	AREA RamData, DATA, READWRITE

	^   _ISR_STARTADDRESS	; _ISR_STARTADDRESS=0x33FF_FF00, MAP directive = ^ (sets memory origin)
HandleReset 	#   4		; FIELD directive = # (space allocate)
HandleUndef 	#   4
HandleSWI		#   4
HandlePabort    #   4
HandleDabort    #   4
HandleReserved  #   4
HandleIRQ		#   4
HandleFIQ		#   4

; Don't use the label 'IntVectorTable',
; The value of IntVectorTable is different with the address you think it may be.
; IntVectorTable

; **** Further work - Need to modify after spec fix by djkim 2006/07/05
HandleEINT0	    #	4
HandleEINT1	    #	4
HandleEINT2	    #	4
HandleEINT3	    #	4
HandleIIC0      #   4
HandleIIC0_AAS  #   4
HandleTIMER0_TOF #   4
HandleTIMER0_TMC #   4
HandleTIMER1_TOF #   4
HandleTIMER1_TMC #   4
HandleTIMER2_TOF #   4
HandleTIMER2_TMC #   4
HandleEINT4     #   4
HandleEINT5     #   4
HandleEINT6     #   4
HandleEINT7     #   4
HandleIIC1      #   4
HandleIIC1_AAS  #   4
HandleWDT       #   4
HandleADC       #   4
HandleUTX       #   4
HandleURX       #   4
HandleTIMER3_TOF #   4
HandleTIMER3_TMC #   4
HandleTIMER4_TOF #   4
HandleTIMER4_TMC #   4
HandleTIMER5_TOF #   4
HandleTIMER5_TMC #   4
HandleTIMER6_TOF #   4
HandleTIMER6_TMC #   4
HandleTIMER7_TOF #   4
HandleTIMER7_TMC #   4
	END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;