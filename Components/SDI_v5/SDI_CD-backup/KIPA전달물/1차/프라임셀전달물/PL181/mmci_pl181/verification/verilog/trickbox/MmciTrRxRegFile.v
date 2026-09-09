// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : MmciTrRxRegFile.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Receive FIFO Register File
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MmciTrRxRegFile (
// Inputs
                       PCLK,
                       PRESETn,
                       RegFileWrEn,
                       WrPtr,
                       RdPtr,
                       RxFWrData,
// Outputs
                       RxFRdData
                       );

// Inputs
input         PCLK;        // APB bus clock
input         PRESETn;     // APB Bus Reset
input         RegFileWrEn; // Write enable
input   [4:0] WrPtr;       // Write pointer
input   [4:0] RdPtr;       // Read pointer
input  [32:0] RxFWrData;   // Write data, contains CrcErrStat

// Outputs
output [32:0] RxFRdData;   // Read Data

// Inputs
wire        PCLK;          // APB bus clock
wire        PRESETn;       // APB Bus Reset
wire        RegFileWrEn;   // Write enable
wire  [4:0] WrPtr;         // Write pointer
wire  [4:0] RdPtr;         // Read pointer
wire [32:0] RxFWrData;     // Write data, contains CrcErrStat

// Outputs
wire [32:0] RxFRdData;     // Read Data

// -----------------------------------------------------------------------------
//
//                               MmciTrRxRegFile
//                               ===============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module contains the Register file for the Receive FIFO. When the
// Write enable signal RegFileWrEn is asserted, data on the write data
// bus is written into the location pointed to by the current value of
// the Write pointer, WrPtr[3:0]. On the read interface, the contents
// of the location pointed to by the current value of the read pointer
// RdPtr, is driven onto the read databus, RxFRdData.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
reg [32:0] RxReg1;
// Receive FIFO register1

reg [32:0] RxReg2;
// Receive FIFO register2

reg [32:0] RxReg3;
// Receive FIFO register3

reg [32:0] RxReg4;
// Receive FIFO register4

reg [32:0] RxReg5;
// Receive FIFO register5

reg [32:0] RxReg6;
// Receive FIFO register6

reg [32:0] RxReg7;
// Receive FIFO register7

reg [32:0] RxReg8;
// Receive FIFO register8

reg [32:0] RxReg9;
// Receive FIFO register9

reg [32:0] RxReg10;
// Receive FIFO register10

reg [32:0] RxReg11;
// Receive FIFO register11

reg [32:0] RxReg12;
// Receive FIFO register12

reg [32:0] RxReg13;
// Receive FIFO register13

reg [32:0] RxReg14;
// Receive FIFO register14

reg [32:0] RxReg15;
// Receive FIFO register15

reg [32:0] RxReg16;
// Receive FIFO register16

reg [32:0] RxReg17;
// Receive FIFO register17

reg [32:0] RxReg18;
// Receive FIFO register18

reg [32:0] RxReg19;
// Receive FIFO register19

reg [32:0] RxReg20;
// Receive FIFO register20

reg [32:0] RxReg21;
// Receive FIFO register21

reg [32:0] RxReg22;
// Receive FIFO register22

reg [32:0] RxReg23;
// Receive FIFO register23

reg [32:0] RxReg24;
// Receive FIFO register24

reg [32:0] RxReg25;
// Receive FIFO register25

reg [32:0] RxReg26;
// Receive FIFO register26

reg [32:0] RxReg27;
// Receive FIFO register27

reg [32:0] RxReg28;
// Receive FIFO register28

reg [32:0] RxReg29;
// Receive FIFO register29

reg [32:0] RxReg30;
// Receive FIFO register30

reg [32:0] RxReg31;
// Receive FIFO register31

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [32:0] RxReg0;
// Receive FIFO register0

reg  [32:0] NextRxReg0;
// D-input of RxReg0

reg  [32:0] NextRxReg1;
// D-input of RxReg1

reg  [32:0] NextRxReg2;
// D-input of RxReg2

reg  [32:0] NextRxReg3;
// D-input of RxReg3

