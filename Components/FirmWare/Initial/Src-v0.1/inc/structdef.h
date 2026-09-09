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

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

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
        I2C controller
-----------------------------------------------------------*/
typedef enum
{
	I2C_CH0,
	I2C_CH1
} I2C_CHANNEL;

typedef enum
{
	MASTER_RX,
	MASTER_TX
} I2C_OPMODE;

typedef enum
{
	SEND_NACK,
	SEND_ACK
} I2C_ACK;

typedef enum
{
	INT_DISABLE,
	INT_ENABLE
} I2C_INT;

typedef struct
{
	smtUint16 txPrescale;
	smtUint8 operMode;
	smtUint8 ackEn;
	smtUint8 txRxIntEn;
} I2C_CTRL_STRUCT;

typedef struct
{
	smtBoolean intPendFlag;

	smtBoolean busBusy;
	smtBoolean arbitSta;
	smtBoolean ackValue;
} I2C_STATUS_STRUCT;

/*----------------------------------------------------------
        Video Interface Controller
-----------------------------------------------------------*/
typedef enum
{
	VIF_NO_INT			= 0x0,
	VIF_ENDFRAME		= 0x1,
	VIF_START_FRAME	= 0x2
} VIF_INT_STATUS;

typedef struct
{
	smtUint8 ycOrder;
	smtUint8 startIntEn;
	smtUint8 endIntEn;
	smtUint8 dmaEn;
} VIF_CTRL_STRUCT;

typedef struct
{
	smtUint32 vifDmaAddr;
	smtUint16 vifXPos;
	smtUint16 vifYPos;
	smtUint16 vifXSize;
	smtUint16 vifYSize;
} VIF_PROP_STRUCT;


/*----------------------------------------------------------
        E-DMA
-----------------------------------------------------------*/
typedef enum
{
	DMA_NO_INT	= 0x0,
	DMA_ERRINT		= 0x1,
	DMA_ENINT		= 0x2,
	DMA_STARTINT	= 0x4,
	DMA_STOPINT	= 0x8
} DMA_INT_STATUS;

typedef struct
{
	smtUint32 srcAddr;
	smtUint32 dstAddr;
	smtUint32 control;
	smtUint32 descAddr;
} DMA_STRUCT;

/*----------------------------------------------------------
        G-DMA
-----------------------------------------------------------*/
typedef enum
{
	DMA2D_NO_INT	= 0x0,
	DMA2D_STOPINT	= 0x1,
	DMA2D_ERRINT	= 0x2
} DMA2D_INT_STATUS;

typedef struct
{
	smtUint32 src;
	smtUint32 dst;
	smtUint32 count;

	smtUint16 bytePerLine;
	smtUint16 srcIncSize;
	smtUint16 dstIncSize;
} DMA2D_STRUCT;


/*----------------------------------------------------------
        Timer & PWM
-----------------------------------------------------------*/
typedef enum
{
	TIMER_INTERVAL,
	TIMER_CAPTURE,
	TIMER_MATCHOVER,
	TIMER_PWM
} TIMER_MODE;

typedef enum
{
	TIMER_SEL0,
	TIMER_SEL1,
	TIMER_SEL2,
	TIMER_SEL3,
	TIMER_SEL4,
	TIMER_SEL5,
	TIMER_SEL6,
	TIMER_SEL7
} TIMER_SEL;

typedef struct
{
	smtUint16 data;

	smtBoolean phase;
	smtBoolean clk;
	smtUint8 opMode;
	smtBoolean timerClear;
	smtBoolean timerEn;
	smtUint8 prescale;
} TIMER_STRUCT;


/*----------------------------------------------------------
        WDT
-----------------------------------------------------------*/
typedef enum
{
	WDT_NO_INT	= 0,
	WDT_INT		= 1,

	WDT_NO_RST	= 0,
	WDT_RST		= 1,

	WDT_DISABLE	= 0,
	WDT_ENABLE	= 1
} WDT_STATE;

typedef struct
{
	smtUint16 preScale;
	smtUint16 reloadValue;

	smtUint8 div;
	smtBoolean clkSel;
	smtBoolean intEn;
	smtBoolean rstEn;
	smtBoolean wdtEn;
} WDT_STRUCT;


/*----------------------------------------------------------
        GPIO
-----------------------------------------------------------*/
typedef enum
{
	GPIO0_TYPE,
	GPIO1_TYPE
} GPIO_TYPE;

typedef enum
{
	GPIO_MODE_IN	= 0,
	GPIO_MODE_OUT	= 1,

	GPIO_INT_NO_DETECTED	= 0,
	GPIO_INT_DETECTED		= 1,

	GPIO_INT_DISABLE	= 0,
	GPIO_INT_ENABLE	= 1,

	GPIO_INT_EDGE		= 0,
	GPIO_INT_LEVEL		= 1,

	GPIO_INT_LOW_POLARITY	= 0,
	GPIO_INT_HIGH_POLARITY	= 1,

	GPIO_INT_SINGLE_EDGE	= 0,
	GPIO_INT_BOTH_EDGE	= 1
} GPIO_ENUM;

typedef struct
{
	smtUint32 gpioMode;		// In/Out mode

	smtUint32 intStatus;
	smtUint32 intNum;
	smtBoolean intLevel;
	smtBoolean intPolarity;
	smtBoolean intBothEdge;

	smtUint8 gpioNum;		// GPIO channel
	//smtUint8 gpioData;
} GPIO_STRUCT;

typedef struct
{
} GPIO_INT_STRUCT;


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
