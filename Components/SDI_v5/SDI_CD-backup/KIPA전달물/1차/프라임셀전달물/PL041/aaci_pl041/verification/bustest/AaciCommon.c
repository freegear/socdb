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
-- File Name              : AaciCommon.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This section contains the global variables and common
--           functions used by other functions
--
-- --=================================================================*/

/**********************************************************************/
/************************** GLOBAL CONSTANTS **************************/
/**********************************************************************/
int32 Masks[] = { 0x00, 0x01, 0x03, 0x07,  0x0f, 0x1f, 0x3f, 0x7f, 0xff,
                  0x1ff, 0x3ff, 0x7ff, 0xfff,0x1fff,0x3fff, 0x7fff,
                  0xffff, 0x1ffff, 0x3ffff,0x7ffff,0xfffff,0x1fffff };

int32 RMasks[] = { 0x00000, 0x80000, 0xc0000, 0xe0000, 0xf0000, 0xf8000,
                   0xfc000, 0xfe000, 0xff000, 0xff800, 0xffc00, 0xffe00,
                   0xfff00, 0xfff80, 0xfffc0, 0xfffe0, 0xffff0, 0xffff8,
                   0xffffc, 0xffffe, 0xfffff};

int32 AACIDR[] = {0x0, AACIDR1, AACIDR2, AACIDR3, AACIDR4 };

static unsigned int TimeOut ;
static unsigned int RXW_Value ;

int WriteData[] = {0x11226644, 0x12345678, 0x33333333, 0x98765432,
                   0x01010101, 0x02020202, 0x03030303, 0x04040404,
                   0x00001111, 0x11110000, 0x00009999, 0x99990000,
                   0x05050505, 0x55555555, 0x99999999, 0x77777777};

int Channel_1 = 1, Channel_2 = 2, Channel_3 = 3, Channel_4 = 4;

int DMAENABLE = 1, DMADISABLE = 0;

int Mask_Size[] = {0x0FFFF, 0x3FFFF, 0xFFFFF, 0x0FFF};

int Shift_Count[] = {4, 2, 0, 8};

int32 SlotArr[] = {0, AACI_RX1, AACI_RX2, AACI_RX3, AACI_RX4, AACI_RX5,
                   AACI_RX6, AACI_RX7, AACI_RX8, AACI_RX9, AACI_RX10,
                   AACI_RX11, AACI_RX12 };

/**********************************************************************/
/************************ Structure Definitions ***********************/
/**********************************************************************/
struct ControlWords
{
  /* Expected Slot0 from the AACI for each frame. Used to compare with
     Slot 0 data read from the Rx FIFO of the trickbox */
  int32 AACI_SLOT0[15];

  /* Slot0 to be transmitted by the trickbox */
  int32 AACITB_SLOT0[15];

  /* Slot1 (including SRC bit information) to be transmitted by the 
     trickbox */
  int32 AACITB_SLOT1[15];

  /* Register fields for the AACITXCRn (n=1 to 4) register.
     Indices 1 to 4 of this variable are associated with the four
     channels. Index 5 is associated with the AACISLnTX (n = 1, 2, 12) 
     registers */
  int32 DatTxCntlReg[6];

  /* Register fields for the AACIRXCRn (n=1 to 4) register. 
     Indices 1 to 4 of this variable are associated with the four
     channels. Index 5 is associated with the AACISLnRX (n = 1, 2, 12) 
     registers */
  int32 DatRxCntlReg[6];

  /* Information about whether sufficient data is to be written into
     the channels. Channels with insufficient data/no data are expected 
     not to contribute to the data transmitted on the next frame. */
  int FrmInVldCh[5];

  /*  Number of invalid frames to be transmitted by the AACI */
  int NoInVldFrm;

  /* It indicates the frame number (say, 3rd or 4th frame) that is to be
     transmitted as invalid frame by the AACI */
  int StartInVldFrm;

  /* Complement of  SRC bits set in Slot1 of the trickbox */
  int32 RemapedSRC[15];

  /* Information about slots for which data need to be written into the
     channels for each frame */
  int32 TxFIFOWtSltEn[15];

  /* Information about which of the slot data originated from Channel 
     Tx FIFOs of the AACI (data could be from either the Channels or 
     from the AACISLnTX (n = 1, 2, 12) registers) */
  int32 TxFIFORdSltEn[15];

  /* Information about slots for which data need to be written into the
     AACISLnTX (n = 1, 2, 12) registers for each frame */
  int32 TxRegWtSltEn[15];

  /* Information about which of the slot data originated from the 
     AACISLnTX (n = 1, 2, 12) registers (data could be from either the 
     Channels or from the AACISLnTX (n = 1, 2, 12) registers) */
  int32 TxRegRdSltEn[15];

  /* Information about which of the AACISLnRX (n = 1, 2, 12) registers 
     are to be enabled for each frame */
  int32 RxRegSltEn[15];

  /* Information about which of the AACISLnTX (n = 1, 2, 12) registers 
     need to be enabled for each frame */
  int32 TxRegSltEn[15];

  /* Indicates the secondary CODEC to be accessed */
  int32 SecCODEC;

  /* Correction factor used to point to the correct element in the 
     expected-value array. Specifically, this factor is required to 
     test the dependency of Slot 2 data on Slot 1 data. */
  int Slt2Corcfct;
};

struct ControlWords CW;
int32 TxSize[5];
int32 RxSize[5];

/**********************************************************************/
/**************************** nBITCLKRST ******************************/
/**********************************************************************/
void nBITCLKRST(void)
{
  /*
    Summary: nBITCLKRST
    ===================
    This function asserts and de-asserts the nAACIBITCLKRST input to
    the AACI. The Trickbox ensures that the nAACIBITCLKRST input to the
    AACI is asserted asynchronously when the AACITB_BtClkRst bit in the
    AACITrCntlReg register is cleared. It also ensures that the
    negation of nAACIBITCLKRST occurs synchronous to AACIBITCLK
  */ 

  int temp = AACIBITCLK_PERIOD /PCLK_PERIOD;
  if (temp == 0)
    temp = 2;

  /* Assert the nAACIBITCLKRST input to the AACI by writing '0' to the
     AACITB_BtClkRst bit in the AACITrCntlReg register */
  PSW(AACITB_En, AACITrCntlReg);

  /* Wait for one BitClk Period */
  PI(temp);

  /* Negate nAACIBITCLKRST by writing '1' to the AACITB_BtClkRst bit.
     The negation happens after AACIBITCLK is enabled */
  PSW(AACITB_En | AACITB_BtClkRst , AACITrCntlReg);

  PI(2 * temp);
}

