#ifndef __NAND_PRE_DRV_H__
#define	__NAND_PRE_DRV_H__

#include "sysinc.h"

/*----------------------------------------------------------
	NAND controller structure
	
		NAND_OPT0
		NAND_OPT1
		NAND_OPT2
		NAND_DAT	
		NAND_CFG
		NAND_CTRL
		NAND_STA
		NAND_ECC
		NAND_ECC_STAT
	
-----------------------------------------------------------*/

typedef struct 
{
	smtBoolean	chipSel;	
	smtUint8	option;
	smtUint16	dataSize;
	smtUint8	opMode;
	smtUint8	TransSize;
	smtUint8	cmdAddrTransByte;
	smtUint8	cmdAddrFlag;
}	NAND_OPT0;

typedef struct 
{
	smtUint8	CMDADDR[4];
}	NAND_OPT1;

typedef struct 
{

	smtUint8	CMDADDR[4];
}	NAND_OPT2;


typedef struct 
{
	smtBoolean	nandBootEn;	
	smtBoolean	IOWidth;
	smtBoolean	NandWidth;
	smtUint8	bootCfg;
	smtBoolean	OutDtmn;
	smtUint8	TADLTWB;
	smtUint8	TCALS;
	smtUint8	TRWLP;
	smtUint8	TRWHP;
	
}	NAND_CFG;

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
	smtBoolean	RnBintEn1;
	smtBoolean	RnBintEn0;
	
}	NAND_CTRL;

typedef struct 
{
//	smtBoolean	eccErr;	
//	smtUint8	NFQueLevel;
	smtBoolean	NFCtrlBusy;
	smtBoolean	NFIDValid;
	smtBoolean	NFStatValid;
	smtUint16	NFStatus;			// change from 8bits to 16bits
	smtBoolean	wrEnd;
	smtBoolean	rdEnd;
	smtBoolean	wrFIFOReady;
	smtBoolean	rdFIFOReady;
//	smtBoolean 	RnBDetect1;
	smtBoolean 	RnBDetect0;
//	smtBoolean	RnBSTAT1;
	smtBoolean	RnBSTAT0;
	
}	NAND_STAT;

typedef struct 
{
	smtUint8	DFIFOLevel1;
	smtUint8	DFIFOLevel0;
	smtUint8	QLevel;
	
}	NAND_FIFOSTAT;

typedef struct 
{
	smtUint32	ecc[16];
	smtUint32	secc[16];
	
}	NAND_ECC;

typedef struct 
{
	smtBoolean	eccErr[16];	
	smtBoolean	seccErr[16];	
	
}	NAND_ECC_STAT;



/*----------------------------------------------------------
	NAND controller interface
	
	#operation config /command/address
		- smtNANDSetOPT0
		- smtNANDSetOPT1
		- smtNANDSetOPT2
		- smtNANDSetData
		- smtNANDGetData
		
	# config
		- smtNANDGetCfg/smtNANDSetCfg

	# control
		- smtNANDGetControl/smtNANDSetControl
		
	# status
		- smtNANDGetStatus/smtNANDSetStatus
		
	# ecc
		- smtNANDGetECC
		- smtNANDGetECCStatus
		
-----------------------------------------------------------*/
void smtNANDSetOPT0(NAND_OPT0 *popt0);
void smtNANDSetOPT1(NAND_OPT1 *popt1);
void smtNANDSetOPT2(NAND_OPT2 *popt2);
void smtNANDSetData(smtUint32 *pdata);
smtUint32 smtNANDGetData(void);

void smtNANDGetCfg(NAND_CFG *pconfig);
void smtNANDSetCfg(NAND_CFG *pconfig);

void smtNANDGetControl(NAND_CTRL *pcontrol);
void smtNANDSetControl(NAND_CTRL *pcontrol);

void smtNANDGetStatus(NAND_STAT *pstatus);
void smtNANDSetStatus(NAND_STAT *pstatus);

void smtNANDGetFIFOStatus(NAND_FIFOSTAT *pfifoStatus);

void smtNANDGetECC(smtUint8 eccIdx, smtUint32 *pecc, smtUint32 *psecc);

#endif
