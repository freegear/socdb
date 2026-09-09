// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : Dmac.v.rca
// File Revision          : 1.8
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block is the top level of the Dmac.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module Dmac (
// Inputs
             // Clock and reset
             HCLK,
             HRESETn,
             // AHB slave signals
             HSELDMAC,
             HWRITE,
             HTRANS,
             HADDR,
             HSIZE,
             HREADYIN,
             HWDATA,
             // AHB master signals
             HGRANTDMACM1,
             HGRANTDMACM2,
             HREADYINM1,
             HREADYINM2,
             HRESPM1,
             HRESPM2,
             HRDATAM1,
             HRDATAM2,
             // DMA request signals
             DMACBREQ,
             DMACLBREQ,
             DMACSREQ,
             DMACLSREQ,
             // Scan related signals
             SCANINHCLK,
             SCANENABLE,

// Outputs
             // AHB slave signals
             HREADYOUT,
             HRESP,
             HRDATA,
             // AHB master signals
             HBUSREQDMACM1,
             HBUSREQDMACM2,
             HLOCKDMACM1,
             HLOCKDMACM2,
             HTRANSM1,
             HTRANSM2,
             HADDRM1,
             HADDRM2,
             HSIZEM1,
             HSIZEM2,
             HBURSTM1,
             HBURSTM2,
             HPROTM1,
             HPROTM2,
             HWRITEM1,
             HWRITEM2,
             HWDATAM1,
             HWDATAM2,
             // DMA response signals
             DMACCLR,
             DMACTC,
             // DMA interrupt request signals
             DMACINTERR,
             DMACINTTC,
             DMACINTR,
             // Scan related signals
             SCANOUTHCLK
            );

// Inputs
// Clock and reset
input         HCLK;             // AHB clock
input         HRESETn;          // AHB reset
// AHB slave signals
input         HSELDMAC;         // Slave Select for DMAC
input         HWRITE;           // Transfer direction
input         HTRANS;           // Type of transfer on AHB Only HTRANS(1)
input  [11:2] HADDR;            // AHB address bus
input   [2:0] HSIZE;            // The width of the transfer on AHB
input         HREADYIN;         // Transfer done response on AHB from
input  [31:0] HWDATA;           // AHB slave write data
// AHB master signals
input         HGRANTDMACM1;     // AHB bus grant for master1
input         HGRANTDMACM2;     // AHB bus grant for master2
input         HREADYINM1;       // Transfer done response from AHB 1
input         HREADYINM2;       // Transfer done response from AHB 2
input   [1:0] HRESPM1;          // Transfer response from AHB 1
input   [1:0] HRESPM2;          // Transfer response from AHB 2
input  [31:0] HRDATAM1;         // Read Data from AHB 1
input  [31:0] HRDATAM2;         // Read Data from AHB 2
// DMA request signals
input  [15:0] DMACBREQ;         // DMA burst transfer request
input  [15:0] DMACLBREQ;        // DMA last burst transfer request
input  [15:0] DMACSREQ;         // DMA single transfer request
input  [15:0] DMACLSREQ;        // DMA last single transfer request
// Scan related signals
input         SCANINHCLK;       // Scan input for DMAC
input         SCANENABLE;       // Scan enable

// Outputs
// AHB slave signals
output        HREADYOUT;        // Transfer done response to AHB
output  [1:0] HRESP;            // Transfer response to AHB
output [31:0] HRDATA;           // Read data bus to AHB
// AHB master signals
output        HBUSREQDMACM1;    // Bus request signal to the AHB arbiter 1
output        HBUSREQDMACM2;    // Bus request signal to the AHB arbiter 2
output        HLOCKDMACM1;      // Indicates locked-burst request on AHB 1
output        HLOCKDMACM2;      // Indicates locked-burst request on AHB 2
output  [1:0] HTRANSM1;         // Type of transfer on AHB1
output  [1:0] HTRANSM2;         // Type of transfer on AHB2
output [31:0] HADDRM1;          // AHB1 address bus
output [31:0] HADDRM2;          // AHB2 address bus
output  [2:0] HSIZEM1;          // Width of transfer on AHB1
output  [2:0] HSIZEM2;          // Width of transfer on AHB2
output  [2:0] HBURSTM1;         // Burst length on AHB1
output  [2:0] HBURSTM2;         // Burst length on AHB2
output  [3:0] HPROTM1;          // Protection information on AHB1
output  [3:0] HPROTM2;          // Protection information on AHB2
output        HWRITEM1;         // Transfer direction on AHB1
output        HWRITEM2;         // Transfer direction on AHB2
output [31:0] HWDATAM1;         // Write data to AHB1
output [31:0] HWDATAM2;         // Write data to AHB2
// DMA response signals
output [15:0] DMACCLR;          // DMA request clear
output [15:0] DMACTC;           // DMA terminal count
// DMA interrupt request signals
output        DMACINTERR;       // DMA error interrupt request
output        DMACINTTC;        // DMA terminal count interrupt request
output        DMACINTR;         // DMA combined interrupt request
// Scan related signals
output        SCANOUTHCLK;      // Scan out of DMAC

// Inputs
// Clock and reset
wire          HCLK;             // AHB clock
wire          HRESETn;          // AHB reset
// AHB slave signals
wire          HSELDMAC;         // Slave Select for DMAC
wire          HWRITE;           // Transfer direction
wire          HTRANS;           // Type of transfer on AHB Only HTRANS(1)
                                // of the slave AHB should connect
wire   [11:2] HADDR;            // AHB address bus
wire    [2:0] HSIZE;            // The width of the transfer on AHB
wire          HREADYIN;         // Transfer done response on AHB from
                                // previous Slave
wire   [31:0] HWDATA;           // AHB slave write data
// AHB master signals
wire          HGRANTDMACM1;     // AHB bus grant for master1
wire          HGRANTDMACM2;     // AHB bus grant for master2
wire          HREADYINM1;       // Transfer done response from AHB 1
wire          HREADYINM2;       // Transfer done response from AHB 2
wire    [1:0] HRESPM1;          // Transfer response from AHB 1
wire    [1:0] HRESPM2;          // Transfer response from AHB 2
wire   [31:0] HRDATAM1;         // Read Data from AHB 1
wire   [31:0] HRDATAM2;         // Read Data from AHB 2
// DMA request signals
wire   [15:0] DMACBREQ;         // DMA burst transfer request
wire   [15:0] DMACLBREQ;        // DMA last burst transfer request
wire   [15:0] DMACSREQ;         // DMA single transfer request
wire   [15:0] DMACLSREQ;        // DMA last single transfer request
// Scan related signals
wire          SCANINHCLK;       // Scan input for DMAC
wire          SCANENABLE;       // Scan enable

// Outputs
// AHB slave signals
wire          HREADYOUT;        // Transfer done response to AHB
wire    [1:0] HRESP;            // Transfer response to AHB
wire   [31:0] HRDATA;           // Read data bus to AHB
// AHB master signals
wire          HBUSREQDMACM1;    // Bus request signal to the AHB arbiter 1
wire          HBUSREQDMACM2;    // Bus request signal to the AHB arbiter 2
wire          HLOCKDMACM1;      // Indicates locked-burst request on AHB 1
wire          HLOCKDMACM2;      // Indicates locked-burst request on AHB 2
wire    [1:0] HTRANSM1;         // Type of transfer on AHB1
wire    [1:0] HTRANSM2;         // Type of transfer on AHB2
wire   [31:0] HADDRM1;          // AHB1 address bus
wire   [31:0] HADDRM2;          // AHB2 address bus
wire    [2:0] HSIZEM1;          // Width of transfer on AHB1
wire    [2:0] HSIZEM2;          // Width of transfer on AHB2
wire    [2:0] HBURSTM1;         // Burst length on AHB1
wire    [2:0] HBURSTM2;         // Burst length on AHB2
wire    [3:0] HPROTM1;          // Protection information on AHB1
wire    [3:0] HPROTM2;          // Protection information on AHB2
wire          HWRITEM1;         // Transfer direction on AHB1
wire          HWRITEM2;         // Transfer direction on AHB2
wire   [31:0] HWDATAM1;         // Write data to AHB1
wire   [31:0] HWDATAM2;         // Write data to AHB2
// DMA response signals
wire   [15:0] DMACCLR;          // DMA request clear
wire   [15:0] DMACTC;           // DMA terminal count
// DMA interrupt request signals
wire          DMACINTERR;       // DMA error interrupt request
wire          DMACINTTC;        // DMA terminal count interrupt request
wire          DMACINTR;         // DMA combined interrupt request
// Scan related signals
wire          SCANOUTHCLK;      // Scan out of DMAC

// -----------------------------------------------------------------------------
//
//                                    Dmac
//                                    ====
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block is the top level of the DMAC. This block instantiates the
// following functional sub-blocks in the DMAC.
//      - DmacRqstSync
//          This module is used for double synchronization of the DMA Requests
//        coming from the peripherals
//      - DmacRspRoute
//          This module routes the responses given to the peripherals from
//        different channels
//      - DmacAhbSlaveIf
//          The module used to interface the AHB and the programming registers
//        the DMA Controller
//      - DmacAhbMaster(2 instances)
//          This modules are the actual AHB master interfaces for the DMA
//        Controller
//      - DmacChannel(8 instances)
//          The 8 instances of Channel are instantiating the control logic and
//        the required data path logic for the
//      - DmacRevAnd(4 instances)
//          The module to give the Peripheral and PrimeCell Identification
//        number of the DMA Controller
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [31:0] Ch0HRDATA;
// Read data bus from channel 0

wire [31:0] Ch1HRDATA;
// Read data bus from channel 1

wire [31:0] Ch2HRDATA;
// Read data bus from channel 2

wire [31:0] Ch3HRDATA;
// Read data bus from channel 3

wire [31:0] Ch4HRDATA;
// Read data bus from channel 4

wire [31:0] Ch5HRDATA;
// Read data bus from channel 5

wire [31:0] Ch6HRDATA;
// Read data bus from channel 6

wire [31:0] Ch7HRDATA;
// Read data bus from channel 7

