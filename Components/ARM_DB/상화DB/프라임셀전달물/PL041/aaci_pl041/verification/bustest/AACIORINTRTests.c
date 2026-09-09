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
-- File Name              : AACIORINTRTests.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose : 
--           This section of the code tests the AACIORINTRn [n = 1 to 4]
--           Interrupt generation logic.
--
-- --=================================================================*/

/**********************************************************************/
/*********************** Function Declarations ************************/
/**********************************************************************/
void OverrunIntTest(int ChannelNo, int32 ChModeSizeFen);
 
/**********************************************************************/
/*********************** Overrun Interrupt Tests **********************/
/**********************************************************************/
void AACIORINTRTests(void)
{
 /*
   Summary : OverrunIntTest
   ========================
   This section of the code tests the AACIORINTRn [n = 1 to 4] Interrupt
   generation logic. This function calls the OverrunIntTest() function
   multiple times, each time with a different set of arguments. Each
   function call tests a specific channel of the AACI.

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

 C("INTERRUPT TESTS");
 C("Rx OVERRUN INTERRUPT TEST FOR CHANNEL 1");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 OverrunIntTest(Channel_1, AACI_CM | AACI_RSIZE12 | AACI_FEN);
 C("END OF Rx OVERRUN INTERRUPT TEST FOR CHANNEL 1");

 C("Rx OVERRUN INTERRUPT TEST FOR CHANNEL 1 IN CHARACTER MODE");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 OverrunIntTest(Channel_1, AACI_RSIZE20);
 C("END OF Rx OVERRUN INTERRUPT TEST FOR CH 1 IN CHARACTER MODE");

 C("Rx OVERRUN INTERRUPT TEST FOR CHANNEL 2");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 OverrunIntTest(Channel_2, AACI_RSIZE16 | AACI_FEN);
 C("END OF Rx OVERRUN INTERRUPT TEST FOR CHANNEL 2");

 C("Rx OVERRUN INTERRUPT TEST FOR CHANNEL 3");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 OverrunIntTest(Channel_3, AACI_RSIZE12 | AACI_FEN);
 C("END OF Rx OVERRUN INTERRUPT TEST FOR CHANNEL 3");

 C("Rx OVERRUN INTERRUPT TEST FOR CHANNEL 4 IN CHARACTER MODE");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 OverrunIntTest(Channel_4, AACI_RSIZE20);
 C("END OF Rx OVERRUN INTERRUPT TEST FOR CHANNEL 4");
}

/**********************************************************************/
/*********************** Overrun Interrupt Test ***********************/
/**********************************************************************/
void OverrunIntTest(int ChannelNo, int32 ChModeSizeFen)
{
 /*
   Summary : OverrunIntTest
   ========================
   This section of the code tests the AACIORINTRn [n = 1 to 4] Interrupt
   generation logic.

   - The RxFIFO of the AACI is enabled and the ORIE bit is set
     in the AACIIEn [n = 1 to 4] Register. 
   - The TxFIFO in the Trickbox is filled with data for two frames. 
   - The AACIRXCRn [n = 1 to 4] register is programmed for 8 valid 
     slots.
   - The trickbox is allowed to transmit the first frame. The Rx FIFO 
     in the AACI is expected to be filled with 8 words of data. The Rx 
     Overrun interrupt should not asserted. This is confirmed by 
     reading the AACITrIntrReg register in the trickbox and the AACIISR,
     AACISR and AACIALLINTS registers in the AACI. 
   - The second frame from the trickbox is then allowed to be 
     transmitted. The data written into the Tx FIFO of the trickbox is 
     such that the Slot0 of the AACI's received frame indicates valid 
     data for one slot. When the Rx FIFO is written with the 9th data 
     word, the Rx Overrun interrupt should be asserted. This is 
     confirmed by reading the AACITrIntrReg register in trickbox and 
     the AACISR, AACIISR and the AACIALLINTS registers in the AACI. 
   - The second frame is allowed to complete. 
   - Writing into RXOEC bit of the AACIINTCLR register of the AACI 
     should clear the Interrupt. This is confirmed by reading the
     AACITrIntrReg register and the AACISR, AACIISR, AACIALLINTS
     registers.

   This test is repeated after the interrupt is masked to ensure
   that this interrupt does not get set when masked. After the 
   interrupting condition has been created, the Interrupt enable bit is
   set and it is then verified that the interrupt is asserted. This test
   is done for all the channels.

   This test is also repeated with the channels programmed for Character
   mode reception.

 */

 int32 ChValidSlot, FEN, Mode, ChModeSize;
 int One_BitClk_Period  = AACIBITCLK_PERIOD / PCLK_PERIOD;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 /* Extract control information from function arguments */
 FEN        = ChModeSizeFen & AACI_FEN;
 Mode       = ChModeSizeFen & MASK_MODE;
 ChModeSize = ChModeSizeFen & (MASK_MODE || MASK_RSIZE);

 /* Calculate the slot numbers for which the test will be done */
 if (FEN == AACI_FEN) 
   ChValidSlot = AACI_RX11 | AACI_RX12 | AACI_RX3 | AACI_RX4 |
                  AACI_RX5 | AACI_RX6 | AACI_RX7 | AACI_RX8;
 else
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_RX11 | AACI_RX12;
    else
      ChValidSlot = AACI_RX11;
   }

 /* Configure the AACIRXCRn [n = 1 to 4] registers */
 if (ChannelNo == Channel_1)
   {
    ConfigRxCR(Channel_1, ChValidSlot | ChModeSize | FEN);
    ConfigRxCR(Channel_2, 0x0);
    ConfigRxCR(Channel_3, 0x0);
    ConfigRxCR(Channel_4, 0x0);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       ConfigRxCR(Channel_2, ChValidSlot | ChModeSize | FEN);
       ConfigRxCR(Channel_1, 0x0);
       ConfigRxCR(Channel_3, 0x0);
       ConfigRxCR(Channel_4, 0x0);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          ConfigRxCR(Channel_3, ChValidSlot | ChModeSize | FEN);
          ConfigRxCR(Channel_1, 0x0);
          ConfigRxCR(Channel_2, 0x0);
          ConfigRxCR(Channel_4, 0x0);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             ConfigRxCR(Channel_4, ChValidSlot | ChModeSize | FEN);
             ConfigRxCR(Channel_1, 0x0);
             ConfigRxCR(Channel_2, 0x0);
             ConfigRxCR(Channel_3, 0x0);
            }
         }
      }
   }

 /* Enable AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);

 /* Enable AACIORINTRn [n = 1 to 4] Interrupt */
 if (ChannelNo == Channel_1)
   PSW(AACI_ORIE, AACIIE1);
 else
   {
    if (ChannelNo == Channel_2)
      PSW(AACI_ORIE, AACIIE2);
    else
      {
       if (ChannelNo == Channel_3)
         PSW(AACI_ORIE, AACIIE3);
       else
         {
          if (ChannelNo == Channel_4)
            PSW(AACI_ORIE, AACIIE4);
         }
      }
   }

 /* Fill Trickbox */
 FrameWrite(ChannelNo, ChValidSlot, ChModeSize);/* 1st Frame */

 /* Enable AACI Reception */
 ConfigRxCR(ChannelNo, ChValidSlot | ChModeSize | FEN | AACI_REN);

 /* Writing data for the next frame in to the trickbox transmit FIFO */
 if (Mode == AACI_CM)
   ChValidSlot = AACI_RX11 | AACI_RX12;
 else
   ChValidSlot = AACI_RX11;
 FrameWrite(ChannelNo, ChValidSlot, ChModeSize); /*2nd Frame */

 /* Enable TrickBox TxFIFO for Transmission */
 PSW(AACITB_En | AACITB_TxEn | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Polling for completion of the second frame */
 PO(0x00000000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);
 PI(4);

 /* Verify that the AACIORINTRn [n = 1 to 4] interrupt is set */
 if (ChannelNo == Channel_1)
   { 
    PSR(AACI_RXOE, AACI_RXOE, AACISR1,AACI1_T224);
    PSR(AACI_ORIS, AACI_ORIS, AACIISR1,AACI1_T225);
    PSR(AACI_ORIS1, AACI_ORIS1, AACIALLINTS,AACI1_T226);
    PSR(AACIORINTR1, AACIORINTR1, AACITrIntr1Reg,AACI1_T227);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_RXOE, AACI_RXOE, AACISR2,AACI1_T228);
       PSR(AACI_ORIS, AACI_ORIS, AACIISR2,AACI1_T229);
       PSR(AACI_ORIS2, AACI_ORIS2, AACIALLINTS,AACI1_T230);
       PSR(AACIORINTR2, AACIORINTR2, AACITrIntr1Reg,AACI1_T231);
       PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead);
      }
   else
     {
      if (ChannelNo == Channel_3)
        {
         PSR(AACI_RXOE, AACI_RXOE, AACISR3,AACI1_T232);
         PSR(AACI_ORIS, AACI_ORIS, AACIISR3,AACI1_T233);
         PSR(AACI_ORIS3, AACI_ORIS3, AACIALLINTS,AACI1_T234);
         PSR(AACIORINTR3, AACIORINTR3, AACITrIntr1Reg,AACI1_T235);
         PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead);
        }
      else
        {
         if (ChannelNo == Channel_4)
           {
            PSR(AACI_RXOE, AACI_RXOE, AACISR4,AACI1_T236);
            PSR(AACI_ORIS, AACI_ORIS, AACIISR4,AACI1_T237);
            PSR(AACI_ORIS4, AACI_ORIS4, AACIALLINTS,AACI1_T238);
            PSR(AACIORINTR4, AACIORINTR4, AACITrIntr1Reg,AACI1_T239);
            PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead);
           }
        }
     }
   }

 /* Disable the trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Clearing the interrupt */
 if (ChannelNo == Channel_1)
   PSW(AACI_RXOEC1, AACIINTCLR);
 else
   {
    if (ChannelNo == Channel_2)
      PSW(AACI_RXOEC2, AACIINTCLR);
    else
      {
       if (ChannelNo == Channel_3)
         PSW(AACI_RXOEC3, AACIINTCLR);
       else
         {
          if (ChannelNo == Channel_4)
            PSW(AACI_RXOEC4, AACIINTCLR);
         }
      }
   }

 /* Verify that the AACIORINTRn [n = 1 to 4] interrupt is cleared */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_RXOE, AACISR1,AACI1_T224ORClr);
    PSR(0x0, AACI_ORIS, AACIISR1,AACI1_T225ORClr);
    PSR(0x0, AACI_ORIS1, AACIALLINTS,AACI1_T226ORClr);
    PSR(0x0, AACIORINTR1, AACITrIntr1Reg,AACI1_T227ORClr);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrReadORClr);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(0x0, AACI_RXOE, AACISR2,AACI1_T228ORClr);
       PSR(0x0, AACI_ORIS, AACIISR2,AACI1_T229ORClr);
       PSR(0x0, AACI_ORIS2, AACIALLINTS,AACI1_T230ORClr);
       PSR(0x0, AACIORINTR2, AACITrIntr1Reg,AACI1_T231ORClr);
       PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrReadORClr);
      }
   else
     {
      if (ChannelNo == Channel_3)
        {
         PSR(0x0, AACI_RXOE, AACISR3,AACI1_T232ORClr);
         PSR(0x0, AACI_ORIS, AACIISR3,AACI1_T233ORClr);
         PSR(0x0, AACI_ORIS3, AACIALLINTS,AACI1_T234ORClr);
         PSR(0x0, AACIORINTR3, AACITrIntr1Reg,AACI1_T235ORClr);
         PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrReadORClr);
        }
      else
        {
         if (ChannelNo == Channel_4)
           {
            PSR(0x0, AACI_RXOE, AACISR4,AACI1_T236ORClr);
            PSR(0x0, AACI_ORIS, AACIISR4,AACI1_T237ORClr);
            PSR(0x0, AACI_ORIS4, AACIALLINTS,AACI1_T238ORClr);
            PSR(0x0, AACIORINTR4, AACITrIntr1Reg,AACI1_T239ORClr);
            PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrReadORClr);
           }
        }
     }
   }

 /* Disable AACI */
 PSW(0x0, AACIMAINCR);

 /* Repeat the test with the AACIORINTRn [n = 1 to 4] interrupt 
    masked. Verify that the interrupt is not set when masked */

 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Calculate the slot numbers for which the read is to be done */
 if (FEN == AACI_FEN)
   ChValidSlot = AACI_RX11 | AACI_RX9 | AACI_RX3 | AACI_RX4 |
                  AACI_RX5 | AACI_RX6 | AACI_RX7 | AACI_RX8;
 else
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_RX3 | AACI_RX5;
    else
      ChValidSlot = AACI_RX3;
   }

 /* Configure the AACIRXCRn [n = 1 to 4] registers */
 ConfigRxCR(ChannelNo, ChValidSlot | ChModeSize | FEN);

 /* Mask AACIORINTRn [n = 1 to 4] interrupt */
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

 /* Enable AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);

 /* Fill Trickbox */
 FrameWrite(ChannelNo, ChValidSlot, ChModeSize);/* 1st Frame */

 /* Enable AACI RxFIFO for Receive */
 ConfigRxCR(ChannelNo, ChValidSlot | ChModeSize | FEN | AACI_REN);

 /* Writing data for the next frame in to the trickbox transmit FIFO */
 if (Mode == AACI_CM)
   ChValidSlot = AACI_RX3 | AACI_RX5;
 else
   ChValidSlot = AACI_RX3;
 FrameWrite(ChannelNo, ChValidSlot, ChModeSize); /*2nd Frame */

 /* Enable TrickBox TxFIFO for Transmission */
 PSW(AACITB_En | AACITB_TxEn | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Polling for completion of the second frame */
 PO(0x00000000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Verify that AACIORINTRn [n = 1 to 4] interrupt is clear but raw
    interrupt set */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_RXOE, AACI_RXOE, AACISR1,AACI1_T256);
    PSR(0x0, AACI_ORIS, AACIISR1,AACI1_T257);
    PSR(0x0, AACI_ORIS1, AACIALLINTS,AACI1_T258);
    PSR(0x0, AACIORINTR1, AACITrIntr1Reg,AACI1_T259);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_RXOE, AACI_RXOE, AACISR2,AACI1_T260);
       PSR(0x0, AACI_ORIS, AACIISR2,AACI1_T261);
       PSR(0x0, AACI_ORIS2, AACIALLINTS,AACI1_T262);
       PSR(0x0, AACIORINTR2, AACITrIntr1Reg,AACI1_T263);
       PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(AACI_RXOE, AACI_RXOE, AACISR3,AACI1_T264);
          PSR(0x0, AACI_ORIS, AACIISR3,AACI1_T265);
          PSR(0x0, AACI_ORIS3, AACIALLINTS,AACI1_T266);
          PSR(0x0, AACIORINTR3, AACITrIntr1Reg,AACI1_T267);
          PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(AACI_RXOE, AACI_RXOE, AACISR4,AACI1_T268);
             PSR(0x0, AACI_ORIS, AACIISR4,AACI1_T269);
             PSR(0x0, AACI_ORIS4, AACIALLINTS,AACI1_T270);
             PSR(0x0, AACIORINTR4, AACITrIntr1Reg,AACI1_T271);
             PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead);
            }
         }
      }
   }

 /* Unmask AACIORINTRn [n = 1 to 4] interrupt */
 if (ChannelNo == Channel_1)
   PSW(AACI_ORIE, AACIIE1);
 else
   {
    if (ChannelNo == Channel_2)
      PSW(AACI_ORIE, AACIIE2);
    else
      {
       if (ChannelNo == Channel_3)
          PSW(AACI_ORIE, AACIIE3);
       else
         {
          if (ChannelNo == Channel_4)
            PSW(AACI_ORIE, AACIIE4);
         }
      }
   }

 /* Verify that AACIORINTRn [n = 1 to 4] interrupt is set */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_RXOE, AACI_RXOE, AACISR1,AACI1_T272);
    PSR(AACI_ORIS, AACI_ORIS, AACIISR1,AACI1_T273);
    PSR(AACI_ORIS1, AACI_ORIS1, AACIALLINTS,AACI1_T274);
    PSR(AACIORINTR1, AACIORINTR1, AACITrIntr1Reg,AACI1_T275);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_RXOE, AACI_RXOE, AACISR2,AACI1_T276);
       PSR(AACI_ORIS, AACI_ORIS, AACIISR2,AACI1_T277);
       PSR(AACI_ORIS2, AACI_ORIS2, AACIALLINTS,AACI1_T278);
       PSR(AACIORINTR2, AACIORINTR2, AACITrIntr1Reg,AACI1_T279);
       PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(AACI_RXOE, AACI_RXOE, AACISR3,AACI1_T280);
          PSR(AACI_ORIS, AACI_ORIS, AACIISR3,AACI1_T281);
          PSR(AACI_ORIS3, AACI_ORIS3, AACIALLINTS,AACI1_T282);
          PSR(AACIORINTR3, AACIORINTR3, AACITrIntr1Reg,AACI1_T283);
          PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(AACI_RXOE, AACI_RXOE, AACISR4,AACI1_T284);
             PSR(AACI_ORIS, AACI_ORIS, AACIISR4,AACI1_T285);
             PSR(AACI_ORIS4, AACI_ORIS4, AACIALLINTS,AACI1_T286);
             PSR(AACIORINTR4, AACIORINTR4, AACITrIntr1Reg,AACI1_T287);
             PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead);
            }
         }
      }
   }

 /* Disable Trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Disable AACI */
 PSW(0x0, AACIMAINCR);
 PI(0x2);

 /* Verify that AACIORINTRn [n = 1 to 4] interrupt is cleared */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_RXOE, AACISR1,AACI1_T272_DisTst);
    PSR(0x0, AACI_ORIS, AACIISR1,AACI1_T273_DisTst);
    PSR(0x0, AACI_ORIS1, AACIALLINTS,AACI1_T274_DisTst);
    PSR(0x0, AACIORINTR1, AACITrIntr1Reg,AACI1_T275_DisTst);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead_DisTst);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(0x0, AACI_RXOE, AACISR2,AACI1_T276_DisTst);
       PSR(0x0, AACI_ORIS, AACIISR2,AACI1_T277_DisTst);
       PSR(0x0, AACI_ORIS2, AACIALLINTS,AACI1_T278_DisTst);
       PSR(0x0, AACIORINTR2, AACITrIntr1Reg,AACI1_T279_DisTst);
       PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead_DisTst);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(0x0, AACI_RXOE, AACISR3,AACI1_T280_DisTst);
          PSR(0x0, AACI_ORIS, AACIISR3,AACI1_T281_DisTst);
          PSR(0x0, AACI_ORIS3, AACIALLINTS,AACI1_T282_DisTst);
          PSR(0x0, AACIORINTR3, AACITrIntr1Reg,AACI1_T283_DisTst);
          PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead_DisTst);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(0x0, AACI_RXOE, AACISR4,AACI1_T284_DisTst);
             PSR(0x0, AACI_ORIS, AACIISR4,AACI1_T285_DisTst);
             PSR(0x0, AACI_ORIS4, AACIALLINTS,AACI1_T286_DisTst);
             PSR(0x0, AACIORINTR4, AACITrIntr1Reg,AACI1_T287_DisTst);
             PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_DisTst);
            }
         }
      }
   }

 /* Enable AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);
 PI(0x2);

 /* Verify that AACIORINTRn [n = 1 to 4] interrupt is still cleared */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_RXOE, AACISR1,AACI1_T272_DisTst2);
    PSR(0x0, AACI_ORIS, AACIISR1,AACI1_T273_DisTst2);
    PSR(0x0, AACI_ORIS1, AACIALLINTS,AACI1_T274_DisTst2);
    PSR(0x0, AACIORINTR1, AACITrIntr1Reg,AACI1_T275_DisTst2);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_DisTst2);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(0x0, AACI_RXOE, AACISR2,AACI1_T276_DisTst2);
       PSR(0x0, AACI_ORIS, AACIISR2,AACI1_T277_DisTst2);
       PSR(0x0, AACI_ORIS2, AACIALLINTS,AACI1_T278_DisTst2);
       PSR(0x0, AACIORINTR2, AACITrIntr1Reg,AACI1_T279_DisTst2);
       PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_OR_IntrRead_DisTst2);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(0x0, AACI_RXOE, AACISR3,AACI1_T280_DisTst2);
          PSR(0x0, AACI_ORIS, AACIISR3,AACI1_T281_DisTst2);
          PSR(0x0, AACI_ORIS3, AACIALLINTS,AACI1_T282_DisTst2);
          PSR(0x0, AACIORINTR3, AACITrIntr1Reg,AACI1_T283_DisTst2);
          PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_DisTst2);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(0x0, AACI_RXOE, AACISR4,AACI1_T284_DisTst2);
             PSR(0x0, AACI_ORIS, AACIISR4,AACI1_T285_DisTst2);
             PSR(0x0, AACI_ORIS4, AACIALLINTS,AACI1_T286_DisTst2);
             PSR(0x0, AACIORINTR4, AACITrIntr1Reg,AACI1_T287_DisTst2);
             PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_DisTst2);
            }
         }
      }
   }

 /* Disable all the interrupts */
 PSW(0x0, AACIIE1);
 PSW(0x0, AACIIE2);
 PSW(0x0, AACIIE3);
 PSW(0x0, AACIIE4);

 /* Disable AACI */
 PSW(0x0, AACIMAINCR);
}

/*********************** End of AACIORINTRTests.c **********************/
