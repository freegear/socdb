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
// File Name              : MmciTrRegblk.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block contains various registers of MMCI Trickbox
//           and the required logic to synchronise these registers
//           to the MMCICLK domain.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MmciTrRegblk (
// Inputs
                    PCLK,
                    PRESETn,
                    MMCIPowerWr,
                    MMCIClockWr,
                    MMCICommandWr,
                    MMCIDataLenWr,
                    MMCIDataCntlWr,
                    MMCITBCntlWr,
                    MMCITBRxdCIndS2,
                    MMCITBRxdCArgS2,
                    MTBCIUpdateSync,
                    MTBCAUpdateSync,
                    PWDATAIn,
// Outputs
                    MMCIPower,
                    MMCIClock,
                    MMCICommand,
                    MMCIDataLength,
                    MMCIDataCntl,
                    MMCITBCntl,
                    MPUpdate,
                    MCUpdate,
                    MCMUpdate,
                    MDLUpdate,
                    MDCUpdate,
                    MTBCUpdate,
                    MMCITBRxdCInd,
                    MMCITBRxdCArg
                    );

// Inputs
input         PCLK;            // APB Bus Clock
input         PRESETn;         // APB Bus Reset
input         MMCIPowerWr;     // WrEnable for MMCIPower
input         MMCIClockWr;     // WrEnable for MMCIClock
input         MMCICommandWr;   // WrEnable for MMCICommand
input         MMCIDataLenWr;   // WrEnable for MMCIDatalen
input         MMCIDataCntlWr;  // WrEnable for MMCIDataCntl
input         MMCITBCntlWr;    // Wr enable for MMCITBCntl
input   [5:0] MMCITBRxdCIndS2; // Stg2 buff i/p of RxdCmdInd
input  [31:0] MMCITBRxdCArgS2; // Stage 2 buffer i/p of RxdCmdArg
input         MTBCIUpdateSync; // Syncd Updt sig for MMCITBRxdCInd
input         MTBCAUpdateSync; // Syncd Updt sig for MMCITBRxdCArg
input  [31:0] PWDATAIn;        // Gated PWDATA Bus of APB

// Outputs
output  [7:0] MMCIPower;       // Stage 1 buffer o/p of MMCIPower
output [10:0] MMCIClock;       // Stage 1 buffer o/p of MMCIClock
output [10:0] MMCICommand;     // Stage 1 buffer o/p of MMCICommand
output [15:0] MMCIDataLength;  // Stage 1 buffer o/p of MMCIDataLen
output  [7:0] MMCIDataCntl;    // Stage 1 buffer o/p of MMCIDatCntl
output [13:0] MMCITBCntl;      // Stage 1 buffer o/p of MMCITBCtrl
output        MPUpdate;        // Updt signal for MMCIPower
output        MCUpdate;        // Updt sig for MMCIClock
output        MCMUpdate;       // Updt sig for MMCICommand
output        MDLUpdate;       // Updt sig for MMCIDataLen
output        MDCUpdate;       // Updt sig for MMCIDataCntl
output        MTBCUpdate;      // Updt sig for MMCITBCntl
output  [5:0] MMCITBRxdCInd;   // Stage 2 buffer o/p of RxdCmdInd
output [31:0] MMCITBRxdCArg;   // Stage 2 buffer o/p of RxdCmdArg

// Inputs
wire        PCLK;              // APB Bus Clock
wire        PRESETn;           // APB Bus Reset
wire        MMCIPowerWr;       // WrEnable for MMCIPower
wire        MMCIClockWr;       // WrEnable for MMCIClock
wire        MMCICommandWr;     // WrEnable for MMCICommand
wire        MMCIDataLenWr;     // WrEnable for MMCIDatalen
wire        MMCIDataCntlWr;    // WrEnable for MMCIDataCntl
wire        MMCITBCntlWr;      // Wr enable for MMCITBCntl
wire  [5:0] MMCITBRxdCIndS2;   // Stg2 buff i/p of RxdCmdInd
wire [31:0] MMCITBRxdCArgS2;   // Stage 2 buffer i/p of RxdCmdArg
wire        MTBCIUpdateSync;   // Syncd Updt sig for MMCITBRxdCInd
wire        MTBCAUpdateSync;   // Syncd Updt sig for MMCITBRxdCArg
wire [31:0] PWDATAIn;          // Gated PWDATA Bus of APB

