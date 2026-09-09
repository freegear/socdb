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
// File Name              : MpmcTrAhbif.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block interfaces the MPMC Trickbox with the AHB.
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "MpmcTrParams.v"

// -----------------------------------------------------------------------------

module MpmcTrAhbif (
// Inputs
                    HCLK,
                    HRESETn,
                    HADDR,
                    HTRANS,
                    HWRITE,
                    HSIZE,
                    HREADYIN,
                    MPMCTrSR,
                    HWDATA,
                    HSELMPMCTR,
                    HSELMPMCREG,
                    Fifo1Out,
                    Fifo2Out,
                    MPMCTrCR,
                    MPMCTrSNPCR,
                    MPMCTrExpRef,
                    HREADY0CNT,
                    HREADY1CNT,
                    MPMCTrExBkOff,
                    MPMCTrStCS,
                    MPMCTrTES,
// Outputs
                    HREADYOUT,
                    HRESP,
                    HRDATA,
                    WriteData,
                    MPMCTrSRWr,
                    MPMCTrCRWr,
                    MPMCTrSNPCRWr,
                    MPMCTrControlWr,
                    MPMCTrConfigWr,
                    MPMCTrDynCntlWr,
                    MPMCTrDynRfrshWr,
                    MPMCTrStExtWtWr,
                    MPMCTrDynRC0Wr,
                    MPMCTrDynRC1Wr,
                    MPMCTrDynRC2Wr,
                    MPMCTrDynRC3Wr,
                    MPMCTrDynCnfg0Wr,
                    MPMCTrDynCnfg1Wr,
                    MPMCTrDynCnfg2Wr,
                    MPMCTrDynCnfg3Wr,
                    MPMCTrStCSWr,
                    MPMCTrTESWr,
                    MPMCTrExpRefWr,
                    MPMCTrExBkOffWr,
                    HREADY0CNTWr,
                    HREADY1CNTWr,
                    Fifo1Rd,
                    Fifo2Rd
                   );

// Inputs
// AHB bus signals
input         HCLK;             // AHB Bus Clock
input         HRESETn;          // Bus Reset
input  [11:2] HADDR;            // AHB Address Bus
input   [1:0] HTRANS;           // Transfer type
input         HWRITE;           // AHB Peripheral Write
input   [2:0] HSIZE;            // Transfer size
input         HREADYIN;         // Multiplexed version of HREADY outputs
input   [8:0] MPMCTrSR;         // MPMCTrSR Register
input  [31:0] HWDATA;           // AHB Write Data bus
input         HSELMPMCTR;       // AHB Peripheral (Trickbox) Select
input         HSELMPMCREG;      // AHB Peripheral (MPMC Reg) Select
input  [31:0] Fifo1Out;         // Snooper fifo1 data from snooper module
input  [31:0] Fifo2Out;         // Snooper fifo2 data from snooper module
input   [6:0] MPMCTrCR;         // MPMCTrCR Register
input   [3:0] MPMCTrSNPCR;      // MPMCTrSNP Control Register
input   [3:0] MPMCTrExpRef;     // MPMCTrExpRef Register
input   [5:0] MPMCTrExBkOff;    // MPMCTrExBkOff Register
input   [7:0] HREADY0CNT;       // HREADY0CNT Register
input   [7:0] HREADY1CNT;       // HREADY1CNT Register
input   [6:0] MPMCTrStCS;       // MPMCTrStCS Register
input   [3:0] MPMCTrTES;        // MPMCTrTES Register

