/******************************************************************************
	ISA Base Board  各レジスタ初期化
******************************************************************************/

#include	"TYPEDEF.H"
#include	"ISABASE.H"

/* ISA Base Board イネーブル
   戻り値  0:イネーブル成功  -1:イネーブル失敗
*/
int ISABase_Init(void)
{
	int i;
	for(i=0;i<4;i++){
		*BridgeEnable=0x4949;	/* ブリッジイネーブルシグネチャ */
	}
	if (*Verison != 0x0100) return -1;	/* ブリッジイネーブルエラー */

	/* 各種インターフェースコントローラを割り込み未使用状態にする */
	*ATAIntLvl=0;
	*ATAIntMsk=0;
	*USBIntLvl=0;
	*USBIntMsk=0;
	*ISAIntLvl=0;
	*ISAIntMsk=0;
	*PC0IntLvl=0;
	*PC0IntMsk=0;
	*PC1IntLvl=0;
	*PC1IntMsk=0;

	return 0;	/* ブリッジイネーブル成功 */
}

/* ATAコントローラ初期化 */
void ATA_Init(void)
{
	int i;
	*ATAIntLvl=0;	/* 割り込みIRLレベル 0 */
	*ATAIntMsk=0;	/* 割り込み禁止 */
	for(i=0;i<10000;i++){
		*ATACtrl=0x0000;	/* ATAリセット */
	}
	for(i=0;i<10000;i++){
		*ATACtrl=0x8000;	/* ATAリセット解除 */
	}
}

/* USBコントローラ初期化 */
void USB_Init(void)
{
	int i;
	*USBIntLvl=0;	/* 割り込みIRLレベル 0 */
	*USBIntMsk=0;	/* 割り込み禁止 */
	for(i=0;i<10000;i++){
		*ATACtrl=0x0000;	/* USBリセット */
	}
	for(i=0;i<10000;i++){
		*ATACtrl=0x8000;	/* USBリセット解除 */
	}
}
/* 注意：ATAとUSBのハードウェアリセット端子は兼用ピン */

/* ISAバスコントローラ初期化 */
void ISABus_Init(void)
{
	int i;
	*ISAIntLvl=0;	/* 割り込みIRLレベル 0 */
	*ISAIntMsk=0;	/* 割り込み禁止 */
	for(i=0;i<10000;i++){
		*ISACtrl=0x0000;	/* ISAバスリセット */
	}
	for(i=0;i<10000;i++){
		*ISACtrl=0x8000;	/* ISAバスリセット解除 */
	}
}

/* PCソケット0コントローラ初期化(ディセーブル状態) */
void PC0_Init(void)
{
	int i;
	*PC0IntLvl=0;	/* 割り込みIRLレベル 0 */
	*PC0IntMsk=0;	/* 割り込み禁止 */
	for(i=0;i<10000;i++){
		*PC0Ctrl=0xE000;	/* バスバッファディセーブル/電源OFF/リセット */
	}
}

/* PCソケット1コントローラ初期化(ディセーブル状態) */
void PC1_Init(void)
{
	int i;
	*PC1IntLvl=0;	/* 割り込みIRLレベル 0 */
	*PC1IntMsk=0;	/* 割り込み禁止 */
	for(i=0;i<10000;i++){
		*PC1Ctrl=0xE000;	/* バスバッファディセーブル/電源OFF/リセット */
	}
}

/* ATA割り込みコントローラ初期化
   引き数  割り込みレベル:IRLlvl   1～15
*/
void ATAInt_Init(int IRLlvl)
{
	*ATAIntSts=0xFFFF;	/* 全割り込み要求クリア */
	*ATAIntMsk=0;		/* 割り込み禁止 */
	*ATAIntLvl=(UWORD)IRLlvl;	/* ATA 割り込みIRLレベル設定 */
}

