/********************************
	ATA(IDE)/ATAPI制御 BIOS
*********************************/

#include "typedef.h"
#include "iodef.h"
#include "ide_bios.h"

/* ATAエラーレジスタビット定義 */
#define BIT_NM		2		/* メディアがない */
#define BIT_MCR		8		/* メディアチェンジが要求された */
#define BIT_MC		0x20	/* メディアがチェンジされた */
#define BIT_WP		0x40	/* メディアがライトプロテクト状態である */

/* ATAステータスレジスタビット定義 */
#define BIT_BSY		0x80	/* Status reg. bit7 */
#define BIT_DRDY	0x40	/* Status reg. bit6 */
#define BIT_DRQ		8		/* Status reg. bit3 */
#define BIT_ABRT	4		/* Error reg.  bit2 */
#define BIT_CHK		1		/* Status reg. bit0 (ATAPI) */
#define BIT_ERR		1		/* Status reg. bit0 (ATA) */
#define BIT_IO		2		/* Interrup Reason reg. bit1 */
#define BIT_CD		1		/* Interrup Reason reg. bit0 */

/* そのほか定数定義 */
#define DEV_HEAD_obs	0xa0	/* Device/Headレジスタのobsビットの値(bit8/bit6) */
#define LBA_flg			0x40	/* LBA or CHS選択ビット */
#ifndef NULL
	#define NULL		((void *)0)
#endif

/* IDE BIOS 内部ワーク用変数 */
UWORD identify_data[2][256];	/* IDENTIFY DEVICE情報格納配列(256ワード) */
int device_type[2];				/* デバイスタイプ */
int chs_lba[2];					/* CHSアクセスデバイスかLBA対応デバイスか */
int PIO_mode;					/* PIO転送モード */
int DMA_mode	;				/* DMA転送モード */
int active_device;				/* 現在どちらのデバイスが選択されているか */
UDWORD device_ready[2];			/* デバイスのレディ状態保存 */
UWORD device_secter_size[2];	/* メディアのセクタサイズ */

/* パケットコマンドの処理を割り込みを使って行う場合 */
#ifdef USE_INTERRUPT
volatile int atapi_interrupt_state;	/* 割り込み処理ステート状態変数 */
#define ST_IDLE				0		/* ステート定義 */
#define ST_COMMAND			1
#define ST_MESSAGE			2
#define ST_DATATOHOST		3
#define ST_DATAFROMHOST		4
#define ST_STATUS			5
#define ST_RELEASE			6
volatile void *atapi_interrupt_buff;	/* 割り込み処理ルーチンで使用するバッファポインタ */
volatile UWORD atapi_interrupt_limit;	/* 割り込み処理ルーチンで使用する最大転送バイト数 */
#endif
volatile UWORD atapi_datatransfer;	/* ATAPIで転送したバイト数 */

/* ATAコマンド発行用 構造体 */
struct STRUCT_ATA_CMD {
	UBYTE feature;	/* フィ－チャーレジスタ */
	UBYTE sec_cnt;	/* セクタカウントレジスタ */
	UBYTE sec_no;	/* セクタナンバレジスタ */
	UBYTE cyl_lo;	/* シリンダ下位レジスタ */
	UBYTE cyl_hi;	/* シリンダ上位レジスタ */
	UBYTE dev_hed;	/* デバイス/ヘッドレジスタ */
	UBYTE command;	/* コマンドレジスタ */
	UBYTE DRDY_Chk;	/* コマンドレジスタ */
};

/* ATAPIパケットコマンド発行用 構造体 */
struct STRUCT_ATAPI_CMD {
	UBYTE feature; 			/* overlap/DMAの設定 */
	UBYTE dev_sel;			/* デバイスセレクト(0:デバイス0/1:デバイス1) */
	UBYTE cmd_packet[12];	/* コマンドパケット */
};



/*****************************/
/* ATAレジスタアクセスレベル */
/*****************************/

/* データレジスタ ブロックデータリード */
void ide_ata_read_data(UWORD len, void* buff)
{
	UWORD i,*p;
	p=(UWORD *)buff;
	if (p==NULL) {	/* データの空読み */
		for(i=0;i<len;i++){
			in_word(ATA_DTR);
		}
	} else {		/* データバッファへ書き込み */
		for(i=0;i<len;i++){
			*p=in_word(ATA_DTR);
			p++;
		}
	}
}

/* データレジスタ ブロックデータライト */
void ide_ata_write_data(UWORD len, void* buff)
{
	UWORD i,*p;
	p=(UWORD *)buff;
	if (p==NULL) {	/* ダミーデータ(00h)の書き込み */
		for(i=0;i<len;i++){
			out_word(ATA_DTR,0);
			p++;
		}
	} else {		/* データバッファから読み出し */
		for(i=0;i<len;i++){
			out_word(ATA_DTR,*p);
			p++;
		}
	}
}

/* ソフトウェアリセット */
void ide_ata_reset(void)
{
	out_byte(ATA_DCR,0x6);			/* ソフトリセット */
	ide_ata_wait(ATA_WAIT5ms);		/* 5msウェイト */
	out_byte(ATA_DCR,0x2);			/* ソフトリセット解除 & 割り込み禁止 */
	ide_ata_wait(ATA_WAIT5ms);		/* 5msウェイト */
}



/*******************************/
/* ATAコマンドプロトコル処理部 */
/*******************************/

/* BSYビットがクリアされるまでウェイト */
int ide_wait_bsyclr(void)
{
	UBYTE c;
	UDWORD l;
	for (l=0;l<ATA_TIMEOUT;l++){
		c=in_byte(ATA_ASR);
		if ((c&BIT_BSY)==0) break;
	}
	if (l==ATA_TIMEOUT) return -1;
	return 0;
}

/* DRDYビットが立つまでウェイト */
void ide_wait_drdyset(void)
{
	UBYTE c;
	UDWORD l;
	for (l=0;l<ATA_TIMEOUT;l++){
		c=in_byte(ATA_ASR);
		if (c&BIT_DRDY) break;
	}
}

/* デバイスセレクションプロトコル */
int ide_ata_device_select(int dev_head)
{
	int err_flg;
	UDWORD l;
	UBYTE c;
	err_flg=0;
	for (l=0;l<ATA_TIMEOUT;l++){
		c=in_byte(ATA_ASR);
		if (((c & BIT_BSY)==0)&&((c & BIT_DRQ)==0)) break;
	}
	if (l==ATA_TIMEOUT) err_flg=1;	/* タイムアウトエラーフラグ */
	out_byte(ATA_DHR,dev_head);		/* デバイス選択 */
	ide_ata_wait(ATA_WAIT400ns);	/* 400nsウェイト */
	for (l=0;l<ATA_TIMEOUT;l++) {
		c=in_byte(ATA_ASR);
		if (((c & BIT_BSY)==0)&&((c & BIT_DRQ)==0)) break;
	}
	if (l==ATA_TIMEOUT) err_flg=err_flg|2;	/* タイムアウトエラーフラグ */
	return err_flg;	/* 正常終了時=0 */
}

/* Non-data command プロトコル */
int ide_ata_non_data_cmd(struct STRUCT_ATA_CMD *ata_cmd)
{
	UBYTE c;
	UDWORD l;
	c=(ata_cmd->dev_hed>>4)&1;
	if (active_device != c) {	/* 現在選択されているドライブでなければ */
		active_device = (int)c;	/* デバイスセレクション */
		if (ide_ata_device_select(ata_cmd->dev_hed)!=0) return -1;	/* セレクションエラー */
	} else {	/* デバイスセレクションフェーズは行わずにDevice/Headレジスタへ書き込み */
		out_byte(ATA_DHR,ata_cmd->dev_hed);
	}
	out_byte(ATA_DCR,0x2);				/* 割り込み未使用 */
	out_byte(ATA_FTR,ata_cmd->feature);	/* フィーチャー */
	out_byte(ATA_SCR,ata_cmd->sec_cnt);	/* セクタカウント */
	out_byte(ATA_SNR,ata_cmd->sec_no);	/* セクタナンバ */
	out_byte(ATA_CLR,ata_cmd->cyl_lo);	/* シリンダLo */
	out_byte(ATA_CHR,ata_cmd->cyl_hi);	/* シリンダHi */
	if (ata_cmd->DRDY_Chk) ide_wait_drdyset();	/* DRDYビットウェイト */
	out_byte(ATA_CMR,ata_cmd->command);	/* コマンド */
	ide_ata_wait(ATA_WAIT400ns);		/* 400nsウェイト */
	for (l=0;l<ATA_TIMEOUT;l++) {		/* タイムアウトまでループ */
		c=in_byte(ATA_STR);				/* Statusレジスタ */
		if ((c & BIT_BSY)==0) break;	/* コマンド実行終了 */
	}
	if (l==ATA_TIMEOUT) return -2;		/* タイムアウトエラー */
	in_byte(ATA_ASR);					/* Alternate Statusレジスタ */
	c=in_byte(ATA_STR);					/* Statusレジスタ */
	if (c & BIT_ERR) {					/* エラー終了 */
		c=in_byte(ATA_ERR);				/* 戻り値の下位8ビットをErrorレジスタの値とする */
		return 0x1000|(unsigned int)c;	/* エラー終了 != 0 */
	} else {							/* コマンド正常実行終了時 */
		return 0;						/* 正常終了 = 0 */
	}
}

/* PIO data in command プロトコル */
int ide_ata_pio_datain_cmd(struct STRUCT_ATA_CMD *ata_cmd, UWORD count, void *buff)
{
	UBYTE c;
	UWORD i,*p;
	UDWORD l;
	p=(UWORD *)buff;
	c=(ata_cmd->dev_hed>>4)&1;
	if (active_device != c) {	/* 現在選択されているドライブでなければ */
		active_device = (int)c;	/* デバイスセレクション */
		if (ide_ata_device_select(ata_cmd->dev_hed)!=0) return -1;	/* セレクションエラー */
	} else {	/* デバイスセレクションフェーズは行わずにDevice/Headレジスタへ書き込み */
		out_byte(ATA_DHR,ata_cmd->dev_hed);
	}
	out_byte(ATA_DCR,0x2);				/* 割り込み未使用 */
	out_byte(ATA_FTR,ata_cmd->feature);	/* フィーチャー */
	out_byte(ATA_SCR,ata_cmd->sec_cnt);	/* セクタカウント */
	out_byte(ATA_SNR,ata_cmd->sec_no);	/* セクタナンバ */
	out_byte(ATA_CLR,ata_cmd->cyl_lo);	/* シリンダLo */
	out_byte(ATA_CHR,ata_cmd->cyl_hi);	/* シリンダHi */
	if (ata_cmd->DRDY_Chk) ide_wait_drdyset();	/* DRDYビットウェイト */
	out_byte(ATA_CMR,ata_cmd->command);	/* コマンド */
	ide_ata_wait(ATA_WAIT400ns);		/* 400nsウェイト */
	in_byte(ATA_ASR);					/* Alternate Statusレジスタ空読み */
	for(i=0;i<count;i++) {				/* 読み出しブロック数ループ */
		for (l=0;l<ATA_TIMEOUT;l++) {	/* タイムアウトまでループ */
			c=in_byte(ATA_STR);			/* Statusレジスタ */
			if ((c & BIT_BSY)==0) break;/* コマンド実行終了 */
		}
		if (l==ATA_TIMEOUT) return -2;	/* タイムアウトエラー */
		c=in_byte(ATA_STR);				/* Statusレジスタ */
		if ((c & BIT_ERR)!=0) {			/* コマンド実行エラー */
			break;						/* コマンドエラー終了*/
		}
		if ((c & BIT_DRQ)==0) {			/* なぜかデータが用意されていない */
			return -3;					/* コマンド未実行エラー */
		} else {						/* データが用意されている */
			ide_ata_read_data(256,p);	/* ブロック読み出し(256ワード) */
		}
		p=p+256;						/* データバッファポインタインクリメント */
	}
	in_byte(ATA_ASR);					/* Alternate Statusレジスタ */
	c=in_byte(ATA_STR);					/* Statusレジスタ */
	if (c & BIT_ERR) {					/* エラー終了 */
		c=in_byte(ATA_ERR);				/* 戻り値の下位8ビットをErrorレジスタの値とする */
		return 0x1000|(unsigned int)c;	/* エラー終了 != 0 */
	} else {							/* コマンド正常実行終了時 */
		return 0;						/* 正常終了 = 0 */
	}
}

