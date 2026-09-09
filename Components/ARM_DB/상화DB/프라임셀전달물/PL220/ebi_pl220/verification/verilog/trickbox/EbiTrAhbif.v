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
// File Name              : EbiTrAhbif.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block interfaces the EBI Trickbox with the AHB.
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "EbiTrParams.v"

// -----------------------------------------------------------------------------

module EbiTrAhbif (
// Inputs
                   // AHB bus signals
                   HCLK,
                   HRESETn,
                   HADDR,
                   HTRANS,
                   HWRITE,
                   HSIZE,
                   HREADYIN,
                   HWDATA,
                   HSELEBITRICKBOX,
                   EbiTrCntl,
                   EbiTrStatus,
                   EbiTrClk,
                   EbiTrAddr1,
                   EbiTrAddr2,
                   EbiTrAddr3,
                   EbiTrData1,
                   EbiTrData2,
                   EbiTrData3,
                   nEbiTrDataEn1,
                   nEbiTrDataEn2,
                   nEbiTrDataEn3,
                   EbiTrExtDataIn,
                   EbiTrTimeOut1,
                   EbiTrTimeOut2,
                   EbiTrTimeOut3,
// Outputs
                   HREADYOUT,
                   HRESP,
                   HRDATA,
                   WriteData,
                   EbiTrCntlWr,
                   EbiTrClkWr,
                   EbiTrAddr1Wr,
                   EbiTrAddr2Wr,
                   EbiTrAddr3Wr,
                   EbiTrData1Wr,
                   EbiTrData2Wr,
                   EbiTrData3Wr,
                   nEbiTrDataEn1Wr,
                   nEbiTrDataEn2Wr,
                   nEbiTrDataEn3Wr,
                   EbiTrExtDataInWr,
                   EbiTrTimeOut1Wr,
                   EbiTrTimeOut2Wr,
                   EbiTrTimeOut3Wr
                  );

// Inputs

// AHB bus signals
input         HCLK;             // AHB Bus Clock
input         HRESETn;          // Bus Reset
input  [11:2] HADDR;            // AHB Address Bus
input   [1:0] HTRANS;           // Transfer type
input         HWRITE;           // AHB Peripheral Write
input   [2:0] HSIZE;            // Transfer size
input         HREADYIN;         // Multiplexed version of HREADY
                                // outputs
input  [31:0] HWDATA;           // AHB Write Data bus
input         HSELEBITRICKBOX;  // AHB Peripheral (Trickbox) Select
input   [7:0] EbiTrCntl;        // EbiTrCntl Register
input   [5:0] EbiTrStatus;      // EbiTrStatus Register
input   [2:0] EbiTrClk;         // Indicates speed of the MEMCLK1, MEMCLK2 and
                                // MEMCLK3
input  [31:0] EbiTrAddr1;       // Indicates address on EBIADDR1
input  [31:0] EbiTrAddr2;       // Indicates address on EBIADDR1
input  [31:0] EbiTrAddr3;       // Indicates address on EBIADDR1
input  [31:0] EbiTrData1;       // Indicates data on EBIDATA1
input  [31:0] EbiTrData2;       // Indicates data on EBIDATA2
input  [31:0] EbiTrData3;       // Indicates data on EBIDATA3
input   [3:0] nEbiTrDataEn1;    // Indicates data enable on EBIDATAEN1
input   [3:0] nEbiTrDataEn2;    // Indicates data enable on EBIDATAEN2
input   [3:0] nEbiTrDataEn3;    // Indicates data enable on EBIDATAEN3
input  [31:0] EbiTrExtDataIn;   // Indicates data enable on
                                // EBIEXTDATAIN
input   [9:0] EbiTrTimeOut1;    // Indicates EBITIMEOUTVALUE1
input   [9:0] EbiTrTimeOut2;    // Indicates EBITIMEOUTVALUE2
input   [9:0] EbiTrTimeOut3;    // Indicates EBITIMEOUTVALUE3

// Outputs
output        HREADYOUT;        // Slave HREADY output
output  [1:0] HRESP;            // Slave response
output [31:0] HRDATA;           // AHB Read Data bus
output [31:0] WriteData;        // Write Data bus to the Register
                                // Block
