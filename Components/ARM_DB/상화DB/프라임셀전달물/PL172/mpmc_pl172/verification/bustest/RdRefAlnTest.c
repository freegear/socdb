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
-- File Name              : RdRefAlnTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--          This test verifies that refresh has highest priority over memory
--          access when they are applied simultaneously
--
--          TEST ID : MPMC_RdRef_1
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************* RdRefAlnTest *********************************/
/******************************************************************************/
void RdRefAlnTest(void)
{
  /*
    Summary: RdRefAlnTest
    =====================
    This test performs the below functionality check

    o  Program REFRESH field and apply read request when REFRESH becomes zero.

    o  Verify that refresh gets higher priority than read operaion
  
  */ 
  int refcnt[4] = {8,0xA,0xF,5};
  unsigned long data[4]   = {0x11111111,0xFFFFFFFF,0x55555555,0xAAAAAAAA};
  unsigned long addr[4]   = {0x40067890,0x500FFFF0,0x60055550,0x700AAAA0};
  unsigned long Addr,Data;
  int i,j;
  int waitval;
  C("TEST ID : MPMC_RdRef_1");
  Data = 0x22222222; 
  TimingInit(2,6,8,5,6,5,4,7,7,4,2,3);
  WriteData(MPMCControl, 0x00000001, "WRD");
  SyncInitializeProc(
                     2, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     0,1,0,0,1,1,1,0,2,0,0,
                     0,0,0,0,0,1,1,0,3,0,0,
                     0,0,1,0,0,1,1,0,3,1,1,
                     0,0,2,0,1,1,1,0,4,1,1,
                     11,11,12,14,
                     0,
                     0
                    );
    WriteData(MPMCTrSR, 0x00000000, "WRD");
    C("Program refresh counter");
    WriteData(MPMCDyRef, 0x8, "WRD");

    /* Initiate read operation when refresh counter reaches zero */
    waitval = 8 * 16;
    WaitLoop(waitval-3);

    C("Read data");
    ReadData(0x40000010, 0x00000005, 0x0000FFFF, "WRD");
    WaitLoop(0x30);
}
/*-- --================================ End ================================--*/
