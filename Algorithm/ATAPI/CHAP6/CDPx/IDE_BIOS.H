/***********************************************
	ATA(IDE)/ATAPI制御 BIOS ヘッダファイル
***********************************************/


/************/
/* 定数定義 */
/************/

/* デバイス選択 */
#define DEVICE0		0	/* マスタ */
#define DEVICE1		1	/* スレーブ */

/* デバイス種別定義 */
#define DEVICE_NON		0		/* 未接続 */
#define DEVICE_UNKOWN	0x8000	/* 不明デバイス */
#define DEVICE_ATA		0x4000	/* ATAデバイス */
#define DEVICE_ATAPI	0x2000	/* ATAPIデバイス */
#define DEVICE_REMOV	0x1000	/* リムーバブルフラグ */
#define DEVICE_PEJECT	0x0800	/* パワーイジェクト機能あり */
#define DEVICE_LOCK		0x0400	/* ロック/アンロック機能あり */
#define DEVICE_GETMeSt	0x0200	/* GET MEDIA STATUSコマンドサポート */
#define DEVICE_HDD		1		/* HDD */
#define DEVICE_CDROM	2		/* CD-ROMドライブ */
#define DEVICE_MO		4		/* 3.5インチMO */
#define DEVICE_LS		8		/* SuperDisk LS-120/240 */
#define DEVICE_ZIP		0x10	/* ZIP100/250 */
#define DEVICE_CFA		0x20	/* Compact Flash feature setサポート */

/* メディア状態定義 */
#define MEDIA_Ready		0	/* アクセスレディ状態 */
#define MEDIA_Wp		1	/* メディアがライトプロテクト状態である */
/* #define MEDIA_xxx	2	予約 */
#define MEDIA_NoDisk	4	/* メディアがない */
#define MEDIA_Chg		8	/* メディアがチェンジされた */
#define MEDIA_ChgReq	16	/* メディアチェンジが要求された */
/* #define MEDIA_xxx	32	予約 */
#define MEDIA_NotReady	64	/* ノットレディ状態 */
#define MEDIA_Error		128	/* 何らかのエラー */

/* リードアクセス/ライトアクセス */
#define MEDIA_ReadAccess	0
#define MEDIA_WriteAccess	1

/* メディアロック/アンロック */
#define MEDIA_Lock		1
#define MEDIA_UnLock	0

/* START/STOP UNIT(START)コマンドパラメータ */
#define ATAPI_START		1	/* ATAPIデバイススタート */
#define ATAPI_EJECT		2	/* イジェクト */
#define ATAPI_CLOSE		3	/* トレイクローズ */

/* SET FEATURESコマンド用サブコマンド */
#define SET_TRANSFER	0x03	/* Set Transfer Mode */
#define ENA_MEDIASTATUS	0x95	/* Enable Media Status Notification */
#define DIS_MEDIASTATUS	0x31	/* Disable Media Status Notification */


/* CDプレーヤ制御用 */
struct STRUCT_TOC_POINT {
	UBYTE dmy0; 		/* Reserved or Setion number */
	UBYTE adr_ctl;		/* Sub-Q Address and Control bit */
	UBYTE trk;			/* トラック番号 */
	UBYTE dmy1; 		/* Reserved */
	UBYTE dmy2; 		/* LBA[31:24] or Reserved */
	UBYTE mm;			/* LBA[23:16] or MM */
	UBYTE ss;			/* LBA[15:8]  or SS */
	UBYTE ff;			/* LBA[7:0]   or FF */
};

struct STRUCT_TOC {
	UWORD length; 		/* TOCの長さ */
	UBYTE first_trk;	/* 最初のトラック */
	UBYTE last_trk;		/* 最終トラック */
	struct STRUCT_TOC_POINT point[99];
};

/* 定数定義 */
#define RETRY_MAX		8	/* リトライ回数 */
#define ATA_WAIT400ns	1	/* 400nsウェイトループ回数 */
#define ATA_WAIT10us	25
#define ATA_WAIT5ms		12500
#define ATA_WAIT20ms	50000
#define ATA_WAIT100ms	250000



/*******************/
/* ATAコマンド発行 */
/*******************/

/* DEVICE RESETコマンド発行 */
int IDE_device_reset(int);

/* IDENTIFY DEVICE/IDENTIFY PACKET DEVICEコマンド発行 */
int IDE_identify_device(int, int, UWORD *);

/* EXECUTE DEVICE DIAGNOSTICコマンド発行 */
int IDE_execute_device_diagnostic(void);

/* IDLE/IDLE IMMEDIATEコマンド発行 */
int IDE_idle_device(int, int);

