/* --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- --------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : FIFOTest.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
--  Purpose : 
--            This part of the code checks the functionality of status
--            flag of AACI for all channel(ie Channel 1 to Channel 4 ).
--
-- --=================================================================*/

/**********************************************************************/
/************************* Function declarations **********************/
/**********************************************************************/

void FIFOStatusTest(int ChannelNo);

void FlagTest(int ChannelNo);

/**********************************************************************/
/********************* FIFO Test **************************************/
/**********************************************************************/
void FIFOTest(void)
{
  /*
   Summary: FIFO Test
   ==================
   The function calls FIFOStatusTest and FlagTest function for all 
   Channel. FIFOStausTest function checks functionality of the
   following status flags of the AACISR : TXBUSY, RXBUSY, TXFF, RXFF, 
   TXHE, RXHF, TXFE and RXFE with AACIFE bit Enabled. FlagTest function
   also checks status flag but AACIFE bit disabled.
 */
 
 int  One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 
 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 C("START OF FIFO TEST");

 C("FIFO STATUS TEST FOR CHANNEL 1");
 FIFOStatusTest(Channel_1);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 C("FIFO STATUS TEST FOR CHANNEL 2");
 FIFOStatusTest(Channel_2);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 C("FIFO STATUS TEST FOR CHANNEL 3");
 FIFOStatusTest(Channel_3);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 C("FIFO STATUS TEST FOR CHANNEL 4");
 FIFOStatusTest(Channel_4);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 C("FLAG TEST FOR CHANNEL 1"); 
 FlagTest(Channel_1);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 C("FLAG TEST FOR CHANNEL 2"); 
 FlagTest(Channel_2);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 C("FLAG TEST FOR CHANNEL 3"); 
 FlagTest(Channel_3);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 C("FLAG TEST FOR CHANNEL 4"); 
 FlagTest(Channel_4);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
}

