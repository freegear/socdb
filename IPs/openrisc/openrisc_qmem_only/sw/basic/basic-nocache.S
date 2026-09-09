
basic-nocache.or32:     file format elf32-or32

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
 194:	a8 63 06 f8 	l.ori r3,r3,0x6f8
 198:	44 00 18 00 	l.jr r3
 19c:	15 00 00 00 	l.nop 0x0
Disassembly of section .text:

000001a0 <_align_except>:
 1a0:	15 00 00 00 	l.nop 0x0
 1a4:	00 00 00 02 	l.j 1ac <_regs>
 1a8:	15 00 00 00 	l.nop 0x0

000001ac <_regs>:
 1ac:	9c 20 00 01 	l.addi r1,r0,0x1
 1b0:	9c 41 00 02 	l.addi r2,r1,0x2
 1b4:	9c 62 00 04 	l.addi r3,r2,0x4
 1b8:	9c 83 00 08 	l.addi r4,r3,0x8
 1bc:	9c a4 00 10 	l.addi r5,r4,0x10
 1c0:	9c c5 00 20 	l.addi r6,r5,0x20
 1c4:	9c e6 00 40 	l.addi r7,r6,0x40
 1c8:	9d 07 00 80 	l.addi r8,r7,0x80
 1cc:	9d 28 01 00 	l.addi r9,r8,0x100
 1d0:	9d 49 02 00 	l.addi r10,r9,0x200
 1d4:	9d 6a 04 00 	l.addi r11,r10,0x400
 1d8:	9d 8b 08 00 	l.addi r12,r11,0x800
 1dc:	9d ac 10 00 	l.addi r13,r12,0x1000
 1e0:	9d cd 20 00 	l.addi r14,r13,0x2000
 1e4:	9d ee 40 00 	l.addi r15,r14,0x4000
 1e8:	9e 0f 80 00 	l.addi r16,r15,0xffff8000
 1ec:	e3 e0 08 02 	l.sub r31,r0,r1
 1f0:	e3 df 10 02 	l.sub r30,r31,r2
 1f4:	e3 be 18 02 	l.sub r29,r30,r3
 1f8:	e3 9d 20 02 	l.sub r28,r29,r4
 1fc:	e3 7c 28 02 	l.sub r27,r28,r5
 200:	e3 5b 30 02 	l.sub r26,r27,r6
 204:	e3 3a 38 02 	l.sub r25,r26,r7
 208:	e3 19 40 02 	l.sub r24,r25,r8
 20c:	e2 f8 48 02 	l.sub r23,r24,r9
 210:	e2 d7 50 02 	l.sub r22,r23,r10
 214:	e2 b6 58 02 	l.sub r21,r22,r11
 218:	e2 95 60 02 	l.sub r20,r21,r12
 21c:	e2 74 68 02 	l.sub r19,r20,r13
 220:	e2 53 70 02 	l.sub r18,r19,r14
 224:	e2 32 78 02 	l.sub r17,r18,r15
 228:	e2 11 80 02 	l.sub r16,r17,r16
 22c:	1b e0 00 00 	l.movhi r31,0x0
 230:	ab ff 00 40 	l.ori r31,r31,0x40
 234:	c0 40 82 34 	l.mtspr r0,r16,0x1234
 238:	d4 1f 80 00 	l.sw 0x0(r31),r16

0000023c <_mem>:
 23c:	18 60 12 34 	l.movhi r3,0x1234
 240:	a8 63 56 78 	l.ori r3,r3,0x5678
 244:	d4 1f 18 04 	l.sw 0x4(r31),r3
 248:	8c 9f 00 04 	l.lbz r4,0x4(r31)
 24c:	e1 08 20 00 	l.add r8,r8,r4
 250:	d8 1f 20 0b 	l.sb 0xb(r31),r4
 254:	8c 9f 00 05 	l.lbz r4,0x5(r31)
 258:	e1 08 20 00 	l.add r8,r8,r4
 25c:	d8 1f 20 0a 	l.sb 0xa(r31),r4
 260:	8c 9f 00 06 	l.lbz r4,0x6(r31)
 264:	e1 08 20 00 	l.add r8,r8,r4
 268:	d8 1f 20 09 	l.sb 0x9(r31),r4
 26c:	8c 9f 00 07 	l.lbz r4,0x7(r31)
 270:	e1 08 20 00 	l.add r8,r8,r4
 274:	d8 1f 20 08 	l.sb 0x8(r31),r4
 278:	90 9f 00 08 	l.lbs r4,0x8(r31)
 27c:	e1 08 20 00 	l.add r8,r8,r4
 280:	d8 1f 20 07 	l.sb 0x7(r31),r4
 284:	90 9f 00 09 	l.lbs r4,0x9(r31)
 288:	e1 08 20 00 	l.add r8,r8,r4
 28c:	d8 1f 20 06 	l.sb 0x6(r31),r4
 290:	90 9f 00 0a 	l.lbs r4,0xa(r31)
 294:	e1 08 20 00 	l.add r8,r8,r4
 298:	d8 1f 20 05 	l.sb 0x5(r31),r4
 29c:	90 9f 00 0b 	l.lbs r4,0xb(r31)
 2a0:	e1 08 20 00 	l.add r8,r8,r4
 2a4:	d8 1f 20 04 	l.sb 0x4(r31),r4
 2a8:	94 9f 00 04 	l.lhz r4,0x4(r31)
 2ac:	e1 08 20 00 	l.add r8,r8,r4
 2b0:	dc 1f 20 0a 	l.sh 0xa(r31),r4
 2b4:	94 9f 00 06 	l.lhz r4,0x6(r31)
 2b8:	e1 08 20 00 	l.add r8,r8,r4
 2bc:	dc 1f 20 08 	l.sh 0x8(r31),r4
 2c0:	98 9f 00 08 	l.lhs r4,0x8(r31)
 2c4:	e1 08 20 00 	l.add r8,r8,r4
 2c8:	dc 1f 20 06 	l.sh 0x6(r31),r4
 2cc:	98 9f 00 0a 	l.lhs r4,0xa(r31)
 2d0:	e1 08 20 00 	l.add r8,r8,r4
 2d4:	dc 1f 20 04 	l.sh 0x4(r31),r4
 2d8:	84 9f 00 04 	l.lwz r4,0x4(r31)
 2dc:	e1 08 20 00 	l.add r8,r8,r4
 2e0:	c0 40 42 34 	l.mtspr r0,r8,0x1234
 2e4:	85 3f 00 00 	l.lwz r9,0x0(r31)
 2e8:	e1 09 40 00 	l.add r8,r9,r8
 2ec:	d4 1f 40 00 	l.sw 0x0(r31),r8

