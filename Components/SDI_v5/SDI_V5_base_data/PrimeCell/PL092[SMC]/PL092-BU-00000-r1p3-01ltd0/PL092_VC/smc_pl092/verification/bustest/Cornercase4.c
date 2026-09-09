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
--  File Name              : Cornercase4.c.rca
--  File Revision          : 1.5
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform tests to check the operation of the SMC with
--           Wrap4 write followed by Wrap8 write.
--
-- --=========================================================================*/

/******************************************************************************/
/****************************** BURST ROM Tests *******************************/
/******************************************************************************/

void Cornercase4()
{
  /*
     Summary: BURST Mode Wait state tests
     ========================
     This function performs the following:

     o  Performs Wrap4 write followed by Wrap8 write to the different chip
        select through SMC.

  */

  int i;
  int WST1, WST2, Burst, HSIZE, WriteData;
  char HBURST;
  int32 TestData, MemAddr, ReadData, ReadMask;
  int32 TempData1, TempData2, TempData3, TempData4;
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int32 Offset, Address;
  int trans2[9] = {2,3,3,3,3,3,3,3,5};
  int trans4[5] = {2,3,3,3,5};
  char PrintStr[128];
  char* SizeStr[7] = {"WRD","HWRD", "BYTE","HWRD", "WRD","HWRD","HWRD"};



C(" Configure the memory");
for (WST1 = 0; WST1 < 1; WST1++ )
  {
    for (WST2 = 0; WST2 < 1; WST2 ++)
    {

  /** Set Bank 1 Memory Type as SRAM (32 bits width) with burst mode enabled **/
     SMCTrMEMBData[1] = 0x00000000;
     ConfigureUUT(1, 0x01, WST1, WST2, 0x00, 0x00, 0x00000080, 0x000000,
                  0x000000);
     ConfigureUUT(6, 0x02, 0x07, 0x05, 0x00, 0x00, 0x00000040, 0x000000,
                  0x000000);

    for (HSIZE = 1, TestData = 0xA0000000; HSIZE < 2; HSIZE++)
    {
    for (Burst = 5; Burst > 4; Burst--)
    {
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(1, Burst, 0x120 , HSIZE, 2, WriteData);

   
     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_0 + 0x428 * 0xFF; 
     HSA(MemAddr, NSEQ, SINGLE, OK, BYTE, , 0x1, , , , ,);
     HSW( , 0x40000000);
 }
}

 }

}
   
     WaitLoop(10);
/* test case for the hang issue where Wrap4 write is followed by Wrap8 write */
/* to the different chip select */
    ConfigureUUT(1, 0x01, 0x08, 0x15, 0x04, 0x0D, 0x00000080, 0x000000,
                  0x000000);
     ConfigureUUT(6, 0x02, 0x1F, 0x02, 0x04, 0x01, 0x00000041, 0x000000,
                  0x000000);

Address = SMCMEM_6 + 0x420 * 0x00;
Sequence('w',Address, trans4,"wr4",1,0x88222288,0);

 C("Trickmem access");
  HSA(SMCTrMEMR_0, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x000000F0, , 0x00000000, ,BROMTests_5);

  HSA(SMCTrMEMT_0, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x000000F0, , 0x00000000, ,BROMTests_5);

  HSA(SMCTrMEMT_0, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x000000F0, , 0x00000000, ,BROMTests_5);


Address = SMCMEM_1 + 0x420 * 0x00;
Sequence('w',Address, trans2,"wr8",1,0x88222288,0);
Sequence('r',Address, trans2,"wr8",1,0x88222288,0);
}


/************************************ End *************************************/
