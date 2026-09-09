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
// File Name              : MpmcTrRegBlk.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block implements the AHB read/write registers in the
//           MPMC Trickbox
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MpmcTrRegBlk (
// Inputs
                     HCLK,
                     nPOR,
                     HRESETn,
                     HREADYIN0,
                     HREADYIN1,
                     HREADYIN2,
                     HREADYIN3,
                     WriteData,
                     MPMCTrSRWr,
                     MPMCTrCRWr,
                     MPMCTrSNPCRWr,
                     MPMCTrControlWr,
                     MPMCTrConfigWr,
                     MPMCTrDynCntlWr,
                     MPMCTrDynRfrshWr,
                     MPMCTrStExtWtWr,
                     MPMCTrDynRC0Wr,
                     MPMCTrDynRC1Wr,
                     MPMCTrDynRC2Wr,
                     MPMCTrDynRC3Wr,
                     MPMCTrDynCnfg0Wr,
                     MPMCTrDynCnfg1Wr,
                     MPMCTrDynCnfg2Wr,
                     MPMCTrDynCnfg3Wr,
                     MPMCTrStCSWr,
                     MPMCTrTESWr0,
                     MPMCTrTESWr1,
                     MPMCTrTESWr2,
                     MPMCTrTESWr3,
                     MPMCTrExpRefWr,
                     MPMCTrExBkOffWr,
                     HREADY0CNTWr,
                     HREADY1CNTWr,

// Outputs
                     MPMCTrCR,
                     MPMCTrSNPCR,
                     MPMCTrExpRef,
                     MPMCTrExBkOff,
                     MPMCTrControl,
                     MPMCTrConfig,
                     MPMCTrDynCntl,
                     MPMCTrDynRfrsh,
                     MPMCTrStExtWt,
                     MPMCTrDynRC0,
                     MPMCTrDynRC1,
                     MPMCTrDynRC2,
                     MPMCTrDynRC3,
                     MPMCTrDynCnfg0,
                     MPMCTrDynCnfg1,
                     MPMCTrDynCnfg2,
                     MPMCTrDynCnfg3,
                     MPMCTrStCS,
                     MPMCTrDynMEMT,
                     MPMCTrTES,
                     MPMCTrWrPrStat,
                     HREADY0CNT,
                     HREADY1CNT,
                     DataSR
                    );

// Inputs
// AHB bus signals
input         HCLK;             // AHB Bus Clock
input         nPOR;             // Power on reset
input         HRESETn;          // Bus Reset
input         HREADYIN0;        // HREADYIN for AHB0
input         HREADYIN1;        // HREADYIN for AHB1
input         HREADYIN2;        // HREADYIN for AHB2
input         HREADYIN3;        // HREADYIN for AHB3
input  [31:0] WriteData;        // Write Data bus to the Register
                                // Block
input         MPMCTrSRWr;       // MPMCTrSR register write enable
input         MPMCTrCRWr;       // MPMCTrCR Register Write Enable
input         MPMCTrSNPCRWr;    // MPMCTrSNP Control Register Write
                                // Enable
input         MPMCTrControlWr;  // MPMCTrControl Register Write Enable
input         MPMCTrConfigWr;   // MPMCTrConfig Register Write Enable
input         MPMCTrDynCntlWr;  // MPMCTrDynCntl Register Write Enable
input         MPMCTrDynRfrshWr; // MPMCTrDynRfrsh Register Write
                                // Enable
input         MPMCTrStExtWtWr;  // MPMCTrExtWait Register Write Enable
input         MPMCTrDynRC0Wr;   // MPMCTrDynRC0 Register Write Enable
input         MPMCTrDynRC1Wr;   // MPMCTrDynRC1 Register Write Enable
input         MPMCTrDynRC2Wr;   // MPMCTrDynRC2 Register Write Enable
input         MPMCTrDynRC3Wr;   // MPMCTrDynRC3 Register Write Enable
input         MPMCTrDynCnfg0Wr; // MPMCTrDynCnfg0 Register Write
                                // Enable
