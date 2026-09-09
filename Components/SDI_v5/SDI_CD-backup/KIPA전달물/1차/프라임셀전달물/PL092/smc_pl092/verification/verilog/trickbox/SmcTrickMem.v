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
// File Name              : SmcTrickMem.v.rca
// File Revision          : 1.9
//
// Release Information    : PrimeCell(TM)-PL092-REL1v1
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module is the top level SMC Trickbox Memory model.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SmcTrickMem (
// Inputs
                    HCLK,
                    nHCLK,
                    HRESETn,
                    HADDR,
                    HTRANS,
                    HWRITE,
                    HSIZE,
                    HBURST,
                    HREADYIN,
                    HWDATA,
                    HSELSMCTRMEM,
                    SMADDR,
                    nSMDATAEN,
                    nSMWEN,
                    nSMOEN,
                    nSMBLS,
                    SMCTrAllCS,
                    SMCTrCS,

// Inouts
                    SMDATA,

// Outputs
                    HRDATA,
                    HREADYOUT,
                    HRESP,

                    SMCActLowCS
                   );

parameter Tclk = 10.56;        // HCLK Period

// Inputs
input         HCLK;         // AHB Clock
input         nHCLK;        // AHB Clock (Inverted)
input         HRESETn;      // Bus Reset
input  [15:0] HADDR;        // AHB Address Bus
input   [1:0] HTRANS;       // Transfer type
input         HWRITE;       // AHB Peripheral Write
input   [2:0] HSIZE;        // Transfer size
input   [2:0] HBURST;       // Burst Type
input         HREADYIN;     // Multiplexed version of HREADY outputs
input  [31:0] HWDATA;       // AHB Write Data bus
input         HSELSMCTRMEM; // AHB Peripheral (TrickMem) Select
input  [25:0] SMADDR;       // Memory Address Bus
input   [3:0] nSMDATAEN;    // Memory Bus Enable
input         nSMWEN;       // Write Enable for the external Memory
                            // bank
input         nSMOEN;       // Output Enable for the external Memory
                            // bank
input   [3:0] nSMBLS;       // Byte Enables for the external Memory
                            // bank
input   [7:0] SMCTrAllCS;   // The CS status of all the eight banks
                            // connected with the SMC
input         SMCTrCS;      // Individual select line for a TrickMem



// Inouts
inout  [31:0] SMDATA;       // Memory Data Bus



// Outputs
output [31:0] HRDATA;       // AHB Read Data bus
output        HREADYOUT;    // Slave HREADY output
output  [1:0] HRESP;        // Slave response


output        SMCActLowCS;  // Used for suitably routing the SMCTrWAIT
                            // as the final SMWAIT at the top-level of
                            // the tbench




// Inputs
  wire        HCLK;         // AHB Clock
  wire        nHCLK;        // AHB Clock (Inverted)
  wire        HRESETn;      // Bus Reset
  wire [15:0] HADDR;        // AHB Address Bus
  wire  [1:0] HTRANS;       // Transfer type
  wire        HWRITE;       // AHB Peripheral Write
  wire  [2:0] HSIZE;        // Transfer size
  wire  [2:0] HBURST;       // Burst Type
  wire        HREADYIN;     // Multiplexed version of HREADY outputs
  wire [31:0] HWDATA;       // AHB Write Data bus
  wire        HSELSMCTRMEM; // AHB Peripheral (TrickMem) Select
  wire [25:0] SMADDR;       // Memory Address Bus
  wire  [3:0] nSMDATAEN;    // Memory Bus Enable
  wire        nSMWEN;       // Write Enable for the external Memory
                            // bank
  wire        nSMOEN;       // Output Enable for the external Memory
                            // bank
  wire  [3:0] nSMBLS;       // Byte Enables for the external Memory
                            // bank
  wire  [7:0] SMCTrAllCS;   // The CS status of all the eight banks
                            // connected with the SMC
  wire        SMCTrCS;      // Individual select line for a TrickMem



// Inouts
  wire [31:0] SMDATA;       // Memory Data Bus



// Outputs
  wire [31:0] HRDATA;       // AHB Read Data bus
  wire        HREADYOUT;    // Slave HREADY output
  wire  [1:0] HRESP;        // Slave response


  wire        SMCActLowCS;  // Used for suitably routing the SMCTrWAIT
                            // as the final SMWAIT at the top-level of
                            // the tbench


