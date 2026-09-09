/*-- --=======================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : MemBGntTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function tests the controller in a particular cornercase,
--           where the autorefresh is applied at the point of last static
--           access.
--
--           TEST ID : MPMC_MemBGnt_1
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************* MemBGntTest **********************************/
/******************************************************************************/
void MemBGntTest(void)
{
  /*
    Summary: MemBGntTest
    ====================
    This test performs the following functionalities:
   
    o This test performs burst of read to the unbuffered static chip select.
      At the last beat apply the refresh so that the staic is degranted.
    
    o Perform single read to the buffered static chip select and observe that
      the AHB locks up or not.
 
  */
  int i,size,csel,chip,burst,msize;
  char debugstr[100];
  char *sizetype[] = {"BYTE", "HWRD","WRD"};
  unsigned long Addr, Data,LoBits,Bound;
 
  int trans0[6] = {2,2,2,2,2,5};
  int trans1[10] = {2,3,3,3,3,3,3,3,3,5};
  int trans2[4] = {2,3,3,5};
  int trans3[9] = {2,3,3,3,3,3,3,3,5};
  int trans4[17]= {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  int trans5[2] = {2,5};
  int trans[500];
  C("TEST ID : MPMC_MemBGnt_1");
  /* Disable Address mirror */
  WriteData(MPMCControl, 0x00000001, "WRD");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  WriteData(MPMCTrExBkOff, 0x00000002, "WRD");
  /* Write from Port0 to all memory chips with diff sizes and read it back */

  TimingInit(2,6,8,5,6,2,4,7,7,4,2,3);
  SyncInitializeProc(3, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     3, 0, 3, 3, 0, 0,
                     0,1,3,0,0,1,1,0,3,1,2,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,1,
                     12,12,10,11,
                     0,
                     0);

  WriteData(MPMCTrSR, 0x00000000, "WRD");
  WriteData(MPMCDyRef, 0x2, "WRD");
  WaitLoop(0x5);
  C("Initialize Bank0 registers");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,0,0,0,0,0,0,0,0,0x3,0x3,0x4,0x7,0x5,0x5,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x3,0x3,0x4,0x7,0x5,0x5,MPMCTrMEMBData[0],
               0x0);
  WaitLoop(0x5);
  C("Initialize Bank1 registers");
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,0,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(1,0,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0); 

  WaitLoop(0x7);
  /* Set Bank 2 Memory Type as SRAM (32 bits width) */
  C("Initialize Bank2 registers");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,2,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(2,2,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[2],
               0x0);

  WaitLoop(0x7);
  /* Set Bank 3 Memory Type as SRAM (16 bits width) */
  C("Initialize Bank3 registers");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(3,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);

    WaitLoop(0x1B);
    HSA(0x00000004, NSEQ, INCR4, OK, WRD);
    HSR(,0x00000000, ,0x00000000);
    HSR(,0x00000000, ,0x00000000);
    HSR(,0x00000000, ,0x00000000);
    HSR(,0x00000000, ,0x00000000);
    
    
    HSA(0x10000020, NSEQ, SINGLE, OK, WRD);
    HSR(,0x00000000, ,0x00000000);
    HSA(0x10000024, NSEQ, SINGLE, OK, WRD);
    HSR(,0x00000000, ,0x00000000);
    HSA(0x10000028, NSEQ, SINGLE, OK, WRD);
    HSR(,0x00000000, ,0x00000000);
    HSA(0x1000002C, NSEQ, SINGLE, OK, WRD);
    HSR(,0x00000000, ,0x00000000);
} /* end of main */
/*-- --================================ End ================================--*/