input         MPMCTrDynCnfg1Wr; // MPMCTrDynCnfg1 Register Write
                                // Enable
input         MPMCTrDynCnfg2Wr; // MPMCTrDynCnfg2 Register Write
                                // Enable
input         MPMCTrDynCnfg3Wr; // MPMCTrDynCnfg3 Register Write
                                // Enable
input         MPMCTrStCSWr;     // MPMCTrStCS Register Write Enable
input         MPMCTrTESWr0;     // MPMCTrTES Register Write Enable
                                // (AHB0)
input         MPMCTrTESWr1;     // MPMCTrTES Register Write Enable
                                // (AHB1)
input         MPMCTrTESWr2;     // MPMCTrTES Register Write Enable
                                // (AHB2)
input         MPMCTrTESWr3;     // MPMCTrTES Register Write Enable
                                // (AHB3)
input         MPMCTrExpRefWr;   // MPMCTrExpRef Register Write Enable
input         MPMCTrExBkOffWr;  // MPMCTrExBkOff Register Write Enable
input         HREADY0CNTWr;     // HREADY0CNT Register Write Enable
input         HREADY1CNTWr;     // HREADY1CNT Register Write Enable

// Outputs
// MPMC related signals
output  [6:0] MPMCTrCR;         // MPMCTrCR Register
output  [3:0] MPMCTrSNPCR;      // MPMCTrSNPCR Register
output  [3:0] MPMCTrExpRef;     // MPMCTrExpRef Register
output  [5:0] MPMCTrExBkOff;    // MPMCTrExkOff Register
output  [7:0] HREADY0CNT;       // HREADY0CNT Register
output  [7:0] HREADY1CNT;       // HREADY1CNT Register
output  [3:0] MPMCTrControl;    // MPMCTrControl Register
output  [9:0] MPMCTrConfig;     // MPMCTrConfig Register
output [15:0] MPMCTrDynCntl;    // MPMCTrDynCntl Register
output [10:0] MPMCTrDynRfrsh;   // MPMCTrDynRfrsh Register
output  [9:0] MPMCTrStExtWt;    // MPMCTrExtWait Register
output  [9:0] MPMCTrDynRC0;     // MPMCTrDynRC0 Register
output  [9:0] MPMCTrDynRC1;     // MPMCTrDynRC1 Register
output  [9:0] MPMCTrDynRC2;     // MPMCTrDynRC2 Register
output  [9:0] MPMCTrDynRC3;     // MPMCTrDynRC3 Register
output [29:0] MPMCTrDynCnfg0;   // MPMCTrDynCnfg0 Register
output [29:0] MPMCTrDynCnfg1;   // MPMCTrDynCnfg1 Register
output [29:0] MPMCTrDynCnfg2;   // MPMCTrDynCnfg2 Register
output [29:0] MPMCTrDynCnfg3;   // MPMCTrDynCnfg3 Register
output  [6:0] MPMCTrStCS;       // MPMCTrStCS Register
output  [3:0] MPMCTrDynMEMT;    // MPMCTrDynMEMT Register
output  [3:0] MPMCTrTES;        // MPMCTrTES Register
output  [3:0] MPMCTrWrPrStat;   // Indicates the status of write protect bits of
                                // memory
output  [8:0] DataSR;           // Data for MPMCTrSR register

// Inputs
wire          HCLK;             // AHB Bus Clock
wire          nPOR;             // Power on reset
wire          HRESETn;          // Bus Reset
wire          HREADYIN0;        // HREADYIN for AHB0
wire          HREADYIN1;        // HREADYIN for AHB1
wire          HREADYIN2;        // HREADYIN for AHB2
wire          HREADYIN3;        // HREADYIN for AHB3
wire   [31:0] WriteData;        // Write Data bus to the Register
                                // Block
