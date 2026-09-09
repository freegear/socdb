
tick-nocache.or32:     file format elf32-or32

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
 184:	a8 63 08 6c 	l.ori r3,r3,0x86c
 188:	44 00 18 00 	l.jr r3
 18c:	15 00 00 00 	l.nop 0x0
Disassembly of section .vectors:

00000200 <_vec_start>:
	...
 500:	9f e3 00 00 	l.addi r31,r3,0x0
 504:	b7 20 00 20 	l.mfspr r25,r0,0x20
 508:	1b 40 00 00 	l.movhi r26,0x0
 50c:	ab 5a 06 30 	l.ori r26,r26,0x630
 510:	9c 79 00 00 	l.addi r3,r25,0x0
 514:	15 00 00 02 	l.nop 0x2
 518:	e3 39 d0 02 	l.sub r25,r25,r26
 51c:	9c 79 00 00 	l.addi r3,r25,0x0
 520:	15 00 00 02 	l.nop 0x2
 524:	9c 7f 00 00 	l.addi r3,r31,0x0
 528:	bc 19 00 00 	l.sfeqi r25,0x0
 52c:	10 00 00 52 	l.bf 674 <_i00>
 530:	bc 19 00 04 	l.sfeqi r25,0x4
 534:	10 00 00 55 	l.bf 688 <_i04>
 538:	bc 19 00 08 	l.sfeqi r25,0x8
 53c:	10 00 00 5d 	l.bf 6b0 <_i08>
 540:	bc 19 00 0c 	l.sfeqi r25,0xc
 544:	10 00 00 65 	l.bf 6d8 <_i0c>
 548:	bc 19 00 10 	l.sfeqi r25,0x10
 54c:	10 00 00 68 	l.bf 6ec <_i10>
 550:	bc 19 00 14 	l.sfeqi r25,0x14
 554:	10 00 00 6c 	l.bf 704 <_i14>
 558:	bc 19 00 18 	l.sfeqi r25,0x18
 55c:	10 00 00 6f 	l.bf 718 <_i18>
 560:	bc 19 00 1c 	l.sfeqi r25,0x1c
 564:	10 00 00 73 	l.bf 730 <_i1c>
 568:	bc 19 00 20 	l.sfeqi r25,0x20
 56c:	10 00 00 73 	l.bf 738 <_i20>
 570:	bc 19 00 24 	l.sfeqi r25,0x24
 574:	10 00 00 73 	l.bf 740 <_i24>
 578:	bc 19 00 28 	l.sfeqi r25,0x28
 57c:	10 00 00 7f 	l.bf 778 <_i28>
 580:	bc 19 00 2c 	l.sfeqi r25,0x2c
 584:	10 00 00 8e 	l.bf 7bc <_i2c>
 588:	bc 19 00 30 	l.sfeqi r25,0x30
 58c:	10 00 00 96 	l.bf 7e4 <_i30>
 590:	bc 19 00 34 	l.sfeqi r25,0x34
 594:	10 00 00 99 	l.bf 7f8 <_i34>
 598:	bc 19 00 38 	l.sfeqi r25,0x38
 59c:	10 00 00 a0 	l.bf 81c <_i38>
 5a0:	15 00 00 00 	l.nop 0x0

000005a4 <_die>:
 5a4:	15 00 00 02 	l.nop 0x2
 5a8:	9c 60 ee ee 	l.addi r3,r0,0xffffeeee
 5ac:	15 00 00 02 	l.nop 0x2
 5b0:	9c 60 00 01 	l.addi r3,r0,0x1
 5b4:	04 00 00 b7 	l.jal 890 <_exit>
 5b8:	15 00 00 00 	l.nop 0x0
 5bc:	00 00 00 00 	l.j 5bc <_die+0x18>
 5c0:	15 00 00 00 	l.nop 0x0
Disassembly of section .text:

000005c4 <_main>:
 5c4:	15 00 00 00 	l.nop 0x0
 5c8:	15 00 00 00 	l.nop 0x0
 5cc:	9e 00 00 00 	l.addi r16,r0,0x0
 5d0:	9e 20 00 01 	l.addi r17,r0,0x1
 5d4:	9e 40 00 00 	l.addi r18,r0,0x0
 5d8:	9e 60 00 00 	l.addi r19,r0,0x0
 5dc:	9e c0 00 00 	l.addi r22,r0,0x0
 5e0:	1a e0 00 00 	l.movhi r23,0x0
 5e4:	aa f7 0d 80 	l.ori r23,r23,0xd80
 5e8:	18 a0 ff ff 	l.movhi r5,0xffff
 5ec:	a8 a5 ff ff 	l.ori r5,r5,0xffff
 5f0:	c1 20 28 00 	l.mtspr r0,r5,0x4800
 5f4:	b6 80 00 11 	l.mfspr r20,r0,0x11
 5f8:	aa 94 02 03 	l.ori r20,r20,0x203
 5fc:	18 a0 a0 00 	l.movhi r5,0xa000
 600:	e2 a5 88 00 	l.add r21,r5,r17

