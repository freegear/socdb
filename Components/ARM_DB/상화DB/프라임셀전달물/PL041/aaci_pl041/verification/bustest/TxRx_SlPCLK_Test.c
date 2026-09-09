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
-- File Name              : TxRx_SlPCLK_Test.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This function programs the AACI and performs data tests
--           to verify its operation. It is called only when
--           PCLK is slower than AACIBITCLK.
--
-- --=================================================================*/

/**********************************************************************/
/*** For more information on the AACI, please refer to PL041 AMBA   ***/
/*** AACI Block Specification                                       ***/
/**********************************************************************/

/**********************************************************************/
/*************************** TxRx_SlPCLK_Test *************************/
/**********************************************************************/
void TxRx_SlPCLK_Test(int TotNoFrame)
{
 
  /*
    Summary: TxRx_SlPCLK_Test
    =========================

    This function is used to verify Transmission and Reception
    operation of the AACI when PCLK is slower than AACIBITCLK.

    This test checks the following functionality:

    o This function programs the AACI according to parameters passed 
      to it by the calling functions (TxRx_SlPCLK_Call). These 
      parameters are indirectly passed by updating the CW(ControlWords)
      structure in the calling functions (TxRx_SlPCLK_Call).
      These parameters determine the following :

      - The expected Slot0 from the AACI
      - Slot0 to be transmitted by the Trickbox
      - Register fields for the AACITXCRn (n = 1 to 4) registers
      - Register fields for the AACIRXCRn (n = 1 to 4) registers
      - SRC bit values to be transmitted by the trickbox
      - Information regarding which of the Slot registers need to
        be enabled for data transmission.
      - Information regarding which of the Slot registers need to
        be enabled for data reception.
      - Information regarding to which of the slot data nedd to be
        written into the Tx FIFOs of the AACI for each frame
      - Information regarding to which of the AACISLnTX (n = 1 to 4)
        registers to be loaded with new data for each frame

    o This function also verifies data transmission by the AACI for 
      a range of TSIZE values in Compact mode and non-Compact mode

    o Additionally, this function verifies data reception by the AACI
      for a range of RSIZE values in Compact mode and non-Compact mode

    o The test sequence is as follows:
      - Data is written to the AACI's Transmit FIFOs and slot registers
      - Data is written to the Trickbox's Transmit FIFO
      - Transmission and Reception is enabled.
      - The AACI and the Trickbox are enabled to allow data transfer.
      - During the transfer of any given frame, data corresponding to
        the previous frames are read out and verified and data for
        subsequent frames are written. Reads and writes occur to both 
        the Channel FIFOs and the Slot registers in the AACI. When data
        transfer is in progress, no reads/writes are done to the 
        Trickbox. This is because of the limited number of PCLKs per
        AACIBITCLK period (PCLK slower than AACIBITCLK). All data
        writes required to be done to the trickbox are done before the
        start of data transfer. Similarly, all trickbox-reads are
        done after the completion of data transmission.

   */

  int32 AACI_Buffer[150];
  int32 ReMapAACI_Buffer[150];
  int32 AACITB_Buffer[150];
  int32 ReMapAACITB_Buffer[150];
  int32 AACI_TempBuffer;
  int32 AACITB_TempBuffer;
  int32 RSize[6];
  int32 TSize[6];
  int32 Temp[5];
  int S[6];
  int i,j,k,l,m,n,Count;
  int DisableFurtherRd[5];
  int32 RxFFillLevel;
  int32 MaskBit;
  int32 RMaskBit;
  int FrameNo = 1;
  int CharMod = 0;
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

  /* Set the variable CharMod  */
  for (i = 1; i < 5; i++)
  {
    if (CW.DatTxCntlReg[i] != 0x0)
    {
      if (!(CW.DatTxCntlReg[i] & AACI_FEN))
        CharMod = 1;
    }
    if (CW.DatRxCntlReg[i] != 0x0)
    {
      if (!(CW.DatRxCntlReg[i] & AACI_FEN))
        CharMod = 1;
    }
  }

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

  /* Initialise the flag variable DisableFurtherRd */
  /* This variable is used to ensure that the RxFIFO is read */
  /* only once in the Character mode */
  for (i = 1; i < 5; i++)
    DisableFurtherRd[i] = 0;

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
    if (CW.DatTxCntlReg[5] & MaskBit)
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
  PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR1,SlP_R1);
  PI(2);
  
  PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR2,SlP_R2);
  PI(2);
  
  PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR3,SlP_R3);
  PI(2);
  
  PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR4,SlP_R4);
  PI(2);

  k = 13;
 
  /* Write data into the Aaci */
  for(i = 0; i < k; i++)
  {
    if (!(i % 13))
      MaskBit = 0x2;
    else
    {
      for (j = 1; j < 5; j++)
      {
        if (CW.DatTxCntlReg[j] & MaskBit & 
            CW.TxFIFOWtSltEn[FrameNo + 1])
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
  }
   
  /* Read the trickbox Status register */
  PSR(AACITB_TxFFillLevel0 | AACITB_RxFFillLevel0, Masks[12], AACITrFIFOStat,SlP_R5);
  PI(2);
 
  l = 13 * TotNoFrame;

  /* Write data into the trickbox  */
  for(i = 0; i < l; i++)
  {
    PSW(AACITB_Buffer[i] & Masks[20], AACITrTxFIFO);
  }

  /* One additional data element is written to the TxFIFO of the 
     trickbox for the last frame. This is to prevent the AACI from
     inferring a CODEC Idle on the last frame. The last frame has only
     the CODEC Ready bit set in the Slot0 - all other slot valid bits 
     are cleared to the zero. */
  PSW(0x80000 & Masks[20], AACITrTxFIFO);

  /* Start Trickbox transmission and reception by enabling the 
     AACITB_TxEn and AACITB_RxEn in the Trickbox control register */
  PSW(AACITB_En | AACITB_TxEn | AACITB_RxEn | AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);

  m = 0;
  RxFFillLevel = 12;

  /* Allow data transfer to complete. Verify received data by reading
     from the slot registers and the FIFOs. Also, write data for
     subsequent frames into the AACI's Tx FIFOs and the Slot registers
  */
  /* Loop Starts */
  while (FrameNo <= TotNoFrame)
  {
    /* Poll for the start of the first frame of the first Slot */
    PO(RxFFillLevel, MASK_RxFFFillLevel, AACITrFIFOStat, 28 * TimeOut,SlP_po1);
    RxFFillLevel = RxFFillLevel + 13;

    if (PCLK_PERIOD < 400)
      PI(SLOT_TIME - 2);

    /* Read data from the AACISL1RX and the AACISL2RX registers */
    MaskBit = 0x2;
    RMaskBit = 0x4000;
    if (CW.AACITB_SLOT0[FrameNo] & 0x8000)
    {
      for (i = m + 1; i < m + 3; i++)
      {
        if ((CW.DatRxCntlReg[5] & MaskBit) && 
            (CW.AACITB_SLOT0[FrameNo] & RMaskBit))
        {
          if (i == m + 1)
            PSR(AACITB_Buffer[i], Masks[20] ,AACISL1RX,SlP_R6);
          else if (i == m + 2)
            PSR(AACITB_Buffer[i], Masks[20] ,AACISL2RX,SlP_R7);
        }
        MaskBit = MaskBit << 1;
        RMaskBit = RMaskBit >> 1;
      }
    }

    /* Initialise the flag variable DisableFurtherRd */
    /* This variable is used to ensure that the RxFIFO is read */
    /* only once in the Character mode */
    for (i = 1; i < 5; i++)
      DisableFurtherRd[i] = 0;

    /* Read the Slots from the AACIDR for the last frame */
    MaskBit  = 0x2;
    RMaskBit = 0x4000;
    for(i = m + 1; i < m + 13; i++)
    {
      for (j = 1; j < 5; j++)
      {
        if ((CW.DatRxCntlReg[j] & MaskBit) &&
            (CW.AACITB_SLOT0[FrameNo] & RMaskBit) &&
            (!(DisableFurtherRd[j])))
        {
          if (!(CW.DatRxCntlReg[j] & AACI_CM))
          {
            PSR(ReMapAACITB_Buffer[i], Masks[20], AACIDR[j],SlP_R8);
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
              PSR(AACITB_TempBuffer, 0xFFFFFFFF, AACIDR[j],SlP_R9);
              Temp[j] = 200;
            }
          }
        }
      }
      MaskBit = MaskBit << 1;
      RMaskBit = RMaskBit >> 1;
    }

    /* Read the data from the AACISL12RX register */
    if (CW.AACITB_SLOT0[FrameNo] & 0x8000)
    {
      MaskBit = 0x1000;
      RMaskBit = 0x8;
      if ((CW.DatRxCntlReg[5] & MaskBit) && 
          (CW.AACITB_SLOT0[FrameNo] & RMaskBit))
        PSR(AACITB_Buffer[m + 12], Masks[20], AACISL12RX,SlP_R10);
    }

    if ((CharMod == 1) && (CW.DatTxCntlReg[5] & 0x4))
      PO(AACI_SL2TXEMPTY, AACI_SL2TXEMPTY, AACISLFR, 4 * TimeOut,SlP_po2);
    else if ((CharMod == 1) && (CW.DatTxCntlReg[5] & 0x2))
      PO(AACI_SL1TXEMPTY, AACI_SL1TXEMPTY, AACISLFR, 4 * TimeOut,SlP_po3);

    /* Write data into the AACISL1TX and the AACISL2TX registers */
    MaskBit = 0x2;
    for(i = m + 1; i < m + 3; i++)
    {
      if ((CW.DatTxCntlReg[5] & MaskBit &
           CW.TxRegWtSltEn[FrameNo + 2]) && (FrameNo < TotNoFrame - 1))
      {
        if (i == m + 1)
          PSW(0x55AAA, AACISL1TX);
        else if (i == m + 2)
          PSW(0x55AAA, AACISL2TX);
      }
      MaskBit = MaskBit << 1;
    }

    /* Write data into the AACISL12TX register */
    MaskBit = 0x1000;
    if ((CW.DatTxCntlReg[5] & MaskBit & 
         CW.TxRegWtSltEn[FrameNo + 2]) && (FrameNo < TotNoFrame - 1))
    {
      PSW(0x55AAA, AACISL12TX);
    }

    if ((CharMod == 1) && (FrameNo < TotNoFrame))
    {
      /* APB dummy read to avoid two consecutive poll commands */ 
      PSR(AACIBITCLK_PERIOD , Masks[20], AACITrBtClkPrd,DummyRead);
      RxFFillLevel = RxFFillLevel - 2;

      PO(RxFFillLevel, MASK_RxFFFillLevel, AACITrFIFOStat, 13 * TimeOut,SlP_po4);
      RxFFillLevel = RxFFillLevel + 2;
    }

    if (PCLK_PERIOD < 300)
      PI(SLOT_TIME -2);

    /* Write the Slots data into the AACIDR register */
    MaskBit  = 0x2;
    for(i = m + 1; i < m + 13; i++)
    {
      for (j = 1; j < 5; j++)
      {
        if ((CW.DatTxCntlReg[j] & MaskBit & 
             CW.TxFIFOWtSltEn[FrameNo + 2]) && 
            (FrameNo < TotNoFrame - 1))
        {
          if (!(CW.DatTxCntlReg[j] & AACI_CM))
          {
            PSW(AACI_Buffer[i + 13], AACIDR[j]);
          }
          else
          {
            if (Temp[j] == 200)
              Temp[j] = i + 13;
            else
            {
              AACI_TempBuffer = (AACI_Buffer[Temp[j]] & Masks[16]) |
                                ((AACI_Buffer[i + 13] & Masks[16]) << 
                                 16);
              PSW(AACI_TempBuffer, AACIDR[j]);
              Temp[j] = 200;
            }
          }    
        }
      }
      MaskBit = MaskBit << 1;
    }
    FrameNo = FrameNo + 1;
    m = m + 13;

    /* Disable the trickbox reception for the last dummy frame */
    if (FrameNo == TotNoFrame)
    {
      PSW(AACITB_En | AACITB_TxEn | AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);
      RxFFillLevel = (13 * TotNoFrame);
    }
  }
  /* Loop End */

  /* Wait for the complete the transmission */
  PI(5);

  /* Disable the trickbox transmission */
  PSW( AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

  /* Wait untill the RxBusy goes to the zero */
  Idle(BITCLK_TIME * 15);

  /* Clear the TxFIFO having the data which is not being transmitted */
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
    /* Read the Aaci status register */
    PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR1,SlP_R11);
    PI(2);
  
    PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR2,SlP_R12);
    PI(2);
  
    PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR3,SlP_R13);

    PI(2);
  
    PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR4,SlP_R14);
    PI(2);
  }

  PSW(0x0 , AACIMAINCR);

  m = 0;

  /* Read and verify data from the Rx FIFO of the trickbox */
  for (FrameNo = 1; FrameNo <= TotNoFrame; FrameNo++)
  {
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
          if (((~(CW.RemapedSRC[FrameNo - 4])) & (CW.DatTxCntlReg[i]))
              && (FrameNo > 4))
            S[i] = S[i] + 13;
        }
      }
      else
        S[i] = 0;
    }

    /* Read slot data for one frame from the Rx FIFO of the trickbox */
    /* All the expected slot data from the AACI corresponding to the
       first frame are zero */
    if (FrameNo == 1)
    {
      for (i = 0; i < 13; i++)
        PSR(DATA_0s, Masks[20], AACITrRxFIFO,SlP_R15);
    }
    else if (CW.AACITB_SLOT0[FrameNo - 1] & 0x8000)
    {  
      for(i = m; i < m + 13; i++)
      {
        if (!(i % 13))
        {
          MaskBit = 0x2;
          if ((CW.AACI_SLOT0[FrameNo] & 0x4000) && (FrameNo == 3) &&
              (CW.TxFIFORdSltEn[FrameNo] & 0x2))
          {
            /* The second frame is the read transfer (MSB of the 
               AACI SLOT1 is set), so it is expected that the Slot2 
               to be invalid */
            PSR(CW.AACI_SLOT0[FrameNo] & 0xDFFF, Masks[16], AACITrRxFIFO,SlP_R16_a);
          }
          else
          {
            PSR(CW.AACI_SLOT0[FrameNo], Masks[16], AACITrRxFIFO,SlP_R16_b);
          }
        }
        else
        {
          /* The second frame is the read transfer (MSB of the AACI 
             SLOT1 is zero), so it is expected that the AACI SLOT2 
             should be stuffed with the zero by the AACI */
          if ((i == 15) && ((CW.AACI_SLOT0[FrameNo] & 0x4000) || 
                            (CW.SecCODEC != 0x0)) && 
              (CW.TxFIFORdSltEn[FrameNo] & 0x2))
             PSR(DATA_0s, Masks[20], AACITrRxFIFO,SlP_R17);
  
          /* Read slot data from the Rx FIFO of the trickbox and verify 
             that it is the same as the one written to channel-1 of the 
             AACI */
          else if ((CW.DatTxCntlReg[1] & MaskBit &
                    CW.TxFIFORdSltEn[FrameNo]) && 
                   (CW.DatTxCntlReg[1] & AACI_TEN))
          {
            if (MaskBit == 0x4)
              PSR(ReMapAACI_Buffer[i - CW.Slt2Corcfct] & 0xFFFF0,Masks[20], AACITrRxFIFO,SlP_R18);
            else 
            {
              PSR(ReMapAACI_Buffer[i - S[1]], Masks[20], AACITrRxFIFO,SlP_R19);
            }
          }

          /* Read slot data from the Rx FIFO of the trickbox and verify 
             that it is the same as the one written to channel-2 of the 
             AACI */

          else if ((CW.DatTxCntlReg[2] & MaskBit & 
                    CW.TxFIFORdSltEn[FrameNo]) &&
                   (CW.DatTxCntlReg[2] & AACI_TEN))
          {
            if (MaskBit == 0x4)
              PSR(ReMapAACI_Buffer[i - CW.Slt2Corcfct] & 0xFFFF0, Masks[20], AACITrRxFIFO,SlP_R20);
            else 
              PSR(ReMapAACI_Buffer[i - S[2]], Masks[20], AACITrRxFIFO,SlP_R21);
          }

          /* Read slot data from the Rx FIFO of the trickbox and verify 
             that it is the same as the one written to channel-3 of the 
             AACI */
          else if ((CW.DatTxCntlReg[3] & MaskBit &
                    CW.TxFIFORdSltEn[FrameNo]) &&
                   (CW.DatTxCntlReg[3] & AACI_TEN))
          {
            if (MaskBit == 0x4)
              PSR(ReMapAACI_Buffer[i - CW.Slt2Corcfct] & 0xFFFF0, Masks[20], AACITrRxFIFO,SlP_R22);
            else 
            {
              PSR(ReMapAACI_Buffer[i - S[3]], Masks[20], AACITrRxFIFO,SlP_R23);
            }
          }
  
          /* Read slot data from the Rx FIFO of the trickbox and verify 
             that it is the same as the one written to channel-4 of the 
             AACI */
          else if ((CW.DatTxCntlReg[4] & MaskBit & 
                    CW.TxFIFORdSltEn[FrameNo]) &&
                   (CW.DatTxCntlReg[4] & AACI_TEN))
          {
            if (MaskBit == 0x4)
              PSR(ReMapAACI_Buffer[i - CW.Slt2Corcfct] & 0xFFFF0, Masks[20], AACITrRxFIFO,SlP_R24);
            else 
              PSR(ReMapAACI_Buffer[i - S[4]], Masks[20], AACITrRxFIFO,SlP_R25);
          }

          /* Read slot data from the Rx FIFO of the trickbox and verify 
             that it is the same as the one written to AACISL1TX, 
             AACISL2TX and AACISLOT12TX registers */
          else if (CW.DatTxCntlReg[5] & MaskBit & 
                   CW.TxRegRdSltEn[FrameNo])
          {
            if (MaskBit == 0x4)
              PSR(0x55AAA & 0xFFFF0, Masks[20], AACITrRxFIFO,SlP_R26);
            else 
              PSR(0x55AAA, Masks[20], AACITrRxFIFO,SlP_R27);
          }
          else
            PSR(DATA_0s, Masks[20] ,AACITrRxFIFO,SlP_R28);
  
          MaskBit = MaskBit << 1;
        }
      }
      if (CW.AACITB_SLOT0[FrameNo - 1] & 0x8000)
      {
        m = m + 13;
      }
    }
    /* All the expected slot data transmitted by the AACI 
       corresponding to the invalid frame are zero */
    else
      for (i = 0; i < 13; i++)
        PSR(DATA_0s, Masks[20], AACITrRxFIFO,SlP_R29);
  }

  /* Read the status register of the trickbox */
  PSR(AACITB_TxFFillLevel0 | AACITB_RxFFillLevel0, Masks[12], AACITrFIFOStat,SlP_R31);
  PI(2);

  C("Transmission and Reception Test Ends");
}

/************************ End of TxRx_SlPCLK_Test.c *******************/