wire [15:0] DMACBREQSync;
// Synchronised signal for DMACSREQ

wire [15:0] DMACLBREQSync;
// Synchronised signal for DMACBREQ

wire [15:0] DMACSREQSync;
// Synchronised signal for DMACLSREQ

wire [15:0] DMACLSREQSync;
// Synchronised signal for DMACLBREQ

wire        ChannelEn0;
// Channel 0 is enabled

wire        ChannelEn1;
// Channel 1 is enabled

wire        ChannelEn2;
// Channel 2 is enabled

wire        ChannelEn3;
// Channel 3 is enabled

wire        ChannelEn4;
// Channel 4 is enabled

wire        ChannelEn5;
// Channel 5 is enabled

wire        ChannelEn6;
// Channel 6 is enabled

wire        ChannelEn7;
// Channel 7 is enabled

wire        IntErrCh0;
// Error Interrupt for channel 0

wire        IntErrCh1;
// Error Interrupt for channel 1

wire        IntErrCh2;
// Error Interrupt for channel 2

wire        IntErrCh3;
// Error Interrupt for channel 3

wire        IntErrCh4;
// Error Interrupt for channel 4

wire        IntErrCh5;
// Error Interrupt for channel 5

wire        IntErrCh6;
// Error Interrupt for channel 6

wire        IntErrCh7;
// Error Interrupt for channel 7

wire        IntTCCh0;
// TC Interrupt for channel 0

wire        IntTCCh1;
// TC Interrupt for channel 1

wire        IntTCCh2;
// TC Interrupt for channel 2

wire        IntTCCh3;
// TC Interrupt for channel 3

wire        IntTCCh4;
// TC Interrupt for channel 4

wire        IntTCCh5;
// TC Interrupt for channel 5

wire        IntTCCh6;
// TC Interrupt for channel 6

wire        IntTCCh7;
// TC Interrupt for channel 7

wire        RawIntErrCh0;
// Raw Error Interrupt for Channel 0

wire        RawIntErrCh1;
// Raw Error Interrupt for Channel 1

wire        RawIntErrCh2;
// Raw Error Interrupt for Channel 2

wire        RawIntErrCh3;
// Raw Error Interrupt for Channel 3

wire        RawIntErrCh4;
// Raw Error Interrupt for Channel 4

wire        RawIntErrCh5;
// Raw Error Interrupt for Channel 5

wire        RawIntErrCh6;
// Raw Error Interrupt for Channel 6

wire        RawIntErrCh7;
// Raw Error Interrupt for Channel 7

wire        RawIntTCCh0;
// Raw TC Interrupt for Channel 0

wire        RawIntTCCh1;
// Raw TC Interrupt for Channel 1

wire        RawIntTCCh2;
// Raw TC Interrupt for Channel 2

wire        RawIntTCCh3;
// Raw TC Interrupt for Channel 3

wire        RawIntTCCh4;
// Raw TC Interrupt for Channel 4

wire        RawIntTCCh5;
// Raw TC Interrupt for Channel 5

wire        RawIntTCCh6;
// Raw TC Interrupt for Channel 6

wire        RawIntTCCh7;
// Raw TC Interrupt for Channel 7

wire [15:0] ErrClrReq0;
// Clear DMAREQ from Channel 0 for Error

wire [15:0] ErrClrReq1;
// Clear DMAREQ from Channel 1 for Error

wire [15:0] ErrClrReq2;
// Clear DMAREQ from Channel 2 for Error

wire [15:0] ErrClrReq3;
// Clear DMAREQ from Channel 3 for Error

wire [15:0] ErrClrReq4;
// Clear DMAREQ from Channel 4 for Error

wire [15:0] ErrClrReq5;
// Clear DMAREQ from Channel 5 for Error

wire [15:0] ErrClrReq6;
// Clear DMAREQ from Channel 6 for Error

wire [15:0] ErrClrReq7;
// Clear DMAREQ from Channel 7 for Error

wire [15:0] ClearReq0;
// Clear DMAREQ from Channel 0

wire [15:0] ClearReq1;
// Clear DMAREQ from Channel 1

wire [15:0] ClearReq2;
// Clear DMAREQ from Channel 2

wire [15:0] ClearReq3;
// Clear DMAREQ from Channel 3

wire [15:0] ClearReq4;
// Clear DMAREQ from Channel 4

wire [15:0] ClearReq5;
// Clear DMAREQ from Channel 5

wire [15:0] ClearReq6;
// Clear DMAREQ from Channel 6

wire [15:0] ClearReq7;
// Clear DMAREQ from Channel 7

wire [15:0] SigTC0;
// DMACTC signal from Channel 0

wire [15:0] SigTC1;
// DMACTC signal from Channel 1

wire [15:0] SigTC2;
// DMACTC signal from Channel 2

wire [15:0] SigTC3;
// DMACTC signal from Channel 3

wire [15:0] SigTC4;
// DMACTC signal from Channel 4

wire [15:0] SigTC5;
// DMACTC signal from Channel 5

wire [15:0] SigTC6;
// DMACTC signal from Channel 6

wire [15:0] SigTC7;
// DMACTC signal from Channel 7

wire        RegHWrite;
// Write enable signal to DMAC channel registers

wire  [4:2] RegAddress;
// Registered lower order address bits for register addressing

wire        DmacChannelSel0;
// Read-Write Select for channel 0

wire        DmacChannelSel1;
// Read-Write Select for channel 1

wire        DmacChannelSel2;
// Read-Write Select for channel 2

wire        DmacChannelSel3;
// Read-Write Select for channel 3

wire        DmacChannelSel4;
// Read-Write Select for channel 4

wire        DmacChannelSel5;
// Read-Write Select for channel 5

wire        DmacChannelSel6;
// Read-Write Select for channel 6

wire        DmacChannelSel7;
// Read-Write Select for channel 7

wire [15:0] MskdDMACSREQ;
// Gated DMACSREQ with DMACEn

wire [15:0] MskdDMACBREQ;
// Gated DMACBREQ with DMACEn

wire [15:0] MskdDMACLSREQ;
// Gated DMACLSREQ with DMACEn

wire [15:0] MskdDMACLBREQ;
// Gated DMACLBREQ with DMACEn

wire [15:0] ClearReq;
// Combined Clear DMAREQ from all the channels

wire        ClrIntTC0;
// TC Interrupt clear for channel 0

wire        ClrIntTC1;
// TC Interrupt clear for channel 1

wire        ClrIntTC2;
// TC Interrupt clear for channel 2

wire        ClrIntTC3;
// TC Interrupt clear for channel 3

wire        ClrIntTC4;
// TC Interrupt clear for channel 4

wire        ClrIntTC5;
// TC Interrupt clear for channel 5

wire        ClrIntTC6;
// TC Interrupt clear for channel 6

wire        ClrIntTC7;
// TC Interrupt clear for channel 7

wire        ClrIntErr0;
// Error Interrupt clear for channel 0

wire        ClrIntErr1;
// Error Interrupt clear for channel 1

wire        ClrIntErr2;
// Error Interrupt clear for channel 2

wire        ClrIntErr3;
// Error Interrupt clear for channel 3

wire        ClrIntErr4;
// Error Interrupt clear for channel 4

wire        ClrIntErr5;
// Error Interrupt clear for channel 5

wire        ClrIntErr6;
// Error Interrupt clear for channel 6

wire        ClrIntErr7;
// Error Interrupt clear for channel 7

wire [15:0] DMACBREQCh;
// DMA burst transfer request

wire [15:0] DMACLBREQCh;
// DMAC last burst transfer request

wire [15:0] DMACSREQCh;
// DMAC single transfer request

wire [15:0] DMACLSREQCh;
// DMAC last single transfer request

wire        ITEN;
// Integration Test enable

wire [15:0] DMACITOP1;
// Integration test output register DMACITOP1

wire [15:0] DMACITOP2;
// Integration test output register DMACITOP2

wire  [1:0] DMACITOP3;
// Integration test output register DMACITOP3

wire        DMACEn;
// DMA Controller Enable

wire        BigEndianM1;
// Endian-ness bit for master 1

wire        BigEndianM2;
// Endian-ness bit for master 2

wire        BusAvlblM1;
// AHB1 Data/Address Bus available

wire        BusAvlblM2;
// AHB2 Data/Address Bus available

// Master 1 signals
// Signals indicating the number of transfers requested
wire  [4:0] Ch0NumOfXfers1;
// Number of AHB transfers requested by channel 0

wire  [4:0] Ch1NumOfXfers1;
// Number of AHB transfers requested by channel 1

wire  [4:0] Ch2NumOfXfers1;
// Number of AHB transfers requested by channel 2

wire  [4:0] Ch3NumOfXfers1;
// Number of AHB transfers requested by channel 3

wire  [4:0] Ch4NumOfXfers1;
// Number of AHB transfers requested by channel 4

wire  [4:0] Ch5NumOfXfers1;
// Number of AHB transfers requested by channel 5

wire  [4:0] Ch6NumOfXfers1;
// Number of AHB transfers requested by channel 6

wire  [4:0] Ch7NumOfXfers1;
// Number of AHB transfers requested by channel 7

// Signals From channels to AHB master module
wire        Ch0ReqM1;
// Channel 0 request for AHB1

wire        Ch1ReqM1;
// Channel 1 request for AHB1

wire        Ch2ReqM1;
// Channel 2 request for AHB1

wire        Ch3ReqM1;
// Channel 3 request for AHB1

wire        Ch4ReqM1;
// Channel 4 request for AHB1

wire        Ch5ReqM1;
// Channel 5 request for AHB1

wire        Ch6ReqM1;
// Channel 6 request for AHB1

wire        Ch7ReqM1;
// Channel 7 request for AHB1

wire        Ch0IncrM1;
// Indicates incrementing transfers are required for channel 0

wire        Ch1IncrM1;
// Indicates incrementing transfers are required for channel 1

wire        Ch2IncrM1;
// Indicates incrementing transfers are required for channel 2

wire        Ch3IncrM1;
// Indicates incrementing transfers are required for channel 3

