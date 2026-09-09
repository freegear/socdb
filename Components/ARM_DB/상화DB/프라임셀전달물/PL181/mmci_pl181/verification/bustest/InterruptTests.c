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
-- File Name              : InterruptTests.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Tests to verify Interrupt generation by the MMCI
--
-- --=========================================================================*/

/******************************************************************************/
/****************************  MMCI INTERRUPT TEST  ***************************/
/******************************************************************************/

void InterruptTests()
{
  /*
  Summary: MMCI Interrupt Tests
  ============================

  o In these tests the interrupt masks are enabled and the interrupt
    conditions are created. Later the status flag is read out from UUT
    and the interrupt flags are read out from trickbox to verify that
    the relevant interrupts are asserted. It is also verified that each
    of the Status flags, is routable to the interrupt lines by suitably
    programming the Mask registers.
    The common steps are given below
    - Program MMCIMask0 in the UUT to route the flag being tested to
      MMCIINTR0
    - Create the interrupting condition in the UUT
    - Verify, by reading the MMCITBSIGSTAT register in the trickbox,
      that MMCIINTR0 is asserted
    - Clear MMCIMask0 in the UUT
    - Verify, by reading the MMCITBSIGSTAT register in the trickbox,
      that MMCIINTR0 and MMCIINTR1 are cleared
    - Program MMCIMask1 in the UUT to route the flag being tested to
      MMCIINTR1
    - Verify, by reading the MMCITBSIGSTAT register in the trickbox,
      that MMCIINTR1 is asserted
    - Clear the Status flag in UUT
    - Verify, by reading the MMCITBSIGSTAT register in the trickbox,
      that MMCIINTR1 is cleared
  */

  /* Command CRC Fail
     ================
     First the trickbox and the UUT are programmed with Command
     response bit set. The trickbox is programmed to give a wrong CRC
     in the command Response. The CPSM in the UUT is enabled and
     Command transfer is initiated. The CmdCrcFail bit in the MMCIStatus
     register is then polled. It is expected that this bit is set at
     the end of the Command transfer.
     This test is again repeated with the LongRsp bit set in the
     Command register.
  */

  int i;
  int PollWait;
  int CLKS;

  if (PCLK_PERIOD < MCLK_PERIOD)
    CLKS = 1;
  else
    CLKS = PCLK_PERIOD / MCLK_PERIOD;

  PSW(POWERON | VOLTAGE3, MMCIPower);

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  CLKDIV = CLKDIV1;
  PSW(0x00000009, MMCITBRespTimer);
  PSW(0x00000004, MMCISelect);
  PSW(CLEARALL, MMCIClear);

  C("Testing Command CRC Fail Interrupt");

  PSW(0x00000001, MMCIMask0);
  PSW(WRONGCMDCRC, MMCITBControl);
  PSW(DATA_As, MMCIArgument);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | SHORTRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PSW(0x0000003F, MMCITBCmdResponse);
  PSW(DATA_Fs, MMCITBResponse0);
  PollWait = ((8 + 48 + 48 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000001, 0x00000001, PollWait);

  PSW(0x00000001, MMCIMask0);
  PSW(WRONGCMDCRC, MMCITBControl);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | LONGRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PSW(DATA_Fs, MMCITBResponse0);
  PSW(DATA_5s, MMCITBResponse1);
  PSW(DATA_As, MMCITBResponse2);
  PSW(0x7FFFFFFF, MMCITBResponse3);
  PollWait = ((8 + 48 + 136 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000001, 0x00000001, PollWait);

  C("End of Command CRC Fail Interrupt Test");

  /* Command Response End Interrupt Test
     ===================================
     This test and CmdCRC fail test are complimentary. In this test,
     the trickbox is programmed to give a correct CRC. The response bit
     in the Command register is set, and the command transfer is
     initiated. The CmdRespEnd flag in the UUT is expected to be set at
     the end of Command transfer.
     The test is repeated for long response mode.
  */

  C("Testing Command Response End Interrupt");

  PSW(0x00000040, MMCIMask0);
  PSW(DATA_0s, MMCITBControl);
  PSW(DATA_Fs, MMCIArgument);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | SHORTRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PSW(0x0000001F, MMCITBCmdResponse);
  PSW(DATA_5s, MMCITBResponse0);
  PollWait = ((8 + 48 + 48 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000040, 0x00000040, PollWait);

  PSW(0x00000040, MMCIMask0);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | LONGRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PSW(DATA_5s, MMCITBResponse0);
  PSW(DATA_As, MMCITBResponse1);
  PSW(DATA_Fs, MMCITBResponse2);
  PSW(0x7FFFFFFF, MMCITBResponse3);
  PollWait = ((8 + 48 + 136 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000040, 0x00000040, PollWait);

  C("End of Command Response End Interrupt Test");

  /* Command Sent Interrupt test
     ===========================
     This interrupt is tested by writing 0 to the response bit of
     Command register and initiating a command transfer between the
     Trickbox and the UUT. In this mode the UUT does not expect a
     response from trickbox. The CmdSent flag is expected to be set
     at the end of Command transfer.
     The test is repeated for long response mode
  */
  C("Testing Command Sent Interrupt");

  PSW(0x00000080, MMCIMask0);
  PSW(DATA_0s, MMCITBControl);
  PSW(DATA_5s, MMCIArgument);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | NORESP_LONGRSP_CLR | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PollWait = ((48 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000080, 0x00000080, PollWait);

  PSW(0x00000080, MMCIMask0);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | NORESP_LONGRSP_SET | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PollWait = ((48 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000080, 0x00000080, PollWait);

  C("End of Command Sent Interrupt Test");

  /* Command Active Interrupt test
     =============================
     This is tested by writing 0 in the response bit of Command
     register and a command transfer is initiated between the Trickbox
     and the UUT. In this mode the UUT does not expect the response from
     trickbox. The CmdActive flag is expected to be set during the
     Command transfer.
  */
  C("Testing Command Active Interrupt");

  PSW(0x00000800, MMCIMask0);
  PSW(DATA_0s, MMCITBControl);
  PSW(DATA_5s, MMCIArgument);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | NORESP_LONGRSP_CLR | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PSR(0x00000010, TBMASKINTR, MMCITBSIGSTAT);
  PSW(DATA_0s, MMCIMask0);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(0x00000800, MMCIMask1);
  PSR(0x00000020, TBMASKINTR, MMCITBSIGSTAT);
  PO(0x00000080, CMDSENT | CMDACTIVE, MMCIStatus,0x0000FFFF);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(CMDSENTCLR, MMCIClear);
  PSW(DATA_0s, MMCIMask1);

  PSW(0x00000800, MMCIMask0);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | NORESP_LONGRSP_SET | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PO(0x00000800, CMDACTIVE, MMCIStatus,0x0000FFFF);
  PSR(0x00000010, TBMASKINTR, MMCITBSIGSTAT);
  PSW(DATA_0s, MMCIMask0);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(0x00000800, MMCIMask1);
  PSR(0x00000020, TBMASKINTR, MMCITBSIGSTAT);
  PO(0x00000080, CMDSENT | CMDACTIVE, MMCIStatus,0x0000FFFF);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(CMDSENTCLR, MMCIClear);
  PSW(DATA_0s, MMCIMask1);

  C("End of Command Active Interrupt Test");

  /* Command TimeOut Interrupt Test
     ==============================
     Here the Command timer register in the trickbox is programmed with
     63 and the interrupt bit in command register is cleared. The
     response bit is set in the Command register, and command transfer
     is initiated. It is expected that the UUT set the CmdTimeOut bit
     after timeout period.
     The test is repeated by programming the Command timer register in
     the trickbox for values lesser than 63, say 62 and 50. In these
     cases, the CmdRespEnd bit in the Status register in the UUT is
     polled to detect the end of response. The CmdTimeOut flag is read
     to check that it is not set.
     Similarly, the test is repeated for Trickbox Command Timer values
     larger than 63, say 64 and 70. In these cases, the CmdTimeOut bit
     is polled after enabling command transfer. It is expected that the
     UUT set the CmdTimeOut bit after the timeout period.
     The test is repeated with LongRsp bit set in the Command register
  */

  C("Testing Command TimeOut Interrupt");
  /* Testing with command timer set to 63 */

  PSW(0x00000004, MMCIMask0);
  PSW(DATA_0s, MMCITBControl);
  PSW(DATA_Fs, MMCIArgument);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | SHORTRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PSW(0x0000001F, MMCITBCmdResponse);
  PSW(0x00000042, MMCITBRespTimer);
  PSW(DATA_5s, MMCITBResponse0);
  PollWait = ((8 + 48 + 64 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000004, 0x00000004, PollWait);

  /* Testing with command timer programmed to 62 */

  PSW(0x00000004, MMCIMask0);
  PSW(0x0000003E, MMCITBRespTimer);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | SHORTRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PO(0x00000040, CMDRESPEND, MMCIStatus,0x0000FFFF);
  PSR(0x00000000, CMDTIMEOUT, MMCIStatus);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(CMDRESPENDCLR, MMCIClear);

  /* Testing with command timer programmed to 50 */
  PSW(0x00000032, MMCITBRespTimer);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | SHORTRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PO(0x00000040, CMDRESPEND, MMCIStatus,0x0000FFFF);
  PSR(0x00000000, CMDTIMEOUT, MMCIStatus);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(CMDRESPENDCLR, MMCIClear);

  /* Testing with command timer programmed to 64 */
  PSW(0x00000004, MMCIMask0);
  PSW(0x00000043, MMCITBRespTimer);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | SHORTRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PollWait = ((8 + 48 + 66 + 5) * DELAY * 2 * (CLKDIV + 1));
  PO(0x00000004, CMDTIMEOUT, MMCIStatus, PollWait);
  PSR(0x00000010, TBMASKINTR, MMCITBSIGSTAT);
  RoutableInterrupt(0x00000004, 0x00000004, PollWait);
  PSW(CMDTIMEOUTCLR, MMCIClear);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);

  /* Testing with command timer programmed to 70 */
  PSW(0x00000004, MMCIMask0);
  PSW(0x00000050, MMCITBRespTimer);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | SHORTRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PollWait = ((8 + 48 + 72 + 5) * DELAY * 2 * (CLKDIV + 1));
  PO(0x00000004, CMDTIMEOUT, MMCIStatus, PollWait);
  PSR(0x00000010, TBMASKINTR, MMCITBSIGSTAT);
  RoutableInterrupt(0x00000004, 0x00000004, PollWait);
  PSW(CMDTIMEOUTCLR, MMCIClear);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);

  /* Testing with command timer programmed to 70 and Interrupt bit set*/
  Idle(((DELAY)* (2 * (CLKDIV + 1))) * 0x010);
  PSW(0x00000004, MMCIMask0);
  PSW(0x00000050, MMCITBRespTimer);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | SHORTRESP | COMMANDENB | INTERRUPTENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PollWait = ((8 + 48 + 66) * DELAY * (CLKDIV + 1));
  PO(0x00000000, CMDTIMEOUT, MMCIStatus, PollWait);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  Check(0x00000000, 0x00000004);
  PollWait = ((8 + 48 + 66) * DELAY * 2 * (CLKDIV + 1));
  PO(0x00000040, CMDRESPEND, MMCIStatus, PollWait);
  PSW(CMDRESPEND, MMCIClear);
  Idle(((DELAY)* (2 * (CLKDIV + 1))) * 0x010);

  /* Repeating the above tests in Long Response mode */
  /* Testing with command timer programmed to 63 */

  PSW(DATA_5s, MMCITBResponse0);
  PSW(DATA_As, MMCITBResponse1);
  PSW(DATA_Fs, MMCITBResponse2);
  PSW(0x7FFFFFFF, MMCITBResponse3);

  PSW(0x00000004, MMCIMask0);
  PSW(DATA_0s, MMCITBControl);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | LONGRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PSW(0x00000042, MMCITBRespTimer);
  PollWait = ((8 + 48 + 66 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000004, 0x00000004, PollWait);
  PSW(CMDTIMEOUTCLR, MMCIClear);

  /* Testing with command timer programmed to 62 */

  PSW(0x00000004, MMCIMask0);
  PSW(0x0000003E, MMCITBRespTimer);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | LONGRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PollWait = ((8 + 48 + 66 + 140 + 5) * DELAY * 2 * (CLKDIV + 1));
  PO(0x00000040, CMDRESPEND, MMCIStatus, PollWait);
  PSR(0x00000000, CMDTIMEOUT, MMCIStatus);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(CMDRESPENDCLR, MMCIClear);

  /* Testing with command timer programmed to 50 */
  PSW(0x00000004, MMCIMask0);
  PSW(0x00000032, MMCITBRespTimer);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | LONGRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PollWait = ((8 + 48 + 52 + 140 + 5) * DELAY * 2 * (CLKDIV + 1));
  PO(0x00000040, CMDRESPEND, MMCIStatus, PollWait);
  PSR(0x00000000, CMDTIMEOUT, MMCIStatus);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(CMDRESPENDCLR, MMCIClear);

  /* Testing with command timer programmed to 64 */
  PSW(0x00000004, MMCIMask0);
  PSW(0x00000043, MMCITBRespTimer);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | LONGRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PollWait = ((8 + 48 + 68 + 5) * DELAY * 2 * (CLKDIV + 1));
  PO(0x00000004, CMDTIMEOUT, MMCIStatus, PollWait);
  PSR(0x00000010, TBMASKINTR, MMCITBSIGSTAT);
  RoutableInterrupt(0x00000004, 0x00000004, PollWait);
  PSW(CMDTIMEOUTCLR, MMCIClear);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);

  /* Testing with command timer programmed to 70 */
  PSW(0x00000004, MMCIMask0);
  PSW(0x00000050, MMCITBRespTimer);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | LONGRESP | COMMANDENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PollWait = ((8 + 48 + 72 + 5) * DELAY * 2 * (CLKDIV + 1));
  PO(0x00000004, CMDTIMEOUT, MMCIStatus,0x0000FFFF);
  PSR(0x00000010, TBMASKINTR, MMCITBSIGSTAT);
  RoutableInterrupt(0x00000004, 0x00000004, PollWait);
  PSW(CMDTIMEOUTCLR, MMCIClear);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);

  /* Testing with command timer programmed to 70 and Interrupt bit set*/
  Idle(((DELAY)* (2 * (CLKDIV + 1))) * 0x010);
  PSW(0x00000004, MMCIMask0);
  PSW(0x00000050, MMCITBRespTimer);
  PO(0x00000000, STATICFLAGS | CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | LONGRESP | COMMANDENB | INTERRUPTENB;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);
  PollWait = ((8 + 48 + 66) * DELAY * (CLKDIV + 1));
  PO(0x00000000, CMDTIMEOUT, MMCIStatus, PollWait);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  Check(0x00000000, 0x00000004);
  PollWait = ((8 + 136 + 66) * DELAY * 2 * (CLKDIV + 1));
  PO(0x00000040, CMDRESPEND, MMCIStatus, PollWait);
  PSW(CMDRESPENDCLR, MMCIClear);
  Idle(((DELAY)* (2 * (CLKDIV + 1))) * 0x010);

  C("End of Command TimeOut Interrupt Test");

  /* DataCrcFail Interrupt Test
     ==========================
     This test is carried out in the Block transfer mode first with the
     UUT in transmit mode and then with the UUT in the receive mode.
     First the UUT is programmed to transmit data and the trickbox is
     programmed to give a CRC error token. The UUT and the trickbox are
     then enabled. the FIFO in the UUT is filled with data. The
     DataCrcFail flag in the UUT is polled and is expected to get set
     after the CRC status token has been received.
     The DataCrcFlag is then cleared. The test is again repeated in
     wide bus mode.
     The DataCrcFlag is then cleared. The MMCI is programmed to transmit
     data in block mode. The MMCI and the trickbox are then programmed
     for standard bus mode. The DataLength register is programmed with
     a value which is not a integral multiple of Block size. MMCI and
     trickbox are enabled. The FIFO in MMCI is filled with data. The
     DataCrcFail flag in the MMCI is polled and is expected to get set.
     The DataCrcFlag is then cleared. The test is again repeated by
     enabling the wide bus mode in the Clock Control register of MMCI
     and Trickbox.
     The DataCrcFlag is then cleared. The UUT is programmed in receive
     mode and the trickbox is programmed to transmit data with a wrong
     CRC. The Transmit FIFO in the trickbox is filled with data for one
     block size. The Trickbox and the UUT are enabled and data transfer
     is allowed to occur. The DataCrcFail flag in the UUT is polled and
     is expected to get set after the block of data with the CRC has
     been received.
     The DataCrcFlag is then cleared. The test is again repeated by
     enabling the wide bus mode in the Clock Control register of MMCI
     and Trickbox. The trickbox is programmed to give a wrong CRC on
     different lines and also on multiple lines.
     The DataCrcFlag is then cleared. The UUT is programmed in receive
     mode. The MMCI and the trickbox are then programmed
     for standard bus mode. The DataLength register is programmed with
     a value which is not a integral multiple of Block size. The
     Transmit FIFO in the trickbox is filled with data for one block
     size.MMCI and trickbox are enabled. CrcFail flag in the UUT is
     polled and is expected to get set after the CRC status token has
     been received.
     The DataCrcFlag is then cleared. The test is again repeated by
     enabling the wide bus mode in the Clock Control register of MMCI
     and Trickbox. The trickbox is programmed to give a wrong CRC on
     different lines and also on multiple lines.
  */

  C("DPSM INTERRUPT TESTS");
  C("Testing Data CRCfail Interrupt");
  /* When UUT is txg in block mode and in standard bus format*/

  PSW(0x00000400, MMCITBPCDisable);
  PSW(POWERON | VOLTAGE15, MMCIPower);
  PSW(CLKDIV1 | CLKENB, MMCIClock);
  CLKDIV = 1;
  PSW(CLEARALL, MMCIClear);
  Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 4);
  PSW(0x00000002, MMCIMask0);
  PSW(0x00000004, MMCIDataLength);
  PSW(WRONGCRCORTOKEN, MMCITBControl);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000001F, MMCITBDataTimer);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PSR(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus);
  PSW(DATA_5s, MMCIFIFO);
  PollWait = ((8 + 32 + 16 + 40 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000002, 0x00000002, PollWait);

  /* When datalength is not an integral multiple of Block length, and
     in standard bus format  */

  PSW(DATA_0s, MMCITBControl);
  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000002, MMCIMask0);
  PSW(0x00000006, MMCIDataLength);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PSR(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus);
  PSW(DATA_5s, MMCIFIFO);
  PSW(DATA_As, MMCIFIFO);
  PSW(DATA_As, MMCIFIFO);
  PollWait = ((8 + (32 + 16 + 40)*2 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000002, 0x00000002, PollWait);

  /* When datalength is not an integral multiple of Block length, and
     in standard bus format  */

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000002, MMCIMask0);
  PSW(0x0000000C, MMCIDataLength);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | BLOCKSIZE3;
  PSW(local, MMCIDataCtrl);
  PSR(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus);
  PSW(DATA_5s, MMCIFIFO);
  PSW(DATA_As, MMCIFIFO);
  PSW(DATA_As, MMCIFIFO);
  PollWait = ((8 + (64 + 16 + 40)*2 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000002, 0x00000002, PollWait);

  /* When UUT is Receiving */
  /* When UUT is Rxg in block mode and in standard bus format*/

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000002, MMCIMask0);
  PSW(0x00000004, MMCIDataLength);
  PSW(WRONGDATACRC0, MMCITBControl);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000001F, MMCITBDataTimer);
  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  PSW(DATA_5s, MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | DATARXDIR | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PO(0x00002000, RXACTIVE, MMCIStatus);
  PollWait = ((8 + (32 + 16 + 40)*2 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000002, 0x00000002, PollWait);

  /* When datalength is not a integral multiple of Block length, and
     in standard bus format CRC error on DAT0  */

  PSW(DATA_0s, MMCITBControl);
  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000002, MMCIMask0);
  PSW(0x00000006, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000001F, MMCITBDataTimer);
  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  PSW(DATA_5s, MMCITBFIFOReg);
  PSW(DATA_As, MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | DATARXDIR | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PO(0x00002000, RXACTIVE, MMCIStatus);
  PollWait = ((8 + (32 + 16 + 40)*4 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000002, 0x00000002, PollWait);

  C("End of DataCrcFail Interrupt Test");
  PSW(DATA_0s, MMCITBControl);
  PSW(CLEARALL, MMCIClear);
  PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

  PSW(0x00004440, MMCITBPCDisable);
  Idle(((DELAY)* (2 * (CLKDIV + 1))) * 0x010);
  PSW(DATA_0s, MMCIDataCtrl);
  Idle(((DELAY)* (2 * (CLKDIV + 1))) * 0x010);
  PSW(0x00000400, MMCITBPCDisable);
  Idle(((DELAY)* (2 * (CLKDIV + 1))) * 0x030);

  /* DataTimeOut Interrupt Test
     ==========================
     Here the Data Timer register in trickbox is programmed with a
     large value and that in MMCI is programmed with a small value. The
     data transfer is initiated, so that the trickbox takes more time
     to respond. The DataTimeOut flag in the MMCI is then expected to be
     set.
     This test is done for the transmit mode and the receive mode of
     the MMCI. In the transmit mode the CRC token given by the trickbox
     is delayed by as many clocks as written in the Token Timer
     register of the trickbox. The DataTimeOut flag is then polled.
     The test is repeated by programming the trickbox to introduce no
     delay in responding with the CRC Token, but sufficient number of
     BUSY cycles so as to result in a DataTimeOut in the MMCI. The test
     is repeated with the MMCI and the Trickbox programmed with the same
     values in the Timeout registers, so that the Timeout condition is
     just avoided. In this case, the DataEnd flag in the MMCI is polled
     and then the DataTimeOut flag is read to verify that it is not set.
     The above tests are carried out by programming the Clock Control
     register for both Standard bud mode as well as Wide bus mode.
     In the receive mode the trickbox is programmed to delay the start
     bit of the receive data stream by the value written in the timer
     register of trickbox which is greater than that written in MMCI.
     The clock control register is programmed for standard bus mode.
     The Data Control register is programmed for Block transfer. The
     DataTimeOut flag is polled to verify that the MMCI detects the
     DataTimeOut condition. This test is repeated with the MMCI and
     trickbox programmedwith the same values in the Timeout registers,
     so that the Timeout condition is avoided. In this case, the
     DataEnd flag in the MMCI is polled and then the DataTimeOut flag is
     read to verify that it is not set.
     The DataTimeOut flag is cleared. The DataControl register is
     programmed in stream mode and the above tests are repeated.
     The DataTimeOut flag is cleared and the test is repeated in Wide
     bus mode.
  */

  C("Testing DataTimeOut Interrupt");
  /* Test is carried out in standard bus mode, where token is delayed */

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000008, MMCIMask0);
  PSW(0x00000004, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000003F, MMCITBTokenTimer);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PSR(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus);
  PSW(DATA_5s, MMCIFIFO);
  PollWait = ((8 + (32 + 16 + 40) + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000008, 0x00000008, PollWait);

  /* Test is carried out in standard bus mode, where BUSY is delayed */

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000008, MMCIMask0);
  PSW(0x00000000, MMCITBTokenTimer);
  PSW(0x0000003F, MMCITBBusyTimer);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PSR(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus);
  PSW(DATA_5s, MMCIFIFO);
  PollWait = ((8 + (32 + 16 + 44) + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000008, 0x00000008, PollWait);
  PSW(DATABLOCKENDCLR, MMCIClear);

  /* Test is carried out in standard bus mode, where BUSY and Token
     are programmed with same value and interrupt is prevented */

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000008, MMCIMask0);
  PSW(0x00000004, MMCIDataLength);
  PSW(0x00000010, MMCIDataTimer);
  PSW(0x00000006, MMCITBTokenTimer);
  PSW(0x00000006, MMCITBBusyTimer);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PSR(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus);
  PSW(DATA_5s, MMCIFIFO);
  PSW(DATA_5s, MMCIFIFO);
  PSW(DATA_5s, MMCIFIFO);
  PSW(DATA_5s, MMCIFIFO);
  PollWait = ((8 + (32 + 16 + 30) + 5) * DELAY * 2 * (CLKDIV + 1));
  PO(0x00000100, DATATIMEOUT | DATAEND, MMCIStatus, PollWait);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(DATA_0s, MMCIMask0);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(0x00000008, MMCIMask1);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(DATATIMEOUTCLR, MMCIClear);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(0x00000500, MMCIClear);
  PSW(DATA_0s, MMCIMask0);
  PSW(DATA_0s, MMCIMask1);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);


  /* Testing in receive mode */
  /* Testing in standard bus mode where start bit is delayed */

  PSW(CLEARALL, MMCIClear);
  PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000008, MMCIMask0);
  PSW(0x00000004, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000002F, MMCITBDataTimer);
  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  PSW(DATA_As, MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | DATARXDIR | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PO(0x00002000, RXACTIVE, MMCIStatus);
  PollWait = ((8 + (32 + 16 + 40) + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000008, 0x00000008, PollWait);

  /* Testing in standard bus mode where interrupt is just avoided */

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000008, MMCIMask0);
  PSW(0x00000004, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000001D, MMCITBDataTimer);
  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  PSW(DATA_As, MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | DATARXDIR | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PO(0x00002000, RXACTIVE, MMCIStatus);
  PollWait = ((8 + (32 + 16 + 40) + 5) * DELAY * 2 * (CLKDIV + 1));
  PO(0x00000100, DATATIMEOUT | DATAEND, MMCIStatus, PollWait);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(DATA_0s, MMCIMask0);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(0x00000008, MMCIMask1);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(DATATIMEOUTCLR, MMCIClear);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(DATABLOCKENDCLR | DATAENDCLR, MMCIClear);
  PSR(DATA_As, DATA_0s, MMCIFIFO);
  PSW(DATA_0s, MMCIMask0);
  PSW(DATA_0s, MMCIMask1);

  /* Testing in stream, standard mode where start bit is delayed */

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000008, MMCIMask0);
  PSW(0x00000004, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000002F, MMCITBDataTimer);
  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  PSW(DATA_As, MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATATXRENB | DATARXDIR | STREAMMODE, MMCIDataCtrl);
  PO(0x00002000, RXACTIVE, MMCIStatus);
  PollWait = ((8 + (40) + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000008, 0x00000008, PollWait);

  C("End of DataTimeOut Interrupt Test");
  PSW(CLEARALL, MMCIClear);
  PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

  /* TxUnderrun Interrupt Test
     =========================
     Here the Data Counter register is filled with a value more than
     that filled in MMCI FIFO. The MMCI is programmed for block mode in
     DataControl register, and in standard bus mode in Clock control
     register. Then the MMCI is programmed for transmission, and
     the TxUnderrun flag is polled so that underrun condition occurs.
     The TxUnderrun flag is cleared, Clock Control register is
     programmed for wide bus mode, and the test is repeated.
     The TxUnderrun flag is cleared, and the above tests are repeated
     by programming the DataControl register for stream mode.
  */

  C("Testing TxUnderrun Interrupt");
  /* Testing in standard bus mode and when MMCI is transmitting */

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000010, MMCIMask0);
  PSW(0x00000048, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000000F, MMCITBTokenTimer);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATATXRENB | BLOCKSIZE3, MMCIDataCtrl);
  PSR(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus);
  for (i=0 ; i<16; i++)
     PSW(DATA_5s, MMCIFIFO);
  PO(0x00004000, TXFIFOHALFEMPTY, MMCIStatus,0x0000FFFF);
     PSW(DATA_5s, MMCIFIFO);
  PollWait = ((8 + (64 + 16 + 20)*10 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000010, 0x00000010, PollWait);

  /* Testing in stream, standard bus mode and when MMCI is txg */

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000010, MMCIMask0);
  PSW(0x00000048, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000000F, MMCITBTokenTimer);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATATXRENB | STREAMMODE, MMCIDataCtrl);
  PSR(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus);
  for (i=0 ; i<16; i++)
     PSW(DATA_5s, MMCIFIFO);
  PO(0x00004000, TXFIFOHALFEMPTY, MMCIStatus,0x0000FFFF);
     PSW(DATA_5s, MMCIFIFO);
  PollWait = ((8 + (20 + 50*8) + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000010, 0x00000010, PollWait);

  C("End of TxUnderrun Interrupt Test");
  PSW(CLEARALL, MMCIClear);
  PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

  /* RxOverrrun Interrupt Test
     =========================
     Here the Data Counter register in trickbox is filled with a value
     more than the FIFO depth in MMCI. The MMCI is programmed in receive
     mode and the trickbox starts pumping more data into the MMCI than
     the depth of the FIFO in the MMCI. The RxOverrun flag is expected
     to be set after 16 words of data have been received. The 16th data
     is read from the MMCI FIFO, it is expected that the DPSM goes to
     idle state by resetting the FIFO pointers so that the reading of
     16th data is not possible.
     The RxOverrun flag is cleared. This test is repeated in stream
     mode and wide bus mode separately.
  */
  C("Testing RxOverrrun Interrupt");
  /* Testing in standard mode when MMCI is rxg */

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000020, MMCIMask0);
  PSW(0x00000048, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000000F, MMCITBDataTimer);
  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  for (i=0 ; i<18; i++)
     PSW(DATA_As, MMCITBFIFOReg);
  local = DATATXRENB | DATARXDIR | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PO(0x00002000, RXACTIVE, MMCIStatus);
  PollWait = ((8 + (32 + 16 + 20)*20 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000020, 0x00000020, PollWait);
  for (i=0 ; i<16; i++)
     PSR(DATA_As, DATA_0s, MMCIFIFO);

  /* Testing in stream, standard mode when MMCI is rxg */

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000020, MMCIMask0);
  PSW(0x00000048, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000000F, MMCITBDataTimer);
  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  for (i=0 ; i<18; i++)
     PSW(~DATA_As, MMCITBFIFOReg);
  PSW(DATATXRENB | DATARXDIR | STREAMMODE, MMCIDataCtrl);
  PO(0x00002000, RXACTIVE, MMCIStatus);
  PollWait = ((8 + (20 + 50*8) + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000020, 0x00000020, PollWait);
  for (i=0 ; i<16; i++)
     PSR(DATA_As, DATA_0s, MMCIFIFO);
  PO(0x00000000, RXACTIVE, MMCIStatus);

  C("End of RxOverrrun Interrupt Test");
  PSW(CLEARALL, MMCIClear);
  PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

  /* DataEnd Interrupt Test
     ======================
     This test can be carried out by writing a small value (say 2) in
     DataCounter register of MMCI and the data transfer is initiated
     with MMCI transmitting the data. This test performed first in block
     mode and then in stream mode.
     This test is repeated in both Standard bus mode and wide bus mode.
  */
  C("Testing DataEnd Interrupt");
  /* Testing in standard mode when MMCI is txg */

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000100, MMCIMask0);
  PSW(0x00000008, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000000F, MMCITBTokenTimer);
  PSW(0x00000001, MMCITBBusyTimer);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PSR(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus);
  for (i=0 ; i<2; i++)
     PSW(DATA_5s, MMCIFIFO);
  PollWait = ((8 + (32 + 16 + 28)*2 + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000100, 0x00000100, PollWait);

  /* Testing in stream, standard mode when MMCI is txg */

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000100, MMCIMask0);
  PSW(0x00000008, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000001F, MMCITBTokenTimer);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATATXRENB | STREAMMODE, MMCIDataCtrl);
  PSR(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus);
  for (i=0 ; i<2; i++)
     PSW(~DATA_5s, MMCIFIFO);
  PollWait = ((8 + (64 + 25) + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000100, 0x00000100, PollWait);

  C("End of DataEnd Interrupt Test");
  PSW(CLEARALL, MMCIClear);
  PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

  /* DataBlockEnd Interrupt Test
     ===========================
     This test and DataCrcFail test are complimentary. To bring out
     this condition, the trickbox is programmed in the block mode and
     to give a correct CRC token. The MMCI is then programmed to
     transmit data to the trickbox. At the end of transmission of one
     block of data, the DataBlockEnd flag is expected to be set. This
     test is repeated with the MMCI programmed in the receive mode, the
     trickbox has to transmit the correct CRC.
     The test is repeated by programming the Clock Control register for
     wide bus mode.
  */
  C("Testing DataBlockEnd Interrupt");
  /* Testing in standard mode , MMCI is txg */

  PSW(CLEARALL, MMCIClear);
  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000400, MMCIMask0);
  PSW(0x00000004, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000000F, MMCITBTokenTimer);
  PSW(0x00000001, MMCITBBusyTimer);
  PSW(DATA_0s, MMCITBControl);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);

  Idle(((DELAY) * (2 * (CLKDIV + 1))) * 0x0A);
  PSW(0x00000400, MMCITBPCDisable);
  PSR(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus);
  PSW(DATA_5s, MMCIFIFO);
  PollWait = ((8 + (32 + 16 + 44) + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000400, 0x00000400, PollWait);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);

  Idle(((DELAY) * (2 * (CLKDIV + 1))) * 0x1A);
  /* Testing in standard mode , MMCI is Rxg */

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000400, MMCIMask0);
  PSW(0x00000004, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000000F, MMCITBDataTimer);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  PSW(DATA_As, MMCITBFIFOReg);
  local = DATATXRENB | DATARXDIR | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PollWait = ((8 + (32 + 16 + 25) + 5) * DELAY * 2 * (CLKDIV + 1));
  RoutableInterrupt(0x00000400, 0x00000400, PollWait);
  PSR(DATA_5s, DATA_0s, MMCIFIFO);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(0x00000100, MMCIClear);
  PO(0x00000000,0x00000100, MMCIStatus,0x0000FFFF);

  C("End of DataBlockEnd Interrupt Test");
  PSW(CLEARALL, MMCIClear);
  PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

  /* FIFO Interrupt Test (Transmit mode)
     ===================================
     In this test the TxFifoHalfEmpty, TxDataAvbl, TxFifoEmpty and
     TxFifoFull flags are tested. The test sequence is as follows:
     - Program the MMCI and the Trickbox for a block length of 4 bytes
     and data length of 68 bytes. Program the DataTimeOut register in
     the MMCI to a high value. Enable the MMCI in Transmit mode. Poll for
     a 1 on the TxActive bit, indicating that the FIFO is now enabled.
     Read the status register in the MMCI to verify that the TxFifoEmpty
     flag is set and the TxDataAvlbl flag is cleared. Also check for
     TxFifoHalfEmpty = 1 and TxFifoFull = 0.
     - Write 1 word of data to the TxFIFO. Read the MMCI status register
       to verify that TxFifoEmpty = 0, TxDataAvbl = 1. Poll for
       TxDataAvbl = 0.
     - Since the Trickbox CRC token enable bit is not being set, the
       Data FSM waits for the CRC token. Write 1 word into the TxFIFO
       and check for TxFifoEmpty = 0, TxDataAvbl = 1,
       TxFifoHalfEmpty = 1 and TxFifoFul l = 0.
     - Write 7 more words of data into the TxFIFO. Now check for
       TxFifoEmpty = 0, TxDataAvbl = 1, TxFifoHalfEmpty = 0 and
       TxFifoFull = 0.
     - The MMCI's Tx logic removes 1 data word from the FIFO for the
       transmission of the next block. Now check for TxFifoEmpty = 0,
       TxDataAvbl = 1, TxFifoHalfEmpty = 0 and TxFifoFull = 0. Poll for
       DataBlockEnd = 1 and clear it by writing to the MMCIClear register
     - Allow 6 more transfers to occur.
     - Allow 1 more transfer to occur. Check for TxFifoEmpty = 0,
       TxDataAvbl = 1, TxFifoHalfEmpty = 1 and TxFifoFull = 0.
     - Allow 6 more transfers to occur.
     - Allow 1 more transfer to occur. Check for TxFifoEmpty = 0,
       TxDataAvbl = 0, TxFifoHalfEmpty = 1 and TxFifoFull = 0.
  */
  C("Testing FIFO Interrupts - Transmit mode");

  if (PCLK_PERIOD == 100)
    PSW(CLKDIV2 | CLKENB, MMCIClock);
  else
    PSW(CLKDIV1 | CLKENB, MMCIClock);

  PSW(0x00000044, MMCIDataLength);
  PSW(0x00000A00, MMCIDataTimer);
  PSW(0x0000004F, MMCITBTokenTimer);
  PSW(0x00040000, MMCIMask0);
  PSW(DATA_0s, MMCITBControl);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  local = TXDATAAVLBL | TXFIFOEMPTY | TXFIFOFULL |
          TXFIFOHALFEMPTY | TXACTIVE;
  PSR(0x00045000, local, MMCIStatus);
  Check (0x00040000, 0x00040000); /* TxFifoEmpty Flag  set*/
  PSW(0x00004000, MMCIMask0);
  Check (0x00004000, 0x00004000); /* TxFifoHalfEmpty set */
  PSW(DATA_5s, MMCIFIFO);
  local = TXDATAAVLBL | TXFIFOEMPTY | TXFIFOFULL | TXFIFOHALFEMPTY;
  PO(0x00104000, local, MMCIStatus,0x0000FFFF);
  Check (0x00040000, 0x00040000); /* TxFifoEmpty Flag cleared*/
  PO(0x00000000, TXDATAAVLBL, MMCIStatus,0x0000FFFF);
  Check (0x00000000, 0x00100000); /* TxDataAvbl Flag  cleared*/
  PSW(DATA_As, MMCIFIFO);
  local = TXDATAAVLBL | TXFIFOEMPTY | TXFIFOFULL | TXFIFOHALFEMPTY;
  PO(0x00104000, local, MMCIStatus,0x0000FFFF);
  Check (0x00100000, 0x00100000); /* TxDataAvbl Flag  set*/
  for ( i=0; i<7; i++ )
    PSW(DATA_As, MMCIFIFO);
  local = TXDATAAVLBL | TXFIFOEMPTY | TXFIFOFULL | TXFIFOHALFEMPTY;
  PO(0x00104000, local, MMCIStatus,0x0000FFFF);
  PSW(~DATA_As, MMCIFIFO);
  local = TXDATAAVLBL | TXFIFOEMPTY | TXFIFOFULL | TXFIFOHALFEMPTY;
  PO(0x00100000, local, MMCIStatus,0x0000FFFF);
  Check (0x00000000, 0x00004000); /* TxFifoHalfEmpty cleared */
  for ( i=0; i<7; i++ )
    PSW(DATA_As, MMCIFIFO);
  local = TXDATAAVLBL | TXFIFOEMPTY | TXFIFOFULL | TXFIFOHALFEMPTY;
  PO(0x00110000, local, MMCIStatus,0x0000FFFF);
  Check (0x00010000, 0x00010000); /* TxFifoFull set */
  PSW(0x00000000, MMCITBTokenTimer);
  local = TXDATAAVLBL | TXFIFOEMPTY | TXFIFOFULL | TXFIFOHALFEMPTY;
  PO(0x00100000, local, MMCIStatus,0x0000FFFF);
  Check (0x00000000, 0x00010000); /* TxFifoFull cleared */
  local = TXDATAAVLBL | TXFIFOEMPTY | TXFIFOFULL | TXFIFOHALFEMPTY;
  PO(0x00044000, local, MMCIStatus,0x0000FFFF);
  Check (0x00000000, 0x00100000); /* TxDataAvbl Flag  cleared*/
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(CLEARALL, MMCIClear);
  PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

  C("End of FIFO Interrupts tests - Transmit mode");

  /* FIFO Interrupt Test (Receive mode)
     ==================================
     In this test RxFifoEmpty, RxDataAvbl, RxFifoFull flags are tested.

     The test sequence is as follows :
     - Program the MMCI and the Trickbox for a block length of 4 bytes
       and Data length of 64 bytes (16 words). Program the DataTimeOut
       register in the MMCI to a high value, say 0x0000A000. Enable the
       MMCI in receive mode. Poll for a 1 on the RxActive bit,
       indicating that the FIFO is now enabled. Read the status
       register in the MMCI to verify that the RxFifoEmpty flag is set
       and the RxDataAvbl flag is cleared. Also check for
       RxFifoHalfFull = 0 and RxFifoFull = 0.
     - Write 1 word into the TxFIFO of the trickbox. Poll for the
       BlockEnd bit in the MMCI's status register. Check for
       RxFifoEmpty = 0, RxDataAvbl = 1, RxFifoHalfFull = 0 and
       RxFifoFull = 0.
     - Allow 6 more transfer.
     - Allow 1 more transfer, poll for the BlockEnd bit in the MMCI's
       status register and checking for RxFifoEmpty = 0,RxDataAvbl = 1,
       RxFifoHalfFull = 1 and RxFifoFull = 0.
     - Allow 7 more transfer.
     - Allow 1 more transfer, poll for the BlockEnd bit in the MMCI's
       status register and checking for RxFifoEmpty = 0,RxDataAvbl = 1,
       RxFifoHalfFull = 1 and RxFifoFull = 1.
     - Through the APB interface, read 1 word of data from the FIFO and
       check for RxFIFOFull becoming 0. Read 8 more words and check for
       RxFifoHalfFull = 0. Then read 7 more words and check for
       RxDataAvbl = 0 and RxFifoEmpty = 1.
  */

  C("Testing FIFO Interrupts - Receive mode");

  if (PCLK_PERIOD == 100)
    PSW(CLKDIV2 | CLKENB, MMCIClock);
  else
    PSW(CLKDIV1 | CLKENB, MMCIClock);

  PSW(0x00000040, MMCIDataLength);
  PSW(0x000000A0, MMCIDataTimer);
  PSW(0x0000000F, MMCITBDataTimer);
  PSW(0x00040000, MMCIMask0);
  PSW(DATA_0s, MMCITBControl);
  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  PSW(DATA_As, MMCITBFIFOReg);
  PSW(DATA_As, MMCITBFIFOReg);
  local = DATATXRENB | DATARXDIR | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  local = RXFIFOHALFEMPTY | RXDATAAVLBL | RXFIFOEMPTY | RXFIFOFULL;
  PO(0x00080000, local, MMCIStatus,0x0000FFFF);
  Check (0x00080000, 0x00080000); /* RxFifoEmpty set */
  local = RXFIFOHALFEMPTY | RXDATAAVLBL | RXFIFOEMPTY | RXFIFOFULL;
  PO(0x00200000, local, MMCIStatus,0x0000FFFF);
  Check (0x00000000, 0x00080000); /* RxFifoEmpty cleared */
  Check (0x00200000, 0x00200000); /* RxDataAvbl set */
  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  for (i=0; i<7; i++)
    PSW(DATA_As, MMCITBFIFOReg);
  local = RXFIFOHALFEMPTY | RXDATAAVLBL | RXFIFOEMPTY | RXFIFOFULL;
  PO(0x00208000, local, MMCIStatus,0x0000FFFF);
  Check (0x00008000, 0x00008000); /* RxFifoHalfFull set */
  for (i=0; i<8; i++)
    PSW(DATA_5s, MMCITBFIFOReg);
  local = RXFIFOHALFEMPTY | RXDATAAVLBL | RXFIFOEMPTY | RXFIFOFULL;
  PO(0x00228000, local, MMCIStatus,0x0000FFFF);
  Check (0x00020000, 0x00020000); /* RxFifoFull set */
  PSR(0x00000000, DATA_0s, MMCIFIFO);
  local = RXFIFOHALFEMPTY | RXDATAAVLBL | RXFIFOEMPTY | RXFIFOFULL;
  PO(0x00208000, local, MMCIStatus,0x0000FFFF);
  Check (0x00000000, 0x00020000); /* RxFifoFull cleared */
  for (i=0; i<8; i++)
    PSR(0x00000000, DATA_0s, MMCIFIFO);
  local = RXFIFOHALFEMPTY | RXDATAAVLBL | RXFIFOEMPTY | RXFIFOFULL;
  PO(0x00200000, local, MMCIStatus,0x0000FFFF);
  Check (0x00000000, 0x00008000); /* RxFifoHalfFull cleared */
  for (i=0; i<7; i++)
    PSR(0x00000000, DATA_0s, MMCIFIFO);
  local = RXFIFOHALFEMPTY | RXDATAAVLBL | RXFIFOEMPTY | RXFIFOFULL;
  PO(0x00080000, local, MMCIStatus,0x0000FFFF);
  Check (0x00000000, 0x00200000); /* RxDataAvbl cleared */
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(CLEARALL, MMCIClear);
  PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

  PSW(0x00000000, MMCITBPCDisable);
  C("End of FIFO Interrupt tests - Receive mode");

  /* Clearing the Trickbox Fifo contents */
  Idle(((DELAY) * (2 * (CLKDIV + 1))) * 0x3A);
  PSW(TBRESET, MMCITBControl);
  Idle(((DELAY) * (2 * (CLKDIV + 1))) * 0x0A);
  PSW(DATA_0s, MMCITBControl);
  Idle(((DELAY) * (2 * (CLKDIV + 1))) * 0x3A);


  C("Testing TxActive Interrupt");
  /* Testing in standard mode , MMCI is txg */

  PSW(CLEARALL, MMCIClear);
  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00001000, MMCIMask0);
  PSW(0x00000004, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000000F, MMCITBTokenTimer);
  PSW(0x00000001, MMCITBBusyTimer);
  PSW(DATA_0s, MMCITBControl);
  PO(0x00000000, TXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(0x00000021, MMCIDataCtrl);
  PSW(0x00000000, MMCITBPCDisable);
  PSR(0x00041000, 0x00041000, MMCIStatus);
  PSW(DATA_5s, MMCIFIFO);
  PollWait = 6;
  PO(0x00001000, TXACTIVE, MMCIStatus, PollWait);
  PSR(0x00000010, 0x00000030, MMCITBSIGSTAT);
  PSW(DATA_0s, MMCIMask0);
  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((CLKS) + 1)) * 0x03);
  PSR(0x00000000, 0x00000030, MMCITBSIGSTAT);
  PSW(0x00001000, MMCIMask1);
  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((CLKS) + 1)) * 0x03);
  PSR(0x00000020, 0x00000030, MMCITBSIGSTAT);
  PSW(DATA_0s, MMCIMask0);
  PSW(DATA_0s, MMCIMask1);
  PO(0x00000000, TXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(CLEARALL, MMCIClear);
  PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

  C("End of TxActive Interrupt Test");

  C("Testing RxActive Interrupt");
   /* Testing in standard mode , MMCI is Rxg */

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00002000, MMCIMask0);
  PSW(0x00000004, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000000F, MMCITBDataTimer);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  PSW(DATA_As, MMCITBFIFOReg);
  PSW(0x00000023, MMCIDataCtrl);
  PollWait = 60;
  PO(0x00002000, RXACTIVE, MMCIStatus, PollWait);
  PSR(0x00000010, 0x00000030, MMCITBSIGSTAT);
  PSW(DATA_0s, MMCIMask0);
  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((CLKS) + 1)) * 0x03);
  PSR(0x00000000, 0x00000030, MMCITBSIGSTAT);
  PSW(0x00002000, MMCIMask1);
  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((CLKS) + 1)) * 0x03);
  PSR(0x00000020, 0x00000030, MMCITBSIGSTAT);
  PO(0x00000100, 0x00000100, MMCIStatus,0x0000FFFF);
  PSW(DATA_0s, MMCIMask0);
  PSW(DATA_0s, MMCIMask1);
  PSR(DATA_5s, DATA_0s, MMCIFIFO);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);

  C("End of RxActive Interrupt Test");

}

/*******************************  End  ****************************************/