/* PIO data out command プロトコル */
int ide_ata_pio_dataout_cmd(struct STRUCT_ATA_CMD *ata_cmd, UWORD count, void *buff)
{
	UBYTE c;
	UWORD i,*p;
	UDWORD l;
	p=(UWORD *)buff;
	c=(ata_cmd->dev_hed>>4)&1;
	if (active_device != c) {	/* 現在選択されているドライブでなければ */
		active_device = (int)c;	/* デバイスセレクション */
		if (ide_ata_device_select(ata_cmd->dev_hed)!=0) return -1;	/* セレクションエラー */
	} else {	/* デバイスセレクションフェーズは行わずにDevice/Headレジスタへ書き込み */
		out_byte(ATA_DHR,ata_cmd->dev_hed);
	}
	out_byte(ATA_DCR,0x2);				/* 割り込み未使用 */
	out_byte(ATA_FTR,ata_cmd->feature);	/* フィーチャー */
	out_byte(ATA_SCR,ata_cmd->sec_cnt);	/* セクタカウント */
	out_byte(ATA_SNR,ata_cmd->sec_no);	/* セクタナンバ */
	out_byte(ATA_CLR,ata_cmd->cyl_lo);	/* シリンダLo */
	out_byte(ATA_CHR,ata_cmd->cyl_hi);	/* シリンダHi */
	if (ata_cmd->DRDY_Chk) ide_wait_drdyset();	/* DRDYビットウェイト */
	out_byte(ATA_CMR,ata_cmd->command);	/* コマンド */
	ide_ata_wait(ATA_WAIT400ns);		/* 400nsウェイト */
	for(i=0;i<count;i++) {				/* 読み出しブロック数ループ */
		for (l=0;l<ATA_TIMEOUT;l++) {	/* タイムアウトまでループ */
			c=in_byte(ATA_ASR);			/* Alternate Statusレジスタ */
			if ((c & BIT_BSY)==0) break;/* コマンド実行終了 */
		}
		if (l==ATA_TIMEOUT) return -2;	/* タイムアウトエラー */
		c=in_byte(ATA_ASR);				/* Alternate Statusレジスタ */
		if ((c & BIT_ERR)!=0) {			/* コマンド実行エラー */
			break;						/* コマンドエラー終了 */
		}
		if ((c & BIT_DRQ)==0) {			/* なぜかデータが要求されていない */
			return -3;					/* コマンド未実行エラー */
		} else {						/* データが要求されている */
			ide_ata_write_data(256,p);	/* ブロック書き込み(1セクタ256ワード) */
		}
		p=p+256;						/* データバッファポインタインクリメント */
	}
	in_byte(ATA_ASR);					/* Alternate Statusレジスタ */
	c=in_byte(ATA_STR);					/* Statusレジスタ */
	if (c & BIT_ERR) {					/* エラー終了 */
		c=in_byte(ATA_ERR);				/* 戻り値の下位8ビットをErrorレジスタの値とする */
		return 0x1000|(unsigned int)c;	/* エラー終了 != 0 */
	} else {							/* コマンド正常実行終了時 */
		return 0;						/* 正常終了 = 0 */
	}
}



/*******************/
/* ATAコマンド発行 */
/*******************/

/* DEVICE RESETコマンド
引き数     なし
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_device_reset(int device)
{
	int i;
	struct STRUCT_ATA_CMD ata_cmd;
	ata_cmd.feature=0;		/* (フィーチャー) */
	ata_cmd.sec_cnt=0;		/* (セクタカウント) */
	ata_cmd.sec_no=0;		/* (セクタナンバ) */
	ata_cmd.cyl_lo=0;		/* (シリンダLo) */
	ata_cmd.cyl_hi=0;		/* (シリンダHi) */
	ata_cmd.dev_hed=DEV_HEAD_obs|(device<<4);	/* デバイス */
	ata_cmd.command=0x08;	/* DEVICE RESETコマンド */
	ata_cmd.DRDY_Chk=0;		/* DRDYビットチェック不要 */
	i=ide_ata_non_data_cmd(&ata_cmd);
	return i;				/* 正常終了時=0 エラー終了時!=0 */
}

/* IDENTIFY DEVICE/IDENTIFY PACKET DEVICEコマンド発行
引き数
	device : デバイス選択 0 or 1
	flg    : ATA or ATAPIフラグ
	*buff  : IDENTIFY情報格納バッファポインタ
戻り値
	2      : アボートエラー
	1      : コマンドを誰も実行していない
	0      : 正常終了
	-1     : デバイスセレクションエラーorタイムアウトエラー
	-2     : アボート以外のコマンド実行エラー
*/
int IDE_identify_device(int device, int flg, UWORD *buff)
{
	int i;
#ifdef BIG_ENDIAN
	UWORD l;
#endif
	struct STRUCT_ATA_CMD ata_cmd;
	ata_cmd.feature=0;		/* (フィーチャー) */
	ata_cmd.sec_cnt=0;		/* (セクタカウント) */
	ata_cmd.sec_no=0;		/* (セクタナンバ) */
	ata_cmd.cyl_lo=0;		/* (シリンダLo) */
	ata_cmd.cyl_hi=0;		/* (シリンダHi) */
	ata_cmd.dev_hed=DEV_HEAD_obs|(device<<4);	/* デバイス */
	if (flg&DEVICE_ATA) {
		if (device_type[device]&DEVICE_UNKOWN) {
			ata_cmd.DRDY_Chk=0;	/* 接続デバイス判定のためチェック不要 */
		} else {
			ata_cmd.DRDY_Chk=1;	/* DRDYビットチェック */
		}
		ata_cmd.command=0xec;/* IDENTIFY DEVICEコマンド */
	} else {
		ata_cmd.DRDY_Chk=0;	/* DRDYビットチェック不要 */
		ata_cmd.command=0xa1;/* IDENTIFY PACKET DEVICEコマンド */
	}
	i=ide_ata_pio_datain_cmd(&ata_cmd,1,(void *)buff);	/* 1ブロック(256ワード) */
	if (i==-3) return 1;	/* コマンド未実行エラー→実際にはデバイスがいない */
	if (i>0) {				/* コマンド実行エラー */
		if ((i & BIT_ABRT)!=0) return 2;	/* アボートエラー */
		else return -2;		/* アボート以外のエラー */
	}
	if (i<0) return -1;		/* デバイスセレクションエラーorタイムアウトエラー */
#ifdef BIG_ENDIAN
	for(i=0;i<256;i++){
		l=*buff;
		*buff=((l>>8)&0xff)|((l<<8)&0xff00);	/* 上位下位反転 */
		buff++;
	}
#endif
	return 0;	/* 正常終了時=0 */
}

/* EXECUTE DEVICE DIAGNOSTICコマンド
引き数     なし
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_execute_device_diagnostic(void)
{
	int i;
	struct STRUCT_ATA_CMD ata_cmd;
	ata_cmd.feature=0;		/* (フィーチャー) */
	ata_cmd.sec_cnt=0;		/* (セクタカウント) */
	ata_cmd.sec_no=0;		/* (セクタナンバ) */
	ata_cmd.cyl_lo=0;		/* (シリンダLo) */
	ata_cmd.cyl_hi=0;		/* (シリンダHi) */
	ata_cmd.dev_hed=DEV_HEAD_obs;	/* デバイス(マスタ/スレーブ両方同時に実行) */
	ata_cmd.command=0x90;	/* EXECUTE DEVICE DIAGNOSTICコマンド */
	ata_cmd.DRDY_Chk=1;		/* DRDYビットチェック */
	i=ide_ata_non_data_cmd(&ata_cmd);
	return i;				/* 正常終了時=0 エラー終了時!=0 */
}

/* IDLE/IDLE IMMEDIATEコマンド発行
引き数
	device : デバイス選択 0 or 1
	flg    : ATA or ATAPIフラグ
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_idle_device(int device, int flg)
{
	int i;
	struct STRUCT_ATA_CMD ata_cmd;
	ata_cmd.feature=0;		/* (フィーチャー) */
	ata_cmd.sec_cnt=0;		/* (セクタカウント) */
	ata_cmd.sec_no=0;		/* (セクタナンバ) */
	ata_cmd.cyl_lo=0;		/* (シリンダLo) */
	ata_cmd.cyl_hi=0;		/* (シリンダHi) */
	ata_cmd.dev_hed=DEV_HEAD_obs|(device<<4);	/* デバイス */
	if (flg&DEVICE_ATA) {
		ata_cmd.command=0xe3;/* ATAデバイス用 IDLEコマンド */
	} else {
		ata_cmd.command=0xe1;/* ATAPIデバイス用 IDLEコマンド */
	}
	ata_cmd.DRDY_Chk=1;		/* DRDYビットチェック */
	i=ide_ata_non_data_cmd(&ata_cmd);
	return i;				/* 正常終了時=0 エラー終了時!=0 */
}

/* INITALIZE DEVICE PARAMATERSコマンド発行
引き数
	device : デバイス選択 0 or 1
	head   : ヘッド数
	sector : セクタ数
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_init_device_paramaters(int device, UBYTE head, UBYTE sector)
{
	int i;
	struct STRUCT_ATA_CMD ata_cmd;
	ata_cmd.feature=0xff;	/* (フィーチャー) */
	ata_cmd.sec_cnt=sector;	/* 最大セクタ数 */
	ata_cmd.sec_no=0;		/* (セクタナンバ) */
	ata_cmd.cyl_lo=0;		/* (シリンダLo) */
	ata_cmd.cyl_hi=0;		/* (シリンダHi) */
	ata_cmd.dev_hed=DEV_HEAD_obs|(device<<4)|(head & 0xf);	/* デバイス/ヘッド数 */
	ata_cmd.command=0x91;	/* INITALIZE DEVICE PARAMATERSコマンド */
	ata_cmd.DRDY_Chk=0;		/* DRDYビットチェック不要 */
	i=ide_ata_non_data_cmd(&ata_cmd);
	return i;				/* 正常終了時=0 エラー終了時!=0 */
}

/* SET FEATURESコマンド発行
引き数
	device : デバイス選択 0 or 1
	subcom : サブコマンド
	mode   : 転送モード値ほか
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_set_features(int device, UBYTE subcom, UBYTE mode)
{
	int i;
	struct STRUCT_ATA_CMD ata_cmd;
	ata_cmd.feature=subcom;	/* SET FEATURES sub command */
	ata_cmd.sec_cnt=mode;	/* データ転送モード値ほか */
	ata_cmd.sec_no=0;		/* (セクタナンバ) */
	ata_cmd.cyl_lo=0;		/* (シリンダLo) */
	ata_cmd.cyl_hi=0;		/* (シリンダHi) */
	ata_cmd.dev_hed=DEV_HEAD_obs|(device<<4);	/* デバイス */
	ata_cmd.command=0xef;	/* SET FEATURESコマンド */
	ata_cmd.DRDY_Chk=1;		/* DRDYビットチェック */
	i=ide_ata_non_data_cmd(&ata_cmd);
	return i;				/* 正常終了時=0 エラー終了時!=0 */
}

/* GET MEDIA STATUSコマンド発行
引き数
	device : デバイス選択 0 or 1
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_get_media_status(int device)
{
	int i;
	struct STRUCT_ATA_CMD ata_cmd;
	ata_cmd.feature=0;		/* (フィーチャー) */
	ata_cmd.sec_cnt=0;		/* (セクタカウント) */
	ata_cmd.sec_no=0;		/* (セクタナンバ) */
	ata_cmd.cyl_lo=0;		/* (シリンダLo) */
	ata_cmd.cyl_hi=0;		/* (シリンダHi) */
	ata_cmd.dev_hed=DEV_HEAD_obs|(device<<4);	/* デバイス */
	ata_cmd.command=0xda;	/* GET MEDIA STATUSコマンド */
	ata_cmd.DRDY_Chk=1;		/* DRDYビットチェック */
	i=ide_ata_non_data_cmd(&ata_cmd);
	return i;				/* 正常終了時=0 エラー終了時!=0 */
}

