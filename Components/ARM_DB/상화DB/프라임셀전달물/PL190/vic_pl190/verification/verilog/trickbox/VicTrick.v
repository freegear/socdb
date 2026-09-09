// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : VicTrick.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL190-REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           Top level of the VIC Trickbox.
//
// --=================================================================--

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module VicTrick (
// Inputs
                 HCLK,
                 HRESETn,
                 HREADYIN,
                 HADDR,
                 HTRANS,
                 HSIZE,
                 HWRITE,
                 HPROT,
                 HWDATA,
                 HSELVICTR,
                 HSELVIC,
                 nVICFIQ,
                 nVICIRQ,
                 VICVECTADDROUT,

// Outputs
                 HRDATA,
                 HREADYOUT,
                 HRESP,
                 VICINTSOURCE,
                 VICVECTADDRIN,
                 nVICFIQIN,
                 nVICIRQIN
                );

parameter Tclk = 10;

// Inputs
input         HCLK;           // AHB Clock
input         HRESETn;        // AHB Reset
input         HREADYIN;       // Transfer Ready Signal
input  [11:2] HADDR;          // Address Bus for AHB Slave
input         HTRANS;         // Transfer signal for AHB Slave
input   [2:0] HSIZE;          // AHB Transfer size
input         HWRITE;         // Write Signal for AHB Slave
input         HPROT;          // Protection Control signal
input  [31:0] HWDATA;         // Write Data input for AHB Slave
input         HSELVICTR;      // Slave Select Signal for
                              // the VIC Trickbox
input         HSELVIC;        // Slave Select Signal for the VIC
input         nVICFIQ;        // nVICFIQ output from the VIC
input         nVICIRQ;        // nVICIRQ output from the VIC
input  [31:0] VICVECTADDROUT; // VICVECTADDROUT output from the VIC

// Outputs
output [31:0] HRDATA;         // Read Data output from AHB Slave
output        HREADYOUT;      // Ready Signal from AHB Slave
output  [1:0] HRESP;          // Transfer Response from AHB Slave
output [31:0] VICINTSOURCE;   // Output lines for raising
                              // Interrupt requests to the VIC
output [31:0] VICVECTADDRIN;  // VICVECTADDRIN Daisy chain Vector
                              // address signal to the VIC
output        nVICFIQIN;      // nVICFIQIN Daisy chain
                              // signal to the VIC
output        nVICIRQIN;      // nVICIRQIN Daisy chain
                              // signal to the VIC
// Inputs
wire         HCLK;            // AHB Clock
wire         HRESETn;         // AHB Reset
wire         HREADYIN;        // Transfer Ready Signal
wire  [11:2] HADDR;           // Address Bus for AHB Slave
wire         HTRANS;          // Transfer signal for AHB Slave
wire   [2:0] HSIZE;           // AHB Transfer size
wire         HWRITE;          // Write Signal for AHB Slave
wire         HPROT;           // Protection Control signal
wire  [31:0] HWDATA;          // Write Data input for AHB Slave
wire         HSELVICTR;       // Slave Select Signal for
                              // the VIC Trickbox
wire         HSELVIC;         // Slave Select Signal for the VIC
wire         nVICFIQ;         // nVICFIQ output from the VIC
wire         nVICIRQ;         // nVICIRQ output from the VIC
wire  [31:0] VICVECTADDROUT;  // VICVECTADDROUT output from the VIC
 
// Outputs
wire [31:0] HRDATA;           // Read Data output from AHB Slave
wire        HREADYOUT;        // Ready Signal from AHB Slave
wire  [1:0] HRESP;            // Transfer Response from AHB Slave
wire [31:0] VICINTSOURCE;     // Output lines for raising
                              // Interrupt requests to the VIC
wire [31:0] VICVECTADDRIN;    // VICVECTADDRIN Daisy chain Vector
                              // address signal to the VIC
wire        nVICFIQIN;        // nVICFIQIN Daisy chain
                              // signal to the VIC
wire        nVICIRQIN;        // nVICIRQIN Daisy chain
                              // signal to the VIC

// ---------------------------------------------------------------------
//
//                              VicTrick
//                              ========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This block is the top level of the VIC Trickbox. This block
// instantiates the following sub-blocks:
//
// 1. VicTrAhbif
// 2. VicTrIntReq
// 3. VicTrVectBank
// 4. VicTrProtChkr
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------
 
//----------------------------------------------------------------------
// Timing Parameters of Trickbox
//----------------------------------------------------------------------
`define tovminintsrc     (0.0 * Tclk)
// VICINTSOURCE valid time (min) after HCLK rising edge
 
`define tovmaxintsrc     (0.05 * Tclk)
// VICINTSOURCE valid time (max) after HCLK rising edge
 
