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
--  File Name              : Cornercase1.c.rca
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

void Cornercase1()
{
  /*
     Summary: BURST Mode Wait state tests
     ========================
     This function performs the following:

     o  This test does the different types of Burst reads followed by a single 
        write and read to the same bank
     o  Performs BURST and Non-BURST reads from the memory banks through the
        SMC using different HSIZE WST1, WST2 and HBURST values
  */

  int i;
  int WST1, WST2, Burst;
  char HBURST;
  int32 TestData, MemAddr, ReadData, ReadMask;
  int32 TempData1, TempData2, TempData3, TempData4;

C(" Configure the memory");
for (WST1 = 16; WST1 < 32; WST1=WST1+15 )
  {
    for (WST2 = 0; WST2 < 4; WST2 ++)
    {

  /** Set Bank 1 Memory Type as SRAM (32 bits width) with burst mode enabled **/
     SMCTrMEMBData[1] = 0x00000000;
     ConfigureUUT(1, 0x01, WST1, WST2, 0x00, 0x00, 0x000000A0, 0x000000,
                  0x000000);
   
    C("INCR BURST");

    C("HSIZE = WORD, HBURST = INCR, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x120 * 0x00;
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , 0xA0000000);
    TestData = 0xA0000000;
    for (i=1, TestData++; i<6; i++, TestData++)
    HSW( , TestData);

   
     C("HSIZE = WORD, HBURST = INCR, READ BURST");
     MemAddr = SMCMEM_1 + 0x120 * 0x00;
     TestData = 0xA0000000;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_1);
     for (i=1, TestData++; i<6; i++, TestData++)
     {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_2);
     }
   
     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x428 * 0xFF; 
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x40000000);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x428 * 0xFF; 
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x40000000, , ReadMask, ,BROMTests_single);

     C("INCR4 Burst");
     C("HSIZE = WORD, HBURST = INCR4, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x440 * 0x00;
    HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
    HSW( , 0x40404040);
    TestData = 0x40404040;
    for (i=1, TestData++; i<4; i++, TestData++)
    HSW( , TestData);


     C("HSIZE = WORD, HBURST = INCR, READ BURST");
     MemAddr = SMCMEM_1 + 0x440 * 0x00;
     TestData = 0x40404040;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_1);
     for (i=1, TestData++; i<4; i++, TestData++)
     {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_2);
     }

     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x428 * 0x64;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x66666666);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x428 * 0x64;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x66666666, , ReadMask, ,BROMTests_single);

     C("WRAP4 BURST");
    C("HSIZE = WORD, HBURST = WRAP4, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x620 * 0x00;
    HSA(MemAddr, NSEQ, WRAP4, OK, WRD, , 0x1, , , , ,);
    HSW( , 0x30000000);
    TestData = 0x30000000;
    for (i=1, TestData++; i<4; i++, TestData++)
    HSW( , TestData);


     C("HSIZE = WORD, HBURST = WRAP4, READ BURST");
     MemAddr = SMCMEM_1 + 0x620 * 0x00;
     TestData = 0x30000000;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, WRAP4, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_1);
     for (i=1, TestData++; i<4; i++, TestData++)
     {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_2);
     }

     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x628 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x40000000);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x628 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x40000000, , ReadMask, ,BROMTests_single);

     C("INCR8 BURST");
     C("HSIZE = WORD, HBURST = INCR8, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x6C0 * 0x00;
    HSA(MemAddr, NSEQ, INCR8, OK, WRD, , 0x1, , , , ,);
    HSW( , 0x56000056);
    TestData = 0x56000056;
    for (i=1, TestData++; i<8; i++, TestData++)
    HSW( , TestData);


     C("HSIZE = WORD, HBURST = INCR8, READ BURST");
     MemAddr = SMCMEM_1 + 0x6C0 * 0x00;
     TestData = 0x56000056;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, INCR8, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_1);
     for (i=1, TestData++; i<8; i++, TestData++)
     {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_2);
     }

     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x648 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x40000000);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x648 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x40000000, , ReadMask, ,BROMTests_single);

     C("WRAP8 BURST")
     C("HSIZE = WORD, HBURST = WRAP8, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x6A0 * 0x00;
    HSA(MemAddr, NSEQ, WRAP8, OK, WRD, , 0x1, , , , ,);
    HSW( , 0xCCCCCCCC);
    TestData = 0xCCCCCCCC;
    for (i=1, TestData++; i<8; i++, TestData++)
    HSW( , TestData);


     C("HSIZE = WORD, HBURST = WRAP8, READ BURST");
     MemAddr = SMCMEM_1 + 0x6A0 * 0x00;
     TestData = 0xCCCCCCCC;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, WRAP8, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_1);
     for (i=1, TestData++; i<8; i++, TestData++)
     {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_2);
     }

     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x628 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x40000000);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x628 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x40000000, , ReadMask, ,BROMTests_single);

     C("INCR16 BURST");
     C("HSIZE = WORD, HBURST = INCR16, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x420 * 0x00;
    HSA(MemAddr, NSEQ, INCR16, OK, WRD, , 0x1, , , , ,);
    HSW( , 0xF000000F);
    TestData = 0xF000000F;
    for (i=1, TestData++; i<16; i++, TestData++)
    HSW( , TestData);


     C("HSIZE = WORD, HBURST = INCR16, READ BURST");
     MemAddr = SMCMEM_1 + 0x620 * 0x00;
     TestData = 0xF000000F;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, INCR16, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_1);
     for (i=1, TestData++; i<16; i++, TestData++)
     {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_2);
     }

     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x628 * 0x82;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x77665544);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x628 * 0x82;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x77665544, , ReadMask, ,BROMTests_single);
     
     C("WRAP16 BURST");
      C("HSIZE = WORD, HBURST = WRAP16, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x520 * 0x00;
    HSA(MemAddr, NSEQ, WRAP16, OK, WRD, , 0x1, , , , ,);
    HSW( , 0x12345678);
    TestData = 0x12345678;
    for (i=1, TestData++; i<16; i++, TestData++)
    HSW( , TestData);


     C("HSIZE = WORD, HBURST = WRAP16, READ BURST");
     MemAddr = SMCMEM_1 + 0x520 * 0x00;
     TestData = 0x12345678;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, WRAP16, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_1);
     for (i=1, TestData++; i<16; i++, TestData++)
     {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_2);
     }

     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x628 * 0x82;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x77665544);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x628 * 0x82;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x77665544, , ReadMask, ,BROMTests_single);

 }

}
   
     WaitLoop(10);

