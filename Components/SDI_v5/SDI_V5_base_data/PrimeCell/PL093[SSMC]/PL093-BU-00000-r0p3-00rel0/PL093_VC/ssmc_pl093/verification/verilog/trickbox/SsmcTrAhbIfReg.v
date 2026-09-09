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
// File Name              : SsmcTrAhbIfReg.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL093-r0p1-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block interfaces the SMC Trickbox with the AHB.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SsmcTrAhbIfReg (
// Inputs
                      // AHB bus signals
                      HCLK,
                      HRESETn,
                      HADDR,
                      HTRANS,
                      HWRITE,
                      HSIZE,
                      HREADYINTr,
                      HWDATA,
                      HSELSSMCTr,
// Outputs
                      HRDATATr,
                      HREADYOUTTr,
                      HRESPTr,
                      BIGENDIAN,
                      SSMCTrExtMux,

                      // SMC related signals
                      SMMWCS7,
                      SSMCTrCS2WTR0,
                      SSMCTrCS2WTR1,
                      SSMCTrCS2WTR2,
                      SSMCTrCS2WTR3,
                      SSMCTrCS2WTR4,
                      SSMCTrCS2WTR5,
                      SSMCTrCS2WTR6,
                      SSMCTrCS2WTR7,
                      SSMCTrWTCNCL,
                      SSMCTrCR,
                      SMBLS7POL
                      );

// Inputs

// AHB bus signals
input         HCLK;           // AHB Bus Clock
input         HRESETn;        // Bus Reset
input   [5:2] HADDR;          // AHB Address Bus
input   [1:0] HTRANS;         // Transfer type
input         HWRITE;         // AHB Peripheral Write
input   [2:0] HSIZE;          // Transfer size
input         HREADYINTr;     // Multiplexed version of HREADY outputs
input  [31:0] HWDATA;         // AHB Write Data bus
input         HSELSSMCTr;     // AHB Peripheral (Trickbox) Select

// Outputs
output [31:0] HRDATATr;       // AHB Read Data bus
output        HREADYOUTTr;    // Slave HREADY output
output  [1:0] HRESPTr;        // Slave response
output        BIGENDIAN;      // Endianness of the System
output  [8:0] SSMCTrExtMux;   // External bus MUX Register 

// SMC related signals
output  [1:0] SMMWCS7;         // Boot Memory Bank Width
output [11:0] SSMCTrCS2WTR0;   // SMCTrCS2WTR0 Register
output [11:0] SSMCTrCS2WTR1;   // SMCTrCS2WTR1 Register
output [11:0] SSMCTrCS2WTR2;   // SMCTrCS2WTR2 Register
output [11:0] SSMCTrCS2WTR3;   // SMCTrCS2WTR3 Register
output [11:0] SSMCTrCS2WTR4;   // SMCTrCS2WTR4 Register
output [11:0] SSMCTrCS2WTR5;   // SMCTrCS2WTR5 Register
output [11:0] SSMCTrCS2WTR6;   // SMCTrCS2WTR6 Register
output [11:0] SSMCTrCS2WTR7;   // SMCTrCS2WTR7 Register
output  [8:0] SSMCTrWTCNCL;    // SSMCTrWTCNCL Register
output  [2:0] SSMCTrCR;        // Clock ratio register
output        SMBLS7POL;       // SSMCTrSMBLSPOL register

// Inputs

// AHB bus signals
  wire        HCLK;           // AHB Bus Clock
  wire        HRESETn;        // Bus Reset
  wire  [5:2] HADDR;          // AHB Address Bus
  wire  [1:0] HTRANS;         // Transfer type
  wire        HWRITE;         // AHB Peripheral Write
  wire  [2:0] HSIZE;          // Transfer size
  wire        HREADYINTr;     // Multiplexed version of HREADY outputs
  wire [31:0] HWDATA;         // AHB Write Data bus
  wire        HSELSSMCTr;     // AHB Peripheral (Trickbox) Select

// Outputs
  wire [31:0] HRDATATr;       // AHB Read Data bus
  reg         HREADYOUTTr;    // Slave HREADY output
  wire  [1:0] HRESPTr;        // Slave response
  wire        BIGENDIAN;      // Endianness of the System
  wire  [8:0] SSMCTrExtMux;   // External bus MUX Register 

