// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SsmcTrick_denali.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL093-r0p1-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module is the top level SSMC Trickbox
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SsmcTrick (
// Inputs
                 HCLK,
                 HRESETn,
                 HADDR,
                 HTRANS,
                 HWRITE,
                 HSIZE,
                 HREADYINTr,
                 HWDATA,
                 HSELSSMCTr,

                 SMDATAOUT,
                 SMADDR,
                 SSMTrCS,
                 nSSMTrCS,
                 nSMDATAEN,
                 nSMWEN,
                 nSMBLS,
                 nSMOEN,
                 SMBUSREQEBI,
                 SMTICBUSREQEBI,

// Outputs
                 HRDATATr,
                 HREADYOUTTr,
                 HRESPTr,
                 BIGENDIAN,
                 SMEXTBUSMUX, 
                 SMMWCS7,
                 SMWAIT,
                 SMCANCELWAIT,
                 SMBUSGNTEBI,
                 SMBUSBACKOFFEBI,
                 SMTICBUSGNTEBI,
                 SMFBCLK,
                 SMMemCLK,
                 SMMemClkRatio,
                 SMBLS7POL
                );

parameter Tclk = 10.56;     // HCLK Period
parameter Tclkl = 10;       // HCLK low time
parameter Tclkh = 10;       // HCLK high time
parameter Tclks = 10;       // SMMemCLK start delay

// Inputs
input         HCLK;         // AHB Bus Clock
input         HRESETn;      // Bus Reset
input   [5:2] HADDR;        // AHB Address Bus
input   [1:0] HTRANS;       // Transfer type
input         HWRITE;       // AHB Peripheral Write
input   [2:0] HSIZE;        // Transfer size
input         HREADYINTr;   // Multiplexed version of HREADY outputs
input  [31:0] HWDATA;       // AHB Write Data bus
input         HSELSSMCTr;   // AHB Peripheral (Trickbox) Select


input  [31:0] SMDATAOUT;    // SMC Data Out Bus to Memory
input  [25:0] SMADDR;       // Memory Address Bus
input   [7:0] SSMTrCS;      // Memory chip select lines active high
input   [7:0] nSSMTrCS;     // Memory chip select lines active low 
input   [3:0] nSMDATAEN;    // Memory Data Bus Enable lines
input         nSMWEN;       // Memory Write Enable
input   [3:0] nSMBLS;       // Memory Data Bus Lane Enable
input         nSMOEN;       // Memory Output Enable
input         SMBUSREQEBI;  // SSMC request
input         SMTICBUSREQEBI;
                            // TIC request

// Outputs
output [31:0] HRDATATr;     // AHB Read Data bus
output        HREADYOUTTr;  // Slave HREADY output
output  [1:0] HRESPTr;      // Slave response
output        BIGENDIAN;    // Endianness of the System
output        SMEXTBUSMUX;  // External bus MUX

output  [1:0] SMMWCS7;      // Boot Memory Bank Width
output        SMWAIT;       // External Wait signal routed to the SMC

output        SMCANCELWAIT; // External Wait time-out signal
output        SMBUSGNTEBI;  // External bus granted to SSMC
output        SMBUSBACKOFFEBI;
                            // Backoff signal for SSMC
output        SMTICBUSGNTEBI;
                            // External bus granted to TIC
output        SMFBCLK;      // Feedback clock
output        SMMemCLK;     // Memeory clock
output  [1:0] SMMemClkRatio;// Memory clock ratio      
output        SMBLS7POL;    // SMBLS Polarity for bank 7

// Inputs
  wire        HCLK;         // AHB Bus Clock
  wire        HRESETn;      // Bus Reset
  wire  [5:2] HADDR;        // AHB Address Bus
  wire  [1:0] HTRANS;       // Transfer type
  wire        HWRITE;       // AHB Peripheral Write
  wire  [2:0] HSIZE;        // Transfer size
  wire        HREADYINTr;   // Multiplexed version of HREADY outputs
  wire [31:0] HWDATA;       // AHB Write Data bus
  wire        HSELSSMCTr;   // AHB Peripheral (Trickbox) Select


  wire [25:0] SMADDR;       // Memory Address Bus
  wire  [7:0] SSMTrCS;      // Memory chip select lines(high)
  wire  [7:0] nSSMTrCS;     // Memory chip select lines(low)
  wire  [3:0] nSMDATAEN;    // Memory Data Bus Enable lines
  wire        nSMWEN;       // Memory Write Enable
  wire  [3:0] nSMBLS;       // Memory Data Bus Lane Enable
  wire        nSMOEN;       // Memory Output Enable
  wire        SMBUSREQEBI;  // SSMC request
  wire        SMTICBUSREQEBI;
                            // TIC request

