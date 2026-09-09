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
-- File Name              : AACISnTXINTRTests.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This section of the code tests the AACISnTXINTR 
--           [n = 1 to 4] Interrupt generation logic.
--
-- --=================================================================*/

/**********************************************************************/
/*********************** Function Declarations ************************/
/**********************************************************************/
void SlotTxIntTest(int ChannelNo,int32 RegSlotValid);

/**********************************************************************/
/********************** Slot Tx Interrupt Tests ***********************/
/**********************************************************************/
void AACISnTXINTRTests(void)
{
 /*
   Summary : AACISnTXINTRTests
   ===========================
   This section of the code tests the AACISnTXINTR [n = 1, 2, 12]
   Interrupt generation logic. This function calls the SlotTxIntTest() 
   function multiple times, each time with a different set of arguments.
   Each function call tests a specific slot register of the AACI.
 
 */

 int One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 C(" SLOT REGISTER 12 TX INTERRUPT TEST");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 SlotTxIntTest(Channel_2,AACI_TX12);
 C(" END OF SLOT REGISTER 12 TX INTERRUPT TEST");

 C(" SLOT REGISTER 2 TX INTERRUPT TEST");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 SlotTxIntTest(Channel_1,AACI_TX2);
 C("END OF SLOT REGISTER 2 TX INTERRUPT TEST");

 C(" SLOT REGISTER 1 TX INTERRUPT TEST");
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 SlotTxIntTest(Channel_3,AACI_TX1);
 C("END OF SLOT REGISTER 1 TX INTERRUPT TEST");
}

