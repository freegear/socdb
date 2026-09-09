#ifndef __NAND_PRE_DRV_H__
#define	__NAND_PRE_DRV_H__

#include "sysinc.h"

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
	smtBoolean	chipSel;	
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
	smtBoolean	NandWidth;
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
	smtBoolean	RnBintEn1;
	smtBoolean	RnBintEn0;
	
}	NandCtrl;

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
	
}	NandStat;

typedef struct 
{
	smtUint8	DFIFOLevel1;
	smtUint8	DFIFOLevel0;
	smtUint8	QLevel;
	
}	NandFifoStat;

typedef struct 
{
	smtUint32	ecc[16];
	smtUint32	secc[16];
	
}	NandEcc;

typedef struct 
{
	smtBoolean	eccErr[16];	
	smtBoolean	seccErr[16];	
	
}	NandEccStat;



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
void smtNANDSetOPT0(NandOpt0 *popt0);
void smtNANDSetOPT1(NandOpt1 *popt1);
void smtNANDSetOPT2(NandOpt2 *popt2);
void smtNANDSetData(smtUint32 *pdata);
void smtNANDGetData(smtUint32 *pdata);

void smtNANDGetCfg(NandCfg *pconfig);
void smtNANDSetCfg(NandCfg *pconfig);

void smtNANDGetControl(NandCtrl *pcontrol);
void smtNANDSetControl(NandCtrl *pcontrol);

void smtNANDGetStatus(NandStat *pstatus);
void smtNANDSetStatus(NandStat *pstatus);

void smtNANDGetFIFOStatus(NandFifoStat *pfifoStatus);

void smtNANDGetECC(smtUint8 eccIdx, smtUint32 *pecc, smtUint32 *psecc);

#endif
