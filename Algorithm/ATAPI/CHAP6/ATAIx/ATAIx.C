/***********************************************************
	ATA(IDE)/ATAPI デバイス初期化/情報表示ツール Ver 1.1
		for PC/AT互換機
************************************************************/

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

int main(int argc, char *argv[])
{
	int i,mode,device,device_type,SectorSize;
	UDWORD Maxlba;
	UWORD Info_Buffer[256];
#ifdef USE_INTERRUPT
	unsigned long originalVector; /* 元の割り込みベクタ保存変数 */
	unsigned int originalIrqMask; /* 元の割り込みマスク状態保存変数 */
#endif

	printf("\nATA/ATAPI Device Infomation tool Ver.1.1\n");

	/* コマンドラインオプション指定チェック */
	mode=0;
	if (argc>=2) {	/* デバイスインフォメーション表示 */
		device=atoi(argv[1]);	/* デバイス番号 */
		mode=1;	/* デバイスインフォメーション表示フラグ */
	}
	if (argc==3) {	/* 読み込みLBA指定パラメータ */
		if ((*argv[2] == 'E')||(*argv[2] == 'e')) {
			mode=2;	/* メディアイジェクト指定 */
		} else if ((*argv[2] == 'T')||(*argv[2] == 't')) {
			mode=3;	/* トレイクローズ指定 */
		} else if ((*argv[2] == 'L')||(*argv[2] == 'l')) {
			mode=4;	/* ロック指定 */
		} else if ((*argv[2] == 'U')||(*argv[2] == 'u')) {
			mode=5;	/* アンロック指定 */
		}
	}
	/* 使い方簡易表示 */
	if ((argc<2)||(argc>3)||(*argv[1]<'0')||(*argv[1]>'1')||(mode==0)) {
		printf("\n >ATAIx device [E|L|U|T]\n");
		printf("  device .. 0:device0  1:device1\n");
		printf("  E  ...... Removable media Eject\n");
		printf("  L  ...... Removable media Lock\n");
		printf("  U  ...... Removable media Unlock\n");
		printf("  T  ...... Removable media Tray close\n");
		return 0;
	}

	/* デバイス初期化 */
	printf("\nDevice initialize ... ");
	i=IDE_Initialize_Device();	/* デバイス初期化 */
	if (i!=0) {
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

	/* アクセスレディチェック(デバイス初期化/割り込み初期化後に1回実行) */
	i=IDE_Media_AccessReady(device,MEDIA_ReadAccess);

	/* デバイス情報取得 */
	printf("\nDevice %d : ",device);
	switch(mode) {

		case 1:	/* デバイスインフォメーション表示 */
			/* デバイス情報表示 */
			printf("IDENTIFY Information ... \n");
			IDE_Get_Identify_Infomation(device,Info_Buffer);
			IDE_Print_Device_Info(device,device_type,Info_Buffer);
			printf("\n");
			IDE_Print_BIOS_Info(device,device_type,Info_Buffer);
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
					printf("NG! (errcode=%04Xh[%d])\n",i,i);
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
					printf("NG! (errcode=%04Xh[%d])\n",i,i);
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
					printf("NG! (errcode=%04Xh[%d])\n",i,i);
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
					printf("NG! (errcode=%04Xh[%d])\n",i,i);
				}
			} else {
				printf(" Not Removable media device!\n");
			}
			break;

	}

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
