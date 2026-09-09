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
// File Name              : Dmac.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
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
             HGRANTDMACM,
             HREADYINM,
             HRESPM,
             HRDATAM,
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
             HBUSREQDMACM,
             HLOCKDMACM,
             HTRANSM,
             HADDRM,
             HSIZEM,
             HBURSTM,
             HPROTM,
             HWRITEM,
             HWDATAM,
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
input         HCLK;         // AHB clock
input         HRESETn;      // AHB reset

// AHB slave signals
input         HSELDMAC;     // Slave Select for DMAC
input         HWRITE;       // Transfer direction
input         HTRANS;       // Type of transfer on AHB Only HTRANS(1)
                            // of the slave AHB should connect
input  [11:2] HADDR;        // AHB address bus
input   [2:0] HSIZE;        // The width of the transfer on AHB
input         HREADYIN;     // Transfer done response on AHB from
                            // previous Slave
input  [31:0] HWDATA;       // AHB slave write data

// AHB master signals
input         HGRANTDMACM;  // AHB bus grant for master
input         HREADYINM;    // Transfer done response from AHB
input   [1:0] HRESPM;       // Transfer response from AHB
input  [31:0] HRDATAM;      // Read Data from AHB

// DMA request signals
input  [15:0] DMACBREQ;     // DMA burst transfer request
input  [15:0] DMACLBREQ;    // DMA last burst transfer request
input  [15:0] DMACSREQ;     // DMA single transfer request
input  [15:0] DMACLSREQ;    // DMA last single transfer request

// Scan related signals
input         SCANINHCLK;   // Scan input for DMAC
input         SCANENABLE;   // Scan enable

// Outputs

// AHB slave signals
output        HREADYOUT;    // Transfer done response to AHB
output  [1:0] HRESP;        // Transfer response to AHB
output [31:0] HRDATA;       // Read data bus to AHB

// AHB master signals
output        HBUSREQDMACM; // Bus request signal to the AHB arbiter
output        HLOCKDMACM;   // Indicates locked-burst request on AHB
output  [1:0] HTRANSM;      // Type of transfer on AHB
output [31:0] HADDRM;       // AHB address bus
output  [2:0] HSIZEM;       // Width of transfer on AHB
output  [2:0] HBURSTM;      // Burst length on AHB
output  [3:0] HPROTM;       // Protection information on AHB
output        HWRITEM;      // Transfer direction on AHB
output [31:0] HWDATAM;      // Write data to AHB

// DMA response signals
output [15:0] DMACCLR;      // DMA request clear
output [15:0] DMACTC;       // DMA terminal count

// DMA interrupt request signals
output        DMACINTERR;   // DMA error interrupt request
output        DMACINTTC;    // DMA terminal count interrupt request
output        DMACINTR;     // DMA combined interrupt request

// Scan related signals
output        SCANOUTHCLK;  // Scan out of DMAC

// Inputs

// Clock and reset
wire          HCLK;         // AHB clock
wire          HRESETn;      // AHB reset

// AHB slave signals
wire          HSELDMAC;     // Slave Select for DMAC
wire          HWRITE;       // Transfer direction
wire          HTRANS;       // Type of transfer on AHB Only HTRANS(1)
                            // of the slave AHB should connect
wire   [11:2] HADDR;        // AHB address bus
wire    [2:0] HSIZE;        // The width of the transfer on AHB
wire          HREADYIN;     // Transfer done response on AHB from
                            // previous Slave
wire   [31:0] HWDATA;       // AHB slave write data

// AHB master signals
wire          HGRANTDMACM;  // AHB bus grant for master
wire          HREADYINM;    // Transfer done response from AHB
wire    [1:0] HRESPM;       // Transfer response from AHB
wire   [31:0] HRDATAM;      // Read Data from AHB

// DMA request signals
wire   [15:0] DMACBREQ;     // DMA burst transfer request
wire   [15:0] DMACLBREQ;    // DMA last burst transfer request
wire   [15:0] DMACSREQ;     // DMA single transfer request
wire   [15:0] DMACLSREQ;    // DMA last single transfer request

// Scan related signals
wire          SCANINHCLK;   // Scan input for DMAC
wire          SCANENABLE;   // Scan enable

