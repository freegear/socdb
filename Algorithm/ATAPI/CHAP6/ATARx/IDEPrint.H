/*******************************************************
	デバイス情報表示/ダンプ表示関数ヘッダファイル
*******************************************************/

/* IDENTIFY情報表示 */
void IDE_Print_Device_Info(int, int, UWORD *);

/* ATA/ATAPIデバイス制御BIOSのデバイス判定表示 */
void IDE_Print_BIOS_Info(int, int, UWORD *);

/* IDEコマンドエラー内容表示 */
void IDE_Print_CommandError(int, int);

/* IDEディスクアクセスエラー内容表示 */
void IDE_Print_AccessError(int, int);

/* 16進数ダンプ表示 */
void Buffer_Dump(void *, int);