000002f0 <_arith>:
 2f0:	9c 60 00 01 	l.addi r3,r0,0x1
 2f4:	9c 80 00 02 	l.addi r4,r0,0x2
 2f8:	9c a0 ff ff 	l.addi r5,r0,0xffffffff
 2fc:	9c c0 ff ff 	l.addi r6,r0,0xffffffff
 300:	9d 00 00 00 	l.addi r8,r0,0x0
 304:	e0 e5 18 02 	l.sub r7,r5,r3
 308:	e1 03 28 02 	l.sub r8,r3,r5
 30c:	e1 08 38 00 	l.add r8,r8,r7
 310:	e1 23 20 00 	l.add r9,r3,r4
 314:	e0 e9 3b 06 	l.mul r7,r9,r7
 318:	e1 08 38 00 	l.add r8,r8,r7
 31c:	c0 40 42 34 	l.mtspr r0,r8,0x1234
 320:	85 3f 00 00 	l.lwz r9,0x0(r31)
 324:	e1 09 40 00 	l.add r8,r9,r8
 328:	d4 1f 40 00 	l.sw 0x0(r31),r8

0000032c <_log>:
 32c:	9c 60 00 01 	l.addi r3,r0,0x1
 330:	9c 80 00 02 	l.addi r4,r0,0x2
 334:	9c a0 ff ff 	l.addi r5,r0,0xffffffff
 338:	9c c0 ff ff 	l.addi r6,r0,0xffffffff
 33c:	9d 00 00 00 	l.addi r8,r0,0x0
 340:	a5 08 00 01 	l.andi r8,r8,0x1
 344:	e1 08 18 03 	l.and r8,r8,r3
 348:	ad 05 a5 a5 	l.xori r8,r5,0xffffa5a5
 34c:	e1 08 28 05 	l.xor r8,r8,r5
 350:	a9 08 00 02 	l.ori r8,r8,0x2
 354:	e1 08 20 04 	l.or r8,r8,r4
 358:	c0 40 42 34 	l.mtspr r0,r8,0x1234
 35c:	85 3f 00 00 	l.lwz r9,0x0(r31)
 360:	e1 09 40 00 	l.add r8,r9,r8
 364:	d4 1f 40 00 	l.sw 0x0(r31),r8

00000368 <_shift>:
 368:	9c 60 00 01 	l.addi r3,r0,0x1
 36c:	9c 80 00 02 	l.addi r4,r0,0x2
 370:	9c a0 ff ff 	l.addi r5,r0,0xffffffff
 374:	9c c0 ff ff 	l.addi r6,r0,0xffffffff
 378:	9d 00 00 00 	l.addi r8,r0,0x0
 37c:	b9 05 00 06 	l.slli r8,r5,0x6
 380:	e1 08 20 08 	l.sll r8,r8,r4
 384:	b9 08 00 46 	l.srli r8,r8,0x6
 388:	e1 08 20 48 	l.srl r8,r8,r4
 38c:	b9 08 00 82 	l.srai r8,r8,0x2
 390:	e1 08 20 88 	l.sra r8,r8,r4
 394:	c0 40 42 34 	l.mtspr r0,r8,0x1234
 398:	85 3f 00 00 	l.lwz r9,0x0(r31)
 39c:	e1 09 40 00 	l.add r8,r9,r8
 3a0:	d4 1f 40 00 	l.sw 0x0(r31),r8

