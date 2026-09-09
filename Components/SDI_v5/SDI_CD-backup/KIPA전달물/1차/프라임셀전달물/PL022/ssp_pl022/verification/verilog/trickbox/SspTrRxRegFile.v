// --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
// ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name              : SspTrRxRegFile.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
// -----------------------------------------------------------------------------
// Purpose      : Receive FIFO Register File
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SspTrRxRegFile
                     ( 
                      PCLK,            
                      PRESETn,         
                      RegFileWrEn,  
                      WrPtr,
                      RdPtr,
                      RxFWrData,
                      RxFRdData 
                     );

input        PCLK;          // APB bus clock
input        PRESETn;       // APB bus reset 
input        RegFileWrEn;   // Write enable
input  [3:0] WrPtr;         // Write pointer
input  [3:0] RdPtr;         // Read pointer
input [15:0] RxFWrData;     // Write data
input [15:0] RxFRdData;     // Read Data

// -----------------------------------------------------------------------------
//
//                               SspTrRxRegFile
//                               ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This module contains the Register file for the Receive FIFO. When the 
// Write enable signal RegFileWrEn is asserted, data on the write data bus 
// PWDATAIn is written into the location pointed to by the current value of the
// Write pointer, WrPtr[3:0]. On the read interface, the contents of the 
// location pointed to by the current value of the read pointer RdPtr, is 
// driven onto the read databus, TxFRdData.
// 
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
reg [15:0] RxReg0;
// Receive FIFO register0 

reg [15:0] NextRxReg0;
// D-input of RxReg0

reg [15:0] RxReg1;
// Receive FIFO register1 

reg [15:0] NextRxReg1;
// D-input of RxReg1

reg [15:0] RxReg2;
// Receive FIFO register2 

reg [15:0] NextRxReg2;
// D-input of RxReg2

reg [15:0] RxReg3;
// Receive FIFO register3 

reg [15:0] NextRxReg3;
// D-input of RxReg3

reg [15:0] RxReg4;
// Receive FIFO register4 

reg [15:0] NextRxReg4;
// D-input of RxReg4

reg [15:0] RxReg5;
// Receive FIFO register5 

reg [15:0] NextRxReg5;
// D-input of RxReg5

reg [15:0] RxReg6;
// Receive FIFO register6 

reg [15:0] NextRxReg6;
// D-input of RxReg6

reg [15:0] RxReg7;
// Receive FIFO register7 

reg [15:0] NextRxReg7;
// D-input of RxReg7

reg [15:0] RxReg8;
// Receive FIFO register8 

reg [15:0] NextRxReg8;
// D-input of RxReg8

reg [15:0] RxReg9;
// Receive FIFO register9 

reg [15:0] NextRxReg9;
// D-input of RxReg9

reg [15:0] RxReg10;
// Receive FIFO register10 

reg [15:0] NextRxReg10;
// D-input of RxReg10

reg [15:0] RxReg11;
// Receive FIFO register11 

reg [15:0] NextRxReg11;
// D-input of RxReg11

reg [15:0] RxReg12;
// Receive FIFO register12 

reg [15:0] NextRxReg12;
// D-input of RxReg12

reg [15:0] RxReg13;
// Receive FIFO register13 

reg [15:0] NextRxReg13;
// D-input of RxReg13

reg [15:0] RxReg14;
// Receive FIFO register14 

reg [15:0] NextRxReg14;
// D-input of RxReg14

reg [15:0] RxReg15;
// Receive FIFO register15 

reg [15:0] NextRxReg15;
// D-input of RxReg15

