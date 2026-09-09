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
#include "ftl_c_core.h"
#include "ftl_w_wear.h"
/*
/////////////////////////////////////////////////////////
        GLOBAL VARIABLE
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
#define	FTL_COM_FRAGCACHE_GETPBA(l)		(gFragCache.ppba[(l)%MAX_FRAGSIZE])
#define	FTL_COM_FRAGCACHE_SETPBA(l, p)	(gFragCache.ppba[(l)%MAX_FRAGSIZE] = (p))
#define	FTL_COM_FRAGCACHE_GETFRAGNUM(l)	((smtFrag)((l)/MAX_FRAGSIZE))
#define	FTL_COM_MAPBLOCK_GETIDX(f)		((f)/gMapBlocks.maxFragPerMapBlk)
/*----------------------------------------------------------
	Function name	: FTL_C_LoadFrag
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: load frag into RAM and set as current frag
-----------------------------------------------------------*/
smtBoolean 			// SMT_TRUE/SMT_FALSE, success/error
FTL_C_LoadFrag(
smtFrag num			// fragment number to load
)
{
	ST_MAPDIR 	*pfragMap;

	// load if not cached 
	if(gFragCache.num != num)
	{
		
		// get cache entry buffer's and current frag map pointer
		pfragMap = &gMapDir[num];				

		// read that half part 
		if (FTL_L_ReadPart(
			pfragMap->PBA,				// Target fragment pba
			pfragMap->PPO,				// Target fragment ppo
			(smtUint8*)gFragCache.ppba,	// Target buffer for pbas
			pfragMap->index)			// Nand region index
		) 
		{ 
			gFragCache.num = FRAG_NA;
			return SMT_FALSE;
		}

		// set cache field to current fragnumber and pointer
		gFragCache.num 	= num;		
	}

	return SMT_TRUE;
}
/*----------------------------------------------------------
	Function name	: FTL_C_WriteFrag
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: subfunction for formatting to write current 
					  fragments in fragbuff
-----------------------------------------------------------*/
smtBoolean 			// SMT_TRUE/SMT_FALSE, success/other error
FTL_C_WriteFrag(
smtFrag 	frag, 	// current frag number
smtUint8	*buff	// fragment cache buffer
)
{
	ST_MAPBLOCK		*mapblock	= FTL_C_GetfMapBlk(frag);
	ST_SPARE		*sptr;
	ST_MAPDIR		*mapdir;


	// FATAL, out of range 
	if (!mapblock) 
	{
		return SMT_FALSE;	
	}

	// Check if there is any space 
	if (mapblock->curPPO == gDevInfo.pagePerBlks) 
	{
		// allocate another block 
		FTL_C_AllocMapBlk(mapblock);
	}

	// check if this is the 1st page of the mapblock 
	// here this is the 1st write of the block and
	// write reference counter 
	sptr = GET_SPARE_AREA(buff);
	if (mapblock->curPPO == 0) 
	{
		sptr->wear				= 1;					
		sptr->u.map.ref_count	= mapblock->ref_count; 	
	}
	// signal original fragments here, store the fragment number
	sptr->u.map.block_type	= mapblock->blockType;		
	sptr->u.map.frag		= frag;						

	if (FTL_L_Write(
		mapblock->curPBA, 
		mapblock->curPPO, 
		buff) == FTL_L_ERROR) 
	{
		// Fatal 
		return SMT_FALSE; 
	}


	// store mapdir info 2 frags are a pair in the fragment area 
	mapdir			= &gMapDir[frag];	
	mapdir->PBA		= mapblock->curPBA;
	mapdir->PPO		= mapblock->curPPO;
	mapdir->index	= 1;

	// goto the next mapdir (2nd frag) 
	mapdir++;					
	mapdir->PBA		= mapblock->curPBA;
	mapdir->PPO		= mapblock->curPPO;
	mapdir->index	= 0;

	// goto next available 
	mapblock->curPPO++;			

	return SMT_TRUE;
}