/* INITALIZE DEVICE PARAMATERSコマンド発行 */
int IDE_init_device_paramaters(int, UBYTE, UBYTE);

/* SET FEATURESコマンド発行 */
int IDE_set_features(int, UBYTE, UBYTE);

/* GET MEDIA STATUSコマンド発行 */
int IDE_get_media_status(int);

/* DOOR/MEDIA UNLOCKコマンド発行 */
int IDE_media_unlock(int);

/* DOOR/MEDIA LOCKコマンド発行 */
int IDE_media_lock(int);

/* MEDIA EJECTコマンド発行 */
int IDE_media_eject(int);

/* ATAリードセクタコマンド発行 */
int IDE_ata_read_sector(int, UDWORD, UWORD, void *);

/* ATAライトセクタコマンド発行 */
int IDE_ata_write_sector(int, UDWORD, UWORD, void *);


/*****************************/
/* ATAPIパケットコマンド発行 */
/*****************************/

#ifdef USE_INTERRUPT
/* ATAPI パケットコマンド実行完了処理(割り込み処理) */
void IDE_atapi_packet_interrupt(void);
#endif

/* TEST UNITコマンドパケット発行 */
int IDE_atapi_test_unit(int);

/* REQUEST SENSEコマンドパケット発行 */
int IDE_atapi_request_sense(int, void *);

/* START/STOP UNIT(START)コマンドパケット発行 */
int IDE_atapi_start_unit(int, UBYTE);

/* READ CAPACITYコマンドパケット発行 */
int IDE_atapi_read_capacity(int, void *);

/* INQUIRYコマンドパケット発行 */
int IDE_atapi_inquiry(int, UBYTE, void *);

/* READ(10)コマンドパケット発行 */
int IDE_atapi_read10(int, UDWORD, UWORD, void *);

/* WRITE(10)コマンドパケット発行 */
int IDE_atapi_write10(int, UDWORD, UWORD, void *);

/* PREVENT ALLOW MEDIAUM REMOVALコマンドパケット発行 */
int IDE_prevent_allow_mediaum_removal(int, int);

/* READ TOCコマンドパケット発行 */
int IDE_atapi_read_toc(int, int, UBYTE, UBYTE, UWORD, void *);

/* PLAY AUDIO MSFコマンドパケット発行 */
int IDE_atapi_play_audio_msf(int, UBYTE, UBYTE, UBYTE, UBYTE, UBYTE, UBYTE);

/* STOP PLAYBACKコマンドパケット発行 */
int IDE_atapi_stop_playback(int);

/* PAUSE/RESUMEコマンドパケット発行 */
int IDE_atapi_pause_resume(int, int);

/* READ SUBCHANNLコマンドパケット発行 */
int IDE_atapi_read_subchannel(int, int, int, UBYTE, UBYTE, UWORD, void *);



/************************************/
/* ATA/ATAPI デバイス初期化ルーチン */
/************************************/

/* デバイス接続確認 & デバイスモード初期化 */
int IDE_Initialize_Device(void);

/* デバイスタイプ取得 */
int IDE_Get_Device_Type(int);

/* デバイス詳細情報テーブル取得 */
void IDE_Get_Identify_Infomation(int, UWORD *);

/* 現在のPIO転送モードを取得 */
int IDE_Get_PIO_Mode(void);

/* 現在のDMA転送モードを取得 */
int IDE_Get_DMA_Mode(void);

/* デバイス/メディアのセクタあたりのバイト数と最大LBAの取得 */
int IDE_Get_Media_Infomation(int, UDWORD *, UWORD *);

/* ATAPIデバイスレディチェック */
UDWORD IDE_Get_Atapi_DeviceReady(int);

/* メディア状態チェック(即時コマンド発行) */
UDWORD IDE_Get_MediaStatus_Immediate(int);

/* メディア状態チェック(保存情報から返す) */
UDWORD IDE_Get_MediaStatus(int);

/* メディアアクセスレディ待ち(リトライ付き) */
int IDE_Media_AccessReady(int,int);

/* メディアロック設定/アンロック設定 */
int IDE_Media_LockUnlock(int, int);

/* メディアイジェクト */
int IDE_Media_Eject(int);

/* メディアトレイクローズ */
int IDE_Media_TrayClose(int);

/* 直前のATAPIコマンドで転送されたバイト数取得 */
UWORD IDE_Get_Atapi_TransferByte(void);

/* セクタリード(ATA/ATAPI兼用/リトライあり) */
int IDE_Read_Sector(int, UDWORD, UWORD, void *);

/* セクタライト(ATA/ATAPI兼用/リトライあり) */
int IDE_Write_Sector(int, UDWORD, UWORD, void *);
