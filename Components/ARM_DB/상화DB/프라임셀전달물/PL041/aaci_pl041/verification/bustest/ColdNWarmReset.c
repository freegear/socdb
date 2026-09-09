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
-- File Name              : ColdNWarmReset.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This section of the code checks for the normal transmission
--           and reception of data to/from AACI before and after power
--           down entry of the AACI.
--
-- --=================================================================*/

/**********************************************************************/
/**************** Internal function declarations  *********************/
/**********************************************************************/
void WarmResetTest(void);

void ColdResetTest(void);

void TxRxFIFOTest(int32 Ch1ValidSlot, int32 Ch2ValidSlot,
                  int32 Ch3ValidSlot, int32 Ch4ValidSlot,
                  int32 Ch1ModeSize, int32 Ch2ModeSize,
                  int32 Ch3ModeSize, int32 Ch4ModeSize);

/**********************************************************************/
/************************* Cold Reset Test ****************************/
/**********************************************************************/
void ColdNWarmReset(void)
{
/*
  Summary : ColdNWarmReset
  ========================
  This test checks for the normal transmission and reception of data 
  to/from AACI before and after power down entry of the AACI. 
  This function calls the WarmResetTest() function to verify the AACI's
  operation on Warm Reset and the ColdResetTest() function to verify
  the AACI's operation on Cold Reset.
*/
  if (AACIBITCLK_PERIOD >= PCLK_PERIOD)
   {
    ColdResetTest();
    WarmResetTest();
   }
 }

