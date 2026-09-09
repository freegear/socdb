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
--  File Name              : ProtectionTests.c.rca
--  File Revision          : 1.9
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform write protection and bus e_r_r_o_r flag tests
--           on the SSMC.
--
-- ===========================================================================*/

/******************************************************************************/
/************* Write Protection and Bus E_R_R_O_R flag Tests ******************/
/******************************************************************************/

void ProtectionTests()
{
  /*
     Summary: Write Protection and Bus E_R_R_O_R flag Tests
     ======================================================
     This function performs the following:

     o  Checks the setting and clearing logic of the BUS E_R_R_O_R and 
        WRITE PROTECT E_R_R_O_R flags
     o  Checks WPERR flag for WRITE PROTECT E_R_R_O_R Protection mode of SRAMs
  */

  char size[3] = {'b', 'h', 'w'};
  int32 TempMSIZE, BCRData, MemAddr, MemType, TestData,
        WTCNCLData, ExtMuxData, AHBAddr, SMBLSPOLData;


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
  HSW( , WTCNCLData);

  /** Configuring the system to LITTLE endian mode  setting ENDIANNESS = 0 **/
  ENDIANNESS = 0;
  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ENDIANNESS);
  HSEN(LITTLE);

  /*
      Programming the SSMCTrExtMuxWT register.The constant ExtMuxDI/EN disables
      or enables the  External Mux. The constants ExtMuxAss0 to 15 and
      ExtMuxDAss0 to 15 define the Assertion and Deassertion counts.
  */
  ExtMuxData = ExtMuxAss5 | ExtMuxDAss5 | ExtMuxDI;
  HSA(SSMCTrExtMux, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ExtMuxData);

  /** Programming the SSMCTrSMBLSPOL register **/
  SMBLSPOLData = SMBLSPOL_0;
  HSA(SSMCTrSMBLSPOL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBLSPOLData);

  /** Set Bank 0 Memory Type as ROM (32 bits width) **/
  SSMCTrMEMBData[0] = 0x00000000;

  SMBCRData[0] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[0] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK0, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD2);

  ConfigureMemory(BANK0, SSMCTrMEMBData[0]);

  /** Set Bank 4 Memory Type as SRAM (32 bits width) **/
  SSMCTrMEMBData[4] = 0x00000000;
  SMBCRData[4] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[4] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK4, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[4],
               SSMCTrCS2WTRData[4], WSTBRD2);

  ConfigureMemory(BANK4, SSMCTrMEMBData[4]);

  /** Set Bank 5 Memory Type as ROM (32 bits width) **/
  SSMCTrMEMBData[5] = 0x00000000;

  SMBCRData[5] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        | 
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5]);

  /** Set Bank 6 Memory Type as BROM (8 bits width) **/
  SSMCTrMEMBData[6] = 0x00000000;
  
  SMBCRData[6] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW8            | RBLE_0           | SMBLSPOL_0;
  
  SSMCTrCS2WTRData[6] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK6, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[6],
               SSMCTrCS2WTRData[6], WSTBRD2);

  ConfigureMemory(BANK6, SSMCTrMEMBData[6]);

  /** Set Bank 7 Memory Type as BROM (16 bits width) **/
  SSMCTrMEMBData[7] = 0x00000000;
  SMBCRData[7] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[7] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK7, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[7],
               SSMCTrCS2WTRData[7], WSTBRD2);

  ConfigureMemory(BANK7, SSMCTrMEMBData[7]);


  /** Initialise the ROM/BROMs from AHB side **/
  AHBWriteMem(0, 0, 4, 0xAABBCCDD);
  AHBWriteMem(5, 0, 4, 0x11223344);
  AHBWriteMem(6, 0, 4, 0x00000055);
  AHBWriteMem(7, 0, 4, 0x0000AABB);

  /*
     The following three testcases test for the bussize error by performing 
     nonword accesses to different banks.The error flag in the respective 
     status registers are expected to set indicating an error. 
  */  
  C("NON WORD ACCESS TO SMBIDCYR4 REGISTER: EXPECT E_R_R_O_R RESPONCE");
  HSA(SMBIDCYR4, NSEQ, INCR, ERROR, HWRD, , 0x1, , , , ,);  
  HSW( , 0xAAAAAAAA);

  C("NON WORD ACCESS TO SMBWSTRDR5 REGISTER: EXPECT E_R_R_O_R RESPONCE");
  HSA(SMBWSTRDR5, NSEQ, INCR, ERROR, BYTE, , 0x1, , , , ,);
  HSW( , 0x55555555);
  
  C("NON WORD ACCESS TO THE SMBWSTWRR6 REGISTER: EXPECT E_R_R_O_R RESPONCE");
  HSA(SMBWSTWRR6, NSEQ, INCR, ERROR, HWRD, , 0x1, , , , ,);
  HSR( , 0x00000000, , MaskAll, ,ProtectionTests_1);

  /*
    The following testcases check the write protection for the different banks.
    Write acces are done to banks which are are protected and then the status 
    registers of the respective banks are read to check whether the write 
    protection flags are set or not. 
  */
  /** Write into the ROM (Bank 5) through the SSMC **/
  C("WRITE TO BANK 5 CONFIGURED AS ROM: EXPECT E_R_R_O_R RESPONCE");
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x44332211);

  /** Checks for the unmodified data **/
  C("READ ROM BANK 5 TO CHECK THE ORIGINAL DATA");
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , NoMask, ,ProtectionTests_2);

  /** Write into the SRAM (Bank 4) through the SSMC **/
  MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0xDEADBEEF);

  /** Reread  the data written into the bank 4 **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0xDEADBEEF, , NoMask, ,ProtectionTests_3);

  C("WRITES TO THE DIFFERENT ROM BANKS: EXPECT E_R_R_O_R RESPONCE");
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0xA1B2C3D4);

  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0xABCDEF01);

  MemAddr = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x12345678);

  MemAddr = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, HWRD, , 0x1, , , , ,);
  HSW( , 0x00005678);

  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11) + 4;
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0xAB12CD34);

  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 4;
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x87654321);

  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 8;
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x11112222);

  MemAddr = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11) + 1;
  HSA(MemAddr, NSEQ, INCR, ERROR, BYTE, , 0x1, , , , ,);
  HSW( , 0x00000033);

  MemAddr = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11) + 2;
  HSA(MemAddr, NSEQ, INCR, ERROR, HWRD, , 0x1, , , , ,);
  HSW( , 0x00001234);

  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11) + 8;
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x11223344);

  MemAddr = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11) + 2;
  HSA(MemAddr, NSEQ, INCR, ERROR, BYTE, , 0x1, , , , ,);
  HSW( , 0x00000044);

  MemAddr = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11) + 3;
  HSA(MemAddr, NSEQ, INCR, ERROR, BYTE, , 0x1, , , , ,);
  HSW( , 0x00000055);

  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 12;
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x87654321);

  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11) + 12;
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x12345678);

  MemAddr = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11) + 4;
  HSA(MemAddr, NSEQ, INCR, ERROR, HWRD, , 0x1, , , , ,);
  HSW( , 0x00008765);

  /** Checks for the unmodified data **/
  C("READ ROM DATA: CHECK IF ORIGINAL DATA IS CORRUPTED");
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11);
  TestData = 0xAABBCCDD;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,ProtectionTests_4);
  HSR( , TestData++, , NoMask, ,ProtectionTests_5);
  HSR( , TestData++, , NoMask, ,ProtectionTests_6);
  HSR( , TestData, , NoMask, ,ProtectionTests_7);

  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  TestData = 0x11223344;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,ProtectionTests_8);
  HSR( , TestData++, , NoMask, ,ProtectionTests_9);
  HSR( , TestData++, , NoMask, ,ProtectionTests_10);
  HSR( , TestData, , NoMask, ,ProtectionTests_11);

  MemAddr = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11);
  TestData = 0x58575655;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,ProtectionTests_12);

  MemAddr = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11);
  TestData = 0x0000AABB;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0xAABCAABB, , NoMask, ,ProtectionTests_13);
  HSA(MemAddr+4, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , 0x0000AABD, , HWUnMaskL, ,ProtectionTests_14);


  C("D O U B L E  W O R D  ACCESS TO BANK 4: EXPECTING E_R_R_O_R RESPONCE");
  MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  HSA(MemAddr, NSEQ, INCR, ERROR, DWRD, , 0x1, , , , ,);
  HSW( , 0xDEADBEEF);

}

/************************************ End *************************************/
