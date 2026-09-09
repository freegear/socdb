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
-- File Name              : PowerControlTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Tests to verify that the Power control bits are used
--           by the MMCI to control MMCICLKOUT generation and the
--           tri-stating of the MMCICMDOUT and MMCIDATOUT lines
--
-- --=========================================================================*/

/******************************************************************************/
/****************************  POWERCONTROL  Test *****************************/
/******************************************************************************/

void PowerControlTest ()
{
 /*
    Summary : Power Control Test
    ============================
    In this test the power is switched off by writing into MMCIPower
    register. The Clock is enabled and a ClkDiv value is programmed
    into the Clock Control register. Then the voltage values are
    changed to all possible combinations. The protocol checkers in the
    Trickbox verify that all the outputs from the MMCI are disabled
    during the power - off phase. Any discrepancies are flagged as
    errors by the trickbox.
    The power control register is programmed for power - up phase. The
    Clock is enabled in the Clock Control register with the ClkDiv
    value programmed. Then the voltage values are changed in Power
    Control register. Then the Bypass mode in the Clock Control
    register is enabled. The protocol checkers in the Trickbox verify
    that all the outputs from the MMCI are disabled during the power-up
    phase.
    The above test is repeated with Power Control register programmed
    for power - on mode. In this mode all the outputs and the MMCICLKOUT
    is active.
    Finally again the power is switched off and the outputs are
    monitored by the trickbox for any protocol violations.
 */

  int32 voltage, voltageshift;
  int i;

  /* POWER - OFF phase */

  voltage = 0x00000000;
  voltageshift = 0x00000000;
  PO(0x00000000, CMDACTIVE, MMCIStatus,0x0000FFFF);
  PSW(CLKDIV1 | CLKENB, MMCIClock);
  CLKDIV = 0x1;
  PSW(DATA_As, MMCIArgument);
  PSW(0xFFFE, MMCITBPCDisable);
  local = CMDINDEXFF | NORESP_LONGRSP_CLR | COMMANDENB;
  PSW(local, MMCICommand);
  for (i=0; i<16; i++)
    {
      PSW(voltageshift | POWEROFF, MMCIPower);
      voltage = voltage + 0x00000001;
      voltageshift = voltage << 2;
      if (i == 8)
        PSW(CLKDIV1 | CLKENB | BYPASSENB, MMCIClock);
        Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
              ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);

    }
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x10);


  /* POWER - UP phase */

  voltage = 0x00000000;
  voltageshift = 0x00000000;
  PSW(CLKDIV1 | CLKENB, MMCIClock);
  CLKDIV = 0x1;
  PSW(DATA_Fs, MMCIArgument);
  local = CMDINDEXFF | NORESP_LONGRSP_CLR | COMMANDENB;
  PSW(local, MMCICommand);
  for (i=0; i<16; i++)
    {
      PSW(voltageshift | POWERUP, MMCIPower);
      voltage = voltage + 0x00000001;
      voltageshift = voltage << 2;
        Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
              ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);
    }
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x10);

  /* POWER - ON phase */

  voltage = 0x00000000;
  voltageshift = 0x00000000;
  PSW(CLKDIV1 | CLKENB, MMCIClock);
  CLKDIV = 0x1;
  PSW(DATA_5s, MMCIArgument);
  local = CMDINDEXFF | NORESP_LONGRSP_CLR | COMMANDENB;
  PSW(local, MMCICommand);
  for (i=0; i<16; i++)
    {
      PSW(voltageshift | POWERON, MMCIPower);
      voltage = voltage + 0x00000001;
      voltageshift = voltage << 2;
      Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
            ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);
    }
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x3A);

  /* With open drain bit set */

  voltage = 0x00000000;
  voltageshift = 0x00000000;
  PSW(CLKDIV1 | CLKENB, MMCIClock);
  CLKDIV = 0x1;
  PSW(DATA_5s, MMCIArgument);
  local = CMDINDEXFF | NORESP_LONGRSP_CLR | COMMANDENB;
  PSW(local, MMCICommand);
  for (i=0; i<16; i++)
    {
      PSW(voltageshift | OPENDRAINEN | POWERON, MMCIPower);
      voltage = voltage + 0x00000001;
      voltageshift = voltage << 2;
      Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
            ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);
    }
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x3A);

  /* With open drain bit and open drain resistor enable set */

  voltage = 0x00000000;
  voltageshift = 0x00000000;
  PSW(CLKDIV1 | CLKENB, MMCIClock);
  CLKDIV = 0x1;
  PSW(DATA_5s, MMCIArgument);
  local = CMDINDEXFF | NORESP_LONGRSP_CLR | COMMANDENB;
  PSW(local, MMCICommand);
  for (i=0; i<16; i++)
    {
      PSW(voltageshift | 0x000000D3, MMCIPower);
      voltage = voltage + 0x00000001;
      voltageshift = voltage << 2;
      Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
            ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);
    }
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x3A);
}

/*******************************  End  ****************************************/
