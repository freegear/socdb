
cbasic-nocache-O2.or32:     file format elf32-or32

Disassembly of section .reset:

00000000 <_reset_vector-0x100>:
	...

00000100 <_reset_vector>:
 100:	15 00 00 00 	l.nop 0x0
 104:	15 00 00 00 	l.nop 0x0
 108:	9c 40 00 00 	l.addi r2,r0,0x0
 10c:	9c 60 00 00 	l.addi r3,r0,0x0
 110:	9c 80 00 00 	l.addi r4,r0,0x0
 114:	9c a0 00 00 	l.addi r5,r0,0x0
 118:	9c c0 00 00 	l.addi r6,r0,0x0
 11c:	9c e0 00 00 	l.addi r7,r0,0x0
 120:	9d 00 00 00 	l.addi r8,r0,0x0
 124:	9d 20 00 00 	l.addi r9,r0,0x0
 128:	9d 40 00 00 	l.addi r10,r0,0x0
 12c:	9d 60 00 00 	l.addi r11,r0,0x0
 130:	9d 80 00 00 	l.addi r12,r0,0x0
 134:	9d a0 00 00 	l.addi r13,r0,0x0
 138:	9d c0 00 00 	l.addi r14,r0,0x0
 13c:	9d e0 00 00 	l.addi r15,r0,0x0
 140:	9e 00 00 00 	l.addi r16,r0,0x0
 144:	9e 20 00 00 	l.addi r17,r0,0x0
 148:	9e 40 00 00 	l.addi r18,r0,0x0
 14c:	9e 60 00 00 	l.addi r19,r0,0x0
 150:	9e 80 00 00 	l.addi r20,r0,0x0
 154:	9e a0 00 00 	l.addi r21,r0,0x0
 158:	9e c0 00 00 	l.addi r22,r0,0x0
 15c:	9e e0 00 00 	l.addi r23,r0,0x0
 160:	9f 00 00 00 	l.addi r24,r0,0x0
 164:	9f 20 00 00 	l.addi r25,r0,0x0
 168:	9f 40 00 00 	l.addi r26,r0,0x0
 16c:	9f 60 00 00 	l.addi r27,r0,0x0
 170:	9f 80 00 00 	l.addi r28,r0,0x0
 174:	9f a0 00 00 	l.addi r29,r0,0x0
 178:	9f c0 00 00 	l.addi r30,r0,0x0
 17c:	9f e0 00 00 	l.addi r31,r0,0x0
 180:	18 60 60 00 	l.movhi r3,0x6000
 184:	a8 63 00 08 	l.ori r3,r3,0x8
 188:	9c a0 00 00 	l.addi r5,r0,0x0
 18c:	d4 03 28 00 	l.sw 0x0(r3),r5
 190:	18 60 00 00 	l.movhi r3,0x0
 194:	a8 63 08 8c 	l.ori r3,r3,0x88c
 198:	44 00 18 00 	l.jr r3
 19c:	15 00 00 00 	l.nop 0x0
Disassembly of section .text:

000001a0 <_buserr_except>:
 1a0:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 1a4:	d4 01 10 00 	l.sw 0x0(r1),r2
 1a8:	9c 41 00 04 	l.addi r2,r1,0x4
 1ac:	84 41 00 00 	l.lwz r2,0x0(r1)
 1b0:	44 00 48 00 	l.jr r9
 1b4:	9c 21 00 04 	l.addi r1,r1,0x4

000001b8 <_dpf_except>:
 1b8:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 1bc:	d4 01 10 00 	l.sw 0x0(r1),r2
 1c0:	9c 41 00 04 	l.addi r2,r1,0x4
 1c4:	84 41 00 00 	l.lwz r2,0x0(r1)
 1c8:	44 00 48 00 	l.jr r9
 1cc:	9c 21 00 04 	l.addi r1,r1,0x4

000001d0 <_ipf_except>:
 1d0:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 1d4:	d4 01 10 00 	l.sw 0x0(r1),r2
 1d8:	9c 41 00 04 	l.addi r2,r1,0x4
 1dc:	84 41 00 00 	l.lwz r2,0x0(r1)
 1e0:	44 00 48 00 	l.jr r9
 1e4:	9c 21 00 04 	l.addi r1,r1,0x4

000001e8 <_lpint_except>:
 1e8:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 1ec:	d4 01 10 00 	l.sw 0x0(r1),r2
 1f0:	9c 41 00 04 	l.addi r2,r1,0x4
 1f4:	84 41 00 00 	l.lwz r2,0x0(r1)
 1f8:	44 00 48 00 	l.jr r9
 1fc:	9c 21 00 04 	l.addi r1,r1,0x4

00000200 <_align_except>:
 200:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 204:	d4 01 10 00 	l.sw 0x0(r1),r2
 208:	9c 41 00 04 	l.addi r2,r1,0x4
 20c:	84 41 00 00 	l.lwz r2,0x0(r1)
 210:	44 00 48 00 	l.jr r9
 214:	9c 21 00 04 	l.addi r1,r1,0x4

00000218 <_illegal_except>:
 218:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 21c:	d4 01 10 00 	l.sw 0x0(r1),r2
 220:	9c 41 00 04 	l.addi r2,r1,0x4
 224:	84 41 00 00 	l.lwz r2,0x0(r1)
 228:	44 00 48 00 	l.jr r9
 22c:	9c 21 00 04 	l.addi r1,r1,0x4

00000230 <_hpint_except>:
 230:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 234:	d4 01 10 00 	l.sw 0x0(r1),r2
 238:	9c 41 00 04 	l.addi r2,r1,0x4
 23c:	84 41 00 00 	l.lwz r2,0x0(r1)
 240:	44 00 48 00 	l.jr r9
 244:	9c 21 00 04 	l.addi r1,r1,0x4

00000248 <_dtlbmiss_except>:
 248:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 24c:	d4 01 10 00 	l.sw 0x0(r1),r2
 250:	9c 41 00 04 	l.addi r2,r1,0x4
 254:	84 41 00 00 	l.lwz r2,0x0(r1)
 258:	44 00 48 00 	l.jr r9
 25c:	9c 21 00 04 	l.addi r1,r1,0x4

00000260 <_itlbmiss_except>:
 260:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 264:	d4 01 10 00 	l.sw 0x0(r1),r2
 268:	9c 41 00 04 	l.addi r2,r1,0x4
 26c:	84 41 00 00 	l.lwz r2,0x0(r1)
 270:	44 00 48 00 	l.jr r9
 274:	9c 21 00 04 	l.addi r1,r1,0x4

00000278 <_range_except>:
 278:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 27c:	d4 01 10 00 	l.sw 0x0(r1),r2
 280:	9c 41 00 04 	l.addi r2,r1,0x4
 284:	84 41 00 00 	l.lwz r2,0x0(r1)
 288:	44 00 48 00 	l.jr r9
 28c:	9c 21 00 04 	l.addi r1,r1,0x4

00000290 <_syscall_except>:
 290:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 294:	d4 01 10 00 	l.sw 0x0(r1),r2
 298:	9c 41 00 04 	l.addi r2,r1,0x4
 29c:	84 41 00 00 	l.lwz r2,0x0(r1)
 2a0:	44 00 48 00 	l.jr r9
 2a4:	9c 21 00 04 	l.addi r1,r1,0x4

