// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : MmciTrMclkRsgen.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block generates the MCLK and nMMCIRST signals
//           for the MMCI controller
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MmciTrMclkRsgen (
// Inputs
                       PCLK,
                       PRESETn,
                       MMCITBMCLKWr,
                       MMCITBCLKRSTWr,
                       PWDATAIn,
// Outpus
                       MCLK,
                       nMMCIRST,
                       MMCITBMCLKPeriod,
                       PCLKOn,
                       MCLKOn
                       );

// Inputs
input         PCLK;             // APB Bus clock
input         PRESETn;          // Bus reset
input         MMCITBMCLKWr;     // WrEn to MMCITBMCLKPd
input         MMCITBCLKRSTWr;   // WrEn to MMCITBCkRsCtl
input  [31:0] PWDATAIn;         // Write Data from APB Bus

// Outpus
output        MCLK;             // MCLK output to MMCI
output        nMMCIRST;         // Reset to MMCI
output [31:0] MMCITBMCLKPeriod; // Mclk period value reg
output        PCLKOn;           // Indicates PCLK in enabled internally
output        MCLKOn;           // Indicates MCLK in enabled internally

// Inputs
wire        PCLK;              // APB Bus clock
wire        PRESETn;           // Bus reset
wire        MMCITBMCLKWr;      // WrEn to MMCITBMCLKPd
wire        MMCITBCLKRSTWr;    // WrEn to MMCITBCkRsCtl
wire [31:0] PWDATAIn;          // Write Data from APB Bus

// Outpus
wire        MCLK;              // MCLK output to MMCI
reg         nMMCIRST;          // Reset to MMCI
wire [31:0] MMCITBMCLKPeriod;  // Mclk period value reg
reg         PCLKOn;            // Indicates PCLK in enabled internally
reg         MCLKOn;            // Indicates MCLK in enabled internally

// -----------------------------------------------------------------------------
//
//                               MmciTrMclkRsgen
//                               ===============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block generates the MCLK and the nMMCIRST signals.The
// MmciTrMclkRstCtrl register bits are interpreted in this block.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        MuxInRCLK;
// RCLKEnNegSync anded with MRefClk

wire        MuxInPCLK;
// PCLKEnNegSync anded with PCLK

wire        RSTBIT;
// Gives the status of reset bit in MmciClkRstCntl Register

wire         MRefClk;
// Generated as per MMCITBMCLKPd

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [31:0] MMCITBMCLKPd;
// MMCITBMCLKPd Register to hold MCLk period value

reg   [3:0] MMCITBCkRsCtl;
// MMCITBCkRsCtl register, holds clock muxing bits

reg  [31:0] NxtMMCITBMCLKPd;
// D-Input to MMCITBMCLKPd

reg   [3:0] NxtMMCITBCkRsCtl;
// D-Input to MMCITBCkRsCtl

reg         iMCLK;
// Internal MCLK

reg         PCLKEnNegSync;
// PCLKEN bit synced to falling edge of PCLK

reg         RCLKEnNegSync;
// RCLKEn bit synced to falling edge of MRefClk

reg         IntnMMCIRST;
// Used to generate a pulse of nMMCIRST

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
// Initialisations
// -----------------------------------------------------------------------------
initial
begin : p_Initialisations
  MMCITBCkRsCtl     = 4'b0000;
  NxtMMCITBCkRsCtl  = 4'b0000;
  iMCLK             = 1'b0;
  PCLKEnNegSync     = 1'b0;
  RCLKEnNegSync     = 1'b0;
end // p_Initialisations

