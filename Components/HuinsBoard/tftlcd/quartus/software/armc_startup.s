;/******************************************************************************
;*
;*		Code to startup the ARM C environment
;*		===========================================
;*
;* 	Copyright (c) Altera Corporation 2000-2002.
;* 	All rights reserved.
;*
;*
;* This file contains the code to initialise the C environment before branching 
;* to __main which is ARM's C library initialisation routine. For more information
;* on ARM's C libraries see chapter 4 of the ARM Developer Suite Tools manual.
;*
;* The c initialisation includes:
;* 1. Turn on the instruction cache
;* 2. Turn on the instruction cache and MMU, see below for details on the mapping
;* 3. Setup the stack for all modes
;* 4. Initialise the UART
;* 5. Switch to User mode with IRQ's enabled, FIQs disabled
;* 6. Branch to __main
;
;******************************************************************************/

	IMPORT CIrqHandler
	IMPORT CFiqHandler
	IMPORT CPabtHandler
	IMPORT CDabtHandler
	IMPORT CSwiHandler
	IMPORT CUdefHandler
    IMPORT uart_init

	GET ../stripe.s
	
	; --- Standard definitions of mode bits and interrupt (I & F) flags in PSRs

Mode_USR        EQU     0x10
Mode_FIQ        EQU     0x11
Mode_IRQ        EQU     0x12
Mode_SVC        EQU     0x13
Mode_ABT        EQU     0x17
Mode_UNDEF      EQU     0x1B
Mode_SYS        EQU     0x1F ; available on ARM Arch 4 and later

I_Bit           EQU     0x80 ; when I bit is set, IRQ is disabled
F_Bit           EQU     0x40 ; when F bit is set, FIQ is disabled


; --- System memory locations
; We have mapped 128K of SRAM at address 0x20000 I'm using the top of 
; this memory as a stack
RAM_Limit       EQU     EXC_SPSRAM_BLOCK1_BASE + EXC_SPSRAM_BLOCK1_SIZE 
SVC_Stack       EQU     RAM_Limit           ; 8K SVC stack at top of memory
IRQ_Stack       EQU     RAM_Limit-8192      ; followed by  1k IRQ stack
ABT_Stack       EQU     IRQ_Stack-1024      ; followed by  1k ABT stack 
FIQ_Stack		EQU		ABT_Stack-1024		; followed by  1k FIQ stack 
UNDEF_Stack		EQU		FIQ_Stack-1024		; followed by  1k UNDEF stack 
USR_Stack       EQU     UNDEF_Stack-1024    ; followed by  USR stack

		
;
;	If booting from flash the entry point Start is not arrived at immediately after reset
;	the quartus project file is doing a few things under your feet that you need to be 
; 	aware of.
;	
; 	The Excalibur Megawizard generated a file (.sbd) which contains the information about 
; 	the setup you requested for your memory map, IO settings, SDRAM settings etc.
;
;	This file, along with your hex file and PLD image is converted to an object file, and 
;	compressed in the process.
;
;	This object file is linked with Altera's boot code. Altera's boot code then configures
;	excalibur's registers to give the setup you requested via the MegaWizard, it 
;	uncompresses the PLD image and the hex file and loads them.
;
;	So at this point your memory map should be setup and contain the memory you initially 
;	requested.
;
;	For more information on this flow please see the document
;	Toolflow for ARM-Based Embedded Processor PLDs
;
	AREA init, CODE, READONLY
	b	Start
	b	UdefHnd
	b	SwiHnd
	b	PabtHnd
	b	DabtHnd
	b	Unexpected
	b	IrqHnd
	b	FiqHnd

Unexpected		
	b	Unexpected
	
UdefHnd	
	stmdb	sp!,{r0-r12,lr}
	bl	CUdefHandler
	ldmia	sp!,{r0-r12,lr}
	subs	pc,lr,#4

SwiHnd	
	stmdb	sp!,{r0-r12,lr}

    ; put the swi argument in r0 and call
    ; CSwiHandler   

    sub r0, lr, #4
    ldr r0, [r0]
    mvn r1, #0xff000000
    and r0, r0, r1
	bl CSwiHandler
	ldmia	sp!,{r0-r12,lr}
	movs		pc, lr

IrqHnd
	stmdb	sp!,{r0-r12,lr}
	bl	CIrqHandler
	ldmia	sp!,{r0-r12,lr}
	subs	pc,lr,#4

PabtHnd
	stmdb	sp!,{r0-r12,lr}
	bl	CPabtHandler
	ldmia	sp!,{r0-r12,lr}
	subs	pc,lr,#4

DabtHnd
	stmdb	sp!,{r0-r12,lr}
	bl	CDabtHandler
	ldmia	sp!,{r0-r12,lr}
	subs	pc,lr,#4

FiqHnd	
	stmdb	sp!,{r0-r7,lr}
	bl	CFiqHandler
	ldmia	sp!,{r0-r7,lr}
	subs	pc,lr,#4

