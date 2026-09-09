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
//#include <reg51.h>
#include "mmc8052.h"
#include "syscfg.h"

/*
//////////////////////////////////////////////////////////////////////////////
/	REGISTER DEFINITION
//////////////////////////////////////////////////////////////////////////////
*/

/* NAND Controller */
#define	NAND_BASEADDR	(DEVICE_STARTADDR+0x8000)
#define NFOPER0			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x00))
#define NFOPER1			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x01))
#define NFOPER2			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x02))
#define NFOPER3			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x03))
#define NFDATA			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x04))
#define NFCONF0			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x05))
#define NFCONF1			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x06))
#define NFCONF2			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x07))
#define NFCTRL0			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x08))
#define NFCTRL1			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x09))
#define NFSTAT0			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x0A))
#define NFSTAT1			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x0B))
#define NFSTAT2			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x0C))
#define NFSTAT3			(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x0D))
#define NFFIFOSTAT0		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x0E))
#define NFFIFOSTAT1		(*(volatile unsigned char xdata *)(NAND_BASEADDR+0x0F))

#define NFCOPER0(x)		(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x00)+(x*0x10)))
#define NFCOPER1(x)		(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x01)+(x*0x10)))
#define NFCOPER2(x)		(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x02)+(x*0x10)))
#define NFCOPER3(x)		(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x03)+(x*0x10)))
#define NFCDATA(x)		(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x04)+(x*0x10)))
#define NFCCONF0(x)		(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x05)+(x*0x10)))
#define NFCCONF1(x)		(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x06)+(x*0x10)))
#define NFCCONF2(x)		(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x07)+(x*0x10)))
#define NFCCTRL0(x)		(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x08)+(x*0x10)))
#define NFCCTRL1(x)		(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x09)+(x*0x10)))
#define NFCSTAT0(x)		(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x0A)+(x*0x10)))
#define NFCSTAT1(x)		(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x0B)+(x*0x10)))
#define NFCSTAT2(x)		(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x0C)+(x*0x10)))
#define NFCSTAT3(x)		(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x0D)+(x*0x10)))
#define NFCFIFOSTAT0(x)	(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x0E)+(x*0x10)))
#define NFCFIFOSTAT1(x)	(*(volatile unsigned char xdata *)((NAND_BASEADDR+0x0F)+(x*0x10)))

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
