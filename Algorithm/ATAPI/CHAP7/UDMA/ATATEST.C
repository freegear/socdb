/*
//=============================================================================
// ＵＤＭＡアクセステストプログラム
//
// Copyright(C) by M.Kuwano(PastelMagic) All rights reserved.
//
//=============================================================================
*/

#define	UDMA_MODE	5		/* UltraDMA/100 = mode 5 */
#define	PCI_DEV_ID	0x244B	/* Intel82801BA(ICH2)内のIDEコントローラのデバイスID */

/* #define	UDMA_MODE	2		*/ /* UltraDMA/33 = mode 2 */
/* #define	PCI_DEV_ID	0x7111	*/ /* Intel82371AB(PIIX4)内のIDEコントローラのデバイスID */

/* 以下のデバイスでは動作未確認 */
/* #define	UDMA_MODE	5		*/ /* UltraDMA/100 = mode 5 */
/* #define	PCI_DEV_ID	0x244A	*/ /* Intel82801BAM(ICH2)内のIDEコントローラのデバイスID */

/* #define	UDMA_MODE	2		*/ /* UltraDMA/66 = mode 4 */
/* #define	PCI_DEV_ID	0x2411	*/ /* Intel82801AA(ICH)内のIDEコントローラのデバイスID */

/* #define	UDMA_MODE	2		*/ /* UltraDMA/66 = mode 4 */
/* #define	PCI_DEV_ID	0x2421	*/ /* Intel82801AB(ICH)内のIDEコントローラのデバイスID */


#define		ATA100		1
#define		ATA66		0
#define		ATA33		0
#define		PCIREG_IDECONFIG	0x54
#define		IDECONFIG_MSK		((unsigned long)~0x1001)
#define		IDECONFIG_VAL		((((unsigned long)ATA100) << 12) | ((unsigned long)ATA66))

#include <stdio.h>
#include <process.h>
#include <machine.h>
#include "pcifunc.h"	/* PCI BIOSコールライブラリヘッダファイル	*/
#include "iofunc.h"		/* 32ビットI/Oアクセスライブラリヘッダファイル 	*/
#include "memfunc.h"	/* ハイメモリ領域アクセスライブラリヘッダファイル	*/

unsigned int _asm_getds(char *);
#define	get_ds()	_asm_getds("\n\tMOV\tAX,DS\n")

#define	XFR_SIZE	((unsigned long)0x00020000)
#define	XFR_BLKS	(XFR_SIZE>>9)				/* １ブロックは512バイト			*/
#define	PRD_ADRS	((unsigned long)0x00100000)		/* PRDテーブル					*/
#define	TRKBUF_ADRS	((unsigned long)0x00110000)		/* トラックバッファの物理アドレス		*/
#define	TRKBUF_ADRS2	((unsigned long)0x00120000)		/* トラックバッファの物理アドレス（続き）	*/

#define	SPIC_IMR	0xa1	/* PC/AT割り込みコントローラレジスタ */

#define	IDE_BASE	0x1f0				/* Primary IDE	*/
#define	IDE_DATA	(IDE_BASE+0)		/* Data		(r/w)	*/
#define	IDE_ER		(IDE_BASE+1)		/* Error	(r)	*/
#define	IDE_FT		(IDE_BASE+1)		/* Feature	(w)	*/
#define	IDE_SC		(IDE_BASE+2)		/* SectorCount	(r/w)	*/
#define	IDE_SN		(IDE_BASE+3)		/* SectorNumber	(r/w)	*/
#define	IDE_LL		(IDE_BASE+3)		/* LBA LOW	(r/w)	*/
#define	IDE_CL		(IDE_BASE+4)		/* CylinderLow	(r/w)	*/
#define	IDE_LM		(IDE_BASE+4)		/* LBA MID	(r/w)	*/
#define	IDE_CH		(IDE_BASE+5)		/* CylinderHigh	(r/w)	*/
#define	IDE_LH		(IDE_BASE+5)		/* LBA HIGH	(r/w)	*/
#define	IDE_DH		(IDE_BASE+6)		/* Device/Head	(r/w)	*/
#define	IDE_STS		(IDE_BASE+7)		/* Status	(r)	*/
#define	IDE_CMD		(IDE_BASE+7)		/* COMMAND	(w)	*/
#define	IDE_ASTS	(IDE_BASE+0x206)	/* AlternateSts	(r)	*/
#define	IDE_CTL		(IDE_BASE+0x206)	/* Device Ctrl	(w)	*/
#define	IDE_DRVADRS	(IDE_BASE+0x207)	/* DriveAddress	(r/w)	Obsolete	*/

