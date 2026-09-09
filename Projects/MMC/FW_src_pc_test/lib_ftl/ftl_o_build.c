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
	Function name	: ml_buildmap
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
	ST_SPARE 	*sptr=GET_SPARE_AREA(gTempBuffer);
	smtUint8 	mappage;
	smtUint8 	cou;
	smtUint8 	index;
	smtUint8 	idxcou;
	ST_MAPDIR 	*pfragMap;
	smtFrag 		frag,fragcou;
	smtBlkAddr 		pba;
	smtPageAddr 		ppo;


	// label for step back 
again: 

	//-------------------------------------------------------
	// go through on all index entry 
	//-------------------------------------------------------
	map->depthIdx = INDEX_NA;
	for (cou = 0; cou < FTL_MAPBLOCK_DEPTH; cou++)
	{
		index = gFlush.mapInfo->mapPageBlk[cou];
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
	map->mapCntH	= gFlush.mapInfo->mapCntH;	// get last map cntH
	map->mapCntL	= gFlush.mapInfo->mapCntL;	// get last map cntL

	// check if this is the maximum counter 
	if(gFlush.mapInfo->mapCntH > gMapBlocks.maxMapCntH)
	{
		gMapBlocks.maxMapCntL	= gFlush.mapInfo->mapCntL;
		gMapBlocks.maxMapCntH	= gFlush.mapInfo->mapCntH;
	}
	else
	{
		if((gFlush.mapInfo->mapCntH == gMapBlocks.maxMapCntH)
		&& (gFlush.mapInfo->mapCntL  > gMapBlocks.maxMapCntL))
		{
			gMapBlocks.maxMapCntL	= gFlush.mapInfo->mapCntL;
			gMapBlocks.maxMapCntH	= gFlush.mapInfo->mapCntH;
		}
	}
	
	

	mappage	= 0;						// signal we didn't find any map page 
	idxcou	= 0;						// reset index counter 
	index	= map->mapPageBlk[idxcou];	// get its value 
	SMT_ASSERT(index != INDEX_NA);		// 1st index cannot be not available
	
	pba		= (smtBlkAddr)(gFlush.freeBlks[index]&FT_ADDRMASK);	// get pba from index 
	ppo		= 0;											// ppo value starts from 0 
	frag	= map->startFragIdx;							// initialize start fragment 

	//-------------------------------------------------------
	// First mapPageBlk is aligned mappage + frags
	//-------------------------------------------------------
	pfragMap	= &gMapDir[frag];
	fragcou	= (smtFrag)(gMapBlocks.maxFragPerMapBlk/2);			
	while(fragcou)
	{
		if(ppo == gDevInfo.pagePerBlks) {
			
			// goto next shadow index 
			idxcou++;								  	 		
			SMT_ASSERT(idxcou != FTL_MAPBLOCK_DEPTH);
			
			// get its value 
			index = map->mapPageBlk[idxcou];					
			if(index == INDEX_NA)
			{	// index cannot be not available until 
				// all frags is not collected
				return SMT_FALSE;
			}

			// get pba from index & ppo value starts from 0 
			pba	= (smtBlkAddr)(gFlush.freeBlks[index]&FT_ADDRMASK);
			ppo	= 0;										
		}

		// read page's spare area 
		if (!FTL_L_ReadPart(
				pba,
				ppo,
				(smtUint8*)sptr,
				FTL_L_SP)
			) 
		{
			// check page type 
			if (sptr->u.map.block_type & BLK_MAPPAGE_FLAG) 
			{
				// 1st page is always map page other must be 
				// original until collected 
				SMT_ASSERT(ppo == 0);
				
				// get frag map information
				pfragMap=&gMapDir[sptr->u.map.frag];
				pfragMap->PBA		= pba;				
				pfragMap->PPO		= ppo;				
				pfragMap->index		= 1;				

				// restore frag map
				pfragMap			= &gMapDir[frag];	
				
				// we found a mappage 	
				mappage			= 1;					
			}
			else 
			{

				// check stored fragment pair 
				SMT_ASSERT(sptr->u.map.frag == frag);

				// fill first frag information
				pfragMap->PBA	= pba;	
				pfragMap->PPO	= ppo;	
				pfragMap->index	= 1;	
				pfragMap++;				

				// fill second frag information
				pfragMap->PBA	= pba;	
				pfragMap->PPO	= ppo;	
				pfragMap->index	= 0;	
				pfragMap++;				

				frag+=2;				// go to next 2 fragment 
				fragcou--;				// decrementing pair counter 
			}

			// goto next page 
			ppo++; 
		}
		else
		{
			// broken mapdir, so step back check if there was any step back 
			// and set step back value to the current map block 
			SMT_ASSERT(gMapBlocks.stepback == 0);
			gMapBlocks.stepback = map;		   
			
			// check if pba and ppo valid for step back
			SMT_ASSERT(gFlush.mapInfo->LastPBA != BLK_NA);
			SMT_ASSERT(gFlush.mapInfo->LastPPO != INDEX_NA);

			// get last stored pba and ppo of mappage 
			map->curPBA = gFlush.mapInfo->LastPBA;
			map->curPPO = gFlush.mapInfo->LastPPO;

			//-----------------------------------------------
			// read Flush Data and goto again label
			//-----------------------------------------------
			if (FTL_L_ReadPart(
				map->curPBA,
				map->curPPO,
				gFlushBuffer,
				FTL_L_2ND)
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
			pba	= (smtBlkAddr)(gFlush.freeBlks[index]&FT_ADDRMASK);	
			ppo	= 0;												
		}

		//---------------------------------------------------
		// read spare area for mapdir
		//---------------------------------------------------
		if (!FTL_L_ReadPart(
			pba,			
			ppo,
			(smtUint8*)sptr,
			FTL_L_SP))	
		{
			// check if it is a map page
			if (sptr->u.map.block_type & BLK_MAPPAGE_FLAG) 
			{
				pfragMap		= &gMapDir[sptr->u.map.frag];
				pfragMap->PBA	= pba;					
				pfragMap->PPO	= ppo;					
				pfragMap->index	= 1;				
				
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
	Function name	: ml_buildlog
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: rebuilding log cache information
-----------------------------------------------------------*/
void 
ml_buildlog(
void
)
{
	
	ST_LOG 		*log;
	smtUint8 	idx;
	smtBlkAddr 	pba;
	smtPageAddr po,lastpo;
	ST_SPARE 	*sptr;
	
	sptr=GET_SPARE_AREA(gTempBuffer);
	
	//-------------------------------------------------------
	// building log blocks 
	//-------------------------------------------------------
	gLogCache.lockedCnt			= 0;
	log							= gLogCache.logs;
	for(idx = 0; idx < gFlush.freeBlkNum; idx++)
	{

		if((gFlush.freeBlks[idx]&(FT_MAP|FT_LOG))==FT_LOG)
		{
			pba = (smtBlkAddr)(gFlush.freeBlks[idx]&FT_ADDRMASK);
			log->lastppo	= gDevInfo.pagePerBlks;
			log->pba		= pba;
			log->switchable	= 1;
			log->index		= idx;

			// searching the last page from top 
			lastpo = gDevInfo.pagePerBlks;
			for(po = 0;po < gDevInfo.pagePerBlks; po++)
			{ 
				int ret=FTL_L_Read(pba,(smtUint8)(gDevInfo.pagePerBlks-po-1),gTempBuffer);
				if (ret==FTL_L_ERASED) 
				{
					lastpo = (smtUint8)(gDevInfo.pagePerBlks-po-1);
				}
				else 
				{
					break;
				}
			}

			// building log blk 
			log->lastppo = lastpo;
			for(po = 0; po < lastpo; po++)
			{		
				int ret = FTL_L_Read(pba,po,gTempBuffer);
				if (ret == FTL_L_OK) 
				{
					log->ppo[sptr->u.log.lpo]	= po;
					log->lba					= sptr->u.log.lba;
					if (po != sptr->u.log.lpo) 
					{
						log->switchable = 0;
					}

					if(!po)
					{
						log->wear = sptr->wear;
					}
				}
				else 
				{
					// if error or hole in the log block 
					log->switchable = 0; 
				}
			}

			if (log->lastppo != 0)
			{
				log++;
				gLogCache.lockedCnt++;
			}
			else
			{
				// nothing was written, so remove log block flag
				// reset data in not used log blk  
				gFlush.freeBlks[idx]		   &= (~FT_LOG);
				log->lastppo					= INDEX_NA;		
				log->pba						= BLK_NA;
			}
		}
	}
	
}
/*----------------------------------------------------------
	Function name	: FTL_O_BuildCache
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: build top for log, wear, map directory
-----------------------------------------------------------*/
smtBoolean 			// SMT_TRUE/SMT_FALSE, ok/error
FTL_O_BuildCache(
void
)
{
	
	smtUint32 	wear_sum		= 0;	// summary of wears 
	smtUint32 	wear_count		= 0;	// counting number of wears  
	smtUint32 	wear_average	= 0;
	smtUint8 	idx;
	smtUint8 	cou;
	smtBlkAddr 		pba,lba;
	smtPageAddr 		po,lastpo;
	ST_SPARE 	*sptr;
	
	sptr=GET_SPARE_AREA(gTempBuffer);

	// reset stepback 
	gMapBlocks.stepback = 0; 
	
	for(cou = 0; cou < FTL_MAPBLOCK_NUM; cou++)
	{
		ST_MAPBLOCK	*map = &gMapBlocks.mapBlks[cou];
		SMT_ASSERT(map->curPBA != BLK_NA);	
		
		//---------------------------------------------------
		// Search last erased only page, (lastpo)
		//---------------------------------------------------
		lastpo = gDevInfo.pagePerBlks;
		for(po = 0; po < gDevInfo.pagePerBlks; po++)
		{
			smtInt32 ret = FTL_L_Read(
				map->curPBA,
				(smtUint8)(gDevInfo.pagePerBlks-po-1),
				gTempBuffer
			);
					
			if (ret == FTL_L_ERASED) 
			{
				lastpo = (smtUint8)(gDevInfo.pagePerBlks-po-1);
			}
			else 
			{
				break;
			}
		}
		//---------------------------------------------------
		// Search last po in block 
		//---------------------------------------------------
		map->curPPO = INDEX_NA;
		for(po = 0; po < lastpo; po++)
		{
			smtInt32 ret = FTL_L_Read(map->curPBA, po, gTempBuffer);
			if (ret == FTL_L_OK)
			{
				if (sptr->u.map.block_type & BLK_MAPPAGE_FLAG)
				{
					map->curPPO = po;
				}
			}
		}
		// fatal, no map page in blk found 
		SMT_ASSERT(map->curPPO != INDEX_NA);	


		// read it 
		if (FTL_L_ReadPart(
			map->curPBA,
			map->curPPO,
			gFlushBuffer,
			FTL_L_2ND)
		) 
		{
			// Fatal
			return SMT_FALSE;
		}

		//---------------------------------------------------
		// update map block information
		//---------------------------------------------------
		map->LastPBA	= map->curPBA; 	
		map->LastPPO	= map->curPPO;
		map->curPPO		= lastpo;		
		

		if (BuildMap(map) == SMT_FALSE)
		{
			// Fatal
			return SMT_FALSE;
		}

	}	
	
	// counting blocks 
	for(lba = 0; lba < gDevInfo.blks; lba++)
	{
		pba = FTL_C_GetPhy(lba);
        if (pba == BLK_NA) 
        {
        	break;
        }
        gDevInfo.dataBlks++;
	}

	// Check if step back is requested 
	if (gMapBlocks.stepback)
	{
		gMapBlocks.stepback->curPPO		= gDevInfo.pagePerBlks;
		gMapBlocks.stepback->depthIdx	= FTL_MAPBLOCK_DEPTH; // Force map merge 

		if(!FTL_C_LoadFrag(gMapBlocks.stepback->startFragIdx)) 
		{
			return SMT_FALSE;
		}
		
		if(FTL_C_SaveMap()) 
		{
			return SMT_FALSE;
		}
	}
	
	{
		// finding last fltable 
		smtUint32		mapCntL	= 0;
		smtUint32		mapCntH	= 0;
		ST_MAPBLOCK		*lastMap		= &gMapBlocks.mapBlks[0];

		for (cou = 0; cou < FTL_MAPBLOCK_NUM;cou++)
		{
			if(gMapBlocks.mapBlks[cou].mapCntH > mapCntH)
			{
				mapCntL	= gMapBlocks.mapBlks[cou].mapCntL;
				mapCntH	= gMapBlocks.mapBlks[cou].mapCntH;
				lastMap	= &gMapBlocks.mapBlks[cou];
			}
			else if(
				(gMapBlocks.mapBlks[cou].mapCntH == mapCntH)
			 && (gMapBlocks.mapBlks[cou].mapCntL > mapCntL)
			)
			{
				mapCntL = gMapBlocks.mapBlks[cou].mapCntL;
				mapCntH = gMapBlocks.mapBlks[cou].mapCntH;
				lastMap	= &gMapBlocks.mapBlks[cou];
			}
		}

		if (FTL_L_ReadPart(
			lastMap->LastPBA,
			lastMap->LastPPO,
			gFlushBuffer,
			FTL_L_2ND)
			) 
		{
			// fatal 
			return SMT_FALSE;
		}


		// read the last freelog table 
		gFlush.mapInfo->mapCntL = gMapBlocks.maxMapCntL;
		gFlush.mapInfo->mapCntH = gMapBlocks.maxMapCntH;
	}	
	
	ml_buildlog();
	
	
	// calculate current average for dynamic 
	if(wear_count) 
	{
		wear_average = (wear_sum/wear_count); 
	}

	//-------------------------------------------------------------------------
	// fill dynamic wear info table 
	//-------------------------------------------------------------------------
	for(idx=0; idx<gFlush.freeBlkNum; idx++)
	{
		if((gFlush.freeBlks[idx]&FT_BAD) != FT_BAD)
		{
			pba = (smtBlkAddr)(gFlush.freeBlks[idx]&FT_ADDRMASK);
			if (FTL_L_Read(pba,0, gTempBuffer)==FTL_L_OK)
			{
				FTL_W_UpdateDInfo(idx,sptr->wear);
			}
			else
			{
				FTL_W_UpdateDInfo(idx,wear_average);
			}
		}
	}

	FTL_W_ReleaseDLock();	

	return SMT_TRUE;

}