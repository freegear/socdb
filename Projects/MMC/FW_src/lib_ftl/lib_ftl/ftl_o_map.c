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
#include "ftl_o_lowinit.h"
#include "ftl_o_rw.h"
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
	Function name	: BuildMap
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: function for rebuilding mapdir
-----------------------------------------------------------*/
smtBoolean 			// SMT_TRUE/SMT_FALSE, ok/fail
BuildMap(
ST_MAPBLOCK	*map	// map block to be build
)
{
	ST_SPARE 	*sptr=GET_SPARE_AREA(ml_buffer);
	smtUint8 	mappage;
	smtUint8 	cou;
	smtUint8 	index;
	smtUint8 	idxcou;
	ST_MAPDIR 	*pfragMap;
	smtFrag 	frag,fragcou;
	smtBlkAddr 	pba;
	smtPageAddr ppo;


	// label for step back 
again: 

	//-------------------------------------------------------
	// go through on all index entry 
	//-------------------------------------------------------
	map->depthIdx = INDEX_NA;
	for (cou = 0; cou < FTL_MAPBLOCK_DEPTH; cou++)
	{
		index = gpFlush->mapInfo->mapPageBlk[cou];
		map->mapPageBlk[cou] = index;								

		// If valid index, then update indexcou 
		if (index != INDEX_NA)				
		{
			map->depthIdx = cou;						
		}
	}
	SMT_ASSERT(map->depthIdx != INDEX_NA);

	//-------------------------------------------------------
	// goto the next entry 
	//-------------------------------------------------------
	map->depthIdx++; 
	map->mapCntH	= gpFlush->mapInfo->mapCntH;	// get last map cntH
	map->mapCntL	= gpFlush->mapInfo->mapCntL;	// get last map cntL

	// check if this is the maximum counter 
	if(gpFlush->mapInfo->mapCntH > gpMapBlocks->maxMapCntH)
	{
		gpMapBlocks->maxMapCntL	= gpFlush->mapInfo->mapCntL;
		gpMapBlocks->maxMapCntH	= gpFlush->mapInfo->mapCntH;
	}
	else
	{
		if((gpFlush->mapInfo->mapCntH == gpMapBlocks->maxMapCntH)
		&& (gpFlush->mapInfo->mapCntL  > gpMapBlocks->maxMapCntL))
		{
			gpMapBlocks->maxMapCntL	= gpFlush->mapInfo->mapCntL;
			gpMapBlocks->maxMapCntH	= gpFlush->mapInfo->mapCntH;
		}
	}
	

	//-------------------------------------------------------
	// First mapPageBlk is aligned mappage + frags or frags
	//-------------------------------------------------------
	mappage		= 0;						// signal we didn't find any map page 
	idxcou		= 0;						// reset index counter 
	index		= map->mapPageBlk[idxcou];	// get its value 
	SMT_ASSERT(index != INDEX_NA);			// 1st index cannot be not available

	pba			= (smtBlkAddr)(gpFlush->freeBlks[index]&FTL_BLKADDR_MASK);
	ppo			= 0;
	frag		= map->startFragIdx;
	pfragMap	= &gpMapDir[frag];
	fragcou		= (smtFrag)(gpMapBlocks->maxFragPerMapBlk/2);			
	while(fragcou)
	{

		// read page's spare area 
		if (!FTL_L_ReadPart(
				pba,
				ppo,
				(smtUint8*)sptr,
				FTL_L_S0)
			) 
		{

			// check stored fragment pair 
			SMT_ASSERT(sptr->u.map.frag == frag);

			// fill first frag information
			pfragMap->PBA	= pba;	
			pfragMap->PPO	= ppo;	
			pfragMap->index	= FTL_L_M0_0;	
			pfragMap++;				

			// fill second frag information
			pfragMap->PBA	= pba;	
			pfragMap->PPO	= ppo;	
			pfragMap->index	= FTL_L_M0_1;	
			pfragMap++;				

			frag+=2;				// go to next 2 fragment 
			fragcou--;				// decrementing pair counter 

			// goto next page 
			ppo++; 
		}
		else
		{
			// broken mapdir, so step back check if there was any step back 
			// and set step back value to the current map block 
			SMT_ASSERT(gpMapBlocks->stepback == 0);
			gpMapBlocks->stepback = map;		   
			
			// check if pba and ppo valid for step back
			SMT_ASSERT(gpFlush->mapInfo->LastPBA != BLK_NA);
			SMT_ASSERT(gpFlush->mapInfo->LastPPO != INDEX_NA);

			// get last stored pba and ppo of mappage 
			map->curPBA = gpFlush->mapInfo->LastPBA;
			map->curPPO = gpFlush->mapInfo->LastPPO;

			//-----------------------------------------------
			// read Flush Data and goto again label
			//-----------------------------------------------
			if (FTL_L_Read(
				map->curPBA,
				map->curPPO,
				ml_basebuff)
			)
			{
				// Fatal
				return SMT_FALSE; 
			}

			// update last information of pba , ppo
			// And seek to next ppo
			map->LastPBA	= map->curPBA; 
			map->LastPPO	= map->curPPO;	
			map->curPPO++; 				

			goto again;
		}
	}

	//-------------------------------------------------------
	// remain mapPageBlk is not aligned
	//-------------------------------------------------------
	while(SMT_TRUE)
	{
		//---------------------------------------------------
		// Check next block (shadow)
		//---------------------------------------------------
		if(ppo == gDevInfo.pagePerBlks) 
		{
			// goto next shadow index 
			idxcou++;											   
			if(idxcou == FTL_MAPBLOCK_DEPTH) break; 

			// get its value 
			index = map->mapPageBlk[idxcou];	
			if(index == INDEX_NA) break;	

			// get pba from index  and ppo set to zero
			//pba	= (smtBlkAddr)(gpFlush->freeBlks[index]&FTL_BTYPE_MAPPAGE);	
			pba	= (smtBlkAddr)(gpFlush->freeBlks[index]&FTL_BLKADDR_MASK);	
			ppo	= 0;												
		}

		//---------------------------------------------------
		// read spare area for mapdir
		//---------------------------------------------------
		if (!FTL_L_ReadPart(
			pba,			
			ppo,
			(smtUint8*)sptr,
			FTL_L_S0))	
		{
			// check if it is a map page
			if (sptr->u.map.block_type & FTL_BTYPE_MAPPAGE) 
			{
				pfragMap		= &gpMapDir[sptr->u.map.frag];
				pfragMap->PBA	= pba;					
				pfragMap->PPO	= ppo;					
				pfragMap->index	= FTL_L_M0_0;				
				
				mappage	= 1;						
			}
		}

		// go to next page 
		ppo++;	
	}
	

	// check if any mappage found 
	if (!mappage)
	{
		// no mappage found, eg. FLT missing after format 
		return SMT_FALSE; 
	}

	// successfuly built 
	return SMT_TRUE; 
}
/*----------------------------------------------------------
	Function name	: FTL_O_BuildMap
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: build top for log, wear, map directory
-----------------------------------------------------------*/
smtBoolean 			// SMT_TRUE/SMT_FALSE, ok/error
FTL_O_BuildMap(
void
)
{
	
	smtUint32 	wear_sum		= 0;	// summary of wears 
	smtUint32 	wear_count		= 0;	// counting number of wears  
	smtUint32 	wear_average	= 0;
	smtPageAddr po,lastPO, mappagePO;
	ST_SPARE 	*sptr;

	smtUint8	mapBlkIdx;
	ST_MAPBLOCK	*map;
	
	sptr=GET_SPARE_AREA(ml_buffer);

	// reset stepback 
	gpMapBlocks->stepback = 0; 
	
	for(mapBlkIdx = 0; mapBlkIdx < FTL_MAPBLOCK_NUM; mapBlkIdx++)
	{
		map = &gpMapBlocks->mapBlks[mapBlkIdx];
		SMT_ASSERT(map->curPBA != BLK_NA);	
		
		//---------------------------------------------------
		// Search last erased only page, (lastpo)
		//---------------------------------------------------
		for(po = gDevInfo.pagePerBlks-1; po >= 0; po--)
		{
			smtInt32 ret = FTL_L_Read(
				map->curPBA,
				(smtUint8)po,
				ml_buffer
			);
					
			lastPO = (smtUint8)po;
			if (ret != FTL_L_ERASED) break;
		}
		//---------------------------------------------------
		// Search last po in block 
		//---------------------------------------------------
		map->curPPO = INDEX_NA;
		for(po = 0; po <= lastPO; po++)
		{
			smtInt32 ret = FTL_L_Read(
				map->curPBA, 
				po, 
				ml_buffer
			);
			if (ret == FTL_L_OK)
			{
				if (sptr->u.map.block_type & FTL_BTYPE_MAPPAGE)
				{
					mappagePO = po;
				}
			}
		}
		// fatal, no map page in blk found 
		SMT_ASSERT(mappagePO != INDEX_NA);	


		// read it 
		if (FTL_L_Read(
			map->curPBA,
			mappagePO,
			ml_basebuff)
		) 
		{
			// Fatal
			return SMT_FALSE;
		}

		//---------------------------------------------------
		// update map block information
		//---------------------------------------------------
		map->curPPO		= lastPO;		
		map->LastPBA	= map->curPBA; 	
		map->LastPPO	= mappagePO;		

		if (BuildMap(map) == SMT_FALSE)
		{
			// Fatal
			return SMT_FALSE;
		}

	}	
	
	return SMT_TRUE;

}