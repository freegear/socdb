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
	Function name	: FTL_O_Init
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: Initialize this layer, this function must
					  be called at the begining befores lowinit
-----------------------------------------------------------*/
smtBoolean 		// SMT_TRUE/SMT_FALSE, success/any error
FTL_O_Init(
void
)
{
	smtUint32 	wear_sum		= 0;	/* summary of wears */
	smtUint32 	wear_count		= 0;	/* counting number of wears  */
	smtUint32 	wear_average	= 0;
	smtBlkAddr 	pba;
	ST_SPARE 	*sptr;

	smtUint32	mapBlkIdx;
	smtUint32	refCnt;
	ST_MAPBLOCK	*map;

	sptr = GET_SPARE_AREA(ml_buffer);

	//-------------------------------------------------------
	// search last map blk 
	//-------------------------------------------------------
	for (pba = 0; pba < gDevInfo.blks; pba++)
	{
	
		//---------------------------------------------------
		// (MAPBLOCK) Check map block ecc
		//---------------------------------------------------
		/*
		{
			smtUint32	block_type_ptr_pos;

			block_type_ptr_pos 
				= (smtUint8)
				(
					(smtUint32)(&sptr->u.map.block_type)
					-(smtUint32)(sptr)
				);

			if (FTL_L_ReadOne(
					pba,								// block offset
					0,									// page offset
					(smtUint8)block_type_ptr_pos,		// block_type's position
					&block_type))						// destination buffer
			{
				continue; // pre selecting blocks 
			}
			block_type &= FTL_BTYPE_MASK;		// block type check 
			if ((block_type == BLK_TYPE_INV)	// check 2bit error
			 || (!block_type))					
			{
				continue; // skip 2 bit errors, no map block 
			}
		}
		*/

		//---------------------------------------------------
		// (MAPBLOCK) Check mapblock type
		//---------------------------------------------------
		if (!FTL_L_ReadPart(
				pba,					// block offset
				0,						// first page
				(smtUint8*)sptr,		// spare area pointer
				FTL_L_S0)				// spare area
			)
		{

			// Make wear information sum
			if (sptr->wear < WEAR_NA)
			{
				wear_count++;				
				wear_sum	+= sptr->wear;				
			}

			// remove MAPBLOCK & MAPPAGE flag
			mapBlkIdx	=	sptr->u.map.block_type	& ~FTL_BTYPE_MAPBLK;	
			mapBlkIdx	=	mapBlkIdx				& ~FTL_BTYPE_MAPPAGE;
			if ((mapBlkIdx >= 0) 
			&&  (mapBlkIdx <  FTL_MAPBLOCK_NUM)) 
			{

				map		= &gpMapBlocks->mapBlks[mapBlkIdx];
				refCnt	= sptr->u.map.ref_count;

				// Check max wear, don't use it
				if(map->curPBA != BLK_NA)
				{
					if(map->ref_count < refCnt)
					{
						if(refCnt-map->ref_count > 64)
						continue;
					}
					else
					{
						if(map->ref_count - refCnt < 64)
						continue;
					}
				}

				// Set ST_MAPBLOCK::curPBA, ST_MAPBLOCK::ref_count
				map->curPBA		= pba;
				map->ref_count	= refCnt;
			}
		}
	}

	return SMT_TRUE;
}