00000604 <_main_loop>:
 604:	9c 60 aa aa 	l.addi r3,r0,0xffffaaaa
 608:	9d 20 bb bb 	l.addi r9,r0,0xffffbbbb
 60c:	d4 17 18 00 	l.sw 0x0(r23),r3
 610:	d4 17 48 04 	l.sw 0x4(r23),r9
 614:	d4 17 18 08 	l.sw 0x8(r23),r3
 618:	9e 31 00 01 	l.addi r17,r17,0x1
 61c:	c1 40 00 01 	l.mtspr r0,r0,0x5001
 620:	c1 40 a8 00 	l.mtspr r0,r21,0x5000
 624:	c1 40 00 01 	l.mtspr r0,r0,0x5001
 628:	9e b5 00 01 	l.addi r21,r21,0x1
 62c:	c0 00 a0 11 	l.mtspr r0,r20,0x11

00000630 <_ie_start>:
 630:	18 60 12 34 	l.movhi r3,0x1234
 634:	d4 17 18 00 	l.sw 0x0(r23),r3
 638:	18 60 00 00 	l.movhi r3,0x0
 63c:	84 63 00 00 	l.lwz r3,0x0(r3)
 640:	18 60 00 00 	l.movhi r3,0x0
 644:	9c 63 00 04 	l.addi r3,r3,0x4
 648:	00 00 00 03 	l.j 654 <_ie_start+0x24>
 64c:	84 63 00 00 	l.lwz r3,0x0(r3)
 650:	9c 63 00 01 	l.addi r3,r3,0x1
 654:	bc 03 de ad 	l.sfeqi r3,0xffffdead
 658:	04 00 00 02 	l.jal 660 <_return_addr>
 65c:	9c 60 56 78 	l.addi r3,r0,0x5678

00000660 <_return_addr>:
 660:	13 ff ff d1 	l.bf 5a4 <_die>
 664:	d4 17 18 08 	l.sw 0x8(r23),r3

00000668 <_ie_end>:
 668:	15 00 00 00 	l.nop 0x0
 66c:	03 ff ff e6 	l.j 604 <_main_loop>
 670:	15 00 00 00 	l.nop 0x0

00000674 <_i00>:
 674:	bc 03 aa aa 	l.sfeqi r3,0xffffaaaa
 678:	0f ff ff cb 	l.bnf 5a4 <_die>
 67c:	15 00 00 00 	l.nop 0x0
 680:	00 00 00 73 	l.j 84c <_resume>
 684:	15 00 00 00 	l.nop 0x0

00000688 <_i04>:
 688:	1b 40 12 34 	l.movhi r26,0x1234
 68c:	e4 03 d0 00 	l.sfeq r3,r26
 690:	0f ff ff c5 	l.bnf 5a4 <_die>
 694:	15 00 00 00 	l.nop 0x0
 698:	87 57 00 00 	l.lwz r26,0x0(r23)
 69c:	bc 1a aa aa 	l.sfeqi r26,0xffffaaaa
 6a0:	0f ff ff c1 	l.bnf 5a4 <_die>
 6a4:	15 00 00 00 	l.nop 0x0
 6a8:	00 00 00 69 	l.j 84c <_resume>
 6ac:	15 00 00 00 	l.nop 0x0

000006b0 <_i08>:
 6b0:	1b 40 12 34 	l.movhi r26,0x1234
 6b4:	e4 03 d0 00 	l.sfeq r3,r26
 6b8:	0f ff ff bb 	l.bnf 5a4 <_die>
 6bc:	15 00 00 00 	l.nop 0x0
 6c0:	87 77 00 00 	l.lwz r27,0x0(r23)
 6c4:	e4 1b d0 00 	l.sfeq r27,r26
 6c8:	0f ff ff b7 	l.bnf 5a4 <_die>
 6cc:	15 00 00 00 	l.nop 0x0
 6d0:	00 00 00 5f 	l.j 84c <_resume>
 6d4:	15 00 00 00 	l.nop 0x0