// SMC related signals
  wire  [1:0] SMMWCS7;        // Boot Memory Bank Width
  wire [11:0] SSMCTrCS2WTR0;  // SMCTrCS2WTR0 Register
  wire [11:0] SSMCTrCS2WTR1;  // SMCTrCS2WTR1 Register
  wire [11:0] SSMCTrCS2WTR2;  // SMCTrCS2WTR2 Register
  wire [11:0] SSMCTrCS2WTR3;  // SMCTrCS2WTR3 Register
  wire [11:0] SSMCTrCS2WTR4;  // SMCTrCS2WTR4 Register
  wire [11:0] SSMCTrCS2WTR5;  // SMCTrCS2WTR5 Register
  wire [11:0] SSMCTrCS2WTR6;  // SMCTrCS2WTR6 Register
  wire [11:0] SSMCTrCS2WTR7;  // SMCTrCS2WTR7 Register
  wire [8:0]  SSMCTrWTCNCL;   // SSMCTrWTCNCL Register
  wire [2:0]  SSMCTrCR;       // Clock ratio register
  wire        SMBLS7POL;      // SSMCTrSMBLSPOL register

// -----------------------------------------------------------------------------
//
//                                SsmcTrAhbifReg
//                                ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// SSMC Tricbox is an AHB slave. This block performs the following operations:
//   - Interfaces the Trickbox with the AHB
//       All slave response signals are generated from this module.
//       This module decodes AHB accesses and generates the read/write
//       strobe to the appropriate registers.
//   - Implements SSMC Trickbox registers
//   - Drives non-AMBA, non-memory related signals into the SSMC
//
// -----------------------------------------------------------------------------
//                         SSMC Trickbox Register Map
// -----------------------------------------------------------------------------
// Offset    Register    Type   Width    Describtion
// -----------------------------------------------------------------------------
// 0x0000 -  SSMCTrMWCS      R/W   2-bits These bits determine the memory width.
//                                        These are clocked, but not affected by
//                                        HRESETn. Used to check SMMWCS7
//                                        functionality.
//                                        00 -> 8 bits wide memory
//                                        01 -> 16 bits wide memory
//                                        10 -> 32 bits wide memory
//                                        11 -> 8 bits wide memory
//
// 0x0004    SSMCTrExtMux   R/W  9-bit    This register controls the SMEXTBUSMUX
//                                        the System. The value put in this
//                                        register is driven on BIGENDIAN input
//                                        of the SMC.
//
// 0x0008    SSMCTrEndian   R/W  1-bit    Indicates the type of Endianness of
//                                        the System. The value put in this
//                                        register is driven on BIGENDIAN input
//                                        of the SMC.
//
//           SSMCTrCS2WTRx  R/W  10-bits  This register determines the time
//                                        duration between nCS to SmcTrWait
//                                        assertions and deassertion for Bank x.
//
// 0x000C    SSMCTrCS2WTR0  R/W  12-bits
// 0x0010    SSMCTrCS2WTR1  R/W  12-bits
// 0x0014    SSMCTrCS2WTR2  R/W  12-bits
// 0x0018    SSMCTrCS2WTR3  R/W  12-bits
// 0x001C    SSMCTrCS2WTR4  R/W  12-bits
// 0x0020    SSMCTrCS2WTR5  R/W  12-bits
// 0x0024    SSMCTrCS2WTR6  R/W  12-bits
// 0x0028    SSMCTrCS2WTR7  R/W  12-bits
// 0x002C    SSMCTrWTCNCL   R/W   9-bits  This register determines the delay
//                                        count after which nSMCANCELWAIT will
//                                        be asserted.
//
// 0x0030    SSMCTrCR       R/W   3-bit   Clock ratio control register
//
// 0x0034    SSMCTrSMBLSPOL R/W   1-bit   This register drives the reset value
//                                        for SMBLS7POL signal.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define IDLE             2'b00
// Master IDLE transfer

`define BUSY             2'b01
// Master BUSY transfer

`define OKAY             2'b00
// Slave OKAY respone

`define ERROR            2'b01
// Slave ERROR respone

`define WORD             3'b010
// 32-bit operation

