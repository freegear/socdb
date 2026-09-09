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
// File Name              : AaciTrClkGen.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL041-REL1v0
//
// ---------------------------------------------------------------------
// Purpose :
//           This generates the AACIBITCLK and nAACIBITCLKRST in 
//           AACIBITCLK domain.
//
// --=================================================================--

`timescale 1ns/1ps

`include   "AaciTrPackage.v"

// ---------------------------------------------------------------------

module AaciTrClkGen (
// Inputs
                     // APB signals
                     PCLK,
                     PRESETn,

                     // BITCLK related signals
                     AACITrBtClkE,
                     AACITrBtClkRst,
                     AACITrBtClkPrd,
                     AACITrClkReg,
// Outputs
                     // BITCLK status signals
                     PCLKOn,
                     BITCLKOn,
                     AACIBITCLK,
                     BITCLKIn,
                     nAACIBITCLKRST,
                     nFAACIBITCLKRST
                    );

// Inputs
input         PCLK;            // APB clock
input         PRESETn;         // APB Reset
input         AACITrBtClkE;    // BITCLKE sync'ed signal
input         AACITrBtClkRst;  // Reset for AACI in BITCLK domain
input  [15:0] AACITrBtClkPrd;  // BITCLK period value
input   [2:0] AACITrClkReg;    // BITCLK muxing register
// Outputs
output        PCLKOn;          // PCLK is driven on the BITCLK
output        BITCLKOn;        // iBITCLK is driven on BITCLK o/p
output        AACIBITCLK;      // AACI serial Clock out Signal
output        BITCLKIn;        // AACI serial Clock Signal
output        nAACIBITCLKRST;  // Reset in the AACIBITCLK domain
output        nFAACIBITCLKRST; // Reset in the nAACIBITCLK domain

// Inputs
wire          PCLK;             // APB clock
wire          PRESETn;          // APB Reset
wire          AACITrBtClkE;     // BITCLKE sync'ed signal
wire          AACITrBtClkRst;   // Reset for AACI in BITCLK domain
wire   [15:0] AACITrBtClkPrd;   // BITCLK period value
wire    [2:0] AACITrClkReg;     // BITCLK muxing register

// Outputs
reg           PCLKOn;           // PCLK is driven as the BITCLK
reg           BITCLKOn;         // iBITCLK is driven as the BITCLK
wire          AACIBITCLK;       // AACI serial Clock out Signal
wire          BITCLKIn;         // AACI serial Clock Signal
reg           nAACIBITCLKRST;   // AACIBITCLK domain reset 
reg           nFAACIBITCLKRST;  // nAACIBITCLK domain reset 

// ---------------------------------------------------------------------
//
//                           AaciTrClkGen
//                           ============
//
// ---------------------------------------------------------------------
//
// Overview
// ========
// This submodule of the AACI trickbox provides the BITCLK serial clock
// output for the serial data transmission. The BITCLK generator
// generates a clock whose frequency is dependent on the value in the
// AACITrBtClkPrd. Similarly the nAACIBITCLKRST is driven low when the
// AACITrBtCLkRst bit from the control register of the trickbox is
// reset to zero. The assertion to low value is asynchronous but the
// de-assertion is synchronous to BITCLK.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Parameter declarations
// ---------------------------------------------------------------------
parameter BtClkSkew        = 3;

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
// Internal signals
// ----------------
wire        MuxInBITCLK;      // iBITCLK input to the mux
wire        MuxInPCLK;        // PCLK input to the mux

// ---------------------------------------------------------------------
// Reg declarations
// ---------------------------------------------------------------------
reg  [63:0] Clk_low;          // Clock low Width
reg  [63:0] Clk_high;         // Clock high Width
reg         iBITCLK;          // Generated BITCLK
reg         BitClkSelected;   // Internal BITCLK
reg         AACITrBtClkESync; // Sync'ed BITCLKE in iBITCLK domain
reg         BITCLKSkewd;      // Internal BITCLK with skew
reg         PCLKEnNegSync;    // PCLKE sync to PCLK
reg         BITCLKEnNegSync;  // BITCLKE sync to BITCLK

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
// Initialises of the signals and variables
// ---------------------------------------------------------------------
initial
begin
  iBITCLK     = 1'b0;
  BITCLKSkewd = 1'b0;
end

// ---------------------------------------------------------------------
// Connect local copies to output ports
// ---------------------------------------------------------------------
assign BITCLKIn         = BITCLKSkewd;

