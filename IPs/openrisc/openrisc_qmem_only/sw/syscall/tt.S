
syscall-nocache.or32:     file format elf32-or32

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
 194:	a8 63 0c 60 	l.ori r3,r3,0xc60
 198:	44 00 18 00 	l.jr r3
 19c:	15 00 00 00 	l.nop 0x0
Disassembly of section .vectors:

00000200 <_vec_start>:
	...

00000c00 <_syscall_except>:
 c00:	9d 6b 00 14 	l.addi r11,r11,0x14
 c04:	9d 6b 00 15 	l.addi r11,r11,0x15
 c08:	24 00 00 00 	l.rfe 
 c0c:	9d 6b 00 16 	l.addi r11,r11,0x16
 c10:	9d 6b 00 17 	l.addi r11,r11,0x17
 c14:	15 00 00 00 	l.nop 0x0
Disassembly of section .text:

00000c18 <_main>:
     c18:	15 00 00 00 	l.nop 0x0
     c1c:	9d 60 00 01 	l.addi r11,r0,0x1

00000c20 <_loop>:
     c20:	9d 6b 00 01 	l.addi r11,r11,0x1
     c24:	9d 6b 00 02 	l.addi r11,r11,0x2
     c28:	20 00 00 0d 	l.sys 0xd
     c2c:	9d 6b 00 03 	l.addi r11,r11,0x3
     c30:	9d 6b 00 04 	l.addi r11,r11,0x4
     c34:	9d 6b 00 05 	l.addi r11,r11,0x5
     c38:	15 00 00 00 	l.nop 0x0
     c3c:	15 00 00 00 	l.nop 0x0
     c40:	15 00 00 00 	l.nop 0x0
     c44:	19 20 de ad 	l.movhi r9,0xdead
     c48:	a9 29 de 74 	l.ori r9,r9,0xde74
     c4c:	e0 6b 48 00 	l.add r3,r11,r9
     c50:	04 00 00 54 	l.jal da0 <_report>
     c54:	15 00 00 00 	l.nop 0x0
     c58:	04 00 00 31 	l.jal d1c <_exit>
     c5c:	15 00 00 00 	l.nop 0x0

00000c60 <_start>:
     c60:	15 00 00 00 	l.nop 0x0
     c64:	9c 60 00 00 	l.addi r3,r0,0x0
     c68:	9c 80 00 00 	l.addi r4,r0,0x0
     c6c:	18 20 00 01 	l.movhi r1,0x1
     c70:	a8 21 12 00 	l.ori r1,r1,0x1200
     c74:	18 40 00 00 	l.movhi r2,0x0
     c78:	a8 42 0d 44 	l.ori r2,r2,0xd44
     c7c:	44 00 10 00 	l.jr r2
     c80:	15 00 00 00 	l.nop 0x0

00000c84 <_init_mc>:
     c84:	18 60 60 00 	l.movhi r3,0x6000
     c88:	a8 63 00 00 	l.ori r3,r3,0x0
     c8c:	9c 83 00 10 	l.addi r4,r3,0x10
     c90:	18 a0 04 00 	l.movhi r5,0x400
     c94:	b8 a5 00 86 	l.srai r5,r5,0x6
     c98:	a8 a5 00 25 	l.ori r5,r5,0x25
     c9c:	d4 04 28 00 	l.sw 0x0(r4),r5
     ca0:	9c 83 00 14 	l.addi r4,r3,0x14
     ca4:	18 a0 19 22 	l.movhi r5,0x1922
     ca8:	a8 a5 00 57 	l.ori r5,r5,0x57
     cac:	d4 04 28 00 	l.sw 0x0(r4),r5
     cb0:	9c 83 00 08 	l.addi r4,r3,0x8
     cb4:	9c a0 03 ff 	l.addi r5,r0,0x3ff
     cb8:	d4 04 28 00 	l.sw 0x0(r4),r5
     cbc:	9c 83 00 00 	l.addi r4,r3,0x0
     cc0:	18 a0 0b 00 	l.movhi r5,0xb00
     cc4:	a8 a5 03 00 	l.ori r5,r5,0x300
     cc8:	d4 04 28 00 	l.sw 0x0(r4),r5
     ccc:	9c 83 00 1c 	l.addi r4,r3,0x1c
     cd0:	18 a0 00 00 	l.movhi r5,0x0
     cd4:	a8 a5 01 03 	l.ori r5,r5,0x103
     cd8:	d4 04 28 00 	l.sw 0x0(r4),r5
     cdc:	9c 83 00 18 	l.addi r4,r3,0x18
     ce0:	18 a0 00 00 	l.movhi r5,0x0
     ce4:	b8 a5 00 86 	l.srai r5,r5,0x6
     ce8:	a8 a5 04 11 	l.ori r5,r5,0x411
     cec:	d4 04 28 00 	l.sw 0x0(r4),r5
     cf0:	9c 83 00 24 	l.addi r4,r3,0x24
     cf4:	18 a0 00 00 	l.movhi r5,0x0
     cf8:	a8 a5 01 03 	l.ori r5,r5,0x103
     cfc:	d4 04 28 00 	l.sw 0x0(r4),r5
     d00:	9c 83 00 20 	l.addi r4,r3,0x20
     d04:	18 a0 00 80 	l.movhi r5,0x80
     d08:	b8 a5 00 86 	l.srai r5,r5,0x6
     d0c:	a8 a5 04 11 	l.ori r5,r5,0x411
     d10:	d4 04 28 00 	l.sw 0x0(r4),r5
     d14:	44 00 48 00 	l.jr r9
     d18:	15 00 00 00 	l.nop 0x0