/**********************************************************************/
/*************************** Clock Selection **************************/
/**********************************************************************/
void ClockSelect(void)
{
 /*
    Summary: ClockSelect
    ====================
    This function selects the clock (PCLK or the internal clock from 
    the trickbox) to route to AACIBITCLK. When the frequencies of PCLK
    and AACIBITCLK are equal, it is necessary that the two clocks be
    driven from the same source. Hence, in this case, the PCLK input is
    routed onto the AACIBITCLK port of the AACI. When the frequencies
    of the two clocks are different, the BITCLK generated internally
    within the trickbox is driven onto the AACIBITCLK port of the AACI.
    The transition from one source to another source is to be done 
    without a glitch on the AACIBITCLK line. Hence, when switching
    clock sources, the following sequence is followed :
      - The active source driving AACIBITCLK is first turned off
      - Polling is done for AACIBITCLK to die down 
      - The other clock is source is enabled.
 */

 int32 One_BitClk_Period;

 One_BitClk_Period = AACIBITCLK_PERIOD/PCLK_PERIOD;
 if (One_BitClk_Period == 0x0)
   One_BitClk_Period = 0x2;

 /* Write AACIBITCLK period in to the trickbox */
 PSW(AACIBITCLK_PERIOD, AACITrBtClkPrd);

 /* Selecting the clock source to be routed to AACIBITCLK */
 if (AACIBITCLK_PERIOD == PCLK_PERIOD)
   {
    PSW(0x00, AACITrClkReg);
    PO(0x00, AACITB_PCLKOn | AACITB_BITCLKOn,AACITrClkReg, 2 * One_BitClk_Period);
    /* PCLK routed to AACIBITCLK */
    PSW(AACITB_ClkSel, AACITrClkReg);
    PSW(AACITB_PCLKEn | AACITB_ClkSel, AACITrClkReg);
   }
 else
   {
    PSW(0x00, AACITrClkReg);
    PO(0x00, 0x18,AACITrClkReg, One_BitClk_Period);

    /* Internal BITCLK from the trickbox is routed to AACIBITCLK */
    PSW(0x0, AACITrClkReg);
    PSW(AACITB_BitClkEn, AACITrClkReg);
   }
}

/**********************************************************************/
/*************************** CalculateTimeOut *************************/
/**********************************************************************/
void CalculateTimeOut(void)
{
  /*
    Summary: CalculateTimeOut
    =========================
    This function calculates a TimeOut value for use in Poll commands.

  */

  /* The timeout value is calculated as the number of poll-reads 
     corresponding to the duration of one Slot */
  TimeOut = (((20 * AACIBITCLK_PERIOD ) / PCLK_PERIOD)/2);
}

/**********************************************************************/
/*************************** InitCntlWrd ******************************/
/**********************************************************************/
void InitCntlWrd(void)
{
 
  /*
     Summary: InitCntlWrd
     ====================
     This function initializes the CW (ControlWords) structure:

     o It initializes all the elements of structure ControlWords to
       their default values.

     o It reassigns the TxSize[1 - 4] and RxSize[1 - 4] to new values 
       derived from their respective previous values

  */

  int i;

 
  /* Initialise transmit/receive enable bits */
  CW.DatTxCntlReg[1] = 0x0;
  CW.DatTxCntlReg[2] = 0x0;
  CW.DatTxCntlReg[3] = 0x0;
  CW.DatTxCntlReg[4] = 0x0;
  CW.DatTxCntlReg[5] = 0x0;
  CW.DatRxCntlReg[1] = 0x0;
  CW.DatRxCntlReg[2] = 0x0;
  CW.DatRxCntlReg[3] = 0x0;
  CW.DatRxCntlReg[4] = 0x0;
  CW.DatRxCntlReg[5] = 0x0;
  
  for (i = 1; i < 12; i++)
    CW.AACITB_SLOT0[i] = 0x0;
 
  for ( i = 0; i < 12; i++)
    CW.AACITB_SLOT1[i]  = 0x0;

  for (i = 1; i < 12; i++)
    CW.AACI_SLOT0[i]   = 0x0;

  CW.NoInVldFrm = 0;

  /* Indicates that the third frame is an invalid frame */
  CW.StartInVldFrm = 3;
 
  for (i = 1; i < 6; i++)
    CW.FrmInVldCh[i] = 0;
 
  for (i = 0; i < 12; i++)
    CW.RemapedSRC[i] = RemapSR(i);

  /* Access primary CODEC by default */
  CW.SecCODEC = 0x0;

  CW.Slt2Corcfct = 0;

  for (i = 1; i < 12; i++)
  {
    CW.TxRegRdSltEn[i]   = DATA_Fs;
    CW.TxRegWtSltEn[i]   = DATA_Fs;
    CW.TxFIFOWtSltEn[i]  = DATA_Fs;
    CW.TxFIFORdSltEn[i]  = DATA_Fs;
    CW.RxRegSltEn[i]     = DATA_Fs;
    CW.TxRegSltEn[i]     = DATA_Fs;
  }

  /* Initialising TxSize and RxSize. TxSize[0] and RxSize[0] are used
     as temporary variables */
  TxSize[0] = TxSize[1];
  TxSize[1] = TxSize[2];
  TxSize[2] = TxSize[3];
  TxSize[3] = TxSize[4];
  TxSize[4] = TxSize[0];
  RxSize[0] = RxSize[1];
  RxSize[1] = RxSize[2];
  RxSize[2] = RxSize[3];
  RxSize[3] = RxSize[4];
  RxSize[4] = RxSize[0];
}