000002a8 <_res1_except>:
 2a8:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 2ac:	d4 01 10 00 	l.sw 0x0(r1),r2
 2b0:	9c 41 00 04 	l.addi r2,r1,0x4
 2b4:	84 41 00 00 	l.lwz r2,0x0(r1)
 2b8:	44 00 48 00 	l.jr r9
 2bc:	9c 21 00 04 	l.addi r1,r1,0x4

000002c0 <_trap_except>:
 2c0:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 2c4:	d4 01 10 00 	l.sw 0x0(r1),r2
 2c8:	9c 41 00 04 	l.addi r2,r1,0x4
 2cc:	84 41 00 00 	l.lwz r2,0x0(r1)
 2d0:	44 00 48 00 	l.jr r9
 2d4:	9c 21 00 04 	l.addi r1,r1,0x4

000002d8 <_res2_except>:
 2d8:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 2dc:	d4 01 10 00 	l.sw 0x0(r1),r2
 2e0:	9c 41 00 04 	l.addi r2,r1,0x4
 2e4:	84 41 00 00 	l.lwz r2,0x0(r1)
 2e8:	44 00 48 00 	l.jr r9
 2ec:	9c 21 00 04 	l.addi r1,r1,0x4

000002f0 <_test_cond>:
 2f0:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 2f4:	d4 01 10 00 	l.sw 0x0(r1),r2
 2f8:	9c 41 00 04 	l.addi r2,r1,0x4
 2fc:	bc 03 ff ff 	l.sfeqi r3,0xffffffff
 300:	10 00 00 06 	l.bf 318 <_test_cond+0x28>
 304:	bc 03 00 01 	l.sfeqi r3,0x1
 308:	0c 00 00 27 	l.bnf 3a4 <_test_cond+0xb4>
 30c:	a9 63 00 00 	l.ori r11,r3,0x0
 310:	00 00 00 22 	l.j 398 <_test_cond+0xa8>
 314:	9c 60 00 04 	l.addi r3,r0,0x4
 318:	9c 60 ff e1 	l.addi r3,r0,0xffffffe1
 31c:	bd a3 00 03 	l.sflesi r3,0x3
 320:	10 00 00 10 	l.bf 360 <_test_cond+0x70>
 324:	15 00 00 00 	l.nop 0x0
 328:	9c 63 00 01 	l.addi r3,r3,0x1
 32c:	bd 43 00 05 	l.sfgtsi r3,0x5
 330:	10 00 00 10 	l.bf 370 <_test_cond+0x80>
 334:	15 00 00 00 	l.nop 0x0
 338:	9c 63 00 01 	l.addi r3,r3,0x1
 33c:	bd 43 00 06 	l.sfgtsi r3,0x6
 340:	10 00 00 10 	l.bf 380 <_test_cond+0x90>
 344:	15 00 00 00 	l.nop 0x0
 348:	9c 63 00 01 	l.addi r3,r3,0x1
 34c:	bc 03 02 9a 	l.sfeqi r3,0x29a
 350:	10 00 00 10 	l.bf 390 <_test_cond+0xa0>
 354:	15 00 00 00 	l.nop 0x0
 358:	00 00 00 12 	l.j 3a0 <_test_cond+0xb0>
 35c:	9c 63 00 01 	l.addi r3,r3,0x1
 360:	9c 63 ff f6 	l.addi r3,r3,0xfffffff6
 364:	bd 43 00 05 	l.sfgtsi r3,0x5
 368:	0f ff ff f4 	l.bnf 338 <_test_cond+0x48>
 36c:	15 00 00 00 	l.nop 0x0
 370:	9c 63 ff f6 	l.addi r3,r3,0xfffffff6
 374:	bd 43 00 06 	l.sfgtsi r3,0x6
 378:	0f ff ff f4 	l.bnf 348 <_test_cond+0x58>
 37c:	15 00 00 00 	l.nop 0x0
 380:	9c 63 ff f6 	l.addi r3,r3,0xfffffff6
 384:	bc 03 02 9a 	l.sfeqi r3,0x29a
 388:	0f ff ff f4 	l.bnf 358 <_test_cond+0x68>
 38c:	15 00 00 00 	l.nop 0x0
 390:	00 00 00 04 	l.j 3a0 <_test_cond+0xb0>
 394:	9c 60 02 90 	l.addi r3,r0,0x290
 398:	03 ff ff e2 	l.j 320 <_test_cond+0x30>
 39c:	bd a3 00 03 	l.sflesi r3,0x3
 3a0:	a9 63 00 00 	l.ori r11,r3,0x0
 3a4:	84 41 00 00 	l.lwz r2,0x0(r1)
 3a8:	44 00 48 00 	l.jr r9
 3ac:	9c 21 00 04 	l.addi r1,r1,0x4

000003b0 <_test_loops>:
 3b0:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 3b4:	d4 01 10 00 	l.sw 0x0(r1),r2
 3b8:	9c 41 00 04 	l.addi r2,r1,0x4
 3bc:	00 00 00 04 	l.j 3cc <_test_loops+0x1c>
 3c0:	9c 80 00 00 	l.addi r4,r0,0x0
 3c4:	9c 63 00 01 	l.addi r3,r3,0x1
 3c8:	9c 84 00 02 	l.addi r4,r4,0x2
 3cc:	bd 43 00 09 	l.sfgtsi r3,0x9
 3d0:	0f ff ff fd 	l.bnf 3c4 <_test_loops+0x14>
 3d4:	15 00 00 00 	l.nop 0x0
 3d8:	9c 84 ff ff 	l.addi r4,r4,0xffffffff
 3dc:	bc 04 ff ff 	l.sfeqi r4,0xffffffff
 3e0:	0f ff ff fe 	l.bnf 3d8 <_test_loops+0x28>
 3e4:	9c 63 ff fd 	l.addi r3,r3,0xfffffffd
 3e8:	a9 63 00 00 	l.ori r11,r3,0x0
 3ec:	84 41 00 00 	l.lwz r2,0x0(r1)
 3f0:	44 00 48 00 	l.jr r9
 3f4:	9c 21 00 04 	l.addi r1,r1,0x4

000003f8 <_test_arith>:
 3f8:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
 3fc:	d4 01 10 04 	l.sw 0x4(r1),r2
 400:	9c 41 00 0c 	l.addi r2,r1,0xc
 404:	d4 01 48 00 	l.sw 0x0(r1),r9
 408:	d4 01 50 08 	l.sw 0x8(r1),r10
 40c:	a8 c3 00 00 	l.ori r6,r3,0x0
 410:	9c 60 00 00 	l.addi r3,r0,0x0
 414:	a8 86 00 00 	l.ori r4,r6,0x0
 418:	00 00 00 08 	l.j 438 <_test_arith+0x40>
 41c:	a9 63 00 00 	l.ori r11,r3,0x0
 420:	e0 a5 33 06 	l.mul r5,r5,r6
 424:	e0 63 28 00 	l.add r3,r3,r5
 428:	e0 a4 18 00 	l.add r5,r4,r3
 42c:	e0 a5 58 00 	l.add r5,r5,r11
 430:	9c 84 00 01 	l.addi r4,r4,0x1
 434:	9d 65 00 05 	l.addi r11,r5,0x5
 438:	bd 44 00 27 	l.sfgtsi r4,0x27
 43c:	0f ff ff f9 	l.bnf 420 <_test_arith+0x28>
 440:	e0 a4 23 06 	l.mul r5,r4,r4
 444:	e1 43 58 00 	l.add r10,r3,r11
 448:	04 00 01 61 	l.jal 9cc <_report>
 44c:	a8 6a 00 00 	l.ori r3,r10,0x0
 450:	a9 6a 00 00 	l.ori r11,r10,0x0
 454:	85 21 00 00 	l.lwz r9,0x0(r1)
 458:	84 41 00 04 	l.lwz r2,0x4(r1)
 45c:	85 41 00 08 	l.lwz r10,0x8(r1)
 460:	44 00 48 00 	l.jr r9
 464:	9c 21 00 0c 	l.addi r1,r1,0xc

