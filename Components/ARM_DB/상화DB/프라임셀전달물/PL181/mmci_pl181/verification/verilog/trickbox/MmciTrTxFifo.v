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
// File Name              : MmciTrTxFifo.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block instantiates the MmciTrTxFCntl, MmciTrTxRegFile
//           blocks.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MmciTrTxFifo (
// Inputs
                     PCLK,
                     PRESETn,
                     FifoClearSync,
                     MMCITBTXFWr,
                     TxFRdSync,
                     PWDATAIn,
// Outputs
                     TxDataAvlbl,
                     TNF,
                     TFE,
                     TFHE,
                     TxFRdData
                    );

// Inputs
input         PCLK;          // APB bus clock
input         PRESETn;       // Bus reset
input         FifoClearSync; // FifoClear signal
input         MMCITBTXFWr;   // Tx FIFO write enable
input         TxFRdSync;     // TX FIFO read ptr incr.
input  [31:0] PWDATAIn;      // Int PWDATA

// Outputs
output        TxDataAvlbl;   // Tx FIFO data available
output        TNF;           // Tx FIFO not full
output        TFE;           // Tx FIFO empty
output        TFHE;          // Tx FIFO half empty
output [31:0] TxFRdData;     // Tx FIFO Rddata

// Inputs
wire        PCLK;            // APB bus clock
wire        PRESETn;         // Bus reset
wire        FifoClearSync;   // FifoClear signal
wire        MMCITBTXFWr;     // Tx FIFO write enable
wire        TxFRdSync;       // TX FIFO read ptr incr.
wire [31:0] PWDATAIn;        // Int PWDATA

// Outputs
wire        TxDataAvlbl;     // Tx FIFO data available
wire        TNF;             // Tx FIFO not full
wire        TFE;             // Tx FIFO empty
wire        TFHE;            // Tx FIFO half empty
wire [31:0] TxFRdData;       // Tx FIFO Rddata

// -----------------------------------------------------------------------------
//
//                                MmciTrTxFifo
//                                ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// The MmciTrTxFIFO block instantiates the MmciTrTxRegFile block, the
// MmciTrTxFCntl block.
// The MmciTrTxRegFile block contains the Transmit FIFO register file.
// Data on the PWDATAIn bus is written into the location in the Receive
// FIFO pointed to by the current value of the WrPtr[4:0](Write pointer)
// signal on the rising edge of PCLK on which the RegFileWrEn signal
// is sampled high. Data in the FIFO location pointed to by the
// RdPtr[4:0] signal is always driven on the TxFRdData[31:0] output.
// The MmciTrTxFCntl block controls the Read pointer and the Write
// pointer. Thus, the Transmit FIFO is implemented as a circular buffer.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire       RegFileWrEn;
// Enable for valid Writes into Tx FIFO

wire [4:0] RdPtr;
// Read pointer, points to the location from where data is to be read

wire [4:0] WrPtr;
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
// The MmciTrTxFCntl block contains the control logic for the
// Transmit FIFO.
// -----------------------------------------------------------------------------
MmciTrTxFCntl uMmciTrTxFCntl          (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .FifoClearSync    (FifoClearSync),
                    .MMCITBTXFWr      (MMCITBTXFWr),
                    .TxFRdSync        (TxFRdSync),
                    .TxDataAvlbl      (TxDataAvlbl),
                    .TNF              (TNF),
                    .WrPtr            (WrPtr),
                    .RdPtr            (RdPtr),
                    .RegFileWrEn      (RegFileWrEn),
                    .TFE              (TFE),
                    .TFHE             (TFHE)
                   );

// -----------------------------------------------------------------------------
//  The MmciTrTxRegFile block is a 32-bit wide 32-deep Register File for
// the Transmit FIFO.
// -----------------------------------------------------------------------------
MmciTrTxRegFile uMmciTrTxRegFile      (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .RegFileWrEn      (RegFileWrEn),
                    .WrPtr            (WrPtr),
                    .RdPtr            (RdPtr),
                    .PWDATAIn         (PWDATAIn),
                    .TxFRdData        (TxFRdData)
                   );

endmodule
// --================================== End ==================================--
