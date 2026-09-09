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
	Function name	: FTL_O_LowInit
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: low level initialize, this must be called 
					  from FTL_O_Init and FTL_O_Format 
-----------------------------------------------------------*/
smtBoolean 		// SMT_TRUE/SMT_FALSE, ok/any error
FTL_O_LowInit(
void
)
{
	smtUint8 mapBlkIdx;

	gpFlush->freeBlkNum			= FTL_FREEBLK_MAXNUM;
	gDevInfo.blks				= 0;
	gDevInfo.pagePerBlks		= 0;
	gDevInfo.pageSize			= 0;

	if(FTL_L_Init() == FTL_L_ERROR) 
	{
		return SMT_FALSE;
	}

	SMT_ASSERT(gDevInfo.blks			!= 0);
	SMT_ASSERT(gDevInfo.pagePerBlks		!= 0);
	SMT_ASSERT(gDevInfo.pageSize		!= 0);
	SMT_ASSERT(gDevInfo.blks			<= FTL_BLOCK_MAXNUM);
	SMT_ASSERT(gDevInfo.pagePerBlks		<= FTL_PAGEPERBLOCK_MAXNUM);
	SMT_ASSERT(gDevInfo.pageSize		<= FTL_DATA_MAXSIZE);
	SMT_ASSERT(gpFlush->freeBlkNum		<= FTL_FREEBLK_MAXNUM);
	SMT_ASSERT(gDevInfo.pageSize/32		>= sizeof(ST_SPARE));
	

	//	maxFragPerMapBlk 
	gpMapBlocks->maxFragPerMapBlk
	= (smtFrag)((gDevInfo.blks/FTL_FRAG_POOLPERNUM)/FTL_MAPBLOCK_NUM);
	
	// max frag per block cannot be zero 
	if(!gpMapBlocks->maxFragPerMapBlk)
	{
		//maxFragPerMapBlk = 2; 
		gpMapBlocks->maxFragPerMapBlk = 2;
	}
	
	// max frag per block must be even number 
	if(gpMapBlocks->maxFragPerMapBlk & 1)
	{
		gpMapBlocks->maxFragPerMapBlk++;
	}

	gpLogCache->curLog			= 0;
	gpLogCache->lockedCnt			= 0;
	gpLogCache->nextIdx			= 0;
	gpLogCache->num				= FTL_LOG_MAXNUM;
	memset(gpLogCache->logs, 0xFF, sizeof(gpLogCache->logs));
	SMT_ASSERT(gpLogCache->num <= FTL_LOG_MAXNUM);
	

	//-------------------------------------------------------
	//	ml_basebuff's memory  lock
	//	-> static_wear/mapInfo/gl_freetable
	//-------------------------------------------------------
	gpFlush->fragBuf			= (smtBlkAddr*)(ml_basebuff);
	gpFlush->staticInfo		= (ST_STATIC*)(ml_basebuff+1024);
	gpFlush->mapInfo			= (ST_MAPINFO*)(ml_basebuff+1024+sizeof(ST_STATIC));
	gpFlush->freeBlks			= (smtBlkAddr*)(ml_basebuff+1024+sizeof(ST_STATIC)+sizeof(ST_MAPINFO));

	gpFragCache->ppba			= gpFlush->fragBuf;
	gpFragCache->num			= FRAG_NA;		 

	gpMapBlocks->maxMapCntL	= 0;
	gpMapBlocks->maxMapCntH	= 0;

	gDevInfo.dataBlks		= 0;
	gfSaveMapNeed			= SMT_FALSE;


	{
		int i;

		for(i = 0; i < FTL_FRAG_MAXNUM; i++)
		{
			gpMapDir[i].PBA = (smtBlkAddr)0xFFFFFFFF;
			gpMapDir[i].PPO = (smtPageAddr)0xFFFFFFFF;
			gpMapDir[i].index = (smtUint8)0xFF;
		}
	}

	FTL_W_Init(gpFlush->staticInfo);

	//-------------------------------------------------------
	// reset fragment cache 
	// gFragCache variable initialize
	//-------------------------------------------------------
	// set current frag also NA 
	

	// filling variables of mapblocks 
	for (mapBlkIdx = 0; mapBlkIdx < FTL_MAPBLOCK_NUM; mapBlkIdx++)
	{
		ST_MAPBLOCK	*mapblock	= &gpMapBlocks->mapBlks[mapBlkIdx];

		mapblock->LastPBA		= BLK_NA;
		mapblock->LastPPO		= INDEX_NA;
		mapblock->blockType		= (smtUint8)(FTL_BTYPE_MAPBLK|mapBlkIdx);
		mapblock->curPBA		= BLK_NA;
		mapblock->curPPO		= INDEX_NA;
		mapblock->ref_count		= 0;
		mapblock->startFragIdx	= (smtFrag)(mapBlkIdx*gpMapBlocks->maxFragPerMapBlk);
		mapblock->endFragIdx	= (smtFrag)(mapblock->startFragIdx+gpMapBlocks->maxFragPerMapBlk);
		mapblock->depthIdx		= 0;
		memset(mapblock->mapPageBlk,INDEX_NA,FTL_MAPBLOCK_DEPTH);
		
	}
	
	return SMT_TRUE;
}