// Outputs
output        HREADYOUT;        // Slave HREADY output
output  [1:0] HRESP;            // Slave response
output [31:0] HRDATA;           // AHB Read Data bus
output [31:0] WriteData;        // Write Data bus to the Register Block
output        MPMCTrSRWr;       // MPMCTrSR register write enable
output        MPMCTrCRWr;       // MPMCTrCR Register Write Enable
output        MPMCTrSNPCRWr;    // MPMCTrSNPCR Register Write
output        MPMCTrControlWr;  // MPMCTrControl Register Write Enable
output        MPMCTrConfigWr;   // MPMCTrConfig Register Write Enable
output        MPMCTrDynCntlWr;  // MPMCTrDynCntl Register Write Enable
output        MPMCTrDynRfrshWr; // MPMCTrDynRfrsh Register Write Enable
output        MPMCTrStExtWtWr;  // MPMCTrExtWait Register Write Enable
output        MPMCTrDynRC0Wr;   // MPMCTrDynRC0 Register Write Enable
output        MPMCTrDynRC1Wr;   // MPMCTrDynRC1 Register Write Enable
output        MPMCTrDynRC2Wr;   // MPMCTrDynRC2 Register Write Enable
output        MPMCTrDynRC3Wr;   // MPMCTrDynRC3 Register Write Enable
output        MPMCTrDynCnfg0Wr; // MPMCTrDynCnfg0 Register Write Enable
output        MPMCTrDynCnfg1Wr; // MPMCTrDynCnfg1 Register Write Enable
output        MPMCTrDynCnfg2Wr; // MPMCTrDynCnfg2 Register Write Enable
output        MPMCTrDynCnfg3Wr; // MPMCTrDynCnfg3 Register Write Enable
output        MPMCTrStCSWr;     // MPMCTrStCS Register Write Enable
output        MPMCTrTESWr;      // MPMCTrTES Register Write Enable
output        MPMCTrExpRefWr;   // MPMCTrExpRef Register Write Enable
output        MPMCTrExBkOffWr;  // MPMCTrExBkOff Register Write Enable
output        HREADY0CNTWr;     // HREADY0CNT Register Write Enable
output        HREADY1CNTWr;     // HREADY1CNT Register Write Enable
output        Fifo1Rd;          // Snooper fifo1 Read Enable signal
output        Fifo2Rd;          // Snooper fifo2 Read Enable signal

// Inputs
wire          HCLK;             // AHB Bus Clock
wire          HRESETn;          // Bus Reset
wire   [11:2] HADDR;            // AHB Address Bus
wire    [1:0] HTRANS;           // Transfer type
wire          HWRITE;           // AHB Peripheral Write
wire    [2:0] HSIZE;            // Transfer size
wire          HREADYIN;         // Multiplexed version of HREADY outputs
wire    [8:0] MPMCTrSR;         // MPMCTrSR Register
wire   [31:0] HWDATA;           // AHB Write Data bus
wire          HSELMPMCTR;       // AHB Peripheral (Trickbox) Select
wire          HSELMPMCREG;      // AHB Peripheral (MPMC Reg) Select
wire   [31:0] Fifo1Out;         // Snooper fifo1 data from snooper module
wire   [31:0] Fifo2Out;         // Snooper fifo2 data from snooper module
wire    [6:0] MPMCTrCR;         // MPMCTrCR Register
wire    [3:0] MPMCTrSNPCR;      // MPMCTrSNP Control Register
wire    [6:0] MPMCTrStCS;       // MPMCTrStCS Register
wire    [7:0] HREADY0CNT;       // HREADY0CNT Register
wire    [7:0] HREADY1CNT;       // HREADY1CNT Register
wire    [3:0] MPMCTrTES;        // MPMCTrTES Register

// Outputs
reg           HREADYOUT;        // Slave HREADY output
wire    [1:0] HRESP;            // Slave response
wire   [31:0] HRDATA;           // AHB Read Data bus
wire   [31:0] WriteData;        // Write Data bus to the Register Block
wire          MPMCTrSRWr;       // MPMCTrSR register write enable
wire          MPMCTrCRWr;       // MPMCTrCR Register Write Enable
wire          MPMCTrSNPCRWr;    // MPMCTrSNPCR Register Write
wire          MPMCTrControlWr;  // MPMCTrControl Register Write Enable
wire          MPMCTrConfigWr;   // MPMCTrConfig Register Write Enable
wire          MPMCTrDynCntlWr;  // MPMCTrDynCntl Register Write Enable
wire          MPMCTrDynRfrshWr; // MPMCTrDynRfrsh Register Write Enable
wire          MPMCTrStExtWtWr;  // MPMCTrExtWait Register Write Enable
wire          MPMCTrDynRC0Wr;   // MPMCTrDynRC0 Register Write Enable
wire          MPMCTrDynRC1Wr;   // MPMCTrDynRC1 Register Write Enable
wire          MPMCTrDynRC2Wr;   // MPMCTrDynRC2 Register Write Enable
wire          MPMCTrDynRC3Wr;   // MPMCTrDynRC3 Register Write Enable
wire          MPMCTrDynCnfg0Wr; // MPMCTrDynCnfg0 Register Write Enable
wire          MPMCTrDynCnfg1Wr; // MPMCTrDynCnfg1 Register Write Enable
wire          MPMCTrDynCnfg2Wr; // MPMCTrDynCnfg2 Register Write Enable
wire          MPMCTrDynCnfg3Wr; // MPMCTrDynCnfg3 Register Write Enable
wire          MPMCTrStCSWr;     // MPMCTrStCS Register Write Enable
wire          MPMCTrTESWr;      // MPMCTrTES Register Write Enable
wire          MPMCTrExpRefWr;   // MPMCTrExpRef Register Write Enable
wire          MPMCTrExBkOffWr;  // MPMCTrExBkOff Register Write Enable
wire          HREADY0CNTWr;     // HREADY0CNT Register Write Enable
wire          HREADY1CNTWr;     // HREADY1CNT Register Write Enable
wire          Fifo1Rd;          // Snooper fifo1 Read Enable signal
wire          Fifo2Rd;          // Snooper fifo2 Read Enable signal