output        EbiTrCntlWr;      // EbiTrCntl register write enable
output        EbiTrClkWr;       // EbiTrClk Register Write Enable
output        EbiTrAddr1Wr;     // EbiTrAddr1 Register Write
output        EbiTrAddr2Wr;     // EbiTrAddr2 Register Write
output        EbiTrAddr3Wr;     // EbiTrAddr3 Register Write
output        EbiTrData1Wr;     // EbiTrData1 Register Write
output        EbiTrData2Wr;     // EbiTrData2 Register Write
output        EbiTrData3Wr;     // EbiTrData3 Register Write
output        nEbiTrDataEn1Wr;  // nEbiTrDataEn1 Register Write
output        nEbiTrDataEn2Wr;  // nEbiTrDataEn2 Register Write
output        nEbiTrDataEn3Wr;  // nEbiTrDataEn3 Register Write
output        EbiTrExtDataInWr; // EbiTrExtDataIn Register Write
output        EbiTrTimeOut1Wr;  // EbiTrTimeOut1 register write
output        EbiTrTimeOut2Wr;  // EbiTrTimeOut2 register write
output        EbiTrTimeOut3Wr;  // EbiTrTimeOut3 register write

// Inputs

// AHB bus signals
wire        HCLK;             // AHB Bus Clock
wire        HRESETn;          // Bus Reset
wire [11:2] HADDR;            // AHB Address Bus
wire  [1:0] HTRANS;           // Transfer type
wire        HWRITE;           // AHB Peripheral Write
wire  [2:0] HSIZE;            // Transfer size
wire        HREADYIN;         // Multiplexed version of HREADY
                              // outputs
wire [31:0] HWDATA;           // AHB Write Data bus
wire        HSELEBITRICKBOX;  // AHB Peripheral (Trickbox) Select
wire  [7:0] EbiTrCntl;        // EbiTrCntl Register
wire  [5:0] EbiTrStatus;      // EbiTrStatus Register
wire  [2:0] EbiTrClk;         // Indicates speed of MEMCLK1 MEMCLK2 and MEMCLK3
wire [31:0] EbiTrAddr1;       // Indicates address on EBIADDR1
wire [31:0] EbiTrAddr2;       // Indicates address on EBIADDR1
wire [31:0] EbiTrAddr3;       // Indicates address on EBIADDR1
wire [31:0] EbiTrData1;       // Indicates data on EBIDATA1
wire [31:0] EbiTrData2;       // Indicates data on EBIDATA2
wire [31:0] EbiTrData3;       // Indicates data on EBIDATA3
wire  [3:0] nEbiTrDataEn1;    // Indicates data enable on EBIDATAEN1
wire  [3:0] nEbiTrDataEn2;    // Indicates data enable on EBIDATAEN2
wire  [3:0] nEbiTrDataEn3;    // Indicates data enable on EBIDATAEN3
wire [31:0] EbiTrExtDataIn;   // Indicates data enable on
                              // EBIEXTDATAIN
wire  [9:0] EbiTrTimeOut1;    // Indicates EBITIMEOUTVALUE1
wire  [9:0] EbiTrTimeOut2;    // Indicates EBITIMEOUTVALUE2
wire  [9:0] EbiTrTimeOut3;    // Indicates EBITIMEOUTVALUE3

// Outputs
reg         HREADYOUT;        // Slave HREADY output
wire  [1:0] HRESP;            // Slave response
wire [31:0] HRDATA;           // AHB Read Data bus
wire [31:0] WriteData;        // Write Data bus to the Register
                              // Block
wire        EbiTrCntlWr;      // EbiTrCntl register write enable
wire        EbiTrClkWr;       // EbiTrClk Register Write Enable
wire        EbiTrAddr1Wr;     // EbiTrAddr1 Register Write
wire        EbiTrAddr2Wr;     // EbiTrAddr2 Register Write
wire        EbiTrAddr3Wr;     // EbiTrAddr3 Register Write
wire        EbiTrData1Wr;     // EbiTrData1 Register Write
wire        EbiTrData2Wr;     // EbiTrData2 Register Write
wire        EbiTrData3Wr;     // EbiTrData3 Register Write
wire        nEbiTrDataEn1Wr;  // nEbiTrDataEn1 Register Write
wire        nEbiTrDataEn2Wr;  // nEbiTrDataEn2 Register Write
wire        nEbiTrDataEn3Wr;  // nEbiTrDataEn3 Register Write
wire        EbiTrExtDataInWr; // EbiTrExtDataIn Register Write
wire        EbiTrTimeOut1Wr;  // EbiTrTimeOut1 register write
wire        EbiTrTimeOut2Wr;  // EbiTrTimeOut2 register write
wire        EbiTrTimeOut3Wr;  // EbiTrTimeOut3 register write

