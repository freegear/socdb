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
//  File Name              : SciTrTxFIFO.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//  Purpose          : This block instantiates the SciTxFCntl, SciTxRegFile 
//                     
// -----------------------------------------------------------------------------
`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SciTrTxFIFO (
                    PCLK,	    
                    PRESETn,	    
                    SCIDRWr,	    
                    TxFRdPtrIncSync,
                    PWDATAIn,	   
                    TxSRLevel,    
                    SCITrTFR,	 
                    TxDataAvlbl,
                    SCITrTFF,
                    SCITrTFE,	
                    TxFRdData
                   );

input        PCLK;              // APB bus clock
input        PRESETn;           // reset (from PRESETn)
input        SCIDRWr;           // Tx FIFO write enable
input        TxFRdPtrIncSync;   // TX FIFO read ptr incr.
input  [7:0] PWDATAIn;          // Int PWDATA
input  [3:0] TxSRLevel;         // TX FIFO level
output       SCITrTFR;          // Tx FIFO service request
output       TxDataAvlbl;       // Tx FIFO data available
output       SCITrTFF;          // Tx FIFO not full
output       SCITrTFE;          // Tx FIFO empty
output [7:0] TxFRdData;         // Tx FIFO Rd data
// -----------------------------------------------------------------------------
//  
//                            SciTxFIFO
//                            =========
//  
// -----------------------------------------------------------------------------
//  
// Overview
// ========
//  
//  The SsiTxFIFO block instantiates the SciTxRegFile block and the SciTxFCntl
// block. The SciTxRegFile block contains the Transmit FIFO register file. 
// Data on the PWDATAIn bus is written into the location in the Receive FIFO 
// pointed to by the current value of the WrPtr[3:0] (Write pointer) signal on 
// the rising edge of PCLK on which the RegFileWrEn signal is sampled high. 
// Data in the FIFO location pointed to by the RdPtr[3:0] signal is always 
// driven on the TxFRdData[15:0] output. The SsiTxFCntl block controls the 
// Read pointer and the Write pointer. Thus, the Transmit FIFO is implemented 
// as a circular buffer. The SciTxFCntl block also generates FIFO status 
// signals TFF and TFE and TFR (Transmit FIFO service request) interrupt.
// 
 

//------------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
wire  RegFileWrEn; 
wire [3:0] RdPtr; 
wire [3:0] WrPtr; 

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------
// The SciTxFCntl block contains the control logic for the Transmit FIFO.
// -----------------------------------------------------------------------------
SciTrTxFCntl uSciTrTxFCntl (
                            .PCLK(PCLK),
                            .PRESETn(PRESETn),
                            .SCIDRWr(SCIDRWr),
                            .TxFRdPtrIncSync(TxFRdPtrIncSync),
                            .TxDataAvlbl(TxDataAvlbl),
                            .SCITrTFR(SCITrTFR),
                            .SCITrTFF(SCITrTFF),
                            .TxSRLevel(TxSRLevel), 
                            .WrPtr(WrPtr),
                            .RdPtr(RdPtr),
                            .RegFileWrEn(RegFileWrEn),
                            .SCITrTFE(SCITrTFE)
                           );

// -----------------------------------------------------------------------------
// The SciTxRegFile block is a 8-bit wide 16-deep Register File for the 
// Transmit FIFO.
// -----------------------------------------------------------------------------
SciTrTxRegFile uSciTrTxRegFile (
                                .PCLK(PCLK),
                                .WrPtr(WrPtr),
                                .RdPtr(RdPtr),
                                .RegFileWrEn(RegFileWrEn),
                                .TxFRdData(TxFRdData),
                                .PWDATAIn(PWDATAIn),
                                .PRESETn(PRESETn)
                               );

endmodule

// --========================= End of SciTrTxFIFO ============================--
