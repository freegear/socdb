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
// File Name              : MpmcTrick.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block is the top level of the MPMC Trickbox.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MpmcTrick (
// Inputs
                  // AHB bus signals
                  HCLK,
                  HRESETn,
                  HADDR0,
                  HADDR1,
                  HADDR2,
                  HADDR3,
                  HTRANS0,
                  HTRANS1,
                  HTRANS2,
                  HTRANS3,
                  HWRITE0,
                  HWRITE1,
                  HWRITE2,
                  HWRITE3,
                  HSIZE0,
                  HSIZE1,
                  HSIZE2,
                  HSIZE3,
                  HBURST0,
                  HBURST1,
                  HBURST2,
                  HBURST3,
                  HREADYIN0,
                  HREADYIN1,
                  HREADYIN2,
                  HREADYIN3,
                  HWDATA0,
                  HWDATA1,
                  HWDATA2,
                  HWDATA3,
                  HSELMPMCTR0,
                  HSELMPMCTR1,
                  HSELMPMCTR2,
                  HSELMPMCTR3,
                  HSELMPMCREG,
                  MPMCCLKOUT,
                  MPMCCKEOUT,
                  nMPMCRASOUT,
                  nMPMCCASOUT,
                  nMPMCDYCSOUT,
                  nMPMCSTCSOUT,
                  MPMCACTLOWCS,
                  nMPMCWEOUT,
                  nMPMCDATAEN,
                  nMPMCOEOUT,
                  MPMCDQMOUT,
                  nMPMCRPOUT,
                  MPMCRPVHHOUT,
                  MPMCSREFACK,
                  MPMCADDROUT,
                  MPMCDATAIN,
                  MPMCDATAOUT,
                  MPMCEBIREQ,
                  HREADYOutMpmc0,
                  HREADYOutMpmc1,

// Outputs
                  MPMCTrStExtWt,
                  HREADYOUT0,
                  HREADYOUT1,
                  HREADYOUT2,
                  HREADYOUT3,
                  HRESP0,
                  HRESP1,
                  HRESP2,
                  HRESP3,
                  MPMCCLK,
                  MPMCCLKDELAY,
                  nPOR,
                  MPMCSREFREQ,
                  MPMCBIGENDIAN,
                  MPMCSTCS0POL,
                  MPMCSTCS1POL,
                  MPMCSTCS2POL,
                  MPMCSTCS3POL,
                  MPMCSTCS1PB,
                  MPMCSTCS1MW,
                  MPMCEBIGNT,
                  MPMCEBIBACKOFF,
                  HRDATA0,
                  HRDATA1,
                  HRDATA2,
                  HRDATA3
                 );

// Parameters
parameter Tclkl = 10;       // HCLK low time
parameter Tclkh = 10;       // HCLK high time
parameter Tclks = 10;       // MPMCCLK start delay

// Inputs
// AHB bus signals
input        HCLK;          // AHB Bus Clock
input        HRESETn;       // Bus Reset
input [11:2] HADDR0;        // AHB0 Address Bus
input [11:2] HADDR1;        // AHB1 Address Bus
input [11:2] HADDR2;        // AHB2 Address Bus
input [11:2] HADDR3;        // AHB3 Address Bus
input  [1:0] HTRANS0;       // Transfer type AHB0
input  [1:0] HTRANS1;       // Transfer type AHB1
input  [1:0] HTRANS2;       // Transfer type AHB2
input  [1:0] HTRANS3;       // Transfer type AHB3
input        HWRITE0;       // AHB0 Peripheral Write
input        HWRITE1;       // AHB1 Peripheral Write
input        HWRITE2;       // AHB2 Peripheral Write
input        HWRITE3;       // AHB3 Peripheral Write
input  [2:0] HSIZE0;        // Transfer size AHB0
input  [2:0] HSIZE1;        // Transfer size AHB1
input  [2:0] HSIZE2;        // Transfer size AHB2
input  [2:0] HSIZE3;        // Transfer size AHB3
input  [2:0] HBURST0;       // AHB0 Burst type
input  [2:0] HBURST1;       // AHB1 Burst type
input  [2:0] HBURST2;       // AHB2 Burst type
input  [2:0] HBURST3;       // AHB3 Burst type
input        HREADYIN0;     // Multiplexed version of HREADY outputs for AHB0
input        HREADYIN1;     // Multiplexed version of HREADY outputs for AHB1
input        HREADYIN2;     // Multiplexed version of HREADY outputs for AHB2
input        HREADYIN3;     // Multiplexed version of HREADY outputs for AHB3
input [31:0] HWDATA0;       // AHB0 Write Data bus
input [31:0] HWDATA1;       // AHB1 Write Data bus
input [31:0] HWDATA2;       // AHB2 Write Data bus
input [31:0] HWDATA3;       // AHB3 Write Data bus
input        HSELMPMCTR0;   // AHB0 Peripheral (Trickbox) Select
input        HSELMPMCTR1;   // AHB1 Peripheral (Trickbox) Select
input        HSELMPMCTR2;   // AHB2 Peripheral (Trickbox) Select
input        HSELMPMCTR3;   // AHB3 Peripheral (Trickbox) Select
input        HSELMPMCREG;   // AHB Peripheral (MPMC Reg) Select (for AHB0)
input  [3:0] MPMCCLKOUT;    // Memory clock out from MPMC
input  [3:0] MPMCCKEOUT;    // Clock Enable Pin to memory device
input        nMPMCRASOUT;   // nMPMCRASOUT output from the memory module
input        nMPMCCASOUT;   // nMPMCCASOUT output from the memory module
input  [3:0] nMPMCDYCSOUT;  // Synchronise memory Chip Select from MPMC
input  [3:0] nMPMCSTCSOUT;  // Memory Bank Select signals from the MPMC
input  [3:0] MPMCACTLOWCS;  // Active low Memory Bank Select from TrickMem
input        nMPMCWEOUT;    // nMPMCWEOUT output from the memory module
input  [3:0] nMPMCDATAEN;   // Data Bus enable signal
input        nMPMCOEOUT;    // Memory read enable
input  [3:0] MPMCDQMOUT;    // Data Bus Lane Enable signal
input        nMPMCRPOUT;    // Sync Flash Reset/Power down signal
input        MPMCRPVHHOUT;  // Sync Flash Reset/Power down to be driven to VHH
input        MPMCSREFACK;   // Self referesh acknowledge from MPMC
input [27:0] MPMCADDROUT;   // Memory Address from the MPMC
input [31:0] MPMCDATAIN;    // Memory Data Out from the MPMC
input [31:0] MPMCDATAOUT;   // Memory Data Out from the MPMC
input        MPMCEBIREQ;    // EBI request from the controller
input        HREADYOutMpmc0;// HREADY0 from MPMC
input        HREADYOutMpmc1;// HREADY1 from MPMC

