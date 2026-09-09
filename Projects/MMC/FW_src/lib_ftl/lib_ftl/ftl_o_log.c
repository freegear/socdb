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
	Function name	: buildLog
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: rebuilding log cache information
-----------------------------------------------------------*/
void 
BuildLog(
void
)
{
	
	ST_LOG 		*log;
	smtUint8 	idx;
	smtBlkAddr 	pba;
	smtPageAddr po,lastpo;
	ST_SPARE 	*sptr;
	
	sptr=GET_SPARE_AREA(ml_buffer);
	
	//-------------------------------------------------------
	// building log blocks 
	//-------------------------------------------------------
	gpLogCache->lockedCnt			= 0;
	log							= gpLogCache->logs;
	for(idx = 0; idx < gpFlush->freeBlkNum; idx++)
	{

		if((gpFlush->freeBlks[idx]&(FTL_FBTYPE_MAP|FTL_FBTYPE_LOG))==FTL_FBTYPE_LOG)
		{
			pba				= (smtBlkAddr)(gpFlush->freeBlks[idx]&FTL_BLKADDR_MASK);
			log->lastppo	= gDevInfo.pagePerBlks;
			log->pba		= pba;
			log->switchable	= 1;
			log->index		= idx;

			// searching the last page from top 
			lastpo = gDevInfo.pagePerBlks;
			for(po = 0;po < gDevInfo.pagePerBlks; po++)
			{ 
				int ret=FTL_L_Read(
						pba,
						(smtUint8)(gDevInfo.pagePerBlks-po-1),
						ml_buffer
					);
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
				int ret = FTL_L_Read(pba,po,ml_buffer);
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
				gpLogCache->lockedCnt++;
			}
			else
			{
				// nothing was written, so remove log block flag
				// reset data in not used log blk  
				gpFlush->freeBlks[idx]		   &= (~FTL_FBTYPE_LOG);
				log->lastppo					= INDEX_NA;		
				log->pba						= BLK_NA;
			}
		}
	}
	
}
/*----------------------------------------------------------
	Function name	: FTL_O_BuildLog
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: build top for log, wear, map directory
-----------------------------------------------------------*/
smtBoolean 			// SMT_TRUE/SMT_FALSE, ok/error
FTL_O_BuildLog(
void
)
{
	
	smtUint32 	wear_sum		= 0;	// summary of wears 
	smtUint32 	wear_count		= 0;	// counting number of wears  
	smtUint32 	wear_average	= 0;
	smtUint8 	idx;
	smtBlkAddr 	pba,lba;
	ST_SPARE 	*sptr;

	smtUint8	mapBlkIdx;
	
	sptr=GET_SPARE_AREA(ml_buffer);


	// counting blocks 
	for(lba = 0; lba < (gDevInfo.blks - gpFlush->freeBlkNum); lba++)
	{
		pba = FTL_C_GetPhy(lba);
        if (pba == BLK_NA) 
        {
        	break;
        }
        gDevInfo.dataBlks++;
	}
	

	// Check if step back is requested 
	if (gpMapBlocks->stepback)
	{
		gpMapBlocks->stepback->curPPO		= gDevInfo.pagePerBlks;
		gpMapBlocks->stepback->depthIdx	= FTL_MAPBLOCK_DEPTH; // Force map merge 

		if(!FTL_C_LoadFrag(gpMapBlocks->stepback->startFragIdx)) 
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
		smtUint32		mapCntL		= 0;
		smtUint32		mapCntH		= 0;
		ST_MAPBLOCK		*lastMap	= &gpMapBlocks->mapBlks[0];

		for (mapBlkIdx = 0; mapBlkIdx < FTL_MAPBLOCK_NUM; mapBlkIdx++)
		{
			if(gpMapBlocks->mapBlks[mapBlkIdx].mapCntH > mapCntH)
			{
				mapCntL	= gpMapBlocks->mapBlks[mapBlkIdx].mapCntL;
				mapCntH	= gpMapBlocks->mapBlks[mapBlkIdx].mapCntH;
				lastMap	= &gpMapBlocks->mapBlks[mapBlkIdx];
			}
			else if(
				(gpMapBlocks->mapBlks[mapBlkIdx].mapCntH == mapCntH)
			 && (gpMapBlocks->mapBlks[mapBlkIdx].mapCntL > mapCntL)
			)
			{
				mapCntL = gpMapBlocks->mapBlks[mapBlkIdx].mapCntL;
				mapCntH = gpMapBlocks->mapBlks[mapBlkIdx].mapCntH;
				lastMap	= &gpMapBlocks->mapBlks[mapBlkIdx];
			}
		}

		// check ml_basebuff
		if (FTL_L_Read(
			lastMap->LastPBA,
			lastMap->LastPPO,
			ml_basebuff)
			) 
		{
			// fatal 
			return SMT_FALSE;
		}


		// read the last freelog table 
		gpFlush->mapInfo->mapCntL = gpMapBlocks->maxMapCntL;
		gpFlush->mapInfo->mapCntH = gpMapBlocks->maxMapCntH;
	}	

	
	// calculate current average for dynamic 
	if(wear_count) 
	{
		wear_average = (wear_sum/wear_count); 
	}

	//-------------------------------------------------------------------------
	// fill dynamic wear info table 
	//-------------------------------------------------------------------------
	for(idx=0; idx < gpFlush->freeBlkNum; idx++)
	{
		if((gpFlush->freeBlks[idx]&FTL_FBTYPE_BAD) != FTL_FBTYPE_BAD)
		{
			pba = (smtBlkAddr)(gpFlush->freeBlks[idx]&FTL_BLKADDR_MASK);
			if (FTL_L_Read(pba,0,ml_buffer)==FTL_L_OK)
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

	BuildLog();


	return SMT_TRUE;

}