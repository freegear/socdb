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
--  File Name              : BusAccessTests.c.rca
--  File Revision          : 1.10
--
--  Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform different BUSY and IDLE access tests on the
--           SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/************************ BUSY and IDLE Accesses Tests ************************/
/******************************************************************************/

void BusAccessTests()
{
  /*
     Summary: BUSY and IDLE Accesses Tests
     =====================================
     This function performs the following:

     o  Adds BUSY transfer in between reads, writes and BURST reads
     o  Adds IDLE transfer in between reads, writes and BURST transfers
  */

  int32 TestData, MemAddr;

  /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000085, 0x000004,
               0x000007);
  ConfigureMemory(3, 0x02, 0x05, 0x04, 0x142, SMCTrMEMBData[3], 0x02,
                  0x00, 0x000000);

  /** Initialise the Memory Bank 3 **/
  TestData = 0x55555555;
  AHBWriteMem(3, 0, 8, TestData);

  C("Adds BUSY in between reads");
  MemAddr = MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_1);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_2);

  HSA(MemAddr+=4, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++ & MaskAll, , NoMask, ,BusAccessTests_3);

  HSA(MemAddr, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData & MaskAll, , NoMask, ,BusAccessTests_4);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_5);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_6);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_7);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,BusAccessTests_8);

  C("Adds BUSY in between Writes");
  TestData = 0xAAAAAAAA;
  MemAddr = MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr+=4, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /** Verify that the BUSY transfer did not modify the Memory data **/
  TestData = 0x55555555 + 2;
  MemAddr = MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11) + 8;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,BusAccessTests_9);

  C("Adds IDLE in between reads");
  TestData = 0xAAAAAAAA;
  MemAddr = MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_10);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_11);

  HSA(MemAddr+=4, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++ & MaskAll, , NoMask, ,BusAccessTests_12);

  HSA(MemAddr+=4, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++ & MaskAll, , NoMask, ,BusAccessTests_13);

  TestData++;
  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_14);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_15);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_16);

  C("Adds IDLE in between Writes");
  TestData = 0xBBBBBBBB;
  MemAddr = MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr+=4, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr+=4, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /** Verify that the IDLE transfer did not modify the Memory data **/
  MemAddr = MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11) + 8;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x55555557, , NoMask, ,BusAccessTests_17);
  HSR( , 0xAAAAAAAE, , NoMask, ,BusAccessTests_18);

  C("Adds BUSY in between BURST reads");
  MemAddr = MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11);
  TestData = 0xBBBBBBBB;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_19);
  HSR( , TestData++, , NoMask, ,BusAccessTests_20);

  HSA(MemAddr+=8, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData & MaskAll, , NoMask, ,BusAccessTests_21);

  HSA(MemAddr, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData & MaskAll, , NoMask, ,BusAccessTests_22);

  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x55555557, , NoMask, ,BusAccessTests_23);
  HSR( , 0xAAAAAAAE, , NoMask, ,BusAccessTests_24);
  TestData+=2;
  HSR( , TestData++, , NoMask, ,BusAccessTests_25);
  HSR( , TestData++, , NoMask, ,BusAccessTests_26);
  HSR( , TestData++, , NoMask, ,BusAccessTests_27);
  HSR( , TestData++, , NoMask, ,BusAccessTests_28);

  C("Adds BUSY in between BURST Writes");
  TestData = 0xCCCCCCCC;
  MemAddr = MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  HSW( , TestData++);

  HSA(MemAddr+=8, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  /** Verify that the BUSY transfer did not modify the Memory data **/
  MemAddr = MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11) + 8;
  TestData = 0x55555555 + 2;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,BusAccessTests_29);

  C("Adds IDLE in between BURST reads");
  TestData = 0xCCCCCCCC;
  MemAddr = MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_30);
  HSR( , TestData++, , NoMask, ,BusAccessTests_31);

  HSA(MemAddr+=8, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++ & MaskAll, , NoMask, ,BusAccessTests_32);

  HSA(MemAddr+=4, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++ & MaskAll, , NoMask, ,BusAccessTests_33);

  TestData = 0xBBBBBBBF;
  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_34);
  HSR( , TestData++, , NoMask, ,BusAccessTests_35);
  HSR( , TestData++, , NoMask, ,BusAccessTests_36);
  HSR( , TestData, , NoMask, ,BusAccessTests_37);

  C("Adds IDLE in between BURST Writes");
  TestData = 0xDDDDDDDD;
  MemAddr = MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  HSW( , TestData++);

  HSA(MemAddr+=8, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr+=4, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , TestData++);
  HSW( , TestData++);
  HSW( , TestData++);
  HSW( , TestData);

  /** Verify that the IDLE transfer did not modify the Memory data **/
  TestData = 0x55555555 + 2;
  MemAddr = MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11) + 8;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x55555557, , NoMask, ,BusAccessTests_38);
  HSR( , 0xAAAAAAAE, , NoMask, ,BusAccessTests_39);
}

/************************************ End *************************************/
