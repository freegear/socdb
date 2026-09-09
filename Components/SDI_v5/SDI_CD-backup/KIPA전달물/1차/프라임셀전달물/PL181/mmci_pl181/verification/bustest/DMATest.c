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
-- File Name              : DMATest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Tests to verify the generation of the DMA requests
--
-- --=========================================================================*/

/******************************************************************************/
/****************************  DMA  Test **************************************/
/******************************************************************************/

void DMATest ()
{
  /*
     Summary : DMA Tests
     ====================

    This test tests the generation of the DMA requests DMASREQ,
    DMABREQ,DMALSREQ and DMALBREQ.
    DMASREQ:
    ========
    The MMCI is programmed for block data transfer in Standard bus mode.
    MMCI is programmed to transmit the data. The DataLength register is
    programmed for 68 bytes. The trickbox is programmed to give a
    correct CRC token. The TokenTimer register is programmed for a
    small value. The data transfer is initiated. The transmit fifo in
    MMCI is filled with 8 words when the TxActive flag is asserted. The
    DMASREQ flag is polled for 0. Then the MMCI FIFO is filled with 2
    more words of data and DMASREQ flag is polled. It is expected to
    get set. Then the DMACLR signal is asserted. The transmit FIFO in
    MMCI is filled with 7 words. The DMASREQ flag is polled for 0. The
    DPSM is disabled.

    The MMCI is programmed for block data transfer in Standard bus mode.
    MMCI is programmed to receive the data. The DataLength register is
    programmed for 8 bytes(2 words), The Trickbox is filled with 2
    words of data. Program the DataTimeOut register in the MMCI to a
    high value, say 0x0000A000. The data transfer is initiated. The
    DataCounter register is polled for a value of 1, and the DMASREQ
    flag is polled for 0. It is expected to be cleared. Then the
    DataCounter register is polled for a value of 0, and the DMASREQ
    is polled for a value of 1. Then the DMACLR signal is asserted and
    the DPSM is disabled. The DataLength register is programmed for 28
    bytes (7 words), The data transfer is initiated. The DataCounter
    register is polled for a value of 0, and the DMASREQ flag is
    polled for 1. It is expected to be set. Then the DMACLR signal is
    asserted and the DPSM is disabled. The DataLength register is
    programmed for 32 bytes(8 words), The data transfer is initiated.
    The DataCounter register is polled for a value of 0, and the
    DMASREQ flag is polled for 0. It is expected to be cleared.
    The DPSM is disabled.
    DMALSREQ:
    =========
    The MMCI is programmed for block data transfer in Standard bus mode.
    MMCI is programmed to transmit the data. The DataLength register is
    programmed for 68 bytes(17 words), The Trickbox is programmed to
    give a correct CRC token. The TokenTimer register is programmed for
    a small value say 0x00000010. The data transfer is initiated. The
    transmit FIFO in MMCI is filled with 15 word when the TxActive flag
    is asserted. The DMALSREQ  flag is polled for 0. Then 1 more data
    is filled into the MMCI FIFO. The DMALSREQ is polled. It is expected
    to get  set. Then the DMACLR signal is asserted. Then 1 more data
    is filled into the MMCI FIFO. The DMALSREQ is polled for 0. The DPSM
    is disabled.
    The MMCI is programmed for block data transfer in Standard bus mode.
    MMCI is programmed to receive the data. The DataLength register is
    programmed for 4 bytes(1 word), The Trickbox is filled with 1 word
    of data. Program the DataTimeOut register in the MMCI to a high
    value, say 0x0000A000. The data transfer is initiated. The DMALSREQ
    flag is polled. It is expected to get  set. Then the DMACLR signal
    is asserted and the DPSM is disabled. The DataLength register is
    programmed for 8 bytes(2 words), The Trickbox is filled with 2
    words of data. Program the DataTimeOut register in the MMCI to a
    high value, say 0x0000A000. The data transfer is initiated. The
    DataBlockEnd flag is polled for 1. Then DMALSREQ  flag is polled
    for 0. Then the status flags are cleared. DataBlockEnd flag is
    polled for 1. Then DMALSREQ  flag is polled for 0. The DPSM is
    disabled.
    DMALBREQ:
    =========
    The MMCI is programmed for block data transfer in Standard bus mode.
    MMCI is programmed to transmit the data. The DataLength register is
    programmed for 40 bytes(10 words), The Trickbox is programmed to
    give a correct CRC token. The TokenTimer register is programmed
    for a small value say 0x00000010. The data transfer is initiated.
    The transmit FIFO in MMCI is filled with 8 words when the TxActive
    flag is asserted. The DMALBREQ  flag is polled for 0. Then 1 more
    data is written into MMCI FIFO. The DMALBREQ is polled. It is
    expected to get  set. Then the DMACLR signal is asserted. Then 1
    more data is written into MMCI FIFO. The DMALBREQ is polled for 0.
    Then DPSM is disabled.
    The MMCI is programmed for block data transfer in Standard bus mode.
    MMCI is programmed to receive the data. The DataLength register is
    programmed for 32 bytes(8 words), The Trickbox is filled with 8
    words of data. Program the DataTimeOut register in the MMCI to a
    high value, say 0x0000A000. The data transfer is initiated. The
    DataCounter register is polled for 1. The DMALBREQ  flag is polled
    for 0. The DataCounter register is polled for 0. The DMALBREQ is
    polled. It is expected to get  set. Then the DMACLR signal is
    asserted and the DPSM is disabled. The DataLength register is
    programmed for 36 bytes(9 words), The Trickbox is filled with 9
    words of data. The data transfer is initiated. The DataCounter
    register is polled for 0. The DMALBREQ is polled. It is expected
    to get cleared. The DPSM is disabled.
    DMABREQ:
    ========
    The MMCI is programmed for block data transfer in Standard bus mode.
    MMCI is programmed to transmit the data. The DataLength register is
    programmed for 36 bytes(9 words). The Trickbox is programmed to
    give a correct CRC token. The TokenTimer register is programmed
    for a small value say 0x00000010. The data transfer is initiated.
    The transmit FIFO in MMCI is filled with 8 words when the TxActive
    flag is asserted. Then DMABREQ  flag is polled for 1. Then the
    DMACLR signal is asserted. The transmit FIFO in MMCI is filled with
    1 more words of data. The DMABREQ  flag is polled for 0. The DPSM
    is disabled.
    The MMCI is programmed for block data transfer in Standard bus mode.
    MMCI is programmed to receive the data. The DataLength register is
    programmed for 32 bytes(8 words), The Trickbox is filled with 32
    words of data. Program the DataTimeOut register in the MMCI to a
    high value, say 0x0000A000. The data transfer is initiated. The
    DataCounter register is polled for 1, then DMABREQ  flag is polled
    for 0. The DataCounter register is polled for 0, then DMABREQ is
    polled for 0. The DPSM is disabled. The DataLength register is
    programmed for 36 bytes(9 words), The Trickbox is filled with 36
    words of data. Program the DataTimeOut register in the MMCI to a
    high value, say 0x0000A000. The data transfer is initiated. The
    DataCounter register is polled for 1, then DMABREQ  flag is polled
    for 0. The DataCounter register is polled for 0, then DMABREQ is
    polled. It is expected to get set. Then the DMACLR signal is
    asserted and the DPSM is disabled.
  */
  int32 i, data1, data2, data2and, data1and, data3, expr;
  srand(SEED);
  for(i=0x00; i<0x10; i++)
    {
      data1 = rand();
      data2 = rand();
      data2and = (data2 & 0x00007FFF) << 15;
      data1and = data1 & 0x00007FFF;
      data3 = (rand()) << 30;
      dataarray[i] = (data3 | data2and | data1and);
    }

  PSW(POWERON | VOLTAGE3, MMCIPower);
  Idle(((DELAY)+(PCLK_PERIOD/MCLK_PERIOD)) * 0x5);
  PSW(0x00010000,MMCITBPCDisable);
  PSW(CLKENB, MMCIClock);
  Idle(((DELAY)+(PCLK_PERIOD/MCLK_PERIOD)) * 0xA);
  PSW(0x00000000,MMCITBPCDisable);
  CLKDIV = 0;
  PSW(0x00000009, MMCITBRespTimer);
  PSW(0x00000004, MMCISelect);
  PSW(CLEARALL, MMCIClear);

  PSW(0x00000FFF, MMCIDataTimer);
  PSW(0x00000FFF, MMCITBDataTimer);

  /* DMA Flag testing, while transmitting, and DMAENB set */

  C("DMA Flag testing, while transmitting, and DMAENB set");
  PSW(0x00000044,MMCIDataLength);

  PSW(DATA_0s,MMCITBControl);
  PSW(0x00000100,MMCITBTokenTimer);
  PSW(DATA_0s,MMCITBBusyTimer);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x000000FF);
  PSW(DATATXRENB | DMAENAB | BLOCKSIZE2, MMCIDataCtrl);
  PO(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus,0x000000FF);
  for(i=0x00; i<0x8; i++)
    {
      PO(0x00000002, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
      PSW(dataarray[i], MMCIFIFO);
      Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
      PSR(0x00000002, TBMASKDMA, MMCITBSIGSTAT);
      PSW(DMACLROUT, MMCITBControl);
      PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
      PSW(DATA_0s, MMCITBControl);
      Idle((DELAY) * (2*(CLKDIV + 1)) );
    }
  PO(0x00000002, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
  PSW(dataarray[0x8], MMCIFIFO);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
  PSR(0x00000002, TBMASKDMA, MMCITBSIGSTAT);
  PSW(DMACLROUT, MMCITBControl);
  PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
  PSW(0x00000000, MMCITBControl);
  PO(0x00000008, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);

  PSW(dataarray[0x9], MMCIFIFO);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
  PSR(0x00000008, TBMASKDMA, MMCITBSIGSTAT);
  PSW(DMACLROUT, MMCITBControl);
  PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
  PSW(DATA_0s, MMCITBControl);
  PO(0x00000001, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);

  for(i=0x0A; i<0xF; i++)
    {
      PO(0x00000001, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
      PSW(dataarray[i], MMCIFIFO);
      Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
      PSR(0x00000001, TBMASKDMA, MMCITBSIGSTAT);
      PSW(DMACLROUT, MMCITBControl);
      PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
      PSW(DATA_0s, MMCITBControl);
      Idle((DELAY) * (2*(CLKDIV + 1)) );
    }

  PO(0x00000001, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
  PSW(dataarray[0xF], MMCIFIFO);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
  PSR(0x00000001, TBMASKDMA, MMCITBSIGSTAT);
  PSW(DMACLROUT, MMCITBControl);
  PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
  PSW(DATA_0s, MMCITBControl);
  PO(0x00000004, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);

  PSW(dataarray[0x0], MMCIFIFO);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
  PSR(0x00000004, TBMASKDMA, MMCITBSIGSTAT);
  PSW(DMACLROUT, MMCITBControl);
  PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
  PSW(DATA_0s, MMCITBControl);
  PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);

  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
  expr = ((DELAY) +
                                 (PCLK_PERIOD/MCLK_PERIOD)) * 0x05;
  PSW(expr,MMCITBTokenTimer);
  PO(0x00000000, TXACTIVE, MMCIStatus,0x0000FFFF);
  for(i=0x00; i<0x10; i++)
    {
      PSW(dataarray[i], MMCITBFIFOReg);
    }
  PSW(DATA_Fs, MMCIClear);
  PSW(DATA_0s, MMCIDataCtrl);

  C("End of DMA Flag testing, while transmitting, and DMAENB set");

  /* DMA Flag testing, while transmitting, and DMAENB cleared */

  C("Start of DMA Flag testing, while transmitting,and DMAENB cleared");
  PSW(0x00000044,MMCIDataLength);

  PSW(DATA_0s,MMCITBControl);
  PSW(0x00000005,MMCITBTokenTimer);
  PSW(DATA_0s,MMCITBBusyTimer);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | BLOCKSIZE2;
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);
  PSW(local, MMCIDataCtrl);
  PO(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus,0x0000FFFF);
  for(i=0x00; i<0x10; i++)
    {
      PSW(dataarray[i], MMCIFIFO);
      PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
    }

  PSW(dataarray[0], MMCIFIFO);
  PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
  PSW(0x00000440,MMCITBPCDisable);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x3);
  PSW(DATA_0s, MMCIDataCtrl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x3);
  C("End of DMA Flag testing, while transmitting,and DMAENB cleared");

  /* DMASREQ Flag testing, while receiving, DMAENB set */

  C("Start of DMASREQ Flag testing, while receiving, DMAENB set");

  PSW(TBRESET, MMCITBControl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);
  PSW(DATA_0s, MMCITBControl);

  PSW(0x00000008,MMCIDataLength);
  PSW(DATA_0s,MMCITBControl);
  expr = ((DELAY) +
                                 (PCLK_PERIOD/MCLK_PERIOD)) * 0x10;

  PSW(expr, MMCIDataTimer);
  PSW(expr, MMCITBDataTimer);

  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  PSW(dataarray[0], MMCITBFIFOReg);
  PSW(dataarray[1], MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATATXRENB | DATARXDIR | DMAENAB | BLOCKSIZE2, MMCIDataCtrl);
  PSW(0x00000000,MMCITBPCDisable);
  PO(0x00000001, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000000, TBMASKDMA, MMCITBSIGSTAT);
  PO(0x00000000, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000001, TBMASKDMA, MMCITBSIGSTAT);
  PO(0x00000100, DATAEND, MMCIStatus,0x0000FFFF);

  PSW(0x00000440,MMCITBPCDisable);
  PSW(DATA_0s,MMCIDataCtrl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);
  PSW(DMACLROUT, MMCITBControl);
  PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
  PSW(DATA_0s, MMCITBControl);

  PSW(0x00000020,MMCIDataLength);
  PSW(DATA_0s,MMCITBControl);

  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  for (i=0x00; i<0x8; i++)
    PSW(dataarray[i], MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATATXRENB | DATARXDIR | DMAENAB | BLOCKSIZE2, MMCIDataCtrl);
  PSW(0x00000000,MMCITBPCDisable);
  PO(0x00000001, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000000, TBMASKDMA, MMCITBSIGSTAT);
  PO(0x00000000, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000008, TBMASKDMA, MMCITBSIGSTAT);
  PO(0x00000100, DATAEND, MMCIStatus,0x0000FFFF);

  PSW(DMACLROUT, MMCITBControl);
  PSW(0x00000440,MMCITBPCDisable);
  PSW(DATA_0s,MMCIDataCtrl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);
  PSW(DMACLROUT, MMCITBControl);
  PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
  PSW(DATA_0s, MMCITBControl);

  C("End of DMASREQ Flag testing, while receiving, DMAENB set");

  PSW(DATA_Fs, MMCIClear);

  /* DMA Flag testing, while Receiving, and DMAENB cleared */

  C("Start of DMASREQ Flag testing, while receiving, DMAENB cleared");
  PSW(0x00000008,MMCIDataLength);
  PSW(DATA_0s,MMCITBControl);

  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  PSW(dataarray[0], MMCITBFIFOReg);
  PSW(dataarray[1], MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | DATARXDIR | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PSW(0x00000000,MMCITBPCDisable);
  PO(0x00000001, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000000, TBMASKDMA, MMCITBSIGSTAT);
  PO(0x00000000, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000000, TBMASKDMA, MMCITBSIGSTAT);
  PSW(0x00000440,MMCITBPCDisable);
  PSW(DATA_0s, MMCIDataCtrl);
  PSW(TBRESET, MMCITBControl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);
  PSW(DATA_0s, MMCITBControl);

  C("End of DMASREQ Flag testing, while receiving, DMAENB cleared");

  /* DMALSREQ Flag testing, while receiving, and DMAENB set */

  C("Start of DMALSREQ Flag testing, while receiving, DMAENB set");
  PSW(0x00000004,MMCIDataLength);
  PSW(DATA_0s,MMCITBControl);

  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  PSW(dataarray[0], MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATATXRENB | DATARXDIR | DMAENAB | BLOCKSIZE2, MMCIDataCtrl);
  PSW(0x00000000,MMCITBPCDisable);
  PO(0x00000001, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PI(0x1);
  PO(0x00000000, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000004, TBMASKDMA, MMCITBSIGSTAT);
  PSW(DMACLROUT, MMCITBControl);
  PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
  PSW(DATA_0s, MMCITBControl);
  PSW(0x00000440,MMCITBPCDisable);
  PSW(DATA_0s,MMCIDataCtrl);

  PSW(TBRESET, MMCITBControl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);
  PSW(DATA_0s, MMCITBControl);

  PSW(0x00000008,MMCIDataLength);
  PSW(DATA_0s,MMCITBControl);

  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  PSW(dataarray[0], MMCITBFIFOReg);
  PSW(dataarray[1], MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATATXRENB | DATARXDIR | DMAENAB | BLOCKSIZE2, MMCIDataCtrl);
  PSW(0x00000000,MMCITBPCDisable);
  PO(0x00000001, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000000, TBMASKDMA, MMCITBSIGSTAT);
  PO(0x00000000, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000001, TBMASKDMA, MMCITBSIGSTAT);
  PSW(0x00000440,MMCITBPCDisable);
  PSW(DATA_0s,MMCIDataCtrl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);

  PSW(DATA_Fs, MMCIClear);
  PSW(TBRESET, MMCITBControl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);
  PSW(DATA_0s, MMCITBControl);
  C("End of DMALSREQ Flag testing, while receiving, DMAENB set");

  /* DMA Flag testing, while transmitting, and DMAENB cleared */

  C("Start of DMALSREQ Flag testing, while receiving, DMAENB cleared");
  PSW(0x00000004,MMCIDataLength);
  PSW(DATA_0s,MMCITBControl);

  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  PSW(dataarray[0], MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | DATARXDIR | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PSW(0x00000000,MMCITBPCDisable);
  PO(0x00000000, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000000, TBMASKDMA, MMCITBSIGSTAT);
  PSW(0x00000440,MMCITBPCDisable);
  expr = ((DELAY) +
                                 (PCLK_PERIOD/MCLK_PERIOD)) * 0x10;
  Idle(expr);
  PSW(0x00000440,MMCITBPCDisable);
  PSW(DATA_0s, MMCIDataCtrl);
  PSW(DATA_Fs, MMCIClear);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);

  PSW(TBRESET, MMCITBControl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);
  PSW(DATA_0s, MMCITBControl);

  C("End of DMALSREQ Flag testing, while receiving, DMAENB cleared");

  /* DMALBREQ Flag testing, while receiving, DMAENB set */

  C("Start of DMALBREQ Flag testing, while receiving, DMAENB set");
  PSW(0x00000020,MMCIDataLength);

  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  for (i=0x00; i<0x8; i++)
    PSW(dataarray[i], MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATATXRENB | DATARXDIR | DMAENAB | BLOCKSIZE2, MMCIDataCtrl);
  PSW(0x00000000,MMCITBPCDisable);
  PO(0x00000001, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000000, TBMASKDMA, MMCITBSIGSTAT);
  PO(0x00000000, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000008, TBMASKDMA, MMCITBSIGSTAT);
  PSW(DMACLROUT, MMCITBControl);
  PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
  PSW(DATA_0s, MMCITBControl);
  PSW(0x00000440,MMCITBPCDisable);
  PSW(DATA_0s,MMCIDataCtrl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);

  PSW(DATA_Fs, MMCIClear);
  PSW(TBRESET, MMCITBControl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);
  PSW(DATA_0s, MMCITBControl);

  PSW(0x00000024,MMCIDataLength);

  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  for (i=0x00; i<0x9; i++)
    PSW(dataarray[i], MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATATXRENB | DATARXDIR | DMAENAB | BLOCKSIZE2, MMCIDataCtrl);
  PSW(0x00000000,MMCITBPCDisable);
  PO(0x00000001, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000002, TBMASKDMA, MMCITBSIGSTAT);
  PO(0x00000000, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000002, TBMASKDMA, MMCITBSIGSTAT);
  PSW(DMACLROUT, MMCITBControl);
  PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
  PSW(DATA_0s, MMCITBControl);
  PSW(0x00000440,MMCITBPCDisable);
  PSW(DATA_0s,MMCIDataCtrl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);

  PSW(TBRESET, MMCITBControl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);
  PSW(DATA_0s, MMCITBControl);

  PSW(DATA_Fs, MMCIClear);

  C("End of DMALBREQ Flag testing, while receiving, DMAENB set");

  /* DMALBREQ Flag testing, while receiving, DMAENB cleared */

  C("Start of DMALBREQ Flag testing, while receiving, DMAENB cleared");

  PSW(0x00000020,MMCIDataLength);

  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  for (i=0x00; i<0x8; i++)
    PSW(dataarray[i], MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | DATARXDIR | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PSW(0x00000000,MMCITBPCDisable);
  PO(0x00000001, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000000, TBMASKDMA, MMCITBSIGSTAT);
  PO(0x00000000, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000000, TBMASKDMA, MMCITBSIGSTAT);
  PSW(0x00000440,MMCITBPCDisable);
  PSW(DATA_0s, MMCIDataCtrl);
  PSW(TBRESET, MMCITBControl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);

  C("End of DMALBREQ Flag testing, while receiving, DMAENB cleared");

  /* DMABREQ Flag testing, while receiving, when DMAENB set */

  C("Start of DMABREQ Flag testing, while receiving, DMAENB set");

  PSW(0x00000020,MMCIDataLength);
  PSW(DATA_0s,MMCITBControl);

  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  for (i=0x00; i<0x8; i++)
    PSW(dataarray[i], MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATATXRENB | DATARXDIR | DMAENAB | BLOCKSIZE2, MMCIDataCtrl);
  PSW(0x00000000,MMCITBPCDisable);
  PO(0x00000001, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000000, TBMASKDMA, MMCITBSIGSTAT);
  PO(0x00000000, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000008, TBMASKDMA, MMCITBSIGSTAT);
  PSW(DMACLROUT, MMCITBControl);
  PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
  PSW(DATA_0s, MMCITBControl);
  PSW(0x00000440,MMCITBPCDisable);
  PSW(DATA_0s, MMCIDataCtrl);
  PSW(TBRESET, MMCITBControl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);
  PSW(DATA_0s, MMCITBControl);

  PSW(DATA_Fs, MMCIClear);

  PSW(0x00000024,MMCIDataLength);
  PSW(DATA_0s,MMCITBControl);

  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  for (i=0x00; i<0x9; i++)
    PSW(dataarray[i], MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATATXRENB | DATARXDIR | DMAENAB | BLOCKSIZE2, MMCIDataCtrl);
  PSW(0x00000000,MMCITBPCDisable);
  PO(0x00000001, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000002, TBMASKDMA, MMCITBSIGSTAT);
  PSW(DMACLROUT, MMCITBControl);
  PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
  PSW(DATA_0s, MMCITBControl);
  PO(0x00000000, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000002, TBMASKDMA, MMCITBSIGSTAT);
  PSW(DMACLROUT, MMCITBControl);
  PO(0x00000000, TBMASKDMA, MMCITBSIGSTAT,0x0000FFFF);
  PSW(DATA_0s, MMCITBControl);
  PSW(0x00000440,MMCITBPCDisable);
  PSW(DATA_0s, MMCIDataCtrl);
  PSW(TBRESET, MMCITBControl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);
  PSW(DATA_0s, MMCITBControl);

  PSW(DATA_Fs, MMCIClear);

  C("End of DMABREQ Flag testing, while receiving, DMAENB set");

  /* DMABREQ Flag testing, while receiving, when DMAENB cleared */

  C("Start of DMABREQ Flag testing, while receiving, DMAENB cleared");

  PSW(0x00000024,MMCIDataLength);
  PSW(DATA_0s,MMCITBControl);

  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  for (i=0x00; i<0x9; i++)
    PSW(dataarray[i], MMCITBFIFOReg);
  PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | DATARXDIR | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PSW(0x00000000,MMCITBPCDisable);
  PO(0x00000001, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000000, TBMASKDMA, MMCITBSIGSTAT);
  PO(0x00000000, MASK_MMCIFifoCnt, MMCIFifoCnt,0x0000FFFF);
  PSR(0x00000000, TBMASKDMA, MMCITBSIGSTAT);
  PSW(0x00000440,MMCITBPCDisable);
  PSW(DATA_0s, MMCIDataCtrl);
  PSW(TBRESET, MMCITBControl);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0xA);
  PSW(DATA_0s, MMCITBControl);
  PSW(0x00000000,MMCITBPCDisable);
  C("End of DMABREQ Flag testing, while receiving, DMAENB cleared");
}

/*******************************  End  ****************************************/
