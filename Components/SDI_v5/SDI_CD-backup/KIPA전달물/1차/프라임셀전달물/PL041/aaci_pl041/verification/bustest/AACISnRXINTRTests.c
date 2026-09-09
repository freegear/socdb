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
-- File Name              : AACISnRXINTRTests.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This section of the code tests the AACISnRXINTR 
--           [n = 1, 2, 12] Interrupt generation logic.
--
-- --=================================================================*/

/**********************************************************************/
/*********************** Function Declarations ************************/
/**********************************************************************/
void SlotRxIntTest(int ChannelNo, int32 RegSlotValid);

/**********************************************************************/
/********************** Slot Rx Interrupt Tests ***********************/
/**********************************************************************/
void AACISnRXINTRTests(void)
 {
 /*
   Summary : AACISnRXINTRTests
   ===========================
   This section of the code tests the AACISnRXINTR [n = 1, 2, 12]
   Interrupt generation logic. This function calls the SlotRxIntTest()
   function multiple times, each time with a different set of arguments.
   Each function call tests a specific slot register of the AACI.
 
 */

  int One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;

  if (AACIBITCLK_PERIOD < PCLK_PERIOD)
     One_BitClk_Period = 0x1;

  C(" SLOT REGISTER 12 RX INTERRUPT TEST");
  PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  PI(One_BitClk_Period * 16);
  PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  SlotRxIntTest(Channel_1,AACI_RX12);
  C(" END OF SLOT REGISTER 12 RX INTERRUPT TEST");

  C(" SLOT REGISTER 2 RX INTERRUPT TEST");
  PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  PI(One_BitClk_Period * 16);
  PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  SlotRxIntTest(Channel_3,AACI_RX2);
  C(" SLOT REGISTER 2 RX INTERRUPT TEST");
  C(" SLOT REGISTER 1 RX INTERRUPT TEST");
  PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  PI(One_BitClk_Period * 16);
  PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  SlotRxIntTest(Channel_4,AACI_RX1);
  C(" END OF SLOT REGISTER 1 RX INTERRUPT TEST");
 }