wire        Ch4IncrM1;
// Indicates incrementing transfers are required for channel 4

wire        Ch5IncrM1;
// Indicates incrementing transfers are required for channel 5

wire        Ch6IncrM1;
// Indicates incrementing transfers are required for channel 6

wire        Ch7IncrM1;
// Indicates incrementing transfers are required for channel 7

wire [31:0] Ch0AddrM1;
// First address for the AHB Access requested by channel 0

wire [31:0] Ch1AddrM1;
// First address for the AHB Access requested by channel 1

wire [31:0] Ch2AddrM1;
// First address for the AHB Access requested by channel 2

wire [31:0] Ch3AddrM1;
// First address for the AHB Access requested by channel 3

wire [31:0] Ch4AddrM1;
// First address for the AHB Access requested by channel 4

wire [31:0] Ch5AddrM1;
// First address for the AHB Access requested by channel 5

wire [31:0] Ch6AddrM1;
// First address for the AHB Access requested by channel 6

wire [31:0] Ch7AddrM1;
// First address for the AHB Access requested by channel 7

wire  [2:0] Ch0ProtM1;
// HPROT information for channel 0

wire  [2:0] Ch1ProtM1;
// HPROT information for channel 1

wire  [2:0] Ch2ProtM1;
// HPROT information for channel 2

wire  [2:0] Ch3ProtM1;
// HPROT information for channel 3

wire  [2:0] Ch4ProtM1;
// HPROT information for channel 4

wire  [2:0] Ch5ProtM1;
// HPROT information for channel 5

wire  [2:0] Ch6ProtM1;
// HPROT information for channel 6

wire  [2:0] Ch7ProtM1;
// HPROT information for channel 7

wire        Ch0LockM;
// HLOCK information for channel 0

wire        Ch1LockM;
// HLOCK information for channel 1

wire        Ch2LockM;
// HLOCK information for channel 2

wire        Ch3LockM;
// HLOCK information for channel 3

wire        Ch4LockM;
// HLOCK information for channel 4

wire        Ch5LockM;
// HLOCK information for channel 5

wire        Ch6LockM;
// HLOCK information for channel 6

wire        Ch7LockM;
// HLOCK information for channel 7

wire  [2:0] Ch0WidthM1;
// HSIZE information for channel 0

wire  [2:0] Ch1WidthM1;
// HSIZE information for channel 1

wire  [2:0] Ch2WidthM1;
// HSIZE information for channel 2

wire  [2:0] Ch3WidthM1;
// HSIZE information for channel 3

wire  [2:0] Ch4WidthM1;
// HSIZE information for channel 4

wire  [2:0] Ch5WidthM1;
// HSIZE information for channel 5

wire  [2:0] Ch6WidthM1;
// HSIZE information for channel 6

wire  [2:0] Ch7WidthM1;
// HSIZE information for channel 7

wire        Ch0DirxnM1;
// HWRITE information for channel 0

wire        Ch1DirxnM1;
// HWRITE information for channel 1

wire        Ch2DirxnM1;
// HWRITE information for channel 2

wire        Ch3DirxnM1;
// HWRITE information for channel 3

wire        Ch4DirxnM1;
// HWRITE information for channel 4

wire        Ch5DirxnM1;
// HWRITE information for channel 5

wire        Ch6DirxnM1;
// HWRITE information for channel 6

wire        Ch7DirxnM1;
// HWRITE information for channel 7

wire        Ch0XferAbort1;
// Request to abort the AHB transfer from channel 0

wire        Ch1XferAbort1;
// Request to abort the AHB transfer from channel 1

wire        Ch2XferAbort1;
// Request to abort the AHB transfer from channel 2

wire        Ch3XferAbort1;
// Request to abort the AHB transfer from channel 3

wire        Ch4XferAbort1;
// Request to abort the AHB transfer from channel 4

wire        Ch5XferAbort1;
// Request to abort the AHB transfer from channel 5

wire        Ch6XferAbort1;
// Request to abort the AHB transfer from channel 6

wire        Ch7XferAbort1;
// Request to abort the AHB transfer from channel 7

wire [31:0] Ch0HWDATA1;
// The HWDATA information from the channel 0

wire [31:0] Ch1HWDATA1;
// The HWDATA information from the channel 1

wire [31:0] Ch2HWDATA1;
// The HWDATA information from the channel 2

wire [31:0] Ch3HWDATA1;
// The HWDATA information from the channel 3

wire [31:0] Ch4HWDATA1;
// The HWDATA information from the channel 4

wire [31:0] Ch5HWDATA1;
// The HWDATA information from the channel 5

wire [31:0] Ch6HWDATA1;
// The HWDATA information from the channel 6

wire [31:0] Ch7HWDATA1;
// The HWDATA information from the channel 7

// Grant to channel
wire        Ch0GntM1;
// Grant for channel 0 from master1

wire        Ch1GntM1;
// Grant for channel 1 from master1

wire        Ch2GntM1;
// Grant for channel 2 from master1

wire        Ch3GntM1;
// Grant for channel 3 from master1

wire        Ch4GntM1;
// Grant for channel 4 from master1

wire        Ch5GntM1;
// Grant for channel 5 from master1

wire        Ch6GntM1;
// Grant for channel 6 from master1

wire        Ch7GntM1;
// Grant for channel 7 from master1

// Master 2 signals
// The number of transfers requested
wire  [4:0] Ch0NumOfXfers2;
// Number of AHB transfers requested by channel 0

wire  [4:0] Ch1NumOfXfers2;
// Number of AHB transfers requested by channel 1

wire  [4:0] Ch2NumOfXfers2;
// Number of AHB transfers requested by channel 2

wire  [4:0] Ch3NumOfXfers2;
// Number of AHB transfers requested by channel 3

wire  [4:0] Ch4NumOfXfers2;
// Number of AHB transfers requested by channel 4

wire  [4:0] Ch5NumOfXfers2;
// Number of AHB transfers requested by channel 5

wire  [4:0] Ch6NumOfXfers2;
// Number of AHB transfers requested by channel 6

wire  [4:0] Ch7NumOfXfers2;
// Number of AHB transfers requested by channel 7

// From channel to AHB master module
wire        Ch0ReqM2;
// Channel 0 request for AHB2

wire        Ch1ReqM2;
// Channel 1 request for AHB2

wire        Ch2ReqM2;
// Channel 2 request for AHB2

wire        Ch3ReqM2;
// Channel 3 request for AHB2

wire        Ch4ReqM2;
// Channel 4 request for AHB2

wire        Ch5ReqM2;
// Channel 5 request for AHB2

wire        Ch6ReqM2;
// Channel 6 request for AHB2

wire        Ch7ReqM2;
// Channel 7 request for AHB2

wire        Ch0IncrM2;
// Indicates incrementing transfers are required for channel 0

wire        Ch1IncrM2;
// Indicates incrementing transfers are required for channel 1

wire        Ch2IncrM2;
// Indicates incrementing transfers are required for channel 2

wire        Ch3IncrM2;
// Indicates incrementing transfers are required for channel 3

wire        Ch4IncrM2;
// Indicates incrementing transfers are required for channel 4

wire        Ch5IncrM2;
// Indicates incrementing transfers are required for channel 5

wire        Ch6IncrM2;
// Indicates incrementing transfers are required for channel 6

wire        Ch7IncrM2;
// Indicates incrementing transfers are required for channel 7

wire [31:0] Ch0AddrM2;
// First address for the AHB Access requested by channel 0

wire [31:0] Ch1AddrM2;
// First address for the AHB Access requested by channel 1

wire [31:0] Ch2AddrM2;
// First address for the AHB Access requested by channel 2

wire [31:0] Ch3AddrM2;
// First address for the AHB Access requested by channel 3

wire [31:0] Ch4AddrM2;
// First address for the AHB Access requested by channel 4

wire [31:0] Ch5AddrM2;
// First address for the AHB Access requested by channel 5

wire [31:0] Ch6AddrM2;
// First address for the AHB Access requested by channel 6

wire [31:0] Ch7AddrM2;
// First address for the AHB Access requested by channel 7

wire  [2:0] Ch0ProtM2;
// HPROT information for channel 0

wire  [2:0] Ch1ProtM2;
// HPROT information for channel 1

wire  [2:0] Ch2ProtM2;
// HPROT information for channel 2

wire  [2:0] Ch3ProtM2;
// HPROT information for channel 3

wire  [2:0] Ch4ProtM2;
// HPROT information for channel 4

wire  [2:0] Ch5ProtM2;
// HPROT information for channel 5

wire  [2:0] Ch6ProtM2;
// HPROT information for channel 6

wire  [2:0] Ch7ProtM2;
// HPROT information for channel 7

wire  [2:0] Ch0WidthM2;
// HSIZE information for channel 0

wire  [2:0] Ch1WidthM2;
// HSIZE information for channel 1

wire  [2:0] Ch2WidthM2;
// HSIZE information for channel 2

wire  [2:0] Ch3WidthM2;
// HSIZE information for channel 3

wire  [2:0] Ch4WidthM2;
// HSIZE information for channel 4

wire  [2:0] Ch5WidthM2;
// HSIZE information for channel 5

wire  [2:0] Ch6WidthM2;
// HSIZE information for channel 6

wire  [2:0] Ch7WidthM2;
// HSIZE information for channel 7

wire        Ch0DirxnM2;
// HWRITE information for channel 0

wire        Ch1DirxnM2;
// HWRITE information for channel 1

wire        Ch2DirxnM2;
// HWRITE information for channel 2

wire        Ch3DirxnM2;
// HWRITE information for channel 3

wire        Ch4DirxnM2;
// HWRITE information for channel 4

wire        Ch5DirxnM2;
// HWRITE information for channel 5

wire        Ch6DirxnM2;
// HWRITE information for channel 6

wire        Ch7DirxnM2;
// HWRITE information for channel 7

wire        Ch0XferAbort2;
// Request to abort the AHB transfer from channel 0

wire        Ch1XferAbort2;
// Request to abort the AHB transfer from channel 1

wire        Ch2XferAbort2;
// Request to abort the AHB transfer from channel 2

