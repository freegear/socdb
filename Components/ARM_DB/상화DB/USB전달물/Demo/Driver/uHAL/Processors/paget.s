
	; Simple macro to clear all page table entries.
$label  INIT_PGTABLE	$count, $val, $ptr, $offset
	LDR	$ptr, =Level1tab
	ADD	$ptr, $ptr, $offset	; Real address of Level1 TTB
	MOV	$val, #0		; Invalid
	LDR	$count, =L1_TABLE_ENTRIES
77
	STR	$val, [$ptr], #4
	SUBS	$count, $count, #1	; decrement loop count
	BNE	%B77

	LDR	$ptr, =Level2tab_ROM
	ADD	$ptr, $ptr, $offset	; Real address of Level2 TTB
	LDR	$count, =L2_TABLE_ENTRIES
78
	STR	$val, [$ptr], #4
	SUBS	$count, $count, #1	; decrement loop count
	BNE	%B78

	MEND

	; If this platform supports auto-memory sizing, the size found
	; should be in $tmp2
$label  BUILD_PGTABLE	$tmp1, $tmp2, $tmp3, $tmp4, $tmp5, $addr, $offset

	; Offset between physical & virtual addresses for TTBs
	LDR	$offset, =TTB_OFFSET

	; ----------------------------------------------------
	; First clear all TT entries - FAULT
	; ----------------------------------------------------
	INIT_PGTABLE	$tmp3, $tmp4, $tmp5, $offset

	; ----------------------------------------------------
	; Here lies the MMU memory map for this board
	; ----------------------------------------------------
	ldr	$addr, =uHAL_AddressTable

	; ----------------------------------------------------
	; For executables which are linked for a different
	; address to the physically executed address:
	;
	; Need to adjust from the linked address of the table
	; to a relative offset from here. First, work out the
	; offset from the RO$$Base, then find out how far we
	; are from our actual start. Lastly, add the
	; difference to the current pc.

        LDR	$tmp4, =|Image$$RO$$Base| ; get linked location of code
	SUB	$addr, $addr, $tmp4	  ; A. table offset from start
        LDR	$tmp3, =%F79
	SUB	$tmp3, $tmp3, $tmp4	  ; B. Offset to next label
	SUB	$addr, $addr, $tmp3	  ; A-B

	; ----------------------------------------------------
	; Note: no more than 2 instructions between here and
	; the label.  Since pc is here + 8, add A-B to get
	; current table address
	MOV	$tmp3, pc
	ADD	$addr, $addr, $tmp3
79
	; ----------------------------------------------------
	; Check 1st Entry in address table
	; If this value is non-zero, size of first memory area is taken
	; from target-specific memory sizing code rather than this table
	; ----------------------------------------------------
	LDR	$tmp3, [$addr], #4
	CMP	$tmp3, #0
	BEQ	%F81		; Not autosizing, read all params

	; Make sure given memory size is a multiple of 1MB
	; tmp3 is no. of 1MB segments
	MOV	$tmp3, $tmp1, LSR #20
	MOV	$tmp4, $tmp3, LSL #20
	CMP	$tmp4, $tmp1
	ADDNE	$tmp3, #1

	; ----------------------------------------------------
	; Read 1st Entry from MMU table seperately to allow
	; memory sizing.
	; NOTE: 1st entry cannot abort & can't be Level2 !!
	LDR	$tmp4, =Level1tab
	ADD	$tmp4, $tmp4, $offset

	; Virtual base address -> Level1 offset in tmp2
	LDR	$tmp5, [$addr], #4
	ADD	$tmp2, $tmp4, $tmp5, LSR #(20-2)

	; Physical base address -> tmp4
	LDR	$tmp4, [$addr], #4
	; Access permissions etc -> tmp3 (NOTE: Size is skipped!)
	LDR	$tmp5, [$addr], #8

	CMP	$tmp5, #0		; Halt if access is zero
	BEQ	%F80

	TST	$tmp4, #PT_PAGE
	BNE	%F80			; Halt if Level2 table

	ADD	$tmp1, $tmp4, $tmp5	; Level1 Table Entry

	; Registers set, so build 1st entry & rest of TLB.
	B	%F83

	; All causes for error end up here
80	
 IF :DEF: ARM7T
	B	%F90			; No Page Table if no MMU
 ENDIF
	B	.

