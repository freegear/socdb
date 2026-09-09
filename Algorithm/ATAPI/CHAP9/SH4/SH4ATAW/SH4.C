/******************************************************************************
	SH-4 エリア1 初期化
******************************************************************************/

#include	"TYPEDEF.H"
#include	"SH4.H"

/* SH-4 エリア1 初期化 */
void CPUBus_Init(void)
{
	int i;
	int (*fnc)();
	unsigned int data0;
	unsigned short data1;

	CPUInt_Mask(0);	/* CPU割り込み禁止 */

	/* CPU内蔵リソース 割り込みレベルリセット */
	*IPRA = 0;	/* CPU内蔵リソース割り込み未使用 */
	*IPRB = 0;	/* CPU内蔵リソース割り込み未使用 */
	*IPRC = 0;	/* CPU内蔵リソース割り込み未使用 */

	/* SH-4 エリア1 初期化 */
	data0=*BCR1;
	*BCR1=data0 | 0x00200000;	/* bit21:1 */
	data1=*BCR2;
	*BCR2=(data1 & 0xfff3) | 0x0008;	/* bit3/2:10 */
	data0=*WCR1;
	*WCR1=(data0 & 0xffffff8f) | 0x00000020;	/* bit6/5/4:010 */
	data0=*WCR2;
	*WCR2=(data0 & 0xfffffe3f) | 0x00000100;	/* bit8/7/6:100 */
	data0=*WCR3;
	*WCR3=(data0 & 0xffffff8f);	/* bit6:0 bit5/4:00 */

/*  キャッシュON */
	fnc = (int (*)())((int)CACH_On | 0xa0000000);
	(*fnc)();
}

/* SH-4 キャッシュON */
void CACH_On(void)
{
	register int i;
	*CCR=0x808;
	*CCR=0x101;
}

/* SH-4 1ms タイマー割り込み初期化 */
void SystemTimer_Init(int IRLlvl)
{
	ITU0->TCR = 0x21;	/* Int Ena 1/16 clock (1066 nS 15MHz)*/
	ITU0->TCOR = 938;	/* 1msec */
	ITU0->TCNT = 938;
	*TSTR = *TSTR | 1;	/* タイマースタート */
	*IPRA = (*IPRA & 0x0FFF) | ((IRLlvl&0xF)<<12);	/* ITU0 割り込み */
}

/* SH-4 1ms タイマー割り込み処理関数 */
void SystemTimer_Int(void)
{
	if(ITU0->TCR & 0x100){	/* 1msec 割り込み */
		ITU0->TCR=(ITU0->TCR & 0xfeff);	/* 割り込み要求クリア */
		TIMER_count++;
	}
}