000003a4 <_flag>:
 3a4:	9c 60 00 01 	l.addi r3,r0,0x1
 3a8:	9c 80 ff fe 	l.addi r4,r0,0xfffffffe
 3ac:	9d 00 00 00 	l.addi r8,r0,0x0
 3b0:	e4 03 18 00 	l.sfeq r3,r3
 3b4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 3b8:	a4 85 02 00 	l.andi r4,r5,0x200
 3bc:	e1 08 20 00 	l.add r8,r8,r4
 3c0:	e4 03 20 00 	l.sfeq r3,r4
 3c4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 3c8:	a4 85 02 00 	l.andi r4,r5,0x200
 3cc:	e1 08 20 00 	l.add r8,r8,r4
 3d0:	bc 03 00 01 	l.sfeqi r3,0x1
 3d4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 3d8:	a4 85 02 00 	l.andi r4,r5,0x200
 3dc:	e1 08 20 00 	l.add r8,r8,r4
 3e0:	bc 03 ff fe 	l.sfeqi r3,0xfffffffe
 3e4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 3e8:	a4 85 02 00 	l.andi r4,r5,0x200
 3ec:	e1 08 20 00 	l.add r8,r8,r4
 3f0:	e4 23 18 00 	l.sfne r3,r3
 3f4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 3f8:	a4 85 02 00 	l.andi r4,r5,0x200
 3fc:	e1 08 20 00 	l.add r8,r8,r4
 400:	e4 23 20 00 	l.sfne r3,r4
 404:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 408:	a4 85 02 00 	l.andi r4,r5,0x200
 40c:	e1 08 20 00 	l.add r8,r8,r4
 410:	bc 23 00 01 	l.sfnei r3,0x1
 414:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 418:	a4 85 02 00 	l.andi r4,r5,0x200
 41c:	e1 08 20 00 	l.add r8,r8,r4
 420:	bc 23 ff fe 	l.sfnei r3,0xfffffffe
 424:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 428:	a4 85 02 00 	l.andi r4,r5,0x200
 42c:	e1 08 20 00 	l.add r8,r8,r4
 430:	e4 43 18 00 	l.sfgtu r3,r3
 434:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 438:	a4 85 02 00 	l.andi r4,r5,0x200
 43c:	e1 08 20 00 	l.add r8,r8,r4
 440:	e4 43 20 00 	l.sfgtu r3,r4
 444:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 448:	a4 85 02 00 	l.andi r4,r5,0x200
 44c:	e1 08 20 00 	l.add r8,r8,r4
 450:	bc 43 00 01 	l.sfgtui r3,0x1
 454:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 458:	a4 85 02 00 	l.andi r4,r5,0x200
 45c:	e1 08 20 00 	l.add r8,r8,r4
 460:	bc 43 ff fe 	l.sfgtui r3,0xfffffffe
 464:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 468:	a4 85 02 00 	l.andi r4,r5,0x200
 46c:	e1 08 20 00 	l.add r8,r8,r4
 470:	e4 63 18 00 	l.sfgeu r3,r3
 474:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 478:	a4 85 02 00 	l.andi r4,r5,0x200
 47c:	e1 08 20 00 	l.add r8,r8,r4
 480:	e4 63 20 00 	l.sfgeu r3,r4
 484:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 488:	a4 85 02 00 	l.andi r4,r5,0x200
 48c:	e1 08 20 00 	l.add r8,r8,r4
 490:	bc 63 00 01 	l.sfgeui r3,0x1
 494:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 498:	a4 85 02 00 	l.andi r4,r5,0x200
 49c:	e1 08 20 00 	l.add r8,r8,r4
 4a0:	bc 63 ff fe 	l.sfgeui r3,0xfffffffe
 4a4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 4a8:	a4 85 02 00 	l.andi r4,r5,0x200
 4ac:	e1 08 20 00 	l.add r8,r8,r4
 4b0:	e4 83 18 00 	l.sfltu r3,r3
 4b4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 4b8:	a4 85 02 00 	l.andi r4,r5,0x200
 4bc:	e1 08 20 00 	l.add r8,r8,r4
 4c0:	e4 83 20 00 	l.sfltu r3,r4
 4c4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 4c8:	a4 85 02 00 	l.andi r4,r5,0x200
 4cc:	e1 08 20 00 	l.add r8,r8,r4
 4d0:	bc 83 00 01 	l.sfltui r3,0x1
 4d4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 4d8:	a4 85 02 00 	l.andi r4,r5,0x200
 4dc:	e1 08 20 00 	l.add r8,r8,r4
 4e0:	bc 83 ff fe 	l.sfltui r3,0xfffffffe
 4e4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 4e8:	a4 85 02 00 	l.andi r4,r5,0x200
 4ec:	e1 08 20 00 	l.add r8,r8,r4
 4f0:	e4 a3 18 00 	l.sfleu r3,r3
 4f4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 4f8:	a4 85 02 00 	l.andi r4,r5,0x200
 4fc:	e1 08 20 00 	l.add r8,r8,r4
 500:	e4 a3 20 00 	l.sfleu r3,r4
 504:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 508:	a4 85 02 00 	l.andi r4,r5,0x200
 50c:	e1 08 20 00 	l.add r8,r8,r4
 510:	bc a3 00 01 	l.sfleui r3,0x1
 514:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 518:	a4 85 02 00 	l.andi r4,r5,0x200
 51c:	e1 08 20 00 	l.add r8,r8,r4
 520:	bc a3 ff fe 	l.sfleui r3,0xfffffffe
 524:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 528:	a4 85 02 00 	l.andi r4,r5,0x200
 52c:	e1 08 20 00 	l.add r8,r8,r4
 530:	e5 43 18 00 	l.sfgts r3,r3
 534:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 538:	a4 85 02 00 	l.andi r4,r5,0x200
 53c:	e1 08 20 00 	l.add r8,r8,r4
 540:	e5 43 20 00 	l.sfgts r3,r4
 544:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 548:	a4 85 02 00 	l.andi r4,r5,0x200
 54c:	e1 08 20 00 	l.add r8,r8,r4
 550:	bd 43 00 01 	l.sfgtsi r3,0x1
 554:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 558:	a4 85 02 00 	l.andi r4,r5,0x200
 55c:	e1 08 20 00 	l.add r8,r8,r4
 560:	bd 43 ff fe 	l.sfgtsi r3,0xfffffffe
 564:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 568:	a4 85 02 00 	l.andi r4,r5,0x200
 56c:	e1 08 20 00 	l.add r8,r8,r4
 570:	e5 63 18 00 	l.sfges r3,r3
 574:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 578:	a4 85 02 00 	l.andi r4,r5,0x200
 57c:	e1 08 20 00 	l.add r8,r8,r4
 580:	e5 63 20 00 	l.sfges r3,r4
 584:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 588:	a4 85 02 00 	l.andi r4,r5,0x200
 58c:	e1 08 20 00 	l.add r8,r8,r4
 590:	bd 63 00 01 	l.sfgesi r3,0x1
 594:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 598:	a4 85 02 00 	l.andi r4,r5,0x200
 59c:	e1 08 20 00 	l.add r8,r8,r4
 5a0:	bd 63 ff fe 	l.sfgesi r3,0xfffffffe
 5a4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 5a8:	a4 85 02 00 	l.andi r4,r5,0x200
 5ac:	e1 08 20 00 	l.add r8,r8,r4
 5b0:	e5 83 18 00 	l.sflts r3,r3
 5b4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 5b8:	a4 85 02 00 	l.andi r4,r5,0x200
 5bc:	e1 08 20 00 	l.add r8,r8,r4
 5c0:	e5 83 20 00 	l.sflts r3,r4
 5c4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 5c8:	a4 85 02 00 	l.andi r4,r5,0x200
 5cc:	e1 08 20 00 	l.add r8,r8,r4
 5d0:	bd 83 00 01 	l.sfltsi r3,0x1
 5d4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 5d8:	a4 85 02 00 	l.andi r4,r5,0x200
 5dc:	e1 08 20 00 	l.add r8,r8,r4
 5e0:	bd 83 ff fe 	l.sfltsi r3,0xfffffffe
 5e4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 5e8:	a4 85 02 00 	l.andi r4,r5,0x200
 5ec:	e1 08 20 00 	l.add r8,r8,r4
 5f0:	e5 a3 18 00 	l.sfles r3,r3
 5f4:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 5f8:	a4 85 02 00 	l.andi r4,r5,0x200
 5fc:	e1 08 20 00 	l.add r8,r8,r4
 600:	e5 a3 20 00 	l.sfles r3,r4
 604:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 608:	a4 85 02 00 	l.andi r4,r5,0x200
 60c:	e1 08 20 00 	l.add r8,r8,r4
 610:	bd a3 00 01 	l.sflesi r3,0x1
 614:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 618:	a4 85 02 00 	l.andi r4,r5,0x200
 61c:	e1 08 20 00 	l.add r8,r8,r4
 620:	bd a3 ff fe 	l.sflesi r3,0xfffffffe
 624:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 628:	a4 85 02 00 	l.andi r4,r5,0x200
 62c:	e1 08 20 00 	l.add r8,r8,r4
 630:	c0 40 42 34 	l.mtspr r0,r8,0x1234
 634:	85 3f 00 00 	l.lwz r9,0x0(r31)
 638:	e1 09 40 00 	l.add r8,r9,r8
 63c:	d4 1f 40 00 	l.sw 0x0(r31),r8