/*----------------------------------------------------------
	Function name	: FTL_C_GetFrag
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: function copy the requested frag content 
					  to destionation buffer if its cached then 
					  it copies other case it reads
-----------------------------------------------------------*/
void 				// None
FTL_C_GetFrag(
smtFrag 	frag, 	// Requested fragment number
smtUint8	*dest	// Destination buffer
) 
{
	
	
	// check if its cached 
	if(gFragCache.num == frag)
	{
		// simple copy 
		memcpy(
			dest,
			gFragCache.ppba,
			(smtInt32)gDevInfo.pageSize/2
		); 
	}
	else
	{
		// getting mapdir 
		ST_MAPDIR *pfragMap = &gMapDir[frag]; 

		// read requested part 
		if (FTL_L_ReadPart(
			pfragMap->PBA,
			pfragMap->PPO,
			dest,
			pfragMap->index)
			)
		{
			// fills with ff-s if error 
			memset(
				dest, 
				0xFF,
				(smtInt32)gDevInfo.pageSize/2
			); 
		}
	}
}
/*----------------------------------------------------------
	Function name	: FTL_C_CollectFrag
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: function collects store or cached fragments
-----------------------------------------------------------*/
smtBoolean 				// SMT_TRUE/SMT_FALSE, success/other error
FTL_C_CollectFrag(
ST_MAPBLOCK	*mapblock	// mapblock which contains fragtments
)
{
	smtFrag		cou;		
	smtFrag		frag;					
	smtUint8	*dest;
	
	
	cou		= (smtFrag)(gMapBlocks.maxFragPerMapBlk/2);
	frag	= mapblock->startFragIdx;					

	//-------------------------------------------------------
	// collect all fragments 
	//-------------------------------------------------------
	while (cou--)					
	{
		// Check if there is any space 
		if (mapblock->curPPO == gDevInfo.pagePerBlks) 
		{
			// allocate another block 
			FTL_C_AllocMapBlk(mapblock);

			// 1st page is always map page 
			if (FTL_C_StoreMappage(mapblock)) 
			{
				return SMT_FALSE;
			}

			// goto next page 
			mapblock->curPPO++;	
		}

		// collect 1st half is for even frags and get fragment
		dest = gTempBuffer;							
		FTL_C_GetFrag(frag, dest);				

		// collect 2nd half is for odd frags and get fragment
		dest += gDevInfo.pageSize/2;					
		FTL_C_GetFrag((smtFrag)(frag+1),dest);	

		// simple writes them 
		if (!FTL_C_WriteFrag(frag, gTempBuffer)) 
		{
			return SMT_FALSE;
		}

		// 2 fragment per page 
		frag += 2;								
	}

	return SMT_TRUE;
}
/*----------------------------------------------------------
	Function name	: FTL_C_GetPhy
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: convert logical address to physical
-----------------------------------------------------------*/
smtBlkAddr 				// Physical address or BLK_NA if address is invalid
FTL_C_GetPhy(
smtBlkAddr lba			// Logical block address
)
{
	
	smtBlkAddr pba;
	
	// check if it is in valid range 
	SMT_ASSERT(lba <= (gDevInfo.blks - gFlush.freeBlkNum));

	// load current fragment 
	if (!FTL_C_LoadFrag(FTL_COM_FRAGCACHE_GETFRAGNUM(lba)))
	{
		return BLK_NA;  
	}

	// return it's physical address 	  
	pba = FTL_COM_FRAGCACHE_GETPBA(lba);
	return pba;
}
/*----------------------------------------------------------
	Function name	: FTL_C_SetPhy
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: set logical block's physical address, 
					  1st ml_get_log2phy function has to set 
					  logical block's physical address, 1st 
					  ml_get_log2phy function has to be called 
					  to get the fragments into the cached 
					  area and ppba must be set
-----------------------------------------------------------*/
smtBlkAddr 				// 
FTL_C_SetPhy(
smtBlkAddr	lba,		// Logical block address
smtBlkAddr	pba			// Physical block address
)
{

	// check if lba is valid 
	SMT_ASSERT(lba < (gDevInfo.blks - gFlush.freeBlkNum));
	
	
	// load current fragment 
	if (!FTL_C_LoadFrag(FTL_COM_FRAGCACHE_GETFRAGNUM(lba))) 
	{
		return BLK_NA;  
	}

	
	FTL_COM_FRAGCACHE_SETPBA(lba, pba);
	gOpInfo.SaveMapNeed = SMT_TRUE;
	
	return 0;
}
/*----------------------------------------------------------
	Function name	: FTL_C_AllocBlk
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: allocate a block from free table and erases it
-----------------------------------------------------------*/
smtUint8 		// index in free table of INDEX_NA if any error
FTL_C_AllocBlk(
void
)
{
	smtUint8 index;

	for (;;)
	{// loop for alloc 
		
		smtBlkAddr pba;

		FTL_W_AllocWear();
		index=gWearAllocInfo.free_index;

		if (index==INDEX_NA)
		{
			// FATAL error no free blocks are available 
		    return INDEX_NA; 
		}

		pba	= gFlush.freeBlks[index];


		if (FTL_L_Erase(pba) == FTL_L_OK)
		{
			// erase is ok, so return with the index 
			return index; 
		}


		// signal it and locked as BAD 
		gFlush.freeBlks[index] |= FT_BAD;

		// lets allocate another one from freetable
	}
}
/*----------------------------------------------------------
	Function name	: FTL_C_AllocLog
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: alloc log block and initiate it
-----------------------------------------------------------*/
void			// None
FTL_C_AllocLog(
ST_LOG 	*log,	// Pointer where to alloc to
smtBlkAddr	lba		// Which logical block is connected to log block
) 
{
	smtUint8	index;
	smtBlkAddr 		pba;

	index = FTL_C_AllocBlk();
	SMT_ASSERT(index != INDEX_NA);
	pba	= gFlush.freeBlks[index];

	log->index		= index;
	log->lastppo	= 0;
	log->lba		= lba;
	log->pba		= pba;
	log->wear		= gWearAllocInfo.free_wear;
	log->switchable	= 1;

	gFlush.freeBlks[index] = (smtBlkAddr)(pba | FT_LOG);
	FTL_W_UpdateDInfo(index, log->wear); /* locked now */
	gLogCache.lockedCnt++;

	memset(log->ppo, INDEX_NA, sizeof(log->ppo));
	gOpInfo.SaveMapNeed = SMT_TRUE;


}
/*----------------------------------------------------------
	Function name	: FTL_C_AllocMapBlk
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: allocate a new map block
-----------------------------------------------------------*/
void 
FTL_C_AllocMapBlk(
ST_MAPBLOCK *mapblock	// mapblock need to be allocated
)
{

	// allocate a block 
	smtUint8 index;
	
	index = FTL_C_AllocBlk();
	SMT_ASSERT(index != INDEX_NA);
	
	// set new pba and reset ppo and MAP flag in FLT
	mapblock->curPBA	= gFlush.freeBlks[index];
	mapblock->curPPO	= 0;						
	gFlush.freeBlks[index] |= FT_MAP;

		
	// update wear info 
	FTL_W_UpdateDInfo(
		index,
		gWearAllocInfo.free_wear
	); 

	// set mapblock info
	mapblock->ref_count++;							
	mapblock->ref_count&=255; 						
	mapblock->mapPageBlk[mapblock->depthIdx++]=index; 
	
 
}
/*----------------------------------------------------------
	Function name	: FTL_C_GetfMapBlk
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: Function for retreiving the map according 
					  fragment counter
-----------------------------------------------------------*/
ST_MAPBLOCK*		// None NULL/NULL, success/fail
FTL_C_GetfMapBlk(
smtFrag frag			// Fragment number
)
{

	smtInt8	index = FTL_COM_MAPBLOCK_GETIDX(frag);
	SMT_ASSERT(index < FTL_MAPBLOCK_NUM);

	return &gMapBlocks.mapBlks[index];
}
/*----------------------------------------------------------
	Function name	: FTL_C_FindLog
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: Searching for a log block (check if logical 
					  block is logged) it sets ml_curlog to a log 
					  block or set it to NULL
-----------------------------------------------------------*/
smtBoolean 			// SMT_TRUE/SMT_FALSE, found/ not found
FTL_C_FindLog(
smtBlkAddr lba			// target Logical block address
)
{

	
	smtUint32	logIdx;
	
	for(
	logIdx = 0; 
	logIdx < gLogCache.num; 
	logIdx++)
	{
		if(gLogCache.logs[logIdx].lba == lba)
		{
			gLogCache.curLog = &gLogCache.logs[logIdx];
			return SMT_TRUE;
		}
	}
	
	gLogCache.curLog = 0;
	return SMT_FALSE;
}
/*----------------------------------------------------------
	Function name	: FTL_C_StoreMappage
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: mapblock which contains fragments
-----------------------------------------------------------*/
t_bit 					// 0/other, success/any error
FTL_C_StoreMappage(	
ST_MAPBLOCK *mapblock	// mapblock which contains fragments
)
{
	smtUint8	cou;
	ST_SPARE 	*sptr;

	// special spare_area pointer, only half buffer is used in write double! 
	sptr = ((ST_SPARE*)(((smtUint8*)(gFlushBuffer))+(gDevInfo.pageSize/2)));

	// setting spare information about mappage 
	// set map page here only! 
	sptr->u.map.block_type	= (smtUint8)(mapblock->blockType | BLK_MAPPAGE_FLAG); 
	sptr->u.map.frag		= gFragCache.num;

	// if we are in the 1st page then set special variable 
	if(mapblock->curPPO == 0)
	{
		// wear level and reference counter information 
		sptr->wear				= gWearAllocInfo.free_wear;	
		sptr->u.map.ref_count	= mapblock->ref_count;				
	}

	// update mapinfo about map blocks 
	for(cou = 0; cou < FTL_MAPBLOCK_DEPTH; cou++)
	{
		// copy shadow block's index 
		gFlush.mapInfo->mapPageBlk[cou] = mapblock->mapPageBlk[cou];
	}

	// update mapinfo about last success mappage 
	gFlush.mapInfo->LastPBA = mapblock->LastPBA;
	gFlush.mapInfo->LastPPO = mapblock->LastPPO;


	// increase mappage counter 
	gFlush.mapInfo->mapCntL++;
	if(!gFlush.mapInfo->mapCntL)
	{
		gFlush.mapInfo->mapCntH++;
	}

	
	// check if current fragment is cached (it has to be) 
	SMT_ASSERT(gFragCache.num != FRAG_NA);
	

	// write 1st half of fragment, 2nd half of FLT in the map page 
	return FTL_L_WriteDouble(
			mapblock->curPBA,
			mapblock->curPPO,
			(smtUint8*)gFragCache.ppba,
			gFlushBuffer);
			
}
 /*----------------------------------------------------------
	Function name	: FTL_C_SaveMap
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: Save map informations (fragments, free 
					  table modification)
-----------------------------------------------------------*/
t_bit 			// 0/other, success/any error
FTL_C_SaveMap(
void
)
{
	ST_MAPBLOCK	*mapblock;
	ST_MAPDIR 	*pfragMap;
	smtUint8 	cou;

	// get current map block 
	mapblock	= FTL_C_GetfMapBlk(gFragCache.num);
	SMT_ASSERT(mapblock);

	//-------------------------------------------------------
	// Check write space
	//-------------------------------------------------------
	if (mapblock->curPPO == gDevInfo.pagePerBlks)
	{
		// Need gabarge collection
		if(mapblock->depthIdx < FTL_MAPBLOCK_DEPTH) 
		{		
			FTL_C_AllocMapBlk(mapblock);
		}
		else
		{
			while(SMT_TRUE)
			{
			
				// release mapblock allocation block
				for (cou = 0; cou < FTL_MAPBLOCK_DEPTH; cou++)
				{
					smtUint8 midx	= mapblock->mapPageBlk[cou];
					if(midx != INDEX_NA)
					{
						gFlush.freeBlks[midx] &= ~FT_MAP;
						FTL_W_UpdateDInfo(midx,WEAR_NA);	
						mapblock->mapPageBlk[cou]=INDEX_NA;		
					}
				}
				mapblock->depthIdx = 0;	
			
			
				// allocate new map block
				FTL_C_AllocMapBlk(mapblock);
			
				// 1st page is mapblock 
				if(!FTL_C_StoreMappage(mapblock)) 
				{
					// 1st page is the FLT 
					smtBlkAddr LastPBA	= mapblock->curPBA;	
					smtPageAddr LastPPO	= mapblock->curPPO;	
					mapblock->curPPO++;					
			
					// collecting fragments 
					if(FTL_C_CollectFrag(mapblock))		
					{									
						mapblock->LastPBA	= LastPBA;	
						mapblock->LastPPO	= LastPPO;	
						FTL_W_ReleaseDLock();		
						gOpInfo.SaveMapNeed		= SMT_FALSE;		
						return 0;						
					}
				}
			}			
		}
	}
	//-------------------------------------------------------
	// Check write space
	//-------------------------------------------------------
	if(FTL_C_StoreMappage(mapblock))
	{
		return 1;
	}
	
	// get current frag mapdir 
	pfragMap= &gMapDir[gFragCache.num]; 
	
	// Update map directory
	pfragMap->PBA		= mapblock->curPBA;	
	pfragMap->PPO		= mapblock->curPPO;	
	pfragMap->index		= 1;				
	
	// Update mappblock information
	mapblock->LastPBA	= mapblock->curPBA;	
	mapblock->LastPPO	= mapblock->curPPO;	
	mapblock->curPPO++;						
	
	// release dynamic lock 
	FTL_W_ReleaseDLock();				
	gOpInfo.SaveMapNeed = SMT_FALSE;					
	return 0;							
		
	
}