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
-- File Name              : CPSMDisableTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Test to verify CPSM operation when disabled in each of
--           its states
--
-- --=========================================================================*/

/******************************************************************************/
/****************************  CPSMDISABLE  Test ******************************/
/******************************************************************************/

void CPSMDisableTest()
{
  /* Summary : CPSM disable test
     ===========================
     This test disables CPSM when the MMCI CPSM is in each of its states.
     The condition to bring the FSM to each state is given below.

     To target PEND State in CPSM:
     -----------------------------
     The Pending bit in the
     Command register is set, the Data Control register is set for
     stream mode and the DataCounter register is loaded with a count
     of 8 (larger than 6) . The MMCI DPSM is configured for transmitting
     data. The CPSM and the DPSM are enabled. The CPSM enters the
     PEND state where it waits for the Pend pulse from the DPSM. The
     DPSM, however, issues the Pend pulse only when 6 data bytes remain
     to be transmitted. With the CPSM in the PEND state, the CPSM is
     disabled.

     To target SEND state in CPSM:
     -----------------------------
     The CPSM is enabled for transmission. After a few idle cycles
     when it is ensured that the CPSM is in the SEND state, the
     CPSM is disabled.

     To target WAIT state in CPSM:
     -----------------------------
     The Command Timer register
     in the trickbox is programmed with 60. The Response bit is set in
     the Command register, and the LongRsp bit cleared in Command
     register. The command transfer is initiated. Idle cycles are
     inserted for a duration corresponding to 48 MMCICLKOUT periods,
     after which the CPSM is expected to enter the WAIT state.
     Then the CPSM is disabled.
  */

  PSW(POWERON | VOLTAGE3, MMCIPower);

  /* To target PEND State in CPSM */

  PSW(0x0000FFFF, MMCITBPCDisable);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000001F, MMCITBDataTimer);
  PSW(CLKDIV1 | CLKENB, MMCIClock);

  PSW(DATA_As, MMCIArgument);
  PO(0x00000000, CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | NORESP_LONGRSP_SET | COMMANDENB | PENDINGMODE;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);

  PSW(0x00000008, MMCIDataLength);
  Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 2);
  PSW(DATATXRENB | STREAMMODE, MMCIDataCtrl);
  PO(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATA_As, MMCIFIFO);
  PSW(DATA_As, MMCIFIFO);

  Idle((DELAY) * 0xA);
  PSW(DATA_0s, MMCICommand);
  C("CPSM DISABLED IN PEND STATE");

  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x40);
  /* 64 MMCICLK's wait for command transfer to end */
  PSW(0x00000000, MMCITBPCDisable);
  PSW(TBRESET, MMCITBControl);
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x0A);
  PSW(DATA_0s, MMCITBControl);

/* To target RECEIVE State in CPSM */

  PSW(0x00000011, MMCITBCmdResponse);
  PSW(DATA_5s, MMCITBResponse0);
  PSW(DATA_5s, MMCITBResponse1);
  PSW(DATA_5s, MMCITBResponse2);
  PSW(DATA_5s, MMCITBResponse3);
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x0A);

  PSW(0x00000004, MMCITBRespTimer);
  local = CMDINDEXFF | SHORTRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x9);
  /* 9 MMCICLK's wait for command transfer to start */

  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x30);
  /* 48 MMCICLK's wait for command transfer to end */

  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x0C);
  /* 12 MMCICLK's wait in the receive state */

  PSW(DATA_0s, MMCICommand);
  C("CPSM DISABLED IN RECEIVE STATE");
  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);

  PSW(0x00000004, MMCITBRespTimer);
  local = CMDINDEXFF | SHORTRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x9);
  /* 9 MMCICLK's wait for command transfer to start */

  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x30);
  /* 48 MMCICLK's wait for command transfer to end */

  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x50);
  /* wait for reception to be complete */

  /* To target SEND State in CPSM */

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  CLKDIV = 0x1;

  PO(0x00000000, CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | NORESP_LONGRSP_SET | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);

  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x0F);
  /* 15 MMCICLK's wait for command transfer to start */

  PSW(DATA_0s, MMCICommand);
  C("CPSM DISABLED IN SEND STATE");

  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x0B);
  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);

/* To target WAIT State in CPSM */

  PSW(0x0000003C, MMCITBRespTimer);
  local = CMDINDEXFF | SHORTRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x9);
  /* 9 MMCICLK's wait for command transfer to start */

  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x30);
  /* 48 MMCICLK's wait for command transfer to end */

  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x1F);
  /* 31 MMCICLK's wait in the WAIT state */

  PSW(DATA_0s, MMCICommand);
  C("CPSM DISABLED IN WAIT STATE");
  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);

}

/*******************************  End  ****************************************/
