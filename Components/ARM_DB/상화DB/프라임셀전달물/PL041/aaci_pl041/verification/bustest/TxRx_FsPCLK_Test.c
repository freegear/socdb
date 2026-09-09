/* --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : TxRx_FsPCLK_Test.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose : 
--           This function programs the AACI and performs data tests 
--           to verify its operation. It is called only when
--           PCLK is faster than or has the same frequency as
--           AACIBITCLK.
--
-- --=================================================================*/

/**********************************************************************/
/*** For more information on the AACI, please refer to PL041 AMBA   ***/
/*** AACI Block Specification                                       ***/
/**********************************************************************/

/**********************************************************************/
/**************** Internal function declarations  *********************/
/**********************************************************************/
void ReadData(int32 AACIStart, int32 AACITBStart, int FrameNo,
              int32 *ReMapAACI_Buffer, int32 *ReMapAACITB_Buffer,
              int32 *RSize, int32 *TSize);

/**********************************************************************/
/*************************** TxRx_FsPCLK_Test *************************/
/**********************************************************************/
void TxRx_FsPCLK_Test(int TotNoFrame)
{
 
  /*
    Summary : TxRx_FsPCLK_Test 
    ==========================

    This function is used to verify Transmission and Reception
    operation of the AACI when PCLK is faster than or has the same 
    frequency as AACIBITCLK.

    This test checks the following functionality :

    o This function programs the AACI according to parameters passed 
      to it by the calling functions (Rx_Call, Tx_Call,
      TxRx_FsPCLK_Call). These parameters are indirectly passed by 
      updating the CW(ControlWords) structure in calling functions 
      (Tx_Call, Rx_Call,TxRx_FsPCLK_Call).
      These parameters determine the following :

      - The expected Slot0 from the AACI
      - Slot0 to be transmitted by the Trickbox
      - Register fields for the AACITXCRn (n = 1 to 4) registers
      - Register fields for the AACIRXCRn (n = 1 to 4) registers
      - SRC bit values to be transmitted by the trickbox
      - Information regarding which of the Slot registers need to
        be enabled for data transmission for each frame
      - Information regarding which of the Slot registers need to
        be enabled for data reception for each frame
      - Information regarding to which of the slot data need to be 
        written into the Tx FIFOs of the AACI for each frame
      - Information regarding to which of the AACISLnTX (n = 1 to 4)
        registers to be loaded with new data for each frame

    o This function also verifies data transmission by the AACI for
      a range of TSIZE values in Compact mode and non-Compact mode

    o Addtionally, this function verifies data reception by the AACI 
      for a range of RSIZE values in Compact mode and non-Compact mode

    o The test sequence is as follows:
      - Data is written to the AACI's Transmit FIFOs and slot registers
      - Data is written to the Trickbox's Transmit FIFO
      - Transmission and Reception is enabled.
      - The AACI and the Trickbox are enabled to allow data transfer.
      - During the transfer of any given frame, data corresponding to
        the previous frames are read out and verified and data for 
        subsequent frames are written. The reads and writes occur to 
        both the AACI and the Trickbox. With regard to the AACI,
        reads and writes occur to both the Channel FIFOs and the
        Slot registers.

   */
  int32 AACI_Buffer[150];
  int32 ReMapAACI_Buffer[150];
  int32 AACITB_Buffer[150];
  int32 ReMapAACITB_Buffer[150];
  int32 AACI_TempBuffer;
  int32 RSize[6];
  int32 TSize[6];
  int32 Temp[5];
  int NoSltPerCh[6];
  int InVldFrmState = 0;
  int i,j,k,l,m,n,Count;
  int32 MaskBit;
  int32 RMaskBit;
  int FrameNo = 1;
  int32 SltEn;
 
  C("Transmission and Reception Test starts");
 
  for (i = 0; i < 150; i++)
  {
    if (!(i % 13))
      AACITB_Buffer[i] = (CW.AACITB_SLOT0[i / 13 + 1]) << 4;
    else
      AACITB_Buffer[i] = random(10000);
 
    AACI_Buffer[i] = random(10000);
  }

  /* Every slot 1 indicates CODEC register write access */
  for (i = 1; i < 150; i = i + 13)
    AACI_Buffer[i] = 0x55555;

  /* Third frame slot 1 indicates CODEC register read access. The
     AACI is expected to stuff zeros into the transmitted slot 2 */
  AACI_Buffer[14] = 0xAAAAA;

  /* For Every Slot2 first four LSB bits are ORed with one. The AACI
     is expected to zero the 4 LSbits in the transmitted Slot 2
     when Slot 1 bit 19 indicates a CODEC register write */
  for (i = 2; i < 150; i = i + 13)
    AACI_Buffer[i] = AACI_Buffer[i] | 0xF;

  /* SRC bit is loaded into the Slot1 data */
  for (i = 1; i < 150; i = i + 13)
    AACITB_Buffer[i] = CW.AACITB_SLOT1[i / 13 + 1];
 
  for (i = 1; i < 5; i++)
    Temp[i] = 200;

  /* Extracting the RSize and the TSize information from the 
     CW.DatTxCntlReg array programmed by the calling function */
  for (i = 1; i < 5; i++)
  {
    TSize[i] = CW.DatTxCntlReg[i] & 0x6000;
    RSize[i] = CW.DatRxCntlReg[i] & 0x6000;
 
    if (RSize[i] == 0x0)
      RSize[i] = 16;
    else if (RSize[i] == 0x2000)
      RSize[i] = 18;
    else if (RSize[i] == 0x4000)
      RSize[i] = 20;
    else
      RSize[i] = 12;
 
    if (TSize[i] == 0x0)
      TSize[i] = 16;
    else if (TSize[i] == 0x2000)
      TSize[i] = 18;
    else if (TSize[i] == 0x4000)
      TSize[i] = 20;
    else
      TSize[i] = 12;
  }
  RSize[5] = 20;
  TSize[5] = 20;
 
  /* Calculate the number of valid slots for each channel */
  for (j = 1; j < 6; j++)
  {
    MaskBit = 0x2;
    NoSltPerCh[j] = 0;
    for (i = 1; i < 13; i++)
    {
      if (CW.DatTxCntlReg[j] & MaskBit)
        NoSltPerCh[j] = NoSltPerCh[j] + 1;
      MaskBit = MaskBit << 1;
    }
  }

  /* Calculate expected value for Trickbox Rx FIFO reads */
  for (i = 0; i < 150; i++)
  {
    if (!(i % 13))
      MaskBit = 0x2;
    else
    {
      ReMapAACI_Buffer[i] = AACI_Buffer[i];
      for (j = 1; j < 5; j++)
      {
        if (CW.DatTxCntlReg[j] & MaskBit)
        {
          ReMapAACI_Buffer[i] = AACI_Buffer[i] << (20 - TSize[j]);
          ReMapAACI_Buffer[i] = ReMapAACI_Buffer[i] & RMasks[TSize[j]];
        }
      }
      MaskBit = MaskBit << 1;
    }
  }

  /* Calculate expected value for reads from AACI Rx FIFOs */
  for (i = 0; i < 150; i++)
  {
    if (!(i % 13))
      MaskBit = 0x2;
    else
    {
      ReMapAACITB_Buffer[i] = AACITB_Buffer[i];
      for (j = 1; j < 5; j++)
      {
        if (CW.DatRxCntlReg[j] & MaskBit)
        {
          ReMapAACITB_Buffer[i] = AACITB_Buffer[i] >> (20 - RSize[j]);
          ReMapAACITB_Buffer[i] = ReMapAACITB_Buffer[i] &
                                  Masks[RSize[j]];
        }
      }
      MaskBit = MaskBit << 1;
    }
  }

  /* Enable AACIBITCLK by writing to the Trickbox control register */
  PSW(AACITB_En | AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);

  Idle(BITCLK_TIME * 6);

  /* Assign the initial value to SltEn - this variable holds the
    current value of the AACIMAINCR register */
  SltEn = AACI_AACIIFE | CW.SecCODEC;

  /* Enable the AACI */
  PSW(SltEn, AACIMAINCR);
 
  /* Program the AACIRXCR Registers and enable reception */
  PSW(CW.DatRxCntlReg[1], AACIRXCR1);
  PSW(CW.DatRxCntlReg[2], AACIRXCR2);
  PSW(CW.DatRxCntlReg[3], AACIRXCR3);
  PSW(CW.DatRxCntlReg[4], AACIRXCR4);
 
  /* Program the AACITXCR Registers and enable transmission */
  PSW(CW.DatTxCntlReg[1], AACITXCR1);
  PSW(CW.DatTxCntlReg[2], AACITXCR2);
  PSW(CW.DatTxCntlReg[3], AACITXCR3);
  PSW(CW.DatTxCntlReg[4], AACITXCR4);
  
  /* Enable the Slot registers based on the values programmed into
     the CW.DatTxCntlReg[5] array-element by the calling function */
  for (i = 1; i < 13; i++)
  {
    if (i == 1)
      MaskBit = 0x2;
    if (CW.DatTxCntlReg[5] & MaskBit & CW.TxRegSltEn[FrameNo + 1])
    {
      if (i == 1)
        SltEn = SltEn | AACI_S1TXE;
      else if (i == 2)
        SltEn = SltEn | AACI_S2TXE;
      else if (i == 12)
        SltEn = SltEn | AACI_S12TXE;
    }  
    if (CW.DatRxCntlReg[5] & MaskBit & CW.RxRegSltEn[FrameNo])
    {
      if (i == 1)
        SltEn = SltEn | AACI_S1RXE;
      else if (i == 2)
        SltEn = SltEn | AACI_S2RXE;
      else if (i == 12)
        SltEn = SltEn | AACI_S12RXE;
    }  
    MaskBit = MaskBit << 1;
  }
   
  /* Write the calculated value in SltEn into the AACIMAINCR
     register */
  PSW(SltEn, AACIMAINCR);

  /* Read the AACISR (Aaci Status register) to verify initial
     conditions */
  PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR1,FsP_R1);
  PI(2);
  
  PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR2,FsP_R2);
  PI(2);
  
  PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR3,FsP_R3);
  PI(2);
  
  PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR4,FsP_R4);
  PI(2);

  k = 13;
 
  /* Write data into the Aaci */
  MaskBit = 0x2;
  for(i = 1; i < k; i++)
  {
    for (j = 1; j < 5; j++)
    {
      if (CW.DatTxCntlReg[j] & MaskBit & CW.TxFIFOWtSltEn[FrameNo + 1])
      {
        if (!(CW.DatTxCntlReg[j] & AACI_CM))
        {
          PSW(AACI_Buffer[i], AACIDR[j]);
        }
        else
        {
          if (Temp[j] == 200)
            Temp[j] = i;
          else
          {
            AACI_TempBuffer = (AACI_Buffer[Temp[j]] & Masks[16]) |
                               ((AACI_Buffer[i] & Masks[16]) << 16);
            PSW(AACI_TempBuffer , AACIDR[j]);
            Temp[j] = 200;
          }
        }    
      }
    }
   
    if (CW.DatTxCntlReg[5] & MaskBit & CW.TxRegWtSltEn[FrameNo + 1])
    {
      if (i == 1)
        PSW(0x55AAA, AACISL1TX);
      else if (i == 2)
        PSW(0x55AAA, AACISL2TX);
      else if (i == 12)
        PSW(0x55AAA, AACISL12TX);
    }
    MaskBit = MaskBit << 1;
  }
 
  /* Read AACITB Status register */
  PSR(AACITB_TxFFillLevel0 | AACITB_RxFFillLevel0, Masks[12], AACITrFIFOStat,FsP_R5);
  PI(2);
 
  l = 26;

  /* Write data into the trickbox */
  for(i = 0; i < l; i++)
  {
    PSW(AACITB_Buffer[i] & Masks[20], AACITrTxFIFO);
  }

  /* Start Trickbox Transmission and Reception by enabling AACITB_TxEn 
     and AACITB_RxEn in the Trickbox control register */
   PSW(AACITB_En | AACITB_TxEn | AACITB_RxEn | AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);
   
  /* Wait for data transfer to complete and read data from the AACISL1RX
     and the AACISL2RX  registers */
  if (CW.AACITB_SLOT0[FrameNo] & 0x8000)
  {
    for (i = 1; i < 3; i++)
    {
      if (i == 1)
      {
        MaskBit = 0x2;
        RMaskBit = 0x4000;
      }
      if ((CW.DatRxCntlReg[5] & MaskBit & CW.RxRegSltEn[FrameNo]) &&
          (CW.AACITB_SLOT0[FrameNo] & RMaskBit))
      {
        if (i == 1)  
        {
          PO(AACI_SL1RXVALID, AACI_SL1RXVALID, AACISLFR, 16 * TimeOut,FsP_po1);
          PSR(AACITB_Buffer[i], Masks[20] ,AACISL1RX,FsP_R6);
        }
        else if (i == 2)
        {
          PO(AACI_SL2RXVALID, AACI_SL2RXVALID, AACISLFR, 17 * TimeOut,FsP_po2);
          PSR(AACITB_Buffer[i], Masks[20] ,AACISL2RX,FsP_R7);
        }
      }
      MaskBit = MaskBit << 1;
      RMaskBit = RMaskBit >> 1;
    }
  }
 
  /* Poll for 6th slot transmission to start */
  PO(AACITB_TxFFillLevel20, MASK_TxFFFillLevel, AACITrFIFOStat, 20 * TimeOut,FsP_po3);
 
  /* Enable AACISL1RX, and AACISL2RX so that reception for these slots
     starts from the next frame */
  SltEn = SltEn & 0xFD7;
  MaskBit = 0x2;
  for (i = 1; i < 3; i++)
  {
    if (CW.DatRxCntlReg[5] & MaskBit & CW.RxRegSltEn[FrameNo + 1])
    {
      if (i == 1)
        SltEn = SltEn | AACI_S1RXE;
      else if (i == 2)
        SltEn = SltEn | AACI_S2RXE;
    }  
    MaskBit = MaskBit << 1;
  }
  
  /* Write SltEn into the AACIMAINCR */
  PSW(SltEn, AACIMAINCR);

  /* APB dummy read to avoid two consecutive poll commands */ 
  PSR(AACIBITCLK_PERIOD , Masks[20], AACITrBtClkPrd,DummyRead);

  /* Wait till one frame transmission is over */
  PO(AACITB_TxFFillLevel12, MASK_TxFFFillLevel , AACITrFIFOStat, 10 * TimeOut,FsP_po4);

  /* Read data from the AACISL12RX register */
  if (CW.AACITB_SLOT0[FrameNo] & 0x8000)
  {
    MaskBit = 0x1000;
    RMaskBit = 0x8;
    if ((CW.DatRxCntlReg[5] & MaskBit & CW.RxRegSltEn[FrameNo]) &&
        (CW.AACITB_SLOT0[FrameNo] & RMaskBit))
    {
      PO(AACI_SL12RXVALID, AACI_SL12RXVALID, AACISLFR, 2 * TimeOut,FsP_po5);
      PSR(AACITB_Buffer[12], Masks[20], AACISL12RX,FsP_R8);
    }
  }

  /* Enable AACISL12RX for the next frame */
  SltEn = SltEn & 0xF7F;
  MaskBit = 0x1000;
  if (CW.DatRxCntlReg[5] & MaskBit & CW.RxRegSltEn[FrameNo + 1])
  {
    SltEn = SltEn + AACI_S12RXE;
  }

  /* Write SltEn into the AACIMAINCR */
  PSW(SltEn, AACIMAINCR);

  /* Wait for 12th slot transmission over */
  Idle(BITCLK_TIME * 2);

  m = 0;
  n = 0;

  /* Read data received in the first frame from both the AACI and 
     the AACITB */
  ReadData(m, n, FrameNo, ReMapAACI_Buffer, ReMapAACITB_Buffer,
           RSize, TSize);

  m = m + 13;
  n = 0;
 
  /* Allow data transfer to proceed. During data transfer, data from
     frames received previously are read out and verified. Also, data
     for subsequent frames are written. The reads and writes occur to 
     the Trickbox FIFOs, the AACI FIFOs and the AACI Slot registers.
     Verify received data by reading from the slot registers and the 
     FIFOs. Also, write data for subsequent frames into the AACI's 
     Tx FIFOs and the Slot registers
  */
  /* Loop starts */
  for(Count = 0; Count < TotNoFrame - 1; Count++)
  {
    FrameNo = FrameNo + 1;
    if (CW.AACITB_SLOT0[FrameNo] & 0x8000)
    {
      /* Read data from the AACISL1RX and the AACISL2RX registers */
      for (i = m + 1; i < m + 3; i++)
      {
        if (i == m + 1)
        {
          MaskBit = 0x2;
          RMaskBit = 0x4000;
        }
        if ((CW.DatRxCntlReg[5] & MaskBit & CW.RxRegSltEn[FrameNo]) &&
            (CW.AACITB_SLOT0[FrameNo] & RMaskBit))
        {
          if (i == m + 1)  
          {
            PO(AACI_SL1RXVALID, AACI_SL1RXVALID, AACISLFR, 4 * TimeOut,FsP_po6);
            PSR(AACITB_Buffer[i], Masks[20] ,AACISL1RX,FsP_R9);
          }
          else if (i == m + 2)
          {
            PO(AACI_SL2RXVALID, AACI_SL2RXVALID, AACISLFR, 4 * TimeOut,FsP_po7);
            PSR(AACITB_Buffer[i], Masks[20] ,AACISL2RX,FsP_R10);
          }
        }
     
        MaskBit = MaskBit << 1;
        RMaskBit = RMaskBit >> 1;
      }
    
      /* Poll for AACISLOTnTX [n=1, 2, 12] Busy bit to become zero */
      if (CW.DatTxCntlReg[5] & 0x4 & CW.TxRegWtSltEn[FrameNo + 1])
        PO(0x0, AACI_SL2TXBUSY, AACISLFR, 5 * TimeOut,Fs_po4);
      else if (CW.DatTxCntlReg[5] & 0x2 & CW.TxRegWtSltEn[FrameNo + 1])
        PO(0x0, AACI_SL1TXBUSY, AACISLFR, 5 * TimeOut,Fs_po4);

      /* Enable the AACISL1TX and the AACISL2TX registers for
         the transmission */
      SltEn = SltEn & 0xFAF;
      MaskBit = 0x2;
      for (i = 1; i < 3; i++)
      {
        if (CW.DatTxCntlReg[5] & MaskBit & CW.TxRegSltEn[FrameNo + 1])
        {
          if (i == 1)
            SltEn = SltEn | AACI_S1TXE;
          else if (i == 2)
            SltEn = SltEn | AACI_S2TXE;
         }  
         MaskBit = MaskBit << 1;
      }

      /* Write SltEn into the AACIMAINCR register */
      PSW(SltEn, AACIMAINCR);
  
      /* Write data to the AACISL1TX and the AACISL2TX registers */
      MaskBit = 0x2;
      for(i = k + 1; i < k + 3; i++)
      {
        if ((CW.DatTxCntlReg[5] & MaskBit & 
             CW.TxRegWtSltEn[FrameNo + 1]) && (Count != TotNoFrame - 2))
        {
          if (i == k + 1)
            PSW(0x55AAA, AACISL1TX);
          else if (i == k + 2)
            PSW(0x55AAA, AACISL2TX);
        }
        MaskBit = MaskBit << 1;
      }
    }
  
    if (Count == TotNoFrame - 2)
    {
      /* One additional data element is written to the TxFIFO of the
         trickbox for the last frame. This is to prevent the AACI from
         inferring a CODEC Idle on the last frame. The last frame has 
         only the CODEC Ready bit set in the Slot0 - all other slot 
         valid bits are cleared to the zero. */
      PSW(0x80000 & Masks[20], AACITrTxFIFO);
    }
    else
    {
      /* Write data for the next frame into the trickbox */
      for(i = l; i < l+13; i++)
      {
        PSW(AACITB_Buffer[i] & Masks[20], AACITrTxFIFO);
      }
    }

    l = l + 13;

    if (Count == TotNoFrame - 2)
    {
      /* Poll for start of transmission of the 9th slot of the last 
         frame */
      PO(AACITB_TxFFillLevel5, MASK_TxFFFillLevel, AACITrFIFOStat, 8*TimeOut,FsP_po8);
    }
    else
    {
      /* Poll for the start of transmission of the 9th slot of the next
         frame */
      PO(AACITB_TxFFillLevel17, MASK_TxFFFillLevel, AACITrFIFOStat, 8*TimeOut,FsP_po9);
    }
  
    if (CW.AACITB_SLOT0[FrameNo] & 0x8000)
    {
      /* Enable the AACISL1RX, and AACISL2RX registers for the next 
         frame */
      SltEn = SltEn & 0xFD7;
      MaskBit = 0x2;
      for (i = 1; i < 3; i++)
      {
        if (CW.DatRxCntlReg[5] & MaskBit & CW.RxRegSltEn[FrameNo + 1])
        {
          if (i == 1)
            SltEn = SltEn | AACI_S1RXE;
          else if (i == 2)
            SltEn = SltEn | AACI_S2RXE;
        }  
        MaskBit = MaskBit << 1;
      }

      /* Write SltEn into the AACIMAINCR */
      PSW(SltEn, AACIMAINCR);
    }
  
    /* Write transmit data for the next frame into the Aaci */
    if (Count != TotNoFrame - 2)
    {
      if (Count == CW.StartInVldFrm - 3)
        InVldFrmState = 1;
      else if ((Count == CW.StartInVldFrm - 2) && (CW.NoInVldFrm == 2))
        InVldFrmState = 2;
      else if ((Count == CW.StartInVldFrm - 1) && (CW.NoInVldFrm == 2))
        InVldFrmState = 3;
      else
        InVldFrmState = 0;

      if (InVldFrmState == 2)
      {
        for (j = 1; j < 5; j++)
        {
          if (CW.FrmInVldCh[j])
          {
            for (i = 0; i < NoSltPerCh[j] - 1; i++)
              PSW(0x55550, AACIDR[j]);
          }
        }
      }

      if (InVldFrmState == 3)
      {
        for (j = 1; j < 5; j++)
        {
          if (CW.FrmInVldCh[j])
          {
            PSW(0x55550, AACIDR[j]);
          }
        }
      }

      MaskBit = 0x2;
      for(i = k + 1; i < k + 9; i++)
      {
        for (j = 1; j < 5; j++)
        {
          if ((CW.DatTxCntlReg[j] & MaskBit &
               CW.TxFIFOWtSltEn[FrameNo + 1]) &&
              (!((CW.FrmInVldCh[j]) && (InVldFrmState))))
          {
            if (!(CW.DatTxCntlReg[j] & AACI_CM))
            {
              PSW(AACI_Buffer[i], AACIDR[j]);
            }
            else
            {
              if (Temp[j] == 200)
                Temp[j] = i;
              else
              {
                AACI_TempBuffer = (AACI_Buffer[Temp[j]] & Masks[16]) |
                                  ((AACI_Buffer[i] & Masks[16]) << 16);
                PSW(AACI_TempBuffer, AACIDR[j]);
                Temp[j] = 200;
              }
            }    
          }
        }
        MaskBit = MaskBit << 1;
      }

      k = k + 9;

      /* APB dummy read to avoid two consecutive poll commands */ 
      PSR(AACIBITCLK_PERIOD , Masks[20], AACITrBtClkPrd,DummyRead);

      /* Poll for the start of transmission of the 12th slot of the
         current frame */
      PO(AACITB_TxFFillLevel13, MASK_TxFFFillLevel, AACITrFIFOStat, 10*TimeOut,FsP_po10);

      MaskBit = 0x200;
      for(i = k; i < k + 4; i++)
      {
        for (j = 1; j < 5; j++)
        {
          if ((CW.DatTxCntlReg[j] & MaskBit & 
              CW.TxFIFOWtSltEn[FrameNo + 1]) && 
              (!((CW.FrmInVldCh[j]) && (InVldFrmState))))
          {
            if (!(CW.DatTxCntlReg[j] & AACI_CM))
            {
              PSW(AACI_Buffer[i], AACIDR[j]);
            }
            else
            {
              if (Temp[j] == 200)
                Temp[j] = i;
              else
              {
                AACI_TempBuffer = (AACI_Buffer[Temp[j]] & Masks[16]) |
                                  ((AACI_Buffer[i] & Masks[16]) << 16);
                PSW(AACI_TempBuffer, AACIDR[j]);
                Temp[j] = 200;
              }
            }    
          }
        }
        MaskBit = MaskBit << 1;
      }
      k = k + 4;

      /* Enable the AACISL12TX for the next Frame */
      SltEn = SltEn & 0xEFF;
      MaskBit = 0x1000;
      if (CW.DatTxCntlReg[5] & MaskBit & CW.TxRegSltEn[FrameNo + 1])
        SltEn = SltEn | AACI_S12TXE;

      /* Write into the AACIMAINCR register */
      PSW(SltEn, AACIMAINCR);
      
      /* Write data into the AACISL12TX register */
      MaskBit = 0x1000;
      if ((CW.DatTxCntlReg[5] & MaskBit & CW.TxRegWtSltEn[FrameNo + 1]))
        PSW(0x55AAA, AACISL12TX);
    }

    if (Count == TotNoFrame - 2)
    {
      /* Poll for end of transmission of the last frame */
      PO(AACITB_TxFFillLevel0, MASK_TxFFFillLevel, AACITrFIFOStat, 13*TimeOut,FsP_po11);
    }
    else
    {
      /* Poll for the start of the next frame */
      PO(AACITB_TxFFillLevel12, MASK_TxFFFillLevel, AACITrFIFOStat, 13*TimeOut,FsP_po12);
    }

    /* Read data from the AACISL12RX register */
    if (CW.AACITB_SLOT0[FrameNo] & 0x8000)
    {
      MaskBit = 0x1000;
      RMaskBit = 0x8;
      if ((CW.DatRxCntlReg[5] & MaskBit & CW.RxRegSltEn[FrameNo]) &&
          (CW.AACITB_SLOT0[FrameNo] & RMaskBit))
      {
        PO(AACI_SL12RXVALID, AACI_SL12RXVALID, AACISLFR, 2 * TimeOut,FsP_po13);
        PSR(AACITB_Buffer[m + 12], Masks[20], AACISL12RX,FsP_R11);
      }
    }

    /* Enable the AACISL12RX register for the next frame */
    SltEn = SltEn & 0xF7F;
    MaskBit = 0x1000;
    if (CW.DatRxCntlReg[5] & MaskBit & CW.RxRegSltEn[FrameNo + 1])
    {
      SltEn = SltEn + AACI_S12RXE;
    }

    /* Write into the AACIMAINCR */
    PSW(SltEn, AACIMAINCR);

    /* Wait for the end of transmission of the 12th slot */
    Idle(BITCLK_TIME * 2);

    /* Read the received data corresponding to the previous frame from 
       both the Aaci and the trickbox RxFIFOs */
    ReadData(m, n, FrameNo, ReMapAACI_Buffer, ReMapAACITB_Buffer,
             RSize, TSize);
 
    m = m + 13;
 
    if (CW.AACITB_SLOT0[FrameNo - 1] & 0x8000)
    {
      n = n + 13;
    }
    else
    {
      k = k - 13;
    }

    /* Disable the trickbox reception during the last dummy frame */
    if (Count == TotNoFrame - 3)
    {
      Idle(BITCLK_TIME * 20);
      PSW(AACITB_En | AACITB_TxEn | AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);
    }
  }
  /* Loop Ends  */

  /* Disable the trickbox transmission and reception */
  PSW( AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

  /* Wait untill the RxBusy goes low */
  Idle(BITCLK_TIME * 10);

  /* Read the AACISLFR register */
  PSR(AACI_SL1TXEMPTY | AACI_SL2TXEMPTY | AACI_SL12TXEMPTY, Masks[12], AACISLFR,FsP_R12);

  /* Clear left-over data in the TxFIFO of the AACI */
  if (!(CW.DatTxCntlReg[1] & AACI_TEN) && (CW.DatTxCntlReg[1] & 0x1FFE))
    PSW(0x0 , AACIMAINCR);
  else  if (!(CW.DatTxCntlReg[2] & AACI_TEN) && 
             (CW.DatTxCntlReg[2] & 0x1FFE))
    PSW(0x0 , AACIMAINCR);
  else if (!(CW.DatTxCntlReg[3] & AACI_TEN) && 
            (CW.DatTxCntlReg[3] & 0x1FFE))
    PSW(0x0 , AACIMAINCR);
  else if (!(CW.DatTxCntlReg[4] & AACI_TEN) && 
            (CW.DatTxCntlReg[4] & 0x1FFE))
    PSW(0x0 , AACIMAINCR);
  else
  {
 
    /* Read the Aaci Status register */
    PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR1,FsP_R13);
    PI(2);
  
    PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR2,FsP_R14);
    PI(2);
  
    PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR3,FsP_R15);

    PI(2);
  
    PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR4,FsP_R16);
    PI(2);
   
  }

  /* Read the trickbox status registers */
  PSR(AACITB_TxFFillLevel0 | AACITB_RxFFillLevel0, Masks[12], AACITrFIFOStat,FsP_R17);
  PI(2);

  PSW(0x0 , AACIMAINCR);

  C("Transmission and Reception Test Ends");
}

