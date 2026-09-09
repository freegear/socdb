// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name              : SspTrTxRegFile.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
// -----------------------------------------------------------------------------
// Purpose      : Register File for Transmit FIFO
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SspTrTxRegFile 
                     (
                      PCLK,
                      PRESETn, 
                      RegFileWrEn,
                      WrPtr,
                      RdPtr, 
                      PWDATAIn,
                      TxFRdData
                     );

input         PCLK ;        // APB bus clock
input         PRESETn;        // Muxed Reset (from BPRESETn)
input         RegFileWrEn;  // Write enable for Reg file 
input   [3:0] WrPtr;        // Write pointer
input   [3:0] RdPtr;        // Read pointer
input  [15:0] PWDATAIn;     // Int PWDATA
output [15:0] TxFRdData;    // Read data
// -----------------------------------------------------------------------------
//
//                               SspTrTxRegFile
//                               ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This module contains the Register file for the Transmit FIFO. When the 
// Write enable signal RegFileWrEn is asserted, data on the write data bus 
// PWDATAIn is written into the location pointed to by the current value of the
// Write pointer WrPtr. On the read interface, the contents of the location
// pointed to by the current value of the read pointer RdPtr, is driven onto
// the read databus, TxFRdData.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

wire         PCLK ;
// APB bus clock

wire         PRESETn;
// Muxed Reset (from BPRESETn)

wire         RegFileWrEn;
// Write enable for Reg file 

wire   [3:0] WrPtr;
// Write pointer

wire   [3:0] RdPtr;
// Read pointer

wire  [15:0] PWDATAIn;
// Int PWDATA

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg [15:0] TxReg0 ;
// Transmit FIFO register0 

reg [15:0] NextTxReg0;
// D-input of TxReg0

reg [15:0] TxReg1;
// Transmit FIFO register1

reg [15:0] NextTxReg1;
// D-input of TxReg1

reg [15:0] TxReg2;
// Transmit FIFO register2

reg [15:0] NextTxReg2;
// D-input of TxReg2

reg [15:0] TxReg3   ;
// Transmit FIFO register3

reg [15:0] NextTxReg3;
// D-input of TxReg3

reg [15:0] TxReg4;
// Transmit FIFO register4

reg [15:0] NextTxReg4;
// D-input of TxReg4

reg [15:0] TxReg5;
// Transmit FIFO register5

reg [15:0] NextTxReg5;
// D-input of TxReg5

reg [15:0] TxReg6;
// Transmit FIFO register6

reg [15:0] NextTxReg6;
// D-input of TxReg6

reg [15:0] TxReg7;
// Transmit FIFO register7

reg [15:0] NextTxReg7;
// D-input of TxReg7

reg [15:0] TxReg8;
// Transmit FIFO register8

reg [15:0] NextTxReg8;
// D-input of TxReg8

reg [15:0] TxReg9;
// Transmit FIFO register9

reg [15:0] NextTxReg9;
// D-input of TxReg9

reg [15:0] TxReg10;
// Transmit FIFO register10

reg [15:0] NextTxReg10;
// D-input of TxReg10

reg [15:0] TxReg11;
// Transmit FIFO register11

reg [15:0] NextTxReg11;
// D-input of TxReg11

reg [15:0] TxReg12;
// Transmit FIFO register12

reg [15:0] NextTxReg12;
// D-input of TxReg12

reg [15:0] TxReg13;
// Transmit FIFO register13

reg [15:0] NextTxReg13;
// D-input of TxReg13

reg [15:0] TxReg14;
// Transmit FIFO register14

reg [15:0] NextTxReg14;
// D-input of TxReg14

reg [15:0] TxReg15;
// Transmit FIFO register15

reg [15:0] NextTxReg15;
// D-input of TxReg15

