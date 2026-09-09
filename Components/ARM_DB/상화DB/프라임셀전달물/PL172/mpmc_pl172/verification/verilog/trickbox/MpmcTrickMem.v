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
// File Name              : MpmcTrickMem.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module is the top level MPMC Trickbox Memory model.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MpmcTrickMem (
// Inputs
                     HCLK,
                     HRESETn,
                     HADDR,
                     HTRANS,
                     HWRITE,
                     HSIZE,
                     HBURST,
                     HREADYIN,
                     HWDATA,
                     HSELMPMCTRMEM,
                     MPMCADDR,
                     nMPMCDATAEN,
                     nMPMCWEN,
                     nMPMCOEN,
                     nMPMCBLS,
                     MPMCTrAllCS,
                     MPMCTrCS,
                     MPMCTrStExtWt,

// Inouts
                     MPMCDATA,

// Outputs
                     HRDATA,
                     HREADYOUT,
                     HRESP,

                     MPMCActLowCS
                    );

parameter Tclk = 10.52;         // HCLK Period

// Inputs
input         HCLK;             // AHB Clock
input         HRESETn;          // Bus Reset
input  [15:0] HADDR;            // AHB Address Bus
input   [1:0] HTRANS;           // Transfer type
input         HWRITE;           // AHB Peripheral Write
input   [2:0] HSIZE;            // Transfer size
input   [2:0] HBURST;           // Burst Type
input         HREADYIN;         // Multiplexed version of HREADY outputs
input  [31:0] HWDATA;           // AHB Write Data bus
input         HSELMPMCTRMEM;    // AHB Peripheral (TrickMem) Select
input  [27:0] MPMCADDR;         // Memory Address Bus
input   [3:0] nMPMCDATAEN;      // Memory Bus Enable
input         nMPMCWEN;         // Write Enable for the external Memory bank
input         nMPMCOEN;         // Output Enable for the external Memory bank
input   [3:0] nMPMCBLS;         // Byte Enables for the external Memory bank
input   [7:0] MPMCTrAllCS;      // The CS status of all the eight banks
                                // connected with the MPMC
input         MPMCTrCS;         // Individual select line for a TrickMem
input   [9:0] MPMCTrStExtWt;    // MPMCTrExtWait Register

// Inouts
inout  [31:0] MPMCDATA;         // Memory Data Bus

// Outputs
output [31:0] HRDATA;           // AHB Read Data bus
output        HREADYOUT;        // Slave HREADY output
output  [1:0] HRESP;            // Slave response
output        MPMCActLowCS;     // Used for suitably routing the
                                // MPMCTrWAIT as the final MPMCWAIT at the
                                // top-level of the tbench

// Inputs
wire          HCLK;             // AHB Clock
wire          HRESETn;          // Bus Reset
wire   [15:0] HADDR;            // AHB Address Bus
wire    [1:0] HTRANS;           // Transfer type
wire        HWRITE;             // AHB Peripheral Write
wire    [2:0] HSIZE;            // Transfer size
wire    [2:0] HBURST;           // Burst Type
wire          HREADYIN;         // Multiplexed version of HREADY outputs
wire   [31:0] HWDATA;           // AHB Write Data bus
wire          HSELMPMCTRMEM;    // AHB Peripheral (TrickMem) Select
wire   [27:0] MPMCADDR;         // Memory Address Bus
wire    [3:0] nMPMCDATAEN;      // Memory Bus Enable
wire          nMPMCWEN;         // Write Enable for the external Memory bank
wire          nMPMCOEN;         // Output Enable for the external Memory bank
wire    [3:0] nMPMCBLS;         // Byte Enables for the external Memory bank
wire    [7:0] MPMCTrAllCS;      // The CS status of all the eight banks
                                // connected with the MPMC
wire          MPMCTrCS;         // Individual select line for a TrickMem
wire    [9:0] MPMCTrStExtWt;    // MPMCTrExtWait Register

// Inouts
wire   [31:0] MPMCDATA;         // Memory Data Bus

// Outputs
wire   [31:0] HRDATA;           // AHB Read Data bus
wire          HREADYOUT;        // Slave HREADY output
wire    [1:0] HRESP;            // Slave response
wire          MPMCActLowCS;     // Used for suitably routing the
                                // MPMCTrWAIT as the final MPMCWAIT at the
                                // top-level of the tbench

// -----------------------------------------------------------------------------
//
//                                MpmcTrickMem
//                                ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block is the top level of the MPMC Trickbox Memory Model. This block
// instantiates the following sub-blocks:
//
// 1. MpmcTrMemAhbifReg - AHB Interface and Register Block
// 2. MpmcTrMemRdWrCtl  - Memory Read/Write Control and Timing checks
// 3. MpmcTrMemArray    - Memory Element
// 4. MpmcTrPackage     - Constant declaration
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire   [15:0] LatchHADDR;
// Latched AHB Address. This is used when the memory is accessed via AHB

