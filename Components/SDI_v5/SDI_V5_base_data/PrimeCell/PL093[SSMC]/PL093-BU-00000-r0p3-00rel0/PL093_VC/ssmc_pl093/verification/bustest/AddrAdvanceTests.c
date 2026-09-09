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
--  File Name              : AddrAdvanceTests.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Synchronous transfers such that the 
--           highest burst counter address is reached
--
-- --=========================================================================*/

/******************************************************************************/
/***************************** Address Advance Test ***************************/
/******************************************************************************/

void AddrAdvanceTests()
{
  /*
     Summary: Address Advance Test 
     ==============================
     This function performs the following:

     o  Programs the Bank 2 and Bank 5 as 8 bit Synchronous SRAMS 
     o  BIWRITE & BIREAD bits in the SMBCR2 and SMBCR5 are enabled
     o  BURST Read accesses of INCR 8 and INCR 16 are done on the Bank2 and 
        Bank5 such that the burst address counter terminal count is crossed
     o  BURST Write/Read are also checked at non aligned starting address
  */

  int   i, j, beats, burst, hsize, msize;
  int32 MemAddr, TestData, WTCNCLData, ExtMuxData, BAAData2, BAAData5;
  int32 ReadData, ReadMask, SMBLSPOLData, TempData, testdata;
  int32 AddrMask[3] = {0x3, 0x2, 0x0};
  char  size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  int   Shift[3] = {8, 16, 32};
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};

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


  /** Set Bank 2 Memory Type as Synchronous SRAM (8 bits width) **/
  SSMCTrMEMBData[2] = 0x00000000;

  SMBCRData[2] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
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
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_EN       | BIREAD_DI        |
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5]);

  /** Initialise the Banks from AHB side **/
  AHBWriteMem(2, 0, 64, 0x00000033);
  AHBWriteMem(5, 0, 64, 0x00000033);

  /** Enable the BIWriteEN & BIReadEN bits in the SMBCR2 & SMBCR5 registers **/
  BAAData2 = SMBCRData[2] |  BIWRITE_DI | BIREAD_EN;
  BAAData5 = SMBCRData[5] |  BIWRITE_EN | BIREAD_EN;
  
  HSA(SMBCR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , BAAData2);

  HSA(SMBCR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , BAAData5);

  /** Performing BYTE reads to 8 bit Bank 2 SRAM in INCR8 burst mode **/
  C("READ ACCESSES TO BANK 2: HSIZE = BYTE, MSIZE = BYTE, HBURST = INCR8");
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[5] << 11) + 0x0000001C;
  TestData = 0x0000004F;
  ReadData = TestData;
  ReadMask = BUnMask0;
  HSA(MemAddr, NSEQ, INCR8, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , ReadMask, ,AddrAdvanceTests_1);
  for (i=1, TestData++; i< 8; i++, TestData++)
  {
    ReadMask = BUnMask0 << 8*i;
    ReadData = TestData << 8*i;
    HSR( , ReadData, , ReadMask, ,AddrAdvanceTests_2);
  }

  /** Performing BYTE reads to 8 bit Bank 5 SRAM in INCR16 burst mode **/
  C("READ ACCESSES TO BANK 5: HSIZE = BYTE, MSIZE = BYTE, HBURST = INCR16");
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 0x00000018;
  TestData = 0x0000004B;
  ReadData = TestData;
  ReadMask = BUnMask0;
  HSA(MemAddr, NSEQ, INCR16, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , ReadMask, ,AddrAdvanceTests_3);
  for (i=1, TestData++; i< 16; i++, TestData++)
  {
    ReadMask = BUnMask0 << 8*i;
    ReadData = TestData << 8*i;
    HSR( , ReadData, , ReadMask, ,AddrAdvanceTests_4);
  }
  
  MemAddr = SSMCMEM_2 + 0x1F;
  beats = 16;
  burst = 4;
  hsize = 0;
  msize = 0x0;
  TestData = 0x00123456;

  C("CHECKING BOUNDARY CROSSOVER CONDITION: STARTING NEW BURST ON BANK 2");
  C("HSIZE = BYTE, MSIZE = BYTE, HBURST = INCR16");

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
  HSR( , testdata, , ReadMask, ,AddrAdvanceTests_5);
  for (i = 1, j++, TempData++; i < beats; i++, j++, TempData++)
  {
    ReadMask = (UnMask[hsize] << j*Shift[hsize]);
    testdata = (TempData << j*Shift[hsize]) & ReadMask;
    HSR( , testdata, , ReadMask, ,AddrAdvanceTests_6);
  }

  WaitLoop(20);
  SSMCCRDATA = 0x00000002 | CLKSTATUS;
  ConfigureCLKRatio(SSMCCRDATA);
  WaitLoop(20);

  /** Initialise the Banks from AHB side **/
  AHBWriteMem(2, 0, 64, 0x00000033);
  AHBWriteMem(5, 0, 64, 0x00000033);


  /** Performing BYTE reads to 8 bit Bank 2 SRAM in INCR8 burst mode **/
  C("READ ACCESSES TO BANK 2: HSIZE = BYTE, MSIZE = BYTE, HBURST = INCR8");
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[5] << 11) + 0x0000001C;
  TestData = 0x0000004F;
  ReadData = TestData;
  ReadMask = BUnMask0;
  HSA(MemAddr, NSEQ, INCR8, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , ReadMask, ,AddrAdvanceTests_1);
  for (i=1, TestData++; i< 8; i++, TestData++)
  {
    ReadMask = BUnMask0 << 8*i;
    ReadData = TestData << 8*i;
    HSR( , ReadData, , ReadMask, ,AddrAdvanceTests_2);
  }

  /** Performing BYTE reads to 8 bit Bank 5 SRAM in INCR16 burst mode **/
  C("READ ACCESSES TO BANK 5: HSIZE = BYTE, MSIZE = BYTE, HBURST = INCR16");
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 0x00000018;
  TestData = 0x0000004B;
  ReadData = TestData;
  ReadMask = BUnMask0;
  HSA(MemAddr, NSEQ, INCR16, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , ReadMask, ,AddrAdvanceTests_3);
  for (i=1, TestData++; i< 16; i++, TestData++)
  {
    ReadMask = BUnMask0 << 8*i;
    ReadData = TestData << 8*i;
    HSR( , ReadData, , ReadMask, ,AddrAdvanceTests_4);
  }
  
  MemAddr = SSMCMEM_2 + 0x1F;
  beats = 16;
  burst = 4;
  hsize = 0;
  msize = 0x0;
  TestData = 0x00123456;

  C("CHECKING BOUNDARY CROSSOVER CONDITION: STARTING NEW BURST ON BANK 2");
  C("HSIZE = BYTE, MSIZE = BYTE, HBURST = INCR16");

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
  HSR( , testdata, , ReadMask, ,AddrAdvanceTests_5);
  for (i = 1, j++, TempData++; i < beats; i++, j++, TempData++)
  {
    ReadMask = (UnMask[hsize] << j*Shift[hsize]);
    testdata = (TempData << j*Shift[hsize]) & ReadMask;
    HSR( , testdata, , ReadMask, ,AddrAdvanceTests_6);
  }


  WaitLoop(20);
  SSMCCRDATA = 0x00000004 | CLKSTATUS;
  ConfigureCLKRatio(SSMCCRDATA);
  WaitLoop(20);

  /** Initialise the Banks from AHB side **/
  AHBWriteMem(2, 0, 64, 0x00000033);
  AHBWriteMem(5, 0, 64, 0x00000033);


  /** Performing BYTE reads to 8 bit Bank 2 SRAM in INCR8 burst mode **/
  C("READ ACCESSES TO BANK 2: HSIZE = BYTE, MSIZE = BYTE, HBURST = INCR8");
  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[5] << 11) + 0x0000001C;
  TestData = 0x0000004F;
  ReadData = TestData;
  ReadMask = BUnMask0;
  HSA(MemAddr, NSEQ, INCR8, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , ReadMask, ,AddrAdvanceTests_1);
  for (i=1, TestData++; i< 8; i++, TestData++)
  {
    ReadMask = BUnMask0 << 8*i;
    ReadData = TestData << 8*i;
    HSR( , ReadData, , ReadMask, ,AddrAdvanceTests_2);
  }

  /** Performing BYTE reads to 8 bit Bank 5 SRAM in INCR16 burst mode **/
  C("READ ACCESSES TO BANK 5: HSIZE = BYTE, MSIZE = BYTE, HBURST = INCR16");
  MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + 0x00000018;
  TestData = 0x0000004B;
  ReadData = TestData;
  ReadMask = BUnMask0;
  HSA(MemAddr, NSEQ, INCR16, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , ReadMask, ,AddrAdvanceTests_3);
  for (i=1, TestData++; i< 16; i++, TestData++)
  {
    ReadMask = BUnMask0 << 8*i;
    ReadData = TestData << 8*i;
    HSR( , ReadData, , ReadMask, ,AddrAdvanceTests_4);
  }
  
  MemAddr = SSMCMEM_2 + 0x1F;
  beats = 16;
  burst = 4;
  hsize = 0;
  msize = 0x0;
  TestData = 0x00123456;

  C("CHECKING BOUNDARY CROSSOVER CONDITION: STARTING NEW BURST ON BANK 2");
  C("HSIZE = BYTE, MSIZE = BYTE, HBURST = INCR16");

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
  HSR( , testdata, , ReadMask, ,AddrAdvanceTests_5);
  for (i = 1, j++, TempData++; i < beats; i++, j++, TempData++)
  {
    ReadMask = (UnMask[hsize] << j*Shift[hsize]);
    testdata = (TempData << j*Shift[hsize]) & ReadMask;
    HSR( , testdata, , ReadMask, ,AddrAdvanceTests_6);
  }


  WaitLoop(20);
  MemAddr = SSMCMEM_5 + 0x20;
  testdata = 0xDEADBEEF;

  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , testdata);

  MemAddr = SSMCMEM_2 + 0x20;
  testdata = 0xBEEFDEAD;

  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , testdata);

  MemAddr = SSMCMEM_5 + 0x20;
  testdata = 0xDEADBEEF;

  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , testdata, , NoMask, ,AddrAdvanceTests_5);

  WaitLoop(20);
  SSMCCRDATA = CLKRATIO | CLKSTATUS;
  ConfigureCLKRatio(SSMCCRDATA);
  WaitLoop(20);


  /** Disable the BIWriteEN & BIReadEN for both the banks **/
  BAAData2 = SMBCRData[2] |  BIWRITE_DI | BIREAD_DI;
  BAAData5 = SMBCRData[5] |  BIWRITE_DI | BIREAD_DI;
  
  HSA(SMBCR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , BAAData2);

  HSA(SMBCR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , BAAData5);

}

/************************************ End *************************************/