/* DOOR/MEDIA UNLOCKコマンド発行
引き数
	device : デバイス選択 0 or 1
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_media_unlock(int device)
{
	int i;
	struct STRUCT_ATA_CMD ata_cmd;
	ata_cmd.feature=0;		/* (フィーチャー) */
	ata_cmd.sec_cnt=0;		/* (セクタカウント) */
	ata_cmd.sec_no=0;		/* (セクタナンバ) */
	ata_cmd.cyl_lo=0;		/* (シリンダLo) */
	ata_cmd.cyl_hi=0;		/* (シリンダHi) */
	ata_cmd.dev_hed=DEV_HEAD_obs|(device<<4);	/* デバイス */
	ata_cmd.command=0xdf;	/* DOOR/MEDIA UNLOCKコマンド */
	ata_cmd.DRDY_Chk=1;		/* DRDYビットチェック */
	i=ide_ata_non_data_cmd(&ata_cmd);
	return i;				/* 正常終了時=0 エラー終了時!=0 */
}

/* DOOR/MEDIA LOCKコマンド発行
引き数
	device : デバイス選択 0 or 1
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_media_lock(int device)
{
	int i;
	struct STRUCT_ATA_CMD ata_cmd;
	ata_cmd.feature=0;		/* (フィーチャー) */
	ata_cmd.sec_cnt=0;		/* (セクタカウント) */
	ata_cmd.sec_no=0;		/* (セクタナンバ) */
	ata_cmd.cyl_lo=0;		/* (シリンダLo) */
	ata_cmd.cyl_hi=0;		/* (シリンダHi) */
	ata_cmd.dev_hed=DEV_HEAD_obs|(device<<4);	/* デバイス */
	ata_cmd.command=0xde;	/* DOOR/MEDIA LOCKコマンド */
	ata_cmd.DRDY_Chk=1;		/* DRDYビットチェック */
	i=ide_ata_non_data_cmd(&ata_cmd);
	return i;				/* 正常終了時=0 エラー終了時!=0 */
}

/* MEDIA EJECTコマンド発行
引き数
	device : デバイス選択 0 or 1
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_media_eject(int device)
{
	int i;
	struct STRUCT_ATA_CMD ata_cmd;
	ata_cmd.feature=0;		/* (フィーチャー) */
	ata_cmd.sec_cnt=0;		/* (セクタカウント) */
	ata_cmd.sec_no=0;		/* (セクタナンバ) */
	ata_cmd.cyl_lo=0;		/* (シリンダLo) */
	ata_cmd.cyl_hi=0;		/* (シリンダHi) */
	ata_cmd.dev_hed=DEV_HEAD_obs|(device<<4);	/* デバイス */
	ata_cmd.command=0xed;	/* MEDIA EJECTコマンド */
	ata_cmd.DRDY_Chk=1;		/* DRDYビットチェック */
	i=ide_ata_non_data_cmd(&ata_cmd);
	return i;				/* 正常終了時=0 エラー終了時!=0 */
}

/* セクタレジスタ設定値(セクタR/Wコマンド発行関数のサブ関数) */
UBYTE ide_get_sct_parameter(int device, UDWORD lba)
{
	int sct;
	if (chs_lba[device]) {	/* LBA方式対応デバイス */
		sct=lba&0xff;
	} else {				/* LBA方式未対応デバイス */
		sct=(lba%identify_data[device][56])+1;
	}
	return (UBYTE)sct;
}

/* シリンダレジスタ設定値(セクタR/Wコマンド発行関数のサブ関数) */
UWORD ide_get_cyli_parameter(int device, UDWORD lba)
{
	UWORD cyli;
	if (chs_lba[device]) {	/* LBA方式対応デバイス */
		cyli=(lba>>8)&0xffff;
	} else {				/* LBA方式未対応デバイス */
		cyli=lba/(identify_data[device][56]*identify_data[device][55]);
	}
	return cyli;
}

/* ヘッドレジスタ設定値(セクタR/Wコマンド発行関数のサブ関数) */
UBYTE ide_get_head_parameter(int device, UDWORD lba)
{
	int head;
	if (chs_lba[device]) {	/* LBA方式対応デバイス */
		head=LBA_flg|(device<<4)|((lba>>24)&0xf);
	} else {				/* LBA方式未対応デバイス */
		head=(device<<4)|(lba/(identify_data[device][56]))%identify_data[device][55];
	}
	return (UBYTE)head;
}

/* ATAリードセクタコマンド発行
引き数
	device : デバイス選択 0 or 1
	lba    : LBA
	count  : セクタ数
	*buff  : データバッファポインタ
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_ata_read_sector(int device, UDWORD lba, UWORD count, void *buff)
{
	int i;
	UWORD l;
	struct STRUCT_ATA_CMD ata_cmd;
	ata_cmd.feature=0;			/* (フィーチャー) */
	ata_cmd.sec_cnt=(UBYTE)count;/* セクタ数 */
	ata_cmd.sec_no=ide_get_sct_parameter(device,lba);	/* セクタナンバ */
	l=ide_get_cyli_parameter(device,lba);
	ata_cmd.cyl_lo=l&0xff;		/* シリンダLo */
	ata_cmd.cyl_hi=(l>>8)&0xff;	/* シリンダHi */
	ata_cmd.dev_hed=DEV_HEAD_obs|ide_get_head_parameter(device,lba);	/* デバイス/ヘッド */
	ata_cmd.command=0x20;		/* セクタリードコマンド */
	ata_cmd.DRDY_Chk=1;			/* DRDYビットチェック */
	i=ide_ata_pio_datain_cmd(&ata_cmd,count,buff);	/* count=セクタ(ブロック)数 */
	return i;					/* 正常終了時=0 エラー終了時!=0 */
}

/* ATAライトセクタコマンド発行
引き数
	device : デバイス選択 0 or 1
	lba    : LBA
	count  : セクタ数
	*buff  : データバッファポインタ
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_ata_write_sector(int device, UDWORD lba, UWORD count, void *buff)
{
	int i;
	UWORD l;
	struct STRUCT_ATA_CMD ata_cmd;
	ata_cmd.feature=0;			/* (フィーチャー) */
	ata_cmd.sec_cnt=(UBYTE)count;/* セクタ数 */
	ata_cmd.sec_no=ide_get_sct_parameter(device,lba);	/* セクタナンバ */
	l=ide_get_cyli_parameter(device,lba);
	ata_cmd.cyl_lo=l&0xff;		/* シリンダLo */
	ata_cmd.cyl_hi=(l>>8)&0xff;	/* シリンダHi */
	ata_cmd.dev_hed=DEV_HEAD_obs|ide_get_head_parameter(device,lba);	/* デバイス/ヘッド */
	ata_cmd.command=0x30;		/* セクタライトコマンド */
	ata_cmd.DRDY_Chk=1;			/* DRDYビットチェック */
	i=ide_ata_pio_dataout_cmd(&ata_cmd,count,buff);	/* count=セクタ(ブロック)数 */
	return i;					/* 正常終了時=0 エラー終了時!=0 */
}



/*****************************/
/* ATAPIパケットコマンド発行 */
/*****************************/

/* PACKETコマンド発行 */
int ide_atapi_packet_cmd(struct STRUCT_ATAPI_CMD *atapi_cmd, UWORD limit, void *buff)
{
	int i;
	UDWORD l;
	UBYTE c1,c2;
	/* PACKETコマンド発行 */
#ifdef USE_INTERRUPT		/* パケットコマンドの処理を割り込みを使って行う場合 */
	atapi_interrupt_buff=buff;		/* 割り込みルーチンで使用するデータバッファのポインタ */
	atapi_interrupt_state=ST_IDLE;	/* 割り込み処理ステート状態変数クリア */
	atapi_interrupt_limit=limit;	/* 割り込みルーチンで使用する最大転送バイト数 */
	out_byte(ATA_DCR,0x8);	/* 割り込み使用 */
#else
	out_byte(ATA_DCR,0xa);	/* 割り込み未使用 */
#endif
	if (active_device!=atapi_cmd->dev_sel) {/* 現在選択されているドライブでなければ */
		active_device=atapi_cmd->dev_sel;	/* デバイスセレクション */
		if (ide_ata_device_select(DEV_HEAD_obs|(atapi_cmd->dev_sel<<4))!=0) return -1;	/* セレクションエラー */
	} else {	/* デバイスセレクションフェーズは行わずにDevice/Headレジスタへ書き込み */
		out_byte(ATA_DHR,DEV_HEAD_obs|(atapi_cmd->dev_sel<<4));
	}
	out_byte(ATA_FTR,atapi_cmd->feature);	/* overlap/DMAの設定 */
	out_byte(ATA_SCR,0);					/* TAG未使用 */
	out_byte(ATA_BLR,(UBYTE)(limit&0xff));	/* バイトカウント low  */
	out_byte(ATA_BHR,(UBYTE)(limit>>8));	/* バイトカウント high */
	out_byte(ATA_CMR,0xa0);					/* PACKETコマンド */
	ide_ata_wait(ATA_WAIT400ns);			/* 400nsウェイト */

	/* デバイスのコマンドパケット受信開始待ち */
	i=0;
	for (l=0;l<ATA_TIMEOUT;l++) {			/* タイムアウトまでループ */
		c1=in_byte(ATA_ASR);				/* Alternate Statusレジスタ */
		if ((c1 & BIT_BSY)==0) {			/* コマンド実行終了 */
			if ((c1 & BIT_CHK)!=0) {		/* Statusレジスタ CHK=1 */
				i=-1;						/* PACKETコマンド実行エラー */
				break;
			}
			c2=in_byte(ATA_IRR);			/* Interrup Reasonレジスタ */
			if (((c1 & BIT_DRQ)!=0)&&		/* Statusレジスタ DRQ=1 */
				((c2 & BIT_IO )==0)&&		/* Interrup Reasonレジスタ I/O=0 */
				((c2 & BIT_CD )!=0)) break;	/* Interrup Reasonレジスタ C/D=1 */
		}
	}
	if (i<0) {
#ifdef USE_INTERRUPT
		/* 意図しないタイミングで割り込みが発生してもDataレジスタを空読みするために */
		atapi_interrupt_buff=NULL;
#endif
		return -2;		/* PACKETコマンド発行エラー */
	}
	if (l==ATA_TIMEOUT) {
#ifdef USE_INTERRUPT
		/* 意図しないタイミングで割り込みが発生してもDataレジスタを空読みするために */
		atapi_interrupt_buff=NULL;
#endif
		return -3;		/* タイムアウトエラー */
	}
	/* コマンドパケット送信 */
	ide_ata_write_data(6,&atapi_cmd->cmd_packet);	/* 6ワード書き込み */

	/* パケットコマンド実行終了待ち */
	i=0;
	for (l=0;l<ATA_TIMEOUT;l++) {	/* タイムアウトまでループ */
#ifdef USE_INTERRUPT
		c1=in_byte(ATA_ASR);		/* ステータスリード */
#else
		c1=in_byte(ATA_STR);		/* ステータスリード & 割り込み要求クリア */
#endif
		c2=in_byte(ATA_IRR);		/* 割り込み要因リード */
		if ((c1 & BIT_BSY)==0) {	/* コマンド実行中 */
			if ((c1 & BIT_CHK)!=0) {/* Statusレジスタ CHK=1 */
				l=0;				/* タイムアウトエラーフラグクリア */
				i=-1;				/* パケットコマンド実行エラー */
				break;
			}
#ifdef USE_INTERRUPT
	/* 割り込みを使う場合は、割り込み処理ステートでパケットコマンド実行終了を判定 */
			if (atapi_interrupt_state==ST_STATUS) {	/* 割り込み処理ステート 処理完了 */
				l=0;	/* タイムアウトエラーフラグクリア */
				break;
			}
#else
	/* 割り込みを使わない場合は、StatusレジスタとInterrup Reasonレジスタの各ビットを判定 */
			if ( ((c2 & BIT_IO)!=0)&&((c2 & BIT_CD)==0)&&((c1 & BIT_DRQ)!=0) ) {
				/* デバイス→ホストデータ転送 */
				atapi_datatransfer=(in_byte(ATA_BHR)<<8)|in_byte(ATA_BLR);	/* 読み出しバイト数 */
				if (atapi_datatransfer>limit) {	/* 転送予定バイト数より転送バイト数が多い場合 */
					ide_ata_read_data((limit+1)/2,(void *)buff);	/* Dataレジスタ読み出し(奇数バイトの場合に最後まで読み出すため+1) */
					ide_ata_read_data(((atapi_datatransfer-limit)+1)/2,(void *)NULL);	/* 残ったデータは空読み */
				} else {
					ide_ata_read_data((atapi_datatransfer+1)/2,(void *)buff);	/* Dataレジスタ読み出し */
				}
			}
			if ( ((c2 & BIT_IO)==0)&&((c2 & BIT_CD)==0)&&((c1 & BIT_DRQ)!=0) ) {
				/* ホスト→デバイスデータ転送 */
				atapi_datatransfer=(in_byte(ATA_BHR)<<8)|in_byte(ATA_BLR);	/* 書き込みバイト数 */
				if (atapi_datatransfer>limit) {	/* 転送予定バイト数より転送バイト数が多い場合 */
					ide_ata_write_data((limit+1)/2,(void *)buff);	/* Dataレジスタ書き込み */
					ide_ata_write_data(((atapi_datatransfer-limit)+1)/2,(void *)NULL);
					/* ↑足りないデータは、とりあえず仕方ないので00hで埋める… */
				} else {
					ide_ata_write_data((atapi_datatransfer+1)/2,(void *)buff);/* Dataレジスタ書き込み */
				}
			}
			if ( ((c2 & BIT_IO)!=0)&&((c2 & BIT_CD)!=0)&&((c1 & BIT_DRQ)==0) ) {
				/* パケットコマンド実行終了 */
				l=0;	/* タイムアウトエラーフラグクリア */
				break;
			}
#endif
		}
	}
	in_byte(ATA_STR);			/* Statusレジスタ空読み */
#ifdef USE_INTERRUPT
	atapi_interrupt_buff=NULL;	/* 割り込みルーチンで使用するデータバッファのポインタをクリア */
#endif
	if (l==ATA_TIMEOUT) return -4;	/* タイムアウトエラー */
	if (i<0) {
		c1=in_byte(ATA_ERR);	/* 戻り値の下位8ビットをErrorレジスタの値とする */
		return 0x1000|(unsigned int)c1;	/* エラー終了 != 0 */
	}
	return 0;					/* パケットコマンド実行完了 */
}

