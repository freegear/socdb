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
// File Name              : MmciTrRxFifo.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block instantiates the MmciTrRxFCntl and the
//           MmciTrRxRegFile blocks
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MmciTrRxFifo (
// Inputs
                    PCLK,
                    PRESETn,
                    FifoClearSync,
                    RxFWrSync,
                    RxFRdPtrInc,
                    RxFWrData,
// Outputs
                    RNE,
                    RFF,
                    RFHF,
                    RxFRdData
                    );

// Inputs
input         PCLK;          // APB bus clock
input         PRESETn;       // Bus reset
input         FifoClearSync; // Clear signal
input         RxFWrSync;     // RX FIFO write enable
input         RxFRdPtrInc;   // RX FIFO read ptr incr.
input  [32:0] RxFWrData;     // RX FIFO Wr data

// Outputs
output        RNE;           // RX FIFO not empty
output        RFF;           // RX FIFO full
output        RFHF;          // RX FIFO half full
output [32:0] RxFRdData;     // RX FIFO read data

// Inputs
wire        PCLK;            // APB bus clock
wire        PRESETn;         // Bus reset
wire        FifoClearSync;   // Clear signal
wire        RxFWrSync;       // RX FIFO write enable
wire        RxFRdPtrInc;     // RX FIFO read ptr incr.
wire [32:0] RxFWrData;       // RX FIFO Wr data

// Outputs
wire        RNE;             // RX FIFO not empty
wire        RFF;             // RX FIFO full
wire        RFHF;            // RX FIFO half full
wire [32:0] RxFRdData;       // RX FIFO read data

// -----------------------------------------------------------------------------
//
//                                 MmciTrRxFifo
//                                 ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// The MmciTrRxFIFO block instantiates the MmciTrRxRegFile block and the
// MmciTrRxFCntl block. The MmciTrRxRegFile block contains the Receive
// FIFO register file. Data on the RxFWrData bus is written into the
// location in the Receive FIFO pointed to by the current value of the
// WrPtr[4:0] (Write pointer) signal on the rising edge of PCLK on which
// the RegFileWrEn signal is sampled high. Data in the FIFO location
// pointed to by the RdPtr[4:0] signal is always driven on the
// RxFRdData[31:0] output.The MmciTrRxFCntl block controls the Read
// pointer and the Write pointer.Thus, the Receive FIFO is
// implemented as a circular buffer.The MmciTrRxFCntl block also
// generates FIFO status signals RFF, RFHF and RNE.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire       RegFileWrEn;
// Enable for valid Writes into Rx FIFO

wire [4:0] WrPtr;
// Read pointer, points to the location from where data is to be read

wire [4:0] RdPtr;
// Write pointer, points to the location where data is to be written

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
// The MmciTrRxFCntl block contains the control logic for the Receive
// FIFO.
// -----------------------------------------------------------------------------
MmciTrRxFCntl uMmciTrRxFCntl          (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .FifoClearSync    (FifoClearSync),
                    .RxFWrSync        (RxFWrSync),
                    .RxFRdPtrInc      (RxFRdPtrInc),
                    .RegFileWrEn      (RegFileWrEn),
                    .RNE              (RNE),
                    .RFF              (RFF),
                    .RFHF             (RFHF),
                    .WrPtr            (WrPtr),
                    .RdPtr            (RdPtr)
                   );

// -----------------------------------------------------------------------------
// The MmciTrRxRegFile block is a 16-bit wide 16-deep Register File for
// the Receive FIFO.
// -----------------------------------------------------------------------------
MmciTrRxRegFile uMmciTrRxRegFile     (
                    .PCLK            (PCLK),
                    .PRESETn         (PRESETn),
                    .RegFileWrEn     (RegFileWrEn),
                    .WrPtr           (WrPtr),
                    .RdPtr           (RdPtr),
                    .RxFWrData       (RxFWrData),
                    .RxFRdData       (RxFRdData)
                   );

endmodule
// --================================== End ==================================--