reg  [32:0] NextRxReg4;
// D-input of RxReg4

reg  [32:0] NextRxReg5;
// D-input of RxReg5

reg  [32:0] NextRxReg6;
// D-input of RxReg6

reg  [32:0] NextRxReg7;
// D-input of RxReg7

reg  [32:0] NextRxReg8;
// D-input of RxReg8

reg  [32:0] NextRxReg9;
// D-input of RxReg9

reg  [32:0] NextRxReg10;
// D-input of RxReg10

reg  [32:0] NextRxReg11;
// D-input of RxReg11

reg  [32:0] NextRxReg12;
// D-input of RxReg12

reg  [32:0] NextRxReg13;
// D-input of RxReg13

reg  [32:0] NextRxReg14;
// D-input of RxReg14

reg  [32:0] NextRxReg15;
// D-input of RxReg15

reg  [32:0] NextRxReg16;
// D-input of RxReg16

reg  [32:0] NextRxReg17;
// D-input of RxReg17

reg  [32:0] NextRxReg18;
// D-input of RxReg18

reg  [32:0] NextRxReg19;
// D-input of RxReg19

reg  [32:0] NextRxReg20;
// D-input of RxReg20

reg  [32:0] NextRxReg21;
// D-input of RxReg21

reg  [32:0] NextRxReg22;
// D-input of RxReg22

reg  [32:0] NextRxReg23;
// D-input of RxReg23

reg  [32:0] NextRxReg24;
// D-input of RxReg24

reg  [32:0] NextRxReg25;
// D-input of RxReg25

reg  [32:0] NextRxReg26;
// D-input of RxReg26

reg  [32:0] NextRxReg27;
// D-input of RxReg27

reg  [32:0] NextRxReg28;
// D-input of RxReg28

reg  [32:0] NextRxReg29;
// D-input of RxReg29

reg  [32:0] NextRxReg30;
// D-input of RxReg30

