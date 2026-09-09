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
--  File Name              : RandomTests.c.rca
--  File Revision          : 1.9
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform random accesses to the SSMC.
--
-- --=========================================================================*/

/******************************************************************************/
/******************************** Random Tests ********************************/
/******************************************************************************/

void RandomTests()
{
  /*
     Summary: Random Tests
     =====================
     This function performs the following:

     o  Accesses different banks of the SSMC with various combinations of
        different sizes, bursts and transfer types
     o  Accesses are generated randomly using "random" function
  */

  int i, j, HSIZE1, HSIZE2, BURST1, BURST2, BankNo1, BankNo2, BeatsNo1,
      BeatsNo2;
  int32 TestData1, TestData2, MemAddr1, MemAddr2, TestWrite, TestRead,
        MaskRead, TempData, WTCNCLData, ExtMuxData, SMBLSPOLData;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  int32 Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int Shift[3] = {8, 16, 0};


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

  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** ExtWait disabled **/
  C("CONFIGURING THE SSMC AND THE MEMORY BLOCKS");
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

  ConfigureUUT(BANK0, WSTIDCY2, WSTRD6, WSTWR5, WSTOEN2, WSTWEN2, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD2);

  ConfigureMemory(BANK0, SSMCTrMEMBData[0]);

  /** Set Bank 1 Memory Type as SRAM (16 bits width) **/
  /** ExtWait disabled **/
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

  ConfigureUUT(BANK1, WSTIDCY2, WSTRD5, WSTWR4, WSTOEN1, WSTWEN0, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);

  /** Set Bank 2 Memory Type as SRAM (8 bits width) **/
  SSMCTrMEMBData[2] = 0x00000000;
  /** ExtWait enabled **/
  SMBCRData[2] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK2, WSTIDCY3, WSTRD5, WSTWR4, WSTOEN1, WSTWEN1, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD2);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2]);

  /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  /** ExtWait enabled **/
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

  ConfigureUUT(BANK3, WSTIDCY1, WSTRD7, WSTWR4, WSTOEN1, WSTWEN0, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD2);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3]);

  /** Set Bank 4 Memory Type as SRAM (16 bits width) **/
  SSMCTrMEMBData[4] = 0x00000000;
  /** ExtWait enabled **/

  SMBCRData[4] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[4] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK4, WSTIDCY4, WSTRD7, WSTWR7, WSTOEN2, WSTWEN1, SMBCRData[4],
               SSMCTrCS2WTRData[4], WSTBRD2);

  ConfigureMemory(BANK4, SSMCTrMEMBData[4]);

  /** Set Bank 5 Memory Type as SRAM (8 bits width) **/
  /** ExtWait enabled **/
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

  ConfigureUUT(BANK5, WSTIDCY3, WSTRD7, WSTWR5, WSTOEN3, WSTWEN2, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5]);

  /** Set Bank 6 Memory Type as SRAM (32 bits width) **/
  SSMCTrMEMBData[6] = 0x00000000;
  /** ExtWait disabled **/
  SMBCRData[6] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[6] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK6, WSTIDCY4, WSTRD6, WSTWR5, WSTOEN1, WSTWEN1, SMBCRData[6],
               SSMCTrCS2WTRData[6], WSTBRD2);

  ConfigureMemory(BANK6, SSMCTrMEMBData[6]);

  /** Set Bank 7 Memory Type as SRAM (16 bits width) **/
  /**  ExtWait disabled **/
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

  ConfigureUUT(BANK7, WSTIDCY2, WSTRD5, WSTWR5, WSTOEN1, WSTWEN1, SMBCRData[7],
               SSMCTrCS2WTRData[7], WSTBRD2);

  ConfigureMemory(BANK7, SSMCTrMEMBData[7]);

  for (i=0; i<10; i++)
  {
    sprintf(Message," TEST NO : %d ", i);
    C(Message);

    HSIZE1 = random()%3;
    HSIZE2 = random()%3;
    BURST1 = random()%8;
    BURST2 = random()%8;
    BankNo1 = random()%8;
    BankNo2 = random()%8;
    TestData1 = random();
    TestData2 = random();
  
    switch (BankNo1)
    {
      case 0 : MemAddr1 = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11) + 0x000; break;
      case 1 : MemAddr1 = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11) + 0x004; break;
      case 2 : MemAddr1 = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 0x008; break;
      case 3 : MemAddr1 = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11) + 0x00C; break;
      case 4 : MemAddr1 = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11) + 0x010; break;
      case 5 : MemAddr1 = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 0x014; break;
      case 6 : MemAddr1 = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11) + 0x018; break;
      case 7 : MemAddr1 = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11) + 0x01C; break;
      default : break;
    }
  
    switch (BankNo2)
    {
      case 0 : MemAddr2 = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11) + 0x70C; break;
      case 1 : MemAddr2 = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11) + 0x708; break;
      case 2 : MemAddr2 = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 0x704; break;
      case 3 : MemAddr2 = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11) + 0x700; break;
      case 4 : MemAddr2 = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11) + 0x6FC; break;
      case 5 : MemAddr2 = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 0x6F8; break;
      case 6 : MemAddr2 = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11) + 0x6F4; break;
      case 7 : MemAddr2 = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11) + 0x6F0; break;
      default : break;
    }
  
    switch (BURST1)
    {
      case 0 : BeatsNo1 = 2; break;
      case 1 : BeatsNo1 = 2; break;
      case 2 : BeatsNo1 = 4; break;
      case 3 : BeatsNo1 = 8; break;
      case 4 : BeatsNo1 = 16; break;
      case 5 : BeatsNo1 = 4; break;
      case 6 : BeatsNo1 = 8; break;
      case 7 : BeatsNo1 = 16; break;
      default : break;
    }
  
    switch (BURST2)
    {
      case 0 : BeatsNo2 = 2; break;
      case 1 : BeatsNo2 = 2; break;
      case 2 : BeatsNo2 = 4; break;
      case 3 : BeatsNo2 = 8; break;
      case 4 : BeatsNo2 = 16; break;
      case 5 : BeatsNo2 = 4; break;
      case 6 : BeatsNo2 = 8; break;
      case 7 : BeatsNo2 = 16; break;
      default : break;
    }
  
    TestWrite = TestData1;
    HSA(MemAddr1, NSEQ, beat[BURST1], , size[HSIZE1], , 0x1, , , , ,);
    HSW( ,TestWrite++);
    for (j=1; j<BeatsNo1; j++)
      HSW( ,TestWrite++)
  
    TestWrite = TestData2;
    HSA(MemAddr2, NSEQ, beat[BURST2], , size[HSIZE2], , 0x1, , , , ,);
    HSW( ,TestWrite++);
    for (j=1; j<BeatsNo2; j++)
      HSW( ,TestWrite++)
  
    TempData = TestData1;
    MaskRead = Mask[HSIZE1];
    TestRead = TempData & MaskRead;
    HSA(MemAddr1, NSEQ, beat[BURST1], , size[HSIZE1], , 0x1, , , , ,);
    HSR( , TestRead, , MaskRead, ,RandomTests_1);
    for (j=1, TempData++; j<BeatsNo1; j++, TempData++)
    {
      MaskRead = Mask[HSIZE1] << j*Shift[HSIZE1];
      TestRead = (TempData << j*Shift[HSIZE1]) & MaskRead;
      HSR( , TestRead, , MaskRead, ,RandomTests_2);
    }
  
    TempData = TestData2;
    MaskRead = Mask[HSIZE2];
    TestRead = TempData & MaskRead;
    HSA(MemAddr2, NSEQ, beat[BURST2], , size[HSIZE2], , 0x1, , , , ,);
    HSR( , TestRead, , MaskRead, ,RandomTests_3);
    for (j=1, TempData++; j<BeatsNo2; j++, TempData++)
    {
      MaskRead = Mask[HSIZE2] << j*Shift[HSIZE2];
      TestRead = (TempData << j*Shift[HSIZE2]) & MaskRead;
      HSR( , TestRead, , MaskRead, ,RandomTests_4);
    }
  }
}

/************************************ End *************************************/
