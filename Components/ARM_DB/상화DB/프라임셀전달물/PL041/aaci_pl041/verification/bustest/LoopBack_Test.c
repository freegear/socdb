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
-- File Name              : LoopBack_Test.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose : 
--           This function programs the AACI in loopback mode and
--           performs data tests to verify its operation.
--
-- --=================================================================*/

/**********************************************************************/
/*** For more information on the AACI, please refer to PL041 AMBA   ***/
/*** AACI Block Specification                                       ***/
/**********************************************************************/

/**********************************************************************/
/*************************** LoopBack_Test ****************************/
/**********************************************************************/
void LoopBack_Test(int TotNoFrame)
{
 
  /*
    Summary : LoopBack_Test
    =======================
    This test checks the following functionality:

    o This function programs the AACI in Loop back mode according to
      parameters passed to it by the calling functions
      (TxRx_FsPCLK_Call, TxRx_SlPCLK_Call). These parameters are 
      indirectly passed by updating the CW(ControlWords) structure in 
      calling functions (TxRx_FsPCLK_Call, TxRx_SlPCLK_Call).
      These parameters determine the following :

      - The expected Slot0 from the AACI
      - Register fields for the AACITXCRn (n=1 to 4) registers
      - Register fields for the AACIRXCRn (n=1 to 4) registers
      - SRC bit values to be transmitted by the trickbox
      - Information regarding which of the Slot registers need to
        be enabled for data transmission.
      - Information regarding which of the Slot registers need to
        be enabled for data reception
      - Information regarding which of the slot data need to be written
        into the Tx FIFOs of the AACI for each frame
      - Information regarding which of the AACISLnTX (n=1 to 4) 
        registers need to be loaded with new data for each frame.

    o This function also verifies data transmission by the AACI for 
      a range of TSIZE values in Compact mode and non-Compact mode

    o Additionally, this function verifies data reception by the AACI
      for a range of RSIZE values in Compact mode and non-Compact mode

    o The test sequence is as follows:
      - Data is written to the AACI's Transmit FIFOs and slot registers
      - Transmission and Reception is enabled.
      - The Trickbox is enabled to allow AACIBITCLK to be generated.
        However, no data transfer takes place because the Trickbox
        is not programmed for data transmission.
      - The LOOP bit in the AACIMAINCR register is set. This allows
        reception to start and consequently, for data transmission to
        proceed on the transmit data line.
      - After the end of data transfer, data is read out of the
        AACI's receive FIFOs and the Slot registers and verified.
      
   */
  int32 AACI_Buffer[150];
  int32 ReMapAACI_Buffer[150];
  int32 AACI_TempBuffer;
  int32 RegAACI_Buffer[150];
  int32 RSize[6];
  int32 TSize[6];
  int32 Temp[5];
  int i,j,k,l,m,n,Count;
  int DisableFurtherRd[6];
  int32 MaskBit;
  int32 RMaskBit;
  int FrameNo = 1;
  int32 SltEn;
 
  C("Start of Transmission and Reception Test in Loopback mode");
 
  for (i = 0; i < 150; i++)
  {
    AACI_Buffer[i] = random(10000);
  }

  /* All SRC bits set to the reset value */
  for (i = 1; i < 150; i = i + 13)
    AACI_Buffer[i] = 0x55000;

  /* For Every Slot2 first four LSB bits are ORed with one. The AACI
     is expected to zero the 4 LSbits in the transmitted Slot 2
     when Slot 1 bit 19 indicates a CODEC register write */
  for (i = 2; i < 150; i = i + 13)
    AACI_Buffer[i] = AACI_Buffer[i] | 0x0000F;

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

  /* Since the AACI is in loopback mode, data transmitted on Slot 1 
     bit 19 is made '0' (indicating a CODEC register write)
     for all values of TSize. */
  for (i = 1; i < 150; i = i + 13)
  {
    for (j = 1; j < 5; j++)
    {
      if (CW.DatTxCntlReg[j] & 0x2)
      {
        AACI_Buffer[i] = AACI_Buffer[i] >> (20 - TSize[j]);
      }
    }
  }
        
  /* Re-map AACI_Buffer so as to calculate the expected values in
     the Rx FIFO of the AACI */
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
          ReMapAACI_Buffer[i] = ReMapAACI_Buffer[i] & Masks[20];
          if (CW.DatRxCntlReg[5] & MaskBit)
            RegAACI_Buffer[i] = ReMapAACI_Buffer[i];
        }
      }
      MaskBit = MaskBit << 1;
    }
  }

  /* If the Slot1 indicates the read access, then the AACI is expected
     to stuff zeroes into Slot2 */
  for (i = 1; i < 150; i = i + 13)
  {
    for (j = 1; j < 5; j++)
    {
      if (CW.DatTxCntlReg[j] & 0x2)
      {
        if ((ReMapAACI_Buffer[i] & 0x80000))
        {
          ReMapAACI_Buffer[i + 1] = 0x0;
          RegAACI_Buffer[i + 1] = 0x0;
        }
        else
        {
          ReMapAACI_Buffer[i + 1] = ReMapAACI_Buffer[i + 1] & 0xFFFF0;
          RegAACI_Buffer[i + 1] =  RegAACI_Buffer[i + 1] & 0xFFFF0;
        }
      }
    }
  }

  /* Re-adjust the expected data to conform to the parameters 
     programmed by the calling function into the CW.DatRxCntlReg 
     array */
  for (i = 0; i < 150; i++)
  {
    if (!(i % 13))
      MaskBit = 0x2;
    else
    {
      for (j = 1; j < 5; j++)
      {
        if (CW.DatRxCntlReg[j] & MaskBit)
        {
          ReMapAACI_Buffer[i] = ReMapAACI_Buffer[i] & RMasks[RSize[j]];
          ReMapAACI_Buffer[i] = ReMapAACI_Buffer[i] >> (20 - RSize[j]);
        }
      }
      MaskBit = MaskBit << 1;
    }
  }

  /* Enable AACIBITCLK in the trickbox control register */
  PSW(AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);

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
    if (CW.DatRxCntlReg[5] & MaskBit)
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
  PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR1,LB_R1);
  PI(2);
  
  PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR2,LB_R2);
  PI(2);
  
  PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR3,LB_R3);
  PI(2);
  
  PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR4,LB_R4);
  PI(2);

  k = 13;
 
  /* Write data into the AACI's TX FIFOs  */
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
   
    if (CW.DatTxCntlReg[5] & MaskBit)
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
  PSR(AACITB_TxFFillLevel0 | AACITB_RxFFillLevel0, Masks[12], AACITrFIFOStat,LB_R5);
  PI(2);
 
  /* Start the transmission and reception by enabling  
     Loop Back mode in AACI */
  SltEn = SltEn | AACI_LOOP;
  PSW(SltEn, AACIMAINCR); 

  m = 0;

  /* Wait until the first valid frame starts */
  PO(AACI_MAINRXBUSY, AACI_MAINRXBUSY, AACIMAINFR, 28 * TimeOut,LB_po1)

  /* APB dummy read to avoid two consecutive poll commands */ 
  PSR(AACIBITCLK_PERIOD , Masks[20], AACITrBtClkPrd,DummyRead);

  FrameNo = FrameNo + 1;

  /* Allow data transfer to complete. Verify received data by reading
     from the slot registers and the FIFOs. Also, write data for 
     subsequent frames into the AACI's Tx FIFOs and the Slot registers
  */ 
  while(FrameNo <= TotNoFrame)
  {
    /* Read the data from the AACISL1RX and the AACISL2RX Registers */
    for (i = m + 1; i < m + 3; i++)
    {
      if (i == m + 1)
      {
        MaskBit = 0x2;
        RMaskBit = 0x4000;
      }
      if ((CW.DatRxCntlReg[5] & MaskBit) && 
          (CW.AACI_SLOT0[FrameNo] & RMaskBit))
      {
        if (i == m + 1)  
        {
          PO(AACI_SL1RXVALID, AACI_SL1RXVALID, AACISLFR, 6 * TimeOut,LB_po2);
          PSR(RegAACI_Buffer[i], Masks[20] ,AACISL1RX,LB_R6);
        }
        else if (i == m + 2)
        {
          PO(AACI_SL2RXVALID, AACI_SL2RXVALID, AACISLFR, 5 * TimeOut,LB_po3);
          PSR(RegAACI_Buffer[i], Masks[20] ,AACISL2RX,LB_R7);
        }
      }
      MaskBit = MaskBit << 1;
      RMaskBit = RMaskBit >> 1;
    }
    
    /* Write data into the AACISL1TX and the AACISL2TX registers */
    MaskBit = 0x2;
    for(i = k + 1; i < k + 3; i++)
    {
      if ((CW.DatTxCntlReg[5] & MaskBit & CW.TxRegWtSltEn[FrameNo + 1])
          && (FrameNo != TotNoFrame))
      {
        if (i == k + 1)
        {
          PO(AACI_SL1TXEMPTY, AACI_SL1TXEMPTY, AACISLFR, 3 * TimeOut,LB_po4);
          PSW(0x55AAA, AACISL1TX);
        }
        else if (i == k + 2)
        {
          PO(AACI_SL2TXEMPTY, AACI_SL2TXEMPTY, AACISLFR, 3 * TimeOut,LB_po5);
          PSW(0x55AAA, AACISL2TX);
        }
      }
      MaskBit = MaskBit << 1;
    }

    /* Based on Compact mode/Non-compact mode, generate write data 
       for the AACI */
    MaskBit = 0x2;
    for(i = k + 1; i < k + 7; i++)
    {
      for (j = 1; j < 5; j++)
      {
        if ((CW.DatTxCntlReg[j] & MaskBit &
             CW.TxFIFOWtSltEn[FrameNo + 1]) && 
            (FrameNo != TotNoFrame))
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
    k = k + 7;
    MaskBit = 0x80;
    for(i = k; i < k + 6; i++)
    {
      for (j = 1; j < 5; j++)
      {
        if ((CW.DatTxCntlReg[j] & MaskBit &
             CW.TxFIFOWtSltEn[FrameNo + 1]) && (FrameNo != TotNoFrame))
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
    k = k + 6;

    /* Write data into the AACISL12TX register */
    MaskBit = 0x1000;
    if ((CW.DatTxCntlReg[5] & MaskBit & CW.TxRegWtSltEn[FrameNo + 1])
         && (FrameNo != TotNoFrame))
    {
      PO(AACI_SL12TXEMPTY, AACI_SL12TXEMPTY, AACISLFR, 12 * TimeOut,LB_po6);
      PSW(0x55AAA, AACISL12TX);
    }
  
    /* Read the data from the AACISL12RX register */
    MaskBit = 0x1000;
    RMaskBit = 0x8;
    if ((CW.DatRxCntlReg[5] & MaskBit) && 
        (CW.AACI_SLOT0[FrameNo] & RMaskBit))
    {
      PO(AACI_SL12RXVALID, AACI_SL12RXVALID, AACISLFR, 13 * TimeOut,LB_po7);
      PSR(RegAACI_Buffer[m + 12], Masks[20], AACISL12RX,LB_R8);
    }

    /* Wait until the end of transmission of the 12th slot */
    Idle(BITCLK_TIME * 2);

    /* Initialise the flag variable DisableFurtherRd */
    /* This variable is used to ensure that the RxFIFO is read */
    /* only once in the Character mode */
    for (i = 1; i < 5; i++)
      DisableFurtherRd[i] = 0;

    /* Read data from the Rx FIFO of the AACI for the next frame */
    MaskBit  = 0x2;
    RMaskBit = 0x4000;
    for(i = m + 1; i < m + 13; i++)
    {
      for (j = 1; j < 5; j++)
      {
        if ((CW.DatRxCntlReg[j] & MaskBit) && 
            (CW.AACI_SLOT0[FrameNo] & RMaskBit) && 
            (!(DisableFurtherRd[j])))
        {
          if (!(CW.DatRxCntlReg[j] & AACI_CM))
          {
            PSR(ReMapAACI_Buffer[i], Masks[20], AACIDR[j],LB_R9);
            if (!(CW.DatRxCntlReg[j] & AACI_FEN))
              DisableFurtherRd[j] = 1;
          }
          else
          {
            if (Temp[j] == 200)
              Temp[j] = i;
            else
            {
              AACI_TempBuffer = (ReMapAACI_Buffer[Temp[j]]) |
                                (ReMapAACI_Buffer[i] << 16);
              PSR(AACI_TempBuffer, 0xFFFFFFFF, AACIDR[j],LB_R10);
              Temp[j] = 200;
            }
          }
        }
      }
      MaskBit = MaskBit << 1;
      RMaskBit = RMaskBit >> 1;
    }

    m = m + 13;
 
    FrameNo = FrameNo + 1;
  }
  /* Loop Ends  */

  /* Wait for the RxBusy bit to go to zero */
  Idle(BITCLK_TIME * 15);

  /* Read the AACISLFR register */
  PSR(AACI_SL1TXEMPTY | AACI_SL2TXEMPTY | AACI_SL12TXEMPTY, Masks[12], AACISLFR,LB_R11);

  /* Clear the TxFIFO of left-over data */
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
 
    /* Read the AACISR (Aaci status register) */
    PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR1,LB_R12);
    PI(2);
  
    PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR2,LB_R13);
    PI(2);
  
    PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR3,LB_R14);

    PI(2);
  
    PSR(AACI_TXFE | AACI_RXFE | AACI_TXHE, Masks[8], AACISR4,LB_R15);
    PI(2);
   
  }
  PSR(AACITB_TxFFillLevel0 | AACITB_RxFFillLevel0, Masks[12], AACITrFIFOStat,LB_R16);
  PI(2);

  PSW(0x0 , AACIMAINCR);

  C("End of Transmission and Reception Test in Loopback mode");
}

/*********************** End of LoopBack_Test.c ***********************/
