// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : UartTXRegFile.v.rca
//  File Revision          : 1.3
//
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//
// -----------------------------------------------------------------------------
// Purpose     : This block contains the Register File for the
//               Transmit FIFO
// --=========================================================================--

`timescale 1ns/1ps

module UartTXRegFile (
                      PCLK,
                      PRESETn,
                      RegFileWrEn,
                      WrPtr,
                      RdPtr,
                      PWDATAIn,
                      iTXFIFOData
                     );

input          PCLK;           // APB Clock
input          PRESETn;        // APB Bus Reset
input          RegFileWrEn;    // Write Enable
input [3:0]    WrPtr;          // Write Pointer
input [3:0]    RdPtr;          // Read Pointer
input [7:0]    PWDATAIn;       // Data bus

output [7:0]   iTXFIFOData;    // Read data
//
// -----------------------------------------------------------------------------
//
//                   UartTXRegFile
//                   =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//  This block contains an array of flipflops that serve as the storage
//  register file for the transmit FIFO.
//
//
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// wire declaration
// -----------------------------------------------------------------------------
wire          PCLK;
// APB Clock                                              (Module Input)

wire          PRESETn;
// APB Bus Reset					  (Module Input)

wire          RegFileWrEn;
// Write Enable                                           (Module Input)

wire [3:0]    WrPtr;
// Write Pointer                                          (Module Input)

wire [3:0]    RdPtr;
// Read Pointer                                           (Module Input)

wire [7:0]    PWDATAIn;
// Data bus                                               (Module Input)

// -----------------------------------------------------------------------------
// register declaration
// -----------------------------------------------------------------------------
  reg [7:0] TXRegFile0;
// Register File-0 8-bits wide

  reg [7:0] TXRegFile1;
// Register File-1 8-bits wide

  reg [7:0] TXRegFile2;
// Register File-2 8-bits wide

  reg [7:0] TXRegFile3;
// Register File-3 8-bits wide

  reg [7:0] TXRegFile4;
// Register File-4 8-bits wide

  reg [7:0] TXRegFile5;
// Register File-5 8-bits wide

  reg [7:0] TXRegFile6;
// Register File-6 8-bits wide

  reg [7:0] TXRegFile7;
// Register File-7 8-bits wide

  reg [7:0] TXRegFile8;
// Register File-8 8-bits wide

  reg [7:0] TXRegFile9;
// Register File-9 8-bits wide

  reg [7:0] TXRegFile10;
// Register File-10 8-bits wide

  reg [7:0] TXRegFile11;
// Register File-11 8-bits wide

  reg [7:0] TXRegFile12;
// Register File-12 8-bits wide

  reg [7:0] TXRegFile13;
// Register File-13 8-bits wide

  reg [7:0] TXRegFile14;
// Register File-14 8-bits wide

  reg [7:0] TXRegFile15;
// Register File-15 8-bits wide

  //reg [7:0] TXRegFile16;
// Register File-16 8-bits wide

  reg [7:0] NextTXRegFile0;
// D-inputs of Register File-1 8-bits wide

  reg [7:0] NextTXRegFile1;
// D-inputs of Register File-1 8-bits wide

  reg [7:0] NextTXRegFile2;
// D-inputs of Register File-2 8-bits wide

  reg [7:0] NextTXRegFile3;
// D-inputs of Register File-3 8-bits wide

  reg [7:0] NextTXRegFile4;
// D-inputs of Register File-4 8-bits wide

  reg [7:0] NextTXRegFile5;
// D-inputs of Register File-5 8-bits wide

  reg [7:0] NextTXRegFile6;
// D-inputs of Register File-6 8-bits wide

  reg [7:0] NextTXRegFile7;
// D-inputs of Register File-7 8-bits wide

  reg [7:0] NextTXRegFile8;
// D-inputs of Register File-8 8-bits wide

  reg [7:0] NextTXRegFile9;
// D-inputs of Register File-9 8-bits wide

  reg [7:0] NextTXRegFile10;
// D-inputs of Register File-10 8-bits wide

  reg [7:0] NextTXRegFile11;
// D-inputs of Register File-11 8-bits wide

  reg [7:0] NextTXRegFile12;
// D-inputs of Register File-12 8-bits wide

  reg [7:0] NextTXRegFile13;
// D-inputs of Register File-13 8-bits wide

  reg [7:0] NextTXRegFile14;
// D-inputs of Register File-14 8-bits wide

  reg [7:0] NextTXRegFile15;
// D-inputs of Register File-15 8-bits wide


// -----------------------------------------------------------------------------
//
// Main Verilog code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Register array
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
  begin : p_Seq
    if (PRESETn == 1'b0)
      begin
        TXRegFile0  <= 8'b00000000;
        TXRegFile1  <= 8'b00000000;
        TXRegFile2  <= 8'b00000000;
        TXRegFile3  <= 8'b00000000;
        TXRegFile4  <= 8'b00000000;
        TXRegFile5  <= 8'b00000000;
        TXRegFile6  <= 8'b00000000;
        TXRegFile7  <= 8'b00000000;
        TXRegFile8  <= 8'b00000000;
        TXRegFile9  <= 8'b00000000;
        TXRegFile10 <= 8'b00000000;
        TXRegFile11 <= 8'b00000000;
        TXRegFile12 <= 8'b00000000;
        TXRegFile13 <= 8'b00000000;
        TXRegFile14 <= 8'b00000000;
        TXRegFile15 <= 8'b00000000;
      end
     else
      begin
        TXRegFile0  <= NextTXRegFile0;
        TXRegFile1  <= NextTXRegFile1;
        TXRegFile2  <= NextTXRegFile2;
        TXRegFile3  <= NextTXRegFile3;
        TXRegFile4  <= NextTXRegFile4;
        TXRegFile5  <= NextTXRegFile5;
        TXRegFile6  <= NextTXRegFile6;
        TXRegFile7  <= NextTXRegFile7;
        TXRegFile8  <= NextTXRegFile8;
        TXRegFile9  <= NextTXRegFile9;
        TXRegFile10 <= NextTXRegFile10;
        TXRegFile11 <= NextTXRegFile11;
        TXRegFile12 <= NextTXRegFile12;
        TXRegFile13 <= NextTXRegFile13;
        TXRegFile14 <= NextTXRegFile14;
        TXRegFile15 <= NextTXRegFile15;
      end
end // p_Seq;

// -----------------------------------------------------------------------------
// Write logic
// -----------------------------------------------------------------------------

always @(TXRegFile0 or TXRegFile1 or TXRegFile2 or TXRegFile3 or
         TXRegFile4 or TXRegFile5 or TXRegFile6 or TXRegFile7 or
         TXRegFile8 or TXRegFile9 or TXRegFile10 or TXRegFile11 or
         TXRegFile12 or TXRegFile13 or TXRegFile14 or TXRegFile15 or
         RegFileWrEn or PWDATAIn or WrPtr)
begin : p_WrPtrComb
  NextTXRegFile0  = TXRegFile0;
  NextTXRegFile1  = TXRegFile1;
  NextTXRegFile2  = TXRegFile2;
  NextTXRegFile3  = TXRegFile3;
  NextTXRegFile4  = TXRegFile4;
  NextTXRegFile5  = TXRegFile5;
  NextTXRegFile6  = TXRegFile6;
  NextTXRegFile7  = TXRegFile7;
  NextTXRegFile8  = TXRegFile8;
  NextTXRegFile9  = TXRegFile9;
  NextTXRegFile10 = TXRegFile10;
  NextTXRegFile11 = TXRegFile11;
  NextTXRegFile12 = TXRegFile12;
  NextTXRegFile13 = TXRegFile13;
  NextTXRegFile14 = TXRegFile14;
  NextTXRegFile15 = TXRegFile15;

  if(RegFileWrEn == 1'b1)
    case (WrPtr)
      4'b0000 : NextTXRegFile0  = PWDATAIn;
      4'b0001 : NextTXRegFile1  = PWDATAIn;
      4'b0010 : NextTXRegFile2  = PWDATAIn;
      4'b0011 : NextTXRegFile3  = PWDATAIn;
      4'b0100 : NextTXRegFile4  = PWDATAIn;
      4'b0101 : NextTXRegFile5  = PWDATAIn;
      4'b0110 : NextTXRegFile6  = PWDATAIn;
      4'b0111 : NextTXRegFile7  = PWDATAIn;
      4'b1000 : NextTXRegFile8  = PWDATAIn;
      4'b1001 : NextTXRegFile9  = PWDATAIn;
      4'b1010 : NextTXRegFile10 = PWDATAIn;
      4'b1011 : NextTXRegFile11 = PWDATAIn;
      4'b1100 : NextTXRegFile12 = PWDATAIn;
      4'b1101 : NextTXRegFile13 = PWDATAIn;
      4'b1110 : NextTXRegFile14 = PWDATAIn;
      4'b1111 : NextTXRegFile15 = PWDATAIn;
      default :;
    endcase
end // p_WrPtrComb;

// -----------------------------------------------------------------------------
// Read Mux
// -----------------------------------------------------------------------------
assign iTXFIFOData = (RdPtr == 4'b0000) ? TXRegFile0
                   : (RdPtr == 4'b0001) ? TXRegFile1
                   : (RdPtr == 4'b0010) ? TXRegFile2
                   : (RdPtr == 4'b0011) ? TXRegFile3
                   : (RdPtr == 4'b0100) ? TXRegFile4
                   : (RdPtr == 4'b0101) ? TXRegFile5
                   : (RdPtr == 4'b0110) ? TXRegFile6
                   : (RdPtr == 4'b0111) ? TXRegFile7
                   : (RdPtr == 4'b1000) ? TXRegFile8
                   : (RdPtr == 4'b1001) ? TXRegFile9
                   : (RdPtr == 4'b1010) ? TXRegFile10
                   : (RdPtr == 4'b1011) ? TXRegFile11
                   : (RdPtr == 4'b1100) ? TXRegFile12
                   : (RdPtr == 4'b1101) ? TXRegFile13
                   : (RdPtr == 4'b1110) ? TXRegFile14
                   : (RdPtr == 4'b1111) ? TXRegFile15
                   :  8'b00000000;

endmodule

// --============================ End of UartTXRegFile =======================--

