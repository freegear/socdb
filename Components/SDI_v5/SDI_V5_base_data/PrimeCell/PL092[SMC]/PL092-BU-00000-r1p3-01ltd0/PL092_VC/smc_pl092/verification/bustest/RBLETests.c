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
--  File Name              : RBLETests.c.rca
--  File Revision          : 1.17
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform tests on RBLE functionality of the SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/********************************* RBLE Tests *********************************/
/******************************************************************************/

void RBLETests()
{
  /*
     Summary: RBLE Tests
     ===================
     This function performs the following:

     o  Configures alternate banks with RBLE value '1'
     o  Tries various BURST accesses which cross banks
     o  The transfers are listed below:
        -------------------------------------------------------------------
        Current transfer with RBLE status   Next transfer with RBLE status
        -------------------------------------------------------------------
        RBLE enabled read transfer          RBLE disabled write transfer to
                                            different bank
        RBLE enabled write transfer         RBLE disabled read transfer to
                                            different bank
        RBLE enabled read transfer          RBLE disabled read transfer to
                                            different bank
        RBLE enabled write transfer         RBLE disabled write transfer to
                                            different bank
        RBLE disabled read transfer         RBLE enabled write transfer to
                                            different bank
        RBLE disabled read transfer         RBLE enabled read transfer to
                                            different bank
        RBLE disabled write transfer        RBLE enabled read transfer to
                                            different bank
        RBLE disabled write transfer        RBLE enabled write transfer to
                                            different bank
        RBLE enabled write transfer         RBLE enabled read transfer to
                                            same bank
        RBLE enabled read transfer          RBLE enabled write transfer to
                                            same bank
        RBLE disabled write transfer        RBLE disabled read transfer to
                                            same bank
        RBLE disabled read transfer         RBLE disabled write transfer to
                                            same bank
        -------------------------------------------------------------------
  */

  int i, BankNo;
  int32 MemAddr, TestData, ReadData1, ReadData2, ReadData3, ReadData4;
  int32 ReadData, ReadMask, Address;
  int WST1, WST2, Burst,WriteData,HSIZE,MSIZE;
  int msize, testprot;
  char *sizetype[] = {"BYTE", "HWRD","WRD"};
  unsigned long  Data,LoBits,Bound;
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int32 Offset;

  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[0] = 0x00001;
  ConfigureUUT(0, 0x02, 0x05, 0x04, 0x02, 0x02, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x02, 0x05, 0x04, 0x042, SMCTrMEMBData[0], 0x02,
                  0x02, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (8 bits width) **/
  /** RBLE Disabled, ExtWait Disabled **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x06, 0x05, 0x02, 0x02, 0x00000000, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x02, 0x06, 0x05, 0x000, SMCTrMEMBData[1], 0x02,
                  0x02, 0x000000);

  /** Set Bank 2 Memory Type as SRAM (16 bits width) **/
  SMCTrMEMBData[2] = 0x00001;
  /** RBLE Enabled, ExtWait Enabled **/
  ConfigureUUT(2, 0x03, 0x08, 0x07, 0x02, 0x03, 0x00000045, 0x000003,
               0x000006);
  ConfigureMemory(2, 0x03, 0x08, 0x07, 0x141, SMCTrMEMBData[2], 0x02,
                  0x03, 0x000000);

  /** Set Bank 3 Memory Type as SRAM (8 bits width) **/
  /** RBLE Disabled, ExtWait Enabled **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x05, 0x0A, 0x07, 0x03, 0x03, 0x00000004, 0x000004,
               0x000008);
  ConfigureMemory(3, 0x05, 0x0A, 0x07, 0x100, SMCTrMEMBData[3], 0x03,
                  0x03, 0x000000);

  /** Set Bank 4 Memory Type as SRAM (16 bits width) **/
  SMCTrMEMBData[4] = 0x00001;
  /** RBLE Enabled, ExtWait Enabled **/
  ConfigureUUT(4, 0x06, 0x0A, 0x0A, 0x04, 0x03, 0x00000045, 0x000002,
               0x000006);
  ConfigureMemory(4, 0x06, 0x0A, 0x0A, 0x541, SMCTrMEMBData[4], 0x04,
                  0x03, 0x000000);

  /** Set Bank 5 Memory Type as ROM (8 bits width) **/
  /** RBLE Disabled, ExtWait Enabled **/
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x03, 0x07, 0x07, 0x03, 0x03, 0x00000014, 0x000003,
               0x000005);
  ConfigureMemory(5, 0x03, 0x07, 0x07, 0x504, SMCTrMEMBData[5], 0x03,
                  0x03, 0x000000);

  /** Set Bank 6 Memory Type as BROM (32 bits width) **/
  SMCTrMEMBData[6] = 0x00001;
  /** RBLE Enabled, ExtWait Disabled **/
  ConfigureUUT(6, 0x04, 0x06, 0x03, 0x01, 0x01, 0x000000B1, 0x000000,
               0x000000);
  ConfigureMemory(6, 0x04, 0x06, 0x03, 0x07A, SMCTrMEMBData[6], 0x01,
                  0x01, 0x000000);

  /** Set Bank 7 Memory Type as BROM (8 bits width) **/
  /** RBLE Disabled, ExtWait Disabled **/
  SMCTrMEMBData[7] = 0x00000000;
  ConfigureUUT(7, 0x02, 0x0B, 0x09, 0x05, 0x06, 0x00000030, 0x000000,
               0x000000);
  ConfigureMemory(7, 0x02, 0x0B, 0x09, 0x008, SMCTrMEMBData[7], 0x05,
                  0x06, 0x000000);

  /** Initialise the ROMs from AHB side **/
  AHBWriteMem(5, 0, 64, 0x0000007F);
  AHBWriteMem(6, 0, 16, 0x98ABCDEF);
  AHBWriteMem(7, 0, 64, 0x000000AB);

  /** RBLE enabled Writes followed by RBLE disabled Writes to different Bank **/
  C("RBLE enabled write followed by RBLE disabled write to different bank");
  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 0x1DC;
  TestData = 0x10101010;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  for (i=0; i<15; i++)
    HSW( , TestData++);

  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + 0xFC;
  TestData = 0x20202020; 
  HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /** Verify the written data **/
  C("RBLE enabled read followed by RBLE disabled read to different bank");
  TestData = 0x10101010;
  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 0x1DC;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_1);
  for (i=0; i<15; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_2);

  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + 0xFC;
  TestData = 0x20202020;
  HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,RBLETests_1);

  C("RBLE enabled read followed by RBLE disabled write to different bank");
  TestData = 0x10101010;
  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 0x1DC;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_3);
  for (i=0; i<8; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_4);

  TestData = 0x10101010;
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  for (i=0; i<6; i++)
    HSW( , TestData++);

  C("RBLE enabled write followed by RBLE disabled read to different bank");
  MemAddr = SMCMEM_4 + (SMCTrMEMBData[4] << 11) + 0x1DC;
  TestData = 0xA5A5A5A5;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  for (i=0; i<8; i++)
    HSW( , TestData++);

  ReadData = 0x0000007F;
  MemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,RBLETests_5);
  for (i=0; i<8; i++)
  {
    HSR( , ReadData++, , NoMask, ,RBLETests_6);
  }

  C("RBLE enabled write followed by RBLE enabled read to the same bank");
  /** Does the RBLE enabled write **/
  MemAddr = SMCMEM_4 + (SMCTrMEMBData[4] << 11) + 0x1BC;
  TestData = 0x12121212;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  for (i=0; i<7; i++)
    HSW( , TestData++);

  /** Verifying the data written to the bank 5 in the previous case and **/
  /** does the RBLE enabled read to the same bank **/
  MemAddr = MemAddr + 8*4;
  TestData = 0xA5A5A5A5;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_7);
  for (i=0; i<8; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_8);

  C("RBLE enabled read followed by RBLE enabled write to the same bank");
  /** Verifying the written data **/
  MemAddr = SMCMEM_4 + (SMCTrMEMBData[4] << 11) + 0x1BC;
  TestData = 0x12121212;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_9);
  for (i=0; i<7; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_10);

  /** Does the RBLE enabled write to the same bank **/
  MemAddr = MemAddr + 8*4;
  TestData = 0x5A5A5A5A;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  for (i=0; i<8; i++)
    HSW( , TestData++);

  /** Verifying the written data **/
  TestData = 0x5A5A5A5A;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_11);
  for (i=0; i<8; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_12);

  C("RBLE disabled read followed by RBLE disabled write to same bank");
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  TestData = 0x10101010;
  /** Does the RBLE disabled read **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_13);
  for (i=0; i<6; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_14);

  /** does the RBLE disabled write to the same bank **/
  MemAddr = MemAddr + 7*4;
  TestData = 0x44332211;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  for (i=0; i<8; i++)
    HSW( , TestData++);

  /** Verifying the written data **/
  TestData = 0x44332211;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_15);
  for (i=0; i<8; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_16);

  C("RBLE disabled write followed by RBLE disabled read to same bank");
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  TestData = 0x87654321;
  /** does the RBLE disabled write **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  for (i=0; i<6; i++)
    HSW( , TestData++);

  /** Does the RBLE disabled read **/
  MemAddr = MemAddr + 7*4;
  TestData = 0x44332211;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_17);
  for (i=0; i<8; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_18);

  /** Verifying the written data **/
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  TestData = 0x87654321;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_19);
  for (i=0; i<6; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_20);

  /** Changing the base address of the bank 5 **/
  SMCTrMEMBData[5] = 0x00001;
  HSA(SMCTrMEMB_5, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , SMCTrMEMBData[5]);

  /** Initialise the ROM from the AHB side **/
  AHBWriteMem(5, 0x800, 8, 0x00000055);

  /** Changing the base address of the bank 6 **/
  SMCTrMEMBData[6] = 0x00000000;
  HSA(SMCTrMEMB_6, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , SMCTrMEMBData[6]);

  C("RBLE disabled read followed by RBLE enabled read to different bank");
  MemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  TestData = 0x00000055;
  /** Does RBLE disabled read **/
  ReadData = TestData; 
  ReadMask = NoMask;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , ReadMask, ,RBLETests_21);
  for (i=1, TestData++; i<7; i++, TestData++)
  {
    HSR( , ReadData++, , NoMask, ,RBLETests_22);
  }

  MemAddr = SMCMEM_6 + (SMCTrMEMBData[6] << 11);
  TestData = 0x98ABCDEF;
  ReadMask = BUnMask0;
  ReadData = TestData & ReadMask;
  /** Does RBLE enabled read from the different bank **/
  HSA(MemAddr, NSEQ, INCR, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , ReadMask, ,RBLETests_23);
  for (i=1; i<8; i++, TestData+= i/4)
  {
    ReadMask = (BUnMask0 << (i%4)*8);
    ReadData = TestData & ReadMask;
    HSR( , ReadData, , ReadMask, ,RBLETests_24);
  }

  /** Changing the base address of the bank 1 **/
  SMCTrMEMBData[1] = 0x00001;
  HSA(SMCTrMEMB_1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , SMCTrMEMBData[1]);

  /** Changing the base address of the bank 2 **/
  SMCTrMEMBData[2] = 0x00000000;
  HSA(SMCTrMEMB_2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , SMCTrMEMBData[2]);

  C("RBLE disabled write followed by RBLE enabled write to different bank");
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + 0x1E0;
  TestData = 0x11223344;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  for (i=0; i<15; i++)
    HSW( , TestData++);

  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 0xDC;
  TestData = 0xAAAAAAAA;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  for (i=0; i<15; i++)
    HSW( , TestData++);

  /** Verifying the written data **/
  TestData = 0x11223344;
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + 0x1E0;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_25);
  for (i=0; i<15; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_26);

  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 0xDC;
  TestData = 0xAAAAAAAA;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_25);
  for (i=0; i<15; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_26);

  C("RBLE disabled write followed by RBLE enabled read to different bank");
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + 0x1E0;
  TestData = 0x66778899;
  /** Does RBLE disabled write **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  for (i=0; i<7; i++)
    HSW( , TestData++);

  MemAddr+= 8*4;
  TestData = 0x11223344 + 8;
  /** Does RBLE enabled read **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_27);
  for (i=0; i<7; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_28);

  C("RBLE disabled read followed by RBLE enabled write to different bank");
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + 0x1E0;
  TestData = 0x66778899;
  /** Does RBLE disabled read **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_29);
  for (i=0; i<7; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_30);

  MemAddr+= 8*4;
  TestData = 0xABCDEF01;
  /** Does RBLE enabled write **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  for (i=0; i<7; i++)
    HSW( , TestData++);

  /** Verifying the written data **/
  TestData = 0xABCDEF01;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_31);
  for (i=0; i<7; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_32);

