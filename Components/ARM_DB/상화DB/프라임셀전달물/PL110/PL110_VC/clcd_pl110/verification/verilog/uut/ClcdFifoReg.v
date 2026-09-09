// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : ClcdFifoReg.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//  ----------------------------------------------------------------------------
//  Purpose                : An array of flip-flops to form FIFO elements
// 
//  NOTE                   : This module is designed for the FIFO_DEPTH of "16".
//                           this module needs to be modified appropriately if 
//                           the FIFO-DEPTH value is changed and the FIFO_TYPE
//                           is REG type.
//       
// --=========================================================================--

`timescale 1ns/1ps
`include "ClcdConfig.v"
// ----------------------------------------------------------------------------

module ClcdFifoReg (
// Inputs
                    HCLK,
                    WrAddr,
                    WrEnable, 
                    WrData, 
                    RdAddr,

// Outputs
                    RdData
                   );

input                 HCLK;    // Clock input
input                 WrEnable;// Write request
input  [`PTR_SIZE-1:0]WrAddr;  // Write address
input  [31:0]         WrData;  // Data to be written into the register elements
input  [`PTR_SIZE-1:0]RdAddr;  // Address from which data is driven out 

output [31:0]         RdData;  // Read data out

// -----------------------------------------------------------------------------
// Overview
// ========
// This module contains an array of registers used as FIFO elements.
// Data will be written in to the register whenever WrEnable signal is sampled
// HIGH on any rising edge of HCLK;
// The data corresponding to the current Read address(RdAddr) will be driven to
// the output port as RdData.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire                   HCLK;
// Clock input                                          (Module input)

wire                   WrEnable; 
// Data is written into the selected register element on the rising edge of FCLK
// when this signal is high                             (Module input)

wire  [`PTR_SIZE-1:0]   WrAddr;
// Address to which WrData is to be written when 
// WrEnable is asserted.                                (Module input)

wire  [31:0]           WrData; 
// Data to be written into the register elements        (Module input)

wire  [`PTR_SIZE-1:0]   RdAddr; 
// Address from which data is driven out to RdData.     (Module input)

wire [31:0]            RdData;                            
// Read data corresponding to the RdAddr                (Module input)
 
// -----------------------------------------------------------------------------
// Register  declarations
// -----------------------------------------------------------------------------
reg [31:0] FifoReg0; 
// Fifo register0

reg [31:0] FifoReg1; 
// Fifo register1

reg [31:0] FifoReg2; 
// Fifo register2

reg [31:0] FifoReg3; 
// Fifo register3

reg [31:0] FifoReg4; 
// Fifo register4

reg [31:0] FifoReg5; 
// Fifo register5

reg [31:0] FifoReg6; 
// Fifo register6

reg [31:0] FifoReg7; 
// Fifo register7

reg [31:0] FifoReg8; 
// Fifo register8

reg [31:0] FifoReg9; 
// Fifo register9

reg [31:0] FifoReg10; 
// Fifo register10

reg [31:0] FifoReg11; 
// Fifo register11

reg [31:0] FifoReg12; 
// Fifo register12

reg [31:0] FifoReg13; 
// Fifo register13

reg [31:0] FifoReg14; 
// Fifo register14

reg [31:0] FifoReg15; 
// Fifo register15

reg [31:0] NextFifoReg0; 
// D-input for FifoReg0

reg [31:0] NextFifoReg1; 
// D-input for FifoReg1

reg [31:0] NextFifoReg2; 
// D-input for FifoReg2

reg [31:0] NextFifoReg3; 
// D-input for FifoReg3

reg [31:0] NextFifoReg4; 
// D-input for FifoReg4

reg [31:0] NextFifoReg5; 
// D-input for FifoReg5

reg [31:0] NextFifoReg6; 
// D-input for FifoReg6

reg [31:0] NextFifoReg7; 
// D-input for FifoReg7

reg [31:0] NextFifoReg8; 
// D-input for FifoReg8

reg [31:0] NextFifoReg9; 
// D-input for FifoReg9

reg [31:0] NextFifoReg10; 
// D-input for FifoReg10

reg [31:0] NextFifoReg11; 
// D-input for FifoReg11

reg [31:0] NextFifoReg12; 
// D-input for FifoReg12

reg [31:0] NextFifoReg13; 
// D-input for FifoReg13

reg [31:0] NextFifoReg14; 
// D-input for FifoReg14

reg [31:0] NextFifoReg15; 
// D-input for FifoReg15


