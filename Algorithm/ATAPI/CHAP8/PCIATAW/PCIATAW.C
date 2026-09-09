/*******************************************************
	ATA(IDE)/ATAPI セクタライトツール Ver 1.1
		for PCI ATAホストインターフェース用
********************************************************/

#include <conio.h>
#include <stdio.h>
#include <stdlib.h>
#include "typedef.h"
#include "iodef.h"
#include "ide_bios.h"
#include "ideprint.h"

#ifdef USE_INTERRUPT
	#include "Irqfunc.h"	/* PC/AT互換機割り込み制御ライブラリ */
#endif

#include "pcifunc.h"	/* PCI BIOSコールライブラリ */

int ATA_IRQ_NO;			/* PCI ATA用IRQ */
int BASE_ATA_REGS;		/* ATAレジスタベースアドレス */
int CTRL_BLK_ADDR;
int Bus;				/* バス番号 */
int Dev;				/* デバイス番号 */
int Func;				/* ファンクション番号 */

/* PCI環境チェック&PCIデバイス検索 */
int PCI_Init(void)
{
	int	Bus,Dev,Func;
	unsigned int	i;
	unsigned long	l;

	/* PCIバス環境確認 */
	i=_pciConfigVersion();
	l=_pciSigPCI();
	if ( ((i & 0xff00)!=0) || (l != 0x20494350) ) {
		printf("PCI BIOS not found\n");
		return -1;
	}
	i=_pciBusVersion();
	if (i < 0x200) {
		printf("PCI BIOS is old\n");
		return -1;
	}
	/* KEI-EVSP2 PCI ATAホストインターフェースデバイス検索 */
	printf("PCI device search ... VenderID 6809h  DeviceID 8117h\n");
	l=_pciFindPciDevice(0x6809,0x8117,0);
	if ((l & 0xFFFF)!= 0) {
		printf("PCI device not found\n");
		return -1;
	} else {
		Bus=pciGetBus(l >> 16);
		Dev=pciGetDev(l >> 16);
		Func=pciGetFunc(l >> 16);
		printf("PCIBus No:%d Device No:%d Function No:%d\n",Bus,Dev,Func);
		i=_pciConfigReadWord(pciBusDevFunc(Bus,Dev,Func),0x4);
		if ((i&1) == 0) {
				printf("I/O space diseable\n");
			return -1;
		}
	}
	/* ベースアドレスレジスタ0 */
	BASE_ATA_REGS=_pciConfigReadWord(pciBusDevFunc(Bus,Dev,Func),0x10) & 0xFFFC;
	printf("Base Address 0 : %l4Xh\n",BASE_ATA_REGS);
	CTRL_BLK_ADDR=BASE_ATA_REGS+0xE;
	/* IRQ取得 */
	ATA_IRQ_NO=(int)_pciConfigReadByte(pciBusDevFunc(Bus,Dev,Func),0x3c);
	printf("IRQ %d\n",ATA_IRQ_NO);
	return 0;
}