wire          MPMCTrSRWr;       // MPMCTrSR register write enable
wire          MPMCTrCRWr;       // MPMCTrCR Register Write Enable
wire          MPMCTrSNPCRWr;    // MPMCTrSNP Control Register Write
                                // Enable
wire          MPMCTrControlWr;  // MPMCTrControl Register Write Enable
wire          MPMCTrConfigWr;   // MPMCTrConfig Register Write Enable
wire          MPMCTrDynCntlWr;  // MPMCTrDynCntl Register Write Enable
wire          MPMCTrDynRfrshWr; // MPMCTrDynRfrsh Register Write
                                // Enable
wire          MPMCTrStExtWtWr;  // MPMCTrExtWait Register Write Enable
wire          MPMCTrDynRC0Wr;   // MPMCTrDynRC0 Register Write Enable
wire          MPMCTrDynRC1Wr;   // MPMCTrDynRC1 Register Write Enable
wire          MPMCTrDynRC2Wr;   // MPMCTrDynRC2 Register Write Enable
wire          MPMCTrDynRC3Wr;   // MPMCTrDynRC3 Register Write Enable
wire          MPMCTrDynCnfg0Wr; // MPMCTrDynCnfg0 Register Write
                                // Enable
wire          MPMCTrDynCnfg1Wr; // MPMCTrDynCnfg1 Register Write
                                // Enable
wire          MPMCTrDynCnfg2Wr; // MPMCTrDynCnfg2 Register Write
                                // Enable
wire          MPMCTrDynCnfg3Wr; // MPMCTrDynCnfg3 Register Write
                                // Enable
wire          MPMCTrStCSWr;     // MPMCTrStCS Register Write Enable
wire          MPMCTrTESWr0;     // MPMCTrTES Register Write Enable
                                // (AHB0)
wire          MPMCTrTESWr1;     // MPMCTrTES Register Write Enable
                                // (AHB1)
wire          MPMCTrTESWr2;     // MPMCTrTES Register Write Enable
                                // (AHB2)
wire          MPMCTrTESWr3;     // MPMCTrTES Register Write Enable
                                // (AHB3)
wire          MPMCTrExpRefWr;   // MPMCTrExpRef Register Write Enable
wire          MPMCTrExBkOffWr;  // MPMCTrExBkOff Register Write Enable
wire          HREADY0CNTWr;     // HREADY0CNT Register Write Enable
wire          HREADY1CNTWr;     // HREADY1CNT Register Write Enable

// Outputs
wire    [6:0] MPMCTrCR;         // MPMCTrCR Register
wire    [3:0] MPMCTrSNPCR;      // MPMCTrSNPCR Register
wire    [3:0] MPMCTrExpRef;     // MPMCTrExpRef Register
wire    [5:0] MPMCTrExBkOff;    // MPMCTrExBkOff Register
wire    [7:0] HREADY0CNT;       // HREADY0CNT Register
wire    [7:0] HREADY1CNT;       // HREADY1CNT Register
wire    [3:0] MPMCTrControl;    // MPMCTrControl Register
wire    [9:0] MPMCTrConfig;     // MPMCTrConfig Register
wire   [15:0] MPMCTrDynCntl;    // MPMCTrDynCntl Register
wire   [10:0] MPMCTrDynRfrsh;   // MPMCTrDynRfrsh Register
wire    [9:0] MPMCTrStExtWt;    // MPMCTrExtWait Register
wire    [9:0] MPMCTrDynRC0;     // MPMCTrDynRC0 Register
wire    [9:0] MPMCTrDynRC1;     // MPMCTrDynRC1 Register
wire    [9:0] MPMCTrDynRC2;     // MPMCTrDynRC2 Register
wire    [9:0] MPMCTrDynRC3;     // MPMCTrDynRC3 Register
wire   [29:0] MPMCTrDynCnfg0;   // MPMCTrDynCnfg0 Register
wire   [29:0] MPMCTrDynCnfg1;   // MPMCTrDynCnfg1 Register
wire   [29:0] MPMCTrDynCnfg2;   // MPMCTrDynCnfg2 Register
wire   [29:0] MPMCTrDynCnfg3;   // MPMCTrDynCnfg3 Register
wire    [6:0] MPMCTrStCS;       // MPMCTrStCS Register
wire    [3:0] MPMCTrDynMEMT;    // MPMCTrDynMEMT Register
wire    [3:0] MPMCTrWrPrStat;   // MPMCTrWrPrStat Register
wire    [3:0] MPMCTrTES;        // MPMCTrTES Register
wire    [8:0] DataSR;           // Data for MPMCTrSR register

