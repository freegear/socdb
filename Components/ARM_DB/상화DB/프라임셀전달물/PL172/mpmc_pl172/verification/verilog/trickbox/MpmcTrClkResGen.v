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
// File Name              : MpmcTrClkResGen.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block generates the MPMCCLK, MPMCFBCLKIN, MPMCCSREFREQ
//           and nPOR signals for the MPMC
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "MpmcTrParams.v"

// -----------------------------------------------------------------------------

module MpmcTrClkResGen (
// Inputs
                        HCLK,
                        MPMCCLKOUT,
                        HRESETn,
                        MPMCTrCR,
                        MPMCTrConfig,
                        MPMCSREFACK,
// Outputs
                        MPMCCLK,
                        MPMCCLKDELAY,
                        nPOR,
                        nReset,
                        MPMCSREFREQ
                       );

parameter Tclkl = 20;            // HCLK low time
parameter Tclkh = 20;            // HCLK high time
parameter Tclks = 10;            // MPMCCLK start delay

// Inputs
input         HCLK;             // AHB Bus clock
input   [3:0] MPMCCLKOUT;       // MPMC Clock
input         HRESETn;          // Bus reset
input   [3:0] MPMCTrCR;         // MPMCTrCR register
input   [9:0] MPMCTrConfig;     // Mirror register of MPMCConfig
input         MPMCSREFACK;      // Self referesh acknowledge from MPMC

// Outputs
output        MPMCCLK;          // MPMCCLK output to MPMC
output        MPMCCLKDELAY;     // Delayed MPMCCLK output to MPMC
output        nPOR;             // Power on Reset to MPMC
output        nReset;           // Trickbox internal reset signal
output        MPMCSREFREQ;      // Self refersh request from Trickbox

// Inputs
wire          HCLK;             // AHB Bus clock
wire    [3:0] MPMCCLKOUT;       // MPMC Clock
wire          HRESETn;          // Bus reset
wire    [3:0] MPMCTrCR;         // MPMCTrCR register
wire    [9:0] MPMCTrConfig;     // Mirror register of MPMCConfig
wire          MPMCSREFACK;      // Self referesh acknowledge from MPMC

// Outputs
reg           MPMCCLK;          // MPMCCLK output to MPMC
wire          nPOR;             // Power on Reset to MPMC
wire          nReset;           // Trickbox internal reset signal
wire          MPMCSREFREQ;      // Self refersh request from Trickbox

// -----------------------------------------------------------------------------
//
//                               MpmcTrClkResGen
//                               ===============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block generates the MPMCCLK,  MPMCCSREFREQ, MPMCCLKDELAY
// and the nPOR signals. The MPMCTrCR register bits are interpreted in this 
// block.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define MPMCCLK_TO_MPMCCLKDELAY_DELAY    4
`define PORDELAY                         1

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire          POR;
// Power on Reset bit of MPMCTrCR register

wire          SREFREQ;
// Self refersh bit of MPMCTrCR register

wire    [1:0] ClkRatio;
// Define the ratio between HCLK and MPMCCLK

wire          inReset;
// Internal signal for nReset

reg           StartMPMCCLK;
// Indicates the start of MPMCCLK

time          Tmclkh;
// MPMCCLK high time

time          Tmclkl;
// MPMCCLK low time

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg           NxtMPMCSREFREQ;
// D-Input for MPMCSREFREQ

reg           iMPMCSREFREQ;
// Internal signal for MPMCSREFREQ

reg           inPOR;
// Internal signal for nPOR

reg         ResetAssrtd;
// Indicates that initial reset has been applied

reg         ResetOver;
// Indicates that initial reset has been applied

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
begin
  ResetOver   = `FALSE;
  ResetAssrtd = `FALSE;
  MPMCCLK     = 1'b0;
  Tmclkh      = (Tclkl + Tclkh)/2;
  Tmclkl      = (Tclkl + Tclkh)/2;
end

// -----------------------------------------------------------------------------
// Connect local copies to output ports
// -----------------------------------------------------------------------------
assign # 2 nPOR         = inPOR;
assign MPMCSREFREQ      = iMPMCSREFREQ;
assign nReset           = inReset;

// -----------------------------------------------------------------------------
// nReset Generation
// -----------------------------------------------------------------------------
assign inReset          = inPOR & HRESETn;

// -----------------------------------------------------------------------------
// inPOR Generation using the MPMCTrCR register bit
// -----------------------------------------------------------------------------
assign POR              = MPMCTrCR[1];
// -----------------------------------------------------------------------------
// ResetAssrtd signal is set once the Reset is applied
// -----------------------------------------------------------------------------
always @(HRESETn or ResetAssrtd)
begin : p_ResetOverComb
  if ((ResetAssrtd) && (HRESETn == 1'b1))
    ResetOver     <= `TRUE;
