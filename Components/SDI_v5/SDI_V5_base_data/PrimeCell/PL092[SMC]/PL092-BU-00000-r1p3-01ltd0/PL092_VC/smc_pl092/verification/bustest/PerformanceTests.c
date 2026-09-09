/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : PerformanceTests.c.rca
--  File Revision          : 1.17
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Read/Write operation tests on the SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/***************************** Performance Tests ******************************/
/******************************************************************************/

void PerformanceTests()
{
  /*
     Summary: Performance Tests
     ==========================
     This function performs the following:

     o  Checks whether the SMC gives data to the requester immedietely.
     o  Checks whether the SMC holds the HREADYOUT low even after the
        completion of a valid read/write
     o  Verifies that the read/write is completed within the expected number
        of clock cycles
  */

  int i, j;
  int32 MemAddr1, MemAddr2, MemAddr3, MemAddr4, TestData;
  int32 TestWrite[3] = {0x11111111, 0x22222222, 0x33333333};
  int32 TestWST1[3] = {0x00000005, 0x0000001F, 0x0000000F};
  int32 TestWST2[3] = {0x00000005, 0x0000001F, 0x0000000F};
  int32 TestIDCY[3] = {0x00000007, 0x00000002, 0x00000000};

  /** Set Bank 1 Memory Type as SRAM (32 bits width) **/
  C("Configuring the Memory Bank 1 as SRAM with ExtWait Disabled.");
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x0F, 0x05, 0x04, 0x02, 0x03, 0x00000080, 0x00000A,
               0x00000F);
  ConfigureMemory(1, 0x0F, 0x05, 0x04, 0x002, SMCTrMEMBData[1], 0x02,
                  0x03, 0x000000);

  /** Set Bank 3 Memory Type as BROM (32 bits width) **/
  C("Configuring the Memory Bank 3 as 32 bits BROM with ExtWait Disabled.");
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x0F, 0x05, 0x04, 0x02, 0x02, 0x000000B0, 0x00000A,
               0x00000F);
  ConfigureMemory(3, 0x0F, 0x05, 0x04, 0x03A, SMCTrMEMBData[3], 0x02,
                  0x02, 0x000000);

  MemAddr1 = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  TestData = 0xAAAA5555;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  for (i=0; i<4; i++)
    HSW( , TestData++);

  WaitLoop(8);

  /** Re-configuring the WST2 register for SRAM and reads again **/
  C("Testing the WST2 timing for SRAM");
  for (j=0; j<3; j++)
  {
    HSA(SMBWST2R1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[j]);
    HSA(SMCTrWST2_1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[j]);
  
    TestData = 0xAAAA5555;
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , NoMask, ,PerformanceTests_1);
    for (i=0; i<4; i++)
      HSR( , TestData++, , NoMask, ,PerformanceTests_2);
  }

  /** Re-configuring the WST1 register for SRAM and writes again **/
  C("Testing the WST1 timing for SRAM");
  for (j=0; j<3; j++)
  {
    HSA(SMBWST1R1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[j]);
    HSA(SMCTrWST1_1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[j]);

    TestData = TestWrite[j];
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestData++);
    for (i=0; i<4; i++)
      HSW( , TestData++);
  
    TestData = TestWrite[j];
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , NoMask, ,PerformanceTests_3);
    for (i=0; i<4; i++)
      HSR( , TestData++, , NoMask, ,PerformanceTests_4);
  }

  /** Re-configuring the IDCY register **/
  MemAddr2 = SMCMEM_3 + (SMCTrMEMBData[3] << 11);
  TestWrite[0] = 0x44444444;
  TestWrite[1] = 0x55555555;
  TestWrite[2] = 0x66666666;
  C("Testing the IDCY timing");
  for (j=0; j<3; j++)
  {
    HSA(SMBIDCYR1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestIDCY[j]);
    HSA(SMCTrIDCY_1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestIDCY[j]);

    /** Initialise the BROM from the AHB side **/
    HSA(SMCTrMEMR_3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , ~TestWrite[j]);

    TestData = TestWrite[j];
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestData);
    HSA(MemAddr2, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
    HSW( , TestData);
  
    TestData = TestWrite[j];
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , NoMask, ,PerformanceTests_5);
    HSA(MemAddr1+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestData);
  
    /** Verify the written data **/
    HSA(MemAddr1+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData, , NoMask, ,PerformanceTests_6);

    /** IDCY behaviour across the banks **/
    TestData = TestWrite[j];
    HSA(MemAddr2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , ~TestData, , NoMask, ,PerformanceTests_7);
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestData+=5);

    /** Verify the written data **/
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData, , NoMask, ,PerformanceTests_8);

    WaitLoop(1);

  }

  /** Initialise the BROM from the AHB side **/
  TestData = 0x5555AAAA;
  HSA(SMCTrMEMR_3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  for (j=0; j<3; j++)
    HSW( , TestData++);

  /** Re-configuring the WST1 register for BROM and reads again **/
  C("Testing the WST1 timing for BROM");
  for (j=0; j<2; j++)
  {
    HSA(SMBWST1R3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[j]);
    HSA(SMCTrWST1_3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST1[j]);
  
    TestData = 0x5555AAAA;
    HSA(MemAddr2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , NoMask, ,PerformanceTests_9);
    for (i=0; i<3; i++)
      HSR( , TestData++, , NoMask, ,PerformanceTests_10);
  }

  /** Re-configuring the WST2 register for BROM and reads again **/
  C("Testing the WST2 timing for BROM");
  for (j=0; j<2; j++)
  {
    HSA(SMBWST2R3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[j]);
    HSA(SMCTrWST2_3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestWST2[j]);
  
    TestData = 0x5555AAAA;
    HSA(MemAddr2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , NoMask, ,PerformanceTests_11);
    for (i=0; i<3; i++)
      HSR( , TestData++, , NoMask, ,PerformanceTests_12);
  }

  /** Re-configuring the IDCY register **/
  C("Testing the IDCY timing across the banks");
  TestIDCY[0] = 0x0000000E;
  TestIDCY[1] = 0x00000008;
  TestIDCY[2] = 0x00000001;
  TestWrite[0] = 0x11223344;
  TestWrite[1] = 0x55667788;
  TestWrite[2] = 0x99AABBCC;
  for (j=0; j<3; j++)
  {
    HSA(SMBIDCYR1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestIDCY[j]);
    HSA(SMCTrIDCY_1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestIDCY[j]);

    TestData = TestWrite[j];
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestData++);
    HSA(MemAddr2, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
    HSW( , TestData);
  
    /** IDCY behaviour across the banks **/
    TestData = TestWrite[j];
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , NoMask, ,PerformanceTests_13);
    HSA(MemAddr2, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
    HSW( , TestData);
  }

  /** Testing the case where the number of IDLE cycles after a Write        **/
  /** is equal to the WST2 value due to which the next Waited write or read **/
  /** requests comes along the MemWrOver                                    **/

  C("Testing the corner case where Waited Requests comes along with MemWrOver");

  /** Set Bank 1 Memory Type as SRAM (32 bits width) **/
  C("Configuring the Memory Bank 1 as SRAM with ExtWait Disabled.");
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x05, 0x05, 0x02, 0x02, 0x00000080, 0x00000A,
               0x00000F);
  ConfigureMemory(1, 0x02, 0x05, 0x05, 0x002, SMCTrMEMBData[1], 0x02,
                  0x02, 0x000000);

  /** Set Bank 3 Memory Type as BROM (32 bits width) **/
  C("Configuring the Memory Bank 3 as 32 bits BROM with ExtWait Disabled.");
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x02, 0x05, 0x05, 0x02, 0x03, 0x000000B0, 0x00000A,
               0x00000F);
  ConfigureMemory(3, 0x02, 0x05, 0x05, 0x03A, SMCTrMEMBData[3], 0x02,
                  0x03, 0x000000);

  /** Set Bank 5 Memory Type as SRAM (16 bits width) **/
  C("Configuring the Memory Bank 5 as SRAM with ExtWait Disabled.");
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x02, 0x05, 0x05, 0x02, 0x02, 0x00000040, 0x00000A,
               0x00000F);
  ConfigureMemory(5, 0x02, 0x05, 0x05, 0x002, SMCTrMEMBData[5], 0x02,
                  0x02, 0x000000);

  /** Set Bank 7 Memory Type as SRAM (32 bits width) **/
  C("Configuring the Memory Bank 7 as SRAM with ExtWait Disabled.");
  SMCTrMEMBData[7] = 0x00000000;
  ConfigureUUT(7, 0x02, 0x05, 0x05, 0x02, 0x00, 0x00000080, 0x00000A,
               0x00000F);
  ConfigureMemory(7, 0x02, 0x05, 0x05, 0x002, SMCTrMEMBData[7], 0x02,
                  0x00, 0x000000);

  MemAddr3 = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  MemAddr4 = SMCMEM_7 + (SMCTrMEMBData[7] << 11);

  /** The WtdWrReq is aligned with MemWrOver by introducing WaitCycles **/
  /** equal to WST2 value **/

  C("Testing the corner case where WtdWrReq comes along with MemWrOver");
  TestData = 0x22223333;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData);
  for(j=0; j<6; j++)
  {
    HSA(MemAddr1+4, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestData);
  }
  HSA(MemAddr1+4, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , ++TestData);

  HSA(MemAddr1, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , 0x22223333, , NoMask, ,PerformanceTests_14);
  HSA(MemAddr1+4, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , 0x22223334, , NoMask, ,PerformanceTests_15);

  WaitLoop(10);

  TestData = 0x22223333;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(MemAddr1+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , ++TestData);
  HSA(MemAddr3+8, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSW( , ++TestData);

  WaitLoop(10);

  C("Testing the corner case where WtdRdReq comes along with MemWrOver");
  TestData = 0x22223333;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData);
  WaitLoop(6);
  HSA(MemAddr3+8, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , 0x22223335, , HWUnMaskL, ,PerformanceTests_16);

  WaitLoop(10);

  TestData = 0x22223333;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(MemAddr1+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  WaitLoop(10);

  C("Testing the corner case where WtdWrReq comes along with MemWrOver");
  /** Here the Initial Write Request comes during TurnArnd state **/
  /** So we introduce Waitcycles equal to WST2 value and the remaining **/
  /** IDCY values so that the WtdWrReq comes along with MemWrOver **/
  TestData = 0x22223333;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,PerformanceTests_17);
  HSA(MemAddr1+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , ++TestData);
  WaitLoop(21);
  HSA(MemAddr3+4, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSW( , ++TestData);

  HSA(MemAddr3+4, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , 0x22223335, , HWUnMaskL, ,PerformanceTests_18);

  WaitLoop(10);

  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(MemAddr1+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , ++TestData);

  WaitLoop(10);

  C("Testing the corner case where WtdWrReq comes along with MemWrOver");
  TestData = 0x22223333;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData);
  WaitLoop(6);
  HSA(MemAddr4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , ++TestData);

  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x22223333, , NoMask, ,PerformanceTests_19);
  HSA(MemAddr4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x22223334, , NoMask, ,PerformanceTests_20);

  WaitLoop(10);

  /** Configuring WSTWEN value as 1 **/
  ConfigureUUT(5, 0x02, 0x05, 0x05, 0x02, 0x01, 0x00000080, 0x00000A,
               0x00000F);
  ConfigureMemory(5, 0x02, 0x05, 0x05, 0x002, SMCTrMEMBData[5], 0x02,
                  0x01, 0x000000);

  TestData = 0x22223333;
  HSA(MemAddr3, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData);

   /** Configuring WSTWEN value as 2 **/
  ConfigureUUT(5, 0x02, 0x05, 0x05, 0x02, 0x02, 0x00000080, 0x00000A,
               0x00000F);
  ConfigureMemory(5, 0x02, 0x05, 0x05, 0x002, SMCTrMEMBData[5], 0x02,
                  0x02, 0x000000);

  HSA(MemAddr3+4, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /** Configuring WSTWEN equal to WST2 **/
  ConfigureUUT(5, 0x02, 0x05, 0x05, 0x02, 0x05, 0x00000080, 0x00000A,
               0x00000F);
  ConfigureMemory(5, 0x02, 0x05, 0x05, 0x002, SMCTrMEMBData[5], 0x02,
                  0x05, 0x000000);

  HSA(MemAddr3+8, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /** Configuring WSTWEN equal to WST2 **/
  ConfigureUUT(5, 0x02, 0x03, 0x01, 0x01, 0x01, 0x00000080, 0x00000A,
               0x00000F);
  ConfigureMemory(5, 0x02, 0x03, 0x01, 0x002, SMCTrMEMBData[5], 0x01,
                  0x01, 0x000000);

  HSA(MemAddr3+8, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData);

  WaitLoop(10);
}

/************************************ End *************************************/