// -----------------------------------------------------------------------------
//
//                                 EbiTrAhbif
//                                 ==========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// EBI Tricbox is an AHB slave. This block performs the following operations:
//   - Interfaces the Trickbox with the AHB
//       All slave response signals are generated from this module.
//       This module decodes AHB accesses and generates the read/write
//       strobe to the appropriate registers.
//
// -----------------------------------------------------------------------------
//                         EBI Trickbox Register Map
// -----------------------------------------------------------------------------
// Offset    Register       Type  Width    Describtion
// -----------------------------------------------------------------------------
// [from EBI trickbox Base]
// 0x0000 -  EbiTrCntl      R/W  8-bits  This is EBI request register
//
// 0x0004 -  EbiTrStatus    R/W  6-bits  This is EBI Status register
//
// 0x0008 -  EbiTrClk       R/W  3-bits  This register indicates the clock
//                                       speed
//
// 0x000C -  EbiTrAddr1     R/W  32-bits This is EBI Trickbox register which
//                                       indicates the address to be put on
//                                       EBIADDR1[31:0]
//
// 0x0010 -  EbiTrAddr2     R/W  32-bits This is EBI Trickbox register which
//                                       indicates the address to be put on
//                                       EBIADDR2[31:0]
//
// 0x0014 -  EbiTrAddr3     R/W  32-bits This is EBI Trickbox register which
//                                       indicates the address to be put on
//                                       EBIADDR3[31:0]
//
// 0x0018 -  EbiTrData1     R/W  32-bits This is EBI Trickbox register which
//                                       indicates the data to be put on
//                                       EBIDATA1[31:0]
//
// 0x001C -  EbiTrData2     R/W  32-bits This is EBI Trickbox register which
//                                       indicates the data to be put on
//                                       EBIDATA2[31:0]
//
// 0x0020 -  EbiTrData3     R/W  32-bits This is EBI Trickbox register which
//                                       indicates the data to be put on
//                                       EBIDATA3[31:0]
//
// 0x0024 -  nEbiTrDataEn1   R/W   4-bits This is EBI Trickbox register which
//                                       indicates the dataen to be put on
//                                       EBIDATAEn1[3:0]
//
// 0x0028 -  nEbiTrDataEn2   R/W   4-bits This is EBI Trickbox register which
//                                       indicates the dataen to be put on
//                                       EBIDATAEn2[3:0]
//
// 0x002C -  nEbiTrDataEn3   R/W   4-bits This is EBI Trickbox register which
//                                       indicates the dataen to be put on
//                                       EBIDATAEn3[3:0]
//
// 0x0030 -  EbiTrExtDataIn R/W  32-bits This is EBI Trickbox register which
//                                       indicates the External Data in to be
//                                       put on  EBIEXTDATAIN[31:0]
//
// 0x0034 -  EbiTrTimeOut1  R/W  10-bits This is EBI Trickbox register which
//                                       indicates the timeout value to be put
//                                       on EBITIMEOUTVALUE1[9:0]
//
// 0x0038 -  EbiTrTimeOut2  R/W  10-bits This is EBI Trickbox register which
//                                       indicates the timeout value to be put
//                                       on EBITIMEOUTVALUE2[9:0]
//
// 0x003C -  EbiTrTimeOut3  R/W  10-bits This is EBI Trickbox register which
//                                       indicates the timeout value to be put
//                                       on EBITIMEOUTVALUE3[9:0]
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Trickbox registers address constants. Address decode is for
// bits 2 to 4 (3 bits)
// -----------------------------------------------------------------------------
`define ADDR_EBITRCNTL     10'b0000000000
// EbiTrCntl at offset 0x0000

`define ADDR_EBITRSTATUS   10'b0000000001
// EbiTrStatus at offset 0x0001

`define ADDR_EBITRCLK      10'b0000000010
// EbiTrClk at offset 0x0004

`define ADDR_EBITRADDR1    10'b0000000011
// EbiTrAddr1 at offset 0x0008

`define ADDR_EBITRADDR2    10'b0000000100
// EbiTrAddr2 at offset 0x000C

`define ADDR_EBITRADDR3    10'b0000000101
// EbiTrAddr3 at offset 0x0010

`define ADDR_EBITRDATA1    10'b0000000110
// EbiTrData1 at offset 0x0014

`define ADDR_EBITRDATA2    10'b0000000111
// EbiTrData2 at offset 0x0018