000006d8 <_i0c>:
 6d8:	e4 03 b8 00 	l.sfeq r3,r23
 6dc:	0f ff ff b2 	l.bnf 5a4 <_die>
 6e0:	15 00 00 00 	l.nop 0x0
 6e4:	00 00 00 5a 	l.j 84c <_resume>
 6e8:	15 00 00 00 	l.nop 0x0

000006ec <_i10>:
 6ec:	1b 40 12 34 	l.movhi r26,0x1234
 6f0:	e4 1a 18 00 	l.sfeq r26,r3
 6f4:	0f ff ff ac 	l.bnf 5a4 <_die>
 6f8:	15 00 00 00 	l.nop 0x0
 6fc:	00 00 00 54 	l.j 84c <_resume>
 700:	15 00 00 00 	l.nop 0x0

00000704 <_i14>:
 704:	e4 03 b8 00 	l.sfeq r3,r23
 708:	0f ff ff a7 	l.bnf 5a4 <_die>
 70c:	15 00 00 00 	l.nop 0x0
 710:	00 00 00 4f 	l.j 84c <_resume>
 714:	15 00 00 00 	l.nop 0x0

00000718 <_i18>:
 718:	9f 57 00 04 	l.addi r26,r23,0x4
 71c:	e4 03 d0 00 	l.sfeq r3,r26
 720:	0f ff ff a1 	l.bnf 5a4 <_die>
 724:	15 00 00 00 	l.nop 0x0
 728:	00 00 00 49 	l.j 84c <_resume>
 72c:	15 00 00 00 	l.nop 0x0

00000730 <_i1c>:
 730:	03 ff ff 9d 	l.j 5a4 <_die>
 734:	15 00 00 00 	l.nop 0x0

00000738 <_i20>:
 738:	03 ff ff 9b 	l.j 5a4 <_die>
 73c:	15 00 00 00 	l.nop 0x0

00000740 <_i24>:
 740:	b7 40 00 40 	l.mfspr r26,r0,0x40
 744:	9f c3 00 00 	l.addi r30,r3,0x0
 748:	9c 7a 00 00 	l.addi r3,r26,0x0
 74c:	15 00 00 02 	l.nop 0x2
 750:	9c 7e 00 00 	l.addi r3,r30,0x0
 754:	a7 5a 02 00 	l.andi r26,r26,0x200
 758:	e4 1a 00 00 	l.sfeq r26,r0
 75c:	13 ff ff 92 	l.bf 5a4 <_die>
 760:	15 00 00 00 	l.nop 0x0
 764:	bc 03 bb bb 	l.sfeqi r3,0xffffbbbb
 768:	0f ff ff 8f 	l.bnf 5a4 <_die>
 76c:	15 00 00 00 	l.nop 0x0
 770:	00 00 00 37 	l.j 84c <_resume>
 774:	15 00 00 00 	l.nop 0x0

00000778 <_i28>:
 778:	b7 40 00 40 	l.mfspr r26,r0,0x40
 77c:	9f c3 00 00 	l.addi r30,r3,0x0
 780:	9c 7a 00 00 	l.addi r3,r26,0x0
 784:	15 00 00 02 	l.nop 0x2
 788:	9c 7e 00 00 	l.addi r3,r30,0x0
 78c:	a7 5a 02 00 	l.andi r26,r26,0x200
 790:	e4 1a 00 00 	l.sfeq r26,r0
 794:	0f ff ff 84 	l.bnf 5a4 <_die>
 798:	15 00 00 00 	l.nop 0x0
 79c:	bc 16 00 01 	l.sfeqi r22,0x1
 7a0:	10 00 00 2b 	l.bf 84c <_resume>
 7a4:	9e c0 00 01 	l.addi r22,r0,0x1
 7a8:	bc 09 bb bb 	l.sfeqi r9,0xffffbbbb
 7ac:	0f ff ff 7e 	l.bnf 5a4 <_die>
 7b0:	15 00 00 00 	l.nop 0x0
 7b4:	00 00 00 26 	l.j 84c <_resume>
 7b8:	15 00 00 00 	l.nop 0x0

000007bc <_i2c>:
 7bc:	1b 40 00 00 	l.movhi r26,0x0
 7c0:	ab 5a 06 60 	l.ori r26,r26,0x660
 7c4:	e4 09 d0 00 	l.sfeq r9,r26
 7c8:	0f ff ff 77 	l.bnf 5a4 <_die>
 7cc:	15 00 00 00 	l.nop 0x0
 7d0:	bc 03 bb bb 	l.sfeqi r3,0xffffbbbb
 7d4:	0f ff ff 74 	l.bnf 5a4 <_die>
 7d8:	15 00 00 00 	l.nop 0x0
 7dc:	00 00 00 1c 	l.j 84c <_resume>
 7e0:	15 00 00 00 	l.nop 0x0