/**********************************************************************/
/************************* Cold Reset Test ****************************/
/**********************************************************************/
void ColdResetTest(void)
{
 /*
   Summary : ColdResetTest
   =======================
   This section of the code checks for the normal transmission and 
   reception of data to/from AACI before and after power down entry of 
   the AACI. 
   The test sequence is as follows. 
   - Normal transmission and reception of data is allowed to occur for 
     2 frames. 
   - The AACI is programmed through the AACISL1TX and the AACISL2TX 
     registers to force the CODEC into low power mode. 
   - Then the AACIBITCLK in the trickbox is disabled so as to simulate 
     low power mode entry.
   - Cold Reset is then applied through the AACIRESET port by driving
     it LOW and then HIGH. The AACIRESET port is controlled by writing
     to the FORCEDRESET bit in the AACIRESET register.
   - AACIBITCLK from the trickbox is then enabled to simulate 
     power-down exit by the CODEC.
   - A few frames of transmission and reception are allowed. It is 
     verified that the transmission / reception is error-free.

 */

 int i;
 int32 One_BitClk_Period;


 One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 /* Disable AACI to flush the FIFOs of any left-over data */
 PSW(0x0, AACIMAINCR);
 PI(3 * One_BitClk_Period);

 /* Enable AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);

 C("START OF COLD RESET TEST");
 One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 
 C("PERFORM NORMAL TRANSMISSION AND RECEPTION BEFORE POWER DOWN ENTRY");
 TxRxFIFOTest(AACI_TX3 | AACI_TX4,
               0x0, 0x0,
               0x0,
               AACI_CM | AACI_TSIZE16,
               AACI_TSIZE16,
               AACI_TSIZE20,
               AACI_CM | AACI_TSIZE12
              );

 C("END OF NORMAL TRANSMISSION AND RECEPTION");

 /* Disable all Slots in AACIRXCRn and AACITXCRn [n = 1 to 4] registers
    and enable AACISL1TX & AACISL2TX for transmission. */

 /* Disable all Slots in AACIRXCRn [n = 1 to 4] */
 ConfigRxCR(Channel_1, AACI_FEN);
 ConfigRxCR(Channel_2, AACI_FEN);
 ConfigRxCR(Channel_3, AACI_FEN);
 ConfigRxCR(Channel_4, AACI_FEN);

 /* Disable all Slots in AACITXCRn [n = 1 to 4] */
 ConfigTxCR(Channel_1, AACI_FEN);
 ConfigTxCR(Channel_2, AACI_FEN);
 ConfigTxCR(Channel_3, AACI_FEN);
 ConfigTxCR(Channel_4, AACI_FEN);

 C("PROGRAMMING THE AACI FOR POWER-DOWN ENTRY");

 /* Set Bit16 of AACISL2TX Register */
 PSW(0x10000, AACISL2TX, Set_bit12_SLOT2TX_for_LowPowerMode);
 
 /* Write 26h into AACISL1TX[18:12] Register. Also set the 'Read/Write'
    bit to indicate Write operation */
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
 PSW(AACITB_BtClkEn | AACITB_En | AACITB_RxEn | AACITB_TxEn | AACITB_BtClkRst, AACITrCntlReg,BitClk_Disabled);

 /* Wait for the completion of the first slot of the second frame */ 
 PO(0x10,MASK_RxFFFillLevel,AACITrFIFOStat,One_BitClk_Period * 512);

 /* Disable AACIBITCLK after fixed delay */
 if (AACIBITCLK_PERIOD > PCLK_PERIOD)
   {
    PI(0x40);
   }
 PSW(AACITB_En | AACITB_BtClkRst, AACITrCntlReg,BitClk_Disabled);
 
 /* Wait for One Slot Period */
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
 PSR(0x12345, MASK_ALL, AACISL2RX,AACI1_T219);

 /* Verify that the status register bits are low */
 PSR(0x0, 0x0C0, AACISR1,AACI1_T220);
 PSR(0x0, 0x0C0, AACISR2,AACI1_T221);
 PSR(0x0, 0x0C0, AACISR3,AACI1_T222);
 PSR(0x0, 0x0C0, AACISR4,AACI1_T223
 
 /* Simulate Cold reset through writes to the AACIRESET register */
 PSW(AACI_FORCEDRESET0, AACIRESET, Set_FORCEDSYNC_Bit);
 PI(20, Wait_for_few_PCLK_Cycle);
 PSW(AACI_FORCEDRESET1, AACIRESET, Clear_FORCEDSYNC_Bit);
 PI(20, Wait_for_few_PCLK_Cycle);
 
 /* Enable AACIBITCLK */ 
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(14 * One_BitClk_Period); /* wait for 14 BitClk Period */
 
 C("PERFORM NORMAL TRANSMISSION AND RECEPTION AFTER POWER DOWN EXIT");
 TxRxFIFOTest(AACI_TX3 | AACI_TX6,
               0x0, 0x0, 0x0,
               AACI_CM | AACI_TSIZE16,
               AACI_TSIZE16,
               AACI_TSIZE20,
               AACI_CM | AACI_TSIZE12
              );

 C("END OF NORMAL TRANSMISSION AND RECEPTION AFTER POWER-DOWN EXIT");
 C("END OF COLD RESET TEST");
}

/*********************** End of ColdResetTest.c ***********************/
/**********************************************************************/
/************************** WarmResetTest  ****************************/
/**********************************************************************/
void WarmResetTest(void) 
{
 /*
   Summary : WarmResetTest
   =======================
   This section of the code checks for the normal transmission and
   reception of data to/from AACI before and after power down entry of
   the AACI.
   The test sequence is as follows.
   - Normal transmission and reception of data is allowed to occur for
     2 frames.
   - The AACI is programmed through the AACISL1TX and the AACISL2TX
     registers to force the CODEC into low power mode.
   - Then the AACIBITCLK in the trickbox is disabled so as to simulate
     low power mode entry.
   - Warm Reset is then applied through the AACISYNC port by driving
     it HIGH and then LOW. The AACISYNC port is controlled by writing
     to the FORCEDSYNC bit in the AACISYNC register.
   - AACIBITCLK from the trickbox is then enabled to simulate
     power-down exit by the CODEC.
   - A few frames of transmission and reception are allowed. It is
     verified that the transmission / reception is error-free.

 */

 int   i;
 int32 One_BitClk_Period;
 
 One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 /* Disable AACI to flush the FIFOs of any left-over data */
 PSW(0x0, AACIMAINCR);
 PI(3 * One_BitClk_Period);

 /* Enable AACI */
 PSW(AACI_AACIIFE, AACIMAINCR);

 C(" START OF WARM RESET TEST");
 /* First Check error free transmission and reception for 2 frames */
 C("PERFORM NORMAL TRANSMISSION AND RECEPTION BEFORE POWER DOWN ENTRY");
 TxRxFIFOTest(AACI_TX3 | AACI_TX4,
               0x0, 0x0,
               0x0,
               AACI_CM | AACI_TSIZE16,
               AACI_TSIZE16,
               AACI_TSIZE20,
               AACI_CM | AACI_TSIZE12
              );

 C("END OF NORMAL TRANSMISSION AND RECEPTION");

 /* Disable all Slots in AACIRXCRn and AACITXCRn [n = 1 to 4] registers
    and enable AACISL1TX & AACISL2TX for transmission. */

 /* Disable all Slots in AACIRXCRn [n = 1 to 4] */
 ConfigRxCR(Channel_1, AACI_FEN);
 ConfigRxCR(Channel_2, AACI_FEN);
 ConfigRxCR(Channel_3, AACI_FEN);
 ConfigRxCR(Channel_4, AACI_FEN);

 /* Disable all Slots in AACITXCRn [n = 1 to 4] */
 ConfigTxCR(Channel_1, AACI_FEN);
 ConfigTxCR(Channel_2, AACI_FEN);
 ConfigTxCR(Channel_3, AACI_FEN);
 ConfigTxCR(Channel_4, AACI_FEN);

 C("PROGRAMMING THE AACI FOR POWER-DOWN ENTRY");

 /* Set Bit16 of AACISL2TX Register */
 PSW(0x10000, AACISL2TX, Set_bit12_SLOT2TX_for_LowPowerMode);

 /* Write 26h into AACISL1TX[18:12] Register. Also set the 'Read/Write'
    bit to indicate Write operation */
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
    PI(0x40);
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

 /* Simulate Warm reset through writes to the AACISYNC register */
 PSW(AACI_FORCEDSYNC, AACISYNC, Set_FORCEDSYNC_Bit);
 PI(20, Wait_for_few_PCLK_Cycle);
 PSW(0x0, AACISYNC, Clear_FORCEDSYNC_Bit);
 PI(20, Wait_for_few_PCLK_Cycle);

 /* Enable AACIBITCLK */
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(14 * One_BitClk_Period); /* wait for 14 BitClk Period */

 C("PERFORM NORMAL TRANSMISSION AND RECEPTION AFTER POWER DOWN EXIT");
 TxRxFIFOTest(AACI_TX3 | AACI_TX6,
               0x0, 0x0, 0x0,
               AACI_CM | AACI_TSIZE16,
               AACI_TSIZE16,
               AACI_TSIZE20,
               AACI_CM | AACI_TSIZE12
              );

 C("END OF NORMAL TRANSMISSION AND RECEPTION AFTER POWER-DOWN EXIT");
 C("END OF WARM RESET TEST");

}

/**********************************************************************/
/**************** Transmission and Reception Test *********************/
/**********************************************************************/
void TxRxFIFOTest(int32 Ch1ValidSlot, int32 Ch2ValidSlot, 
                  int32 Ch3ValidSlot, int32 Ch4ValidSlot, 
                  int32 Ch1ModeSize, int32 Ch2ModeSize,
                  int32 Ch3ModeSize, int32 Ch4ModeSize)
{
 /* 
   Summary : TxRxFIFOTest
   ======================
   This function is called by the ColdReset() and WarmReset() functions.
   Here, normal transmisson and reception is done for 2 frames. 
   So the reception in the AACI occurs for 2 frames and transmission 
   occurs only for one frame since transmission is only started after 
   'Codec Ready' is detected. 

 */
 int One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;

 int i;
  
 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
   One_BitClk_Period = 0x1;

 /* Enabling Trickbox reception and transmission */
 PSW(AACITB_BtClkEn | AACITB_RxEn | AACITB_BtClkRst | AACITB_TxEn,AACITrCntlReg);
 PI(One_BitClk_Period * 18);

 if (Ch1ValidSlot > 0)
   {
    ConfigTxCR(Channel_1, Ch1ValidSlot | Ch1ModeSize | AACI_FEN);
    TxFIFOFill(Channel_1, Ch1ValidSlot, Ch1ModeSize | AACI_FEN);
   }
 if (Ch2ValidSlot > 0)
   {
    ConfigTxCR(Channel_2, Ch2ValidSlot | Ch2ModeSize | AACI_FEN);
    TxFIFOFill(Channel_2, Ch2ValidSlot, Ch2ModeSize | AACI_FEN);
   }
 if (Ch3ValidSlot > 0)
   {
    ConfigTxCR(Channel_3, Ch3ValidSlot | Ch3ModeSize | AACI_FEN);
    TxFIFOFill(Channel_3, Ch3ValidSlot, Ch3ModeSize | AACI_FEN);
   }
 if (Ch4ValidSlot > 0)
   {
    ConfigTxCR(Channel_4, Ch4ValidSlot | Ch4ModeSize | AACI_FEN);
    TxFIFOFill(Channel_4, Ch4ValidSlot, Ch4ModeSize | AACI_FEN);
   }
 if (Ch1ValidSlot > 0)
   ConfigRxCR(Channel_1, Ch1ValidSlot | Ch1ModeSize | AACI_FEN);

 if (Ch2ValidSlot > 0)
   ConfigRxCR(Channel_2, Ch2ValidSlot | Ch2ModeSize | AACI_FEN);

 if (Ch3ValidSlot > 0)
   ConfigRxCR(Channel_3, Ch3ValidSlot | Ch3ModeSize | AACI_FEN);

 if (Ch4ValidSlot > 0)
   ConfigRxCR(Channel_4, Ch4ValidSlot | Ch4ModeSize | AACI_FEN);
 
 TrTxFIFOWr(Ch1ValidSlot, Ch2ValidSlot, Ch3ValidSlot,
              Ch4ValidSlot, Ch1ModeSize, Ch2ModeSize,
              Ch3ModeSize, Ch4ModeSize);

 /* Trickbox Tx FIFO is filled with 2 frames of data */
 TrTxFIFOWr(Ch1ValidSlot, Ch2ValidSlot, Ch3ValidSlot,
              Ch4ValidSlot, Ch1ModeSize, Ch2ModeSize,
              Ch3ModeSize, Ch4ModeSize);

 /* Enable AACI for Transmission */ 
 if (Ch1ValidSlot > 0)
   ConfigTxCR(Channel_1, 
               Ch1ValidSlot | Ch1ModeSize | AACI_FEN | AACI_TEN);

 if (Ch2ValidSlot > 0)
   ConfigTxCR(Channel_2,
               Ch2ValidSlot | Ch2ModeSize | AACI_FEN | AACI_TEN);

 if (Ch3ValidSlot > 0)
   ConfigTxCR(Channel_3, 
               Ch3ValidSlot | Ch3ModeSize | AACI_FEN | AACI_TEN);

 if (Ch4ValidSlot > 0)
   ConfigTxCR(Channel_4,
               Ch4ValidSlot | Ch4ModeSize | AACI_FEN | AACI_TEN);

 /* Enable AACI for Reception */ 
 if (Ch1ValidSlot > 0)
   ConfigRxCR(Channel_1,
               Ch1ValidSlot | Ch1ModeSize | AACI_FEN | AACI_REN);
 
 if (Ch2ValidSlot > 0)
   ConfigRxCR(Channel_2,
               Ch2ValidSlot | Ch2ModeSize | AACI_FEN | AACI_REN);

 if (Ch3ValidSlot > 0)
   ConfigRxCR(Channel_3,
               Ch3ValidSlot | Ch3ModeSize | AACI_FEN | AACI_REN);

 if (Ch4ValidSlot > 0)
   ConfigRxCR(Channel_4,
               Ch4ValidSlot | Ch4ModeSize | AACI_FEN | AACI_REN);
 
 /* Enable Trickbox reception and transmission */
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_RxEn | AACITB_BtClkRst | AACITB_TxEn,AACITrCntlReg);

 /* Waiting for completion of 2 frames */
 PO(0x0000001A, MASK_RxFFFillLevel, AACITrFIFOStat, One_BitClk_Period * 766);

 /* Disable Trickbox reception and transmission */
 PSW(AACITB_BtClkEn | AACITB_BtClkRst,AACITrCntlReg);

 /* The first frame transmitted by the AACI should be invalid */
 for (i = 0 ; i < 13 ; i++ )
   { 
    PSR(0x0, 0xFFFFF, AACITrRxFIFO,RdInvalid);
   }

 /* Reading the second received frame from the trickbox */
 TrRxFIFORd(Ch1ValidSlot, Ch2ValidSlot, Ch3ValidSlot,
              Ch4ValidSlot, Ch1ModeSize, Ch2ModeSize,
              Ch3ModeSize, Ch4ModeSize);

 /* Reading the 1 st received frame from the AACI receive FIFO */
 RxFIFORd(Channel_1, Ch1ValidSlot, Ch1ModeSize | AACI_FEN);
 RxFIFORd(Channel_2, Ch2ValidSlot, Ch2ModeSize | AACI_FEN);
 RxFIFORd(Channel_3, Ch3ValidSlot, Ch3ModeSize | AACI_FEN);
 RxFIFORd(Channel_4, Ch4ValidSlot, Ch4ModeSize | AACI_FEN);

 /* Reading the 2 nd received frame from the AACI receive FIFO */
 RxFIFORd(Channel_1, Ch1ValidSlot, Ch1ModeSize | AACI_FEN);
 RxFIFORd(Channel_2, Ch2ValidSlot, Ch2ModeSize | AACI_FEN);
 RxFIFORd(Channel_3, Ch3ValidSlot, Ch3ModeSize | AACI_FEN);
 RxFIFORd(Channel_4, Ch4ValidSlot, Ch4ModeSize | AACI_FEN);

}

/************************ End of WarmResetTest.c **********************/
