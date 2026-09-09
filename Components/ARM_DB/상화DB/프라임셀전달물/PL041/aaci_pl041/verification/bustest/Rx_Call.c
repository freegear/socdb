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
-- File Name              : Rx_Call.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose : 
--           This function verifies the receive functionality of the
--           AACI.It is called only when PCLK is faster than or has the
--           same frequency as AACIBITCLK.
--
-- --=================================================================*/

/**********************************************************************/
/*** For more information on the AACI, please refer to PL041 AMBA   ***/
/*** AACI Block Specification                                       ***/
/**********************************************************************/

/**********************************************************************/
/*************************** Rx_Call **********************************/
/**********************************************************************/
void Rx_Call(int32 CmpctMod)
{
  /*
    Summary: Rx_Call
    ================
    This function is called only when PCLK is faster than or has the 
    same frequency as AACIBITCLK.

    This function calls the TxRx_FsPCLK_Test routine which programs the
    Aaci according to parameters passed to it by the calling function.
    These parameters are indirectly passed by updating the CW 
    (ControlWords) structure in this function (Rx_Call).
    These parameters determine the following :
      - Slot0 to be transmitted by the Trickbox
      - Register fields for the AACIRXCRn (n = 1 to 4) registers
      - Information regarding which of the Slot registers need to
        be enabled for data reception for each frame

    o This function also verifies data reception by the AACI for
      a range of RSIZE values in Compact mode and non-Compact mode

    o The reception tests are split into five major categories with 
      each category containing several sub-tests. These five categories 
      are derived from the following four fields.
      
      <Data Direction> + <Data Src/Dest> + <FIFO mode> + <SRC mode>

      Data Direction -> Rx Only
      Data Src/Dest  -> CH/SLReg/(Both CH and SLReg) 
      FIFO mode      -> FIFO / Char
      SRC            -> SRC / No SRC

      The five categories of reception-tests are :
      1. Rx Only - CH - FIFO mode
      2. Rx Only - CH - Char mode
      3. Rx Only - SLReg
      4. Rx Only - CH & SLReg - FIFO mode
      5. Rx Only - CH & SLReg - Char mode

      Sub-tests for each of the above categories are invoked with
      a range of values of RSIZE. Only sub-tests involving even number
      of slots per channel are run in Compact mode. 
  */

  int i;

/**********************************************************************/
/***************** Rx Only - CH - FIFO mode ***************************/
/**********************************************************************/
  /*
    AACI is programmed for reception-only in the FIFO mode. Three data 
    tests are done under this category. The following parameters are 
    varied for each test :
      o The number of slots enabled for reception per channel
      o The number of slots enabled per received frame.
      o Slot0 to be transmitted by the trickbox for each frame
      o RSIZE 

    The tests are repeated by programming the channels to store data for
    different combinations of slots.

    The test cases having an even number of slots enabled per channel 
    are again executed with the CM bit set in the AACIRXCRn (n = 1 to 4)
    register.

  */

  C(" Rx Only - CH - FIFO mode");
  C("Channel3Rx enabled and has slots 1, 2, 3, 4, 7, 10, 11 and 12");

  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[3] = AACI_FEN | RxSize[3] | CmpctMod | AACI_RX1 |
                       AACI_RX2 | AACI_RX3 | AACI_RX4 | AACI_RX7 |
                       AACI_RX10 | AACI_RX11 | AACI_RX12 | AACI_REN;

  /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S9 | S10 |
                       S11 | S12;
  CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S9 | S10 |
                       S11 | S12;
  CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S9 | S10 |
                       S11 | S12;
  CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S9 | S10 |
                       S11 | S12;

  /* Perform a 4-frame data transfer with the above settings */
  TxRx_FsPCLK_Test(4);

  C("Channel1Rx enabled and has slots 2, 8, 9 and 10");
  C("Channel2Rx enabled and has slots 1, 11 and 12");
  C("Channel4Rx enabled and has slots 3, 4, 5, 6 and 7");

  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign the CW.DatRxCntlReg[n] (n = channel number) with
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[1] = AACI_FEN | RxSize[1] | CmpctMod | AACI_RX2 |
                       AACI_RX8 | AACI_RX9 | AACI_RX10 | AACI_REN;
  CW.DatRxCntlReg[2] = AACI_FEN | RxSize[2] | AACI_RX1 | AACI_RX11 |
                       AACI_RX12 | AACI_REN;
  CW.DatRxCntlReg[4] = AACI_FEN | RxSize[4] | AACI_RX3 | AACI_RX4 |
                       AACI_RX5 | AACI_RX6 | AACI_RX7 | AACI_REN;

  /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;
  CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;
  CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;
  CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;

  /* Perform a 4-frame data transfer with the above settings */
  TxRx_FsPCLK_Test(4);

  if (CmpctMod == 0x0)
  {
    C("Channel1Rx enabled and has slots 2, 3 and 4");
    C("Channel2Rx enabled and has slots 7, 8 and 9");
    C("Channel3Rx enabled and has slots 10, 11 and 12");
    C("Channel4Rx enabled and has slots 1, 5 and 6");
  
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[1] = AACI_FEN | RxSize[1] | AACI_RX2 | AACI_RX3 |
                         AACI_RX4 | AACI_REN;
    CW.DatRxCntlReg[2] = AACI_FEN | RxSize[2] | AACI_RX7 | AACI_RX8 |
                         AACI_RX9 | AACI_REN;
    CW.DatRxCntlReg[3] = AACI_FEN | RxSize[3] | AACI_RX10 | AACI_RX11 |
                         AACI_RX12 | AACI_REN;
    CW.DatRxCntlReg[4] = AACI_FEN | RxSize[4] | AACI_RX1 | AACI_RX5 |
                         AACI_RX6 | AACI_REN;
  
    /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S10 | S11 | S12;
    CW.AACITB_SLOT0[2] = FV | S2 | S3 | S4 | S5 | S6 | S9 | S10 | S11;
    CW.AACITB_SLOT0[3] = FV | S1 | S3 | S8 | S12;
    CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S10 | S11 | S12;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  }
  
/**********************************************************************/
/***************** Rx Only - CH - Char mode ***************************/
/**********************************************************************/
  /*
    The AACI is programmed for reception-only in Character mode. Three 
    data tests are done under this category. The following parameters 
    are varied for each test under this category.
      o The number of slots enabled for reception per channel
      o Slot0 to be transmitted by the trickbox for each frame
      o RSIZE

    The tests are repeated by programming the channels to store data for
    different combinations of slots.

    Also, the AACI is programmed with the AACIRXCRn (n = 1 to 4) 
    enabled with more than one slot in Character mode. This is to verify
    that the AACI prevents overwriting of data.

  */

  if (CmpctMod == 0x0)
  {
    C("Rx Only - CH - Char mode");
    C("Channel1Rx enabled and has slots 7, 8 and 9");
  
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[1] = RxSize[1] | AACI_RX7 | AACI_RX8 | AACI_RX9 |
                         AACI_REN;
  
    /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S7;
    CW.AACITB_SLOT0[2] = FV | S8 | S9;
    CW.AACITB_SLOT0[3] = FV | S9;
    CW.AACITB_SLOT0[4] = FV | S7 | S8;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  
    C("Channel2Rx enabled and has slot 4");
    C("Channel3Rx enabled and has slot 6");
    C("Channel4Rx enabled and has slot 12");
  
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[2] = RxSize[2] | AACI_RX4 | AACI_REN;
    CW.DatRxCntlReg[3] = RxSize[3] | AACI_RX6 | AACI_REN;
    CW.DatRxCntlReg[4] = RxSize[4] | AACI_RX12 | AACI_REN;
  
    /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S4 | S12;
    CW.AACITB_SLOT0[2] = FV | S4 | S6 | S12;
    CW.AACITB_SLOT0[3] = FV;
    CW.AACITB_SLOT0[4] = FV | S6;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  
    C("Channel1Rx enabled and has slots 1, 5, 6");
    C("Channel2Rx enabled and has slots 2, 3, 4");
    C("Channel3Rx enabled and has slots 10, 11, 12");
    C("Channel4Rx enabled and has slots 7, 8, 9");
  
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[1] = RxSize[1] | AACI_RX1 | AACI_RX5 | AACI_RX6 |
                         AACI_REN;
    CW.DatRxCntlReg[2] = RxSize[2] | AACI_RX2 | AACI_RX3 | AACI_RX4 |
                         AACI_REN;
    CW.DatRxCntlReg[3] = RxSize[3] | AACI_RX10 | AACI_RX11 |
                         AACI_RX12 | AACI_REN;
    CW.DatRxCntlReg[4] = RxSize[4] | AACI_RX7 | AACI_RX8 | AACI_RX9 |
                         AACI_REN;
  
    /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S10 | S11 | S12;
    CW.AACITB_SLOT0[2] = FV | S2 | S3 | S4 | S5 | S6 | S9 | S10 | S11;
    CW.AACITB_SLOT0[3] = FV | S1 | S3 | S8 | S12;
    CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S10 | S11 | S12;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  }

/**********************************************************************/
/********************** Rx Only - SLReg *******************************/
/**********************************************************************/
  /*
    The AACI is programmed for reception-only through the AACISLnRX 
    (n = 1, 2 and 12) registers. Three data tests are done under this 
    category. The following parameters are varied for each test under 
    this category.
      o Information about  which of the AACISLnRX (n = 1, 2, 12) 
        register is to be enabled for each frame
      o The number of slots enabled per received frame.
      o Slot0 to be transmitted by the trickbox for each frame

  */

  if (CmpctMod == 0x0)
  {
    C("Rx Only - SLReg");
    C("AACISL12RX enabled");
  
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[5] = AACI_RX12;
  
    /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S12;
    CW.AACITB_SLOT0[2] = FV;
    CW.AACITB_SLOT0[3] = FV | S12;
    CW.AACITB_SLOT0[4] = FV | S12;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S1 | S2 | S12;
    CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S10 | S11 | S12;
    CW.AACITB_SLOT0[3] = FV | S1 | S2 | S12;
    CW.AACITB_SLOT0[4] = FV | S1 | S2 | S12;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
    C("Rx Slot Register Enabled between Frames ");
  
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* Assign the CW.RxRegSltEn[n] (n = Frame number) with information 
       about  which of the AACISLnRX (n = 1, 2, 12) register to be
       enabled for each frame */
    CW.RxRegSltEn[1]   = RX1 | RX2 | RX12;
    CW.RxRegSltEn[2]   = RX2 | RX2 | RX12;
    CW.RxRegSltEn[3]   = RX1 | RX12;
    CW.RxRegSltEn[4]   = RX1 | RX12;
  
    /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S1 | S2 | S12;
    CW.AACITB_SLOT0[2] = FV | S1;
    CW.AACITB_SLOT0[3] = FV | S2;
    CW.AACITB_SLOT0[4] = FV | S2 | S12;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  }

/**********************************************************************/
/***************** Rx Only - CH & SLReg - FIFO mode *******************/
/**********************************************************************/
  /*
    The AACI is programmed for reception-only in the FIFO mode. 
    AACISLnRX (n = 1, 2 and 12) are also enabled for reception. Three 
    data tests are done under this category. The following parameters 
    are varied for each test under this category.
      o The number of slots enabled per Rx channel
      o Information about which of the AACISLnRX (n = 1, 2, 12) 
        register is to be enabled for each frame
      o The number of slots enabled per received frame.
      o Slot0 to be transmitted by the trickbox for each frame 
      o RSIZE 

    The tests are repeated by programming the channels to store data for
    different combinations of slots.

    The test cases having an even number of slots enabled per channel
    are again executed with the CM bit set in the AACIRXCRn (n = 1 to 4)
    register.

  */
  if (CmpctMod == 0x0)
  { 
    C("Rx Only - CH & SLReg - FIFO mode");
    C("Channel2Rx enabled and has slots 1, 2, 3, 4, 7, 10, 11 and 12");
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[2] = AACI_FEN | RxSize[2] | AACI_RX1 | AACI_RX2 |
                         AACI_RX3 | AACI_RX4 | AACI_RX7 | AACI_RX10 |
                         AACI_RX11 | AACI_RX12 | AACI_REN;
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S9 | S10 |
                         S11 | S12;
    CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S9 | S10 |
                         S11 | S12;
    CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S9 | S10 |
                         S11 | S12;
    CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S7 | S8 | S9 | S10 |
                         S11 | S12;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  }

  C("Channel1Rx enabled and has slots 1, 11 and 12");
  C("Channel2Rx enabled and has slots 2, 8, 9 and 10");
  C("Channel3Rx enabled and has slots 3, 4, 5, 6 and 7");
  C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");

  /* Initialize the ControlWord structure to default values */
  InitCntlWrd();

  /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
     the value to be programmed into the AACIRXCRn (n = 1 to 4)
     register */
  CW.DatRxCntlReg[1] = AACI_FEN | RxSize[1] | AACI_RX1 | AACI_RX11 |
                       AACI_RX12 | AACI_REN;
  CW.DatRxCntlReg[2] = AACI_FEN | RxSize[2] | CmpctMod | AACI_RX2 |
                       AACI_RX8 | AACI_RX9 | AACI_RX10 | AACI_REN;
  CW.DatRxCntlReg[3] = AACI_FEN | RxSize[3] | AACI_RX3 | AACI_RX4 |
                       AACI_RX5 | AACI_RX6 | AACI_RX7 | AACI_REN;
  CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;

  /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
     slot0 to be transmitted by the trickbox for each frame */
  CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;
  CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;
  CW.AACITB_SLOT0[3] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;
  CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                       S9 | S10 | S11 | S12;

  /* Perform a 4-frame data transfer with the above settings */
  TxRx_FsPCLK_Test(4);

  if (CmpctMod == 0x0)
  {
    C("Channel1Rx enabled and has slots 10, 11 and 12");
    C("Channel2Rx enabled and has slots 7, 8 and 9");
    C("Channel3Rx enabled and has slots 1, 5 and 6");
    C("Channel4Rx enabled and has slots 2, 3 and 4");
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
    C("Rx Slot Register Enabled between Frames ");
  
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[1] = AACI_FEN | RxSize[1] | AACI_RX10 | AACI_RX11 |
                         AACI_RX12 | AACI_REN;
    CW.DatRxCntlReg[2] = AACI_FEN | RxSize[2] | AACI_RX7 | AACI_RX8 |
                         AACI_RX9 | AACI_REN;
    CW.DatRxCntlReg[3] = AACI_FEN | RxSize[3] | AACI_RX1 | AACI_RX5 |
                         AACI_RX6 | AACI_REN;
    CW.DatRxCntlReg[4] = AACI_FEN | RxSize[4] | AACI_RX2 | AACI_RX3 |
                         AACI_RX4 | AACI_REN;
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* Assign the CW.RxRegSltEn[n] (n = Frame number) with information 
       about  which of the AACISLnRX (n = 1, 2, 12) register to be
       enabled for each frame */
    CW.RxRegSltEn[1]   = RX1 | RX2 | RX12;
    CW.RxRegSltEn[2]   = RX2 | RX2 | RX12;
    CW.RxRegSltEn[3]   = RX1 | RX2;
    CW.RxRegSltEn[4]   = 0x0;
  
    /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S10 | S11 | S12;
    CW.AACITB_SLOT0[2] = FV | S2 | S3 | S4 | S5 | S6 | S9 | S10 | S11;
    CW.AACITB_SLOT0[3] = FV | S1 | S3 | S8 | S12;
    CW.AACITB_SLOT0[4] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
                         S9 | S10 | S11 | S12;
   
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  }
  
/**********************************************************************/
/***************** Rx Only - CH & SLReg - Char mode *******************/
/**********************************************************************/
  /*
    The AACI is programmed for reception-only in Character mode. 
    AACISLnRX (n = 1, 2 and 12) are also enabled for reception. 
    Six data tests are done under this category. The following 
    parameters are varied for each test under this category.
      o Information about which of the AACISLnTX (n = 1, 2, 12) 
        register is to be loaded with new data for each frame 
      o Information about  which of the AACISLnTX (n = 1, 2, 12) 
        register is to be enabled for each frame
      o The number of slots enabled per received frame.
      o Slot0 to be transmitted by the trickbox for each frame
      o RSIZE 

    The tests are repeated by programming the channels to store data for
    different combinations of slots.

    Also, the AACI is programmed with the AACIRXCRn (n = 1 to 4)
    enabled with more than one slot in Character mode. This is to verify
    that the AACI prevents overwriting of data.

    The test cases having an even number of slots enabled per channel
    are again executed with the CM bit set in the AACIRXCRn (n = 1 to 4)
    register.

  */

  if (CmpctMod == 0x0)
  {
    C("Rx Only - CH & SLReg - Char mode");
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[1] = RxSize[1] | AACI_REN;
    CW.DatRxCntlReg[2] = RxSize[2] | AACI_REN;
    CW.DatRxCntlReg[3] = RxSize[3] | AACI_REN;
    CW.DatRxCntlReg[4] = RxSize[4] | AACI_REN;
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = 0x0;
    CW.AACITB_SLOT0[2] = FV;
    CW.AACITB_SLOT0[3] = Calculate_TrSlot0();
    CW.AACITB_SLOT0[4] = Calculate_TrSlot0();
    CW.AACITB_SLOT0[5] = Calculate_TrSlot0();
    CW.AACITB_SLOT0[6] = Calculate_TrSlot0();

    /* Perform a 6-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(6);
  
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[1] = RxSize[1] | AACI_REN;
    CW.DatRxCntlReg[2] = RxSize[2] | AACI_REN;
    CW.DatRxCntlReg[3] = RxSize[3] | AACI_REN;
    CW.DatRxCntlReg[4] = RxSize[4] | AACI_REN;
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S1;
    CW.AACITB_SLOT0[2] = FV | S2;
    CW.AACITB_SLOT0[3] = FV | S1 | S2 | S12;
    CW.AACITB_SLOT0[4] = FV | S2 | S12;

    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
    C("Rx Slot Register Enabled between Frames");
  
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[1] = RxSize[1] | AACI_REN;
    CW.DatRxCntlReg[2] = RxSize[2] | AACI_REN;
    CW.DatRxCntlReg[3] = RxSize[3] | AACI_REN;
    CW.DatRxCntlReg[4] = RxSize[4] | AACI_REN;
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* Assign the CW.RxRegSltEn[n] (n = Frame number) with information 
       about  which of the AACISLnRX (n = 1, 2, 12) register to be
       enabled for each frame */
    CW.RxRegSltEn[1]   = RX1;
    CW.RxRegSltEn[2]   = RX2 | RX12;
    CW.RxRegSltEn[3]   = RX1 | RX2;
    CW.RxRegSltEn[4]   = RX1 | RX12;
  
    /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S1 | S2 | S12;
    CW.AACITB_SLOT0[2] = FV | S1 | S2 | S12;
    CW.AACITB_SLOT0[3] = FV | S1 | S2 | S12;
    CW.AACITB_SLOT0[4] = FV | S1 | S2 | S12;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  
    C("Channel1Rx enabled and has slots 1, 2 and 12");
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[1] = RxSize[1] | AACI_REN | AACI_RX1 | AACI_RX2 |
                         AACI_RX12;
    CW.DatRxCntlReg[2] = RxSize[2] | AACI_REN;
    CW.DatRxCntlReg[3] = RxSize[3] | AACI_REN;
    CW.DatRxCntlReg[4] = RxSize[4] | AACI_REN;
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S12;
    CW.AACITB_SLOT0[2] = FV | S1 | S12;
    CW.AACITB_SLOT0[3] = FV | S2;
    CW.AACITB_SLOT0[4] = FV | S1 | S2;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  
    C("Channel4Rx enabled and has slots 1, 2 and 12");
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[1] = RxSize[1] | AACI_REN;
    CW.DatRxCntlReg[2] = RxSize[2] | AACI_REN | AACI_RX1;
    CW.DatRxCntlReg[3] = RxSize[3] | AACI_REN | AACI_RX2;
    CW.DatRxCntlReg[4] = RxSize[4] | AACI_REN | AACI_RX12;
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = FV | S2 | S12;
    CW.AACITB_SLOT0[2] = FV | S1 | S2 | S12;
    CW.AACITB_SLOT0[3] = FV | S1 | S2;
    CW.AACITB_SLOT0[4] = FV | S12;
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  
    C("Channel1Rx enabled and has slots 2, 3, 4");
    C("Channel2Rx enabled and has slots 1, 5, 6");
    C("Channel3Rx enabled and has slots 7, 8, 9");
    C("Channel4Rx enabled and has slots 10, 11, 12");
    C("AACISL1RX, AACISL2RX, AACISL12RX are enabled");
  
    /* Initialize the ControlWord structure to default values */
    InitCntlWrd();
  
    /* Assign the CW.DatRxCntlReg[n] (n = channel number) with 
       the value to be programmed into the AACIRXCRn (n = 1 to 4)
       register */
    CW.DatRxCntlReg[1] = RxSize[1] | AACI_REN | AACI_RX2 | AACI_RX3 |
                         AACI_RX4;
    CW.DatRxCntlReg[2] = RxSize[2] | AACI_REN | AACI_RX1 | AACI_RX5 |
                         AACI_RX6;
    CW.DatRxCntlReg[3] = RxSize[3] | AACI_REN | AACI_RX7 | AACI_RX8 |
                         AACI_RX9;
    CW.DatRxCntlReg[4] = RxSize[4] | AACI_REN | AACI_RX10 | AACI_RX11 |
                         AACI_RX12;
    CW.DatRxCntlReg[5] = AACI_RX1 | AACI_RX2 | AACI_RX12;
  
    /* The CW.AACITB_SLOT0[n] (n = Frame number) is assigned with the
       slot0 to be transmitted by the trickbox for each frame */
    CW.AACITB_SLOT0[1] = Calculate_TrSlot0();
    CW.AACITB_SLOT0[2] = FV | S1 | S2 | S3 | S4 | S5 | S6 | S9 | S10 |
                         S11;
    CW.AACITB_SLOT0[3] = FV | S1 | S3 | S8 | S12;
    CW.AACITB_SLOT0[4] = Calculate_TrSlot0();
  
    /* Perform a 4-frame data transfer with the above settings */
    TxRx_FsPCLK_Test(4);
  }
}

/*************************** End of Rx_Call.c *************************/