00000d1c <_exit>:
     d1c:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
     d20:	d4 01 10 00 	l.sw 0x0(r1),r2
     d24:	9c 41 00 04 	l.addi r2,r1,0x4
     d28:	e0 60 18 00 	l.add r3,r0,r3
     d2c:	15 00 00 01 	l.nop 0x1
     d30:	00 00 00 00 	l.j d30 <_exit+0x14>
     d34:	15 00 00 00 	l.nop 0x0
     d38:	84 41 00 00 	l.lwz r2,0x0(r1)
     d3c:	44 00 48 00 	l.jr r9
     d40:	9c 21 00 04 	l.addi r1,r1,0x4

00000d44 <_reset>:
     d44:	9c 21 ff f8 	l.addi r1,r1,0xfffffff8
     d48:	d4 01 10 04 	l.sw 0x4(r1),r2
     d4c:	9c 41 00 08 	l.addi r2,r1,0x8
     d50:	d4 01 48 00 	l.sw 0x0(r1),r9
     d54:	07 ff ff b1 	l.jal c18 <_main>
     d58:	15 00 00 00 	l.nop 0x0
     d5c:	07 ff ff f0 	l.jal d1c <_exit>
     d60:	a8 6b 00 00 	l.ori r3,r11,0x0
     d64:	85 21 00 00 	l.lwz r9,0x0(r1)
     d68:	84 41 00 04 	l.lwz r2,0x4(r1)
     d6c:	44 00 48 00 	l.jr r9
     d70:	9c 21 00 08 	l.addi r1,r1,0x8

00000d74 <_printf>:
     d74:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
     d78:	d4 01 10 00 	l.sw 0x0(r1),r2
     d7c:	9c 41 00 04 	l.addi r2,r1,0x4
     d80:	84 82 00 00 	l.lwz r4,0x0(r2)
     d84:	9c 62 00 04 	l.addi r3,r2,0x4
     d88:	9c 64 00 00 	l.addi r3,r4,0x0
     d8c:	9c 83 00 00 	l.addi r4,r3,0x0
     d90:	15 00 00 03 	l.nop 0x3
     d94:	84 41 00 00 	l.lwz r2,0x0(r1)
     d98:	44 00 48 00 	l.jr r9
     d9c:	9c 21 00 04 	l.addi r1,r1,0x4

00000da0 <_report>:
     da0:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
     da4:	d4 01 10 00 	l.sw 0x0(r1),r2
     da8:	9c 41 00 04 	l.addi r2,r1,0x4
     dac:	9c 63 00 00 	l.addi r3,r3,0x0
     db0:	15 00 00 02 	l.nop 0x2
     db4:	84 41 00 00 	l.lwz r2,0x0(r1)
     db8:	44 00 48 00 	l.jr r9
     dbc:	9c 21 00 04 	l.addi r1,r1,0x4

