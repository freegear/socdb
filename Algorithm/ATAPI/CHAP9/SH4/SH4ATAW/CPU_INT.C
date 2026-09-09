/******************************************************************************
	CQ RISC評価キット/SH-4 割り込み処理ベクタ初期化
******************************************************************************/

#include	<stdio.h>
#include	"sh4.h"

/* SH-4 割り込みベクタテーブル 0x08F00000～ */
extern char _ex_int_start_[],_ex_int_end_[];
extern char _TLBex_int_start_[],_TLBex_int_end_[];
extern char _int_start_[],_int_end_[];

/*  割り込み処理初期化 */
void CPUInt_Init(int IRLlvl)
{
	/* VBR(VBR_ADR=0x08F00000)に割り込みベクタを転送 */
	/* VBRをセット */
	asm("ldc	%0,vbr"::"r"(VBR_ADR));
	/* 一般例外処理 転送 */
	movmem(_ex_int_start_,(void *)(VBR_ADR+0x100),_ex_int_end_-_ex_int_start_);
	/* 命令TLBミス例外およびﾃデータTLBミス例外 転送 */
	movmem(_TLBex_int_start_,(void *)(VBR_ADR+0x400),_TLBex_int_end_-_TLBex_int_start_);
	/* 割り込み処理 転送 */
	movmem(_int_start_,(void *)(VBR_ADR+0x600),_int_end_-_int_start_);

	/* CPU割り込み受け付けレベル */
	IntMskSet(IRLlvl);
	/* CPUInt_Mask(1);	CPU割り込み許可 */
}