`define ADDR_EBITRDATA3    10'b0000001000
// EbiTrData3 at offset 0x001C

`define ADDR_EBITRDATAEN1  10'b0000001001
// nEbiTrDataEn1 at offset 0x0020 from EBI base

`define ADDR_EBITRDATAEN2  10'b0000001010
// nEbiTrDataEn2 at offset 0x0024 from EBI base

`define ADDR_EBITRDATAEN3  10'b0000001011
// nEbiTrDataEn3 at offset 0x0028 from EBI base

`define ADDR_EBITREXTDATAIN 10'b0000001100
// nEbiTrDataEn3 at offset 0x002C from EBI base

`define ADDR_EBITRTIMEOUT1 10'b0000001101
// EbiTrTimeOut1 at offset 0x0030 from EBI base

`define ADDR_EBITRTIMEOUT2 10'b0000001110
// EbiTrTimeOut2 at offset 0x0034 from EBI base

`define ADDR_EBITRTIMEOUT3 10'b0000001111
// EbiTrTimeOut3 at offset 0x0038 from EBI base

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        EbiTrCntlRd;
// EbiTrCntl Read

wire        EbiTrStatusRd;
// EbiTrStatus Read

wire        EbiTrClkRd;
// EbiTrClk Read

wire        EbiTrAddr1Rd;
// EbiTrAddr1 Read

wire        EbiTrAddr2Rd;
// EbiTrAddr2 Read

wire        EbiTrAddr3Rd;
// EbiTrAddr3 Read

wire        EbiTrData1Rd;
// EbiTrData1 Read

wire        EbiTrData2Rd;
// EbiTrData2 Read

wire        EbiTrData3Rd;
// EbiTrData3 Read

wire        nEbiTrDataEn1Rd;
// EbiTrData1En Read

wire        nEbiTrDataEn2Rd;
// EbiTrData2En Read

wire        nEbiTrDataEn3Rd;
// EbiTrData3En Read

wire        EbiTrExtDataInRd;
// EbiTrExtDataIn Read

wire        EbiTrTimeOut1Rd;
// EbiTrTimeOut1 Read

wire        EbiTrTimeOut2Rd;
// EbiTrTimeOut2 Read

wire        EbiTrTimeOut3Rd;
// EbiTrTimeOut3 Read

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [11:2] iLatchHADDR;
// Latched version of HADDR

reg   [1:0] iHRESP;
// Indicates the type of response for a transfer

reg         RdEn;
// Read enable signal

reg         WrEn;
// Write enable signal

reg         ErrorLat;
// Latch error condition

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
// Write enables for registers
// -----------------------------------------------------------------------------
assign EbiTrCntlWr      = ((WrEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRCNTL)) ?
                          1'b1 : 1'b0;

assign EbiTrClkWr       = ((WrEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRCLK)) ?
                          1'b1 : 1'b0;

assign EbiTrAddr1Wr     = ((WrEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRADDR1)) ?
                          1'b1 : 1'b0;

assign EbiTrAddr2Wr     = ((WrEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRADDR2)) ?
                          1'b1 : 1'b0;

assign EbiTrAddr3Wr     = ((WrEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRADDR3)) ?
                          1'b1 : 1'b0;

assign EbiTrData1Wr     = ((WrEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRDATA1)) ?
                          1'b1 : 1'b0;

assign EbiTrData2Wr     = ((WrEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRDATA2)) ?
                          1'b1 : 1'b0;

assign EbiTrData3Wr     = ((WrEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRDATA3)) ?
                          1'b1 : 1'b0;

assign nEbiTrDataEn1Wr  = ((WrEn == 1'b1) & (iLatchHADDR ==
                           `ADDR_EBITRDATAEN1)) ? 1'b1 : 1'b0;

assign nEbiTrDataEn2Wr  = ((WrEn == 1'b1) & (iLatchHADDR ==
                           `ADDR_EBITRDATAEN2)) ? 1'b1 : 1'b0;

assign nEbiTrDataEn3Wr  = ((WrEn == 1'b1) & (iLatchHADDR ==
                           `ADDR_EBITRDATAEN3)) ? 1'b1 : 1'b0;

assign EbiTrExtDataInWr = ((WrEn == 1'b1) & (iLatchHADDR ==
                           `ADDR_EBITREXTDATAIN)) ? 1'b1 : 1'b0;

