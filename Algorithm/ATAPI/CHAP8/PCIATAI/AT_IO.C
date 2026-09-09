/***********************************************
	PC/AT互換機 PCI ATAホスト用 I/Oアクセス部
************************************************/

#include <conio.h>
#include "typedef.h"
#include "iodef.h"
#include "pcifunc.h"	/* PCI BIOSコールライブラリ */

/*************************/
/* 物理I/Oアクセスレベル */
/*************************/

/* バイトサイズ入力 */
UBYTE in_byte(unsigned int p)
{
	UBYTE c;
	c=inp(p);
	return c;
}

/* ワードサイズ入力 */
UWORD in_word(unsigned int p)
{
	UWORD w;
	w=inpw(p);
	return(w);
}

/* バイトサイズ出力 */
void out_byte(unsigned int p, UBYTE c)
{
	outp(p,c);
}

/* ワードサイズ出力 */
void out_word(unsigned int p, UWORD w)
{
	outpw(p,w);
}

/* ATAレジスタアクセスウェイト */
void ide_ata_wait(UDWORD count)
{
	UDWORD l;
	for(l=0;l<count;l++){
		/* このfor文の中を1回実行するのに400ns以上かかるように調整 */
		in_byte(BASE_ATA_REGS+0x10);	/* ウェイト用ダミーアクセスレジスタ */
	}
}

/* ホストコントローラのモード設定 */
void IDE_initialize_host_mode(int pio_mode,int dma_mode)
{
	_pciConfigWriteLong(pciBusDevFunc(Bus,Dev,Func),0x40,pio_mode);
	return;
}
