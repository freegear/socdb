// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name              : AaciTrProtChk.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL041-REL1v0
//
// ---------------------------------------------------------------------
// Purpose :
//           This module checks the AACISYNC and the AACIRESET protocols
//           and also the data width from SDATOUT line.
//
// --=================================================================--

`timescale 1ns/1ps

`include   "AaciTrPackage.v"

// ---------------------------------------------------------------------

module AaciTrProtChk (
// Inputs
                      // APB signals
                      PRESETn,
                      PCLK,

                      // AC link related signals
                      BITCLKIn,
                      AACITrEnBSync,
                      BtClkESync,
                      AACITrEn,
                      AACISDATAIN,
                      SlotState,
                      AACITrBtClkPrd,
                      AACISYNC,
                      AACIRESET,
                      // Foreced AACISYNC and AACIRESET signals
                      FORCEDRESET,
                      FORCEDSYNC,
                      WidChkEnSync
                     );

// Inputs
input         PRESETn;          // APB Reset
input         PCLK;             // APB clock
input         BITCLKIn;         // Serial Reference Clock
input         AACITrEnBSync;    // Trickbox enable in BITCLK domain
input         BtClkESync;       // Serial Bit Clock Enable
input         AACITrEn;         // Trickbox enable
input         AACISDATAIN;      // AACI trickbox serial data input
                                // AACISDATAOUT of the AACI
input   [3:0] SlotState;        // Slot data number
input  [15:0] AACITrBtClkPrd;   // BITCLK period value
input         AACISYNC;         // AACISYNC  port
input         AACIRESET;        // AACIRESET  port
input         FORCEDRESET;      // Forced Reset bit AACIRESET reg
input         FORCEDSYNC;       // Forced Sync bit AACISYNC reg
input         WidChkEnSync;     // Data width check

// Inputs
wire          PRESETn;          // APB Reset
wire          PCLK;             // APB clock
wire          BITCLKIn;         // Serial Reference Clock
wire          AACITrEnBSync;    // Trickbox enable in BITCLK domain
wire          BtClkESync;       // Serial Bit Clock Enable
wire          AACITrEn;         // Trickbox enable
wire          AACISDATAIN;      // AACI trickbox serial data input
wire    [3:0] SlotState;        // Slot data number
wire   [15:0] AACITrBtClkPrd;   // BITCLK period value
wire          AACISYNC;         // AACISYNC  port
wire          AACIRESET;        // AACIRESET  port
wire          FORCEDRESET;      // Forced Reset bit AACIRESET reg
wire          FORCEDSYNC;       // Forced Sync bit AACISYNC reg
wire          WidChkEnSync;     // Data width check

// ---------------------------------------------------------------------
//
//                           AaciTrProtChk
//                           =============
//
// ---------------------------------------------------------------------
//
// Overview
// ======== 
//
//    This module checks the protocol of the signals from the AACIRESET
// and AACISYNC ports of the AACI. It checks wheather the SYNC port is
// following the FORCEDSYNC bit in the AACISYNC register.
// And similarly the AACIRESET port is checked whether it is following
// the FORCEDRESET bit in AACIRESET register.
// The AACISYNC port is checked whether it is following the FORCEDSYNC
// bit in AACISYNC register in low power mode. AACISDATAOUT data width
// is checked in this block. For this the data pattern written to the 
// AACI // transmit FIFO is 1010... pattern through APB. And the 
// AACITrWidChkEn bit in the control register of the trickbox has to 
// written with value 1(high). In normal mode this bit has to be reset 
// to zero.The data width will be checked for half the BITCLK period
// with some allowable tolerance.
// The AACISYNC setup period with respect to the falling edge of the
// BITCLK is also checked in the normal mode with allowable tolerence.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Time variables declarations
// ---------------------------------------------------------------------
// timing parmeters
reg [64:0] DataRiseEdge;
// Rise Time of Data on AACISDATAOUT

reg [64:0] DataFallEdge;
// Time of falling Edge of the data

reg [64:0] SYNCActLTime;
// Actual AACISYNC high to low transition time

reg [64:0] SYNCActHTime;
// Actual AACISYNC low to high transition time

reg [64:0] SyncHighTime;
// AACISYNC low to high transition time in BITCLK domain

