
cbasic-nocache-O0.or32:     file format elf32-or32

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
 194:	a8 63 13 f8 	l.ori r3,r3,0x13f8
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
     2f0:	9c 21 ff 60 	l.addi r1,r1,0xffffff60
     2f4:	d4 01 10 00 	l.sw 0x0(r1),r2
     2f8:	9c 41 00 a0 	l.addi r2,r1,0xa0
     2fc:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     300:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     304:	d7 e2 1f e0 	l.sw 0xffffffe0(r2),r3
     308:	84 62 ff e0 	l.lwz r3,0xffffffe0(r2)
     30c:	bc 03 ff ff 	l.sfeqi r3,0xffffffff
     310:	10 00 00 11 	l.bf 354 <_test_cond+0x64>
     314:	15 00 00 00 	l.nop 0x0
     318:	84 62 ff e0 	l.lwz r3,0xffffffe0(r2)
     31c:	bc 03 00 01 	l.sfeqi r3,0x1
     320:	10 00 00 04 	l.bf 330 <_test_cond+0x40>
     324:	15 00 00 00 	l.nop 0x0
     328:	00 00 00 14 	l.j 378 <_test_cond+0x88>
     32c:	15 00 00 00 	l.nop 0x0
     330:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     334:	d7 e2 1f f4 	l.sw 0xfffffff4(r2),r3
     338:	84 62 ff f4 	l.lwz r3,0xfffffff4(r2)
     33c:	9c 63 00 01 	l.addi r3,r3,0x1
     340:	d7 e2 1f f0 	l.sw 0xfffffff0(r2),r3
     344:	84 62 ff f0 	l.lwz r3,0xfffffff0(r2)
     348:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     34c:	00 00 00 11 	l.j 390 <_test_cond+0xa0>
     350:	15 00 00 00 	l.nop 0x0
     354:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     358:	d7 e2 1f ec 	l.sw 0xffffffec(r2),r3
     35c:	84 62 ff ec 	l.lwz r3,0xffffffec(r2)
     360:	9c 63 ff f6 	l.addi r3,r3,0xfffffff6
     364:	d7 e2 1f e8 	l.sw 0xffffffe8(r2),r3
     368:	84 62 ff e8 	l.lwz r3,0xffffffe8(r2)
     36c:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     370:	00 00 00 08 	l.j 390 <_test_cond+0xa0>
     374:	15 00 00 00 	l.nop 0x0
     378:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     37c:	d7 e2 1f e4 	l.sw 0xffffffe4(r2),r3
     380:	84 62 ff e4 	l.lwz r3,0xffffffe4(r2)
     384:	d7 e2 1f f8 	l.sw 0xfffffff8(r2),r3
     388:	00 00 00 8a 	l.j 5b0 <_test_cond+0x2c0>
     38c:	15 00 00 00 	l.nop 0x0
     390:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     394:	d7 e2 1f dc 	l.sw 0xffffffdc(r2),r3
     398:	84 62 ff dc 	l.lwz r3,0xffffffdc(r2)
     39c:	bc 23 00 02 	l.sfnei r3,0x2
     3a0:	10 00 00 0b 	l.bf 3cc <_test_cond+0xdc>
     3a4:	15 00 00 00 	l.nop 0x0
     3a8:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     3ac:	d7 e2 1f d8 	l.sw 0xffffffd8(r2),r3
     3b0:	84 62 ff d8 	l.lwz r3,0xffffffd8(r2)
     3b4:	9c 63 00 01 	l.addi r3,r3,0x1
     3b8:	d7 e2 1f d4 	l.sw 0xffffffd4(r2),r3
     3bc:	84 62 ff d4 	l.lwz r3,0xffffffd4(r2)
     3c0:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     3c4:	00 00 00 09 	l.j 3e8 <_test_cond+0xf8>
     3c8:	15 00 00 00 	l.nop 0x0
     3cc:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     3d0:	d7 e2 1f d0 	l.sw 0xffffffd0(r2),r3
     3d4:	84 62 ff d0 	l.lwz r3,0xffffffd0(r2)
     3d8:	9c 63 ff f6 	l.addi r3,r3,0xfffffff6
     3dc:	d7 e2 1f cc 	l.sw 0xffffffcc(r2),r3
     3e0:	84 62 ff cc 	l.lwz r3,0xffffffcc(r2)
     3e4:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     3e8:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     3ec:	d7 e2 1f c8 	l.sw 0xffffffc8(r2),r3
     3f0:	84 62 ff c8 	l.lwz r3,0xffffffc8(r2)
     3f4:	bd a3 00 02 	l.sflesi r3,0x2
     3f8:	10 00 00 0b 	l.bf 424 <_test_cond+0x134>
     3fc:	15 00 00 00 	l.nop 0x0
     400:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     404:	d7 e2 1f c4 	l.sw 0xffffffc4(r2),r3
     408:	84 62 ff c4 	l.lwz r3,0xffffffc4(r2)
     40c:	9c 63 00 01 	l.addi r3,r3,0x1
     410:	d7 e2 1f c0 	l.sw 0xffffffc0(r2),r3
     414:	84 62 ff c0 	l.lwz r3,0xffffffc0(r2)
     418:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     41c:	00 00 00 09 	l.j 440 <_test_cond+0x150>
     420:	15 00 00 00 	l.nop 0x0
     424:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     428:	d7 e2 1f bc 	l.sw 0xffffffbc(r2),r3
     42c:	84 62 ff bc 	l.lwz r3,0xffffffbc(r2)
     430:	9c 63 ff f6 	l.addi r3,r3,0xfffffff6
     434:	d7 e2 1f b8 	l.sw 0xffffffb8(r2),r3
     438:	84 62 ff b8 	l.lwz r3,0xffffffb8(r2)
     43c:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     440:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     444:	d7 e2 1f b4 	l.sw 0xffffffb4(r2),r3
     448:	84 62 ff b4 	l.lwz r3,0xffffffb4(r2)
     44c:	bd a3 00 03 	l.sflesi r3,0x3
     450:	10 00 00 0b 	l.bf 47c <_test_cond+0x18c>
     454:	15 00 00 00 	l.nop 0x0
     458:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     45c:	d7 e2 1f b0 	l.sw 0xffffffb0(r2),r3
     460:	84 62 ff b0 	l.lwz r3,0xffffffb0(r2)
     464:	9c 63 00 01 	l.addi r3,r3,0x1
     468:	d7 e2 1f ac 	l.sw 0xffffffac(r2),r3
     46c:	84 62 ff ac 	l.lwz r3,0xffffffac(r2)
     470:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     474:	00 00 00 09 	l.j 498 <_test_cond+0x1a8>
     478:	15 00 00 00 	l.nop 0x0
     47c:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     480:	d7 e2 1f a8 	l.sw 0xffffffa8(r2),r3
     484:	84 62 ff a8 	l.lwz r3,0xffffffa8(r2)
     488:	9c 63 ff f6 	l.addi r3,r3,0xfffffff6
     48c:	d7 e2 1f a4 	l.sw 0xffffffa4(r2),r3
     490:	84 62 ff a4 	l.lwz r3,0xffffffa4(r2)
     494:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     498:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     49c:	d7 e2 1f a0 	l.sw 0xffffffa0(r2),r3
     4a0:	84 62 ff a0 	l.lwz r3,0xffffffa0(r2)
     4a4:	bd 43 00 05 	l.sfgtsi r3,0x5
     4a8:	10 00 00 0b 	l.bf 4d4 <_test_cond+0x1e4>
     4ac:	15 00 00 00 	l.nop 0x0
     4b0:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     4b4:	d7 e2 1f 9c 	l.sw 0xffffff9c(r2),r3
     4b8:	84 62 ff 9c 	l.lwz r3,0xffffff9c(r2)
     4bc:	9c 63 00 01 	l.addi r3,r3,0x1
     4c0:	d7 e2 1f 98 	l.sw 0xffffff98(r2),r3
     4c4:	84 62 ff 98 	l.lwz r3,0xffffff98(r2)
     4c8:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     4cc:	00 00 00 09 	l.j 4f0 <_test_cond+0x200>
     4d0:	15 00 00 00 	l.nop 0x0
     4d4:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     4d8:	d7 e2 1f 94 	l.sw 0xffffff94(r2),r3
     4dc:	84 62 ff 94 	l.lwz r3,0xffffff94(r2)
     4e0:	9c 63 ff f6 	l.addi r3,r3,0xfffffff6
     4e4:	d7 e2 1f 90 	l.sw 0xffffff90(r2),r3
     4e8:	84 62 ff 90 	l.lwz r3,0xffffff90(r2)
     4ec:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     4f0:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     4f4:	d7 e2 1f 8c 	l.sw 0xffffff8c(r2),r3
     4f8:	84 62 ff 8c 	l.lwz r3,0xffffff8c(r2)
     4fc:	bd 43 00 06 	l.sfgtsi r3,0x6
     500:	10 00 00 0b 	l.bf 52c <_test_cond+0x23c>
     504:	15 00 00 00 	l.nop 0x0
     508:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     50c:	d7 e2 1f 88 	l.sw 0xffffff88(r2),r3
     510:	84 62 ff 88 	l.lwz r3,0xffffff88(r2)
     514:	9c 63 00 01 	l.addi r3,r3,0x1
     518:	d7 e2 1f 84 	l.sw 0xffffff84(r2),r3
     51c:	84 62 ff 84 	l.lwz r3,0xffffff84(r2)
     520:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     524:	00 00 00 09 	l.j 548 <_test_cond+0x258>
     528:	15 00 00 00 	l.nop 0x0
     52c:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     530:	d7 e2 1f 80 	l.sw 0xffffff80(r2),r3
     534:	84 62 ff 80 	l.lwz r3,0xffffff80(r2)
     538:	9c 63 ff f6 	l.addi r3,r3,0xfffffff6
     53c:	d7 e2 1f 7c 	l.sw 0xffffff7c(r2),r3
     540:	84 62 ff 7c 	l.lwz r3,0xffffff7c(r2)
     544:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     548:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     54c:	d7 e2 1f 78 	l.sw 0xffffff78(r2),r3
     550:	84 62 ff 78 	l.lwz r3,0xffffff78(r2)
     554:	bc 03 02 9a 	l.sfeqi r3,0x29a
     558:	10 00 00 0b 	l.bf 584 <_test_cond+0x294>
     55c:	15 00 00 00 	l.nop 0x0
     560:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     564:	d7 e2 1f 74 	l.sw 0xffffff74(r2),r3
     568:	84 62 ff 74 	l.lwz r3,0xffffff74(r2)
     56c:	9c 63 00 01 	l.addi r3,r3,0x1
     570:	d7 e2 1f 70 	l.sw 0xffffff70(r2),r3
     574:	84 62 ff 70 	l.lwz r3,0xffffff70(r2)
     578:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     57c:	00 00 00 09 	l.j 5a0 <_test_cond+0x2b0>
     580:	15 00 00 00 	l.nop 0x0
     584:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     588:	d7 e2 1f 6c 	l.sw 0xffffff6c(r2),r3
     58c:	84 62 ff 6c 	l.lwz r3,0xffffff6c(r2)
     590:	9c 63 ff f6 	l.addi r3,r3,0xfffffff6
     594:	d7 e2 1f 68 	l.sw 0xffffff68(r2),r3
     598:	84 62 ff 68 	l.lwz r3,0xffffff68(r2)
     59c:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     5a0:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     5a4:	d7 e2 1f 64 	l.sw 0xffffff64(r2),r3
     5a8:	84 62 ff 64 	l.lwz r3,0xffffff64(r2)
     5ac:	d7 e2 1f f8 	l.sw 0xfffffff8(r2),r3
     5b0:	85 62 ff f8 	l.lwz r11,0xfffffff8(r2)
     5b4:	84 41 00 00 	l.lwz r2,0x0(r1)
     5b8:	44 00 48 00 	l.jr r9
     5bc:	9c 21 00 a0 	l.addi r1,r1,0xa0