000007e4 <_i30>:
 7e4:	bc 03 56 78 	l.sfeqi r3,0x5678
 7e8:	0f ff ff 6f 	l.bnf 5a4 <_die>
 7ec:	15 00 00 00 	l.nop 0x0
 7f0:	00 00 00 17 	l.j 84c <_resume>
 7f4:	15 00 00 00 	l.nop 0x0

000007f8 <_i34>:
 7f8:	bc 03 56 78 	l.sfeqi r3,0x5678
 7fc:	0f ff ff 6a 	l.bnf 5a4 <_die>
 800:	15 00 00 00 	l.nop 0x0
 804:	87 57 00 08 	l.lwz r26,0x8(r23)
 808:	bc 1a aa aa 	l.sfeqi r26,0xffffaaaa
 80c:	0f ff ff 66 	l.bnf 5a4 <_die>
 810:	15 00 00 00 	l.nop 0x0
 814:	00 00 00 0e 	l.j 84c <_resume>
 818:	15 00 00 00 	l.nop 0x0

0000081c <_i38>:
 81c:	87 57 00 08 	l.lwz r26,0x8(r23)
 820:	bc 1a 56 78 	l.sfeqi r26,0x5678
 824:	0f ff ff 60 	l.bnf 5a4 <_die>
 828:	15 00 00 00 	l.nop 0x0
 82c:	18 60 de ad 	l.movhi r3,0xdead
 830:	a8 63 de ad 	l.ori r3,r3,0xdead
 834:	15 00 00 02 	l.nop 0x2
 838:	9c 60 00 00 	l.addi r3,r0,0x0
 83c:	04 00 00 15 	l.jal 890 <_exit>
 840:	15 00 00 00 	l.nop 0x0

00000844 <_ok>:
 844:	00 00 00 00 	l.j 844 <_ok>
 848:	15 00 00 00 	l.nop 0x0

0000084c <_resume>:
 84c:	b7 60 00 40 	l.mfspr r27,r0,0x40
 850:	9f 40 00 02 	l.addi r26,r0,0x2
 854:	9f 80 ff ff 	l.addi r28,r0,0xffffffff
 858:	e3 5a e0 05 	l.xor r26,r26,r28
 85c:	e3 5a d8 03 	l.and r26,r26,r27
 860:	c0 00 d0 40 	l.mtspr r0,r26,0x40
 864:	24 00 00 00 	l.rfe 
 868:	9c 63 00 05 	l.addi r3,r3,0x5

0000086c <_start>:
 86c:	15 00 00 00 	l.nop 0x0
 870:	9c 60 00 00 	l.addi r3,r0,0x0
 874:	9c 80 00 00 	l.addi r4,r0,0x0
 878:	18 20 00 00 	l.movhi r1,0x0
 87c:	a8 21 1f fc 	l.ori r1,r1,0x1ffc
 880:	18 40 00 00 	l.movhi r2,0x0
 884:	a8 42 08 b8 	l.ori r2,r2,0x8b8
 888:	44 00 10 00 	l.jr r2
 88c:	15 00 00 00 	l.nop 0x0

00000890 <_exit>:
 890:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 894:	d4 01 10 00 	l.sw 0x0(r1),r2
 898:	9c 41 00 04 	l.addi r2,r1,0x4
 89c:	e0 60 18 00 	l.add r3,r0,r3
 8a0:	15 00 00 01 	l.nop 0x1
 8a4:	00 00 00 00 	l.j 8a4 <_exit+0x14>
 8a8:	15 00 00 00 	l.nop 0x0
 8ac:	84 41 00 00 	l.lwz r2,0x0(r1)
 8b0:	44 00 48 00 	l.jr r9
 8b4:	9c 21 00 04 	l.addi r1,r1,0x4

000008b8 <_reset>:
 8b8:	9c 21 ff f8 	l.addi r1,r1,0xfffffff8
 8bc:	d4 01 10 04 	l.sw 0x4(r1),r2
 8c0:	9c 41 00 08 	l.addi r2,r1,0x8
 8c4:	d4 01 48 00 	l.sw 0x0(r1),r9
 8c8:	07 ff ff 3f 	l.jal 5c4 <_main>
 8cc:	15 00 00 00 	l.nop 0x0
 8d0:	07 ff ff f0 	l.jal 890 <_exit>
 8d4:	a8 6b 00 00 	l.ori r3,r11,0x0
 8d8:	85 21 00 00 	l.lwz r9,0x0(r1)
 8dc:	84 41 00 04 	l.lwz r2,0x4(r1)
 8e0:	44 00 48 00 	l.jr r9
 8e4:	9c 21 00 08 	l.addi r1,r1,0x8

