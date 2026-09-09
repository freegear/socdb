/*******************************************************
	ATA(IDE)/ATAPI セクタリード表示ツール Ver 1.0
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
	int i,device,device_type,SectorSize;
	UDWORD l,lba,lba0,lba1,count,Maxlba;
	UBYTE *buff;
	char c;
	struct STRUCT_TOC toc;

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

	printf("\n\nATA/ATAPI Device Sector Read tool Ver.1.0\n");
	printf("Hardware Reset Waiting ....");
	for(i=0;i<50;i++){	/* ハードウェアリセットからの起動が遅いデバイスがいるため */
		ide_ata_wait(ATA_WAIT100ms);	/* 数十秒のウェイト */
	}
	printf("\n");

	/* デバイス初期化 */
	printf("\nDevice initialize ... ");
	i=IDE_Initialize_Device();		/* デバイス初期化 */
	if (i<0) {
		printf("initialize device mode error!!(errcode=%d)\n",i);
		return -1;
	} else {
		printf("success\n");
	}

	in_byte(ATA_STR);	/* ステータスリード */
	ATAInt_Mask(1);		/* ATA割り込み許可 */
	SystemTimer_Init(15);	/* タイマー割り込み初期化(割り込みレベル15) */
	CPUInt_Init(7);		/* 割り込みベクタ初期化 */
	CPUInt_Mask(1);		/* CPU割り込み許可 */

	/* バッファメモリ確保 */
	buff=malloc(16*1024);
	if (buff==NULL) {
		printf("buffer malloc error!!\n");
		goto quit1;
	}


  for(lba=0;lba<0x10000;lba=lba+16){	/* 16セクタづつ表示 */

	device=0;	/* デバイス番号0 */
	count=16;	/* 16セクタ */
	lba0=lba;	/* 読み出し開始LBA */

	/* ATA/ATAPIデバイス以外は実行しない */
	device_type=IDE_Get_Device_Type(device);
	if (device_type==DEVICE_NON) {
		printf("\nDevice %d : non device\n",device);
		goto quit1;
	}
	if (device_type&DEVICE_UNKOWN) {
		printf("\nDevice %d : unkown device\n",device);
		goto quit1;
	}

	/* アクセスレディ状態確認 */
	printf("\nDevice 0 Sector Read & Dump .... ");
	i=IDE_Media_AccessReady(device,MEDIA_ReadAccess);
	if (i!=MEDIA_Ready) {	/* レディ状態 */
		IDE_Print_AccessError(i,device_type);
		goto quit1;
	}
	/* 最大LBA/セクタサイズ情報取得 */
	i=IDE_Get_Media_Infomation(device,&Maxlba,&SectorSize);
	if (i!=0) {		/* エラー発生時 */
		IDE_Print_CommandError(i,device_type);
		goto quit1;
	}
	printf("Ready!!\n");
	/* 指定LBAが範囲内か? */
	if (lba0>Maxlba) {
		printf("Max LBA over!!\n");
		goto quit1;
	}
	/* デバイスがCD-ROMドライブの場合はディスクがCD-ROMかどうか確認 */
	if (device_type&DEVICE_CDROM) {
		i=IDE_atapi_read_toc(device,1/*MSF*/,0,0,804,&toc);
		if (i!=0) {
			IDE_Print_CommandError(i,device_type);
			goto quit1;
		}
		/* データトラック以外ならCD-ROMではない */
		if (((toc.point[0].adr_ctl&0xf0)!=0x10)||((toc.point[0].adr_ctl&4)==0)) {
			printf("\nNot CD-ROM Disk\n");
			goto quit1;
		}
	}

	/* セクタダンプ */
	for(l=1;l<=count;l++){
		if (lba0>Maxlba) {
			printf("Max LBA over!!\n");
			break;
		}
		printf("\nLBA=%u read sector ... ",lba0);
		i=IDE_Read_Sector(device,lba0,1,buff);
		if (i!=0) {		/* エラー発生時 */
			IDE_Print_AccessError(i,device_type);
			printf("\nHit Any Key ('E'...end) ... ");
			c=getch();
			if ((c=='e')||(c=='E')) break;	/* 終了 */
			printf("\n");
			l=l-1;	/* もう一度リトライ */
		} else {		/* セクタデータ正常読み出し時 */
			printf("\n");
			if (device_type&DEVICE_CDROM) {	/* CD-ROMデバイスのとき */
				SectorSize=2048;	/* CD-ROM時は2Kバイト固定 */
			}
			Buffer_Dump(buff,SectorSize);	/* セクタサイズだけダンプ */
			lba0++;	/* 次のセクタ */
		}
	}

quit1:
	device=1;	/* デバイス番号1 */
	count=16;	/* 16セクタ */
	lba1=lba;	/* 読み出し開始LBA */

	/* ATA/ATAPIデバイス以外は実行しない */
	device_type=IDE_Get_Device_Type(device);
	if (device_type==DEVICE_NON) {
		printf("\nDevice %d : non device\n",device);
		goto quit2;
	}
	if (device_type&DEVICE_UNKOWN) {
		printf("\nDevice %d : unkown device\n",device);
		goto quit2;
	}

	/* アクセスレディ状態確認 */
	printf("\nDevice 1 Sector Read & Dump .... ");
	i=IDE_Media_AccessReady(device,MEDIA_ReadAccess);
	if (i!=MEDIA_Ready) {	/* レディ状態 */
		IDE_Print_AccessError(i,device_type);
		goto quit2;
	}
	/* 最大LBA/セクタサイズ情報取得 */
	i=IDE_Get_Media_Infomation(device,&Maxlba,&SectorSize);
	if (i!=0) {		/* エラー発生時 */
		IDE_Print_CommandError(i,device_type);
		goto quit2;
	}
	printf("Ready!!\n");
	/* 指定LBAが範囲内か? */
	if (lba1>Maxlba) {
		printf("Max LBA over!!\n");
		goto quit2;
	}
	/* デバイスがCD-ROMドライブの場合はディスクがCD-ROMかどうか確認 */
	if (device_type&DEVICE_CDROM) {
		i=IDE_atapi_read_toc(device,1/*MSF*/,0,0,804,&toc);
		if (i!=0) {
			IDE_Print_CommandError(i,device_type);
			goto quit2;
		}
		/* データトラック以外ならCD-ROMではない */
		if (((toc.point[0].adr_ctl&0xf0)!=0x10)||((toc.point[0].adr_ctl&4)==0)) {
			printf("\nNot CD-ROM Disk\n");
			goto quit2;
		}
	}

	/* セクタダンプ */
	for(l=1;l<=count;l++){
		if (lba1>Maxlba) {
			printf("Max LBA over!!\n");
			break;
		}
		printf("\nLBA=%u read sector ... ",lba1);
		i=IDE_Read_Sector(device,lba1,1,buff);
		if (i!=0) {		/* エラー発生時 */
			IDE_Print_AccessError(i,device_type);
			printf("\nHit Any Key ('E'...end) ... ");
			c=getch();
			if ((c=='e')||(c=='E')) break;	/* 終了 */
			printf("\n");
			l=l-1;	/* もう一度リトライ */
		} else {		/* セクタデータ正常読み出し時 */
			printf("\n");
			if (device_type&DEVICE_CDROM) {	/* CD-ROMデバイスのとき */
				SectorSize=2048;	/* CD-ROM時は2Kバイト固定 */
			}
			Buffer_Dump(buff,SectorSize);	/* セクタサイズだけダンプ */
			lba1++;	/* 次のセクタ */
		}
	}


quit2:
	printf("\n\nwaiting ....");
	for(i=0;i<20;i++){
		ide_ata_wait(ATA_WAIT100ms);		/* 100msウェイト */
	}
	printf("\n");

  }

  return 0;
}

