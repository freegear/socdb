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
-- File Name              : AACIRXTOFEINTRTests.c.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This section of the code tests the AACIRXTOFEINTRn 
--           [n = 1 to 4] Interrupt generation logic.
--
-- --=================================================================*/
 
/**********************************************************************/
/*********************** Function Declarations ************************/
/**********************************************************************/
void RxTOFEIntTest(int ChannelNo, int32 ChModeSizeFen, int32 TOC,
                  int DMAEN);

/**********************************************************************/
/********************** RXTOFE Interrupt Tests ************************/
/**********************************************************************/
void AACIRXTOFEINTRTests(void)
{
 /*
   Summary : AACIRXTOFEINTRTests
   =============================
   This section of the code tests the AACIRXTOFEINTRn [n = 1 to 4] 
   Interrupt generation logic. This function calls the RxTOFEIntTest() 
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

 /*
   For verifying that the TOFE interrupt generation logic for channels
   2,3 and 4 does not have any effect of the DMAEn bit in the
   AACIMAINCR register, the TOFE and TimeOut tests are done for these
   channels with DMAEn = 0 as well as DMAEn = 1 along with the
   channel 1.
 */

 C("Rx TOFE INTERRUPT TEST FOR CHANNEL 1 WITH DMAEn = 0");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 RxTOFEIntTest(Channel_1, AACI_CM | AACI_RSIZE16 | AACI_FEN, 0x4, DMADISABLE);
 C("END OF Rx TOFE  INTERRUPT TEST FOR CHANNEL 1");

 C("Rx TOFE INTERRUPT TEST FOR CH 1 IN CHARACTER MODE WITH DMAEn = 0");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 RxTOFEIntTest(Channel_1, AACI_RSIZE18 , 0x4, DMADISABLE);
 C("END OF Rx TOFE INTERRUPT TEST FOR CH 1 IN CHARACTER MODE");

 C("Rx TOFE INTERRUPT TEST FOR CHANNEL 2 WITH DMAEn = 0");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 RxTOFEIntTest(Channel_2, AACI_RSIZE18 | AACI_FEN, 0x4, DMADISABLE);
 C("END OF Rx TOFE  INTERRUPT TEST FOR CHANNEL 2");

 C("Rx TOFE INTERRUPT TEST FOR CHANNEL 3 WITH DMAEn = 0");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 RxTOFEIntTest(Channel_3, AACI_CM | AACI_RSIZE12 | AACI_FEN, 0x4, DMADISABLE);
 C("END OF Rx TOFE  INTERRUPT TEST FOR CHANNEL 3");

 C("Rx TOFE INTERRUPT TEST FOR CH 4 IN CHARACTER MODE WITH DMAEn = 0");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 RxTOFEIntTest(Channel_4, AACI_RSIZE16, 0x1, DMADISABLE);
 C("END OF Rx TOFE INTERRUPT TEST FOR CH 4 IN CHARACTER MODE");

 C("Rx TOFE INTERRUPT TEST FOR CHANNEL 1 WITH DMAEn = 1");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 RxTOFEIntTest(Channel_1, AACI_CM | AACI_RSIZE16 | AACI_FEN, 0x4, DMAENABLE);
 C("END OF Rx TOFE  INTERRUPT TEST FOR CHANNEL 1");

 C("Rx TOFE INTERRUPT TEST FOR CH 1 IN CHARACTER MODE WITH DMAEn = 1");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 RxTOFEIntTest(Channel_1, AACI_RSIZE18 , 0x4, DMAENABLE);
 C("END OF Rx TOFE  INTERRUPT TEST FOR CH 1 IN CHARACTER MODE");

 C("Rx TOFE INTERRUPT TEST FOR CHANNEL 2 WITH DMAEn = 1");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 RxTOFEIntTest(Channel_2, AACI_RSIZE18 | AACI_FEN, 0x4, DMAENABLE);
 C("END OF Rx TOFE  INTERRUPT TEST FOR CHANNEL 2");

 C("Rx TOFE INTERRUPT TEST FOR CHANNEL 3 WITH DMAEn = 1");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 RxTOFEIntTest(Channel_3, AACI_CM | AACI_RSIZE12 | AACI_FEN, 0x4, DMAENABLE);
 C("END OF Rx TOFE  INTERRUPT TEST FOR CHANNEL 3");

 C("Rx TOFE INTERRUPT TEST FOR CH 4 IN CHARACTER MODE WITH DMAEn = 1");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 RxTOFEIntTest(Channel_4, AACI_RSIZE16, 0x1, DMAENABLE);
 C("END OF Rx TOFE INTERRUPT TEST FOR CH 4 IN CHARACTER MODE");

}