/* CPU割り込みマスク設定 */
/* 引き数：1で割り込み許可,0で割り込みマスク */
asm("
	.align 2
_CPUInt_Mask:
.globl _CPUInt_Mask
	mov	r4,r0
	and	#1,r0
	xor	#1,r0	/* Cプログラムの引き数の論理と逆 */
	shll16	r0
	shll8	r0
	shll2	r0
	shll2	r0
	mov	r0,r4
	stc	sr,r0
	mov.l	L030,r1
	and	r1,r0
	or	r4,r0
	ldc	r0,sr	/* 0で割り込み許可,1で割り込みマスク */
	rts
	nop
	.align 2
L030:
	.long	0xefffffff
");


asm("	.text
	.align	2

/* 一般例外(命令TLBミス例外およびデータTLBミス例外を除く) */
	.org 0x100
.global	__ex_int_start_
.global	__ex_int_end_
__ex_int_start_:
	nop
	nop
	nop
__ex_ent_99:
	bra	__ex_ent_99
	nop
__ex_int_end_:


/* 命令TLBミス例外およびデータTLBミス例外 */
	.org	0x0400
.global	__TLBex_int_start_
.global	__TLBex_int_end_
__TLBex_int_start_:
	nop
	nop
	nop
__TLBex_ent_99:
	bra	__TLBex_ent_99
	nop
__TLBex_int_end_:


/* 一般割り込み */
	.org 0x600

.global	__int_start_
.global	__int_end_
__int_start_:
	/* レジスタ退避 */
	stc.l	ssr,@-r15
	stc.l	spc,@-r15
	mov.l	r0,@-r15
	mov.l	r1,@-r15
	mov.l	r2,@-r15
	mov.l	r3,@-r15
	mov.l	r4,@-r15
	mov.l	r5,@-r15
	mov.l	r6,@-r15
	mov.l	r7,@-r15
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	mov.l	r13,@-r15
	mov.l	r14,@-r15
	sts.l	pr,@-r15

	/* 割り込み要因判定 */
	mov.l	INTEVT,r1
	mov.l	@r1,r0
	shlr2	r0
	shlr2	r0
	mov	#0x20,r1	/* レベル15の外部割り込みのイベントコード/16 */
	mov	#15,r2		/* レベル15 */
	mov	#1,r3
	mov	#0,r4
	mov.l	IRL_adr,r5	/* レベル15の外部割込み処理関数アドレステーブル */

loopIRL0:
	cmp/eq	r1,r0		/* IRL15から順にイベントコードを調べる */
	bf	nextIRL0		/* 違う */
		/* このレベルの外部割り込み処理関数アドレス読み出し */
		mov.l	@r5,r0
		jsr	@r0	/* 割り込み関数呼び出し */
		nop
		bra	int_ret
		nop

nextIRL0:
	add	#2,r1		/* イベントコード +2h(+20h/16) */
	add	#4,r5		/* 割り込み処理関数アドレステーブル+4 */
	sub	r3,r2		/* レベル-1 */
	cmp/eq	r4,r2	/* レベル0でなかったら T=0 */
	bf	loopIRL0	/* ループ */

	/* タイマー割り込み確認 */
	cmp/eq	#0x40,r0	/* TMU0割り込みのイベントコード */
	bf	nextIRL1	/* 違う */
		/* TMU0のタイマー割込み関数呼び出し */
		mov.l	TIMERInt_tbl,r0
		jsr	@r0
		nop
		bra	int_ret
		nop

	.align 2
INTEVT:
	.long	0xFF000028	/* INTEVTレジスタアドレス */
IRL_adr:
	.long	IRL_tbl	/* 割り込み処理関数アドレステーブル先頭アドレス */
IRL_tbl:	/* 割り込み処理関数アドレステーブル */
	.long	int_nonuse	/* 外部割り込みルーチン レベル15 */
	.long	int_nonuse	/* 外部割り込みルーチン レベル14 */
	.long	int_nonuse	/* 外部割り込みルーチン レベル13 */
	.long	int_nonuse	/* 外部割り込みルーチン レベル12 */
	.long	int_nonuse	/* 外部割り込みルーチン レベル11 */
	.long	int_nonuse	/* 外部割り込みルーチン レベル10 */
	.long	int_nonuse	/* 外部割り込みルーチン レベル9 */
	.long	_IDE_atapi_packet_interrupt	/* 外部割り込みルーチン レベル8 */
	.long	int_nonuse	/* 外部割り込みルーチン レベル7 */
	.long	int_nonuse	/* 外部割り込みルーチン レベル6 */
	.long	int_nonuse	/* 外部割り込みルーチン レベル5 */
	.long	int_nonuse	/* 外部割り込みルーチン レベル4 */
	.long	int_nonuse	/* 外部割り込みルーチン レベル3 */
	.long	int_nonuse	/* 外部割り込みルーチン レベル2 */
	.long	int_nonuse	/* 外部割り込みルーチン レベル1 */
TIMERInt_tbl:
	.long	_SystemTimer_Int
IPRA:
	.long	0xFFD00004

nextIRL1:
int_ret:
	lds.l	@r15+,pr
	mov.l	@r15+,r14
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	mov.l	@r15+,r8
	mov.l	@r15+,r7
	mov.l	@r15+,r6
	mov.l	@r15+,r5
	mov.l	@r15+,r4
	mov.l	@r15+,r3
	mov.l	@r15+,r2
	mov.l	@r15+,r1
	mov.l	@r15+,r0
	ldc.l	@r15+,spc
	ldc.l	@r15+,ssr
	rte
	nop

int_nonuse:	/* 何もしないでリターン */
	rts
	nop

	.align 2
BANK1_Reg:
	.long	0x20000000
__int_end_:
");

/* CPU割り込み受け付けレベル設定 */
/* 引き数：割り込み受け付けレベル 0～15 */
asm("
	.align 2
_IntMskSet:
.globl _IntMskSet
	mov	r4,r0
	and	#15,r0
	shll2	r0
	shll2	r0
	mov	r0,r4
	stc	sr,r0
	mov.l	L020,r1
	and	r1,r0
	or	r4,r0
	ldc	r0,sr
	rts
	nop
	.align 2
L020:
	.long	0xffffff0f
");

