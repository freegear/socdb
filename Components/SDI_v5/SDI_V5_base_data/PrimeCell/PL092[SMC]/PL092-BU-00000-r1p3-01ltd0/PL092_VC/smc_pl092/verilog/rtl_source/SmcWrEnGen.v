// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SmcWrEnGen.v.rca
// File Revision          : 1.20
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block has the logic for the generation of positive clocked and
//           negative clocked write enable and byte lane enable signals module.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SmcWrEnGen (
// Inputs
                   nHCLK,
                   HCLK,
                   HRESETn,
                   RBLE,
                   PosSMWEN,
                   PosSMBLS,
                   ExtWrEnCo,
                   XoutEnCo,

// Outputs
                   nSMWEN,
                   nSMBLS
                  );

// Inputs
input         nHCLK;           // AHB Clock negative
input         HCLK;            // Bus Clock
input         HRESETn;         // Bus Clock
input         RBLE;            // Byte lane enabled
                               // device
input         PosSMWEN;        // Positive edge
                               // (HCLK) triggered
                               // Write Enable, SMWEN
input [3:0]   PosSMBLS;        // Positive edge
                               // (HCLK) triggered
                               // byte lane select,
                               // SMBLS
input         ExtWrEnCo;       // enable signal for
                               // generation of write
                               // enable and bytelane
                               // select
input         XoutEnCo;        // Enable signal for
                               // the nSMOEN during
                               // reads



// Outputs
output        nSMWEN;          // Memory device write
                               // enable pin
output [3:0]  nSMBLS;          // Byte Lane selects
                               // pins




// Inputs
wire          nHCLK;           // AHB Clock negative
wire          HCLK;            // Bus Clock
wire          HRESETn;         // Bus Clock
wire          RBLE;            // Byte lane enabled
                               // device
wire          PosSMWEN;        // Positive edge
                               // (HCLK) triggered
                               // Write Enable, SMWEN
wire [3:0]    PosSMBLS;        // Positive edge
                               // (HCLK) triggered
                               // byte lane select,
                               // SMBLS
wire          ExtWrEnCo;       // enable signal for
                               // generation of write
                               // enable and bytelane
                               // select
wire          XoutEnCo;        // Enable signal for
                               // the nSMOEN during
                               // reads



// Outputs
reg           nSMWEN;          // Memory device write
                               // enable pin
reg [3:0]     nSMBLS;          // Byte Lane selects
                               // pins


// -----------------------------------------------------------------------------
//
//                                 SmcWrEnGen
//                                 ==========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

// Register declarations
// -----------------------------------------------------------------------------
reg  [3:0] NegSMBLS;
// Negative edge (nHCLK) triggered Byte lane select, BLS

reg        PosBlsSel;
// Write enable select between the positive and negative clocked SMBLS

reg        NextPosBlsSel;
// D-input of PosBlsSel

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Combinational logic for memory write enables
// -----------------------------------------------------------------------------
always @(ExtWrEnCo or RBLE or XoutEnCo or PosBlsSel)
begin : p_BlsSelGenComb
  NextPosBlsSel    = PosBlsSel;

  if ((ExtWrEnCo == 1'b1 || XoutEnCo == 1'b1) && (RBLE == 1'b1))
    begin
      NextPosBlsSel    = 1'b1;
    end
  else if (ExtWrEnCo == 1'b1 && RBLE == 1'b0)
    begin
      NextPosBlsSel    = 1'b0;
    end

end // p_BlsSelGenComb

// -----------------------------------------------------------------------------
// Sequential/clocked logic for the positive write enable signals
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_PosWrGenSeq
  if (HRESETn == 1'b0)
    begin
      PosBlsSel        <= 1'b0;
    end
  else
    begin
      PosBlsSel        <= NextPosBlsSel;
    end
end // p_PosWrGenSeq

// -----------------------------------------------------------------------------
// Generate the negative clock triggered WEN and BLS using nHCLK. There is no
// separate RESET for the nHCLK domain, but the signals will get reset in the
// subsequent negative clock edge after the positive clocked signals are reset
// in the HCLK domain.
// -----------------------------------------------------------------------------
always @(posedge nHCLK)
begin : p_NegWrEnSeq
  nSMWEN           <= PosSMWEN;
  NegSMBLS         <= PosSMBLS;
end // p_NegWrEnSeq

// -----------------------------------------------------------------------------
// This is the final output multiplexer logic which will select between the
// rising clock domain and falling clock domain sets of the SMBLS
// output signals as the final pad outputs
// -----------------------------------------------------------------------------
always @(PosSMBLS or NegSMBLS or PosBlsSel)
begin : p_FinalBlsComb

  case (PosBlsSel)
    1'b1 :
      nSMBLS           = PosSMBLS;
    1'b0 :
      nSMBLS           = NegSMBLS;
    default : ;
  
    endcase
end // p_FinalBlsComb

endmodule
// --================================== End ==================================--
