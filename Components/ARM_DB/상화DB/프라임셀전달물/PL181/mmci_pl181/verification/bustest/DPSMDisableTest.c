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
-- File Name              : DPSMDisableTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Tests to verify DPSM operation when disabled in each of
--           its states
--
-- --=========================================================================*/

/******************************************************************************/
/****************************  DPSMDISABLE  Test ******************************/
/******************************************************************************/

void DPSMDisableTest()
{
  /*
     Summary : Datapath FSM disable tests
     ====================================

     In this test, the DPSM is disabled when the MMCI DPSM is in each of
     its states. The condition to bring out in each state is given
     below.

     To target SEND state in DPSM:
     ----------------------------
     The DataLength register is
     loaded with a value 4. MMCI is programmed for transmitting data.
     The Token timer register is loaded with 0. The DPSM is
     enabled. When the TxActive flag is asserted, the transmit FIFO of
     MMCI is filled with data. The DataCounter register is polled for a
     value of 2. This indicates that the DPSM has reached the SEND
     state. Then DPSM is disabled.

     To target WAIT_S state in DPSM:
     -------------------------------
     The DataLength register
     is loaded with a value 4. MMCI is programmed for transmitting data.
     The Token timer register is loaded with 0. The DPSM
     is enabled. When the TxActive flag is asserted, it indicates
     that the DPSM has reached the WAIT_S and is waiting for transmit
     data to be written to the FIFO. Then, the DPSM is disabled.

     To target BUSY state in DPSM:
     -----------------------------
     The DataLength register and the BlockLength are programmed  with a
     value 4. The MMCI is programmed for transmitting
     data. The Token timer register is loaded with a value of 0. The
     Busy timer in the Trickbox is loaded with a large value. The DPSM
     is enabled. When the TxActive flag is asserted, the transmit FIFO
     of the MMCI is filled with data. The DataCounter register is polled
     for a value of 0. This indicates that the DPSM has completed
     data reception and is waiting for the end of the token response
     from the trickbox. Since the trickbox has been programmed with
     a large value for the Busy timer, the trickbox returns BUSY
     for a long time during which the DPSM remains in the BUSY state.
     The DPSM is then disabled.

     To target WAIT_R state in DPSM:
     -------------------------------
     The DataLength register
     is loaded  with a value 4. MMCI is programmed for receiving the
     data. The  DataTimer register in MMCI and MMCITBDataTimer register
     in the trickbox is filled with a large value so that Trickbox
     gives the start bit after so many clocks programmed in
     MMCITBDataTimer register. Trickbox is filled with data. The data
     transfer is initiated and after few idle cycles the DPSM is
     expected to enter the WAIT_R state. The DPSM is then disabled.
     Since the MMCIDataCtrl register is mirrored in the trickbox, it
     is not possible to enable MMCI reception without enabling Trickbox
     transmission. Hence the need to program the MMCITBDataTimer register
     with a large value.

     To target RECEIVE state in DPSM:
     --------------------------------
     The DataLength register
     is loaded  with a value 4. MMCI is programmed for receiving the
     data. Trickbox is filled with data. The data transfer is
     initiated. The DataCounter register is polled for a value of 2.
     This indicates that the DPSM has reached the RECEIVE state.
     Then the DPSM is disabled.
  */
  int32 i, data1, data2, data2and, data1and, data3;
  int CLKS;

  if (MCLK_PERIOD < PCLK_PERIOD)
    CLKS = 1;
  else
    CLKS = MCLK_PERIOD / PCLK_PERIOD;

  srand(SEED);
  for (i=0x0; i<0x10; i++)
    {
      data1 = rand();
      data2 = rand();
      data2and = (data2 & 0x00007FFF) << 15;
      data1and = data1 & 0x00007FFF;
      data3 = (rand()) << 30;
      dataarray[i] = (data3 | data2and | data1and);
    }

  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000001F, MMCITBDataTimer);
  PSW(CLKDIV1 | CLKENB, MMCIClock);
  CLKDIV = 1;

  /* For SEND state */
  PSW(DATA_0s,MMCITBControl);
  PSW(DATA_0s,MMCITBTokenTimer);
  PSW(DATA_0s,MMCITBBusyTimer);

  PSW(0x00000008, MMCIDataLength);
  local = DATATXRENB | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PO(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATA_As, MMCIFIFO);
  PSW(DATA_Fs, MMCIFIFO);
  Idle((CLKS) * (2*(CLKDIV + 1)) * 0x10);
  PSW(DATA_0s, MMCIDataCtrl);
  C("DPSM DISABLED IN SEND STATE");
  PSW(DATABLOCKENDCLR, MMCIClear);
  Idle((CLKS) * (2*(CLKDIV + 1)) * 0x0A);

  /* For WAIT_S state */
  PSW(0x00000008, MMCIDataLength);
  PSW(DATATXRENB, MMCIDataCtrl);
  PO(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATA_0s, MMCIDataCtrl);
  C("DPSM DISABLED IN WAIT_S STATE");
  Idle((CLKS) * (2*(CLKDIV + 1)) * 0x0A);

  /* For BUSY state */

  PSW(0x0000000A,MMCITBBusyTimer);
  PSW(0x00000008, MMCIDataLength);
  PSW(DATATXRENB, MMCIDataCtrl);
  PO(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATA_As, MMCIFIFO);
  PSW(DATA_Fs, MMCIFIFO);
  Idle((CLKS) * (2*(CLKDIV + 1)) * 0x2A);
  PSW(DATA_0s, MMCIDataCtrl);
  PSW(DATABLOCKENDCLR, MMCIClear);
  C("DPSM DISABLED IN BUSY STATE");
  Idle((CLKS) * (2*(CLKDIV + 1)) * 0x2A);
  Idle((CLKS) * (2*(CLKDIV + 1)) * 0x2A);

  /* For WAIT_R state */

  PSW(0x00000A00, MMCIDataTimer);
  PSW(0x00000A00, MMCITBDataTimer);
  PSW(DATA_0s,MMCITBBusyTimer);
  PSW(0x00000008, MMCIDataLength);
  PSW(DATATXRENB | DATARXDIR, MMCIDataCtrl);
  PO(0x00002000, RXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATA_0s, MMCIDataCtrl);
  C("DPSM DISABLED IN WAIT_R STATE");

  /* For Receive state */

  PSW(0x0000000A, MMCIDataTimer);
  PSW(0x0000000A, MMCITBDataTimer);
  PSW(DATA_0s,MMCITBBusyTimer);
  PSW(0x00000008, MMCIDataLength);
  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  PSW(DATA_As, MMCITBFIFOReg);
  PSW(DATA_Fs, MMCITBFIFOReg);
  local = DATATXRENB | DATARXDIR | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PO(0x00002000, RXACTIVE, MMCIStatus,0x0000FFFF);
  PO(0x00080000, RXFIFOEMPTY, MMCIStatus,0x0000FFFF);
  Idle((CLKS) * (2*(CLKDIV + 1)) * 0x10);
  PSW(DATA_0s, MMCIDataCtrl);
  C("DPSM DISABLED IN RECEIVE STATE");
  Idle((CLKS) * (2*(CLKDIV + 1)) * 0x10);
}

/*******************************  End  ****************************************/
