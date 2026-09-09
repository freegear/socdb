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
// File Name              : AaciTrRegBlk.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL041-REL1v0
//
// ---------------------------------------------------------------------
// Purpose :
//           This block contains the Registers in the AACI Trickbox
//
// --=================================================================--

`timescale 1ns/1ps

`include   "AaciTrPackage.v"

// ---------------------------------------------------------------------

module AaciTrRegBlk (
// Inputs
                      // APB signals
                     PCLK,
                     PRESETn,
                     PWDataIn,
             
                     AACITSYNCWr,
                     AACITRRESETWr,
                     AACITRDMAWr,
                     AACITRBTCLKWr,
                     AACITRCLKWr,
                     AACITRCNTRLWr,
// Outputs
                     // Control outputs to other submodules
                     AACITrEn,
                     AACITrWidChkEn,
                     AACITrTxEn,
                     AACITrRxEn,
                     AACITrBtClkE,
                     AACITrBtClkRst,
                     AACITrWintGen,
             
                     // Register outputs to other submodules
                     AACITrBtClkPrd,
                     AACITrClkReg,
                     AACITrDMAReg,
                     FORCEDRESET,
                     FORCEDSYNC,
                     AACIDMACLRRX,
                     AACIDMACLRTX
                    );
// Inputs
// APB signals
input         PCLK;             // APB clock
input         PRESETn;          // APB Reset
input  [31:0] PWDataIn;         // Int PWDATA

input         AACITSYNCWr;      // Write enable for AACITrSYNC
input         AACITRRESETWr;    // Write enable for AACITrRESET
input         AACITRDMAWr;      // Write enable for AACITrDMAReg
input         AACITRBTCLKWr;    // Write enable for AACITrBtClkPrd
input         AACITRCLKWr;      // Write enable for AACITrClkReg
input         AACITRCNTRLWr;    // Write enable for AACITrCntrlReg

// Outputs
// Control outputs to other submodules
output        AACITrEn;         // Trickbox enable
output        AACITrWidChkEn;   // Data width Check enable
output        AACITrTxEn;       // Transmission enable
output        AACITrRxEn;       // Reception  enable
output        AACITrBtClkE;     // BITCLK enable
output        AACITrBtClkRst;   // BITCLK domain reset
output        AACITrWintGen;    // The AACISDATAOUT in absense of BITCLK

// Register outputs to other submodules
output [15:0] AACITrBtClkPrd;   // BITCLK Period Register
output  [2:0] AACITrClkReg;     // Muxing control Register
output  [6:5] AACITrDMAReg;     // FIFO Status
output        FORCEDRESET;      // AC link Reset
output        FORCEDSYNC;       // Sync Register
output        AACIDMACLRRX;     // DMA receive request clear
output        AACIDMACLRTX;     // DMA transmit request clear

// Inputs
wire          PCLK;             // APB clock
wire          PRESETn;          // APB Reset
wire   [31:0] PWDataIn;         // Int PWDATA
wire          AACITSYNCWr;      // Write enable for AACITrSYNC
wire          AACITRRESETWr;    // Write enable for AACITrRESET
wire          AACITRDMAWr;      // Write enable for AACITrDMAReg
wire          AACITRBTCLKWr;    // Write enable for AACITrBtClkPrd
wire          AACITRCLKWr;      // Write enable for AACITrClkReg
wire          AACITRCNTRLWr;    // Write enable for AACITrCntrlReg

// Outputs
wire          AACITrEn;         // Trickbox enable
wire          AACITrWidChkEn;   // Data width Check enable
wire          AACITrTxEn;       // Transmission enable
wire          AACITrRxEn;       // Reception  enable
wire          AACITrBtClkE;     // BITCLK enable
wire          AACITrBtClkRst;   // BITCLK domain reset
wire          AACITrWintGen;    // The AACISDATAOUT in absense of BITCLK
reg    [15:0] AACITrBtClkPrd;   // Bit clock period Reg.
reg     [2:0] AACITrClkReg;     // Bit clock muxing Reg.
reg     [6:5] AACITrDMAReg;     // DMA request capture & clear Reg
wire          FORCEDRESET;      // AC link Reset 
wire          FORCEDSYNC;       // AC link SYNC control bit
reg           AACIDMACLRRX;     // DMA receive request clear
reg           AACIDMACLRTX;     // DMA transmit request clear

// ---------------------------------------------------------------------
//
//                           AaciTrRegBlk
//                           ============
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This block contains the registers in the AACI Trickbox. The
// writable registers are AACITrCntlReg, AACITrBtClkPrd, AACITrSYNC,
// AACITrRESET, AACITrTxFIFO(AACITrTxWdata), AACITrDMAReg.
//  Out of these, writes to AACITrTxWdata go to the Transmit FIFO 
// register. The contents of AACITrCntlReg which are used in the AC 
// link side are double synchronised to the BITCLK domain.
//   The write to these registers is done in this module and the
// contents of the registers are made available to the APB interface for
// register reads. The contents of the registers are routed to the
// various modules in the trickbox.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
// Internal register declarations
reg   [6:0] AACITrCntlReg;    // Control Register 
reg         AACITRRESET;      // Reset Register
reg         AACITRSYNC;       // Sync Register