#ifdef USE_INTERRUPT
/* ATAPI パケットコマンド実行(割り込み処理関数) */
void IDE_atapi_packet_interrupt(void)
{
	UBYTE c1,c2;
	c1=in_byte(ATA_STR);	/* ステータスリード&割り込み要求クリア */
	c2=in_byte(ATA_IRR);	/* 割り込み要因リード */
	if ( ((c2 & BIT_IO)==0)&&((c2 & BIT_CD)!=0)&&((c1 & BIT_DRQ)!=0) ) {
		/* コマンドパケット受信待機状態 */
		atapi_interrupt_state=ST_COMMAND;
		/* パケットコマンドは非割り込みルーチン内でポーリングにより転送 */
	}
	if ( ((c2 & BIT_IO)!=0)&&((c2 & BIT_CD)==0)&&((c1 & BIT_DRQ)!=0) ) {
		/* デバイス→ホストデータ転送 */
		atapi_interrupt_state=ST_DATATOHOST;
		atapi_datatransfer=(in_byte(ATA_BHR)<<8)|in_byte(ATA_BLR);	/* 読み出しバイト数 */
		if (atapi_datatransfer>atapi_interrupt_limit) {	/* 転送予定バイト数より転送バイト数が多い場合 */
			ide_ata_read_data((atapi_interrupt_limit+1)/2,(void *)atapi_interrupt_buff);	/* Dataレジスタ読み出し(奇数バイトの場合に最後まで読み出すため+1) */
			ide_ata_read_data(((atapi_datatransfer-atapi_interrupt_limit)+1)/2,(void *)NULL);	/* 残ったデータは空読み */
		} else {
			ide_ata_read_data((atapi_datatransfer+1)/2,(void *)atapi_interrupt_buff);	/* Dataレジスタ読み出し */
		}
	}
	if ( ((c2 & BIT_IO)==0)&&((c2 & BIT_CD)==0)&&((c1 & BIT_DRQ)!=0) ) {
		/* ホスト→デバイスデータ転送 */
		atapi_interrupt_state=ST_DATAFROMHOST;
		atapi_datatransfer=(in_byte(ATA_BHR)<<8)|in_byte(ATA_BLR);	/* 書き込みバイト数 */
		if (atapi_datatransfer>atapi_interrupt_limit) {	/* 転送予定バイト数より転送バイト数が多い場合 */
			ide_ata_write_data((atapi_interrupt_limit+1)/2,(void *)atapi_interrupt_buff);	/* Dataレジスタ書き込み */
			ide_ata_write_data(((atapi_datatransfer-atapi_interrupt_limit)+1)/2,(void *)NULL);
			/* ↑足りないデータは、とりあえず仕方ないので00hで埋める… */
		} else {
			ide_ata_write_data((atapi_datatransfer+1)/2,(void *)atapi_interrupt_buff);/* Dataレジスタ書き込み */
		}
	}
	if ( ((c2 & BIT_IO)==0)&&((c2 & BIT_CD)==0)&&((c1 & BIT_DRQ)==0) ) {
		/* バスリリース */
		atapi_interrupt_state=ST_RELEASE;
		/* オーバーラップコマンド未使用 */
	}
	if ( ((c2 & BIT_IO)!=0)&&((c2 & BIT_CD)!=0)&&((c1 & BIT_DRQ)!=0) ) {
		/* Message(将来拡張用) - Ready to Send Message data to Host */
		atapi_interrupt_state=ST_MESSAGE;
		atapi_datatransfer=in_byte(ATA_BHR)<<8|in_byte(ATA_BLR);/* 読み出しバイト数 */
		ide_ata_read_data((atapi_datatransfer+1)/2,NULL);		/* Dataレジスタ空読み */
	}
	if ( ((c2 & BIT_IO)!=0)&&((c2 & BIT_CD)!=0)&&((c1 & BIT_DRQ)==0) ) {
		/* コマンド実行終了 */
		atapi_interrupt_state=ST_STATUS;
	}
}
#endif

/* TEST UNITコマンドパケット発行
引き数
	device : デバイス選択 0 or 1
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_atapi_test_unit(int device)
{
	int i;
	struct STRUCT_ATAPI_CMD atapi_cmd;
	atapi_cmd.feature=0;			/* Non-overlap/non DMA */
	atapi_cmd.dev_sel=device;		/* デバイス */
	for(i=0;i<12;i++){
		atapi_cmd.cmd_packet[i]=0;	/* パケットコマンドバッファクリア */
	}
	i=ide_atapi_packet_cmd(&atapi_cmd,0,NULL);
	return i;						/* 正常終了時=0 エラー終了時!=0 */
}

/* REQUEST SENSEパケットコマンド発行
引き数
	device : デバイス選択 0 or 1
	*buff  : データ格納バッファポインタ
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_atapi_request_sense(int device, void *buff)
{
	int i;
	struct STRUCT_ATAPI_CMD atapi_cmd;
	atapi_cmd.feature=0;			/* Non-overlap/non DMA */
	atapi_cmd.dev_sel=device;		/* デバイス */
	for(i=0;i<12;i++){
		atapi_cmd.cmd_packet[i]=0;	/* パケットコマンドバッファクリア */
	}
	atapi_cmd.cmd_packet[0]=3;		/* REQUEST SENSE */
	atapi_cmd.cmd_packet[4]=18;		/* 18バイト */
	atapi_datatransfer=0;			/* 転送データバイト数クリア */
	i=ide_atapi_packet_cmd(&atapi_cmd,18,buff);
	if ((i==0)&&(atapi_datatransfer==18)) return 0;	/* 正常終了時=0 */
	return i;						/* エラー終了時!=0 */
}

/* START/STOP UNIT(START)パケットコマンド発行
引き数
	device : デバイス選択 0 or 1
	data   : スタート/イジェクト/トレイクローズ
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_atapi_start_unit(int device, UBYTE data)
{
	int i;
	struct STRUCT_ATAPI_CMD atapi_cmd;
	atapi_cmd.feature=0;			/* Non-overlap/non DMA */
	atapi_cmd.dev_sel=device;		/* デバイス */
	for(i=0;i<12;i++){
		atapi_cmd.cmd_packet[i]=0;	/* パケットコマンドバッファクリア */
	}
	atapi_cmd.cmd_packet[0]=0x1b;	/* START UNIT */
	atapi_cmd.cmd_packet[4]=data;	/* 設定値 */
	i=ide_atapi_packet_cmd(&atapi_cmd,0,NULL);
	return i;						/* 正常終了時=0 エラー終了時!=0 */
}

/* READ CAPACITYパケットコマンド発行
引き数
	device : デバイス選択 0 or 1
	*buff  : データ格納バッファポインタ
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_atapi_read_capacity(int device, void *buff)
{
	int i;
	struct STRUCT_ATAPI_CMD atapi_cmd;
	atapi_cmd.feature=0;			/* Non-overlap/non DMA */
	atapi_cmd.dev_sel=device;		/* デバイス */
	for(i=0;i<12;i++){
		atapi_cmd.cmd_packet[i]=0;	/* パケットコマンドバッファクリア */
	}
	atapi_cmd.cmd_packet[0]=0x25;	/* READ CAPACITY */
	atapi_datatransfer=0;			/* 転送データバイト数クリア */
	i=ide_atapi_packet_cmd(&atapi_cmd,8,buff);
	if ((i==0)&&(atapi_datatransfer==8)) return 0;	/* 正常終了時=0 */
	return i;						/* エラー終了時!=0 */
}

/* INQUIRYパケットコマンド発行
引き数
	device : デバイス選択 0 or 1
	len    : 取得データバイト数
	*buff  : データ格納バッファポインタ
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_atapi_inquiry(int device, UBYTE len, void *buff)
{
	int i;
	struct STRUCT_ATAPI_CMD atapi_cmd;
	atapi_cmd.feature=0;			/* Non-overlap/non DMA */
	atapi_cmd.dev_sel=device;		/* デバイス */
	for(i=0;i<12;i++){
		atapi_cmd.cmd_packet[i]=0;	/* パケットコマンドバッファクリア */
	}
	atapi_cmd.cmd_packet[0]=0x12;	/* INQUIRY */
	atapi_cmd.cmd_packet[4]=len;	/* 転送バイト長 */
	atapi_datatransfer=0;			/* 転送データバイト数クリア */
	i=ide_atapi_packet_cmd(&atapi_cmd,len,buff);
	if ((i==0)&&(atapi_datatransfer==len)) return 0;	/* 正常終了時=0 */
	return i;						/* エラー終了時!=0 */
}

