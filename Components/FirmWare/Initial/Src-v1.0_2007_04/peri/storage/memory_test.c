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

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include <stdio.h>
#include <string.h>

#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
//#include "irq.h"
#include "memory_test.h"

/*
/////////////////////////////////////////////////////////
        FUNCTIONS DECLARE
///////////////////////////////////////////////////////// 
*/
extern 	smtUint32 smt2UARTPrint(smtUint8 uartCh, smtInt8 *format, ...);
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
#define MEMTDPRINTF					smt2UARTPrint

/*
/////////////////////////////////////////////////////////
        TYPE DEFINITION
///////////////////////////////////////////////////////// 
*/
/*----------------------------------------------------------
	Function name	: GetSeed
	Prototype		: static smtUint32 GetSeed(ACCESS_TYPE type, 
						smtUint32 a, smtUint32 b) 
	Return			: Generation value by Seed
	Argument		: type/a/b-(8/16/32)bits/highword/lowword
	Comments		: Generation value
-----------------------------------------------------------*/
static smtUint32 GetSeed(ACCESS_TYPE type, smtUint32 a, smtUint32 b) 
{
	smtUint32	Result;
	
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
/*----------------------------------------------------------
	Function name	: MemVerify8bit
	Prototype		: static smtBoolean MemVerify8bit(smtUint32 source, 
						smtUint32	size, ACCESS_METHOD method, smtUint32 seed)
	Return			: test true/false-success/fail
	Argument		: source/size/method/seeds-source address/test size/access 
						type/seed value
	Comments		: Compare 8bit memory access verify
-----------------------------------------------------------*/
static smtBoolean MemVerify8bit(smtUint32 source, smtUint32	size, 
	ACCESS_METHOD method, smtUint32 seed)
{
	volatile smtUint8	*pSource;
	smtUint32 	u8Idx;
	
	switch(method) 
	{
		//---------------------------------------------------
		//	sequential acess
		//---------------------------------------------------
		case AM_SEQ:
			
			// write
			pSource = (smtUint8*)source;
			for(u8Idx = 0; u8Idx < size; u8Idx++) 
			{
				*pSource = GetSeed(AT_08BITS, u8Idx, seed);
				pSource++;
			}
			
			// verify
			pSource = (smtUint8*)source;
			for(u8Idx = 0; u8Idx < size; u8Idx++) 
			{
				if(*pSource != GetSeed(AT_08BITS, u8Idx, seed))
				{
					MEMTDPRINTF(CFG_UART_CH, "[MEM ERROR] 8bits seq access fail\n");
					MEMTDPRINTF(CFG_UART_CH, "[MEM ERROR] addr:origin:read");
					MEMTDPRINTF(CFG_UART_CH, "-0x%08x|0x%08x:0x%08x\n",
							pSource, GetSeed(AT_08BITS, u8Idx, seed), *pSource);
					return false;
				}
				pSource++;
			}
			
			MEMTDPRINTF(CFG_UART_CH, "[MEM TEST] 8bits seq acces OK!!!\n");			
			
			break;
	
		//---------------------------------------------------
		//	none sequential acess
		//---------------------------------------------------
		case AM_NONSEQ:
			
			// write
			pSource = (smtUint8*)source;
			for(u8Idx = 0; u8Idx < size; u8Idx+=8) 
			{
				*pSource = GetSeed(AT_08BITS, u8Idx, seed);
				pSource++;
			}
			
			// verify
			pSource = (smtUint8*)source;
			for(u8Idx = 0; u8Idx < size; u8Idx+=8) 
			{
				if(*pSource != GetSeed(AT_08BITS, u8Idx, seed))
				{
					MEMTDPRINTF(CFG_UART_CH, "[MEM ERROR] 8bits none seq access fail\n");
					MEMTDPRINTF(CFG_UART_CH, "[MEM ERROR] addr:origin:read");
					MEMTDPRINTF(CFG_UART_CH, "-0x%08x|0x%08x:0x%08x\n",
							pSource, GetSeed(AT_08BITS, u8Idx, seed) ,*pSource);
							
					return false;
				}
				pSource++;
			}			
			
			MEMTDPRINTF(CFG_UART_CH, "[MEM TEST] 8bits none seq acces OK!!!\n");			
			
			break;
			
		case AM_BURST:
			/* don't need in ARM */
			break;
	}
	
	return true;
}
/*----------------------------------------------------------
	Function name	: MemVerify16bit
	Prototype		: static smtBoolean MemVerify16bit(smtUint32 source, 
						smtUint32 size, ACCESS_METHOD method, smtUint32 seed)
	Return			: test true/false-success/fail
	Argument		: source/size/method/seeds-source address/test size/access 
						type/seed value
	Comments		: Compare 16bit memory access verify
-----------------------------------------------------------*/
static smtBoolean MemVerify16bit(smtUint32 source, smtUint32 size, 
	ACCESS_METHOD method, smtUint32 seed)
{
	volatile smtUint16 	*pSource;
	smtUint32 	u16Idx;
	
	switch(method) 
	{
		//---------------------------------------------------
		//	sequential acess
		//---------------------------------------------------
		case AM_SEQ:
			
			// write
			pSource = (volatile smtUint16*)source;
			for(u16Idx = 0; u16Idx < size/sizeof(smtUint16); u16Idx++) 
			{
				*pSource = GetSeed(AT_16BITS, u16Idx, seed);
				pSource++;
			}
			
			// verify
			pSource = (volatile smtUint16*)source;
			for(u16Idx = 0; u16Idx < size/sizeof(smtUint16); u16Idx++) 
			{
				if(*pSource != GetSeed(AT_16BITS, u16Idx, seed))
				{
					MEMTDPRINTF(CFG_UART_CH, "[MEM ERROR] 16bits seq access faile\n");
					MEMTDPRINTF(CFG_UART_CH, "[MEM ERROR] addr:origin:read");
					MEMTDPRINTF(CFG_UART_CH, "-0x%08x|0x%08x:0x%08x\n",
							pSource, GetSeed(AT_16BITS, u16Idx, seed) ,*pSource);
					return false;
				}
				pSource++;
			}
			
			MEMTDPRINTF(CFG_UART_CH, "[MEM TEST] 16bits seq acces OK!!!\n");			
			
			break;
		
		//---------------------------------------------------
		//	none sequential acess
		//---------------------------------------------------
		case AM_NONSEQ:
			
			// write
			pSource = (volatile smtUint16*)source;
			for(u16Idx = 0; u16Idx < size/sizeof(smtUint16); u16Idx+=8) 
			{
				*pSource = GetSeed(AT_16BITS, u16Idx, seed);
				pSource++;
			}
			
			// verify
			pSource = (volatile smtUint16*)source;
			for(u16Idx = 0; u16Idx < size/sizeof(smtUint16); u16Idx+=8) 
			{
				if(*pSource != GetSeed(AT_16BITS, u16Idx, seed))
				{
					MEMTDPRINTF(CFG_UART_CH, "[MEM ERROR] 16bits none seq access faile\n");
					MEMTDPRINTF(CFG_UART_CH, "[MEM ERROR] addr:origin:read");
					MEMTDPRINTF(CFG_UART_CH, "-0x%08x|0x%08x:0x%08x\n",
							pSource, GetSeed(AT_16BITS, u16Idx, seed) ,*pSource);
					return false;
				}
				pSource++;
			}			
			MEMTDPRINTF(CFG_UART_CH, "[MEM TEST] 16bits none seq acces OK!!!\n");			
			
			break;
			
		case AM_BURST:
			/* don't need in ARM */
			break;
	}
	
	return true;
}
/*----------------------------------------------------------
	Function name	: MemVerify32bit
	Prototype		: static smtBoolean MemVerify32bit(smtUint32 source, 
						smtUint32	size, ACCESS_METHOD method, smtUint32 seed)
	Return			: test true/false-success/fail
	Argument		: source/size/method/seeds-source address/test size/access 
						type/seed value
	Comments		: Compare 32bit memory access verify
-----------------------------------------------------------*/
static smtBoolean MemVerify32bit(smtUint32 source,  smtUint32 size, 
	ACCESS_METHOD method, smtUint32	seed)
{
	volatile smtUint32 	*pSource;
	smtUint32 	u32Idx;
	
	switch(method) 
	{
		//---------------------------------------------------
		//	sequential acess
		//---------------------------------------------------
		case AM_SEQ:
			
			// write
			pSource = (volatile smtUint32*)source;
			for(u32Idx = 0; u32Idx < size/sizeof(smtUint32); u32Idx++) 
			{
				*pSource = GetSeed(AT_32BITS, u32Idx, seed);
				pSource++;
			}
			
			// verify
			pSource = (volatile smtUint32*)source;
			for(u32Idx = 0; u32Idx < size/sizeof(smtUint32); u32Idx++) 
			{
				if(*pSource != GetSeed(AT_32BITS, u32Idx, seed))
				{
					MEMTDPRINTF(CFG_UART_CH, "[MEM ERROR] 32bits seq access fail\n");
					MEMTDPRINTF(CFG_UART_CH, "[MEM ERROR] addr:origin:read");
					MEMTDPRINTF(CFG_UART_CH, "-0x%08x|0x%08x:0x%08x\n",
							pSource, GetSeed(AT_32BITS, u32Idx, seed) ,*pSource);
					return false;
				}
				pSource++;
			}
			
			MEMTDPRINTF(CFG_UART_CH, "[MEM TEST] 32bits seq acces OK!!!\n");			
			
			break;
		//---------------------------------------------------
		//	none sequential acess
		//---------------------------------------------------			
		case AM_NONSEQ:
			
			// write
			pSource = (volatile smtUint32*)source;
			for(u32Idx = 0; u32Idx < size/sizeof(smtUint32); u32Idx+=8) 
			{
				*pSource = GetSeed(AT_32BITS, u32Idx, seed);
				pSource++;
			}
			
			// verify
			pSource = (volatile smtUint32*)source;
			for(u32Idx = 0; u32Idx < size/sizeof(smtUint32); u32Idx+=8) 
			{
				if(*pSource != GetSeed(AT_32BITS, u32Idx, seed))
				{
					MEMTDPRINTF(CFG_UART_CH, "[MEM ERROR] 32bits none seq access fail\n");
					MEMTDPRINTF(CFG_UART_CH, "[MEM ERROR] addr:origin:read");
					MEMTDPRINTF(CFG_UART_CH, "-0x%08x|0x%08x:0x%08x\n",
							pSource, GetSeed(AT_32BITS, u32Idx, seed) ,*pSource);
					return false;
				}
				pSource++;
			}			
			MEMTDPRINTF(CFG_UART_CH, "[MEM TEST] 32bits none seq acces OK!!!\n");			
			
			break;
		//---------------------------------------------------
		//	burst acess
		//---------------------------------------------------
		case AM_BURST:
		{
			// must be implemented for ARM 
			volatile smtUint32 *pTarget;
			
			// write
			pSource = (volatile smtUint32*)source;
			pTarget	= (volatile smtUint32*)(source+(size/2));
			
			for(u32Idx = 0; u32Idx < (size/2)/sizeof(smtUint32); u32Idx++) 
			{
				*pSource = GetSeed(AT_32BITS, u32Idx, seed);
				pSource++;
			}
						
			// burst write
			pSource = (volatile smtUint32*)source;
			pTarget	= (volatile smtUint32*)(source+(size/2));
			memcpy((void *)pTarget, (void *)pSource, size/2);
			
			// verify
			pSource = (volatile smtUint32*)(source+(size/2));
			pTarget	= (volatile smtUint32*)(source+(size/2));
			for(u32Idx = 0; u32Idx < (size/2)/sizeof(smtUint32); u32Idx++) 
			{
				if(*pSource != GetSeed(AT_32BITS, u32Idx, seed))
				{
					MEMTDPRINTF(CFG_UART_CH, "[MEM ERROR] 32bits burst access fail\n");
					MEMTDPRINTF(CFG_UART_CH, "[MEM ERROR] addr:origin:read");
					MEMTDPRINTF(CFG_UART_CH, "-0x%08x|0x%08x:0x%08x\n",
							pSource, GetSeed(AT_32BITS, u32Idx, seed) ,*pSource);
					return false;
				}
				pSource++;
			}			
			
			MEMTDPRINTF(CFG_UART_CH, "[MEM TEST] 32bits burst access OK!!!\n");			
		}
		break;
	}
	
	return true;
}

/*----------------------------------------------------------
	Function name	: MemRWTest
	Prototype		: smtBoolean MemRWTest(smtUint32 testTarget, 
						smtUint32 testSizeInByte, MEM_TEST *ptestInfo, smtUint32 seed)
	Return			: test true/false-success/fail
	Argument		: testTarget/testSizeInByte/ptestInfo/seed-test target address/
						test size in byte/memory test structure(MEM_TEST)
	Comments		: memory test top 
-----------------------------------------------------------*/
smtBoolean MemRWTest(smtUint32 testTarget, smtUint32 testSizeInByte, 
	MEM_TEST *ptestInfo, smtUint32 seed)
{
	smtUint32 	methodIdx;		

	switch(ptestInfo->type) 
	{
		//----------------------------------------------------------------------
		//	8bits access
		//----------------------------------------------------------------------
		case AT_08BITS:
		{			

    		for(methodIdx = 0 ; methodIdx < 3; methodIdx++) 
    		{    			
    			if(ptestInfo->method[methodIdx] == AM_NULL) 
    			{
    				break;
    			}
    			
    			if(!MemVerify8bit(
    					testTarget, 
    					testSizeInByte, 
    					ptestInfo->method[methodIdx], 
    					seed
    					))
    			{	
    				return false;
    			}
    		}	
		}
		break;
		//----------------------------------------------------------------------
		//	16bits access
		//----------------------------------------------------------------------
		case AT_16BITS:
		{
	
  	
    		for(methodIdx = 0 ; methodIdx < 3; methodIdx++) 
    		{
    			if(ptestInfo->method[methodIdx] == AM_NULL) 
    			{
    				break;
    			}
    			
    			if(!MemVerify16bit(
    					testTarget, 
    					testSizeInByte, 
    					ptestInfo->method[methodIdx], 
    					seed
    					))
    			{	
    				return false;
    			}
    		}
    			
		}
		break;
		//----------------------------------------------------------------------
		//	32bits access
		//----------------------------------------------------------------------		
		case AT_32BITS:
		{
    	
    		for(methodIdx = 0 ; methodIdx < 3; methodIdx++) 
    		{
    			if(ptestInfo->method[methodIdx] == AM_NULL) 
    			{
    				break;
    			}
    			
    			if(!MemVerify32bit(
    					testTarget, 
    					testSizeInByte, 
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


