// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : EbiTrMultBlk.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block implements the multiplexers for the address, data and
//           data enable signals
//
// --=========================================================================--

`timescale 1ns/1ps


module EbiTrMultBlk (
// Inputs
                     EBICLK,
                     nPOR,
                     EbiTrGnt,
                     EBIADDR1,
                     EBIADDR2,
                     EBIADDR3,
                     nEBIDATAEN1,
                     nEBIDATAEN2,
                     nEBIDATAEN3,
                     EBIDATA1,
                     EBIDATA2,
                     EBIDATA3,
                     EBIEXTDATAIN,

// Outputs
                     EbiTrDataIn,
                     EbiTrExtAddrOut,
                     EbiTrExtDataOut,
                     nEbiTrExtDataEn
                     );

// Inputs
input         EBICLK;          // External Bus Interface Clock
input         nPOR;            // Power On Reset
input   [2:0] EbiTrGnt;        // EbiTrGnt(0) EBI Grant for Port 1
                               // EbiTrGnt(1) EBI Grant for Port 2
                               // EbiTrGnt(2) EBI Grant for Port 3
input  [31:0] EBIADDR1;        // EBI Address for Port 1
input  [31:0] EBIADDR2;        // EBI Address for Port 2
input  [31:0] EBIADDR3;        // EBI Address for Port 3
input   [3:0] nEBIDATAEN1;     // EBI Data Enable for port 1
input   [3:0] nEBIDATAEN2;     // EBI Data Enable for port 2
input   [3:0] nEBIDATAEN3;     // EBI Data Enable for port 3
input  [31:0] EBIDATA1;        // EBI Data for Port 1
input  [31:0] EBIDATA2;        // EBI Data for Port 2
input  [31:0] EBIDATA3;        // EBI Data for Port 3
input  [31:0] EBIEXTDATAIN;    // EBI External Data In



// Outputs
output [31:0] EbiTrDataIn;     // Data input connected to all the
                               // Controllers
output [31:0] EbiTrExtAddrOut; // Address output to the pads
output [31:0] EbiTrExtDataOut; // Data output to the pads
output  [3:0] nEbiTrExtDataEn; // Data Enable to the pads




// Inputs
  wire        EBICLK;          // External Bus Interface Clock
  wire        nPOR;            // Power On Reset
  wire  [2:0] EbiTrGnt;        // EbiTrGnt(0) EBI Grant for Port 1
                               // EbiTrGnt(1) EBI Grant for Port 2
                               // EbiTrGnt(2) EBI Grant for Port 3
  wire [31:0] EBIADDR1;        // EBI Address for Port 1
  wire [31:0] EBIADDR2;        // EBI Address for Port 2
  wire [31:0] EBIADDR3;        // EBI Address for Port 3
  wire  [3:0] nEBIDATAEN1;     // EBI Data Enable for port 1
  wire  [3:0] nEBIDATAEN2;     // EBI Data Enable for port 2
  wire  [3:0] nEBIDATAEN3;     // EBI Data Enable for port 3
  wire [31:0] EBIDATA1;        // EBI Data for Port 1
  wire [31:0] EBIDATA2;        // EBI Data for Port 2
  wire [31:0] EBIDATA3;        // EBI Data for Port 3
  wire [31:0] EBIEXTDATAIN;    // EBI External Data In



// Outputs
  wire [31:0] EbiTrDataIn;     // Data input connected to all the
                               // Controllers
  wire [31:0] EbiTrExtAddrOut; // Address output to the pads
  wire [31:0] EbiTrExtDataOut; // Data output to the pads
  wire  [3:0] nEbiTrExtDataEn; // Data Enable to the pads


// -----------------------------------------------------------------------------
//
//                                EbiTrMultBlk
//                                ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// o Multiplexer block
//     The multiplexer block multiplexes the address, data and data enable lines
//     from three separate controllers on to the common address, data and
//     data enable pins of the chip.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [31:0] EbiTrExtDataOutl;
// Internal version of the EbiTrExtDataOut signal

wire [31:0] EbiTrExtAddrOutl;
// Internal version of the EbiTrExtAddrOut signal

wire  [3:0] nEbiTrExtDataEnl;
// Internal version of the nEbiTrExtDataEn signal

// -----------------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg [31:0] iEbiTrExtDataOut;
// Latched version of the EbiTrExtDataOut signal

reg [31:0] iEbiTrExtAddrOut;
// Latched version of the EbiTrExtAddrOut signal

reg  [3:0] inEbiTrExtDataEn;
// Latched version of the nEbiTrExtDataEn signal


// ---------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// This process latches the previous values of EbiTrExtDataOutl,
// EbiTrExtAddrOutl and nEbiTrExtDataEnl which is set as default
// on common address, data and data enable pins of the chip.
// -----------------------------------------------------------------------------
always @(posedge EBICLK or negedge nPOR)
begin : p_latchSeq
  if (nPOR == 1'b0)
  begin
    iEbiTrExtDataOut <= 32'b0;
    iEbiTrExtAddrOut <= 32'b0;
    inEbiTrExtDataEn <= 4'b1111;
  end
  else
  begin
    iEbiTrExtDataOut <= EbiTrExtDataOutl;
    iEbiTrExtAddrOut <= EbiTrExtAddrOutl;
    inEbiTrExtDataEn <= nEbiTrExtDataEnl;
  end
end // p_latchSeq
// -----------------------------------------------------------------------------
// Mux the EBIDATA signals which is sent out as EbiTrExtDataOut
// based on the EbiTrGnt signal .
// -----------------------------------------------------------------------------
assign EbiTrExtDataOut  = EbiTrGnt == 3'b001 ? EBIDATA1              : (
                           EbiTrGnt == 3'b010 ? EBIDATA2             : (
                           EbiTrGnt == 3'b100 ? EBIDATA3             :
                           iEbiTrExtDataOut));
// -----------------------------------------------------------------------------
// Mux the EBIDATA signals which is used for internal latching
// based on the EbiTrGnt signal .
// -----------------------------------------------------------------------------
assign EbiTrExtDataOutl = EbiTrGnt == 3'b001 ? EBIDATA1              : (
                           EbiTrGnt == 3'b010 ? EBIDATA2             : (
                           EbiTrGnt == 3'b100 ? EBIDATA3             :
                           iEbiTrExtDataOut));
// -----------------------------------------------------------------------------
// Mux the EBIADDR signals which is sent out as EbiTrExtAddrOut
// based on the EbiTrGnt signal.
// -----------------------------------------------------------------------------
assign EbiTrExtAddrOut  = EbiTrGnt == 3'b001 ? EBIADDR1              : (
                           EbiTrGnt == 3'b010 ? EBIADDR2             : (
                           EbiTrGnt == 3'b100 ? EBIADDR3             :
                           iEbiTrExtAddrOut));
// -----------------------------------------------------------------------------
// Mux the EBIADDR signals which is used for internal latching
// based on the EbiTrGnt signal.
// -----------------------------------------------------------------------------
assign EbiTrExtAddrOutl = EbiTrGnt == 3'b001 ? EBIADDR1              : (
                           EbiTrGnt == 3'b010 ? EBIADDR2             : (
                           EbiTrGnt == 3'b100 ? EBIADDR3             :
                           iEbiTrExtAddrOut));
// -----------------------------------------------------------------------------
// Mux the nEBIDATAEN signals which is sent out as nEbiTrExtDataEn
// based on the EbiTrGnt signal.
// -----------------------------------------------------------------------------
assign nEbiTrExtDataEn  = EbiTrGnt == 3'b001 ? nEBIDATAEN1           : (
                           EbiTrGnt == 3'b010 ? nEBIDATAEN2          : (
                           EbiTrGnt == 3'b100 ? nEBIDATAEN3          :
                           inEbiTrExtDataEn));
// -----------------------------------------------------------------------------
// Mux the nEBIDATAEN signals which is used for internal latching
// based on the EbiTrGnt signal.
// -----------------------------------------------------------------------------
assign nEbiTrExtDataEnl = EbiTrGnt == 3'b001 ? nEBIDATAEN1           : (
                           EbiTrGnt == 3'b010 ? nEBIDATAEN2          : (
                           EbiTrGnt == 3'b100 ? nEBIDATAEN3          :
                           inEbiTrExtDataEn));
// -----------------------------------------------------------------------------
// The value on EBIEXTDATAIN signal is passed on EbiTrDataIn
// signal.
// -----------------------------------------------------------------------------
assign EbiTrDataIn      = EBIEXTDATAIN;

endmodule
// --================================== End ==================================--
