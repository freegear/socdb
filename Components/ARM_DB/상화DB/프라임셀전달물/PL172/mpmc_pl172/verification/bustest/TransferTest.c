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
-- File Name              : TransferTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           It performs different types of HTRANS operations at or near the
--           quad word boundary.
--
--           TEST ID : MPMC_TransTest_1
--
-- --=======================================================================--*/
/******************************************************************************/
/********************************** TransferTest ******************************/
/******************************************************************************/
void TransferTest()
{
  /* 
      Summary:TransferTest
      ====================
      This test performs the following functionalities

      o  It performs different types of HTRANS operation and verifies the data
         integrity.

      o  Different combinaitons are:
         NS-NS,NS-NS-NS,NS-S,NS-S-S,NS-I-NS,NS-B-S,NS-B-NS,NS-B-I,NS-S-B-S,
         NS-B-S-B-S
         All combinations mentioned above are tried with same as well as 
         different banks.
  */
  unsigned long addr1, addr2, addr3, addr4, chpsel,data;
  unsigned long TestData;
  int i;
  int32 Addr;
  int trans1[11] = {2,3,3,3,3,3,3,3,1,0,5};
  int trans2[11] = {2,3,3,3,3,3,3,3,1,2,5};
  int trans3[7] = {2,3,3,3,1,0,5};
  int trans4[7] = {2,3,3,3,1,2,5};
  int trans5[6] = {2,3,3,1,0,5};
  int trans6[6] = {2,3,3,1,2,5};
  int trans7[4] = {2,1,0,5};
  int trans8[4] = {2,1,2,5};
  int trans9[6] = {2,3,1,3,3,5};
  int trans10[6] = {2,3,3,0,5};
  C("TEST ID : MPMC_TransTest_1");
  /* Disable Address Mirror bit */
  HSA(MPMCControl, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000001);
  /* Set Bank 0 Memory Type as SRAM (32 bits width) */
  C("Program bank0");
  StInitProc(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);

  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Program bank1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(1,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  C("Program bank2");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,0x3);
  TrickMemInit(2,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (32 bits width) with buffers disabled */
  C("Program bank3");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(3,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);
  C("Transfer type: NS-B-S to the same bank");
  addr1 = MEM0_BASE + 0x1E1;
  HSA(addr1, NSEQ, INCR, OK, BYTE);
  HSW(,0x33333333);
  HSA(addr1 + 1, BUSY, INCR, OK, BYTE);
  HSW(,0xAAAAAAAA);
  HSA(addr1 + 1, SEQ, INCR, OK, BYTE);
  HSW(,0x22222222);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_0, 0x52, "WRD");
  HSA(addr1, NSEQ, INCR, OK, BYTE);
  HSR(,0x33333333,0x000000FF);
  HSA(addr1 + 1, SEQ, INCR, OK, BYTE);
  HSR(,0x22222222,0x0000FF00);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_0, 0x42,"WRD");

  C("Transfer type: NS-B-S to the same bank");
  addr1 = MEM0_BASE + 0x1AC;
  HSA(addr1, NSEQ, INCR, OK, HWRD);
  HSW(,0x33333333);
  HSA(addr1 + 2, BUSY, INCR, OK, HWRD);
  HSW(,0xAAAAAAAA);
  HSA(addr1 + 2, SEQ, INCR, OK, HWRD);
  HSW(,0x22222222);
  
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_0, 0x52, "WRD");
  HSA(addr1, NSEQ, INCR, OK, HWRD);
  HSR(,0x33333333,0x0000FFFF);
  HSA(addr1 + 2, SEQ, INCR, OK, HWRD);
  HSR(,0x22222222,0xFFFF0000);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_0, 0x42,"WRD");
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
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_0, 0x52, "WRD");
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

  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_0, 0x42,"WRD");
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

  C("Write data to memory with HWRD");
  HSA(0x20000022,NSEQ, INCR, OK, HWRD);
  HSW(,0x00002222);
  HSA(0x20000024,BUSY,INCR, OK, HWRD);
  HSW(,0x22220000);
  HSA(0x20000022,NSEQ, INCR, OK, HWRD);
  HSR(,0x22220000, ,0xFFFF0000);
  HSA(0x20000024,BUSY,INCR, OK, HWRD);
  HSR(,0x22220000, ,0xFFFF0000);
  HSA(0x20000044,NSEQ, INCR, OK, HWRD);
  HSW(,0x00002222);
  HSA(0x20000046,BUSY,INCR, OK, HWRD);
  HSW(,0x00002222);
  HSA(0x20000046,NSEQ,INCR, OK, HWRD);
  HSW(,0x00002223);
  HSA(0x20000044,NSEQ, INCR, OK, HWRD);
  HSR(,0x00002222, ,0x0000FFFF);
  HSA(0x20000046,NSEQ,INCR, OK, HWRD);
  HSR(,0x22230000, , 0xFFFF0000);

  WriteData(MPMCTrMEMT_0, 0x52, "WRD");
  Sequence('w',0x0000002E, trans9,"in4",0,0x11111111,0);
  Sequence('w',0x00000076, trans10,"in4",0,0x22222222,0);
  Sequence('r',0x0000002E, trans9,"in4",0,0x11111111,0);
  Sequence('r',0x00000076, trans10,"in4",0,0x22222222,0);

  C("Burst operation to 32 bit MW with hsize as BYTE");
  Addr = 0x00000024;
  C("Read data back");
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  for (i = 0; i < 7; i++)
  {
     Sequence('w',Addr,trans1,"inc",0,0x22222222,0);
     Sequence('r',Addr,trans1,"inc",0,0x22222222,0);

     Sequence('w',Addr,trans3,"in4",0,0x44444444,0);
     Sequence('r',Addr,trans3,"in4",0,0x44444444,0);

     Sequence('w',Addr,trans1,"in8",0,0x55555555,0);
     Sequence('r',Addr,trans1,"in8",0,0x55555555,0);

     Sequence('w',Addr,trans1,"i16",0,0x66666666,0);
     Sequence('r',Addr,trans1,"i16",0,0x66666666,0);

     Sequence('w',Addr,trans6,"wr4",0,0x77777777,0);
     Sequence('r',Addr,trans3,"wr4",0,0x77777777,0);

     Sequence('w',Addr,trans1,"wr8",0,0x88888888,0);
     Sequence('r',Addr,trans1,"wr8",0,0x88888888,0);

     Sequence('w',Addr,trans5,"w16",0,0x99999999,0);
     Sequence('r',Addr,trans5,"w16",0,0x99999999,0);
     Addr = Addr + 1;
  }
  C("Burst operation to 32 bit MW with hsize as HWRD");
  Addr = 0x00000028;
  for (i = 0; i < 7; i++)
  {
     Sequence('w',Addr,trans4,"inc",1,0xAAAAAAAA,0);
     Sequence('r',Addr,trans4,"inc",1,0xAAAAAAAA,0);

     Sequence('w',Addr,trans3,"in4",1,0xBBBBBBBB,0);
     Sequence('r',Addr,trans6,"in4",1,0xBBBBBBBB,0);

     Sequence('w',Addr,trans2,"in8",1,0xCCCCCCCC,0);
     Sequence('r',Addr,trans1,"in8",1,0xCCCCCCCC,0);

     Sequence('w',Addr,trans1,"i16",1,0xDDDDDDDD,0);
     Sequence('r',Addr,trans1,"i16",1,0xDDDDDDDD,0);

     Sequence('w',Addr,trans6,"wr4",1,0xEEEEEEEE,0);
     Sequence('r',Addr,trans3,"wr4",1,0xEEEEEEEE,0);
  
     Sequence('w',Addr,trans1,"wr8",1,0xFFFFFFFF,0);
     Sequence('r',Addr,trans1,"wr8",1,0xFFFFFFFF,0);
  
     Sequence('w',Addr,trans1,"w16",1,0x11111111,0);
     Sequence('r',Addr,trans1,"w16",1,0x11111111,0);
     Addr = Addr + 2;
  }
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_0, 0x42,"WRD");

  C("Burst operation to 32 bit MW with hsize as WRD");
  Addr = 0x0000005C;
  for (i = 0; i < 7; i++)
  {
     Sequence('w',Addr,trans10,"inc",2,0x33333333,0);
     Sequence('r',Addr,trans10,"inc",2,0x33333333,0);

     Sequence('w',Addr,trans9,"in4",2,0x22222222,0);
     Sequence('r',Addr,trans3,"in4",2,0x22222222,0);

     Sequence('w',Addr,trans2,"in8",2,0x55555555,0);
     Sequence('r',Addr,trans1,"in8",2,0x55555555,0);

     Sequence('w',Addr,trans2,"i16",2,0x66666666,0);
     Sequence('r',Addr,trans2,"i16",2,0x66666666,0);

     Sequence('w',Addr,trans9,"wr4",2,0x88888888,0);
     Sequence('r',Addr,trans6,"wr4",2,0x88888888,0);
  
     Sequence('w',Addr,trans1,"wr8",2,0xAAAAAAAA,0);
     Sequence('r',Addr,trans1,"wr8",2,0xAAAAAAAA,0);
  
     Sequence('w',Addr,trans5,"w16",2,0x33333333,0);
     Sequence('r',Addr,trans5,"w16",2,0x33333333,0);
     Addr = Addr + 4;
  }

  C("Burst operation to 8 bit MW with hsize as BYTE");
  Addr = 0x20000024;
  for (i = 0; i < 7; i++)
  {
     Sequence('w',Addr,trans4,"inc",0,0x11111111,0);
     Sequence('r',Addr,trans3,"inc",0,0x11111111,0);

     Sequence('w',Addr,trans6,"in4",0,0x00000000,0);
     Sequence('r',Addr,trans9,"in4",0,0x00000000,0);

     Sequence('w',Addr,trans2,"in8",0,0xEEEEEEEE,0);
     Sequence('r',Addr,trans2,"in8",0,0xEEEEEEEE,0);

     Sequence('w',Addr,trans4,"i16",0,0x44444444,0);
     Sequence('r',Addr,trans9,"i16",0,0x44444444,0);

     Sequence('w',Addr,trans6,"wr4",0,0x33333333,0);
     Sequence('r',Addr,trans9,"wr4",0,0x33333333,0);

     Sequence('w',Addr,trans1,"wr8",0,0x66666666,0);
     Sequence('r',Addr,trans1,"wr8",0,0x66666666,0);

     Sequence('w',Addr,trans1,"w16",0,0x77777777,0);
     Sequence('r',Addr,trans1,"w16",0,0x77777777,0);
     Addr = Addr + 1;
  }

  C("Burst operation to 8 bit MW with hsize as HWRD");
  Addr = 0x20000028;
  for (i = 0; i < 7; i++)
  {
     Sequence('w',Addr,trans2,"inc",1,0xEEEEEEEE,0);
     Sequence('r',Addr,trans2,"inc",1,0xEEEEEEEE,0);

     Sequence('w',Addr,trans6,"in4",1,0xFFFFFFFF,0);
     Sequence('r',Addr,trans3,"in4",1,0xFFFFFFFF,0);

     Sequence('w',Addr,trans2,"in8",1,0x11111111,0);
     Sequence('r',Addr,trans2,"in8",1,0x11111111,0);

     Sequence('w',Addr,trans2,"i16",1,0x55555555,0);
     Sequence('r',Addr,trans1,"i16",1,0x55555555,0);

     Sequence('w',Addr,trans3,"wr4",1,0x77777777,0);
     Sequence('r',Addr,trans6,"wr4",1,0x77777777,0);
  
     Sequence('w',Addr,trans1,"wr8",1,0x66666666,0);
     Sequence('r',Addr,trans1,"wr8",1,0x66666666,0);
  
     Sequence('w',Addr,trans1,"w16",1,0x99999999,0);
     Sequence('r',Addr,trans1,"w16",1,0x99999999,0);
     Addr = Addr + 2;
  }

  C("Burst operation to 8 bit MW with hsize as WRD");
  Addr = 0x2000005C;
  for (i = 0; i < 7; i++)
  {
     Sequence('w',Addr,trans7,"inc",2,0x33333333,0);
     Sequence('r',Addr,trans7,"inc",2,0x33333333,0);

     Sequence('w',Addr,trans7,"in4",2,0x99999999,0);
     Sequence('r',Addr,trans7,"in4",2,0x99999999,0);

     Sequence('w',Addr,trans2,"in8",2,0x55555555,0);
     Sequence('r',Addr,trans1,"in8",2,0x55555555,0);

     Sequence('w',Addr,trans2,"i16",2,0x88888888,0);
     Sequence('r',Addr,trans1,"i16",2,0x88888888,0);

     Sequence('w',Addr,trans6,"wr4",2,0x66666666,0);
     Sequence('r',Addr,trans6,"wr4",2,0x66666666,0);
  
     Sequence('w',Addr,trans1,"wr8",2,0x11111111,0);
     Sequence('r',Addr,trans1,"wr8",2,0x11111111,0);
  
     Sequence('w',Addr,trans4,"w16",2,0x77777777,0);
     Sequence('r',Addr,trans4,"w16",2,0x77777777,0);
     Addr = Addr + 4;
  }

  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_0, 0x52, "WRD");

  C("Random Burst Write and Read operation");

     Addr = 0x00000021;
     Sequence('w',Addr,trans7,"inc",0,0x22222222,0);
     Addr = 0x20000021;
     Sequence('w',Addr,trans1,"inc",0,0x22222222,0);

     Addr = 0x00000021;
     Sequence('r',Addr,trans7,"in4",0,0x22222222,0);
     Addr = 0x20000021;
     Sequence('r',Addr,trans6,"in4",0,0x22222222,0);

     Addr = 0x00000023;
     Sequence('w',Addr,trans2,"in8",0,0x33333333,0);
     Addr = 0x000000E1;
     Sequence('w',Addr,trans1,"in8",0,0x55555555,0);

     Addr = 0x00000023;
     Sequence('r',Addr,trans6,"in4",0,0x33333333,0);
     Addr = 0x000000E1;
     Sequence('r',Addr,trans1,"in8",0,0x55555555,0);

     Addr = 0x000000A5;
     Sequence('w',Addr,trans9,"in4",0,0x22222222,0);
     Addr = 0x00000077;
     Sequence('w',Addr,trans6,"wr4",0,0x11111111,0);

     Addr = 0x000000A5;
     Sequence('r',Addr,trans3,"in4",0,0x22222222,0);
     Addr = 0x00000077;
     Sequence('r',Addr,trans6,"wr4",0,0x11111111,0);

     Addr = 0x00000023;
     Sequence('r',Addr,trans3,"in4",0,0x33333333,0);
     Addr = 0x000000E1;
     Sequence('r',Addr,trans3,"in8",0,0x55555555,0); 

     C("HSIZE is HWRD");
     Addr = 0x00000022;
     Sequence('w',Addr,trans2,"inc",1,0x55555555,0);
     Addr = 0x20000022;
     Sequence('w',Addr,trans3,"inc",1,0x22222222,0);

     Addr = 0x00000022;
     Sequence('r',Addr,trans6,"in4",1,0x55555555,0);
     Addr = 0x20000022;
     Sequence('r',Addr,trans3,"in4",1,0x22222222,0);

     Addr = 0x0000002A;
     Sequence('w',Addr,trans1,"in8",1,0x99999999,0);
     Addr = 0x00000072;
     Sequence('w',Addr,trans1,"in8",1,0x33333333,0);

     Addr = 0x0000002A;
     Sequence('r',Addr,trans3,"in4",1,0x99999999,0);
     Addr = 0x00000072;
     Sequence('r',Addr,trans1,"in8",1,0x33333333,0);

     Addr = 0x000000A4;
     Sequence('w',Addr,trans6,"in4",1,0x88888888,0);
     Addr = 0x00000076;
     Sequence('w',Addr,trans6,"wr4",1,0x11111111,0);

     Addr = 0x000000A4;
     Sequence('r',Addr,trans6,"in4",1,0x88888888,0);
     Addr = 0x00000076;
     Sequence('r',Addr,trans6,"wr4",1,0x11111111,0);

     Addr = 0x0000002A;
     Sequence('r',Addr,trans6,"in4",1,0x99999999,0);
     Addr = 0x00000076;
     Sequence('r',Addr,trans9,"wr4",1,0x11111111,0);

     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_0, 0x42, "WRD");

     C("HSIZE is WRD");
     Addr = 0x00000024;
     Sequence('w',Addr,trans4,"inc",2,0x22222222,0);
     Addr = 0x20000024;
     Sequence('w',Addr,trans1,"inc",2,0x11111111,0);

     Addr = 0x00000024;
     Sequence('r',Addr,trans4,"inc",2,0x22222222,0);
     Addr = 0x20000024;
     Sequence('r',Addr,trans9,"in4",2,0x11111111,0);

     Addr = 0x0000002C;
     Sequence('w',Addr,trans1,"in8",2,0x33333333,0);
     Addr = 0x000000F0;
     Sequence('w',Addr,trans1,"in8",2,0x22222222,0);

     Addr = 0x0000002C;
     Sequence('r',Addr,trans9,"in4",2,0x33333333,0);
     Addr = 0x000000F0;
     Sequence('r',Addr,trans1,"in8",2,0x22222222,0);

     Addr = 0x000000A4;
     Sequence('w',Addr,trans9,"in4",2,0x44444444,0);
     Addr = 0x00000078;
     Sequence('w',Addr,trans3,"wr4",2,0x99999999,0);

     Addr = 0x000000A4;
     Sequence('r',Addr,trans9,"in4",2,0x44444444,0);
     Addr = 0x00000078;
     Sequence('r',Addr,trans3,"wr4",2,0x99999999,0);

     Addr = 0x0000002C;
     Sequence('r',Addr,trans9,"in4",2,0x33333333,0);
     Addr = 0x000000F0;
     Sequence('r',Addr,trans9,"in4",2,0x22222222,0);
}
/*-- --================================ End ================================--*/