// -----------------------------------------------------------------------------
//
//                                MpmcTrRegBlk
//                                ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// MPMC Tricbox is an AHB slave. This block performs the following operations:
//   - Implements MPMC Trickbox registers
//   - Drives non-AMBA, non-memory related signals into the MPMC
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire    [6:0] NxtMPMCTrCR;
// D-input for the MPMCTrCR Register

wire    [3:0] NxtMPMCTrSNPCR;
// D-input for the MPMCTrSNPCR Register

wire    [3:0] NxtMPMCTrExpRef;
// D-input for the MPMCTrExpRef Register

wire    [5:0] NxtMPMCTrExBkOff;
// D-input for the MPMCTrExBkOff Register

wire    [3:0] NxtMPMCTrControl;
// D-input for the MPMCTrControl Register

wire    [9:0] NxtMPMCTrConfig;
// D-input for the MPMCTrConfig Register

wire   [15:0] NxtMPMCTrDynCntl;
// D-input for the MPMCTrDynCntl Register

wire   [10:0] NxtMPMCTrDyRfrsh;
// D-input for the MPMCTrDynRfrsh Register

wire    [9:0] NxtMPMCTrStExtWt;
// D-input for the MPMCTrStExtWt Register

wire    [9:0] NxtMPMCTrDynRC0;
// D-input for the MPMCTrDynRC0 Register

wire    [9:0] NxtMPMCTrDynRC1;
// D-input for the MPMCTrDynRC1 Register

wire    [9:0] NxtMPMCTrDynRC2;
// D-input for the MPMCTrDynRC2 Register

wire    [9:0] NxtMPMCTrDynRC3;
// D-input for the MPMCTrDynRC3 Register

wire   [29:0] NxtMPMCTrDyCnfg0;
// D-input for the MPMCTrDynCnfg0 Register

wire   [29:0] NxtMPMCTrDyCnfg1;
// D-input for the MPMCTrDynCnfg1 Register

wire   [29:0] NxtMPMCTrDyCnfg2;
// D-input for the MPMCTrDynCnfg2 Register

wire   [29:0] NxtMPMCTrDyCnfg3;
// D-input for the MPMCTrDynCnfg3 Register

wire    [6:0] NxtMPMCTrStCS;
// D-input for the MPMCTrStCS Register

wire    [3:0] NxtMPMCTrTES;
// D-input for the MPMCTrTES Register

wire    [7:0] NxtHREADY0CNT;
// D-input for the HREADY0CNT Register

wire    [7:0] NxtHREADY1CNT;
// D-input for the HREADY1CNT Register

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg     [6:0] iMPMCTrCR;
// Internal version of MPMCTrCR Register

reg     [3:0] iMPMCTrSNPCR;
// Internal version of MPMCTrSNPCR Register

reg     [3:0] iMPMCTrExpRef;
// Internal version of MPMCTrExpRef Register

reg     [5:0] iMPMCTrExBkOff;
// Internal version of MPMCTrExBkOff Register

reg     [3:0] iMPMCTrControl;
// Internal version of MPMCTrControl Register

