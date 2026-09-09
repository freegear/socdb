/***********************************************************
	ATA(IDE)/ATAPI デバイス初期化/情報表示ツール Ver 1.0
		for CQ RISC評価キット/SH-4
************************************************************/

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
	UDWORD Maxlba;
	UWORD Info_Buffer[256];

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

	printf("\nATA/ATAPI Device Infomation tool Ver.1.0\n");
	printf("Hardware Reset Waiting ....");
	for(i=0;i<50;i++){	/* ハードウェアリセットからの起動が遅いデバイスがいるため */
		ide_ata_wait(ATA_WAIT100ms);	/* 数十秒のウェイト */
	}
	printf("\n");

	device=0;	/* デバイス番号0 or 1 */
	mode=1;		/* デバイスインフォメーション表示フラグ */
//	mode=2;		/* メディアイジェクト指定 */
//	mode=3;		/* トレイクローズ指定 */
//	mode=4;		/* ロック指定 */
//	mode=5;		/* アンロック指定 */

	/* デバイス初期化 */
	printf("\nDevice initialize ... ");
	i=IDE_Initialize_Device();	/* デバイス初期化 */
	if (i!=0) {
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



  for(;;){

	/* ATA/ATAPIデバイス以外はこれ以上実行しない */
	device=0;	/* デバイス0で実行 */
	device_type=IDE_Get_Device_Type(device);
	if (device_type==DEVICE_NON) {
		printf("\nDevice %d : non device\n",device);
		goto jump1;
	}
	if (device_type&DEVICE_UNKOWN) {
		printf("\nDevice %d : unkown device\n",device);
		goto jump1;
	}

	/* アクセスレディチェック(デバイス初期化/割り込み初期化後に1回実行) */
	i=IDE_Media_AccessReady(device,MEDIA_ReadAccess);

	/* デバイス情報取得 */
	printf("\n");
	printf("\nDevice %d : ",device);
	switch(mode) {

		case 1:	/* デバイスインフォメーション表示 */
			/* デバイス情報表示 */
			printf("IDENTIFY Information ... \n");
			IDE_Get_Identify_Infomation(device,Info_Buffer);
			IDE_Print_Device_Info(device,device_type,Info_Buffer);
			/* 転送モード表示 */
			printf("\nTransfer mode\n PIO mode = %d\n",IDE_Get_PIO_Mode());
			i=IDE_Get_DMA_Mode();
			if (i>=0) printf(" Multi Word DMA mode = %d\n",i);
			if (device_type&DEVICE_REMOV) {	/*  リムーバブルデバイス */
				/* メディア情報表示 */
				printf("\nDevice %d : Device/Media Information ...\n",device);
				i=IDE_Media_AccessReady(device,MEDIA_ReadAccess);
				if (i==MEDIA_Ready) {	/* レディ状態 */
					i=IDE_Get_Media_Infomation(device, &Maxlba, &SectorSize);
					if (i==0) {	/* 正常取得完了 */
						printf(" Device/Media Max LBA = %lu\n",Maxlba);
						printf(" Device/Media Byte/Sector = %Xh bytes\n",SectorSize);
						printf(" Access Ready!!\n");
					} else {
						printf(" Media Infomation Get Error\n");
					}
				} else {
					IDE_Print_AccessError(i,device_type);
				}
			}
			break;

		case 2:	/* メディアイジェクト指定 */
			printf("Media Eject ... ");	/* メディアイジェクト */
			if (device_type&DEVICE_REMOV) {	/*  リムーバブルデバイス */
				i=IDE_Media_Eject(device);
				if (i==0) {
					printf("OK!\n");
				} else {
					printf("NG! (error code=%d)\n",i);
				}
			} else {
				printf(" Not Removable media device!\n");
			}
			break;

		case 3:		/* トレイクローズ */
			printf("Media Tray Close ... ");
			if (device_type&DEVICE_REMOV) {	/*  リムーバブルデバイス */
				i=IDE_Media_TrayClose(device);	/* メディアトレイクローズ */
				if (i==0) {
					printf("OK!\n");
				} else {
					printf("NG! (error code=%d)\n",i);
				}
			} else {
				printf(" Not Removable media device!\n");
			}
			break;

		case 4:	/* ロック指定 */
			printf("Media Lock ... ");
			if (device_type&DEVICE_REMOV) {	/*  リムーバブルデバイス */
				i=IDE_Media_LockUnlock(device,MEDIA_Lock);	/* メディアロック設定 */
				if (i==0) {
					printf("OK!\n");
				} else {
					printf("NG! (error code=%d)\n",i);
				}
			} else {
				printf(" Not Removable media device!\n");
			}
			break;

		case 5:	/* アンロック指定 */
			printf("Media Unlock ... ");
			if (device_type&DEVICE_REMOV) {	/*  リムーバブルデバイス */
				i=IDE_Media_LockUnlock(device,MEDIA_UnLock);	/* アンロック設定 */
				if (i==0) {
					printf("OK!\n");
				} else {
					printf("NG! (error code=%d)\n",i);
				}
			} else {
				printf(" Not Removable media device!\n");
			}
			break;

	}


jump1:
	/* ATA/ATAPIデバイス以外はこれ以上実行しない */
	device=1;	/* デバイス1で実行 */
	device_type=IDE_Get_Device_Type(device);
	if (device_type==DEVICE_NON) {
		printf("\nDevice %d : non device\n",device);
		goto jump2;
	}
	if (device_type&DEVICE_UNKOWN) {
		printf("\nDevice %d : unkown device\n",device);
		goto jump2;
	}

	/* アクセスレディチェック(デバイス初期化/割り込み初期化後に1回実行) */
	i=IDE_Media_AccessReady(device,MEDIA_ReadAccess);

	/* デバイス情報取得 */
	printf("\n");
	printf("\nDevice %d : ",device);
	switch(mode) {

		case 1:	/* デバイスインフォメーション表示 */
			/* デバイス情報表示 */
			printf("IDENTIFY Information ... \n");
			IDE_Get_Identify_Infomation(device,Info_Buffer);
			IDE_Print_Device_Info(device,device_type,Info_Buffer);
			/* 転送モード表示 */
			printf("\nTransfer mode\n PIO mode = %d\n",IDE_Get_PIO_Mode());
			i=IDE_Get_DMA_Mode();
			if (i>=0) printf(" Multi Word DMA mode = %d\n",i);
			if (device_type&DEVICE_REMOV) {	/*  リムーバブルデバイス */
				/* メディア情報表示 */
				printf("\nDevice %d : Device/Media Information ...\n",device);
				i=IDE_Media_AccessReady(device,MEDIA_ReadAccess);
				if (i==MEDIA_Ready) {	/* レディ状態 */
					i=IDE_Get_Media_Infomation(device, &Maxlba, &SectorSize);
					if (i==0) {	/* 正常取得完了 */
						printf(" Device/Media Max LBA = %lu\n",Maxlba);
						printf(" Device/Media Byte/Sector = %Xh bytes\n",SectorSize);
						printf(" Access Ready!!\n");
					} else {
						printf(" Media Infomation Get Error\n");
					}
				} else {
					IDE_Print_AccessError(i,device_type);
				}
			}
			break;

		case 2:	/* メディアイジェクト指定 */
			printf("Media Eject ... ");	/* メディアイジェクト */
			if (device_type&DEVICE_REMOV) {	/*  リムーバブルデバイス */
				i=IDE_Media_Eject(device);
				if (i==0) {
					printf("OK!\n");
				} else {
					printf("NG! (error code=%d)\n",i);
				}
			} else {
				printf(" Not Removable media device!\n");
			}
			break;

		case 3:		/* トレイクローズ */
			printf("Media Tray Close ... ");
			if (device_type&DEVICE_REMOV) {	/*  リムーバブルデバイス */
				i=IDE_Media_TrayClose(device);	/* メディアトレイクローズ */
				if (i==0) {
					printf("OK!\n");
				} else {
					printf("NG! (error code=%d)\n",i);
				}
			} else {
				printf(" Not Removable media device!\n");
			}
			break;

		case 4:	/* ロック指定 */
			printf("Media Lock ... ");
			if (device_type&DEVICE_REMOV) {	/*  リムーバブルデバイス */
				i=IDE_Media_LockUnlock(device,MEDIA_Lock);	/* メディアロック設定 */
				if (i==0) {
					printf("OK!\n");
				} else {
					printf("NG! (error code=%d)\n",i);
				}
			} else {
				printf(" Not Removable media device!\n");
			}
			break;

		case 5:	/* アンロック指定 */
			printf("Media Unlock ... ");
			if (device_type&DEVICE_REMOV) {	/*  リムーバブルデバイス */
				i=IDE_Media_LockUnlock(device,MEDIA_UnLock);	/* アンロック設定 */
				if (i==0) {
					printf("OK!\n");
				} else {
					printf("NG! (error code=%d)\n",i);
				}
			} else {
				printf(" Not Removable media device!\n");
			}
			break;

	}


jump2:
	printf("\n\nwaiting ....");
	for(i=0;i<20;i++){
		ide_ata_wait(ATA_WAIT100ms);		/* 100msウェイト */
	}
	mode++;
	if (mode>5) mode=1;
	printf("\n");

  }


  return 0;
}
