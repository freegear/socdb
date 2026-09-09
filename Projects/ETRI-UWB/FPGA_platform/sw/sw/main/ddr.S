/*
 * ddr.S: ddr test code
 *
 */

.global DDRTest0
.text
DDRTest0:
	ldr r0, =0x60000000			// DDR Start Address
	ldr r1, =0x00001000			// 4KWord(16KB)
	ldr r2, =0x00000000			// test data

	// store data
1:
	str r2, [r0]
	add r2, r2, #1
	add r0, r0, #4
	sub r3, r2, r1 
	cmp r3, #0
	bne 1b

	ldr r0, =0x60000000			// RAM Start Addr
	ldr r2, =0x00000000			// test data
2:
	ldr r3, [r0]
	sub r3, r2, r3
	cmp r3, #0
	bne 3f						// error !
	add r2, r2, #1
	add r0, r0, #4
	sub r3, r2, r1
	cmp r3, #0
	bne 2b

	b 4f
3:
	ldr  r1 , =0x50002008		// GPIO_OUTL
	ldr  r3 , =0x0000deaf		// 0xdeaf
	str  r3 , [r1]
	b 3b
4:
	mov pc, lr					// return

