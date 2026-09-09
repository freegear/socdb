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
#include "../lib_nand/ftl_l_layer.h"
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
#define MAX_DLEN			(gDevInfo.pageSize + FTL_SPARE_MAXSIZE)
#define MAX_BLOCK_SIZE		(MAX_DLEN*gDevInfo.pagePerBlks)
#define MAX_SIZE			(gDevInfo.blks * MAX_BLOCK_SIZE)
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
static smtUint32	allocated	= 0;
static smtUint8		*gl_data	= 0;
static smtUint32	*gl_wear	= 0;
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
smtUint8	// FTL_L_OK/FTL_L_ERROR
FTL_L_Init(
void
) 
{
	gDevInfo.blks			= 8192;		
	gDevInfo.pagePerBlks	= 64;		
	gDevInfo.pageSize		= 2048;


	if (!allocated) 
	{
		gl_data=malloc(MAX_SIZE);
		allocated=1;
		SMT_FTL_DPRINTF("data address: 0x%08x\n", gl_data);
	}

	if (!gl_wear) 
	{
		gl_wear = malloc(sizeof(smtInt32)*gDevInfo.blks);
	}

	if ((!gl_data) || (!gl_wear)) 
	{
		return FTL_L_ERROR;
	}

	if (!onceinit) 
	{
		memset(gl_data, 0xFF, MAX_SIZE);
		onceinit=1;
	}

	return FTL_L_OK;
}

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

	if(pba >= gDevInfo.blks) 
	{
		return FTL_L_ERROR;
	}

	pos	*= MAX_BLOCK_SIZE;
	memset((gl_data+pos),0xFF,MAX_BLOCK_SIZE);

	return FTL_L_OK;
}

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
	smtUint32	page	= ppo;
	smtUint32	pos		= pba;
	smtUint8	*dest;
	smtUint32	a;

	dest = gl_data;

	if(pba >= gDevInfo.blks) 
	{
		return FTL_L_ERROR;
	}

	if(ppo >= gDevInfo.pagePerBlks)
	{
		return FTL_L_ERROR;
	}

	pos		*= MAX_BLOCK_SIZE;
	page	*= MAX_DLEN;

	dest+=(pos+page);

	if (!ppo) 
	{
		smtUint32 newwear=GET_SPARE_AREA(buffer)->wear;
		if(gl_wear[pba]+1 != newwear) 
		{
		 	a=10;
		}
		gl_wear[pba]=newwear;
	}

	for (a = 0; a < MAX_DLEN; a++) 
	{
		smtInt8 ch	=* dest;
		smtInt8	ch2	=* buffer++;
		*dest++=(smtUint8)(ch&ch2);
	}

	return FTL_L_OK;
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
	smtUint8	*sou;
	smtUint32	a;
	smtUint32	page		= ppo;
	smtUint32	pos			= pba;
	smtInt8		iserased	=	1;

	sou=gl_data;


	if(pba >= gDevInfo.blks) 
	{
		return FTL_L_ERROR;
	}

	if(ppo >= gDevInfo.pagePerBlks)
	{
		return FTL_L_ERROR;
	}

	pos		*= MAX_BLOCK_SIZE;
	page	*= MAX_DLEN;
	sou		+= (pos+page);



	// we should go throught on all data+spare
	for(a = 0; a < MAX_DLEN; a++) 
	{ 
		smtUint8 ch=*sou++;
		if(ch != 0xFF) 
		{
			// simple erase chk 
			iserased = 0; 
		}

		// if there is given buffer then store 
		// the data into it 
		if (buffer) 
		{
			*buffer++ = ch;
		}
	}

	// if flasg is still set, returns with 
	// erased page 
	if(iserased) 
	{
		return FTL_L_ERASED;	 
	}

	return FTL_L_OK;
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
	
	smtUint32	a;
	smtInt8		iserased	= 1;
	smtUint32	page		= ppo;
	smtUint32	pos			= pba;
	smtUint8	*sou		= gl_data;


	if (pba >= gDevInfo.blks) 
	{
		return FTL_L_ERROR;
	}

	if(ppo >= gDevInfo.pagePerBlks) 
	{
		return FTL_L_ERROR;
	}

	pos		*= MAX_BLOCK_SIZE;
	page	*= MAX_DLEN;

	sou+=(pos+page);

	// we should go throught on all data+spare
	for (a=0; a<MAX_DLEN; a++) 
	{ 
		smtUint8 ch	= *sou++;
		// simple erase chk 
		if(ch != 0xFF) iserased=0; 

		// if 1st half is requested 
		if(index == FTL_L_M0_0) 
		{ 
			if(a < 256) 
			{
				*buffer++=ch;
			}
		}
		else 
		if(index == FTL_L_M0_1) 
		{ 
			if ((a >= 256*1) 
			 && (a  < 256*2))
			{
				*buffer++=ch;
			}
		}
		else 
		if(index == FTL_L_M1_0) 
		{ 
			if ((a >= 256*2) 
			 && (a  < 256*3))
			{
				*buffer++=ch;
			}
		}
		else 
		if(index == FTL_L_M1_1) 
		{ 
			if ((a >= 256*3) 
			 && (a  < 256*4))
			{
				*buffer++=ch;
			}
		}
		else 
		if(index == FTL_L_M2_0) 
		{ 
			if ((a >= 256*4) 
			 && (a  < 256*5))
			{
				*buffer++=ch;
			}
		}
		else 
		if(index == FTL_L_M2_1) 
		{ 
			if ((a >= 256*5) 
			 && (a  < 256*6))
			{
				*buffer++=ch;
			}
		}
			else 
		if(index == FTL_L_M3_0) 
		{ 
			if ((a >= 256*6) 
			 && (a  < 256*7))
			{
				*buffer++=ch;
			}
		}
		else 
		if(index == FTL_L_M3_1) 
		{ 
			if ((a >= 256*8) 
			 && (a  < 256*9))
			{
				*buffer++=ch;
			}
		}
		// spare only is requested 
		else 
		if((index&FTL_L_S0) == FTL_L_S0)
		{ 
			if((a >= gDevInfo.pageSize) 
			&& (a  < gDevInfo.pageSize+16*1))
			{
				*buffer++=ch;
			}
		}
		else
		if((index&FTL_L_S1) == FTL_L_S1)
		{ 
			if((a >= gDevInfo.pageSize+16*1) 
			&& (a  < gDevInfo.pageSize+16*2))
			{
				*buffer++=ch;
			}
		}
		else
		if((index&FTL_L_S2) == FTL_L_S2)
		{ 
			if((a >= gDevInfo.pageSize+16*2) 
			&& (a  < gDevInfo.pageSize+16*3))
			{
				*buffer++=ch;
			}
		}
		else
		if((index&FTL_L_S3) == FTL_L_S3) 
		{ 
			if((a >= gDevInfo.pageSize+16*3) 
			&& (a  < gDevInfo.pageSize+16*4))
			{
				*buffer++=ch;
			}
		}
		else 
		{
			return FTL_L_ERROR;
		}

	}

	// if flasg is still set, returns with erased page 
	if(iserased) 
	{
		return FTL_L_ERASED;	 
	}

	return FTL_L_OK;
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
