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
	return (smtUint32)ml_buffer;
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
	
	ST_SPARE	*sptr;
	smtBlkAddr	lba;
	smtPageAddr	lpo;
	ST_LOG		*pcurLog;

	// make sector	
	lba	= (smtBlkAddr)(sector/gDevInfo.pagePerBlks);
	lpo	= (smtPageAddr)(sector%gDevInfo.pagePerBlks);


	if(lpo >= gDevInfo.pagePerBlks)
	{
		lba++;
		lpo = 0;
		SMT_ASSERT(lba < gDevInfo.dataBlks);
	}
	
	pcurLog = FTL_C_FindLog(lba);
	if(pcurLog == SMT_NULL)
	{
		SMT_ASSERT(gpLogCache->lockedCnt <= gpLogCache->num);
		
		pcurLog = FTL_C_FindLog(BLK_NA);
		if(pcurLog == SMT_NULL)
		{
			gpLogCache->curLog = &gpLogCache->logs[gpLogCache->nextIdx++];
			if(gpLogCache->nextIdx >= gpLogCache->num)
			{
				gpLogCache->nextIdx = 0;
			}		
		
			// do merge						
			return 2;
		}
		else
		{
			FTL_C_AllocLog(pcurLog, lba);
		}
	}
	else
	{
		// do merge
		if(pcurLog->lastppo >= gDevInfo.pagePerBlks)
		{
			return 2;
		}

	}

	

	//memcpy (ml_buffer,datap, 512);//(smtInt32)gDevInfo.pageSize);
	sptr = GET_SPARE_AREA(ml_buffer);
		
	if(pcurLog->lastppo == 0)
	{
		sptr->wear				= pcurLog->wear;
		sptr->u.map.block_type	= FTL_BTYPE_DAT;
	}
	sptr->u.log.lba	= lba;
	sptr->u.log.lpo	= lpo;
		
	FTL_L_Write(
		pcurLog->pba,
		pcurLog->lastppo,
		ml_buffer
	);
		

	// log cache update
	if(lpo != pcurLog->lastppo)
	{
		pcurLog->switchable = 0;
	}
	pcurLog->ppo[lpo] = pcurLog->lastppo++;

	// save map
	if (gfSaveMapNeed)
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
	smtBlkAddr		ba, lba, pba;
	smtPageAddr 	po, lpo;
	smtInt32		ret;
	ST_LOG			*pcurLog;
	
	// Make address
	lba	= (smtBlkAddr)(sector/gDevInfo.pagePerBlks);
	lpo	= (smtPageAddr)(sector%gDevInfo.pagePerBlks);
	
	// Check block boundary
	if(lpo   >= gDevInfo.pagePerBlks)
	{
		lba++;
		lpo = 0;
		SMT_ASSERT(lba < gDevInfo.dataBlks);
	}
	pba = FTL_C_GetPhy(lba);
	SMT_ASSERT(pba != BLK_NA);
	

	// real block address and page address
	pcurLog = (ST_LOG*)FTL_C_FindLog(lba);
	if(pcurLog == NULL)
	{
		ba = pba;
		po = lpo;
	}
	else
	{
		if(pcurLog->ppo[lpo] != INDEX_NA)
		{
			ba = gpLogCache->curLog->pba;
			po = gpLogCache->curLog->ppo[lpo];
		}
		else
		{
			ba = pba;
			po = lpo;
		}
	}

	// Read operation
	ret = FTL_L_Read(
		ba, 		// block address
		po, 		// page address
		ml_buffer);	// read buffer
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
