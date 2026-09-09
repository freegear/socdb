;******************************************************************************
; Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
; Copyright © ARM Limited 1998.  All rights reserved.
;******************************************************************************
;******************************************************************************
;	Redirection code for routines normally held in a C library.   Do not
;	build this module if you start using a real C library.
;******************************************************************************/

	INCLUDE	platform.s
	
	EXPORT	lib_support_printf		
	EXPORT	lib_support_putchar
	EXPORT	lib_support_getchar
	EXPORT	lib_support_malloc
	EXPORT	lib_support_free
	EXPORT  lib_flush_buffer
 	
	IMPORT	malloc, WEAK
	IMPORT	free, WEAK
	IMPORT	_printf, WEAK
	IMPORT	getchar, WEAK
	IMPORT	putchar, WEAK
	IMPORT	_fflush, WEAK
	IMPORT	_flushlinebuffered, WEAK

	KEEP

	AREA	uHAL_external, CODE, READONLY

; Routines to determine if C library support is avaliable
; for printf, getchar etc. If it is avaliable then use these
; instead of the uHAL definitions. Failure is denoted by 
; returning a 0.

lib_support_printf
	STMFD	sp!, {lr}		; save working registers

	LDR		lr,=_printf
   	TEQ     lr, #0x00000000
   	MOVEQ   r0, #0x00000000 ; failure
   	BLNE    _printf
	LDMFD	sp!, {lr}		; restore registers & return

 IF :DEF: THUMB_AWARE
	BX 		lr
 ELSE
	MOV	    pc,lr
 ENDIF

lib_support_putchar
	STMFD	sp!, {lr}		; save working registers
	LDR		lr,=_printf		; cant use putc if printf is not there.
   	TEQ     lr, #0x00000000
   	BEQ    	%F1

	LDR		lr, =putchar
	TEQ		lr, #0x00000000
	BLNE	putchar
1
	MOVEQ	r0,#0x00000000	; failure
	LDMFD	sp!, {lr}		; restore registers & return
 IF :DEF: THUMB_AWARE
	BX 		lr
 ELSE
	MOV	    pc,lr
 ENDIF

lib_flush_buffer
	STMFD	sp!, {lr}		; save working registers
	LDR     lr,=_flushlinebuffered
   	TEQ     lr, #0x00000000
	BLNE	_flushlinebuffered

	LDMFD	sp!, {lr}		; restore registers & return
 IF :DEF: THUMB_AWARE
	BX 		lr
 ELSE
	MOV	    pc,lr
 ENDIF

lib_support_getchar
	STMFD	sp!, {lr}		; save working registers
	LDR		lr, =getchar
	TEQ		lr, #0x00000000
	BLNE	getchar

	LDR     lr,=_flushlinebuffered
   	TEQ     lr, #0x00000000
	BLNE	_flushlinebuffered

	MOVEQ	r0,#0x00000000	; failure
	LDMFD	sp!, {lr}		; restore registers & return
 IF :DEF: THUMB_AWARE
	BX 		lr
 ELSE
	MOV	    pc,lr
 ENDIF


; Failure for free and malloc is denoted by returning -1.
lib_support_free
	STMFD	sp!, {r6,lr}	; save working registers
	LDR		lr, =free
	TEQ		lr, #0x00000000
	MRS		r6,CPSR
	BLNE	free	
	MSR		CPSR_cf,r6
	MOVNE	r0,#0x00000001	; success
	MOVEQ	r0,#0xFFFFFFFF	; failure
	LDMFD	sp!, {r6,lr}	; restore registers & return
 IF :DEF: THUMB_AWARE
	BX 		lr
 ELSE
	MOV	    pc,lr
 ENDIF

lib_support_malloc
	STMFD	sp!, {lr}		; save working registers
	LDR		lr, =malloc
	TEQ		lr, #0x00000000
	MOVEQ	r0,#0xFFFFFFFF	; failure
	BLNE	malloc
	LDMFD	sp!, {lr}		; restore registers & return
 IF :DEF: THUMB_AWARE
	BX 		lr
 ELSE
	MOV	    pc,lr
 ENDIF

        END