reg [64:0] SyncLowTime;
// AACISYNC high to low transition time in BITCLK domain

reg [64:0] SYNCChangeTime;
// Time at which an actual transition occurred on the AACISYNC port

reg [64:0] SDataInChngeTime;
// Time at which an actual transition occurred on the AACISDATAIN port

reg [64:0] BitClkRisingTime;
// BITCLK rising edge time

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg        SyncHighFlag;
// Flag for the high phase of AACISYNC

reg        SyncLowFlag;
// Flag for the low phase of AACISYNC

reg        DATAFlag1;
// Flag for the high phase of DATA

reg        DATAFlag2;
// Flag for the low phase of DATA

reg        SDataInCngeFlag;
// Flag to indicate change in DATA

reg        SYNCChangeFlag;
// Flag to indicate change in AACISYNC

reg  [1:0] ResetState;
// Reset State

reg  [1:0] BitClkState;
// BITCLK enable State

reg  [1:0] AsyncState;
// AACISYNC port State

reg  [7:0] ResetCount;
// Reset State counter

reg  [7:0] BitClkCnt;
// BITCLK counts counter

reg        iAACITrEnBSync;
// AACITrEn synchronised to BITCLK

reg        SyncCapt;
// AACISYNC port status captured in BITCLK domain
 
// ---------------------------------------------------------------------
// Function declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------
 
// ---------------------------------------------------------------------
// Connect local copies to output signals
// --------------------------------------------------------------------

// ---------------------------------------------------------------------
// Initialization of the registers used in the module
// ---------------------------------------------------------------------
initial
begin
  DataRiseEdge     <= 64'b0;
  DataFallEdge     <= 64'b0;
  SYNCActLTime     <= 64'b0;
  SYNCActHTime     <= 64'b0;
  SyncHighTime     <= 64'b0;
  SyncLowTime      <= 64'b0;
  SYNCChangeTime   <= 64'b0;
  SDataInChngeTime <= 64'b0;
  BitClkRisingTime <= 64'b0;
  SyncHighFlag     <= 1'b0;
  SyncLowFlag      <= 1'b0;
  SYNCChangeFlag   <= 1'b0;
  SDataInCngeFlag  <= 1'b0;
  DATAFlag1        <= 1'b0;
  DATAFlag2        <= 1'b0;
end