/* USB割り込みコントローラ初期化
   引き数  割り込みレベル:IRLlvl   1～15
*/
void USBInt_Init(int IRLlvl)
{
	*USBIntSts=0xFFFF;	/* 全割り込み要求クリア */
	*USBIntMsk=0;		/* 割り込み禁止 */
	*USBIntLvl=(UWORD)IRLlvl;	/* USB 割り込みIRLレベル設定 */
}

/* ISAバス割り込みコントローラ初期化
   引き数  割り込みレベル:IRLlvl   1～15
*/
void ISAInt_Init(int IRLlvl)
{
	*ISAIntSts=0xFFFF;	/* 全割り込み要求クリア */
	*ISAIntMsk=0;		/* 割り込み禁止 */
	*ISAIntLvl=(UWORD)IRLlvl;	/* ISAバス 割り込みIRLレベル設定 */
}

/* PCカードソケット0 割り込みコントローラ初期化
   引き数  割り込みレベル:IRLlvl   1～15
*/
void PC0Int_Init(int IRLlvl)
{
	*PC0IntSts=0xFFFF;	/* 全割り込み要求クリア */
	*PC0IntMsk=0;		/* 割り込み禁止 */
	*PC0IntLvl=(UWORD)IRLlvl;	/* PCカードソケット0 割り込みIRLレベル設定 */
}

/* PCカードソケット1 割り込みコントローラ初期化
   引き数  割り込みレベル:IRLlvl   1～15
*/
void PC1Int_Init(int IRLlvl)
{
	*PC1IntSts=0xFFFF;	/* 全割り込み要求クリア */
	*PC1IntMsk=0;		/* 割り込み禁止 */
	*PC1IntLvl=(UWORD)IRLlvl;	/* PCカードソケット1 割り込みIRLレベル設定 */
}

/* ATA割り込みマスク制御
   引き数：0:割り込み禁止  1:許可
*/
void ATAInt_Mask(int IntMsk)
{
	*ATAIntMsk=(UWORD)IntMsk;
}

/* USB割り込みマスク制御
   引き数：0:割り込み禁止  1:許可
*/
void USBInt_Mask(int IntMsk)
{
	*USBIntMsk=(UWORD)IntMsk;
}

/* ISAバス割り込みマスク制御
   引き数  IRQ番号:IRQ  3:IRQ3 ～ 15:IRQ15
           割り込み制御:IntMsk  0:割り込み禁止 1:許可
*/
void ISAInt_Mask(int IRQ, int IntMsk)
{
	if (IntMsk == 1) {	/* 割り込み許可 */
		*ISAIntMsk=*ISAIntMsk|(1<<IRQ);
	} else {			/* 割り込み禁止 */
		*ISAIntMsk=*ISAIntMsk&((1<<IRQ)^0xFFFF);
	}
}

/*  PCカードソケット0 割り込みマスク制御
   引き数  割り込み要因:IntNo 1:カード挿抜割り込み/2:状態変化割り込み/4:カードリソース割り込み
           割り込み制御:IntMsk  0:割り込み禁止 1:許可
*/
void PC0Int_Mask(int IntNo, int IntMsk)
{
	if (IntMsk == 1) {	/* 割り込み許可 */
		*PC0IntMsk=*PC0IntMsk|IntNo;
	} else {			/* 割り込み禁止 */
		*PC0IntMsk=*PC0IntMsk&(IntNo^0xFFFF);
	}
}

/*  PCカードソケット1 割り込みマスク制御
   引き数  割り込み要因:IntNo 1:カード挿抜割り込み/2:状態変化割り込み/4:カードリソース割り込み
           割り込み制御:IntMsk  0:割り込み禁止 1:許可
*/
void PC1Int_Mask(int IntNo, int IntMsk)
{
	if (IntMsk == 1) {	/* 割り込み許可 */
		*PC1IntMsk=*PC1IntMsk|IntNo;
	} else {			/* 割り込み禁止 */
		*PC1IntMsk=*PC1IntMsk&(IntNo^0xFFFF);
	}
}
