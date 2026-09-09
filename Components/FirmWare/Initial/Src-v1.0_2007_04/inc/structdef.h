/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: structdef.h
	Description	: SDI V5 struct definition header file
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __STRUCTDEF_H__
#define __STRUCTDEF_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "sysinc.h"

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
        Internal flash
-----------------------------------------------------------*/
typedef enum
{
	FM_ERASE_CHIP			= 0x1,
	FM_ERASE_SECTOR		= 0x2,
	FM_PROGRAM			= 0x4,
	FM_PROGRAM_OPTION	= 0x20
} FM_OPERATION_MODE;

typedef enum
{
	OPTION_SMART,
	OPTION_PROTECT_HW,
	OPTION_PROTECT_RD
} FM_OPTION_TYPE;

typedef struct
{
	smtUint32 addr;
	smtUint32 data;
	smtUint32 length;
	smtUint32 mode;
} FM_STRUCT;    // Flash memory struct

typedef struct
{
	/*
	smtBoolean chipEraseEn;
	smtBoolean sectorEraseEn;
	smtBoolean ProgramEn;
	smtBoolean optionProgEn;
	*/
	smtUint8 mode;
	smtBoolean cpuHold;
	smtBoolean operation;
	smtBoolean oscEn;
	smtUint8 waitReg;
} FMC_STRUCT;   // Flash memory controller struct

/*----------------------------------------------------------
        External sram
-----------------------------------------------------------*/
typedef enum
{
	SMC_BANK0,
	SMC_BANK1,
	SMC_BANK2,
	SMC_BANK3
} ESMC_BANK;

typedef struct
{
	smtUint8 aSetup;		// Address setup time
	smtUint8 csSetup;		// Chip select setup time
	smtUint8 access;		// Access time
	smtUint8 csHold;		// Chip select hold time
	smtUint8 aHold;		// Address hold time
	smtUint8 busWidth;	// Data but width
	smtUint8 addrShift;	// Address shift
} ESMC_CON;


/*----------------------------------------------------------
        External sdram
-----------------------------------------------------------*/
typedef enum
{
	ESDRAM_16M,
	ESDRAM_32M,
	ESDRAM_64M,
	ESDRAM_128M
} ESDMC_COL_ADDRSIZE;

typedef struct
{
	smtUint8 tRowCycle;		// Row cycle time
	smtUint8 tRowActive;		// Minumum row active time
	smtUint8 tCasLatency;		// Cas latency
	smtUint8 tDelay;			// Ras to cas delay
	smtUint8 tPrecharge;		// Precharge time
} ESDMC_TCON;

typedef struct
{
	smtBoolean bitSel;		// SDRAM 16bit select
	smtUint8 colAddrSize;		// Column address size
	smtBoolean addrSwapEn;	// Address swap enable
	smtBoolean sdramEn;		// SDRAM enable
} ESDMC_CON;

typedef struct
{
	smtUint16 pwdnRef;		// Auto power down count
	smtBoolean selfRefEn;		// Auto power down enable
	smtBoolean pwdnEn;		// SDRAM self refresh enable
}ESDMC_PWR_CON;

typedef struct
{
	smtUint16 refCount;		// Refresh count
	smtUint8 refNum;			// Refresh number
}ESDMC_REF_CON;

/*----------------------------------------------------------
        E-DMA
-----------------------------------------------------------*/
#define DMA_CHALLOC		1
#define DMA_CHDALLOC	0

//////////////////////////////////////////////
//DMA Control Register
//////////////////////////////////////////////
#define EDMA_MAX_CHANNEL	0x08
typedef void (*ptDMAIntFunction)(smtUint32 irq);
typedef enum
{
	EDMA_CH_0 = 0x0,
	EDMA_CH_1 = 0x1,
	EDMA_CH_2 = 0x2,
	EDMA_CH_3 = 0x3,
	EDMA_CH_4 = 0x4,
	EDMA_CH_5 = 0x5,
	EDMA_CH_6 = 0x6,
	EDMA_CH_7 = 0x7
} EdmaChannel;
typedef enum
{
	DMA_BUSWIDTH8	= 0x00,
	DMA_BUSWIDTH16	= 0x01,
	DMA_BUSWIDTH32	= 0x02
} DmaBusWidth;

typedef enum
{
	DMA_TRANSSIZE1	= 0x00,
	DMA_TRANSSIZE2	= 0x01,
	DMA_TRANSSIZE4	= 0x02,
	DMA_TRANSSIZE8	= 0x03,
	DMA_TRANSSIZE16	= 0x04,
	DMA_TRANSSIZE32	= 0x05	
} DmaTransSize;

typedef enum
{
	DMA_ADDR_NOINC	= 0x00,		
	DMA_ADDR_INC	= 0x01
} DmaAddr;

typedef enum
{
	DMADEV_NAND		= 0,
	DMADEV_SEIPTX	= 1,
	DMADEV_SEIPRX	= 2,
	DMADEV_I2STX	= 3,
	DMADEV_I2SRX	= 4,
	DMADEV_SPI0TX	= 5,
	DMADEV_SPI0RX	= 6,
	DMADEV_UART0TX	= 7,
	DMADEV_UART0RX	= 8,
	DMADEV_UART1TX	= 9,
	DMADEV_UART1RX	= 10, 
	DMADEV_NONE		= 0xF 
	
} DmaDevice;

typedef struct 
{
	smtUint8 device;
	smtUint8 free;
} EdmaChAlloc; 


