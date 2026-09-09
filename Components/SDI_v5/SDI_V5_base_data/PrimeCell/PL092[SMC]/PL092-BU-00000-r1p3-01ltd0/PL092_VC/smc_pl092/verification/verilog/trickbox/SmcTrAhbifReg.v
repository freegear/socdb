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
// File Name              : SmcTrAhbifReg.v.rca
// File Revision          : 1.14
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block interfaces the SMC Trickbox with the AHB.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SmcTrAhbifReg (
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
                      HSELSMCTR,
// Outputs
                      HRDATA,
                      HREADYOUT,
                      HRESP,
                      ENDIANCNT,
                      REMAP,

                      // SMC related signals
                      SMMWCS7,
                      SMCTrCS2WTR0,
                      SMCTrCEWTR0,
                      SMCTrCS2WTR1,
                      SMCTrCEWTR1,
                      SMCTrCS2WTR2,
                      SMCTrCEWTR2,
                      SMCTrCS2WTR3,
                      SMCTrCEWTR3,
                      SMCTrCS2WTR4,
                      SMCTrCEWTR4,
                      SMCTrCS2WTR5,
                      SMCTrCEWTR5,
                      SMCTrCS2WTR6,
                      SMCTrCEWTR6,
                      SMCTrCS2WTR7,
                      SMCTrCEWTR7,
                      SMCTrMCREQD,
                      SMCTrGNT2RMREQ,
                      SMCTrMCADDR,
                      SMCTrMCDATAOUT,
                      SMCTrCNCLWAIT,
                      SMCTrEBICntl,
                      SMCTrMCBUSRRd,
                      SMCTrCNCLWAITRd,
                      SMCTrCNCLWAITWr,
                      SMCTrMCBUSRWr
                      );

// Inputs

// AHB bus signals
input         HCLK;           // AHB Bus Clock
input         HRESETn;        // Bus Reset
input   [6:2] HADDR;          // AHB Address Bus
input   [1:0] HTRANS;         // Transfer type
input         HWRITE;         // AHB Peripheral Write
input   [2:0] HSIZE;          // Transfer size
input         HREADYIN;       // Multiplexed version of HREADY outputs
input  [31:0] HWDATA;         // AHB Write Data bus
input         HSELSMCTR;      // AHB Peripheral (Trickbox) Select

// Outputs
output [31:0] HRDATA;         // AHB Read Data bus
output        HREADYOUT;      // Slave HREADY output
output  [1:0] HRESP;          // Slave response
output        ENDIANCNT;      // Endianness of the System
output        REMAP;          // Reset/Normal Memory map select



// SMC related signals
output  [1:0] SMMWCS7;        // Boot Memory Bank Width
output [25:0] SMCTrCS2WTR0;   // SMCTrCS2WTR0 Register
output [23:0] SMCTrCEWTR0;    // SMCTrCEWTR0 Register
output [25:0] SMCTrCS2WTR1;   // SMCTrCS2WTR1 Register
output [23:0] SMCTrCEWTR1;    // SMCTrCEWTR1 Register
output [25:0] SMCTrCS2WTR2;   // SMCTrCS2WTR2 Register
output [23:0] SMCTrCEWTR2;    // SMCTrCEWTR2 Register
output [25:0] SMCTrCS2WTR3;   // SMCTrCS2WTR3 Register
output [23:0] SMCTrCEWTR3;    // SMCTrCEWTR3 Register
output [25:0] SMCTrCS2WTR4;   // SMCTrCS2WTR4 Register
output [23:0] SMCTrCEWTR4;    // SMCTrCEWTR4 Register
output [25:0] SMCTrCS2WTR5;   // SMCTrCS2WTR5 Register
output [23:0] SMCTrCEWTR5;    // SMCTrCEWTR5 Register
output [25:0] SMCTrCS2WTR6;   // SMCTrCS2WTR6 Register
output [23:0] SMCTrCEWTR6;    // SMCTrCEWTR6 Register
output [25:0] SMCTrCS2WTR7;   // SMCTrCS2WTR7 Register
output [23:0] SMCTrCEWTR7;    // SMCTrCEWTR7 Register
output  [4:0] SMCTrMCREQD;    // MCBUS Access to REQUEST Delay Count
                              // Register
output  [4:0] SMCTrGNT2RMREQ; // MCBUS Grant to REQUEST de-assertion
                              // delay count Register
output [25:0] SMCTrMCADDR;    // Address to eb driven out to the
                              // MCADDR bus of the SMC
output [31:0] SMCTrMCDATAOUT; // Data to be driven out to the
                              // MCDATAOUT bus of the SMC
output [5:0] SMCTrCNCLWAIT; 
output [11:0] SMCTrEBICntl; 
                            
output        SMCTrMCBUSRRd;  // MCBUS Read Enable
output        SMCTrMCBUSRWr;  // MCBUS Write Enable

output        SMCTrCNCLWAITRd; 
output        SMCTrCNCLWAITWr;



// Inputs

// AHB bus signals
  wire        HCLK;           // AHB Bus Clock
  wire        HRESETn;        // Bus Reset
  wire  [6:2] HADDR;          // AHB Address Bus
  wire  [1:0] HTRANS;         // Transfer type
  wire        HWRITE;         // AHB Peripheral Write
  wire  [2:0] HSIZE;          // Transfer size
  wire        HREADYIN;       // Multiplexed version of HREADY outputs
  wire [31:0] HWDATA;         // AHB Write Data bus
  wire        HSELSMCTR;      // AHB Peripheral (Trickbox) Select

// Outputs
  wire [31:0] HRDATA;         // AHB Read Data bus
  reg         HREADYOUT;      // Slave HREADY output
  wire  [1:0] HRESP;          // Slave response
  wire        ENDIANCNT;      // Endianness of the System
  wire        REMAP;          // Reset/Normal Memory map select