// Outputs
output  [9:0] MPMCTrStExtWt; // Extended Wait count to the memory block
output        HREADYOUT0;    // Slave HREADY output (AHB0)
output        HREADYOUT1;    // Slave HREADY output (AHB1)
output        HREADYOUT2;    // Slave HREADY output (AHB2)
output        HREADYOUT3;    // Slave HREADY output (AHB3)
output [1:0]  HRESP0;        // Slave response (AHB0)
output [1:0]  HRESP1;        // Slave response (AHB1)
output [1:0]  HRESP2;        // Slave response (AHB2)
output [1:0]  HRESP3;        // Slave response (AHB3)
output        MPMCCLK;       // Memory clock to the MPMC
output        MPMCCLKDELAY;  // Delayed Memory clock to the MPMC
output        nPOR;          // Power On Reset
output        MPMCSREFREQ;   // Self refersh reques to MPMC
output        MPMCBIGENDIAN; // Endianness
output        MPMCSTCS0POL;  // Indicates CS1 polarity
output        MPMCSTCS1POL;  // Indicates CS2 polarity
output        MPMCSTCS2POL;  // Indicates CS3 polarity
output        MPMCSTCS3POL;  // Indicates CS4 polarity
output  [1:0] MPMCSTCS1MW;   // Indicates CS1 memory width
output        MPMCSTCS1PB;   // BLS pin
output        MPMCEBIGNT;    // EBI grant to the controller
output        MPMCEBIBACKOFF;// EBI backoff to the controller
output [31:0] HRDATA0;       // AHB0 Read Data bus
output [31:0] HRDATA1;       // AHB1 Read Data bus
output [31:0] HRDATA2;       // AHB2 Read Data bus
output [31:0] HRDATA3;       // AHB3 Read Data bus

