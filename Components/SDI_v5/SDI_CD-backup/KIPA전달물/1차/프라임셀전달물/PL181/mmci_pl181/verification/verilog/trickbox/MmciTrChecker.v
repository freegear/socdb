// --=========================================================================--
// This confidential && proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies && copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version && Release Control Information:
//
// File Name              : MmciTrChecker.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module maintains registers which have been
//           loaded in the PCLK domain && syncd to MMCICLK
//           domain. All relevant signals, which are part of the
//           register fields, are driven from this model.This module
//           also contains protocol checkers for various violations
//           of MMCI protocols.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MmciTrChecker (
// Inputs
                     MMCICLK,
                     nMMCIRST,
                     MMCIINTR0,
                     MMCIINTR1,
                     MMCIDMASREQ,
                     MMCIDMABREQ,
                     MMCIDMALSREQ,
                     MMCIDMALBREQ,
                     MMCIPWR,
                     MMCIVDD,
                     MMCIROD,
                     MMCIPower,
                     MMCIClock,
                     MMCICommand,
                     MMCIDataLength,
                     MMCIDataCntl,
                     MMCITBCntl,
                     MMCITBMCLKPeriod,
                     DataCnt,
                     BitCnt,
                     MMCITBReTimWr,
                     MMCITBDtTimWr,
                     MMCITBTokTimWr,
                     MMCITBBsyTimWr,
                     MMCITBPCDisWr,
                     MMCITBStTimWr,
                     MPUpdateSync,
                     MCUpdateSync,
                     MCMUpdateSync,
                     MDLUpdateSync,
                     MDCUpdateSync,
                     MTBCUpdateSync,
                     TokenSent,
                     BlkEnd,
                     PWDATAIn,
                     MMCICMD,
                     MMCIDAT,
// Outputs
                     MMCITBSIGSTAT,
                     ResponseBits,
                     CmdEnable,
                     DataEn,
                     DataDirection,
                     DataMode,
                     DataLength,
                     Blocklen,
                     MDCStg2WrEn,
                     CmdCrcErr,
                     DataCrcErr,
                     TokenErrBit,
                     CmdRespCnt,
                     DataTimeCnt,
                     TokenTimeCnt,
                     BsyTimeCnt,
                     MMCIDMACLR,
                     FifoClear,
                     SendResponse,
                     RxCommand
                     );

// Inputs
input         MMCICLK;          // Main MMCI clock
input         nMMCIRST;         // MMCI reset
input         MMCIINTR0;        // Intr 0 Request from MMCI
input         MMCIINTR1;        // Intr 1 Request from MMCI
input         MMCIDMASREQ;      // DMA Single Req from MMCI
input         MMCIDMABREQ;      // DMA Burst Req from MMCI
input         MMCIDMALSREQ;     // DMA last single Req of MMCI
input         MMCIDMALBREQ;     // DMA last Burst Req from MMCI
input         MMCIPWR;          // Indication of Pwr Phase
input   [3:0] MMCIVDD;          // Output voltage level
input         MMCIROD;          // Open drain resistor En
input   [7:0] MMCIPower;        // 2 stage MMCIPower buffer
input  [10:0] MMCIClock;        // 2 stage MMCIClock buffer
input  [10:0] MMCICommand;      // 2 stg MMCICommand buffer
input  [15:0] MMCIDataLength;   // 2 stg MMCIDataLen buffer
input   [7:0] MMCIDataCntl;     // 2 stg MMCIDataCntl buffer
input  [13:0] MMCITBCntl;       // 2 stg MMCITBCtrl buffer
input  [31:0] MMCITBMCLKPeriod; // Gives the MCLK Period
input  [15:0] DataCnt;          // Counter based on DtTimer
input   [2:0] BitCnt;           // Counter to count each bit Txd/Rxd
input         MMCITBReTimWr;    // WrEn for MMCITBRespTimer
input         MMCITBDtTimWr;    // WrEn for MMCITBDataTimer
input         MMCITBTokTimWr;   // WrEn for MMCITBTkenTimer
input         MMCITBBsyTimWr;   // WrEn for MMCITBBusyTimer
input         MMCITBPCDisWr;    // WrEn for MMCITBPCDisable
input         MMCITBStTimWr;    // WrEn for MMCITBStTimeout
input         MPUpdateSync;     // Updt sig for MMCIPower
input         MCUpdateSync;     // Updt sig for MMCIClock
input         MCMUpdateSync;    // Updt sig for MMCICommand
input         MDLUpdateSync;    // Updt sig for MMCIDataLen
input         MDCUpdateSync;    // Updt sig for MMCIDataCntl
input         MTBCUpdateSync;   // Updt sig for MMCITBCntl
input         TokenSent;        // Qualifies token bits
input         BlkEnd;           // Indicates the end of blk
input  [31:0] PWDATAIn;         // APB Write Data Bus
input         MMCICMD;          // Serial Command line
input         MMCIDAT;          // Serial Data lines

// Outputs
output  [5:0] MMCITBSIGSTAT;    // Stg1 buffer o/p of MMCISIGSTAT
output  [1:0] ResponseBits;     // Reflects the Resp bits in Cmd Reg
output        CmdEnable;        // Command Path enable bit
output        DataEn;           // Data Path enable bit
output        DataDirection;    // Data direction
output        DataMode;         // 0-Streammode, 1-Blockmode
output [15:0] DataLength;       // MMCIDataLen Reg Syncd
output  [3:0] Blocklen;         // Block size from DataCntl
output        MDCStg2WrEn;      // Wr enable for MDC Reg
output        CmdCrcErr;        // Indicates to force error on command
                                // crc
output        DataCrcErr;       // Indicates to force error on data crc
output        TokenErrBit;      // Indicates to force error on token
                                // issued
output [31:0] CmdRespCnt;       // Counts MMCITBRespTimer
output [31:0] DataTimeCnt;      // Counts MMCITBDataTimer
output [15:0] TokenTimeCnt;     // Counts MMCITBTokenTimer
output [15:0] BsyTimeCnt;       // Counts MMCITBBusyTimer
output        MMCIDMACLR;       // Signal to issue DMAClear
output        FifoClear;        // Clear signal for FIFO
output        SendResponse;     // Qualifies response txn
output        RxCommand;        // Qualifies command rx

