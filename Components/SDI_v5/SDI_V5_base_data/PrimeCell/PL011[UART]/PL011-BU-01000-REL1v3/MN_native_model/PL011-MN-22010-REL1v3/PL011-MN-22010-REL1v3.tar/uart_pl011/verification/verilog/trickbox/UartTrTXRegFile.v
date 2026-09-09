//============================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : UartTrTXRegFile.v.rca
//  File Revision          : 1.3
//  
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//  
//------------------------------------------------------------------------------
// Purpose     : This block contains the Register file for the Transmit FIFO
// ===========================================================================--

`timescale 1ns/1ps

//  ----------------------------------------------------------------------------
module UartTrTXRegFile (
// Inputs
                        PCLK,
                        PRESETn,
                        RegFileWrEn,
                        WrPtr,
                        RdPtr,
                        PWDATAIn,

// Outputs
                        TXFIFOData
                       );

// Inputs
input         PCLK;             // APB Clock
input         PRESETn;          // AMBA reset
input         RegFileWrEn;      // Register file write enable
input   [3:0] WrPtr;            // Write pointer
input   [3:0] RdPtr;            // Read pointer
input   [7:0] PWDATAIn;         // Data bus

// Outputs
output  [7:0] TXFIFOData;       // Read data

// Inputs
wire          PCLK;             // APB Clock
wire          PRESETn;          // AMBA reset
wire          RegFileWrEn;      // Register file write enable
wire    [3:0] WrPtr;            // Write pointer
wire    [3:0] RdPtr;            // Read pointer
wire    [7:0] PWDATAIn;         // Data bus

// Outputs
wire    [7:0] TXFIFOData;       // Read data

//------------------------------------------------------------------------------
//
//                               UartTrTXRegFile
//                               ===============
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//  This block contains an array of flipflops that serve as the storage register
// file for the transmit FIFO.
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------
reg     [7:0] TxReg0;
// Transmit FIFO register0
 
reg     [7:0] NextTxReg0;
// D-input of TxReg0
 
reg     [7:0] TxReg1;
// Transmit FIFO register1
 
reg     [7:0] NextTxReg1;
// D-input of TxReg1
 
reg     [7:0] TxReg2;
// Transmit FIFO register2
 
reg     [7:0] NextTxReg2;
// D-input of TxReg2
 
reg     [7:0] TxReg3;
// Transmit FIFO register3
 
reg     [7:0] NextTxReg3;
// D-input of TxReg3
 
reg     [7:0] TxReg4;
// Transmit FIFO register4
 
reg     [7:0] NextTxReg4;
// D-input of TxReg4
 
reg     [7:0] TxReg5;
// Transmit FIFO register5
 
reg     [7:0] NextTxReg5;
// D-input of TxReg5
 
reg     [7:0] TxReg6;
// Transmit FIFO register6
 
reg     [7:0] NextTxReg6;
// D-input of TxReg6
 
reg     [7:0] TxReg7;
// Transmit FIFO register7
 
reg     [7:0] NextTxReg7;
// D-input of TxReg7
 
reg     [7:0] TxReg8;
// Transmit FIFO register8
 
reg     [7:0] NextTxReg8;
// D-input of TxReg8
 
reg     [7:0] TxReg9;
// Transmit FIFO register9
 
reg     [7:0] NextTxReg9;
// D-input of TxReg9
 
reg     [7:0] TxReg10;
// Transmit FIFO register10
 
reg     [7:0] NextTxReg10;
// D-input of TxReg10
 
reg     [7:0] TxReg11;
// Transmit FIFO register11
 
reg     [7:0] NextTxReg11;
// D-input of TxReg11
 
reg     [7:0] TxReg12;
// Transmit FIFO register12
 
reg     [7:0] NextTxReg12;
// D-input of TxReg12
 
reg     [7:0] TxReg13;
// Transmit FIFO register13
 
reg     [7:0] NextTxReg13;
// D-input of TxReg13
 
reg     [7:0] TxReg14;
// Transmit FIFO register14
 
reg     [7:0] NextTxReg14;
// D-input of TxReg14
 
reg     [7:0] TxReg15;
// Transmit FIFO register15
 
reg     [7:0] NextTxReg15;
// D-input of TxReg15
 
// -----------------------------------------------------------------------------
//
// Main body of the  Code
// ======================
//
// -----------------------------------------------------------------------------
 
// -----------------------------------------------------------------------------
// Register array. Not asynchronously resettable so as to save gates.
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin : p_FIFOSeq
  if (PRESETn == 1'b0)
    begin
      TxReg0  <= 8'h00;
      TxReg1  <= 8'h00;
      TxReg2  <= 8'h00;
      TxReg3  <= 8'h00;
      TxReg4  <= 8'h00;
      TxReg5  <= 8'h00;
      TxReg6  <= 8'h00;
      TxReg7  <= 8'h00;
      TxReg8  <= 8'h00;
      TxReg9  <= 8'h00;
      TxReg10 <= 8'h00;
      TxReg11 <= 8'h00;
      TxReg12 <= 8'h00;
      TxReg13 <= 8'h00;
      TxReg14 <= 8'h00;
      TxReg15 <= 8'h00;
    end
  else
    begin
      TxReg0  <= NextTxReg0;
      TxReg1  <= NextTxReg1;
      TxReg2  <= NextTxReg2;
      TxReg3  <= NextTxReg3;
      TxReg4  <= NextTxReg4;
      TxReg5  <= NextTxReg5;
      TxReg6  <= NextTxReg6;
      TxReg7  <= NextTxReg7;
      TxReg8  <= NextTxReg8;
      TxReg9  <= NextTxReg9;
      TxReg10 <= NextTxReg10;
      TxReg11 <= NextTxReg11;
      TxReg12 <= NextTxReg12;
      TxReg13 <= NextTxReg13;
      TxReg14 <= NextTxReg14;
      TxReg15 <= NextTxReg15;
    end
end // p_FIFOSeq
 
// -----------------------------------------------------------------------------
// Write logic. When the Write enable signal, RegFileWrEn, is asserted, data on
// the write data bus PWDATAIn is written into the location pointed to by the
// current value of the Write pointer, WrPtr[3:0].
// -----------------------------------------------------------------------------
always @(TxReg0 or TxReg1 or TxReg2 or TxReg3 or TxReg4 or TxReg5 or TxReg6 or 
         TxReg7 or TxReg8 or TxReg9 or TxReg10 or TxReg11 or TxReg12 or
         TxReg13 or TxReg14 or TxReg15 or WrPtr or RegFileWrEn or PWDATAIn)
begin : p_WrComb
  NextTxReg0  = TxReg0;
  NextTxReg1  = TxReg1;
  NextTxReg2  = TxReg2;
  NextTxReg3  = TxReg3;
  NextTxReg4  = TxReg4;
  NextTxReg5  = TxReg5;
  NextTxReg6  = TxReg6;
  NextTxReg7  = TxReg7;
  NextTxReg8  = TxReg8;
  NextTxReg9  = TxReg9;
  NextTxReg10 = TxReg10;
  NextTxReg11 = TxReg11;
  NextTxReg12 = TxReg12;
  NextTxReg13 = TxReg13;
  NextTxReg14 = TxReg14;
  NextTxReg15 = TxReg15;
  if (RegFileWrEn == 1'b1)
    case (WrPtr)
      4'h0 : NextTxReg0  = PWDATAIn;
      4'h1 : NextTxReg1  = PWDATAIn;
      4'h2 : NextTxReg2  = PWDATAIn;
      4'h3 : NextTxReg3  = PWDATAIn;
      4'h4 : NextTxReg4  = PWDATAIn;
      4'h5 : NextTxReg5  = PWDATAIn;
      4'h6 : NextTxReg6  = PWDATAIn;
      4'h7 : NextTxReg7  = PWDATAIn;
      4'h8 : NextTxReg8  = PWDATAIn;
      4'h9 : NextTxReg9  = PWDATAIn;
      4'hA : NextTxReg10 = PWDATAIn;
      4'hB : NextTxReg11 = PWDATAIn;
      4'hC : NextTxReg12 = PWDATAIn;
      4'hD : NextTxReg13 = PWDATAIn;
      4'hE : NextTxReg14 = PWDATAIn;
      4'hF : NextTxReg15 = PWDATAIn;
      //default : null;
    endcase
end // p_WrComb
 
// -----------------------------------------------------------------------------
// Read Mux. The contents of the location pointed to by the current value of
// the read pointer RdPtr, is driven onto the read databus, TXFIFOData.
// -----------------------------------------------------------------------------
assign TXFIFOData = (RdPtr == 4'h0) ?
                    TxReg0  : ((RdPtr == 4'h1) ?
                    TxReg1  : ((RdPtr == 4'h2) ?
                    TxReg2  : ((RdPtr == 4'h3) ?
                    TxReg3  : ((RdPtr == 4'h4) ?
                    TxReg4  : ((RdPtr == 4'h5) ?
                    TxReg5  : ((RdPtr == 4'h6) ?
                    TxReg6  : ((RdPtr == 4'h7) ?
                    TxReg7  : ((RdPtr == 4'h8) ?
                    TxReg8  : ((RdPtr == 4'h9) ?
                    TxReg9  : ((RdPtr == 4'hA) ?
                    TxReg10 : ((RdPtr == 4'hB) ?
                    TxReg11 : ((RdPtr == 4'hC) ?
                    TxReg12 : ((RdPtr == 4'hD) ?
                    TxReg13 : ((RdPtr == 4'hE) ?
                    TxReg14 : ((RdPtr == 4'hF) ?
                    TxReg15 : 8'h00)))))))))))))));

endmodule

//========================== End of UartTrTXRegFile ==========================--
