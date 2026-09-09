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
-- File Name              : FifoCounterTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Tests to verify FIFOCounter operation
--
-- --=========================================================================*/

/******************************************************************************/
/****************************** FifoCounterTest *******************************/
/******************************************************************************/
void FifoCounterTest(int32 DataLen, int32 BlokLen, int Txmode)
{
/*
   Summary: FifoCounter Test
   =========================
   In this test the DataLenth is programmed for different values, the
   BlockLength is programmed for word, half word and byte boundaries.
   MMCI is programmed for both transmission and reception mode. After a
   precalculated delay the FIFOCounter is read back for the expected
   values.
*/
    int32 bloklenand, LoopCnt, DataLenTemp, fifocnt, DataLenand, expr;
    int32 Data, byteblock, wordblok;
    int toggle;

    toggle = 0;
    DataLenand = DataLen & 0x3;
    bloklenand = BlokLen << 4;
    byteblock  = 0x00000001 << BlokLen;
    wordblok = byteblock >> 2;
    if (DataLenand == 0x0)
      fifocnt = DataLen >> 2;
    else
      fifocnt = DataLen >> 2 + 0x1;
    C("Start of FifoCounter Test");
   sprintf(printstr,"Bytes per block = %d  Fifocnt(Number of words to be transferred) = %d",byteblock,fifocnt);
   C(printstr);

    PSW(POWERON | VOLTAGE15, MMCIPower);
    PSW(0x00010440,MMCITBPCDisable);
    PSW(CLKENB, MMCIClock);
    Idle((MCLK_PERIOD/PCLK_PERIOD)+(PCLK_PERIOD/MCLK_PERIOD) * 0xA);
    PSW(0x00000000,MMCITBPCDisable);

    PSW(TBRESET, MMCITBControl);
    Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0xF);
    PSW(DATA_0s, MMCITBControl);
    PSW(DATA_0s, MMCITBBusyTimer);

    PSW(0x00000440, MMCITBPCDisable);
    PSW(CLEARALL, MMCIClear);
    PSW(DataLen, MMCIDataLength);
    expr = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0x5;
    PSW(expr, MMCITBTokenTimer);
    PSW(expr + 0xF, MMCIDataTimer);
    PSW(expr + 0xA, MMCITBDataTimer);

    if (Txmode == 1)
    {
      DataLenTemp = DataLen;
      PO(0x00000000,TXACTIVE, MMCIStatus,0x0000FFFF);
      PSW(bloklenand | DATATXRENB, MMCIDataCtrl);
      PO(0x00005000, TXACTIVE | TXFIFOHALFEMPTY, MMCIStatus,0x0000FFFF);
      for(LoopCnt = 0x0; LoopCnt < 0x4; LoopCnt = LoopCnt + 0x1)
        {
          Data = LoopCnt + 0x1234;
          PSW(Data, MMCIFIFO);
        }
        fifocnt = fifocnt - 0x1;
        if (BlokLen >= 0x3)
          Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0xF);
        else
          Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0x3F);
        PSR(fifocnt, MASK_MMCIFifoCnt, MMCIFifoCnt,FirstRead);
        for(LoopCnt = 0x1; LoopCnt < 0x4; LoopCnt++)
          {
            fifocnt = fifocnt - 0x1;
            if ((DataLenTemp > 0x0) && (fifocnt >= 0x0))
            {
              if (BlokLen > 0x3)
              {
                expr = 0x8 * 0x4;
                Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) *
                                                                 expr);
              }
              if (BlokLen == 0x3)
              {
                if ((LoopCnt % wordblok) == 0x0)
                {
                  expr = 0x8 * 0x4 + 0x18 + (MCLK_PERIOD/PCLK_PERIOD
                                      + PCLK_PERIOD/MCLK_PERIOD) * 0x5;
                  Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) *
                                                                 expr);
                }
                else
                {
                  expr = 0x8 * 0x4;
                  Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) *
                                                                 expr);
                }
              }
              if (BlokLen == 0x2)
              {
                expr = 0x8 * 0x4 + 0x1B + (MCLK_PERIOD/PCLK_PERIOD
                                      + PCLK_PERIOD/MCLK_PERIOD) * 0x5;
                Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) *
                                                                 expr);
              }
              if (BlokLen == 0x1)
              {
                expr = 0x8 * 0x4 + 0x3F + (MCLK_PERIOD/PCLK_PERIOD
                                      + PCLK_PERIOD/MCLK_PERIOD) * 0x5;
                Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) *
                                                                 expr);
              }
              if (BlokLen == 0x0)
              {
                expr = 0x8 * 0x4 + 0x90 + (MCLK_PERIOD/PCLK_PERIOD
                                      + PCLK_PERIOD/MCLK_PERIOD) * 0x5;
                Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) *
                                                                 expr);
              }
              PSR(fifocnt, MASK_MMCIFifoCnt, MMCIFifoCnt,NextRead);
            }
            else
            {
              PSW(DATA_0s, MMCIDataCtrl);
              Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0x2);
            }
            DataLenTemp = DataLenTemp - 0x4;
          }
    }
    else
    {
      expr = (MCLK_PERIOD/PCLK_PERIOD + PCLK_PERIOD/MCLK_PERIOD) * 0x5;
      PSW(expr + 0x5, MMCIDataTimer);
      PSW(expr, MMCITBDataTimer);
      DataLenTemp = DataLen;
      PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
      for (LoopCnt=0x0 ; LoopCnt<4; LoopCnt++)
        PSW(DATA_As, MMCITBFIFOReg);
      PSW(bloklenand | DATATXRENB | DATARXDIR, MMCIDataCtrl);
      Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0x10);
      for (LoopCnt=0x0 ; LoopCnt<4; LoopCnt++)
      {
        fifocnt = fifocnt - 0x1;
        if ((DataLenTemp > 0x0) && (fifocnt >= 0x0))
        {
          if (BlokLen > 0x3)
          {
            expr = 0x8 * 0x4;
            Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * expr);
            PSR(fifocnt, MASK_MMCIFifoCnt, MMCIFifoCnt,NextRead);
          }
          if (BlokLen == 0x3)
          {
            expr = 0x8 * 0x4;
            Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * expr);
            if (toggle == 0)
            {
              PSR(fifocnt, MASK_MMCIFifoCnt, MMCIFifoCnt,NextRead);
              toggle = 1;
            }
            else
            {
              Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0x20);
              PSR(fifocnt, MASK_MMCIFifoCnt, MMCIFifoCnt,NextRead);
              toggle = 0;
            }
          }
          if (BlokLen == 0x2)
          {
            expr = 0x8 * 0x4;
            Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * expr);
            PSR(fifocnt, MASK_MMCIFifoCnt, MMCIFifoCnt,NextRead);
            Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0x20);
          }
          if (BlokLen == 0x1)
          {
            expr = 0x8 * 0x4;
            Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * expr);
            Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0x10);
            Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * expr);
            PSR(fifocnt, MASK_MMCIFifoCnt, MMCIFifoCnt,NextRead);
            Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0x10);
          }
          if (BlokLen == 0x0)
          {
            expr = 0x8 * 0x4;
            Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * expr);
            Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0x10);
            Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * expr);
            Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0x10);
            Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * expr);
            Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0x10);
            PSR(fifocnt, MASK_MMCIFifoCnt, MMCIFifoCnt,NextRead);
            Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0x10);
          }
        }
        DataLenTemp = DataLenTemp - 0x4;
      }
    }
    PSW(0x00000440, MMCITBPCDisable);
    PSW(DATA_0s, MMCIDataCtrl);
    Idle((MCLK_PERIOD/PCLK_PERIOD) * (2*(CLKDIV + 1)) * 0xA);
    PSW(0x00000000, MMCITBPCDisable);
    C("End of FifoCounter Test");
}

/*******************************  End  ****************************************/
