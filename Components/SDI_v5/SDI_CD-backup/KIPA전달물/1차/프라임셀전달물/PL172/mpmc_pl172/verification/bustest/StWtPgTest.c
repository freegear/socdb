/*-- --=======================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : StWtPgTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           It checks the page mode access to the Page Mode ROM.
--
--           TEST ID : MPMC_StWtPg
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************** StWtPgTest **********************************/
/******************************************************************************/
void StWtPgTest()
{
  /* 
     Summary: StWtPgTest
     ================
     This test performs the following operations

     o  Enable the page mode access.

     o  It reads from Burst ROM with different types of burst, sizes.

     o  It tries to write to memory and verifies that the response is Error.
  */
  unsigned long MemAddr, ReadData1,WriteData1,TmpRdData;
  int i,k,x;
  int32 DataCS0,DataCS1,DataCS2,DataCS3;
  char *bursttype[7] = {"INCR", "INCR4", "INCR8","INCR16", "WRAP4",
                        "WRAP8", "WRAP16"};
  char *sizetype[3] = {"BYTE","HWRD","WRD"};
  int32 Hmask[] = {0x0000FFFF, 0xFFFF0000};
  int32 Bmask[] = {0x000000FF, 0x0000FF00, 0x00FF0000,0xFF000000};
  C("TEST ID : MPMC_StWtPg");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  WriteData(MPMCControl, 0x00000001, "WRD");
  /* Configure registers as well as memory banks */
  C("Program bank0");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,2,1,0,1,0,0,0,1,0x3,0x5,0x7,0x6,0x5,0x1,0x4);
  TrickMemInit(0,2,1,0,1,0,0,0,1,0x3,0x5,0x7,0x6,0x5,0x1,MPMCTrMEMBData[0],
               0x0);

  /* Program bank1 : enable page mode, read buffer and connect BHE pin to Vcc */
  C("Program bank1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,1,0,1,0,0,0,1,0x2,0x3,0x5,0x4,0x3,0x1,0x4);
  TrickMemInit(1,1,1,0,1,0,0,0,1,0x2,0x3,0x5,0x4,0x3,0x1,MPMCTrMEMBData[1],
               0x0);

  /* Program bank2 : enable page mode ,disable read and write buffer */
  C("Program bank2");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,0,1,0,0,0,0,0,1,0x3,0x5,0x8,0x6,0x4,0x1,0x4);
  TrickMemInit(2,0,1,0,0,0,0,0,1,0x3,0x5,0x8,0x6,0x4,0x1,MPMCTrMEMBData[2],
               0x0);

  /* Program bank3 : enable page mode, read buffer and connect BHE pin to GND */
  C("Program bank3");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,0,1,0,0,0,0,0,1,0x2,0x2,0x4,0x3,0x5,0x1,0x4);
  TrickMemInit(3,0,1,0,0,0,0,0,1,0x2,0x2,0x4,0x3,0x5,0x1,MPMCTrMEMBData[3],
               0x0);

  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_1, 0x71, "WRD");

  AHBWriteMem(1, 0x00, 0x20, 0x00001211);
  C("Reading from bank1 with burst as INCR4 and size as BYTE");
  HSA(0x10000003, NSEQ, INCR4, OK,BYTE);
  HSR(,0x12000000, ,0xFF000000);
  HSA(0x10000004, SEQ, INCR4, OK,BYTE);
  HSR(,0x00000013, ,0x000000FF);
  HSA(0x10000005, SEQ, INCR4, OK,BYTE);
  HSR(,0x00001200, ,0x0000FF00);
  HSA(0x10000006, SEQ, INCR4, OK,BYTE);
  HSR(,0x00140000, ,0x00FF0000);
  AHBWriteMem(0, 0x00, 0x20, 0x11111111);
  AHBWriteMem(1, 0x00, 0x20, 0x00003333);
  AHBWriteMem(2, 0x00, 0x20, 0x00000022);
  AHBWriteMem(3, 0x00, 0x20, 0x00000022);
  DataCS0 = 0x11111111;
  DataCS1 = 0x00003333;
  DataCS2 = 0x00000022;
  DataCS3 = 0x00000022;
  C("Reading from bank0 with burst as INCR and size as BYTE");
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_0, 0x72, "WRD"); 
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x00;
  ReadData1 = DataCS0;
  /* burst = INCR, sizetype = BYTE */
  ReadData1 = 0x11111111;
  HSA(MemAddr, NSEQ, INCR4, OK, BYTE);
  HSR(, ReadData1,,0x000000FF, ,BURSTROMTest_1);
  for(i = 1; i < 4; i++)
  {
    TmpRdData = ReadData1 << (8*i) & Bmask[i];
    HSR(, TmpRdData,,Bmask[i], ,BURSTROMTest_1);
  }
  /* burst = INCR4, sizetype = HWRD */
  C("Reading from bank0 with burst as INCR4 and size as HWRD");
  ReadData1 = DataCS0;
  TmpRdData = (ReadData1 & 0x0000FFFF);
  HSA(MemAddr, NSEQ, INCR4, OK, HWRD); 
  HSR(, TmpRdData, ,0x0000FFFF, ,BURSTROMTest_2);
  for(i = 1; i < 4; i++)
  {
    k = i % 2;
    if(k == 0)
     ReadData1 = ReadData1 + 1;
    TmpRdData = ReadData1 & (0x0000FFFF << 16 * k);
    HSR(, TmpRdData, ,Hmask[k], ,BURSTROMTest_3);
  }
  /* burst = INCR8, sizetype = WRD */
  C("Reading from bank0 with burst as INCR8 and size as WRD");
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, INCR8, OK, WRD);
  HSR(, ReadData1, ,MaskALL, ,BURSTROMTest_4);
  ReadData1 = ReadData1 + 1;
  for(i = 0; i < 6; i++)
  {
    HSR(, ReadData1, ,MaskALL, ,BURSTROMTest_5);
    ReadData1 = ReadData1 + 1;
  }

  C("Reading from bank0 with burst as WRAP4 and size as BYTE");
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x1;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE);
  HSR(, ReadData1, ,0x0000FF00, ,BURSTROMTest_6);
  ReadData1 = ReadData1 + 1;
  for(i = 2; i < 5; i++)
  {
     k = i % 4;
     if(k == 0)
     ReadData1 = DataCS0;
     TmpRdData = ReadData1 & Bmask[k];
     HSR(, TmpRdData, ,Bmask[k], ,BURSTROMTest_6);
  }
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_0, 0x42, "WRD");

  C("Reading from bank1 with burst as INCR16 and size as HWRD");
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x0;
  ReadData1 = DataCS1;
  HSA(MemAddr, NSEQ, INCR16, OK, HWRD);
  HSR(,ReadData1++, ,0x0000FFFF, ,BURSTROMTest_6);
  for(i = 1; i < 15; i++)
  {
    k = i % 2;
    TmpRdData = ReadData1 << (16 * k);
    HSR(,TmpRdData, ,Hmask[k], ,BURSTROMTest_6);
    ReadData1 = ReadData1 + 1;
  }
  C("Reading from bank1 with burst as WRAP4 and size as BYTE");
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x0;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS1;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE);
  HSR(, ReadData1, ,0x000000FF, ,BURSTROMTest_6);
  for(i = 1; i < 3; i++) 
  {
     k = i % 2;
     if(k == 0)
       ReadData1 = ReadData1 + 1;
     TmpRdData = (ReadData1 & Bmask[k])>>(8*k);
     TmpRdData = (TmpRdData<< (8*i));  
     HSR(, TmpRdData, ,Bmask[i], ,BURSTROMTest_6);
  }
  /* burst = WRAP8, sizetype = HWRD */
  C("Reading from bank1 with burst as WRAP8 and size as HWRD"); 
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x2;
  ReadData1 = DataCS1;
  HSA(MemAddr, NSEQ, WRAP8, OK, HWRD);
  ReadData1 = ReadData1 + 1;
  TmpRdData = ReadData1 << 16; 
  HSR(, TmpRdData, ,0xFFFF0000, ,BURSTROMTest_7);
  ReadData1 = ReadData1 + 1;
  for(i = 2; i < 9; i++)
  {
     k = i % 2;
     x = i % 8;
    TmpRdData = (ReadData1 << (16 * k)) & (0x0000FFFF << 16 * k);
     if(x == 0)
       TmpRdData = DataCS1; 
    HSR(, TmpRdData, ,Hmask[k], ,BURSTROMTest_3);
    ReadData1 = ReadData1 + 1;
  }
  /* burst = WRAP16, sizetype = WRD */
  C("Reading from bank1 with burst as WRAP16 and size as WRD");
  ReadData1 = DataCS1;
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x4;
  ReadData1 = ReadData1 + 2;
  TmpRdData = (ReadData1 & 0x0000FFFF) | (((ReadData1 + 1)<< 16) & 0xFFFF0000);
  HSA(MemAddr, NSEQ, WRAP16, OK, WRD);
  HSR(, TmpRdData, ,MaskALL, ,BURSTROMTest_9);
  ReadData1 = ReadData1 + 2;
  for(i = 1; i < 16; i++)
  {
    k = i % 15; 
    if(k == 0)
      ReadData1 = DataCS1;
    TmpRdData = (ReadData1 & 0x0000FFFF) | 
                (((ReadData1 + 1)<< 16) & 0xFFFF0000);
    HSR(, TmpRdData, ,MaskALL, ,BURSTROMTest_10);
    ReadData1 = ReadData1 + 2;
  } 
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_1, 0x41, "WRD");
  C("Reading from bank2 with burst as WRAP4 and size as BYTE");
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11)+ 0x00;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS2;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE);
  HSR(, ReadData1++, ,0x000000FF, ,BURSTROMTest_11);
  for(i = 1; i < 3; i++)
  {
     TmpRdData = (ReadData1 << (8 * i)) & Bmask[i];   
     HSR(, TmpRdData, ,Bmask[i], ,BURSTROMTest_12);
     ReadData1 = ReadData1 + 1;
  } 
  /* burst = INCR4, sizetype = HWRD */
  C("Reading from bank2 with burst as INCR4 and size as HWRD");
  ReadData1 = DataCS2;
  TmpRdData = (ReadData1 & 0x000000FF) | (((ReadData1 + 1)<< 8) & 0x0000FF00);
  HSA(MemAddr, NSEQ, INCR4, OK, HWRD);
  HSR(, TmpRdData, ,0x0000FFFF, ,BURSTROMTest_13);
  ReadData1 = ReadData1 + 2;
  for(i = 1; i < 4; i++)
  {
    k = i % 2;
    TmpRdData = ((ReadData1 & 0x000000FF) | 
                 (((ReadData1 + 1)<< 8) & 0x0000FF00)) << (16 * k);
    HSR(, TmpRdData, ,Hmask[k], ,BURSTROMTest_13);
    ReadData1 = ReadData1 + 2;
  }
  /* burst = INCR8, sizetype = WRD */
  C("Reading from bank2 with burst as INCR8 and size as WRD");
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_2, 0x30, "WRD");

  MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11) + 0x00;
  ReadData1 = DataCS2;
  TmpRdData = ((ReadData1 & 0x000000FF) |
              (((ReadData1 + 1) << 8) & 0x0000FF00) |
              (((ReadData1 + 2) << 16) & 0x00FF0000) |
              (((ReadData1 + 3) << 24) & 0xFF000000));
  HSA(MemAddr, NSEQ, INCR8, OK, WRD);
  HSR(, TmpRdData, ,MaskALL, ,BURSTROMTest_14);
  ReadData1 = ReadData1 + 4;
  for(i = 1; i < 8; i++)
  {
    TmpRdData = ((ReadData1 & 0x000000FF) |
              (((ReadData1 + 1) << 8) & 0x0000FF00) |
              (((ReadData1 + 2) << 16) & 0x00FF0000) |
              (((ReadData1 + 3) << 24) & 0xFF000000));
    HSR(, TmpRdData, ,MaskALL, ,BURSTROMTest_15);
    ReadData1 = ReadData1 + 4;
  }
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_2, 0x00, "WRD");

  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_3, 0x30, "WRD");

  C("Reading from bank3 with burst as INCR4 and size as BYTE");
  MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11) + 0x00;
  ReadData1 = DataCS3;
  /* burst = INCR4, sizetype = BYTE */
  HSA(MemAddr, NSEQ, INCR4, OK, BYTE);
  HSR(, ReadData1++,,0x000000FF, ,BURSTROMTest_16);
  for(i = 1; i < 4; i++)
  {
    TmpRdData = (ReadData1 << (8 * i)) & Bmask[i]; 
    HSR(, TmpRdData, ,Bmask[i], ,BURSTROMTest_17);
    ReadData1 = ReadData1 + 1;
  }
  /* burst = INCR, sizetype = HWRD */
  C("Reading from bank3 with burst as INCR and size as HWRD");
   MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11) + 0x00;
  ReadData1 = DataCS3;
  TmpRdData = (ReadData1 & 0x000000FF) | 
              (((ReadData1 + 1) << 8) & 0x0000FF00); 
  ReadData1 = ReadData1 + 2;
  HSA(MemAddr, NSEQ, INCR4, OK, HWRD);
  HSR(, TmpRdData, ,0x0000FFFF, ,BURSTROMTest_18);
  for(i = 1; i < 4; i++)
  {
     k = i % 2;
     TmpRdData = (ReadData1 & 0x000000FF) |
              (((ReadData1 + 1) << 8) & 0x0000FF00);
     TmpRdData = TmpRdData << (16*k); 
     HSR(, TmpRdData, ,Hmask[k], ,BURSTROMTest_18);
     ReadData1 = ReadData1 + 2;
  }
  /* burst = WRAP8, sizetype = WRD */
  C("Reading from bank3 with burst as WRAP8 and size as WRD");
  ReadData1 = DataCS3;  
  TmpRdData = ((ReadData1 & 0x000000FF) |
              (((ReadData1 + 1) << 8) & 0x0000FF00) |
              (((ReadData1 + 2) << 16) & 0x00FF0000) |
              (((ReadData1 + 3) << 24) & 0xFF000000));
  HSA(MemAddr, NSEQ, WRAP8, OK, WRD);
  HSR(, TmpRdData, ,MaskALL, ,BURSTROMTest_19);
  ReadData1 = ReadData1 + 4;
  for(i = 0; i < 6; i++)
  {
    TmpRdData = ((ReadData1 & 0x000000FF) |
              (((ReadData1 + 1) << 8) & 0x0000FF00) |
              (((ReadData1 + 2) << 16) & 0x00FF0000) |
              (((ReadData1 + 3) << 24) & 0xFF000000));
    HSR(, TmpRdData, ,MaskALL, ,BURSTROMTest_20);
    ReadData1 = ReadData1 + 4;
  }
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_3, 0x00, "WRD");
  /* WRITE TO BURST ROM AND VERIFY THAT RESPONSE IS ERROR */