assign EbiTrTimeOut1Wr  = ((WrEn == 1'b1) & (iLatchHADDR ==
                           `ADDR_EBITRTIMEOUT1)) ? 1'b1 : 1'b0;

assign EbiTrTimeOut2Wr  = ((WrEn == 1'b1) & (iLatchHADDR ==
                           `ADDR_EBITRTIMEOUT2)) ? 1'b1 : 1'b0;

assign EbiTrTimeOut3Wr  = ((WrEn == 1'b1) & (iLatchHADDR ==
                           `ADDR_EBITRTIMEOUT3)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Read enables for registers
// -----------------------------------------------------------------------------
assign EbiTrCntlRd      = ((RdEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRCNTL)) ?
                          1'b1 : 1'b0;

assign EbiTrStatusRd    = ((RdEn == 1'b1) & (iLatchHADDR ==
                            `ADDR_EBITRSTATUS)) ?  1'b1 : 1'b0;

assign EbiTrClkRd       = ((RdEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRCLK)) ?
                          1'b1 : 1'b0;

assign EbiTrAddr1Rd     = ((RdEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRADDR1)) ?
                          1'b1 : 1'b0;

assign EbiTrAddr2Rd     = ((RdEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRADDR2)) ?
                          1'b1 : 1'b0;

assign EbiTrAddr3Rd     = ((RdEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRADDR3)) ?
                          1'b1 : 1'b0;

assign EbiTrData1Rd     = ((RdEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRDATA1)) ?
                          1'b1 : 1'b0;

assign EbiTrData2Rd     = ((RdEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRDATA2)) ?
                          1'b1 : 1'b0;