000008e8 <_printf>:
 8e8:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 8ec:	d4 01 10 00 	l.sw 0x0(r1),r2
 8f0:	9c 41 00 04 	l.addi r2,r1,0x4
 8f4:	84 82 00 00 	l.lwz r4,0x0(r2)
 8f8:	9c 62 00 04 	l.addi r3,r2,0x4
 8fc:	9c 64 00 00 	l.addi r3,r4,0x0
 900:	9c 83 00 00 	l.addi r4,r3,0x0
 904:	15 00 00 03 	l.nop 0x3
 908:	84 41 00 00 	l.lwz r2,0x0(r1)
 90c:	44 00 48 00 	l.jr r9
 910:	9c 21 00 04 	l.addi r1,r1,0x4

00000914 <_report>:
 914:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 918:	d4 01 10 00 	l.sw 0x0(r1),r2
 91c:	9c 41 00 04 	l.addi r2,r1,0x4
 920:	9c 63 00 00 	l.addi r3,r3,0x0
 924:	15 00 00 02 	l.nop 0x2
 928:	84 41 00 00 	l.lwz r2,0x0(r1)
 92c:	44 00 48 00 	l.jr r9
 930:	9c 21 00 04 	l.addi r1,r1,0x4

00000934 <___main>:
 934:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 938:	d4 01 10 00 	l.sw 0x0(r1),r2
 93c:	9c 41 00 04 	l.addi r2,r1,0x4
 940:	84 41 00 00 	l.lwz r2,0x0(r1)
 944:	44 00 48 00 	l.jr r9
 948:	9c 21 00 04 	l.addi r1,r1,0x4

0000094c <_start_timer>:
 94c:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 950:	d4 01 10 00 	l.sw 0x0(r1),r2
 954:	9c 41 00 04 	l.addi r2,r1,0x4
 958:	84 41 00 00 	l.lwz r2,0x0(r1)
 95c:	44 00 48 00 	l.jr r9
 960:	9c 21 00 04 	l.addi r1,r1,0x4

00000964 <_read_timer>:
 964:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 968:	d4 01 10 00 	l.sw 0x0(r1),r2
 96c:	9c 41 00 04 	l.addi r2,r1,0x4
 970:	9d 60 00 00 	l.addi r11,r0,0x0
 974:	84 41 00 00 	l.lwz r2,0x0(r1)
 978:	44 00 48 00 	l.jr r9
 97c:	9c 21 00 04 	l.addi r1,r1,0x4

00000980 <_mtspr>:
 980:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 984:	d4 01 10 00 	l.sw 0x0(r1),r2
 988:	9c 41 00 04 	l.addi r2,r1,0x4
 98c:	c0 03 20 00 	l.mtspr r3,r4,0x0
 990:	84 41 00 00 	l.lwz r2,0x0(r1)
 994:	44 00 48 00 	l.jr r9
 998:	9c 21 00 04 	l.addi r1,r1,0x4

0000099c <_mfspr>:
 99c:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 9a0:	d4 01 10 00 	l.sw 0x0(r1),r2
 9a4:	9c 41 00 04 	l.addi r2,r1,0x4
 9a8:	b5 63 00 00 	l.mfspr r11,r3,0x0
 9ac:	84 41 00 00 	l.lwz r2,0x0(r1)
 9b0:	44 00 48 00 	l.jr r9
 9b4:	9c 21 00 04 	l.addi r1,r1,0x4

000009b8 <_memcpy>:
 9b8:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 9bc:	d4 01 10 00 	l.sw 0x0(r1),r2
 9c0:	9c 41 00 04 	l.addi r2,r1,0x4
 9c4:	00 00 00 07 	l.j 9e0 <_memcpy+0x28>
 9c8:	9c a5 ff ff 	l.addi r5,r5,0xffffffff
 9cc:	8c c4 00 00 	l.lbz r6,0x0(r4)
 9d0:	9c a5 ff ff 	l.addi r5,r5,0xffffffff
 9d4:	d8 03 30 00 	l.sb 0x0(r3),r6
 9d8:	9c 84 00 01 	l.addi r4,r4,0x1
 9dc:	9c 63 00 01 	l.addi r3,r3,0x1
 9e0:	bc 05 ff ff 	l.sfeqi r5,0xffffffff
 9e4:	0f ff ff fa 	l.bnf 9cc <_memcpy+0x14>
 9e8:	a9 63 00 00 	l.ori r11,r3,0x0
 9ec:	84 41 00 00 	l.lwz r2,0x0(r1)
 9f0:	44 00 48 00 	l.jr r9
 9f4:	9c 21 00 04 	l.addi r1,r1,0x4

