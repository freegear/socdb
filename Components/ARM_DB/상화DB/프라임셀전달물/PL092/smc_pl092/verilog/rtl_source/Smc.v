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
// File Name              : Smc.v.rca
// File Revision          : 1.9
//
// Release Information    : PrimeCell(TM)-PL092-REL1v1
//
// -----------------------------------------------------------------------------
// Purpose :
//           This is the top level structural block of the ARM PrimeCell
//           Static Memory Controller Peripheral SMC_PL092.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module Smc (
// Inputs
            nHCLK,
            HCLK,
            HRESETn,
            HREADYIN,
            HADDR,
            HBURST,
            HTRANS,
            HWRITE,
            HSIZE,
            HWDATA,
            HSELSMC,
            HSELREG,
            HRESPTIC,
            HRDATATIC,
            HGRANTTIC,
            BIGENDIAN,
            REMAP,

            TICBUSGNTEBI,
            SMBUSGNTEBI,

            SCANENABLE,
            SCANINHCLK,
            SCANINnHCLK,

            SMWAIT,
            CANCELSMWAIT,
            SMMWCS7,
            SMDATAIN,
            TESTREQA,
            TESTREQB,

            MCBUSREQ,
            MCADDR,
            MCDATAOUT,
            MCDATAEN,

            EXTBUSMUX,

// Outputs
            HRDATA,
            HREADYOUT,
            HRESP,

            HADDRTIC,
            HTRANSTIC,
            HWRITETIC,
            HSIZETIC,
            HBURSTTIC,
            HPROTTIC,
            HWDATATIC,
            HBUSREQTIC,
            HLOCKTIC,

            TICBUSREQEBI,
            SMBUSREQEBI,

            SCANOUTnHCLK,
            SCANOUTHCLK,

            SMDATAOUT,
            nSMDATAEN,
            SMADDR,
            SMCS,
            nSMBLS,
            nSMWEN,
            nSMOEN,

            TICREADEBI,
            TBUSOUTEBI,
            TESTACK,

            MCBUSGNT
            );

// Inputs
input         nHCLK;           // Negative AHB Bus Clock
input         HCLK;            // AHB Bus Clock
input         HRESETn;         // AHB Bus Reset Signal
input         HREADYIN;        // Multiplexed HREADY input from all
                               // slaves
input  [28:0] HADDR;           // AHB Address Bus input to SMC
input   [2:0] HBURST;          // Information about the type of burst
                               // transfer from AHB
input   [1:0] HTRANS;          // AHB Bus Transfer type input to SMC
input         HWRITE;          // AHB Bus Transfer Direction input to SMC
input   [2:0] HSIZE;           // AHB Bus Transfer size input to SMC
input  [31:0] HWDATA;          // AHB Write Data input to SMC
input         HSELSMC;         // Device Select signal of Memorybank on
                               // AHB Bus
input         HSELREG;         // Device Select signal of Configuration
                               // registers on AHB Bus
input   [1:0] HRESPTIC;        // AHB Bus Transfer Response to TIC
input  [31:0] HRDATATIC;       // AHB Read Data Input to TIC
input         HGRANTTIC;       // AHB Bus Grant to the TIC
input         BIGENDIAN;       // Type of endianness of the system
input         REMAP;           // Indicates the state of the Memory map

input         TICBUSGNTEBI;    // Bus Grant input to TIC from external EbiSdram
input         SMBUSGNTEBI;     // Bus Grant input to SmcCore from external
                               // EbiSdram

input         SCANENABLE;      // Test Mode input
input         SCANINHCLK;      // Scan chain input with respect to HCLK
input         SCANINnHCLK;     // Scan chain input with respect to nHCLK


input         SMWAIT;          // Async Wait signal from external memory
                               // controller
input         CANCELSMWAIT;    // Asynchronous external input pin to
                               // signal that the SMWAIT has timed out
input   [1:0] SMMWCS7;         // Input pins used to program the memory
                               // width bit field of SMCBCR1 register
input  [31:0] SMDATAIN;        // Data from Memory to Smc

input         TESTREQA;        // Test bus request A
input         TESTREQB;        // Test bus request B

input         MCBUSREQ;        // Bus Request from the Additional Memory
                               // Controller
input  [25:0] MCADDR;          // Address Bus of the Additional Memory
                               // Controller 
input  [31:0] MCDATAOUT;       // Output Data Bus of the Additional Memory
                               // Controller
input   [3:0] MCDATAEN;        // Pad enables from the Additional Memory
                               // Controller

input         EXTBUSMUX;       // This tied input will determine whether the
                               // internal DBI or external EbiSdram will be
                               // used for bus arbitration

