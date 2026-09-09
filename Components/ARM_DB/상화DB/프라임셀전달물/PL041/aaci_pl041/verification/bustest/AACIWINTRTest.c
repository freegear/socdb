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
-- File Name              : AACIWINTRTest.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This section of the code tests the AACIWINTR Interrupt
--           generation logic.
--
-- --=================================================================*/

/**********************************************************************/
/******************** Wakeup Interrupt Test ***************************/
/**********************************************************************/
void AACIWINTRTest(void)
{
 /*
   Summary : AACIWINTRTest
   =======================
   This section of the code tests the AACIWINTR Interrupt generation 
   logic. The test sequence is as follows :

   - The WIE bit in the AACISLIEN register of the AACI is set and the 
     WISE bit in the same register is cleared.
   - Normal transmission and reception of data is allowed to occur for
     2 frames.
   - The AACI is programmed through the AACISL1TX and the AACISL2TX
     registers to force the CODEC into low power mode.
   - Then the AACIBITCLK in the trickbox is disabled so as to simulate
     low power mode entry.
   - Initially, when the LPM bit is cleared, the WintGen bit in the 
     AACITrCntlReg register in the Trickbox is made high. This results
     in the AACISDATAIN input to the AACI to be made high. It is 
     expected that the AACIWINTR interrupt is not asserted. 
   - Then, the LPM bit in the AACMAINCR register is set. Also, the 
     WintGen bit in the Trickbox is made high. Then the AACITrIntrReg 
     register is read to verify that the AACIWINTR interrupt is 
     asserted. Also the RWIS bit in the AACISLFR register and the WIS 
     bit in the AACISLISTAT register are read to verify that these are 
     cleared.
   - Then the WintGen bit in the Trickbox is cleared. This is expected 
     to clear the AACIWINTR interrupt. This is confirmed by reading the 
     AACITrIntrReg register in the trickbox. The RWIS bit in the 
     AACISLFR register and the WIS bit in the AACISLISTAT register are 
     read to verify that these are still in the cleared condition.

   - Then, the WISE bit is set and the interrupting condition is created
     again. The WIE bit is kept high. Then the AACITrIntrReg register is
     read to verify that the AACIWINTR Interrupt is asserted. 
     Also the RWIS bit in the AACISLFR register and the WIS bit in the 
     AACISLISTAT register are read to verify that these are set to 
     indicate the occurence of the interrupt.
   - Then the WintGen bit in the AACITrCntlReg register is then made
     zero. The AACIWINTR interrupt and the related flags are expected to
     be still set as the interrupt is expected to have been latched. 
   - Then a value of  '1' is written to the WISC bit of the AACIINTCLR 
     Register to clear the AACIWINTR interrupt. The AACITrIntrReg, 
     AACISLFR and AACISLISTAT registers are read to verify that the 
     interrupt is cleared. 

   This test is repeated with the WIE bit in the AACISLIEN register 
   cleared, to verify that the interrupt is not asserted when masked.

 */

 int i, One_BitClk_Period, Cycle;

 One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 
 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 if (AACIBITCLK_PERIOD > PCLK_PERIOD)
   {
    C(" WAKE UP INTERRUPT TEST");
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   
    /* Disable AACI */
    PSW(0x0, AACIMAINCR);
    PI(One_BitClk_Period * 3);
   
    /* Disable all Slot bits in AACIRXCRn [n = 1 to 4] */
    ConfigRxCR(Channel_1, AACI_FEN);
    ConfigRxCR(Channel_2, AACI_FEN);
    ConfigRxCR(Channel_3, AACI_FEN);
    ConfigRxCR(Channel_4, AACI_FEN);
   
    /* Disable all Slot bits in AACITXCRn [n = 1 to 4] */
    ConfigTxCR(Channel_1, AACI_FEN);
    ConfigTxCR(Channel_2, AACI_FEN);
    ConfigTxCR(Channel_3, AACI_FEN);
    ConfigTxCR(Channel_4, AACI_FEN);
    PI(One_BitClk_Period * 3);
   
    /* Set the WIE Bit and Clear the WISE bit in AACISLIEN register */
    PSW(AACI_WIE, AACISLIEN);
   
    /* Set Bit 16 of AACISL2TX Register to put the CODEC into low power 
       mode */
    PSW(0x10000, AACISL2TX, Set_bit12_SLOT2TX_for_LowPowerMode);
   
    /* Write 26h into AACISL1TX[18:12] Register. Also set the
       'Read/Write' bit to indicate Write operation */
    PSW(0x26000, AACISL1TX, Writing_0x26_to_SLOT1TX_for_LowPowerMode);
   
    /* Enable AACISL1TX, AACISL2TX and AACISL2RX */
    PSW(AACI_S1TXE | AACI_S2TXE | AACI_S2RXE | AACI_AACIIFE, AACIMAINCR);
   
    /* Write data for the first frame with Slot 2 = 0x12345. This data
       is expected to be received by the AACI and stored in the
       AACISL2RX register */
    PSW(0xA0000, AACITrTxFIFO);
    for (i = 0; i < 12; i++)
      {
       if (i == 1)
         {
          PSW(0x12345, AACITrTxFIFO);
         }
       else
         {
          PSW(0x0000, AACITrTxFIFO);
         }
      }
   
    /* Write data for the first 3 slots in the next (valid) frame */
    PSW(0xE0000, AACITrTxFIFO);
    PSW(0x54321, AACITrTxFIFO);
    PSW(0x98765, AACITrTxFIFO);
   
    /* Enable data transfer */
    PSW(AACITB_BtClkEn | AACITB_En | AACITB_RxEn | AACITB_TxEn | AACITB_BtClkRst, AACITrCntlReg,BitClk_Enabled);
   
    /* Wait for the completion of the first slot of the second frame */
    PO(0x10,MASK_RxFFFillLevel,AACITrFIFOStat,One_BitClk_Period * 512);
   
    /* Disable AACIBITCLK after fixed delay */
    if (AACIBITCLK_PERIOD > PCLK_PERIOD)
      {
       PI(One_BitClk_Period * 8);
      }
    PSW(AACITB_En | AACITB_BtClkRst, AACITrCntlReg,BitClk_Disabled);
   
    /* Wait for One Slot  Period */
    PI(20 * One_BitClk_Period);
   
    /* Dummy reads for the invalid frame */
    for (i = 0 ; i < 13 ; i++ )
      {
       PSR(0x0, 0xFFFFF, AACITrRxFIFO,RdInvalid);
      }
   
    /* Verify data transmitted by the AACI */
    PSR(0x0E000, 0xFFFFF, AACITrRxFIFO,PDOWN_TAG_READ);
    PSR(0x26000, 0xFFFFF, AACITrRxFIFO,PDOWN_READ);
    PSR(0x10000, 0xFFFFF, AACITrRxFIFO,PDOWN_READ);
   
    /* Verify that AACISL2RX data is not stored after the CODEC has
       entered Low Power Mode */
    PSR(0x12345, MASK_ALL, AACISL2RX,AACI1_T214);
   
    /* Verify that the status register bits are low */
    PSR(0x0, 0x0C0, AACISR1,AACI1_T215);
    PSR(0x0, 0x0C0, AACISR2,AACI1_T216);
    PSR(0x0, 0x0C0, AACISR3,AACI1_T217);
    PSR(0x0, 0x0C0, AACISR4,AACI1_T218);
   
    /* Set LPM bit in the AACIMAINCR register */
    PSW(AACI_LPM | AACI_AACIIFE, AACIMAINCR, Set_LPM);
   
    /* Force SDATAIN input to the AACI high through the trickbox */
    PSW(AACITB_WintGen | AACITB_En | AACITB_BtClkRst, AACITrCntlReg);
    PI(One_BitClk_Period * 3);
   
    /* Verify that the AACIWINR interrupt and the AACIINTR are
       asserted */
    PSR(AACIWINTR, AACIWINTR, AACITrIntr1Reg,AACI1_T898);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   
    /* Verify that other related status bits in the AACI are low */
    PSR(0x0, AACI_RWIS, AACISLFR,AACI1_T899);
    PSR(0x0, AACI_WIS, AACISLISTAT,AACI1_T900);
   
    /* Force SDATAIN input to the AACI low through the trickbox */
    PSW(AACITB_En | AACITB_BtClkRst, AACITrCntlReg);
    PI(One_BitClk_Period * 3);
   
    /* Verify that the AACIWINR interrupt and the AACIINTR are 
       cleared */
    PSR(0x0, AACIWINTR, AACITrIntr1Reg,AACI1_T901);
    PSR(0x0, AACI_RWIS, AACISLFR,AACI1_T902);
    PSR(0x0, AACI_WIS, AACISLISTAT,AACI1_T903);
   
    /* Set the WIE bit and the WISE bit in the AACISLIEN register */
    PSW(AACI_WIE | AACI_WISE, AACISLIEN);
   
    /* Set Bit16 of AACISL2TX Register */
    PSW(0x10000, AACISL2TX, Set_bit12_SLOT2TX_for_LowPowerMode);
   
    /* Write 26h into AACISL1TX[18:12] Register. Also set the 
       'Read/Write' bit to indicate Write operation */
    PSW(0x26000, AACISL1TX, Writing_0x26_to_SLOT1TX_for_LowPowerMode);
   
    /* Enable AACISL1TX, AACISL2TX and AACISL2RX */
    PSW(AACI_S1TXE | AACI_S2TXE | AACI_S2RXE | AACI_AACIIFE, AACIMAINCR);
   
    /* Enable AACIBITCLK */
    PSW(AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
   
    /* Write data for the first frame with Slot 2 = 0x12345. This data
       is expected to be received by the AACI and stored in the
       AACISL2RX register */
    PSW(0xA0000, AACITrTxFIFO);
    for (i = 0; i < 12; i++)
      {
       if (i == 1)
         {
          PSW(0x12345, AACITrTxFIFO);
         }
       else
         {
          PSW(0x0000, AACITrTxFIFO);
         }
      }
   
    /* Write data for the first 3 slots in the next (valid) frame */
    PSW(0xE0000, AACITrTxFIFO);
    PSW(0x54321, AACITrTxFIFO);
    PSW(0x98765, AACITrTxFIFO);
   
    /* Enable data transfer */
    PSW(AACITB_BtClkEn | AACITB_En | AACITB_RxEn | AACITB_TxEn | AACITB_BtClkRst, AACITrCntlReg,BitClk_Enabled);
   
    /* Wait for the completion of the first slot of the second frame */
    PO(0x10,MASK_RxFFFillLevel,AACITrFIFOStat,One_BitClk_Period * 512);
   
    /* Disable AACIBITCLK after fixed delay */
    if (AACIBITCLK_PERIOD > PCLK_PERIOD)
      {
       PI(One_BitClk_Period * 8);
      }
    PSW(AACITB_En | AACITB_BtClkRst, AACITrCntlReg,BitClk_Disabled);
   
    /* Wait for One Slot  Period */
    PI(20 * One_BitClk_Period);
   
    /* Dummy reads for the invalid frame */
    for (i = 0 ; i < 13 ; i++ )
      {
       PSR(0x0, 0xFFFFF, AACITrRxFIFO,RdInvalid);
      }
   
    /* Verify data transmitted by the AACI */
    PSR(0x0E000, 0xFFFFF, AACITrRxFIFO,PDOWN_TAG_READ);
    PSR(0x26000, 0xFFFFF, AACITrRxFIFO,PDOWN_READ);
    PSR(0x10000, 0xFFFFF, AACITrRxFIFO,PDOWN_READ);
   
    /* Verify that AACISL2RX data is not stored after the CODEC has
       entered Low Power Mode */
    PSR(0x12345, MASK_ALL, AACISL2RX,AACI1_T214);
   
    /* Verify that the status register bits are low */
    PSR(0x0, 0x0C0, AACISR1,AACI1_T215);
    PSR(0x0, 0x0C0, AACISR2,AACI1_T216);
    PSR(0x0, 0x0C0, AACISR3,AACI1_T217);
    PSR(0x0, 0x0C0, AACISR4,AACI1_T218);
   
    /* Set the LPM bit in the AACIMAINCR register */
    PSW(AACI_LPM | AACI_AACIIFE, AACIMAINCR, Set_LPM);
   
    /* Force SDATAIN input to the AACI high through the trickbox */
    PSW(AACITB_WintGen | AACITB_En | AACITB_BtClkRst, AACITrCntlReg);
    PI(One_BitClk_Period * 3);
   
    /* Verify that the AACIWINR interrupt, the AACIINTR interrupt and
       the related status register bits are set */
    PSR(AACIWINTR, AACIWINTR, AACITrIntr1Reg,AACI1_T904);
    PSR(AACI_RWIS, AACI_RWIS, AACISLFR,AACI1_T905);
    PSR(AACI_WIS, AACI_WIS, AACISLISTAT,AACI1_T906);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   
    /* Disable AACIBITCLK */
    PSW(AACITB_En | AACITB_BtClkRst, AACITrCntlReg);
    PI(One_BitClk_Period * 3);
   
    /* Verify that the AACIWINR interrupt and the AACIINTR are not
       cleared, since they are expected to have been latched */
    PSR(AACIWINTR, AACIWINTR, AACITrIntr1Reg,AACI1_T907);
    PSR(AACI_RWIS, AACI_RWIS, AACISLFR,AACI1_T908);
    PSR(AACI_WIS, AACI_WIS, AACISLISTAT,AACI1_T909);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   
    /* Clear the AACIWINTR interrupt */
    PSW(AACI_WISC, AACIINTCLR);
   
    /* Verify that the AACIWINR interrupt and the AACIINTR are 
       cleared */
    PSR(0x0, AACIWINTR, AACITrIntr1Reg,AACI1_T907);
    PSR(0x0, AACI_RWIS, AACISLFR,AACI1_T908);
    PSR(0x0, AACI_WIS, AACISLISTAT,AACI1_T909);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   
    /* Repeating the test with the AACIWINTR interrupt masked. This is
       to verify that the interupt is not asserted when masked */
   
    /* Clear the WIE bit and the WISE bit */ 
    PSW(0x0, AACISLIEN);
   
    /* Set Bit 16 of AACISL2TX Register to put the CODEC into low power
       mode */
    PSW(0x10000, AACISL2TX, Set_bit12_SLOT2TX_for_LowPowerMode);
   
    /* Write 26h into AACISL1TX[18:12] Register. Also set the 
       'Read/Write' bit to indicate Write operation */
    PSW(0x26000, AACISL1TX, Writing_0x26_to_SLOT1TX_for_LowPowerMode);
   
    /* Enable AACISL1TX, AACISL2TX and AACISL2RX */
    PSW(AACI_S1TXE | AACI_S2TXE | AACI_S2RXE | AACI_AACIIFE, AACIMAINCR);
   
    /* Enable the AACIBITCLK*/
    PSW(AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
   
    /* Write data for the first frame with Slot 2 = 0x12345. This data
       is expected to be received by the AACI and stored in the
       AACISL2RX register */
    PSW(0xA0000, AACITrTxFIFO);
    for (i = 0; i < 12; i++)
      {
       if (i == 1)
         {
          PSW(0x12345, AACITrTxFIFO);
         }
       else
         {
          PSW(0x0000, AACITrTxFIFO);
         }
      }
   
    /* Write data for the first 3 slots in the next (valid) frame */
    PSW(0xE0000, AACITrTxFIFO);
    PSW(0x54321, AACITrTxFIFO);
    PSW(0x98765, AACITrTxFIFO);
   
     /* Enable data transfer */
    PSW(AACITB_BtClkEn | AACITB_En | AACITB_RxEn | AACITB_TxEn | AACITB_BtClkRst, AACITrCntlReg,BitClk_Enabled);
   
    /* Wait for the completion of the first slot of the second frame */
    PO(0x10,MASK_RxFFFillLevel,AACITrFIFOStat,One_BitClk_Period * 512);
   
    /* Disable AACIBITCLK after fixed delay */
    if (AACIBITCLK_PERIOD > PCLK_PERIOD)
      {
       PI(One_BitClk_Period * 8);
      }
    PSW(AACITB_En | AACITB_BtClkRst, AACITrCntlReg,BitClk_Disabled);
   
    /* Wait for One Slot  Period */
    PI(20 * One_BitClk_Period);
   
    /* Dummy reads for the invalid frame */
    for (i = 0 ; i < 13 ; i++ )
      {
       PSR(0x0, 0xFFFFF, AACITrRxFIFO,RdInvalid);
      }
   
    /* Verify data transmitted by the AACI */
    PSR(0x0E000, 0xFFFFF, AACITrRxFIFO,PDOWN_TAG_READ);
    PSR(0x26000, 0xFFFFF, AACITrRxFIFO,PDOWN_READ);
    PSR(0x10000, 0xFFFFF, AACITrRxFIFO,PDOWN_READ);
   
    /* Verify that AACISL2RX data is not stored after the CODEC has
       entered Low Power Mode */
    PSR(0x12345, MASK_ALL, AACISL2RX,AACI1_T214);
   
    /* Verify that the status register bits are low */
    PSR(0x0, 0x0C0, AACISR1,AACI1_T215);
    PSR(0x0, 0x0C0, AACISR2,AACI1_T216);
    PSR(0x0, 0x0C0, AACISR3,AACI1_T217);
    PSR(0x0, 0x0C0, AACISR4,AACI1_T218);
   
    /* Set LPM bit in the AACIMAINCR register */
    PSW(AACI_LPM | AACI_AACIIFE, AACIMAINCR, Set_LPM);
   
    /* Force SDATAIN input to the AACI high through the trickbox */
    PSW(AACITB_WintGen | AACITB_En | AACITB_BtClkRst, AACITrCntlReg);
    PI(One_BitClk_Period * 3);
   
    /* Verify that the AACIWINR interrupt and the AACIINTR are 
       cleared */
    PSR(0x0, AACIWINTR, AACITrIntr1Reg,AACI1_T910);
    PSR(0x0, AACI_RWIS, AACISLFR,AACI1_T911);
    PSR(0x0, AACI_WIS, AACISLISTAT,AACI1_T912);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   
    /* Set the WIE bit */
    PSW(AACI_WIE, AACISLIEN);
   
    /* Verify that the AACIWINR interrupt and the AACIINTR are 
       asserted */
    PSR(AACIWINTR, AACIWINTR, AACITrIntr1Reg,AACI1_T913);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   
    /* Verify that other related status bits in the AACI are low */
    PSR(0x0, AACI_RWIS, AACISLFR,AACI1_T914);
    PSR(0x0, AACI_WIS, AACISLISTAT,AACI1_T915);
   
    /* Force SDATAIN input to the AACI low through the trickbox */
    PSW(AACITB_En | AACITB_BtClkRst, AACITrCntlReg);
    PI(One_BitClk_Period * 3);
   
    /* Verify that the AACIWINR interrupt and the AACIINTR are
       cleared */
    PSR(0x0, AACIWINTR, AACITrIntr1Reg,AACI1_T916);
    PSR(0x0, AACI_RWIS, AACISLFR,AACI1_T917);
    PSR(0x0, AACI_WIS, AACISLISTAT,AACI1_T918);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   
    /* Clear the WIE bit and set the WISE bit */
    PSW(AACI_WISE, AACISLIEN);
   
    /* Set Bit 16 of AACISL2TX Register to put the CODEC into low power
       mode */
    PSW(0x10000, AACISL2TX, Set_bit12_SLOT2TX_for_LowPowerMode);
   
    /* Write 26h into AACISL1TX[18:12] Register. Also set the 
       'Read/Write' bit to indicate Write operation */
    PSW(0x26000, AACISL1TX, Writing_0x26_to_SLOT1TX_for_LowPowerMode);
   
    /* Enable AACISL1TX, AACISL2TX and AACISL2RX */
    PSW(AACI_S1TXE | AACI_S2TXE | AACI_S2RXE | AACI_AACIIFE, AACIMAINCR);
   
    /* Enabling AACIBITCLK */
    PSW(AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
   
    /* Write data for the first frame with Slot 2 = 0x12345. This data
       is expected to be received by the AACI and stored in the
       AACISL2RX register */
    PSW(0xA0000, AACITrTxFIFO);
    for (i = 0; i < 12; i++)
      {
       if (i == 1)
         {
          PSW(0x12345, AACITrTxFIFO);
         }
       else
         {
          PSW(0x0000, AACITrTxFIFO);
         }
      }
   
    /* Write data for the first 3 slots in the next (valid) frame */
    PSW(0xE0000, AACITrTxFIFO);
    PSW(0x54321, AACITrTxFIFO);
    PSW(0x98765, AACITrTxFIFO);
   
    /* Enable data transfer */
    PSW(AACITB_BtClkEn | AACITB_En | AACITB_RxEn | AACITB_TxEn | AACITB_BtClkRst, AACITrCntlReg,BitClk_Enabled);
   
    /* Wait for the completion of the first slot of the second frame */
    PO(0x10,MASK_RxFFFillLevel,AACITrFIFOStat,One_BitClk_Period * 512);
   
    /* Disable AACIBITCLK after fixed delay */
    if (AACIBITCLK_PERIOD > PCLK_PERIOD)
      {
       PI(One_BitClk_Period * 8);
      }
    PSW(AACITB_En | AACITB_BtClkRst, AACITrCntlReg,BitClk_Disabled);
   
    /* Wait for One Slot  Period */
    PI(20 * One_BitClk_Period);
   
     /* Dummy reads for the invalid frame */
    for (i = 0 ; i < 13 ; i++ )
      {
       PSR(0x0, 0xFFFFF, AACITrRxFIFO,RdInvalid);
      }
   
    /* Verify data transmitted by the AACI */
    PSR(0x0E000, 0xFFFFF, AACITrRxFIFO,PDOWN_TAG_READ);
    PSR(0x26000, 0xFFFFF, AACITrRxFIFO,PDOWN_READ);
    PSR(0x10000, 0xFFFFF, AACITrRxFIFO,PDOWN_READ);
   
    /* Verify that AACISL2RX data is not stored after the CODEC has
       entered Low Power Mode */
    PSR(0x12345, MASK_ALL, AACISL2RX,AACI1_T214);
   
    /* Verify that the status register bits are low */
    PSR(0x0, 0x0C0, AACISR1,AACI1_T215);
    PSR(0x0, 0x0C0, AACISR2,AACI1_T216);
    PSR(0x0, 0x0C0, AACISR3,AACI1_T217);
    PSR(0x0, 0x0C0, AACISR4,AACI1_T218);
   
    /* Set LPM bit in the AACIMAINCR register */
    PSW(AACI_LPM | AACI_AACIIFE, AACIMAINCR, Set_LPM);
   
    /* Force SDATAIN input to the AACI high through the trickbox */
    PSW(AACITB_WintGen | AACITB_En | AACITB_BtClkRst, AACITrCntlReg);
    PI(One_BitClk_Period * 3);
   
    /* Verify that the AACIWINR interrupt is cleared and the WIS bit in
       AACISLFR is set */
    PSR(0x0, AACIWINTR, AACITrIntr1Reg,AACI1_T919);
    PSR(AACI_RWIS, AACI_RWIS, AACISLFR,AACI1_T920);
    PSR(0x0, AACI_WIS, AACISLISTAT,AACI1_T921);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   
    /* Set WIE bit */
     PSW(AACI_WIE | AACI_WISE, AACISLIEN);
   
    /* Verify that the AACIWINR interrupt and the AACIINTR are 
       asserted */
    PSR(AACIWINTR, AACIWINTR, AACITrIntr1Reg,AACI1_T922);
    PSR(AACI_RWIS, AACI_RWIS, AACISLFR,AACI1_T923);
    PSR(AACI_WIS, AACI_WIS, AACISLISTAT,AACI1_T924);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   
    /* Force SDATAIN input to the AACI low through the trickbox */
    PSW(AACITB_En | AACITB_BtClkRst, AACITrCntlReg);
    PI(One_BitClk_Period * 3);
   
    /* Verify for AACIWINTR interrupt is asserted still as it is 
       expected to have been latched */
    PSR(AACIWINTR, AACIWINTR, AACITrIntr1Reg,AACI1_T922);
    PSR(AACI_RWIS, AACI_RWIS, AACISLFR,AACI1_T923);
    PSR(AACI_WIS, AACI_WIS, AACISLISTAT,AACI1_T924);
    PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   
    /* Verify the effect of AACIFE bit on the AACIWINTR interrupt */
    /* Clear AACIFE */
    PSW(AACI_LPM, AACIMAINCR, Disable_With_LPM);
    PI(0x2);
   
    /* Verify that the AACIWINTR interrupt is cleared */
    PSR(0x0, AACIWINTR, AACITrIntr1Reg,AACI1_T925);
    PSR(0x0, AACI_RWIS, AACISLFR,AACI1_T926);
    PSR(0x0, AACI_WIS, AACISLISTAT,AACI1_T927);
    PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
   
    /* Enable AACIBITCLK */
    PSW(AACITB_En | AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);
    PI(One_BitClk_Period * 3);
    C("END OF WAKE UP INTERRUPT TEST");
   }
 /* Added for reseting the trickbox state machine */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
}

/*********************** End of AACIWINTRTest.c ***********************/
