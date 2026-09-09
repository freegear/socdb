// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacRspRoute.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           DMA controller AHB response routing module
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacRspRoute (
// Inputs
                     // Channels interrupt status
                     // Error Interrupt status
                     IntErrCh0,
                     IntErrCh1,
                     IntErrCh2,
                     IntErrCh3,
                     IntErrCh4,
                     IntErrCh5,
                     IntErrCh6,
                     IntErrCh7,
                     // TC Interrupt status
                     IntTCCh0,
                     IntTCCh1,
                     IntTCCh2,
                     IntTCCh3,
                     IntTCCh4,
                     IntTCCh5,
                     IntTCCh6,
                     IntTCCh7,
                     // Clear DMA REQ signals from all the channels
                     ClearReq0,
                     ClearReq1,
                     ClearReq2,
                     ClearReq3,
                     ClearReq4,
                     ClearReq5,
                     ClearReq6,
                     ClearReq7,
                     // Terminal count to generate the DMACTC signals
                     SigTC0,
                     SigTC1,
                     SigTC2,
                     SigTC3,
                     SigTC4,
                     SigTC5,
                     SigTC6,
                     SigTC7,
                     // Integration test related register bit values
                     ITEN,
                     DMACITOP1,
                     DMACITOP2,
                     DMACITOP3,

// Outputs
                     ClearReq,
                     // DMAC response signals
                     DMACCLR,
                     DMACTC,
                     // DMAC interrupt request signals
                     DMACINTERR,
                     DMACINTTC,
                     DMACINTR
                     );

// Inputs

// Channels interrupt status
// Error Interrupt status
input         IntErrCh0;        // Error Interrupt for CH0
input         IntErrCh1;        // Error Interrupt for CH1
input         IntErrCh2;        // Error Interrupt for CH2
input         IntErrCh3;        // Error Interrupt for CH3
input         IntErrCh4;        // Error Interrupt for CH4
input         IntErrCh5;        // Error Interrupt for CH5
input         IntErrCh6;        // Error Interrupt for CH6
input         IntErrCh7;        // Error Interrupt for CH7
// TC Interrupt status
input         IntTCCh0;         // TC Interrupt for CH0
input         IntTCCh1;         // TC Interrupt for CH1
input         IntTCCh2;         // TC Interrupt for CH2
input         IntTCCh3;         // TC Interrupt for CH3
input         IntTCCh4;         // TC Interrupt for CH4
input         IntTCCh5;         // TC Interrupt for CH5
input         IntTCCh6;         // TC Interrupt for CH6
input         IntTCCh7;         // TC Interrupt for CH7
// Clear DMA REQ signals from all the channels
input  [15:0] ClearReq0;        // Clear DMAREQ from Channel 0
input  [15:0] ClearReq1;        // Clear DMAREQ from Channel 1
input  [15:0] ClearReq2;        // Clear DMAREQ from Channel 2
input  [15:0] ClearReq3;        // Clear DMAREQ from Channel 3
input  [15:0] ClearReq4;        // Clear DMAREQ from Channel 4
input  [15:0] ClearReq5;        // Clear DMAREQ from Channel 5
input  [15:0] ClearReq6;        // Clear DMAREQ from Channel 6
input  [15:0] ClearReq7;        // Clear DMAREQ from Channel 7
// Terminal count to generate the DMACTC signals
input  [15:0] SigTC0;           // DMACTC signal from CH0
input  [15:0] SigTC1;           // DMACTC signal from CH1
input  [15:0] SigTC2;           // DMACTC signal from CH2
input  [15:0] SigTC3;           // DMACTC signal from CH3
input  [15:0] SigTC4;           // DMACTC signal from CH4
input  [15:0] SigTC5;           // DMACTC signal from CH5
input  [15:0] SigTC6;           // DMACTC signal from CH6
input  [15:0] SigTC7;           // DMACTC signal from CH7
// Integration test related register bit values
input         ITEN;             // integration Test enable
input  [15:0] DMACITOP1;        // register DMACITOP1
input  [15:0] DMACITOP2;        // register DMACITOP2
input   [1:0] DMACITOP3;        // register DMACITOP3

// Outputs
output [15:0] ClearReq;         // ORed version of clear request from all
                                // the channels
// DMAC response signals
output [15:0] DMACCLR;          // DMAC request clear
output [15:0] DMACTC;           // DMAC terminal count
// DMAC interrupt request signals
output        DMACINTERR;       // DMAC error interrupt request
output        DMACINTTC;        // DMAC terminal count interrupt request
output        DMACINTR;         // DMAC combined interrupt request