00000640 <_jump>:
 640:	9d 00 00 00 	l.addi r8,r0,0x0
 644:	00 00 00 05 	l.j 658 <_T1>
 648:	9d 08 00 01 	l.addi r8,r8,0x1

0000064c <_T2>:
 64c:	e1 40 48 04 	l.or r10,r0,r9
 650:	48 00 50 00 	l.jalr r10
 654:	9d 08 00 01 	l.addi r8,r8,0x1

00000658 <_T1>:
 658:	07 ff ff fd 	l.jal 64c <_T2>
 65c:	9d 08 00 01 	l.addi r8,r8,0x1
 660:	bc 00 00 00 	l.sfeqi r0,0x0
 664:	10 00 00 02 	l.bf 66c <_T3>
 668:	9d 08 00 01 	l.addi r8,r8,0x1

0000066c <_T3>:
 66c:	bc 00 00 01 	l.sfeqi r0,0x1
 670:	10 00 00 03 	l.bf 67c <_T4>
 674:	9d 08 00 01 	l.addi r8,r8,0x1
 678:	9d 08 00 01 	l.addi r8,r8,0x1

0000067c <_T4>:
 67c:	bc 00 00 00 	l.sfeqi r0,0x0
 680:	0c 00 00 03 	l.bnf 68c <_T5>
 684:	9d 08 00 01 	l.addi r8,r8,0x1
 688:	9d 08 00 01 	l.addi r8,r8,0x1

0000068c <_T5>:
 68c:	bc 00 00 01 	l.sfeqi r0,0x1
 690:	0c 00 00 03 	l.bnf 69c <_T6>
 694:	9d 08 00 01 	l.addi r8,r8,0x1
 698:	9d 08 00 01 	l.addi r8,r8,0x1

0000069c <_T6>:
 69c:	18 60 00 00 	l.movhi r3,0x0
 6a0:	a8 63 06 bc 	l.ori r3,r3,0x6bc
 6a4:	c0 00 18 20 	l.mtspr r0,r3,0x20
 6a8:	b4 a0 00 11 	l.mfspr r5,r0,0x11
 6ac:	c0 00 28 40 	l.mtspr r0,r5,0x40
 6b0:	24 00 00 00 	l.rfe 
 6b4:	9d 08 00 01 	l.addi r8,r8,0x1
 6b8:	9d 08 00 01 	l.addi r8,r8,0x1

000006bc <_T7>:
 6bc:	c0 40 42 34 	l.mtspr r0,r8,0x1234
 6c0:	85 3f 00 00 	l.lwz r9,0x0(r31)
 6c4:	e1 09 40 00 	l.add r8,r9,r8
 6c8:	d4 1f 40 00 	l.sw 0x0(r31),r8
 6cc:	85 3f 00 00 	l.lwz r9,0x0(r31)
 6d0:	18 60 cc 69 	l.movhi r3,0xcc69
 6d4:	a8 63 e5 fb 	l.ori r3,r3,0xe5fb
 6d8:	e0 68 18 00 	l.add r3,r8,r3
 6dc:	18 20 00 00 	l.movhi r1,0x0
 6e0:	a8 21 1c a0 	l.ori r1,r1,0x1ca0
 6e4:	04 00 00 55 	l.jal 838 <_report>
 6e8:	15 00 00 00 	l.nop 0x0
 6ec:	04 00 00 32 	l.jal 7b4 <_exit>
 6f0:	15 00 00 00 	l.nop 0x0
 6f4:	15 00 00 00 	l.nop 0x0