/**********************************************************************/
/************************** Calculate_TrSlot0 *************************/
/**********************************************************************/
int32 Calculate_TrSlot0()
{
  /*
     Summary: Calculate_TrSlot0
     ==========================
     This function calculates the Slot 0 to be transmitted by the
     trickbox and assigns it to the CW.AACITB_SLOT0 structure element. 
     This information is derived from the value programmed into the
     structure element CW.DatRxCntlReg[n] (n = 1 to 5)

  */

  int32 RSlot0;
  int32 Slot0 = 0x0;
  int32 MaskBit = 0x1;
  int i;

  RSlot0 = CW.DatRxCntlReg[1] | CW.DatRxCntlReg[2] |
           CW.DatRxCntlReg[3] | CW.DatRxCntlReg[4] | CW.DatRxCntlReg[5];
  RSlot0 = RSlot0 & Masks[13];

  RSlot0 = RSlot0 | 0x1;

  for (i = 0; i < 16; i++)
  {
    Slot0 = ((RSlot0 & MaskBit) << (15 - i)) | Slot0;
    RSlot0 = RSlot0 >> 1;
  }

  return(Slot0);
}

/**********************************************************************/
/*************************** Calculate_AaciSlot0 **********************/
/**********************************************************************/
int32 Calculate_AaciSlot0(int FrameNo)
{
  /*
    Summary: Calculate_AaciSlot0
    ============================
    This function calculates the Slot 0 to be transmitted by the
    AACI and assigns it to the CW.AACI_SLOT0 structure element. This
    value is used to verify the Slot 0 data actually transmitted by the
    AACI. This information is derived from the value programmed into 
    the structure elements CW.TxFIFORdSltEn[n] (n = Frame number) and
    CW.TxRegRdSltEn[n] (n = Frame number).

  */

  int32 RSlot0;
  int32 Slot0 = 0x0;
  int32 MaskBit = 0x1;
  int i;

  RSlot0 = CW.TxFIFORdSltEn[FrameNo] | CW.TxRegRdSltEn[FrameNo];
  RSlot0 = RSlot0 & Masks[13];
  if (RSlot0 != 0x0)
    RSlot0 = RSlot0 | 0x1;

  for (i = 0; i < 16; i++)
  {
    Slot0 = ((RSlot0 & MaskBit) << (15 - i)) | Slot0;
    RSlot0 = RSlot0 >> 1;
  }

  return(Slot0);
}

/**********************************************************************/
/*************************** RemapSR **********************************/
/**********************************************************************/
int32 RemapSR(int FrameNo)
{
  /*
   Summary: RemapSR
   ================
   This function inverts the SRC bits transmitted by the trickbox. This
   value is used for bit-wise ANDing with the value programmed into
   the AACITXCRn (n = 1 to 4) register. The result of the bit-wise
   AND is used to determine whether data written to the AACI will be 
   suppressed from transmission on the next frame by the SRC bits 
   transmitted from the trickbox.

  */
 
  int32 RSlot1;
  int32 Slot1 = 0x0;
  int32 MaskBit = 0x1;
  int i;

  RSlot1 = CW.AACITB_SLOT1[FrameNo];
  RSlot1 = RSlot1>>2;
  RSlot1 = RSlot1 & Masks[12];
 
  for (i = 0; i < 12; i++)
  {
    Slot1 = ((RSlot1 & MaskBit) << (11 - i)) | Slot1;
    RSlot1 = RSlot1 >> 1;
  }
 
  Slot1 = ~(Slot1);
  Slot1 = Slot1 << 1;
  Slot1 = Slot1 | 0x7;
  
  return(Slot1);
}

/**********************************************************************/
/********************************  Idle  ******************************/
/**********************************************************************/
void Idle(unsigned long time)
{
  /*
    Summary: Idle
    =============
    This function inserts idle cycles using the PI command. The
    argument to PI cannot be more than 255. Hence, larger delays 
    need to be split into multiple PI commands.

  */
 
  unsigned long i;
  int Count, Remainder; 

  Count     = time/255;
  Remainder = time % 255;

  if (time <= 2)
  {
    PI(0x02);
  }
  else
  {
    while (Count > 0)
      {
       if (Remainder == 1)
         {
          PI(0xFE);
          PI(0x2);
          Remainder = 0;
         }
       else
         {
          PI(0xFF);
         }
       Count = Count - 1;
      }
    if (Remainder != 0)
      {
       PI(Remainder);
      }
  }
}

