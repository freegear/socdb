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
--  File Name              : RandomTests.c.rca
--  File Revision          : 1.10
--
--  Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform random accesses to the SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/******************************** Random Tests ********************************/
/******************************************************************************/

void RandomTests()
{
  /*
     Summary: Random Tests
     =====================
     This function performs the following:

     o  Accesses different banks of the SMC with various combinations of
        different sizes, bursts and transfer types
     o  Accesses are generated randomly using "random" function
  */

  int i, j, HSIZE1, HSIZE2, BURST1, BURST2, BankNo1, BankNo2, BeatsNo1,
      BeatsNo2;
  int32 TestData1, TestData2, MemAddr1, MemAddr2, TestWrite, TestRead,
        MaskRead, TempData;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  int32 Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int Shift[3] = {8, 16, 0};

  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** CSPol = 0, ExtWait disabled **/
  C("Configuring the SMC and the Memory Blocks");
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x06, 0x05, 0x02, 0x02, 0x00000080, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x02, 0x06, 0x05, 0x002, SMCTrMEMBData[0], 0x02,
                  0x02, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (16 bits width) **/
  /** CSPol = 1, ExtWait disabled **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x05, 0x04, 0x01, 0x00, 0x00000048, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x02, 0x05, 0x04, 0x081, SMCTrMEMBData[1], 0x01,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as SRAM (8 bits width) **/
  SMCTrMEMBData[2] = 0x00000000;
  /** CSPol = 0, ExtWait enabled **/
  ConfigureUUT(2, 0x03, 0x05, 0x04, 0x01, 0x01, 0x00000004, 0x000004,
               0x000007);
  ConfigureMemory(2, 0x03, 0x05, 0x04, 0x100, SMCTrMEMBData[2], 0x01,
                  0x01, 0x000000);

  /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  /** CSPol = 1, ExtWait enabled **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x01, 0x07, 0x04, 0x01, 0x00, 0x0000008C, 0x000002,
               0x000006);
  ConfigureMemory(3, 0x01, 0x07, 0x04, 0x182, SMCTrMEMBData[3], 0x01,
                  0x00, 0x000000);

  /** Set Bank 4 Memory Type as SRAM (16 bits width) **/
  SMCTrMEMBData[4] = 0x00000000;
  /** CSPol = 0, ExtWait enabled **/
  ConfigureUUT(4, 0x02, 0x07, 0x07, 0x02, 0x01, 0x00000044, 0x000005,
               0x00000A);
  ConfigureMemory(4, 0x02, 0x07, 0x07, 0x501, SMCTrMEMBData[4], 0x02,
                  0x01, 0x000000);

  /** Set Bank 5 Memory Type as SRAM (8 bits width) **/
  /** CSPol = 1, ExtWait enabled **/
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x03, 0x07, 0x05, 0x03, 0x02, 0x0000000C, 0x000003,
               0x000005);
  ConfigureMemory(5, 0x03, 0x07, 0x05, 0x580, SMCTrMEMBData[5], 0x03,
                  0x02, 0x000000);

  /** Set Bank 6 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[6] = 0x00000000;
  /** CSPol = 0, ExtWait disabled **/
  ConfigureUUT(6, 0x04, 0x06, 0x05, 0x01, 0x01, 0x00000080, 0x000000,
               0x000000);
  ConfigureMemory(6, 0x04, 0x06, 0x05, 0x002, SMCTrMEMBData[6], 0x01,
                  0x01, 0x000000);

  /** Set Bank 7 Memory Type as SRAM (16 bits width) **/
  /** CSPol = 1, ExtWait disabled **/
  SMCTrMEMBData[7] = 0x00000000;
  ConfigureUUT(7, 0x02, 0x05, 0x05, 0x01, 0x01, 0x00000048, 0x000000,
               0x000000);
  ConfigureMemory(7, 0x02, 0x05, 0x05, 0x081, SMCTrMEMBData[7], 0x01,
                  0x01, 0x000000);

  for (i=0; i<10; i++)
  {
    HSIZE1 = random()%3;
    HSIZE2 = random()%3;
    BURST1 = random()%8;
    BURST2 = random()%8;
    BankNo1 = random()%8;
    BankNo2 = random()%8;
    TestData1 = random();
    TestData2 = random();
  
    switch (BankNo1)
    {
      case 0 : MemAddr1 = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 0x000; break;
      case 1 : MemAddr1 = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + 0x004; break;
      case 2 : MemAddr1 = SMCMEM_2 + (SMCTrMEMBData[2] << 11) + 0x008; break;
      case 3 : MemAddr1 = SMCMEM_3 + (SMCTrMEMBData[3] << 11) + 0x00C; break;
      case 4 : MemAddr1 = SMCMEM_4 + (SMCTrMEMBData[4] << 11) + 0x010; break;
      case 5 : MemAddr1 = SMCMEM_5 + (SMCTrMEMBData[5] << 11) + 0x014; break;
      case 6 : MemAddr1 = SMCMEM_6 + (SMCTrMEMBData[6] << 11) + 0x018; break;
      case 7 : MemAddr1 = SMCMEM_7 + (SMCTrMEMBData[7] << 11) + 0x01C; break;
      default : break;
    }
  
    switch (BankNo2)
    {
      case 0 : MemAddr2 = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 0x70C; break;
      case 1 : MemAddr2 = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + 0x708; break;
      case 2 : MemAddr2 = SMCMEM_2 + (SMCTrMEMBData[2] << 11) + 0x704; break;
      case 3 : MemAddr2 = SMCMEM_3 + (SMCTrMEMBData[3] << 11) + 0x700; break;
      case 4 : MemAddr2 = SMCMEM_4 + (SMCTrMEMBData[4] << 11) + 0x6FC; break;
      case 5 : MemAddr2 = SMCMEM_5 + (SMCTrMEMBData[5] << 11) + 0x6F8; break;
      case 6 : MemAddr2 = SMCMEM_6 + (SMCTrMEMBData[6] << 11) + 0x6F4; break;
      case 7 : MemAddr2 = SMCMEM_7 + (SMCTrMEMBData[7] << 11) + 0x6F0; break;
      default : break;
    }
  
    switch (BURST1)
    {
      case 0 : BeatsNo1 = 2; break;
      case 1 : BeatsNo1 = 2; break;
      case 2 : BeatsNo1 = 4; break;
      case 3 : BeatsNo1 = 8; break;
      case 4 : BeatsNo1 = 16; break;
      case 5 : BeatsNo1 = 4; break;
      case 6 : BeatsNo1 = 8; break;
      case 7 : BeatsNo1 = 16; break;
      default : break;
    }
  
    switch (BURST2)
    {
      case 0 : BeatsNo2 = 2; break;
      case 1 : BeatsNo2 = 2; break;
      case 2 : BeatsNo2 = 4; break;
      case 3 : BeatsNo2 = 8; break;
      case 4 : BeatsNo2 = 16; break;
      case 5 : BeatsNo2 = 4; break;
      case 6 : BeatsNo2 = 8; break;
      case 7 : BeatsNo2 = 16; break;
      default : break;
    }
  
    TestWrite = TestData1;
    HSA(MemAddr1, NSEQ, beat[BURST1], , size[HSIZE1], , 0x1, , , , ,);
    HSW( , TestWrite++);
    for (j=1; j<BeatsNo1; j++)
      HSW( , TestWrite++)
  
    TestWrite = TestData2;
    HSA(MemAddr2, NSEQ, beat[BURST2], , size[HSIZE2], , 0x1, , , , ,);
    HSW( , TestWrite++);
    for (j=1; j<BeatsNo2; j++)
      HSW( , TestWrite++)
  
    TempData = TestData1;
    MaskRead = Mask[HSIZE1];
    TestRead = TempData & MaskRead;
    HSA(MemAddr1, NSEQ, beat[BURST1], , size[HSIZE1], , 0x1, , , , ,);
    HSR( , TestRead, , MaskRead, ,RandomTests_1);
    for (j=1, TempData++; j<BeatsNo1; j++, TempData++)
    {
      MaskRead = Mask[HSIZE1] << j*Shift[HSIZE1];
      TestRead = (TempData << j*Shift[HSIZE1]) & MaskRead;
      HSR( , TestRead, , MaskRead, ,RandomTests_2);
    }
  
    TempData = TestData2;
    MaskRead = Mask[HSIZE2];
    TestRead = TempData & MaskRead;
    HSA(MemAddr2, NSEQ, beat[BURST2], , size[HSIZE2], , 0x1, , , , ,);
    HSR( , TestRead, , MaskRead, ,RandomTests_3);
    for (j=1, TempData++; j<BeatsNo2; j++, TempData++)
    {
      MaskRead = Mask[HSIZE2] << j*Shift[HSIZE2];
      TestRead = (TempData << j*Shift[HSIZE2]) & MaskRead;
      HSR( , TestRead, , MaskRead, ,RandomTests_4);
    }
  }
}

/************************************ End *************************************/