// Outputs
  wire [31:0] HRDATATr;     // AHB Read Data bus
  wire        HREADYOUTTr;  // Slave HREADY output
  wire  [1:0] HRESPTr;      // Slave response
  wire        BIGENDIAN;    // Endianness of the System
  reg         SMEXTBUSMUX;  // External bus MUX
  wire  [1:0] SMMWCS7;      // Boot Memory Bank Width


  wire        SMWAIT;       // External Wait signal routed to the SMC
  wire        SMCANCELWAIT; // External Wait time-out signal
  wire        iSMWAIT;      // External Wait signal routed to the SMC
  wire        iSMCANCELWAIT;// External Wait time-out signal
  reg         SMBUSGNTEBI;  // External bus granted to SSMC
  wire        SMBUSBACKOFFEBI;
                            // Backoff signal for SSMC 
  wire        SMTICBUSGNTEBI;
                            // External bus granted to TIC
  wire        SMFBCLK;      // Feedback clock
  wire        SMMemCLK;     // Memeory clock
  wire  [1:0] SMMemClkRatio;// Memory clock ratio
  wire        SMBLS7POL;    // SMBLS Polarity for bank 7

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
// 1. SsmcTrAhbIfReg - AHB Interface and Register Block
// 2. SsmcTrProtChkr - SSMC Protocol Checker
// 3. SsmcTrWaitCntl - SSMC Wait Control logic Block.
// 4. SsmcTrExtArb   - External Arbitor
// 5. SsmcTrMemClkGen  - Memory clock generator block.
// 
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        iSMBUSGNTEBI;
// Internal connection
 
wire  [2:0] iSMMemClkRatio;
// Memory clock to HCLK  ratio

wire        iSMMemCLK;
// Memory Clock

wire  [8:0] SSMCTrExtMux;
// External Mux Request and grant
        
wire [11:0] SSMCTrCS2WTR0;
// SMWAIT assertion timming for Bank 0

wire [11:0] SSMCTrCS2WTR1;
// SMWAIT assertion timming for Bank 1

wire [11:0] SSMCTrCS2WTR2;
// SMWAIT assertion timming for Bank 2

wire [11:0] SSMCTrCS2WTR3;
// SMWAIT assertion timming for Bank 3

wire [11:0] SSMCTrCS2WTR4;
// SMWAIT assertion timming for Bank 4

wire [11:0] SSMCTrCS2WTR5;
// SMWAIT assertion timming for Bank 5

wire [11:0] SSMCTrCS2WTR6;
// SMWAIT assertion timming for Bank 6

wire [11:0] SSMCTrCS2WTR7;
// SMWAIT assertion timming for Bank 7

wire  [8:0] SSMCTrWTCNCL;
// SMCANCELWAIT assertion timming

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
assign  #5 SMFBCLK    =  iSMMemCLK;
assign  SMWAIT = 1'b1;
assign  SMCANCELWAIT = 1'b0;
assign  SMMemCLK      = iSMMemCLK;
assign  SMMemClkRatio = iSMMemClkRatio[2:1];
  
always @(SSMCTrExtMux)
  SMEXTBUSMUX <= SSMCTrExtMux[0];

always @(iSMBUSGNTEBI)
  SMBUSGNTEBI = iSMBUSGNTEBI;