000006f8 <_start>:
 6f8:	15 00 00 00 	l.nop 0x0
 6fc:	9c 60 00 00 	l.addi r3,r0,0x0
 700:	9c 80 00 00 	l.addi r4,r0,0x0
 704:	18 20 00 01 	l.movhi r1,0x1
 708:	a8 21 1c a0 	l.ori r1,r1,0x1ca0
 70c:	18 40 00 00 	l.movhi r2,0x0
 710:	a8 42 07 dc 	l.ori r2,r2,0x7dc
 714:	44 00 10 00 	l.jr r2
 718:	15 00 00 00 	l.nop 0x0

0000071c <_init_mc>:
 71c:	18 60 60 00 	l.movhi r3,0x6000
 720:	a8 63 00 00 	l.ori r3,r3,0x0
 724:	9c 83 00 10 	l.addi r4,r3,0x10
 728:	18 a0 04 00 	l.movhi r5,0x400
 72c:	b8 a5 00 86 	l.srai r5,r5,0x6
 730:	a8 a5 00 25 	l.ori r5,r5,0x25
 734:	d4 04 28 00 	l.sw 0x0(r4),r5
 738:	9c 83 00 14 	l.addi r4,r3,0x14
 73c:	18 a0 19 22 	l.movhi r5,0x1922
 740:	a8 a5 00 57 	l.ori r5,r5,0x57
 744:	d4 04 28 00 	l.sw 0x0(r4),r5
 748:	9c 83 00 08 	l.addi r4,r3,0x8
 74c:	9c a0 03 ff 	l.addi r5,r0,0x3ff
 750:	d4 04 28 00 	l.sw 0x0(r4),r5
 754:	9c 83 00 00 	l.addi r4,r3,0x0
 758:	18 a0 0b 00 	l.movhi r5,0xb00
 75c:	a8 a5 03 00 	l.ori r5,r5,0x300
 760:	d4 04 28 00 	l.sw 0x0(r4),r5
 764:	9c 83 00 1c 	l.addi r4,r3,0x1c
 768:	18 a0 00 00 	l.movhi r5,0x0
 76c:	a8 a5 01 03 	l.ori r5,r5,0x103
 770:	d4 04 28 00 	l.sw 0x0(r4),r5
 774:	9c 83 00 18 	l.addi r4,r3,0x18
 778:	18 a0 00 00 	l.movhi r5,0x0
 77c:	b8 a5 00 86 	l.srai r5,r5,0x6
 780:	a8 a5 04 11 	l.ori r5,r5,0x411
 784:	d4 04 28 00 	l.sw 0x0(r4),r5
 788:	9c 83 00 24 	l.addi r4,r3,0x24
 78c:	18 a0 00 00 	l.movhi r5,0x0
 790:	a8 a5 01 03 	l.ori r5,r5,0x103
 794:	d4 04 28 00 	l.sw 0x0(r4),r5
 798:	9c 83 00 20 	l.addi r4,r3,0x20
 79c:	18 a0 00 80 	l.movhi r5,0x80
 7a0:	b8 a5 00 86 	l.srai r5,r5,0x6
 7a4:	a8 a5 04 11 	l.ori r5,r5,0x411
 7a8:	d4 04 28 00 	l.sw 0x0(r4),r5
 7ac:	44 00 48 00 	l.jr r9
 7b0:	15 00 00 00 	l.nop 0x0

000007b4 <_exit>:
 7b4:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 7b8:	d4 01 10 00 	l.sw 0x0(r1),r2
 7bc:	9c 41 00 04 	l.addi r2,r1,0x4
 7c0:	e0 60 18 00 	l.add r3,r0,r3
 7c4:	15 00 00 01 	l.nop 0x1
 7c8:	00 00 00 00 	l.j 7c8 <_exit+0x14>
 7cc:	15 00 00 00 	l.nop 0x0
 7d0:	84 41 00 00 	l.lwz r2,0x0(r1)
 7d4:	44 00 48 00 	l.jr r9
 7d8:	9c 21 00 04 	l.addi r1,r1,0x4

000007dc <_reset>:
 7dc:	9c 21 ff f8 	l.addi r1,r1,0xfffffff8
 7e0:	d4 01 10 04 	l.sw 0x4(r1),r2
 7e4:	9c 41 00 08 	l.addi r2,r1,0x8
 7e8:	d4 01 48 00 	l.sw 0x0(r1),r9
 7ec:	07 ff fe 6d 	l.jal 1a0 <_align_except>
 7f0:	15 00 00 00 	l.nop 0x0
 7f4:	07 ff ff f0 	l.jal 7b4 <_exit>
 7f8:	a8 6b 00 00 	l.ori r3,r11,0x0
 7fc:	85 21 00 00 	l.lwz r9,0x0(r1)
 800:	84 41 00 04 	l.lwz r2,0x4(r1)
 804:	44 00 48 00 	l.jr r9
 808:	9c 21 00 08 	l.addi r1,r1,0x8

0000080c <_printf>:
 80c:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 810:	d4 01 10 00 	l.sw 0x0(r1),r2
 814:	9c 41 00 04 	l.addi r2,r1,0x4
 818:	84 82 00 00 	l.lwz r4,0x0(r2)
 81c:	9c 62 00 04 	l.addi r3,r2,0x4
 820:	9c 64 00 00 	l.addi r3,r4,0x0
 824:	9c 83 00 00 	l.addi r4,r3,0x0
 828:	15 00 00 03 	l.nop 0x3
 82c:	84 41 00 00 	l.lwz r2,0x0(r1)
 830:	44 00 48 00 	l.jr r9
 834:	9c 21 00 04 	l.addi r1,r1,0x4