reg     [9:0] iMPMCTrConfig;
// Internal version of MPMCTrConfig Register

reg    [15:0] iMPMCTrDynCntl;
// Internal version of MPMCTrDynCntl Register

reg    [10:0] iMPMCTrDynRfrsh;
// Internal version of MPMCTrDynRfrsh Register

reg     [9:0] iMPMCTrStExtWt;
// Internal version of MPMCTrStExtWt Register

reg     [9:0] iMPMCTrDynRC0;
// Internal version of MPMCTrDynRC0 Register

reg     [9:0] iMPMCTrDynRC1;
// Internal version of MPMCTrDynRC1 Register

reg     [9:0] iMPMCTrDynRC2;
// Internal version of MPMCTrDynRC2 Register

reg     [9:0] iMPMCTrDynRC3;
// Internal version of MPMCTrDynRC3 Register

reg    [29:0] iMPMCTrDynCnfg0;
// Internal version of MPMCTrDynCnfg0 Register

reg    [29:0] iMPMCTrDynCnfg1;
// Internal version of MPMCTrDynCnfg1 Register

reg    [29:0] iMPMCTrDynCnfg2;
// Internal version of MPMCTrDynCnfg2 Register

reg    [29:0] iMPMCTrDynCnfg3;
// Internal version of MPMCTrDynCnfg3 Register

reg     [6:0] iMPMCTrStCS;
// Internal version of MPMCTrStCS Register

reg     [3:0] iMPMCTrTES;
// Internal version of MPMCTrTES Register

reg     [7:0] iHREADY0CNT;
// Internal version of HREADY0CNT Register

reg     [7:0] iHREADY1CNT;
// Internal version of HREADY1CNT Register

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
  iMPMCTrStCS   = 7'b0100000;
end