/* READ(10)パケットコマンド発行
引き数
	device : デバイス選択 0 or 1
	lba    : LBA
	count  : セクタ数
	*buff  : データ格納バッファポインタ
戻り値
	-100   : 転送バイト数がセクタサイズと異なる
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_atapi_read10(int device, UDWORD lba, UWORD count, void *buff)
{
	int i;
	struct STRUCT_ATAPI_CMD atapi_cmd;
	atapi_cmd.feature=0;			/* Non-overlap/non DMA */
	atapi_cmd.dev_sel=device;		/* デバイス */
	for(i=0;i<12;i++){
		atapi_cmd.cmd_packet[i]=0;	/* パケットコマンドバッファクリア */
	}
	atapi_cmd.cmd_packet[0]=0x28;	/* READ(10) */
	atapi_cmd.cmd_packet[2]=(lba>>24)&0xff;	/* 論理セクタ */
	atapi_cmd.cmd_packet[3]=(lba>>16)&0xff;
	atapi_cmd.cmd_packet[4]=(lba>>8)&0xff;
	atapi_cmd.cmd_packet[5]=lba&0xff;
	atapi_cmd.cmd_packet[7]=(count>>8)&0xff;/* 読み出しセクタ数 */
	atapi_cmd.cmd_packet[8]=count&0xff;
	atapi_datatransfer=0;			/* 転送データバイト数クリア */
	i=ide_atapi_packet_cmd(&atapi_cmd,device_secter_size[device],buff);
	if (i==0) {	/* パケットコマンドの実行自体は正常終了 */
		if (atapi_datatransfer<=device_secter_size[device]) return 0;	/* 正常終了時=0 */
		/* ↑CD-ROMのセクタサイズを"2352バイト"と返すドライブがあるため、少ない分についてはNo Errorとする */
		else return -100;	/* 実際に転送したバイト数がセクタサイズより大きい場合 */
	} else {	/* パケットコマンドの実行前/中/後にエラー */
		return i;	/* エラー終了時!=0*/
	}
}

/* WRITE(10)パケットコマンド発行
引き数
	device : デバイス選択 0 or 1
	lba    : LBA
	count  : セクタ数
	*buff  : データ格納バッファポインタ
戻り値
	-100   : 転送バイト数がセクタサイズと異なる
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_atapi_write10(int device, UDWORD lba, UWORD count, void *buff)
{
	int i;
	struct STRUCT_ATAPI_CMD atapi_cmd;
	atapi_cmd.feature=0;			/* Non-overlap/non DMA */
	atapi_cmd.dev_sel=device;		/* デバイス */
	for(i=0;i<12;i++){
		atapi_cmd.cmd_packet[i]=0;	/* パケットコマンドバッファクリア */
	}
	atapi_cmd.cmd_packet[0]=0x2a;	/* WRITE(10) */
	atapi_cmd.cmd_packet[2]=(lba>>24)&0xff;	/* 論理セクタ */
	atapi_cmd.cmd_packet[3]=(lba>>16)&0xff;
	atapi_cmd.cmd_packet[4]=(lba>>8)&0xff;
	atapi_cmd.cmd_packet[5]=lba&0xff;
	atapi_cmd.cmd_packet[7]=(count>>8)&0xff;/* 書き込みセクタ数 */
	atapi_cmd.cmd_packet[8]=count&0xff;
	atapi_datatransfer=0;			/* 転送データバイト数クリア */
	i=ide_atapi_packet_cmd(&atapi_cmd,device_secter_size[device],buff);
	if (i==0) {	/* パケットコマンドの実行自体は正常終了 */
		if (atapi_datatransfer<=device_secter_size[device]) return 0;	/* 正常終了時=0 */
		/* ↑CD-ROMのセクタサイズを"2352バイト"と返すドライブがあるため、少ない分についてはNo Errorとする */
		else return -100;	/* 実際に転送したバイト数がセクタサイズより大きい場合 */
	} else {	/* パケットコマンドの実行前/中/後にエラー */
		return i;	/* エラー終了時!=0*/
	}
}

/* PREVENT ALLOW MEDIAUM REMOVALパケットコマンド発行
引き数
	device : デバイス選択 0 or 1
	lock   : ロック(MEDIA_Lock)/アンロック(MEDIA_UnLock)
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_prevent_allow_mediaum_removal(int device, int lock)
{
	int i;
	struct STRUCT_ATAPI_CMD atapi_cmd;
	atapi_cmd.feature=0;			/* Non-overlap/non DMA */
	atapi_cmd.dev_sel=device;		/* デバイス */
	for(i=0;i<12;i++){
		atapi_cmd.cmd_packet[i]=0;	/* パケットコマンドバッファクリア */
	}
	atapi_cmd.cmd_packet[0]=0x1e;	/* PREVENT ALLOW MEDIAUM REMOVAL */
	atapi_cmd.cmd_packet[4]=lock&1;	/* ロック/アンロック */
	i=ide_atapi_packet_cmd(&atapi_cmd,0,NULL);
	return i;						/* 正常終了時=0 エラー終了時!=0 */
}

/* READ TOCパケットコマンド発行
引き数
	device : デバイス選択 0 or 1
	lba_msf: LBA or MSF選択
	format : フォーマット選択
	setion : トラック/セクション
	len    : 取得データバイト数
	*buff  : データ格納バッファポインタ
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_atapi_read_toc(int device, int lba_msf, UBYTE format, UBYTE setion, UWORD len, void *buff)
{
	int i;
	struct STRUCT_ATAPI_CMD atapi_cmd;
	atapi_cmd.feature=0;			/* Non-overlap/non DMA */
	atapi_cmd.dev_sel=device;		/* デバイス */
	for(i=0;i<12;i++){
		atapi_cmd.cmd_packet[i]=0;	/* パケットコマンドバッファクリア */
	}
	atapi_cmd.cmd_packet[0]=0x43;	/* READ TOC */
	atapi_cmd.cmd_packet[1]=(lba_msf&1)<<1;/* select LBA/MSF */
	atapi_cmd.cmd_packet[2]=format&7;/* format */
	atapi_cmd.cmd_packet[6]=setion;	/* track/setion */
	atapi_cmd.cmd_packet[7]=(len>>8)&0xff;	/* 読み出しバイト数 */
	atapi_cmd.cmd_packet[8]=len&0xff;
	atapi_datatransfer=0;			/* 転送データバイト数クリア */
	i=ide_atapi_packet_cmd(&atapi_cmd,len,buff);
	if ((i==0)&&(atapi_datatransfer==len)) return 0;	/* 正常終了時=0 */
	return i;						/* エラー終了時!=0 */
}

/* PLAY AUDIO MSFパケットコマンド発行
引き数
	device : デバイス選択 0 or 1
	s_mm   : 開始位置[分]
	s_ss   : 開始位置[秒]
	s_ff   : 開始位置[フレーム]
	e_mm   : 終了位置[分]
	e_ss   : 終了位置[秒]
	e_ff   : 終了位置[フレーム]
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_atapi_play_audio_msf(int device, UBYTE s_mm, UBYTE s_ss, UBYTE s_ff, UBYTE e_mm, UBYTE e_ss, UBYTE e_ff)
{
	int i;
	struct STRUCT_ATAPI_CMD atapi_cmd;
	atapi_cmd.feature=0;			/* Non-overlap/non DMA */
	atapi_cmd.dev_sel=device;		/* デバイス */
	atapi_cmd.cmd_packet[0]=0x47;	/* PLAY AUDIO MSF */
	atapi_cmd.cmd_packet[1]=0;		/* reserved */;
	atapi_cmd.cmd_packet[2]=0;		/* reserved */
	atapi_cmd.cmd_packet[3]=s_mm;	/* 開始[分] */
	atapi_cmd.cmd_packet[4]=s_ss;	/* 開始[秒] */
	atapi_cmd.cmd_packet[5]=s_ff;	/* 開始[フレーム] */
	atapi_cmd.cmd_packet[6]=e_mm;	/* 終了[分] */
	atapi_cmd.cmd_packet[7]=e_ss;	/* 終了[秒] */
	atapi_cmd.cmd_packet[8]=e_ff;	/* 終了[フレーム] */
	atapi_cmd.cmd_packet[9]=0;
	atapi_cmd.cmd_packet[10]=0;		/* reserved */
	atapi_cmd.cmd_packet[11]=0;
	i=ide_atapi_packet_cmd(&atapi_cmd,0,NULL);
	return i;						/* 正常終了時=0 エラー終了時!=0 */
}

/* STOP PLAYBACKパケットコマンド発行
引き数
	device : デバイス選択 0 or 1
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_atapi_stop_playback(int device)
{
	int i;
	struct STRUCT_ATAPI_CMD atapi_cmd;
	atapi_cmd.feature=0;			/* Non-overlap/non DMA */
	atapi_cmd.dev_sel=device;		/* デバイス */
	for(i=0;i<12;i++){
		atapi_cmd.cmd_packet[i]=0;	/* パケットコマンドバッファクリア */
	}
	atapi_cmd.cmd_packet[0]=0x4e;	/* STOP PLAY */
	i=ide_atapi_packet_cmd(&atapi_cmd,0,NULL);
	return i;						/* 正常終了時=0 エラー終了時!=0 */
}

/* PAUSE/RESUMEパケットコマンド発行
引き数
	device : デバイス選択 0 or 1
	pause  : 一時停止/復帰
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_atapi_pause_resume(int device, int pause)
{
	int i;
	struct STRUCT_ATAPI_CMD atapi_cmd;
	atapi_cmd.feature=0;			/* Non-overlap/non DMA */
	atapi_cmd.dev_sel=device;		/* デバイス */
	for(i=0;i<12;i++){
		atapi_cmd.cmd_packet[i]=0;	/* パケットコマンドバッファクリア */
	}
	atapi_cmd.cmd_packet[0]=0x4b;	/* PAUSE or RESUME */
	atapi_cmd.cmd_packet[8]=pause&1;/* 0:一時停止 / 1:復帰 */
	i=ide_atapi_packet_cmd(&atapi_cmd,0,NULL);
	return i;						/* 正常終了時=0 エラー終了時!=0 */
}

/* READ SUBCHANNLパケットコマンド発行
引き数
	device : デバイス選択 0 or 1
	lba_msf: LBA or MSF選択
	subq   : Sub-Q選択
	subqfo : Sub-Qフォーマット選択
	track  : トラック番号
	len    : 取得データバイト数
	*buff  : データ格納バッファポインタ
戻り値
	0>     : コマンド実行前/中エラー
	0      : 正常終了
	0<     : コマンド実行後エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_atapi_read_subchannel(int device, int lba_msf, int subq, UBYTE subqfo, UBYTE track, UWORD len, void *buff)
{
	int i;
	struct STRUCT_ATAPI_CMD atapi_cmd;
	atapi_cmd.feature=0;			/* Non-overlap/non DMA */
	atapi_cmd.dev_sel=device;		/* デバイス */
	for(i=0;i<12;i++){
		atapi_cmd.cmd_packet[i]=0;	/* パケットコマンドバッファクリア */
	}
	atapi_cmd.cmd_packet[0]=0x42;	/* READ SUB-CHANNEL */
	atapi_cmd.cmd_packet[1]=(lba_msf&1)<<1;	/* select LBA/MSF */
	atapi_cmd.cmd_packet[2]=(subq&1)<<6;	/* SubQ */
	atapi_cmd.cmd_packet[3]=subqfo;	/* SubQ データフォーマット */
	atapi_cmd.cmd_packet[4]=0;		/* reserved */
	atapi_cmd.cmd_packet[5]=0;		/* reserved */
	atapi_cmd.cmd_packet[6]=track;	/* トラック番号 */
	atapi_cmd.cmd_packet[7]=(len>>8)&0xff;	/* 読み出しバイト数 */
	atapi_cmd.cmd_packet[8]=len&0xff;
	atapi_datatransfer=0;			/* 転送データバイト数クリア */
	i=ide_atapi_packet_cmd(&atapi_cmd,len,buff);
	if ((i==0)&&(atapi_datatransfer==len)) return 0;	/* 正常終了時=0 */
	return i;						/* エラー終了時!=0 */
}



/************************************/
/* ATA/ATAPI デバイス初期化ルーチン */
/************************************/