00000838 <_report>:
 838:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 83c:	d4 01 10 00 	l.sw 0x0(r1),r2
 840:	9c 41 00 04 	l.addi r2,r1,0x4
 844:	9c 63 00 00 	l.addi r3,r3,0x0
 848:	15 00 00 02 	l.nop 0x2
 84c:	84 41 00 00 	l.lwz r2,0x0(r1)
 850:	44 00 48 00 	l.jr r9
 854:	9c 21 00 04 	l.addi r1,r1,0x4

00000858 <___main>:
 858:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 85c:	d4 01 10 00 	l.sw 0x0(r1),r2
 860:	9c 41 00 04 	l.addi r2,r1,0x4
 864:	84 41 00 00 	l.lwz r2,0x0(r1)
 868:	44 00 48 00 	l.jr r9
 86c:	9c 21 00 04 	l.addi r1,r1,0x4

00000870 <_start_timer>:
 870:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 874:	d4 01 10 00 	l.sw 0x0(r1),r2
 878:	9c 41 00 04 	l.addi r2,r1,0x4
 87c:	84 41 00 00 	l.lwz r2,0x0(r1)
 880:	44 00 48 00 	l.jr r9
 884:	9c 21 00 04 	l.addi r1,r1,0x4

00000888 <_read_timer>:
 888:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 88c:	d4 01 10 00 	l.sw 0x0(r1),r2
 890:	9c 41 00 04 	l.addi r2,r1,0x4
 894:	9d 60 00 00 	l.addi r11,r0,0x0
 898:	84 41 00 00 	l.lwz r2,0x0(r1)
 89c:	44 00 48 00 	l.jr r9
 8a0:	9c 21 00 04 	l.addi r1,r1,0x4

000008a4 <_mtspr>:
 8a4:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 8a8:	d4 01 10 00 	l.sw 0x0(r1),r2
 8ac:	9c 41 00 04 	l.addi r2,r1,0x4
 8b0:	c0 03 20 00 	l.mtspr r3,r4,0x0
 8b4:	84 41 00 00 	l.lwz r2,0x0(r1)
 8b8:	44 00 48 00 	l.jr r9
 8bc:	9c 21 00 04 	l.addi r1,r1,0x4

000008c0 <_mfspr>:
 8c0:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 8c4:	d4 01 10 00 	l.sw 0x0(r1),r2
 8c8:	9c 41 00 04 	l.addi r2,r1,0x4
 8cc:	b5 63 00 00 	l.mfspr r11,r3,0x0
 8d0:	84 41 00 00 	l.lwz r2,0x0(r1)
 8d4:	44 00 48 00 	l.jr r9
 8d8:	9c 21 00 04 	l.addi r1,r1,0x4

000008dc <_memcpy>:
 8dc:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 8e0:	d4 01 10 00 	l.sw 0x0(r1),r2
 8e4:	9c 41 00 04 	l.addi r2,r1,0x4
 8e8:	00 00 00 07 	l.j 904 <_memcpy+0x28>
 8ec:	9c a5 ff ff 	l.addi r5,r5,0xffffffff
 8f0:	8c c4 00 00 	l.lbz r6,0x0(r4)
 8f4:	9c a5 ff ff 	l.addi r5,r5,0xffffffff
 8f8:	d8 03 30 00 	l.sb 0x0(r3),r6
 8fc:	9c 84 00 01 	l.addi r4,r4,0x1
 900:	9c 63 00 01 	l.addi r3,r3,0x1
 904:	bc 05 ff ff 	l.sfeqi r5,0xffffffff
 908:	0f ff ff fa 	l.bnf 8f0 <_memcpy+0x14>
 90c:	a9 63 00 00 	l.ori r11,r3,0x0
 910:	84 41 00 00 	l.lwz r2,0x0(r1)
 914:	44 00 48 00 	l.jr r9
 918:	9c 21 00 04 	l.addi r1,r1,0x4

0000091c <_excpt_dummy>:
 91c:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 920:	d4 01 10 00 	l.sw 0x0(r1),r2
 924:	9c 41 00 04 	l.addi r2,r1,0x4
 928:	84 41 00 00 	l.lwz r2,0x0(r1)
 92c:	44 00 48 00 	l.jr r9
 930:	9c 21 00 04 	l.addi r1,r1,0x4

00000934 <_int_init>:
 934:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 938:	d4 01 10 00 	l.sw 0x0(r1),r2
 93c:	9c 41 00 04 	l.addi r2,r1,0x4
 940:	18 60 00 00 	l.movhi r3,0x0
 944:	a8 63 0b a0 	l.ori r3,r3,0xba0
 948:	9c 80 00 1f 	l.addi r4,r0,0x1f
 94c:	9c a0 00 00 	l.addi r5,r0,0x0
 950:	9c 84 ff ff 	l.addi r4,r4,0xffffffff
 954:	d4 03 28 00 	l.sw 0x0(r3),r5
 958:	d4 03 28 04 	l.sw 0x4(r3),r5
 95c:	bd 64 00 00 	l.sfgesi r4,0x0
 960:	13 ff ff fc 	l.bf 950 <_int_init+0x1c>
 964:	9c 63 00 08 	l.addi r3,r3,0x8
 968:	a9 65 00 00 	l.ori r11,r5,0x0
 96c:	84 41 00 00 	l.lwz r2,0x0(r1)
 970:	44 00 48 00 	l.jr r9
 974:	9c 21 00 04 	l.addi r1,r1,0x4

