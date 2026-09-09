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
--  File Name              : SyAddrToggleTests.c.rca
--  File Revision          : 1.8
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to toggle all the memory related address bits of the SSMC.
--
-- --=========================================================================*/

/******************************************************************************/
/************************** Synchronous Address Toggle Tests ******************/
/******************************************************************************/

void SyAddrToggleTests()
{
  /*
     Summary: Synchronous Address Toggle Tests
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

  /** Configuring the system to LITTLE endian mode by setting ENDIANNESS = 0 **/
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

  /** Set the parameters for the Memory Model **/
  /** Set Bank 1 as Synchronmous SRAM (32 bits width), WP & WaitEn disabled **/
  SSMCTrMEMBData[1] = 0x00000000;

  SMBCRData[1] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN | CRSYNCENWR_SY |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
		 CRBURSTLENWR4    | CRBURSTLENRD4 |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI | WRAPRD_DI        |
		 CRWAITEN_DI      | CRWAITPOL_0   |
                 BIWRITE_DI       | BIREAD_DI        |
		 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[1] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR1 | TRWT2DEWT1;

  ConfigureUUT(BANK1, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);

  /** Set Bank 3  as Synchronmous SRAM (32 bits width) **/
  SSMCTrMEMBData[3] = 0x00005555;
  
  SMBCRData[3] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
		 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
		 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
		 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[3] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR1 | TRWT2DEWT1;

  ConfigureUUT(BANK3, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD2);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3]);

  /** Set Bank 4 as Synchronmous SRAM (32 bits width) **/
  SSMCTrMEMBData[4] = 0x00002AAA;
  
  SMBCRData[4] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
		 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
		 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
		 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[4] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR1 | TRWT2DEWT1;

  ConfigureUUT(BANK4, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[4],
               SSMCTrCS2WTRData[4], WSTBRD2);

  ConfigureMemory(BANK4, SSMCTrMEMBData[4]);

  /** Set Bank 6 as Synchronmous SRAM (32 bits width) **/
  SSMCTrMEMBData[6] = 0x00007FFF;
  
  SMBCRData[6] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
		 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[6] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR1 | TRWT2DEWT1;

  ConfigureUUT(BANK6, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[6],
               SSMCTrCS2WTRData[6], WSTBRD2);

  ConfigureMemory(BANK6, SSMCTrMEMBData[6]);

  /** Writing to Bank 1 through the SSMC **/
  sprintf(report,"PERFORMING ADDRTOGGLE TESTS ON BANK 1 WITH ADDR 0x00000000");
  C(report);
  SSMCMemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 10) + 0x000;
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x00000078);

  /** Reading from Bank 1 through the SSMC **/
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSR( , 0x00000078, , 0x000000FF, ,SyAddrToggleTests_1);

  /** Reading from Bank 1 through the AHB **/
  AHBMemAddr = SSMCTrMEMARRAY1;
  HSA(AHBMemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x00000078, , 0x000000FF, ,);

  /** Writing to Bank 3 through the SSMC **/
  sprintf(report,"PERFORMING ADDRTOGGLE TESTS ON BANK 3 WITH ADDR 0xAAAAAAAA");
  C(report);
  SSMCMemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11) + 0x2AA;
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x00000021);

  /** Reading from Bank 3 through the SSMC **/
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSR( , 0x00210000, , 0x00FF0000, ,SyAddrToggleTests_3);

  /** Reading from Bank 3 through the AHB **/
  AHBMemAddr = SSMCTrMEMARRAY3 + 0x0AA8;
  HSA(AHBMemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x00210000, , 0x00FF0000, ,SyAddrToggleTests_4);

  /** Writing to Bank 4 through the SSMC **/
  sprintf(report,"PERFORMING ADDRTOGGLE TESTS ON BANK 4 WITH ADDR 0x55555555");
  C(report);
  SSMCMemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11) + 0x555;
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x00000078);

  /** Reading from Bank 4 through the SSMC **/
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSR( , 0x00007800, , 0x0000FF00, ,SyAddrToggleTests_5);

  /** Reading from Bank 4 through the AHB **/
  AHBMemAddr = SSMCTrMEMARRAY4 + 0x1554;
  HSA(AHBMemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x00007800, , 0x0000FF00, ,SyAddrToggleTests_6);

  /** Writing to Bank 6 through the SSMC **/
  sprintf(report,"PERFORMING ADDRTOGGLE TESTS ON BANK 6 WITH ADDR 0xFFFFFFFF");
  C(report);
  SSMCMemAddr = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11) + 0x7FF;
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , 0x00000021);

  /** Reading from Bank 6 through the SSMC **/
  HSA(SSMCMemAddr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSR( , 0x21000000, , 0xFF000000, ,SyAddrToggleTests_7);

  /** Reading from Bank 6 through the AHB **/
  AHBMemAddr = SSMCTrMEMARRAY6 + 0x1FFC;
  HSA(AHBMemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x21000000, , 0xFF000000, ,SyAddrToggleTests_8);
}

/************************************ End *************************************/
