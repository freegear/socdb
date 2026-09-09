;******************************************************************************
; Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
; Copyright © ARM Limited 1998, 1999.  All rights reserved.
;******************************************************************************
;/*****************************************************************************

;  C library initlization code and general routines to
;	return memory locations and sizes.

;	$Id: support.s,v 1.6.2.3 2000/02/02 09:22:48 mwelsh Exp $

;******************************************************************************/

	INCLUDE platform.s

	EXPORT  uHALr_SizeOfFreeRam		; Returns the size of the heap
	EXPORT  uHALr_StartOfFreeRam	; Returns start of heap
	EXPORT	uHALr_StartOfRam		; Returns 1st free RAM address
	EXPORT	uHALr_EndOfFreeRam		; Returns last free RAM address
	EXPORT	uHALr_EndOfRam			; Returns top of available RAM

	EXPORT  uHALr_LibraryInit
	EXPORT  uHALir_CLibInit			; Initializes the C library
	EXPORT  __rt_heap_extend
	EXPORT	__rt_stackheap_init

	IMPORT	uHALiv_TopOfHeap		; Variables holding above values
	IMPORT	uHALiv_TopOfMemory
	IMPORT	uHALiv_BaseOfMemory
	IMPORT  uHALiv_FileCount
	IMPORT	uHALiv_MemorySize		; Memory Size

	IMPORT	uHALir_FloatInit
	IMPORT	uHALir_EnterSvcMode	; Enter Supervisor mode.
	IMPORT	uHALir_ExitSvcMode	; Exit Supervisor mode.
	IMPORT 	uHALir_InitTMem, WEAK
	IMPORT 	uHALr_InitHeap

	IMPORT  _init_alloc, WEAK
	IMPORT  _initio, WEAK
	IMPORT	__rt_malloc, WEAK

	IMPORT __heap_base, WEAK
	IMPORT __heap_limit, WEAK
	IMPORT __stack_base, WEAK
	IMPORT __stack_limit, WEAK

	KEEP

	AREA	uHAL_external, CODE, READONLY

; Routines to return addresses of start & end of free & end of installed RAM.
	INCLUDE linkdata.s		; Any compiler dependencies are in here
uHALr_StartOfRam
	LDR	r0, uHAL_EndOfBSS	; 1st available uninitialised RAM
	
 IF :DEF: THUMB_AWARE   ; if interworking is required
	BX    lr
 ELSE                    ; some processors are not Thumb aware
	MOV	pc, lr			 ; All done, return
 ENDIF

uHALr_EndOfRam
	STMFD	sp!, {r4, lr}
	LDR	r4, =uHALiv_TopOfMemory
	LDR	r0, [r4]
	
 IF :DEF: THUMB_AWARE   ; if interworking is required
 	LDMFD	sp!, {r4, lr}		; restore registers and return
	BX    lr
 ELSE                    ; some processors are not Thumb aware
 	LDMFD	sp!, {r4, pc}		; restore registers and return
 ENDIF

uHALr_EndOfFreeRam
	STMFD	sp!, {r4, lr}	
	LDR		r4, =__heap_limit
	TEQ 	r4, #0x00000000
	LDREQ	r4, =uHALiv_TopOfHeap
	LDR		r0, [r4]
	
 IF :DEF: THUMB_AWARE   ; if interworking is required
 	LDMFD	sp!, {r4, lr}		; restore registers and return
	BX    lr
 ELSE                    ; some processors are not Thumb aware
 	LDMFD	sp!, {r4, pc}		; restore registers and return
 ENDIF

uHALr_StartOfFreeRam
	STMFD	sp!, {r4, lr}
	LDR		r4, =__heap_base
	TEQ 	r4, #0x00000000
	LDREQ	r4, =uHALiv_BaseOfMemory
	LDR		r0, [r4]
	
 IF :DEF: THUMB_AWARE   ; if interworking is required
 	LDMFD	sp!, {r4, lr}		; restore registers and return
	BX    lr
 ELSE                    ; some processors are not Thumb aware
 	LDMFD	sp!, {r4, pc}		; restore registers and return
 ENDIF

uHALr_SizeOfFreeRam
	STMFD	sp!, {r1,r2,r4,lr}
	LDR		r4, =__heap_base
	TEQ 	r4, #0x00000000
	LDREQ	r4, =uHALiv_BaseOfMemory
	LDR		r2, [r4]
	LDRNE	r4, =__heap_limit
	LDREQ	r4, =uHALiv_TopOfHeap
	LDR		r1, [r4]
	SUB 	r0, r1, r2
	
 IF :DEF: THUMB_AWARE   ; if interworking is required
 	LDMFD	sp!, {r1,r2,r4,lr}		; restore registers and return
	BX    lr
 ELSE                    ; some processors are not Thumb aware
 	LDMFD	sp!, {r1,r2,r4,pc}		; restore registers and return
 ENDIF

