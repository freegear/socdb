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
--  File Name              : BankCrossingTests.c.rca
--  File Revision          : 1.9
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform transfers such that they cross banks
--
-- --=========================================================================*/

/******************************************************************************/
/**************************** Bank Crossing Tests *****************************/
/******************************************************************************/

void BankCrossingTests()
{
  /*
     Summary: Bank Crossing Tests
     ============================
     This function performs the following:
     o  Alternate banks are programmed as Synchronous and Asynchronous.
     o  Does various BURST accesses of various lengths to the Memory such that
        they cross banks.
     o  BURSTs are started
        - At different word boundaries and quadword boundaries with INCR4,
          INCR8, INCR16, WRAP4, WRAP8 and WRAP16
        - With HSIZE as BYTE, HWRD and WRD
     o  Repeats the tests with various values of WST1, WST2, CS2OEN, CS2WEN
        and IDCY.
  */

  int HSIZE, BURST;
  int32 MemAddr, TestData, WTCNCLData, ExtMuxData, SMBLSPOLData;
  int32 AddrMask[3] = {0x3, 0x2, 0x0};
  char report[75];
  char* SBurst[8] = {"SINGLE", "INCR", "INCR4", "INCR8",
                          "INCR16", "WRAP4", "WRAP8", "WRAP16"};
  char* SSize[3] = {"BYTE", "HALFWORD", "WORD"};


  /*
      Programming SSMCCR and SSMCTrCR registers. The constants CLKRATIO and
      CLKSTATUS defined in the Ssmc.h set the required  MemClkRatio and
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

  /** Configuring the system to LITTLE endian mode by setting ENDIANNESS = 0 **/
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

  /** Set Bank 0 Memory Type as Synchronous SRAM (32 bits width) **/
  SSMCTrMEMBData[0] = 0x00000000;

  SMBCRData[0] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[0] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK0, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD2);

  ConfigureMemory(BANK0, SSMCTrMEMBData[0]);


  /** Set Bank 1 Memory Type as AsSynchronous SRAM (16 bits width) **/
  SSMCTrMEMBData[1] = 0x00000000;

  SMBCRData[1] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[1] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);


  /** Set Bank 2 Memory Type as Synchronous SRAM (8 bits width) **/
  SSMCTrMEMBData[2] = 0x00000000;

  SMBCRData[2] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK2, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD2);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2]);

  /** Set Bank 3 Memory Type as Synchronous SRAM (32 bits width) **/
  SSMCTrMEMBData[3] = 0x00000000;

  SMBCRData[3] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[3] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK3, WSTIDCY1, WSTRD2, WSTWR0, WSTOEN1, WSTWEN0, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD2);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3]);

  /** Set Bank 4 Memory Type as Synchronous SRAM (16 bits width) **/
  SSMCTrMEMBData[4] = 0x00000000;
  SMBCRData[4] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[4] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK4, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[4],
               SSMCTrCS2WTRData[4], WSTBRD2);

  ConfigureMemory(BANK4, SSMCTrMEMBData[4]);

  /** Set Bank 5 Memory Type as Synchronous SRAM (8 bits width) **/
  SSMCTrMEMBData[5] = 0x00000000;

  SMBCRData[5] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5]);

  /** Set Bank 6 Memory Type as Synchronous SRAM (32 bits width) **/
  SSMCTrMEMBData[6] = 0x00000000;

  SMBCRData[6] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[6] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK6, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[6],
               SSMCTrCS2WTRData[6], WSTBRD2);

  ConfigureMemory(BANK6, SSMCTrMEMBData[6]);

  /** Set Bank 7 Memory Type as Synchronous SRAM (16 bits width) **/
  SSMCTrMEMBData[7] = 0x00000000;
  
  SMBCRData[7] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[7] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK7, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[7],
               SSMCTrCS2WTRData[7], WSTBRD2);

  ConfigureMemory(BANK7, SSMCTrMEMBData[7]);

  TestData = 0x00123456;
  for (HSIZE = 0; HSIZE<3; HSIZE++)
  {
   for (BURST = 0; BURST<8; BURST++)
   {
    sprintf(report,"BURST WR/RDs ON BANK 0:");
    C(report);
    sprintf(report, "MSIZE = WORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]);
    C(report);
    MemWriteRead(0, BURST, 0x7F8 & AddrMask[HSIZE], HSIZE, 0x2, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WR/RDs ON BANK 1:");
    C(report);
    sprintf(report, "MSIZE = HALFWORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWriteRead(1, BURST, 0x7F9 & AddrMask[HSIZE], HSIZE, 0x1, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WR/RDs ON BANK 2:");
    C(report);
    sprintf(report, "MSIZE = BYTE, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWriteRead(2, BURST, 0x7FA & AddrMask[HSIZE], HSIZE, 0x0, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WR/RDs ON BANK 3:");
    C(report);
    sprintf(report, "MSIZE = WORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWriteRead(3, BURST, 0x7FB & AddrMask[HSIZE], HSIZE, 0x2, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WR/RDs ON BANK 4:");
    C(report);
    sprintf(report, "MSIZE = HALFWORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWriteRead(4, BURST, 0x7FC & AddrMask[HSIZE], HSIZE, 0x1, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WR/RDs ON BANK 5:"); 
    C(report);
    sprintf(report, "MSIZE = BYTE, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWriteRead(5, BURST, 0x7FD & AddrMask[HSIZE], HSIZE, 0x0, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WR/RDs ON BANK 6:");
    C(report);
    sprintf(report, "MSIZE = WORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWriteRead(6, BURST, 0x7FE & AddrMask[HSIZE], HSIZE, 0x2, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WR/RDs ON BANK 7:");
    C(report);
    sprintf(report, "MSIZE = HALFWORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWriteRead(7, BURST, 0x7FF & AddrMask[HSIZE], HSIZE, 0x1, TestData);
    TestData+= 0x00111111;
   }
  }


  /** Set Bank 0 Memory Type as Asynchronous SRAM (8 bits width) **/
  SSMCTrMEMBData[0] = 0x00000000;

  SMBCRData[0] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[0] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK0, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD2);

  ConfigureMemory(BANK0, SSMCTrMEMBData[0]);


  /** Set Bank 1 Memory Type as Synchronous SRAM (32 bits width) **/
  SSMCTrMEMBData[1] = 0x00000000;

  SMBCRData[1] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[1] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);

  /** Set Bank 2 Memory Type as Asynchronous SRAM (16 bits width) **/
  SSMCTrMEMBData[2] = 0x00000000;

  SMBCRData[2] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           |RBLE_1            | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK2, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD2);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2]);

  /** Set Bank 3 Memory Type as Synchronous SRAM (8 bits width) **/
  SSMCTrMEMBData[3] = 0x00000000;

  SMBCRData[3] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[3] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK3, WSTIDCY1, WSTRD2, WSTWR0, WSTOEN1, WSTWEN0, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD2);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3]);

  /** Set Bank 4 Memory Type as Asynchronous SRAM (32 bits width) **/
  SSMCTrMEMBData[4] = 0x00000000;
  SMBCRData[4] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[4] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK4, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[4],
               SSMCTrCS2WTRData[4], WSTBRD2);

  ConfigureMemory(BANK4, SSMCTrMEMBData[4]);

  /** Set Bank 5 Memory Type as Synchronous SRAM (16 bits width) **/
  SSMCTrMEMBData[5] = 0x00000000;

  SMBCRData[5] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5]);

  /** Set Bank 6 Memory Type as Asynchronous SRAM (8 bits width) **/
  SSMCTrMEMBData[6] = 0x00000000;

  SMBCRData[6] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[6] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK6, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[6],
               SSMCTrCS2WTRData[6], WSTBRD2);

  ConfigureMemory(BANK6, SSMCTrMEMBData[6]);

  /** Set Bank 7 Memory Type as Synchronous SRAM (32 bits width) **/
  SSMCTrMEMBData[7] = 0x00000000;

  SMBCRData[7] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[7] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK7, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[7],
               SSMCTrCS2WTRData[7], WSTBRD2);

  ConfigureMemory(BANK7, SSMCTrMEMBData[7]);

  TestData = 0x00123456;
  for (HSIZE = 0; HSIZE<1; HSIZE++)
  {
    for (BURST = 0; BURST<1; BURST++)
    {

    C("********* STARTING THE WRITES TO THE DIFFERENT BANKS ***********");

    sprintf(report, "BURST WR/RDs ON BANK 0:");
    C(report);
    sprintf(report, "MSIZE = BYTE, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]);
    C(report);
    MemWrite(0, BURST, 0x7F8 & AddrMask[HSIZE], HSIZE, 0x0, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WRITES ON BANK 1:");
    C(report);
    sprintf(report,"MSIZE = WORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWrite(1, BURST, 0x7F9 & AddrMask[HSIZE], HSIZE, 0x2, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WRITES ON BANK 2:");
    C(report);
    sprintf(report,"MSIZE = HALFWORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWrite(2, BURST, 0x7FA & AddrMask[HSIZE], HSIZE, 0x1, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WRITES ON BANK 3:");
    C(report);
    sprintf(report,"MSIZE = BYTE, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWrite(3, BURST, 0x7FB & AddrMask[HSIZE], HSIZE, 0x0, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WRITES ON BANK 4:");
    C(report);
    sprintf(report,"MSIZE = WORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWrite(4, BURST, 0x7FC & AddrMask[HSIZE], HSIZE, 0x2, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WRITES ON BANK 5:");
    C(report);
    sprintf(report,"MSIZE = HALFWORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWrite(5, BURST, 0x7FD & AddrMask[HSIZE], HSIZE, 0x1, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WRITES ON BANK 6:"); 
    C(report);
    sprintf(report,"MSIZE = BYTE, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWrite(6, BURST, 0x7FE & AddrMask[HSIZE], HSIZE, 0x0, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WRITES ON BANK 7:");
    C(report);
    sprintf(report,"MSIZE = WORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWrite(7, BURST, 0x7FF & AddrMask[HSIZE], HSIZE, 0x2, TestData);

   C("////////  STARTING THE READS TO THE DIFFERENT BANKS  \\\\\\\\");

    sprintf(report,"BURST READS ON BANK 7:");
    C(report);
    sprintf(report, "MSIZE = WORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(7, BURST, 0x7FF & AddrMask[HSIZE], HSIZE, 0x2, TestData);
    TestData-= 0x00111111;

    sprintf(report,"BURST READS ON BANK 6:");
    C(report);
    sprintf(report, "MSIZE = BYTE, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(6, BURST, 0x7FE & AddrMask[HSIZE], HSIZE, 0x0, TestData);
    TestData-= 0x00111111;

    sprintf(report,"BURST READS ON BANK 5:");
    C(report);
    sprintf(report, "MSIZE =  HALFWORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(5, BURST, 0x7FD & AddrMask[HSIZE], HSIZE, 0x1, TestData);
    TestData-= 0x00111111;

    sprintf(report,"BURST READS ON BANK 4:");
    C(report);
    sprintf(report, "MSIZE = WORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(4, BURST, 0x7FC & AddrMask[HSIZE], HSIZE, 0x2, TestData);
    TestData-= 0x00111111;

    sprintf(report,"BURST READS ON BANK 3:");
    C(report);
    sprintf(report, "MSIZE = BYTE, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(3, BURST, 0x7FB & AddrMask[HSIZE], HSIZE, 0x0, TestData);
    TestData-= 0x00111111;

    sprintf(report,"BURST READS ON BANK 2:");
    C(report);
    sprintf(report, "MSIZE = HALFWORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(2, BURST, 0x7FA & AddrMask[HSIZE], HSIZE, 0x1, TestData);
    TestData-= 0x00111111;

    sprintf(report,"BURST READS ON BANK 1:");
    C(report);
    sprintf(report, "MSIZE = WORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(1, BURST, 0x7F9 & AddrMask[HSIZE], HSIZE, 0x2, TestData);
    TestData-= 0x00111111;

    sprintf(report,"BURST READS ON BANK 0:");
    C(report);
    sprintf(report, "MSIZE = BYTE, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(0, BURST, 0x7F8 & AddrMask[HSIZE], HSIZE, 0x0, TestData);
    TestData-= 0x00111111;

   }
  }

  TestData = 0x00ABCDEF;
  for (HSIZE = 0; HSIZE<1; HSIZE++)
  {
    for (BURST = 0; BURST<8; BURST++)
    {
     C("");
     C("********* STARTING THE WRITES TO THE DIFFERENT BANKS ***********");

    sprintf(report,"BURST WRITES ON BANK 7:");
    C(report);
    sprintf(report, "MSIZE = WORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWrite(7, BURST, 0x7FF & AddrMask[HSIZE], HSIZE, 0x2, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WRITES ON BANK 6:");
    C(report);
    sprintf(report, "MSIZE = BYTE, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWrite(6, BURST, 0x7FE & AddrMask[HSIZE], HSIZE, 0x0, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WRITES ON BANK 5:");
    C(report);
    sprintf(report, "MSIZE = HALFWORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWrite(5, BURST, 0x7FD & AddrMask[HSIZE], HSIZE, 0x1, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WRITES ON BANK 4:");
    C(report);
    sprintf(report, "MSIZE = WORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWrite(4, BURST, 0x7FC & AddrMask[HSIZE], HSIZE, 0x2, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WRITES ON BANK 3:");
    C(report);
    sprintf(report, "MSIZE = BYTE, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWrite(3, BURST, 0x7FB & AddrMask[HSIZE], HSIZE, 0x0, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WRITES ON BANK 2:");
    C(report);
    sprintf(report, "MSIZE = HALFWORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWrite(2, BURST, 0x7FA & AddrMask[HSIZE], HSIZE, 0x1, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WRITES ON BANK 1:");
    C(report);
    sprintf(report, "MSIZE = WORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWrite(1, BURST, 0x7F9 & AddrMask[HSIZE], HSIZE, 0x2, TestData);
    TestData+= 0x00111111;

    sprintf(report,"BURST WRITES ON BANK 0:");
    C(report);
    sprintf(report, "MSIZE = BYTE, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemWrite(0, BURST, 0x7F8 & AddrMask[HSIZE], HSIZE, 0x0, TestData);

     C("////////  STARTING THE READS TO THE DIFFERENT BANKS  \\\\\\\\");
    sprintf(report,"BURST READS ON BANK 0:");
    C(report);
    sprintf(report, "MSIZE = BYTE, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(0, BURST, 0x7F8 & AddrMask[HSIZE], HSIZE, 0x0, TestData);
    TestData-= 0x00111111;

    sprintf(report,"BURST READS ON BANK 1:");
    C(report);
    sprintf(report, "MSIZE = WORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(1, BURST, 0x7F9 & AddrMask[HSIZE], HSIZE, 0x2, TestData);
    TestData-= 0x00111111;

    sprintf(report,"BURST READS ON BANK 2:");
    C(report);
    sprintf(report, "MSIZE = HALFWORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(2, BURST, 0x7FA & AddrMask[HSIZE], HSIZE, 0x1, TestData);
    TestData-= 0x00111111;

    sprintf(report,"BURST READS ON BANK 3:");
    C(report);
    sprintf(report, "MSIZE = BYTE, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(3, BURST, 0x7FB & AddrMask[HSIZE], HSIZE, 0x0, TestData);
    TestData-= 0x00111111;

    sprintf(report,"BURST READS ON BANK 4:");
    C(report);
    sprintf(report, "MSIZE = WORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(4, BURST, 0x7FC & AddrMask[HSIZE], HSIZE, 0x2, TestData);
    TestData-= 0x00111111;

    sprintf(report,"BURST READS ON BANK 5:");
    C(report);
    sprintf(report, "MSIZE = HALFWORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(5, BURST, 0x7FD & AddrMask[HSIZE], HSIZE, 0x1, TestData);
    TestData-= 0x00111111;

    sprintf(report,"BURST READS ON BANK 6:"); 
    C(report);
    sprintf(report, "MSIZE = BYTE, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(6, BURST, 0x7FE & AddrMask[HSIZE], HSIZE, 0x0, TestData);
    TestData-= 0x00111111;

    sprintf(report,"BURST READS ON BANK 7:");
    C(report);
    sprintf(report, "MSIZE = WORD, HSIZE = %s, HBURST = %s",
            SSize[HSIZE], SBurst[BURST]); 
    C(report);
    MemRead(7, BURST, 0x7FF & AddrMask[HSIZE], HSIZE, 0x2, TestData);
    TestData-= 0x00111111;


   }
  }

  /** Following Test cases have been added for coverage **/

  /** Set Bank 1 Memory Type as AsSynchronous SRAM (16 bits width) **/
  SSMCTrMEMBData[1] = 0x00000000;
  SMBCRData[1] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[1] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY1, WSTRD2, WSTWR0, WSTOEN1, WSTWEN0, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);
  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);

  /** Set Bank 3 Memory Type as Asynchronous SRAM (32 bits width) **/
  SSMCTrMEMBData[3] = 0x00000000;
  SMBCRData[3] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[3] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK3, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD2);
  ConfigureMemory(BANK3, SSMCTrMEMBData[3]);

  /** Set Bank 7 Memory Type as Asynchronous SRAM (8 bits width) **/
  SSMCTrMEMBData[7] = 0x00000000;

  SMBCRData[7] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[7] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK7, WSTIDCY1, WSTRD0, WSTWR3, WSTOEN0, WSTWEN1, SMBCRData[7],
               SSMCTrCS2WTRData[7], WSTBRD2);
  ConfigureMemory(BANK7, SSMCTrMEMBData[7]);

  C("** TEST CASES ADDED FOR COVERAGE **");
  sprintf(report,"BURST WR/RDs ON BANK 0:");
  C(report);
  sprintf(report,"HSIZE = WORD, MSIZE = WORD, BURST = SIN");
  C(report);
  TestData = 0x00123456;
  MemWriteRead(0, SIN, 0x7F8 & AddrMask[2], 2, 0x2, TestData);

  WaitLoop(5);

  sprintf(report,"BURST WR/RDs ON BANK 1:");
  C(report);
  sprintf(report,"HSIZE = HALFWORD, MSIZE = HALFWORD, BURST = INC");
  C(report);
  TestData+= 0x00111111;
  MemWriteRead(1, INC, 0x7F9 & AddrMask[1], 1, 0x1, TestData);

  WaitLoop(5);

  sprintf(report,"BURST WR/RDs ON BANK 2:");
  C(report);
  sprintf(report,"HSIZE = BYTE, MSIZE = BYTE, BURST = INC4");
  C(report);
  TestData+= 0x00111111;
  MemWriteRead(2, INC4, 0x7FA & AddrMask[0], 0, 0x0, TestData);

  WaitLoop(5);

  sprintf(report,"BURST WR/RDs ON BANK 3:");
  C(report);
  sprintf(report,"HSIZE = WORD, MSIZE = WORD, BURST = INC8");
  C(report);
  TestData+= 0x00111111;
  MemWriteRead(3, INC8, 0x7FB & AddrMask[2], 2, 0x2, TestData);

  WaitLoop(5);

  sprintf(report,"BURST WR/RDs ON BANK 4:");
  C(report);
  sprintf(report,"HSIZE = HALFWORD, MSIZE = HALFWORD, BURST = INC16");
  C(report);
  TestData+= 0x00111111;
  MemWriteRead(4, INC16, 0x7FC & AddrMask[1],1, 0x1, TestData);

  WaitLoop(5);

  sprintf(report,"BURST WR/RDs ON BANK 5:");
  C(report);
  sprintf(report,"HSIZE = BYTE, MSIZE = BYTE, BURST = WRP4");
  C(report);
  TestData+= 0x00111111;
  MemWriteRead(5, WRP4, 0x7FD & AddrMask[0],0, 0x0, TestData);

  WaitLoop(5);

  sprintf(report,"BURST WR/RDs ON BANK 6:");
  C(report);
  sprintf(report,"HSIZE = HALFWORD, MSIZE = WORD, BURST = WRP8");
  C(report);
  TestData+= 0x00111111;
  MemWriteRead(6, WRP8, 0x7FE & AddrMask[1], 1, 0x2, TestData);

  WaitLoop(5);

  sprintf(report,"BURST WR/RDs ON BANK 7:");
  C(report);
  sprintf(report,"HSIZE = BYTE, MSIZE = BYTE, BURST = WRP16");
  C(report);
  TestData+= 0x00111111;
  MemWriteRead(7, WRP16, 0x7FF & AddrMask[2],0, 0x0, TestData);

  WaitLoop(5);

  sprintf(report,"BURST WR/RDs ON BANK 1:");
  C(report);
  sprintf(report,"HSIZE = WORD, MSIZE = HALFWORD, BURST = INC");
  C(report);
  TestData+= 0x00111111;
  MemWriteRead(1, INC, 0x7F9 & AddrMask[2], 2, 0x1, TestData);

  WaitLoop(5);

/* Note : Donot change WSTRD or WSTOEN = 0 of BANK 7,,
   WSTWR or WSRWEN = 0 of BANK 1 , WSTWR or WSRWEN = 0 of BANK
   BAnk 3 wait EN disabled    as done for coverage*/

}

/************************************ End *************************************/