000005c0 <_test_loops>:
     5c0:	9c 21 ff c4 	l.addi r1,r1,0xffffffc4
     5c4:	d4 01 10 00 	l.sw 0x0(r1),r2
     5c8:	9c 41 00 3c 	l.addi r2,r1,0x3c
     5cc:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     5d0:	9c 60 00 00 	l.addi r3,r0,0x0
     5d4:	d7 e2 1f f8 	l.sw 0xfffffff8(r2),r3
     5d8:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     5dc:	d7 e2 1f f0 	l.sw 0xfffffff0(r2),r3
     5e0:	84 62 ff f0 	l.lwz r3,0xfffffff0(r2)
     5e4:	bd 43 00 09 	l.sfgtsi r3,0x9
     5e8:	10 00 00 12 	l.bf 630 <_test_loops+0x70>
     5ec:	15 00 00 00 	l.nop 0x0
     5f0:	84 62 ff f8 	l.lwz r3,0xfffffff8(r2)
     5f4:	d7 e2 1f ec 	l.sw 0xffffffec(r2),r3
     5f8:	84 62 ff ec 	l.lwz r3,0xffffffec(r2)
     5fc:	9c 63 00 02 	l.addi r3,r3,0x2
     600:	d7 e2 1f e8 	l.sw 0xffffffe8(r2),r3
     604:	84 62 ff e8 	l.lwz r3,0xffffffe8(r2)
     608:	d7 e2 1f f8 	l.sw 0xfffffff8(r2),r3
     60c:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     610:	d7 e2 1f e4 	l.sw 0xffffffe4(r2),r3
     614:	84 62 ff e4 	l.lwz r3,0xffffffe4(r2)
     618:	9c 63 00 01 	l.addi r3,r3,0x1
     61c:	d7 e2 1f e0 	l.sw 0xffffffe0(r2),r3
     620:	84 62 ff e0 	l.lwz r3,0xffffffe0(r2)
     624:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     628:	03 ff ff ec 	l.j 5d8 <_test_loops+0x18>
     62c:	15 00 00 00 	l.nop 0x0
     630:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     634:	d7 e2 1f dc 	l.sw 0xffffffdc(r2),r3
     638:	84 62 ff dc 	l.lwz r3,0xffffffdc(r2)
     63c:	9c 63 ff fd 	l.addi r3,r3,0xfffffffd
     640:	d7 e2 1f d8 	l.sw 0xffffffd8(r2),r3
     644:	84 62 ff d8 	l.lwz r3,0xffffffd8(r2)
     648:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     64c:	84 62 ff f8 	l.lwz r3,0xfffffff8(r2)
     650:	d7 e2 1f d4 	l.sw 0xffffffd4(r2),r3
     654:	84 62 ff d4 	l.lwz r3,0xffffffd4(r2)
     658:	9c 63 ff ff 	l.addi r3,r3,0xffffffff
     65c:	d7 e2 1f d0 	l.sw 0xffffffd0(r2),r3
     660:	84 62 ff d0 	l.lwz r3,0xffffffd0(r2)
     664:	d7 e2 1f cc 	l.sw 0xffffffcc(r2),r3
     668:	84 62 ff cc 	l.lwz r3,0xffffffcc(r2)
     66c:	d7 e2 1f f8 	l.sw 0xfffffff8(r2),r3
     670:	84 62 ff cc 	l.lwz r3,0xffffffcc(r2)
     674:	bc 03 ff ff 	l.sfeqi r3,0xffffffff
     678:	10 00 00 04 	l.bf 688 <_test_loops+0xc8>
     67c:	15 00 00 00 	l.nop 0x0
     680:	03 ff ff ec 	l.j 630 <_test_loops+0x70>
     684:	15 00 00 00 	l.nop 0x0
     688:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     68c:	d7 e2 1f c8 	l.sw 0xffffffc8(r2),r3
     690:	84 62 ff c8 	l.lwz r3,0xffffffc8(r2)
     694:	d7 e2 1f f4 	l.sw 0xfffffff4(r2),r3
     698:	85 62 ff f4 	l.lwz r11,0xfffffff4(r2)
     69c:	84 41 00 00 	l.lwz r2,0x0(r1)
     6a0:	44 00 48 00 	l.jr r9
     6a4:	9c 21 00 3c 	l.addi r1,r1,0x3c

000006a8 <_test_arith>:
     6a8:	9c 21 ff 88 	l.addi r1,r1,0xffffff88
     6ac:	d4 01 10 04 	l.sw 0x4(r1),r2
     6b0:	9c 41 00 78 	l.addi r2,r1,0x78
     6b4:	d4 01 48 00 	l.sw 0x0(r1),r9
     6b8:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     6bc:	9c 60 00 00 	l.addi r3,r0,0x0
     6c0:	d7 e2 1f f8 	l.sw 0xfffffff8(r2),r3
     6c4:	9c 80 00 00 	l.addi r4,r0,0x0
     6c8:	d7 e2 27 f4 	l.sw 0xfffffff4(r2),r4
     6cc:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     6d0:	d7 e2 1f e8 	l.sw 0xffffffe8(r2),r3
     6d4:	84 82 ff e8 	l.lwz r4,0xffffffe8(r2)
     6d8:	d7 e2 27 f0 	l.sw 0xfffffff0(r2),r4
     6dc:	84 62 ff f0 	l.lwz r3,0xfffffff0(r2)
     6e0:	d7 e2 1f e4 	l.sw 0xffffffe4(r2),r3
     6e4:	84 82 ff e4 	l.lwz r4,0xffffffe4(r2)
     6e8:	bd 44 00 27 	l.sfgtsi r4,0x27
     6ec:	10 00 00 34 	l.bf 7bc <_test_arith+0x114>
     6f0:	15 00 00 00 	l.nop 0x0
     6f4:	84 62 ff f0 	l.lwz r3,0xfffffff0(r2)
     6f8:	d7 e2 1f dc 	l.sw 0xffffffdc(r2),r3
     6fc:	84 82 ff f0 	l.lwz r4,0xfffffff0(r2)
     700:	d7 e2 27 d8 	l.sw 0xffffffd8(r2),r4
     704:	84 62 ff dc 	l.lwz r3,0xffffffdc(r2)
     708:	84 82 ff d8 	l.lwz r4,0xffffffd8(r2)
     70c:	e0 63 23 06 	l.mul r3,r3,r4
     710:	d7 e2 1f e0 	l.sw 0xffffffe0(r2),r3
     714:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     718:	d7 e2 1f d0 	l.sw 0xffffffd0(r2),r3
     71c:	84 82 ff e0 	l.lwz r4,0xffffffe0(r2)
     720:	84 62 ff d0 	l.lwz r3,0xffffffd0(r2)
     724:	e0 84 1b 06 	l.mul r4,r4,r3
     728:	d7 e2 27 d4 	l.sw 0xffffffd4(r2),r4
     72c:	84 82 ff f8 	l.lwz r4,0xfffffff8(r2)
     730:	d7 e2 27 cc 	l.sw 0xffffffcc(r2),r4
     734:	84 62 ff cc 	l.lwz r3,0xffffffcc(r2)
     738:	84 82 ff d4 	l.lwz r4,0xffffffd4(r2)
     73c:	e0 63 20 00 	l.add r3,r3,r4
     740:	d7 e2 1f c8 	l.sw 0xffffffc8(r2),r3
     744:	84 62 ff c8 	l.lwz r3,0xffffffc8(r2)
     748:	d7 e2 1f f8 	l.sw 0xfffffff8(r2),r3
     74c:	84 82 ff f0 	l.lwz r4,0xfffffff0(r2)
     750:	d7 e2 27 c0 	l.sw 0xffffffc0(r2),r4
     754:	84 62 ff f8 	l.lwz r3,0xfffffff8(r2)
     758:	d7 e2 1f bc 	l.sw 0xffffffbc(r2),r3
     75c:	84 82 ff c0 	l.lwz r4,0xffffffc0(r2)
     760:	84 62 ff bc 	l.lwz r3,0xffffffbc(r2)
     764:	e0 84 18 00 	l.add r4,r4,r3
     768:	d7 e2 27 c4 	l.sw 0xffffffc4(r2),r4
     76c:	84 82 ff f4 	l.lwz r4,0xfffffff4(r2)
     770:	d7 e2 27 b4 	l.sw 0xffffffb4(r2),r4
     774:	84 62 ff c4 	l.lwz r3,0xffffffc4(r2)
     778:	84 82 ff b4 	l.lwz r4,0xffffffb4(r2)
     77c:	e0 63 20 00 	l.add r3,r3,r4
     780:	d7 e2 1f b8 	l.sw 0xffffffb8(r2),r3
     784:	84 62 ff b8 	l.lwz r3,0xffffffb8(r2)
     788:	9c 63 00 05 	l.addi r3,r3,0x5
     78c:	d7 e2 1f b0 	l.sw 0xffffffb0(r2),r3
     790:	84 82 ff b0 	l.lwz r4,0xffffffb0(r2)
     794:	d7 e2 27 f4 	l.sw 0xfffffff4(r2),r4
     798:	84 62 ff f0 	l.lwz r3,0xfffffff0(r2)
     79c:	d7 e2 1f ac 	l.sw 0xffffffac(r2),r3
     7a0:	84 82 ff ac 	l.lwz r4,0xffffffac(r2)
     7a4:	9c 84 00 01 	l.addi r4,r4,0x1
     7a8:	d7 e2 27 a8 	l.sw 0xffffffa8(r2),r4
     7ac:	84 62 ff a8 	l.lwz r3,0xffffffa8(r2)
     7b0:	d7 e2 1f f0 	l.sw 0xfffffff0(r2),r3
     7b4:	03 ff ff ca 	l.j 6dc <_test_arith+0x34>
     7b8:	15 00 00 00 	l.nop 0x0
     7bc:	84 82 ff f8 	l.lwz r4,0xfffffff8(r2)
     7c0:	d7 e2 27 a0 	l.sw 0xffffffa0(r2),r4
     7c4:	84 62 ff f4 	l.lwz r3,0xfffffff4(r2)
     7c8:	d7 e2 1f 9c 	l.sw 0xffffff9c(r2),r3
     7cc:	84 82 ff a0 	l.lwz r4,0xffffffa0(r2)
     7d0:	84 62 ff 9c 	l.lwz r3,0xffffff9c(r2)
     7d4:	e0 84 18 00 	l.add r4,r4,r3
     7d8:	d7 e2 27 a4 	l.sw 0xffffffa4(r2),r4
     7dc:	84 62 ff a4 	l.lwz r3,0xffffffa4(r2)
     7e0:	04 00 03 56 	l.jal 1538 <_report>
     7e4:	15 00 00 00 	l.nop 0x0
     7e8:	84 82 ff f8 	l.lwz r4,0xfffffff8(r2)
     7ec:	d7 e2 27 94 	l.sw 0xffffff94(r2),r4
     7f0:	84 62 ff f4 	l.lwz r3,0xfffffff4(r2)
     7f4:	d7 e2 1f 90 	l.sw 0xffffff90(r2),r3
     7f8:	84 82 ff 94 	l.lwz r4,0xffffff94(r2)
     7fc:	84 62 ff 90 	l.lwz r3,0xffffff90(r2)
     800:	e0 84 18 00 	l.add r4,r4,r3
     804:	d7 e2 27 98 	l.sw 0xffffff98(r2),r4
     808:	84 82 ff 98 	l.lwz r4,0xffffff98(r2)
     80c:	d7 e2 27 ec 	l.sw 0xffffffec(r2),r4
     810:	85 62 ff ec 	l.lwz r11,0xffffffec(r2)
     814:	85 21 00 00 	l.lwz r9,0x0(r1)
     818:	84 41 00 04 	l.lwz r2,0x4(r1)
     81c:	44 00 48 00 	l.jr r9
     820:	9c 21 00 78 	l.addi r1,r1,0x78

