/******************************************************************************
   SH-4内蔵 & CQ RISC評価キット/SH-4 CPUボード リソース定義
******************************************************************************/

#define TSTR	(pUBYTE)0xFFD80004
#define TOCR	(pUBYTE)0xFFD80000

typedef struct {
	unsigned long TCOR;
	unsigned long TCNT;
	unsigned short int TCR;
	} ITU;
#define ITU0	((ITU *)0xFFD80008)

#define ICR		(pUWORD)0xFFD00000
#define IPRA	(pUWORD)0xFFD00004
#define IPRB	(pUWORD)0xFFD00008
#define IPRC	(pUWORD)0xFFD0000C

#define BCR1	(pUDWORD)0xFF800000	/* バスコントロールレジスタ1 */
#define BCR2	(pUWORD)0xFF800004	/* バスコントロールレジスタ2 */
#define WCR1	(pUDWORD)0xFF800008	/* ウェイトコントロールレジスタ1 */
#define WCR2	(pUDWORD)0xFF80000C	/* ウェイトコントロールレジスタ2 */
#define WCR3	(pUDWORD)0xFF800010	/* ウェイトコントロールレジスタ3 */

#define CCR	(pUDWORD)0xFF00001C
#define VBR_ADR	0x08F00000
#define LED_ADDRESS	(pUBYTE)0xB4000000


/* SH-4 エリア1 初期化 */
void CPUBus_Init(void);

/* SH-4 キャッシュON */
void CACH_On(void);

/* SH-4 1ms タイマー割り込み初期化 */
void SystemTimer_Init(int);

/* SH-4 1ms タイマー割り込み処理関数 */
void SystemTimer_Int(void);
volatile unsigned int TIMER_count;
