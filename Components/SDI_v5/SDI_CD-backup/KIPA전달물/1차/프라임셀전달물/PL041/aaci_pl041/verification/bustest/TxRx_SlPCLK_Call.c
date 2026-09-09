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
-- File Name              : TxRx_SlPCLK_Call.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This function verifies both the transmit and receive
--           functionality of the AACI. It is called only when PCLK is 
--           slower than AACIBITCLK.
--
-- --=================================================================*/

/**********************************************************************/
/*** For more information on the AACI, please refer to PL041 AMBA   ***/
/*** AACI Block Specification                                       ***/
/**********************************************************************/

/**********************************************************************/
/*************************** TxRx_SlPCLK_Call *************************/
/**********************************************************************/
void TxRx_SlPCLK_Call(int32 CmpctMod)
{
  /*
    Summary: TxRx_SlPCLK_Call
    =========================
    This function is called only when PCLK is slower than AACIBITCLK.
    This function calls the TxRxTxRx_SlPCLK_Test routine which programs
    the Aaci according to parameters passed to it by the calling 
    function. These parameters are indirectly passed by updating the CW 
    (ControlWords) structure in this function (TxTxRx_SlPCLK_Call).
    These parameters determine the following :
      - The expected Slot0 from the AACI
      - Slot0 to be transmitted by the Trickbox
      - Register fields for the AACITXCRn (n = 1 to 4) registers
      - Register fields for the AACIRXCRn (n = 1 to 4) registers
      - SRC bit values to be transmitted by the trickbox
      - Information regarding the number of words of data to be written
        into the Tx FIFOs of the AACI for each frame
      - Information regarding which of the AACISLnTX (n = 1 to 4)
        registers need to be loaded with new data for each frame

    o The transmission and reception tests can be split into ten major
      categories. These ten categories are derived from the following 
      four fields.
      
      <Data Direction> + <Data Src/Dest> + <FIFO mode> + <SRC mode>

      Data Direction -> Tx & Rx
      Data Src/Dest  -> CH/SLReg/(Both CH and SLReg) 
      FIFO mode      -> FIFO / Char
      SRC            -> SRC / No SRC

      Out of the possible 10 categories, the following four categories 
      are tested. These form a minimal set of tests that would 
      reasonably test the AACI's functionality. When PCLK is faster than
      or has the same frequency as AACIBITCLK, the TxRx_FsPCLK_Call()
      ensures that all 10 categories are tested.
      1. Tx & Rx - CH - FIFO mode - No SRC
      2. Tx & Rx - CH & SLReg - FIFO mode - No SRC
      3. Tx & Rx - CH & SLReg - FIFO mode - SRC 
      4. Tx & Rx - CH & SLReg - Char mode - SRC

    o This function also verifies data transfer by the AACI for a
      range of TSIZE and RSIZE values in Compact mode and non-Compact
      mode. Only sub-tests involving even number of slots per channel
      are run in Compact mode.

  */

  int i;

/**********************************************************************/
/***************** Tx & Rx - CH - FIFO mode - No SRC ******************/
/**********************************************************************/
  /*
    The AACI is programmed for both transmission and reception in the
    FIFO mode. No SRC bits are set in the incoming frames. Two tests
    are done under this category. The following parameters are varied
    for each test.
      o The number of slots enabled for transmission per channel
      o The number of slots enabled for reception per channel
      o The number of slots enabled per transmitted frame.
      o The number of slots enabled per received frame.
      o Slot0 to be transmitted by the trickbox for each frame
      o TSIZE and RSIZE

    The tests are repeated by programming the channels to transfer
    data for different combinations of slots.

    The test cases having an even number of slots enabled per channel
    are again executed with the CM bit set in the AACITXCRn (n = 1 to 4)
    and in the AACIRXCRn (n = 1 to 4) registers.

  */

  C("Tx & Rx - CH - FIFO mode - No SRC");
  C("Channel1Tx enabled and has slots 1 and 2");
  C("Channel2Tx enabled and has slots 3,9");
  C("Channel3Tx enabled and has slots 7 and 8");
  C("Channel4Tx enabled and has slots 11 and 12");
  C("Channel1Rx enabled and has slots 3 and 4");
  C("Channel2Rx enabled and has slots 5,6");
  C("Channel3Rx enabled and has slots 8 and 9");
  C("Channel4Rx enabled and has slots 1 and 12");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TX1 |
                       AACI_TX2 | AACI_TEN;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TX3 |
                       AACI_TX9 | AACI_TEN;
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | CmpctMod | AACI_TX7 |
                       AACI_TX8 | AACI_TEN;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[4] | CmpctMod | AACI_TX11 |
                       AACI_TX12 | AACI_TEN;

  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[1] = AACI_FEN | RxSize[1] | CmpctMod | AACI_RX2 |
                       AACI_RX3 | AACI_REN;
  CW.DatRxCntlReg[2] = AACI_FEN | RxSize[2] | CmpctMod | AACI_RX1 |
                       AACI_RX7 | AACI_REN;
  CW.DatRxCntlReg[3] = AACI_FEN | RxSize[3] | CmpctMod | AACI_RX8 |
                       AACI_RX9 | AACI_REN;
  CW.DatRxCntlReg[4] = AACI_FEN | RxSize[4] | CmpctMod | AACI_RX10 |
                       AACI_RX12 | AACI_REN;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S1 | S2 | S3 | S7 | S8 | S9 | S11 | S12;
  CW.AACI_SLOT0[3] = FV | S1 | S2 | S3 | S7 | S8 | S9 | S11 | S12;
  CW.AACI_SLOT0[4] = FV | S1 | S2 | S3 | S7 | S8 | S9 | S11 | S12;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = FV;
  CW.AACITB_SLOT0[2] = Calculate_TrSlot0();
  CW.AACITB_SLOT0[3] = Calculate_TrSlot0();
  CW.AACITB_SLOT0[4] = FV;

  /* Perform a 4-frame data transfer with the above settings */
  TxRx_SlPCLK_Test(4);

  C("Channel3Tx enabled and has slots 1, 2, 11 and 12");
  C("Channel3Rx enabled and has slots 1, 2, 3, 4, 5, 10, 11 and 12");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | CmpctMod | AACI_TX1 |
                       AACI_TX2 | AACI_TX11 | AACI_TX12 | AACI_TEN;

  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[3] = AACI_FEN | RxSize[3] | CmpctMod | AACI_RX1 |
                       AACI_RX2 | AACI_RX3 | AACI_RX4 | AACI_RX5 |
                       AACI_RX10 | AACI_RX11 | AACI_RX12 | AACI_REN;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S1 | S2 | S11 | S12;
  CW.AACI_SLOT0[3] = FV | S1 | S2 | S11 | S12;
  CW.AACI_SLOT0[4] = FV | S1 | S2 | S11 | S12;
  CW.AACI_SLOT0[5] = FV | S1 | S2 | S11 | S12;
  CW.AACI_SLOT0[6] = FV | S1 | S2 | S11 | S12;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = Calculate_TrSlot0();
  CW.AACITB_SLOT0[2] = Calculate_TrSlot0();
  CW.AACITB_SLOT0[3] = Calculate_TrSlot0();
  CW.AACITB_SLOT0[4] = FV;
  CW.AACITB_SLOT0[5] = Calculate_TrSlot0();
  CW.AACITB_SLOT0[6] = Calculate_TrSlot0();

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_SlPCLK_Test(6);

/**********************************************************************/
/**************** Tx & Rx - CH & SLReg - FIFO mode - No SRC ***********/
/**********************************************************************/
  /*
    The AACI is programmed for both transmission and reception in the
    FIFO mode. AACISLnTX (n = 1, 2 and 12) are also enabled for
    transmission. AACISLnRX (n = 1, 2 and 12) are enabled for
    reception.
    No SRC bits are set in the incoming frames. Seven data tests are
    done under this category. The following parameters are varied for
    each test.
      o The number of slots enabled for transmission per channel
      o The number of slots enabled per Rx channel
      o The number of slots enabled per transmitted frame.
      o The number of slots enabled per received frame.
      o TSIZE and RSIZE
      o Information about which of the AACISLnTX (n = 1, 2, 12)
        registers are to be loaded with new data for each frame
      o Slot0 to be transmitted by the trickbox for each frame
      o Whether data for Slots 1, 2 and 12 are present in Channels AND
        Slot registers (as against data being present for these slots
        ONLY in Slot registers or ONLY in channels)

    The tests are repeated by programming the channels to transfer
    data for different combinations of slots.

    The test cases having an even number of slots enabled per channel
    are again executed with the CM bit set in the AACITXCRn (n = 1 to 4)
    and AACIRXCRn (n = 1 to 4) register.

  */

  C("Tx & Rx - CH & SLReg - FIFO mode - No SRC");
  C("Channel1Tx enabled and has slots 1, 2, 4 and 12");
  C("Channel1Rx enabled and has slots 1, 2, 3, 7, 8, 9, 10 and 12");
  C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");

  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TX1 |
                       AACI_TX2 | AACI_TX4 | AACI_TX12 | AACI_TEN;

  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[1] = AACI_FEN | RxSize[1] | CmpctMod | AACI_RX1 |
                       AACI_RX2 | AACI_RX3 | AACI_RX7 | AACI_RX8 |
                       AACI_RX9 | AACI_RX10 | AACI_RX12 | AACI_REN;
  CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S1 | S2 | S4 | S12;
  CW.AACI_SLOT0[3] = FV | S1 | S2 | S4 | S12;
  CW.AACI_SLOT0[4] = FV | S1 | S2 | S4 | S12;
  CW.AACI_SLOT0[5] = FV | S1 | S2 | S4 | S12;
  CW.AACI_SLOT0[6] = FV | S1 | S2 | S4 | S12;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = FV;
  CW.AACITB_SLOT0[2] = Calculate_TrSlot0();
  CW.AACITB_SLOT0[3] = Calculate_TrSlot0();
  CW.AACITB_SLOT0[4] = Calculate_TrSlot0();
  CW.AACITB_SLOT0[5] = Calculate_TrSlot0();
  CW.AACITB_SLOT0[6] = FV;

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_SlPCLK_Test(6);

  C("Channel1Tx enabled and has slot 1");
  C("Channel2Tx enabled and has slot 2");
  C("Channel3Tx enabled and has slots 4, 6, 7 and 8");
  C("Channel4Tx enabled and has slot 11");
  C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");
  C("Channel3Rx enabled and has slots 1, 2, 3, 4, 9, 10, 11 and 12");
  C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  C("Secondary CODEC 1 is accessed");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | AACI_TX1 | AACI_TEN;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | AACI_TX2 | AACI_TEN;
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TX4 |
                       AACI_TX6 | AACI_TX7 | AACI_TX8 | AACI_TEN;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[2] | AACI_TX11 | AACI_TEN;
  CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[3] = AACI_FEN | RxSize[3] | CmpctMod | AACI_RX1 |
                       AACI_RX2 | AACI_RX3 | AACI_RX4 | AACI_RX9 |
                       AACI_RX10 | AACI_RX11 | AACI_RX12 | AACI_REN;
  CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;

  /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the channels
     for each frame */
  CW.TxFIFOWtSltEn[1] = 0x0;
  CW.TxFIFOWtSltEn[2] = TX1 | TX2 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFOWtSltEn[3] = TX2 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFOWtSltEn[4] = TX1 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFOWtSltEn[5] = 0x0;
  CW.TxFIFOWtSltEn[6] = TX1;
  CW.TxFIFOWtSltEn[7] = TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFOWtSltEn[8] = TX1;

  /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from Channel Tx FIFOs of
     the AACI (data could be from either the Channels or from the
     AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxFIFORdSltEn[1] = 0x0;
  CW.TxFIFORdSltEn[2] = TX1 | TX2 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFORdSltEn[3] = TX2 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFORdSltEn[4] = TX1 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFORdSltEn[5] = 0x0;
  CW.TxFIFORdSltEn[6] = TX1;
  CW.TxFIFORdSltEn[7] = TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFORdSltEn[8] = 0x0;

  /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from the AACISLnTX 
     (n = 1, 2, 12) registers (data could be from either the Channels
     or from the AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxRegRdSltEn[1] = 0x0;
  CW.TxRegRdSltEn[2] = TX12;
  CW.TxRegRdSltEn[3] = TX1;
  CW.TxRegRdSltEn[4] = TX2;
  CW.TxRegRdSltEn[5] = TX1 | TX2;
  CW.TxRegRdSltEn[6] = 0x0;
  CW.TxRegRdSltEn[7] = 0x0;
  CW.TxRegRdSltEn[8] = TX1;

  /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the 
     AACISLnTX (n = 1, 2, 12) registers for each frame */
  CW.TxRegWtSltEn[1] = 0x0;
  CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
  CW.TxRegWtSltEn[3] = 0x0;
  CW.TxRegWtSltEn[4] = 0x0;
  CW.TxRegWtSltEn[5] = TX1 | TX2;
  CW.TxRegWtSltEn[6] = 0x0;
  CW.TxRegWtSltEn[7] = 0x0;
  CW.TxRegWtSltEn[8] = TX1;

  /* Select secondary CODEC 1 */
  CW.SecCODEC = AACI_SCRA1;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S4 | S6 | S7 | S8 | S11 | S12 | SC1;
  CW.AACI_SLOT0[3] = FV | S4 | S6 | S7 | S8 | S11 | SC1;
  CW.AACI_SLOT0[4] = FV | S4 | S6 | S7 | S8 | S11 | SC1;
  CW.AACI_SLOT0[5] = FV | SC1;
  CW.AACI_SLOT0[6] = FV | SC1;
  CW.AACI_SLOT0[7] = FV | S4 | S6 | S7 | S8 | S11;
  CW.AACI_SLOT0[8] = FV | SC1;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[5] = FV;
  CW.AACITB_SLOT0[6] = FV;

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_SlPCLK_Test(6);

  C("Channel1Tx enabled and has slot 1");
  C("Channel2Tx enabled and has slot 2");
  C("Channel3Tx enabled and has slots 4, 6, 7 and 8");
  C("Channel4Tx enabled and has slot 11");
  C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");
  C("Channel3Rx enabled and has slots 1, 2, 3, 4, 9, 10, 11 and 12");
  C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  C("Secondary CODEC 2 is accessed");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | AACI_TX1 | AACI_TEN;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | AACI_TX2 | AACI_TEN;
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TX4 |
                       AACI_TX6 | AACI_TX7 | AACI_TX8 | AACI_TEN;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[2] | AACI_TX11 | AACI_TEN;
  CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[3] = AACI_FEN | RxSize[3] | CmpctMod | AACI_RX1 |
                       AACI_RX2 | AACI_RX3 | AACI_RX4 | AACI_RX9 |
                       AACI_RX10 | AACI_RX11 | AACI_RX12 | AACI_REN;
  CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;

  /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the channels
     for each frame */
  CW.TxFIFOWtSltEn[1] = 0x0;
  CW.TxFIFOWtSltEn[2] = TX1 | TX2 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFOWtSltEn[3] = TX2 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFOWtSltEn[4] = TX1 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFOWtSltEn[5] = 0x0;
  CW.TxFIFOWtSltEn[6] = TX1;
  CW.TxFIFOWtSltEn[7] = TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFOWtSltEn[8] = TX1;

  /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from Channel Tx FIFOs of
     the AACI (data could be from either the Channels or from the
     AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxFIFORdSltEn[1] = 0x0;
  CW.TxFIFORdSltEn[2] = TX1 | TX2 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFORdSltEn[3] = TX2 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFORdSltEn[4] = TX1 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFORdSltEn[5] = 0x0;
  CW.TxFIFORdSltEn[6] = TX1;
  CW.TxFIFORdSltEn[7] = TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFORdSltEn[8] = 0x0;

  /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from the AACISLnTX 
     (n = 1, 2, 12) registers (data could be from either the Channels
     or from the AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxRegRdSltEn[1] = 0x0;
  CW.TxRegRdSltEn[2] = TX12;
  CW.TxRegRdSltEn[3] = TX1;
  CW.TxRegRdSltEn[4] = TX2;
  CW.TxRegRdSltEn[5] = TX1 | TX2;
  CW.TxRegRdSltEn[6] = 0x0;
  CW.TxRegRdSltEn[7] = 0x0;
  CW.TxRegRdSltEn[8] = TX1;

  /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the 
     AACISLnTX (n = 1, 2, 12) registers for each frame */
  CW.TxRegWtSltEn[1] = 0x0;
  CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
  CW.TxRegWtSltEn[3] = 0x0;
  CW.TxRegWtSltEn[4] = 0x0;
  CW.TxRegWtSltEn[5] = TX1 | TX2;
  CW.TxRegWtSltEn[6] = 0x0;
  CW.TxRegWtSltEn[7] = 0x0;
  CW.TxRegWtSltEn[8] = TX1;

  /* Select secondary CODEC 2 */
  CW.SecCODEC = AACI_SCRA2;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S4 | S6 | S7 | S8 | S11 | S12 | SC2;
  CW.AACI_SLOT0[3] = FV | S4 | S6 | S7 | S8 | S11 | SC2;
  CW.AACI_SLOT0[4] = FV | S4 | S6 | S7 | S8 | S11 | SC2;
  CW.AACI_SLOT0[5] = FV | SC2;
  CW.AACI_SLOT0[6] = FV | SC2;
  CW.AACI_SLOT0[7] = FV | S4 | S6 | S7 | S8 | S11;
  CW.AACI_SLOT0[8] = FV | SC2;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[5] = FV;
  CW.AACITB_SLOT0[6] = FV;

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_SlPCLK_Test(6);

  C("Channel1Tx enabled and has slot 1");
  C("Channel2Tx enabled and has slot 2");
  C("Channel3Tx enabled and has slots 4, 6, 7 and 8");
  C("Channel4Tx enabled and has slot 11");
  C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");
  C("Channel3Rx enabled and has slots 1, 2, 3, 4, 9, 10, 11 and 12");
  C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  C("Secondary CODEC 3 is accessed");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | AACI_TX1 | AACI_TEN;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | AACI_TX2 | AACI_TEN;
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TX4 |
                       AACI_TX6 | AACI_TX7 | AACI_TX8 | AACI_TEN;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[2] | AACI_TX11 | AACI_TEN;
  CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[3] = AACI_FEN | RxSize[3] | CmpctMod | AACI_RX1 |
                       AACI_RX2 | AACI_RX3 | AACI_RX4 | AACI_RX9 |
                       AACI_RX10 | AACI_RX11 | AACI_RX12 | AACI_REN;
  CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;

  /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the channels
     for each frame */
  CW.TxFIFOWtSltEn[1] = 0x0;
  CW.TxFIFOWtSltEn[2] = TX1 | TX2 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFOWtSltEn[3] = TX2 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFOWtSltEn[4] = TX1 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFOWtSltEn[5] = 0x0;
  CW.TxFIFOWtSltEn[6] = TX1;
  CW.TxFIFOWtSltEn[7] = TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFOWtSltEn[8] = TX1;

  /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from Channel Tx FIFOs of
     the AACI (data could be from either the Channels or from the
     AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxFIFORdSltEn[1] = 0x0;
  CW.TxFIFORdSltEn[2] = TX1 | TX2 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFORdSltEn[3] = TX2 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFORdSltEn[4] = TX1 | TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFORdSltEn[5] = 0x0;
  CW.TxFIFORdSltEn[6] = TX1;
  CW.TxFIFORdSltEn[7] = TX4 | TX6 | TX7 | TX8 | TX11;
  CW.TxFIFORdSltEn[8] = 0x0;

  /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from the AACISLnTX 
     (n = 1, 2, 12) registers (data could be from either the Channels
     or from the AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxRegRdSltEn[1] = 0x0;
  CW.TxRegRdSltEn[2] = TX12;
  CW.TxRegRdSltEn[3] = TX1;
  CW.TxRegRdSltEn[4] = TX2;
  CW.TxRegRdSltEn[5] = TX1 | TX2;
  CW.TxRegRdSltEn[6] = 0x0;
  CW.TxRegRdSltEn[7] = 0x0;
  CW.TxRegRdSltEn[8] = TX1;

  /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the 
     AACISLnTX (n = 1, 2, 12) registers for each frame */
  CW.TxRegWtSltEn[1] = 0x0;
  CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
  CW.TxRegWtSltEn[3] = 0x0;
  CW.TxRegWtSltEn[4] = 0x0;
  CW.TxRegWtSltEn[5] = TX1 | TX2;
  CW.TxRegWtSltEn[6] = 0x0;
  CW.TxRegWtSltEn[7] = 0x0;
  CW.TxRegWtSltEn[8] = TX1;

  /* Select secondary CODEC 3 */
  CW.SecCODEC = AACI_SCRA3;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S4 | S6 | S7 | S8 | S11 | S12 | SC3;
  CW.AACI_SLOT0[3] = FV | S4 | S6 | S7 | S8 | S11 | SC3;
  CW.AACI_SLOT0[4] = FV | S4 | S6 | S7 | S8 | S11 | SC3;
  CW.AACI_SLOT0[5] = FV | SC3;
  CW.AACI_SLOT0[6] = FV | SC3;
  CW.AACI_SLOT0[7] = FV | S4 | S6 | S7 | S8 | S11;
  CW.AACI_SLOT0[8] = FV | SC3;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[5] = FV;
  CW.AACITB_SLOT0[6] = FV;

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_SlPCLK_Test(6);

  C("Channel1Tx enabled and has slots 1 and 3");
  C("Channel2Tx enabled and has slot 2");
  C("Channel4Tx enabled and has slots 10 and 11");
  C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");
  C("Channel4Rx enabled and has slots 9, 10, 11 and 12");
  C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  C("Testing Slot2 dependency on Slot1");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TX1 |
                       AACI_TX3 | AACI_TEN;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | AACI_TX2 | AACI_TEN;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TX10 |
                       AACI_TX11 | AACI_TEN;
  CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[4] = AACI_FEN | RxSize[3] | CmpctMod | AACI_RX9 |
                       AACI_RX10 | AACI_RX11 | AACI_RX12 | AACI_REN;
  CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;

  /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the channels
     for each frame */
  CW.TxFIFOWtSltEn[1] = 0x0;
  CW.TxFIFOWtSltEn[2] = TX2 | TX10 | TX11;
  CW.TxFIFOWtSltEn[3] = TX1 | TX3 | TX10 | TX11;
  CW.TxFIFOWtSltEn[4] = TX10 | TX11;
  CW.TxFIFOWtSltEn[5] = 0x0;
  CW.TxFIFOWtSltEn[6] = 0x0;

  /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from Channel Tx FIFOs of
     the AACI (data could be from either the Channels or from the
     AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxFIFORdSltEn[1] = 0x0;
  CW.TxFIFORdSltEn[2] = TX10 | TX11;
  CW.TxFIFORdSltEn[3] = TX1 | TX2 | TX3 | TX10 | TX11;
  CW.TxFIFORdSltEn[4] = TX10 | TX11;
  CW.TxFIFORdSltEn[5] = 0x0;
  CW.TxFIFORdSltEn[6] = 0x0;

  /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from the AACISLnTX 
     (n = 1, 2, 12) registers (data could be from either the Channels
     or from the AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxRegRdSltEn[1] = 0x0;
  CW.TxRegRdSltEn[2] = TX12;
  CW.TxRegRdSltEn[3] = 0x0;
  CW.TxRegRdSltEn[4] = 0x0;
  CW.TxRegRdSltEn[5] = 0x0;
  CW.TxRegRdSltEn[6] = TX1 | TX2;

  /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the 
     AACISLnTX (n = 1, 2, 12) registers for each frame */
  CW.TxRegWtSltEn[1] = 0x0;
  CW.TxRegWtSltEn[2] = TX2 | TX12;
  CW.TxRegWtSltEn[3] = 0x0;
  CW.TxRegWtSltEn[4] = 0x0;
  CW.TxRegWtSltEn[5] = 0x0;
  CW.TxRegWtSltEn[6] = TX1;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  for (i = 1; i < 7; i++)
    CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[5] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[6] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_SlPCLK_Test(6);

  C("Channel1Tx enabled and has slots 5 and 6");
  C("Channel2Tx enabled and has slot 9");
  C("Channel3Tx enabled and has slot 2");
  C("Channel4Tx enabled and has slots 1 and 7");
  C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");
  C("Channel2Rx enabled and has slots 1, 2, 3 and 4");
  C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  C("Testing Slot2 dependency on Slot1");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TX5 |
                       AACI_TX6 | AACI_TEN;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | AACI_TX9 | AACI_TEN;
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[2] | AACI_TX2 | AACI_TEN;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TX1 |
                       AACI_TX7 | AACI_TEN;
  CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[2] = AACI_FEN | RxSize[3] | CmpctMod | AACI_RX9 |
                       AACI_RX10 | AACI_RX11 | AACI_RX12 | AACI_REN;
  CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;

  /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the channels
     for each frame */
  CW.TxFIFOWtSltEn[1] = 0x0;
  CW.TxFIFOWtSltEn[2] = TX2 | TX5 | TX6 | TX9;
  CW.TxFIFOWtSltEn[3] = TX5 | TX6 | TX9;
  CW.TxFIFOWtSltEn[4] = TX5 | TX6 | TX9;
  CW.TxFIFOWtSltEn[5] = TX5 | TX6 | TX9;
  CW.TxFIFOWtSltEn[6] = 0x0;
  CW.TxFIFOWtSltEn[7] = TX1 | TX5 | TX6 | TX7 | TX9;

  /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from Channel Tx FIFOs of
     the AACI (data could be from either the Channels or from the
     AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxFIFORdSltEn[1] = 0x0;
  CW.TxFIFORdSltEn[2] = TX5 | TX6 | TX9;
  CW.TxFIFORdSltEn[3] = TX5 | TX6 | TX9;
  CW.TxFIFORdSltEn[4] = TX5 | TX6 | TX9;
  CW.TxFIFORdSltEn[5] = TX2 | TX5 | TX6 | TX9;
  CW.TxFIFORdSltEn[6] = 0x0;
  CW.TxFIFORdSltEn[7] = TX1 | TX5 | TX6 | TX7 | TX9;

  /* CW.Slt2Corcfct assigned with correction factor. This is used to
     point to the correct element in the expected-value array.
     Specifically, this factor is required to test the dependency
     of Slot 2 data on Slot 1 data. */
  CW.Slt2Corcfct = 39;

  /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from the AACISLnTX 
     (n = 1, 2, 12) registers (data could be from either the Channels
     or from the AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxRegRdSltEn[1] = 0x0;
  CW.TxRegRdSltEn[2] = TX12;
  CW.TxRegRdSltEn[3] = 0x0;
  CW.TxRegRdSltEn[4] = 0x0;
  CW.TxRegRdSltEn[5] = TX1;
  CW.TxRegRdSltEn[6] = 0x0;
  CW.TxRegRdSltEn[7] = TX2;

  /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the 
     AACISLnTX (n = 1, 2, 12) registers for each frame */
  CW.TxRegWtSltEn[1] = 0x0;
  CW.TxRegWtSltEn[2] = TX2 | TX12;
  CW.TxRegWtSltEn[3] = 0x0;
  CW.TxRegWtSltEn[4] = 0x0;
  CW.TxRegWtSltEn[5] = TX1;
  CW.TxRegWtSltEn[6] = 0x0;
  CW.TxRegWtSltEn[7] = 0x0;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  for (i = 1; i < 8; i++)
    CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[5] = FV;
  CW.AACITB_SLOT0[6] = FV;
  CW.AACITB_SLOT0[7] = FV;

  /* Perform a 7-frame data transfer with the above settings */
  TxRx_SlPCLK_Test(7);

  C("Channel2Tx enabled and has slots 5, 6 and 9");
  C("Channel3Tx enabled and has slots 1 and 4");
  C("Channel4Tx enabled and has slot 2");
  C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");
  C("Channel1Rx enabled and has slots 1, 2, 3 and 4");
  C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  C("Testing Slot2 dependency on Slot1 when accessing CODEC 2");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[1] | AACI_TX5 | AACI_TX6 |
                       AACI_TX9 | AACI_TEN;
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TX1 |
                       AACI_TX4 | AACI_TEN;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[2] | AACI_TX2 | AACI_TEN;
  CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[1] = AACI_FEN | RxSize[3] | CmpctMod | AACI_RX1 |
                       AACI_RX2 | AACI_RX3 | AACI_RX4 | AACI_REN;
  CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;

  /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the channels
     for each frame */
  CW.TxFIFOWtSltEn[1] = 0x0;
  CW.TxFIFOWtSltEn[2] = TX2 | TX5 | TX6 | TX9;
  CW.TxFIFOWtSltEn[3] = TX1 | TX4 | TX5 | TX6 | TX9;
  CW.TxFIFOWtSltEn[4] = TX5 | TX6 | TX9;
  CW.TxFIFOWtSltEn[5] = 0x0;
  CW.TxFIFOWtSltEn[6] = 0x0;

  /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from Channel Tx FIFOs of
     the AACI (data could be from either the Channels or from the
     AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxFIFORdSltEn[1] = 0x0;
  CW.TxFIFORdSltEn[2] = TX5 | TX6 | TX9;
  CW.TxFIFORdSltEn[3] = TX1 | TX2 | TX4 | TX5 | TX6 | TX9;
  CW.TxFIFORdSltEn[4] = TX5 | TX6 | TX9;
  CW.TxFIFORdSltEn[5] = 0x0;
  CW.TxFIFORdSltEn[6] = 0x0;

  /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from the AACISLnTX 
     (n = 1, 2, 12) registers (data could be from either the Channels
     or from the AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxRegRdSltEn[1] = 0x0;
  CW.TxRegRdSltEn[2] = TX12;
  CW.TxRegRdSltEn[3] = 0x0;
  CW.TxRegRdSltEn[4] = 0x0;
  CW.TxRegRdSltEn[5] = 0x0;
  CW.TxRegRdSltEn[6] = TX1 | TX2;

  /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the 
     AACISLnTX (n = 1, 2, 12) registers for each frame */
  CW.TxRegWtSltEn[1] = 0x0;
  CW.TxRegWtSltEn[2] = TX2 | TX12;
  CW.TxRegWtSltEn[3] = 0x0;
  CW.TxRegWtSltEn[4] = 0x0;
  CW.TxRegWtSltEn[5] = 0x0;
  CW.TxRegWtSltEn[6] = TX1;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S5 | S6 | S9 | S12;
  CW.AACI_SLOT0[3] = FV | S4 | S5 | S6 | S9 | SC2;
  CW.AACI_SLOT0[4] = FV | S5 | S6 | S9;
  CW.AACI_SLOT0[5] = 0x0;
  CW.AACI_SLOT0[6] = FV | SC2;

  /* Select secondary CODEC 2 */
  CW.SecCODEC = AACI_SCRA2;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[5] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[6] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_SlPCLK_Test(6);

/**********************************************************************/
/**************** Tx & Rx - CH & SLReg - FIFO mode - SRC **************/
/**********************************************************************/
  /*
    The AACI is programmed for both transmission and reception in the
    FIFO mode. AACISLnTX (n = 1, 2 and 12) are enabled for
    transmission. AACISLnRX (n = 1, 2 and 12) are enabled for
    reception. SRC bits are set in the incoming frames. Six data
    tests are done under this category. The following parameters are
    varied for each test.
      o The number of slots enabled for transmission per channel
      o The number of slots enabled per Rx channel
      o The number of slots enabled per transmitted frame.
      o The number of slots enabled per received frame.
      o TSIZE and RSIZE
      o Information about which of the AACISLnTX (n = 1, 2, 12)
        registers are to be loaded with new data for each frame
      o SRC bit-pattern to be transmitted by the trickbox for each frame
      o Slot0 to be transmitted by the trickbox for each frame
      o Whether data for Slots 1, 2 and 12 are present in Channels AND
        Slot registers (as against data being present for these slots
        ONLY in Slot registers or ONLY in channels)

    The tests are repeated by programming the channels to transfer
    data for different combinations of slots.

    The test cases having an even number of slots enabled per channel
    are again executed with the CM bit set in the AACITXCRn (n = 1 to 4)
    and AACIRXCRn (n = 1 to 4) register.

  */

  C("Tx & Rx - CH & SLReg - FIFO mode - SRC");
  C("Channel1Tx enabled and has slots 3, 4, 5 and 11");
  C("AACISL1TX, AACISL2TX, AACISL2TX are enabled");
  C("Channel1Rx enabled and has slots 1, 2, 3 and 12");
  C("SRC bits set for multiple slots");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | CmpctMod  | AACI_TX3 |
                       AACI_TX4 | AACI_TX5 | AACI_TX11 | AACI_TEN;
  CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[1] = AACI_FEN | RxSize[1] | CmpctMod | AACI_RX1 |
                       AACI_RX2 | AACI_RX3 | AACI_RX12 | AACI_REN;

  /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from the AACISLnTX 
     (n = 1, 2, 12) registers (data could be from either the Channels
     or from the AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxRegRdSltEn[1] = 0x0;
  CW.TxRegRdSltEn[2] = TX1 | TX2;
  CW.TxRegRdSltEn[3] = TX12;
  CW.TxRegRdSltEn[4] = 0x0;
  CW.TxRegRdSltEn[5] = 0x0;

  /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the 
     AACISLnTX (n = 1, 2, 12) registers for each frame */
  CW.TxRegWtSltEn[1] = 0x0;
  CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
  CW.TxRegWtSltEn[3] = 0x0;
  CW.TxRegWtSltEn[4] = 0x0;
  CW.TxRegWtSltEn[5] = 0x0;

  /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the channels
     for each frame */
  CW.TxFIFOWtSltEn[2] = TX3 | TX4 | TX5 | TX11;
  CW.TxFIFOWtSltEn[3] = 0x0;
  CW.TxFIFOWtSltEn[4] = TX3 | TX4 | TX5 | TX11;
  CW.TxFIFOWtSltEn[5] = 0x0;

  /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from Channel Tx FIFOs of
     the AACI (data could be from either the Channels or from the
     AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxFIFORdSltEn[1] = 0x0;
  CW.TxFIFORdSltEn[2] = 0x0;
  CW.TxFIFORdSltEn[3] = TX3 | TX4 | TX5 | TX11;
  CW.TxFIFORdSltEn[4] = 0x0;
  CW.TxFIFORdSltEn[5] = TX3 | TX4 | TX5 | TX11;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  for (i = 1; i < 6; i++)
   CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S9 | S10 | S12;
  CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S9 | S10 | S12;
  CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S9 | S10 | S12;
  CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S9 | S10 | S12;
  CW.AACITB_SLOT0[5] = FV;

  /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
     about which of the SRC bits need to be set by the trickbox
     for each frame  */
  CW.AACITB_SLOT1[1] = SRC3 | SRC4 | SRC5 | SRC6 | SRC7 | SRC8 |
                       SRC9 | SRC10 | SRC11 | SRC12;
  CW.AACITB_SLOT1[2] = 0x0;
  CW.AACITB_SLOT1[3] = SRC3 | SRC4 | SRC5 | SRC6 | SRC7 | SRC8 |
                       SRC9 | SRC10 | SRC11 | SRC12;
  CW.AACITB_SLOT1[4] = 0x0;
  CW.AACITB_SLOT1[5] = 0x0;

  /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
     version of the SRC bits transmitted by the trickbox. This is
     used for computational purposes. */
  CW.RemapedSRC[1] = RemapSR(1);
  CW.RemapedSRC[2] = RemapSR(2);
  CW.RemapedSRC[3] = RemapSR(3);
  CW.RemapedSRC[4] = RemapSR(4);
  CW.RemapedSRC[5] = RemapSR(5);

  /* Perform a 5-frame data transfer with the above settings */
  TxRx_SlPCLK_Test(5);

  C("Channel2Tx enabled and has slots 3, 9, 11 and 12");
  C("Channel3Rx enabled and has slots 1, 2, 3, 8, 9, 10, 11 and 12");
  C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  C("SRC bits set for multiple slots");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TX3 |
                       AACI_TX9 | AACI_TX11 | AACI_TX12 | AACI_TEN;

  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[3] = AACI_FEN | RxSize[3] | CmpctMod | AACI_RX1 |
                       AACI_RX2 | AACI_RX3 | AACI_RX4 | AACI_RX9 |
                       AACI_RX10 | AACI_RX11 | AACI_RX12 | AACI_REN;
  CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;

  /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the channels
     for each frame */
  CW.TxFIFOWtSltEn[1] = 0x0;
  CW.TxFIFOWtSltEn[2] = TX3 | TX9 | TX11 | TX12;
  CW.TxFIFOWtSltEn[3] = TX3 | TX9 | TX11 | TX12;
  CW.TxFIFOWtSltEn[4] = 0x0;
  CW.TxFIFOWtSltEn[5] = TX3 | TX9 | TX11 | TX12;
  CW.TxFIFOWtSltEn[6] = 0x0;

  /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from Channel Tx FIFOs of
     the AACI (data could be from either the Channels or from the
     AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxFIFORdSltEn[1] = 0x0;
  CW.TxFIFORdSltEn[2] = TX3 | TX9 | TX11 | TX12;
  CW.TxFIFORdSltEn[3] = 0x0;
  CW.TxFIFORdSltEn[4] = TX3 | TX9 | TX11 | TX12;
  CW.TxFIFORdSltEn[5] = 0x0;
  CW.TxFIFORdSltEn[6] = TX3 | TX9 | TX11 | TX12;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S3 | S9 | S11 | S12;
  CW.AACI_SLOT0[3] = 0x0;
  CW.AACI_SLOT0[4] = FV | S3 | S9 | S11 | S12;
  CW.AACI_SLOT0[5] = 0x0;
  CW.AACI_SLOT0[6] = FV | S3 | S9 | S11 | S12;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
  CW.AACITB_SLOT0[5] = FV;
  CW.AACITB_SLOT0[6] = FV;

  /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
     about which of the SRC bits need to be set by the trickbox
     for each frame  */
  CW.AACITB_SLOT1[1] = 0x0;
  CW.AACITB_SLOT1[2] = SRC3 | SRC9 | SRC11 | SRC12;
  CW.AACITB_SLOT1[3] = 0x0;
  CW.AACITB_SLOT1[4] = SRC3 | SRC9 | SRC11 | SRC12;
  CW.AACITB_SLOT1[5] = 0x0;
  CW.AACITB_SLOT1[6] = 0x0;

  /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
     version of the SRC bits transmitted by the trickbox. This is
     used for computational purposes. */
  CW.RemapedSRC[1] = RemapSR(1);
  CW.RemapedSRC[2] = RemapSR(2);
  CW.RemapedSRC[3] = RemapSR(3);
  CW.RemapedSRC[4] = RemapSR(4);
  CW.RemapedSRC[5] = RemapSR(5);
  CW.RemapedSRC[6] = RemapSR(6);

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_SlPCLK_Test(6);

  C("Channel1Tx enabled and has slots 7, 8, 9 and 12");
  C("Channel2Tx enabled and has slots 3 and 11");
  C("AACISL1TX, AACISL12TX are enabled");
  C("Channel1Rx enabled and has slots 1, 2, 8, 9, 10 and 12");
  C("Channel2Rx enabled and has slots 3, 7 and 11");
  C("AACISL2RX, AACISL12RX are enabled");
  C("SRC bits set for multiple slots");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TX7 |
                       AACI_TX8 | AACI_TX9 | AACI_TX12 | AACI_TEN;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TX3 |
                       AACI_TX11 | AACI_TEN;
  CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX12;

  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[1] = AACI_FEN | RxSize[1] | CmpctMod | AACI_RX1 |
                       AACI_RX2 | AACI_RX8 | AACI_RX9 | AACI_RX10 |
                       AACI_RX12 | AACI_REN;
  CW.DatRxCntlReg[2] = AACI_FEN | RxSize[2] | AACI_RX3 | AACI_RX5 |
                       AACI_RX6 | AACI_RX7 | AACI_RX11 | AACI_REN;
  CW.DatRxCntlReg[5] = AACI_RX2 | AACI_RX12;

  /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from the AACISLnTX 
     (n = 1, 2, 12) registers (data could be from either the Channels
     or from the AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxRegRdSltEn[1] = 0x0;
  CW.TxRegRdSltEn[2] = TX1;
  CW.TxRegRdSltEn[3] = TX1;
  CW.TxRegRdSltEn[4] = 0x0;
  CW.TxRegRdSltEn[5] = 0x0;
  CW.TxRegRdSltEn[6] = TX12;

  /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the 
     AACISLnTX (n = 1, 2, 12) registers for each frame */
  CW.TxRegWtSltEn[1] = 0x0;
  CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
  CW.TxRegWtSltEn[3] = TX1;
  CW.TxRegWtSltEn[4] = 0x0;
  CW.TxRegWtSltEn[5] = 0x0;
  CW.TxRegWtSltEn[6] = 0x0;

  /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the channels
     for each frame */
  CW.TxFIFOWtSltEn[2]  = TX3 | TX7 | TX8 | TX9 | TX11 | TX12;
  CW.TxFIFOWtSltEn[3]  = TX3 | TX11;
  CW.TxFIFOWtSltEn[4]  = TX7 | TX8 | TX9 | TX12;
  CW.TxFIFOWtSltEn[5]  = TX3 | TX11;
  CW.TxFIFOWtSltEn[6]  = 0x0;

  /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from Channel Tx FIFOs of
     the AACI (data could be from either the Channels or from the
     AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxFIFORdSltEn[1]  = 0x0;
  CW.TxFIFORdSltEn[2]  = TX3 | TX11;
  CW.TxFIFORdSltEn[3]  = TX7 | TX8 | TX9 | TX12;
  CW.TxFIFORdSltEn[4]  = TX3 | TX11;
  CW.TxFIFORdSltEn[5]  = TX7 | TX8 | TX9 | TX12;
  CW.TxFIFORdSltEn[6]  = TX3 | TX11;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S1 | S3 | S11;
  CW.AACI_SLOT0[3] = FV | S1 | S7 | S8 | S9 | S12;
  CW.AACI_SLOT0[4] = FV | S3 | S11;
  CW.AACI_SLOT0[5] = FV | S7 | S8 | S9 | S12;
  CW.AACI_SLOT0[6] = FV | S3 | S11 | S12;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;
  CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;
  CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;
  CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;
  CW.AACITB_SLOT0[5] = FV;
  CW.AACITB_SLOT0[6] = FV;

  /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
     about which of the SRC bits need to be set by the trickbox
     for each frame  */
  CW.AACITB_SLOT1[1] = SRC7 | SRC8 | SRC9 | SRC12;
  CW.AACITB_SLOT1[2] = SRC3 | SRC11;
  CW.AACITB_SLOT1[3] = SRC7 | SRC8 | SRC9 | SRC12;
  CW.AACITB_SLOT1[4] = SRC3 | SRC11;
  CW.AACITB_SLOT1[5] = 0x0;
  CW.AACITB_SLOT1[6] = 0x0;

  /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
     version of the SRC bits transmitted by the trickbox. This is
     used for computational purposes. */
  CW.RemapedSRC[1] = RemapSR(1);
  CW.RemapedSRC[2] = RemapSR(2);
  CW.RemapedSRC[3] = RemapSR(3);
  CW.RemapedSRC[4] = RemapSR(4);
  CW.RemapedSRC[5] = RemapSR(5);
  CW.RemapedSRC[6] = RemapSR(6);

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_SlPCLK_Test(6);

  C("Channel1Tx enabled and has slots 6, 8 and 12");
  C("Channel2Tx enabled and has slots 4, 5, 9 and 10");
  C("Channel3Tx enabled and has slots 3, 7 and 11");
  C("Channel4Tx enabled and has slots 1 and 2");
  C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");
  C("Channel1Rx enabled and has slots 1 and 2");
  C("Channel2Rx enabled and has slots 3, 7 and 11");
  C("Channel3Rx enabled and has slots 4, 5, 9 and 10");
  C("Channel4Rx enabled and has slots 6, 8 and 12");
  C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  C("SRC bits set for multiple slots");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | AACI_TX6 | AACI_TX8 |
                       AACI_TX12 | AACI_TEN;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TX4 |
                       AACI_TX5 | AACI_TX9 | AACI_TX10 | AACI_TEN;
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | AACI_TX3 | AACI_TX7 |
                       AACI_TX11 | AACI_TEN;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[4] | CmpctMod | AACI_TX1 |
                       AACI_TX2 | AACI_TEN;
  CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[1] = AACI_FEN | RxSize[1] | CmpctMod | AACI_RX1 |
                       AACI_RX2 | AACI_REN;
  CW.DatRxCntlReg[2] = AACI_FEN | RxSize[2] | AACI_RX3 | AACI_RX7 |
                       AACI_RX11 | AACI_REN;
  CW.DatRxCntlReg[3] = AACI_FEN | RxSize[3] | CmpctMod | AACI_RX4 |
                       AACI_RX5 | AACI_RX9 | AACI_RX10 | AACI_REN;
  CW.DatRxCntlReg[4] = AACI_FEN | RxSize[4] | AACI_RX6 | AACI_RX8 |
                       AACI_RX12 | AACI_REN;
  CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;

  /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from the AACISLnTX 
     (n = 1, 2, 12) registers (data could be from either the Channels
     or from the AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxRegRdSltEn[1] = 0x0;
  CW.TxRegRdSltEn[2] = 0x0;
  CW.TxRegRdSltEn[3] = 0x0;
  CW.TxRegRdSltEn[4] = TX1 | TX2;
  CW.TxRegRdSltEn[5] = 0x0;
  CW.TxRegRdSltEn[6] = 0x0;
  CW.TxRegRdSltEn[7] = TX12;

  /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the 
     AACISLnTX (n = 1, 2, 12) registers for each frame */
  CW.TxRegWtSltEn[1] = 0x0;
  CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
  CW.TxRegWtSltEn[3] = 0x0;
  CW.TxRegWtSltEn[4] = 0x0;
  CW.TxRegWtSltEn[5] = 0x0;
  CW.TxRegWtSltEn[6] = 0x0;
  CW.TxRegWtSltEn[7] = 0x0;

  /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the channels
     for each frame */
  CW.TxFIFOWtSltEn[2]  = TX1 | TX2 | TX3 | TX4 | TX5 | TX6 | TX7 |
                         TX8 | TX9 | TX10 | TX11 | TX12;
  CW.TxFIFOWtSltEn[3]  = TX1 | TX2 | TX4 | TX5 | TX9 | TX10;
  CW.TxFIFOWtSltEn[4]  = 0x0;
  CW.TxFIFOWtSltEn[5]  = TX3 | TX6 | TX7 | TX8 | TX11 | TX12;
  CW.TxFIFOWtSltEn[6]  = 0x0;
  CW.TxFIFOWtSltEn[7]  = 0x0;

  /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from Channel Tx FIFOs of
     the AACI (data could be from either the Channels or from the
     AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxFIFORdSltEn[1]  = 0x0;
  CW.TxFIFORdSltEn[2]  = TX1 | TX2 | TX4 | TX5 | TX9 | TX10;
  CW.TxFIFORdSltEn[3]  = TX1 | TX2 | TX4 | TX5 | TX9 | TX10;
  CW.TxFIFORdSltEn[4]  = TX3 | TX6 | TX7 | TX8 | TX11 | TX12;
  CW.TxFIFORdSltEn[5]  = 0x0;
  CW.TxFIFORdSltEn[6]  = TX3 | TX6 | TX7 | TX8 | TX11 | TX12;
  CW.TxFIFORdSltEn[7]  = 0x0;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S1 | S2 | S4 | S5 | S9 | S10;
  CW.AACI_SLOT0[3] = FV | S1 | S2 | S4 | S5 | S9 | S10;
  CW.AACI_SLOT0[4] = FV | S1 | S2 | S3 | S6 | S7 | S8 | S11 | S12;
  CW.AACI_SLOT0[5] = 0x0;
  CW.AACI_SLOT0[6] = FV | S3 | S6 | S7 | S8 | S11 | S12;
  CW.AACI_SLOT0[7] = FV | S12;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  for (i = 1; i < 8; i++)
    CW.AACITB_SLOT0[i] = FV | S1 | S2 | S3 | S4 | S5 | S9 | S10 |
                         S11 | S12;

  /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
     about which of the SRC bits need to be set by the trickbox
     for each frame  */
  CW.AACITB_SLOT1[1] = SRC3 | SRC6 | SRC7 | SRC8 | SRC11 | SRC12;
  CW.AACITB_SLOT1[2] = SRC3 | SRC6 | SRC7 | SRC8 | SRC11 | SRC12;
  CW.AACITB_SLOT1[3] = SRC4 | SRC5 | SRC9 | SRC10;
  CW.AACITB_SLOT1[4] = SRC3 | SRC6 | SRC7 | SRC8 | SRC11 | SRC12;
  CW.AACITB_SLOT1[5] = 0x0;
  CW.AACITB_SLOT1[6] = 0x0;
  CW.AACITB_SLOT1[7] = 0x0;

  /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
     version of the SRC bits transmitted by the trickbox. This is
     used for computational purposes. */
  for (i = 1; i < 8; i++)
    CW.RemapedSRC[i] = RemapSR(i);

  /* Perform a 7-frame data transfer with the above settings */
  TxRx_SlPCLK_Test(7);

  C("Channel1Tx enabled and has slots 4 and 11");
  C("Channel2Tx enabled and has slots 3 and 7");
  C("Channel3Tx enabled and has slots 6 and 12");
  C("Channel4Tx enabled and has slots 8 and 10");
  C("AACISL12TX are enabled");
  C("Channel1Rx enabled and has slots 3, 7 and 10");
  C("Channel2Rx enabled and has slots 6, 9 and 12");
  C("Channel3Rx enabled and has slots 5, 8 and 11");
  C("Channel4Rx enabled and has slots 1, 2 and 4");
  C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  C("SRC bits set for multiple slots");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TX4 |
                       AACI_TX11 | AACI_TEN;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TX3 |
                       AACI_TX7 | AACI_TEN;
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | CmpctMod | AACI_TX6 |
                       AACI_TX12 | AACI_TEN;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[4] | CmpctMod | AACI_TX8 |
                       AACI_TX10 | AACI_TEN;
  CW.DatTxCntlReg[5] = AACI_TX12;

  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[1] = AACI_FEN | RxSize[1] | AACI_RX3 | AACI_RX7 |
                       AACI_RX10 | AACI_REN;
  CW.DatRxCntlReg[2] = AACI_FEN | RxSize[2] | AACI_RX6 | AACI_RX9 |
                       AACI_RX12 | AACI_REN;
  CW.DatRxCntlReg[3] = AACI_FEN | RxSize[3] | AACI_RX5 | AACI_RX8 |
                       AACI_RX11 | AACI_REN;
  CW.DatRxCntlReg[4] = AACI_FEN | RxSize[4] | AACI_RX1 | AACI_RX2 |
                       AACI_RX4 | AACI_REN;
  CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;

  /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from the AACISLnTX 
     (n = 1, 2, 12) registers (data could be from either the Channels
     or from the AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxRegRdSltEn[1] = 0x0;
  CW.TxRegRdSltEn[2] = 0x0;
  CW.TxRegRdSltEn[3] = 0x0;
  CW.TxRegRdSltEn[4] = 0x0;
  CW.TxRegRdSltEn[5] = 0x0;
  CW.TxRegRdSltEn[6] = TX12;

  /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the 
     AACISLnTX (n = 1, 2, 12) registers for each frame */
  CW.TxRegWtSltEn[1] = 0x0;
  CW.TxRegWtSltEn[2] = TX12;
  CW.TxRegWtSltEn[3] = 0x0;
  CW.TxRegWtSltEn[4] = 0x0;
  CW.TxRegWtSltEn[5] = 0x0;
  CW.TxRegWtSltEn[6] = 0x0;

  /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the channels
     for each frame */
  CW.TxFIFOWtSltEn[1]  = 0x0;
  CW.TxFIFOWtSltEn[2]  = TX3 | TX4 | TX6 | TX7 | TX8 | TX10 | TX11 |
                         TX12;
  CW.TxFIFOWtSltEn[3]  = TX3 | TX7;
  CW.TxFIFOWtSltEn[4]  = TX4 | TX11;
  CW.TxFIFOWtSltEn[5]  = TX6 | TX12;
  CW.TxFIFOWtSltEn[6]  = TX8 | TX10;

  /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from Channel Tx FIFOs of
     the AACI (data could be from either the Channels or from the
     AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxFIFORdSltEn[1]  = 0x0;
  CW.TxFIFORdSltEn[2]  = TX3 | TX7;
  CW.TxFIFORdSltEn[3]  = TX4 | TX11;
  CW.TxFIFORdSltEn[4]  = TX3 | TX6 | TX7 | TX12;
  CW.TxFIFORdSltEn[5]  = TX4 | TX6 | TX8 | TX10 | TX11 | TX12;
  CW.TxFIFORdSltEn[6]  = TX8 | TX10;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  for (i = 1; i < 7; i++)
  {
    CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
  }

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = FV | S2 | S3 | S4 | S5 | S6 | S7 | S8 | S9 |
                       S10 | S11 | S12;
  CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;
  CW.AACITB_SLOT0[3] = FV | S2 | S3 | S4 | S5 | S6 | S7 | S8 | S9 |
                       S10 | S11 | S12;
  CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;
  CW.AACITB_SLOT0[5] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;
  CW.AACITB_SLOT0[6] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;

  /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
     about which of the SRC bits need to be set by the trickbox
     for each frame  */
  CW.AACITB_SLOT1[1] = SRC4 | SRC6 | SRC8 | SRC10 | SRC11 | SRC12;
  CW.AACITB_SLOT1[2] = SRC3 | SRC7 | SRC6 | SRC8 | SRC10 | SRC12;
  CW.AACITB_SLOT1[3] = SRC4 | SRC8 | SRC10 | SRC11;
  CW.AACITB_SLOT1[4] = SRC3 | SRC7;
  CW.AACITB_SLOT1[5] = 0x0;
  CW.AACITB_SLOT1[6] = 0x0;

  /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
     version of the SRC bits transmitted by the trickbox. This is
     used for computational purposes. */
  for (i = 1; i < 8; i++)
    CW.RemapedSRC[i] = RemapSR(i);

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_SlPCLK_Test(6);

  if (CmpctMod == 0x0)
  {
    C("Channel1Tx enabled and has slots 1, 2 and 12");
    C("Channel2Tx enabled and has slots 4, 6 and 8");
    C("Channel3Tx enabled and has slot 9");
    C("Channel4Tx enabled and has slot 12");
    C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");
    C("Channel3Rx enabled and has slots 1, 5, 7 and 12");
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
    C("SRC bits set for multiple slots");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | AACI_TX1 | AACI_TX2 |
                         AACI_TX12 | AACI_TEN;
    CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | AACI_TX4 | AACI_TX6 |
                         AACI_TX8 | AACI_TEN;
    CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | AACI_TX9 | AACI_TEN;
    CW.DatTxCntlReg[4] = AACI_FEN | TxSize[4] | AACI_TX11 | AACI_TEN;
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;
  
    /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[3] = AACI_FEN | RxSize[3] | AACI_RX1 | AACI_RX5 |
                         AACI_RX7 | AACI_RX12 | AACI_REN;
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1] = 0x0;
    CW.TxRegRdSltEn[2] = TX1 | TX2;
    CW.TxRegRdSltEn[3] = 0x0;
    CW.TxRegRdSltEn[4] = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[5] = 0x0;
    CW.TxRegRdSltEn[6] = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[7] = 0x0;
  
    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1] = 0x0;
    CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[3] = 0x0;
    CW.TxRegWtSltEn[4] = TX1 | TX2;
    CW.TxRegWtSltEn[5] = 0x0;
    CW.TxRegWtSltEn[6] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[7] = 0x0;
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX4 | TX6 | TX8 | TX9 | TX11;
    CW.TxFIFOWtSltEn[3]  = TX11;
    CW.TxFIFOWtSltEn[4]  = TX4 | TX6 | TX8 | TX11;
    CW.TxFIFOWtSltEn[5]  = TX9 | TX11;
    CW.TxFIFOWtSltEn[6]  = TX9;
    CW.TxFIFOWtSltEn[7]  = TX9;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX11;
    CW.TxFIFORdSltEn[3]  = TX4 | TX6 | TX8 | TX11;
    CW.TxFIFORdSltEn[4]  = TX9 | TX11;
    CW.TxFIFORdSltEn[5]  = TX4 | TX6 | TX8 | TX9 | TX11;
    CW.TxFIFORdSltEn[6]  = TX9;
    CW.TxFIFORdSltEn[7]  = TX9;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 8; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S2 | S5 | S7 | S11 | S12;
    CW.AACITB_SLOT0[2] = FV | S1 | S2 | S5 | S7 | S11 | S12;
    CW.AACITB_SLOT0[3] = FV | S2 | S5 | S7 | S11 | S12;
    CW.AACITB_SLOT0[4] = FV | S2 | S5 | S7 | S11 | S12;
    CW.AACITB_SLOT0[5] = FV | S2 | S5 | S7 | S11 | S12;
    CW.AACITB_SLOT0[6] = FV | S2 | S5 | S7 | S11 | S12;
    CW.AACITB_SLOT0[7] = FV | S2 | S5 | S7 | S11 | S12;
  
    /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
       about which of the SRC bits need to be set by the trickbox
       for each frame  */
    CW.AACITB_SLOT1[1] = SRC4 | SRC6 | SRC8 | SRC9 | SRC12;
    CW.AACITB_SLOT1[2] = SRC9 | SRC12;
    CW.AACITB_SLOT1[3] = SRC4 | SRC6 | SRC8;
    CW.AACITB_SLOT1[4] = 0x0;
    CW.AACITB_SLOT1[5] = 0x0;
    CW.AACITB_SLOT1[6] = 0x0;
    CW.AACITB_SLOT1[7] = 0x0;
  
    /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
       version of the SRC bits transmitted by the trickbox. This is
       used for computational purposes. */
    for (i = 1; i < 8; i++)
      CW.RemapedSRC[i] = RemapSR(i);
  
    /* Perform a 7-frame data transfer with the above settings */
    TxRx_SlPCLK_Test(7);

/**********************************************************************/
/**************** Tx & Rx - CH & SLReg - Char mode - SRC **************/
/**********************************************************************/
  /*
    The AACI is programmed for both transmission and reception in the
    Character mode. AACISLnTX (n = 1, 2 and 12) are enabled for
    transmission. AACISLnRX (n = 1, 2 and 12) are enabled for
    reception. SRC bits are set in the incoming frames. Five data
    tests are done under this category. The following parameters are
    varied for each test.
      o The number of slots enabled per transmitted frame.
      o The number of slots enabled per received frame.
      o TSIZE and RSIZE
      o Information about which of the AACISLnTX (n = 1, 2, 12)
        registers are to be loaded with new data for each frame
      o Slot0 to be transmitted by the trickbox for each frame
      o SRC bit-pattern to be transmitted by the trickbox for each frame
      o Whether data for Slots 1, 2 and 12 are present in Channels AND
        Slot registers (as against data being present for these slots
        ONLY in Slot registers or ONLY in channels)

    The tests are repeated by programming the channels to transfer
    data for different combinations of slots.

  */

    C("Tx & Rx - CH & SLReg - Char mode - SRC");
    C("Channel3Tx enabled and has slot 3");
    C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");
    C("Channel3Rx enabled and has slots 1, 2, 4 and 12");
    C("SRC bits set for multiple slots");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[3] = TxSize[3] | AACI_TX3 | AACI_TEN;
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;
  
    /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[3] = RxSize[3] | AACI_RX1 | AACI_RX2 | AACI_RX4 |
                         AACI_RX12 | AACI_REN;
  
    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1] = 0x0;
    CW.TxRegRdSltEn[2] = TX1 | TX2;
    CW.TxRegRdSltEn[3] = TX12;
    CW.TxRegRdSltEn[4] = 0x0;
  
    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1] = 0x0;
    CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[3] = 0x0;
    CW.TxRegWtSltEn[4] = 0x0;
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX3;
    CW.TxFIFOWtSltEn[3]  = 0x0;
    CW.TxFIFOWtSltEn[4]  = 0x0;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = 0x0;
    CW.TxFIFORdSltEn[3]  = TX3;
    CW.TxFIFORdSltEn[4]  = 0x0;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 5; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S10 | S11;
    CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S10 | S11;
    CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S10 | S11;
    CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S10 | S11;
  
    /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
       about which of the SRC bits need to be set by the trickbox
       for each frame  */
    CW.AACITB_SLOT1[1] = SRC3 | SRC4 | SRC5 | SRC6 | SRC7 | SRC8 |
                         SRC9 | SRC10 | SRC11 | SRC12;
    CW.AACITB_SLOT1[2] = 0x0;
    CW.AACITB_SLOT1[3] = SRC3 | SRC4 | SRC5 | SRC6 | SRC7 | SRC8 |
                         SRC9 | SRC10 | SRC11 | SRC12;
    CW.AACITB_SLOT1[4] = 0x0;
  
    /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
       version of the SRC bits transmitted by the trickbox. This is
       used for computational purposes. */
    for (i = 1; i < 5; i++)
      CW.RemapedSRC[i] = RemapSR(i);
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_SlPCLK_Test(4);
  
    C("Channel3Tx enabled and has slot 12");
    C("Channel3Rx enabled and has slots 1, 2, 4 and 12");
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
    C("SRC bits set for multiple slots");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[3] = TxSize[3] | AACI_TX11 | AACI_TEN;
  
    /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[3] = RxSize[3] | AACI_RX1 | AACI_RX2 | AACI_RX4 |
                         AACI_RX12 | AACI_REN;
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX11;
    CW.TxFIFOWtSltEn[3]  = TX11;
    CW.TxFIFOWtSltEn[4]  = 0x0;
    CW.TxFIFOWtSltEn[5]  = 0x0;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX11;
    CW.TxFIFORdSltEn[3]  = 0x0;
    CW.TxFIFORdSltEn[4]  = TX11;
    CW.TxFIFORdSltEn[5]  = 0x0;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    CW.AACI_SLOT0[1] = 0x0;
    CW.AACI_SLOT0[2] = FV | S11;
    CW.AACI_SLOT0[3] = 0x0;
    CW.AACI_SLOT0[4] = FV | S11;
    CW.AACI_SLOT0[5] = 0x0;
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
    CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
    CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
    CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S11 | S12;
    CW.AACITB_SLOT0[5] = FV;
  
    /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
       about which of the SRC bits need to be set by the trickbox
       for each frame  */
    CW.AACITB_SLOT1[1] = 0x0;
    CW.AACITB_SLOT1[2] = SRC3 | SRC4 | SRC11 | SRC12;
    CW.AACITB_SLOT1[3] = 0x0;
    CW.AACITB_SLOT1[4] = SRC3 | SRC4 | SRC11 | SRC12;
    CW.AACITB_SLOT1[5] = 0x0;
  
    /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
       version of the SRC bits transmitted by the trickbox. This is
       used for computational purposes. */
    for (i = 1; i < 6; i++)
      CW.RemapedSRC[i] = RemapSR(i);
  
    /* Perform a 5-frame data transfer with the above settings */
    TxRx_SlPCLK_Test(5);
  
    C("Channel1Tx enabled and has slot 5");
    C("Channel2Tx enabled and has slot 12");
    C("AACISL1TX, AACISL12TX are enabled ");
    C("Channel1Rx enabled and has slot 12");
    C("Channel2Rx enabled and has slot 3");
    C("AACISL2RX, AACISL12RX are enabled");
    C("SRC bits set for multiple slots");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[1] = TxSize[1] | AACI_TX5 | AACI_TEN;
    CW.DatTxCntlReg[2] = TxSize[2] | AACI_TX12 | AACI_TEN;
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX12;
  
    /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[1] = RxSize[1] | AACI_RX12 | AACI_REN;
    CW.DatRxCntlReg[2] = RxSize[2] | AACI_RX3 | AACI_REN;
    CW.DatRxCntlReg[5] = AACI_RX2 | AACI_RX12;
  
    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1]  = 0x0;
    CW.TxRegWtSltEn[2]  = TX1 | TX12;
    CW.TxRegWtSltEn[3]  = TX1;
    CW.TxRegWtSltEn[4]  = 0x0;
    CW.TxRegWtSltEn[5]  = 0x0;
  
    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1]  = 0x0;
    CW.TxRegRdSltEn[2]  = TX1;
    CW.TxRegRdSltEn[3]  = TX1;
    CW.TxRegRdSltEn[4]  = TX12;
    CW.TxRegRdSltEn[5]  = 0x0;
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX5 | TX12;
    CW.TxFIFOWtSltEn[3]  = 0x0;
    CW.TxFIFOWtSltEn[4]  = TX5;
    CW.TxFIFOWtSltEn[5]  = 0x0;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX12;
    CW.TxFIFORdSltEn[3]  = TX5;
    CW.TxFIFORdSltEn[4]  = 0x0;
    CW.TxFIFORdSltEn[5]  = TX5;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 6; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S11 | S12;
    CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S11 | S12;
    CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S11 | S12;
    CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S11 | S12;
    CW.AACITB_SLOT0[5] = FV;
  
    /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
       about which of the SRC bits need to be set by the trickbox
       for each frame  */
    CW.AACITB_SLOT1[1] = SRC5 | SRC6 | SRC7 | SRC8 | SRC9 | SRC10;
    CW.AACITB_SLOT1[2] = SRC3 | SRC4 | SRC12;
    CW.AACITB_SLOT1[3] = SRC5 | SRC6 | SRC7 | SRC8 | SRC9 | SRC10;
    CW.AACITB_SLOT1[4] = SRC3 | SRC4 | SRC12;
    CW.AACITB_SLOT1[5] = 0x0;
  
    /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
       version of the SRC bits transmitted by the trickbox. This is
       used for computational purposes. */
    for (i = 1; i < 6; i++)
      CW.RemapedSRC[i] = RemapSR(i);
  
    /* Perform a 5-frame data transfer with the above settings */
    TxRx_SlPCLK_Test(5);
  
    C("Channel1Tx enabled and has slot 6");
    C("Channel2Tx enabled and has slot 4");
    C("Channel3Tx enabled and has slot 3");
    C("Channel4Tx enabled and has slot 1");
    C("AACISL1TX, AACISL2TX, AACISL12TX are enabled ");
    C("Channel1Rx enabled and has slot 1");
    C("Channel2Rx enabled and has slot 3");
    C("Channel3Rx enabled and has slot 9");
    C("Channel4Rx enabled and has slot 12");
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
    C("SRC bits set for multiple slots");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[1] = TxSize[1] | AACI_TX6 | AACI_TEN;
    CW.DatTxCntlReg[2] = TxSize[2] | AACI_TX4 | AACI_TEN;
    CW.DatTxCntlReg[3] = TxSize[3] | AACI_TX3 | AACI_TEN;
    CW.DatTxCntlReg[4] = TxSize[4] | AACI_TX1 | AACI_TEN;
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;
  
    /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[1] = RxSize[1] | AACI_RX1 | AACI_REN;
    CW.DatRxCntlReg[2] = RxSize[2] | AACI_RX3 | AACI_REN;
    CW.DatRxCntlReg[3] = RxSize[3] | AACI_RX9 | AACI_REN;
    CW.DatRxCntlReg[4] = RxSize[4] | AACI_RX12 | AACI_REN;
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1]  = 0x0;
    CW.TxRegWtSltEn[2]  = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[3]  = 0x0;
    CW.TxRegWtSltEn[4]  = 0x0;
    CW.TxRegWtSltEn[5]  = 0x0;
    CW.TxRegWtSltEn[6]  = 0x0;
  
    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1]  = 0x0;
    CW.TxRegRdSltEn[2]  = TX2 | TX12;
    CW.TxRegRdSltEn[3]  = 0x0;
    CW.TxRegRdSltEn[4]  = TX1;
    CW.TxRegRdSltEn[5]  = 0x0;
    CW.TxRegRdSltEn[6]  = 0x0;
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX1 | TX3 | TX4 | TX6;
    CW.TxFIFOWtSltEn[3]  = TX1 | TX3;
    CW.TxFIFOWtSltEn[4]  = TX6;
    CW.TxFIFOWtSltEn[5]  = TX4;
    CW.TxFIFOWtSltEn[6]  = 0x0;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX1 | TX3;
    CW.TxFIFORdSltEn[3]  = TX1 | TX6;
    CW.TxFIFORdSltEn[4]  = TX4;
    CW.TxFIFORdSltEn[5]  = TX3 | TX6;
    CW.TxFIFORdSltEn[6]  = TX4;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 7; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S11 | S12;
    CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S11 | S12;
    CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S11 | S12;
    CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S11 | S12;
    CW.AACITB_SLOT0[5] = FV;
    CW.AACITB_SLOT0[6] = FV;
  
    /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
       about which of the SRC bits need to be set by the trickbox
       for each frame  */
    CW.AACITB_SLOT1[1] = SRC4 | SRC6;
    CW.AACITB_SLOT1[2] = SRC3 | SRC4;
    CW.AACITB_SLOT1[3] = SRC3 | SRC6;
    CW.AACITB_SLOT1[4] = SRC4;
    CW.AACITB_SLOT1[5] = 0x0;
    CW.AACITB_SLOT1[6] = 0x0;
  
    /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
       version of the SRC bits transmitted by the trickbox. This is
       used for computational purposes. */
    for (i = 1; i < 7; i++)
      CW.RemapedSRC[i] = RemapSR(i);
  
    /* Perform a 6-frame data transfer with the above settings */
    TxRx_SlPCLK_Test(6);
  
    C("Channel1Tx enabled and has slot 12");
    C("Channel2Tx enabled and has slot 8");
    C("Channel3Tx enabled and has slot 9");
    C("Channel4Tx enabled and has slot 11");
    C("AACISL1TX, AACISL2TX, AACISL12TX are enabled ");
    C("Channel3Rx enabled and has slot 2");
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
    C("SRC bits set for multiple slots");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[1] = TxSize[1] | AACI_TX12 | AACI_TEN;
    CW.DatTxCntlReg[2] = TxSize[2] | AACI_TX8 | AACI_TEN;
    CW.DatTxCntlReg[3] = TxSize[3] | AACI_TX9 | AACI_TEN;
    CW.DatTxCntlReg[4] = TxSize[4] | AACI_TX11 | AACI_TEN;
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;
  
    /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[3] = RxSize[3] | AACI_RX2 | AACI_REN;
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1]  = 0x0;
    CW.TxRegWtSltEn[2]  = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[3]  = TX1 | TX2;
    CW.TxRegWtSltEn[4]  = TX1 | TX2;
    CW.TxRegWtSltEn[5]  = TX1 | TX2;
  
    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1]  = 0x0;
    CW.TxRegRdSltEn[2]  = TX1 | TX2;
    CW.TxRegRdSltEn[3]  = TX1 | TX2;
    CW.TxRegRdSltEn[4]  = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[5]  = TX1 | TX2;
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX8 | TX9 | TX11;
    CW.TxFIFOWtSltEn[3]  = TX11;
    CW.TxFIFOWtSltEn[4]  = TX8;
    CW.TxFIFOWtSltEn[5]  = TX9;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX11;
    CW.TxFIFORdSltEn[3]  = TX8 | TX11;
    CW.TxFIFORdSltEn[4]  = TX9;
    CW.TxFIFORdSltEn[5]  = TX8 | TX9;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 6; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S2 | S3 | S4 | S5 | S6 | S7 | S8 | S9 |
                         S11 | S12;
    CW.AACITB_SLOT0[2] = FV | S2 | S3 | S4 | S5 | S6 | S7 | S8 | S9 |
                         S11 | S12;
    CW.AACITB_SLOT0[3] = FV | S2 | S3 | S4 | S5 | S6 | S7 | S8 | S9 |
                         S11 | S12;
    CW.AACITB_SLOT0[4] = FV | S2 | S3 | S4 | S5 | S6 | S7 | S8 | S9 |
                         S11 | S12;
    CW.AACITB_SLOT0[5] = FV;
  
    /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
       about which of the SRC bits need to be set by the trickbox
       for each frame  */
    CW.AACITB_SLOT1[1] = SRC8 | SRC9 | SRC12;
    CW.AACITB_SLOT1[2] = SRC9 | SRC12;
    CW.AACITB_SLOT1[3] = SRC8;
    CW.AACITB_SLOT1[4] = 0x0;
    CW.AACITB_SLOT1[5] = 0x0;
  
    /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
       version of the SRC bits transmitted by the trickbox. This is
       used for computational purposes. */
    for (i = 1; i < 6; i++)
      CW.RemapedSRC[i] = RemapSR(i);
  
    /* Perform a 5-frame data transfer with the above settings */
    TxRx_SlPCLK_Test(5);
  }

/**********************************************************************/
/************************* Loop back test *****************************/
/**********************************************************************/
  /*
    The AACI is programmed in the Loopback mode. The Channels are
    enabled in the FIFO mode. AACISLnTX (n = 1, 2 and 12) registers are
    enabled for transmission and AACISLnRX (n = 1, 2 and 12) registers
    are enabled for reception. No SRC bits are set in the incoming
    frames. Four data tests are done under this category. The following
    parameters are varied for each test.
      o The number of slots enabled for transmission per channel
      o The number of slots enabled for reception per channel
      o The number of slots enabled per transmitted frame.
      o The number of slots enabled per received frame.
      o TSIZE and RSIZE

    The tests are repeated by programming the channels to transfer
    data for different combinations of slots.

    The test cases having an even number of slots enabled per channel
    are again executed with the CM bit set in the AACITXCRn (n = 1 to 4)
    and AACIRXCRn (n = 1 to 4) register.

  */

  C("Start of Loop Back test");
  C("Channel1Tx enabled and has slots 9 and 10");
  C("Channel2Tx enabled and has slots 3, 7 and 11");
  C("Channel3Tx enabled and has slot 12");
  C("Channel4Tx enabled and has slots 1 and 2");
  C("Channel1Rx enabled and has slots 3 and 11");
  C("Channel2Rx enabled and has slots 1 and 2");
  C("Channel3Rx enabled and has slots 6 and 8");
  C("Channel4Rx enabled and has slots 4 and 9");
  C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TX9 |
                       AACI_TX10 | AACI_TEN;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[1] | AACI_TX3 | AACI_TX7 |
                       AACI_TX11 | AACI_TEN;
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[1] | AACI_TX12 | AACI_TEN;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TX1 |
                       AACI_TX2 | AACI_TEN;

  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[1] = AACI_FEN | RxSize[1] | AACI_RX3 | AACI_RX11 |
                       AACI_REN;
  CW.DatRxCntlReg[2] = AACI_FEN | RxSize[1] | CmpctMod | AACI_RX1 |
                       AACI_RX2 | AACI_REN;
  CW.DatRxCntlReg[3] = AACI_FEN | RxSize[1] | AACI_RX6 | AACI_RX8 |
                       AACI_REN;
  CW.DatRxCntlReg[4] = AACI_FEN | RxSize[1] | AACI_RX4 | AACI_RX9 |
                       AACI_REN;
  CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S1 | S2 | S3 | S7 | S9 | S10 | S11 | S12;
  CW.AACI_SLOT0[3] = FV | S1 | S2 | S3 | S7 | S9 | S10 | S11 | S12;
  CW.AACI_SLOT0[4] = FV | S1 | S2 | S3 | S7 | S9 | S10 | S11 | S12;

  /* Perform a 4-frame data transfer with the above settings */
  LoopBack_Test(4);

  C("Channel1Tx enabled and has slots 8 and 10");
  C("Channel2Tx enabled and has slots 4 and 11");
  C("Channel3Tx enabled and has slots 3 and 7");
  C("Channel4Tx enabled and has slots 6 and 12");
  C("Channel1Rx enabled and has slots 6, 9 and 12");
  C("Channel2Rx enabled and has slots 3, 7 and 10");
  C("Channel3Rx enabled and has slots 1, 2 and 4");
  C("Channel4Rx enabled and has slots 5 and 11");
  C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();
 
  /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACITXCRn (n = 1 to 4)
     register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TX8 |
                       AACI_TX10 | AACI_TEN;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TX4 |
                       AACI_TX11 | AACI_TEN;
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TX3 |
                       AACI_TX7 | AACI_TEN;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TX6 |
                       AACI_TX12 | AACI_TEN;
 
  /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[1] = AACI_FEN | RxSize[1] | AACI_RX6 | AACI_RX9 |
                       AACI_RX12 | AACI_REN;
  CW.DatRxCntlReg[2] = AACI_FEN | RxSize[1] | AACI_RX3 | AACI_RX7 |
                       AACI_RX10 | AACI_REN;
  CW.DatRxCntlReg[3] = AACI_FEN | RxSize[1] | AACI_RX1 | AACI_RX2 |
                       AACI_RX4 | AACI_REN;
  CW.DatRxCntlReg[4] = AACI_FEN | RxSize[1] | AACI_RX5 | AACI_RX11 |
                       AACI_REN;
  CW.DatRxCntlReg[5] = AACI_RX2 | AACI_RX12;
 
  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S3 | S4 | S6 | S7 | S8 | S10 | S11 | S12;
  CW.AACI_SLOT0[3] = FV | S3 | S4 | S6 | S7 | S8 | S10 | S11 | S12;
  CW.AACI_SLOT0[4] = FV | S3 | S4 | S6 | S7 | S8 | S10 | S11 | S12;
 
  /* Perform a 4-frame data transfer with the above settings */
  LoopBack_Test(4);

  if (CmpctMod == 0x0)
  {
    C("Channel1Tx enabled and has slot 9");
    C("Channel2Tx enabled and has slots 4, 6 and 8");
    C("Channel3Tx enabled and has slot 11");
    C("Channel4Tx enabled and has slots 1, 2 and 12");
    C("Channel2Rx enabled and has slots 1, 5, 7 and 12");
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | AACI_TX9 | AACI_TEN;
    CW.DatTxCntlReg[2] = AACI_FEN | TxSize[1] | AACI_TX4 | AACI_TX6 |
                         AACI_TX8 | AACI_TEN;
    CW.DatTxCntlReg[3] = AACI_FEN | TxSize[1] | AACI_TX11 | AACI_TEN;
    CW.DatTxCntlReg[4] = AACI_FEN | TxSize[1] | AACI_TX1 | AACI_TX2 |
                         AACI_TX12 | AACI_TEN;
  
    /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[2] = AACI_FEN | RxSize[1] | AACI_RX1 | AACI_RX5 |
                         AACI_RX7 | AACI_RX12 | AACI_REN;
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    CW.AACI_SLOT0[1] = 0x0;
    CW.AACI_SLOT0[2] = FV | S1 | S2 | S4 | S6 | S8 | S9 | S11 | S12;
    CW.AACI_SLOT0[3] = FV | S1 | S2 | S4 | S6 | S8 | S9 | S11 | S12;
    CW.AACI_SLOT0[4] = FV | S1 | S2 | S4 | S6 | S8 | S9 | S11 | S12;
    CW.AACI_SLOT0[5] = FV | S1 | S2 | S4 | S6 | S8 | S9 | S11 | S12;
    CW.AACI_SLOT0[6] = FV | S1 | S2 | S4 | S6 | S8 | S9 | S11 | S12;
  
    /* Perform a 6-frame data transfer with the above settings */
    LoopBack_Test(6);
  
    C("Channel1Tx enabled and has slot 9");
    C("Channel2Tx enabled and has slots 4, 6 and 8");
    C("Channel3Tx enabled and has slot 11");
    C("Channel4Tx enabled and has slots 1, 2 and 12");
    C("Channel2Rx enabled and has slots 1, 5, 7 and 12");
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | AACI_TX9 | AACI_TEN;
    CW.DatTxCntlReg[2] = AACI_FEN | TxSize[1] | AACI_TX4 | AACI_TX6 |
                         AACI_TX8 | AACI_TEN;
    CW.DatTxCntlReg[3] = AACI_FEN | TxSize[1] | AACI_TX11 | AACI_TEN;
    CW.DatTxCntlReg[4] = AACI_FEN | TxSize[1] | AACI_TX1 | AACI_TX2 |
                         AACI_TX12 | AACI_TEN;
  
    /* Assign CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[2] = AACI_FEN | RxSize[1] | AACI_RX1 | AACI_RX5 |
                         AACI_RX7 | AACI_RX12 | AACI_REN;
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX1 | TX2 | TX4 | TX6 | TX8 | TX11 | TX12;
    CW.TxFIFOWtSltEn[3]  = TX1 | TX2 | TX4 | TX6 | TX8 | TX12;
    CW.TxFIFOWtSltEn[4]  = TX1 | TX2 | TX11 | TX12;
    CW.TxFIFOWtSltEn[5]  = TX1 | TX2 | TX12;
    CW.TxFIFOWtSltEn[6]  = TX1 | TX2 | TX4 | TX6 | TX8 | TX9 | TX11 |
                           TX12;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX1 | TX2 | TX4 | TX6 | TX8 | TX11 | TX12;
    CW.TxFIFORdSltEn[3]  = TX1 | TX2 | TX4 | TX6 | TX8 | TX12;
    CW.TxFIFORdSltEn[4]  = TX1 | TX2 | TX11 | TX12;
    CW.TxFIFORdSltEn[5]  = TX1 | TX2 | TX12;
    CW.TxFIFORdSltEn[6]  = TX1 | TX2 | TX4 | TX6 | TX8 | TX9 | TX11 |
                           TX12;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    CW.AACI_SLOT0[1]  = 0x0;
    CW.AACI_SLOT0[2]  = S1 | S2 | S4 | S6 | S8 | S11 | S12;
    CW.AACI_SLOT0[3]  = S1 | S2 | S4 | S6 | S8 | S12;
    CW.AACI_SLOT0[4]  = S1 | S2 | S11 | S12;
    CW.AACI_SLOT0[5]  = S1 | S2 | S12;
    CW.AACI_SLOT0[6]  = S1 | S2 | S4 | S6 | S8 | S9 | S11 | S12;
  
    /* Perform a 6-frame data transfer with the above settings */
    LoopBack_Test(6);
  }
}

/*********************** End of TxRx_SlPCLK_Call.c ********************/