000009f8 <_excpt_dummy>:
 9f8:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 9fc:	d4 01 10 00 	l.sw 0x0(r1),r2
 a00:	9c 41 00 04 	l.addi r2,r1,0x4
 a04:	84 41 00 00 	l.lwz r2,0x0(r1)
 a08:	44 00 48 00 	l.jr r9
 a0c:	9c 21 00 04 	l.addi r1,r1,0x4

00000a10 <_int_init>:
 a10:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
 a14:	d4 01 10 00 	l.sw 0x0(r1),r2
 a18:	9c 41 00 04 	l.addi r2,r1,0x4
 a1c:	18 60 00 00 	l.movhi r3,0x0
 a20:	a8 63 0c 80 	l.ori r3,r3,0xc80
 a24:	9c 80 00 1f 	l.addi r4,r0,0x1f
 a28:	9c a0 00 00 	l.addi r5,r0,0x0
 a2c:	9c 84 ff ff 	l.addi r4,r4,0xffffffff
 a30:	d4 03 28 00 	l.sw 0x0(r3),r5
 a34:	d4 03 28 04 	l.sw 0x4(r3),r5
 a38:	bd 64 00 00 	l.sfgesi r4,0x0
 a3c:	13 ff ff fc 	l.bf a2c <_int_init+0x1c>
 a40:	9c 63 00 08 	l.addi r3,r3,0x8
 a44:	a9 65 00 00 	l.ori r11,r5,0x0
 a48:	84 41 00 00 	l.lwz r2,0x0(r1)
 a4c:	44 00 48 00 	l.jr r9
 a50:	9c 21 00 04 	l.addi r1,r1,0x4

00000a54 <_int_add>:
 a54:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
 a58:	d4 01 10 04 	l.sw 0x4(r1),r2
 a5c:	9c 41 00 0c 	l.addi r2,r1,0xc
 a60:	d4 01 48 00 	l.sw 0x0(r1),r9
 a64:	d4 01 50 08 	l.sw 0x8(r1),r10
 a68:	b8 c3 00 03 	l.slli r6,r3,0x3
 a6c:	a9 43 00 00 	l.ori r10,r3,0x0
 a70:	18 e0 00 00 	l.movhi r7,0x0
 a74:	a8 e7 0c 80 	l.ori r7,r7,0xc80
 a78:	9c 60 48 00 	l.addi r3,r0,0x4800
 a7c:	e0 c6 38 00 	l.add r6,r6,r7
 a80:	bc aa 00 1f 	l.sfleui r10,0x1f
 a84:	0c 00 00 0b 	l.bnf ab0 <_int_add+0x5c>
 a88:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
 a8c:	d4 06 20 00 	l.sw 0x0(r6),r4
 a90:	07 ff ff c3 	l.jal 99c <_mfspr>
 a94:	d4 06 28 04 	l.sw 0x4(r6),r5
 a98:	9c 80 00 01 	l.addi r4,r0,0x1
 a9c:	9c 60 48 00 	l.addi r3,r0,0x4800
 aa0:	e0 84 50 08 	l.sll r4,r4,r10
 aa4:	07 ff ff b7 	l.jal 980 <_mtspr>
 aa8:	e0 8b 20 04 	l.or r4,r11,r4
 aac:	9d 60 00 00 	l.addi r11,r0,0x0
 ab0:	85 21 00 00 	l.lwz r9,0x0(r1)
 ab4:	84 41 00 04 	l.lwz r2,0x4(r1)
 ab8:	85 41 00 08 	l.lwz r10,0x8(r1)
 abc:	44 00 48 00 	l.jr r9
 ac0:	9c 21 00 0c 	l.addi r1,r1,0xc

