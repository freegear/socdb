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
--  File Name              : TransferTests.c.rca
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
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                                      Located in          ***/
/*** ---------------------------------------------------------------------- ***/
/*** ConfigureMemory                                    SmcCommon.c         ***/
/*** ConfigureUUT                                       SmcCommon.c         ***/
/*** SingleWriteRead                                    SmcCommon.c         ***/
/*** BurstWriteRead                                     SmcCommon.c         ***/
/******************************************************************************/

/******************************************************************************/
/******************************* Transfer Tests *******************************/
/******************************************************************************/

void TransferTests()
{
  /*
     Summary: Transfer Tests
     =======================
     This function performs the following:

     o  Does the read/write operations with all combinations of
        - HSIZE values of BYTE, HWRD and WRD
        - Memory size of 8 bits, 16 bits and 32 bits
        - Different bursts
        - Bank values of 0 to 7
  */

  int Burst, BankNo, HSIZE, MSIZE;
  char size[3] = {'b', 'h', 'w'};
  int32 BCRData, MemAddr1, MemAddr2, MemAddr3, AHBAddr, TestData;
  int32 MEMTData;
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};

  /** Writing and Reading from the Memory before it's configured **/
  MemAddr1 = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x55555555);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x55555555, , NoMask, ,TransferTests_1);

  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x02, 0x05, 0x04, 0x042, SMCTrMEMBData[0], 0x02,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x02, 0x05, 0x04, 0x042, SMCTrMEMBData[1], 0x02,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(2, 0x02, 0x05, 0x04, 0x042, SMCTrMEMBData[2], 0x02,
                  0x00, 0x000000);

  /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(3, 0x02, 0x05, 0x04, 0x042, SMCTrMEMBData[3], 0x02,
                  0x00, 0x000000);

  /** Set Bank 4 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[4] = 0x00000000;
  ConfigureUUT(4, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(4, 0x02, 0x05, 0x04, 0x042, SMCTrMEMBData[4], 0x02,
                  0x00, 0x000000);

  /** Set Bank 5 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x03, 0x07, 0x00, 0x03, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(5, 0x03, 0x07, 0x00, 0x042, SMCTrMEMBData[5], 0x03,
                  0x00, 0x000000);

  /** Set Bank 6 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[6] = 0x00000000;
  ConfigureUUT(6, 0x04, 0x06, 0x02, 0x04, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(6, 0x04, 0x06, 0x02, 0x042, SMCTrMEMBData[6], 0x04,
                  0x00, 0x000000);

  /** Set Bank 7 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[7] = 0x00000000;
  ConfigureUUT(7, 0x02, 0x05, 0x01, 0x04, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(7, 0x02, 0x05, 0x01, 0x042, SMCTrMEMBData[7], 0x04,
                  0x00, 0x000000);
  /** Different Burst transfers to the 8 Banks **/
  for (HSIZE = 0; HSIZE <= 2; HSIZE++)
    for (MSIZE = 0; MSIZE <= 2; MSIZE++)
    {
      /** Reconfigure the Memory Width field of the SMC and the Memory **/
      if (MSIZE != 0)
      {
        MEMTData = 0x040 | MSIZE;
        BCRData = 0x00000001 | (MSIZE << 6);
      } else
      {
        MEMTData = 0x000 | MSIZE;
        BCRData = 0x00000000 | (MSIZE << 6);
      }

      HSA(SMBCR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , BCRData);
      HSA(SMCTrMEMT_0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , MEMTData);

      HSA(SMBCR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , BCRData);
      HSA(SMCTrMEMT_1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , MEMTData);

      HSA(SMBCR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , BCRData);
      HSA(SMCTrMEMT_2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , MEMTData);

      HSA(SMBCR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , BCRData);
      HSA(SMCTrMEMT_3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , MEMTData);

      HSA(SMBCR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , BCRData);
      HSA(SMCTrMEMT_4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , MEMTData);

      HSA(SMBCR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , BCRData);
      HSA(SMCTrMEMT_5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , MEMTData);

      HSA(SMBCR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , BCRData);
      HSA(SMCTrMEMT_6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , MEMTData);

      HSA(SMBCR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , BCRData);
      HSA(SMCTrMEMT_7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , MEMTData);

      /** Write into the Memory through the SMC and read it back through     **/
      /** both the SMC and the AHB Interface of the TrickMem                 **/
      for (BankNo = 0; BankNo < 8; BankNo++)
      {
        TestData = ~BankNo & UnMask[HSIZE];
        for (Burst = 0; Burst < 8; Burst++)
          BurstWriteRead(BankNo, Burst, 0x00, HSIZE, MSIZE, TestData);
      }
    }

  /** Different transfer sequences **/
  /** NS-NS to the same bank **/
  MemAddr1 = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0x89ABCDEF);
  HSA(MemAddr1+4, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0xFEDCBA98);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x89ABCDEF, , NoMask, ,TransferTests_2);
  HSA(MemAddr1+4, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0xFEDCBA98, , NoMask, ,TransferTests_3);

  /** NS-NS to different banks **/
  MemAddr1 = SMCMEM_2 + (SMCTrMEMBData[2] << 11);
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0x12345678);
  MemAddr2 = SMCMEM_3 + (SMCTrMEMBData[3] << 11);
  HSA(MemAddr2, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0x87654321);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x12345678, , NoMask, ,TransferTests_4);
  HSA(MemAddr2, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x87654321, , NoMask, ,TransferTests_5);
  
  /** NS-NS-NS to the same bank **/
  MemAddr1 = SMCMEM_4 + (SMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0x11223344);
  HSA(MemAddr1+4, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0x22334455);
  HSA(MemAddr1+8, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0x33445566);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , NoMask, ,TransferTests_6);
  HSA(MemAddr1+4, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x22334455, , NoMask, ,TransferTests_7);
  HSA(MemAddr1+8, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x33445566, , NoMask, ,TransferTests_8);

  /** NS-NS-NS to different banks **/
  MemAddr1 = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0x44332211);
  MemAddr2 = SMCMEM_6 + (SMCTrMEMBData[6] << 11);
  HSA(MemAddr2, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0x55443322);
  MemAddr3 = SMCMEM_7 + (SMCTrMEMBData[7] << 11);
  HSA(MemAddr3, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0x66554433);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x44332211, , NoMask, ,TransferTests_9);
  HSA(MemAddr2, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x55443322, , NoMask, ,TransferTests_10);
  HSA(MemAddr3, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x66554433, , NoMask, ,TransferTests_11);

  /** NS-S-S **/
  MemAddr1 = SMCMEM_2 + (SMCTrMEMBData[2] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x11223344);
  HSW( , 0x22334455);
  HSW( , 0x33445566);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , NoMask, ,TransferTests_12);
  HSR( , 0x22334455, , NoMask, ,TransferTests_13);
  HSR( , 0x33445566, , NoMask, ,TransferTests_14);

  /** NS-I-NS to the same bank **/
  MemAddr1 = SMCMEM_4 + (SMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0xAABBCCDD);
  HSA(MemAddr1+4, IDLE, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0xBBCCDDEE);
  HSA(MemAddr1+8, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0xCCDDEEFF);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xAABBCCDD, , NoMask, ,TransferTests_15);
  HSR( , 0x22334455, , NoMask, ,TransferTests_16);
  HSR( , 0xCCDDEEFF, , NoMask, ,TransferTests_17);

  /** NS-I-NS to different banks **/
  MemAddr1 = SMCMEM_3 + (SMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0xDDCCBBAA);
  MemAddr2 = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  HSA(MemAddr2, IDLE, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0xEEDDCCBB);
  MemAddr3 = SMCMEM_6 + (SMCTrMEMBData[6] << 11);
  HSA(MemAddr3, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0xFFEEDDCC);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0xDDCCBBAA, , NoMask, ,TransferTests_18);
  HSA(MemAddr2, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x44332211, , NoMask, ,TransferTests_19);
  HSA(MemAddr3, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0xFFEEDDCC, , NoMask, ,TransferTests_20);

  /** NS-B-S **/
  MemAddr1 = SMCMEM_7 + (SMCTrMEMBData[7] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xAABBCCDD);
  HSA(MemAddr1+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xBBCCDDEE);
  HSA(MemAddr1+4, SEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xCCDDEEFF);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xAABBCCDD, , NoMask, ,TransferTests_21);
  HSR( , 0xCCDDEEFF, , NoMask, ,TransferTests_22);

  /** NS-B-NS to the same bank **/
  MemAddr1 = SMCMEM_4 + (SMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x12345678);
  HSA(MemAddr1+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x89ABCDEF);
  HSA(MemAddr1+12, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0x01234567);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x12345678, , NoMask, ,TransferTests_23);
  HSR( , 0x22334455, , NoMask, ,TransferTests_24);
  HSA(MemAddr1+12, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x01234567, , NoMask, ,TransferTests_25);

  /** NS-B-NS to different banks **/
  MemAddr1 = SMCMEM_7 + (SMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x01234567);
  HSA(MemAddr1+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x12345678);
  MemAddr2 = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  HSA(MemAddr2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x23456789);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x01234567, , NoMask, ,TransferTests_26);
  HSR( , 0xCCDDEEFF, , NoMask, ,TransferTests_27);
  HSA(MemAddr2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x23456789, , NoMask, ,TransferTests_28);

  /** NS-B-I to the same bank **/
  MemAddr1 = SMCMEM_4 + (SMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x024678AC);
  HSA(MemAddr1+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x13579BDF);
  HSA(MemAddr1+8, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x13579BD2);
  HSA(MemAddr1+12, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x2468ACE0);
  HSA(MemAddr1+16, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x2468ACE2);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x024678AC, , NoMask, ,TransferTests_29);
  HSR( , 0x22334455, , NoMask, ,TransferTests_30);
  HSR( , 0xCCDDEEFF, , NoMask, ,TransferTests_31);
  HSR( , 0x01234567, , NoMask, ,TransferTests_32);
  HSR( , 0x2468ACE2, , NoMask, ,TransferTests_33);

  /** NS-S-B-S to the same bank **/
  MemAddr1 = SMCMEM_4 + (SMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x11111111);
  HSW( , 0x22222222);
  HSA(MemAddr1+8, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x33333333);
  HSA(MemAddr1+8, SEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x44444444);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11111111, , NoMask, ,TransferTests_34);
  HSR( , 0x22222222, , NoMask, ,TransferTests_35);
  HSR( , 0x44444444, , NoMask, ,TransferTests_36);

  /** NS-B-S-B-S to the same bank **/
  MemAddr1 = SMCMEM_4 + (SMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xAAAAAAAA);
  HSA(MemAddr1+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xBBBBBBBB);
  HSA(MemAddr1+4, SEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xCCCCCCCC);
  HSA(MemAddr1+8, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xDDDDDDDD);
  HSA(MemAddr1+8, SEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xEEEEEEEE);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xAAAAAAAA, , NoMask, ,TransferTests_37);
  HSR( , 0xCCCCCCCC, , NoMask, ,TransferTests_38);
  HSR( , 0xEEEEEEEE, , NoMask, ,TransferTests_39);

 C("The corner case with NS-I-NS to different banks whose MSizes are different");
  /** Corner case with the MSizes for the two banks different **/
  /** with NS-I-NS to different banks **/

  /** Set Bank 3 Memory Type as SRAM (16 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x02, 0x05, 0x04, 0x02, 0x02, 0x00000041, 0x000000,
               0x000000);
  ConfigureMemory(3, 0x02, 0x05, 0x04, 0x041, SMCTrMEMBData[3], 0x02,
                  0x02, 0x000000);

  /** Set Bank 5 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x03, 0x07, 0x00, 0x03, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(5, 0x03, 0x07, 0x00, 0x042, SMCTrMEMBData[5], 0x03,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x04, 0x06, 0x02, 0x04, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(2, 0x04, 0x06, 0x02, 0x042, SMCTrMEMBData[2], 0x04,
                  0x00, 0x000000);

   /** Set Bank 6 Memory Type as SRAM (8 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SMCTrMEMBData[6] = 0x00000000;
  ConfigureUUT(6, 0x04, 0x06, 0x02, 0x04, 0x00, 0x00000001, 0x000000,
               0x000000);
  ConfigureMemory(6, 0x04, 0x06, 0x02, 0x040, SMCTrMEMBData[6], 0x04,
                  0x00, 0x000000);



/** Corner case with the MSizes for the two banks being different **/
/** NS-I-NS to different banks **/
 C("The corner case with NS-I-NS to 32 bit device followed by 16 bit device");
