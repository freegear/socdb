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
-- File Name              : CSPolarityTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function tests the functionality of the polarity(PC) bit of 
--           MPMCStaticConfig registers
--
--           TEST ID : MPMC_CSPol_1
--
-- --=======================================================================--*/
/******************************************************************************/
/****************************** CSPolarityTest ********************************/
/******************************************************************************/
void CSPolarityTest(void)
{
  /*
     Summary: CSPolarityTest
     =======================
     This test checks the following functionalities:

     o Write zero to PC bit of MPMCStaticConfig register and verify that 
       chip select is active low.

     o Write one to PC bit of MPMCStaticConfig register and verify that 
       chip select is active high. 
    
     o Access the memory in both cases and check the data integrity.
  */
  int i;
  char debugstr[100];
  unsigned long addr;
  unsigned long AddrArr[3] = {0x00000030,0x10000030,0x20000030}; 
  int32 addr1, addr2, addr3;
  unsigned long DataArr[3] = {0x66666666,0xFFFFFFFF,0x55555555};

  C("TEST ID : MPMC_CSPol_1");
  WriteData(MPMCControl,0x00000001,"WRD");
  C("Configuring controller and TrickMem");
  debug_info("Switch off Protocol checker");
  WriteData(MPMCTrCR,0x00000010,"WRD");
  /* Set Bank 0 Memory Type as SRAM (32 bits width) */
  C("Initialize Bank0 registers and trickmem0");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);

  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Initialize Bank1 registers and trickmem1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(1,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  C("Initialize Bank2 registers and trickmem2");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,0x3);
  TrickMemInit(2,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (32 bits width) */
  C("Initialize Bank3 registers and trickmem3");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(3,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);
   
  debug_info("Switch on Protocol checker");
  WriteData(MPMCTrCR, 0x00000000, "WRD");
  /* Assert POLARITY lines of all ports from trickbox and verify */ 
  debug_info(" Asserting POLARITY lines of all ports from trickbox");
  /* Logic low chip select */
  C("Assert all chip selects polarity low through trickbox");
  WriteData(MPMCTrStaticCS, 0x00000000, "WRD");
  debug_info("Low Polarity for CS0");
  WriteData(MPMCTrCSPOL_0, 0x00000000, "WRD");
 
  debug_info("Low Polarity for CS1");
  WriteData(MPMCTrCSPOL_1, 0x00000000, "WRD");

  debug_info("Low Polarity for CS2");
  WriteData(MPMCTrCSPOL_2, 0x00000000, "WRD");

  debug_info("Low Polarity for CS3");
  WriteData(MPMCTrCSPOL_3, 0x00000000, "WRD");
  
  WriteData(MPMCTrMEMT_0, 0x40, "WRD");

  WriteData(MPMCTrMEMT_1, 0x40, "WRD");

  WriteData(MPMCTrMEMT_2, 0x0, "WRD");

  WriteData(MPMCTrMEMT_3, 0x00, "WRD");

  WaitLoop(0x3);
  /* Apply Reset */
  CSPOReset();
  WaitLoop(0xA);
  C("Disable Address Mirror bit");
  WriteData(MPMCControl, 0x00000001, "WRD");
  WaitLoop(0x2);
  /* Write and read data back with single burst, byte and mw as 32 bits to
     bank1  with buffer disabled */
  
  /* Set Bank 3 Memory Type as ROM (32 bits width) with buffers disabled */
  MPMCTrMEMBData[3] = 0x00000000;

  CSPolWriteRead(3,0,0x8,0,0,0x11111111,0);
  
  debug_info("Switch off Protocol checker");
  WriteData(MPMCTrCR, 0x00000010, "WRD");
  C("Reconfiguring Bank0 registers");
  StInitProc(0,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);

  C("Reconfiguring Bank1 registers");
  StInitProc(1,0,0,1,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(1,0,0,1,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);

  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Reconfiguring Bank2 registers");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(2,0,0,1,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(2,0,0,1,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  C("Reconfiguring Bank3 registers");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(3,0,0,1,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,0x3);
  TrickMemInit(3,0,0,1,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,MPMCTrMEMBData[2],
               0x0);

  debug_info("Switch on Protocol checker");
  WriteData(MPMCTrCR, 0x00000000, "WRD");
  CSPolWriteRead(3,0,0x8,0,0,0x11111111,0);

  C("Assert all chip selects high through trickbox");
  WriteData(MPMCTrStaticCS, 0x0000000F, "WRD");

  debug_info("Logic HIGH chip select for CS0");
  WriteData(MPMCTrCSPOL_0, 0x0000000F, "WRD");

  debug_info("Logic HIGH chip select for CS1");
  WriteData(MPMCTrCSPOL_1, 0x0000000F, "WRD");

  debug_info("Logic HIGH chip select for CS2");
  WriteData(MPMCTrCSPOL_2, 0x0000000F, "WRD");

  debug_info("Logic HIGH chip select for CS3");
  WriteData(MPMCTrCSPOL_3, 0x0000000F, "WRD");
  

  WriteData(MPMCTrMEMT_0, 0x80, "WRD");

  WriteData(MPMCTrMEMT_1, 0x80, "WRD");

  WriteData(MPMCTrMEMT_2, 0x80, "WRD");

  WriteData(MPMCTrMEMT_3, 0x80, "WRD");

  /* Apply Reset */
  CSPOReset();
  WaitLoop(0xA); 
  WriteData(MPMCControl, 0x00000001, "WRD");
  WaitLoop(0x2);
  /* Write and read data back with single burst, byte and mw as 32 bits to
     bank1  with buffer disabled */

  CSPolWriteRead(3,0,0x8,0,0,0x11111111,0);

  /* Write and read data back with single burst, byte and mw as 32 bits to
     bank0  with buffer disabled */
  debug_info("Switch off Protocol checker");
  WriteData(MPMCTrCR, 0x00000010, "WRD");
  C("Reconfiguring Bank0 registers");
  StInitProc(0,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);

  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Reconfiguring Bank1 registers");
  StInitProc(1,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(1,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */ 
  C("Reconfiguring Bank2 registers");
  StInitProc(2,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,0x3);
  TrickMemInit(2,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,MPMCTrMEMBData[2],
               0x0);

  C("Reconfiguring Bank3 registers");
  StInitProc(3,2,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(3,2,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);

  debug_info("Switch on Protocol checker");
  WriteData(MPMCTrCR, 0x00000000, "WRD");
  CSPolWriteRead(2,0,0x4,0,0,0x11111111,0);

  WaitLoop(0x16);
  /* Assert chip select of CS0 as 0, CS1 as 1, CS2 as 0 and CS3 as 1 */
  
  WriteData(MPMCTrStaticCS, 0x0000000A, "WRD");

  WriteData(MPMCTrCR, 0x00000010, "WRD");

  WriteData(MPMCTrMEMT_0, 0x00, "WRD");

  WriteData(MPMCTrMEMT_1, 0x80, "WRD");

  WriteData(MPMCTrMEMT_2, 0x40, "WRD");

  WriteData(MPMCTrMEMT_3, 0x80, "WRD");

  WriteData(MPMCTrCSPOL_0, 0xA, "WRD");

  WriteData(MPMCTrCSPOL_1, 0xA, "WRD");

  WriteData(MPMCTrCSPOL_2, 0xA, "WRD");

  WriteData(MPMCTrCSPOL_3, 0xA, "WRD");

  /* Apply nPOR */
  CSPOReset();
  WaitLoop(0xA);
  WriteData(MPMCControl, 0x00000001, "WRD");
  WaitLoop(0x2);
  CSPolWriteRead(0,0,0x4,1,0,0x22222222,0);
  WaitLoop(0x16);

  debug_info("Switch off Protocol checker");
  WriteData(MPMCTrCR, 0x00000010, "WRD");

  C("Reconfiguring Bank0 registers");
  StInitProc(0,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);


  /*  Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Reconfiguring Bank1 registers");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(1,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0);

  /*  Set Bank 2 Memory Type as SRAM (8 bits width) */
  C("Reconfiguring Bank2 registers");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,0,0,1,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,0x3);
  TrickMemInit(2,0,0,1,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,MPMCTrMEMBData[2],
               0x0);
  
  C("Reconfiguring Bank3 registers");
  StInitProc(3,0,0,1,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(3,0,0,1,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);
 
  debug_info("Switch on Protocol checker");
  WriteData(MPMCTrCR, 0x00000000, "WRD");

  CSPolWriteRead(0,0,0x8,1,0,0x11111111,0);
  CSPolWriteRead(1,0,0x0,1,0,0x22222222,0);
  CSPolWriteRead(2,0,0xC,1,0,0x55555555,0);
  CSPolWriteRead(3,0,0x4,1,0,0x66666666,0); 
 
  C("Reprogram registers");
  debug_info("Switch off Protocol checker");
  WriteData(MPMCTrCR, 0x00000010, "WRD");

  C("Reconfiguring Bank0 registers");
  StInitProc(0,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);

  C("Reconfiguring Bank1 registers");
  StInitProc(1,1,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,0x3);
  TrickMemInit(1,1,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,MPMCTrMEMBData[2],
               0x0);

  C("Reconfiguring Bank2 registers");
  StInitProc(2,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(2,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);

  C("Reconfiguring Bank3 registers");
  StInitProc(3,1,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(3,1,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0);

  debug_info("Switch on Protocol checker");
  WriteData(MPMCTrCR, 0x00000000, "WRD");

  /* Program CS1 as 01(16 bits)  and polarity as 0 */
  WriteData(MPMCTrStaticCS, 0x00000010, "WRD");
 
  WriteData(MPMCTrCSPOL_0, 0x00000000, "WRD");

  WriteData(MPMCTrCSPOL_1, 0x00000000, "WRD");

  WriteData(MPMCTrCSPOL_2, 0x00000000, "WRD");

  WriteData(MPMCTrCSPOL_3, 0x00000000, "WRD");

  /* Apply nPOR */
  C("Apply nPOR");
  CSPOReset();
  WaitLoop(0xA);
  WriteData(MPMCControl, 0x00000001, "WRD");
  WaitLoop(0x2);
  C("Write and  read the data back with MW specified by the external pins");
  CSPolWriteRead(1,0,0x0,2,1,0x22222222,0);
}
/*-- --================================ End ================================--*/