00000978 <_int_add>:
 978:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
 97c:	d4 01 10 04 	l.sw 0x4(r1),r2
 980:	9c 41 00 0c 	l.addi r2,r1,0xc
 984:	d4 01 48 00 	l.sw 0x0(r1),r9
 988:	d4 01 50 08 	l.sw 0x8(r1),r10
 98c:	b8 c3 00 03 	l.slli r6,r3,0x3
 990:	a9 43 00 00 	l.ori r10,r3,0x0
 994:	18 e0 00 00 	l.movhi r7,0x0
 998:	a8 e7 0b a0 	l.ori r7,r7,0xba0
 99c:	9c 60 48 00 	l.addi r3,r0,0x4800
 9a0:	e0 c6 38 00 	l.add r6,r6,r7
 9a4:	bc aa 00 1f 	l.sfleui r10,0x1f
 9a8:	0c 00 00 0b 	l.bnf 9d4 <_int_add+0x5c>
 9ac:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
 9b0:	d4 06 20 00 	l.sw 0x0(r6),r4
 9b4:	07 ff ff c3 	l.jal 8c0 <_mfspr>
 9b8:	d4 06 28 04 	l.sw 0x4(r6),r5
 9bc:	9c 80 00 01 	l.addi r4,r0,0x1
 9c0:	9c 60 48 00 	l.addi r3,r0,0x4800
 9c4:	e0 84 50 08 	l.sll r4,r4,r10
 9c8:	07 ff ff b7 	l.jal 8a4 <_mtspr>
 9cc:	e0 8b 20 04 	l.or r4,r11,r4
 9d0:	9d 60 00 00 	l.addi r11,r0,0x0
 9d4:	85 21 00 00 	l.lwz r9,0x0(r1)
 9d8:	84 41 00 04 	l.lwz r2,0x4(r1)
 9dc:	85 41 00 08 	l.lwz r10,0x8(r1)
 9e0:	44 00 48 00 	l.jr r9
 9e4:	9c 21 00 0c 	l.addi r1,r1,0xc

000009e8 <_int_disable>:
 9e8:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
 9ec:	d4 01 10 04 	l.sw 0x4(r1),r2
 9f0:	9c 41 00 0c 	l.addi r2,r1,0xc
 9f4:	d4 01 48 00 	l.sw 0x0(r1),r9
 9f8:	d4 01 50 08 	l.sw 0x8(r1),r10
 9fc:	a9 43 00 00 	l.ori r10,r3,0x0
 a00:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
 a04:	bc aa 00 1f 	l.sfleui r10,0x1f
 a08:	0c 00 00 0b 	l.bnf a34 <_int_disable+0x4c>
 a0c:	9c 60 48 00 	l.addi r3,r0,0x4800
 a10:	07 ff ff ac 	l.jal 8c0 <_mfspr>
 a14:	15 00 00 00 	l.nop 0x0
 a18:	9c 80 00 01 	l.addi r4,r0,0x1
 a1c:	9c 60 48 00 	l.addi r3,r0,0x4800
 a20:	e0 84 50 08 	l.sll r4,r4,r10
 a24:	ac 84 ff ff 	l.xori r4,r4,0xffffffff
 a28:	07 ff ff 9f 	l.jal 8a4 <_mtspr>
 a2c:	e0 8b 20 03 	l.and r4,r11,r4
 a30:	9d 60 00 00 	l.addi r11,r0,0x0
 a34:	85 21 00 00 	l.lwz r9,0x0(r1)
 a38:	84 41 00 04 	l.lwz r2,0x4(r1)
 a3c:	85 41 00 08 	l.lwz r10,0x8(r1)
 a40:	44 00 48 00 	l.jr r9
 a44:	9c 21 00 0c 	l.addi r1,r1,0xc

00000a48 <_int_enable>:
 a48:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
 a4c:	d4 01 10 04 	l.sw 0x4(r1),r2
 a50:	9c 41 00 0c 	l.addi r2,r1,0xc
 a54:	d4 01 48 00 	l.sw 0x0(r1),r9
 a58:	d4 01 50 08 	l.sw 0x8(r1),r10
 a5c:	a9 43 00 00 	l.ori r10,r3,0x0
 a60:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
 a64:	bc aa 00 1f 	l.sfleui r10,0x1f
 a68:	0c 00 00 0a 	l.bnf a90 <_int_enable+0x48>
 a6c:	9c 60 48 00 	l.addi r3,r0,0x4800
 a70:	07 ff ff 94 	l.jal 8c0 <_mfspr>
 a74:	15 00 00 00 	l.nop 0x0
 a78:	9c 80 00 01 	l.addi r4,r0,0x1
 a7c:	9c 60 48 00 	l.addi r3,r0,0x4800
 a80:	e0 84 50 08 	l.sll r4,r4,r10
 a84:	07 ff ff 88 	l.jal 8a4 <_mtspr>
 a88:	e0 8b 20 04 	l.or r4,r11,r4
 a8c:	9d 60 00 00 	l.addi r11,r0,0x0
 a90:	85 21 00 00 	l.lwz r9,0x0(r1)
 a94:	84 41 00 04 	l.lwz r2,0x4(r1)
 a98:	85 41 00 08 	l.lwz r10,0x8(r1)
 a9c:	44 00 48 00 	l.jr r9
 aa0:	9c 21 00 0c 	l.addi r1,r1,0xc