// ---------------------------------------------------------------------
// BITCLK generation based on the value in AACTrBtClkPrd
// ---------------------------------------------------------------------
always @(AACITrBtClkPrd or iBITCLK)
begin : p_BITCLKGenSeq
    if (AACITrBtClkPrd != 16'b0)
      #(AACITrBtClkPrd / 2.0) iBITCLK <= ~iBITCLK;
end   //  p_BITCLKGenSeq;

// --------------------------------------------------------------------
// Derive final clock signals by gating the clocks with the respective
// enable signals synchronised to the BITCLK clock domain.
// --------------------------------------------------------------------
assign AACIBITCLK       = BITCLKSkewd && AACITrBtClkESync;

// ---------------------------------------------------------------------
// Synchronize the Enable of the BITCLK to the iBITCLK domain.
// ---------------------------------------------------------------------
always @(iBITCLK)
begin : p_BtlkEnSyncSeq
  if (iBITCLK == 1'b1)
    AACITrBtClkESync <= AACITrBtClkE;
end // process p_BtlkEnSyncSeq;

// ---------------------------------------------------------------------
// BITCLKSkewd generation based on the value in BtClkSkew
// ---------------------------------------------------------------------
always @(BitClkSelected)
begin : p_BITCLKSkdGen
  # BtClkSkew;
  BITCLKSkewd <= BitClkSelected;
end // p_BITCLKSkdGen; 

// ---------------------------------------------------------------------
// Reset signal generator.The Reset is done asynchronously but the 
// deassertion is done synchronous to the BITCLK clock.
// ---------------------------------------------------------------------
always @(negedge BITCLKSkewd or negedge PRESETn or AACITrBtClkRst) 
begin
  if (AACITrBtClkRst == 1'b0)
    nAACIBITCLKRST <= 1'b0;
  else if (AACITrBtClkRst == 1'b1 && BITCLKEnNegSync == 1'b0 &&
            PCLKEnNegSync == 1'b0)
    nAACIBITCLKRST <= 1'b1;
  else if (BITCLKSkewd == 1'b0)
    nAACIBITCLKRST <= AACITrBtClkRst;
end // process p_RstCtrlSeq;

// ---------------------------------------------------------------------
// Reset signal generator.The Reset is done asynchronously but the 
// deassertion is done synchronous to the nAACIBITCLK clock.
// ---------------------------------------------------------------------
always @(posedge BITCLKSkewd or negedge PRESETn or AACITrBtClkRst) 
begin
  if (AACITrBtClkRst == 1'b0)
    nFAACIBITCLKRST <= 1'b0;
  else if (AACITrBtClkRst == 1'b1 && BITCLKEnNegSync == 1'b0 &&
            PCLKEnNegSync == 1'b0)
    nFAACIBITCLKRST <= 1'b1;
  else if (BITCLKSkewd == 1'b1)
    nFAACIBITCLKRST <= AACITrBtClkRst;
end // process p_RstCtrlSeq1;
// ---------------------------------------------------------------------
// Synchronize the Enable of the PCLK to the PCLK domain.
// The synchronising is done on the falling edges of the clock so as to
// guarantee the dying down of the clock.
// ---------------------------------------------------------------------
always @(negedge PCLK or AACITrClkReg)
begin : p_PCLKEnSyncSeq
  if (PCLK == 1'b0)
    PCLKEnNegSync <= AACITrClkReg[1];
end // process p_PCLKEnSyncSeq;
 
// ---------------------------------------------------------------------
// Synchronize the Enable of the iBITCLK to the iBITCLK domain.
// The synchronising is done on the falling edges of the clock so as to
// guarantee the dying down of the clock.
// ---------------------------------------------------------------------
always @(negedge iBITCLK or AACITrClkReg)
begin : p_BtCkEnSncSeq
  if (iBITCLK == 1'b0)
    BITCLKEnNegSync <= AACITrClkReg[2];
end // process p_BtCkEnSncSeq;
 
// ---------------------------------------------------------------------
// Derive intermediate clock signals by gating the clocks with the
// respective enable signals synchronised to the corresponding clock
// domain.
// ---------------------------------------------------------------------
assign MuxInBITCLK      = iBITCLK && BITCLKEnNegSync;
assign MuxInPCLK        = PCLK    && PCLKEnNegSync;
 
// ---------------------------------------------------------------------
// Writes the Status Bits PCLKOn and BITCLK into the Status Register of
// the TrickBox and the write is done on seeing the positive edge of
// the PCLK. These signals will be used by the test code to detect
// whether the respective clock is died down or not.
// ---------------------------------------------------------------------
always @(posedge PCLK)
begin : p_StatGenSeq
  PCLKOn    <= PCLKEnNegSync;
  BITCLKOn  <= BITCLKEnNegSync;
end // process p_StatGenSeq;
 
// ---------------------------------------------------------------------
// This process routes either MuxInPCLK or MuxInBITCLK to BITCLK.
// ---------------------------------------------------------------------
always @(AACITrClkReg or MuxInPCLK or MuxInBITCLK)
begin : p_RoutComb
  if (AACITrClkReg[0] !== 1'bx)
    if (AACITrClkReg[0] == 1'b1)
      BitClkSelected   <= MuxInPCLK;
    else
      BitClkSelected   <= MuxInBITCLK;
end // process p_RoutComb;
 
endmodule

// --============================ End ================================--