assign EbiTrData3Rd     = ((RdEn == 1'b1) & (iLatchHADDR == `ADDR_EBITRDATA3)) ?
                          1'b1 : 1'b0;

assign nEbiTrDataEn1Rd  = ((RdEn == 1'b1) & (iLatchHADDR ==
                           `ADDR_EBITRDATAEN1)) ? 1'b1 : 1'b0;

assign nEbiTrDataEn2Rd  = ((RdEn == 1'b1) & (iLatchHADDR ==
                           `ADDR_EBITRDATAEN2)) ? 1'b1 : 1'b0;

assign nEbiTrDataEn3Rd  = ((RdEn == 1'b1) & (iLatchHADDR ==
                           `ADDR_EBITRDATAEN3)) ? 1'b1 : 1'b0;

assign EbiTrExtDataInRd = ((RdEn == 1'b1) & (iLatchHADDR ==
                           `ADDR_EBITREXTDATAIN)) ? 1'b1 : 1'b0;

assign EbiTrTimeOut1Rd  = ((RdEn == 1'b1) & (iLatchHADDR ==
                           `ADDR_EBITRTIMEOUT1)) ? 1'b1 : 1'b0;

assign EbiTrTimeOut2Rd  = ((RdEn == 1'b1) & (iLatchHADDR ==
                           `ADDR_EBITRTIMEOUT2)) ? 1'b1 : 1'b0;

assign EbiTrTimeOut3Rd  = ((RdEn == 1'b1) & (iLatchHADDR ==
                           `ADDR_EBITRTIMEOUT3)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Output Mux
// When the peripheral is not being accessed, '0's are driven
// on the Read Databus (HRDATA)
// -----------------------------------------------------------------------------
assign HRDATA           = (EbiTrCntlRd == 1'b1) ?
                           {24'b000000000000000000000000, EbiTrCntl}     : (
                           (EbiTrStatusRd == 1'b1) ?
                           {26'b00000000000000000000000000, EbiTrStatus} : (
                           (EbiTrClkRd == 1'b1) ?
                           {29'b00000000000000000000000000000, EbiTrClk}
                                                                         : (
                           (EbiTrAddr1Rd == 1'b1) ? EbiTrAddr1           : (
                           (EbiTrAddr2Rd == 1'b1) ? EbiTrAddr2           : (
                           (EbiTrAddr3Rd == 1'b1) ? EbiTrAddr3           : (
                           (EbiTrData1Rd == 1'b1) ? EbiTrData1           : (
                           (EbiTrData2Rd == 1'b1) ? EbiTrData2           : (
                           (EbiTrData3Rd == 1'b1) ? EbiTrData3           : (
                           (nEbiTrDataEn1Rd == 1'b1) ?
                           {28'b0000000000000000000000000000,
                           nEbiTrDataEn1}                                : (
                           (nEbiTrDataEn2Rd == 1'b1) ?
                           {28'b0000000000000000000000000000,
                           nEbiTrDataEn2}                                : (
                           (nEbiTrDataEn3Rd == 1'b1) ?
                           {28'b0000000000000000000000000000,
                           nEbiTrDataEn3}                                : (
                           (EbiTrExtDataInRd == 1'b1) ? EbiTrExtDataIn   : (
                           (EbiTrTimeOut1Rd == 1'b1) ?
                           {22'b0000000000000000000000, EbiTrTimeOut1}   : (
                           (EbiTrTimeOut2Rd == 1'b1) ?
                           {22'b0000000000000000000000, EbiTrTimeOut2}   : (
                           (EbiTrTimeOut3Rd == 1'b1) ?
                           {22'b0000000000000000000000, EbiTrTimeOut3}   :
                           32'h00000000)))))))))))))));

// -----------------------------------------------------------------------------
// This process generates the bus response required for an AHB slave.
// EBI Trickbox is designed for an HSIZE of 32-bit. So this process will
// generate an ERROR response when the master tries to access it in some other
// mode. Also it displays an error message to the output. Trickbox always
// provides a ZERO wait state OKAY response for IDLE and BUSY
// HTRANS of the master.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_BusRespSeq
  if (HRESETn == 1'b0)
    begin
     iHRESP           <= 2'b00;
     HREADYOUT        <= 1'b1;
     WrEn             <= 1'b0;
     RdEn             <= 1'b0;
     ErrorLat         <= 1'b0;
     iLatchHADDR      <= 10'b0000000000;
    end
  else
    begin
      if ((iHRESP == `HRESP_ERROR) & (HREADYIN == 1'b0) & (ErrorLat == 1'b1))
        begin
          iHRESP           <= `HRESP_ERROR;
          HREADYOUT        <= 1'b1;
          WrEn             <= 1'b0;
          RdEn             <= 1'b0;
          ErrorLat         <= 1'b0;
        end
      else if (((HTRANS == `HTRANS_IDLE) | (HTRANS == `HTRANS_BUSY)) &
                (HSELEBITRICKBOX == 1'b1) & (HREADYIN == 1'b1))
        begin
          WrEn             <= 1'b0;
          RdEn             <= 1'b0;
          iHRESP           <= `HRESP_OKAY;
          HREADYOUT        <= 1'b1;
        end
      else if ((HREADYIN == 1'b1) & (HSELEBITRICKBOX == 1'b1))
        begin
          if (HSIZE == `HSIZE_WORD)
            begin
              HREADYOUT        <= 1'b1;
              iLatchHADDR      <= HADDR;
              iHRESP           <= `HRESP_OKAY;
              if (HWRITE == 1'b1)
                begin
                  WrEn             <= 1'b1;
                  RdEn             <= 1'b0;
                end
              else
                begin
                  WrEn             <= 1'b0;
                  RdEn             <= 1'b1;
                end
            end
          else
            begin
              iHRESP           <= `HRESP_ERROR;
              HREADYOUT        <= 1'b0;
              WrEn             <= 1'b0;
              RdEn             <= 1'b0;
              ErrorLat         <= 1'b1;
              $display("Error : Time %t : Error Response from EBI trickbox slave", $time);
            end
        end
      else if (HREADYIN == 1'b1)
        begin
          if (HSIZE == `HSIZE_WORD)
            begin
              HREADYOUT        <= 1'b1;
              iLatchHADDR      <= HADDR;
              iHRESP           <= `HRESP_OKAY;
              if (HWRITE == 1'b1)
                begin
                  WrEn             <= 1'b0;
                  RdEn             <= 1'b0;
                end
              else
                begin
                  WrEn             <= 1'b0;
                  RdEn             <= 1'b0;
                end
            end
          else
            begin
              iHRESP           <= `HRESP_ERROR;
              HREADYOUT        <= 1'b0;
              WrEn             <= 1'b0;
              RdEn             <= 1'b0;
              ErrorLat         <= 1'b1;
            end
        end
      else
        begin
          WrEn             <= 1'b0;
          RdEn             <= 1'b0;
          iHRESP           <= 2'b00;
          HREADYOUT        <= 1'b1;
          ErrorLat         <= 1'b0;
        end
    end
end // p_BusRespSeq

// -----------------------------------------------------------------------------
// Assign AHB Write Data
// -----------------------------------------------------------------------------
assign WriteData        = (WrEn == 1'b1) ? HWDATA : 32'h00000000;

// -----------------------------------------------------------------------------
// Assign local copies of signals to the outputs
// -----------------------------------------------------------------------------
assign HRESP            = iHRESP;

endmodule
// --================================== End ==================================--
