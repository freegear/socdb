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
-- File Name              : Tx_Call.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose : 
--           This function verifies the transmit functionality of the
--           AACI.It is called only when PCLK is faster than or has the
--           same frequency as AACIBITCLK.
--
-- --=================================================================*/

/**********************************************************************/
/*** For more information on the AACI, please refer to PL041 AMBA   ***/
/*** AACI Block Specification                                       ***/
/**********************************************************************/

/**********************************************************************/
/*************************** Tx_Call **********************************/
/**********************************************************************/
void Tx_Call(int32 CmpctMod)
{
  /*
    Summary: Tx_Call
    ================
    This function is called only when PCLK is faster than or has the 
    same frequency as AACIBITCLK.

    This function calls the TxRx_FsPCLK_Test routine which programs the
    Aaci according to parameters passed to it by the calling function.
    These parameters are indirectly passed by updating the CW 
    (ControlWords) structure in this function (Tx_Call).
    These parameters determine the following :
      - The expected Slot0 from the AACI
      - Slot0 to be transmitted by the Trickbox
      - Register fields for the AACITXCRn (n = 1 to 4) registers
      - SRC bit values to be transmitted by the trickbox
      - Information regarding which of the Slot registers need to
        be enabled for data transmission for each frame
      - Information regarding the number of words of data to be written
        into the Tx FIFOs of the AACI for each frame
      - Information regarding to which of the AACISLnTX (n = 1 to 4)
        registers are to be loaded with new data for each frame

    o The transmission tests are split into ten major categories with 
      each category containing several sub-tests. These categories are 
      derived from the following four fields.
      
      <Data Direction> + <Data Src/Dest> + <FIFO mode> + <SRC mode>

      Data Direction -> Tx Only
      Data Src/Dest  -> CH/SLReg/(Both CH and SLReg) 
      FIFO mode      -> FIFO / Char
      SRC            -> SRC / No SRC

      1.  Tx Only - CH - FIFO mode - No SRC
      2.  Tx Only - CH - FIFO mode - SRC
      3.  Tx Only - CH - Char mode - No SRC
      4.  Tx Only - CH - Char mode - SRC
      5.  Tx Only - SLReg - No SRC
      6.  Tx Only - SLReg - SRC
      7.  Tx Only - CH & SLReg - FIFO mode - No SRC
      8.  Tx Only - CH & SLReg - FIFO mode - SRC
      9.  Tx Only - CH & SLReg - Char mode - No SRC
      10. Tx Only - CH & SLReg - Char mode - SRC

    o This function also verifies data transmission by the AACI for a 
      range of TSIZE values in Compact mode and non-Compact mode.
      Only sub-tests involving even number of slots per channel are run
      in Compact mode. 

  */

  int i;

/**********************************************************************/
/***************** Tx Only - CH - FIFO mode - No SRC ******************/
/**********************************************************************/
  /*
    The AACI is programmed for transmission-only in the FIFO mode.
    No SRC bits are set in the incoming frame. Ten data tests are 
    done under this category. The following parameters are varied for
    each test.
      o The number of slots enabled for transmission per channel
      o The number of slots enabled per transmitted frame.
      o TSIZE

    The tests are repeated by programming the channels to transmit 
    data for different combinations of slots.

    The test cases having an even number of slots enabled per channel 
    are again executed with the CM bit set in the AACITXCRn (n = 1 to 4)
    register.

  */

  C("Tx Only - CH - FIFO mode - No SRC");
  C("Channel1Tx enabled and no slots enabled");
  C("Channel2Tx disabled and has slots 1, 2, 3 and 4");
  C("Channel3Tx disabled and has slots 5, 6, 7 and 8");
  C("Channel4Tx disabled and has slots 9, 10, 11 and 12");

  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with the value
     to be programmed into the AACITXCRn (n = 1 to 4) register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | AACI_TEN;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TX1 |
                       AACI_TX2 | AACI_TX3 | AACI_TX4;
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | CmpctMod | AACI_TX5 |
                       AACI_TX6 | AACI_TX7 | AACI_TX8;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[4] | CmpctMod | AACI_TX9 |
                       AACI_TX10 | AACI_TX11 | AACI_TX12;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
  for (i = 1; i < 12; i++)
   CW.AACITB_SLOT0[i] = Calculate_TrSlot0();

  /* Perform a 3-frame data transfer with the above settings */
  TxRx_FsPCLK_Test(3);

  /* Performing Transmission tests with the AACI programmed to 
     transmit combinations of invalid frames and valid frames */
  C("Channel1Tx enabled and has slots 1, 2, 3 and 4");

  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with the value
     to be programmed into the AACITXCRn (n = 1 to 4) register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TEN |
                       AACI_TX1 | AACI_TX2 | AACI_TX3 | AACI_TX4;

  /* Assign CW.FrmInVldCh[n] (n = channel number) with information about
     whether sufficient data is to be written into that channel. */
  CW.FrmInVldCh[1] = 1;

  /* Assign CW.NoInVldFrm with the number of invalid frames
     to be sent by the AACI */
  CW.NoInVldFrm    = 1;

  /* Assign CW.StartInVldFrm with a value indicating the frame
     number (say, 3rd or 4th frame) that is to be transmitted as 
     invalid frame by the AACI */
  CW.StartInVldFrm = 4;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
  for (i = 1; i < 12; i++)
    CW.AACITB_SLOT0[i] = Calculate_TrSlot0();

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */

  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S1 | S2 | S3 | S4;
  CW.AACI_SLOT0[3] = FV | S1 | S2 | S3 | S4;
  CW.AACI_SLOT0[4] = 0x0;
  CW.AACI_SLOT0[5] = FV | S1 | S2 | S3 | S4;
  CW.AACI_SLOT0[6] = FV | S1 | S2 | S3 | S4;

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_FsPCLK_Test(6);

  /* Performing Transmission tests with the AACI programmed to 
     transmit combinations of invalid frames and valid frames */
  C("Channel2Tx enabled and has slots 4, 5, 6 and 7");

  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with the value
     to be programmed into the AACITXCRn (n = 1 to 4) register */
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TEN |
                       AACI_TX4 | AACI_TX5 | AACI_TX6 | AACI_TX7;

  /* Assign CW.FrmInVldCh[n] (n = channel number) with information about
     whether sufficient data is to be written into that channel. */
  CW.FrmInVldCh[2] = 1;

  /* Assign CW.NoInVldFrm with the number of invalid frames
     to be sent by the AACI */
  CW.NoInVldFrm    = 1;

  /* Assign CW.StartInVldFrm with the value indicating the frame
     number (say, 3rd or 4th frame) that is to be transmitted as
     invalid frame by the AACI */
  CW.StartInVldFrm = 4;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
  for (i = 1; i < 12; i++)
    CW.AACITB_SLOT0[i] = Calculate_TrSlot0();

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S4 | S5 | S6 | S7;
  CW.AACI_SLOT0[3] = FV | S4 | S5 | S6 | S7;
  CW.AACI_SLOT0[4] = 0x0;
  CW.AACI_SLOT0[5] = FV | S4 | S5 | S6 | S7;
  CW.AACI_SLOT0[6] = FV | S4 | S5 | S6 | S7;

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_FsPCLK_Test(6);

  /* Performing Transmission tests with the AACI programmed to
     transmit combinations of invalid frames and valid frames */
  C("Channel3Tx enabled and has slots 1, 7, 9 and 11");

  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with the value
     to be programmed into the AACITXCRn (n = 1 to 4) register */
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | CmpctMod | AACI_TEN |
                       AACI_TX1 | AACI_TX7 | AACI_TX9 | AACI_TX11;

  /* Assign CW.FrmInVldCh[n] (n = channel number) with information about
     whether sufficient data is to be written into that channel. */
  CW.FrmInVldCh[3] = 1;

  /* Assign CW.NoInVldFrm with the number of invalid frames
     to be sent by the AACI */
  CW.NoInVldFrm    = 1;

  /* Assign CW.StartInVldFrm with the value indicating the frame
     number (say, 3rd or 4th frame) that is to be transmitted as
     invalid frame by the AACI */
  CW.StartInVldFrm = 4;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
  for (i = 1; i < 12; i++)
    CW.AACITB_SLOT0[i] = Calculate_TrSlot0();

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */

  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S1 | S7 | S9 | S11;
  CW.AACI_SLOT0[3] = FV | S1 | S7 | S9 | S11;
  CW.AACI_SLOT0[4] = 0x0;
  CW.AACI_SLOT0[5] = FV | S1 | S7 | S9 | S11;
  CW.AACI_SLOT0[6] = FV | S1 | S7 | S9 | S11;

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_FsPCLK_Test(6);

  /* Performing Transmission tests with the AACI programmed to
     transmit combinations of invalid frames and valid frames */
  C("Channel4Tx enabled and has slots 9, 10, 11 and 12");

  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with the value
     to be programmed into the AACITXCRn (n = 1 to 4) register */
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[4] | CmpctMod | AACI_TEN |
                       AACI_TX9 | AACI_TX10 | AACI_TX11 | AACI_TX12;

  /* Assign CW.FrmInVldCh[n] (n = channel number) with information about
     whether sufficient data is to be written into that channel. */
  CW.FrmInVldCh[4] = 1;

  /* Assign CW.NoInVldFrm with the number of invalid frames
     to be sent by the AACI */
  CW.NoInVldFrm    = 1;

  /* Assign CW.StartInVldFrm with the value indicating the frame
     number (say, 3rd or 4th frame) that is to be transmitted as
     invalid frame by the AACI */
  CW.StartInVldFrm = 4;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
  for (i = 1; i < 12; i++)
    CW.AACITB_SLOT0[i] = Calculate_TrSlot0();

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S9 | S10 | S11 | S12;
  CW.AACI_SLOT0[3] = FV | S9 | S10 | S11 | S12;
  CW.AACI_SLOT0[4] = 0x0;
  CW.AACI_SLOT0[5] = FV | S9 | S10 | S11 | S12;
  CW.AACI_SLOT0[6] = FV | S9 | S10 | S11 | S12;

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_FsPCLK_Test(6);

  if (CmpctMod == 0x0)
  {
    /* Performing Transmission tests with the AACI programmed to
       transmit combinations of invalid frames and valid frames */
    C("Channel2Tx enabled and has slots 8, 9, 10, 11, 12")

    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4) 
       register */
    CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | AACI_TEN | AACI_TX8 |
                         AACI_TX9 | AACI_TX10 | AACI_TX11 | AACI_TX12;
  
    /* Assign CW.FrmInVldCh[n] (n = channel number) with information 
       about whether sufficient data is to be written into that 
       channel. */
    CW.FrmInVldCh[2] = 1;

    /* Assign CW.NoInVldFrm with the number of invalid frames
       to be sent by the AACI */
    CW.NoInVldFrm    = 1;

    /* Assign CW.StartInVldFrm with the value indicating the frame
       number (say, 3rd or 4th frame) that is to be transmitted as
       invalid frame by the AACI */
    CW.StartInVldFrm = 3;
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
    for (i = 1; i < 12; i++)
      CW.AACITB_SLOT0[i] = Calculate_TrSlot0();
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    CW.AACI_SLOT0[1] = 0x0;
    CW.AACI_SLOT0[2] = FV | S8 | S9 | S10 | S11 | S12;
    CW.AACI_SLOT0[3] = 0x0;
    CW.AACI_SLOT0[4] = FV | S8 | S9 | S10 | S11 | S12;
    CW.AACI_SLOT0[5] = FV | S8 | S9 | S10 | S11 | S12;

    /* Perform a 5-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(5);
  
    /* Performing Transmission tests with the AACI programmed to
       transmit combinations of invalid frames and valid frames */
    C("Channel3Tx enabled and has slots 1, 4, 5, 8 and 12");

    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | AACI_TEN | AACI_TX1 |
                         AACI_TX4 | AACI_TX5 | AACI_TX8 | AACI_TX12;
  
    /* Assign CW.FrmInVldCh[n] (n = channel number) with information 
       about whether sufficient data is to be written into that 
       channel. */
    CW.FrmInVldCh[3] = 1;

    /* Assign CW.NoInVldFrm with the number of invalid frames
       to be sent by the AACI */
    CW.NoInVldFrm    = 1;

    /* Assign CW.StartInVldFrm with the value indicating the frame
       number (say, 3rd or 4th frame) that is to be transmitted as
       invalid frame by the AACI */
    CW.StartInVldFrm = 3;
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox */
    for (i = 1; i < 12; i++)
      CW.AACITB_SLOT0[i] = Calculate_TrSlot0();
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    CW.AACI_SLOT0[1] = 0x0;
    CW.AACI_SLOT0[2] = FV | S1 | S4 | S5 | S8 | S12;
    CW.AACI_SLOT0[3] = 0x0;
    CW.AACI_SLOT0[4] = FV | S1 | S4 | S5 | S8 | S12;
    CW.AACI_SLOT0[5] = FV | S1 | S4 | S5 | S8 | S12;

    /* Perform a 5-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(5);
  }

  /* Performing Transmission tests with the AACI programmed to
     transmit combinations of invalid frames and valid frames */
  C("Channel1Tx enabled and has slots 1, 2, 5, 7, 9 and 11");

  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with the value
     to be programmed into the AACITXCRn (n = 1 to 4) register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TEN |
                       AACI_TX1 | AACI_TX2 | AACI_TX5 | AACI_TX7 |
                       AACI_TX9 | AACI_TX11;

  /* Assign CW.FrmInVldCh[n] (n = channel number) with information about
     whether sufficient data is to be written into that channel. */
  CW.FrmInVldCh[1] = 1;

  /* Assign CW.NoInVldFrm with the number of invalid frames
     to be sent by the AACI */
  CW.NoInVldFrm    = 1;

  /* Assign CW.StartInVldFrm with the value indicating the frame
     number (say, 3rd or 4th frame) that is to be transmitted as
     invalid frame by the AACI */
  CW.StartInVldFrm = 3;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
  for (i = 1; i < 12; i++)
    CW.AACITB_SLOT0[i] = Calculate_TrSlot0();

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  CW.AACI_SLOT0[1] = 0x0;
  CW.AACI_SLOT0[2] = FV | S1 | S2 | S5 | S7 | S9 | S11;
  CW.AACI_SLOT0[3] = 0x0;
  CW.AACI_SLOT0[4] = FV | S1 | S2 | S5 | S7 | S9 | S11;
  CW.AACI_SLOT0[5] = FV | S1 | S2 | S5 | S7 | S9 | S11;

  /* Perform a 5-frame data transfer with the above settings */
  TxRx_FsPCLK_Test(5);

  if (CmpctMod == 0x0)
  {
    /* Performing Transmission tests with the AACI programmed to
       transmit combinations of invalid frames and valid frames */
    C("Channel2Tx enabled and has slots 1, 2, 3, 4, 10, 11 and 12");

    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | AACI_TEN | AACI_TX1 |
                         AACI_TX2 | AACI_TX3 | AACI_TX4 | AACI_TX10 |
                         AACI_TX11 | AACI_TX12;
  
    /* Assign CW.FrmInVldCh[n] (n = channel number) with information 
       about whether sufficient data is to be written into that 
       channel. */
    CW.FrmInVldCh[2] = 1;

    /* Assign CW.NoInVldFrm with the number of invalid frames
       to be sent by the AACI */
    CW.NoInVldFrm    = 1;

    /* Assign CW.StartInVldFrm with the value indicating the frame
       number (say, 3rd or 4th frame) that is to be transmitted as
       invalid frame by the AACI */
    CW.StartInVldFrm = 3;
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox */
    for (i = 1; i < 12; i++)
      CW.AACITB_SLOT0[i] = Calculate_TrSlot0();
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    CW.AACI_SLOT0[1] = 0x0;
    CW.AACI_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S10 | S11 | S12;
    CW.AACI_SLOT0[3] = 0x0;
    CW.AACI_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S10 | S11 | S12;
    CW.AACI_SLOT0[5] = FV | S1 | S2 | S3 | S4 | S10 | S11 | S12;

    /* Perform a 5-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(5);
  }

  /* Performing Transmission tests with the AACI programmed to
     transmit combinations of invalid frames and valid frames */
  C("Channel4Tx enabled and has slots 1, 2, 4, 5, 7, 8, 11 and 12");

  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with the value
     to be programmed into the AACITXCRn (n = 1 to 4) register */
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[4] | CmpctMod | AACI_TEN |
                       AACI_TX1 | AACI_TX2 | AACI_TX4 | AACI_TX5 |
                       AACI_TX7 | AACI_TX8 | AACI_TX11 | AACI_TX12;

  /* Assign CW.FrmInVldCh[n] (n = channel number) with information about
     whether sufficient data is to be written into that channel. */
  CW.FrmInVldCh[4] = 1;

  /* Assign CW.NoInVldFrm with the number of invalid frames
     to be sent by the AACI */
  CW.NoInVldFrm    = 1;

  /* Assign CW.StartInVldFrm with the value indicating the frame
     number (say, 3rd or 4th frame) that is to be transmitted as
     invalid frame by the AACI */
  CW.StartInVldFrm = 3;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
  for (i = 1; i < 12; i++)
    CW.AACITB_SLOT0[i] = Calculate_TrSlot0();

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
    CW.AACI_SLOT0[1] = 0x0;
    CW.AACI_SLOT0[2] = FV | S1 | S2 | S4 | S5 | S7 | S8 | S11 | S12;
    CW.AACI_SLOT0[3] = 0x0;
    CW.AACI_SLOT0[4] = FV | S1 | S2 | S4 | S5 | S7 | S8 | S11 | S12;
    CW.AACI_SLOT0[5] = FV | S1 | S2 | S4 | S5 | S7 | S8 | S11 | S12;


  /* Perform a 5-frame data transfer with the above settings */
  TxRx_FsPCLK_Test(5);

/**********************************************************************/
/***************** Tx Only - CH - FIFO mode - SRC *********************/
/**********************************************************************/
  /*
    The AACI is programmed for transmission-only in the FIFO mode.
    SRC bits are set in the incoming frame. Two tests are done under 
    this category. The following parameters are varied for
    each test.
      o The number of slots enabled for transmission per channel
      o The number of slots enabled per transmitted frame.
      o SRC bit-pattern to be transmitted by the trickbox for each frame
      o TSIZE

    The tests are repeated by programming the channels to transmit 
    data for different combinations of slots.

    The test cases having an even number of slots enabled per channel 
    are again executed with the CM bit set in the AACITXCRn (n = 1 to 4)
    register.

  */

  C("Tx Only - CH - FIFO mode - SRC");
  C("Channel1Tx enabled and has slots 6, 8 and 12");
  C("Channel2Tx enabled and has slots 4, 5, 9 and 10");
  C("Channel3Tx enabled and has slots 3, 7 and 11");
  C("Channel4Tx enabled and has slots 1 and 2");
  C("SRC bits set for multiple slots");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with the value
     to be programmed into the AACITXCRn (n = 1 to 4) register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | AACI_TX6 | AACI_TX8 |
                       AACI_TX12 | AACI_TEN;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TX4 |
                       AACI_TX5 | AACI_TX9 | AACI_TX10 | AACI_TEN;
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | AACI_TX3 | AACI_TX7 |
                       AACI_TX11 | AACI_TEN;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[4] | CmpctMod | AACI_TX1 |
                       AACI_TX2 | AACI_TEN;

  for (i = 1; i < 7; i++)
  {
    /* No data is to be written to the AACISLnTX (n = 1, 2, 12) 
       registers */
    CW.TxRegWtSltEn[i] = 0x0;
    
    /* None of the frames contain data transmitted through the AACISLnTX
       (n = 1, 2, 12) Slot registers */
    CW.TxRegRdSltEn[i] = 0x0;
  }

  /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the channels
     for each frame */
  CW.TxFIFOWtSltEn[2]  = TX1 | TX2 | TX3 | TX4 | TX5 | TX6 | TX7 |
                         TX8 | TX9 | TX10 | TX11 | TX12;
  CW.TxFIFOWtSltEn[3]  = TX1 | TX2 | TX4 | TX5 | TX9 | TX10;
  CW.TxFIFOWtSltEn[4]  = TX1 | TX2;
  CW.TxFIFOWtSltEn[5]  = TX1 | TX2 | TX3 | TX6 | TX7 | TX8 | TX11 |
                         TX12;
  CW.TxFIFOWtSltEn[6]  = 0x0;

  /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from Channel Tx FIFOs of
     the AACI (data could be from either the Channels or from the
     AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxFIFORdSltEn[1]  = 0x0;
  CW.TxFIFORdSltEn[2]  = TX1 | TX2 | TX4 | TX5 | TX9 | TX10;
  CW.TxFIFORdSltEn[3]  = TX1 | TX2 | TX4 | TX5 | TX9 | TX10;
  CW.TxFIFORdSltEn[4]  = TX1 | TX2 | TX3 | TX6 | TX7 | TX8 | TX11 |
                         TX12;
  CW.TxFIFORdSltEn[5]  = TX1 | TX2;
  CW.TxFIFORdSltEn[6]  = TX3 | TX6 | TX7 | TX8 | TX11 | TX12;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  for (i = 1; i < 7; i++)
  {
    CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
  }

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the 
     slot0 to be transmitted by the trickbox */
  for (i = 1; i < 7; i++)
    CW.AACITB_SLOT0[i] = FV;

  /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
     about which of the SRC bits need to be set by the trickbox
     for each frame  */
  CW.AACITB_SLOT1[1] = SRC3 | SRC6 | SRC7 | SRC8 | SRC11 | SRC12;
  CW.AACITB_SLOT1[2] = SRC3 | SRC6 | SRC7 | SRC8 | SRC11 | SRC12;
  CW.AACITB_SLOT1[3] = SRC4 | SRC5 | SRC9 | SRC10;
  CW.AACITB_SLOT1[4] = SRC3 | SRC6 | SRC7 | SRC8 | SRC11 | SRC12;
  CW.AACITB_SLOT1[5] = 0x0;
  CW.AACITB_SLOT1[6] = 0x0;

  /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
     version of the SRC bits transmitted by the trickbox. This is
     used for computational purposes. */
  for (i = 1; i < 7; i++)
    CW.RemapedSRC[i] = RemapSR(i);

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_FsPCLK_Test(6);

  if (CmpctMod == 0x0)
  {
    C("Channel1Tx enabled and has slot 11");
    C("Channel2Tx enabled and has slots 1, 1, 2 and 12");
    C("Channel3Tx enabled and has slots 4, 6 and 8");
    C("Channel4Tx enabled and has slot 9");
    C("SRC bits set for multiple slots");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4) register */
    CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | AACI_TX11 | AACI_TEN;
    CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | AACI_TX1 | AACI_TX2 |
                         AACI_TX12 | AACI_TEN;
    CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | AACI_TX4 | AACI_TX6 |
                         AACI_TX8 | AACI_TEN;
    CW.DatTxCntlReg[4] = AACI_FEN | TxSize[4] | AACI_TX9 | AACI_TEN;
  
    for (i = 1; i < 8; i++)
    {
      /* None of the frames contain data transmitted through the 
         AACISLnTX (n = 1, 2, 12) Slot registers */
      CW.TxRegRdSltEn[i] = 0x0;

      /* No data is to be written to the AACISLnTX (n = 1, 2, 12) 
         registers */
      CW.TxRegWtSltEn[i] = 0x0;
    }
  
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
       slot0 to be transmitted by the trickbox */
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
    TxRx_FsPCLK_Test(7);

/**********************************************************************/
/***************** Tx Only - CH - Char mode - No SRC ******************/
/**********************************************************************/
  /*
    The AACI is programmed for transmission-only in the Character mode.
    No SRC bits are set in the incoming frame. Three tests are done 
    under this category. The following parameters are varied for each 
    test.
      o The number of slots enabled for transmission per channel
      o The number of slots enabled per transmitted frame.
      o TSIZE

    The tests are repeated by programming the channels to transmit 
    data for different combinations of slots.

  */

    C("Tx Only - CH - Char mode - No SRC");
    C("Channel3Tx enabled and has slot 1");
    C("Channel4Tx enabled and has slot 12");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[3] = TxSize[3] | AACI_TX1 | AACI_TEN;
    CW.DatTxCntlReg[4] = TxSize[4] | AACI_TX12 | AACI_TEN;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    CW.AACI_SLOT0[1] = 0x0;
    CW.AACI_SLOT0[2] = FV | S1 | S12;
    CW.AACI_SLOT0[3] = FV | S1 | S12;
    CW.AACI_SLOT0[4] = FV | S1 | S12;
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox */
    CW.AACITB_SLOT0[1] = FV;
    CW.AACITB_SLOT0[2] = FV;
    CW.AACITB_SLOT0[3] = FV;
    CW.AACITB_SLOT0[4] = FV;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  
    C("Channel1Tx enabled and has slot 1");
    C("Channel2Tx enabled and has slot 4");
    C("Channel3Tx enabled and has slot 11");
    C("Channel4Tx enabled and has slot 10");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[1] = TxSize[1] | AACI_TX1 | AACI_TEN;
    CW.DatTxCntlReg[2] = TxSize[2] | AACI_TX4 | AACI_TEN;
    CW.DatTxCntlReg[3] = TxSize[3] | AACI_TX11 | AACI_TEN;
    CW.DatTxCntlReg[4] = TxSize[4] | AACI_TX10 | AACI_TEN;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    CW.AACI_SLOT0[1] = 0x0;
    CW.AACI_SLOT0[2] = FV | S1 | S4 | S10 | S11;
    CW.AACI_SLOT0[3] = FV | S1 | S4 | S10 | S11;
    CW.AACI_SLOT0[4] = FV | S1 | S4 | S10 | S11;
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox */
    CW.AACITB_SLOT0[1] = FV;
    CW.AACITB_SLOT0[2] = FV;
    CW.AACITB_SLOT0[3] = FV;
    CW.AACITB_SLOT0[4] = FV;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  
    C("Channel1Tx enabled and has slot 3");
    C("Channel2Tx enabled and has slot 5");
    C("Channel3Tx enabled and has slot 7");
    C("Channel4Tx enabled and has slot 1");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[1] = TxSize[1] | AACI_TX3 | AACI_TEN;
    CW.DatTxCntlReg[2] = TxSize[2] | AACI_TX5 | AACI_TEN;
    CW.DatTxCntlReg[3] = TxSize[3] | AACI_TX7 | AACI_TEN;
    CW.DatTxCntlReg[4] = TxSize[4] | AACI_TX1 | AACI_TEN;
  
    for (i = 1; i < 5; i++)
    {
      /* No data is to be written to the AACISLnTX (n = 1, 2, 12) 
         registers */
      CW.TxRegWtSltEn[i]  = 0x0;

      /* None of the frames contain data transmitted through the 
         AACISLnTX (n = 1, 2, 12) Slot registers */
      CW.TxRegRdSltEn[i]  = 0x0;
    }
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX3 | TX5 | TX7;
    CW.TxFIFOWtSltEn[3]  = TX3 | TX5 | TX7;
    CW.TxFIFOWtSltEn[4]  = TX3 | TX5 | TX7;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX3 | TX5 | TX7;
    CW.TxFIFORdSltEn[3]  = TX3 | TX5 | TX7;
    CW.TxFIFORdSltEn[4]  = TX3 | TX5 | TX7;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 5; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox */
    CW.AACITB_SLOT0[1] = FV;
    CW.AACITB_SLOT0[2] = FV;
    CW.AACITB_SLOT0[3] = FV;
    CW.AACITB_SLOT0[4] = FV;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  
/**********************************************************************/
/***************** Tx Only - CH - Char mode - SRC *********************/
/**********************************************************************/
  /*
    The AACI is programmed for transmission-only in the Character mode.
    SRC bits are set in the incoming frame. Three tests are done under 
    this category. The following parameters are varied for each test.
      o The number of slots enabled for transmission per channel
      o The number of slots enabled per transmitted frame.
      o SRC bit-pattern to be transmitted by the trickbox for each frame
      o TSIZE

    The tests are repeated by programming the channels to transmit 
    data for different combinations of slots.

  */

    C("Tx Only - CH - Char mode - SRC");
    C("Channel1Tx enabled and has slot 4");
    C("Channel2Tx enabled and has slot 5");
    C("Channel3Tx enabled and has slot 6");
    C("Channel4Tx enabled and has slot 7");
    C("SRC bits set for multiple slots");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[1] = TxSize[1] | AACI_TX4 | AACI_TEN;
    CW.DatTxCntlReg[2] = TxSize[2] | AACI_TX5 | AACI_TEN;
    CW.DatTxCntlReg[3] = TxSize[3] | AACI_TX6 | AACI_TEN;
    CW.DatTxCntlReg[4] = TxSize[4] | AACI_TX7 | AACI_TEN;
  
    for (i = 1; i < 7; i++)
    {
      /* No data is to be written to the AACISLnTX (n = 1, 2, 12) 
         registers */
      CW.TxRegWtSltEn[i]  = 0x0;

      /* None of the frames contain data transmitted through the 
         AACISLnTX (n = 1, 2, 12) Slot registers */
      CW.TxRegRdSltEn[i]  = 0x0;
    }
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX4 | TX5 | TX6 | TX7;
    CW.TxFIFOWtSltEn[3]  = TX4 | TX5;
    CW.TxFIFOWtSltEn[4]  = TX6 | TX7;
    CW.TxFIFOWtSltEn[5]  = 0x0;
    CW.TxFIFOWtSltEn[6]  = 0x0;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX4 | TX5;
    CW.TxFIFORdSltEn[3]  = TX5 | TX6 | TX7;
    CW.TxFIFORdSltEn[4]  = TX6;
    CW.TxFIFORdSltEn[5]  = TX4;
    CW.TxFIFORdSltEn[6]  = TX7;
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox */
    for (i = 1; i < 7; i++)
    {
      CW.AACITB_SLOT0[i] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                           S9 | S10 | S11 | S12;
    }
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 7; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }

    /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
       about which of the SRC bits need to be set by the trickbox
       for each frame  */
    CW.AACITB_SLOT1[1] = SRC7 | SRC6;
    CW.AACITB_SLOT1[2] = SRC4;
    CW.AACITB_SLOT1[3] = SRC4 | SRC7;
    CW.AACITB_SLOT1[4] = SRC7;
    CW.AACITB_SLOT1[5] = 0x0;
    CW.AACITB_SLOT1[6] = 0x0;
  
    /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
       version of the SRC bits transmitted by the trickbox. This is
       used for computational purposes. */
    for (i = 1; i < 7; i++)
      CW.RemapedSRC[i] = RemapSR(i);
  
    /* Perform a 6-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(6);
  
    C("Channel1Tx enabled and has slot 7");
    C("Channel2Tx enabled and has slot 12");
    C("Channel3Tx enabled and has slot 10");
    C("Channel4Tx enabled and has slot 11");
    C("SRC bits set for multiple slots");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the
       value to be programmed the AACITXCRn (n = 1 to 4) register */
    CW.DatTxCntlReg[1] = TxSize[1] | AACI_TX7 | AACI_TEN;
    CW.DatTxCntlReg[2] = TxSize[2] | AACI_TX12 | AACI_TEN;
    CW.DatTxCntlReg[3] = TxSize[3] | AACI_TX10 | AACI_TEN;
    CW.DatTxCntlReg[4] = TxSize[4] | AACI_TX11 | AACI_TEN;
  
    for (i = 1; i < 7; i++)
    {
      /* No data is to be written to the AACISLnTX (n = 1, 2, 12) 
         registers */
      CW.TxRegWtSltEn[i]  = 0x0;

      /* None of the frames contain data transmitted through the 
         AACISLnTX (n = 1, 2, 12) Slot registers */
      CW.TxRegRdSltEn[i]  = 0x0;
    }
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX7 | TX10 | TX11 | TX12;
    CW.TxFIFOWtSltEn[3]  = TX7;
    CW.TxFIFOWtSltEn[4]  = TX11;
    CW.TxFIFOWtSltEn[5]  = TX12;
    CW.TxFIFOWtSltEn[6]  = TX10;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX7;
    CW.TxFIFORdSltEn[3]  = TX11;
    CW.TxFIFORdSltEn[4]  = TX7 | TX12;
    CW.TxFIFORdSltEn[5]  = TX10 | TX11 | TX12;
    CW.TxFIFORdSltEn[6]  = TX10;
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox */
    for (i = 1; i < 7; i++)
    {
      CW.AACITB_SLOT0[i] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                           S9 | S10 | S11 | S12;
    }
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 7; i++)
    {
      CW.AACI_SLOT0[i]   = Calculate_AaciSlot0(i);
    }
  
    /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
       about which of the SRC bits need to be set by the trickbox
       for each frame  */
    CW.AACITB_SLOT1[1] = SRC10 | SRC11 | SRC12;
    CW.AACITB_SLOT1[2] = SRC7 | SRC10 | SRC12;
    CW.AACITB_SLOT1[3] = SRC11 | SRC10;
    CW.AACITB_SLOT1[4] = SRC7;
    CW.AACITB_SLOT1[5] = 0x0;
    CW.AACITB_SLOT1[6] = 0x0;
  
    /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
       version of the SRC bits transmitted by the trickbox. This is
       used for computational purposes. */
    for (i = 1; i < 7; i++)
      CW.RemapedSRC[i] = RemapSR(i);
  
    /* Perform a 6-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(6);

    C("Channel1Tx enabled and has slot 12");
    C("Channel2Tx enabled and has slot 8");
    C("Channel3Tx enabled and has slot 11");
    C("Channel4Tx enabled and has slot 9");
    C("SRC bits set for multiple slots");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[1] = TxSize[1] | AACI_TX12 | AACI_TEN;
    CW.DatTxCntlReg[2] = TxSize[2] | AACI_TX8 | AACI_TEN;
    CW.DatTxCntlReg[3] = TxSize[3] | AACI_TX11 | AACI_TEN;
    CW.DatTxCntlReg[4] = TxSize[4] | AACI_TX9 | AACI_TEN;
  
    for (i = 1; i < 6; i++)
    {
      /* No data is to be written to the AACISLnTX (n = 1, 2, 12) 
         registers */
      CW.TxRegWtSltEn[i]  = 0x0;

      /* None of the frames contain data transmitted through the 
         AACISLnTX (n = 1, 2, 12) Slot registers */
      CW.TxRegRdSltEn[i]  = 0x0;
    }
  
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
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox */
    for (i = 1; i < 7; i++)
    {
      CW.AACITB_SLOT0[i] = FV | S2 | S5 | S7 | S11 | S12;
    }
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 7; i++)
    {
      CW.AACI_SLOT0[i]   = Calculate_AaciSlot0(i);
    }
  
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
    TxRx_FsPCLK_Test(5);
  }

