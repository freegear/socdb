/******************************************************************************
   ISA Base Board ブリッジコントローラレジスタ定義(SH-3用)
******************************************************************************/

#define BridgeEnable	(pUWORD)0xB4000000	/* ブリッジイネーブルレジスタ */
#define Verison			(pUWORD)0xB4000000	/* ブリッジコントローラバージョン */
#define IFBusBit		(pUWORD)0xB4000002	/* インターフェース実装ビット */

#define ATACtrl			(pUWORD)0xB4000018	/* ATA制御レジスタ */
#define ATAIntLvl		(pUWORD)0xB400001A	/* ATA割り込みレベル設定レジスタ */
#define ATAIntMsk		(pUWORD)0xB400001C	/* ATA割り込みマスクレジスタ */
#define ATAIntSts		(pUWORD)0xB400001E	/* ATA割り込みステータスレジスタ */

#define USBIntLvl		(pUWORD)0xB4000022	/* USB割り込みレベル設定レジスタ */
#define USBIntMsk		(pUWORD)0xB4000024	/* USB割り込みマスクレジスタ */
#define USBIntSts		(pUWORD)0xB4000026	/* USB割り込みステータスレジスタ */

#define ISACtrl			(pUWORD)0xB4000028	/* ISA制御レジスタ */
#define ISAIntLvl		(pUWORD)0xB400002A	/* ISA割り込みレベル設定レジスタ */
#define ISAIntMsk		(pUWORD)0xB400002C	/* ISA割り込みマスクレジスタ */
#define ISAIntSts		(pUWORD)0xB400002E	/* ISA割り込みステータスレジスタ */

#define PC0Ctrl			(pUWORD)0xB4000030	/* PC0制御レジスタ */
#define PC0IntLvl		(pUWORD)0xB4000032	/* PC0割り込みレベル設定レジスタ */
#define PC0IntMsk		(pUWORD)0xB4000034	/* PC0割り込みマスクレジスタ */
#define PC0IntSts		(pUWORD)0xB4000036	/* PC0割り込みステータスレジスタ */

#define PC1Ctrl			(pUWORD)0xB4000038	/* PC1制御レジスタ */
#define PC1IntLvl		(pUWORD)0xB400003A	/* PC1割り込みレベル設定レジスタ */
#define PC1IntMsk		(pUWORD)0xB400003C	/* PC1割り込みマスクレジスタ */
#define PC1IntSts		(pUWORD)0xB400003E	/* PC1割り込みステータスレジスタ */

#define ISAMemAdr		0xB5000000	/* ISAバス メモリ空間 */
#define ISAIoAdr		0xB4A00000	/* ISAバス I/O空間 */

#define PC0MemAdr		0xB6000000	/* PCソケット0 メモリ空間 */
#define PC1MemAdr		0xB7000000	/* PCソケット0 I/O空間 */

#define PC0IoAdr		0xB4C00000	/* PCソケット1 メモリ空間 */
#define PC1IoAdr		0xB4E00000	/* PCソケット1 I/O空間 */



/* ISA Base Board イネーブル */
int ISABase_Init(void);

/* ATAコントローラ初期化 */
void ATA_Init(void);

/* USBコントローラ初期化 */
void USB_Init(void);

/* ISAバスコントローラ初期化 */
void ISABus_Init(void);

/* PCソケット0コントローラ初期化(ディセーブル状態) */
void PC0_Init(void);

/* PCソケット1コントローラ初期化(ディセーブル状態) */
void PC1_Init(void);

/* ATA割り込みコントローラ初期化 */
void ATAInt_Init(int IRLlvl);

/* USB割り込みコントローラ初期化 */
void USBInt_Init(int IRLlvl);

/* ISAバス割り込みコントローラ初期化 */
void ISAInt_Init(int IRLlvl);

/* PCカードソケット0 割り込みコントローラ初期化 */
void PC0Int_Init(int IRLlvl);

/* PCカードソケット1 割り込みコントローラ初期化 */
void PC1Int_Init(int IRLlvl);

/* ATA割り込みマスク制御 */
void ATAInt_Mask(int IntMsk);

/* USB割り込みマスク制御 */
void USBInt_Mask(int IntMsk);

/* ISAバス割り込みマスク制御 */
void ISAInt_Mask(int IRQ, int IntMsk);

/*  PCカードソケット0 割り込みマスク制御 */
void PC0Int_Mask(int IntNo, int IntMsk);

/*  PCカードソケット1 割り込みマスク制御 */
void PC1Int_Mask(int IntNo, int IntMsk);
