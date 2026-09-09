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
--  File Name              : DenaliTests.c.rca
--  File Revision          : 1.8
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Denali Memory Model based tests on the SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/******************** Denali Memory Model Based Tests *************************/
/******************************************************************************/

void DenaliTests()
{
  /*
     Summary: Denali Memory Model Based Tests
     ========================================
     This function performs the following:

     o  Accesses different banks of the SSMC with various combinations of
        different sizes, bursts and transfer types
     o  The Clock Stop functionality is also checked here by disabling the
        CLKEN bit so the clock is inactive during non access period to a bank. 
     o  Does various transfer accesses of various lengths to the Memory while
        the clock is active during memory accesses to safe power
        
  */

  int HSIZE, Burst;
  int32 TestData, WriteData, Bank0Data, WTCNCLData, ExtMuxData;
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  char PrtString[75];
  char* BurstString[8] = {"SINGLE", "INCR", "INCR4", "INCR8",
                          "INCR16", "WRAP4", "WRAP8", "WRAP16"};
  char* SizeString[3] = {"BYTE", "HALFWORD", "WORD"};

  int32 AddrMask[3] = {0x3, 0x2, 0x0};
  int32 SSMCCRData;
  char Report[75];

  /*
      Programming SSMCCR and SSMCTrCR registers. The constants CLKRATIO and
      CLKSTATUS defined in the Ssmc.h set the required  MemClkRatio and
      SMClockEn field bits.
  */

  /** Programming SSMCCR and SMMemCLKRatio  registers **/
  SSMCCRDATA = CLKRATIO | CLKSTATUS;
  ConfigureCLKRatio(SSMCCRDATA);

  /** Set Bank 0 Memory Type as SRAM (8 bits width) **/
  /** CSPol = 0, ExtWait Enabled **/
  C("CONFIGURING THE SSMC");

  SMBCRData[0] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_0      |
                 CRMW8            | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[0] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR1 | TRWT2DEWT1;

  ConfigureUUT(BANK0, WSTIDCY1, WSTRD3, WSTWR3, WSTOEN0, WSTWEN1, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD2);

  /** Set Bank 1 Memory Type as SRAM (16 bits width) **/
  /** CSPol = 0, ExtWait disabled **/

  SMBCRData[1] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[1] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY1, WSTRD3, WSTWR4, WSTOEN1, WSTWEN1, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);


  /** Set Bank 2 Memory Type as FLASH1 (16 bits width) **/
  /** CSPol = 1, ExtWait disabled **/

  SMBCRData[2] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 CRMW16           | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK2, WSTIDCY4, WSTRD15, WSTWR8, WSTOEN9, WSTWEN1, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD15);

  /** Set Bank 3 Memory Type as FLASH2 (16 bits width) **/
  /** CSPol = 1, ExtWait disabled **/

  SMBCRData[3] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[3] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK3, WSTIDCY4, WSTRD12, WSTWR12, WSTOEN8, WSTWEN1, 
               SMBCRData[3], SSMCTrCS2WTRData[3], WSTBRD12);


  /** Set Bank 4 Memory Type as Mask ROM (32 bits width) **/
  /** CSPol = 1, ExtWait disabled **/

  SMBCRData[4] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_DI     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[4] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK4, WSTIDCY1, WSTRD14, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[4],
               SSMCTrCS2WTRData[4],WSTBRD4);

  /** Set Bank 5 Memory Type as Mask ROM (32 bits width) **/
  /** CSPol = 0, ExtWait disabled **/

  SMBCRData[5] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 CRMW32           | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY1, WSTRD21, WSTWR3, WSTOEN0, WSTWEN1, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD10);

  /** Set Bank 6 Memory Type as SRAM (16 bits width) **/
  /** CSPol = 0, ExtWait disabled **/

  SMBCRData[6] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[6] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK6, WSTIDCY1, WSTRD4, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[6],
               SSMCTrCS2WTRData[6], WSTBRD4);

  /** Set Bank 7 Memory Type as SRAM (8 bits width) **/
  /** CSPol = 0, ExtWait disabled **/

  SMBCRData[7] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      | 
                 CRMW8            | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[7] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK7, WSTIDCY1, WSTRD3, WSTWR4, WSTOEN0, WSTWEN1, SMBCRData[7],
               SSMCTrCS2WTRData[7], WSTBRD2);

  /** Do the tests in the LITTLE Endian mode **/
  ENDIANNESS = 0;
  C("CONFIGURING THE SYSTEM TO LITTLE ENDIAN MODE");
  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,ENDIANNESS);
  HSEN(LITTLE);

  for (HSIZE = 0, TestData = 0xA0000000; HSIZE < 3; HSIZE++)
    for (Burst = 7; Burst >= 5; Burst--)
    {
      sprintf(PrtString, "BURST WR/RDs: HSIZE = %s, BURST = %s", 
              SizeString[HSIZE], BurstString[Burst]);
      C(PrtString);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(0, Burst, 0x00, HSIZE, 0, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(1, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(2, Burst, 0x00, HSIZE, 1, WriteData, 0x5555); 
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(3, Burst, 0x00, HSIZE, 1, WriteData, 0xAAAA);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(4, Burst, 0x00, HSIZE, 2, WriteData, 0x66666666);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(5, Burst, 0x00, HSIZE, 2, WriteData, 0x6FFFFFE0);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(6, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(7, Burst, 0x00, HSIZE, 0, WriteData);
    }

  for (HSIZE = 0, TestData = 0xA0000000; HSIZE < 3; HSIZE++)
   {
    for (Burst = 3; Burst >= 0; Burst--)
    {
      sprintf(PrtString, "BURST WR/RDs: HSIZE = %s, BURST = %s", 
              SizeString[HSIZE], BurstString[Burst]);
      C(PrtString);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(0, Burst, 0x00, HSIZE, 0, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(1, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(2, Burst, 0x00, HSIZE, 1, WriteData, 0x5555);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(3, Burst, 0x00, HSIZE, 1, WriteData, 0xAAAA); 
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(4, Burst, 0x00, HSIZE, 2, WriteData, 0x66666666);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(5, Burst, 0x00, HSIZE, 2, WriteData, 0x6FFFFFE0);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(6, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(7, Burst, 0x00, HSIZE, 0, WriteData);
    }
   }
  
  Burst = 4;
  for (HSIZE = 0, TestData = 0xA0000000; HSIZE < 3; HSIZE++)
    {
      sprintf(PrtString, "BURST WR/RDs: HSIZE = %s, BURST = %s", 
              SizeString[HSIZE], BurstString[Burst]);
      C(PrtString);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(0, Burst, 0x00, HSIZE, 0, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(1, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(2, Burst, 0x00, HSIZE, 1, WriteData, 0x5555); 
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(3, Burst, 0x00, HSIZE, 1, WriteData, 0xAAAA);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(4, Burst, 0x00, HSIZE, 2, WriteData, 0x66666666);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(5, Burst, 0x00, HSIZE, 2, WriteData, 0x6FFFFFE0);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(6, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(7, Burst, 0x00, HSIZE, 0, WriteData);
    }

  /** Do the tests in the BIG Endian mode **/
  ENDIANNESS = 1;
  C("CONFIGURING THE SYSTEM TO BIG ENDIAN MODE");
  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ENDIANNESS);
  HSEN(DISABLE);

  for (HSIZE = 0, TestData = 0x10000000; HSIZE < 3; HSIZE++)
   {
    for (Burst = 0; Burst < 4; Burst++)
    {
      sprintf(PrtString, "BURST WR/RDs: HSIZE = %s, BURST = %s", 
              SizeString[HSIZE], BurstString[Burst]);
      C(PrtString);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(0, Burst, 0x00, HSIZE, 0, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(1, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(2, Burst, 0x00, HSIZE, 1, WriteData, 0x5555);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(3, Burst, 0x00, HSIZE, 1, WriteData, 0xAAAA);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(4, Burst, 0x00, HSIZE, 2, WriteData, 0x66666666);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(5, Burst, 0x00, HSIZE, 2, WriteData, 0x6FFFFFE0);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(6, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(7, Burst, 0x00, HSIZE, 0, WriteData);
    }
   }

  for (HSIZE = 0, TestData = 0x10000000; HSIZE < 3; HSIZE++)
   {
    for (Burst = 5; Burst < 8; Burst++)
    {
      sprintf(PrtString, "BURST WR/RDs: HSIZE = %s, BURST = %s", 
              SizeString[HSIZE], BurstString[Burst]);
      C(PrtString);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(0, Burst, 0x00, HSIZE, 0, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(1, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(2, Burst, 0x00, HSIZE, 1, WriteData, 0x5555);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(3, Burst, 0x00, HSIZE, 1, WriteData, 0xAAAA); 
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(4, Burst, 0x00, HSIZE, 2, WriteData, 0x66666666);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(5, Burst, 0x00, HSIZE, 2, WriteData, 0x6FFFFFE0);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(6, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(7, Burst, 0x00, HSIZE, 0, WriteData);
    }
   }

  Burst = 4;
  for (HSIZE = 0, TestData = 0xA0000000; HSIZE < 3; HSIZE++)
    {
      sprintf(PrtString, "BURST WR/RDs: HSIZE = %s, BURST = %s", 
              SizeString[HSIZE], BurstString[Burst]);
      C(PrtString);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(0, Burst, 0x00, HSIZE, 0, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(1, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(2, Burst, 0x00, HSIZE, 1, WriteData, 0x5555);  
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(3, Burst, 0x00, HSIZE, 1, WriteData, 0xAAAA); 
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(4, Burst, 0x00, HSIZE, 2, WriteData, 0x66666666);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(5, Burst, 0x00, HSIZE, 2, WriteData, 0x6FFFFFE0);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(6, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(7, Burst, 0x00, HSIZE, 0, WriteData);
    }

  /** Changing back the ENDIANNESS to LITTLE (default) **/
  ENDIANNESS = 0;
  HSEN(LITTLE);
  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,ENDIANNESS);


  /*
     The following test checks the clock stop functionality :

     o  Does various transfer accesses of various lengths to the Memory while
        the clock is active during memory accesses to safe power
  */


      /** Writing in to SSMCCR register to disable the Clock **/
      C("PERFORMING BURST WRITE/READ WITH THE SMCLOCK DISABLED");
      SSMCCRData = CLKRATIO | CLKDI;
      HSA(SSMCCR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( ,SSMCCRData);

      TestData = 0x00123456; 

      sprintf(Report,"BURST WR/RDs ON BANK 0: ");
      C(Report);
      sprintf(Report,"HSIZE = WORD, MSIZE = BYTE, BURST = SIN");
      C(Report);
      HSIZE = 2; 
      Burst = 0;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(0, Burst, 0x00, HSIZE, 0, WriteData);
      TestData += 0x1111;

      WaitLoop(5);

      sprintf(Report,"BURST WR/RDs ON BANK 1: ");
      C(Report);
      sprintf(Report,"HSIZE = HALFWORD, MSIZE = HALFWORD, BURST = INC");
      C(Report);
      HSIZE = 1;
      Burst = 1;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(1, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;

      WaitLoop(5);

      sprintf(Report,"BURST WR/RDs ON BANK 2: ");
      C(Report);
      sprintf(Report,"HSIZE = BYTE, MSIZE = HALFWORD, BURST = INC4");
      C(Report);
      HSIZE = 0;
      Burst = 2;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(2, Burst, 0x00, HSIZE, 1, WriteData, 0x5555);  
      TestData += 0x1111;

      WaitLoop(5);

      sprintf(Report,"BURST WR/RDs ON BANK 3: ");
      C(Report);
      sprintf(Report,"HSIZE = WORD, MSIZE = HALFWORD, BURST = INC8");
      C(Report);
      HSIZE = 2;
      Burst = 3;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(3, Burst, 0x00, HSIZE, 1, WriteData, 0xAAAA); 
      TestData += 0x1111;

      WaitLoop(5);
 
      sprintf(Report,"BURST WR/RDs ON BANK 4: ");
      C(Report);
      sprintf(Report,"HSIZE = HALFWORD, MSIZE = WORD, BURST = INC16");
      C(Report);
      HSIZE = 1;
      Burst = 4;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(4, Burst, 0x00, HSIZE, 2, WriteData, 0x66666666);
      TestData += 0x1111;

      WaitLoop(5);

      sprintf(Report,"BURST WR/RDs ON BANK 5: ");
      C(Report);
      sprintf(Report,"HSIZE = BYTE, MSIZE = WORD, BURST = WRP4");
      C(Report);
      HSIZE = 0;
      Burst = 5;
      WriteData = TestData & UnMask[HSIZE];
      ROMWriteRead(5, Burst, 0x00, HSIZE, 2, WriteData, 0x6FFFFFE0);
      TestData += 0x1111;

      WaitLoop(5);

      sprintf(Report,"BURST WR/RDs ON BANK 6: ");
      C(Report);
      sprintf(Report,"HSIZE = HALFWORD, MSIZE = HALFWORD, BURST = WRP8");
      C(Report);
      HSIZE = 1;
      Burst = 6;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(6, Burst, 0x00, HSIZE, 1, WriteData);
      TestData += 0x1111;

      WaitLoop(5);

      sprintf(Report,"BURST WR/RDs ON BANK 7: ");
      C(Report);
      sprintf(Report,"HSIZE = BYTE, MSIZE = BYTE, BURST = WRP16");
      C(Report);
      HSIZE = 0;
      Burst = 7;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(7, Burst, 0x00, HSIZE, 0, WriteData);
    

  /** Writing in to SSMCCR register to Enable the Clock **/
  SSMCCRData = CLKRATIO | CLKEN;
  HSA(SSMCCR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SSMCCRData);


}

/************************************ End *************************************/
