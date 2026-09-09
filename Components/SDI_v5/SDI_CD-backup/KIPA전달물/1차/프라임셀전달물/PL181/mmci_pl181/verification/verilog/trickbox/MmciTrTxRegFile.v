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
// File Name              : MmciTrTxRegFile.v.rca
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

module MmciTrTxRegFile (
// Inputs
                        PCLK,
                        PRESETn,
                        RegFileWrEn,
                        WrPtr,
                        RdPtr,
                        PWDATAIn,
// Outputs
                        TxFRdData
                       );

// Inputs
input         PCLK;        // APB bus clock
input         PRESETn;     // APB Bus Reset
input         RegFileWrEn; // Write enable
input   [4:0] WrPtr;       // Write pointer
input   [4:0] RdPtr;       // Read pointer
input  [31:0] PWDATAIn;    // Write data

// Outputs
output [31:0] TxFRdData;   // Read Data

// Inputs
wire        PCLK;        // APB bus clock
wire        PRESETn;     // APB Bus Reset
wire        RegFileWrEn; // Write enable
wire  [4:0] WrPtr;       // Write pointer
wire  [4:0] RdPtr;       // Read pointer
wire [31:0] PWDATAIn;    // Write data

// Outputs
wire [31:0] TxFRdData;   // Read Data

// -----------------------------------------------------------------------------
//
//                               MmciTrTxRegFile
//                               ===============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module contains the Register file for the Transmit FIFO.When the
// Write enable signal RegFileWrEn is asserted, data on the wr data bus
// is written into the location pointed to by the current value of the
// Write pointer, WrPtr[3:0]. On the read interface, the contents of the
// location pointed to by the current value of the read ptr RdPtr, is
// driven onto the read databus, TxFRdData.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// reg declarations
// -----------------------------------------------------------------------------
reg [31:0] TxReg1;
// Receive FIFO register1

reg [31:0] TxReg2;
// Receive FIFO register2

reg [31:0] TxReg3;
// Receive FIFO register3

reg [31:0] TxReg4;
// Receive FIFO register4

reg [31:0] TxReg5;
// Receive FIFO register5

reg [31:0] TxReg6;
// Receive FIFO register6

reg [31:0] TxReg7;
// Receive FIFO register7

reg [31:0] TxReg8;
// Receive FIFO register8

reg [31:0] TxReg9;
// Receive FIFO register9

reg [31:0] TxReg10;
// Receive FIFO register10

reg [31:0] TxReg11;
// Receive FIFO register11

reg [31:0] TxReg12;
// Receive FIFO register12

reg [31:0] TxReg13;
// Receive FIFO register13

reg [31:0] TxReg14;
// Receive FIFO register14

reg [31:0] TxReg15;
// Receive FIFO register15

reg [31:0] TxReg16;
// Receive FIFO register16

reg [31:0] TxReg17;
// Receive FIFO register17

reg [31:0] TxReg18;
// Receive FIFO register18

reg [31:0] TxReg19;
// Receive FIFO register19

reg [31:0] TxReg20;
// Receive FIFO register20

reg [31:0] TxReg21;
// Receive FIFO register21

reg [31:0] TxReg22;
// Receive FIFO register22

reg [31:0] TxReg23;
// Receive FIFO register23

reg [31:0] TxReg24;
// Receive FIFO register24

reg [31:0] TxReg25;
// Receive FIFO register25

reg [31:0] TxReg26;
// Receive FIFO register26

reg [31:0] TxReg27;
// Receive FIFO register27

reg [31:0] TxReg28;
// Receive FIFO register28

reg [31:0] TxReg29;
// Receive FIFO register29

reg [31:0] TxReg30;
// Receive FIFO register30

reg [31:0] TxReg31;
// Receive FIFO register31

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [31:0] TxReg0;
// Receive FIFO register0

reg  [31:0] NextTxReg0;
// D-input of TxReg0

reg  [31:0] NextTxReg1;
// D-input of TxReg1

reg  [31:0] NextTxReg2;
// D-input of TxReg2

reg  [31:0] NextTxReg3;
// D-input of TxReg3

