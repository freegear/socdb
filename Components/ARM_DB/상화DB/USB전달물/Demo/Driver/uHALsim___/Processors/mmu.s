;/***************************************************************************
; * Copyright © ARM Limited 1998.  All rights reserved.
; ***************************************************************************/
;******************************************************************************
;  Memory Management and Cache Initialisation Routines for the ARM920T. All 
;  access to the Co-processor must be in supervisor mode and these routines 
;  handle all these issues internally.
;******************************************************************************/

	INCLUDE	bits.s
	INCLUDE	sizes.s
	INCLUDE	platform.s
	INCLUDE	mmumacro.s
	INCLUDE target.s

	IMPORT	Level1tab
	IMPORT	Level2tab_ROM
	IMPORT	MPUMaptab

	EXPORT	uHALr_InitMMU		; Setup page tables, MMU etc.
	EXPORT	uHALr_ResetMMU		; Reset Memory to initial state, no MMU

	EXPORT	uHALir_MMUSupported
	EXPORT	uHALir_MPUSupported
	EXPORT	uHALir_CacheSupported
	EXPORT	uHALir_CheckUnifiedCache

	EXPORT	uHALir_WriteCacheMode
	EXPORT	uHALir_ReadCacheMode
	EXPORT	uHALir_DisableICache
	EXPORT	uHALir_DisableDCache
	EXPORT	uHALir_DisableWriteBuffer
	EXPORT	uHALir_CleanDCache
	EXPORT	uHALir_CleanDCacheEntry
	
	; Enter Supervisor mode & disable IRQ.
	IMPORT	uHALir_EnterLockedSvcMode
	IMPORT	uHALir_ExitSvcMode	; Exit Supervisor mode.

	IMPORT	uHAL_AddressTable
	IMPORT	uHAL_MappingTable
	IMPORT	uHALiv_TopOfMemory	; Top of RAM.

        IMPORT	|Image$$RO$$Base|	; linked location of code

	KEEP

	AREA	uHAL_MMU, CODE, READONLY

;-------------------------------------------------------------------
; Routine to initialise the page tables & MMU to memmap layout.
;
; See SETUPMMU macro for description
; WARNING:	The MMU must be disabled when this routine is called,
;		but routine checks MMU, will do nothing if enabled.
;
; void uHALir_InitMMU(void)	- Init MMU to flat-memory map

uHALr_InitMMU
	STMFD	sp!,{r0-r2, r4-r9, lr}	; Save registers

	MOV	r9, r0			; Save the mode
	
	; If the MMU is already on, do nothing..
	TEST_MMU	r0
	BEQ	%F27

	; Switch into SVC returns SPSR in r0
	BL	uHALir_EnterLockedSvcMode

	LDR	r5, =uHALiv_TopOfMemory	; Macro needs top of memory
	LDR	r5, [r5]		; Read memory size

	SETUPMMU	r4, r5, r6, r7, r8, r1, r2

	;
	; Enable MMU, and any caching required.
	;	
	; This code must maintain the state of all other bits in the
	; control register that apart from cache, write buffer & MMU
	; enable bits
	;
	MOV	r1, #(EnableMMU :OR: EnableDcache :OR: EnableWB)
	ORR	r1, r1, #EnableIcache	; Create mask of the bits we can touch
	AND	r9, r9, r1		; Clear all other bits from the mask supplied

	RDMMU_STATE	r2		; Read current state of control register

	BIC	r2, r2, r1		; Clear the bits that we may change
	ORR	r9, r9, r2		; Merge in the supplied mask

	WRMMU_STATE	r9		; Write this to the control register

	; Make sure the pipeline is clear of any cached entries
	NOP
	NOP
	NOP

	; Switch back to the mode we started in (restores interrupts, if any)

	BL	uHALir_ExitSvcMode	; Switch out of SVC mode, r0 -> spsr
27

 IF :DEF: THUMB_AWARE      		; if interworking is required
	LDMFD	sp!,{r0-r2, r4-r9, lr}	; restore registers and return
   	BX    	lr                	; just return 
 ELSE                      		; some processors are not Thumb aware
	LDMFD	sp!,{r0-r2, r4-r9, pc}	; restore registers and return
 ENDIF


;-------------------------------------------------------------------
; void uHALr_ResetMMU(void)	- Function to reset the MMU.
;
; Flushes the Icache, cleans & flushes the Dcache, disables IC, DC, WB and
; MMU returning the memory system to its powerup state (flat map allows this)
;
; Never call ResetMMU without having called InitMMU first.
;
; When running semihosted, care should be exercised to leave the debugger
; in a state similar to that when starting our application.

uHALr_ResetMMU
	STMFD	sp!, {r0, r4-r6, lr}	; Save registers

	; Has this CPU an MPU?
	CHECK_FOR_MPU	r0
	BNE	%F40

	; Make sure this CPU has an MMU
	CHECK_FOR_MMU	r0
	BEQ	%F41

	; If the current memory map isn't 1-1 at 0, do NOT reset MMU
	MOV	r0, #0
	TEST_121MAP	r0, r4, r5
	BNE	%F41