`define tovminnvicfiqin  (0.0 * Tclk)
// nVICFIQIN valid time (min) after HCLK rising edge
 
`define tovmaxnvicfiqin  (0.2 * Tclk)
// nVICFIQIN valid time (max) after HCLK rising edge
 
`define tovminnvicirqin  (0.0 * Tclk)
// nVICIRQIN valid time (min) after HCLK rising edge
 
`define tovmaxnvicirqin  (0.2 * Tclk)
// nVICIRQIN valid time (max) after HCLK rising edge
 
`define tovminvectadin   (0.0 * Tclk)
// VICVECTADDRIN valid time (min) after HCLK rising edge
 
`define tovmaxvectadin   (0.2 * Tclk)
// VICVECTADDRIN valid time (max) after HCLK rising edge
 
// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire [31:0] VICTrVectAddrOut;
// VectAddrOut from the internal mirrored model
 
wire        SetCSRBit;
// Current Service Register Set enable signal
 
wire        ClearCSRBit;
// Current Service Register Clear enable signal
 
wire [31:0] VICTrSoftInt;
// SoftInt register
 
wire [31:0] VICTrIntEnable;
// IntEnable register
 
wire [31:0] VICTrIntSelect;
// IntSelect register
 
wire [31:0] VICTrDefVectAddr;
// Default Vector Address register
 
wire [31:0] VICTrVectAddr0;
// VectorAddress 0 register
 
wire [31:0] VICTrVectAddr1;
// VectorAddress 1 register
 
wire [31:0] VICTrVectAddr2;
// VectorAddress 2 register
 
wire [31:0] VICTrVectAddr3;
// VectorAddress 3 register
 
wire [31:0] VICTrVectAddr4;
// VectorAddress 4 register
 
wire [31:0] VICTrVectAddr5;
// VectorAddress 5 rester
 
wire [31:0] VICTrVectAddr6;
// VectorAddress 6 register
 
wire [31:0] VICTrVectAddr7;
// VectorAddress 7 register
 
wire [31:0] VICTrVectAddr8;
// VectorAddress 8 register
 
wire [31:0] VICTrVectAddr9;
// VectorAddress 9 register
 
wire [31:0] VICTrVectAddr10;
// VectorAddress 10 register
 
wire [31:0] VICTrVectAddr11;
// VectorAddress 11 register
 
wire [31:0] VICTrVectAddr12;
// VectorAddress 12 register
 
wire [31:0] VICTrVectAddr13;
// VectorAddress 13 register
 
wire [31:0] VICTrVectAddr14;
// VectorAddress 14 register
 
wire [31:0] VICTrVectAddr15;
// VectorAddress 15 register
 
wire  [5:0] VICTrVectCntl0;
// Vector Control 0 register
 
wire  [5:0] VICTrVectCntl1;
// Vector Control 1 register
 
wire  [5:0] VICTrVectCntl2;
// Vector Control 2 register
 
wire  [5:0] VICTrVectCntl3;
// Vector Control 3 register
 
wire  [5:0] VICTrVectCntl4;
// Vector Control 4 register
 
wire  [5:0] VICTrVectCntl5;
// Vector Control 5 register
 
wire  [5:0] VICTrVectCntl6;
// Vector Control 6 register
 
wire  [5:0] VICTrVectCntl7;
// Vector Control 7 register
 
wire  [5:0] VICTrVectCntl8;
// Vector Control 8 register
 
wire  [5:0] VICTrVectCntl9;
// Vector Control 9 register
 
wire  [5:0] VICTrVectCntl10;
// Vector Control 10 register
 
wire  [5:0] VICTrVectCntl11;
// Vector Control 11 register
 
wire  [5:0] VICTrVectCntl12;
// Vector Control 12 register
 
wire  [5:0] VICTrVectCntl13;
// Vector Control 13 register
 
wire  [5:0] VICTrVectCntl14;
// Vector Control 14 register
 
wire  [5:0] VICTrVectCntl15;
// Vector Control 15 register
 
wire [31:0] VICTrIntSource;
// Interrupt source register
 
wire [31:0] VICTrFIQStatus;
// FIQ Status register
 
wire [31:0] VICTrIRQStatus;
// IRQ Status register
 
wire [31:0] VICTrVectAddrIn;
// Vector AddressIn register
 
wire        nFIQ;
// nFIQ from Mirrored VIC model
 
wire        nIRQ;
// nIRQ from Mirrored VIC model
 
wire        nVICTrFIQIn;
// nVICFIQIN Daisy chain signal
 
wire        nVICTrIRQIn;
// nVICIRQIN Daisy chain signal
 
