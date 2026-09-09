/*----------------------------------------------------------
	File Name   : i2s.c 
	Description : i2s Controller test code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/
#include "Commonmacro.h"
#include "uart_pre_drv.h"
#include "i2s_pre_drv.h"
#include "l3inf.h"
/*/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// */
//-----------------------------------------------------------
// I2S interface configuration definition
//-----------------------------------------------------------
#define I2S_DTO_RATIO(b, s)														\
	((unsigned)(((float)(b)*256)*((float)(0x00040000))/((float)(s))))

// I2S clock
#define I2S_SYS_CLK					(100*1000*1000)						// 100MHz system clock for I2S 
#define	I2ST_DTO_11025				I2S_DTO_RATIO(11025, I2S_SYS_CLK)	// DTO ratio for 11025Hz 
#define	I2ST_DTO_22050				I2S_DTO_RATIO(22050, I2S_SYS_CLK)	// DTO ratio for 22050Hz 
#define	I2ST_DTO_44100				I2S_DTO_RATIO(44100, I2S_SYS_CLK)	// DTO ratio for 44100Hz 
#define	I2ST_DTO_48000				I2S_DTO_RATIO(48000, I2S_SYS_CLK)	// DTO ratio for 48000Hz 

// I2S bitwidth
#define	I2ST_BW_08BIT				(0x0)								
#define	I2ST_BW_16BIT				(0x1)
#define	I2ST_BW_24BIT				(0x2)
#define	I2ST_BW_32BIT				(0x3)

// I2S etc
#define	I2ST_FIFO_TH				(0x8)
#define	I2ST_SAMPLE_LEN				(0x1000)
#define	I2ST_TX_PERI_IDX			(0x3)
#define	I2ST_RX_PERI_IDX			(0x4)
#define	I2ST_TX_DMC_CH				(0x3)
#define	I2ST_RX_DMC_CH				(0x4)

// I2S & DMA interrupt
#define	I2ST_INT_NUM				(21)
#define	I2ST_TX_DMC_INT_NUM			(I2ST_TX_DMC_CH)
#define	I2ST_RX_DMC_INT_NUM			(I2ST_RX_DMC_CH)

// I2S time out value
#define	I2S_TIMEOUT_DMA				(0x7FFFF)
#define	I2S_TIMEOUT_UNDERRUNEVENT	(0x7FFFFFF)
#define	I2S_TIMEOUT_OVERRUNEVENT	(0x7FFFFFF)
//-----------------------------------------------------------
// UDA1341 
//-----------------------------------------------------------
#define UDA1341STAT			0x16
#define UDA1341DATA0		0x14

#define UDA1341STAT_RST		0
#define UDA1341STAT_SC		2		// 256*Fs
#define UDA1341STAT_DC		1		// dc filtering
#define UDA1341STAT_IF		0		// I2S Mode
#define UDA1341STAT_OGS		0		// Output Gain(0dB)
#define UDA1341STAT_IGS		0		// Input Gain(0dB)
#define UDA1341STAT_PAD		0		// Polarity of ADC(non inverting)
#define UDA1341STAT_PDA		0		// Polarity of DAC(non inverting)
#define UDA1341STAT_PC		3		// Power Control(ADC on, DAC on)
#define UDA1341STAT_DS		0		// Double Speed(Single Speed)

#define UDA1341DATA0_VC		0		// Volume Control(0dB)
#define UDA1341DATA0_BB		0		// Base Boot(0)
#define UDA1341DATA0_TR		0		// Treble(0)
#define UDA1341DATA0_PP		0		// Peak Detection Position(0)
#define UDA1341DATA0_DE		0		// De-emphasis(no de-emphasis)
#define UDA1341DATA0_MT		0		// Mute(No Mute)
#define UDA1341DATA0_M		0		// Mode(flat)

#define UDA1341DATA0E_MA	0	// Mixer Gain Channel1(0dB)
#define UDA1341DATA0E_MB	0	// Miser Gain Channel2(0dB)
#define UDA1341DATA0E_MS	6	// MIC sensitity(27dB:max)
#define UDA1341DATA0E_MM	1	// Mixer Mode(Input Channel 1)
#define UDA1341DATA0E_AG	0	// AGC control(enable)
#define UDA1341DATA0E_IG	0	// Input Channel 2 gain(0dB)
#define UDA1341DATA0E_AT	0	// AGC attack and decay time
#define UDA1341DATA0E_AL	0	// AGC output level(-9dB)