// SMC related signals
  wire  [1:0] SMMWCS7;        // Boot Memory Bank Width
  wire [25:0] SMCTrCS2WTR0;   // SMCTrCS2WTR0 Register
  wire [23:0] SMCTrCEWTR0;    // SMCTrCEWTR0 Register
  wire [25:0] SMCTrCS2WTR1;   // SMCTrCS2WTR1 Register
  wire [23:0] SMCTrCEWTR1;    // SMCTrCEWTR1 Register
  wire [25:0] SMCTrCS2WTR2;   // SMCTrCS2WTR2 Register
  wire [23:0] SMCTrCEWTR2;    // SMCTrCEWTR2 Register
  wire [25:0] SMCTrCS2WTR3;   // SMCTrCS2WTR3 Register
  wire [23:0] SMCTrCEWTR3;    // SMCTrCEWTR3 Register
  wire [25:0] SMCTrCS2WTR4;   // SMCTrCS2WTR4 Register
  wire [23:0] SMCTrCEWTR4;    // SMCTrCEWTR4 Register
  wire [25:0] SMCTrCS2WTR5;   // SMCTrCS2WTR5 Register
  wire [23:0] SMCTrCEWTR5;    // SMCTrCEWTR5 Register
  wire [25:0] SMCTrCS2WTR6;   // SMCTrCS2WTR6 Register
  wire [23:0] SMCTrCEWTR6;    // SMCTrCEWTR6 Register
  wire [25:0] SMCTrCS2WTR7;   // SMCTrCS2WTR7 Register
  wire [23:0] SMCTrCEWTR7;    // SMCTrCEWTR7 Register
  wire  [4:0] SMCTrMCREQD;    // MCBUS Access to REQUEST Delay Count
                              // Register
  wire  [4:0] SMCTrGNT2RMREQ; // MCBUS Grant to REQUEST de-assertion
                              // delay count Register
  wire [25:0] SMCTrMCADDR;    // Address to eb driven out to the
                              // MCADDR bus of the SMC
  wire [31:0] SMCTrMCDATAOUT; // Data to be driven out to the
                              // MCDATAOUT bus of the SMC
  wire [5:0]  SMCTrCNCLWAIT ; 
  wire [11:0]  SMCTrEBICntl; 
  wire        SMCTrMCBUSRRd;  // MCBUS Read Enable
  wire        SMCTrMCBUSRWr;  // MCBUS Write Enable
  wire        SMCTrCNCLWAITRd; 
  wire        SMCTrCNCLWAITWr;


// -----------------------------------------------------------------------------
//
//                                SmcTrAhbifReg
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// SMC Tricbox is an AHB slave. This block performs the following operations:
//   - Interfaces the Trickbox with the AHB
//       All slave response signals are generated from this module.
//       This module decodes AHB accesses and generates the read/write
//       strobe to the appropriate registers.
//   - Implements SMC Trickbox registers
//   - Drives non-AMBA, non-memory related signals into the SMC
//
// -----------------------------------------------------------------------------
//                         SMC Trickbox Register Map
// -----------------------------------------------------------------------------
// Offset    Register    Type   Width    Describtion
// -----------------------------------------------------------------------------
// 0x0000 -  SMCTrMWCS     R/W   2-bits  These bits determine the memory width.
//                                       These are clocked, but not affected by
//                                       HRESETn. Used to check SMMWCS1
//                                       functionality.
//                                       00 -> 8 bits wide memory
//                                       01 -> 16 bits wide memory
//                                       10 -> 32 bits wide memory
//                                       11 -> 8 bits wide memory
//
// 0x0004    SMCTrRemap    R/W  1-bit    Indicates the state of the memory map.
//                                       0 -> Reset memory map (SMCS[1] shadows
//                                            SMCS[0])
//                                       1 -> Normal memory map
//                                       This bit is clocked, but not affected
//                                       by HRESETn.
//
// 0x0008    SMCTrEndian   R/W  1-bit    Indicates the type of Endianness of
//                                       the System. The value put in this
//                                       register is driven on BIGENDIAN input
//                                       of the SMC.
//
//           SMCTrCS2WTRx  R/W  26-bits  This register determines the time
//                                       duration between nCS and SmcTrWait
//                                       assertions for Bank x.
//
// 0x000C    SMCTrCS2WTR0  R/W  26-bits
// 0x0014    SMCTrCS2WTR1  R/W  26-bits
// 0x001C    SMCTrCS2WTR2  R/W  26-bits
// 0x0024    SMCTrCS2WTR3  R/W  26-bits
// 0x002C    SMCTrCS2WTR4  R/W  26-bits
// 0x0034    SMCTrCS2WTR5  R/W  26-bits
// 0x003C    SMCTrCS2WTR6  R/W  26-bits
// 0x0044    SMCTrCS2WTR7  R/W  26-bits
//
//           SMCTrCEWTRx   R/W  26-bits  This register determines the time
//                                       duration between counter expiry and
//                                       the SMWAIT de-assertion for Bank x.
//
// 0x0010    SMCTrCEWTR0   R/W  26-bits
// 0x0018    SMCTrCEWTR1   R/W  26-bits
// 0x0020    SMCTrCEWTR2   R/W  26-bits
// 0x0028    SMCTrCEWTR3   R/W  26-bits
// 0x0030    SMCTrCEWTR4   R/W  26-bits
// 0x0038    SMCTrCEWTR5   R/W  26-bits
// 0x0040    SMCTrCEWTR6   R/W  26-bits
// 0x0048    SMCTrCEWTR7   R/W  26-bits
//
// 0x004C    SMCTrMCREQD   R/W  5-bit    This register determines the time
//                                       duration between the access to the
//                                       address SMCTrMCBUSR and the MCBUSREQ
//                                       assertion.
//
// 0x0050    SMCTrGNT2RMREQ R/W 5-bit    This register determines the time
//                                       delay for the MCBUSREQ de-assertion
//                                       after getting the MCBUSGNT.
//
// 0x0054    SMCTrMCADDR   R/W  32-bits  This register holds the value to be
//                                       driven out through the MCADDR bus to
//                                       the SMC.
//
// 0x0058    SMCTrMCBUSR   R/W  32-bits  An access to this address causes the
//                                       MCBUSREQ line to go HIGH after a
//                                       delay. The delay is determined by the
//                                       value programmed in SMCTrMCREQD
//                                       register. A write access drives out
//                                       the written data to be driven out
//                                       through the MCDATAOUT lines to the
//                                       SMC. Switching between write and read
//                                       to this address toggles the MCDATAEN
//                                       lines.
//
// 0x005C   SMCTrCNCLWAIT  R/W   5- bit   CANCELSMWAIT is enabled and also 
//                                       counter value is loaded.
// 0x0060   SMCTrEBICntl   R/W   11-bit  This gives the delay for SMBUSGNTEBI
//                                       signal assertion time and deassertion 
//                                       time.
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
// Zero fill for register reads to return zeros in unused bit positions
// -----------------------------------------------------------------------------
`define ZEROFILL         32'h00000000

// -----------------------------------------------------------------------------
// Trickbox registers address constants. Address decode is for
// bits 2 to 4 (3 bits)
// -----------------------------------------------------------------------------
`define ADDR_SMCTrMWCS      5'b00000
// SMCTrMWCS at offset 0x0000