// -----------------------------------------------------------------------------
// The SMC Trickbox AHB Interface Instantiation
// -----------------------------------------------------------------------------
SsmcTrAhbIfReg uSsmcTrAhbIfReg        (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR[5:2]),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HREADYINTr       (HREADYINTr),
                    .HWDATA           (HWDATA),
                    .HSELSSMCTr       (HSELSSMCTr),
                    .HRDATATr         (HRDATATr),
                    .HREADYOUTTr      (HREADYOUTTr),
                    .HRESPTr          (HRESPTr),
                    .BIGENDIAN        (BIGENDIAN),
                    .SSMCTrExtMux     (SSMCTrExtMux), 
                    .SMMWCS7          (SMMWCS7),
                    .SSMCTrCS2WTR0    (SSMCTrCS2WTR0),
                    .SSMCTrCS2WTR1    (SSMCTrCS2WTR1),
                    .SSMCTrCS2WTR2    (SSMCTrCS2WTR2),
                    .SSMCTrCS2WTR3    (SSMCTrCS2WTR3),
                    .SSMCTrCS2WTR4    (SSMCTrCS2WTR4),
                    .SSMCTrCS2WTR5    (SSMCTrCS2WTR5),
                    .SSMCTrCS2WTR6    (SSMCTrCS2WTR6),
                    .SSMCTrCS2WTR7    (SSMCTrCS2WTR7),
                    .SSMCTrWTCNCL     (SSMCTrWTCNCL),
                    .SSMCTrCR         (iSMMemClkRatio),
                    .SMBLS7POL        (SMBLS7POL)
                    );

// -----------------------------------------------------------------------------
// The SMC Protocol Checker module Instantiation
// -----------------------------------------------------------------------------
SsmcTrProtChkr uSsmcTrProtChkr        (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .SMDATAOUT        (SMDATAOUT),
                    .SMADDR           (SMADDR),
                    .nSSMCS           (nSSMTrCS),
                    .SSMCS            (SSMTrCS),
                    .nSMDATAEN        (nSMDATAEN),
                    .nSMWEN           (nSMWEN),
                    .nSMBLS           (nSMBLS),
                    .nSMOEN           (nSMOEN)
                    );

// -----------------------------------------------------------------------------
// The SMC SMWAIT Control Logic Instantiation
// -----------------------------------------------------------------------------
defparam uSsmcTrWaitCntl.Tclk = Tclk;

SsmcTrWaitCntl uSsmcTrWaitCntl        (
                    .SMMemCLK         (iSMMemCLK),
                    .HRESETn          (HRESETn),
                    .nSSMCS           (nSSMTrCS),
                    .SMADDR           (SMADDR),
                    .SSMCTrCS2WTR0    (SSMCTrCS2WTR0),
                    .SSMCTrCS2WTR1    (SSMCTrCS2WTR1),
                    .SSMCTrCS2WTR2    (SSMCTrCS2WTR2),
                    .SSMCTrCS2WTR3    (SSMCTrCS2WTR3),
                    .SSMCTrCS2WTR4    (SSMCTrCS2WTR4),
                    .SSMCTrCS2WTR5    (SSMCTrCS2WTR5),
                    .SSMCTrCS2WTR6    (SSMCTrCS2WTR6),
                    .SSMCTrCS2WTR7    (SSMCTrCS2WTR7),
                    .SSMCTrWTCNCL     (SSMCTrWTCNCL),
                    .SMMemClkRatio    (iSMMemClkRatio[2:1]),  
                    .SMWAIT           (iSMWAIT),
                    .SMCANCELWAIT     (iSMCANCELWAIT)
                    );
// -----------------------------------------------------------------------------
// The External arbitar
// -----------------------------------------------------------------------------
SsmcTrExtArb uSsmcTrExtArb            (
                    .SMMemCLK         (iSMMemCLK),
                    .HRESETn          (HRESETn),
                    .SMBUSREQEBI      (SMBUSREQEBI),
                    .SMTICBUSREQEBI   (SMTICBUSREQEBI),
                    .SSMCTrExtMux     (SSMCTrExtMux), 
                    .SMBUSGNTEBI      (iSMBUSGNTEBI),
                    .BackOffSsmc      (SMBUSBACKOFFEBI), 
                    .SMTICBUSGNTEBI   (SMTICBUSGNTEBI)
                    );

// -----------------------------------------------------------------------------
// Memory Clock genrator block instantiation
// -----------------------------------------------------------------------------
defparam uSsmcTrMemClkGen.Tclks = Tclks;
defparam uSsmcTrMemClkGen.Tclkl = Tclkl;
defparam uSsmcTrMemClkGen.Tclkh = Tclkh;
SsmcTrMemClkGen uSsmcTrMemClkGen      (
                     .SMMemClkRatio   (iSMMemClkRatio[2:1]),
                     .SMMemCLK        (iSMMemCLK)
                     );  
                           
endmodule
// --================================== End ==================================--
