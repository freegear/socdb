/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: memory_test.c
	Description	: SD/MMC test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
//#include "irq.h"
#include "memory_test.h"
/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
/*/////////////////////////////////////////////////////////
        TYPE DEFINITION
///////////////////////////////////////////////////////// */
/*/////////////////////////////////////////////////////////
        FUNCTIONS
///////////////////////////////////////////////////////// */
//-----------------------------------------------------------
//	GetSeed
//-----------------------------------------------------------
static smtUint32 GetSeed(ACCESS_TYPE type, smtUint32 a, smtUint32 b) 
{
	int Result;
	switch(type) 
	{
	case AT_08BITS:
		Result = (smtUint8)(a+b);
		break;

	case AT_16BITS:
		Result = (smtUint16)(a+b);
		break;

	case AT_32BITS:
		Result = (smtUint32)(a+b);
		break;
	}

	return Result;
}
//-----------------------------------------------------------
//	MemVerify8bit
//-----------------------------------------------------------
static smtBoolean MemVerify8bit(smtUint32 source, smtUint32	size, 
	ACCESS_METHOD method, smtUint32 seed)
{
	smtUint8 	*pSource;
	smtUint32 	byteIdx;
	
	switch(method) 
	{
		case AM_SEQ:
			
			//printf("AM_SEQ test!!!\n");
			
			// write
			pSource = (smtUint8*)source;
			for(byteIdx = 0; byteIdx < size; byteIdx++) 
			{
				*pSource = GetSeed(AT_08BITS, byteIdx, seed);
				pSource++;
			}
			
			// verify
			pSource = (smtUint8*)source;
			for(byteIdx = 0; byteIdx < size; byteIdx++) 
			{
				if(*pSource != GetSeed(AT_08BITS, byteIdx, seed))
				{
					//printf("AM_SEQ test fail!!!\n");
					return false;
				}
				pSource++;
			}
			
			break;
			
		case AM_NONSEQ:
			
			//printf("AM_NONSEQ test!!!\n");
			// write
			pSource = (smtUint8*)source;
			for(byteIdx = 0; byteIdx < size; byteIdx+=8) 
			{
				*pSource = GetSeed(AT_08BITS, byteIdx, seed);
				pSource++;
			}
			
			// verify
			pSource = (smtUint8*)source;
			for(byteIdx = 0; byteIdx < size; byteIdx+=8) 
			{
				if(*pSource != GetSeed(AT_08BITS, byteIdx, seed))
				{
					//printf("AM_NONSEQ test fail!!!\n");
					return false;
				}
				pSource++;
			}			
			
			break;
			
		case AM_BURST:
			/* don't need in ARM */
			break;
	}
	
	return true;
}