// -----------------------------------------------------------------------------
// Write logic. When the Write enable signal "WrEnable" is asserted, data on
// the write data bus WrData is written into the location pointed to by the
// current value of the Write pointer, WrAddr[3:0].
// -----------------------------------------------------------------------------
always @(WrEnable or WrAddr or WrData or FifoReg0 or FifoReg1 or FifoReg2 or
         FifoReg3 or FifoReg4 or FifoReg5 or FifoReg6 or FifoReg7 or FifoReg8 or
         FifoReg9 or FifoReg10 or FifoReg11 or FifoReg12 or FifoReg13 or
         FifoReg14 or FifoReg15 )
begin : p_FRegWrComb
  NextFifoReg0  = FifoReg0;
  NextFifoReg1  = FifoReg1;
  NextFifoReg2  = FifoReg2;
  NextFifoReg3  = FifoReg3;
  NextFifoReg4  = FifoReg4;
  NextFifoReg5  = FifoReg5;
  NextFifoReg6  = FifoReg6;
  NextFifoReg7  = FifoReg7;
  NextFifoReg8  = FifoReg8;
  NextFifoReg9  = FifoReg9;
  NextFifoReg10 = FifoReg10;
  NextFifoReg11 = FifoReg11;
  NextFifoReg12 = FifoReg12;
  NextFifoReg13 = FifoReg13;
  NextFifoReg14 = FifoReg14;
  NextFifoReg15 = FifoReg15;

  if (WrEnable == 1'b1)
    case (WrAddr)
      4'b0000 : NextFifoReg0  = WrData;
      4'b0001 : NextFifoReg1  = WrData;
      4'b0010 : NextFifoReg2  = WrData;
      4'b0011 : NextFifoReg3  = WrData;
      4'b0100 : NextFifoReg4  = WrData;
      4'b0101 : NextFifoReg5  = WrData;
      4'b0110 : NextFifoReg6  = WrData;
      4'b0111 : NextFifoReg7  = WrData;
      4'b1000 : NextFifoReg8  = WrData;
      4'b1001 : NextFifoReg9  = WrData;
      4'b1010 : NextFifoReg10 = WrData;
      4'b1011 : NextFifoReg11 = WrData;
      4'b1100 : NextFifoReg12 = WrData;
      4'b1101 : NextFifoReg13 = WrData;
      4'b1110 : NextFifoReg14 = WrData;
      4'b1111 : NextFifoReg15 = WrData;
      default : ;
    endcase
end // p_FRegWrComb

// -----------------------------------------------------------------------------
// Sequential logic for the Fifo register
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_FRegWrSeq
  FifoReg0  <= NextFifoReg0;
  FifoReg1  <= NextFifoReg1;
  FifoReg2  <= NextFifoReg2;
  FifoReg3  <= NextFifoReg3;
  FifoReg4  <= NextFifoReg4;
  FifoReg5  <= NextFifoReg5;
  FifoReg6  <= NextFifoReg6;
  FifoReg7  <= NextFifoReg7;
  FifoReg8  <= NextFifoReg8;
  FifoReg9  <= NextFifoReg9;
  FifoReg10 <= NextFifoReg10;
  FifoReg11 <= NextFifoReg11;
  FifoReg12 <= NextFifoReg12;
  FifoReg13 <= NextFifoReg13;
  FifoReg14 <= NextFifoReg14;
  FifoReg15 <= NextFifoReg15;
end // p_FRegWrSeq

// -----------------------------------------------------------------------------
// Read path mux
// -----------------------------------------------------------------------------
assign RdData = (RdAddr[3:0] == 4'b0000) ? FifoReg0
              : (RdAddr[3:0] == 4'b0001) ? FifoReg1 
              : (RdAddr[3:0] == 4'b0010) ? FifoReg2 
              : (RdAddr[3:0] == 4'b0011) ? FifoReg3 
              : (RdAddr[3:0] == 4'b0100) ? FifoReg4 
              : (RdAddr[3:0] == 4'b0101) ? FifoReg5 
              : (RdAddr[3:0] == 4'b0110) ? FifoReg6 
              : (RdAddr[3:0] == 4'b0111) ? FifoReg7 
              : (RdAddr[3:0] == 4'b1000) ? FifoReg8 
              : (RdAddr[3:0] == 4'b1001) ? FifoReg9 
              : (RdAddr[3:0] == 4'b1010) ? FifoReg10
              : (RdAddr[3:0] == 4'b1011) ? FifoReg11
              : (RdAddr[3:0] == 4'b1100) ? FifoReg12
              : (RdAddr[3:0] == 4'b1101) ? FifoReg13
              : (RdAddr[3:0] == 4'b1110) ? FifoReg14
              : (RdAddr[3:0] == 4'b1111) ? FifoReg15
              : 32'b0;


endmodule

// --================================== End ==================================--
