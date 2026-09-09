/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : TestForErrata3_6_BufEn.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Does different types of memory access
--
-- --=======================================================================--*/
void TestForErrata3_6_BufEn()
{
  /*
     Summary: TestForErrata3_6_BuffEn
     ================================
     It does the following functionality
  
     o  Initialise the Static memories with buffers enabled.

     o  Write to the static memories through AHB 1

     o  Try to perform read from the AHB 0 to the same bank.

     o  Verify that the Port0 gets the bus at the earliest.
  */

  int i;
  int32 Addr, Data,Address;
  char debugstr[100];
  #if (INFILE == 3)
  C("TEST ID : MPMC_MultiPortPgAccessTest1");
  C("Configuring the Memory Banks and the MPMC");

  WriteData(MPMCControl, 0x00000001, "WRD");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  TimingInit(2,6,8,5,6,2,4,7,7,4,2,3);
  SyncInitializeProc(2, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     3, 0, 3, 2, 0, 0,
                     3, 0, 2, 3, 0, 0,
                     0,1,3,1,1,1,1,0,3,1,2,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,1,
                     11,12,10,11,
                     0,
                     0);

  /* Program the operational value to REFRESH field */
  HSA(MPMCDyRef,NSEQ,INCR,OK,WRD,0x7FF, , ,0);
  HSW(,0x0000032);
  WaitLoop(0x270);

  WriteData(MPMCTrCR, 0x00000020, "WRD");
  
  MPMCTrMEMBData[0] = 0x00000000;

  C("Initialize registers of bank0 and TrickMem0");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,0,0,0,0,0,1,1,0,0x1,0x1,0x2,0x3,0x4,0x2,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x1,0x1,0x2,0x3,0x4,0x2,MPMCTrMEMBData[0],
               0x0);
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Initialize registers of bank1 and TrickMem1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,1,1,0x1,0x1,0x2,0x3,0x4,0x1,0x2);
  TrickMemInit(1,1,0,0,1,0,0,1,0,0x1,0x1,0x2,0x3,0x4,0x1,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (32 bits width) */
  C("Initialize registers of bank2 and TrickMem2");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,2,0,0,1,0,1,1,0,0x1,0x1,0x2,0x2,0x3,0x0,0x3);
  TrickMemInit(2,2,0,0,1,0,1,0,0,0x1,0x1,0x2,0x2,0x3,0x0,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (16 bits width) */
  C("Initialize registers of bank3 and TrickMem3");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,1,0,0,1,0,1,1,0,0x1,0x2,0x2,0x2,0x3,0x2,0x3);
  TrickMemInit(3,1,0,0,1,0,1,1,0,0x1,0x2,0x2,0x2,0x3,0x2,MPMCTrMEMBData[3],
               0x0);

  ENDIANNESS = 0;
  HSEN(LITTLE); 

  HSA(MPMCTrSR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000008);
  WaitLoop(0x3);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x0000000B, ,0x0000000B);
  WaitLoop(0x3);

  #elif (INFILE == 1)
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);
  WaitLoop(0x3);
  
  Address = 0x000000F0;
  Data = 0x0;
  WaitLoop(0x9);
  for (i = 0; i < 100; i++)
  {
    C("Writing from Port2");
    HSA(Address, NSEQ, SINGLE, OK, WRD);
    HSW(, Data);
    Address = Address + 0x00004;
    Data = Data + 1;
  }

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000002);
  WaitLoop(0x3);

  #elif (INFILE == 0)
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);
  WaitLoop(0x3);
  Address = 0x000001FC;
  for (i=0;i<=3;i++) {
  C("Reading from Port0");
  HSA(Address, NSEQ, INCR16, OK, WRD);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  Address = Address + 0x4;
  }

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000001);
 #endif
}
/*-- --=============================== End ================================-- */