00000824 <_test_bitop>:
     824:	9c 21 ff 78 	l.addi r1,r1,0xffffff78
     828:	d4 01 10 00 	l.sw 0x0(r1),r2
     82c:	9c 41 00 88 	l.addi r2,r1,0x88
     830:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     834:	9c 60 00 00 	l.addi r3,r0,0x0
     838:	d7 e2 1f f8 	l.sw 0xfffffff8(r2),r3
     83c:	9c 80 00 00 	l.addi r4,r0,0x0
     840:	d7 e2 27 f4 	l.sw 0xfffffff4(r2),r4
     844:	9c 60 00 00 	l.addi r3,r0,0x0
     848:	d7 e2 1f f0 	l.sw 0xfffffff0(r2),r3
     84c:	84 82 ff fc 	l.lwz r4,0xfffffffc(r2)
     850:	d7 e2 27 e4 	l.sw 0xffffffe4(r2),r4
     854:	84 62 ff e4 	l.lwz r3,0xffffffe4(r2)
     858:	d7 e2 1f ec 	l.sw 0xffffffec(r2),r3
     85c:	84 82 ff ec 	l.lwz r4,0xffffffec(r2)
     860:	d7 e2 27 e0 	l.sw 0xffffffe0(r2),r4
     864:	84 62 ff e0 	l.lwz r3,0xffffffe0(r2)
     868:	bd 43 00 22 	l.sfgtsi r3,0x22
     86c:	10 00 00 4d 	l.bf 9a0 <_test_bitop+0x17c>
     870:	15 00 00 00 	l.nop 0x0
     874:	9c 80 00 01 	l.addi r4,r0,0x1
     878:	d7 e2 27 d8 	l.sw 0xffffffd8(r2),r4
     87c:	84 62 ff ec 	l.lwz r3,0xffffffec(r2)
     880:	d7 e2 1f d4 	l.sw 0xffffffd4(r2),r3
     884:	84 82 ff d8 	l.lwz r4,0xffffffd8(r2)
     888:	84 62 ff d4 	l.lwz r3,0xffffffd4(r2)
     88c:	e0 84 18 08 	l.sll r4,r4,r3
     890:	d7 e2 27 dc 	l.sw 0xffffffdc(r2),r4
     894:	84 82 ff f8 	l.lwz r4,0xfffffff8(r2)
     898:	d7 e2 27 d0 	l.sw 0xffffffd0(r2),r4
     89c:	84 62 ff d0 	l.lwz r3,0xffffffd0(r2)
     8a0:	84 82 ff dc 	l.lwz r4,0xffffffdc(r2)
     8a4:	e0 63 20 00 	l.add r3,r3,r4
     8a8:	d7 e2 1f cc 	l.sw 0xffffffcc(r2),r3
     8ac:	84 62 ff cc 	l.lwz r3,0xffffffcc(r2)
     8b0:	d7 e2 1f f8 	l.sw 0xfffffff8(r2),r3
     8b4:	18 80 80 00 	l.movhi r4,0x8000
     8b8:	d7 e2 27 c4 	l.sw 0xffffffc4(r2),r4
     8bc:	84 62 ff ec 	l.lwz r3,0xffffffec(r2)
     8c0:	d7 e2 1f c0 	l.sw 0xffffffc0(r2),r3
     8c4:	84 82 ff c4 	l.lwz r4,0xffffffc4(r2)
     8c8:	84 62 ff c0 	l.lwz r3,0xffffffc0(r2)
     8cc:	e0 84 18 48 	l.srl r4,r4,r3
     8d0:	d7 e2 27 c8 	l.sw 0xffffffc8(r2),r4
     8d4:	84 82 ff f4 	l.lwz r4,0xfffffff4(r2)
     8d8:	d7 e2 27 bc 	l.sw 0xffffffbc(r2),r4
     8dc:	84 62 ff bc 	l.lwz r3,0xffffffbc(r2)
     8e0:	84 82 ff c8 	l.lwz r4,0xffffffc8(r2)
     8e4:	e0 63 20 00 	l.add r3,r3,r4
     8e8:	d7 e2 1f b8 	l.sw 0xffffffb8(r2),r3
     8ec:	84 62 ff b8 	l.lwz r3,0xffffffb8(r2)
     8f0:	d7 e2 1f f4 	l.sw 0xfffffff4(r2),r3
     8f4:	84 82 ff ec 	l.lwz r4,0xffffffec(r2)
     8f8:	d7 e2 27 b0 	l.sw 0xffffffb0(r2),r4
     8fc:	84 62 ff b0 	l.lwz r3,0xffffffb0(r2)
     900:	ac 63 ff ff 	l.xori r3,r3,0xffffffff
     904:	d7 e2 1f b4 	l.sw 0xffffffb4(r2),r3
     908:	18 60 11 22 	l.movhi r3,0x1122
     90c:	a8 63 33 44 	l.ori r3,r3,0x3344
     910:	84 82 ff b4 	l.lwz r4,0xffffffb4(r2)
     914:	e0 64 18 05 	l.xor r3,r4,r3
     918:	d7 e2 1f ac 	l.sw 0xffffffac(r2),r3
     91c:	84 82 ff ec 	l.lwz r4,0xffffffec(r2)
     920:	d7 e2 27 a4 	l.sw 0xffffffa4(r2),r4
     924:	18 80 33 55 	l.movhi r4,0x3355
     928:	a8 84 77 88 	l.ori r4,r4,0x7788
     92c:	84 62 ff a4 	l.lwz r3,0xffffffa4(r2)
     930:	e0 83 20 00 	l.add r4,r3,r4
     934:	d7 e2 27 a8 	l.sw 0xffffffa8(r2),r4
     938:	84 62 ff ac 	l.lwz r3,0xffffffac(r2)
     93c:	84 82 ff a8 	l.lwz r4,0xffffffa8(r2)
     940:	e0 63 20 03 	l.and r3,r3,r4
     944:	d7 e2 1f a0 	l.sw 0xffffffa0(r2),r3
     948:	18 80 11 22 	l.movhi r4,0x1122
     94c:	a8 84 33 44 	l.ori r4,r4,0x3344
     950:	84 62 ff a0 	l.lwz r3,0xffffffa0(r2)
     954:	e0 83 20 04 	l.or r4,r3,r4
     958:	d7 e2 27 9c 	l.sw 0xffffff9c(r2),r4
     95c:	84 62 ff f0 	l.lwz r3,0xfffffff0(r2)
     960:	d7 e2 1f 98 	l.sw 0xffffff98(r2),r3
     964:	84 82 ff 98 	l.lwz r4,0xffffff98(r2)
     968:	84 62 ff 9c 	l.lwz r3,0xffffff9c(r2)
     96c:	e0 84 18 00 	l.add r4,r4,r3
     970:	d7 e2 27 94 	l.sw 0xffffff94(r2),r4
     974:	84 82 ff 94 	l.lwz r4,0xffffff94(r2)
     978:	d7 e2 27 f0 	l.sw 0xfffffff0(r2),r4
     97c:	84 62 ff ec 	l.lwz r3,0xffffffec(r2)
     980:	d7 e2 1f 90 	l.sw 0xffffff90(r2),r3
     984:	84 82 ff 90 	l.lwz r4,0xffffff90(r2)
     988:	9c 84 00 01 	l.addi r4,r4,0x1
     98c:	d7 e2 27 8c 	l.sw 0xffffff8c(r2),r4
     990:	84 62 ff 8c 	l.lwz r3,0xffffff8c(r2)
     994:	d7 e2 1f ec 	l.sw 0xffffffec(r2),r3
     998:	03 ff ff b1 	l.j 85c <_test_bitop+0x38>
     99c:	15 00 00 00 	l.nop 0x0
     9a0:	84 82 ff f8 	l.lwz r4,0xfffffff8(r2)
     9a4:	d7 e2 27 84 	l.sw 0xffffff84(r2),r4
     9a8:	84 62 ff f4 	l.lwz r3,0xfffffff4(r2)
     9ac:	d7 e2 1f 80 	l.sw 0xffffff80(r2),r3
     9b0:	84 82 ff 84 	l.lwz r4,0xffffff84(r2)
     9b4:	84 62 ff 80 	l.lwz r3,0xffffff80(r2)
     9b8:	e0 84 18 00 	l.add r4,r4,r3
     9bc:	d7 e2 27 88 	l.sw 0xffffff88(r2),r4
     9c0:	84 82 ff f0 	l.lwz r4,0xfffffff0(r2)
     9c4:	d7 e2 27 7c 	l.sw 0xffffff7c(r2),r4
     9c8:	84 62 ff 88 	l.lwz r3,0xffffff88(r2)
     9cc:	84 82 ff 7c 	l.lwz r4,0xffffff7c(r2)
     9d0:	e0 63 20 00 	l.add r3,r3,r4
     9d4:	d7 e2 1f 88 	l.sw 0xffffff88(r2),r3
     9d8:	84 62 ff 88 	l.lwz r3,0xffffff88(r2)
     9dc:	d7 e2 1f e8 	l.sw 0xffffffe8(r2),r3
     9e0:	85 62 ff e8 	l.lwz r11,0xffffffe8(r2)
     9e4:	84 41 00 00 	l.lwz r2,0x0(r1)
     9e8:	44 00 48 00 	l.jr r9
     9ec:	9c 21 00 88 	l.addi r1,r1,0x88

000009f0 <_test_types>:
     9f0:	9c 21 ff 74 	l.addi r1,r1,0xffffff74
     9f4:	d4 01 10 00 	l.sw 0x0(r1),r2
     9f8:	9c 41 00 8c 	l.addi r2,r1,0x8c
     9fc:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     a00:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     a04:	d7 e2 1f e0 	l.sw 0xffffffe0(r2),r3
     a08:	18 60 10 20 	l.movhi r3,0x1020
     a0c:	a8 63 30 40 	l.ori r3,r3,0x3040
     a10:	84 82 ff e0 	l.lwz r4,0xffffffe0(r2)
     a14:	e0 64 18 05 	l.xor r3,r4,r3
     a18:	d7 e2 1f dc 	l.sw 0xffffffdc(r2),r3
     a1c:	84 82 ff dc 	l.lwz r4,0xffffffdc(r2)
     a20:	d7 e2 27 fc 	l.sw 0xfffffffc(r2),r4
     a24:	9c 60 00 00 	l.addi r3,r0,0x0
     a28:	d7 e2 1f e8 	l.sw 0xffffffe8(r2),r3
     a2c:	84 82 ff e8 	l.lwz r4,0xffffffe8(r2)
     a30:	d7 e2 27 d8 	l.sw 0xffffffd8(r2),r4
     a34:	84 62 ff d8 	l.lwz r3,0xffffffd8(r2)
     a38:	bd 43 00 09 	l.sfgtsi r3,0x9
     a3c:	10 00 00 4d 	l.bf b70 <_test_types+0x180>
     a40:	15 00 00 00 	l.nop 0x0
     a44:	84 82 ff fc 	l.lwz r4,0xfffffffc(r2)
     a48:	d7 e2 27 d4 	l.sw 0xffffffd4(r2),r4
     a4c:	84 62 ff d4 	l.lwz r3,0xffffffd4(r2)
     a50:	db e2 1f d3 	l.sb 0xffffffd3(r2),r3
     a54:	8c 82 ff d3 	l.lbz r4,0xffffffd3(r2)
     a58:	db e2 27 fb 	l.sb 0xfffffffb(r2),r4
     a5c:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     a60:	d7 e2 1f cc 	l.sw 0xffffffcc(r2),r3
     a64:	84 82 ff cc 	l.lwz r4,0xffffffcc(r2)
     a68:	db e2 27 cb 	l.sb 0xffffffcb(r2),r4
     a6c:	8c 62 ff cb 	l.lbz r3,0xffffffcb(r2)
     a70:	db e2 1f fa 	l.sb 0xfffffffa(r2),r3
     a74:	84 82 ff fc 	l.lwz r4,0xfffffffc(r2)
     a78:	d7 e2 27 c4 	l.sw 0xffffffc4(r2),r4
     a7c:	84 62 ff c4 	l.lwz r3,0xffffffc4(r2)
     a80:	df e2 1f c2 	l.sh 0xffffffc2(r2),r3
     a84:	94 82 ff c2 	l.lhz r4,0xffffffc2(r2)
     a88:	df e2 27 f8 	l.sh 0xfffffff8(r2),r4
     a8c:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     a90:	d7 e2 1f bc 	l.sw 0xffffffbc(r2),r3
     a94:	84 82 ff bc 	l.lwz r4,0xffffffbc(r2)
     a98:	df e2 27 ba 	l.sh 0xffffffba(r2),r4
     a9c:	94 62 ff ba 	l.lhz r3,0xffffffba(r2)
     aa0:	df e2 1f f6 	l.sh 0xfffffff6(r2),r3
     aa4:	84 82 ff fc 	l.lwz r4,0xfffffffc(r2)
     aa8:	d7 e2 27 b4 	l.sw 0xffffffb4(r2),r4
     aac:	84 62 ff b4 	l.lwz r3,0xffffffb4(r2)
     ab0:	d7 e2 1f f0 	l.sw 0xfffffff0(r2),r3
     ab4:	84 82 ff fc 	l.lwz r4,0xfffffffc(r2)
     ab8:	d7 e2 27 b0 	l.sw 0xffffffb0(r2),r4
     abc:	84 62 ff b0 	l.lwz r3,0xffffffb0(r2)
     ac0:	d7 e2 1f ec 	l.sw 0xffffffec(r2),r3
     ac4:	8c 82 ff fb 	l.lbz r4,0xfffffffb(r2)
     ac8:	d7 e2 27 ac 	l.sw 0xffffffac(r2),r4
     acc:	90 62 ff fa 	l.lbs r3,0xfffffffa(r2)
     ad0:	d7 e2 1f a8 	l.sw 0xffffffa8(r2),r3
     ad4:	84 82 ff ac 	l.lwz r4,0xffffffac(r2)
     ad8:	84 62 ff a8 	l.lwz r3,0xffffffa8(r2)
     adc:	e0 84 18 00 	l.add r4,r4,r3
     ae0:	d7 e2 27 a4 	l.sw 0xffffffa4(r2),r4
     ae4:	94 82 ff f8 	l.lhz r4,0xfffffff8(r2)
     ae8:	d7 e2 27 a0 	l.sw 0xffffffa0(r2),r4
     aec:	84 62 ff a4 	l.lwz r3,0xffffffa4(r2)
     af0:	84 82 ff a0 	l.lwz r4,0xffffffa0(r2)
     af4:	e0 63 20 00 	l.add r3,r3,r4
     af8:	d7 e2 1f 9c 	l.sw 0xffffff9c(r2),r3
     afc:	98 62 ff f6 	l.lhs r3,0xfffffff6(r2)
     b00:	d7 e2 1f 98 	l.sw 0xffffff98(r2),r3
     b04:	84 82 ff 9c 	l.lwz r4,0xffffff9c(r2)
     b08:	84 62 ff 98 	l.lwz r3,0xffffff98(r2)
     b0c:	e0 84 18 00 	l.add r4,r4,r3
     b10:	d7 e2 27 94 	l.sw 0xffffff94(r2),r4
     b14:	84 82 ff f0 	l.lwz r4,0xfffffff0(r2)
     b18:	d7 e2 27 8c 	l.sw 0xffffff8c(r2),r4
     b1c:	84 62 ff 94 	l.lwz r3,0xffffff94(r2)
     b20:	84 82 ff 8c 	l.lwz r4,0xffffff8c(r2)
     b24:	e0 63 20 00 	l.add r3,r3,r4
     b28:	d7 e2 1f 90 	l.sw 0xffffff90(r2),r3
     b2c:	84 62 ff ec 	l.lwz r3,0xffffffec(r2)
     b30:	d7 e2 1f 88 	l.sw 0xffffff88(r2),r3
     b34:	84 82 ff 90 	l.lwz r4,0xffffff90(r2)
     b38:	84 62 ff 88 	l.lwz r3,0xffffff88(r2)
     b3c:	e0 84 18 00 	l.add r4,r4,r3
     b40:	d7 e2 27 84 	l.sw 0xffffff84(r2),r4
     b44:	84 82 ff 84 	l.lwz r4,0xffffff84(r2)
     b48:	d7 e2 27 fc 	l.sw 0xfffffffc(r2),r4
     b4c:	84 62 ff e8 	l.lwz r3,0xffffffe8(r2)
     b50:	d7 e2 1f 80 	l.sw 0xffffff80(r2),r3
     b54:	84 82 ff 80 	l.lwz r4,0xffffff80(r2)
     b58:	9c 84 00 01 	l.addi r4,r4,0x1
     b5c:	d7 e2 27 7c 	l.sw 0xffffff7c(r2),r4
     b60:	84 62 ff 7c 	l.lwz r3,0xffffff7c(r2)
     b64:	d7 e2 1f e8 	l.sw 0xffffffe8(r2),r3
     b68:	03 ff ff b1 	l.j a2c <_test_types+0x3c>
     b6c:	15 00 00 00 	l.nop 0x0
     b70:	84 82 ff fc 	l.lwz r4,0xfffffffc(r2)
     b74:	d7 e2 27 78 	l.sw 0xffffff78(r2),r4
     b78:	84 62 ff 78 	l.lwz r3,0xffffff78(r2)
     b7c:	d7 e2 1f e4 	l.sw 0xffffffe4(r2),r3
     b80:	85 62 ff e4 	l.lwz r11,0xffffffe4(r2)
     b84:	84 41 00 00 	l.lwz r2,0x0(r1)
     b88:	44 00 48 00 	l.jr r9
     b8c:	9c 21 00 8c 	l.addi r1,r1,0x8c