#define	IDE_STS_BUSY	0x80
#define	IDE_STS_DRDY	0x40
#define	IDE_STS_DRQ	0x08

unsigned int	BMIOBASE;		/* バスマスタＩＤＥレジスタベースアドレス		*/
#define	BMICP	(BMIOBASE+0)	/* バスマスタＩＤＥコマンドレジスタ				*/
#define	BMISP	(BMIOBASE+2)	/* バスマスタＩＤＥステータスレジスタ			*/
#define	BMIDP	(BMIOBASE+4)	/* バスマスタＩＤＥディスクリプタテーブルポインタ	*/

unsigned int	IDE_BUSNUM;		/* ＩＤＥコントローラバス番号					*/
unsigned int	IDE_DEVNUM;		/* ＩＤＥコントローラデバイス番号				*/
unsigned int	IDE_FNCNUM;		/* ＩＤＥコントローラファンクション番号			*/



/*
 * Physical Resion Descriptorが64Kバウンダリをまたげない。
 * また、４バイトバウンダリに配置しなくてはならないため、
 * ２倍の領域を確保する（実際には２倍－１バイトあればＯＫ）
 */
unsigned char prddata[] = { 0x00,0x00,0x11,0x00, (XFR_SIZE & 0xff), ((XFR_SIZE>>8)&0xff), 0x00, 0x80,	/* Physical Resion Descriptor	*/
			    0x00,0x00,0x12,0x00, (XFR_SIZE & 0xff), ((XFR_SIZE>>8)&0xff), 0x00, 0x80};	/* Physical Resion Descriptor	*/


/*
 * IDEコマンドテーブル（必要なパラメータ部分は必要に応じて書き換え）
 */
unsigned char cmd_identify[]	= {0x00, 0x00, 0x00, 0x00, 0x00, 0xa0, 0xec};
unsigned char cmd_setfeatures[]	= {0x03, (0x40+UDMA_MODE), 0x00, 0x00, 0x00, 0xa0, 0xef,
				   0x03, 0x00, 0x00, 0x00, 0x00, 0xa0, 0xef};
unsigned char cmd_readdma[]	= {0x00, XFR_BLKS, 0x00, 0x00, 0x00, 0xe0, 0xc8};
unsigned char cmd_writedma[]	= {0x00, XFR_BLKS, 0x00, 0x00, 0x00, 0xe0, 0xca};



/*
 * エラー終了表示用
 * 標準エラー出力に出すのが清く正しいありかただけれども、
 * リダイレクトしてログを取りやすいので標準出力に出した
 */
void err_aux(unsigned char *p)
{
	printf("%s",p);
	exit(0);
}


/*
 * ＩＤＥデバイスに対するコマンドセット
 *　配列の先頭＋０：Featureレジスタ値
 *　　　　　　＋１：SectorCountレジスタ値
 *　　　　　　＋２：SectorNumber（LBA_LOW）レジスタ値
 *　　　　　　＋３：CylinderLow （LBA_MIDDLE）レジスタ値
 *　　　　　　＋４：CylinderHigh（LBA_HIGH）レジスタ値
 *　　　　　　＋５：Device/Headレジスタ値
 *　　　　　　＋６：Commandレジスタ値
 */
