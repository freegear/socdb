// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : SspTxFIFO.v.rca
//  File Revision          : 1.3
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
// -----------------------------------------------------------------------------
  
// -----------------------------------------------------------------------------

//  Purpose          : This block instantiates the SspTxFCntl, SspTxLJustify 
//                     and the SspTxRegFile blocks

// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SspTxFIFO (
// Inputs
                  PCLK, 
                  PRESETn, 
                  MS, 
                  SSPDRWr, 
                  TxFRdPtrIncSync, 
                  TxRxBSYSync, 
                  TXIM, 
                  FRFPCLK, 
                  DSSPCLK, 
                  PWDATAIn,
				  TxDMALevel,
// Outputs
                  TNF, 
                  TFE, 
                  BSY,
                  TXRIS,
                  TXMIS,
                  FIFOLTE7Full, 
                  TxDataAvlbl,
                  TxFRdData,
                  TxFRdDataIn,
		  TxFFillLevel	
                 );

// Inputs
input         PCLK;             // APB bus clock
input         PRESETn;          // Muxed reset (from BPRESETn)
input         MS;               // Master / Slave Select bit
input         SSPDRWr;          // Tx FIFO write enable
input         TxFRdPtrIncSync;  // TX FIFO read ptr incr.
input         TxRxBSYSync;      // Tx/Rx controller busy
input         TXIM;             // Intr enable for SSPTFSINTR
input   [1:0] FRFPCLK;          // Frame format
input   [3:0] DSSPCLK;          // Data size
input  [15:0] PWDATAIn;         // Int PWDATA
input	[3:0] TxDMALevel;


// Outputs
output        TNF;              // Tx FIFO not full
output        TFE;              // Tx FIFO empty
output        BSY;              // SSP Busy
output        TXRIS;            // Tx FIFO Raw Interrupt Status  
output        TXMIS;            // Tx FIFO Masked Interrupt Status  
output        FIFOLTE7Full;     // TX FIFO has one or more spaces
output        TxDataAvlbl;      // Tx FIFO data available
output [15:0] TxFRdData;        // Tx FIFO read data (unjustified)
output [15:0] TxFRdDataIn;      // Tx FIFO read data (left justified)
output	[3:0] TxFFillLevel;

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
// Wire Declarations 
// -----------------------------------------------------------------------------

wire        RegFileWrEn; 
wire  [2:0] RdPtr; 
wire  [2:0] WrPtr; 
wire [15:0] TxFRdData; 

// -----------------------------------------------------------------------------
// The SspTxFCntl block contains the control logic for the Transmit FIFO.
// -----------------------------------------------------------------------------
 SspTxFCntl uSspTxFCntl                  (
                        .PCLK            (PCLK),
                        .PRESETn         (PRESETn),
                        .TXIM            (TXIM),
                        .SSPDRWr         (SSPDRWr),
                        .TxFRdPtrIncSync (TxFRdPtrIncSync),
                        .TxRxBSYSync     (TxRxBSYSync),
						.TxDMALevel		 (TxDMALevel),
                        .TxDataAvlbl     (TxDataAvlbl),
                        .TNF             (TNF),
                        .TFE             (TFE),
                        .BSY             (BSY),
                        .TXRIS           (TXRIS),
                        .TXMIS           (TXMIS),
                        .FIFOLTE7Full    (FIFOLTE7Full),
                        .RegFileWrEn     (RegFileWrEn),
                        .WrPtr           (WrPtr),
                        .RdPtr           (RdPtr),
			.TxFFillLevel	 (TxFFillLevel)
                       );


// -----------------------------------------------------------------------------
// The SspTxRegFile block is a 16-bit wide 8-deep Register File for the Transmit
// FIFO.
// -----------------------------------------------------------------------------
 SspTxRegFile uSspTxRegFile              (
                        .PCLK            (PCLK),
                        .PRESETn         (PRESETn),
                        .PWDATAIn        (PWDATAIn),
                        .WrPtr           (WrPtr),
                        .RdPtr           (RdPtr),
                        .RegFileWrEn     (RegFileWrEn),
                        .TxFRdData       (TxFRdData)
                       );


// -----------------------------------------------------------------------------
// The SspTxLJustify block left-justifies transmit data from the Transmit
// FIFO.
// -----------------------------------------------------------------------------
 SspTxLJustify uSspTxLJustify            (
                        .PCLK            (PCLK),
                        .PRESETn         (PRESETn),
                        .MS              (MS),
                        .FRFPCLK         (FRFPCLK),
                        .DSSPCLK         (DSSPCLK),
                        .TxFRdData       (TxFRdData),
                        .TxFRdDataIn     (TxFRdDataIn)
                       );
endmodule

// --=============================== End =====================================--