`define ADDR_SMCTrREMAP     5'b00001
// SMCTrRemap at offset 0x0004

`define ADDR_SMCTrENDIAN    5'b00010
// SMCTrEndian at offset 0x0008

`define ADDR_SMCTrCS2WTR0   5'b00011
// SMCTrCS2WT at offset 0x000C

`define ADDR_SMCTrCEWTR0    5'b00100
// SMCTrCEWT at offset 0x0010

`define ADDR_SMCTrCS2WTR1   5'b00101
// SMCTrCS2WT at offset 0x0014

`define ADDR_SMCTrCEWTR1    5'b00110
// SMCTrCEWT at offset 0x0018

`define ADDR_SMCTrCS2WTR2   5'b00111
// SMCTrCS2WT at offset 0x001C

`define ADDR_SMCTrCEWTR2    5'b01000
// SMCTrCEWT at offset 0x0020

`define ADDR_SMCTrCS2WTR3   5'b01001
// SMCTrCS2WT at offset 0x0024

`define ADDR_SMCTrCEWTR3    5'b01010
// SMCTrCEWT at offset 0x0028

`define ADDR_SMCTrCS2WTR4   5'b01011
// SMCTrCS2WT at offset 0x002C

`define ADDR_SMCTrCEWTR4    5'b01100
// SMCTrCEWT at offset 0x0030

`define ADDR_SMCTrCS2WTR5   5'b01101
// SMCTrCS2WT at offset 0x0034

`define ADDR_SMCTrCEWTR5    5'b01110
// SMCTrCEWT at offset 0x0038

`define ADDR_SMCTrCS2WTR6   5'b01111
// SMCTrCS2WT at offset 0x003C

`define ADDR_SMCTrCEWTR6    5'b10000
// SMCTrCEWT at offset 0x0040

`define ADDR_SMCTrCS2WTR7   5'b10001
// SMCTrCS2WT at offset 0x0044

`define ADDR_SMCTrCEWTR7    5'b10010
// SMCTrCEWT at offset 0x0048

`define ADDR_SMCTrMCREQD    5'b10011
// SMCTrMCREQD at offset 0x004C

`define ADDR_SMCTrGNT2RMREQ 5'b10100
// SMCTrGNT2RMREQ at offset 0x0050

`define ADDR_SMCTrMCADDR    5'b10101
// SMCTrMCBUSR at offset 0x0054

`define ADDR_SMCTrMCBUSR    5'b10110
// SMCTrMCBUSR at offset 0x0058

`define ADDR_SMCTrCNCLWAIT  5'b10111
// SMCTrMCBUSR at offset 0x005c

`define ADDR_SMCTrEBICntl  5'b11000
// SMCTrMCBUSR at offset 0x0060

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        Wait4GNT;
// Indicates that the device is waiting for the SMBUSGNT assertion

wire        Wait4GNTRm;
// Indicates that the device is waiting for the SMBUSGNT de-assertion

wire        NxtSMCTrEndian;
// D-input of SMCTrEndian Register

wire [25:0] NxtSMCTrCS2WTR0;
// D-input for the SMCTrCS2WT Register for Bank 0

wire [23:0] NxtSMCTrCEWTR0;
// D-input for the SMCTrCEWT Register for Bank 0

wire [25:0] NxtSMCTrCS2WTR1;
// D-input for the SMCTrCS2WT Register for Bank 1

wire [23:0] NxtSMCTrCEWTR1;
// D-input for the SMCTrCEWT Register for Bank 1

wire [25:0] NxtSMCTrCS2WTR2;
// D-input for the SMCTrCS2WT Register for Bank 2

wire [23:0] NxtSMCTrCEWTR2;
// D-input for the SMCTrCEWT Register for Bank 2

wire [25:0] NxtSMCTrCS2WTR3;
// D-input for the SMCTrCS2WT Register for Bank 3

wire [23:0] NxtSMCTrCEWTR3;
// D-input for the SMCTrCEWT Register for Bank 3