/**********************************************************************/
/********************** Slot Rx Interrupt Tests ***********************/
/**********************************************************************/
void SlotRxIntTest(int ChannelNo, int32 RegSlotValid)
{
 /*
   Summary : SlotRxIntTest
   =======================
            The SLOTnRXINTE [n = 1,2 or 12] bit is enabled in the
 AACISLIEN Register. The AACI is programmed such that none of the
 AACIRXCR1-4 registers have the SLOT n Enable bits [n = 1,2 or 12] set.
 The AACISLnRX [n = 1,2 or 12]register is enabled by writing to the
 AACIMAINCR register. The Tx FIFO in the Trickbox is loaded with data
 for one frame within which slot3, slot 6, slot8, and slot n, (where n
 is the slot number - either 1, 2 or 12 - for which this test is being
 called) are valid slots. After the reception of the new SLOT data, the
 AACITrIntrReg is tested to verify that the AACISnRXINTR [n = 1,2 or 12]
 interrupt is raised. Also, the AACISLFR, AACISLISTAT and AACIALLINTS
 registers are checked to verify the interrupt status.
 Reading the data in the AACISLnRX [n = 1,2 or 12]register clears this
 interrupt. This is confirmed by reading the Interrupt status registers.

 This test is repeated for 2 frames of reception.
 Data received for the slot n [n = 1,2 or 12] register in the first
 frame is not read until the next data for that register in the next
 frame is about to be written. 
 When the second data received is about to be written to the AACISLnRX
 [n = 1,2 or 12] register, a read is deterministically initiated to read
 out the first received data. In this case, the interrupt is expected to
 remain set to indicate the presence of new data.

 This test is repeated after disabling the SLOTnRXINTE [n = 1,2 or 12]
 bit in the AACISLIEN register. The interrupt is not expected to get set
 when it is masked. Also, it is confirmed that setting interrupt enableo
 bit results in the assertion of this interrupt.

 */

 int32 ChValidSlot, ChRegValidSlot;
 int   i, One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int32 Poll_Value, ReadData;
 
 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 /* Enable the desired AACISnRXINTR [n = 1, 2, 12] interrupt */
 switch (RegSlotValid)
   {
    case AACI_RX12 :
      PSW(AACI_SL12RXINTE, AACISLIEN);
      break;
    case AACI_RX2 :
      PSW(AACI_SL2RXINTE, AACISLIEN);
      break;
    case AACI_RX1 :
      PSW(AACI_SL1RXINTE, AACISLIEN);
      break;
    default :
      C("Invalid slot register number");
   }
 
 /* Enable the AACI and set the desired SnRXE [n = 1, 2, 12] bit */ 
 switch (RegSlotValid)
   {
    case AACI_RX12 :
      PSW(AACI_S12RXE | AACI_AACIIFE, AACIMAINCR);
      break;
    case AACI_RX2 :
      PSW(AACI_S2RXE | AACI_AACIIFE, AACIMAINCR);
      break;
    case AACI_RX1 :
      PSW(AACI_S1RXE | AACI_AACIIFE, AACIMAINCR);
      break;
    default :
      C("Invalid slot register number");
   }


 ChValidSlot = AACI_TX3 | AACI_TX4 | AACI_TX6;

 ChRegValidSlot = AACI_TX3 | AACI_TX4 | AACI_TX6 | RegSlotValid;

 ConfigRxCR(ChannelNo, ChValidSlot | AACI_TSIZE20 | AACI_FEN| AACI_REN);

 /* Fill Trickbox with data for one frame */
 FrameWrite (ChannelNo, ChRegValidSlot, AACI_TSIZE20);

 /* Fill Trickbox with data for the next frame - all slots in this
    frame are invalid, but the frame valid bit is set */
 PSW(0x80000, AACITrTxFIFO);
 for (i = 0; i < 12; i = i + 1)
   {
    PSW(0x00000, AACITrTxFIFO);
   } 

 /* Enable Trickbox for Transmission and AACI RxFIFO for Reception */
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn | AACITB_TxEn,AACITrCntlReg);

 /* Waiting for the frame to start */
 PO(0x00170000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Verifying the busy status of the AACISLnRX [n = 1, 2, 12] 
    register */
 switch (RegSlotValid)
   {
    case AACI_RX12 :
      PSR(AACI_SL12RXBUSY, AACI_SL12RXBUSY , AACISLFR,AACI1_RxBsyCheck_1);
      break;
    case AACI_RX2 :
      PSR(AACI_SL2RXBUSY, AACI_SL2RXBUSY , AACISLFR,AACI1_RxBsyCheck_1);
      break;
    case AACI_RX1 :
      PSR(AACI_SL1RXBUSY, AACI_SL1RXBUSY , AACISLFR,AACI1_RxBsyCheck_1);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Waiting for the frame to complete and the next frame to start */
 PO(0x000B0000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Verifying the busy status of the Rx slot register */
 switch (RegSlotValid)
   {
    case AACI_RX12 :
      PSR(AACI_SL12RXBUSY, AACI_SL12RXBUSY , AACISLFR,AACI1_RxBsyCheck_2);
      break;
    case AACI_RX2 :
      PSR(AACI_SL2RXBUSY, AACI_SL2RXBUSY , AACISLFR,AACI1_RxBsyCheck_2);
      break;
    case AACI_RX1 :
      PSR(AACI_SL1RXBUSY, AACI_SL1RXBUSY , AACISLFR,AACI1_RxBsyCheck_2);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Disable Trickbox Transmission and AACI RxFIFO Reception */
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 ConfigRxCR(ChannelNo, ChValidSlot | AACI_TSIZE20 | AACI_FEN);

 /* Waiting for the next frame to complete */
 PO(0x0, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Verify that the AACISLnRXINTR [n = 1, 2, 12] interrupt is set */
 switch (RegSlotValid)
   {
    case AACI_RX12 :
      CheckSlIntrSet(12,0);
      break;
    case AACI_RX2 :
      CheckSlIntrSet(2,0);
      break;
    case AACI_RX1 :
      CheckSlIntrSet(1,0);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Verifying the busy status of the AACISLnRX [n = 1, 2, 12] register 
    even after 2 frames of reception */
 switch (RegSlotValid)
   {
    case AACI_RX12 :
      PSR(AACI_SL12RXBUSY, AACI_SL12RXBUSY , AACISLFR,AACI1_RxBsyCheck_3);
      break;
    case AACI_RX2 :
      PSR(AACI_SL2RXBUSY, AACI_SL2RXBUSY , AACISLFR,AACI1_RxBsyCheck_3);
      break;
    case AACI_RX1 :
      PSR(AACI_SL1RXBUSY, AACI_SL1RXBUSY , AACISLFR,AACI1_RxBsyCheck_3);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Calculate expected value for reads from AACISLnRX [n = 1, 2, 12]
    registers */
 switch (RegSlotValid)
   {
    case AACI_RX12 :
      ReadData = WriteData[11] & Mask_Size[AACI_RSIZE20 >>13];
      break;
    case AACI_RX2 :
      ReadData = WriteData[1] & Mask_Size[AACI_RSIZE20 >>13];
      break;
    case AACI_RX1 :
      ReadData = WriteData[0] & Mask_Size[AACI_RSIZE20 >>13];
      break;
    default :
      C("Invalid slot register number");
   }

 ReadData = ReadData << Shift_Count[AACI_RSIZE20 >>13];

 /* Reading the data from the AACISLnRX [n = 1, 2, 12] register */
 switch (RegSlotValid)
   {
    case AACI_RX12 :
      PSR(ReadData, MASK_ALL, AACISL12RX,RX12_T624);
      break;
    case AACI_RX2 :
      PSR(ReadData, MASK_ALL, AACISL2RX,RX2_T624);
      break;
    case AACI_RX1 :
      PSR(ReadData, MASK_ALL, AACISL1RX,RX1_T624);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Verifying the non-busy status of the AACISLnRX [n = 1, 2, 12] 
    register */
 PSR(0x0, AACI_SL12RXBUSY | AACI_SL2RXBUSY | AACI_SL1RXBUSY , AACISLFR,AACI1_RxBsyCheck);

 /* Verify that the AACISLnRXINTR [n = 1, 2, 12] interrupt is 
    cleared */
 switch (RegSlotValid)
   {
    case AACI_RX12 :
      CheckSlIntrClr(12,0,0);
      break;
    case AACI_RX2 :
      CheckSlIntrClr(2,0,0);
      break;
    case AACI_RX1 :
      CheckSlIntrClr(1,0,0);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Waiting for the second frame to complete */
 PO(0x00000000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Boundary condition check to verify that the AACISLnRXINTR 
    [n = 1, 2, 12] remains set when there is a read from the AACISLnRX
    [n = 1, 2, 12] register just before a write happens. This test uses
    deterministic delays and hence is run only for the fixed case of 
    (PCLK period = 10 ns) and (AACIBITCLK period = 80 ns) */

if ((PCLK_PERIOD == 10) && (AACIBITCLK_PERIOD == 80))
  {
   /* Write data for 2 frames into the trickbox */
   FrameWrite (ChannelNo, ChRegValidSlot, AACI_TSIZE20); /* 1st Frame */
   FrameWrite (ChannelNo, ChRegValidSlot, AACI_TSIZE20); /* 2nd Frame */
   PSW(0x80000, AACITrTxFIFO, Third_FrameValidBit);
  
   /* Enable Trickbox for Transmission and AACI RxFIFO for Reception */
   ConfigRxCR(ChannelNo, ChValidSlot | AACI_TSIZE20 | AACI_FEN| AACI_REN);
   PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn | AACITB_TxEn,AACITrCntlReg);
  
   /* Waiting for half of the second frame to complete */
   PO(0xD0000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);
   switch (RegSlotValid)
     {
      case AACI_RX12 :
        Poll_Value = 0x00010000;
        break;
      case AACI_RX2 :
        Poll_Value = 0x000B0000;
        break;
      case AACI_RX1 :
        Poll_Value = 0x000C0000;
        break;
      default :
        C("Invalid slot register number");
     }
  
   /* Waiting for the slot to complete */
   PO(Poll_Value, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);
  
   /* Calculate expected value for reads from AACISLnRX [n = 1, 2, 12]
      registers */
   switch (RegSlotValid)
     {
      case AACI_RX12 :
        ReadData = WriteData[11] & Mask_Size[AACI_RSIZE20 >>13];
        break;
      case AACI_RX2 :
        ReadData = WriteData[1] & Mask_Size[AACI_RSIZE20 >>13];
        break;
      case AACI_RX1 :
        ReadData = WriteData[0] & Mask_Size[AACI_RSIZE20 >>13];
        break;
      default :
        C("Invalid slot register number");
     }
   ReadData = ReadData << Shift_Count[AACI_RSIZE20 >>13];

   /* Deterministic no. of idle cycles */
   PI(0x9F);

   switch (RegSlotValid)
     {
      case AACI_RX12 :
        PSR(ReadData, MASK_ALL, AACISL12RX,RX12_T626);
        break;
      case AACI_RX2 :
        PSR(ReadData, MASK_ALL, AACISL2RX,RX2_T626);
        break;
      case AACI_RX1 :
        PSR(ReadData, MASK_ALL, AACISL1RX,RX1_T626);
        break;
      default :
        C("Invalid slot register number");
     }
  
   /* Waiting for the Slotn (n = 1, 2, or 12) in the receive frame to 
      be completely received and written in to the AACISLOTnRX 
      (n = 1, 2, or 12) register.
      This time period for waiting is one slot period (20 AACIBITCLK
      periods) + synchronisation period from AACIBITCLK to PCLK 
      domain */
  
   PI(0x23);
  
   /* Verify that the AACISLnRXINTR [n = 1, 2, 12] interrupt is 
      set */
   switch (RegSlotValid)
     {
      case AACI_RX12 :
        CheckSlIntrSet(12,0);
        break;
      case AACI_RX2 :
        CheckSlIntrSet(2,0);
        break;
      case AACI_RX1 :
        CheckSlIntrSet(1,0);
        break;
      default :
        C("Invalid slot register number");
     }
  
   /* Calculate expected value for reads from AACISLnRX [n = 1, 2, 12]
      registers */
   switch (RegSlotValid)
     {
      case AACI_RX12 :
        ReadData = WriteData[11] & Mask_Size[AACI_RSIZE20 >>13];
        break;
      case AACI_RX2 :
        ReadData = WriteData[1] & Mask_Size[AACI_RSIZE20 >>13];
        break;
      case AACI_RX1 :
        ReadData = WriteData[0] & Mask_Size[AACI_RSIZE20 >>13];
        break;
      default :
        C("Invalid slot register number");
     }
   ReadData = ReadData << Shift_Count[AACI_RSIZE20 >>13];
  
   switch (RegSlotValid)
     {
      case AACI_RX12 :
        PSR(ReadData, MASK_ALL, AACISL12RX,RX12_T625);
        break;
      case AACI_RX2 :
        PSR(ReadData, MASK_ALL, AACISL2RX,RX2_T625);
        break;
      case AACI_RX1 :
        PSR(ReadData, MASK_ALL, AACISL1RX,RX1_T625);
        break;
      default :
        C("Invalid slot register number");
     }
  
   /* Verify that the AACISLnRXINTR [n = 1, 2, 12] interrupt is 
      cleared */
   switch (RegSlotValid)
     {
       case AACI_RX12 :
        CheckSlIntrClr(12,0,0);
        break;
       case AACI_RX2 :
        CheckSlIntrClr(2,0,0);
        break;
       case AACI_RX1 :
        CheckSlIntrClr(1,0,0);
        break;
      default :
        C("Invalid slot register number");
     }

   /* Wait for completion of the frame */
   PO(0x00000000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);
   PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   PI(One_BitClk_Period * 16);
  }

 /* Repeat the test with the SLOTnRXINTE [n = 1, 2, 12] bit in the 
    AACISLIEN register cleared. It is expected that the AACISLnRXINTR
    [n = 1, 2, 12] interrupt should not be asserted */
   
 /* Clear the  SLOTnRXINTE [n = 1, 2, 12] bit in the AACISLIEN 
    register */
 PSW(0x0, AACISLIEN);

 /* Enable reception into AACISLnRX [n = 1, 2, 12] register */
 switch (RegSlotValid)
   {
     case AACI_RX12 :
      PSW(AACI_S12RXE | AACI_AACIIFE, AACIMAINCR);
      break;
     case AACI_RX2 :
      PSW(AACI_S2RXE | AACI_AACIIFE, AACIMAINCR);
      break;
     case AACI_RX1 :
      PSW(AACI_S1RXE | AACI_AACIIFE, AACIMAINCR);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Fill Trickbox with data for one frame */
 FrameWrite (ChannelNo, ChRegValidSlot, AACI_TSIZE20);

 /* Fill Trickbox with data for the next frame - all slots in this
    frame are invalid, but the frame valid bit is set */
 PSW(0x80000, AACITrTxFIFO);
 for (i = 0; i < 12; i = i + 1)
   {
    PSW(0x00000, AACITrTxFIFO);
   }

 /* Enable Trickbox for Transmission and AACI RxFIFO for Reception */
 ConfigRxCR(ChannelNo, ChValidSlot | AACI_TSIZE20 | AACI_FEN| AACI_REN);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn | AACITB_TxEn,AACITrCntlReg);

 /* Waiting for the frame to complete */
 PO(0x000B0000, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Disable Trickbox Transmission and AACI RxFIFO Reception */
 ConfigRxCR(ChannelNo, ChValidSlot | AACI_TSIZE20 | AACI_FEN);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn,AACITrCntlReg);

 /* Verify that the AACISLnRXINTR [n = 1, 2, 12] interrupt is 
    cleared */
 switch (RegSlotValid)
   {
     case AACI_RX12 :
      CheckSlIntrClr(12,0,1);
      break;
     case AACI_RX2 :
      CheckSlIntrClr(2,0,1);
      break;
     case AACI_RX1 :
      CheckSlIntrClr(1,0,1);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Enable the desired AACISnRXINTR [n = 1, 2, 12] interrupt */
 switch (RegSlotValid)
   {
     case AACI_RX12 :
      PSW(AACI_SL12RXINTE, AACISLIEN);
      break;
     case AACI_RX2 :
      PSW(AACI_SL2RXINTE, AACISLIEN);
      break;
     case AACI_RX1 :
      PSW(AACI_SL1RXINTE, AACISLIEN);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Verify that the AACISLnRXINTR [n = 1, 2, 12] interrupt is set */
 switch (RegSlotValid)
   {
     case AACI_RX12 :
      CheckSlIntrSet(12,0);
      break;
     case AACI_RX2 :
      CheckSlIntrSet(2,0);
      break;
     case AACI_RX1 :
      CheckSlIntrSet(1,0);
      break;
    default :
      C("Invalid slot register number");
   }
 
 /* Wait for completiion of the last frame */
 PO(0x0, MASK_TxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Disable the AACI with the SnRXE [n = 1, 2, 12] bits 
    remaining set in the AACIMAINCR register */
 switch (RegSlotValid)
   {
     case AACI_RX12 :
      PSW(AACI_S12RXE, AACIMAINCR);
      break;
     case AACI_RX2 :
      PSW(AACI_S2RXE, AACIMAINCR);
      break;
     case AACI_RX1 :
      PSW(AACI_S1RXE, AACIMAINCR);
      break;
    default :
      C("Invalid slot register number");
   }
 PI(0x2);

 /* Verify that the AACISLnRXINTR [n = 1, 2, 12] interrupt is 
    cleared */
 switch (RegSlotValid)
   {
     case AACI_RX12 :
      CheckSlIntrClr(12,0,0);
      break;
     case AACI_RX2 :
      CheckSlIntrClr(2,0,0);
      break;
     case AACI_RX1 :
      CheckSlIntrClr(1,0,0);
      break;
    default :
      C("Invalid slot register number");
   }

 /* Disable AACI */
 PSW(0x0, AACIMAINCR);

 /* Disable channel reception */
 ConfigRxCR(ChannelNo, 0x0);
 PI(One_BitClk_Period * 4);
}

/********************* End of AACISnRXINTRTests.c *********************/
