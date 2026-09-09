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
-- File Name              : AACIURINTRTests.c.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This section of the code tests the AACIURINTRn [n = 1 to 4]
--           interrupt generation logic.
--
-- --=================================================================*/

/**********************************************************************/
/*********************** Function Declarations ************************/
/**********************************************************************/
void TxUnderRunIntTest(int ChannelNo, int32 ChModeSizeFen);

/**********************************************************************/
/******************* AACIURINTR interrupt Tests ***********************/
/**********************************************************************/
void AACIURINTRTests(void)
 {
 /*
   Summary : AACIURINTRTests
   =========================
   This section of the code tests the AACIURINTRn [n = 1 to 4] 
   Interrupt generation logic. This function calls the 
   TxUnderRunIntTest() function multiple times, each time with a 
   different set of arguments. Each function call tests a specific 
   channel of the AACI.
 
   To implement the receive section in the channels two types of modules
   have been used in the AACI. One is the AaciDMARChannel (DMA-capable)
   and the other is the AaciRxChannel (non-DMA-capable). In Channel 1,
   the module AaciDMARChannel has been instantiated and in channels 2, 3
   and 4, the module AaciRxChannel is instatiated. A similar situation
   exists for the transmit sections in the channels. The modules in this
   case are AaciDMATChannel and AaciTxChannel. Exhaustively testing the
   interrupt generation logic in all the instances of the channel
   control logic in both modes (FIFO mode and Character mode) would mean
   a large simulation runtime. The interrupt tests have been arranged
   to test the interrupt generation logic in both the MODULE types in
   both the modes (CHARACTER mode and FIFO mode). To this end, the
   interrupts are tested for channel 1 for both modes (FIFO modes as
   well as CHARACTER mode) and out of channels 2, 3 and 4 one channel
   is tested in the CHARACTER mode and the others in the FIFO mode. This
   helps in testing both modules in both the modes with lesser
   simulation run time.

 */
  int One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;

  if (AACIBITCLK_PERIOD < PCLK_PERIOD)
     One_BitClk_Period = 0x1;

  C("TRANSMIT UNDERFLOW INTERRUPT TESTS FOR CHANNEL 1");
  PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  PI(One_BitClk_Period * 16);
  PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  TxUnderRunIntTest(Channel_1, AACI_CM | AACI_TSIZE12 | AACI_FEN);
  C("END OF TRANSMIT UNDERFLOW INTERRUPT TESTS FOR CHANNEL 1");

  C("TRANSMIT UNDERFLOW INTERRUPT TESTS FOR CH 1 IN CHARACTER MODE");
  PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  PI(One_BitClk_Period * 16);
  PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  TxUnderRunIntTest(Channel_1, AACI_TSIZE18);
  C("END OF TRANSMIT UNDERFLOW INTERRUPT TESTS FOR CH 1 IN CHARACTER MODE");

  C("TRANSMIT UNDERFLOW INTERRUPT TESTS FOR CHANNEL 2");
  PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  PI(One_BitClk_Period * 16);
  PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  TxUnderRunIntTest(Channel_2, AACI_TSIZE20 | AACI_FEN);
  C("END OF TRANSMIT UNDERFLOW INTERRUPT TESTS FOR CHANNEL 2");

  C("TRANSMIT UNDERFLOW INTERRUPT TESTS FOR CH 3 IN CHARACTER MODE");
  PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  PI(One_BitClk_Period * 16);
  PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  TxUnderRunIntTest(Channel_3, AACI_TSIZE18);
  C("END OF TRANSMIT UNDERFLOW INTERRUPT TESTS FOR CH 3  IN CHARACTER MODE");
  C("TRANSMIT UNDERFLOW INTERRUPT TESTS FOR CHANNEL 4");
  PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  PI(One_BitClk_Period * 16);
  PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  TxUnderRunIntTest(Channel_4, AACI_TSIZE16 | AACI_FEN);
  C("END OF TRANSMIT UNDERFLOW INTERRUPT TESTS FOR CHANNEL 4");
 }

