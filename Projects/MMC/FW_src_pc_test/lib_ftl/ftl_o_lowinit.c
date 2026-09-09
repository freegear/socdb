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
	smtInt32	a;
	smtUint32	ret;


	
	memset(gFlushBuffer	,0xFF	,sizeof(gFlushBuffer));
	memset(gTempBuffer	,0xFF	,sizeof(gTempBuffer));
	memset(gMapDir		,0xFF	,sizeof(gMapDir));
	memset(&gLogCache	,0xFF	,sizeof(gLogCache));
	memset(&gFlush		,0xFF	,sizeof(gFlush));

	gFlush.freeBlkNum			= MAX_FREE_BLOCK_AVAILABLE;
	gDevInfo.blks				= 0;
	gDevInfo.pagePerBlks		= 0;
	gDevInfo.pageSize			= 0;

	ret = FTL_L_Init();
	SMT_ASSERT(ret != FTL_L_ERROR);

	SMT_ASSERT(gDevInfo.blks		!= 0);
	SMT_ASSERT(gDevInfo.pagePerBlks != 0);
	SMT_ASSERT(gDevInfo.pageSize	!= 0);
	SMT_ASSERT(gDevInfo.blks		<= MAX_BLOCK_AVAILABLE);
	SMT_ASSERT(gDevInfo.pagePerBlks <= MAX_PAGE_PER_BLOCK_AVAILABLE);
	SMT_ASSERT(gDevInfo.pageSize	<= MAX_DATA_SIZE);
	SMT_ASSERT(gFlush.freeBlkNum	<= MAX_FREE_BLOCK_AVAILABLE);


	//	maxFragPerMapBlk 
	gMapBlocks.maxFragPerMapBlk
	= (smtFrag)((gDevInfo.blks/MAX_FRAGSIZE)/FTL_MAPBLOCK_NUM);
	
	// max frag per block cannot be zero 
	if(!gMapBlocks.maxFragPerMapBlk)
	{
		//maxFragPerMapBlk = 2; 
		gMapBlocks.maxFragPerMapBlk = 2;
	}
	
	// max frag per block must be even number 
	if(gMapBlocks.maxFragPerMapBlk & 1)
	{
		gMapBlocks.maxFragPerMapBlk++;
	}

	gLogCache.curLog			= 0;
	gLogCache.lockedCnt			= 0;
	gLogCache.nextIdx			= 0;
	gLogCache.num				= MAX_LOG_BLOCK_AVAILABLE;
	if(gLogCache.num > MAX_LOG_BLOCK_AVAILABLE)
	{
		return SMT_FALSE;
	}



	//-------------------------------------------------------
	//	gFlushBuffer's memory  lock
	//	-> static_wear/mapInfo/gl_freetable
	//-------------------------------------------------------
	// allocate ptrs in the half page 
	gFlush.staticInfo		= (ST_STATIC*)gFlushBuffer;
	gFlush.mapInfo			= (ST_MAPINFO*)((smtUint8*)gFlush.staticInfo+sizeof(ST_STATIC));
	gFlush.freeBlks			= (smtBlkAddr*)((smtUint8*)gFlush.mapInfo+sizeof(ST_MAPINFO));
	gFlush.fragBuf			= (smtBlkAddr*)(gFlushBuffer+(MAX_DATA_SIZE/2)+MAX_SPARE_SIZE);
	FTL_W_Init(gFlush.staticInfo);


	// check if data above is fit into a half page 
	{

		smtInt32 freesize
			= (smtInt32)(
				(smtInt32)(gFlushBuffer+gDevInfo.pageSize/2)
		       -(smtInt32)(&gFlush.freeBlks[gFlush.freeBlkNum])
		    );
			
		// this size must be positive, showing how many 
		// bytes are left there 
		if (freesize < 0) 
		{
			// FATAL: freetable is not fit into a half page 
			return SMT_FALSE;
		}
	}


	
	// check spare size 
	if ((gDevInfo.pageSize/32) < sizeof(ST_SPARE))
	{
		// pagesize in a 512 data device cannot be more 
		// than 16 bytes or pagesize in a 2048 data device 
		// cannot be more than 64 bytes 
		return SMT_FALSE;
	}

	// check necessary map shadow blocks 
	if(((gMapBlocks.maxFragPerMapBlk/2)/gDevInfo.pagePerBlks)+1 
		> FTL_MAPBLOCK_DEPTH)
	{
		// FATAL 
		return SMT_FALSE;
	}
	

	//-------------------------------------------------------
	// reset fragment cache 
	// gFragCache variable initialize
	//-------------------------------------------------------
	// set current frag also NA 
	gFragCache.num = FRAG_NA;		 

	// filling variables of mapblocks 
	for (a = 0; a < FTL_MAPBLOCK_NUM; a++)
	{
		ST_MAPBLOCK	*mapblock	= &gMapBlocks.mapBlks[a];

		mapblock->LastPBA		= BLK_NA;
		mapblock->LastPPO		= INDEX_NA;
		mapblock->blockType		= (smtUint8)(BLK_TYPE_MAP_ORI+a);
		mapblock->curPBA		= BLK_NA;
		mapblock->curPPO		= INDEX_NA;
		mapblock->ref_count		= 0;
		mapblock->startFragIdx	= (smtFrag)(a*gMapBlocks.maxFragPerMapBlk);
		mapblock->endFragIdx	= (smtFrag)(mapblock->startFragIdx+gMapBlocks.maxFragPerMapBlk);
		mapblock->depthIdx		= 0;
		memset(mapblock->mapPageBlk,INDEX_NA,FTL_MAPBLOCK_DEPTH);
	}


	
	gMapBlocks.maxMapCntL	= 0;
	gMapBlocks.maxMapCntH	= 0;
	gOpInfo.SaveMapNeed		= SMT_FALSE;

	memset(gMapDir, 0xFF, sizeof(gMapDir));
	gDevInfo.dataBlks = 0;

	

	//-------------------------------------------------------
	// gFlushBuffer memory lock -> gFragCache.ppbas
	//-------------------------------------------------------

	// set all cache entry half buffer's 
	gFragCache.ppba	= gFlush.fragBuf;
	
	return SMT_TRUE;
}