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
-- File Name              : ExdWaitDelTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function tests the Extended Wait(EW) bit of StConfig register.
--
--           TEST ID : MPMC_ExdWtDel_1
--
-- --=======================================================================--*/
/******************************************************************************/
/****************************** ExdWaitDelTest ********************************/
/******************************************************************************/
void ExdWaitDelTest()
{
  /*
    Summary: ExdWaitDelTest
    =======================
    This test performs the following functionality

    o Program MPMCExdWt register with delay value.
 
    o Program MPMCStConfig register with EW as 1 indicating extended wait is 
      enabled.
   
    o Does all combinations of BURST reads, Non-BURST reads and writes as
      mentioned below:
        - Read followed by BURST reads to same and different banks
        - Read followed by writes to same and different banks
        - BURST read followed by reads to same and different banks
        - BURST read followed by writes to same and different banks
        - Write followed by reads to same and different banks
        - Write followed by BURST reads to same and different banks
  */
  int i,k;
  unsigned long TestData, TestWrite, MemAddr, TestRead;
  int32 ExdWt[4] = {0x1F, 0x14, 0x8};
  TestRead = 0x00333333;
  TestWrite = 0x00444444;
  C("TEST ID : MPMC_ExdWtDel_1");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  C("Initialize registers of Bank0");
  StInitProc(0,2,0,0,1,1,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(0,2,0,0,1,1,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);

  C("Initialize registers of Bank1");
  StInitProc(1,2,0,0,1,1,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(1,2,0,0,1,1,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);

  C("Initialize registers of Bank2");
  StInitProc(2,2,0,0,1,1,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(2,2,0,0,1,1,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);

  C("Initialize registers of Bank3");
  StInitProc(3,2,0,0,1,1,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3FD);
  TrickMemInit(3,2,0,0,1,1,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);
  
  WriteData(MPMCControl, 0x00000001, "WRD");

  MemAddr = MEM3_BASE + (MPMCTrMEMBData[0] << 11) + 0x7C0; 
  WaitLoop(0x3);
  HSA(MemAddr, NSEQ, SINGLE, OK, WRD);
  HSW(,0x55555555);
  WaitLoop(0x400); 

  for(i = 0; i < 3; i++)
  {
    MPMCDisable();  
    WriteData(MPMCStExdWt, ExdWt[i], "WRD");
    MPMCEnable();  
    
    AHBWriteMem(0, 0x7E0, 8, TestRead);
    C("BURST Writes followed by BURST reads to the same bank");

    TestData = TestWrite;
    MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x7C0;

    sprintf(message,"Write data %X to memory location %X",TestData,MemAddr);
    debug_info(message);

    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestData++);
    for (k=0; k<7; k++)
    {
       sprintf(message,"Write data %X",TestData);
       debug_info(message);

       HSW( , TestData++);
    }
    TestData = TestRead;
    sprintf(message,"Read data %X from memory location %X",
            TestData,MemAddr+32);
    debug_info(message);

    HSA(MemAddr+32, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , MaskALL, ,ExdDelValTests_1);
    for (k=0; k<7; k++)
    {
      sprintf(message,"Read data %X",TestData);
      debug_info(message);
      HSR( , TestData++, , MaskALL, ,ExdDelValTests_2);
    }
    C("BURST Reads followed by BURST Writes to the same bank");

    TestData = TestWrite;
    sprintf(message,"Read data %X from memory location %X",
            TestData,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , MaskALL, ,ExdDelValTests_3);
    for (k=0; k<7; k++)
    {
      sprintf(message,"Read data %X",TestData);
      debug_info(message);

      HSR( , TestData++, , MaskALL, ,ExdDelValTests_4);
    }
    TestData = TestWrite;
    sprintf(message,"Write data %X to memory location %X",
            TestData,MemAddr+32);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestData++);
    for (k=0; k<7; k++)
    {
      sprintf(message,"Write data %X",TestData);
      debug_info(message);
      HSW( , TestData++);
    } 
    C("BURST Reads followed by BURST Writes to different banks");

    TestData = TestWrite;
    sprintf(message,"Read data %X from memory location %X",
            TestData,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , MaskALL, ,ExdDelValTests_5);
    for (k=0; k<7; k++)
    {
      sprintf(message,"Read data %X",TestData);
      debug_info(message);
      HSR( , TestData++, , MaskALL, ,ExdDelValTests_6);
    }
    TestWrite+= 0x00111111;
    TestData = TestWrite;
    MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x7C0;
    sprintf(message,"Write data %X to memory location %X",
            TestData,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestData++);
    for (k=0; k<7; k++)
    {
      sprintf(message,"Write data %X",TestData);
      debug_info(message);
      HSW( , TestData++);
    }
    C("BURST Writes followed by BURST Reads to different banks");
    MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x7C0;
    TestData = TestWrite;
    sprintf(message,"Write data %X to memory location %X",
            TestData,MemAddr);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestData++);
    for (k=0; k<7; k++)
    {
      sprintf(message,"Write data %X", TestData);
      debug_info(message);
      HSW( , TestData++);
    }
    TestData = TestWrite;
    MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x7C0;
    sprintf(message,"Read data %X from memory location %X",
            TestData,MemAddr);
    debug_info(message);

    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , MaskALL, ,ExdDelValTests_7);
    for (k=0; k<7; k++)
    {
      sprintf(message,"Read data %X", TestData);
      debug_info(message);
      HSR( , TestData++, , MaskALL, ,ExdDelValTests_8);
    }
    C("BURST Writes followed by BURST Writes to the same bank");

    MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x7C0;
    TestWrite+= 0x00111111;
    TestData = TestWrite;
    sprintf(message,"Write data %X to memory location %X",
            TestData,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestData++);
    for (k=0; k<7; k++)
    {
      sprintf(message,"Write data %X",TestData);
      debug_info(message);
      HSW( , TestData++);
    }
    sprintf(message,"Write data %X to memory location %X",
            TestData,MemAddr + 32);
    debug_info(message);


    HSA(MemAddr+32, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestData++);
    for (k=0; k<7; k++)
    {
      sprintf(message,"Write data %X",TestData);
      debug_info(message);
      HSW( , TestData++);
    }
    C("BURST Reads followed by BURST Reads to the same bank");

    TestData = TestWrite;
    sprintf(message,"Read data %X from location %X",TestData,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , MaskALL, ,ExdDelValTests_11);
    for (k=0; k<7; k++)
    {
      sprintf(message,"Read data %X",TestData);
      debug_info(message);
      HSR( , TestData++, , MaskALL, ,ExdDelValTests_12);
    }
    sprintf(message,"Read data %X from location %X",TestData,MemAddr + 32);
    debug_info(message);
    HSA(MemAddr+32, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , MaskALL, ,ExdDelValTests_13);
    for (k=0; k<7; k++)
    {
      sprintf(message,"Read data %X",TestData);
      debug_info(message);
      HSR( , TestData++, , MaskALL, ,ExdDelValTests_14);
    }
    C("BURST Writes followed by BURST Writes to different banks");

    MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x7C0;
    TestWrite+= 0x00111111;
    TestData = TestWrite;
    sprintf(message,"Write data %X to location %X",TestData,MemAddr);
    debug_info(message);

    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestData++);
    for (k=0; k<7; k++)
    {
      sprintf(message,"Write data %X",TestData);
      debug_info(message);
      HSW( , TestData++);
    }
    MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x7C0;
    sprintf(message,"Write data %X to location %X",TestData,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestData++);
    for (k=0; k<7; k++)
    {
      sprintf(message,"Write data %X",TestData);
      debug_info(message);
      HSW( , TestData++);
    }
    C("BURST Reads followed by BURST Reads to different banks");

    MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x7C0;
    TestData = TestWrite;
    sprintf(message,"Read data %X from location %X",TestData,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , MaskALL, ,ExdDelValTests_15);
    for (k=0; k<7; k++)
    {
      sprintf(message,"Read data %X",TestData);
      debug_info(message);
      HSR( , TestData++, , MaskALL, ,ExdDelValTests_16);
    }
    MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x7C0;
    sprintf(message,"Read data %X from location %X",TestData,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , MaskALL, ,ExdDelValTests_17);
    for (k=0; k<7; k++)
    {
      sprintf(message,"Read data %X",TestData);
      debug_info(message);
      HSR( , TestData++, , MaskALL, ,ExdDelValTests_18);
    }
    /* Does Non-BURST Transfers */

    C("Write followed by Read to the same bank");
    MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
    AHBWriteMem(2, 16, 4, TestRead);
    sprintf(message,"Write data %X to location %X",TestData,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWrite);

    TestData = TestRead;
    MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11) + 0x10;
    sprintf(message,"Write data %X to location %X",TestData,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData, , MaskALL, ,ExdDelValTests_19);

    C("Read followed by Write to the same bank");
    sprintf(message,"Read data %X from location %X",TestRead,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestRead, , MaskALL, ,ExdDelValTests_20);

    TestWrite+= 0x00111111;
    MemAddr+= 4;
    sprintf(message,"Read data %X from location %X",TestWrite,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWrite);

    C("Read followed by Write to different banks");

    TestData = TestWrite;
    sprintf(message,"Read data %X from location %X",TestWrite,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestWrite, , MaskALL, ,ExdDelValTests_21);

    MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11);
    sprintf(message,"Write data %X to location %X",~TestWrite,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , ~TestWrite);

    C("Write followed by Read to different banks");

    MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
    sprintf(message,"Write data %X to location %X",TestWrite,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWrite);

    MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11);
    sprintf(message,"Read data %X from location %X",~TestWrite,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , ~TestWrite, , MaskALL, ,ExdDelValTests_22);

    /* Verify the previously written data */
    MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
    debug_info("Verify the previously written data");
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestWrite, , MaskALL, ,ExdDelValTests_23);

    C("Write followed by Write to the same bank");

    MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
    TestWrite+= 0x00111111;
    sprintf(message,"Write data %X to location %X",TestWrite,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWrite);
    sprintf(message,"Write data %X to location %X",~TestWrite,MemAddr+4);
    debug_info(message);
    HSA(MemAddr+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , ~TestWrite);

    C("Read followed by Read to the same bank");
    sprintf(message,"Read data %X from location %X",TestWrite,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestWrite, , MaskALL, ,ExdDelValTests_24);
    sprintf(message,"Read data %X from location %X",~TestWrite,MemAddr + 4);
    debug_info(message);
    HSA(MemAddr+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , ~TestWrite, , MaskALL, ,ExdDelValTests_25);

    C("Write followed by Write to different banks");

    MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
    TestWrite+= 0x00111111;
    sprintf(message,"Write data %X to location %X",TestWrite,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWrite);

    MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11);
    sprintf(message,"Write data %X to location %X",~TestWrite,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , ~TestWrite);

    C("Read followed by Read to different banks");

    MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11);
    sprintf(message,"Read data %X from location %X",TestWrite,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestWrite, , MaskALL, ,ExdDelValTests_26);

    MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11);
    sprintf(message,"Read data %X from location %X",~TestWrite,MemAddr);
    debug_info(message);
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , ~TestWrite, , MaskALL, ,ExdDelValTests_27);
  }
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(,0x00000008);
}
/*-- --================================ End ================================--*/
