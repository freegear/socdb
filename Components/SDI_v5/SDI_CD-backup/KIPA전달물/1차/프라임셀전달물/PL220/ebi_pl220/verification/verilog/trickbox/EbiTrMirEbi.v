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
// File Name              : EbiTrMirEbi.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This the Top Level file for Ebi Mirror Trick Box.
//
// --=========================================================================--

`timescale 1ns/1ps


module EbiTrMirEbi (
// Inputs
                    EBICLK,
                    nPOR,
                    EBIREQ1,
                    EBIREQ2,
                    EBIREQ3,
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
                    EBITIMEOUTVALUE1,
                    EBITIMEOUTVALUE2,
                    EBITIMEOUTVALUE3,

// Outputs
                    EbiTrGnt1,
                    EbiTrGnt2,
                    EbiTrGnt3,
                    EbiTrBackoff1,
                    EbiTrBackoff2,
                    EbiTrBackoff3,
                    EbiTrDataIn,
                    EbiTrExtAddrOut,
                    EbiTrExtDataOut,
                    nEbiTrExtDataEn
                    );

// Inputs
input         EBICLK;           // External Bus Interface Clock
input         nPOR;             // Power On Reset
input         EBIREQ1;          // EBI request for Port 1, Active high
input         EBIREQ2;          // EBI request for Port 2, Active high
input         EBIREQ3;          // EBI request for Port 3, Active high
input  [31:0] EBIADDR1;         // EBI Address for Port 1
input  [31:0] EBIADDR2;         // EBI Address for Port 2
input  [31:0] EBIADDR3;         // EBI Address for Port 3
input   [3:0] nEBIDATAEN1;      // EBI Data Enable for port 1
input   [3:0] nEBIDATAEN2;      // EBI Data Enable for port 2
input   [3:0] nEBIDATAEN3;      // EBI Data Enable for port 3
input  [31:0] EBIDATA1;         // EBI Data for Port 1
input  [31:0] EBIDATA2;         // EBI Data for Port 2
input  [31:0] EBIDATA3;         // EBI Data for Port 3
input  [31:0] EBIEXTDATAIN;     // External Data input from the pads
input   [9:0] EBITIMEOUTVALUE1; // Gives the value to be loaded into
                                // timeout counter for port 1.
input   [9:0] EBITIMEOUTVALUE2; // Gives the value to be loaded into
                                // timeout counter for port 2.
input   [9:0] EBITIMEOUTVALUE3; // Gives the value to be loaded into
                                // timeout counter for port 3.



// Outputs
output        EbiTrGnt1;        // EBI Grant for port 1
output        EbiTrGnt2;        // EBI Grant for port 2
output        EbiTrGnt3;        // EBI Grant for port 3
output        EbiTrBackoff1;    // EBIBACKOFF signal for port 1
                                // Indicates to Controller-1 that the
                                // current transfer should be completed
                                // as soon as possible.
output        EbiTrBackoff2;    // EBIBACKOFF signal for port 2
                                // Indicates to Controller-2 that the
                                // current transfer should be completed
                                // as soon as possible.
output        EbiTrBackoff3;    // EBIBACKOFF signal for port 3
                                // Indicates to Controller-3 that the
                                // current transfer should be completed
                                // as soon as possible.
output [31:0] EbiTrDataIn;      // Data input connected to all the
                                // Controllers
output [31:0] EbiTrExtAddrOut;  // Address output to the pads
output [31:0] EbiTrExtDataOut;  // Data output to the pads
output  [3:0] nEbiTrExtDataEn;  // Data Enable to the pads




// Inputs
  wire        EBICLK;           // External Bus Interface Clock
  wire        nPOR;             // Power On Reset
  wire        EBIREQ1;          // EBI request for Port 1, Active high
  wire        EBIREQ2;          // EBI request for Port 2, Active high
  wire        EBIREQ3;          // EBI request for Port 3, Active high
  wire [31:0] EBIADDR1;         // EBI Address for Port 1
  wire [31:0] EBIADDR2;         // EBI Address for Port 2
  wire [31:0] EBIADDR3;         // EBI Address for Port 3
  wire  [3:0] nEBIDATAEN1;      // EBI Data Enable for port 1
  wire  [3:0] nEBIDATAEN2;      // EBI Data Enable for port 2
  wire  [3:0] nEBIDATAEN3;      // EBI Data Enable for port 3
  wire [31:0] EBIDATA1;         // EBI Data for Port 1
  wire [31:0] EBIDATA2;         // EBI Data for Port 2
  wire [31:0] EBIDATA3;         // EBI Data for Port 3
  wire [31:0] EBIEXTDATAIN;     // External Data input from the pads
  wire  [9:0] EBITIMEOUTVALUE1; // Gives the value to be loaded into
                                // timeout counter for port 1.
  wire  [9:0] EBITIMEOUTVALUE2; // Gives the value to be loaded into
                                // timeout counter for port 2.
  wire  [9:0] EBITIMEOUTVALUE3; // Gives the value to be loaded into
                                // timeout counter for port 3.



// Outputs
  wire        EbiTrGnt1;        // EBI Grant for port 1
  wire        EbiTrGnt2;        // EBI Grant for port 2
  wire        EbiTrGnt3;        // EBI Grant for port 3
  wire        EbiTrBackoff1;    // EBIBACKOFF signal for port 1
                                // Indicates to Controller-1 that the
                                // current transfer should be completed
                                // as soon as possible.
  wire        EbiTrBackoff2;    // EBIBACKOFF signal for port 2
                                // Indicates to Controller-2 that the
                                // current transfer should be completed
                                // as soon as possible.
  wire        EbiTrBackoff3;    // EBIBACKOFF signal for port 3
                                // Indicates to Controller-3 that the
                                // current transfer should be completed
                                // as soon as possible.
  wire [31:0] EbiTrDataIn;      // Data input connected to all the
                                // Controllers
  wire [31:0] EbiTrExtAddrOut;  // Address output to the pads
  wire [31:0] EbiTrExtDataOut;  // Data output to the pads
  wire  [3:0] nEbiTrExtDataEn;  // Data Enable to the pads


// -----------------------------------------------------------------------------
//
//                                 EbiTrMirEbi
//                                 ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// o EbiTrMirEbi block
//     This module is top level file for EBI Mirror Trick box.
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire [2:0] iEbiGnt;
// Internal Signal for Port Mapping

wire [2:0] iEbiBackoff;
// Internal Signal for Port Mapping

// -----------------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------

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
// Assigning Local Copies to the OutPut Grant Signal.
// -----------------------------------------------------------------------------
assign EbiTrGnt1        = iEbiGnt[0];
assign EbiTrGnt2        = iEbiGnt[1];
assign EbiTrGnt3        = iEbiGnt[2];
assign EbiTrBackoff3    = iEbiBackoff[2];
assign EbiTrBackoff2    = iEbiBackoff[1];
assign EbiTrBackoff1    = iEbiBackoff[0];

// -----------------------------------------------------------------------------
// Port mapping of Ebi Arbitration and Control Block.
// -----------------------------------------------------------------------------
EbiTrArbtCtl uEbiTrArbtCtl (
        .EBICLK          (EBICLK),
        .nPOR            (nPOR),
        .EBIREQ1         (EBIREQ1),
        .EBIREQ2         (EBIREQ2),
        .EBIREQ3         (EBIREQ3),
        .EBITIMEOUTVALUE1(EBITIMEOUTVALUE1),
        .EBITIMEOUTVALUE2(EBITIMEOUTVALUE2),
        .EBITIMEOUTVALUE3(EBITIMEOUTVALUE3),
        .EbiTrBackoff    (iEbiBackoff),
        .EbiTrGnt        (iEbiGnt)
           );
// -----------------------------------------------------------------------------
// Port mapping of Ebi Multiplexing Block.
// -----------------------------------------------------------------------------
EbiTrMultBlk uEbiTrMultBlk (
        .EBICLK          (EBICLK),
        .nPOR            (nPOR),
        .EbiTrGnt        (iEbiGnt),
        .EBIADDR1        (EBIADDR1),
        .EBIADDR2        (EBIADDR2),
        .EBIADDR3        (EBIADDR3),
        .nEBIDATAEN1     (nEBIDATAEN1),
        .nEBIDATAEN2     (nEBIDATAEN2),
        .nEBIDATAEN3     (nEBIDATAEN3),
        .EBIDATA1        (EBIDATA1),
        .EBIDATA2        (EBIDATA2),
        .EBIDATA3        (EBIDATA3),
        .EBIEXTDATAIN    (EBIEXTDATAIN),
        .EbiTrDataIn     (EbiTrDataIn),
        .EbiTrExtAddrOut (EbiTrExtAddrOut),
        .EbiTrExtDataOut (EbiTrExtDataOut),
        .nEbiTrExtDataEn (nEbiTrExtDataEn)
           );

endmodule
// --================================== End ==================================--
