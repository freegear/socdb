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
-- File Name              : DataCounterTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Test to verify DataCounter operation
--
-- --=========================================================================*/

/******************************************************************************/
/****************************** DataCounterTest *******************************/
/******************************************************************************/
void DataCounterTest(int DataCrcFailTx, int DataCrcFailRx,
                     int DataTimeOutTx, int DataTimeOutRx,
                     int TxUnderrun, int RxOverrun, int32 DataLen)
{
/*
   Summary: DataCounter Test
   =========================
   The DataCounter is checked after bringing out the following error
   conditions :
   o The DataCRC fail condition is initiated when transmitting as well
     as receiving and the DataCounter register value is read back after
     the flag is set. It is expected to indicate the loaded value minus
     the Block length.
   o The DataTimeOut condition is initiated when transmitting as well
     as receiving and the DataCounter register value is read back after
     the flag is set. This test is carried out in Wide bus and stream
     mode.
   o The TxUnderrun and RxOverrun conditions are created and the
     DataCounter register value is read back after the corresponding
     flag is set.
   o The StartBit error condition is introduced on each bit of
     MMCIDATAIN[3:0] and the the DataCounter register value is read back
     after the flag is set.
*/

  int32 i, expr, expr1, expr2;

  Idle(((MCLK_PERIOD/PCLK_PERIOD)+(PCLK_PERIOD/MCLK_PERIOD)) * 0x4);
  PSW(POWERON | VOLTAGE15, MMCIPower);
  PSW(0x00010000,MMCITBPCDisable);
  PSW(CLKENB, MMCIClock);
  Idle(((MCLK_PERIOD/PCLK_PERIOD)+(PCLK_PERIOD/MCLK_PERIOD)) * 0x4);
  PSW(0x00000440,MMCITBPCDisable);


  if(TxUnderrun == 1)
  {
  /* Testing in standard bus mode and when MMCI is transmitting */
    C("Start of DataCounter Test - TxUnderrun induced during Transmission");

    PSW(TBRESET, MMCITBControl);
    Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0xA);
    PSW(DATA_0s, MMCITBControl);

    PSW(0x00000048, MMCIDataLength);
    expr = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0xA;
    PSW(expr, MMCIDataTimer);
    PSW(expr, MMCITBDataTimer);
    PSW(DATA_0s, MMCITBBusyTimer);
    PSW(0x00000005, MMCITBTokenTimer);
    PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
    PSW(DATATXRENB | BLOCKSIZE3, MMCIDataCtrl);
    PSR(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus);
    for (i=0x0 ; i<16; i++)
      PSW(DATA_5s, MMCIFIFO);
    PO(0x00004000, TXFIFOHALFEMPTY, MMCIStatus,0x0000FFFF);
    PSW(DATA_5s, MMCIFIFO);
    PO(0x00000010, TXUNDERRUN, MMCIStatus,0x0000FFFF);
    PSW(DATA_Fs, MMCIClear);
    PSR(0x00000004, MASK_MMCIDataCnt, MMCIDataCnt);
    PSW(DATA_0s, MMCIDataCtrl);
    Idle(((MCLK_PERIOD/PCLK_PERIOD)+(PCLK_PERIOD/MCLK_PERIOD)) * 0x4);

    C("End of DataCounter Test - TxUnderrun induced during Transmission");
  }
  if(DataCrcFailTx == 1)
  {
  /* When UUT is txg in block mode and in standard bus format*/
    C("Start of DataCounter Test - Crc fail induced while transmitting");

    Idle(((MCLK_PERIOD/PCLK_PERIOD)+(PCLK_PERIOD/MCLK_PERIOD)) * 0x4);
    PSW(DataLen, MMCIDataLength);
    PSW(WRONGCRCORTOKEN, MMCITBControl);
    PSW(0x0000001F, MMCIDataTimer);
    PSW(0x0000001F, MMCITBDataTimer);
    PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
    local = DATATXRENB | BLOCKSIZE2;
    PSW(local, MMCIDataCtrl);
    PSR(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus);
    for(i=0x0; i<DataLen/0x4; i++)
      PSW(DATA_5s, MMCIFIFO);
    PO(0x00000002, DATACRCFAIL, MMCIStatus,0x0000FFFF);
    PSW(DATA_Fs, MMCIClear);
    expr = DataLen - 0x4;
    PSR(expr, MASK_MMCIDataCnt, MMCIDataCnt);
    C("End of DataCounter Test - Crc fail induced while transmitting");
  }

  if(DataCrcFailRx == 1)
  {
  /* When UUT is Rxg in block mode and in standard bus format*/
    C("Start of DataCounter Test - Crc fail induced while receiving");

    PSW(TBRESET, MMCITBControl);
    Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0xA);
    PSW(DATA_0s, MMCITBControl);

    PSW(DataLen, MMCIDataLength);
    PSW(WRONGDATACRC0, MMCITBControl);
    expr = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0x5F;
    PSW(expr, MMCIDataTimer);
    PSW(expr - 0x5, MMCITBDataTimer);
    PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
    for(i=0x0; i<DataLen/0x4; i++)
      PSW(DATA_5s, MMCITBFIFOReg);
    PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
    local = DATATXRENB | DATARXDIR | BLOCKSIZE2;
    PSW(local, MMCIDataCtrl);
    PO(0x00002000, RXACTIVE, MMCIStatus);
    expr = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0x03;
    PI(expr);
    PO(0x00000002, DATACRCFAIL, MMCIStatus,0x0000FFFF);
    PSW(DATA_Fs, MMCIClear);
    expr = DataLen - 0x4;
    PSR(expr, MASK_MMCIDataCnt, MMCIDataCnt);
    C("End of DataCounter Test - Crc fail induced while receiving");
  }

  if(DataTimeOutTx == 1)
  {
  /* Test is carried out in standard bus mode, where token is delayed */
    C("Start of DataCounter Test - DataTimeout induced while transmitting");
    C("Token response from Trickbox is delayed");

    PSW(TBRESET, MMCITBControl);
    Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0xA);
    PSW(DATA_0s, MMCITBControl);

    PSW(DataLen, MMCIDataLength);
    expr1 = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0xF;
    expr2 = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0x1F;
    PSW(expr1, MMCIDataTimer);
    PSW(expr2, MMCITBTokenTimer);
    PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
    local = DATATXRENB | BLOCKSIZE2;
    PSW(local, MMCIDataCtrl);
    PSR(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus);
    for(i=0x0; i<DataLen/0x4; i++)
      PSW(DATA_5s, MMCIFIFO);
    PO(0x00000008, DATATIMEOUT, MMCIStatus,0x0000FFFF);
    PSW(DATA_Fs, MMCIClear);
    expr = DataLen - 0x4;
    PSR(expr, MASK_MMCIDataCnt, MMCIDataCnt);


  /* Test is carried out in standard bus mode, where BUSY is delayed */

    C("Busy indication from Trickbox is prolonged");

    PSW(TBRESET, MMCITBControl);
    Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0xA);
    PSW(DATA_0s, MMCITBControl);

    PSW(DataLen, MMCIDataLength);
    PSW(0x00000000, MMCITBTokenTimer);
    expr1 = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0xF;
    expr2 = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0x1F;
    PSW(expr1, MMCIDataTimer);
    PSW(expr2, MMCITBBusyTimer);
    PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
    local = DATATXRENB | BLOCKSIZE2;
    PSW(local, MMCIDataCtrl);
    PSR(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus);
    for(i=0x0; i<DataLen/0x4; i++)
      PSW(DATA_5s, MMCIFIFO);
    PO(0x00000008, DATATIMEOUT, MMCIStatus,0x0000FFFF);
    PSW(DATA_Fs, MMCIClear);
    expr = DataLen - 0x4;
    PSR(expr, MASK_MMCIDataCnt, MMCIDataCnt);

    C("End of DataCounter Test - DataTimeout induced while transmitting");

  }
  if(DataTimeOutRx == 1)
  {
  /* Testing in standard bus mode where start bit is delayed */
    C("Start of DataCounter Test - DataTimeout induced while receiving");

    PSW(TBRESET, MMCITBControl);
    Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0xA);
    PSW(DATA_0s, MMCITBControl);

    PSW(CLEARALL, MMCIClear);
    PSW(DataLen, MMCIDataLength);
    expr = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0x5F;
    PSW(expr, MMCIDataTimer);
    PSW(expr - 0xA, MMCITBDataTimer);
    PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
    for(i=0x0; i<DataLen/0x4; i++)
      PSW(DATA_5s, MMCITBFIFOReg);
    PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
    local = DATATXRENB | DATARXDIR | BLOCKSIZE2;
    PSW(local, MMCIDataCtrl);
    PO(0x00002000, RXACTIVE, MMCIStatus, 0x0000FFFF);
    expr1 = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0x3F;
    expr2 = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0x5F;
    PSW(expr1, MMCIDataTimer);
    PSW(expr2, MMCITBDataTimer);
    PO(0x00000008, DATATIMEOUT, MMCIStatus,0x0000FFFF);
    PSW(DATA_Fs, MMCIClear);
    expr = DataLen - 0x4;
    PSR(expr, MASK_MMCIDataCnt, MMCIDataCnt);
    C("End of DataCounter Test - DataTimeout induced while receiving");

  }
  if(RxOverrun == 1)
  {
  /* Testing in standard mode when MMCI is rxg */
    C("Start of DataCounter Test - RxOverrun induced while receiving");

    PSW(TBRESET, MMCITBControl);
    Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0xA);
    PSW(DATA_0s, MMCITBControl);

    PSW(0x00000048, MMCIDataLength);
    expr1 = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0x05;
    expr2 = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0x5F;
    PSW(expr2, MMCIDataTimer);
    PSW(expr1, MMCITBDataTimer);
    PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
    for (i=0x0 ; i<18; i++)
      PSW(DATA_As, MMCITBFIFOReg);
    local = DATATXRENB | DATARXDIR | BLOCKSIZE2;
    PSW(local, MMCIDataCtrl);
    expr = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0xA;
    PI(expr);
    PSR(0x00002000, RXACTIVE, MMCIStatus);
    PO(0x00000020, RXOVERRUN, MMCIStatus,0x0000FFFF);
    PSR(0x00000004, MASK_MMCIDataCnt, MMCIDataCnt,RXOVERRUNREAD);
    PSW(DATA_Fs, MMCIClear);
    PSW(DATA_0s, MMCIDataCtrl);
    expr = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0xA;
    PI(expr);

    C("End of DataCounter Test - RxOverrun induced while receiving");
  }
    PSW(0x00000000,MMCITBPCDisable);
}

/*******************************  End  ****************************************/
