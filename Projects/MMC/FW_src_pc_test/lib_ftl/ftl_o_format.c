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
#include "../lib_nand/ftl_l_layer.h"
#include "ftl_t_define.h"
#include "ftl_w_wear.h"
#include "ftl_c_core.h"
#include "ftl_o_rw.h"
#include "ftl_o_lowinit.h"
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
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
	Function name	: FTL_O_Format
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: Formatting the layer, this function must 
					  be called once at manufacturing This is important 
					  that this function can be called only once!
-----------------------------------------------------------*/
smtBoolean 			// SMT_TRUE/SMT_FALSE, success/any error
FTL_O_Format(
void
) 
{
	smtUint16 	fidx;
	smtUint8	index;
	smtUint8 	cou;
	smtFrag 		frag;
	smtBlkAddr 		pba;
	smtBlkAddr 		*ppba;
	ST_SPARE 	*sptr;


	// here we can set up a local spare ptr 
	// <gDevInfo.pageSize is requested for it>
	sptr=GET_SPARE_AREA(gTempBuffer);	

	//-------------------------------------------------------
	// allocating free table 
	//-------------------------------------------------------
	for(
	index=0, pba=0;
	(index < gFlush.freeBlkNum) && (pba < gDevInfo.blks); 
	pba++
	)
	{

		// if a block is bad it is left out from the system 
		if (FTL_L_IsBadBlk(pba)) 
		{
			continue; 
		}

		// if blk is not an erased blk 
		if (FTL_L_Read(pba,0,0)!= FTL_L_ERASED)  
		{
			if (FTL_L_Erase(pba) == FTL_L_ERROR) 
			{
				continue; 
			}
		}

		gFlush.freeBlks[index] = pba;
		FTL_W_UpdateDInfo((smtUint8)index,0);
		index++;
	}
	
	SMT_ASSERT(index == gFlush.freeBlkNum);
	FTL_W_ReleaseDLock();

	//-------------------------------------------------------
	// allocate MAP block 
	//-------------------------------------------------------
	for(cou = 0; cou < FTL_MAPBLOCK_NUM; cou++)
	{
		// get the given map block 
		ST_MAPBLOCK *mapblock = &gMapBlocks.mapBlks[cou];
		
		mapblock->depthIdx	= 0;	// reset index 
		mapblock->ref_count	= 0;	// reset reference counter 

		// allocate 1st block in map block 
		FTL_C_AllocMapBlk(mapblock); 

	}

	// reset mapinfo 
	memset(gFlush.mapInfo, 0xFF, sizeof(ST_MAPINFO));

	//-------------------------------------------------------
	// Write fragment map to nand
	//-------------------------------------------------------
	
	// create MAP dir from remaining blocks 
	// gTempBuffer data area is for fragments, spare is 
	// for reading new phy block
	ppba	= (smtBlkAddr *)gTempBuffer; 
	fidx	= 0;
	frag	= 0;
	
	for (;pba < gDevInfo.blks; pba++)
	{
		
		if (FTL_L_Read(pba,0,0)!=FTL_L_ERASED)  
		{
			if (FTL_L_Erase(pba) == FTL_L_ERROR) 
			{
				continue; 
			}
		}

		// if a block is bad it is left out from the system 
		if (FTL_L_IsBadBlk(pba)) 
		{
			continue; 
		}


		// counting data blocks 
		gDevInfo.dataBlks++; 
		ppba[fidx++] = pba;

		
		// if reach the end of fragpair then write it 
		if (fidx == MAX_FRAGSIZE*2)
		{
			if (!FTL_C_WriteFrag(frag, (smtUint8*)ppba)) 
			{
				// Fatal 
				return SMT_FALSE;
			}
			fidx = 	0;
			frag +=	2;
		}
	}

	//-------------------------------------------------------
	// fill remaining frag entries with BLK_NA 
	//-------------------------------------------------------
	while(frag != (gMapBlocks.maxFragPerMapBlk*FTL_MAPBLOCK_NUM))
	{
		while (fidx!=MAX_FRAGSIZE*2)
		{
			ppba[fidx++] = BLK_NA;
		}

		if (!FTL_C_WriteFrag(frag, (smtUint8*)ppba)) 
		{
			// fatal 
			return SMT_FALSE;
		}
		fidx	= 	0;
		frag	+= 	2;
	}

	// reset counters
	gFlush.mapInfo->mapCntH	= 0;
	gFlush.mapInfo->mapCntL	= 0;

	//-------------------------------------------------------
	// store FLT to the top of MAP BLKS 
	//-------------------------------------------------------
	for(cou = 0; cou < FTL_MAPBLOCK_NUM; cou++)
	{
		// setting global mapblock 
		if(!FTL_C_LoadFrag(gMapBlocks.mapBlks[cou].startFragIdx))
		{
			// FATAL 
			return SMT_FALSE;
		}

		// Store information 
		if (FTL_C_SaveMap()) 
		{
			return SMT_FALSE;
		}
	}


	return SMT_TRUE;
}