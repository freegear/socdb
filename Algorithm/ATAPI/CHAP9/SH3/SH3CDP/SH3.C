/******************************************************************************
	SH-3 エリア5 初期化
******************************************************************************/

#include	"TYPEDEF.H"
#include	"SH3.H"

/* SH-3 エリア5 初期化 */
void CPUBus_Init(void)
{
	int i;
	unsigned short data;

	/* SH-3 エリア5 初期化 */
	data=*BCR1;
	*BCR1=(data & 0xfe7d) | 2;	/* bit8/7:00  bit1:1 */
	data=*BCR2;
	*BCR2=(data & 0xf3ff) | 0x0800;	/* bit11/10:10 */
	data=*WCR1;
	*WCR1=(data & 0xf3ff) | 0x0800;	/* bit11/10:10 */
	data=*WCR2;
	*WCR2=(data & 0xe3ff) | 0x1400;	/* bit12/11/10:101 */
	data=*PCR;
	*PCR=(data & 0xff33);	/* bit7/6:00 bit3/2:00 */
}

/* SH-3 1ms タイマー割り込み初期化 */
void SystemTimer_Init(int IRLlvl)
{
	ITU0->TCR = 0x21;	/* Int Ena 1/16 clock (1066 nS 15MHz)*/
	ITU0->TCOR = 938;	/* 1msec */
	ITU0->TCNT = 938;
	*TSTR = *TSTR | 1;	/* タイマースタート */
	*IPRA = (*IPRA & 0x0FFF) | ((IRLlvl&0xF)<<12);	/* ITU0 割り込み */
}

/* SH-3 1ms タイマー割り込み処理関数 */
void SystemTimer_Int(void)
{
	if(ITU0->TCR & 0x100){	/* 1msec 割り込み */
		ITU0->TCR=(ITU0->TCR & 0xfeff);	/* 割り込み要求クリア */
		TIMER_count++;
	}
}