// Inputs
// Channels interrupt status
// Error Interrupt status
wire          IntErrCh0;        // Error Interrupt for CH0
wire          IntErrCh1;        // Error Interrupt for CH1
wire          IntErrCh2;        // Error Interrupt for CH2
wire          IntErrCh3;        // Error Interrupt for CH3
wire          IntErrCh4;        // Error Interrupt for CH4
wire          IntErrCh5;        // Error Interrupt for CH5
wire          IntErrCh6;        // Error Interrupt for CH6
wire          IntErrCh7;        // Error Interrupt for CH7
// TC Interrupt status
wire          IntTCCh0;         // TC Interrupt for CH0
wire          IntTCCh1;         // TC Interrupt for CH1
wire          IntTCCh2;         // TC Interrupt for CH2
wire          IntTCCh3;         // TC Interrupt for CH3
wire          IntTCCh4;         // TC Interrupt for CH4
wire          IntTCCh5;         // TC Interrupt for CH5
wire          IntTCCh6;         // TC Interrupt for CH6
wire          IntTCCh7;         // TC Interrupt for CH7
// Clear DMA REQ signals from all the channels
wire   [15:0] ClearReq0;        // Clear DMAREQ from Channel 0
wire   [15:0] ClearReq1;        // Clear DMAREQ from Channel 1
wire   [15:0] ClearReq2;        // Clear DMAREQ from Channel 2
wire   [15:0] ClearReq3;        // Clear DMAREQ from Channel 3
wire   [15:0] ClearReq4;        // Clear DMAREQ from Channel 4
wire   [15:0] ClearReq5;        // Clear DMAREQ from Channel 5
wire   [15:0] ClearReq6;        // Clear DMAREQ from Channel 6
wire   [15:0] ClearReq7;        // Clear DMAREQ from Channel 7
// Terminal count to generate the DMACTC signals
wire   [15:0] SigTC0;           // DMACTC signal from CH0
wire   [15:0] SigTC1;           // DMACTC signal from CH1
wire   [15:0] SigTC2;           // DMACTC signal from CH2
wire   [15:0] SigTC3;           // DMACTC signal from CH3
wire   [15:0] SigTC4;           // DMACTC signal from CH4
wire   [15:0] SigTC5;           // DMACTC signal from CH5
wire   [15:0] SigTC6;           // DMACTC signal from CH6
wire   [15:0] SigTC7;           // DMACTC signal from CH7
// Integration test related register bit values
wire          ITEN;             // integration Test enable
wire   [15:0] DMACITOP1;        // register DMACITOP1
wire   [15:0] DMACITOP2;        // register DMACITOP2
wire    [1:0] DMACITOP3;        // register DMACITOP3

// Outputs
wire   [15:0] ClearReq;         // ORed version of clear request from all
                                // the channels
// DMAC response signals
wire   [15:0] DMACCLR;          // DMAC request clear
wire   [15:0] DMACTC;           // DMAC terminal count
// DMAC interrupt request signals
wire          DMACINTERR;       // DMAC error interrupt request
wire          DMACINTTC;        // DMAC terminal count interrupt request
wire          DMACINTR;         // DMAC combined interrupt request

// -----------------------------------------------------------------------------
//
//                                DmacRspRoute
//                                ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//   This module takes the outputs of the all 8 channels and generates common
// output signals by ORing all the outputs of the channels. This module also
// implements the integration test multiplexors
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        InINTERR;
// Internal DMACINTERR interrupt signal

wire        InINTTC;
// Internal DMACINTTC interrupt signal

wire        InINTR;
// Internal DMACINTR interrupt signal

wire [15:0] SigTC;
// Internal DMACTC interrupt signal

wire [15:0] iClearReq;
// Internal copy of ClearReq signal

//Include Parameters File
`include "DmacParams.v"

// -----------------------------------------------------------------------------
// Register declarations
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
// Combinational assignments
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Generating the Interrupt signals from the status from all the
// channels
// -----------------------------------------------------------------------------
// The ERROR interrupt is the ORed version of the ERROR interrupt from
// all the channels.
assign InINTERR         = IntErrCh0 | IntErrCh1 | IntErrCh2 | IntErrCh3 |
                           IntErrCh4 | IntErrCh5 | IntErrCh6 | IntErrCh7;

// The TERMINAL COUNT interrupt is the ORed version of the TERMINAL
// COUNT interrupt from all the channels.
assign InINTTC          = IntTCCh0 | IntTCCh1 | IntTCCh2 | IntTCCh3 |
                           IntTCCh4 | IntTCCh5 | IntTCCh6 | IntTCCh7;

// The COMBINED interrupt is the ORed version of the InINTTC and InINTERR
// interrupts
assign InINTR           = InINTTC | InINTERR;

// -----------------------------------------------------------------------------
// Generating the final DMACTC signal from the DMACTC signals from all
// the channels
// -----------------------------------------------------------------------------
assign SigTC            = SigTC0 | SigTC1 | SigTC2 | SigTC3 | SigTC4 |
                           SigTC5 | SigTC6 | SigTC7;

// -----------------------------------------------------------------------------
// Generating the final DMACCLR signal from the DMACCLR signals from all
// the channels
// -----------------------------------------------------------------------------
assign iClearReq        = ClearReq0 | ClearReq1 | ClearReq2 | ClearReq3 |
                           ClearReq4 | ClearReq5 | ClearReq6 | ClearReq7;

// -----------------------------------------------------------------------------
// Test Multiplexing for integration testing of the intrachip output signals.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// The combinational routing of the Interrupt signals depending upon the ITEN
// bit from the DMACTCR reigister
// -----------------------------------------------------------------------------
assign DMACINTR         = (ITEN == 1'b0) ? InINTR :
                           (DMACITOP3[0] | DMACITOP3[1]);

assign DMACINTERR       = (ITEN == 1'b0) ? InINTERR : DMACITOP3[1];

assign DMACINTTC        = (ITEN == 1'b0) ? InINTTC : DMACITOP3[0];

// -----------------------------------------------------------------------------
// The combinational routing of the DMACTC signals depending upon the ITEN bit
// from the DMACTCR register
// -----------------------------------------------------------------------------
assign DMACTC           = (ITEN == 1'b0) ? SigTC : DMACITOP2;

// -----------------------------------------------------------------------------
// The combinational routing of the DMACCLR signals depending upon the ITEN bit
// from the DMACTCR register
// -----------------------------------------------------------------------------
assign DMACCLR          = (ITEN == 1'b0) ? iClearReq : DMACITOP1;

// -----------------------------------------------------------------------------
// Assigning the local copies to the output
// -----------------------------------------------------------------------------
assign ClearReq         = iClearReq;

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule
// --================================== End ==================================--