// Inputs
// AHB bus signals
  wire        HCLK;          // AHB Bus Clock
  wire        HRESETn;       // Bus Reset
  wire [11:2] HADDR0;        // AHB0 Address Bus
  wire [11:2] HADDR1;        // AHB1 Address Bus
  wire [11:2] HADDR2;        // AHB2 Address Bus
  wire [11:2] HADDR3;        // AHB3 Address Bus
  wire  [1:0] HTRANS0;       // Transfer type AHB0
  wire  [1:0] HTRANS1;       // Transfer type AHB1
  wire  [1:0] HTRANS2;       // Transfer type AHB2
  wire  [1:0] HTRANS3;       // Transfer type AHB3
  wire        HWRITE0;       // AHB0 Peripheral Write
  wire        HWRITE1;       // AHB1 Peripheral Write
  wire        HWRITE2;       // AHB2 Peripheral Write
  wire        HWRITE3;       // AHB3 Peripheral Write
  wire  [2:0] HSIZE0;        // Transfer size AHB0
  wire  [2:0] HSIZE1;        // Transfer size AHB1
  wire  [2:0] HSIZE2;        // Transfer size AHB2
  wire  [2:0] HSIZE3;        // Transfer size AHB3
  wire  [2:0] HBURST0;       // AHB0 Burst type
  wire  [2:0] HBURST1;       // AHB1 Burst type
  wire  [2:0] HBURST2;       // AHB2 Burst type
  wire  [2:0] HBURST3;       // AHB3 Burst type
  wire        HREADYIN0;     // Multiplexed version of HREADY outputs for AHB0
  wire        HREADYIN1;     // Multiplexed version of HREADY outputs for AHB1
  wire        HREADYIN2;     // Multiplexed version of HREADY outputs for AHB2
  wire        HREADYIN3;     // Multiplexed version of HREADY outputs for AHB3
  wire [31:0] HWDATA0;       // AHB0 Write Data bus
  wire [31:0] HWDATA1;       // AHB1 Write Data bus
  wire [31:0] HWDATA2;       // AHB2 Write Data bus
  wire [31:0] HWDATA3;       // AHB3 Write Data bus
  wire        HSELMPMCTR0;   // AHB0 Peripheral (Trickbox) Select
  wire        HSELMPMCTR1;   // AHB1 Peripheral (Trickbox) Select
  wire        HSELMPMCTR2;   // AHB2 Peripheral (Trickbox) Select
  wire        HSELMPMCTR3;   // AHB3 Peripheral (Trickbox) Select
  wire        HSELMPMCREG;   // AHB Peripheral (MPMC Reg) Select (for AHB0)
  wire  [3:0] MPMCCLKOUT;    // Memory clock out from MPMC
  wire  [3:0] MPMCCKEOUT;    // Clock Enable Pin to memory device
  wire        nMPMCRASOUT;   // nMPMCRASOUT output from the memory module
  wire        nMPMCCASOUT;   // nMPMCCASOUT output from the memory module
  wire  [3:0] nMPMCDYCSOUT;  // Synchronise memory Chip Select from MPMC
  wire  [3:0] nMPMCSTCSOUT;  // Memory Bank Select signals from the MPMC
  wire  [3:0] MPMCACTLOWCS;  // Active low Memory Bank Select from TrickMem
  wire        nMPMCWEOUT;    // nMPMCWEOUT output from the memory module
  wire  [3:0] nMPMCDATAEN;   // Data Bus enable signal
  wire        nMPMCOEOUT;    // Memory read enable
  wire  [3:0] MPMCDQMOUT;    // Data Bus Lane Enable signal
  wire        nMPMCRPOUT;    // Sync Flash Reset/Power down signal
  wire        MPMCRPVHHOUT;  // Sync Flash Reset/Power down to be driven to VHH
  wire        MPMCSREFACK;   // Self referesh acknowledge from MPMC
  wire [27:0] MPMCADDROUT;   // Memory Address from the MPMC
  wire [31:0] MPMCDATAIN;    // Memory Data Out from the MPMC
  wire [31:0] MPMCDATAOUT;   // Memory Data Out from the MPMC
  wire        MPMCEBIREQ;    // EBI request from the controller
  wire        HREADYOutMpmc0;// HREADY0 from MPMC
  wire        HREADYOutMpmc1;// HREADY1 from MPMC

// Outputs
  wire  [9:0] MPMCTrStExtWt; // Extended Wait count to the memory block
  wire        HREADYOUT0;    // Slave HREADY output (AHB0)
  wire        HREADYOUT1;    // Slave HREADY output (AHB1)
  wire        HREADYOUT2;    // Slave HREADY output (AHB2)
  wire        HREADYOUT3;    // Slave HREADY output (AHB3)
  wire  [1:0] HRESP0;        // Slave response (AHB0)
  wire  [1:0] HRESP1;        // Slave response (AHB1)
  wire  [1:0] HRESP2;        // Slave response (AHB2)
  wire  [1:0] HRESP3;        // Slave response (AHB3)
  wire        MPMCCLK;       // Memory clock to the MPMC
  wire        nPOR;          // Power On Reset
  wire        MPMCSREFREQ;   // Self refersh reques to MPMC
  wire        MPMCBIGENDIAN; // Endianness
  wire        MPMCSTCS0POL;  // Indicates CS1 polarity
  wire        MPMCSTCS1POL;  // Indicates CS2 polarity
  wire        MPMCSTCS2POL;  // Indicates CS3 polarity
  wire        MPMCSTCS3POL;  // Indicates CS4 polarity
  wire        MPMCSTCS1PB;   // BLS pin
  wire        MPMCEBIGNT;    // EBI grant to the controller
  wire        MPMCEBIBACKOFF;// EBI backoff to the controller
  wire  [1:0] MPMCSTCS1MW;   // Indicates CS1 memory width
  wire [31:0] HRDATA0;       // AHB0 Read Data bus
  wire [31:0] HRDATA1;       // AHB1 Read Data bus
  wire [31:0] HRDATA2;       // AHB2 Read Data bus
  wire [31:0] HRDATA3;       // AHB3 Read Data bus

