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
//  File Name              : UartRXRegFile.v.rca
//  File Revision          : 1.3
//
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//
// -----------------------------------------------------------------------------
// Purpose     : This block contains the Register File for the
//               Receive FIFO
// --=========================================================================--
`timescale 1ns/1ps

module UartRXRegFile (
                      PCLK,
                      PRESETn,
                      RegFileWrEn,
                      WrPtr,
                      RdPtr,
                      RXFIFOData,
                      RXFRdData
                     );

input         PCLK;           // APB Clock
input         PRESETn;        // APB Bus Reset
input         RegFileWrEn;    // Write Enable
input  [3:0]  WrPtr;          // Write Pointer
input  [3:0]  RdPtr;          // Read Pointer
input [11:0]  RXFIFOData;     // Write data

output [11:0] RXFRdData;      // Read data
//
// -----------------------------------------------------------------------------
//
//                   UartRXRegFile
//                   =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//  This block contains an array of flipflops that serve as the storage
//  register file for the receive FIFO.
//
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declaration
// -----------------------------------------------------------------------------
wire          PCLK;
// APB Clock                                            (Module Input)

wire          PRESETn;
// APB Bus REset                                        (Module Input)

wire          RegFileWrEn;
// Write Enable                                         (Module Input)

wire [3:0]    WrPtr;
// Write Pointer                                        (Module Input)

wire [3:0]    RdPtr;
// Read Pointer                                         (Module Input)

wire [11:0]   RXFIFOData;
// Write data                                           (Module Input)

wire [11:0]  RXFRdData;
// Read data                                            (Module Output)


// -----------------------------------------------------------------------------
// register declaration
// -----------------------------------------------------------------------------
  reg [11:0] RXRegFile0;
// Register File-0 12-bits wide

  reg [11:0] RXRegFile1;
// Register File-1 12-bits wide

  reg [11:0] RXRegFile2;
// Register File-2 12-bits wide

  reg [11:0] RXRegFile3;
// Register File-3 12-bits wide

  reg [11:0] RXRegFile4;
// Register File-4 12-bits wide

  reg [11:0] RXRegFile5;
// Register File-5 12-bits wide

  reg [11:0] RXRegFile6;
// Register File-6 12-bits wide

  reg [11:0] RXRegFile7;
// Register File-7 12-bits wide

  reg [11:0] RXRegFile8;
// Register File-8 12-bits wide

  reg [11:0] RXRegFile9;
// Register File-9 12-bits wide

  reg [11:0] RXRegFile10;
// Register File-10 12-bits wide

  reg [11:0] RXRegFile11;
// Register File-11 12-bits wide

  reg [11:0] RXRegFile12;
// Register File-12 12-bits wide

  reg [11:0] RXRegFile13;
// Register File-13 12-bits wide

  reg [11:0] RXRegFile14;
// Register File-14 12-bits wide

  reg [11:0] RXRegFile15;
// Register File-15 12-bits wide

//  reg [11:0] RXRegFile16;
// Register File-16 12-bits wide

  reg [11:0] NextRXRegFile0;
// D-inputs of Register File-1 12-bits wide

  reg [11:0] NextRXRegFile1;
// D-inputs of Register File-1 12-bits wide

  reg [11:0] NextRXRegFile2;
// D-inputs of Register File-2 12-bits wide

  reg [11:0] NextRXRegFile3;
// D-inputs of Register File-3 12-bits wide

  reg [11:0] NextRXRegFile4;
// D-inputs of Register File-4 12-bits wide

  reg [11:0] NextRXRegFile5;
// D-inputs of Register File-5 12-bits wide

  reg [11:0] NextRXRegFile6;
// D-inputs of Register File-6 12-bits wide

  reg [11:0] NextRXRegFile7;
// D-inputs of Register File-7 12-bits wide

  reg [11:0] NextRXRegFile8;
// D-inputs of Register File-8 12-bits wide

  reg [11:0] NextRXRegFile9;
// D-inputs of Register File-9 12-bits wide

  reg [11:0] NextRXRegFile10;
// D-inputs of Register File-10 12-bits wide

  reg [11:0] NextRXRegFile11;
// D-inputs of Register File-11 12-bits wide

  reg [11:0] NextRXRegFile12;
// D-inputs of Register File-12 12-bits wide

  reg [11:0] NextRXRegFile13;
// D-inputs of Register File-13 12-bits wide

  reg [11:0] NextRXRegFile14;
// D-inputs of Register File-14 12-bits wide

  reg [11:0] NextRXRegFile15;
// D-inputs of Register File-15 12-bits wide

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
        RXRegFile0  <= 12'b000000000000;
        RXRegFile1  <= 12'b000000000000;
        RXRegFile2  <= 12'b000000000000;
        RXRegFile3  <= 12'b000000000000;
        RXRegFile4  <= 12'b000000000000;
        RXRegFile5  <= 12'b000000000000;
        RXRegFile6  <= 12'b000000000000;
        RXRegFile7  <= 12'b000000000000;
        RXRegFile8  <= 12'b000000000000;
        RXRegFile9  <= 12'b000000000000;
        RXRegFile10 <= 12'b000000000000;
        RXRegFile11 <= 12'b000000000000;
        RXRegFile12 <= 12'b000000000000;
        RXRegFile13 <= 12'b000000000000;
        RXRegFile14 <= 12'b000000000000;
        RXRegFile15 <= 12'b000000000000;
      end
     else
      begin
        RXRegFile0  <= NextRXRegFile0;
        RXRegFile1  <= NextRXRegFile1;
        RXRegFile2  <= NextRXRegFile2;
        RXRegFile3  <= NextRXRegFile3;
        RXRegFile4  <= NextRXRegFile4;
        RXRegFile5  <= NextRXRegFile5;
        RXRegFile6  <= NextRXRegFile6;
        RXRegFile7  <= NextRXRegFile7;
        RXRegFile8  <= NextRXRegFile8;
        RXRegFile9  <= NextRXRegFile9;
        RXRegFile10 <= NextRXRegFile10;
        RXRegFile11 <= NextRXRegFile11;
        RXRegFile12 <= NextRXRegFile12;
        RXRegFile13 <= NextRXRegFile13;
        RXRegFile14 <= NextRXRegFile14;
        RXRegFile15 <= NextRXRegFile15;
      end
end // p_Seq;

// -----------------------------------------------------------------------------
// Write logic
// -----------------------------------------------------------------------------
always @(RXRegFile0 or RXRegFile1 or RXRegFile2 or RXRegFile3 or
         RXRegFile4 or RXRegFile5 or RXRegFile6 or RXRegFile7 or
         RXRegFile8 or RXRegFile9 or RXRegFile10 or RXRegFile11 or
         RXRegFile12 or RXRegFile13 or RXRegFile14 or RXRegFile15 or
         RegFileWrEn or RXFIFOData or WrPtr)
begin : p_WrComb
  NextRXRegFile0 = RXRegFile0;
  NextRXRegFile1 = RXRegFile1;
  NextRXRegFile2 = RXRegFile2;
  NextRXRegFile3 = RXRegFile3;
  NextRXRegFile4 = RXRegFile4;
  NextRXRegFile5 = RXRegFile5;
  NextRXRegFile6 = RXRegFile6;
  NextRXRegFile7 = RXRegFile7;
  NextRXRegFile8 = RXRegFile8;
  NextRXRegFile9 = RXRegFile9;
  NextRXRegFile10 = RXRegFile10;
  NextRXRegFile11 = RXRegFile11;
  NextRXRegFile12 = RXRegFile12;
  NextRXRegFile13 = RXRegFile13;
  NextRXRegFile14 = RXRegFile14;
  NextRXRegFile15 = RXRegFile15;

  if(RegFileWrEn == 1'b1)
    case (WrPtr)
      4'b0000 : NextRXRegFile0  = RXFIFOData;
      4'b0001 : NextRXRegFile1  = RXFIFOData;
      4'b0010 : NextRXRegFile2  = RXFIFOData;
      4'b0011 : NextRXRegFile3  = RXFIFOData;
      4'b0100 : NextRXRegFile4  = RXFIFOData;
      4'b0101 : NextRXRegFile5  = RXFIFOData;
      4'b0110 : NextRXRegFile6  = RXFIFOData;
      4'b0111 : NextRXRegFile7  = RXFIFOData;
      4'b1000 : NextRXRegFile8  = RXFIFOData;
      4'b1001 : NextRXRegFile9  = RXFIFOData;
      4'b1010 : NextRXRegFile10 = RXFIFOData;
      4'b1011 : NextRXRegFile11 = RXFIFOData;
      4'b1100 : NextRXRegFile12 = RXFIFOData;
      4'b1101 : NextRXRegFile13 = RXFIFOData;
      4'b1110 : NextRXRegFile14 = RXFIFOData;
      4'b1111 : NextRXRegFile15 = RXFIFOData;
      default :;
    endcase
end // p_WrComb;

// -----------------------------------------------------------------------------
// Read Mux
// -----------------------------------------------------------------------------
assign RXFRdData =   (RdPtr == 4'b0000) ? RXRegFile0
                   : (RdPtr == 4'b0001) ? RXRegFile1
                   : (RdPtr == 4'b0010) ? RXRegFile2
                   : (RdPtr == 4'b0011) ? RXRegFile3
                   : (RdPtr == 4'b0100) ? RXRegFile4
                   : (RdPtr == 4'b0101) ? RXRegFile5
                   : (RdPtr == 4'b0110) ? RXRegFile6
                   : (RdPtr == 4'b0111) ? RXRegFile7
                   : (RdPtr == 4'b1000) ? RXRegFile8
                   : (RdPtr == 4'b1001) ? RXRegFile9
                   : (RdPtr == 4'b1010) ? RXRegFile10
                   : (RdPtr == 4'b1011) ? RXRegFile11
                   : (RdPtr == 4'b1100) ? RXRegFile12
                   : (RdPtr == 4'b1101) ? RXRegFile13
                   : (RdPtr == 4'b1110) ? RXRegFile14
                   : (RdPtr == 4'b1111) ? RXRegFile15
                   :  12'b000000000000;

endmodule

// -============================ End of UartRXRegFile ========================--