Start

	;/* Turn on the instruction cache, Random replacement*/ ; 
	MRC 	p15,0,r0,c1,c0,0
	LDR	r1,=0x1078
	ORRS	r0,r0,r1
	MCR 	p15,0,r0,c1,c0,0

	LDR	r0,=0xFFFFFFF7	   ; set all domains to be manager, except domain 1
	MCR	p15,0,r0,c3,c0,0

	; Enable the MMU and DCache
	LDR	r0,=page_table
	MCR	p15,0,r0,c2,c0,0   ; set TTB address

	MRC 	p15,0,r0,c1,c0,0
	ORR 	r0,r0,#5         ; enable DCache and MMU
	MCR 	p15,0,r0,c1,c0,0

	
	; --- Initialise stack pointer registers
; Enter SVC mode and set up the SVC stack pointer
        MSR     CPSR_c, #Mode_SVC:OR:I_Bit:OR:F_Bit ; No interrupts
        LDR     SP, =SVC_Stack

; Enter IRQ mode and set up the IRQ stack pointer
        MSR     CPSR_c, #Mode_IRQ:OR:I_Bit:OR:F_Bit ; No interrupts
        LDR     SP, =IRQ_Stack

; Enter FIQ mode and set up the FIQ stack pointer
        MSR     CPSR_c, #Mode_FIQ:OR:I_Bit:OR:F_Bit ; No interrupts
        LDR     SP, =FIQ_Stack

; Enter UNDEF mode and set up the UNDEF stack pointer
        MSR     CPSR_c, #Mode_UNDEF:OR:I_Bit:OR:F_Bit ; No interrupts
        LDR     SP, =UNDEF_Stack

; Enter ABT mode and set up the ABT stack pointer
        MSR     CPSR_c, #Mode_ABT:OR:I_Bit:OR:F_Bit ; No interrupts
        LDR     SP, =ABT_Stack


; --- Initialise memory system

; --- Initialise critical IO devices
        ; ...

; --- Initialise interrupt system variables here
        ; ...

; --- Initialise critical IO devices
        
        BL uart_init

; --- Initialise interrupt system variables here

; --- Now change to User mode and set up User mode stack.
       	MSR     CPSR_c, #Mode_USR
        LDR     SP, =USR_Stack

        IMPORT  __main


; --- Now enter the C code
        B      __main   ; note use B not BL, because an application will never return this way

;--- Page table AREA
;
; General comment
;
; The page table below is configurred to use 1Mb sections to configure the MMU, it is set up as follows:

; 0 - 0x5fff ffff 
; This area has the cache turned on in write-back mode there is a one to one mapping
; between virtual and physical addresses

; 0x6000 0000 - 0x6fff ffff 
; This area has the cache off, it is set asside for PLD region 1

; 0x7000 0000 - 0x7fef ffff
; This area has the cache turned on in write-back mode there is a one to one mapping
; between virtual and physical addresses

; 0x7ff0 0000 - 0x7fff ffff
; This area has the cache turned off, as it contains the registers

; 0x8000 0000 - 0xbfff ffff
; This area has the cache off, it is set asside for PLD region 0

; 0xc000 0000 - 0xffff ffff
; This area has the cache turned on in write-back mode there is a one to one mapping
; between virtual and physical addresses
;
; In the page table below there are two setups used of the Form
;
; (Address << 20) | 0xc1e 
; (Address << 20) | 0xc12 
; 
; The address element is the base address of the 1MByte section, the other none zero bits are:
;
; 0xC00 This sets the access permissions so the the section can be accessed from User mode 
; and in priviledged modes
; 0x10 This bit must be written as 1
; 0xc These two bits control whether the cache is enabled and the write buffer is enabled
; 0x2 This bit marks the entry as a section descriptor
;

		AREA	L1_table, DATA, READONLY, ALIGN=14 ; ALign to 16kB
page_table
		GBLA	section
section 	SETA	0
		WHILE	section < 1536		
		DCD	(0x$section:SHL:20):OR:0xC1E ; Flat mapping WB, domain 0.
section		SETA	section + 1
		WEND
		
;
; 	256MByte region for PLD Region1 with the cache disabled
;	This needs doing for any area which contains memory mapped hardware 
;
		WHILE	section < 1792
		DCD	(0x$section:SHL:20):OR:0xC12 ; No cache no buffering
section		SETA	section + 1
		WEND

		WHILE	section < 2047		
		DCD	(0x$section:SHL:20):OR:0xC1E ; Flat mapping WB, domain 0.
section		SETA	section + 1
		WEND

;
;	Register region, turn off the cache and the buffers
;	This needs doing for any area which contains memory mapped hardware 
; 	It could have been included in the PLD region below, but is left separate 
;	for clarity
;
		DCD  0x7FF00C12	; 1 MByte Register region no cache no buffering
						; Strictly I should have a small page table and 
						; just turn of the cache for the 16k which contains the
						; registers, but this is much easier
		
section 	SETA	2048
;
; 	1GByte region for PLD Region0 with the cache disabled
;	This needs doing for any area which contains memory mapped hardware 
;
		WHILE	section < 3072
		DCD	(0x$section:SHL:20):OR:0xC12 ; No cache no buffering
section		SETA	section + 1
		WEND


		WHILE	section < 4096		
		DCD	(0x$section:SHL:20):OR:0xC1E ; Flat mapping WB, domain 0.
section		SETA	section + 1
		WEND
		
	END
	
