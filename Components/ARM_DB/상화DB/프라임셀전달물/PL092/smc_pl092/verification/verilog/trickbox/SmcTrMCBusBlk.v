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
// File Revision          : 1.9
//
// Release Information    : PrimeCell(TM)-PL092-REL1v1
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

// Outputs
                      MCBUSREQ,
                      MCADDR,
                      MCDATAOUT,
                      MCDATAEN
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



// Outputs
output        MCBUSREQ;       // MCBUS Access Request signal
output [25:0] MCADDR;         // MCBUS Address signals
output [31:0] MCDATAOUT;      // MCBUS Data Out signals
output  [3:0] MCDATAEN;       // MCBUS Data Enable lines




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



// Outputs
  reg         MCBUSREQ;       // MCBUS Access Request signal
  wire [25:0] MCADDR;         // MCBUS Address signals
  wire [31:0] MCDATAOUT;      // MCBUS Data Out signals
  wire  [3:0] MCDATAEN;       // MCBUS Data Enable lines


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

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

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

endmodule
// --================================== End ==================================--
