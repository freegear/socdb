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
// File Name              : Ebi.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block is the top level of the EBI
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module Ebi (
// Inputs
            EBICLK,
            nPOR,
            EBIREQ1,
            EBIADDR1,
            EBIDATA1,
            nEBIDATAEN1,
            EBITIMEOUTVALUE1,
            EBIREQ2,
            EBIADDR2,
            EBIDATA2,
            nEBIDATAEN2,
            EBITIMEOUTVALUE2,
            EBIREQ3,
            EBIADDR3,
            EBIDATA3,
            nEBIDATAEN3,
            EBITIMEOUTVALUE3,
            EBIEXTDATAIN,
            // Scan test Signals
            SCANENABLE,
            SCANINEBICLK,

// Outputs
            EBIGNT1,
            EBIBACKOFF1,
            EBIGNT2,
            EBIBACKOFF2,
            EBIGNT3,
            EBIBACKOFF3,
            EBIEXTDATAOUT,
            EBIEXTADDROUT,
            nEBIEXTDATAEN,
            EBIDATAIN,
            // Scan test Signals
            SCANOUTEBICLK
           );

// Inputs
input         EBICLK;           // External Bus Interface Clock
input         nPOR;             // Power On Reset
input         EBIREQ1;          // EBI request for Port 1, Active high
input  [31:0] EBIADDR1;         // EBI Address for Port 1
input  [31:0] EBIDATA1;         // EBI Data for Port 1
input   [3:0] nEBIDATAEN1;      // EBI Data Enable for port 1
input   [9:0] EBITIMEOUTVALUE1; // Gives the value to be loaded into
                                // timeout counter for port 1.
input         EBIREQ2;          // EBI request for Port 2, Active high
input  [31:0] EBIADDR2;         // EBI Address for Port 2
input  [31:0] EBIDATA2;         // EBI Data for Port 2
input   [3:0] nEBIDATAEN2;      // EBI Data Enable for port 2
input   [9:0] EBITIMEOUTVALUE2; // Gives the value to be loaded into
                                // timeout counter for port 2.
input         EBIREQ3;          // EBI request for Port 3, Active high
input  [31:0] EBIADDR3;         // EBI Address for Port 2
input  [31:0] EBIDATA3;         // EBI Data for Port 2
input   [3:0] nEBIDATAEN3;      // EBI Data Enable for port 3
input   [9:0] EBITIMEOUTVALUE3; // Gives the value to be loaded into
                                // timeout counter for port 3.
input  [31:0] EBIEXTDATAIN;     // External Data input from the pads

// Scan test Signals
input         SCANENABLE;       // Scan enable signal
input         SCANINEBICLK;     // Scan input signal

// Outputs
output        EBIGNT1;          // EBI Grant for port 1
output        EBIBACKOFF1;      // EBIBACKOFF signal for port 1
                                // Indicates to Controller-1 that the
                                // current transfer should be completed
                                // as soon as possible.
output        EBIGNT2;          // EBI Grant for port 2
output        EBIBACKOFF2;      // EBIBACKOFF signal for port 2
                                // Indicates to Controller-2 that the
                                // current transfer should be completed
                                // as soon as possible.
output        EBIGNT3;          // EBI Grant for port 3
output        EBIBACKOFF3;      // EBIBACKOFF signal for port 3
                                // Indicates to Controller-3 that the
                                // current transfer should be completed
                                // as soon as possible.
output [31:0] EBIEXTDATAOUT;    // Data output to the pads
output [31:0] EBIEXTADDROUT;    // Address output to the pads
output  [3:0] nEBIEXTDATAEN;    // Data Enable to the pads
output [31:0] EBIDATAIN;        // Data input connected to all the
                                // Controllers

// Scan test Signals
output        SCANOUTEBICLK;    // Scan output signal

// Inputs
wire        EBICLK;             // External Bus Interface Clock
wire        nPOR;               // Power On Reset
wire        EBIREQ1;            // EBI request for Port 1, Active high
wire [31:0] EBIADDR1;           // EBI Address for Port 1
wire [31:0] EBIDATA1;           // EBI Data for Port 1
wire  [3:0] nEBIDATAEN1;        // EBI Data Enable for port 1
wire  [9:0] EBITIMEOUTVALUE1;   // Gives the value to be loaded into
                                // timeout counter for port 1.
wire        EBIREQ2;            // EBI request for Port 2, Active high
wire [31:0] EBIADDR2;           // EBI Address for Port 2
wire [31:0] EBIDATA2;           // EBI Data for Port 2
wire  [3:0] nEBIDATAEN2;        // EBI Data Enable for port 2
wire  [9:0] EBITIMEOUTVALUE2;   // Gives the value to be loaded into
                                // timeout counter for port 2.