00000dc0 <___main>:
     dc0:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
     dc4:	d4 01 10 00 	l.sw 0x0(r1),r2
     dc8:	9c 41 00 04 	l.addi r2,r1,0x4
     dcc:	84 41 00 00 	l.lwz r2,0x0(r1)
     dd0:	44 00 48 00 	l.jr r9
     dd4:	9c 21 00 04 	l.addi r1,r1,0x4

00000dd8 <_start_timer>:
     dd8:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
     ddc:	d4 01 10 00 	l.sw 0x0(r1),r2
     de0:	9c 41 00 04 	l.addi r2,r1,0x4
     de4:	84 41 00 00 	l.lwz r2,0x0(r1)
     de8:	44 00 48 00 	l.jr r9
     dec:	9c 21 00 04 	l.addi r1,r1,0x4

00000df0 <_read_timer>:
     df0:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
     df4:	d4 01 10 00 	l.sw 0x0(r1),r2
     df8:	9c 41 00 04 	l.addi r2,r1,0x4
     dfc:	9d 60 00 00 	l.addi r11,r0,0x0
     e00:	84 41 00 00 	l.lwz r2,0x0(r1)
     e04:	44 00 48 00 	l.jr r9
     e08:	9c 21 00 04 	l.addi r1,r1,0x4

00000e0c <_mtspr>:
     e0c:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
     e10:	d4 01 10 00 	l.sw 0x0(r1),r2
     e14:	9c 41 00 04 	l.addi r2,r1,0x4
     e18:	c0 03 20 00 	l.mtspr r3,r4,0x0
     e1c:	84 41 00 00 	l.lwz r2,0x0(r1)
     e20:	44 00 48 00 	l.jr r9
     e24:	9c 21 00 04 	l.addi r1,r1,0x4

00000e28 <_mfspr>:
     e28:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
     e2c:	d4 01 10 00 	l.sw 0x0(r1),r2
     e30:	9c 41 00 04 	l.addi r2,r1,0x4
     e34:	b5 63 00 00 	l.mfspr r11,r3,0x0
     e38:	84 41 00 00 	l.lwz r2,0x0(r1)
     e3c:	44 00 48 00 	l.jr r9
     e40:	9c 21 00 04 	l.addi r1,r1,0x4

00000e44 <_memcpy>:
     e44:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
     e48:	d4 01 10 00 	l.sw 0x0(r1),r2
     e4c:	9c 41 00 04 	l.addi r2,r1,0x4
     e50:	00 00 00 07 	l.j e6c <_memcpy+0x28>
     e54:	9c a5 ff ff 	l.addi r5,r5,0xffffffff
     e58:	8c c4 00 00 	l.lbz r6,0x0(r4)
     e5c:	9c a5 ff ff 	l.addi r5,r5,0xffffffff
     e60:	d8 03 30 00 	l.sb 0x0(r3),r6
     e64:	9c 84 00 01 	l.addi r4,r4,0x1
     e68:	9c 63 00 01 	l.addi r3,r3,0x1
     e6c:	bc 05 ff ff 	l.sfeqi r5,0xffffffff
     e70:	0f ff ff fa 	l.bnf e58 <_memcpy+0x14>
     e74:	a9 63 00 00 	l.ori r11,r3,0x0
     e78:	84 41 00 00 	l.lwz r2,0x0(r1)
     e7c:	44 00 48 00 	l.jr r9
     e80:	9c 21 00 04 	l.addi r1,r1,0x4

00000e84 <_excpt_dummy>:
     e84:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
     e88:	d4 01 10 00 	l.sw 0x0(r1),r2
     e8c:	9c 41 00 04 	l.addi r2,r1,0x4
     e90:	84 41 00 00 	l.lwz r2,0x0(r1)
     e94:	44 00 48 00 	l.jr r9
     e98:	9c 21 00 04 	l.addi r1,r1,0x4

