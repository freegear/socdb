
d_buserr-icdc.or32:     file format elf32-or32

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
 180:	18 60 00 00 	l.movhi r3,0x0
 184:	a8 63 02 18 	l.ori r3,r3,0x218
 188:	44 00 18 00 	l.jr r3
 18c:	15 00 00 00 	l.nop 0x0
Disassembly of section .vectors:

00000200 <_vec_start>:
 200:	15 00 00 00 	l.nop 0x0
 204:	18 60 de ad 	l.movhi r3,0xdead
 208:	a8 63 de ad 	l.ori r3,r3,0xdead
 20c:	15 00 00 02 	l.nop 0x2
 210:	04 00 00 31 	l.jal 2d4 <_exit>
 214:	15 00 00 00 	l.nop 0x0
Disassembly of section .text:

00000218 <_start>:
 218:	15 00 00 00 	l.nop 0x0
 21c:	9d 40 00 00 	l.addi r10,r0,0x0
 220:	9d 60 00 00 	l.addi r11,r0,0x0
 224:	9d 80 00 00 	l.addi r12,r0,0x0
 228:	9d 60 20 00 	l.addi r11,r0,0x2000
 22c:	9d 80 20 00 	l.addi r12,r0,0x2000
 230:	e4 ac 58 00 	l.sfleu r12,r11
 234:	10 00 00 03 	l.bf 240 <loop>
 238:	15 00 00 00 	l.nop 0x0
 23c:	e1 60 60 00 	l.add r11,r0,r12

00000240 <loop>:
 240:	c0 80 50 02 	l.mtspr r0,r10,0x2002
 244:	c0 60 50 03 	l.mtspr r0,r10,0x1803
 248:	e4 2a 58 00 	l.sfne r10,r11
 24c:	13 ff ff fd 	l.bf 240 <loop>
 250:	9d 4a 00 10 	l.addi r10,r10,0x10
 254:	9d 40 00 01 	l.addi r10,r0,0x1
 258:	a9 4a 00 10 	l.ori r10,r10,0x10
 25c:	a9 4a 00 08 	l.ori r10,r10,0x8
 260:	c0 00 50 11 	l.mtspr r0,r10,0x11
 264:	15 00 00 00 	l.nop 0x0
 268:	15 00 00 00 	l.nop 0x0
 26c:	15 00 00 00 	l.nop 0x0
 270:	15 00 00 00 	l.nop 0x0
 274:	15 00 00 00 	l.nop 0x0
 278:	9c 60 00 00 	l.addi r3,r0,0x0
 27c:	9c 80 00 00 	l.addi r4,r0,0x0
 280:	18 20 00 01 	l.movhi r1,0x1
 284:	a8 21 07 c0 	l.ori r1,r1,0x7c0
 288:	18 40 00 00 	l.movhi r2,0x0
 28c:	a8 42 02 fc 	l.ori r2,r2,0x2fc
 290:	44 00 10 00 	l.jr r2
 294:	15 00 00 00 	l.nop 0x0

00000298 <_main>:
 298:	9c 21 ff f8 	l.addi r1,r1,0xfffffff8
 29c:	d4 01 10 04 	l.sw 0x4(r1),r2
 2a0:	9c 41 00 08 	l.addi r2,r1,0x8
 2a4:	d4 01 48 00 	l.sw 0x0(r1),r9
 2a8:	18 60 06 00 	l.movhi r3,0x600
 2ac:	18 80 de ad 	l.movhi r4,0xdead
 2b0:	90 63 00 00 	l.lbs r3,0x0(r3)
 2b4:	04 00 00 29 	l.jal 358 <_report>
 2b8:	e0 63 20 00 	l.add r3,r3,r4
 2bc:	04 00 00 06 	l.jal 2d4 <_exit>
 2c0:	9c 60 00 00 	l.addi r3,r0,0x0
 2c4:	85 21 00 00 	l.lwz r9,0x0(r1)
 2c8:	84 41 00 04 	l.lwz r2,0x4(r1)
 2cc:	44 00 48 00 	l.jr r9
 2d0:	9c 21 00 08 	l.addi r1,r1,0x8

000002d4 <_exit>:
 2d4:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 2d8:	d4 01 10 00 	l.sw 0x0(r1),r2
 2dc:	9c 41 00 04 	l.addi r2,r1,0x4
 2e0:	e0 60 18 00 	l.add r3,r0,r3
 2e4:	15 00 00 01 	l.nop 0x1
 2e8:	00 00 00 00 	l.j 2e8 <_exit+0x14>
 2ec:	15 00 00 00 	l.nop 0x0
 2f0:	84 41 00 00 	l.lwz r2,0x0(r1)
 2f4:	44 00 48 00 	l.jr r9
 2f8:	9c 21 00 04 	l.addi r1,r1,0x4

000002fc <_reset>:
 2fc:	9c 21 ff f8 	l.addi r1,r1,0xfffffff8
 300:	d4 01 10 04 	l.sw 0x4(r1),r2
 304:	9c 41 00 08 	l.addi r2,r1,0x8
 308:	d4 01 48 00 	l.sw 0x0(r1),r9
 30c:	07 ff ff e3 	l.jal 298 <_main>
 310:	15 00 00 00 	l.nop 0x0
 314:	07 ff ff f0 	l.jal 2d4 <_exit>
 318:	a8 6b 00 00 	l.ori r3,r11,0x0
 31c:	85 21 00 00 	l.lwz r9,0x0(r1)
 320:	84 41 00 04 	l.lwz r2,0x4(r1)
 324:	44 00 48 00 	l.jr r9
 328:	9c 21 00 08 	l.addi r1,r1,0x8

0000032c <_printf>:
 32c:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 330:	d4 01 10 00 	l.sw 0x0(r1),r2
 334:	9c 41 00 04 	l.addi r2,r1,0x4
 338:	84 82 00 00 	l.lwz r4,0x0(r2)
 33c:	9c 62 00 04 	l.addi r3,r2,0x4
 340:	9c 64 00 00 	l.addi r3,r4,0x0
 344:	9c 83 00 00 	l.addi r4,r3,0x0
 348:	15 00 00 03 	l.nop 0x3
 34c:	84 41 00 00 	l.lwz r2,0x0(r1)
 350:	44 00 48 00 	l.jr r9
 354:	9c 21 00 04 	l.addi r1,r1,0x4

00000358 <_report>:
 358:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 35c:	d4 01 10 00 	l.sw 0x0(r1),r2
 360:	9c 41 00 04 	l.addi r2,r1,0x4
 364:	9c 63 00 00 	l.addi r3,r3,0x0
 368:	15 00 00 02 	l.nop 0x2
 36c:	84 41 00 00 	l.lwz r2,0x0(r1)
 370:	44 00 48 00 	l.jr r9
 374:	9c 21 00 04 	l.addi r1,r1,0x4

00000378 <___main>:
 378:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 37c:	d4 01 10 00 	l.sw 0x0(r1),r2
 380:	9c 41 00 04 	l.addi r2,r1,0x4
 384:	84 41 00 00 	l.lwz r2,0x0(r1)
 388:	44 00 48 00 	l.jr r9
 38c:	9c 21 00 04 	l.addi r1,r1,0x4