reg  [31:0] NextTxReg4;
// D-input of TxReg4

reg  [31:0] NextTxReg5;
// D-input of TxReg5

reg  [31:0] NextTxReg6;
// D-input of TxReg6

reg  [31:0] NextTxReg7;
// D-input of TxReg7

reg  [31:0] NextTxReg8;
// D-input of TxReg8

reg  [31:0] NextTxReg9;
// D-input of TxReg9

reg  [31:0] NextTxReg10;
// D-input of TxReg10

reg  [31:0] NextTxReg11;
// D-input of TxReg11

reg  [31:0] NextTxReg12;
// D-input of TxReg12

reg  [31:0] NextTxReg13;
// D-input of TxReg13

reg  [31:0] NextTxReg14;
// D-input of TxReg14

reg  [31:0] NextTxReg15;
// D-input of TxReg15

reg  [31:0] NextTxReg16;
// D-input of TxReg16

reg  [31:0] NextTxReg17;
// D-input of TxReg17

reg  [31:0] NextTxReg18;
// D-input of TxReg18

reg  [31:0] NextTxReg19;
// D-input of TxReg19

reg  [31:0] NextTxReg20;
// D-input of TxReg20

reg  [31:0] NextTxReg21;
// D-input of TxReg21

reg  [31:0] NextTxReg22;
// D-input of TxReg22

reg  [31:0] NextTxReg23;
// D-input of TxReg23

reg  [31:0] NextTxReg24;
// D-input of TxReg24

reg  [31:0] NextTxReg25;
// D-input of TxReg25

reg  [31:0] NextTxReg26;
// D-input of TxReg26

reg  [31:0] NextTxReg27;
// D-input of TxReg27

reg  [31:0] NextTxReg28;
// D-input of TxReg28

reg  [31:0] NextTxReg29;
// D-input of TxReg29

reg  [31:0] NextTxReg30;
// D-input of TxReg30

reg  [31:0] NextTxReg31;
// D-input of TxReg31

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
      TxReg0           <= 32'h00000000;
      TxReg1           <= 32'h00000000;
      TxReg2           <= 32'h00000000;
      TxReg3           <= 32'h00000000;
      TxReg4           <= 32'h00000000;
      TxReg5           <= 32'h00000000;
      TxReg6           <= 32'h00000000;
      TxReg7           <= 32'h00000000;
      TxReg8           <= 32'h00000000;
      TxReg9           <= 32'h00000000;
      TxReg10          <= 32'h00000000;
      TxReg11          <= 32'h00000000;
      TxReg12          <= 32'h00000000;
      TxReg13          <= 32'h00000000;
      TxReg14          <= 32'h00000000;
      TxReg15          <= 32'h00000000;
      TxReg16          <= 32'h00000000;
      TxReg17          <= 32'h00000000;
      TxReg18          <= 32'h00000000;
      TxReg19          <= 32'h00000000;
      TxReg20          <= 32'h00000000;
      TxReg21          <= 32'h00000000;
      TxReg22          <= 32'h00000000;
      TxReg23          <= 32'h00000000;
      TxReg24          <= 32'h00000000;
      TxReg25          <= 32'h00000000;
      TxReg26          <= 32'h00000000;
      TxReg27          <= 32'h00000000;
      TxReg28          <= 32'h00000000;
      TxReg29          <= 32'h00000000;
      TxReg30          <= 32'h00000000;
      TxReg31          <= 32'h00000000;
    end
  else
    begin
      TxReg0           <= NextTxReg0;
      TxReg1           <= NextTxReg1;
      TxReg2           <= NextTxReg2;
      TxReg3           <= NextTxReg3;
      TxReg4           <= NextTxReg4;
      TxReg5           <= NextTxReg5;
      TxReg6           <= NextTxReg6;
      TxReg7           <= NextTxReg7;
      TxReg8           <= NextTxReg8;
      TxReg9           <= NextTxReg9;
      TxReg10          <= NextTxReg10;
      TxReg11          <= NextTxReg11;
      TxReg12          <= NextTxReg12;
      TxReg13          <= NextTxReg13;
      TxReg14          <= NextTxReg14;
      TxReg15          <= NextTxReg15;
      TxReg16          <= NextTxReg16;
      TxReg17          <= NextTxReg17;
      TxReg18          <= NextTxReg18;
      TxReg19          <= NextTxReg19;
      TxReg20          <= NextTxReg20;
      TxReg21          <= NextTxReg21;
      TxReg22          <= NextTxReg22;
      TxReg23          <= NextTxReg23;
      TxReg24          <= NextTxReg24;
      TxReg25          <= NextTxReg25;
      TxReg26          <= NextTxReg26;
      TxReg27          <= NextTxReg27;
      TxReg28          <= NextTxReg28;
      TxReg29          <= NextTxReg29;
      TxReg30          <= NextTxReg30;
      TxReg31          <= NextTxReg31;
    end
