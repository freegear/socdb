// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SmcTrick.v.rca
// File Revision          : 1.14
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module is the top level SMC Trickbox
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SmcTrick (
// Inputs
                 HCLK,
                 HRESETn,
                 HADDR,
                 HTRANS,
                 HWRITE,
                 HSIZE,
                 HREADYIN,
                 HWDATA,
                 HSELSMCTR,

                 SMDATAOUT,
                 SMADDR,
                 SMCS,
                 nSMDATAEN,
                 nSMWEN,
                 nSMBLS,
                 nSMOEN,
                 SMCActLowCS,
                 MCBUSGNT,
                 SMBUSREQ,

// Outputs
                 HRDATA,
                 HREADYOUT,
                 HRESP,
                 ENDIANCNT,
                 REMAP,

                 SMMWCS7,

                 SMWAIT,
                 nSMWAIT,
                 CANCELSMWAIT,

                 MCBUSREQ,
                 MCADDR,
                 MCDATAOUT,
                 MCDATAEN,
                 SMBUSGNT,
                 EXTBUSMUX
                );

parameter Tclk = 10.56;        // HCLK Period

// Inputs
input         HCLK;         // AHB Bus Clock
input         HRESETn;      // Bus Reset
input   [6:2] HADDR;        // AHB Address Bus
input   [1:0] HTRANS;       // Transfer type
input         HWRITE;       // AHB Peripheral Write
input   [2:0] HSIZE;        // Transfer size
input         HREADYIN;     // Multiplexed version of HREADY outputs
input  [31:0] HWDATA;       // AHB Write Data bus
input         HSELSMCTR;    // AHB Peripheral (Trickbox) Select


input  [31:0] SMDATAOUT;    // SMC Data Out Bus to Memory
input  [25:0] SMADDR;       // Memory Address Bus
input   [7:0] SMCS;         // Memory chip select lines
input   [3:0] nSMDATAEN;    // Memory Data Bus Enable lines
input         nSMWEN;       // Memory Write Enable
input   [3:0] nSMBLS;       // Memory Data Bus Lane Enable
input         nSMOEN;       // Memory Output Enable
input   [7:0] SMCActLowCS;  // Active low Memory Bank Select
input         MCBUSGNT;     // MCBUS Grant
input         SMBUSREQ;     // SMBUS request 



// Outputs
output [31:0] HRDATA;       // AHB Read Data bus
output        HREADYOUT;    // Slave HREADY output
output  [1:0] HRESP;        // Slave response
output        ENDIANCNT;    // Endianness of the System
output        REMAP;        // Reset/Normal Memory map select


output  [1:0] SMMWCS7;      // Boot Memory Bank Width


output        SMWAIT;       // External Wait signal routed to the SMC
output        nSMWAIT;      // External Wait signal routed to the SMC
output        CANCELSMWAIT; // External Wait time-out signal


output        MCBUSREQ;     // MCBUS Access Request signal
output [25:0] MCADDR;       // MCBUS Address signals
output [31:0] MCDATAOUT;    // MCBUS Data Out signals
output  [3:0] MCDATAEN;     // MCBUS Data Enable lines
output        SMBUSGNT;     // SMBUS Grant
output        EXTBUSMUX;



// Inputs
  wire        HCLK;         // AHB Bus Clock
  wire        HRESETn;      // Bus Reset
  wire  [6:2] HADDR;        // AHB Address Bus
  wire  [1:0] HTRANS;       // Transfer type
  wire        HWRITE;       // AHB Peripheral Write
  wire  [2:0] HSIZE;        // Transfer size
  wire        HREADYIN;     // Multiplexed version of HREADY outputs
  wire [31:0] HWDATA;       // AHB Write Data bus
  wire        HSELSMCTR;    // AHB Peripheral (Trickbox) Select


  wire [31:0] SMDATAOUT;    // SMC Data Out Bus to Memory
  wire [25:0] SMADDR;       // Memory Address Bus
  wire  [7:0] SMCS;         // Memory chip select lines
  wire  [3:0] nSMDATAEN;    // Memory Data Bus Enable lines
  wire        nSMWEN;       // Memory Write Enable
  wire  [3:0] nSMBLS;       // Memory Data Bus Lane Enable
  wire        nSMOEN;       // Memory Output Enable
  wire  [7:0] SMCActLowCS;  // Active low Memory Bank Select
  wire        MCBUSGNT;     // MCBUS Grant
  wire        SMBUSREQ;     // SMBUS request 