00000b90 <_test_array>:
     b90:	9c 21 fd f4 	l.addi r1,r1,0xfffffdf4
     b94:	d4 01 10 04 	l.sw 0x4(r1),r2
     b98:	9c 41 02 0c 	l.addi r2,r1,0x20c
     b9c:	d4 01 48 00 	l.sw 0x0(r1),r9
     ba0:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
     ba4:	18 60 00 00 	l.movhi r3,0x0
     ba8:	a8 63 18 64 	l.ori r3,r3,0x1864
     bac:	d7 e2 1f 64 	l.sw 0xffffff64(r2),r3
     bb0:	9c 82 ff d0 	l.addi r4,r2,0xffffffd0
     bb4:	d7 e2 27 60 	l.sw 0xffffff60(r2),r4
     bb8:	84 62 ff 64 	l.lwz r3,0xffffff64(r2)
     bbc:	d7 e2 1f 5c 	l.sw 0xffffff5c(r2),r3
     bc0:	9c 80 00 29 	l.addi r4,r0,0x29
     bc4:	d7 e2 27 58 	l.sw 0xffffff58(r2),r4
     bc8:	84 62 ff 60 	l.lwz r3,0xffffff60(r2)
     bcc:	84 82 ff 5c 	l.lwz r4,0xffffff5c(r2)
     bd0:	84 a2 ff 58 	l.lwz r5,0xffffff58(r2)
     bd4:	04 00 02 82 	l.jal 15dc <_memcpy>
     bd8:	15 00 00 00 	l.nop 0x0
     bdc:	90 62 ff d5 	l.lbs r3,0xffffffd5(r2)
     be0:	d7 e2 1f 54 	l.sw 0xffffff54(r2),r3
     be4:	84 62 ff 54 	l.lwz r3,0xffffff54(r2)
     be8:	04 00 02 54 	l.jal 1538 <_report>
     bec:	15 00 00 00 	l.nop 0x0
     bf0:	9c 82 ff 6c 	l.addi r4,r2,0xffffff6c
     bf4:	d7 e2 27 50 	l.sw 0xffffff50(r2),r4
     bf8:	9c 62 ff d0 	l.addi r3,r2,0xffffffd0
     bfc:	d7 e2 1f 4c 	l.sw 0xffffff4c(r2),r3
     c00:	84 62 ff 50 	l.lwz r3,0xffffff50(r2)
     c04:	84 82 ff 4c 	l.lwz r4,0xffffff4c(r2)
     c08:	9c a0 00 28 	l.addi r5,r0,0x28
     c0c:	04 00 02 74 	l.jal 15dc <_memcpy>
     c10:	15 00 00 00 	l.nop 0x0
     c14:	90 82 ff d5 	l.lbs r4,0xffffffd5(r2)
     c18:	d7 e2 27 48 	l.sw 0xffffff48(r2),r4
     c1c:	84 62 ff 48 	l.lwz r3,0xffffff48(r2)
     c20:	04 00 02 46 	l.jal 1538 <_report>
     c24:	15 00 00 00 	l.nop 0x0
     c28:	90 62 ff 71 	l.lbs r3,0xffffff71(r2)
     c2c:	d7 e2 1f 44 	l.sw 0xffffff44(r2),r3
     c30:	84 62 ff 44 	l.lwz r3,0xffffff44(r2)
     c34:	04 00 02 41 	l.jal 1538 <_report>
     c38:	15 00 00 00 	l.nop 0x0
     c3c:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
     c40:	04 00 02 3e 	l.jal 1538 <_report>
     c44:	15 00 00 00 	l.nop 0x0
     c48:	90 82 ff 6c 	l.lbs r4,0xffffff6c(r2)
     c4c:	d7 e2 27 40 	l.sw 0xffffff40(r2),r4
     c50:	90 62 ff 6d 	l.lbs r3,0xffffff6d(r2)
     c54:	d7 e2 1f 3c 	l.sw 0xffffff3c(r2),r3
     c58:	84 82 ff 40 	l.lwz r4,0xffffff40(r2)
     c5c:	84 62 ff 3c 	l.lwz r3,0xffffff3c(r2)
     c60:	e0 84 18 00 	l.add r4,r4,r3
     c64:	d7 e2 27 38 	l.sw 0xffffff38(r2),r4
     c68:	90 82 ff 6e 	l.lbs r4,0xffffff6e(r2)
     c6c:	d7 e2 27 34 	l.sw 0xffffff34(r2),r4
     c70:	84 62 ff 38 	l.lwz r3,0xffffff38(r2)
     c74:	84 82 ff 34 	l.lwz r4,0xffffff34(r2)
     c78:	e0 63 20 00 	l.add r3,r3,r4
     c7c:	d7 e2 1f 30 	l.sw 0xffffff30(r2),r3
     c80:	90 62 ff 6f 	l.lbs r3,0xffffff6f(r2)
     c84:	d7 e2 1f 2c 	l.sw 0xffffff2c(r2),r3
     c88:	84 82 ff 30 	l.lwz r4,0xffffff30(r2)
     c8c:	84 62 ff 2c 	l.lwz r3,0xffffff2c(r2)
     c90:	e0 84 18 00 	l.add r4,r4,r3
     c94:	d7 e2 27 28 	l.sw 0xffffff28(r2),r4
     c98:	90 82 ff 70 	l.lbs r4,0xffffff70(r2)
     c9c:	d7 e2 27 24 	l.sw 0xffffff24(r2),r4
     ca0:	84 62 ff 28 	l.lwz r3,0xffffff28(r2)
     ca4:	84 82 ff 24 	l.lwz r4,0xffffff24(r2)
     ca8:	e0 63 20 00 	l.add r3,r3,r4
     cac:	d7 e2 1f 20 	l.sw 0xffffff20(r2),r3
     cb0:	90 62 ff 71 	l.lbs r3,0xffffff71(r2)
     cb4:	d7 e2 1f 1c 	l.sw 0xffffff1c(r2),r3
     cb8:	84 82 ff 20 	l.lwz r4,0xffffff20(r2)
     cbc:	84 62 ff 1c 	l.lwz r3,0xffffff1c(r2)
     cc0:	e0 84 18 00 	l.add r4,r4,r3
     cc4:	d7 e2 27 18 	l.sw 0xffffff18(r2),r4
     cc8:	90 82 ff 72 	l.lbs r4,0xffffff72(r2)
     ccc:	d7 e2 27 14 	l.sw 0xffffff14(r2),r4
     cd0:	84 62 ff 18 	l.lwz r3,0xffffff18(r2)
     cd4:	84 82 ff 14 	l.lwz r4,0xffffff14(r2)
     cd8:	e0 63 20 00 	l.add r3,r3,r4
     cdc:	d7 e2 1f 10 	l.sw 0xffffff10(r2),r3
     ce0:	90 62 ff 73 	l.lbs r3,0xffffff73(r2)
     ce4:	d7 e2 1f 0c 	l.sw 0xffffff0c(r2),r3
     ce8:	84 82 ff 10 	l.lwz r4,0xffffff10(r2)
     cec:	84 62 ff 0c 	l.lwz r3,0xffffff0c(r2)
     cf0:	e0 84 18 00 	l.add r4,r4,r3
     cf4:	d7 e2 27 08 	l.sw 0xffffff08(r2),r4
     cf8:	90 82 ff 74 	l.lbs r4,0xffffff74(r2)
     cfc:	d7 e2 27 04 	l.sw 0xffffff04(r2),r4
     d00:	84 62 ff 08 	l.lwz r3,0xffffff08(r2)
     d04:	84 82 ff 04 	l.lwz r4,0xffffff04(r2)
     d08:	e0 63 20 00 	l.add r3,r3,r4
     d0c:	d7 e2 1f 00 	l.sw 0xffffff00(r2),r3
     d10:	90 62 ff 75 	l.lbs r3,0xffffff75(r2)
     d14:	d7 e2 1e fc 	l.sw 0xfffffefc(r2),r3
     d18:	84 82 ff 00 	l.lwz r4,0xffffff00(r2)
     d1c:	84 62 fe fc 	l.lwz r3,0xfffffefc(r2)
     d20:	e0 84 18 00 	l.add r4,r4,r3
     d24:	d7 e2 26 f8 	l.sw 0xfffffef8(r2),r4
     d28:	90 82 ff 76 	l.lbs r4,0xffffff76(r2)
     d2c:	d7 e2 26 f4 	l.sw 0xfffffef4(r2),r4
     d30:	84 62 fe f8 	l.lwz r3,0xfffffef8(r2)
     d34:	84 82 fe f4 	l.lwz r4,0xfffffef4(r2)
     d38:	e0 63 20 00 	l.add r3,r3,r4
     d3c:	d7 e2 1e f0 	l.sw 0xfffffef0(r2),r3
     d40:	90 62 ff 77 	l.lbs r3,0xffffff77(r2)
     d44:	d7 e2 1e ec 	l.sw 0xfffffeec(r2),r3
     d48:	84 82 fe f0 	l.lwz r4,0xfffffef0(r2)
     d4c:	84 62 fe ec 	l.lwz r3,0xfffffeec(r2)
     d50:	e0 84 18 00 	l.add r4,r4,r3
     d54:	d7 e2 26 e8 	l.sw 0xfffffee8(r2),r4
     d58:	90 82 ff 78 	l.lbs r4,0xffffff78(r2)
     d5c:	d7 e2 26 e4 	l.sw 0xfffffee4(r2),r4
     d60:	84 62 fe e8 	l.lwz r3,0xfffffee8(r2)
     d64:	84 82 fe e4 	l.lwz r4,0xfffffee4(r2)
     d68:	e0 63 20 00 	l.add r3,r3,r4
     d6c:	d7 e2 1e e0 	l.sw 0xfffffee0(r2),r3
     d70:	90 62 ff 79 	l.lbs r3,0xffffff79(r2)
     d74:	d7 e2 1e dc 	l.sw 0xfffffedc(r2),r3
     d78:	84 82 fe e0 	l.lwz r4,0xfffffee0(r2)
     d7c:	84 62 fe dc 	l.lwz r3,0xfffffedc(r2)
     d80:	e0 84 18 00 	l.add r4,r4,r3
     d84:	d7 e2 26 d8 	l.sw 0xfffffed8(r2),r4
     d88:	90 82 ff 7a 	l.lbs r4,0xffffff7a(r2)
     d8c:	d7 e2 26 d4 	l.sw 0xfffffed4(r2),r4
     d90:	84 62 fe d8 	l.lwz r3,0xfffffed8(r2)
     d94:	84 82 fe d4 	l.lwz r4,0xfffffed4(r2)
     d98:	e0 63 20 00 	l.add r3,r3,r4
     d9c:	d7 e2 1e d0 	l.sw 0xfffffed0(r2),r3
     da0:	90 62 ff 7b 	l.lbs r3,0xffffff7b(r2)
     da4:	d7 e2 1e cc 	l.sw 0xfffffecc(r2),r3
     da8:	84 82 fe d0 	l.lwz r4,0xfffffed0(r2)
     dac:	84 62 fe cc 	l.lwz r3,0xfffffecc(r2)
     db0:	e0 84 18 00 	l.add r4,r4,r3
     db4:	d7 e2 26 c8 	l.sw 0xfffffec8(r2),r4
     db8:	90 82 ff 7c 	l.lbs r4,0xffffff7c(r2)
     dbc:	d7 e2 26 c4 	l.sw 0xfffffec4(r2),r4
     dc0:	84 62 fe c8 	l.lwz r3,0xfffffec8(r2)
     dc4:	84 82 fe c4 	l.lwz r4,0xfffffec4(r2)
     dc8:	e0 63 20 00 	l.add r3,r3,r4
     dcc:	d7 e2 1e c0 	l.sw 0xfffffec0(r2),r3
     dd0:	90 62 ff 7d 	l.lbs r3,0xffffff7d(r2)
     dd4:	d7 e2 1e bc 	l.sw 0xfffffebc(r2),r3
     dd8:	84 82 fe c0 	l.lwz r4,0xfffffec0(r2)
     ddc:	84 62 fe bc 	l.lwz r3,0xfffffebc(r2)
     de0:	e0 84 18 00 	l.add r4,r4,r3
     de4:	d7 e2 26 b8 	l.sw 0xfffffeb8(r2),r4
     de8:	90 82 ff 7e 	l.lbs r4,0xffffff7e(r2)
     dec:	d7 e2 26 b4 	l.sw 0xfffffeb4(r2),r4
     df0:	84 62 fe b8 	l.lwz r3,0xfffffeb8(r2)
     df4:	84 82 fe b4 	l.lwz r4,0xfffffeb4(r2)
     df8:	e0 63 20 00 	l.add r3,r3,r4
     dfc:	d7 e2 1e b0 	l.sw 0xfffffeb0(r2),r3
     e00:	90 62 ff 7f 	l.lbs r3,0xffffff7f(r2)
     e04:	d7 e2 1e ac 	l.sw 0xfffffeac(r2),r3
     e08:	84 82 fe b0 	l.lwz r4,0xfffffeb0(r2)
     e0c:	84 62 fe ac 	l.lwz r3,0xfffffeac(r2)
     e10:	e0 84 18 00 	l.add r4,r4,r3
     e14:	d7 e2 26 a8 	l.sw 0xfffffea8(r2),r4
     e18:	90 82 ff 80 	l.lbs r4,0xffffff80(r2)
     e1c:	d7 e2 26 a4 	l.sw 0xfffffea4(r2),r4
     e20:	84 62 fe a8 	l.lwz r3,0xfffffea8(r2)
     e24:	84 82 fe a4 	l.lwz r4,0xfffffea4(r2)
     e28:	e0 63 20 00 	l.add r3,r3,r4
     e2c:	d7 e2 1e a0 	l.sw 0xfffffea0(r2),r3
     e30:	90 62 ff 81 	l.lbs r3,0xffffff81(r2)
     e34:	d7 e2 1e 9c 	l.sw 0xfffffe9c(r2),r3
     e38:	84 82 fe a0 	l.lwz r4,0xfffffea0(r2)
     e3c:	84 62 fe 9c 	l.lwz r3,0xfffffe9c(r2)
     e40:	e0 84 18 00 	l.add r4,r4,r3
     e44:	d7 e2 26 98 	l.sw 0xfffffe98(r2),r4
     e48:	90 82 ff 82 	l.lbs r4,0xffffff82(r2)
     e4c:	d7 e2 26 94 	l.sw 0xfffffe94(r2),r4
     e50:	84 62 fe 98 	l.lwz r3,0xfffffe98(r2)
     e54:	84 82 fe 94 	l.lwz r4,0xfffffe94(r2)
     e58:	e0 63 20 00 	l.add r3,r3,r4
     e5c:	d7 e2 1e 90 	l.sw 0xfffffe90(r2),r3
     e60:	90 62 ff 83 	l.lbs r3,0xffffff83(r2)
     e64:	d7 e2 1e 8c 	l.sw 0xfffffe8c(r2),r3
     e68:	84 82 fe 90 	l.lwz r4,0xfffffe90(r2)
     e6c:	84 62 fe 8c 	l.lwz r3,0xfffffe8c(r2)
     e70:	e0 84 18 00 	l.add r4,r4,r3
     e74:	d7 e2 26 88 	l.sw 0xfffffe88(r2),r4
     e78:	90 82 ff 84 	l.lbs r4,0xffffff84(r2)
     e7c:	d7 e2 26 84 	l.sw 0xfffffe84(r2),r4
     e80:	84 62 fe 88 	l.lwz r3,0xfffffe88(r2)
     e84:	84 82 fe 84 	l.lwz r4,0xfffffe84(r2)
     e88:	e0 63 20 00 	l.add r3,r3,r4
     e8c:	d7 e2 1e 80 	l.sw 0xfffffe80(r2),r3
     e90:	90 62 ff 85 	l.lbs r3,0xffffff85(r2)
     e94:	d7 e2 1e 7c 	l.sw 0xfffffe7c(r2),r3
     e98:	84 82 fe 80 	l.lwz r4,0xfffffe80(r2)
     e9c:	84 62 fe 7c 	l.lwz r3,0xfffffe7c(r2)
     ea0:	e0 84 18 00 	l.add r4,r4,r3
     ea4:	d7 e2 26 78 	l.sw 0xfffffe78(r2),r4
     ea8:	90 82 ff 86 	l.lbs r4,0xffffff86(r2)
     eac:	d7 e2 26 74 	l.sw 0xfffffe74(r2),r4
     eb0:	84 62 fe 78 	l.lwz r3,0xfffffe78(r2)
     eb4:	84 82 fe 74 	l.lwz r4,0xfffffe74(r2)
     eb8:	e0 63 20 00 	l.add r3,r3,r4
     ebc:	d7 e2 1e 70 	l.sw 0xfffffe70(r2),r3
     ec0:	90 62 ff 87 	l.lbs r3,0xffffff87(r2)
     ec4:	d7 e2 1e 6c 	l.sw 0xfffffe6c(r2),r3
     ec8:	84 82 fe 70 	l.lwz r4,0xfffffe70(r2)
     ecc:	84 62 fe 6c 	l.lwz r3,0xfffffe6c(r2)
     ed0:	e0 84 18 00 	l.add r4,r4,r3
     ed4:	d7 e2 26 68 	l.sw 0xfffffe68(r2),r4
     ed8:	90 82 ff 88 	l.lbs r4,0xffffff88(r2)
     edc:	d7 e2 26 64 	l.sw 0xfffffe64(r2),r4
     ee0:	84 62 fe 68 	l.lwz r3,0xfffffe68(r2)
     ee4:	84 82 fe 64 	l.lwz r4,0xfffffe64(r2)
     ee8:	e0 63 20 00 	l.add r3,r3,r4
     eec:	d7 e2 1e 60 	l.sw 0xfffffe60(r2),r3
     ef0:	90 62 ff 89 	l.lbs r3,0xffffff89(r2)
     ef4:	d7 e2 1e 5c 	l.sw 0xfffffe5c(r2),r3
     ef8:	84 82 fe 60 	l.lwz r4,0xfffffe60(r2)
     efc:	84 62 fe 5c 	l.lwz r3,0xfffffe5c(r2)
     f00:	e0 84 18 00 	l.add r4,r4,r3
     f04:	d7 e2 26 58 	l.sw 0xfffffe58(r2),r4
     f08:	90 82 ff 8a 	l.lbs r4,0xffffff8a(r2)
     f0c:	d7 e2 26 54 	l.sw 0xfffffe54(r2),r4
     f10:	84 62 fe 58 	l.lwz r3,0xfffffe58(r2)
     f14:	84 82 fe 54 	l.lwz r4,0xfffffe54(r2)
     f18:	e0 63 20 00 	l.add r3,r3,r4
     f1c:	d7 e2 1e 50 	l.sw 0xfffffe50(r2),r3
     f20:	90 62 ff 8b 	l.lbs r3,0xffffff8b(r2)
     f24:	d7 e2 1e 4c 	l.sw 0xfffffe4c(r2),r3
     f28:	84 82 fe 50 	l.lwz r4,0xfffffe50(r2)
     f2c:	84 62 fe 4c 	l.lwz r3,0xfffffe4c(r2)
     f30:	e0 84 18 00 	l.add r4,r4,r3
     f34:	d7 e2 26 48 	l.sw 0xfffffe48(r2),r4
     f38:	90 82 ff 8c 	l.lbs r4,0xffffff8c(r2)
     f3c:	d7 e2 26 44 	l.sw 0xfffffe44(r2),r4
     f40:	84 62 fe 48 	l.lwz r3,0xfffffe48(r2)
     f44:	84 82 fe 44 	l.lwz r4,0xfffffe44(r2)
     f48:	e0 63 20 00 	l.add r3,r3,r4
     f4c:	d7 e2 1e 40 	l.sw 0xfffffe40(r2),r3
     f50:	90 62 ff 8d 	l.lbs r3,0xffffff8d(r2)
     f54:	d7 e2 1e 3c 	l.sw 0xfffffe3c(r2),r3
     f58:	84 82 fe 40 	l.lwz r4,0xfffffe40(r2)
     f5c:	84 62 fe 3c 	l.lwz r3,0xfffffe3c(r2)
     f60:	e0 84 18 00 	l.add r4,r4,r3
     f64:	d7 e2 26 38 	l.sw 0xfffffe38(r2),r4
     f68:	90 82 ff 8e 	l.lbs r4,0xffffff8e(r2)
     f6c:	d7 e2 26 34 	l.sw 0xfffffe34(r2),r4
     f70:	84 62 fe 38 	l.lwz r3,0xfffffe38(r2)
     f74:	84 82 fe 34 	l.lwz r4,0xfffffe34(r2)
     f78:	e0 63 20 00 	l.add r3,r3,r4
     f7c:	d7 e2 1e 30 	l.sw 0xfffffe30(r2),r3
     f80:	90 62 ff 8f 	l.lbs r3,0xffffff8f(r2)
     f84:	d7 e2 1e 2c 	l.sw 0xfffffe2c(r2),r3
     f88:	84 82 fe 30 	l.lwz r4,0xfffffe30(r2)
     f8c:	84 62 fe 2c 	l.lwz r3,0xfffffe2c(r2)
     f90:	e0 84 18 00 	l.add r4,r4,r3
     f94:	d7 e2 26 28 	l.sw 0xfffffe28(r2),r4
     f98:	90 82 ff 90 	l.lbs r4,0xffffff90(r2)
     f9c:	d7 e2 26 24 	l.sw 0xfffffe24(r2),r4
     fa0:	84 62 fe 28 	l.lwz r3,0xfffffe28(r2)
     fa4:	84 82 fe 24 	l.lwz r4,0xfffffe24(r2)
     fa8:	e0 63 20 00 	l.add r3,r3,r4
     fac:	d7 e2 1e 20 	l.sw 0xfffffe20(r2),r3
     fb0:	90 62 ff 91 	l.lbs r3,0xffffff91(r2)
     fb4:	d7 e2 1e 1c 	l.sw 0xfffffe1c(r2),r3
     fb8:	84 82 fe 20 	l.lwz r4,0xfffffe20(r2)
     fbc:	84 62 fe 1c 	l.lwz r3,0xfffffe1c(r2)
     fc0:	e0 84 18 00 	l.add r4,r4,r3
     fc4:	d7 e2 26 18 	l.sw 0xfffffe18(r2),r4
     fc8:	90 82 ff 92 	l.lbs r4,0xffffff92(r2)
     fcc:	d7 e2 26 14 	l.sw 0xfffffe14(r2),r4
     fd0:	84 62 fe 18 	l.lwz r3,0xfffffe18(r2)
     fd4:	84 82 fe 14 	l.lwz r4,0xfffffe14(r2)
     fd8:	e0 63 20 00 	l.add r3,r3,r4
     fdc:	d7 e2 1e 10 	l.sw 0xfffffe10(r2),r3
     fe0:	90 62 ff 93 	l.lbs r3,0xffffff93(r2)
     fe4:	d7 e2 1e 0c 	l.sw 0xfffffe0c(r2),r3
     fe8:	84 82 fe 10 	l.lwz r4,0xfffffe10(r2)
     fec:	84 62 fe 0c 	l.lwz r3,0xfffffe0c(r2)
     ff0:	e0 84 18 00 	l.add r4,r4,r3
     ff4:	d7 e2 26 08 	l.sw 0xfffffe08(r2),r4
     ff8:	84 82 ff fc 	l.lwz r4,0xfffffffc(r2)
     ffc:	d7 e2 26 04 	l.sw 0xfffffe04(r2),r4
    1000:	84 62 fe 04 	l.lwz r3,0xfffffe04(r2)
    1004:	84 82 fe 08 	l.lwz r4,0xfffffe08(r2)
    1008:	e0 63 20 00 	l.add r3,r3,r4
    100c:	d7 e2 1e 00 	l.sw 0xfffffe00(r2),r3
    1010:	84 62 fe 00 	l.lwz r3,0xfffffe00(r2)
    1014:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
    1018:	84 62 ff fc 	l.lwz r3,0xfffffffc(r2)
    101c:	04 00 01 47 	l.jal 1538 <_report>
    1020:	15 00 00 00 	l.nop 0x0
    1024:	84 82 ff fc 	l.lwz r4,0xfffffffc(r2)
    1028:	d7 e2 25 fc 	l.sw 0xfffffdfc(r2),r4
    102c:	84 62 fd fc 	l.lwz r3,0xfffffdfc(r2)
    1030:	d7 e2 1f 68 	l.sw 0xffffff68(r2),r3
    1034:	85 62 ff 68 	l.lwz r11,0xffffff68(r2)
    1038:	85 21 00 00 	l.lwz r9,0x0(r1)
    103c:	84 41 00 04 	l.lwz r2,0x4(r1)
    1040:	44 00 48 00 	l.jr r9
    1044:	9c 21 02 0c 	l.addi r1,r1,0x20c