/** write to 32 bit device followed by idle cycles and **/
/** write to 16 bit device.**/
/** This helps in checking for the proper assertion of smbls signals **/

  MemAddr1 = SMCMEM_2 + 0x04;                       
  HSA(MemAddr1, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x000000CC);

  WaitLoop(5);
  
  HSA(MemAddr1+1, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x000000DD);


 WaitLoop(4);

  MemAddr2 = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  HSA(MemAddr2, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xEEDDCCBB);
  MemAddr3 = SMCMEM_3 + 0x04;
  HSA(MemAddr3, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0xDDCCBBAA);

  
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xFFEEDDCC, , BUnMask0, ,TransferTests_Cnr1);
  HSA(MemAddr3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xDDCCBBAA, , BUnMask0, ,TransferTests_Cnr1);

/** Write to 16 bit device followed by idle cycles and **/
/** write to 32 bit device.**/
 C("The corner case with NS-I-NS to 16 bit device followed by 32 bit device");
  MemAddr1 = SMCMEM_3 + 0x04;
  HSA(MemAddr1, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0xDDCCBBAA);

  WaitLoop(6);

  MemAddr2 = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  HSA(MemAddr2, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xEEDDCCBB);

  MemAddr3 = SMCMEM_2 + 0x04;
  HSA(MemAddr3, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x000000CC);

  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xDDCCBBAA, , BUnMask0, ,TransferTests_Cnr2);
  HSA(MemAddr3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xFFEEDDCC, , BUnMask0, ,TransferTests_Cnr2);

  /** Write to 8 bit device followed by idle cycles and **/
  /** write to 32 bit device.**/

