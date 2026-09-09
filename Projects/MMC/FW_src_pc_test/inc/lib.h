/*----------------------------------------------------------
	 MMC controller SOC
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2007 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: lib.h
	Description	: Basic peripheral header file
----------------------------------------------------------*/
#ifndef __LIB_H__
#define __LIB_H__

/*
/////////////////////////////////////////////////////////
	INCLUDE
///////////////////////////////////////////////////////// 
*/
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>

#include "sysinc.h"
#include "structdef.h"
#include "commonmacro.h"

/*
/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// 
*/
	
#define NO_ERROR			0
#define NAND_ERROR			10
#define RS_ERROR			11
#define SDMMC_ERROR		12
#define SRAM_ERROR			13


/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

smtBoolean smtDelay100us(smtInt16 time);


/*---------------------------------------------------------
	Peripheral (8051)
--------------------------------------------------------- */
void smtExtIntInitial(void);
void smtTimer0Initial(void);


/*---------------------------------------------------------
	POWER MANAGEMENT
--------------------------------------------------------- */
smtBoolean smtPower(PM_PWR_MODE pwrMode);


/*---------------------------------------------------------
	Reed Solomon
--------------------------------------------------------- */
smtBoolean smtRSSetMode(void);


/*---------------------------------------------------------
	MEMORY (SRAM)
--------------------------------------------------------- */
smtBoolean smtSRAMSetMode(ESMC_CON sramCtrl, smtUint8 bankSel);
smtBoolean smtSRAMGetMode(ESMC_CON sramCtrl, smtUint8 bankSel);
smtBoolean smtMemWrite(smtUint16 addr, smtUint16 *dat, smtUint16 length);
smtBoolean smtMemRead(smtUint16 addr, smtUint16 *dat, smtUint16 length);


/*---------------------------------------------------------
	UART
--------------------------------------------------------- */
smtUint32 smt2UartPutCh(smtUint8 ch);
smtUint8 smt2UartGetCh(void);
smtUint32 smt2UartPutStr(smtInt8 * str);
smtUint32 smt2UartGetStr(smtUint8 *pData, smtUint8 dataCnt);
smtUint32 smt2UartPrint(smtInt32 dispLvl, smtInt8 *format, ...);
static smtUint32 UARTGetBaudrate(smtUint32 baudrate);
smtUint32 smt2UartInit(void);
smtUint32 smt2UartDeInit(void);

/*---------------------------------------------------------
	Dynamic Loader
--------------------------------------------------------- */
void dynamicLoader(void);
void ftlLoading(void);
void jmpToFtl(void);

/*---------------------------------------------------------
	SD/MMC Command Parser
--------------------------------------------------------- */
void sdmmcCmdParser(void);

#endif /* __LIB_H__ */