// -----------------------------------------------------------------------------
//
//                                 MpmcTrAhbif
//                                 ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// MPMC Tricbox is an AHB slave. This block performs the following operations:
//   - Interfaces the Trickbox with the AHB
//       All slave response signals are generated from this module.
//       This module decodes AHB accesses and generates the read/write
//       strobe to the appropriate registers.
//
// -----------------------------------------------------------------------------
//                         MPMC Trickbox Register Map
// -----------------------------------------------------------------------------
// Offset    Register       Type  Width    Describtion
// -----------------------------------------------------------------------------
// [from MpmcTr Base]
// 0x0000 -  MPMCTrCR       R/W  7-bits  This is MPMC Trickbox Control register
//                                       used to control various signals
//
// 0x0004 -  MPMCTrSR       R/W  9-bits  This is MPMC Trickbox Status register
//                                       used to setting and reading the
//                                       various signals
//
// 0x0008 -  MPMCTrSNPFIFO1 R/W  32-bits This is MPMC Trickbox snooper Fifo1
//                                       used to snoop the PAD signals from MPMC
//
// 0x000C -  MPMCTrSNPFIFO2 R/W  32-bits This is MPMC Trickbox snooper Fifo2
//                                       used to snoop the PAD signals from MPMC
//
// 0x0014    MPMCTrStCS     R/W  6-bits  This register is used to drive the
//                                       MPMCSTATICCS1POL and
//                                       MPMCSTATICCS1MW width signal
//
// 0x0018    MPMCTrTES      R/W  4-bits  This register indicates the Test End
//                                       Status of 4 AHBs
//
// 0x001C -  MPMCTrSNPCR    R/W  4-bits  This is MPMC Trickbox snooper Fifo
//                                       used to snoop the PAD signals from MPMC
//
// 0x0020 -  MPMCTrExpRef   R/W  4-bits  This register specifies the number of
//                                       refresh cycles needed during the
//                                       initialisation
//
// 0x0024 -  MPMCTrExBkOff  R/W  4-bits  This register specifies the number of
//                                       clks after which backoff is supposed
//                                       to be asserted after the GNT signal 
//
// 0x0028 -  HREADY0CNT     R/W  8-bits  This register specifies the number of
//                                       clks to check the HREADY0 low
//
// 0x002C -  HREADY1CNT     R/W  8-bits  This register specifies the number of
//                                       clks to check the HREADY1 low
//
// [from Mpmc Base]
// 0x0000    MPMCTrControl  R/W  4-bits  This register is a mirrored version
//                                       of the MPMCControl register
//
// 0x0008    MPMCTrConfig   R/W  10-bits This register is a mirrored version
//                                       of the MPMCConfig register
//
// 0x0020    MPMCTrDynCntl  R/W  16-bits This register is a mirrored version
//                                       of the MPMCDynControl register
//
// 0x0024    MPMCTrDynRfrsh R/W  11-bits This register is a mirrored version
//                                       of the MPMCTrDynRefresh register
//
// 0x0080    MPMCTrStExtWt  R/W  10-bits This register indicates the Extended
//                                       Wait count
//
// 0x0100    MPMCTrDynCnfg0 R/W  16-bits This register is a mirrored version
//                                       of the MPMCTrDynConfig0 register
//
// 0x0104    MPMCTrDynRC0   R/W 10-bits  This register is a mirrored version
//                                       of the MPMCTrDynRasCas0 register
//
// 0x0120    MPMCTrDynCnfg1 R/W  16-bits This register is a mirrored version
//                                       of the MPMCTrDynConfig1 register
//
// 0x0124    MPMCTrDynRC1   R/W 10-bits  This register is a mirrored version
//                                       of the MPMCTrDynRasCas1 register
//
// 0x0140    MPMCTrDynCnfg2 R/W  16-bits This register is a mirrored version
//                                       of the MPMCTrDynConfig2 register
//
// 0x0144    MPMCTrDynRC2   R/W 10-bits  This register is a mirrored version
//                                       of the MPMCTrDynRasCas2 register
//
// 0x0160    MPMCTrDynCnfg3 R/W  16-bits This register is a mirrored version
//                                       of the MPMCTrDynConfig3 register
//
// 0x0164    MPMCTrDynRC3   R/W 10-bits  This register is a mirrored version
//                                       of the MPMCTrDynRasCas3 register
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Zero fill for register reads to return zeros in unused bit positions
// -----------------------------------------------------------------------------
`define ZEROFILL         32'h00000000

// -----------------------------------------------------------------------------
// Trickbox registers address constants. Address decode is for
// bits 2 to 4 (3 bits)
// -----------------------------------------------------------------------------
`define ADDR_MPMCTrCR        10'b0000000000
// MPMCTrCR at offset 0x0000