// -----------------------------------------------------------------------------
//
//                                  MpmcTrick
//                                  =========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block is the top level of the Trickbox. This block instantiates the
// following functional sub-blocks in the trickbox.
//      - MpmcTrAhbif
//      - MpmcTrRegBlk
//      - MpmcTrClkResGen
//      - MpmcTrProChkr
//      - MpmcTrSnp
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        LatencyChkEn;
wire  [8:0] MPMCTrSR;
wire  [6:0] MPMCTrCR;
wire  [3:0] MPMCTrSNPCR;
wire  [3:0] MPMCTrExpRef;
wire  [5:0] MPMCTrExBkOff;
wire  [7:0] HREADY0CNT;
wire  [7:0] HREADY1CNT;
wire  [3:0] MPMCTrControl;
wire  [9:0] MPMCTrConfig;
wire [15:0] MPMCTrDynCntl;
wire [10:0] MPMCTrDynRfrsh;
wire  [9:0] MPMCTrDynRC0;
wire  [9:0] MPMCTrDynRC1;
wire  [9:0] MPMCTrDynRC2;
wire  [9:0] MPMCTrDynRC3;
wire [29:0] MPMCTrDynCnfg0;
wire [29:0] MPMCTrDynCnfg1;
wire [29:0] MPMCTrDynCnfg2;
wire [29:0] MPMCTrDynCnfg3;
wire  [6:0] MPMCTrStCS;
wire  [3:0] MPMCTrDynMEMT;
wire  [3:0] MPMCTrWrPrStat;
wire  [3:0] MPMCTrTES;
wire  [8:0] DataSR;
wire        nReset;
wire [31:0] FifoIn;
wire        Fifo1Rd;
wire        Fifo2Rd;
wire        Fifo1Rd0;
wire        Fifo2Rd0;
wire        Fifo1Rd1;
wire        Fifo2Rd1;
wire        Fifo1Rd2;
wire        Fifo2Rd2;
wire        Fifo1Rd3;
wire        Fifo2Rd3;
wire [31:0] Fifo1Out;
wire [31:0] Fifo2Out;
wire [31:0] WriteData;
wire [31:0] WriteData0;
wire [31:0] WriteData1;
wire [31:0] WriteData2;
wire [31:0] WriteData3;
wire        MPMCTrCRWr3;
wire        MPMCTrSRWr3;
wire        MPMCTrSNPCRWr3;
wire        MPMCTrControlWr3;
wire        MPMCTrConfigWr3;
wire        MPMCTrDynCntlWr3;
wire        MPMCTrDyRfrshWr3;
wire        MPMCTrStExtWtWr3;
wire        MPMCTrDynRC0Wr3;
wire        MPMCTrDynRC1Wr3;
wire        MPMCTrDynRC2Wr3;
wire        MPMCTrDynRC3Wr3;
wire        MPMCTrDyCnfg0Wr3;
wire        MPMCTrDyCnfg1Wr3;
wire        MPMCTrDyCnfg2Wr3;
wire        MPMCTrDyCnfg3Wr3;
wire        MPMCTrStCSWr3;
wire        MPMCTrTESWr;
wire        MPMCTrTESWr0;
wire        MPMCTrTESWr1;
wire        MPMCTrTESWr2;
wire        MPMCTrTESWr3;
wire        MPMCTrExpRefWr3;
wire        MPMCTrExBkOffWr3;
// wire        iMPMCCLK;
wire        inPOR;

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
// Instantiation of MpmcTrAhbif (AHB0)
// -----------------------------------------------------------------------------
MpmcTrAhbif u0MpmcTrAhbif             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR0),
                    .HTRANS           (HTRANS0),
                    .HWRITE           (HWRITE0),
                    .HSIZE            (HSIZE0),
                    .HREADYIN         (HREADYIN0),
                    .MPMCTrSR         (MPMCTrSR),
                    .HWDATA           (HWDATA0),
                    .HSELMPMCTR       (HSELMPMCTR0),
                    .HSELMPMCREG      (HSELMPMCREG),
                    .Fifo1Out         (Fifo1Out),
                    .Fifo2Out         (Fifo2Out),
                    .MPMCTrCR         (MPMCTrCR),
                    .MPMCTrSNPCR      (MPMCTrSNPCR),
                    .MPMCTrExpRef     (MPMCTrExpRef),
                    .MPMCTrExBkOff    (MPMCTrExBkOff),
                    .HREADY0CNT       (HREADY0CNT),
                    .HREADY1CNT       (HREADY1CNT),
                    .MPMCTrStCS       (MPMCTrStCS),
                    .MPMCTrTES        (MPMCTrTES),
                    .HREADYOUT        (HREADYOUT0),
                    .HRESP            (HRESP0),
                    .HRDATA           (HRDATA0),
                    .WriteData        (WriteData0),
                    .MPMCTrSRWr       (),
                    .MPMCTrCRWr       (),
                    .MPMCTrSNPCRWr    (),
                    .MPMCTrControlWr  (),
                    .MPMCTrConfigWr   (),
                    .MPMCTrDynCntlWr  (),
                    .MPMCTrDynRfrshWr (), 
                    .MPMCTrStExtWtWr  (),
                    .MPMCTrDynRC0Wr   (),
                    .MPMCTrDynRC1Wr   (),
                    .MPMCTrDynRC2Wr   (),
                    .MPMCTrDynRC3Wr   (),
                    .MPMCTrDynCnfg0Wr (), 
                    .MPMCTrDynCnfg1Wr (), 
                    .MPMCTrDynCnfg2Wr (), 
                    .MPMCTrDynCnfg3Wr (), 
                    .MPMCTrStCSWr     (),
                    .MPMCTrTESWr      (MPMCTrTESWr0),
                    .MPMCTrExpRefWr   (),
                    .MPMCTrExBkOffWr  (),
                    .HREADY0CNTWr     (),
                    .HREADY1CNTWr     (),
                    .Fifo1Rd          (Fifo1Rd0),
                    .Fifo2Rd          (Fifo2Rd0)
                    );