C("Writing to bank0 with burst as INCR and size as BYTE and resp is E R R O R");
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x00;
  /* burst = INCR, sizetype = BYTE */
  WriteData1 = 0x00000000;
  HSA(MemAddr, NSEQ, INCR, ERROR, BYTE);
  HSW(, WriteData1);

  /* burst = INCR, sizetype = HWRD */
C("Writing to bank0 with burst as INCR and size as HWRD and resp is E R R O R");
  HSA(MemAddr, NSEQ, INCR, ERROR, HWRD);
  HSW(, WriteData1);

  /* burst = INCR, sizetype = WRD */
 C("Writing to bank0 with burst as INCR and size as WRD and resp is E R R O R");
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD);
  HSW(, WriteData1++);
  /* burst = INCR, sizetype = HWRD */
C("Writing to bank1 with burst as INCR and size as HWRD and resp is E R R O R");
  HSA(MemAddr, NSEQ, INCR, ERROR, HWRD);
  HSW(, WriteData1++);

  /* burst = INCR, sizetype = WRD */
 C("Writing to bank1 with burst as INCR and size as WRD and resp is E R R O R");
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD);
  HSW(, WriteData1++);
  C("Writing to bank2 with burst as INCR and size as BYTE");
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11) + 0x00;
  /* burst = INCR, sizetype = BYTE */
  WriteData1 = 0x00000022;
  HSA(MemAddr, NSEQ, INCR, ERROR, BYTE);
  HSW(, WriteData1++);
  /* burst = INCR, sizetype = HWRD */