// Outputs

// AHB slave signals
wire          HREADYOUT;    // Transfer done response to AHB
wire    [1:0] HRESP;        // Transfer response to AHB
wire   [31:0] HRDATA;       // Read data bus to AHB

// AHB master signals
wire          HBUSREQDMACM; // Bus request signal to the AHB arbiter
wire          HLOCKDMACM;   // Indicates locked-burst request on AHB
wire    [1:0] HTRANSM;      // Type of transfer on AHB
wire   [31:0] HADDRM;       // AHB address bus
wire    [2:0] HSIZEM;       // Width of transfer on AHB
wire    [2:0] HBURSTM;      // Burst length on AHB
wire    [3:0] HPROTM;       // Protection information on AHB
wire          HWRITEM;      // Transfer direction on AHB
wire   [31:0] HWDATAM;      // Write data to AHB

// DMA response signals
wire   [15:0] DMACCLR;      // DMA request clear
wire   [15:0] DMACTC;       // DMA terminal count

// DMA interrupt request signals
wire          DMACINTERR;   // DMA error interrupt request
wire          DMACINTTC;    // DMA terminal count interrupt request
wire          DMACINTR;     // DMA combined interrupt request

// Scan related signals
wire          SCANOUTHCLK;  // Scan out of DMAC

// -----------------------------------------------------------------------------
//
//                                    Dmac
//                                    ====
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//  This block is the top level of the DMAC. This block instantiates the
// following functional sub-blocks in the DMAC.
// - DmacRqstSync
//    This module is used for double synchronization of the DMA Requests
//   coming from the peripherals
// - DmacRspRoute
//    This module routes the responses given to the peripherals from
//   different channels
// - DmacAhbSlaveIf
//    The module used to interface the AHB and the programming registers
//   the DMA Controller
// - DmacAhbMaster(1 instances)
//    This module is the actual AHB master interface for the DMA
//   Controller
// - DmacChannel(2 instances)
//    The 2 instances of Channnel are instatiating the control logic and
//   the required data path logic for the
// - DmacRevAnd(4 instances)
//    The module to give the Peripheral and PrimeCell Identification
//   number of the DMA Controller
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
// Registered lower order address bits for regiter addressing

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

wire        BigEndianM;
// Endian-ness bit for master

wire        BusAvlblM;
// AHB Data/Address Bus available

// Master  signals
// Signals indicating the number of transfers requested
wire  [4:0] Ch0NumOfXfers;
// Number of AHB transfers requested by channel 0

wire  [4:0] Ch1NumOfXfers;
// Number of AHB transfers requested by channel 1

wire  [4:0] Ch2NumOfXfers;
// Number of AHB transfers requested by channel 2

wire  [4:0] Ch3NumOfXfers;
// Number of AHB transfers requested by channel 3

wire  [4:0] Ch4NumOfXfers;
// Number of AHB transfers requested by channel 4

wire  [4:0] Ch5NumOfXfers;
// Number of AHB transfers requested by channel 5

wire  [4:0] Ch6NumOfXfers;
// Number of AHB transfers requested by channel 6

wire  [4:0] Ch7NumOfXfers;
// Number of AHB transfers requested by channel 7

// Signals From channels to AHB master module
wire        Ch0ReqM;
// Channel 0 request for AHB

wire        Ch1ReqM;
// Channel 1 request for AHB

wire        Ch2ReqM;
// Channel 2 request for AHB

wire        Ch3ReqM;
// Channel 3 request for AHB

wire        Ch4ReqM;
// Channel 4 request for AHB

wire        Ch5ReqM;
// Channel 5 request for AHB

wire        Ch6ReqM;
// Channel 6 request for AHB

wire        Ch7ReqM;
// Channel 7 request for AHB

wire        Ch0IncrM;
// Indicates incrementing transfers are required for channel 0

wire        Ch1IncrM;
// Indicates incrementing transfers are required for channel 1

wire        Ch2IncrM;
// Indicates incrementing transfers are required for channel 2

wire        Ch3IncrM;
// Indicates incrementing transfers are required for channel 3

wire        Ch4IncrM;
// Indicates incrementing transfers are required for channel 4

wire        Ch5IncrM;
// Indicates incrementing transfers are required for channel 5