end // p_Seq

// -----------------------------------------------------------------------------
// Write logic. When the Write enable signal, RegFileWrEn, is asserted,
// data on the write data bus PWDATAIn is written into the location
// pointed to by the current value of the Write pointer, WrPtr[2:0].
// -----------------------------------------------------------------------------
always @(TxReg0 or TxReg1 or TxReg2 or TxReg3 or TxReg4 or TxReg5 or
         TxReg6 or TxReg7 or TxReg8 or TxReg9 or TxReg10 or TxReg11 or
         TxReg12 or TxReg13 or TxReg14 or TxReg15 or TxReg16 or
         TxReg17 or TxReg18 or TxReg19 or TxReg20 or TxReg21 or
         TxReg22 or TxReg23 or TxReg24 or TxReg25 or TxReg26 or
         TxReg27 or TxReg28 or TxReg29 or TxReg30 or TxReg31 or
         WrPtr or RegFileWrEn or PWDATAIn)
begin : p_WrComb
  NextTxReg0       = TxReg0;
  NextTxReg1       = TxReg1;
  NextTxReg2       = TxReg2;
  NextTxReg3       = TxReg3;
  NextTxReg4       = TxReg4;
  NextTxReg5       = TxReg5;
  NextTxReg6       = TxReg6;
  NextTxReg7       = TxReg7;
  NextTxReg8       = TxReg8;
  NextTxReg9       = TxReg9;
  NextTxReg10      = TxReg10;
  NextTxReg11      = TxReg11;
  NextTxReg12      = TxReg12;
  NextTxReg13      = TxReg13;
  NextTxReg14      = TxReg14;
  NextTxReg15      = TxReg15;
  NextTxReg16      = TxReg16;
  NextTxReg17      = TxReg17;
  NextTxReg18      = TxReg18;
  NextTxReg19      = TxReg19;
  NextTxReg20      = TxReg20;
  NextTxReg21      = TxReg21;
  NextTxReg22      = TxReg22;
  NextTxReg23      = TxReg23;
  NextTxReg24      = TxReg24;
  NextTxReg25      = TxReg25;
  NextTxReg26      = TxReg26;
  NextTxReg27      = TxReg27;
  NextTxReg28      = TxReg28;
  NextTxReg29      = TxReg29;
  NextTxReg30      = TxReg30;
  NextTxReg31      = TxReg31;
  if (RegFileWrEn ==  1'b1)
    begin
      case (WrPtr)
        5'b00000 :
          NextTxReg0       = PWDATAIn;
        5'b00001 :
          NextTxReg1       = PWDATAIn;
        5'b00010 :
          NextTxReg2       = PWDATAIn;
        5'b00011 :
          NextTxReg3       = PWDATAIn;
        5'b00100 :
          NextTxReg4       = PWDATAIn;
        5'b00101 :
          NextTxReg5       = PWDATAIn;
        5'b00110 :
          NextTxReg6       = PWDATAIn;
        5'b00111 :
          NextTxReg7       = PWDATAIn;
        5'b01000 :
          NextTxReg8       = PWDATAIn;
        5'b01001 :
          NextTxReg9       = PWDATAIn;
        5'b01010 :
          NextTxReg10      = PWDATAIn;
        5'b01011 :
          NextTxReg11      = PWDATAIn;
        5'b01100 :
          NextTxReg12      = PWDATAIn;
        5'b01101 :
          NextTxReg13      = PWDATAIn;
        5'b01110 :
          NextTxReg14      = PWDATAIn;
        5'b01111 :
          NextTxReg15      = PWDATAIn;
        5'b10000 :
          NextTxReg16      = PWDATAIn;
        5'b10001 :
          NextTxReg17      = PWDATAIn;
        5'b10010 :
          NextTxReg18      = PWDATAIn;
        5'b10011 :
          NextTxReg19      = PWDATAIn;
        5'b10100 :
          NextTxReg20      = PWDATAIn;
        5'b10101 :
          NextTxReg21      = PWDATAIn;
        5'b10110 :
          NextTxReg22      = PWDATAIn;
        5'b10111 :
          NextTxReg23      = PWDATAIn;
        5'b11000 :
          NextTxReg24      = PWDATAIn;
        5'b11001 :
          NextTxReg25      = PWDATAIn;
        5'b11010 :
          NextTxReg26      = PWDATAIn;
        5'b11011 :
          NextTxReg27      = PWDATAIn;
        5'b11100 :
          NextTxReg28      = PWDATAIn;
        5'b11101 :
          NextTxReg29      = PWDATAIn;
        5'b11110 :
          NextTxReg30      = PWDATAIn;
        5'b11111 :
          NextTxReg31      = PWDATAIn;
        default :
          NextTxReg31      = PWDATAIn;
    endcase
  end
end // p_WrComb

// -----------------------------------------------------------------------------
// Read Mux.The contents of the location pointed to by the current value
// of the read ptr RdPtr, is driven onto the read databus, TxFRdData.
// -----------------------------------------------------------------------------
assign TxFRdData        = (RdPtr == 5'b00000) ? TxReg0               : (
                           (RdPtr == 5'b00001) ? TxReg1              : (
                           (RdPtr == 5'b00010) ? TxReg2              : (
                           (RdPtr == 5'b00011) ? TxReg3              : (
                           (RdPtr == 5'b00100) ? TxReg4              : (
                           (RdPtr == 5'b00101) ? TxReg5              : (
                           (RdPtr == 5'b00110) ? TxReg6              : (
                           (RdPtr == 5'b00111) ? TxReg7              : (
                           (RdPtr == 5'b01000) ? TxReg8              : (
                           (RdPtr == 5'b01001) ? TxReg9              : (
                           (RdPtr == 5'b01010) ? TxReg10             : (
                           (RdPtr == 5'b01011) ? TxReg11             : (
                           (RdPtr == 5'b01100) ? TxReg12             : (
                           (RdPtr == 5'b01101) ? TxReg13             : (
                           (RdPtr == 5'b01110) ? TxReg14             : (
                           (RdPtr == 5'b01111) ? TxReg15             : (
                           (RdPtr == 5'b10000) ? TxReg16             : (
                           (RdPtr == 5'b10001) ? TxReg17             : (
                           (RdPtr == 5'b10010) ? TxReg18             : (
                           (RdPtr == 5'b10011) ? TxReg19             : (
                           (RdPtr == 5'b10100) ? TxReg20             : (
                           (RdPtr == 5'b10101) ? TxReg21             : (
                           (RdPtr == 5'b10110) ? TxReg22             : (
                           (RdPtr == 5'b10111) ? TxReg23             : (
                           (RdPtr == 5'b11000) ? TxReg24             : (
                           (RdPtr == 5'b11001) ? TxReg25             : (
                           (RdPtr == 5'b11010) ? TxReg26             : (
                           (RdPtr == 5'b11011) ? TxReg27             : (
                           (RdPtr == 5'b11100) ? TxReg28             : (
                           (RdPtr == 5'b11101) ? TxReg29             : (
                           (RdPtr == 5'b11110) ? TxReg30             : (
                           (RdPtr == 5'b11111) ? TxReg31             :
                           32'h00000000)))))))))))))))))))))))))))))));

endmodule
// --================================== End ==================================--
