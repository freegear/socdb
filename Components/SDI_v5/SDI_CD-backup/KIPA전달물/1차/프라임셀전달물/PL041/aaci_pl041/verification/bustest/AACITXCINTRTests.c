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
-- File Name              : AACITXCINTRTests.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This section of the code tests the AACITXCINTRn 
--           [n = 1 to 4] Interrupt generation logic.
--
-- --=================================================================*/

/**********************************************************************/
/*********************** Function Declarations ************************/
/**********************************************************************/
void TxCompleteIntTest(int ChannelNo, int32 ChModeSizeFen);

/**********************************************************************/
/********************* TX Complete Interrupt Test *********************/
/**********************************************************************/
void AACITXCINTRTests(void)
{
 /*
   Summary : AACITXCINTRTests
   ==========================
   This section of the code tests the AACITXCINTRn [n = 1 to 4] 
   Interrupt generation logic. This function calls the 
   TxCompleteIntTest() function multiple times, each time with a 
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

 C("TRANSMIT COMPLETE INTERRUPT TESTS FOR CHANNEL 1");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 TxCompleteIntTest(Channel_1, AACI_CM | AACI_TSIZE12 | AACI_FEN);
 C("END OF TRANSMIT COMPLETE INTERRUPT TESTS FOR CHANNEL 1");

 C("TRANSMIT COMPLETE INTERRUPT TESTS FOR CH 1 IN CHARACTER MODE");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 TxCompleteIntTest(Channel_1, AACI_TSIZE20);
 C("END OF TRANSMIT COMPLETE INTERRUPT TESTS FOR CH 1  IN CHARACTER MODE");

 C("TRANSMIT COMPLETE INTERRUPT TESTS FOR CHANNEL 2 IN CHARACTER MODE")
;
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 TxCompleteIntTest(Channel_2, AACI_TSIZE16);
 C("END OF TRANSMIT COMPLETE INTERRUPT TESTS FOR CHANNEL 2  IN CHARACTER MODE");

 C("TRANSMIT COMPLETE INTERRUPT TESTS FOR CHANNEL 3");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 TxCompleteIntTest(Channel_3, AACI_CM | AACI_TSIZE16 | AACI_FEN);
 C("END OF TRANSMIT COMPLETE INTERRUPT TESTS FOR CHANNEL 3");

 C("TRANSMIT COMPLETE INTERRUPT TESTS FOR CHANNEL 4");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 TxCompleteIntTest(Channel_4, AACI_TSIZE18 | AACI_FEN);
 C("END OF TRANSMIT COMPLETE INTERRUPT TESTS FOR CHANNEL 4");
}

/**********************************************************************/
/********************* TX Complete Interrupt Test *********************/
/**********************************************************************/
void TxCompleteIntTest(int ChannelNo, int32 ChModeSizeFen)
{
 /*
   Summary : TxCompleteIntTest
   ===========================
 This section of the code tests the AACITXCINTR Interrupt generation 
 logic. The test sequence is as follows:

 - The Tx FIFO of the AACI is enabled and the TCIE bit in the
   AACIIEn [n = 1 to 4] Register is set to enable the AACITXCINTRn
   [n = 1 to 4] interrupt. 
 - The AACITXCRn [n = 1 to 4] register is programmed for transmitting 
   four valid slots. 
 - The Tx FIFO n [n = 1 to 4] of the AACI is filled with 4 data. 
 - The AACI is allowed to transmit one full frame. 
 - The TXFE, TXBUSY bits of the AACISR register are polled to detect 
   the completion of the frame.
 - Then the AACITrIntrReg is read to verify that the AACITXCINTRn 
   [n = 1 to 4] interrupt is asserted. Also, the AACIISR and 
   AACIALLINTS registers are read to verify the assertion of the 
   interrupt. 
 - Data is written to the Tx FIFO n [n = 1 to 4] to clear this 
   interrupt.

 This test is repeated after clearing the TCIE bit in the AACIIE
 register to ensure that this interrupt is not set when masked. 
 This test is repeated for all the channels. This test is also repeated
 with the channels programmed for Character mode reception.

 */

 int32 ChValidSlot, FEN, Mode, ChModeSize;
 int   i, One_BitClk_Period  = AACIBITCLK_PERIOD / PCLK_PERIOD;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 /* Extract control information from function arguments */
 FEN        = ChModeSizeFen & AACI_FEN;
 Mode       = ChModeSizeFen & MASK_MODE;
 ChModeSize = ChModeSizeFen & (MASK_MODE | MASK_RSIZE);

 /* Calculate the slot numbers for which the test will be done */
 if (FEN == AACI_FEN)
   ChValidSlot = AACI_TX3 | AACI_TX4 | AACI_TX9 | AACI_TX10;
 else
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_TX3 | AACI_TX4;
    else
      ChValidSlot = AACI_TX3;
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
 PI(One_BitClk_Period * 4);

 /* Disable trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 18);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Enable AACITXCINTRn [n = 1 to 4] Interrupt */
 if (ChannelNo == Channel_1)
   PSW(AACI_TCIE, AACIIE1);
 else
   {
    if (ChannelNo == Channel_2)
      PSW(AACI_TCIE, AACIIE2);
    else
      {
       if (ChannelNo == Channel_3)
         PSW(AACI_TCIE, AACIIE3);
       else
         {
          if (ChannelNo == Channel_4)
            PSW(AACI_TCIE, AACIIE4);
         }
      }
   }

 /* Fill AACI TX FIFO */
 TxFIFOFill(ChannelNo, ChValidSlot, ChModeSizeFen);

 /* Wait before the reprogramming CR register */
 PI(One_BitClk_Period * 4);

 /* Programming AACITXCRn [n = 1 to 4] for Transmission */
 ConfigTxCR(ChannelNo, ChValidSlot | ChModeSize | FEN | AACI_TEN);

 /* Filling the SLOT 0 data for the first frame into the trickbox */
 PSW(0x000C0000, AACITrTxFIFO);

 /* Fill in zeros for the remaining 12 data of the first frame */
 for (i = 0; i < 12; i = i + 1)
   {
    PSW(0x0, AACITrTxFIFO);
    }

 /* Filling the SLOT 0 data for the second frame into the trickbox */
 PSW(0x00080000, AACITrTxFIFO);

 /* Fill in zeros for the remaining 12 data of the first frame */
 for (i = 0; i < 12; i = i + 1)
   {
    PSW(0x0, AACITrTxFIFO);
    }

 /* Enable TrickBox for Transmission */
 PSW(AACITB_En | AACITB_TxEn | AACITB_RxEn | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Wait for the completion of half of the frame */
 PO(0x00000014, MASK_RxFFFillLevel, AACITrFIFOStat, 766 * One_BitClk_Period);

 /* Disable trickbox transmission and reception */
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Poll for TXFE = 1  and TXBUSY = 0. After this, the AACITXCINTRn 
    [n = 1 to 4] is expected to be set */
 if (ChannelNo == Channel_1)
   PO(AACI_TXFE, AACI_TXFE | AACI_TXBUSY, AACISR1, 766 * One_BitClk_Period);
 else
   {
    if (ChannelNo == Channel_2)
      PO(AACI_TXFE, AACI_TXFE | AACI_TXBUSY, AACISR2, 766 * One_BitClk_Period);
    else
      {
       if (ChannelNo == Channel_3)
         PO(AACI_TXFE, AACI_TXFE | AACI_TXBUSY, AACISR3, 766 * One_BitClk_Period);
       else
         {
          if (ChannelNo == Channel_4)
            PO(AACI_TXFE, AACI_TXFE | AACI_TXBUSY, AACISR4, 766 * One_BitClk_Period);
         }
      }
   }

 /* Disable trickbox reception and transmission */
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Wait for the completion of this frame */
 PO(0x0000001A, MASK_RxFFFillLevel, AACITrFIFOStat, 766 * One_BitClk_Period);

 /* Disable the trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Verify that the AACITXCINTRn [n = 1 to 4] interrupt is set */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_TCIS, AACI_TCIS, AACIISR1,AACI1_T480);
    PSR(AACI_TCIS1, AACI_TCIS1, AACIALLINTS,AACI1_T481);
    PSR(AACITXCMPLINTR1, AACITXCMPLINTR1, AACITrIntr1Reg,AACI1_T482);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_TCIS, AACI_TCIS, AACIISR2,AACI1_T483);
       PSR(AACI_TCIS2, AACI_TCIS2, AACIALLINTS,AACI1_T484);
       PSR(AACITXCMPLINTR2, AACITXCMPLINTR2, AACITrIntr1Reg,AACI1_T485);
       PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(AACI_TCIS, AACI_TCIS, AACIISR3,AACI1_T486);
          PSR(AACI_TCIS3, AACI_TCIS3, AACIALLINTS,AACI1_T487);
          PSR(AACITXCMPLINTR3, AACITXCMPLINTR3, AACITrIntr1Reg,AACI1_T488);
          PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(AACI_TCIS, AACI_TCIS, AACIISR4,AACI1_T489);
             PSR(AACI_TCIS4, AACI_TCIS4, AACIALLINTS,AACI1_T490);
             PSR(AACITXCMPLINTR4, AACITXCMPLINTR4, AACITrIntr1Reg,AACI1_T491);
             PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
            }
         }
      }
   }

 /* Write one more word into the AACI TxFIFO to clear the AACITXCINTRn
    [n = 1 to 4] interrupt  */
 if (Mode == AACI_CM)
   ChValidSlot == AACI_TX3 | AACI_TX4;
 else
   ChValidSlot == AACI_TX3;
 ConfigTxCR(ChannelNo, ChValidSlot | ChModeSize | FEN);
 TxFIFOFill(ChannelNo, ChValidSlot, ChModeSizeFen);

 /* Verify that the AACITXCINTRn [n = 1 to 4] interrupt is cleared */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_TCIS, AACIISR1,AACI1_T492);
    PSR(0x0, AACI_TCIS1, AACIALLINTS,AACI1_T493);
    PSR(0x0, AACITXCMPLINTR1, AACITrIntr1Reg,AACI1_T494);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(0x0, AACI_TCIS, AACIISR2,AACI1_T495);
       PSR(0x0, AACI_TCIS2, AACIALLINTS,AACI1_T496);
       PSR(0x0, AACITXCMPLINTR2, AACITrIntr1Reg,AACI1_T497);
       PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(0x0, AACI_TCIS, AACIISR3,AACI1_T498);
          PSR(0x0, AACI_TCIS3, AACIALLINTS,AACI1_T499);
          PSR(0x0, AACITXCMPLINTR3, AACITrIntr1Reg,AACI1_T500);
          PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(0x0, AACI_TCIS, AACIISR4,AACI1_T501);
             PSR(0x0, AACI_TCIS4, AACIALLINTS,AACI1_T502);
             PSR(0x0, AACITXCMPLINTR4, AACITrIntr1Reg,AACI1_T503);
             PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
            }
         }
      }
   }

 /* Calculate the slot numbers for which the read is to be done */
 if (FEN == AACI_FEN)
   ChValidSlot = AACI_TX3 | AACI_TX4 | AACI_TX9 | AACI_TX10;
 else
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_TX3 | AACI_TX4;
    else
      ChValidSlot = AACI_TX3;
   }

 /* Reading the first received invalid frame */
 for (i = 0 ; i < 13 ; i++ )
   {
    PSR(0x0, 0xFFFFF, AACITrRxFIFO,RdInvalid);
   }

 /* Reading the second received frame (first received valid frame) */
 FrameRead(ChannelNo, ChValidSlot,ChModeSize);

 /* Disable AACI */
 PSW(0x0, AACIMAINCR);
 PI(One_BitClk_Period * 3);

 /* Repeat the test with the AACITXCINTRn [n = 1 to 4] Interrupt
    disabled */ 
 /* Enable AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);
 PI(One_BitClk_Period * 4);

 /* Disable trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 18);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Disable AACITXCINTRn [n = 1 to 4] Interrupt */
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

 /* Calculate the slot numbers for which the test will be done */
 if (FEN == AACI_FEN)
   ChValidSlot = AACI_TX3 | AACI_TX4 | AACI_TX9 | AACI_TX10;
 else
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_TX3 | AACI_TX4;
    else
      ChValidSlot = AACI_TX3;
   }

 /* Configure the AACITXCRn [n = 1 to 4] registers */
 ConfigTxCR(ChannelNo, ChValidSlot | ChModeSize | FEN);

 /* Fill AACI TX FIFO */
 TxFIFOFill(ChannelNo, ChValidSlot, ChModeSizeFen);

 /* Filling the SLOT 0 data for the first frame into the trickbox */
 PSW(0x000C0000, AACITrTxFIFO);

 /* Fill in zeros for the remaining 12 data of the first frame */
 for (i = 0; i < 12; i = i + 1)
   {
    PSW(0x0, AACITrTxFIFO);
    }

 /* Filling the SLOT 0 data for the second frame into the trickbox */
 PSW(0x00080000, AACITrTxFIFO);

 /* Fill in zeros for the remaining 12 data of the second frame */
 for (i = 0; i < 12; i = i + 1)
   {
    PSW(0x0, AACITrTxFIFO);
    }

 /* Enable TrickBox transmission */
 PSW(AACITB_En | AACITB_TxEn | AACITB_RxEn | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Programming AACITXCRn [n = 1 to 4] for Transmission */
 ConfigTxCR(ChannelNo, ChValidSlot | ChModeSize | FEN | AACI_TEN);

 /* Wait for completion of half of the frame */
 PO(0x00000014, MASK_RxFFFillLevel, AACITrFIFOStat, 766 * One_BitClk_Period);

 /* Disable trickbox transmission and reception */
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Poll for TXFE = 1  and TXBUSY = 0. After this, the AACITXCINTRn 
    [n = 1 to 4] is expected not to be set */
 if (ChannelNo == Channel_1)
   PO(AACI_TXFE, AACI_TXFE | AACI_TXBUSY, AACISR1, 766 * One_BitClk_Period);
 else
   {
    if (ChannelNo == Channel_2)
      PO(AACI_TXFE, AACI_TXFE | AACI_TXBUSY, AACISR2, 766 * One_BitClk_Period);
    else
      {
       if (ChannelNo == Channel_3)
         PO(AACI_TXFE, AACI_TXFE | AACI_TXBUSY, AACISR3, 766 * One_BitClk_Period);
       else
         {
          if (ChannelNo == Channel_4)
            PO(AACI_TXFE, AACI_TXFE | AACI_TXBUSY, AACISR4, 766 * One_BitClk_Period);
         }
      }
   }

 /* Wait for the completion of that frame */
 PO(0x0000001A, MASK_RxFFFillLevel, AACITrFIFOStat, 766 * One_BitClk_Period);

 /* Disable the trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Verify that the AACITXCINTRn [n = 1 to 4] interrupt is not set */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_TCIS, AACIISR1,AACI1_T504);
    PSR(0x0, AACI_TCIS1, AACIALLINTS,AACI1_T505);
    PSR(0x0, AACITXCMPLINTR1, AACITrIntr1Reg,AACI1_T506);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(0x0, AACI_TCIS, AACIISR2,AACI1_T507);
       PSR(0x0, AACI_TCIS2, AACIALLINTS,AACI1_T508);
       PSR(0x0, AACITXCMPLINTR2, AACITrIntr1Reg,AACI1_T509);
       PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(0x0, AACI_TCIS, AACIISR3,AACI1_T510);
          PSR(0x0, AACI_TCIS3, AACIALLINTS,AACI1_T511);
          PSR(0x0, AACITXCMPLINTR3, AACITrIntr1Reg,AACI1_T512);
          PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(0x0, AACI_TCIS, AACIISR4,AACI1_T513);
             PSR(0x0, AACI_TCIS4, AACIALLINTS,AACI1_T514);
             PSR(0x0, AACITXCMPLINTR4, AACITrIntr1Reg,AACI1_T515);
             PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
            }
         }
      }
   }

 /* Unmask AACITXCINTRn [n = 1 to 4] interrupt */
 if (ChannelNo == Channel_1)
   PSW(AACI_TCIE, AACIIE1);
 else
   {
    if (ChannelNo == Channel_2)
      PSW(AACI_TCIE, AACIIE2);
    else
      {
       if (ChannelNo == Channel_3)
         PSW(AACI_TCIE, AACIIE3);
       else
         {
          if (ChannelNo == Channel_4)
            PSW(AACI_TCIE, AACIIE4);
         }
      }
   }

 /* Verify that the AACITXCINTRn [n = 1 to 4] interrupt is set */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_TCIS, AACI_TCIS, AACIISR1,AACI1_T516);
    PSR(AACI_TCIS1, AACI_TCIS1, AACIALLINTS,AACI1_T517);
    PSR(AACITXCMPLINTR1, AACITXCMPLINTR1, AACITrIntr1Reg,AACI1_T518);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_TCIS, AACI_TCIS, AACIISR2,AACI1_T519);
       PSR(AACI_TCIS2, AACI_TCIS2, AACIALLINTS,AACI1_T520);
       PSR(AACITXCMPLINTR2, AACITXCMPLINTR2, AACITrIntr1Reg,AACI1_T521);
       PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(AACI_TCIS, AACI_TCIS, AACIISR3,AACI1_T522);
          PSR(AACI_TCIS3, AACI_TCIS3, AACIALLINTS,AACI1_T523);
          PSR(AACITXCMPLINTR3, AACITXCMPLINTR3, AACITrIntr1Reg,AACI1_T524);
          PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(AACI_TCIS, AACI_TCIS, AACIISR4,AACI1_T525);
             PSR(AACI_TCIS4, AACI_TCIS4, AACIALLINTS,AACI1_T526);
             PSR(AACITXCMPLINTR4, AACITXCMPLINTR4, AACITrIntr1Reg,AACI1_T527);
             PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
            }
         }
      }
   }

 /* Disable Trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Verify that the AACITXCINTRn [n = 1 to 4] interrupt is cleared
    when the AACI is disabled */

 /* Disable AACI */
 PSW(0x0, AACIMAINCR);

 /* Since the interrupt is clocked out, allow for atleast one clock
    for the interrupt line to be updated */
 PI(0x2);

 /* Verify that the AACITXCINTRn [n = 1 to 4] interrupt is cleared */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_TCIS, AACIISR1,AACI1_distc1);
    PSR(0x0, AACI_TCIS1, AACIALLINTS,AACI1_distc2);
    PSR(0x0, AACITXCMPLINTR1, AACITrIntr1Reg,AACI1_distc3);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_distc4);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(0x0, AACI_TCIS, AACIISR2,AACI1_distc5);
       PSR(0x0, AACI_TCIS2, AACIALLINTS,AACI1_distc6);
       PSR(0x0, AACITXCMPLINTR2, AACITrIntr1Reg,AACI1_distc7);
       PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_distc8);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(0x0, AACI_TCIS, AACIISR3,AACI1_distc9);
          PSR(0x0, AACI_TCIS3, AACIALLINTS,AACI1_distc10);
          PSR(0x0, AACITXCMPLINTR3, AACITrIntr1Reg,AACI1_distc11);
          PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_distc12);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(0x0, AACI_TCIS, AACIISR4,AACI1_distc13);
             PSR(0x0, AACI_TCIS4, AACIALLINTS,AACI1_distc14);
             PSR(0x0, AACITXCMPLINTR4, AACITrIntr1Reg,AACI1_distc15);
             PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_distc16);
            }
         }
      }
   }

 PSW(0x0, AACIIE1);
 PSW(0x0, AACIIE2);
 PSW(0x0, AACIIE3);
 PSW(0x0, AACIIE4);

 /* Reading the first received invalid frame */
 for (i = 0 ; i < 13 ; i++ )
   {
    PSR(0x0, 0xFFFFF, AACITrRxFIFO,RdInvalid);
   }

 /* Reading the second received frame (first received valid frame) */
 FrameRead(ChannelNo, ChValidSlot,ChModeSize);
}

/********************* End of AACITXCINTRTests.c **********************/