/**********************************************************************/
/********************** Slot Tx Interrupt Test ************************/
/**********************************************************************/
void SlotTxIntTest(int ChannelNo,int32 RegSlotValid)
{
 /*
   Summary : SlotTxIntTest
   =======================
   This section of the code tests the AACISnTXINTR [n = 1 to 4] 
   Interrupt generation logic. The test sequence is as follows :
   - The SLOTnTXINTE [n = 1,2 or 12] bit is enabled in the AACISLIEN
     register. The AACI is programmed such that none of the channels 
     hold data for Slots 1, 2 or 12.
   - The AACISLnTX [n = 1, 2, 12] register is enabled by writing to the 
     AACIMAINCR register. The AACITXCRn [n = 1 to 4] is programmed for 3
     valid slots. 
   - Then, the AACITrIntrReg register is read to verify that the 
     AACISnTXINTR [n = 1,2 or 12] interrupt is initially raised. Also 
     the AACISLFR, AACISLISTAT and AACIALLINTS registers are checked. 
   - Three words of datas are written into the Tx FIFO of the AACI and 
     it is verified that the interrupt is not cleared. Then the 
     SnTXE [n = 1, 2, 12] bit in the AACIMAINCR register is cleared thus
     disabling the transmission from that Slot register. This should not
     clear the AACISnTXINTR [n = 1, 2, 12] interrupt. This is verified 
     by reading the AACITrIntrReg register and the interrupt status 
     registers in the AACI. 
   - Again the SnTXE [n = 1, 2, 12] is set to enable that Slot register 
     for transmission. The SLOTnTXBUSY[n = 1, 2, 12]  bit in the 
     AACISLFR register is read to verify that it is not set as the 
     AACISLnTX register is still not written with any data and is empty.
   - Then, data is written in to the AACISLnTX [n = 1, 2 or 12] register
     and the AACISnTXINTR [n =1, 2, or 12] interrupt is checked for 
     being cleared. The SLOTnTXBUSY [n = 1, 2, 12] bit in the AACISLFR 
     register is also read to verify that it is set. 
   - Then data transmission is enabled. Data from the AACISLnTX 
     [n = 1,2 or 12] register is expected to be copied into the Transmit
     shift register of the AACI, thereby rendering the AACISLnTX 
     [n = 1,2 or 12] register empty. The AACITrIntrReg is read to verify
     that the AACISnTXINTR [n = 1,2 or 12] interrupt is raised. Also
     the AACISLFR, AACISLISTAT and AACIALLINTS registers are checked.
   - This interrupt is cleared with a single write to the AACISLnTX 
     [n = 1,2 or 12] register.

   This test is repeated by clearing the SLOTnTXINTE [n = 1,2 or 12] 
   bit in the AACISLIEN register. The interrupt is not expected to get 
   set when it is masked. Also, it is confirmed that setting Interrupt 
   enable bit again results in the assertion of this interrupt.

 */

 int32 ChValidSlot, ChRegValidSlot;
 int   i, One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int32 Poll_Value;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 /* Enable the AACISLnTXINTR (n = 1, 2 or 12) Interrupt */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      PSW(AACI_SL12TXINTE, AACISLIEN);
      break;
     case AACI_TX2 :
      PSW(AACI_SL2TXINTE, AACISLIEN);
      break;
     case AACI_TX1 :
      PSW(AACI_SL1TXINTE, AACISLIEN);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Enable transmission through slot register by writing to the
    AACIMAINCR register */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      PSW(AACI_S12TXE | AACI_AACIIFE, AACIMAINCR);
      break;
     case AACI_TX2 :
      PSW(AACI_S2TXE | AACI_AACIIFE, AACIMAINCR);
      break;
     case AACI_TX1 :
      PSW(AACI_S1TXE | AACI_AACIIFE, AACIMAINCR);
      break;
    default :
      C("Invalid slot register number");
   }

 /* When slot 2 has to be transmitted slot1 is also required to be
    transmitted */
 if (RegSlotValid == AACI_TX2)
   {
    ChValidSlot    = AACI_TX1 | AACI_TX6 | AACI_TX9;
    }
  else
    {
     ChValidSlot    = AACI_TX4 | AACI_TX6 | AACI_TX9;
    }

 /* Configure the AACITXCRn [n = 1 to 4] registers */
 ConfigTxCR(ChannelNo, ChValidSlot | AACI_FEN | AACI_TSIZE20);

 /* Calculate the slot numbers for which the test will be done */
 if (RegSlotValid == AACI_TX2)
   {
    ChRegValidSlot = AACI_TX1 | AACI_TX6 | AACI_TX9 | RegSlotValid;
    }
  else
    {
     ChRegValidSlot = AACI_TX4 | AACI_TX6 | AACI_TX9 | RegSlotValid;
    }

 /* Write transmit data for first frame into trickbox Transmit FIFO */
 FrameWrite (ChannelNo, ChValidSlot, AACI_TSIZE20);

 /* Writing the next frame as the valid frame ('CODEC Ready' bit set,
    but none of the slots are valid) */
 PSW(0x80000, AACITrTxFIFO);
 for (i = 0; i < 12; i = i + 1)
   {
    PSW(0x00000, AACITrTxFIFO);
   }

 /* Verify that the AACISLnTXINR [n = 1, 2, 12] interrupt is set */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      CheckSlIntrSet(12,1);
      break;
     case AACI_TX2 :
      CheckSlIntrSet(2,1);
      break;
     case AACI_TX1 :
      CheckSlIntrSet(1,1);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Disable transmission through slot register by writing to the
    AACIMAINCR register */
 PSW(AACI_AACIIFE, AACIMAINCR);
 
 /* Verify that the AACISLnTXINR [n = 1, 2, 12] interrupt is set */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      CheckSlIntrSet(12,1);
      break;
     case AACI_TX2 :
      CheckSlIntrSet(2,1);
      break;
     case AACI_TX1 :
      CheckSlIntrSet(1,1);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Enable transmission through slot register by writing to the
    AACIMAINCR register */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      PSW(AACI_S12TXE | AACI_AACIIFE, AACIMAINCR);
      break;
     case AACI_TX2 :
      PSW(AACI_S2TXE | AACI_AACIIFE, AACIMAINCR);
      break;
     case AACI_TX1 :
      PSW(AACI_S1TXE | AACI_AACIIFE, AACIMAINCR);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Verify that the SLnTXBUSY [n = 1, 2, 12] bits are cleared */
 PSR(0x0, AACI_SL12TXBUSY | AACI_SL2TXBUSY | AACI_SL1TXBUSY, AACISLFR,AACI1_TxBusyCheck);

 /* Write data into the Channel FIFO for transmission */
 TxFIFOFill(ChannelNo, ChValidSlot, AACI_FEN | AACI_TSIZE20);

 /* Verify that the AACISLnTXINR [n = 1, 2, 12] interrupt is not 
    cleared */
 switch (RegSlotValid)
   {
    case AACI_TX12 :
      CheckSlIntrSet(12,1);
      break;
    case AACI_TX2 :
      CheckSlIntrSet(2,1);
      break;
    case AACI_TX1 :
      CheckSlIntrSet(1,1);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Write transmit data into the slot register */
 switch (RegSlotValid)
   {
    case AACI_TX12 :
      PSW(WriteData[11], AACISL12TX);
      break;
    case AACI_TX2 :
      PSW(WriteData[1], AACISL2TX);
      break;
    case AACI_TX1 :
      PSW(WriteData[0], AACISL1TX);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Verify that the SLnTXBUSY [n = 1, 2, 12] bit is set */
 switch (RegSlotValid)
   {
    case AACI_TX12 :
      PSR(AACI_SL12TXBUSY, AACI_SL12TXBUSY , AACISLFR,AACI1_TxBusyCheck);
      break;
    case AACI_TX2 :
      PSR(AACI_SL2TXBUSY, AACI_SL2TXBUSY , AACISLFR,AACI1_TxBusyCheck);
      break;
    case AACI_TX1 :
      PSR(AACI_SL1TXBUSY, AACI_SL1TXBUSY, AACISLFR,AACI1_TxBusyCheck);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Verify that the AACISLnTXINR [n = 1, 2, 12] interrupt is cleared */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      CheckSlIntrClr(12,1,0);
      break;
     case AACI_TX2 :
      CheckSlIntrClr(2,1,0);
      break;
     case AACI_TX1 :
      CheckSlIntrClr(1,1,0);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Enable data transfer */
 ConfigTxCR(ChannelNo, ChValidSlot | AACI_FEN | AACI_TSIZE20| AACI_TEN);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn | AACITB_TxEn | AACITB_RxEn,AACITrCntlReg);

 /* Poll for the start of the second frame */
 PO(0x000C0000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Disable trickbox transmission and reception */
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Calculate poll value to determine the point at which the
    SLnTXBUSY [n = 1, 2, 12] bit is expected to be low, The Tx FIFO in
    the trickbox is polled for this value */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      Poll_Value = 0x00000000;
      break;
     case AACI_TX2 :
      Poll_Value = 0x000A0000;
      break;
     case AACI_TX1 :
      Poll_Value = 0x000B0000;
      break;
    default :
      C("Invalid slot register number");
   }
 PO(Poll_Value, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);
 PI(One_BitClk_Period * 24);

 /* Verify that the SLnTXBUSY [n = 1, 2, 12] bit is cleared */
 switch (RegSlotValid)
   {
    case AACI_TX12 :
      PSR(0x0, AACI_SL12TXBUSY , AACISLFR,AACI1_TxBusyCheck);
      break;
    case AACI_TX2 :
      PSR(0x0, AACI_SL2TXBUSY , AACISLFR,AACI1_TxBusyCheck);
      break;
    case AACI_TX1 :
      PSR(0x0, AACI_SL1TXBUSY, AACISLFR,AACI1_TxBusyCheck);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Verify that the AACISLnTXINTR [n = 1, 2, 12] interrupt is set */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      CheckSlIntrSet(12,1);
      break;
     case AACI_TX2 :
      CheckSlIntrSet(2,1);
      break;
     case AACI_TX1 :
      CheckSlIntrSet(1,1);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Waiting for that frame to complete */
 PO(0x0, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);
 PI(One_BitClk_Period * 24);

 /* Disable Transmission and Reception */
 ConfigTxCR(ChannelNo, ChValidSlot | AACI_FEN | AACI_TSIZE20);

 /* Repeat the test with the AACITXCINTRn [n = 1 to 4] Interrupt
    masked. */

 /* Disable the AACISLnTXINTR (n = 1, 2 or 12) Interrupt */
 PSW(0x0, AACISLIEN);

 /* Verify that the AACISLnTXINR [n = 1, 2, 12] interrupt is not set */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      CheckSlIntrClr(12,1,1);
      break;
     case AACI_TX2 :
      CheckSlIntrClr(2,1,1);
      break;
     case AACI_TX1 :
      CheckSlIntrClr(1,1,1);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Write data into the Channel FIFO for transmission */
 TxFIFOFill(ChannelNo, ChValidSlot, AACI_FEN | AACI_TSIZE20);

 /* Verify that the AACISLnTXINR [n = 1, 2, 12] interrupt is not set */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      CheckSlIntrClr(12,1,1);
      break;
     case AACI_TX2 :
      CheckSlIntrClr(2,1,1);
      break;
     case AACI_TX1 :
      CheckSlIntrClr(1,1,1);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Enable the AACISLnTXINTR (n = 1, 2 or 12) Interrupt */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      PSW(AACI_SL12TXINTE, AACISLIEN);
      break;
     case AACI_TX2 :
      PSW(AACI_SL2TXINTE, AACISLIEN);
      break;
     case AACI_TX1 :
      PSW(AACI_SL1TXINTE, AACISLIEN);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Verify that the AACISLnTXINR [n = 1, 2, 12] interrupt is set */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      CheckSlIntrSet(12,1);
      break;
     case AACI_TX2 :
      CheckSlIntrSet(2,1);
      break;
     case AACI_TX1 :
      CheckSlIntrSet(1,1);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Clear the interrupt */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      PSW(WriteData[11], AACISL12TX);
      break;
     case AACI_TX2 :
      PSW(WriteData[1], AACISL2TX);
      break;
     case AACI_TX1 :
      PSW(WriteData[0], AACISL1TX);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Write transmit data for first frame into trickbox Transmit FIFO */
 FrameWrite (ChannelNo, ChValidSlot, AACI_TSIZE20);

 /* Writing the next frame as the valid frame ('CODEC Ready' bit set,
    but none of the slots are valid) */
 PSW(0x80000, AACITrTxFIFO);
 for (i = 0; i < 12; i = i + 1)
   {
    PSW(0x00000, AACITrTxFIFO);
   }

 /* Enable data transfer */
 ConfigTxCR(ChannelNo, ChValidSlot | AACI_FEN | AACI_TSIZE20| AACI_TEN);
 PSW(AACITB_En | AACITB_RxEn | AACITB_BtClkRst | AACITB_BtClkEn | AACITB_TxEn,AACITrCntlReg);

 /* Poll for the start of the second frame */
 PO(0x000C0000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Disable the trickbox reception and reception */
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Calculate poll value to determine the point at which the
    SLnTXBUSY [n = 1, 2, 12] bit is expected to be low, The Tx FIFO in
    the trickbox is polled for this value */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      Poll_Value = 0x00000000;
      break;
     case AACI_TX2 :
      Poll_Value = 0x000A0000;
      break;
     case AACI_TX1 :
      Poll_Value = 0x000B0000;
      break;
    default :
      C("Invalid slot register number");
   }
 PO(Poll_Value, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);
 PI(One_BitClk_Period * 24);

 /* Verify that the SLnTXBUSY [n = 1, 2, 12] bit is cleared */
 switch (RegSlotValid)
   {
    case AACI_TX12 :
      PSR(0x0, AACI_SL12TXBUSY , AACISLFR,AACI1_TxBusyCheck);
      break;
    case AACI_TX2 :
      PSR(0x0, AACI_SL2TXBUSY , AACISLFR,AACI1_TxBusyCheck);
      break;
    case AACI_TX1 :
      PSR(0x0, AACI_SL1TXBUSY, AACISLFR,AACI1_TxBusyCheck);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Verify that the AACISLnTXINTR [n = 1, 2, 12] interrupt is set */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      CheckSlIntrSet(12,1);
      break;
     case AACI_TX2 :
      CheckSlIntrSet(2,1);
      break;
     case AACI_TX1 :
      CheckSlIntrSet(1,1);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Waiting for that frame to complete */
 PO(0x0, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);
 PI(One_BitClk_Period * 24);

 /* Disable the trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Disable the AACISLnTXINTR (n = 1, 2 or 12) Interrupt */
 PSW(0x0, AACISLIEN);

 /* Verify that SLOTnTX (n = 1, 2 or 12) Interrupt is cleared due
    to masking */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      CheckSlIntrClr(12,1,1);
      break;
     case AACI_TX2 :
      CheckSlIntrClr(2,1,1);
      break;
     case AACI_TX1 :
      CheckSlIntrClr(1,1,1);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Enable AACISLnTXINTR (n = 1, 2 or 12) interrupt */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      PSW(AACI_SL12TXINTE, AACISLIEN);
      break;
     case AACI_TX2 :
      PSW(AACI_SL2TXINTE, AACISLIEN);
      break;
     case AACI_TX1 :
      PSW(AACI_SL1TXINTE, AACISLIEN);
      break;
    default :
      C("Invalid slot register number");
   }
 PI(0x2);

 /* Verify that the AACISLnTXINR [n = 1, 2, 12] interrupt is set */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      CheckSlIntrSet(12,1);
      break;
     case AACI_TX2 :
      CheckSlIntrSet(2,1);
      break;
     case AACI_TX1 :
      CheckSlIntrSet(1,1);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Verify the effect of disabling the AACI on the AACISLnTXINTR 
    [n = 1, 2, 12]. The interrupt is expected to be cleared when the
    AACI is disabled */

 /* Disable AACI */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      PSW(AACI_S12TXE, AACIMAINCR);
      break;
     case AACI_TX2 :
      PSW(AACI_S2TXE, AACIMAINCR);
      break;
     case AACI_TX1 :
      PSW(AACI_S1TXE, AACIMAINCR);
      break;
    default :
      C("Invalid slot register number");
   }
 PI(0x2);

 /* Verify that AACISLnTXINR [n = 1, 2, 12] interrupt is cleared since
    the AACI has been disabled */
 switch (RegSlotValid)
   {
     case AACI_TX12 :
      CheckSlIntrClr(12,1,1);
      break;
     case AACI_TX2 :
      CheckSlIntrClr(2,1,1);
      break;
     case AACI_TX1 :
      CheckSlIntrClr(1,1,1);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Disable transmission from the channels */
 ConfigTxCR(ChannelNo, 0x0);
 PI(One_BitClk_Period * 3);

 /* Verify data transmitted by the AACI */

 /* The first frame transmitted by the AACI should be invalid */
 for (i = 0 ; i < 13 ; i++ )
   {
    PSR(0x0, 0xFFFFF, AACITrRxFIFO,RdInvalid);
   }
    
 /* Reading the valid frame from the trickbox */
 switch (ChannelNo)
   {
    case 1 :
      TrRxFIFORd(ChRegValidSlot, 0x0, 0x0, 0x0,
                  AACI_TSIZE20, 0x0, 0x0, 0x0);
      break;
    case 2 :
      TrRxFIFORd(0x0, ChRegValidSlot, 0x0, 0x0,
                  0x0, AACI_TSIZE20, 0x0, 0x0);
      break;
    case 3 :
      TrRxFIFORd(0x0, 0x0, ChRegValidSlot, 0x0,
                  0x0, 0x0, AACI_TSIZE20, 0x0);
      break;
    case 4 :
      TrRxFIFORd(0x0, 0x0, 0x0, ChRegValidSlot,
                  0x0, 0x0, 0x0, AACI_TSIZE20);
      break;
    default :
      C("InCorrect Channel Number");
   }

 /* Third frame is invalid */
 for (i = 0 ; i < 13 ; i++ )
   {
    PSR(0x0, 0xFFFFF, AACITrRxFIFO,RdInvalid);
   }

 /* Reading the valid frame from the trickbox */
 switch (ChannelNo)
   {
    case 1 :
      TrRxFIFORd(ChRegValidSlot, 0x0, 0x0, 0x0,
                  AACI_TSIZE20, 0x0, 0x0, 0x0);
      break;
    case 2 :
      TrRxFIFORd(0x0, ChRegValidSlot, 0x0, 0x0,
                  0x0, AACI_TSIZE20, 0x0, 0x0);
      break;
    case 3 :
      TrRxFIFORd(0x0, 0x0, ChRegValidSlot, 0x0,
                  0x0, 0x0, AACI_TSIZE20, 0x0);
      break;
    case 4 :
      TrRxFIFORd(0x0, 0x0, 0x0, ChRegValidSlot,
                  0x0, 0x0, 0x0, AACI_TSIZE20);
      break;
    default :
      C("InCorrect Channel Number");
   }
}
/********************* End of AACISnTXINTRTests.c *********************/