00000468 <_test_bitop>:
 468:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 46c:	d4 01 10 00 	l.sw 0x0(r1),r2
 470:	9c 41 00 04 	l.addi r2,r1,0x4
 474:	9d 60 00 00 	l.addi r11,r0,0x0
 478:	bd 43 00 22 	l.sfgtsi r3,0x22
 47c:	a8 eb 00 00 	l.ori r7,r11,0x0
 480:	10 00 00 16 	l.bf 4d8 <_test_bitop+0x70>
 484:	a9 0b 00 00 	l.ori r8,r11,0x0
 488:	9d e0 00 01 	l.addi r15,r0,0x1
 48c:	19 a0 80 00 	l.movhi r13,0x8000
 490:	18 80 ee dd 	l.movhi r4,0xeedd
 494:	18 c0 33 55 	l.movhi r6,0x3355
 498:	a8 84 cc bb 	l.ori r4,r4,0xccbb
 49c:	a8 c6 77 88 	l.ori r6,r6,0x7788
 4a0:	e0 a3 20 05 	l.xor r5,r3,r4
 4a4:	1a 20 11 22 	l.movhi r17,0x1122
 4a8:	e0 83 30 00 	l.add r4,r3,r6
 4ac:	aa 31 33 44 	l.ori r17,r17,0x3344
 4b0:	e0 85 20 03 	l.and r4,r5,r4
 4b4:	e0 cf 18 08 	l.sll r6,r15,r3
 4b8:	e0 ad 18 48 	l.srl r5,r13,r3
 4bc:	e0 84 88 04 	l.or r4,r4,r17
 4c0:	e1 6b 30 00 	l.add r11,r11,r6
 4c4:	9c 63 00 01 	l.addi r3,r3,0x1
 4c8:	e0 e7 28 00 	l.add r7,r7,r5
 4cc:	bd 43 00 22 	l.sfgtsi r3,0x22
 4d0:	0f ff ff f0 	l.bnf 490 <_test_bitop+0x28>
 4d4:	e1 08 20 00 	l.add r8,r8,r4
 4d8:	e1 6b 38 00 	l.add r11,r11,r7
 4dc:	e1 6b 40 00 	l.add r11,r11,r8
 4e0:	84 41 00 00 	l.lwz r2,0x0(r1)
 4e4:	44 00 48 00 	l.jr r9
 4e8:	9c 21 00 04 	l.addi r1,r1,0x4

000004ec <_test_types>:
 4ec:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 4f0:	d4 01 10 00 	l.sw 0x0(r1),r2
 4f4:	9c 41 00 04 	l.addi r2,r1,0x4
 4f8:	18 80 10 20 	l.movhi r4,0x1020
 4fc:	9c e0 00 09 	l.addi r7,r0,0x9
 500:	a8 84 30 40 	l.ori r4,r4,0x3040
 504:	e1 63 20 05 	l.xor r11,r3,r4
 508:	b8 6b 00 18 	l.slli r3,r11,0x18
 50c:	a4 cb 00 ff 	l.andi r6,r11,0xff
 510:	b8 8b 00 10 	l.slli r4,r11,0x10
 514:	b8 63 00 98 	l.srai r3,r3,0x18
 518:	a4 ab ff ff 	l.andi r5,r11,0xffff
 51c:	b8 84 00 90 	l.srai r4,r4,0x10
 520:	e0 66 18 00 	l.add r3,r6,r3
 524:	9c e7 ff ff 	l.addi r7,r7,0xffffffff
 528:	e0 63 28 00 	l.add r3,r3,r5
 52c:	bd 67 00 00 	l.sfgesi r7,0x0
 530:	e0 63 20 00 	l.add r3,r3,r4
 534:	e0 63 58 00 	l.add r3,r3,r11
 538:	13 ff ff f4 	l.bf 508 <_test_types+0x1c>
 53c:	e1 63 58 00 	l.add r11,r3,r11
 540:	84 41 00 00 	l.lwz r2,0x0(r1)
 544:	44 00 48 00 	l.jr r9
 548:	9c 21 00 04 	l.addi r1,r1,0x4

