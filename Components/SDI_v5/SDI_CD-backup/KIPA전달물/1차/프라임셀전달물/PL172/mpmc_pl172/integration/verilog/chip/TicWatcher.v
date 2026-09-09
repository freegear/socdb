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
// File Name              : TicWatcher.v.rca
// File Revision          : 1.6
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Protocol checker for the TIC
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module TicWatcher (
// Inputs
                   // Test bus signals
                   TCLK,
                   RESETn,
                   TESTREQA,
                   TESTREQB,
                   TESTACK,
                   TESTBUS,
                   // AHB Master signals
                   HADDRTIC,
                   HWRITETIC,
                   HTRANSTIC,
                   HSIZETIC,
                   HBURSTTIC,
                   HPROTTIC,
                   HWDATATIC
                  );

// Inputs

// Test bus signals
input         TCLK;      // Test mode clock
input         RESETn;    // Bus Reset
input         TESTREQA;  // Test bus request A
input         TESTREQB;  // Test bus request B
input         TESTACK;   // Test Acknowledge
input  [31:0] TESTBUS;   // Test data bus

// AHB Master signals
input  [31:0] HADDRTIC;  // AHB System address bus
input         HWRITETIC; // Data transfer direction signal
input   [1:0] HTRANSTIC; // AHB Transfer type
input   [2:0] HSIZETIC;  // AHB Data transfer type
input   [2:0] HBURSTTIC; // AHB Burst type
input   [3:0] HPROTTIC;  // Protection control signal
input  [31:0] HWDATATIC; // AHB Write data bus




// Inputs

// Test bus signals
  wire        TCLK;      // Test mode clock
  wire        RESETn;    // Bus Reset
  wire        TESTREQA;  // Test bus request A
  wire        TESTREQB;  // Test bus request B
  wire        TESTACK;   // Test Acknowledge
  wire [31:0] TESTBUS;   // Test data bus

// AHB Master signals
  wire [31:0] HADDRTIC;  // AHB System address bus
  wire        HWRITETIC; // Data transfer direction signal
  wire  [1:0] HTRANSTIC; // AHB Transfer type
  wire  [2:0] HSIZETIC;  // AHB Data transfer type
  wire  [2:0] HBURSTTIC; // AHB Burst type
  wire  [3:0] HPROTTIC;  // Protection control signal
  wire [31:0] HWDATATIC; // AHB Write data bus


// -----------------------------------------------------------------------------
//
//                                 TicWatcher
//                                 ==========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   TicWatcher module watches the TIC Bus and flags warning messages for
// protocol violations on the Bus.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// TIC States
// -----------------------------------------------------------------------------
`define ST_IDLE          3'b000
// TIC remains IDLE (Normal mode operation of the System

`define ST_ENTER         3'b001
// Entering TEST mode

`define ST_START         3'b010
// Start of TEST by the TIC

`define ST_ADDR          3'b011
// Address or Control state

`define ST_READ          3'b100
// Read state

`define ST_LASTREAD      3'b101
// Read state

`define ST_WRITE         3'b110
// Write state

`define ST_TAROUND       3'b111
// Turnaround state

// -----------------------------------------------------------------------------
// Vector Types
// -----------------------------------------------------------------------------
`define ADDRVEC          2'b11
// Address Vector

`define READVEC          2'b01
// Read Vector

`define WRITEVEC         2'b10
// Write Vector

`define EXITVEC          2'b00
// Exit Test mode