C("Write from bank2 with burst as INCR and size as HWRD and resp is E R R O R");
  HSA(MemAddr, NSEQ, INCR, ERROR, HWRD);
  HSW(, WriteData1);

  /* burst = INCR, sizetype = WRD */
 C("Writing to bank2 with burst as INCR and size as WRD and resp is E R R O R");
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD);
  HSW(, WriteData1++);
C("Writing to bank3 with burst as INCR and size as BYTE and resp is E R R O R");
  MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11) + 0x00;
  /* burst = INCR, sizetype = BYTE */
  WriteData1 = 0x00000022;
  HSA(MemAddr, NSEQ, INCR, ERROR, BYTE);
  HSW(, WriteData1++);

  /* burst = INCR, sizetype = HWRD */
C("Writing to bank3 with burst as INCR and size as HWRD and resp is E R R O R");
  HSA(MemAddr, NSEQ, INCR, ERROR, HWRD);
  HSW(, WriteData1++);

  /* burst = INCR, sizetype = WRD */
 C("Writing to bank3 with burst as INCR and size as WRD and resp is E R R O R");
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD);
  HSW(, WriteData1++);
  for(i = 0; i < 7; i++)
    HSW(, WriteData1++)
  WriteData(MPMCTrTES, 0x00000008, "WRD");
}
/*-- --================================ End ================================--*/
