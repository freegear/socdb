// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : MpmcTrProChkr.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module does the protocol checks on the MPMC
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "MpmcTrParams.v"

// -----------------------------------------------------------------------------

module MpmcTrProChkr (
// Inputs
                      HCLK,
                      HRESETn,
                      MPMCCLKOUT,
                      MPMCCLK,
                      nPOR,
                      MPMCTrExpRef,
                      MPMCTrExBkOff,
                      HREADY0CNT,
                      HREADY1CNT,
                      MPMCTrSRWr,
                      ProtChkMask,
                      MPMCCKEOUT,
                      nMPMCRASOUT,
                      nMPMCCASOUT,
                      MPMCTrDynMEMT,
                      nMPMCDYCSOUT,
                      nMPMCSTCSOUT,
                      MPMCACTLOWCS,
                      nMPMCWEOUT,
                      nMPMCDATAEN,
                      nMPMCOEOUT,
                      MPMCDQMOUT,
                      nMPMCRPOUT,
                      MPMCRPVHHOUT,
                      MPMCSREFACK,
                      MPMCADDROUT,
                      MPMCDATAOUT,
                      MPMCTrDynRfrshWr,
                      MPMCTrDynRfrsh,
                      MPMCTrControl,
                      MPMCTrDynCntl,
                      MPMCEBIREQ,
                      MPMCTrWrPrStat,
                      DataSR,
                      HREADYOutMpmc0,
                      HREADYOutMpmc1,
                      HREADY0ChkEn,
                      HREADY1ChkEn,
// Outputs
                      MPMCEBIGNT,
                      MPMCEBIBACKOFF, 
                      MPMCTrSR
                     );

parameter Tclk = 20;            // HCLK time

// Inputs
input         HCLK;             // Clock Input from AHB
input         HRESETn;          // Reset from AHB
input   [3:0] MPMCCLKOUT;       // Memory clock out from MPMC
input         MPMCCLK;          // Memory clock in to the MPMC
input         nPOR;             // Power On Reset
input   [3:0] MPMCTrExpRef;     // Expected number of refresh cycles
                                // during initialisation
input   [5:0] MPMCTrExBkOff;    // Expected number of clks after which BackOff
                                // is suppossed to be asserted
input   [7:0] HREADY0CNT;       // Expected number of clks beyond which if the
                                // hready0 is low, error message will be
                                // displayed.
input   [7:0] HREADY1CNT;       // Expected number of clks beyond which if the
                                // hready1 is low, error message will be
                                // displayed.
input         MPMCTrSRWr;       // Write Select from the top module
input         ProtChkMask;      // Protocol check mask
input   [3:0] MPMCCKEOUT;       // Clock Enable Pin to memory device
input         nMPMCRASOUT;      // nMPMCRASOUT output from the memory
                                // module
input         nMPMCCASOUT;      // nMPMCCASOUT output from the memory
                                // module
input   [3:0] MPMCTrDynMEMT;    // Indicates the Memory Device type
input   [3:0] nMPMCDYCSOUT;     // Synchronise memory Chip Select from
                                // MPMC
input   [3:0] nMPMCSTCSOUT;     // Memory Bank Select signals from the
                                // MPMC
input   [3:0] MPMCACTLOWCS;     // Active low Memory Bank Select
input         nMPMCWEOUT;       // nMPMCWEOUT output from the memory
                                // module
input   [3:0] nMPMCDATAEN;      // Data Bus enable signal
input         nMPMCOEOUT;       // Memory read enable
input   [3:0] MPMCDQMOUT;       // Data Bus Lane Enable signal
input         nMPMCRPOUT;       // Sync Flash Reset/Power down signal
input         MPMCRPVHHOUT;     // Sync Flash Reset/Power down to be
                                // driven to VHH
input         MPMCSREFACK;      // Self Referesh acknowledg from MPMC
input  [27:0] MPMCADDROUT;      // Memory Address from the MPMC for
                                // checking 'X'es on it
input  [31:0] MPMCDATAOUT;      // Memory Data Out from the MPMC for
                                // checking 'X'es on it
input         MPMCTrDynRfrshWr; // MPMCTrDynRfrsh Register Write
input  [10:0] MPMCTrDynRfrsh;   // Refresh count register
input   [3:0] MPMCTrControl;    // MPMCTrControl Register
input  [15:0] MPMCTrDynCntl;    // MPMCTrDynCntl Register
input   [8:0] DataSR;           // Data Input from the top module
input         MPMCEBIREQ;       // EBI request from the MPMC
input   [3:0] MPMCTrWrPrStat;   // Indicates the write protect status of 
                                // dy memory connected
input         HREADYOutMpmc0;   // HREADYOut from Port0
input         HREADYOutMpmc1;   // HREADYOut from Port1
input         HREADY0ChkEn;      // HREADYOut0 Check Enable
input         HREADY1ChkEn;      // HREADYOut1 Check Enable
// Outputs
output        MPMCEBIGNT;       // EBI grant to the controller
output        MPMCEBIBACKOFF;   // EBI backoff to the controller
output  [8:0] MPMCTrSR;         // MPMCTrSR Register

// Inputs
  wire        HCLK;             // Clock Input from AHB
  wire        HRESETn;          // Reset from AHB
  wire  [3:0] MPMCCLKOUT;       // Memory clock out from MPMC
  wire        MPMCCLK;          // Memory clock in to the MPMC
  wire        nPOR;             // Power On Reset
  wire  [3:0] MPMCTrExpRef;     // Expected number of refresh cycles
                                // during initialisation
  wire  [5:0] MPMCTrExBkOff;    // Expected number of clks after which BackOff
                                // is suppossed to be asserted
  wire  [7:0] HREADY0CNT;       // Expected number of clks beyond which if the
                                // hready0 is low, error message will be
                                // displayed.
  wire  [7:0] HREADY1CNT;       // Expected number of clks beyond which if the
                                // hready1 is low, error message will be
                                // displayed.
  wire        MPMCTrSRWr;       // Write Select from the top module
  wire        ProtChkMask;      // Protocol check mask
  wire  [3:0] MPMCCKEOUT;       // Clock Enable Pin to memory device
  wire        nMPMCRASOUT;      // nMPMCRASOUT output from the memory
                                // module
  wire        nMPMCCASOUT;      // nMPMCCASOUT output from the memory
                                // module
  wire        MPMCEBIREQ;       // EBI request from the MPMC
  wire        MPMCEBIGNT;       // EBI grant to the controller
  wire        MPMCEBIBACKOFF;   // EBI backoff to the controller
  wire  [3:0] MPMCTrDynMEMT;    // Indicates the Memory Device type
  wire  [3:0] MPMCTrWrPrStat;   // Indicates the write protect status of dy
                                // memory connected
  wire  [3:0] nMPMCDYCSOUT;     // Synchronise memory Chip Select from
                                // MPMC
  wire  [3:0] nMPMCSTCSOUT;     // Memory Bank Select signals from the
                                // MPMC
  wire  [3:0] MPMCACTLOWCS;     // Active low Memory Bank Select
  wire        nMPMCWEOUT;       // nMPMCWEOUT output from the memory
                                // module
  wire  [3:0] nMPMCDATAEN;      // Data Bus enable signal
  wire        nMPMCOEOUT;       // Memory read enable
  wire  [3:0] MPMCDQMOUT;       // Data Bus Lane Enable signal
  wire        nMPMCRPOUT;       // Sync Flash Reset/Power down signal
  wire        MPMCRPVHHOUT;     // Sync Flash Reset/Power down to be
                                // driven to VHH
  wire        MPMCSREFACK;      // Self Referesh acknowledg from MPMC
  wire [27:0] MPMCADDROUT;      // Memory Address from the MPMC for
                                // checking 'X'es on it
  wire [31:0] MPMCDATAOUT;      // Memory Data Out from the MPMC for
                                // checking 'X'es on it
  wire        MPMCTrDynRfrshWr; // MPMCTrDynRfrsh Register Write
  wire [10:0] MPMCTrDynRfrsh;   // Refresh count register
  wire  [3:0] MPMCTrControl;    // MPMCTrControl Register
  wire [15:0] MPMCTrDynCntl;    // MPMCTrDynCntl Register
  wire  [8:0] DataSR;           // Data Input from the top module
  wire        HREADYOutMpmc0;   // HREADY from port0 of MPMC
  wire        HREADYOutMpmc1;   // HREADY from port1 of MPMC