void ide_cmdset(unsigned char *cmdtbl)
{
	unsigned char sts;
	sts = inp(IDE_STS);
	if (!(sts & IDE_STS_DRDY)) {	/* Drive Not ready	*/
		printf("[IDE_STS = %02XH]",sts);
		printf("Device Not Ready!\n");
	}
	printf("CMD:-");
	for (sts=0; sts<7; sts++)
		printf("%02xH ",*(cmdtbl+sts));
	printf("\n");
	outp(IDE_FT,*cmdtbl++);
	outp(IDE_SC,*cmdtbl++);
	outp(IDE_LL,*cmdtbl++);
	outp(IDE_LM,*cmdtbl++);
	outp(IDE_LH,*cmdtbl++);
	outp(IDE_DH,*cmdtbl++);
	outp(IDE_CMD,*cmdtbl);
}

/*
 * DRQ（Data Request）：データ転送要求フラグ：がセットされるのを待つ
 */
void ide_wait_drq()
{
	unsigned char	sts;
	while(1) {
		sts = inp(IDE_STS);
		printf("%02xH  ",sts);
		if (sts & IDE_STS_DRQ)
			break;
	}
	printf("\n");
}

/*
 * ドライブがレディ状態になるのを待つ
 */
void ide_wait_ready()
{
	unsigned char	sts;
	printf("Wait Ready\n");
	while(1) {
		sts = inp(IDE_STS);
		printf("%02xH  ",sts);
		if (!(sts & IDE_STS_BUSY))
			break;
	}
	printf("\n");
}

/*
 * PIOモードでの１ブロック（512バイト分）データリード＆表示
 * Identifyコマンドで使用する。
 * ATAのドキュメントではIdentifyデータのオフセットが10進数で
 * 表記されているので、10ワード毎に表示するようにした
 */
void ide_data_read(unsigned int size)
{
	unsigned int	i,j;
	for (i=0; i<size; i+=10) {
		printf("%04d : ",i);
		for (j=i; (j<i+10) && (j<size); j++) {
			printf("%04X ",inpw(IDE_DATA));
		}
		printf("\n");
	}
}

/*
 * Identifyコマンド実行
 */
void exec_identify()
{
	printf("Identify Start!\n");
	ide_cmdset(cmd_identify);
	printf("wait..\n");
	ide_wait_drq();
	printf("Identify Complete!\n");
	ide_data_read(0x100);
}

/*
 * 物理アドレス（20ビット長）算出
 * x86のリアルモードで、かつコンパイルはスモールモデルが前提
 * 与えられたポインタはオフセット値、セグメント値はDSレジスタ
 * 内容
 * 
 */
unsigned long phyadrs(unsigned char *p)
{
	unsigned int	off,seg;
	unsigned long	padrs;
	seg = get_ds();
	off = (unsigned int)p;
	padrs = (((unsigned long)seg) << 4) + (unsigned long)off;
	return(padrs);
}

/*
 * 物理アドレス（20ビット長）から、セグメント値分を引いて
 * オフセットアドレスを得る
 */
unsigned int offsetadrs(unsigned long phyadrs)
{
	unsigned int	seg,off;
	phyadrs &= 0x000fffff;
	seg = get_ds();
	off = phyadrs - (((unsigned long)seg) << 4);
	return(off);
}
/*
 * Physical Resion Descriptor、
 * BMIDP、BMICPをセットアップし、転送開始準備
 *
 * dir: 0=MemoryRead 1=MemoryWrite
 */
void setup_prd(unsigned char dir)
{
	prddata[15] = 0x80;
	if (XFR_SIZE > 0x00010000)				/* ６４Ｋ以下なら一つでＯＫ		*/
		prddata[7] = 0x00;
	else	prddata[7] = 0x80;
	_maskNMI();			/* パリティエラーNMI禁止 */
	_writeHimemBlockByte(PRD_ADRS, prddata, 0x10);
	_unmaskNMI();			/* NMI許可 */
	dir = (dir & 1) << 3;
	outp(BMICP, dir);					/* 転送方向フラグセット			*/
	_IoWriteLong(BMIDP, PRD_ADRS);				/* データポインタセット			*/
}

/*
 * DMAにスタートをかける
 */
void start_dma()
{
	unsigned char dat;
	dat = inp(BMISP);
	outp(BMISP,dat);					/* 割り込みフラグをクリアしておく	*/
	dat = inp(BMICP) | 0x1;
	outp(BMICP,dat);
}