// D inputs for the above registers
reg   [6:0] NxtAACITrCntlReg; // Control Register
reg  [15:0] NxtBtClkPrd;      // Bit clock period Reg.
reg   [4:0] NxtAACITrClkReg;  // Bit clock period Reg.
reg   [6:5] NxtAACITrDMAReg;  // DMA clear bits of DMA reg
reg         NextAACITRRESET;  // Reset Register
reg         NextAACITSYNC;    // Sync Register

// ---------------------------------------------------------------------
// 
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Assigning the DMA clears after some delay
// ---------------------------------------------------------------------
always @(AACITrDMAReg[5])
begin : p_AsgnRxClrsSeq
  # `Tdclrrx
  AACIDMACLRRX        <= AACITrDMAReg [5];
end // process p_AsgnRxClrsSeq

// ---------------------------------------------------------------------
// Assigning the DMA clears after some delay
// ---------------------------------------------------------------------
always @(AACITrDMAReg[6])
begin : p_AsgnTxClrsSeq
  # `Tdclrtx
  AACIDMACLRTX        <= AACITrDMAReg [6];
end // process p_AsgnTxClrsSeq

// ---------------------------------------------------------------------
// The following block assigns the different bits in the control reg
// ---------------------------------------------------------------------
assign AACITrEn         = AACITrCntlReg[0];
assign AACITrWidChkEn   = AACITrCntlReg[1];
assign AACITrTxEn       = AACITrCntlReg[2];
assign AACITrRxEn       = AACITrCntlReg[3];
assign AACITrBtClkE     = AACITrCntlReg[4];
assign AACITrBtClkRst   = AACITrCntlReg[5];
assign AACITrWintGen    = AACITrCntlReg[6];

// ---------------------------------------------------------------------
// Drive the values written into the AACITrRESET register and the
// AACITrSYNC register onto the FORCEDRESET, FORCEDSYNC outputs.
// ---------------------------------------------------------------------
assign FORCEDRESET      = AACITRRESET;
assign FORCEDSYNC       = AACITRSYNC;

// ---------------------------------------------------------------------
// Clocked process for the registers in this block. 
// ---------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_RegSeq
  if (PRESETn == 1'b0)
    begin
      AACITrCntlReg    <= 7'b0100000;
      AACITrBtClkPrd   <= 16'b0;
      AACITrClkReg     <= 3'b0;
      AACITrDMAReg     <= 2'b0;
      AACITRRESET      <= 1'b1;
      AACITRSYNC       <= 1'b0;
    end
  else
    begin
      AACITrCntlReg    <= NxtAACITrCntlReg;
      AACITrBtClkPrd   <= NxtBtClkPrd;
      AACITrClkReg     <= NxtAACITrClkReg;
      AACITrDMAReg     <= NxtAACITrDMAReg;
      AACITRRESET      <= NextAACITRRESET;
      AACITRSYNC       <= NextAACITSYNC;
    end
end // process p_RegSeq;

// ---------------------------------------------------------------------
// Write interface for First stage buffer.
// Write into the First stage buffers from the Data bus when the 
// corresponding write enable signal is asserted. 
// ---------------------------------------------------------------------
always @(AACITSYNCWr or AACITRRESETWr or AACITRDMAWr or AACITRBTCLKWr
         or AACITRCLKWr or  AACITRCNTRLWr or AACITrCntlReg or
         AACITrDMAReg or AACITrBtClkPrd or AACITrClkReg or AACITRRESET
         or AACITRSYNC or PWDataIn)
begin : p_RegComb
  if (AACITRCNTRLWr == 1'b1)
    NxtAACITrCntlReg = PWDataIn[6:0];
  else 
    NxtAACITrCntlReg = AACITrCntlReg;

  if (AACITRDMAWr == 1'b1)
    NxtAACITrDMAReg = PWDataIn[6:5];
  else 
    NxtAACITrDMAReg = AACITrDMAReg[6:5];

  if (AACITRBTCLKWr == 1'b1)
    NxtBtClkPrd = PWDataIn[15:0];
  else 
    NxtBtClkPrd = AACITrBtClkPrd;

  if (AACITRCLKWr == 1'b1)
    NxtAACITrClkReg = PWDataIn[2:0];
  else
    NxtAACITrClkReg = AACITrClkReg[2:0];

  if (AACITRRESETWr == 1'b1)
    NextAACITRRESET = PWDataIn[0];
  else 
    NextAACITRRESET = AACITRRESET;
  
  if (AACITSYNCWr == 1'b1)
    NextAACITSYNC = PWDataIn[0];
  else 
    NextAACITSYNC = AACITRSYNC;
  
end // process p_RegComb;

endmodule

// --=========================== End =================================--