// Outputs
  reg   [8:0] MPMCTrSR;         // MPMCTrSR Register
  integer i;

// -----------------------------------------------------------------------------
//
//                                MpmcTrProChkr
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This module checks for the diffrent command issued by the MPMC. It checks
// the following aspects of the MPMC:
//   x The SDRAM/SyncFLASH initialisation sequence
//   x Refresh command frequency and validity of the refresh command sequence
//   x Multiple assertion of static/dynamic chip selects
//   x Memory command signals going to 'X's
//   x Checks if the clock is running when the command is issued
//   x Checks if the clock enable is pulled to active properly
//   x MPMC disabled mode operation checks
//   x MPMC low power mode operation checks
//   x Behaviour of RP/RPVHH signals
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define RefTolerance     8'b00011111
// Tolerance count for refresh command

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        nReset;

wire        ValidRefCmd;
// Indicates a valid refresh command has been issued

wire        NxtSREF;
// D-Input to SREF

wire        NxtRefCmd;
// D-input for RefCmd

wire  [2:0] NxtRefWidth;
// D-input for RefWidth

wire  [3:0] NxtRefCount;
// D-input for RefCount

wire        NxtInitChkEn;
// D-input for InitChkEn

wire        NxtModeRegCmd;
// D-Input to ModeRegCmd

wire  [6:0] NxtModeRegCount;
// D-Input to ModeRegCount

wire        NxtRefCheckEn;
// D-input for RefCheckEn

wire        NxtMonitorRef;
// D-input for MonitorRef

wire        NxtNOP;
// D-Input to NOP

wire [10:0] ExpRefCycles;
// Refresh cycle frequency

wire [10:0] NxtExpRefCycles;
// D-input for ExpRefCycles

wire        NxtPALL;
// D-Input to PALL

wire        NxtPreCharge;
// D-Input to PreCharge

wire  [3:0] DelnMPMCDYCSOUT;
// Delayed version of the nMPMCDYCSOUT

wire  [3:0] DelnMPMCSTCSOUT;
// Delayed version of the MPMCACTLOWCS

wire  [8:0] NxtMPMCTrSR;
// D-input for MPMCTrSR

wire  [3:0] ClkDiff;
// Signal difine the phase differences between MPMCCLK and MPMCCLKOUT

wire  [3:0] DelClkDiff;
// Delayed clock diff to mask off the gate dealys glitches

wire        MPMCEn;
// Enable bit of MPMCTrControl Register

wire        LowPower;
// Low power mode bit of MPMCTrControl Register

wire        ClkEn;
// Synchronous memory clock enable control bit of MPMCTrDynCntl Register

wire        ClkCntl;
// Synchronous memory clock control bit of MPMCTrDynCntl Register

wire        DisClkOut;
// Disabling the MPMCCLKOUT when DisClkOut is high

wire  [1:0] ResPwrDwn;
// SyncFlash Reset/Power down signal bit of MPMCTrDynCntl Register

wire        A10;
// Addr(10) output from the memory module used to find PALL command

wire        NxtSyncFlashSel;
// D- input for SYNCFLASH Select status

wire        RefWindow;
// When it is HIGH, it is expecting a refresh command

wire        MaskedRef;
// Indicates that a refresh is masked since it is a SyncFLASH

wire        NxtDyWrite;
// D-input of DyWrite

wire       CntFlag;
// Control flag

wire       ValidRefCmdCo;
// ORing the ValidRefCmd and ValidRefCmdQ

wire       TakeRegEbiSig;
// Used to select the type of EBI signals

wire       TakeRanEbiSig;
// Used to select the type of EBI signals

wire   HREADY0CNTRFlag;
wire   HREADY1CNTRFlag;


// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg   [2:0] PresentState;
// State vector for the initialisation check logic

reg   [2:0] NxtState;
// D-input for the State vector

reg         InitSeqErrSt;
// Indicates the initialisation sequence error

reg         NxtInitSeqErrSt;
// D-input for InitSeqErrSt

reg         RefCmd;
// Indicates a refresh command has arrived at the command signals from MPMC

reg         DelayRefCmd;
// Delayed version of RefCmd

reg   [2:0] RefWidth;
// Indicates the the status of the chip selects which are refreshed

reg         RefStatus;
// Indicates that the required number of refresh commands have been issued
// during initialisation

reg         NxtRefStatus;
// D-input for RefStatus

reg   [3:0] RefCount;
// Refresh count during initialisation

reg  [15:0] RefCycles;
// Refresh up-counter : Counts-up till it gets a valid refresh

reg  [15:0] NxtRefCycles;
// D-input for RefCycles

reg         ModeRegChk;
// LMR command check enable during initialisation

reg         NxtModeRegChk;
// D-input for ModeRegChk

reg         InitChkEn;
// Initialisation check enable

reg         ModeRegCmd;
// Indicates a LMR has arrived at the command signals from MPMC

reg   [6:0] ModeRegCount;
// Number of LMRs issued

reg         RefCheckEn;
// Refresh check enable signal

reg         MonitorRef;
// Indicates that the protocol checker is waiting for a valid refresh command
// within the time-out window of RefCycles

reg         RefErrStat;
// Indicates that either a refresh miss or refresh timing violation has
// occurred

reg         NxtRefErrStat;
// D-input for RefErrStat

reg         NxtMPMCEBIGNT;
// D-input for MPMCEBIGNT

reg         NOP;
// NOP command Detect Ouptut

reg         PALL;
// PALL command Detect Ouptut

reg         PreCharge;
// Precharge command Detect Ouptut

reg   [3:0] CkeStart;
// Indicates the time when MPMCCKEOUT goes high after the CE bit is enabled

reg         MclkStart;
// Indicates the start of the MPMCCLKOUT

reg         SyncFlashSel;
// SYNCFLASH Select status

reg         RefMiss;
// Refresh is missing in the refresh window

reg         NxtRefMiss;
// D-input for RefMiss

reg         ResetAssrtd;
// Indicates the start of checks

reg         ResetOver;
// Indicates the start of checks

reg         DelRefWindow;
// Used to time the rising edge of RefWindow

reg         SREF;
// SREF command Detect Ouptut

reg  [3:0] MPMCCKEOUTQ;
// Clked version of MPMCCKEOUT

reg        iMPMCEBIGNT;
// Internal version of MPMCEBIGNT

reg        MPMCEBIGNTQ;
// Clked version of MPMCEBIGNT

reg        iMPMCEBIBACKOFF;
// Clked version of MPMCEBIBACKOFF

reg        ValidRefCmdQ;
// Clocked version of ValidRefCmd

reg  [12:0] Cntr;
reg  [12:0] NxtCntr;

reg        ValidRefCmdCoQ;
// Clock the ValidRefCmdCo

reg  [12:0] iMPMCTrExBkOff;
// Internal copy of MPMCTrExBkOff

reg         DyWrite;
// Indicates dynamic write

reg  [7:0] HREADY0CNTR;
reg  [7:0] HREADY1CNTR;

reg  [7:0] NxtHREADY0CNTR;
reg  [7:0] NxtHREADY1CNTR;

reg  [4:0] NxtPRBS;
// D-input of PRBS

reg  [4:0] PRBS;
// The random value to generate the EBI signal

reg        RandEBIGNT;
// Used to generate the EBIGNT signal

reg        RandEBIBACKOFF;
// Used to generate the EBIBACKOFF signal

reg         NxtMPMCEBIBACKOFF;
// D-input for MPMCEBIBACKKOFF

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of Code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Generation of internal signals from register bit fields
// -----------------------------------------------------------------------------
assign MPMCEn           = MPMCTrControl[0];
assign LowPower         = MPMCTrControl[2];
assign ClkEn            = MPMCTrDynCntl[0] & MPMCTrControl[0] &
                          ~(MPMCTrDynCntl[13]);