// Inputs
wire        MMCICLK;          // Main MMCI clock
wire        nMMCIRST;         // MMCI reset
wire        MMCIINTR0;        // Intr 0 Request from MMCI
wire        MMCIINTR1;        // Intr 1 Request from MMCI
wire        MMCIDMASREQ;      // DMA Single Req from MMCI
wire        MMCIDMABREQ;      // DMA Burst Req from MMCI
wire        MMCIDMALSREQ;     // DMA last single Req of MMCI
wire        MMCIDMALBREQ;     // DMA last Burst Req from MMCI
wire        MMCIPWR;          // Indication of Pwr Phase
wire  [3:0] MMCIVDD;          // Output voltage level
wire        MMCIROD;          // Open drain resistor En
wire  [7:0] MMCIPower;        // 2 stage MMCIPower buffer
wire [10:0] MMCIClock;        // 2 stage MMCIClock buffer
wire [10:0] MMCICommand;      // 2 stg MMCICommand buffer
wire [15:0] MMCIDataLength;   // 2 stg MMCIDataLen buffer
wire  [7:0] MMCIDataCntl;     // 2 stg MMCIDataCntl buffer
wire [13:0] MMCITBCntl;       // 2 stg MMCITBCtrl buffer
wire [31:0] MMCITBMCLKPeriod; // Gives the MCLK Period
wire [15:0] DataCnt;          // Counter based on DtTimer
wire  [2:0] BitCnt;           // Counter to count each bit Txd/Rxd
wire        MMCITBReTimWr;    // WrEn for MMCITBRespTimer
wire        MMCITBDtTimWr;    // WrEn for MMCITBDataTimer
wire        MMCITBTokTimWr;   // WrEn for MMCITBTkenTimer
wire        MMCITBBsyTimWr;   // WrEn for MMCITBBusyTimer
wire        MMCITBPCDisWr;    // WrEn for MMCITBPCDisable
wire        MMCITBStTimWr;    // WrEn for MMCITBStTimeout
wire        MPUpdateSync;     // Updt sig for MMCIPower
wire        MCUpdateSync;     // Updt sig for MMCIClock
wire        MCMUpdateSync;    // Updt sig for MMCICommand
wire        MDLUpdateSync;    // Updt sig for MMCIDataLen
wire        MDCUpdateSync;    // Updt sig for MMCIDataCntl
wire        MTBCUpdateSync;   // Updt sig for MMCITBCntl
wire        TokenSent;        // Qualifies token bits
wire        BlkEnd;           // Indicates the end of blk
wire [31:0] PWDATAIn;         // APB Write Data Bus
wire        MMCICMD;          // Serial Command line
wire        MMCIDAT;          // Serial Data lines

// Outputs
wire  [5:0] MMCITBSIGSTAT;    // Stg1 buffer o/p of MMCISIGSTAT
wire  [1:0] ResponseBits;     // Reflects the Resp bits in Cmd Reg
wire        CmdEnable;        // Command Path enable bit
wire        DataEn;           // Data Path enable bit
wire        DataDirection;    // Data direction
wire        DataMode;         // 0-Streammode, 1-Blockmode
wire [15:0] DataLength;       // MMCIDataLen Reg Syncd
wire  [3:0] Blocklen;         // Block size from DataCntl
wire        MDCStg2WrEn;      // Wr enable for MDC Reg
wire        CmdCrcErr;        // Indicates to force error on command
                              // crc
wire        DataCrcErr;       // Indicates to force error on data crc
wire        TokenErrBit;      // Indicates to force error on token
                              // issued
wire [31:0] CmdRespCnt;       // Counts MMCITBRespTimer
wire [31:0] DataTimeCnt;      // Counts MMCITBDataTimer
wire [15:0] TokenTimeCnt;     // Counts MMCITBTokenTimer
wire [15:0] BsyTimeCnt;       // Counts MMCITBBusyTimer
wire        MMCIDMACLR;       // Signal to issue DMAClear
wire        FifoClear;        // Clear signal for FIFO
wire        SendResponse;     // Qualifies response txn
reg         RxCommand;        // Qualifies command rx

// -----------------------------------------------------------------------------
//
//                                MmciTrChecker
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//   This module drives the fields of registers, that are needed in
// other modules.This module also performs the various protocol checks
// associated with the MMCI.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define OFFSET 3.1
// Margin for the various signals

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        MPStg2WrEn;
// Load signal for the second stage buffer of MMCIPower

wire        MCStg2WrEn;
// Load signal for the second stage buffer of MMCIClock

wire        MCMStg2WrEn;
// Load signal for the second stage buffer of MMCICommand

wire        MDLStg2WrEn;
// Load signal for the second stage buffer of MMCIDataLength

wire        iMDCStg2WrEn;
// Load signal for the second stage buffer of MMCIDataCntl

wire        MTBCStg2WrEn;
// Load signal for the second stage buffer of MMCITBCntl

wire  [1:0] iResponseBits;
// local copy of ResponseBits output

wire        iCmdEnable;
// local copy of CmdEnable

wire        iDataDirection;
// local copy of DataDirection output

wire        iDataEn;
// local copy of DataEn output

wire        iDataMode;
// local copy of DataMode output

wire        BusInactive;
// Indicates that Bus, both Cmd & Data is Inactive for more than 8 clks

wire        CmdBit;
// Command Bit received

wire        DataBit0;
// Data Bit received on line 0

wire        MMCICLKREFVALUE;

wire        CLKDIV;
// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         DelMPUpdate;
// Delayed MPUpdateSync signal

reg         DelMCUpdate;
// Delayed MCUpdateSync signal

reg         DelMCMUpdate;
// Delayed MCMUpdateSync signal

reg         DelMDLUpdate;
// Delayed MDLUpdateSync signal

reg         DelMDCUpdate;
// Delayed MDCUpdateSync signal

reg         DelMTBCUpdate;
// Delayed MTBCUpdateSync signal

reg         DelMPUpdate1;
// Delayed DelMPUpdate signal

reg         DelMCUpdate1;
// Delayed DelMCUpdate signal

reg         DelMCMUpdate1;
// Delayed DelMCMUpdate signal

reg         DelMDLUpdate1;
// Delayed DelMDLUpdate signal

reg         DelMDCUpdate1;
// Delayed DelMDCUpdate signal

reg         DelMTBCUpdate1;
// Delayed DelMTBCUpdate signal

reg   [7:0] MP;
// Second stage buffer for MMCIPower Register

reg  [10:0] MC;
// Second stage buffer for MMCIClock Register

reg  [10:0] MCM;
// Second stage buffer for MMCICommand Register

reg  [15:0] MDL;
// Second stage buffer for MMCIDataLength Register

reg   [7:0] MDC;
// Second stage buffer for MMCIDataCntl Register

reg  [13:0] MTBC;
// Second stage buffer for MMCITBCntl Register

reg   [7:0] NextMP;
// D-input of MP

reg  [10:0] NextMC;
// D-input of MC

reg  [10:0] NextMCM;
// D-input of MCM

reg  [15:0] NextMDL;
// D-input of MDL

reg   [7:0] NextMDC;
// D-input of MDC

reg  [13:0] NextMTBC;
// D-input of MTBC

reg  [31:0] MMCITBRespTimer;
// Indicates the delay before the start bit of a Cmd Response

reg  [31:0] MMCITBDataTimer;
// Indicates the delay before the start bit of Data

reg  [15:0] MMCITBTokenTimer;
// Indicates the delay before the start bit of Token

reg  [15:0] MMCITBBusyTimer;
// Indicates the Busy duration

reg  [31:0] MMCITBStTimeout;
// Gives the maximum delay that can exist before MMCI issues a St Bit

reg  [16:0] MMCITBPCDisable;
// Controls disabling of Protocol checks

reg  [31:0] iCmdRespCnt;
// local copy of the CmdRespCnt counter output

reg  [31:0] iDataTimeCnt;
// local copy of the DataTimeCnt counter output

reg  [15:0] iTokenTimeCnt;
// local copy of the TokenTimeCnt counter output

reg  [15:0] iBsyTimeCnt;
// local copy of the BsyTimeCnt counter output

reg         DelDataEn;
// Delayed version of DatEn

reg         DelTokenSent;
// Delayed version of TokenSent