//-----------------------------------------------------------
// I2S test  
//-----------------------------------------------------------
#define DDRRAM_STARTADDR		(0x63000000)
#define DDRRAM_USER				(DDRRAM_STARTADDR+2*1024*1024)		// lower 2MB used as code/data
#define FRAME_BASEADDR			(DDRRAM_USER)
#define AUDIO_TESTADDR			(FRAME_BASEADDR+12*1024*1024)		// 4MB as Frame buffer
#define USE_DMA
//-----------------------------------------------------------
// I2S DMA
//-----------------------------------------------------------
#define DMA_I2STX				3
#define DMA_I2SRX				4
#define NUMBER_OF_DMA_CHANNEL	8
/*/////////////////////////////////////////////////////////
        TYPE DEFINITION
///////////////////////////////////////////////////////// */
struct dma_desc
{
	smtUint32 src_addr;
	smtUint32 dest_addr;
	smtUint32 control;
	smtUint32 desc_addr;
};
typedef struct dma_channel_alloctator_entry_ 
{
	smtUint16 dma_device;
	smtUint16 free;
} dma_channel_allocator_entry; 

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

static dma_channel_allocator_entry dma_channel_allocator[NUMBER_OF_DMA_CHANNEL] =
{
	{ 0, 1 },
	{ 1, 1 },
	{ 2, 1 },
	{ 3, 1 },
	{ 4, 1 },
	{ 5, 1 },
	{ 6, 1 },
	{ 7, 1 }
};

extern smtUint32 sounddata[];
static smtInt32 i2s_rx_dmach, i2s_tx_dmach;
static struct dma_desc tx_dma_desc_loop[32];
static struct dma_desc rx_dma_desc_loop[32];
static struct dma_desc tx_start_dma_desc;
/*/////////////////////////////////////////////////////////
        DMA FUNCTION
///////////////////////////////////////////////////////// */
// Refer to dma_mux.c
/*-----------------------------------------------------------------------
    Function name   : DMAChannelAlloc(smtUint16 dma_device)
    Prototype       : int DMAChannelAlloc(smtUint16 dma_device)
    Return          : -1 when no available channel
                      DMA channel number for your device.
	Argument        : dma_device -> predefined number of each device
    Comments        : ResourceShare setting(I think this routine should 
    					be exeucted with IRQ off, but ...)
-----------------------------------------------------------------------*/
smtInt32 DMAChannelAlloc(smtUint16 dma_device)
{
	smtUint32 data;
	smtInt32 i;

	// Check if allready allocated channel exists
	for(i = 0; i < NUMBER_OF_DMA_CHANNEL; i++)
	{
		if(dma_channel_allocator[i].dma_device == dma_device
			&& dma_channel_allocator[i].free == 0)
			return i;
	}

	// Check if previously allocated channel exists
	for(i = 0; i < NUMBER_OF_DMA_CHANNEL; i++)
	{
		if(dma_channel_allocator[i].dma_device == dma_device)
		{
			dma_channel_allocator[i].free = 0;
			return i;
		}
	}

	// Search free available channel
	for(i = 0; i < NUMBER_OF_DMA_CHANNEL; i++)
	{
		if(dma_channel_allocator[i].free == 1)
		{
			dma_channel_allocator[i].dma_device = dma_device;
			dma_channel_allocator[i].free = 0;
			data = SMT_READ(RS_DMAMUX);
			data &= ~(0x000000f<<(i*4));
			data |= (dma_device & 0x000f)<<(i*4);
			SMT_WRITE(RS_DMAMUX, data);

			return i;
		}
	}

	// No available channel exists
	return -1;
}

/*-----------------------------------------------------------------------
    Function name   : DMAChannelFree(smtInt32 channelNo)
    Prototype       : void DMAChannelFree(smtInt32 channelNo)
    Return          : void
	Argument        : channelNo => return value of DMAChannelAlloc()
    Comments        : 
-----------------------------------------------------------------------*/
void DMAChannelFree(smtInt32 channelNo)
{
	if(channelNo < 0 || channelNo >= NUMBER_OF_DMA_CHANNEL)
		return;

	dma_channel_allocator[channelNo].free = 1;
}