/**********************************************************************/
/****************** TX underflow Interrupt Test ***********************/
/**********************************************************************/
void TxUnderRunIntTest(int ChannelNo, int32 ChModeSizeFen)
{
 /*
   Summary : TxUnderRunIntTest
   ===========================
   This section of the code tests the AACIURINTRn [n = 1 to 4] interrupt
   generation logic. The test sequence is as follows :
   - The TxFIFO of the AACI is enabled and the TUIE bit in the AACIIE 
     Register is set. The AACITXCRn [n = 1 to 4] register is programmed
     for transmitting four valid slots. 
   - The Tx FIFO of the AACI is filled with 7 data - 4 for the first 
     frame and 3 for the second. 
   - Data is written into the transmit FIFO of the trickbox so as to 
     request for data for the all the slots for the next frame. 
   - During the transmission of the second frame the AACIURINTRn 
     [n = 1 to 4] interrupt request for that channel is expected
     to be asserted by the AACI because enough data is not available in 
     the Tx FIFO. The assertion of this interrupt is verified by reading
     the AACITrIntrReg in the trickbox and the AACISR, AACIISR and 
     AACIALLINTS registers of the AACI.
   - Writing to the TXUECn [n = 1 to 4] bit in the INTCLEAR register 
     should clear interrupt. This is verified by again reading the 
     AACITrIntrReg in the trickbox and the AACISR, AACIALLINTS and 
     AACIISR registers in the AACI.

   This test is repeated after masking the interrupt to verify that this
   interrupt is not asserted when masked. After the interrupting 
   condition is created, it is also verified that unmasking the 
   interrupt results in the assertion of this interrupt. 
   This test is repeated for all channels. This test is also repeated 
   with the channels programmed for Character mode transmission.

 */

 int32 ChValidSlot, FEN, Mode, ChModeSize, temp;

 int32 MaskBit = 0x01;

 int   i = 0, One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
   One_BitClk_Period = 0x1;

 /* Extract control information from function arguments */
 FEN          = ChModeSizeFen & AACI_FEN;
 Mode         = ChModeSizeFen & MASK_MODE;
 ChModeSize   = ChModeSizeFen & (MASK_MODE | MASK_RSIZE);

 /* Calculate the slot numbers for which the test will be done */
 if (FEN == AACI_FEN)
   ChValidSlot = AACI_TX9 | AACI_TX10 | AACI_TX11 | AACI_TX8;
 else
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_TX9 | AACI_TX10;
    else
      ChValidSlot = AACI_TX9;
   }
 
 /* Configure the AACITXCRn [n = 1 to 4] registers */
 if (ChannelNo == Channel_1)
   {
    ConfigTxCR(Channel_1, ChValidSlot | ChModeSize | FEN);
    ConfigTxCR(Channel_2, 0x0);
    ConfigTxCR(Channel_3, 0x0);
    ConfigTxCR(Channel_4, 0x0);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       ConfigTxCR(Channel_2, ChValidSlot | ChModeSize | FEN);
       ConfigTxCR(Channel_1, 0x0);
       ConfigTxCR(Channel_3, 0x0);
       ConfigTxCR(Channel_4, 0x0);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          ConfigTxCR(Channel_3, ChValidSlot | ChModeSize | FEN);
          ConfigTxCR(Channel_1, 0x0);
          ConfigTxCR(Channel_2, 0x0);
          ConfigTxCR(Channel_4, 0x0);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             ConfigTxCR(Channel_4, ChValidSlot | ChModeSize | FEN);
             ConfigTxCR(Channel_1, 0x0);
             ConfigTxCR(Channel_2, 0x0);
             ConfigTxCR(Channel_3, 0x0);
            }
         }
      }
   }

 /* Enable AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);

 /* Enable AACIURINTRn [n = 1 to 4] Interrupt */
 if (ChannelNo == Channel_1)
   PSW(AACI_TXUIE, AACIIE1);
 else
   {
    if (ChannelNo == Channel_2)
      PSW(AACI_TXUIE, AACIIE2);
    else
      {
       if (ChannelNo == Channel_3)
         PSW(AACI_TXUIE, AACIIE3);
       else
         {
          if (ChannelNo == Channel_4)
            PSW(AACI_TXUIE, AACIIE4);
         }
      }
   }

 /* Filling the trickbox with data for first valid frame */

 /* Slot 0 data indicates that Slot 1 is valid */
 PSW(0x000C0000, AACITrTxFIFO);

 /* Make SRC bits 0's - request data on all slots in the next frame */
 /* Remaining 12 data are filled with zeros */
 for (i = 0; i < 12; i = i + 1)
   {
    PSW(0x0, AACITrTxFIFO);
    }

 /* Filling the trickbox with data for the second valid frame */

 /* Slot 0 data indicates that Slot 1 is valid */
 PSW(0x000C0000, AACITrTxFIFO);

 /* Make SRC bits 0's - request data on all slots in the next frame */
 /* Remaining 12 data are filled with the zeros */
 for (i = 0; i < 12; i = i + 1)
   {
    PSW(0x0, AACITrTxFIFO);
    }

 /* Filling the trickbox with data for the third valid frame */

 /* Slot 0 indicates that the frame is valid but none of the slots
    are valid */
 PSW(0x00080000, AACITrTxFIFO);

 /* Remaining 12 data are filled with the zeros */
 for (i = 0; i < 12; i = i + 1)
   {
    PSW(0x0, AACITrTxFIFO);
    }

 /* Fill AACI TX FIFO (1st Frame) */
 TxFIFOFill(ChannelNo, ChValidSlot, ChModeSizeFen);

 /* Write data for 2nd Frame in Tx FIFO (write one slot less) */ 
 if (FEN == AACI_FEN)
   ChValidSlot = AACI_TX9 | AACI_TX10 | AACI_TX8;
 else
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_TX9;
    else
      ChValidSlot = 0x0;
   }
 TxFIFOFill(ChannelNo, ChValidSlot, ChModeSizeFen);

 /* Reverting back to normal valid slots configuration */
 if (FEN == AACI_FEN)
   ChValidSlot = AACI_TX9 | AACI_TX10 | AACI_TX11 | AACI_TX8;
 else
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_TX9 | AACI_TX10;
    else
      ChValidSlot = AACI_TX9;
   }

 /* Enable Trickbox for reception and transmission */
 PSW(AACITB_En | AACITB_RxEn | AACITB_TxEn | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Enable AACI Channel Transmission */
 ConfigTxCR(ChannelNo, ChValidSlot | ChModeSize | FEN | AACI_TEN);

 /* Waiting for one frame and 6 slots of second frame to complete.
    This is to disable trickbox reception after two frames so that
    the extra read of data for the third frame from the Trickbox
    Rx FIFO can be avoided. The disabling of trickbox reception
    takes effect from the start of the next frame */
 PO(0x00140000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Disable Trickbox for reception */
 PSW(AACITB_En | AACITB_TxEn | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Waiting for completion of two frames */
 PO(0x000A0000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Disable AACI Transmission */
 ConfigTxCR(ChannelNo, ChValidSlot | ChModeSize | FEN);

 /* Verify that the AACIURINTRn [n = 1 to 4] interrupt is set */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_TXUE, AACI_TXUE, AACISR1,AACI1_T540);
    PSR(AACI_TXUIS, AACI_TXUIS, AACIISR1,AACI1_T541);
    PSR(AACI_TXUIS1, AACI_TXUIS1, AACIALLINTS,AACI1_T542);
    PSR(AACITXURINTR1, AACITXURINTR1, AACITrIntr1Reg,AACI1_T543);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_TXUE, AACI_TXUE, AACISR2,AACI1_T544);
       PSR(AACI_TXUIS, AACI_TXUIS, AACIISR2,AACI1_T545);
       PSR(AACI_TXUIS2, AACI_TXUIS2, AACIALLINTS,AACI1_T546);
       PSR(AACITXURINTR2, AACITXURINTR2, AACITrIntr1Reg,AACI1_T547);
       PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(AACI_TXUE, AACI_TXUE, AACISR3,AACI1_T548);
          PSR(AACI_TXUIS, AACI_TXUIS, AACIISR3,AACI1_T549);
          PSR(AACI_TXUIS3, AACI_TXUIS3, AACIALLINTS,AACI1_T550);
          PSR(AACITXURINTR3, AACITXURINTR3, AACITrIntr1Reg,AACI1_T551);
          PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(AACI_TXUE, AACI_TXUE, AACISR4,AACI1_T552);
             PSR(AACI_TXUIS, AACI_TXUIS, AACIISR4,AACI1_T553);
             PSR(AACI_TXUIS4, AACI_TXUIS4, AACIALLINTS,AACI1_T554);
             PSR(AACITXURINTR4, AACITXURINTR4, AACITrIntr1Reg,AACI1_T555);
             PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
            }
         }
      }
   }

 /* 2 frames dummy read */
 for (i = 0; i < 26; i++ )
   {
    PSR(0x00, 0x0, AACITrRxFIFO,AACI1_Dummy_Rd);
   }

 /* Clear the interrupt */
 if (ChannelNo == Channel_1)
    PSW(AACI_TXUEC1, AACIINTCLR);
 else
   {
    if (ChannelNo == Channel_2)
      PSW(AACI_TXUEC2, AACIINTCLR);
    else
      {
       if (ChannelNo == Channel_3)
         PSW(AACI_TXUEC3, AACIINTCLR);
       else
         {
          if (ChannelNo == Channel_4)
            PSW(AACI_TXUEC4, AACIINTCLR);
         }
      }
   }

 /* Verify that the AACIURINTRn [n = 1 to 4] interrupt is cleared */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACITXURINTR1, AACITrIntr1Reg,AACI1_T559);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }
 else if (ChannelNo == Channel_2)
   {
    PSR(0x0, AACITXURINTR2, AACITrIntr1Reg,AACI1_T563);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }
 else if (ChannelNo == Channel_3)
   {
    PSR(0x0, AACITXURINTR3, AACITrIntr1Reg,AACI1_T567);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }
 else if (ChannelNo == Channel_4)
   {
    PSR(0x0, AACITXURINTR4, AACITrIntr1Reg,AACI1_T571);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }

 /* Wait for synchronisation to occur */
 PI(One_BitClk_Period * 4);

 /* Verify that the AACIURINTRn [n = 1 to 4] interrupt is cleared */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_TXUE, AACISR1,AACI1_T556);
    PSR(0x0, AACI_TXUIS, AACIISR1,AACI1_T557);
    PSR(0x0, AACI_TXUIS1, AACIALLINTS,AACI1_T558);
   }
 else if (ChannelNo == Channel_2)
   {
    PSR(0x0, AACI_TXUE, AACISR2,AACI1_T560);
    PSR(0x0, AACI_TXUIS, AACIISR2,AACI1_T561);
    PSR(0x0, AACI_TXUIS2, AACIALLINTS,AACI1_T562);
   }
 else if (ChannelNo == Channel_3)
   {
    PSR(0x0, AACI_TXUE, AACISR3,AACI1_T564);
    PSR(0x0, AACI_TXUIS, AACIISR3,AACI1_T565);
    PSR(0x0, AACI_TXUIS3, AACIALLINTS,AACI1_T566);
   }
 else if (ChannelNo == Channel_4)
   {
    PSR(0x0, AACI_TXUE, AACISR4,AACI1_T568);
    PSR(0x0, AACI_TXUIS, AACIISR4,AACI1_T569);
    PSR(0x0, AACI_TXUIS4, AACIALLINTS,AACI1_T570);
   }

 /* Waiting for the last frame to complete */
 PO(0x00000000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 20);

 /* Disable the trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Disable the AACI */
 PSW(0x0, AACIMAINCR);
 PI(One_BitClk_Period * 4);

 /* Enable the AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);

 /* Repeatin the test with the interrupt masked. */

 /* Disable trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 20);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Disable the AACIURINTRn [n = 1 to 4] Interrupt */
 if (ChannelNo == Channel_1)
   PSW(0x0, AACIIE1);
 else
   {
    if (ChannelNo == Channel_2)
      PSW(0x0, AACIIE2);
    else
      {
       if (ChannelNo == Channel_3)
         PSW(0x0, AACIIE3);
       else
         {
          if (ChannelNo == Channel_4)
            PSW(0x0, AACIIE4);
         }
      }
   }

 /* Filling the trickbox with data for the first valid frame */

 /* Slot 0 data indicates that Slot 1 is valid */
 PSW(0x000C0000, AACITrTxFIFO);

 /* Make SRC bits 0's - request data on all slots in the next frame */
 /* Remaining 12 data are filled with zeros */
 for (i = 0; i < 12; i = i + 1)
   {
    PSW(0x0, AACITrTxFIFO);
    }

 /* Filling the trickbox with data for second valid frame */
 /* Slot 0 indicates that the frame is valid but none of the slots
    are valid */
 PSW(0x00080000, AACITrTxFIFO);
 for (i = 0; i < 12; i = i + 1)
   {
    PSW(0x0, AACITrTxFIFO);
    }

 /* Filling the trickbox with data for third valid frame */
 /* Slot 0 indicates that the frame is valid but none of the slots
    are valid */
 PSW(0x00080000, AACITrTxFIFO);

 /* Remaining 12 data are filled with the zeros */
 for (i = 0; i < 12; i = i + 1)
   {
    PSW(0x0, AACITrTxFIFO);
    }

 /* Fill AACI TX FIFO (1st Frame) */
 TxFIFOFill(ChannelNo, ChValidSlot, ChModeSizeFen);

 /* Write data for 2nd Frame into the AACI Tx FIFO 
    (write one slot less) */
 if (FEN == AACI_FEN)
   ChValidSlot = AACI_TX9 | AACI_TX10 | AACI_TX8;
 else
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_TX9;
    else
      ChValidSlot = 0x0;
   }
 TxFIFOFill(ChannelNo, ChValidSlot, ChModeSizeFen);

 /* Reverting back to normal valid slots configuration */
 if (FEN == AACI_FEN)
   ChValidSlot = AACI_TX9 | AACI_TX10 | AACI_TX11 | AACI_TX8;
 else
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_TX9 | AACI_TX10;
    else
      ChValidSlot = AACI_TX9;
   }

 /* Enable Trickbox for reception and transmission */
 PSW(AACITB_En | AACITB_RxEn | AACITB_TxEn | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Enable AACI Channel Transmission */
 ConfigTxCR(ChannelNo, ChValidSlot | ChModeSize | FEN | AACI_TEN);

 /* Waiting for one frame and 6 slots of second frame to complete.
    This is to disable trickbox reception after two frames so that
    the extra read of data for the third frame from the Trickbox
    Rx FIFO can be avoided. The disabling of trickbox reception
    takes effect from the start of the next frame */
 PO(0x00140000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Disable Trickbox for reception */
 PSW(AACITB_En | AACITB_TxEn | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Waiting for completion of two frames */
 PO(0x000A0000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Disable AACI Transmission */
 ConfigTxCR(ChannelNo, ChValidSlot | ChModeSize | FEN);

 /* Verify that the AACIURINTRn [n = 1 to 4] interrupt is not set */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_TXUE, AACI_TXUE, AACISR1,AACI1_T572);
    PSR(0x0, AACI_TXUIS, AACIISR1,AACI1_T573);
    PSR(0x0, AACI_TXUIS1, AACIALLINTS,AACI1_T574);
    PSR(0x0, AACITXURINTR1, AACITrIntr1Reg,AACI1_T575);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_TXUE, AACI_TXUE, AACISR2,AACI1_T576);
       PSR(0x0, AACI_TXUIS, AACIISR2,AACI1_T577);
       PSR(0x0, AACI_TXUIS2, AACIALLINTS,AACI1_T578);
       PSR(0x0, AACITXURINTR2, AACITrIntr1Reg,AACI1_T579);
       PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(AACI_TXUE, AACI_TXUE, AACISR3,AACI1_T580);
          PSR(0x0, AACI_TXUIS, AACIISR3,AACI1_T581);
          PSR(0x0, AACI_TXUIS3, AACIALLINTS,AACI1_T582);
          PSR(0x0, AACITXURINTR3, AACITrIntr1Reg,AACI1_T583);
          PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(AACI_TXUE, AACI_TXUE, AACISR4,AACI1_T584);
             PSR(0x0, AACI_TXUIS, AACIISR4,AACI1_T585);
             PSR(0x0, AACI_TXUIS4, AACIALLINTS,AACI1_T586);
             PSR(0x0, AACITXURINTR4, AACITrIntr1Reg,AACI1_T587);
             PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
            }
         }
      }
   }

 /* Enable AACIURINTRn [n = 1 to 4] Interrupt */
 if (ChannelNo == Channel_1)
   PSW(AACI_TXUIE, AACIIE1);
 else
   {
    if (ChannelNo == Channel_2)
      PSW(AACI_TXUIE, AACIIE2);
    else
      {
       if (ChannelNo == Channel_3)
         PSW(AACI_TXUIE, AACIIE3);
       else
         {
          if (ChannelNo == Channel_4)
            PSW(AACI_TXUIE, AACIIE4);
         }
      }
   }

 /* Verify that the AACIURINTRn [n = 1 to 4] interrupt is set */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_TXUE, AACI_TXUE, AACISR1,AACI1_T588);
    PSR(AACI_TXUIS, AACI_TXUIS, AACIISR1,AACI1_T589);
    PSR(AACI_TXUIS1, AACI_TXUIS1, AACIALLINTS,AACI1_T590);
    PSR(AACITXURINTR1, AACITXURINTR1, AACITrIntr1Reg,AACI1_T591);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_TXUE, AACI_TXUE, AACISR2,AACI1_T592);
       PSR(AACI_TXUIS, AACI_TXUIS, AACIISR2,AACI1_T593);
       PSR(AACI_TXUIS2, AACI_TXUIS2, AACIALLINTS,AACI1_T594);
       PSR(AACITXURINTR2, AACITXURINTR2, AACITrIntr1Reg,AACI1_T595);
       PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(AACI_TXUE, AACI_TXUE, AACISR3,AACI1_T596);
          PSR(AACI_TXUIS, AACI_TXUIS, AACIISR3,AACI1_T597);
          PSR(AACI_TXUIS3, AACI_TXUIS3, AACIALLINTS,AACI1_T598);
          PSR(AACITXURINTR3, AACITXURINTR3, AACITrIntr1Reg,AACI1_T599);
          PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(AACI_TXUE, AACI_TXUE, AACISR4,AACI1_T600);
             PSR(AACI_TXUIS, AACI_TXUIS, AACIISR4,AACI1_T601);
             PSR(AACI_TXUIS4, AACI_TXUIS4, AACIALLINTS,AACI1_T602);
             PSR(AACITXURINTR4, AACITXURINTR4, AACITrIntr1Reg,AACI1_T603);
             PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
            }
         }
      }
   }

 /* 2 frames dummy read */
 for (i = 0; i < 26; i++ )
   {
    PSR(0x00, 0x0, AACITrRxFIFO,AACI1_Dummy_Rd);
   }

 /* Waiting for the last frame to complete */
 PO(0x00000000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Disable Trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Disable AACI to verify that it clears the Interrupt */
 PSW(0x0, AACIMAINCR);

 /* Verify that the AACIURINTRn [n = 1 to 4] interrupt is cleared */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACITXURINTR1, AACITrIntr1Reg,AACI1_disur4);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_disur5);
   }
 else if (ChannelNo == Channel_2)
   {
    PSR(0x0, AACITXURINTR2, AACITrIntr1Reg,AACI1_disur9);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_disur10);
   }
 else if (ChannelNo == Channel_3)
   {
    PSR(0x0, AACITXURINTR3, AACITrIntr1Reg,AACI1_disur14);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_disur15);
   }
 else if (ChannelNo == Channel_4)
   {
    PSR(0x0, AACITXURINTR4, AACITrIntr1Reg,AACI1_disur19);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_disur20);
   }

 /* Wait for synchronisation to occur */
 PI(One_BitClk_Period * 4);

 /* Verify that the AACIURINTRn [n = 1 to 4] interrupt is cleared */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_TXUE, AACISR1,AACI1_disur1);
    PSR(0x0, AACI_TXUIS, AACIISR1,AACI1_disur2);
    PSR(0x0, AACI_TXUIS1, AACIALLINTS,AACI1_disur3);
   }
 else if (ChannelNo == Channel_2)
   {
    PSR(0x0, AACI_TXUE, AACISR2,AACI1_disur6);
    PSR(0x0, AACI_TXUIS, AACIISR2,AACI1_disur7);
    PSR(0x0, AACI_TXUIS2, AACIALLINTS,AACI1_disur8);
   }
 else if (ChannelNo == Channel_3)
   {
    PSR(0x0, AACI_TXUE, AACISR3,AACI1_disur11);
    PSR(0x0, AACI_TXUIS, AACIISR3,AACI1_disur12);
    PSR(0x0, AACI_TXUIS3, AACIALLINTS,AACI1_disur13);
   }
 else if (ChannelNo == Channel_4)
   {
    PSR(0x0, AACI_TXUE, AACISR4,AACI1_disur16);
    PSR(0x0, AACI_TXUIS, AACIISR4,AACI1_disur17);
    PSR(0x0, AACI_TXUIS4, AACIALLINTS,AACI1_disur18);
   }

 /* Disable all the channels */
 ConfigTxCR(Channel_1, 0x0);
 ConfigTxCR(Channel_2, 0x0);
 ConfigTxCR(Channel_3, 0x0);
 ConfigTxCR(Channel_4, 0x0);

 /* Disabling all the interrupts and waitng for synchronisation */
 PSW(0x0, AACIIE1);
 PSW(0x0, AACIIE2);
 PSW(0x0, AACIIE3);
 PSW(0x0, AACIIE4);
 PI(One_BitClk_Period * 3);
}

/********************** End of AACIURINTRTests.c **********************/
