/*----------------------------------------------------------
	 MMC controller SOC
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2007 SHMT. Co
	 All Rights Reserved.
-----------------------------------------------------------*/
/*----------------------------------------------------------
	File Name	: nand.c 
	Description	: nand file
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/
//#include "global.h"
#include "nand.h"



/*
/////////////////////////////////////////////////////////
        DEFINITIOIN
/////////////////////////////////////////////////////////
*/



/*
/////////////////////////////////////////////////////////
	VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/


/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/
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
		
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name	: smtNANDSetOPT0
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDSetOPT0(NandChannel ch, NandOpt0 *popt0)
{
	smtUint32 regData;
	
	regData = 
		 ((popt0->chipSel			& 0x2) 		<< 30)
		|((popt0->option			& 0x3)		<< 28)
		|((popt0->dataSize			& 0xFFF)	<< 16)
		|((popt0->opMode			& 0x7) 		<< 13)
		|((popt0->TransSize			& 0x1) 		<< 12)
		|((popt0->cmdAddrTransByte	& 0xF) 		<< 8)
		|((popt0->cmdAddrFlag		& 0xFF) 	<< 0);
	
	
	SMT_WRITE(NFCOPER3(ch), ((regData >> (3*8)) & 0xFF));
	SMT_WRITE(NFCOPER2(ch), ((regData >> (2*8)) & 0xFF));
	SMT_WRITE(NFCOPER1(ch), ((regData >> (1*8)) & 0xFF));
	SMT_WRITE(NFCOPER0(ch), ((regData >> (0*8)) & 0xFF));

}
/*----------------------------------------------------------
	Function name	: smtNANDSetOPT1
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDSetOPT1(NandChannel ch, NandOpt1 *popt1)
{
	SMT_WRITE(NFCOPER3(ch), (popt1->CMDADDR[3] & 0xFF));
	SMT_WRITE(NFCOPER2(ch), (popt1->CMDADDR[2] & 0xFF));
	SMT_WRITE(NFCOPER1(ch), (popt1->CMDADDR[1] & 0xFF));
	SMT_WRITE(NFCOPER0(ch), (popt1->CMDADDR[0] & 0xFF));
}

/*----------------------------------------------------------
	Function name	: smtNANDSetOPT2
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDSetOPT2(NandChannel ch, NandOpt2 *popt2)
{
	SMT_WRITE(NFCOPER3(ch), (popt2->CMDADDR[3] & 0xFF));
	SMT_WRITE(NFCOPER2(ch), (popt2->CMDADDR[2] & 0xFF));
	SMT_WRITE(NFCOPER1(ch), (popt2->CMDADDR[1] & 0xFF));
	SMT_WRITE(NFCOPER0(ch), (popt2->CMDADDR[0] & 0xFF));
}
/*----------------------------------------------------------
	Function name	: smtNANDSetDataHalfWD
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDSetDataHalfWD(NandChannel ch, smtUint16 *pData)
{
	SMT_WRITE(NFCDATA(ch), ((*pData >> (1*8)) & 0xFF));
	SMT_WRITE(NFCDATA(ch), ((*pData >> (0*8)) & 0xFF));
}

/*----------------------------------------------------------
	Function name	: smtNANDSetData
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDSetDataByte(NandChannel ch, smtUint8 *pData)
{
	SMT_WRITE(NFCDATA(ch), ((*pData >> (1*8)) & 0xFF));
}

/*----------------------------------------------------------
	Function name	: smtNANDGetDataHalfWD
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDGetDataHalfWD(NandChannel ch, smtUint16 *pData)
{
	*pData = 0;
	*pData |= (SMT_READ(NFCDATA(ch)) & 0xFF) << (1*8);
	*pData |= (SMT_READ(NFCDATA(ch)) & 0xFF) << (0*8);
}

/*----------------------------------------------------------
	Function name	: smtNANDGetDataByte
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDGetDataByte(NandChannel ch, smtUint8 *pData)
{
	*pData = (SMT_READ(NFCDATA(ch)) & 0xFF) << (1*8);
}

/*----------------------------------------------------------
	Function name	: smtNANDGetCfg
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDGetCfg(NandChannel ch, NandCfg *pconfig)
{
	smtUint32 reg = 0;
	reg |= (SMT_READ(NFCCONF2(ch)) & 0xFF) << (2*8);
	reg |= (SMT_READ(NFCCONF1(ch)) & 0xFF) << (1*8);
	reg |= (SMT_READ(NFCCONF0(ch)) & 0xFF) << (0*8);
		
	pconfig->nandBootEn	= ((reg	>> 18) & 0x1);
	pconfig->IOWidth	= ((reg >> 17) & 0x1);
	pconfig->bootCfg	= ((reg	>> 14) & 0x3);
	pconfig->OutDtmn	= ((reg >> 13) & 0x1);
	pconfig->TADLTWB	= ((reg >> 9 ) & 0xF);
	pconfig->TCALS		= ((reg	>> 6 ) & 0x7);
	pconfig->TRWLP		= ((reg >> 3 ) & 0x7);
	pconfig->TRWHP		= ((reg >> 0 ) & 0x7);
	
}
/*----------------------------------------------------------
	Function name	: smtNANDSetCfg
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDSetCfg(NandChannel ch, NandCfg *pconfig)
{
	smtUint32 reg;
	
	reg =  
		(((pconfig->nandBootEn	& 0x1) << 18)
		|((pconfig->IOWidth		& 0x1) << 17)
		|((pconfig->bootCfg		& 0x1) << 14)
		|((pconfig->OutDtmn		& 0x0) << 13)
		|((pconfig->TADLTWB		& 0xF) << 9)
		|((pconfig->TCALS		& 0x7) << 6)
		|((pconfig->TRWLP		& 0x7) << 3)
		|((pconfig->TRWHP		& 0x7) << 0));
	
	SMT_WRITE(NFCCONF2(ch), ((reg >> (2*8)) & 0xFF));
	SMT_WRITE(NFCCONF1(ch), ((reg >> (1*8)) & 0xFF));
	SMT_WRITE(NFCCONF0(ch), ((reg >> (0*8)) & 0xFF));
}


/*----------------------------------------------------------
	Function name	: smtNANDGetControl
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDGetControl(NandChannel ch, NandCtrl *pcontrol)
{
	smtUint32 reg = 0;

	reg |= (SMT_READ(NFCCTRL1(ch)) & 0xFF) << (1*8);
	reg |= (SMT_READ(NFCCTRL0(ch)) & 0xFF) << (0*8);
	
	pcontrol->NFCtrlRst		= ((reg	>> 13) & 0x1);
	pcontrol->FIFOLevel		= ((reg >> 10) & 0x7);
	pcontrol->Ecc512byteEn	= ((reg >> 9 ) & 0x1);
	pcontrol->autoEccWr		= ((reg	>> 8 ) & 0x1);//shkim-20070613 : remove???

	pcontrol->DMAEn			= ((reg >> 7 ) & 0x1);
	pcontrol->wrEndIntEn	= ((reg >> 6 ) & 0x1);	
	pcontrol->rdEndIntEn	= ((reg	>> 5 ) & 0x1);
	pcontrol->FIFOIntEn		= ((reg >> 4 ) & 0x1);	

	pcontrol->RnBintEn3		= ((reg >> 3 ) & 0x1);
	pcontrol->RnBintEn2		= ((reg >> 2 ) & 0x1);
	pcontrol->RnBintEn1		= ((reg >> 1 ) & 0x1);
	pcontrol->RnBintEn0		= ((reg >> 0 ) & 0x1);	
}
/*----------------------------------------------------------
	Function name	: smtNANDSetControl
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDSetControl(NandChannel ch, NandCtrl *pcontrol)
{
	
	smtUint32 reg;
	
	reg = (
		 ((pcontrol->NFCtrlRst    	& 0x1)<<13)
		|((pcontrol->FIFOLevel		& 0x7)<<10)
		|((pcontrol->Ecc512byteEn 	& 0x1)<< 9)
		|((pcontrol->autoEccWr		& 0x1)<< 8)
		|((pcontrol->DMAEn		  	& 0x1)<< 7)
		|((pcontrol->wrEndIntEn		& 0x1)<< 6)
		|((pcontrol->rdEndIntEn	  	& 0x1)<< 5)
		|((pcontrol->FIFOIntEn	  	& 0x1)<< 4)
		|((pcontrol->RnBintEn3	  	& 0x1)<< 3)
		|((pcontrol->RnBintEn2	  	& 0x1)<< 2)
		|((pcontrol->RnBintEn1	  	& 0x1)<< 1)
		|((pcontrol->RnBintEn0	  	& 0x1)<< 0));
		
	SMT_WRITE(NFCCTRL1(ch) , ((reg >> (1*8)) & 0xFF));
	SMT_WRITE(NFCCTRL0(ch) , ((reg >> (0*8)) & 0xFF));
}
/*----------------------------------------------------------
	Function name	: smtNANDGetStatus
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDGetStatus(NandChannel ch, NandStat *pstatus)
{
	smtUint32 reg =	0;
	reg |= (SMT_READ(NFCSTAT3(ch)) & 0xFF) << 3*8;	
	reg |= (SMT_READ(NFCSTAT2(ch)) & 0xFF) << 2*8;	
	reg |= (SMT_READ(NFCSTAT1(ch)) & 0xFF) << 1*8;	
	reg |= (SMT_READ(NFCSTAT0(ch)) & 0xFF) << 0*8;	

	pstatus->RnBDetect3		= ((reg >> 31) & 0x1);
	pstatus->RnBDetect2		= ((reg >> 30) & 0x1);
	pstatus->RnBDetect1		= ((reg >> 29) & 0x1);
	pstatus->RnBDetect0		= ((reg >> 28) & 0x1);
	
	pstatus->RnBSTAT3		= ((reg >> 27) & 0x1);
	pstatus->RnBSTAT2		= ((reg >> 26) & 0x1);
	pstatus->RnBSTAT1		= ((reg >> 25) & 0x1);
	pstatus->RnBSTAT0		= ((reg >> 24) & 0x1);

	pstatus->NFStatus		= ((reg >> 8 ) & 0xFFFF);	
	pstatus->wrEnd			= ((reg >> 7 ) & 0x1);
	pstatus->rdEnd			= ((reg >> 6 ) & 0x1);
	pstatus->wrFIFOReady	= ((reg >> 5 ) & 0x1);
	pstatus->rdFIFOReady	= ((reg >> 4 ) & 0x1);
	pstatus->NFCtrlBusy		= ((reg >> 1 ) & 0x1);		
	pstatus->NFStatValid	= ((reg >> 0 ) & 0x1); 		
	
}
/*----------------------------------------------------------
	Function name	: smtNANDSetStatus
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDSetStatus(NandChannel ch, NandStat *pstatus)
{
	smtUint32 reg;
	
	reg = (	
		 ((pstatus->RnBDetect3		& 0x1)		<< 31)
		|((pstatus->RnBDetect2		& 0x1)		<< 30)
		|((pstatus->RnBDetect1		& 0x1)		<< 29)
		|((pstatus->RnBDetect0		& 0x1)		<< 28)
		|((pstatus->RnBSTAT3		& 0x1)		<< 27)
		|((pstatus->RnBSTAT2		& 0x1)		<< 26)
		|((pstatus->RnBSTAT1		& 0x1)		<< 25)
		|((pstatus->RnBSTAT0		& 0x1)		<< 24)
		|((pstatus->NFStatus		& 0xFFFF) 	<< 8)	
		|((pstatus->wrEnd			& 0x1)  	<< 7) 
		|((pstatus->rdEnd			& 0x1)		<< 6)
		|((pstatus->wrFIFOReady		& 0x1)  	<< 5) 
		|((pstatus->rdFIFOReady		& 0x1)		<< 4)
		|((pstatus->NFCtrlBusy		& 0x1)  	<< 1)
		|((pstatus->NFStatValid		& 0x1)		<< 0));

	SMT_WRITE(NFCSTAT3(ch), ((reg >> (3*8)) & 0xFF));
	SMT_WRITE(NFCSTAT2(ch), ((reg >> (2*8)) & 0xFF));
	SMT_WRITE(NFCSTAT1(ch), ((reg >> (1*8)) & 0xFF));
	SMT_WRITE(NFCSTAT0(ch), ((reg >> (0*8)) & 0xFF));
			
}
/*----------------------------------------------------------
	Function name	: smtNANDGetFIFOStatus
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDGetFIFOStatus(NandChannel ch, NandFifoStat *pfifoStatus)
{
	
	smtUint32 reg =	0;
	reg |= (SMT_READ(NFCFIFOSTAT1(ch)) & 0xFF) << (1*8);
	reg |= (SMT_READ(NFCFIFOSTAT0(ch)) & 0xFF) << (0*8);
	
	pfifoStatus->QLevel			= ((reg >> 8) & 0xF);
	pfifoStatus->DFIFOLevel1	= ((reg >> 4) & 0xF);
	pfifoStatus->DFIFOLevel0	= ((reg >> 0) & 0xF);
}