/**********************************************************************/
/*************************** TrRxFIFORd *******************************/
/**********************************************************************/
void TrRxFIFORd(int32 Ch1ValidSlot, int32 Ch2ValidSlot, 
                 int32 Ch3ValidSlot, int32 Ch4ValidSlot, 
                 int32 Ch1ModeSize, int32 Ch2ModeSize,
                 int32 Ch3ModeSize, int32 Ch4ModeSize)
{
 /* 
   Summary : TrRxFIFORd
   ====================
   This function is used to verify data transmitted by the
   AACI, which is stored in the Receive FIFO of the Trickbox. Data 
   originally written to the AACI's Tx Channels are accessible to this
   function through the global variable, WriteData. The control
   parameters programmed into the AACI (such as Valid slots for each
   channel, Compact mode/Non-Compact mode and TSIZE) are passed as 
   arguments to this function. This function combines these two sources 
   of information to derive the expected data in the Receive FIFO of the
   trickbox. This function reads and verifies data corresponding to one 
   frame. 
 */

 int   i = 0, Count = 12;
 int32 temp, Ch1TSize, Ch2TSize, Ch3TSize, Ch4TSize, Expected_Slot0;
 int32 SlotMask = 0x02;
 int32 MaskBit = 0x1;

 /* Extract TSIZE values programmed into each of the channels */
 temp     = Ch1ModeSize & MASK_TSIZE;
 Ch1TSize = temp >> 13;
 temp     = Ch2ModeSize & MASK_TSIZE;
 Ch2TSize = temp >> 13;
 temp     = Ch3ModeSize & MASK_TSIZE;
 Ch3TSize = temp >> 13;
 temp     = Ch4ModeSize & MASK_TSIZE;
 Ch4TSize = temp >> 13;

 temp = 0;

 /* Calculate the expected Slot 0 */
 /* The Slot0Generation() function is common to data transmission and
    reception by the trickbox. In the case of data reception by the
    trickbox, the Slot0Generation() function calculates the expected
    value of Slot 0 to be transmitted by the AACI. In the case of data
    transmission by the trickbox, the Slot0Generation() function 
    calculates the Slot 0 that needs to be transmitted by the 
    trickbox. The 20-bit Slot 0 information generated by the 
    Slot0Generation() function needs to be right shifted by 4 bits
    before being compared with the 16-bit Slot 0 data received from
    the AACI. The Slot0Generation() function generates 20-bit Slot0
    information in a right-justified manner for the trickbox to
    transmit.  
 */
 if (Ch1ValidSlot == 0 && Ch2ValidSlot == 0 && Ch3ValidSlot == 0 && 
     Ch4ValidSlot == 0)
   {
    Expected_Slot0 = 0x80000;
   }
 else 
   {
    Expected_Slot0 = Slot0Generation(Ch1ValidSlot, Ch2ValidSlot,
                                      Ch3ValidSlot, Ch4ValidSlot);
   }

 Expected_Slot0 = Expected_Slot0 >> 0x4;

 PSR(Expected_Slot0 & 0x00FFF8, 0x0FFFF, AACITrRxFIFO,AACI1_T3);

 /* For each slot, the expected data is calculated and the data
    read from the RX FIFO of the trickbox is verified. For Slot2
    data, the 4 LSBits are expected to be zeroed.  */
 for (i = 0; i < Count; i++)
    {
     if (Ch1ValidSlot & SlotMask)
       {
        temp = (WriteData[i] & Mask_Size[Ch1TSize]) << 
               Shift_Count[Ch1TSize];
        if (SlotMask == 0x4)
          {
           temp = temp & 0x000FFFF0;
          }
        PSR(temp, Mask_Size[Ch1TSize], AACITrRxFIFO,AACI1_T4);
       }
     else
       {
        if (Ch2ValidSlot & SlotMask)
          {
           temp = (WriteData[i] & Mask_Size[Ch2TSize]) <<
                  Shift_Count[Ch2TSize];
          if (SlotMask == 0x4)
            {
             temp = temp & 0x000FFFF0;
            }
           PSR(temp, Mask_Size[Ch2TSize], AACITrRxFIFO,AACI1_T5);
          } 
       else
         {
          if (Ch3ValidSlot & SlotMask)
            {
             temp = (WriteData[i] & Mask_Size[Ch3TSize]) <<
                    Shift_Count[Ch3TSize];
             if (SlotMask == 0x4)
               {
                temp = temp & 0x000FFFF0;
               }
             PSR(temp, Mask_Size[Ch3TSize], AACITrRxFIFO,AACI1_T6);
            } 
        else
          {
           if (Ch4ValidSlot & SlotMask)
             {
              temp = (WriteData[i] & Mask_Size[Ch4TSize]) <<
                     Shift_Count[Ch4TSize];
              if (SlotMask == 0x4)
                {
                 temp = temp & 0x000FFFF0;
                }

               PSR(temp, Mask_Size[Ch4TSize], AACITrRxFIFO,AACI1_T7);
             }
          else
            PSR(0x00, 0x0FFFFF, AACITrRxFIFO,AACI1_T8);
          }
         }
       }
      SlotMask = SlotMask<<1;
    }
}

/**********************************************************************/
/*************************** ConfigTxCR *******************************/
/**********************************************************************/
void ConfigTxCR(int ChannelNo, int32 ConfigData)
{
 /* 
   Summary : ConfigTxCR
   ====================
   This function writes the ConfigData passed as argument into
   the AACITXCRn [n = 1 to 4] registers based on the ChannelNo
   argument value.
 */

  if (ChannelNo == Channel_1)
    PSW(ConfigData, AACITXCR1);
  else
    {
     if (ChannelNo == Channel_2)
       PSW(ConfigData, AACITXCR2);
     else
       {
        if (ChannelNo == Channel_3)
          PSW(ConfigData, AACITXCR3);
       else
         if (ChannelNo == Channel_4)
           PSW(ConfigData, AACITXCR4);
       }
    }
}

/**********************************************************************/
/************************** ConfigRxCR ********************************/
/**********************************************************************/
void ConfigRxCR(int ChannelNo, int32 ConfigData)
{
 /* 
   Summary : ConfigRxCR
   ====================
   This function writes the ConfigData passed as argument into
   the AACIRXCRn [n = 1 to 4] registers based on the ChannelNo
   argument value.
 */

 if (ChannelNo == Channel_1)
   PSW(ConfigData, AACIRXCR1);
 else
   {
    if (ChannelNo == Channel_2)
      PSW(ConfigData, AACIRXCR2);
    else
      {
       if (ChannelNo == Channel_3)
         PSW(ConfigData, AACIRXCR3);
       else
         if (ChannelNo == Channel_4)
           PSW(ConfigData, AACIRXCR4);
      }
   }
}

