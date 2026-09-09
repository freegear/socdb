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
#include "ftl_o_rw.h"
#include "ftl_w_wear.h"
#include "ftl_c_core.h"
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
static ST_STATIC 	*gl_static;

// dynamic wear info is here 
static smtUint32 	gl_dynamic_wear_info[MAX_FREE_BLOCK_AVAILABLE]; 

// bitfield for locking mechanism 
static smtUint8		gl_dynamic_lock[(MAX_FREE_BLOCK_AVAILABLE+7) >> 3];

// optimalized table for fast masking 
static const smtUint8 gl_lookup_mask[8]= 
	{0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80};

/*
/////////////////////////////////////////////////////////
        FUNCTIONS 
///////////////////////////////////////////////////////// 
*/
/*----------------------------------------------------------
	Function name	: FTL_W_Init
	Prototype		: 
	Return			: none
	Argument		: 
	Comments		: initiate wear leveling, this function 
					  must be called at power on
-----------------------------------------------------------*/
void 
FTL_W_Init(
ST_STATIC *ptr	// Static info for wear contoller
) 
{
	smtUint8 idx;
	
	// Initialize static data pointer
	gl_static = ptr;

	// Reset dynamic wear info
	for (idx = 0; idx < gFlush.freeBlkNum; idx++) 
	{
		gl_dynamic_wear_info[idx] = WEAR_NA;
	}
		
	// Reset dynamic wear lock info
	for(idx = 0; idx < sizeof(gl_dynamic_lock); idx++)
	{
		gl_dynamic_lock[idx] = 0xff;
	}
	
	// Reset static block information
	for (idx =0; idx<MAXSTATICWEAR; idx++) 
	{
		gl_static->wear_info[idx].lba	= BLK_NA;
        gl_static->wear_info[idx].wear	= WEAR_NA;
	}

	// Reset static LBA, Count, Current dynamic index
	gl_static->lba				= 0;	
    gl_static->cnt				= 2; 	
	gl_static->dynamic_index	= 0; 	
}
/*----------------------------------------------------------
	Function name	: FTL_W_GetStaticLBA
	Prototype		: 
	Return			: lba of static block
	Argument		: 
	Comments		: retreive the current lba of the static wear
-----------------------------------------------------------*/
smtBlkAddr 
FTL_W_GetStaticLBA(
void
) 
{
	return gl_static->lba;
}
/*----------------------------------------------------------
	Function name	: wear_setstatic_lba
	Prototype		: 
	Return			: none
	Argument		: 
	Comments		: update the current lba of the static wear
-----------------------------------------------------------*/
void 
FTL_W_SetStaticLBA(
smtBlkAddr lba	// new static LBA 
) 
{
	gl_static->lba=lba;
}
/*----------------------------------------------------------
	Function name	: FTL_W_CheckDPeak
	Prototype		: 
	Return			: 0/other, Not found/ other found peek in dynamic area
	Argument		: 
	Comments		: searching in dynamic area if there is any 
					  wear which is bigger than the average
-----------------------------------------------------------*/
static 
smtBoolean 
FTL_W_CheckDPeak(
void
) 
{
	smtUint32 	average	= 0;
	smtUint32 	avecou	= 0;
	smtUint8	idx;
	smtBlkAddr 		*free_table;

	// get free table 
	free_table = gFlush.freeBlks;
	for(idx = 0; idx < gFlush.freeBlkNum; idx++,free_table++) 
	{
		// check if block is not used (free) 
		if (!((*free_table)&FT_BAD)) 	  
		{
			// check if there is dynamic lock set 
			if (!(gl_dynamic_lock[idx>>3]&gl_lookup_mask[idx&7]))  
			{
				smtUint32 wear=gl_dynamic_wear_info[idx];
				if (wear!=WEAR_NA) 
				{
					average+=wear;
					avecou++;
				}
			}
		}
	}

	// Check and caculate average 
	if (!avecou) return SMT_TRUE;
	average/=avecou;

	// get free table 
	free_table = gFlush.freeBlks;
	for(idx = 0; idx < gFlush.freeBlkNum; idx++, free_table++) 
	{
		// check if block is not used (free) 
		if(!((*free_table)&FT_BAD)) 	  
		{
			// check if there is dynamic lock set 
			if (!(gl_dynamic_lock[idx>>3]&gl_lookup_mask[idx&7]))  
			{
				smtUint32 wear=gl_dynamic_wear_info[idx];
				if (wear!=WEAR_NA) 
				{
					// 75% of distance 
					if (wear>average+((3*WEAR_STATIC_LIMIT)/4))  
					{
						return SMT_TRUE;
					}
				}
			}
		}
	}

	return SMT_FALSE;
} 
/*----------------------------------------------------------
	Function name	: FTL_W_ChkStatic
	Prototype		: 
	Return			: 0/1, If not needed/static wear necessary
	Argument		: 
	Comments		: checking if static wear is needed
-----------------------------------------------------------*/
smtBoolean 
FTL_W_ChkStatic(
void
) 
{
	smtUint8 	a;
	smtBlkAddr 		static_lba	= BLK_NA;
	smtUint32 	static_wear	= WEAR_NA;

	// search the lowest static 
	if ((!gl_static->cnt) || FTL_W_CheckDPeak()) 	
	{
		for (a=0; a<MAXSTATICWEAR; a++) 
		{
			smtUint32 wear=gl_static->wear_info[a].wear;
			smtBlkAddr lba=gl_static->wear_info[a].lba;

			if ((wear!=WEAR_NA) && (lba!=BLK_NA)) 
			{
				if (static_lba!=BLK_NA) 
				{
					// if its bigger continue 
					if (wear>=static_wear) 
					{
						continue;	
					}
				}

				static_lba=lba;
				static_wear=wear;
			}
		}
	}

    if(static_lba != BLK_NA)
	{
		smtUint8 	*lookup_mask	= (smtUint8 *)gl_lookup_mask;
		smtUint8 	*dynamic_lock	= gl_dynamic_lock;
		smtBlkAddr		*free_table 	= gFlush.freeBlks;
		smtUint8	find_index		= INDEX_NA;
		smtUint32 	find_wear		= WEAR_NA;

		for (a=0; a<gFlush.freeBlkNum; a++)
		{
			// search for the highest dynamic 
			if (!( (*dynamic_lock) & (*lookup_mask) ) )
			{ // check if locked 
				
				if (!((*free_table) & FT_BAD))
				{	// if it is realy free 
					smtUint32 wear=gl_dynamic_wear_info[a];

					if (wear != WEAR_NA)
					{
						if (find_index == INDEX_NA)
						{
							find_index	= a;
							find_wear	= wear;
						}
						else if (wear>find_wear)
						{	// if its bigger 
							find_index	= a;
							find_wear	= wear;
						}
					}
				}

				free_table++;
				lookup_mask++;

				if ((a&7)==7)
				{
					// reset look up 
					lookup_mask=(smtUint8*)gl_lookup_mask; 
					// goto next bitfield; 
					dynamic_lock++;				
				}
			}
		}

		if (find_index!=INDEX_NA)
		{
			if (find_wear>static_wear+WEAR_STATIC_LIMIT)
			{
				// incremented by 1! 
				gWearAllocInfo.free_index=find_index;
				gWearAllocInfo.free_wear=find_wear+1; 

				gWearAllocInfo.static_lba=static_lba;
				gWearAllocInfo.static_wear=static_wear;

				gl_static->cnt=WEAR_STATIC_COUNT;
				// static wear successfully 
				return SMT_TRUE;	 
			}
		}
	}
	else 
	{
		gl_static->cnt--;
	}

	gWearAllocInfo.free_index	= INDEX_NA;
	gWearAllocInfo.static_lba	= BLK_NA;
	gWearAllocInfo.static_wear	= WEAR_NA;

	// no static wear needed 
	return SMT_FALSE;
}
/*----------------------------------------------------------
	Function name	: FTL_W_AllocWear
	Prototype		: 
	Return			: none
	Argument		: 
	Comments		: 
	
		allocates a block from free table list according to theirs wear 
		level info datas will be unchanged in all table (calling twice 
		it returns with same values) if static_lba is not equal with 
		BLK_NA then static wear heandler has to be called immediately. 
		gWearAllocInfo holds all the information                                                                  
	
-----------------------------------------------------------*/
void 
FTL_W_AllocWear(
void
)
{
	smtUint8 	index;
	smtUint8 	num;
	smtBlkAddr		*free_table;
	
	
	// Initialize all varaible(last counter, maxium cycle, free table)
	index 		= gl_static->dynamic_index;
	num			= (smtUint8)gFlush.freeBlkNum;
	free_table	= &gFlush.freeBlks[index];

	while (num--)
	{	
		// cycle for all entries and goto next entry
		free_table++;
	    index++;		
		if (index >= gFlush.freeBlkNum)
		{
			// Reset
			index		= 0;				
			free_table 	= gFlush.freeBlks;	
		}

		// Check if block is not used (free) 
		if (!((*free_table)&FT_BAD))
		{	
			// Check if block is not used (free) 
			if (!(gl_dynamic_lock[index>>3]&gl_lookup_mask[index&7]))
			{ 
				
				gl_static->dynamic_index		= index;	
				gWearAllocInfo.free_index	= index; 
				gWearAllocInfo.free_wear	= gl_dynamic_wear_info[index]+1; 
				// Allocation is success 
				return;	 
			}
		}
	}

	// Restore index 
	gl_static->dynamic_index		= index;		
 	gWearAllocInfo.free_index	= INDEX_NA;
 	gWearAllocInfo.free_wear	= WEAR_NA;		
 	
 	// Fatal error! no free block in the table 
}
/*----------------------------------------------------------
	Function name	: FTL_W_UpdateDInfo
	Prototype		: 
	Return			: none
	Argument		: 
	Comments		: 
	
		updating dynamic wear level info of an 
		indexed block (free block)                                                
	
-----------------------------------------------------------*/
void 
FTL_W_UpdateDInfo(
smtUint8	index, 	// index of the block in free table entry
smtUint32	wear	// wear info of given block
) 
{
   if (index<gFlush.freeBlkNum) 
   {
   		// Keep original data inside <e.g. for log,map blocks> 
		if (wear<WEAR_NA)  
		{
			gl_dynamic_wear_info[index]=wear;
		}

		// optimalized! 
		gl_dynamic_lock[index>>3] |= gl_lookup_mask[index&7]; 
	}
}
/*----------------------------------------------------------
	Function name	: FTL_W_ReleaseDLock
	Prototype		: 
	Return			: none
	Argument		: 
	Comments		: 
	
		Releasing newly added free blocks (enabled for allocation)
		Must be called when a MAP dir or entry is stored
	
-----------------------------------------------------------*/
void 
FTL_W_ReleaseDLock(
void
) 
{
	smtUint8	idx;

	for (idx = 0; idx < sizeof(gl_dynamic_lock); idx++) 
	{
		// set all bits to 0 
		gl_dynamic_lock[idx] = 0; 
	}
}
/*----------------------------------------------------------
	Function name	: FTL_W_UpdateSInfo
	Prototype		: 
	Return			: none
	Argument		: 
	Comments		: 
	
		updating static wear info of a static block (used block)
	
-----------------------------------------------------------*/
void 
FTL_W_UpdateSInfo(
smtBlkAddr 	lba, 
smtUint32	wear
) 
{
	smtUint32	max_wear		= WEAR_NA;
	smtUint8 	idx,max_index	= INDEX_NA;

	if (lba == BLK_NA) return;

 	// check if its already existed 
	for(idx = 0; idx < MAXSTATICWEAR; idx++)   
	{
		if (gl_static->wear_info[idx].lba==lba) 
		{
			gl_static->wear_info[idx].wear=wear;
			return;
		}
	}

	// search maximum or empty entry 
	for(idx = 0; idx < MAXSTATICWEAR; idx++)    
	{
		smtUint32 twear = gl_static->wear_info[idx].wear;
		if(twear != WEAR_NA) 
		{
			if(max_index != INDEX_NA) 
			{
				if (twear < max_wear) continue;
			}

			max_wear	= twear;
			max_index	= idx;
		}
		else  
		{// if entry is empty put immediatelly 
			gl_static->wear_info[idx].wear	= wear;
			gl_static->wear_info[idx].lba	= lba;
			return;
		}
	}

	if(max_index != INDEX_NA) 
	{
		if(wear < max_wear) 
		{
			gl_static->wear_info[max_index].wear	= wear;
			gl_static->wear_info[max_index].lba		= lba;
		}
	}
}