C(" Configure the memory");
for (WST1 = 0; WST1 < 4; WST1 ++)
  {
    for (WST2 = 0; WST2 < 4 ; WST2 ++)
    {

  /** Set Bank 1 Memory Type as SRAM (32 bits width) with burst mode enabled **/
     SMCTrMEMBData[1] = 0x00000000;
     ConfigureUUT(1, 0x01, WST1, WST2, 0x00, 0x00, 0x000000A0, 0x000000,
                  0x000000);

    C("INCR BURST");

    C("HSIZE = WORD, HBURST = INCR, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x120 * 0x00;
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , 0xA0000000);
    TestData = 0xA0000000;
    for (i=1, TestData++; i<6; i++, TestData++)
    HSW( , TestData);


     C("HSIZE = WORD, HBURST = INCR, READ BURST");
     MemAddr = SMCMEM_1 + 0x120 * 0x00;
     TestData = 0xA0000000;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_3);
     for (i=1, TestData++; i<6; i++, TestData++)
     {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_4);
     }

     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x428 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x40000000);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x428 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x40000000, , ReadMask, ,BROMTests_single);
 
     C("INCR4 BURST");
     C("HSIZE = WORD, HBURST = INCR4, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x320 * 0x00;
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , 0xAAAAAAAA);
    TestData = 0xAAAAAAAA;
    for (i=1, TestData++; i<4; i++, TestData++)
    HSW( , TestData);


     C("HSIZE = WORD, HBURST = INCR4, READ BURST");
     MemAddr = SMCMEM_1 + 0x320 * 0x00;
     TestData = 0xAAAAAAAA;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_3);
     for (i=1, TestData++; i<4; i++, TestData++)
     {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_4);
     }

     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x528 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x40000000);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x528 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x40000000, , ReadMask, ,BROMTests_single);

     C("WRAP4 BURST");
     C("HSIZE = WORD, HBURST = WRAP4, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x4C0 * 0x00;
    HSA(MemAddr, NSEQ, WRAP4, OK, WRD, , 0x1, , , , ,);
    HSW( , 0x20000002);
    TestData = 0x20000002;
    for (i=1, TestData++; i<4; i++, TestData++)
    HSW( , TestData);


     C("HSIZE = WORD, HBURST = INCR, READ BURST");
     MemAddr = SMCMEM_1 + 0x120 * 0x00;
     TestData = 0x20000002;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, WRAP4, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_3);
     for (i=1, TestData++; i<4; i++, TestData++)
     {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_4);
     }

     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x428 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x40000000);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x428 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x40000000, , ReadMask, ,BROMTests_single);



     WaitLoop(10);
    }
}

