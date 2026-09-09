; *******************************************************
; * NAME    : 44BINIT.S									*
; * Version : 10.April.2000								*
; * Description:										*
; *	C start up codes									*
; *	Configure memory, Initialize ISR ,stacks			*
; *	Initialize C-variables								*
; *	Fill zeros into zero-initialized C-variables		*
; *******************************************************
 
    GET option.s
    GET memcfg.s

;***********************************
;Memory Area
;***********************************
; Internal SRAM 24KB (0x01ff0000 ~ 0x01ff5fff)
; APP RAM = 0x01ff0000~0x01ff1fff   (8KB)
; ZI RAM  = 0x01ff2000 ~ 0x01ff5fff (256-8)KB
; STACK   = 0x01ff5dff ~ 0x01ff5fff (512B)

;***********************************
;Interrupt Control
;***********************************
INTPND	    EQU	0x01ff8b04
INTMOD	    EQU	0x01ff8b08
INTMSK	    EQU	0x01ff8b0c
I_ISPR	    EQU	0x01ff8b3c
I_CMST	    EQU	0x01ff8b38

I_VECADDR EQU   0x01ff8B78

;Watchdog timer
WDTCR       EQU	0x01ff8900

;Clock Controller       Further Work - Not yet 2006/02/24
;PLLCON	    EQU	0x01d80000
;CLKCON	    EQU	0x01d80004
;LOCKTIME   EQU	0x01d8000c

;Memory Controller      Further Work - Not yet 2006/02/24
;REFRESH	    EQU 0x01c80024

;Pre-defined constants
USERMODE    EQU	0x10
FIQMODE     EQU	0x11
IRQMODE     EQU	0x12
SVCMODE     EQU	0x13
ABORTMODE   EQU	0x17
UNDEFMODE   EQU	0x1b
MODEMASK    EQU	0x1f
NOINT       EQU	0xc0

;I/O Ports
PCONA		EQU	0x01ff8a10
PCONB		EQU	0x01ff8a14
PCONC		EQU	0x01ff8a18
PCOND		EQU	0x01ff8a1c

PDATA		EQU	0x01ff8a00
PDATB		EQU	0x01ff8a04
PDATC		EQU	0x01ff8a08
PDATD		EQU	0x01ff8a0c



;***********************************
;check if tasm.exe is used.
    GBLL    THUMBCODE
    [ {CONFIG} = 16	
THUMBCODE SETL	{TRUE}
    CODE32
    |   
THUMBCODE SETL	{FALSE}
    ]

    [ THUMBCODE
    CODE32   ;for start-up code for Thumb mode
    ]


;***********************************
; Interrupt Handler MACRO Define
;***********************************
    MACRO
$HandlerLabel HANDLER $HandleLabel

