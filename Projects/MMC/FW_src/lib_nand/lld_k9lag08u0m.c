 /*----------------------------------------------------------
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: lld_k9lag08u0m.h
	Description		: Low Level Driver for K9LAG08U0M
----------------------------------------------------------*/
/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/
#include <string.h>
#include <stdlib.h>
#include "ftl_l_layer.h"
#include "../inc/k9lag08u0m.h"
#include "../lib_ftl/ftl_o_rw.h"
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
#define MAX_DLEN (gDevInfo.pageSize + MAX_SPARE_SIZE)
#define MAX_BLOCK_SIZE (MAX_DLEN*gDevInfo.pagePerBlks)
#define MAX_SIZE (gDevInfo.blks * MAX_BLOCK_SIZE)

//	address define
#define	ADDRESS0(c)						((c) & 0xFF)					// A00 ~ A07
#define	ADDRESS1(c)                 	(((c) >> 8) & 0xF)				// A08 ~ A11
#define	ADDRESS2(p, b)                 	((((b) & 0x3)<<6)|((p) & 0x3F))	// A12 ~ a19 
#define	ADDRESS3(b)                 	(((b) >> 2) & 0xFF)				// A20 ~ A27
#define	ADDRESS4(b)                 	(((b) >> 10) & 0xFF)			// A28 ~ A30

/*
/////////////////////////////////////////////////////////
        GLOBAL VARIABLE
///////////////////////////////////////////////////////// 
*/
FTL_DEV_INFO	gDevInfo;
/*
/////////////////////////////////////////////////////////
        STATIC VARIABLE
///////////////////////////////////////////////////////// 
*/
static smtInt32		onceinit	= 0;

/*
/////////////////////////////////////////////////////////
        FUNCTIONS 
///////////////////////////////////////////////////////// 
*/
/*----------------------------------------------------------
	Function name	: FTL_L_Init
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: Low level init function, this is called from
					  core FTL layer, only once
----------------------------------------------------------*/
#define LLD_NAND_TO_READ_ID	(0x7FFFF)
#define LLD_NAND_TO_ERASE	(0x7FFFF)
#define LLD_NAND_TO_WRFIFO	(0x7FFFF)
#define LLD_NAND_TO_RDFIFO	(0x7FFFF)
#define LLD_NAND_TO_WREND	(0x7FFFF)

#define LLD_NAND_FIFO_LEV	(7)

smtUint8	// FTL_L_OK/FTL_L_ERROR
FTL_L_Init(
void
) 
{
	// Init nand controller
	SMT_WRITE(NFCONF0,0xFF);
	SMT_WRITE(NFCONF1,0xFF);
	SMT_WRITE(NFCONF2,0xFF);

	SMT_WRITE(NFCTRL0,0xFF);
	SMT_WRITE(NFCTRL1,0xFF);

	// Init the variables for FTL
	gDevInfo.blks			= 8192;		
	gDevInfo.pagePerBlks	= 64;		
	gDevInfo.pageSize		= 2048;

	return FTL_L_OK;
	
}
/****************************************************************************
 *
 * ll_erase
 *
 * erase a block
 *
 * INPUTS
 *
 * pba - physical block address
 *
 * RETURNS
 *
 * FTL_L_OK - if successfuly
 * FTL_L_ERROR - if any error
 *
 ***************************************************************************/
