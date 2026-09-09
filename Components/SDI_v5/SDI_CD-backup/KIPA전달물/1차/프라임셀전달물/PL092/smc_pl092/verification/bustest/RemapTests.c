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
--  File Name              : RemapTests.c.rca
--  File Revision          : 1.10
--
--  Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform REMAP and SMMWCS7 tests on the SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/************************** REMAP and SMMWCS7 Tests ***************************/
/******************************************************************************/

void RemapTests()
{
  /*
     Summary: REMAP and SMMWCS7 Tests
     ================================
     This function performs the following:

     o  REMAP is set to '0' at Reset to check the functioning of the SMC
     o  Checks its effect on other Chip Selects
     o  REMAP is set to '1' to operate the SMC in normal mode
     o  SMMWCS7 is varied for all possible combinations and checked for its
        functionality
     o  Initial values are loaded into the REMAP and SMMWCS7 after reset and
        then reset is applied again. So at the second Reset, REMAP and SMMWCS7
        have stable values.
  */

  int i, SMMWCS;
  int32 MemAddr, TestData, TestWrite, TempData, ReadMask, MEMTData;
  int Shift[3] = {8, 16, 32};
  char string[35];
  char size[3] = {'b', 'h', 'w'};
  char* SizeString[3] = {"BYTE", "HALFWORD", "WORD"};
  int32 Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};

  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  C("Configuring the SMC and the Memory Blocks");
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x0F, 0x1F, 0x1F, 0x0F, 0x0F, 0x00000080, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x0F, 0x1F, 0x1F, 0x002, SMCTrMEMBData[0], 0x0F,
                  0x0F, 0x000000);

  /** Set Bank 7 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[7] = 0x00000000;
  ConfigureUUT(7, 0x0F, 0x1F, 0x1F, 0x0F, 0x0F, 0x00000000, 0x000000,
               0x000000);
  ConfigureMemory(7, 0x0F, 0x1F, 0x1F, 0x000, SMCTrMEMBData[7], 0x0F,
                  0x0F, 0x000000);

  TestWrite = 0x77777777;

  for (SMMWCS = 0; SMMWCS < 3; SMMWCS++)
  {
    /** Configure SMMWCS7 input **/
    sprintf(string, "SMMWCS7 is configured as %s", SizeString[SMMWCS]);
    C(string);
    HSA(SMCTrMWCS, NSEQ, INCR, , WRD, , 0x1, , , , ,);
    HSW( , SMMWCS);
    /** Clear the REMAP input **/
    C("Clearing REMAP input");
    HSA(SMCTrREMAP, NSEQ, INCR, , WRD, , 0x1, , , , ,);
    HSW( , 0x0);

    HSA(SMCTrREMAP, IDLE, INCR, , WRD, , 0x1, , , , ,);
    HSW( , 0x0);
    HSA(SMCTrREMAP, IDLE, INCR, , WRD, , 0x1, , , , ,);
    HSW( , 0x0);
    HSA(SMCTrREMAP, IDLE, INCR, , WRD, , 0x1, , , , ,);
    HSW( , 0x0);

    /** Apply Reset **/
    C("Applying RESET");
    RES(LOW, , 1);

    WaitLoop(SMMWCS);

    /** Initialise Bank 0 **/
    AHBWriteMem(0, 0, 16, 0x11111111);

    /** Initialise/Modify Bank 7 **/
    AHBWriteMem(7, 0, 16, TestWrite);

    /** Reconfigure the Memory Width field of the Memory **/
    MEMTData = 0x000 | SMMWCS;
    HSA(SMCTrMEMT_0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
    HSW( , 0x002);
    HSA(SMCTrMEMT_7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
    HSW( , MEMTData);

    /** Read from Bank 0 **/
    /** Since Bank 7 is shadowed onto Bank 0, Bank 7 data will be read out **/
    TempData = TestWrite & Mask[SMMWCS];
    if (ENDIANNESS == 0)
    {
      ReadMask = Mask[SMMWCS];
      TestData = TempData & ReadMask;
    } else
    {
      ReadMask = Mask[SMMWCS] << 3*Shift[SMMWCS];
      TestData = (TempData << 3*Shift[SMMWCS]) & ReadMask;
    }
    MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11);
    HSA(MemAddr, NSEQ, INCR, , size[SMMWCS], , 0x1, , , , ,);
    HSR( , TestData, , ReadMask, ,RemapTests_1);
    for (i=1, TempData++; i<16; i++, TempData++)
    {
      if (ENDIANNESS == 0)
      {
        ReadMask = (Mask[SMMWCS] << i*Shift[SMMWCS]);
        TestData = (TempData << i*Shift[SMMWCS]) & ReadMask;
      } else
      {
        ReadMask = (Mask[SMMWCS] << (3-i%4)*Shift[SMMWCS]);
        TestData = (TempData << (3-i%4)*Shift[SMMWCS]) & ReadMask;
      }
      HSR( , TestData, , ReadMask, ,RemapTests_2);
    }

    /** Write into Bank 0 **/
    /** Since Bank 7 is shadowed onto Bank 0, Bank 7 will get written into **/
    TestWrite += 0x11111111;
    TempData = TestWrite;
    if (ENDIANNESS == 0)
    {
      TestData = TempData & Mask[SMMWCS];
    } else
    {
      TestData = (TempData << 3*Shift[SMMWCS]) &
                 (Mask[SMMWCS] << 3*Shift[SMMWCS]);
    }
    HSA(MemAddr, NSEQ, INCR, , size[SMMWCS], , 0x1, , , , ,);
    HSW( , TestData);
    for (i=1, TempData++; i<16; i++, TempData++)
    {
      if (ENDIANNESS == 0)
      {
        TestData = TempData & Mask[SMMWCS];
      } else
      {
        TestData = (TempData << (3-i%4)*Shift[SMMWCS]) &
                   (Mask[SMMWCS] << (3-i%4)*Shift[SMMWCS]);
      }
      HSW( , TestData);
    }
    
    /** Set the REMAP input **/
    C("Setting REMAP input");
    HSA(SMCTrREMAP, NSEQ, INCR, , WRD, , 0x1, , , , ,);
    HSW( , 0x1);
    HSA(SMCTrREMAP, NSEQ, INCR, , WRD, , 0x1, , , , ,);
    HSW( , 0x1);

    /** Inserts wait state to account for the registering the Remap **/
    WaitLoop(1);

    /** Read Bank 0 for unmodified data **/
    TempData = 0x11111111;
    HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
    HSR( , TempData, , NoMask, ,RemapTests_3);
    for (i=1, TempData++; i<16; i++, TempData++)
      HSR( , TempData, , NoMask, ,RemapTests_4);

    /** Read Bank 7 for modified data **/
    MemAddr = SMCMEM_7 + (SMCTrMEMBData[7] << 11);
    TempData = TestWrite;
    if (ENDIANNESS == 0)
    {
      ReadMask = Mask[SMMWCS];
      TestData = TempData & ReadMask;
    } else
    {
      ReadMask = Mask[SMMWCS] << 3*Shift[SMMWCS];
      TestData = (TempData << 3*Shift[SMMWCS]) & ReadMask;
    }
    HSA(MemAddr, NSEQ, INCR, , size[SMMWCS], , 0x1, , , , ,);
    HSR( , TestData, , ReadMask, ,RemapTests_5);
    for (i=1, TempData++; i<16; i++, TempData++)
    {
      if (ENDIANNESS == 0)
      {
        ReadMask = (Mask[SMMWCS] << i*Shift[SMMWCS]);
        TestData = (TempData << i*Shift[SMMWCS]) & ReadMask;
      } else
      {
        ReadMask = (Mask[SMMWCS] << (3-i%4)*Shift[SMMWCS]);
        TestData = (TempData << (3-i%4)*Shift[SMMWCS]) & ReadMask;
      }
      HSR( , TestData, , ReadMask, ,RemapTests_6);
    }
  }
}

/************************************ End *************************************/