reg         Count0;
// Internal signal to invoke CmdRespCnt

reg         Count1;
// Internal signal to invoke DataTimeCnt

reg         Count2;
// Internal signal to invoke TokenTimeCnt

reg         DelCount2;
// Delayed Count2

reg         Count3;
// Internal signal to invoke BsyTimeCnt

reg         CmdBusInAc;
// Indicates that CmdBus is Inactive for more than 8 clks

reg         DataBusInAc;
// Indicates that DataBus is Inactive for more than 8 clks

reg         CmdlineChk;
// Indicates when to start checking Cmd Bus inactiveness

reg         DatalineChk;
// Indicates when to start checking Data Bus inactiveness

reg   [3:0] CmdClkCnt;
// Indicates when to declare Cmd Bus to be inactive

reg   [3:0] DataClkCnt;
// Indicates when to declare Data Bus to be inactive

reg         CountSt;
// Indicates the Window in which the Nrc && Ncc should be monitored

reg         MMCICLKFallEdge;

reg         MMCICLKRiseEdge;

reg         MMCICLKFlag1;
// Flag for the high phase of MMCICLK

reg         MMCICLKFlag2;
// Flag for the low phase of MMCICLK

reg         EndBitChk;
// Signal to qualify end bit protocol check in pending mode

reg         BlockBit;
// This bit qualifies a bit of a block

reg         BlockErr;
// Indicates whether any error has occured in a block's start or end bit

reg         CmdOver;
// Indicates that Cmd Reception is over

reg         NextRxCommand;
// D-Input to RxCommand;

reg         DelCmdBit;
// Delayed version of Command Bit received

reg         CmdSBit;
// Qualifies start bit of Command path

reg         DelDataBit0;
// Delayed version of Data Bit received on line 0

reg         DataSBit0;
// Qualifies start bit of data on line 0

reg         CmdEBit;
// Qualifies end bit on commmand line

reg         DataEBit0;
// Qualifies end bit on data line 0

reg         iSendResponse;
// Local copy of SendResponse output

reg         DelCmdEnable;
// Delayed value of Del1CmdEnable enable

reg         Del1CmdEnable;
// 1 clock delayed version of CmdEnable

reg         PCEnable;
// Used as an enable for all Protocol checks && defines the
// appropriate window for all protocol checks

reg         MMCITB1En;
// Enables the MMCITB1 protocol check

reg         MMCITB3En;
// Enables the MMCITB3 protocol check

reg         MMCITB4En;
// Enables the MMCITB4 protocol check

reg         MMCITB5En;
// Enables the MMCITB5 protocol check

reg         MMCITB6En;
// Enables the MMCITB6 protocol check

reg         MMCITB7En;
// Enables the MMCITB7 protocol check

reg         MMCITB8En;
// Enables the MMCITB8 protocol check

reg         MMCITB9En;
// Enables the MMCITB9 protocol check

reg         MMCITB10En;
// Enables the MMCITB10 protocol check

reg         MMCITB18En;
// Enables the MMCITB18 protocol check

reg         MMCITB19En;
// Enables the MMCITB19 protocol check

reg         IntCmdBit;
// Internal version of CmdBit with transition less than 1ns width
// being removed

reg         DelCountSt;
// Delayed Version of CountSt

reg         DelCount0;
// Delayed version of Count0

reg         DelDataEBit0;
// Delayed version of DataEBit0

reg         Check;
// Used for protocol checking

reg         StartBit;
// used in block startbit checking

reg         EndBit;
// used in block endbit checking

reg         Start;
// used as trigger in protocol checking

reg   [2:0] Count;
// used to count number of clocks

reg  [31:0] val;
// used to keep track of clocks

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

initial
begin : p_Initialisation
  MMCICLKFallEdge = 1'b0;
  MMCICLKRiseEdge = 1'b0;
  MMCICLKFlag1    = 1'b0;
  MMCICLKFlag2    = 1'b0;
  BlockBit       = 1'b1;
  BlockErr       = 1'b0;
  MMCITB1En       = 1'b0;
  MMCITB3En       = 1'b0;
  MMCITB4En       = 1'b0;
  MMCITB5En       = 1'b0;
  MMCITB6En       = 1'b0;
  MMCITB7En       = 1'b0;
  MMCITB8En       = 1'b0;
  MMCITB9En       = 1'b0;
  MMCITB18En      = 1'b0;
  MMCITB19En      = 1'b0;
  Count          = 1'b0;
  Check          = 1'b0;
  StartBit       = 1'b0;
  EndBit         = 1'b0;
  Start          = 1'b0;
end // p_Initialisation

// ----------------------------------------------------------------------------
// Driving lines from the Registers
// ----------------------------------------------------------------------------
assign ResponseBits     = iResponseBits;
assign CmdEnable        = iCmdEnable;
assign DataEn           = iDataEn;
assign DataDirection    = iDataDirection;
assign DataMode         = iDataMode;
assign DataLength       = MMCIDataLength;
assign Blocklen         = MMCIDataCntl[7:4];

assign iResponseBits    = MCM[7:6];
assign iCmdEnable       = MCM[10];
assign iDataEn          = MDC[0];
assign iDataDirection   = MDC[1];
assign iDataMode        = MDC[2];

assign CmdCrcErr        = MMCITBCntl[0];
assign DataCrcErr       = MMCITBCntl[1];
assign TokenErrBit      = MMCITBCntl[5];
assign MMCIDMACLR       = MMCITBCntl[10];
assign FifoClear        = MMCITBCntl[13] | (iMDCStg2WrEn &
                          (~MMCIDataCntl[1]));
assign MDCStg2WrEn      = iMDCStg2WrEn;

// -------------------------------------------------------------------------
// Driving counter outputs with local copies
// -------------------------------------------------------------------------
assign CmdRespCnt       = iCmdRespCnt;
assign DataTimeCnt      = iDataTimeCnt;
assign TokenTimeCnt     = iTokenTimeCnt;
assign BsyTimeCnt       = iBsyTimeCnt;
assign SendResponse     = iSendResponse;