// Outputs
  wire [31:0] HRDATA;       // AHB Read Data bus
  wire        HREADYOUT;    // Slave HREADY output
  wire  [1:0] HRESP;        // Slave response
  wire        ENDIANCNT;    // Endianness of the System
  wire        REMAP;        // Reset/Normal Memory map select


  wire  [1:0] SMMWCS7;      // Boot Memory Bank Width


  wire        SMWAIT;       // External Wait signal routed to the SMC
  wire        nSMWAIT;       // External Wait signal routed to the SMC
  wire        CANCELSMWAIT; // External Wait time-out signal


  wire        MCBUSREQ;     // MCBUS Access Request signal
  wire [25:0] MCADDR;       // MCBUS Address signals
  wire [31:0] MCDATAOUT;    // MCBUS Data Out signals
  wire  [3:0] MCDATAEN;     // MCBUS Data Enable lines
  wire        SMBUSGNT;     // SMBUS Grant
  wire        EXTBUSMUX;


// -----------------------------------------------------------------------------
//
//                                  SmcTrick
//                                  ========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block is the top level of the SMC Trickbox Memory Model. This block
// instantiates the following sub-blocks:
//
// 1. SmcTrAhbifReg - AHB Interface and Register Block
// 2. SmcTrProtChkr - SMC Protocol Checker
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [25:0] SMCTrCS2WTR0;
// SMCTrCS2WT Register for Bank 0

wire [23:0] SMCTrCEWTR0;
// SMCTrCEWT Register for Bank 0

wire [25:0] SMCTrCS2WTR1;
// SMCTrCS2WT Register for Bank 1

wire [23:0] SMCTrCEWTR1;
// SMCTrCEWT Register for Bank 1

wire [25:0] SMCTrCS2WTR2;
// SMCTrCS2WT Register for Bank 2

wire [23:0] SMCTrCEWTR2;
// SMCTrCEWT Register for Bank 2

wire [25:0] SMCTrCS2WTR3;
// SMCTrCS2WT Register for Bank 3

wire [23:0] SMCTrCEWTR3;
// SMCTrCEWT Register for Bank 3

wire [25:0] SMCTrCS2WTR4;
// SMCTrCS2WT Register for Bank 4

wire [23:0] SMCTrCEWTR4;
// SMCTrCEWT Register for Bank 4

wire [25:0] SMCTrCS2WTR5;
// SMCTrCS2WT Register for Bank 5

wire [23:0] SMCTrCEWTR5;
// SMCTrCEWT Register for Bank 5

wire [25:0] SMCTrCS2WTR6;
// SMCTrCS2WT Register for Bank 6

wire [23:0] SMCTrCEWTR6;
// SMCTrCEWT Register for Bank 6

wire [25:0] SMCTrCS2WTR7;
// SMCTrCS2WT Register for Bank 7

wire [23:0] SMCTrCEWTR7;
// SMCTrCEWT Register for Bank 7

wire  [4:0] SMCTrMCREQD;
// SMCTrMCREQD Register

wire  [4:0] SMCTrGNT2RMREQ;
// SMCTrGNT2RMREQ Register

wire [25:0] SMCTrMCADDR;
// SMCTrMCADDR Register

wire [31:0] SMCTrMCDATAOUT;
// SMCTrMCDATAOUT Register

wire [5:0] SMCTrCNCLWAIT;
// SMCTrCNCLWAIT Register

wire        SMCTrMCBUSRRd;
// SMCTrMCBUSR Read

wire        SMCTrMCBUSRWr;
// SMCTrMCBUSR Write

wire        SMCTrCNCLWAITRd;

wire        SMCTrCNCLWAITWr;

wire [11:0] SMCTrEBICntl;

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
// The SMC Trickbox AHB Interface Instantiation
// -----------------------------------------------------------------------------
SmcTrAhbifReg uSmcTrAhbifReg          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HREADYIN         (HREADYIN),
                    .HWDATA           (HWDATA),
                    .HSELSMCTR        (HSELSMCTR),
                    .HRDATA           (HRDATA),
                    .HREADYOUT        (HREADYOUT),
                    .HRESP            (HRESP),
                    .ENDIANCNT        (ENDIANCNT),
                    .REMAP            (REMAP),
                    .SMMWCS7          (SMMWCS7),
                    .SMCTrCS2WTR0     (SMCTrCS2WTR0),
                    .SMCTrCEWTR0      (SMCTrCEWTR0),
                    .SMCTrCS2WTR1     (SMCTrCS2WTR1),
                    .SMCTrCEWTR1      (SMCTrCEWTR1),
                    .SMCTrCS2WTR2     (SMCTrCS2WTR2),
                    .SMCTrCEWTR2      (SMCTrCEWTR2),
                    .SMCTrCS2WTR3     (SMCTrCS2WTR3),
                    .SMCTrCEWTR3      (SMCTrCEWTR3),
                    .SMCTrCS2WTR4     (SMCTrCS2WTR4),
                    .SMCTrCEWTR4      (SMCTrCEWTR4),
                    .SMCTrCS2WTR5     (SMCTrCS2WTR5),
                    .SMCTrCEWTR5      (SMCTrCEWTR5),
                    .SMCTrCS2WTR6     (SMCTrCS2WTR6),
                    .SMCTrCEWTR6      (SMCTrCEWTR6),
                    .SMCTrCS2WTR7     (SMCTrCS2WTR7),
                    .SMCTrCEWTR7      (SMCTrCEWTR7),
                    .SMCTrMCREQD      (SMCTrMCREQD),
                    .SMCTrGNT2RMREQ   (SMCTrGNT2RMREQ),
                    .SMCTrMCADDR      (SMCTrMCADDR),
                    .SMCTrMCDATAOUT   (SMCTrMCDATAOUT),
                    .SMCTrMCBUSRRd    (SMCTrMCBUSRRd),
                    .SMCTrCNCLWAIT    (SMCTrCNCLWAIT),
                    .SMCTrEBICntl     (SMCTrEBICntl),
                    .SMCTrCNCLWAITRd  (SMCTrCNCLWAITRd),
                    .SMCTrCNCLWAITWr  (SMCTrCNCLWAITWr),
                    .SMCTrMCBUSRWr    (SMCTrMCBUSRWr)
                    );

