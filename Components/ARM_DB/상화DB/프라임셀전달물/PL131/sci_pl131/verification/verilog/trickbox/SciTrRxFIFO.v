// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : SciTrRxFIFO.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//  Purpose          : This block instantiates the SciRxFCntl and the
//                     SciRxRegFile blocks
// -----------------------------------------------------------------------------
`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SciTrRxFIFO (
                    PCLK,	
                    PRESETn,	
                    RxFWrSync,	
                    RxFRdPtrInc,
                    RxSRLevel, 
                    RxFWrData,
                    SCITrRFR,
                    SCITrRFE,
                    SCITrRFF,
                    RxFRdData
                   );

input         PCLK;         // APB bus clock
input         PRESETn;      // reset (from PRESETn)
input         RxFWrSync;    // RX FIFO write enable
input         RxFRdPtrInc;  // RX FIFO read pointer incr.
input  [3:0]  RxSRLevel;    // RX FIFO level
input  [8:0]  RxFWrData;    // RX FIFO write data
output        SCITrRFR;     // RX FIFO service request
output        SCITrRFE;     // RX FIFO not empty
output        SCITrRFF;     // RX FIFO full
output [8:0]  RxFRdData;    // RX FIFO read data
// -----------------------------------------------------------------------------
// 
//                            SciTrRxFIFO
//                            ===========
// 
// -----------------------------------------------------------------------------
// 
// Overview
// ========
// 
//  The SciRxFIFO block instantiates the SciRxRegFile block and the SciRxFCntl
// block. The SciRxRegFile block contains the Receive FIFO register file. Data
// on the RxFWrData bus is written into the location in the Receive FIFO pointed
// to by the current value of the WrPtr[3:0] (Write pointer) signal on the
// rising edge of PCLK on which the RegFileWrEn signal is sampled high. Data in
// the FIFO location pointed to by the RdPtr[3:0] signal is always driven on the
// RxFRdData[15:0] output. 
//  The SciRxFCntl block controls the Read pointer and the Write pointer. Thus,
// the Receive FIFO is implemented as a circular buffer. The SciRxFCntl block
// also generates FIFO status signals RFF,RNE and RFR 
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------

wire       RegFileWrEn;
wire [3:0] WrPtr;
wire [3:0] RdPtr;
 
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------
// The SciRxFCntl block contains the control logic for the Receive FIFO.
// -----------------------------------------------------------------------------

SciTrRxFCntl uSciTrRxFCntl (
                            .PCLK(PCLK),
                            .PRESETn(PRESETn),
                            .RxFWrSync(RxFWrSync),
                            .RxFRdPtrInc(RxFRdPtrInc),
                            .WrPtr(WrPtr),
                            .RdPtr(RdPtr),
                            .RxSRLevel(RxSRLevel),
                            .RegFileWrEn(RegFileWrEn),
                            .SCITrRFE(SCITrRFE),
                            .SCITrRFR(SCITrRFR),
                            .SCITrRFF(SCITrRFF)
                           );

// -----------------------------------------------------------------------------
// The SciRxRegFile block is a 9-bit wide 16-deep Register File for the Receive
// FIFO.
// -----------------------------------------------------------------------------

SciTrRxRegFile uSciTrRxRegFile (
                                .PCLK(PCLK),
                                .RxFWrData(RxFWrData),
                                .RegFileWrEn(RegFileWrEn),
                                .WrPtr(WrPtr),
                                .RdPtr(RdPtr),
                                .RxFRdData(RxFRdData),
                                .PRESETn(PRESETn)
                               );

endmodule
// --======================= End of SciTrRxFIFO ==============================-