// Outputs
output [31:0] HRDATA;          // AHB Read Data output from SMC
output        HREADYOUT;       // Signal from the SMC to indicate the
                               // completion of the transfer
output  [1:0] HRESP;           // AHB Bus Transfer Response from the SMC

output [31:0] HADDRTIC;        // AHB Address output from TIC
output  [1:0] HTRANSTIC;       // AHB Transfer type output from TIC
output        HWRITETIC;       // AHB Transfer Direction output from TIC
output  [2:0] HSIZETIC;        // AHB Transfer Size output from TIC
output  [2:0] HBURSTTIC;       // AHB Burst Type output from TIC
output  [3:0] HPROTTIC;        // AHB Protection control signal
output [31:0] HWDATATIC;       // AHB Write Data output from TIC
output        HBUSREQTIC;      // AHB Bus Request
output        HLOCKTIC;        // AHB signal indicating Locked access to
                               // the Bus

output        TICBUSREQEBI;    // External Data bus request signal from TIC
                               // to the EbiSdram
output        SMBUSREQEBI;     // External Data bus request signal from SmcCore
                               // to the EbiSdram

output        SCANOUTnHCLK;    // Scan chain output with respect to nHCLK
output        SCANOUTHCLK;     // Scan chain output with respect to HCLK


output [31:0] SMDATAOUT;       // Data Bus output from SMC to Memory
output  [3:0] nSMDATAEN;       // Tri-state I/O pad enable for the byte
                               // lanes of external memory data bus
output [25:0] SMADDR;          // External Memory address bus
output  [7:0] SMCS;            // Memory bank Chip Select output pins
output  [3:0] nSMBLS;          // Memory device Byte lane enables
output        nSMWEN;          // Memory Write Enable
output        nSMOEN;          // Memory Output Enable

output        TICREADEBI;      // Pad Enable signal from TIC when EbiSdram is
                               // used
output [31:0] TBUSOUTEBI;      // Data bus output from the TIC when EbiSdram is
                               // used
output        TESTACK;         // Test acknowledge

output        MCBUSGNT;        // Bus Grant to Additional Memory Controller


// Inputs
wire          nHCLK;           // Negative AHB Bus Clock
wire          HCLK;            // AHB Bus Clock
wire          HRESETn;         // AHB Bus Reset Signal
wire          HREADYIN;        // Multiplexed HREADY input from all
                               // slaves
wire   [28:0] HADDR;           // AHB Address Bus input to SMC
wire    [2:0] HBURST;          // Information about the type of burst
                               // transfer from AHB
wire    [1:0] HTRANS;          // AHB Bus Transfer type input to SMC
wire          HWRITE;          // AHB Bus Transfer Direction input to SMC
wire    [2:0] HSIZE;           // AHB Bus Transfer size input to SMC
wire   [31:0] HWDATA;          // AHB Write Data input to SMC
wire          HSELSMC;         // Device Select signal of Memorybank on
                               // AHB Bus
wire          HSELREG;         // Device Select signal of Configuration
                               // registers on AHB Bus
wire    [1:0] HRESPTIC;        // AHB Bus Transfer Response to TIC
wire   [31:0] HRDATATIC;       // AHB Read Data Input to TIC
wire          HGRANTTIC;       // AHB Bus Grant to the TIC
wire          BIGENDIAN;       // Type of endianness of the system
wire          REMAP;           // Indicates the state of the Memory map

wire          TICBUSGNTEBI;    // Bus Grant input to TIC from external EbiSdram
wire          SMBUSGNTEBI;     // Bus Grant input to SmcCore from external
                               // EbiSdram

wire          SCANENABLE;      // Test Mode input
wire          SCANINHCLK;      // Scan chain input with respect to HCLK
wire          SCANINnHCLK;     // Scan chain input with respect to nHCLK


wire          SMWAIT;          // Async Wait signal from external memory
                               // controller
wire          CANCELSMWAIT;    // Asynchronous external input pin to
                               // signal that the SMWAIT has timed out
wire    [1:0] SMMWCS7;         // Input pins used to program the memory
                               // width bit field of SMCBCR1 register
wire   [31:0] SMDATAIN;        // Data from Memory to Smc

wire          TESTREQA;        // Test bus request A
wire          TESTREQB;        // Test bus request B

wire          MCBUSREQ;        // Bus Request from Additional Memory
                               // Controller
wire   [25:0] MCADDR;          // Additional Memory Controller Address Bus
wire   [31:0] MCDATAOUT;       // Additional Memory controller Output Data Bus
wire    [3:0] MCDATAEN;        // Pad enables from Additional Memory
                               // Controller

wire          EXTBUSMUX;       // This tied input will determine whether the
                               // internal DBI or external EbiSdram will be
                               // used for bus arbitration


