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
-- File Name              : CornerCases3.c.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           It performs different types of HTRANS operations at or near the
--           quad word boundary.
--
--           TEST ID : MPMC_CornerCases3
--
-- --=======================================================================--*/
/******************************************************************************/
/********************************** CornerCases3 ******************************/
/******************************************************************************/
void CornerCases3()
{
  /* 
      Summary:CornerCases3
      ====================
      This test performs the following functionalities
      
      o  Performs the BYTE write to the dynamic memory and reads the address
         with WORD as HSIZE which gets the data from both memory and buffer
         and checks for data integrity.

      o  Performs the HWRD write to the dynamic memory and reads the address
         with WORD as HSIZE which gets the data from both memory and buffer
         and checks for data integrity.

      o  It performs different types of HTRANS operation and verifies the data
         integrity.

      o  Different combinaitons are:
         NS-NS,NS-NS-NS,NS-S,NS-S-S,NS-I-NS,NS-B-S,NS-B-NS,NS-B-I,NS-S-B-S,
         NS-B-S-B-S
         All combinations mentioned above are tried with same as well as 
         different banks.

      o  All tests are conducted with buffers enabled.
  */
  unsigned long addr1, addr2, addr3, addr4, chpsel,data;
  unsigned long TestData;
  int i;
  int32 Addr;
  C("TEST ID : MPMC_CornerCases3");
  /* Disable Address Mirror bit */
  HSA(MPMCControl, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000001);

  TimingInit(2,5,8,0,5,2,0,7,7,0,2,3);
  SyncInitializeProc(3, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     3, 0, 3, 2, 0, 0,
                     3, 0, 2, 3, 0, 0,
                     0,1,3,0,0,1,1,0,3,1,2,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,1,
                     12,12,10,11,
                     0,
                     0);
  HSA(MPMCTrExBkOff, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000004);
  /* Set Bank 0 Memory Type as SRAM (32 bits width) */
  C("Program bank0");
  StInitProc(0,2,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);

  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Program bank1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,2,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(1,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  C("Program bank2");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,0,0,0,0,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x5,0x3);
  TrickMemInit(2,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (32 bits width) with buffers disabled */
  C("Program bank3");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,2,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(3,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);
  C("Initialise the memory");
  Addr = 0x51000000;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x51010000;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x51020000;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x51030000;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x51040000;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x51070000;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x51060000;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x51060100;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x51060120;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x51060200;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x51060300;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x51060310;
  for (i = 0; i < 0x40; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x51060400;
  for (i = 0; i < 0x40; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }

  Addr = 0x52100000;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x52110000;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x52120000;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x52130000;
  for (i = 0; i < 0x20; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x52140000;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x52170000;
  for (i = 0; i < 0x10; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x52160000;
  for (i = 0; i < 0x40; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x52160100;
  for (i = 0; i < 0x40; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x52160120;
  for (i = 0; i < 0x40; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x52160200;
  for (i = 0; i < 0x40; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x52160300;
  for (i = 0; i < 0x40; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x52160310;
  for (i = 0; i < 0x40; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  Addr = 0x52160400;
  for (i = 0; i < 0x40; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  
  C("Dummy writes to flush the buffer");
  Addr = 0x61060300;
  for (i = 0; i < 100; i++)
  {
    HSA(Addr, NSEQ, INCR, OK, WRD);
    HSW(, Addr);
    Addr = Addr + 4;
  }
  C("Perform byte write to the dynamic memory");
  HSA(0x50000000, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x50000000, NSEQ, INCR4, OK, WRD);
  HSR(,0xBBBBBB33, ,0x000000FF);
  HSR(,0xBBBBBBBC, ,0x00000000);
  HSR(,0xBBBBBBBD, ,0x00000000);
  HSR(,0xBBBBBBBE, ,0x00000000);

  C("Perform halfword write to the dynamic memory");
  HSA(0x50020000, NSEQ, INCR, OK, HWRD);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x50020000, NSEQ, INCR4, OK, WRD);
  HSR(,0x00003333, ,0x0000FFFF);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x50030004, NSEQ, INCR, OK, HWRD);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x50030004, NSEQ, INCR4, OK, WRD);
  HSR(,0x00003333, ,0x0000FFFF);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);

  C("Perform halfword write to the dynamic memory to the aligned address");
  HSA(0x50040000, NSEQ, INCR, OK, HWRD);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x50040000, NSEQ, INCR, OK, WRD);
  HSR(,0x00003333, ,0x0000FFFF);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);

  C("Perform Byte write to the dynamic memory to the aligned address");
  HSA(0x50050000, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x50050000, NSEQ, INCR4, OK, WRD);
  HSR(,0x00000033, ,0x000000FF);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);

  C("Perform WORD write to the dynamic memory to the aligned address");
  HSA(0x50050000, NSEQ, INCR, OK, WRD);
  HSW(,0x66666666);
  C("Perform byte read from the dynamic memory");
  HSA(0x50050000, NSEQ, INCR4, OK, BYTE);
  HSR(,0x00000066, ,0x000000FF);
  HSR(,0x00006600, ,0x0000FF00);
  HSR(,0x00660000, ,0x00FF0000);
  HSR(,0x66000000, ,0xFF000000);

  C("Perform WORD write to the dynamic memory to the aligned address");
  HSA(0x50050000, NSEQ, INCR, OK, WRD);
  HSW(,0x77777777);
  C("Perform byte read from the dynamic memory");
  HSA(0x50050000, NSEQ, INCR4, OK, BYTE);
  HSR(,0x00007777, ,0x0000FFFF);
  HSR(,0x77770000, ,0xFFFF0000);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x50060008, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x50060008, NSEQ, INCR4, OK, WRD);
  HSR(,0x00000033, ,0x000000FF);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x5006010C, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x5006010C, NSEQ, INCR4, OK, WRD);
  HSR(,0x00000033, ,0x000000FF);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x5006020E, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x5006020C, NSEQ, INCR4, OK, WRD);
  HSR(,0x00330000, ,0x00FF0000);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x5006030D, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x5006030C, NSEQ, INCR4, OK, WRD);
  HSR(,0x00003300, ,0x0000FF00);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x5006040F, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x5006040C, NSEQ, INCR4, OK, WRD);
  HSR(,0x33000000, ,0xFF000000);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);
  HSR(,0x00000000, ,0x00000000);

  C("Following cases read the data with INCR8");
  C("Perform byte write to the dynamic memory");
  HSA(0x51000000, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  
  C("Perform byte read from the dynamic memory");
  HSA(0x51000000, NSEQ, INCR8, OK, WRD);
  HSR(,0x51000033, ,0xFFFFFFFF);
  HSR(,0x51000004, ,0xFFFFFFFF);
  HSR(,0x51000008, ,0xFFFFFFFF);
  HSR(,0x5100000C, ,0xFFFFFFFF);
  HSR(,0x51000010, ,0xFFFFFFFF);
  HSR(,0x51000014, ,0xFFFFFFFF);
  HSR(,0x51000018, ,0xFFFFFFFF);
  HSR(,0x5100001C, ,0xFFFFFFFF);

  C("Perform halfword write to the dynamic memory");
  HSA(0x51020000, NSEQ, INCR, OK, HWRD);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x51020000, NSEQ, INCR8, OK, WRD);
  HSR(,0x51023333, ,0xFFFFFFFF);
  HSR(,0x51020004, ,0xFFFFFFFF);
  HSR(,0x51020008, ,0xFFFFFFFF);
  HSR(,0x5102000C, ,0xFFFFFFFF);
  HSR(,0x51020010, ,0xFFFFFFFF);
  HSR(,0x51020014, ,0xFFFFFFFF);
  HSR(,0x51020018, ,0xFFFFFFFF);
  HSR(,0x5102001C, ,0xFFFFFFFF);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x51030004, NSEQ, INCR, OK, HWRD);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x51030004, NSEQ, INCR8, OK, WRD);
  HSR(,0x51033333, ,0xFFFFFFFF);
  HSR(,0x51030008, ,0xFFFFFFFF);
  HSR(,0x5103000C, ,0xFFFFFFFF);
  HSR(,0x51030010, ,0xFFFFFFFF);
  HSR(,0x51030014, ,0xFFFFFFFF);
  HSR(,0x51030018, ,0xFFFFFFFF);
  HSR(,0x5103001C, ,0xFFFFFFFF);
  HSR(,0x51030020, ,0xFFFFFFFF);

  C("Perform halfword write to the dynamic memory to the aligned address");
  HSA(0x51040000, NSEQ, INCR, OK, HWRD);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x51040000, NSEQ, INCR, OK, WRD);
  HSR(,0x51043333, ,0xFFFFFFFF);
  HSR(,0x51040004, ,0xFFFFFFFF);
  HSR(,0x51040008, ,0xFFFFFFFF);
  HSR(,0x5104000C, ,0xFFFFFFFF);
  HSR(,0x51040010, ,0xFFFFFFFF);
  HSR(,0x51040014, ,0xFFFFFFFF);
  HSR(,0x51040018, ,0xFFFFFFFF);
  HSR(,0x5104001C, ,0xFFFFFFFF);

  C("Perform Byte write to the dynamic memory to the aligned address");
  HSA(0x51070000, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x51070000, NSEQ, INCR8, OK, WRD);
  HSR(,0x51070033, ,0xFFFFFFFF);
  HSR(,0x51070004, ,0xFFFFFFFF);
  HSR(,0x51070008, ,0xFFFFFFFF);
  HSR(,0x5107000C, ,0xFFFFFFFF);
  HSR(,0x51070010, ,0xFFFFFFFF);
  HSR(,0x51070014, ,0xFFFFFFFF);
  HSR(,0x51070018, ,0xFFFFFFFF);
  HSR(,0x5107001C, ,0xFFFFFFFF);

  C("Perform WORD write to the dynamic memory to the aligned address");
  HSA(0x51070000, NSEQ, INCR, OK, WRD);
  HSW(,0x66666666);
  HSA(0x51070004, NSEQ, INCR, OK, WRD);
  HSW(,0x66666666);
  C("Perform byte read from the dynamic memory");
  HSA(0x51070000, NSEQ, INCR8, OK, BYTE);
  HSR(,0x00000066, ,0x000000FF);
  HSR(,0x00006600, ,0x0000FF00);
  HSR(,0x00660000, ,0x00FF0000);
  HSR(,0x66000000, ,0xFF000000);
  HSR(,0x00000066, ,0x000000FF);
  HSR(,0x00006600, ,0x0000FF00);
  HSR(,0x00660000, ,0x00FF0000);
  HSR(,0x66000000, ,0xFF000000);

  C("Perform WORD write to the dynamic memory to the aligned address");
  HSA(0x51070000, NSEQ, INCR, OK, WRD);
  HSW(,0x77777777);
  HSA(0x51070004, NSEQ, INCR, OK, WRD);
  HSW(,0x77777777);
  C("Perform byte read from the dynamic memory");
  HSA(0x51070000, NSEQ, INCR4, OK, HWRD);
  HSR(,0x00007777, ,0x0000FFFF);
  HSR(,0x77770000, ,0xFFFF0000);
  HSR(,0x00007777, ,0x0000FFFF);
  HSR(,0x77770000, ,0xFFFF0000);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x51060008, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x51060008, NSEQ, INCR8, OK, WRD);
  HSR(,0x51060033, ,0xFFFFFFFF);
  HSR(,0x5106000C, ,0xFFFFFFFF);
  HSR(,0x51060010, ,0xFFFFFFFF);
  HSR(,0x51060014, ,0xFFFFFFFF);
  HSR(,0x51060018, ,0xFFFFFFFF);
  HSR(,0x5106001C, ,0xFFFFFFFF);
  HSR(,0x51060020, ,0xFFFFFFFF);
  HSR(,0x51060024, ,0xFFFFFFFF);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x5106010C, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x5106010C, NSEQ, INCR8, OK, WRD);
  HSR(,0x51060133, ,0xFFFFFFFF);
  HSR(,0x51060110, ,0xFFFFFFFF);
  HSR(,0x51060114, ,0xFFFFFFFF);
  HSR(,0x51060118, ,0xFFFFFFFF);
  HSR(,0x5106011C, ,0xFFFFFFFF);
  HSR(,0x51060120, ,0xFFFFFFFF);
  HSR(,0x51060124, ,0xFFFFFFFF);
  HSR(,0x51060128, ,0xFFFFFFFF);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x5106020E, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x5106020C, NSEQ, INCR8, OK, WRD);
  HSR(,0x5133020C, ,0xFFFFFFFF);
  HSR(,0x51060210, ,0xFFFFFFFF);
  HSR(,0x51060214, ,0xFFFFFFFF);
  HSR(,0x51060218, ,0xFFFFFFFF);
  HSR(,0x5106021C, ,0xFFFFFFFF);
  HSR(,0x51060220, ,0xFFFFFFFF);
  HSR(,0x51060224, ,0xFFFFFFFF);
  HSR(,0x51060228, ,0xFFFFFFFF);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x5106030D, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x5106030C, NSEQ, INCR8, OK, WRD);
  HSR(,0x5106330C, ,0xFFFFFFFF);
  HSR(,0x51060310, ,0xFFFFFFFF);
  HSR(,0x51060314, ,0xFFFFFFFF);
  HSR(,0x51060318, ,0xFFFFFFFF);
  HSR(,0x5106031C, ,0xFFFFFFFF);
  HSR(,0x51060320, ,0xFFFFFFFF);
  HSR(,0x51060324, ,0xFFFFFFFF);
  HSR(,0x51060328, ,0xFFFFFFFF);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x5106040F, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x5106040C, NSEQ, INCR8, OK, WRD);
  HSR(,0x3306040C, ,0xFFFFFFFF);
  HSR(,0x51060410, ,0xFFFFFFFF);
  HSR(,0x51060414, ,0xFFFFFFFF);
  HSR(,0x51060418, ,0xFFFFFFFF);
  HSR(,0x5106041C, ,0xFFFFFFFF);
  HSR(,0x51060420, ,0xFFFFFFFF);
  HSR(,0x51060424, ,0xFFFFFFFF);
  HSR(,0x51060428, ,0xFFFFFFFF);


  C("Following cases read the data with INCR16");
  C("Perform byte write to the dynamic memory");
  HSA(0x52100000, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  
  C("Perform byte read from the dynamic memory");
  HSA(0x52100000, NSEQ, INCR16, OK, WRD);
  HSR(,0x52100033, ,0xFFFFFFFF);
  HSR(,0x52100004, ,0xFFFFFFFF);
  HSR(,0x52100008, ,0xFFFFFFFF);
  HSR(,0x5210000C, ,0xFFFFFFFF);
  HSR(,0x52100010, ,0xFFFFFFFF);
  HSR(,0x52100014, ,0xFFFFFFFF);
  HSR(,0x52100018, ,0xFFFFFFFF);
  HSR(,0x5210001C, ,0xFFFFFFFF);
  HSR(,0x52100020, ,0xFFFFFFFF);
  HSR(,0x52100024, ,0xFFFFFFFF);
  HSR(,0x52100028, ,0xFFFFFFFF);
  HSR(,0x5210002C, ,0xFFFFFFFF);
  HSR(,0x52100030, ,0xFFFFFFFF);
  HSR(,0x52100034, ,0xFFFFFFFF);
  HSR(,0x52100038, ,0xFFFFFFFF);
  HSR(,0x5210003C, ,0xFFFFFFFF);

  C("Perform halfword write to the dynamic memory");
  HSA(0x52120000, NSEQ, INCR, OK, HWRD);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x52120000, NSEQ, INCR16, OK, WRD);
  HSR(,0x52123333, ,0xFFFFFFFF);
  HSR(,0x52120004, ,0xFFFFFFFF);
  HSR(,0x52120008, ,0xFFFFFFFF);
  HSR(,0x5212000C, ,0xFFFFFFFF);
  HSR(,0x52120010, ,0xFFFFFFFF);
  HSR(,0x52120014, ,0xFFFFFFFF);
  HSR(,0x52120018, ,0xFFFFFFFF);
  HSR(,0x5212001C, ,0xFFFFFFFF);
  HSR(,0x52120020, ,0xFFFFFFFF);
  HSR(,0x52120024, ,0xFFFFFFFF);
  HSR(,0x52120028, ,0xFFFFFFFF);
  HSR(,0x5212002C, ,0xFFFFFFFF);
  HSR(,0x52120030, ,0xFFFFFFFF);
  HSR(,0x52120034, ,0xFFFFFFFF);
  HSR(,0x52120038, ,0xFFFFFFFF);
  HSR(,0x5212003C, ,0xFFFFFFFF);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x52130004, NSEQ, INCR, OK, HWRD);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x52130004, NSEQ, INCR16, OK, WRD);
  HSR(,0x52133333, ,0xFFFFFFFF);
  HSR(,0x52130008, ,0xFFFFFFFF);
  HSR(,0x5213000C, ,0xFFFFFFFF);
  HSR(,0x52130010, ,0xFFFFFFFF);
  HSR(,0x52130014, ,0xFFFFFFFF);
  HSR(,0x52130018, ,0xFFFFFFFF);
  HSR(,0x5213001C, ,0xFFFFFFFF);
  HSR(,0x52130020, ,0xFFFFFFFF);
  HSR(,0x52130024, ,0xFFFFFFFF);
  HSR(,0x52130028, ,0xFFFFFFFF);
  HSR(,0x5213002C, ,0xFFFFFFFF);
  HSR(,0x52130030, ,0xFFFFFFFF);
  HSR(,0x52130034, ,0xFFFFFFFF);
  HSR(,0x52130038, ,0xFFFFFFFF);
  HSR(,0x5213003C, ,0xFFFFFFFF);
  HSR(,0x52130040, ,0xFFFFFFFF);

  C("Perform halfword write to the dynamic memory to the aligned address");
  HSA(0x52140000, NSEQ, INCR, OK, HWRD);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x52140000, NSEQ, INCR, OK, WRD);
  HSR(,0x52143333, ,0xFFFFFFFF);
  HSR(,0x52140004, ,0xFFFFFFFF);
  HSR(,0x52140008, ,0xFFFFFFFF);
  HSR(,0x5214000C, ,0xFFFFFFFF);
  HSR(,0x52140010, ,0xFFFFFFFF);
  HSR(,0x52140014, ,0xFFFFFFFF);
  HSR(,0x52140018, ,0xFFFFFFFF);
  HSR(,0x5214001C, ,0xFFFFFFFF);
  HSR(,0x52140020, ,0xFFFFFFFF);
  HSR(,0x52140024, ,0xFFFFFFFF);
  HSR(,0x52140028, ,0xFFFFFFFF);
  HSR(,0x5214002C, ,0xFFFFFFFF);
  HSR(,0x52140030, ,0xFFFFFFFF);
  HSR(,0x52140034, ,0xFFFFFFFF);
  HSR(,0x52140038, ,0xFFFFFFFF);
  HSR(,0x5214003C, ,0xFFFFFFFF);

  C("Perform Byte write to the dynamic memory to the aligned address");
  HSA(0x52170000, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x52170000, NSEQ, INCR16, OK, WRD);
  HSR(,0x52170033, ,0xFFFFFFFF);
  HSR(,0x52170004, ,0xFFFFFFFF);
  HSR(,0x52170008, ,0xFFFFFFFF);
  HSR(,0x5217000C, ,0xFFFFFFFF);
  HSR(,0x52170010, ,0xFFFFFFFF);
  HSR(,0x52170014, ,0xFFFFFFFF);
  HSR(,0x52170018, ,0xFFFFFFFF);
  HSR(,0x5217001C, ,0xFFFFFFFF);
  HSR(,0x52170020, ,0xFFFFFFFF);
  HSR(,0x52170024, ,0xFFFFFFFF);
  HSR(,0x52170028, ,0xFFFFFFFF);
  HSR(,0x5217002C, ,0xFFFFFFFF);
  HSR(,0x52170030, ,0xFFFFFFFF);
  HSR(,0x52170034, ,0xFFFFFFFF);
  HSR(,0x52170038, ,0xFFFFFFFF);
  HSR(,0x5217003C, ,0xFFFFFFFF);

  C("Perform WORD write to the dynamic memory to the aligned address");
  HSA(0x52170000, NSEQ, INCR, OK, WRD);
  HSW(,0x66666666);
  HSA(0x52170004, NSEQ, INCR, OK, WRD);
  HSW(,0x66666666);
  HSA(0x52170008, NSEQ, INCR, OK, WRD);
  HSW(,0x66666666);
  HSA(0x5217000C, NSEQ, INCR, OK, WRD);
  HSW(,0x66666666);
  C("Perform byte read from the dynamic memory");
  HSA(0x52170000, NSEQ, INCR16, OK, BYTE);
  HSR(,0x00000066, ,0x000000FF);
  HSR(,0x00006600, ,0x0000FF00);
  HSR(,0x00660000, ,0x00FF0000);
  HSR(,0x66000000, ,0xFF000000);
  HSR(,0x00000066, ,0x000000FF);
  HSR(,0x00006600, ,0x0000FF00);
  HSR(,0x00660000, ,0x00FF0000);
  HSR(,0x66000000, ,0xFF000000);
  HSR(,0x00000066, ,0x000000FF);
  HSR(,0x00006600, ,0x0000FF00);
  HSR(,0x00660000, ,0x00FF0000);
  HSR(,0x66000000, ,0xFF000000);
  HSR(,0x00000066, ,0x000000FF);
  HSR(,0x00006600, ,0x0000FF00);
  HSR(,0x00660000, ,0x00FF0000);
  HSR(,0x66000000, ,0xFF000000);

  C("Perform WORD write to the dynamic memory to the aligned address");
  HSA(0x52170000, NSEQ, INCR, OK, WRD);
  HSW(,0x77777777);
  HSA(0x52170004, NSEQ, INCR, OK, WRD);
  HSW(,0x77777777);
  HSA(0x52170008, NSEQ, INCR, OK, WRD);
  HSW(,0x77777777);
  HSA(0x5217000C, NSEQ, INCR, OK, WRD);
  HSW(,0x77777777);
  C("Perform byte read from the dynamic memory");
  HSA(0x52170000, NSEQ, INCR8, OK, HWRD);
  HSR(,0x00007777, ,0x0000FFFF);
  HSR(,0x77770000, ,0xFFFF0000);
  HSR(,0x00007777, ,0x0000FFFF);
  HSR(,0x77770000, ,0xFFFF0000);
  HSR(,0x00007777, ,0x0000FFFF);
  HSR(,0x77770000, ,0xFFFF0000);
  HSR(,0x00007777, ,0x0000FFFF);
  HSR(,0x77770000, ,0xFFFF0000);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x52160008, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x52160008, NSEQ, INCR16, OK, WRD);
  HSR(,0x52160033, ,0xFFFFFFFF);
  HSR(,0x5216000C, ,0xFFFFFFFF);
  HSR(,0x52160010, ,0xFFFFFFFF);
  HSR(,0x52160014, ,0xFFFFFFFF);
  HSR(,0x52160018, ,0xFFFFFFFF);
  HSR(,0x5216001C, ,0xFFFFFFFF);
  HSR(,0x52160020, ,0xFFFFFFFF);
  HSR(,0x52160024, ,0xFFFFFFFF);
  HSR(,0x52160028, ,0xFFFFFFFF);
  HSR(,0x5216002C, ,0xFFFFFFFF);
  HSR(,0x52160030, ,0xFFFFFFFF);
  HSR(,0x52160034, ,0xFFFFFFFF);
  HSR(,0x52160038, ,0xFFFFFFFF);
  HSR(,0x5216003C, ,0xFFFFFFFF);
  HSR(,0x52160040, ,0xFFFFFFFF);
  HSR(,0x52160044, ,0xFFFFFFFF);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x5216010C, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x5216010C, NSEQ, INCR16, OK, WRD);
  HSR(,0x52160133, ,0xFFFFFFFF);
  HSR(,0x52160110, ,0xFFFFFFFF);
  HSR(,0x52160114, ,0xFFFFFFFF);
  HSR(,0x52160118, ,0xFFFFFFFF);
  HSR(,0x5216011C, ,0xFFFFFFFF);
  HSR(,0x52160120, ,0xFFFFFFFF);
  HSR(,0x52160124, ,0xFFFFFFFF);
  HSR(,0x52160128, ,0xFFFFFFFF);
  HSR(,0x5216012C, ,0xFFFFFFFF);
  HSR(,0x52160130, ,0xFFFFFFFF);
  HSR(,0x52160134, ,0xFFFFFFFF);
  HSR(,0x52160138, ,0xFFFFFFFF);
  HSR(,0x5216013C, ,0xFFFFFFFF);
  HSR(,0x52160140, ,0xFFFFFFFF);
  HSR(,0x52160144, ,0xFFFFFFFF);
  HSR(,0x52160148, ,0xFFFFFFFF);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x5216020E, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x5216020C, NSEQ, INCR16, OK, WRD);
  HSR(,0x5233020C, ,0xFFFFFFFF);
  HSR(,0x52160210, ,0xFFFFFFFF);
  HSR(,0x52160214, ,0xFFFFFFFF);
  HSR(,0x52160218, ,0xFFFFFFFF);
  HSR(,0x5216021C, ,0xFFFFFFFF);
  HSR(,0x52160220, ,0xFFFFFFFF);
  HSR(,0x52160224, ,0xFFFFFFFF);
  HSR(,0x52160228, ,0xFFFFFFFF);
  HSR(,0x5216022C, ,0xFFFFFFFF);
  HSR(,0x52160230, ,0xFFFFFFFF);
  HSR(,0x52160234, ,0xFFFFFFFF);
  HSR(,0x52160238, ,0xFFFFFFFF);
  HSR(,0x5216023C, ,0xFFFFFFFF);
  HSR(,0x52160240, ,0xFFFFFFFF);
  HSR(,0x52160244, ,0xFFFFFFFF);
  HSR(,0x52160248, ,0xFFFFFFFF);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x5216030D, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x5216030C, NSEQ, INCR16, OK, WRD);
  HSR(,0x5216330C, ,0xFFFFFFFF);
  HSR(,0x52160310, ,0xFFFFFFFF);
  HSR(,0x52160314, ,0xFFFFFFFF);
  HSR(,0x52160318, ,0xFFFFFFFF);
  HSR(,0x5216031C, ,0xFFFFFFFF);
  HSR(,0x52160320, ,0xFFFFFFFF);
  HSR(,0x52160324, ,0xFFFFFFFF);
  HSR(,0x52160328, ,0xFFFFFFFF);
  HSR(,0x5216032C, ,0xFFFFFFFF);
  HSR(,0x52160330, ,0xFFFFFFFF);
  HSR(,0x52160334, ,0xFFFFFFFF);
  HSR(,0x52160338, ,0xFFFFFFFF);
  HSR(,0x5216033C, ,0xFFFFFFFF);
  HSR(,0x52160340, ,0xFFFFFFFF);
  HSR(,0x52160344, ,0xFFFFFFFF);
  HSR(,0x52160348, ,0xFFFFFFFF);

  C("Perform halfword write to the dynamic memory to the unaligned address");
  HSA(0x5216040F, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  C("Perform byte read from the dynamic memory");
  HSA(0x5216040C, NSEQ, INCR16, OK, WRD);
  HSR(,0x3316040C, ,0xFFFFFFFF);
  HSR(,0x52160410, ,0xFFFFFFFF);
  HSR(,0x52160414, ,0xFFFFFFFF);
  HSR(,0x52160418, ,0xFFFFFFFF);
  HSR(,0x5216041C, ,0xFFFFFFFF);
  HSR(,0x52160420, ,0xFFFFFFFF);
  HSR(,0x52160424, ,0xFFFFFFFF);
  HSR(,0x52160428, ,0xFFFFFFFF);
  HSR(,0x5216042C, ,0xFFFFFFFF);
  HSR(,0x52160430, ,0xFFFFFFFF);
  HSR(,0x52160434, ,0xFFFFFFFF);
  HSR(,0x52160438, ,0xFFFFFFFF);
  HSR(,0x5216043C, ,0xFFFFFFFF);
  HSR(,0x52160440, ,0xFFFFFFFF);
  HSR(,0x52160444, ,0xFFFFFFFF);
  HSR(,0x52160448, ,0xFFFFFFFF);

  
  C("Transfer type: NS-B-S to the same bank");
  addr1 = MEM0_BASE + 0x1E1;
  HSA(addr1, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  HSA(addr1 + 1, BUSY, INCR, OK, BYTE);
  HSW(,0xAAAAAAAA);
  HSA(addr1 + 1, SEQ, INCR, OK, BYTE);
  HSW(,0x22222222);

  HSA(addr1, NSEQ, INCR, OK, BYTE);
  HSR(,0x33333333,0x000000FF);
  HSA(addr1 + 1, SEQ, INCR, OK, BYTE);
  HSR(,0x22222222,0x0000FF00);

  C("Transfer type: NS-B-S to the dynamic memory");
  addr1 = 0x40000001;
  HSA(addr1, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  HSA(addr1 + 1, BUSY, INCR, OK, BYTE);
  HSW(,0xAAAAAAAA);
  HSA(addr1 + 1, SEQ, INCR, OK, BYTE);
  HSW(,0x22222222);

  HSA(addr1, NSEQ, INCR, OK, BYTE);
  HSR(,0x33333333,0x000000FF);
  HSA(addr1 + 1, SEQ, INCR, OK, BYTE);
  HSR(,0x22222222,0x0000FF00);

  C("Transfer type: NS-B-S to the same bank");
  addr1 = MEM0_BASE + 0x1AC;
  HSA(addr1, NSEQ, INCR, OK, HWRD);
  HSW(,0x33333333);
  HSA(addr1 + 2, BUSY, INCR, OK, HWRD);
  HSW(,0xAAAAAAAA);
  HSA(addr1 + 2, SEQ, INCR, OK, HWRD);
  HSW(,0x22222222);

  HSA(addr1, NSEQ, INCR, OK, HWRD);
  HSR(,0x33333333,0x0000FFFF);
  HSA(addr1 + 2, SEQ, INCR, OK, HWRD);
  HSR(,0x22222222,0xFFFF0000);

  C("Transfer type: NS-B-S to the same bank to dynamic  memory ");
  addr1 = 0x500001AC;
  HSA(addr1, NSEQ, INCR, OK, HWRD);
  HSW(,0x33333333);
  HSA(addr1 + 2, BUSY, INCR, OK, HWRD);
  HSW(,0xAAAAAAAA);
  HSA(addr1 + 2, SEQ, INCR, OK, HWRD);
  HSW(,0x22222222);

  HSA(addr1, NSEQ, INCR, OK, HWRD);
  HSR(,0x33333333,0x0000FFFF);
  HSA(addr1 + 2, SEQ, INCR, OK, HWRD);
  HSR(,0x22222222,0xFFFF0000);

  /** Write data to memory with transfer type as :NS-I-NS **/
  C("Transfer type: NS-I-NS to the same bank");
  TestData = 0x0000000C;
  AHBWriteMem(1, 0x120, 6, TestData);
  addr1 = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x12C;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x55555555);
  addr1 = addr1 + 4;
  HSA(addr1, IDLE, INCR, OK, WRD);
  HSW(,0x33333333);
  addr1 = addr1 + 4;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x44444444);

  /** Read the data back **/
  addr1 = addr1 - 8;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x55555555, ,MaskALL, ,TransferTest_1);
  addr1 = addr1 + 4;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x00000010, ,MaskALL, ,TransferTest_2);
  addr1 = addr1 + 4;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x44444444, ,MaskALL, ,TransferTest_3);

  /** Write data to memory with transfer type as :NS-I-NS **/
  C("Transfer type: NS-I-NS to the same bank to dynamic memory");
  TestData = 0x0000000C;
  addr1 = 0x6000012C;
  HSA(addr1+4, NSEQ, INCR, OK, WRD);
  HSW(,0x11111111);
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x55555555);
  addr1 = addr1 + 4;
  HSA(addr1, IDLE, INCR, OK, WRD);
  HSW(,0x33333333);
  addr1 = addr1 + 4;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x44444444);

  /** Read the data back **/
  addr1 = addr1 - 8;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x55555555, ,MaskALL, ,TransferTest_1);
  addr1 = addr1 + 4;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x11111111, ,MaskALL, ,TransferTest_2);
  addr1 = addr1 + 4;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x44444444, ,MaskALL, ,TransferTest_3);

  /* Write operation to the address where IDLE cycle is going to be applied */
  addr1 = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x010;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x22222222);

  C("Perform write operation with INCR4 and insert IDLE operation");
  addr1 = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x004;
  HSA(addr1, NSEQ, INCR4, OK, WRD);
  HSW(,0xAAAAAAAA);
  for(i = 0; i < 2; i++)
    HSW(,0xBBBBBBBB);
  addr1 = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x010;
  debug_info("Insert IDLE cycle at quad word boundary");
  HSA(addr1, IDLE, INCR, OK, WRD);
  HSW(,0x33333333);
 
  addr1 = addr1 + 4;
  HSA(addr1, NSEQ, INCR4, OK, WRD);
  HSW(,0xCCCCCCCC);

  /** Read the data back **/
  addr1 = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x004;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0xAAAAAAAA, ,MaskALL, ,TransferTest_4);
  for(i = 0; i < 2; i++)
    HSR(,0xBBBBBBBB, ,MaskALL, ,TransferTest_5);
  addr1 = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x010;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x22222222, ,MaskALL, ,TransferTest_6);
  addr1 = addr1 + 4;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0xCCCCCCCC, ,MaskALL, ,TransferTest_7);

  C("Perform write operation with INCR4 and insert IDLE operation");
  addr1 = 0x40000004;
  HSA(addr1, NSEQ, INCR4, OK, WRD);
  HSW(,0xAAAAAAAA);
  for(i = 0; i < 2; i++)
    HSW(,0xBBBBBBBB);
  addr1 = 0x40000010;
  debug_info("Insert IDLE cycle at quad word boundary to dynamic memory");
  HSA(addr1, IDLE, INCR, OK, WRD);
  HSW(,0x33333333);

  addr1 = addr1 + 4;
  HSA(addr1, NSEQ, INCR4, OK, WRD);
  HSW(,0xCCCCCCCC);

  /** Read the data back **/
  addr1 = 0x40000004;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0xAAAAAAAA, ,MaskALL, ,TransferTest_4);
  for(i = 0; i < 2; i++)
    HSR(,0xBBBBBBBB, ,MaskALL, ,TransferTest_5);
  addr1 = 0x40000010;
  addr1 = addr1 + 4;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0xCCCCCCCC, ,MaskALL, ,TransferTest_7);

  /** Write data to memory with transfer type as :NS-B-S **/ 
  C("Transfer type: NS-B-S");
  addr1 = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x014;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x55555555);
  addr1 = addr1 + 4;
  HSA(addr1, BUSY, INCR, OK, WRD);
  HSW(,0x33333333);
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x44444444); 

  /** Read the data back **/
  addr1 = addr1 - 4;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x55555555, ,MaskALL, ,TransferTest_8);
  HSR(,0x44444444, ,MaskALL, ,TransferTest_9);

  /** Write data to memory with transfer type as :NS-B-S **/
  C("Transfer type: NS-B-S to dynamic memory");
  addr1 = 0x50000014;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x55555555);
  addr1 = addr1 + 4;
  HSA(addr1, BUSY, INCR, OK, WRD);
  HSW(,0x33333333);
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x44444444);

  /** Read the data back **/
  addr1 = addr1 - 4;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x55555555, ,MaskALL, ,TransferTest_8);
  HSR(,0x44444444, ,MaskALL, ,TransferTest_9);

  /** Write data to memory with transfer type as :NS-B-S **/
  C("Trans type:NS-B-S where BUSY is inserted at quadword boundary");
  TestData = 0x0000FFFF;
  addr1 = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x01C;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x55555555);
  addr1 = addr1 + 4;
  HSA(addr1, BUSY, INCR, OK, WRD);
  HSW(,0x33333333);
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x44444444); 

  /** Read the data back **/
  addr1 = addr1 - 4;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x55555555, ,MaskALL, ,TransferTest_10);
  HSR(,0x44444444, ,MaskALL, ,TransferTest_11);

  /** Write data to memory with transfer type as :NS-B-NS **/
  C("Trans type:NS-S-S-B-NS where BUSY is applied at quadword cross");
  addr1 = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x034;
  TestData = 0x00000000;
  AHBWriteMem(1, 0x034, 4, TestData);
  HSA(addr1, NSEQ, INCR4, OK, WRD);
  HSW(,0x55555555);
  for(i = 0; i < 2; i++)
   HSW(,0x66666666); 
  addr1 = addr1 + 0xC;
  HSA(addr1, BUSY, INCR4, OK, WRD);
  HSW(,0x11111111);
  HSA(addr1, NSEQ, INCR4, OK, WRD);
  HSW(,0xBBBBBBBB);
  /* Read the data back */
  C("Read data back");
  addr1 = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x034;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x55555555, ,MaskALL, ,TransferTest_12);
  for(i = 0; i < 2; i++)
   HSR(,0x66666666, ,MaskALL, ,TransferTest_13); 
  addr1 = addr1 + 0xC;
  HSA(addr1, NSEQ, INCR4, OK, WRD);
  HSR(,0xBBBBBBBB, ,MaskALL, ,TransferTest_14); 

  C("Trans type:NS-S-S-B-NS where BUSY is applied at quadword cross");
  addr1 = 0x50000034;
  TestData = 0x00000000;
  HSA(addr1, NSEQ, INCR4, OK, WRD);
  HSW(,0x55555555);
  for(i = 0; i < 2; i++)
   HSW(,0x66666666);
  addr1 = addr1 + 0xC;
  HSA(addr1, BUSY, INCR4, OK, WRD);
  HSW(,0x11111111);
  HSA(addr1, NSEQ, INCR4, OK, WRD);
  HSW(,0xBBBBBBBB);
  /* Read the data back */
  C("Read data back");
  addr1 = 0x50000034;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x55555555, ,MaskALL, ,TransferTest_12);
  for(i = 0; i < 2; i++)
   HSR(,0x66666666, ,MaskALL, ,TransferTest_13);
  addr1 = addr1 + 0xC;
  HSA(addr1, NSEQ, INCR4, OK, WRD);
  HSR(,0xBBBBBBBB, ,MaskALL, ,TransferTest_14);

  /** Write data to memory with transfer type as :NS-B-I-NS **/ 
  C("Transfer type: NS-B-I-NS");
  addr1 = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + 0x038;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x23232323);
  HSA(addr1 + 4, BUSY, INCR, OK, WRD);
  HSW(,0x11111111);
  HSA(addr1 + 4, IDLE, INCR, OK, WRD);
  HSW(,0x44444444);
  HSA(addr1 + 8, NSEQ, INCR, OK, WRD);
  HSW(,0x56565656);

  /** Read the data back **/
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x23232323, ,MaskALL, ,TransferTest_15);
  HSR(,0x66666666, ,MaskALL, ,TransferTest_16);
  HSR(,0x56565656, ,MaskALL, ,TransferTest_17);

  C("Transfer type: NS-B-I-NS to dynamic memory");
  addr1 = 0x60000038;
  HSA(addr1+4, NSEQ, INCR, OK, WRD);
  HSW(,0x66666666);
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x23232323);
  HSA(addr1 + 4, BUSY, INCR, OK, WRD);
  HSW(,0x11111111);
  HSA(addr1 + 4, IDLE, INCR, OK, WRD);
  HSW(,0x44444444);
  HSA(addr1 + 8, NSEQ, INCR, OK, WRD);
  HSW(,0x56565656);

  /** Read the data back **/
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x23232323, ,MaskALL, ,TransferTest_15);
  HSR(,0x66666666, ,MaskALL, ,TransferTest_16);
  HSR(,0x56565656, ,MaskALL, ,TransferTest_17);

  /** Write data to memory with transfer type as :NS-B-I-NS **/
  C("Transfer type: NS-B-I-NS with burst as WRAP4");

  addr1 =  MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x7D4;
  TestData = 0x00000002;
  AHBWriteMem(0, 0x7E0, 2, TestData);
  AHBWriteMem(0, 0x7D0, 6, 0x22222222);
  AHBWriteMem(1, 0x000, 2, 0x00000004);
  HSA(addr1, NSEQ, WRAP4, OK, WRD);
  HSW(,0xCCCCCCCC);
  for(i = 0; i < 2; i++)
   HSW(,0xDDDDDDDD);
  addr1 = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x7D0;
  HSA(addr1, BUSY, WRAP4, OK, WRD);
  HSW(,0xCCAACCAA);
  
  HSA(addr1, IDLE, WRAP4, OK, WRD);
  HSW(,0x11111111); 
  addr1 = addr1 =  MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x7E0;
  HSA(addr1, NSEQ, WRAP4, OK, WRD);
  HSW(,0x22222222);

  /** Read the data back **/
  addr1 =  MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x7D4;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0xCCCCCCCC, ,MaskALL, ,TransferTest_18);
  HSR(,0xDDDDDDDD, ,MaskALL, ,TransferTest_19);
  HSR(,0xDDDDDDDD, ,MaskALL, ,TransferTest_20);
  HSR(,0x22222222, ,MaskALL, ,TransferTest_21);
  HSA(0x000007D0, NSEQ, INCR, OK, WRD);
  HSR(,0x22222222, , MaskALL, ,TransferTest_22);
  /** Write data to memory with transfer type as :NS-S-B-S **/
  C("Transfer type: NS-S-B-S to the same bank");
  addr1 =  MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x7DC;
  TestData = 0x00000004;
  AHBWriteMem(0, 0x7E0, 8, TestData);
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x22222222);
  HSW(,0x11111111);
  HSA(addr1 + 8, BUSY, INCR, OK, WRD);
  HSW(,0xCCCCCCCC);
  HSA(addr1 + 8, SEQ, INCR, OK, WRD);
  HSW(,0xAAAAAAAA);

  /** Read the data back **/
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x22222222, ,MaskALL, ,TransferTest_23);
  HSR(,0x11111111, ,MaskALL, ,TransferTest_24);
  HSR(,0xAAAAAAAA, ,MaskALL, ,TransferTest_25);

  C("Transfer type: NS-S-B-S to dynamic memory");
  addr1 =  0x600007DC;
  TestData = 0x00000004;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x22222222);
  HSW(,0x11111111);
  HSA(addr1 + 8, BUSY, INCR, OK, WRD);
  HSW(,0xCCCCCCCC);
  HSA(addr1 + 8, SEQ, INCR, OK, WRD);
  HSW(,0xAAAAAAAA);

  /** Read the data back **/
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x22222222, ,MaskALL, ,TransferTest_23);
  HSR(,0x11111111, ,MaskALL, ,TransferTest_24);
  HSR(,0xAAAAAAAA, ,MaskALL, ,TransferTest_25);

  /** Write data to memory with transfer type as :NS-S-B-S **/
  C("Transfer type: NS-S-B-S without quad word cross");
  addr1 =  MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x7D0;
  TestData = 0x00000004;
  HSA(addr1, NSEQ, INCR8, OK, WRD);
  HSW(,0x22222222);
  HSW(,0x11111111);
  HSA(addr1 + 8, BUSY, INCR8, OK, WRD);
  HSW(,0xCCCCCCCC);
  HSA(addr1 + 8, SEQ, INCR8, OK, WRD);
  HSW(,0xAAAAAAAA);

  /** Read the data back **/
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x22222222, ,MaskALL, ,TransferTest_26);
  HSR(,0x11111111, ,MaskALL, ,TransferTest_27);
  HSR(,0xAAAAAAAA, ,MaskALL, ,TransferTest_29);

  C("Transfer type: NS-S-B-S without quad word cross to dynamic memory");
  addr1 =  0x700007D0;
  TestData = 0x00000004;
  HSA(addr1, NSEQ, INCR8, OK, WRD);
  HSW(,0x22222222);
  HSW(,0x11111111);
  HSA(addr1 + 8, BUSY, INCR8, OK, WRD);
  HSW(,0xCCCCCCCC);
  HSA(addr1 + 8, SEQ, INCR8, OK, WRD);
  HSW(,0xAAAAAAAA);

  /** Read the data back **/
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x22222222, ,MaskALL, ,TransferTest_26);
  HSR(,0x11111111, ,MaskALL, ,TransferTest_27);
  HSR(,0xAAAAAAAA, ,MaskALL, ,TransferTest_29);

  /** Write data to memory with transfer type as :NS-S-B-S **/
  C("Trans type : NS-S-B-S: BUSY is inserted before quadword cross");
  addr1 =  MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x1C4;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x22222222);
  HSW(,0x11111111);
  HSA(addr1 + 8, BUSY, INCR, OK, WRD);
  HSW(,0xCCCCCCCC);
  HSA(addr1 + 8, SEQ, INCR, OK, WRD);
  HSW(,0xAAAAAAAA);

  /** Read the data back **/
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x22222222, ,MaskALL, ,TransferTest_30);
  HSR(,0x11111111, ,MaskALL, ,TransferTest_31);
  HSR(,0xAAAAAAAA, ,MaskALL, ,TransferTest_32);

  /** Write data to memory with transfer type as :NS-B-S-B-S **/
  C("Transfer type: NS-B-S-B-S to the same bank");
  HSA(addr1, NSEQ, INCR, OK, WRD); 
  HSW(,0x22222222);
  HSA(addr1 + 4, BUSY, INCR, OK, WRD); 
  HSW(,0x55555555);
  HSA(addr1 + 4, SEQ, INCR, OK, WRD);
  HSW(,0x00000000);
  HSA(addr1 + 8, BUSY, INCR, OK, WRD);
  HSW(,0x33333333);
  HSA(addr1 + 8, SEQ, INCR, OK, WRD);
  HSW(,0xCCCCCCCC);

  /** Read the data back **/
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x22222222, ,MaskALL, ,TransferTest_33);
  HSR(,0x00000000, ,MaskALL, ,TransferTest_34);
  HSR(,0xCCCCCCCC, ,MaskALL, ,TransferTest_35);

  /** Write data to memory with transfer type as :NS-B-S-B-S **/
  C("Transfer type: NS-B-S-B-S to the dynamic memory");
  addr1 = 0x50000348;
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSW(,0x22222222);
  HSA(addr1 + 4, BUSY, INCR, OK, WRD);
  HSW(,0x55555555);
  HSA(addr1 + 4, SEQ, INCR, OK, WRD);
  HSW(,0x00000000);
  HSA(addr1 + 8, BUSY, INCR, OK, WRD);
  HSW(,0x33333333);
  HSA(addr1 + 8, SEQ, INCR, OK, WRD);
  HSW(,0xCCCCCCCC);

  /** Read the data back **/
  HSA(addr1, NSEQ, INCR, OK, WRD);
  HSR(,0x22222222, ,MaskALL, ,TransferTest_33);
  HSR(,0x00000000, ,MaskALL, ,TransferTest_34);
  HSR(,0xCCCCCCCC, ,MaskALL, ,TransferTest_35);

  C("Access to 32 bit MW with BYTE and WRAP16");
  Addr = MEM0_BASE + 0x29;
  HSA(Addr, NSEQ, WRAP16, OK, BYTE);
  HSW(,0x33333333);
  HSA(Addr+1, SEQ, WRAP16, OK, BYTE);
  HSW(,0x33333334);
  HSA(Addr+2, SEQ, WRAP16, OK, BYTE);
  HSW(,0x33333335);
  HSA(Addr+3, SEQ, WRAP16, OK, BYTE);
  HSW(,0x33333336);
  HSA(Addr+4, SEQ, WRAP16, OK, BYTE);
  HSW(,0x33333337);
  HSA(Addr+5, SEQ, WRAP16, OK, BYTE);
  HSW(,0x33333338);
  HSA(Addr+6, SEQ, WRAP16, OK, BYTE);
  HSW(,0x33333339);
  HSA(0x00000020, SEQ, WRAP16, OK, BYTE);
  HSW(,0x3333333A);
  HSA(0x00000021, SEQ, WRAP16, OK, BYTE);
  HSW(,0x3333333B);
  HSA(0x00000022, SEQ, WRAP16, OK, BYTE);
  HSW(,0x3333333C);
  HSA(0x00000023, SEQ, WRAP16, OK, BYTE);
  HSW(,0x3333333D);
  HSA(0x00000024, BUSY, WRAP16, OK, BYTE);
  HSW(,0x333333BB);
  HSA(0x00000024, BUSY, WRAP16, OK, BYTE);
  HSW(,0x333333CC);
  HSA(0x00000024, SEQ, WRAP16, OK, BYTE);
  HSW(,0x3333333E);
  HSA(0x00000025, BUSY, WRAP16, OK, BYTE);
  HSW(,0x333333DD);
  HSA(0x00000025, BUSY, WRAP16, OK, BYTE);
  HSW(,0x33333300);
  HSA(0x00000025, BUSY, WRAP16, OK, BYTE);
  HSW(,0x333333DD);
  HSA(0x00000025, BUSY, WRAP16, OK, BYTE);
  HSW(,0x33333300);
  HSA(0x00000025, BUSY, WRAP16, OK, BYTE);
  HSW(,0x333333DD);
  HSA(0x00000025, BUSY, WRAP16, OK, BYTE);
  HSW(,0x33333300);
  HSA(0x00000025, SEQ, WRAP16, OK, BYTE);
  HSW(,0x3333333F);
  HSA(0x00000026, BUSY, WRAP16, OK, BYTE);
  HSW(,0x33333344);
  HSA(0x00000026, BUSY, WRAP16, OK, BYTE);
  HSW(,0x33333355);
  HSA(0x00000026, IDLE, WRAP16, OK, BYTE);
  HSW(,0x00000000);
  HSA(0x00000026, NSEQ, INCR, OK, BYTE);
  HSW(,0x11111111);
  HSA(0x00000027, SEQ, INCR, OK, BYTE);
  HSW(,0x11111112);
  HSA(0x00000028, IDLE, INCR, OK, BYTE);
  HSW(,0x11111113);
  
  C("Read data back");
  Addr = MEM0_BASE + 0x29;
  HSA(Addr, NSEQ, WRAP16, OK, BYTE);
  HSR(,0x33333333, ,0x0000FF00);
  HSA(Addr+1, SEQ, WRAP16, OK, BYTE);
  HSR(,0x33343333, ,0x00FF0000);
  HSA(Addr+2, SEQ, WRAP16, OK, BYTE);
  HSR(,0x35343333, ,0xFF000000);
  HSA(Addr+3, SEQ, WRAP16, OK, BYTE);
  HSR(,0x35343336, ,0x000000FF);
  HSA(Addr+4, SEQ, WRAP16, OK, BYTE);
  HSR(,0x35343733, ,0x0000FF00);
  HSA(Addr+5, SEQ, WRAP16, OK, BYTE);
  HSR(,0x35383333, ,0x00FF0000);
  HSA(Addr+6, SEQ, WRAP16, OK, BYTE);
  HSR(,0x39343333, ,0xFF000000);
  HSA(0x00000020, SEQ, WRAP16, OK, BYTE);
  HSR(,0x3333333A, , 0x000000FF);
  HSA(0x00000021, SEQ, WRAP16, OK, BYTE);
  HSR(,0x33333B33, ,0x0000FF00);
  HSA(0x00000022, SEQ, WRAP16, OK, BYTE);
  HSR(,0x333C3332, ,0x00FF0000);
  HSA(0x00000023, SEQ, WRAP16, OK, BYTE);
  HSR(,0x3D333332, ,0xFF000000);
  HSA(0x00000024, SEQ, WRAP16, OK, BYTE);
  HSR(,0x3333333E, ,0x000000FF);
  HSA(0x00000025, SEQ, WRAP16, OK, BYTE);
  HSR(,0x33333F30, ,0x0000FF00);
  HSA(0x00000026, NSEQ, INCR, OK, BYTE);
  HSR(,0x11111111, ,0x00FF0000);
  HSA(0x00000027, SEQ, INCR, OK, BYTE);
  HSR(,0x12111111, ,0xFF000000);
  HSA(0x00000028, IDLE, INCR, OK, BYTE);
  HSR(,0x11111113, ,0x000000FF);

  C("Perform memory access to 32 bit MW with HWRD access");
  Addr = MEM0_BASE + 0x26;
  HSA(Addr, NSEQ, WRAP16, OK, HWRD);
  HSW(,0x22222222);
  HSA(Addr+2, SEQ, WRAP16, OK, HWRD);
  HSW(,0x22222223);
  HSA(Addr+4, SEQ, WRAP16, OK, HWRD);
  HSW(,0x22222224);
  HSA(Addr+6, SEQ, WRAP16, OK, HWRD);
  HSW(,0x22222225);
  HSA(Addr+8, SEQ, WRAP16, OK, HWRD);
  HSW(,0x22222226);
  HSA(Addr+0xA, BUSY, WRAP16, OK, HWRD);
  HSW(,0x22222222);
  HSA(Addr+0xA, BUSY, WRAP16, OK, HWRD);
  HSW(,0x22222222);
  HSA(Addr+0xA, SEQ, WRAP16, OK, HWRD);
  HSW(,0x22222227);
  HSA(Addr+0xC, SEQ, WRAP16, OK, HWRD);
  HSW(,0x22222228);
  HSA(Addr+0xE, SEQ, WRAP16, OK, HWRD);
  HSW(,0x22222229);
  HSA(Addr+0x10, BUSY, WRAP16, OK, HWRD);
  HSW(,0x22222210);
  HSA(Addr+0x10, IDLE, WRAP16, OK, HWRD);
  HSW(,0x22222210);
  HSA(Addr+0x10, NSEQ, INCR, OK, HWRD);
  HSW(,0x22222227);
  HSA(Addr+0x12, SEQ, INCR, OK, HWRD);
  HSW(,0x22222228);

  C("Read data back");
  Addr = MEM0_BASE + 0x26;
  HSA(Addr, NSEQ, WRAP16, OK, HWRD);
  HSR(,0x22222222, ,0xFFFF0000);
  HSA(Addr+2, SEQ, WRAP16, OK, HWRD);
  HSR(,0x22222223, ,0x0000FFFF);
  HSA(Addr+4, SEQ, WRAP16, OK, HWRD);
  HSR(,0x22242222, ,0xFFFF0000);
  HSA(Addr+6, SEQ, WRAP16, OK, HWRD);
  HSR(,0x22222225, ,0x0000FFFF);
  HSA(Addr+8, SEQ, WRAP16, OK, HWRD);
  HSR(,0x22262222, ,0xFFFF0000);
  HSA(Addr+0xA, BUSY, WRAP16, OK, HWRD);
  HSR(,0x2222AAAA, ,0x0000FFFF);
  HSA(Addr+0xA, SEQ, WRAP16, OK, HWRD);
  HSR(,0x22222227, ,0x0000FFFF);
  HSA(Addr+0xC, SEQ, WRAP16, OK, HWRD);
  HSR(,0x22282227, ,0xFFFF0000);
  HSA(Addr+0xE, SEQ, WRAP16, OK, HWRD);
  HSR(,0x22222229, ,0x0000FFFF);
  HSA(Addr+0x10, NSEQ, INCR, OK, HWRD);
  HSR(,0x22272220, ,0xFFFF0000);
  HSA(Addr+0x12, SEQ, INCR, OK, HWRD);
  HSR(,0x22222228, ,0x0000FFFF);

  C("Write data and insert busy to 32 bit MW with HWRD");
  Addr = MEM0_BASE + 0x1A0;
  HSA(Addr, NSEQ, INCR16,OK, HWRD);
  HSW(,0x11111111);
  HSA(Addr+2, SEQ, INCR16,OK, HWRD);
  HSW(,0x11111112);
  HSA(Addr+0x4, BUSY, INCR16,OK, HWRD);
  HSW(,0x111111AA);
  HSA(Addr+4, SEQ, INCR16,OK, HWRD);
  HSW(,0x11111113);
  HSA(Addr+6, SEQ, INCR16,OK, HWRD);
  HSW(,0x11111114);
  HSA(Addr+8, SEQ, INCR16,OK, HWRD);
  HSW(,0x11111115);
  HSA(Addr+0xA, SEQ, INCR16,OK, HWRD);
  HSW(,0x11111116);
  HSA(Addr+0xC, SEQ, INCR16,OK, HWRD);
  HSW(,0x11111117);
  HSA(Addr+0xE, SEQ, INCR16,OK, HWRD);
  HSW(,0x11111118);
  HSA(Addr+0x10, SEQ, INCR16,OK, HWRD);
  HSW(,0x11111119);
  HSA(Addr+0x12, SEQ, INCR16,OK, HWRD);
  HSW(,0x1111111A);
  HSA(Addr+0x14, SEQ, INCR16,OK, HWRD);
  HSW(,0x1111111B);
  HSA(Addr+0x16, SEQ, INCR16,OK, HWRD);
  HSW(,0x1111111C);
  HSA(Addr+0x18, SEQ, INCR16,OK, HWRD);
  HSW(,0x1111111D);
  HSA(Addr+0x1A, SEQ, INCR16,OK, HWRD);
  HSW(,0x1111111E);
  HSA(Addr+0x1C, SEQ, INCR16,OK, HWRD);
  HSW(,0x1111111F);
  HSA(Addr+0x1E, SEQ, INCR16,OK, HWRD);
  HSW(,0x11111120);

  C("Read data");
  HSA(Addr, NSEQ, INCR16,OK, HWRD);
  HSR(,0x11111111, ,0x0000FFFF);
  HSA(Addr+2, SEQ, INCR16,OK, HWRD);
  HSR(,0x11121111, ,0xFFFF0000);
  HSA(Addr+4, SEQ, INCR16,OK, HWRD);
  HSR(,0x11111113, ,0x0000FFFF);
  HSA(Addr+6, SEQ, INCR16,OK, HWRD);
  HSR(,0x11141111, ,0xFFFF0000);
  HSA(Addr+8, SEQ, INCR16,OK, HWRD);
  HSR(,0x11111115, ,0x0000FFFF);
  HSA(Addr+0xA, SEQ, INCR16,OK, HWRD);
  HSR(,0x11161111, ,0xFFFF0000);
  HSA(Addr+0xC, SEQ, INCR16,OK, HWRD);
  HSR(,0x11111117, ,0x0000FFFF);
  HSA(Addr+0xE, SEQ, INCR16,OK, HWRD);
  HSR(,0x11181111, ,0xFFFF0000);
  HSA(Addr+0x10, SEQ, INCR16,OK, HWRD);
  HSR(,0x11111119, ,0x0000FFFF);
  HSA(Addr+0x12, SEQ, INCR16,OK, HWRD);
  HSR(,0x111A1111, ,0xFFFF0000);
  HSA(Addr+0x14, SEQ, INCR16,OK, HWRD);
  HSR(,0x1111111B, ,0x0000FFFF);
  HSA(Addr+0x16, SEQ, INCR16,OK, HWRD);
  HSR(,0x111C1111, ,0xFFFF0000);
  HSA(Addr+0x18, SEQ, INCR16,OK, HWRD);
  HSR(,0x1111111D, ,0x0000FFFF);
  HSA(Addr+0x1A, SEQ, INCR16,OK, HWRD);
  HSR(,0x111E1111, ,0xFFFF0000);
  HSA(Addr+0x1C, SEQ, INCR16,OK, HWRD);
  HSR(,0x1111111F, ,0x0000FFFF);
  HSA(Addr+0x1E, SEQ, INCR16,OK, HWRD);
  HSR(,0x11201111, ,0xFFFF0000);

  Addr = MEM0_BASE + 0x1E2;
  HSA(Addr, NSEQ, INCR4, OK, HWRD);
  HSW(,0x11111111);
  HSA(Addr+2, BUSY, INCR4, OK, HWRD);
  HSW(,0xAAAAAAAA);
  HSA(Addr+2, SEQ, INCR4, OK, HWRD);
  HSW(,0x11111112);
  HSA(Addr+4, SEQ, INCR4, OK, HWRD);
  HSW(,0x11111113);
  HSA(Addr+6, SEQ, INCR4, OK, HWRD);
  HSW(,0x11111114);

  HSA(Addr, NSEQ, INCR4, OK, HWRD);
  HSR(,0x11111111, ,0xFFFF0000);
  HSA(Addr+2, SEQ, INCR4, OK, HWRD);
  HSR(,0x11111112, ,0x0000FFFF);
  HSA(Addr+4, SEQ, INCR4, OK, HWRD);
  HSR(,0x11131111, ,0xFFFF0000);
  HSA(Addr+6, BUSY, INCR4, OK, HWRD);
  HSR(,0xBBBBBBBB, ,0xFFFF0000);
  HSA(Addr+6, BUSY, INCR4, OK, HWRD);
  HSR(,0xAAAAAAAA, ,0xFFFF0000);
  HSA(Addr+6, IDLE, INCR4, OK, HWRD);
  HSR(,0xBBBBBBBB, ,0xFFFF0000);
  HSA(Addr+6, NSEQ, INCR4, OK, HWRD);
  HSR(,0x11111114, ,0x0000FFFF);

  C("Write data to 32 bit MW with HWRD");
  data = 0x11111111;
  HSA(0x00000060, NSEQ, WRAP16, OK, HWRD);
  HSW(,data++);
  for(i = 0; i < 15; i++)
   HSW(,data++);
  C("Read data back with the insertion of Busy state");
  HSA(0x00000060, NSEQ, WRAP16, OK, HWRD);
  HSR(, 0x00001111, ,0x0000FFFF);

  HSA(0x00000062, SEQ, WRAP16, OK, HWRD);
  HSR(, 0x11120000, ,0xFFFF0000);

  HSA(0x00000064, SEQ, WRAP16, OK, HWRD);
  HSR(, 0x00001113, ,0x0000FFFF);

  HSA(0x00000066, SEQ, WRAP16, OK, HWRD);
  HSR(, 0x11140000, ,0xFFFF0000);

  HSA(0x00000068, BUSY, WRAP16, OK, HWRD);
  HSR(, 0x00001111, ,0x0000FFFF);

  HSA(0x00000068, SEQ, WRAP16, OK, HWRD);
  HSR(, 0x00001115, ,0x0000FFFF);

  HSA(0x0000006A, SEQ, WRAP16, OK, HWRD);
  HSR(, 0x11160000, ,0xFFFF0000);

  HSA(0x0000006C, SEQ, WRAP16, OK, HWRD);
  HSR(, 0x00001117, ,0x0000FFFF);
  
  HSA(0x0000006E, BUSY, WRAP16, OK, HWRD);
  HSR(, 0x11110000, ,0xFFFF0000);

  HSA(0x0000006E, BUSY, WRAP16, OK, HWRD);
  HSR(, 0x00001111, ,0x0000FFFF);

  HSA(0x0000006E, BUSY, WRAP16, OK, HWRD);
  HSR(, 0x00001111, ,0x0000FFFF);

  HSA(0x0000006E, BUSY, WRAP16, OK, HWRD);
  HSR(, 0x00001111, ,0x0000FFFF);

  HSA(0x0000006E, BUSY, WRAP16, OK, HWRD);
  HSR(, 0x00001111, ,0x0000FFFF);

  HSA(0x0000006E, BUSY, WRAP16, OK, HWRD);
  HSR(, 0x00001111, ,0x0000FFFF);

  HSA(0x0000006E, BUSY, WRAP16, OK, HWRD);
  HSR(, 0x00001111, ,0x0000FFFF);

  HSA(0x0000006E, SEQ, WRAP16, OK, HWRD);
  HSR(, 0x11180000, ,0xFFFF0000);

  HSA(0x00000070, BUSY, WRAP16, OK, HWRD);
  HSR(, 0x11110000, ,0xFFFF0000);

  HSA(0x00000070, BUSY, WRAP16, OK, HWRD);
  HSR(, 0x00001111, ,0x0000FFFF);

  HSA(0x00000070, BUSY, WRAP16, OK, HWRD);
  HSR(, 0x00001111, ,0x0000FFFF);

  HSA(0x00000070, BUSY, WRAP16, OK, HWRD);
  HSR(, 0x00001111, ,0x0000FFFF);

  HSA(0x00000070, BUSY, WRAP16, OK, HWRD);
  HSR(, 0x00001111, ,0x0000FFFF);

  HSA(0x00000070, BUSY, WRAP16, OK, HWRD);
  HSR(, 0x00001111, ,0x0000FFFF);

  HSA(0x00000070, SEQ, WRAP16, OK, HWRD);
  HSR(, 0x00001119, ,0x0000FFFF);

  HSA(0x00000072, SEQ, WRAP16, OK, HWRD);
  HSR(, 0x111A0000, ,0xFFFF0000);
  
  HSA(0x00000074, SEQ, WRAP16, OK, HWRD);
  HSR(, 0x0000111B, ,0x0000FFFF);

  HSA(0x00000076, SEQ, WRAP16, OK, HWRD);
  HSR(, 0x111C0000, ,0xFFFF0000);

  HSA(0x00000078, SEQ, WRAP16, OK, HWRD);
  HSR(, 0x0000111D, ,0x0000FFFF);

  HSA(0x0000007A, SEQ, WRAP16, OK, HWRD);
  HSR(, 0x111E0000, ,0xFFFF0000);

  HSA(0x0000007C, SEQ, WRAP16, OK, HWRD);
  HSR(, 0x0000111F, ,0x0000FFFF);

  HSA(0x0000007E, SEQ, WRAP16, OK, HWRD);
  HSR(, 0x11200000, ,0xFFFF0000);

}
/*-- --================================ End ================================--*/