81
	LDR	$tmp4, =Level1tab
	ADD	$tmp4, $tmp4, $offset
82
	; Calculate offset to virtual base address entry -> tmp2
	LDR	$tmp1, [$addr], #4	; Virtual address
	ADD	$tmp2, $tmp4, $tmp1, LSR #(20-2)

	; Physical base address -> tmp1
	LDR	$tmp1, [$addr], #4
	; Access permissions etc -> tmp3
	LDR	$tmp3, [$addr], #4
	CMP	$tmp3, #0		; All done if access is zero
	BEQ	%F90

	TST	$tmp1, #PT_PAGE		; Check for Level2 table
	BNE	%F84			; Yes, do it

	; ----------------------------------------------------
	; Level 1 Entries, calculate size & fill table
	; ----------------------------------------------------
	ADD	$tmp1, $tmp1, $tmp3	; Level1 Table Entry
	LDR	$tmp3, [$addr], #4	; area size
	MOV	$tmp3, $tmp3, LSR #20	; no. of 1MB segments
83
	STR	$tmp1, [$tmp2], #4	; store Table Entry
	ADD	$tmp1, $tmp1, #SZ_1M	; add section number field
	SUBS	$tmp3, $tmp3, #1	; decrement loop count
	BGT	%B83
	B	%B82			; Repeat until done

84
	; Convert logical addresses to real addresses
	ADD	$tmp1, $tmp1, $offset	; Pointer to Level2 table

	; ----------------------------------------------------
	; Check for Fine table and process seperately
	; ----------------------------------------------------
	TST	$tmp3, #(PT_FINE - PT_PAGE)
	; Read size!
	LDR	$tmp5, [$addr], #4
	BIC	$tmp4, $tmp1, #0x0ff
	BNE	%F87

	; ----------------------------------------------------
	; Large Level2: Strip address of Level2 Table -> tmp4
	; ----------------------------------------------------
	BIC	$tmp4, $tmp4, #0x0300

	MOV	$tmp5, $tmp5, LSR #16	; no. of 64KB segments
	MOV	$tmp5, $tmp5, LSL #4	; no. of 4KB aliases
85
	STR	$tmp1, [$tmp2], #4	; Level1 points to Level2 entry
86
	; Add each entry aliased 16 times (64KB/4KB, so $tmp3 & 0xF == 0)
	STR	$tmp3, [$tmp4], #4	; store large L2 TT entry
	SUB	$tmp5, $tmp5, #1	; decrement page count
	TST	$tmp5, #0xF
	BNE	%B86			; upto 16 L2 entries

	; Add 16 L2 entries per L1 entry  (1MB/64KB, so $tmp3 & 0xF0 == 0)
	ADD	$tmp3, $tmp3, #SZ_64K	; next page field
	TST	$tmp5, #0xf0
	BNE	%B86			; upto 16 L2 entries

	CMP	$tmp5, #0		; All done?
	ADD	$tmp1, $tmp1, #0x400	; Next 1MB is 256 entries further down
	BNE	%B85			; No, do another L1 entry.
	B	%B81
87
	; ----------------------------------------------------
	; Fine Level2: Strip address of Level2 Table -> tmp4
	; ----------------------------------------------------
	BIC	$tmp4, $tmp4, #0x0f00

	MOV	$tmp5, $tmp5, LSR #16	; no. of 64KB segments
	MOVEQ	$tmp5, $tmp5, LSL #8	; no. of 1KB aliases
	MOVNE	$tmp5, $tmp5, LSL #4	; no. of 4KB aliases
88
	STR	$tmp1, [$tmp2], #4	; Level1 points to Level2 entry
89
	STR	$tmp3, [$tmp4], #4	; store fine L2 TT entry
	SUBS	$tmp5, $tmp5, #1	; decrement page count
	ADD	$tmp3, $tmp3, #SZ_1K	; next page field
	TST	$tmp5, #0x0ff
	BNE	%B89			; 4 x 256 L2 entries
	TST	$tmp5, #0x300
	BNE	%B89			; 3ff won't fit inside an instruction

	CMP	$tmp5, #0		; All done?
	ADD	$tmp1, $tmp1, #0x4000	; Next 1MB is 1K entries further down
	BNE	%B88			; No, do another L1 entry.
	B	%B81
90
	MEND