/*
 * DMA停止（転送動作中には使わないこと）
 */
void stop_dma()
{
	unsigned char dat;
	dat = inp(BMICP) & 0xfe;
	outp(BMICP,dat);
}

/*
 * バッファクリア＆初期化関係
 */
void clear_buf(unsigned char dat)
{
	_maskNMI();			/* パリティエラーNMI禁止 */
	_fillHimemByte(TRKBUF_ADRS, XFR_SIZE, dat);
	_unmaskNMI();			/* NMI許可 */
}

void init_buf(unsigned char dat)
{
	unsigned long i,adrs;
	adrs = TRKBUF_ADRS;
	_maskNMI();			/* パリティエラーNMI禁止 */
	for (i=0; i<XFR_SIZE; i++) {	/* 01,02...FF,01,02..というずれた周期にする	*/
		_writeHimemByte(adrs++,dat++);
		if (dat == 0x00)
			dat++;
	}
	_unmaskNMI();			/* NMI許可 */
}

/*
 * バッファ内容の表示
 */
void disp_buf()
{
	unsigned long	i,adrs;
	unsigned int	j;
	unsigned char	c;
	printf("Buffer Data:-\n");
	adrs = TRKBUF_ADRS;
	_maskNMI();			/* パリティエラーNMI禁止 */
	for (i=0; i<XFR_SIZE; i+=16) {
		printf("%08lXH: ",i);
		for (j=0; j<16; j++) {
			c = _readHimemByte(adrs++);
			printf("%02X ",c);
		}
		printf("\n");
	}
	_unmaskNMI();			/* NMI許可 */

}

/*
 * 割り込み＆動作完了待ち
 * 通常のPICのIRQ14で待ちかまえていても良いのだろうけれども、
 * バスマスタIDE I/Oレジスタの、
 * BMISPに割り込みフラグがあるので、こちらを使う。
 */
void ide_wait_int()
{
	unsigned char	dat;
	printf("BMISP:-");
	while(1) {
		dat= inp(BMISP);
		printf("%02X  ",dat);
		if ((dat & 0x05) == 0x04)	/* 割り込みきて、ACTが落ちたよー	*/
			break;
	}
	printf("\n");
	outp(BMISP, dat | 0x4);
}

void wait_drrdy()
{
	unsigned char c;
	while(1) {
		c = inp(IDE_STS);
		if (c & IDE_STS_DRDY)
			break;
	}
}

/*
 * ＤＭＡを使ったデータライト動作
 * LBAブロック番号から始まるインクリメントデータ（インクリメント後はFFhの後を
 * 01ｈにする、変則インクリメントデータ）を書き込む
 */
void exec_write_dma(unsigned long lba)
{
	printf("Write DMA [%08lXH] Start!\n",lba);
	cmd_writedma[2] = lba & 0xff;		/* LBAアドレスを設定					*/
	cmd_writedma[3] = (lba >> 8) & 0xff;
	cmd_writedma[4] = (lba >> 16) & 0xff;
	cmd_writedma[5] = ((lba >> 24) & 0xf) | (cmd_writedma[5] & 0xf0);
	printf("Write set PRD\n");
	setup_prd(0);				/* ライト方向（メモリリード方向）でPRDをセットアップ	*/
	init_buf((unsigned char)(lba & 0xff));	/* バッファ初期化					*/
	printf("Send Command\n");
	ide_cmdset(cmd_setfeatures);		/* SET FEATURESコマンドで転送モードをUDMAに設定		*/
	wait_drrdy();
	ide_cmdset(cmd_writedma);		/* DMAライト転送コマンド発行				*/
	printf("DMA Start!\n");
	start_dma();				/* DMAスタートして・・					*/
	printf("Waiting..\n");
	ide_wait_int();				/* 完了を待つ						*/
	printf("Done!\n");
	stop_dma();				/* DMA停止させて					*/
	ide_cmdset(&cmd_setfeatures[7]);	/* ＰＩＯモードに戻しておく				*/
}

