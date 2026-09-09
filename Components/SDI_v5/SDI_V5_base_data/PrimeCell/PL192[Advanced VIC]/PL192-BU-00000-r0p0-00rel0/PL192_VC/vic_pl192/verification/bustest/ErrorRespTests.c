/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : ErrorRespTests.c.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Error-response tests on the Vic.
--
-- --=========================================================================*/
 
/******************************************************************************/
/************************** Error Response Tests ******************************/
/******************************************************************************/

void ErrorRespTests()
{
  /*
     Summary: Error Response Tests
     =============================
     This function performs the following: 
 
     o  All VIC Registers are accessed with invalid HSIZE values,
        expecting ERROR Response.
    
     o  Both reads and writes are performed with HSIZE values of 
        BYTE and HALF-WORD.

     o  Non-Sequential and Sequential accesses are performed.
  */

  int i;
  int32 addr;
 
  /** Half-word and Byte accesses are done to ALL the registers. An **/
  /** Error response is expected in each case.                      **/

  HSA(VICIRQStatus, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICFIQStatus, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICRawIntr, NSEQ, SINGLE, ERROR, BYTE, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICIntSelect, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICIntEnable, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICIntEnClear, NSEQ, SINGLE, ERROR, BYTE, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICSoftInt, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICSoftIntClear, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICProtection, NSEQ, SINGLE, ERROR, BYTE, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICVectAddr, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICSWPriorityMask, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICVectPriorityDaisy, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  for (i = 0; i < INT_COUNT; i++)
  {
    HSA(VICVectAddr_BASE + i * 0x4, NSEQ, SINGLE, ERROR, BYTE, , 0x1, , , , , 0x0);
    HSW( , DataF);
  }
 
  for (i = 0; i < INT_COUNT; i++)
  {
    HSA(VICVectPriority_BASE + i * 0x4, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
    HSW( , DataF);
  }
 
  HSA(VICITCR, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICITIP1, NSEQ, SINGLE, ERROR, BYTE, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICITIP2, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICITOP1, NSEQ, SINGLE, ERROR, BYTE, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICITOP2, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICPeriphID0, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICPeriphID1, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICPeriphID2, NSEQ, SINGLE, ERROR, BYTE, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICPeriphID3, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICPCellID0, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICPCellID1, NSEQ, SINGLE, ERROR, BYTE, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICPCellID2, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);
 
  HSA(VICPCellID3, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , 0x0);
  HSW( , DataF);

  /** Expecting Error Response during Burst accesses **/
  addr = VICVectPriority_BASE;
  HSA(addr, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , );
  HSW( , DataF);
  addr += 0x4;
  for (i = 1; i < INT_COUNT; i++)
  {
    HSW( , DataF);
  }
}

/************************************ End *************************************/