/**********************************************************************/
/******************    FIFO Status Test    ****************************/
/**********************************************************************/
void FIFOStatusTest(int ChannelNo)
{
 /*
   Summary: FIFO Status Test
   =========================
   This function tests the following status flags of the channels
   AACISR register: TXBUSY, RXBUSY, TXFF, RXFF, TXHE, RXHF, TXFE and
   RXFE. 
   The Trickbox Tx FIFO is loaded with data for one frame with 8 valid
   slots. Then TXBUSY, RXBUSY, TXFF, RXFF, RXHF are checked for '0',
   and TXHE, TXFE and RXFE are checked for '1'. The AACI Tx FIFO is
   loaded with 8 data and TXFF and TXHE are checked for '1' and '0'
   respectively. The AACITXCR and AACIRXCR registers are programmed for
   8 valid slots. Data transfer is started and immediately RXBUSY and
   TXBUSY are checked for '1'. After one slot is transferred, RXFE and
   TXFE are checked for '0'. When data for the fifth slot is removed
   from the Tx FIFO, RXHF and TXHE are tested for '1' and '0'
   respectively. Then after all slots are transmitted RXFF is tested
   for '1' and TXBUSY is tested for '0'. Data is read back from the Rx
   FIFO of the Trickbox and the Rx FIFO of the AACI to check for
   error-free transmission. 
 */

 int32 ChValidSlot;
 int   i;
 int   One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 C("START OF FIFO STATUS TEST ");

 ChValidSlot =  AACI_TX3 | AACI_TX5  | AACI_TX6  | AACI_TX4 | 
                AACI_TX7 | AACI_TX10 | AACI_TX11 | AACI_TX12;
 
 /* Fill Trickbox with 8 valid slots */
 FrameWrite(ChannelNo, ChValidSlot, AACI_TSIZE20);
 FrameWrite(ChannelNo, 0x80000,     AACI_TSIZE20);

 /* Enable AACIFE bit */
 PSW(AACI_AACIIFE, AACIMAINCR); 

 /* Check Flags from the AACISR register of the selected channel for 
    empty status of Tx and Rx FIFOs */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_RXFE, AACI_RXFE,   AACISR1,FIFOStT1);
    PSR(AACI_TXFE, AACI_TXFE,   AACISR1,FIFOStT2);
    PSR(0x0,       AACI_RXHF,   AACISR1,FIFOStT3);
    PSR(AACI_TXHE, AACI_TXHE,   AACISR1,FIFOStT4);
    PSR(0x0,       AACI_RXFF,   AACISR1,FIFOStT5);
    PSR(0x0,       AACI_TXFF,   AACISR1,FIFOStT6);
    PSR(0x0,       AACI_RXBUSY, AACISR1,FIFOStT7);
    PSR(0x0,       AACI_TXBUSY, AACISR1,FIFOStT8);
   }
 else if (ChannelNo == Channel_2)
   {
    PSR(AACI_RXFE, AACI_RXFE,   AACISR2,FIFOStT9);
    PSR(AACI_TXFE, AACI_TXFE,   AACISR2,FIFOStT10);
    PSR(0x0,       AACI_RXHF,   AACISR2,FIFOStT11);
    PSR(AACI_TXHE, AACI_TXHE,   AACISR2,FIFOStT12);
    PSR(0x0,       AACI_RXFF,   AACISR2,FIFOStT13);
    PSR(0x0,       AACI_TXFF,   AACISR2,FIFOStT14);
    PSR(0x0,       AACI_RXBUSY, AACISR2,FIFOStT15);
    PSR(0x0,       AACI_TXBUSY, AACISR2,FIFOStT16);
   }
 else if (ChannelNo == Channel_3)
   { 
    PSR(AACI_RXFE, AACI_RXFE,   AACISR3,FIFOStT17);
    PSR(AACI_TXFE, AACI_TXFE,   AACISR3,FIFOStT18);
    PSR(0x0,       AACI_RXHF,   AACISR3,FIFOStT19);
    PSR(AACI_TXHE, AACI_TXHE,   AACISR3,FIFOStT20);
    PSR(0x0,       AACI_RXFF,   AACISR3,FIFOStT21);
    PSR(0x0,       AACI_TXFF,   AACISR3,FIFOStT22);
    PSR(0x0,       AACI_RXBUSY, AACISR3,FIFOStT23);
    PSR(0x0,       AACI_TXBUSY, AACISR3,FIFOStT24);
   }
 else if (ChannelNo == Channel_4)
   {
    PSR(AACI_RXFE, AACI_RXFE,   AACISR4,FIFOStT25);
    PSR(AACI_TXFE, AACI_TXFE,   AACISR4,FIFOStT26);
    PSR(0x0,       AACI_RXHF,   AACISR4,FIFOStT27);
    PSR(AACI_TXHE, AACI_TXHE,   AACISR4,FIFOStT28);
    PSR(0x0,       AACI_RXFF,   AACISR4,FIFOStT29);
    PSR(0x0,       AACI_TXFF,   AACISR4,FIFOStT31);
    PSR(0x0,       AACI_RXBUSY, AACISR4,FIFOStT32);
    PSR(0x0,       AACI_TXBUSY, AACISR4,FIFOStT33);
   } 

 /* Configure AACI Tx FIFO */
 ConfigTxCR(ChannelNo, ChValidSlot | AACI_TSIZE20 | AACI_FEN);
 PI(One_BitClk_Period * 4);

 C("FILL FRAME IN AACI TXFIFO ");
 TxFIFOFill(ChannelNo, ChValidSlot, AACI_TSIZE20 | AACI_FEN);

 /* Configure AACI Rx FIFO */
 ConfigRxCR(ChannelNo, ChValidSlot | AACI_RSIZE20 | AACI_FEN);

 /* Verify that TXFF is set and TxHE is cleared */ 
 if (ChannelNo == Channel_1)
   {
    PSR(0x0,       AACI_TXHE, AACISR1,FIFOStT34);
    PSR(AACI_TXFF, AACI_TXFF, AACISR1,FIFOStT35);
   }
 else if (ChannelNo == Channel_2)
   {
    PSR(0x0,       AACI_TXHE, AACISR2,FIFOStT36);
    PSR(AACI_TXFF, AACI_TXFF, AACISR2,FIFOStT37);
   }
 else if (ChannelNo == Channel_3)
   {
    PSR(0x0,       AACI_TXHE, AACISR3,FIFOStT38);
    PSR(AACI_TXFF, AACI_TXFF, AACISR3,FIFOStT39);
   }
 else if (ChannelNo == Channel_4)
   {
    PSR(0x0,       AACI_TXHE, AACISR4,FIFOStT40);
    PSR(AACI_TXFF, AACI_TXFF, AACISR4,FIFOStT41);
   }
 
 /* Enable Transmission and Reception */
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_RxEn | AACITB_BtClkRst, AACITrCntlReg);
 ConfigTxCR(ChannelNo,ChValidSlot | AACI_TSIZE20 | AACI_FEN | AACI_TEN);
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_RxEn | AACITB_TxEn | AACITB_BtClkRst, AACITrCntlReg);
 ConfigRxCR(ChannelNo,ChValidSlot | AACI_RSIZE20 | AACI_FEN | AACI_REN);

 C(" TRANSMISSION & RECEPTION IS ENABLED ");

 /* Verify that TXBUSY is set */
 PSR(AACI_MAINTXBUSY, AACI_MAINTXBUSY, AACIMAINFR, FIFOStT42); 

 /* Wait for SLOT 0 transmission of 1st Frame */ 
 PO(AACITB_RxFFillLevel1, MASK_RxFFFillLevel, AACITrFIFOStat, 256 * One_BitClk_Period,FIFOStT43 );

 PI(One_BitClk_Period);

 /* Verify that RXBUSY is set */
 PSR(AACI_MAINRXBUSY, AACI_MAINRXBUSY, AACIMAINFR,FIFOStT44);

 /* wait for SLOT 5 transmission of 1st Frame */ 
 PO(AACITB_TxFFillLevel21, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,FIFOStT45 );

 PI(One_BitClk_Period);

 /* Verify that RXFE & TXFE are cleared */
 if (ChannelNo == Channel_1)
  {
   PSR(0x0, AACI_RXFE, AACISR1,FIFOStT46);
   PSR(0x0, AACI_TXFE, AACISR1,FIFOStT47);
  }
 else if (ChannelNo == Channel_2)
   {
    PSR(0x0, AACI_RXFE, AACISR2,FIFOStT48);
    PSR(0x0, AACI_TXFE, AACISR2,FIFOStT49);
   } 
 else if (ChannelNo == Channel_3)
   {
    PSR(0x0, AACI_RXFE, AACISR3,FIFOStT50);
    PSR(0x0, AACI_TXFE, AACISR3,FIFOStT51);
   }
 else if (ChannelNo == Channel_4)
   {
    PSR(0x0, AACI_RXFE, AACISR4,FIFOStT52);
    PSR(0x0, AACI_TXFE, AACISR4,FIFOStT53);
   }

 /* Wait for Slot7 Transmission */
 PO(AACITB_TxFFillLevel18, MASK_TxFFFillLevel, AACITrFIFOStat, 256 * One_BitClk_Period,FIFOStT54);

 PI(2 * One_BitClk_Period);

 /* Verify that RXHF is set & TXHF is cleared */
 if (ChannelNo == Channel_1)
  {
   PSR(AACI_RXHF, AACI_RXHF, AACISR1,FIFOStT55);
   PSR(0x0,       AACI_TXHE, AACISR1,FIFOStT56);
  }
 else if (ChannelNo == Channel_2)
   {
    PSR(AACI_RXHF, AACI_RXHF, AACISR2,FIFOStT57);
    PSR(0x0,       AACI_TXHE, AACISR2,FIFOStT58);
   }
 else if (ChannelNo == Channel_3)
   {
    PSR(AACI_RXHF, AACI_RXHF, AACISR3,FIFOStT59);
    PSR(0x0,       AACI_TXHE, AACISR3,FIFOStT60);
   }
 else if (ChannelNo == Channel_4)
   {
    PSR(AACI_RXHF, AACI_RXHF, AACISR4,FIFOStT61);
    PSR(0x0,       AACI_TXHE, AACISR4,FIFOStT62);
   }

 C("WAIT FOR END OF FIRST FRAME TRANSMISSION ");
 PO(AACITB_TxFFillLevel12, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,FIFOStT63);

 /* Disable Trickbox Transmission and Reception */
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Verify that RXFF is set */
 if (ChannelNo == Channel_1)
    PSR(AACI_RXFF, AACI_RXFF, AACISR1,FIFOStT64);
 else if (ChannelNo == Channel_2)
    PSR(AACI_RXFF, AACI_RXFF, AACISR2,FIFOStT65);
 else if (ChannelNo == Channel_3)
    PSR(AACI_RXFF, AACI_RXFF, AACISR3,FIFOStT66);
 else if (ChannelNo == Channel_4)
    PSR(AACI_RXFF, AACI_RXFF, AACISR4,FIFOStT67);

 /* Wait for 2nd Frame Transmission */
 PO(AACITB_TxFFillLevel0, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,FIFOStT68);

 PI(20 * One_BitClk_Period);

 /* Verify that AACI MAINTXBUSY is cleared */  
 PSR(0x0, AACI_MAINTXBUSY, AACIMAINFR,FIFOStT69);

 /* Disable Transmission and Reception */
 ConfigRxCR(ChannelNo, ChValidSlot | AACI_TSIZE20 | AACI_FEN);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 ConfigTxCR(ChannelNo, ChValidSlot | AACI_RSIZE20 | AACI_FEN);
 
 C("TRANSMISSION AND RECEPTION DISABLED ");

 /* Read AACI Rx FIFO */
 
 RxFIFORd(ChannelNo, ChValidSlot, AACI_TSIZE20 | AACI_FEN);
 
 C(" READ FRAME FROM AACI");

 for (i = 0; i < 13; i++)
   {
    PSR(0x0, MASK_ALL, AACITrRxFIFO,FIFOStT70);
   }

