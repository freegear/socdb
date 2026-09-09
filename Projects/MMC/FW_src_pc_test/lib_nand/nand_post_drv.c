/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: nand_post_drv.c 
	Description	: nand post driver 
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include <stdio.h>
#include <string.h>
#include "nand_post_drv.h"
#include "ftl_l_layer.h"

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARE
///////////////////////////////////////////////////////// 
*/
extern void HexDump(void * buffer, smtUint32 size);
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
#define NANDDPRINTF printf
/*
/////////////////////////////////////////////////////////
        TYPE DEFINITION
///////////////////////////////////////////////////////// 
*/
#define NAND_MAX_CH		(2)// 2
#define NAND_CS_PER_CH	(2)// 4
#define NAND_CS_MAX (NAND_MAX_CH * NAND_CS_PER_CH)
//#define NAND_MOD_MASK	(0x3)
#define NAND_DIV_VALUE  (0x2)
#define NAND_MOD_MASK	(0x3)
#define NAND2DPRINTF printf
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
	Function name	: smt2NANDInit
	Prototype		: smtBoolean smt2NANDInit(void)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smt2NANDInit(void)
{
	smtNANDInit();
	smtNAND1Init();
}

/*----------------------------------------------------------
	Function name	: smt2NANDDeInit
	Prototype		: smtBoolean smt2NANDDeInit(void)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean smt2NANDDeInit(void)
{
	return true;
}

/*----------------------------------------------------------
	Function name	: smt2NANDDeInit
	Prototype		: smtBoolean smt2NANDDeInit(void)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean smt2NANDEraseMul(smtBlkAddr pba)
{
	smtUint8 bank;
	smtUint32 ret;
	for(bank = 0; bank < NAND_CS_PER_CH; bank++)
	{
		ret = smtNANDErase(bank, pba);
		if(!ret)
		{
			NAND2DPRINTF("Erase failed!!\n");
			return false;
		}
		ret = smtNAND1Erase(bank, pba);
		if(!ret)
		{
			NAND2DPRINTF("Erase failed!!\n");
			return false;
		}
	}
	return true;
}

/*----------------------------------------------------------
	Function name	: smt2NANDWriteMul
	Prototype		: smtBoolean smt2NANDWriteMul(void)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean smt2NANDWriteMul(smtBlkAddr pba, smtPageAddr ppo, smtUint8 *buffer)
{
	NandRWInfo main,spare;
	smtUint8 ch, bank;
	smtUint32 ret;
	buffer = NULL;// prevent compile error 
	ch = 0;
	bank = ppo & NAND_MOD_MASK;
	ppo = ppo >> NAND_DIV_VALUE;
	if(bank > NAND_CS_PER_CH-1)
	{
		ch = 1;
		bank -=NAND_CS_PER_CH;
	}

	// write data
	main.col = 0;
	main.ppa = ppo;
	main.pba = pba;
	main.size	= 2048;
	main.buffer = (void *)0;

	spare.col = 2048;
	spare.ppa = ppo;
	spare.pba = pba;
	spare.size	= 64;
	spare.buffer = (void *)0;

	if(ch == 0)
	{
		ret = smtNANDWrite(bank, &main, &spare);
	}
	else if(ch == 1)
	{
		ret = smtNAND1Write(bank, &main, &spare);
	}
	else
	{
		NAND2DPRINTF("[NAND2 WR] failed to select channel = %bd\n",ch);
		return false;
	}
	if(!ret)
	{
		NAND2DPRINTF("[NAND2] nand write failed!!!\n");
		return false;
	}
	return true;
}

/*----------------------------------------------------------
	Function name	: smt2NANDReadMul
	Prototype		: smtBoolean smt2NANDReadMul(void)
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean smt2NANDReadMul(smtBlkAddr pba, smtPageAddr ppo, smtUint8 *buffer)
{
	NandRWInfo main,spare;
	smtUint8 ch, bank;
	smtUint32 ret;
	buffer = NULL; // prevent compile error
	ch = 0;
	bank = ppo & NAND_MOD_MASK;
	ppo = ppo >> NAND_DIV_VALUE;

	if(bank > NAND_CS_PER_CH-1)
	{
		ch = 1;
		bank -=NAND_CS_PER_CH;
	}
	
	// write data
	main.col = 0;
	main.ppa = ppo;
	main.pba = pba;
	main.size	= 2048;
	main.buffer = (void *)0;

	spare.col = 2048;
	spare.ppa = ppo;
	spare.pba = pba;
	spare.size	= 64;
	spare.buffer = (void *)0;

	if(ch == 0)
	{
		ret = smtNANDRead(bank, &main, &spare);
	}
	else if(ch == 1)
	{
		ret = smtNAND1Read(bank, &main, &spare);
	}
	else
	{
		NAND2DPRINTF("[NAND2 RD] failed to select channel = %bd\n",ch);
		return false;
	}

	if(!ret)
	{
		NAND2DPRINTF("[NAND2] nand read error!!\n");
		return false;
	}
	return true;
}

smtBoolean smt2NANDReadPartMul(smtBlkAddr pba, smtPageAddr ppo, smtUint8 *buffer, smtUint8 index)
{
	NandRWInfo main, spare;
	smtUint8 ch, bank;
	smtUint32 ret;

	ch = 0;
	bank = ppo & NAND_MOD_MASK;
	ppo = ppo >> NAND_DIV_VALUE;
	if(bank > NAND_CS_PER_CH-1)
	{
		ch = 1;
		bank -=NAND_CS_PER_CH;
	}
	
	main.size 	= 0;
	spare.size 	= 0;
	switch(index)
	{
		case FTL_L_1ST:
			main.col	= 0;
			main.ppa	= ppo;
			main.pba	= pba;
			main.size	= 1024;
			break;
		case FTL_L_2ND:
			main.col	= gDevInfo.pageSize/2;
			main.ppa	= ppo;
			main.pba	= pba;
			main.size	= 1024;
			break;
		case FTL_L_SP:
			spare.col	= gDevInfo.pageSize;
			spare.ppa	= ppo;
			spare.pba	= pba;
			spare.size	= gDevInfo.spareSize;
			break;
		default:
			NAND2DPRINTF("invalid part index\n");
			return false;
	}

	if(ch == 0)
	{
		ret = smtNANDRead(bank, &main, &spare);
	}
	else if(ch == 1)
	{
		ret = smtNAND1Read(bank, &main, &spare);
	}
	else
	{
		NAND2DPRINTF("[NAND2 RD Part] failed to select channel = %bd\n",ch);
		return false;
	}
	
	if(!ret)
	{
		NAND2DPRINTF("[NAND2 ReadPart] read error !!\n");
		return false;
	}
	
	if(main.size)
	{
		memcpy(buffer, (smtUint8 xdata*)0xA000, main.size);
	}
	else if(spare.size)
	{
		memcpy(buffer, (smtUint8 xdata*)0xA800, spare.size);
	}
	else
	{
		NAND2DPRINTF("[Read Part] main/spare size is zero!!!\n");
		return false;
	}
	return true;
}