reg  [32:0] NextRxReg31;
// D-input of RxReg31

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

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
  if (PRESETn ==  1'b0)
  begin
     RxReg0           <= 33'h000000000;
     RxReg1           <= 33'h000000000;
     RxReg2           <= 33'h000000000;
     RxReg3           <= 33'h000000000;
     RxReg4           <= 33'h000000000;
     RxReg5           <= 33'h000000000;
     RxReg6           <= 33'h000000000;
     RxReg7           <= 33'h000000000;
     RxReg8           <= 33'h000000000;
     RxReg9           <= 33'h000000000;
     RxReg10          <= 33'h000000000;
     RxReg11          <= 33'h000000000;
     RxReg12          <= 33'h000000000;
     RxReg13          <= 33'h000000000;
     RxReg14          <= 33'h000000000;
     RxReg15          <= 33'h000000000;
     RxReg16          <= 33'h000000000;
     RxReg17          <= 33'h000000000;
     RxReg18          <= 33'h000000000;
     RxReg19          <= 33'h000000000;
     RxReg20          <= 33'h000000000;
     RxReg21          <= 33'h000000000;
     RxReg22          <= 33'h000000000;
     RxReg23          <= 33'h000000000;
     RxReg24          <= 33'h000000000;
     RxReg25          <= 33'h000000000;
     RxReg26          <= 33'h000000000;
     RxReg27          <= 33'h000000000;
     RxReg28          <= 33'h000000000;
     RxReg29          <= 33'h000000000;
     RxReg30          <= 33'h000000000;
     RxReg31          <= 33'h000000000;
    end
    else
    begin
     RxReg0           <= NextRxReg0;
     RxReg1           <= NextRxReg1;
     RxReg2           <= NextRxReg2;
     RxReg3           <= NextRxReg3;
     RxReg4           <= NextRxReg4;
     RxReg5           <= NextRxReg5;
     RxReg6           <= NextRxReg6;
     RxReg7           <= NextRxReg7;
     RxReg8           <= NextRxReg8;
     RxReg9           <= NextRxReg9;
     RxReg10          <= NextRxReg10;
     RxReg11          <= NextRxReg11;
     RxReg12          <= NextRxReg12;
     RxReg13          <= NextRxReg13;
     RxReg14          <= NextRxReg14;
     RxReg15          <= NextRxReg15;
     RxReg16          <= NextRxReg16;
     RxReg17          <= NextRxReg17;
     RxReg18          <= NextRxReg18;
     RxReg19          <= NextRxReg19;
     RxReg20          <= NextRxReg20;
     RxReg21          <= NextRxReg21;
     RxReg22          <= NextRxReg22;
     RxReg23          <= NextRxReg23;
     RxReg24          <= NextRxReg24;
     RxReg25          <= NextRxReg25;
     RxReg26          <= NextRxReg26;
     RxReg27          <= NextRxReg27;
     RxReg28          <= NextRxReg28;
     RxReg29          <= NextRxReg29;
     RxReg30          <= NextRxReg30;
     RxReg31          <= NextRxReg31;
  end
end // p_Seq

// -----------------------------------------------------------------------------
// Write logic. When the Write enable signal, RegFileWrEn, is asserted,
// data on the write data bus PWDATAIn is written into the location
// pointed to by the current value of the Write pointer, WrPtr[2:0].
// -----------------------------------------------------------------------------
always @(RxReg0 or RxReg1 or RxReg2 or RxReg3 or RxReg4 or RxReg5 or
         RxReg6 or RxReg7 or RxReg8 or RxReg9 or RxReg10 or RxReg11 or
         RxReg12 or RxReg13 or RxReg14 or RxReg15 or RxReg16 or
         RxReg17 or RxReg18 or RxReg19 or RxReg20 or RxReg21 or
         RxReg22 or RxReg23 or RxReg24 or RxReg25 or RxReg26 or
         RxReg27 or RxReg28 or RxReg29 or RxReg30 or RxReg31 or
         WrPtr or RegFileWrEn or RxFWrData)
begin : p_WrComb
   NextRxReg0       = RxReg0;
   NextRxReg1       = RxReg1;
   NextRxReg2       = RxReg2;
   NextRxReg3       = RxReg3;
   NextRxReg4       = RxReg4;
   NextRxReg5       = RxReg5;
   NextRxReg6       = RxReg6;
   NextRxReg7       = RxReg7;
   NextRxReg8       = RxReg8;
   NextRxReg9       = RxReg9;
   NextRxReg10      = RxReg10;
   NextRxReg11      = RxReg11;
   NextRxReg12      = RxReg12;
   NextRxReg13      = RxReg13;
   NextRxReg14      = RxReg14;
   NextRxReg15      = RxReg15;
   NextRxReg16      = RxReg16;
   NextRxReg17      = RxReg17;
   NextRxReg18      = RxReg18;
   NextRxReg19      = RxReg19;
   NextRxReg20      = RxReg20;
   NextRxReg21      = RxReg21;
   NextRxReg22      = RxReg22;
   NextRxReg23      = RxReg23;
   NextRxReg24      = RxReg24;
   NextRxReg25      = RxReg25;
   NextRxReg26      = RxReg26;
   NextRxReg27      = RxReg27;
   NextRxReg28      = RxReg28;
   NextRxReg29      = RxReg29;
   NextRxReg30      = RxReg30;
   NextRxReg31      = RxReg31;
  if (RegFileWrEn ==  1'b1)
  begin
    case (WrPtr)
      5'b00000 :
         NextRxReg0       = RxFWrData;
      5'b00001 :
         NextRxReg1       = RxFWrData;
      5'b00010 :
         NextRxReg2       = RxFWrData;
      5'b00011 :
         NextRxReg3       = RxFWrData;
      5'b00100 :
         NextRxReg4       = RxFWrData;
      5'b00101 :
         NextRxReg5       = RxFWrData;
      5'b00110 :
         NextRxReg6       = RxFWrData;
      5'b00111 :
         NextRxReg7       = RxFWrData;
      5'b01000 :
         NextRxReg8       = RxFWrData;
      5'b01001 :
         NextRxReg9       = RxFWrData;
      5'b01010 :
         NextRxReg10      = RxFWrData;
      5'b01011 :
         NextRxReg11      = RxFWrData;
      5'b01100 :
         NextRxReg12      = RxFWrData;
      5'b01101 :
         NextRxReg13      = RxFWrData;
      5'b01110 :
         NextRxReg14      = RxFWrData;
      5'b01111 :
         NextRxReg15      = RxFWrData;
      5'b10000 :
         NextRxReg16      = RxFWrData;
      5'b10001 :
         NextRxReg17      = RxFWrData;
      5'b10010 :
         NextRxReg18      = RxFWrData;
      5'b10011 :
         NextRxReg19      = RxFWrData;
      5'b10100 :
         NextRxReg20      = RxFWrData;
      5'b10101 :
         NextRxReg21      = RxFWrData;
      5'b10110 :
         NextRxReg22      = RxFWrData;
      5'b10111 :
         NextRxReg23      = RxFWrData;
      5'b11000 :
         NextRxReg24      = RxFWrData;
      5'b11001 :
         NextRxReg25      = RxFWrData;
      5'b11010 :
         NextRxReg26      = RxFWrData;
      5'b11011 :
         NextRxReg27      = RxFWrData;
      5'b11100 :
         NextRxReg28      = RxFWrData;
      5'b11101 :
         NextRxReg29      = RxFWrData;
      5'b11110 :
         NextRxReg30      = RxFWrData;
      5'b11111 :
         NextRxReg31      = RxFWrData;
      default :
         NextRxReg31      = RxFWrData;
    endcase
  end
end // p_WrComb

// -----------------------------------------------------------------------------
// Read Mux. The contents of the location pointed to by the current
// value of the read pointer RdPtr, is driven onto the read databus,
// RxFRdData.
// -----------------------------------------------------------------------------
assign RxFRdData        = (RdPtr == 5'b00000) ? RxReg0               : (
                           (RdPtr == 5'b00001) ? RxReg1              : (
                           (RdPtr == 5'b00010) ? RxReg2              : (
                           (RdPtr == 5'b00011) ? RxReg3              : (
                           (RdPtr == 5'b00100) ? RxReg4              : (
                           (RdPtr == 5'b00101) ? RxReg5              : (
                           (RdPtr == 5'b00110) ? RxReg6              : (
                           (RdPtr == 5'b00111) ? RxReg7              : (
                           (RdPtr == 5'b01000) ? RxReg8              : (
                           (RdPtr == 5'b01001) ? RxReg9              : (
                           (RdPtr == 5'b01010) ? RxReg10             : (
                           (RdPtr == 5'b01011) ? RxReg11             : (
                           (RdPtr == 5'b01100) ? RxReg12             : (
                           (RdPtr == 5'b01101) ? RxReg13             : (
                           (RdPtr == 5'b01110) ? RxReg14             : (
                           (RdPtr == 5'b01111) ? RxReg15             : (
                           (RdPtr == 5'b10000) ? RxReg16             : (
                           (RdPtr == 5'b10001) ? RxReg17             : (
                           (RdPtr == 5'b10010) ? RxReg18             : (
                           (RdPtr == 5'b10011) ? RxReg19             : (
                           (RdPtr == 5'b10100) ? RxReg20             : (
                           (RdPtr == 5'b10101) ? RxReg21             : (
                           (RdPtr == 5'b10110) ? RxReg22             : (
                           (RdPtr == 5'b10111) ? RxReg23             : (
                           (RdPtr == 5'b11000) ? RxReg24             : (
                           (RdPtr == 5'b11001) ? RxReg25             : (
                           (RdPtr == 5'b11010) ? RxReg26             : (
                           (RdPtr == 5'b11011) ? RxReg27             : (
                           (RdPtr == 5'b11100) ? RxReg28             : (
                           (RdPtr == 5'b11101) ? RxReg29             : (
                           (RdPtr == 5'b11110) ? RxReg30             : (
                           (RdPtr == 5'b11111) ? RxReg31             :
                           33'h000000000)))))))))))))))))))))))))))))));

endmodule
// --================================== End ==================================--
