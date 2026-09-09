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
--  File Name              : AddrToggleTests.c.rca
--  File Revision          : 1.17
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to toggle all the memory related address bits of the SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/**************************** Address Toggle Tests ****************************/
/******************************************************************************/

void AddrToggleTests()
{
  /*
     Summary: Address Toggle Tests
     =============================
     This function performs the following:

     o  Toggles all memory related address bits in the SMC.

     The TrickMem is designed with a memory size of 8K. The remaining higher
     order address is specified in the base address register SMCTrMEMB.
     For toggling all the 29 lines of address, locations 0x00000000,
     0x55555555, 0xAAAAAAAA and 0xFFFFFFFF are accessed.
  */

  int i, j, Bank_No;
  int32 SMCMemAddr, AHBMemAddr;

  /** Reading from the Memory before it's configured **/
  SMCMemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  HSA(SMCMemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , ZERO, , NoMask, ,AddrToggleTests_1);

  /** Set the parameters for the Memory Model **/
  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000080, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x02, 0x05, 0x04, 0x002, SMCTrMEMBData[0], 0x02,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000080, 0x000000,
               0x000000);
  ConfigureMemory(2, 0x02, 0x05, 0x04, 0x002, SMCTrMEMBData[2], 0x02,
                  0x00, 0x000000);

  /** Set Bank 5 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000080, 0x000000,
               0x000000);
  ConfigureMemory(5, 0x02, 0x05, 0x04, 0x002, SMCTrMEMBData[5], 0x02,
                  0x00, 0x000000);

  /** Set Bank 7 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[7] = 0x00000000;
  ConfigureUUT(7, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000080, 0x000000,
               0x000000);
  ConfigureMemory(7, 0x02, 0x05, 0x04, 0x002, SMCTrMEMBData[7], 0x02,
                  0x00, 0x000000);

  /** Writing to Bank 0 through the SMC **/
  SMCMemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 10) + 0x000;
  HSA(SMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x00000078);

  /** Reading from Bank 0 through the SMC **/
  HSA(SMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSR( , 0x00000078, , 0x000000FF, ,AddrToggleTests_2);

  /** Reading from Bank 0 through the AHB **/
  AHBMemAddr = SMCTrMEMR_0;
  HSA(AHBMemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x00000078, , 0x000000FF, ,AddrToggleTests_3);

  /** Writing to Bank 2 through the SMC **/
  SMCMemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11) + 0x2AA;
  HSA(SMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x00000021);

  /** Reading from Bank 2 through the SMC **/
  HSA(SMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSR( , 0x00210000, , 0x00FF0000, ,AddrToggleTests_4);

  /** Reading from Bank 2 through the AHB **/
  AHBMemAddr = SMCTrMEMR_2 + 0x02A8;
  HSA(AHBMemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x00210000, , 0x00FF0000, ,AddrToggleTests_5);

  /** Writing to Bank 5 through the SMC **/
  SMCMemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11) + 0x555;
  HSA(SMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x00000078);

  /** Reading from Bank 5 through the SMC **/
  HSA(SMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSR( , 0x00007800, , 0x0000FF00, ,AddrToggleTests_6);

  /** Reading from Bank 5 through the AHB **/
  AHBMemAddr = SMCTrMEMR_5 + 0x554;
  HSA(AHBMemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x00007800, , 0x0000FF00, ,AddrToggleTests_7);

  /** Writing to Bank 7 through the SMC **/
  SMCMemAddr = SMCMEM_7 + (SMCTrMEMBData[7] << 11) + 0x7FF;
  HSA(SMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x00000021);

  /** Reading from Bank 5 through the SMC **/
  HSA(SMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSR( , 0x21000000, , 0xFF000000, ,AddrToggleTests_8);

  /** Reading from Bank 7 through the AHB **/
  AHBMemAddr = SMCTrMEMR_7 + 0x7FC; 
  HSA(AHBMemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x21000000, , 0xFF000000, ,AddrToggleTests_9);
}

/************************************ End *************************************/