// -----------------------------------------------------------------------------
// The SMC Protocol Checker module Instantiation
// -----------------------------------------------------------------------------
SmcTrProtChkr uSmcTrProtChkr          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .SMDATAOUT        (SMDATAOUT),
                    .SMADDR           (SMADDR),
                    .SMCActLowCS      (SMCActLowCS),
                    .SMCS             (SMCS),
                    .nSMDATAEN        (nSMDATAEN),
                    .nSMWEN           (nSMWEN),
                    .nSMBLS           (nSMBLS),
                    .nSMOEN           (nSMOEN)
                    );

// -----------------------------------------------------------------------------
// The SMC SMWAIT Control Logic Instantiation
// -----------------------------------------------------------------------------
defparam uSmcTrWaitCntl.Tclk = Tclk;

SmcTrWaitCntl uSmcTrWaitCntl          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .SMCActLowCS      (SMCActLowCS),
                    .SMADDR           (SMADDR),
                    .SMCTrCS2WTR0     (SMCTrCS2WTR0),
                    .SMCTrCEWTR0      (SMCTrCEWTR0),
                    .SMCTrCS2WTR1     (SMCTrCS2WTR1),
                    .SMCTrCEWTR1      (SMCTrCEWTR1),
                    .SMCTrCS2WTR2     (SMCTrCS2WTR2),
                    .SMCTrCEWTR2      (SMCTrCEWTR2),
                    .SMCTrCS2WTR3     (SMCTrCS2WTR3),
                    .SMCTrCEWTR3      (SMCTrCEWTR3),
                    .SMCTrCS2WTR4     (SMCTrCS2WTR4),
                    .SMCTrCEWTR4      (SMCTrCEWTR4),
                    .SMCTrCS2WTR5     (SMCTrCS2WTR5),
                    .SMCTrCEWTR5      (SMCTrCEWTR5),
                    .SMCTrCS2WTR6     (SMCTrCS2WTR6),
                    .SMCTrCEWTR6      (SMCTrCEWTR6),
                    .SMCTrCS2WTR7     (SMCTrCS2WTR7),
                    .SMCTrCEWTR7      (SMCTrCEWTR7),
                    .SMWAIT           (SMWAIT),
                    .nSMWAIT          (nSMWAIT),
                    .SMCTrCNCLWAIT    (SMCTrCNCLWAIT),
                    .CANCELSMWAIT     (CANCELSMWAIT)
                    );

// -----------------------------------------------------------------------------
// The MCBUS Block Instantiation
// -----------------------------------------------------------------------------
defparam uSmcTrMCBusBlk.Tclk = Tclk;

SmcTrMCBusBlk uSmcTrMCBusBlk          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .SMADDR           (SMADDR),
                    .SMDATAOUT        (SMDATAOUT),
                    .nSMDATAEN        (nSMDATAEN),
                    .MCBUSGNT         (MCBUSGNT),
                    .SMCTrMCREQD      (SMCTrMCREQD),
                    .SMCTrGNT2RMREQ   (SMCTrGNT2RMREQ),
                    .SMCTrMCADDR      (SMCTrMCADDR),
                    .SMCTrMCDATAOUT   (SMCTrMCDATAOUT),
                    .SMCTrMCBUSRRd    (SMCTrMCBUSRRd),
                    .SMCTrMCBUSRWr    (SMCTrMCBUSRWr),
                    .SMCTrEBICntl     (SMCTrEBICntl),
                    .SMBUSREQ         (SMBUSREQ),
                    .SMBUSGNT         (SMBUSGNT),
                    .MCBUSREQ         (MCBUSREQ),
                    .MCADDR           (MCADDR),
                    .MCDATAOUT        (MCDATAOUT),
                    .MCDATAEN         (MCDATAEN)
                    );

// -----------------------------------------------------------------------------
// assigning local copies to output
// -----------------------------------------------------------------------------
assign EXTBUSMUX = SMCTrEBICntl[11];

endmodule
// --================================== End ==================================--