/*
 * ＤＭＡを使ったデータリード動作
 */
void exec_read_dma(unsigned long lba)
{
	printf("Read DMA [%08lXH] Start!\n",lba);
	cmd_readdma[2] = lba & 0xff;		/* LBAアドレスを設定					*/
	cmd_readdma[3] = (lba >> 8) & 0xff;
	cmd_readdma[4] = (lba >> 16) & 0xff;
	cmd_readdma[5] = ((lba >> 24) & 0xf) | (cmd_readdma[5] & 0xf0);
	setup_prd(1);				/* リード方向（メモリライト方向）でPRDをセットアップ	*/
	clear_buf(0xaa);			/* ちゃんと読めたかの確認用にバッファを固定値でクリア	*/
	printf("DMA Start!\n");
	start_dma();				/* DMAをスタートさせておく				*/
	printf("Send Command\n");
	ide_cmdset(cmd_setfeatures);		/* SET FEATURESコマンドで転送モードをUDMAに設定		*/
	wait_drrdy();
	ide_cmdset(cmd_readdma);		/* DMAリードコマンド発行				*/
	printf("Waiting..\n");
	ide_wait_int();				/* で、完了待ち						*/
	printf("Done!\n");
	stop_dma();				/* DMA停止させて					*/
	ide_cmdset(&cmd_setfeatures[7]);	/* ＰＩＯモードに戻しておく				*/
	disp_buf();
}

void atamode_setup()
{
	unsigned long	ldat;
	ldat=_pciConfigReadLong(pciBusDevFunc(IDE_BUSNUM,IDE_DEVNUM,IDE_FNCNUM),0x54);
	printf("ATA MODE SET! [%08lXH]:[%08lXH]=",ldat, IDECONFIG_VAL);
	ldat = (ldat & (IDECONFIG_MSK)) | IDECONFIG_VAL;
	printf("%08lXH\n",ldat);
	_pciConfigWriteLong(pciBusDevFunc(IDE_BUSNUM,IDE_DEVNUM,IDE_FNCNUM),0x54,ldat);
}





void main(void)
{
	unsigned char	cdat,msk;
	unsigned long	ldat;
	if (_preInitHimem() != 0) {	/* ハイメモリアクセス関数初期化 */
		err_aux("HiMemory access lib init error!\n");
	}
	ldat=_pciFindPciDevice(0x8086,PCI_DEV_ID,0);
	if ((ldat & 0xFFFF)!= 0) {
		err_aux("Sorry...Not supported.\n");
	} else {
		IDE_BUSNUM=pciGetBus(ldat >> 16);
		IDE_DEVNUM=pciGetDev(ldat >> 16);
		IDE_FNCNUM=pciGetFunc(ldat >> 16);
	}
	printf("IDE Controller Bus:%d Dev:%d Func:%d\n",IDE_BUSNUM,IDE_DEVNUM,IDE_FNCNUM);
	atamode_setup();
	msk = inp(SPIC_IMR);
	outp(SPIC_IMR,0x40);				/* プライマリＩＤＥ割り込みマスク		*/
	cdat=_pciConfigReadByte(pciBusDevFunc(IDE_BUSNUM,IDE_DEVNUM,IDE_FNCNUM),0x48);
	if (!(cdat & 1))				/*  DMAモードになってない			*/
		err_aux("SDMA_CNT:PSDE: Primary Drive 0 Synchronous DMA Mode Disabled.\n");
	/* バスマスタIDE レジスタのベースアドレス取得	*/
	BMIOBASE=_pciConfigReadLong(pciBusDevFunc(IDE_BUSNUM,IDE_DEVNUM,IDE_FNCNUM),0x20) & 0xfff0;
	printf("Base Address = %04XH\n",BMIOBASE);
	exec_identify();				/* Identify情報取得				*/
	for (ldat = 1; ldat < 0x3; ldat++) {
		exec_write_dma(ldat);
	}
	for (ldat = 1; ldat < 3; ldat++) {
		exec_read_dma(ldat);
	}
	outp(SPIC_IMR,msk);				/* 割り込みマスクを元に戻す			*/
}