wire        Ch6IncrM;
// Indicates incrementing transfers are required for channel 6

wire        Ch7IncrM;
// Indicates incrementing transfers are required for channel 7

wire [31:0] Ch0AddrM;
// First address for the AHB Access requested by channel 0

wire [31:0] Ch1AddrM;
// First address for the AHB Access requested by channel 1

wire [31:0] Ch2AddrM;
// First address for the AHB Access requested by channel 2

wire [31:0] Ch3AddrM;
// First address for the AHB Access requested by channel 3

wire [31:0] Ch4AddrM;
// First address for the AHB Access requested by channel 4

wire [31:0] Ch5AddrM;
// First address for the AHB Access requested by channel 5

wire [31:0] Ch6AddrM;
// First address for the AHB Access requested by channel 6

wire [31:0] Ch7AddrM;
// First address for the AHB Access requested by channel 7

wire  [2:0] Ch0ProtM;
// HPROT information for channel 0

wire  [2:0] Ch1ProtM;
// HPROT information for channel 1

wire  [2:0] Ch2ProtM;
// HPROT information for channel 2

wire  [2:0] Ch3ProtM;
// HPROT information for channel 3

wire  [2:0] Ch4ProtM;
// HPROT information for channel 4

wire  [2:0] Ch5ProtM;
// HPROT information for channel 5

wire  [2:0] Ch6ProtM;
// HPROT information for channel 6

wire  [2:0] Ch7ProtM;
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

wire  [2:0] Ch0WidthM;
// HSIZE information for channel 0

wire  [2:0] Ch1WidthM;
// HSIZE information for channel 1

wire  [2:0] Ch2WidthM;
// HSIZE information for channel 2

wire  [2:0] Ch3WidthM;
// HSIZE information for channel 3

wire  [2:0] Ch4WidthM;
// HSIZE information for channel 4

wire  [2:0] Ch5WidthM;
// HSIZE information for channel 5

wire  [2:0] Ch6WidthM;
// HSIZE information for channel 6

wire  [2:0] Ch7WidthM;
// HSIZE information for channel 7

wire        Ch0DirxnM;
// HWRITE information for channel 0

wire        Ch1DirxnM;
// HWRITE information for channel 1

wire        Ch2DirxnM;
// HWRITE information for channel 2

wire        Ch3DirxnM;
// HWRITE information for channel 3

wire        Ch4DirxnM;
// HWRITE information for channel 4

wire        Ch5DirxnM;
// HWRITE information for channel 5

wire        Ch6DirxnM;
// HWRITE information for channel 6

wire        Ch7DirxnM;
// HWRITE information for channel 7

wire        Ch0XferAbort;
// Request to abort the AHB transfer from channel 0

wire        Ch1XferAbort;
// Request to abort the AHB transfer from channel 1

wire        Ch2XferAbort;
// Request to abort the AHB transfer from channel 2

wire        Ch3XferAbort;
// Request to abort the AHB transfer from channel 3

wire        Ch4XferAbort;
// Request to abort the AHB transfer from channel 4

wire        Ch5XferAbort;
// Request to abort the AHB transfer from channel 5

wire        Ch6XferAbort;
// Request to abort the AHB transfer from channel 6

wire        Ch7XferAbort;
// Request to abort the AHB transfer from channel 7

wire [31:0] Ch0HWDATA;
// The HWDATA information from the channel 0

wire [31:0] Ch1HWDATA;
// The HWDATA information from the channel 1

wire [31:0] Ch2HWDATA;
// The HWDATA information from the channel 2

wire [31:0] Ch3HWDATA;
// The HWDATA information from the channel 3

wire [31:0] Ch4HWDATA;
// The HWDATA information from the channel 4

wire [31:0] Ch5HWDATA;
// The HWDATA information from the channel 5

wire [31:0] Ch6HWDATA;
// The HWDATA information from the channel 6

wire [31:0] Ch7HWDATA;
// The HWDATA information from the channel 7

// Grant to channel
wire        Ch0GntM;
// Grant for channel 0 from master

wire        Ch1GntM;
// Grant for channel 1 from master

wire        Ch2GntM;
// Grant for channel 2 from master

wire        Ch3GntM;
// Grant for channel 3 from master

