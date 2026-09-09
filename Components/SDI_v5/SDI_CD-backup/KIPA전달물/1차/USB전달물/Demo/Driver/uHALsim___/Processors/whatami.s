
IF :DEF: NOTYET
	IMPORT	=uHALir_ReadCPUIdFromBoard, WEAK

uHALir_GetCPUId
	; Sequence of events is as follows:
	;
	; 1.	Try to use a board-specific routine, the board designer
	;	may have implemented a mechanism for identifying CPUs.
	; 2.	If the board can have a CPU without the CPU/Vendor ID in
	;	a co-processor, we have to play with the Undefined
	;	instruction vector:
	;  a.	Is the vector writable? If not, we have to assume
	;	minimum CPU (ARM7T)
	;  b.	Change the vector to point at our routine
	; 3.	Read from CP15 register 0.
	;  a.	If the exception vector is taken, it is an ARM7/9T.
	;  b.	Otherwise, we have read the CPU/Vendor ID.
	; 4.	Save the determined CPU/Vendor ID.
	; 5.	Restore the original Undefined Vector.
	;
	LDR	r0, =uHALir_ReadCPUIdFromBoard
	CMP	r0, #0
	BEQ	NoBoardId

	BL	uHALir_ReadCPUIdFromBoard
	B	CPUIdFound
or
	LDR	lr, =CPUIdFound
	mov	pc, r0

 IF :DEF: CPU_MAY_NOT_HAVE_VENDORID

	; Save the Undefined Vector

 ENDIF

	RDCP15_ID	r0		; Read the CPU/Vendor ID

	LDR	r1, =uHALiv_CPUType	
	STR	r0, [r1]

 IF :DEF: CPU_MAY_NOT_HAVE_VENDORID

	; Restore the Undefined Vector

 ENDIF
   
 IF :DEF: THUMB_AWARE  ; if interworking is required
   BX    lr             ; just return 
 ELSE                   ; some processors are not Thumb aware
   MOV   pc, lr	      ; return 
 ENDIF
 
 ENDIF

	END