// Refer to dmac.c
/*-----------------------------------------------------------------------
    Function name   : DMACEnable()
    Prototype       : void DMACEnable(smtUint8 channel)
    Return          : 
    Argument        :
    Comments        : Enable DMA 
-----------------------------------------------------------------------*/
void DMACEnable(smtUint8 channel)
{
	SMT_WRITE(DMACSta(channel), 
		(SMT_READ(DMACSta(channel))|DMA_ENABLE_MASK)); // DMAC Enable
}
/*-----------------------------------------------------------------------
    Function name   : DMACDisable()
    Prototype       : void DMACDisable(smtUint8 channel)
    Return          : 
    Argument        :
    Comments        : Disable DMA Channel
-----------------------------------------------------------------------*/
void DMACDisable(smtUint8 channel)
{
	// DMAC Disable
	SMT_WRITE(DMACSta(channel), 
		(SMT_READ(DMACSta(channel))&(!DMA_ENABLE_MASK&0xFFFFFFFF))); 
		
	// polling Active bit => 0
	while ((SMT_READ(DMACSta(channel))&DMA_ACTIVE_MASK) == DMA_ACTIVE_MASK);
	SMT_WRITE(DMACSta(channel), 0x0000000F); 
	
}
/*-----------------------------------------------------------------------
    Function name   : DMACNoDescrp()
    Prototype       : void DMACNoDescrp(smtUint8 channel, smtUint32 
    						SourceAddr, smtUint32 DestAddr, smtUint16 TSize)
    Return          : 
    Argument        :
    Comments        : DMA Don't Use Descriptor
-----------------------------------------------------------------------*/

void DMACNoDescrp(smtUint8 channel, 
			smtUint32 SrcAddr, smtBoolean SrcIncrease, smtUint8 SWidth,
	      	smtUint32 DestAddr,  smtBoolean DstIncrease, smtUint8 DWidth, 
	      	smtUint8 TransSize, smtUint16 TotalSize)
{
	// assign Source address
	SMT_WRITE (DMACSAdr(channel), SrcAddr); 
	
	// assign Destination address
	SMT_WRITE (DMACDAdr(channel), DestAddr); 
	
	// Control register setting
	SMT_WRITE (DMACCon (channel), 
				((SrcIncrease&0x01)<<28)|((SWidth&0x03)<<26)|((DstIncrease&0x01)<<25)
			   |((DWidth&0x03)<<23)
			   |((TransSize&0x07)<<20)|(TotalSize&DMA_TXLENGTH_MASK)); 
			   	   
	SMT_WRITE (DMACDescrp(channel), 
		DMA_DESCREND_MASK);
		
	SMT_WRITE (DMACSta(channel), 
		DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK);
}

/*-----------------------------------------------------------------------
    Function name   : DMADescrp()
    Prototype       : void DMACUseDescrp(smtUint8 channel, smtBoolean mem2mem)
    Return          : 
    Argument        :
    Comments        : DMA Use Descriptor
-----------------------------------------------------------------------*/
void DMACUseDescrp(smtUint8 channel, smtUint32 FirstDescAddr)
{
	smtUint32 i, j;
	smtUint32 *desc = (smtUint32 *)FirstDescAddr;

	DCacheFlushing();

	// Memory to Memory
	SMT_WRITE(DMACDescrp(channel),FirstDescAddr); 
	
	// DMA Bug for Size registering
	SMT_WRITE(DMACCon(channel), 0);	
	SMT_WRITE(DMACSta(channel), DMA_ENABLE_MASK|DMA_STOPINTEN_MASK);	
}