wire    [4:0] MPMCTrIDCY;
// Memory data bus turn around time count

wire    [5:0] MPMCTrWaitRd;
// Initial Access time count in case of BROMs
// Read Access time count in case of SRAMs or ROMs

wire    [5:0] MPMCTrWaitWr;
// Write access time count in case of SRAM
// Burst access time count in case of BROMs
// Insignificant in case of ROMs

wire    [5:0] MPMCTrWaitPg;
// Page mode access delay

wire   [10:0] MPMCTrMEMT;
// Memory type specifier

wire   [16:0] MPMCTrMEMB;
// Memory Base Address

wire          MPMCTrMEMRWr;
// Memory Write Enable

wire    [4:0] MPMCTrCS2OEN;
// Chip Select to Output Enable delay count

wire    [4:0] MPMCTrCS2WEN;
// Chip Select to Write Enable delay count

wire    [7:0] MPMCTrCSPOL;
// Chip Select Polarity Select

wire   [10:0] LatchMCADDR;
// Latched Memory Address Bus

wire    [7:0] AhbRdDatab0;
// BYTE0 of 32 bits AHB Read Data

wire    [7:0] AhbRdDatab1;
// BYTE1 of 32 bits AHB Read Data

wire    [7:0] AhbRdDatab2;
// BYTE2 of 32 bits AHB Read Data

wire    [7:0] AhbRdDatab3;
// BYTE3 of 32 bits AHB Read Data

wire    [7:0] MemRdDatab0;
// BYTE0 of 32 bits Memory Read Data

wire    [7:0] MemRdDatab1;
// BYTE1 of 32 bits Memory Read Data

wire    [7:0] MemRdDatab2;
// BYTE2 of 32 bits Memory Read Data

wire    [7:0] MemRdDatab3;
// BYTE3 of 32 bits Memory Read Data

wire    [7:0] MemWrDatab0;
// BYTE0 of 32 bits Memory Write Data

wire    [7:0] MemWrDatab1;
// BYTE1 of 32 bits Memory Write Data

wire    [7:0] MemWrDatab2;
// BYTE2 of 32 bits Memory Write Data

wire    [7:0] MemWrDatab3;
// BYTE3 of 32 bits Memory Write Data

wire   [31:0] MemRdDataDW;
// 32 Bits Memory Read Data (Concatenation of MemRdDatab0-3)

wire   [31:0] AhbRdDataDW;
// 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

wire          RBLE;
// Read Byte Lane Enable signal

wire          nCS;
// Memory Chip Select signal (Active Low)

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg     [3:0] TrnMCBLS;
// Byte Lane Select signal whose value depend on RBLE

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


assign MemWrDatab0      = MPMCDATA[7:0];
assign MemWrDatab1      = MPMCDATA[15:8];
assign MemWrDatab2      = MPMCDATA[23:16];
assign MemWrDatab3      = MPMCDATA[31:24];
assign MemRdDataDW      = {MemRdDatab3, MemRdDatab2, MemRdDatab1,
                           MemRdDatab0};
assign AhbRdDataDW      = {AhbRdDatab3, AhbRdDatab2, AhbRdDatab1,
                           AhbRdDatab0};
assign RBLE             = MPMCTrMEMT[6];