00000ac4 <_int_disable>:
 ac4:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
 ac8:	d4 01 10 04 	l.sw 0x4(r1),r2
 acc:	9c 41 00 0c 	l.addi r2,r1,0xc
 ad0:	d4 01 48 00 	l.sw 0x0(r1),r9
 ad4:	d4 01 50 08 	l.sw 0x8(r1),r10
 ad8:	a9 43 00 00 	l.ori r10,r3,0x0
 adc:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
 ae0:	bc aa 00 1f 	l.sfleui r10,0x1f
 ae4:	0c 00 00 0b 	l.bnf b10 <_int_disable+0x4c>
 ae8:	9c 60 48 00 	l.addi r3,r0,0x4800
 aec:	07 ff ff ac 	l.jal 99c <_mfspr>
 af0:	15 00 00 00 	l.nop 0x0
 af4:	9c 80 00 01 	l.addi r4,r0,0x1
 af8:	9c 60 48 00 	l.addi r3,r0,0x4800
 afc:	e0 84 50 08 	l.sll r4,r4,r10
 b00:	ac 84 ff ff 	l.xori r4,r4,0xffffffff
 b04:	07 ff ff 9f 	l.jal 980 <_mtspr>
 b08:	e0 8b 20 03 	l.and r4,r11,r4
 b0c:	9d 60 00 00 	l.addi r11,r0,0x0
 b10:	85 21 00 00 	l.lwz r9,0x0(r1)
 b14:	84 41 00 04 	l.lwz r2,0x4(r1)
 b18:	85 41 00 08 	l.lwz r10,0x8(r1)
 b1c:	44 00 48 00 	l.jr r9
 b20:	9c 21 00 0c 	l.addi r1,r1,0xc

00000b24 <_int_enable>:
 b24:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
 b28:	d4 01 10 04 	l.sw 0x4(r1),r2
 b2c:	9c 41 00 0c 	l.addi r2,r1,0xc
 b30:	d4 01 48 00 	l.sw 0x0(r1),r9
 b34:	d4 01 50 08 	l.sw 0x8(r1),r10
 b38:	a9 43 00 00 	l.ori r10,r3,0x0
 b3c:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
 b40:	bc aa 00 1f 	l.sfleui r10,0x1f
 b44:	0c 00 00 0a 	l.bnf b6c <_int_enable+0x48>
 b48:	9c 60 48 00 	l.addi r3,r0,0x4800
 b4c:	07 ff ff 94 	l.jal 99c <_mfspr>
 b50:	15 00 00 00 	l.nop 0x0
 b54:	9c 80 00 01 	l.addi r4,r0,0x1
 b58:	9c 60 48 00 	l.addi r3,r0,0x4800
 b5c:	e0 84 50 08 	l.sll r4,r4,r10
 b60:	07 ff ff 88 	l.jal 980 <_mtspr>
 b64:	e0 8b 20 04 	l.or r4,r11,r4
 b68:	9d 60 00 00 	l.addi r11,r0,0x0
 b6c:	85 21 00 00 	l.lwz r9,0x0(r1)
 b70:	84 41 00 04 	l.lwz r2,0x4(r1)
 b74:	85 41 00 08 	l.lwz r10,0x8(r1)
 b78:	44 00 48 00 	l.jr r9
 b7c:	9c 21 00 0c 	l.addi r1,r1,0xc

