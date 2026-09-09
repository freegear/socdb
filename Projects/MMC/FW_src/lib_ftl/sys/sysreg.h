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
#include <reg51.h>
#endif
#include "syscfg.h"

/*
//////////////////////////////////////////////////////////////////////////////
/	REGISTER DEFINITION
//////////////////////////////////////////////////////////////////////////////
*/

/* NAND Controller */
#define	NAND_BASEADDR	(DEVICE_STARTADDR+0x8000)
#define	NANDNFOPER		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x00))
#define	NANDDATA            	(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x04))
#define	NANDCONF			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x08))
#define	NANDCTRL            	(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x0C))
#define	NANDSTAT            	(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x10))
#define	NANDFIFOSTAT		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x14))

#define	ECCSECTOR0			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x18))
#define	ECCSECTOR1			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x1c))
#define	ECCSECTOR2			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x20))
#define	ECCSECTOR3			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x24))
#define	ECCSECTOR4			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x28))
#define	ECCSECTOR5			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x2c))
#define	ECCSECTOR6			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x30))
#define	ECCSECTOR7			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x34))
#define	ECCSECTOR8			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x38))
#define	ECCSECTOR9			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x3c))
#define	ECCSECTOR10		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x40))
#define	ECCSECTOR11		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x44))
#define	ECCSECTOR12		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x48))
#define	ECCSECTOR13		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x4c))
#define	ECCSECTOR14		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x50))
#define	ECCSECTOR15		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x54))

#define	SECCSECTOR0		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x58))
#define	SECCSECTOR1		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x5c))
#define	SECCSECTOR2		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x60))
#define	SECCSECTOR3		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x64))
#define	SECCSECTOR4		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x68))
#define	SECCSECTOR5		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x6c))
#define	SECCSECTOR6		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x70))
#define	SECCSECTOR7		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x74))

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