// -----------------------------------------------------------------------------
// Write Enable selection according to the RBLE value
// -----------------------------------------------------------------------------
always @(RBLE or nMPMCBLS or nMPMCWEN)
begin : p_MPMCBLSComb
  if (RBLE == 1'b0)
    begin
      TrnMCBLS = nMPMCBLS;
    end
  else
    begin
      TrnMCBLS = nMPMCBLS | ({nMPMCWEN, nMPMCWEN, nMPMCWEN, nMPMCWEN});
    end
end // p_MPMCBLSComb

// -----------------------------------------------------------------------------
// Instantiation of the MPMC TrickMem AHB interface
// -----------------------------------------------------------------------------
MpmcTrMemAhbifReg uMpmcTrMemAhbifReg  (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HREADYIN         (HREADYIN),
                    .HWDATA           (HWDATA),
                    .HSELMPMCTRMEM    (HSELMPMCTRMEM),
                    .AhbRdDataDW      (AhbRdDataDW),
                    .HRDATA           (HRDATA),
                    .HREADYOUT        (HREADYOUT),
                    .HRESP            (HRESP),
                    .MPMCTrMEMRWr     (MPMCTrMEMRWr),
                    .LatchHADDR       (LatchHADDR),
                    .MPMCTrIDCY       (MPMCTrIDCY),
                    .MPMCTrWaitRd     (MPMCTrWaitRd),
                    .MPMCTrWaitWr     (MPMCTrWaitWr),
                    .MPMCTrWaitPg     (MPMCTrWaitPg),
                    .MPMCTrMEMT       (MPMCTrMEMT),
                    .MPMCTrMEMB       (MPMCTrMEMB),
                    .MPMCTrCS2OEN     (MPMCTrCS2OEN),
                    .MPMCTrCS2WEN     (MPMCTrCS2WEN),
                    .MPMCTrCSPOL      (MPMCTrCSPOL)
                    );

// -----------------------------------------------------------------------------
// Instantiation of the MPMC TrickMem Read/Write Control Block
// -----------------------------------------------------------------------------
defparam uMpmcTrMemRdWrCtl.Tclk = Tclk;
MpmcTrMemRdWrCtl uMpmcTrMemRdWrCtl    (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .MPMCADDR         (MPMCADDR),
                    .nMPMCDATAEN      (nMPMCDATAEN),
                    .MPMCTrCS         (MPMCTrCS),
                    .MPMCTrAllCS      (MPMCTrAllCS),
                    .nMPMCWEN         (nMPMCWEN),
                    .nMPMCBLS         (nMPMCBLS),
                    .nMPMCOEN         (nMPMCOEN),
                    .MemRdDataDW      (MemRdDataDW),
                    .MPMCTrIDCY       (MPMCTrIDCY),
                    .MPMCTrWaitRd     (MPMCTrWaitRd),
                    .MPMCTrWaitWr     (MPMCTrWaitWr),
                    .MPMCTrWaitPg     (MPMCTrWaitPg),
                    .MPMCTrMEMT       (MPMCTrMEMT),
                    .MPMCTrMEMB       (MPMCTrMEMB),
                    .MPMCTrCS2OEN     (MPMCTrCS2OEN),
                    .MPMCTrCS2WEN     (MPMCTrCS2WEN),
                    .MPMCTrExtWait    (MPMCTrStExtWt),
                    .MPMCTrCSPOL      (MPMCTrCSPOL),
                    .MPMCDATA         (MPMCDATA),
                    .LatchMCADDR      (LatchMCADDR),
                    .MPMCActLowCS     (nCS)
                    );

// -----------------------------------------------------------------------------
// 4 Instantiations of the Memory Element (Each of 2k depth)
// -----------------------------------------------------------------------------
MpmcTrMemArray u0MpmcTrMemArray       (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .nCS              (nCS),
                    .nMPMCBLS         (TrnMCBLS[0]),
                    .MPMCTrMEMRWr     (MPMCTrMEMRWr),
                    .LatchHADDR       (LatchHADDR[12:2]),
                    .LatchMCADDR      (LatchMCADDR),
                    .HWDATA           (HWDATA[7:0]),
                    .MemWrDatab       (MemWrDatab0),
                    .AhbRdDatab       (AhbRdDatab0),
                    .MemRdDatab       (MemRdDatab0)
                    );

MpmcTrMemArray u1MpmcTrMemArray       (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .nCS              (nCS),
                    .nMPMCBLS         (TrnMCBLS[1]),
                    .MPMCTrMEMRWr     (MPMCTrMEMRWr),
                    .LatchHADDR       (LatchHADDR[12:2]),
                    .LatchMCADDR      (LatchMCADDR),
                    .HWDATA           (HWDATA[15:8]),
                    .MemWrDatab       (MemWrDatab1),
                    .AhbRdDatab       (AhbRdDatab1),
                    .MemRdDatab       (MemRdDatab1)
                    );

MpmcTrMemArray u2MpmcTrMemArray       (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .nCS              (nCS),
                    .nMPMCBLS         (TrnMCBLS[2]),
                    .MPMCTrMEMRWr     (MPMCTrMEMRWr),
                    .LatchHADDR       (LatchHADDR[12:2]),
                    .LatchMCADDR      (LatchMCADDR),
                    .HWDATA           (HWDATA[23:16]),
                    .MemWrDatab       (MemWrDatab2),
                    .AhbRdDatab       (AhbRdDatab2),
                    .MemRdDatab       (MemRdDatab2)
                    );

MpmcTrMemArray u3MpmcTrMemArray       (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .nCS              (nCS),
                    .nMPMCBLS         (TrnMCBLS[3]),
                    .MPMCTrMEMRWr     (MPMCTrMEMRWr),
                    .LatchHADDR       (LatchHADDR[12:2]),
                    .LatchMCADDR      (LatchMCADDR),
                    .HWDATA           (HWDATA[31:24]),
                    .MemWrDatab       (MemWrDatab3),
                    .AhbRdDatab       (AhbRdDatab3),
                    .MemRdDatab       (MemRdDatab3)
                    );

// -----------------------------------------------------------------------------
// Assign local copies of signals to the outputs
// -----------------------------------------------------------------------------
assign MPMCActLowCS     = nCS;

endmodule

// --================================== End ==================================--
