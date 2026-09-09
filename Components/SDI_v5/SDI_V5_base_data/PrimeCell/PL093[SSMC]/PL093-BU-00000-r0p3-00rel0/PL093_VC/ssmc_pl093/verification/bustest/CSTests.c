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
--  File Name              : CSTests.c.rca
--  File Revision          : 1.9
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Chip Select to Output Enable assertion and
--           Chip Select to Write Enable assertion Tests on the SSMC.
--
-- --=========================================================================*/

/******************************************************************************/
/**************************** Chip Select Tests *******************************/
/******************************************************************************/

void CSTests()
{
  /*
     Summary: Chip Select Tests
     ==========================
     This function performs the following:

     o  Checks whether only one CS is asserted corresponding to an address
     o  This is tested by applying all 8 values on HADDR[28:26], keeping
        the remaining 26 address bits unchanged. Eight memory locations are
        written into, each with different data. This data is read back and
        compared. If it matches, then unique CS assertion for each address is
        proved.
  */

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

  /** Configuring the system to LITTLE endian mode  by setting ENDIANNESS = 0 **/
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

  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** ExtWait disabled **/
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

  ConfigureUUT(BANK0, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD2);

  ConfigureMemory(BANK0, SSMCTrMEMBData[0]);

  /** Set Bank 1 Memory Type as SRAM (32 bits width)  ExtWait diasbled **/
  SSMCTrMEMBData[1] = 0x00000000;
  
  SMBCRData[1] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;
  
  SSMCTrCS2WTRData[1] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);

  /** Set Bank 2 Memory Type as SRAM (32 bits width), ExtWait enabled **/
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

  ConfigureUUT(BANK2, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD2);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2]);

  /** Set Bank 3 Memory Type as SRAM (32 bits width), ExtWait enabled **/
  SSMCTrMEMBData[3] = 0x00000000;

  SMBCRData[3] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[3] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK3, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD2);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3]);

  /** Set Bank 4 Memory Type as SRAM (32 bits width), ExtWait enabled **/
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

  /** Set Bank 5 Memory Type as SRAM (32 bits width), ExtWait enabled **/
  SSMCTrMEMBData[5] = 0x00000000;

  SMBCRData[5] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5]);

  /** Set Bank 6 Memory Type as SRAM (32 bits width), ExtWait disabled **/
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

  ConfigureUUT(BANK6, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[6],
               SSMCTrCS2WTRData[6], WSTBRD2);

  ConfigureMemory(BANK6, SSMCTrMEMBData[6]);

  /** Set Bank 7 Memory Type as SRAM (32 bits width), ExtWait disabled **/
  SSMCTrMEMBData[7] = 0x00000000;

  SMBCRData[7] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[7] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK7, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[7],
               SSMCTrCS2WTRData[7], WSTBRD2);

  ConfigureMemory(BANK7, SSMCTrMEMBData[7]);


 SMCS();

}

/************************************ End *************************************/