00001048 <_main>:
    1048:	9c 21 ff 20 	l.addi r1,r1,0xffffff20
    104c:	d4 01 10 0c 	l.sw 0xc(r1),r2
    1050:	9c 41 00 e0 	l.addi r2,r1,0xe0
    1054:	d4 01 48 08 	l.sw 0x8(r1),r9
    1058:	9c 60 00 00 	l.addi r3,r0,0x0
    105c:	d7 e2 1f fc 	l.sw 0xfffffffc(r2),r3
    1060:	9c 80 00 00 	l.addi r4,r0,0x0
    1064:	d7 e2 27 f8 	l.sw 0xfffffff8(r2),r4
    1068:	9c 60 00 00 	l.addi r3,r0,0x0
    106c:	d7 e2 1f f4 	l.sw 0xfffffff4(r2),r3
    1070:	9c 60 00 01 	l.addi r3,r0,0x1
    1074:	07 ff fc 9f 	l.jal 2f0 <_test_cond>
    1078:	15 00 00 00 	l.nop 0x0
    107c:	d7 e2 5f f0 	l.sw 0xfffffff0(r2),r11
    1080:	84 82 ff f0 	l.lwz r4,0xfffffff0(r2)
    1084:	d7 e2 27 fc 	l.sw 0xfffffffc(r2),r4
    1088:	9c 60 ff ff 	l.addi r3,r0,0xffffffff
    108c:	07 ff fc 99 	l.jal 2f0 <_test_cond>
    1090:	15 00 00 00 	l.nop 0x0
    1094:	d7 e2 5f ec 	l.sw 0xffffffec(r2),r11
    1098:	84 62 ff ec 	l.lwz r3,0xffffffec(r2)
    109c:	d7 e2 1f f8 	l.sw 0xfffffff8(r2),r3
    10a0:	84 82 ff fc 	l.lwz r4,0xfffffffc(r2)
    10a4:	d7 e2 27 e4 	l.sw 0xffffffe4(r2),r4
    10a8:	84 62 ff f8 	l.lwz r3,0xfffffff8(r2)
    10ac:	d7 e2 1f e0 	l.sw 0xffffffe0(r2),r3
    10b0:	84 82 ff e4 	l.lwz r4,0xffffffe4(r2)
    10b4:	84 62 ff e0 	l.lwz r3,0xffffffe0(r2)
    10b8:	e0 84 18 00 	l.add r4,r4,r3
    10bc:	d7 e2 27 e8 	l.sw 0xffffffe8(r2),r4
    10c0:	84 82 ff f4 	l.lwz r4,0xfffffff4(r2)
    10c4:	d7 e2 27 dc 	l.sw 0xffffffdc(r2),r4
    10c8:	84 62 ff dc 	l.lwz r3,0xffffffdc(r2)
    10cc:	84 82 ff e8 	l.lwz r4,0xffffffe8(r2)
    10d0:	e0 63 20 02 	l.sub r3,r3,r4
    10d4:	d7 e2 1f d8 	l.sw 0xffffffd8(r2),r3
    10d8:	84 62 ff d8 	l.lwz r3,0xffffffd8(r2)
    10dc:	d7 e2 1f f4 	l.sw 0xfffffff4(r2),r3
    10e0:	84 62 ff f8 	l.lwz r3,0xfffffff8(r2)
    10e4:	04 00 01 15 	l.jal 1538 <_report>
    10e8:	15 00 00 00 	l.nop 0x0
    10ec:	9c 60 00 01 	l.addi r3,r0,0x1
    10f0:	07 ff fd 34 	l.jal 5c0 <_test_loops>
    10f4:	15 00 00 00 	l.nop 0x0
    10f8:	d7 e2 5f d4 	l.sw 0xffffffd4(r2),r11
    10fc:	84 82 ff d4 	l.lwz r4,0xffffffd4(r2)
    1100:	d7 e2 27 fc 	l.sw 0xfffffffc(r2),r4
    1104:	9c 60 ff ff 	l.addi r3,r0,0xffffffff
    1108:	07 ff fd 2e 	l.jal 5c0 <_test_loops>
    110c:	15 00 00 00 	l.nop 0x0
    1110:	d7 e2 5f d0 	l.sw 0xffffffd0(r2),r11
    1114:	84 62 ff d0 	l.lwz r3,0xffffffd0(r2)
    1118:	d7 e2 1f f8 	l.sw 0xfffffff8(r2),r3
    111c:	84 82 ff fc 	l.lwz r4,0xfffffffc(r2)
    1120:	d7 e2 27 c8 	l.sw 0xffffffc8(r2),r4
    1124:	84 62 ff f8 	l.lwz r3,0xfffffff8(r2)
    1128:	d7 e2 1f c4 	l.sw 0xffffffc4(r2),r3
    112c:	84 82 ff c8 	l.lwz r4,0xffffffc8(r2)
    1130:	84 62 ff c4 	l.lwz r3,0xffffffc4(r2)
    1134:	e0 84 18 00 	l.add r4,r4,r3
    1138:	d7 e2 27 cc 	l.sw 0xffffffcc(r2),r4
    113c:	84 82 ff f4 	l.lwz r4,0xfffffff4(r2)
    1140:	d7 e2 27 c0 	l.sw 0xffffffc0(r2),r4
    1144:	84 62 ff c0 	l.lwz r3,0xffffffc0(r2)
    1148:	84 82 ff cc 	l.lwz r4,0xffffffcc(r2)
    114c:	e0 63 20 02 	l.sub r3,r3,r4
    1150:	d7 e2 1f bc 	l.sw 0xffffffbc(r2),r3
    1154:	84 62 ff bc 	l.lwz r3,0xffffffbc(r2)
    1158:	d7 e2 1f f4 	l.sw 0xfffffff4(r2),r3
    115c:	84 62 ff f8 	l.lwz r3,0xfffffff8(r2)
    1160:	04 00 00 f6 	l.jal 1538 <_report>
    1164:	15 00 00 00 	l.nop 0x0
    1168:	9c 60 00 01 	l.addi r3,r0,0x1
    116c:	07 ff fd 4f 	l.jal 6a8 <_test_arith>
    1170:	15 00 00 00 	l.nop 0x0
    1174:	d7 e2 5f b8 	l.sw 0xffffffb8(r2),r11
    1178:	84 82 ff b8 	l.lwz r4,0xffffffb8(r2)
    117c:	d7 e2 27 fc 	l.sw 0xfffffffc(r2),r4
    1180:	9c 60 ff ff 	l.addi r3,r0,0xffffffff
    1184:	07 ff fd 49 	l.jal 6a8 <_test_arith>
    1188:	15 00 00 00 	l.nop 0x0
    118c:	d7 e2 5f b4 	l.sw 0xffffffb4(r2),r11
    1190:	84 62 ff b4 	l.lwz r3,0xffffffb4(r2)
    1194:	d7 e2 1f f8 	l.sw 0xfffffff8(r2),r3
    1198:	84 82 ff fc 	l.lwz r4,0xfffffffc(r2)
    119c:	d7 e2 27 ac 	l.sw 0xffffffac(r2),r4
    11a0:	84 62 ff f8 	l.lwz r3,0xfffffff8(r2)
    11a4:	d7 e2 1f a8 	l.sw 0xffffffa8(r2),r3
    11a8:	84 82 ff ac 	l.lwz r4,0xffffffac(r2)
    11ac:	84 62 ff a8 	l.lwz r3,0xffffffa8(r2)
    11b0:	e0 84 18 00 	l.add r4,r4,r3
    11b4:	d7 e2 27 b0 	l.sw 0xffffffb0(r2),r4
    11b8:	84 82 ff f4 	l.lwz r4,0xfffffff4(r2)
    11bc:	d7 e2 27 a4 	l.sw 0xffffffa4(r2),r4
    11c0:	84 62 ff a4 	l.lwz r3,0xffffffa4(r2)
    11c4:	84 82 ff b0 	l.lwz r4,0xffffffb0(r2)
    11c8:	e0 63 20 02 	l.sub r3,r3,r4
    11cc:	d7 e2 1f a0 	l.sw 0xffffffa0(r2),r3
    11d0:	84 62 ff a0 	l.lwz r3,0xffffffa0(r2)
    11d4:	d7 e2 1f f4 	l.sw 0xfffffff4(r2),r3
    11d8:	84 62 ff f8 	l.lwz r3,0xfffffff8(r2)
    11dc:	04 00 00 d7 	l.jal 1538 <_report>
    11e0:	15 00 00 00 	l.nop 0x0
    11e4:	9c 60 00 01 	l.addi r3,r0,0x1
    11e8:	07 ff fd 8f 	l.jal 824 <_test_bitop>
    11ec:	15 00 00 00 	l.nop 0x0
    11f0:	d7 e2 5f 9c 	l.sw 0xffffff9c(r2),r11
    11f4:	84 82 ff 9c 	l.lwz r4,0xffffff9c(r2)
    11f8:	d7 e2 27 fc 	l.sw 0xfffffffc(r2),r4
    11fc:	9c 60 ff ff 	l.addi r3,r0,0xffffffff
    1200:	07 ff fd 89 	l.jal 824 <_test_bitop>
    1204:	15 00 00 00 	l.nop 0x0
    1208:	d7 e2 5f 98 	l.sw 0xffffff98(r2),r11
    120c:	84 62 ff 98 	l.lwz r3,0xffffff98(r2)
    1210:	d7 e2 1f f8 	l.sw 0xfffffff8(r2),r3
    1214:	84 82 ff fc 	l.lwz r4,0xfffffffc(r2)
    1218:	d7 e2 27 90 	l.sw 0xffffff90(r2),r4
    121c:	84 62 ff f8 	l.lwz r3,0xfffffff8(r2)
    1220:	d7 e2 1f 8c 	l.sw 0xffffff8c(r2),r3
    1224:	84 82 ff 90 	l.lwz r4,0xffffff90(r2)
    1228:	84 62 ff 8c 	l.lwz r3,0xffffff8c(r2)
    122c:	e0 84 18 00 	l.add r4,r4,r3
    1230:	d7 e2 27 94 	l.sw 0xffffff94(r2),r4
    1234:	84 82 ff f4 	l.lwz r4,0xfffffff4(r2)
    1238:	d7 e2 27 88 	l.sw 0xffffff88(r2),r4
    123c:	84 62 ff 88 	l.lwz r3,0xffffff88(r2)
    1240:	84 82 ff 94 	l.lwz r4,0xffffff94(r2)
    1244:	e0 63 20 02 	l.sub r3,r3,r4
    1248:	d7 e2 1f 84 	l.sw 0xffffff84(r2),r3
    124c:	84 62 ff 84 	l.lwz r3,0xffffff84(r2)
    1250:	d7 e2 1f f4 	l.sw 0xfffffff4(r2),r3
    1254:	84 62 ff f8 	l.lwz r3,0xfffffff8(r2)
    1258:	04 00 00 b8 	l.jal 1538 <_report>
    125c:	15 00 00 00 	l.nop 0x0
    1260:	9c 60 00 01 	l.addi r3,r0,0x1
    1264:	07 ff fd e3 	l.jal 9f0 <_test_types>
    1268:	15 00 00 00 	l.nop 0x0
    126c:	d7 e2 5f 80 	l.sw 0xffffff80(r2),r11
    1270:	84 82 ff 80 	l.lwz r4,0xffffff80(r2)
    1274:	d7 e2 27 fc 	l.sw 0xfffffffc(r2),r4
    1278:	9c 60 ff ff 	l.addi r3,r0,0xffffffff
    127c:	07 ff fd dd 	l.jal 9f0 <_test_types>
    1280:	15 00 00 00 	l.nop 0x0
    1284:	d7 e2 5f 7c 	l.sw 0xffffff7c(r2),r11
    1288:	84 62 ff 7c 	l.lwz r3,0xffffff7c(r2)
    128c:	d7 e2 1f f8 	l.sw 0xfffffff8(r2),r3
    1290:	84 82 ff fc 	l.lwz r4,0xfffffffc(r2)
    1294:	d7 e2 27 74 	l.sw 0xffffff74(r2),r4
    1298:	84 62 ff f8 	l.lwz r3,0xfffffff8(r2)
    129c:	d7 e2 1f 70 	l.sw 0xffffff70(r2),r3
    12a0:	84 82 ff 74 	l.lwz r4,0xffffff74(r2)
    12a4:	84 62 ff 70 	l.lwz r3,0xffffff70(r2)
    12a8:	e0 84 18 00 	l.add r4,r4,r3
    12ac:	d7 e2 27 78 	l.sw 0xffffff78(r2),r4
    12b0:	84 82 ff f4 	l.lwz r4,0xfffffff4(r2)
    12b4:	d7 e2 27 6c 	l.sw 0xffffff6c(r2),r4
    12b8:	84 62 ff 6c 	l.lwz r3,0xffffff6c(r2)
    12bc:	84 82 ff 78 	l.lwz r4,0xffffff78(r2)
    12c0:	e0 63 20 02 	l.sub r3,r3,r4
    12c4:	d7 e2 1f 68 	l.sw 0xffffff68(r2),r3
    12c8:	84 62 ff 68 	l.lwz r3,0xffffff68(r2)
    12cc:	d7 e2 1f f4 	l.sw 0xfffffff4(r2),r3
    12d0:	84 62 ff f8 	l.lwz r3,0xfffffff8(r2)
    12d4:	04 00 00 99 	l.jal 1538 <_report>
    12d8:	15 00 00 00 	l.nop 0x0
    12dc:	9c 60 00 01 	l.addi r3,r0,0x1
    12e0:	07 ff fe 2c 	l.jal b90 <_test_array>
    12e4:	15 00 00 00 	l.nop 0x0
    12e8:	d7 e2 5f 64 	l.sw 0xffffff64(r2),r11
    12ec:	84 82 ff 64 	l.lwz r4,0xffffff64(r2)
    12f0:	d7 e2 27 fc 	l.sw 0xfffffffc(r2),r4
    12f4:	9c 60 ff ff 	l.addi r3,r0,0xffffffff
    12f8:	07 ff fe 26 	l.jal b90 <_test_array>
    12fc:	15 00 00 00 	l.nop 0x0
    1300:	d7 e2 5f 60 	l.sw 0xffffff60(r2),r11
    1304:	84 62 ff 60 	l.lwz r3,0xffffff60(r2)
    1308:	d7 e2 1f f8 	l.sw 0xfffffff8(r2),r3
    130c:	84 82 ff fc 	l.lwz r4,0xfffffffc(r2)
    1310:	d7 e2 27 58 	l.sw 0xffffff58(r2),r4
    1314:	84 62 ff f8 	l.lwz r3,0xfffffff8(r2)
    1318:	d7 e2 1f 54 	l.sw 0xffffff54(r2),r3
    131c:	84 82 ff 58 	l.lwz r4,0xffffff58(r2)
    1320:	84 62 ff 54 	l.lwz r3,0xffffff54(r2)
    1324:	e0 84 18 00 	l.add r4,r4,r3
    1328:	d7 e2 27 5c 	l.sw 0xffffff5c(r2),r4
    132c:	84 82 ff f4 	l.lwz r4,0xfffffff4(r2)
    1330:	d7 e2 27 50 	l.sw 0xffffff50(r2),r4
    1334:	84 62 ff 50 	l.lwz r3,0xffffff50(r2)
    1338:	84 82 ff 5c 	l.lwz r4,0xffffff5c(r2)
    133c:	e0 63 20 02 	l.sub r3,r3,r4
    1340:	d7 e2 1f 4c 	l.sw 0xffffff4c(r2),r3
    1344:	84 62 ff 4c 	l.lwz r3,0xffffff4c(r2)
    1348:	d7 e2 1f f4 	l.sw 0xfffffff4(r2),r3
    134c:	84 62 ff f8 	l.lwz r3,0xfffffff8(r2)
    1350:	04 00 00 7a 	l.jal 1538 <_report>
    1354:	15 00 00 00 	l.nop 0x0
    1358:	18 80 00 00 	l.movhi r4,0x0
    135c:	a8 84 18 8d 	l.ori r4,r4,0x188d
    1360:	d7 e2 27 48 	l.sw 0xffffff48(r2),r4
    1364:	84 62 ff 48 	l.lwz r3,0xffffff48(r2)
    1368:	d4 01 18 00 	l.sw 0x0(r1),r3
    136c:	84 82 ff f4 	l.lwz r4,0xfffffff4(r2)
    1370:	d7 e2 27 40 	l.sw 0xffffff40(r2),r4
    1374:	18 80 93 22 	l.movhi r4,0x9322
    1378:	a8 84 b8 63 	l.ori r4,r4,0xb863
    137c:	84 62 ff 40 	l.lwz r3,0xffffff40(r2)
    1380:	e0 83 20 00 	l.add r4,r3,r4
    1384:	d7 e2 27 44 	l.sw 0xffffff44(r2),r4
    1388:	84 62 ff 44 	l.lwz r3,0xffffff44(r2)
    138c:	d4 01 18 04 	l.sw 0x4(r1),r3
    1390:	04 00 00 5f 	l.jal 150c <_printf>
    1394:	15 00 00 00 	l.nop 0x0
    1398:	84 82 ff f4 	l.lwz r4,0xfffffff4(r2)
    139c:	d7 e2 27 38 	l.sw 0xffffff38(r2),r4
    13a0:	18 80 93 22 	l.movhi r4,0x9322
    13a4:	a8 84 bf e2 	l.ori r4,r4,0xbfe2
    13a8:	84 62 ff 38 	l.lwz r3,0xffffff38(r2)
    13ac:	e0 83 20 00 	l.add r4,r3,r4
    13b0:	d7 e2 27 3c 	l.sw 0xffffff3c(r2),r4
    13b4:	84 62 ff 3c 	l.lwz r3,0xffffff3c(r2)
    13b8:	04 00 00 60 	l.jal 1538 <_report>
    13bc:	15 00 00 00 	l.nop 0x0
    13c0:	84 62 ff f4 	l.lwz r3,0xfffffff4(r2)
    13c4:	d7 e2 1f 30 	l.sw 0xffffff30(r2),r3
    13c8:	18 60 93 22 	l.movhi r3,0x9322
    13cc:	a8 63 bf e2 	l.ori r3,r3,0xbfe2
    13d0:	84 82 ff 30 	l.lwz r4,0xffffff30(r2)
    13d4:	e0 64 18 00 	l.add r3,r4,r3
    13d8:	d7 e2 1f 34 	l.sw 0xffffff34(r2),r3
    13dc:	84 62 ff 34 	l.lwz r3,0xffffff34(r2)
    13e0:	04 00 00 35 	l.jal 14b4 <_exit>
    13e4:	15 00 00 00 	l.nop 0x0
    13e8:	85 21 00 08 	l.lwz r9,0x8(r1)
    13ec:	84 41 00 0c 	l.lwz r2,0xc(r1)
    13f0:	44 00 48 00 	l.jr r9
    13f4:	9c 21 00 e0 	l.addi r1,r1,0xe0

