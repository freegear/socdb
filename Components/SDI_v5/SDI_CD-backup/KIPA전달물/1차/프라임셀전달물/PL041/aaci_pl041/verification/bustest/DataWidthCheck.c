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
-- File Name              : DataWidthCheck.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose : 
--           Test code to verify setup and hold timing requirements
--           on the AACISDATAOUT line.
--
-- --=================================================================*/

/**********************************************************************/
/************************* Data Width Check ***************************/
/**********************************************************************/
void DataWidthCheck(void)
{
 /*
   Summary : DataWidthCheck
   ========================
            This function checks the setup and hold timings of the
  AACISDATAOUT line with respect to the falling edge of AACIBITCLK and 
  the signal width corresponding to each data bit on AACISDATAOUT.

  The Tx Channels and SLOTnTx(n =1, 2, and 12) registers are enabled for
  transmission such that all the 12 slots in the frame are valid.

  The data to be transmitted is written in to the Tx FIFO of the
  channels and the SLOTnTx(n = 1, 2, and 12) registers. The data 
  written to all these locations is 0xAAAAA, so that the AACISDATAOUT 
  line from the AACI toggles on every rising edge of the AACIBITCLK.

  Every bit-duration is expected to last for one AACIBITCLK period.
  (The only exceptions are Slot0 - because multiple slots in each
  frame are valid and the valid bits for those slots in Slot 0 would
  be set - and Slot2 - because last 3 bits in this slot are always
  stuffed with zeros.) 

  Normal transmission and reception is allowed to occur for 4 frames.

  During this test the trickbox WidChkEn bit in the control register is
  set to 1 so that trickbox checks for the setup and hold timings on the
  AACISDATAOUT with respect to the falling edge of the AACIBITCLK and 
  the bit-durations on AACISDATAOUT. Any violations are flaged as error
  messages by the trickbox.

 */

 int One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int i;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
   One_BitClk_Period = 0x1;

 /* Disable AACI */
 PSW(0x0, AACIMAINCR);

 /* Disabling the trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Enable AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);

 C("BIT-DURATION CHECK FOR AACISDATAOUT");

 /* Enabling the channels so as to have valid data on all slots in
    every frame
 */
 PSW(AACI_TX3 | AACI_TX5 | AACI_TX4 | AACI_TSIZE20 | AACI_FEN, AACITXCR1);
 PSW(AACI_TX8 | AACI_TX10 | AACI_TX7 | AACI_TSIZE20 | AACI_FEN, AACITXCR2);
 PSW(AACI_TX6 | AACI_TX9 | AACI_TSIZE20 | AACI_FEN, AACITXCR3);
 PSW(AACI_TX11 | AACI_TX12 | AACI_TSIZE20 | AACI_FEN, AACITXCR4);

 /* Waiting for synchronisation to occur */
 PI(One_BitClk_Period * 4);
 
 /* Fill the channels with data (0xAAAAA) required for 4 frames */

 /* For channel 1 */
 for (i = 0; i < 8; i = i + 1)
   {
    PSW(0x55555555, AACIDR1);
   }

 /* For channel 2 */
 for (i = 0; i < 8; i = i + 1)
   {
    PSW(0x55555555, AACIDR2);
   }

 /* For channel 3 */
 for (i = 0; i < 8; i = i + 1)
   {
    PSW(0x55555555, AACIDR3);
   }

 /* For channel 4 */
 for (i = 0; i < 8; i = i + 1)
   {
    PSW(0x55555555, AACIDR4);
   }

 /* Writing data to the slot registers */
 PSW(0x55555555, AACISL1TX, Width_Chk_Sl1_Write);
 PSW(0x55555555, AACISL2TX, Width_Chk_Sl1_Write);

 /* Enable SLOT1TX and SLOT2TX for transmission */
 PSW(AACI_S1TXE | AACI_S2TXE | AACI_AACIIFE, AACIMAINCR);

 /* Enabling the channels for transmission */
 PSW(AACI_TX3 | AACI_TX5 | AACI_TX4 | AACI_TSIZE20 | AACI_FEN | AACI_TEN, AACITXCR1);
 PSW(AACI_TX8 | AACI_TX10 | AACI_TX7 | AACI_TSIZE20 | AACI_FEN | AACI_TEN, AACITXCR2);
 PSW(AACI_TX6 | AACI_TX9 | AACI_TSIZE20 | AACI_FEN | AACI_TEN, AACITXCR3);
 PSW(AACI_TX11 | AACI_TX12 | AACI_TSIZE20 | AACI_FEN | AACI_TEN, AACITXCR4);

  /* Reception is not enabled */
  PSW(0x0, AACIRXCR1);
  PSW(0x0, AACIRXCR2);
  PSW(0x0, AACIRXCR3);
  PSW(0x0, AACIRXCR4);
 
 /* Filling the trickbox with data for 4 valid frames for transmission
 */

 /* First frame */
 PSW(0xE0000, AACITrTxFIFO);
 for (i = 0; i < 12; i++)
   {
    PSW(0x0000, AACITrTxFIFO);
   }
 /* Second frame */
 PSW(0xE0000, AACITrTxFIFO);
 for (i = 0; i < 12; i++)
   {
    PSW(0x0000, AACITrTxFIFO);
   }
 /* Third frame */
 PSW(0xE0000, AACITrTxFIFO);
 for (i = 0; i < 12; i++)
   {
    PSW(0x0000, AACITrTxFIFO);
   }
 /* Fourth frame */
 PSW(0xE0000, AACITrTxFIFO);
 for (i = 0; i < 12; i++)
   {
    PSW(0x0000, AACITrTxFIFO);
   }

 /* Fifth frame to prevent the AACI from inferring a CODEC-IDLE */
 PSW(0xE0000, AACITrTxFIFO);

 /* Enabling trickbox transmission */
 PSW(AACITB_En | AACITB_WidChkEn | AACITB_TxEn | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Waiting for half of the 1st frame to complete */
 PO(0x002D0000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 512);
 /* Enabling trickbox Reception */
 PSW(AACITB_En | AACITB_WidChkEn | AACITB_RxEn | AACITB_TxEn | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Waiting for the 1 st frame to complete */
 PO(0x00270000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 512);
 C("END OF THE FIRST FRAME OF TRANSMISSION");

 /* Waiting for the half of the 2nd frame to complete so that the
    empty AACISL1TX and AACISL2TX registers can be filled with
    data for the next frame
 */
 PO(0x00210000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 512);

 /* Writing to the slot registers */
 PSW(0x55555555, AACISL1TX, Width_Chk_Sl1_Write);
 PSW(0x55555555, AACISL2TX, Width_Chk_Sl1_Write);

 /* Waiting for the 2nd frame to complete */
 PO(0x001A0000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 512);
 C("END OF THE SECOND FRAME OF TRANSMISSION");

 /* Fill data into the depleted channels to prevent an Underrun from
    being generated 
 */
 PSW(0x55555555, AACIDR1);
 PSW(0x55555555, AACIDR1);
 PSW(0x55555555, AACIDR1);

 PSW(0x55555555, AACIDR2);
 PSW(0x55555555, AACIDR2);
 PSW(0x55555555, AACIDR2);

 /* Waiting for the half of the 3rd frame to complete so that the
    empty AACISL1TX and AACISL2TX registers can be filled with
    data for the next frame
 */
 PO(0x00150000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 512);

 /* Writing in to the slot registers */
 PSW(0x55555555, AACISL1TX, Width_Chk_Sl1_Write);
 PSW(0x55555555, AACISL2TX, Width_Chk_Sl1_Write);

 /* Waiting for the 3rd frame to complete */
 PO(0x000D0000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 512);
 C("END OF THE THIRD FRAME OF TRANSMISSION");

 /* Fill data into the depleted channels to prevent an Underrun from
    being generated 
 */
 PSW(0x55555555, AACIDR1);
 PSW(0x55555555, AACIDR2);
 
 /* Waiting for the half of the 4th frame to complete so that the
    empty AACISL1TX and AACISL2TX registers can be filled with
    data for the next frame
 */
 PO(0x00070000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 512);

 /* Writing in to the slot registers */
 PSW(0x55555555, AACISL1TX, Width_Chk_Sl1_Write);
 PSW(0x55555555, AACISL2TX, Width_Chk_Sl1_Write);

 /* Waiting for the 4th frame to complete */
 PO(0x00000000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 512);
 C("END OF THE FOURTH FRAME OF TRANSMISSION");

 /* Waiting for the half of 5th frame to complete */
 PO(0x00000030, MASK_RxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 512);

 /* Disabling trickbox transmission and reception */
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Waiting for the 5th frame to complete */
 PO(0x00000034, MASK_RxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 512);
 C("END OF TRANSMISSION OF THE FIFTH FRAME");

 /* Verify the data transmitted by the AACI by 
    reading data from the receive FIFO of the trickbox */

 for (i = 0; i < 52; i++)
   {
    if ( i == 0 || i == 13 || i == 26 || i == 39)
      {
       PSR(0x00FFF8, 0x00FFFF, AACITrRxFIFO,WidChk_Tr_Rx_Read);
      }
    else if (i == 2 || i == 15 || i == 28 || i == 41 )
      {
       PSR(0x055550, 0x0FFFFF, AACITrRxFIFO,WidChk_Tr_Rx_Read);
      }
    else
      {
       PSR(0x055555, 0x0FFFFF, AACITrRxFIFO,WidChk_Tr_Rx_Read);
      }
   }

 /* Disabling the AACI */
 PSW(0x0, AACIMAINCR);

 /* Disabling the trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

}

/*********************** End of DataWidthCheck.c **********************/
