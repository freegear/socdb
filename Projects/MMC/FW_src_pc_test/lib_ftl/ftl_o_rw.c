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
	Function name	: FTL_O_GetMaxSector
	Prototype		: 
	Return			: none
	Argument		: 
	Comments		: retreives the maximum number of sectors 
					  can be used in the system
-----------------------------------------------------------*/
smtUint32 
FTL_O_GetMaxSector(
void
) 
{
	return gDevInfo.dataBlks*gDevInfo.pagePerBlks;
}
/*----------------------------------------------------------
	Function name	: FTL_O_GetBuffer
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
smtUint32
FTL_O_GetRWBuffer(
void
)
{
	return (smtUint32)gTempBuffer;
}

/*----------------------------------------------------------
	Function name	: FTL_O_Write
	Prototype		: 
	Return			: none
	Argument		: 
	Comments		: Writing sector data
-----------------------------------------------------------*/
smtUint8 			// 0/other, success/any error
FTL_O_Write(
smtUint32	sector
) 
{
	
	ST_SPARE 	*sptr;

	gOpInfo.LBA		= (smtBlkAddr)(sector/gDevInfo.pagePerBlks);
	gOpInfo.LPO		= (smtPageAddr)(sector%gDevInfo.pagePerBlks);	


	if(gOpInfo.LPO >= gDevInfo.pagePerBlks)
	{
		gOpInfo.LBA++;
		gOpInfo.LPO = 0;
		SMT_ASSERT(gOpInfo.LBA < gDevInfo.dataBlks);		
	}
		
	if(!FTL_C_FindLog(gOpInfo.LBA))
	{
		SMT_ASSERT(gLogCache.lockedCnt <= gLogCache.num);
		
		if(FTL_C_FindLog(BLK_NA))
		{				
			FTL_C_AllocLog(gLogCache.curLog, gOpInfo.LBA);
		}
		else
		{
			gLogCache.curLog 
				= &gLogCache.logs[gLogCache.nextIdx++];
			if(gLogCache.nextIdx >= gLogCache.num)
			{
				gLogCache.nextIdx = 0;
			}		
			
			// do merge						
			return 2;
		}
	}
		

	// do merge
	if(gLogCache.curLog->lastppo >= gDevInfo.pagePerBlks)
	{
		return 2;
	}

	// data write per page size
	sptr = GET_SPARE_AREA(gTempBuffer);
	
	if(!gLogCache.curLog->lastppo)
	{
		sptr->wear				= gLogCache.curLog->wear;
		sptr->u.map.block_type	= BLK_TYPE_DAT;
	}
	sptr->u.log.lba	= gOpInfo.LBA;
	sptr->u.log.lpo	= gOpInfo.LPO;
		
		
	FTL_L_Write(
		gLogCache.curLog->pba,
		gLogCache.curLog->lastppo,
		gTempBuffer
	);
		

	// log cache update
	if(gOpInfo.LPO != gLogCache.curLog->lastppo)
	{
		gLogCache.curLog->switchable = 0;
	}
	gLogCache.curLog->ppo[gOpInfo.LPO++]
		= gLogCache.curLog->lastppo++;

	// save map
	if(gOpInfo.SaveMapNeed)
	{
		if (FTL_C_SaveMap()) 
		{
			return 1;
		}
	}

	return 0;
}
/*----------------------------------------------------------
	Function name	: FTL_O_Read
	Prototype		: 
	Return			: none
	Argument		: 
	Comments		: Read sector data
-----------------------------------------------------------*/
smtUint8 		// 0/other success/any error
FTL_O_Read(
smtUint32	sector
)
{
	smtBlkAddr		ba;
	smtPageAddr 	po;
	smtInt32		ret;

	
	gOpInfo.LBA		= (smtBlkAddr)(sector/gDevInfo.pagePerBlks);
	gOpInfo.LPO		= (smtPageAddr)(sector%gDevInfo.pagePerBlks);	
	
	
	if(gOpInfo.LPO   >= gDevInfo.pagePerBlks)
	{
		gOpInfo.LBA++;
		gOpInfo.LPO = 0;
		SMT_ASSERT(gOpInfo.LBA < gDevInfo.dataBlks);
	}
		
	gOpInfo.PBA = FTL_C_GetPhy(gOpInfo.LBA);
	SMT_ASSERT(gOpInfo.PBA != BLK_NA);

	FTL_C_FindLog(gOpInfo.LBA);

	// Read operation
	// Check log cache pointer		
	ba = gOpInfo.PBA;
	po = gOpInfo.LPO;
		
	if(gLogCache.curLog)
	{
		if(gLogCache.curLog->ppo[gOpInfo.LPO] != INDEX_NA)
		{
			ba = gLogCache.curLog->pba;
			po = gLogCache.curLog->ppo[gOpInfo.LPO];
		}
	}

	// Read operation
	ret = FTL_L_Read(ba, po, gTempBuffer);

	gOpInfo.LPO++;

	if (ret == FTL_L_OK) 
	{
		return 0;
	}
	else if (ret == FTL_L_ERASED) 
	{
		// erased 
		return 0; 
	}

	return 1;
}