// -----------------------------------------------------------------------------
// Combinational logic for all functional registers. When the respective
// write enable input is asserted, copy the contents of the HWDATA Bus into
// the corresponding registers.
// -----------------------------------------------------------------------------
assign NxtMPMCTrCR      = (MPMCTrCRWr == 1'b1) ?
                           WriteData[6:0] : iMPMCTrCR;

assign NxtMPMCTrSNPCR   = (MPMCTrSNPCRWr == 1'b1) ?
                           WriteData[3:0] : iMPMCTrSNPCR;

assign NxtMPMCTrExpRef  = (MPMCTrExpRefWr == 1'b1) ?
                           WriteData[3:0] : iMPMCTrExpRef;

assign NxtMPMCTrExBkOff = (MPMCTrExBkOffWr == 1'b1) ?
                           WriteData[5:0] : iMPMCTrExBkOff;

assign NxtHREADY0CNT    = (HREADY0CNTWr == 1'b1) ?
                           WriteData[7:0] : iHREADY0CNT;

assign NxtHREADY1CNT    = (HREADY1CNTWr == 1'b1) ?
                           WriteData[7:0] : iHREADY1CNT;

assign NxtMPMCTrControl = (MPMCTrControlWr == 1'b1) ?
                           WriteData[3:0] : iMPMCTrControl;

assign NxtMPMCTrConfig  = (MPMCTrConfigWr == 1'b1) ?
                           WriteData[9:0] : iMPMCTrConfig;

assign NxtMPMCTrDynCntl = (MPMCTrDynCntlWr == 1'b1) ?
                           WriteData[15:0] : iMPMCTrDynCntl;

assign NxtMPMCTrDyRfrsh = (MPMCTrDynRfrshWr == 1'b1) ?
                           WriteData[10:0] : iMPMCTrDynRfrsh;

assign NxtMPMCTrStExtWt = (MPMCTrStExtWtWr == 1'b1) ?
                           WriteData[9:0] : iMPMCTrStExtWt;

assign NxtMPMCTrDynRC0  = (MPMCTrDynRC0Wr == 1'b1) ?
                           WriteData[9:0] : iMPMCTrDynRC0;

assign NxtMPMCTrDynRC1  = (MPMCTrDynRC1Wr == 1'b1) ?
                           WriteData[9:0] : iMPMCTrDynRC1;

assign NxtMPMCTrDynRC2  = (MPMCTrDynRC2Wr == 1'b1) ?
                           WriteData[9:0] : iMPMCTrDynRC2;

assign NxtMPMCTrDynRC3  = (MPMCTrDynRC3Wr == 1'b1) ?
                           WriteData[9:0] : iMPMCTrDynRC3;

assign NxtMPMCTrDyCnfg0 = (MPMCTrDynCnfg0Wr == 1'b1) ?
                           WriteData[29:0] : iMPMCTrDynCnfg0;

assign NxtMPMCTrDyCnfg1 = (MPMCTrDynCnfg1Wr == 1'b1) ?
                           WriteData[29:0] : iMPMCTrDynCnfg1;

assign NxtMPMCTrDyCnfg2 = (MPMCTrDynCnfg2Wr == 1'b1) ?
                           WriteData[29:0] : iMPMCTrDynCnfg2;

assign NxtMPMCTrDyCnfg3 = (MPMCTrDynCnfg3Wr == 1'b1) ?
                           WriteData[29:0] : iMPMCTrDynCnfg3;

assign NxtMPMCTrStCS    = (MPMCTrStCSWr == 1'b1) ?
                           WriteData[6:0] : iMPMCTrStCS;

assign NxtMPMCTrTES[0]  = (MPMCTrTESWr0 == 1'b1) ?
                           WriteData[0] : iMPMCTrTES[0];

assign NxtMPMCTrTES[1]  = (MPMCTrTESWr1 == 1'b1) ?
                           WriteData[1] : iMPMCTrTES[1];

assign NxtMPMCTrTES[2]  = (MPMCTrTESWr2 == 1'b1) ?
                           WriteData[2] : iMPMCTrTES[2];

assign NxtMPMCTrTES[3]  = (MPMCTrTESWr3 == 1'b1) ?
                           WriteData[3] : iMPMCTrTES[3];

assign DataSR           = (MPMCTrSRWr == 1'b1) ?
                           WriteData[8:0] : 9'b000000000;

// -----------------------------------------------------------------------------
// Sequential process for all functional registers writes.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_HResRegUpdSeq
  if (HRESETn == 1'b0)
    begin
      iMPMCTrCR        <= 7'b0000000;
      iMPMCTrSNPCR     <= 4'h0;
      iMPMCTrTES       <= 4'h0;
      iMPMCTrExpRef    <= 4'h2;
      iMPMCTrExBkOff   <= 6'b111111;
      iHREADY0CNT      <= 8'b11111111;
      iHREADY1CNT      <= 8'b11111111;
    end
  else
    begin
      iMPMCTrCR        <= NxtMPMCTrCR;
      iMPMCTrSNPCR     <= NxtMPMCTrSNPCR;
      iMPMCTrStCS      <= NxtMPMCTrStCS;
      iMPMCTrTES       <= NxtMPMCTrTES;
      iMPMCTrExpRef    <= NxtMPMCTrExpRef;
      iMPMCTrExBkOff   <= NxtMPMCTrExBkOff;
      iHREADY0CNT      <= NxtHREADY0CNT;
      iHREADY1CNT      <= NxtHREADY1CNT;
    end
end // p_HResRegUpdSeq

// -----------------------------------------------------------------------------
// Sequential process for all nPOR reset registers writes.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge nPOR)
begin : p_PORRegUpdSeq
  if (nPOR == 1'b0)
    begin
      iMPMCTrControl   <= 4'h3;
      iMPMCTrConfig[7:0] <= 8'h00;
      iMPMCTrDynCntl   <= 16'h0002;
      iMPMCTrDynRfrsh  <= 11'b00000000000;
      iMPMCTrStExtWt   <= 10'b0000000000;
      iMPMCTrDynRC0    <= 10'b1100000011;
      iMPMCTrDynRC1    <= 10'b0100100100;
      iMPMCTrDynRC2    <= 10'b0101000100;
      iMPMCTrDynRC3    <= 10'b0101100100;
      iMPMCTrDynCnfg0  <= 30'b000000000000000000000100000000;
      iMPMCTrDynCnfg1  <= 30'b000000000000000000000100100000;
      iMPMCTrDynCnfg2  <= 30'b000000000000000000000100100100;
      iMPMCTrDynCnfg3  <= 30'b000000000000000000000101100000;
    end
  else
    begin
      iMPMCTrControl   <= NxtMPMCTrControl;
      iMPMCTrConfig    <= NxtMPMCTrConfig;
      iMPMCTrDynCntl   <= NxtMPMCTrDynCntl;
      iMPMCTrDynRfrsh  <= NxtMPMCTrDyRfrsh;
      iMPMCTrStExtWt   <= NxtMPMCTrStExtWt;
      iMPMCTrDynRC0    <= NxtMPMCTrDynRC0;
      iMPMCTrDynRC1    <= NxtMPMCTrDynRC1;
      iMPMCTrDynRC2    <= NxtMPMCTrDynRC2;
      iMPMCTrDynRC3    <= NxtMPMCTrDynRC3;
      iMPMCTrDynCnfg0  <= NxtMPMCTrDyCnfg0;
      iMPMCTrDynCnfg1  <= NxtMPMCTrDyCnfg1;
      iMPMCTrDynCnfg2  <= NxtMPMCTrDyCnfg2;
      iMPMCTrDynCnfg3  <= NxtMPMCTrDyCnfg3;
    end
end // p_PORRegUpdSeq

// -----------------------------------------------------------------------------
// Assign local copies of signals to the outputs
// -----------------------------------------------------------------------------
assign MPMCTrCR         = iMPMCTrCR;
assign MPMCTrSNPCR      = iMPMCTrSNPCR;
assign MPMCTrControl    = iMPMCTrControl;
assign MPMCTrConfig     = iMPMCTrConfig;
assign MPMCTrDynCntl    = iMPMCTrDynCntl;
assign MPMCTrDynRfrsh   = iMPMCTrDynRfrsh;
assign MPMCTrStExtWt    = iMPMCTrStExtWt;
assign MPMCTrDynRC0     = iMPMCTrDynRC0;
assign MPMCTrDynRC1     = iMPMCTrDynRC1;
assign MPMCTrDynRC2     = iMPMCTrDynRC2;
assign MPMCTrDynRC3     = iMPMCTrDynRC3;
assign MPMCTrDynCnfg0   = iMPMCTrDynCnfg0;
assign MPMCTrDynCnfg1   = iMPMCTrDynCnfg1;
assign MPMCTrDynCnfg2   = iMPMCTrDynCnfg2;
assign MPMCTrDynCnfg3   = iMPMCTrDynCnfg3;
assign MPMCTrStCS       = iMPMCTrStCS;
assign MPMCTrDynMEMT    = {iMPMCTrDynCnfg3[4], iMPMCTrDynCnfg2[4],
                           iMPMCTrDynCnfg1[4], iMPMCTrDynCnfg0[4]};
assign MPMCTrWrPrStat   = {iMPMCTrDynCnfg3[20], iMPMCTrDynCnfg2[20],
                           iMPMCTrDynCnfg1[20], iMPMCTrDynCnfg0[20]};
assign MPMCTrTES        = iMPMCTrTES;
assign MPMCTrExpRef     = iMPMCTrExpRef;
assign MPMCTrExBkOff    = iMPMCTrExBkOff;
assign HREADY0CNT       = iHREADY0CNT;
assign HREADY1CNT       = iHREADY1CNT;

endmodule

// --================================== End ==================================--
