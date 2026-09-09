/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : ClockTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Test to verify the Clock control unit of the MMCI
--
-- --=========================================================================*/

/******************************************************************************/
/****************************  CLOCK  Test ************************************/
/******************************************************************************/

void ClockTest (int32 clkdiv, int32 pwrsave, int32 bypass)
{
  /*
     Summary : ClockTest
     ===================

     In this test MMCICLOCK register is written with the clock divider
     value and the period of the MMCICLKOUT output is checked by the
     trickbox. Also, Bypass mode is set and the test is repeated.
     Pwrsave mode bit is set and some transfers are allowed to occur.
     Any differences between the programmed period of MMCICLKOUT and
     the actual period of the MMCICLKOUT signal are flagged as errors
     by the trickbox.
  */

  int32 pwrsaveand, bypassand, clkdivand;
  clkdivand  = clkdiv & CLKDIV_MASK;
  CLKDIV = clkdivand;
  pwrsaveand = (pwrsave & 0x00000001) << 9;
  bypassand  = (bypass & 0x00000001) << 10;

  PSW(clkdivand | pwrsaveand | bypassand | CLKENB, MMCIClock);
  Idle((((MCLK_PERIOD/PCLK_PERIOD) + 1) * (2 * (CLKDIV + 1))) * 0xA);
  PSW(0x00000000,MMCITBPCDisable);

  PO(0x00000000, CMDACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATA_5s, MMCIArgument);
  local = CMDINDEXFF | NORESP_LONGRSP_CLR | COMMANDENB;
  PSW(local, MMCICommand);
  if (pwrsave == 1)
    Idle((((MCLK_PERIOD/PCLK_PERIOD) + 1) * (2 * (CLKDIV + 1))) * 0xA);

  Idle((((MCLK_PERIOD/PCLK_PERIOD) + 1) * (2 * (CLKDIV + 1))) * 0x3A);
  PSW(DATA_0s, MMCICommand);
}

/*******************************  End  ****************************************/