// -----------------------------------------------------------------------------
// Instantiation of MpmcTrAhbif (AHB1)
// -----------------------------------------------------------------------------
MpmcTrAhbif u1MpmcTrAhbif             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR1),
                    .HTRANS           (HTRANS1),
                    .HWRITE           (HWRITE1),
                    .HSIZE            (HSIZE1),
                    .HREADYIN         (HREADYIN1),
                    .MPMCTrSR         (MPMCTrSR),
                    .HWDATA           (HWDATA1),
                    .HSELMPMCTR       (HSELMPMCTR1),
                    .HSELMPMCREG      (HSELMPMCREG),
                    .Fifo1Out         (Fifo1Out),
                    .Fifo2Out         (Fifo2Out),
                    .MPMCTrCR         (MPMCTrCR),
                    .MPMCTrSNPCR      (MPMCTrSNPCR),
                    .MPMCTrExpRef     (MPMCTrExpRef),
                    .MPMCTrExBkOff    (MPMCTrExBkOff),
                    .HREADY0CNT       (HREADY0CNT),
                    .HREADY1CNT       (HREADY1CNT),
                    .MPMCTrStCS       (MPMCTrStCS),
                    .MPMCTrTES        (MPMCTrTES),
                    .HREADYOUT        (HREADYOUT1),
                    .HRESP            (HRESP1),
                    .HRDATA           (HRDATA1),
                    .WriteData        (WriteData1),
                    .MPMCTrSRWr       (),
                    .MPMCTrCRWr       (),
                    .MPMCTrSNPCRWr    (),
                    .MPMCTrControlWr  (),
                    .MPMCTrConfigWr   (),
                    .MPMCTrDynCntlWr  (),
                    .MPMCTrDynRfrshWr (), 
                    .MPMCTrStExtWtWr  (),
                    .MPMCTrDynRC0Wr   (),
                    .MPMCTrDynRC1Wr   (),
                    .MPMCTrDynRC2Wr   (),
                    .MPMCTrDynRC3Wr   (),
                    .MPMCTrDynCnfg0Wr (), 
                    .MPMCTrDynCnfg1Wr (), 
                    .MPMCTrDynCnfg2Wr (), 
                    .MPMCTrDynCnfg3Wr (), 
                    .MPMCTrStCSWr     (),
                    .MPMCTrTESWr      (MPMCTrTESWr1),
                    .MPMCTrExpRefWr   (),
                    .MPMCTrExBkOffWr  (),
                    .HREADY0CNTWr     (),
                    .HREADY1CNTWr     (),
                    .Fifo1Rd          (Fifo1Rd1),
                    .Fifo2Rd          (Fifo2Rd1)
                    );

// -----------------------------------------------------------------------------
// Instantiation of MpmcTrAhbif (AHB2)
// -----------------------------------------------------------------------------
MpmcTrAhbif u2MpmcTrAhbif             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR2),
                    .HTRANS           (HTRANS2),
                    .HWRITE           (HWRITE2),
                    .HSIZE            (HSIZE2),
                    .HREADYIN         (HREADYIN2),
                    .MPMCTrSR         (MPMCTrSR),
                    .HWDATA           (HWDATA2),
                    .HSELMPMCTR       (HSELMPMCTR2),
                    .HSELMPMCREG      (HSELMPMCREG),
                    .Fifo1Out         (Fifo1Out),
                    .Fifo2Out         (Fifo2Out),
                    .MPMCTrCR         (MPMCTrCR),
                    .MPMCTrSNPCR      (MPMCTrSNPCR),
                    .MPMCTrExpRef     (MPMCTrExpRef),
                    .MPMCTrExBkOff    (MPMCTrExBkOff),
                    .HREADY0CNT       (HREADY0CNT),
                    .HREADY1CNT       (HREADY1CNT),
                    .MPMCTrStCS       (MPMCTrStCS),
                    .MPMCTrTES        (MPMCTrTES),
                    .HREADYOUT        (HREADYOUT2),
                    .HRESP            (HRESP2),
                    .HRDATA           (HRDATA2),
                    .WriteData        (WriteData2),
                    .MPMCTrSRWr       (),
                    .MPMCTrCRWr       (),
                    .MPMCTrSNPCRWr    (),
                    .MPMCTrControlWr  (),
                    .MPMCTrConfigWr   (),
                    .MPMCTrDynCntlWr  (),
                    .MPMCTrDynRfrshWr (), 
                    .MPMCTrStExtWtWr  (),
                    .MPMCTrDynRC0Wr   (),
                    .MPMCTrDynRC1Wr   (),
                    .MPMCTrDynRC2Wr   (),
                    .MPMCTrDynRC3Wr   (),
                    .MPMCTrDynCnfg0Wr (), 
                    .MPMCTrDynCnfg1Wr (), 
                    .MPMCTrDynCnfg2Wr (), 
                    .MPMCTrDynCnfg3Wr (), 
                    .MPMCTrStCSWr     (),
                    .MPMCTrTESWr      (MPMCTrTESWr2),
                    .MPMCTrExpRefWr   (),
                    .MPMCTrExBkOffWr  (),
                    .HREADY0CNTWr     (),
                    .HREADY1CNTWr     (),
                    .Fifo1Rd          (Fifo1Rd2),
                    .Fifo2Rd          (Fifo2Rd2)
                    );

