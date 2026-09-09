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
-- File Name              : SelfRefChk.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           It checks  whether self refresh ACK is generated when self 
--           refresh request is asserted  
--
--           TEST ID : MPMC_SelfRefChk
--
-- --=======================================================================--*/
/******************************************************************************/
/********************************* SelfRefChk *********************************/
/******************************************************************************/
void SelfRefChk(void)
{
  /*
    Summary : Self Refresh Check
    ============================
    It does the following checks,

    o  This test verifies that a self refresh is issued by the controller when a
       SREFReq input is asserted.

    o  Write 1 to SR bit of MPMCDyCntl register and verify that ACK has given
       back or not.

    o Apply nPOR and verify that after coming out of reset controller is in 
      self refresh mode. Read data back after the memory comes out self refresh
      which are written before applying the nPOR
    
  */
  int i;
  int trans[17] = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  int trans1[128];
  C("TEST ID : MPMC_SelfRefChk");
  WriteData(MPMCControl, 0x00000001, "WRD");

  TimingInit(2,5,8,0,5,5,0,7,7,0,2,3);
  SyncInitializeProc(2, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     0,2,1,0,1,1,1,0,2,1,1,
                     0,1,2,0,0,1,1,0,3,1,1,
                     0,0,0,0,0,1,1,0,3,0,0,
                     0,2,2,0,1,1,1,0,2,1,2,
                     12,12,11,12,
                     0,
                     0);
  C("Perform memory access before entering into self refresh mode");
  Sequence('w', 0x40000028,trans,"inc",2,0x44444444,0);
  Sequence('r', 0x40000028,trans,"inc",2,0x44444444,0);
  InitTransRnd(trans1, 80); 
  Sequence('w', 0x50005224,trans1,"inc",2,0x11111111,0);
  Sequence('r', 0x50005224,trans1,"inc",2,0x11111111,0);

  InitTransRnd(trans1, 80);
  Sequence('w', 0x60005024,trans1,"inc",2,0x55555555,0);
  Sequence('r', 0x60005024,trans1,"inc",2,0x55555555,0);

  C("Poll for busy bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);

  C("Poll for busy bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
 
  C("Assert self refresh request");
  WriteData(MPMCDyCntl, 0x04, "WRD");
  WaitLoop(0x06);

  C("Checking for self refresh request to be asserted");
  WaitLoop(0x7);
  ReadData(MPMCTrSR, 0x004, 0x004, "WRD");

  C(" Check SREFACK ");
  WaitLoop(0x20);
  ReadData(MPMCStatus, 0x004, 0x004, "WRD");
  /* Perform memory access and verify that response is ERROR */
  HSA(0x60000000, NSEQ, INCR, ERROR, WRD);
  HSW(, 0x0000FFFF);
  for(i = 0; i < 4; i++)
    HSW(,0xFFFF0000);
  C("Deassert self refresh request");
  WriteData(MPMCDyCntl, ZERO, "WRD");

  C("Checking for self refresh request to be deasserted");
  WaitLoop(2);
  ReadData(MPMCTrSR, 0x000, 0x004, "WRD");

  WaitLoop(5);

  C(" Check SREFACK ");
  HSA(MPMCStatus, NSEQ, INCR);
  HPO( ,0x000, ,0x004, ,);

  /* Write 1 SREFREQ bit of MPMCTrCR register to make MPMCREFREQ line high */
  WriteData(MPMCTrCR, 0x00000001, "WRD");
  WaitLoop(0x10);
  /* Read SREF of MPMCTrSr which indicates the status of MPMCREFREQ line */
  ReadData(MPMCTrSR, 0x00000004, 0x00000004, "WRD");

  WaitLoop(0xA);
  /* Check whether ACK has issued */
  C(" Check SREFACK ");
  HSA(MPMCStatus, NSEQ, INCR);
  HPO( ,0x004, ,0x004, ,);

  WaitLoop(0x3);
  /* Perform memory access and verify that response is ERROR */
  HSA(0x50000000, NSEQ, INCR4, ERROR, WRD);
  HSW(, 0x0000AAAA);
  for(i = 0; i < 3; i++)
    HSW(,0xAAAA0000);
  WaitLoop(0x30);
  C("Apply nPOR and verify that memory is still in self refresh mode");
  CSPOReset();
  WaitLoop(0x2);
  WriteData(MPMCControl, 0x00000001, "WRD");
  C("Check for the self refresh acknowledgement");
  HSA(MPMCStatus, NSEQ, INCR);
  HPO( ,0x004, ,0x004, ,);
  C("Reset the self refresh bit");
  WriteData(MPMCDyCntl, 0x00000000, "WRD");

  C("Reconfigure the dynamic controller registers");
  TimingInit(2,5,8,0,5,5,0,7,7,0,2,3);
  ReProgramDyReg(2, 0, 2, 2, 0, 0,
                 3, 0, 2, 2, 0, 0,
                 3, 0, 2, 2, 0, 0,
                 2, 0, 2, 2, 0, 0,
                 0,2,1,0,1,1,1,0,2,1,1,
                 0,1,2,0,0,1,1,0,3,1,1,
                 0,0,0,0,0,1,1,0,3,0,0,
                 0,2,2,0,1,1,1,0,2,1,2,
                 12,12,11,12,
                 0,
                 0,
                 0);

  /* Write 0 SREFREQ bit of MPMCTrCR register to make MPMCREFREQ line low */
  WriteData(MPMCTrCR, 0x00000000, "WRD");

  WaitLoop(0x3);
  /* Read SREF of MPMCTrSr which indicates the status of MPMCREFREQ line */
  ReadData(MPMCTrSR, 0x00000000, 0x00000004, "WRD");

  WaitLoop(0x3);
  /* Chk whether controller is in normal mode */
  C(" Check SREFACK ");
  ReadData(MPMCStatus, 0x000, 0x004, "WRD");

  WaitLoop(0x10); 
  C("Reread the data written before entering the self refresh mode"); 
  /* Sequence('r', 0x40000028,trans,"inc",2,0x44444444,0); */
   InitTransRnd(trans1, 16);
   Sequence('r', 0x40000028,trans1,"inc",2,0x44444444,0);

  /* Wait till the MPMC is IDLE */
  WaitLoop(3);
  HSA(MPMCStatus,NSEQ,INCR,OK,WRD, , , , , ,);
  HPO(,0x00000000, ,0x00000001);

  C("Set the SREFREQ bit in the DyCntl register");
  WriteData(MPMCDyCntl, 0x00000004, "WRD");
  WaitLoop(0x5);
  C("Set the SREFREQ input before SREF mode is entered");
  WriteData(MPMCTrCR, 0x00000001, "WRD");

  WaitLoop(0x3);
  C(" Check SREFACK ");
  HSA(MPMCStatus,NSEQ,INCR,OK,WRD, , , , , ,);
  HPO(,0x00000004, ,0x00000004);

  WaitLoop(0x3);
  /* Perform memory access and verify that response is ERROR */
  HSA(0x50000000, NSEQ, INCR4, ERROR, BYTE);
  HSR(,0x00000000, ,0x00000000);
  for(i = 0; i < 3; i++)
    HSR(,0x00000000, ,0x00000000);

  WaitLoop(0x30);
  C("Apply nPOR and verify that memory is still in self refresh mode");
  CSPOReset();
  WaitLoop(0x2);
  WriteData(MPMCControl, 0x00000001, "WRD");
  C("Check for the self refresh acknowledgement");
  HSA(MPMCStatus, NSEQ, INCR);
  HPO( ,0x004, ,0x004, ,);

  C("Reconfigure the dynamic controller registers");
  TimingInit(2,5,8,0,5,5,0,7,7,0,2,3);
  ReProgramDyReg(2, 0, 2, 2, 0, 0,
                 3, 0, 2, 2, 0, 0,
                 3, 0, 2, 2, 0, 0,
                 2, 0, 2, 2, 0, 0,
                 0,2,1,0,1,1,1,0,2,1,1,
                 0,1,2,0,0,1,1,0,3,1,1,
                 0,0,0,0,0,1,1,0,3,0,0,
                 0,2,2,0,1,1,1,0,2,1,2,
                 12,12,11,12,
                 0,
                 0,
                 0);
  /* Perform memory access and verify that response is ERROR */
  HSA(0x60000000, NSEQ, INCR4, ERROR, BYTE);
  HSR(,0x00000000, ,0x00000000);
  for(i = 0; i < 3; i++)
    HSR(,0x00000000, ,0x00000000);

  C("Deassert self refresh request");
  WriteData(MPMCDyCntl, ZERO, "WRD");

  /* Write 0 SREFREQ bit of MPMCTrCR register to make MPMCREFREQ line low */
  WriteData(MPMCTrCR, 0x00000000, "WRD");

  WaitLoop(0x3);
  /* Chk whether controller is in normal mode */
  C(" Check SREFACK ");
  ReadData(MPMCStatus, 0x000, 0x004, "WRD");

  /* Wait till the MPMC is IDLE */
  WaitLoop(3);
  HSA(MPMCStatus,NSEQ,INCR,OK,WRD, , , , , ,);
  HPO(,0x00000000, ,0x00000001);
  C("Reread the data which was written before entering the self refresh");
  Sequence('r', 0x50005224,trans1,"inc",2,0x11111111,0);
  C("Set the SREFREQ bit in the DyCntl register");
  WriteData(MPMCDyCntl, 0x00000004, "WRD");

  WaitLoop(0x4);
  C("Set the SREFREQ input after SREF mode is entered");
  WriteData(MPMCTrCR, 0x00000001, "WRD");

  WaitLoop(0x3);
  C(" Check SREFACK ");
  HSA(MPMCStatus,NSEQ,INCR,OK,WRD, , , , , ,);
  HPO(,0x00000004, ,0x00000004);

  WaitLoop(0x3);
  /* Perform memory access and verify that response is ERROR */
  HSA(0x60000000, NSEQ, INCR4, ERROR, HWRD);
  HSR(,0x00000000, ,0x00000000);
  for(i = 0; i < 3; i++)
    HSR(,0x00000000, ,0x00000000);

  /* Write 0 SREFREQ bit of MPMCTrCR register to make MPMCREFREQ line low */
  WriteData(MPMCTrCR, 0x00000000, "WRD");

  C("Deassert self refresh request");
  WriteData(MPMCDyCntl, ZERO, "WRD");

  WaitLoop(0x3);
  /* Chk whether controller is in normal mode */
  C(" Check SREFACK ");
  ReadData(MPMCStatus, 0x000, 0x004, "WRD");
  C("Reread the data which was written before entering the self refresh");
  Sequence('r', 0x60005024,trans1,"inc",2,0x55555555,0);
}
/*-- --================================ End ================================--*/
