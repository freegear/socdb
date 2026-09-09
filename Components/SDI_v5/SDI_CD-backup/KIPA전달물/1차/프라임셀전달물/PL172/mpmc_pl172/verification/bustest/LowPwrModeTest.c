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
-- File Name              : LowPwrModeTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--          This block checks the functionality of LowPower(L) bit of 
--          MPMCControl regsiter
--
--          TEST ID : MPMC_LowPwrMode_1
--
-- --=======================================================================--*/
/******************************************************************************/
/********************************* LowPwrModeTest *****************************/
/******************************************************************************/
void LowPwrModeTest()
{
  /*
     Summary: LowPwrModeTest
     =======================
     This test verifies the following functionalities

     o  Enable low power mode and verify that memory accesses result in ERROR
        response.

     o  Observe that refresh activity is unaltered.
  */ 

  unsigned long addr,Data, MemAddr0,MemData0, MemAddr1,MemData1;
  int trans[1024];
  int Addr;
  C("TEST ID : MPMC_LowPwrMode_1");
  WriteData(MPMCControl, 0x00000001, "WRD");
  TimingInit(2,6,8,5,6,5,4,7,7,4,2,3);
  SyncInitializeProc(3, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     0,1,3,0,0,1,1,0,3,1,0,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,0,
                     12,12,10,11,
                     0,
                     0);
  /* Set Bank 0 Memory Type as SRAM (32 bits width) */
  C("Initialize bank0 registers");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,2,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(0,2,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);
  /* Set Bank 1 Memory Type as SRAM (32 bits width) */ 
  C("Initialize bank1 registers");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(1,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);
  /* Set Bank 2 Memory Type as SRAM (32 bits width) */
  C("Initialize bank2 registers");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,2,0,0,1,0,1,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(2,2,0,0,1,0,1,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (16 bits width) */
  C("Initialize bank3 registers");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,1,0,0,0,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(3,1,0,0,0,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);

  /* Write 1 to L of MPMCControl to enable the low power mode */
  
  C("Programming the refresh counter");
 /* WriteData(MPMCDyRef, 0x2, "WRD"); */
  WriteData(MPMCControl, 0x00000001, "WRD");
  /* Write to a memory location and read when low power mode is enabled and
    disabled. Read from the same location and verify that data has not changed*/
  
  Addr = 0x40000004;
  InitTransRnd(trans,200);
  Sequence('w',Addr,trans,"inc",2,0xBBBBBBBB,0);

  Addr = 0x000000C6;
  InitTransRnd(trans,100);
  Sequence('w',Addr,trans,"inc",0,0xBBBBBBBB,0);

  MemAddr0 = MEM0_BASE + (rand() & 0x3DC); 
  MemData0 = 0xFFFFFFFF;
  WriteData(MemAddr0, MemData0, "WRD");

  MemAddr1 = MEM1_BASE + (rand() & 0x3DC);
  MemData1 = 0xFFFFFFFF;
  WriteData(MemAddr1, MemData1, "WRD");

  WaitLoop(0x50);

  C("Poll for mpmc busy bit");
  HSA(MPMCStatus,NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, , 0x00000001);

  C("Enable Low power mode");
  WriteData(MPMCControl, 0x00000005, "WRD");
  C("Enable refresh Check");
  WriteData(MPMCTrSR, 0x00000040, "WRD");

  /* Perform memory accesses and verify that response is ERROR */
  HSA(0x40005000, NSEQ, INCR, ERROR, WRD);
  HSR(,0x55555555, ,0xFFFFFFFF);

  HSA(0x40005000, NSEQ, INCR, ERROR, WRD);
  HSR(,0x00000000, ,0xFFFFFFFF);
  addr = rand() & 0x3DC;
  addr = MEM0_BASE + addr;
  HSA(0x40005000, NSEQ, INCR, ERROR, WRD, , , , , , ,);
  HSR(, 0xFFFFFFFF, ,0xFFFFFFFF);

  addr = rand() & 0x3DC;
  addr = MEM0_BASE + addr;
  HSA(0x40005000, NSEQ, INCR, ERROR, WRD, , , , , , ,);
  HSR(, 0xAAAAAAAA, ,0xFFFFFFFF);

  addr = rand() & 0x3DC;
  addr = MEM0_BASE + addr;
  HSA(0x40005000, NSEQ, INCR, ERROR, WRD, , , , , , ,);
  HSR(, 0x55555555, ,0xFFFFFFFF);
  
  addr = rand() & 0x3DC;
  addr = MEM0_BASE + addr;
  HSA(0x40005000, NSEQ, INCR, ERROR, WRD, , , , , , ,);
  HSR(, 0x22222222, ,0xFFFFFFFF);

  /* Reset RefErrSt bit */
  WriteData(MPMCTrSR, 0x00000000, "WRD");
  C("Disable low power mode");
  WriteData(MPMCControl, 0x00000001, "WRD");
  WaitLoop(0x2);
  /* Read data which are previously written */

  ReadData(MemAddr0, MemData0, MaskALL, "WRD");
  ReadData(MemAddr1, MemData1, MaskALL, "WRD");
  Addr = 0x40000004;
  InitTransRnd(trans,200);
  Sequence('r',Addr,trans,"inc",2,0xBBBBBBBB,0);

  Addr = 0x000000C6;
  InitTransRnd(trans,100);
  Sequence('r',Addr,trans,"inc",0,0xBBBBBBBB,0);
}
/*-- --================================ End ================================--*/
