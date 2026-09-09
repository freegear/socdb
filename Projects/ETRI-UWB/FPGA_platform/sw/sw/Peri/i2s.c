/*----------------------------------------------------------
	File Name   : i2s.c 
	Description : i2s Controller test code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/
#include "sysinc.h"
#include "Commonmacro.h"
#include "gpio.h"
#include "uart.h"
#include "dmac.h"
#include "dma_mux.h"
#include "memorymap.h"

#define SYS_CLK		(100*1000*1000)		// 100 MHz
#define SAMPLING_RATE	(44.1*1000)		// 44.1 KHz
#define MCLK_RATE	(256*SAMPLING_RATE)

#define DTO_RATIO	((unsigned)(((float)MCLK_RATE)*((float)(0x00040000))/((float)SYS_CLK)))

#define MASTER_SLAVE	1		// master mode
#define LRCLK_INV		0		// Normal mode
#define MCLK_ON			1		// should be 1 when master mode
#define MCLK_OE			1		// MCLK Output Enable

#define I2S_RX_EN		1
#define RX_RESET		0
#define RX_DMAINTEN		0
#define RX_FIFOORINTEN	1
#define RX_WLEN			1		// 1 : 16bit per sample
#define RX_LJUST		0		// 0 : I2S compatible mode
#define RX_FIFOTH		8		// Fifo Threshold

#define USE_DMA
#define I2S_TX_EN		1
#define TX_RESET		0
#define TX_DMAINTEN		0
#define TX_FIFOURINTEN	1
#define TX_WLEN			1		// 1 : 16bit per sample
#define TX_LJUST		0		// 0 : I2S compatible mode
#define TX_FIFOTH		8		// Fifo Threshold

static int i2s_rx_dmach, i2s_tx_dmach;

extern unsigned sounddata[];
struct dma_desc
{
	unsigned src_addr;
	unsigned dest_addr;
	unsigned control;
	unsigned desc_addr;
};

static struct dma_desc tx_dma_desc_loop[32];
static struct dma_desc rx_dma_desc_loop[32];
static struct dma_desc tx_start_dma_desc;

#define GPIOWRITEBIT(x, pos) \
	do { \
		unsigned gpio_data;	\
		unsigned gpio_mask;	\
		gpio_mask = (0x00000001 << (pos));	\
		gpio_data = SMT_READ(GPIO0_OUT);	\
		if(x) gpio_data |= gpio_mask;	\
		else gpio_data &= ~gpio_mask; \
		SMT_WRITE(GPIO0_OUT, gpio_data);	\
	} while(0)

#define GPIOPIN_L3MODE	21
#define GPIOPIN_L3CLK	22
#define GPIOPIN_L3DATA	23
#define L3MODE(x)	GPIOWRITEBIT((x), GPIOPIN_L3MODE)
#define L3CLK(x)	GPIOWRITEBIT((x), GPIOPIN_L3CLK)
#define L3DATA(x)	GPIOWRITEBIT((x), GPIOPIN_L3DATA)

#define UDA1341STAT		0x16
#define UDA1341DATA0	0x14

#define UDA1341STAT_RST	0
#define UDA1341STAT_SC	2		// 256*Fs
#define UDA1341STAT_DC	1		// dc filtering
#define UDA1341STAT_IF	0		// I2S Mode
#define UDA1341STAT_OGS	0		// Output Gain(0dB)
#define UDA1341STAT_IGS	0		// Input Gain(0dB)
#define UDA1341STAT_PAD	0		// Polarity of ADC(non inverting)
#define UDA1341STAT_PDA	0		// Polarity of DAC(non inverting)
#define UDA1341STAT_PC	3		// Power Control(ADC on, DAC on)
#define UDA1341STAT_DS	0		// Double Speed(Single Speed)

#define UDA1341DATA0_VC	0		// Volume Control(0dB)
#define UDA1341DATA0_BB 0		// Base Boot(0)
#define UDA1341DATA0_TR 0		// Treble(0)
#define UDA1341DATA0_PP 0		// Peak Detection Position(0)
#define UDA1341DATA0_DE 0		// De-emphasis(no de-emphasis)
#define UDA1341DATA0_MT	0		// Mute(No Mute)
#define UDA1341DATA0_M	0		// Mode(flat)

#define UDA1341DATA0E_MA	0	// Mixer Gain Channel1(0dB)
#define UDA1341DATA0E_MB	0	// Miser Gain Channel2(0dB)
#define UDA1341DATA0E_MS	6	// MIC sensitity(27dB:max)
#define UDA1341DATA0E_MM	1	// Mixer Mode(Input Channel 1)
#define UDA1341DATA0E_AG	0	// AGC control(enable)
#define UDA1341DATA0E_IG	0	// Input Channel 2 gain(0dB)
#define UDA1341DATA0E_AT	0	// AGC attack and decay time
#define UDA1341DATA0E_AL	0	// AGC output level(-9dB)

static void L3Delay(void)
{
	int count = 20;

	while(count--)
		;
}

static int L3Addr(unsigned char addr)
{
	int i;

	L3MODE(0);
	L3Delay();
	for(i = 0; i < 8; i++)
	{
		L3CLK(1);
		L3Delay();
		L3CLK(0);
		L3DATA(addr & 0x01);
		L3Delay();
		addr >>= 1;
	}

	L3CLK(1);
	L3Delay();
	L3MODE(1);
	L3Delay();

	return 0;
}

static int L3Data(unsigned char data)
{
	int i;

	L3MODE(1);
	L3Delay();
	for(i = 0; i < 8; i++)
	{
		L3CLK(1);
		L3Delay();
		L3CLK(0);
		L3DATA(data & 0x01);
		L3Delay();
		data >>= 1;
	}

	L3CLK(1);
	L3Delay();
	L3MODE(0);
	L3Delay();
	L3MODE(1);
	L3Delay();

	return 0;
}

static void L3Init(void)
{
	unsigned data;

	data = SMT_READ(GPIO0_OUT);
	data |= (1<<GPIOPIN_L3MODE)|(1<<GPIOPIN_L3CLK)|(1<<GPIOPIN_L3DATA);
	SMT_WRITE(GPIO0_OUT, data);

	data = SMT_READ(GPIO0_OE);
	data |= (1<<GPIOPIN_L3MODE)|(1<<GPIOPIN_L3CLK)|(1<<GPIOPIN_L3DATA);
	SMT_WRITE(GPIO0_OE, data);

	L3Delay();
	L3CLK(1);
}

static int AudioCodecInit(void)
{
	static int initialized = 0;

	if(initialized)
		return 0;

//	DPRINTF("Philips UDA1341 Setting...");
	
	L3Init();

	L3Addr(UDA1341STAT);
	L3Data((0<<7)
		|(UDA1341STAT_RST<<6)
		|(UDA1341STAT_SC<<4)
		|(UDA1341STAT_IF<<1)
		|(UDA1341STAT_DC<<0));

	L3Addr(UDA1341STAT);
	L3Data((1<<7)
		|(UDA1341STAT_OGS<<6)
		|(UDA1341STAT_IGS<<5)
		|(UDA1341STAT_PAD<<4)
		|(UDA1341STAT_PDA<<3)
		|(UDA1341STAT_DS<<2)
		|(UDA1341STAT_PC<<0));

	L3Addr(UDA1341DATA0);
	L3Data((0<<6)
		|(UDA1341DATA0_VC));

	L3Data((1<<6)
		|(UDA1341DATA0_BB<<2)
		|(UDA1341DATA0_TR));

	L3Data((2<<6)
		|(UDA1341DATA0_PP<<5)
		|(UDA1341DATA0_DE<<3)
		|(UDA1341DATA0_MT<<2)
		|(UDA1341DATA0_M));

	L3Data((0x18<<3)
		|(0x00));	// ExT ADDR 000

	L3Data((0x7<<5)
		|(UDA1341DATA0E_MA));

	L3Data((0x18<<3)
		|(0x01));	// ExT ADDR 001

	L3Data((0x7<<5)
		|(UDA1341DATA0E_MB));

	L3Data((0x18<<3)
		|(0x02));	// ExT ADDR 010

	L3Data((0x7<<5)
		|(UDA1341DATA0E_MS<<2)
		|(UDA1341DATA0E_MM));

	L3Data((0x18<<3)
		|(0x04));	// ExT ADDR 100

	L3Data((0x7<<5)
		|(UDA1341DATA0E_AG<<4)
		|(UDA1341DATA0E_IG&0x03));

	L3Data((0x18<<3)
		|(0x05));	// ExT ADDR 101

	L3Data((0x7<<5)
		|((UDA1341DATA0E_IG>>2)&0x1F));

	L3Data((0x18<<3)
		|(0x06));	// ExT ADDR 110

	L3Data((0x7<<5)
		|(UDA1341DATA0E_AT<<2)
		|(UDA1341DATA0E_AL));

	initialized = 1;
//	DPRINTF("Done\n");

	return 0;
}

static void I2SCtrlReset(void)
{
	SMT_WRITE(I2S_CTRL,	(1<<14)|(1<<30));		// Tx Reset & Rx Reset
}

void BGMEnable(void)
{
	int i;
	unsigned dto_ratio = DTO_RATIO;
	unsigned fifo_depth;
	unsigned preload;

	fifo_depth = (SMT_READ(I2S_STATUS)&0x00070000)>>16;
	preload = (1<<fifo_depth)/2;

	I2SCtrlReset();

#ifdef USE_DMA
	for(i = 0; i < 32; i++)	// 1 MB sound data = 32 x 32 KB
	{
		tx_dma_desc_loop[i].src_addr = (unsigned)&sounddata[i*0x8000/4];
		tx_dma_desc_loop[i].dest_addr = (unsigned)(&I2S_DATA);
		tx_dma_desc_loop[i].control = 0x06258000;
		if(i != 31)
			tx_dma_desc_loop[i].desc_addr = (unsigned)&tx_dma_desc_loop[i+1];
	}
	tx_dma_desc_loop[31].desc_addr = (unsigned)&tx_dma_desc_loop[0];

	tx_start_dma_desc.src_addr = (unsigned)&sounddata[preload];	// first 16 sample already in fifo
	tx_start_dma_desc.dest_addr = (unsigned)(&I2S_DATA);
	tx_start_dma_desc.control = 0x06250000|(0x8000-preload*4);
	tx_start_dma_desc.desc_addr = (unsigned)&tx_dma_desc_loop[1];
#endif

	SMT_WRITE(I2S_CLKCTRL, (MASTER_SLAVE<<31)|(LRCLK_INV<<30)|(MCLK_ON<<18)|(MCLK_OE<<19)|(0x0003ffff & dto_ratio));

//	AudioCodecInit();

	for(i = 0; i < preload; i++)
		SMT_WRITE(I2S_DATA, sounddata[i]);

	SMT_WRITE(I2S_CTRL,	(I2S_TX_EN<<15)|(TX_RESET<<14)|(TX_DMAINTEN<<13)|(TX_FIFOURINTEN<<12)|(TX_WLEN<<9)|(TX_LJUST<<8)|TX_FIFOTH);

#ifdef USE_DMA
	i2s_tx_dmach = DMAChannelAlloc(DMA_I2STX);
	DMACUseDescrp(i2s_tx_dmach, (unsigned)(&tx_start_dma_desc));
	UartPrintf("DMAC(%d) STA  : 0x%08x\n", i2s_tx_dmach, DMACSta(i2s_tx_dmach));
#else
	while(1)
	{
		unsigned data;
		data = SMT_READ(I2S_STATUS);
		if(!(data & (0x01<<fifo_depth)))
		{
			SMT_WRITE(I2S_DATA, sounddata[i++]);
			if(i >= 256*1024)	// sound data size is 1MB
				i = 0;
		}
	}
#endif
}

static void AudioDelayedLoopbackEnable(void)
{
	int i;
	unsigned dto_ratio = DTO_RATIO;
	unsigned loopback_start_addr = AUDIO_TESTADDR;

	I2SCtrlReset();

	// clearing data first
	for(i = 0; i < 0x8000*32/4; i++)
		*(((unsigned *)loopback_start_addr)+i) = 0;

	for(i = 0; i < 32; i++)	// 1 MB sound data = 32 x 32 KB
	{
		tx_dma_desc_loop[i].src_addr = loopback_start_addr + 0x8000*i;;
		tx_dma_desc_loop[i].dest_addr = (unsigned)(&I2S_DATA);
		tx_dma_desc_loop[i].control = 0x06258000;
		if(i != 31)
			tx_dma_desc_loop[i].desc_addr = (unsigned)&tx_dma_desc_loop[i+1];

		rx_dma_desc_loop[i].dest_addr = loopback_start_addr + 0x8000*i;
		rx_dma_desc_loop[i].src_addr = (unsigned)(&I2S_DATA);
		rx_dma_desc_loop[i].control = 0x02658000;
		if(i != 31)
			rx_dma_desc_loop[i].desc_addr = (unsigned)&rx_dma_desc_loop[i+1];
	}
	tx_dma_desc_loop[31].desc_addr = (unsigned)&tx_dma_desc_loop[0];
	rx_dma_desc_loop[31].desc_addr = (unsigned)&rx_dma_desc_loop[0];

	SMT_WRITE(I2S_CLKCTRL, (MASTER_SLAVE<<31)|(LRCLK_INV<<30)|(MCLK_ON<<18)|(MCLK_OE<<19)|(0x0003ffff & dto_ratio));

	AudioCodecInit();

	SMT_WRITE(I2S_CTRL, (I2S_RX_EN<<31)|(RX_RESET<<30)|(RX_DMAINTEN<<29)|(RX_FIFOORINTEN<<28)|(RX_WLEN<<25)|(RX_LJUST<<24)|(RX_FIFOTH<<16) | (I2S_TX_EN<<15)|(TX_RESET<<14)|(TX_DMAINTEN<<13)|(TX_FIFOURINTEN<<12)|(TX_WLEN<<9)|(TX_LJUST<<8)|TX_FIFOTH);

	i2s_tx_dmach = DMAChannelAlloc(DMA_I2STX);
	i2s_rx_dmach = DMAChannelAlloc(DMA_I2SRX);
	DMACUseDescrp(i2s_tx_dmach, (unsigned)(&tx_dma_desc_loop[0]));
	DMACUseDescrp(i2s_rx_dmach, (unsigned)(&rx_dma_desc_loop[31]));
}

void BGMTest(void)
{
	int i;
	int count;

	BGMEnable();
	i = 0;
	while(1)
	{
		char uart_input;
		count = 100000;
		GPIOWrite(i);
		i++;
		if(UartDataAvailable())
		{
			uart_input = UartGetch();
			if(uart_input == '0')
				break;
		}
		i &= 0xfffff;
		while(count--);
	}

	// Clean Up
	I2SCtrlReset();
	DMAChannelFree(i2s_tx_dmach);
	DMACDisable(i2s_tx_dmach);
}

void AudioDelayedLoopback(void)
{
	int i;
	int count;

	AudioDelayedLoopbackEnable();
	i = 0;
	while(1)
	{
		char uart_input;
		count = 100000;
		GPIOWrite(i);
		i++;
		if(UartDataAvailable())
		{
			uart_input = UartGetch();
			if(uart_input == '0')
				break;
		}
		i &= 0xfffff;
		while(count--);
	}

	// Clean Up
	I2SCtrlReset();
	DMAChannelFree(i2s_tx_dmach);
	DMAChannelFree(i2s_rx_dmach);
	DMACDisable(i2s_tx_dmach);
	DMACDisable(i2s_rx_dmach);
}

