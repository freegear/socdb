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
--  File Name              : PerformanceTests.c.rca
--  File Revision          : 1.9
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Read/Write operation tests on the SSMC.
--
-- --=========================================================================*/

/******************************************************************************/
/***************************** Performance Tests ******************************/
/******************************************************************************/

void PerformanceTests()
{
  /*
     Summary: Performance Tests
     ==========================
     This function performs the following:

     o  Checks whether the SSMC gives data to the requester immedietely.
     o  Checks whether the SSMC holds the HREADYOUT low even after the
        completion of a valid read/write
     o  Verifies that the read/write is completed within the expected number
        of clock cycles
  */

  int i, j;
  int32 MemAddr1, MemAddr2, MemAddr3, MemAddr4, MemAddr6, TestData;
  int32 TestWrite[3] = {0x11111111, 0x22222222, 0x33333333};
  int32 TestWSTRD[3] = {0x00000005, 0x0000001F, 0x0000000F};
  int32 TestWSTBRD[3] = {0x00000005, 0x0000001F, 0x0000000F};
  int32 TestWSTWR[3] = {0x00000005, 0x0000001F, 0x0000000F};
  int32 TestIDCY[3] = {0x00000007, 0x00000002, 0x00000000};
  int32 WTCNCLData, ExtMuxData, SMBLSPOLData;

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

  /** Configuring the system to LITTLE endian mode by setting ENDIANNESS = 0  **/
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

  /** Set Bank 1 Memory Type as SRAM (32 bits width) **/
  /** Configuring the Memory Bank 1 as SRAM with ExtWait Disabled **/
  SSMCTrMEMBData[1] = 0x00000000;
  SMBCRData[1] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[1] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY15, WSTRD5, WSTWR4, WSTOEN2, WSTWEN3, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);

  /** Set Bank 3 Memory Type as BROM (32 bits width) **/
  /** Configuring the Memory Bank 3 as 32 bits BROM with ExtWait Disabled **/
  SSMCTrMEMBData[3] = 0x00000000;
  SMBCRData[3] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[3] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK3, WSTIDCY15, WSTRD5, WSTWR4, WSTOEN2, WSTWEN2, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD2);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3] );

  MemAddr1 = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  TestData = 0xAAAA5555;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  for (i=0; i<4; i++)
    HSW( ,TestData++);

  WaitLoop(8);

  /** Re-configuring the WSTRD register for SRAM and reads again **/
  C("TESTING THE WSTRD TIMING FOR SRAM");
  for (j=0; j<3; j++)
  {
    HSA(SMBWSTRDR1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestWSTRD[j]);
  
    TestData = 0xAAAA5555;
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , NoMask, ,PerformanceTests_1);
    for (i=0; i<4; i++)
      HSR( , TestData++, , NoMask, ,PerformanceTests_2);
  }

  /** Re-configuring the WSTWR register for SRAM and writes again **/
  C("TESTING THE WSTWR TIMING FOR SRAM");
  for (j=0; j<3; j++)
  {
    HSA(SMBWSTWRR1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestWSTWR[j]);

    TestData = TestWrite[j];
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestData++);
    for (i=0; i<4; i++)
      HSW( ,TestData++);
  
    TestData = TestWrite[j];
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , NoMask, ,PerformanceTests_3);
    for (i=0; i<4; i++)
      HSR( , TestData++, , NoMask, ,PerformanceTests_4);
  }

  /** Re-configuring the IDCY register **/
  MemAddr2 = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  TestWrite[0] = 0x44444444;
  TestWrite[1] = 0x55555555;
  TestWrite[2] = 0x66666666;
  C("TESTING THE IDCY TIMING");
  for (j=0; j<3; j++)
  {
    HSA(SMBIDCYR1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestIDCY[j]);

    /** Initialise the BROM from the AHB side **/
    HSA(SSMCTrMEMARRAY3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,~TestWrite[j]);

    TestData = TestWrite[j];
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestData);
    HSA(MemAddr2, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
    HSW( ,TestData);
  
    TestData = TestWrite[j];
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , NoMask, ,PerformanceTests_5);
    HSA(MemAddr1+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestData);
  
    /** Verify the written data **/
    HSA(MemAddr1+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData, , NoMask, ,PerformanceTests_6);

    /** IDCY behaviour across the banks **/
    TestData = TestWrite[j];
    HSA(MemAddr2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , ~TestData, , NoMask, ,PerformanceTests_7);
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestData+=5);

    /** Verify the written data **/
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData, , NoMask, ,PerformanceTests_8);

    WaitLoop(1);

  }

  /** Initialise the BROM from the AHB side **/
  TestData = 0x5555AAAA;
  HSA(SSMCTrMEMARRAY3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  for (j=0; j<3; j++)
    HSW( ,TestData++);

  /** Re-configuring the WSTRD register for BROM and reads again **/
  C("TESTING THE WSTRD TIMING FOR BROM");
  for (j=0; j<2; j++)
  {
    HSA(SMBWSTRDR3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestWSTRD[j]);
  
    TestData = 0x5555AAAA;
    HSA(MemAddr2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , NoMask, ,PerformanceTests_9);
    for (i=0; i<3; i++)
      HSR( , TestData++, , NoMask, ,PerformanceTests_10);
  }

  /** Re-configuring the WSTBRD register for BROM and reads again **/
  C("TESTING THE WSTBRD TIMING FOR BROM");
  for (j=0; j<2; j++)
  {
    HSA(SMBWSTBRDR3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestWSTBRD[j]);
  
    TestData = 0x5555AAAA;
    HSA(MemAddr2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , NoMask, ,PerformanceTests_11);
    for (i=0; i<3; i++)
      HSR( , TestData++, , NoMask, ,PerformanceTests_12);
  }

  /** Re-configuring the IDCY register **/
  C("TESTING THE IDCY TIMING ACROSS THE BANKS");
  TestIDCY[0] = 0x0000000E;
  TestIDCY[1] = 0x00000008;
  TestIDCY[2] = 0x00000001;
  TestWrite[0] = 0x11223344;
  TestWrite[1] = 0x55667788;
  TestWrite[2] = 0x99AABBCC;
  for (j=0; j<3; j++)
  {
    HSA(SMBIDCYR1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestIDCY[j]);

    TestData = TestWrite[j];
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestData++);
    HSA(MemAddr2, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
    HSW( ,TestData);
  
    /** IDCY behaviour across the banks **/
    TestData = TestWrite[j];
    HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , TestData++, , NoMask, ,PerformanceTests_13);
    HSA(MemAddr2, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
    HSW( ,TestData);
  }

  /** Testing the case where the number of IDLE cycles after a Write        **/
  /** is equal to the WSTWR value                                           **/

  C("TESTING THE CASE WHERE WHERE WSTIDCY COUNT = WSTWR COUNT");

  /** Set Bank 1 Memory Type as SRAM (32 bits width) **/
  /** Configuring the Memory Bank 1 as SRAM with ExtWait Disabled **/
  SSMCTrMEMBData[1] = 0x00000000;
  SMBCRData[1] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[1] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY2, WSTRD5, WSTWR5, WSTOEN2, WSTWEN2, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1] );


  /** Set Bank 3 Memory Type as BROM (32 bits width) **/
  /** Configuring the Memory Bank 3 as 32 bits BROM with ExtWait Disabled **/
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

  ConfigureUUT(BANK3, WSTIDCY2, WSTRD5, WSTWR5, WSTOEN2, WSTWEN3, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD2);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3] );

  /** Set Bank 5 Memory Type as SRAM (16 bits width) **/
  /** Configuring the Memory Bank 5 as SRAM with ExtWait Disabled **/
  SSMCTrMEMBData[5] = 0x00000000;
  SMBCRData[5] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY2, WSTRD5, WSTWR5, WSTOEN2, WSTWEN2, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5] );

  /** Set Bank 7 Memory Type as SRAM (32 bits width) **/
  /** Configuring the Memory Bank 7 as SRAM with ExtWait Disabled **/
  SSMCTrMEMBData[7] = 0x00000000;
  SMBCRData[7] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[7] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK7, WSTIDCY2, WSTRD5, WSTWR5, WSTOEN2, WSTWEN0, SMBCRData[7],
               SSMCTrCS2WTRData[7], WSTBRD2);

  ConfigureMemory(BANK7, SSMCTrMEMBData[7] );

  MemAddr3 = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  MemAddr4 = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11);


  C("TESTING THE WSTWR TIMING WITH BUSY ADDED IN BETWEEN TO SAME BANK");
  TestData = 0x22223333;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData);
  for(j=0; j<6; j++)
  {
    HSA(MemAddr1+4, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestData);
  }
  HSA(MemAddr1+4, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,++TestData);

  HSA(MemAddr1, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , 0x22223333, , NoMask, ,PerformanceTests_14);
  HSA(MemAddr1+4, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , 0x22223334, , NoMask, ,PerformanceTests_15);

  WaitLoop(10);

  TestData = 0x22223333;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData);
  HSA(MemAddr1+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,++TestData);
  HSA(MemAddr3+8, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSW( ,++TestData);

  WaitLoop(10);

  C("TESTING THE CASE WSTRD TIMING ACROSS DIFFERENT BANKS");
  TestData = 0x22223333;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData);
  WaitLoop(6);
  HSA(MemAddr3+8, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , 0x22223335, , HWUnMaskL, ,PerformanceTests_16);

  WaitLoop(10);

  TestData = 0x22223333;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData);
  HSA(MemAddr1+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  WaitLoop(10);

  C("TESTING THE CASE WSTWR TIMING WHEN MOVING ACROSS DIFFERENT BANKS");
  TestData = 0x22223333;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,PerformanceTests_17);
  HSA(MemAddr1+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,++TestData);
  WaitLoop(21);
  HSA(MemAddr3+4, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSW( ,++TestData);

  HSA(MemAddr3+4, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , 0x22223335, , HWUnMaskL, ,PerformanceTests_18);

  WaitLoop(10);

  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData);
  HSA(MemAddr1+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,++TestData);

  WaitLoop(10);

  TestData = 0x22223333;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData);
  WaitLoop(6);
  HSA(MemAddr4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,++TestData);

  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x22223333, , NoMask, ,PerformanceTests_19);
  HSA(MemAddr4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x22223334, , NoMask, ,PerformanceTests_20);

  WaitLoop(10);

  /** Configuring WSTWEN value as 1 **/
  C("TESTING WHEN WSTWEN VALUE AS 1");
  SMBCRData[5] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY2, WSTRD5, WSTWR5, WSTOEN2, WSTWEN1, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5] );

  TestData = 0x22223333;
  HSA(MemAddr3, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData);

   /** Configuring WSTWEN value as 2 **/
   C("TESTING WHEN WSTWEN VALUE AS 2");
  SMBCRData[6] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[6] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK6, WSTIDCY2, WSTRD5, WSTWR5, WSTOEN2, WSTWEN2, SMBCRData[6],
               SSMCTrCS2WTRData[6], WSTBRD2);

  ConfigureMemory(BANK6, SSMCTrMEMBData[6] );

  MemAddr6 = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11);
  HSA(MemAddr6, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData);

  /** Configuring WSTWEN equal to WSTWR = 5 **/
  C("TESTING WSTWEN EQUAL TO WSTWR = 5");
  SMBCRData[5] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY2, WSTRD5, WSTWR5, WSTOEN2, WSTWEN5, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5] );

  HSA(MemAddr3+4, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData);

  /** Configuring WSTWEN equal to WSTWR = 1 **/
  C("TESTING WHEN WSTWEN EQUAL TO WSTWR = 1");
  SMBCRData[6] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[6] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK6, WSTIDCY2, WSTRD3, WSTWR1, WSTOEN1, WSTWEN1, SMBCRData[6],
               SSMCTrCS2WTRData[6], WSTBRD2);

  ConfigureMemory(BANK6, SSMCTrMEMBData[6] );

  HSA(MemAddr6+4, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData);

  WaitLoop(10);

}

/************************************ End *************************************/