/* ATAデバイス接続確認サブ関数 */
int ide_initialize_device_check_sub(int device, UBYTE s1, UBYTE s2)
{
	int i,l,k,flg;
	if ((s1==0)&&(s2==0)) {		/* デバイスnはATAデバイスの可能性あり */
		flg=DEVICE_ATA;
	} else if ((s1==0x14)&&(s2==0xEB)) {/* デバイスnはATAPIデバイスの可能性あり */
		flg=DEVICE_ATAPI;
	} else {
		device_type[device]=DEVICE_NON;	/* デバイスnは未接続 */
		return -1;
	}
	i=ide_wait_bsyclr();		/* BSYビットクリア待ち */
	if (i==0) {					/* タイムアウト以内にBSYビットクリア */
		for(l=0;l<RETRY_MAX;l++){
			ide_ata_wait(ATA_WAIT5ms);	/* 5msウェイト */
			i=IDE_identify_device(device,flg,&identify_data[device][0]);
			ide_ata_wait(ATA_WAIT5ms);	/* 5msウェイト */
			k=IDE_identify_device(device,flg,&identify_data[device][0]);
			if (k==i) {	/* 2回実行して同じ結果 */
				if (i==0) {				/* エラーなし&IDENTIFYデータ正常取得 */
					device_type[device]=flg;		/* デバイスnの判定確定 */
					break;
				} else if (i==1) {		/* コマンド未実行終了 */
					device_type[device]=DEVICE_NON;	/* デバイスnは未接続 */
					break;
				} else if (i==2) {		/* アボートエラー */
					device_type[device]=DEVICE_NON;	/* デバイスnは未接続 */
					break;
				}	/* その他のエラーはリトライ */
			}
			ide_ata_wait(ATA_WAIT5ms);	/* 5msウェイト */
		}
		if (l==RETRY_MAX) {
			device_type[device]=DEVICE_UNKOWN;	/* デバイスnは不明デバイス */
		}
		return 0;	/* デバイスタイプ判定終了 */
	} else {		/* BSYビットがクリアされない */
		device_type[device]=DEVICE_UNKOWN;	/* デバイスnは不明デバイス */
		return -1;
	}
}

/* ATAデバイス接続確認 */
void ide_initialize_device_check(void)
{
	int i,l;
	UBYTE c0,c1,c2,c3,c4;

	ide_ata_reset();	/* ソフトウェアリセット実行 */
	device_type[DEVICE0]=DEVICE_UNKOWN;
	device_type[DEVICE1]=DEVICE_UNKOWN;

	/* デバイス0シグネチャ取得 */
	for(l=0;l<RETRY_MAX;l++){
		c1=c2=0xff;					/* デバイス未接続フラグ */
		out_byte(ATA_DHR,DEVICE0<<4);/* デバイス0セレクト */
		ide_ata_wait(ATA_WAIT400ns);
		c0=in_byte(ATA_STR);		/* 即効でリードバック */
		if (c0==0xff) break;		/* 未接続と判定 */
		c0=in_byte(ATA_STR);		/* 再度読み出し */
		if (c0==0xff) break;		/* 未接続と判定 */
		i=ide_wait_bsyclr();		/* BSYビットクリア待ち */
		if (i==-1) break;			/* デバイス未接続と判定 */
		c0=in_byte(ATA_ERR);		/* Errorレジスタチェック */
		if ((c0&0x7f)!=1) break;	/* デバイス0不良 */
		c0=in_byte(ATA_DHR);
		if ((c0&0x10)==0) {			/* デバイス0選択確認 */
			c1=in_byte(ATA_CLR);	/* シリンダLow */
			c2=in_byte(ATA_CHR);	/* シリンダHi */
			break;
		}
	}

	/* デバイス1シグネチャ取得 */
	for(l=0;l<RETRY_MAX;l++){
		c3=c4=0xff;					/* デバイス未接続フラグ */
		out_byte(ATA_DHR,DEVICE1<<4);/* デバイス1セレクト */
		ide_ata_wait(ATA_WAIT400ns);
		c0=in_byte(ATA_STR);		/* 即効でリードバック */
		if (c0==0xff) break;		/* 未接続と判定 */
		c0=in_byte(ATA_STR);		/* 再度読み出し */
		if (c0==0xff) break;		/* 未接続と判定 */
		i=ide_wait_bsyclr();		/* BSYビットクリア待ち */
		if (i==-1) break;			/* デバイス未接続と判定 */
		c0=in_byte(ATA_ERR);		/* Errorレジスタチェック */
		if ((c0&0x7f)!=1) break;	/* デバイス1不良 */
		c0=in_byte(ATA_DHR);
		if ((c0&0x10)==0x10) {		/* デバイス1選択確認 */
			c3=in_byte(ATA_CLR);	/* シリンダLow */
			c4=in_byte(ATA_CHR);	/* シリンダHi */
			break;
		}
	}

	/* デバイス0接続チェック */
	out_byte(ATA_DHR,DEVICE0<<4);	/* デバイス0選択 */
	ide_ata_wait(ATA_WAIT400ns);
	active_device=DEVICE0;			/* 現在のドライブはデバイス0 */
	ide_initialize_device_check_sub(DEVICE0,c1,c2);

	/* デバイス1接続チェック */
	out_byte(ATA_DHR,DEVICE1<<4);	/* デバイス1選択 */
	ide_ata_wait(ATA_WAIT400ns);
	active_device=DEVICE1;			/* 現在のドライブはデバイス1 */
	ide_initialize_device_check_sub(DEVICE1,c3,c4);

	/* デバイス0にATAまたはATAPIデバイスが接続されている */
	if ((device_type[DEVICE0]&DEVICE_ATA)||(device_type[DEVICE0]&DEVICE_ATAPI)) {
		active_device=DEVICE0;	/* デバイス0と1の両方に接続されている場合はデフォルトをデバイス0 */
	/* デバイス1にATAまたはATAPIデバイスが接続されている */
	} else if ((device_type[DEVICE1]&DEVICE_ATA)||(device_type[DEVICE1]&DEVICE_ATAPI)) {
		active_device=DEVICE1;
	} else {	/* どちらも未接続ならドライブ0にしておく */
		active_device=DEVICE0;
	}

	/* デフォルトのドライブ選択 */
	out_byte(ATA_DHR,active_device<<4);
	ide_ata_wait(ATA_WAIT400ns);
	ide_wait_bsyclr();	/* BSYビットクリア待ち(エラーがあってもとりあえず無視) */

	/* デバイス接続チェックのため存在しないドライブに対してIDENTIFY DEVICEコマンドを発行すると */
	/* デバイス選択を戻したときにコマンドが実行されている!?デバイスがあったため */
	c0=in_byte(ATA_ASR);	/* DRQビットが立っていたらとりあえずデバイスリセット */
	if (c0&BIT_DRQ) IDE_device_reset(active_device);	/* エラーがあってもとりあえず無視 */
}

/* ATAデバイスモード初期化サブ関数1 */
int ide_initialize_device_mode_sub1(int device, int pio_mode, int dma_mode)
{
	int i;
	UBYTE c;
	/* デバイスnモード初期化 */
	if ((device_type[device]&DEVICE_ATA)||(device_type[device]&DEVICE_ATAPI)) {
		i=ide_ata_device_select(device<<4);
		if (i!=0) return -1;	/* デバイスn選択エラー */
		if (device_type[device]&DEVICE_ATA) {
			i=IDE_init_device_paramaters(device,identify_data[device][3]-1,identify_data[device][6]);
			if (i!=0) return -2;	/* INITALIZE DEVICE PARAMATERSコマンドエラー */
			i=IDE_idle_device(device,DEVICE_ATA);	/* IDLEコマンド */
			if (i!=0) return -3;
		}
		if (device_type[device]&DEVICE_ATAPI) {
			/* ATAPIなら IDLE IMMEDIATEコマンドサポートが必須になっているはずだが */
			if (identify_data[device][82]&8) {	/* Power Management feature setサポート */
				i=IDE_idle_device(device,DEVICE_ATAPI);
				if (i!=0) return -4;
			}
		}
		/* PIO転送モード設定 */
		if (identify_data[device][49]&0x800) {	/* IORDYサポート */
			i=IDE_set_features(device,SET_TRANSFER,0x08|(pio_mode&7));	/* PIOフローコントロールモード&PIO転送モードを設定 */
			if (i!=0) {	/* フローコントロール付きPIOモード 設定エラー */
				IDE_set_features(device,SET_TRANSFER,0);	/* PIOデフォルト転送モード(エラー無視) */
				PIO_mode=0;	/* PIO転送モードリセット */
			}
		} else {	/* PIOフローコントロール未サポート */
			IDE_set_features(device,SET_TRANSFER,0);	/* PIOデフォルト転送モード(エラー無視) */
			PIO_mode=0;	/* PIO転送モードリセット */
		}
		/* DMA転送モード設定 */
		if (dma_mode > 0) {	/* DMA転送対応 */
			i=IDE_set_features(device,SET_TRANSFER,0x20|(dma_mode&7));	/* マルチワードDMA転送 */
			if (i!=0) {	/* マルチワードDMA転送設定エラー */
				DMA_mode=-1;	/* DMA転送モード未使用 */
			}
		}
		/* Removable Media Status Notification サポートチェック */
		if ( ((identify_data[device][83]&0x10)==0x10) ||
			 ((identify_data[device][127]&3)==1) ) {
			i=IDE_set_features(device,ENA_MEDIASTATUS,0);	/* Enable Media Status Notification */
			if (i==0) {	/* コマンド正常終了 */
				c=in_byte(ATA_CHR);	/* シリンダHi */
				if (c&2) device_type[device]=device_type[device]|DEVICE_LOCK;	/* ロック/アンロック機能あり */
				if (c&4) device_type[device]=device_type[device]|DEVICE_PEJECT;	/* パワーイジェクト機能あり */
			}
		}
	}
	return 0;
}

/* ATAデバイスモード初期化サブ関数2 */
int ide_initialize_device_mode_sub2(int device)
{
	int i;
	/* デバイスタイプ確認 & IDENTIFYコマンド再実行 */
	if (device_type[device]&DEVICE_ATA) {	/* ATAデバイス */
		if ((identify_data[device][61]|identify_data[device][60])==0) {
			chs_lba[device]=0;	/* CHS方式対応 */
		} else {
			chs_lba[device]=1;	/* LBA方式対応 */
		}
		if (identify_data[device][0]&0x40) {	/*  非リムーバブルデバイス */
			device_type[device]=device_type[device]|DEVICE_HDD;
		}
		if (identify_data[device][0]&0x80) {	/*  リムーバブルデバイス */
			device_type[device]=device_type[device]|DEVICE_REMOV;
		}
		/* ZIPデバイスの判定を入れる場合 */
		/* identify_data[device]中の Model number などからデバイスを特定 */
		/*	device_type[device]=device_type[device]|DEVICE_ZIP; */
		i=IDE_identify_device(device,DEVICE_ATA,&identify_data[device][0]);
		if (i!=0) return -1;

	} else if (device_type[device]&DEVICE_ATAPI) {	/* ATAPIデバイス */
		if (((identify_data[device][0]>>8)&0x1f)==5) {	/* CD-ROM/DVD-ROM device */
			device_type[device]=device_type[device]|DEVICE_CDROM;
		}
		if (identify_data[device][0]&0x80) {	/*  リムーバブルデバイス */
			device_type[device]=device_type[device]|DEVICE_REMOV;
		}
		/* MOやSuperDiskデバイスの判定を入れる場合 */
		/* identify_data[device]中の Model number などからデバイスを特定 */
		/*	device_type[device]=device_type[device]|DEVICE_MO; */
		/*	device_type[device]=device_type[device]|DEVICE_LS; */
		i=IDE_identify_device(device,DEVICE_ATAPI,&identify_data[device][0]);
		if (i!=0) return -2;
	}
	/* GET MEDIA STATUSコマンド対応確認 */
	if (
		(identify_data[device][82]!=0xffff)&&((identify_data[device][82]&0x04)==0x04) /* Removable Media feature set */
	 ||	/* ←とりあえず「どれか成立すれば」で判定 */
		(identify_data[device][83]!=0xffff)&&((identify_data[device][83]&0x10)==0x10) /* Removable Media Status Notification feature set */
	 ||	/* ←とりあえず「どれか成立すれば」で判定 */
		((identify_data[device][127]&3)==1) /* Removable Media Status Notification feature set */
	) {	/* GET MEDIA STATUSコマンドに対応しているかもしれないので、実際にコマンドを発行してみる */
		i=IDE_get_media_status(device);
		if ((i&4)==0) device_type[device]=device_type[device]|DEVICE_GETMeSt;	/* アボードが発生しなければGET MEDIA STATUSコマンド対応 */
	}
	/* CFAデバイス確認 */
	if (
		(identify_data[device][0]==0x848a)	/* CFAシグネチャ */
	 ||	/* ←とりあえず「どちらか成立すれば」で判定 */
		(identify_data[device][83]!=0xffff)&&((identify_data[device][83]&0x02)==0x02) /* CFA feature set */
	) {
		device_type[device]=device_type[device]|DEVICE_CFA;		/* CFAデバイスである */
	}
	return 0;
}

