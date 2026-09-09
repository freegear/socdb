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


	sptr = GET_SPARE_AREA(gTempBuffer);

	//-------------------------------------------------------
	// search last map blk 
	//-------------------------------------------------------
	for (pba = 0; pba < gDevInfo.blks; pba++)
	{
		smtUint8	block_type;
//		smtUint32	block_type_ptr_pos;


		if (!FTL_L_ReadPart(
				pba,				// block offset
				0,					// first page
				(smtUint8*)sptr,	// spare area pointer
				FTL_L_SP)			// spare area
			)
		{

			// Make wear information sum
			if (sptr->wear < WEAR_NA)
			{
				wear_count++;				
				wear_sum	+= sptr->wear;				
			}

			// check block type and assign to mapblock buffer
			block_type	=	sptr->u.map.block_type;		
			block_type	&=	BLK_TYPE_MAP_MASK;						
			if ((block_type >= BLK_TYPE_MAP_ORI) 
			&&  (block_type <  (BLK_TYPE_MAP_ORI+FTL_MAPBLOCK_NUM))) 
			{

				smtUint8	mapBlkNum	= block_type-BLK_TYPE_MAP_ORI;
				ST_MAPBLOCK	*map		= &gMapBlocks.mapBlks[mapBlkNum];
				smtUint32	refCount	= sptr->u.map.ref_count;


				if(map->curPBA != BLK_NA)
				{
					if(map->ref_count < refCount)
					{
						if(refCount-map->ref_count > 64)
						continue;
					}
					else
					{
						if(map->ref_count - refCount < 64)
						continue;
					}
				}

				// 1. Get map::pba, map::ref_count set
				map->curPBA		= pba;
				map->ref_count	= refCount;

			}
		}
	}

	return SMT_TRUE;
}