000013f8 <_start>:
    13f8:	15 00 00 00 	l.nop 0x0
    13fc:	9c 60 00 00 	l.addi r3,r0,0x0
    1400:	9c 80 00 00 	l.addi r4,r0,0x0
    1404:	18 20 00 01 	l.movhi r1,0x1
    1408:	a8 21 19 d0 	l.ori r1,r1,0x19d0
    140c:	18 40 00 00 	l.movhi r2,0x0
    1410:	a8 42 14 dc 	l.ori r2,r2,0x14dc
    1414:	44 00 10 00 	l.jr r2
    1418:	15 00 00 00 	l.nop 0x0

0000141c <_init_mc>:
    141c:	18 60 60 00 	l.movhi r3,0x6000
    1420:	a8 63 00 00 	l.ori r3,r3,0x0
    1424:	9c 83 00 10 	l.addi r4,r3,0x10
    1428:	18 a0 04 00 	l.movhi r5,0x400
    142c:	b8 a5 00 86 	l.srai r5,r5,0x6
    1430:	a8 a5 00 25 	l.ori r5,r5,0x25
    1434:	d4 04 28 00 	l.sw 0x0(r4),r5
    1438:	9c 83 00 14 	l.addi r4,r3,0x14
    143c:	18 a0 19 22 	l.movhi r5,0x1922
    1440:	a8 a5 00 57 	l.ori r5,r5,0x57
    1444:	d4 04 28 00 	l.sw 0x0(r4),r5
    1448:	9c 83 00 08 	l.addi r4,r3,0x8
    144c:	9c a0 03 ff 	l.addi r5,r0,0x3ff
    1450:	d4 04 28 00 	l.sw 0x0(r4),r5
    1454:	9c 83 00 00 	l.addi r4,r3,0x0
    1458:	18 a0 0b 00 	l.movhi r5,0xb00
    145c:	a8 a5 03 00 	l.ori r5,r5,0x300
    1460:	d4 04 28 00 	l.sw 0x0(r4),r5
    1464:	9c 83 00 1c 	l.addi r4,r3,0x1c
    1468:	18 a0 00 00 	l.movhi r5,0x0
    146c:	a8 a5 01 03 	l.ori r5,r5,0x103
    1470:	d4 04 28 00 	l.sw 0x0(r4),r5
    1474:	9c 83 00 18 	l.addi r4,r3,0x18
    1478:	18 a0 00 00 	l.movhi r5,0x0
    147c:	b8 a5 00 86 	l.srai r5,r5,0x6
    1480:	a8 a5 04 11 	l.ori r5,r5,0x411
    1484:	d4 04 28 00 	l.sw 0x0(r4),r5
    1488:	9c 83 00 24 	l.addi r4,r3,0x24
    148c:	18 a0 00 00 	l.movhi r5,0x0
    1490:	a8 a5 01 03 	l.ori r5,r5,0x103
    1494:	d4 04 28 00 	l.sw 0x0(r4),r5
    1498:	9c 83 00 20 	l.addi r4,r3,0x20
    149c:	18 a0 00 80 	l.movhi r5,0x80
    14a0:	b8 a5 00 86 	l.srai r5,r5,0x6
    14a4:	a8 a5 04 11 	l.ori r5,r5,0x411
    14a8:	d4 04 28 00 	l.sw 0x0(r4),r5
    14ac:	44 00 48 00 	l.jr r9
    14b0:	15 00 00 00 	l.nop 0x0