assign ClkCntl          = MPMCTrDynCntl[1] & MPMCTrControl[0] &
                          (~(MPMCTrDynCntl[5]));
assign DisClkOut        = MPMCTrDynCntl[5];
assign ResPwrDwn[0]     = MPMCTrDynCntl[14];
assign ResPwrDwn[1]     = MPMCTrDynCntl[15];
assign A10              = MPMCADDROUT[10];

// -----------------------------------------------------------------------------
// Ebi Random value generation and Ebi signals decoding
// -----------------------------------------------------------------------------
assign TakeRanEbiSig    = MPMCTrExBkOff[5] & MPMCTrExBkOff[2] &
                          ~(MPMCTrExBkOff[4]);
assign TakeRegEbiSig    = MPMCTrExBkOff[5] & ~(MPMCTrExBkOff[2]);


// -----------------------------------------------------------------------------
// Allows a tolerance for the Refresh frequency
// -----------------------------------------------------------------------------
assign RefWindow        = ((RefCycles > ((ExpRefCycles*16) - `RefTolerance)) &
                           (RefCycles < ((ExpRefCycles*16) + `RefTolerance))) ?
                          1'b1 : 1'b0;

always @(negedge HRESETn or posedge MPMCCLK)
begin : p_DelRefWinSeq
  if (HRESETn == 1'b0)
    DelRefWindow <= 1'b0;
  else
    DelRefWindow <= RefWindow;
end // p_DelRefWinSeq

// -----------------------------------------------------------------------------
// Clock the HREADY0 counter
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge MPMCCLK)
begin : p_HREADYChkSeq
  if (HRESETn == 1'b0)
    HREADY0CNTR <= 8'b00000000;
  else
    HREADY0CNTR <= NxtHREADY0CNTR;
end // p_HREADYChkSeq

// -----------------------------------------------------------------------------
// Clock the HREADY1 counter
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge MPMCCLK)
begin : p_HREADY1ChkSeq
  if (HRESETn == 1'b0)
    HREADY1CNTR <= 8'b00000000;
  else
    HREADY1CNTR <= NxtHREADY1CNTR;
end // p_HREADY1ChkSeq

// -----------------------------------------------------------------------------
// HREADY0 counter
// -----------------------------------------------------------------------------
always @(HREADYOutMpmc0 or HREADY0CNTR)
begin : p_HREADYChkComb
  if ((HREADYOutMpmc0 == 1'b1) | (HREADY0CNTR == HREADY0CNT))
    NxtHREADY0CNTR = 8'b00000000;
  else
    NxtHREADY0CNTR = HREADY0CNTR + 1;
  end // p_HREADYChkComb

// -----------------------------------------------------------------------------
// HREADY1 counter
// -----------------------------------------------------------------------------
always @(HREADYOutMpmc1 or HREADY1CNTR)
begin : p_HREADY1ChkComb
  if ((HREADYOutMpmc1 == 1'b1) | (HREADY1CNTR == HREADY1CNT))
    NxtHREADY1CNTR = 8'b00000000;
  else
    NxtHREADY1CNTR = HREADY1CNTR + 1;
  end // p_HREADY1ChkComb

assign HREADY0CNTRFlag = (HREADY0CNTR == HREADY0CNT) ? 1'b1 : 1'b0;
assign HREADY1CNTRFlag = (HREADY1CNTR == HREADY1CNT) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Display the error message if the HREADYOutMpmc0 is low for more than
// HREADY0CNT clocks
// -----------------------------------------------------------------------------
always @(HREADY0CNTRFlag)
begin : p_HREADY0ChkDispComb
 if ((HREADY0CNTRFlag == 1'b1) & (ProtChkMask == 1'b0) & (HREADY0ChkEn == 1'b1))
    $display("Error : Time %t : MPMCTR49: HREADY0 is low for more than %d clks", $time, HREADY0CNT);
end // p_HREADY0ChkDispComb

// -----------------------------------------------------------------------------
// Display the error message if the HREADYOutMpmc1 is low for more than
// HREADY1CNT clocks
// -----------------------------------------------------------------------------
always @(HREADY1CNTRFlag)
begin : p_HREADY1ChkDispComb
 if ((HREADY1CNTRFlag == 1'b1) & (ProtChkMask == 1'b0) & (HREADY1ChkEn == 1'b1))
    $display("Error : Time %t : MPMCTR50: HREADY1 is low for more than %d clks", $time, HREADY1CNT);
end // p_HREADY1ChkDispComb

// -----------------------------------------------------------------------------
// Checks if a refresh command is missed in the refresh tolerance window
// -----------------------------------------------------------------------------
always @(RefWindow or ValidRefCmd or RefMiss)
begin : p_WatchRefComb
  if ((RefWindow == 1'b1) & (DelRefWindow == 1'b0))
    NxtRefMiss = 1'b1;
  else if (RefWindow == 1'b1 & ValidRefCmd == 1'b1)
    NxtRefMiss = 1'b0;
  else if (RefWindow == 1'b0 & RefMiss == 1'b1)
    NxtRefMiss = 1'b0;
end // p_WatchRefComb

// -----------------------------------------------------------------------------
// Clocking in the RefMiss at HCLK
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_RefMissSeq
  if (HRESETn == 1'b0)
    RefMiss <= 1'b0;
  else
    begin
      if (RefWindow == 1'b0)
        RefMiss <= NxtRefMiss;
    end
end // p_RefMissSeq

// -----------------------------------------------------------------------------
// Refresh Check Error Status
// -----------------------------------------------------------------------------
always @(ExpRefCycles or ValidRefCmd or MonitorRef or RefCycles or
         RefErrStat or MPMCTrSRWr or DataSR or RefMiss or RefCheckEn)
begin : p_RefErrStatComb
  if (MPMCTrSRWr == 1'b1 & DataSR[8] == 1'b0)
    NxtRefErrStat    = 1'b0;

  if (ValidRefCmd == 1'b1 & MonitorRef == 1'b1)
    begin
      if ((RefCycles < ((ExpRefCycles*16) - 4)) |
          (RefCycles > ((ExpRefCycles*16) + 4)))
        NxtRefErrStat    = 1'b1;
    end
  else if (RefMiss == 1'b1 & RefCheckEn == 1'b1)
    NxtRefErrStat    = 1'b1;
  else
    NxtRefErrStat    = RefErrStat;
end // p_RefErrStatComb

// -----------------------------------------------------------------------------
// Clocking in Refresh check error status
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge nReset)
begin : p_RefErrStatSeq
  if (nReset == 1'b0)
    RefErrStat       <= 1'b0;
  else
    RefErrStat       <= NxtRefErrStat;
end // p_RefErrStatSeq

// -----------------------------------------------------------------------------
// Clocking the MPMCCKEOUT 
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge nReset)
begin : p_CKECmdSeq
  if (nReset == 1'b0)
    MPMCCKEOUTQ      <= 4'b1111;
  else
    MPMCCKEOUTQ      <= MPMCCKEOUT;
end // p_CKECmdSeq

// -----------------------------------------------------------------------------
// Expected Refresh Cycles
// -----------------------------------------------------------------------------
assign ExpRefCycles     = MPMCTrDynRfrsh;

// -----------------------------------------------------------------------------
// Refresh Check Enable generation logic
// -----------------------------------------------------------------------------
assign NxtMonitorRef    = (MPMCTrDynRfrshWr == 1'b1) ? 1'b0    :
                           ((ValidRefCmd == 1'b1) ? RefCheckEn : MonitorRef);

// -----------------------------------------------------------------------------
// Clocking in Refresh Check Enable
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK or negedge nReset)
begin : p_MonitorRefSeq
  if (nReset == 1'b0)
    MonitorRef       <= 1'b0;
  else
    MonitorRef       <= NxtMonitorRef;
end // p_MonitorRefSeq

// -----------------------------------------------------------------------------
// Phase Delayed Refresh Check Enable
// -----------------------------------------------------------------------------
assign NxtRefCheckEn    = (MPMCTrSRWr == 1'b1) ? DataSR[7] : RefCheckEn;

// -----------------------------------------------------------------------------
// Phase Delayed Refresh Check Enable
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge nReset)
begin : p_RefCheckEnSeq
  if (nReset == 1'b0)
    RefCheckEn       <= 1'b0;
  else
    RefCheckEn       <= NxtRefCheckEn;
end // p_RefCheckEnSeq

// -----------------------------------------------------------------------------
// Mode Register Command signal generation logic
// -----------------------------------------------------------------------------
assign NxtModeRegCmd    = (~(nMPMCRASOUT) & ~(nMPMCCASOUT) &
                           ~(nMPMCWEOUT) & ~(nMPMCDYCSOUT[0] &
                           nMPMCDYCSOUT[1] & nMPMCDYCSOUT[2] &
                           nMPMCDYCSOUT[3]));

// -----------------------------------------------------------------------------
// Clocking in Mode Register Command
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK or negedge nReset)
begin : p_ModeRegComSeq
  if (nReset == 1'b0)
    ModeRegCmd       <= 1'b0;
  else
    ModeRegCmd       <= NxtModeRegCmd;
end // p_ModeRegComSeq

// -----------------------------------------------------------------------------
// Mode Register Command Counter generation logic
// -----------------------------------------------------------------------------
assign NxtModeRegCount  = (InitChkEn == 1'b0) ? 7'b0000000            :
                           ((ModeRegCmd == 1'b1) ? (ModeRegCount) + 1 :
                           ModeRegCount);

// -----------------------------------------------------------------------------
// Clocking in Mode Register Command Counter
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK or negedge nReset)
begin : p_ModeRegCntSeq
  if (nReset == 1'b0)
    ModeRegCount <= 7'b0000000;
  else
    ModeRegCount <= NxtModeRegCount;
end // p_ModeRegCntSeq

// -----------------------------------------------------------------------------
// Mode Register Command Check signal generation logic
// -----------------------------------------------------------------------------
always @(ModeRegCount or ModeRegChk or InitChkEn)
begin : p_MdeRegChkComb
  if (InitChkEn == 1'b0)
    NxtModeRegChk    = 1'b0;
  else if ((ModeRegCount == 7'b0000100))
    NxtModeRegChk    = 1'b1;
  else
    NxtModeRegChk    = ModeRegChk;
end // p_MdeRegChkComb

// -----------------------------------------------------------------------------
// Clocking in Mode Register Command Check
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK or negedge nReset)
begin : p_MdeRegChkSeq
  if (nReset == 1'b0)
    ModeRegChk <= 1'b0;
  else
    ModeRegChk <= NxtModeRegChk;
end // p_MdeRegChkSeq

// -----------------------------------------------------------------------------
// NOP Condition Check signal geneation logic
// ---------------------------------------------------------------------------
assign NxtNOP           = MPMCCKEOUT[0] & MPMCCKEOUT[1] & MPMCCKEOUT[2] &
                          MPMCCKEOUT[3] & ~(nMPMCDYCSOUT[0]) &
                          ~(nMPMCDYCSOUT[1]) & ~(nMPMCDYCSOUT[2]) &
                          ~(nMPMCDYCSOUT[3]) & nMPMCRASOUT & nMPMCCASOUT
                          & nMPMCWEOUT;

// -----------------------------------------------------------------------------
// Clocking in NOP Condition Check signal
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK or negedge nReset)
begin : p_NOPSeq
  if (nReset == 1'b0)
    NOP <= 1'b0;
  else
    NOP <= NxtNOP;
end // p_NOPSeq

// -----------------------------------------------------------------------------
// Initialization Sequence Check StateMachine
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK or negedge nReset)
begin : p_StateSeq
  if (nReset == 1'b0)
    PresentState <= 3'b000;
  else
    PresentState <= NxtState;
end // p_StateSeq

// -----------------------------------------------------------------------------
// Initialization Sequence Check Status
// -----------------------------------------------------------------------------
always @(PresentState or InitSeqErrSt or ModeRegChk)
begin : p_PStateComb
  if (MPMCTrSRWr == 1'b1 & DataSR[1] == 1'b0)
    NxtInitSeqErrSt  = 1'b0;

  if ((PresentState == 3'b100) & ModeRegChk == 1'b1)
    NxtInitSeqErrSt  = 1'b1;
  else
    NxtInitSeqErrSt  = InitSeqErrSt;
end // p_PStateComb

// -----------------------------------------------------------------------------
// Registering Initialization Sequence Check Status
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge nReset)
begin : p_PStateSeq
  if (nReset == 1'b0)
    InitSeqErrSt <= 1'b0;
  else
    InitSeqErrSt <= NxtInitSeqErrSt;
end // p_PStateSeq

// -----------------------------------------------------------------------------
// SyncFlash Select status
// -----------------------------------------------------------------------------
assign NxtSyncFlashSel  = (~(nMPMCDYCSOUT[0]) & MPMCTrDynMEMT[0]) |
                           (~(nMPMCDYCSOUT[1]) & MPMCTrDynMEMT[1]) |
                           (~(nMPMCDYCSOUT[2]) & MPMCTrDynMEMT[2]) |
                           (~(nMPMCDYCSOUT[3]) & MPMCTrDynMEMT[3]);

// -----------------------------------------------------------------------------
// Clocking in SyncFlash Select status
// -----------------------------------------------------------------------------
always @(negedge nReset or posedge MPMCCLK)
begin : p_SynFlsSelSeq
  if (nReset == 1'b0)
    SyncFlashSel <= 1'b0;
  else
    SyncFlashSel <= NxtSyncFlashSel;
end // p_SynFlsSelSeq

// -----------------------------------------------------------------------------
//   Next State logic generation
// -----------------------------------------------------------------------------
always @(PresentState or NOP or PALL or RefStatus or NxtModeRegChk or
         ModeRegCmd or InitChkEn or PreCharge)
begin : p_NStateComb
  NxtState         = PresentState;
  case (PresentState)
    3'b000 :
      begin
        if (InitChkEn == 1'b1)
          NxtState         = 3'b001;
      end
    3'b001 :
      begin
        if (InitChkEn == 1'b0)
          NxtState         = 3'b000;
        else if (SyncFlashSel == 1'b1 & ModeRegCmd == 1'b1)
          NxtState         = 3'b000;
        else if (PreCharge == 1'b1)
          begin
            if (ProtChkMask == 1'b0)
              $display("Error : Time %t : MPMCTR3: PreCharge Command received while NOP is expected", $time);
          end
        else if (PALL == 1'b1)
          begin
            if (ProtChkMask == 1'b0)
              $display("Error : Time %t : MPMCTR4: PALL Command received while NOP is expected", $time);
          end
        else if (ModeRegCmd == 1'b1)
          begin
            if (ProtChkMask == 1'b0)
              $display("Error : Time %t : MPMCTR5: MODE Command received while NOP is expected", $time);
          end
        else if (NOP == 1'b1)
          NxtState         = 3'b010;
      end
    3'b010 :
      begin
        if (InitChkEn == 1'b0)
          NxtState         = 3'b000;
        else if (PALL == 1'b1)
          NxtState         = 3'b011;
        else if (ModeRegCmd == 1'b1)
          begin
            if (ProtChkMask == 1'b0)
              $display("Error : Time %t : MPMCTR6: MODE Command received while PALL is expected", $time);
          end
      end
    3'b011 :
      begin
        if (InitChkEn == 1'b0)
          NxtState         = 3'b000;
        else if (NOP == 1'b1)
          begin
            if (ProtChkMask == 1'b0)
              $display("Error : Time %t : MPMCTR7: NOP has been issued more than once", $time);
          end
        else if (RefStatus == 1'b1)
          NxtState         = 3'b100;
      end
    3'b100 :
      begin
        if (InitChkEn == 1'b0)
          NxtState         = 3'b000;
        else if (PALL == 1'b1)
          begin
            if (ProtChkMask == 1'b0)
              $display("Error : Time %t : MPMCTR8: PALL has been issued more than once", $time);
          end
        else if (NOP == 1'b1)
          begin
            if (ProtChkMask == 1'b0)
              $display("Error : Time %t : MPMCTR9: NOP has been issued more than once", $time);
          end
        if (NxtModeRegChk == 1'b1)
          NxtState         = 3'b000;
      end
    default :
      NxtState         = 3'b000;
  endcase
end // p_NStateComb

// -----------------------------------------------------------------------------
// nReset Generation
// -----------------------------------------------------------------------------
assign nReset           = HRESETn & nPOR;

// -----------------------------------------------------------------------------
// InitChkEn bit generation logic
// -----------------------------------------------------------------------------
assign NxtInitChkEn     = (MPMCTrSRWr == 1'b1) ? DataSR[0] :
                          ((InitSeqErrSt == 1'b1) ?   1'b0 : InitChkEn);

// -----------------------------------------------------------------------------
// Clocking in InitChkEn bit
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge nReset)
begin : p_InitChkEnSeq
  if (nReset == 1'b0)
    InitChkEn        <= 1'b0;
  else
    InitChkEn        <= NxtInitChkEn;
end // p_InitChkEnSeq

// -----------------------------------------------------------------------------
// Refresh Command Generation
// -----------------------------------------------------------------------------
assign NxtRefCmd        = ~(nMPMCRASOUT) & ~(nMPMCCASOUT) & nMPMCWEOUT &
                           MPMCCKEOUT[0] & MPMCCKEOUT[1] & MPMCCKEOUT[2] &
                           MPMCCKEOUT[3] & ((nMPMCDYCSOUT[0] &
                           nMPMCDYCSOUT[1] & (nMPMCDYCSOUT[2] ^
                           nMPMCDYCSOUT[3])) | (nMPMCDYCSOUT[2] &
                           nMPMCDYCSOUT[3] & (nMPMCDYCSOUT[1] ^
                           nMPMCDYCSOUT[0])));

// -----------------------------------------------------------------------------
// Clocking in Refresh Command
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK or negedge nReset)
begin : p_RefCmdSeq
  if (nReset == 1'b0)
    RefCmd <= 1'b0;
  else
    RefCmd <= NxtRefCmd;
end // p_RefCmdSeq

// -----------------------------------------------------------------------------
// Refresh Command Validity Check
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK or negedge nReset)
begin : p_DelayRefCommSeq
  if (nReset == 1'b0)
    DelayRefCmd <= 1'b0;
  else
    DelayRefCmd <= RefCmd;
end // p_DelayRefCommSeq

// -----------------------------------------------------------------------------
// Generate refresh check mask for SyncFLASH. The Mpmc masks the refresh
// cycles to a SyncFLASH if the chip selects are populated with SDRAMs and
// SyncFLASHs. MaskedRef enables the refresh check mechanism to proceed even if
// a refresh to a chip select is missed from the sequence because of being a
// SyncFLASH.
// -----------------------------------------------------------------------------
assign MaskedRef        = (RefWidth == 3'b001 & MPMCTrDynMEMT[1] == 1'b1) |
                          (RefWidth == 3'b010 & MPMCTrDynMEMT[2] == 1'b1) |
                          (RefWidth == 3'b011 & MPMCTrDynMEMT[3] == 1'b1) ?
                           1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Refresh Width generation. If a SyncFLASH is connected to a chip select, it
// skips that one and proceeds to the next.
// -----------------------------------------------------------------------------
assign NxtRefWidth      = (NxtRefCmd == 1'b1 & nMPMCDYCSOUT[0] == 1'b0 &
                           MPMCTrDynMEMT[0] == 1'b0 & RefWidth == 3'b000) ?
                           3'b001 :
                          ((NxtRefCmd == 1'b1 & nMPMCDYCSOUT[1] == 1'b0 &
                           ((MPMCTrDynMEMT[1] == 1'b0 & RefWidth == 3'b001) |
                           (MPMCTrDynMEMT[0] == 1'b1 & RefWidth == 3'b000))) ?
                           3'b010 :
                          ((NxtRefCmd == 1'b1 & nMPMCDYCSOUT[2] == 1'b0 &
                           ((MPMCTrDynMEMT[2] == 1'b0 & RefWidth == 3'b010) |
                           (MPMCTrDynMEMT[1] == 1'b1 & RefWidth == 3'b001) |
                           (MPMCTrDynMEMT[1:0] == 2'b11 &
                           RefWidth == 3'b000))) ?
                           3'b011 :
                          ((NxtRefCmd == 1'b1 & nMPMCDYCSOUT[3] == 1'b0 &
                           ((MPMCTrDynMEMT[3] == 1'b0 & RefWidth == 3'b011) |
                           (MPMCTrDynMEMT[2] == 1'b1 & RefWidth == 3'b010) |
                           (MPMCTrDynMEMT[2:1] == 2'b11 & RefWidth == 3'b001) |
                           (MPMCTrDynMEMT[2:0] == 3'b111 &
                            RefWidth == 3'b000))) ?
                           3'b100   :
                          ((RefWidth == 3'b100) | (MPMCTrDynMEMT[3] == 1'b1 &
                           RefWidth == 3'b011) | (MPMCTrDynMEMT[3:2] == 2'b11 &
                           RefWidth == 3'b010) | (MPMCTrDynMEMT[3:1] == 3'b111 &
                           RefWidth == 3'b001) |
                           (MPMCTrDynMEMT[3:0] == 4'b1111) ?
                           3'b000 : RefWidth))));

// -----------------------------------------------------------------------------
// Clocking in Refresh Width
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK or negedge nReset)
begin : p_NREfWidthSeq
  if (nReset == 1'b0)
    RefWidth <= 3'b000;
  else
    RefWidth <= NxtRefWidth;
end // p_NREfWidthSeq

// -----------------------------------------------------------------------------
// A valid completion of a refresh sequence. The RefWidth logic takes care of
// the missed (SyncFLASH) refreshes.
// -----------------------------------------------------------------------------
assign ValidRefCmd      = ((RefCmd == 1'b0) & (DelayRefCmd == 1'b1) &
                           (RefWidth == 3'b000)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Refresh request validity check
// -----------------------------------------------------------------------------
always @(negedge MPMCCLK)
begin : p_ValRefReqSeq
  if ((RefCmd == 1'b0 & DelayRefCmd == 1'b1 & ValidRefCmd == 1'b0 &
      MaskedRef == 1'b0) | (RefMiss == 1'b1 & RefCheckEn == 1'b1))
    begin
      if (ProtChkMask == 1'b0)
        $display("Error : Time %t : MPMCTR10: Not Valid Refresh Request", $time); 
    end
end // p_ValRefReqSeq

// -----------------------------------------------------------------------------
// Refresh Command Counter : Enabled only when InitChkEn bit is On.
// -----------------------------------------------------------------------------
assign NxtRefCount      = (PresentState != 3'b011) ? 4'h0            :
                           ((ValidRefCmd == 1'b1) ? ((RefCount) + 1) :
                           RefCount);

// -----------------------------------------------------------------------------
// Updating Refresh Command Counter
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK or negedge nReset)
begin : p_RefCountSeq
  if (nReset == 1'b0)
    RefCount <= 4'h0;
  else
    RefCount <= NxtRefCount;
end // p_RefCountSeq

// -----------------------------------------------------------------------------
// No of Refresh Command Check
// -----------------------------------------------------------------------------
always @(RefCount or RefStatus or PresentState)
begin : p_NRefStateComb
  if (PresentState == 3'b011)
    begin
      if (RefCount == MPMCTrExpRef)
        NxtRefStatus     = 1'b1;
      else
        NxtRefStatus     = 1'b0;
    end
  else if (PresentState != 3'b011)
    NxtRefStatus     = 1'b0;
  else
    NxtRefStatus     = RefStatus;
end // p_NRefStateComb

// -----------------------------------------------------------------------------
// Clocking in RefStatus
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK or negedge nReset)
begin : p_NRefStateSeq
  if (nReset == 1'b0)
    RefStatus <= 1'b0;
  else
    RefStatus <= NxtRefStatus;
end // p_NRefStateSeq

// -----------------------------------------------------------------------------
// Clock the ValidRefCmd 
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge MPMCCLK)
begin : p_ValidRefSeq
  if (HRESETn == 1'b0)
    ValidRefCmdQ = 1'b0;
  else
    ValidRefCmdQ = ValidRefCmd;
end //p_ValidRefSeq

assign ValidRefCmdCo = ValidRefCmdQ || ValidRefCmd;

// -----------------------------------------------------------------------------
// Clock the ValidRefCmd
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_ValidRefCoSeq
  if (HRESETn == 1'b0)
    ValidRefCmdCoQ = 1'b0;
  else
    ValidRefCmdCoQ = ValidRefCmdCo;
end //p_ValidRefCoSeq
// -----------------------------------------------------------------------------
// No of Cycles between two Refresh Command
// -----------------------------------------------------------------------------
always @(ValidRefCmdCoQ or RefCycles)
begin : p_RefCycComb
  if (ValidRefCmdCoQ == 1'b1)
    NxtRefCycles     = 16'h0000;
  else
    NxtRefCycles     = (RefCycles) + 1;
end // p_RefCycComb

// -----------------------------------------------------------------------------
// Refresh cycles interval counter updation
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge nReset)
begin : p_RefCycSeq
  if (nReset == 1'b0)
    RefCycles <= 16'h0000;
  else
    RefCycles <= NxtRefCycles;
end // p_RefCycSeq

// -----------------------------------------------------------------------------
// PALL Check
// -----------------------------------------------------------------------------
assign NxtPALL          = ~(nMPMCRASOUT) & nMPMCCASOUT & ~(nMPMCWEOUT) & A10;

// -----------------------------------------------------------------------------
// Dynamic write check
// -----------------------------------------------------------------------------
assign NxtDyWrite       = (nMPMCRASOUT) & ~(nMPMCCASOUT) & ~(nMPMCWEOUT);

// -----------------------------------------------------------------------------
// Clocking in PALL Command
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK or negedge nReset)
begin : p_PALLSeq
  if (nReset == 1'b0)
    PALL <= 1'b0;
  else
    PALL <= NxtPALL;
end // p_PALLSeq

// -----------------------------------------------------------------------------
// Clocking in DyWrite Command
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK or negedge nReset)
begin : p_DyWriteSeq
  if (nReset == 1'b0)
    DyWrite <= 1'b0;
  else
    DyWrite <= NxtDyWrite;
end // p_DyWriteSeq

// -----------------------------------------------------------------------------
// PreCharge Check
// -----------------------------------------------------------------------------
assign NxtPreCharge     = ~(nMPMCRASOUT) & nMPMCCASOUT & ~(nMPMCWEOUT) & ~(A10);

// -----------------------------------------------------------------------------
// Clocking in PreCharge Command
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK or negedge nReset)
begin : p_PreChargeSeq
  if (nReset == 1'b0)
    PreCharge <= 1'b0;
  else
    PreCharge <= NxtPreCharge;
end // p_PreChargeSeq

// -----------------------------------------------------------------------------
// SREF Check
// -----------------------------------------------------------------------------
assign NxtSREF          = ~(nMPMCRASOUT) & ~(nMPMCCASOUT) & nMPMCWEOUT &
                           ((MPMCCKEOUT[3] & MPMCCKEOUT[2] & MPMCCKEOUT[1] &
                           ~(MPMCCKEOUT[0]) & ~(nMPMCDYCSOUT[0])) |
                           (MPMCCKEOUT[3] & MPMCCKEOUT[2] & ~(MPMCCKEOUT[1]) &
                           ~(MPMCCKEOUT[0]) & ~(nMPMCDYCSOUT[1])) |
                           (MPMCCKEOUT[3] & ~(MPMCCKEOUT[2]) & ~(MPMCCKEOUT[1])&
                           ~(MPMCCKEOUT[0]) & ~(nMPMCDYCSOUT[2])) |
                           (~(MPMCCKEOUT[3]) & ~(MPMCCKEOUT[2]) & 
                           ~(MPMCCKEOUT[1])& ~(MPMCCKEOUT[0]) & 
                           ~(nMPMCDYCSOUT[3])));
// -----------------------------------------------------------------------------
// Clocking in SREF command
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK or negedge nReset)
begin : p_SREFSeq
  if (nReset == 1'b0)
    SREF             <= 1'b0;
  else
    SREF             <= NxtSREF;
end // p_SREFSeq

// -----------------------------------------------------------------------------
// Data Register
// -----------------------------------------------------------------------------
assign NxtMPMCTrSR      = {RefErrStat, MonitorRef, MPMCCKEOUT, SREF,
                           InitSeqErrSt, InitChkEn};

// -----------------------------------------------------------------------------
// Clocking out Data Register
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge nReset)
begin : p_MPMCTrSRSeq
  if (nReset == 1'b0)
    MPMCTrSR <= 9'b000000000;
  else
    MPMCTrSR <= NxtMPMCTrSR;
end // p_MPMCTrSRSeq

// -----------------------------------------------------------------------------
// Generate Delayed nMPMCSTCSOUT
// -----------------------------------------------------------------------------
assign # 2 DelnMPMCSTCSOUT  = MPMCACTLOWCS;
assign # 2 DelnMPMCDYCSOUT  = nMPMCDYCSOUT;

// -----------------------------------------------------------------------------
// Check for multiple Static Chip Select assertion
// -----------------------------------------------------------------------------
always @(DelnMPMCSTCSOUT)
begin : p_MSChipSelComb
  if (ResetOver == `TRUE)
    begin
      if (DelnMPMCSTCSOUT == MPMCACTLOWCS)
        begin
          if ((MPMCACTLOWCS !== 4'hE) && (MPMCACTLOWCS !== 4'hD) &&
              (MPMCACTLOWCS !== 4'hB) && (MPMCACTLOWCS !== 4'h7) &&
              (MPMCACTLOWCS !== 4'hF))
            if ((ProtChkMask == 1'b0) & (InitChkEn == 1'b0))
              $display("Error : Time %t : MPMCTR7: Multiple Static Memory Chip Selects are asserted simultaneously", $time);
        end
    end
end // p_MSChipSelComb

// -----------------------------------------------------------------------------
// Check for multiple Dynamic Chip Select assertion
// -----------------------------------------------------------------------------
always @(DelnMPMCDYCSOUT)
begin : p_MDChipSelComb
  if (ResetOver == `TRUE)
    begin
      if ((DelnMPMCDYCSOUT == nMPMCDYCSOUT) & (NxtPALL == 1'b0))
        begin
          if ((nMPMCDYCSOUT !== 4'hE) && (nMPMCDYCSOUT !== 4'hD) &&
              (nMPMCDYCSOUT !== 4'hB) && (nMPMCDYCSOUT !== 4'h7) &&
              (nMPMCDYCSOUT !== 4'hF))
            if ((ProtChkMask == 1'b0) & (InitChkEn == 1'b0))
              $display("Error : Time %t : MPMCTR8: Multiple Dynamic Memory Chip Selects are asserted simultaneously", $time);
        end
    end
end // p_MDChipSelComb

// -----------------------------------------------------------------------------
// StartCheck signal is set once the Reset is applied
// -----------------------------------------------------------------------------
always @(HRESETn or ResetAssrtd)
begin : p_ResetOverComb
  if ((ResetAssrtd) && HRESETn == 1'b1)
     ResetOver <= `TRUE;
end // p_ResetOverComb

always @(posedge HCLK)
begin : p_ResetStrComb
  if (HRESETn == 1'b0)
    ResetAssrtd <= `TRUE;
end // p_ResetStrComb

// -----------------------------------------------------------------------------
// 'X' check on MPMC related signal.
// -----------------------------------------------------------------------------
always @(ResetOver or MPMCDATAOUT or MPMCADDROUT or nMPMCSTCSOUT or
         nMPMCDATAEN or nMPMCWEOUT or MPMCDQMOUT or nMPMCOEOUT or
         nMPMCDYCSOUT or MPMCCKEOUT or MPMCCLKOUT or nMPMCRASOUT or
         nMPMCCASOUT)
begin : p_XCheckComb
  if (ResetOver == `TRUE)
    begin
      if ((MPMCDATAOUT == 32'h00000000) === 1'bx)
        $display("MPMCTR9: X(es) found in MPMCDATAOUT");

      if ((MPMCADDROUT == 26'b00000000000000000000000000) === 1'bx)
        $display("MPMCTR10: MPMCTB2: X(es) found in MPMCADDROUT");

      if ((nMPMCSTCSOUT == 4'h0) === 1'bx)
        $display("MPMCTR11: X(es) found in nMPMCSTCSOUT");

      if ((nMPMCDYCSOUT == 4'h0) === 1'bx)
        $display("MPMCTR12: X(es) found in nMPMCDYCSOUT");

      if ((nMPMCDATAEN == 4'h0) === 1'bx)
        $display("MPMCTR13: X(es) found in nMPMCDATAEN");

      if ((nMPMCWEOUT == 1'b0) === 1'bx)
        $display("MPMCTR14: X found in nMPMCWEOUT");

      if ((MPMCDQMOUT == 4'h0) === 1'bx)
        $display("MPMCTR15: X(es) found in MPMCDQMOUT");

      if ((nMPMCOEOUT == 1'b0) === 1'bx)
        $display("MPMCTR16: X found in nMPMCOEOUT");

      if ((MPMCCLKOUT == 1'b0) === 1'bx)
        $display("MPMCTR17: X found in MPMCCLKOUT");

      if ((MPMCCKEOUT == 1'b0) === 1'bx)
        $display("MPMCTR18: X(es) found in MPMCCKEOUT");

      if ((nMPMCRASOUT == 1'b0) === 1'bx)
        $display("MPMCTR19: X found in nMPMCRASOUT");

      if ((nMPMCCASOUT == 1'b0) === 1'bx)
        $display("MPMCTR20: X found in nMPMCCASOUT");

      if ((MPMCSREFACK == 1'b0) === 1'bx)
        $display("MPMCTR20: X found in MPMCSREFACK");
    end
end // p_XCheckComb

// -----------------------------------------------------------------------------
// Checks MPMCCLKOUT when DisClkOut high
// -----------------------------------------------------------------------------
always @(DisClkOut or MPMCCLKOUT)
begin : p_DisMClkComb
  if (DisClkOut == 1'b1)
    if (MPMCCLKOUT != 4'b1111)
      $display("MPMCTR53: MPMCCLKOUT is running with DMC high",$time);
end // p_DisMClkComb  

// -----------------------------------------------------------------------------
// Generation of ClkDiff
// -----------------------------------------------------------------------------
assign ClkDiff[0]       = MPMCCLKOUT[0] ^ MPMCCLK;
assign ClkDiff[1]       = MPMCCLKOUT[1] ^ MPMCCLK;
assign ClkDiff[2]       = MPMCCLKOUT[2] ^ MPMCCLK;
assign ClkDiff[3]       = MPMCCLKOUT[3] ^ MPMCCLK;

assign # 1 DelClkDiff       = ClkDiff;

always @(negedge nPOR or posedge MPMCCLK)
begin : p_MClkSeq
  if (nPOR == 1'b0)
    MclkStart <= 1'b1;
  else
    begin
      if (ClkCntl == 1'b1 & nMPMCDYCSOUT != 4'b1111)
        begin
          MclkStart <= 1'b1;
            if (DelClkDiff != 4'b0000)
              $display("Error : Time %t : MPMCTR1: MPMCCLKOUT should start running prior to the command", $time);
        end
      else if (ClkCntl == 1'b0)
        MclkStart <= 1'b0;
    end
end // p_MClkSeq

always @(negedge nPOR or posedge MPMCCLK)
begin : p_CkeStrtSeq
  if (nPOR == 1'b0)
    CkeStart <= 4'hF;
  else
    begin
      if (ClkEn == 1'b1 & nMPMCDYCSOUT != 4'b1111)
        begin
          CkeStart <= ~(nMPMCDYCSOUT);
          if ((~(nMPMCDYCSOUT) & MPMCCKEOUT) != ~(nMPMCDYCSOUT))
            $display("Error : Time %t : MPMCTR2: MPMCCKEOUT should be issued prior to the command", $time);
        end
      else if (ClkEn == 1'b0)
        CkeStart <= 4'h0;
    end
end // p_CkeStrtSeq

// -----------------------------------------------------------------------------
// MPMC Enable/Disable check
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK)
begin : p_MPMCEnChkComb
  if ((ResetOver) & (MPMCEn == 1'b0))
    begin
      if (ValidRefCmd == 1'b1)
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR26: Refresh has been issued while MPMC is in disabled mode", $time);
        end

      if (MPMCDQMOUT != 4'b1111)
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR27: MPMCDQMOUT signals are active during disabled mode", $time);
        end

      if (nMPMCOEOUT != 1'b1)
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR28: nMPMCOEOUT is active during disabled mode", $time);
        end

      if (nMPMCDATAEN != 4'b1111)
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR29: nMPMCDATAEN signals are active during disabled mode", $time);
        end

      if ((NxtPALL == 1'b0) & (nMPMCWEOUT != 1'b1))
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time  %t : MPMCTR30: nMPMCWEOUT is active during disabled mode", $time);
        end

      if ((DelnMPMCSTCSOUT == MPMCACTLOWCS) & (MPMCACTLOWCS != 4'b1111))
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR31: nMPMCSTCSOUT signals are active during disabled mode", $time);
        end

      if ((NxtPALL == 1'b0) & (NxtRefCmd == 1'b0) & (nMPMCDYCSOUT != 4'b1111))
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR32: nMPMCDYCSOUT signals are active during disabled mode", $time);
        end

      if ((NxtPALL == 1'b0) & (NxtRefCmd == 1'b0) & (nMPMCCASOUT != 1'b1))
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR33: nMPMCCASOUT is active during disabled mode", $time);
        end

      if ((NxtPALL == 1'b0) & (NxtRefCmd == 1'b0) & (nMPMCRASOUT != 1'b1))
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR34: nMPMCRASOUT is active during disabled mode", $time);
        end
    end
end // p_MPMCEnChkComb

// -----------------------------------------------------------------------------
// MPMC Low power mode check
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK)
begin : p_LowPwrChkComb
  if ((ResetOver) & (LowPower == 1'b1))
    begin
      if (MPMCDQMOUT != 4'b1111)
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR35: MPMCDQMOUT signals are active during Low power mode", $time);
        end

      if (nMPMCOEOUT != 1'b1)
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR36 : nMPMCOEOUT is active during Low power mode", $time);
        end

      if (nMPMCDATAEN != 4'b1111)
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR37: nMPMCDATAEN signals are active during Low power mode", $time);
        end

      if ((NxtPALL == 1'b0) & (nMPMCWEOUT != 1'b1))
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR38: nMPMCWEOUT is active during Low power mode", $time);
        end

      if (MPMCACTLOWCS != 4'b1111)
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR39: nMPMCSTCSOUT signals are active during Low power mode", $time);
        end

      if ((NxtPALL == 1'b0) & (NxtRefCmd == 1'b0) & (nMPMCDYCSOUT != 4'b1111))
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR40: nMPMCDYCSOUT signals are active during Low power mode", $time);
        end

      if ((NxtPALL == 1'b0) & (NxtRefCmd == 1'b0) & (nMPMCCASOUT != 1'b1))
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR41: nMPMCCASOUT is active during Low power mode", $time);
        end

      if ((NxtPALL == 1'b0) & (NxtRefCmd == 1'b0) & (nMPMCRASOUT != 1'b1))
        begin
          if (ProtChkMask == 1'b0)
            $display("Error : Time %t : MPMCTR42: nMPMCRASOUT is active during Low power mode", $time);
        end
    end
end // p_LowPwrChkComb

// -----------------------------------------------------------------------------
// MPMC Clock Enable/Disable check
// -----------------------------------------------------------------------------
always @(MPMCCKEOUT or ClkEn or CkeStart or MclkStart or ClkDiff or
         ResetOver or DelClkDiff)
begin : p_SyCntlchkComb
  if (ResetOver)
    begin
      if (ClkEn == 1'b1)
        begin
          if ((CkeStart & MPMCCKEOUT) != CkeStart)
            if (ProtChkMask == 1'b0)
              $display("Error : Time %t : MPMCTR43: MPMCCKEOUT signal(s) are disable while 'CE' bit is set", $time);
        end

      if (MclkStart == 1'b1)
        begin
          if (DelClkDiff[0] != 1'b0)
            if (ProtChkMask == 1'b0)
              $display("Error : Time %t : MPMCTR44: MPMCLKOUT0 is not running continuously while 'CS' bit is set", $time);

          if (DelClkDiff[1] != 1'b0)
            if (ProtChkMask == 1'b0)
              $display("Error : Time %t : MPMCTR45: MPMCLKOUT1 is not running continuously while 'CS' bit is set", $time);

          if (DelClkDiff[2] != 1'b0)
            if (ProtChkMask == 1'b0)
              $display("Error : Time %t : MPMCTR46: MPMCLKOUT2 is not running continuously while 'CS' bit is set", $time);

          if (DelClkDiff[3] != 1'b0)
            if (ProtChkMask == 1'b0)
              $display("Error : Time %t : MPMCTR47: MPMCLKOUT3 is not running continuously while 'CS' bit is set", $time);
        end
    end
end // p_SyCntlchkComb

// -----------------------------------------------------------------------------
// Reset/Power down pin status check
// -----------------------------------------------------------------------------
always @(MPMCCLK)
begin : p_ResPwrDwnSeq
  if (ResetOver)
    begin
      if (ResPwrDwn != ({MPMCRPVHHOUT, nMPMCRPOUT}))
        if (ProtChkMask == 1'b0)
          $display("Error : Time %t : MPMCTR48: The Reset/Power down signals do not follow 'RP' bit", $time);
    end
end // p_ResPwrDwnSeq

// -----------------------------------------------------------------------------
// Check for the write protect in case of SDRAM
// -----------------------------------------------------------------------------
always @(MPMCTrWrPrStat or DyWrite or nMPMCDYCSOUT)
begin : p_DyWrPrChk
  for (i = 0; i < 4; i = i+1)
  begin
    if (MPMCTrWrPrStat[i] == 1'b1 & (nMPMCDYCSOUT[i] == 1'b0))
    begin
      if (DyWrite == 1'b1) 
        $display("Error : Time %t : MPMCTR54:Write operation initiated for the write protected chip", $time);
    end
  end
end // p_DyWrPrChk

// -----------------------------------------------------------------------------
// EBIGNT generator
// -----------------------------------------------------------------------------
always @(MPMCEBIREQ or TakeRegEbiSig or TakeRanEbiSig or MPMCTrExBkOff or
         RandEBIGNT)
begin : p_EbiGntGenComb
  if (TakeRegEbiSig == 1'b1)
    NxtMPMCEBIGNT = MPMCTrExBkOff[1];
  else if (TakeRanEbiSig == 1'b1)
    NxtMPMCEBIGNT = RandEBIGNT;
  else if (MPMCEBIREQ == 1'b1)
    NxtMPMCEBIGNT = 1'b1;
  else
    NxtMPMCEBIGNT = 1'b0;
end //p_EbiGntGenComb

// -----------------------------------------------------------------------------
// Increase the backoff counter value
// -----------------------------------------------------------------------------
always @(MPMCTrExBkOff)
begin : p_BackOffCntComb
  if (MPMCTrExBkOff != 6'b111111)
    iMPMCTrExBkOff = MPMCTrExBkOff;
  else
    iMPMCTrExBkOff = 13'b1111111111111;
  end // p_BackOffCntComb

// -----------------------------------------------------------------------------
// Generating the EBIBACKOFF signal
// -----------------------------------------------------------------------------
always @(iMPMCEBIGNT or CntFlag or Cntr or MPMCTrExBkOff)
begin : p_BACKOFFCNTR
  NxtCntr = Cntr;
  if (iMPMCEBIGNT == 1'b0)
    NxtCntr = iMPMCTrExBkOff;
  else if (CntFlag != 1'b1)
    NxtCntr = Cntr - 1;
end
// -----------------------------------------------------------------------------
// Counter which assists to raise the BackOff signal
// -----------------------------------------------------------------------------

always @(posedge HCLK or negedge HRESETn)
begin : p_CNTRSeq
  if (HRESETn == 1'b0)
    Cntr = 6'b111111; 
  else
    Cntr = NxtCntr;
end
// -----------------------------------------------------------------------------
// Flag to indicate the assertion of the BackOff signal
// -----------------------------------------------------------------------------
assign CntFlag = (Cntr == 2'b00) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Clock the EBIGNT
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_GntSeq
  if (HRESETn == 1'b0)
    MPMCEBIGNTQ <= 1'b0;
  else
    MPMCEBIGNTQ <= iMPMCEBIGNT;
end

// -----------------------------------------------------------------------------
// Assertion of BackOff signal
// -----------------------------------------------------------------------------
always @(CntFlag or iMPMCEBIGNT or MPMCEBIGNTQ or iMPMCEBIBACKOFF or
         TakeRegEbiSig or nPOR or TakeRanEbiSig or MPMCTrExBkOff or
         RandEBIBACKOFF)
begin : p_BackOffGen
  NxtMPMCEBIBACKOFF = iMPMCEBIBACKOFF;
  if (nPOR == 1'b0)
    NxtMPMCEBIBACKOFF = 1'b0;
  else if (TakeRegEbiSig == 1'b1)
    NxtMPMCEBIBACKOFF <= ~(MPMCTrExBkOff[0]);
  else if (TakeRanEbiSig == 1'b1)
    NxtMPMCEBIBACKOFF = RandEBIBACKOFF;
  else if(iMPMCEBIGNT == 1'b0)
    NxtMPMCEBIBACKOFF = 1'b0;
  else if (CntFlag == 1'b1 & MPMCEBIGNTQ == 1'b1)
    NxtMPMCEBIBACKOFF = 1'b1;
end //p_BackOffGen

// -----------------------------------------------------------------------------
// Clking the GNT and BACKOFF signals
// -----------------------------------------------------------------------------
always @(negedge nPOR or posedge MPMCCLK)
begin : p_EbiGntSeq
  if (nPOR == 1'b0)
    begin
      iMPMCEBIGNT      <= 1'b1;
      iMPMCEBIBACKOFF  <= 1'b0;
    end
  else 
    begin
      iMPMCEBIGNT      <= NxtMPMCEBIGNT;
      iMPMCEBIBACKOFF  <= NxtMPMCEBIBACKOFF;
    end
end //p_EbiGntSeq

// -----------------------------------------------------------------------------
// Random number generation
// -----------------------------------------------------------------------------
always @(PRBS)
begin : p_PRBSComb
  NxtPRBS[0] = PRBS[1];
  NxtPRBS[1] = PRBS[2];
  NxtPRBS[2] = PRBS[3];
  NxtPRBS[3] = PRBS[4];
  NxtPRBS[4] = ~(PRBS[4] ^ PRBS[1]);
end // p_PRBSComb

// -----------------------------------------------------------------------------
// Sequence process for PRBS
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge nPOR)
begin : p_PRBSSeq
  if (nPOR == 1'b0)
    PRBS <= 5'b00000;
  else
    PRBS <= NxtPRBS;
end // p_PRBSSeq

// -----------------------------------------------------------------------------
// Random EBI Grant signals generation
// -----------------------------------------------------------------------------
always @(MPMCEBIREQ)
begin : p_GntRandComb
  if (MPMCEBIREQ == 1'b1)
    begin
      # (Tclk * PRBS) RandEBIGNT = MPMCEBIREQ;
    end
  else
    begin
      RandEBIGNT  = 1'b0;
    end
end // p_GntRandComb

// -----------------------------------------------------------------------------
// Random EBI Grant signals generation
// -----------------------------------------------------------------------------
always @(NxtMPMCEBIGNT)
begin : p_BackRandComb
  if (NxtMPMCEBIGNT == 1'b1)
    begin
      # (Tclk * PRBS) RandEBIBACKOFF = NxtMPMCEBIGNT;
    end
  else
    begin
      RandEBIBACKOFF  = 1'b0;
    end
end // p_BackRandComb

assign MPMCEBIGNT      = iMPMCEBIGNT;
assign MPMCEBIBACKOFF  = iMPMCEBIBACKOFF;

endmodule

// --================================== End ==================================--
