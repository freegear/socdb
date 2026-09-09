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
--  File Name              : ProtectionTests.c.rca
--  File Revision          : 1.17
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform write protection and bus error flag tests on
--           the SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/***************** Write Protection and Bus Error flag Tests ******************/
/******************************************************************************/

void ProtectionTests()
{
  /*
     Summary: Write Protection and Bus Error flag Tests
     ==================================================
     This function performs the following:

     o  Checks the setting and clearing logic of the BUSERR and WPERR flags
     o  Checks WPERR flag for Write Protection mode of SRAMs
  */

  char size[3] = {'b', 'h', 'w'};
  int32 TempMSIZE, BCRData, MemAddr, MemType, TestData;

  /** Set Bank 0 Memory Type as ROM (32 bits width) **/
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x01, 0x02, 0x03, 0x01, 0x00, 0x00000090, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x01, 0x02, 0x03, 0x006, SMCTrMEMBData[0], 0x01,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as ROM (32 bits width) **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x01, 0x02, 0x03, 0x01, 0x00, 0x00000090, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x01, 0x02, 0x03, 0x006, SMCTrMEMBData[0], 0x01,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as ROM (32 bits width) **/
  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x01, 0x02, 0x03, 0x01, 0x00, 0x00000090, 0x000000,
               0x000000);
  ConfigureMemory(2, 0x01, 0x02, 0x03, 0x006, SMCTrMEMBData[0], 0x01,
                  0x00, 0x000000);

  /** Set Bank 4 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[4] = 0x00000000;
  ConfigureUUT(4, 0x01, 0x02, 0x03, 0x01, 0x00, 0x00000080, 0x000000,
               0x000000);
  ConfigureMemory(4, 0x01, 0x02, 0x03, 0x002, SMCTrMEMBData[4], 0x01,
                  0x00, 0x000000);

  /** Set Bank 5 Memory Type as ROM (32 bits width) **/
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x03, 0x07, 0x00, 0x03, 0x00, 0x00000090, 0x000000,
               0x000000);
  ConfigureMemory(5, 0x03, 0x07, 0x00, 0x006, SMCTrMEMBData[5], 0x03,
                  0x00, 0x000000);

  /** Set Bank 6 Memory Type as BROM (8 bits width) **/
  SMCTrMEMBData[6] = 0x00000000;
  ConfigureUUT(6, 0x04, 0x0B, 0x07, 0x04, 0x00, 0x00000030, 0x000000,
               0x000000);
  ConfigureMemory(6, 0x04, 0x0B, 0x07, 0x038, SMCTrMEMBData[6], 0x04,
                  0x00, 0x000000);

  /** Set Bank 7 Memory Type as BROM (16 bits width) **/
  SMCTrMEMBData[7] = 0x00000000;
  ConfigureUUT(7, 0x04, 0x0B, 0x07, 0x04, 0x00, 0x00000070, 0x000000,
               0x000000);
  ConfigureMemory(7, 0x04, 0x0B, 0x07, 0x039, SMCTrMEMBData[7], 0x04,
                  0x00, 0x000000);

  /** Initialise the ROM/BROMs from AHB side **/
  AHBWriteMem(0, 0, 4, 0xAABBCCDD);
  AHBWriteMem(5, 0, 4, 0x11223344);
  AHBWriteMem(6, 0, 4, 0x00000055);
  AHBWriteMem(7, 0, 4, 0x0000AABB);

#ifdef TmpHSizeErrTst
  /** Write into the SMC register with a HSIZE != WRD **/
  /* HSA(SMBIDCYR4, NSEQ, INCR, ERROR, HWRD, , 0x1, , , , ,); */
  HSA(SMBIDCYR4, NSEQ, INCR, , HWRD, , 0x1, , , , ,);
  HSW( , 0xAAAAAAAA);

  /** Read the Status Register for No BusErr Error **/
  ReadStatus(4, ZERO);
#endif

  /** Checks for the unmodified data **/
  HSA(SMBIDCYR4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000001, , NoMask, ,ProtectionTests_1);

#ifdef TmpHSizeErrTst
  /** Write into the SMC register with a HSIZE != WRD **/
  HSA(SMBWST1R5, NSEQ, INCR, ERROR, BYTE, , 0x1, , , , ,);
  HSW( , 0x55555555);

  /** Read the Status Register for No BusErr Error **/
  ReadStatus(5, ZERO);