// -----------------------------------------------------------------------------
// 
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Register array. 
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_Seq
  if (PRESETn == 1'b0) 
    begin
    RxReg0  <= 16'h0000;
    RxReg1  <= 16'h0000;
    RxReg2  <= 16'h0000;
    RxReg3  <= 16'h0000;
    RxReg4  <= 16'h0000;
    RxReg5  <= 16'h0000;
    RxReg6  <= 16'h0000;
    RxReg7  <= 16'h0000;
    RxReg8  <= 16'h0000;
    RxReg9  <= 16'h0000;
    RxReg10 <= 16'h0000;
    RxReg11 <= 16'h0000;
    RxReg12 <= 16'h0000;
    RxReg13 <= 16'h0000;
    RxReg14 <= 16'h0000;
    RxReg15 <= 16'h0000;
    end 
  else 
    begin
    RxReg0  <= NextRxReg0;
    RxReg1  <= NextRxReg1;
    RxReg2  <= NextRxReg2;
    RxReg3  <= NextRxReg3;
    RxReg4  <= NextRxReg4;
    RxReg5  <= NextRxReg5;
    RxReg6  <= NextRxReg6;
    RxReg7  <= NextRxReg7; 
    RxReg8  <= NextRxReg8;
    RxReg9  <= NextRxReg9;
    RxReg10 <= NextRxReg10;
    RxReg11 <= NextRxReg11;
    RxReg12 <= NextRxReg12;
    RxReg13 <= NextRxReg13;
    RxReg14 <= NextRxReg14;
    RxReg15 <= NextRxReg15; 
    end
end   // p_Seq;

// -----------------------------------------------------------------------------
// Write logic. When the Write enable signal, RegFileWrEn, is asserted, data on
// the write data bus PWDATAIn is written into the location pointed to by the 
// current value of the Write pointer, WrPtr[2:0].
// -----------------------------------------------------------------------------
 always @(RxReg0 or RxReg1 or RxReg2 or RxReg3 or RxReg4 or RxReg5 or RxReg6 or 
          RxReg7 or RxReg8 or RxReg9 or RxReg10 or RxReg11 or RxReg12 or 
          RxReg13 or RxReg14 or RxReg15 or WrPtr or RegFileWrEn or RxFWrData)
begin : p_WrComb
  NextRxReg0  = RxReg0;
  NextRxReg1  = RxReg1;
  NextRxReg2  = RxReg2;
  NextRxReg3  = RxReg3;
  NextRxReg4  = RxReg4;
  NextRxReg5  = RxReg5;
  NextRxReg6  = RxReg6;
  NextRxReg7  = RxReg7;
  NextRxReg8  = RxReg8;
  NextRxReg9  = RxReg9;
  NextRxReg10 = RxReg10;
  NextRxReg11 = RxReg11;
  NextRxReg12 = RxReg12;
  NextRxReg13 = RxReg13;
  NextRxReg14 = RxReg14;
  NextRxReg15 = RxReg15;
  if (RegFileWrEn == 1'b1) 
    begin
      case (WrPtr)
      4'b0000: 
        NextRxReg0 = RxFWrData;
      4'b0001:
        NextRxReg1 = RxFWrData;
      4'b0010:
        NextRxReg2 = RxFWrData;
      4'b0011:
        NextRxReg3 = RxFWrData;
      4'b0100:
        NextRxReg4 = RxFWrData;
      4'b0101: 
        NextRxReg5 = RxFWrData;
      4'b0110: 
        NextRxReg6 = RxFWrData;
      4'b0111: 
        NextRxReg7 = RxFWrData;
      4'b1000: 
        NextRxReg8 = RxFWrData;
      4'b1001: 
        NextRxReg9 = RxFWrData;
      4'b1010: 
        NextRxReg10 = RxFWrData;
      4'b1011: 
        NextRxReg11 = RxFWrData;
      4'b1100: 
        NextRxReg12 = RxFWrData;
      4'b1101: 
        NextRxReg13 = RxFWrData;
      4'b1110: 
        NextRxReg14 = RxFWrData;
      4'b1111: 
        NextRxReg15 = RxFWrData;
    endcase
  end
end   // p_WrComb;

// -----------------------------------------------------------------------------
// Read Mux. The contents of the location pointed to by the current value of 
// the read pointer RdPtr, is driven onto the read databus, RxFRdData.
// -----------------------------------------------------------------------------
assign RxFRdData = (RdPtr == 4'b0000) ? RxReg0    :(   
                   (RdPtr == 4'b0001) ? RxReg1    :(  
                   (RdPtr == 4'b0010) ? RxReg2    :(   
                   (RdPtr == 4'b0011) ? RxReg3    :(
                   (RdPtr == 4'b0100) ? RxReg4    :(
                   (RdPtr == 4'b0101) ? RxReg5    :(
                   (RdPtr == 4'b0110) ? RxReg6    :(
                   (RdPtr == 4'b0111) ? RxReg7    :(
                   (RdPtr == 4'b1000) ? RxReg8    :(
                   (RdPtr == 4'b1001) ? RxReg9    :(
                   (RdPtr == 4'b1010) ? RxReg10   :(
                   (RdPtr == 4'b1011) ? RxReg11   :(
                   (RdPtr == 4'b1100) ? RxReg12   :(
                   (RdPtr == 4'b1101) ? RxReg13   :(
                   (RdPtr == 4'b1110) ? RxReg14   :(
                   (RdPtr == 4'b1111) ? RxReg15   :(
                   (16'h0000)))))))))))))))));

endmodule

// --=========================== End =========================================--