`define ADDR_MPMCTrSR        10'b0000000001
// MPMCTrSR at offset 0x0004

`define ADDR_MPMCTrSNPFIFO1  10'b0000000010
// MPMCTrSNP1 at offset 0x0008

`define ADDR_MPMCTrSNPFIFO2  10'b0000000011
// MPMCTrSNP1 at offset 0x000C

`define ADDR_MPMCTrStCS      10'b0000000101
// MPMCTrStCS at offset 0x0014

`define ADDR_MPMCTrTES       10'b0000000110
// MPMCTrDynCnfg at offset 0x0018

`define ADDR_MPMCTrSNPCR     10'b0000000111
// MPMCTrSNPCR at offset 0x001C

`define ADDR_MPMCTrExpRef    10'b0000001000
// MPMCTrExpRef at offset 0x0020

`define ADDR_MPMCTrExBkOff   10'b0000001001
// MPMCTrExpRef at offset 0x0024

`define ADDR_HREADY0CNT   10'b0000001010
// HREADY0CNT at offset 0x0028

`define ADDR_HREADY1CNT   10'b0000001011
// HREADY1CNT at offset 0x002C

`define ADDR_MPMCTrControl   10'b0000000000
// MPMCTrControl at offset 0x0000 from Mpmc base

`define ADDR_MPMCTrConfig    10'b0000000010
// MPMCTrConfig at offset 0x0008 from Mpmc base

`define ADDR_MPMCTrDynCntl   10'b0000001000
// MPMCTrDynCntl at offset 0x0020 from Mpmc base

`define ADDR_MPMCTrDynRfrsh  10'b0000001001
// MPMCTrDynRfrsh at offset 0x0024 from Mpmc base

`define ADDR_MPMCTrStExtWt   10'b0000100000
// MPMCTrStExtWt at offset 0x80 from Mpmc base

`define ADDR_MPMCTrDynCnfg0  10'b0001000000
// MPMCTrDynCnfg0 at offset 0x0100 from Mpmc base

`define ADDR_MPMCTrDynRC0    10'b0001000001
// MPMCTrDynRC0 at offset 0x0104 from Mpmc base

`define ADDR_MPMCTrDynCnfg1  10'b0001001000
// MPMCTrDynCnfg1 at offset 0x0120 from Mpmc base

`define ADDR_MPMCTrDynRC1    10'b0001001001
// MPMCTrDynRC1 at offset 0x0124 from Mpmc base

`define ADDR_MPMCTrDynCnfg2  10'b0001010000
// MPMCTrDynCnfg2 at offset 0x0140 from Mpmc base