end // p_ResetOverComb

always @(posedge HCLK)
begin : p_ResetStrComb
  if (HRESETn == 1'b0)
    ResetAssrtd <= `TRUE;
end // p_ResetStrComb

// -----------------------------------------------------------------------------
// Clocking out the nPOR
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn or negedge POR)
begin : p_nPORSeq
  if ((HRESETn == 1'b0) & (ResetOver == 1'b0))
    inPOR <= 1'b0;
  else if (POR == 1'b1)
    # `PORDELAY inPOR <= 1'b0;
  else
    inPOR <= 1'b1;
end // p_nPORSeq

// -----------------------------------------------------------------------------
// MPMCSREFREQ Generation
// -----------------------------------------------------------------------------
assign SREFREQ          = MPMCTrCR[0];

// -----------------------------------------------------------------------------
// MPMCSREFREQ set/clear logic
// -----------------------------------------------------------------------------
always @(SREFREQ or MPMCSREFACK or iMPMCSREFREQ)
begin : p_SRefReqComb
  if (MPMCSREFACK == 1'b1)
    NxtMPMCSREFREQ = SREFREQ;
  else if (SREFREQ == 1'b1)
    NxtMPMCSREFREQ = 1'b1;
  else
    NxtMPMCSREFREQ = iMPMCSREFREQ;
end // p_SRefReqComb

// -----------------------------------------------------------------------------
// Clocking out MPMCSREFREQ
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge inReset)
begin : p_SRefReqSeq
  if (inReset == 1'b0)
    iMPMCSREFREQ <= 1'b0;
  else
    iMPMCSREFREQ <= NxtMPMCSREFREQ;
end // p_SRefReqSeq

// -----------------------------------------------------------------------------
//  ClkRatio and MemClkEn Generation
// -----------------------------------------------------------------------------
assign ClkRatio         = MPMCTrConfig[9:8];

// -----------------------------------------------------------------------------
//  MPMCCLK Generation
// -----------------------------------------------------------------------------
initial
  begin
    MPMCCLK      <= 1'b0;
    StartMPMCCLK <= 1'b0;
    # Tclks StartMPMCCLK <= 1'b1;
  end
 
  always @(StartMPMCCLK)
  begin
    if (StartMPMCCLK == 1'b1)
    forever
    begin
      # Tmclkl MPMCCLK =  1'b1;
      # Tmclkh MPMCCLK =  1'b0;
    end
  end
 
// -----------------------------------------------------------------------------
// Determine the MPMCCLK frequency
// -----------------------------------------------------------------------------
always @(negedge MPMCCLK)
begin : p_ClkRatSeq
  if (ClkRatio == 2'b11)
    begin
      Tmclkh           <= (Tclkl + Tclkh)/4;
      Tmclkl           <= (Tclkl + Tclkh)/4;
    end
  else
    begin
      Tmclkh           <= (Tclkl + Tclkh)/2;
      Tmclkl           <= (Tclkl + Tclkh)/2;
    end
end // p_ClkRatSeq

// -----------------------------------------------------------------------------
// MPMCCLKDELAY Generation
// -----------------------------------------------------------------------------
assign # `MPMCCLK_TO_MPMCCLKDELAY_DELAY MPMCCLKDELAY = MPMCCLK;

endmodule

// --================================== End ==================================--