00000390 <_start_timer>:
 390:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 394:	d4 01 10 00 	l.sw 0x0(r1),r2
 398:	9c 41 00 04 	l.addi r2,r1,0x4
 39c:	84 41 00 00 	l.lwz r2,0x0(r1)
 3a0:	44 00 48 00 	l.jr r9
 3a4:	9c 21 00 04 	l.addi r1,r1,0x4

000003a8 <_read_timer>:
 3a8:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 3ac:	d4 01 10 00 	l.sw 0x0(r1),r2
 3b0:	9c 41 00 04 	l.addi r2,r1,0x4
 3b4:	9d 60 00 00 	l.addi r11,r0,0x0
 3b8:	84 41 00 00 	l.lwz r2,0x0(r1)
 3bc:	44 00 48 00 	l.jr r9
 3c0:	9c 21 00 04 	l.addi r1,r1,0x4

000003c4 <_mtspr>:
 3c4:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 3c8:	d4 01 10 00 	l.sw 0x0(r1),r2
 3cc:	9c 41 00 04 	l.addi r2,r1,0x4
 3d0:	c0 03 20 00 	l.mtspr r3,r4,0x0
 3d4:	84 41 00 00 	l.lwz r2,0x0(r1)
 3d8:	44 00 48 00 	l.jr r9
 3dc:	9c 21 00 04 	l.addi r1,r1,0x4

000003e0 <_mfspr>:
 3e0:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 3e4:	d4 01 10 00 	l.sw 0x0(r1),r2
 3e8:	9c 41 00 04 	l.addi r2,r1,0x4
 3ec:	b5 63 00 00 	l.mfspr r11,r3,0x0
 3f0:	84 41 00 00 	l.lwz r2,0x0(r1)
 3f4:	44 00 48 00 	l.jr r9
 3f8:	9c 21 00 04 	l.addi r1,r1,0x4

000003fc <_memcpy>:
 3fc:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 400:	d4 01 10 00 	l.sw 0x0(r1),r2
 404:	9c 41 00 04 	l.addi r2,r1,0x4
 408:	00 00 00 07 	l.j 424 <_memcpy+0x28>
 40c:	9c a5 ff ff 	l.addi r5,r5,0xffffffff
 410:	8c c4 00 00 	l.lbz r6,0x0(r4)
 414:	9c a5 ff ff 	l.addi r5,r5,0xffffffff
 418:	d8 03 30 00 	l.sb 0x0(r3),r6
 41c:	9c 84 00 01 	l.addi r4,r4,0x1
 420:	9c 63 00 01 	l.addi r3,r3,0x1
 424:	bc 05 ff ff 	l.sfeqi r5,0xffffffff
 428:	0f ff ff fa 	l.bnf 410 <_memcpy+0x14>
 42c:	a9 63 00 00 	l.ori r11,r3,0x0
 430:	84 41 00 00 	l.lwz r2,0x0(r1)
 434:	44 00 48 00 	l.jr r9
 438:	9c 21 00 04 	l.addi r1,r1,0x4

0000043c <_excpt_dummy>:
 43c:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 440:	d4 01 10 00 	l.sw 0x0(r1),r2
 444:	9c 41 00 04 	l.addi r2,r1,0x4
 448:	84 41 00 00 	l.lwz r2,0x0(r1)
 44c:	44 00 48 00 	l.jr r9
 450:	9c 21 00 04 	l.addi r1,r1,0x4

00000454 <_int_init>:
 454:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 458:	d4 01 10 00 	l.sw 0x0(r1),r2
 45c:	9c 41 00 04 	l.addi r2,r1,0x4
 460:	18 60 00 00 	l.movhi r3,0x0
 464:	a8 63 06 c0 	l.ori r3,r3,0x6c0
 468:	9c 80 00 1f 	l.addi r4,r0,0x1f
 46c:	9c a0 00 00 	l.addi r5,r0,0x0
 470:	9c 84 ff ff 	l.addi r4,r4,0xffffffff
 474:	d4 03 28 00 	l.sw 0x0(r3),r5
 478:	d4 03 28 04 	l.sw 0x4(r3),r5
 47c:	bd 64 00 00 	l.sfgesi r4,0x0
 480:	13 ff ff fc 	l.bf 470 <_int_init+0x1c>
 484:	9c 63 00 08 	l.addi r3,r3,0x8
 488:	a9 65 00 00 	l.ori r11,r5,0x0
 48c:	84 41 00 00 	l.lwz r2,0x0(r1)
 490:	44 00 48 00 	l.jr r9
 494:	9c 21 00 04 	l.addi r1,r1,0x4

00000498 <_int_add>:
 498:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
 49c:	d4 01 10 04 	l.sw 0x4(r1),r2
 4a0:	9c 41 00 0c 	l.addi r2,r1,0xc
 4a4:	d4 01 48 00 	l.sw 0x0(r1),r9
 4a8:	d4 01 50 08 	l.sw 0x8(r1),r10
 4ac:	b8 c3 00 03 	l.slli r6,r3,0x3
 4b0:	a9 43 00 00 	l.ori r10,r3,0x0
 4b4:	18 e0 00 00 	l.movhi r7,0x0
 4b8:	a8 e7 06 c0 	l.ori r7,r7,0x6c0
 4bc:	9c 60 48 00 	l.addi r3,r0,0x4800
 4c0:	e0 c6 38 00 	l.add r6,r6,r7
 4c4:	bc aa 00 1f 	l.sfleui r10,0x1f
 4c8:	0c 00 00 0b 	l.bnf 4f4 <_int_add+0x5c>
 4cc:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
 4d0:	d4 06 20 00 	l.sw 0x0(r6),r4
 4d4:	07 ff ff c3 	l.jal 3e0 <_mfspr>
 4d8:	d4 06 28 04 	l.sw 0x4(r6),r5
 4dc:	9c 80 00 01 	l.addi r4,r0,0x1
 4e0:	9c 60 48 00 	l.addi r3,r0,0x4800
 4e4:	e0 84 50 08 	l.sll r4,r4,r10
 4e8:	07 ff ff b7 	l.jal 3c4 <_mtspr>
 4ec:	e0 8b 20 04 	l.or r4,r11,r4
 4f0:	9d 60 00 00 	l.addi r11,r0,0x0
 4f4:	85 21 00 00 	l.lwz r9,0x0(r1)
 4f8:	84 41 00 04 	l.lwz r2,0x4(r1)
 4fc:	85 41 00 08 	l.lwz r10,0x8(r1)
 500:	44 00 48 00 	l.jr r9
 504:	9c 21 00 0c 	l.addi r1,r1,0xc