/**********************************************************************/
/***************** Tx Only - SLReg - No SRC ***************************/
/**********************************************************************/
  /*
    The AACI is programmed for transmission-only through the AACISLnTX
    (n = 1, 2 and 12) registers. No SRC bits are set in the incoming
    frame. Two data tests are done under this category. 
    The following parameters are varied for each test.
      o Information about which of the AACISLnTX (n = 1, 2, 12) 
        register is to be loaded with new data for each frame 
      o Information about which of the AACISLnTX (n = 1, 2, 12) 
        register is to be enabled for each frame

  */

  if (CmpctMod == 0x0)
  {
    C("Tx Only - SLReg - No SRC");
    C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");

    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();

    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox */
    for (i = 1; i < 12; i++)
      CW.AACITB_SLOT0[i] = Calculate_TrSlot0();

    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1] = 0x0;
    CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[3] = TX1 | TX2;
    CW.TxRegWtSltEn[4] = TX1 | TX12;

    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1] = 0x0;
    CW.TxRegRdSltEn[2] = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[3] = TX1 | TX2;
    CW.TxRegRdSltEn[4] = TX1 | TX12;

    for (i = 1; i < 5; i++)
    {
      /* No data is to be written to the Channel Tx FIFOs */
      CW.TxFIFOWtSltEn[i] = 0x0;

      /* None of the frames contain data transmitted through the 
         channels */
      CW.TxFIFORdSltEn[i] = 0x0;
    }

    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 5; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }

    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
   
    C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");

    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();

    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox */
    for (i = 1; i < 12; i++)
      CW.AACITB_SLOT0[i] = Calculate_TrSlot0();

    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1] = 0x0;
    CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[3] = TX1 | TX12;
    CW.TxRegWtSltEn[4] = TX2 | TX12;
    CW.TxRegWtSltEn[5] = TX1;
    CW.TxRegWtSltEn[6] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[7] = 0x0;

    /* Assign CW.TxRegSltEn[n] (n = Frame number) with information 
       about which of the AACISLnTX (n = 1, 2, 12) registers need to be
       enabled for each frame */
    CW.TxRegSltEn[2] = TX1 | TX2 | TX12;
    CW.TxRegSltEn[3] = TX2 | TX12;
    CW.TxRegSltEn[4] = TX1 | TX12;
    CW.TxRegSltEn[5] = TX1 | TX2 | TX12;
    CW.TxRegSltEn[6] = TX1 | TX2;
    CW.TxRegSltEn[7] = TX1 | TX2 | TX12;

    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1] = 0x0;
    CW.TxRegRdSltEn[2] = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[3] = TX12;
    CW.TxRegRdSltEn[4] = TX1 | TX12;
    CW.TxRegRdSltEn[5] = TX1 | TX2;
    CW.TxRegRdSltEn[6] = TX1 | TX2;
    CW.TxRegRdSltEn[7] = TX12;

    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    CW.AACI_SLOT0[1] = 0x0;
    CW.AACI_SLOT0[2] = FV | S1 | S2 | S12;
    CW.AACI_SLOT0[3] = FV | S12;
    CW.AACI_SLOT0[4] = FV | S1 | S12;
    CW.AACI_SLOT0[5] = FV | S1 | S2;
    CW.AACI_SLOT0[6] = FV | S1 | S2;
    CW.AACI_SLOT0[7] = FV | S12;

    /* Perform a 7-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(7);
  }

/**********************************************************************/
/********************** Tx Only - SLReg - SRC *************************/
/**********************************************************************/
  /*
    The AACI is programmed for transmission-only through the AACISLnTX 
    (n = 1, 2 and 12) registers. SRC bits are set in the incoming
    frame. Two data tests are done under this category. 
    The following parameters are varied for each test.
      o Information about  which of the AACISLnTX (n = 1, 2, 12) 
        registers are to be loaded with new data for each frame 
      o Information about  which of the AACISLnTX (n = 1, 2, 12) 
        registers are to be enabled for each frame
      o SRC bit-pattern to be transmitted by the trickbox for each frame

  */

  if (CmpctMod == 0x0)
  {
    C("Tx Only - SLReg - SRC");
    C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");
    C("SRC bits set for multiple slots");

    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();

    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1] = 0x0;
    CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[3] = TX1 | TX2;
    CW.TxRegWtSltEn[4] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[5] = 0x0;

    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1] = 0x0;
    CW.TxRegRdSltEn[2] = TX1 | TX2;
    CW.TxRegRdSltEn[3] = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[4] = TX1 | TX2;
    CW.TxRegRdSltEn[5] = TX12;

    for (i = 1; i < 6; i++)
    {
      /* No data is to be written to the Channel Tx FIFOs */
      CW.TxFIFOWtSltEn[i] = 0x0;

      /* None of the frames contain data transmitted through the
         channels */
      CW.TxFIFORdSltEn[i] = 0x0;
    }

    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 6; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }

    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the 
       slot0 to be transmitted by the trickbox */
    CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S7 | S9 | S10 | S12;
    CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S7 | S9 | S10 | S12;
    CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S7 | S9 | S10 | S12;
    CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S7 | S9 | S10 | S12;
    CW.AACITB_SLOT0[5] = FV;

    /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
       about which of the SRC bits need to be set by the trickbox
       for each frame  */
    CW.AACITB_SLOT1[1] = SRC3 | SRC4 | SRC5 | SRC6 | SRC7 | SRC8 |
                         SRC9 | SRC10 | SRC11 | SRC12;
    CW.AACITB_SLOT1[2] = 0x0;
    CW.AACITB_SLOT1[3] = SRC12;
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
    TxRx_FsPCLK_Test(5);

    C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");
    C("SRC bits set for multiple slots");

    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();

    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

    /* Assign CW.TxRegSltEn[n] (n = Frame number) with information 
       about which of the AACISLnTX (n = 1, 2, 12) registers need to be
       enabled for each frame */
    CW.TxRegSltEn[2] = TX1 | TX2 | TX12;
    CW.TxRegSltEn[3] = TX2 | TX12;
    CW.TxRegSltEn[4] = TX1 | TX12;
    CW.TxRegSltEn[5] = TX1 | TX2 | TX12;
    CW.TxRegSltEn[6] = TX1 | TX2 | TX12;
    CW.TxRegSltEn[7] = TX1 | TX2;
    CW.TxRegSltEn[8] = TX1 | TX2;
    CW.TxRegSltEn[9] = TX1 | TX2 | TX12;

    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1] = 0x0;
    CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[3] = TX1;
    CW.TxRegWtSltEn[3] = TX1;
    CW.TxRegWtSltEn[4] = TX12;
    CW.TxRegWtSltEn[5] = 0x0;
    CW.TxRegWtSltEn[6] = TX1;
    CW.TxRegWtSltEn[7] = TX12;
    CW.TxRegWtSltEn[8] = 0x0;
    CW.TxRegWtSltEn[9] = 0x0;

    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1] = 0x0;
    CW.TxRegRdSltEn[2] = TX1 | TX2;
    CW.TxRegRdSltEn[3] = TX12;
    CW.TxRegRdSltEn[4] = TX1;
    CW.TxRegRdSltEn[5] = TX12;
    CW.TxRegRdSltEn[6] = TX1;
    CW.TxRegRdSltEn[7] = 0x0;
    CW.TxRegRdSltEn[8] = 0x0;
    CW.TxRegRdSltEn[9] = TX12;

    for (i = 1; i < 10; i++)
    {
      /* No data is to be written to the Channel Tx FIFOs */
      CW.TxFIFOWtSltEn[i] = 0x0;

      /* None of the frames contain data transmitted through the
         channels */
      CW.TxFIFORdSltEn[i] = 0x0;
    }

    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 10; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }

    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox */
    CW.AACITB_SLOT0[1] = FV | S3 | S7 | S9 | S10 | S12;
    CW.AACITB_SLOT0[2] = FV | S3 | S7 | S9 | S10 | S12;
    CW.AACITB_SLOT0[3] = FV | S3 | S7 | S9 | S10 | S12;
    CW.AACITB_SLOT0[4] = FV | S3 | S7 | S9 | S10 | S12;
    CW.AACITB_SLOT0[5] = FV | S3 | S7 | S9 | S10 | S12;
    CW.AACITB_SLOT0[6] = FV | S3 | S7 | S9 | S10 | S12;
    CW.AACITB_SLOT0[7] = FV | S3 | S7 | S9 | S10 | S12;
    CW.AACITB_SLOT0[8] = FV;
    CW.AACITB_SLOT0[9] = FV;

    /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
       about which of the SRC bits need to be set by the trickbox
       for each frame  */
    CW.AACITB_SLOT1[1] = SRC3 | SRC4 | SRC5 | SRC6 | SRC7 | SRC8 |
                         SRC9 | SRC10 | SRC11 | SRC12;
    CW.AACITB_SLOT1[2] = 0x0;
    CW.AACITB_SLOT1[3] = SRC12;
    CW.AACITB_SLOT1[4] = 0x0;
    CW.AACITB_SLOT1[5] = 0x0;
    CW.AACITB_SLOT1[6] = SRC12;
    CW.AACITB_SLOT1[7] = 0x0;
    CW.AACITB_SLOT1[8] = 0x0;
    CW.AACITB_SLOT1[9] = 0x0;

    /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
       version of the SRC bits transmitted by the trickbox. This is
       used for computational purposes. */
    for (i = 1; i < 10; i++)
    {
      CW.RemapedSRC[i] = RemapSR(i);
    }

    /* Perform a 9-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(9);
  }

/**********************************************************************/
/*************** Tx Only - CH & SLReg - FIFO mode - No SRC ************/
/**********************************************************************/
  /*
    The AACI is programmed for transmission-only in the FIFO mode.
    AACISLnTX (n = 1, 2 and 12) are also enabled for transmission.
    No SRC bits are set in the incoming frame. Five data tests are 
    done under this category. The following parameters are varied for
    each test.
      o The number of slots enabled for transmission per channel
      o The number of slots enabled per transmitted frame.
      o TSIZE
      o Information about  which of the AACISLnTX (n = 1, 2, 12) 
        registers are to be loaded with new data for each frame 
      o Whether data for Slots 1, 2 and 12 are present in Channels AND 
        Slot registers (as against data being present for these slots
        ONLY in Slot registers or ONLY in channels)

    The tests are repeated by programming the channels to transmit 
    data for different combinations of slots.

    The test cases having an even number of slots enabled per channel 
    are again executed with the CM bit set in the AACITXCRn (n = 1 to 4)
    register.

  */

  if (CmpctMod == 0x0)
  {
    C("Tx Only - CH & SLReg - FIFO mode - No SRC");
    C("Channel1Tx enabled and has slots 1, 2 and 12");
    C("AACISL1TX, AACISL2TX, AACISL12TX are enabled ");

    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | AACI_TEN | AACI_TX1 |
                         AACI_TX2 | AACI_TX12;
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox */
    for (i = 1; i < 12; i++)
      CW.AACITB_SLOT0[i] = Calculate_TrSlot0();
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1] = 0x0;
    CW.TxFIFOWtSltEn[2] = TX1 | TX2 | TX12;
    CW.TxFIFOWtSltEn[3] = TX1 | TX2 | TX12;

    for (i = 4; i < 12; i++)
      CW.TxFIFOWtSltEn[i] = 0x0;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    for (i = 1; i < 12; i++)
      CW.TxFIFORdSltEn[i] = CW.TxFIFOWtSltEn[i];
  
    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1] = 0x0;
    CW.TxRegRdSltEn[2] = 0x0;
    CW.TxRegRdSltEn[3] = 0x0;
    CW.TxRegRdSltEn[4] = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[5] = 0x0;
    CW.TxRegRdSltEn[6] = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[7] = TX1;
    CW.TxRegRdSltEn[8] = TX12;
    
    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1] = 0x0;
    CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[3] = 0x0;
    CW.TxRegWtSltEn[4] = 0x0;
    CW.TxRegWtSltEn[5] = 0x0;
    CW.TxRegWtSltEn[6] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[7] = TX1;
    CW.TxRegWtSltEn[8] = TX12;

    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 12; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* Perform a 8-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(8);
  
    C("Channel1Tx enabled and has slot 1");
    C("Channel2Tx enabled and has slot 2");
    C("Channel3Tx enabled and has slot 12");
    C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");

    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | AACI_TEN | AACI_TX1;
    CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | AACI_TEN | AACI_TX2;
    CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | AACI_TEN | AACI_TX12;
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox */
    for (i = 1; i < 12; i++)
      CW.AACITB_SLOT0[i] = Calculate_TrSlot0();
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1] = 0x0;
    CW.TxFIFOWtSltEn[2] = TX1 | TX2 | TX12;
    CW.TxFIFOWtSltEn[3] = TX1 | TX2 | TX12;

    for (i = 4; i < 12; i++)
      CW.TxFIFOWtSltEn[i] = 0x0;
   
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    for (i = 1; i < 12; i++)
      CW.TxFIFORdSltEn[i] = CW.TxFIFOWtSltEn[i];
  
    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1] = 0x0;
    CW.TxRegRdSltEn[2] = 0x0;
    CW.TxRegRdSltEn[3] = 0x0;
    CW.TxRegRdSltEn[4] = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[5] = 0x0;
    CW.TxRegRdSltEn[6] = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[7] = TX12;
    CW.TxRegRdSltEn[8] = TX1;
    
    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1] = 0x0;
    CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[3] = 0x0;
    CW.TxRegWtSltEn[4] = 0x0;
    CW.TxRegWtSltEn[5] = 0x0;
    CW.TxRegWtSltEn[6] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[7] = TX12;
    CW.TxRegWtSltEn[8] = TX1;
    
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 12; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* Perform a 8-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(8);
  }

  C("Channel2Tx enabled and has slots 1, 3, 9 and 12");
  C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");

  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with the value
     to be programmed into the AACITXCRn (n = 1 to 4) register */
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TEN |
                       AACI_TX1 | AACI_TX3 | AACI_TX9 | AACI_TX12;
  CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
  for (i = 1; i < 12; i++)
    CW.AACITB_SLOT0[i] = Calculate_TrSlot0();

  /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the channels
     for each frame */
  CW.TxFIFOWtSltEn[1] = 0x0;
  CW.TxFIFOWtSltEn[2] = TX1 | TX3 | TX9 | TX12;
  CW.TxFIFOWtSltEn[3] = TX1 | TX3 | TX9 | TX12;
  CW.TxFIFOWtSltEn[4] = 0x0;
  CW.TxFIFOWtSltEn[5] = 0x0;
  CW.TxFIFOWtSltEn[6] = 0x0;
  CW.TxFIFOWtSltEn[7] = TX1 | TX3 | TX9 | TX12;
  CW.TxFIFOWtSltEn[8] = 0x0;

  /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from Channel Tx FIFOs of
     the AACI (data could be from either the Channels or from the
     AACISLnTX (n = 1, 2, 12) registers) */ 
  for (i = 1; i < 12; i++)
    CW.TxFIFORdSltEn[i] = CW.TxFIFOWtSltEn[i];

  /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from the AACISLnTX 
     (n = 1, 2, 12) registers (data could be from either the Channels
     or from the AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxRegRdSltEn[1] = 0x0;
  CW.TxRegRdSltEn[2] = TX2;
  CW.TxRegRdSltEn[3] = 0x0;
  CW.TxRegRdSltEn[4] = TX1 | TX12;
  CW.TxRegRdSltEn[5] = 0x0;
  CW.TxRegRdSltEn[6] = TX1 | TX2 | TX12;
  CW.TxRegRdSltEn[7] = TX2;
  CW.TxRegRdSltEn[8] = TX1 | TX2;

  /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the 
     AACISLnTX (n = 1, 2, 12) registers for each frame */
  CW.TxRegWtSltEn[1] = 0x0;
  CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
  CW.TxRegWtSltEn[3] = 0x0;
  CW.TxRegWtSltEn[4] = 0x0;
  CW.TxRegWtSltEn[5] = 0x0;
  CW.TxRegWtSltEn[6] = TX1 | TX2 | TX12;
  CW.TxRegWtSltEn[7] = TX1 | TX2;
  CW.TxRegWtSltEn[8] = TX2;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  for (i = 1; i < 12; i++)
  {
    CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
  }

  /* Perform a 8-frame data transfer with the above settings */
  TxRx_FsPCLK_Test(8);

  C("Channel3Tx enabled and has slots 4, 6, 8 and 11");
  C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");

  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with the value
     to be programmed into the AACITXCRn (n = 1 to 4) register */
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | CmpctMod | AACI_TEN |
                       AACI_TX4 | AACI_TX6 | AACI_TX8 | AACI_TX11;
  CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
  for (i = 1; i < 12; i++)
    CW.AACITB_SLOT0[i] = Calculate_TrSlot0();

  /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the channels
     for each frame */
  CW.TxFIFOWtSltEn[1] = 0x0;
  CW.TxFIFOWtSltEn[2] = TX4 | TX6 | TX8 | TX11;
  CW.TxFIFOWtSltEn[3] = TX4 | TX6 | TX8 | TX11;
  CW.TxFIFOWtSltEn[4] = 0x0;
  CW.TxFIFOWtSltEn[5] = 0x0;
  CW.TxFIFOWtSltEn[6] = TX4 | TX6 | TX8 | TX11;

  /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from Channel Tx FIFOs of
     the AACI (data could be from either the Channels or from the
     AACISLnTX (n = 1, 2, 12) registers) */ 
  for (i = 1; i < 12; i++)
    CW.TxFIFORdSltEn[i] = CW.TxFIFOWtSltEn[i];

  /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from the AACISLnTX 
     (n = 1, 2, 12) registers (data could be from either the Channels
     or from the AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxRegRdSltEn[1] = 0x0;
  CW.TxRegRdSltEn[2] = TX1 | TX2 | TX12;
  CW.TxRegRdSltEn[3] = 0x0;
  CW.TxRegRdSltEn[4] = 0x0;
  CW.TxRegRdSltEn[5] = TX1 | TX2 | TX12;
  CW.TxRegRdSltEn[6] = TX1 | TX12;

  /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the 
     AACISLnTX (n = 1, 2, 12) registers for each frame */
  CW.TxRegWtSltEn[1] = 0x0;
  CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
  CW.TxRegWtSltEn[3] = 0x0;
  CW.TxRegWtSltEn[4] = 0x0;
  CW.TxRegWtSltEn[5] = TX1 | TX2 | TX12;
  CW.TxRegWtSltEn[6] = TX1 | TX12;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  for (i = 1; i < 12; i++)
  {
    CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
  }

  /* Perform a 6-frame data transfer with the above settings */
  TxRx_FsPCLK_Test(6);

  C("Channel1Tx enabled and has slots 1 and 2");
  C("Channel2Tx enabled and has slots 10 and 11");
  C("Channel3Tx enabled and has slots 3, 7, 8 and 9");
  C("Channel4Tx enabled and has slots 4, 5, 6 and 12");
  C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");

  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with the value
     to be programmed into the AACITXCRn (n = 1 to 4) register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TEN |
                       AACI_TX1 | AACI_TX2;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TEN |
                       AACI_TX10 | AACI_TX11;
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | CmpctMod | AACI_TEN |
                       AACI_TX3 | AACI_TX7 | AACI_TX8 | AACI_TX9;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[4] | CmpctMod | AACI_TEN |
                       AACI_TX4 | AACI_TX5 | AACI_TX6 | AACI_TX12;
  CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
  for (i = 1; i < 12; i++)
    CW.AACITB_SLOT0[i] = Calculate_TrSlot0();

  /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the channels
     for each frame */
  CW.TxFIFOWtSltEn[1] = 0x0;
  CW.TxFIFOWtSltEn[2] = TX1 | TX2 | TX3 | TX4 | TX5 | TX6 | TX7 | TX8 |
                        TX9 | TX10 | TX11 | TX12;
  CW.TxFIFOWtSltEn[3] = 0x0;
  CW.TxFIFOWtSltEn[4] = 0x0;
  CW.TxFIFOWtSltEn[5] = 0x0;
  CW.TxFIFOWtSltEn[6] = TX1 | TX2 | TX10 | TX11;
  CW.TxFIFOWtSltEn[7] = TX3 | TX4 | TX5 | TX6 | TX7 | TX8 | TX9 | TX12;
  CW.TxFIFOWtSltEn[8] = TX4 | TX5 | TX6 | TX12;
  CW.TxFIFOWtSltEn[9] = 0x0;

  /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from Channel Tx FIFOs of
     the AACI (data could be from either the Channels or from the
     AACISLnTX (n = 1, 2, 12) registers) */ 
  for (i = 1; i < 12; i++)
    CW.TxFIFORdSltEn[i] = CW.TxFIFOWtSltEn[i];

  /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
     about which of the slot data originated from the AACISLnTX 
     (n = 1, 2, 12) registers (data could be from either the Channels
     or from the AACISLnTX (n = 1, 2, 12) registers) */ 
  CW.TxRegRdSltEn[1] = 0x0;
  CW.TxRegRdSltEn[2] = 0x0;
  CW.TxRegRdSltEn[3] = TX1 | TX2 | TX12;
  CW.TxRegRdSltEn[4] = 0x0;
  CW.TxRegRdSltEn[5] = TX1 | TX2 | TX12;
  CW.TxRegRdSltEn[6] = 0x0;
  CW.TxRegRdSltEn[7] = TX1 | TX2;
  CW.TxRegRdSltEn[8] = 0x0;
  CW.TxRegRdSltEn[9] = TX12;

  /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
     about slots for which data need to be written into the 
     AACISLnTX (n = 1, 2, 12) registers for each frame */
  CW.TxRegWtSltEn[1] = 0x0;
  CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
  CW.TxRegWtSltEn[3] = 0x0;
  CW.TxRegWtSltEn[4] = 0x0;
  CW.TxRegWtSltEn[5] = TX1 | TX2 | TX12;
  CW.TxRegWtSltEn[6] = TX1;
  CW.TxRegWtSltEn[7] = TX2;
  CW.TxRegWtSltEn[8] = TX12;
  CW.TxRegWtSltEn[9] = 0x0;

  /* The expected Slot0 from the AACI is assigned to the
     CW.AACI_SLOT0[n] (n = Frame number) */
  for (i = 1; i < 12; i++)
  {
    CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
  }

  /* Perform a 9-frame data transfer with the above settings */
  TxRx_FsPCLK_Test(9);

/**********************************************************************/
/*************** Tx Only - CH & SLReg - FIFO mode - SRC ***************/
/**********************************************************************/
  /*
    The AACI is programmed for transmission-only in the FIFO mode.
    AACISLnTX (n = 1, 2 and 12) are also enabled for transmission.
    SRC bits are set in the incoming frame. Four data tests are 
    done under this category. The following parameters are varied for
    each test.
      o The number of slots enabled for transmission per channel
      o The number of slots enabled per transmitted frame.
      o TSIZE
      o SRC bit-pattern to be transmitted by the trickbox for each frame
      o Information about  which of the AACISLnTX (n = 1, 2, 12) 
        registers are to be loaded with new data for each frame 
      o Whether data for Slots 1, 2 and 12 are present in Channels AND
        Slot registers (as against data being present for these slots
        ONLY in Slot registers or ONLY in channels)

    The tests are repeated by programming the channels to transmit 
    data for different combinations of slots.

    The test cases having an even number of slots enabled per channel 
    are again executed with the CM bit set in the AACITXCRn (n = 1 to 4)
    register.

  */

  if (CmpctMod == 0x0)
  {
    C("Tx Only - CH & SLReg - FIFO mode - SRC");
    C("Channel2Tx enabled and has slots 5, 6, 7, 8, 9, 10 and 12");
    C("Channel3Tx enabled and has slots 3, 4 and 11");
    C("AACISL1TX, AACISL12TX are enabled");
    C("SRC bits set for multiple slots");
 
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();

    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | AACI_TX5 | AACI_TX6 |
                         AACI_TX7 | AACI_TX8 | AACI_TX9 | AACI_TX10 |
                         AACI_TX12 | AACI_TEN;
    CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | AACI_TX3 | AACI_TX4 |
                         AACI_TX11 | AACI_TEN;

    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX12;

    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1]  = 0x0;
    CW.TxRegWtSltEn[2]  = TX1 | TX12;
    CW.TxRegWtSltEn[3]  = TX1;
    CW.TxRegWtSltEn[4]  = TX1;
    CW.TxRegWtSltEn[5]  = TX1;
    CW.TxRegWtSltEn[6]  = TX1;
  
    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1]  = 0x0;
    CW.TxRegRdSltEn[2]  = TX1;
    CW.TxRegRdSltEn[3]  = TX1;
    CW.TxRegRdSltEn[4]  = TX1;
    CW.TxRegRdSltEn[5]  = TX1;
    CW.TxRegRdSltEn[6]  = TX1 | TX12;
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX3 | TX4 | TX5 | TX6 | TX7 | TX8 | TX9 |
                           TX10 | TX11 | TX12;
    CW.TxFIFOWtSltEn[3]  = TX3 | TX4 | TX11;
    CW.TxFIFOWtSltEn[4]  = TX5 | TX6 | TX7 | TX8 | TX9 | TX10 | TX12;
    CW.TxFIFOWtSltEn[5]  = 0x0;
    CW.TxFIFOWtSltEn[6]  = 0x0;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX3 | TX4 | TX11;
    CW.TxFIFORdSltEn[3]  = TX5 | TX6 | TX7 | TX8 | TX9 | TX10 | TX12;
    CW.TxFIFORdSltEn[4]  = TX3 | TX4 | TX11;
    CW.TxFIFORdSltEn[5]  = TX5 | TX6 | TX7 | TX8 | TX9 | TX10 | TX12;
    CW.TxFIFORdSltEn[6]  = 0x0;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 7; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
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
    CW.AACITB_SLOT1[1] = SRC5 | SRC6 | SRC7 | SRC8 | SRC9 | SRC10 |
                         SRC12;
    CW.AACITB_SLOT1[2] = SRC3 | SRC4 | SRC11;
    CW.AACITB_SLOT1[3] = SRC5 | SRC6 | SRC7 | SRC8 | SRC9 | SRC10 |
                         SRC12;
    CW.AACITB_SLOT1[4] = SRC3 | SRC4 | SRC11;
    CW.AACITB_SLOT1[5] = 0x0;
    CW.AACITB_SLOT1[6] = 0x0;

    /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
       version of the SRC bits transmitted by the trickbox. This is
       used for computational purposes. */
    CW.RemapedSRC[2] = RemapSR(2);
    CW.RemapedSRC[3] = RemapSR(3);
    CW.RemapedSRC[4] = RemapSR(4);
    CW.RemapedSRC[5] = RemapSR(5);
    CW.RemapedSRC[6] = RemapSR(6);

    for (i = 1; i < 7; i++)
    {
      CW.RemapedSRC[i] = RemapSR(i);
    }
    /* Perform a 6-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(6);
  }

  C("Channel1Tx enabled and has slots 6, 8 and 12");
  C("Channel2Tx enabled and has slots 3, 7 and 11");
  C("Channel3Tx enabled and has slots 1 and 2");
  C("Channel4Tx enabled and has slots 4, 5, 9 and 10");
  C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");
  C("SRC bits set for multiple slots");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with the value
     to be programmed into the AACITXCRn (n = 1 to 4) register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | AACI_TX6 | AACI_TX8 |
                       AACI_TX12 | AACI_TEN;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | AACI_TX3 | AACI_TX7 |
                       AACI_TX11 | AACI_TEN;
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | CmpctMod | AACI_TX1 |
                       AACI_TX2 | AACI_TEN;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[4] | CmpctMod | AACI_TX4 |
                       AACI_TX5 | AACI_TX9 | AACI_TX10 | AACI_TEN;
  CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;

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
  CW.TxFIFOWtSltEn[2]  = TX1 | TX2 | TX3 | TX4 | TX5 | TX6 | TX7 | TX8
                         | TX9 | TX10 | TX11 | TX12;
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
  for (i = 1; i < 8; i++)
    CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);

  /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
  for (i = 1; i < 8; i++)
    CW.AACITB_SLOT0[i] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S10 | S11 | S12;

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
  TxRx_FsPCLK_Test(7);

  C("Channel1Tx enabled and has slots 8 and 10");
  C("Channel2Tx enabled and has slots 4 and 11");
  C("Channel3Tx enabled and has slots 3 and 7");
  C("Channel4Tx enabled and has slots 6 and 12");
  C("AACISL12TX are enabled");
  C("SRC bits set for multiple slots");
 
  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign CW.DatTxCntlReg[n] (n = channel number) with the value
     to be programmed into the AACITXCRn (n = 1 to 4) register */
  CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | CmpctMod | AACI_TX8 |
                       AACI_TX10 | AACI_TEN;
  CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | CmpctMod | AACI_TX4 |
                       AACI_TX11 | AACI_TEN;
  CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | CmpctMod | AACI_TX3 |
                       AACI_TX7 | AACI_TEN;
  CW.DatTxCntlReg[4] = AACI_FEN | TxSize[4] | CmpctMod | AACI_TX6 |
                       AACI_TX12 | AACI_TEN;
  CW.DatTxCntlReg[5] = AACI_TX12;

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
     slot0 to be transmitted by the trickbox */
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
  TxRx_FsPCLK_Test(6);

  if (CmpctMod == 0x0)
  {
    C("Channel1Tx enabled and has slots 1, 2 and 12");
    C("Channel2Tx enabled and has slots 5, 7 and 9");
    C("Channel3Tx enabled and has slot 10");
    C("Channel4Tx enabled and has slot 11");
    C("AACISL1TX, AACISL2TX, AACISL12TX are enabled");
    C("SRC bits set for multiple slots");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4)
        register */
    CW.DatTxCntlReg[1] = AACI_FEN | TxSize[1] | AACI_TX1 | AACI_TX2 |
                         AACI_TX12 | AACI_TEN;
    CW.DatTxCntlReg[2] = AACI_FEN | TxSize[2] | AACI_TX5 | AACI_TX7 |
                         AACI_TX9 | AACI_TEN;
    CW.DatTxCntlReg[3] = AACI_FEN | TxSize[3] | AACI_TX10 | AACI_TEN;
    CW.DatTxCntlReg[4] = AACI_FEN | TxSize[4] | AACI_TX11 | AACI_TEN;
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;
  
    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1] = 0x0;
    CW.TxRegRdSltEn[2] = TX1 | TX2;
    CW.TxRegRdSltEn[3] = TX1 | TX2;
    CW.TxRegRdSltEn[4] = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[5] = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[6] = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[7] = TX1 | TX2 | TX12;
  
    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1] = 0x0;
    CW.TxRegWtSltEn[2] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[3] = TX1 | TX2;
    CW.TxRegWtSltEn[4] = TX1 | TX2;
    CW.TxRegWtSltEn[5] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[6] = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[7] = TX1 | TX2 | TX12;
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX5 | TX7 | TX9 | TX10 | TX11;
    CW.TxFIFOWtSltEn[3]  = TX11;
    CW.TxFIFOWtSltEn[4]  = TX5 | TX7 | TX9 | TX11;
    CW.TxFIFOWtSltEn[5]  = TX10 | TX11;
    CW.TxFIFOWtSltEn[6]  = TX10;
    CW.TxFIFOWtSltEn[7]  = TX10;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX11;
    CW.TxFIFORdSltEn[3]  = TX5 | TX7 | TX9 | TX11;
    CW.TxFIFORdSltEn[4]  = TX10 | TX11;
    CW.TxFIFORdSltEn[5]  = TX5 | TX7 | TX9 | TX10 | TX11;
    CW.TxFIFORdSltEn[6]  = TX10;
    CW.TxFIFORdSltEn[7]  = TX10;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 8; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
    CW.AACITB_SLOT0[1] = FV;
    CW.AACITB_SLOT0[2] = FV;
    CW.AACITB_SLOT0[3] = FV;
    CW.AACITB_SLOT0[4] = FV;
    CW.AACITB_SLOT0[5] = FV;
    CW.AACITB_SLOT0[6] = FV;
    CW.AACITB_SLOT0[7] = FV;
  
    /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
       about which of the SRC bits need to be set by the trickbox
       for each frame  */
    CW.AACITB_SLOT1[1] = SRC5 | SRC7 | SRC9 | SRC10 | SRC12;
    CW.AACITB_SLOT1[2] = SRC10 | SRC12;
    CW.AACITB_SLOT1[3] = SRC5 | SRC7 | SRC9;
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
    TxRx_FsPCLK_Test(7);
  }