// ---------------------------------------------------------------------
// This is the state machine to check the AACIRESET protocol of the AACI
// This check is done on every rising edge of the PCLK
// This process checks the AACIRESET protocol for FORCEDRESET bit
// ---------------------------------------------------------------------
always @(posedge PCLK)
begin : p_FRESETChkSeq
  if (PRESETn == 1'b1 && AACITrEn == 1'b1)
    if (PCLK == 1'b1)
      if (AACIRESET != FORCEDRESET)
        $display($time," Error : AACITB5 :  AACIRESET port is NOT ",
                     "following the FORCEDRESET bit value defined \n"); 
end // process p_FRESETChkSeq;

// ---------------------------------------------------------------------
// This is the state machine to check the SYNC protocol of the AACI
// when BITCLK is disabled. This process checks the AACISYNC protocol
// for FORCEDSYNC This check is done on every rising edge of the PCLK.
// ---------------------------------------------------------------------
always @(posedge PCLK)
begin : p_FSYNCChkSeq
  if (PRESETn == 1'b1)
    if (PCLK == 1'b1)
      if (AACISYNC != FORCEDSYNC && FORCEDSYNC == 1'b1 && 
                                                 BtClkESync == 1'b0)
        $display($time,"Error : AACITB6 : AACISYNC port is NOT ",
                   "following the FORCEDSYNC bit value defined");
end // process p_FSYNCChkSeq;

// ---------------------------------------------------------------------
// Getting the period of Data Width pulse for verification of the width
// This process captures the positive and the negative edges of Data 
// pattern. This process is only enabled when the data width is to be 
// checked and the WidChkEnSync bit in the control register in the 
// trickbox is enabled.
// The process is sensitized to AACISDATAIN which is SDATAOUT coming out
// from the AACI .
// DATAFlag1 is used as a flag for the High Phase of the data pattern. 
// DATAFlag2 is used as a flag for the Low Phase of the data pattern.
// ---------------------------------------------------------------------
always @(posedge AACISDATAIN or negedge iAACITrEnBSync or WidChkEnSync
         or negedge PRESETn or posedge SlotState[1])
begin : p_GetDEdgesSeq
  if (PRESETn == 1'b0 | iAACITrEnBSync == 1'b0 | SlotState == `ST_SYNC
      | SlotState == `ST_SLOT2)
    begin
      DATAFlag1 <= 1'b0;
      DATAFlag2 <= 1'b0;
    end
  else if (WidChkEnSync == 1'b1)
    if (AACISDATAIN == 1'b1)
      if (DATAFlag1 == 1'b0)
        begin
          DataRiseEdge <= $time;
          DATAFlag1    <= 1'b1;
        end
      if (DATAFlag2 == 1'b1)
        begin
          DataRiseEdge <= $time;
          DATAFlag2    <= 1'b0;
        end
    else if (AACISDATAIN == 1'b0)
      if (DATAFlag2 == 1'b0)
        begin
          DataFallEdge <= $time;
          DATAFlag2    <= 1'b1;
        end
      if (DATAFlag1 == 1'b1)
        begin
          DataFallEdge <= $time;
          DATAFlag1    <= 1'b0;
        end
end // process p_GetDEdgesSeq;

// ---------------------------------------------------------------------
// Checking for validity of Data width.
// The difference in time between the rising and the falling edge of the
// Data is compared with the value calculated from the BITCLK and an 
// Offset is provided for Gate Level Simulations.
// ---------------------------------------------------------------------
always @ (DATAFlag2)
begin : p_ChkLPhaseSeq
  if (DATAFlag2 == 1'b0)
    if (iAACITrEnBSync == 1'b1 && SlotState != `ST_SYNC && 
        SlotState != `ST_SLOT2)
      if (((DataRiseEdge - DataFallEdge) > 
           (AACITrBtClkPrd + `OFFSET))
         | ((DataRiseEdge - DataFallEdge) < 
              (AACITrBtClkPrd - `OFFSET)))
        $display($time,"Error : AACITB7 : Data width Error  in the low",
                 " phase\n");
end // process p_ChkLPhaseSeq;
 
always @(DATAFlag1)
begin : p_ChkHPhaseSeq
  if (DATAFlag1 == 1'b0)
    if (iAACITrEnBSync == 1'b1 && SlotState != `ST_SYNC &&
        SlotState != `ST_SLOT2)
      if (((DataFallEdge - DataRiseEdge) > 
           (AACITrBtClkPrd + `OFFSET))
         | ((DataFallEdge - DataRiseEdge) < 
              (AACITrBtClkPrd - `OFFSET)))
        $display($time,"Error : AACITB8 : Data width Error in the ",
                 "high phase\n");
end // process p_ChkHPhaseSeq;
 
// ---------------------------------------------------------------------
// The protocol Check to check the set up violation for AACISYNC with 
// respect to falling edge of the BITCLK
// The next five process are for this protocol check 
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Capturing the transitions on the AACISYNC in BITCLK domain 
// ---------------------------------------------------------------------
always @(negedge BITCLKIn or negedge PRESETn)
begin : p_SYNCSetUPChk
  if (PRESETn == 1'b0)
      SyncCapt <= 1'b0;
  else if (BITCLKIn == 1'b0)
    if (AACISYNC == 1'b1)
      SyncCapt <= 1'b1;
    else
      SyncCapt <= 1'b0;
end // process p_SYNCSetUPChk;

// ---------------------------------------------------------------------
// Capturing the exact instances of AACISYNC transition in BITCLK domain
// ---------------------------------------------------------------------
always @(negedge PRESETn or SyncCapt)
begin : p_SyncCaptTime
  if (PRESETn == 1'b0)
    begin
      SyncHighFlag <= 1'b0;
      SyncLowFlag  <= 1'b0;
    end
  else if (SyncCapt == 1'b0)
    begin
      SyncLowFlag  <= ! SyncLowFlag;
      SyncLowTime  <= $time;
    end
  else if (SyncCapt == 1'b1)
    begin
      SyncHighFlag  <= ! SyncHighFlag;
      SyncHighTime  <= $time;
    end
end // process p_SyncCaptTime;

// ---------------------------------------------------------------------
// Capturing the actual transition instances on the AACISYNC port
// ---------------------------------------------------------------------
always @(AACISYNC)
begin : p_ActSynctime
  if (AACISYNC == 1'b0)
    SYNCActLTime <= $time; 
  else if (AACISYNC == 1'b1)
    SYNCActHTime <= $time; 
end // process p_ActSynctime;

// ---------------------------------------------------------------------
// Checking the set up periods for the AACISYNC for low to high
// transition
// ---------------------------------------------------------------------
always @(SyncHighFlag)
begin : p_ChkHghSetup
  if ((PRESETn == 1'b1) && (AACITrEn == 1'b1) && (BtClkESync == 1'b1))
    if (SyncHighTime - SYNCActHTime < 
               (AACITrBtClkPrd/2 - `MAXSYNCDELAY))
      $display($time,"Error : AACITB9 : Set up violation for AACISYNC ",
               "low to high transition with respect to falling edge of",
                " BITCLK\n");
end // process p_ChkHghSetup;

// ---------------------------------------------------------------------
// Checking the set up periods for the AACISYNC for high to low
// transition
// ---------------------------------------------------------------------
always @(SyncLowFlag)
begin : p_ChkLowSetup
  if ((PRESETn == 1'b1) && (AACITrEn == 1'b1) && (BtClkESync == 1'b1))
    if (SyncLowTime - SYNCActLTime < 
               (AACITrBtClkPrd/2 - `MAXSYNCDELAY))
      $display($time,"Error : AACITB10 : Set up violation for AACISYNC",
                " high to low transition with respect to falling edge ",
                "of BITCLK\n");
end // process p_ChkLowSetup;

// ---------------------------------------------------------------------
// Sensing the transition instants on the AACISYNC port
// ---------------------------------------------------------------------
always @(AACISYNC)
begin : p_SyncCngeProt
  SYNCChangeTime <= $time;
  SYNCChangeFlag <= ! SYNCChangeFlag;
end // process p_SyncCngeProt;
 
// ---------------------------------------------------------------------
// Capturing the instants of AACISYNC transition in BITCLK domain
// ---------------------------------------------------------------------
always @(posedge BITCLKIn)
begin : p_RsngBClkProt
  BitClkRisingTime <= $time;
end // process p_RsngBClkProt;
 
// ---------------------------------------------------------------------
// Sensing the transition instants on the AACISDATAIN port
// ---------------------------------------------------------------------
always @(AACISDATAIN)
begin : p_SdataInProt
  SDataInCngeFlag  <= ! SDataInCngeFlag;
  SDataInChngeTime <= $time;
end // process p_SdataInProt;
 
// ---------------------------------------------------------------------
// Checking if the AACISDATAIN is delaying more than the allowed
// ---------------------------------------------------------------------
always @(SDataInCngeFlag)
begin : p_SDtaTransProt
  if ((PRESETn == 1'b1) && (AACITrEn == 1'b1) && (BtClkESync == 1'b1) &&
      (WidChkEnSync == 1'b1)&& (SlotState != `ST_SYNC))
    if (SDataInChngeTime - BitClkRisingTime > `MAXSDATADELAY)
      $display($time,"Error : AACITB11 : AACISDATAOUT port is delayed ",
               " more than allowed with respect to rising edge of",
               " BITCLK \n");
end // process p_SDtaTransProt;
 
// ---------------------------------------------------------------------
// Checking if the AACISYNC is delaying more than the allowed
// ---------------------------------------------------------------------
always @(SYNCChangeFlag)
begin : p_SyncTransProt
  if ((PRESETn == 1'b1) && (AACITrEn == 1'b1) && (BtClkESync == 1'b1) &&
       (FORCEDSYNC != 1'b1))
    if (SYNCChangeTime - BitClkRisingTime > `MAXSYNCDELAY)
      $display($time,"Error : AACITB12 : AACISYNC port is delayed more",
              " than allowed with respect to rising edge of BITCLK \n");
end // process p_SyncTransProt;
 
endmodule

// --============================ End ================================--
