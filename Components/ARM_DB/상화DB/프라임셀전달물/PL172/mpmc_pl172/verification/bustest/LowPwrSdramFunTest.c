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
-- File Name              : LowPwrSdramFunTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           It checks for the initialization for LPSDRAM and functionality
--
--           TEST ID : MPMC_LowPwrSdram_1
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************* LowPwrSdramFunTest ***************************/
/******************************************************************************/
void LowPwrSdramFunTest()
{
  /* 
     Summary: LowPwrSdramFunTest
     ===========================
     This test performs the following functionalities

     o  It checks whether the proper initialization sequence is followed
        or not.

     o  Proper sequences can be verified by looking at the MPMCTrSr register.
  
     o  It also tests the deep sleep test. During Deep Sleep mode controller
        should return error response.
  
     o  Once LPSDRAM comes out of Deep Sleep Mode memory has to be again 
        reinitialized.
  */
  int i;
  unsigned long Addr3,Data;
  /* Initialize controller as well as configuration registers */

  Data = 0x33333333;
  C("TEST ID : MPMC_LowPwrSdram_1");
  C("Disable Address Mirror bit");
  WriteData(MPMCControl, 0x00000001, "WRD");
  C("Initialize controller register");
  WriteData(MPMCDyRasCas0, 0x00000302, "WRD");

  WriteData(MPMCDyRasCas1, 0x00000302, "WRD");

  WriteData(MPMCDyRasCas2, 0x00000302, "WRD");

  WriteData(MPMCDyRasCas3, 0x00000302, "WRD");
  C("Program the timing values"); 
  TimingInit(2,1,3,1,2,2,1,3,7,4,2,3);

  C("Program DyConfig register");

  WriteData(MPMCDyConfig0, 0x14800208, "WRD");

  WriteData(MPMCDyConfig1, 0x25000880, "WRD");

  WriteData(MPMCDyConfig2, 0x02404308, "WRD");

  WriteData(MPMCDyConfig3, 0x14800280, "WRD");

  /* Program MPMCConfig register - use CLK ratio as 1 : 1 and
     endian as little */

  WriteData(MPMCConfig, 0x00000000, "WRD");

  C("Wait for 100us");
  WaitLoop(50);
  /* Issue PALL by setting the SDRAM Initailization(I) to 10 */
  debug_info("Set SDRAM Initailization(I) to PALL");
  WriteData(MPMCDyCntl, 0x00000103, "WRD");

  /* write 2 to refresh register */
  WriteData(MPMCDyRef, 0x00000002, "WRD");
  /* Wait for a time period equivalent to 2 refresh cycles */
  WaitLoop(0x108);
  /* Program the operational value to REFRESH field */
  WriteData(MPMCDyRef, 0x0000000A, "WRD");
  /* Set I to MODE */
  debug_info("Set SDRAM Initailization(I) to MODE");
  WriteData(MPMCDyCntl,0x00000083,"WRD");

  /* Configure the mode register for its burst length, burst type, CAS latency,
     operating mode, write burst mode by performing a read operation */

  /* burst length = 4, burst type = Seq, CAS latency = 3, Operating mode = 
     STD op,   Self Refresh = 2  */
  debug_info("Program mode register");
  Addr3 = 0x33 << 12;
  Addr3 = Addr3 | 0x40000000;
  ReadData(Addr3, 0x00000000,0x00000000,"WRD");

  C("Configure CS5");
  Addr3 = 0x33 << 13;
  Addr3 = Addr3 | 0x50000000;
  ReadData(Addr3, 0x00000000,0x00000000,"WRD");
   
  /* Program the Low Power SDRAM extended mode register */
  /* Partial array refresh = 010, Temp. Compensated self refresh = 01 */
  /* To program the extended mode register program row as 0xA and Bank as 1 in
     address mapping */
  Addr3 = 0x4000A400;
  ReadData(Addr3, 0x00000000,0x00000000,"WRD");
 
  /* Program I to "normal" */
  debug_info("Program I to NORMAL mode");
  WriteData(MPMCDyCntl,0x00000003,"WRD");
  C("Configure DyConfig register");
  
  WriteData(MPMCDyConfig0,0x148C0208,"WRD");

  WriteData(MPMCDyConfig1,0x250C0880,"WRD");

  WriteData(MPMCDyConfig3,0x148C0280,"WRD");
  C("Perform memory access operation on LPSDRAM");
  HSA(0x40003440, NSEQ, INCR, OK, WRD);
  HSW(,Data++);
  for(i = 0; i < 95; i++)
    HSW(,Data++);
  C("Read data back");
  Data = 0x33333333;
  HSA(0x40003440, NSEQ, INCR, OK, WRD);
  HSR(,Data++, ,MaskALL);
  for(i = 0; i < 91; i++)
    HSR(,Data++, ,MaskALL);

  C("Disable Protocol checker");
  WriteData(MPMCTrCR, 0x00000010, "WRD");

  WaitLoop(0x3);
  C("Poll for busy and Buffer empty bits");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);

  C("Wait till refresh is applied");
  WaitLoop(0xA2);
  /* Set DP bit of MPMCDyCntl,Write 1 to CS and CE bits */
  WaitLoop(0x3);
  C("Poll for busy as well as write buffer empty");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  C("Enable DP and write 1 to CS and CE");
  WriteData(MPMCDyCntl, 0x00002003, "WRD");
  Addr3 = 0x40000000;
  C("Perform memory write operation and verify that response is E R R O R");
  WaitLoop(0x3);
  HSA(Addr3, NSEQ, INCR4,ERROR,WRD);
  HSW(,Data++);
  for(i = 0; i < 3; i++)
    HSW(,Data++);

  /* Reset DP bit of MPMCDyCntl,Write 1 to CS and CE bits */
  C("Disable DP and write 1 to CS and CE");
  HSA(MPMCDyCntl, NSEQ, INCR, OK, WRD);
  HSW(,0x00000003);
  C("Reinitialize the LPSDRAM");
  /* Before initializing the sdram make sure that buffers are flushed and
     are in buffer empty state and Controller is in Idle state */
  C("Program zero to RefCnt register");
  WriteData(MPMCDyRef, 0x00000000, "WRD");

  WaitLoop(0x3);
  C("Poll for busy and Buffer empty bits");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);

  WaitLoop(0x3);
  C("Poll for buffers and MPMCBusy are in Idle state");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD);
  HPO(,0x00000000, ,0x0000003);
  
  WaitLoop(0x3);
  C("Program DyConfig register");

  WriteData(MPMCDyConfig0, 0x14800208, "WRD");

  WriteData(MPMCDyConfig1, 0x25000880, "WRD");

  WriteData(MPMCDyConfig2, 0x02404308, "WRD");

  WriteData(MPMCDyConfig3, 0x14800280, "WRD");

  /* Program MPMCConfig register - use CLK ratio as 1 : 1 and
     endian as little */

  WriteData(MPMCConfig, 0x00000000, "WRD");

  C("Wait for 100us");
  WaitLoop(3500);
  /* Issue PALL by setting the SDRAM Initailization(I) to 10 */
  debug_info("Set SDRAM Initailization(I) to PALL");
  WriteData(MPMCDyCntl, 0x00000103, "WRD");

  /* write 2 to refresh register */
  WriteData(MPMCDyRef, 0x00000002, "WRD");
  /* Wait for a time period equivalent to 2 refresh cycles */
  WaitLoop(0x108);
  /* Program the operational value to REFRESH field */
  WriteData(MPMCDyRef, 0x0000000A, "WRD");
  /* Set I to MODE */
  debug_info("Set SDRAM Initailization(I) to MODE");
  WriteData(MPMCDyCntl, 0x00000083, "WRD");

  /* Configure the mode register for its burst length, burst type, CAS latency,
     operating mode, write burst mode by performing a read operation */

  /* burst length = 4, burst type = Seq, CAS latency = 3, Operating mode = 
     STD op,   Self Refresh = 2  */
  debug_info("Program mode register");
  Addr3 = 0x33 << 12;
  Addr3 = Addr3 | 0x40000000;
  ReadData(Addr3, 0x00000000, 0x00000000, "WRD");

  Addr3 = 0x33 << 13;
  Addr3 = Addr3 | 0x50000000;
  ReadData(Addr3, 0x00000000, 0x00000000, "WRD");

  /* Program the Low Power SDRAM extended mode register */
  /* Partial array refresh = 010, Temp. Compensated self refresh = 01 */
  /* To program the extended mode register program row as 0xA and Bank as 1 in
     address mapping */
  Addr3 = 0x4000A400;
  ReadData(Addr3, 0x00000000, 0x00000000, "WRD");
 
  /* Program I to "normal" */
  debug_info("Program I to NORMAL mode");
  WriteData(MPMCDyCntl, 0x00000003, "WRD");
  C("Configure DyConfig register");
  
  WriteData(MPMCDyConfig0, 0x148C0208, "WRD");

  WriteData(MPMCDyConfig1, 0x250C0880, "WRD");

  WriteData(MPMCDyConfig3, 0x148C0280, "WRD");
  C("Enable Protocol checker");
  WriteData(MPMCTrCR, 0x00000000, "WRD");
  Data = 0x44444444;
  Addr3 = 0x00000000;
  Addr3 = Addr3 | 0x40000000;
  C("Perform memory write operation");
  HSA(Addr3, NSEQ, INCR,OK,WRD);
  HSW(,Data++);
  for(i = 0; i < 200; i++)
    HSW(,Data++);
  Data = 0x44444444;
  HSA(Addr3, NSEQ, INCR,OK,WRD);
  HSR(,Data++, ,MaskALL);
  for(i = 0; i < 200; i++)
    HSR(,Data++, ,MaskALL);
}
/*-- --================================ End ================================--*/