; Routine to initialize the ADS C library if the initialization
; routines are present
uHALir_CLibInit
	STMFD	sp!, {r0,r2,r4,r14}

	BL		uHALir_FloatInit
; Must keep the next two routine calls in order, init_alloc
; needs the heap base and limit in r0 and r1 respectively.

 	BL 		__rt_stackheap_init
	LDR		r4, =_init_alloc
	TEQ 	r4, #0x00000000
	BLNE	_init_alloc

	MOV		r2,#0x00
	LDR		r0,=uHALiv_FileCount
	STR 	r2, [r0]		; Clear the number of files opened.

	LDR		r4, =_initio
	TEQ 	r4, #0x00000000
	BLNE 	_initio ; Opens stdin, stdout and stderr
	
 IF :DEF: THUMB_AWARE   ; if interworking is required
	LDMFD	sp!, {r0,r2,r4,lr}		; restore registers and return
	BX    lr
 ELSE                    ; some processors are not Thumb aware
	LDMFD	sp!, {r0,r2,r4,pc}		; restore registers and return
 ENDIF

; Returns the heap top and bottom for ADS Lib C init
; in r1 and r0 respectively
;
; Register usage
;
; R9 - hi tide R8 - hi ebb R7 - lo ebb R6 - lo tide
; R1 - Gap 1 R2 - Gap 2 R3 - Gap 3
;
; Algorithm for calculating the avaliable memory for 
; the heap. Generates three values, Gap 1 Gap 2 and Gap 3
;
;        ----------------  Top of memory (TOM)
;	 |                |
;	 |                |
;	 |                |
;	  ----------------  Top of Free memory (TOF)
;	 |                |
;	 |                |
;	 |   Gap 1        |			 hi ebb = lo tide = RWB
;	 |                |			 lo ebb = hi tide = RWT
;	 |         tide   |			 if ROB < TOM
;   ROT  ----------------  RWT			if ROB < RWB
;	 |                |					lo tide = ROB
;	 |   hi           |					lo ebb = ROT
;	 |                |				if ROT > RWT
;   ROB  ----------------  RWB				hi tide = ROT
;	 |         ebb    |					hi ebb = ROB
;	 |                |			 	Gap 3 = hi ebb - lo ebb
;	 |   Gap 3        |			 else
;	 |                |				Gap 3 = 0
;	 |         ebb    |
;   RWT  ----------------  ROT		 Gap 1 = TOF - hi tide
;	 |                |			 Gap 2 = lo tide - BOF
;	 |   lo           |			 if Gap 1 >= Gap 2 && Gap 1 >= Gap 3
;	 |                |			    BOF = hi tide
;   RWB  ----------------  ROB		 elseif Gap 2 >= Gap 1 && Gap 2 >= Gap 3
;	 |         tide   |				TOF = lo tide
;	 |                |			 else
;	 |   Gap 2        |				TOF = hi ebb
;	 |                |				BOF = lo ebb
;	 |                |
;        ----------------  Base of Free Memory (BOF)
;	 |                |
;	 |                |
;	 |                |
;        ----------------  Base of Memory (BOM)
;
;
;

__rt_stackheap_init
	STMFD	sp!, {r2-r9,lr}
	LDR r9, uHAL_EndOfBSS 	; hi tide = RWT
	LDR r7, uHAL_EndOfBSS	; lo ebb = RWT
	LDR r8, uHAL_StartOfBSS ; hi ebb = RWB
	LDR r6, uHAL_StartOfBSS ; lo tide = RWB

;
; The next section of code determines the values of
; lo and hi tide and ebb, given the above diagram.
;
; if ROB < TOM
	LDR	r0, =uHALiv_TopOfMemory
	LDR	r1, [r0]
	LDR r4, uHAL_StartOfROM	; ROB
	CMP r4, r1
	MOVGE 	r3, #0x0 ; Gap three = 0
	BGE 	%F4		; Gap must be zero
; 	if ROB < RWB
	LDR r5, uHAL_StartOfBSS	; RWB
	CMP r4, r5  ; ROB < RWB
;		lo tide = ROB
;		lo ebb = ROT
	LDRLT 	r6, uHAL_StartOfROM ; ROB
	LDRLT 	r7, uHAL_TopOfROM	; ROT

;	if ROT > RWT
	LDR r5, uHAL_EndOfBSS	; RWT
	LDR r4, uHAL_TopOfROM	; ROT	
	CMP r4, r5
;		hi tide = ROT
;		hi ebb = ROB
	LDRGT 	r9, uHAL_TopOfROM 	; ROT
	LDRGT 	r8, uHAL_EndOfBSS	; ROB

;	Gap 3 = hi ebb - lo ebb
	SUB	r3, r8, r7