//-----------------------------------------------------------
//	MemVerify16bit
//-----------------------------------------------------------
static smtBoolean MemVerify16bit(smtUint32 source, smtUint32 size, 
	ACCESS_METHOD method, smtUint32 seed)
{
	smtUint16 	*pSource;
	smtUint32 	byteIdx;
	
	switch(method) 
	{
		case AM_SEQ:
			
			//printf("AM_SEQ test!!!\n");
			
			// write
			pSource = (smtUint16*)source;
			for(byteIdx = 0; byteIdx < size; byteIdx++) 
			{
				*pSource = GetSeed(AT_16BITS, byteIdx, seed);
				pSource++;
			}
			
			// verify
			pSource = (smtUint16*)source;
			for(byteIdx = 0; byteIdx < size; byteIdx++) 
			{
				if(*pSource != GetSeed(AT_16BITS, byteIdx, seed))
				{
					//printf("AM_SEQ test fail!!!\n");
					return false;
				}
				pSource++;
			}
			
			break;
			
		case AM_NONSEQ:
			
			//printf("AM_NONSEQ test!!!\n");
			// write
			pSource = (smtUint16*)source;
			for(byteIdx = 0; byteIdx < size; byteIdx+=8) 
			{
				*pSource = GetSeed(AT_16BITS, byteIdx, seed);
				pSource++;
			}
			
			// verify
			pSource = (smtUint16*)source;
			for(byteIdx = 0; byteIdx < size; byteIdx+=8) 
			{
				if(*pSource != GetSeed(AT_16BITS, byteIdx, seed))
				{
					printf("AM_NONSEQ test fail!!!\n");
					return false;
				}
				pSource++;
			}			
			
			break;
			
		case AM_BURST:
			/* don't need in ARM */
			break;
	}
	
	return true;
}
//-----------------------------------------------------------
//	MemVerify32bit
//-----------------------------------------------------------
static smtBoolean MemVerify32bit(smtUint32 source,  smtUint32 size, 
	ACCESS_METHOD method, smtUint32	seed)
{
	smtUint32 	*pSource;
	smtUint32 	byteIdx;
	
	switch(method) 
	{
		case AM_SEQ:
			
			//printf("AM_SEQ test!!!\n");
			
			// write
			pSource = (smtUint32*)source;
			for(byteIdx = 0; byteIdx < size; byteIdx++) 
			{
				*pSource = GetSeed(AT_32BITS, byteIdx, seed);
				pSource++;
			}
			
			// verify
			pSource = (smtUint32*)source;
			for(byteIdx = 0; byteIdx < size; byteIdx++) 
			{
				if(*pSource != GetSeed(AT_32BITS, byteIdx, seed))
				{
					//printf("AM_SEQ test fail!!!\n");
					return false;
				}
				pSource++;
			}
			
			break;
			
		case AM_NONSEQ:
			
			//printf("AM_NONSEQ test!!!\n");
			// write
			pSource = (smtUint32*)source;
			for(byteIdx = 0; byteIdx < size; byteIdx+=8) 
			{
				*pSource = GetSeed(AT_32BITS, byteIdx, seed);
				pSource++;
			}
			
			// verify
			pSource = (smtUint32*)source;
			for(byteIdx = 0; byteIdx < size; byteIdx+=8) 
			{
				if(*pSource != GetSeed(AT_32BITS, byteIdx, seed))
				{
					//printf("AM_NONSEQ test fail!!!\n");
					return false;
				}
				pSource++;
			}			
			
			break;
			
		case AM_BURST:
		{
			/* must be implemented for ARM */
			
			smtUint32 *pTarget;
			
			//printf("AM_BURST test!!!\n");
			
			
			// write
			pSource = (smtUint32*)source;
			pTarget	= (smtUint32*)(source+(size*4)/2);
			
			for(byteIdx = 0; byteIdx < size/2; byteIdx++) 
			{
				*pSource = GetSeed(AT_32BITS, byteIdx, seed);
				pSource++;
			}
			
			// burst write
			memcpy(pTarget, pSource, (size/2)*4);
			
			// verify
			pSource = (smtUint32*)(source+(size*4)/2);
			for(byteIdx = 0; byteIdx < size/2; byteIdx+=8) 
			{
				if(*pSource != GetSeed(AT_32BITS, byteIdx, seed))
				{
					//printf("AM_BURST test fail!!!\n");
					return false;
				}
				pSource++;
			}						
		}
		break;
	}
	
	return true;
}

//-----------------------------------------------------------
//	MemRWTest
//-----------------------------------------------------------
smtBoolean MemRWTest(smtUint32 testTarget, smtUint32 testSizeInByte, 
	MEM_TEST *ptestInfo, smtUint32 seed)
{
	smtInt32 byteIdxMax;
		

	switch(ptestInfo->type) 
	{
		case AT_08BITS:
		{
			smtUint32 methodIdx;
	
			byteIdxMax 	= testSizeInByte/1;
    	
    		for(methodIdx = 0 ; methodIdx < 3; methodIdx++) 
    		{
    			
    			if(ptestInfo->method[methodIdx] == AM_NULL) 
    			{
    				break;
    			}
    			
    			if(!MemVerify8bit(
    					testTarget, 
    					byteIdxMax, 
    					ptestInfo->method[methodIdx], 
    					seed
    					))
    			{	
    				return false;
    			}
    		}
    			
		}
		break;

		case AT_16BITS:
		{
			unsigned int methodIdx;
	
			byteIdxMax 	= testSizeInByte/2;
    	
    		for(methodIdx = 0 ; methodIdx < 3; methodIdx++) 
    		{
    			
    			if(ptestInfo->method[methodIdx] == AM_NULL) 
    			{
    				break;
    			}
    			
    			if(!MemVerify16bit(
    					testTarget, 
    					byteIdxMax, 
    					ptestInfo->method[methodIdx], 
    					seed
    					))
    			{	
    				return false;
    			}
    		}
    			
		}
		break;
		
		case AT_32BITS:
		{
			unsigned int methodIdx;
	
			byteIdxMax 	= testSizeInByte/4;
    	
    		for(methodIdx = 0 ; methodIdx < 3; methodIdx++) 
    		{
    			
    			if(ptestInfo->method[methodIdx] == AM_NULL) 
    			{
    				break;
    			}
    			
    			if(!MemVerify32bit(
    					testTarget, 
    					byteIdxMax, 
    					ptestInfo->method[methodIdx], 
    					seed
    					))
    			{	
    				return false;
    			}
    		}
    			
		}
		break;		
    	    	
    	
	}

	return true;
}

