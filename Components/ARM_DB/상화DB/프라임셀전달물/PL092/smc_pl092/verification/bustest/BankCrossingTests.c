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
--  File Name              : BankCrossingTests.c.rca
--  File Revision          : 1.10
--
--  Release Information    : PrimeCell(TM)-PL092-REL1v1
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform transfers such that they cross banks
--
-- --=========================================================================*/

/******************************************************************************/
/***************************** Bank Crossing Tests ****************************/
/******************************************************************************/

void BankCrossingTests()
{
  /*
     Summary: Bank Crossing Tests
     ============================
     This function performs the following:

     o  Does various BURST accesses of various lengths to the Memory such that
        they cross banks
     o  BURSTs are started
        - At different word boundaries and quadword boundaries with INCR4,
          INCR8, INCR16, WRAP4, WRAP8 and WRAP16
        - With HSIZE as BYTE, HWRD and WRD
     o  Repeats the tests with various values of WST1, WST2, CS2OEN, CS2WEN
        and IDCY
  */

  int HSIZE, BURST;
  int32 MemAddr, TestData;
  int32 AddrMask[3] = {0x3, 0x2, 0x0};
  char PrtString[75];
  char* BurstString[8] = {"SINGLE", "INCR", "INCR4", "INCR8",
                          "INCR16", "WRAP4", "WRAP8", "WRAP16"};
  char* SizeString[3] = {"BYTE", "HALFWORD", "WORD"};

  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[0] = 0x00007FFF;
  ConfigureUUT(0, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x02, 0x05, 0x04, 0x042, SMCTrMEMBData[0], 0x02,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (16 bits width) **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000041, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x02, 0x05, 0x04, 0x041, SMCTrMEMBData[1], 0x02,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as SRAM (8 bits width) **/
  SMCTrMEMBData[2] = 0x00007FFF;
  ConfigureUUT(2, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000000, 0x000000,
               0x000000);
  ConfigureMemory(2, 0x02, 0x05, 0x04, 0x000, SMCTrMEMBData[2], 0x02,
                  0x00, 0x000000);

  /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(3, 0x02, 0x05, 0x04, 0x042, SMCTrMEMBData[3], 0x02,
                  0x00, 0x000000);

  /** Set Bank 4 Memory Type as SRAM (16 bits width) **/
  SMCTrMEMBData[4] = 0x00007FFF;
  ConfigureUUT(4, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000041, 0x000000,
               0x000000);
  ConfigureMemory(4, 0x02, 0x05, 0x04, 0x041, SMCTrMEMBData[4], 0x02,
                  0x00, 0x000000);

  /** Set Bank 5 Memory Type as SRAM (8 bits width) **/
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x03, 0x07, 0x00, 0x03, 0x00, 0x00000000, 0x000000,
               0x000000);
  ConfigureMemory(5, 0x03, 0x07, 0x00, 0x000, SMCTrMEMBData[5], 0x03,
                  0x00, 0x000000);

  /** Set Bank 6 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[6] = 0x00007FFF;
  ConfigureUUT(6, 0x04, 0x06, 0x02, 0x04, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(6, 0x04, 0x06, 0x02, 0x042, SMCTrMEMBData[6], 0x04,
                  0x00, 0x000000);

  /** Set Bank 7 Memory Type as SRAM (16 bits width) **/
  SMCTrMEMBData[7] = 0x00000000;
  ConfigureUUT(7, 0x02, 0x05, 0x01, 0x04, 0x00, 0x00000041, 0x000000,
               0x000000);
  ConfigureMemory(7, 0x02, 0x05, 0x01, 0x041, SMCTrMEMBData[7], 0x04,
                  0x00, 0x000000);

  TestData = 0x00123456;
  for (HSIZE = 0; HSIZE<3; HSIZE++)
  {
    for (BURST = 0; BURST<8; BURST++)
    {
      sprintf(PrtString, "Performing Burst Write-Reads with HSIZE = %s, BURST = %s", SizeString[HSIZE], BurstString[BURST]);
      C(PrtString);
      MemWriteRead(0, BURST, 0x7F8 & AddrMask[HSIZE], HSIZE, 0x2, TestData);
      TestData+= 0x00111111;
      MemWriteRead(1, BURST, 0x7F9 & AddrMask[HSIZE], HSIZE, 0x1, TestData);
      TestData+= 0x00111111;
      MemWriteRead(2, BURST, 0x7FA & AddrMask[HSIZE], HSIZE, 0x0, TestData);
      TestData+= 0x00111111;
      MemWriteRead(3, BURST, 0x7FB & AddrMask[HSIZE], HSIZE, 0x2, TestData);
      TestData+= 0x00111111;
      MemWriteRead(4, BURST, 0x7FC & AddrMask[HSIZE], HSIZE, 0x1, TestData);
      TestData+= 0x00111111;
      MemWriteRead(5, BURST, 0x7FD & AddrMask[HSIZE], HSIZE, 0x0, TestData);
      TestData+= 0x00111111;
      MemWriteRead(6, BURST, 0x7FE & AddrMask[HSIZE], HSIZE, 0x2, TestData);
      TestData+= 0x00111111;
      MemWriteRead(7, BURST, 0x7FF & AddrMask[HSIZE], HSIZE, 0x1, TestData);
      TestData+= 0x00111111;
    }
  }
}

/************************************ End *************************************/