// -----------------------------------------------------------------------------
// Trickbox registers address constants. Address decode is for
// bits 2 to 4 (3 bits)
// -----------------------------------------------------------------------------
`define ADDR_SSMCTrMWCS      4'b0000
// SSMCTrMWCS at offset 0x0000

`define ADDR_SSMCTrExtMux    4'b0001
// SSMCTrExtMux at offset 0x0004
 
`define ADDR_SSMCTrENDIAN    4'b0010
// SSMCTrEndian at offset 0x0008

`define ADDR_SSMCTrCS2WTR0   4'b0011
// SSMCTrCS2WT at offset 0x0010

`define ADDR_SSMCTrCS2WTR1   4'b0100
// SSMCTrCS2WT at offset 0x0014

`define ADDR_SSMCTrCS2WTR2   4'b0101
// SSMCTrCS2WT at offset 0x0018

`define ADDR_SSMCTrCS2WTR3   4'b0110
// SSMCTrCS2WT at offset 0x001C

`define ADDR_SSMCTrCS2WTR4   4'b0111
// SSMCTrCS2WT at offset 0x0020

`define ADDR_SSMCTrCS2WTR5   4'b1000
// SSMCTrCS2WT at offset 0x0034

`define ADDR_SSMCTrCS2WTR6   4'b1001
// SSMCTrCS2WT at offset 0x0024

`define ADDR_SSMCTrCS2WTR7   4'b1010
// SSMCTrCS2WT at offset 0x0028

`define ADDR_SSMCTrWTCNCL    4'b1011
// SSMCTrWTCNCL at offset 0x002C

`define ADDR_SSMCTrCR        4'b1100
// SSMCTrCR at offset 0x0030

`define ADDR_SSMCTrSMBLSPOL  4'b1101
// SSMCTrSMBLSPOL at offset 0x0034
 
// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

//wire        NxtSSMCTrMWCS;
// D-input of SSMCTrMWCS Register

wire [8:0]  NxtSSMCTrExtMux;
// D-input of SSMCTrExtMux Register

wire        NxtSSMCTrEndian;
// D-input of SSMCTrEndian Register

wire [11:0] NxtSSMCTrCS2WTR0;
// D-input for the SSMCTrCS2WT Register for Bank 0

wire [11:0] NxtSSMCTrCS2WTR1;
// D-input for the SSMCTrCS2WT Register for Bank 1

wire [11:0] NxtSSMCTrCS2WTR2;
// D-input for the SSMCTrCS2WT Register for Bank 2

wire [11:0] NxtSSMCTrCS2WTR3;
// D-input for the SSMCTrCS2WT Register for Bank 3

wire [11:0] NxtSSMCTrCS2WTR4;
// D-input for the SSMCTrCS2WT Register for Bank 4

wire [11:0] NxtSSMCTrCS2WTR5;
// D-input for the SSMCTrCS2WT Register for Bank 5

wire [11:0] NxtSSMCTrCS2WTR6;
// D-input for the SSMCTrCS2WT Register for Bank 6

wire [11:0] NxtSSMCTrCS2WTR7;
// D-input for the SMCTrCS2WT Register for Bank 7

wire [8:0] NxtSSMCTrWTCNCL;
// D-input of SSMCTrWTCNCL Register

wire [2:0] NxtSSMCTrCR;
// D-input of SSMCTrCR Register

wire       SSMCTrMWCSRd;
// SSMCTrMWCS Read

wire       SSMCTrExtMuxRd;
// SSMCTrExtMux Read

wire       SSMCTrEndianRd;
// SSMCTrEndian Read

wire       SSMCTrCS2WTR0Rd;
// SSMCTrCS2WTR0 Read

wire       SSMCTrCS2WTR1Rd;
// SSMCTrCS2WTR1 Read

wire       SSMCTrCS2WTR2Rd;
// SSMCTrCS2WTR2 Read

wire       SSMCTrCS2WTR3Rd;
// SSMCTrCS2WTR3 Read

wire       SSMCTrCS2WTR4Rd;
// SSMCTrCS2WTR4 Read

wire       SSMCTrCS2WTR5Rd;
// SSMCTrCS2WTR5 Read

wire       SSMCTrCS2WTR6Rd;
// SSMCTrCS2WTR6 Read

wire       SSMCTrCS2WTR7Rd;
// SSMCTrCS2WTR7 Read