C(" Configure the memory");
for (WST1 = 16; WST1 < 32; WST1=WST1+15 )
  {
    WST2 = WST1;
    {

  /** Set Bank 1 Memory Type as SRAM (32 bits width) with burst mode enabled **/
     SMCTrMEMBData[1] = 0x00000000;
     ConfigureUUT(1, 0x01, WST1, WST2, 0x00, 0x00, 0x000000A0, 0x000000,
                  0x000000);

     /** Initialise the ROMs from AHB side **/
C("Initialise ROMS from AHB side");

    C("HSIZE = WORD, HBURST = WRAP4, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x120 * 0x00;
    HSA(MemAddr, NSEQ, WRAP4, OK, WRD, , 0x1, , , , ,);
    HSW( , 0xA0000000);
    TestData = 0xA0000000;
    for (i=1, TestData++; i<4; i++, TestData++)
    HSW( , TestData);


     C("HSIZE = WORD, HBURST = WRAP4, READ BURST");
     MemAddr = SMCMEM_1 + 0x120 * 0x00;
     TestData = 0xA0000000;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, WRAP4, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_5);
     for (i=1, TestData++; i<4; i++, TestData++)
     {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_6);
     }

     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x428 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x40000000);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x428 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x40000000, , ReadMask, ,BROMTests_single);

     WaitLoop(10);
}
}