wire [25:0] NxtSMCTrCS2WTR4;
// D-input for the SMCTrCS2WT Register for Bank 4

wire [23:0] NxtSMCTrCEWTR4;
// D-input for the SMCTrCEWT Register for Bank 4

wire [25:0] NxtSMCTrCS2WTR5;
// D-input for the SMCTrCS2WT Register for Bank 5

wire [23:0] NxtSMCTrCEWTR5;
// D-input for the SMCTrCEWT Register for Bank 5

wire [25:0] NxtSMCTrCS2WTR6;
// D-input for the SMCTrCS2WT Register for Bank 6

wire [23:0] NxtSMCTrCEWTR6;
// D-input for the SMCTrCEWT Register for Bank 6

wire [25:0] NxtSMCTrCS2WTR7;
// D-input for the SMCTrCS2WT Register for Bank 7

wire [23:0] NxtSMCTrCEWTR7;
// D-input for the SMCTrCEWT Register for Bank 7

wire  [4:0] NxtSMCTrMCREQD;
// D-input for the SMCTrMCREQD Register

wire  [4:0] NxtSMCTrGNT2RMRQ;
// D-input for the SMCTrGNT2RMREQ Register

wire [25:0] NxtSMCTrMCADDR;
// D-input for the SMCTrMCADDR Register

wire [31:0] NxtSMCTrMCDATA;
// D-input for the SMCTrMCDATAOUT Register

wire [5:0] NxtSMCTrCNCLWAIT;
// D-input for the NxtSMCTrCNCLWAIT Register

wire [11:0] NxtSMCTrEBICntl;
// D-input for the SMCTrEBICntl Register

wire        SMCTrMWCSRd;
// SMCTrMWCS Read

wire        SMCTrRemapRd;
// SMCTrRemap Read

wire        SMCTrEndianRd;
// SMCTrEndian Read

wire        SMCTrCS2WTR0Rd;
// SMCTrCS2WTR0 Read

wire        SMCTrCEWTR0Rd;
// SMCTrCEWTR0 Read

wire        SMCTrCS2WTR1Rd;
// SMCTrCS2WTR1 Read

wire        SMCTrCEWTR1Rd;
// SMCTrCEWTR1 Read

wire        SMCTrCS2WTR2Rd;
// SMCTrCS2WTR2 Read

wire        SMCTrCEWTR2Rd;
// SMCTrCEWTR2 Read

wire        SMCTrCS2WTR3Rd;
// SMCTrCS2WTR3 Read

wire        SMCTrCEWTR3Rd;
// SMCTrCEWTR3 Read

wire        SMCTrCS2WTR4Rd;
// SMCTrCS2WTR4 Read

wire        SMCTrCEWTR4Rd;
// SMCTrCEWTR4 Read

wire        SMCTrCS2WTR5Rd;
// SMCTrCS2WTR5 Read

wire        SMCTrCEWTR5Rd;
// SMCTrCEWTR5 Read

wire        SMCTrCS2WTR6Rd;
// SMCTrCS2WTR6 Read

wire        SMCTrCEWTR6Rd;
// SMCTrCEWTR6 Read

wire        SMCTrCS2WTR7Rd;
// SMCTrCS2WTR7 Read

wire        SMCTrCEWTR7Rd;
// SMCTrCEWTR7 Read

wire        SMCTrMCREQDRd;
// SMCTrMCREQD Read

wire        SMCTrGNT2RMREQRd;
// SMCTrGNT2RMREQ Read

wire        SMCTrMCADDRRd;
// SMCTrMCADDR Read

wire        iSMCTrMCBUSRRd;
// Internal version of SMCTrMCBUSRRd

wire        iSMCTrCNCLWAITRd;
// Internal version of SMCTrCNCLWAITRd 

wire        iSMCTrEBICntlRd;
// Internal version of SMCTrEBICntlRd

wire        SMCTrMWCSWr;
// SMCTrMWCS Write

wire        SMCTrRemapWr;
// SMCTrRemap Write

wire        SMCTrEndianWr;
// SMCTrEndian Write

wire        SMCTrCS2WTR0Wr;
// SMCTrCS2WTR0 Write

wire        SMCTrCEWTR0Wr;
// SMCTrCEWTR0 Write

wire        SMCTrCS2WTR1Wr;
// SMCTrCS2WTR1 Write

wire        SMCTrCEWTR1Wr;
// SMCTrCEWTR1 Write

wire        SMCTrCS2WTR2Wr;
// SMCTrCS2WTR2 Write

wire        SMCTrCEWTR2Wr;
// SMCTrCEWTR2 Write

wire        SMCTrCS2WTR3Wr;
// SMCTrCS2WTR3 Write

wire        SMCTrCEWTR3Wr;
// SMCTrCEWTR3 Write

wire        SMCTrCS2WTR4Wr;
// SMCTrCS2WTR4 Write

wire        SMCTrCEWTR4Wr;
// SMCTrCEWTR4 Write

wire        SMCTrCS2WTR5Wr;
// SMCTrCS2WTR5 Write

wire        SMCTrCEWTR5Wr;
// SMCTrCEWTR5 Write

wire        SMCTrCS2WTR6Wr;
// SMCTrCS2WTR6 Write

wire        SMCTrCEWTR6Wr;
// SMCTrCEWTR6 Write

wire        SMCTrCS2WTR7Wr;
// SMCTrCS2WTR7 Write

wire        SMCTrCEWTR7Wr;
// SMCTrCEWTR7 Write

wire        SMCTrMCREQDWr;
// SMCTrMCREQD Write

wire        SMCTrGNT2RMREQWr;
// SMCTrGNT2RMREQ Write

