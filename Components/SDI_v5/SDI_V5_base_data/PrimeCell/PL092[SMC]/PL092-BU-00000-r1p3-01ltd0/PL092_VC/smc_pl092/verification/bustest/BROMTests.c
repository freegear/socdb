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
--  File Name              : BROMTests.c.rca
--  File Revision          : 1.17
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform tests to check the operation of the SMC with
--           different types of BURST ROMs connected to different banks.
--
-- --=========================================================================*/

/******************************************************************************/
/****************************** BURST ROM Tests *******************************/
/******************************************************************************/

void BROMTests()
{
  /*
     Summary: BURST ROM Tests
     ========================
     This function performs the following:

     o  Programs different banks as BROMs with different parameters
     o  Performs BURST and Non-BURST reads from the memory banks through the
        SMC using different HSIZE and HBURST values
  */

  int i;
  int32 TestData, MemAddr, ReadData, ReadMask;
  int32 TempData1, TempData2, TempData3, TempData4;

  ApplyReset();

  /** Set Bank 1 Memory Type as BROM (32 bits width) **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x03, 0x00, 0x00, 0x00, 0x00, 0x000000B1, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x03, 0x00, 0x00, 0x07A, SMCTrMEMBData[1], 0x00,
                  0x00, 0x000000);

  /** Set Bank 3 Memory Type as ROM (16 bits width) **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x03, 0x07, 0x05, 0x03, 0x00, 0x00000071, 0x000000,
               0x000000);
  ConfigureMemory(3, 0x03, 0x07, 0x05, 0x079, SMCTrMEMBData[3], 0x03,
                  0x00, 0x000000);

  /** Set Bank 5 Memory Type as BROM (8 bits width) **/
  /** ExtWait Enabled **/
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x04, 0x0C, 0x06, 0x04, 0x00, 0x00000034, 0x000001,
               0x000002);
  ConfigureMemory(5, 0x04, 0x0C, 0x06, 0x138, SMCTrMEMBData[5], 0x04,
                  0x00, 0x000000);

  /** Set Bank 7 Memory Type as BROM (32 bits width) **/
  SMCTrMEMBData[7] = 0x00000000;
  ConfigureUUT(7, 0x02, 0x05, 0x02, 0x00, 0x00, 0x000000B1, 0x000000,
               0x000000);
  ConfigureMemory(7, 0x02, 0x05, 0x02, 0x07A, SMCTrMEMBData[7], 0x00,
                  0x00, 0x000000);

  /** Initialise the ROMs from AHB side **/
  AHBWriteMem(1, 0, 16, 0x11111111);
  AHBWriteMem(3, 0, 32, 0x55552222);
  AHBWriteMem(5, 0, 64, 0x66554433);
  AHBWriteMem(7, 0, 16, 0x44444444);

  C("HSIZE = WORD, HBURST = INCR");
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  TestData = 0x11111111;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BROMTests_1);
  for (i=0; i<3; i++)
    HSR( , TestData++, , NoMask, ,BROMTests_2);

  C("HSIZE = HALFWORD, HBURST = INCR4");
  MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11);
  TestData = 0x55552222;
  ReadData = TestData;
  ReadMask = HWUnMaskL;
  HSA(MemAddr, NSEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , ReadMask, ,BROMTests_3);
  for (i=1; i<4; i++)
  {
    ReadMask = HWUnMaskL << 16;
    ReadData = TestData;
    HSR( , ReadData, , ReadMask, ,BROMTests_4);
    TestData = TestData +1;
    ReadMask = HWUnMaskL;
    ReadData = TestData ;
    HSR( , ReadData, , ReadMask, ,BROMTests_4);
  }

  C("HSIZE = BYTE, HBURST = INCR8");
  MemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  TestData = 0x66554433;
  ReadData = TestData;
  ReadMask = BUnMask0;
  HSA(MemAddr, NSEQ, INCR8, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , ReadMask, ,BROMTests_5);
  for (i=1; i<8; i++)
  {
    ReadMask = BUnMask0 << 8;
    HSR( , ReadData, , ReadMask, ,BROMTests_6);
    ReadMask = BUnMask0 << 16;
    HSR( , ReadData, , ReadMask, ,BROMTests_6);
    ReadMask = BUnMask0 << 24;
    HSR( , ReadData, , ReadMask, ,BROMTests_6);
    ReadMask = BUnMask0;
    ReadData = ReadData + 1;
    HSR( , ReadData, , ReadMask, ,BROMTests_6);
  }

  C("HSIZE = WORD, HBURST = INCR16");
  MemAddr = SMCMEM_7 + (SMCTrMEMBData[7] << 11);
  TestData = 0x44444444;
  HSA(MemAddr, NSEQ, INCR16, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BROMTests_7);
  for (i=0; i<15; i++)
    HSR( , TestData++, , NoMask, ,BROMTests_8);

  C("HSIZE = HALFWORD, HBURST = WRAP4");
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + 2;
  TestData = 0x11111111;
  HSA(MemAddr, NSEQ, WRAP4, OK, HWRD, , 0x1, , , , ,);
  HSR( , TestData++ & HWUnMaskB, , HWUnMaskB, ,BROMTests_9);
  HSR( , TestData & HWUnMaskL, , HWUnMaskL, ,BROMTests_10);
  HSR( , TestData & HWUnMaskB, , HWUnMaskB, ,BROMTests_11);
  TestData = 0x11111111;
  HSR( , TestData & HWUnMaskL, , HWUnMaskL, ,BROMTests_12);

  C("HSIZE = BYTE, HBURST = WRAP8");
  MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11) + 1;
  TestData = 0x55552222;
  ReadData = TestData;
  HSA(MemAddr, NSEQ, WRAP8, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , BUnMask1, ,BROMTests_13);
  HSR( , ReadData, , BUnMask2, ,BROMTests_14);
  HSR( , ReadData, , BUnMask3, ,BROMTests_15);

  ReadData = TestData + 1;
  HSR( , ReadData, , BUnMask0, ,BROMTests_16);
  HSR( , ReadData, , BUnMask1, ,BROMTests_17);
  HSR( , ReadData, , BUnMask2, ,BROMTests_18);
  HSR( , ReadData, , BUnMask3, ,BROMTests_19);

  ReadData = TestData;
  HSR( , ReadData, , BUnMask0, ,BROMTests_20);

  C("HSIZE = WORD, HBURST = WRAP16");
  MemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  TestData = 0x66554433;
  ReadData = TestData; 
  HSA(MemAddr, NSEQ, WRAP16, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,BROMTests_21);
  for (i=0; i<15; i++)
  {
    ReadData = ReadData + 1; 
    HSR( , ReadData, , NoMask, ,BROMTests_22);
  }

  C("HSIZE = HALFWORD, HBURST = SINGLE");
  MemAddr = SMCMEM_7 + (SMCTrMEMBData[7] << 11);
  TestData = 0x44444444;
  HSA(MemAddr, NSEQ, SINGLE, OK, HWRD, , 0x1, , , , ,);
  HSR( , TestData & HWUnMaskL, , HWUnMaskL, ,BROMTests_23);

  C("Non-BURST Reads");
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  TestData = 0x11111111;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BROMTests_24);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BROMTests_25);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BROMTests_26);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,BROMTests_27);

  C("Write-Read Tests on the BROMs");
  ROMWriteReadTrick(1, 5, 0, 2, 2, 0xAABBCCDD, 0x11111111);
  ROMWriteReadTrick(1, 6, 0, 2, 2, 0x99887766, 0x11111111);
  ROMWriteReadTrick(3, 6, 0, 1, 1, 0xDDCC, 0x55552222);
  ROMWriteReadTrick(3, 7, 0, 1, 1, 0x3344, 0x55552222);
  ROMWriteReadTrick(5, 7, 0, 0, 0, 0x55, 0x66554433);

  /** Tests Included for code coverage **/

  /** Set Bank 1 Memory Type as BROM (16 bits width) **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00000071, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x03, 0x00, 0x00, 0x07A, SMCTrMEMBData[1], 0x00,
                  0x00, 0x000000);

  C("HSIZE = HALFWORD, HBURST = WRAP4");
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  HSA(MemAddr, NSEQ, WRAP4, OK, HWRD, , 0x1, , , , ,);
  HSR( , 0x00001111, , HWUnMaskL, ,BROMTests_24);
  HSR( , 0x11110000, ,HWUnMaskB, ,BROMTests_25);
  HSR( , 0x00001112, , HWUnMaskL, ,BROMTests_26);
  HSR( , 0x11120000, , HWUnMaskB, ,BROMTests_27);

  WaitLoop(10);

    /** Set Bank 1 Memory Type as BROM (8 bits width) **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00000031, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x03, 0x00, 0x00, 0x07A, SMCTrMEMBData[1], 0x00,
                  0x00, 0x000000);

  C("HSIZE = BYTE, HBURST = WRAP4");
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE, , 0x1, , , , ,);
  HSR( , 0x00000011, ,BUnMask0, ,BROMTests_28);
  HSR( , 0x00001100, ,BUnMask1, ,BROMTests_29);
  HSR( , 0x00110000, ,BUnMask2, ,BROMTests_30);
  HSR( , 0x11000000, ,BUnMask3, ,BROMTests_31);
 
  WaitLoop(10);

  C("HSIZE = BYTE, HBURST = WRAP8");
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  HSA(MemAddr, NSEQ, WRAP8, OK, BYTE, , 0x1, , , , ,);
  HSR( , 0x00000011, ,BUnMask0, ,BROMTests_32);
  HSR( , 0x00001100, ,BUnMask1, ,BROMTests_33);
  HSR( , 0x00110000, ,BUnMask2, ,BROMTests_34);
  HSR( , 0x11000000, ,BUnMask3, ,BROMTests_35);
  HSR( , 0x00000012, ,BUnMask0, ,BROMTests_36);
  HSR( , 0x00001200, ,BUnMask1, ,BROMTests_37);
  HSR( , 0x00120000, ,BUnMask2, ,BROMTests_38);
  HSR( , 0x12000000, ,BUnMask3, ,BROMTests_39);

  WaitLoop(10);

}

/************************************ End *************************************/