/**********************************************************************/
/*************************** ReadData *********************************/
/**********************************************************************/
void ReadData(int32 AACIStart, int32 AACITBStart, int FrameNo,
              int32 *ReMapAACI_Buffer, int32 *ReMapAACITB_Buffer,
              int32 *RSize, int32 *TSize)
{
  /*
    Summary : ReadData
    ==================
    This function reads slot data from the AACI and the trickbox to
    verify the transmission and reception done by the AACI. This 
    function receives all information from the structure 
    CW (ControlWords) and from the calling function(TxRx_FsPCLK_Call)
    These parameters determine the following :
      - The expected Slot0 from the AACI
      - Slot0 transmitted by the trickbox
      - Register fields for the AACITXCRn (n = 1 to 4) registers
      - Register fields for the AACIRXCRn (n = 1 to 4) registers
      - SRC bit values transmitted by the trickbox
      - Information regarding to which of the Tx slot data containing
        the valid data for each frame.
      - The expected slot data transmitting from the AACI
      - The expected slot data receiving from the trickbox
      - The frame number need to be read
      - RSIZE and TSIZE of the each individual channels
    The AACIStart argument to this function is used to point to the 
    starting point in the read data array (ReMapAACITB_Buffer), from 
    which data is to be read and compared with the data transmitted by 
    the AACI in each frame. Similarly, the AACITBStart is used to index
    into the read data array (ReMapAACI_Buffer) that stores expected 
    data for trickbox FIFO reads.

  */

  int32 AACITB_TempBuffer;
  int Temp[5];
  int DisableFurtherRd[5];
  int i;
  int j;
  int InVldFrmState;
  int Flag;
  int S[6];
  int32 MaskBit;
  int32 RMaskBit;
 
  /* Initialise the flag variable DisableFurtherRd */
  /* This variable is used to ensure that the RxFIFO is read */
  /* only once in the Character mode */
  for (i = 1; i < 5; i++)
    DisableFurtherRd[i] = 0;

  for (i = 1; i < 5; i++)
    Temp[i] = 200;
 
  /* The variable S[] is assigned an adjustment factor based on the
     whether the SRC bits were set for slots corresponding to each of
     the Channels and the Slot12Tx Register. When a received frame has
     the SRC bits for a given slot set, the S[] value corresponding to
     that channel is set to multiples of 13. This value is subtracted
     from the current index of the buffer that stores the expected
     value for Trickbox FIFO reads. The subtracted value indicates the
     actual index into the expected value array that contains the
     real expected data.  */
  for (i = 1; i < 6; i++)
  {
    if ((~(CW.RemapedSRC[FrameNo - 2])) & (CW.DatTxCntlReg[i]) && 
        (FrameNo > 2))
    {
      S[i] = 13;
      if (((~(CW.RemapedSRC[FrameNo - 3])) & (CW.DatTxCntlReg[i])) && 
          (FrameNo > 3))
      {
        S[i] = S[i] + 13;
        if (((~(CW.RemapedSRC[FrameNo - 4])) & (CW.DatTxCntlReg[i])) &&
            (FrameNo > 4))
          S[i] = S[i] + 13;
      }
    }
    else
      S[i] = 0;
  }

  /* InVldFrmState is assigned according to the current frame number
     (FrameNo). This variable is used to detect whether valid data
     (non-zero data) can be expected when reading the Rx FIFO of the
     Trickbox. */
  if (FrameNo == CW.StartInVldFrm)
    InVldFrmState = 1;
  else if ((FrameNo == CW.StartInVldFrm + 1) && (CW.NoInVldFrm == 2))
    InVldFrmState = 1;
  else if (FrameNo == CW.StartInVldFrm + 1)
    InVldFrmState = 0;
  else if ((FrameNo == CW.StartInVldFrm + 2) && (CW.NoInVldFrm == 2))
    InVldFrmState = 2;
  else
    InVldFrmState = 0;

  /* Read slot data for one frame from the AACI */
  if (CW.AACITB_SLOT0[FrameNo] & 0x8000)
  {
    for(i= AACIStart; i < AACIStart +13; i++)
    {
      if (i % 13)
      {
        for (j = 1; j < 5; j++)
        {
          if ((CW.DatRxCntlReg[j] & MaskBit) &&
              (CW.AACITB_SLOT0[FrameNo] & RMaskBit) &&
              (!(DisableFurtherRd[j]))) 
          {
            if (!(CW.DatRxCntlReg[j] & AACI_CM))
            {
             PSR(ReMapAACITB_Buffer[i], Masks[20], AACIDR[j],Rd_R1);
             if (!(CW.DatRxCntlReg[j] & AACI_FEN))
               DisableFurtherRd[j] = 1;
            }
            else
            {
              if (Temp[j] == 200)
                Temp[j] = i;
              else
              {
                AACITB_TempBuffer = (ReMapAACITB_Buffer[Temp[j]]) |
                                    (ReMapAACITB_Buffer[i] << 16);
                PSR(AACITB_TempBuffer, 0xFFFFFFFF, AACIDR[j],Rd_R2);
                Temp[j] = 200;
              }
            }
          }
        }
        MaskBit = MaskBit << 1;
        RMaskBit = RMaskBit >> 1;
      }
      else
      {
        MaskBit = 0x2;
        RMaskBit = 0x4000;
      }
    }
  }
 
  /* Read slot data for one frame from the Rx FIFO of the trickbox */
  /* All the expected slot data from the AACI corresponding to the
     first frame are zero */
  if (FrameNo == 1)
    for (i = 0; i < 13; i++)
      PSR(DATA_0s, Masks[20], AACITrRxFIFO,Rd_R3);
  else if (CW.AACITB_SLOT0[FrameNo - 1] & 0x8000)
  {  
    MaskBit = 0x2;

    if ((CW.AACI_SLOT0[FrameNo] & 0x4000) && (FrameNo == 3) &&
        (CW.TxFIFORdSltEn[FrameNo] & 0x2))
    {
      /* The second frame is the read transfer (MSB of the AACI SLOT1
         is zero), so it is expected that the Slot2 to be invalid */
      PSR(CW.AACI_SLOT0[FrameNo] & 0xDFFF, Masks[16], AACITrRxFIFO,Rd_R4_a);
    }
    else
    {
      PSR(CW.AACI_SLOT0[FrameNo], Masks[16], AACITrRxFIFO,Rd_R4_b);
    }

    for(i = AACITBStart + 1; i < AACITBStart + 13; i++)
    {
      /* The second frame is the read transfer (MSB of the AACI SLOT1
         is set), so it is expected that the AACI SLOT2 should be
         stuffed with the zero by the AACI */
      if ((i == 15) && ((CW.AACI_SLOT0[FrameNo] & 0x4000) || 
          (CW.SecCODEC != 0x0)) && (CW.TxFIFORdSltEn[FrameNo] & 0x2))
         PSR(DATA_0s, Masks[20], AACITrRxFIFO,Rd_R5);

      /* Read slot data from the Rx FIFO of the trickbox and verify that
         it is the same as the one written to channel-1 of the AACI */
      else if ((CW.DatTxCntlReg[1] & MaskBit & 
                CW.TxFIFORdSltEn[FrameNo]) && 
               (CW.DatTxCntlReg[1] & AACI_TEN))
      {
        if ((CW.FrmInVldCh[1]) && (InVldFrmState == 1))
          PSR(DATA_0s, Masks[20] ,AACITrRxFIFO,Rd_R6);
        else if ((CW.FrmInVldCh[1]) && (InVldFrmState == 2))
          PSR(0x55550 << 20 - TSize[1] & RMasks[TSize[1]], Masks[20] ,AACITrRxFIFO,Rd_R7);
        else if (MaskBit == 0x4)
          PSR(ReMapAACI_Buffer[i - CW.Slt2Corcfct] & 0xFFFF0,Masks[20], AACITrRxFIFO,Rd_R8);
        else 
          {
          PSR(ReMapAACI_Buffer[i - S[1]], Masks[20], AACITrRxFIFO,Rd_R9);
          }
      }

      /* Read slot data from the Rx FIFO of the trickbox and verify that
         it is the same as the one written to channel-2 of the AACI */
      else if ((CW.DatTxCntlReg[2] & MaskBit & 
                CW.TxFIFORdSltEn[FrameNo]) && 
               (CW.DatTxCntlReg[2] & AACI_TEN))
      {
        if ((CW.FrmInVldCh[2]) && (InVldFrmState == 1))
          PSR(DATA_0s, Masks[20] ,AACITrRxFIFO,Rd_R10);
        else if ((CW.FrmInVldCh[2]) && (InVldFrmState == 2))
          PSR(0x55550 << 20 - TSize[2] & RMasks[TSize[2]], Masks[20] ,AACITrRxFIFO,Rd_R11);
        else if (MaskBit == 0x4)
          PSR(ReMapAACI_Buffer[i - CW.Slt2Corcfct] & 0xFFFF0, Masks[20], AACITrRxFIFO,Rd_R12);
        else 
          PSR(ReMapAACI_Buffer[i - S[2]], Masks[20], AACITrRxFIFO,Rd_R13);
      }

      /* Read slot data from the Rx FIFO of the trickbox and verify that
         it is the same as the one written to channel-3 of the AACI */
      else if ((CW.DatTxCntlReg[3] & MaskBit & 
                CW.TxFIFORdSltEn[FrameNo]) &&
               (CW.DatTxCntlReg[3] & AACI_TEN))
      {
        if ((CW.FrmInVldCh[3]) && (InVldFrmState == 1))
          PSR(DATA_0s, Masks[20] ,AACITrRxFIFO,Rd_R14);
        else if ((CW.FrmInVldCh[3]) && (InVldFrmState == 2))
          PSR(0x55550 << 20 - TSize[3] & RMasks[TSize[3]], Masks[20] ,AACITrRxFIFO,Rd_R15);
        else if (MaskBit == 0x4)
          PSR(ReMapAACI_Buffer[i - CW.Slt2Corcfct] & 0xFFFF0, Masks[20], AACITrRxFIFO,Rd_R16);
        else 
        {
          PSR(ReMapAACI_Buffer[i - S[3]], Masks[20], AACITrRxFIFO,Rd_R17);
        }
      }

      /* Read slot data from the Rx FIFO of the trickbox and verify that
         it is the same as the one written to channel-4 of the AACI */
      else if ((CW.DatTxCntlReg[4] & MaskBit &
                CW.TxFIFORdSltEn[FrameNo]) && 
               (CW.DatTxCntlReg[4] & AACI_TEN))
      {
        if ((CW.FrmInVldCh[4]) && (InVldFrmState == 1))
          PSR(DATA_0s, Masks[20] ,AACITrRxFIFO,Rd_R18);
        else if ((CW.FrmInVldCh[4]) && (InVldFrmState == 2))
          PSR(0x55550 << 20 - TSize[4] & RMasks[TSize[4]], Masks[20] ,AACITrRxFIFO,Rd_R19);
        else if (MaskBit == 0x4)
          PSR(ReMapAACI_Buffer[i - CW.Slt2Corcfct] & 0xFFFF0, Masks[20], AACITrRxFIFO,Rd_R20);
        else 
          PSR(ReMapAACI_Buffer[i - S[4]], Masks[20], AACITrRxFIFO,Rd_R21);
      }

      /* Read slot data from the Rx FIFO of the trickbox and verify that
         it is the same as the one written to AACISL1TX, AACISL2TX and 
         AACISLOT12TX registers of the AACI */
      else if (CW.DatTxCntlReg[5] & MaskBit & CW.TxRegRdSltEn[FrameNo])
      {
        if ((CW.FrmInVldCh[5]) && (InVldFrmState == 1))
          PSR(DATA_0s, Masks[20] ,AACITrRxFIFO,Rd_R22);
        else if ((CW.FrmInVldCh[5]) && (InVldFrmState == 2))
          PSR(0x55550 << 20 - TSize[5] & RMasks[TSize[5]], Masks[20] ,AACITrRxFIFO,Rd_R23);
        else if (MaskBit == 0x4)
          PSR(0x55AAA & 0xFFFF0, Masks[20], AACITrRxFIFO,Rd_R24);
        else 
          PSR(0x55AAA, Masks[20], AACITrRxFIFO,Rd_R25);
      }
      else
        PSR(DATA_0s, Masks[20] ,AACITrRxFIFO,Rd_R26);

      MaskBit = MaskBit << 1;
    }
  }

 /* All the expected slot data transmitted by the AACI corresponding to
    the invalid frame are zero */
 else
  for (i = 0; i < 13; i++)
    PSR(DATA_0s, Masks[20], AACITrRxFIFO,Rd_R27);
}

/*********************** End of TxRx_FsPCLK_Test.c ********************/
