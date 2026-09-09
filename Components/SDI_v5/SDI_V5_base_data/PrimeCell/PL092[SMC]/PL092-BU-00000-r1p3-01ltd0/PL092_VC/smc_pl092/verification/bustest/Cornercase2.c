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
--  File Name              : Cornercase2.c.rca
--  File Revision          : 1.6
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

void Cornercase2()
{
  /*
     Summary: BURST Mode Wait state tests
     ========================
     This function performs the following:

     o  This test does the different types of Burst reads followed by a single
        write and read to the different bank
     o  Performs BURST and Non-BURST reads from the memory banks through the
        SMC using different HSIZE WST1, WST2 and HBURST values

  */

  int i;
  int WST1, WST2, Burst, HSIZE, WriteData;
  char HBURST;
  int32 TestData, MemAddr, ReadData, ReadMask;
  int32 TempData1, TempData2, TempData3, TempData4;
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int32 Offset;


C(" Configure the memory");
for (WST1 = 0; WST1 < 4; WST1++ )
  {
    for (WST2 = 0; WST2 < 4; WST2 ++)
    {

  /** Set Bank 1 Memory Type as SRAM (32 bits width) with burst mode enabled **/
     SMCTrMEMBData[1] = 0x00000000;
     ConfigureUUT(1, 0x01, WST1, WST2, 0x00, 0x00, 0x000000A0, 0x000000,
                  0x000000);
     ConfigureUUT(0, 0x02, 0x07, 0x05, 0x00, 0x00, 0x00000000, 0x000000,
                  0x000000);

    for (HSIZE = 0, TestData = 0xA0000000; HSIZE < 3; HSIZE++)
    {
    for (Burst = 7; Burst >= 1; Burst--)
    {
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(1, Burst, 0x120 , HSIZE, 2, WriteData);

   
     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_0 + 0x428 * 0xFF; 
     HSA(MemAddr, NSEQ, SINGLE, OK, BYTE, , 0x1, , , , ,);
     HSW( , 0x40000000);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_0 + 0x428 * 0xFF; 
     HSA(MemAddr, NSEQ, SINGLE, OK, BYTE, , 0x1, , , , ,);
     HSR( , 0x40000000, , ReadMask, ,BROMTests_single);
 }
}

 }

}
   
     WaitLoop(10);

C(" Configure the memory");
for (WST1 = 6; WST1 < 9; WST1++ )
  {
    for (WST2 = 2; WST2 < 5; WST2 ++)
    {

  /** Set Bank 1 Memory Type as SRAM (32 bits width) with burst mode enabled **/
     SMCTrMEMBData[1] = 0x00000000;
     ConfigureUUT(1, 0x01, 0x00, 0x00, 0x00, 0x00, 0x000000A0, 0x000000,
                  0x000000);
     ConfigureUUT(0, 0x02, WST1, WST2, 0x00, 0x00, 0x00000020, 0x000000,
                  0x000000);

    for (HSIZE = 0, TestData = 0xA0000000; HSIZE < 3; HSIZE++)
    {
    for (Burst = 7; Burst >= 1; Burst--)
    {
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(0, Burst, 0x120 , HSIZE, 0, WriteData);


     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x428 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x40000000);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x428 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x40000000, , ReadMask, ,BROMTests_single);
 }
}

 }

}

     WaitLoop(10);

C(" Configure the memory");
for (WST1 = 16; WST1 < 32; WST1 = WST1+15 )
  {
    for (WST2 = 0; WST2 < 4; WST2 ++)
    {

  /** Set Bank 1 Memory Type as SRAM (32 bits width) with burst mode enabled **/
     SMCTrMEMBData[1] = 0x00000000;
     ConfigureUUT(1, 0x01, 0x06, 0x02, 0x00, 0x00, 0x000000A0, 0x000000,
                  0x000000);
     ConfigureUUT(6, 0x02, WST1, WST2, 0x00, 0x00, 0x00000060, 0x000000,
                  0x000000);

    for (HSIZE = 0, TestData = 0xA0000000; HSIZE < 3; HSIZE++)
    {
    for (Burst = 7; Burst >= 1; Burst--)
    {
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(6, Burst, 0x120 , HSIZE, 1, WriteData);


     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x428 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x40000000);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x428 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x40000000, , ReadMask, ,BROMTests_single);
 }
}

 }

}



}


/************************************ End *************************************/
