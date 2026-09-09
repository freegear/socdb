/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: nand_pre_drv.c
	Description		: 
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/
/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "nand_pre_drv.h"
#include "commonmacro.h"
/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////*/

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
/*----------------------------------------------------------
	Function name	: smtNANDSetOPT0
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDSetOPT0(NAND_OPT0 *popt0)
{
	smtUint32 reg;
	
	SMT_WRITE(
		NANDNFOPER,
		 ((popt0->chipSel			& 0x3) 		<< 31)
		|((popt0->option			& 0x3)		<< 29)
		|((popt0->dataSize			& 0xFFF)	<< 17)
		|((popt0->opMode			& 0x7) 		<< 14)
		|((popt0->TransSize			& 0xFFF) 	<< 12)
		|((popt0->cmdAddrTransByte	& 0xF) 		<< 8)
		|((popt0->cmdAddrFlag		& 0xFF) 	<< 0)
	);
	
	NANDNFOPER = reg;

}
/*----------------------------------------------------------
	Function name	: smtNANDSetOPT1
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDSetOPT1(NAND_OPT1 *popt1)
{
	SMT_WRITE(
		NANDNFOPER,
		 ((popt1->CMDADDR[0] & 0xFF) << 24)
		|((popt1->CMDADDR[1] & 0xFF) << 16)
		|((popt1->CMDADDR[2] & 0xFF) << 8)
		|((popt1->CMDADDR[3] & 0xFF) << 0)
	);
}

/*----------------------------------------------------------
	Function name	: smtNANDSetOPT2
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDSetOPT2(NAND_OPT2 *popt2)
{
	
	SMT_WRITE(
		NANDNFOPER, 
		 ((popt2->CMDADDR[0] & 0xFF) << 24)
	    |((popt2->CMDADDR[1] & 0xFF) << 16)
		|((popt2->CMDADDR[2] & 0xFF) << 8)
		|((popt2->CMDADDR[3] & 0xFF) << 0)
	);
	
}
/*----------------------------------------------------------
	Function name	: smtNANDSetData
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDSetData(smtUint32 *pdata)
{
	SMT_WRITE(NANDDATA, *pdata);
}
/*----------------------------------------------------------
	Function name	: smtNANDGetData
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDGetData(smtUint32 *pdata)
{
	*pdata = SMT_READ(NANDDATA);
}
/*----------------------------------------------------------
	Function name	: smtNANDGetCfg
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDGetCfg(NAND_CFG *pconfig)
{
	
	smtUint32 reg = SMT_READ(NANDCONF);
	
	pconfig->nandBootEn	= ((reg	>> 18) & 0x1);
	pconfig->IOWidth	= ((reg >> 17) & 0x1);
	pconfig->NandWidth	= ((reg >> 16) & 0x1);
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
void smtNANDSetCfg(NAND_CFG *pconfig)
{
	smtUint32 reg;
	
	SMT_WRITE(
		NANDCONF,
		 ((pconfig->nandBootEn	& 0x1) << 18)
		|((pconfig->IOWidth		& 0x1) << 17)
		|((pconfig->NandWidth	& 0x1) << 16)
		|((pconfig->bootCfg		& 0x1) << 14)
		|((pconfig->OutDtmn		& 0x0) << 13)
		|((pconfig->TADLTWB		& 0xF) << 9)
		|((pconfig->TCALS		& 0x7) << 6)
		|((pconfig->TRWLP		& 0x7) << 3)
		|((pconfig->TRWHP		& 0x7) << 0)
	);
	
}
/*----------------------------------------------------------
	Function name	: smtNANDGetControl
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDGetControl(NAND_CTRL *pcontrol)
{
	smtUint32 reg = SMT_READ(NANDCTRL);
	
	pcontrol->NFCtrlRst		= ((reg	>> 13) & 0x1);
	pcontrol->FIFOLevel		= ((reg >> 10) & 0x7);
	pcontrol->Ecc512byteEn	= ((reg >> 8 ) & 0x1);
	pcontrol->autoEccWr		= ((reg	>> 7 ) & 0x1);
	pcontrol->DMAEn			= ((reg >> 6 ) & 0x1);
	pcontrol->wrEndIntEn	= ((reg >> 5 ) & 0x1);	
	pcontrol->rdEndIntEn	= ((reg	>> 4 ) & 0x1);
	pcontrol->eccErrIntEn	= ((reg >> 3 ) & 0x1);
	pcontrol->FIFOIntEn		= ((reg >> 2 ) & 0x1);	
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
void smtNANDSetControl(NAND_CTRL *pcontrol)
{
	
	SMT_WRITE(	
		NANDCTRL, 
		((pcontrol->NFCtrlRst		& 0x1) << 13)
		|((pcontrol->FIFOLevel		& 0x7) << 10)
		|((pcontrol->Ecc512byteEn	& 0x1) << 8)
		|((pcontrol->autoEccWr		& 0x1) << 7)
		|((pcontrol->DMAEn			& 0x1) << 6)
		|((pcontrol->wrEndIntEn		& 0x1) << 5)
		|((pcontrol->rdEndIntEn		& 0x1) << 4)
		|((pcontrol->eccErrIntEn	& 0x1) << 3)
		|((pcontrol->FIFOIntEn		& 0x1) << 2)
		|((pcontrol->RnBintEn1		& 0x1) << 1)
		|((pcontrol->RnBintEn0		& 0x1) << 0)
	);

}
/*----------------------------------------------------------
	Function name	: smtNANDGetStatus
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDGetStatus(NAND_STAT *pstatus)
{
	smtUint32 reg =	SMT_READ(NANDSTAT);
	
	pstatus->eccErr			= ((reg >> 23) & 0x1);
	pstatus->NFQueLevel		= ((reg >> 19) & 0xF);
	pstatus->NFCtrlBusy		= ((reg >> 18) & 0x1);
	pstatus->NFIDValid		= ((reg >> 17) & 0x1);
	pstatus->NFStatValid	= ((reg >> 16) & 0x1);
	pstatus->NFStatus		= ((reg >> 8 ) & 0xFF);	
	pstatus->wrEnd			= ((reg >> 7 ) & 0x1);
	pstatus->rdEnd			= ((reg >> 6 ) & 0x1);
	pstatus->wrFIFOReady	= ((reg >> 5 ) & 0x1);
	pstatus->rdFIFOReady	= ((reg >> 4 ) & 0x1);
	pstatus->RnBDetect1		= ((reg >> 3 ) & 0x1);
	pstatus->RnBDetect0		= ((reg >> 2 ) & 0x1);
	pstatus->RnBSTAT1		= ((reg >> 1 ) & 0x1);
	pstatus->RnBSTAT0		= ((reg >> 0 ) & 0x1);
}
/*----------------------------------------------------------
	Function name	: smtNANDSetStatus
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDSetStatus(NAND_STAT *pstatus)
{

	SMT_WRITE(
		NANDSTAT,
		 ((pstatus->eccErr			& 0x1) 	<< 23)
		|((pstatus->NFQueLevel		& 0xF) 	<< 19)
		|((pstatus->NFCtrlBusy		& 0x1) 	<< 18)
		|((pstatus->NFIDValid		& 0x1) 	<< 17)
		|((pstatus->NFStatValid		& 0x1) 	<< 16)
		|((pstatus->NFStatus		& 0xFF) << 8)
		|((pstatus->wrEnd			& 0x1) 	<< 7)
		|((pstatus->rdEnd			& 0x1) 	<< 6)
		|((pstatus->wrFIFOReady		& 0x1) 	<< 5)
		|((pstatus->rdFIFOReady		& 0x1) 	<< 4)
		|((pstatus->RnBDetect1		& 0x1) 	<< 3)
		|((pstatus->RnBDetect0		& 0x1) 	<< 2)
		|((pstatus->RnBSTAT1		& 0x1) 	<< 1)
		|((pstatus->RnBSTAT0		& 0x1) 	<< 0)
	);


}
/*----------------------------------------------------------
	Function name	: smtNANDGetECC
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDGetECC(smtUint8 eccIdx, smtUint32 *pecc, smtUint32 *psecc)
{

	switch(eccIdx)
	{
		case 0:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR0);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR0);
			break;
			
		case 1:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR1);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR1);
			break;
			
		case 2:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR2);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR2);
			break;
			
		case 3:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR3);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR3);
			break;
			
		case 4:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR4);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR4);
			break;
			
		case 5:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR5);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR5);
			break;
			
		case 6:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR6);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR6);
			break;
			
		case 7:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR7);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR7);
			break;
			
		case 8:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR8);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR8);
			break;		
			
		case 9:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR9);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR9);
			break;
			
		case 10:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR10);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR10);
			break;
			
		case 11:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR11);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR11);
			break;
			
		case 12:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR12);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR12);
			break;
			
		case 13:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR13);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR13);
			break;
			
		case 14:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR14);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR14);
			break;
			
		case 15:
			if(pecc) *pecc 	= SMT_READ(ECCSECTOR15);
			if(pecc) *psecc	= SMT_READ(SECCSECTOR15);
			break;
										
	}
}
/*----------------------------------------------------------
	Function name	: smtNANDGetECCStatus
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtNANDGetECCStatus(smtUint8 eccIdx, smtUint8 *pecc, smtUint8 *psecc)
{
	
	
	smtUint32 eccStatus, seccStatus;
	
	

	if(eccIdx < 8)
	{
		if(pecc) 
		{
			*pecc 	= ((SMT_READ(ECCERR0) & 0x3) >> (eccIdx*4));	
		}
		
		if(psecc)
		{
			*psecc	= ((SMT_READ(ECCERR0) & 0x3) >> (2+eccIdx*4));
		}

	}
	else if(eccIdx > 8)
	{
		eccIdx -= 8;
		
		if(pecc) 	
		{
			*pecc 	= ((SMT_READ(ECCERR1) & 0x3) >> (eccIdx*4));
		}
		
		if(psecc)	
		{
			*psecc	= ((SMT_READ(ECCERR1) & 0x3) >> (2+eccIdx*4));
		}
	}
}