/**********************************************************************/
/********************** RXTOFE Interrupt Test *************************/
/**********************************************************************/
void RxTOFEIntTest(int ChannelNo, int32 ChModeSizeFen, int32 TOC,
                  int DMAEN)
{
 /*
   Summary : RxTOFEIntTest
   =======================
   This section of the code tests the AACIRXTOFEINTRn [n = 1 to 4] 
   Interrupt generation logic. The test sequence is as follows :
   - The RXTOIE bit in the AACIIEn [n = 1 to 4] register is set to 
     enable the RXTOFE interrupt. 
   - The TOC bit field of the AACIRXCRn [n = 1 to 4] register is written
     with 4 (timeout after 4 frames). 
   - The AACIRXCRn [n = 1 to 4] register is programmed for reception of
     4 slots. 
   - The Tx FIFO in the trickbox is filled with invalid data for 5 
     frames with only the 'CODEC Ready' bit set for each frame.
   - Then the trickbox is allowed to transmit data.
   - When the AACI receives Slot12 of the fourth frame, it is expected 
     to raise the AACIRXTOFEINTRn [n = 1 to 4] Interrupt. Then 
     AACITrIntr2Reg is read to verify that the interrupt has been 
     raised. The AACIISR and AACIALLINTS registers are also checked. 
   - Clearing the RXTOFECn [n = 1 to 4] bit in the AACIINTCLR register
     should clear the Interrupt. This is verified by reading the 
     AACITrIntReg register of the trickbox and the AACIISR, AACIALLINTS
     registers. 

   This test is repeated after clearing the RXTOIE bit in the AACIIEn 
   [n = 1 to 4] register to verify that this interrupt is not set when 
   masked. After the interrupting condition is created, it is also 
   verified that unmasking the interrupt results in the assertion of 
   this interrupt.
   This test is also repeated for all Channels and for Character mode
   reception.

 */

 int32 ChValidSlot, FEN, Mode, ChModeSize, DMAEnInMainCR;
 int i = 0;
 int One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 /* Extract control information from function arguments */
 FEN        = ChModeSizeFen & AACI_FEN;
 Mode       = ChModeSizeFen & MASK_MODE;
 ChModeSize = ChModeSizeFen & (MASK_MODE || MASK_RSIZE);

 /* Extract DMAEN information for programming the AACIMAINCR register */
 if (DMAEN == DMAENABLE)
   DMAEnInMainCR = AACI_DMAEN;
 else
   DMAEnInMainCR = 0x0;

 /* Calculate the slot numbers for which the test will be done */
 if (FEN == AACI_FEN)
   ChValidSlot = AACI_RX5 | AACI_RX7 | AACI_RX10 | AACI_RX9;
 else 
   {
    /* In Character Mode, even number of slots are to be enabled */
    if (Mode == AACI_CM)
      ChValidSlot = AACI_RX5 | AACI_RX7;
    else
      ChValidSlot = AACI_RX5;
   }

 /* Shifing the Timeout count to the respective bit in the AACIRXCRn
    [n = 1 to 4] register   */
 TOC = TOC << 17;

 /* Configure the AACIRXCRn [n = 1 to 4] registers */
 if (ChannelNo == Channel_1)
   {
    ConfigRxCR(Channel_1, ChValidSlot | ChModeSize | FEN | TOC);
    ConfigRxCR(Channel_2, 0x0);
    ConfigRxCR(Channel_3, 0x0);
    ConfigRxCR(Channel_4, 0x0);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       ConfigRxCR(Channel_2, ChValidSlot | ChModeSize | FEN | TOC);
       ConfigRxCR(Channel_1, 0x0);
       ConfigRxCR(Channel_3, 0x0);
       ConfigRxCR(Channel_4, 0x0);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          ConfigRxCR(Channel_3, ChValidSlot | ChModeSize | FEN | TOC);
          ConfigRxCR(Channel_1, 0x0);
          ConfigRxCR(Channel_2, 0x0);
          ConfigRxCR(Channel_4, 0x0);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             ConfigRxCR(Channel_4, 
                        ChValidSlot | ChModeSize | FEN | TOC);
             ConfigRxCR(Channel_1, 0x0);
             ConfigRxCR(Channel_2, 0x0);
             ConfigRxCR(Channel_3, 0x0);
            }
         }
      }
   }

 /* Enable AACI */
 PSW(AACI_AACIIFE | DMAEnInMainCR, AACIMAINCR);

 /* Enable the AACIRXTOINTRn [n = 1 to 4] Interrupt and the
    AACIRXTOFEINTRn [n = 1 to 4] Interrupt */
 if (ChannelNo == Channel_1)
   PSW(AACI_RTIE | AACI_RXTOFEIE, AACIIE1);
 else
   {
    if (ChannelNo == Channel_2)
      PSW(AACI_RTIE | AACI_RXTOFEIE, AACIIE2);
    else
      {
       if (ChannelNo == Channel_3)
         PSW(AACI_RTIE | AACI_RXTOFEIE, AACIIE3);
       else
         {
          if (ChannelNo == Channel_4)
            PSW(AACI_RTIE | AACI_RXTOFEIE, AACIIE4);
         }
      }
   }

 /* Fill Trickbox Tx FIFO with transmit data */

 /* Four frames are valid but all slots are invalid */
 for (i = 0; i < 52; i++)
   {
    if (i == 0 || i == 13 || i == 26 || i == 39)
      {
       PSW(0x80000, AACITrTxFIFO);
      }
    else
      {
       PSW(0x00, AACITrTxFIFO);
      }
   }

 /* Enable AACI reception */
 ConfigRxCR(ChannelNo,TOC | ChValidSlot | ChModeSize | FEN | AACI_REN);

 /* Enable TrickBox Transmission */
 PSW(AACITB_En | AACITB_TxEn | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Wait for completion of one frame of data transfer */
 PO(0x260000, MASK_TxFFFillLevel,AACITrFIFOStat, 512 * One_BitClk_Period);

 /* Verify that the RxHF bit is not set */
 if (ChannelNo == Channel_1)
   PSR(0x0, AACI_RXHF, AACISR1,Confirm_Half_Full_0);
 else
   {
    if (ChannelNo == Channel_2)
      PSR(0x0, AACI_RXHF, AACISR2,Confirm_Half_Full_0);
    else
      {
       if (ChannelNo == Channel_3)
         PSR(0x0, AACI_RXHF, AACISR3,Confirm_Half_Full_0);
       else
         {
          if (ChannelNo == Channel_4)
            PSR(0x0, AACI_RXHF, AACISR4, Confirm_Half_Full_0);
         }
      }
   }

 /* Wait for completion of third frame */
 PO(0x00C0000, MASK_TxFFFillLevel,AACITrFIFOStat, 766 * One_BitClk_Period);

 /* Write data for Fifth frame (invalid frame) into the Tx FIFO of the
    trickbox */
 PSW(0x80000, AACITrTxFIFO);
 for (i = 0; i < 12; i++)
   {
    PSW(0x00000, AACITrTxFIFO);
   } 

 PSW(0x80000, AACITrTxFIFO);

 /* Wait for completion of the fifth frame and the start of the
    next frame */
 PO(0x0, MASK_TxFFFillLevel,AACITrFIFOStat, 766 * One_BitClk_Period);
 PI(One_BitClk_Period * 20);

 /* Verify that the AACIRXTOFEINTRn [n = 1 to 4] is set and the
    AACIRXTOINTRn [n = 1 to 4] Interrupt is not set */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_TOEFE, AACI_TOEFE | AACI_TIMEOUT, AACISR1,AACI1_T360_1);
    PSR(AACI_RXTOFEIS, AACI_RTIS | AACI_RXTOFEIS, AACIISR1,AACI1_T336);
    PSR(AACI_RXTOFEIS1, AACI_RTIS1 | AACI_RXTOFEIS1, AACIALLINTS,AACI1_T338);
    PSR(0x0, AACIRXTOINTR1, AACITrIntr1Reg,AACI1_T339);
    PSR(AACIRXTOFEINTR1 | AACIINTR, AACIINTR | AACIRXTOFEINTR1, AACITrIntr2Reg,AACI1_RX_IntrRead);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_TOEFE, AACI_TOEFE | AACI_TIMEOUT, AACISR2,AACI1_T360_1);
       PSR(AACI_RXTOFEIS, AACI_RTIS | AACI_RXTOFEIS, AACIISR2,AACI1_T340);
       PSR(AACI_RXTOFEIS2, AACI_RXTOFEIS2 | AACI_RTIS2, AACIALLINTS,AACI1_T341);
       PSR(0x0, AACIRXTOINTR2, AACITrIntr1Reg,AACI1_T342);
       PSR(AACIRXTOFEINTR2 | AACIINTR, AACIINTR | AACIRXTOFEINTR2, AACITrIntr2Reg,AACI1_RX_IntrRead);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(AACI_TOEFE, AACI_TOEFE | AACI_TIMEOUT, AACISR3,AACI1_T360_1);
          PSR(AACI_RXTOFEIS, AACI_RTIS | AACI_RXTOFEIS, AACIISR3,AACI1_T343);
          PSR(AACI_RXTOFEIS3, AACI_RTIS3 | AACI_RXTOFEIS3, AACIALLINTS,AACI1_T344);
          PSR(0x0, AACIRXTOINTR3, AACITrIntr1Reg,AACI1_T345);
          PSR(AACIRXTOFEINTR3 | AACIINTR, AACIINTR | AACIRXTOFEINTR3, AACITrIntr2Reg,AACI1_RX_IntrRead);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(AACI_TOEFE, AACI_TOEFE | AACI_TIMEOUT, AACISR4,AACI1_T360_1);
             PSR(AACI_RXTOFEIS, AACI_RTIS | AACI_RXTOFEIS, AACIISR4,AACI1_T346);
             PSR(AACI_RXTOFEIS4, AACI_RTIS4 | AACI_RXTOFEIS4, AACIALLINTS,AACI1_T347);
             PSR(0x0, AACIRXTOINTR4, AACITrIntr1Reg,AACI1_T348);
             PSR(AACIRXTOFEINTR4 | AACIINTR, AACIINTR | AACIRXTOFEINTR4, AACITrIntr2Reg,AACI1_RX_IntrRead);
            }
         }
      }
   }

 /* Clear the AACIRXTOFEINTRn [n = 1 to 4] interrupt */
 if (ChannelNo == Channel_1)
   PSW(AACI_RXTOFEC1, AACIINTCLR);
 else if (ChannelNo == Channel_2)
   PSW(AACI_RXTOFEC2, AACIINTCLR);
 else if (ChannelNo == Channel_3)
   PSW(AACI_RXTOFEC3, AACIINTCLR);
 else if (ChannelNo == Channel_4)
   PSW(AACI_RXTOFEC4, AACIINTCLR);

 /* Verify that the AACIRXTOINTRn [n = 1 to 4] and the
    AACIRXTOFEINTRn [n = 1 to 4] Interrupts are cleared */
 if (ChannelNo == Channel_1)
   {
    PSR(0x0, AACI_TOEFE | AACI_TIMEOUT, AACISR1,AACI1_T360_1);
    PSR(0x0, AACI_RTIS | AACI_RXTOFEIS, AACIISR1,AACI1_T349);
    PSR(0x0, AACI_RXTOFEIS1 | AACI_RTIS1, AACIALLINTS,AACI1_T350);
    PSR(0x0, AACIRXTOINTR1, AACITrIntr1Reg,AACI1_T351);
    PSR(0x0, AACIINTR | AACIRXTOFEINTR1, AACITrIntr2Reg,AACI1_RX_IntrRead);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(0x0, AACI_TOEFE | AACI_TIMEOUT, AACISR2,AACI1_T360_1);
       PSR(0x0, AACI_RTIS | AACI_RXTOFEIS, AACIISR2,AACI1_T352);
       PSR(0x0, AACI_RXTOFEIS2 | AACI_RTIS2, AACIALLINTS,AACI1_T353);
       PSR(0x0, AACIRXTOINTR2, AACITrIntr1Reg,AACI1_T354);
       PSR(0x0, AACIINTR | AACIRXTOFEINTR2, AACITrIntr2Reg,AACI1_RX_IntrRead);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(0x0, AACI_TOEFE | AACI_TIMEOUT, AACISR3,AACI1_T360_1);
          PSR(0x0, AACI_RTIS | AACI_RXTOFEIS, AACIISR3,AACI1_T355);
          PSR(0x0, AACI_RXTOFEIS3 | AACI_RTIS3, AACIALLINTS,AACI1_T356);
          PSR(0x0, AACIRXTOINTR3, AACITrIntr1Reg,AACI1_T357);
          PSR(0x0, AACIINTR | AACIRXTOFEINTR3, AACITrIntr2Reg,AACI1_RX_IntrRead);
         }
      else
        {
         if (ChannelNo == Channel_4)
           {
            PSR(0x0, AACI_TOEFE | AACI_TIMEOUT, AACISR4,AACI1_T360_1);
            PSR(0x0, AACI_RTIS | AACI_RXTOFEIS, AACIISR4,AACI1_T358);
            PSR(0x0, AACI_RTIS4 | AACI_RXTOFEIS4, AACIALLINTS,AACI1_T358);
            PSR(0x0, AACIRXTOINTR4, AACITrIntr1Reg,AACI1_T359);
            PSR(0x0, AACIINTR | AACIRXTOFEINTR4, AACITrIntr2Reg,AACI1_RX_IntrRead);
           }
        }
      }
   }

 /* Repeat the test with the AACIRXTOFEINTRn [n = 1 to 4] interrupt
    masked.  The interrupt is expected not to be asserted */

 /* Disable Trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Disable AACI */
 PSW(DMAEnInMainCR, AACIMAINCR);
 PI(One_BitClk_Period * 4);

 /* Enable AACI */
 PSW(DMAEnInMainCR | AACI_AACIIFE, AACIMAINCR);

 /* Enabling the trickbox */
 PI(One_BitClk_Period * 20);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Disable the AACIRXTOFEINTRn [n = 1 to 4] Interrupt */
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

 /* Configure the given AACIRXCRn [n = 1 to 4] register */
 ConfigRxCR(ChannelNo, ChValidSlot | ChModeSize | FEN | TOC);

 /* Fill Trickbox Tx FIFO with transmit data */

 /* Four frames are valid but all slots are invalid */
 for (i = 0; i < 52; i++)
   {
    if (i == 0 || i == 13 || i == 26 || i == 39) 
      {
       PSW(0x80000, AACITrTxFIFO);
      }
    else
      {
       PSW(0x00, AACITrTxFIFO);
      }
   }

 /* Enable AACI reception */
 ConfigRxCR(ChannelNo,TOC | ChValidSlot | ChModeSize | FEN | AACI_REN);

 /* Enable TrickBox Transmission */
 PSW(AACITB_En | AACITB_TxEn | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Wait for completion of third frame */
 PO(0x00C0000, MASK_TxFFFillLevel,AACITrFIFOStat, 766 * One_BitClk_Period);

 /* Write data for Fifth frame (invalid frame) into the Tx FIFO of the
    trickbox */
 PSW(0x80000, AACITrTxFIFO);
 for (i = 0; i < 12; i++)
   {
    PSW(0x00000, AACITrTxFIFO);
   }

 PSW(0x80000, AACITrTxFIFO);

 /* Wait for completion of the fifth frame and the start of the
    next frame */
 PO(0x0, MASK_TxFFFillLevel,AACITrFIFOStat, 766 * One_BitClk_Period);
 PI(One_BitClk_Period * 20);

 /* Verify that the AACIRXTOFEINTRn [n = 1 to 4] and the
    AACIRXTOINTRn [n = 1 to 4] Interrupt are not set. The raw status
    of the AACIRXTOFEINTRn [n = 1 to 4] interrupt is expected to be
    set  */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_TOEFE, AACI_TOEFE | AACI_TIMEOUT, AACISR1,AACI1_T360_1);
    PSR(0x0, AACI_RTIS | AACI_RXTOFEIS, AACIISR1,AACI1_T360);
    PSR(0x0, AACI_RTIS1 | AACI_RXTOFEIS1, AACIALLINTS,AACI1_T361);
    PSR(0x0, AACIRXTOINTR1, AACITrIntr1Reg,AACI1_T362);
    PSR(0x0, AACIINTR | AACIRXTOFEINTR1, AACITrIntr2Reg,AACI1_RX_IntrRead);
   }
 else
   {
    if (ChannelNo == Channel_2)
      {
       PSR(AACI_TOEFE, AACI_TOEFE | AACI_TIMEOUT, AACISR2,AACI1_T360_1);
       PSR(0x0, AACI_RTIS | AACI_RXTOFEIS, AACIISR2,AACI1_T363);
       PSR(0x0, AACI_RTIS2 | AACI_RXTOFEIS2, AACIALLINTS,AACI1_T364);
       PSR(0x0, AACIRXTOINTR2, AACITrIntr1Reg,AACI1_T365);
       PSR(0x0, AACIINTR | AACIRXTOFEINTR2, AACITrIntr2Reg,AACI1_RX_IntrRead);
      }
    else
      {
       if (ChannelNo == Channel_3)
         {
          PSR(AACI_TOEFE, AACI_TOEFE | AACI_TIMEOUT, AACISR3,AACI1_T360_1);
          PSR(0x0, AACI_RTIS | AACI_RXTOFEIS, AACIISR3,AACI1_T366);
          PSR(0x0, AACI_RTIS3 | AACI_RXTOFEIS3, AACIALLINTS,AACI1_T367);
          PSR(0x0, AACIRXTOINTR3, AACITrIntr1Reg,AACI1_T368);
          PSR(0x0, AACIINTR | AACIRXTOFEINTR3, AACITrIntr2Reg,AACI1_RX_IntrRead);
         }
       else
         {
          if (ChannelNo == Channel_4)
            {
             PSR(AACI_TOEFE, AACI_TOEFE | AACI_TIMEOUT, AACISR4,AACI1_T360_1);
             PSR(0x0, AACI_RTIS | AACI_RXTOFEIS, AACIISR4,AACI1_T369);
             PSR(0x0, AACI_RTIS4 | AACI_RXTOFEIS4, AACIALLINTS,AACI1_T370);
             PSR(0x0, AACIRXTOINTR4, AACITrIntr1Reg,AACI1_T371);
             PSR(0x0, AACIINTR | AACIRXTOFEINTR4, AACITrIntr2Reg,AACI1_RX_IntrRead);
            }
         }
      }
   }

 /* Unmask the AACIRXTOFEINTRn [n = 1 to 4] interrupt */
 if (ChannelNo == Channel_1)
   PSW(AACI_RXTOFEIE, AACIIE1);
 else
   {
    if (ChannelNo == Channel_2)
      PSW(AACI_RXTOFEIE, AACIIE2);
    else
      {
       if (ChannelNo == Channel_3)
         PSW(AACI_RXTOFEIE, AACIIE3);
       else
         {
          if (ChannelNo == Channel_4)
            PSW(AACI_RXTOFEIE, AACIIE4);
         }
      }
   }

 /* Wait for synchronisation to occur */
 PI(One_BitClk_Period * 4);

 /* Verify that the AACIRXTOFEINTRn [n = 1 to 4] is set and the
    AACIRXTOINTRn [n = 1 to 4] Interrupt is not set */
  if (ChannelNo == Channel_1)
    {
     PSR(AACI_TOEFE, AACI_TOEFE | AACI_TIMEOUT, AACISR1,AACI1_T360_1);
     PSR(AACI_RXTOFEIS, AACI_RTIS | AACI_RXTOFEIS, AACIISR1,AACI1_T372);
     PSR(AACI_RXTOFEIS1, AACI_RTIS1 | AACI_RXTOFEIS1, AACIALLINTS,AACI1_T373);
     PSR(0x0, AACIRXTOINTR1, AACITrIntr1Reg,AACI1_T374);
     PSR(AACIRXTOFEINTR1 | AACIINTR, AACIINTR | AACIRXTOFEINTR1, AACITrIntr2Reg,AACI1_RX_IntrRead);
    }
  else
    {
     if (ChannelNo == Channel_2)
       {
        PSR(AACI_TOEFE, AACI_TOEFE | AACI_TIMEOUT, AACISR2,AACI1_T360_1);
        PSR(AACI_RXTOFEIS, AACI_RTIS | AACI_RXTOFEIS, AACIISR2,AACI1_T375);
        PSR(AACI_RXTOFEIS2, AACI_RTIS2 | AACI_RXTOFEIS2, AACIALLINTS,AACI1_T376);
        PSR(0x0, AACIRXTOINTR2, AACITrIntr1Reg,AACI1_T377);
        PSR(AACIRXTOFEINTR2 | AACIINTR, AACIINTR | AACIRXTOFEINTR2, AACITrIntr2Reg,AACI1_RX_IntrRead);
       }
     else
       {
        if (ChannelNo == Channel_3)
          {
           PSR(AACI_TOEFE, AACI_TOEFE | AACI_TIMEOUT, AACISR3,AACI1_T360_1);
           PSR(AACI_RXTOFEIS, AACI_RTIS | AACI_RXTOFEIS, AACIISR3,AACI1_T378);
           PSR(AACI_RXTOFEIS3, AACI_RTIS3 | AACI_RXTOFEIS3, AACIALLINTS,AACI1_T379);
           PSR(0x0, AACIRXTOINTR3, AACITrIntr1Reg,AACI1_T380);
           PSR(AACIRXTOFEINTR3 | AACIINTR, AACIINTR | AACIRXTOFEINTR3, AACITrIntr2Reg,AACI1_RX_IntrRead);
          }
        else
          {
           if (ChannelNo == Channel_4)
             {
              PSR(AACI_TOEFE, AACI_TOEFE | AACI_TIMEOUT, AACISR4,AACI1_T360_1);
              PSR(AACI_RXTOFEIS, AACI_RTIS | AACI_RXTOFEIS, AACIISR4,AACI1_T381);
              PSR(AACI_RXTOFEIS4, AACI_RTIS4 | AACI_RXTOFEIS4, AACIALLINTS,AACI1_T382);
              PSR(0x0, AACIRXTOINTR4, AACITrIntr1Reg,AACI1_T383);
              PSR(AACIRXTOFEINTR4 | AACIINTR, AACIINTR | AACIRXTOFEINTR4, AACITrIntr2Reg,AACI1_RX_IntrRead);
             }
          }
       }
    }

  /* Disable Trickbox */
  PSW(AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

  /* Verify the effect of disabling the AACI on the status of the 
     interrupt lines */

  /* Disable AACI */
  PSW(0x0, AACIMAINCR);
  PI(0x2);

  /* Verify that the AACIRXTOFEINTRn [n = 1 to 4] and the
     AACIRXTOINTRn [n = 1 to 4] Interrupt are cleared */
  if (ChannelNo == Channel_1)
    {
     PSR(0x0, AACI_TOEFE | AACI_TIMEOUT, AACISR1,AACI1_TOFEdis1);
     PSR(0x0, AACI_RTIS | AACI_RXTOFEIS, AACIISR1,AACI1_TOFEdis2);
     PSR(0x0, AACI_RTIS1 | AACI_RXTOFEIS1, AACIALLINTS,AACI1_TOFEdis3);
     PSR(0x0, AACIRXTOINTR1, AACITrIntr1Reg,AACI1_TOFEdis4);
     PSR(0x0, AACIINTR | AACIRXTOFEINTR1, AACITrIntr2Reg,AACI1_TOFEdis5);
    }
  else
    {
     if (ChannelNo == Channel_2)
       {
        PSR(0x0, AACI_TOEFE | AACI_TIMEOUT, AACISR2,AACI1_TOFEdis6);
        PSR(0x0, AACI_RTIS | AACI_RXTOFEIS, AACIISR2,AACI1_TOFEdis7);
        PSR(0x0, AACI_RTIS2 | AACI_RXTOFEIS2, AACIALLINTS,AACI1_TOFEdis8);
        PSR(0x0, AACIRXTOINTR2, AACITrIntr1Reg,AACI1_TOFEdis9);
        PSR(0x0, AACIINTR | AACIRXTOFEINTR2, AACITrIntr2Reg,AACI1_TOFEdis10);
       }
     else
       {
        if (ChannelNo == Channel_3)
          {
           PSR(0x0, AACI_TOEFE | AACI_TIMEOUT, AACISR3,AACI1_TOFEdis11);
           PSR(0x0, AACI_RTIS | AACI_RXTOFEIS, AACIISR3,AACI1_TOFEdis12);
           PSR(0x0, AACI_RTIS3 | AACI_RXTOFEIS3, AACIALLINTS,AACI1_TOFEdis13);
           PSR(0x0, AACIRXTOINTR3, AACITrIntr1Reg,AACI1_TOFEdis14);
           PSR(0x0, AACIINTR | AACIRXTOFEINTR3, AACITrIntr2Reg,AACI1_TOFEdis15);
          }
        else
          {
           if (ChannelNo == Channel_4)
             {
              PSR(0x0, AACI_TOEFE | AACI_TIMEOUT, AACISR4,AACI1_TOFEdis16);
              PSR(0x0, AACI_RTIS | AACI_RXTOFEIS, AACIISR4,AACI1_TOFEdis17);
              PSR(0x0, AACI_RTIS4 | AACI_RXTOFEIS4, AACIALLINTS,AACI1_TOFEdis18);
              PSR(0x0, AACIRXTOINTR4, AACITrIntr1Reg,AACI1_TOFEdis19);
              PSR(0x0, AACIINTR | AACIRXTOFEINTR4, AACITrIntr2Reg,AACI1_TOFEdis20);
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

/******************** End of AACIRXTOFEINTRTests.c ********************/