/*
2. WST1 & WST2 > 0, WSTOEN=WSTWEN=0
*/
  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[0] = 0x00001;
  ConfigureUUT(0, 0x02, 0x0A, 0x0A, 0x00, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x02, 0x0A, 0x0A, 0x042, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (8 bits width) **/
  /** RBLE Disabled, ExtWait Disabled **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x0A, 0x0A, 0x00, 0x00, 0x00000000, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x02, 0x0A, 0x0A, 0x000, SMCTrMEMBData[1], 0x00,
                  0x00, 0x000000);

  for (HSIZE = 0; HSIZE < 3; HSIZE++)
   {
  /** RBLE enabled Writes followed by RBLE disabled Writes to different Bank **/
  C("RBLE enabled write followed by RBLE disabled write to different bank");
  /* Offset = (SMCTrMEMBData[0] << 11); */
  Offset = 0;
  WriteData = 0x10101010;
  MSIZE = 2;
  BankNo = 0;
  Burst = 1;
  testprot = 0;
  BurstWrite(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, WriteData);


  Offset = 0;
  WriteData = 0x87654321;
  MSIZE = 0;
  BankNo = 1;
  Burst = 1;
  testprot = 0;
  BurstWrite(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, WriteData);

   /* Reading back the written data */
 C("RBLE enabled read followed by RBLE disabled read to different bank");
 Offset = 0;
 TestData = 0x10101010;
   MSIZE = 2;
  BankNo = 0;
  Burst = 1;
  testprot = 0;
BurstRead(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, TestData);


/** does the RBLE disabled read **/
 Offset = 0;
 TestData = 0x87654321;
   MSIZE = 0;
  BankNo = 1;
  Burst = 1;
  testprot = 0;
BurstRead(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, TestData);


  WaitLoop(2);
  }

