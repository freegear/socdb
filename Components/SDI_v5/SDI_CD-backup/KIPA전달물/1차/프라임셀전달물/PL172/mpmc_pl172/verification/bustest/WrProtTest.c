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
-- File Name              : WrProtTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This test verifies the Write Protect functionality(P field) of 
--           MPMCStConfig(0,1,2,3) and MPMCDyConfig(0,1,2,3) registers
--
--           TEST ID : MPMC_WrProt_1
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************** WrProtTest **********************************/
/******************************************************************************/
void WrProtTest(void)
{
  /* 
    Summary: WrProtTest
    ===================
    This test performs the following functionalities:

    o  Write 1 to Write Protect bit of all chip selects.

    o  Perform write operation over these memory.

    o  Verify that response is ERROR.
  */

  unsigned long Addr,chpsel,Data;
  int i;
  C("TEST ID : MPMC_WrProt_1");
  HSA(MPMCControl, NSEQ, INCR, OK, WRD);
  HSW(,0x00000001);
  C("Initialize SDRAMs");
  TimingInit(2,5,8,0,5,3,0,7,7,0,2,3);
  SyncInitializeProc(
                     2, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     0,1,0,0,1,1,1,1,2,0,2,
                     0,0,0,0,0,1,1,1,3,0,0,
                     0,0,1,0,0,1,1,1,3,0,2,
                     0,0,2,0,1,1,1,1,3,1,2,
                     11,11,12,14,
                     0,
                     0
                    );
  C("Initialize static config registers");
  /* Set Bank 0 Memory Type as SRAM (32 bits width) with write protect */
  StInitProc(0,2,0,0,1,0,1,1,1,0x1,0x1,0x1,0x2,0x0,0x1,0x3);

  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  StInitProc(1,1,0,0,1,0,1,1,1,0x1,0x1,0x1,0x1,0x2,0x1,0x3);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  StInitProc(2,0,0,0,0,0,1,1,1,0x1,0x1,0x1,0x1,0x2,0x1,0x3);

  /* Set Bank 3 Memory Type as SRAM (32 bits width) with buffers disabled */
  StInitProc(3,2,0,0,0,0,0,0,1,0x1,0x1,0x1,0x1,0x2,0x1,0x3);

  C("Write to write protected memory and verify that response is E R R O R");
  for(i = 0; i < 8; i++)
  {
    Addr = rand() & 0x0FFFFFFC;
    Addr = (Addr | i << 28);

    HSA(Addr, NSEQ, INCR, ERROR, WRD);
    HSW(,0xFFFFFFFF);
  }
}
/*-- --================================ End ================================--*/