/**********************************************************************/
/***************************** TxFIFOFill *****************************/
/**********************************************************************/
void TxFIFOFill(int ChannelNo, int32 ChValidSlot, int32 ChModeSizeFen)
{
 /* 
   Summary : TxFIFOFill
   ====================
   This function is used to fill data in to the transmit FIFOs of AACI.
   The function takes in the Channel number (ChannelNo), the slots that 
   are valid for that channel (ChValidSlot) and other control parameters
   (such as Compact Mode/Non-Compact mode, TSIZE, Character-mode/
   FIFO-mode) as arguments. Based on these arguments, the function 
   writes data for one frame from the global variable WriteData[] into 
   the Channel FIFOs of the AACI.
 */

 int   i = 0,j = 0,k = 0, Count = 12, Flag = 0;
 int32 SlotMask = 0x00000002, temp = 0x00, EvenSlots = 0;
 int32 Mode, TSize, Fen;
 int   One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 /* Extract the Mode, TSize and FIFO-mode information */
 Mode  = ChModeSizeFen & MASK_MODE;
 TSize = ChModeSizeFen & MASK_TSIZE;
 Fen   = ChModeSizeFen & AACI_FEN;

 /* Write data into the Channel FIFOs based on the programmed
    parameters. In the case of Compact mode, data for 2 slots are
    combined and written into a single entry of the Channel FIFO.
 */
 if (ChValidSlot > 0)
   {
    for (i = 0; i < Count & Flag == 0; i++)
      {
       if (ChValidSlot & SlotMask)
         {
          if (Mode == AACI_CM)
            {
             EvenSlots = EvenSlots + 1;
             if (EvenSlots == 2)
               {
                if (TSize == AACI_TSIZE12 || TSize == AACI_TSIZE16)
                  {
                   temp = WriteData[k] & 0x0FFFF;
                   temp = temp | WriteData[i] << 16;

                   if (ChannelNo == Channel_1)
                     {
                      PSW(temp, AACIDR1,Channel1Write);
                     }
                   else
                     {  
                      if (ChannelNo == Channel_2)
                        PSW(temp, AACIDR2);
                      else
                        {
                         if (ChannelNo == Channel_3)
                           PSW(temp, AACIDR3);
                         else
                           {
                            if (ChannelNo == Channel_4)
                              PSW(temp, AACIDR4);
                           }
                        }
                     }
                  }
                else
                  {
                   if (TSize == AACI_TSIZE18 || TSize == AACI_TSIZE20)
                     {
                      if (ChannelNo == 1)
                        PSW(WriteData[i],AACIDR1);
                      else
                      if (ChannelNo == 2)
                        PSW(WriteData[i],AACIDR2);
                      else
                        if (ChannelNo == 3)
                          PSW(WriteData[i],AACIDR3);
                      else
                        if (ChannelNo == 4)
                          PSW(WriteData[i],AACIDR4);
                     }
                  }
                PI(One_BitClk_Period * 4);

                if (Fen == 0)
                  Flag = 1;
                else
                  EvenSlots = 0;
               }
             else
               {
                if (EvenSlots == 1)
                k = i; 
               }
            }
          else
            {
             if (ChannelNo == 1)
               PSW(WriteData[i],AACIDR1);
             else
               if (ChannelNo == 2)
                 PSW(WriteData[i],AACIDR2);
             else
               if (ChannelNo == 3)
                 PSW(WriteData[i],AACIDR3);
             else
               if (ChannelNo == 4)
                 PSW(WriteData[i],AACIDR4);

             PI(One_BitClk_Period * 4);

             if (Fen == 0)
               Flag = 1;
            } 
         }
       SlotMask=SlotMask<<1;
     } 
   }
}

/**********************************************************************/
/***************************** TrTxFIFOWr *****************************/
/**********************************************************************/
void TrTxFIFOWr(int32 Ch1ValidSlot, int32 Ch2ValidSlot,
                 int32 Ch3ValidSlot, int32 Ch4ValidSlot, 
                 int32 Ch1ModeSize, int32 Ch2ModeSize,
                 int32 Ch3ModeSize, int32 Ch4ModeSize)
{
 /*
   Summary : TrTxFIFOWr
   ====================
   This function is used to write the data to be transmitted by
   the Trickbox into its Tx FIFO. The function takes as arguments the 
   slots that are valid for each channel (ChnValidSlot [n=1-4]) and 
   other control parameters (such as Compact Mode/ Non-Compact mode, 
   RSIZE, Character-mode/ FIFO-mode). Based on these arguments, the 
   function writes data for one frame from the global variable 
   WriteData[] into the Trickbox Tx FIFO.
 */

 int   i = 0, Count = 12;
 int32 temp, Ch1RSize, Ch2RSize, Ch3RSize, Ch4RSize, Expected_Slot0;
 int32 SlotMask = 0x02, MaskBit = 0x01;
 
 /* Extract RSIZE values programmed into each of the channels */
 temp     = Ch1ModeSize & MASK_RSIZE;
 Ch1RSize = temp >> 13;
 temp     = Ch2ModeSize & MASK_RSIZE;
 Ch2RSize = temp >> 13;
 temp     = Ch3ModeSize & MASK_RSIZE;
 Ch3RSize = temp >> 13;
 temp     = Ch4ModeSize & MASK_RSIZE;
 Ch4RSize = temp >> 13;
 temp     = 0;
 
 /* Generating the slot0 that is to be transmitted to the AACI by
    the trickbox */
 if (Ch1ValidSlot == 0 && Ch2ValidSlot == 0 && Ch3ValidSlot == 0 &&
      Ch4ValidSlot == 0)
   {
    Expected_Slot0 = 0x80000;
   }
 else
   {
    Expected_Slot0 = Slot0Generation(Ch1ValidSlot, Ch2ValidSlot,
                                      Ch3ValidSlot, Ch4ValidSlot);
   }
 PSW(Expected_Slot0, AACITrTxFIFO);

 /* Write data into the Channel FIFOs based on the programmed
    parameters. */
 for (i = 0; i < Count; i++)
   {
    if (Ch1ValidSlot & SlotMask)
      {
       temp = WriteData[i] & Mask_Size[Ch1RSize]; 
       temp = temp << Shift_Count[Ch1RSize]; 
       PSW(temp, AACITrTxFIFO);
      }
    else
      {
       if (Ch2ValidSlot & SlotMask)
         {
          temp = WriteData[i] & Mask_Size[Ch2RSize];
          temp = temp << Shift_Count[Ch2RSize];
          PSW(temp, AACITrTxFIFO);
         }
       else
         {
          if (Ch3ValidSlot & SlotMask)
            {
             temp = WriteData[i] & Mask_Size[Ch3RSize];
             temp = temp << Shift_Count[Ch3RSize];
             PSW(temp, AACITrTxFIFO);
            }
          else
            {
             if (Ch4ValidSlot & SlotMask)
               {
                temp = WriteData[i] & Mask_Size[Ch4RSize];
                temp = temp << Shift_Count[Ch4RSize];
                PSW(temp, AACITrTxFIFO);
               }
             else
               PSW(0x00, AACITrTxFIFO);
            }
         }
      }
    SlotMask=SlotMask << 1;
   }
}