/*-----------------------------------------------------------------------
    Function name	: DMACMemCopy()
    Prototype		: void DMACMemCopy(smtUint8 channel, smtBoolean mem2mem)
    Return			: 
    Argument 		:
    Comments		: Memory copy using DMA
-----------------------------------------------------------------------*/
void DMACMemCopy(smtUint8 channel, 
			unsigned char *dest, unsigned char *src, unsigned nbytes)
{
	unsigned int m2m = 1;		// Memory2Memory Transfer
	unsigned int srcIncr = 1;	// Source Increment
	unsigned int destIncr = 1;	// Destination Increment
	unsigned int Width = 2;		// WORD
	unsigned int size = 5;		// 32 byte
	unsigned int transferLen;

	if(nbytes == 0)
		return;
	while(nbytes > 0)
	{
		if(nbytes > 65532)
			transferLen = 65532;
		else
			transferLen = nbytes;
			
		SMT_WRITE(DMACSAdr(channel), (unsigned)src);
		
		SMT_WRITE(DMACDAdr(channel), (unsigned)dest);
		
		SMT_WRITE(DMACCon(channel), 
			 (m2m<<29)|(Width<<26)|(srcIncr<<28)
			|(destIncr<<25)|(Width<<23)
			|(size<<20)|transferLen);
			
		SMT_WRITE(DMACDescrp(channel), 1);
		
		SMT_WRITE(DMACSta(channel), 0x8000001F);

		while(1)
		{
			// Stop/Error Interrupt Check
			if(SMT_READ(DMACSta(channel)) & 0x00000009)	
				break;
		}

		// Error Interrupt
		if(SMT_READ(DMACSta(channel)) & 0x00000001)	
		{
			//GPIOWrite(0xdead);
			SMT_WRITE(GPIO0_OUT, 0xdead);
			while(1) ;
		}
		nbytes -= transferLen;
	}
}


