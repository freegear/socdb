/*	ハイメモリアクセスサンプル MEMTEST.C	*/

#include	<stdio.h>
#include	"memfunc.h"		/* ハイメモリアクセスライブラリヘッダファイル */

int main(void)
{
	int	j;
	unsigned char	c;
	unsigned int	i;
	unsigned long	l;
	unsigned char	redbuf1[1024];
	unsigned char	redbuf2[1024];


	j=_getCpuMode();	/* CPUモード確認 */
	if (j != 0) {
		printf("メモリドライバが動作している環境では動作できません。(CPU Mode:");
		switch(j){
			case 1 :
				printf("VCPI mode)\n");
				break;
			case 2 :
				printf("DPMI mode)\n");
				break;
			default :
				printf("unknown mode)\n");
				break;
		}
		return(-1);
	}

	j=_preInitHimem();	/* ハイメモリアクセス関数初期化 */
	if (j != 0) {
		printf("メモリ初期化に失敗しました。(エラーコード:%d)\n",j);
		return(-1);
	}
	_maskNMI();			/* パリティエラーNMI禁止 */

	_writeHimemByte(0x01000000,0x88);	/* 1000000h 88h バイトライト */
	c=_readHimemByte(0x01000000);		/* 1000000h バイトリード */
	printf("Address:1000000h(Byte)=%02x\n",c);

	_writeHimemWord(0x01000002,0x55aa);	/* 1000002h 55aah ワードライト */
	i=_readHimemWord(0x01000002);		/* 1000002h ワードリード */
	printf("Address:1000002h(Word)=%04x\n",i);

	_writeHimemLong(0x01000004,0x12345678);	/* 1000004h 12345678h ロングワードライト */
	l=_readHimemLong(0x01000004);		/* 1000004h ロングワードリード */
	printf("Address:1000004h(Long)=%08lx\n",l);

	for(j=0;j<256;j++){		/* バッファ内容設定 */
		redbuf1[j]=j;
	}
	printf("Address:1100000h Buffer Write .....");
	_writeHimemBlockByte(0x01100000,redbuf1,(unsigned int)256);	/* ブロックライト(バイトサイズアクセス) */

	_readHimemBlockLong(0x01100000,redbuf2,(unsigned int)64);	/* ブロックリード(ロングワードサイズアクセス) */
	printf("Address:1100000h Buffer Read\n");
	for(j=0;j<256;j++){		/* バッファ内容表示 */
		printf("%02x  ",redbuf2[j]);
	}
	printf("\n");

	printf("Address:1100000h -> Address:1200000h Himemory Copy\n");
	_copyHimemWord(0x01100000,0x01200000,(unsigned long)128);	/* ブロックコピー */
	/* アドレス3Mバイトからアドレス4Mバイトのところに128ワード(256バイト)転送 */

	_readHimemBlockLong(0x01200000,redbuf1,(unsigned int)64);	/* ブロックリード(ロングワードサイズアクセス) */
	printf("Address:1200000h Buffer Read\n");
	for(j=0;j<16;j++){		/* バッファ内容表示 */
		printf("%02x  ",redbuf1[j]);
	}
	printf("....\n");

	printf("Address:1300000h Himemory Fill(12345678h)\n");
	_fillHimemLong(0x01300000,(unsigned long)64,0x12345678);	/* メモリフィル */
	/* アドレス5Mバイトから64ワード(256バイト)メモリフィル */

	_readHimemBlockLong(0x01300000,redbuf1,(unsigned int)64);	/* ブロックリード(ロングワードサイズアクセス) */
	printf("Address:1300000h Buffer Read\n");
	for(j=0;j<16;j++){		/* バッファ内容表示 */
		printf("%02x  ",redbuf1[j]);
	}
	printf("....");

	_unmaskNMI();	/* NMI許可 */

	return(0);
}
