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
-- File Name              : MPMCEnableTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--            This test verifies the functionality of MPMCEnable bit of
--            MPMCControl register.
--
--            TEST ID : MPMC_En_1
--
-- --=======================================================================--*/
/******************************************************************************/
/********************************* MPMCEnableTest *****************************/
/******************************************************************************/
void MPMCEnableTest()
{
  /*
    Summary: MPMCEnableTest
    =======================
    This functin verifies the following functionalities

    o  Reset MPMCEnable bit and verify that memory accesses will result in
       ERROR response. 

    o  Set MPMCEnable bit and verify that memory accesses will result in
       OK response. 
  */

  unsigned long addr;
  unsigned long chpsel;
  /* Write 0 to MPMCTrTES[3] */
  C("TEST ID : MPMC_En_1");
  WriteData(MPMCTrTES, 0x00000000, "WRD");

  WriteData(MPMCControl, 0x00000001, "WRD");
  TimingInit(2,5,8,0,5,0,0,7,0,0,2,3);
  SyncInitializeProc(3, 0, 3, 3, 0, 0,
                     2, 0, 3, 3, 0, 0,
                     3, 0, 3, 3, 0, 0,
                     3, 0, 3, 3, 0, 0,
                     0,1,3,0,0,1,1,0,3,1,2,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,1,
                     12,12,10,11,
                     0,
                     0);
  C("Initialize Bank0 registers");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,0,0,0,0,0,0,0,0,0x3,0x3,0x4,0x7,0x5,0x5,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x3,0x3,0x4,0x7,0x5,0x5,MPMCTrMEMBData[0],
               0x0);
  C("Initialize Bank1 registers");
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,1,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(1,1,0,0,1,0,0,1,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (32 bits width) */
  C("Initialize Bank2 registers");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,2,0,0,1,0,1,0,0,0x4,0x5,0x6,0x7,0x9,0x2,0x3);
  TrickMemInit(2,2,0,0,1,0,1,0,0,0x4,0x5,0x6,0x7,0x9,0x2,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (16 bits width) */
  C("Initialize Bank3 registers");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,1,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(3,1,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);
  /* Initialize refresh counter */
  WriteData(MPMCDyRef, 0x00000002, "WRD");

  /* Poll Busy bit of MPMCStatus */
  C("Poll for busy bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);

  /* Write 0 to E bit of MPMCControl register. */
  C("Disable MPMCEnable");
  WriteData(MPMCControl, 0x00000000, "WRD");

  WaitLoop(0x2);
  /* Perform write and Read operation and verify that response is ERROR */
  debug_info("Perform memory access and verify that response is E R R O R");
  chpsel = rand() % 4;
  addr = (rand() & 0x000001FC) | chpsel << 28 ;
  WriteErr(addr, Data_0s, WRD);
  ReadErr(addr, Data_0s, MaskALL, WRD);

  /* Write 1 to E bit of MPMCControl register. */
  debug_info("Write 1 to MPMCEnable bit of MPMCControl");
  WriteData(MPMCControl, 0x00000001, "WRD");
  WaitLoop(0x3);
  /* Perform write and Read operation and verify that response is OK */
  debug_info("Verify that controller is enabled by performing memory access");
  WriteData(addr, Data_0s, "WRD");
  ReadData(addr, Data_0s, MaskALL, "WRD");
  
  /* Read the RefErrSt bit of MPMCTrSR register, it'll be low indicating that
     refresh is been issued */
  WaitLoop(0x20);
  ReadData(MPMCTrSR, Data_0s, 0x00000100, "WRD");

  /* Write 1 to MPMCTrTES[3] */
  WriteData(MPMCTrTES, 0x00000008, "WRD");
}
/*-- --=============================== End ================================--*/