wire        Ch3XferAbort2;
// Request to abort the AHB transfer from channel 3

wire        Ch4XferAbort2;
// Request to abort the AHB transfer from channel 4

wire        Ch5XferAbort2;
// Request to abort the AHB transfer from channel 5

wire        Ch6XferAbort2;
// Request to abort the AHB transfer from channel 6

wire        Ch7XferAbort2;
// Request to abort the AHB transfer from channel 7

wire [31:0] Ch0HWDATA2;
// The HWDATA information from the channel 0

wire [31:0] Ch1HWDATA2;
// The HWDATA information from the channel 1

wire [31:0] Ch2HWDATA2;
// The HWDATA information from the channel 2

wire [31:0] Ch3HWDATA2;
// The HWDATA information from the channel 3

wire [31:0] Ch4HWDATA2;
// The HWDATA information from the channel 4

wire [31:0] Ch5HWDATA2;
// The HWDATA information from the channel 5

wire [31:0] Ch6HWDATA2;
// The HWDATA information from the channel 6

wire [31:0] Ch7HWDATA2;
// The HWDATA information from the channel 7

// Grant to channel
wire        Ch0GntM2;
// Grant for channel 0 from master2

wire        Ch1GntM2;
// Grant for channel 1 from master2

wire        Ch2GntM2;
// Grant for channel 2 from master2

wire        Ch3GntM2;
// Grant for channel 3 from master2

wire        Ch4GntM2;
// Grant for channel 4 from master2

wire        Ch5GntM2;
// Grant for channel 5 from master2

wire        Ch6GntM2;
// Grant for channel 6 from master2

wire        Ch7GntM2;
// Grant for channel 7 from master2

wire [31:0] MasterAddressM1;
// HADDR information for master 1

wire [31:0] MasterAddressM2;
// HADDR information for master 2

wire  [3:0] TieOff1;
// Input 1 for RevAnd

wire  [3:0] TieOff2;
// Input 2 for RevAnd

wire  [3:0] Revision;
// Output of RevAnd

// Internal copies of output signals
wire [15:0] iDMACCLR;
// Internal copy of DMACCLR

wire [15:0] iDMACTC;
// Internal copy of DMACTC

wire        iDMACINTERR;
// Internal copy of DMACINTERR

wire        iDMACINTTC;
// Internal copy of DMACINTTC

wire        DataErrorM1;
// Data error on AHB1

wire        DataErrorM2;
// Data error on AHB2

wire        XferAbortedM1;
// Acknowledgement to abort request from master 1

wire        XferAbortedM2;
// Acknowledgement to abort request from master 2

wire [31:0] ChWrDataM1;
// Endianized Read Data of AHB 1 to be written into channel FIFO