wire  [2:0] VICTrTCR;
// Error Message Enabling signal
 
wire [31:0] VICTrIRQStatSync;
// Double synchronised IRQ Status register
 
// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

defparam uVicTrAhbif.tovminintsrc     = `tovminintsrc;
defparam uVicTrAhbif.tovmaxintsrc     = `tovmaxintsrc;
defparam uVicTrAhbif.tovminnvicfiqin  = `tovminnvicfiqin;
defparam uVicTrAhbif.tovmaxnvicfiqin  = `tovmaxnvicfiqin;
defparam uVicTrAhbif.tovminnvicirqin  = `tovminnvicirqin;
defparam uVicTrAhbif.tovmaxnvicirqin  = `tovmaxnvicirqin;
defparam uVicTrAhbif.tovminvectadin   = `tovminvectadin;
defparam uVicTrAhbif.tovmaxvectadin   = `tovmaxvectadin;
 
// ---------------------------------------------------------------------
// Instantiation of Trickbox-AHB Interface Block
// ---------------------------------------------------------------------
VicTrAhbif uVicTrAhbif                (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HREADYIN         (HREADYIN),
                    .HADDR            (HADDR),
                    .HTRANS           (HTRANS),
                    .HSIZE            (HSIZE),
                    .HWRITE           (HWRITE),
                    .HPROT            (HPROT),
                    .HWDATA           (HWDATA),
                    .HSELVICTR        (HSELVICTR),
                    .HSELVIC          (HSELVIC),
                    .VICTrVectAddr    (VICTrVectAddrOut),
                    .nVICFIQ          (nVICFIQ),
                    .nVICIRQ          (nVICIRQ),
                    .VICVECTADDROUT   (VICVECTADDROUT),
                    .HRDATA           (HRDATA),
                    .HREADYOUT        (HREADYOUT),
                    .VICTrTCR         (VICTrTCR),
                    .HRESP            (HRESP),
                    .VICINTSOURCE     (VICTrIntSource),
                    .VICVECTADDRIN    (VICTrVectAddrIn),
                    .nVICFIQIN        (nVICTrFIQIn),
                    .nVICIRQIN        (nVICTrIRQIn),
                    .SetCSRBit        (SetCSRBit),
                    .ClearCSRBit      (ClearCSRBit),
                    .VICTrSoftInt     (VICTrSoftInt),
                    .VICTrIntEnable   (VICTrIntEnable),
                    .VICTrIntSelect   (VICTrIntSelect),
                    .VICTrDefVectAddr (VICTrDefVectAddr),
                    .VICTrVectAddr0   (VICTrVectAddr0),
                    .VICTrVectAddr1   (VICTrVectAddr1),
                    .VICTrVectAddr2   (VICTrVectAddr2),
                    .VICTrVectAddr3   (VICTrVectAddr3),
                    .VICTrVectAddr4   (VICTrVectAddr4),
                    .VICTrVectAddr5   (VICTrVectAddr5),
                    .VICTrVectAddr6   (VICTrVectAddr6),
                    .VICTrVectAddr7   (VICTrVectAddr7),
                    .VICTrVectAddr8   (VICTrVectAddr8),
                    .VICTrVectAddr9   (VICTrVectAddr9),
                    .VICTrVectAddr10  (VICTrVectAddr10),
                    .VICTrVectAddr11  (VICTrVectAddr11),
                    .VICTrVectAddr12  (VICTrVectAddr12),
                    .VICTrVectAddr13  (VICTrVectAddr13),
                    .VICTrVectAddr14  (VICTrVectAddr14),
                    .VICTrVectAddr15  (VICTrVectAddr15),
                    .VICTrVectCntl0   (VICTrVectCntl0),
                    .VICTrVectCntl1   (VICTrVectCntl1),
                    .VICTrVectCntl2   (VICTrVectCntl2),
                    .VICTrVectCntl3   (VICTrVectCntl3),
                    .VICTrVectCntl4   (VICTrVectCntl4),
                    .VICTrVectCntl5   (VICTrVectCntl5),
                    .VICTrVectCntl6   (VICTrVectCntl6),
                    .VICTrVectCntl7   (VICTrVectCntl7),
                    .VICTrVectCntl8   (VICTrVectCntl8),
                    .VICTrVectCntl9   (VICTrVectCntl9),
                    .VICTrVectCntl10  (VICTrVectCntl10),
                    .VICTrVectCntl11  (VICTrVectCntl11),
                    .VICTrVectCntl12  (VICTrVectCntl12),
                    .VICTrVectCntl13  (VICTrVectCntl13),
                    .VICTrVectCntl14  (VICTrVectCntl14),
                    .VICTrVectCntl15  (VICTrVectCntl15)
                    );
 