00000e9c <_int_init>:
     e9c:	9c 21 ff fc 	l.addi r1,r1,0xfffffffc
     ea0:	d4 01 10 00 	l.sw 0x0(r1),r2
     ea4:	9c 41 00 04 	l.addi r2,r1,0x4
     ea8:	18 60 00 00 	l.movhi r3,0x0
     eac:	a8 63 11 00 	l.ori r3,r3,0x1100
     eb0:	9c 80 00 1f 	l.addi r4,r0,0x1f
     eb4:	9c a0 00 00 	l.addi r5,r0,0x0
     eb8:	9c 84 ff ff 	l.addi r4,r4,0xffffffff
     ebc:	d4 03 28 00 	l.sw 0x0(r3),r5
     ec0:	d4 03 28 04 	l.sw 0x4(r3),r5
     ec4:	bd 64 00 00 	l.sfgesi r4,0x0
     ec8:	13 ff ff fc 	l.bf eb8 <_int_init+0x1c>
     ecc:	9c 63 00 08 	l.addi r3,r3,0x8
     ed0:	a9 65 00 00 	l.ori r11,r5,0x0
     ed4:	84 41 00 00 	l.lwz r2,0x0(r1)
     ed8:	44 00 48 00 	l.jr r9
     edc:	9c 21 00 04 	l.addi r1,r1,0x4

00000ee0 <_int_add>:
     ee0:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
     ee4:	d4 01 10 04 	l.sw 0x4(r1),r2
     ee8:	9c 41 00 0c 	l.addi r2,r1,0xc
     eec:	d4 01 48 00 	l.sw 0x0(r1),r9
     ef0:	d4 01 50 08 	l.sw 0x8(r1),r10
     ef4:	b8 c3 00 03 	l.slli r6,r3,0x3
     ef8:	a9 43 00 00 	l.ori r10,r3,0x0
     efc:	18 e0 00 00 	l.movhi r7,0x0
     f00:	a8 e7 11 00 	l.ori r7,r7,0x1100
     f04:	9c 60 48 00 	l.addi r3,r0,0x4800
     f08:	e0 c6 38 00 	l.add r6,r6,r7
     f0c:	bc aa 00 1f 	l.sfleui r10,0x1f
     f10:	0c 00 00 0b 	l.bnf f3c <_int_add+0x5c>
     f14:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
     f18:	d4 06 20 00 	l.sw 0x0(r6),r4
     f1c:	07 ff ff c3 	l.jal e28 <_mfspr>
     f20:	d4 06 28 04 	l.sw 0x4(r6),r5
     f24:	9c 80 00 01 	l.addi r4,r0,0x1
     f28:	9c 60 48 00 	l.addi r3,r0,0x4800
     f2c:	e0 84 50 08 	l.sll r4,r4,r10
     f30:	07 ff ff b7 	l.jal e0c <_mtspr>
     f34:	e0 8b 20 04 	l.or r4,r11,r4
     f38:	9d 60 00 00 	l.addi r11,r0,0x0
     f3c:	85 21 00 00 	l.lwz r9,0x0(r1)
     f40:	84 41 00 04 	l.lwz r2,0x4(r1)
     f44:	85 41 00 08 	l.lwz r10,0x8(r1)
     f48:	44 00 48 00 	l.jr r9
     f4c:	9c 21 00 0c 	l.addi r1,r1,0xc

00000f50 <_int_disable>:
     f50:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
     f54:	d4 01 10 04 	l.sw 0x4(r1),r2
     f58:	9c 41 00 0c 	l.addi r2,r1,0xc
     f5c:	d4 01 48 00 	l.sw 0x0(r1),r9
     f60:	d4 01 50 08 	l.sw 0x8(r1),r10
     f64:	a9 43 00 00 	l.ori r10,r3,0x0
     f68:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
     f6c:	bc aa 00 1f 	l.sfleui r10,0x1f
     f70:	0c 00 00 0b 	l.bnf f9c <_int_disable+0x4c>
     f74:	9c 60 48 00 	l.addi r3,r0,0x4800
     f78:	07 ff ff ac 	l.jal e28 <_mfspr>
     f7c:	15 00 00 00 	l.nop 0x0
     f80:	9c 80 00 01 	l.addi r4,r0,0x1
     f84:	9c 60 48 00 	l.addi r3,r0,0x4800
     f88:	e0 84 50 08 	l.sll r4,r4,r10
     f8c:	ac 84 ff ff 	l.xori r4,r4,0xffffffff
     f90:	07 ff ff 9f 	l.jal e0c <_mtspr>
     f94:	e0 8b 20 03 	l.and r4,r11,r4
     f98:	9d 60 00 00 	l.addi r11,r0,0x0
     f9c:	85 21 00 00 	l.lwz r9,0x0(r1)
     fa0:	84 41 00 04 	l.lwz r2,0x4(r1)
     fa4:	85 41 00 08 	l.lwz r10,0x8(r1)
     fa8:	44 00 48 00 	l.jr r9
     fac:	9c 21 00 0c 	l.addi r1,r1,0xc

