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
--  File Name              : DenaliTests.c.rca
--  File Revision          : 1.11
--
--  Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Denali Memory Model based tests on the SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/******************** Denali Memory Model Based Tests *************************/
/******************************************************************************/

void DenaliTests()
{
  /*
     Summary: Denali Memory Model Based Tests
     ========================================
     This function performs the following:

     o  Accesses different banks of the SMC with various combinations of
        different sizes, bursts and transfer types
     o  Accesses are generated randomly using "random" function
  */

  int HSIZE, Burst;
  int32 TestData, WriteData, Bank0Data;
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};

  /** Set Bank 0 Memory Type as SRAM (8 bits width) **/
  /** CSPol = 0, ExtWait disabled **/
  C("Configuring the SMC");
  ConfigureUUT(0, 0x02, 0x02, 0x02, 0x00, 0x00, 0x00000000, 0x000000,
               0x000000);

  /** Set Bank 1 Memory Type as SRAM (16 bits width) **/
  /** CSPol = 0, ExtWait disabled **/
  ConfigureUUT(1, 0x02, 0x02, 0x02, 0x00, 0x00, 0x00000041, 0x000000,
               0x000000);

  /** Set Bank 2 Memory Type as FLASH1 (16 bits width) **/
  /** CSPol = 0, ExtWait disabled **/
  ConfigureUUT(2, 0x02, 0x0A, 0x0A, 0x00, 0x00, 0x00000050, 0x000003,
               0x000005);

  /** Set Bank 3 Memory Type as FLASH2 (16 bits width) **/
  /** CSPol = 0, ExtWait disabled **/
  ConfigureUUT(3, 0x02, 0x09, 0x09, 0x00, 0x00, 0x00000050, 0x000004,
               0x000004);

  /** Set Bank 4 Memory Type as Mask ROM (32 bits width) **/
  /** CSPol = 0, ExtWait disabled **/
  ConfigureUUT(4, 0x02, 0x0A, 0x03, 0x00, 0x00, 0x000000B0, 0x000005,
               0x000006);

  /** Set Bank 5 Memory Type as Mask ROM (32 bits width) **/
  /** CSPol = 0, ExtWait disabled **/
  ConfigureUUT(5, 0x03, 0x0F, 0x07, 0x00, 0x00, 0x000000B0, 0x000002,
               0x000007);

  /** Set Bank 6 Memory Type as SRAM (16 bits width) **/
  /** CSPol = 0, ExtWait disabled **/
  ConfigureUUT(6, 0x04, 0x02, 0x02, 0x00, 0x00, 0x00000041, 0x000000,
               0x000000);

  /** Set Bank 7 Memory Type as SRAM (8 bits width) **/
  /** CSPol = 0, ExtWait disabled **/
  ConfigureUUT(7, 0x02, 0x02, 0x02, 0x00, 0x00, 0x00000000, 0x000000,
               0x000000);

  /** Do the tests in the LITTLE Endian mode **/
  ENDIANNESS = 0;
  C("Configuring the System to LITTLE ENDIAN Mode");
  HSA(SMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ENDIANNESS);
  HSEN(LITTLE);

  for (HSIZE = 0, TestData = 0xA0000000; HSIZE < 3; HSIZE++)
    for (Burst = 7; Burst >= 5; Burst--)
    {
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(0, Burst, 0x00, HSIZE, 0, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(1, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(2, Burst, 0x00, HSIZE, 1, WriteData, 0x5555);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(3, Burst, 0x00, HSIZE, 1, WriteData, 0xAAAA);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(4, Burst, 0x00, HSIZE, 2, WriteData, 0x66666666);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(5, Burst, 0x00, HSIZE, 2, WriteData, 0x6FFFFFE0);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(6, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(7, Burst, 0x00, HSIZE, 0, WriteData);
    }

  for (HSIZE = 0, TestData = 0xA0000000; HSIZE < 3; HSIZE++)
    for (Burst = 3; Burst >= 0; Burst--)
    {
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(0, Burst, 0x00, HSIZE, 0, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(1, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(2, Burst, 0x00, HSIZE, 1, WriteData, 0x5555);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(3, Burst, 0x00, HSIZE, 1, WriteData, 0xAAAA);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(4, Burst, 0x00, HSIZE, 2, WriteData, 0x66666666);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(5, Burst, 0x00, HSIZE, 2, WriteData, 0x6FFFFFE0);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(6, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(7, Burst, 0x00, HSIZE, 0, WriteData);
    }
  
  Burst = 4;
  for (HSIZE = 0, TestData = 0xA0000000; HSIZE < 3; HSIZE++)
    {
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(0, Burst, 0x00, HSIZE, 0, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(1, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(2, Burst, 0x00, HSIZE, 1, WriteData, 0x5555);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(3, Burst, 0x00, HSIZE, 1, WriteData, 0xAAAA);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(4, Burst, 0x00, HSIZE, 2, WriteData, 0x66666666);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(5, Burst, 0x00, HSIZE, 2, WriteData, 0x6FFFFFE0);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(6, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(7, Burst, 0x00, HSIZE, 0, WriteData);
    }

  /** Do the tests in the BIG Endian mode **/
  ENDIANNESS = 1;
  C("Configuring the System to BIG ENDIAN Mode");
  HSA(SMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ENDIANNESS);
  HSEN(DISABLE);

  for (HSIZE = 0, TestData = 0x10000000; HSIZE < 3; HSIZE++)
    for (Burst = 0; Burst < 4; Burst++)
    {
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(0, Burst, 0x00, HSIZE, 0, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(1, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(2, Burst, 0x00, HSIZE, 1, WriteData, 0x5555);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(3, Burst, 0x00, HSIZE, 1, WriteData, 0xAAAA);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(4, Burst, 0x00, HSIZE, 2, WriteData, 0x66666666);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(5, Burst, 0x00, HSIZE, 2, WriteData, 0x6FFFFFE0);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(6, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(7, Burst, 0x00, HSIZE, 0, WriteData);
    }

  for (HSIZE = 0, TestData = 0x10000000; HSIZE < 3; HSIZE++)
    for (Burst = 5; Burst < 8; Burst++)
    {
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(0, Burst, 0x00, HSIZE, 0, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(1, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(2, Burst, 0x00, HSIZE, 1, WriteData, 0x5555);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(3, Burst, 0x00, HSIZE, 1, WriteData, 0xAAAA);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(4, Burst, 0x00, HSIZE, 2, WriteData, 0x66666666);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(5, Burst, 0x00, HSIZE, 2, WriteData, 0x6FFFFFE0);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(6, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(7, Burst, 0x00, HSIZE, 0, WriteData);
    }

  Burst = 4;
  for (HSIZE = 0, TestData = 0xA0000000; HSIZE < 3; HSIZE++)
    {
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(0, Burst, 0x00, HSIZE, 0, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(1, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(2, Burst, 0x00, HSIZE, 1, WriteData, 0x5555);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(3, Burst, 0x00, HSIZE, 1, WriteData, 0xAAAA);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(4, Burst, 0x00, HSIZE, 2, WriteData, 0x66666666);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(5, Burst, 0x00, HSIZE, 2, WriteData, 0x6FFFFFE0);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(6, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(7, Burst, 0x00, HSIZE, 0, WriteData);
    }

  /** Do the REMAP tests in the LITTLE Endian mode **/
  ENDIANNESS = 0;
  C("Configuring the System to LITTLE ENDIAN Mode");
  HSEN(LITTLE);

  ToggleREMAP(0x11, 0xAA);

  /** Do the REMAP tests in the BIG Endian mode **/
  ENDIANNESS = 1;
  C("Configuring the System to BIG ENDIAN Mode");
  HSEN(DISABLE);

  ToggleREMAP(0x55, 0x77);

  /** Changing back the ENDIANNESS to LITTLE (default) **/
  ENDIANNESS = 0;
  HSEN(LITTLE);
  HSA(SMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ENDIANNESS);
}

/************************************ End *************************************/
