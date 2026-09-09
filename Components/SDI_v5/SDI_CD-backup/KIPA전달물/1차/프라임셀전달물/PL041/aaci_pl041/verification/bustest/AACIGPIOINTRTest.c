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
-- File Name              : AACIGPIOINTRTest.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This section of the code tests the AACIGPIOINTR interrupt 
--           generation logic.
--
-- --=================================================================*/

/**********************************************************************/
/********************  AACIGPIOINTR Interrupt Test ********************/
/**********************************************************************/
void AACIGPIOINTRTest(void)
{
 /*
   Summary : AACIGPIOINTRTest
   ==========================
   This test tests the AACIGPIOINTR interrupt generation logic.
   Test Sequence is as follows :
   - The GPIOIE bit in the AACISLIEN register is set. The AACISL12RX
     register is enabled via the AACIMAINCR register. The Tx FIFO in the
     Trickbox is loaded with data for two frames. The data written is 
     such that the bit-0 of the SLOT12 data for the first frame is zero 
     and bit-0 of slot12 for the next frame is 1. It is expected that,
     at the end of the first frame, the AACIGPIOINTR interrupt should 
     not be set and at the end of the second frame, the AACIGPIOINTR 
     interrupt should be set.
   - Data transfer is then allowed to occur. 
   - The AACITrFIFOStat register is polled to detect the end of 
     transmission of the first frame. The AACITrIntrReg is read to 
     verify that the AACIGPIOINTR interrupt is not raised. The 
     AACISLFR register and the AACISLISTAT and the AACIALLINTS registers
     are also checked.
   - Then, the AACITrFIFOStat register is polled to detect the end of 
     transmission of the second frame. After the transmission of the 
     second frame, the AACIGPIOINTR interrupt is expected to be 
     asserted. This is verified by reading the AACITrIntrReg register. 
     The AACISLFR register, the AACISLISTAT register and the AACIALLINTS
     registers are also checked to verify that the AACIGPIOINTR 
     interrupt is asserted.
   - Then, data received by the AACI is read from the AACISL12RX 
     register and it is expected that the interrupt be cleared. This is
     verified by reading the AACITrFIFOStat, AACISLFR, AACISLISTAT and 
     AACIALLINTS registers. 

   This test is repeated with another frame being allowed to be received
   by the AACI before the data already stored in the AACISL12RX register
   is read out. When the second data received, is about to be written to
   the AACISL12RX register, a read is deterministically initiated to 
   read out the first received data. This allows the write of the 
   second data to occur. In this case, the interrupt is expected
   to remain set to indicate the presence of new data.

   The test is repeated by clearing the GPIOIE bit in the AACISLIEN
   Register to verify that the interrupt is not asserted when masked.
   After the interrupting condition is created, it is also verified that
   setting the Interrupt enable bit results in the assertion of this
   interrupt.

   This test is repeated is repeated after programming a Channel for
   receiving Slot 12 data and clearing the S12RXE bit in the
   AACIMAINCR register. In this case, the AACIGPIOINTR is not expected
   to be set even if bit 0 in the received Slot 12 data is set.

 */

 int  One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int i = 0, Expected_Slot0;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 C(" GPIO INTERRUPT TEST");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Enable GPIO Interrupt Bit */
 PSW(AACI_GPIOIE, AACISLIEN);

 /* Compute Expected Slot 0 for frames with only Slot 12 data valid */
 Expected_Slot0 = Slot0Generation(AACI_RX12, 0x0, 0x0, 0x0);

 /* Fill Trickbox with data for first Frame */
 PSW(Expected_Slot0, AACITrTxFIFO, FirstFrame);
 for (i = 1; i < 13; i ++)
   {
    /* In the first frame, Slot12 bit 0 is zero */ 
    if (i == 12)
      PSW(0x00AAAAA, AACITrTxFIFO, Clear_Slot12_bit0);
    else
      PSW(0x0, AACITrTxFIFO);
   }

 /* Fill Trickbox with data for second Frame */
 PSW(Expected_Slot0, AACITrTxFIFO, Second_Frame);
 for (i = 1; i < 13; i ++)
   {
    /* Second frame bit 0 of slot12 set */
    if (i == 12)
      PSW(0x0055555, AACITrTxFIFO, Clear_Slot12_bit0);
    else
      PSW(0x0, AACITrTxFIFO);
   }
 PSW(0x80000, AACITrTxFIFO, Third_Frame);

 /* Enable Trickbox Transmission */
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn | AACITB_TxEn,AACITrCntlReg);

 /* Enable AACI */
 PSW(AACI_S12RXE | AACI_AACIIFE, AACIMAINCR);

 /* Wait for the completion of slot 12 of the 1st frame 
    and synchronisation to occur */
 PO(0x000D0000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);
 PI(4 * One_BitClk_Period);

 /* Read the slot 12 data from the register */
 PSR(0x00AAAAA, MASK_ALL, AACISL12RX,AACI1_T862);

 /* Verify that the AACIGPIOINTR Interrupt is not set */
 PSR(0x0, AACI_GPIOINTRX, AACISLFR,AACI1_T854);
 PSR(0x0, AACI_GPIOIS, AACISLISTAT,AACI1_T855);
 PSR(0x0, AACIGPIOINTR, AACITrIntr1Reg,AACI1_T857);
 PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);

 /* Wait for completion of the next frame */
 PO(0x00000000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Disable Trickbox Transmission */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);
 PI(24 * One_BitClk_Period);

 /* Verify that the AACIGPIOINTR Interrupt is set */
 PSR(AACI_GPIOINTRX, AACI_GPIOINTRX, AACISLFR,AACI1_T858);
 PSR(AACI_GPIOIS, AACI_GPIOIS, AACISLISTAT,AACI1_T859);
 PSR(AACIGPIOINTR, AACIGPIOINTR, AACITrIntr1Reg,AACI1_T861);
 PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);

 /* Read out the received data from AACISL12RX register */
 PSR(0x0055555, MASK_ALL, AACISL12RX,AACI1_T862);

 /* Verify that the AACIGPIOINTR Interrupt is cleared */
 PSR(0x0, AACI_GPIOINTRX, AACISLFR,AACI1_T863);
 PSR(0x0, AACI_GPIOIS, AACISLISTAT,AACI1_T864);
 PSR(0x0, AACIGPIOINTR, AACITrIntr1Reg,AACI1_T866);
 PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);

 /* Boundary condition check to verify that the AACIGPIOINTR remains
    set when there is a read from the AACISL12RX register just before
    a write happens. This test uses deterministic delays and hence
    is run only for the fixed case of (PCLK period = 10 ns) and
    (AACIBITCLK period = 80 ns) */

