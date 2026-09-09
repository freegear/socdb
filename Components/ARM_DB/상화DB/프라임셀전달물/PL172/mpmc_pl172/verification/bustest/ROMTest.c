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
-- File Name              : ROMTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           It tests the write protect bit of StConfig register
--
--           TEST ID : MPMC_ROM_1
--
-- --=======================================================================--*/
/******************************************************************************/
/********************************** ROMTest ***********************************/
/******************************************************************************/
void ROMTest()
{
  /* 
     Summary: ROMTest
     ================
     This test performs the following operations.

     o  It reads from ROM with different types of burst, sizes.

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
  C("TEST ID : MPMC_ROM_1");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  WriteData(MPMCControl, 0x00000001, "WRD");
  WriteData(MPMCTrExBkOff, 0x00000007, "WRD");
  /* Configure registers as well as memory banks */
  C("Program bank0");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,2,0,0,1,0,0,0,1,0x3,0x5,0x6,0x4,0x5,0x1,0x4);
  TrickMemInit(0,2,0,0,1,0,0,0,1,0x3,0x5,0x6,0x4,0x1,0x1,MPMCTrMEMBData[0],
               0x0);

  /* Program bank1 : enable page mode, read buffer */
  C("Program bank1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,0,1,0x2,0x2,0x3,0x2,0x3,0x1,0x4);
  TrickMemInit(1,1,0,0,1,0,0,0,1,0x2,0x2,0x3,0x2,0x3,0x1,MPMCTrMEMBData[1],
               0x0);

  /* Program bank2 : enable page mode ,disable read and write buffer */
  C("Program bank2");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,0,0,0,0,0,0,0,1,0x3,0x5,0x7,0x4,0x4,0x1,0x4);
  TrickMemInit(2,0,0,0,0,0,0,0,1,0x3,0x5,0x7,0x4,0x4,0x1,MPMCTrMEMBData[2],
               0x0);

  /* Program bank3 : enable page mode, read buffer */
  C("Program bank3");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,0,0,0,0,0,0,0,1,0x2,0x2,0x5,0x3,0x5,0x1,0x4);
  TrickMemInit(3,0,0,0,0,0,0,0,1,0x2,0x2,0x5,0x3,0x5,0x1,MPMCTrMEMBData[3],
               0x0);

  AHBWriteMem(0, 0x00, 0x20, 0x11111111);
  AHBWriteMem(1, 0x00, 0x20, 0x00003333);
  AHBWriteMem(2, 0x00, 0x20, 0x00000022);
  AHBWriteMem(3, 0x00, 0x20, 0x00000022);
  DataCS0 = 0x11111111;
  DataCS1 = 0x00003333;
  DataCS2 = 0x00000022;
  DataCS3 = 0x00000022;
  WriteData(MPMCTrMEMT_0, 0x52, "WRD");
  C("Reading from bank0 with burst as INCR and size as BYTE");
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x00;
  ReadData1 = DataCS0;
  /* burst = INCR, sizetype = BYTE */
  ReadData1 = 0x11111111;
  HSA(MemAddr, NSEQ, INCR, OK, BYTE);
  HSR(, ReadData1,,0x000000FF, ,ROMTest_1);
  for(i = 1; i < 4; i++)
  {
    TmpRdData = ReadData1 << (8*i) & Bmask[i];
    HSR(, TmpRdData,,Bmask[i], ,ROMTest_1);
  }
  /* burst = INCR4, sizetype = HWRD */
  C("Reading from bank0 with burst as INCR4 and size as HWRD");
  TmpRdData = (ReadData1 & 0x0000FFFF);
  HSA(MemAddr, NSEQ, INCR4, OK, HWRD); 
  HSR(, TmpRdData, ,0x0000FFFF, ,ROMTest_2);
  for(i = 1; i < 4; i++)
  {
    k = i % 2;
    if(k == 0)
      ReadData1 = ReadData1 + 1;
    TmpRdData = ReadData1 & (0x0000FFFF << 16 * k);
    HSR(, TmpRdData, ,Hmask[k], ,ROMTest_3);
  }
  /* burst = INCR8, sizetype = WRD */
  C("Reading from bank0 with burst as INCR8 and size as WRD");
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, INCR8, OK, WRD);
  HSR(, ReadData1, ,MaskALL, ,ROMTest_4);
  ReadData1 = ReadData1 + 1;
  for(i = 0; i < 7; i++)
  {
    HSR(, ReadData1, ,MaskALL, ,ROMTest_5);
    ReadData1 = ReadData1 + 1;
  }
  C("Reading from bank0 with burst as WRAP4 and size as BYTE");
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x1;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE);
  HSR(, ReadData1, ,0x0000FF00, ,ROMTest_6);
  for(i = 2; i < 5; i++)
  {
     k = i % 4;
     if( k == 0)
       TmpRdData = DataCS0;
     TmpRdData = (ReadData1 << (8 * k)) & Bmask[k];
     HSR(, TmpRdData, ,Bmask[k], ,ROMTest_6);
  }

  C("Reading from bank1 with burst as INCR16 and size as HWRD");
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x0;
  ReadData1 = DataCS1;
  HSA(MemAddr, NSEQ, INCR16, OK, HWRD);
  HSR(,ReadData1++, ,0x0000FFFF, ,ROMTest_6);
  for(i = 1; i < 16; i++)
  {
    k = i % 2;
    TmpRdData = ReadData1 << (16 * k);
    HSR(,TmpRdData, ,Hmask[k], ,ROMTest_6);
    ReadData1 = ReadData1 + 1;
  }
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_1, 0x51, "WRD");
  C("Reading from bank1 with burst as WRAP4 and size as BYTE");
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x0;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS1;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE);
  HSR(, ReadData1, ,0x000000FF, ,ROMTest_6);
  for(i = 1; i < 4; i++) 
  {
    k = i % 2;
    if(k == 0)
    ReadData1 = ReadData1 + 1;
    TmpRdData = (ReadData1 & Bmask[k])>>(8*k);
    TmpRdData = (TmpRdData<< (8*i));
    HSR(, TmpRdData, ,Bmask[i], ,ROMTest_6);
  }
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_1, 0x41, "WRD"); 
  /* burst = WRAP8, sizetype = HWRD */
  C("Reading from bank1 with burst as WRAP8 and size as HWRD"); 
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x2;
  ReadData1 = DataCS1;
  ReadData1 = ReadData1 + 1;
  HSA(MemAddr, NSEQ, WRAP8, OK, HWRD); 
  TmpRdData = ReadData1 << 16;
  HSR(, TmpRdData, ,0xFFFF0000, ,ROMTest_7);
  ReadData1 = ReadData1 + 1;
  for(i = 2; i < 9; i++)
  {
    k = i % 2;
    x = i % 8;
    if(x == 0)
    ReadData1 = DataCS1;
    TmpRdData = (ReadData1 << (16 * k)) & (0x0000FFFF << 16 * k);
    HSR(, TmpRdData, ,Hmask[k], ,ROMTest_3);
    ReadData1 = ReadData1 + 1;
  }
  /* burst = WRAP16, sizetype = WRD */
  C("Reading from bank1 with burst as WRAP16 and size as WRD");
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x4;
  ReadData1 = DataCS1;
  ReadData1 = ReadData1 + 2;
  TmpRdData = (ReadData1 & 0x0000FFFF) | (((ReadData1 + 1)<< 16) & 0xFFFF0000);
  HSA(MemAddr, NSEQ, WRAP16, OK, WRD);
  HSR(, TmpRdData, ,MaskALL, ,ROMTest_9);
  ReadData1 = ReadData1 + 2;
  for(i = 1; i < 16; i++)
  {
    k = i % 15;
    if(k == 0)
      ReadData1 = DataCS1;
    TmpRdData = (ReadData1 & 0x0000FFFF) | 
                (((ReadData1 + 1)<< 16) & 0xFFFF0000);
    HSR(, TmpRdData, ,MaskALL, ,ROMTest_10);
    ReadData1 = ReadData1 + 2;
  } 
  C("Reading from bank2 with burst as WRAP4 and size as BYTE");
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11)+ 0x00;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS2;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE);
  HSR(, ReadData1++, ,0x000000FF, ,ROMTest_11);
  for(i = 1; i < 4; i++)
  {
     TmpRdData = (ReadData1 << (8 * i)) & Bmask[i];   
     HSR(, TmpRdData, ,Bmask[i], ,ROMTest_12);
     ReadData1 = ReadData1 + 1;
  } 
  /* burst = INCR4, sizetype = HWRD */
  C("Reading from bank2 with burst as INCR4 and size as HWRD");
  ReadData1 = DataCS2;
  TmpRdData = (ReadData1 & 0x000000FF) | (((ReadData1 + 1)<< 8) & 0x0000FF00);
  HSA(MemAddr, NSEQ, INCR4, OK, HWRD);
  HSR(, TmpRdData, ,0x0000FFFF, ,ROMTest_13);
  ReadData1 = ReadData1 + 2;
  for(i = 1; i < 4; i++)
  {
    k = i % 2;
    TmpRdData = ((ReadData1 & 0x000000FF) | 
                 (((ReadData1 + 1)<< 8) & 0x0000FF00)) << (16 * k);
    HSR(, TmpRdData, ,Hmask[k], ,ROMTest_13);
    ReadData1 = ReadData1 + 2;
  }
  /* burst = INCR8, sizetype = WRD */
  C("Reading from bank2 with burst as INCR8 and size as WRD");
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11) + 0x00;
  ReadData1 = DataCS2;
  TmpRdData = ((ReadData1 & 0x000000FF) |
              (((ReadData1 + 1) << 8) & 0x0000FF00) |
              (((ReadData1 + 2) << 16) & 0x00FF0000) |
              (((ReadData1 + 3) << 24) & 0xFF000000));
  HSA(MemAddr, NSEQ, INCR8, OK, WRD);
  HSR(, TmpRdData, ,MaskALL, ,ROMTest_14);
  ReadData1 = ReadData1 + 4;
  for(i = 1; i < 8; i++)
  {
    TmpRdData = ((ReadData1 & 0x000000FF) |
              (((ReadData1 + 1) << 8) & 0x0000FF00) |
              (((ReadData1 + 2) << 16) & 0x00FF0000) |
              (((ReadData1 + 3) << 24) & 0xFF000000));
    HSR(, TmpRdData, ,MaskALL, ,ROMTest_15);
    ReadData1 = ReadData1 + 4;
  }

  C("Reading from bank3 with burst as INCR4 and size as BYTE");
  MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11) + 0x00;
  ReadData1 = DataCS3;
  /* burst = INCR4, sizetype = BYTE */
  HSA(MemAddr, NSEQ, INCR4, OK, BYTE);
  HSR(, ReadData1++,,0x000000FF, ,ROMTest_16);
  for(i = 1; i < 4; i++)
  {
    TmpRdData = (ReadData1 << (8 * i)) & Bmask[i]; 
    HSR(, TmpRdData, ,Bmask[i], ,ROMTest_17);
    ReadData1 = ReadData1 + 1;
  }
  /* burst = INCR, sizetype = HWRD */
  C("Reading from bank3 with burst as INCR and size as HWRD");
  MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11) + 0x00;
  ReadData1 = DataCS3;
  TmpRdData = (ReadData1 & 0x000000FF) | 
              (((ReadData1 + 1) << 8) & 0x0000FF00) |
              (((ReadData1 + 2) << 16) & 0x00FF0000) |
              (((ReadData1 + 3) << 24) & 0xFF000000);
  ReadData1 = ReadData1 + 4;
  HSA(MemAddr, NSEQ, INCR, OK, HWRD);
  HSR(, TmpRdData, ,0xFFFFFFFF, ,ROMTest_18);
  /* burst = WRAP8, sizetype = WRD */
  C("Reading from bank3 with burst as WRAP8 and size as WRD");
  ReadData1 = DataCS3;  
  TmpRdData = ((ReadData1 & 0x000000FF) |
              (((ReadData1 + 1) << 8) & 0x0000FF00) |
              (((ReadData1 + 2) << 16) & 0x00FF0000) |
              (((ReadData1 + 3) << 24) & 0xFF000000));
  HSA(MemAddr, NSEQ, WRAP8, OK, WRD);
  HSR(, TmpRdData, ,MaskALL, ,ROMTest_19);
  ReadData1 = ReadData1 + 4;
  for(i = 0; i < 7; i++)
  {
    TmpRdData = ((ReadData1 & 0x000000FF) |
              (((ReadData1 + 1) << 8) & 0x0000FF00) |
              (((ReadData1 + 2) << 16) & 0x00FF0000) |
              (((ReadData1 + 3) << 24) & 0xFF000000));
    HSR(, TmpRdData, ,MaskALL, ,ROMTest_20);
    ReadData1 = ReadData1 + 4;
  }
  /* WRITE TO ROM AND VERIFY THAT RESPONSE IS E R R O R */
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