/**********************************************************************/
/****************************** RxFIFORd  *****************************/
/**********************************************************************/
void RxFIFORd(int ChannelNo, int32 ChValidSlot, int32 ChModeSizeFen)
{
 /* 
   Summary : RxFIFORd
   ==================
   This function is used to verify data reception by the AACI. Data 
   originally written to the Trickbox's Tx FIFO are accessible to this 
   function through the global variable, WriteData. The control 
   parameters programmed into the AACI (such as Valid slots for the 
   channel, Compact mode/Non-Compact mode and TSIZE) are passed as 
   arguments to this function. This function combines these two sources
   of information to derive the expected data in the Receive FIFO of the
   AACI. This function reads and verifies data corresponding to one 
   frame.
 */

 int i = 0,j = 0,k = 0, Count = 12, Flag = 0;
 int32 SlotMask = 0x02, temp = 0x00, EvenSlots = 0;
 int32 Mode, RSize, Size, Fen;
 
 /* Extract the Mode, RSize and FIFO-mode information */
 Mode  = ChModeSizeFen & MASK_MODE;
 RSize = ChModeSizeFen & MASK_RSIZE;
 Size  = RSize >> 13;
 Fen   = ChModeSizeFen & AACI_FEN;

 /* Read data from the relevant Channel FIFO based on the programmed
    parameters. In the case of Compact mode, data for 2 slots are
    expected to be returned in a single read. */
 if (ChValidSlot > 0)
   {
    for (i = 0; i < Count  & Flag == 0; i++)
      {
       if (ChValidSlot & SlotMask)
         {
          if (Mode == AACI_CM)
            {
             EvenSlots = EvenSlots + 1;
             if (EvenSlots == 2)
               {
                if (RSize == AACI_RSIZE12)
                  {
                   temp = WriteData[k] & Mask_Size[Size];
                   temp = temp | WriteData[i] << 16;
                   temp = temp  &  0x0FFFFFFF; 
                   if (ChannelNo == 1)
                     PSR(temp, 0x0FFF0FFF, AACIDR1,AACI1_T9);
                   else
                     {
                      if (ChannelNo == 2)
                         PSR(temp, 0x0FF80FF8, AACIDR2,AACI1_T10);
                      else
                        {
                         if (ChannelNo == 3)
                           PSR(temp, 0x0FFF0FFF, AACIDR3,AACI1_T11);
                         else
                           {
                            if (ChannelNo == 4)
                              PSR(temp, 0x0FFF0FFF, AACIDR4,AACI1_T12);
                           }
                        }
                     }
                  }
                else
                  {
                   if (RSize == AACI_RSIZE16)
                     {
                      temp = WriteData[k] & Mask_Size[Size];
                      temp = temp | WriteData[i] << 16;
                      if (ChannelNo == 1)
                        /* Masking only the RSIZE */
                        PSR(temp, MASK_ALL, AACIDR1,AACI1_T13);
                      else
                        { 
                         if (ChannelNo == 2)
                            PSR(temp, MASK_ALL, AACIDR2,AACI1_T14);
                         else
                           { 
                            if (ChannelNo == 3)
                              PSR(temp, MASK_ALL, AACIDR3,AACI1_T15);
                            else
                              {
                               if (ChannelNo == 4)
                                 PSR(temp, MASK_ALL, AACIDR4,AACI1_T16);
                              }
                           }
                        }
                     }
                   else
                     {
                      if (RSize == AACI_RSIZE18 || RSize == AACI_RSIZE20)
                        {
                         temp = WriteData[i]&Mask_Size[Size];
                         if (ChannelNo == 1)
                           PSR(temp, Mask_Size[Size], AACIDR1,AACI1_T17);
                         else
                            {
                            if (ChannelNo == 2)
                               PSR(temp,Mask_Size[Size], AACIDR2,AACI1_T18); 
                            else
                              {
                               if (ChannelNo == 3)
                                 PSR(temp,Mask_Size[Size], AACIDR3,AACI1_T19); 
                               else
                                 {
                                  if (ChannelNo == 4)
                                    PSR(temp,Mask_Size[Size], AACIDR4,AACI1_T20);
                                 }
                              }
                           } 
                        }
                     }
                  }
                if (Fen == 0)
                  Flag = 1;
                else 
                  EvenSlots = 0;
               }
             else
               {
                if (EvenSlots == 1)
                  k=i;
               }
            }
          else
            {
             temp = WriteData[i] & Mask_Size[Size];
             if (ChannelNo == 1)
               PSR(temp, Mask_Size[Size], AACIDR1,AACI1_T21);
             else
               {
                if (ChannelNo == 2)
                   PSR(temp,Mask_Size[Size], AACIDR2,AACI1_T22);
                else
                  {
                   if (ChannelNo == 3)
                     PSR(temp,Mask_Size[Size], AACIDR3,AACI1_T23);
                   else
                     {  
                      if (ChannelNo == 4)
                         PSR(temp,Mask_Size[Size], AACIDR4,AACI1_T24);
                     }
                  }
               }
             if (Fen == 0)
               Flag = 1;
            }
         }
       SlotMask=SlotMask<<1; 
      }
   }
}

