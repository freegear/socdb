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
--  File Name              : DenaliTests3.c.rca
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL093-r0p1-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Denali Memory Model based tests on the SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/******************** Denali Memory Model Based Tests *************************/
/******************************************************************************/

void DenaliTests3()
{
  /*
     Summary: Denali Memory Model Based Tests
     ========================================
     This function performs the following:

     o  Accesses the  bank 2 of the SSMC with various combinations of
        different sizes, bursts and transfer types.
     o  This test is to be run using the tbench_denali2.vhd.
  */

  int HSIZE, Burst, i;
  int32 TestData, Bank0Data, MemAddr, WriteData , WriteData1;
  int32 ReadData, ReadData1, ReadMask;
  int32 UnMask[3] = { 0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  char PrtString[75];
  char* BurstString[8] = {"SINGLE", "INCR", "INCR4", "INCR8",
                          "INCR16", "WRAP4", "WRAP8", "WRAP16"};
  char* SizeString[3] = {"BYTE", "HALFWORD", "WORD"};

  /*
      Programming SSMCCR and SSMCTrCR registers. The constants CLKRATIO and
      CLKSTATUS defined in the Ssmc.h set the required  MemClkRatioi and
      SMClockEn field bits.
  */
  SSMCCRDATA = CLKRATIO | CLKSTATUS;
  ConfigureCLKRatio(SSMCCRDATA);


  /** Set Bank 0 Memory Type as SRAM (8 bits width) **/
  SMBCRData[0] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_0      |
                 CRMW8            | RBLE_1           | SMBLSPOL_0 ;  

  SSMCTrCS2WTRData[0] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR1 | TRWT2DEWT1;

  ConfigureUUT(BANK0, WSTIDCY1, WSTRD3, WSTWR3, WSTOEN0, WSTWEN1, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD2);

  /** Set Bank 1 Memory Type as SRAM (16 bits width) **/
  SMBCRData[1] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 CRMW16           | RBLE_1           | SMBLSPOL_0 ;

  SSMCTrCS2WTRData[1] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY1, WSTRD3, WSTWR4, WSTOEN1, WSTWEN1, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);

  /** Set Bank 3 Memory Type as FLASH2 (16 bits width) **/
  SMBCRData[3] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 CRMW16           | RBLE_1           | SMBLSPOL_0 ;

  SSMCTrCS2WTRData[3] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK3, WSTIDCY4, WSTRD12, WSTWR12, WSTOEN8, WSTWEN1,
               SMBCRData[3], SSMCTrCS2WTRData[3], WSTBRD12);

  /** Set Bank 4 Memory Type as Mask ROM (32 bits width) **/
  SMBCRData[4] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 CRMW32           | RBLE_1           | SMBLSPOL_0 ;

  SSMCTrCS2WTRData[4] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK4, WSTIDCY1, WSTRD14, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[4],
               SSMCTrCS2WTRData[4], WSTBRD4);

  /** Set Bank 5 Memory Type as Mask ROM (32 bits width) **/
  SMBCRData[5] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 CRMW32           | RBLE_0           | SMBLSPOL_0 ;

  SSMCTrCS2WTRData[5] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY1, WSTRD21, WSTWR3, WSTOEN0, WSTWEN1, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD10);

  /** Set Bank 6 Memory Type as SRAM (16 bits width) **/
  SMBCRData[6] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 CRMW16           | RBLE_1           | SMBLSPOL_0 ;

  SSMCTrCS2WTRData[6] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK6, WSTIDCY1, WSTRD4, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[6],
               SSMCTrCS2WTRData[6], WSTBRD4);

  /** Set Bank 7 Memory Type as SRAM (8 bits width) **/
  SMBCRData[7] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 CRMW8            | RBLE_1           | SMBLSPOL_0 ;

  SSMCTrCS2WTRData[7] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK7, WSTIDCY1, WSTRD3, WSTWR4, WSTOEN0, WSTWEN1, SMBCRData[7],
               SSMCTrCS2WTRData[7], WSTBRD2);


  /** Do the tests in the LITTLE Endian mode **/
  ENDIANNESS = 0;
  C("CONFIGURING THE SYSTEM TO LITTLE ENDIAN MODE");
  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ENDIANNESS);
  HSEN(LITTLE);

  C("*********STARTING ASYNCHRONOUS READS ON BANK 2 MEMORY DEVICE **********");

  /** Set Bank 2 Memory Type as FLASH (16 bits width) **/ 
  SMBCRData[2] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 CRMW16           | RBLE_1           | SMBLSPOL_0 ;

  SSMCTrCS2WTRData[2] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR1 | TRWT2DEWT1;

  ConfigureUUT(BANK2, WSTIDCY1, WSTRD4, WSTWR6, WSTOEN0, WSTWEN2, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD0);
  C("PROGRAMMING THE CONFIGURATION REGISTER");
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 0x12F9E;
  HSA(MemAddr, NSEQ, INCR, , HWRD, , 0x1, , , , ,);
  HSW( , 0x60);
  WaitLoop(5);

  HSA(MemAddr, NSEQ, INCR, , HWRD, , 0x1, , , , ,);
  HSW( , 0x03);
  HSA(MemAddr, NSEQ, SINGLE, OK, HWRD, , 0x1, , , , ,);
  HSW( , 0xFF);

  /** Performing HALFWORD reads to 16 bit Bank 2 in SINGLE burst mode **/
  C("READ ACCESSES TO SYNCHRONOUS BANK 2: HSIZE = HALFWORD, HBURST = SINGLE");
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 0x100000;
  ReadData = 0x00005555;

  HSA(MemAddr, NSEQ, SINGLE, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,DenaliTests_1);

  MemAddr = MemAddr + 2;
  ReadData = 0x55560000;
  HSA(MemAddr, NSEQ, SINGLE, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,DenaliTests_2);


  /** Performing HALFWORD reads to 16 bit Bank 2 in INCR burst mode **/
  C("READ ACCESSES TO SYNCHRONOUS BANK 2: HSIZE = HALFWORD, HBURST = INCR");
  MemAddr = MemAddr + 2;
  ReadData = 0x00005557;
  HSA(MemAddr, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,DenaliTests_3);

  MemAddr = MemAddr + 2;
  ReadData = 0x55580000;
  HSA(MemAddr, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,DenaliTests_4);
         

  C("READ ACCESSES TO SYNCHRONOUS BANK 2: HSIZE = WORD, HBURST = INCR4");
  /* MemRead(2,2, 0x100000,2,1,0x55565555); */
  MemAddr = SSMCMEM_2 + 0x100000;
  ReadData = 0x55565555;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55585557;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555A5559;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555C555B;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);


  C("READ ACCESSES TO SYNCHRONOUS BANK 2: HSIZE = WORD, HBURST = INCR8");
  /* MemRead(2,3, 0x100000,2,1,0x55565555); */
  MemAddr = SSMCMEM_2 + 0x100000;
  ReadData = 0x55565555;
  HSA(MemAddr, NSEQ, INCR8, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55585557;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555A5559;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555C555B;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555E555D;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x5560555F;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55625561;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55645563;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);


  C("READ ACCESSES TO SYNCHRONOUS BANK 2: HSIZE = WORD, HBURST = INCR16");
  /* MemRead(2,4, 0x100000,2,1,0x55565555); */
  MemAddr = SSMCMEM_2 + 0x100000;
  ReadData = 0x55565555;
  HSA(MemAddr, NSEQ, INCR16, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55585557;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555A5559;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555C555B;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555E555D;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x5560555F;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55625561;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55645563;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55665565;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55685567;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x556A5569;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x556C556B;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x556E556D;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x5570556F;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55725571;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55745573;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);

  C("TESTING THE FIX DONE TO INCREASE READ PERFORMACE WHEN BUSY INSERTED");
  MemAddr = SSMCMEM_2 + 0x100000;
  ReadData = 0x55565555;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,Testing_Performance1);

  HSA(MemAddr+=4, BUSY, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++ & MaskAll, , NoMask, ,Testing_Performance2);

  HSA(MemAddr, BUSY, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData & MaskAll, , NoMask, ,Testing_Performance3);

  ReadData = 0x55585557;
  HSA(MemAddr, SEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,Testing_Performance4);

  ReadData = 0x555A5559;
  HSR( , ReadData, , NoMask, ,Testing_Performance5);

  ReadData = 0x555C555B;
  HSR( , ReadData, , NoMask, ,Testing_Performance5);

         
  C("TESTING THE FIX DONE TO INCREASE READ PERFORMACE WHEN IDLE INSERTED");
  MemAddr = SSMCMEM_2 + 0x100000;
  ReadData = 0x55565555;
  HSA(MemAddr, NSEQ, INCR16, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,Testing_Performance6);

  HSA(MemAddr+=8, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData++ & MaskAll, , NoMask, ,Testing_Performance);

  MemAddr = SSMCMEM_2 + 0x100004;
  ReadData = 0x55585557;
  HSA(MemAddr, NSEQ, INCR8, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,Testing_Performance7);
  ReadData = 0x555A5559;
  HSR( , ReadData, , NoMask, ,Testing_Performance8);
  ReadData = 0x555C555B;
  HSR( , ReadData, , NoMask, ,Testing_Performance9);
  ReadData = 0x555E555D;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x5560555F;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55625561;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55645563;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55665565;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);

  MemAddr = SSMCMEM_2 + 0x100024;
  ReadData = 0x55685567;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,Testing_Performance7);
  ReadData = 0x556A5569;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x556C556B;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x556E556D;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);

  MemAddr = SSMCMEM_2 + 0x100034;
  ReadData = 0x5570556F;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55725571;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55745573;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);


  C("*********STARTING SYNCHRONOUS READS ON BANK 2 MEMORY DEVICE **********");

  /** Set Bank 2 Memory Type as FLASH (16 bits width) **/
  SMBCRData[2] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_ASY   | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR1 | TRWT2DEWT1;

  ConfigureUUT(BANK2, WSTIDCY1, WSTRD2, WSTWR6, WSTOEN0, WSTWEN2, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD1);


  C("PROGRAMMING THE CONFIGURATION REGISTER");
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 0x0239E;
  HSA(MemAddr, NSEQ, INCR, , HWRD, , 0x1, , , , ,);
  HSW( , 0x60);

  WaitLoop(5);

  HSA(MemAddr, NSEQ, INCR, , HWRD, , 0x1, , , , ,);
  HSW( , 0x03);

  /** Performing HALFWORD reads to 16 bit Bank 2 in SINGLE burst mode **/
  C("READ ACCESSES TO SYNCHRONOUS BANK 2: HSIZE = HALFWORD, HBURST = SINGLE");
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + 0x100000;
  ReadData = 0x00005555;
  HSA(MemAddr, NSEQ, SINGLE, OK, HWRD, , 0x1, , , , ,);
  HSW( , 0xFF);

  HSA(MemAddr, NSEQ, SINGLE, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,DenaliTests_5);

  MemAddr = MemAddr + 2;
  ReadData = 0x55560000;
  HSA(MemAddr, NSEQ, SINGLE, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,DenaliTests_6);


  /** Performing HALFWORD reads to 16 bit Bank 2 in INCR burst mode **/
  C("READ ACCESSES TO SYNCHRONOUS BANK 2: HSIZE = HALFWORD, HBURST = INCR");
  MemAddr = MemAddr + 2;
  ReadData = 0x00005557;
  HSA(MemAddr, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,DenaliTests_7);

  MemAddr = MemAddr + 2;
  ReadData = 0x55580000;
  HSA(MemAddr, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskB, ,DenaliTests_8);
         

  C("READ ACCESSES TO SYNCHRONOUS BANK 2: HSIZE = WORD, HBURST = INCR4");
  /* MemRead(2,2, 0x100000,2,1,0x55565555); */

  MemAddr = SSMCMEM_2 + 0x100000;
  ReadData = 0x55565555;
  HSA(MemAddr, NSEQ, INCR4, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55585557;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555A5559;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555C555B;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);

  C("READ ACCESSES TO SYNCHRONOUS BANK 2: HSIZE = WORD, HBURST = INCR8");
  /* MemRead(2,3, 0x100000,2,1,0x55565555); */
  MemAddr = SSMCMEM_2 + 0x100000;
  ReadData = 0x55565555;
  HSA(MemAddr, NSEQ, INCR8, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55585557;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555A5559;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555C555B;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555E555D;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x5560555F;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55625561;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55645563;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);


  C("READ ACCESSES TO SYNCHRONOUS BANK 2: HSIZE = WORD, HBURST = INCR16");
  /* MemRead(2,4, 0x100000,2,1,0x55565555); */
  MemAddr = SSMCMEM_2 + 0x100000;
  ReadData = 0x55565555;
  HSA(MemAddr, NSEQ, INCR16, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55585557;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555A5559;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555C555B;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x555E555D;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x5560555F;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55625561;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55645563;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55665565;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55685567;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x556A5569;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x556C556B;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x556E556D;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x5570556F;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55725571;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);
  ReadData = 0x55745573;
  HSR( , ReadData, , NoMask, ,Testing_Performance1);



    
}


/************************************ END *************************************/
