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

//extern unsigned sounddata[];
#ifdef USE_DMA

//------------------------------------------------------------------------------
//	GetPowerValue
//------------------------------------------------------------------------------
void GetPowerValue(
	short	*psample, 
	int		cbsample, 
	int 	*pleftMax,
	int 	*prightMax) 
{
	

	int idx;
	int lm = 0, rm = 0;

	static int maxLeftSave  = 0;
    static int maxRightSave = 0;	
    
    *pleftMax = 0, *prightMax = 0;
	
	for (idx = 0; idx < cbsample; idx += 2)
	{
		if ((lm = abs(psample[idx]) >> 6) > *pleftMax)
			*pleftMax = lm;
	
		if ((rm = abs(psample[idx+1]) >> 6) > *prightMax)
			*prightMax = rm;
	}
	
	if (*pleftMax < maxLeftSave)
	{
		if ((*pleftMax = maxLeftSave - 4) < 0)
			*pleftMax = 0;
	
	}
	
	if (*prightMax < maxRightSave)
	{
		if ((*prightMax = maxRightSave - 4) < 0)
			*prightMax = 0;
	}	
	
}
void AudioRealISR(void)
{
	unsigned int read;
	int LeftMax, RightMax;
	/*
	UART_printf("Src address: 0x%08x\n", SMT_READ(DMACSADR1));
	UART_printf("Src address: 0x%08x\n", );
	UART_printf("Trans size : 0x%08x\n", SMT_READ(DMACCON1));
	*/
	
	//setCursor(1, 0x40400000);
	GetPowerValue(SMT_READ(DMACSAdr(1)), 0x8000/8, &LeftMax, &RightMax);
	//UART_printf("Left max: %d, Right max: %d\n", LeftMax, RightMax);
	//viewCursor(LeftMax);	
	
	
	{
		unsigned char *pTrg0, *pTrg1;
		int i =0, j = 0;
		
		
		
		for(i = 0; i < 138; i++) {

			pTrg0 = ((480*2)*i) + ((480*2*106)+188*2) + 0x41E00000;
			for(j = 0; j < 8*2; j++) {
				*pTrg0++ = 0xff;
			}
		}
		
		for(i = 0; i < 138; i++) {

			pTrg0 = ((480*2)*i) + ((480*2*106)+188*2) + 0x41E00000-((8+6)*2);
			for(j = 0; j < 8*2; j++) {
				*pTrg0++ = 0xff;
			}
		}
				
		
		
		for(i = 0; i < LeftMax/5; i++) {

			pTrg0 = ((480*2)*i) + ((480*2*106)+188*2) + 0x41E00000;
			for(j = 0; j < 2; j++) {
				
				*pTrg0++ = 0x12;
				*pTrg0++ = 0xef;
				*pTrg0++ = 0x12;
				*pTrg0++ = 0xef;
				*pTrg0++ = 0x12;
				*pTrg0++ = 0xef;
				*pTrg0++ = 0x12;
				*pTrg0++ = 0xef;
			}
		}
		
		for(i = 0; i < RightMax/5; i++) {

			pTrg0 = ((480*2)*i) + ((480*2*106)+188*2) + 0x41E00000-((8+6)*2);
			for(j = 0; j < 2; j++) {
				
				*pTrg0++ = 0x12;
				*pTrg0++ = 0xef;
				*pTrg0++ = 0x12;
				*pTrg0++ = 0xef;
				*pTrg0++ = 0x12;
				*pTrg0++ = 0xef;
				*pTrg0++ = 0x12;
				*pTrg0++ = 0xef;
			}
		}

		
		/*
		pTrg0 = (unsigned char*)0x40000000;
		
		pTrg0 += (480*2*10);
		
		for(i = 0; i < 10; i++) {
			
			for(j = 0; j < LeftMax/4; j++) {
				*pTrg0++ = 0x00;
			}
			
			for(j = 0; j < 480*2 - LeftMax/4; j++)
				*pTrg0++;
			
		}		
		*/
		

			
		
	}
	SMT_WRITE(DMACSTA1, SMT_READ(DMACSTA1)|(1<<1));
}