// Outputs
wire  [7:0] MMCIPower;        // Stage 1 buffer o/p of MMCIPower
wire [10:0] MMCIClock;        // Stage 1 buffer o/p of MMCIClock
wire [10:0] MMCICommand;      // Stage 1 buffer o/p of MMCICommand
wire [15:0] MMCIDataLength;   // Stage 1 buffer o/p of MMCIDataLen
wire  [7:0] MMCIDataCntl;     // Stage 1 buffer o/p of MMCIDatCntl
wire [13:0] MMCITBCntl;       // Stage 1 buffer o/p of MMCITBCtrl
wire        MPUpdate;         // Updt signal for MMCIPower
wire        MCUpdate;         // Updt sig for MMCIClock
wire        MCMUpdate;        // Updt sig for MMCICommand
wire        MDLUpdate;        // Updt sig for MMCIDataLen
wire        MDCUpdate;        // Updt sig for MMCIDataCntl
wire        MTBCUpdate;       // Updt sig for MMCITBCntl
wire  [5:0] MMCITBRxdCInd;    // Stage 2 buffer o/p of RxdCmdInd
wire [31:0] MMCITBRxdCArg;    // Stage 2 buffer o/p of RxdCmdArg


// -----------------------------------------------------------------------------
//
//                                MmciTrRegblk
//                                ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//   This block contains all the registers needed for the functionality
// of the tricbox.Register that follow two buffer syncronization have
// there first stage buffer in this block.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire  [5:0] NextMTBSS;
//  D-Input to MTBSS register

wire  [3:0] NextMTBCS;
//  D-Input to MTBCS register

wire        MTBCIStg2WrEn;
//  Write enable to MTBCI buffer

wire        MTBCAStg2WrEn;
//  Write enable to MTBCA buffer

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg   [7:0] iMMCIPower;
// Stage 1 buffer for MMCIPower Register

reg  [10:0] iMMCIClock;
// Stage 1 buffer for MMCIClock Register

reg  [10:0] iMMCICommand;
// Stage 1 buffer for MMCICommand Register

reg  [15:0] iMMCIDataLength;
// Stage 1 buffer for MMCIDataLength Register

reg   [7:0] iMMCIDataCntl;
// Stage 1 buffer for -MMCIDataCntl Register

reg  [13:0] iMMCITBCntl;
// Stage 1 buffer for MMCITBCntl Register

reg   [7:0] NextMMCIPower;
// D-Input to MMCIPower

reg  [10:0] NextMMCIClock;
// D-Input to MMCIClock

reg  [10:0] NextMMCICommand;
// D-Input to MMCICommand

reg  [15:0] NextMMCIDataLen;
// D-Input to MMCIDataLength

reg   [7:0] NextMMCIDataCntl;
// D-Input to MMCIDataCntl

reg  [13:0] NextMMCITBCntl;
// D-Input to MMCITBCntl

reg         iMPUpdate;
// Local copy of Update signal to MMCIPower Register

reg         NextMPUpdate;
// D-Input to Update signal for MMCIPower Register

reg         iMCUpdate;
// Local copy of Update signal to MMCIClock Register

reg         NextMCUpdate;
// D-Input to Update signal for MMCIClock Register

reg         iMDLUpdate;
// Local copy of Update signal to MMCIDataLength Register

reg         NextMDLUpdate;
// D-Input to Update signal for MMCIDataLength Register

reg         iMDCUpdate;
// Local copy of Update signal to MMCIDataCntl Register

reg         NextMDCUpdate;
// D-Input to Update signal for MMCIDataCntl Register

reg         iMCMUpdate;
// Local copy of Update signal to MMCICommand Register

reg         NextMCMUpdate;
// D-Input to Update signal for MMCICommand Register

reg         iMTBCUpdate;
// Local copy of Update signal to MMCITBCntl Register

reg         NextMTBCUpdate;
// D-Input to Update signal for MMCITBCntl Register

reg   [5:0] MTBCI;
//  Second stage buffer for MMCITBRxdCInd register

reg  [31:0] MTBCA;
//  Second stage buffer for MMCITBRxdCArg register

reg   [5:0] NextMTBCI;
//  D-Input to MTBCI register

reg  [31:0] NextMTBCA;
//  D-Input to MTBCA register

reg         DelMTBCIUpdate;
//  Delayed MTBCIUpdateSync

reg         DelMTBCAUpdate;
//  Delayed MTBCAUpdateSync

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
// Connect local copies to output signals
// -----------------------------------------------------------------------------
// MMCIPower
assign MMCIPower         = iMMCIPower;

// MMCIClock
assign MMCIClock         = iMMCIClock;

// MMCICommand
assign MMCICommand       = iMMCICommand;

// MMCIDataLength
assign MMCIDataLength    = iMMCIDataLength;

// MMCIDataCntl
assign MMCIDataCntl      = iMMCIDataCntl;