0000054c <_test_array>:
 54c:	9c 21 ff 64 	l.addi r1,r1,0xffffff64
 550:	d4 01 10 04 	l.sw 0x4(r1),r2
 554:	9c 41 00 9c 	l.addi r2,r1,0x9c
 558:	d4 01 48 00 	l.sw 0x0(r1),r9
 55c:	d4 01 50 08 	l.sw 0x8(r1),r10
 560:	a9 43 00 00 	l.ori r10,r3,0x0
 564:	9c a0 00 29 	l.addi r5,r0,0x29
 568:	18 80 00 00 	l.movhi r4,0x0
 56c:	a8 84 0c f8 	l.ori r4,r4,0xcf8
 570:	04 00 01 40 	l.jal a70 <_memcpy>
 574:	9c 62 ff d4 	l.addi r3,r2,0xffffffd4
 578:	04 00 01 15 	l.jal 9cc <_report>
 57c:	90 62 ff d9 	l.lbs r3,0xffffffd9(r2)
 580:	84 82 ff d4 	l.lwz r4,0xffffffd4(r2)
 584:	90 62 ff d9 	l.lbs r3,0xffffffd9(r2)
 588:	d7 e2 27 70 	l.sw 0xffffff70(r2),r4
 58c:	84 82 ff d8 	l.lwz r4,0xffffffd8(r2)
 590:	d7 e2 27 74 	l.sw 0xffffff74(r2),r4
 594:	84 82 ff dc 	l.lwz r4,0xffffffdc(r2)
 598:	d7 e2 27 78 	l.sw 0xffffff78(r2),r4
 59c:	84 82 ff e0 	l.lwz r4,0xffffffe0(r2)
 5a0:	d7 e2 27 7c 	l.sw 0xffffff7c(r2),r4
 5a4:	84 82 ff e4 	l.lwz r4,0xffffffe4(r2)
 5a8:	d7 e2 27 80 	l.sw 0xffffff80(r2),r4
 5ac:	84 82 ff e8 	l.lwz r4,0xffffffe8(r2)
 5b0:	d7 e2 27 84 	l.sw 0xffffff84(r2),r4
 5b4:	84 82 ff ec 	l.lwz r4,0xffffffec(r2)
 5b8:	d7 e2 27 88 	l.sw 0xffffff88(r2),r4
 5bc:	84 82 ff f0 	l.lwz r4,0xfffffff0(r2)
 5c0:	d7 e2 27 8c 	l.sw 0xffffff8c(r2),r4
 5c4:	84 82 ff f4 	l.lwz r4,0xfffffff4(r2)
 5c8:	d7 e2 27 90 	l.sw 0xffffff90(r2),r4
 5cc:	84 82 ff f8 	l.lwz r4,0xfffffff8(r2)
 5d0:	04 00 00 ff 	l.jal 9cc <_report>
 5d4:	d7 e2 27 94 	l.sw 0xffffff94(r2),r4
 5d8:	04 00 00 fd 	l.jal 9cc <_report>
 5dc:	90 62 ff 75 	l.lbs r3,0xffffff75(r2)
 5e0:	04 00 00 fb 	l.jal 9cc <_report>
 5e4:	a8 6a 00 00 	l.ori r3,r10,0x0
 5e8:	90 82 ff 70 	l.lbs r4,0xffffff70(r2)
 5ec:	90 62 ff 71 	l.lbs r3,0xffffff71(r2)
 5f0:	90 a2 ff 72 	l.lbs r5,0xffffff72(r2)
 5f4:	e0 64 18 00 	l.add r3,r4,r3
 5f8:	90 82 ff 73 	l.lbs r4,0xffffff73(r2)
 5fc:	e0 63 28 00 	l.add r3,r3,r5
 600:	90 a2 ff 74 	l.lbs r5,0xffffff74(r2)
 604:	e0 63 20 00 	l.add r3,r3,r4
 608:	90 82 ff 75 	l.lbs r4,0xffffff75(r2)
 60c:	e0 63 28 00 	l.add r3,r3,r5
 610:	90 a2 ff 76 	l.lbs r5,0xffffff76(r2)
 614:	e0 63 20 00 	l.add r3,r3,r4
 618:	90 82 ff 77 	l.lbs r4,0xffffff77(r2)
 61c:	e0 63 28 00 	l.add r3,r3,r5
 620:	90 a2 ff 78 	l.lbs r5,0xffffff78(r2)
 624:	e0 63 20 00 	l.add r3,r3,r4
 628:	90 82 ff 79 	l.lbs r4,0xffffff79(r2)
 62c:	e0 63 28 00 	l.add r3,r3,r5
 630:	90 a2 ff 7a 	l.lbs r5,0xffffff7a(r2)
 634:	e0 63 20 00 	l.add r3,r3,r4
 638:	90 82 ff 7b 	l.lbs r4,0xffffff7b(r2)
 63c:	e0 63 28 00 	l.add r3,r3,r5
 640:	90 a2 ff 7c 	l.lbs r5,0xffffff7c(r2)
 644:	e0 63 20 00 	l.add r3,r3,r4
 648:	90 82 ff 7d 	l.lbs r4,0xffffff7d(r2)
 64c:	e0 63 28 00 	l.add r3,r3,r5
 650:	90 a2 ff 7e 	l.lbs r5,0xffffff7e(r2)
 654:	e0 63 20 00 	l.add r3,r3,r4
 658:	90 82 ff 7f 	l.lbs r4,0xffffff7f(r2)
 65c:	e0 63 28 00 	l.add r3,r3,r5
 660:	90 a2 ff 80 	l.lbs r5,0xffffff80(r2)
 664:	e0 63 20 00 	l.add r3,r3,r4
 668:	90 82 ff 81 	l.lbs r4,0xffffff81(r2)
 66c:	e0 63 28 00 	l.add r3,r3,r5
 670:	90 a2 ff 82 	l.lbs r5,0xffffff82(r2)
 674:	e0 63 20 00 	l.add r3,r3,r4
 678:	90 82 ff 83 	l.lbs r4,0xffffff83(r2)
 67c:	e0 63 28 00 	l.add r3,r3,r5
 680:	90 a2 ff 84 	l.lbs r5,0xffffff84(r2)
 684:	e0 63 20 00 	l.add r3,r3,r4
 688:	90 82 ff 85 	l.lbs r4,0xffffff85(r2)
 68c:	e0 63 28 00 	l.add r3,r3,r5
 690:	90 a2 ff 86 	l.lbs r5,0xffffff86(r2)
 694:	e0 63 20 00 	l.add r3,r3,r4
 698:	90 82 ff 87 	l.lbs r4,0xffffff87(r2)
 69c:	e0 63 28 00 	l.add r3,r3,r5
 6a0:	90 a2 ff 88 	l.lbs r5,0xffffff88(r2)
 6a4:	e0 63 20 00 	l.add r3,r3,r4
 6a8:	90 82 ff 89 	l.lbs r4,0xffffff89(r2)
 6ac:	e0 63 28 00 	l.add r3,r3,r5
 6b0:	90 a2 ff 8a 	l.lbs r5,0xffffff8a(r2)
 6b4:	e0 63 20 00 	l.add r3,r3,r4
 6b8:	90 82 ff 8b 	l.lbs r4,0xffffff8b(r2)
 6bc:	e0 63 28 00 	l.add r3,r3,r5
 6c0:	90 a2 ff 8c 	l.lbs r5,0xffffff8c(r2)
 6c4:	e0 63 20 00 	l.add r3,r3,r4
 6c8:	90 82 ff 8d 	l.lbs r4,0xffffff8d(r2)
 6cc:	e0 63 28 00 	l.add r3,r3,r5
 6d0:	90 a2 ff 8e 	l.lbs r5,0xffffff8e(r2)
 6d4:	e0 63 20 00 	l.add r3,r3,r4
 6d8:	90 82 ff 8f 	l.lbs r4,0xffffff8f(r2)
 6dc:	e0 63 28 00 	l.add r3,r3,r5
 6e0:	90 a2 ff 90 	l.lbs r5,0xffffff90(r2)
 6e4:	e0 63 20 00 	l.add r3,r3,r4
 6e8:	90 82 ff 91 	l.lbs r4,0xffffff91(r2)
 6ec:	e0 63 28 00 	l.add r3,r3,r5
 6f0:	90 a2 ff 92 	l.lbs r5,0xffffff92(r2)
 6f4:	e0 63 20 00 	l.add r3,r3,r4
 6f8:	90 82 ff 93 	l.lbs r4,0xffffff93(r2)
 6fc:	e0 63 28 00 	l.add r3,r3,r5
 700:	90 a2 ff 94 	l.lbs r5,0xffffff94(r2)
 704:	e0 63 20 00 	l.add r3,r3,r4
 708:	90 82 ff 95 	l.lbs r4,0xffffff95(r2)
 70c:	e0 63 28 00 	l.add r3,r3,r5
 710:	90 a2 ff 96 	l.lbs r5,0xffffff96(r2)
 714:	e0 63 20 00 	l.add r3,r3,r4
 718:	90 82 ff 97 	l.lbs r4,0xffffff97(r2)
 71c:	e0 63 28 00 	l.add r3,r3,r5
 720:	e0 63 20 00 	l.add r3,r3,r4
 724:	e1 4a 18 00 	l.add r10,r10,r3
 728:	04 00 00 a9 	l.jal 9cc <_report>
 72c:	a8 6a 00 00 	l.ori r3,r10,0x0
 730:	a9 6a 00 00 	l.ori r11,r10,0x0
 734:	85 21 00 00 	l.lwz r9,0x0(r1)
 738:	84 41 00 04 	l.lwz r2,0x4(r1)
 73c:	85 41 00 08 	l.lwz r10,0x8(r1)
 740:	44 00 48 00 	l.jr r9
 744:	9c 21 00 9c 	l.addi r1,r1,0x9c