// Outputs
wire   [31:0] HRDATA;          // AHB Read Data output from SMC
wire          HREADYOUT;       // Signal from the SMC to indicate the
                               // completion of the transfer
wire    [1:0] HRESP;           // AHB Bus Transfer Response from the SMC
wire   [31:0] HADDRTIC;        // AHB Address output from TIC
wire    [1:0] HTRANSTIC;       // AHB Transfer type output from TIC
wire          HWRITETIC;       // AHB Transfer Direction output from TIC
wire    [2:0] HSIZETIC;        // AHB Transfer Size output from TIC
wire    [2:0] HBURSTTIC;       // AHB Burst Type output from TIC
wire    [3:0] HPROTTIC;        // AHB Protection control signal
wire   [31:0] HWDATATIC;       // AHB Write Data output from TIC
wire          HBUSREQTIC;      // AHB Bus Request
wire          HLOCKTIC;        // AHB signal indicating Locked access to
                               // the Bus

wire          TICBUSREQEBI;    // External Data bus request signal from TIC
                               // to the EbiSdram
wire          SMBUSREQEBI;     // External Data bus request signal from SmcCore
                               // to the EbiSdram

wire          SCANOUTnHCLK;    // Scan chain output with respect to nHCLK
wire          SCANOUTHCLK;     // Scan chain output with respect to HCLK


wire   [31:0] SMDATAOUT;       // Data Bus output from SMC to Memory
wire    [3:0] nSMDATAEN;       // Tri-state I/O pad enable for the byte
                               // lanes of external memory data bus
wire   [25:0] SMADDR;          // External Memory address bus
wire    [7:0] SMCS;            // Memory bank Chip Select output pins
wire    [3:0] nSMBLS;          // Memory device Byte lane enables
wire          nSMWEN;          // Memory Write Enable
wire          nSMOEN;          // Memory Output Enable

wire          TICREADEBI;      // Pad Enable signal from TIC when EbiSdram is
                               // used
wire   [31:0] TBUSOUTEBI;      // Data bus output from the TIC when EbiSdram is
                               // used
wire          TESTACK;         // Test acknowledge

wire          MCBUSGNT;        // Bus Grant to Additional Memory Controller


// -----------------------------------------------------------------------------
//
//                                   Smc
//                                   ===
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//         The ARM SMC PrimeCell peripheral SMC_PL092 contains the
//         the following main modules :
//         1. SmcCore - This is the main static memory controller core
//         2. TIC - The test interface controller block
//         3. DBI - The data bus interface block arbitrates between the
//                  SmcCore, TIC and additional Memory Controller blocks
//                  for the control of the external data bus
//         4. SmcRevAnd - This is used for the revision number setting
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        TICBUSREQ;
// TIC bus request to DBI

wire        SMBUSREQ;
// Bus request signal from SmcCore to DBI

wire        TICBUSGNT;
// Bus grant signal by the DBI to the TIC

wire        SMBUSGNT;
// Bus grant signal to SmcCore from DBI

wire  [3:0] nSMCDATAEN;
// Memory data bus driver enable when SmcCore has the control of the bus

wire        TICREAD;
// Drive AHB read data onto TBUSOUT

wire [31:0] SMCDATAOUT;
// Data from SmcCore to Memory through DBI

wire [31:0] TBUSOUT;
// External test vector output data bus

wire [25:0] SMCADDR;
// Address from SmcCore to Memory through DBI

wire  [3:0] TieOff1;
// Input 1 for SmcRevAnd

wire  [3:0] TieOff2;
// Input 2 for SmcRevAnd

wire  [3:0] Revision;
// Output of SmcRevAnd

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
// Instantiation of DBI
// -----------------------------------------------------------------------------
DBI uDBI
        (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),

        .TICBUSREQ       (TICBUSREQ),
        .SMBUSREQ        (SMBUSREQ),
        .MCBUSREQ        (MCBUSREQ),
        .TICBUSGNTEBI    (TICBUSGNTEBI),
        .SMBUSGNTEBI     (SMBUSGNTEBI),
        .nSMCDATAEN      (nSMCDATAEN),
        .MCDATAEN        (MCDATAEN),
        .TICREAD         (TICREAD),
        .SMCDATAOUT      (SMCDATAOUT),
        .MCDATAOUT       (MCDATAOUT),
        .TBUSOUT         (TBUSOUT),
        .SMCADDR         (SMCADDR),
        .MCADDR          (MCADDR),
        .EXTBUSMUX       (EXTBUSMUX),

        .TICBUSREQEBI    (TICBUSREQEBI),
        .SMBUSREQEBI     (SMBUSREQEBI),
        .TICBUSGNT       (TICBUSGNT),
        .SMBUSGNT        (SMBUSGNT),
        .MCBUSGNT        (MCBUSGNT),
        .nSMDATAEN       (nSMDATAEN),
        .TICREADEBI      (TICREADEBI),
        .SMDATAOUT       (SMDATAOUT),
        .TBUSOUTEBI      (TBUSOUTEBI),
        .SMADDR          (SMADDR)
        );

