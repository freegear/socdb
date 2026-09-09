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
-- File Name              : SdramInitRtnChk.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--       This test performs the initialization routine
--
--       TEST ID : MPMC_SdramInit
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************* SdramInitRtnChk ******************************/
/******************************************************************************/
void SdramInitRtnChk(void)
{
  /*
     Summary: SdramInitRtnChk
     ========================
     This test verifies the following functionalities

     o  It checks whether the proper initialization sequence of Sdram is
        followed or not.

     o  Proper sequences can be verified by looking at the InitChk bit of 
        MPMCTrSr register. 
   
     o  It also performs sram access in between the sdram initialization.
  */
  int i;
  int trans8[5] = {2,3,3,3,5};
  unsigned long Addr1,Addr2,Addr3,Addr4;
  C("TEST ID : MPMC_SdramInit");
  /* Initialise the controller registers */

  StInitProc(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[0],
               0x0);
  /* Disable Address Mirror bit */
  WriteData(MPMCControl, 0x00000001, "WRD");

  Sequence('w',0x00000060, trans8,"in4",0,0x55555555,0);
  C("Initialize controller register");
  WriteData(MPMCDyRasCas0, 0x00000302, "WRD");

  WriteData(MPMCDyRasCas1, 0x00000302, "WRD");

  WriteData(MPMCDyRasCas2, 0x00000302, "WRD");
  /* Program Expected no of refresh cycles for protocol */
  WriteData(MPMCTrExpRef, 0x8, "WRD");

  /* Program the timing values */
  TimingInit(2,5,8,0,5,5,0,7,7,0,2,3);
  /* Program DyConfig register */

  WriteData(MPMCDyConfig0, 0x14C00680, "WRD");

  WriteData(MPMCDyConfig1, 0x10804500, "WRD");

  WriteData(MPMCDyConfig2, 0x10800080, "WRD");

  WriteData(MPMCDyConfig3, 0x14800280, "WRD");

  /* Program MPMCConfig register - use CLK ratio as 1 : 1 and 
     endian as little */

  WriteData(MPMCConfig, 0x00000000, "WRD");

  /* Set InitSeq and InitCheckEn bits of MPMCTrSR register */
  debug_info("Set InitSeq and InitCheckEn bits of MPMCTrSR");
  WriteData(MPMCTrSR, 0x00000003, "WRD");
  /* Wait for 200us by performing dummy read operation which consumes two */ 
  /* clock cycles for each operation */
  /* HCLK = 66MHz and HCLK:MPMCCLK = 1 : 1 */
  C("Wait for 200us");
  WaitLoop(50);
  /* Apply NOP */
  WriteData(MPMCDyCntl, 0x00000180, "WRD");
  WaitLoop(0x2); 
  /* Issue Precharge by writing 10 to I field of MPMCDyCntl */
  debug_info("Program Sdram Initialization field to PALL");
  WriteData(MPMCDyCntl, 0x00000100, "WRD");

  Sequence('r',0x00000060, trans8,"in4",0,0x55555555,0);
  /* write a small value to refresh register */
  WriteData(MPMCDyRef, 0x00000001, "WRD");

  WaitLoop(0x80);
  /* Program the operational value to REFRESH field */
  debug_info("Program MPMCDyRef register");
  WriteData(MPMCDyRef, 0x000000AA, "WRD");

  /* Set I to MODE */
  debug_info("Program Sdram Initialization to MODE");
  WriteData(MPMCDyCntl, 0x00000080, "WRD");

  /* Configure the mode register for its burst length, burst type, CAS latency,
     operating mode, write burst mode by performing a read operation */

  /* burst length = 4 for CS6 and 8 for CS4 and CS5, burst = seq,CAS 
     latency = 3 , operating mode = 0, write burst mode = 0 ,BA0 & BA1 = 0 */
  Addr1 = (0x33 << 12); 

  Addr2 = (0x32 << 12);

  Addr3 = (0x33 << 10);

  Addr4 = (0x33 << 11);

  C("Program mode register");
  Addr1 = Addr1 | 0x40000000;
  Addr2 = Addr2 | 0x50000000;
  Addr3 = Addr3 | 0x60000000;
  Addr4 = Addr4 | 0x70000000;

  ReadData(Addr1, 0x00000000, 0x00000000, "WRD");

  ReadData(Addr2, 0x00000000, 0x00000000, "WRD");
  
  ReadData(Addr3, 0x00000000, 0x00000000, "WRD");

  ReadData(Addr4, 0x00000000, 0x00000000, "WRD");
  
  /* Program sync refresh with the relevent values */
  debug_info("Program refresh counter");
  WriteData(MPMCDyRef, 0x00000010, "WRD");

  /* Program I to Normal Mode */
  debug_info("Program Sdram initialization to Normal Mode");
  WriteData(MPMCDyCntl, 0x00000000, "WRD");

  /* Reprogram Configuration register */
  WriteData(MPMCDyConfig0, 0x14CC0480, "WRD");

  WriteData(MPMCDyConfig1, 0x108C4300, "WRD");

  WriteData(MPMCDyConfig2, 0x108C0080, "WRD"); 

  WriteData(MPMCDyConfig3, 0x148C0280, "WRD");

  /* Check for error in the initialisation sequence */
  /* Bit 1 of the MPMCTrSR register is set when there is error in 
     initialization */
  debug_info("Check for whether Error has happened during initialization");
  ReadData(MPMCTrSR, 0x00000000, 0x00000000, "WRD");

  /* Clear the error bit by writing to InitSeqSt bit of MPMCTrSR */
  debug_info("Clear error bit of MPMCTrSR");
  WriteData(MPMCTrSR, 0x00000002, "WRD");
}
/*-- --================================ End ================================--*/
