/***************************************
	I/Oアクセス部ヘッダファイル
****************************************/

#include "typedef.h"

#ifdef IDE1		/* プライマリIDE */
	#define LITTLE_ENDIAN	1		/* エンディアン選択 */
	#define ATA_IRQ_NO		14		/* IRQ14 */
	#define BASE_ATA_REGS	0x1F0	/* ATAレジスタベースアドレス */
	#define CTRL_BLK_ADDR	0x3F6
#endif

#ifdef IDE2		/* セカンダリIDE */
	#define LITTLE_ENDIAN	1		/* エンディアン選択 */
	#define ATA_IRQ_NO		15		/* IRQ15 */
	#define BASE_ATA_REGS	0x170	/* ATAレジスタベースアドレス */
	#define CTRL_BLK_ADDR	0x376
#endif

#ifdef PCI		/* PCIバス対応 ATAホストインターフェース用 */
	#define LITTLE_ENDIAN	1		/* エンディアン選択 */
	extern int ATA_IRQ_NO;			/* 割り当てられたIRQ */
	extern int BASE_ATA_REGS;		/* 割り当てられた ATAレジスタベースアドレス */
	extern int CTRL_BLK_ADDR;
	extern int Bus;					/* バス番号 */
	extern int Dev;					/* デバイス番号 */
	extern int Func;				/* ファンクション番号 */
#endif

#ifdef SH4B		/* SH-4 ビッグエンディアン */
	#define BIG_ENDIAN		1		/* エンディアン選択 */
	#define ATA_INT_LVL		8		/* 割り込みレベル8 */
	#define BASE_ATA_REGS	0xA40001F0	/* ATAレジスタベースアドレス */
	#define CTRL_BLK_ADDR	0xA40003F6
#endif
#ifdef SH4L		/* SH-4 リトルエンディアン */
	#define LITTLE_ENDIAN	1		/* エンディアン選択 */
	#define ATA_INT_LVL		8		/* 割り込みレベル8 */
	#define BASE_ATA_REGS	0xA40001F0	/* ATAレジスタベースアドレス */
	#define CTRL_BLK_ADDR	0xA40003F6
#endif

#ifdef SH3B		/* SH-3 ビッグエンディアン */
	#define BIG_ENDIAN		1		/* エンディアン選択 */
	#define ATA_INT_LVL		8		/* 割り込みレベル8 */
	#define BASE_ATA_REGS	0xB40001F0	/* ATAレジスタベースアドレス */
	#define CTRL_BLK_ADDR	0xB40003F6
#endif
#ifdef SH3L		/* SH-3 リトルエンディアン */
	#define LITTLE_ENDIAN	1		/* エンディアン選択 */
	#define ATA_INT_LVL		8		/* 割り込みレベル8 */
	#define BASE_ATA_REGS	0xB40001F0	/* ATAレジスタベースアドレス */
	#define CTRL_BLK_ADDR	0xB40003F6
#endif

/* タイムアウトループ回数 */
#define ATA_TIMEOUT		20000000L
/* ATA_TIMEOUTの値は、下記のループの実行が数秒程度になる回数が目安
	for (l=1;l<ATA_TIMEOUT;l++) {
		c=in_byte(ATA_ASR);	ステータスレジスタの読み出し
		if (((c & BIT_BSY)==0)&&((c & BIT_DRQ)==0)) break;	BSYビットなどのチェック
		if ????		いくつかのビット判定処理
		IDE_ata_wait(ATA_WAIT10us);
	}
*/

/*********** 共通定義 ************/

/* ATAレジスタオフセットアドレス */
#define ATA_DTR     (BASE_ATA_REGS+0)
#define ATA_ERR     (BASE_ATA_REGS+1)
#define ATA_FTR     (BASE_ATA_REGS+1)
#define ATA_SCR     (BASE_ATA_REGS+2)
#define ATA_IRR     (BASE_ATA_REGS+2)
#define ATA_SNR     (BASE_ATA_REGS+3)
#define ATA_CLR     (BASE_ATA_REGS+4)
#define ATA_BLR     (BASE_ATA_REGS+4)
#define ATA_CHR     (BASE_ATA_REGS+5)
#define ATA_BHR     (BASE_ATA_REGS+5)
#define ATA_DHR     (BASE_ATA_REGS+6)
#define ATA_STR     (BASE_ATA_REGS+7)
#define ATA_CMR     (BASE_ATA_REGS+7)
#define ATA_ASR     CTRL_BLK_ADDR
#define ATA_DCR     CTRL_BLK_ADDR


/*************************/
/* 物理I/Oアクセスレベル */
/*************************/

/* バイトサイズ入力 */
UBYTE in_byte(unsigned int);

/* ワードサイズ入力 */
UWORD in_word(unsigned int);

/* バイトサイズ出力 */
void out_byte(unsigned int, UBYTE);

/* ワードサイズ出力 */
void out_word(unsigned int, UWORD);

/* ATAレジスタアクセスウェイト */
void ide_ata_wait(UDWORD);

/* ホストコントローラのモード設定 */
void IDE_initialize_host_mode(int, int);