// -----------------------------------------------------------------------------
// Instantiation of TIC
// -----------------------------------------------------------------------------
TIC uTIC
        (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HREADYIN        (HREADYIN),
        .HRESPTIC        (HRESPTIC),
        .HGRANTTIC       (HGRANTTIC),
        .HRDATATIC       (HRDATATIC),

        .TBUSIN          (SMDATAIN),
        .TESTREQA        (TESTREQA),
        .TESTREQB        (TESTREQB),
        .TICBUSGNT       (TICBUSGNT),

        .HADDRTIC        (HADDRTIC),
        .HTRANSTIC       (HTRANSTIC),
        .HWRITETIC       (HWRITETIC),
        .HSIZETIC        (HSIZETIC),
        .HBURSTTIC       (HBURSTTIC),
        .HPROTTIC        (HPROTTIC),
        .HWDATATIC       (HWDATATIC),
        .HBUSREQTIC      (HBUSREQTIC),
        .HLOCKTIC        (HLOCKTIC),

        .TBUSOUT         (TBUSOUT),
        .TESTACK         (TESTACK),
        .TICBUSREQ       (TICBUSREQ),
        .TICREAD         (TICREAD)
        );

// -----------------------------------------------------------------------------
// Instantiation of SmcCore
// -----------------------------------------------------------------------------
SmcCore uSmcCore
        (
        .nHCLK           (nHCLK),
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HREADYIN        (HREADYIN),
        .HADDR           (HADDR),
        .HBURST          (HBURST),
        .HTRANS          (HTRANS),
        .HSIZE           (HSIZE),
        .HWRITE          (HWRITE),
        .HWDATA          (HWDATA),
        .HSELSMC         (HSELSMC),
        .HSELREG         (HSELREG),
        .BIGENDIAN       (BIGENDIAN),
        .REMAP           (REMAP),
        .Revision        (Revision),

        .SMWAIT          (SMWAIT),
        .CANCELSMWAIT    (CANCELSMWAIT),
        .SMMWCS7         (SMMWCS7),
        .SMCDATAIN       (SMDATAIN),
        .SMBUSGNT        (SMBUSGNT),
        .HRDATA          (HRDATA),
        .HREADYOUT       (HREADYOUT),
        .HRESP           (HRESP),
        .nSMCDATAEN      (nSMCDATAEN),
        .nSMWEN          (nSMWEN),
        .nSMOEN          (nSMOEN),
        .SMBUSREQ        (SMBUSREQ),
        .SMCDATAOUT      (SMCDATAOUT),
        .SMCS            (SMCS),
        .nSMBLS          (nSMBLS),
        .SMCADDR         (SMCADDR)
        );

// -----------------------------------------------------------------------------
// Instantiation of SmcRevAnd for bit 0 of Revision
// -----------------------------------------------------------------------------
SmcRevAnd u0SmcRevAnd
        (
        .TieOff1         (TieOff1[0]),
        .TieOff2         (TieOff2[0]),
        .Revision        (Revision[0])
        );

// -----------------------------------------------------------------------------
// Instantiation of SmcRevAnd for bit 1 of Revision
// -----------------------------------------------------------------------------
SmcRevAnd u1SmcRevAnd
        (
        .TieOff1         (TieOff1[1]),
        .TieOff2         (TieOff2[1]),
        .Revision        (Revision[1])
        );

// -----------------------------------------------------------------------------
// Instantiation of SmcRevAnd for bit 2 of Revision
// -----------------------------------------------------------------------------
SmcRevAnd u2SmcRevAnd
        (
        .TieOff1         (TieOff1[2]),
        .TieOff2         (TieOff2[2]),
        .Revision        (Revision[2])
        );

// -----------------------------------------------------------------------------
// Instantiation of SmcRevAnd for bit 3 of Revision
// -----------------------------------------------------------------------------
SmcRevAnd u3SmcRevAnd
        (
        .TieOff1         (TieOff1[3]),
        .TieOff2         (TieOff2[3]),
        .Revision        (Revision[3])
        );

// -----------------------------------------------------------------------------
// Assign values to inputs of RevAnd
// -----------------------------------------------------------------------------
assign TieOff1          = 4'b0000;
assign TieOff2          = 4'b0000;

endmodule
// --============================ End Smc.vhd  ===============================--