// -----------------------------------------------------------------------------
// Instantiation of MpmcTrAhbif (AHB3)
// -----------------------------------------------------------------------------
MpmcTrAhbif u3MpmcTrAhbif             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR3),
                    .HTRANS           (HTRANS3),
                    .HWRITE           (HWRITE3),
                    .HSIZE            (HSIZE3),
                    .HREADYIN         (HREADYIN3),
                    .MPMCTrSR         (MPMCTrSR),
                    .HWDATA           (HWDATA3),
                    .HSELMPMCTR       (HSELMPMCTR3),
                    .HSELMPMCREG      (HSELMPMCREG),
                    .Fifo1Out         (Fifo1Out),
                    .Fifo2Out         (Fifo2Out),
                    .MPMCTrCR         (MPMCTrCR),
                    .MPMCTrSNPCR      (MPMCTrSNPCR),
                    .MPMCTrExpRef     (MPMCTrExpRef),
                    .MPMCTrExBkOff    (MPMCTrExBkOff),
                    .HREADY0CNT       (HREADY0CNT),
                    .HREADY1CNT       (HREADY1CNT),
                    .MPMCTrStCS       (MPMCTrStCS),
                    .MPMCTrTES        (MPMCTrTES),
                    .HREADYOUT        (HREADYOUT3),
                    .HRESP            (HRESP3),
                    .HRDATA           (HRDATA3),
                    .WriteData        (WriteData3),
                    .MPMCTrSRWr       (MPMCTrSRWr3),
                    .MPMCTrCRWr       (MPMCTrCRWr3),
                    .MPMCTrSNPCRWr    (MPMCTrSNPCRWr3),
                    .MPMCTrControlWr  (MPMCTrControlWr3),
                    .MPMCTrConfigWr   (MPMCTrConfigWr3),
                    .MPMCTrDynCntlWr  (MPMCTrDynCntlWr3),
                    .MPMCTrDynRfrshWr (MPMCTrDyRfrshWr3), 
                    .MPMCTrStExtWtWr  (MPMCTrStExtWtWr3),
                    .MPMCTrDynRC0Wr   (MPMCTrDynRC0Wr3),
                    .MPMCTrDynRC1Wr   (MPMCTrDynRC1Wr3),
                    .MPMCTrDynRC2Wr   (MPMCTrDynRC2Wr3),
                    .MPMCTrDynRC3Wr   (MPMCTrDynRC3Wr3),
                    .MPMCTrDynCnfg0Wr (MPMCTrDyCnfg0Wr3), 
                    .MPMCTrDynCnfg1Wr (MPMCTrDyCnfg1Wr3), 
                    .MPMCTrDynCnfg2Wr (MPMCTrDyCnfg2Wr3), 
                    .MPMCTrDynCnfg3Wr (MPMCTrDyCnfg3Wr3), 
                    .MPMCTrStCSWr     (MPMCTrStCSWr3),
                    .MPMCTrTESWr      (MPMCTrTESWr3),
                    .MPMCTrExpRefWr   (MPMCTrExpRefWr3),
                    .MPMCTrExBkOffWr  (MPMCTrExBkOffWr3),
                    .HREADY0CNTWr     (HREADY0CNTWr),
                    .HREADY1CNTWr     (HREADY1CNTWr),
                    .Fifo1Rd          (Fifo1Rd3),
                    .Fifo2Rd          (Fifo2Rd3)
                    );

