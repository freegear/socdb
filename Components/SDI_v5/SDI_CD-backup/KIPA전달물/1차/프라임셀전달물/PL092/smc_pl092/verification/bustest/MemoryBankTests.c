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
--  File Name              : MemoryBankTests.c.rca
--  File Revision          : 1.10
--
--  Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform tests to check the operation of the SMC across
--           the bank.
--
-- --=========================================================================*/

/******************************************************************************/
/************************* Multiple Memory Bank Tests *************************/
/******************************************************************************/

void MemoryBankTests()
{
  /*
     Summary: Multiple Memory Bank Tests
     ===================================
     This function performs the following:

     o  Programs the different banks as different types and with different
        parameters
     o  Accesses the memory from AHB with different addresses such that it
        makes the SMC access different banks
  */

  int Burst, i;
  char size[3] = {'b', 'h', 'w'};
  int32 MemAddr, TestData;

  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x00, 0x1F, 0x1F, 0x00, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x00, 0x1F, 0x1F, 0x042, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (16 bits width) **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x01, 0x02, 0x03, 0x01, 0x02, 0x00000041, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x01, 0x02, 0x03, 0x041, SMCTrMEMBData[1], 0x01,
                  0x02, 0x000000);

  /** Set Bank 2 Memory Type as SRAM (8 bits width) **/
  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x00, 0x08, 0x08, 0x00, 0x00, 0x00000000, 0x000000,
               0x000000);
  ConfigureMemory(2, 0x00, 0x08, 0x08, 0x000, SMCTrMEMBData[2], 0x00,
                  0x00, 0x000000);

  C("Accessing different Banks");
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + 0x7DC;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0xABCDEF01);

  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 0x7D0;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x12345678);

  MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11) + 0x004;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x87654321);

  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + 0x008;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x11112222);

  MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11) + 0x00C;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x22223333);

  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 0x010;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x33334444);

  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + 0x014;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x44445555);

  /** Reading the written data **/
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + 0x7DC;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0xABCDEF01, , NoMask, ,MemoryBankTests_1);

  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 0x7D0;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x12345678, , NoMask, ,MemoryBankTests_2);

  MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11) + 0x004;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x87654321, , NoMask, ,MemoryBankTests_2);

  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + 0x008;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x11112222, , NoMask, ,MemoryBankTests_3);

  MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11) + 0x00C;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x22223333, , NoMask, ,MemoryBankTests_4);

  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 0x010;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x33334444, , NoMask, ,MemoryBankTests_5);

  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + 0x014;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x44445555, , NoMask, ,MemoryBankTests_6);
}

/************************************ End *************************************/
