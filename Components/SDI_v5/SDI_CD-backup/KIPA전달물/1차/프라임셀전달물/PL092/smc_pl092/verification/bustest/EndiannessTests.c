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
--  File Name              : EndiannessTests.c.rca
--  File Revision          : 1.10
--
--  Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform different types of transfers.
--
-- --=========================================================================*/

/******************************************************************************/
/****************************** Endianness Tests ******************************/
/******************************************************************************/

void EndiannessTests()
{
  /*
     Summary: Endianness Tests
     =========================
     This function performs the following:

     o  Does the following sequence of tests for Little and Big Endian mode
        of operation:
        - Memory configured as 32 bits. Transactions are initiated from the
          AHB with different HSIZE and HBURST values. The written data patterns
          are read back from Memory via both the AHB interface of the TrickMem
          and the SMC.
        - Memory configured as 16 bits. Transactions are initiated from the
          AHB with different HSIZE and HBURST values. The written data patterns
          are read back from Memory via both the AHB interface of the TrickMem
          and the SMC.
        - Memory configured as 8 bits. Transactions are initiated from the
          AHB with different HSIZE and HBURST values. The written data patterns
          are read back from Memory via both the AHB interface of the TrickMem
          and the SMC.
  */

  int hsize, BankNo, Burst;
  int msize[8] = {2, 1, 0, 2, 1, 0, 2, 1};
  int32 TestData[8] = {0x11111111, 0x22222222, 0x33333333, 0x44444444,
                       0x55555555, 0x66666666, 0x77777777, 0x88888888};

  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** CSPol = 0, ExtWait disabled **/
  C("Configuring the SMC and the Memory Blocks");
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x02, 0x05, 0x04, 0x042, SMCTrMEMBData[0], 0x02,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (16 bits width) **/
  /** CSPol = 1, ExtWait disabled **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000049, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x02, 0x05, 0x04, 0x0C1, SMCTrMEMBData[1], 0x02,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as SRAM (8 bits width) **/
  SMCTrMEMBData[2] = 0x00000000;
  /** CSPol = 0, ExtWait enabled **/
  ConfigureUUT(2, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000004, 0x000002,
               0x000005);
  ConfigureMemory(2, 0x02, 0x05, 0x04, 0x100, SMCTrMEMBData[2], 0x02,
                  0x00, 0x000000);

  /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  /** CSPol = 1, ExtWait enabled **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x02, 0x05, 0x04, 0x02, 0x00, 0x0000008D, 0x000003,
               0x000006);
  ConfigureMemory(3, 0x02, 0x05, 0x04, 0x1C2, SMCTrMEMBData[3], 0x02,
                  0x00, 0x000000);

  /** Set Bank 4 Memory Type as SRAM (16 bits width) **/
  SMCTrMEMBData[4] = 0x00000000;
  /** CSPol = 0, ExtWait enabled **/
  ConfigureUUT(4, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000045, 0x000002,
               0x000006);
  ConfigureMemory(4, 0x02, 0x05, 0x04, 0x541, SMCTrMEMBData[4], 0x02,
                  0x00, 0x000000);

  /** Set Bank 5 Memory Type as SRAM (8 bits width) **/
  /** CSPol = 1, ExtWait enabled **/
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x03, 0x07, 0x00, 0x03, 0x00, 0x0000000C, 0x000003,
               0x000003);
  ConfigureMemory(5, 0x03, 0x07, 0x00, 0x580, SMCTrMEMBData[5], 0x03,
                  0x00, 0x000000);

  /** Set Bank 6 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[6] = 0x00000000;
  /** CSPol = 0, ExtWait disabled **/
  ConfigureUUT(6, 0x04, 0x06, 0x02, 0x04, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(6, 0x04, 0x06, 0x02, 0x042, SMCTrMEMBData[6], 0x04,
                  0x00, 0x000000);

  /** Set Bank 7 Memory Type as SRAM (16 bits width) **/
  /** CSPol = 1, ExtWait disabled **/
  SMCTrMEMBData[7] = 0x00000000;
  ConfigureUUT(7, 0x02, 0x05, 0x01, 0x04, 0x00, 0x00000048, 0x000000,
               0x000000);
  ConfigureMemory(7, 0x02, 0x05, 0x01, 0x081, SMCTrMEMBData[7], 0x04,
                  0x00, 0x000000);

  /** Does the transfers in LITTLE ENDIAN Mode **/
  ENDIANNESS = 0;
  C("Configuring the System to LITTLE ENDIAN Mode");
  HSA(SMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ENDIANNESS);
  HSEN(LITTLE);
  C("Does the transfers in LITTLE Endian Mode");
  for (BankNo=0; BankNo<8; BankNo++)
    for (hsize=0; hsize<3; hsize++)
      for (Burst = 7; Burst >= 0; Burst--)
        BurstWriteRead(BankNo, Burst, 0, hsize, msize[BankNo], TestData[Burst]);

  /** Does the transfers in BIG ENDIAN Mode **/
  ENDIANNESS = 1;
  C("Configuring the System to BIG ENDIAN Mode");
  HSA(SMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ENDIANNESS);
  HSEN(DISABLE);
  C("Does the transfers in BIG Endian Mode");
  for (BankNo=0; BankNo<8; BankNo++)
    for (hsize=0; hsize<3; hsize++)
      for (Burst = 7; Burst >= 0; Burst--)
        BurstWriteRead(BankNo, Burst, 0, hsize, msize[BankNo], TestData[Burst]);

  /** Changing back the ENDIANNESS to LITTLE (default) **/
  ENDIANNESS = 0;
  HSEN(LITTLE);
  HSA(SMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ENDIANNESS);
}

/************************************ End *************************************/