C(" Configure the memory");
for (WST1 = 6; WST1 < 9; WST1++ )
  {
    for (WST2 = 2; WST2 < 5; WST2 ++)
    {

  /** Set Bank 1 Memory Type as SRAM (32 bits width) with burst mode enabled **/
     SMCTrMEMBData[1] = 0x00000000;
     ConfigureUUT(1, 0x01, WST1, WST2, 0x00, 0x00, 0x000000A0, 0x000000,
                  0x000000);

    C("INCR BURST");

    C("HSIZE = WORD, HBURST = INCR, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x120 * 0x00;
    HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , 0xA0000000);
    TestData = 0xA0000000;
    for (i=1, TestData++; i<6; i++, TestData++)
    HSW( , TestData);


     C("HSIZE = WORD, HBURST = INCR, READ BURST");
     MemAddr = SMCMEM_1 + 0x120 * 0x00;
     TestData = 0xA0000000;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_1);
     for (i=1, TestData++; i<6; i++, TestData++)
     {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_2);
     }

     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x428 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x40000000);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x428 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x40000000, , ReadMask, ,BROMTests_single);

       C("INCR4 Burst");
     C("HSIZE = WORD, HBURST = INCR4, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x440 * 0x00;
    HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
    HSW( , 0x40404040);
    TestData = 0x40404040;
    for (i=1, TestData++; i<4; i++, TestData++)
    HSW( , TestData);


     C("HSIZE = WORD, HBURST = INCR, READ BURST");
     MemAddr = SMCMEM_1 + 0x440 * 0x00;
     TestData = 0x40404040;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_1);
     for (i=1, TestData++; i<4; i++, TestData++)
     {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_2);
     }

     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x428 * 0x64;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x66666666);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x428 * 0x64;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x66666666, , ReadMask, ,BROMTests_single);

     C("WRAP4 BURST");
    C("HSIZE = WORD, HBURST = WRAP4, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x620 * 0x00;
    HSA(MemAddr, NSEQ, WRAP4, OK, WRD, , 0x1, , , , ,);
    HSW( , 0x30000000);
    TestData = 0x30000000;
    for (i=1, TestData++; i<4; i++, TestData++)
    HSW( , TestData);


     C("HSIZE = WORD, HBURST = WRAP4, READ BURST");
     MemAddr = SMCMEM_1 + 0x620 * 0x00;
     TestData = 0x30000000;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, WRAP4, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_1);
     for (i=1, TestData++; i<4; i++, TestData++)
   {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_2);
     }

     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x628 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x40000000);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x628 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x40000000, , ReadMask, ,BROMTests_single);

     C("INCR8 BURST");
     C("HSIZE = WORD, HBURST = INCR8, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x6C0 * 0x00;
    HSA(MemAddr, NSEQ, INCR8, OK, WRD, , 0x1, , , , ,);
    HSW( , 0x56000056);
    TestData = 0x56000056;
    for (i=1, TestData++; i<8; i++, TestData++)
    HSW( , TestData);


     C("HSIZE = WORD, HBURST = INCR8, READ BURST");
     MemAddr = SMCMEM_1 + 0x6C0 * 0x00;
     TestData = 0x56000056;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, INCR8, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_1);
     for (i=1, TestData++; i<8; i++, TestData++)
     {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_2);
     }

     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x648 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x40000000);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x648 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x40000000, , ReadMask, ,BROMTests_single);

     C("WRAP8 BURST")
     C("HSIZE = WORD, HBURST = WRAP8, WRITE BURST");
    MemAddr = SMCMEM_1 + 0x6A0 * 0x00;
    HSA(MemAddr, NSEQ, WRAP8, OK, WRD, , 0x1, , , , ,);
    HSW( , 0xCCCCCCCC);
    TestData = 0xCCCCCCCC;
    for (i=1, TestData++; i<8; i++, TestData++)
    HSW( , TestData);


     C("HSIZE = WORD, HBURST = WRAP8, READ BURST");
     MemAddr = SMCMEM_1 + 0x6A0 * 0x00;
     TestData = 0xCCCCCCCC;
     ReadData = TestData;
     ReadMask = NoMask;
     HSA(MemAddr, NSEQ, WRAP8, OK, WRD, , 0x1, , , , ,);
     HSR( , ReadData, , ReadMask, ,BROMTests_1);
     for (i=1, TestData++; i<8; i++, TestData++)
     {
       ReadData = TestData;
       HSR( , ReadData, , ReadMask, ,BROMTests_2);
     }

     C("HSIZE = WORD, HBURST = SINGLE, WRITE");
     MemAddr = SMCMEM_1 + 0x628 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSW( , 0x40000000);
     C("HSIZE = WORD, HBURST = SINGLE, READ");
     MemAddr = SMCMEM_1 + 0x628 * 0xFF;
     HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
     HSR( , 0x40000000, , ReadMask, ,BROMTests_single);


  }

 }



}


/************************************ End *************************************/