000014b4 <_exit>:
    14b4:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
    14b8:	d4 01 10 00 	l.sw 0x0(r1),r2
    14bc:	9c 41 00 04 	l.addi r2,r1,0x4
    14c0:	e0 60 18 00 	l.add r3,r0,r3
    14c4:	15 00 00 01 	l.nop 0x1
    14c8:	00 00 00 00 	l.j 14c8 <_exit+0x14>
    14cc:	15 00 00 00 	l.nop 0x0
    14d0:	84 41 00 00 	l.lwz r2,0x0(r1)
    14d4:	44 00 48 00 	l.jr r9
    14d8:	9c 21 00 04 	l.addi r1,r1,0x4

000014dc <_reset>:
    14dc:	9c 21 ff f8 	l.addi r1,r1,0xfffffff8
    14e0:	d4 01 10 04 	l.sw 0x4(r1),r2
    14e4:	9c 41 00 08 	l.addi r2,r1,0x8
    14e8:	d4 01 48 00 	l.sw 0x0(r1),r9
    14ec:	07 ff fe d7 	l.jal 1048 <_main>
    14f0:	15 00 00 00 	l.nop 0x0
    14f4:	07 ff ff f0 	l.jal 14b4 <_exit>
    14f8:	a8 6b 00 00 	l.ori r3,r11,0x0
    14fc:	85 21 00 00 	l.lwz r9,0x0(r1)
    1500:	84 41 00 04 	l.lwz r2,0x4(r1)
    1504:	44 00 48 00 	l.jr r9
    1508:	9c 21 00 08 	l.addi r1,r1,0x8

0000150c <_printf>:
    150c:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
    1510:	d4 01 10 00 	l.sw 0x0(r1),r2
    1514:	9c 41 00 04 	l.addi r2,r1,0x4
    1518:	84 82 00 00 	l.lwz r4,0x0(r2)
    151c:	9c 62 00 04 	l.addi r3,r2,0x4
    1520:	9c 64 00 00 	l.addi r3,r4,0x0
    1524:	9c 83 00 00 	l.addi r4,r3,0x0
    1528:	15 00 00 03 	l.nop 0x3
    152c:	84 41 00 00 	l.lwz r2,0x0(r1)
    1530:	44 00 48 00 	l.jr r9
    1534:	9c 21 00 04 	l.addi r1,r1,0x4

00001538 <_report>:
    1538:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
    153c:	d4 01 10 00 	l.sw 0x0(r1),r2
    1540:	9c 41 00 04 	l.addi r2,r1,0x4
    1544:	9c 63 00 00 	l.addi r3,r3,0x0
    1548:	15 00 00 02 	l.nop 0x2
    154c:	84 41 00 00 	l.lwz r2,0x0(r1)
    1550:	44 00 48 00 	l.jr r9
    1554:	9c 21 00 04 	l.addi r1,r1,0x4

00001558 <___main>:
    1558:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
    155c:	d4 01 10 00 	l.sw 0x0(r1),r2
    1560:	9c 41 00 04 	l.addi r2,r1,0x4
    1564:	84 41 00 00 	l.lwz r2,0x0(r1)
    1568:	44 00 48 00 	l.jr r9
    156c:	9c 21 00 04 	l.addi r1,r1,0x4

00001570 <_start_timer>:
    1570:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
    1574:	d4 01 10 00 	l.sw 0x0(r1),r2
    1578:	9c 41 00 04 	l.addi r2,r1,0x4
    157c:	84 41 00 00 	l.lwz r2,0x0(r1)
    1580:	44 00 48 00 	l.jr r9
    1584:	9c 21 00 04 	l.addi r1,r1,0x4

00001588 <_read_timer>:
    1588:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
    158c:	d4 01 10 00 	l.sw 0x0(r1),r2
    1590:	9c 41 00 04 	l.addi r2,r1,0x4
    1594:	9d 60 00 00 	l.addi r11,r0,0x0
    1598:	84 41 00 00 	l.lwz r2,0x0(r1)
    159c:	44 00 48 00 	l.jr r9
    15a0:	9c 21 00 04 	l.addi r1,r1,0x4

000015a4 <_mtspr>:
    15a4:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
    15a8:	d4 01 10 00 	l.sw 0x0(r1),r2
    15ac:	9c 41 00 04 	l.addi r2,r1,0x4
    15b0:	c0 03 20 00 	l.mtspr r3,r4,0x0
    15b4:	84 41 00 00 	l.lwz r2,0x0(r1)
    15b8:	44 00 48 00 	l.jr r9
    15bc:	9c 21 00 04 	l.addi r1,r1,0x4

000015c0 <_mfspr>:
    15c0:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
    15c4:	d4 01 10 00 	l.sw 0x0(r1),r2
    15c8:	9c 41 00 04 	l.addi r2,r1,0x4
    15cc:	b5 63 00 00 	l.mfspr r11,r3,0x0
    15d0:	84 41 00 00 	l.lwz r2,0x0(r1)
    15d4:	44 00 48 00 	l.jr r9
    15d8:	9c 21 00 04 	l.addi r1,r1,0x4

000015dc <_memcpy>:
    15dc:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
    15e0:	d4 01 10 00 	l.sw 0x0(r1),r2
    15e4:	9c 41 00 04 	l.addi r2,r1,0x4
    15e8:	00 00 00 07 	l.j 1604 <_memcpy+0x28>
    15ec:	9c a5 ff ff 	l.addi r5,r5,0xffffffff
    15f0:	8c c4 00 00 	l.lbz r6,0x0(r4)
    15f4:	9c a5 ff ff 	l.addi r5,r5,0xffffffff
    15f8:	d8 03 30 00 	l.sb 0x0(r3),r6
    15fc:	9c 84 00 01 	l.addi r4,r4,0x1
    1600:	9c 63 00 01 	l.addi r3,r3,0x1
    1604:	bc 05 ff ff 	l.sfeqi r5,0xffffffff
    1608:	0f ff ff fa 	l.bnf 15f0 <_memcpy+0x14>
    160c:	a9 63 00 00 	l.ori r11,r3,0x0
    1610:	84 41 00 00 	l.lwz r2,0x0(r1)
    1614:	44 00 48 00 	l.jr r9
    1618:	9c 21 00 04 	l.addi r1,r1,0x4

0000161c <_excpt_dummy>:
    161c:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
    1620:	d4 01 10 00 	l.sw 0x0(r1),r2
    1624:	9c 41 00 04 	l.addi r2,r1,0x4
    1628:	84 41 00 00 	l.lwz r2,0x0(r1)
    162c:	44 00 48 00 	l.jr r9
    1630:	9c 21 00 04 	l.addi r1,r1,0x4