// -----------------------------------------------------------------------------
//
//                                 SmcTrickMem
//                                 ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block is the top level of the SMC Trickbox Memory Model. This block
// instantiates the following sub-blocks:
//
// 1. SmcTrMemAhbifReg - AHB Interface and Register Block
// 2. SmcTrMemRdWrCtl  - Memory Read/Write Control and Timing checks
// 3. SmcTrMemArray    - Memory Element
// 4. SmcTrPackage     - Constant declaration
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [15:0] LatchHADDR;
// Latched AHB Address. This is used when the memory is accessed via AHB

wire  [4:0] SMCTrIDCY;
// Memory data bus turn around time count

wire  [5:0] SMCTrWST1;
// Initial Access time count in case of BROMs
// Read Access time count in case of SRAMs or ROMs

wire  [5:0] SMCTrWST2;
// Write access time count in case of SRAM
// Burst access time count in case of BROMs
// Insignificant in case of ROMs

wire [10:0] SMCTrMEMT;
// Memory type specifier

wire [14:0] SMCTrMEMB;
// Memory Base Address

wire        SMCTrMEMRWr;
// Memory Write Enable

wire  [4:0] SMCTrCS2OEN;
// Chip Select to Output Enable delay count

wire  [4:0] SMCTrCS2WEN;
// Chip Select to Write Enable delay count

wire  [7:0] SMCTrCSPOL;
// Chip Select Polarity Select

wire [10:0] LatchSMADDR;
// Latched Memory Address Bus

wire  [7:0] AhbRdDatab0;
// BYTE0 of 32 bits AHB Read Data

wire  [7:0] AhbRdDatab1;
// BYTE1 of 32 bits AHB Read Data

wire  [7:0] AhbRdDatab2;
// BYTE2 of 32 bits AHB Read Data

wire  [7:0] AhbRdDatab3;
// BYTE3 of 32 bits AHB Read Data

wire  [7:0] MemRdDatab0;
// BYTE0 of 32 bits Memory Read Data

wire  [7:0] MemRdDatab1;
// BYTE1 of 32 bits Memory Read Data

wire  [7:0] MemRdDatab2;
// BYTE2 of 32 bits Memory Read Data

wire  [7:0] MemRdDatab3;
// BYTE3 of 32 bits Memory Read Data

wire  [7:0] MemWrDatab0;
// BYTE0 of 32 bits Memory Write Data

wire  [7:0] MemWrDatab1;
// BYTE1 of 32 bits Memory Write Data

wire  [7:0] MemWrDatab2;
// BYTE2 of 32 bits Memory Write Data

wire  [7:0] MemWrDatab3;
// BYTE3 of 32 bits Memory Write Data

wire [31:0] MemRdDataDW;
// 32 Bits Memory Read Data (Concatenation of MemRdDatab0-3)

wire [31:0] AhbRdDataDW;
// 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

wire        RBLE;
// Read Byte Lane Enable signal

wire        nCS;
// Memory Chip Select signal (Active Low)

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg   [3:0] TrnSMBLS;
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


assign MemWrDatab0      = SMDATA[7:0];
assign MemWrDatab1      = SMDATA[15:8];
assign MemWrDatab2      = SMDATA[23:16];
assign MemWrDatab3      = SMDATA[31:24];
assign MemRdDataDW      = {MemRdDatab3, MemRdDatab2, MemRdDatab1,
                           MemRdDatab0};
assign AhbRdDataDW      = {AhbRdDatab3, AhbRdDatab2, AhbRdDatab1,
                           AhbRdDatab0};
assign RBLE             = SMCTrMEMT[6];

