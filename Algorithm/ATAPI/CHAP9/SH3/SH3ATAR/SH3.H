/******************************************************************************
   SH-3内蔵 & CQ RISC評価キット/SH-3 CPUボード リソース定義
******************************************************************************/

#define TSTR	(pUBYTE)0xFFFFFE92
#define TOCR	(pUBYTE)0xFFFFFE90

typedef struct {
	unsigned long TCOR;
	unsigned long TCNT;
	unsigned short int TCR;
	} ITU;

#define ITU0	((ITU *)0xFFFFFE94)
#define IPRA	(pUWORD)0xFFFFFEE2
#define IPRB	(pUWORD)0xFFFFFEE4

#define BCR1	(pUWORD)0xFFFFFF60	/* バスコントロールレジスタ1 */
#define BCR2	(pUWORD)0xFFFFFF62	/* バスコントロールレジスタ2 */
#define WCR1	(pUWORD)0xFFFFFF64	/* ウェイトコントロールレジスタ1 */
#define WCR2	(pUWORD)0xFFFFFF66	/* ウェイトコントロールレジスタ2 */
#define PCR		(pUWORD)0xFFFFFF6C	/* PCMCIAコントロールレジスタ */

#define LED_ADDRESS	(pUBYTE)0xA8000000



/* SH-3 エリア5 初期化 */
void CPUBus_Init(void);

/* SH-3 1ms タイマー割り込み初期化 */
void SystemTimer_Init(int);

/* SH-3 1ms タイマー割り込み処理関数 */
void SystemTimer_Int(void);
volatile unsigned int TIMER_count;
