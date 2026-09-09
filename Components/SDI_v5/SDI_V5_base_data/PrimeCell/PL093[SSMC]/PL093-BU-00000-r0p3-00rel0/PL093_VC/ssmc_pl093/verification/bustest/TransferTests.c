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
--  File Name              : TransferTests.c.rca
--  File Revision          : 1.11
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
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
/*** ConfigureMemory                                    SsmcCommon.c        ***/
/*** ConfigureUUT                                       SsmcCommon.c        ***/
/*** SingleWriteRead                                    SsmcCommon.c        ***/
/*** BurstWriteRead                                     SsmcCommon.c        ***/
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
  int32 BCRData, MemAddr1, MemAddr2, MemAddr3, AHBAddr, TestData, SMBLSPOLData;
  int32 MEMTData, WTCNCLData, ExtMuxData;
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  char  Message[100];
  int i;
  int32 MemAddr, ReadData, ReadData1, ReadData2, ReadData3, ReadData4;
  int32 WriteData1, WriteData2, WriteData ;


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
      disables or Enables the SMCANCELWait signal. The constant 
      SMWAITIGNORE_0/1 enables or disables the SMWAITIGNORE respectively and 
      the constants WTCNCL0 to 63 are used to load the CANCEL WAIT count.
  */
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL10 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  /** Configuring the system to LITTLE endian mode: Setting ENDIANNESS = 0 **/
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

  /** Writing and Reading from the Memory before it's configured **/
  MemAddr1 = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x55555555);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x55555555, , NoMask, ,TransferTests_1);

  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SSMCTrMEMBData[0] = 0x00000000;
  SMBCRData[0] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI | 
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[0] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK0, WSTIDCY2, WSTRD5, WSTWR4, WSTOEN2, WSTWEN0, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD2);
 
  ConfigureMemory(BANK0, SSMCTrMEMBData[0]);

  /** Set Bank 1 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
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

  ConfigureUUT(BANK1, WSTIDCY2, WSTRD5, WSTWR4, WSTOEN2, WSTWEN0, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);

  /** Set Bank 2 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SSMCTrMEMBData[2] = 0x00000000;
  SMBCRData[2] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK2, WSTIDCY2, WSTRD5, WSTWR4, WSTOEN2, WSTWEN0, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD2);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2]);

  /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
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

  ConfigureUUT(BANK3, WSTIDCY2, WSTRD5, WSTWR4, WSTOEN2, WSTWEN0, SMBCRData[3],
               SSMCTrCS2WTRData[3] , WSTBRD2);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3]);

  /** Set Bank 4 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
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

  ConfigureUUT(BANK4, WSTIDCY2, WSTRD2, WSTWR4, WSTOEN2, WSTWEN0, SMBCRData[4],
               SSMCTrCS2WTRData[4], WSTBRD2);

  ConfigureMemory(BANK4, SSMCTrMEMBData[4]);

  /** Set Bank 5 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SSMCTrMEMBData[5] = 0x00000000;
  SMBCRData[5] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI | 
		 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY3, WSTRD7, WSTWR0, WSTOEN3, WSTWEN0, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5]);

  /** Set Bank 6 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SSMCTrMEMBData[6] = 0x00000000;
  SMBCRData[6] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI | 
		 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
		 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[6] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK6, WSTIDCY4, WSTRD6, WSTWR2, WSTOEN4, WSTWEN0, SMBCRData[6],
               SSMCTrCS2WTRData[6], WSTBRD2);

  ConfigureMemory(BANK6, SSMCTrMEMBData[6]);

  /** Set Bank 7 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SSMCTrMEMBData[7] = 0x00000000;
  SMBCRData[7] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI | 
		 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
		 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1 	     | SMBLSPOL_0;

  SSMCTrCS2WTRData[7] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK7, WSTIDCY2, WSTRD5, WSTWR1, WSTOEN4, WSTWEN0, SMBCRData[7],
               SSMCTrCS2WTRData[7], WSTBRD2);

  ConfigureMemory(BANK7, SSMCTrMEMBData[7]);



  /** Different transfer sequences **/
  /** NS-NS to the same bank **/
  C("NS-NS TO THE SAME BANK");
  MemAddr1 = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0x89ABCDEF);
  HSA(MemAddr1+4, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0xFEDCBA98);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x89ABCDEF, , NoMask, ,TransferTests_2);
  HSA(MemAddr1+4, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0xFEDCBA98, , NoMask, ,TransferTests_3);

  /** NS-NS to different banks **/
  C("NS-NS TO DIFFERENT BANKS");
  MemAddr1 = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0x12345678);
  MemAddr2 = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  HSA(MemAddr2, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0x87654321);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x12345678, , NoMask, ,TransferTests_4);
  HSA(MemAddr2, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x87654321, , NoMask, ,TransferTests_5);
  
  /** NS-NS-NS to the same bank **/
  C("NS-NS-NS TO THE SAME BANK");
  MemAddr1 = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0x11223344);
  HSA(MemAddr1+4, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0x22334455);
  HSA(MemAddr1+8, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0x33445566);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , NoMask, ,TransferTests_6);
  HSA(MemAddr1+4, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x22334455, , NoMask, ,TransferTests_7);
  HSA(MemAddr1+8, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x33445566, , NoMask, ,TransferTests_8);

  /** NS-NS-NS to different banks **/
  C("NS-NS-NS TO DIFFERENT BANKS");
  MemAddr1 = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0x44332211);
  MemAddr2 = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11);
  HSA(MemAddr2, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0x55443322);
  MemAddr3 = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11);
  HSA(MemAddr3, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0x66554433);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x44332211, , NoMask, ,TransferTests_9);
  HSA(MemAddr2, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x55443322, , NoMask, ,TransferTests_10);
  HSA(MemAddr3, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x66554433, , NoMask, ,TransferTests_11);

  /** NS-S-S to same bank**/
  C("NS-S-S TO SAME BANK");
  MemAddr1 = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11223344);
  HSW( ,0x22334455);
  HSW( ,0x33445566);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , NoMask, ,TransferTests_12);
  HSR( , 0x22334455, , NoMask, ,TransferTests_13);
  HSR( , 0x33445566, , NoMask, ,TransferTests_14);

  /** NS-I-NS to the same bank **/
  C("NS-I-NS TO THE SAME BANK");
  MemAddr1 = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0xAABBCCDD);
  HSA(MemAddr1+4, IDLE, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0xBBCCDDEE);
  HSA(MemAddr1+8, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0xCCDDEEFF);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xAABBCCDD, , NoMask, ,TransferTests_15);
  HSR( , 0x22334455, , NoMask, ,TransferTests_16);
  HSR( , 0xCCDDEEFF, , NoMask, ,TransferTests_17);

  /** NS-I-NS to different banks **/
  C("NS-I-NS TO DIFFERENT BANKS");
  MemAddr1 = SSMCMEM_3 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0xDDCCBBAA);
  MemAddr2 = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  HSA(MemAddr2, IDLE, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0xEEDDCCBB);
  MemAddr3 = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11);
  HSA(MemAddr3, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0xFFEEDDCC);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0xDDCCBBAA, , NoMask, ,TransferTests_18);
  HSA(MemAddr2, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x44332211, , NoMask, ,TransferTests_19);
  HSA(MemAddr3, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0xFFEEDDCC, , NoMask, ,TransferTests_20);

  /** NS-B-S **/
  C("NS-B-S TO SAME BANK");
  MemAddr1 = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0xAABBCCDD);
  HSA(MemAddr1+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0xBBCCDDEE);
  HSA(MemAddr1+4, SEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0xCCDDEEFF);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xAABBCCDD, , NoMask, ,TransferTests_21);
  HSR( , 0xCCDDEEFF, , NoMask, ,TransferTests_22);

  /** NS-B-NS to the same bank **/
  C("NS-B-NS TO THE SAME BANK"); 
  MemAddr1 = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x12345678);
  HSA(MemAddr1+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x89ABCDEF);
  HSA(MemAddr1+12, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0x01234567);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x12345678, , NoMask, ,TransferTests_23);
  HSR( , 0x22334455, , NoMask, ,TransferTests_24);
  HSA(MemAddr1+12, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x01234567, , NoMask, ,TransferTests_25);

  /** NS-B-NS to different banks **/
  C("NS-B-NS TO DIFFERENT BANKS");
  MemAddr1 = SSMCMEM_7 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x01234567);
  HSA(MemAddr1+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x12345678);
  MemAddr2 = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  HSA(MemAddr2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x23456789);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x01234567, , NoMask, ,TransferTests_26);
  HSR( , 0xCCDDEEFF, , NoMask, ,TransferTests_27);
  HSA(MemAddr2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x23456789, , NoMask, ,TransferTests_28);

  /** NS-B-I to the same bank **/
  C("NS-B-I TO THE SAME BANK"); 
  MemAddr1 = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x024678AC);
  HSA(MemAddr1+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x13579BDF);
  HSA(MemAddr1+8, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x13579BD2);
  HSA(MemAddr1+12, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x2468ACE0);
  HSA(MemAddr1+16, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x2468ACE2);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x024678AC, , NoMask, ,TransferTests_29);
  HSR( , 0x22334455, , NoMask, ,TransferTests_30);
  HSR( , 0xCCDDEEFF, , NoMask, ,TransferTests_31);
  HSR( , 0x01234567, , NoMask, ,TransferTests_32);
  HSR( , 0x2468ACE2, , NoMask, ,TransferTests_33);

  /** NS-S-B-S to the same bank **/
  C("NS-S-B-S TO THE SAME BANK"); 
  MemAddr1 = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111111);
  HSW( ,0x22222222);
  HSA(MemAddr1+8, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x33333333);
  HSA(MemAddr1+8, SEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x44444444);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11111111, , NoMask, ,TransferTests_34);
  HSR( , 0x22222222, , NoMask, ,TransferTests_35);
  HSR( , 0x44444444, , NoMask, ,TransferTests_36);

  /** NS-B-S-B-S to the same bank **/
  C("NS-B-S-B-S TO THE SAME BANK");
  MemAddr1 = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0xAAAAAAAA);
  HSA(MemAddr1+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0xBBBBBBBB);
  HSA(MemAddr1+4, SEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0xCCCCCCCC);
  HSA(MemAddr1+8, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0xDDDDDDDD);
  HSA(MemAddr1+8, SEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0xEEEEEEEE);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xAAAAAAAA, , NoMask, ,TransferTests_37);
  HSR( , 0xCCCCCCCC, , NoMask, ,TransferTests_38);
  HSR( , 0xEEEEEEEE, , NoMask, ,TransferTests_39);

  /** NS-S-B-S to the same bank with WSTBRD = 0 **/
  C("NS-S-B-S to THE SAME BANK: WSTBRD = 0 & HBURST = INCR4");
  MemAddr1 = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111111);
  HSW( ,0x22222222);
  HSA(MemAddr1+8, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x33333333);
  HSA(MemAddr1+8, SEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x33333333);
  HSW( ,0x44444444);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x11111111, , NoMask, ,TransferTests_40);
  HSR( , 0x22222222, , NoMask, ,TransferTests_41);
  HSA(MemAddr1+8, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x33333333, , NoMask, ,TransferTests_42);
  HSA(MemAddr1+8, SEQ, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x33333333, , NoMask, ,TransferTests_43);
  HSR( , 0x44444444, , NoMask, ,TransferTests_44);

  C("NS-S-B-B-B-B-B-B-S-S TO THE SAME BANK: HBURST = INCR4");
  /** Reading the data from the bank 4 with different busy insertion **/
  MemAddr1 = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x11111111, , NoMask, ,TransferTests_45);
  HSR( , 0x22222222, , NoMask, ,TransferTests_46);
  HSA(MemAddr1+8, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x33333333, , NoMask, ,TransferTests_47);
  HSA(MemAddr1+8, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x33333333, , NoMask, ,TransferTests_48);
  HSA(MemAddr1+8, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x33333333, , NoMask, ,TransferTests_49);
  HSA(MemAddr1+8, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x33333333, , NoMask, ,TransferTests_50);
  HSA(MemAddr1+8, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x33333333, , NoMask, ,TransferTests_51);
  HSA(MemAddr1+8, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x33333333, , NoMask, ,TransferTests_52);
  HSA(MemAddr1+8, SEQ, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x33333333, , NoMask, ,TransferTests_53);
  HSR( , 0x44444444, , NoMask, ,TransferTests_54);

  C("NS-S-S-B-B-B-B-B-B-S TO THE SAME BANK: HBURST = INCR4");
  /** Reading the data from the bank 4 with different busy insertion **/
  MemAddr1 = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x11111111, , NoMask, ,TransferTests_55);
  HSR( , 0x22222222, , NoMask, ,TransferTests_56);
  HSR( , 0x33333333, , NoMask, ,TransferTests_57);
  HSA(MemAddr1+12, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x44444444, , NoMask, ,TransferTests_58);
  HSA(MemAddr1+12, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x44444444, , NoMask, ,TransferTests_59);
  HSA(MemAddr1+12, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x44444444, , NoMask, ,TransferTests_60);
  HSA(MemAddr1+12, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x44444444, , NoMask, ,TransferTests_61);
  HSA(MemAddr1+12, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x44444444, , NoMask, ,TransferTests_62);
  HSA(MemAddr1+12, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x44444444, , NoMask, ,TransferTests_63);
  HSR( , 0x44444444, , NoMask, ,TransferTests_64);

  C("NS-B-B-B-B-B-B-S-S-S TO THE SAME BANK: HBURST = INCR4");
  /** Reading the data from the bank 4 with different busy insertion **/
  MemAddr1 = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr1, NSEQ, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x11111111, , NoMask, ,TransferTests_65);
  HSA(MemAddr1+4, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x22222222, , NoMask, ,TransferTests_66);
  HSA(MemAddr1+4, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x22222222, , NoMask, ,TransferTests_67);
  HSA(MemAddr1+4, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x22222222, , NoMask, ,TransferTests_68);
  HSA(MemAddr1+4, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x22222222, , NoMask, ,TransferTests_69);
  HSA(MemAddr1+4, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x22222222, , NoMask, ,TransferTests_70);
  HSA(MemAddr1+4, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x22222222, , NoMask, ,TransferTests_71);
  HSA(MemAddr1+4, SEQ, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , 0x22222222, , NoMask, ,TransferTests_72);
  HSR( , 0x33333333, , NoMask, ,TransferTests_73);
  HSR( , 0x44444444, , NoMask, ,TransferTests_74);

  C("NS-I-NS TO DIFFERENT BANKS WITH DIFFERENT MSIZES");
  /** Case with the MSizes for the two banks different **/
  /** with NS-I-NS to different banks **/

  /** Set Bank 3 Memory Type as SRAM (16 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SSMCTrMEMBData[3] = 0x00000000;
  SMBCRData[3] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[3] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK3, WSTIDCY2, WSTRD5, WSTWR4, WSTOEN2, WSTWEN2, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD2);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3]);
                 

  /** Set Bank 5 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SSMCTrMEMBData[5] = 0x00000000;
  SMBCRData[5] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY3, WSTRD7, WSTWR0, WSTOEN3, WSTWEN0, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5]);
               

  /** Set Bank 2 Memory Type as SRAM (32 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
  SSMCTrMEMBData[2] = 0x00000000;
  SMBCRData[2] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK2, WSTIDCY4, WSTRD6, WSTWR2, WSTOEN4, WSTWEN0, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD2);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2]);
                 

  /** Set Bank 6 Memory Type as SRAM (8 bits width) **/
  /** RBLE Enabled, ExtWait Disabled **/
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

  ConfigureUUT(BANK6, WSTIDCY4, WSTRD6, WSTWR2, WSTOEN4, WSTWEN0, SMBCRData[6],
               SSMCTrCS2WTRData[6], WSTBRD2);

  ConfigureMemory(BANK6, SSMCTrMEMBData[6]);

  /** Case with the MSizes for the two banks being different **/
  /** NS-I-NS to different banks **/
  C("NS-I-NS TO 32 BIT DEVICE FOLLOWED BY 16 BIT DEVICE");
  /** write to 32 bit device followed by idle cycles and **/
  /** write to 16 bit device.**/
  /** This helps in checking for the proper assertion of smbls signals **/

  MemAddr1 = SSMCMEM_2 + 0x04;                       
  HSA(MemAddr1, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( ,0x000000CC);

  WaitLoop(5);
  
  HSA(MemAddr1+1, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( ,0x000000DD);


  WaitLoop(4);

  MemAddr2 = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  HSA(MemAddr2, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0xEEDDCCBB);
  MemAddr3 = SSMCMEM_3 + 0x04;
  HSA(MemAddr3, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( ,0xDDCCBBAA);

  
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xFFEEDDCC, , BUnMask0, ,TransferTests_Cnr1);
  HSA(MemAddr3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xDDCCBBAA, , BUnMask0, ,TransferTests_Cnr1);

  /** Write to 16 bit device followed by idle cycles and **/
  /** write to 32 bit device.**/
  C("NS-I-NS TO 16 BIT DEVICE FOLLOWED BY 32 BIT DEVICE");
  MemAddr1 = SSMCMEM_3 + 0x04;
  HSA(MemAddr1, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( ,0xDDCCBBAA);

  WaitLoop(6);

  MemAddr2 = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  HSA(MemAddr2, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0xEEDDCCBB);

  MemAddr3 = SSMCMEM_2 + 0x04;
  HSA(MemAddr3, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( ,0x000000CC);

  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xDDCCBBAA, , BUnMask0, ,TransferTests_Cnr2);
  HSA(MemAddr3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xFFEEDDCC, , BUnMask0, ,TransferTests_Cnr2);

  /** Write to 8 bit device followed by idle cycles and **/
  /** write to 32 bit device.**/

  C("NS-I-NS TO 8 BIT DEVICE FOLLOWED BY 32 BIT DEVICE");
  MemAddr1 =  SSMCMEM_6 + 0x04;
  HSA(MemAddr1, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( ,0x000000BA);

  WaitLoop(4);

  MemAddr2 = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  HSA(MemAddr2, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0xEEDDCCBB);

  MemAddr3 = SSMCMEM_2 + 0x04;
  HSA(MemAddr3, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( ,0x000000CA);


  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x000000BA, , BUnMask0, ,TransferTests_Cnr3);
  HSA(MemAddr3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x000000CA, , BUnMask0, ,TransferTests_Cnr3);

  /** Write to 16 bit device followed by idle cycles and **/
  /** write to 8 bit device.**/
  C("NS-I-NS TO 16 BIT DEVICE FOLLOWED BY 8 BIT DEVICE");
  MemAddr1 = SSMCMEM_3 + 0x04;
  HSA(MemAddr1, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( ,0x0000001C);
  WaitLoop(5);
  MemAddr2 = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  HSA(MemAddr2, IDLE, INCR, , WRD, , 0x1, , , , ,);
  MemAddr3 = SSMCMEM_6 + 0x04;
  HSA(MemAddr3, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( ,0x000000FF);

  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xDDCCBB1C, , BUnMask0, ,TransferTests_Cnr4);
  HSA(MemAddr3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x000000FF, , BUnMask0, ,TransferTests_Cnr4);

  /** Write to 8 bit device followed by idle cycles and **/
  /** write to 16 bit device.**/
  C("NS-I-NS TO 8 BIT DEVICE FOLLOWED BY 16 BIT DEVICE");
  MemAddr1 = SSMCMEM_6 + 0x04;
  HSA(MemAddr1, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( ,0x00000011);
  WaitLoop(4);
  MemAddr2 = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  HSA(MemAddr2, IDLE, INCR, , WRD, , 0x1, , , , ,);
  MemAddr3 = SSMCMEM_3 + 0x04;
  HSA(MemAddr3, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( ,0x00000022);

  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0xDDCCBB11, , BUnMask0, ,TransferTests_Cnr5);
  HSA(MemAddr3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x00000022, , BUnMask0, ,TransferTests_Cnr5)

  /** Write to 32 bit device followed by write to 8bit **/
  /** device **/
  C("NS-I-NS TO 32 BIT DEVICE FOLLOWED BY 8 BIT DEVICE");
  MemAddr1 = SSMCMEM_2 + 0x04;
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0xDDCCBBAA);
  MemAddr2 = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  HSA(MemAddr2, IDLE, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0xEEDDCCBB);
  MemAddr3 = SSMCMEM_6 + 0x04;
  HSA(MemAddr3, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( ,0xFFEEDDCC);
  /** Reading back the data **/
  HSA(MemAddr1, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0xDDCCBBAA, , NoMask, ,TransferTests_Cnr6);
  HSA(MemAddr3, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0xFFEEDDCC, , NoMask, ,TransferTests_Cnr6);

  /****************************************************************************/
  /*
     The BMWrite and the BMRead Bit in the Synchronous  memory are Disabled
     Writes accesses are done to memory in N-S-S-S sequence
     Wait cycles are introduced after the Write Accesses
     Read accesses are done to the memery in the N-S-S-S sequence.
  */
  /****************************************************************************/

  /** Set Bank 0 Memory Type as Synchronous SRAM  (16 bits width) **/
  SSMCTrMEMBData[0] = 0x00000000;

  SMBCRData[0] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_DI      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[0] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK0, WSTIDCY2, WSTRD5, WSTWR4, WSTOEN2, WSTWEN0, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD2);

  ConfigureMemory(BANK0, SSMCTrMEMBData[0]);

  C("CORNER CASE: THE BMWRITE/READ BIT IS DISABLED IN SYNCHRONOUS MEMORY");
  C("N-S-S-S WRITE SEQUENCE -----------  N-S-S-S READ SEQUENCE");
  /** Writing into Bank 0  **/
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11);
  WriteData1 = 0x00007FFF;
  WriteData2 = WriteData1 + 1;
  WriteData = (WriteData2 << 16) | (WriteData1 & 0x0000FFFF);
  C("WRITE ACCESSES TO SYNCHRONOUS BANK 0: HSIZE = WORD, HBURST = INCR");
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WriteData);
  for (i=0, WriteData1+=2, WriteData2+=2; i<3; i++, WriteData1+=2, 
       WriteData2+=2)
  {
    WriteData = (WriteData2 << 16) | (WriteData1 & 0x0000FFFF);
    HSW( ,WriteData);
  }

   WaitLoop(10);


  /** Reading from Bank 0 SRAM **/
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11);
  ReadData1 = 0x00007FFF;
  ReadData2 = ReadData1 + 1;
  ReadData = (ReadData2 << 16) | (ReadData1 & 0x0000FFFF);
  C("READ ACCESSES TO SYNCHRONOUS BANK 0: HSIZE = WORD, HBURST = INCR");
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,TransferTests_Cnr7);
  for (i=0, ReadData1+=2, ReadData2+=2; i<3; i++, ReadData1+=2, ReadData2+=2)
  {
    ReadData = (ReadData2 << 16) | (ReadData1 & 0x0000FFFF);
    HSR( , ReadData, , NoMask, ,TransferTests_Cnr7);
  }


  /*
     This is a variation of the corner case
     The BMWrite and the BMRead Bit in the Synchronous  memory are Disabled
     Writes accesses are done to memory in N-N-N-N sequence
     Wait cycles are introduced after the Write Accesses
     Read accesses are done to the memery in the N-N-N-N sequence.
  */


  C("N-N-N-N WRITE SEQUENCE -----------  N-N-N-N READ SEQUENCE");
  /** Writing into Bank 0  **/
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11);
  WriteData1 = 0x00007FFF;
  WriteData2 = WriteData1 + 1;
  WriteData = (WriteData2 << 16) | (WriteData1 & 0x0000FFFF);
  C("WRITE ACCESSES TO SYNCHRONOUS BANK 0: HSIZE = WORD, HBURST = INCR");
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WriteData);

  WriteData1 = WriteData1 + 2;
  WriteData2 = WriteData2 + 2;
  WriteData = (WriteData2 << 16) | (WriteData1 & 0x0000FFFF);
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WriteData);

  WriteData1 = WriteData1 + 2;
  WriteData2 = WriteData2 + 2;
  WriteData = (WriteData2 << 16) | (WriteData1 & 0x0000FFFF);
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WriteData);

  WriteData1 = WriteData1 + 2;
  WriteData2 = WriteData2 + 2;
  WriteData = (WriteData2 << 16) | (WriteData1 & 0x0000FFFF);
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WriteData);

   WaitLoop(10);

  /** Reading from Bank 0 SRAM **/
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11);
  ReadData1 = 0x00007FFF;
  ReadData2 = ReadData1 + 1;
  ReadData = (ReadData2 << 16) | (ReadData1 & 0x0000FFFF);
  C("READ ACCESSES ON SYNCHRONOUS BANK 0: HSIZE = WORD, HBURST = INCR");
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,TransferTests_Cnr8);

  ReadData1 = ReadData1 + 2;
  ReadData2 = ReadData2 + 2;
  ReadData = (ReadData2 << 16) | (ReadData1 & 0x0000FFFF);
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,TransferTests_Cnr9);

  ReadData1 = ReadData1 + 2;
  ReadData2 = ReadData2 + 2;
  ReadData = (ReadData2 << 16) | (ReadData1 & 0x0000FFFF);
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,TransferTests_Cnr10);

  ReadData1 = ReadData1 + 2;
  ReadData2 = ReadData2 + 2;
  ReadData = (ReadData2 << 16) | (ReadData1 & 0x0000FFFF);
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,TransferTests_Cnr11);

  /****************************************************************************/
  /*
    Corner case where Write accesses are done across different banks
    Writes accesses are done on consecutive memory locations without any
    IDLE cycles between them
    The written Data is then read back to crosscheck the data written
  */
  /****************************************************************************/

  /** Set Bank 1 Memory Type as Asynchronous SRAM  (16 bits width) **/
  SSMCTrMEMBData[1] = 0x00000000;

  SMBCRData[1] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[1] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY2, WSTRD5, WSTWR4, WSTOEN2, WSTWEN0, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);

  /** Set Bank 2 Memory Type as Asynchronous SRAM  (16 bits width) **/
  SSMCTrMEMBData[2] = 0x00000000;
  SMBCRData[2] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK2, WSTIDCY2, WSTRD5, WSTWR4, WSTOEN2, WSTWEN0, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD2);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2]);

  C("CORNER CASE:");
  C("WRITE ACCESS TO CONSEQUTIVE BANKS WITH HSIZE GREATER THAN MSIZE"); 

  /** Writing into Bank 2  **/
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
  WriteData1 = 0x00007FFF;
  WriteData2 = WriteData1 + 1;
  WriteData = (WriteData2 << 16) | (WriteData1 & 0x0000FFFF);
  C("WRITE ACCESSES TO ASYNCHRONOUS BANK 2: HSIZE = WORD, HBURST = INCR");
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WriteData);
  for (i=0, WriteData1+=2, WriteData2+=2; i<3; i++, WriteData1+=2, 
       WriteData2+=2)
  {
    WriteData = (WriteData2 << 16) | (WriteData1 & 0x0000FFFF);
    HSW( ,WriteData);
  }

  /** Writing into Bank 1  **/
  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  WriteData1 = 0x00008FFF;
  WriteData2 = WriteData1 + 1;
  WriteData = (WriteData2 << 16) | (WriteData1 & 0x0000FFFF);
  C("WRITE ACCESSES TO ASYNCHRONOUS BANK 1: HSIZE = WORD, HBURST = INCR");
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WriteData);
  for (i=0, WriteData1+=2, WriteData2+=2; i<3; i++, WriteData1+=2, 
       WriteData2+=2)
  {
    WriteData = (WriteData2 << 16) | (WriteData1 & 0x0000FFFF);
    HSW( ,WriteData);
  }

  /** Reading from Bank 2 SRAM **/
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
  ReadData1 = 0x00007FFF;
  ReadData2 = ReadData1 + 1;
  ReadData = (ReadData2 << 16) | (ReadData1 & 0x0000FFFF);
  C("READ ACCESS TO BANK 2 TO VERIFY DATA: HSIZE = WORD, HBURST = INCR");
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,TransferTests_Cnr12);
  for (i=0, ReadData1+=2, ReadData2+=2; i<3; i++, ReadData1+=2, ReadData2+=2)
  {
    ReadData = (ReadData2 << 16) | (ReadData1 & 0x0000FFFF);
    HSR( , ReadData, , NoMask, ,TransferTests_Cnr13);
  }

  /** Reading from Bank 1 SRAM **/
  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  ReadData1 = 0x00008FFF;
  ReadData2 = ReadData1 + 1;
  ReadData = (ReadData2 << 16) | (ReadData1 & 0x0000FFFF);
  C("READ ACCESS TO BANK 1 TO VERIFY DATA: HSIZE = WORD, HBURST = INCR");
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,TransferTests_Cnr14);
  for (i=0, ReadData1+=2, ReadData2+=2; i<3; i++, ReadData1+=2, ReadData2+=2)
  {
    ReadData = (ReadData2 << 16) | (ReadData1 & 0x0000FFFF);
    HSR( , ReadData, , NoMask, ,TransferTests_Cnr15);
  }


  /****************************************************************************/
  /*
    Corner cases where BUSY cycle is inserted in between Read accesses
    The different sequences covered are as follows
    N-B-B-B-S-S-S  SEQUENCE
    N-S-B-B-B-S-S  SEQUENCE
    N-S-B-B-B-S-S  SEQUENCE
    Note HSIZE   = HALFWORD
         MSIZE   = WORD
         WSTIDCY = 0
    Bank 3 is configured as an  32 bit Asynchronous Bank
   */
  /****************************************************************************/
  C("CORNER CASE");
  C("BUSY INSERTED IN BETWEEN READS: HSIZE = HALFWORD, MSIZE = WORD"); 
  /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  SSMCTrMEMBData[3] = 0x00000000;

  SMBCRData[3] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_DI      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[3] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK3, WSTIDCY0, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD2);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3]);


  /** Initialise the Memory Bank 3 **/
  TestData = 0xABCD3210;
  AHBWriteMem(3, 0, 16, TestData);

  MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);

  C("N-B-B-B-S-S-S  SEQUENCE");
  ReadData1 = 0xABCD3210;
  ReadData = ReadData1 & HWUnMaskL;
  HSA(MemAddr, NSEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,TransferTests_Cnr16);

  HSA(MemAddr+=2, BUSY, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData & MaskAll, , NoMask, ,TransferTests_Cnr17);

  ReadData = ReadData1 & HWUnMaskB;
  HSA(MemAddr, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,TransferTests_Cnr18);

  ReadData1++;
  ReadData = ReadData1 & HWUnMaskL;
  HSA(MemAddr+=2, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,TransferTests_Cnr19);

  ReadData = ReadData1 & HWUnMaskB;
  HSA(MemAddr+=2, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,TransferTests_Cnr20);

  C("N-S-B-B-B-S-S  SEQUENCE");

  MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  ReadData1 = 0xABCD3210;
  ReadData = ReadData1 & HWUnMaskL;
  HSA(MemAddr, NSEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,TransferTests_Cnr21);

  ReadData = ReadData1 & HWUnMaskB;
  HSA(MemAddr+=2, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,TransferTests_Cnr22);

  HSA(MemAddr+=2, BUSY, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData & MaskAll, , NoMask, ,TransferTests_Cnr23);

  ReadData1++;
  ReadData = ReadData1 & HWUnMaskL;
  HSA(MemAddr, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,TransferTests_Cnr24);

  ReadData = ReadData1 & HWUnMaskB;
  HSA(MemAddr+=2, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,TransferTests_Cnr25);

  C("N-S-B-B-B-S-S  SEQUENCE");

  MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);

  ReadData1 = 0xABCD3210;
  ReadData = ReadData1 & HWUnMaskL;
  HSA(MemAddr, NSEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,TransferTests_Cnr26);

  ReadData = ReadData1 & HWUnMaskB;
  HSA(MemAddr+=2, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,TransferTests_Cnr27);

  ReadData1++;
  ReadData = ReadData1 & HWUnMaskL;
  HSA(MemAddr+=2, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,TransferTests_Cnr28);

  HSA(MemAddr+=2, BUSY, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData & MaskAll, , NoMask, ,TransferTests_Cnr29);

  ReadData = ReadData1 & HWUnMaskB;
  HSA(MemAddr, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,TransferTests_Cnr30);

  /****************************************************************************/
  /*
    Corner cases where BUSY cycle is inserted in between Read accesses
    The different sequences covered are as follows
    N-B-B-B-S-S-S  SEQUENCE
    N-S-B-B-B-S-S  SEQUENCE
    N-S-B-B-B-S-S  SEQUENCE
    Note HSIZE   = HALFWORD
         MSIZE   = WORD
         WSTIDCY = 0
    Bank 3 is configured as an  32 bit Synchronous Bank
   */
  /****************************************************************************/

  C("CORNER CASE");
  C("BUSY INSERTED IN BETWEEN READS: HSIZE = HALFWORD, MSIZE = WORD"); 
  /** Set Bank 4 Memory Type as SYNCHRONOUS  SRAM (32 bits width) **/
  SSMCTrMEMBData[4] = 0x00000000;

  SMBCRData[4] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_DI      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[4] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK4, WSTIDCY0, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[4],
               SSMCTrCS2WTRData[4], WSTBRD2);

  ConfigureMemory(BANK4, SSMCTrMEMBData[4]);


  /** Initialise the Memory Bank 3 **/
  TestData = 0xABBA4440;
  AHBWriteMem(4, 0, 16, TestData);

  MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);

  C("N-B-B-B-S-S-S  SEQUENCE");
  ReadData1 = 0xABBA4440;
  ReadData = ReadData1 & HWUnMaskL;
  HSA(MemAddr, NSEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,TransferTests_Cnr31);

  HSA(MemAddr+=2, BUSY, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData & MaskAll, , NoMask, ,TransferTests_Cnr32);

  ReadData = ReadData1 & HWUnMaskB;
  HSA(MemAddr, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,TransferTests_Cnr33);

  ReadData1++;
  ReadData = ReadData1 & HWUnMaskL;
  HSA(MemAddr+=2, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,TransferTests_Cnr34);

  ReadData = ReadData1 & HWUnMaskB;
  HSA(MemAddr+=2, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,TransferTests_Cnr35);

  C("N-S-B-B-B-S-S  SEQUENCE");

  MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  ReadData1 = 0xABBA4440;
  ReadData = ReadData1 & HWUnMaskL;
  HSA(MemAddr, NSEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,TransferTests_Cnr36);

  ReadData = ReadData1 & HWUnMaskB;
  HSA(MemAddr+=2, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,TransferTests_Cnr37);

  HSA(MemAddr+=2, BUSY, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData & MaskAll, , NoMask, ,TransferTests_Cnr38);

  ReadData1++;
  ReadData = ReadData1 & HWUnMaskL;
  HSA(MemAddr, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,TransferTests_Cnr39);

  ReadData = ReadData1 & HWUnMaskB;
  HSA(MemAddr+=2, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,TransferTests_Cnr40);

  C("N-S-B-B-B-S-S  SEQUENCE");

  MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);

  ReadData1 = 0xABBA4440;
  ReadData = ReadData1 & HWUnMaskL;
  HSA(MemAddr, NSEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,TransferTests_Cnr41);

  ReadData = ReadData1 & HWUnMaskB;
  HSA(MemAddr+=2, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,TransferTests_Cnr42);

  ReadData1++;
  ReadData = ReadData1 & HWUnMaskL;
  HSA(MemAddr+=2, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,TransferTests_Cnr43);

  HSA(MemAddr+=2, BUSY, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData & MaskAll, , NoMask, ,TransferTests_Cnr44);

  ReadData = ReadData1 & HWUnMaskB;
  HSA(MemAddr, SEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,TransferTests_Cnr45);

  C("CORNER CASE -> SYNCHRONOUS WRITE FOLLOWED BY ASYNCHRONOUS WRITE");
  MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSW( ,0x89ABCDEF);

  MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSW( ,0xFEDCBA98);

  MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  ReadData = 0x89ABCDEF;
  HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,TransferTests_Cnr46);

  MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  ReadData = 0xFEDCBA98;
  HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,TransferTests_Cnr47);

  C("CORNER CASE -> ASYNCH 8 BIT WRITE FOLLOWED BY 32 BIT WRITE FROM AHB");
  MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, SINGLE, OK, BYTE, , 0x1, , , , ,);
  HSW( ,0x12345678);

  MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  MemAddr = MemAddr + 0x10;
  HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSW( ,0xABCDEF12);

  MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, SINGLE, OK, BYTE, , 0x1, , , , ,);
  ReadData = 0x00000078;
  HSR( , ReadData, , BUnMask0, ,TransferTests_Cnr48);

  MemAddr = MemAddr + 0x10;
  HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  ReadData = 0xABCDEF12;
  HSR( , ReadData, , NoMask, ,TransferTests_Cnr49);

  C("CORNER CASE -> 8 BIT CONSECUTIVE WRITES TO BANK0(WP) AND BANK1(16 BIT)");
  SSMCTrMEMBData[3] = 0x00000000;

  SMBCRData[3] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_DI      |
                 CRWP_EN          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[3] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK3, WSTIDCY0, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD2);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3]);

  /** Set Bank 1 Memory Type as Asynchronous SRAM  (16 bits width) **/
  SSMCTrMEMBData[1] = 0x00000000;

  SMBCRData[1] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[1] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY2, WSTRD5, WSTWR4, WSTOEN2, WSTWEN0, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);

  MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, SINGLE, ERROR, BYTE, , 0x1, , , , ,);
  HSW( ,0x12345678);

  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  HSA(MemAddr, NSEQ, SINGLE, OK, BYTE, , 0x1, , , , ,);
  HSW( ,0x00000012);

  ReadData = 0x00000012;
  HSA(MemAddr, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , BUnMask0, ,TransferTests_Cnr50);
}

/************************************ End *************************************/