40
	; Switch into SVC returns SPSR in r0
	BL	uHALir_EnterLockedSvcMode

	; Do we need to clean the Dcache?

	TEST_MMU	r4
	BLEQ	uHALir_CleanDCache

	WRMMU_FlushTB		r4	; Flush ITB's and DTB's
	WRCACHE_FlushIDC	r4	; Flush the ICache and DCache

	; Reset MMU control register

	RDMMU_STATE	r4
	CLEAR_IDC	r4
	CLEAR_MMU	r4
	WRMMU_STATE	r4

	; Make sure the pipeline is clear of any cached entries
	NOP
	NOP
	NOP

	; Switch back to the mode we started in (restores interrupts, if any)
	BL	uHALir_ExitSvcMode	; Switch out of SVC mode, r0 -> spsr

41
 IF :DEF: THUMB_AWARE      		; if interworking is required
	LDMFD	sp!,{r0, r4-r6, lr}	; restore registers and return
   	BX    	lr                	; just return 
 ELSE                      		; some processors are not Thumb aware
	LDMFD	sp!,{r0, r4-r6, pc}	; restore registers and return
 ENDIF


;-------------------------------------------------------------------
; Shell routines around MMU/cache query macros

uHALir_MMUSupported
	CHECK_FOR_MMU	r0
 IF :DEF: THUMB_AWARE   	; if interworking is required
   	BX    	lr             	; just return 
 ELSE                   	; some processors are not Thumb aware
   	MOV   	pc, lr	      	; return 
 ENDIF

uHALir_MPUSupported
	CHECK_FOR_MPU	r0
 IF :DEF: THUMB_AWARE   	; if interworking is required
   	BX    	lr             	; just return 
 ELSE                   	; some processors are not Thumb aware
   	MOV   	pc, lr	      	; return 
 ENDIF

uHALir_CacheSupported
	CHECK_CACHE	r0
 IF :DEF: THUMB_AWARE   	; if interworking is required
   	BX    	lr             	; just return 
 ELSE                   	; some processors are not Thumb aware
   	MOV   	pc, lr	      	; return 
 ENDIF

uHALir_CheckUnifiedCache
	CHECK_UNIFIED	r0
 IF :DEF: THUMB_AWARE   	; if interworking is required
   	BX    	lr             	; just return 
 ELSE                   	; some processors are not Thumb aware
   	MOV   	pc, lr	      	; return 
 ENDIF


;-------------------------------------------------------------------
; unsigned int uHALir_ReadCacheMode(void)
;
; Routine to read the mmu state from the Co-processor

uHALir_ReadCacheMode
	RDMMU_STATE	r0

	;
	; We need to clear all bits apart from cache, write buffer & MMU
	; enable bits
	;
	MOV	r1, #(EnableMMU :OR: EnableDcache :OR: EnableWB)
	ORR	r1, r1, #EnableIcache
	AND	r0, r0, r1

 IF :DEF: THUMB_AWARE   	; if interworking is required
   	BX    	lr             	; just return 
 ELSE                   	; some processors are not Thumb aware
   	MOV   	pc, lr	      	; return 
 ENDIF


;-------------------------------------------------------------------
; void uHALir_WriteCacheMode(unsigned int)
;
; Routine to write the mmu state to the Co-processor

uHALir_WriteCacheMode
	STMFD	sp!, {r0, r4-r6, lr}	; Save registers
	MOV	r6, r0			; save the new mode
	
	CHECK_CACHE	r0
	BEQ	%F43

	; Switch into SVC returns SPSR in r0
	BL	uHALir_EnterLockedSvcMode

	;
	; This code must maintain the state of all other bits in the
	; control register that apart from cache, write buffer & MMU
	; enable bits
	;
	MOV	r5, #(EnableMMU :OR: EnableDcache :OR: EnableWB)
	ORR	r5, r5, #EnableIcache	; Create mask of the bits we can touch
	AND	r6, r6, r5		; Clear all other bits from the mask supplied

	RDMMU_STATE	r4		; Read current state of control register

	BIC	r4, r4, r5		; Clear the bits that we may change
	ORR	r6, r6, r4		; Merge in the supplied mask

	WRMMU_STATE	r6		; Write this to the control register

	; Make sure the pipeline is clear of any cached entries
	NOP
	NOP
	NOP

	; Switch back to the mode we started in (restores interrupts, if any)
	BL	uHALir_ExitSvcMode	; Switch out of SVC mode, r0 -> spsr
43
 IF :DEF: THUMB_AWARE      		; if interworking is required
	LDMFD	sp!,{r0, r4-r6, lr}	; restore registers and return
	BX    	lr                	; just return 
 ELSE                      		; some processors are not Thumb aware
	LDMFD	sp!,{r0, r4-r6, pc}	; restore registers and return
 ENDIF

;-------------------------------------------------------------------
; void uHALir_DisableICache(void)
;
; Routine to flush and disable the I Cache