`define ADDR_MPMCTrDynRC2    10'b0001010001
// MPMCTrDynRC2 at offset 0x0144 from Mpmc base

`define ADDR_MPMCTrDynCnfg3  10'b0001011000
// MPMCTrDynCnfg3 at offset 0x0160 from Mpmc base

`define ADDR_MPMCTrDynRC3    10'b0001011001
// MPMCTrDynRC3 at offset 0x0164 from Mpmc base

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire          MPMCTrCRRd;
// MPMCTrCR Read

wire          MPMCTrSRRd;
// MPMCTrSR Read

wire          MPMCTrSNPCRRd;
// MPMCTrSNPCR Read

wire          MPMCTrExpRefRd;
// MPMCTrExpRef Read

wire       MPMCTrSNPFIFO1Rd;
// MPMCTrSNPFIFO1 Read

wire          MPMCTrSNPFIFO2Rd;
// MPMCTrSNPFIFO1 Read

wire          MPMCTrStCSRd;
// MPMCTrStCS Read

wire          MPMCTrTESRd;
// MPMCTrTES Read

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg    [11:2] iLatchHADDR;
// Latched version of HADDR

reg     [1:0] iHRESP;
// Indicates the type of response for a transfer

reg           RdEn;
// Read enable signal

reg           WrEn;
// Write enable signal

reg           WrEnCom;
// Write enable signal for MPMC mirror registers

reg           ErrorLat;
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
assign MPMCTrCRWr       = ((WrEn == 1'b1) & (iLatchHADDR == `ADDR_MPMCTrCR)) ?
                          1'b1 : 1'b0;

assign MPMCTrSRWr       = ((WrEn == 1'b1) & (iLatchHADDR == `ADDR_MPMCTrSR)) ?
                          1'b1 : 1'b0;

assign MPMCTrSNPCRWr    = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_MPMCTrSNPCR)) ? 1'b1 : 1'b0;

assign MPMCTrStCSWr     = ((WrEn === 1'b1) &
                           (iLatchHADDR === `ADDR_MPMCTrStCS)) ? 1'b1 : 1'b0;

assign MPMCTrTESWr      = ((WrEn == 1'b1) & (iLatchHADDR == `ADDR_MPMCTrTES)) ?
                          1'b1 : 1'b0;

assign MPMCTrExpRefWr   = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_MPMCTrExpRef)) ? 1'b1 : 1'b0;

assign MPMCTrExBkOffWr  = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_MPMCTrExBkOff)) ? 1'b1 : 1'b0;

assign HREADY0CNTWr     = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_HREADY0CNT)) ? 1'b1 : 1'b0;