00000748 <_main>:
 748:	9c 21 ff e8 	l.addi r1,r1,0xffffffe8
 74c:	d4 01 10 0c 	l.sw 0xc(r1),r2
 750:	9c 41 00 18 	l.addi r2,r1,0x18
 754:	d4 01 48 08 	l.sw 0x8(r1),r9
 758:	d4 01 50 10 	l.sw 0x10(r1),r10
 75c:	d4 01 60 14 	l.sw 0x14(r1),r12
 760:	07 ff fe e4 	l.jal 2f0 <_test_cond>
 764:	9c 60 00 01 	l.addi r3,r0,0x1
 768:	a9 4b 00 00 	l.ori r10,r11,0x0
 76c:	07 ff fe e1 	l.jal 2f0 <_test_cond>
 770:	9c 60 ff ff 	l.addi r3,r0,0xffffffff
 774:	a8 6b 00 00 	l.ori r3,r11,0x0
 778:	e1 6a 58 00 	l.add r11,r10,r11
 77c:	04 00 00 94 	l.jal 9cc <_report>
 780:	e1 80 58 02 	l.sub r12,r0,r11
 784:	07 ff ff 0b 	l.jal 3b0 <_test_loops>
 788:	9c 60 00 01 	l.addi r3,r0,0x1
 78c:	a9 4b 00 00 	l.ori r10,r11,0x0
 790:	07 ff ff 08 	l.jal 3b0 <_test_loops>
 794:	9c 60 ff ff 	l.addi r3,r0,0xffffffff
 798:	a8 6b 00 00 	l.ori r3,r11,0x0
 79c:	e1 6a 58 00 	l.add r11,r10,r11
 7a0:	04 00 00 8b 	l.jal 9cc <_report>
 7a4:	e1 8c 58 02 	l.sub r12,r12,r11
 7a8:	07 ff ff 14 	l.jal 3f8 <_test_arith>
 7ac:	9c 60 00 01 	l.addi r3,r0,0x1
 7b0:	a9 4b 00 00 	l.ori r10,r11,0x0
 7b4:	07 ff ff 11 	l.jal 3f8 <_test_arith>
 7b8:	9c 60 ff ff 	l.addi r3,r0,0xffffffff
 7bc:	a8 6b 00 00 	l.ori r3,r11,0x0
 7c0:	e1 6a 58 00 	l.add r11,r10,r11
 7c4:	04 00 00 82 	l.jal 9cc <_report>
 7c8:	e1 8c 58 02 	l.sub r12,r12,r11
 7cc:	07 ff ff 27 	l.jal 468 <_test_bitop>
 7d0:	9c 60 00 01 	l.addi r3,r0,0x1
 7d4:	a9 4b 00 00 	l.ori r10,r11,0x0
 7d8:	07 ff ff 24 	l.jal 468 <_test_bitop>
 7dc:	9c 60 ff ff 	l.addi r3,r0,0xffffffff
 7e0:	a8 6b 00 00 	l.ori r3,r11,0x0
 7e4:	e1 6a 58 00 	l.add r11,r10,r11
 7e8:	04 00 00 79 	l.jal 9cc <_report>
 7ec:	e1 8c 58 02 	l.sub r12,r12,r11
 7f0:	07 ff ff 3f 	l.jal 4ec <_test_types>
 7f4:	9c 60 00 01 	l.addi r3,r0,0x1
 7f8:	a9 4b 00 00 	l.ori r10,r11,0x0
 7fc:	07 ff ff 3c 	l.jal 4ec <_test_types>
 800:	9c 60 ff ff 	l.addi r3,r0,0xffffffff
 804:	a8 6b 00 00 	l.ori r3,r11,0x0
 808:	e1 6a 58 00 	l.add r11,r10,r11
 80c:	04 00 00 70 	l.jal 9cc <_report>
 810:	e1 8c 58 02 	l.sub r12,r12,r11
 814:	07 ff ff 4e 	l.jal 54c <_test_array>
 818:	9c 60 00 01 	l.addi r3,r0,0x1
 81c:	a9 4b 00 00 	l.ori r10,r11,0x0
 820:	07 ff ff 4b 	l.jal 54c <_test_array>
 824:	9c 60 ff ff 	l.addi r3,r0,0xffffffff
 828:	a8 6b 00 00 	l.ori r3,r11,0x0
 82c:	e1 6a 58 00 	l.add r11,r10,r11
 830:	04 00 00 67 	l.jal 9cc <_report>
 834:	e1 8c 58 02 	l.sub r12,r12,r11
 838:	18 80 93 22 	l.movhi r4,0x9322
 83c:	a8 84 b8 63 	l.ori r4,r4,0xb863
 840:	e0 6c 20 00 	l.add r3,r12,r4
 844:	d4 01 18 04 	l.sw 0x4(r1),r3
 848:	18 80 00 00 	l.movhi r4,0x0
 84c:	a8 84 0d 21 	l.ori r4,r4,0xd21
 850:	18 60 93 22 	l.movhi r3,0x9322
 854:	d4 01 20 00 	l.sw 0x0(r1),r4
 858:	a8 63 bf e2 	l.ori r3,r3,0xbfe2
 85c:	04 00 00 51 	l.jal 9a0 <_printf>
 860:	e1 4c 18 00 	l.add r10,r12,r3
 864:	04 00 00 5a 	l.jal 9cc <_report>
 868:	a8 6a 00 00 	l.ori r3,r10,0x0
 86c:	04 00 00 37 	l.jal 948 <_exit>
 870:	a8 6a 00 00 	l.ori r3,r10,0x0
 874:	85 21 00 08 	l.lwz r9,0x8(r1)
 878:	84 41 00 0c 	l.lwz r2,0xc(r1)
 87c:	85 41 00 10 	l.lwz r10,0x10(r1)
 880:	85 81 00 14 	l.lwz r12,0x14(r1)
 884:	44 00 48 00 	l.jr r9
 888:	9c 21 00 18 	l.addi r1,r1,0x18

0000088c <_start>:
 88c:	15 00 00 00 	l.nop 0x0
 890:	9c 60 00 00 	l.addi r3,r0,0x0
 894:	9c 80 00 00 	l.addi r4,r0,0x0
 898:	18 20 00 01 	l.movhi r1,0x1
 89c:	a8 21 0e 70 	l.ori r1,r1,0xe70
 8a0:	18 40 00 00 	l.movhi r2,0x0
 8a4:	a8 42 09 70 	l.ori r2,r2,0x970
 8a8:	44 00 10 00 	l.jr r2
 8ac:	15 00 00 00 	l.nop 0x0

