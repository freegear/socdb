/*******************************************************
	ATA(IDE)/ATAPI セクタライトツール Ver 1.0
		for CQ RISC評価キット/SH-4
********************************************************/

#include <stdio.h>
#include "typedef.h"
#include "sh4.h"
#include "cpu_int.h"
#include "isabase.h"
#include "iodef.h"
#include "ide_bios.h"
#include "ideprint.h"

int main(int argc, char *argv[])
{
	int i,mode,device,device_type,SectorSize;
	UDWORD lba,Maxlba;
	UBYTE *buff;
	UWORD data;
	char c;
	char *ep;

	/* ISA Base Board初期化 */
	CPUBus_Init();	/* CPUバス初期化 */
	if (ISABase_Init() != 0) {	/* ブリッジコントローライネーブル */
		printf("ISA Base Board Enable Error\n");
		return -1;
	}
	if ((*IFBusBit & 1)!=1) {	/* ATAインターフェース機能があるか */
		printf("No ATA Interface\n");
		return -1;
	}
	ATA_Init();			/* ATA初期化 */
	ATAInt_Init(8);		/* ATA割り込みレベル8 */

	printf("\n\nATA/ATAPI Device Sector Write tool Ver.1.0\n");
	printf("Hardware Reset Waiting ....");
	for(i=0;i<50;i++){	/* ハードウェアリセットからの起動が遅いデバイスがいるため */
		ide_ata_wait(ATA_WAIT100ms);	/* 数十秒のウェイト */
	}
	printf("\n");

	device=0;	/* デバイス番号=0 */
	lba=0;		/* ライトLBA=0 */
	mode=1;		/* 書き込みデータ指定省略時はインクリメンタルデータ書き込み */

	/* デバイス初期化 */
	printf("\nDevice initalize ... ");
	i=IDE_Initialize_Device();	/* デバイス初期化 */
	if (i<0) {
		printf("initialize device mode error!!(errcode=%d)\n",i);
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
	/* デバイスがCD-ROMドライブの場合は書き込み不可 */
	if (device_type&DEVICE_CDROM) {
		printf("\nDevice %d : CD-ROM device!!\n",device);
		return -1;
	}

	in_byte(ATA_STR);	/* ステータスリード */
	ATAInt_Mask(1);		/* ATA割り込み許可 */
	SystemTimer_Init(15);	/* タイマー割り込み初期化(割り込みレベル15) */
	CPUInt_Init(7);		/* 割り込みベクタ初期化 */
	CPUInt_Mask(1);		/* CPU割り込み許可 */

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
	return 0;
}