`define DEFAULT_CNTLREG  10'b0000110100
// Default value in the Control Register
//   HSIZE = WORD ("10")
//   HPROT = Privileged data access, uncacheable and unbufferable ("0011")
//   Address Increment = Disabled
//   HLOCK = '0'

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire  [1:0] iTESTREQ;
// Test Request Type

wire [31:0] NxtHADDR;
// D- input for the iHADDR

wire [31:0] NxtHWDATA;
// D- input for the iHWDATA

wire  [1:0] iHTRANS;
// Internal HTRANS

wire  [2:0] iHBURST;
// Internal HBURST

wire  [3:0] iHPROT;
// Internal HPROT

wire  [2:0] iHSIZE;
// Internal HSIZE

wire        iHLOCK;
// Internal HWRITE

wire        iHWRITE;
// Internal HWRITE

wire [10:1] NxtControlReg;
// D- input for the ControlReg

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg   [2:0] CurrState;
// Current state

reg   [2:0] PrevState;
// Previous state

reg   [2:0] NxtState;
// D- inputs to the state (CurrState) flip-flops

reg         SyncTESTREQA;
// Synchronised Test bus Request A

reg  [31:0] iHADDR;
// Internal HADDR

reg  [31:0] iHWDATA;
// Internal HWDATA

reg  [10:1] ControlReg;
// TIC Control Register

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

assign iTESTREQ         = {TESTREQA, TESTREQB};

// -----------------------------------------------------------------------------
// Synchronise TESTREQA signal
// -----------------------------------------------------------------------------
always @(posedge TCLK or negedge RESETn)
begin : p_SyncTREQASeq
  if (RESETn == 1'b0)
    SyncTESTREQA <= 1'b0;
  else
    SyncTESTREQA <= TESTREQA;
end // p_SyncTREQASeq

// -----------------------------------------------------------------------------
// Sequential logic to update the state vector of the TIC
// -----------------------------------------------------------------------------
always @(posedge TCLK or negedge RESETn)
begin : p_UpdateStSeq
  if (RESETn == 1'b0)
    begin
      PrevState <= `ST_IDLE;
      CurrState <= `ST_IDLE;
    end
  else
    begin
      if (TESTACK == 1'b1)
        begin
          PrevState <= CurrState;
        end
      CurrState <= NxtState;
    end
end // p_UpdateStSeq

// -----------------------------------------------------------------------------
// Combinatorial logic to update the state vector of the TIC
// -----------------------------------------------------------------------------
always @(CurrState or SyncTESTREQA or TESTACK or iTESTREQ)
begin : p_StMachineComb
  case (CurrState)
    `ST_IDLE :
      begin
        if (SyncTESTREQA == 1'b1)
          NxtState = `ST_ENTER;
        else
          NxtState = `ST_IDLE;
      end

    `ST_ENTER :
      begin
        if (TESTACK == 1'b1)
          NxtState = `ST_START;
        else if (SyncTESTREQA == 1'b0)
          NxtState = `ST_IDLE;
        else
          NxtState = `ST_ENTER;
      end

    `ST_START :
      begin
        if (TESTACK == 1'b0)
          NxtState = `ST_START;
        else if (iTESTREQ == `ADDRVEC)
          NxtState = `ST_ADDR;
        else
          NxtState = `ST_START;
      end

    `ST_ADDR :
      begin
        if (TESTACK == 1'b0)
          NxtState = `ST_ADDR;
        else if (iTESTREQ == `READVEC)
          NxtState = `ST_READ;
        else if (iTESTREQ == `WRITEVEC)
          NxtState = `ST_WRITE;
        else if (iTESTREQ == `EXITVEC)
          NxtState = `ST_IDLE;
        else
          NxtState = `ST_ADDR;
      end

    `ST_READ :
      begin
        if (TESTACK == 1'b0)
          NxtState = `ST_READ;
        else if (iTESTREQ == `READVEC)
          NxtState = `ST_READ;
        else
          NxtState = `ST_LASTREAD;
      end

    `ST_LASTREAD :
      begin
        if (TESTACK == 1'b0)
          NxtState = `ST_LASTREAD;
        else
          NxtState = `ST_TAROUND;
      end

    `ST_WRITE :
      begin
        if (TESTACK == 1'b0)
          NxtState = `ST_WRITE;
        else if ((iTESTREQ == `ADDRVEC) || (iTESTREQ == `EXITVEC))
          NxtState = `ST_ADDR;
        else if (iTESTREQ == `READVEC)
          NxtState = `ST_READ;
        else
          NxtState = `ST_WRITE;
      end

    `ST_TAROUND :
      begin
        if (TESTACK == 1'b0)
          NxtState = `ST_TAROUND;
        else if (iTESTREQ == `READVEC)
          NxtState = `ST_READ;
        else if (iTESTREQ == `WRITEVEC)
          NxtState = `ST_WRITE;
        else
          NxtState = `ST_ADDR;
      end

    default :
      NxtState = `ST_IDLE;
  endcase
end // p_StMachineComb

// -----------------------------------------------------------------------------
// Control Register updation logic
// -----------------------------------------------------------------------------
assign NxtControlReg    = (PrevState == `ST_ADDR & CurrState == `ST_ADDR &
                           NxtState != `ST_ADDR & TESTBUS[0] == 1'b1) ?
                           TESTBUS[10:1] : ControlReg;

// -----------------------------------------------------------------------------
// Sequential process to update Control Register
// -----------------------------------------------------------------------------
always @(posedge TCLK or negedge RESETn)
begin : p_ControlSeq
  if (RESETn == 1'b0)
    ControlReg <= `DEFAULT_CNTLREG;
  else
    ControlReg <= NxtControlReg;
end // p_ControlSeq

// -----------------------------------------------------------------------------
// Internal AHB signal generation
// -----------------------------------------------------------------------------
assign NxtHADDR         = (CurrState == `ST_ADDR) ? TESTBUS : iHADDR;

assign NxtHWDATA        = (CurrState == `ST_WRITE & TESTACK == 1'b1) ?
                           TESTBUS : iHWDATA;

assign iHWRITE          = (CurrState == `ST_WRITE) ? 1'b1 : 1'b0;

assign iHTRANS          = (CurrState == `ST_WRITE | CurrState == `ST_READ) ?
                           2'b10 : 2'b00;

assign iHLOCK           = ControlReg[4];
assign iHBURST          = 3'b001;
assign iHSIZE           = {1'b0, ControlReg[3:2]};
assign iHPROT           = {ControlReg[10:9], ControlReg[6:5]};

// -----------------------------------------------------------------------------
// Internal AHB signal generation (HADDR and HWDATA)
// -----------------------------------------------------------------------------
always @(posedge TCLK or negedge RESETn)
begin : p_AHBSigSeq
  if (RESETn == 1'b0)
    begin
      iHADDR  <= 32'h00000000;
      iHWDATA <= 32'h00000000;
    end
  else
    begin
      iHADDR  <= NxtHADDR;
      iHWDATA <= NxtHWDATA;
    end
end // p_AHBSigSeq

// -----------------------------------------------------------------------------
// Protocol Checkings
// -----------------------------------------------------------------------------
always @(posedge TCLK)
begin : p_SignalChkComb
  if (PrevState == `ST_ADDR)
    begin
      if (HADDRTIC != iHADDR)
        $display("Time : %t TICWATCH1 : Error in HADDR signal from the TIC", $time);

      if (HWRITETIC != iHWRITE)
        $display("Time : %t TICWATCH2 : Error in HWRITE signal from the TIC", $time);

      if (HSIZETIC != iHSIZE)
        $display("Time : %t TICWATCH3 : Error in HSIZE signal from the TIC", $time);

      if (HBURSTTIC != iHBURST)
        $display("Time : %t TICWATCH4 : Error in HBURST signal from the TIC", $time);

      if (HPROTTIC != iHPROT)
        $display("Time : %t TICWATCH5 : Error in HPROT signal from the TIC", $time);

      if (HTRANSTIC != iHTRANS)
        $display("Time : %t TICWATCH6 : Error in HTRANS signal from the TIC", $time);
    end
  else if (PrevState == `ST_WRITE)
    begin
      if (HWDATATIC != iHWDATA)
        $display("Time : %t TICWATCH7 : Error in HWDATA signal from the TIC", $time);
    end
end // p_SignalChkComb

endmodule

// --================================== End ==================================--
