/***********************************
	SH-3/SH-4用 I/Oアクセス部
************************************/

#include "typedef.h"
#include "iodef.h"
#include "isabase.h"

/*************************/
/* 物理I/Oアクセスレベル */
/*************************/

/* バイトサイズ入力 */
UBYTE in_byte(unsigned int p)
{
  UBYTE c;
  UBYTE *ptr;
  ptr=(UBYTE *)p;
  c=*ptr;
  return c;
}

/* ワードサイズ入力 */
UWORD in_word(unsigned int p)
{
  UWORD w;
  UWORD *ptr;
  ptr=(UWORD *)p;
  w=*ptr;
  return w;
}

/* バイトサイズ出力 */
void out_byte(unsigned int p, UBYTE c)
{
  UBYTE *ptr;
  ptr=(UBYTE *)p;
  *ptr=c;
}

/* ワードサイズ出力 */
void out_word(unsigned int p, UWORD w)
{
  UWORD *ptr;
  ptr=(UWORD *)p;
  *ptr=w;
}

/* ATAレジスタアクセスウェイト */
void ide_ata_wait(UDWORD count)
{
	UWORD i;
	UDWORD l;
	for(l=0;l<count;l++){
		i=*BridgeEnable;	/* 1アクセス400ns以上 */
	}
}

/* ホストコントローラのモード設定 */
void IDE_initialize_host_mode(int pio_mode,int dma_mode)
{
	if (pio_mode==3) {
		*ATACtrl=0x8001;	/* PIOモード3 */
	} else if (pio_mode==4) {
		*ATACtrl=0x8002;	/* PIOモード4 */
	} else {
		*ATACtrl=0x8000;	/* PIOモード0 */
	}
	return;
}