// -----------------------------------------------------------------------------
// Write Enable selection according to the RBLE value
// -----------------------------------------------------------------------------
always @(RBLE or nSMBLS or nSMWEN)
begin : p_SMBLSComb
  if (RBLE == 1'b0)
    begin
      TrnSMBLS = nSMBLS;
    end
  else
    begin
      TrnSMBLS = nSMBLS | ({nSMWEN, nSMWEN, nSMWEN, nSMWEN});
    end
end // p_SMBLSComb

// -----------------------------------------------------------------------------
// Instantiation of the SMC TrickMem AHB interface
// -----------------------------------------------------------------------------
SmcTrMemAhbifReg uSmcTrMemAhbifReg    (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HREADYIN         (HREADYIN),
                    .HWDATA           (HWDATA),
                    .HSELSMCTRMEM     (HSELSMCTRMEM),
                    .AhbRdDataDW      (AhbRdDataDW),
                    .HRDATA           (HRDATA),
                    .HREADYOUT        (HREADYOUT),
                    .HRESP            (HRESP),
                    .SMCTrMEMRWr      (SMCTrMEMRWr),
                    .LatchHADDR       (LatchHADDR),
                    .SMCTrIDCY        (SMCTrIDCY),
                    .SMCTrWST1        (SMCTrWST1),
                    .SMCTrWST2        (SMCTrWST2),
                    .SMCTrMEMT        (SMCTrMEMT),
                    .SMCTrMEMB        (SMCTrMEMB),
                    .SMCTrCS2OEN      (SMCTrCS2OEN),
                    .SMCTrCS2WEN      (SMCTrCS2WEN),
                    .SMCTrCSPOL       (SMCTrCSPOL)
                    );

// -----------------------------------------------------------------------------
// Instantiation of the SMC TrickMem Read/Write Control Block
// -----------------------------------------------------------------------------
defparam uSmcTrMemRdWrCtl.Tclk = Tclk;

SmcTrMemRdWrCtl uSmcTrMemRdWrCtl      (
                    .HCLK             (HCLK),
                    .nHCLK            (nHCLK),
                    .HRESETn          (HRESETn),
                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .SMCTrCS          (SMCTrCS),
                    .SMCTrAllCS       (SMCTrAllCS),
                    .nSMWEN           (nSMWEN),
                    .nSMBLS           (nSMBLS),
                    .nSMOEN           (nSMOEN),
                    .MemRdDataDW      (MemRdDataDW),
                    .SMCTrIDCY        (SMCTrIDCY),
                    .SMCTrWST1        (SMCTrWST1),
                    .SMCTrWST2        (SMCTrWST2),
                    .SMCTrMEMT        (SMCTrMEMT),
                    .SMCTrMEMB        (SMCTrMEMB),
                    .SMCTrCS2OEN      (SMCTrCS2OEN),
                    .SMCTrCS2WEN      (SMCTrCS2WEN),
                    .SMCTrCSPOL       (SMCTrCSPOL),
                    .SMDATA           (SMDATA),
                    .LatchSMADDR      (LatchSMADDR),
                    .SMCActLowCS      (nCS)
                    );

// -----------------------------------------------------------------------------
// 4 Instantiations of the Memory Element (Each of 2k depth)
// -----------------------------------------------------------------------------
SmcTrMemArray u0SmcTrMemArray         (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .nCS              (nCS),
                    .nSMBLS           (TrnSMBLS[0]),
                    .SMCTrMEMRWr      (SMCTrMEMRWr),
                    .LatchHADDR       (LatchHADDR[12 : 2]),
                    .LatchSMADDR      (LatchSMADDR),
                    .HWDATA           (HWDATA[7 : 0]),
                    .MemWrDatab       (MemWrDatab0),
                    .AhbRdDatab       (AhbRdDatab0),
                    .MemRdDatab       (MemRdDatab0)
                    );

SmcTrMemArray u1SmcTrMemArray         (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .nCS              (nCS),
                    .nSMBLS           (TrnSMBLS[1]),
                    .SMCTrMEMRWr      (SMCTrMEMRWr),
                    .LatchHADDR       (LatchHADDR[12 : 2]),
                    .LatchSMADDR      (LatchSMADDR),
                    .HWDATA           (HWDATA[15 : 8]),
                    .MemWrDatab       (MemWrDatab1),
                    .AhbRdDatab       (AhbRdDatab1),
                    .MemRdDatab       (MemRdDatab1)
                    );

SmcTrMemArray u2SmcTrMemArray         (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .nCS              (nCS),
                    .nSMBLS           (TrnSMBLS[2]),
                    .SMCTrMEMRWr      (SMCTrMEMRWr),
                    .LatchHADDR       (LatchHADDR[12 : 2]),
                    .LatchSMADDR      (LatchSMADDR),
                    .HWDATA           (HWDATA[23 : 16]),
                    .MemWrDatab       (MemWrDatab2),
                    .AhbRdDatab       (AhbRdDatab2),
                    .MemRdDatab       (MemRdDatab2)
                    );

SmcTrMemArray u3SmcTrMemArray         (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .nCS              (nCS),
                    .nSMBLS           (TrnSMBLS[3]),
                    .SMCTrMEMRWr      (SMCTrMEMRWr),
                    .LatchHADDR       (LatchHADDR[12 : 2]),
                    .LatchSMADDR      (LatchSMADDR),
                    .HWDATA           (HWDATA[31 : 24]),
                    .MemWrDatab       (MemWrDatab3),
                    .AhbRdDatab       (AhbRdDatab3),
                    .MemRdDatab       (MemRdDatab3)
                    );

// -----------------------------------------------------------------------------
// Assign local copies of signals to the outputs
// -----------------------------------------------------------------------------
assign SMCActLowCS      = nCS;

endmodule
// --================================== End ==================================--
