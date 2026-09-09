// --=========================================================================--
//  This confidential  and  proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies  and  copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
// ----------------------------------------------------------------------------
//  Version  and  Release Control Information:
//  
//  File Name              : SspTrRxFIFO.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
// -----------------------------------------------------------------------------
//  Purpose          : This block instantiates the SspTrRxFCntl  and  the
//                     SspTrRxRegFile blocks
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SspTrRxFIFO( 
                   PCLK,
                   PRESETn,
                   RxFWrSync,
                   SRxFWrSync,
                   RxFRdPtrInc, 
                   RXW,	       
                   RxFWrData, 
                   RXWFLG,    
                   RNE,	    
                   RFF,   
                   RxFRdData
                  );

input            PCLK;	       // APB bus clock
input            PRESETn;      // APB bus reset 
input            RxFWrSync;    // RX FIFO write enable
input            SRxFWrSync;   // RX FIFO write enable
input            RxFRdPtrInc;  // RX FIFO read pointer incr.
input      [1:0] RXW;          // Rx watermark lvl.
input     [15:0] RxFWrData;    // RX FIFO Wr data
output           RXWFLG;       // RX FIFO Waterlevel flag 
output           RNE;          // RX FIFO not empty
output           RFF;	       // RX FIFO full
output    [15:0] RxFRdData;    // RX FIFO read data

// -----------------------------------------------------------------------------
//
//                            SspTrRxFIFO
//                            ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//  The SspTrRxFIFO block instantiates the SspTrRxRegFile block  and  the
//  SspTrRxFCntl block. The SspTrRxRegFile block contains the Receive FIFO
//  register file. Data on the RxFWrData bus is written into the location
//  in the Receive FIFO pointed to by the current value of the WrPtr[3:0]
//  (Write pointer) signal on the rising edge of PCLK on which the RegFileWrEn
//  signal is sampled high. Data in the FIFO location pointed to by the
//  RdPtr[3:0] signal is always driven on the RxFRdData[15:0] output.
//  The SspTrRxFCntl block controls the Read pointer  and  the Write pointer.Thus,
//  the Receive FIFO is implemented as a circular buffer.The SspTrRxFCntl block
//  also generates FIFO status signals RFF  and  RNE.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
wire        PCLK;
// APB bus clock

wire        PRESETn;
// APB bus reset

wire        RxFWrSync;
// RX FIFO write enable

wire        SRxFWrSync;
// RX FIFO write enable

wire        RxFRdPtrInc;
// RX FIFO read pointer incr.

wire  [1:0] RXW;
// Rx watermark lvl.

wire [15:0] RxFWrData;
// RX FIFO Wr data

wire        RegFileWrEn;
// Register file Write Data

wire  [3:0] WrPtr;
// Write Ponter

wire  [3:0] RdPtr;
// Read pointer

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// The SspTrRxFCntl block contains the control logic for the Receive FIFO.
// -----------------------------------------------------------------------------
SspTrRxFCntl uSspTrRxFCntl (
                            .PCLK        (PCLK),
                            .PRESETn       (PRESETn),
                            .RxFWrSync   (RxFWrSync),
                            .SRxFWrSync  (SRxFWrSync),
                            .RxFRdPtrInc (RxFRdPtrInc),
                            .WrPtr       (WrPtr),
                            .RdPtr       (RdPtr),
                            .RegFileWrEn (RegFileWrEn),
                            .RNE         (RNE),
                            .RXWFLG      (RXWFLG), 
                            .RFF         (RFF),
                            .RXW         (RXW)
                           );

// -----------------------------------------------------------------------------
// The SspTrRxRegFile block is a 16-bit wide 16-deep Register File for the 
// Receive FIFO.
// -----------------------------------------------------------------------------
SspTrRxRegFile uSspTrRxRegFile (
                                .PCLK         (PCLK),
                                .RxFWrData    (RxFWrData),
                                .RegFileWrEn  (RegFileWrEn),
                                .WrPtr        (WrPtr),
                                .RdPtr        (RdPtr),
                                .RxFRdData    (RxFRdData),
                                .PRESETn      (PRESETn)
                               );

endmodule

// --============================  End  ======================================--