000008b0 <_init_mc>:
 8b0:	18 60 60 00 	l.movhi r3,0x6000
 8b4:	a8 63 00 00 	l.ori r3,r3,0x0
 8b8:	9c 83 00 10 	l.addi r4,r3,0x10
 8bc:	18 a0 04 00 	l.movhi r5,0x400
 8c0:	b8 a5 00 86 	l.srai r5,r5,0x6
 8c4:	a8 a5 00 25 	l.ori r5,r5,0x25
 8c8:	d4 04 28 00 	l.sw 0x0(r4),r5
 8cc:	9c 83 00 14 	l.addi r4,r3,0x14
 8d0:	18 a0 19 22 	l.movhi r5,0x1922
 8d4:	a8 a5 00 57 	l.ori r5,r5,0x57
 8d8:	d4 04 28 00 	l.sw 0x0(r4),r5
 8dc:	9c 83 00 08 	l.addi r4,r3,0x8
 8e0:	9c a0 03 ff 	l.addi r5,r0,0x3ff
 8e4:	d4 04 28 00 	l.sw 0x0(r4),r5
 8e8:	9c 83 00 00 	l.addi r4,r3,0x0
 8ec:	18 a0 0b 00 	l.movhi r5,0xb00
 8f0:	a8 a5 03 00 	l.ori r5,r5,0x300
 8f4:	d4 04 28 00 	l.sw 0x0(r4),r5
 8f8:	9c 83 00 1c 	l.addi r4,r3,0x1c
 8fc:	18 a0 00 00 	l.movhi r5,0x0
 900:	a8 a5 01 03 	l.ori r5,r5,0x103
 904:	d4 04 28 00 	l.sw 0x0(r4),r5
 908:	9c 83 00 18 	l.addi r4,r3,0x18
 90c:	18 a0 00 00 	l.movhi r5,0x0
 910:	b8 a5 00 86 	l.srai r5,r5,0x6
 914:	a8 a5 04 11 	l.ori r5,r5,0x411
 918:	d4 04 28 00 	l.sw 0x0(r4),r5
 91c:	9c 83 00 24 	l.addi r4,r3,0x24
 920:	18 a0 00 00 	l.movhi r5,0x0
 924:	a8 a5 01 03 	l.ori r5,r5,0x103
 928:	d4 04 28 00 	l.sw 0x0(r4),r5
 92c:	9c 83 00 20 	l.addi r4,r3,0x20
 930:	18 a0 00 80 	l.movhi r5,0x80
 934:	b8 a5 00 86 	l.srai r5,r5,0x6
 938:	a8 a5 04 11 	l.ori r5,r5,0x411
 93c:	d4 04 28 00 	l.sw 0x0(r4),r5
 940:	44 00 48 00 	l.jr r9
 944:	15 00 00 00 	l.nop 0x0

00000948 <_exit>:
 948:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 94c:	d4 01 10 00 	l.sw 0x0(r1),r2
 950:	9c 41 00 04 	l.addi r2,r1,0x4
 954:	e0 60 18 00 	l.add r3,r0,r3
 958:	15 00 00 01 	l.nop 0x1
 95c:	00 00 00 00 	l.j 95c <_exit+0x14>
 960:	15 00 00 00 	l.nop 0x0
 964:	84 41 00 00 	l.lwz r2,0x0(r1)
 968:	44 00 48 00 	l.jr r9
 96c:	9c 21 00 04 	l.addi r1,r1,0x4

00000970 <_reset>:
 970:	9c 21 ff f8 	l.addi r1,r1,0xfffffff8
 974:	d4 01 10 04 	l.sw 0x4(r1),r2
 978:	9c 41 00 08 	l.addi r2,r1,0x8
 97c:	d4 01 48 00 	l.sw 0x0(r1),r9
 980:	07 ff ff 72 	l.jal 748 <_main>
 984:	15 00 00 00 	l.nop 0x0
 988:	07 ff ff f0 	l.jal 948 <_exit>
 98c:	a8 6b 00 00 	l.ori r3,r11,0x0
 990:	85 21 00 00 	l.lwz r9,0x0(r1)
 994:	84 41 00 04 	l.lwz r2,0x4(r1)
 998:	44 00 48 00 	l.jr r9
 99c:	9c 21 00 08 	l.addi r1,r1,0x8

000009a0 <_printf>:
 9a0:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 9a4:	d4 01 10 00 	l.sw 0x0(r1),r2
 9a8:	9c 41 00 04 	l.addi r2,r1,0x4
 9ac:	84 82 00 00 	l.lwz r4,0x0(r2)
 9b0:	9c 62 00 04 	l.addi r3,r2,0x4
 9b4:	9c 64 00 00 	l.addi r3,r4,0x0
 9b8:	9c 83 00 00 	l.addi r4,r3,0x0
 9bc:	15 00 00 03 	l.nop 0x3
 9c0:	84 41 00 00 	l.lwz r2,0x0(r1)
 9c4:	44 00 48 00 	l.jr r9
 9c8:	9c 21 00 04 	l.addi r1,r1,0x4

000009cc <_report>:
 9cc:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 9d0:	d4 01 10 00 	l.sw 0x0(r1),r2
 9d4:	9c 41 00 04 	l.addi r2,r1,0x4
 9d8:	9c 63 00 00 	l.addi r3,r3,0x0
 9dc:	15 00 00 02 	l.nop 0x2
 9e0:	84 41 00 00 	l.lwz r2,0x0(r1)
 9e4:	44 00 48 00 	l.jr r9
 9e8:	9c 21 00 04 	l.addi r1,r1,0x4

000009ec <___main>:
 9ec:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 9f0:	d4 01 10 00 	l.sw 0x0(r1),r2
 9f4:	9c 41 00 04 	l.addi r2,r1,0x4
 9f8:	84 41 00 00 	l.lwz r2,0x0(r1)
 9fc:	44 00 48 00 	l.jr r9
 a00:	9c 21 00 04 	l.addi r1,r1,0x4

00000a04 <_start_timer>:
 a04:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 a08:	d4 01 10 00 	l.sw 0x0(r1),r2
 a0c:	9c 41 00 04 	l.addi r2,r1,0x4
 a10:	84 41 00 00 	l.lwz r2,0x0(r1)
 a14:	44 00 48 00 	l.jr r9
 a18:	9c 21 00 04 	l.addi r1,r1,0x4

00000a1c <_read_timer>:
 a1c:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 a20:	d4 01 10 00 	l.sw 0x0(r1),r2
 a24:	9c 41 00 04 	l.addi r2,r1,0x4
 a28:	9d 60 00 00 	l.addi r11,r0,0x0
 a2c:	84 41 00 00 	l.lwz r2,0x0(r1)
 a30:	44 00 48 00 	l.jr r9
 a34:	9c 21 00 04 	l.addi r1,r1,0x4

00000a38 <_mtspr>:
 a38:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 a3c:	d4 01 10 00 	l.sw 0x0(r1),r2
 a40:	9c 41 00 04 	l.addi r2,r1,0x4
 a44:	c0 03 20 00 	l.mtspr r3,r4,0x0
 a48:	84 41 00 00 	l.lwz r2,0x0(r1)
 a4c:	44 00 48 00 	l.jr r9
 a50:	9c 21 00 04 	l.addi r1,r1,0x4

00000a54 <_mfspr>:
 a54:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 a58:	d4 01 10 00 	l.sw 0x0(r1),r2
 a5c:	9c 41 00 04 	l.addi r2,r1,0x4
 a60:	b5 63 00 00 	l.mfspr r11,r3,0x0
 a64:	84 41 00 00 	l.lwz r2,0x0(r1)
 a68:	44 00 48 00 	l.jr r9
 a6c:	9c 21 00 04 	l.addi r1,r1,0x4

00000a70 <_memcpy>:
 a70:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 a74:	d4 01 10 00 	l.sw 0x0(r1),r2
 a78:	9c 41 00 04 	l.addi r2,r1,0x4
 a7c:	00 00 00 07 	l.j a98 <_memcpy+0x28>
 a80:	9c a5 ff ff 	l.addi r5,r5,0xffffffff
 a84:	8c c4 00 00 	l.lbz r6,0x0(r4)
 a88:	9c a5 ff ff 	l.addi r5,r5,0xffffffff
 a8c:	d8 03 30 00 	l.sb 0x0(r3),r6
 a90:	9c 84 00 01 	l.addi r4,r4,0x1
 a94:	9c 63 00 01 	l.addi r3,r3,0x1
 a98:	bc 05 ff ff 	l.sfeqi r5,0xffffffff
 a9c:	0f ff ff fa 	l.bnf a84 <_memcpy+0x14>
 aa0:	a9 63 00 00 	l.ori r11,r3,0x0
 aa4:	84 41 00 00 	l.lwz r2,0x0(r1)
 aa8:	44 00 48 00 	l.jr r9
 aac:	9c 21 00 04 	l.addi r1,r1,0x4

