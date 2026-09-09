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
--  File Name              : AddrToggleTests.c.rca
--  File Revision          : 1.9
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to toggle all the memory related address bits of the SSMC.
--
-- --=========================================================================*/

/******************************************************************************/
/**************************** Address Toggle Tests ****************************/
/******************************************************************************/

void AddrToggleTests()
{
  /*
     Summary: Address Toggle Tests
     =============================
     This function performs the following:

     o  Toggles all memory related address bits in the SSMC.

     The TrickMem is designed with a memory size of 8K. The remaining higher
     order address is specified in the base address register SSMCTrMEMB.
     For toggling all the 29 lines of address, locations 0x00000000,
     0x55555555, 0xAAAAAAAA and 0xFFFFFFFF are accessed.
  */

  int i, j, Bank_No;
  int32 SSMCMemAddr, AHBMemAddr, WTCNCLData, ExtMuxData, SMBLSPOLData;
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
  HSW( , WTCNCLData);

  /** Configuring the system to LITTLE endian mode **/
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

  /* Programming the SSMCTrSMBLSPOL register */
  SMBLSPOLData = SMBLSPOL_0;
  HSA(SSMCTrSMBLSPOL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBLSPOLData);

  /** Reading from the Memory before it's configured **/
  SSMCMemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  HSA(SSMCMemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , ZERO, , NoMask, ,AddrToggleTests_1);

  /** Set the parameters for the Memory Model **/
  /** Set Bank 0 Memory Type as SRAM (32 bits width), WP & WaitEn disabled **/
  SSMCTrMEMBData[0] = 0x00000000;

  SMBCRData[0] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[0] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR1 | TRWT2DEWT1;

  ConfigureUUT(BANK0, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD2);

  ConfigureMemory(BANK0, SSMCTrMEMBData[0] );

  /** Set Bank 2 Memory Type as SRAM (32 bits width) **/
  SSMCTrMEMBData[2] = 0x00005555;
  
  SMBCRData[2] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR1 | TRWT2DEWT1;

  ConfigureUUT(BANK2, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD2);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2] );

  /** Set Bank 5 Memory Type as SRAM (32 bits width) **/
  SSMCTrMEMBData[5] = 0x00002AAA;
  
  SMBCRData[5] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      | 
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR1 | TRWT2DEWT1;

  ConfigureUUT(BANK5, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5] );

  /** Set Bank 7 Memory Type as SRAM (32 bits width) **/
  SSMCTrMEMBData[7] = 0x00007FFF;
  
  SMBCRData[7] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI | 
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      | 
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[7] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR1 | TRWT2DEWT1;

  ConfigureUUT(BANK7, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[7],
               SSMCTrCS2WTRData[7], WSTBRD2);

  ConfigureMemory(BANK7, SSMCTrMEMBData[7] );

  /** Writing to Bank 0 through the SSMC **/
  C("PERFORMING ADDRTOGGLE TESTS ON BANK 0 WITH ADDR 0x00000000");
  SSMCMemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 10) + 0x000;
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x00000078);

  /** Reading from Bank 0 through the SSMC **/
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSR( , 0x00000078, , 0x000000FF, ,AddrToggleTests_2);

  /** Reading from Bank 0 through the AHB **/
  AHBMemAddr = SSMCTrMEMARRAY0;
  HSA(AHBMemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x00000078, , 0x000000FF, ,AddrToggleTests_3);

  /** Writing to Bank 2 through the SSMC **/
  C("PERFORMING ADDRTOGGLE TESTS ON BANK 2 WITH ADDR 0xAAAAAAAA");
  SSMCMemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 0x2AA;
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x00000021);

  /** Reading from Bank 2 through the SSMC **/
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSR( , 0x00210000, , 0x00FF0000, ,AddrToggleTests_4);

  /** Reading from Bank 2 through the AHB **/
  AHBMemAddr = SSMCTrMEMARRAY2 + 0x0AA8;
  HSA(AHBMemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x00210000, , 0x00FF0000, ,AddrToggleTests_5);

  /** Writing to Bank 5 through the SSMC **/
  C("PERFORMING ADDRTOGGLE TESTS ON BANK 5 WITH ADDR 0x55555555");
  SSMCMemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 0x555;
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x00000078);

  /** Reading from Bank 5 through the SSMC **/
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSR( , 0x00007800, , 0x0000FF00, ,AddrToggleTests_6);

  /** Reading from Bank 5 through the AHB **/
  AHBMemAddr = SSMCTrMEMARRAY5 + 0x1554;
  HSA(AHBMemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x00007800, , 0x0000FF00, ,AddrToggleTests_7);

  /** Writing to Bank 7 through the SSMC **/
  C("PERFORMING ADDRTOGGLE TESTS ON BANK 7 WITH ADDR 0xFFFFFFFF");
  SSMCMemAddr = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11) + 0x7FF;
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x00000021);

  /** Reading from Bank 7 through the SSMC **/
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSR( , 0x21000000, , 0xFF000000, ,AddrToggleTests_8);

  /** Reading from Bank 7 through the AHB **/
  AHBMemAddr = SSMCTrMEMARRAY7 + 0x1FFC;
  HSA(AHBMemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x21000000, , 0xFF000000, ,AddrToggleTests_9);
}

/************************************ End *************************************/
