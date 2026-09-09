//  ----------------------------------------------------------------------------
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : SspTrTxFIFO.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
//  ----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------
//  Purpose          : This block instantiates the SspTxFCntl, SspTxLJustify 
//                     and the SspTxRegFile blocks
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// ----------------------------------------------------------------------------

module SspTrTxFIFO(
                   PCLK,
                   PRESETn,
                   SSPTBTDRWr,
                   TxFRdPtrIncSync,
                   STxFRdPtrIncSync,
                   MS,
                   TxRxBSYSync,
                   FRF,
                   DSS,
                   PWDATAIn,
                   TxDataAvlbl,
                   TNF,
                   TFE,
                   BSY,
                   TxFRdDataIn
                  );
input 	      PCLK;	        // APB bus clock
input 	      PRESETn;	        // APB bus Reset 
input 	      SSPTBTDRWr;       // Tx FIFO write enable
input 	      TxFRdPtrIncSync;	// TX FIFO read ptr incr.
input 	      STxFRdPtrIncSync;	// TX FIFO read ptr incr.
input         MS;               // Master/Slave select bit
input         TxRxBSYSync;      // Tx/Rx controller busy
input 	[1:0] FRF;	        // Frame format
input 	[3:0] DSS;	        // Data size
input  [15:0] PWDATAIn;	        // Int PWDATA
output	      TxDataAvlbl;      // Tx FIFO data available
output	      TNF;              // Tx FIFO not full
output	      TFE;              // Tx FIFO empty
output        BSY;              // SSP Busy
output [15:0] TxFRdDataIn;	// Tx FIFO read data

// -----------------------------------------------------------------------------
//  
//                            SspTxFIFO
//                            =========
//  
// -----------------------------------------------------------------------------
//  
// Overview
// ========
//  
//  The SspTxFIFO block instantiates the SspTxRegFile block, the SspTxFCntl
// block and the SspTxLJustify block.
//  The SspTxRegFile block contains the Transmit FIFO register file. Data
// on the PWDATAIn bus is written into the location in the Receive FIFO pointed
// to by the current value of the WrPtr[2:0] (Write pointer) signal on the 
// rising edge of PCLK on which the RegFileWrEn signal is sampled high. Data in
// the FIFO location pointed to by the RdPtr[2:0] signal is always driven on the
// TxFRdData[15:0] output. 
//  The SspTxFCntl block controls the Read pointer and the Write pointer. Thus,
// the Transmit FIFO is implemented as a circular buffer. The SspTxFCntl block
// also generates FIFO status signals TNF and TFE besides the SSPTFSINTR 
// (Transmit FIFO service request) interrupt.
//   The SspTxLJustify block performs left-justification of transmit data to 
// the Transmit control state machine.
// -----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Wire Declarations
// ----------------------------------------------------------------------------

wire        PCLK;
// APB bus clock

wire        PRESETn;
// APB bus Reset 

wire        SSPTBTDRWr;
// Tx FIFO write enable

wire        TxFRdPtrIncSync;
// TX FIFO read ptr incr.

wire        STxFRdPtrIncSync;
// TX FIFO read ptr incr.

wire        MS;
// Master/Slave select bit

wire         TxRxBSYSync;
// Tx/Rx controller busy

wire  [1:0] FRF;
// Frame format

wire  [3:0] DSS;
// Data size

wire [15:0] PWDATAIn;
// Int PWDATA

wire        TxDataAvlbl;
// Tx FIFO data available

wire        TNF;
// Tx FIFO not full

wire        TFE;
// Tx FIFO empty

wire        BSY;
// SSP Busy

wire [15:0] TxFRdDataIn;
// Tx FIFO read data

wire        RegFileWrEn; 
// Register file write enable

wire  [3:0] RdPtr; 
// Read pointer

wire  [3:0] WrPtr; 
// Write pointer

wire [15:0] TxFRdData; 
// Transmiter FIFO Read data


// -----------------------------------------------------------------------------
// The SspTxFCntl block contains the control logic for the Transmit FIFO.
// -----------------------------------------------------------------------------
SspTrTxFCntl uSspTrTxFCntl (
                            .PCLK(PCLK),
	                    .PRESETn(PRESETn) ,
                            .SSPTBTDRWr(SSPTBTDRWr),
	                    .TxFRdPtrIncSync(TxFRdPtrIncSync),
	                    .STxFRdPtrIncSync(STxFRdPtrIncSync),
	                    .TxDataAvlbl(TxDataAvlbl),
	                    .TNF(TNF),
	                    .WrPtr(WrPtr),
	                    .RdPtr(RdPtr),
	                    .RegFileWrEn(RegFileWrEn),
	                    .TFE(TFE),
	                    .TxRxBSYSync(TxRxBSYSync),
	                    .BSY(BSY)
                           );

// -----------------------------------------------------------------------------
// The SspTxRegFile block is a 16-bit wide 8-deep Register File for the Transmit
// FIFO.
// -----------------------------------------------------------------------------
 SspTrTxRegFile uSspTrTxRegFile	(
                                 .PCLK(PCLK) , 
                                 .WrPtr(WrPtr) , 
                                 .RdPtr(RdPtr) , 
                                 .RegFileWrEn(RegFileWrEn) , 
                                 .TxFRdData(TxFRdData) , 
                                 .PWDATAIn(PWDATAIn) , 
                                 .PRESETn(PRESETn)
                                );

// -----------------------------------------------------------------------------
// The SspTxLJustify block left-justifies transmit data from the Transmit
// FIFO.
// -----------------------------------------------------------------------------
 SspTrTxLJustify uSspTrTxLJustify (
                                   .PCLK(PCLK) , 
                                   .PRESETn(PRESETn) , 
                                   .FRF(FRF) , 
                                   .DSS(DSS) , 
                                   .MS(MS),
                                   .TxFRdData(TxFRdData) , 
                                   .TxFRdDataIn(TxFRdDataIn)
                                  );
endmodule

// --================================ End ====================================-- 