// -----------------------------------------------------------------------------
// Connect local copies to output ports
// -----------------------------------------------------------------------------
assign MCLK              = iMCLK;
assign MMCITBMCLKPeriod  = MMCITBMCLKPd;
assign # (MMCITBMCLKPd / 2.0) MRefClk =
         (MMCITBMCLKPd !=  32'b00000000000000000000000000000000) ?
          ~MRefClk  : 1'b0;

// -----------------------------------------------------------------------------
// Reset signal generator.The Reset is done asynchronously but the
// deassertion is done synchronous to the MMCIClk clock.
// -----------------------------------------------------------------------------
always @(RSTBIT or posedge iMCLK or PRESETn)
begin : p_RstCtrlSeq
  if (RSTBIT ==  1'b1 || PRESETn == 1'b0)
  begin
    #1 nMMCIRST    <= 1'b0;
    IntnMMCIRST    <= 1'b0;
  end
  else
  begin
    IntnMMCIRST <= 1'b1;
    #1 nMMCIRST <= IntnMMCIRST;
  end
end // p_RstCtrlSeq

// -----------------------------------------------------------------------------
// Synchronize the Enable of the PCLK to the PCLK domain.
// -----------------------------------------------------------------------------
always @(negedge PCLK or MMCITBCkRsCtl)
begin : p_PCLKEnSyncSeq
  if (PCLK == 1'b0)
     PCLKEnNegSync    <= MMCITBCkRsCtl[1];
end // p_PCLKEnSyncSeq

// -----------------------------------------------------------------------------
// Synchronize the Enable of the MRefClk to the MRefClk domain.
// -----------------------------------------------------------------------------
always @(MRefClk or MMCITBCkRsCtl)
begin : p_RCLKEnSyncSeq
  if (MRefClk ==  1'b0)
     RCLKEnNegSync    <= MMCITBCkRsCtl[2];
end // p_RCLKEnSyncSeq

// -----------------------------------------------------------------------------
// Writes the Status Bits PCLKOn and MCLKOn into the Status Register of
// the TrickBox and the write is done on seeing the positive edge of
// the PCLK
// -----------------------------------------------------------------------------
always @(posedge PCLK or PCLKEnNegSync or RCLKEnNegSync)
begin : p_StatGenSeq
  if (PCLK == 1'b1)
  begin
     PCLKOn           <= PCLKEnNegSync;
     MCLKOn           <= RCLKEnNegSync;
  end
end // p_StatGenSeq

// ----------------------------------------------------------------------------
// Derive intermediate clock signals by gating the clocks with the
// respective enable signals synchronised to the corresponding clock
// domain.
// ----------------------------------------------------------------------------
assign MuxInRCLK        = MRefClk & RCLKEnNegSync;
assign MuxInPCLK        = PCLK & PCLKEnNegSync;

// ----------------------------------------------------------------------------
// This process routes the MuxInRCLK to the MCLK
// ----------------------------------------------------------------------------
always @(MuxInRCLK or MuxInPCLK)
begin : p_RoutComb
  if (MMCITBCkRsCtl[3] ==  1'b1)
    iMCLK = MuxInRCLK;
  else
    iMCLK = MuxInPCLK;
end // p_RoutComb

// ----------------------------------------------------------------------------
//  Driving the RSTBIT
// ----------------------------------------------------------------------------
assign RSTBIT           = MMCITBCkRsCtl[0];

// ----------------------------------------------------------------------------
//  Writes to the registers
// ----------------------------------------------------------------------------
always @(MMCITBMCLKPd or MMCITBCkRsCtl or MMCITBMCLKWr or PWDATAIn or
         MMCITBCLKRSTWr)
begin : p_RegWriteComb
  if (MMCITBMCLKWr ==  1'b1)
     NxtMMCITBMCLKPd  = PWDATAIn;
  else
     NxtMMCITBMCLKPd  = MMCITBMCLKPd;

  if (MMCITBCLKRSTWr ==  1'b1)
     NxtMMCITBCkRsCtl = PWDATAIn[3:0];
  else
     NxtMMCITBCkRsCtl = MMCITBCkRsCtl;
end // p_RegWriteComb

always @(posedge PCLK or negedge PRESETn)
begin : p_RegWriteSeq
  if (PRESETn ==  1'b0)
  begin
     MMCITBMCLKPd      <= 32'h00000000;
     MMCITBCkRsCtl     <= 4'h0;
  end
  else
  begin
     MMCITBMCLKPd      <= NxtMMCITBMCLKPd;
     MMCITBCkRsCtl     <= NxtMMCITBCkRsCtl;
  end
end // p_RegWriteSeq
endmodule
// --================================== End ==================================--
