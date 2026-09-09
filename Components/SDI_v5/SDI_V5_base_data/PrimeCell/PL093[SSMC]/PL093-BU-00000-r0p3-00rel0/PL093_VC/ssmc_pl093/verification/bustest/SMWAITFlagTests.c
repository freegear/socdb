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
--  File Name              : SMWAITFlagTests.c.rca
--  File Revision          : 1.10
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform SMWAIT Flag Tests on the SSMC.
--
-- --=========================================================================*/

/******************************************************************************/
/***************************** SMWAIT Flag Tests ******************************/
/******************************************************************************/

void SMWAITFlagTests()
{
  /*
     Summary: SMWAIT Flag Tests
     ==========================
     This function performs the following:

     o  SMWAIT is asserted and de-asserted before and after 32 wait states
     o  SMWAIT Flag is monitored
     o  SMWAIT is asserted after WSTRD/WSTWR followed by transfers to that bank
        and other banks
     o  Checks for SMWAIT Flag is not set and it gives ERROR response
     o  Checks boundary cases of assertion of SMWAIT just before the WSTRD/WSTWR
        counter expiry and also on the same clock of counter expiry
     o  Checks a boundary case of de-assertion of SMWAIT on the 32 wait states
  */

  int32 MemAddr, StatValue, TestData, EWSValue, WTCNCLData, ExtMuxData,
        SMBLSPOLData;


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

  C("CONFIGURING THE SSMC AND THE MEMORY BANKS WITH SMWAIT ENABLED");
  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/
  SSMCTrMEMBData[0] = 0x00000000;
  
  SMBCRData[0] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  
  SSMCTrCS2WTRData[0] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR4 | TRWT2DEWT2;

  ConfigureUUT(BANK0, WSTIDCY2, WSTRD15, WSTWR15, WSTOEN2, WSTWEN0, 
               SMBCRData[0], SSMCTrCS2WTRData[0], WSTBRD1);

  ConfigureMemory(BANK0, SSMCTrMEMBData[0]);



  /** Set Bank 1 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/
  SSMCTrMEMBData[1] = 0x00000000;

  SMBCRData[1] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[1] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR5 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY2, WSTRD15, WSTWR15, WSTOEN2, WSTWEN0,
               SMBCRData[1], SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);
  

  /** Set Bank 2 Memory Type as SRAM (32 bits width) **/
  SSMCTrMEMBData[2] = 0x00000000;
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case enabled **/

  SMBCRData[2] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR5 | TRWT2DEWT3;

  ConfigureUUT(BANK2, WSTIDCY2, WSTRD0, WSTWR4, WSTOEN0, WSTWEN0,
               SMBCRData[2], SSMCTrCS2WTRData[2], WSTBRD2);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2]);

  /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case enabled **/
  SSMCTrMEMBData[3] = 0x00000000;

  SMBCRData[3] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[3] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR5 | TRWT2DEWT5;

  ConfigureUUT(BANK3, WSTIDCY2, WSTRD0, WSTWR4, WSTOEN0, WSTWEN0,
               SMBCRData[3], SSMCTrCS2WTRData[3], WSTBRD2);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3]);
  
  /** Set Bank 4 Memory Type as SRAM (16 bits width) **/
  SSMCTrMEMBData[4] = 0x00000000;
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/

  SMBCRData[4] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[4] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR7 | TRWT2DEWT8;

  ConfigureUUT(BANK4, WSTIDCY2, WSTRD10, WSTWR4, WSTOEN2, WSTWEN0,
               SMBCRData[4], SSMCTrCS2WTRData[4], WSTBRD2);

  ConfigureMemory(BANK4, SSMCTrMEMBData[4]);


  /** Set Bank 5 Memory Type as SRAM (16 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/
  SSMCTrMEMBData[5] = 0x00000000;

  SMBCRData[5] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR6 | TRWT2DEWT8;

  ConfigureUUT(BANK5, WSTIDCY3, WSTRD10, WSTWR0, WSTOEN3, WSTWEN0,
               SMBCRData[5], SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5]);


  /** Set Bank 6 Memory Type as SRAM (8 bits width) **/
  SSMCTrMEMBData[6] = 0x00000000;
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/

  SMBCRData[6] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[6] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR6 | TRWT2DEWT9;

  ConfigureUUT(BANK6, WSTIDCY4, WSTRD11, WSTWR2, WSTOEN4, WSTWEN0,
               SMBCRData[6], SSMCTrCS2WTRData[6], WSTBRD2);

  ConfigureMemory(BANK6, SSMCTrMEMBData[6]);

  /** Set Bank 7 Memory Type as SRAM (8 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/
  SSMCTrMEMBData[7] = 0x00000000;

  SMBCRData[7] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[7] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR6 | TRWT2DEWT6;

  ConfigureUUT(BANK7, WSTIDCY2, WSTRD12, WSTWR1, WSTOEN5, WSTWEN0,
               SMBCRData[7], SSMCTrCS2WTRData[7], WSTBRD2);

  ConfigureMemory(BANK7, SSMCTrMEMBData[7]);


  C("SMWAIT IS ASSERTED BEFORE COUNTER EXPIRY");
  SSMCTrCS2WTRData[0] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR5 | TRWT2DEWT2;
  HSA(SSMCTrCS2WTR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrCS2WTRData[0]);

  /** Write into the Memory through the SSMC **/
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11);
  TestData = 0x55555555;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,TestData);

  /** Read from the Memory through the SSMC **/
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,SMWAITFlagTests_1);

  StatValue = ZERO;
  ReadStatus(0, StatValue);

  C("SMWAIT IS ASSERTED AFTER COUNTER EXPIRY");
  SSMCTrCS2WTRData[0] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR14 | TRWT2DEWT10;
  HSA(SSMCTrCS2WTR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrCS2WTRData[0]);

  /** Write into the Memory through the SSMC **/
  TestData = 0xAAAAAAAA;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,TestData);

  /** Read from the Memory through the SSMC **/
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,SMWAITFlagTests_2);

  ReadStatus(0, StatValue);

  C("SMWAIT IS ASSERTED AT COUNTER EXPIRY");
  SSMCTrCS2WTRData[0] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR8 | TRWT2DEWT3;
  HSA(SSMCTrCS2WTR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrCS2WTRData[0]);

  /** Write into the Memory through the SSMC **/
  TestData = 0xAAAAAAAA;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,TestData);

  /** Read from the Memory through the SSMC **/
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,SMWAITFlagTests_3);

  ReadStatus(0, StatValue);

  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  TestData = 0x11223344;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,TestData);
  HSW( ,0x12345678);


  C("CHECKING FOR WAIT OUT E_R_R_O_R FLAG SETTING FOR BANK 0");
  /** Enabling the Cancel Wait Signal **/
  WTCNCLData = SMWTCNCLEN | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  /** Programming the SSMCTrCS2WTR0 register **/
  SSMCTrCS2WTRData[0] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR5 | TRWT2DEWT10;
  HSA(SSMCTrCS2WTR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrCS2WTRData[0]);

  /** Write into the Memory through the SSMC **/
  /** The transfer gets aborted due to CancelWait with ERROR response **/
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( ,0x11111111);

  /** Disabling  the CancelWait  Signal **/
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  WaitLoop(2);
  StatValue = 0x01;
  ReadStatus(0, StatValue);

  ClrStatus(0);

  WaitLoop(2);


  C("CHECKING FOR WAIT OUT E_R_R_O_R FLAG SETTING FOR BANK 1");
  /** Enabling the Cancel Wait Signak  **/
  WTCNCLData = SMWTCNCLEN | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  /** Programming the SSMCTrCS2WTR1 register **/
  SSMCTrCS2WTRData[1] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR5 | TRWT2DEWT20;
  HSA(SSMCTrCS2WTR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrCS2WTRData[1]);

  /** Write into the Memory through the SSMC **/
  /** The transfer gets aborted due to CancelWait with ERROR response **/
  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( ,0x22222222);

  /** Disabling  the CancelWait Signal **/
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  WaitLoop(2);
  StatValue = 0x01;
  ReadStatus(1, StatValue);

  ClrStatus(1);

  WaitLoop(2);


  C("CHECKING FOR WAIT OUT E_R_R_O_R FLAG SETTING FOR BANK 2");
  /** Enabling the Cancel Wait Signal **/
  WTCNCLData = SMWTCNCLEN | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  /** Programming the SSMCTrCS2WTR2 register **/
  SSMCTrCS2WTRData[2] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT10;
  HSA(SSMCTrCS2WTR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrCS2WTRData[2]);

  /** Write into the Memory through the SSMC **/
  /** The transfer gets aborted due to CancelWait with ERROR response **/
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( ,0x33333333);

  /** Disabling  the CancelWait Signal **/
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  WaitLoop(2);
  StatValue = 0x01;
  ReadStatus(2, StatValue);

  ClrStatus(2);

  WaitLoop(2);

  C("CHECKING FOR WAIT OUT E_R_R_O_R FLAG SETTING FOR BANK 3");
  /** Enabling the Cancel Wait Signal **/
  WTCNCLData = SMWTCNCLEN | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  /** Programming the SSMCTrCS2WTR0 register **/
  SSMCTrCS2WTRData[3] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT10;
  HSA(SSMCTrCS2WTR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrCS2WTRData[3]);

  /** Write into the Memory through the SSMC **/
  /** The transfer gets aborted due to CancelWait with ERROR response **/
  MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( ,0x44444444);

  /** Disabling  the CancelWait Signal **/
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  WaitLoop(2);
  StatValue = 0x01;
  ReadStatus(3, StatValue);

  ClrStatus(3);

  WaitLoop(2);

  C("CHECKING FOR WAIT OUT E_R_R_O_R FLAG SETTING FOR BANK 4");
  /** Enabling the Cancel Wait Signal **/
  WTCNCLData = SMWTCNCLEN | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  /** Programming the SSMCTrCS2WTR0 register **/
  SSMCTrCS2WTRData[4] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR5 | TRWT2DEWT10;
  HSA(SSMCTrCS2WTR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrCS2WTRData[4]);

  /** Write into the Memory through the SSMC **/
  /** The transfer gets aborted due to CancelWait with ERROR response **/
  MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( ,0x55555555);

  /** Disabling  the CancelWait Signal **/
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  WaitLoop(2);
  StatValue = 0x01;
  ReadStatus(4, StatValue);

  ClrStatus(4);

  WaitLoop(2);

  C("CHECKING FOR WAIT OUT E_R_R_O_R FLAG SETTING FOR BANK 5");
  /* Programming the SSMCTrWTCNCL register */
  WTCNCLData = SMWTCNCLEN | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  /** Programming the SSMCTrCS2WTR0 register **/
  SSMCTrCS2WTRData[5] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR1 | TRWT2DEWT10;
  HSA(SSMCTrCS2WTR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrCS2WTRData[5]);

  /** Write into the Memory through the SSMC **/
  /** The transfer gets aborted due to CancelWait with ERROR response **/
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( ,0x66666666);

  /** Disabling  the CancelWait Signal **/
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  WaitLoop(2);
  StatValue = 0x01;
  ReadStatus(5, StatValue);

  ClrStatus(5);

  WaitLoop(2);

  C("CHECKING FOR WAIT OUT E_R_R_O_R FLAG SETTING FOR BANK 6");
  /** Enabling the Cancel wait Signal  **/
  WTCNCLData = SMWTCNCLEN | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  /** Programming the SSMCTrCS2WTR0 register **/
  SSMCTrCS2WTRData[6] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR5 | TRWT2DEWT10;
  HSA(SSMCTrCS2WTR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SSMCTrCS2WTRData[6]);

  /** Write into the Memory through the SSMC **/
  /** The transfer gets aborted due to CancelWait with ERROR response **/
  MemAddr = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( ,0x77777777);

  /** Disabling the CancelWait Signal **/
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  WaitLoop(2);
  StatValue = 0x01;
  ReadStatus(6, StatValue);

  ClrStatus(6);

  WaitLoop(2);

  C("CHECKING FOR WAIT OUT E_R_R_O_R FLAG SETTING FOR BANK 7");
  /** ENABLING THE CANCEL WAIT SIGNAL **/
  WTCNCLData = SMWTCNCLEN | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  /** Programming the SSMCTrCS2WTR0 register **/
  SSMCTrCS2WTRData[7] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR5 | TRWT2DEWT10;
  HSA(SSMCTrCS2WTR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrCS2WTRData[7]);

  /** Write into the Memory through the SSMC **/
  /** The transfer gets aborted due to CancelWait with ERROR response **/
  MemAddr = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( ,0x88888888);

  /** Disabling  the CancelWait SIGNAL  **/
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL2 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  WaitLoop(2);
  StatValue = 0x01;
  ReadStatus(7, StatValue);

  ClrStatus(7);

  WaitLoop(2);


  C("SMWAIT IS DE-ASSERTED AND CANCELSMWAIT IS ASSERTED SIMULTANEOUSLY");
  /** CALCULATING AND PROGRAMMING THE VALUE OF THE WTCNCLData **/
  WTCNCLData = SMWTCNCLEN | WTIG0 | WTCNCL26;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  HSA(SSMCTrCS2WTR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrCS2WTRData[1]);

  /** Write into the Memory through the SSMC  **/
  /** The transfer gets aborted and expecting ERROR response **/
  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR , WRD, , 0x1, , , , ,);
  HSW( ,0x11223344);

  /** Disabling the Cancel Wait Signal **/
  WTCNCLData = SMWTCNCLDI | WTIG1 | WTCNCL20;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  WaitLoop(2);

  StatValue = 0x01;
  ReadStatus(1, StatValue);

  ClrStatus(1);
  WaitLoop(5);

  TestData = 0x11223344;
  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,TestData);
  HSW( ,0x12345678);

  C("SMWAIT IS DE-ASSERTED AFTER CANCELSMWAIT ASSERTION");
  /** ENABLING THE CANCEL WAIT SIGNAL **/
  WTCNCLData = SMWTCNCLEN | WTIG1 | WTCNCL8;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  SSMCTrCS2WTRData[1] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT30;
  HSA(SSMCTrCS2WTR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrCS2WTRData[1]);

  /** Write into the Memory through the SSMC **/
  /** The transfer gets aborted and expecting ERROR response **/
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( ,TestData);

  /** Read from the Memory through the SSMC **/
  /** Since the SMWAIT is still asserted, the transfer gets aborted and **/
  /** expecting ERROR response **/
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSR( , ZERO, , NoMask, ,SMWAITFlagTests_4);

  WaitLoop(1);

  EWSValue = 0x01;
  ReadCSR(EWSValue);

  StatValue = 0x01;
  ReadStatus(1,StatValue);

  EWSValue = 0x00;
  ReadCSR(EWSValue);

  ClrStatus(1);

  /** Read the Memory through the SSMC data **/
  /** Since the SMWAIT is still asserted, the transfer gets aborted and **/
  /** expecting ERROR response **/
  HSA(MemAddr+4, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSR( , ZERO, , NoMask, ,SMWAITFlagTests_5);

  WaitLoop(1);
  EWSValue = 0x01;
  ReadCSR(EWSValue);

  StatValue = 0x01;
  ReadStatus(1,StatValue);

  EWSValue = 0x00;
  ReadCSR(EWSValue);

  ClrStatus(1);

  /** Reconfigure the CEWT Register for proper operation **/
  SSMCTrCS2WTRData[1] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR5 | TRWT2DEWT2;
  HSA(SSMCTrCS2WTR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrCS2WTRData[1]);

  /** Read the Memory for the unmodified data **/
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,SMWAITFlagTests_6);
  HSR( , 0x12345678, , NoMask, ,SMWAITFlagTests_7);


  /** SMWAIT is Asserted when the Timer count has reached 1 **/
  /** This is tested to verify that the SMWAIT assertion is given **/
  /** preference even if the Timer count value has reached one **/

  /** Set Bank 1 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/

  C("SMWAIT ASSERTED WHEN COUNT VALUE IS 1");

  SSMCTrMEMBData[1] = 0x00000000;

  SMBCRData[1] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[1] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR9 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY2, WSTRD11, WSTWR11, WSTOEN2, WSTWEN0,
               SMBCRData[1], SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);

  /** DISABLNG THE CANCEL WAIT SIGNAL **/
  WTCNCLData = SMWTCNCLDI | WTIG1 | WTCNCL30;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);

  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11112222);

  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11112222, , NoMask, ,SMWAITFlagTests_8);
 
  WaitLoop(6);

  /*
    Corner case where an externally waited write is cancelled to  
    a 16 bit memory and read is performed on 32 bit memory 
    Bank5 is configured as 16 bit memory and externally waited write 
    is cancelled to bank5 and a read is performed on the bank1 configured 
    as 32 bit 
 */

 C("CORNER CASE: EXTERNALLY WAITED WRITE IS CANCELLED TO A 16 BIT MEMORY");
 C("READ ACCESS IS DONE TO 32 BIT MEMORY");

  /** Set Bank 5 Memory Type as SRAM (16 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/

  SSMCTrMEMBData[5] = 0x00000000;

  SMBCRData[5] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT5;

  ConfigureUUT(BANK5, WSTIDCY3, WSTRD31, WSTWR31, WSTOEN3, WSTWEN0,
               SMBCRData[5], SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5]);

  C("SMWAIT IS DE-ASSERTED AFTER CANCELSMWAIT ASSERTION"); 
  /** ENABLING THE CANCEL WAIT SIGNAL **/
  WTCNCLData = SMWTCNCLEN | WTIG1 | WTCNCL1 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  HSA(SSMCTrCS2WTR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrCS2WTRData[5]);

  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  TestData = 0x12345678;
  HSA(MemAddr, NSEQ, INCR, ERROR , WRD, , 0x1, , , , ,);
  HSW( ,TestData);

  /** Read the Memory through the SSMC data **/
  /** The transfer gets aborted and expecting ERROR response **/
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSR( , ZERO, , NoMask, ,SMWAITFlagTests_9);

  /** DISABLING THE CANCEL WAIT SIGNAL **/
  WTCNCLData = SMWTCNCLDI | WTIG1 | WTCNCL1 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);


  WaitLoop(8); 

  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);

  /** Reading the data from bank1**/
  HSA(MemAddr, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x11112222, , NoMask, ,SMWAITFlagTests_10);

  
}

/************************************ End *************************************/