/**********************************************************************/
/*************** Tx Only - CH & SLReg - Char mode - No SRC ************/
/**********************************************************************/
  /*
    The AACI is programmed for transmission-only in the Character mode.
    AACISLnTX (n = 1, 2 and 12) registers are also enabled for 
    transmission.
    No SRC bits are set in the incoming frames. Three data tests are 
    done under this category. The following parameters are varied for
    each test.
      o The number of slots enabled for transmission per channel
      o The number of slots enabled per transmitted frame.
      o TSIZE
      o Information about  which of the AACISLnTX (n = 1, 2, 12) 
        registers are to be loaded with new data for each frame 
      o Whether data for Slots 1, 2 and 12 are present in Channels AND
        Slot registers (as against data being present for these slots
        ONLY in Slot registers or ONLY in channels)

    The tests are repeated by programming the channels to transmit 
    data for different combinations of slots.
  */

  if (CmpctMod == 0x0)
  {
    C("Tx Only - CH & SLReg - Char mode - No SRC");
    C("Channel1Tx enabled and has slot 5");
    C("Channel2Tx enabled and has slot 2");
    C("AACISL1TX, AACISL12TX are enabled ");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[1] = TxSize[1] | AACI_TX5 | AACI_TEN;
    CW.DatTxCntlReg[2] = TxSize[2] | AACI_TX2 | AACI_TEN;
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX12;
  
    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1]  = 0x0;
    CW.TxRegWtSltEn[2]  = TX1 | TX12;
    CW.TxRegWtSltEn[3]  = TX12;
    CW.TxRegWtSltEn[4]  = TX1;
  
    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1]  = 0x0;
    CW.TxRegRdSltEn[2]  = TX1 | TX12;
    CW.TxRegRdSltEn[3]  = TX12;
    CW.TxRegRdSltEn[4]  = TX1;
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX2 | TX5;
    CW.TxFIFOWtSltEn[3]  = TX5;
    CW.TxFIFOWtSltEn[4]  = TX2;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX2 | TX5;
    CW.TxFIFORdSltEn[3]  = TX5;
    CW.TxFIFORdSltEn[4]  = TX2;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 5; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
    CW.AACITB_SLOT0[1] = FV;
    CW.AACITB_SLOT0[2] = FV;
    CW.AACITB_SLOT0[3] = FV;
    CW.AACITB_SLOT0[4] = FV;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  
    C("Channel1Tx enabled and has slot 6");
    C("Channel2Tx enabled and has slot 5");
    C("Channel3Tx enabled and has slot 4");
    C("Channel4Tx enabled and has slot 12");
    C("AACISL12TX are enabled ");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4) 
       register */
    CW.DatTxCntlReg[1] = TxSize[1] | AACI_TX6 | AACI_TEN;
    CW.DatTxCntlReg[2] = TxSize[2] | AACI_TX5 | AACI_TEN;
    CW.DatTxCntlReg[3] = TxSize[3] | AACI_TX4 | AACI_TEN;
    CW.DatTxCntlReg[4] = TxSize[4] | AACI_TX12 | AACI_TEN;
    CW.DatTxCntlReg[5] = AACI_TX12;
  
    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1]  = 0x0;
    CW.TxRegWtSltEn[2]  = TX12;
    CW.TxRegWtSltEn[3]  = 0x0;
    CW.TxRegWtSltEn[4]  = 0x0;
    CW.TxRegWtSltEn[5]  = 0x0;
  
    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1]  = 0x0;
    CW.TxRegRdSltEn[2]  = 0x0;
    CW.TxRegRdSltEn[3]  = 0x0;
    CW.TxRegRdSltEn[4]  = 0x0;
    CW.TxRegRdSltEn[5]  = TX12;
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX6 | TX5 | TX4 | TX12;
    CW.TxFIFOWtSltEn[3]  = TX6 | TX5 | TX4 | TX12;
    CW.TxFIFOWtSltEn[4]  = TX6 | TX5 | TX4 | TX12;
    CW.TxFIFOWtSltEn[5]  = 0x0;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX6 | TX5 | TX4 | TX12;
    CW.TxFIFORdSltEn[3]  = TX6 | TX5 | TX4 | TX12;
    CW.TxFIFORdSltEn[4]  = TX6 | TX5 | TX4 | TX12;
    CW.TxFIFORdSltEn[5]  = 0x0;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 6; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
    CW.AACITB_SLOT0[1] = FV;
    CW.AACITB_SLOT0[2] = FV;
    CW.AACITB_SLOT0[3] = FV;
    CW.AACITB_SLOT0[4] = FV;
    CW.AACITB_SLOT0[5] = FV;
  
    /* Perform a 5-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(5);
  
    C("Channel1Tx enabled and has slot 10");
    C("Channel2Tx enabled and has slot 6");
    C("Channel3Tx enabled and has slot 7");
    C("Channel4Tx enabled and has slot 9");
    C("AACISL1TX, AACISL2TX, AACISL12TX are enabled ");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4)
       register */
    CW.DatTxCntlReg[1] = TxSize[1] | AACI_TX10 | AACI_TEN;
    CW.DatTxCntlReg[2] = TxSize[2] | AACI_TX6 | AACI_TEN;
    CW.DatTxCntlReg[3] = TxSize[3] | AACI_TX7 | AACI_TEN;
    CW.DatTxCntlReg[4] = TxSize[4] | AACI_TX9 | AACI_TEN;
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;
  
    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1]  = 0x0;
    CW.TxRegWtSltEn[2]  = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[3]  = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[4]  = TX1 | TX2 | TX12;
  
    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1]  = 0x0;
    CW.TxRegRdSltEn[2]  = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[3]  = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[4]  = TX1 | TX2 | TX12;
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX6 | TX7 | TX9;
    CW.TxFIFOWtSltEn[3]  = TX6 | TX7 | TX9;
    CW.TxFIFOWtSltEn[4]  = TX6 | TX7 | TX9;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX6 | TX7 | TX9;
    CW.TxFIFORdSltEn[3]  = TX6 | TX7 | TX9;
    CW.TxFIFORdSltEn[4]  = TX6 | TX7 | TX9;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 5; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
    CW.AACITB_SLOT0[1] = FV | S1 | S2 | S5 | S7 | S11 | S12;
    CW.AACITB_SLOT0[2] = FV | S1 | S2 | S5 | S7 | S11 | S12;
    CW.AACITB_SLOT0[3] = FV | S1 | S2 | S5 | S7 | S11 | S12;
    CW.AACITB_SLOT0[4] = FV | S1 | S2 | S5 | S7 | S11 | S12;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);