00000fb0 <_int_enable>:
     fb0:	9c 21 ff f4 	l.addi r1,r1,0xfffffff4
     fb4:	d4 01 10 04 	l.sw 0x4(r1),r2
     fb8:	9c 41 00 0c 	l.addi r2,r1,0xc
     fbc:	d4 01 48 00 	l.sw 0x0(r1),r9
     fc0:	d4 01 50 08 	l.sw 0x8(r1),r10
     fc4:	a9 43 00 00 	l.ori r10,r3,0x0
     fc8:	9d 60 ff ff 	l.addi r11,r0,0xffffffff
     fcc:	bc aa 00 1f 	l.sfleui r10,0x1f
     fd0:	0c 00 00 0a 	l.bnf ff8 <_int_enable+0x48>
     fd4:	9c 60 48 00 	l.addi r3,r0,0x4800
     fd8:	07 ff ff 94 	l.jal e28 <_mfspr>
     fdc:	15 00 00 00 	l.nop 0x0
     fe0:	9c 80 00 01 	l.addi r4,r0,0x1
     fe4:	9c 60 48 00 	l.addi r3,r0,0x4800
     fe8:	e0 84 50 08 	l.sll r4,r4,r10
     fec:	07 ff ff 88 	l.jal e0c <_mtspr>
     ff0:	e0 8b 20 04 	l.or r4,r11,r4
     ff4:	9d 60 00 00 	l.addi r11,r0,0x0
     ff8:	85 21 00 00 	l.lwz r9,0x0(r1)
     ffc:	84 41 00 04 	l.lwz r2,0x4(r1)
    1000:	85 41 00 08 	l.lwz r10,0x8(r1)
    1004:	44 00 48 00 	l.jr r9
    1008:	9c 21 00 0c 	l.addi r1,r1,0xc

0000100c <_int_main>:
    100c:	9c 21 ff e4 	l.addi r1,r1,0xffffffe4
    1010:	d4 01 10 04 	l.sw 0x4(r1),r2
    1014:	9c 41 00 1c 	l.addi r2,r1,0x1c
    1018:	d4 01 48 00 	l.sw 0x0(r1),r9
    101c:	d4 01 50 08 	l.sw 0x8(r1),r10
    1020:	d4 01 60 0c 	l.sw 0xc(r1),r12
    1024:	d4 01 70 10 	l.sw 0x10(r1),r14
    1028:	d4 01 80 14 	l.sw 0x14(r1),r16
    102c:	d4 01 90 18 	l.sw 0x18(r1),r18
    1030:	9c 60 48 02 	l.addi r3,r0,0x4802
    1034:	07 ff ff 7d 	l.jal e28 <_mfspr>
    1038:	9d 80 00 00 	l.addi r12,r0,0x0
    103c:	aa 0b 00 00 	l.ori r16,r11,0x0
    1040:	9c 60 48 02 	l.addi r3,r0,0x4802
    1044:	a8 8c 00 00 	l.ori r4,r12,0x0
    1048:	19 c0 00 00 	l.movhi r14,0x0
    104c:	a9 ce 11 00 	l.ori r14,r14,0x1100
    1050:	07 ff ff 6f 	l.jal e0c <_mtspr>
    1054:	9e 40 00 01 	l.addi r18,r0,0x1
    1058:	e1 52 60 08 	l.sll r10,r18,r12
    105c:	e0 6a 80 03 	l.and r3,r10,r16
    1060:	bc 03 00 00 	l.sfeqi r3,0x0
    1064:	10 00 00 0e 	l.bf 109c <_int_main+0x90>
    1068:	9d 8c 00 01 	l.addi r12,r12,0x1
    106c:	84 8e 00 00 	l.lwz r4,0x0(r14)
    1070:	bc 04 00 00 	l.sfeqi r4,0x0
    1074:	10 00 00 0b 	l.bf 10a0 <_int_main+0x94>
    1078:	bc 4c 00 1f 	l.sfgtui r12,0x1f
    107c:	48 00 20 00 	l.jalr r4
    1080:	84 6e 00 04 	l.lwz r3,0x4(r14)
    1084:	07 ff ff 69 	l.jal e28 <_mfspr>
    1088:	9c 60 48 02 	l.addi r3,r0,0x4802
    108c:	ac 8a ff ff 	l.xori r4,r10,0xffffffff
    1090:	9c 60 48 02 	l.addi r3,r0,0x4802
    1094:	07 ff ff 5e 	l.jal e0c <_mtspr>
    1098:	e0 8b 20 03 	l.and r4,r11,r4
    109c:	bc 4c 00 1f 	l.sfgtui r12,0x1f
    10a0:	0f ff ff ee 	l.bnf 1058 <_int_main+0x4c>
    10a4:	9d ce 00 08 	l.addi r14,r14,0x8
    10a8:	85 21 00 00 	l.lwz r9,0x0(r1)
    10ac:	84 41 00 04 	l.lwz r2,0x4(r1)
    10b0:	85 41 00 08 	l.lwz r10,0x8(r1)
    10b4:	85 81 00 0c 	l.lwz r12,0xc(r1)
    10b8:	85 c1 00 10 	l.lwz r14,0x10(r1)
    10bc:	86 01 00 14 	l.lwz r16,0x14(r1)
    10c0:	86 41 00 18 	l.lwz r18,0x18(r1)
    10c4:	44 00 48 00 	l.jr r9
    10c8:	9c 21 00 1c 	l.addi r1,r1,0x1c
