/*------------------------------------------------------------------------------
    File Name   : sysreg.h
    Description : Special function register definition
------------------------------------------------------------------------------*/

#ifndef __MMC_SOC_H__
#define __MMC_SOC_H__

#ifdef __cplusplus
extern "C" {
#endif

/*
//////////////////////////////////////////////////////////////////////////////
//	INCLUDE
//////////////////////////////////////////////////////////////////////////////
*/
#ifndef WIN32
//#include <reg51.h>
#include "mmc8052.h"
#endif
#include "syscfg.h"

/*
//////////////////////////////////////////////////////////////////////////////
/	REGISTER DEFINITION
//////////////////////////////////////////////////////////////////////////////
*/
#ifndef WIN32
sfr MMCRAMCTRL = 0x84;
sfr NANDRAM0SEL = 0x85;
sfr NANDRAM1SEL = 0x86;

sfr DMA0CTRL 		= 0x8F;
sfr DMA0SIZE_L 		= 0x92;
sfr DMA0SIZE_H 		= 0x93;
sfr DMA0START_L	 	= 0x94;
sfr DMA0START_H 	= 0x95;

sfr DMA1CTRL 		= 0x96;
sfr DMA1SIZE_L 		= 0x97;
sfr DMA1SIZE_H 		= 0x9A;
sfr DMA1START_L 	= 0x9B;
sfr DMA1START_H 	= 0x9C;

sfr NF0_OPER0 = 0x9D;
sfr NF0_OPER1 = 0x9E;
sfr NF0_OPER2 = 0x9F;
sfr NF0_OPER3 = 0xA1;
sfr NF0_CONF0 = 0xA2;
sfr NF0_CONF1 = 0xA3;
sfr NF0_CONF2 = 0xA4;
sfr NF0_CTRL0 = 0xA5;
sfr NF0_CTRL1 = 0xA6;
sfr NF0_STAT0 = 0xA7;
sfr NF0_STAT1 = 0xAA;
sfr NF0_STAT2 = 0xAB;
sfr NF0_STAT3 = 0xAC;
sfr NF0_FIFOSTAT0 = 0xAD;
sfr NF0_FIFOSTAT1 = 0xAE;

sfr NF1_OPER0 = 0xAF;
sfr NF1_OPER1 = 0xB1;
sfr NF1_OPER2 = 0xB2;
sfr NF1_OPER3 = 0xB3;
sfr NF1_CONF0 = 0xB4;
sfr NF1_CONF1 = 0xB5;
sfr NF1_CONF2 = 0xB6;
sfr NF1_CTRL0 = 0xBA;
sfr NF1_CTRL1 = 0xBB;
sfr NF1_STAT0 = 0xBC;
sfr NF1_STAT1 = 0xBD;
sfr NF1_STAT2 = 0xBE;
sfr NF1_STAT3 = 0xBF;
sfr NF1_FIFOSTAT0 = 0xC1;
sfr NF1_FIFOSTAT1 = 0xC2;
#endif

/* Reed Solomon */
#define RS_BASE_ADDR		(DEVICE_STARTADDR+0x0)



/* SD/MMC Controller */
#define MMC_BASEADDR		(DEVICE_STARTADDR+0x0000)
#define SDCON				(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x00))
#define SDPRE				(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x04))
#define SDCmdArg			(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x08))
#define SDCmdCon			(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x0C))
#define SDCmdSta			(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x10))
#define SDRSP0				(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x14))
#define SDRSP1				(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x18))
#define SDRSP2				(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x1C))
#define SDRSP3				(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x20))
#define SDDTimer			(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x24))
#define SDBSize				(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x28))
#define SDDatCon				(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x2C))
#define SDDatCnt				(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x30))
#define SDDatSta				(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x34))
#define SDFSTA				(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x38))
#define SDIntMsk				(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x3C))
#define SDIntSta				(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x40))
#define SDDAT				(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x44))
#define SDAutoReadCon		(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x48))
#define SDAutoReadSta		(*(volatile unsigned char xdata *)(MMC_BASEADDR+0x4C))

/* SRAM (External) */
#define ESMC_BASEADDR		(DEVICE_STARTADDR+0x9000)
#define ESMC_B0_CON     		(*(volatile unsigned *)(ESMC_BASEADDR+0x00))
#define ESMC_B1_CON     		(*(volatile unsigned *)(ESMC_BASEADDR+0x04))
#define ESMC_B2_CON     		(*(volatile unsigned *)(ESMC_BASEADDR+0x08))
#define ESMC_B3_CON     		(*(volatile unsigned *)(ESMC_BASEADDR+0x0C))


/*
/////////////////////////////////////////////////////////
        REGISTER MASK DEFINITION
///////////////////////////////////////////////////////// 
*/

/* NAND Controller */


/* Reed Solomon */


/* SD/MMC Controller */


/* SRAM (External) */


#ifdef __cplusplus
}
#endif
#endif /*__MMC_SOC_H___*/