wire       SSMCTrWTCNCLRd;
// SSMCTrWTCNCL Read

wire       SSMCTrCRRd;
// SSMCTrCR Read

wire       SSMCTrSMBLSPOLRd;
// SSMCTrSMBLSPOL Read

wire       SSMCTrMWCSWr;
// SSMCTrMWCS Write

wire       SSMCTrExtMuxWr;
// SSMCTrExtMux Write

wire       SSMCTrEndianWr;
// SSMCTrEndian Write

wire       SSMCTrCS2WTR0Wr;
// SSMCTrCS2WTR0 Write

wire       SSMCTrCS2WTR1Wr;
// SSMCTrCS2WTR1 Write

wire       SSMCTrCS2WTR2Wr;
// SSMCTrCS2WTR2 Write

wire       SSMCTrCS2WTR3Wr;
// SSMCTrCS2WTR3 Write

wire       SSMCTrCS2WTR4Wr;
// SSMCTrCS2WTR4 Write

wire       SSMCTrCS2WTR5Wr;
// SSMCTrCS2WTR5 Write

wire       SSMCTrCS2WTR6Wr;
// SSMCTrCS2WTR6 Write

wire       SSMCTrCS2WTR7Wr;
// SSMCTrCS2WTR7 Write

wire       SSMCTrWTCNCLWr;
// SSMCTrWTCNCL Write

wire       SSMCTrCRWr;
// SSMCTrCR Write

wire       SSMCTrSMBLSPOLWr;
// SSMCTrSMBLSPOL Write

//wire       SSMCTrEndian;
// SSMCTrEndian Register

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg   [1:0] NxtSSMCTrMWCS;
// D-input of SSMCTrMWCS Register

reg         NxtSSMCTrSMBLSPOL;
// D-input of SSMCTrSMBLSPOL Register

reg   [5:2] iLatchHADDR;
// Latched version of HADDR

reg   [1:0] iHRESPTr;
// Indicates the type of response for a transfer

reg   [1:0] SSMCTrMWCS;
// SSMCTrMWCS Register

reg         SSMCTrSMBLSPOL;
// SSMCTrSMBLSPOL Register

reg         SSMCTrEndian;
// SSMCTrEndian Register

reg  [8:0]  iSSMCTrExtMux;
// Internal version of SSMCTrExtMux Register

reg  [25:0] iSSMCTrCS2WTR0;
// Internal version of SSMCTrCS2WT Register for Bank 0

reg  [25:0] iSSMCTrCS2WTR1;
// Internal version of SSMCTrCS2WT Register for Bank 1

reg  [25:0] iSSMCTrCS2WTR2;
// Internal version of SSMCTrCS2WT Register for Bank 2

reg  [25:0] iSSMCTrCS2WTR3;
// Internal version of SSMCTrCS2WT Register for Bank 3

reg  [25:0] iSSMCTrCS2WTR4;
// Internal version of SSMCTrCS2WT Register for Bank 4

reg  [25:0] iSSMCTrCS2WTR5;
// Internal version of SSMCTrCS2WT Register for Bank 5

reg  [25:0] iSSMCTrCS2WTR6;
// Internal version of SSMCTrCS2WT Register for Bank 6

reg  [25:0] iSSMCTrCS2WTR7;
// Internal version of SSMCTrCS2WT Register for Bank 7

reg  [8:0] iSSMCTrWTCNCL;
// Internal version of iSSSMCTrWTCNCL Register

reg  [2:0]  iSSMCTrCR;
// Internal version of SSMCTrCR

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

initial
begin
  SSMCTrMWCS     = 2'b00;
  NxtSSMCTrMWCS  = 2'b00;
  iSSMCTrCR      = 3'b000;
  SSMCTrSMBLSPOL = 1'b0;
end

// -----------------------------------------------------------------------------
// Write enables for registers
// -----------------------------------------------------------------------------
assign SSMCTrMWCSWr      = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrMWCS)) ? 1'b1 : 1'b0;

assign SSMCTrSMBLSPOLWr  = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrMWCS)) ? 1'b1 : 1'b0;

assign SSMCTrExtMuxWr    = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrExtMux)) ? 1'b1 : 1'b0;
  