wire        EBIREQ3;            // EBI request for Port 3, Active high
wire [31:0] EBIADDR3;           // EBI Address for Port 2
wire [31:0] EBIDATA3;           // EBI Data for Port 2
wire  [3:0] nEBIDATAEN3;        // EBI Data Enable for port 3
wire  [9:0] EBITIMEOUTVALUE3;   // Gives the value to be loaded into
                                // timeout counter for port 3.
wire [31:0] EBIEXTDATAIN;       // External Data input from the pads

// Scan test Signals
wire        SCANENABLE;         // Scan enable signal
wire        SCANINEBICLK;       // Scan input signal

// Outputs
wire        EBIGNT1;            // EBI Grant for port 1
wire        EBIBACKOFF1;        // EBIBACKOFF signal for port 1
                                // Indicates to Controller-1 that the
                                // current transfer should be completed
                                // as soon as possible.
wire        EBIGNT2;            // EBI Grant for port 2
wire        EBIBACKOFF2;        // EBIBACKOFF signal for port 2
                                // Indicates to Controller-2 that the
                                // current transfer should be completed
                                // as soon as possible.
wire        EBIGNT3;            // EBI Grant for port 3
wire        EBIBACKOFF3;        // EBIBACKOFF signal for port 3
                                // Indicates to Controller-3 that the
                                // current transfer should be completed
                                // as soon as possible.
wire [31:0] EBIEXTDATAOUT;      // Data output to the pads
wire [31:0] EBIEXTADDROUT;      // Address output to the pads
wire  [3:0] nEBIEXTDATAEN;      // Data Enable to the pads
wire [31:0] EBIDATAIN;          // Data input connected to all the
                                // Controllers

// Scan test Signals
wire        SCANOUTEBICLK;      // Scan output signal

// -----------------------------------------------------------------------------
//
//                                     Ebi
//                                     ===
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This block is the top level of the EBI. This block instantiates the
// following functional sub-blocks in the EBI.
// o EbiArbCntl
//     Control and Arbitration Block does the arbitration of the requests
//     coming from three controllers and gives EBIGNT to the highest priority
//     controller.
//     Each port has a 10 bit counter which will be loaded with a value from
//     the EBITIMEOUTVALUE[9:0] input whenever a request is made for the bus.
//     If the signal EBITIMEOUTVALUE[9:0] is zero then the counter will not be
//     started for the port. When the counter reaches 0 then the controller
//     currently granted the bus, will be requested to release the bus by
//     asserting the EBIBACKOFF signal. The first port counter to reach 0 will
//     be given the highest priority for the bus, followed by the second
//     device.  If more than one controller issues a request for the bus at
//     the same time then a round robin arbitration scheme will be used to
//     decide which controller should be granted the bus. When no device is
//     requesting the use of the bus then no controller gets the grant.
//     At reset controller-1 will be granted the bus.
//
// o EbiMux
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

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

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
// Instantiation of EbiArbCntl
// -----------------------------------------------------------------------------
EbiArbCntl uEbiArbCntl (
                        .EBICLK           (EBICLK),
                        .nPOR             (nPOR),
                        .EBIREQ1          (EBIREQ1),
                        .EBITIMEOUTVALUE1 (EBITIMEOUTVALUE1),
                        .EBIREQ2          (EBIREQ2),
                        .EBITIMEOUTVALUE2 (EBITIMEOUTVALUE2),
                        .EBIREQ3          (EBIREQ3),
                        .EBITIMEOUTVALUE3 (EBITIMEOUTVALUE3),
                        .EBIGNT1          (EBIGNT1),
                        .EBIBACKOFF1      (EBIBACKOFF1),
                        .EBIGNT2          (EBIGNT2),
                        .EBIBACKOFF2      (EBIBACKOFF2),
                        .EBIGNT3          (EBIGNT3),
                        .EBIBACKOFF3      (EBIBACKOFF3)
                       );

// -----------------------------------------------------------------------------
// Instantiation of EbiMux
// -----------------------------------------------------------------------------
EbiMux uEbiMux (
                .EBICLK           (EBICLK),
                .nPOR             (nPOR),
                .EBIGNT1          (EBIGNT1),
                .EBIADDR1         (EBIADDR1),
                .EBIDATA1         (EBIDATA1),
                .nEBIDATAEN1      (nEBIDATAEN1),
                .EBIGNT2          (EBIGNT2),
                .EBIADDR2         (EBIADDR2),
                .EBIDATA2         (EBIDATA2),
                .nEBIDATAEN2      (nEBIDATAEN2),
                .EBIGNT3          (EBIGNT3),
                .EBIADDR3         (EBIADDR3),
                .EBIDATA3         (EBIDATA3),
                .nEBIDATAEN3      (nEBIDATAEN3),
                .EBIEXTDATAIN     (EBIEXTDATAIN),
                .EBIEXTDATAOUT    (EBIEXTDATAOUT),
                .EBIEXTADDROUT    (EBIEXTADDROUT),
                .nEBIEXTDATAEN    (nEBIEXTDATAEN),
                .EBIDATAIN        (EBIDATAIN)
               );

endmodule
// --================================== End ==================================--