typedef struct
{
	smtUint32 src;
	DmaBusWidth srcWidth;
	smtBoolean srcInc;
	
	smtUint32 dst;
	DmaBusWidth dstWidth;
	smtBoolean dstInc;

	smtUint8 transSize;
	smtUint32 totSize;

	smtBoolean startIntEn;
	smtBoolean stopIntEn;
	smtBoolean endIntEn;	

	smtBoolean enM2M;//shkim-20070418 : new DMA
	smtUint32 descListBase;
	
} EdmaStruct;
/*----------------------------------------------------------
        G-DMA
-----------------------------------------------------------*/
typedef struct
{
	smtUint32 src;
	smtUint32 sWidth, sHeight;
	smtUint32 sClipX, sClipY;

	smtUint32 dst;
	smtUint32 dWidth, dHeight;
	smtUint32 dClipX, dClipY;

	smtUint32 clipWidth, clipHeight;
	
	smtUint32 bpp;

	ptDMAIntFunction intFunction;	
} GdmaStruct;

/*----------------------------------------------------------
        Timer & PWM
-----------------------------------------------------------*/
typedef enum 
{
	TIMER_INTERVAL,
	TIMER_MATCHOVER
} TimerMode;

typedef enum
{
	TIMER_SEL0,
	TIMER_SEL1,
	TIMER_SEL2,
	TIMER_SEL3
} TimerChannel;

typedef struct
{
	smtUint32 data;
	smtUint16 prescale;

	smtUint8 opMode;
	smtBoolean timerClear;
	smtBoolean timerEn;
} TimerProperty;


/*----------------------------------------------------------
        WDT
-----------------------------------------------------------*/
typedef struct
{
	smtUint16 preScale;
	smtUint16 reloadValue;

	smtUint8 div;
	smtBoolean clkSel;
	smtBoolean intEn;
	smtBoolean rstEn;
	smtBoolean wdtEn;
} WdtProperty;


/*----------------------------------------------------------
        GPIO
-----------------------------------------------------------*/
typedef enum
{
	GPIO0_TYPE,
	GPIO1_TYPE
} GpioChannel;

typedef enum
{
	GPIO_MODE_IN	= 0,
	GPIO_MODE_OUT	= 1,

	GPIO_INT_DISABLE	= 0,
	GPIO_INT_ENABLE		= 1,

	GPIO_INT_EDGE		= 0,
	GPIO_INT_LEVEL		= 1,

	GPIO_INT_LOW_POLARITY	= 0,
	GPIO_INT_HIGH_POLARITY	= 1,

	GPIO_INT_SINGLE_EDGE	= 0,
	GPIO_INT_BOTH_EDGE		= 1
} GpioMode;

typedef struct
{
	//smtBoolean gpioMode;		// In/Out mode

	smtUint32 intStatus;
	//smtUint32 intNum;
	smtUint32 intLevel;
	smtUint32 intPolarity;
	smtUint32 intBothEdge;

	smtUint8  gpioNum;
	//smtBoolean gpioChannel;
	
} GpioProperty;



/*----------------------------------------------------------
        VIC
-----------------------------------------------------------*/


/*----------------------------------------------------------
        ADC
-----------------------------------------------------------*/
typedef enum
{
	ADC_NORMAL,
	ADC_STANDBY
} ADC_MODE;

typedef enum
{
	ADC_DISABLE,
	ADC_ENABLE
} ADC_OPERATION;

typedef enum
{
	ADC_CH0,
	ADC_CH1,
	ADC_CH2,
	ADC_CH3,
	ADC_CH4,
	ADC_CH5,
	ADC_CH6,
	ADC_CH7
} ADC_CHANNEL;

typedef struct {
    //smtUint16 adcData;

    smtBoolean adcEnable;
    smtBoolean readStart;
    smtBoolean opMode;
    smtUint8 adcChanSel;
} ADC_STRUCT;


/*----------------------------------------------------------
        Power Management
-----------------------------------------------------------*/
typedef enum
{
	PM_NORMAL,
	PM_SLOW,
	PM_IDLE,
	PM_SLEEP
} PM_PWR_MODE;

typedef struct
{
	smtBoolean slowEn;	// Slow enable operate by external slow clock
	smtBoolean cpuIdlEn;	// CPU only power down enable
	smtBoolean pwdnEn;	// Power downenable
} PM_CLK_CON;


typedef struct
{
	smtUint8 cClkDiv;		// Camera clock divide
	smtBoolean bClkDiv;	// USB clock divide
	smtUint8 aClkDiv;		// ADC clock divide
	smtUint8 uClkDiv;		// UART clock divide
	smtBoolean pClkDiv;	// Peri (AXI APB) bus clock divide
	smtUint8 sClkDiv;		// System(AXI) bus clock divide
} PM_CLK_DIV;

typedef struct
{
	smtBoolean mPllPd;	// System pll power down enable
	smtUint8 mPllFr;		// System pll feedback divide value
	smtUint8 mPllRr;		// System pll input divider value
	smtBoolean mPllOdr;	// System pll output divider value
} PM_SYS_PLL;

typedef struct
{
	smtBoolean uPllPd;	// USB pll power down enable
	smtUint8 uPllFr;		// USB pll feedback divider value
	smtUint8 uPllRr;		// USB pll input divider value
	smtUint8 uPllOdr;		// USB pll output divider value
} PM_USB_PLL;

typedef struct
{
	smtUint16 waitLockCnt;// Wait lock time count
	smtBoolean pllLocked;	// System pll locked status
} PM_RESET_CON;

typedef struct
{
	PM_RESET_CON resetControl;
	PM_CLK_CON clkControl;
	PM_CLK_DIV clkDivide;
	PM_SYS_PLL systemPll;
	PM_USB_PLL usbPll;
} PM_POWER;

#endif  /* __STRUCTDEF_H__ */
