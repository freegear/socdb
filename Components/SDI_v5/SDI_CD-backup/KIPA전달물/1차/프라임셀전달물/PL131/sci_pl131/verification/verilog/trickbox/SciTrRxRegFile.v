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
//  File Name              : SciTrRxRegFile.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Purpose      : Receive FIFO Register File
//------------------------------------------------------------------------------
 `timescale 1ns/1ps 

//------------------------------------------------------------------------------

module SciTrRxRegFile (
                       PCLK,
                       PRESETn,
                       RegFileWrEn,
                       WrPtr,
                       RdPtr,
                       RxFWrData,
                       RxFRdData
                      );
input         PCLK;         // APB bus clock
input         PRESETn;      // Reset (from PRESETn)
input         RegFileWrEn;  // Write enable
input  [3:0]  WrPtr;        // Write pointer
input  [3:0]  RdPtr;        // Read pointer
input  [8:0]  RxFWrData;    // Write data
output [8:0]  RxFRdData;    // Read Data
//------------------------------------------------------------------------------
//
//                               SciRxRegFile
//                               ============
//
//------------------------------------------------------------------------------
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


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
reg [8:0] RxReg0;
// Receive FIFO register 0
 
reg [8:0] NextRxReg0;
// D-input of RxReg 0
 
reg [8:0] RxReg1;
// Receive FIFO register 1
 
reg [8:0] NextRxReg1;
// D-input of RxReg 1
 
reg [8:0] RxReg2;
// Receive FIFO register 2
 
reg [8:0] NextRxReg2;
// D-input of RxReg 2
 
reg [8:0] RxReg3;
// Receive FIFO register 3
 
reg [8:0] NextRxReg3;
// D-input of RxRego 3
 
reg [8:0] RxReg4;
// Receive FIFO register 4
 
reg [8:0] NextRxReg4;
// D-input of RxReg 4
 
reg [8:0] RxReg5;
// Receive FIFO register 5
 
reg [8:0] NextRxReg5;
// D-input of RxReg 5
 
reg [8:0] RxReg6;
// Receive FIFO register 6
 
reg [8:0] NextRxReg6;
// D-input of RxReg 6
 
reg [8:0] RxReg7;
// Receive FIFO register 7
 
reg [8:0] NextRxReg7;
// D-input of RxReg 7
 
reg [8:0] RxReg8;
// Receive FIFO register 8 
 
reg [8:0] NextRxReg8;
// D-input of RxReg 8
 
reg [8:0] RxReg9;
// Receive FIFO register 9 
 
reg [8:0] NextRxReg9;
// D-input of RxReg 9
 
reg [8:0] RxReg10;
// Receive FIFO register 10
 
reg [8:0] NextRxReg10;
// D-input of RxReg 10
 
reg [8:0] RxReg11;
// Receive FIFO register 11 
 
reg [8:0] NextRxReg11;
// D-input of RxReg 11
 
reg [8:0] RxReg12;
// Receive FIFO register 12 
 
reg [8:0] NextRxReg12;
// D-input of RxReg 12
 
reg [8:0] RxReg13;
// Receive FIFO register 13 
 
reg[8:0]  NextRxReg13;
// D-input of RxReg 13
 
reg [8:0] RxReg14;
// Receive FIFO register 14 
 
reg [8:0] NextRxReg14;
// D-input of RxReg 14
 
reg [8:0] RxReg15;
// Receive FIFO register 15 
 
reg [8:0] NextRxReg15;
// D-input of RxReg 15

//------------------------------------------------------------------------------
// 
// Main body of Code
// =================
//
//------------------------------------------------------------------------------

// Register array. 
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_Seq
  if (PRESETn  == 1'b0)
  begin 
    RxReg0  <= 9'b000000000;
    RxReg1  <= 9'b000000000;
    RxReg2  <= 9'b000000000;
    RxReg3  <= 9'b000000000;
    RxReg4  <= 9'b000000000;
    RxReg5  <= 9'b000000000;
    RxReg6  <= 9'b000000000;
    RxReg7  <= 9'b000000000;
    RxReg8  <= 9'b000000000;
    RxReg9  <= 9'b000000000;
    RxReg10 <= 9'b000000000;
    RxReg11 <= 9'b000000000;
    RxReg12 <= 9'b000000000;
    RxReg13 <= 9'b000000000;
    RxReg14 <= 9'b000000000;
    RxReg15 <= 9'b000000000;
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
end // p_Seq;

//------------------------------------------------------------------------------
// Write logic. When the Write enable signal, RegFileWrEn, is asserted, data on
// the write data bus PWDATAIn is written into the location pointed to by the 
// current value of the Write pointer, WrPtr[3:0].
//------------------------------------------------------------------------------
always @(RxReg0 or RxReg1 or RxReg2 or RxReg3 or RxReg4 or RxReg5 or 
         RxReg6 or RxReg7 or RxReg8 or RxReg9 or RxReg10 or RxReg11 
         or RxReg12 or RxReg13 or RxReg14 or RxReg15 or  WrPtr or  
         RegFileWrEn or  RxFWrData)
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
      4'b0000 :
        NextRxReg0  = RxFWrData;
      4'b0001 :
        NextRxReg1  = RxFWrData;
      4'b0010 :
        NextRxReg2  = RxFWrData;
      4'b0011 :
        NextRxReg3  = RxFWrData;
      4'b0100 :
        NextRxReg4  = RxFWrData;
      4'b0101 :
        NextRxReg5  = RxFWrData;
      4'b0110 :
        NextRxReg6  = RxFWrData;
      4'b0111 :
        NextRxReg7  = RxFWrData;
      4'b1000 :
        NextRxReg8  = RxFWrData;
      4'b1001 :
        NextRxReg9  = RxFWrData;
      4'b1010 :
        NextRxReg10 = RxFWrData;
      4'b1011 :
        NextRxReg11 = RxFWrData;
      4'b1100 :
        NextRxReg12 = RxFWrData;
      4'b1101 :
        NextRxReg13 = RxFWrData;
      4'b1110 :
        NextRxReg14 = RxFWrData;
      4'b1111 :
        NextRxReg15 = RxFWrData;
    endcase
  end
end // p_WrComb;

//------------------------------------------------------------------------------
// Read Mux. The contents of the location pointed to by the current value of 
// the read pointer RdPtr, is driven onto the read databus, RxFRdData.
//------------------------------------------------------------------------------
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
                   (11'b00000000000)))))))))))))))));
 
endmodule
//============================ End ===================================--