FrameRead(ChannelNo, ChValidSlot, AACI_RSIZE20);

/* Disable Trickbox enable bit */
PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

/* Disable AACIFE bit */
PSW(0x0, AACIMAINCR);

/* Clear AACIRXCR & AACITXCR Register */
ConfigRxCR(ChannelNo, 0x0);
ConfigTxCR(ChannelNo, 0x0);  

C("END OF FIFO STATUS TEST ");
}

/**********************************************************************/
/************************  Flag Test **********************************/
/**********************************************************************/
void FlagTest(int ChannelNo)
{
 /*
   Summary: Flag Test
   ==================
   In this function the status of the FIFO flags are tested with the
   AACIFE bit is disabled. AACIRXCR is programmed for eight valid slots.
   Trickbox is filled with eight valid slots. Data transmission from
   the Trickbox is enabled. After transmission has started, it is
   verified that the FIFO flags status will remain in default state due
   to AACIFE bit being disabled. Now AACIFE bit is enabled. After
   transmission of whole frame, data is read from Rx FIFO of AACI and
   compared with expected data.
 */ 

 int32 ChValidSlot;
 int   i;
 int   One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 
 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;
 
 C("START OF FLAG TEST ");

 ChValidSlot =  AACI_TX3  | AACI_TX5  | AACI_TX6  | AACI_TX4 |
                AACI_TX7  | AACI_TX10 | AACI_TX11 | AACI_TX12;
 
 /* Fill Trickbox with 8 valid slots */
 FrameWrite(ChannelNo, ChValidSlot, AACI_TSIZE20);
 FrameWrite(ChannelNo, 0x80000, AACI_TSIZE20);

 /* Disable AACIFE bit */
 PSW(0x0, AACIMAINCR); 
 
 /* Check flags from the AACISR register of the selected channel for 
    empty status of Tx and Rx FIFOs */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_RXFE, AACI_RXFE,   AACISR1,FLAGT_1);
    PSR(AACI_TXFE, AACI_TXFE,   AACISR1,FLAGT_2);
    PSR(0x0,       AACI_RXHF,   AACISR1,FLAGT_3);
    PSR(AACI_TXHE, AACI_TXHE,   AACISR1,FLAGT_4);
    PSR(0x0,       AACI_RXFF,   AACISR1,FLAGT_5);
    PSR(0x0,       AACI_TXFF,   AACISR1,FLAGT_6);
    PSR(0x0,       AACI_RXBUSY, AACISR1,FLAGT_7);
    PSR(0x0,       AACI_TXBUSY, AACISR1,FLAGT_8);
   }
 else if (ChannelNo == Channel_2)
   {
    PSR(AACI_RXFE, AACI_RXFE,   AACISR2,FLAGT_9);
    PSR(AACI_TXFE, AACI_TXFE,   AACISR2,FLAGT_10);
    PSR(0x0,       AACI_RXHF,   AACISR2,FLAGT_11);
    PSR(AACI_TXHE, AACI_TXHE,   AACISR2,FLAGT_12);
    PSR(0x0,       AACI_RXFF,   AACISR2,FLAGT_13);
    PSR(0x0,       AACI_TXFF,   AACISR2,FLAGT_14);
    PSR(0x0,       AACI_RXBUSY, AACISR2,FLAGT_15);
    PSR(0x0,       AACI_TXBUSY, AACISR2,FLAGT_16);
   }
 else if (ChannelNo == Channel_3)
   {
    PSR(AACI_RXFE, AACI_RXFE,   AACISR3,FLAGT_17);
    PSR(AACI_TXFE, AACI_TXFE,   AACISR3,FLAGT_18);
    PSR(0x0,       AACI_RXHF,   AACISR3,FLAGT_19);
    PSR(AACI_TXHE, AACI_TXHE,   AACISR3,FLAGT_20);
    PSR(0x0,       AACI_RXFF,   AACISR3,FLAGT_21);
    PSR(0x0,       AACI_TXFF,   AACISR3,FLAGT_22);
    PSR(0x0,       AACI_RXBUSY, AACISR3,FLAGT_23);
    PSR(0x0,       AACI_TXBUSY, AACISR3,FLAGT_24);
   }
 else if (ChannelNo == Channel_4)
   {
    PSR(AACI_RXFE, AACI_RXFE,   AACISR4,FLAGT_25);
    PSR(AACI_TXFE, AACI_TXFE,   AACISR4,FLAGT_26);
    PSR(0x0,       AACI_RXHF,   AACISR4,FLAGT_27);
    PSR(AACI_TXHE, AACI_TXHE,   AACISR4,FLAGT_28);
    PSR(0x0,       AACI_RXFF,   AACISR4,FLAGT_29);
    PSR(0x0,       AACI_TXFF,   AACISR4,FLAGT_30);
    PSR(0x0,       AACI_RXBUSY, AACISR4,FLAGT_31);
    PSR(0x0,       AACI_TXBUSY, AACISR4,FLAGT_32);
   }

 /* Configure AACI Tx FIFO */
 ConfigTxCR(ChannelNo, ChValidSlot | AACI_TSIZE20 | AACI_FEN);

 PI(One_BitClk_Period * 4);
 
 /* Fill AACI Tx FIFO */
 TxFIFOFill(ChannelNo, ChValidSlot, AACI_TSIZE20 | AACI_FEN);
 
 /* Configure AACI Rx FIFO */
 ConfigRxCR(ChannelNo, ChValidSlot | AACI_RSIZE20 | AACI_FEN);
 
 /* Enable Trickbox and AACI Transmission and Reception */
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_RxEn | AACITB_BtClkRst, AACITrCntlReg);
 ConfigTxCR(ChannelNo,ChValidSlot | AACI_TSIZE20 | AACI_FEN | AACI_TEN);
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_RxEn | AACITB_TxEn | AACITB_BtClkRst, AACITrCntlReg);
 ConfigRxCR(ChannelNo,ChValidSlot | AACI_RSIZE20 | AACI_FEN | AACI_REN);
 
 /* Verify that all Tx and Rx Busy bits are cleared */
 
 PI( 20 * One_BitClk_Period);
 
 PSR(0x0, AACI_MAINRXBUSY | AACI_MAINTXBUSY, AACIMAINFR,FLAGT_33)
 
 PI(0x01);

 /* Check flags from the AACISR register of the selected channel for 
    empty status of Tx and Rx FIFOs */
 if (ChannelNo == Channel_1)
   {
    PSR(AACI_RXFE, AACI_RXFE,   AACISR1,FLAGT_34);
    PSR(AACI_TXFE, AACI_TXFE,   AACISR1,FLAGT_35);
    PSR(0x0,       AACI_RXHF,   AACISR1,FLAGT_36);
    PSR(AACI_TXHE, AACI_TXHE,   AACISR1,FLAGT_37);
    PSR(0x0,       AACI_RXFF,   AACISR1,FLAGT_38);
    PSR(0x0,       AACI_TXFF,   AACISR1,FLAGT_39);
    PSR(0x0,       AACI_RXBUSY, AACISR1,FLAGT_40);
    PSR(0x0,       AACI_TXBUSY, AACISR1,FLAGT_41);
   }
 else if (ChannelNo == Channel_2)
   {
    PSR(AACI_RXFE, AACI_RXFE,   AACISR2,FLAGT_42);
    PSR(AACI_TXFE, AACI_TXFE,   AACISR2,FLAGT_43);
    PSR(0x0,       AACI_RXHF,   AACISR2,FLAGT_44);
    PSR(AACI_TXHE, AACI_TXHE,   AACISR2,FLAGT_45);
    PSR(0x0,       AACI_RXFF,   AACISR2,FLAGT_46);
    PSR(0x0,       AACI_TXFF,   AACISR2,FLAGT_47);
    PSR(0x0,       AACI_RXBUSY, AACISR2,FLAGT_48);
    PSR(0x0,       AACI_TXBUSY, AACISR2,FLAGT_49);
   }
 else if (ChannelNo == Channel_3)
   {
    PSR(AACI_RXFE, AACI_RXFE,   AACISR3,FLAGT_50);
    PSR(AACI_TXFE, AACI_TXFE,   AACISR3,FLAGT_51);
    PSR(0x0,       AACI_RXHF,   AACISR3,FLAGT_52);
    PSR(AACI_TXHE, AACI_TXHE,   AACISR3,FLAGT_53);
    PSR(0x0,       AACI_RXFF,   AACISR3,FLAGT_54);
    PSR(0x0,       AACI_TXFF,   AACISR3,FLAGT_55);
    PSR(0x0,       AACI_RXBUSY, AACISR3,FLAGT_56);
    PSR(0x0,       AACI_TXBUSY, AACISR3,FLAGT_57);
   }
 else if (ChannelNo == Channel_4)
   {
    PSR(AACI_RXFE, AACI_RXFE,   AACISR4,FLAGT_58);
    PSR(AACI_TXFE, AACI_TXFE,   AACISR4,FLAGT_59);
    PSR(0x0,       AACI_RXHF,   AACISR4,FLAGT_60);
    PSR(AACI_TXHE, AACI_TXHE,   AACISR4,FLAGT_61);
    PSR(0x0,       AACI_RXFF,   AACISR4,FLAGT_62);
    PSR(0x0,       AACI_TXFF,   AACISR4,FLAGT_63);
    PSR(0x0,       AACI_RXBUSY, AACISR4,FLAGT_64);
    PSR(0x0,       AACI_TXBUSY, AACISR4,FLAGT_65);
   }

 /* Enable AACIFE bit */
 PSW(AACI_AACIIFE, AACIMAINCR);  

 /* Write Frame in Tx FIFO of AACI */ 
 TxFIFOFill(ChannelNo, ChValidSlot, AACI_TSIZE20 | AACI_FEN);

 /* Wait for 1st Frame Transmission */  
 PO(AACITB_TxFFillLevel12, MASK_TxFFFillLevel, AACITrFIFOStat, 256 * One_BitClk_Period,FLAGT_66);

 /* Disable Trickbox Reception */ 
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Wait for 2nd Frame Transmission */
 PO(AACITB_TxFFillLevel0, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,FLAGT_67);

 PI(20 * One_BitClk_Period);

 /* Disable Trickbox and AACI Transmission and Reception */
 ConfigRxCR(ChannelNo, ChValidSlot | AACI_TSIZE20 | AACI_FEN);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 ConfigTxCR(ChannelNo, ChValidSlot | AACI_RSIZE20 | AACI_FEN);
 C("TRANSMISSION AND RECEPTION DISABLED ");

 /* Read AACI Rx FIFO */
 RxFIFORd(ChannelNo, ChValidSlot, AACI_TSIZE20 | AACI_FEN);
 
 C(" READ FRAME FROM AACI");

 for (i = 0; i < 13; i++)
   {
    PSR(0x0, MASK_ALL, AACITrRxFIFO,FLAGT_68);
   }
 FrameRead(ChannelNo, ChValidSlot, AACI_RSIZE20);

 /* Disable Trickbox bit */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 /* Disable AACIFE bit */
 PSW(0x0, AACIMAINCR);

 /* Clear AACIRXCR & AACITXCR registers */
 ConfigRxCR(ChannelNo, 0x0);
 ConfigTxCR(ChannelNo, 0x0);
 
 C("END OF FLAG TEST ");
}