wire        SMCTrMCADDRWr;
// SMCTrMCADDR Write

wire        iSMCTrMCBUSRWr;
// Internal version of SMCTrMCBUSRWr

wire        iSMCTrCNCLWAITWr;
// Internal version of iSMCTrCNCLWAITWr 

wire        iSMCTrEBICntlWr;
//Internal version of iSMCTrEBICntlWr
// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg   [1:0] NxtSMCTrMWCS;
// D-input of SMCTrMWCS Register

reg         NxtSMCTrRemap;
// D-input of SMCTrRemap Register

reg   [6:2] iLatchHADDR;
// Latched version of HADDR

reg   [1:0] iHRESP;
// Indicates the type of response for a transfer

reg   [1:0] SMCTrMWCS;
// SMCTrMWCS Register

reg         SMCTrRemap;
// SMCTrRemap Register

reg         SMCTrEndian;
// SMCTrEndian Register

reg  [25:0] iSMCTrCS2WTR0;
// Internal version of SMCTrCS2WT Register for Bank 0

reg  [23:0] iSMCTrCEWTR0;
// Internal version of SMCTrCEWT Register for Bank 0

reg  [25:0] iSMCTrCS2WTR1;
// Internal version of SMCTrCS2WT Register for Bank 1

reg  [23:0] iSMCTrCEWTR1;
// Internal version of SMCTrCEWT Register for Bank 1

reg  [25:0] iSMCTrCS2WTR2;
// Internal version of SMCTrCS2WT Register for Bank 2

reg  [23:0] iSMCTrCEWTR2;
// Internal version of SMCTrCEWT Register for Bank 2

reg  [25:0] iSMCTrCS2WTR3;
// Internal version of SMCTrCS2WT Register for Bank 3

reg  [23:0] iSMCTrCEWTR3;
// Internal version of SMCTrCEWT Register for Bank 3

reg  [25:0] iSMCTrCS2WTR4;
// Internal version of SMCTrCS2WT Register for Bank 4

reg  [23:0] iSMCTrCEWTR4;
// Internal version of SMCTrCEWT Register for Bank 4

reg  [25:0] iSMCTrCS2WTR5;
// Internal version of SMCTrCS2WT Register for Bank 5

reg  [23:0] iSMCTrCEWTR5;
// Internal version of SMCTrCEWT Register for Bank 5

reg  [25:0] iSMCTrCS2WTR6;
// Internal version of SMCTrCS2WT Register for Bank 6

reg  [23:0] iSMCTrCEWTR6;
// Internal version of SMCTrCEWT Register for Bank 6

reg  [25:0] iSMCTrCS2WTR7;
// Internal version of SMCTrCS2WT Register for Bank 7

reg  [23:0] iSMCTrCEWTR7;
// Internal version of SMCTrCEWT Register for Bank 7

reg   [4:0] iSMCTrMCREQD;
// Internal version of SMCTrMCREQD Register

reg   [4:0] iSMCTrGNT2RMREQ;
// Internal version of SMCTrGNT2RMREQ Register

reg  [25:0] iSMCTrMCADDR;
// Internal version of SMCTrMCADDR Register

reg  [31:0] iSMCTrMCDATA;
// Internal version of SMCTrMCDATAOUT Register

reg  [5:0] iSMCTrCNCLWAIT;
// Internal version of SMCTrCNCLWAIT Register

reg  [11:0] iSMCTrEBICntl;
// Internal version of SMCTrEBICntl Register

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
  SMCTrRemap    = 1'b1;
  NxtSMCTrRemap = 1'b1;
  SMCTrMWCS     = 2'b10;
  NxtSMCTrMWCS  = 2'b10;
end

// -----------------------------------------------------------------------------
// Write enables for registers
// -----------------------------------------------------------------------------
assign SMCTrMWCSWr      = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrMWCS)) ? 1'b1 : 1'b0;

assign SMCTrRemapWr     = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrREMAP)) ? 1'b1 : 1'b0;

