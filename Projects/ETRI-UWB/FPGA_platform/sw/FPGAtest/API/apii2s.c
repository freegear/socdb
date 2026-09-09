/*----------------------------------------------------------
	File Name   : apii2s.c 
	Description : i2s Controller
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

#include "psm711.h"

#define SYS_CLK		(50*1000*1000)		// 25 MHz
#define SAMPLING_RATE	(44.1*1000)		// 8 KHz
#define MCLK_RATE	(256*SAMPLING_RATE)	// 1/4 clock of SYS_CLK for test

#define DTO_RATIO	((unsigned)(((float)MCLK_RATE)*((float)(0x10000000))/((float)SYS_CLK)))

#define MASTER_SLAVE	1		// master mode
#define LRCLK_INV		0		// Normal mode
#define MCLK_ON			1		// should be 1 when master mode
#define MCLK_OE			1		// MCLK Output Enable

#define I2S_TX_EN		1
#define TX_RESET		0
#define TX_DMAINTEN		0
#define TX_FIFOURINTEN	1
#define TX_WLEN			1		// 1 : 16bit per sample
#define TX_LJUST		0		// 0 : I2S compatible mode
#define TX_FIFOTH		15		// Fifo Threshold
#define MAKE_STEREO(x)		(((((unsigned)(x))&0x0000ffff) << 16) | (((unsigned)(x))&0x0000ffff))

#define SINE_WAVE_VOL	256*8
#define SINE_FREQ_CONTROL	4

#define USE_DMA
#define PRELOAD		32

extern unsigned sounddata[];
#ifdef USE_DMA
struct dma_desc
{
	unsigned src_addr;
	unsigned dest_addr;
	unsigned control;
	unsigned desc_addr;
};

static struct dma_desc dma_desc_loop[32];
static struct dma_desc start_dma_desc;
#endif
void BGM_Start(void)
{
	int i;
	unsigned dto_ratio = DTO_RATIO;

#ifndef SIMUL
	PSM_InitialTest();
#endif

#ifdef USE_DMA
	for(i = 0; i < 32; i++)	// 1 MB sound data = 32 x 32 KB
	{
		dma_desc_loop[i].src_addr = (unsigned)&sounddata[i*0x8000/4];
		dma_desc_loop[i].dest_addr = APB1_STARTADDR+0x7000+0x0C;
		dma_desc_loop[i].control = 0x06258000;
		if(i != 31)
			dma_desc_loop[i].desc_addr = (unsigned)&dma_desc_loop[i+1];
	}
	dma_desc_loop[31].desc_addr = (unsigned)&dma_desc_loop[0];

	start_dma_desc.src_addr = (unsigned)&sounddata[PRELOAD];	// first 16 sample already in fifo
	start_dma_desc.dest_addr = APB1_STARTADDR+0x7000+0x0C;
	start_dma_desc.control = 0x06250000|(0x8000-PRELOAD*4);
	start_dma_desc.desc_addr = (unsigned)&dma_desc_loop[1];
#endif
#ifndef SIMUL
	// PSM register setting
	PSM_2ByteWriteAndCheck(PSM_PLL_FREQUENCY_SEL, 24, 204);

	PSM_2ByteWriteAndCheck(PSM_IN1_CONTROL, 0x01, 0xEE);
	PSM_2ByteWriteAndCheck(PSM_IN1_CONTROL+1, 0x01, 0xEE);
	PSM_2ByteWriteAndCheck(PSM_IN1_CONTROL+2, 0x01, 0xEE);
	PSM_2ByteWriteAndCheck(PSM_PWM_ON_OFF, 0x00, 0x00);
	PSM_2ByteWriteAndCheck(PSM_IN_MODE_CONTROL, 0x00, 0x02);
	PSM_2ByteWriteAndCheck(PSM_IN_MIX_CONFIG, 0x00, 0x1F);
	PSM_2ByteWriteAndCheck(PSM_IN_MIX_LEVEL, 0x80, 0x08);
	PSM_2ByteWriteAndCheck(PSM_IN1_VOICE_CONTROL, 0x0A, 0x30);
	PSM_2ByteWriteAndCheck(PSM_IN2_VOICE_CONTROL, 0x0A, 0x30);
	PSM_2ByteWriteAndCheck(PSM_MASTER_VOLUME, 0x00, 0x2c);
//	PSM_2ByteWriteAndCheck(PSM_HP_VOL, 0x00, 0x1f);
	PSM_2ByteWriteAndCheck(PSM_GLOBAL_MUTE, 0x00, 0x00);
	PSM_2ByteWriteAndCheck(PSM_HP_ON, 0x00, 0x01);
	PSM_2ByteWriteAndCheck(PSM_HP_ON+1, 0x00, 0x01);
#endif

	SMT_WRITE(I2S_CLKCTRL, (MASTER_SLAVE<<31)|(LRCLK_INV<<30)|(MCLK_ON<<29)|(MCLK_OE<<28)|(0x0fffffff & dto_ratio));
	for(i = 0; i < PRELOAD; i++)
		SMT_WRITE(I2S_DATA, sounddata[i]);

	SMT_WRITE(I2S_CTRL,	(I2S_TX_EN<<15)|(TX_RESET<<14)|(TX_DMAINTEN<<13)|(TX_FIFOURINTEN<<12)|(TX_WLEN<<9)|(TX_LJUST<<8)|TX_FIFOTH);

#ifdef USE_DMA
	DMACUseDescrp(1, (unsigned)(&start_dma_desc));
#else
	while(1)
	{
		unsigned data;
		unsigned char data0, data1;
		data = SMT_READ(I2S_STATUS);
		if(!(data & (0x01<<6)))
		{
			SMT_WRITE(I2S_DATA, sounddata[i++]);
			if(i >= 256*1024)	// sound data size is 1MB
				i = 0;
		}
	}
#endif
}