00000508 <_int_disable>:
 508:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
 50c:	d4 01 10 04 	l.sw 0x4(r1),r2
 510:	9c 41 00 0c 	l.addi r2,r1,0xc
 514:	d4 01 48 00 	l.sw 0x0(r1),r9
 518:	d4 01 50 08 	l.sw 0x8(r1),r10
 51c:	a9 43 00 00 	l.ori r10,r3,0x0
 520:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
 524:	bc aa 00 1f 	l.sfleui r10,0x1f
 528:	0c 00 00 0b 	l.bnf 554 <_int_disable+0x4c>
 52c:	9c 60 48 00 	l.addi r3,r0,0x4800
 530:	07 ff ff ac 	l.jal 3e0 <_mfspr>
 534:	15 00 00 00 	l.nop 0x0
 538:	9c 80 00 01 	l.addi r4,r0,0x1
 53c:	9c 60 48 00 	l.addi r3,r0,0x4800
 540:	e0 84 50 08 	l.sll r4,r4,r10
 544:	ac 84 ff ff 	l.xori r4,r4,0xffffffff
 548:	07 ff ff 9f 	l.jal 3c4 <_mtspr>
 54c:	e0 8b 20 03 	l.and r4,r11,r4
 550:	9d 60 00 00 	l.addi r11,r0,0x0
 554:	85 21 00 00 	l.lwz r9,0x0(r1)
 558:	84 41 00 04 	l.lwz r2,0x4(r1)
 55c:	85 41 00 08 	l.lwz r10,0x8(r1)
 560:	44 00 48 00 	l.jr r9
 564:	9c 21 00 0c 	l.addi r1,r1,0xc

00000568 <_int_enable>:
 568:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
 56c:	d4 01 10 04 	l.sw 0x4(r1),r2
 570:	9c 41 00 0c 	l.addi r2,r1,0xc
 574:	d4 01 48 00 	l.sw 0x0(r1),r9
 578:	d4 01 50 08 	l.sw 0x8(r1),r10
 57c:	a9 43 00 00 	l.ori r10,r3,0x0
 580:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
 584:	bc aa 00 1f 	l.sfleui r10,0x1f
 588:	0c 00 00 0a 	l.bnf 5b0 <_int_enable+0x48>
 58c:	9c 60 48 00 	l.addi r3,r0,0x4800
 590:	07 ff ff 94 	l.jal 3e0 <_mfspr>
 594:	15 00 00 00 	l.nop 0x0
 598:	9c 80 00 01 	l.addi r4,r0,0x1
 59c:	9c 60 48 00 	l.addi r3,r0,0x4800
 5a0:	e0 84 50 08 	l.sll r4,r4,r10
 5a4:	07 ff ff 88 	l.jal 3c4 <_mtspr>
 5a8:	e0 8b 20 04 	l.or r4,r11,r4
 5ac:	9d 60 00 00 	l.addi r11,r0,0x0
 5b0:	85 21 00 00 	l.lwz r9,0x0(r1)
 5b4:	84 41 00 04 	l.lwz r2,0x4(r1)
 5b8:	85 41 00 08 	l.lwz r10,0x8(r1)
 5bc:	44 00 48 00 	l.jr r9
 5c0:	9c 21 00 0c 	l.addi r1,r1,0xc

000005c4 <_int_main>:
 5c4:	9c 21 ff e4 	l.addi r1,r1,0xffffffe4
 5c8:	d4 01 10 04 	l.sw 0x4(r1),r2
 5cc:	9c 41 00 1c 	l.addi r2,r1,0x1c
 5d0:	d4 01 48 00 	l.sw 0x0(r1),r9
 5d4:	d4 01 50 08 	l.sw 0x8(r1),r10
 5d8:	d4 01 60 0c 	l.sw 0xc(r1),r12
 5dc:	d4 01 70 10 	l.sw 0x10(r1),r14
 5e0:	d4 01 80 14 	l.sw 0x14(r1),r16
 5e4:	d4 01 90 18 	l.sw 0x18(r1),r18
 5e8:	9c 60 48 02 	l.addi r3,r0,0x4802
 5ec:	07 ff ff 7d 	l.jal 3e0 <_mfspr>
 5f0:	9d 80 00 00 	l.addi r12,r0,0x0
 5f4:	aa 0b 00 00 	l.ori r16,r11,0x0
 5f8:	9c 60 48 02 	l.addi r3,r0,0x4802
 5fc:	a8 8c 00 00 	l.ori r4,r12,0x0
 600:	19 c0 00 00 	l.movhi r14,0x0
 604:	a9 ce 06 c0 	l.ori r14,r14,0x6c0
 608:	07 ff ff 6f 	l.jal 3c4 <_mtspr>
 60c:	9e 40 00 01 	l.addi r18,r0,0x1
 610:	e1 52 60 08 	l.sll r10,r18,r12
 614:	e0 6a 80 03 	l.and r3,r10,r16
 618:	bc 03 00 00 	l.sfeqi r3,0x0
 61c:	10 00 00 0e 	l.bf 654 <_int_main+0x90>
 620:	9d 8c 00 01 	l.addi r12,r12,0x1
 624:	84 8e 00 00 	l.lwz r4,0x0(r14)
 628:	bc 04 00 00 	l.sfeqi r4,0x0
 62c:	10 00 00 0b 	l.bf 658 <_int_main+0x94>
 630:	bc 4c 00 1f 	l.sfgtui r12,0x1f
 634:	48 00 20 00 	l.jalr r4
 638:	84 6e 00 04 	l.lwz r3,0x4(r14)
 63c:	07 ff ff 69 	l.jal 3e0 <_mfspr>
 640:	9c 60 48 02 	l.addi r3,r0,0x4802
 644:	ac 8a ff ff 	l.xori r4,r10,0xffffffff
 648:	9c 60 48 02 	l.addi r3,r0,0x4802
 64c:	07 ff ff 5e 	l.jal 3c4 <_mtspr>
 650:	e0 8b 20 03 	l.and r4,r11,r4
 654:	bc 4c 00 1f 	l.sfgtui r12,0x1f
 658:	0f ff ff ee 	l.bnf 610 <_int_main+0x4c>
 65c:	9d ce 00 08 	l.addi r14,r14,0x8
 660:	85 21 00 00 	l.lwz r9,0x0(r1)
 664:	84 41 00 04 	l.lwz r2,0x4(r1)
 668:	85 41 00 08 	l.lwz r10,0x8(r1)
 66c:	85 81 00 0c 	l.lwz r12,0xc(r1)
 670:	85 c1 00 10 	l.lwz r14,0x10(r1)
 674:	86 01 00 14 	l.lwz r16,0x14(r1)
 678:	86 41 00 18 	l.lwz r18,0x18(r1)
 67c:	44 00 48 00 	l.jr r9
 680:	9c 21 00 1c 	l.addi r1,r1,0x1c
Disassembly of section .data:

00000684 <_dst_beg>:
 684:	00 00 04 3c 	l.j 1774 <_int_handlers+0x10b4>

00000688 <_excpt_break>:
 688:	00 00 04 3c 	l.j 1778 <_int_handlers+0x10b8>

0000068c <_excpt_syscall>:
 68c:	00 00 04 3c 	l.j 177c <_int_handlers+0x10bc>

00000690 <_excpt_range>:
 690:	00 00 04 3c 	l.j 1780 <_int_handlers+0x10c0>