/**********************************************************************/
/*************** Tx Only - CH & SLReg - Char mode - SRC ***************/
/**********************************************************************/
  /*
    The AACI is programmed for transmission-only in the Character mode.
    AACISLnTX (n = 1, 2 and 12) are also enabled for transmission.
    SRC bits are set in the incoming frames. Three data tests are 
    done under this category. The following parameters are varied for
    each test.
      o The number of slots enabled for transmission per channel
      o The number of slots enabled per transmitted frame.
      o TSIZE
      o SRC bit-pattern to be transmitted by the trickbox for each frame
      o Information about  which of the AACISLnTX (n = 1, 2, 12) 
        registers are to be loaded with new data for each frame 
      o Whether data for Slots 1, 2 and 12 are present in Channels AND
        Slot registers (as against data being present for these slots
        ONLY in Slot registers or ONLY in channels)

    The tests are repeated by programming the channels to transmit 
    data for different combinations of slots.

  */

    C("Tx Only - CH & SLReg - Char mode - SRC");
    C("Channel1Tx enabled and has slot 7");
    C("Channel2Tx enabled and has slot 5");
    C("Channel3Tx enabled and has slot 4");
    C("Channel4Tx enabled and has slot 1");
    C("AACISL1TX, AACISL2TX, AACISL12TX are enabled ");
    C("SRC bits set for multiple slots");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4) 
       register */
    CW.DatTxCntlReg[1] = TxSize[1] | AACI_TX7 | AACI_TEN;
    CW.DatTxCntlReg[2] = TxSize[2] | AACI_TX5 | AACI_TEN;
    CW.DatTxCntlReg[3] = TxSize[3] | AACI_TX4 | AACI_TEN;
    CW.DatTxCntlReg[4] = TxSize[4] | AACI_TX1 | AACI_TEN;
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;
  
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
    CW.TxFIFOWtSltEn[2]  = TX1 | TX4 | TX5 | TX7;
    CW.TxFIFOWtSltEn[3]  = TX1 | TX4;
    CW.TxFIFOWtSltEn[4]  = TX7;
    CW.TxFIFOWtSltEn[5]  = TX5;
    CW.TxFIFOWtSltEn[6]  = 0x0;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX1 | TX4;
    CW.TxFIFORdSltEn[3]  = TX1 | TX7;
    CW.TxFIFORdSltEn[4]  = TX5;
    CW.TxFIFORdSltEn[5]  = TX4 | TX7;
    CW.TxFIFORdSltEn[6]  = TX5;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 7; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
    CW.AACITB_SLOT0[1] = FV;
    CW.AACITB_SLOT0[2] = FV;
    CW.AACITB_SLOT0[3] = FV;
    CW.AACITB_SLOT0[4] = FV;
    CW.AACITB_SLOT0[5] = FV;
    CW.AACITB_SLOT0[6] = FV;
  
    /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
       about which of the SRC bits need to be set by the trickbox
       for each frame  */
    CW.AACITB_SLOT1[1] = SRC5 | SRC7;
    CW.AACITB_SLOT1[2] = SRC4 | SRC5;
    CW.AACITB_SLOT1[3] = SRC4 | SRC7;
    CW.AACITB_SLOT1[4] = SRC5;
    CW.AACITB_SLOT1[5] = 0x0;
    CW.AACITB_SLOT1[6] = 0x0;

    /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
       version of the SRC bits transmitted by the trickbox. This is
       used for computational purposes. */
    for (i = 1; i < 7; i++)
    {
      CW.RemapedSRC[i] = RemapSR(i);
    }

    /* Perform a 6-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(6);

    C("Channel1Tx enabled and has slot 10");
    C("Channel2Tx enabled and has slot 6");
    C("Channel3Tx enabled and has slot 12");
    C("Channel4Tx enabled and has slot 9");
    C("AACISL12TX are enabled ");
    C("SRC bits set for multiple slots");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4) 
       register */
    CW.DatTxCntlReg[1] = TxSize[1] | AACI_TX10 | AACI_TEN;
    CW.DatTxCntlReg[2] = TxSize[2] | AACI_TX6 | AACI_TEN;
    CW.DatTxCntlReg[3] = TxSize[3] | AACI_TX12 | AACI_TEN;
    CW.DatTxCntlReg[4] = TxSize[4] | AACI_TX9 | AACI_TEN;
    CW.DatTxCntlReg[5] = AACI_TX12;
  
    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1]  = 0x0;
    CW.TxRegWtSltEn[2]  = TX12;
    CW.TxRegWtSltEn[3]  = 0x0;
    CW.TxRegWtSltEn[4]  = 0x0;
    CW.TxRegWtSltEn[5]  = 0x0;
    CW.TxRegWtSltEn[6]  = 0x0;
  
    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1]  = 0x0;
    CW.TxRegRdSltEn[2]  = 0x0;
    CW.TxRegRdSltEn[3]  = 0x0;
    CW.TxRegRdSltEn[4]  = 0x0;
    CW.TxRegRdSltEn[5]  = 0x0;
    CW.TxRegRdSltEn[6]  = TX12;
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX6 | TX9 | TX10 | TX12;
    CW.TxFIFOWtSltEn[3]  = TX6;
    CW.TxFIFOWtSltEn[4]  = TX10;
    CW.TxFIFOWtSltEn[5]  = TX12;
    CW.TxFIFOWtSltEn[6]  = TX9;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX6;
    CW.TxFIFORdSltEn[3]  = TX10;
    CW.TxFIFORdSltEn[4]  = TX6 | TX10 | TX12;
    CW.TxFIFORdSltEn[5]  = TX9 | TX12;
    CW.TxFIFORdSltEn[6]  = TX9;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 7; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox */
    CW.AACITB_SLOT0[1] = FV;
    CW.AACITB_SLOT0[2] = FV;
    CW.AACITB_SLOT0[3] = FV;
    CW.AACITB_SLOT0[4] = FV;
    CW.AACITB_SLOT0[5] = FV;
    CW.AACITB_SLOT0[6] = FV;
  
    /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
       about which of the SRC bits need to be set by the trickbox
       for each frame  */
    CW.AACITB_SLOT1[1] = SRC9 | SRC10 | SRC12;
    CW.AACITB_SLOT1[2] = SRC6 | SRC9 | SRC12;
    CW.AACITB_SLOT1[3] = SRC9 | SRC11;
    CW.AACITB_SLOT1[4] = SRC6;
    CW.AACITB_SLOT1[5] = 0x0;
    CW.AACITB_SLOT1[6] = 0x0;

    /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
       version of the SRC bits transmitted by the trickbox. This is
       used for computational purposes. */
    for (i = 1; i < 7; i++)
    {
      CW.RemapedSRC[i] = RemapSR(i);
    }

    /* Perform a 6-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(6);

    C("Channel1Tx enabled and has slot 12");
    C("Channel2Tx enabled and has slot 7");
    C("Channel3Tx enabled and has slot 8");
    C("Channel4Tx enabled and has slot 10");
    C("AACISL1TX, AACISL2TX, AACISL12TX are enabled ");
    C("SRC bits set for multiple slots");
   
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign CW.DatTxCntlReg[n] (n = channel number) with the 
       value to be programmed into the AACITXCRn (n = 1 to 4) 
       register */
    CW.DatTxCntlReg[1] = TxSize[1] | AACI_TX12 | AACI_TEN;
    CW.DatTxCntlReg[2] = TxSize[2] | AACI_TX7 | AACI_TEN;
    CW.DatTxCntlReg[3] = TxSize[3] | AACI_TX8 | AACI_TEN;
    CW.DatTxCntlReg[4] = TxSize[4] | AACI_TX10 | AACI_TEN;
    CW.DatTxCntlReg[5] = AACI_TX1 | AACI_TX2 | AACI_TX12;
  
    /* Assign CW.TxRegWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the 
       AACISLnTX (n = 1, 2, 12) registers for each frame */
    CW.TxRegWtSltEn[1]  = 0x0;
    CW.TxRegWtSltEn[2]  = TX1 | TX2 | TX12;
    CW.TxRegWtSltEn[3]  = TX1 | TX2;
    CW.TxRegWtSltEn[4]  = TX1 | TX2;
    CW.TxRegWtSltEn[5]  = TX1 | TX2 | TX12;
  
    /* Assign CW.TxRegRdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from the AACISLnTX 
       (n = 1, 2, 12) registers (data could be from either the Channels
       or from the AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxRegRdSltEn[1]  = 0x0;
    CW.TxRegRdSltEn[2]  = TX1 | TX2;
    CW.TxRegRdSltEn[3]  = TX1 | TX2;
    CW.TxRegRdSltEn[4]  = TX1 | TX2 | TX12;
    CW.TxRegRdSltEn[5]  = TX1 | TX2 | TX12;
  
    /* Assign CW.TxFIFOWtSltEn[n] (n = Frame number) with information 
       about slots for which data need to be written into the channels
       for each frame */
    CW.TxFIFOWtSltEn[1]  = 0x0;
    CW.TxFIFOWtSltEn[2]  = TX7 | TX8 | TX10;
    CW.TxFIFOWtSltEn[3]  = TX10;
    CW.TxFIFOWtSltEn[4]  = TX7;
    CW.TxFIFOWtSltEn[5]  = TX8;
  
    /* Assign CW.TxFIFORdSltEn[n] (n = Frame number) with information
       about which of the slot data originated from Channel Tx FIFOs of
       the AACI (data could be from either the Channels or from the
       AACISLnTX (n = 1, 2, 12) registers) */ 
    CW.TxFIFORdSltEn[1]  = 0x0;
    CW.TxFIFORdSltEn[2]  = TX10;
    CW.TxFIFORdSltEn[3]  = TX7 | TX10;
    CW.TxFIFORdSltEn[4]  = TX8;
    CW.TxFIFORdSltEn[5]  = TX7 | TX8;
  
    /* The expected Slot0 from the AACI is assigned to the
       CW.AACI_SLOT0[n] (n = Frame number) */
    for (i = 1; i < 6; i++)
    {
      CW.AACI_SLOT0[i] = Calculate_AaciSlot0(i);
    }
  
    /* CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox */
    CW.AACITB_SLOT0[1] = FV | S1 | S2 | S5 | S7 | S11 | S12;
    CW.AACITB_SLOT0[2] = FV | S1 | S2 | S5 | S7 | S11 | S12;
    CW.AACITB_SLOT0[3] = FV | S1 | S2 | S5 | S7 | S11 | S12;
    CW.AACITB_SLOT0[4] = FV | S1 | S2 | S5 | S7 | S11 | S12;
    CW.AACITB_SLOT0[5] = FV;
  
    /* Assign CW.AACITB_SLOT1[n] (n = Frame number) with information
       about which of the SRC bits need to be set by the trickbox
       for each frame  */
    CW.AACITB_SLOT1[1] = SRC7 | SRC8 | SRC12;
    CW.AACITB_SLOT1[2] = SRC8 | SRC12;
    CW.AACITB_SLOT1[3] = SRC7;
    CW.AACITB_SLOT1[4] = 0x0;
    CW.AACITB_SLOT1[5] = 0x0;

    /* Assign CW.RemapedSRC[n] (n = Frame number) with the inverted
       version of the SRC bits transmitted by the trickbox. This is
       used for computational purposes. */
    for (i = 1; i < 6; i++)
    {
      CW.RemapedSRC[i] = RemapSR(i);
    }

    /* Perform a 5-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(5);
  }
}

/*************************** End of Tx_Call.c *************************/
