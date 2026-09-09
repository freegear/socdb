// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SmcTrMCBusBlk.v.rca
// File Revision          : 1.14
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module checks the MCBUS protocols on the SMC
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SmcTrMCBusBlk (
// Inputs
                      // AHB bus signals
                      HCLK,
                      HRESETn,

                      // SMBUS signals
                      SMADDR,
                      SMDATAOUT,
                      nSMDATAEN,

                      // MCBUS Signals
                      MCBUSGNT,
                      SMCTrMCREQD,
                      SMCTrGNT2RMREQ,
                      SMCTrMCADDR,
                      SMCTrMCDATAOUT,
                      SMCTrMCBUSRRd,
                      SMCTrMCBUSRWr,
                      SMCTrEBICntl,
                      SMBUSREQ,

// Outputs
                      MCBUSREQ,
                      MCADDR,
                      MCDATAOUT,
                      MCDATAEN,
                      SMBUSGNT
                     );

parameter Tclk = 10.56;          // HCLK Period

// Inputs

// AHB bus signals
input         HCLK;           // AHB Bus Clock
input         HRESETn;        // Bus Reset



// SMBUS signals
input  [25:0] SMADDR;         // SMBUS Address signals
input  [31:0] SMDATAOUT;      // SMBUS Data Out signals
input   [3:0] nSMDATAEN;      // SMBUS Data Enable lines



// MCBUS Signals
input         MCBUSGNT;       // MCBUS Grant
input   [4:0] SMCTrMCREQD;    // MCBUS Access to REQUEST Delay Count
                              // Register
input   [4:0] SMCTrGNT2RMREQ; // MCBUS Grant to REQUEST de-assertion
                              // delay count Register
input  [25:0] SMCTrMCADDR;    // Address to eb driven out to the
                              // MCADDR bus of the SMC
input  [31:0] SMCTrMCDATAOUT; // Data to be driven out to the
                              // MCDATAOUT bus of the SMC
input         SMCTrMCBUSRRd;  // MCBUS Read Enable
input         SMCTrMCBUSRWr;  // MCBUS Write Enable

// Ebi Signals
input [11:0]  SMCTrEBICntl;   // Ebi Control register
input         SMBUSREQ;       // External Bus request

// Outputs
output        MCBUSREQ;       // MCBUS Access Request signal
output [25:0] MCADDR;         // MCBUS Address signals
output [31:0] MCDATAOUT;      // MCBUS Data Out signals
output  [3:0] MCDATAEN;       // MCBUS Data Enable lines
output        SMBUSGNT;       // Grant for external bus



// Inputs

// AHB bus signals
  wire        HCLK;           // AHB Bus Clock
  wire        HRESETn;        // Bus Reset



// SMBUS signals
  wire [25:0] SMADDR;         // SMBUS Address signals
  wire [31:0] SMDATAOUT;      // SMBUS Data Out signals
  wire  [3:0] nSMDATAEN;      // SMBUS Data Enable lines



// MCBUS Signals
  wire        MCBUSGNT;       // MCBUS Grant
  wire  [4:0] SMCTrMCREQD;    // MCBUS Access to REQUEST Delay Count
                              // Register
  wire  [4:0] SMCTrGNT2RMREQ; // MCBUS Grant to REQUEST de-assertion
                              // delay count Register
  wire [25:0] SMCTrMCADDR;    // Address to eb driven out to the
                              // MCADDR bus of the SMC
  wire [31:0] SMCTrMCDATAOUT; // Data to be driven out to the
                              // MCDATAOUT bus of the SMC
  wire        SMCTrMCBUSRRd;  // MCBUS Read Enable
  wire        SMCTrMCBUSRWr;  // MCBUS Write Enable

  wire [11:0]  SMCTrEBICntl;   // Ebi Control register
  wire SMBUSREQ;               // External Bus request


// Outputs
  reg         MCBUSREQ;       // MCBUS Access Request signal
  wire [25:0] MCADDR;         // MCBUS Address signals
  wire [31:0] MCDATAOUT;      // MCBUS Data Out signals
  wire  [3:0] MCDATAEN;       // MCBUS Data Enable lines
  wire        SMBUSGNT;       // Grant for external bus


// -----------------------------------------------------------------------------
//
//                                SmcTrMCBusBlk
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// SMC Tricbox is an AHB slave. This block performs the following operations:
//   - Generates the MCBUSREQ, MCADDR, MCDATAOUT and MCDATAEN signals.
//   - Watches the MCBUSGNT, SMADDR, SMDATAOUT and SMDATAEN for the expected
//     data.
//   - Flags Error messages when a mismatch is found on the SMBUS signals.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [31:0] IntMCREQD;
// MCBUS access to Bus Request assertion delay

wire [31:0] IntGNT2RMREQ;
// MCBUS Grant to Bus Request de-assertion delay