; else
4
;	if BOF > lo tide
	LDR	r0, =uHALiv_BaseOfMemory
	LDR	r5, [r0]
	CMP	r5, r6
	MOVGT r2, #0x0 ; Gap two = 0
	SUBLE	r2, r6, r5 ; Gap two = lo tide - BOF
	
	LDR	r0, =uHALiv_TopOfHeap ; Gap one = TopofFree - hi tide
	LDR	r1, [r0]	
	SUB r1, r1, r9

;
; The next section of code calculates which of the three
; gaps is the largest and sets the BOF and TOF as required.
; The gap values are not currently stored, if heap extension
; is required these values could be stored and used with the
; routine __rt_heap_extend.
;
; 	if Gap one > Gap two and Gap one > Gap 3
	CMP 	r1, r2
	CMPGE	r1, r3
	ADDGE	r9, r9, #0x4 	; make sure of base of memory + 4
	LDRGE	r0, =uHALiv_BaseOfMemory ; BaseOfMem = hi tide
	STRGE 	r9, [r0]
	BGT		%F5

; 	elseif Gap two > Gap one and Gap two > Gap 3
	CMP 	r2, r1
	CMPGE 	r2, r3
	SUBGE	r6, r6, #0x4 ; make sure top of free - 4
	LDRGE	r0, =uHALiv_TopOfHeap ; TopofFree = lo tide
	STRGE 	r6, [r0]
	BGT		%F5

;	else 	
	LDR	r0, =uHALiv_TopOfHeap ; TopofFree = hi ebb
	SUB r8, r8, #0x4 ; make sure top of free = hi ebb - 4
	STR r8, [r0]
	ADD r7, r7, #0x4 ; make sure base of mem = lo ebb + 4
	LDR	r0, =uHALiv_BaseOfMemory ; BaseOfMem = lo ebb
	STR r7, [r0]
5
	LDR	r4, =uHALiv_BaseOfMemory
	LDR	r0, [r4]		; Here's the top of free RAM
	LDR	r4, =uHALiv_TopOfHeap	; Top of installed memory
	LDR	r1, [r4]
	LDMFD	sp!, {r2-r9,lr}		; restore registers and return
	
 IF :DEF: THUMB_AWARE   ; if interworking is required
	BX    lr
 ELSE                    ; some processors are not Thumb aware
	MOV	pc, lr			 ; All done, return
 ENDIF
	 
; Routine to provide additional memory to the heap.
; Could be non-contiguous memory. If you wish to use this
; functionality you could store the gaps calculated
; in __rt_stack_heap_init above as valid heap locations.
__rt_heap_extend
	MOV a1, #0
	
 IF :DEF: THUMB_AWARE   ; if interworking is required
	BX    lr
 ELSE                    ; some processors are not Thumb aware
	MOV	pc, lr			 ; All done, return
 ENDIF

; Routine to initialize the SDT C lib heap management
; routines by setting up the function pointer for the
; malloc routine. Also inits uHAL heap for non lib C
; implementation.
uHALr_LibraryInit
	STMFD	sp!, {r1,lr}		; save working registers
	BL	uHALir_EnterSvcMode
	STMFD	sp!, {r0}		; save working registers
	LDR	r1, =_init_alloc
	TEQ 	r1, #0x00000000
	BNE	%F7
	LDR	r1, =__rt_malloc
	TEQ 	r1, #0x00000000
	BNE	%F6
	LDR	r1, =uHALir_InitTMem
	TEQ 	r1, #0x00000000
	BLNE	uHALir_InitTMem
6
	BL	uHALr_InitHeap
7
	LDMFD	sp!, {r0}		; restore registers & return
	BL	uHALir_ExitSvcMode	; needs old mode in r0 
	
 IF :DEF: THUMB_AWARE   ; if interworking is required
	LDMFD	sp!, {r1,lr}		; restore registers and return
	BX    lr
 ELSE                    ; some processors are not Thumb aware
	LDMFD	sp!, {r1,pc}		; restore registers and return
 ENDIF

; Only included for compatibility with SDT 2.50, initializes
; the function pointer for malloc, if its there.
 IF uHAL_HEAP <> 0
 IF USE_C_LIBRARY = 1
	EXPORT	uHALir_InitCLibraryMalloc
	IMPORT	__rt_malloc, WEAK
	IMPORT	uHALr_malloc
uHALir_InitCLibraryMalloc
	LDR		r0, =uHALr_malloc
	LDR		r1, =__rt_malloc
	TEQ 	r1, #0x00000000
	STRNE	r0, [r1]
	
 	IF :DEF: THUMB_AWARE   ; if interworking is required
		BX    lr
 	ELSE                    ; some processors are not Thumb aware
		MOV	pc, lr			 ; All done, return
 	ENDIF

 ENDIF
 ENDIF

        END