void BGM_Init(void) {
	
	int i;
	unsigned dto_ratio = DTO_RATIO;
	
	// PSM initailize
	PSM_InitialTest();
	
	
	
	
	
	// Init interrupt
	//EnableVIC(0, 0, 0);
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	smtISRregist();	// Primary ISR routine regist
	//RequestIRQ(0, );	// Real ISR routine regist
	RequestIRQ(1, AudioRealISR); // Real ISR routine regist

	EnableIRQ(0);
	EnableIRQ(1);

//	EnableIRQ(2);
//	EnableIRQ(3);
//	EnableIRQ(4);
//	EnableIRQ(5);
//	EnableIRQ(6);
//	EnableIRQ(7);
	
	Enable_IRQ();	
	
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
	PSM_2ByteWriteAndCheck(PSM_MASTER_VOLUME, 0x00, 0x4c);
//	PSM_2ByteWriteAndCheck(PSM_HP_VOL, 0x00, 0x1f);
	PSM_2ByteWriteAndCheck(PSM_GLOBAL_MUTE, 0x00, 0x00);
	PSM_2ByteWriteAndCheck(PSM_HP_ON, 0x00, 0x01);
	PSM_2ByteWriteAndCheck(PSM_HP_ON+1, 0x00, 0x01);	
	
	// I2S ready
	SMT_WRITE(
		I2S_CLKCTRL, 
		(MASTER_SLAVE<<31)
	   |(LRCLK_INV<<30)
	   |(MCLK_ON<<29)
	   |(MCLK_OE<<28)
	   |(0x0fffffff & dto_ratio));
	   
	for(i = 0; i < PRELOAD; i++)
		SMT_WRITE(I2S_DATA, 0);

	SMT_WRITE(
		I2S_CTRL,	
		(I2S_TX_EN<<15)
		|(TX_RESET<<14)
		|(TX_DMAINTEN<<13)
		|(TX_FIFOURINTEN<<12)
		|(TX_WLEN<<9)
		|(TX_LJUST<<8)
		|TX_FIFOTH);	
}
void BGM_MusicPlay(unsigned int ppcm, unsigned int size) {
	
	
	struct dma_desc
	{
		unsigned src_addr;
		unsigned dest_addr;
		unsigned control;
		unsigned desc_addr;
	};

	static struct dma_desc dma_desc_loop[500];
	static struct dma_desc start_dma_desc;	
	
	int i;
	
	/*
	tempclus = fOpen("00000test.snd");	// File statrt clust number
	if(tempclus)
	{
		Printf("raw open sucess!!!\n");
	}
	else 
		Printf("raw fail %d\n", tempclus);

	{
		int i = 0;
		
		for(i = 0; i < 1; i++) {
			readCount = fRead(0x40a00000+i*0x100000, 0x100000); //fRead(TargetAddr, Length);
			Printf("%d\n", readCount);
		}
	}
	*/	
	
	
#if 1	
	for(i = 0; i < size/0x8000; i++)	// 1 MB sound data = 32 x 32 KB
	{
		dma_desc_loop[i].src_addr 	=  	(ppcm + (i*0x8000));// (unsigned)&sounddata[i*0x8000/4];
		dma_desc_loop[i].dest_addr 	= 	APB1_STARTADDR+0x7000+0x0C;
		dma_desc_loop[i].control 	= 	0x06258000|(1<<30);
		
		if(i != (size/0x8000)-1) {
			dma_desc_loop[i].desc_addr = (unsigned)&dma_desc_loop[i+1];
		}
	}
	dma_desc_loop[(size/0x8000)-1].desc_addr = 1;

	DMACUseDescrp(1, (unsigned)(&dma_desc_loop[0]));	
	
	//
	// wait DMA end
	//
	while(1) 
	{
		if(SMT_READ(DMACDescrp(1))&0x1) 
		{
			break;
		}
		
	}	
	
	DMACDisable(1);
#else

	

#endif	
	
	
}
void BGM_MusicPlay0(unsigned int ppcm, unsigned int size) {
	
	
	struct dma_desc
	{
		unsigned src_addr;
		unsigned dest_addr;
		unsigned control;
		unsigned desc_addr;
	};

	static struct dma_desc dma_desc_loop[500];
	static struct dma_desc start_dma_desc;	
	
	int i;
	
	/*
	tempclus = fOpen("00000test.snd");	// File statrt clust number
	if(tempclus)
	{
		Printf("raw open sucess!!!\n");
	}
	else 
		Printf("raw fail %d\n", tempclus);

	{
		int i = 0;
		
		for(i = 0; i < 1; i++) {
			readCount = fRead(0x40a00000+i*0x100000, 0x100000); //fRead(TargetAddr, Length);
			Printf("%d\n", readCount);
		}
	}
	*/	
	
	
#if 1	
	for(i = 0; i < size/0x8000; i++)	// 1 MB sound data = 32 x 32 KB
	{
		dma_desc_loop[i].src_addr 	=  	(ppcm + (i*0x8000));// (unsigned)&sounddata[i*0x8000/4];
		dma_desc_loop[i].dest_addr 	= 	APB1_STARTADDR+0x7000+0x0C;
		dma_desc_loop[i].control 	= 	0x06258000;
		
		if(i != (size/0x8000)-1) {
			dma_desc_loop[i].desc_addr = (unsigned)&dma_desc_loop[i+1];
		}
	}
	dma_desc_loop[(size/0x8000)-1].desc_addr = 1;

	DMACUseDescrp(1, (unsigned)(&dma_desc_loop[0]));	
	

#else

	

#endif	
	
	
}
void BGM_MusicPlayWait(void) {
	
	//
	// wait DMA end
	//
	while(1) 
	{
		if(SMT_READ(DMACDescrp(1))&0x1) 
		{
			break;
		}
		
	}	
	
	DMACDisable(1);
	
}

