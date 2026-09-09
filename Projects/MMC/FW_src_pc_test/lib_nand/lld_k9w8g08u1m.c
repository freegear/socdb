/****************************************************************************
 *
 *            Copyright (c) 2005-2006 by HCC Embedded
 *
 * This software is copyrighted by and is the sole property of
 * HCC.  All rights, title, ownership, or other interests
 * in the software remain the property of HCC.  This
 * software may only be used in accordance with the corresponding
 * license agreement.  Any unauthorized use, duplication, transmission,
 * distribution, or disclosure of this software is expressly forbidden.
 *
 * This Copyright notice may not be removed or modified without prior
 * written consent of HCC.
 *
 * HCC reserves the right to modify this software without notice.
 *
 * HCC Embedded
 * Budapest 1132
 * Victor Hugo Utca 11-15
 * Hungary
 *
 * Tel:  +36 (1) 450 1302
 * Fax:  +36 (1) 450 1303
 * http: www.hcc-embedded.com
 * email: info@hcc-embedded.com
 *
 ***************************************************************************/
 /*----------------------------------------------------------
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "../lib_nand/ftl_l_layer.h"
#include "sysinc.h"
#include "lld_k9w8g08u1m.h"
#include "nand_post_drv.h"
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

#define FTL_L_PAGESIZE		(gDevInfo.pageSize + gDevInfo.spareSize)
#define FTL_L_BLOCKSIZE		(FTL_L_PAGESIZE*gDevInfo.pagePerBlks)
#define FTL_L_TOTALSIZE		(gDevInfo.blks * FTL_L_BLOCKSIZE)

extern void HexDump(void * buffer, smtUint32 size);
/*
/////////////////////////////////////////////////////////
        GLOBAL VARIABLE
///////////////////////////////////////////////////////// 
*/
/*
/////////////////////////////////////////////////////////
        STATIC VARIABLE
///////////////////////////////////////////////////////// 
*/

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
smtUint8	// FTL_L_OK/FTL_L_ERROR
FTL_L_Init(
void
) 
{
	gDevInfo.blks			= LLD_BLOK_SIZE;		
	gDevInfo.pagePerBlks	= LLD_PAGE_PER_BLOCK;			
	gDevInfo.pageSize		= LLD_PAGE_SIZE;
	gDevInfo.spareSize		= LLD_SPARE_SIZE;

	smt2NANDInit();
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
	smtUint32 ret;
	
	if(pba >= gDevInfo.blks) 
	{
		return FTL_L_ERROR;
	}

	ret = smt2NANDEraseMul(pba);

	if(!ret)
	{
		LLDDPRINTF("Erase error \n");
		goto ERROR;
	}
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
	smtUint32	ret;
#ifdef __LLD_FTL_SIM__
	memcpy((void xdata*)0xA000,buffer,2048);
	memcpy((void xdata*)0xA800,buffer+2048,64);
#endif	
	//LLDDPRINTF("FTL_L_Write +\n");
	//buffer = NULL; // prevent compile warning
	if(pba >= gDevInfo.blks) 
	{
		LLDDPRINTF("[WR]invalid block number\n");
		return FTL_L_ERROR;
	}

	if(ppo >= gDevInfo.pagePerBlks)
	{
		LLDDPRINTF("[WR]invalid page number\n");
		return FTL_L_ERROR;
	}

	ret = smt2NANDWriteMul(pba, ppo, buffer);

	if(!ret)
	{
		LLDDPRINTF("nand wrtie error\n");
		goto ERROR;
	}
	return FTL_L_OK;

ERROR:
	return FTL_L_ERROR;	
}
/*----------------------------------------------------------
	Function name	: FTL_L_WriteDouble
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: NAND double write function
----------------------------------------------------------*/
smtUint8 
FTL_L_WriteDouble(
smtBlkAddr	pba,		// block address
smtPageAddr ppo,		// page address
smtUint8	*buffer0,	// 1st half of page data to be written
smtUint8	*buffer1	// 2nd half of page data + spare data to be written
) 
{
	smtUint32 ret;
#ifdef __LLD_FTL_SIM__
	memcpy((smtUint8 xdata*)0xA000,buffer0,1024);
	memcpy((smtUint8 xdata*)(0xA000+(1024)),buffer1,1024);
	memcpy((smtUint8 xdata*)(0xA800),buffer1+(1024),64);
#endif	
	buffer0 = NULL; // prevent compile warning
	buffer1 = NULL; // prevent compile warning

	if(pba >= gDevInfo.blks) 
	{
		LLDDPRINTF("[WR DB]invalid block number\n");
		return FTL_L_ERROR;
	}

	if(ppo >= gDevInfo.pagePerBlks)
	{
		LLDDPRINTF("[WR DB]invalid page number\n");		
		return FTL_L_ERROR;
	}

	ret = smt2NANDWriteMul(pba, ppo, buffer0);

	if(!ret)
	{
		LLDDPRINTF("nand wrtie error\n");
		goto ERROR;
	}
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
	smtUint32 ret;
	//buffer = NULL; // prevent compile warning
	if(pba >= gDevInfo.blks) 
	{
		LLDDPRINTF("[Read]invalid block number\n");
		return FTL_L_ERROR;
	}

	if(ppo >= gDevInfo.pagePerBlks)
	{
		LLDDPRINTF("[Read]invalid page number\n");
		return FTL_L_ERROR;
	}
	ret = smt2NANDReadMul(pba, ppo, buffer);
	if(!ret)
	{
		printf("[LLD]] Read failded\n");
		goto ERROR;
	}
#ifdef __LLD_FTL_SIM__
	if(buffer)
	{
		memcpy(buffer, (smtUint8 xdata*)0xA000,2048);
		memcpy(buffer+2048,(smtUint8 xdata*)0xA800,64);
	}
#endif	

	{
		int i;
		int isErased = 1;
		buffer += 2048;
		for(i = 0; i < 64; i++)
		{
			if(buffer[i] != 0xff) 
			{
				isErased = 0;
				break;
			}
		}
		NANDRAM0SEL = 0;
		if(isErased) 
		{
			//LLDDPRINTF("[Read] this page is erased\n");
			return FTL_L_ERASED;
		}
	}
	return FTL_L_OK;
	
ERROR:
	return FTL_L_ERROR;
}

