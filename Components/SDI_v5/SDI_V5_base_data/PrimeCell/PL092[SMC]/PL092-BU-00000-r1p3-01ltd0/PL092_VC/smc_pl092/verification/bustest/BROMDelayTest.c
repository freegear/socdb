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
--  File Name              : BROMDelayTest.c.rca
--  File Revision          : 1.6
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform tests to check the operation of the SMC with
--           a of BURST size of 16 with the WST2 value zero and a nonzero value of 
--           WST1.
--
-- --=========================================================================*/

/******************************************************************************/
/****************************** BURST ROM Delay Tests *******************************/
/******************************************************************************/

void BROMDelayTest()
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

  int i, HSIZE;
  int WST1, WST2, Burst;
  char HBURST;
  int32 TestData, MemAddr, ReadData, ReadMask, WriteData;
  int32 TempData1, TempData2, TempData3, TempData4;
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};

  C(" Configure the memory");
  WST1 = 2;
  WST2 = 0;
  HSIZE = 1;
  Burst = 7;

  /** Set Bank 0 Memory Type as BROM (16 bits width) **/
     SMCTrMEMBData[1] = 0x00000000;
     ConfigureUUT(0, 0x01, WST1, WST2, 0x00, 0x00, 0x00000060, 0x000000,
                  0x000000);
   
/*
  C("INCR BURST : Does INCR burst read from CS0");
  MemAddr = 0x00000002;
  TestData = 0x000000E2;
  WriteData = TestData & UnMask[HSIZE];
  MemAddr = 0x00000000;
  TestData = 0x000000E0;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0x0000FFFF, ,BROMTests_1);
  MemAddr = 0x00000004;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x000000E4, , 0x0000FFFF, ,BROMTests_2);
  MemAddr = 0x00000008;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x000000E8, , 0x0000FFFF, ,BROMTests_3);
  MemAddr = 0x0000000C;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x000000EC, , 0x0000FFFF, ,BROMTests_4);
  MemAddr = 0x00000010;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x000000F0, , 0x0000FFFF, ,BROMTests_5);
  MemAddr = 0x00000014;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x000000F4, , 0x0000FFFF, ,BROMTests_6);
  MemAddr = 0x00000018;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x000000F8, , 0x0000FFFF, ,BROMTests_7);
  MemAddr = 0x0000001C;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x000000FC, , 0x0000FFFF, ,BROMTests_8);
  MemAddr = 0x00000020;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000000, , 0x0000FFFF, ,BROMTests_9);
  MemAddr = 0x00000024;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000004, , 0x0000FFFF, ,BROMTests_10);
  MemAddr = 0x00000028;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000008, , 0x0000FFFF, ,BROMTests_11);
  MemAddr = 0x0000002C;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x0000000C, , 0x0000FFFF, ,BROMTests_12);
  MemAddr = 0x00000030;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000010, , 0x0000FFFF, ,BROMTests_13);
  MemAddr = 0x00000034;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000014, , 0x0000FFFF, ,BROMTests_14);
  MemAddr = 0x00000038;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000018, , 0x0000FFFF, ,BROMTests_15);

*/

  C(" Configure the memory");
  WST1 = 5;
  WST2 = 0;
  HSIZE = 1;
  Burst = 7;

  /** Set Bank 2 Memory Type as BROM (16 bits width)  **/
     SMCTrMEMBData[1] = 0x00000000;
     ConfigureUUT(2, 0x02, WST1, WST2, 0x00, 0x00, 0x00000060, 0x000000,
                  0x000000);
/*

  C("INCR BURST : Does INCR burst read from CS2");
  MemAddr = 0x08008000;
  TestData = 0x00000001;
  WriteData = TestData & UnMask[HSIZE];
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0x0000FFFF, ,BROMTests_16);
  MemAddr = 0x08008004;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000005, , 0x0000FFFF, ,BROMTests_17);
  MemAddr = 0x08008008;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000009, , 0x0000FFFF, ,BROMTests_18);
  MemAddr = 0x0800800C;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000013, , 0x0000FFFF, ,BROMTests_19);
  MemAddr = 0x08008010;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000017, , 0x0000FFFF, ,BROMTests_20);
  MemAddr = 0x08008014;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000021, , 0x0000FFFF, ,BROMTests_21);
  MemAddr = 0x08008018;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000025, , 0x0000FFFF, ,BROMTests_22);
  MemAddr = 0x0800801C;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000029, , 0x0000FFFF, ,BROMTests_23);
  MemAddr = 0x08008020;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000033, , 0x0000FFFF, ,BROMTests_24);
  MemAddr = 0x08008024;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000037, , 0x0000FFFF, ,BROMTests_25);
  MemAddr = 0x08008028;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000041, , 0x0000FFFF, ,BROMTests_26);
  MemAddr = 0x0800802C;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000045, , 0x0000FFFF, ,BROMTests_27);
  MemAddr = 0x08008030;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000049, , 0x0000FFFF, ,BROMTests_28);
  MemAddr = 0x08008034;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000053, , 0x0000FFFF, ,BROMTests_29);
  MemAddr = 0x08008038;
  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000057, , 0x0000FFFF, ,BROMTests_30);
*/

/* testcode for error_conseqread_rel115 */
  C(" Configure the memory");
  WST1 = 5;
  WST2 = 18;
  HSIZE = 2;
  Burst = 7;

  /** Set Bank 2 Memory Type as BROM (16 bits width)  **/
     SMCTrMEMBData[1] = 0x00000000;
     ConfigureUUT(2, 0x02, WST1, WST2, 0x00, 0x09, 0x00000060, 0x000000,
                  0x000000);
  C("WRAP4 BURST : Does WRAP4 burst read from CS2");
  MemAddr = 0x0800800C;
  TestData = 0x00000013;
  WriteData = TestData & UnMask[HSIZE];
  HSA(MemAddr, NSEQ, WRAP4, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0x0000FFFF, ,BROMTests_16);
  MemAddr = 0x08008000;
  HSA(MemAddr, SEQ, WRAP4, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000001, , 0x0000FFFF, ,BROMTests_17);
  MemAddr = 0x08008004;
  HSA(MemAddr, SEQ, WRAP4, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000005, , 0x0000FFFF, ,BROMTests_18);
  MemAddr = 0x08008008;
  HSA(MemAddr, SEQ, WRAP4, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000009, , 0x0000FFFF, ,BROMTests_19);


}


/************************************ End *************************************/