00000aa4 <_int_main>:
 aa4:	9c 21 ff e4 	l.addi r1,r1,0xffffffe4
 aa8:	d4 01 10 04 	l.sw 0x4(r1),r2
 aac:	9c 41 00 1c 	l.addi r2,r1,0x1c
 ab0:	d4 01 48 00 	l.sw 0x0(r1),r9
 ab4:	d4 01 50 08 	l.sw 0x8(r1),r10
 ab8:	d4 01 60 0c 	l.sw 0xc(r1),r12
 abc:	d4 01 70 10 	l.sw 0x10(r1),r14
 ac0:	d4 01 80 14 	l.sw 0x14(r1),r16
 ac4:	d4 01 90 18 	l.sw 0x18(r1),r18
 ac8:	9c 60 48 02 	l.addi r3,r0,0x4802
 acc:	07 ff ff 7d 	l.jal 8c0 <_mfspr>
 ad0:	9d 80 00 00 	l.addi r12,r0,0x0
 ad4:	aa 0b 00 00 	l.ori r16,r11,0x0
 ad8:	9c 60 48 02 	l.addi r3,r0,0x4802
 adc:	a8 8c 00 00 	l.ori r4,r12,0x0
 ae0:	19 c0 00 00 	l.movhi r14,0x0
 ae4:	a9 ce 0b a0 	l.ori r14,r14,0xba0
 ae8:	07 ff ff 6f 	l.jal 8a4 <_mtspr>
 aec:	9e 40 00 01 	l.addi r18,r0,0x1
 af0:	e1 52 60 08 	l.sll r10,r18,r12
 af4:	e0 6a 80 03 	l.and r3,r10,r16
 af8:	bc 03 00 00 	l.sfeqi r3,0x0
 afc:	10 00 00 0e 	l.bf b34 <_int_main+0x90>
 b00:	9d 8c 00 01 	l.addi r12,r12,0x1
 b04:	84 8e 00 00 	l.lwz r4,0x0(r14)
 b08:	bc 04 00 00 	l.sfeqi r4,0x0
 b0c:	10 00 00 0b 	l.bf b38 <_int_main+0x94>
 b10:	bc 4c 00 1f 	l.sfgtui r12,0x1f
 b14:	48 00 20 00 	l.jalr r4
 b18:	84 6e 00 04 	l.lwz r3,0x4(r14)
 b1c:	07 ff ff 69 	l.jal 8c0 <_mfspr>
 b20:	9c 60 48 02 	l.addi r3,r0,0x4802
 b24:	ac 8a ff ff 	l.xori r4,r10,0xffffffff
 b28:	9c 60 48 02 	l.addi r3,r0,0x4802
 b2c:	07 ff ff 5e 	l.jal 8a4 <_mtspr>
 b30:	e0 8b 20 03 	l.and r4,r11,r4
 b34:	bc 4c 00 1f 	l.sfgtui r12,0x1f
 b38:	0f ff ff ee 	l.bnf af0 <_int_main+0x4c>
 b3c:	9d ce 00 08 	l.addi r14,r14,0x8
 b40:	85 21 00 00 	l.lwz r9,0x0(r1)
 b44:	84 41 00 04 	l.lwz r2,0x4(r1)
 b48:	85 41 00 08 	l.lwz r10,0x8(r1)
 b4c:	85 81 00 0c 	l.lwz r12,0xc(r1)
 b50:	85 c1 00 10 	l.lwz r14,0x10(r1)
 b54:	86 01 00 14 	l.lwz r16,0x14(r1)
 b58:	86 41 00 18 	l.lwz r18,0x18(r1)
 b5c:	44 00 48 00 	l.jr r9
 b60:	9c 21 00 1c 	l.addi r1,r1,0x1c
Disassembly of section .data:

00000b64 <_dst_beg>:
 b64:	00 00 09 1c 	l.j 2fd4 <_tmp_stack+0x1334>

00000b68 <_excpt_break>:
 b68:	00 00 09 1c 	l.j 2fd8 <_tmp_stack+0x1338>

00000b6c <_excpt_syscall>:
 b6c:	00 00 09 1c 	l.j 2fdc <_tmp_stack+0x133c>

00000b70 <_excpt_range>:
 b70:	00 00 09 1c 	l.j 2fe0 <_tmp_stack+0x1340>

00000b74 <_excpt_itlbmiss>:
 b74:	00 00 09 1c 	l.j 2fe4 <_tmp_stack+0x1344>

00000b78 <_excpt_dtlbmiss>:
 b78:	00 00 09 1c 	l.j 2fe8 <_tmp_stack+0x1348>

00000b7c <_excpt_int>:
 b7c:	00 00 0a a4 	l.j 360c <_tmp_stack+0x196c>

00000b80 <_excpt_illinsn>:
 b80:	00 00 09 1c 	l.j 2ff0 <_tmp_stack+0x1350>

00000b84 <_excpt_align>:
 b84:	00 00 09 1c 	l.j 2ff4 <_tmp_stack+0x1354>

00000b88 <_excpt_tick>:
 b88:	00 00 09 1c 	l.j 2ff8 <_tmp_stack+0x1358>

00000b8c <_excpt_ipfault>:
 b8c:	00 00 09 1c 	l.j 2ffc <_tmp_stack+0x135c>

00000b90 <_excpt_dpfault>:
 b90:	00 00 09 1c 	l.j 3000 <_tmp_stack+0x1360>

00000b94 <_excpt_buserr>:
 b94:	00 00 09 1c 	l.j 3004 <_tmp_stack+0x1364>
Disassembly of section .bss:

00000ba0 <_int_handlers>:
	...
Disassembly of section .stack:

00000ca0 <_tmp_stack-0x1000>:
	...

00001ca0 <_tmp_stack>:
	...
Disassembly of section .comment:

00000000 <.comment>:
   0:	00 47 43 43 	l.j 11d0d0c <_src_addr+0x11bf06c>
   4:	3a 20 28 47 	.word 0x3a202847
   8:	4e 55 29 20 	l.maci r21,0xffff9120
   c:	33 2e 34 2e 	.word 0x332e342e
  10:	34 00 00 47 	.word 0x34000047
  14:	43 43 3a 20 	.word 0x43433a20
  18:	28 47 4e 55 	lv.max.b r2,r7,r9
  1c:	29 20 33 2e 	.word 0x2920332e
  20:	34 2e 34 00 	.word 0x342e3400
