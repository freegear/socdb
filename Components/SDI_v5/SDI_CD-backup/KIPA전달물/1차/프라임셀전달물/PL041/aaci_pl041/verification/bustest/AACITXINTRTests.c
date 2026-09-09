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
-- File Name              : AACITXINTRTests.c.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This section of the code tests the AACITXINTRn
--           [n = 1 to 4] Interrupt generation logic.
--
-- --=================================================================*/

/**********************************************************************/
/*********************** Function Declarations ************************/
/**********************************************************************/
void TxIntTest(int ChannelNo, int32 ChModeSizeFen);

/**********************************************************************/
/********************** AACITXINTR Interrupt Tests ********************/
/**********************************************************************/
void AACITXINTRTests(void)
{
 /*
   Summary : AACITXINTRTests
   =========================
   This section of the code tests the AACITXINTRn [n = 1 to 4] 
   Interrupt generation logic. This function calls the TxIntTest() 
   function multiple times, each time with a different set of arguments.
   Each function call tests a specific channel of the AACI.
 
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

 C("TRANSMIT INTERRUPT TESTS FOR CHANNEL 1");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 TxIntTest(Channel_1, AACI_CM | AACI_TSIZE12 | AACI_FEN);
 C("END OF TRANSMIT INTERRUPT TESTS FOR CHANNEL 1");

 C("TRANSMIT INTERRUPT TESTS FOR CHANNEL 1 IN CHARACTER MODE");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 TxIntTest(Channel_1, AACI_TSIZE16);
 C("END OF TRANSMIT INTERRUPT TESTS FOR CHANNEL 1 IN CHARACTER MODE");

 C("TRANSMIT INTERRUPT TESTS FOR CHANNEL 2");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 TxIntTest(Channel_2, AACI_TSIZE12 | AACI_FEN);
 C("END OF TRANSMIT INTERRUPT TESTS FOR CHANNEL 2");

 C("TRANSMIT INTERRUPT TESTS FOR CHANNEL 3");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 TxIntTest(Channel_3, AACI_CM | AACI_TSIZE16 | AACI_FEN);
 C("END OF TRANSMIT INTERRUPT TESTS FOR CHANNEL 3");

 C("TRANSMIT INTERRUPT TESTS FOR CHANNEL 4 IN CHARACTER MODE");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 TxIntTest(Channel_4, AACI_TSIZE16);
 C("END OF TRANSMIT INTERRUPT TESTS FOR CHANNEL 4 IN CHARACTER MODE");
}

/**********************************************************************/
/*********************** TX Interrupt Test ****************************/
/**********************************************************************/
void TxIntTest(int ChannelNo, int32 ChModeSizeFen)
{
 /*
   Summary : TxIntTest
   ===================
   This section of the code tests the AACITXINTRn [n = 1 to 4] Interrupt
   generation logic. The test sequence is as follows :

   - The TxFIFO of the AACI is enabled and TIE bit in the AACIIEn
     [n = 1 to 4] register is set. Initially, the Tx FIFO is empty and 
     hence the AACITXINTRn [n = 1 to 4] should be asserted. This is 
     verified by reading the AACITrIntrReg, AACIISR and AACIALLINTS 
     registers. 
   - Then the Tx FIFO of the AACI is loaded with four data and the 
     AACITXINTRn [n = 1 to 4] interrupt is checked. The interrupt is 
     expected to remain asserted.
   - One more data is written to the TxFIFO of the AACI. This should 
     clear the Interrupt. This is verified by reading the AACITrIntReg 
     of the trickbox and the AACIISR register.

    This test is repeated after clearing the TIE bit in the AACIIEn 
    [n = 1 to 4] register to ensure that the interrupt is not set when 
    masked. The interrupt is then unmasked and it is verified that the 
    interrupt is asserted. 

    This test is also repeated after disabling the Tx FIFO. This test 
    is done for all the channels. This test is also repeated with the 
    channels programmed for Character mode transmission.
 
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
   ChValidSlot = AACI_TX3 | AACI_TX6 | AACI_TX9 | AACI_TX12;
 else
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_TX3 | AACI_TX6;
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

 /* Enable AACITXINTRn [n = 1 to 4] Interrupt */
 if (ChannelNo == Channel_1)
    PSW(AACI_TIE, AACIIE1);
 else
   {
    if (ChannelNo == Channel_2)
       PSW(AACI_TIE, AACIIE2);
    else
      {
       if (ChannelNo == Channel_3)
          PSW(AACI_TIE, AACIIE3);
       else
         {
          if (ChannelNo == Channel_4)
            PSW(AACI_TIE, AACIIE4);
         }
      }
   }
 
 /* Verify that the AACITXINTRn [n = 1 to 4] interrupt is set */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_TIS, AACI_TIS, AACIISR1,AACI1_T408);
    PSR(AACI_TIS1, AACI_TIS1, AACIALLINTS,AACI1_T409);
    PSR(AACITXINTR1, AACITXINTR1, AACITrIntr1Reg,AACI1_T410);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_TIS, AACI_TIS, AACIISR2,AACI1_T411);
       PSR(AACI_TIS2, AACI_TIS2, AACIALLINTS,AACI1_T412);
       PSR(AACITXINTR2, AACITXINTR2, AACITrIntr1Reg,AACI1_T413);
       PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(AACI_TIS, AACI_TIS, AACIISR3,AACI1_T414);
          PSR(AACI_TIS3, AACI_TIS3, AACIALLINTS,AACI1_T415);
          PSR(AACITXINTR3, AACITXINTR3, AACITrIntr1Reg,AACI1_T416);
          PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(AACI_TIS, AACI_TIS, AACIISR4,AACI1_T417);
             PSR(AACI_TIS4, AACI_TIS4, AACIALLINTS,AACI1_T418);
             PSR(AACITXINTR4, AACITXINTR4, AACITrIntr1Reg,AACI1_T419);
             PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
            }
         }
      }
   }

 /* Fill AACI TX FIFO */
 TxFIFOFill(ChannelNo, ChValidSlot, ChModeSizeFen);

 /* Verify that the AACITXCINTRn [n = 1 to 4] interrupt is still set */
 if (FEN == AACI_FEN)
   {
    if (ChannelNo == Channel_1)
      {
       PSR(AACI_TIS, AACI_TIS, AACIISR1,AACI1_T420);
       PSR(AACI_TIS1, AACI_TIS1, AACIALLINTS,AACI1_T421);
       PSR(AACITXINTR1, AACITXINTR1, AACITrIntr1Reg,AACI1_T422);
       PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
      }
    else
      {
       if (ChannelNo == Channel_2)
         {
          PSR(AACI_TIS, AACI_TIS, AACIISR2,AACI1_T423);
          PSR(AACI_TIS2, AACI_TIS2, AACIALLINTS,AACI1_T424);
          PSR(AACITXINTR2, AACITXINTR2, AACITrIntr1Reg,AACI1_T425);
          PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
         }
       else
         {
          if (ChannelNo == Channel_3)
            {
             PSR(AACI_TIS, AACI_TIS, AACIISR3,AACI1_T426);
             PSR(AACI_TIS3, AACI_TIS3, AACIALLINTS,AACI1_T427);
             PSR(AACITXINTR3, AACITXINTR3, AACITrIntr1Reg,AACI1_T428);
             PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
            }
          else
            {
             if (ChannelNo == Channel_4)
               {
                PSR(AACI_TIS, AACI_TIS, AACIISR4,AACI1_T429);
                PSR(AACI_TIS4, AACI_TIS4, AACIALLINTS,AACI1_T430);
                PSR(AACITXINTR4, AACITXINTR4, AACITrIntr1Reg,AACI1_T431);
                PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
               }
            }
         }
      }
   }

 /* Write one more word into the AACI TxFIFO and verify that the
    AACITXINTRn [n = 1 to 4] interrupt is cleared */
 if (FEN == AACI_FEN)
   {
    if (Mode == AACI_CM)
      ChValidSlot = AACI_TX3 | AACI_TX6;
    else 
      ChValidSlot = AACI_TX3;

    TxFIFOFill(ChannelNo, ChValidSlot, ChModeSizeFen);
   }
 
 /* Verify that the AACITXCINTRn [n = 1 to 4] interrupt is cleared */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_TIS, AACIISR1,AACI1_T432);
    PSR(0x0, AACI_TIS1, AACIALLINTS,AACI1_T433);
    PSR(0x0, AACITXINTR1, AACITrIntr1Reg,AACI1_T434);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(0x0, AACI_TIS, AACIISR2,AACI1_T435);
       PSR(0x0, AACI_TIS2, AACIALLINTS,AACI1_T436);
       PSR(0x0, AACITXINTR2, AACITrIntr1Reg,AACI1_T437);
       PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(0x0, AACI_TIS, AACIISR3,AACI1_T438);
          PSR(0x0, AACI_TIS3, AACIALLINTS,AACI1_T439);
          PSR(0x0, AACITXINTR3, AACITrIntr1Reg,AACI1_T440);
          PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(0x0, AACI_TIS, AACIISR4,AACI1_T441);
             PSR(0x0, AACI_TIS4, AACIALLINTS,AACI1_T442);
             PSR(0x0, AACITXINTR4, AACITrIntr1Reg,AACI1_T443);
             PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
            }
         }
      }
   }  

 /* Disable AACI */
 PSW(0x0, AACIMAINCR);

 /* Disable trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Repeat the test with the AACITXINTRn [n = 1 to 4] Interrupt
    disabled */

 /* Disable the AACITXINTRn [n = 1 to 4] Interrupt */
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

 /* Configure the AACITXCRn [n = 1 to 4] registers */
 if (FEN == AACI_FEN)
   ChValidSlot = AACI_TX3 | AACI_TX6 | AACI_TX9 | AACI_TX12;
 else
   {
    /* In Charcter Mode */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_TX3 | AACI_TX6;
    else
      ChValidSlot = AACI_TX3;
   }
 ConfigTxCR(ChannelNo, ChValidSlot | ChModeSize | FEN);

 /* Enable AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);

 /* Verify that the AACITXINTRn [n = 1 to 4] interrupt is not set */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_TIS, AACIISR1,AACI1_T444);
    PSR(0x0, AACI_TIS1, AACIALLINTS,AACI1_T445);
    PSR(0x0, AACITXINTR1, AACITrIntr1Reg,AACI1_T446);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(0x0, AACI_TIS, AACIISR2,AACI1_T447);
       PSR(0x0, AACI_TIS2, AACIALLINTS,AACI1_T448);
       PSR(0x0, AACITXINTR2, AACITrIntr1Reg,AACI1_T449);
       PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(0x0, AACI_TIS, AACIISR3,AACI1_T450);
          PSR(0x0, AACI_TIS3, AACIALLINTS,AACI1_T451);
          PSR(0x0, AACITXINTR3, AACITrIntr1Reg,AACI1_T452);
          PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(0x0, AACI_TIS, AACIISR4,AACI1_T453);
             PSR(0x0, AACI_TIS4, AACIALLINTS,AACI1_T454);
             PSR(0x0, AACITXINTR4, AACITrIntr1Reg,AACI1_T455);
             PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
            }
         }
      }
   }

 /* Enable AACITXINTRn [n = 1 to 4] Interrupt */
 if (ChannelNo == Channel_1)
   PSW(AACI_TIE, AACIIE1);
 else
   {
    if (ChannelNo == Channel_2)
      PSW(AACI_TIE, AACIIE2);
    else
      {
       if (ChannelNo == Channel_3)
         PSW(AACI_TIE, AACIIE3);
       else
         {
          if (ChannelNo == Channel_4)
            PSW(AACI_TIE, AACIIE4);
         }
      }
   }

 /* Verify that the AACITXINTRn [n = 1 to 4] Interrupt is asserted */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_TIS, AACI_TIS, AACIISR1,AACI1_T468);
    PSR(AACI_TIS1, AACI_TIS1, AACIALLINTS,AACI1_T469);
    PSR(AACITXINTR1, AACITXINTR1, AACITrIntr1Reg,AACI1_T470);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_TIS, AACI_TIS, AACIISR2,AACI1_T471);
       PSR(AACI_TIS2, AACI_TIS2, AACIALLINTS,AACI1_T472);
       PSR(AACITXINTR2, AACITXINTR2, AACITrIntr1Reg,AACI1_T473);
       PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(AACI_TIS, AACI_TIS, AACIISR3,AACI1_T474);
          PSR(AACI_TIS3, AACI_TIS3, AACIALLINTS,AACI1_T475);
          PSR(AACITXINTR3, AACITXINTR3, AACITrIntr1Reg,AACI1_T476);
          PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(AACI_TIS, AACI_TIS, AACIISR4,AACI1_T477);
             PSR(AACI_TIS4, AACI_TIS4, AACIALLINTS,AACI1_T478);
             PSR(AACITXINTR4, AACITXINTR4, AACITrIntr1Reg,AACI1_T479);
             PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
            }
         }
      }
   }

 /* Disable trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Verify that the AACITXINTRn [n = 1 to 4] interrupt is cleared
    when the AACI is disabled */

 /* Disable AACI */
 PSW(0x0, AACIMAINCR);
 PI(One_BitClk_Period * 16);

 /* Calculate the slot numbers for which the test will be done */
 if (FEN == AACI_FEN)
   ChValidSlot = AACI_TX3 | AACI_TX6 | AACI_TX9 | AACI_TX12;
 else
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_TX3 | AACI_TX6;
    else
      ChValidSlot = AACI_TX3;
   }
 ConfigTxCR(ChannelNo, ChValidSlot | ChModeSize | FEN);

 /* Enable AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);

 /* Verify that the AACITXINTRn [n = 1 to 4] interrupt is set */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_TIS, AACI_TIS, AACIISR1,AACI1_T468);
    PSR(AACI_TIS1, AACI_TIS1, AACIALLINTS,AACI1_T469);
    PSR(AACITXINTR1, AACITXINTR1, AACITrIntr1Reg,AACI1_T470);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_TIS, AACI_TIS, AACIISR2,AACI1_T471);
       PSR(AACI_TIS2, AACI_TIS2, AACIALLINTS,AACI1_T472);
       PSR(AACITXINTR2, AACITXINTR2, AACITrIntr1Reg,AACI1_T473);
       PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(AACI_TIS, AACI_TIS, AACIISR3,AACI1_T474);
          PSR(AACI_TIS3, AACI_TIS3, AACIALLINTS,AACI1_T475);
          PSR(AACITXINTR3, AACITXINTR3, AACITrIntr1Reg,AACI1_T476);
          PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(AACI_TIS, AACI_TIS, AACIISR4,AACI1_T477);
             PSR(AACI_TIS4, AACI_TIS4, AACIALLINTS,AACI1_T478);
             PSR(AACITXINTR4, AACITXINTR4, AACITrIntr1Reg,AACI1_T479);
             PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
            }
         }
      }
   }

 /* Disable AACI */
 PSW(0x0, AACIMAINCR);
 PI(0x2);

 /* Verify that the AACITXCINTRn [n = 1 to 4] interrupt is cleared */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_TIS, AACIISR1,AACI1_distxint1);
    PSR(0x0, AACI_TIS1, AACIALLINTS,AACI1_distxint2);
    PSR(0x0, AACITXINTR1, AACITrIntr1Reg,AACI1_distxint3);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_distxint4);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(0x0, AACI_TIS, AACIISR2,AACI1_distxint5);
       PSR(0x0, AACI_TIS2, AACIALLINTS,AACI1_distxint6);
       PSR(0x0, AACITXINTR2, AACITrIntr1Reg,AACI1_distxint7);
       PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_distxint8);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(0x0, AACI_TIS, AACIISR3,AACI1_distxint9);
          PSR(0x0, AACI_TIS3, AACIALLINTS,AACI1_distxint10);
          PSR(0x0, AACITXINTR3, AACITrIntr1Reg,AACI1_distxint11);
          PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_distxint12);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(0x0, AACI_TIS, AACIISR4,AACI1_distxint13);
             PSR(0x0, AACI_TIS4, AACIALLINTS,AACI1_distxint14);
             PSR(0x0, AACITXINTR4, AACITrIntr1Reg,AACI1_distxint15);
             PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_distxint16);
            }
         }
      }
   }

 /* Disable all the interrupts */
 PSW(0x0, AACIIE1);
 PSW(0x0, AACIIE2);
 PSW(0x0, AACIIE3);
 PSW(0x0, AACIIE4);
}

/************************ End of AACITXINTRTests.c ********************/
