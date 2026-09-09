;-------------------------------------------------------------------------------
; BOOT up code boot.s
;-------------------------------------------------------------------------------
	EXPORT	Jump
;-------------------------------------------------------------------------------
; ARM PSR bits
;-------------------------------------------------------------------------------
ARM_M_MASK		EQU 0x1F
ARM_M_ABT		EQU	0x17
ARM_M_FIQ		EQU	0x11
ARM_M_IRQ		EQU	0x12
ARM_M_SVC		EQU	0x13
ARM_M_SYS		EQU	0x3F
ARM_M_UND		EQU	0x1B
ARM_M_USR		EQU	0x10
ARM_I_IRQ		EQU	0x80
ARM_I_FIQ		EQU	0x40
ARM_S_THB		EQU	0x20

USERMODE    EQU 	0x10
FIQMODE     EQU 	0x11
IRQMODE     EQU 	0x12
SVCMODE     EQU 	0x13
ABORTMODE   EQU 	0x17
UNDEFMODE   EQU 	0x1b
MODEMASK    EQU 	0x1f
NOINT       EQU 	0xc0

GBLL	CT500_EVB

;-------------------------------------------------------------------------------
; Debug GPIO
;-------------------------------------------------------------------------------
DGPIO_BASE		EQU 0x50002000
DGPIO_EN		EQU	DGPIO_BASE+0x02
DGPIO_IN		EQU DGPIO_BASE+0x04
DGPIO_OUT		EQU DGPIO_BASE+0x08
;-------------------------------------------------------------------------------
; NAND controller
;-------------------------------------------------------------------------------
NAND_BASEADDR	EQU 0x40008000
NANDNFOPER		EQU	NAND_BASEADDR+0x00
NANDDATA        EQU	NAND_BASEADDR+0x04
NANDCONF		EQU	NAND_BASEADDR+0x08
NANDCTRL        EQU	NAND_BASEADDR+0x0C
NANDSTAT        EQU	NAND_BASEADDR+0x10
NANDFIFOSTAT    EQU	NAND_BASEADDR+0x14
;-------------------------------------------------------------------------------
; DMA channel 0 contorller
;-------------------------------------------------------------------------------
DMAC_BASEADDR	EQU 0x4000C000	
DMACSADR0		EQU DMAC_BASEADDR+0x00
DMACDADR0		EQU DMAC_BASEADDR+0x04
DMACCON0		EQU DMAC_BASEADDR+0x08
DMACDESCRP0		EQU DMAC_BASEADDR+0x0C
DMACSTA0		EQU DMAC_BASEADDR+0x10

;-------------------------------------------------------------------------------
; boot configure infomatio
;-------------------------------------------------------------------------------

R1_I    EQU     (1<<12)
R1_C    EQU     (1<<2)
R1_A    EQU     (1<<1)
R1_M    EQU     (1<<0)

	AREA Bootup,CODE,READONLY
;-------------------------------------------------------------------------------
;	the actual bootup code 
;-------------------------------------------------------------------------------
bootup
	IF DEF:CT500_EVB
	; Power Management Uint Setting
	ldr r0, =0x50003000		; Clock Control
	ldr r1, =0x50003004		; Clock Divide
	ldr r2, =0x50003008		; PLL Lock Count
	ldr r3, =0x5000300C		; PLL MPS Value
	ldr r4, =0x50003010		; SWReset

	;ldr r5, =0x00ff0f00
	;str r5, [r0]

	;ldr r5, =0x00000011		; cpuclk = x1, sysclk = 1/2 mclk
	;str r5, [r1]

	ldr r5, =0x80000380
	str r5, [r2]

	ldr r5, =0x0000252A
	str r5, [r3]
	
	;ldr r5, =0x000FFFFC
	ldr r5, =0x000FDDFC
	str r5, [r4]
	ENDIF

	ldr r0, =0x40004000		; DDRTCON
	ldr r1, =0x40004004		; DDRCON
	ldr r2, =0x40004008		; DDRPCON
	ldr r3, =0x4000400c		; DDRREF
	ldr r4, =0x40004010		; DDRDLL

	;--------------------------------------------------------------------------
	;	DDTCON
	;--------------------------------------------------------------------------
	ldr r5, =0x00037535 	;0x00017535
	str r5, [r0]			; store DDTCON

	;--------------------------------------------------------------------------
	;	DDRDLL
	;--------------------------------------------------------------------------
	ldr r5, =0x00000024		; 0x00000025	
	str r5, [r4]			; store DDRDLL

	;--------------------------------------------------------------------------
	;	DDRREF
	;--------------------------------------------------------------------------
	;ldr r5, =0x00031040		; 0x00000410	
	ldr r5, =0x00000410
	str r5, [r3]			; store DDRREF

	;--------------------------------------------------------------------------
	;	DDRCON
	;--------------------------------------------------------------------------
	ldr r5, =0x000000A1		; 
	str r5, [r1]			; store DDRCON

	;--------------------------------------------------------------------------
	;	wait 200 cycle (DDR controller clock)
	;--------------------------------------------------------------------------
	ldr r5, =0x01f00000
1	ldr r6, [r3]
	and r6, r6, r5
	cmp r6, #0
	bne %B1
	
	
	;---------------------------------------------------------------------------
	;
	; Cache & MMU clean up
	;
	;---------------------------------------------------------------------------
	
	; disable I cache
	
	mrc  p15,0,r0,c1,c0,0
  	bic  r0,r0,#R1_I
   	mcr  p15,0,r0,c1,c0,0
   	
   	; disable D cache
   	
   	mrc  p15,0,r0,c1,c0,0
   	bic  r0,r0,#R1_C
   	mcr  p15,0,r0,c1,c0,0
   		
   	; invalidat I & D cache
   
   	mov  r0,#0x0 
   	mcr  p15,0,r0,c7,c7,0
   	 	
   	; disable MMU
  
   	mrc  p15,0,r0,c1,c0,0
   	bic  r0,r0,#R1_M
   	mcr  p15,0,r0,c1,c0,0
   	
   	; invalide date TLB
   	
 	mov  r0,#0x0     
   	mcr  p15,0,r0,c8,c7,0
   	
   	; pipe line safe
   	b %f1
1   	
   	
	bic	r0,r0,#MODEMASK|NOINT
	orr	r1,r0,#SVCMODE
	msr	cpsr_cxsf,r1		; SVCMode
	ldr	sp,=0x62000000


	;--------------------------------------------------------
	; disable interrupt IRQ/FIQ
	;--------------------------------------------------------
	mrs r0 ,cpsr 
	orr r0,r0,#ARM_I_IRQ
	msr cpsr_cxsf,r0
	 
	mrs r0 ,cpsr 
	orr r0,r0,#ARM_I_FIQ
	msr cpsr_cxsf,r0

	
	IMPORT CopyDataToMemory
	bl CopyDataToMemory
	 

Jump
	mov pc, r0	 
	 
	END
	