C("The corner case with NS-I-NS to 8 bit device followed by 32 bit device");
  MemAddr1 =  SMCMEM_6 + 0x04;
  HSA(MemAddr1, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x000000BA);

  WaitLoop(4);

  MemAddr2 = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  HSA(MemAddr2, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0xEEDDCCBB);

  MemAddr3 = SMCMEM_2 + 0x04;
  HSA(MemAddr3, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x000000CA);


  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x000000BA, , BUnMask0, ,TransferTests_Cnr3);
  HSA(MemAddr3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x000000CA, , BUnMask0, ,TransferTests_Cnr3);

 /** Write to 16 bit device followed by idle cycles and **/
 /** write to 8 bit device.**/
C("The corner case with NS-I-NS to 16 bit device followed by 8 bit device");
  MemAddr1 = SMCMEM_3 + 0x04;
  HSA(MemAddr1, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x0000001C);
  WaitLoop(5);
  MemAddr2 = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  HSA(MemAddr2, IDLE, INCR, , WRD, , 0x1, , , , ,);
  MemAddr3 = SMCMEM_6 + 0x04;
  HSA(MemAddr3, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x000000FF);

  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xDDCCBB1C, , BUnMask0, ,TransferTests_Cnr4);
  HSA(MemAddr3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x000000FF, , BUnMask0, ,TransferTests_Cnr4);

