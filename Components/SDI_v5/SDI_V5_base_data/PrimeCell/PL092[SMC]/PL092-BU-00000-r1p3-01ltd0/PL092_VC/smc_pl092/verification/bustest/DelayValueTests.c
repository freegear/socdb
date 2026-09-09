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
--  File Name              : DelayValueTests.c.rca
--  File Revision          : 1.17
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Chip Select to Output Enable assertion and
--           Chip Select to Write Enable assertion Tests on the SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/****************** CS to OEN and CS to WEN assertion Tests *******************/
/******************************************************************************/

void DelayValueTests()
{
  /*
     Summary: CS to OEN and CS to WEN assertion Tests
     ================================================
     This function performs the following:

     o  Programs CS2OEN and CS2WEN registers of Memory banks with different
        values
     o  Does all combinations of BURST reads, Non-BURST reads and writes as
        mentioned below:
        - Read followed by BURST reads to same and different banks
        - Read followed by writes to same and different banks
        - BURST read followed by reads to same and different banks
        - BURST read followed by writes to same and different banks
        - Write followed by reads to same and different banks
        - Write followed by BURST reads to same and different banks
  */

  int i, j, k;
  int32 TestCS2OEN[4] = {0x00, 0x05, 0x09, 0x0B};
  int32 TestCS2WEN[4] = {0x00, 0x05, 0x09, 0x0B};
  int32 TestRead, TestWrite, MemAddr, TestData;

  C("Configuring the Memory Banks and the SMC");
  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[0] = 0x00007FFF;
  ConfigureUUT(0, 0x02, 0x0F, 0x0F, 0x02, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x02, 0x0F, 0x0F, 0x042, SMCTrMEMBData[0], 0x02,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (16 bits width) **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x0F, 0x0F, 0x02, 0x00, 0x00000041, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x02, 0x0F, 0x0F, 0x041, SMCTrMEMBData[1], 0x02,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as SRAM (8 bits width) **/
  SMCTrMEMBData[2] = 0x00007FFF;
  ConfigureUUT(2, 0x02, 0x0C, 0x0C, 0x02, 0x00, 0x00000000, 0x000000,
               0x000000);
  ConfigureMemory(2, 0x02, 0x0C, 0x0C, 0x000, SMCTrMEMBData[2], 0x02,
                  0x00, 0x000000);

  /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x02, 0x0F, 0x0F, 0x02, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(3, 0x02, 0x0F, 0x0F, 0x042, SMCTrMEMBData[3], 0x02,
                  0x00, 0x000000);

  TestRead = 0x00111111;
  TestWrite = 0x00222222;
  for (i=0; i<4; i++)
  {
    C("Reconfiguring the CS2OEN Register");
    HSA(SMBWSTOENR0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[i]);
    HSA(SMCTrCS2OEN_0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[i]);

    k = (i+1)%4;
    HSA(SMBWSTOENR1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);
    HSA(SMCTrCS2OEN_1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);

    k = (i+2)%4;
    HSA(SMBWSTOENR2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);
    HSA(SMCTrCS2OEN_2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);

    k = (i+3)%4;
    HSA(SMBWSTOENR3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);
    HSA(SMCTrCS2OEN_3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , TestCS2OEN[k]);

    for (j=0; j<4; j++)
    {
      C("Reconfiguring the CS2OEN Register");
      HSA(SMBWSTWENR0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestCS2OEN[j]);
      HSA(SMCTrCS2WEN_0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestCS2WEN[j]);
  
      k = (j+1)%4;
      HSA(SMBWSTWENR1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestCS2WEN[k]);
      HSA(SMCTrCS2WEN_1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestCS2WEN[k]);
  
      k = (j+2)%4;
      HSA(SMBWSTWENR2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestCS2WEN[k]);
      HSA(SMCTrCS2WEN_2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestCS2WEN[k]);
  
      k = (j+3)%4;
      HSA(SMBWSTWENR3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestCS2WEN[k]);
      HSA(SMCTrCS2WEN_3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestCS2WEN[k]);

      /** Does BURST Transfers **/
      C("BURST Writes followed by BURST reads to the same bank");
      AHBWriteMem(0, 0x7E0, 8, TestRead);
      TestData = TestWrite;
      MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 0x7C0;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
      for (k=0; k<7; k++)
        HSW( , TestData++);

      TestData = TestRead;
      HSA(0x000007E0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_1);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_2);

      C("BURST Reads followed by BURST Writes to the same bank");
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_3);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_4);

      TestWrite+= 0x00111111;
      TestData = TestWrite;
      MemAddr+= 32;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
      for (k=0; k<7; k++)
        HSW( , TestData++);

      C("BURST Reads followed by BURST Writes to different banks");
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_5);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_6);

      TestWrite+= 0x00111111;
      TestData = TestWrite;
      HSA(MemAddr+32, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
      for (k=0; k<7; k++)
        HSW( , TestData++);

      C("BURST Writes followed by BURST Reads to different banks");
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
      for (k=0; k<7; k++)
        HSW( , TestData++);

      TestData = TestWrite;
      HSA(MemAddr+32, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_7);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_8);

      /** Verify the previously written data **/
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_9);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_10);

      C("BURST Writes followed by BURST Writes to the same bank");
      MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 0x7C0;
      TestWrite+= 0x00111111;
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
      for (k=0; k<7; k++)
        HSW( , TestData++);

      HSA(MemAddr+32, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
      for (k=0; k<7; k++)
        HSW( , TestData++);

      C("BURST Reads followed by BURST Reads to the same bank");
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_11);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_12);

      HSA(MemAddr+32, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_13);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_14);

      C("BURST Writes followed by BURST Writes to different banks");
      MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 0x7E0;
      TestWrite+= 0x00111111;
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
      for (k=0; k<7; k++)
        HSW( , TestData++);

      HSA(MemAddr+32, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
      for (k=0; k<7; k++)
        HSW( , TestData++);

      C("BURST Reads followed by BURST Reads to different banks");
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_15);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_16);

      HSA(MemAddr+32, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_17);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_18);

      /** Does Non-BURST Transfers **/
      C("Write followed by Read to the same bank");
      AHBWriteMem(2, 16, 4, TestRead);
      MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestWrite);

      C("Read followed by Write to the same bank");
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , NoMask, ,DelayValueTests_20);

      TestWrite+= 0x00111111;
      MemAddr+= 4;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestWrite);

      C("Read followed by Write to different banks");
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , NoMask, ,DelayValueTests_21);

      MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , ~TestWrite);

      C("Write followed by Read to different banks");
      MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestWrite);

      MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , ~TestWrite, , NoMask, ,DelayValueTests_22);

      /** Verify the previously written data **/
      MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , NoMask, ,DelayValueTests_24);

      C("Write followed by Write to the same bank");
      MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11);
      TestWrite+= 0x00111111;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestWrite);

      HSA(MemAddr+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , ~TestWrite);

      C("Read followed by Read to the same bank");
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , NoMask, ,DelayValueTests_25);

      HSA(MemAddr+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , ~TestWrite, , NoMask, ,DelayValueTests_26);

      C("Write followed by Write to different banks");
      MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11);
      TestWrite+= 0x00111111;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestWrite);

      MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , ~TestWrite);

      C("Read followed by Read to different banks");
      MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , NoMask, ,DelayValueTests_27);

      MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , ~TestWrite, , NoMask, ,DelayValueTests_28);
    }
  }
}

/************************************ End *************************************/
