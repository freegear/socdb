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
--  File Name              : RBLETests.c.rca
--  File Revision          : 1.9
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform tests on RBLE functionality of the SSMC.
--
-- --=========================================================================*/

/******************************************************************************/
/********************************* RBLE Tests *********************************/
/******************************************************************************/

void RBLETests()
{
  /*
     Summary: RBLE Tests
     ===================
     This function performs the following:

     o  Configures alternate banks with RBLE value '1'
     o  Tries various BURST accesses which cross banks
     o  The transfers are listed below:
        -------------------------------------------------------------------
        Current transfer with RBLE status   Next transfer with RBLE status
        -------------------------------------------------------------------
        RBLE enabled read transfer          RBLE disabled write transfer to
                                            different bank
        RBLE enabled write transfer         RBLE disabled read transfer to
                                            different bank
        RBLE enabled read transfer          RBLE disabled read transfer to
                                            different bank
        RBLE enabled write transfer         RBLE disabled write transfer to
                                            different bank
        RBLE disabled read transfer         RBLE enabled write transfer to
                                            different bank
        RBLE disabled read transfer         RBLE enabled read transfer to
                                            different bank
        RBLE disabled write transfer        RBLE enabled read transfer to
                                            different bank
        RBLE disabled write transfer        RBLE enabled write transfer to
                                            different bank
        RBLE enabled write transfer         RBLE enabled read transfer to
                                            same bank
        RBLE enabled read transfer          RBLE enabled write transfer to
                                            same bank
        RBLE disabled write transfer        RBLE disabled read transfer to
                                            same bank
        RBLE disabled read transfer         RBLE disabled write transfer to
                                            same bank
        -------------------------------------------------------------------
  */

  int i,k;
  int32 MemAddr, TestData, ReadData1, ReadData2, ReadData3, ReadData4;
  int32 ReadData, ReadMask, MemAddr1, TestData1, MemAddr2, WTCNCLData,
        ExtMuxData, SMBLSPOLData;
  char Message[100];


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

  /** Configuring the system to LITTLE endian mode by settng ENDIANNESS = 0 **/
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
  /** RBLE Enabled, ExtWait Disabled **/
  SSMCTrMEMBData[0] = 0x00007FFF;

  SMBCRData[0] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_EN      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[0] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK0, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD2);

  ConfigureMemory(BANK0, SSMCTrMEMBData[0]);

  /** Set Bank 1 Memory Type as SRAM (8 bits width) **/
  /** RBLE Disabled, ExtWait Disabled **/
  SSMCTrMEMBData[1] = 0x00000000;
  
  SMBCRData[1] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[1] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);

  /** Set Bank 2 Memory Type as SRAM (16 bits width) **/
  SSMCTrMEMBData[2] = 0x00007FFF;
  /** RBLE Enabled, ExtWait Enabled **/

  SMBCRData[2] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK2, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD2);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2]);

  /** Set Bank 3 Memory Type as SRAM (8 bits width) **/
  /** RBLE Disabled, ExtWait Enabled **/
  SSMCTrMEMBData[3] = 0x00000000;

  SMBCRData[3] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[3] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK3, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD2);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3]);

  /** Set Bank 4 Memory Type as SRAM (16 bits width) **/
  SSMCTrMEMBData[4] = 0x00007FFF;
  /** RBLE Enabled, ExtWait Enabled **/

  SMBCRData[4] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[4] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK4, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[4],
               SSMCTrCS2WTRData[4], WSTBRD2);

  ConfigureMemory(BANK4, SSMCTrMEMBData[4]);

  /** Set Bank 5 Memory Type as ROM (8 bits width) **/
  /** RBLE Disabled, ExtWait Enabled **/
  SSMCTrMEMBData[5] = 0x00000000;

  SMBCRData[5] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5]);

  /** Set Bank 6 Memory Type as BROM (32 bits width) **/
  SSMCTrMEMBData[6] = 0x00007FFF;
  /** RBLE Enabled, ExtWait Disabled **/

  SMBCRData[6] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        | 
                 CRWAITEN_EN      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[6] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK6, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[6],
               SSMCTrCS2WTRData[6], WSTBRD2);

  ConfigureMemory(BANK6, SSMCTrMEMBData[6]);

  /** Set Bank 7 Memory Type as BROM (8 bits width) **/
  /** RBLE Disabled, ExtWait Disabled **/
  SSMCTrMEMBData[7] = 0x00000000;

  SMBCRData[7] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        | 
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        | 
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[7] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK7, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[7],
               SSMCTrCS2WTRData[7], WSTBRD2);

  ConfigureMemory(BANK7, SSMCTrMEMBData[7]);

  /*
    Bank5, Bank6, Bank7 are configured as ROMS.
    The ROMs are then initialised from AHB side 
  */
  AHBWriteMem(5, 0, 64, 0x0000007F);
  AHBWriteMem(6, 0, 16, 0x98ABCDEF);
  AHBWriteMem(7, 0, 64, 0x000000AB);

  /* RBLE enabled Writes followed by RBLE disabled Writes to different Bank.
     Burst Writes  are performed on 32 bit Bank0 & 8 bit Bank1 
  */
  C("RBLE ENABLED WRITE FOLLOWED BY RBLE DISABLED WRITE TO DIFFERENT BANK");
  TestData = 0x10101010;
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11) + 0x7DC;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  for (i=0; i<7; i++)
    HSW( ,TestData++);

  TestData1 = 0x20202020;
  MemAddr1 = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData1++);
  for (k=0; k<7; k++)
     HSW( ,TestData1++);

  /* 
    RBLE Enabled Read followed by RBLE Disabled Read to different bank.
    The written data in the previous test is used in this test.
    Burst Reads are performed on 32 bit Bank0 & 8 bit Bank1.
  */
  C("RBLE ENABLED READ FOLLOWED BY RBLE DISABLED READ TO DIFFERENT BANK");
  TestData = 0x10101010;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_1);
  for (i=0; i<7; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_2);

  TestData1 = 0x20202020;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData1++, , NoMask, ,RBLETests_3);
  for (i=0; i<7; i++)
    HSR( , TestData1++, , NoMask, ,RBLETests_4);

  /*
    RBLE Enabled Read followed by RBLE Disabled Write to a different bank.
    Burst Read is performed on 32 bit Bank0 followed by Burst Writes on 
    the 8 bit Bank1.
  */
  C("RBLE ENABLED READ FOLLOWED BY RBLE DISABLED WRITE TO DIFFERENT BANK");
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11) + 0x7DC;
  TestData = 0x10101010;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_5);
  for (i=0; i<7; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_6);

  TestData1 = 0x20202020;  
  MemAddr1 = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData1++);
  for (i=0; i<7; i++)
    HSW( ,TestData1++);

  C("RBLE ENABLED WRITE FOLLOWED BY RBLE DISABLED READ TO DIFFERENT BANK");
  MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11) + 0x7DC;
  TestData = 0xA5A5A5A5;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  for (i=0; i<8; i++)
    HSW( ,TestData++);

  ReadData1 = 0x0000007F;
  ReadData2 = ReadData1+1;
  ReadData3 = ReadData2+1;
  ReadData4 = ReadData3+1;
  ReadData = ((ReadData4 << 24) & 0xFF000000) |
             ((ReadData3 << 16) & 0x00FF0000) |
             ((ReadData2 << 8) & 0x0000FF00) |
             (ReadData1 & 0x000000FF);

  MemAddr2 = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  HSA(MemAddr2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,RBLETests_7);
  for (i=0, ReadData1+=4, ReadData2+=4, ReadData3+=4, ReadData4+=4; i<8; i++,
       ReadData1+=4, ReadData2+=4, ReadData3+=4, ReadData4+=4)
  {
    ReadData = ((ReadData4 << 24) & 0xFF000000) |
               ((ReadData3 << 16) & 0x00FF0000) |
               ((ReadData2 << 8) & 0x0000FF00) |
               (ReadData1 & 0x000000FF);
    HSR( , ReadData, , NoMask, ,RBLETests_8);
  }

  C("RBLE ENABLED WRITE FOLLOWED BY RBLE ENABLED READ TO THE SAME BANK");
  /** Does the RBLE enabled write **/
  MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11) + 0x7BC;
  TestData = 0x12121212;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  for (i=0; i<7; i++)
    HSW( ,TestData++);

  MemAddr = MemAddr + 8*4;
  TestData = 0xA5A5A5A5;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_9);
  for (i=0; i<8; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_10);

  C("RBLE ENABLED READ FOLLOWED BY RBLE ENABLED WRITE TO THE SAME BANK");
  /** Verifying the written data **/
  MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11) + 0x7BC;
  TestData = 0x12121212;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_11);
  for (i=0; i<7; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_12);
  
  /** Does the RBLE enabled write to the same bank **/
  MemAddr = MemAddr + 8*4;
  TestData = 0x5A5A5A5A;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  for (i=0; i<8; i++)
    HSW( ,TestData++);
  
  /** Verifying the written data **/
  TestData = 0x5A5A5A5A;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_13);
  for (i=0; i<8; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_14);

  C("RBLE DISABLED READ FOLLOWED BY RBLE DISABLED WRITE TO SAME BANK");
  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  TestData1 = 0x20202020;
  /** Does the RBLE disabled read **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData1++, , NoMask, ,RBLETests_15);
  for (i=0; i<6; i++)
    HSR( , TestData1++, , NoMask, ,RBLETests_16);
  
  /** does the RBLE disabled write to the same bank **/
  MemAddr = MemAddr + 7*4;
  TestData = 0x44332211;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  for (i=0; i<8; i++)
    HSW( ,TestData++);
  
  /** Verifying the written data **/
  TestData = 0x44332211;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_17);
  for (i=0; i<8; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_18);

  C("RBLE DISABLED WRITE FOLLOWED BY RBLE DISABLED READ TO SAME BANK");
  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  TestData = 0x87654321;
  /** does the RBLE disabled write **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  for (i=0; i<6; i++)
    HSW( ,TestData++);
  
  /** Does the RBLE disabled read **/
  MemAddr = MemAddr + 7*4;
  TestData = 0x44332211;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_19);
  for (i=0; i<8; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_20);

  /** Verifying the written data **/
  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
  TestData = 0x87654321;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_21);
  for (i=0; i<6; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_22);
  
  /** Changing the base address of the bank 5 **/
  SSMCTrMEMBData[5] = 0x00007FFF;
  HSA(SSMCTrMEMBase5, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrMEMBData[5]);
  
  /** Initialise the ROM from the AHB side **/
  AHBWriteMem(5, 0x7DC, 8, 0x00000055);
  
  /** Changing the base address of the bank 6 **/
  SSMCTrMEMBData[6] = 0x00000000;
  HSA(SSMCTrMEMBase6, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrMEMBData[6]);

  C("RBLE DISABLED READ FOLLOWED BY RBLE ENABLED READ TO DIFFERENT BANk");
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 0x1F7;
  TestData = 0x00000055;
  /** Does RBLE disabled read **/
  ReadMask = (BUnMask0 << 3*8);
  ReadData = (TestData << 3*8) & ReadMask;
  HSA(MemAddr, NSEQ, INCR, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , ReadMask, ,RBLETests_23);
  for (i=4, TestData++; i<11; i++, TestData++)
  {
    ReadMask = (BUnMask0 << (i%4)*8);
    ReadData = (TestData << (i%4)*8) & ReadMask;
    HSR( , ReadData, , ReadMask, ,RBLETests_24);
  }

  MemAddr = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11);
  TestData = 0x98ABCDEF;
  ReadMask = BUnMask0;
  ReadData = TestData & ReadMask;
  /** Does RBLE enabled read from the different bank **/
  HSA(MemAddr, NSEQ, INCR, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , ReadMask, ,RBLETests_25);
  for (i=1; i<8; i++, TestData+= i/4)
  {
    ReadMask = (BUnMask0 << (i%4)*8);
    ReadData = TestData & ReadMask;
    HSR( , ReadData, , ReadMask, ,RBLETests_26);
  }
  
  /** Changing the base address of the bank 1 **/
  SSMCTrMEMBData[1] = 0x00007FFF;
  HSA(SSMCTrMEMBase1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrMEMBData[1]);
  
  /** Changing the base address of the bank 2 **/
  SSMCTrMEMBData[2] = 0x00000000;
  HSA(SSMCTrMEMBase2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,SSMCTrMEMBData[2]);

  C("RBLE DISABLED WRITE FOLLOWED BY RBLE ENABLED WRITE TO DIFFERENT BANk");
  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11) + 0x7E0;
  TestData = 0x11223344;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  for (i=0; i<7; i++)
    HSW( ,TestData++);
  
  MemAddr1 = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  for (i=0; i<7; i++)
    HSW( ,TestData++);
  
  /** Verifying the written data **/
  TestData = 0x11223344;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_27);
  for (i=0; i<7; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_28);

  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_29);
  for (i=0; i<7; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_30);

  C("RBLE DISABLED WRITE FOLLOWED BY RBLE ENABLED READ TO DIFFERENT BANk"); 
  TestData = 0x66778899;
  /** Does RBLE disabled write **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  for (i=0; i<7; i++)
    HSW( ,TestData++);

  TestData = 0x11223344 + 8;
  /** Does RBLE enabled read **/
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_31);
  for (i=0; i<7; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_32);

  C("RBLE DISABLED READ FOLLOWED BY RBLE ENABLED WRITE TO DIFFERENT BANk"); 

  MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11) + 0x7E0;
  TestData = 0x66778899;
  /** Does RBLE disabled read **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_33);
  for (i=0; i<7; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_34);

  MemAddr1+= 8*4;
  TestData = 0xABCDEF01;
  /** Does RBLE enabled write **/
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  for (i=0; i<7; i++)
    HSW( ,TestData++);

  /** Verifying the written data **/
  TestData = 0xABCDEF01;
  HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,RBLETests_35);
  for (i=0; i<7; i++)
    HSR( , TestData++, , NoMask, ,RBLETests_36);
    
}

/************************************ End *************************************/