/**********************************************************************/
/************************* Slot0Generation ****************************/
/**********************************************************************/
int32 Slot0Generation(int32 Ch1ValidSlot, int32 Ch2ValidSlot, 
                     int32 Ch3ValidSlot, int32 Ch4ValidSlot) 
{
 /*
   Summary : 
   ========
            This function calculates the slot 0 data from the slot
   valid information corresponding to each channel. The ChnValidSlot
   [n = 1-4] arguments are bitwise ORed and the bits in the result
   are 'reversed' i.e. bit 0 in the result is made bit 15 of the
   Slot 0 data, bit 1 the result is made bit 14 of the Slot 0 data
   and so on. The bit reversal is required because the ChnValidSlot
   [n = 1-4] arguments carry the information for Slot 1 on their
   LSBit, while the protocol requires that the Valid bit for Slot 1
   be transmitted on Bit 14 of Slot 0.
 */

 int32 Expected_Slot0 = 0, MaskBit = 0x01,temp;
 int i = 0;

 /* Bit-wise OR the Slot Valid information */
 temp = Ch1ValidSlot | Ch2ValidSlot | Ch3ValidSlot | Ch4ValidSlot;

 /* Bit-reverse the result */
 for (i = 0; i < 16; i++)
   {
    Expected_Slot0 = ((temp & MaskBit) << (15 - i)) | Expected_Slot0;
    temp = temp >> 1;
   }

 /* Set the Frame Valid bit because this function is always called
    with atleast one slot valid bit set */
 Expected_Slot0 = Expected_Slot0 | 0x08000;

 /* Left justification by 4 bits for tag slot. This is because the 
    trickbox transmits the 20-bit data written to its Tx FIFO 
    MSB-first */
 Expected_Slot0 = Expected_Slot0 << 0x4;

 return(Expected_Slot0);
}

/**********************************************************************/
/*************************** FrameWrite *******************************/
/**********************************************************************/
void FrameWrite (int ChannelNo, int32 ChValidSlot, int32  ChModeSize)
{
 /*
   Summary : FrameWrite
   ====================
   This function is used to write data in to the transmit FIFO of the 
   trickbox. The data write is controlled by the number of slots 
   (ChValidSlot) programmed for that channel and other control
   parameters such as Mode and RSIZE.
 */

 if (ChannelNo == Channel_1)
   TrTxFIFOWr(ChValidSlot, 0x00, 0x00, 0x00,
                ChModeSize, 0x00, 0x00, 0x00);
 else
   {
    if (ChannelNo == Channel_2)
      TrTxFIFOWr(0x00, ChValidSlot, 0x00, 0x00,
                  0x00, ChModeSize,  0x00, 0x00);
    else
      {
       if (ChannelNo == Channel_3)
         TrTxFIFOWr(0x00, 0x00, ChValidSlot, 0x00,
                     0x00, 0x00, ChModeSize,  0x00);
       else
         {
          if (ChannelNo == Channel_4)
            TrTxFIFOWr(0x00, 0x00, 0x00, ChValidSlot,
                        0x00, 0x00, 0x00, ChModeSize);
         }
      }
   }
}

/**********************************************************************/
/**************************** FrameRead *******************************/
/**********************************************************************/
void FrameRead(int ChannelNo, int32 ChValidSlot, int32  ChModeSize)
{
 /*
   Summary : FrameRead
   ===================
   This function is used to read data from the receive FIFO of the 
   trickbox. The expected data is controlled by the number of slots 
   (ChValidSlot) programmed for that channel and other control 
   parameters such as Mode and TSIZE.
 */
 
 if (ChannelNo == Channel_1)
   TrRxFIFORd(ChValidSlot, 0x00, 0x00, 0x00,
               ChModeSize,  0x00, 0x00, 0x00);
 else
   {
    if (ChannelNo == Channel_2)
      TrRxFIFORd(0x00, ChValidSlot, 0x00, 0x00,
                  0x00, ChModeSize,  0x00, 0x00);
    else
      {
       if (ChannelNo == Channel_3)
         TrRxFIFORd(0x00, 0x00, ChValidSlot, 0x00,
                     0x00, 0x00, ChModeSize,  0x00);
       else
         {
          if (ChannelNo == Channel_4)
            TrRxFIFORd(0x00, 0x00, 0x00, ChValidSlot,
                        0x00, 0x00, 0x00, ChModeSize);
         }
      }
   }
}

