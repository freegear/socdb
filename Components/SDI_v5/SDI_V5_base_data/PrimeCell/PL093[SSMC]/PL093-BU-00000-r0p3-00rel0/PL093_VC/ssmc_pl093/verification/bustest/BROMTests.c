/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : BROMTests.c.rca
--  File Revision          : 1.9
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform tests to check the operation of the SSMC with
--           different types of BURST ROMs connected to different banks.
--
-- --=========================================================================*/

/******************************************************************************/
/****************************** BURST ROM Tests *******************************/
/******************************************************************************/

void BROMTests()
{
  /*
     Summary: BURST ROM Tests
     ========================
     This function performs the following:

     o  Programs different banks as BROMs with different parameters
     o  Performs BURST and Non-BURST reads from the memory banks through the
        SSMC using different HSIZE and HBURST values
  */

  int i;
  int32 TestData, MemAddr, ReadData, ReadMask, WTCNCLData, ExtMuxData;
  int32 TempData1, TempData2, TempData3, TempData4, SMBLSPOLData;
  char Message[100];

  /*
      Programming SSMCCR and SSMCTrCR registers. The constants CLKRATIO and
      CLKSTATUS defined in the Ssmc.h set the required  MemClkRatioi and
      SMClockEn field bits.
  */
  SSMCCRDATA = CLKRATIO | CLKSTATUS;
  ConfigureCLKRatio(SSMCCRDATA);

  /*
      Programming the SSMCTrBurstWT register to turn the mask ON/OFF and to
      set the BeatNo and BurstWT counts. The constants BWtMask_ON/OFF,
      Beat0 to 15 and SSMCTrBurstWT0 to 15 are defined in Ssmc.h.
  */
  SSMCTrBurstWTData = BWtMask_ON | Beat15 | SSMCTrBurstWT15;
  ConfigureBurstWT(SSMCTrBurstWTData);

  /*
      Programming the SSMCTrWTCNCL register. The constant SMWTCNCLDI/EN
      disables or Enables the SMCANCELWait signal. The constant SMWAITIGNORE_0/1
      enables or disables the SMWAITIGNORE respectively and the constants
      WTCNCL0 to 63 are used to load the CANCEL WAIT count.
  */
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL10 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  /** Configuring the system to LITTLE endian mode **/
  ENDIANNESS = 0;
  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,ENDIANNESS);
  HSEN(LITTLE);

  /*
      Programming the SSMCTrExtMuxWT register.The constant ExtMuxDI/EN disables
      or enables the  External Mux. The constants ExtMuxAss0 to 15 and
      ExtMuxDAss0 to 15 define the Assertion and Deassertion counts.
  */
  ExtMuxData = ExtMuxAss5 | ExtMuxDAss5 | ExtMuxDI;
  HSA(SSMCTrExtMux, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,ExtMuxData);

  /** Programming the SSMCTrSMBLSPOL register **/
  SMBLSPOLData = SMBLSPOL_0;
  HSA(SSMCTrSMBLSPOL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SMBLSPOLData);

  /** Set Bank 0 Memory Type as BROM (16 bits width) **/
  SSMCTrMEMBData[0] = 0x00000000;
  SMBCRData[0] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[0] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK0, WSTIDCY3, WSTRD0, WSTWR0, WSTOEN0, WSTWEN0, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD1);

  ConfigureMemory(BANK0, SSMCTrMEMBData[0] );


  /** Set Bank 1 Memory Type as BROM (32 bits width) **/
  SSMCTrMEMBData[1] = 0x00000000;
  SMBCRData[1] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[1] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY3, WSTRD0, WSTWR0, WSTOEN0, WSTWEN0, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1] );


  /** Set Bank 2 Memory Type as BROM (8 bits width) **/
  SSMCTrMEMBData[2] = 0x00000000;
  SMBCRData[2] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK2, WSTIDCY3, WSTRD0, WSTWR0, WSTOEN0, WSTWEN0, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD1);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2] );


  /** Set Bank 3 Memory Type as ROM (16 bits width) **/
  SSMCTrMEMBData[3] = 0x00000000;
  SMBCRData[3] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[3] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK3, WSTIDCY3, WSTRD7, WSTWR5, WSTOEN3, WSTWEN0, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD4);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3] );

  /** Set Bank 5 Memory Type as BROM (8 bits width) **/
  /** ExtWait Enabled **/
  SSMCTrMEMBData[5] = 0x00000000;
  SMBCRData[5] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY4, WSTRD12, WSTWR6, WSTOEN4, WSTWEN0, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD6);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5]);

  /** Set Bank 7 Memory Type as BROM (32 bits width) **/
  SSMCTrMEMBData[7] = 0x00000000;

  SMBCRData[7] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[7] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK7, WSTIDCY2, WSTRD5, WSTWR2, WSTOEN0, WSTWEN0, SMBCRData[7],
               SSMCTrCS2WTRData[7], WSTBRD8);

  ConfigureMemory(BANK7, SSMCTrMEMBData[7] );

  /** Initialise the ROMs from AHB side **/
  AHBWriteMem(0, 0, 16, 0x11111111);
  AHBWriteMem(1, 0, 16, 0x11111111);
  AHBWriteMem(2, 0, 16, 0x11111111);
  AHBWriteMem(3, 0, 32, 0x00002222);
  AHBWriteMem(5, 0, 64, 0x00000033);
  AHBWriteMem(7, 0, 16, 0x44444444);

  /** Performing WORD reads to 32 bit Bank 1 BROM in INCR burst mode **/  
  C("READ ACCESSES TO BANK 1: HSIZE = WORD, MSIZE = WORD, HBURST = INCR");
  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  TestData = 0x11111111;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BROMTests_1);
  for (i=0; i<3; i++)
    HSR( , TestData++, , NoMask, ,BROMTests_2);

  /** Performing HALFWORD reads to 16 bit Bank 3 BROM in INCR4 burst mode **/
  C("READ ACCESSES TO BANK 3: HSIZE = HWORD, MSIZE = HWORD, HBURST = INCR4");
  MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  TestData = 0x00002222;
  ReadData = TestData;
  ReadMask = HWUnMaskL;
  HSA(MemAddr, NSEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , ReadMask, ,BROMTests_3);
  for (i=1, TestData++; i<4; i++, TestData++)
  {
    ReadMask = HWUnMaskL << 16*i;
    ReadData = TestData << 16*i;
    HSR( , ReadData, , ReadMask, ,BROMTests_4);
  }

  /** Performing BYTE reads to 8 bit Bank 5 BROM in INCR8 burst mode **/
  C("READ ACCESSES TO BANK 5: HSIZE = BYTE, MSIZE = BYTE, HBURST = INCR8");
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  TestData = 0x00000033;
  ReadData = TestData;
  ReadMask = BUnMask0;
  HSA(MemAddr, NSEQ, INCR8, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , ReadMask, ,BROMTests_5);
  for (i=1, TestData++; i<8; i++, TestData++)
  {
    ReadMask = BUnMask0 << 8*i;
    ReadData = TestData << 8*i;
    HSR( , ReadData, , ReadMask, ,BROMTests_6);
  }

  /** Performing WORD reads to 32 bit Bank 7 BROM in INCR16 burst mode **/
  C("READ ACCESSES TO BANK 7: HSIZE = WORD, MSIZE = WORD, HBURST = INCR16");
  MemAddr = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11);
  TestData = 0x44444444;
  HSA(MemAddr, NSEQ, INCR16, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BROMTests_7);
  for (i=0; i<15; i++)
    HSR( , TestData++, , NoMask, ,BROMTests_8);

  /** Performing HALFWORD reads to 32 bit Bank 1 BROM in WRAP8 burst mode **/
  C("READ ACCESSES TO BANK 1: HSIZE = HALFWORD, MSIZE = WORD, HBURST = WRAP4");
  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11) + 2;
  TestData = 0x11111111;
  HSA(MemAddr, NSEQ, WRAP4, OK, HWRD, , 0x1, , , , ,);
  HSR( , TestData++ & HWUnMaskB, , HWUnMaskB, ,BROMTests_9);
  HSR( , TestData & HWUnMaskL, , HWUnMaskL, ,BROMTests_10);
  TestData = 0x11111111;
  HSR( , TestData & HWUnMaskB, , HWUnMaskB, ,BROMTests_11);
  HSR( , TestData & HWUnMaskL, , HWUnMaskL, ,BROMTests_12);

  /** Performing BYTE reads to 16 bit Bank 3 BROM in WRAP8 burst mode **/
  C("READ ACCESSES TO BANK 3: HSIZE = BYTE, MSIZE = HWORD, HBURST = WRAP8");
  MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11) + 1;
  TestData = 0x00002222;
  ReadData = TestData++ & BUnMask1;
  HSA(MemAddr, NSEQ, WRAP8, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , BUnMask1, ,BROMTests_13);
  ReadData = (TestData & BUnMask0) << 16;
  HSR( , ReadData, , BUnMask2, ,BROMTests_14);
  ReadData = (TestData++ & BUnMask1) << 16;
  HSR( , ReadData, , BUnMask3, ,BROMTests_15);
  ReadData = (TestData & BUnMask0);
  HSR( , ReadData, , BUnMask0, ,BROMTests_16);
  ReadData = TestData++ & BUnMask1;
  HSR( , ReadData, , BUnMask1, ,BROMTests_17);
  ReadData = (TestData & BUnMask0) << 16;
  HSR( , ReadData, , BUnMask2, ,BROMTests_18);
  ReadData = (TestData & BUnMask1) << 16;
  HSR( , ReadData, , BUnMask3, ,BROMTests_19);
  TestData = 0x00002222;
  ReadData = (TestData & BUnMask0);
  HSR( , ReadData, , BUnMask0, ,BROMTests_20);

  /** Performing WORD reads to 8 bit Bank 5 BROM in WRAP16 burst mode **/
  C("READ ACCESSES TO BANK 5: HSIZE = WORD, MSIZE = BYTE, HBURST = WRAP16");
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  TestData = 0x00000033;
  TempData1 = TestData++;
  TempData2 = TestData++;
  TempData3 = TestData++;
  TempData4 = TestData++;
  ReadData = TempData1 | (TempData2 << 8) | (TempData3 << 16) |
             (TempData4 << 24);
  HSA(MemAddr, NSEQ, WRAP16, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,BROMTests_21);
  for (i=0; i<15; i++)
  {
    TempData1 = TestData++;
    TempData2 = TestData++;
    TempData3 = TestData++;
    TempData4 = TestData++;
    ReadData = TempData1 | (TempData2 << 8) | (TempData3 << 16) |
               (TempData4 << 24);
    HSR( , ReadData, , NoMask, ,BROMTests_22);
  }

  /** Performing HALFWORD reads to 32 bit Bank 7 BROM in SINGLE burst mode **/
  C("READ ACCESSES TO BANK 7: HSIZE = HALFWORD, MSIZE = WORD, HBURST = SINGLE");
  MemAddr = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11);
  TestData = 0x44444444;
  HSA(MemAddr, NSEQ, SINGLE, OK, HWRD, , 0x1, , , , ,);
  HSR( , TestData & HWUnMaskL, , HWUnMaskL, ,BROMTests_23);

  /** Performing WORD reads to 32 bit Bank 1 BROM in NON BURST mode **/
  C("NON-BURST READ ACCESSES TO BANK 1: HSIZE = WORD, MSIZE = WORD");
  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  TestData = 0x11111111;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BROMTests_24);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BROMTests_25);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BROMTests_26);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,BROMTests_27);


  /** Performing HALFWORD reads to 16 bit Bank 0 BROM in WRAP4  burst mode **/
  C("READ ACCESSES TO BANK 0: HSIZE = HWORD, MSIZE = HWORD, HBURST = WRAP4");
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11);
  TestData = 0x1111;
  HSA(MemAddr, NSEQ, WRAP4, OK, HWRD, , 0x1, , , , ,);

  HSR( , TestData++, , HWUnMaskL, ,BROMTests_28);
  HSR( , TestData++ << 16, , HWUnMaskB, ,BROMTests_29);
  HSR( , TestData++, , HWUnMaskL, ,BROMTests_30);
  HSR( , TestData << 16, , HWUnMaskB, ,BROMTests_31);

  WaitLoop(10);


  /** Performing BYTE reads to 8 bit Bank 2 BROM in WRAP 4 burst mode **/
  C("READ ACCESSES TO BANK 2: HSIZE = BYTE, MSIZE = BYTE, HBURST = WRAP4");
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
  TestData = 0x11;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE, , 0x1, , , , ,);
  HSR( , TestData++, , BUnMask0, ,BROMTests_32);
  HSR( , TestData++ <<  8, , BUnMask1, ,BROMTests_33);
  HSR( , TestData++ << 16, , BUnMask2, ,BROMTests_34);
  HSR( , TestData <<   24, , BUnMask3, ,BROMTests_35);
 
  WaitLoop(10);

  /** Performing BYTE reads to 8 bit Bank 2 BROM in WRAP 8 burst mode **/
  C("READ ACCESSES TO BANK 2: HSIZE = BYTE, MSIZE = BYTE, HBURST = WRAP8");
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
  TestData = 0x11;
  HSA(MemAddr, NSEQ, WRAP8, OK, BYTE, , 0x1, , , , ,);
  HSR( , TestData++, , BUnMask0, ,BROMTests_36);
  HSR( , TestData++ <<  8, , BUnMask1, ,BROMTests_37);
  HSR( , TestData++ << 16, , BUnMask2, ,BROMTests_38);
  HSR( , TestData++ << 24, , BUnMask3, ,BROMTests_39);
  HSR( , TestData++, , BUnMask0, ,BROMTests_40);
  HSR( , TestData++ <<  8, , BUnMask1, ,BROMTests_41);
  HSR( , TestData++ << 16, , BUnMask2, ,BROMTests_42);
  HSR( , TestData   <<   24, , BUnMask3, ,BROMTests_43);


  WaitLoop(10);

  C("WRITE-READ TESTS ON THE BROM BANKS 1, 3, 5:");
  C("CHECK FOR CORRUPTION OF ORIGINAL DATA BY ATTEMPTED WRITES");
  ROMWriteRead(1, 5, 0, 2, 2, 0xAABBCCDD, 0x11111111);
  ROMWriteRead(1, 6, 0, 2, 2, 0x99887766, 0x11111111);
  ROMWriteRead(3, 6, 0, 1, 1, 0xDDCC, 0x2222);
  ROMWriteRead(3, 7, 0, 1, 1, 0x3344, 0x2222);
  ROMWriteRead(5, 7, 0, 0, 0, 0x55, 0x33);

}

/************************************ End *************************************/