// MMCITBCntl
assign MMCITBCntl        = iMMCITBCntl;

// ----------------------------------------------------------------------------
//        Register Write Logic
// ----------------------------------------------------------------------------

always @(posedge PCLK or negedge PRESETn)
begin : p_RegWriteSeq
  if (PRESETn ==  1'b0)
  begin
     iMMCIPower        <= 7'h00;
     iMMCIClock        <= 12'h000;
     iMMCICommand      <= 11'h000;
     iMMCIDataLength   <= 16'h0000;
     iMMCIDataCntl     <= 8'h00;
     iMMCITBCntl       <= 14'h0000;
  end
  else
  begin
     iMMCIPower        <= NextMMCIPower;
     iMMCIClock        <= NextMMCIClock;
     iMMCICommand      <= NextMMCICommand;
     iMMCIDataLength   <= NextMMCIDataLen;
     iMMCIDataCntl     <= NextMMCIDataCntl;
     iMMCITBCntl       <= NextMMCITBCntl;
  end
end // p_RegWriteSeq

// ----------------------------------------------------------------------------
// Write interface for First stage buffer.
// Write into the First stage buffers from the Data bus when the
// corresponding write enable signal is asserted.
// ----------------------------------------------------------------------------

always @(iMMCIPower or iMMCIClock or iMMCICommand or iMMCIDataLength or
         iMMCIDataCntl or iMMCITBCntl or MMCIPowerWr or MMCIClockWr or
         MMCICommandWr or MMCIDataLenWr or MMCIDataCntlWr or MMCITBCntlWr)
begin : p_RegComb
  if (MMCIPowerWr ==  1'b1)
     NextMMCIPower     = PWDATAIn[7:0];
  else
     NextMMCIPower     = iMMCIPower;

  if (MMCIClockWr ==  1'b1)
     NextMMCIClock     = PWDATAIn[11:0];
  else
     NextMMCIClock     = iMMCIClock;

  if (MMCICommandWr ==  1'b1)
     NextMMCICommand   = PWDATAIn[10:0];
  else
     NextMMCICommand   = iMMCICommand;

  if (MMCIDataLenWr ==  1'b1)
     NextMMCIDataLen   = PWDATAIn[15:0];
  else
     NextMMCIDataLen   = iMMCIDataLength;

  if (MMCIDataCntlWr ==  1'b1)
     NextMMCIDataCntl  = PWDATAIn[7:0];
  else
     NextMMCIDataCntl  = iMMCIDataCntl;

  if (MMCITBCntlWr ==  1'b1)
     NextMMCITBCntl    = PWDATAIn[13:0];
  else
     NextMMCITBCntl    = iMMCITBCntl;
end // p_RegComb


// ----------------------------------------------------------------------------
//   Update Siganals for Register Writes used for synchronisations
// ----------------------------------------------------------------------------

always @(iMPUpdate or MMCIPowerWr)
begin : p_UpdtMPComb
   NextMPUpdate     = iMPUpdate;
  if (MMCIPowerWr ==  1'b1)
     NextMPUpdate     =  ~(iMPUpdate);
end // p_UpdtMPComb

always @(posedge PCLK or negedge PRESETn)
begin : p_UpdtMPSeq
  if (PRESETn ==  1'b0)
     iMPUpdate        <= 1'b0;
  else
     iMPUpdate        <= NextMPUpdate;
end // p_UpdtMPSeq

always @(iMCUpdate or MMCIClockWr)
begin : p_UpdtMCComb
   NextMCUpdate     = iMCUpdate;
  if (MMCIClockWr ==  1'b1)
     NextMCUpdate   =  ~(iMCUpdate);
end // p_UpdtMCComb

always @(posedge PCLK or negedge PRESETn)
begin : p_UpdtMCSeq
  if (PRESETn ==  1'b0)
     iMCUpdate        <= 1'b0;
  else
     iMCUpdate        <= NextMCUpdate;
end // p_UpdtMCSeq

always @(iMCMUpdate or MMCICommandWr)
begin : p_UpdtMCMComb
   NextMCMUpdate    = iMCMUpdate;
  if (MMCICommandWr ==  1'b1)
     NextMCMUpdate  =  ~(iMCMUpdate);
end // p_UpdtMCMComb

always @(posedge PCLK or negedge PRESETn)
begin : p_UpdtMCMSeq
  if (PRESETn ==  1'b0)
     iMCMUpdate       <= 1'b0;
  else
     iMCMUpdate       <= NextMCMUpdate;
end // p_UpdtMCMSeq

always @(iMDLUpdate or MMCIDataLenWr)
begin : p_UpdtMDLComb
   NextMDLUpdate    = iMDLUpdate;
  if (MMCIDataLenWr ==  1'b1)
     NextMDLUpdate  =  ~(iMDLUpdate);
end // p_UpdtMDLComb

always @(posedge PCLK or negedge PRESETn)
begin : p_UpdtMDLSeq
  if (PRESETn ==  1'b0)
     iMDLUpdate       <= 1'b0;
  else
     iMDLUpdate       <= NextMDLUpdate;
end // p_UpdtMDLSeq

always @(iMDCUpdate or MMCIDataCntlWr)
begin : p_UpdtMDCComb
   NextMDCUpdate    = iMDCUpdate;
  if (MMCIDataCntlWr ==  1'b1)
     NextMDCUpdate  =  ~(iMDCUpdate);
end // p_UpdtMDCComb

always @(posedge PCLK or negedge PRESETn)
begin : p_UpdtMDCSeq
  if (PRESETn ==  1'b0)
     iMDCUpdate       <= 1'b0;
  else
     iMDCUpdate       <= NextMDCUpdate;
end // p_UpdtMDCSeq

always @(iMTBCUpdate or MMCITBCntlWr)
begin : p_UpdtMTBCComb
   NextMTBCUpdate   = iMTBCUpdate;
  if (MMCITBCntlWr ==  1'b1)
     NextMTBCUpdate =  ~(iMTBCUpdate);
end // p_UpdtMTBCComb

always @(posedge PCLK or negedge PRESETn)
begin : p_UpdtMTBCSeq
  if (PRESETn ==  1'b0)
     iMTBCUpdate      <= 1'b0;
  else
     iMTBCUpdate      <= NextMTBCUpdate;
end // p_UpdtMTBCSeq

// -----------------------------------------------------------------------------
// Connect local copies to output ports
// -----------------------------------------------------------------------------
assign MPUpdate         = iMPUpdate;
assign MCUpdate         = iMCUpdate;
assign MDLUpdate        = iMDLUpdate;
assign MDCUpdate        = iMDCUpdate;
assign MCMUpdate        = iMCMUpdate;
assign MTBCUpdate       = iMTBCUpdate;

// -----------------------------------------------------------------------------
// Generation of delayed versions of the Update trigger inputs.
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_UpdtSyncDel
  if (PRESETn ==  1'b0)
  begin
     DelMTBCIUpdate   <= 1'b0;
     DelMTBCAUpdate   <= 1'b0;
  end
  else
  begin
     DelMTBCIUpdate   <= MTBCIUpdateSync;
     DelMTBCAUpdate   <= MTBCAUpdateSync;
  end
end // p_UpdtSyncDel

// -----------------------------------------------------------------------------
// Generation of load signals for second stage buffers.
// -----------------------------------------------------------------------------
assign MTBCIStg2WrEn    = MTBCIUpdateSync ^ DelMTBCIUpdate;
assign MTBCAStg2WrEn    = MTBCAUpdateSync ^ DelMTBCAUpdate;

// -----------------------------------------------------------------------------
// MTBSSStg2WrEn is used to enable the clocking of MMCISIGSTATS2 Input
// into MTBSS buffer
// -----------------------------------------------------------------------------

always @(MTBCIStg2WrEn or MMCITBRxdCIndS2 or MTBCI)
begin : p_MTBCIComb
  if (MTBCIStg2WrEn ==  1'b1)
     NextMTBCI        = MMCITBRxdCIndS2;
  else
     NextMTBCI        = MTBCI;
end // p_MTBCIComb

always @(MTBCAStg2WrEn or MMCITBRxdCArgS2 or MTBCA)
begin : p_MTBCAComb
  if (MTBCAStg2WrEn ==  1'b1)
     NextMTBCA        = MMCITBRxdCArgS2;
  else
     NextMTBCA        = MTBCA;
end // p_MTBCAComb

// -----------------------------------------------------------------------------
// Second stage buffers for the registers.
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_Stg2BufSeq
  if (PRESETn ==  1'b0)
  begin
     MTBCI            <= 6'b000000;
     MTBCA            <= 32'h00000000;
  end
  else
  begin
     MTBCI            <= MMCITBRxdCIndS2;
     MTBCA            <= MMCITBRxdCArgS2;
  end
end // p_Stg2BufSeq

// -----------------------------------------------------------------------------
// Driving the outputs from the second stage buffers
// -----------------------------------------------------------------------------
// MMCITBRxdCInd
assign MMCITBRxdCInd     = MTBCI;

// MMCITBRxdCArg
assign MMCITBRxdCArg     = MTBCA;

endmodule
// --================================== End ==================================--