/* デバイス対応最上位モード判定 */
void ide_initialize_device_modcheck(int device , int *device_pio_mode, int *device_dma_mode)
{
	if ((device_type[device]&DEVICE_ATA)||(device_type[device]&DEVICE_ATAPI)) {
		if (identify_data[device][53] & 2) {	/* ワード53 ビット1=1 ワード64～70有効 */
			*device_pio_mode=0;	/* 基本はPIOモード0 */
			if (identify_data[device][64] & 1) *device_pio_mode=3;	/* PIOモード3 */
			if (identify_data[device][64] & 2) *device_pio_mode=4;	/* PIOモード4 */
			if (identify_data[device][63] & 7) {	/* マルチワードDMA転送対応 */
				if (identify_data[device][63] & 1) *device_dma_mode=0;	/* モード0 */
				if (identify_data[device][63] & 2) *device_dma_mode=1;	/* モード1 */
				if (identify_data[device][63] & 4) *device_dma_mode=2;	/* モード2 */
			} else {
				*device_dma_mode=-1;	/* マルチワードDMA非対応 */
			}
		} else {	/* 対応モードが不明な場合 */
			*device_pio_mode=0;		/* PIOモード 0 */
			*device_dma_mode=-1;	/* マルチワードDMA非対応 */
		}
	} else {	/* デバイス未接続 or 非ATA/ATAPIデバイス */
		*device_pio_mode=255;	/* 未接続や非ATA/ATAPIデバイスなら無視 */
		*device_dma_mode=255;
	}
}

/* ATAデバイス接続確認 & ATAデバイスモード初期化
引き数     なし
戻り値     エラーコード
*/
int IDE_Initialize_Device(void)
{
	int i;
	int device0_pio_mode,device1_pio_mode;
	int device0_dma_mode,device1_dma_mode;

	/* デバイス接続チェック */
	ide_initialize_device_check();

	/* デバイス0モード判定 */
	ide_initialize_device_modcheck(DEVICE0,&device0_pio_mode,&device0_dma_mode);
	/* デバイス1モード判定 */
	ide_initialize_device_modcheck(DEVICE1,&device1_pio_mode,&device1_dma_mode);

	/* PIOモードの設定 */
	if (device0_pio_mode<device1_pio_mode) {/* モード値の小さいほうにあわせる */
		PIO_mode=device0_pio_mode;
	} else {
		PIO_mode=device1_pio_mode;
	}
	/* マルチワードDMAモードの設定 */
	if (device0_dma_mode<device1_dma_mode) {/* モード値の小さいほうにあわせる */
		DMA_mode=device0_dma_mode;
	} else {
		DMA_mode=device1_dma_mode;
	}

	/* デバイス0モード初期化 */
	i=ide_initialize_device_mode_sub1(DEVICE0,PIO_mode,DMA_mode);
	if (i!=0) return i;
	/* デバイス1モード初期化 */
	i=ide_initialize_device_mode_sub1(DEVICE1,PIO_mode,DMA_mode);
	if (i!=0) return i-50;
	/* デバイス0 モード初期化後IDENTIFYコマンド再実行 */
	i=ide_initialize_device_mode_sub2(DEVICE0);
	if (i!=0) return i-100;
	/* デバイス1 モード初期化後IDENTIFYコマンド再実行 */
	i=ide_initialize_device_mode_sub2(DEVICE1);
	if (i!=0) return i-150;

	/* ホストコントローラのモード設定 */
	IDE_initialize_host_mode(PIO_mode,DMA_mode);

	device_ready[DEVICE0]=MEDIA_NotReady;
	device_ready[DEVICE1]=MEDIA_NotReady;
	return 0;	/* 正常終了 */
}

/* デバイスタイプ取得
引き数
	device : デバイス選択 0 or 1
戻り値       デバイスタイプ(DEVICE_xxx定義)
*/
int IDE_Get_Device_Type(int device)
{
	return device_type[device];
}

/* デバイスIDENTIFY情報取得
引き数
	device : デバイス選択 0 or 1
	*buff  : データ転送先バッファポインタ
戻り値       なし
*/
void IDE_Get_Identify_Infomation(int device, UWORD *buff)
{
	int i;
	for(i=0;i<256;i++){
		buff[i]=identify_data[device][i];	/* IDENTIFY情報コピー */
	}
}

/* 現在のPIO転送モードを取得
引き数       なし
戻り値
	0～4   : PIO転送モード
*/
int IDE_Get_PIO_Mode(void)
{
	return PIO_mode;
}

/* 現在のDMA転送モードを取得
引き数       なし
戻り値
	0>     : 非対応
	0～2   : マルチワードDMA転送モード
*/
int IDE_Get_DMA_Mode(void)
{
	return DMA_mode;
}

/* デバイス/メディアのセクタあたりのバイト数と最大LBAの取得
引き数
	device  : デバイス選択 0 or 1
	*lba    : 最大LBA値格納ポインタ
	*size   : セクタサイズ値格納ポインタ
戻り値
	0!=     : エラー終了
	0       : 正常終了
*/
int IDE_Get_Media_Infomation(int device, UDWORD *lba, UWORD *size)
{
	int i,j;
	UDWORD l;
	UBYTE buffer[8];
	if (device_type[device]&DEVICE_ATA) {	/* 選択されたドライブはATAデバイス */
		*size=device_secter_size[device]=512;	/* ATAデバイスは1セクタ512バイト */
		if (device_type[device]&DEVICE_REMOV) {	/* リムーバブルデバイス */
			for(j=0;j<RETRY_MAX;j++){	/* 正常終了するまでリトライ */
				i=IDE_identify_device(device,DEVICE_ATA,&identify_data[device][0]);
				if (i==0) break;	/* 正常終了 */
			}
			if (i==0) {	/* IDENTIFY情報正常取得 */
				l=identify_data[device][61]<<16|identify_data[device][60];	/* 最大セクタ数 */
				*lba=l;
				return 0;	/* 正常終了 */
			} else {	/* IDENTIFY情報取得エラー */
				*lba=0;
				return -1;	/* 正常終了 */
			}
		} else {	/* 非リムーバブルデバイス */
			l=identify_data[device][61]<<16|identify_data[device][60];	/* 最大セクタ数 */
			*lba=l;
			return 0;	/* 正常終了 */
		}
	} else if (device_type[device]&DEVICE_ATAPI) {	/* 選択されたドライブはATAPIデバイス */
		for(j=0;j<RETRY_MAX;j++){
			i=IDE_atapi_read_capacity(device, buffer);	/* READ CAPACITYコマンドパケット */
			if (i==0) break;	/* 正常取得 */
		}
		if (i!=0) return i;	/* エラー終了(メディアが入っていないなど) */
		l=buffer[0]<<24|buffer[1]<<16|buffer[2]<<8|buffer[3];	/* 最大LBA */
		*lba=l;
		l=buffer[4]<<24|buffer[5]<<16|buffer[6]<<8|buffer[7];	/* ブロックサイズ */
		*size=device_secter_size[device]=l;
		return 0;	/* 正常終了 */
	} else {
		return -1;	/* エラー */
	}
}

/* ATAPIデバイス(CD-ROMドライブ)レディチェック
引き数
	device   : デバイス選択 0 or 1
戻り値
	bit27~24 : SenseKey
	bit23~16 : ASC
	bit15~8  : ASCQ
	bit7~0   : 0
*/
UDWORD IDE_Get_Atapi_DeviceReady(int device)
{
	int i,j;
	UDWORD l;
	UBYTE sense_buffer[18];
	if (device_type[device]&DEVICE_ATAPI) {	/* ATAPIデバイスの場合 */
		for(j=0;j<RETRY_MAX;j++){		/* Request Senseが失敗したときはリトライ */
			IDE_atapi_test_unit(device);/* ATAPI TEST UNIT */
			i=IDE_atapi_request_sense(device,sense_buffer);
			if (i==0) break;			/* 正常終了 */
			ide_ata_wait(ATA_WAIT5ms);	/* 5msウェイト */
		}
		if (i==0) {						/* Request Sense成功時 */
			l=((sense_buffer[2]&0xf)<<24)|(sense_buffer[12]<<16)|(sense_buffer[13]<<8);
		} else {
			l=0xffffff00;
		}
	} else {
		l=0xffffff00;
	}
	return l;
}

/* メディア状態チェック(即時コマンド発行)
引き数
	device   : デバイス選択 0 or 1
戻り値
  CD-ROMデバイスの場合
	bit27~24 : SenseKey
	bit23~16 : ASC
	bit15~8  : ASCQ
	bit7~0   : メディア状態(MEDIA_xxx定義)
  CD-ROM以外のデバイスの場合
	bit7~0   : メディア状態(MEDIA_xxx定義)
*/
UDWORD IDE_Get_MediaStatus_Immediate(int device)
{
	int i;
	UDWORD l;
	if (device_type[device]&DEVICE_REMOV) {	/* リムーバブルデバイスの場合 */

		if ((device_type[device]&DEVICE_CDROM)==0) {	/* CD-ROM以外のデバイスの場合 */

			if (device_type[device]&DEVICE_GETMeSt) {	/* GET MEDIA STATUSコマンド対応の場合 */
				l=0;
				i=IDE_get_media_status(device);			/* GET MEDIA STATUSコマンド */
				if (i!=0) {	/* エラー状態 */
					if (i&BIT_WP)   l=l|MEDIA_Wp;		/* メディアがライトプロテクト状態である */
					if (i&BIT_NM)   l=l|MEDIA_NoDisk;	/* メディアがない */
					if (i&BIT_MC)   l=l|MEDIA_Chg;		/* メディアがチェンジされた */
					if (i&BIT_MCR) {
						l=l|MEDIA_ChgReq;				/* メディアチェンジが要求された */
						IDE_Media_Eject(device);		/* メディアイジェクト(エラー無視) */
					}
					if (i&BIT_ABRT) l=l|MEDIA_Error;	/* 何らかのエラー */
					device_ready[device]=l;
				} else {	/* 正常終了(アクセスレディ状態) */
					device_ready[device]=l|MEDIA_Ready;	/* レディ状態 */
				}

			} else {	/* GET MEDIA STATUSコマンド非対応の場合 */
				if (device_type[device]&DEVICE_ATAPI) {	/* ATAPIデバイスの場合 */
					l=IDE_Get_Atapi_DeviceReady(device);/* ビット27～8にSenseKeyやASC/ASCQの状態を格納 */
				}
				device_ready[device]=l|MEDIA_Ready;		/* レディ状態 */
				/* リムーバブルメディアのフラグが立っているのにGET MEDIA STATUSコマンド非対応の場合は */
				/* ATAPIデバイスならTEST UNITパケットコマンドなどでデバイスの状態を調べ */
				/* とりあえずレディ状態として返す */
				if (device_type[device]&DEVICE_CFA) {	/* CFAデバイスの場合 */
				/* CompactFlashなどPCカード系のATAデバイス(リムーバブルデバイスなのにGET MEDIA STATUSコマンド非対応) */
				/* の場合は、不意にカードを抜かれる状況が考えられるので、ここでカードの接続状態を確認したほうが良い */
				/* PCカードやCFの場合は、CD1#/CD2#(カードデテクト信号)を調べてカードが抜かれたかどうかを判定する */
				/* TrueIDEモードの場合は… プラットホーム依存(^^;) */
				}
			}

		} else {	/* CD-ROMデバイスの場合 */
			l=IDE_Get_Atapi_DeviceReady(device);	/* ビット27～8にSenseKeyやASC/ASCQの状態を格納 */
			if (l==0) {					/* レディ状態 */
				device_ready[device]=l|MEDIA_Wp|MEDIA_Ready;
			} else if ((l&0x0fff0000)==0x06280000) {/* ディスクが交換された */
				device_ready[device]=l|MEDIA_Wp|MEDIA_Chg;
			} else if ((l&0x0f000000)==0x02000000) {/* Notレディ状態 */
				device_ready[device]=l|MEDIA_Wp|MEDIA_NotReady;
			} else {					/* 何らかのエラー状態 */
				device_ready[device]=l|MEDIA_Wp|MEDIA_Error;
			}							/* ↑CD-ROMは読み出し専用なのでMEDIA_Wpを付加 */
		}

	} else {	/* 非リムーバブルメディア */
		device_ready[device]=MEDIA_Ready;	/* 常時レディ状態 */
	}
	return device_ready[device];
}

