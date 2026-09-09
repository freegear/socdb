;/******************************************************************************
;*
;*		Code to startup the ARM C environment
;*		===========================================
;*
;*		Author:	MCD 
;*
;* 	Copyright (c) Altera Corporation 2000-2001.
;* 	All rights reserved.
;*
;******************************************************************************/

	IMPORT CIrqHandler
	IMPORT CFiqHandler
	IMPORT CPabtHandler
	IMPORT CDabtHandler
	IMPORT CSwiHandler
	IMPORT CUdefHandler

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
; We have mapped 256k of SRAM at address 0x100000 I'm using the top of 
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
	; So far all we're using SWI for is enabling and disabling interrupts
	; when in User mode
	subs r0, lr, #4
	ldr	r0,[r0]
	mov	r1, #0xffffff
	and r0,r0,r1
	cmp r0, #1
	beq	Enable_IRQ_SWI
	b	EndOfSwi
	
Enable_IRQ_SWI	
	; Enable interrupts for User Mode
	mrs	r1,spsr
	mvn	r0,#0xc0
	and	r1,r1,r0
	msr	spsr_c,r1
	b EndOfSwi
	
EndOfSwi
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
	;/* Turn on the instruction cache */ ; 
	MRC 	p15,0,r0,c1,c0,0
	LDR	r1,=0x80001078
	ORRS	r0,r0,r1
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
        ; ...

; --- Initialise critical IO devices
        ; ...

; --- Initialise interrupt system variables here
        ; ...

; --- Now change to User mode and set up User mode stack.
        MSR     CPSR_c, #Mode_USR:OR:I_Bit:OR:F_Bit ; No interrupts
        LDR     SP, =USR_Stack

        IMPORT  __main

; --- Now enter the C code
        B      __main   ; note use B not BL, because an application will never return this way

;******************************************************************************
;*
;*		Useful admin functions
;*		======================
;*
;*		Author:	PRR
;*
;******************************************************************************/

	EXPORT EnableIRQ

	AREA |C$$Code|,CODE,READONLY
	
;
;	The ARM C runtime code puts us into User mode, to enable interrupts
; 	we need to be in supervisor mode, so use a SWI to do this
;	
EnableIRQ
	swi 1	
	mov	pc, lr
	
	END

	AREA |Stacks|, DATA, NOINIT
	%	8192
SvcStackTop	
	%	1024
IrqStackTop	
	%	1024
FiqStackTop
	%	1024
AbtStackTop	
	%	1024
UndefStackTop	

	END