/*/////////////////////////////////////////////////////////
        I2S FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : AudioCodecInit()
    Prototype       : void AudioCodecInit(void)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
static smtInt32 AudioCodecInit(void)
{
	static smtInt32 initialized = 0;

	if(initialized)
		return 0;

	UARTPrintf("Philips UDA1341 Setting...");
	
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
	UARTPrintf("Done\n");

	return 0;
}
/*-----------------------------------------------------------------------
    Function name   : BGMEnable()
    Prototype       : void BGMEnable(void)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
static void BGMEnable(void)
{
	smtInt32 i;
	smtUint32 fifo_depth;
	smtUint32 preload;
	
	I2S_CLOCK_MODE	I2SClkMode;
	I2S_CONTROL		I2SCtrl;
	I2S_STATUS_DAT	I2SStatus;	
	smtUint32		tIdx;	
	smtUint32		offset;
	smtUint32		timeOut;
	smtUint32		regValue;
	
	// I2S TX clock configure
	I2SClkMode.ClkMaster	= 0x1;					// master mode
	I2SClkMode.LRClkInv		= 0x0;					// L/R clock no inversion
	I2SClkMode.MClkOn		= 0x1;					// Mclk on
	I2SClkMode.MClkOE		= 0x1;					// Mclk enable
	I2SClkMode.DTORatio		= I2ST_DTO_44100;		// 44100 sample rate
	smtSetClockMode(&I2SClkMode);
	
	// I2S TX configure
	I2SCtrl.DMAIntEn		= 0x0;					// DMA disable
	I2SCtrl.FifoOURIntEn	= 0x0;					// underrun disable
	I2SCtrl.WLen			= I2ST_BW_16BIT;		// 16bits sample width 
	I2SCtrl.Ljust			= 0x0;					// I2S mode
	I2SCtrl.FifoTH			= I2ST_FIFO_TH;			// DMA burst length
	smtSetI2SMode(I2S_DIR_TX, &I2SCtrl);		
	smtI2SEnable(I2S_DIR_TX, 0);	
	
	// Audio codec reset
	AudioCodecInit();
	
	// DMA enable for descript type DMA
	i2s_tx_dmach = DMAChannelAlloc(DMA_I2STX);
	
	
#ifdef USE_DMA
	
	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);			
	
	// I2S run
	smtI2SFIFOReset(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);			
	
	// 1 MB sound data = 32 x 32 KB
	for(i = 0; i < 32; i++)	
	{
		tx_dma_desc_loop[i].src_addr 	= (smtUint32)&sounddata[i*0x8000/4];
		tx_dma_desc_loop[i].dest_addr 	= (smtUint32)(&I2S_DATA);
		tx_dma_desc_loop[i].control 	= ((0x8000)
									 | (0x0<<31)	
									 | (0x0<<30)
									 | (0x0<<29)
									 | (0x1<<28)
									 | (0x2<<26)
									 | (0x0<<25)
									 | (0x2<<23)
									 | (0x5<<20)
									 );
						 
		if(i != 31)
		{
			tx_dma_desc_loop[i].desc_addr = (smtUint32)&tx_dma_desc_loop[i+1];
		}
	}
	tx_dma_desc_loop[31].desc_addr = (smtUint32)&tx_dma_desc_loop[0];
	
	// first 16 sample already in fifo
	tx_start_dma_desc.src_addr 		= (smtUint32)&sounddata[preload];	
	tx_start_dma_desc.dest_addr		= (smtUint32)(&I2S_DATA);
	tx_start_dma_desc.control 		= ((0x8000-preload*4)
									 | (0x0<<31)	
									 | (0x0<<30)
									 | (0x0<<29)
									 | (0x1<<28)
									 | (0x2<<26)
									 | (0x0<<25)
									 | (0x2<<23)
									 | (0x5<<20)
									 );
									 
	tx_start_dma_desc.desc_addr 	= (smtUint32)&tx_dma_desc_loop[1];	
	DMACUseDescrp(i2s_tx_dmach, (smtUint32)(&tx_start_dma_desc));


	
#else

	// I2S stop 
	smtI2SEnable(I2S_DIR_TX, 0);		

	// I2S run
	smtI2SFIFOReset(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);	
	
	for(tIdx = 0; tIdx <  128*1024/2; tIdx++) 
	{
		
		// check fifo wait FIFO is not full
		while(true) 
		{
			smtI2SGetStatus(I2S_DIR_TX, &I2SStatus);	
			if(I2SStatus.FIFOL != 32) break;
		}
		
		smtI2SSetData(sounddata[tIdx]);	
	}

#endif
}

/*-----------------------------------------------------------------------
    Function name   : AudioDelayedLoopbackEnable()
    Prototype       : void AudioDelayedLoopbackEnable(void)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
static void AudioDelayedLoopbackEnable(void)
{
	smtInt32 i;
	smtUint32 loopback_start_addr = AUDIO_TESTADDR;
	
	I2S_CLOCK_MODE	I2SClkMode;
	I2S_CONTROL		I2SCtrl;

	// I2S TX disable
	smtI2SEnable(I2S_DIR_TX, 0);
	
	// I2S RX disable
	smtI2SEnable(I2S_DIR_RX, 0);		

	// I2S TX clock configure
	I2SClkMode.ClkMaster	= 0x1;					// master mode
	I2SClkMode.LRClkInv		= 0x0;					// L/R clock no inversion
	I2SClkMode.MClkOn		= 0x1;					// Mclk on
	I2SClkMode.MClkOE		= 0x1;					// Mclk enable
	I2SClkMode.DTORatio		= I2ST_DTO_44100;		// 44100 sample rate
	smtSetClockMode(&I2SClkMode);
	
	// I2S TX configure
	I2SCtrl.DMAIntEn		= 0x0;					// DMA disable
	I2SCtrl.FifoOURIntEn	= 0x0;					// underrun disable
	I2SCtrl.WLen			= I2ST_BW_16BIT;		// 16bits sample width 
	I2SCtrl.Ljust			= 0x0;					// I2S mode
	I2SCtrl.FifoTH			= I2ST_FIFO_TH;			// DMA burst length
	smtSetI2SMode(I2S_DIR_TX, &I2SCtrl);		
	smtI2SEnable(I2S_DIR_TX, 0);	
	
	// I2S RX configure
	I2SCtrl.DMAIntEn		= 0x0;					// DMA disable
	I2SCtrl.FifoOURIntEn	= 0x0;					// overrun disable
	I2SCtrl.WLen			= I2ST_BW_16BIT;		// 16bits sample width 
	I2SCtrl.Ljust			= 0x0;					// I2S mode
	I2SCtrl.FifoTH			= I2ST_FIFO_TH;			// DMA burst length
	smtSetI2SMode(I2S_DIR_RX, &I2SCtrl);		
	smtI2SEnable(I2S_DIR_RX, 0);					
	
	// audio codec init
	AudioCodecInit();

	// I2S run
	smtI2SFIFOReset(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 1);

	smtI2SFIFOReset(I2S_DIR_RX);
	smtI2SEnable(I2S_DIR_RX, 1);
	
	// clearing data first
	for(i = 0; i < 0x8000*32/4; i++)
		*(((smtUint32 *)loopback_start_addr)+i) = 0;

	for(i = 0; i < 32; i++)	// 1 MB sound data = 32 x 32 KB
	{
		tx_dma_desc_loop[i].src_addr 	= loopback_start_addr + 0x8000*i;;
		tx_dma_desc_loop[i].dest_addr 	= (smtUint32)(&I2S_DATA);
		tx_dma_desc_loop[i].control 	= 0x06258000;
		tx_dma_desc_loop[i].control 	= ((0x8000)
									 | (0x0<<31)	
									 | (0x0<<30)
									 | (0x0<<29)
									 | (0x1<<28)
									 | (0x2<<26)
									 | (0x0<<25)
									 | (0x2<<23)
									 | (0x5<<20)
									 );
		if(i != 31)
			tx_dma_desc_loop[i].desc_addr = (smtUint32)&tx_dma_desc_loop[i+1];

		rx_dma_desc_loop[i].dest_addr 	= loopback_start_addr + 0x8000*i;
		rx_dma_desc_loop[i].src_addr 	= (smtUint32)(&I2S_DATA);
		rx_dma_desc_loop[i].control 	= ((0x8000)
									 | (0x0<<31)	
									 | (0x0<<30)
									 | (0x0<<29)
									 | (0x0<<28)
									 | (0x2<<26)
									 | (0x1<<25)
									 | (0x2<<23)
									 | (0x5<<20)
									 );
		if(i != 31)
			rx_dma_desc_loop[i].desc_addr = (smtUint32)&rx_dma_desc_loop[i+1];
	}
	tx_dma_desc_loop[31].desc_addr = (smtUint32)&tx_dma_desc_loop[0];
	rx_dma_desc_loop[31].desc_addr = (smtUint32)&rx_dma_desc_loop[0];

	i2s_tx_dmach = DMAChannelAlloc(DMA_I2STX);
	i2s_rx_dmach = DMAChannelAlloc(DMA_I2SRX);
	DMACUseDescrp(i2s_tx_dmach, (smtUint32)(&tx_dma_desc_loop[0]));
	DMACUseDescrp(i2s_rx_dmach, (smtUint32)(&rx_dma_desc_loop[31]));
}

/*-----------------------------------------------------------------------
    Function name   : BGMTest()
    Prototype       : void BGMTest(void)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
void BGMTest(void)
{
	smtInt32 i;
	smtInt32 count;

	BGMEnable();
	i = 0;
	while(1)
	{
		char uart_input;
		count = 100000;
		//GPIOWrite(i);
		SMT_WRITE(GPIO0_OUT, i);
		i++;
		if(smtUartDataAvailable())
		{
			uart_input = UARTGetch();
			if(uart_input == '0') 
			{
				break;
			}
		}
		i &= 0xfffff;
		while(count--);
	}

	
	// Clean Up
	smtI2SFIFOReset(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 0);
	
	DMAChannelFree(i2s_tx_dmach);
	DMACDisable(i2s_tx_dmach);
}

/*-----------------------------------------------------------------------
    Function name   : AudioDelayedLoopback()
    Prototype       : void AudioDelayedLoopback(void)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
void AudioDelayedLoopback(void)
{
	smtInt32 i;
	smtInt32 count;

	AudioDelayedLoopbackEnable();
	i = 0;
	while(1)
	{
		char uart_input;
		count = 100000;
		//GPIOWrite(i);
		SMT_WRITE(GPIO0_OUT, i);
		i++;
		if(smtUartDataAvailable())
		{
			uart_input = UARTGetch();
			if(uart_input == '0')
				break;
		}
		i &= 0xfffff;
		while(count--);
	}

	// Clean Up
	smtI2SFIFOReset(I2S_DIR_TX);
	smtI2SEnable(I2S_DIR_TX, 0);
	
	DMAChannelFree(i2s_tx_dmach);
	DMAChannelFree(i2s_rx_dmach);
	DMACDisable(i2s_tx_dmach);
	DMACDisable(i2s_rx_dmach);
}



