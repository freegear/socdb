/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: esmc.c 
	Description	: SMC test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
//#include "irq.h"
#include "dmc_pre_drv.h"
#include "memory_test.h"

/*
/////////////////////////////////////////////////////////
        FUNCTIONS DECLARE
///////////////////////////////////////////////////////// 
*/
extern 	smtBoolean 	smt2UartPrint(int dispLvl, char *fmt, ...);
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
#define SRAMTDPRINTF				smt2UartPrint
/*
/////////////////////////////////////////////////////////
        TYPE DEFINITION
///////////////////////////////////////////////////////// 
*/
/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/	
/*----------------------------------------------------------
	Function name	: ESRAMTest()
	Prototype		: smtUint32 ESRAMTest(void)
	Return			:
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtUint32 ESRAMTest(void)
{
	smtUint32	testIdx, regionIdx, loopCnt;
	smtBoolean	testResult;
	
	// memory test type
	MEM_TEST testInfo[] = 
	{
		{AT_08BITS, {AM_SEQ, 	AM_NONSEQ, 	AM_NULL		}},
		{AT_16BITS, {AM_SEQ, 	AM_NONSEQ, 	AM_NULL		}},
		{AT_32BITS, {AM_SEQ, 	AM_NONSEQ, 	AM_BURST	}},
		{AT_NULL, 	{AM_NULL, 	AM_NULL, 	AM_NULL		}}
	};	
	
	// memory test region
	MEM_REGION	testRegion[] = 
	{	
		{0x20000000, 	(0x20000000+0x20000)},		// SRAM Region 0
		{0xFFFFFFFF, 	0xFFFFFFFF		     },		// end marker
	};
	
	

	testIdx 	= 0;
	regionIdx	= 0;
	
	SRAMTDPRINTF(11, "[SRAM TEST] START!!!\n");
	
	for(loopCnt = 0; loopCnt < 4; loopCnt++) {
		
		regionIdx = 0;
		while(true) 
		{
			
			//-------------------------------------------------------
			//	check end condition and invalid condition
			//-------------------------------------------------------
			if(testRegion[regionIdx].startAddress == testRegion[regionIdx].endAddress)
			{
				if(testRegion[regionIdx].startAddress == 0xFFFFFFFF) 
				{
					SRAMTDPRINTF(11, "[SRAM TEST] %d loop test END!!!\n", loopCnt);
					break;
				}
				else
				{
					SRAMTDPRINTF(11, 
						"[SRAM ERROR] start/end address is overlapped!!!\n");
					return !NO_ERROR;	
				}
			}
    	
			
			//--------------------------------------------------------
			//	memory test per test type
			//--------------------------------------------------------
			SRAMTDPRINTF(11, "------------------------------------------------------\n");
			SRAMTDPRINTF(11, "[SRAM TEST] region: 0x%08x-0x%08x\n",
					testRegion[regionIdx].startAddress, 
					testRegion[regionIdx].endAddress);
			SRAMTDPRINTF(11, "------------------------------------------------------\n");				
			testIdx = 0;
			while(testInfo[testIdx].type != AT_NULL) 
			{
				testResult = MemRWTest(
					testRegion[regionIdx].startAddress,			// start address
					(testRegion[regionIdx].endAddress
					-testRegion[regionIdx].startAddress + 1), 	// length in byte
					&testInfo[testIdx], 						// test type
					(loopCnt<<24)								// test seed
				);
				
				if(!testResult) 
				{
					return !NO_ERROR;	
				}
				
				// increament test type index
				testIdx++;
			}
			
			// increament test region index
			regionIdx++;
		}
	}
	
	return NO_ERROR;	
}