#endif

  /** Checks for the unmodified data **/
  HSA(SMBWST1R5, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x00000007, , NoMask, ,ProtectionTests_2);

#ifdef TmpHSizeErrTst
  /** Read from the SMC register with a HSIZE != WRD **/
  HSA(SMBWST2R6, NSEQ, INCR, ERROR, HWRD, , 0x1, , , , ,);
  HSR( , 0x00000000, , MaskAll, ,ProtectionTests_3);

  /** Read the Status Register for No BusErr Error **/
  ReadStatus(6, ZERO);
#endif

  /** Write into the ROM (Bank 5) through the SMC **/
  MemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x44332211);

  /** Read the Status Register for WriteProt Error **/
  ReadStatus(5, 0x02);

  /** Checks for the unmodified data **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , NoMask, ,ProtectionTests_4);

  C("Accessing different Read Only Memory Banks");
  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0xA1B2C3D4);

  MemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0xABCDEF01);

  MemAddr = SMCMEM_6 + (SMCTrMEMBData[6] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x12345678);

  MemAddr = SMCMEM_7 + (SMCTrMEMBData[7] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, HWRD, , 0x1, , , , ,);
  HSW( , 0x00005678);

  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 4;
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0xAB12CD34);

  MemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11) + 4;
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x87654321);

  MemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11) + 8;
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x11112222);

  MemAddr = SMCMEM_6 + (SMCTrMEMBData[6] << 11) + 1;
  HSA(MemAddr, NSEQ, INCR, ERROR, BYTE, , 0x1, , , , ,);
  HSW( , 0x00000033);

  MemAddr = SMCMEM_7 + (SMCTrMEMBData[7] << 11) + 2;
  HSA(MemAddr, NSEQ, INCR, ERROR, HWRD, , 0x1, , , , ,);
  HSW( , 0x00001234);

  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 8;
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x11223344);

  MemAddr = SMCMEM_6 + (SMCTrMEMBData[6] << 11) + 2;
  HSA(MemAddr, NSEQ, INCR, ERROR, BYTE, , 0x1, , , , ,);
  HSW( , 0x00000044);

  MemAddr = SMCMEM_6 + (SMCTrMEMBData[6] << 11) + 3;
  HSA(MemAddr, NSEQ, INCR, ERROR, BYTE, , 0x1, , , , ,);
  HSW( , 0x00000055);

  MemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11) + 12;
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x87654321);

  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + 12;
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x12345678);

  MemAddr = SMCMEM_7 + (SMCTrMEMBData[7] << 11) + 4;
  HSA(MemAddr, NSEQ, INCR, ERROR, HWRD, , 0x1, , , , ,);
  HSW( , 0x00008765);

  /** Read the Status Register for WriteProt Error **/
  HSA(SMBSR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x00000002, , NoMask, ,ProtectionTests_5);
  HSA(SMBSR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x00000002, , NoMask, ,ProtectionTests_6);
  HSA(SMBSR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x00000002, , NoMask, ,ProtectionTests_7);
  HSA(SMBSR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x00000002, , NoMask, ,ProtectionTests_8);

  /** Clear the Status bits **/
  HSA(SMBSR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x00000007);
  HSA(SMBSR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x00000007);
  HSA(SMBSR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x00000007);
  HSA(SMBSR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x00000007);

  /** Checks for the unmodified data **/
  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11);
  TestData = 0xAABBCCDD;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,ProtectionTests_9);
  HSR( , TestData++, , NoMask, ,ProtectionTests_10);
  HSR( , TestData++, , NoMask, ,ProtectionTests_11);
  HSR( , TestData, , NoMask, ,ProtectionTests_12);

  MemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  TestData = 0x11223344;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,ProtectionTests_13);
  HSR( , TestData++, , NoMask, ,ProtectionTests_14);
  HSR( , TestData++, , NoMask, ,ProtectionTests_15);
  HSR( , TestData, , NoMask, ,ProtectionTests_16);

  MemAddr = SMCMEM_6 + (SMCTrMEMBData[6] << 11);
  TestData = 0x00000055;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,ProtectionTests_17);

  MemAddr = SMCMEM_7 + (SMCTrMEMBData[7] << 11);
  TestData = 0x0000AABB;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x0000AABB, , NoMask, ,ProtectionTests_18);
  HSA(MemAddr+4, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , 0x0000AABC, , HWUnMaskL, ,ProtectionTests_19);
}

/************************************ End *************************************/