wire [31:0] GntCounter;
// SMBUSREQ to SMBUSGNT delay

wire [31:0] DeGntCounter;
// SMBUSGNT deassertion time

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

reg [31:0] GntWaitCount;
// Counter for Counting upto GntCounter value

reg [31:0] DeGntWaitCount;
// Counter for Counting upto DeGntCounter value

reg       iSMBUSGNT;
// internal copy of SMBUSGNT
// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// ToInteger
// ---------
//   This function converts the std_logic_vector input argument into integer
// and returns the integer value.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

initial
begin
  MCBUSREQ = 1'b0;
end

// -----------------------------------------------------------------------------
// MCBUS Signal generation
// -----------------------------------------------------------------------------
assign MCADDR           = SMCTrMCADDR;

assign MCDATAEN         = (SMCTrMCBUSRRd == 1'b1) ?
                           4'b0101 : ((SMCTrMCBUSRWr == 1'b1) ?
                           4'b1010 : MCDATAEN);

assign MCDATAOUT        = ((SMCTrMCBUSRRd == 1'b1) |
                           (SMCTrMCBUSRWr == 1'b1)) ?
                           SMCTrMCDATAOUT : MCDATAOUT;

// -----------------------------------------------------------------------------
// Converting std_logic_vector to time.
// -----------------------------------------------------------------------------
assign IntMCREQD        = SMCTrMCREQD * Tclk;
assign IntGNT2RMREQ     = SMCTrGNT2RMREQ * Tclk;

// -----------------------------------------------------------------------------
// Loading SMBUS counter values 
// -----------------------------------------------------------------------------
assign GntCounter     = SMCTrEBICntl[4:0];
assign DeGntCounter   = SMCTrEBICntl[9:5];

// -----------------------------------------------------------------------------
// Process to count for the SMBUSGNT assertion 
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_GntWaitCount
  if (HRESETn == 1'b0)
    GntWaitCount <= 5'b00000;
  else
    begin
      if (SMBUSREQ == 1'b1)
        begin
          if (GntWaitCount <= GntCounter)
              GntWaitCount <= GntWaitCount + 1;
        end
      else
          GntWaitCount <= 5'b00000;
    end
end // p_GntWaitCount

// -----------------------------------------------------------------------------
// Process to count for the SMBUSGNT deassertion 
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DeGntWaitCount 
  if (HRESETn == 1'b0)
    DeGntWaitCount <= 5'b00000;
  else
    begin
      if (SMBUSGNT == 1'b1)
        begin
          if (DeGntWaitCount <= DeGntCounter)
              DeGntWaitCount <= DeGntWaitCount + 1;
        end
      else
        DeGntWaitCount <= 5'b00000;
    end
end // p_DeGntWaitCount 
// -----------------------------------------------------------------------------
// Process to generate SMBUSGNT 
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SmBusGnt
  if (HRESETn == 1'b0)
    iSMBUSGNT <= 1'b0;
  else
    begin
      if (GntWaitCount == GntCounter && SMBUSREQ == 1'b1)
       begin
        iSMBUSGNT  <= 1'b1;
       end
       else if (SMBUSREQ == 1'b0)
        iSMBUSGNT  <= 1'b0;
    end
end // p_SmBusGnt 
// -----------------------------------------------------------------------------
// MCBUSREQ Generation
// -----------------------------------------------------------------------------
always @(SMCTrMCBUSRRd or SMCTrMCBUSRWr or
         MCBUSGNT)
begin : p_MCBUSREQComb
  if ((SMCTrMCBUSRRd == 1'b1) || (SMCTrMCBUSRWr == 1'b1))
    begin
      if (MCBUSREQ == 1'b0)
        # IntMCREQD MCBUSREQ <= 1'b1;
    end
  else if (MCBUSGNT == 1'b1)
    # IntGNT2RMREQ MCBUSREQ <= 1'b0;
end // p_MCBUSREQComb

// -----------------------------------------------------------------------------
// Check the external BUS signals for the correct data
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SMBUSWatchComb
  if (HRESETn == 1'b0)
    ; 
  else
    begin
      if (MCBUSGNT == 1'b1)
        begin
          if (SMADDR != SMCTrMCADDR)
            $display("Time %t SMCTB8: Error in the SMADDR received", $time);

          if (nSMDATAEN != MCDATAEN)
            $display("Time %t SMCTB9: Error in the nSMDATAEN received", $time);

          if (SMDATAOUT != MCDATAOUT)
            $display("Time %t SMCTB10: Error in the SMDATAOUT received", $time);
        end
    end
end // p_SMBUSWatchComb

// -----------------------------------------------------------------------------
// assigning local copies to output 
// -----------------------------------------------------------------------------
assign SMBUSGNT = iSMBUSGNT;

endmodule
// --================================== End ==================================--