/** Write to 8 bit device followed by idle cycles and **/
 /** write to 16 bit device.**/
C("The corner case with NS-I-NS to 8 bit device followed by 16 bit device");
  MemAddr1 = SMCMEM_6 + 0x04;
  HSA(MemAddr1, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x00000011);
  WaitLoop(4);
  MemAddr2 = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  HSA(MemAddr2, IDLE, INCR, , WRD, , 0x1, , , , ,);
  MemAddr3 = SMCMEM_3 + 0x04;
  HSA(MemAddr3, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x00000022);

  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xDDCCBB11, , BUnMask0, ,TransferTests_Cnr5);
  HSA(MemAddr3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x00000022, , BUnMask0, ,TransferTests_Cnr5)

/** Write to 32 bit device followed by write to 8bit **/
 /** device **/
C("The corner case with NS-I-NS to 32 bit device followed by 8 bit device");
  MemAddr1 = SMCMEM_2 + 0x04;
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0xDDCCBBAA);
  MemAddr2 = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  HSA(MemAddr2, IDLE, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0xEEDDCCBB);
  MemAddr3 = SMCMEM_6 + 0x04;
  HSA(MemAddr3, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0xFFEEDDCC);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0xDDCCBBAA, , NoMask, ,TransferTests_Cnr6);
  HSA(MemAddr3, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0xFFEEDDCC, , NoMask, ,TransferTests_Cnr6);

}

/************************************ End *************************************/