00000b80 <_int_main>:
 b80:	9c 21 ff e4 	l.addi r1,r1,0xffffffe4
 b84:	d4 01 10 04 	l.sw 0x4(r1),r2
 b88:	9c 41 00 1c 	l.addi r2,r1,0x1c
 b8c:	d4 01 48 00 	l.sw 0x0(r1),r9
 b90:	d4 01 50 08 	l.sw 0x8(r1),r10
 b94:	d4 01 60 0c 	l.sw 0xc(r1),r12
 b98:	d4 01 70 10 	l.sw 0x10(r1),r14
 b9c:	d4 01 80 14 	l.sw 0x14(r1),r16
 ba0:	d4 01 90 18 	l.sw 0x18(r1),r18
 ba4:	9c 60 48 02 	l.addi r3,r0,0x4802
 ba8:	07 ff ff 7d 	l.jal 99c <_mfspr>
 bac:	9d 80 00 00 	l.addi r12,r0,0x0
 bb0:	aa 0b 00 00 	l.ori r16,r11,0x0
 bb4:	9c 60 48 02 	l.addi r3,r0,0x4802
 bb8:	a8 8c 00 00 	l.ori r4,r12,0x0
 bbc:	19 c0 00 00 	l.movhi r14,0x0
 bc0:	a9 ce 0c 80 	l.ori r14,r14,0xc80
 bc4:	07 ff ff 6f 	l.jal 980 <_mtspr>
 bc8:	9e 40 00 01 	l.addi r18,r0,0x1
 bcc:	e1 52 60 08 	l.sll r10,r18,r12
 bd0:	e0 6a 80 03 	l.and r3,r10,r16
 bd4:	bc 03 00 00 	l.sfeqi r3,0x0
 bd8:	10 00 00 0e 	l.bf c10 <_int_main+0x90>
 bdc:	9d 8c 00 01 	l.addi r12,r12,0x1
 be0:	84 8e 00 00 	l.lwz r4,0x0(r14)
 be4:	bc 04 00 00 	l.sfeqi r4,0x0
 be8:	10 00 00 0b 	l.bf c14 <_int_main+0x94>
 bec:	bc 4c 00 1f 	l.sfgtui r12,0x1f
 bf0:	48 00 20 00 	l.jalr r4
 bf4:	84 6e 00 04 	l.lwz r3,0x4(r14)
 bf8:	07 ff ff 69 	l.jal 99c <_mfspr>
 bfc:	9c 60 48 02 	l.addi r3,r0,0x4802
 c00:	ac 8a ff ff 	l.xori r4,r10,0xffffffff
 c04:	9c 60 48 02 	l.addi r3,r0,0x4802
 c08:	07 ff ff 5e 	l.jal 980 <_mtspr>
 c0c:	e0 8b 20 03 	l.and r4,r11,r4
 c10:	bc 4c 00 1f 	l.sfgtui r12,0x1f
 c14:	0f ff ff ee 	l.bnf bcc <_int_main+0x4c>
 c18:	9d ce 00 08 	l.addi r14,r14,0x8
 c1c:	85 21 00 00 	l.lwz r9,0x0(r1)
 c20:	84 41 00 04 	l.lwz r2,0x4(r1)
 c24:	85 41 00 08 	l.lwz r10,0x8(r1)
 c28:	85 81 00 0c 	l.lwz r12,0xc(r1)
 c2c:	85 c1 00 10 	l.lwz r14,0x10(r1)
 c30:	86 01 00 14 	l.lwz r16,0x14(r1)
 c34:	86 41 00 18 	l.lwz r18,0x18(r1)
 c38:	44 00 48 00 	l.jr r9
 c3c:	9c 21 00 1c 	l.addi r1,r1,0x1c
Disassembly of section .data:

00000c40 <_dst_beg>:
 c40:	00 00 09 f8 	l.j 3420 <_ram_end+0x1424>

00000c44 <_excpt_break>:
 c44:	00 00 09 f8 	l.j 3424 <_ram_end+0x1428>

00000c48 <_excpt_syscall>:
 c48:	00 00 09 f8 	l.j 3428 <_ram_end+0x142c>

00000c4c <_excpt_range>:
 c4c:	00 00 09 f8 	l.j 342c <_ram_end+0x1430>

00000c50 <_excpt_itlbmiss>:
 c50:	00 00 09 f8 	l.j 3430 <_ram_end+0x1434>

00000c54 <_excpt_dtlbmiss>:
 c54:	00 00 09 f8 	l.j 3434 <_ram_end+0x1438>

00000c58 <_excpt_int>:
 c58:	00 00 0b 80 	l.j 3a58 <_ram_end+0x1a5c>

00000c5c <_excpt_illinsn>:
 c5c:	00 00 09 f8 	l.j 343c <_ram_end+0x1440>

00000c60 <_excpt_align>:
 c60:	00 00 09 f8 	l.j 3440 <_ram_end+0x1444>

00000c64 <_excpt_tick>:
 c64:	00 00 09 f8 	l.j 3444 <_ram_end+0x1448>

00000c68 <_excpt_ipfault>:
 c68:	00 00 09 f8 	l.j 3448 <_ram_end+0x144c>

00000c6c <_excpt_dpfault>:
 c6c:	00 00 09 f8 	l.j 344c <_ram_end+0x1450>

00000c70 <_excpt_buserr>:
 c70:	00 00 09 f8 	l.j 3450 <_ram_end+0x1454>
Disassembly of section .bss:

00000c80 <_int_handlers>:
	...
Disassembly of section .stack:

00000d80 <_stack_saddr>:
	...
Disassembly of section .comment:

00000000 <.comment>:
   0:	00 47 43 43 	l.j 11d0d0c <_ram_end+0x11ced10>
   4:	3a 20 28 47 	.word 0x3a202847
   8:	4e 55 29 20 	l.maci r21,0xffff9120
   c:	33 2e 34 2e 	.word 0x332e342e
  10:	34 00 00 47 	.word 0x34000047
  14:	43 43 3a 20 	.word 0x43433a20
  18:	28 47 4e 55 	lv.max.b r2,r7,r9
  1c:	29 20 33 2e 	.word 0x2920332e
  20:	34 2e 34 00 	.word 0x342e3400
