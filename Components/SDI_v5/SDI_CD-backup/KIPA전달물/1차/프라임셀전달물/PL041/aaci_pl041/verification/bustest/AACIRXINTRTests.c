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
-- File Name              : AACIRXINTRTests.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This section of the code tests the AACIRXINTRn [n = 1 to 4]
--           Interrupt generation logic.
--
-- --=================================================================*/

/**********************************************************************/
/*********************** Function Declarations ************************/
/**********************************************************************/
void RxIntTest(int ChannelNo, int32 ChModeSizeFen);

/**********************************************************************/
/********************* Receive interrupt test *************************/
/**********************************************************************/
void AACIRXINTRTests(void)
{
 /*
   Summary : AACIRXINTRTests
   =========================
   This section of the code tests the AACIRXINTRn [n = 1 to 4] Interrupt
   generation logic. This function calls the RxIntTest() function
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

 C("Rx INTERRUPT TEST FOR CHANNEL 1");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 RxIntTest(Channel_1, AACI_CM | AACI_RSIZE12 | AACI_FEN);
 C("END OF Rx INTERRUPT TEST FOR CHANNEL 1");

 C("Rx INTERRUPT TEST FOR CHANNEL 1 IN CHARACTER MODE");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 RxIntTest(Channel_1, AACI_RSIZE20);
 C("END OF Rx INTERRUPT TEST FOR CHANNEL 1 IN CHARACTER MODE");

 C("Rx INTERRUPT TEST FOR CHANNEL 2 IN FIFO MODE");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 RxIntTest(Channel_2, AACI_CM | AACI_RSIZE12 | AACI_FEN);
 C("END OF Rx INTERRUPT TEST FOR CHANNEL 2 IN FIFO MODE");

 C("Rx INTERRUPT TEST FOR CHANNEL 3 IN CHARACTER MODE");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 RxIntTest(Channel_3, AACI_RSIZE12);
 C("END OF Rx INTERRUPT TEST FOR CHANNEL 3 IN CHARACTER MODE");

 C("Rx INTERRUPT TEST FOR CHANNEL 4");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 RxIntTest(Channel_4, AACI_RSIZE12 | AACI_FEN);
 C("END OF Rx INTERRUPT TEST FOR CHANNEL 4");
}
/**********************************************************************/
/********************* Receive interrupt test *************************/
/**********************************************************************/
void RxIntTest(int ChannelNo, int32 ChModeSizeFen)
{
 /*
   Summary : RxIntTest
   ===================
   This section of the code tests the AACIRXINTRn [n = 1 to 4] interrupt
   generation logic. The test sequence is as follows :
   - The RIE bit in the AACIIEn [n = 1 to 4] Register is enabled.
   - The TxFIFO in the Trickbox is filled with data for one full frame 
     in which data for only four slots are valid.
   - The AACIRXCRn [n = 1 to 4] register is programmed to receive four
     valid slots.
   - Then, the data transfer is allowed to happen for the first frame
     AACI RxFIFO would have been filled with 4 data, AACIRXINTRn 
     [n = 1 to 4] is expected to be set. This is verified by reading the
     AACITrIntrReg register and the AACIISR and AACIALLINTS registers.
   - Reading one Data from RxFIFO of AACI should clear the interrupt.
     This is confirmed by reading the AACITrIntReg of the trickbox and
     the AACIISR , AACIALLINTS registers.

   This test is repeated by masking the interrupt, to verify that this
   interrupt is not set when masked and this interrupt is expected to 
   be set when it is unmasked when interrupting condition had occured.
   This test is repeated for character mode of the FIFO and for all
   the channels.

 */
 int32 ChValidSlot, FEN, Mode, ChModeSize;
 int One_BitClk_Period  = AACIBITCLK_PERIOD / PCLK_PERIOD;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 /* Extract control information from function arguments */
 FEN        = ChModeSizeFen & AACI_FEN;
 Mode       = ChModeSizeFen & MASK_MODE;
 ChModeSize = ChModeSizeFen & (MASK_MODE | MASK_RSIZE);

 /* Calculate the slot numbers for which the test will be done */
 if (FEN == AACI_FEN)
   {
    ChValidSlot = AACI_RX5 | AACI_RX7 | AACI_RX8 | AACI_RX9;
   }
 else
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_RX5 | AACI_RX7;
    else
      ChValidSlot = AACI_RX5;
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
 
 /* Enable AACIRXINTRn [n = 1 to 4] Interrupt */
 if (ChannelNo == Channel_1)
   PSW(AACI_RIE, AACIIE1);
 else
   {
    if (ChannelNo == Channel_2)
      PSW(AACI_RIE, AACIIE2);
    else
      {
       if (ChannelNo == Channel_3)
         PSW(AACI_RIE, AACIIE3);
       else
         {
          if (ChannelNo == Channel_4)
            PSW(AACI_RIE, AACIIE4);
         }
      }
   }

 /* Enable AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);

 /* Fill Trickbox */
 FrameWrite(ChannelNo, ChValidSlot, ChModeSize);/* 1st Frame */

 /* Enable AACI RxFIFO for reception */
 ConfigRxCR(ChannelNo, ChValidSlot | ChModeSize | FEN | AACI_REN);

 /* Enable TrickBox TxFIFO for Transmission */
 PSW(AACITB_En | AACITB_TxEn | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Polling for completion of the frame */
 PO(0x00000000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Verify that the AACIRXINTRn [n = 1 to 4] interrupt is set */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_RIS, AACI_RIS, AACIISR1,AACI1_T288);
    PSR(AACI_RIS1, AACI_RIS1, AACIALLINTS,AACI1_T289);
    PSR(AACIRXINTR1, AACIRXINTR1, AACITrIntr1Reg,AACI1_T290);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_RIS, AACI_RIS, AACIISR2,AACI1_T291);
       PSR(AACI_RIS2, AACI_RIS2, AACIALLINTS,AACI1_T292);
       PSR(AACIRXINTR2, AACIRXINTR2, AACITrIntr1Reg,AACI1_T293);
       PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(AACI_RIS, AACI_RIS, AACIISR3,AACI1_T294);
          PSR(AACI_RIS3, AACI_RIS3, AACIALLINTS,AACI1_T295);
          PSR(AACIRXINTR3, AACIRXINTR3, AACITrIntr1Reg,AACI1_T296);
          PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(AACI_RIS, AACI_RIS, AACIISR4,AACI1_T297);
             PSR(AACI_RIS4, AACI_RIS4, AACIALLINTS,AACI1_T298);
             PSR(AACIRXINTR4, AACIRXINTR4, AACITrIntr1Reg,AACI1_T299);
             PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
            }
          }
      }
  }
  
 /* Read AACI Rx FIFO */
 RxFIFORd(ChannelNo, ChValidSlot, ChModeSize | FEN);
 
 /* Verify that the AACIRXINTRn [n = 1 to 4] interrupt is cleared */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_RIS, AACIISR1,AACI1_T300);
    PSR(0x0, AACI_RIS1, AACIALLINTS,AACI1_T301);
    PSR(0x0, AACIRXINTR1, AACITrIntr1Reg,AACI1_T302);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(0x0, AACI_RIS, AACIISR2,AACI1_T303);
       PSR(0x0, AACI_RIS2, AACIALLINTS,AACI1_T304);
       PSR(0x0, AACIRXINTR2, AACITrIntr1Reg,AACI1_T305);
       PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(0x0, AACI_RIS, AACIISR3,AACI1_T306);
          PSR(0x0, AACI_RIS3, AACIALLINTS,AACI1_T307);
          PSR(0x0, AACIRXINTR3, AACITrIntr1Reg,AACI1_T308);
          PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(0x0, AACI_RIS, AACIISR4,AACI1_T309);
             PSR(0x0, AACI_RIS4, AACIALLINTS,AACI1_T310);
             PSR(0x0, AACIRXINTR4, AACITrIntr1Reg,AACI1_T311);
             PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
            }
         }
      }
   }

 /* Disable Trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Disable AACI */
 PSW(0x0, AACIMAINCR);

 /* Test with interrupt masked to verify that the interrupt is not
    asserted when it is masked even if the interrupting condition has
    come . */

 /* Enable AACIBITCLK */
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Mask AACIRXINTR [n = 1 to 4] interrupt */
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
 
 /* Writing extra data for the next frame */
 if (FEN == AACI_FEN)  
   {
    ChValidSlot = AACI_RX5 | AACI_RX7 | AACI_RX8 | AACI_RX9;
   }
 else
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_RX5 | AACI_RX7;
    else
      ChValidSlot = AACI_RX5;
   }

 /* Configure the AACIRXCRn [n = 1 to 4] registers */
 ConfigRxCR(ChannelNo, ChValidSlot | ChModeSize | FEN);

 /* Fill Trickbox */
 FrameWrite(ChannelNo, ChValidSlot, ChModeSize);/* 1st Frame */

 /* Enable AACI RxFIFO for Reception */
 ConfigRxCR(ChannelNo, ChValidSlot | ChModeSize | FEN | AACI_REN);

 /* Enable AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);

 /* Enable TrickBox TxFIFO for Transmission */
 PSW(AACITB_En | AACITB_TxEn | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Polling for the frame to complete */
 PO(0x00000000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Verify that the AACIRXINTRn [n = 1 to 4] interrupt is not set */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_RIS, AACIISR1,AACI1_T312);
    PSR(0x0, AACI_RIS1, AACIALLINTS,AACI1_T313);
    PSR(0x0, AACIRXINTR1, AACITrIntr1Reg,AACI1_T314);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(0x0, AACI_RIS, AACIISR2,AACI1_T315);
       PSR(0x0, AACI_RIS2, AACIALLINTS,AACI1_T316);
       PSR(0x0, AACIRXINTR2, AACITrIntr1Reg,AACI1_T317);
       PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(0x0, AACI_RIS, AACIISR3,AACI1_T318);
          PSR(0x0, AACI_RIS3, AACIALLINTS,AACI1_T319);
          PSR(0x0, AACIRXINTR3, AACITrIntr1Reg,AACI1_T320);
          PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(0x0, AACI_RIS, AACIISR4,AACI1_T321);
             PSR(0x0, AACI_RIS4, AACIALLINTS,AACI1_T322);
             PSR(0x0, AACIRXINTR4, AACITrIntr1Reg,AACI1_T323);
             PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
            }
         }
      }
   }

 /* Unmask the interrupt */
 if (ChannelNo == Channel_1)
   PSW(AACI_RIE, AACIIE1);
 else
   {
    if (ChannelNo == Channel_2)
      PSW(AACI_RIE, AACIIE2);
    else
      {
       if (ChannelNo == Channel_3)
         PSW(AACI_RIE, AACIIE3);
       else
         {
          if (ChannelNo == Channel_4)
            PSW(AACI_RIE, AACIIE4);
         }
      }
   }

 /* Verify that the AACIRXINTRn [n = 1 to 4] interrupt is set */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_RIS, AACI_RIS, AACIISR1,AACI1_T324);
    PSR(AACI_RIS1, AACI_RIS1, AACIALLINTS,AACI1_T325);
    PSR(AACIRXINTR1, AACIRXINTR1, AACITrIntr1Reg,AACI1_T326);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_RIS, AACI_RIS, AACIISR2,AACI1_T327);
       PSR(AACI_RIS2, AACI_RIS2, AACIALLINTS,AACI1_T328);
       PSR(AACIRXINTR2, AACIRXINTR2, AACITrIntr1Reg,AACI1_T329);
       PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(AACI_RIS, AACI_RIS, AACIISR3,AACI1_T330);
          PSR(AACI_RIS3, AACI_RIS3, AACIALLINTS,AACI1_T331);
          PSR(AACIRXINTR3, AACIRXINTR3, AACITrIntr1Reg,AACI1_T332);
          PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(AACI_RIS, AACI_RIS, AACIISR4,AACI1_T333);
             PSR(AACI_RIS4, AACI_RIS4, AACIALLINTS,AACI1_T334);
             PSR(AACIRXINTR4, AACIRXINTR4, AACITrIntr1Reg,AACI1_T335);
             PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
            }
         }
      }
   }

 /* Read AACI Rx FIFO */
 RxFIFORd(ChannelNo, ChValidSlot, ChModeSize | FEN);

 /* Disable Trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Disable AACI */
 PSW(0x0, AACIMAINCR);

 /* Test to verify that the AACIRXINTRn [n = 1 to 4] is getting cleared
    when the AACIFE bit in the AACIMAINCR is cleared.
 */

 /* Enabling AACIBITCLK */
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Writing the data for the next frame in the trickbox */
 if (FEN == AACI_FEN)  
   {
    ChValidSlot = AACI_RX5 | AACI_RX7 | AACI_RX8 | AACI_RX9;
   }
 else
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_RX5 | AACI_RX7;
    else
      ChValidSlot = AACI_RX5;
   }

 /* Configure the AACIRXCRn [n = 1 to 4] registers */
 ConfigRxCR(ChannelNo, ChValidSlot | ChModeSize | FEN);

 /* Fill Trickbox */
 FrameWrite(ChannelNo, ChValidSlot, ChModeSize);/* 1st Frame */

 /* Enable AACI RxFIFO for Reception */
 ConfigRxCR(ChannelNo, ChValidSlot | ChModeSize | FEN | AACI_REN);

 /* Enable AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);

 /* Enable TrickBox TxFIFO for Transmission */
 PSW(AACITB_En | AACITB_TxEn | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Polling for the completion of the frame */
 PO(0x00000000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Verify that the AACIRXINTRn [n = 1 to 4] interrupt is set */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_RIS, AACI_RIS, AACIISR1,AACI1_T324);
    PSR(AACI_RIS1, AACI_RIS1, AACIALLINTS,AACI1_T325);
    PSR(AACIRXINTR1, AACIRXINTR1, AACITrIntr1Reg,AACI1_T326);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_RIS, AACI_RIS, AACIISR2,AACI1_T327);
       PSR(AACI_RIS2, AACI_RIS2, AACIALLINTS,AACI1_T328);
       PSR(AACIRXINTR2, AACIRXINTR2, AACITrIntr1Reg,AACI1_T329);
       PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(AACI_RIS, AACI_RIS, AACIISR3,AACI1_T330);
          PSR(AACI_RIS3, AACI_RIS3, AACIALLINTS,AACI1_T331);
          PSR(AACIRXINTR3, AACIRXINTR3, AACITrIntr1Reg,AACI1_T332);
          PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(AACI_RIS, AACI_RIS, AACIISR4,AACI1_T333);
             PSR(AACI_RIS4, AACI_RIS4, AACIALLINTS,AACI1_T334);
             PSR(AACIRXINTR4, AACIRXINTR4, AACITrIntr1Reg,AACI1_T335);
             PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,AACI1_RX_IntrRead);
            }
         }
      }
   }

 /* Disable AACI */
 PSW(0x0, AACIMAINCR);
 PI(0x2);

 /* Disable Trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Verify that the AACIRXINTRn [n = 1 to 4] interrupt is cleared */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_RIS, AACIISR1,AACI1_ch1dis1);
    PSR(0x0, AACI_RIS1, AACIALLINTS,AACI1_ch1dis1);
    PSR(0x0, AACIRXINTR1, AACITrIntr1Reg,AACI16_ch1dis1);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_ch1dis1);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(0x0, AACI_RIS, AACIISR2,AACI1_ch2dis1);
       PSR(0x0, AACI_RIS2, AACIALLINTS,AACI1_ch2dis1);
       PSR(0x0, AACIRXINTR2, AACITrIntr1Reg,AACI1_ch2dis1);
       PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_ch2dis1);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(0x0, AACI_RIS, AACIISR3,AACI1_ch3dis1);
          PSR(0x0, AACI_RIS3, AACIALLINTS,AACI1_ch3dis1);
          PSR(0x0, AACIRXINTR3, AACITrIntr1Reg,AACI1_ch3dis1);
          PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_ch3dis1);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(0x0, AACI_RIS, AACIISR4,AACI1_ch3dis1);
             PSR(0x0, AACI_RIS4, AACIALLINTS,AACI1_ch3dis1);
             PSR(0x0, AACIRXINTR4, AACITrIntr1Reg,AACI1_ch3dis1);
             PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_ch3dis1);
            }
         }
      }
   }

 /* Enable AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);
 PI(0x2);

 /* Verify that the AACIRXINTRn [n = 1 to 4] interrupt is not set */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_RIS, AACIISR1,AACI1_ch1dis2);
    PSR(0x0, AACI_RIS1, AACIALLINTS,AACI1_ch1dis2);
    PSR(0x0, AACIRXINTR1, AACITrIntr1Reg,AACI1_ch1dis2);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_ch1dis2);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(0x0, AACI_RIS, AACIISR2,AACI1_ch2dis2);
       PSR(0x0, AACI_RIS2, AACIALLINTS,AACI1_ch2dis2);
       PSR(0x0, AACIRXINTR2, AACITrIntr1Reg,AACI1_ch2dis2);
       PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_ch2dis2);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(0x0, AACI_RIS, AACIISR3,AACI1_ch3dis2);
          PSR(0x0, AACI_RIS3, AACIALLINTS,AACI1_ch3dis2);
          PSR(0x0, AACIRXINTR3, AACITrIntr1Reg,AACI1_ch3dis2);
          PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_RX_ch3dis2);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(0x0, AACI_RIS, AACIISR4,AACI1_ch3dis2);
             PSR(0x0, AACI_RIS4, AACIALLINTS,AACI1_ch3dis2);
             PSR(0x0, AACIRXINTR4, AACITrIntr1Reg,AACI1_ch3dis2);
             PSR(0x0, AACIINTR, AACITrIntr2Reg,AACI1_ch3dis2);
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

/*********************** End of AACIRXINTRTests.c *********************/