// -----------------------------------------------------------------------------
// 
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Register array. Not asynchronously resettable so as to save gates.
// -----------------------------------------------------------------------------
always @ (posedge PCLK or negedge PRESETn)
begin : p_Seq
  if (PRESETn == 1'b0) 
    begin
      TxReg0  <=  16'b0000000000000000;
      TxReg1  <=  16'b0000000000000000;
      TxReg2  <=  16'b0000000000000000;
      TxReg3  <=  16'b0000000000000000;
      TxReg4  <=  16'b0000000000000000;
      TxReg5  <=  16'b0000000000000000;
      TxReg6  <=  16'b0000000000000000;
      TxReg7  <=  16'b0000000000000000;
      TxReg8  <=  16'b0000000000000000;
      TxReg9  <=  16'b0000000000000000;
      TxReg10 <=  16'b0000000000000000;
      TxReg11 <=  16'b0000000000000000;
      TxReg12 <=  16'b0000000000000000;
      TxReg13 <=  16'b0000000000000000;
      TxReg14 <=  16'b0000000000000000;
      TxReg15 <=  16'b0000000000000000;
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
end  // p_Seq;

// -----------------------------------------------------------------------------
// Write logic. When the Write enable signal, RegFileWrEn, is asserted, data on
// the write data bus PWDATAIn is written into the location pointed to by the
// current value of the Write pointer, WrPtr[3:0].
// -----------------------------------------------------------------------------
always @(TxReg0 or TxReg1 or TxReg2 or TxReg3 or TxReg4 or TxReg5 or TxReg6 or 
         TxReg7 or TxReg8 or TxReg9 or TxReg10 or TxReg11 or TxReg12
         or TxReg13 or TxReg14 or TxReg15 or WrPtr or RegFileWrEn or PWDATAIn)
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
  if (RegFileWrEn == 1'b1) begin
    case (WrPtr)
      4'b0000 :
        NextTxReg0 = PWDATAIn;
      4'b0001 :
        NextTxReg1 = PWDATAIn;
      4'b0010 :
        NextTxReg2 = PWDATAIn;
      4'b0011 :
        NextTxReg3 = PWDATAIn;
      4'b0100 :
        NextTxReg4 = PWDATAIn;
      4'b0101 :
        NextTxReg5 = PWDATAIn;
      4'b0110 :
        NextTxReg6 = PWDATAIn;
      4'b0111 :
        NextTxReg7 = PWDATAIn;
      4'b1000 :
        NextTxReg8 = PWDATAIn;
      4'b1001 :
        NextTxReg9 = PWDATAIn;
      4'b1010 :
        NextTxReg10 = PWDATAIn;
      4'b1011 :
        NextTxReg11 = PWDATAIn;
      4'b1100 :
        NextTxReg12 = PWDATAIn;
      4'b1101 :
        NextTxReg13 = PWDATAIn;
      4'b1110 :
        NextTxReg14 = PWDATAIn;
      4'b1111 :
        NextTxReg15 = PWDATAIn;
    endcase
  end
end  // p_WrComb;

// -----------------------------------------------------------------------------
// Read Mux. The contents of the location pointed to by the current value of
// the read pointer RdPtr, is driven onto the read databus, TxFRdData.
// -----------------------------------------------------------------------------
assign TxFRdData = (RdPtr == 4'b0000) ? TxReg0   : (  
                   (RdPtr == 4'b0001) ? TxReg1   : (
                   (RdPtr == 4'b0010) ? TxReg2   : (
                   (RdPtr == 4'b0011) ? TxReg3   : (
                   (RdPtr == 4'b0100) ? TxReg4   : (
                   (RdPtr == 4'b0101) ? TxReg5   : (
                   (RdPtr == 4'b0110) ? TxReg6   : (
                   (RdPtr == 4'b0111) ? TxReg7   : (
                   (RdPtr == 4'b1000) ? TxReg8   : (
                   (RdPtr == 4'b1001) ? TxReg9   : (
                   (RdPtr == 4'b1010) ? TxReg10  : (
                   (RdPtr == 4'b1011) ? TxReg11  : (
                   (RdPtr == 4'b1100) ? TxReg12  : (
                   (RdPtr == 4'b1101) ? TxReg13  : ( 
                   (RdPtr == 4'b1110) ? TxReg14  : (
                   (RdPtr == 4'b1111) ? TxReg15  : (
                   (16'h0000)))))))))))))))));

endmodule

// ================================= End =====================================--