/*
1. WST1, WST2, WSTOEN, WSTWEN values as in error_wracc.vcd of customer
*/
  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[0] = 0x00001;
  ConfigureUUT(0, 0x02, 0x0A, 0x0A, 0x08, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x02, 0x0A, 0x0A, 0x042, SMCTrMEMBData[0], 0x08,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (8 bits width) **/
  /** RBLE Disabled, ExtWait Disabled **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x0A, 0x0A, 0x03, 0x08, 0x00000000, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x02, 0x0A, 0x0A, 0x000, SMCTrMEMBData[1], 0x03,
                  0x08, 0x000000);

  /** RBLE enabled Writes followed by RBLE disabled Writes to different Bank **/
  C("RBLE enabled write followed by RBLE disabled write to different bank");

    for (HSIZE = 0; HSIZE < 3; HSIZE++)
   {
  /** RBLE enabled Writes followed by RBLE disabled Writes to different Bank **/
  C("RBLE enabled write followed by RBLE disabled write to different bank");
  Offset = 0;
  WriteData = 0x10101010;
  MSIZE = 2;
  BankNo = 0;
  Burst = 1;
  testprot = 0;
  BurstWrite(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, WriteData);


  Offset = 0;
  WriteData = 0x87654321;
  MSIZE = 0;
  BankNo = 1;
  Burst = 1;
  testprot = 0;
  BurstWrite(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, WriteData);

   /* Reading back the written data */
 C("RBLE enabled read followed by RBLE disabled read to different bank");
 Offset = 0;
 TestData = 0x10101010;
   MSIZE = 2;
  BankNo = 0;
  Burst = 1;
  testprot = 0;
BurstRead(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, TestData);


/** does the RBLE disabled read **/
 Offset = 0;
 TestData = 0x87654321;
   MSIZE = 0;
  BankNo = 1;
  Burst = 1;
  testprot = 0;
BurstRead(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, TestData);


  WaitLoop(2);
  }

/*
3. WST1=WST2=0, WSTOEN=WSTWEN=0
*/
  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[0] = 0x00001;
  ConfigureUUT(0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x00, 0x00, 0x00, 0x042, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (8 bits width) **/
  /** RBLE Disabled, ExtWait Disabled **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00000000, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x00, 0x00, 0x00, 0x000, SMCTrMEMBData[1], 0x00,
                  0x00, 0x000000);

   for (HSIZE = 0; HSIZE < 3; HSIZE++)
   {
  /** RBLE enabled Writes followed by RBLE disabled Writes to different Bank **/
  C("RBLE enabled write followed by RBLE disabled write to different bank");
  Offset = 0;
  WriteData = 0x10101010;
  MSIZE = 2;
  BankNo = 0;
  Burst = 1;
  testprot = 0;
  BurstWrite(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, WriteData);


  Offset = 0;
  WriteData = 0x87654321;
  MSIZE = 0;
  BankNo = 1;
  Burst = 1;
  testprot = 0;
  BurstWrite(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, WriteData);

   /* Reading back the written data */
 C("RBLE enabled read followed by RBLE disabled read to different bank");
 Offset = 0;
 TestData = 0x10101010;
  MSIZE = 2;
  BankNo = 0;
  Burst = 1;
  testprot = 0;
  BurstRead(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, TestData);


/** does the RBLE disabled read **/
 Offset = 0;
 TestData = 0x87654321;
   MSIZE = 0;
  BankNo = 1;
  Burst = 1;
  testprot = 0;
BurstRead(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, TestData);


  WaitLoop(2);

 }

for (WST1 = 0; WST1 < 4; WST1++ )
  {
    for (WST2 = 16; WST2 < 32; WST2 = WST2 + 15)
    {
   /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[0] = 0x00001;
  ConfigureUUT(0, 0x00, WST1, WST2, 0x00, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x00, WST1, WST2, 0x042, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (8 bits width) **/
  /** RBLE Disabled, ExtWait Disabled **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x00, WST1, WST2, 0x00, 0x00, 0x00000000, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x00, WST1, WST2, 0x000, SMCTrMEMBData[1], 0x00,
                  0x00, 0x000000);

   for (HSIZE = 0; HSIZE < 3; HSIZE++)
   {
  /** RBLE enabled Writes followed by RBLE disabled Writes to different Bank **/
  C("RBLE enabled write followed by RBLE disabled write to different bank");
  Offset = 0;
  WriteData = 0x10101010;
  MSIZE = 2;
  BankNo = 0;
  Burst = 1;
  testprot = 0;
  BurstWrite(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, WriteData);


  Offset = 0;
  WriteData = 0x87654321;
  MSIZE = 0;
  BankNo = 1;
  Burst = 1;
  testprot = 0;
  BurstWrite(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, WriteData);

   /* Reading back the written data */
 C("RBLE enabled read followed by RBLE disabled read to different bank");
 Offset = 0;
 TestData = 0x10101010;
   MSIZE = 2;
  BankNo = 0;
  Burst = 1;
  testprot = 0;
BurstRead(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, TestData);


/** does the RBLE disabled read **/
 Offset = 0;
 TestData = 0x87654321;
   MSIZE = 0;
  BankNo = 1;
  Burst = 1;
  testprot = 0;
BurstRead(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, TestData);


  WaitLoop(2);

   }
  }
 }

for (WST1 = 6; WST1 < 9; WST1++ )
  {
    for (WST2 = 2; WST2 < 5; WST2++)
    {
   /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[0] = 0x00001;
  ConfigureUUT(0, 0x00, WST1, WST2, 0x02, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x00, WST1, WST2, 0x042, SMCTrMEMBData[0], 0x02,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (8 bits width) **/
  /** RBLE Disabled, ExtWait Disabled **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x00, WST1, WST2, 0x03, 0x01, 0x00000000, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x00, WST1, WST2, 0x000, SMCTrMEMBData[1], 0x03,
                  0x01, 0x000000);

   for (HSIZE = 0; HSIZE < 3; HSIZE++)
   {
  /** RBLE enabled Writes followed by RBLE disabled Writes to different Bank **/
  C("RBLE enabled write followed by RBLE disabled write to different bank");
  Offset = 0;
  WriteData = 0x10101010;
  MSIZE = 2;
  BankNo = 0;
  Burst = 1;
  testprot = 0;
  BurstWrite(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, WriteData);


  Offset = 0;
  WriteData = 0x87654321;
  MSIZE = 0;
  BankNo = 1;
  Burst = 1;
  testprot = 0;
  BurstWrite(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, WriteData);

   /* Reading back the written data */
 C("RBLE enabled read followed by RBLE disabled read to different bank");
 Offset = 0;
 TestData = 0x10101010;
   MSIZE = 2;
  BankNo = 0;
  Burst = 1;
  testprot = 0;
BurstRead(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, TestData);


/** does the RBLE disabled read **/
 Offset = 0;
 TestData = 0x87654321;
   MSIZE = 0;
  BankNo = 1;
  Burst = 1;
  testprot = 0;
BurstRead(BankNo, Burst, Offset , HSIZE, MSIZE, testprot, TestData);


  WaitLoop(2);

   }
  }
 }

    /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[0] = 0x00001;
  ConfigureUUT(0, 0x01, 0x02, 0x05, 0x00, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x01, 0x02, 0x05, 0x042, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);

  C(" INCR Write with HSIZE=16, MSIZE=32 and RBLE=1");
  Address = SMCMEM_0 + (SMCTrMEMBData[0] << 11);
  HSA(Address, NSEQ, INCR, , HWRD, , 0x1, , , , ,);
  HSW( , 0x11223344);
  HSW( , 0x00001122);

  /*  Read back the written data */
  C("Read back the written data");
  Address = SMCMEM_0 + (SMCTrMEMBData[0] << 11);
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , 0xFFFFFFFF, ,TransferTests_34);

  HSA(Address+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , 0xFFFFFFFF, ,TransferTests_34);

  HSA(Address+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , 0xFFFFFFFF, ,TransferTests_34);

  HSA(Address+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , 0xFFFFFFFF, ,TransferTests_34);

  HSA(Address+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , 0xFFFFFFFF, ,TransferTests_34);

  HSA(Address+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , 0xFFFFFFFF, ,TransferTests_34);

  HSA(Address+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , 0xFFFFFFFF, ,TransferTests_34);

  HSA(Address+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , 0xFFFFFFFF, ,TransferTests_34);

  HSA(Address+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , 0xFFFFFFFF, ,TransferTests_34);

  HSA(Address+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , 0xFFFFFFFF, ,TransferTests_34);

  HSA(Address+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , 0xFFFFFFFF, ,TransferTests_34);

    /* test case for Problem description for error_wracc_mbls */
 /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[0] = 0x00001;
  ConfigureUUT(0, 0x01, 0x02, 0x09, 0x00, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x01, 0x02, 0x09, 0x042, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);

  C(" INCR Write with HSIZE=16, MSIZE=32 and RBLE=1");
  Address = SMCMEM_0 + (SMCTrMEMBData[0] << 11);
  HSA(Address, NSEQ, INCR, , HWRD, , 0x1, , , , ,);
  HSW( , 0x88776655);
  HSW( , 0x00008877);