00001634 <_int_init>:
    1634:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
    1638:	d4 01 10 00 	l.sw 0x0(r1),r2
    163c:	9c 41 00 04 	l.addi r2,r1,0x4
    1640:	18 60 00 00 	l.movhi r3,0x0
    1644:	a8 63 18 d0 	l.ori r3,r3,0x18d0
    1648:	9c 80 00 1f 	l.addi r4,r0,0x1f
    164c:	9c a0 00 00 	l.addi r5,r0,0x0
    1650:	9c 84 ff ff 	l.addi r4,r4,0xffffffff
    1654:	d4 03 28 00 	l.sw 0x0(r3),r5
    1658:	d4 03 28 04 	l.sw 0x4(r3),r5
    165c:	bd 64 00 00 	l.sfgesi r4,0x0
    1660:	13 ff ff fc 	l.bf 1650 <_int_init+0x1c>
    1664:	9c 63 00 08 	l.addi r3,r3,0x8
    1668:	a9 65 00 00 	l.ori r11,r5,0x0
    166c:	84 41 00 00 	l.lwz r2,0x0(r1)
    1670:	44 00 48 00 	l.jr r9
    1674:	9c 21 00 04 	l.addi r1,r1,0x4

00001678 <_int_add>:
    1678:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
    167c:	d4 01 10 04 	l.sw 0x4(r1),r2
    1680:	9c 41 00 0c 	l.addi r2,r1,0xc
    1684:	d4 01 48 00 	l.sw 0x0(r1),r9
    1688:	d4 01 50 08 	l.sw 0x8(r1),r10
    168c:	b8 c3 00 03 	l.slli r6,r3,0x3
    1690:	a9 43 00 00 	l.ori r10,r3,0x0
    1694:	18 e0 00 00 	l.movhi r7,0x0
    1698:	a8 e7 18 d0 	l.ori r7,r7,0x18d0
    169c:	9c 60 48 00 	l.addi r3,r0,0x4800
    16a0:	e0 c6 38 00 	l.add r6,r6,r7
    16a4:	bc aa 00 1f 	l.sfleui r10,0x1f
    16a8:	0c 00 00 0b 	l.bnf 16d4 <_int_add+0x5c>
    16ac:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
    16b0:	d4 06 20 00 	l.sw 0x0(r6),r4
    16b4:	07 ff ff c3 	l.jal 15c0 <_mfspr>
    16b8:	d4 06 28 04 	l.sw 0x4(r6),r5
    16bc:	9c 80 00 01 	l.addi r4,r0,0x1
    16c0:	9c 60 48 00 	l.addi r3,r0,0x4800
    16c4:	e0 84 50 08 	l.sll r4,r4,r10
    16c8:	07 ff ff b7 	l.jal 15a4 <_mtspr>
    16cc:	e0 8b 20 04 	l.or r4,r11,r4
    16d0:	9d 60 00 00 	l.addi r11,r0,0x0
    16d4:	85 21 00 00 	l.lwz r9,0x0(r1)
    16d8:	84 41 00 04 	l.lwz r2,0x4(r1)
    16dc:	85 41 00 08 	l.lwz r10,0x8(r1)
    16e0:	44 00 48 00 	l.jr r9
    16e4:	9c 21 00 0c 	l.addi r1,r1,0xc

000016e8 <_int_disable>:
    16e8:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
    16ec:	d4 01 10 04 	l.sw 0x4(r1),r2
    16f0:	9c 41 00 0c 	l.addi r2,r1,0xc
    16f4:	d4 01 48 00 	l.sw 0x0(r1),r9
    16f8:	d4 01 50 08 	l.sw 0x8(r1),r10
    16fc:	a9 43 00 00 	l.ori r10,r3,0x0
    1700:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
    1704:	bc aa 00 1f 	l.sfleui r10,0x1f
    1708:	0c 00 00 0b 	l.bnf 1734 <_int_disable+0x4c>
    170c:	9c 60 48 00 	l.addi r3,r0,0x4800
    1710:	07 ff ff ac 	l.jal 15c0 <_mfspr>
    1714:	15 00 00 00 	l.nop 0x0
    1718:	9c 80 00 01 	l.addi r4,r0,0x1
    171c:	9c 60 48 00 	l.addi r3,r0,0x4800
    1720:	e0 84 50 08 	l.sll r4,r4,r10
    1724:	ac 84 ff ff 	l.xori r4,r4,0xffffffff
    1728:	07 ff ff 9f 	l.jal 15a4 <_mtspr>
    172c:	e0 8b 20 03 	l.and r4,r11,r4
    1730:	9d 60 00 00 	l.addi r11,r0,0x0
    1734:	85 21 00 00 	l.lwz r9,0x0(r1)
    1738:	84 41 00 04 	l.lwz r2,0x4(r1)
    173c:	85 41 00 08 	l.lwz r10,0x8(r1)
    1740:	44 00 48 00 	l.jr r9
    1744:	9c 21 00 0c 	l.addi r1,r1,0xc

00001748 <_int_enable>:
    1748:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
    174c:	d4 01 10 04 	l.sw 0x4(r1),r2
    1750:	9c 41 00 0c 	l.addi r2,r1,0xc
    1754:	d4 01 48 00 	l.sw 0x0(r1),r9
    1758:	d4 01 50 08 	l.sw 0x8(r1),r10
    175c:	a9 43 00 00 	l.ori r10,r3,0x0
    1760:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
    1764:	bc aa 00 1f 	l.sfleui r10,0x1f
    1768:	0c 00 00 0a 	l.bnf 1790 <_int_enable+0x48>
    176c:	9c 60 48 00 	l.addi r3,r0,0x4800
    1770:	07 ff ff 94 	l.jal 15c0 <_mfspr>
    1774:	15 00 00 00 	l.nop 0x0
    1778:	9c 80 00 01 	l.addi r4,r0,0x1
    177c:	9c 60 48 00 	l.addi r3,r0,0x4800
    1780:	e0 84 50 08 	l.sll r4,r4,r10
    1784:	07 ff ff 88 	l.jal 15a4 <_mtspr>
    1788:	e0 8b 20 04 	l.or r4,r11,r4
    178c:	9d 60 00 00 	l.addi r11,r0,0x0
    1790:	85 21 00 00 	l.lwz r9,0x0(r1)
    1794:	84 41 00 04 	l.lwz r2,0x4(r1)
    1798:	85 41 00 08 	l.lwz r10,0x8(r1)
    179c:	44 00 48 00 	l.jr r9
    17a0:	9c 21 00 0c 	l.addi r1,r1,0xc

000017a4 <_int_main>:
    17a4:	9c 21 ff e4 	l.addi r1,r1,0xffffffe4
    17a8:	d4 01 10 04 	l.sw 0x4(r1),r2
    17ac:	9c 41 00 1c 	l.addi r2,r1,0x1c
    17b0:	d4 01 48 00 	l.sw 0x0(r1),r9
    17b4:	d4 01 50 08 	l.sw 0x8(r1),r10
    17b8:	d4 01 60 0c 	l.sw 0xc(r1),r12
    17bc:	d4 01 70 10 	l.sw 0x10(r1),r14
    17c0:	d4 01 80 14 	l.sw 0x14(r1),r16
    17c4:	d4 01 90 18 	l.sw 0x18(r1),r18
    17c8:	9c 60 48 02 	l.addi r3,r0,0x4802
    17cc:	07 ff ff 7d 	l.jal 15c0 <_mfspr>
    17d0:	9d 80 00 00 	l.addi r12,r0,0x0
    17d4:	aa 0b 00 00 	l.ori r16,r11,0x0
    17d8:	9c 60 48 02 	l.addi r3,r0,0x4802
    17dc:	a8 8c 00 00 	l.ori r4,r12,0x0
    17e0:	19 c0 00 00 	l.movhi r14,0x0
    17e4:	a9 ce 18 d0 	l.ori r14,r14,0x18d0
    17e8:	07 ff ff 6f 	l.jal 15a4 <_mtspr>
    17ec:	9e 40 00 01 	l.addi r18,r0,0x1
    17f0:	e1 52 60 08 	l.sll r10,r18,r12
    17f4:	e0 6a 80 03 	l.and r3,r10,r16
    17f8:	bc 03 00 00 	l.sfeqi r3,0x0
    17fc:	10 00 00 0e 	l.bf 1834 <_int_main+0x90>
    1800:	9d 8c 00 01 	l.addi r12,r12,0x1
    1804:	84 8e 00 00 	l.lwz r4,0x0(r14)
    1808:	bc 04 00 00 	l.sfeqi r4,0x0
    180c:	10 00 00 0b 	l.bf 1838 <_int_main+0x94>
    1810:	bc 4c 00 1f 	l.sfgtui r12,0x1f
    1814:	48 00 20 00 	l.jalr r4
    1818:	84 6e 00 04 	l.lwz r3,0x4(r14)
    181c:	07 ff ff 69 	l.jal 15c0 <_mfspr>
    1820:	9c 60 48 02 	l.addi r3,r0,0x4802
    1824:	ac 8a ff ff 	l.xori r4,r10,0xffffffff
    1828:	9c 60 48 02 	l.addi r3,r0,0x4802
    182c:	07 ff ff 5e 	l.jal 15a4 <_mtspr>
    1830:	e0 8b 20 03 	l.and r4,r11,r4
    1834:	bc 4c 00 1f 	l.sfgtui r12,0x1f
    1838:	0f ff ff ee 	l.bnf 17f0 <_int_main+0x4c>
    183c:	9d ce 00 08 	l.addi r14,r14,0x8
    1840:	85 21 00 00 	l.lwz r9,0x0(r1)
    1844:	84 41 00 04 	l.lwz r2,0x4(r1)
    1848:	85 41 00 08 	l.lwz r10,0x8(r1)
    184c:	85 81 00 0c 	l.lwz r12,0xc(r1)
    1850:	85 c1 00 10 	l.lwz r14,0x10(r1)
    1854:	86 01 00 14 	l.lwz r16,0x14(r1)
    1858:	86 41 00 18 	l.lwz r18,0x18(r1)
    185c:	44 00 48 00 	l.jr r9
    1860:	9c 21 00 1c 	l.addi r1,r1,0x1c
Disassembly of section .rodata:

00001864 <.rodata>:
    1864:	54 68 69 73 	.word 0x54686973
    1868:	20 74 65 73 	.word 0x20746573
    186c:	74 20 73 74 	l.cust2 
    1870:	72 69 6e 67 	l.cust1 
    1874:	20 4d 55 53 	.word 0x204d5553
    1878:	54 20 4e 4f 	.word 0x54204e4f
    187c:	54 20 62 65 	.word 0x54206265
    1880:	20 6d 6f 64 	.word 0x206d6f64
    1884:	69 66 69 65 	.word 0x69666965
    1888:	64 2e 2e 2e 	.word 0x642e2e2e
    188c:	00 52 45 53 	l.j 1492dd8 <_src_addr+0x1481408>
    1890:	55 4c 54 3a 	.word 0x554c543a
    1894:	20 25 2e 38 	.word 0x20252e38
    1898:	6c 78 0a 00 	.word 0x6c780a00
Disassembly of section .data:

0000189c <_dst_beg>:
    189c:	00 00 16 1c 	l.j 710c <_dst_end+0x583c>

000018a0 <_excpt_break>:
    18a0:	00 00 16 1c 	l.j 7110 <_dst_end+0x5840>

000018a4 <_excpt_syscall>:
    18a4:	00 00 16 1c 	l.j 7114 <_dst_end+0x5844>

000018a8 <_excpt_range>:
    18a8:	00 00 16 1c 	l.j 7118 <_dst_end+0x5848>

000018ac <_excpt_itlbmiss>:
    18ac:	00 00 16 1c 	l.j 711c <_dst_end+0x584c>

000018b0 <_excpt_dtlbmiss>:
    18b0:	00 00 16 1c 	l.j 7120 <_dst_end+0x5850>

000018b4 <_excpt_int>:
    18b4:	00 00 17 a4 	l.j 7744 <_dst_end+0x5e74>

000018b8 <_excpt_illinsn>:
    18b8:	00 00 16 1c 	l.j 7128 <_dst_end+0x5858>

000018bc <_excpt_align>:
    18bc:	00 00 16 1c 	l.j 712c <_dst_end+0x585c>

000018c0 <_excpt_tick>:
    18c0:	00 00 16 1c 	l.j 7130 <_dst_end+0x5860>

000018c4 <_excpt_ipfault>:
    18c4:	00 00 16 1c 	l.j 7134 <_dst_end+0x5864>

000018c8 <_excpt_dpfault>:
    18c8:	00 00 16 1c 	l.j 7138 <_dst_end+0x5868>

000018cc <_excpt_buserr>:
    18cc:	00 00 16 1c 	l.j 713c <_dst_end+0x586c>
Disassembly of section .bss:

000018d0 <_int_handlers>:
	...
Disassembly of section .stack:

000019d0 <_src_addr-0x10000>:
	...
Disassembly of section .comment:

00000000 <.comment>:
   0:	00 47 43 43 	l.j 11d0d0c <_src_addr+0x11bf33c>
   4:	3a 20 28 47 	.word 0x3a202847
   8:	4e 55 29 20 	l.maci r21,0xffff9120
   c:	33 2e 34 2e 	.word 0x332e342e
  10:	34 00 00 47 	.word 0x34000047
  14:	43 43 3a 20 	.word 0x43433a20
  18:	28 47 4e 55 	lv.max.b r2,r7,r9
  1c:	29 20 33 2e 	.word 0x2920332e
  20:	34 2e 34 00 	.word 0x342e3400
  24:	00 47 43 43 	l.j 11d0d30 <_src_addr+0x11bf360>
  28:	3a 20 28 47 	.word 0x3a202847
  2c:	4e 55 29 20 	l.maci r21,0xffff9120
  30:	33 2e 34 2e 	.word 0x332e342e
  34:	Address 0x00000034 is out of bounds.