00000ab0 <_excpt_dummy>:
 ab0:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 ab4:	d4 01 10 00 	l.sw 0x0(r1),r2
 ab8:	9c 41 00 04 	l.addi r2,r1,0x4
 abc:	84 41 00 00 	l.lwz r2,0x0(r1)
 ac0:	44 00 48 00 	l.jr r9
 ac4:	9c 21 00 04 	l.addi r1,r1,0x4

00000ac8 <_int_init>:
 ac8:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 acc:	d4 01 10 00 	l.sw 0x0(r1),r2
 ad0:	9c 41 00 04 	l.addi r2,r1,0x4
 ad4:	18 60 00 00 	l.movhi r3,0x0
 ad8:	a8 63 0d 70 	l.ori r3,r3,0xd70
 adc:	9c 80 00 1f 	l.addi r4,r0,0x1f
 ae0:	9c a0 00 00 	l.addi r5,r0,0x0
 ae4:	9c 84 ff ff 	l.addi r4,r4,0xffffffff
 ae8:	d4 03 28 00 	l.sw 0x0(r3),r5
 aec:	d4 03 28 04 	l.sw 0x4(r3),r5
 af0:	bd 64 00 00 	l.sfgesi r4,0x0
 af4:	13 ff ff fc 	l.bf ae4 <_int_init+0x1c>
 af8:	9c 63 00 08 	l.addi r3,r3,0x8
 afc:	a9 65 00 00 	l.ori r11,r5,0x0
 b00:	84 41 00 00 	l.lwz r2,0x0(r1)
 b04:	44 00 48 00 	l.jr r9
 b08:	9c 21 00 04 	l.addi r1,r1,0x4

00000b0c <_int_add>:
 b0c:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
 b10:	d4 01 10 04 	l.sw 0x4(r1),r2
 b14:	9c 41 00 0c 	l.addi r2,r1,0xc
 b18:	d4 01 48 00 	l.sw 0x0(r1),r9
 b1c:	d4 01 50 08 	l.sw 0x8(r1),r10
 b20:	b8 c3 00 03 	l.slli r6,r3,0x3
 b24:	a9 43 00 00 	l.ori r10,r3,0x0
 b28:	18 e0 00 00 	l.movhi r7,0x0
 b2c:	a8 e7 0d 70 	l.ori r7,r7,0xd70
 b30:	9c 60 48 00 	l.addi r3,r0,0x4800
 b34:	e0 c6 38 00 	l.add r6,r6,r7
 b38:	bc aa 00 1f 	l.sfleui r10,0x1f
 b3c:	0c 00 00 0b 	l.bnf b68 <_int_add+0x5c>
 b40:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
 b44:	d4 06 20 00 	l.sw 0x0(r6),r4
 b48:	07 ff ff c3 	l.jal a54 <_mfspr>
 b4c:	d4 06 28 04 	l.sw 0x4(r6),r5
 b50:	9c 80 00 01 	l.addi r4,r0,0x1
 b54:	9c 60 48 00 	l.addi r3,r0,0x4800
 b58:	e0 84 50 08 	l.sll r4,r4,r10
 b5c:	07 ff ff b7 	l.jal a38 <_mtspr>
 b60:	e0 8b 20 04 	l.or r4,r11,r4
 b64:	9d 60 00 00 	l.addi r11,r0,0x0
 b68:	85 21 00 00 	l.lwz r9,0x0(r1)
 b6c:	84 41 00 04 	l.lwz r2,0x4(r1)
 b70:	85 41 00 08 	l.lwz r10,0x8(r1)
 b74:	44 00 48 00 	l.jr r9
 b78:	9c 21 00 0c 	l.addi r1,r1,0xc

00000b7c <_int_disable>:
 b7c:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
 b80:	d4 01 10 04 	l.sw 0x4(r1),r2
 b84:	9c 41 00 0c 	l.addi r2,r1,0xc
 b88:	d4 01 48 00 	l.sw 0x0(r1),r9
 b8c:	d4 01 50 08 	l.sw 0x8(r1),r10
 b90:	a9 43 00 00 	l.ori r10,r3,0x0
 b94:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
 b98:	bc aa 00 1f 	l.sfleui r10,0x1f
 b9c:	0c 00 00 0b 	l.bnf bc8 <_int_disable+0x4c>
 ba0:	9c 60 48 00 	l.addi r3,r0,0x4800
 ba4:	07 ff ff ac 	l.jal a54 <_mfspr>
 ba8:	15 00 00 00 	l.nop 0x0
 bac:	9c 80 00 01 	l.addi r4,r0,0x1
 bb0:	9c 60 48 00 	l.addi r3,r0,0x4800
 bb4:	e0 84 50 08 	l.sll r4,r4,r10
 bb8:	ac 84 ff ff 	l.xori r4,r4,0xffffffff
 bbc:	07 ff ff 9f 	l.jal a38 <_mtspr>
 bc0:	e0 8b 20 03 	l.and r4,r11,r4
 bc4:	9d 60 00 00 	l.addi r11,r0,0x0
 bc8:	85 21 00 00 	l.lwz r9,0x0(r1)
 bcc:	84 41 00 04 	l.lwz r2,0x4(r1)
 bd0:	85 41 00 08 	l.lwz r10,0x8(r1)
 bd4:	44 00 48 00 	l.jr r9
 bd8:	9c 21 00 0c 	l.addi r1,r1,0xc

00000bdc <_int_enable>:
 bdc:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
 be0:	d4 01 10 04 	l.sw 0x4(r1),r2
 be4:	9c 41 00 0c 	l.addi r2,r1,0xc
 be8:	d4 01 48 00 	l.sw 0x0(r1),r9
 bec:	d4 01 50 08 	l.sw 0x8(r1),r10
 bf0:	a9 43 00 00 	l.ori r10,r3,0x0
 bf4:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
 bf8:	bc aa 00 1f 	l.sfleui r10,0x1f
 bfc:	0c 00 00 0a 	l.bnf c24 <_int_enable+0x48>
 c00:	9c 60 48 00 	l.addi r3,r0,0x4800
 c04:	07 ff ff 94 	l.jal a54 <_mfspr>
 c08:	15 00 00 00 	l.nop 0x0
 c0c:	9c 80 00 01 	l.addi r4,r0,0x1
 c10:	9c 60 48 00 	l.addi r3,r0,0x4800
 c14:	e0 84 50 08 	l.sll r4,r4,r10
 c18:	07 ff ff 88 	l.jal a38 <_mtspr>
 c1c:	e0 8b 20 04 	l.or r4,r11,r4
 c20:	9d 60 00 00 	l.addi r11,r0,0x0
 c24:	85 21 00 00 	l.lwz r9,0x0(r1)
 c28:	84 41 00 04 	l.lwz r2,0x4(r1)
 c2c:	85 41 00 08 	l.lwz r10,0x8(r1)
 c30:	44 00 48 00 	l.jr r9
 c34:	9c 21 00 0c 	l.addi r1,r1,0xc

