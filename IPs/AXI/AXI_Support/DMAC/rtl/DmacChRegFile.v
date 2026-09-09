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
// File Name              : DmacChRegFile.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Register File for the Channel FIFO
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacChRegFile (
// Inputs
                      // AHB Inputs
                      HCLK,
                      HRESETn,
                      // From DmacChPckUnpck block
                      FifoWrEn,
                      FifoWrPtr,
                      FifoWrData,
                      FifoWrMask,
                      FifoRdPtr,

// Outputs
                      // To DmacChPckUnpck block
                      FifoRdData
                     );

// Inputs
// AHB Inputs
input         HCLK;       // AHB Clock
input         HRESETn;    // AHB Reset
// From DmacChPckUnpck block
input         FifoWrEn;   // Data write enable in FIFO
input   [1:0] FifoWrPtr;  // FIFO write pointer
input  [31:0] FifoWrData; // data to be written into the FIFO
input  [31:0] FifoWrMask; // mask for writing into a specific data-lane in
                          // FIFO
input   [1:0] FifoRdPtr;  // FIFO read pointer

// Outputs
// To DmacChPckUnpck block
output [31:0] FifoRdData; // Data read out of FIFO


// Inputs
// AHB Inputs
wire          HCLK;       // AHB Clock
wire          HRESETn;    // AHB Reset
// From DmacChPckUnpck block
wire          FifoWrEn;   // Data write enable in FIFO
wire    [1:0] FifoWrPtr;  // FIFO write pointer
wire   [31:0] FifoWrData; // data to be written into the FIFO
wire   [31:0] FifoWrMask; // mask for writing into a specific data-lane in
                          // FIFO
wire    [1:0] FifoRdPtr;  // FIFO read pointer

// Outputs
// To DmacChPckUnpck block
reg    [31:0] FifoRdData; // Data read out of FIFO


// -----------------------------------------------------------------------------
//
//                                DmacChRegFile
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This file performs the following functionalities:
// o Register file for the channel FIFO is described. When FIFOWrEn (the write
//   enable signal) is asserted, FifoWrData is masked with FifoWrMask and is
//   written into the location pointed to by the current value of the Write
//   pointer (FifoWrPtr).
// o Read-data-mux is described. When FIFO is accessed for read, the contents of
//   the location pointed to by the current value of the read pointer (RdPtr),
//   are driven onto RdData.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [31:0] ChFIFOReg0;
// Transmit FIFO register 0

reg  [31:0] NextChFIFOReg0;
// D-input of ChFIFOReg0

reg  [31:0] ChFIFOReg1;
// Transmit FIFO register 1

reg  [31:0] NextChFIFOReg1;
// D-input of ChFIFOReg1

reg  [31:0] ChFIFOReg2;
// Transmit FIFO register 2

reg  [31:0] NextChFIFOReg2;
// D-input of ChFIFOReg2

reg  [31:0] ChFIFOReg3;
// Transmit FIFO register 3

reg  [31:0] NextChFIFOReg3;
// D-input of ChFIFOReg3

//Include Parameters File
`include "DmacParams.v"

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
// Write logic.
// When the Write enable signal (FifoWrEn) is asserted, data on the write
// databus (FifoWrData) is masked with FifoWrMask and written into the location
// pointed to by the current value of the Write pointer (FifoWrPtr).
// -----------------------------------------------------------------------------
always @(ChFIFOReg0 or ChFIFOReg1 or ChFIFOReg2 or ChFIFOReg3 or FifoWrPtr or
         FifoWrEn or FifoWrData or FifoWrMask)
begin : p_ChFIFORegComb
  NextChFIFOReg0   = ChFIFOReg0;
  NextChFIFOReg1   = ChFIFOReg1;
  NextChFIFOReg2   = ChFIFOReg2;
  NextChFIFOReg3   = ChFIFOReg3;
  if (FifoWrEn == 1'b1)
    begin
      case (FifoWrPtr)
        2'b00 : NextChFIFOReg0   = ((FifoWrData & FifoWrMask) |
                                    (( ~(FifoWrMask)) & ChFIFOReg0));
        2'b01 : NextChFIFOReg1   = ((FifoWrData & FifoWrMask) |
                                    (( ~(FifoWrMask)) & ChFIFOReg1));
        2'b10 : NextChFIFOReg2   = ((FifoWrData & FifoWrMask) |
                                    (( ~(FifoWrMask)) & ChFIFOReg2));
        2'b11 : NextChFIFOReg3   = ((FifoWrData & FifoWrMask) |
                                    (( ~(FifoWrMask)) & ChFIFOReg3));
        default : NextChFIFOReg0   = ((FifoWrData & FifoWrMask) |
                                      (( ~(FifoWrMask)) & ChFIFOReg0));
      endcase
    end
end // p_ChFIFORegComb

// -----------------------------------------------------------------------------
// Sequential logic for generation of the register array
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_ChFIFORegSeq
  if (HRESETn == 1'b0)
    begin
      ChFIFOReg0       <= {32{1'b0}};
      ChFIFOReg1       <= {32{1'b0}};
      ChFIFOReg2       <= {32{1'b0}};
      ChFIFOReg3       <= {32{1'b0}};
    end
  else
    begin
      ChFIFOReg0       <= NextChFIFOReg0;
      ChFIFOReg1       <= NextChFIFOReg1;
      ChFIFOReg2       <= NextChFIFOReg2;
      ChFIFOReg3       <= NextChFIFOReg3;
    end
end // p_ChFIFORegSeq

// -----------------------------------------------------------------------------
// The following statement describes a read-mux.
// The contents of the location pointed to by the current value of the
// read pointer (FifoRdPtr), is driven onto the read databus (FifoRdData).
// -----------------------------------------------------------------------------
always @(FifoRdPtr or ChFIFOReg0 or ChFIFOReg1 or ChFIFOReg2 or ChFIFOReg3)
begin : p_FifoRdDataComb
  case (FifoRdPtr)
    2'b00 : FifoRdData       = ChFIFOReg0;
    2'b01 : FifoRdData       = ChFIFOReg1;
    2'b10 : FifoRdData       = ChFIFOReg2;
    2'b11 : FifoRdData       = ChFIFOReg3;
    default : FifoRdData       = {32{1'b0}};
  endcase
end // p_FifoRdDataComb

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