wire [31:0] ChWrDataM2;
// Endianized Read Data of AHB 2 to be written into channel FIFO

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
// Instantiation of DmacAhbSlaveIf
// -----------------------------------------------------------------------------
DmacAhbSlaveIf uDmacAhbSlaveIf        (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HSELDMAC         (HSELDMAC),
                    .HWRITE           (HWRITE),
                    .HTRANS           (HTRANS),
                    .HWDATA           (HWDATA[15:0]),
                    .HADDR            (HADDR),
                    .HSIZE            (HSIZE),
                    .HREADYIN         (HREADYIN),
                    .Revision         (Revision),
                    .Ch0HRDATA        (Ch0HRDATA),
                    .Ch1HRDATA        (Ch1HRDATA),
                    .Ch2HRDATA        (Ch2HRDATA),
                    .Ch3HRDATA        (Ch3HRDATA),
                    .Ch4HRDATA        (Ch4HRDATA),
                    .Ch5HRDATA        (Ch5HRDATA),
                    .Ch6HRDATA        (Ch6HRDATA),
                    .Ch7HRDATA        (Ch7HRDATA),
                    .DMACBREQ         (DMACBREQ),
                    .DMACLBREQ        (DMACLBREQ),
                    .DMACSREQ         (DMACSREQ),
                    .DMACLSREQ        (DMACLSREQ),
                    .DMACSREQSync     (DMACSREQSync),
                    .DMACBREQSync     (DMACBREQSync),
                    .DMACLSREQSync    (DMACLSREQSync),
                    .DMACLBREQSync    (DMACLBREQSync),
                    .DMACCLR          (iDMACCLR),
                    .DMACTC           (iDMACTC),
                    .DMACINTERR       (iDMACINTERR),
                    .DMACINTTC        (iDMACINTTC),
                    .ChannelEn0       (ChannelEn0),
                    .ChannelEn1       (ChannelEn1),
                    .ChannelEn2       (ChannelEn2),
                    .ChannelEn3       (ChannelEn3),
                    .ChannelEn4       (ChannelEn4),
                    .ChannelEn5       (ChannelEn5),
                    .ChannelEn6       (ChannelEn6),
                    .ChannelEn7       (ChannelEn7),
                    .IntErrCh0        (IntErrCh0),
                    .IntErrCh1        (IntErrCh1),
                    .IntErrCh2        (IntErrCh2),
                    .IntErrCh3        (IntErrCh3),
                    .IntErrCh4        (IntErrCh4),
                    .IntErrCh5        (IntErrCh5),
                    .IntErrCh6        (IntErrCh6),
                    .IntErrCh7        (IntErrCh7),
                    .IntTCCh0         (IntTCCh0),
                    .IntTCCh1         (IntTCCh1),
                    .IntTCCh2         (IntTCCh2),
                    .IntTCCh3         (IntTCCh3),
                    .IntTCCh4         (IntTCCh4),
                    .IntTCCh5         (IntTCCh5),
                    .IntTCCh6         (IntTCCh6),
                    .IntTCCh7         (IntTCCh7),
                    .RawIntErrCh0     (RawIntErrCh0),
                    .RawIntErrCh1     (RawIntErrCh1),
                    .RawIntErrCh2     (RawIntErrCh2),
                    .RawIntErrCh3     (RawIntErrCh3),
                    .RawIntErrCh4     (RawIntErrCh4),
                    .RawIntErrCh5     (RawIntErrCh5),
                    .RawIntErrCh6     (RawIntErrCh6),
                    .RawIntErrCh7     (RawIntErrCh7),
                    .RawIntTCCh0      (RawIntTCCh0),
                    .RawIntTCCh1      (RawIntTCCh1),
                    .RawIntTCCh2      (RawIntTCCh2),
                    .RawIntTCCh3      (RawIntTCCh3),
                    .RawIntTCCh4      (RawIntTCCh4),
                    .RawIntTCCh5      (RawIntTCCh5),
                    .RawIntTCCh6      (RawIntTCCh6),
                    .RawIntTCCh7      (RawIntTCCh7),
                    .ClearReq         (ClearReq),
                    .ErrClrReq0       (ErrClrReq0),
                    .ErrClrReq1       (ErrClrReq1),
                    .ErrClrReq2       (ErrClrReq2),
                    .ErrClrReq3       (ErrClrReq3),
                    .ErrClrReq4       (ErrClrReq4),
                    .ErrClrReq5       (ErrClrReq5),
                    .ErrClrReq6       (ErrClrReq6),
                    .ErrClrReq7       (ErrClrReq7),
                    .HREADYOUT        (HREADYOUT),
                    .HRESP            (HRESP),
                    .HRDATA           (HRDATA),
                    .RegHWrite        (RegHWrite),
                    .RegAddress       (RegAddress),
                    .DmacChannelSel0  (DmacChannelSel0),
                    .DmacChannelSel1  (DmacChannelSel1),
                    .DmacChannelSel2  (DmacChannelSel2),
                    .DmacChannelSel3  (DmacChannelSel3),
                    .DmacChannelSel4  (DmacChannelSel4),
                    .DmacChannelSel5  (DmacChannelSel5),
                    .DmacChannelSel6  (DmacChannelSel6),
                    .DmacChannelSel7  (DmacChannelSel7),
                    .MskdDMACSREQ     (MskdDMACSREQ),
                    .MskdDMACBREQ     (MskdDMACBREQ),
                    .MskdDMACLSREQ    (MskdDMACLSREQ),
                    .MskdDMACLBREQ    (MskdDMACLBREQ),
                    .ClrIntTC0        (ClrIntTC0),
                    .ClrIntTC1        (ClrIntTC1),
                    .ClrIntTC2        (ClrIntTC2),
                    .ClrIntTC3        (ClrIntTC3),
                    .ClrIntTC4        (ClrIntTC4),
                    .ClrIntTC5        (ClrIntTC5),
                    .ClrIntTC6        (ClrIntTC6),
                    .ClrIntTC7        (ClrIntTC7),
                    .ClrIntErr0       (ClrIntErr0),
                    .ClrIntErr1       (ClrIntErr1),
                    .ClrIntErr2       (ClrIntErr2),
                    .ClrIntErr3       (ClrIntErr3),
                    .ClrIntErr4       (ClrIntErr4),
                    .ClrIntErr5       (ClrIntErr5),
                    .ClrIntErr6       (ClrIntErr6),
                    .ClrIntErr7       (ClrIntErr7),
                    .DMACBREQCh       (DMACBREQCh),
                    .DMACLBREQCh      (DMACLBREQCh),
                    .DMACSREQCh       (DMACSREQCh),
                    .DMACLSREQCh      (DMACLSREQCh),
                    .ITEN             (ITEN),
                    .DMACITOP1        (DMACITOP1),
                    .DMACITOP2        (DMACITOP2),
                    .DMACITOP3        (DMACITOP3),
                    .DMACEn           (DMACEn),
                    .BigEndianM1      (BigEndianM1),
                    .BigEndianM2      (BigEndianM2)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacAhbMaster 1
// -----------------------------------------------------------------------------
DmacAhbMaster u1DmacAhbMaster         (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HGRANTDMACM      (HGRANTDMACM1),
                    .HREADYINM        (HREADYINM1),
                    .HRESPM           (HRESPM1),
                    .HRDATAM          (HRDATAM1),
                    .BigEndianM       (BigEndianM1),
                    .Ch0ReqM          (Ch0ReqM1),
                    .Ch1ReqM          (Ch1ReqM1),
                    .Ch2ReqM          (Ch2ReqM1),
                    .Ch3ReqM          (Ch3ReqM1),
                    .Ch4ReqM          (Ch4ReqM1),
                    .Ch5ReqM          (Ch5ReqM1),
                    .Ch6ReqM          (Ch6ReqM1),
                    .Ch7ReqM          (Ch7ReqM1),
                    .Ch0LockM         (Ch0LockM),
                    .Ch1LockM         (Ch1LockM),
                    .Ch2LockM         (Ch2LockM),
                    .Ch3LockM         (Ch3LockM),
                    .Ch4LockM         (Ch4LockM),
                    .Ch5LockM         (Ch5LockM),
                    .Ch6LockM         (Ch6LockM),
                    .Ch7LockM         (Ch7LockM),
                    .Ch0NumOfXfers    (Ch0NumOfXfers1),
                    .Ch1NumOfXfers    (Ch1NumOfXfers1),
                    .Ch2NumOfXfers    (Ch2NumOfXfers1),
                    .Ch3NumOfXfers    (Ch3NumOfXfers1),
                    .Ch4NumOfXfers    (Ch4NumOfXfers1),
                    .Ch5NumOfXfers    (Ch5NumOfXfers1),
                    .Ch6NumOfXfers    (Ch6NumOfXfers1),
                    .Ch7NumOfXfers    (Ch7NumOfXfers1),
                    .Ch0IncrM         (Ch0IncrM1),
                    .Ch1IncrM         (Ch1IncrM1),
                    .Ch2IncrM         (Ch2IncrM1),
                    .Ch3IncrM         (Ch3IncrM1),
                    .Ch4IncrM         (Ch4IncrM1),
                    .Ch5IncrM         (Ch5IncrM1),
                    .Ch6IncrM         (Ch6IncrM1),
                    .Ch7IncrM         (Ch7IncrM1),
                    .Ch0AddrM         (Ch0AddrM1),
                    .Ch1AddrM         (Ch1AddrM1),
                    .Ch2AddrM         (Ch2AddrM1),
                    .Ch3AddrM         (Ch3AddrM1),
                    .Ch4AddrM         (Ch4AddrM1),
                    .Ch5AddrM         (Ch5AddrM1),
                    .Ch6AddrM         (Ch6AddrM1),
                    .Ch7AddrM         (Ch7AddrM1),
                    .Ch0ProtM         (Ch0ProtM1),
                    .Ch1ProtM         (Ch1ProtM1),
                    .Ch2ProtM         (Ch2ProtM1),
                    .Ch3ProtM         (Ch3ProtM1),
                    .Ch4ProtM         (Ch4ProtM1),
                    .Ch5ProtM         (Ch5ProtM1),
                    .Ch6ProtM         (Ch6ProtM1),
                    .Ch7ProtM         (Ch7ProtM1),
                    .Ch0WidthM        (Ch0WidthM1),
                    .Ch1WidthM        (Ch1WidthM1),
                    .Ch2WidthM        (Ch2WidthM1),
                    .Ch3WidthM        (Ch3WidthM1),
                    .Ch4WidthM        (Ch4WidthM1),
                    .Ch5WidthM        (Ch5WidthM1),
                    .Ch6WidthM        (Ch6WidthM1),
                    .Ch7WidthM        (Ch7WidthM1),
                    .Ch0DirxnM        (Ch0DirxnM1),
                    .Ch1DirxnM        (Ch1DirxnM1),
                    .Ch2DirxnM        (Ch2DirxnM1),
                    .Ch3DirxnM        (Ch3DirxnM1),
                    .Ch4DirxnM        (Ch4DirxnM1),
                    .Ch5DirxnM        (Ch5DirxnM1),
                    .Ch6DirxnM        (Ch6DirxnM1),
                    .Ch7DirxnM        (Ch7DirxnM1),
                    .Ch0XferAbort     (Ch0XferAbort1),
                    .Ch1XferAbort     (Ch1XferAbort1),
                    .Ch2XferAbort     (Ch2XferAbort1),
                    .Ch3XferAbort     (Ch3XferAbort1),
                    .Ch4XferAbort     (Ch4XferAbort1),
                    .Ch5XferAbort     (Ch5XferAbort1),
                    .Ch6XferAbort     (Ch6XferAbort1),
                    .Ch7XferAbort     (Ch7XferAbort1),
                    .Ch0HWDATA        (Ch0HWDATA1),
                    .Ch1HWDATA        (Ch1HWDATA1),
                    .Ch2HWDATA        (Ch2HWDATA1),
                    .Ch3HWDATA        (Ch3HWDATA1),
                    .Ch4HWDATA        (Ch4HWDATA1),
                    .Ch5HWDATA        (Ch5HWDATA1),
                    .Ch6HWDATA        (Ch6HWDATA1),
                    .Ch7HWDATA        (Ch7HWDATA1),
                    .HBUSREQDMACM     (HBUSREQDMACM1),
                    .HLOCKDMACM       (HLOCKDMACM1),
                    .HPROTM           (HPROTM1),
                    .HBURSTM          (HBURSTM1),
                    .HTRANSM          (HTRANSM1),
                    .HADDRM           (HADDRM1),
                    .HSIZEM           (HSIZEM1),
                    .HWRITEM          (HWRITEM1),
                    .HWDATAM          (HWDATAM1),
                    .BusAvlblM        (BusAvlblM1),
                    .DataError        (DataErrorM1),
                    .XferAborted      (XferAbortedM1),
                    .Ch0GntM          (Ch0GntM1),
                    .Ch1GntM          (Ch1GntM1),
                    .Ch2GntM          (Ch2GntM1),
                    .Ch3GntM          (Ch3GntM1),
                    .Ch4GntM          (Ch4GntM1),
                    .Ch5GntM          (Ch5GntM1),
                    .Ch6GntM          (Ch6GntM1),
                    .Ch7GntM          (Ch7GntM1),
                    .MasterAddress    (MasterAddressM1),
                    .ChWrData         (ChWrDataM1)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacAhbMaster 2
// -----------------------------------------------------------------------------
DmacAhbMaster u2DmacAhbMaster         (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HGRANTDMACM      (HGRANTDMACM2),
                    .HREADYINM        (HREADYINM2),
                    .HRESPM           (HRESPM2),
                    .HRDATAM          (HRDATAM2),
                    .BigEndianM       (BigEndianM2),
                    .Ch0ReqM          (Ch0ReqM2),
                    .Ch1ReqM          (Ch1ReqM2),
                    .Ch2ReqM          (Ch2ReqM2),
                    .Ch3ReqM          (Ch3ReqM2),
                    .Ch4ReqM          (Ch4ReqM2),
                    .Ch5ReqM          (Ch5ReqM2),
                    .Ch6ReqM          (Ch6ReqM2),
                    .Ch7ReqM          (Ch7ReqM2),
                    .Ch0LockM         (Ch0LockM),
                    .Ch1LockM         (Ch1LockM),
                    .Ch2LockM         (Ch2LockM),
                    .Ch3LockM         (Ch3LockM),
                    .Ch4LockM         (Ch4LockM),
                    .Ch5LockM         (Ch5LockM),
                    .Ch6LockM         (Ch6LockM),
                    .Ch7LockM         (Ch7LockM),
                    .Ch0NumOfXfers    (Ch0NumOfXfers2),
                    .Ch1NumOfXfers    (Ch1NumOfXfers2),
                    .Ch2NumOfXfers    (Ch2NumOfXfers2),
                    .Ch3NumOfXfers    (Ch3NumOfXfers2),
                    .Ch4NumOfXfers    (Ch4NumOfXfers2),
                    .Ch5NumOfXfers    (Ch5NumOfXfers2),
                    .Ch6NumOfXfers    (Ch6NumOfXfers2),
                    .Ch7NumOfXfers    (Ch7NumOfXfers2),
                    .Ch0IncrM         (Ch0IncrM2),
                    .Ch1IncrM         (Ch1IncrM2),
                    .Ch2IncrM         (Ch2IncrM2),
                    .Ch3IncrM         (Ch3IncrM2),
                    .Ch4IncrM         (Ch4IncrM2),
                    .Ch5IncrM         (Ch5IncrM2),
                    .Ch6IncrM         (Ch6IncrM2),
                    .Ch7IncrM         (Ch7IncrM2),
                    .Ch0AddrM         (Ch0AddrM2),
                    .Ch1AddrM         (Ch1AddrM2),
                    .Ch2AddrM         (Ch2AddrM2),
                    .Ch3AddrM         (Ch3AddrM2),
                    .Ch4AddrM         (Ch4AddrM2),
                    .Ch5AddrM         (Ch5AddrM2),
                    .Ch6AddrM         (Ch6AddrM2),
                    .Ch7AddrM         (Ch7AddrM2),
                    .Ch0ProtM         (Ch0ProtM2),
                    .Ch1ProtM         (Ch1ProtM2),
                    .Ch2ProtM         (Ch2ProtM2),
                    .Ch3ProtM         (Ch3ProtM2),
                    .Ch4ProtM         (Ch4ProtM2),
                    .Ch5ProtM         (Ch5ProtM2),
                    .Ch6ProtM         (Ch6ProtM2),
                    .Ch7ProtM         (Ch7ProtM2),
                    .Ch0WidthM        (Ch0WidthM2),
                    .Ch1WidthM        (Ch1WidthM2),
                    .Ch2WidthM        (Ch2WidthM2),
                    .Ch3WidthM        (Ch3WidthM2),
                    .Ch4WidthM        (Ch4WidthM2),
                    .Ch5WidthM        (Ch5WidthM2),
                    .Ch6WidthM        (Ch6WidthM2),
                    .Ch7WidthM        (Ch7WidthM2),
                    .Ch0DirxnM        (Ch0DirxnM2),
                    .Ch1DirxnM        (Ch1DirxnM2),
                    .Ch2DirxnM        (Ch2DirxnM2),
                    .Ch3DirxnM        (Ch3DirxnM2),
                    .Ch4DirxnM        (Ch4DirxnM2),
                    .Ch5DirxnM        (Ch5DirxnM2),
                    .Ch6DirxnM        (Ch6DirxnM2),
                    .Ch7DirxnM        (Ch7DirxnM2),
                    .Ch0XferAbort     (Ch0XferAbort2),
                    .Ch1XferAbort     (Ch1XferAbort2),
                    .Ch2XferAbort     (Ch2XferAbort2),
                    .Ch3XferAbort     (Ch3XferAbort2),
                    .Ch4XferAbort     (Ch4XferAbort2),
                    .Ch5XferAbort     (Ch5XferAbort2),
                    .Ch6XferAbort     (Ch6XferAbort2),
                    .Ch7XferAbort     (Ch7XferAbort2),
                    .Ch0HWDATA        (Ch0HWDATA2),
                    .Ch1HWDATA        (Ch1HWDATA2),
                    .Ch2HWDATA        (Ch2HWDATA2),
                    .Ch3HWDATA        (Ch3HWDATA2),
                    .Ch4HWDATA        (Ch4HWDATA2),
                    .Ch5HWDATA        (Ch5HWDATA2),
                    .Ch6HWDATA        (Ch6HWDATA2),
                    .Ch7HWDATA        (Ch7HWDATA2),
                    .HBUSREQDMACM     (HBUSREQDMACM2),
                    .HLOCKDMACM       (HLOCKDMACM2),
                    .HPROTM           (HPROTM2),
                    .HBURSTM          (HBURSTM2),
                    .HTRANSM          (HTRANSM2),
                    .HADDRM           (HADDRM2),
                    .HSIZEM           (HSIZEM2),
                    .HWRITEM          (HWRITEM2),
                    .HWDATAM          (HWDATAM2),
                    .BusAvlblM        (BusAvlblM2),
                    .DataError        (DataErrorM2),
                    .XferAborted      (XferAbortedM2),
                    .Ch0GntM          (Ch0GntM2),
                    .Ch1GntM          (Ch1GntM2),
                    .Ch2GntM          (Ch2GntM2),
                    .Ch3GntM          (Ch3GntM2),
                    .Ch4GntM          (Ch4GntM2),
                    .Ch5GntM          (Ch5GntM2),
                    .Ch6GntM          (Ch6GntM2),
                    .Ch7GntM          (Ch7GntM2),
                    .MasterAddress    (MasterAddressM2),
                    .ChWrData         (ChWrDataM2)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacChannel0
// -----------------------------------------------------------------------------
DmacChannel u0DmacChannel             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .MasterAddressM1  (MasterAddressM1),
                    .MasterAddressM2  (MasterAddressM2),
                    .ChWrDataM1       (ChWrDataM1),
                    .ChWrDataM2       (ChWrDataM2),
                    .BusAvlblM1       (BusAvlblM1),
                    .BusAvlblM2       (BusAvlblM2),
                    .DataErrorM1      (DataErrorM1),
                    .DataErrorM2      (DataErrorM2),
                    .XferAbortedM1    (XferAbortedM1),
                    .XferAbortedM2    (XferAbortedM2),
                    .RegHWrite        (RegHWrite),
                    .RegAddress       (RegAddress),
                    .DmacChannelSel   (DmacChannelSel0),
                    .HWDATA           (HWDATA),
                    .ClrIntTC         (ClrIntTC0),
                    .ClrIntErr        (ClrIntErr0),
                    .DMACBREQCh       (DMACBREQCh),
                    .DMACLBREQCh      (DMACLBREQCh),
                    .DMACSREQCh       (DMACSREQCh),
                    .DMACLSREQCh      (DMACLSREQCh),
                    .DMACEn           (DMACEn),
                    .ChGntM1          (Ch0GntM1),
                    .ChGntM2          (Ch0GntM2),
                    .ChHRDATA         (Ch0HRDATA),
                    .ChannelEn        (ChannelEn0),
                    .IntErrCh         (IntErrCh0),
                    .IntTCCh          (IntTCCh0),
                    .RawIntErrCh      (RawIntErrCh0),
                    .RawIntTCCh       (RawIntTCCh0),
                    .ClearReq         (ClearReq0),
                    .SigTC            (SigTC0),
                    .ErrClrReq        (ErrClrReq0),
                    .ChLock           (Ch0LockM),
                    .ChNumOfXfersM1   (Ch0NumOfXfers1),
                    .ChReqM1          (Ch0ReqM1),
                    .ChIncrM1         (Ch0IncrM1),
                    .ChAddrM1         (Ch0AddrM1),
                    .ChProtM1         (Ch0ProtM1),
                    .ChWidthM1        (Ch0WidthM1),
                    .ChDirxnM1        (Ch0DirxnM1),
                    .ChXferAbortM1    (Ch0XferAbort1),
                    .ChHWDATAM1       (Ch0HWDATA1),
                    .ChNumOfXfersM2   (Ch0NumOfXfers2),
                    .ChReqM2          (Ch0ReqM2),
                    .ChIncrM2         (Ch0IncrM2),
                    .ChAddrM2         (Ch0AddrM2),
                    .ChProtM2         (Ch0ProtM2),
                    .ChWidthM2        (Ch0WidthM2),
                    .ChDirxnM2        (Ch0DirxnM2),
                    .ChXferAbortM2    (Ch0XferAbort2),
                    .ChHWDATAM2       (Ch0HWDATA2)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacChannel1
// -----------------------------------------------------------------------------
DmacChannel u1DmacChannel             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .MasterAddressM1  (MasterAddressM1),
                    .MasterAddressM2  (MasterAddressM2),
                    .ChWrDataM1       (ChWrDataM1),
                    .ChWrDataM2       (ChWrDataM2),
                    .BusAvlblM1       (BusAvlblM1),
                    .BusAvlblM2       (BusAvlblM2),
                    .DataErrorM1      (DataErrorM1),
                    .DataErrorM2      (DataErrorM2),
                    .XferAbortedM1    (XferAbortedM1),
                    .XferAbortedM2    (XferAbortedM2),
                    .RegHWrite        (RegHWrite),
                    .RegAddress       (RegAddress),
                    .DmacChannelSel   (DmacChannelSel1),
                    .HWDATA           (HWDATA),
                    .ClrIntTC         (ClrIntTC1),
                    .ClrIntErr        (ClrIntErr1),
                    .DMACBREQCh       (DMACBREQCh),
                    .DMACLBREQCh      (DMACLBREQCh),
                    .DMACSREQCh       (DMACSREQCh),
                    .DMACLSREQCh      (DMACLSREQCh),
                    .DMACEn           (DMACEn),
                    .ChGntM1          (Ch1GntM1),
                    .ChGntM2          (Ch1GntM2),
                    .ChHRDATA         (Ch1HRDATA),
                    .ChannelEn        (ChannelEn1),
                    .IntErrCh         (IntErrCh1),
                    .IntTCCh          (IntTCCh1),
                    .RawIntErrCh      (RawIntErrCh1),
                    .RawIntTCCh       (RawIntTCCh1),
                    .ClearReq         (ClearReq1),
                    .SigTC            (SigTC1),
                    .ErrClrReq        (ErrClrReq1),
                    .ChLock           (Ch1LockM),
                    .ChNumOfXfersM1   (Ch1NumOfXfers1),
                    .ChReqM1          (Ch1ReqM1),
                    .ChIncrM1         (Ch1IncrM1),
                    .ChAddrM1         (Ch1AddrM1),
                    .ChProtM1         (Ch1ProtM1),
                    .ChWidthM1        (Ch1WidthM1),
                    .ChDirxnM1        (Ch1DirxnM1),
                    .ChXferAbortM1    (Ch1XferAbort1),
                    .ChHWDATAM1       (Ch1HWDATA1),
                    .ChNumOfXfersM2   (Ch1NumOfXfers2),
                    .ChReqM2          (Ch1ReqM2),
                    .ChIncrM2         (Ch1IncrM2),
                    .ChAddrM2         (Ch1AddrM2),
                    .ChProtM2         (Ch1ProtM2),
                    .ChWidthM2        (Ch1WidthM2),
                    .ChDirxnM2        (Ch1DirxnM2),
                    .ChXferAbortM2    (Ch1XferAbort2),
                    .ChHWDATAM2       (Ch1HWDATA2)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacChannel2
// -----------------------------------------------------------------------------
DmacChannel u2DmacChannel             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .MasterAddressM1  (MasterAddressM1),
                    .MasterAddressM2  (MasterAddressM2),
                    .ChWrDataM1       (ChWrDataM1),
                    .ChWrDataM2       (ChWrDataM2),
                    .BusAvlblM1       (BusAvlblM1),
                    .BusAvlblM2       (BusAvlblM2),
                    .DataErrorM1      (DataErrorM1),
                    .DataErrorM2      (DataErrorM2),
                    .XferAbortedM1    (XferAbortedM1),
                    .XferAbortedM2    (XferAbortedM2),
                    .RegHWrite        (RegHWrite),
                    .RegAddress       (RegAddress),
                    .DmacChannelSel   (DmacChannelSel2),
                    .HWDATA           (HWDATA),
                    .ClrIntTC         (ClrIntTC2),
                    .ClrIntErr        (ClrIntErr2),
                    .DMACBREQCh       (DMACBREQCh),
                    .DMACLBREQCh      (DMACLBREQCh),
                    .DMACSREQCh       (DMACSREQCh),
                    .DMACLSREQCh      (DMACLSREQCh),
                    .DMACEn           (DMACEn),
                    .ChGntM1          (Ch2GntM1),
                    .ChGntM2          (Ch2GntM2),
                    .ChHRDATA         (Ch2HRDATA),
                    .ChannelEn        (ChannelEn2),
                    .IntErrCh         (IntErrCh2),
                    .IntTCCh          (IntTCCh2),
                    .RawIntErrCh      (RawIntErrCh2),
                    .RawIntTCCh       (RawIntTCCh2),
                    .ClearReq         (ClearReq2),
                    .SigTC            (SigTC2),
                    .ErrClrReq        (ErrClrReq2),
                    .ChLock           (Ch2LockM),
                    .ChNumOfXfersM1   (Ch2NumOfXfers1),
                    .ChReqM1          (Ch2ReqM1),
                    .ChIncrM1         (Ch2IncrM1),
                    .ChAddrM1         (Ch2AddrM1),
                    .ChProtM1         (Ch2ProtM1),
                    .ChWidthM1        (Ch2WidthM1),
                    .ChDirxnM1        (Ch2DirxnM1),
                    .ChXferAbortM1    (Ch2XferAbort1),
                    .ChHWDATAM1       (Ch2HWDATA1),
                    .ChNumOfXfersM2   (Ch2NumOfXfers2),
                    .ChReqM2          (Ch2ReqM2),
                    .ChIncrM2         (Ch2IncrM2),
                    .ChAddrM2         (Ch2AddrM2),
                    .ChProtM2         (Ch2ProtM2),
                    .ChWidthM2        (Ch2WidthM2),
                    .ChDirxnM2        (Ch2DirxnM2),
                    .ChXferAbortM2    (Ch2XferAbort2),
                    .ChHWDATAM2       (Ch2HWDATA2)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacChannel3
// -----------------------------------------------------------------------------
DmacChannel u3DmacChannel             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .MasterAddressM1  (MasterAddressM1),
                    .MasterAddressM2  (MasterAddressM2),
                    .ChWrDataM1       (ChWrDataM1),
                    .ChWrDataM2       (ChWrDataM2),
                    .BusAvlblM1       (BusAvlblM1),
                    .BusAvlblM2       (BusAvlblM2),
                    .DataErrorM1      (DataErrorM1),
                    .DataErrorM2      (DataErrorM2),
                    .XferAbortedM1    (XferAbortedM1),
                    .XferAbortedM2    (XferAbortedM2),
                    .RegHWrite        (RegHWrite),
                    .RegAddress       (RegAddress),
                    .DmacChannelSel   (DmacChannelSel3),
                    .HWDATA           (HWDATA),
                    .ClrIntTC         (ClrIntTC3),
                    .ClrIntErr        (ClrIntErr3),
                    .DMACBREQCh       (DMACBREQCh),
                    .DMACLBREQCh      (DMACLBREQCh),
                    .DMACSREQCh       (DMACSREQCh),
                    .DMACLSREQCh      (DMACLSREQCh),
                    .DMACEn           (DMACEn),
                    .ChGntM1          (Ch3GntM1),
                    .ChGntM2          (Ch3GntM2),
                    .ChHRDATA         (Ch3HRDATA),
                    .ChannelEn        (ChannelEn3),
                    .IntErrCh         (IntErrCh3),
                    .IntTCCh          (IntTCCh3),
                    .RawIntErrCh      (RawIntErrCh3),
                    .RawIntTCCh       (RawIntTCCh3),
                    .ClearReq         (ClearReq3),
                    .SigTC            (SigTC3),
                    .ErrClrReq        (ErrClrReq3),
                    .ChLock           (Ch3LockM),
                    .ChNumOfXfersM1   (Ch3NumOfXfers1),
                    .ChReqM1          (Ch3ReqM1),
                    .ChIncrM1         (Ch3IncrM1),
                    .ChAddrM1         (Ch3AddrM1),
                    .ChProtM1         (Ch3ProtM1),
                    .ChWidthM1        (Ch3WidthM1),
                    .ChDirxnM1        (Ch3DirxnM1),
                    .ChXferAbortM1    (Ch3XferAbort1),
                    .ChHWDATAM1       (Ch3HWDATA1),
                    .ChNumOfXfersM2   (Ch3NumOfXfers2),
                    .ChReqM2          (Ch3ReqM2),
                    .ChIncrM2         (Ch3IncrM2),
                    .ChAddrM2         (Ch3AddrM2),
                    .ChProtM2         (Ch3ProtM2),
                    .ChWidthM2        (Ch3WidthM2),
                    .ChDirxnM2        (Ch3DirxnM2),
                    .ChXferAbortM2    (Ch3XferAbort2),
                    .ChHWDATAM2       (Ch3HWDATA2)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacChannel4
// -----------------------------------------------------------------------------
DmacChannel u4DmacChannel             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .MasterAddressM1  (MasterAddressM1),
                    .MasterAddressM2  (MasterAddressM2),
                    .ChWrDataM1       (ChWrDataM1),
                    .ChWrDataM2       (ChWrDataM2),
                    .BusAvlblM1       (BusAvlblM1),
                    .BusAvlblM2       (BusAvlblM2),
                    .DataErrorM1      (DataErrorM1),
                    .DataErrorM2      (DataErrorM2),
                    .XferAbortedM1    (XferAbortedM1),
                    .XferAbortedM2    (XferAbortedM2),
                    .RegHWrite        (RegHWrite),
                    .RegAddress       (RegAddress),
                    .DmacChannelSel   (DmacChannelSel4),
                    .HWDATA           (HWDATA),
                    .ClrIntTC         (ClrIntTC4),
                    .ClrIntErr        (ClrIntErr4),
                    .DMACBREQCh       (DMACBREQCh),
                    .DMACLBREQCh      (DMACLBREQCh),
                    .DMACSREQCh       (DMACSREQCh),
                    .DMACLSREQCh      (DMACLSREQCh),
                    .DMACEn           (DMACEn),
                    .ChGntM1          (Ch4GntM1),
                    .ChGntM2          (Ch4GntM2),
                    .ChHRDATA         (Ch4HRDATA),
                    .ChannelEn        (ChannelEn4),
                    .IntErrCh         (IntErrCh4),
                    .IntTCCh          (IntTCCh4),
                    .RawIntErrCh      (RawIntErrCh4),
                    .RawIntTCCh       (RawIntTCCh4),
                    .ClearReq         (ClearReq4),
                    .SigTC            (SigTC4),
                    .ErrClrReq        (ErrClrReq4),
                    .ChLock           (Ch4LockM),
                    .ChNumOfXfersM1   (Ch4NumOfXfers1),
                    .ChReqM1          (Ch4ReqM1),
                    .ChIncrM1         (Ch4IncrM1),
                    .ChAddrM1         (Ch4AddrM1),
                    .ChProtM1         (Ch4ProtM1),
                    .ChWidthM1        (Ch4WidthM1),
                    .ChDirxnM1        (Ch4DirxnM1),
                    .ChXferAbortM1    (Ch4XferAbort1),
                    .ChNumOfXfersM2   (Ch4NumOfXfers2),
                    .ChHWDATAM1       (Ch4HWDATA1),
                    .ChReqM2          (Ch4ReqM2),
                    .ChIncrM2         (Ch4IncrM2),
                    .ChAddrM2         (Ch4AddrM2),
                    .ChProtM2         (Ch4ProtM2),
                    .ChWidthM2        (Ch4WidthM2),
                    .ChDirxnM2        (Ch4DirxnM2),
                    .ChXferAbortM2    (Ch4XferAbort2),
                    .ChHWDATAM2       (Ch4HWDATA2)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacChannel5
// -----------------------------------------------------------------------------
DmacChannel u5DmacChannel             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .MasterAddressM1  (MasterAddressM1),
                    .MasterAddressM2  (MasterAddressM2),
                    .ChWrDataM1       (ChWrDataM1),
                    .ChWrDataM2       (ChWrDataM2),
                    .BusAvlblM1       (BusAvlblM1),
                    .BusAvlblM2       (BusAvlblM2),
                    .DataErrorM1      (DataErrorM1),
                    .DataErrorM2      (DataErrorM2),
                    .XferAbortedM1    (XferAbortedM1),
                    .XferAbortedM2    (XferAbortedM2),
                    .RegHWrite        (RegHWrite),
                    .RegAddress       (RegAddress),
                    .DmacChannelSel   (DmacChannelSel5),
                    .HWDATA           (HWDATA),
                    .ClrIntTC         (ClrIntTC5),
                    .ClrIntErr        (ClrIntErr5),
                    .DMACBREQCh       (DMACBREQCh),
                    .DMACLBREQCh      (DMACLBREQCh),
                    .DMACSREQCh       (DMACSREQCh),
                    .DMACLSREQCh      (DMACLSREQCh),
                    .DMACEn           (DMACEn),
                    .ChGntM1          (Ch5GntM1),
                    .ChGntM2          (Ch5GntM2),
                    .ChHRDATA         (Ch5HRDATA),
                    .ChannelEn        (ChannelEn5),
                    .IntErrCh         (IntErrCh5),
                    .IntTCCh          (IntTCCh5),
                    .RawIntErrCh      (RawIntErrCh5),
                    .RawIntTCCh       (RawIntTCCh5),
                    .ClearReq         (ClearReq5),
                    .SigTC            (SigTC5),
                    .ErrClrReq        (ErrClrReq5),
                    .ChLock           (Ch5LockM),
                    .ChNumOfXfersM1   (Ch5NumOfXfers1),
                    .ChReqM1          (Ch5ReqM1),
                    .ChIncrM1         (Ch5IncrM1),
                    .ChAddrM1         (Ch5AddrM1),
                    .ChProtM1         (Ch5ProtM1),
                    .ChWidthM1        (Ch5WidthM1),
                    .ChDirxnM1        (Ch5DirxnM1),
                    .ChXferAbortM1    (Ch5XferAbort1),
                    .ChHWDATAM1       (Ch5HWDATA1),
                    .ChNumOfXfersM2   (Ch5NumOfXfers2),
                    .ChReqM2          (Ch5ReqM2),
                    .ChIncrM2         (Ch5IncrM2),
                    .ChAddrM2         (Ch5AddrM2),
                    .ChProtM2         (Ch5ProtM2),
                    .ChWidthM2        (Ch5WidthM2),
                    .ChDirxnM2        (Ch5DirxnM2),
                    .ChXferAbortM2    (Ch5XferAbort2),
                    .ChHWDATAM2       (Ch5HWDATA2)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacChannel6
// -----------------------------------------------------------------------------
DmacChannel u6DmacChannel             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .MasterAddressM1  (MasterAddressM1),
                    .MasterAddressM2  (MasterAddressM2),
                    .ChWrDataM1       (ChWrDataM1),
                    .ChWrDataM2       (ChWrDataM2),
                    .BusAvlblM1       (BusAvlblM1),
                    .BusAvlblM2       (BusAvlblM2),
                    .DataErrorM1      (DataErrorM1),
                    .DataErrorM2      (DataErrorM2),
                    .XferAbortedM1    (XferAbortedM1),
                    .XferAbortedM2    (XferAbortedM2),
                    .RegHWrite        (RegHWrite),
                    .RegAddress       (RegAddress),
                    .DmacChannelSel   (DmacChannelSel6),
                    .HWDATA           (HWDATA),
                    .ClrIntTC         (ClrIntTC6),
                    .ClrIntErr        (ClrIntErr6),
                    .DMACBREQCh       (DMACBREQCh),
                    .DMACLBREQCh      (DMACLBREQCh),
                    .DMACSREQCh       (DMACSREQCh),
                    .DMACLSREQCh      (DMACLSREQCh),
                    .DMACEn           (DMACEn),
                    .ChGntM1          (Ch6GntM1),
                    .ChGntM2          (Ch6GntM2),
                    .ChHRDATA         (Ch6HRDATA),
                    .ChannelEn        (ChannelEn6),
                    .IntErrCh         (IntErrCh6),
                    .IntTCCh          (IntTCCh6),
                    .RawIntErrCh      (RawIntErrCh6),
                    .RawIntTCCh       (RawIntTCCh6),
                    .ClearReq         (ClearReq6),
                    .SigTC            (SigTC6),
                    .ErrClrReq        (ErrClrReq6),
                    .ChLock           (Ch6LockM),
                    .ChNumOfXfersM1   (Ch6NumOfXfers1),
                    .ChReqM1          (Ch6ReqM1),
                    .ChIncrM1         (Ch6IncrM1),
                    .ChAddrM1         (Ch6AddrM1),
                    .ChProtM1         (Ch6ProtM1),
                    .ChWidthM1        (Ch6WidthM1),
                    .ChDirxnM1        (Ch6DirxnM1),
                    .ChXferAbortM1    (Ch6XferAbort1),
                    .ChHWDATAM1       (Ch6HWDATA1),
                    .ChNumOfXfersM2   (Ch6NumOfXfers2),
                    .ChReqM2          (Ch6ReqM2),
                    .ChIncrM2         (Ch6IncrM2),
                    .ChAddrM2         (Ch6AddrM2),
                    .ChProtM2         (Ch6ProtM2),
                    .ChWidthM2        (Ch6WidthM2),
                    .ChDirxnM2        (Ch6DirxnM2),
                    .ChXferAbortM2    (Ch6XferAbort2),
                    .ChHWDATAM2       (Ch6HWDATA2)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacChannel7
// -----------------------------------------------------------------------------
DmacChannel u7DmacChannel             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .MasterAddressM1  (MasterAddressM1),
                    .MasterAddressM2  (MasterAddressM2),
                    .ChWrDataM1       (ChWrDataM1),
                    .ChWrDataM2       (ChWrDataM2),
                    .BusAvlblM1       (BusAvlblM1),
                    .BusAvlblM2       (BusAvlblM2),
                    .DataErrorM1      (DataErrorM1),
                    .DataErrorM2      (DataErrorM2),
                    .XferAbortedM1    (XferAbortedM1),
                    .XferAbortedM2    (XferAbortedM2),
                    .RegHWrite        (RegHWrite),
                    .RegAddress       (RegAddress),
                    .DmacChannelSel   (DmacChannelSel7),
                    .HWDATA           (HWDATA),
                    .ClrIntTC         (ClrIntTC7),
                    .ClrIntErr        (ClrIntErr7),
                    .DMACBREQCh       (DMACBREQCh),
                    .DMACLBREQCh      (DMACLBREQCh),
                    .DMACSREQCh       (DMACSREQCh),
                    .DMACLSREQCh      (DMACLSREQCh),
                    .DMACEn           (DMACEn),
                    .ChGntM1          (Ch7GntM1),
                    .ChGntM2          (Ch7GntM2),
                    .ChHRDATA         (Ch7HRDATA),
                    .ChannelEn        (ChannelEn7),
                    .IntErrCh         (IntErrCh7),
                    .IntTCCh          (IntTCCh7),
                    .RawIntErrCh      (RawIntErrCh7),
                    .RawIntTCCh       (RawIntTCCh7),
                    .ClearReq         (ClearReq7),
                    .SigTC            (SigTC7),
                    .ErrClrReq        (ErrClrReq7),
                    .ChLock           (Ch7LockM),
                    .ChNumOfXfersM1   (Ch7NumOfXfers1),
                    .ChReqM1          (Ch7ReqM1),
                    .ChIncrM1         (Ch7IncrM1),
                    .ChAddrM1         (Ch7AddrM1),
                    .ChProtM1         (Ch7ProtM1),
                    .ChWidthM1        (Ch7WidthM1),
                    .ChDirxnM1        (Ch7DirxnM1),
                    .ChXferAbortM1    (Ch7XferAbort1),
                    .ChHWDATAM1       (Ch7HWDATA1),
                    .ChNumOfXfersM2   (Ch7NumOfXfers2),
                    .ChReqM2          (Ch7ReqM2),
                    .ChIncrM2         (Ch7IncrM2),
                    .ChAddrM2         (Ch7AddrM2),
                    .ChProtM2         (Ch7ProtM2),
                    .ChWidthM2        (Ch7WidthM2),
                    .ChDirxnM2        (Ch7DirxnM2),
                    .ChXferAbortM2    (Ch7XferAbort2),
                    .ChHWDATAM2       (Ch7HWDATA2)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacRspRoute
// -----------------------------------------------------------------------------
DmacRspRoute uDmacRspRoute            (
                    .IntErrCh0        (IntErrCh0),
                    .IntErrCh1        (IntErrCh1),
                    .IntErrCh2        (IntErrCh2),
                    .IntErrCh3        (IntErrCh3),
                    .IntErrCh4        (IntErrCh4),
                    .IntErrCh5        (IntErrCh5),
                    .IntErrCh6        (IntErrCh6),
                    .IntErrCh7        (IntErrCh7),
                    .IntTCCh0         (IntTCCh0),
                    .IntTCCh1         (IntTCCh1),
                    .IntTCCh2         (IntTCCh2),
                    .IntTCCh3         (IntTCCh3),
                    .IntTCCh4         (IntTCCh4),
                    .IntTCCh5         (IntTCCh5),
                    .IntTCCh6         (IntTCCh6),
                    .IntTCCh7         (IntTCCh7),
                    .ClearReq0        (ClearReq0),
                    .ClearReq1        (ClearReq1),
                    .ClearReq2        (ClearReq2),
                    .ClearReq3        (ClearReq3),
                    .ClearReq4        (ClearReq4),
                    .ClearReq5        (ClearReq5),
                    .ClearReq6        (ClearReq6),
                    .ClearReq7        (ClearReq7),
                    .SigTC0           (SigTC0),
                    .SigTC1           (SigTC1),
                    .SigTC2           (SigTC2),
                    .SigTC3           (SigTC3),
                    .SigTC4           (SigTC4),
                    .SigTC5           (SigTC5),
                    .SigTC6           (SigTC6),
                    .SigTC7           (SigTC7),
                    .ITEN             (ITEN),
                    .DMACITOP1        (DMACITOP1),
                    .DMACITOP2        (DMACITOP2),
                    .DMACITOP3        (DMACITOP3),
                    .ClearReq         (ClearReq),
                    .DMACCLR          (iDMACCLR),
                    .DMACTC           (iDMACTC),
                    .DMACINTERR       (iDMACINTERR),
                    .DMACINTTC        (iDMACINTTC),
                    .DMACINTR         (DMACINTR)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacRqstSync
// -----------------------------------------------------------------------------
DmacRqstSync uDmacRqstSync            (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .MskdDMACBREQ     (MskdDMACBREQ),
                    .MskdDMACLBREQ    (MskdDMACLBREQ),
                    .MskdDMACSREQ     (MskdDMACSREQ),
                    .MskdDMACLSREQ    (MskdDMACLSREQ),
                    .DMACBREQSync     (DMACBREQSync),
                    .DMACLBREQSync    (DMACLBREQSync),
                    .DMACSREQSync     (DMACSREQSync),
                    .DMACLSREQSync    (DMACLSREQSync)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacRevAnd for bit 0 of Revision
// -----------------------------------------------------------------------------
DmacRevAnd u0DmacRevAnd               (
                    .TieOff1          (TieOff1[0]),
                    .TieOff2          (TieOff2[0]),
                    .Revision         (Revision[0])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacRevAnd for bit 1 of Revision
// -----------------------------------------------------------------------------
DmacRevAnd u1DmacRevAnd               (
                    .TieOff1          (TieOff1[1]),
                    .TieOff2          (TieOff2[1]),
                    .Revision         (Revision[1])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacRevAnd for bit 2 of Revision
// -----------------------------------------------------------------------------
DmacRevAnd u2DmacRevAnd  (
                    .TieOff1          (TieOff1[2]),
                    .TieOff2          (TieOff2[2]),
                    .Revision         (Revision[2])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacRevAnd for bit 3 of Revision
// -----------------------------------------------------------------------------
DmacRevAnd u3DmacRevAnd  (
                    .TieOff1          (TieOff1[3]),
                    .TieOff2          (TieOff2[3]),
                    .Revision         (Revision[3])
                    );

// -----------------------------------------------------------------------------
// Assigning the local copies to the output
// -----------------------------------------------------------------------------
assign DMACCLR          = iDMACCLR;
assign DMACTC           = iDMACTC;
assign DMACINTERR       = iDMACINTERR;
assign DMACINTTC        = iDMACINTTC;

// -----------------------------------------------------------------------------
// Assign values to inputs of RevAnd
// -----------------------------------------------------------------------------
assign TieOff1          = 4'b0001;
assign TieOff2          = 4'b0001;

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule
// --================================== End ==================================--