assign SMCTrEndianWr    = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrENDIAN)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR0Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR0)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR0Wr    = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCEWTR0)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR1Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR1)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR1Wr    = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCEWTR1)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR2Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR2)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR2Wr    = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCEWTR2)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR3Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR3)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR3Wr    = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCEWTR3)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR4Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR4)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR4Wr    = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCEWTR4)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR5Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR5)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR5Wr    = ((WrEn == 1'b1) &
                          (iLatchHADDR == `ADDR_SMCTrCEWTR5)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR6Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR6)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR6Wr    = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCEWTR6)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR7Wr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR7)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR7Wr    = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCEWTR7)) ? 1'b1 : 1'b0;

assign SMCTrMCREQDWr    = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrMCREQD)) ? 1'b1 : 1'b0;

assign SMCTrGNT2RMREQWr = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrGNT2RMREQ)) ? 1'b1 : 1'b0;

assign SMCTrMCADDRWr    = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrMCADDR)) ? 1'b1 : 1'b0;

assign iSMCTrMCBUSRWr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrMCBUSR)) ? 1'b1 : 1'b0;

assign iSMCTrCNCLWAITWr = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCNCLWAIT)) ? 1'b1 : 1'b0;

assign iSMCTrEBICntlWr = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrEBICntl)) ? 1'b1 : 1'b0;


// -----------------------------------------------------------------------------
// Read enables for registers
// -----------------------------------------------------------------------------
assign SMCTrMWCSRd      = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrMWCS)) ? 1'b1 : 1'b0;

assign SMCTrRemapRd     = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrREMAP)) ? 1'b1 : 1'b0;

assign SMCTrEndianRd    = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrENDIAN)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR0Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR0)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR0Rd    = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCEWTR0)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR1Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR1)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR1Rd    = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCEWTR1)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR2Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR2)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR2Rd    = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCEWTR2)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR3Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR3)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR3Rd    = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCEWTR3)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR4Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR4)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR4Rd    = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCEWTR4)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR5Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR5)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR5Rd    = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCEWTR5)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR6Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR6)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR6Rd    = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCEWTR6)) ? 1'b1 : 1'b0;

assign SMCTrCS2WTR7Rd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCS2WTR7)) ? 1'b1 : 1'b0;

assign SMCTrCEWTR7Rd    = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCEWTR7)) ? 1'b1 : 1'b0;

assign SMCTrMCREQDRd    = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrMCREQD)) ? 1'b1 : 1'b0;

assign SMCTrGNT2RMREQRd = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrGNT2RMREQ)) ? 1'b1 : 1'b0;

assign SMCTrMCADDRRd    = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrMCADDR)) ? 1'b1 : 1'b0;

assign iSMCTrMCBUSRRd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrMCBUSR)) ? 1'b1 : 1'b0;

assign iSMCTrCNCLWAITRd = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrCNCLWAIT)) ? 1'b1 : 1'b0;

assign iSMCTrEBICntlRd    = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_SMCTrEBICntl)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Output Mux
// When the peripheral is not being accessed, '0's are driven
// on the Read Databus (HRDATA)
// -----------------------------------------------------------------------------
assign HRDATA           = (SMCTrMWCSRd == 1'b1) ?
                           {30'b000000000000000000000000000000, SMCTrMWCS} :
                          ((SMCTrRemapRd == 1'b1) ?
                           {31'b0000000000000000000000000000000, SMCTrRemap} :
                          ((SMCTrEndianRd == 1'b1) ?
                           {31'b0000000000000000000000000000000, SMCTrEndian} :
                          ((SMCTrCS2WTR0Rd == 1'b1) ?
                           {10'b0000000000, iSMCTrCS2WTR0} :
                          ((SMCTrCEWTR0Rd == 1'b1) ?
                           {8'h00, iSMCTrCEWTR0} :
                          ((SMCTrCS2WTR1Rd == 1'b1) ?
                           {10'b0000000000, iSMCTrCS2WTR1} :
                          ((SMCTrCEWTR1Rd == 1'b1) ?
                           {8'h00, iSMCTrCEWTR1} :
                          ((SMCTrCS2WTR2Rd == 1'b1) ?
                           {10'b0000000000, iSMCTrCS2WTR2} :
                          ((SMCTrCEWTR2Rd == 1'b1) ?
                           {8'h00, iSMCTrCEWTR2} :
                          ((SMCTrCS2WTR3Rd == 1'b1) ?
                           {10'b0000000000, iSMCTrCS2WTR3} :
                          ((SMCTrCEWTR3Rd == 1'b1) ?
                           {8'h00, iSMCTrCEWTR3} :
                          ((SMCTrCS2WTR4Rd == 1'b1) ?
                           {10'b0000000000, iSMCTrCS2WTR4} :
                          ((SMCTrCEWTR4Rd == 1'b1) ?
                           {8'h00, iSMCTrCEWTR4} :
                          ((SMCTrCS2WTR5Rd == 1'b1) ?
                           {10'b0000000000, iSMCTrCS2WTR5} :
                          ((SMCTrCEWTR5Rd == 1'b1) ?
                           {8'h00, iSMCTrCEWTR5} :
                          ((SMCTrCS2WTR6Rd == 1'b1) ?
                           {10'b0000000000, iSMCTrCS2WTR6} :
                          ((SMCTrCEWTR6Rd == 1'b1) ?
                           {8'h00, iSMCTrCEWTR6} :
                          ((SMCTrCS2WTR7Rd == 1'b1) ?
                           {10'b0000000000, iSMCTrCS2WTR7} :
                          ((SMCTrCEWTR7Rd == 1'b1) ?
                           {8'h00, iSMCTrCEWTR7} :
                          ((SMCTrMCREQDRd == 1'b1) ?
                           {27'b000000000000000000000000000, iSMCTrMCREQD} :
                          ((SMCTrGNT2RMREQRd == 1'b1) ?
                           {27'b000000000000000000000000000, iSMCTrGNT2RMREQ} :
                          ((SMCTrMCADDRRd == 1'b1) ?
                           {6'b000000, iSMCTrMCADDR} : 
                           32'h00000000)))))))))))))))))))));

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
     iHRESP           <= 2'b00;
     HREADYOUT        <= 1'b1;
     WrEn             <= 1'b0;
     RdEn             <= 1'b0;
     ErrorLat         <= 1'b0;
     iLatchHADDR      <= 5'b00000;
    end
  else
    begin
      if ((iHRESP == `ERROR) && (HREADYIN == 1'b0) && (ErrorLat == 1'b1))
        begin
          iHRESP           <= `ERROR;
          HREADYOUT        <= 1'b1;
          WrEn             <= 1'b0;
          RdEn             <= 1'b0;
          ErrorLat         <= 1'b0;
        end
      else if (((HTRANS == `IDLE) || (HTRANS == `BUSY)) &&
               (HSELSMCTR == 1'b1) && (HREADYIN == 1'b1))
        begin
          iHRESP           <= `OKAY;
          HREADYOUT        <= 1'b1;
        end
      else if ((HREADYIN == 1'b1) & (HSELSMCTR == 1'b1))
        begin
          if (HSIZE == `WORD)
            begin
              HREADYOUT        <= 1'b1;
              iLatchHADDR      <= HADDR;
              iHRESP           <= `OKAY;
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
              iHRESP           <= `ERROR;
              HREADYOUT        <= 1'b0;
              WrEn             <= 1'b0;
              RdEn             <= 1'b0;
              ErrorLat         <= 1'b1;
              $display("Error Response from SMC trickbox slave");
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
// Combinational logic for all functional registers. When the respective
// write enable input is asserted, copy the contents of the HWDATA Bus into
// the corresponding registers.
// -----------------------------------------------------------------------------
always @(SMCTrMWCSWr or HWDATA or SMCTrMWCS)
begin : p_MWCSWrComb
  if (SMCTrMWCSWr == 1'b1)
    NxtSMCTrMWCS = HWDATA[1:0];
  else
    NxtSMCTrMWCS = SMCTrMWCS;
end // p_MWCSWrComb

always @(SMCTrRemapWr or HWDATA or SMCTrRemap)
begin : p_RemapWrComb
  if (SMCTrRemapWr == 1'b1)
    NxtSMCTrRemap = HWDATA[0];
  else
    NxtSMCTrRemap = SMCTrRemap;
end // p_RemapWrComb

assign NxtSMCTrEndian   = (SMCTrEndianWr == 1'b1) ? HWDATA[0]        :
                           SMCTrEndian;

assign NxtSMCTrCS2WTR0  = (SMCTrCS2WTR0Wr == 1'b1) ? HWDATA[25:0]    :
                           iSMCTrCS2WTR0;

assign NxtSMCTrCEWTR0   = (SMCTrCEWTR0Wr == 1'b1) ? HWDATA[23:0]     :
                           iSMCTrCEWTR0;

assign NxtSMCTrCS2WTR1  = (SMCTrCS2WTR1Wr == 1'b1) ? HWDATA[25:0]    :
                           iSMCTrCS2WTR1;

assign NxtSMCTrCEWTR1   = (SMCTrCEWTR1Wr == 1'b1) ? HWDATA[23:0]     :
                           iSMCTrCEWTR1;

assign NxtSMCTrCS2WTR2  = (SMCTrCS2WTR2Wr == 1'b1) ? HWDATA[25:0]    :
                           iSMCTrCS2WTR2;

assign NxtSMCTrCEWTR2   = (SMCTrCEWTR2Wr == 1'b1) ? HWDATA[23:0]     :
                           iSMCTrCEWTR2;

assign NxtSMCTrCS2WTR3  = (SMCTrCS2WTR3Wr == 1'b1) ? HWDATA[25:0]    :
                           iSMCTrCS2WTR3;

assign NxtSMCTrCEWTR3   = (SMCTrCEWTR3Wr == 1'b1) ? HWDATA[23:0]     :
                           iSMCTrCEWTR3;

assign NxtSMCTrCS2WTR4  = (SMCTrCS2WTR4Wr == 1'b1) ? HWDATA[25:0]    :
                           iSMCTrCS2WTR4;

assign NxtSMCTrCEWTR4   = (SMCTrCEWTR4Wr == 1'b1) ? HWDATA[23:0]     :
                           iSMCTrCEWTR4;

assign NxtSMCTrCS2WTR5  = (SMCTrCS2WTR5Wr == 1'b1) ? HWDATA[25:0]    :
                           iSMCTrCS2WTR5;

assign NxtSMCTrCEWTR5   = (SMCTrCEWTR5Wr == 1'b1) ? HWDATA[23:0]     :
                           iSMCTrCEWTR5;

assign NxtSMCTrCS2WTR6  = (SMCTrCS2WTR6Wr == 1'b1) ? HWDATA[25:0]    :
                           iSMCTrCS2WTR6;

assign NxtSMCTrCEWTR6   = (SMCTrCEWTR6Wr == 1'b1) ? HWDATA[23:0]     :
                           iSMCTrCEWTR6;

assign NxtSMCTrCS2WTR7  = (SMCTrCS2WTR7Wr == 1'b1) ? HWDATA[25:0]    :
                           iSMCTrCS2WTR7;

assign NxtSMCTrCEWTR7   = (SMCTrCEWTR7Wr == 1'b1) ? HWDATA[23:0]     :
                           iSMCTrCEWTR7;

assign NxtSMCTrMCREQD   = (SMCTrMCREQDWr == 1'b1) ? HWDATA[4:0]      :
                           iSMCTrMCREQD;

assign NxtSMCTrGNT2RMRQ = (SMCTrGNT2RMREQWr == 1'b1) ? HWDATA[4:0]   :
                           iSMCTrGNT2RMREQ;

assign NxtSMCTrMCADDR   = (SMCTrMCADDRWr == 1'b1) ? HWDATA[25:0]     :
                           iSMCTrMCADDR;

assign NxtSMCTrMCDATA   = ((iSMCTrMCBUSRRd == 1'b1) |
                           (iSMCTrMCBUSRWr == 1'b1)) ? HWDATA[31:0]  :
                           iSMCTrMCDATA;

assign NxtSMCTrCNCLWAIT = ((iSMCTrCNCLWAITRd == 1'b1) |
                           (iSMCTrCNCLWAITWr == 1'b1)) ? HWDATA[5:0]  :
                           iSMCTrCNCLWAIT;

assign NxtSMCTrEBICntl  = ((iSMCTrEBICntlRd  == 1'b1) |
                           (iSMCTrEBICntlWr  == 1'b1)) ? HWDATA[11:0]  :
                           iSMCTrEBICntl;

// -----------------------------------------------------------------------------
// Sequential process for all functional registers writes.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegUpdateSeq
  if (HRESETn == 1'b0)
  begin
     SMCTrEndian      <= 1'b0;
     iSMCTrCS2WTR0    <= 26'b00000000000000000000000000;
     iSMCTrCEWTR0     <= 24'h000000;
     iSMCTrCS2WTR1    <= 26'b00000000000000000000000000;
     iSMCTrCEWTR1     <= 24'h000000;
     iSMCTrCS2WTR2    <= 26'b00000000000000000000000000;
     iSMCTrCEWTR2     <= 24'h000000;
     iSMCTrCS2WTR3    <= 26'b00000000000000000000000000;
     iSMCTrCEWTR3     <= 24'h000000;
     iSMCTrCS2WTR4    <= 26'b00000000000000000000000000;
     iSMCTrCEWTR4     <= 24'h000000;
     iSMCTrCS2WTR5    <= 26'b00000000000000000000000000;
     iSMCTrCEWTR5     <= 24'h000000;
     iSMCTrCS2WTR6    <= 26'b00000000000000000000000000;
     iSMCTrCEWTR6     <= 24'h000000;
     iSMCTrCS2WTR7    <= 26'b00000000000000000000000000;
     iSMCTrCEWTR7     <= 24'h000000;
     iSMCTrMCREQD     <= 5'b00000;
     iSMCTrGNT2RMREQ  <= 5'b00000;
     iSMCTrMCADDR     <= 26'b00000000000000000000000000;
     iSMCTrMCDATA     <= 32'h00000000;
     iSMCTrCNCLWAIT   <= 6'b011111;
     iSMCTrEBICntl    <= 11'b00000000000;
    end
    else
    begin
     SMCTrMWCS        <= NxtSMCTrMWCS;
     SMCTrRemap       <= NxtSMCTrRemap;
     SMCTrEndian      <= NxtSMCTrEndian;
     iSMCTrCS2WTR0    <= NxtSMCTrCS2WTR0;
     iSMCTrCEWTR0     <= NxtSMCTrCEWTR0;
     iSMCTrCS2WTR1    <= NxtSMCTrCS2WTR1;
     iSMCTrCEWTR1     <= NxtSMCTrCEWTR1;
     iSMCTrCS2WTR2    <= NxtSMCTrCS2WTR2;
     iSMCTrCEWTR2     <= NxtSMCTrCEWTR2;
     iSMCTrCS2WTR3    <= NxtSMCTrCS2WTR3;
     iSMCTrCEWTR3     <= NxtSMCTrCEWTR3;
     iSMCTrCS2WTR4    <= NxtSMCTrCS2WTR4;
     iSMCTrCEWTR4     <= NxtSMCTrCEWTR4;
     iSMCTrCS2WTR5    <= NxtSMCTrCS2WTR5;
     iSMCTrCEWTR5     <= NxtSMCTrCEWTR5;
     iSMCTrCS2WTR6    <= NxtSMCTrCS2WTR6;
     iSMCTrCEWTR6     <= NxtSMCTrCEWTR6;
     iSMCTrCS2WTR7    <= NxtSMCTrCS2WTR7;
     iSMCTrCEWTR7     <= NxtSMCTrCEWTR7;
     iSMCTrMCREQD     <= NxtSMCTrMCREQD;
     iSMCTrGNT2RMREQ  <= NxtSMCTrGNT2RMRQ;
     iSMCTrMCADDR     <= NxtSMCTrMCADDR;
     iSMCTrMCDATA     <= NxtSMCTrMCDATA;
     iSMCTrCNCLWAIT   <= NxtSMCTrCNCLWAIT;
     iSMCTrEBICntl    <= NxtSMCTrEBICntl;
  end
end // p_RegUpdateSeq

// -----------------------------------------------------------------------------
// Assign local copies of signals to the outputs
// -----------------------------------------------------------------------------
assign HRESP            = iHRESP;
assign SMMWCS7          = SMCTrMWCS;
assign REMAP            = SMCTrRemap;
assign ENDIANCNT        = SMCTrEndian;
assign SMCTrCS2WTR0     = iSMCTrCS2WTR0;
assign SMCTrCEWTR0      = iSMCTrCEWTR0;
assign SMCTrCS2WTR1     = iSMCTrCS2WTR1;
assign SMCTrCEWTR1      = iSMCTrCEWTR1;
assign SMCTrCS2WTR2     = iSMCTrCS2WTR2;
assign SMCTrCEWTR2      = iSMCTrCEWTR2;
assign SMCTrCS2WTR3     = iSMCTrCS2WTR3;
assign SMCTrCEWTR3      = iSMCTrCEWTR3;
assign SMCTrCS2WTR4     = iSMCTrCS2WTR4;
assign SMCTrCEWTR4      = iSMCTrCEWTR4;
assign SMCTrCS2WTR5     = iSMCTrCS2WTR5;
assign SMCTrCEWTR5      = iSMCTrCEWTR5;
assign SMCTrCS2WTR6     = iSMCTrCS2WTR6;
assign SMCTrCEWTR6      = iSMCTrCEWTR6;
assign SMCTrCS2WTR7     = iSMCTrCS2WTR7;
assign SMCTrCEWTR7      = iSMCTrCEWTR7;
assign SMCTrMCREQD      = iSMCTrMCREQD;
assign SMCTrGNT2RMREQ   = iSMCTrGNT2RMREQ;
assign SMCTrMCADDR      = iSMCTrMCADDR;
assign SMCTrMCDATAOUT   = iSMCTrMCDATA;
assign SMCTrCNCLWAIT    = iSMCTrCNCLWAIT;
assign SMCTrEBICntl     = iSMCTrEBICntl;
assign SMCTrMCBUSRWr    = iSMCTrMCBUSRWr;
assign SMCTrCNCLWAITWr  = iSMCTrCNCLWAITWr;
assign SMCTrMCBUSRRd    = iSMCTrMCBUSRRd;
assign SMCTrCNCLWAITRd  = iSMCTrCNCLWAITRd;

endmodule
// --================================== End ==================================--
