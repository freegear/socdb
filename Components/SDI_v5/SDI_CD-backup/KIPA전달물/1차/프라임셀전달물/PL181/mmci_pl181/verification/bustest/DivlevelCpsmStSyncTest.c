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
-- File Name              : DivlevelCpsmStSyncTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Test to hit the case where the CpsmStPulse and the Divlevel
--           occur in the same clock
--
-- --=========================================================================*/

void DivlevelCpsmStSyncTest(void)
{
  /*
    Summary : DivlevelCpsmStSyncTest
    ================================
   This test aims at testing a particular case in the CPSM which
   doesn't occur oftenly.CPSM uses Divlevel signal to qualify the
   last MCLK contained in each MMCICLK.Similarly, a CPSMStPulse signal
   heralds the start of CPSM transmission.The design allows CPSM
   enabling anytime after the previous transfer has ended, this
   enabling is captured by CPSMSt and latched onto CPSMStL till
   the CPSM can actually start transmission.
   This test aims at avoiding the latching described in the above
   process and is coded in such a way to align CPSMStPulse with
   Divlevel.
   This test is to hit the case where the CpsmStPulse and the Divlevel
   occur in the same clock, that is the CpsmStPulse is issued at the
   last Mclk contained in that paticular Mmciclk.This test will be
   hitting the above said case with Pclk = Mclk = 10 ns and a
   clkdiv value of 1.
  */

  PSW(0x00010000,MMCITBPCDisable);
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x0A);
  PSW(CLKDIV1 | CLKENB | PWRSAVE, MMCIClock);
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x0A);
  PSW(0x00010000,MMCITBPCDisable);
  CLKDIV = 0x1;
  PSW(DATA_5s, MMCIArgument);
  local = CMDINDEXFF | NORESP_LONGRSP_CLR | COMMANDENB;
  PSW(local, MMCICommand);

  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x3A);
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x3A);

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  Idle((MCLK_PERIOD/PCLK_PERIOD) * 2);
  local = CMDINDEX3A | NORESP_LONGRSP_CLR | COMMANDENB;
  PSW(local, MMCICommand);
}

/*******************************  End  ****************************************/
