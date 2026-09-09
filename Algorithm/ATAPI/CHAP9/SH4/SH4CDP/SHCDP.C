/*******************************************
	CDプレーヤプログラム Ver 1.0
		for CQ RISC評価キット/SH-4
********************************************/

#include <stdio.h>
#include "typedef.h"
#include "sh4.h"
#include "cpu_int.h"
#include "isabase.h"
#include "iodef.h"
#include "ide_bios.h"
#include "ideprint.h"

int CDplay(int device, int tocprint)
{
	struct STRUCT_TOC toc;
	char c,read_buf[16];
	int l,i,m,s,mode,last_trak,track_chg;
	int current_trk,current_mm,current_ss,end_mm,end_ss,end_ff;
	int CDplay,CDpause;

	/* TOC読み出し */
	printf("Audio CD TOC Read ... ");
	i=IDE_atapi_read_toc(device,1/*MSF*/,0,0,804,&toc);
	if (i!=0) {
		printf("errorcode0=%d\n",i);
		return -1;
	} else {
		printf("success\n");
	}

	if (tocprint) {	/* TOCダンプ表示 */
		printf("\nTOC Dump!!\n");
		l=((toc.length>>8)&0xff)|((toc.length&0xff)<<8);
		Buffer_Dump(&toc,l+2);
		return 0;
	}

	/* 2ch CD-DA以外なら再生しない */
	if (((toc.point[0].adr_ctl&0xf0)!=0x10)||((toc.point[0].adr_ctl&0xc)!=0)) {
		printf("Not 2ch-Audio Disk!\n");
		return -1;
	}

	/* CDプレーヤ制御 */
	/* トラック情報表示 */
	last_trak=toc.last_trk;
	for(l=0;l<last_trak;l++){
		printf("Track %02d  %02dm %02ds %02df\n",toc.point[l].trk,toc.point[l].mm,toc.point[l].ss,toc.point[l].ff);
	}
	printf("Read OUT Time  %02dm %02ds %02df\n\n",toc.point[last_trak].mm,toc.point[last_trak].ss,toc.point[last_trak].ff);

	/* トラック1からリードOUTの直前まで再生開始 */
	end_mm=toc.point[last_trak].mm;
	end_ss=toc.point[last_trak].ss;
	end_ff=toc.point[last_trak].ff-1;	/* リードOUTの直前のフレームまで */
	if (end_ff<0) {	/* 負になったら一つ上の桁を-1 */
		end_ff=0;
		end_ss--;
		if (end_ss<0) {	/* 負になったら一つ上の桁を-1 */
			end_ss=0;
			end_mm--;
		}
	}
	printf("Start CD platyer %02dm %02ds %02df - %02dm %02ds %02df\n\n",toc.point[0].mm,toc.point[0].ss,toc.point[0].ff,end_mm,end_ss,end_ff);
	i=IDE_atapi_play_audio_msf(device,toc.point[0].mm,toc.point[0].ss,toc.point[0].ff,end_mm,end_ss,end_ff);

	/* メインループ */
	current_trk=current_mm=current_ss=-1;
	mode=0;
	CDpause=1;	/* 一時停止フラグ */
	CDplay=2;	/* CD再生中 */
	while(CDplay) {

		/* 現在の再生時間(位置)取得 */
		if (CDplay==2) {
			i=IDE_atapi_read_subchannel(device,1/*MSF*/,1/*SubQ*/,1/*CD*/,0,16,read_buf);
			if (i!=0) printf("errorcode1=%d\n",i);
			if (read_buf[6]>last_trak) {	/* 再生終了時間まできたら */
				printf("Play Stop\n");
				i=IDE_atapi_stop_playback(device);	/* CD再生停止 */
				if (i!=0) printf("errorcode2=%d\n",i);
				CDplay=1;	/* CD再生停止中 */
				current_trk=toc.point[0].trk;	/* 停止位置は先頭トラックにしておく */
			}
		}
		if (CDplay==2) {	/* CD再生中 */
			if (mode) {	/* CDの先頭からの時間 */
				if ((current_trk!=read_buf[6])||(current_mm!=read_buf[9])||(current_ss!=read_buf[10])) {
					l=read_buf[9]*60+read_buf[10];			/* 秒に変換 */
					i=toc.point[0].mm*60+toc.point[0].ss;	/* 秒に変換 */
					m=(l-i)/60;	/* 分に変換 */
					s=(l-i)%60;	/* あまり=秒 */
					printf("Track %02d  [ Absolute Time  %02dm %02ds ]\n",read_buf[6],m,s);
					current_mm=read_buf[9];	/* 現在の時間を保存 */
					current_ss=read_buf[10];
				}
			} else {	/* トラック時間 */
				if ((current_trk!=read_buf[6])||(current_mm!=read_buf[13])||(current_ss!=read_buf[14])) {
					if (current_trk!=read_buf[6]) track_chg=1;	/* トラックチェンジフラグ */
					if ((read_buf[13]==0)&&(read_buf[14]==0)) track_chg=0;	/* フラグクリア */
					if (track_chg) {	/* トラック間のギャップ再生中はマイナス表示 */
						printf("Track %02d  [ Track Time -%02dm %02ds ]\n",read_buf[6],read_buf[13],read_buf[14]);
					} else {			/* トラック再生中 */
						printf("Track %02d  [ Track Time  %02dm %02ds ]\n",read_buf[6],read_buf[13],read_buf[14]);
					}
					current_mm=read_buf[13];	/* 現在の時間を保存 */
					current_ss=read_buf[14];
				}
			}
			current_trk=read_buf[6];	/* 現在のトラック番号を保存 */
		}
	/*	if (kbhit()) {	キーバッファに文字があればキー入力取得 */
		if (0) {	/* exeGCCではキーバッファの状態は取得できないので操作不可 */
			c=toupper(getch());
			l=0;
			switch(c) {	/* CDプレーヤ再生制御 */
				case 'E':
					i=IDE_atapi_stop_playback(device);	/* CD再生停止 */
					if (i!=0) printf("errorcode3=%d\n",i);
					CDplay=0;	/* CDプレーヤ終了 */
					break;
				case 'T':	/* 時間表示モード変更 */
					mode=(mode+1)&1;
					break;
				case 'P':	/* 一時停止/復帰 */
					if (CDplay==2) {
						CDpause=(CDpause+1)&1;
						if (CDpause) printf("play\n");
						else printf("pause...");
						IDE_atapi_pause_resume(device,CDpause);	/* CD再生一時停止/解除 */
					}
					break;
				case 'S':	/* 停止状態からの再生 */
					if (CDplay==1) {
						l=-1;	/* トラック移動フラグ */
					}
					break;
				case 'R':	/* 前のトラックへ */
					if (CDplay==2) {
						if (current_trk>1) {	/* トラック1より前はない */
							track_chg=0;	/* トラック間のギャップは再生しないのでフラグクリア */
							current_mm=-1;
							current_trk--;
							l=-1;	/* トラック移動フラグ */
						}
					}
					break;
				case 'F':	/* 次のトラックへ */
					if (CDplay==2) {
						if (current_trk<last_trak) {	/* 最終トラックより後はない */
							track_chg=0;	/* トラック間のギャップは再生しないのでフラグクリア */
							current_mm=-1;
							current_trk++;
							l=-1;	/* トラック移動フラグ */
						}
					}
					break;
			}
			if (l==-1) {	/* 新トラックから再生 */
				printf("Next Track %d\n",current_trk);
				i=IDE_atapi_play_audio_msf(
					device,toc.point[current_trk-1].mm,toc.point[current_trk-1].ss,toc.point[current_trk-1].ff,
					end_mm,end_ss,end_ff);
				if (i!=0) printf("errorcode4=%d\n",i);
				CDplay=2;	/* CD再生中 */
			}
		}
	}
	return 0;
}