/**********************************************************************/
/************************** CheckSlIntrClr ****************************/
/**********************************************************************/
void CheckSlIntrClr(int SlotNo, int RxOrTx, int Masked)
{
 /*
   Summary : CheckSlIntrClr
   ========================
   This function reads the status registers related to the AACISLnTXINTR
   (n = 1, 2, 12) and AACICLnRXINTR (n = 1, 2, 12) interrupts to verify 
   that the interrupts are cleared.
 */
 switch (RxOrTx)
   {
    case 0 : 
      switch (SlotNo)
        {
         case 12 :
           /* Verify that the AACISL12RXINTR Interrupt is cleared */
           if (Masked == 1)
             {
              PSR(AACI_SL12RXVALID, AACI_SL12RXVALID, AACISLFR,AACI1_T625);
             }
           else
             {
              PSR(0x0, AACI_SL12RXVALID, AACISLFR,AACI1_T625);
             }
           PSR(0x0, AACI_SL12RXINT, AACISLISTAT,AACI1_T626);
           PSR(0x0, AACISLOT12RXINTR, AACITrIntr1Reg,AACI1_T628);
           PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
           break;
     
         case 2 :
           /* Verify that the AACISL2RXINTR Interrupt is cleared */
           if (Masked == 1)
             {
              PSR(AACI_SL2RXVALID, AACI_SL2RXVALID, AACISLFR,AACI1_T671);
             }
           else
             {
              PSR(0x0, AACI_SL2RXVALID, AACISLFR,AACI1_T671);
             }
           PSR(0x0, AACI_SL2RXINT, AACISLISTAT,AACI1_T672);
           PSR(0x0, AACISLOT2RXINTR, AACITrIntr1Reg,AACI1_T674);
           PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
           break;
     
         case 1 :
           /* Verify that the AACISL1RXINTR Interrupt is cleared */
           if (Masked == 1)
             {
              PSR(AACI_SL1RXVALID, AACI_SL1RXVALID, AACISLFR,AACI1_T727);
             }
           else
             {
              PSR(0x0, AACI_SL1RXVALID, AACISLFR,AACI1_T727);
             }
           PSR(0x0, AACI_SL1RXINT, AACISLISTAT,AACI1_T728);
           PSR(0x0, AACISLOT1RXINTR, AACITrIntr1Reg,AACI1_T730);
           PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
           break;

         default :
           C("Invalid slot register value for interrupt test");
        }
      break;

    case 1 : 
      switch (SlotNo)
        {
         case 12 :
           /* Verify that the AACISL12TXINTR Interrupt is cleared */
           if (Masked == 1)
             {
              PSR(AACI_SL12TXEMPTY, AACI_SL12TXEMPTY, AACISLFR,AACI1_T766);
             }
           else
             {
              PSR(0x0, AACI_SL12TXEMPTY, AACISLFR,AACI1_T766);
             }
           PSR(0x0, AACI_SL12TXINT, AACISLISTAT,AACI1_T767);
           PSR(0x0, AACISLOT12TXINTR, AACITrIntr1Reg,AACI1_T769);
           PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
           break;
     
         case 2 :
           /* Verify that the AACISL2TXINTR Interrupt is cleared */
           if (Masked == 1)
             {
              PSR(AACI_SL2TXEMPTY, AACI_SL2TXEMPTY, AACISLFR,AACI1_T798);
             }
           else
             {
              PSR(0x0, AACI_SL2TXEMPTY, AACISLFR,AACI1_T798);
             }
           PSR(0x0, AACI_SL2TXINT, AACISLISTAT,AACI1_T799);
           PSR(0x0, AACISLOT2TXINTR, AACITrIntr1Reg,AACI1_T801);
           PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
           break;
     
         case 1 :
           /* Verify that the AACISL1TXINTR Interrupt is cleared */
           if (Masked == 1)
             {
              PSR(AACI_SL1TXEMPTY, AACI_SL1TXEMPTY, AACISLFR,AACI1_T830);
             }
           else
             {
              PSR(0x0, AACI_SL1TXEMPTY, AACISLFR,AACI1_T830);
             }
           PSR(0x0, AACI_SL1TXINT, AACISLISTAT,AACI1_T831);
           PSR(0x0, AACISLOT1TXINTR, AACITrIntr1Reg,AACI1_T833);
           PSR(0x0, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
           break;

         default :
           C("Invalid slot register value for interrupt test");
        }
      break;

    default :
      C("Invalid value on RxOrTx for interrupt test");
   }
}

/**********************************************************************/
/**************** Checking the slot interrupt to be set ***************/
/**********************************************************************/
void CheckSlIntrSet(int SlotNo, int RxOrTx)
{
 /*
   Summary : CheckSlIntrSet
   ========================
   This function reads the status registers related to the AACISLnTXINTR
   (n = 1, 2, 12) and AACICLnRXINTR (n = 1, 2, 12) interrupts to verify 
   that the interrupts are set.

 */
 switch (RxOrTx)
   {
    /* RxOrTx = 0 for AACISLnRXINTR (n = 1, 2, 12) interrupt */
    case 0 : 
      switch (SlotNo)
        {
         case 12 :
           /* Verify that the AACISL12RXINTR Interrupt is set */
           PSR(AACI_SL12RXVALID, AACI_SL12RXVALID, AACISLFR,AACI1_T620);
           PSR(AACI_SL12RXINT, AACI_SL12RXINT, AACISLISTAT,AACI1_T621);
           PSR(AACISLOT12RXINTR, AACISLOT12RXINTR, AACITrIntr1Reg,T623);
           PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
           break;
          
         case 2 :
           /* Verify that the AACISL2RXINTR Interrupt is set */
           PSR(AACI_SL2RXVALID, AACI_SL2RXVALID, AACISLFR,AACI1_T666);
           PSR(AACI_SL2RXINT, AACI_SL2RXINT, AACISLISTAT,AACI1_T667);
           PSR(AACISLOT2RXINTR, AACISLOT2RXINTR, AACITrIntr1Reg,T669);
           PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
           break;
          
         case 1 :
           /* Verify that the AACISL1RXINTR Interrupt is set */
           PSR(AACI_SL1RXVALID, AACI_SL1RXVALID, AACISLFR,AACI1_T722);
           PSR(AACI_SL1RXINT, AACI_SL1RXINT, AACISLISTAT,AACI1_T723);
           PSR(AACISLOT1RXINTR, AACISLOT1RXINTR, AACITrIntr1Reg,T725);
           PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
           break;

         default :
           C("Invalid slot register value for interrupt test");
        }
      break;

    /* RxOrTx = 1 for AACISLnTXINTR (n = 1, 2, 12) interrupt */
    case 1 : 
      switch (SlotNo)
        {
         case 12 :
           /* Verify that the AACISL12TXINTR Interrupt is set */
           PSR(AACI_SL12TXEMPTY, AACI_SL12TXEMPTY, AACISLFR,AACI1_T758);
           PSR(AACI_SL12TXINT, AACI_SL12TXINT, AACISLISTAT,_T759);
           PSR(AACISLOT12TXINTR, AACISLOT12TXINTR, AACITrIntr1Reg,T761);
           PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
           break;
          
         case 2 :
           /* Verify that the AACISL2TXINTR Interrupt is set */
           PSR(AACI_SL2TXEMPTY, AACI_SL2TXEMPTY, AACISLFR,AACI1_T802);
           PSR(AACI_SL2TXINT, AACI_SL2TXINT, AACISLISTAT,AACI1_T803);
           PSR(AACISLOT2TXINTR, AACISLOT2TXINTR, AACITrIntr1Reg,T805);
           PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
           break;
          
         case 1 :
           /* Verify that the AACISL1TXINTR Interrupt is set */
           PSR(AACI_SL1TXEMPTY, AACI_SL1TXEMPTY, AACISLFR,AACI1_T822);
           PSR(AACI_SL1TXINT, AACI_SL1TXINT, AACISLISTAT,AACI1_T823);
           PSR(AACISLOT1TXINTR, AACISLOT1TXINTR, AACITrIntr1Reg,_T825);
           PSR(AACIINTR, AACIINTR, AACITrIntr2Reg,Intr2_Tx_Intr_Rd);
           break;

         default :
           C("Invalid slot register value for interrupt test");
        }
      break;

    default :
      C("Invalid value on RxOrTx for interrupt test");
   }
}
/*********************** End of AaciCommon.c **************************/
