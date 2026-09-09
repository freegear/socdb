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
--  File Name              : AddrValidTests.c.rca
--  File Revision          : 1.5
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routine checks the Address Valid signal behaviour during
--           synchronous write and reads. 
--
-- --=========================================================================*/

/******************************************************************************/
/***************************** Address Valid Test *****************************/
/******************************************************************************/

void AddrValidTests()
{
  /*
     Summary: Addrress Valid Test 
     ==============================
     This function performs the following:

     o  Programs the Bank 2 and Bank 5 as Synchronous Banks 
     o  Does Synchronous BURST Writes followed by Asynchronous Burst Reads
        to bank 2.   
     o  Does Asynchronous BURST Writes followed by Synchronous Burst Reads
        to bank 5.   
  */

  int   i, j, beats, burst, hsize, msize;
  int32 MemAddr, TestData, WTCNCLData, ExtMuxData, BAAData2, BAAData5;
  int32 ReadData, ReadMask, SMBLSPOLData, TempData, testdata;
  int32 AddrMask[3] = {0x3, 0x2, 0x0};
  char  size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  int   Shift[3] = {8, 16, 32};
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  char PrtString[75];


  /*
     Programming SSMCCR and SSMCTrCR registers. The constants CLKRATIO and
     CLKSTATUS defined in the Ssmc.h set the required  MemClkRatio and
     SMClockEn field bits.
  */
  SSMCCRDATA = CLKRATIO | CLKSTATUS;
  ConfigureCLKRatio(SSMCCRDATA);

  /**  Programming the SSMCTrBurstWT register **/
  SSMCTrBurstWTData = BWtMask_EN | Beat15 | SSMCTrBurstWT15;
  ConfigureBurstWT(SSMCTrBurstWTData);

  /** Programming the SSMCTrWTCNCL register **/
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL10 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , WTCNCLData);

  /** Configuring the system to LITTLE endian mode **/
  ENDIANNESS = 0;
  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ENDIANNESS);
  HSEN(LITTLE);

  /** Programming the SSMCTrExtMuxWT register **/
  ExtMuxData = ExtMuxAss5 | ExtMuxDAss5 | ExtMuxDI;
  HSA(SSMCTrExtMux, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ExtMuxData);

  /** Programming the SSMCTrSMBLSPOL register **/
  SMBLSPOLData = SMBLSPOL_0;
  HSA(SSMCTrSMBLSPOL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBLSPOLData);

  /** Set Bank 2 Memory Type as Synchronous SRAM (8 bits width) **/
  SSMCTrMEMBData[2] = 0x00000000;

  SMBCRData[2] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK2, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD2);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2]);


  /** Set Bank 5 Memory Type as Synchronous SRAM (8 bits width) **/
  SSMCTrMEMBData[5] = 0x00000000;

  SMBCRData[5] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_ASY   | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5]);


  C("BURST WR/RDs ON BANK 2: HSIZE = BYTE, MSIZE = BYTE, HBURST = INCR16");

  MemAddr = SSMCMEM_2 + 0x1F;
  beats = 16;
  burst = 4;
  hsize = 0;
  msize = 0x0;
  TestData = 0x00123456;

  /** Writing via SSMC **/
  TempData = TestData;
  j = MemAddr & 0x3;
  testdata = TempData & UnMask[hsize];

  HSA(MemAddr, NSEQ, beat[burst], , size[hsize], , 0x1, , , , ,);
  HSW( , testdata);
  for (i = 1, j++, TempData++; i < beats; i++, j++, TempData++)
  {
    testdata = TempData & UnMask[hsize];
    HSW( , testdata);
  }

  /** Reading via SSMC **/
  TempData = TestData;
  j = (MemAddr & 0x3) >> hsize;
  ReadMask = UnMask[hsize] << j*Shift[hsize];
  testdata = (TempData << j*Shift[hsize]) & ReadMask;

  HSA(MemAddr, NSEQ, beat[burst], , size[hsize], , 0x1, , , , ,);
  HSR( , testdata, , ReadMask, ,AddrValidTests_1);
  for (i = 1, j++, TempData++; i < beats; i++, j++, TempData++)
  {
    ReadMask = (UnMask[hsize] << j*Shift[hsize]);
    testdata = (TempData << j*Shift[hsize]) & ReadMask;
    HSR( , testdata, , ReadMask, ,AddrValidTests_2);
  }

  C("BURST WR/RDs ON BANK 5: HSIZE = BYTE, MSIZE = BYTE, HBURST = INCR16");

  MemAddr = SSMCMEM_5 + 0x1F;
  beats = 16;
  burst = 4;
  hsize = 0;
  msize = 0x0;
  TestData = 0x00123456;

  /** Writing via SSMC **/
  TempData = TestData;
  j = MemAddr & 0x3;
  testdata = TempData & UnMask[hsize];
  
  HSA(MemAddr, NSEQ, beat[burst], , size[hsize], , 0x1, , , , ,);
  HSW( , testdata);
  for (i = 1, j++, TempData++; i < beats; i++, j++, TempData++)
  { 
    testdata = TempData & UnMask[hsize];
    HSW( , testdata);
  }
  
  /** Reading via SSMC **/
  TempData = TestData;
  j = (MemAddr & 0x3) >> hsize;
  ReadMask = UnMask[hsize] << j*Shift[hsize];
  testdata = (TempData << j*Shift[hsize]) & ReadMask;
  
  HSA(MemAddr, NSEQ, beat[burst], , size[hsize], , 0x1, , , , ,);
  HSR( , testdata, , ReadMask, ,AddrValidTests_3); 
  for (i = 1, j++, TempData++; i < beats; i++, j++, TempData++)
  {
    ReadMask = (UnMask[hsize] << j*Shift[hsize]);
    testdata = (TempData << j*Shift[hsize]) & ReadMask;
    HSR( , testdata, , ReadMask, ,AddrValidTests_4);
  }


}

/************************************ End *************************************/
