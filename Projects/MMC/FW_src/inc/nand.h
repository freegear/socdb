/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: nand.h
	Description		: nand driver header file
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __NAND_H__
#define __NAND_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "commonmacro.h"
#include "sysinc.h"

/*
/////////////////////////////////////////////////////////
        TYPEDEF
///////////////////////////////////////////////////////// 
*/
/*----------------------------------------------------------
	NAND controller structure
	
		NandOpt0
		NandOpt1
		NandOpt2
		NAND_DAT	
		NandCfg
		NandCtrl
		NAND_STA
		NandEcc
		NandEccStat
	
-----------------------------------------------------------*/

typedef struct 
{
	smtUint8	chipSel;	
	smtUint8	option;
	smtUint16	dataSize;
	smtUint8	opMode;
	smtUint8	TransSize;
	smtUint8	cmdAddrTransByte;
	smtUint8	cmdAddrFlag;
}	NandOpt0;

typedef struct 
{
	smtUint8	CMDADDR[4];
}	NandOpt1;

typedef struct 
{

	smtUint8	CMDADDR[4];
}	NandOpt2;


typedef struct 
{
	smtBoolean	nandBootEn;	
	smtBoolean	IOWidth;
	smtUint8	bootCfg;
	smtBoolean	OutDtmn;
	smtUint8	TADLTWB;
	smtUint8	TCALS;
	smtUint8	TRWLP;
	smtUint8	TRWHP;
	
}	NandCfg;

typedef struct 
{
	smtBoolean	NFCtrlRst;	
	smtUint8	FIFOLevel;
	smtBoolean	Ecc512byteEn;
	smtBoolean	autoEccWr;
	smtBoolean	DMAEn;
	smtBoolean	wrEndIntEn;
	smtBoolean	rdEndIntEn;
	smtBoolean	eccErrIntEn;
	smtBoolean	FIFOIntEn;
	smtBoolean	RnBintEn3;
	smtBoolean	RnBintEn2;
	smtBoolean	RnBintEn1;
	smtBoolean	RnBintEn0;
	
}	NandCtrl;

typedef struct 
{
	smtBoolean	NFCtrlBusy;
	smtBoolean	NFStatValid;
	smtUint16	NFStatus;			// change from 8bits to 16bits
	smtBoolean	wrEnd;
	smtBoolean	rdEnd;
	smtBoolean	wrFIFOReady;
	smtBoolean	rdFIFOReady;
	
	smtBoolean 	RnBDetect3;
	smtBoolean 	RnBDetect2;
	smtBoolean 	RnBDetect1;
	smtBoolean 	RnBDetect0;
	
	smtBoolean	RnBSTAT3;
	smtBoolean	RnBSTAT2;
	smtBoolean	RnBSTAT1;
	smtBoolean	RnBSTAT0;
	
}	NandStat;

typedef struct 
{
	smtUint8	DFIFOLevel1;
	smtUint8	DFIFOLevel0;
	smtUint8	QLevel;
	
}	NandFifoStat;

typedef enum
{
	NAND_CH0,
	NAND_CH1,
	NAND_CH_MAX
} NandChannel;
/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////
*/
void smtNANDSetOPT0(NandChannel ch, NandOpt0 *popt0);
void smtNANDSetOPT1(NandChannel ch, NandOpt1 *popt1);
void smtNANDSetOPT2(NandChannel ch, NandOpt2 *popt2);

void smtNANDSetDataHalfWD(NandChannel ch, smtUint16 *pData);
void smtNANDSetDataByte(NandChannel ch, smtUint8 *pData);
void smtNANDGetDataHalfWD(NandChannel ch, smtUint16 *pData);
void smtNANDGetDataByte(NandChannel ch, smtUint8 *pData);

void smtNANDGetCfg(NandChannel ch, NandCfg *pconfig);
void smtNANDSetCfg(NandChannel ch, NandCfg *pconfig);

void smtNANDGetControl(NandChannel ch, NandCtrl *pcontrol);
void smtNANDSetControl(NandChannel ch, NandCtrl *pcontrol);

void smtNANDGetStatus(NandChannel ch, NandStat *pstatus);
void smtNANDSetStatus(NandChannel ch, NandStat *pstatus);

void smtNANDGetFIFOStatus(NandChannel ch, NandFifoStat *pfifoStatus);

#endif //__NAND_H__


