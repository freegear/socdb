/*----------------------------------------------------------
	 MMC controller SOC
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2007 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: structdef.h
	Description	: Struct definition header file
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
	smtUint16 waitLockCnt;// Wait lock time count
	smtBoolean pllLocked;	// System pll locked status
} PM_RESET_CON;

typedef struct
{
	PM_RESET_CON resetControl;
	PM_CLK_CON clkControl;
	PM_CLK_DIV clkDivide;
	PM_SYS_PLL systemPll;
} PM_POWER;


/*----------------------------------------------------------
        NAND
-----------------------------------------------------------*/


/*----------------------------------------------------------
        Reed Solomon
-----------------------------------------------------------*/


/*----------------------------------------------------------
        SD/MMC
-----------------------------------------------------------*/


/*----------------------------------------------------------
        SRAM (External)
-----------------------------------------------------------*/
typedef enum
{
	SMC_BANK0,
	SMC_BANK1,
	SMC_BANK2,
	SMC_BANK3
} SRAM_BANK;

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


#endif  /* __STRUCTDEF_H__ */
