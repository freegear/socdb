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
--  File Name              : SsmcTranSeqTests.c.rca
--  File Revision          : 1.8
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform transfers such that they cross banks
--
-- --=========================================================================*/

/******************************************************************************/
/**************************** Transfer Sequence Tests *************************/
/******************************************************************************/

void SsmcTranSeqTests()
{
  /*
     Summary: Transfer Sequence Tests
     ================================
     This function performs the following:
     o  Alternate banks are programmed as Synchronous and Asynchronous.
     o  Does various types of accesses of various lengths to the Memory such 
        that they cross banks.
     o  BURSTs are started
        - At different word boundaries and quadword boundaries with INCR4,
          INCR8, INCR16, WRAP4, WRAP8 and WRAP16
        - With HSIZE as BYTE, HWRD and WRD
     o  Repeats the tests with various values of WST1, WST2, CS2OEN, CS2WEN
        and IDCY.
  */

  int HSIZE, BURST, i;
  int32 MemAddr, TestData, WTCNCLData, ReadData, ReadData1, ExtMuxData,
        SMBLSPOLData;
  int32 AddrMask[3] = {0x3, 0x2, 0x0};
  char PrtString[75];
  char* BurstString[8] = {"SINGLE", "INCR", "INCR4", "INCR8",
                          "INCR16", "WRAP4", "WRAP8", "WRAP16"};
  char* SizeString[3] = {"BYTE", "HALFWORD", "WORD"};


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

  /** Configuring the system to LITTLE endian mode by setting ENDIANESS = 0 **/
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

  SMBCRData[0] = CRADDRVALIDWR_DI | CRADDRVALIDRD_EN | 
                 CRSYNCENWR_ASY   | CRSYNCENRD_SY    |
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


  /** Set Bank 1 Memory Type as Asynchronous SRAM (16 bits width) **/
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
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK2, WSTIDCY1, WSTRD0, WSTWR0, WSTOEN0, WSTWEN0, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD2);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2]);

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

  /** Set Bank 5 Memory Type as Asynchronous SRAM (8 bits width) **/
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

  ConfigureUUT(BANK5, WSTIDCY1, WSTRD0, WSTWR0, WSTOEN0, WSTWEN0, SMBCRData[5],
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

  /** Set Bank 7 Memory Type as Asynchronous SRAM (16 bits width) **/
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

  ConfigureUUT(BANK7, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[7],
               SSMCTrCS2WTRData[7], WSTBRD2);

  ConfigureMemory(BANK7, SSMCTrMEMBData[7]);

  C("PERFORMNG ASYNCHRONOUS WRITES FOLLOWED BY SYNCHRONOUS READS");
  /** Filling the  Synchronous Bank 0 with Data **/
  AHBWriteMem(0, 0, 4, 0x1FFFFFFF);
   
  /** Writing into the Asynchronous Bank 3 with Data **/
  TestData = 0x4FFFFFFF; 
  MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR4, , WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);

  /** Reading from Bank 0 **/
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11);
  ReadData = 0x1FFFFFFF;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,SsmcTranSeqTests_1);
  for (i=0, ReadData++; i<3; i++, ReadData++)
    HSR( , ReadData, , NoMask, ,SsmcTranSeqTests_1);

  /** Confirming the data written in the Bank 3  **/
  MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  ReadData = 0x4FFFFFFF;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,SsmcTranSeqTests_2);
  for (i=0, ReadData++; i<3; i++, ReadData++)
    HSR( , ReadData, , NoMask, ,SsmcTranSeqTests_2);
 

  C("SYNCHRONOUS BURST WRITES FOLLOWED BY ASYNCHRONOUS WRITES");
  C("SMWAIT ENABLED AND WSTWR = 0");
  /** Performing Synchronous Burst writes to the Bank 2 **/
  TestData = 0x3FFFFFFF; 
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);

  /** Performing Asynchronous writes to the bank 5 with ext Wait Enabled **/
  TestData = 0x6FFFFFFF; 
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);

  /**  Confirming the data written in the Bank 2 & Bank 5 **/
  TestData = 0x3FFFFFFF;
  ReadData = TestData;
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_3);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_3);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_3);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_3);

  TestData = 0x6FFFFFFF;
  ReadData = TestData;
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_4);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_4);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_4);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_4);

  C("ASYNCHRONOUS WRITES WITH SMWAIT ENABLED FOLLOWED BY SYNCHRONOUS READS");
  C("WSTRD = 0");
  /** Performing Asynchronous writes to the  bank 5 with ext Wait Enabled **/
  TestData = 0x6FFFFFFF + 4; 
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 16;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);

  /** Performing Synchronous Reads to bank 2 on previously written data **/
  TestData = 0x3FFFFFFF;
  ReadData = TestData;
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_5);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_5);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_5);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_5);

  /** Confirming the data written in the  Bank 5 **/ 
  TestData = 0x6FFFFFFF + 4 ;
  ReadData = TestData;
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 16;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_6);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_6);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_6);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_6);

  C("ASYNCHRONOUS WRITES WITH SMWAIT ENABLED FOLLOWED BY SYNCHRONOUS WRITES");
  C("WSTWR = 0 ");
  /** Performing Asynchronous writes to the bank 5 with ext Wait Enabled **/
  TestData = 0x6FFFFFFF + 8; 
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 32;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);

  /** Performing Burst writes to the Synchronous Bank 2 **/
  TestData = 0x3FFFFFFF + 4; 
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 16;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);

  /** Confirming the data written in the Bank 2 & Bank 5 **/
  TestData = 0x3FFFFFFF + 4;
  ReadData = TestData;
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 16;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_7);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_7);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_7);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_7);

  TestData = 0x6FFFFFFF + 8; 
  ReadData = TestData;
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 32;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_8);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_8);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_8);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_8);


 C("ASYNCHRONOUS READS FOLLOWED BY SYNCHRONOUS READS WITH WSTRD = 0");
  /** Performing reads to the Asynchronous Bank 5 **/
  TestData = 0x6FFFFFFF + 8; 
  ReadData = TestData;
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 32;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_9);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_9);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_9);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_9);

  /** Performing Burst reads to Synchronous Banks 2 **/
  TestData = 0x3FFFFFFF + 4;
  ReadData = TestData;
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 16;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_10);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_10);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_10);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_10);

 C("ASYNCHRONOUS READS FOLLOWED BY SYNCHRONOUS WRITES WITH WSTWR = 0");
  /** Perfroming Asynchronous reads to Asynchonous Bank 5 **/
  TestData = 0x6FFFFFFF + 8; 
  ReadData = TestData;
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 32;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_11);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_11);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_11);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_11);

  /** Performing Burst writes to the Synchronous Bank 2 **/
  TestData = 0x3FFFFFFF + 8; 
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 32;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);

  /** Confirming the Data written in Banks 2  **/
  TestData = 0x3FFFFFFF + 8;
  ReadData = TestData;
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 32;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_12);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_12);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_12);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_12);

  C("ASYNCHRONOUS WRITES FOLLOWED BY SYNCHRONOUS READS WITH WSTRD = 0");
  /** Performing writes to the Asynchronous bank 5 with ext Wait Enabled **/
  TestData = 0x6FFFFFFF + 16; 
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 48;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);

  /** Performing Burst reads to Synchronous Banks 2  **/
  TestData = 0x3FFFFFFF + 8;
  ReadData = TestData;
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 32;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_13);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_13);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_13);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_13);

 /** Confirming the data Written in Bank 5 **/
  TestData = 0x6FFFFFFF + 16;
  ReadData = TestData;
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 48;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_14);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_14);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_14);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_14);

 C("SYNCHRONOUS WRITES FOLLOWED BY ASYNCHRONOUS WRITES WITH SMWAIT ENABLED");
 /** Performing Synchronous Writes **/
  TestData = 0x3FFFFFFF + 16; 
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 48;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);

  /** Performing writes to the Asynchronous bank 5 with ext Wait Enabled **/
  TestData = 0x6FFFFFFF + 20; 
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 64;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);

 /** Confirming the data written in the Bank 2 & Bank 5 **/
  TestData = 0x3FFFFFFF + 16;
  ReadData = TestData;
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 48;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_15);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_15);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_15);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_15);

  TestData = 0x6FFFFFFF + 20;
  ReadData = TestData;
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 64;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_16);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_16);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_16);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_16);


  C("SYNCHRONOUS WRITES FOLLOWED BY ASYNCHRONOUS READS");
  /** Performing Synchronous Writes **/
  TestData = 0x3FFFFFFF + 20; 
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 64;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);

  /** Perfroming Asynchronous reads to Asynchonous Bank 5 **/
  TestData = 0x6FFFFFFF + 20; 
  ReadData = TestData;
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 64;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_17);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_17);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_17);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_17);

 /** Confirming the data written in the Bank 2  **/
  TestData = 0x3FFFFFFF + 20;
  ReadData = TestData;
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 64;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_18);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_18);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_18);
  HSR( , ReadData++, , NoMask, ,SsmcTranSeqTests_18);

  C("SYNCHRONOUS READS FOLLOWED BY ASYNCHRONOUS WRITES WITHIN SAME BANK");
  /** Synchronous Reads from Bank 0 **/
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11);
  ReadData = 0x1FFFFFFF;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,SsmcTranSeqTests_19);
  for (i=0, ReadData++; i<3; i++, ReadData++)
    HSR( , ReadData, , NoMask, ,SsmcTranSeqTests_19);

  /** Asynchronous Writes to Bank O **/
  TestData = 0x1FFFFFFF + 4;
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11) + 16;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);

  /** Confirming the data Written in the Bank 0 **/
  ReadData = 0x1FFFFFFF + 4;
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11) + 16;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,SsmcTranSeqTests_20);
  for (i=0, ReadData++; i<3; i++, ReadData++)
    HSR( , ReadData, , NoMask, ,SsmcTranSeqTests_20);
}

/************************************ End *************************************/