// ---------------------------------------------------------------------
// Instantiation of FIQ/IRQ Status Generator
// ---------------------------------------------------------------------
VicTrIntReq uVicTrIntReq              (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VICTrIntSource   (VICTrIntSource),
                    .VICTrSoftInt     (VICTrSoftInt),
                    .VICTrIntEnable   (VICTrIntEnable),
                    .VICTrIntSelect   (VICTrIntSelect),
                    .VICTrFIQStatus   (VICTrFIQStatus),
                    .VICTrIRQStatus   (VICTrIRQStatus),
                    .VICTrIRQStatSync (VICTrIRQStatSync)
                    );
 
// ---------------------------------------------------------------------
// Instantiation of IRQ Priority Resolver Block
// ---------------------------------------------------------------------
VicTrVectBank uVicTrVectBank          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VICTrFIQStatus   (VICTrFIQStatus),
                    .VICTrIRQStatus   (VICTrIRQStatus),
                    .VICTrIRQStatSync (VICTrIRQStatSync),
                    .nVICTrFIQIn      (nVICTrFIQIn),
                    .nVICTrIRQIn      (nVICTrIRQIn),
                    .SetCSRBit        (SetCSRBit),
                    .ClearCSRBit      (ClearCSRBit),
                    .VICTrVectAddrIn  (VICTrVectAddrIn),
                    .VICTrDefVectAddr (VICTrDefVectAddr),
                    .VICTrVectAddr0   (VICTrVectAddr0),
                    .VICTrVectAddr1   (VICTrVectAddr1),
                    .VICTrVectAddr2   (VICTrVectAddr2),
                    .VICTrVectAddr3   (VICTrVectAddr3),
                    .VICTrVectAddr4   (VICTrVectAddr4),
                    .VICTrVectAddr5   (VICTrVectAddr5),
                    .VICTrVectAddr6   (VICTrVectAddr6),
                    .VICTrVectAddr7   (VICTrVectAddr7),
                    .VICTrVectAddr8   (VICTrVectAddr8),
                    .VICTrVectAddr9   (VICTrVectAddr9),
                    .VICTrVectAddr10  (VICTrVectAddr10),
                    .VICTrVectAddr11  (VICTrVectAddr11),
                    .VICTrVectAddr12  (VICTrVectAddr12),
                    .VICTrVectAddr13  (VICTrVectAddr13),
                    .VICTrVectAddr14  (VICTrVectAddr14),
                    .VICTrVectAddr15  (VICTrVectAddr15),
                    .VICTrVectCntl0   (VICTrVectCntl0),
                    .VICTrVectCntl1   (VICTrVectCntl1),
                    .VICTrVectCntl2   (VICTrVectCntl2),
                    .VICTrVectCntl3   (VICTrVectCntl3),
                    .VICTrVectCntl4   (VICTrVectCntl4),
                    .VICTrVectCntl5   (VICTrVectCntl5),
                    .VICTrVectCntl6   (VICTrVectCntl6),
                    .VICTrVectCntl7   (VICTrVectCntl7),
                    .VICTrVectCntl8   (VICTrVectCntl8),
                    .VICTrVectCntl9   (VICTrVectCntl9),
                    .VICTrVectCntl10  (VICTrVectCntl10),
                    .VICTrVectCntl11  (VICTrVectCntl11),
                    .VICTrVectCntl12  (VICTrVectCntl12),
                    .VICTrVectCntl13  (VICTrVectCntl13),
                    .VICTrVectCntl14  (VICTrVectCntl14),
                    .VICTrVectCntl15  (VICTrVectCntl15),
                    .nFIQ             (nFIQ),
                    .nIRQ             (nIRQ),
                    .VICTrVectAddrOut (VICTrVectAddrOut)
                    );

// ---------------------------------------------------------------------
// Instantiation of output comparator
// ---------------------------------------------------------------------
VicTrProtChkr uVicTrProtChkr          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VICTrTCR         (VICTrTCR),
                    .nVICFIQ          (nVICFIQ),
                    .nFIQ             (nFIQ),
                    .nVICIRQ          (nVICIRQ),
                    .nIRQ             (nIRQ),
                    .VICVECTADDROUT   (VICVECTADDROUT),
                    .VICTrVectAddrOut (VICTrVectAddrOut)
                    );
 
// ---------------------------------------------------------------------
// Assigns output signals of the VIC Trickbox
// ---------------------------------------------------------------------
assign nVICFIQIN        = nVICTrFIQIn;
assign nVICIRQIN        = nVICTrIRQIn;
assign VICINTSOURCE     = VICTrIntSource;
assign VICVECTADDRIN    = VICTrVectAddrIn;

endmodule

// --======================== End ====================================--