assign HREADY1CNTWr     = ((WrEn == 1'b1) &
                           (iLatchHADDR == `ADDR_HREADY1CNT)) ? 1'b1 : 1'b0;

assign MPMCTrControlWr  = ((WrEnCom == 1'b1) &
                           (iLatchHADDR == `ADDR_MPMCTrControl)) ? 1'b1 : 1'b0;

assign MPMCTrConfigWr   = ((WrEnCom == 1'b1) &
                           (iLatchHADDR == `ADDR_MPMCTrConfig)) ? 1'b1 : 1'b0;

assign MPMCTrDynCntlWr  = ((WrEnCom == 1'b1) &
                           (iLatchHADDR == `ADDR_MPMCTrDynCntl)) ? 1'b1 : 1'b0;

assign MPMCTrDynRfrshWr = ((WrEnCom == 1'b1) &
                          (iLatchHADDR == `ADDR_MPMCTrDynRfrsh)) ? 1'b1 : 1'b0;

assign MPMCTrStExtWtWr  = ((WrEnCom == 1'b1) &
                           (iLatchHADDR == `ADDR_MPMCTrStExtWt)) ? 1'b1 : 1'b0;

assign MPMCTrDynRC0Wr   = ((WrEnCom == 1'b1) &
                           (iLatchHADDR == `ADDR_MPMCTrDynRC0)) ? 1'b1 : 1'b0;

assign MPMCTrDynRC1Wr   = ((WrEnCom == 1'b1) &
                           (iLatchHADDR == `ADDR_MPMCTrDynRC1)) ? 1'b1 : 1'b0;

assign MPMCTrDynRC2Wr   = ((WrEnCom == 1'b1) &
                           (iLatchHADDR == `ADDR_MPMCTrDynRC2)) ? 1'b1 : 1'b0;

assign MPMCTrDynRC3Wr   = ((WrEnCom == 1'b1) &
                           (iLatchHADDR == `ADDR_MPMCTrDynRC3)) ? 1'b1 : 1'b0;

assign MPMCTrDynCnfg0Wr = ((WrEnCom == 1'b1) &
                          (iLatchHADDR == `ADDR_MPMCTrDynCnfg0)) ? 1'b1 : 1'b0;

assign MPMCTrDynCnfg1Wr = ((WrEnCom == 1'b1) &
                          (iLatchHADDR == `ADDR_MPMCTrDynCnfg1)) ? 1'b1 : 1'b0;

assign MPMCTrDynCnfg2Wr = ((WrEnCom == 1'b1) &
                          (iLatchHADDR == `ADDR_MPMCTrDynCnfg2)) ? 1'b1 : 1'b0;

assign MPMCTrDynCnfg3Wr = ((WrEnCom == 1'b1) &
                          (iLatchHADDR == `ADDR_MPMCTrDynCnfg3)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Read enables for registers
// -----------------------------------------------------------------------------
assign MPMCTrCRRd       = ((RdEn == 1'b1) & (iLatchHADDR == `ADDR_MPMCTrCR)) ?
                           1'b1 : 1'b0;

assign MPMCTrSRRd       = ((RdEn == 1'b1) & (iLatchHADDR == `ADDR_MPMCTrSR)) ?
                           1'b1 : 1'b0;

assign MPMCTrSNPCRRd    = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_MPMCTrSNPCR)) ? 1'b1 : 1'b0;

assign MPMCTrSNPFIFO1Rd = ((RdEn == 1'b1) &
                          (iLatchHADDR == `ADDR_MPMCTrSNPFIFO1)) ? 1'b1 : 1'b0;

assign MPMCTrSNPFIFO2Rd = ((RdEn == 1'b1) &
                          (iLatchHADDR == `ADDR_MPMCTrSNPFIFO2)) ? 1'b1 : 1'b0;

assign MPMCTrStCSRd     = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_MPMCTrStCS)) ? 1'b1 : 1'b0;

assign MPMCTrTESRd      = ((RdEn == 1'b1) & (iLatchHADDR == `ADDR_MPMCTrTES)) ?
                           1'b1 : 1'b0;

assign MPMCTrExpRefRd   = ((RdEn == 1'b1) &
                           (iLatchHADDR == `ADDR_MPMCTrExpRef)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Output Mux
// When the peripheral is not being accessed, '0's are driven
// on the Read Databus (HRDATA)
// -----------------------------------------------------------------------------
assign HRDATA           = (MPMCTrCRRd == 1'b1) ?
                           {25'b0000000000000000000000000, MPMCTrCR} :
                           ((MPMCTrSRRd == 1'b1) ?
                           {23'b00000000000000000000000, MPMCTrSR} :
                           ((MPMCTrSNPCRRd == 1'b1) ?
                           {28'b0000000000000000000000000000, MPMCTrSNPCR} :
                           ((MPMCTrSNPFIFO1Rd == 1'b1) ?
                           Fifo1Out : ((MPMCTrSNPFIFO2Rd == 1'b1) ?
                           Fifo2Out : ((MPMCTrStCSRd == 1'b1) ?
                           {25'b0000000000000000000000000, MPMCTrStCS} :
                           ((MPMCTrTESRd == 1'b1) ?
                           {28'b0000000000000000000000000000, MPMCTrTES} :
                           ((MPMCTrExpRefRd == 1'b1) ?
                           {28'h0000000, MPMCTrExpRef} : 32'h00000000)))))));

// -----------------------------------------------------------------------------
// This process generates the bus response required for an AHB slave.
// MPMC Trickbox is designed for an HSIZE of 32-bit. So this process will
// generate an ERROR response when the master tries to access it in some other
// mode. Also it displays an error message to the output. Trickbox always
// provides a ZERO wait state OKAY response for IDLE and BUSY
// HTRANS of the master.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_BusRespSeq
  if (HRESETn == 1'b0)
    begin
      iHRESP              <= 2'b00;
      HREADYOUT           <= 1'b1;
      WrEn                <= 1'b0;
      RdEn                <= 1'b0;
      ErrorLat            <= 1'b0;
      iLatchHADDR         <= 7'b0000000;
    end
  else
    begin
      if ((iHRESP == `HRESP_ERROR) & (HREADYIN == 1'b0) & (ErrorLat == 1'b1))
        begin
          iHRESP          <= `HRESP_ERROR;
          HREADYOUT       <= 1'b1;
          WrEn            <= 1'b0;
          RdEn            <= 1'b0;
          ErrorLat        <= 1'b0;
        end
      else if (((HTRANS == `HTRANS_IDLE) | (HTRANS == `HTRANS_BUSY)) &
               ((HSELMPMCTR == 1'b1) | (HSELMPMCREG == 1'b1)) &
                (HREADYIN == 1'b1))
        begin
          WrEn            <= 1'b0;
          RdEn            <= 1'b0;
          WrEnCom         <= 1'b0;
          iHRESP          <= `HRESP_OKAY;
          HREADYOUT       <= 1'b1;
        end
      else if ((HREADYIN == 1'b1) & (HSELMPMCTR == 1'b1))
        begin
          if (HSIZE == `HSIZE_WORD)
            begin
              HREADYOUT   <= 1'b1;
              iLatchHADDR <= HADDR;
              iHRESP      <= `HRESP_OKAY;
              if (HWRITE == 1'b1)
                begin
                  WrEn    <= 1'b1;
                  RdEn    <= 1'b0;
                  WrEnCom <= 1'b0;
                end
              else
                begin
                  WrEn    <= 1'b0;
                  RdEn    <= 1'b1;
                  WrEnCom <= 1'b0;
                end
            end
          else
            begin
              iHRESP      <= `HRESP_ERROR;
              HREADYOUT   <= 1'b0;
              WrEn        <= 1'b0;
              RdEn        <= 1'b0;
              WrEnCom     <= 1'b0;
              ErrorLat    <= 1'b1;
              $display("Error Response from MPMC trickbox slave");
            end
        end
      else if ((HREADYIN == 1'b1) & (HSELMPMCREG == 1'b1))
        begin
          if (HSIZE == `HSIZE_WORD)
            begin
              HREADYOUT   <= 1'b1;
              iLatchHADDR <= HADDR;
              iHRESP      <= `HRESP_OKAY;
              if (HWRITE == 1'b1)
                begin
                  WrEn    <= 1'b0;
                  WrEnCom <= 1'b1;
                  RdEn    <= 1'b0;
                end
              else
                begin
                  WrEn    <= 1'b0;
                  WrEnCom <= 1'b0;
                  RdEn    <= 1'b0;
                end
            end
          else
            begin
              iHRESP      <= `HRESP_ERROR;
              HREADYOUT   <= 1'b0;
              WrEn        <= 1'b0;
              WrEnCom     <= 1'b0;
              RdEn        <= 1'b0;
              ErrorLat    <= 1'b1;
            end
        end
      else
        begin
          WrEn            <= 1'b0;
          RdEn            <= 1'b0;
          WrEnCom         <= 1'b0;
          iHRESP          <= 2'b00;
          HREADYOUT       <= 1'b1;
          ErrorLat        <= 1'b0;
        end
    end
end // p_BusRespSeq

// -----------------------------------------------------------------------------
// Generation of FifoRd signals
// -----------------------------------------------------------------------------
assign Fifo1Rd          = MPMCTrSNPFIFO1Rd;
assign Fifo2Rd          = MPMCTrSNPFIFO2Rd;

// -----------------------------------------------------------------------------
// Assign AHB Write Data
// -----------------------------------------------------------------------------
assign WriteData        = ((WrEn == 1'b1) | (WrEnCom == 1'b1)) ?
                          HWDATA : 32'h00000000;

// -----------------------------------------------------------------------------
// Assign local copies of signals to the outputs
// -----------------------------------------------------------------------------
assign HRESP            = iHRESP;

endmodule

// --================================== End ==================================--