$HandlerLabel
    sub	    sp,sp,#4	    ;decrement sp(to store jump address)
    stmfd   sp!,{r0}	    ;PUSH the work register to stack(lr does't push because it return to original address)
    ldr	    r0,=$HandleLabel;load the address of HandleXXX to r0
    ldr	    r0,[r0]	    ;load the contents(service routine start address) of HandleXXX
    str	    r0,[sp,#4]	    ;store the contents(ISR) of HandleXXX to stack
    ldmfd   sp!,{r0,pc}	    ;POP the work register and pc(jump to ISR)
    MEND

    IMPORT	|Image$$RO$$Limit|  ; End of ROM code (=start of ROM data)
    IMPORT	|Image$$RW$$Base|   ; Base of RAM to initialise
    IMPORT	|Image$$ZI$$Base|   ; Base and limit of area
    IMPORT	|Image$$ZI$$Limit|  ; to zero initialise

    IMPORT  Main    ; The main entry of mon program 

    
    
    
    
    
;***********************************
; Code section
;***********************************
;    AREA    |C$$code|,CODE,READONLY
    AREA    Init,CODE,READONLY

    ENTRY 
    b ResetHandler  ;for debug
    b HandlerUndef  ;handlerUndef
    b HandlerSWI    ;SWI interrupt handler
    b HandlerPabort ;handlerPAbort
    b HandlerDabort ;handlerDAbort
    b .		    ;handlerReserved
    b HandlerIRQ    ; Use the H/W vectored interrupt controller
    b HandlerFIQ

	;***IMPORTANT NOTE***
	;If the H/W vectored interrutp mode is enabled, The above two instructions should
	;be changed like below, to work-around with H/W bug of S3C44B0X interrupt controller. 
	; b HandlerIRQ  ->  subs pc,lr,#4
	; b HandlerIRQ  ->  subs pc,lr,#4

VECTOR_BRANCH
    ldr pc,=HandlerEINT0        ; H/W interrupt vector table
    ldr pc,=HandlerEINT1        ;	
    ldr pc,=HandlerEINT2        ;
    ldr pc,=HandlerEINT3        ;
    
    ldr pc,=HandlerIIC0         ;
    ldr pc,=HandlerIIC0_AAS ;

    ldr pc,=HandlerTIMER0_TOF   ;
    ldr pc,=HandlerTIMER0_TMC   ;
    ldr pc,=HandlerTIMER1_TOF   ;
    ldr pc,=HandlerTIMER1_TMC   ;
    ldr pc,=HandlerTIMER2_TOF   ;
    ldr pc,=HandlerTIMER2_TMC   ;

    ldr pc,=HandlerEINT4        ;	    
    ldr pc,=HandlerEINT5	        ;
    ldr pc,=HandlerEINT6	        ;
    ldr pc,=HandlerEINT7	        ;
    
    ldr pc,=HandlerIIC1         ;
    ldr pc,=HandlerIIC1_AAS ;
    
    ldr pc,=HandlerWDT          ;
    ldr pc,=HandlerADC          ;
    
    ldr pc,=HandlerURX          ;
    ldr pc,=HandlerUTX          ;

    ldr pc,=HandlerTIMER3_TOF           ;
    ldr pc,=HandlerTIMER3_TMC           ;
    ldr pc,=HandlerTIMER4_TOF           ;
    ldr pc,=HandlerTIMER4_TMC           ;

    ldr pc,=HandlerTIMER5_TOF           ;
    ldr pc,=HandlerTIMER5_TMC           ;
    ldr pc,=HandlerTIMER6_TOF           ;
    ldr pc,=HandlerTIMER6_TMC           ;
		
    ldr pc,=HandlerTIMER7_TOF           ;
    ldr pc,=HandlerTIMER7_TMC           ;

    b .
;0xe0=EnterPWDN
    ldr pc,=EnterPWDN

    LTORG	

HandlerUndef	HANDLER HandleUndef
HandlerSWI	HANDLER HandleSWI
HandlerPabort   HANDLER HandlePabort
HandlerDabort   HANDLER HandleDabort
HandlerIRQ	HANDLER HandleIRQ
HandlerFIQ	HANDLER HandleFIQ

HandlerEINT0	HANDLER HandleEINT0
HandlerEINT1	HANDLER HandleEINT1
HandlerEINT2	HANDLER HandleEINT2
HandlerEINT3	HANDLER HandleEINT3

HandlerIIC0	    HANDLER HandleIIC0
HandlerIIC0_AAS HANDLER HandleIIC0_AAS

HandlerTIMER0_TOF	HANDLER HandleTIMER0_TOF
HandlerTIMER0_TMC	HANDLER HandleTIMER0_TMC
HandlerTIMER1_TOF	HANDLER HandleTIMER1_TOF
HandlerTIMER1_TMC	HANDLER HandleTIMER1_TMC
HandlerTIMER2_TOF	HANDLER HandleTIMER2_TOF
HandlerTIMER2_TMC	HANDLER HandleTIMER2_TMC

HandlerEINT4	HANDLER HandleEINT4
HandlerEINT5	HANDLER HandleEINT5
HandlerEINT6	HANDLER HandleEINT6
HandlerEINT7	HANDLER HandleEINT7

HandlerIIC1     HANDLER HandleIIC1
HandlerIIC1_AAS HANDLER HandleIIC1_AAS

HandlerWDT	HANDLER HandleWDT
HandlerADC	HANDLER HandleADC

HandlerUTX      HANDLER HandleUTX
HandlerURX      HANDLER HandleURX

HandlerTIMER3_TOF	HANDLER HandleTIMER3_TOF
HandlerTIMER3_TMC	HANDLER HandleTIMER3_TMC
HandlerTIMER4_TOF	HANDLER HandleTIMER4_TOF
HandlerTIMER4_TMC	HANDLER HandleTIMER4_TMC
HandlerTIMER5_TOF	HANDLER HandleTIMER5_TOF
HandlerTIMER5_TMC	HANDLER HandleTIMER5_TMC
HandlerTIMER6_TOF	HANDLER HandleTIMER6_TOF
HandlerTIMER6_TMC	HANDLER HandleTIMER6_TMC
HandlerTIMER7_TOF	HANDLER HandleTIMER7_TOF
HandlerTIMER7_TMC	HANDLER HandleTIMER7_TMC



;***********************************
; IRQ/FIQ interrupt service routine (H/W vectored method)
;***********************************
IsrIRQHW    ; usingI_VECADDR/F_VECADDR
    sub	    sp,sp,#4       ;reserved for PC
    stmfd   sp!,{r8-r9}   

	;IMPORTANT CAUTION
	;if I_ISPC isn't used properly, I_ISPR can be 0 in this routine.

    ldr	    r9,=I_ISPR
    ldr	    r9,[r9]

	cmp		r9, #0x0	;If the IDLE mode work-around is used,
						;r9 may be 0 sometimes.
	beq		%F2

0
    ldr         r8,=I_VECADDR
    ldr         r8, [r8]
1
    ldr	    r9,=HandleEINT0
    add	    r9,r9,r8
    ldr	    r9,[r9]
    str	    r9,[sp,#8]
    ldmfd   sp!,{r8-r9,pc}

2
	ldmfd	sp!,{r8-r9}
	add		sp,sp,#4
	subs	pc,lr,#4


;***********************************
; IRQ/FIQ interrupt service routine (S/W vectored method)
;***********************************
;One of the following two routines can be used for non-vectored interrupt.

IsrIRQ	;using I_ISPR register.
    sub	    sp,sp,#4       ;reserved for PC
    stmfd   sp!,{r8-r9}   

	;IMPORTANT CAUTION
	;if I_ISPC isn't used properly, I_ISPR can be 0 in this routine.

    ldr	    r9,=I_ISPR
    ldr	    r9,[r9]

	cmp		r9, #0x0	;If the IDLE mode work-around is used,
						;r9 may be 0 sometimes.
	beq		%F2

    mov	    r8,#0x0
0
    movs    r9,r9,lsr #1
    bcs	    %F1
    add	    r8,r8,#4
    b	    %B0

1
    ldr	    r9,=HandleEINT0
    add	    r9,r9,r8
    ldr	    r9,[r9]
    str	    r9,[sp,#8]
    ldmfd   sp!,{r8-r9,pc}

2
	ldmfd	sp!,{r8-r9}
	add		sp,sp,#4
	subs	pc,lr,#4

;****************************************************
;*	START											*
;****************************************************
ResetHandler
    ;LDR    r1, =PDATA			; Reset WDT, Lcd Off
    ;LDR    r0, =0x0200
    ;STR    r0, [r1]
    ;LDR    r0, =0x0000
    ;STR    r0, [r1]	

    ldr	    r0,=WDTCR	    ;watch dog disable 
    ldr	    r1,=0x0 		
    str	    r1,[r0]

    ldr	    r0,=INTMSK
    ldr	    r1,=0xffffffff  ;all interrupt disable
    str	    r1,[r0]

;****************************************************
;*	Set clock control registers						*
;****************************************************
; Edit your code.
;;;;;;;;;;;;;;;;;;;


    

;****************************************************
;*	Set memory control registers					*
;****************************************************
    ldr	    r0,=SMRDATA
    ldmia   r0,{r1-r4}
    ldr	    r0,=0x01ff8100  ; Bank0 controll register
    stmia   r0,{r1-r4}

;****************************************************
;*	Initialize stacks								* 
;****************************************************
    ldr	    sp, =SVCStack	;
    bl	    InitStacks

;****************************************************
;*	Setup IRQ handler								*
;****************************************************
    ldr	    r0,=HandleIRQ		;This routine is needed
    ;ldr	    r1,=IsrIRQ			;if there isn't 'subs pc,lr,#4' at 0x18, 0x1c
    ldr          r1,=IsrIRQHW           ; H/W vectored interrupt
    str	    r1,[r0]

;********************************************************
;*	Copy and paste RW data/zero initialized data	    *
;********************************************************
    LDR	    r0, =|Image$$RO$$Limit|	; Get pointer to ROM data
    LDR	    r1, =|Image$$RW$$Base|	; and RAM copy
    LDR	    r3, =|Image$$ZI$$Base|	
	;Zero init base => top of initialised data
			
    CMP	    r0, r1	    ; Check that they are different
    BEQ	    %F1
0		
    CMP	    r1, r3	    ; Copy init data
    LDRCC   r2, [r0], #4    ;--> LDRCC r2, [r0] + ADD r0, r0, #4		 
    STRCC   r2, [r1], #4    ;--> STRCC r2, [r1] + ADD r1, r1, #4
    BCC	    %B0
1		
    LDR	    r1, =|Image$$ZI$$Limit| ; Top of zero init segment
    MOV	    r2, #0
2		
    CMP	    r3, r1	    ; Zero init
    STRCC   r2, [r3], #4
    BCC	    %B2
    

;********************************************************
;*	Interrupt Enable	    *
;********************************************************
    mrs	    r0,cpsr
    bic	    r0,r0,#MODEMASK
    orr	    r1,r0,#USERMODE
    msr	    cpsr_cxsf,r1		;UserMode & Enable interrupt
    ldr          sp,=UserStack          ; UserStack initialize
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    [ :LNOT:THUMBCODE
	BL	Main	    ;Don't use main() because ......
	B	.						
    ]

    [ THUMBCODE		    ;for start-up code for Thumb mode
	orr     lr,pc,#1
	bx      lr
	CODE16
	bl      Main	    ;Don't use main() because ......
	b       .
	CODE32
    ]

;****************************************************
;*	The function for initializing stack				*
;****************************************************
InitStacks
	;Don't use DRAM,such as stmfd,ldmfd......
	;SVCstack is initialized before
	;Under toolkit ver 2.50, 'msr cpsr,r1' can be used instead of 'msr cpsr_cxsf,r1'

    mrs	    r0,cpsr
    bic	    r0,r0,#MODEMASK
    orr	    r1,r0,#UNDEFMODE|NOINT
    msr	    cpsr_cxsf,r1		;UndefMode
    ldr	    sp,=UndefStack
	
    orr	    r1,r0,#ABORTMODE|NOINT
    msr	    cpsr_cxsf,r1 	    	;AbortMode
    ldr	    sp,=AbortStack

    orr	    r1,r0,#IRQMODE|NOINT
    msr	    cpsr_cxsf,r1 	    	;IRQMode
    ldr	    sp,=IRQStack
	
    orr	    r1,r0,#FIQMODE|NOINT
    msr	    cpsr_cxsf,r1 	    	;FIQMode
    ldr	    sp,=FIQStack

    bic	    r0,r0,#MODEMASK|NOINT
    orr	    r1,r0,#SVCMODE
    msr	    cpsr_cxsf,r1 	    	;SVCMode
    ldr	    sp,=SVCStack

	;USER mode is not initialized.
    mov	    pc,lr ;The LR register may be not valid for the mode changes.

;****************************************************
;*	The function for entering power down mode		*       Further Work - Need to programming
;****************************************************
;void EnterPWDN(int CLKCON);
; Edit your code.
;;;;;;;;;;;;;;;;;;;
EnterPWDN
    ; Temporary code
    nop
    nop
    nop
    nop




    LTORG

SMRDATA DATA
;*****************************************************************
;* Memory configuration has to be optimized for best performance *      Further Work - Need to programming
;* The following parameter is not optimized.                     *
;*****************************************************************

;*** memory access cycle parameter strategy ***
; 1) Even FP-DRAM, EDO setting has more late fetch point by half-clock
; 2) The memory settings,here, are made the safe parameters even at 66Mhz.
; 3) FP-DRAM Parameters:tRCD=3 for tRAC, tcas=2 for pad delay, tcp=2 for bus load.
; 4) DRAM refresh rate is for 40Mhz. 

	DCD ((B0_Tacsr<<26)+(B0_Tcosr<<24)+(B0_Taccr<<20)+(B0_Tcohr<<18)+(B0_Tcohw<<10)+(B0_Tcohw<<8)+(B0_Tcohw<<4)+(B0_Tcohw<<2)+(B0_Shift<<1)+(B0_Width))   ; Bank0
	DCD ((B1_Tacsr<<26)+(B1_Tcosr<<24)+(B1_Taccr<<20)+(B1_Tcohr<<18)+(B1_Tcohw<<10)+(B1_Tcohw<<8)+(B1_Tcohw<<4)+(B1_Tcohw<<2)+(B1_Shift<<1)+(B1_Width))   ; Bank1
	DCD ((B2_Tacsr<<26)+(B2_Tcosr<<24)+(B2_Taccr<<20)+(B2_Tcohr<<18)+(B2_Tcohw<<10)+(B2_Tcohw<<8)+(B2_Tcohw<<4)+(B2_Tcohw<<2)+(B2_Shift<<1)+(B2_Width))   ; Bank2
	DCD ((B3_Tacsr<<26)+(B3_Tcosr<<24)+(B3_Taccr<<20)+(B3_Tcohr<<18)+(B3_Tcohw<<10)+(B3_Tcohw<<8)+(B3_Tcohw<<4)+(B3_Tcohw<<2)+(B3_Shift<<1)+(B3_Width))   ; Bank3



	ALIGN


	AREA RamData, DATA, READWRITE

	^	(_ISR_STARTADDRESS-0x600)
;   Internal SRAM - 0x01ff0000~0x01ff5fff / ISR_STARTADDRESS - 0x01ff5f60
UserStack	    #	256	; 0x01ff5960
SVCStack	    #	256	; 0x01ff5a60
UndefStack	    #	256	; 0x01ff5b60
AbortStack	    #	256	; 0x01ff5c60
IRQStack        #	256	; 0x01ff5d60
FIQStack        #	256	; 0x01ff5e60


		^	_ISR_STARTADDRESS
HandleReset	    #	4
HandleUndef	    #	4
HandleSWI	    #	4
HandlePabort    #	4
HandleDabort    #	4
HandleReserved	#	4
HandleIRQ	    #	4
HandleFIQ	    #	4

;Don't use the label 'IntVectorTable',
;because armasm.exe cann't recognize this label correctly.
;the value is different with an address you think it may be.
;IntVectorTable
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
