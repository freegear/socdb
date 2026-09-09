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
-- File Name              : FIFOTransmitTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           FIFO tests with the MMCI programmed for transmission
--
-- --=========================================================================*/

/******************************************************************************/
/****************************  FIFOTRANSMIT  Test *****************************/
/******************************************************************************/

void FIFOTransmitTest ()
{
  /*
     Summary : FIFOTransmitTest
     ==========================

     Testing the FIFO in Transmit mode
     ---------------------------------
     In this test several words of data are written to the FIFO with
     the MMCI in the transmit mode. The APB address used for writing to
     the FIFO is randomly chosen from within the address range of
     (MMCI_BaseAddr + 0x80) and (MMCI_BaseAddr + 0xBC). Data transfer is
     allowed to occur. The receive FIFO in the Trickbox is read to
     verify correct data transmission. The objective of this test is
     to force multiple writes and reads from the FIFO when the MMCI is
     in Transmit mode.
  */
  int32 i, addr, data1, data2, data2and, data1and, data3;
  C("START OF FIFO TRANSMIT TEST");
  addr = MMCIFIFO;
  srand(SEED);
  for (i=0x00; i<0x10; i++)
    {
      data1 = rand();
      data2 = rand();
      data2and = (data2 & 0x00007FFF) << 15;
      data1and = data1 & 0x00007FFF;
      data3 = (rand()) << 30;
      dataarray[i] = (data3 | data2and | data1and);
    }
  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);
  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000001F, MMCITBDataTimer);
  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);
  PSW(POWERON | VOLTAGE3, MMCIPower);
  PSW(0x00000040,MMCIDataLength);

  PSW(DATA_0s,MMCITBControl);
  PSW(0x00000005,MMCITBTokenTimer);
  PSW(DATA_0s,MMCITBBusyTimer);
  PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
  local = DATATXRENB | BLOCKSIZE2;
  PSW(local, MMCIDataCtrl);
  PO(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus,0x0000FFFF);
  for( i=0x00; i<0x10; i++)
    {
      PSW(dataarray[i], addr);
      addr = addr + 4;
    }
  for (i=0x00; i<0x10; i++)
    {
      PO(0x00000400, DATABLOCKEND, MMCIStatus,0x0000FFFF);
      PSR(dataarray [i], MASK_TBMMCIFIFO, MMCITBFIFOReg,dataread);
      PSR(DATA_0s, MASK_TBDATACRC, MMCITBCrcErrStat);
      if (i != 0x0F)
      PSW(DATABLOCKENDCLR, MMCIClear);
      Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) + ((PCLK_PERIOD /
                    MCLK_PERIOD) + 1)) * (2 * (CLKDIV + 1)) * 0x02);
    }

    Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) + ((PCLK_PERIOD /
            MCLK_PERIOD) + 1)) * (2 * (CLKDIV + 1)) * 0x0A);

  C("END OF FIFO TRANSMIT TEST");

}

/*******************************  End  ****************************************/