/*----------------------------------------------------------
	Function name	: FTL_L_ReadPart
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: NAND read operation by page unit
----------------------------------------------------------*/
smtUint8				// FTL_L_OK/FTL_L_ERASED/FTL_L_ERROR
FTL_L_ReadPart(
smtBlkAddr	pba,		// block address
smtPageAddr ppo,		// page address
smtUint8	*buffer,	// age data pointer where to store data (data+spare)
smtUint8	index		// which part need to be stored (FTL_L_1ST/
						// FTL_L_2ND/FTL_L_SP)
) 
{

	smtUint32	ret;
	//buffer = NULL; // prevent compile warning

	if (pba >= gDevInfo.blks) 
	{
		LLDDPRINTF("[Read part]invalid block number\n");
		return FTL_L_ERROR;
	}

	if(ppo >= gDevInfo.pagePerBlks) 
	{
		LLDDPRINTF("[Read part]invalid page number\n");
		return FTL_L_ERROR;
	}

	//printf("read part index = 0x%02bx\n",index);
	ret = smt2NANDReadPartMul(pba, ppo, buffer,index);
	if(!ret)
	{
		LLDDPRINTF("[Read Part] read error !!\n");
		goto ERROR;
	}

#if 1
	return FTL_L_OK;
#else
	// check if the page is erased or not 
	{
		smtUint32 i;
		smtBoolean iserased = true;
		
		for(i = 0 ; i < dataSize; i++)
		{
			if(buffer[i] != 0xFF)
				iserased = false;
		}

		if(iserased) 
		{
			LLDDPRINTF("[Read Part] this part is erased!!\n");
			return FTL_L_ERASED;	 
		}
		return FTL_L_OK;
	}
#endif
ERROR:
	LLDDPRINTF("[Read Part] error!!\n");
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
	smtBlkAddr warn = pba;
	/*
	// in the simulation we simulate only 2 badblock 
	// 10 and 200 only for test purpose 
	if (pba == 10 || pba == 200) 
	{
		// signal as bad block 
		return 1; 
	}
	*/

	// no bad block signalled 
	return FTL_L_OK; 
}
