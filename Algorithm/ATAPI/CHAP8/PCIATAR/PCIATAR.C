/*******************************************************
	ATA(IDE)/ATAPI セクタリード表示ツール Ver 1.1
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
	int i,device,device_type;
	UDWORD l,lba,count,Maxlba;
	UWORD SectorSize;
	UBYTE *buff;
	char c;
	struct STRUCT_TOC toc;
#ifdef USE_INTERRUPT
	unsigned long originalVector; /* 元の割り込みベクタ保存変数 */
	unsigned int originalIrqMask; /* 元の割り込みマスク状態保存変数 */
#endif

	printf("\n\nATA/ATAPI Device Sector Read tool Ver.1.1 (PCI ATA)\n");

	/* コマンドラインオプション指定チェック */
	if ((argc<3)||(argc>4)||(*argv[1]<'0')||(*argv[1]>'1')) {
		printf("\n >PCIATAR device lba [count]\n");
		printf("  device .. 0:device0  1:device1\n");
		printf("  lba ..... LBA address\n");
		printf("  count ... read secter count\n");
		return 0;
	}
	device=atoi(argv[1]);	/* デバイス番号 */
	lba=atol(argv[2]);		/* リードLBA */
	if (argc==3) {
		count=1;	/* 読み出しセクタ数指定省略時は1セクタ */
	}
	if (argc==4) {
		count=atoi(argv[3]);	/* 読み出しセクタ数 */
		if (count < 1) count=1;	/* セクタ数が1未満の時は1セクタのみ読み出し */
		if (count > 0x10000) count=0x10000;	/* 最大64Kセクタまで */
	}

	/* PCIデバイス検索&リソース取得 */
	if (PCI_Init() == -1) return -1;

	/* デバイス初期化 */
	printf("\nDevice initialize ... ");
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
	printf("Sector Read & Dump .... ");
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
	printf("Ready!! (SectorSize=%dbytes)\n",SectorSize);
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
	/* デバイスがCD-ROMドライブの場合はディスクがCD-ROMかどうか確認 */
	if (device_type&DEVICE_CDROM) {
		i=IDE_atapi_read_toc(device,1/*MSF*/,0,0,sizeof(toc)/*796*/,&toc);
		if (i!=0) {
			IDE_Print_CommandError(i,device_type);
			goto quit;
		}
		/* データトラック以外ならCD-ROMではない */
		if (((toc.point[0].adr_ctl&0xf0)!=0x10)||((toc.point[0].adr_ctl&4)==0)) {
			printf("\nNot CD-ROM Disk\n");
			goto quit;
		}
	}

	/* セクタダンプ */
	for(l=1;l<=count;l++){
		if (lba>Maxlba) {
			printf("Max LBA over!!\n");
			break;
		}
		printf("\nLBA=%u read sector ... ",lba);
		i=IDE_Read_Sector(device,lba,1,buff);
		if ((i!=-100)&&(i!=0)) {	/* エラー発生時 */
			IDE_Print_AccessError(i,device_type);
			printf("\nHit Any Key ('E'...end) ... ");
			c=getch();
			if ((c=='e')||(c=='E')) break;	/* 終了 */
			l=l-1;	/* もう一度リトライ */
		} else {		/* セクタデータ正常読み出し時 */
			printf("\n");
			if (i==-100) {	/* セクタサイズより実際に転送したデータが多い場合 */
				printf("Atapi_datatransfer=%dbytes\n",IDE_Get_Atapi_TransferByte());
			}
			if (device_type&DEVICE_CDROM) {	/* CD-ROMデバイスのとき */
				SectorSize=2048;	/* CD-ROM時は2Kバイト固定 */
			}
			Buffer_Dump(buff,SectorSize);	/* セクタサイズだけダンプ */
			lba++;	/* 次のセクタ */
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