wire        Ch4GntM;
// Grant for channel 4 from master

wire        Ch5GntM;
// Grant for channel 5 from master

wire        Ch6GntM;
// Grant for channel 6 from master

wire        Ch7GntM;
// Grant for channel 7 from master


wire [31:0] MasterAddressM;
// HADDR information for master

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

wire        DataErrorM;
// Data error on AHB

wire        XferAbortedM;
// Acknowledgement to abort request from master

wire [31:0] ChWrDataM;
// Endianized Read Data of AHB to be written into channel FIFO

wire [31:0] SignalZEROFILL;
// signal to declare the zero values for port mapping of unused inputs

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
// Assignment of constant ZEROFILL to a signnal for port mapping
// -----------------------------------------------------------------------------
assign SignalZEROFILL   = {32{1'b0}};

// -----------------------------------------------------------------------------
// Include Parameters File
`include "DmacParams.v"
// -----------------------------------------------------------------------------
// Instantiation of DmacAhbSlaveIf
// -----------------------------------------------------------------------------
DmacAhbSlaveIf uDmacAhbSlaveIf        (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HSELDMAC         (HSELDMAC),
                    .HWRITE           (HWRITE),
                    .HTRANS           (HTRANS),
                    .HWDATA           (HWDATA[15 : 0]),
                    .HADDR            (HADDR),
                    .HSIZE            (HSIZE),
                    .HREADYIN         (HREADYIN),
                    .Revision         (Revision),
                    .Ch0HRDATA        (Ch0HRDATA),
                    .Ch1HRDATA        (Ch1HRDATA),
                    .Ch2HRDATA        (SignalZEROFILL),
                    .Ch3HRDATA        (SignalZEROFILL),
                    .Ch4HRDATA        (SignalZEROFILL),
                    .Ch5HRDATA        (SignalZEROFILL),
                    .Ch6HRDATA        (SignalZEROFILL),
                    .Ch7HRDATA        (SignalZEROFILL),
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
                    .ChannelEn2       (SignalZEROFILL[0]),
                    .ChannelEn3       (SignalZEROFILL[0]),
                    .ChannelEn4       (SignalZEROFILL[0]),
                    .ChannelEn5       (SignalZEROFILL[0]),
                    .ChannelEn6       (SignalZEROFILL[0]),
                    .ChannelEn7       (SignalZEROFILL[0]),
                    .IntErrCh0        (IntErrCh0),
                    .IntErrCh1        (IntErrCh1),
                    .IntErrCh2        (SignalZEROFILL[0]),
                    .IntErrCh3        (SignalZEROFILL[0]),
                    .IntErrCh4        (SignalZEROFILL[0]),
                    .IntErrCh5        (SignalZEROFILL[0]),
                    .IntErrCh6        (SignalZEROFILL[0]),
                    .IntErrCh7        (SignalZEROFILL[0]),
                    .IntTCCh0         (IntTCCh0),
                    .IntTCCh1         (IntTCCh1),
                    .IntTCCh2         (SignalZEROFILL[0]),
                    .IntTCCh3         (SignalZEROFILL[0]),
                    .IntTCCh4         (SignalZEROFILL[0]),
                    .IntTCCh5         (SignalZEROFILL[0]),
                    .IntTCCh6         (SignalZEROFILL[0]),
                    .IntTCCh7         (SignalZEROFILL[0]),
                    .RawIntErrCh0     (RawIntErrCh0),
                    .RawIntErrCh1     (RawIntErrCh1),
                    .RawIntErrCh2     (SignalZEROFILL[0]),
                    .RawIntErrCh3     (SignalZEROFILL[0]),
                    .RawIntErrCh4     (SignalZEROFILL[0]),
                    .RawIntErrCh5     (SignalZEROFILL[0]),
                    .RawIntErrCh6     (SignalZEROFILL[0]),
                    .RawIntErrCh7     (SignalZEROFILL[0]),
                    .RawIntTCCh0      (RawIntTCCh0),
                    .RawIntTCCh1      (RawIntTCCh1),
                    .RawIntTCCh2      (SignalZEROFILL[0]),
                    .RawIntTCCh3      (SignalZEROFILL[0]),
                    .RawIntTCCh4      (SignalZEROFILL[0]),
                    .RawIntTCCh5      (SignalZEROFILL[0]),
                    .RawIntTCCh6      (SignalZEROFILL[0]),
                    .RawIntTCCh7      (SignalZEROFILL[0]),
                    .ClearReq         (ClearReq),
                    .ErrClrReq0       (ErrClrReq0),
                    .ErrClrReq1       (ErrClrReq1),
                    .ErrClrReq2       (SignalZEROFILL[15 : 0]),
                    .ErrClrReq3       (SignalZEROFILL[15 : 0]),
                    .ErrClrReq4       (SignalZEROFILL[15 : 0]),
                    .ErrClrReq5       (SignalZEROFILL[15 : 0]),
                    .ErrClrReq6       (SignalZEROFILL[15 : 0]),
                    .ErrClrReq7       (SignalZEROFILL[15 : 0]),
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
                    .BigEndianM       (BigEndianM)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacAhbMaster
// -----------------------------------------------------------------------------
DmacAhbMaster u1DmacAhbMaster         (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HGRANTDMACM      (HGRANTDMACM),
                    .HREADYINM        (HREADYINM),
                    .HRESPM           (HRESPM),
                    .HRDATAM          (HRDATAM),
                    .BigEndianM       (BigEndianM),
                    .Ch0ReqM          (Ch0ReqM),
                    .Ch1ReqM          (Ch1ReqM),
                    .Ch2ReqM          (SignalZEROFILL[0]),
                    .Ch3ReqM          (SignalZEROFILL[0]),
                    .Ch4ReqM          (SignalZEROFILL[0]),
                    .Ch5ReqM          (SignalZEROFILL[0]),
                    .Ch6ReqM          (SignalZEROFILL[0]),
                    .Ch7ReqM          (SignalZEROFILL[0]),
                    .Ch0LockM         (Ch0LockM),
                    .Ch1LockM         (Ch1LockM),
                    .Ch2LockM         (SignalZEROFILL[0]),
                    .Ch3LockM         (SignalZEROFILL[0]),
                    .Ch4LockM         (SignalZEROFILL[0]),
                    .Ch5LockM         (SignalZEROFILL[0]),
                    .Ch6LockM         (SignalZEROFILL[0]),
                    .Ch7LockM         (SignalZEROFILL[0]),
                    .Ch0NumOfXfers    (Ch0NumOfXfers),
                    .Ch1NumOfXfers    (Ch1NumOfXfers),
                    .Ch2NumOfXfers    (SignalZEROFILL[4 : 0]),
                    .Ch3NumOfXfers    (SignalZEROFILL[4 : 0]),
                    .Ch4NumOfXfers    (SignalZEROFILL[4 : 0]),
                    .Ch5NumOfXfers    (SignalZEROFILL[4 : 0]),
                    .Ch6NumOfXfers    (SignalZEROFILL[4 : 0]),
                    .Ch7NumOfXfers    (SignalZEROFILL[4 : 0]),
                    .Ch0IncrM         (Ch0IncrM),
                    .Ch1IncrM         (Ch1IncrM),
                    .Ch2IncrM         (SignalZEROFILL[0]),
                    .Ch3IncrM         (SignalZEROFILL[0]),
                    .Ch4IncrM         (SignalZEROFILL[0]),
                    .Ch5IncrM         (SignalZEROFILL[0]),
                    .Ch6IncrM         (SignalZEROFILL[0]),
                    .Ch7IncrM         (SignalZEROFILL[0]),
                    .Ch0AddrM         (Ch0AddrM),
                    .Ch1AddrM         (Ch1AddrM),
                    .Ch2AddrM         (SignalZEROFILL[31 : 0]),
                    .Ch3AddrM         (SignalZEROFILL[31 : 0]),
                    .Ch4AddrM         (SignalZEROFILL[31 : 0]),
                    .Ch5AddrM         (SignalZEROFILL[31 : 0]),
                    .Ch6AddrM         (SignalZEROFILL[31 : 0]),
                    .Ch7AddrM         (SignalZEROFILL[31 : 0]),
                    .Ch0ProtM         (Ch0ProtM),
                    .Ch1ProtM         (Ch1ProtM),
                    .Ch2ProtM         (SignalZEROFILL[2 : 0]),
                    .Ch3ProtM         (SignalZEROFILL[2 : 0]),
                    .Ch4ProtM         (SignalZEROFILL[2 : 0]),
                    .Ch5ProtM         (SignalZEROFILL[2 : 0]),
                    .Ch6ProtM         (SignalZEROFILL[2 : 0]),
                    .Ch7ProtM         (SignalZEROFILL[2 : 0]),
                    .Ch0WidthM        (Ch0WidthM),
                    .Ch1WidthM        (Ch1WidthM),
                    .Ch2WidthM        (SignalZEROFILL[2 : 0]),
                    .Ch3WidthM        (SignalZEROFILL[2 : 0]),
                    .Ch4WidthM        (SignalZEROFILL[2 : 0]),
                    .Ch5WidthM        (SignalZEROFILL[2 : 0]),
                    .Ch6WidthM        (SignalZEROFILL[2 : 0]),
                    .Ch7WidthM        (SignalZEROFILL[2 : 0]),
                    .Ch0DirxnM        (Ch0DirxnM),
                    .Ch1DirxnM        (Ch1DirxnM),
                    .Ch2DirxnM        (SignalZEROFILL[0]),
                    .Ch3DirxnM        (SignalZEROFILL[0]),
                    .Ch4DirxnM        (SignalZEROFILL[0]),
                    .Ch5DirxnM        (SignalZEROFILL[0]),
                    .Ch6DirxnM        (SignalZEROFILL[0]),
                    .Ch7DirxnM        (SignalZEROFILL[0]),
                    .Ch0XferAbort     (Ch0XferAbort),
                    .Ch1XferAbort     (Ch1XferAbort),
                    .Ch2XferAbort     (SignalZEROFILL[0]),
                    .Ch3XferAbort     (SignalZEROFILL[0]),
                    .Ch4XferAbort     (SignalZEROFILL[0]),
                    .Ch5XferAbort     (SignalZEROFILL[0]),
                    .Ch6XferAbort     (SignalZEROFILL[0]),
                    .Ch7XferAbort     (SignalZEROFILL[0]),
                    .Ch0HWDATA        (Ch0HWDATA),
                    .Ch1HWDATA        (Ch1HWDATA),
                    .Ch2HWDATA        (SignalZEROFILL[31 : 0]),
                    .Ch3HWDATA        (SignalZEROFILL[31 : 0]),
                    .Ch4HWDATA        (SignalZEROFILL[31 : 0]),
                    .Ch5HWDATA        (SignalZEROFILL[31 : 0]),
                    .Ch6HWDATA        (SignalZEROFILL[31 : 0]),
                    .Ch7HWDATA        (SignalZEROFILL[31 : 0]),
                    .HBUSREQDMACM     (HBUSREQDMACM),
                    .HLOCKDMACM       (HLOCKDMACM),
                    .HPROTM           (HPROTM),
                    .HBURSTM          (HBURSTM),
                    .HTRANSM          (HTRANSM),
                    .HADDRM           (HADDRM),
                    .HSIZEM           (HSIZEM),
                    .HWRITEM          (HWRITEM),
                    .HWDATAM          (HWDATAM),
                    .BusAvlblM        (BusAvlblM),
                    .DataError        (DataErrorM),
                    .XferAborted      (XferAbortedM),
                    .Ch0GntM          (Ch0GntM),
                    .Ch1GntM          (Ch1GntM),
                    .Ch2GntM          (Ch2GntM),
                    .Ch3GntM          (Ch3GntM),
                    .Ch4GntM          (Ch4GntM),
                    .Ch5GntM          (Ch5GntM),
                    .Ch6GntM          (Ch6GntM),
                    .Ch7GntM          (Ch7GntM),
                    .MasterAddress    (MasterAddressM),
                    .ChWrData         (ChWrDataM)
                    );

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Instantiation of DmacChannel0
// -----------------------------------------------------------------------------
DmacChannel u0DmacChannel             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .MasterAddressM   (MasterAddressM),
                    .ChWrDataM        (ChWrDataM),
                    .BusAvlblM        (BusAvlblM),
                    .DataErrorM       (DataErrorM),
                    .XferAbortedM     (XferAbortedM),
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
                    .ChGntM           (Ch0GntM),
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
                    .ChNumOfXfersM    (Ch0NumOfXfers),
                    .ChReqM           (Ch0ReqM),
                    .ChIncrM          (Ch0IncrM),
                    .ChAddrM          (Ch0AddrM),
                    .ChProtM          (Ch0ProtM),
                    .ChWidthM         (Ch0WidthM),
                    .ChDirxnM         (Ch0DirxnM),
                    .ChXferAbortM     (Ch0XferAbort),
                    .ChHWDATAM        (Ch0HWDATA)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacChannel1
// -----------------------------------------------------------------------------
DmacChannel u1DmacChannel             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .MasterAddressM   (MasterAddressM),
                    .ChWrDataM        (ChWrDataM),
                    .BusAvlblM        (BusAvlblM),
                    .DataErrorM       (DataErrorM),
                    .XferAbortedM     (XferAbortedM),
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
                    .ChGntM           (Ch1GntM),
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
                    .ChNumOfXfersM    (Ch1NumOfXfers),
                    .ChReqM           (Ch1ReqM),
                    .ChIncrM          (Ch1IncrM),
                    .ChAddrM          (Ch1AddrM),
                    .ChProtM          (Ch1ProtM),
                    .ChWidthM         (Ch1WidthM),
                    .ChDirxnM         (Ch1DirxnM),
                    .ChXferAbortM     (Ch1XferAbort),
                    .ChHWDATAM        (Ch1HWDATA)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacRspRoute
// -----------------------------------------------------------------------------
DmacRspRoute uDmacRspRoute            (
                    .IntErrCh0        (IntErrCh0),
                    .IntErrCh1        (IntErrCh1),
                    .IntErrCh2        (SignalZEROFILL[0]),
                    .IntErrCh3        (SignalZEROFILL[0]),
                    .IntErrCh4        (SignalZEROFILL[0]),
                    .IntErrCh5        (SignalZEROFILL[0]),
                    .IntErrCh6        (SignalZEROFILL[0]),
                    .IntErrCh7        (SignalZEROFILL[0]),
                    .IntTCCh0         (IntTCCh0),
                    .IntTCCh1         (IntTCCh1),
                    .IntTCCh2         (SignalZEROFILL[0]),
                    .IntTCCh3         (SignalZEROFILL[0]),
                    .IntTCCh4         (SignalZEROFILL[0]),
                    .IntTCCh5         (SignalZEROFILL[0]),
                    .IntTCCh6         (SignalZEROFILL[0]),
                    .IntTCCh7         (SignalZEROFILL[0]),
                    .ClearReq0        (ClearReq0),
                    .ClearReq1        (ClearReq1),
                    .ClearReq2        (SignalZEROFILL[15 : 0]),
                    .ClearReq3        (SignalZEROFILL[15 : 0]),
                    .ClearReq4        (SignalZEROFILL[15 : 0]),
                    .ClearReq5        (SignalZEROFILL[15 : 0]),
                    .ClearReq6        (SignalZEROFILL[15 : 0]),
                    .ClearReq7        (SignalZEROFILL[15 : 0]),
                    .SigTC0           (SigTC0),
                    .SigTC1           (SigTC1),
                    .SigTC2           (SignalZEROFILL[15 : 0]),
                    .SigTC3           (SignalZEROFILL[15 : 0]),
                    .SigTC4           (SignalZEROFILL[15 : 0]),
                    .SigTC5           (SignalZEROFILL[15 : 0]),
                    .SigTC6           (SignalZEROFILL[15 : 0]),
                    .SigTC7           (SignalZEROFILL[15 : 0]),
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
DmacRevAnd u2DmacRevAnd               (
                    .TieOff1          (TieOff1[2]),
                    .TieOff2          (TieOff2[2]),
                    .Revision         (Revision[2])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacRevAnd for bit 3 of Revision
// -----------------------------------------------------------------------------
DmacRevAnd u3DmacRevAnd               (
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

// ---------------------------------------------------------------------
// Assign values to inputs of RevAnd
// ---------------------------------------------------------------------
assign TieOff1          = 4'b0000;
assign TieOff2          = 4'b0000;

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