// -----------------------------------------------------------------------------
// Instantiation of MpmcTrRegBlk
// -----------------------------------------------------------------------------
MpmcTrRegBlk uMpmcTrRegBlk            (
                    .HCLK             (HCLK),
                    .nPOR             (inPOR),
                    .HRESETn          (HRESETn),
                    .HREADYIN0        (HREADYIN0),
                    .HREADYIN1        (HREADYIN1),
                    .HREADYIN2        (HREADYIN2),
                    .HREADYIN3        (HREADYIN3),
                    .WriteData        (WriteData),
                    .MPMCTrSRWr       (MPMCTrSRWr3),
                    .MPMCTrCRWr       (MPMCTrCRWr3),
                    .MPMCTrSNPCRWr    (MPMCTrSNPCRWr3),
                    .MPMCTrControlWr  (MPMCTrControlWr3),
                    .MPMCTrConfigWr   (MPMCTrConfigWr3),
                    .MPMCTrDynCntlWr  (MPMCTrDynCntlWr3),
                    .MPMCTrDynRfrshWr (MPMCTrDyRfrshWr3), 
                    .MPMCTrStExtWtWr  (MPMCTrStExtWtWr3),
                    .MPMCTrDynRC0Wr   (MPMCTrDynRC0Wr3),
                    .MPMCTrDynRC1Wr   (MPMCTrDynRC1Wr3),
                    .MPMCTrDynRC2Wr   (MPMCTrDynRC2Wr3),
                    .MPMCTrDynRC3Wr   (MPMCTrDynRC3Wr3),
                    .MPMCTrDynCnfg0Wr (MPMCTrDyCnfg0Wr3), 
                    .MPMCTrDynCnfg1Wr (MPMCTrDyCnfg1Wr3), 
                    .MPMCTrDynCnfg2Wr (MPMCTrDyCnfg2Wr3), 
                    .MPMCTrDynCnfg3Wr (MPMCTrDyCnfg3Wr3), 
                    .MPMCTrStCSWr     (MPMCTrStCSWr3),
                    .MPMCTrTESWr0     (MPMCTrTESWr0),
                    .MPMCTrTESWr1     (MPMCTrTESWr1),
                    .MPMCTrTESWr2     (MPMCTrTESWr2),
                    .MPMCTrTESWr3     (MPMCTrTESWr3),
                    .MPMCTrExpRefWr   (MPMCTrExpRefWr3),
                    .MPMCTrExBkOffWr  (MPMCTrExBkOffWr3),
                    .HREADY0CNTWr     (HREADY0CNTWr),
                    .HREADY1CNTWr     (HREADY1CNTWr),
                    .MPMCTrCR         (MPMCTrCR),
                    .MPMCTrSNPCR      (MPMCTrSNPCR),
                    .MPMCTrExpRef     (MPMCTrExpRef),
                    .MPMCTrExBkOff    (MPMCTrExBkOff),
                    .HREADY0CNT       (HREADY0CNT),
                    .HREADY1CNT       (HREADY1CNT),
                    .MPMCTrControl    (MPMCTrControl),
                    .MPMCTrConfig     (MPMCTrConfig),
                    .MPMCTrDynCntl    (MPMCTrDynCntl),
                    .MPMCTrDynRfrsh   (MPMCTrDynRfrsh),
                    .MPMCTrStExtWt    (MPMCTrStExtWt),
                    .MPMCTrDynRC0     (MPMCTrDynRC0),
                    .MPMCTrDynRC1     (MPMCTrDynRC1),
                    .MPMCTrDynRC2     (MPMCTrDynRC2),
                    .MPMCTrDynRC3     (MPMCTrDynRC3),
                    .MPMCTrDynCnfg0   (MPMCTrDynCnfg0),
                    .MPMCTrDynCnfg1   (MPMCTrDynCnfg1),
                    .MPMCTrDynCnfg2   (MPMCTrDynCnfg2),
                    .MPMCTrDynCnfg3   (MPMCTrDynCnfg3),
                    .MPMCTrStCS       (MPMCTrStCS),
                    .MPMCTrDynMEMT    (MPMCTrDynMEMT),
                    .MPMCTrWrPrStat   (MPMCTrWrPrStat),
                    .MPMCTrTES        (MPMCTrTES),
                    .DataSR           (DataSR)
                    );

// Internal OR bus
assign WriteData        = WriteData0 | WriteData1 | WriteData2 |
                          WriteData3;
assign Fifo1Rd          = Fifo1Rd0 | Fifo1Rd1 | Fifo1Rd2 | Fifo1Rd3;
assign Fifo2Rd          = Fifo2Rd0 | Fifo2Rd1 | Fifo2Rd2 | Fifo2Rd3;

// -----------------------------------------------------------------------------
// Instantiation of MpmcTrClkResGen
// -----------------------------------------------------------------------------
defparam uMpmcTrClkResGen.Tclkl = Tclkl;
defparam uMpmcTrClkResGen.Tclkh = Tclkh;
defparam uMpmcTrClkResGen.Tclks = Tclks;

MpmcTrClkResGen uMpmcTrClkResGen      (
                    .HCLK             (HCLK),
                    .MPMCCLKOUT       (MPMCCLKOUT),
                    .HRESETn          (HRESETn),
                    .MPMCTrCR         (MPMCTrCR[3:0]),
                    .MPMCTrConfig     (MPMCTrConfig),
                    .MPMCSREFACK      (MPMCSREFACK),
                    .MPMCCLK          (MPMCCLK),
                    .MPMCCLKDELAY     (MPMCCLKDELAY),
                    .nPOR             (inPOR),
                    .nReset           (nReset),
                    .MPMCSREFREQ      (MPMCSREFREQ)
                    );

// -----------------------------------------------------------------------------
// Instantiation of MpmcTrProChkr
// -----------------------------------------------------------------------------
defparam uMpmcTrProChkr.Tclk = Tclkh + Tclkl;