/*----------------------------------------------------------
	Function name	: FTL_L_Erase
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: NAND erase function
----------------------------------------------------------*/
smtUint8				// FTL_L_OK/FTL_L_ERROR
FTL_L_Erase(	
smtBlkAddr pba
) 
{
	smtUint32 pos = pba;
	smtUint32 timeout;
	if(pba >= gDevInfo.blks) 
	{
		return FTL_L_ERROR;
	}

	// send erase command

	// the 1st operation
	SMT_WRITE(NFOPER0, 0x31);	// CmdAddrFlag(8) 0011 0001B
	SMT_WRITE(NFOPER1, 0xE6);	// OpMode(3)|TransSize(1)|CmdAddrSize(4)
	SMT_WRITE(NFOPER2, 0x0 );	// DataSize(8)
	SMT_WRITE(NFOPER3, 0x0 );	// ChipSel(2)|Option(2)|DataSize(4)

	// the 2nd operation
	SMT_WRITE(NFOPER0, 0x60); 				//  CC0 for erase block
	SMT_WRITE(NFOPER1, ADDRESS2(0,pba)); 	//  row address
	SMT_WRITE(NFOPER2, ADDRESS3(pba)); 		//  row address
	SMT_WRITE(NFOPER3, ADDRESS4(pba)); 		//  row address

	// the 3rd operation
	SMT_WRITE(NFOPER0, 0xD0); //  CC1 for erase block
	SMT_WRITE(NFOPER1, 0x70); //  CC for read status
	SMT_WRITE(NFOPER2, 0x00); //  Dummy
	SMT_WRITE(NFOPER3, 0x00); //  Dummy

	while(1)
	{
		if(SMT_READ(NFSTAT3)&0x1)// check NFStatValid
			break;
		if(timeout++ == LLD_NAND_TO_ERASE)
			goto ERROR;
	}

	if(!(SMT_READ(NFSTAT1)&0x1))	//Check Erase status
		return FTL_L_ERROR;

	return FTL_L_OK;
ERROR:
	// clear status register???
	return FTL_L_ERROR;
}
/****************************************************************************
 *
 * FTL_L_Write
 *
 * write a page
 *
 * INPUTS
 *
 * pba - physical block address
 * ppo - physical page offset
 * buffer - page data to be written (data+spare)
 *
 * RETURNS
 *
 * FTL_L_OK - if successfuly
 * FTL_L_ERROR - if any error
 *
 ***************************************************************************/
/*----------------------------------------------------------
	Function name	: FTL_L_Write
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: NAND write function
----------------------------------------------------------*/
smtUint8				// FTL_L_OK/FTL_L_ERROR
FTL_L_Write(
smtBlkAddr	pba,		// block address
smtPageAddr ppo,		// page address
smtUint8	*buffer		// source gbuffer
) 
{
	smtUint32	bi;
	smtUint32	timeout;
	if(pba >= gDevInfo.blks) 
	{
		return FTL_L_ERROR;
	}

	if(ppo >= gDevInfo.pagePerBlks)
	{
		return FTL_L_ERROR;
	}

	// send program command

	// the 1st operation
	SMT_WRITE(NFOPER0, 0xC1);				// CmdAddrFlag(8) 1100 0001B
	SMT_WRITE(NFOPER1, 0x68);				// OpMode(3)|TransSize(1)|CmdAddrSize(4)
	SMT_WRITE(NFOPER2, 0x40);				// DataSize(8)
	SMT_WRITE(NFOPER3, 0x28);				// ChipSel(2)|Option(2)|DataSize(4)

	// the 2nd operation
	SMT_WRITE(NFOPER0, 0x80);				//  CC0 for program
	SMT_WRITE(NFOPER1, 0x0 ); 				//  column addr
	SMT_WRITE(NFOPER2, 0x0 ); 				//  column addr
	SMT_WRITE(NFOPER3, ADDRESS2(ppo, pba)); //  row addr

	// the 3rd operation
	SMT_WRITE(NFOPER0, ADDRESS3(pba));		//  row addr
	SMT_WRITE(NFOPER1, ADDRESS4(pba));		//  row addr
	SMT_WRITE(NFOPER2, 0x10); 				//  CC1 for program
	SMT_WRITE(NFOPER3, 0x70); 				//  CC for read status

	// write page data to wrFIFO
	timeout = 0;

	for(bi = 0 ; bi < MAX_DLEN ; bi++)
	{
		if(!(bi%(LLD_NAND_FIFO_LEV+1)))
		{
			while(1)
			{
				if(SMT_READ(NFSTAT0)&0x20)// check WrFIFOReady
					break;
				if(timeout++ == LLD_NAND_TO_WRFIFO)
					goto ERROR;
			}
		}
		SMT_WRITE(NFDATA, *buffer++);
	}

	// check wr end
	timeout = 0;
	while(1)
	{
		if(SMT_READ(NFSTAT3)&0x1)// check NFStatValid
			break;

		if(timeout++ == LLD_NAND_TO_WREND)
			goto ERROR;
	}

	if(!(SMT_READ(NFSTAT1)&0x1))	//Check Erase status
		return FTL_L_ERROR;

	return FTL_L_OK;
ERROR:
	return FTL_L_ERROR;
}