Disassembly of section .data:

000010cc <_dst_beg>:
    10cc:	00 00 0e 84 	l.j 4adc <_dst_end+0x39dc>

000010d0 <_excpt_break>:
    10d0:	00 00 0e 84 	l.j 4ae0 <_dst_end+0x39e0>

000010d4 <_excpt_syscall>:
    10d4:	00 00 0e 84 	l.j 4ae4 <_dst_end+0x39e4>

000010d8 <_excpt_range>:
    10d8:	00 00 0e 84 	l.j 4ae8 <_dst_end+0x39e8>

000010dc <_excpt_itlbmiss>:
    10dc:	00 00 0e 84 	l.j 4aec <_dst_end+0x39ec>

000010e0 <_excpt_dtlbmiss>:
    10e0:	00 00 0e 84 	l.j 4af0 <_dst_end+0x39f0>

000010e4 <_excpt_int>:
    10e4:	00 00 10 0c 	l.j 5114 <_dst_end+0x4014>

000010e8 <_excpt_illinsn>:
    10e8:	00 00 0e 84 	l.j 4af8 <_dst_end+0x39f8>

000010ec <_excpt_align>:
    10ec:	00 00 0e 84 	l.j 4afc <_dst_end+0x39fc>

000010f0 <_excpt_tick>:
    10f0:	00 00 0e 84 	l.j 4b00 <_dst_end+0x3a00>

000010f4 <_excpt_ipfault>:
    10f4:	00 00 0e 84 	l.j 4b04 <_dst_end+0x3a04>

000010f8 <_excpt_dpfault>:
    10f8:	00 00 0e 84 	l.j 4b08 <_dst_end+0x3a08>

000010fc <_excpt_buserr>:
    10fc:	00 00 0e 84 	l.j 4b0c <_dst_end+0x3a0c>
Disassembly of section .bss:

00001100 <_int_handlers>:
	...
Disassembly of section .stack:

00001200 <_src_addr-0x10000>:
	...
Disassembly of section .comment:

00000000 <.comment>:
   0:	00 47 43 43 	l.j 11d0d0c <_src_addr+0x11bfb0c>
   4:	3a 20 28 47 	.word 0x3a202847
   8:	4e 55 29 20 	l.maci r21,0xffff9120
   c:	33 2e 34 2e 	.word 0x332e342e
  10:	34 00 00 47 	.word 0x34000047
  14:	43 43 3a 20 	.word 0x43433a20
  18:	28 47 4e 55 	lv.max.b r2,r7,r9
  1c:	29 20 33 2e 	.word 0x2920332e
  20:	34 2e 34 00 	.word 0x342e3400