00000694 <_excpt_itlbmiss>:
 694:	00 00 04 3c 	l.j 1784 <_int_handlers+0x10c4>

00000698 <_excpt_dtlbmiss>:
 698:	00 00 04 3c 	l.j 1788 <_int_handlers+0x10c8>

0000069c <_excpt_int>:
 69c:	00 00 05 c4 	l.j 1dac <_int_handlers+0x16ec>

000006a0 <_excpt_illinsn>:
 6a0:	00 00 04 3c 	l.j 1790 <_int_handlers+0x10d0>

000006a4 <_excpt_align>:
 6a4:	00 00 04 3c 	l.j 1794 <_int_handlers+0x10d4>

000006a8 <_excpt_tick>:
 6a8:	00 00 04 3c 	l.j 1798 <_int_handlers+0x10d8>

000006ac <_excpt_ipfault>:
 6ac:	00 00 04 3c 	l.j 179c <_int_handlers+0x10dc>

000006b0 <_excpt_dpfault>:
 6b0:	00 00 04 3c 	l.j 17a0 <_int_handlers+0x10e0>

000006b4 <_excpt_buserr>:
 6b4:	00 00 04 3c 	l.j 17a4 <_int_handlers+0x10e4>
Disassembly of section .bss:

000006c0 <_int_handlers>:
	...
Disassembly of section .stack:

000007c0 <_src_addr-0x10000>:
	...
Disassembly of section .stab:

00000000 <.stab>:
   0:	00 00 00 01 	l.j 4 <.stab+0x4>
   4:	00 00 00 33 	l.j d0 <.stab+0xd0>
   8:	00 00 05 5b 	l.j 1574 <_int_handlers+0xeb4>
   c:	00 00 00 0c 	l.j 3c <.stab+0x3c>
  10:	64 00 00 00 	.word 0x64000000
  14:	00 00 02 98 	l.j a74 <_int_handlers+0x3b4>
  18:	00 00 00 3d 	l.j 10c <.stab+0x10c>
  1c:	64 00 00 00 	.word 0x64000000
  20:	00 00 02 98 	l.j a80 <_int_handlers+0x3c0>
  24:	00 00 00 48 	l.j 144 <.stab+0x144>
  28:	3c 00 00 00 	.word 0x3c000000
  2c:	00 00 00 00 	l.j 2c <.stab+0x2c>
  30:	00 00 00 57 	l.j 18c <.stab+0x18c>
  34:	80 00 00 00 	l.ld r0,0x0(r0)
  38:	00 00 00 00 	l.j 38 <.stab+0x38>
  3c:	00 00 00 81 	l.j 240 <.stab+0x240>
  40:	80 00 00 00 	l.ld r0,0x0(r0)
  44:	00 00 00 00 	l.j 44 <.stab+0x44>
  48:	00 00 00 9b 	l.j 2b4 <_main+0x1c>
  4c:	80 00 00 00 	l.ld r0,0x0(r0)
  50:	00 00 00 00 	l.j 50 <.stab+0x50>
  54:	00 00 00 ca 	l.j 37c <___main+0x4>
  58:	80 00 00 00 	l.ld r0,0x0(r0)
  5c:	00 00 00 00 	l.j 5c <.stab+0x5c>
  60:	00 00 01 02 	l.j 468 <_int_init+0x14>
  64:	80 00 00 00 	l.ld r0,0x0(r0)
  68:	00 00 00 00 	l.j 68 <.stab+0x68>
  6c:	00 00 01 3f 	l.j 568 <_int_enable>
  70:	80 00 00 00 	l.ld r0,0x0(r0)
  74:	00 00 00 00 	l.j 74 <.stab+0x74>
  78:	00 00 01 90 	l.j 6b8 <_dst_end>
  7c:	80 00 00 00 	l.ld r0,0x0(r0)
  80:	00 00 00 00 	l.j 80 <.stab+0x80>
  84:	00 00 01 e1 	l.j 808 <_int_handlers+0x148>
  88:	80 00 00 00 	l.ld r0,0x0(r0)
  8c:	00 00 00 00 	l.j 8c <.stab+0x8c>
  90:	00 00 02 0c 	l.j 8c0 <_int_handlers+0x200>
  94:	80 00 00 00 	l.ld r0,0x0(r0)
  98:	00 00 00 00 	l.j 98 <.stab+0x98>
  9c:	00 00 02 3b 	l.j 988 <_int_handlers+0x2c8>
  a0:	80 00 00 00 	l.ld r0,0x0(r0)
  a4:	00 00 00 00 	l.j a4 <.stab+0xa4>
  a8:	00 00 02 65 	l.j a3c <_int_handlers+0x37c>
  ac:	80 00 00 00 	l.ld r0,0x0(r0)
  b0:	00 00 00 00 	l.j b0 <.stab+0xb0>
  b4:	00 00 02 8e 	l.j aec <_int_handlers+0x42c>
  b8:	80 00 00 00 	l.ld r0,0x0(r0)
  bc:	00 00 00 00 	l.j bc <.stab+0xbc>
  c0:	00 00 02 a8 	l.j b60 <_int_handlers+0x4a0>
  c4:	80 00 00 00 	l.ld r0,0x0(r0)
  c8:	00 00 00 00 	l.j c8 <.stab+0xc8>
  cc:	00 00 02 c3 	l.j bd8 <_int_handlers+0x518>
  d0:	80 00 00 00 	l.ld r0,0x0(r0)
  d4:	00 00 00 00 	l.j d4 <.stab+0xd4>
  d8:	00 00 02 e3 	l.j c64 <_int_handlers+0x5a4>
  dc:	80 00 00 00 	l.ld r0,0x0(r0)
  e0:	00 00 00 00 	l.j e0 <.stab+0xe0>
  e4:	00 00 03 1c 	l.j d54 <_int_handlers+0x694>
  e8:	80 00 00 00 	l.ld r0,0x0(r0)
  ec:	00 00 00 00 	l.j ec <.stab+0xec>
  f0:	00 00 03 3a 	l.j dd8 <_int_handlers+0x718>
  f4:	80 00 00 00 	l.ld r0,0x0(r0)
  f8:	00 00 00 00 	l.j f8 <.stab+0xf8>
  fc:	00 00 03 5a 	l.j e64 <_int_handlers+0x7a4>
 100:	80 00 00 00 	l.ld r0,0x0(r0)
 104:	00 00 00 00 	l.j 104 <.stab+0x104>
 108:	00 00 03 7f 	l.j f04 <_int_handlers+0x844>
 10c:	80 00 00 00 	l.ld r0,0x0(r0)
 110:	00 00 00 00 	l.j 110 <.stab+0x110>
 114:	00 00 03 93 	l.j f60 <_int_handlers+0x8a0>
 118:	80 00 00 00 	l.ld r0,0x0(r0)
 11c:	00 00 00 00 	l.j 11c <.stab+0x11c>
 120:	00 00 03 b5 	l.j ff4 <_int_handlers+0x934>
 124:	80 00 00 00 	l.ld r0,0x0(r0)
 128:	00 00 00 00 	l.j 128 <.stab+0x128>
 12c:	00 00 03 cc 	l.j 105c <_int_handlers+0x99c>
 130:	82 00 00 00 	l.ld r16,0x0(r0)
 134:	00 00 00 00 	l.j 134 <.stab+0x134>
 138:	00 00 03 e1 	l.j 10bc <_int_handlers+0x9fc>
 13c:	82 00 00 00 	l.ld r16,0x0(r0)
 140:	00 00 00 00 	l.j 140 <.stab+0x140>
 144:	00 00 04 1f 	l.j 11c0 <_int_handlers+0xb00>
 148:	80 00 00 2b 	l.ld r0,0x2b(r0)
 14c:	00 00 00 00 	l.j 14c <.stab+0x14c>
 150:	00 00 04 3c 	l.j 1240 <_int_handlers+0xb80>
 154:	80 00 00 69 	l.ld r0,0x69(r0)
	...
 160:	a2 00 00 00 	l.addic r16,r0,0x0
 164:	00 00 00 00 	l.j 164 <.stab+0x164>
 168:	00 00 04 51 	l.j 12ac <_int_handlers+0xbec>
 16c:	82 00 00 00 	l.ld r16,0x0(r0)
 170:	00 00 00 00 	l.j 170 <.stab+0x170>
 174:	00 00 04 8f 	l.j 13b0 <_int_handlers+0xcf0>
 178:	80 00 00 97 	l.ld r0,0x97(r0)
 17c:	00 00 00 00 	l.j 17c <.stab+0x17c>
 180:	00 00 04 a6 	l.j 1418 <_int_handlers+0xd58>
 184:	80 00 00 d5 	l.ld r0,0xd5(r0)
 188:	00 00 00 00 	l.j 188 <.stab+0x188>
 18c:	00 00 04 ba 	l.j 1474 <_int_handlers+0xdb4>
 190:	80 00 01 45 	l.ld r0,0x145(r0)
	...
 19c:	a2 00 00 00 	l.addic r16,r0,0x0
	...
 1a8:	a2 00 00 00 	l.addic r16,r0,0x0
 1ac:	00 00 00 00 	l.j 1ac <.stab+0x1ac>
 1b0:	00 00 04 cf 	l.j 14ec <_int_handlers+0xe2c>
 1b4:	82 00 00 00 	l.ld r16,0x0(r0)
 1b8:	00 00 00 00 	l.j 1b8 <.stab+0x1b8>
 1bc:	00 00 04 e0 	l.j 153c <_int_handlers+0xe7c>
 1c0:	80 00 00 00 	l.ld r0,0x0(r0)
	...
 1cc:	a2 00 00 00 	l.addic r16,r0,0x0
 1d0:	00 00 00 00 	l.j 1d0 <.stab+0x1d0>
 1d4:	00 00 05 2a 	l.j 167c <_int_handlers+0xfbc>
 1d8:	24 00 00 0a 	l.rfe 
 1dc:	00 00 02 98 	l.j c3c <_int_handlers+0x57c>
 1e0:	00 00 00 00 	l.j 1e0 <.stab+0x1e0>
 1e4:	44 00 00 0a 	l.jr r0
	...
 1f0:	44 00 00 0e 	l.jr r0
 1f4:	00 00 00 10 	l.j 234 <.stab+0x234>
 1f8:	00 00 00 00 	l.j 1f8 <.stab+0x1f8>
 1fc:	44 00 00 10 	l.jr r0
 200:	00 00 00 14 	l.j 250 <.stab+0x250>
 204:	00 00 00 00 	l.j 204 <.stab+0x204>
 208:	44 00 00 0e 	l.jr r0
 20c:	00 00 00 18 	l.j 26c <.stab+0x26c>
 210:	00 00 00 00 	l.j 210 <.stab+0x210>
 214:	44 00 00 10 	l.jr r0
 218:	00 00 00 1c 	l.j 288 <loop+0x48>
 21c:	00 00 00 00 	l.j 21c <.stab+0x21c>
 220:	44 00 00 11 	l.jr r0
 224:	00 00 00 24 	l.j 2b4 <_main+0x1c>
 228:	00 00 05 36 	l.j 1700 <_int_handlers+0x1040>
 22c:	40 00 00 0b 	.word 0x4000000b
 230:	00 00 00 03 	l.j 23c <.stab+0x23c>
 234:	00 00 05 3f 	l.j 1730 <_int_handlers+0x1070>
 238:	40 00 00 0c 	.word 0x4000000c
 23c:	00 00 00 03 	l.j 248 <.stab+0x248>
 240:	00 00 00 00 	l.j 240 <.stab+0x240>
 244:	c0 00 00 00 	l.mtspr r0,r0,0x0
	...
 250:	e0 00 00 00 	l.add r0,r0,r0
 254:	00 00 00 3c 	l.j 344 <_printf+0x18>
 258:	00 00 00 00 	l.j 258 <.stab+0x258>
 25c:	24 00 00 00 	l.rfe 
 260:	00 00 00 3c 	l.j 350 <_printf+0x24>
 264:	00 00 00 00 	l.j 264 <.stab+0x264>
 268:	64 00 00 00 	.word 0x64000000
 26c:	00 00 02 d4 	l.j dbc <_int_handlers+0x6fc>