00000c38 <_int_main>:
 c38:	9c 21 ff e4 	l.addi r1,r1,0xffffffe4
 c3c:	d4 01 10 04 	l.sw 0x4(r1),r2
 c40:	9c 41 00 1c 	l.addi r2,r1,0x1c
 c44:	d4 01 48 00 	l.sw 0x0(r1),r9
 c48:	d4 01 50 08 	l.sw 0x8(r1),r10
 c4c:	d4 01 60 0c 	l.sw 0xc(r1),r12
 c50:	d4 01 70 10 	l.sw 0x10(r1),r14
 c54:	d4 01 80 14 	l.sw 0x14(r1),r16
 c58:	d4 01 90 18 	l.sw 0x18(r1),r18
 c5c:	9c 60 48 02 	l.addi r3,r0,0x4802
 c60:	07 ff ff 7d 	l.jal a54 <_mfspr>
 c64:	9d 80 00 00 	l.addi r12,r0,0x0
 c68:	aa 0b 00 00 	l.ori r16,r11,0x0
 c6c:	9c 60 48 02 	l.addi r3,r0,0x4802
 c70:	a8 8c 00 00 	l.ori r4,r12,0x0
 c74:	19 c0 00 00 	l.movhi r14,0x0
 c78:	a9 ce 0d 70 	l.ori r14,r14,0xd70
 c7c:	07 ff ff 6f 	l.jal a38 <_mtspr>
 c80:	9e 40 00 01 	l.addi r18,r0,0x1
 c84:	e1 52 60 08 	l.sll r10,r18,r12
 c88:	e0 6a 80 03 	l.and r3,r10,r16
 c8c:	bc 03 00 00 	l.sfeqi r3,0x0
 c90:	10 00 00 0e 	l.bf cc8 <_int_main+0x90>
 c94:	9d 8c 00 01 	l.addi r12,r12,0x1
 c98:	84 8e 00 00 	l.lwz r4,0x0(r14)
 c9c:	bc 04 00 00 	l.sfeqi r4,0x0
 ca0:	10 00 00 0b 	l.bf ccc <_int_main+0x94>
 ca4:	bc 4c 00 1f 	l.sfgtui r12,0x1f
 ca8:	48 00 20 00 	l.jalr r4
 cac:	84 6e 00 04 	l.lwz r3,0x4(r14)
 cb0:	07 ff ff 69 	l.jal a54 <_mfspr>
 cb4:	9c 60 48 02 	l.addi r3,r0,0x4802
 cb8:	ac 8a ff ff 	l.xori r4,r10,0xffffffff
 cbc:	9c 60 48 02 	l.addi r3,r0,0x4802
 cc0:	07 ff ff 5e 	l.jal a38 <_mtspr>
 cc4:	e0 8b 20 03 	l.and r4,r11,r4
 cc8:	bc 4c 00 1f 	l.sfgtui r12,0x1f
 ccc:	0f ff ff ee 	l.bnf c84 <_int_main+0x4c>
 cd0:	9d ce 00 08 	l.addi r14,r14,0x8
 cd4:	85 21 00 00 	l.lwz r9,0x0(r1)
 cd8:	84 41 00 04 	l.lwz r2,0x4(r1)
 cdc:	85 41 00 08 	l.lwz r10,0x8(r1)
 ce0:	85 81 00 0c 	l.lwz r12,0xc(r1)
 ce4:	85 c1 00 10 	l.lwz r14,0x10(r1)
 ce8:	86 01 00 14 	l.lwz r16,0x14(r1)
 cec:	86 41 00 18 	l.lwz r18,0x18(r1)
 cf0:	44 00 48 00 	l.jr r9
 cf4:	9c 21 00 1c 	l.addi r1,r1,0x1c
Disassembly of section .rodata:

00000cf8 <.rodata>:
 cf8:	54 68 69 73 	.word 0x54686973
 cfc:	20 74 65 73 	.word 0x20746573
 d00:	74 20 73 74 	l.cust2 
 d04:	72 69 6e 67 	l.cust1 
 d08:	20 4d 55 53 	.word 0x204d5553
 d0c:	54 20 4e 4f 	.word 0x54204e4f
 d10:	54 20 62 65 	.word 0x54206265
 d14:	20 6d 6f 64 	.word 0x206d6f64
 d18:	69 66 69 65 	.word 0x69666965
 d1c:	64 2e 2e 2e 	.word 0x642e2e2e
 d20:	00 52 45 53 	l.j 149226c <_src_addr+0x14813fc>
 d24:	55 4c 54 3a 	.word 0x554c543a
 d28:	20 25 2e 38 	.word 0x20252e38
 d2c:	6c 78 0a 00 	.word 0x6c780a00
Disassembly of section .data:

00000d30 <_dst_beg>:
 d30:	00 00 0a b0 	l.j 37f0 <_int_handlers+0x2a80>

00000d34 <_excpt_break>:
 d34:	00 00 0a b0 	l.j 37f4 <_int_handlers+0x2a84>

00000d38 <_excpt_syscall>:
 d38:	00 00 0a b0 	l.j 37f8 <_int_handlers+0x2a88>

00000d3c <_excpt_range>:
 d3c:	00 00 0a b0 	l.j 37fc <_int_handlers+0x2a8c>

00000d40 <_excpt_itlbmiss>:
 d40:	00 00 0a b0 	l.j 3800 <_int_handlers+0x2a90>

00000d44 <_excpt_dtlbmiss>:
 d44:	00 00 0a b0 	l.j 3804 <_int_handlers+0x2a94>

00000d48 <_excpt_int>:
 d48:	00 00 0c 38 	l.j 3e28 <_int_handlers+0x30b8>

00000d4c <_excpt_illinsn>:
 d4c:	00 00 0a b0 	l.j 380c <_int_handlers+0x2a9c>

00000d50 <_excpt_align>:
 d50:	00 00 0a b0 	l.j 3810 <_int_handlers+0x2aa0>

00000d54 <_excpt_tick>:
 d54:	00 00 0a b0 	l.j 3814 <_int_handlers+0x2aa4>

00000d58 <_excpt_ipfault>:
 d58:	00 00 0a b0 	l.j 3818 <_int_handlers+0x2aa8>

00000d5c <_excpt_dpfault>:
 d5c:	00 00 0a b0 	l.j 381c <_int_handlers+0x2aac>

00000d60 <_excpt_buserr>:
 d60:	00 00 0a b0 	l.j 3820 <_int_handlers+0x2ab0>
Disassembly of section .bss:

00000d70 <_int_handlers>:
	...
Disassembly of section .stack:

00000e70 <_src_addr-0x10000>:
	...
Disassembly of section .comment:

00000000 <.comment>:
   0:	00 47 43 43 	l.j 11d0d0c <_src_addr+0x11bfe9c>
   4:	3a 20 28 47 	.word 0x3a202847
   8:	4e 55 29 20 	l.maci r21,0xffff9120
   c:	33 2e 34 2e 	.word 0x332e342e
  10:	34 00 00 47 	.word 0x34000047
  14:	43 43 3a 20 	.word 0x43433a20
  18:	28 47 4e 55 	lv.max.b r2,r7,r9
  1c:	29 20 33 2e 	.word 0x2920332e
  20:	34 2e 34 00 	.word 0x342e3400
  24:	00 47 43 43 	l.j 11d0d30 <_src_addr+0x11bfec0>
  28:	3a 20 28 47 	.word 0x3a202847
  2c:	4e 55 29 20 	l.maci r21,0xffff9120
  30:	33 2e 34 2e 	.word 0x332e342e
  34:	Address 0x00000034 is out of bounds.