/*  Read back the written data */
  C("Read back the written data");
  Address = SMCMEM_0 + (SMCTrMEMBData[0] << 11);
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x88776655, , 0xFFFFFFFF, ,TransferTests_34);

/*
1. WST1, WST2, WSTOEN, WSTWEN values as in error_wracc.vcd of customer
*/
  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[0] = 0x00001;
  ConfigureUUT(0, 0x02, 0x09, 0x15, 0x06, 0x0D, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x02, 0x09, 0x15, 0x042, SMCTrMEMBData[0], 0x06,
                  0x0D, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (8 bits width) **/
  /** RBLE Disabled, ExtWait Disabled **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x03, 0x0E, 0x00, 0x06, 0x00000080, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x02, 0x03, 0x0E, 0x002, SMCTrMEMBData[1], 0x00,
                  0x06, 0x000000);

    /** Set Bank 2 Memory Type as SRAM (32 bits width) **/
  /** RBLE Disabled, ExtWait Disabled **/
  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x00, 0x09, 0x15, 0x06, 0x0D, 0x00000080, 0x000000,
               0x000000);
  ConfigureMemory(2, 0x02, 0x09, 0x15, 0x042, SMCTrMEMBData[2], 0x06,
                  0x0D, 0x000000);

      /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  /** RBLE Disabled, ExtWait Disabled **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x00, 0x03, 0x0E, 0x00, 0x06, 0x00000000, 0x000000,
               0x000000);
  ConfigureMemory(3, 0x02, 0x03, 0x0E, 0x000, SMCTrMEMBData[1], 0x00,
                  0x06, 0x000000);
 /** RBLE enabled Writes followed by RBLE disabled Writes to different Bank **/
  C("RBLE enabled write followed by RBLE disabled write to different bank");

  /** RBLE enabled Writes followed by RBLE disabled Writes to different Bank **/
  C("RBLE enabled write followed by RBLE disabled write to different bank");
  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11);
  WriteData = 0x10101010;
  HSIZE = 0;
  MSIZE = 2;
  BankNo = 0;
  Burst = 1;
  testprot = 0;

  HSA(MemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , WriteData);

  WaitLoop(23);

  Offset = 0;
  WriteData = 0x87654321;
  HSIZE = 1;
  MSIZE = 2;
  BankNo = 1;
  Burst = 1;
  testprot = 0;
  BurstWrite(BankNo, 1, Offset , HSIZE, MSIZE, testprot, WriteData);

  WaitLoop(3);

  MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 12);
  WriteData = 0x11CCDD33;

  HSA(MemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , WriteData);

  WaitLoop(23);

   Offset = 0;
  WriteData = 0xBBCCDDEE;
  HSIZE = 2;
  MSIZE = 0;
  BankNo = 1;
  Burst = 1;
  testprot = 0;
  BurstWrite(BankNo, 1, Offset , HSIZE, MSIZE, testprot, WriteData);


}

/************************************ End *************************************/