Disassembly of section .stabstr:

00000000 <.stabstr>:
   0:	00 64 5f 62 	l.j 1917d88 <_src_addr+0x19075c8>
   4:	75 73 65 72 	l.cust2 
   8:	72 2e 63 00 	l.cust1 
   c:	2f 68 6f 6d 	.word 0x2f686f6d
  10:	65 2f 68 6f 	.word 0x652f686f
  14:	6c 65 6c 65 	.word 0x6c656c65
  18:	65 2f 6f 70 	.word 0x652f6f70
  1c:	65 6e 72 69 	.word 0x656e7269
  20:	73 63 2f 6f 	l.cust1 
  24:	70 65 6e 72 	l.cust1 
  28:	69 73 63 5f 	.word 0x6973635f
  2c:	61 68 62 2f 	.word 0x6168622f
  30:	73 77 2f 64 	l.cust1 
  34:	5f 62 75 73 	.word 0x5f627573
  38:	65 72 72 2f 	.word 0x6572722f
  3c:	00 64 5f 62 	l.j 1917dc4 <_src_addr+0x1907604>
  40:	75 73 65 72 	l.cust2 
  44:	72 2e 63 00 	l.cust1 
  48:	67 63 63 32 	.word 0x67636332
  4c:	5f 63 6f 6d 	.word 0x5f636f6d
  50:	70 69 6c 65 	l.cust1 
  54:	64 2e 00 69 	.word 0x642e0069
  58:	6e 74 3a 74 	.word 0x6e743a74
  5c:	28 30 2c 31 	lv.add.h r1,r16,r5
  60:	29 3d 72 28 	lv.any_lt.b r9,r29,r14
  64:	30 2c 31 29 	.word 0x302c3129
  68:	3b 2d 32 31 	.word 0x3b2d3231
  6c:	34 37 34 38 	.word 0x34373438
  70:	33 36 34 38 	.word 0x33363438
  74:	3b 32 31 34 	.word 0x3b323134
  78:	37 34 38 33 	.word 0x37343833
  7c:	36 34 37 3b 	.word 0x3634373b
  80:	00 63 68 61 	l.j 18da204 <_src_addr+0x18c9a44>
  84:	72 3a 74 28 	l.cust1 
  88:	30 2c 32 29 	.word 0x302c3229
  8c:	3d 72 28 30 	.word 0x3d722830
  90:	2c 32 29 3b 	.word 0x2c32293b
  94:	30 3b 31 32 	.word 0x303b3132
  98:	37 3b 00 6c 	.word 0x373b006c
  9c:	6f 6e 67 20 	.word 0x6f6e6720
  a0:	69 6e 74 3a 	.word 0x696e743a
  a4:	74 28 30 2c 	l.cust2 
  a8:	33 29 3d 72 	.word 0x33293d72
  ac:	28 30 2c 33 	lv.adds.h r1,r16,r5
  b0:	29 3b 2d 32 	lv.adds.b r9,r27,r5
  b4:	31 34 37 34 	.word 0x31343734
  b8:	38 33 36 34 	.word 0x38333634
  bc:	38 3b 32 31 	.word 0x383b3231
  c0:	34 37 34 38 	.word 0x34373438
  c4:	33 36 34 37 	.word 0x33363437
  c8:	3b 00 75 6e 	.word 0x3b00756e
  cc:	73 69 67 6e 	l.cust1 
  d0:	65 64 20 69 	.word 0x65642069
  d4:	6e 74 3a 74 	.word 0x6e743a74
  d8:	28 30 2c 34 	lv.addu.b r1,r16,r5
  dc:	29 3d 72 28 	lv.any_lt.b r9,r29,r14
  e0:	30 2c 34 29 	.word 0x302c3429
  e4:	3b 30 30 30 	.word 0x3b303030
  e8:	30 30 30 30 	.word 0x30303030
  ec:	30 30 30 30 	.word 0x30303030
  f0:	30 30 3b 30 	.word 0x30303b30
  f4:	30 33 37 37 	.word 0x30333737
  f8:	37 37 37 37 	.word 0x37373737
  fc:	37 37 37 37 	.word 0x37373737
 100:	3b 00 6c 6f 	.word 0x3b006c6f
 104:	6e 67 20 75 	.word 0x6e672075
 108:	6e 73 69 67 	.word 0x6e736967
 10c:	6e 65 64 20 	.word 0x6e656420
 110:	69 6e 74 3a 	.word 0x696e743a
 114:	74 28 30 2c 	l.cust2 
 118:	35 29 3d 72 	.word 0x35293d72
 11c:	28 30 2c 35 	lv.addu.h r1,r16,r5
 120:	29 3b 30 30 	lv.add.b r9,r27,r6
 124:	30 30 30 30 	.word 0x30303030
 128:	30 30 30 30 	.word 0x30303030
 12c:	30 30 30 3b 	.word 0x3030303b
 130:	30 30 33 37 	.word 0x30303337
 134:	37 37 37 37 	.word 0x37373737
 138:	37 37 37 37 	.word 0x37373737
 13c:	37 3b 00 6c 	.word 0x373b006c
 140:	6f 6e 67 20 	.word 0x6f6e6720
 144:	6c 6f 6e 67 	.word 0x6c6f6e67
 148:	20 69 6e 74 	.word 0x20696e74
 14c:	3a 74 28 30 	.word 0x3a742830
 150:	2c 36 29 3d 	.word 0x2c36293d
 154:	40 73 36 34 	.word 0x40733634
 158:	3b 72 28 30 	.word 0x3b722830
 15c:	2c 36 29 3b 	.word 0x2c36293b
 160:	30 31 30 30 	.word 0x30313030
 164:	30 30 30 30 	.word 0x30303030
 168:	30 30 30 30 	.word 0x30303030
 16c:	30 30 30 30 	.word 0x30303030
 170:	30 30 30 30 	.word 0x30303030
 174:	30 30 30 3b 	.word 0x3030303b
 178:	30 37 37 37 	.word 0x30373737
 17c:	37 37 37 37 	.word 0x37373737
 180:	37 37 37 37 	.word 0x37373737
 184:	37 37 37 37 	.word 0x37373737
 188:	37 37 37 37 	.word 0x37373737
 18c:	37 37 3b 00 	.word 0x37373b00
 190:	6c 6f 6e 67 	.word 0x6c6f6e67
 194:	20 6c 6f 6e 	.word 0x206c6f6e
 198:	67 20 75 6e 	.word 0x6720756e
 19c:	73 69 67 6e 	l.cust1 
 1a0:	65 64 20 69 	.word 0x65642069
 1a4:	6e 74 3a 74 	.word 0x6e743a74
 1a8:	28 30 2c 37 	lv.addus.h r1,r16,r5
 1ac:	29 3d 40 73 	lv.subs.b r9,r29,r8
 1b0:	36 34 3b 72 	.word 0x36343b72
 1b4:	28 30 2c 37 	lv.addus.h r1,r16,r5
 1b8:	29 3b 30 30 	lv.add.b r9,r27,r6
 1bc:	30 30 30 30 	.word 0x30303030
 1c0:	30 30 30 30 	.word 0x30303030
 1c4:	30 30 30 3b 	.word 0x3030303b
 1c8:	30 31 37 37 	.word 0x30313737
 1cc:	37 37 37 37 	.word 0x37373737
 1d0:	37 37 37 37 	.word 0x37373737
 1d4:	37 37 37 37 	.word 0x37373737
 1d8:	37 37 37 37 	.word 0x37373737
 1dc:	37 37 37 3b 	.word 0x3737373b
 1e0:	00 73 68 6f 	l.j 1cda39c <_src_addr+0x1cc9bdc>
 1e4:	72 74 20 69 	l.cust1 
 1e8:	6e 74 3a 74 	.word 0x6e743a74
 1ec:	28 30 2c 38 	lv.and r1,r16,r5
 1f0:	29 3d 40 73 	lv.subs.b r9,r29,r8
 1f4:	31 36 3b 72 	.word 0x31363b72
 1f8:	28 30 2c 38 	lv.and r1,r16,r5
 1fc:	29 3b 2d 33 	lv.adds.h r9,r27,r5
 200:	32 37 36 38 	.word 0x32373638
 204:	3b 33 32 37 	.word 0x3b333237
 208:	36 37 3b 00 	.word 0x36373b00
 20c:	73 68 6f 72 	l.cust1 
 210:	74 20 75 6e 	l.cust2 
 214:	73 69 67 6e 	l.cust1 
 218:	65 64 20 69 	.word 0x65642069
 21c:	6e 74 3a 74 	.word 0x6e743a74
 220:	28 30 2c 39 	lv.avg.b r1,r16,r5
 224:	29 3d 40 73 	lv.subs.b r9,r29,r8
 228:	31 36 3b 72 	.word 0x31363b72
 22c:	28 30 2c 39 	lv.avg.b r1,r16,r5
 230:	29 3b 30 3b 	.word 0x293b303b
 234:	36 35 35 33 	.word 0x36353533
 238:	35 3b 00 73 	.word 0x353b0073
 23c:	69 67 6e 65 	.word 0x69676e65
 240:	64 20 63 68 	.word 0x64206368
 244:	61 72 3a 74 	.word 0x61723a74
 248:	28 30 2c 31 	lv.add.h r1,r16,r5
 24c:	30 29 3d 40 	.word 0x30293d40
 250:	73 38 3b 72 	l.cust1 
 254:	28 30 2c 31 	lv.add.h r1,r16,r5
 258:	30 29 3b 2d 	.word 0x30293b2d
 25c:	31 32 38 3b 	.word 0x3132383b
 260:	31 32 37 3b 	.word 0x3132373b
 264:	00 75 6e 73 	l.j 1d5bc30 <_src_addr+0x1d4b470>
 268:	69 67 6e 65 	.word 0x69676e65
 26c:	64 20 63 68 	.word 0x64206368
 270:	61 72 3a 74 	.word 0x61723a74
 274:	28 30 2c 31 	lv.add.h r1,r16,r5
 278:	31 29 3d 40 	.word 0x31293d40
 27c:	73 38 3b 72 	l.cust1 
 280:	28 30 2c 31 	lv.add.h r1,r16,r5
 284:	31 29 3b 30 	.word 0x31293b30
 288:	3b 32 35 35 	.word 0x3b323535
 28c:	3b 00 66 6c 	.word 0x3b00666c
 290:	6f 61 74 3a 	.word 0x6f61743a
 294:	74 28 30 2c 	l.cust2 
 298:	31 32 29 3d 	.word 0x3132293d
 29c:	72 28 30 2c 	l.cust1 
 2a0:	31 29 3b 34 	.word 0x31293b34
 2a4:	3b 30 3b 00 	.word 0x3b303b00
 2a8:	64 6f 75 62 	.word 0x646f7562
 2ac:	6c 65 3a 74 	.word 0x6c653a74
 2b0:	28 30 2c 31 	lv.add.h r1,r16,r5
 2b4:	33 29 3d 72 	.word 0x33293d72
 2b8:	28 30 2c 31 	lv.add.h r1,r16,r5
 2bc:	29 3b 38 3b 	.word 0x293b383b
 2c0:	30 3b 00 6c 	.word 0x303b006c
 2c4:	6f 6e 67 20 	.word 0x6f6e6720
 2c8:	64 6f 75 62 	.word 0x646f7562
 2cc:	6c 65 3a 74 	.word 0x6c653a74
 2d0:	28 30 2c 31 	lv.add.h r1,r16,r5
 2d4:	34 29 3d 72 	.word 0x34293d72
 2d8:	28 30 2c 31 	lv.add.h r1,r16,r5
 2dc:	29 3b 38 3b 	.word 0x293b383b
 2e0:	30 3b 00 63 	.word 0x303b0063
 2e4:	6f 6d 70 6c 	.word 0x6f6d706c
 2e8:	65 78 20 69 	.word 0x65782069
 2ec:	6e 74 3a 74 	.word 0x6e743a74
 2f0:	28 30 2c 31 	lv.add.h r1,r16,r5
 2f4:	35 29 3d 73 	.word 0x35293d73
 2f8:	38 72 65 61 	.word 0x38726561
 2fc:	6c 3a 28 30 	.word 0x6c3a2830
 300:	2c 31 29 2c 	.word 0x2c31292c
 304:	30 2c 33 32 	.word 0x302c3332
 308:	3b 69 6d 61 	.word 0x3b696d61
 30c:	67 3a 28 30 	.word 0x673a2830
 310:	2c 31 29 2c 	.word 0x2c31292c
 314:	33 32 2c 33 	.word 0x33322c33
 318:	32 3b 3b 00 	.word 0x323b3b00
 31c:	63 6f 6d 70 	.word 0x636f6d70
 320:	6c 65 78 20 	.word 0x6c657820
 324:	66 6c 6f 61 	.word 0x666c6f61
 328:	74 3a 74 28 	l.cust2 
 32c:	30 2c 31 36 	.word 0x302c3136
 330:	29 3d 52 33 	lv.adds.h r9,r29,r10
 334:	3b 38 3b 30 	.word 0x3b383b30
 338:	3b 00 63 6f 	.word 0x3b00636f
 33c:	6d 70 6c 65 	.word 0x6d706c65
 340:	78 20 64 6f 	l.cust3 
 344:	75 62 6c 65 	l.cust2 
 348:	3a 74 28 30 	.word 0x3a742830
 34c:	2c 31 37 29 	.word 0x2c313729
 350:	3d 52 33 3b 	.word 0x3d52333b
 354:	31 36 3b 30 	.word 0x31363b30
 358:	3b 00 63 6f 	.word 0x3b00636f
 35c:	6d 70 6c 65 	.word 0x6d706c65
 360:	78 20 6c 6f 	l.cust3 
 364:	6e 67 20 64 	.word 0x6e672064
 368:	6f 75 62 6c 	.word 0x6f75626c
 36c:	65 3a 74 28 	.word 0x653a7428
 370:	30 2c 31 38 	.word 0x302c3138
 374:	29 3d 52 33 	lv.adds.h r9,r29,r10
 378:	3b 31 36 3b 	.word 0x3b31363b
 37c:	30 3b 00 76 	.word 0x303b0076
 380:	6f 69 64 3a 	.word 0x6f69643a
 384:	74 28 30 2c 	l.cust2 
 388:	31 39 29 3d 	.word 0x3139293d
 38c:	28 30 2c 31 	lv.add.h r1,r16,r5
 390:	39 29 00 5f 	.word 0x3929005f
 394:	5f 62 75 69 	.word 0x5f627569
 398:	6c 74 69 6e 	.word 0x6c74696e
 39c:	5f 76 61 5f 	.word 0x5f76615f
 3a0:	6c 69 73 74 	.word 0x6c697374
 3a4:	3a 74 28 30 	.word 0x3a742830
 3a8:	2c 32 30 29 	.word 0x2c323029
 3ac:	3d 2a 28 30 	.word 0x3d2a2830
 3b0:	2c 31 39 29 	.word 0x2c313929
 3b4:	00 5f 42 6f 	l.j 17d0d70 <_src_addr+0x17c05b0>
 3b8:	6f 6c 3a 74 	.word 0x6f6c3a74
 3bc:	28 30 2c 32 	lv.adds.b r1,r16,r5
 3c0:	31 29 3d 40 	.word 0x31293d40
 3c4:	73 38 3b 2d 	l.cust1 
 3c8:	31 36 3b 00 	.word 0x31363b00
 3cc:	2e 2e 2f 73 	.word 0x2e2e2f73
 3d0:	75 70 70 6f 	l.cust2 
 3d4:	72 74 2f 73 	l.cust1 
 3d8:	75 70 70 6f 	l.cust2 
 3dc:	72 74 2e 68 	l.cust1 
 3e0:	00 2f 6f 70 	l.j bdc1a0 <_src_addr+0xbcb9e0>
 3e4:	74 2f 6f 72 	l.cust2 
 3e8:	33 32 2d 75 	.word 0x33322d75
 3ec:	63 6c 69 6e 	.word 0x636c696e
 3f0:	75 78 2f 6c 	l.cust2 
 3f4:	69 62 2f 67 	.word 0x69622f67
 3f8:	63 63 2f 6f 	.word 0x63632f6f
 3fc:	72 33 32 2d 	l.cust1 
 400:	75 63 6c 69 	l.cust2 
 404:	6e 75 78 2f 	.word 0x6e75782f
 408:	33 2e 34 2e 	.word 0x332e342e
 40c:	34 2f 69 6e 	.word 0x342f696e
 410:	63 6c 75 64 	.word 0x636c7564
 414:	65 2f 73 74 	.word 0x652f7374
 418:	64 61 72 67 	.word 0x64617267
 41c:	2e 68 00 5f 	.word 0x2e68005f
 420:	5f 67 6e 75 	.word 0x5f676e75
 424:	63 5f 76 61 	.word 0x635f7661
 428:	5f 6c 69 73 	.word 0x5f6c6973
 42c:	74 3a 74 28 	l.cust2 
 430:	32 2c 31 29 	.word 0x322c3129
 434:	3d 28 30 2c 	.word 0x3d28302c
 438:	32 30 29 00 	.word 0x32302900
 43c:	76 61 5f 6c 	l.cust2 
 440:	69 73 74 3a 	.word 0x6973743a
 444:	74 28 32 2c 	l.cust2 
 448:	32 29 3d 28 	.word 0x32293d28
 44c:	32 2c 31 29 	.word 0x322c3129
 450:	00 2f 6f 70 	l.j bdc210 <_src_addr+0xbcba50>
 454:	74 2f 6f 72 	l.cust2 
 458:	33 32 2d 75 	.word 0x33322d75
 45c:	63 6c 69 6e 	.word 0x636c696e
 460:	75 78 2f 6c 	l.cust2 
 464:	69 62 2f 67 	.word 0x69622f67
 468:	63 63 2f 6f 	.word 0x63632f6f
 46c:	72 33 32 2d 	l.cust1 
 470:	75 63 6c 69 	l.cust2 
 474:	6e 75 78 2f 	.word 0x6e75782f
 478:	33 2e 34 2e 	.word 0x332e342e
 47c:	34 2f 69 6e 	.word 0x342f696e
 480:	63 6c 75 64 	.word 0x636c7564
 484:	65 2f 73 74 	.word 0x652f7374
 488:	64 64 65 66 	.word 0x64646566
 48c:	2e 68 00 70 	.word 0x2e680070
 490:	74 72 64 69 	l.cust2 
 494:	66 66 5f 74 	.word 0x66665f74
 498:	3a 74 28 33 	.word 0x3a742833
 49c:	2c 31 29 3d 	.word 0x2c31293d
 4a0:	28 30 2c 31 	lv.add.h r1,r16,r5
 4a4:	29 00 73 69 	lv.sll.b r8,r0,r14
 4a8:	7a 65 5f 74 	l.cust3 
 4ac:	3a 74 28 33 	.word 0x3a742833
 4b0:	2c 32 29 3d 	.word 0x2c32293d
 4b4:	28 30 2c 34 	lv.addu.b r1,r16,r5
 4b8:	29 00 77 63 	lv.packs.h r8,r0,r14
 4bc:	68 61 72 5f 	.word 0x6861725f
 4c0:	74 3a 74 28 	l.cust2 
 4c4:	33 2c 33 29 	.word 0x332c3329
 4c8:	3d 28 30 2c 	.word 0x3d28302c
 4cc:	34 29 00 2e 	.word 0x3429002e
 4d0:	2e 2f 73 75 	.word 0x2e2f7375
 4d4:	70 70 6f 72 	l.cust1 
 4d8:	74 2f 69 6e 	l.cust2 
 4dc:	74 2e 68 00 	l.cust2 
 4e0:	69 68 6e 64 	.word 0x69686e64
 4e4:	3a 54 28 34 	.word 0x3a542834
 4e8:	2c 31 29 3d 	.word 0x2c31293d
 4ec:	73 38 68 61 	l.cust1 
 4f0:	6e 64 6c 65 	.word 0x6e646c65
 4f4:	72 3a 28 34 	l.cust1 
 4f8:	2c 32 29 3d 	.word 0x2c32293d
 4fc:	2a 28 34 2c 	.word 0x2a28342c
 500:	33 29 3d 66 	.word 0x33293d66
 504:	28 30 2c 31 	lv.add.h r1,r16,r5
 508:	39 29 2c 30 	.word 0x39292c30
 50c:	2c 33 32 3b 	.word 0x2c33323b
 510:	61 72 67 3a 	.word 0x6172673a
 514:	28 34 2c 34 	lv.addu.b r1,r20,r5
 518:	29 3d 2a 28 	lv.any_lt.b r9,r29,r5
 51c:	30 2c 31 39 	.word 0x302c3139
 520:	29 2c 33 32 	lv.adds.b r9,r12,r6
 524:	2c 33 32 3b 	.word 0x2c33323b
 528:	3b 00 6d 61 	.word 0x3b006d61
 52c:	69 6e 3a 46 	.word 0x696e3a46
 530:	28 30 2c 31 	lv.add.h r1,r16,r5
 534:	29 00 69 3a 	lv.avg.h r8,r0,r13
 538:	72 28 30 2c 	l.cust1 
 53c:	31 29 00 69 	.word 0x31290069
 540:	6c 6c 65 67 	.word 0x6c6c6567
 544:	61 6c 5f 61 	.word 0x616c5f61
 548:	64 64 72 3a 	.word 0x6464723a
 54c:	72 28 30 2c 	l.cust1 
 550:	32 32 29 3d 	.word 0x3232293d
 554:	2a 28 30 2c 	.word 0x2a28302c
 558:	Address 0x00000558 is out of bounds.

Disassembly of section .comment:

00000000 <.comment>:
   0:	00 47 43 43 	l.j 11d0d0c <_src_addr+0x11c054c>
   4:	3a 20 28 47 	.word 0x3a202847
   8:	4e 55 29 20 	l.maci r21,0xffff9120
   c:	33 2e 34 2e 	.word 0x332e342e
  10:	34 00 00 47 	.word 0x34000047
  14:	43 43 3a 20 	.word 0x43433a20
  18:	28 47 4e 55 	lv.max.b r2,r7,r9
  1c:	29 20 33 2e 	.word 0x2920332e
  20:	34 2e 34 00 	.word 0x342e3400
  24:	00 47 43 43 	l.j 11d0d30 <_src_addr+0x11c0570>
  28:	3a 20 28 47 	.word 0x3a202847
  2c:	4e 55 29 20 	l.maci r21,0xffff9120
  30:	33 2e 34 2e 	.word 0x332e342e
  34:	Address 0x00000034 is out of bounds.

