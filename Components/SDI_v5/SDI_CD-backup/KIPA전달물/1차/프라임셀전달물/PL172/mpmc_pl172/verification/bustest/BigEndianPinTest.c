/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001-2002 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : BigEndianPinTest.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This tests the functionality of BigEndian pin.
--
--           TEST ID : MPMC_BigEndPin_1
--
-- --=========================================================================*/

/******************************************************************************/
/****************************** BigEndianPinTest ******************************/
/******************************************************************************/

void BigEndianPinTest()
{
  /*
     Summary: BigEndianPinTest
     =========================
     This function performs the following:

     o  Does the following sequence of tests for Little and Big Endian mode
        of operation:
        - Set the endian pin and apply power on reset and verify that big 
          endian logic is followed for the memory access.
        - Reset the endian pin and again apply power on reset and verify that
          little endian logic is followed for the memory access.
  */
  int hsize, BankNo, Burst;
  char burststr[100];
  int msize[8] = {0, 1, 2, 0};

  /** Set Little endian mode **/
  C("TEST ID : MPMC_BigEndPin_1");
  WriteData(MPMCControl, 0x00000001, "WRD");
  C("Initialize static memory controller register");
  MPMCTrMEMBData[0] = 0x00000000;
  WriteData(MPMCTrExBkOff, 0x00000009, "WRD");
  /* Set Bank 0 Memory Type as SRAM (32 bits width) */
  StInitProc(0,0,0,0,0,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x2,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x2,MPMCTrMEMBData[0],
               0x0);

  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x3,0x3);
  TrickMemInit(1,1,0,0,1,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x3,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,2,0,0,1,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x5,0x3);
  TrickMemInit(2,2,0,0,1,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x5,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (32 bits width) with buffers disabled */
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,0,0,0,0,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x7,0x3);
  TrickMemInit(3,0,0,0,0,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x7,MPMCTrMEMBData[3],
               0x0);
  /* Does the transfers in LITTLE ENDIAN Mode */
  ENDIANNESS = 0;
  C("Configuring the System to LITTLE ENDIAN Mode with nPOR");
  WriteData(MPMCTrCR, 0x00000002, "WRD");
  WaitLoop(0x2);
  WriteData(MPMCTrCR, 0x00000000, "WRD");
  WriteData(MPMCControl, 0x00000001, "WRD");
  HSEN(LITTLE);
  WaitLoop(0x7);
  StInitProc(0,0,0,0,0,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x2,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x2,MPMCTrMEMBData[0],
               0x0);
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x3,0x3);
  TrickMemInit(1,1,0,0,1,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x3,MPMCTrMEMBData[1],
               0x0);
  C("Does the transfers in LITTLE Endian Mode");
  WriteData(0x00000030, 0x00000022, "BYTE");
  
  ReadData(0x00000030, 0x00000022, 0x000000FF, "BYTE");
  /* Does the transfers in BIG ENDIAN Mode */
  ENDIANNESS = 1;
  C("Configuring the System to BIG ENDIAN Mode");
  C("Configuring the System to BIG  Mode with nPOR");
  WriteData(MPMCTrCR, 0x0000000A, "WRD");
  WaitLoop(0x2);
  WriteData(MPMCTrCR, 0x00000008, "WRD");
  WaitLoop(0x2);
  WriteData(MPMCControl, 0x00000001, "WRD");
  WaitLoop(0x7);
  StInitProc(0,0,0,0,0,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x2,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x2,MPMCTrMEMBData[0],
               0x0);
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x3,0x3);
  TrickMemInit(1,1,0,0,1,0,0,0,0,0x3,0x5,0x6,0x7,0x5,0x3,MPMCTrMEMBData[1],
               0x0);

  WaitLoop(0x2);
  C("Does the transfers in BIG Endian Mode");
  ENDIANNESS = 1;
  HSEN(DISABLE);
  WaitLoop(0x2);
  WriteData(0x000000C0, 0x33000000, "BYTE");
  ReadData(0x000000C0, 0x33000000, 0xFF000000, "BYTE");
  
  /* Changing back the ENDIANNESS to LITTLE (default) */
  ENDIANNESS = 0;
  WaitLoop(0x3);
  HSEN(LITTLE);
  WriteData(MPMCTrCR, 0x00000000, "WRD");
}
/************************************ End *************************************/