assign SSMCTrEndianWr    = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrENDIAN)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR0Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR0)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR1Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR1)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR2Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR2)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR3Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR3)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR4Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR4)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR5Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR5)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR6Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR6)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR7Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR7)) ? 1'b1 : 1'b0;

assign SSMCTrWTCNCLWr    = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrWTCNCL)) ? 1'b1 : 1'b0;

assign SSMCTrCRWr        = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCR)) ? 1'b1 : 1'b0;
     
// -----------------------------------------------------------------------------
// Read enables for registers
// -----------------------------------------------------------------------------
assign SSMCTrMWCSRd      = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrMWCS)) ? 1'b1 : 1'b0;

assign SSMCTrSMBLSPOLRd  = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrMWCS)) ? 1'b1 : 1'b0;

assign SSMCTrExtMuxRd    = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrExtMux)) ? 1'b1 : 1'b0;
 
assign SSMCTrEndianRd    = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrENDIAN)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR0Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR0)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR1Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR1)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR2Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR2)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR3Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR3)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR4Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR4)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR5Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR5)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR6Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR6)) ? 1'b1 : 1'b0;

assign SSMCTrCS2WTR7Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCS2WTR7)) ? 1'b1 : 1'b0;

assign SSMCTrWTCNCLRd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrWTCNCL)) ? 1'b1 : 1'b0;

