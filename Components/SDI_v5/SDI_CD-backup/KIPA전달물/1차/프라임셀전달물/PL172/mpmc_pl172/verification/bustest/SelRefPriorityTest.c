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
-- File Name              : SelRefPriorityTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           It checks priorities of self Refresh and normal refresh
--
--           TEST ID : MPMC_SelfRefPriority
--
-- --=======================================================================--*/
/******************************************************************************/
/************************** SelRefPriorityTest ********************************/
/******************************************************************************/
void SelRefPriorityTest(void)
{
  /*
     Summary : Self Refresh Priority Test
     ====================================
     This test verifies the following functionality:

     o When a self refresh request is issued at the same time as a normal 
       refresh,the refresh gets higher priority and the self refresh gets 
       delayed by a few clocks.

     o When a self request is issued one clock before a refresh, it finishes
       without getting delayed. The refresh gets delayed by a few clocks.
  */

  int Address0, column;
  int PortAddr, WrDataAddr, RdDataAddr, DqmAddr, PmuVal;
  int Device, Bank, Page;
  long int Data, Data1, Data2;

  C("TEST ID : MPMC_SelfRefPriority");
  WriteData(MPMCControl, 0x00000001, "WRD");
  TimingInit(2,5,8,0,5,2,0,7,7,0,2,3);
  SyncInitializeProc(3, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     0,1,3,0,0,1,1,0,3,1,2,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,1,
                     12,12,10,11,
                     0,
                     0);
  WriteData(MPMCTrSR, 0x00000000, "WRD");

  C("Programming the refresh register");
  WriteData(MPMCDyRef, 0x4, "WRD");

  C("Idle cycles to align the self refresh request with a refresh");
  WaitLoop(0x37);

  C("Assert self refresh request");
  WriteData(MPMCDyCntl, 0x4, "WRD");
 
  C("Checking for self refresh ack to be asserted");
  WaitLoop(0x1);
  HSA(MPMCTrSR, NSEQ, INCR);
  HPO( ,0x004, ,0x004, , ,PollSREFbit_high);

  /* Keep the self refresh request asserted for some time */
  WaitLoop(0x13);

  C("Deassert self refresh request");
  WriteData(MPMCDyCntl, Data_0s, "WRD");

  C("Checking for self refresh to be deasserted");
  WaitLoop(2);
  ReadData(MPMCTrSR, 0x000, 0x004, "WRD");

  WaitLoop(0x30);

  C("Idle cycles to align the self refresh request one clock before a refresh");
  WaitLoop(0x09);

  C("Assert self refresh request");
  WriteData(MPMCDyCntl, 0x04, "WRD");

  C("Checking for self refresh to be asserted");
  HSA(MPMCTrSR, NSEQ, INCR);
  HPO( ,0x004, ,0x004, , ,PollSREFbit_high);

  /* Keep the self refresh request asserted for some time */
  WaitLoop(0x13);

  C("Deassert self refresh request");
  WriteData(MPMCDyCntl, ZERO, "WRD");

  C("Checking for self refresh to be deasserted");
  WaitLoop(2);
  ReadData(MPMCDyCntl, 0x000, 0x004, "WRD");

  WaitLoop(5);

  C("Programming the refresh register");
  WriteData(MPMCDyRef, 0x4, "WRD");
}
/*-- --=========================== End ====================================-- */