/* メディア状態チェック(保存情報から返す)
引き数
	device   : デバイス選択 0 or 1
戻り値
  CD-ROMデバイスの場合
	bit27~24 : SenseKey
	bit23~16 : ASC
	bit15~8  : ASCQ
	bit7~0   : メディア状態(MEDIA_xxx定義)
  CD-ROM以外のデバイスの場合
	bit7~0   : メディア状態(MEDIA_xxx定義)
*/
UDWORD IDE_Get_MediaStatus(int device)
{
	return device_ready[device];	/* デバイス状態データを返す */
}

/* メディアアクセスレディ待ち(リトライ付き)
引き数
	device   : デバイス選択 0 or 1
	flg      : リードアクセス MEDIA_ReadAccess(0) / ライトアクセス MEDIA_WriteAccess(1)
戻り値         メディア状態(MEDIA_xxx)
*/
int IDE_Media_AccessReady(int device,int flg)
{
	int j;
	UDWORD l,k;
	if (flg) {	/* ライトアクセス時 */
		k=0xffffffff;
	} else {	/* リードアクセス時(ライトプロテクトチェックは無し) */
		k=0xfffffffe;
	}
	for(j=0;j<RETRY_MAX;j++){
		l=IDE_Get_MediaStatus_Immediate(device)&k;
		if (l==MEDIA_Ready) break;
		ide_ata_wait(ATA_WAIT5ms);	/* 5msウェイト */
		if (device_type[device]&DEVICE_CDROM) {	/* CD-ROMドライブの場合 */
			IDE_atapi_start_unit(device,ATAPI_START);	/* UNITスタート */
		}
	}
	return (int)l&0xff;
}

/* メディアロック設定/アンロック設定
引き数
	device  : デバイス選択 0 or 1
	lock    : ロック MEDIA_Lock(1)  / アンロック MEDIA_UnLock(0)
戻り値
	-200    : 非リムーバブルデバイス未対応
	-100    : ロック/アンロック機能がない
	0       : 正常終了
	0<      : エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_Media_LockUnlock(int device, int lock)
{
	int i,l;
	if (device_type[device]&DEVICE_REMOV) {	/* リムーバブルデバイス */
		if (
			(device_type[device]&DEVICE_LOCK)		/* ロック/アンロック機能あり */
		||
			(device_type[device]&DEVICE_CDROM)		/* CD-ROMデバイスだったら */
		) {
			if (device_type[device]&DEVICE_ATA) {	/* 選択されたドライブはATAデバイス */
				for(l=0;l<RETRY_MAX;l++){	/* 正常終了するまでリトライ */
					if (lock==MEDIA_Lock) {	/* ロック設定 */
						i=IDE_media_lock(device);	/* DOOR/MEDIA LOCKコマンド発行 */
						if (i==0) break;	/* 正常終了 */
					} else {	/* アンロック設定 */
						i=IDE_media_unlock(device);	/* DOOR/MEDIA UNLOCKコマンド発行 */
						if (i==0) break;	/* 正常終了 */
					}
				}
			} else {						/* 選択されたドライブはATAPIデバイス */
				for(l=0;l<RETRY_MAX;l++){	/* 正常終了するまでリトライ */
					/* PREVENT ALLOW MEDIAUM REMOVALパケットコマンド発行 */
					i=IDE_prevent_allow_mediaum_removal(device,lock);	/* ロック/アンロック */
					if (i==0) break;		/* 正常終了 */
				}
			}
			return i;	/* 終了コード */
		} else {	/* ロック/アンロック機能がない */
			return -100;
		}
	} else {	/* 非リムーバブルデバイスにはこの機能はない */
		return -200;
	}
}

/* メディアイジェクト
引き数
	device  : デバイス選択 0 or 1
戻り値
	-200    : 非リムーバブルデバイス未対応
	0       : 正常終了
	0<      : 10xxh(ロック解除時のエラー)
	          30xxh(イジェクト時のエラー)
	            下位8ビット Errorレジスタの内容
*/
int IDE_Media_Eject(int device)
{
	int i,l;
	if (device_type[device]&DEVICE_REMOV) {	/* リムーバブルデバイス */
		/* メディアロック機能解除 */
		i=IDE_Media_LockUnlock(device,MEDIA_UnLock);
		if (i>0) {	/* メディアロック解除コマンドエラー発生時 */
			IDE_Get_MediaStatus_Immediate(device);	/* 現状のレディ状態を取得して保持しておく */
			return i;	/* ロック解除時のエラー */
		}	/* マイナスのエラーは、ロック/アンロック機能のないデバイスなのでイジェクトコマンドのみ実行する */
		/* イジェクト */
		if (
			(device_type[device]&DEVICE_PEJECT)	/* パワーイジェクト機能あり */
		||
			(device_type[device]&DEVICE_CDROM)	/* CD-ROMデバイスだったら */
		) {
			if (device_type[device]&DEVICE_ATA) {	/* 選択されたドライブはATAデバイス */
				for(l=0;l<RETRY_MAX;l++){	/* 正常終了するまでリトライ */
					i=IDE_media_eject(device);	/* MEDIA EJECTコマンド発行 */
					if (i==0) break;		/* 正常終了 */
				}
			} else {						/* 選択されたドライブはATAPIデバイス */
				for(l=0;l<RETRY_MAX;l++){	/* 正常終了するまでリトライ */
					/* START/STOP UNIT(START)パケットコマンド発行 */
					i=IDE_atapi_start_unit(device,ATAPI_EJECT);	/* イジェクト */
					if (i==0) break;		/* 正常終了 */
				}
			}
			if (i>0) i=i|0x3000;	/* イジェクト時のエラー */
		}
		IDE_Get_MediaStatus_Immediate(device);	/* イジェクト後のレディ状態を取得して保持しておく */
		return i;		/* 終了コード */
	} else {	/* 非リムーバブルデバイスにはこの機能はない */
		return -200;
	}
}

/* メディアトレイクローズ
引き数
	device  : デバイス選択 0 or 1
	lock    : ロック/アンロック
戻り値
	-200    : 非リムーバブルデバイス/パワーイジェクト機構非対応デバイスでは未対応
	-100    : ATAデバイスには該当コマンドがない
	0       : 正常終了
	0<      : エラー(下位8ビット Errorレジスタの内容)
*/
int IDE_Media_TrayClose(int device)
{
	int i,l;
	if (device_type[device]&DEVICE_REMOV) {	/* リムーバブルデバイス */
		if (
			(device_type[device]&DEVICE_PEJECT)	/* パワーイジェクト機能あり */
		||
			(device_type[device]&DEVICE_CDROM)	/* CD-ROMデバイスだったら */
		) {
			if (device_type[device]&DEVICE_ATAPI) {	/* 選択されたドライブはATAPIデバイス */
				for(l=0;l<RETRY_MAX;l++){	/* 正常終了するまでリトライ */
					/* START/STOP UNIT(START)パケットコマンド発行 */
					i=IDE_atapi_start_unit(device,ATAPI_CLOSE);	/* トレイクローズ */
					if (i==0) break;	/* 正常終了 */
				}
				return i;	/* 終了コード */
			} else {	/* ATAデバイス用には該当コマンドはない */
				return -100;
			}
		} else {	/* パワーイジェクト機構非対応デバイスにはこの機能はない */
			return -200;
		}
	} else {	/* 非リムーバブルデバイスにはこの機能はない */
		return -200;
	}
}

/* 直前のATAPIコマンドで転送されたバイト数取得
引き数
	device  : デバイス選択 0 or 1
戻り値        バイト数
*/
UWORD IDE_Get_Atapi_TransferByte(void)
{
	return atapi_datatransfer;	/* ATAPIで転送したバイト数 */
}

/* セクタリード(ATA/ATAPI兼用/リトライあり)
引き数
	device  : デバイス選択 0 or 1
	lba     : LBA
	count   : セクタ数
	*buff   : 読み出しデータ格納先バッファポインタ
戻り値
	0>      : コマンド実行前/中エラー
	0       : 正常終了
	0<      : エラー終了(下位8ビット メディア状態(MEDIA_xxx定義) )
*/
int IDE_Read_Sector(int device, UDWORD lba, UWORD count, void *buff)
{
	int i,l;
	if ((device_ready[device]&0xfffffffe)==MEDIA_Ready) {	/* レディ状態なら */
		if (device_type[device]&DEVICE_ATA) {	/* 選択されたドライブはATAデバイス */
			i=IDE_ata_read_sector(device,lba,count,buff);
		} else {						/* ATAPIデバイス時 */
			i=IDE_atapi_read10(device,lba,count,buff);
		}
		if (i<=0) return i;	/* 正常終了またはコマンド実行前/中エラー */
	}
	for(l=0;l<RETRY_MAX;l++){	/* 何らかのエラーが発生した場合 */
		i=IDE_Media_AccessReady(device,MEDIA_ReadAccess);
		if (i!=MEDIA_Ready) return i;		/* 正常にアクセスできない状態 */
		if (device_type[device]&DEVICE_ATA) {	/* 選択されたドライブはATAデバイス */
			i=IDE_ata_read_sector(device,lba,count,buff);
		} else {						/* ATAPIデバイス時 */
			i=IDE_atapi_read10(device,lba,count,buff);
		}
		if (i<=0) return i;	/* 正常終了またはコマンド実行前/中エラー */
	}
	return 0x1000|IDE_Media_AccessReady(device,MEDIA_ReadAccess);
}

/* セクタライト(ATA/ATAPI兼用/リトライあり)
引き数
	device  : デバイス選択 0 or 1
	lba     : LBA
	count   : セクタ数
	*buff   : 書き込みデータ格納元バッファポインタ
戻り値
	0>      : コマンド実行前/中エラー
	0       : 正常終了
	0<      : エラー終了(下位8ビット メディア状態(MEDIA_xxx定義) )
*/
int IDE_Write_Sector(int device, UDWORD lba, UWORD count, void *buff)
{
	int i,l;
	if (device_ready[device]==MEDIA_Ready) {	/* レディ状態なら */
		if (device_type[device]&DEVICE_ATA) {	/* 選択されたドライブはATAデバイス */
			i=IDE_ata_write_sector(device,lba,count,buff);
		} else {						/* ATAPIデバイス時 */
			i=IDE_atapi_write10(device,lba,count,buff);
		}
		if (i<=0) return i;	/* 正常終了またはコマンド実行前/中エラー */
	}
	for(l=0;l<RETRY_MAX;l++){	/* 何らかのエラーが発生した場合 */
		i=IDE_Media_AccessReady(device,MEDIA_WriteAccess);
		if (i!=MEDIA_Ready) return i;		/* 正常にアクセスできない状態 */
		if (device_type[device]&DEVICE_ATA) {	/* 選択されたドライブはATAデバイス */
			i=IDE_ata_write_sector(device,lba,count,buff);
		} else {						/* ATAPIデバイス時 */
			i=IDE_atapi_write10(device,lba,count,buff);
		}
		if (i<=0) return i;	/* 正常終了またはコマンド実行前/中エラー */
	}
	return 0x1000|IDE_Media_AccessReady(device,MEDIA_WriteAccess);
}