int main(int argc, char *argv[])
{
	int i,mode,device,device_type;
	UDWORD lba,Maxlba;
	UWORD data,SectorSize;
	UBYTE *buff;
	char c;
	char *ep;
#ifdef USE_INTERRUPT
	unsigned long originalVector; /* 元の割り込みベクタ保存変数 */
	unsigned int originalIrqMask; /* 元の割り込みマスク状態保存変数 */
#endif

	printf("\n\nATA/ATAPI Device Sector Write tool Ver.1.1 (PCI ATA)\n");

	/* コマンドラインオプション指定チェック */
	if ((argc<3)||(argc>4)||(*argv[1]<'0')||(*argv[1]>'1')) {
		printf("\n >PCIATAW device lba [data]\n");
		printf("  device .. 0:device0  1:device1\n");
		printf("  lba ..... LBA address\n");
		printf("  data .... write data\n");
		return 0;
	}
	device=atoi(argv[1]);	/* デバイス番号 */
	lba=atol(argv[2]);		/* ライトLBA */
	if (argc==3) {
		mode=1;	/* 書き込みデータ指定省略時はインクリメンタルデータ書き込み */
	}
	if (argc==4) {
		mode=0;	/* 書き込みデータ指定 */
		data=strtoul(argv[3],&ep,16);	/* 16進数変換 */
	}

	/* PCIデバイス検索&リソース取得 */
	if (PCI_Init() == -1) return -1;

	/* デバイス初期化 */
	printf("\nDevice initalize ... ");
	i=IDE_Initialize_Device();	/* デバイス初期化 */
	if (i<0) {
		printf("initialize device mode error!!(errcode=%04Xh[%d])\n",i,i);
		return -1;
	} else {
		printf("success\n");
	}

	/* ATA/ATAPIデバイス以外はこれ以上実行しない */
	device_type=IDE_Get_Device_Type(device);
	if (device_type==DEVICE_NON) {
		printf("\nDevice %d : non device\n",device);
		return -1;
	}
	if (device_type&DEVICE_UNKOWN) {
		printf("\nDevice %d : unkown device\n",device);
		return -1;
	}
	/* ATAデバイスかATAPIデバイスか表示 */
	if (device_type&DEVICE_ATA) {
		printf("\nDevice %d : ATA device\n",device);
	} else if (device_type&DEVICE_ATAPI) {
		printf("\nDevice %d : ATAPI device\n",device);
	}
	/* デバイスがCD-ROMドライブの場合は書き込み不可 */
	if (device_type&DEVICE_CDROM) {
		printf("\nDevice %d is CD-ROM device!!\n",device);
		return -1;
	}

#ifdef USE_INTERRUPT
	/* 割り込み設定など */
	/* 元の割り込みベクタ保存&割り込みマスク */
	originalIrqMask=_maskIRQ(ATA_IRQ_NO,1);
	/* 新割り込み処理関数設定 */
	originalVector=_hookIRQ(ATA_IRQ_NO,&IDE_atapi_packet_interrupt);
	/* ステータスリード */
	in_byte(ATA_STR);
	/* IRQn 割り込みマスク解除 */
	_maskIRQ(ATA_IRQ_NO,0);
#endif

	/* アクセスレディ状態確認 */
	printf("Sector Write .... ");
	i=IDE_Media_AccessReady(device,MEDIA_ReadAccess);
	if (i!=MEDIA_Ready) {	/* レディ状態 */
		IDE_Print_AccessError(i,device_type);
		goto quit;
	}
	/* 最大LBA/セクタサイズ情報取得 */
	i=IDE_Get_Media_Infomation(device,&Maxlba,&SectorSize);
	if (i!=0) {		/* エラー発生時 */
		IDE_Print_CommandError(i,device_type);
		goto quit;
	}
	printf("Ready!!\n");
	/* 指定LBAが範囲内か? */
	if (lba>Maxlba) {
		printf("Max LBA over!!\n");
		goto quit;
	}
	/* バッファメモリ確保 */
	buff=malloc(SectorSize);	/* セクタサイズ分だけバッファを確保 */
	if (buff==NULL) {
		printf("buffer malloc error!!\n");
		goto quit;
	}
	/* 書き込みデータ準備 */
	if (mode) {	/* インクリメンタルデータ */
		for(i=0;i<SectorSize;i=i+2){
			buff[i]=i&255;
			buff[i+1]=(i>>8)&255;
		}
	} else {	/* 書き込みデータ指定時 */
		for(i=0;i<SectorSize;i=i+2){
			buff[i]=data&255;
			buff[i+1]=(data>>8)&255;
		}
	}

	/* セクタライト */
	printf("\nLBA=%u write sector ... ",lba);
	while(1) {	/* エラーリトライのため */
		i=IDE_Write_Sector(device,lba,1,buff);
		if (i!=0) {		/* エラー発生時 */
			IDE_Print_AccessError(i,device_type);
			printf("\nHit Any Key ('E'...end) ... ");
			c=getch();
			if ((c=='e')||(c=='E')) break;	/* 終了 */
			printf("\n");
		} else {		/* セクタデータ正常読み出し時 */
			printf("success\n");
			break;		/* 書き込み終了 */
		}
	}

quit:
#ifdef USE_INTERRUPT
	/* IRQn 割り込みマスク /*
	_maskIRQ(ATA_IRQ_NO,1);
	/* 元の割り込みベクタ復帰 */
	_freeIRQ(ATA_IRQ_NO,originalVector);
	/* 元の割り込みマスク状態復帰 */
	_maskIRQ(ATA_IRQ_NO,originalIrqMask);
#endif

	return 0;
}