MpmcTrProChkr uMpmcTrProChkr          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .MPMCCLKOUT       (MPMCCLKOUT),
                    .MPMCCLK          (MPMCCLK),
                    .nPOR             (inPOR),
                    .MPMCTrExpRef     (MPMCTrExpRef),
                    .MPMCTrExBkOff    (MPMCTrExBkOff),
                    .MPMCTrSRWr       (MPMCTrSRWr3),
                    .ProtChkMask      (MPMCTrCR[4]),
                    .HREADY0ChkEn     (MPMCTrCR[5]),
                    .HREADY1ChkEn     (MPMCTrCR[6]),
                    .MPMCCKEOUT       (MPMCCKEOUT),
                    .nMPMCRASOUT      (nMPMCRASOUT),
                    .nMPMCCASOUT      (nMPMCCASOUT),
                    .MPMCTrDynMEMT    (MPMCTrDynMEMT),
                    .MPMCTrWrPrStat   (MPMCTrWrPrStat),
                    .nMPMCDYCSOUT     (nMPMCDYCSOUT),
                    .nMPMCSTCSOUT     (nMPMCSTCSOUT),
                    .MPMCACTLOWCS     (MPMCACTLOWCS),
                    .nMPMCWEOUT       (nMPMCWEOUT),
                    .nMPMCDATAEN      (nMPMCDATAEN),
                    .nMPMCOEOUT       (nMPMCOEOUT),
                    .MPMCDQMOUT       (MPMCDQMOUT),
                    .nMPMCRPOUT       (nMPMCRPOUT),
                    .MPMCRPVHHOUT     (MPMCRPVHHOUT),
                    .MPMCSREFACK      (MPMCSREFACK),
                    .MPMCADDROUT      (MPMCADDROUT),
                    .MPMCDATAOUT      (MPMCDATAOUT),
                    .MPMCTrDynRfrshWr (MPMCTrDyRfrshWr3), 
                    .MPMCTrDynRfrsh   (MPMCTrDynRfrsh),
                    .MPMCTrControl    (MPMCTrControl),
                    .MPMCTrDynCntl    (MPMCTrDynCntl),
                    .DataSR           (DataSR),
                    .MPMCEBIREQ       (MPMCEBIREQ),
                    .MPMCEBIGNT       (MPMCEBIGNT),
                    .MPMCEBIBACKOFF   (MPMCEBIBACKOFF),
                    .HREADYOutMpmc0   (HREADYOutMpmc0),
                    .HREADYOutMpmc1   (HREADYOutMpmc1),
                    .HREADY0CNT       (HREADY0CNT),
                    .HREADY1CNT       (HREADY1CNT),
                    .MPMCTrSR         (MPMCTrSR)
                    );

// -----------------------------------------------------------------------------
// Instantiation of MpmcTrSnp
// -----------------------------------------------------------------------------
MpmcTrSnp uMpmcTrSnp                  (
                    .HCLK             (HCLK),
                    .MPMCCLK          (MPMCCLK),
                    .nReset           (nReset),
                    .FifoIn           (FifoIn),
                    .LatencyChkEn     (LatencyChkEn),
                    .MPMCDATAOUT      (MPMCDATAOUT),
                    .MPMCDATAIN       (MPMCDATAIN),
                    .nMPMCDYCSOUT     (nMPMCDYCSOUT),
                    .nMPMCSTCSOUT     (nMPMCSTCSOUT),
                    .MPMCTrSNPCR      (MPMCTrSNPCR),
                    .Fifo1Rd          (Fifo1Rd),
                    .Fifo2Rd          (Fifo2Rd),
                    .MPMCTrDynRC0     (MPMCTrDynRC0),
                    .MPMCTrDynRC1     (MPMCTrDynRC1),
                    .MPMCTrDynRC2     (MPMCTrDynRC2),
                    .MPMCTrDynRC3     (MPMCTrDynRC3),
                    .Fifo1Out         (Fifo1Out),
                    .Fifo2Out         (Fifo2Out)
                    );

assign LatencyChkEn     = MPMCTrCR[2];

// -----------------------------------------------------------------------------
// Input to the fifo
// -----------------------------------------------------------------------------
assign FifoIn           = {1'b0, nMPMCRASOUT, nMPMCCASOUT, nMPMCWEOUT,
                           MPMCADDROUT};

// -----------------------------------------------------------------------------
// Connecting local copies to the output port
// -----------------------------------------------------------------------------
assign MPMCBIGENDIAN    = MPMCTrCR[3];
// assign MPMCCLK          = iMPMCCLK;
assign nPOR             = inPOR;
assign MPMCSTCS0POL     = MPMCTrStCS[0];
assign MPMCSTCS1POL     = MPMCTrStCS[1];
assign MPMCSTCS2POL     = MPMCTrStCS[2];
assign MPMCSTCS3POL     = MPMCTrStCS[3];
assign MPMCSTCS1MW      = MPMCTrStCS[5:4];
assign MPMCSTCS1PB      = MPMCTrStCS[6];
endmodule

// --================================== End ==================================--