// -----------------------------------------------------------------------------
// Second stage buffers for the registers.
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_RegSeq
  if (nMMCIRST ==  1'b0)
  begin
    MP   <= 8'h00;
    MC   <= 11'h000;
    MCM  <= 11'h000;
    MDL  <= 16'h0000;
    MDC  <= 8'h00;
    MTBC <= 17'h00000;
  end
  else
  begin
    MP   <= NextMP;
    MC   <= NextMC;
    MCM  <= NextMCM;
    MDL  <= NextMDL;
    MDC  <= NextMDC;
    MTBC <= NextMTBC;
  end
end // p_RegSeq

// -----------------------------------------------------------------------------
// Generation of delayed versions of the Update trigger inputs.
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_TriggerDel
  if (nMMCIRST ==  1'b0)
  begin
    DelMPUpdate1   <= 1'b0;
    DelMPUpdate    <= 1'b0;
    DelMCUpdate1   <= 1'b0;
    DelMCUpdate    <= 1'b0;
    DelMCMUpdate1  <= 1'b0;
    DelMCMUpdate   <= 1'b0;
    DelMDLUpdate1  <= 1'b0;
    DelMDLUpdate   <= 1'b0;
    DelMDCUpdate   <= 1'b0;
    DelMDCUpdate1  <= 1'b0;
    DelMTBCUpdate  <= 1'b0;
    DelMTBCUpdate1 <= 1'b0;
  end
  else
  begin
    if (MMCIClock[10] == 1'b0 && MMCITBMCLKPeriod == 32'h0000000A)
    begin
    DelMPUpdate1   <= MPUpdateSync;
    DelMCUpdate1   <= MCUpdateSync;
    DelMCMUpdate1  <= MCMUpdateSync;
    DelMDLUpdate1  <= MDLUpdateSync;
    DelMDCUpdate1  <= MDCUpdateSync;
    DelMTBCUpdate1 <= MTBCUpdateSync;
    DelMPUpdate    <= DelMPUpdate1;
    DelMCUpdate    <= DelMCUpdate1;
    DelMCMUpdate   <= DelMCMUpdate1;
    DelMDLUpdate   <= DelMDLUpdate1;
    DelMDCUpdate   <= DelMDCUpdate1;
    DelMTBCUpdate  <= DelMTBCUpdate1;
    end
    else
    begin
    DelMPUpdate   <= MPUpdateSync;
    DelMCUpdate   <= MCUpdateSync;
    DelMCMUpdate  <= MCMUpdateSync;
    DelMDLUpdate  <= MDLUpdateSync;
    DelMDCUpdate  <= MDCUpdateSync;
    DelMTBCUpdate <= MTBCUpdateSync;
    end
  end
end // p_TriggerDel

// -----------------------------------------------------------------------------
// Generation of load signals for second stage buffers.
// -----------------------------------------------------------------------------
assign MPStg2WrEn       = MPUpdateSync ^DelMPUpdate;
assign MCStg2WrEn       = MCUpdateSync ^DelMCUpdate;
assign MCMStg2WrEn      = MCMUpdateSync ^DelMCMUpdate;
assign MDLStg2WrEn      = MDLUpdateSync ^DelMDLUpdate;
assign iMDCStg2WrEn     = MDCUpdateSync ^DelMDCUpdate;
assign MTBCStg2WrEn     = MTBCUpdateSync ^DelMTBCUpdate;

// -----------------------------------------------------------------------------
// MPStg2WrEn is used to enable the clocking of MP Input into MP buffer
// -----------------------------------------------------------------------------
always @(MPStg2WrEn or MP or MMCIPower)
begin : p_MPComb
  if (MPStg2WrEn)
    NextMP = MMCIPower;
  else
    NextMP = MP;
end // p_MPComb

// -----------------------------------------------------------------------------
// MCStg2WrEn is used to enable the clocking of MC Input into MC buffer
// -----------------------------------------------------------------------------
always @(MCStg2WrEn or MC or MMCIClock)
begin : p_MCComb
  if (MCStg2WrEn)
    NextMC = MMCIClock;
  else
    NextMC = MC;
end // p_MCComb

// -----------------------------------------------------------------------------
// MDLStg2WrEn is used to enable the clocking of MMCIDataLen Input into
// MDL buffer
// -----------------------------------------------------------------------------
always @(MDLStg2WrEn or MMCIDataLength or MDL)
begin : p_MDLComb
  if (MDLStg2WrEn)
    NextMDL = MMCIDataLength;
  else
    NextMDL = MDL;
end // p_MDLComb

// -----------------------------------------------------------------------------
// MDCStg2WrEn is used to enable the clocking of MDC Input into
// MDC buffer
// -----------------------------------------------------------------------------
always @(iMDCStg2WrEn or MMCIDataCntl or MDC)
begin : p_MDCComb
  if (iMDCStg2WrEn)
    NextMDC = MMCIDataCntl;
  else
    NextMDC = MDC;
end // p_MDCComb

// -----------------------------------------------------------------------------
// MCMStg2WrEn is used to enable the clocking of MCM Input into
// MCM buffer
// -----------------------------------------------------------------------------
always @(MCMStg2WrEn or MMCICommand or MCM)
begin : p_MCMComb
  if (MCMStg2WrEn)
    NextMCM = MMCICommand;
  else
    NextMCM = MCM;
end // p_MCMComb

// -----------------------------------------------------------------------------
// MTBCStg2WrEn is used to enable the clocking of MMCITBCntl Input into
// MTBC buffer
// -----------------------------------------------------------------------------
always @(MTBCStg2WrEn or MMCITBCntl or MTBC)
begin
  if (MTBCStg2WrEn)
    NextMTBC = MMCITBCntl;
  else
    NextMTBC = MTBC;
end // p_MTBCComb

// -----------------------------------------------------------------------------
// Loading MMCITBSIGSTAT Registers
// -----------------------------------------------------------------------------
assign MMCITBSIGSTAT     = ({MMCIINTR1, MMCIINTR0, MMCIDMALBREQ,
                          MMCIDMALSREQ, MMCIDMABREQ, MMCIDMASREQ});

// -----------------------------------------------------------------------------
// Counter for MMCITBRespTimer register.This counter is loaded with
// MMCITBRespTimer value, once the endbit of the cmd is received && when
// the count runs to zero the transmission of response begins
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_CmdRespCntSeq
  if (nMMCIRST ==  1'b0)
  begin
     iCmdRespCnt <= 32'h00000000;
     Count0      <= 1'b0;
  end
  else
  begin
    if (CmdEBit == 1'b1)
    begin
      if (MMCITBRespTimer > 32'b00000000000000000000000000000010)
         iCmdRespCnt <= (MMCITBRespTimer) - 2'b10;
      else
         iCmdRespCnt <= 32'b00000000000000000000000000000001;
      Count0 <= 1'b1;
    end
    else
    begin
      if (Count0 ==  1'b1)
      begin
         iCmdRespCnt <= (iCmdRespCnt) - 1'b1;
         if (iCmdRespCnt == 32'b00000000000000000000000000000001 ||
            iCmdEnable == 1'b0)
           Count0 <= 1'b0;
      end
    end
  end
end // p_CmdRespCntSeq

// ----------------------------------------------------------------------------
// Counter to determine when the token transmission should begin.The
// counter is loaded with MMCITBDataTimer value, once the data
// transmission is enabled && when the counter runs to zero the
// trickbox responds with data.
// ----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DatTimCntSeq
  if (nMMCIRST ==  1'b0)
  begin
     iDataTimeCnt <= 32'h00000000;
     Count1 <= 1'b0;
  end
  else
  begin
    if ((iMDCStg2WrEn & MMCIDataCntl[1] & MMCIDataCntl[0]) | BlkEnd)
    begin
       Count1 <= 1'b1;
      if (MMCITBDataTimer > 32'b00000000000000000000000000000010)
         iDataTimeCnt <= (MMCITBDataTimer) - 2'b10;
      else
         iDataTimeCnt <= 32'b00000000000000000000000000000001;
    end
    else
    begin
      if (Count1 ==  1'b1)
      begin
        iDataTimeCnt <= (iDataTimeCnt) - 1'b1;
        if (iDataTimeCnt == 32'b00000000000000000000000000000001)
          Count1 <= 1'b0;
      end
    end
  end
end // p_DatTimCntSeq

// ----------------------------------------------------------------------------
// Counter to determine when the token transmission should begin.The
// counter is loaded with MMCITBTokenTimer value, on receiving the end
// bit of data && when the counter runs to zero the token
// transmission begins.
// ----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_TokTimCntSeq
  if (nMMCIRST ==  1'b0)
  begin
     iTokenTimeCnt <= 16'h0000;
     Count2 <= 1'b0;
  end
  else
  begin
    if (DataEBit0 & TokenSent & ~iDataMode)
    begin
      Count2 <= 1'b1;
      if (MMCITBTokenTimer > 16'b0000000000000010)
         iTokenTimeCnt <= (MMCITBTokenTimer) - 2'b10;
      else
         iTokenTimeCnt <= 16'b0000000000000010;
    end
    else
    begin
      if (Count2 ==  1'b1)
      begin
        iTokenTimeCnt <= (iTokenTimeCnt) - 1'b1;
        if (iTokenTimeCnt == 16'b0000000000000001)
          Count2 <= 1'b0;
      end
    end
  end
end // p_TokTimCntSeq

// -----------------------------------------------------------------------------
// Delayed version of Count2, used in Busy time counter
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelCount2
  if (nMMCIRST ==  1'b0)
    DelCount2 <= 1'b0;
  else
    DelCount2 <= Count2;
end // p_DelCount2

// -----------------------------------------------------------------------------
// Delayed version of Count0, used in Busy time counter
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelCount0
  if (nMMCIRST ==  1'b0)
    DelCount0 <= 1'b0;
  else
    DelCount0 <= Count0;
end // p_DelCount0

// -----------------------------------------------------------------------------
// Counter to determine busy state duration.This counter is loaded with
// the MMCITBBusyTimer value added with 5 clocks, once token transmission
// begins so at the end of token transmission the counter would hold
// MMCITBBusyTimer value && the MMCIDAT[0] will be held high, indicating
// TrickBox busy, till the counter runs to zero.
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_BsyTimCntSeq
  if (nMMCIRST ==  1'b0)
  begin
     iBsyTimeCnt <= 16'h0000;
     Count3 <= 1'b0;
  end
  else
  begin
    if (Count2 == 1'b0 && DelCount2 == 1'b1)
    begin
      Count3 <= 1'b1;
      if (MMCITBBusyTimer == 16'b0000000000000000)
        iBsyTimeCnt <= (MMCITBBusyTimer) + 3'b101;
      else
        iBsyTimeCnt <= (MMCITBBusyTimer) + 3'b100;
    end
    else
    begin
      if (Count3 ==  1'b1)
      begin
        iBsyTimeCnt <= (iBsyTimeCnt) - 1'b1;
        if (iBsyTimeCnt == 16'b0000000000000001)
           Count3 <= 1'b0;
      end
    end
  end
end // p_BsyTimCntSeq

// -----------------------------------------------------------------------------
// Delayed version of DataEn
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelDataEn
  if (nMMCIRST ==  1'b0)
  begin
    DelDataEn      <= 1'b0;
  end
  else
  begin
    DelDataEn <= iDataEn;
  end
end // p_DelDataEn

// -----------------------------------------------------------------------------
// Delayed version of TokenSent
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelTokenSent
  if (nMMCIRST ==  1'b0)
    DelTokenSent <= 1'b1;
  else
    DelTokenSent <= TokenSent;
end // p_DelTokenSent

// ----------------------------------------------------------------------------
// Generation of Protocol check enable
// ----------------------------------------------------------------------------
always @(posedge MMCICLK)
begin : p_PCEnable
  PCEnable = 1'b0;
  # (`OFFSET);
    PCEnable = 1'b1;
end // p_PCEnable

// ----------------------------------------------------------------------------
// Generation of Protocol check enable for powerup protocol
// ----------------------------------------------------------------------------
always @(MP[1:0])
begin : p_MMCITB1En
  MMCITB1En = 1'b0;
  # ((MMCITBMCLKPeriod) * 2 * (MMCIClock[7:0] + 1));
  # (`OFFSET);
    MMCITB1En = 1'b1;
end // p_MMCITB1En

// ----------------------------------------------------------------------------
// Powerup Phase Protocol Check
// ----------------------------------------------------------------------------
always @(MMCIPWR or MP or MMCITBPCDisable)
begin : p_PowerupPC
  if (~MMCITBPCDisable[0] & PCEnable)
  begin
    if (MP[1:0] == 2'b11)
      if (MMCITB1En & PCEnable)
        if (~MMCIPWR)
        begin
          $write($time, " %m : Error : MMCITB1 : MMCIPWR low during");
          $display ("Poweron phase");
        end
    if (MP[1:0] == 2'b10 || MP[1:0] == 2'b00)
      if (MMCITB1En & PCEnable)
        if (MMCICMD !== 1'bZ || MMCIDAT !== 1'bZ ||
            MMCICLK != 1'b0)
        begin
          $write($time, " %m : Error : MMCITB2 :Outputs not disabled");
          $display("in Powerup phase");
        end
  end
end // p_PowerupPC

// ----------------------------------------------------------------------------
// Generation of Protocol check enable for powersave protocol
// ----------------------------------------------------------------------------
always @(MC)
begin : p_MMCITB3En
  MMCITB3En = 1'b0;
  # (`OFFSET);
    MMCITB3En = 1'b1;
end // p_MMCITB3En

// ----------------------------------------------------------------------------
// Power Save mode Protocol Check
// ----------------------------------------------------------------------------
always @(MC or MMCITBPCDisable)
begin : p_PwrSavePC
  if (~MMCITBPCDisable[2])
    if (MC[9])
      if (MMCITB3En & PCEnable)
        if (BusInactive && MMCICMD === 1'bZ && MMCIDAT === 4'bZZZZ)
        begin
        if (MMCICLK == 1'b1)
          begin
            $write($time, " %m : Error : MMCITB3 : Clock active");
            $display(" in PowerSave Mode");
          end
        end
end // p_PwrSavePC

// ----------------------------------------------------------------------------
// Checking whether the bus is idle
// ----------------------------------------------------------------------------
always @(CmdEBit or DataEBit0 or CmdSBit or DataSBit0)
begin : p_BusCheck
  if (CmdEBit)
    CmdlineChk = 1'b1;
  else if (CmdSBit)
    CmdlineChk = 1'b0;
  if (DataEBit0)
    DatalineChk = 1'b1;
  else if (DataSBit0)
    DatalineChk = 1'b0;
end // p_BusCheck

// ----------------------------------------------------------------------------
// Asserting that the bus has gone idle
// ----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_BusInactive
  if (nMMCIRST == 1'b0)
  begin
    CmdClkCnt   <= 4'b0000;
    DataClkCnt  <= 4'b0000;
    DataBusInAc <= 1'b0;
    CmdBusInAc  <= 1'b0;
  end
  else
  begin
    if (CmdlineChk == 1'b1 && MMCICMD === 1'bZ)
    begin
      CmdClkCnt <= (CmdClkCnt) + 1'b1;
      if (CmdClkCnt == 4'b1000)
        CmdBusInAc <= 1'b1;
    end
    else
    begin
      CmdClkCnt  <= 4'b0000;
      CmdBusInAc <= 1'b0;
    end

    if (DatalineChk)
    begin
      DataClkCnt <= (DataClkCnt) + 1'b1;
      if (DataClkCnt == 4'b1000)
        DataBusInAc <= 1'b1;
    end
    else
    begin
      DataClkCnt  <= 4'b0000;
      DataBusInAc <= 1'b0;
    end
  end
end // p_BusInactive

// ----------------------------------------------------------------------------
// Generating a signal which indicates bus is idle
// ----------------------------------------------------------------------------
assign BusInactive    = CmdBusInAc & DataBusInAc;

// ----------------------------------------------------------------------------
// Delayed Command enable
// ----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelCmdEnable
  if (~nMMCIRST)
  begin
    Del1CmdEnable <= 1'b0;
    DelCmdEnable  <= 1'b0;
  end
  else
  begin
    Del1CmdEnable <= iCmdEnable;
    DelCmdEnable  <= Del1CmdEnable;
  end
end // p_DelCmdEnable

// -----------------------------------------------------------------------------
// Generation of Protocol CheckEn for MMCITB4,MMCITB5,MMCITB6 protocols
// -----------------------------------------------------------------------------
always @(iCmdEnable or DataEn)
begin : p_MMCITB4En
  if (iCmdEnable != DelCmdEnable)
  begin
    MMCITB4En = 1'b0;
    # (`OFFSET);
    MMCITB4En = 1'b1;
  end
  if (DataEn != DelDataEn)
  begin
    MMCITB5En = 1'b0;
    # (`OFFSET);
    MMCITB5En = 1'b1;
  end
end // p_MMCITB4En

// ----------------------------------------------------------------------------
// Checking the state of bus depending on the enable bit
// ----------------------------------------------------------------------------
always @(MMCICMD or MMCIDAT or DelCmdEnable or MDC)
begin : p_BusStateChk
  if (~MMCITBPCDisable[5] & ~MP[6] & ~nMMCIRST)
    if (~DelCmdEnable & ~iCmdEnable)
      if (MMCITB4En)
        if (MMCICMD !== 1'bZ)
        begin
          $write($time, " %m : Error : MMCITB4 : Cmd line active");
          $display("when Cmd Enable bit is 0");
        end

  if (~MMCITBPCDisable[6])
    if (~MDC[0])
      if (MMCITB5En)
        if (MMCIDAT !== 1'bZ)
        begin
          $write($time, " %m : Error : MMCITB5 : Data line active");
          $display("when DataEn bit is 0");
        end

end // p_BusStateChk

// ----------------------------------------------------------------------------
// Generation of Protocol check enable for MMCITB7 protocol
// ----------------------------------------------------------------------------
always @(CmdBit)
begin : p_MMCITB7En
  MMCITB7En = 1'b0;
  # (`OFFSET);
    MMCITB7En = 1'b1;
end // p_MMCITB7En

// ----------------------------------------------------------------------------
// Internal version of CmdBit
// ----------------------------------------------------------------------------
always @(CmdBit)
begin : p_IntCmdBit
  #1 IntCmdBit <= CmdBit;
end // p_IntCmdBit

// ----------------------------------------------------------------------------
// Checking for a one in startbit
// ----------------------------------------------------------------------------
always @(DelCmdBit or CmdBit)
begin : p_BusStartChk
  if (~MMCITBPCDisable[7])
    if (DelCmdBit === 1'bZ && CmdBit != DelCmdBit)
      if (MMCITB7En)
        if (IntCmdBit == 1'b1)
        begin
          $write($time, " %m : Error : MMCITB7 : Start Bit");
          $display("found to contain 1");
        end
end // p_BusStartChk

// ----------------------------------------------------------------------------
// Generation of Protocol check enable for MMCITB8 protocol
// ----------------------------------------------------------------------------
always @(Count0 or iSendResponse)
begin : p_MMCITB8En
  if (iSendResponse)
    if (Count0 == 1'b1 && DelCount0 == 1'b0)
    begin
      MMCITB8En = 1'b0;
      # (`OFFSET);
    MMCITB8En = 1'b1;
    end
end // p_MMCITB8En

// ----------------------------------------------------------------------------
// Interrupt mode Protocol Check
// ----------------------------------------------------------------------------
always @(MCM or MMCICMD or Count0 or iSendResponse or iResponseBits)
begin : p_IntrmodeChk
  if (~MMCITBPCDisable[9])
    if (MCM[8] && iResponseBits != 2'b00 && iResponseBits != 2'b10)
      if (Count0 & iSendResponse)
        if (PCEnable)
          if (MMCICMD !== 1'bZ)
          begin
            $write($time, " %m : Error : MMCITB8 : Cmd line active");
            $display("in Intr mode");
          end
end // p_IntrmodeChk

// ----------------------------------------------------------------------------
// Generation of Protocol check enable for MMCITB9 protocol
// ----------------------------------------------------------------------------
always @(MP)
begin : p_MMCITB9En
  if (MP[6])
  begin
      MMCITB9En = 1'b0;
      # (`OFFSET);
    MMCITB9En = 1'b1;
  end
end // p_MMCITB9En

// ----------------------------------------------------------------------------
// Opendrain mode Protocol Check
// ----------------------------------------------------------------------------
always @(MP or MMCICMD or MMCIDAT)
begin : p_OpenDrainPC
  if (~MMCITBPCDisable[14])
    if (MP[6])
      if (MMCITB9En)
        if (MMCICMD)
        begin
          $write($time, " %m : Error : MMCITB9 :An 1 found on bus");
          $display("during Open Drain Mode");
        end
end // p_OpenDrainPC

// ----------------------------------------------------------------------------
// Generation of Protocol check enable
// ----------------------------------------------------------------------------
always @(PCEnable)
begin : p_MMCITB10En
  if (PCEnable == 1'b1)
  begin
    MMCITB10En = 1'b0;
    # (`OFFSET);
      MMCITB10En = 1'b1;
   end
end // p_MMCITB10En

// ----------------------------------------------------------------------------
// Pending mode Protocol Check
// ----------------------------------------------------------------------------
always @(MCM or MMCICMD or MMCIDAT or iDataMode or DataCnt or BitCnt or
         CmdSBit or CmdEBit or DataEBit0)
begin : p_PendModePC
  if (~MMCITBPCDisable[8])
  begin
    if (MCM[9] & iDataMode)
    begin
      if (DataCnt == 16'b0000000000000101 && BitCnt == 3'b001)
      begin
        EndBitChk = 1'b1;
        if (MMCITB10En & PCEnable)
          if (CmdSBit != 1'b1)
          begin
            $write($time, " %m : Error : MMCITB10 : STOP Command Tx");
            $display("err in Cmd Pend Mode");
          end
      end
      if (MMCITB10En)
        if (CmdSBit)
          if (DataCnt > 16'b0000000000000101)
          begin
            $write($time, " %m : Error : MMCITB10 : STOP Command Tx");
            $display("err in Cmd Pend Mode");
          end
      if (EndBitChk)
      begin
        if (DataEBit0)
        begin
          EndBitChk = 1'b0;
          if (MMCITB10En)
            if (CmdEBit != 1'b1)
            begin
              $write($time, " %m : Error : MMCITB10 : STOP Command Tx");
              $display("err in Cmd Pend Mode");
            end
        end
      end
    end
  end
end // p_PendModePC

// ----------------------------------------------------------------------------
// Checking block start bit && end bit
// ----------------------------------------------------------------------------
always @(iDataEn or iDataMode or DataSBit0 or DataEBit0)
begin : p_BlockStEndPC
  if (~MMCITBPCDisable[10])
  begin
    if (~iDataMode & iDataEn & ~iDataDirection)
    begin
      if (DataSBit0)
      begin
        if (~BlockBit)
        begin
          BlockBit = 1'b1;
          Check = 1'b1;
        end
        if (~StartBit)
        begin
          StartBit = 1'b1;
          EndBit   = 1'b0;
        end
        else
          BlockErr = 1'b1;
      end
      else if (DataEBit0)
      begin
        if (BlockBit)
          BlockBit = 1'b0;
        if (~EndBit)
        begin
          StartBit = 1'b0;
          EndBit   = 1'b1;
        end
        else
          BlockErr = 1'b1;
      end
      else
      begin
        if (~BlockBit & ~Check)
          Count = Count + 3'b001;
        else
        begin
          if (Count < 3'b001 && Check == 1'b1)
          begin
            $write($time, " %m : Error : MMCITB13 : Nwr Timing");
            $display("Check Failure");
          end
          Count = 3'b000;
          Check = 1'b0;
        end
        if (BlockErr == 1'b1 && Check == 1'b0)
        begin
          $write($time, " %m : Error : MMCITB14: Block not bounded");
          $display("by StartBit & EndBit");
          BlockErr = 1'b0;
        end
      end
    end
    else
    begin
      BlockBit = 1'b0;
      Check    = 1'b0;
      StartBit = 1'b0;
      EndBit   = 1'b0;
      BlockErr = 1'b0;
    end
  end
end // p_BlockStEndPC

// ----------------------------------------------------------------------------
// Nrc timing check
// ----------------------------------------------------------------------------
always @(CmdSBit or CmdEBit)
begin : p_NrcPC
  if (~MMCITBPCDisable[11] | ~MMCITBPCDisable[13])
    if (CmdEBit)
      CountSt = 1'b1;
    else if (CmdSBit)
      CountSt = 1'b0;
end // p_NrcPC

// ----------------------------------------------------------------------------
// Delayed version of DataEBit0
// ----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelDataEBit0
  if (nMMCIRST == 1'b0)
    DelDataEBit0 <= 1'b0;
  else
    DelDataEBit0 <= DataEBit0;
end // p_DelDataEBit0

// ----------------------------------------------------------------------------
// Delayed version of CountSt
// ----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_CountSt
  if (nMMCIRST == 1'b0)
    DelCountSt <= 1'b0;
  else
    DelCountSt <= CountSt;
end // p_CountSt

// ----------------------------------------------------------------------------
// Sequential process for Nrc timing check
// ----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_NrcPCSeq
  if (nMMCIRST == 1'b0)
    val = 0;
  else
  begin
    if (CountSt == 1'b1)
      val = val + 1;
    else if (CountSt == 1'b0 && DelCountSt == 1'b1)
    begin
      if (val < 32'h00000007 && iSendResponse == 1'b0)
      begin
        $write($time, " %m : Error : MMCITB15 : Nrc or Ncc");
        $display("Timing Failure");
      end
      val = 0;
    end
  end
end // p_NrcPCSeq

// -----------------------------------------------------------------------------
// Calculation of MMCICLK phase duration from the register
// MMCITBMCLKPeriod, with care being taken for bypass mode
// -----------------------------------------------------------------------------
assign CLKDIV          = (MMCIClock[7:0]);
assign MMCICLKREFVALUE  = ~MMCIClock[10] ?
                         (((MMCITBMCLKPeriod)) * (CLKDIV + 1)):
                         (MMCITBMCLKPeriod) / 2;

// -----------------------------------------------------------------------------
// Getting the period of MMCICLK for later verification
// This process captures the positive && the negative edges of MMCICLK
// The process is sensitized to MMCICLK
// MMCICLKFlag1 is used as a flag for the High Phase
// MMCICLKFlag2 is used as a flag for the Low Phase
// -----------------------------------------------------------------------------
always @(MMCICLK or nMMCIRST or MMCITBPCDisable[16] or MC[9] or
         BusInactive or MCM[10])
begin : p_GetMMCICLKedges
  if (~nMMCIRST | MMCITBPCDisable[16] | (MC[9] & BusInactive) | ~MCM[10])
  begin
    MMCICLKFlag1 = 1'b0;
    MMCICLKFlag2 = 1'b0;
    Start       = 1'b0;
  end
  else if (MMCICLK == 1'b1)
  begin
    if (MMCICLKFlag1 == 1'b0 && (MMCITBPCDisable[16] == 1'b0 &&
       (MC[9] == 1'b1 && BusInactive == 1'b0) &&
        MCM[10] == 1'b1))
    begin
      MMCICLKRiseEdge = $time;
      MMCICLKFlag1 = 1'b1;
      Start = 1'b1;
    end
    if (MMCICLKFlag2 == 1'b1 && (MMCITBPCDisable[16] == 1'b0 &&
      (MC[9] == 1'b1 && BusInactive == 1'b0) &&
       MCM[10] == 1'b1))
    begin
      MMCICLKRiseEdge = $time;
      MMCICLKFlag2 = 1'b0;
      Start = 1'b1;
    end
  end
  else if (MMCICLK == 1'b0)
  begin
    if (MMCICLKFlag2 == 1'b0 && ((MMCITBPCDisable[16] == 1'b0 &&
        (MC[9] == 1'b1 && BusInactive == 1'b0) &&
         MCM[10] == 1'b1) && Start == 1'b1))
    begin
      MMCICLKFallEdge = $time;
      MMCICLKFlag2 = 1'b1;
    end
    if (MMCICLKFlag1 == 1'b1 && ((MMCITBPCDisable[16] == 1'b0 &&
        (MC[9] == 1'b1 && BusInactive == 1'b0) &&
         MCM[10] == 1'b1) && Start == 1'b1))
    begin
      MMCICLKFallEdge = $time;
      MMCICLKFlag1 = 1'b0;
    end
  end
end // p_GetMMCICLKedges

// -----------------------------------------------------------------------------
// Checking for validity of MMCICLK width.
// The difference in time between the rising && the falling edge of the
// MMCICLK is compared with the value calculated from the registers and
// an Offset is provided for Gate Level Simulations.
// -----------------------------------------------------------------------------
always @(MMCICLKFlag2)
begin : p_ChklowphaseSeq
  if (MMCICLKFlag2 == 1'b0 && (MMCITBPCDisable[16] == 1'b0 &&
      (MC[9] == 1'b1 && BusInactive == 1'b0) && MCM[10] == 1'b1))
  begin
    if (((MMCICLKRiseEdge - MMCICLKFallEdge) >
                              ((MMCICLKREFVALUE) + `OFFSET)) ||
        ((MMCICLKRiseEdge - MMCICLKFallEdge) <
                              ((MMCICLKREFVALUE) - `OFFSET)))
    begin
      $write($time, " %m : Error : MMCITB16 :MMCICLK ERROR");
      $display("in the low phase");
    end
  end
end // p_ChklowphaseSeq

always @(MMCICLKFlag1)
begin : p_ChkhighphaseSeq
  if (MMCICLKFlag1 == 1'b0 && (MMCITBPCDisable[16] == 1'b0 &&
      (MC[9] == 1'b1 && BusInactive == 1'b0) && MCM[10] == 1'b1))
  begin
    if (((MMCICLKFallEdge - MMCICLKRiseEdge) >
                                ((MMCICLKREFVALUE) + `OFFSET)) ||
        ((MMCICLKFallEdge - MMCICLKRiseEdge) <
                                ((MMCICLKREFVALUE) - `OFFSET)))
    begin
      $write($time, " %m : Error : MMCITB17 :MMCICLK ERROR");
      $display("in the high phase");
    end
  end
end // p_ChkhighphaseSeq

// ----------------------------------------------------------------------------
// Generation of Protocol checkEn for MMCIVDD protocol
// ----------------------------------------------------------------------------
always @(MMCIPower[5:2])
begin : p_MMCITB18En
  MMCITB18En = 1'b0;
  # (`OFFSET);
    MMCITB18En = 1'b1;
end // p_MMCITB18En

// ----------------------------------------------------------------------------
// Protocol check for MMCIVDD
// ----------------------------------------------------------------------------
always @(MMCIVDD)
begin : p_MMCIVDDCheck
  if (~MMCITBPCDisable[1])
    if (MMCITB18En)
      if (MMCIVDD != MMCIPower[5:2])
      begin
        $write($time, " %m : Error : MMCITB18 : MMCIVDD ERROR");
        $display("");
      end
end // p_MMCIVDDCheck

// ----------------------------------------------------------------------------
// Generation of Protocol checkEn for MMCIROD protocol
// ----------------------------------------------------------------------------
always @(MMCIPower[7])
begin : p_MMCITB19En
  MMCITB19En = 1'b0;
  # (`OFFSET);
    MMCITB19En = 1'b1;
end // p_MMCITB19En

// ----------------------------------------------------------------------------
// Protocol check for MMCIROD
// ----------------------------------------------------------------------------
always @(MMCIROD)
begin : p_MMCIRODCheck
  if (~MMCITBPCDisable[1])
    if (MMCITB19En)
      if (MMCIROD != MMCIPower[7])
      begin
        $write($time, " %m : Error : MMCITB18 : MMCIROD ERROR");
        $display("");
      end
end // p_MMCIRODCheck

// ----------------------------------------------------------------------------
// Tapping the Command && Data Buses
// ----------------------------------------------------------------------------
assign CmdBit        = MMCICMD;
assign DataBit0      = MMCIDAT;

// ----------------------------------------------------------------------------
//  Delayed version of CmdBit
// ----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelayCmdBit
  if (nMMCIRST == 1'b0)
    DelCmdBit <= 1'b0;
  else
    DelCmdBit <= CmdBit;
end // p_DelayCmdBit

// ----------------------------------------------------------------------------
//  Process detects the Command path start && end bit
// ----------------------------------------------------------------------------
always @(CmdBit or DelCmdBit or MP)
begin : p_StartnEndBit
  if (MP[6] == 1'b0)
  begin
    if (DelCmdBit === 1'bZ && CmdBit == 1'b0)
      CmdSBit = 1'b1;
    else if (DelCmdBit == 1'b1 && CmdBit === 1'bZ && iCmdEnable == 1'b1)
      CmdEBit = 1'b1;
    else
    begin
      CmdSBit = 1'b0;
      CmdEBit = 1'b0;
    end
  end
end // p_StartnEndBit

// ----------------------------------------------------------------------------
//  Delayed version of DataBit
// ----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelayDataBit
  if (nMMCIRST == 1'b0)
  begin
    DelDataBit0 <= 1'b0;
  end
  else
  begin
    DelDataBit0 <= DataBit0;
  end
end // p_DelayDataBit

// ----------------------------------------------------------------------------
//  Process detects the Data path start && end bit for line 0
// ----------------------------------------------------------------------------
always @(DataBit0 or DelDataBit0)
begin : p_DStartnEndBit0
  if (DelDataBit0 === 1'bZ && DataBit0 == 1'b0)
    DataSBit0 = 1'b1;
  else if (DelDataBit0 == 1'b1 && DataBit0 === 1'bZ)
    DataEBit0 = 1'b1;
  else
  begin
    DataSBit0 = 1'b0;
    DataEBit0 = 1'b0;
  end
end // p_DStartnEndBit0

// ----------------------------------------------------------------------------
//        Writes to Timer Registers
// ----------------------------------------------------------------------------
always @(MMCITBReTimWr or MMCITBDtTimWr or
         MMCITBTokTimWr or MMCITBBsyTimWr or MMCITBPCDisWr or
         MMCITBStTimWr or nMMCIRST)
begin : p_TimerRegWr
  if (nMMCIRST == 1'b0)
  begin
    MMCITBRespTimer  = 32'h00000000;
    MMCITBDataTimer  = 32'h00000000;
    MMCITBTokenTimer = 16'h0000;
    MMCITBBusyTimer  = 16'h0000;
    MMCITBPCDisable  = 17'h00000;
    MMCITBStTimeout  = 32'h00000000;
  end
  else if (MMCITBReTimWr == 1'b1)
    MMCITBRespTimer  = PWDATAIn;
  else if (MMCITBStTimWr == 1'b1)
    MMCITBStTimeout  = PWDATAIn;
  else if (MMCITBDtTimWr == 1'b1)
    MMCITBDataTimer  = PWDATAIn;
  else if (MMCITBTokTimWr == 1'b1)
    MMCITBTokenTimer = PWDATAIn[15:0];
  else if (MMCITBBsyTimWr == 1'b1)
    MMCITBBusyTimer  = PWDATAIn[15:0];
  else if (MMCITBPCDisWr == 1'b1)
    MMCITBPCDisable  = PWDATAIn[16:0];
end // p_TimerRegWr

// ----------------------------------------------------------------------------
// Handshakes used in command transfer.The SendResponse qualifies the
// time during which a response can be sent && the RxComand qualifies
// the time during which a command can be received, it also takes into
// account the commands recd which require no response.
// ----------------------------------------------------------------------------
always @(CmdEBit or nMMCIRST or iCmdEnable)
begin : p_Cmdhandshakes
  if (~nMMCIRST | ~iCmdEnable)
  begin
    iSendResponse = 1'b0;
    NextRxCommand = 1'b1;
    CmdOver       = 1'b0;
  end
  else
  begin
    if (CmdEBit == 1'b1 && CmdOver == 1'b0)
    begin
      if (iResponseBits == 2'b00 || iResponseBits == 2'b10 ||
          (MMCICommand[8] == 1'b0 &&
           MMCITBRespTimer > 32'b00000000000000000000000001000000))
      begin
        iSendResponse = 1'b0;
        NextRxCommand = 1'b1;
      end
      else
      begin
        iSendResponse = 1'b1;
        NextRxCommand = 1'b0;
        CmdOver       = 1'b1;
      end
    end
    else if (CmdEBit == 1'b1 && CmdOver == 1'b1)
    begin
      iSendResponse = 1'b0;
      NextRxCommand = 1'b1;
      CmdOver       = 1'b0;
    end
  end
end // p_Cmdhandshakes

always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_RxCommand
  if (nMMCIRST == 1'b0)
    RxCommand <= 1'b1;
  else
    RxCommand <= NextRxCommand;
end // p_RxCommand

endmodule

// --================================== End ==================================--