uHALir_DisableICache
	STMFD	sp!,{r0, r4-r5, lr}	; Save registers

	CHECK_CACHE	r0
	BEQ	%F44

	; Switch into SVC returns SPSR in r0
	BL	uHALir_EnterLockedSvcMode

	MOV	r4, #0
	WRCACHE_FlushIC	r4		; Flush ICache

	RDMMU_STATE	r4
	CLEAR_ICACHE	r4
	WRMMU_STATE	r4		; Update current state

	; Make sure the pipeline is clear of any cached entries
	NOP
	NOP
	NOP

	; Switch back to the mode we started in (restores interrupts, if any)
	;	uHALir_ExitSvcMode(spsr);
	BL	uHALir_ExitSvcMode	; Switch out of SVC mode, r0 -> spsr
44
 IF :DEF: THUMB_AWARE        		; if interworking is required
	LDMFD	sp!,{r0, r4-r5, lr} 	; restore registers and return
	BX	lr                  	; just return 
 ELSE                        		; some processors are not Thumb aware
	LDMFD	sp!,{r0, r4-r5, pc} 	; restore registers and return
 ENDIF


;-------------------------------------------------------------------
; void uHALir_DisableDCacheAnd(void)
;
; Routine to flush and disable the D Cache

uHALir_DisableDCache
	STMFD	sp!,{r0, r4-r5, lr}	; Save registers

	CHECK_CACHE	r0
	BEQ	%F45

	; Switch into SVC returns SPSR in r0
	BL	uHALir_EnterLockedSvcMode

	; Clean the Dcache before flush
	BL	uHALir_CleanDCache

	MOV	r4, #0
	WRCACHE_FlushDC	r4		; Flush DCache

	RDMMU_STATE	r4
	CLEAR_DCACHE	r4
	WRMMU_STATE	r4		; Update current state

	; Make sure the pipeline is clear of any cached entries
	NOP
	NOP
	NOP

	; Switch back to the mode we started in (restores interrupts, if any)
	;	uHALir_ExitSvcMode(spsr);
	BL	uHALir_ExitSvcMode	; Switch out of SVC mode, r0 -> spsr
45
 IF :DEF: THUMB_AWARE        		; if interworking is required
	LDMFD	sp!,{r0, r4-r5, lr} 	; restore registers and return
   	BX    	lr                  	; just return 
 ELSE                        		; some processors are not Thumb aware
	LDMFD	sp!,{r0, r4-r5, pc} 	; restore registers and return
 ENDIF


;-------------------------------------------------------------------
; void uHALir_DisableWriteBuffer(void)
;
; Routine to disable the Write Buffer

uHALir_DisableWriteBuffer
	STMFD	sp!,{r0, r4-r5, lr}	; Save registers

	CHECK_CACHE	r0
	BEQ	%F46

	; Switch into SVC returns SPSR in r0
	BL	uHALir_EnterLockedSvcMode

	; Clean the Dcache before flush
	BL	uHALir_CleanDCache

	MOV	r4, #0
	WRCACHE_FlushDC	r4		; Flush DCache

	RDMMU_STATE	r4
	CLEAR_DCACHE	r4
	CLEAR_WBUFFER	r4
	WRMMU_STATE	r4		; Update current state

	; Make sure the pipeline is clear of any cached entries
	NOP
	NOP
	NOP

	; Switch back to the mode we started in (restores interrupts, if any)
	;	uHALir_ExitSvcMode(spsr);
	BL	uHALir_ExitSvcMode	; Switch out of SVC mode, r0 -> spsr
46
 IF :DEF: THUMB_AWARE     		; if interworking is required
	LDMFD	sp!,{r0, r4-r5, lr} 	; restore registers and return
   	BX    	lr                  	; just return 
 ELSE                        		; some processors are not Thumb aware
	LDMFD	sp!,{r0, r4-r5, pc} 	; restore registers and return
 ENDIF

;-------------------------------------------------------------------
;void uHALir_CleanDCacheEntry (void *)
;
; Routine to clean (at least) one Data Cache entry

uHALir_CleanDCacheEntry
 	STMFD	sp!,{r0-r1, lr}	; Save registers

	WRCACHE_CleanDCentry	r0

 IF :DEF: THUMB_AWARE			; if interworking is required
	LDMFD	sp!,{r0-r1, lr}		; restore registers and return
	BX    	lr                  	; just return 
 ELSE                        		; some processors are not Thumb aware
	LDMFD	sp!,{r0-r1, pc} 	; restore registers and return
 ENDIF

;-------------------------------------------------------------------
; void uHALir_CleanDCache(void) 
;
; Routine to clean D cache

uHALir_CleanDCache
	STMFD	sp!,{r0-r5, lr}	; Save registers

	WRCACHE_CleanDCache	r0, r1, r2, r3, r4, r5

 IF :DEF: THUMB_AWARE     		; if interworking is required
	LDMFD	sp!,{r0-r5, lr} 	; restore registers and return
	BX    	lr                  	; just return 
 ELSE                        		; some processors are not Thumb aware
	LDMFD	sp!,{r0-r5, pc} 	; restore registers and return
 ENDIF
;-------------------------------------------------------------------

	END
