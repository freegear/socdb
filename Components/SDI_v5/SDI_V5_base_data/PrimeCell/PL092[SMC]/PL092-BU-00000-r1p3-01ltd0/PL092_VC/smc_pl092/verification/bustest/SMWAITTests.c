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
--  File Name              : SMWAITTests.c.rca
--  File Revision          : 1.17
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform tests on external wait functionality of the
--           SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/******************************** SMWAIT Tests ********************************/
/******************************************************************************/

void SMWAITTests()
{
  /*
     Summary: SMWAIT Tests
     =====================
     This function performs the following:

     o  SMWAIT signal is asserted and de-asserted in various possible ways
     o  Repeats tests for read and write accesses and different polarities
  */

  int i, j, BankNo, n;
  char* ExpResp = OK;
  int32 TestCEWT[4] = {0x000003, 0x000005, 0x00000A, 0x000021};
  int32 TestCS2WT[3] = {0x000003, 0x00000A, 0x000021};
  int32 SMCTrCS2WT, SMCTrCEWT, TestData, TestWrite = 0x00000000;
  int32 BSRData, MemAddr, SMBSRAddr, Mask;

  C("Configuring the SMC and the Memory banks with SMWAIT Enabled");
  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled, WaitPol = 0 **/
  /** Boundary Case disabled **/
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x1F, 0x1F, 0x02, 0x00, 0x00000085, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x02, 0x1F, 0x1F, 0x142, SMCTrMEMBData[0], 0x02,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled, WaitPol = 0 **/
  /** Boundary Case disabled **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x1F, 0x1F, 0x02, 0x00, 0x00000085, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x02, 0x1F, 0x1F, 0x142, SMCTrMEMBData[1], 0x02,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[2] = 0x00000000;
  /** ExtWait Enabled, WaitPol = 0 **/
  /** Boundary Case enabled **/
  ConfigureUUT(2, 0x02, 0x1F, 0x1F, 0x02, 0x00, 0x00000085, 0x000000,
               0x000000);
  ConfigureMemory(2, 0x02, 0x1F, 0x1F, 0x542, SMCTrMEMBData[2], 0x02,
                  0x00, 0x000000);

  /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled, WaitPol = 0 **/
  /** Boundary Case enabled **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x02, 0x1F, 0x1F, 0x02, 0x00, 0x00000085, 0x000000,
               0x000000);
  ConfigureMemory(3, 0x02, 0x00, 0x04, 0x542, SMCTrMEMBData[3], 0x02,
                  0x00, 0x000000);

  /** Set Bank 4 Memory Type as SRAM (16 bits width) **/
  SMCTrMEMBData[4] = 0x00000000;
  /** ExtWait Enabled, WaitPol = 0 **/
  /** Boundary Case disabled **/
  ConfigureUUT(4, 0x02, 0x1F, 0x1F, 0x02, 0x00, 0x00000045, 0x000000,
               0x000000);
  ConfigureMemory(4, 0x02, 0x1F, 0x1F, 0x141, SMCTrMEMBData[4], 0x02,
                  0x00, 0x000000);

  /** Set Bank 5 Memory Type as SRAM (16 bits width) **/
  /** ExtWait Enabled, WaitPol = 0 **/
  /** Boundary Case disabled **/
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x03, 0x1F, 0x1F, 0x03, 0x00, 0x00000045, 0x000000,
               0x000000);
  ConfigureMemory(5, 0x03, 0x1F, 0x1F, 0x141, SMCTrMEMBData[5], 0x03,
                  0x00, 0x000000);

  /** Set Bank 6 Memory Type as SRAM (8 bits width) **/
  SMCTrMEMBData[6] = 0x00000000;
  /** ExtWait Enabled, WaitPol = 0 **/
  /** Boundary Case disabled **/
  ConfigureUUT(6, 0x04, 0x1F, 0x1F, 0x04, 0x00, 0x00000004, 0x000000,
               0x000000);
  ConfigureMemory(6, 0x04, 0x1F, 0x1F, 0x100, SMCTrMEMBData[6], 0x04,
                  0x00, 0x000000);

  /** Set Bank 7 Memory Type as SRAM (8 bits width) **/
  /** ExtWait Enabled, WaitPol = 0 **/
  /** Boundary Case disabled **/
  SMCTrMEMBData[7] = 0x00000000;
  ConfigureUUT(7, 0x02, 0x1F, 0x1F, 0x05, 0x00, 0x00000004, 0x000000,
               0x000000);
  ConfigureMemory(7, 0x02, 0x1F, 0x1F, 0x100, SMCTrMEMBData[7], 0x05,
                  0x00, 0x000000);
 /* TODO */
 
  HSA(SMCTrCNCLWAIT, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0x3FF);
  /** Initially fill the Memory Banks with 0s **/
  for (i=0; i<8; i++)
    AHBFillMem(i, 0, 4, 0x00000000);

  for (BankNo=0; BankNo<8; BankNo++)
  {
    switch (BankNo)
    {
      case 0 : SMCTrCS2WT = SMCTrCS2WTR0;
               SMCTrCEWT  = SMCTrCEWTR0;
               SMBSRAddr  = SMBSR0;
               MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11); break;
      case 1 : SMCTrCS2WT = SMCTrCS2WTR1;
               SMCTrCEWT  = SMCTrCEWTR1;
               SMBSRAddr  = SMBSR1;
               MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11); break;
      case 2 : SMCTrCS2WT = SMCTrCS2WTR2;
               SMCTrCEWT  = SMCTrCEWTR2;
               SMBSRAddr  = SMBSR2;
               MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11); break;
      case 3 : SMCTrCS2WT = SMCTrCS2WTR3;
               SMCTrCEWT  = SMCTrCEWTR3;
               SMBSRAddr  = SMBSR3;
               MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11); break;
      case 4 : SMCTrCS2WT = SMCTrCS2WTR4;
               SMCTrCEWT  = SMCTrCEWTR4;
               SMBSRAddr  = SMBSR4;
               MemAddr = SMCMEM_4 + (SMCTrMEMBData[4] << 11); break;
      case 5 : SMCTrCS2WT = SMCTrCS2WTR5;
               SMCTrCEWT  = SMCTrCEWTR5;
               SMBSRAddr  = SMBSR5;
               MemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11); break;
      case 6 : SMCTrCS2WT = SMCTrCS2WTR6;
               SMCTrCEWT  = SMCTrCEWTR6;
               SMBSRAddr  = SMBSR6;
               MemAddr = SMCMEM_6 + (SMCTrMEMBData[6] << 11); break;
      case 7 : SMCTrCS2WT = SMCTrCS2WTR7;
               SMCTrCEWT  = SMCTrCEWTR7;
               SMBSRAddr  = SMBSR7;
               MemAddr = SMCMEM_7 + (SMCTrMEMBData[7] << 11); break;
      default : break;
    }

    for (i=0; i<4; i++)
    {
      /** Reconfigure CEWT Register **/
      C("Reconfiguring the SMCTrCEWT Register");
      HSA(SMCTrCEWT, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , TestCEWT[i]);
      for (j=0; j<3; j++, TestWrite+=0x00111111)
      {
        /** Reconfigure CS2WT Register **/
        C("Reconfiguring the SMCTrCS2WT Register");
        HSA(SMCTrCS2WT, NSEQ, INCR, , WRD, , 0x1, , , , ,);
        HSW( , TestCS2WT[j] | 0x2000000);
        if ((TestCEWT[i] > 32) && (TestCS2WT[j] < 32))
        {
          BSRData = 0x04;
          ExpResp = ERROR;
          Mask = MaskAll;
        } else
        {
          BSRData = 0x00;
          ExpResp = OK;
          Mask = NoMask;
        }

        /** Write into the SMC **/
        TestData = TestWrite;
        C("Writing into the Memory through the SMC");
        HSA(MemAddr, NSEQ, INCR, ExpResp, WRD, , 0x1, , , , ,);
        HSW( , TestData++);
        for (n=0; n<3; n++)
          HSW( , TestData++);

        /** Read from the SMC **/
        TestData = TestWrite;
        C("Reading from the Memory through the SMC");
        HSA(MemAddr, NSEQ, INCR, ExpResp, WRD, , 0x1, , , , ,);
        HSR( , TestData & Mask, , NoMask, ,SMWAITTests_1);
        for (n=0, TestData++; n<3; n++, TestData++)
          HSR( , TestData & Mask, , NoMask, ,SMWAITTests_2);

        /** Read the Status register **/
        C("Reading the Status Register");
        HSA(SMCTrMCREQD, NSEQ, SINGLE, , WRD, , 0x0, , , , ,);
        HSW( , ZERO);
        HSA(SMCTrMCREQD, NSEQ, SINGLE, , WRD, , 0x0, , , , ,);
        HSW( , ZERO);
        HSA(SMCTrMCREQD, NSEQ, SINGLE, , WRD, , 0x0, , , , ,);
        HSW( , ZERO);
        HSA(SMBSRAddr, NSEQ, SINGLE, , WRD, , 0x0, , , , ,);
        HPO( , BSRData, , NoMask, , 0xFF,SMWAITTests_3);
        HSA(SMBSRAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
        HSR( , BSRData, , NoMask, ,SMWAITTests_3);

        /** Clear the Status register **/
        C("Clearing the Status Register");
        HSA(SMBSRAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
        HSW( , 0x07);
        HSA(SMBSRAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
        HSW( , 0x07);
        HSA(SMBSRAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
        HSW( , 0x07);
        HSA(SMBSRAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
        HSW( , 0x07);
      }
    }
  }

}

/************************************ End *************************************/
