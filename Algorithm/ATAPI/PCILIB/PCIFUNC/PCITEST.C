/*	PCI BIOSコールサンプル PCITEST.C	*/

#include <stdio.h>
#include "pcifunc.h"	/* PCI BIOSコールライブラリヘッダファイル */

void main(void)
{
	int	j,Bus,Dev,Func;
	unsigned char	c;
	unsigned int	i;
	unsigned long	l;

	/* PCIバスコンフィグレーション仕様&PCI BIOSシグネチャ取得 */
	i=_pciConfigVersion();
	l=_pciSigPCI();
	if ( ((i & 0xff00)!=0) || (l != 0x20494350) ) {
		printf("PCI BIOSが存在しません。\n");
		return;
	}
	/* PCIバスコンフィグレーション仕様 */
	if (i & 1) {
		printf("コンフィグレーションメカニズム1サポート\n");
	}
	if (i & 2) {
		printf("コンフィグレーションメカニズム2サポート\n");
	}
	if (i & 0x10) {
		printf("コンフィグレーションメカニズム1でスペシャルサイクルサポート\n");
	}
	if (i & 0x20) {
		printf("コンフィグレーションメカニズム2でスペシャルサイクルサポート\n");
	}

	/* PCIバスバージョン取得 */
	i=_pciBusVersion();
	printf("PCIバスバージョン %x.%02x\n",(i >>8),(i & 0xff) );

	/* PCIバス 最大番号取得 */
	c=_pciMaxBusNo();
	printf("PCIバス最大バス番号 %d\n",c);

/* ここまでの情報を一度に取得する方法として
	j=_pciGetSts(&pciConfigMechanism,&pciVersion,&pciBusNumber,&pciSignature);
という関数もある．それぞれの変数のアドレスを渡すと値が格納されて戻る */

	printf("ベンダID 8086h デバイスID 7180h (Intel 440LX) を探します。\n");
	l=_pciFindPciDevice(0x8086,0x7180,0);	/* ベンダID&デバイスID デバイス検索 */
	if ((l & 0xFFFF)!= 0) {
		printf("デバイスが見つかりませんでした。\n");
	} else {
		Bus=pciGetBus(l >> 16);		/* PCIデバイスアドレス→PCIバス番号変換 */
		Dev=pciGetDev(l >> 16);		/* PCIデバイスアドレス→デバイス番号変換 */
		Func=pciGetFunc(l >> 16);	/* PCIデバイスアドレス→ファンクション番号変換 */
		printf("Intel 440LX  Bus:%d Dev:%d Func:%d\n",Bus,Dev,Func);
	}

	printf("VGA互換デバイス(基本クラス:3 サブクラス:0 プログラムI/F:0) を探します。\n");
	l=_pciFindPciClass(3,0,0,0);	/* クラスコード デバイス検索 */
	if ((l & 0xFFFF)!= 0) {
		printf("デバイスが見つかりませんでした。\n");
	} else {
		Bus=pciGetBus(l >> 16);		/* PCIデバイスアドレス→PCIバス番号変換 */
		Dev=pciGetDev(l >> 16);		/* PCIデバイスアドレス→デバイス番号変換 */
		Func=pciGetFunc(l >> 16);	/* PCIデバイスアドレス→ファンクション番号変換 */
		printf("VGA互換デバイス     Bus:%d Dev:%d Func:%d\n",Bus,Dev,Func);
		/* PCIバス番号/デバイス番号/ファンクション番号→PCIデバイスアドレス */
		i=pciBusDevFunc(Bus,Dev,Func);
		/* コンフィギュレーションレジスタ00h ワード読み出し */
		printf("ベンダID   %04x\n",_pciConfigReadWord(i,0x00));
		/* PCIバス番号/デバイス番号/ファンクション番号→PCIデバイスアドレス */
		i=pciBusDevFunc(Bus,Dev,Func);
		/* コンフィギュレーションレジスタ02h ワード読み出し */
		printf("デバイスID %04x\n",_pciConfigReadWord(i,0x02));

		for(j=0;j<6;j++){
			/* PCIバス番号/デバイス番号/ファンクション番号→PCIデバイスアドレス */
			i=pciBusDevFunc(Bus,Dev,Func);
			/* コンフィグレーションレジスタ10～24h ロングワード読み出し */
			l=_pciConfigReadLong(i,j*4+0x10);
			printf("ベースアドレスレジスタ%d: %08lx\n",j,l);
		}
	}
}
