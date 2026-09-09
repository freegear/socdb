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
#include <stdio.h>
#include <string.h>
#include "ftl_o_gabarge.h"
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
	Function name	:	FTL_Format
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
smtBoolean 
FTL_Format(
void
)
{
	smtBoolean ret;

	ret = FTL_O_LowInit(); 
	if(ret == SMT_FALSE) {
		printf("FTL_LowInit fail!!!\n");
		return SMT_FALSE;
	}

	ret = FTL_O_Format();
	if(ret == SMT_FALSE) {
		printf("FTL_O_Format fail!!!\n");
		return SMT_FALSE;
	}

	return SMT_TRUE;
}

/*----------------------------------------------------------
	Function name	:	FTL_Init
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
smtBoolean 
FTL_Init(
void
)
{
	
	smtBoolean ret;

	ret = FTL_O_LowInit();
	if(ret == SMT_FALSE) {
		printf("FTL_O_LowInit fail!!!\n");
		return SMT_FALSE;
	}

	ret = FTL_O_Init();
	if(ret == SMT_FALSE){
		printf("FTL_O_Init fail!!!\n");
		return SMT_FALSE;
	}

	ret = FTL_O_BuildCache();
	if(ret == SMT_FALSE){
		printf("FTL_O_BuildCache fail!!!\n");
		return SMT_FALSE;
	}

	return SMT_TRUE;
}
/*----------------------------------------------------------
	Function name	:	FTL_Deinit
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
smtBoolean
FTL_Deinit(
void
)
{
	return SMT_TRUE;
}

/*----------------------------------------------------------
	Function name	:	FTL_Write
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
smtBoolean
FTL_Write(
smtUint32	sector, // sector address
smtUint32	num,	// number of sector
smtUint32	buffer	// source buffer
)
{

#define SS_PER_SN	4	

	smtUint32	so, sn;
	smtUint32	sso, ssi, ssn;
	smtUint8	*pbufInternal;
	smtUint32	ret;


	
	// make super sector offset
	sso = sector/SS_PER_SN;

	// clip forward
	if(sector%SS_PER_SN) 
	{
		so 	= sector%SS_PER_SN;
		sn 	= SS_PER_SN - sector%SS_PER_SN;
		if(num < sn) sn = num;
		
			
retry0:	
	
		ret = FTL_O_Read(sso);
		if(ret)	return SMT_FALSE;
			
		pbufInternal = (smtUint8*)FTL_O_GetRWBuffer();
		memcpy((void*)(pbufInternal + so*512),
			  	(void*)buffer,
			   	512*sn);
		
		ret = FTL_O_Write(sso);
		if(ret == 2) 
		{
			FTL_O_GCollect();
			goto retry0;
		}
		if(ret == 1) return SMT_FALSE;		


		buffer	+= 512*sn;
		sso		+= 1;	
		num		-= sn;
	}
	
	// center super sector
	if(num/SS_PER_SN)
	{
		ssn = num/SS_PER_SN;
		for(ssi = 0; ssi < ssn; ssi++)
		{

retry1:
			pbufInternal = (smtUint8*)FTL_O_GetRWBuffer();
			memcpy((void*)pbufInternal
				  ,(void*)buffer 
				  ,2048);

			ret = FTL_O_Write(sso+ssi);
			if(ret == 2) 
			{
				FTL_O_GCollect();
				goto retry1;
			}
			if(ret == 1) return SMT_FALSE;
										  
			buffer	+= 2048;
		}
		sso += ssn;
		num -= ssn*SS_PER_SN;
	}

	// clip backward
	if(num%SS_PER_SN)
	{
		sn	= num%SS_PER_SN;

retry3:	
		ret = FTL_O_Read(sso);
		if(ret)	return SMT_FALSE;
			
		pbufInternal = (smtUint8*)FTL_O_GetRWBuffer();		
		memcpy((void*)pbufInternal
			  ,(void*)buffer
			  ,512*sn);
			  
		ret = FTL_O_Write(sso);
		if(ret == 2) 
		{
			FTL_O_GCollect();
			goto retry3;
		}
		if(ret == 1) return SMT_FALSE;					  
			  
		buffer 	+= 512*sn;
		num 	-= sn;

	}
	

	return SMT_TRUE;

}
/*----------------------------------------------------------
	Function name	:	FTL_Read
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
smtBoolean
FTL_Read(
smtUint32	sector,	// sector address
smtUint32	num,	// number of sector
smtUint32	buffer	// target buffer
)
{

#define SS_PER_SN	4	
	
	smtUint32	so, si, sn;
	smtUint32	sso, ssi, ssn;
	smtUint8	*pbufInternal;
	smtBoolean	ret;

	// make super sector offset
	sso = sector/SS_PER_SN;

	// clip forward
	if(sector%SS_PER_SN) 
	{
		so 	= sector%SS_PER_SN;
		sn 	= SS_PER_SN - sector%SS_PER_SN;
		if(num < sn) sn = num;
		
		ret = FTL_O_Read(sso);
		if(ret)	return SMT_FALSE;

		pbufInternal = (smtUint8*)FTL_O_GetRWBuffer();		
		memcpy((void*)buffer,
			   (void*)(pbufInternal + so*512),
			    512*sn);

		buffer	+= 512*sn;
		sso		+= 1;	
		num		-= sn;
	}
	
	// center super sector
	if(num/SS_PER_SN)
	{
		ssn = num/SS_PER_SN;
		for(ssi = 0; ssi < ssn; ssi++)
		{
			ret = FTL_O_Read(sso+ssi);
			if(ret)	return SMT_FALSE;

			pbufInternal = (smtUint8*)FTL_O_GetRWBuffer();
			memcpy((void*)buffer 
				  ,(void*)pbufInternal
				  ,2048);
			buffer	+= 2048;
		}
		sso += ssn;
		num -= ssn*SS_PER_SN;
	}

	// clip backward
	if(num%SS_PER_SN)
	{
		sn	= num%SS_PER_SN;

		ret = FTL_O_Read(sso);
		if(ret)	return SMT_FALSE;
		pbufInternal = (smtUint8*)FTL_O_GetRWBuffer();		

		for(si = 0; si <sn; si++)
		{
			
			memcpy((void*)buffer
				  ,(void*)pbufInternal
				  ,512*sn);
			buffer += 512*sn;
			num -= sn;

		}	

	}
	
	return SMT_TRUE;

}
/*----------------------------------------------------------
	Function name	:	FTL_GetMaxSectors
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
smtUint32 
FTL_GetMaxSectors(
void
)
{
	return FTL_O_GetMaxSector();
}