assign SSMCTrCRRd       = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SSMCTrCR)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Output Mux
// When the peripheral is not being accessed, '0's are driven
// on the Read Databus (HRDATA)
// -----------------------------------------------------------------------------
assign HRDATATr         = (SSMCTrMWCSRd == 1'b1) ?
                           {30'b000000000000000000000000000000, SSMCTrMWCS} :
                          ((SSMCTrSMBLSPOLRd == 1'b1) ?
                          {31'b0000000000000000000000000000000,SSMCTrSMBLSPOL} :
                          ((SSMCTrExtMuxRd == 1'b1) ?
                           {24'b000000000000000000000000, iSSMCTrExtMux} : 
                          ((SSMCTrEndianRd == 1'b1) ?
                           {31'b0000000000000000000000000000000, SSMCTrEndian} :
                          ((SSMCTrCS2WTR0Rd == 1'b1) ?
                           {20'b00000000000000000000, iSSMCTrCS2WTR0} :
                          ((SSMCTrCS2WTR1Rd == 1'b1) ?
                           {20'b00000000000000000000, iSSMCTrCS2WTR1} :
                          ((SSMCTrCS2WTR2Rd == 1'b1) ?
                           {20'b00000000000000000000, iSSMCTrCS2WTR2} :
                          ((SSMCTrCS2WTR3Rd == 1'b1) ?
                           {20'b00000000000000000000, iSSMCTrCS2WTR3} :
                          ((SSMCTrCS2WTR4Rd == 1'b1) ?
                           {20'b00000000000000000000, iSSMCTrCS2WTR4} :
                          ((SSMCTrCS2WTR5Rd == 1'b1) ?
                           {20'b00000000000000000000, iSSMCTrCS2WTR5} :
                          ((SSMCTrCS2WTR6Rd == 1'b1) ?
                           {20'b00000000000000000000, iSSMCTrCS2WTR6} :
                          ((SSMCTrCS2WTR7Rd == 1'b1) ?
                           {20'b00000000000000000000, iSSMCTrCS2WTR7} :
                          ((SSMCTrWTCNCLRd  == 1'b1) ?
                           {24'b000000000000000000000000, iSSMCTrWTCNCL} :
                          ((SSMCTrCRRd == 1'b1) ?
                           {29'b00000000000000000000000000000, iSSMCTrCR} : 
                           32'h00000000)))))))))))));

// -----------------------------------------------------------------------------
// This process generates the bus response required for an AHB slave.
// SMC Trickbox is designed for an HSIZE of 32-bit. So this process will
// generate an ERROR response when the master tries to access it in some other
// mode. Also it displays an error message to the output. Trickbox always
// provides a ZERO wait state OKAY response for IDLE and BUSY
// HTRANS of the master.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_BusRespSeq
  if (HRESETn == 1'b0)
    begin
     iHRESPTr         <= 2'b00;
     HREADYOUTTr      <= 1'b1;
     WrEn             <= 1'b0;
     RdEn             <= 1'b0;
     ErrorLat         <= 1'b0;
     iLatchHADDR      <= 5'b00000;
    end
  else
    begin
      if ((iHRESPTr == `ERROR) && (HREADYINTr == 1'b0) && (ErrorLat == 1'b1))
        begin
          iHRESPTr         <= `ERROR;
          HREADYOUTTr      <= 1'b1;
          WrEn             <= 1'b0;
          RdEn             <= 1'b0;
          ErrorLat         <= 1'b0;
        end
      else if (((HTRANS == `IDLE) || (HTRANS == `BUSY)) &&
               (HSELSSMCTr == 1'b1) && (HREADYINTr == 1'b1))
        begin
          iHRESPTr         <= `OKAY;
          HREADYOUTTr      <= 1'b1;
        end
      else if ((HREADYINTr == 1'b1) & (HSELSSMCTr == 1'b1))
        begin
          if (HSIZE == `WORD)
            begin
              HREADYOUTTr  <= 1'b1;
              iLatchHADDR  <= HADDR;
              iHRESPTr     <= `OKAY;
              if (HWRITE == 1'b1)
                begin
                  WrEn     <= 1'b1;
                  RdEn     <= 1'b0;
                end
              else
                begin
                  WrEn     <= 1'b0;
                  RdEn     <= 1'b1;
                end
            end
          else
            begin
              iHRESPTr     <= `ERROR;
              HREADYOUTTr  <= 1'b0;
              WrEn         <= 1'b0;
              RdEn         <= 1'b0;
              ErrorLat     <= 1'b1;
              $display("Error Response from SSMC trickbox slave");
            end
        end
      else
        begin
          WrEn             <= 1'b0;
          RdEn             <= 1'b0;
          iHRESPTr         <= 2'b00;
          HREADYOUTTr      <= 1'b1;
          ErrorLat         <= 1'b0;
        end
    end
end // p_BusRespSeq

// -----------------------------------------------------------------------------
// Combinational logic for all functional registers. When the respective
// write enable input is asserted, copy the contents of the HWDATA Bus into
// the corresponding registers.
// -----------------------------------------------------------------------------
always @(SSMCTrMWCSWr or HWDATA or SSMCTrMWCS)
begin : p_MWCSWrComb
  if (SSMCTrMWCSWr == 1'b1)
    NxtSSMCTrMWCS = HWDATA[1:0];
  else
    NxtSSMCTrMWCS = SSMCTrMWCS;
end // p_MWCSWrComb

always @(SSMCTrSMBLSPOLWr or HWDATA or SSMCTrSMBLSPOL)
begin : p_SMBLSWrComb
  if (SSMCTrSMBLSPOLWr == 1'b1)
    NxtSSMCTrSMBLSPOL = HWDATA[0];
  else
    NxtSSMCTrSMBLSPOL = SSMCTrSMBLSPOL;
end // p_SMBLSWrComb

assign NxtSSMCTrExtMux   = (SSMCTrExtMuxWr == 1'b1) ? HWDATA[8:0]      :
                           iSSMCTrExtMux;

assign NxtSSMCTrEndian   = (SSMCTrEndianWr == 1'b1) ? HWDATA[0]        :
                           SSMCTrEndian;

assign NxtSSMCTrCS2WTR0  = (SSMCTrCS2WTR0Wr == 1'b1) ? HWDATA[11:0]    :
                           iSSMCTrCS2WTR0;

assign NxtSSMCTrCS2WTR1  = (SSMCTrCS2WTR1Wr == 1'b1) ? HWDATA[11:0]    :
                           iSSMCTrCS2WTR1;

assign NxtSSMCTrCS2WTR2  = (SSMCTrCS2WTR2Wr == 1'b1) ? HWDATA[11:0]    :
                           iSSMCTrCS2WTR2;

assign NxtSSMCTrCS2WTR3  = (SSMCTrCS2WTR3Wr == 1'b1) ? HWDATA[11:0]    :
                           iSSMCTrCS2WTR3;

assign NxtSSMCTrCS2WTR4  = (SSMCTrCS2WTR4Wr == 1'b1) ? HWDATA[11:0]    :
                           iSSMCTrCS2WTR4;

assign NxtSSMCTrCS2WTR5  = (SSMCTrCS2WTR5Wr == 1'b1) ? HWDATA[11:0]    :
                           iSSMCTrCS2WTR5;

assign NxtSSMCTrCS2WTR6  = (SSMCTrCS2WTR6Wr == 1'b1) ? HWDATA[11:0]    :
                           iSSMCTrCS2WTR6;

assign NxtSSMCTrCS2WTR7  = (SSMCTrCS2WTR7Wr == 1'b1) ? HWDATA[11:0]    :
                           iSSMCTrCS2WTR7;

assign NxtSSMCTrWTCNCL  = (SSMCTrWTCNCLWr == 1'b1) ? HWDATA[8:0]     :
                           iSSMCTrWTCNCL;

assign NxtSSMCTrCR       = (SSMCTrCRWr == 1'b1)      ? HWDATA[2:0]     :
                           iSSMCTrCR;  

// -----------------------------------------------------------------------------
// Sequential process for all functional registers writes.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegUpdateSeq
  if (HRESETn == 1'b0)
  begin
     SSMCTrSMBLSPOL    <= 1'b0;
     iSSMCTrExtMux     <= 9'b000000000;
     SSMCTrEndian      <= 1'b0;
     iSSMCTrCS2WTR0    <= 12'b000000000000;
     iSSMCTrCS2WTR1    <= 12'b000000000000;
     iSSMCTrCS2WTR2    <= 12'b000000000000;
     iSSMCTrCS2WTR3    <= 12'b000000000000;
     iSSMCTrCS2WTR4    <= 12'b000000000000;
     iSSMCTrCS2WTR5    <= 12'b000000000000;
     iSSMCTrCS2WTR6    <= 12'b000000000000;
     iSSMCTrCS2WTR7    <= 12'b000000000000;
     iSSMCTrWTCNCL     <= 9'b000000000;
     iSSMCTrCR         <= 3'b000;
    end
    else
    begin
     SSMCTrMWCS        <= NxtSSMCTrMWCS;
     SSMCTrSMBLSPOL    <= NxtSSMCTrSMBLSPOL;
     iSSMCTrExtMux     <= NxtSSMCTrExtMux;
     SSMCTrEndian      <= NxtSSMCTrEndian;
     iSSMCTrCS2WTR0    <= NxtSSMCTrCS2WTR0;
     iSSMCTrCS2WTR1    <= NxtSSMCTrCS2WTR1;
     iSSMCTrCS2WTR2    <= NxtSSMCTrCS2WTR2;
     iSSMCTrCS2WTR3    <= NxtSSMCTrCS2WTR3;
     iSSMCTrCS2WTR4    <= NxtSSMCTrCS2WTR4;
     iSSMCTrCS2WTR5    <= NxtSSMCTrCS2WTR5;
     iSSMCTrCS2WTR6    <= NxtSSMCTrCS2WTR6;
     iSSMCTrCS2WTR7    <= NxtSSMCTrCS2WTR7;
     iSSMCTrWTCNCL     <= NxtSSMCTrWTCNCL;
     iSSMCTrCR         <= NxtSSMCTrCR;
  end
end // p_RegUpdateSeq

// -----------------------------------------------------------------------------
// Assign local copies of signals to the outputs
// -----------------------------------------------------------------------------
assign HRESPTr          = iHRESPTr;
assign SMMWCS7          = SSMCTrMWCS;
assign SMBLS7POL        = SSMCTrSMBLSPOL;
assign SSMCTrExtMux     = iSSMCTrExtMux;
assign BIGENDIAN        = SSMCTrEndian;
assign SSMCTrCS2WTR0    = iSSMCTrCS2WTR0;
assign SSMCTrCS2WTR1    = iSSMCTrCS2WTR1;
assign SSMCTrCS2WTR2    = iSSMCTrCS2WTR2;
assign SSMCTrCS2WTR3    = iSSMCTrCS2WTR3;
assign SSMCTrCS2WTR4    = iSSMCTrCS2WTR4;
assign SSMCTrCS2WTR5    = iSSMCTrCS2WTR5;
assign SSMCTrCS2WTR6    = iSSMCTrCS2WTR6;
assign SSMCTrCS2WTR7    = iSSMCTrCS2WTR7;
assign SSMCTrWTCNCL     = iSSMCTrWTCNCL;
assign SSMCTrCR         = iSSMCTrCR;

endmodule
// --================================== End ==================================--
