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
-- File Name              : SyncFlashCmdDelTest.c.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           It tests the functionality of controller for Micron SyncFlash 
--           with command delayed mode
--
--           TEST ID : MPMC_SyncFlashCmdDelTest_1
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************* SyncFlashCmdDelTest **************************/
/******************************************************************************/
void SyncFlashCmdDelTest()
{
  /* 
    Summary: SyncFlashCmdDelTest
    ============================
    This test the following functionalities
   
    o It does initialization of sync flash memory.

    o It reads device configuration and Manufacture ID.

    o It performs the memory write protect.
 
    o It checks for memory write and reads. For array read operations buffers
      are enabled

    o It also checks nRP bit.

    o All the above operations are done with command delayed mode.
  */

  int burst, csel, size,i,k,increment;
  char *sizetype[] = {"BYTE", "HWRD","WRD"};
  char *bursttype[] = {"sin","inc","in4","in8","i16","wr4","wr8",
                       "w16"};
  unsigned long data, Addr;
  int32 Mask[]={0x0000FFFF,0xFFFF0000};
  int col;
  int beats[8] = {1,1,4,8,16,4,8,16};
  C("TEST ID : MPMC_SyncFlashCmdDelTest_1");
  HSA(MPMCControl, NSEQ, INCR, OK, WRD);
  HSW(,0x00000001);
  C("Program MpmcConfig register before applying reset");
  HSA(MPMCConfig,NSEQ, INCR, OK, WRD);
  HSW(,0x00000300);
  WaitLoop(0x3);

  C("Program RdCfg register");
  HSA(MPMCDyRdCfg, NSEQ, INCR, OK, WRD);
  HSW(,0x1);

  WaitLoop(0x3);
  C("Apply reset");
  RES(LOW, ,);
  WaitLoop(0x3);
  C("Reprogram MpmcConfig register after applying reset");
  HSA(MPMCConfig,NSEQ, INCR, OK, WRD);
  HSW(,0x00000300);

  C("Initialize the syncflash and verify");
  TimingInit(2,6,8,5,6,5,4,7,7,4,2,3);

  HSA(MPMCDyRasCas0,NSEQ,INCR,OK,WRD);
  HSW(,0x00000302);

  HSA(MPMCDyRasCas1,NSEQ,INCR,OK,WRD);
  HSW(,0x00000302);

  HSA(MPMCDyRasCas2,NSEQ,INCR,OK,WRD);
  HSW(,0x00000302);

  HSA(MPMCDyRasCas3,NSEQ,INCR,OK,WRD);
  HSW(,0x00000302);

  /* Program DyConfig register */
  HSA(MPMCDyConfig0, NSEQ, INCR, OK, WRD);
  HSW(, 0x14800290);

  HSA(MPMCDyConfig1, NSEQ, INCR, OK, WRD);
  HSW(, 0x14804290);

  HSA(MPMCDyConfig2, NSEQ, INCR, OK, WRD);
  HSW(, 0x14804290);

  HSA(MPMCDyConfig3, NSEQ, INCR, OK, WRD);
  HSW(, 0x14800290);

  HSA(MPMCDyCntl, NSEQ, INCR, OK, WRD);
  HSW(, 0x00004003);

  /* Assert RP bit of MPMCDyCntl register */
  debug_info("Set RP bit in MPMCDyCntl");
  HSA(MPMCDyCntl,NSEQ,INCR, OK,WRD);
  HSW(, 0x00004000);

  C("Wait for 100us second");
  WaitLoop(50);
  /* Set I to MODE in MPMCDyCntl register  */
  debug_info("Enter MODE mode by programming MPMCyCntl");
  HSA(MPMCDyCntl,  NSEQ, INCR, OK, WRD);
  HSW(,0x00004083); /* RP = 1, I = 01, CS = 1, CE = 1 */

  /* Burst length = 8, burst type = 0(seq), cas lat = 3, opmode = std op,
     wr burst mode = 0  */

  WaitLoop(0x4);
  Addr = 0x233 << 11;
  HSA(Addr | 0x40000000, NSEQ, INCR, OK, WRD);
  HSR( , , ,MaskALL);

  Addr = 0x232 << 12;
  HSA(Addr | 0x50000000, NSEQ, INCR, OK, WRD);
  HSR( , , ,MaskALL);

  Addr = 0x232 << 12;
  HSA(Addr | 0x60000000, NSEQ, INCR, OK, WRD);
  HSR( , , ,MaskALL);

  Addr = 0x233 << 11;
  HSA(Addr | 0x70000000, NSEQ, INCR, OK, WRD);
  HSR( , , ,MaskALL);

  C(" Set I to NORMAL MODE in MPMCDyCntl register");
  /* RP = 1, I = 00, CS = 1, CE = 1  */
  debug_info("Program I = NORMAL Mode, RP = 1, CS = 1, CE = 1");
  HSA(MPMCDyCntl, NSEQ, INCR, OK, WRD);
  HSW(,0x00004003);
  WaitLoop(0x200);
  /* Clear status register */
  HSA(0x78000000, NSEQ, INCR, OK, HWRD);
  HSW(,0x00005000);
 
  C("Wait till SR7 becomes high before reading Read device ID");
  WaitLoop(700);

  /* Read device cofiguration */
  C("Read Manufacture compatibility ID");
  Addr = 0x0;
  Addr = Addr | 0x78000000;
  HSA(Addr,NSEQ, INCR, OK, HWRD);
  HSR(,0x0000002C, ,0x0000FFFF);
  C("Wait till SR7 becomes high before reading Read device ID"); 
  WaitLoop(200);
  HSA(0x7C000000, NSEQ, INCR, OK, WRD);
  HSR(,0x00000080, ,0x00000080);

  C("Read Device ID"); 
  Addr = 0x2;
  Addr = Addr | 0x78000000;
  HSA(Addr,NSEQ, INCR, OK, HWRD);
  HSR(,0x000000D3, ,0x000000FF); 
  
  C("Wait till SR7 becomes high before reading protect bit");
  WaitLoop(200);
  HSA(0x7C000000, NSEQ, INCR, OK, WRD);
  HSR(,0x00000080, ,0x00000080);

  C("Read device protect bit from Bank0,Block0");
  Addr = 0x4;
  Addr = Addr | 0x78000000;
  HSA(Addr, NSEQ, INCR, OK, HWRD);
  HSR(,0x00000000, ,0x00000001);

  C("Wait till SR7 becomes high");
  WaitLoop(200);
  HSA(0x7C000000, NSEQ, INCR, OK, WRD);
  HSR(,0x00000080, ,0x00000080);

  C("Read device protect bit from Bank1,Block1");
  Addr = 0x00200404;
  Addr = Addr | 0x78000000;
  HSA(Addr, NSEQ, INCR, OK, HWRD);
  HSR(,0x00000000, ,0x00000001); 

  C("Wait for ISM to ready to accept new command");
  WaitLoop(200);
  HSA(0x7C000000, NSEQ, INCR, OK, WRD);
  HSR(,0x00000080, ,0x00000080); 

  /* Program setup/confirm */
  C("Perform WRITE and READ operation");
  Addr = 0x70000420;
  data = 0x00003333;
  for(i = 0; i < 8; i++)
  {
     C("Perform memory access to syncflash");
     HSA(Addr,NSEQ,INCR, OK, HWRD);
     HSW(,data++);
     C("Wait till ISM is ready to take next command");
     WaitLoop(500);
     Addr = Addr + 2;
  }
  C("Perform write operation to CS4");
  HSA(0x40000420, NSEQ, INCR, OK, HWRD);
  HSW(,0x00005000);
  C("Wait till ISR is ready to take another instruction");
  WaitLoop(500);
  C("Perform another operation");
  HSA(0x40000422, NSEQ, INCR, OK, HWRD);
  HSW(,0x22232223);

  C("Perform write operation to CS5");
  HSA(0x50000420, NSEQ, INCR, OK, HWRD);
  HSW(,0x22222222);
  C("Wait till ISR is ready to take another instruction");
  WaitLoop(500);
  C("Perform another operation");
  HSA(0x50000422, NSEQ, INCR, OK, HWRD);
  HSW(,0x22232223); 
  WaitLoop(200);
  HSA(0x7C000000, NSEQ, INCR, OK, WRD);
  HSR(,0x00000080, ,0x00000080);

  C("Perform write operation to CS6");
  HSA(0x60000420, NSEQ, INCR, OK, HWRD);
  HSW(,0x55555555);
  C("Wait till ISR is ready to take another instruction");
  WaitLoop(500);
  C("Perform another operation");
  HSA(0x50000422, NSEQ, INCR, OK, HWRD);
  HSW(,0x55565556);
  WaitLoop(500);
  C("Enable the buffer to do the normal read operation");

  MPMCDisable();

  HSA(MPMCDyConfig0, NSEQ, INCR, OK, WRD);
  HSW(, 0x148C0290);

  HSA(MPMCDyConfig1, NSEQ, INCR, OK, WRD);
  HSW(, 0x148C4290);

  HSA(MPMCDyConfig2, NSEQ, INCR, OK, WRD);
  HSW(, 0x148C4290);

  HSA(MPMCDyConfig3, NSEQ, INCR, OK, WRD);
  HSW(, 0x148C0290);

  HSA(MPMCDyCntl, NSEQ, INCR, OK, WRD);
  HSW(, 0x00004003);

  MPMCEnable();

  Addr = 0x70000420;
  data = 0x00003333;
  C("Read data from CS7");
  HSA(Addr,NSEQ,INCR, OK, HWRD);
  HSR(,data++, ,0x0000FFFF);
  for(i = 1; i < 8; i++)
  {
    k = i % 2;
    HSR(,data++, ,Mask[k]);
  }
  C("Read data from CS4");
  HSA(0x40000420, NSEQ, INCR, OK, HWRD);
  HSR(, 0x00005000, , 0x0000FFFF);

  C("Read data from CS5");
  HSA(0x50000420, NSEQ, INCR, OK, HWRD);
  HSR(, 0x22222222, , 0x0000FFFF);
  C("Read data from CS6");
  HSA(0x60000420, NSEQ, INCR, OK, HWRD);
  HSR(, 0x55555555, , 0x0000FFFF);
  C("Disable the buffer to do the LCR/ACT/READ or WRITE operation");
  MPMCDisable();
  HSA(MPMCDyConfig0, NSEQ, INCR, OK, WRD);
  HSW(, 0x14800290);

  HSA(MPMCDyConfig1, NSEQ, INCR, OK, WRD);
  HSW(, 0x14804290);

  HSA(MPMCDyConfig2, NSEQ, INCR, OK, WRD);
  HSW(, 0x14804290);

  HSA(MPMCDyConfig3, NSEQ, INCR, OK, WRD);
  HSW(, 0x14800290);

  HSA(MPMCDyCntl, NSEQ, INCR, OK, WRD);
  HSW(, 0x00004003);

  MPMCEnable();

  C("Poll the status register");
  WaitLoop(6000);
  HSA(0x7C000000, NSEQ, INCR, OK, WRD);
  HSR(,0x00000080, ,0x00000080);

  C("Block protect block 1 of bank 1");
  /* HADDR[30:28] = 111,HADDR[27] = 1, BA[1:0] = 01 
     0x60h is protect setup 
     0x01 is for protect confirm */
  Addr = 0x400C08;
  HSA(Addr | 0x78000000, NSEQ, INCR, OK, HWRD);
  HSW(,0x00006001);

  C("Wait till ISM comes out of BUSY state");
  WaitLoop(6000);
  HSA(0x7C000000, NSEQ, INCR, OK, WRD);
  HSR(,0x00000080, ,0x00000080);

  C("Write 0 to nRP bit"); 
  HSA(MPMCDyCntl, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000003);
}
/*-- --================================ End ================================--*/