/*----------------------------------------------------------
	Function name	: FTL_L_Read
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: NAND read operation by page unit
----------------------------------------------------------*/
smtUint8			// FTL_L_OK/FTL_L_ERASED/FTL_L_ERROR
FTL_L_Read(
smtBlkAddr	pba,	// block address
smtPageAddr ppo,	// page address
smtUint8	*buffer	// target buffer
) 
{
	smtUint32	bi;
	smtUint32	timeout;
	smtUint8	ch;
	smtUint8	iserased = 1;

	if(pba >= gDevInfo.blks) 
	{
		return FTL_L_ERROR;
	}

	if(ppo >= gDevInfo.pagePerBlks)
	{
		return FTL_L_ERROR;
	}

	// the 1st operation
	SMT_WRITE(NFOPER0, 0x41);	// CmdAddrFlag(8) 0100 0001B
	SMT_WRITE(NFOPER1, 0x07);	// OpMode(3)|TransSize(1)|CmdAddrSize(4)
	SMT_WRITE(NFOPER2, 0x40);	// DataSize(8)
	SMT_WRITE(NFOPER3, 0x08);	// ChipSel(2)|Option(2)|DataSize(4)

	// the 2nd operation
	SMT_WRITE(NFOPER0, 0x00); 				// CC0 for read
	SMT_WRITE(NFOPER1, ADDRESS0(0)); 		// column addr
	SMT_WRITE(NFOPER2, ADDRESS1(0));		// column addr
	SMT_WRITE(NFOPER3, ADDRESS2(ppo,pba)); 	// row addr

	// the 3rd operation
	SMT_WRITE(NFOPER0, ADDRESS3(pba)); 		// row addr
	SMT_WRITE(NFOPER1, ADDRESS4(pba)); 		// row addr
	SMT_WRITE(NFOPER2, 0x30); 				// CC1 for read
	SMT_WRITE(NFOPER3, 0x0 ); 				// Dummy

	for(bi = 0; bi< MAX_DLEN; bi++)
	{
		// check read fifo ready
		if(!(bi%(LLD_NAND_FIFO_LEV+1)))
		{
			timeout = 0;
			while(1)
			{
				if(SMT_READ(NFSTAT0)&0x10)
					break;
				if(timeout++ == LLD_NAND_TO_RDFIFO)
					goto ERROR;
			}
		}
		
		ch = SMT_READ(NFDATA);
		if(ch != 0xFF)
			iserased = 0;
		*buffer++ = ch;
	}

	if(iserased) 
	{
		return FTL_L_ERASED;	 
	}
	return FTL_L_OK;
ERROR:
	return FTL_L_ERROR;
}
/*----------------------------------------------------------
	Function name	: FTL_L_IsBadBlk
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: check if a block is manufactured as 
					  bad block
----------------------------------------------------------*/
smtUint8		//  FTL_L_OK/FTL_L_ERROR
FTL_L_IsBadBlk(
smtBlkAddr pba	// block address
) 
{
	#if 0
	smtBlkAddr warn = pba;
	smtUint8 ch;

 	FTL_L_ReadOne(pba, 0, 0, &ch);
	if(ch != 0xFF)
	{
		return 1;
	}
	else 
	{
	 	FTL_L_ReadOne(pba, 1, 0, &ch);
		if(ch != 0xFF)
			return 1;
	}
	// no bad block signalled 
	#endif
	return FTL_L_OK; 
}
