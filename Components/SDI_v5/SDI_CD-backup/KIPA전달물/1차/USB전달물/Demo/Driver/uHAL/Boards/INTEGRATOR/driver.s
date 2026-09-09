;/***************************************************************************
; * Copyright © ARM Limited 1998.  All rights reserved.
; ***************************************************************************/
;******************************************************************************
;
;	Integrator specific assembly source code.  
;  
;******************************************************************************/

	INCLUDE	bits.s
	INCLUDE	sizes.s
	INCLUDE	platform.s
	INCLUDE	mmu_h.s
	GET	target.s
	
 IF :LNOT: :DEF: ANGELVSN
	EXPORT	uHALir_InitTargetMem	; Initialise memory
	EXPORT	uHALir_FindRAMTop	; Find top of memory
	EXPORT	uHALir_PCIInit		; (Re)initialise PCI 

	IMPORT	uHALir_EnterLockedSvcMode ; Enter Supervisor mode & disable IRQ.
	IMPORT	uHALir_EnterSvcMode	; Enter Supervisor mode.
	IMPORT	uHALir_ExitSvcMode	; Exit Supervisor mode.
	IMPORT	uHALiv_TopOfMemory	; Top of RAM.
 ENDIF
 IF USE_C_LIBRARY = 1
	EXPORT	uHALir_InitTMem
 ENDIF

	EXPORT	Level1tab
	EXPORT	Level2tab_ROM
	EXPORT	MPUMaptab

	KEEP


	AREA    |C$$code$$__Integrator|, CODE, READONLY

 IF :LNOT: :DEF: ANGELVSN
; -------------------------------------------------------------------
; Routine to initialise the target-specific RAM:
;
; See INIT_RAM macro for description

; NOTE:	r14 contains return address
;	r0 returns top of memory

uHALir_InitTargetMem
	;; Initialise the DRAM (if present)

	INIT_RAM	r0, r1, r5

 IF :DEF: THUMB_AWARE   ; if interworking is required
	BX    lr
 ELSE                    ; some processors are not Thumb aware
	MOV	pc, lr			 ; All done, return
 ENDIF


uHALir_FindRAMTop
	LDR	r0, =uHALiv_TopOfMemory
	LDR	r0, [r0]
	
 IF :DEF: THUMB_AWARE   ; if interworking is required
	BX    lr
 ELSE                    ; some processors are not Thumb aware
	MOV	pc, lr			 ; All done, return
 ENDIF

 IF USE_C_LIBRARY = 1
uHALir_InitTMem
	; initialise ram
	INIT_RAM	r0, r1, r2
	LDR	r1, =uHALiv_TopOfMemory
	SUB	r0, r0, #1
	STR	r0, [r1]
	
 	IF :DEF: THUMB_AWARE   ; if interworking is required
		BX    lr
 	ELSE                    ; some processors are not Thumb aware
		MOV	pc, lr			 ; All done, return
 	ENDIF
 ENDIF
; -------------------------------------------------------------------
; Routine to initialise PCI
;
; void uHALir_InitPCI(void)	- Init PCI
uHALir_PCIInit
	STMFD	sp!,{r0-r1, r4-r9, r14}	; Save registers

	MOV	r9, r0			; Save the mode
	
	; Switch into SVC returns SPSR in r0
	BL	uHALir_EnterLockedSvcMode

	; Use the macro
	SETUP_PCI	r4, r5, r6, r7
	
	; Switch back to the mode we started in (restores interrupts, if any)
	BL	uHALir_ExitSvcMode	; Switch out of SVC mode, r0 -> spsr
	
 	IF :DEF: THUMB_AWARE   ; if interworking is required
		LDMFD	sp!,{r0-r1, r4-r9, lr}	; restore registers and return
		BX    lr
 	ELSE                    ; some processors are not Thumb aware
		LDMFD	sp!,{r0-r1, r4-r9, pc}	; restore registers and return	
 	ENDIF


	LTORG

 ENDIF

	AREA uHAL_TTentries, DATA, NOINIT, ALIGN=14

;------------------------------------------------------------------
; MMU lookup tables. Because the SETUPMMU macro is shared with
; semihosted, it uses simple names, these are aliased to uHAL
; standard for internal use.
;
; NOTE: These areas are declared even for processors without MMUs


; 4-byte entries,1MB sections
uHALiv_Level1tab
Level1tab 	% (L1_TABLE_ENTRIES * 4)

; 4-byte entries, 64kB pages; x16 alias
uHALiv_Level2tab_ROM
Level2tab_ROM	% (L2_TABLE_ENTRIES * L2_ENTRY_SIZE * 4)

; 4-byte entries, 8 regions + 3 flags
uHALiv_MPUMaptab
MPUMaptab	% (MPU_TABLE_ENTRIES * 4)

	END