int main(int argc, char *argv[])
{
	int i,device,tocprint;

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

	printf("\n\nCD plyer Ver.1.0\n");
	printf("Hardware Reset Waiting ....");
	for(i=0;i<50;i++){	/* ハードウェアリセットからの起動が遅いデバイスがいるため */
		ide_ata_wait(ATA_WAIT100ms);	/* 数十秒のウェイト */
	}
	printf("\n");

	tocprint=0;	/* CD-DA再生 */
	device=-1;	/* デバイス自動検索 */

	/* デバイス初期化 */
	printf("\nDevice initialize ... ");
	i=IDE_Initialize_Device();	/* デバイス初期化 */
	if (i<0) {
		printf("initialize device mode error!!(errcode=%d)\n",i);
		return -1;
	} else {
		printf("success\n");
	}

	/* 指定ドライブタイプチェック */
	if ((device==0)&&(!(IDE_Get_Device_Type(DEVICE0)&DEVICE_CDROM))) {
		printf("device 0 ... not CD-ROM drive\n");
		return -1;
	}
	if ((device==1)&&(!(IDE_Get_Device_Type(DEVICE1)&DEVICE_CDROM))) {
		printf("device 1 ... not CD-ROM drive\n");
		return -1;
	}
	/* デバイス自動検索 */
	if (device==-1) {
		if (IDE_Get_Device_Type(DEVICE1)&DEVICE_CDROM) device=DEVICE1;	/* スレーブ */
		if (IDE_Get_Device_Type(DEVICE0)&DEVICE_CDROM) device=DEVICE0;	/* マスタ */
		if (device==-1) {
			printf("CD-ROM Device not found\n");
			return -1;
		}
	}

	in_byte(ATA_STR);	/* ステータスリード */
	ATAInt_Mask(1);		/* ATA割り込み許可 */
	SystemTimer_Init(15);	/* タイマー割り込み初期化(割り込みレベル15) */
	CPUInt_Init(7);		/* 割り込みベクタ初期化 */
	CPUInt_Mask(1);		/* CPU割り込み許可 */

	/* メディアアクセスレディ待ち */
	i=IDE_Media_AccessReady(device,MEDIA_ReadAccess);
	if (i!=MEDIA_Ready) {
		printf("Disk not ready\n");
		return -1;
	}

	i=CDplay(device,tocprint);

	return 0;
}
