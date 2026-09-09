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
#include "ftl_o_rw.h"
#include "ftl_w_wear.h"
#include "ftl_c_core.h"


/*
/////////////////////////////////////////////////////////
        GLOBAL VARIABLE DECLARE
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        FUNCTIONS 
///////////////////////////////////////////////////////// 
*/
/*----------------------------------------------------------
	Function name	: DoStatic
	Prototype		: 
	Return			: none
	Argument		: 
	Comments		: does static wear leveling, its read logical
					  block, updates static wear info, and if static
					  request is comming, then copy the block
-----------------------------------------------------------*/
static 
void 
DoStatic(
void
)
{
	smtUint32 		wear;
	smtBlkAddr 		pba;
	smtBlkAddr 		static_lba;

	//-------------------------------------------------------
	// Get next static LBA
	//-------------------------------------------------------
	static_lba	= FTL_W_GetStaticLBA();
	for (;;)
	{
		static_lba++;
		if (static_lba >= gDevInfo.dataBlks) 
		{
			static_lba = 0;
		}

		pba = FTL_C_GetPhy(static_lba);
		if (pba != BLK_NA) 
		{
			break;
		}

		static_lba = 0;
		pba = FTL_C_GetPhy(static_lba);
		if (pba != BLK_NA) 
		{
			break;
		}
	}
	FTL_W_SetStaticLBA(static_lba);


	//-------------------------------------------------------
	// Copy block ?? 
	//-------------------------------------------------------
	if(!FTL_L_Read(
		pba,
		0,
		ml_buffer)	// 
	)
	{ // get original 
		
	 	wear = GET_SPARE_AREA(ml_buffer)->wear;
		if (wear<WEAR_NA) 
		{
			FTL_W_UpdateSInfo(static_lba,wear);
		}
		else 
		{
			FTL_W_UpdateSInfo(static_lba,0);
		}
	}
	else 
	{
		FTL_W_UpdateSInfo(static_lba,0);
	}

	if(FTL_W_ChkStatic())
	{
		smtPageAddr 		po;
		smtBlkAddr 		d_pba,lba;
		smtBlkAddr 		s_pba;
		smtUint8  	index = gpWearAllocData->free_index;

		if(index == INDEX_NA) 
		{
			return;
		}
		//d_pba = gl_freetable[index];
		d_pba = gpFlush->freeBlks[index]&FTL_BLKADDR_MASK;

		if(FTL_L_Erase(d_pba) ==  FTL_L_ERROR)
		{
			// signal it and set as BAD 
			gpFlush->freeBlks[index] |= FTL_FBTYPE_BAD;
			return;
		}

		lba		= gpWearAllocData->static_lba;
		s_pba	= FTL_C_GetPhy(lba);
		if (s_pba == BLK_NA) 
		{
			// nothing to do 
			return; 
		}

		for (po = 0; po < gDevInfo.pagePerBlks; po++)
		{
			int ret=FTL_L_Read(s_pba,po,ml_buffer);
			if (!po)
			{
				ST_SPARE *sptr			= GET_SPARE_AREA(ml_buffer);
				sptr->wear				= gpWearAllocData->free_wear;
				sptr->u.map.block_type	= FTL_BTYPE_DAT;
			}
			else if (ret) 
			{
				continue;
			}

			if (FTL_L_Write(
				d_pba,
				po,
				ml_buffer
				) == FTL_L_ERROR) 
			{
				// we can stop static swap 
				return; 
			}
		}

		FTL_C_SetPhy(lba,d_pba);
		FTL_W_UpdateSInfo(lba,gpWearAllocData->free_wear);

		gpFlush->freeBlks[index] = s_pba;
		FTL_W_UpdateDInfo(index,gpWearAllocData->static_wear);

		FTL_C_SaveMap();
	}
}
/*----------------------------------------------------------
	Function name	: FTL_O_GCollect
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: does log block and logical block merge
-----------------------------------------------------------*/
smtBoolean	 		// 0/other, success/any error
FTL_O_GCollect(
void
) 
{
	smtUint32 	wear=WEAR_NA;
	smtUint8 	po,lpo,index;
	smtBlkAddr 	pba;
	smtBlkAddr 	orig_pba;
	ST_LOG 		*log;
	
	log = gpLogCache->curLog;

	DoStatic();

	gfSaveMapNeed 	= SMT_TRUE;

	orig_pba 		= FTL_C_GetPhy(log->lba);
	SMT_ASSERT(orig_pba != BLK_NA);
	
	//-------------------------------------------------------
	// Check  switch enable!!! and switch block
	//-------------------------------------------------------
	if ((log->lastppo == gDevInfo.pagePerBlks)	
      && log->switchable)
	{ //  check if switchable 

		// Switch log block
		FTL_C_SetPhy(log->lba, log->pba);		
		FTL_W_UpdateSInfo(log->lba, log->wear);

		// Update free table
		if (FTL_L_ERROR != FTL_L_Read(orig_pba, 0, ml_buffer))
		{
			wear = GET_SPARE_AREA(ml_buffer)->wear;
			if(wear == WEAR_NA) wear = 0;
		}
		else
		{
			SMT_ASSERT(0);
		}

		// Release log and alloc log
		gpFlush->freeBlks[log->index] = orig_pba;
		FTL_W_UpdateDInfo(log->index, wear);
		log->lba = BLK_NA;
		gpLogCache->lockedCnt--;

		return SMT_TRUE;
	}
	
	
	
	index = FTL_C_AllocBlk();
	SMT_ASSERT(index != INDEX_NA);
	pba = gpFlush->freeBlks[index]&FTL_BLKADDR_MASK;

	//-------------------------------------------------------
	// Get log cache data to orignal block
	//-------------------------------------------------------
	for (po = 0; po < gDevInfo.pagePerBlks; po++)
	{
		lpo = log->ppo[po];
		if(lpo == INDEX_NA)
		{
			FTL_L_Read(orig_pba, po, ml_buffer);
		}
		else
		{
			FTL_L_Read(log->pba,lpo,ml_buffer);	
		}
		

		if (po == 0)
		{
			ST_SPARE *sptr			= GET_SPARE_AREA(ml_buffer);
			sptr->wear				= gpWearAllocData->free_wear;
			sptr->u.map.block_type	= FTL_BTYPE_DAT;
		}

		if (FTL_L_Write(pba, po, ml_buffer) == FTL_L_ERROR) 
		{
			SMT_ASSERT(0);
		}
	}


	// Wear update
	if (FTL_L_ERROR != FTL_L_Read(orig_pba, 0 ,ml_buffer))
	{
		wear = GET_SPARE_AREA(ml_buffer)->wear;
		if(wear == WEAR_NA) wear = 0;
	}
	
	// Update orignal block 
	gpFlush->freeBlks[index] = orig_pba;
	FTL_W_UpdateDInfo(index, wear);

	// Update static
	FTL_C_SetPhy(log->lba, pba);		
	FTL_W_UpdateSInfo(log->lba, gpWearAllocData->free_wear);
	
	// Release current log
	log->lba = BLK_NA;
	gpLogCache->lockedCnt--;	
	gpFlush->freeBlks[log->index] &= ~FTL_FBTYPE_LOG;
	FTL_W_UpdateDInfo(log->index, WEAR_NA);
	
	return SMT_TRUE;
}