void BGM_BackMusic(unsigned int ppcm, unsigned int size) {
	
	struct dma_desc
	{
		unsigned src_addr;
		unsigned dest_addr;
		unsigned control;
		unsigned desc_addr;
	};

	static struct dma_desc dma_desc_loop[500];
	static struct dma_desc start_dma_desc;	
	
	int i;
	
	for(i = 0; i < size/0x8000; i++)	// 1 MB sound data = 32 x 32 KB
	{
		dma_desc_loop[i].src_addr 	=  	(ppcm + (i*0x8000));// (unsigned)&sounddata[i*0x8000/4];
		dma_desc_loop[i].dest_addr 	= 	APB1_STARTADDR+0x7000+0x0C;
		dma_desc_loop[i].control 	= 	0x06258000;
		if(i != (size/0x8000)-1)
			dma_desc_loop[i].desc_addr = (unsigned)&dma_desc_loop[i+1];
	}
	dma_desc_loop[(size/0x8000)-1].desc_addr = (unsigned)&dma_desc_loop[0];

	//start_dma_desc.src_addr 	= (unsigned)&sounddata[PRELOAD];	// first 16 sample already in fifo
	start_dma_desc.src_addr 	= (unsigned)(ppcm + 32);
	start_dma_desc.dest_addr 	= APB1_STARTADDR+0x7000+0x0C;
	//start_dma_desc.control 		= 0x06250000|(0x8000-PRELOAD*4)|(1<<30)|(1<<31);
	start_dma_desc.control 		= 0x06250000|(1<<30)|(1<<31)|100;
	start_dma_desc.desc_addr 	= (unsigned)&dma_desc_loop[1];	
	
	DMACUseDescrp(1, (unsigned)(&start_dma_desc));
	
}

#endif
void BGM_Start(void)
{
	int i;
	
	
	unsigned int *pTarget;
	
	UART_printf("BGM_Start+\n");

#ifndef SIMUL
	
#endif

#ifdef USE_DMA

#endif
#ifndef SIMUL

#endif


	

#ifdef USE_DMA
#else
	while(1)
	{
		unsigned data;
		unsigned char data0, data1;
		data = SMT_READ(I2S_STATUS);
		if(!(data & (0x01<<6)))
		{
			SMT_WRITE(I2S_DATA, pTarget[i++]);
			if(i >= 10*256*1024)	// sound data size is 1MB
				i = 0;
		}
	}
#endif
}