if ((PCLK_PERIOD == 10) && (AACIBITCLK_PERIOD == 80))
  {
   /* Fill Trickbox with data for the 3 frames */
   PSW(Expected_Slot0, AACITrTxFIFO, FisrtFrame);
   for (i = 1; i < 13; i ++)
     {
      /* In first frame, Slot12 bit 0 is zero */
      if (i == 12)
        PSW(0x00AAAAA, AACITrTxFIFO, Clear_Slot12_bit0);
      else
        PSW(0x0, AACITrTxFIFO);
     }
   PSW(Expected_Slot0, AACITrTxFIFO, SecondFrame);
   for (i = 1; i < 13; i ++)
     {
      /* In second frame, Slot12 bit 0 is high */
      if (i == 12)
        PSW(0x055555, AACITrTxFIFO, Seting_Slot12_bit0);
      else
        PSW(0x0, AACITrTxFIFO);
     }
   PSW(Expected_Slot0, AACITrTxFIFO, ThirdFrame);
   for (i = 1; i < 13; i ++)
     {
      /* In Third Frame, SLOT12 bit 0 Should be high */
      if (i == 12)
        PSW(0x055555, AACITrTxFIFO, Seting_Slot12_bit0);
      else
        PSW(0x0, AACITrTxFIFO);
     }
   PSW(0x80000, AACITrTxFIFO, Frame_ValidBitSet);
  
   /* Transmit First Frame */
  
   /* Enable Trickbox for Transmission */
   PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn | AACITB_TxEn,AACITrCntlReg);
  
   /* Wait for completion of the 1st frame */
   PO(0x00190000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

   /* Read the data from the AACISL12RX register */
   PSR(0xAAAAA, MASK_ALL, AACISL12RX,AACI1_T871);
  
   /* Wait for completion of the 2nd frame */
   PO(0x000D0000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);
   PI(0xC2);
  
   /* Verify that the AACIGPIOINTR Interrupt is set */
   PSR(AACI_GPIOINTRX, AACI_GPIOINTRX, AACISLFR,AACI1_T867);
   PSR(AACI_GPIOIS, AACI_GPIOIS, AACISLISTAT,AACI1_T868);
   PSR(AACIGPIOINTR, AACIGPIOINTR, AACITrIntr1Reg,AACI1_T870);
   PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
  
   /* Wait for completion of the 11th slot of the 3rd frame */
   PO(0x00010000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);
  
   PI(0xA0);
   /* Read first received AACISL12RX data */
   PSR(0x55555, MASK_ALL, AACISL12RX,AACI1_T871);
  
   /* Wait for the Complete Reception */
   PI(0x28);
  
   /* Wait for completion of the 3rd frame */
   PO(0x00000000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);
   /* Disable the trickbox transmission */
   PSW(AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

   /* Verify that the AACIGPIOINTR Interrupt is set */
   PSR(AACI_GPIOINTRX, AACI_GPIOINTRX, AACISLFR,AACI1_T872);
   PSR(AACI_GPIOIS, AACI_GPIOIS, AACISLISTAT,AACI1_T873);
   PSR(AACIGPIOINTR, AACIGPIOINTR, AACITrIntr1Reg,AACI1_T875);
   PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
  
   /* Read the received slot 12 data from the AACISL12RX register */
   PSR(0x55555, MASK_ALL, AACISL12RX,AACI1_T876);
  
   /* Verify that the AACIGPIOINTR Interrupt is cleared */
   PSR(0x0, AACI_GPIOINTRX, AACISLFR,AACI1_T877);
   PSR(0x0, AACI_GPIOIS, AACISLISTAT,AACI1_T878);
   PSR(0x0, AACIGPIOINTR, AACITrIntr1Reg,AACI1_T880);
   PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
  }

 /* Repeat the test after clearing the GPIOIE Bit */

 /* Clear the GPIOIE bit */
 PSW(0x0, AACISLIEN);

 /* Fill Trickbox with data for 2 frames */
 PSW(Expected_Slot0, AACITrTxFIFO, FisrtFrame);
 for (i = 1; i < 13; i ++)
   {
    /* In First Frame, SLOT12 bit 0 Should be zero */
    if (i == 12)
      PSW(0x0AAAAA, AACITrTxFIFO, Clear_Slot12_bit0);
    else
      PSW(0x0, AACITrTxFIFO);
   }
 PSW(Expected_Slot0, AACITrTxFIFO, SecondFrame);
 for (i = 1; i < 13; i ++)
   {
    /* In Second Frame, SLOT12 bit 0 Should be high */
    if (i == 12)
      PSW(0x055555, AACITrTxFIFO, Seting_Slot12_bit0);
    else
      PSW(0x0, AACITrTxFIFO);
   }

 /* Enable Trickbox for Transmission */
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn | AACITB_TxEn,AACITrCntlReg);

 /* Wait for the completion of the 1 st frame */
 PO(0x000C0000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Disable Trickbox Transmission */
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn | AACITB_TxEn,AACITrCntlReg);
 PI(One_BitClk_Period * 4);

 /* Verify that the AACIGPIOINTR Interrupt is cleared */
 PSR(0x0, AACI_GPIOINTRX, AACISLFR,AACI1_T881);
 PSR(0x0, AACI_GPIOIS, AACISLISTAT,AACI1_T882);
 PSR(0x0, AACIGPIOINTR, AACITrIntr1Reg,AACI1_T884);
 PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);

 /* Read the received data from the AACISL12RX regsiter */
 PSR(0x0AAAAA, MASK_ALL, AACISL12RX,AACI1_T893);

 /* Wait for the 2 nd frame to complete */
 PO(0x00000000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Disable Trickbox Transmission */
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);
 PI(One_BitClk_Period * 24)

 /* Disable Trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Verify that the AACIGPIOINTR Interrupt is cleared but the 
    Raw interrupt status bit is set */
 PSR(AACI_GPIOINTRX, AACI_GPIOINTRX, AACISLFR,AACI1_T885);
 PSR(0x0, AACI_GPIOIS, AACISLISTAT,AACI1_T886);
 PSR(0x0, AACIGPIOINTR, AACITrIntr1Reg,AACI1_T888);
 PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);

 /* Set GPIOIE bit */
 PSW(AACI_GPIOIE, AACISLIEN);

 /* Verify that the AACIGPIOINTR Interrupt is set */
 PSR(AACI_GPIOINTRX, AACI_GPIOINTRX, AACISLFR,AACI1_T889);
 PSR(AACI_GPIOIS, AACI_GPIOIS, AACISLISTAT,AACI1_T890);
 PSR(AACIGPIOINTR, AACIGPIOINTR, AACITrIntr1Reg,AACI1_T892);
 PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);

 /* Disable AACI */
 PSW(AACI_S12RXE, AACIMAINCR);
 PI(One_BitClk_Period * 3);

 /* Verify that the AACIGPIOINTR Interrupt is cleared */
 PSR(0x0, AACI_GPIOINTRX, AACISLFR,AACI1_T894);
 PSR(0x0, AACI_GPIOIS, AACISLISTAT,AACI1_T895);
 PSR(0x0, AACIGPIOINTR, AACITrIntr1Reg,AACI1_T897);
 PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);

 /* Verifying that the GPIOINTR is not set if the SLOT12RX register is
    not eabled, instead the channel is enabled for slot 12. 
 */

 /* Fill Trickbox with data for first Frame */
 PSW(Expected_Slot0, AACITrTxFIFO, FirstFrame);
 for (i = 1; i < 13; i ++)
   {
    /* In the first frame, Slot12 bit 0 is zero */
    if (i == 12)
      PSW(0x00AAAAA, AACITrTxFIFO, Clear_Slot12_bit0);
    else
      PSW(0x0, AACITrTxFIFO);
   }

 /* Fill Trickbox with data for second Frame */
 PSW(Expected_Slot0, AACITrTxFIFO, Second_Frame);
 for (i = 1; i < 13; i ++)
   {
    /* Second frame bit 0 of slot12 set */
    if (i == 12)
      PSW(0x0055555, AACITrTxFIFO, Clear_Slot12_bit0);
    else
      PSW(0x0, AACITrTxFIFO);
   }
 PSW(0x80000, AACITrTxFIFO, Third_Frame);

 /* Enable Trickbox Transmission */
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn | AACITB_TxEn,AACITrCntlReg);

 /* Enable AACI */
 ConfigRxCR(Channel_1, AACI_RX12 | AACI_RSIZE20 | AACI_FEN | AACI_REN);
 PSW(AACI_AACIIFE, AACIMAINCR);

 /* Wait for the completion of slot 12 of the 1st frame
    and synchronisation to occur */
 PO(0x000D0000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);
 PI(4 * One_BitClk_Period);

 /* Read the slot 12 data from the channel */
 PSR(0x00AAAAA, MASK_ALL, AACIDR1,AACI1_T862);

 /* Verify that the AACIGPIOINTR Interrupt is not set */
 PSR(0x0, AACI_GPIOINTRX, AACISLFR,AACI1_T854);
 PSR(0x0, AACI_GPIOIS, AACISLISTAT,AACI1_T855);
 PSR(0x0, AACIGPIOINTR, AACITrIntr1Reg,AACI1_T857);
 PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);

 /* Wait for completion of the next frame */
 PO(0x00000000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Disable Trickbox Transmission */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);
 PI(24 * One_BitClk_Period);

 /* Verify that the AACIGPIOINTR Interrupt is not set */
 PSR(0x0, AACI_GPIOINTRX, AACISLFR,AACI1_T858);
 PSR(0x0, AACI_GPIOIS, AACISLISTAT,AACI1_T859);
 PSR(0x0, AACIGPIOINTR, AACITrIntr1Reg,AACI1_T861);
 PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);

 /* Read the slot 12 data from the channel */
 PSR(0x0055555, MASK_ALL, AACIDR1,AACI1_T862);

 /* Clear GPIOIE bit */
 PSW(0x0, AACISLIEN);
 C("END OF GPIO INTERRUPT TEST");
}

/********************* End of AACIGPIOINTRTest.c **********************/
