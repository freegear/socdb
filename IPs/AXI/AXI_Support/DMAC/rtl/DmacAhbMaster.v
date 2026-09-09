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
// File Name              : DmacAhbMaster.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           DMA controller AHB Master Interface module. This structural module
//           instantiates following submodules:
//           1. AHB-Lite Master Interface
//           2. AHBLite to AHB wrapper
//           3. Internal Arbiter
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacAhbMaster (
// Inputs
                      // AHB signals
                      // From Reset and clock generator
                      HCLK,
                      HRESETn,
                      // From arbiter
                      HGRANTDMACM,
                      // from AHB slave
                      HREADYINM,
                      HRESPM,
                      HRDATAM,
                      BigEndianM,
                      // From Channel side.
                      Ch0ReqM,
                      Ch1ReqM,
                      Ch2ReqM,
                      Ch3ReqM,
                      Ch4ReqM,
                      Ch5ReqM,
                      Ch6ReqM,
                      Ch7ReqM,
                      Ch0NumOfXfers,
                      Ch1NumOfXfers,
                      Ch2NumOfXfers,
                      Ch3NumOfXfers,
                      Ch4NumOfXfers,
                      Ch5NumOfXfers,
                      Ch6NumOfXfers,
                      Ch7NumOfXfers,
                      Ch0IncrM,
                      Ch1IncrM,
                      Ch2IncrM,
                      Ch3IncrM,
                      Ch4IncrM,
                      Ch5IncrM,
                      Ch6IncrM,
                      Ch7IncrM,
                      Ch0AddrM,
                      Ch1AddrM,
                      Ch2AddrM,
                      Ch3AddrM,
                      Ch4AddrM,
                      Ch5AddrM,
                      Ch6AddrM,
                      Ch7AddrM,
                      Ch0ProtM,
                      Ch1ProtM,
                      Ch2ProtM,
                      Ch3ProtM,
                      Ch4ProtM,
                      Ch5ProtM,
                      Ch6ProtM,
                      Ch7ProtM,
                      Ch0LockM,
                      Ch1LockM,
                      Ch2LockM,
                      Ch3LockM,
                      Ch4LockM,
                      Ch5LockM,
                      Ch6LockM,
                      Ch7LockM,
                      Ch0WidthM,
                      Ch1WidthM,
                      Ch2WidthM,
                      Ch3WidthM,
                      Ch4WidthM,
                      Ch5WidthM,
                      Ch6WidthM,
                      Ch7WidthM,
                      Ch0DirxnM,
                      Ch1DirxnM,
                      Ch2DirxnM,
                      Ch3DirxnM,
                      Ch4DirxnM,
                      Ch5DirxnM,
                      Ch6DirxnM,
                      Ch7DirxnM,
                      Ch0XferAbort,
                      Ch1XferAbort,
                      Ch2XferAbort,
                      Ch3XferAbort,
                      Ch4XferAbort,
                      Ch5XferAbort,
                      Ch6XferAbort,
                      Ch7XferAbort,
                      Ch0HWDATA,
                      Ch1HWDATA,
                      Ch2HWDATA,
                      Ch3HWDATA,
                      Ch4HWDATA,
                      Ch5HWDATA,
                      Ch6HWDATA,
                      Ch7HWDATA,
// Outputs
                      // AHB signals
                      // To AHB arbiter
                      HBUSREQDMACM,
                      HLOCKDMACM,
                      HPROTM,
                      // To AHB slave and arbiter
                      HBURSTM,
                      // To AHB slave
                      HTRANSM,
                      HADDRM,
                      HSIZEM,
                      HWRITEM,
                      HWDATAM,
                      // To Channels
                      BusAvlblM,
                      DataError,
                      XferAborted,
                      Ch0GntM,
                      Ch1GntM,
                      Ch2GntM,
                      Ch3GntM,
                      Ch4GntM,
                      Ch5GntM,
                      Ch6GntM,
                      Ch7GntM,
                      MasterAddress,
                      ChWrData
                      );
// Inputs
// AHB signals
// From Reset and clock generator
input         HCLK;             // AHB clock
input         HRESETn;          // AHB Reset
// From arbiter
input         HGRANTDMACM;      // AHB bus grant for master
// from AHB slave
input         HREADYINM;        // HREADYIN response from the Slave
input   [1:0] HRESPM;           // HRESP response from the AHB Slave
input  [31:0] HRDATAM;          // Read data from AHB Master
input         BigEndianM;       // Endianness information
// From Channel side.
input         Ch0ReqM;          // Channel 0 request for AHB
input         Ch1ReqM;          // Channel 1 request for AHB
input         Ch2ReqM;          // Channel 2 request for AHB
input         Ch3ReqM;          // Channel 3 request for AHB
input         Ch4ReqM;          // Channel 4 request for AHB
input         Ch5ReqM;          // Channel 5 request for AHB
input         Ch6ReqM;          // Channel 6 request for AHB
input         Ch7ReqM;          // Channel 7 request for AHB
input   [4:0] Ch0NumOfXfers;    // Channel 0 - Number of transfers
input   [4:0] Ch1NumOfXfers;    // Channel 1 - Number of transfers
input   [4:0] Ch2NumOfXfers;    // Channel 2 - Number of transfers
input   [4:0] Ch3NumOfXfers;    // Channel 3 - Number of transfers
input   [4:0] Ch4NumOfXfers;    // Channel 4 - Number of transfers
input   [4:0] Ch5NumOfXfers;    // Channel 5 - Number of transfers
input   [4:0] Ch6NumOfXfers;    // Channel 6 - Number of transfers
input   [4:0] Ch7NumOfXfers;    // Channel 7 - Number of transfers
input         Ch0IncrM;         // Indicates incrementing transfers are
                                // required for channel 0
input         Ch1IncrM;         // Indicates incrementing transfers are
                                // required for channel 1
input         Ch2IncrM;         // Indicates incrementing transfers are
                                // required for channel 2
input         Ch3IncrM;         // Indicates incrementing transfers are
                                // required for channel 3
input         Ch4IncrM;         // Indicates incrementing transfers are
                                // required for channel 4
input         Ch5IncrM;         // Indicates incrementing transfers are
                                // required for channel 5
input         Ch6IncrM;         // Indicates incrementing transfers are
                                // required for channel 6
input         Ch7IncrM;         // Indicates incrementing transfers are
                                // required for channel 7
input  [31:0] Ch0AddrM;         // First address for the AHB Access
                                // requested by channel 0
input  [31:0] Ch1AddrM;         // First address for the AHB Access
                                // requested by channel 1
input  [31:0] Ch2AddrM;         // First address for the AHB Access
                                // requested by channel 2
input  [31:0] Ch3AddrM;         // First address for the AHB Access
                                // requested by channel 3
input  [31:0] Ch4AddrM;         // First address for the AHB Access
                                // requested by channel 4
input  [31:0] Ch5AddrM;         // First address for the AHB Access
                                // requested by channel 5
input  [31:0] Ch6AddrM;         // First address for the AHB Access
                                // requested by channel 6
input  [31:0] Ch7AddrM;         // First address for the AHB Access
                                // requested by channel 7
input   [2:0] Ch0ProtM;         // HPROT information for channel 0
input   [2:0] Ch1ProtM;         // HPROT information for channel 1
input   [2:0] Ch2ProtM;         // HPROT information for channel 2
input   [2:0] Ch3ProtM;         // HPROT information for channel 3
input   [2:0] Ch4ProtM;         // HPROT information for channel 4
input   [2:0] Ch5ProtM;         // HPROT information for channel 5
input   [2:0] Ch6ProtM;         // HPROT information for channel 6
input   [2:0] Ch7ProtM;         // HPROT information for channel 7
input         Ch0LockM;         // HLOCK information for channel 0
input         Ch1LockM;         // HLOCK information for channel 1
input         Ch2LockM;         // HLOCK information for channel 2
input         Ch3LockM;         // HLOCK information for channel 3
input         Ch4LockM;         // HLOCK information for channel 4
input         Ch5LockM;         // HLOCK information for channel 5
input         Ch6LockM;         // HLOCK information for channel 6
input         Ch7LockM;         // HLOCK information for channel 7
input   [2:0] Ch0WidthM;        // HSIZE information for channel 0
input   [2:0] Ch1WidthM;        // HSIZE information for channel 1
input   [2:0] Ch2WidthM;        // HSIZE information for channel 2
input   [2:0] Ch3WidthM;        // HSIZE information for channel 3
input   [2:0] Ch4WidthM;        // HSIZE information for channel 4
input   [2:0] Ch5WidthM;        // HSIZE information for channel 5
input   [2:0] Ch6WidthM;        // HSIZE information for channel 6
input   [2:0] Ch7WidthM;        // HSIZE information for channel 7
input         Ch0DirxnM;        // HWRITE information for channel 0
input         Ch1DirxnM;        // HWRITE information for channel 1
input         Ch2DirxnM;        // HWRITE information for channel 2
input         Ch3DirxnM;        // HWRITE information for channel 3
input         Ch4DirxnM;        // HWRITE information for channel 4
input         Ch5DirxnM;        // HWRITE information for channel 5
input         Ch6DirxnM;        // HWRITE information for channel 6
input         Ch7DirxnM;        // HWRITE information for channel 7
input         Ch0XferAbort;     // Request to abort the AHB transfer from
                                // channel 0
input         Ch1XferAbort;     // Request to abort the AHB transfer from
                                // channel 1
input         Ch2XferAbort;     // Request to abort the AHB transfer from
                                // channel 2
input         Ch3XferAbort;     // Request to abort the AHB transfer from
                                // channel 3
input         Ch4XferAbort;     // Request to abort the AHB transfer from
                                // channel 4
input         Ch5XferAbort;     // Request to abort the AHB transfer from
                                // channel 5
input         Ch6XferAbort;     // Request to abort the AHB transfer from
                                // channel 6
input         Ch7XferAbort;     // Request to abort the AHB transfer from
                                // channel 7
input  [31:0] Ch0HWDATA;        // HWDATA from channel 0
input  [31:0] Ch1HWDATA;        // HWDATA from channel 1
input  [31:0] Ch2HWDATA;        // HWDATA from channel 2
input  [31:0] Ch3HWDATA;        // HWDATA from channel 3
input  [31:0] Ch4HWDATA;        // HWDATA from channel 4
input  [31:0] Ch5HWDATA;        // HWDATA from channel 5
input  [31:0] Ch6HWDATA;        // HWDATA from channel 6
input  [31:0] Ch7HWDATA;        // HWDATA from channel 7

// Outputs
// AHB signals
// To AHB arbiter
output        HBUSREQDMACM;     // HBUSREQ signal to the AHB arbiter
output        HLOCKDMACM;       // Locking Information of AHB transfer
output  [3:0] HPROTM;           // Protection Info on AHB
// To AHB slave and arbiter
output  [2:0] HBURSTM;          // Burst Information
// To AHB slave
output  [1:0] HTRANSM;          // Type of transfer on AHB
output [31:0] HADDRM;           // AHB Slave Address to be accessed
output  [2:0] HSIZEM;           // Width of the AHB data transfer
output        HWRITEM;          // Signal to specify the read or write
                                // transfer to/from slave
output [31:0] HWDATAM;          // Write Data to AHB Slave
// To Channels
output        BusAvlblM;        // Bus available signal for channels
output        DataError;        // Data error
output        XferAborted;      // Acknowledge to abort request
output        Ch0GntM;          // Grant for channel 0
output        Ch1GntM;          // Grant for channel 1
output        Ch2GntM;          // Grant for channel 2
output        Ch3GntM;          // Grant for channel 3
output        Ch4GntM;          // Grant for channel 4
output        Ch5GntM;          // Grant for channel 5
output        Ch6GntM;          // Grant for channel 6
output        Ch7GntM;          // Grant for channel 7
output [31:0] MasterAddress;    // HADDR information
output [31:0] ChWrData;         // Write Data to channel FIFO

// Inputs
// AHB signals
// From Reset and clock generator
wire          HCLK;             // AHB clock
wire          HRESETn;          // AHB Reset
// From arbiter
wire          HGRANTDMACM;      // AHB bus grant for master
// from AHB slave
wire          HREADYINM;        // HREADYIN response from the Slave
wire    [1:0] HRESPM;           // HRESP response from the AHB Slave
wire   [31:0] HRDATAM;          // Read data from AHB Master
wire          BigEndianM;       // Endianness information
// From Channel side.
wire          Ch0ReqM;          // Channel 0 request for AHB
wire          Ch1ReqM;          // Channel 1 request for AHB
wire          Ch2ReqM;          // Channel 2 request for AHB
wire          Ch3ReqM;          // Channel 3 request for AHB
wire          Ch4ReqM;          // Channel 4 request for AHB
wire          Ch5ReqM;          // Channel 5 request for AHB
wire          Ch6ReqM;          // Channel 6 request for AHB
wire          Ch7ReqM;          // Channel 7 request for AHB
wire    [4:0] Ch0NumOfXfers;    // Channel 0 - Number of transfers
wire    [4:0] Ch1NumOfXfers;    // Channel 1 - Number of transfers
wire    [4:0] Ch2NumOfXfers;    // Channel 2 - Number of transfers
wire    [4:0] Ch3NumOfXfers;    // Channel 3 - Number of transfers
wire    [4:0] Ch4NumOfXfers;    // Channel 4 - Number of transfers
wire    [4:0] Ch5NumOfXfers;    // Channel 5 - Number of transfers
wire    [4:0] Ch6NumOfXfers;    // Channel 6 - Number of transfers
wire    [4:0] Ch7NumOfXfers;    // Channel 7 - Number of transfers
wire          Ch0IncrM;         // Indicates incrementing transfers are
                                // required for channel 0
wire          Ch1IncrM;         // Indicates incrementing transfers are
                                // required for channel 1
wire          Ch2IncrM;         // Indicates incrementing transfers are
                                // required for channel 2
wire          Ch3IncrM;         // Indicates incrementing transfers are
                                // required for channel 3
wire          Ch4IncrM;         // Indicates incrementing transfers are
                                // required for channel 4
wire          Ch5IncrM;         // Indicates incrementing transfers are
                                // required for channel 5
wire          Ch6IncrM;         // Indicates incrementing transfers are
                                // required for channel 6
wire          Ch7IncrM;         // Indicates incrementing transfers are
                                // required for channel 7
wire   [31:0] Ch0AddrM;         // First address for the AHB Access
                                // requested by channel 0
wire   [31:0] Ch1AddrM;         // First address for the AHB Access
                                // requested by channel 1
wire   [31:0] Ch2AddrM;         // First address for the AHB Access
                                // requested by channel 2
wire   [31:0] Ch3AddrM;         // First address for the AHB Access
                                // requested by channel 3
wire   [31:0] Ch4AddrM;         // First address for the AHB Access
                                // requested by channel 4
wire   [31:0] Ch5AddrM;         // First address for the AHB Access
                                // requested by channel 5
wire   [31:0] Ch6AddrM;         // First address for the AHB Access
                                // requested by channel 6
wire   [31:0] Ch7AddrM;         // First address for the AHB Access
                                // requested by channel 7
wire    [2:0] Ch0ProtM;         // HPROT information for channel 0
wire    [2:0] Ch1ProtM;         // HPROT information for channel 1
wire    [2:0] Ch2ProtM;         // HPROT information for channel 2
wire    [2:0] Ch3ProtM;         // HPROT information for channel 3
wire    [2:0] Ch4ProtM;         // HPROT information for channel 4
wire    [2:0] Ch5ProtM;         // HPROT information for channel 5
wire    [2:0] Ch6ProtM;         // HPROT information for channel 6
wire    [2:0] Ch7ProtM;         // HPROT information for channel 7
wire          Ch0LockM;         // HLOCK information for channel 0
wire          Ch1LockM;         // HLOCK information for channel 1
wire          Ch2LockM;         // HLOCK information for channel 2
wire          Ch3LockM;         // HLOCK information for channel 3
wire          Ch4LockM;         // HLOCK information for channel 4
wire          Ch5LockM;         // HLOCK information for channel 5
wire          Ch6LockM;         // HLOCK information for channel 6
wire          Ch7LockM;         // HLOCK information for channel 7
wire    [2:0] Ch0WidthM;        // HSIZE information for channel 0
wire    [2:0] Ch1WidthM;        // HSIZE information for channel 1
wire    [2:0] Ch2WidthM;        // HSIZE information for channel 2
wire    [2:0] Ch3WidthM;        // HSIZE information for channel 3
wire    [2:0] Ch4WidthM;        // HSIZE information for channel 4
wire    [2:0] Ch5WidthM;        // HSIZE information for channel 5
wire    [2:0] Ch6WidthM;        // HSIZE information for channel 6
wire    [2:0] Ch7WidthM;        // HSIZE information for channel 7
wire          Ch0DirxnM;        // HWRITE information for channel 0
wire          Ch1DirxnM;        // HWRITE information for channel 1
wire          Ch2DirxnM;        // HWRITE information for channel 2
wire          Ch3DirxnM;        // HWRITE information for channel 3
wire          Ch4DirxnM;        // HWRITE information for channel 4
wire          Ch5DirxnM;        // HWRITE information for channel 5
wire          Ch6DirxnM;        // HWRITE information for channel 6
wire          Ch7DirxnM;        // HWRITE information for channel 7
wire          Ch0XferAbort;     // Request to abort the AHB transfer from
                                // channel 0
wire          Ch1XferAbort;     // Request to abort the AHB transfer from
                                // channel 1
wire          Ch2XferAbort;     // Request to abort the AHB transfer from
                                // channel 2
wire          Ch3XferAbort;     // Request to abort the AHB transfer from
                                // channel 3
wire          Ch4XferAbort;     // Request to abort the AHB transfer from
                                // channel 4
wire          Ch5XferAbort;     // Request to abort the AHB transfer from
                                // channel 5
wire          Ch6XferAbort;     // Request to abort the AHB transfer from
                                // channel 6
wire          Ch7XferAbort;     // Request to abort the AHB transfer from
                                // channel 7
wire   [31:0] Ch0HWDATA;        // HWDATA from channel 0
wire   [31:0] Ch1HWDATA;        // HWDATA from channel 1
wire   [31:0] Ch2HWDATA;        // HWDATA from channel 2
wire   [31:0] Ch3HWDATA;        // HWDATA from channel 3
wire   [31:0] Ch4HWDATA;        // HWDATA from channel 4
wire   [31:0] Ch5HWDATA;        // HWDATA from channel 5
wire   [31:0] Ch6HWDATA;        // HWDATA from channel 6
wire   [31:0] Ch7HWDATA;        // HWDATA from channel 7

// Outputs
// AHB signals
// To AHB arbiter
wire          HBUSREQDMACM;     // HBUSREQ signal to the AHB arbiter
wire          HLOCKDMACM;       // Locking Information of AHB transfer
wire    [3:0] HPROTM;           // Protection Info on AHB
// To AHB slave and arbiter
wire    [2:0] HBURSTM;          // Burst Information
// To AHB slave
wire    [1:0] HTRANSM;          // Type of transfer on AHB
wire   [31:0] HADDRM;           // AHB Slave Address to be accessed
wire    [2:0] HSIZEM;           // Width of the AHB data transfer
wire          HWRITEM;          // Signal to specify the read or write
                                // transfer to/from slave
wire   [31:0] HWDATAM;          // Write Data to AHB Slave
// To Channels
wire          BusAvlblM;        // Bus available signal for channels
wire          DataError;        // Data error
wire          XferAborted;      // Acknowledge to abort request
wire          Ch0GntM;          // Grant for channel 0
wire          Ch1GntM;          // Grant for channel 1
wire          Ch2GntM;          // Grant for channel 2
wire          Ch3GntM;          // Grant for channel 3
wire          Ch4GntM;          // Grant for channel 4
wire          Ch5GntM;          // Grant for channel 5
wire          Ch6GntM;          // Grant for channel 6
wire          Ch7GntM;          // Grant for channel 7
wire   [31:0] MasterAddress;    // HADDR information
wire   [31:0] ChWrData;         // Write Data to channel FIFO

// -----------------------------------------------------------------------------
//
//                                DmacAhbMaster
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//         This module structural block integrating the AHB-Lite master
// interface for the DMAC and the wrapper around it to make it full AHB Master
// interface. This block instantiates the following functional sub-blocks.
//      - DmacLiteMaster
//           This module implements the AHB Lite Master Interface for the
//        DMA controller. This module along with the AHB-Lite wrapper acts as
//        the interface between the AHB and the channels/internal arbiter.
//      - DmacArbiter
//        The DmacArbiter performs the function of
//           o Passing the channel transfer requests to the Master Interface.
//           o Passing the abort-transfer-requests to the Master Interface.
//           o Granting one of the channels, if more than one channel has raised
//             a transfer request.
//           o Passing the address and control information of the granted
//             channel to the Lite Master Interface.
//      - DmacMasterWrap
//            This wrapper enables an AHB-Lite master to interface to an AHB
//        system. The wrapper handles bus requests and slave responses, using
//        MREADY as a means to hold the AHB-Lite master.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [31:0] MADDR;
// AHB Slave Address to be accessed for transfer

wire  [1:0] MTRANS;
// Type of transfer on AHB

wire        MWRITE;
// Signal to specify the read or write transfer to/from slave

wire  [2:0] MSIZE;
// Width of the AHB data transfer

wire  [2:0] MBURST;
// Burst Information

wire  [3:0] MPROT;
// Protection Information on AHB

wire        MLOCK;
// Locking Information of AHB transfer

wire [31:0] MRDATA;
// Read data from AHB Slave

wire [31:0] MWDATA;
// Write Data Bus

wire        MREADY;
// Signal to indicate the waited transfers from the AHB slave

wire        MERROR;
// Signal to indicate the Error response from the AHB slave


// Internal arbiter signals
wire        ArbHLOCK;
// HLOCK information

wire  [2:0] ArbHPROT;
// HPROT information

wire  [2:0] ArbHSIZE;
// HSIZE information

wire [31:0] ArbHADDR;
// HADDR information

wire        ArbIncrXfer;
// Indicates incremental addressing

wire        ArbPriority;
// Indicates priority of the granted channel

wire        ArbXferDir;
// Indicates transfer direction

wire        ArbXferReq;
// AHB Transfer Request

wire  [4:0] ArbNumOfXfers;
// Number of transfers requested

wire        AbortXfer;
// Signal to abort the transfer

wire        ArbStop;
// Stops arbitration

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
// Instantiation of DmacMasterWrap
// -----------------------------------------------------------------------------
DmacMasterWrap uDmacMasterWrap        (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HREADY           (HREADYINM),
                    .HRESP            (HRESPM),
                    .HGRANT           (HGRANTDMACM),
                    .HRDATA           (HRDATAM),
                    .HADDR            (HADDRM),
                    .HTRANS           (HTRANSM),
                    .HWRITE           (HWRITEM),
                    .HSIZE            (HSIZEM),
                    .HBURST           (HBURSTM),
                    .HPROT            (HPROTM),
                    .HBUSREQ          (HBUSREQDMACM),
                    .HLOCK            (HLOCKDMACM),
                    .HWDATA           (HWDATAM),
                    .MADDR            (MADDR),
                    .MTRANS           (MTRANS),
                    .MWRITE           (MWRITE),
                    .MSIZE            (MSIZE),
                    .MBURST           (MBURST),
                    .MPROT            (MPROT),
                    .MMASTLOCK        (MLOCK),
                    .MWDATA           (MWDATA),
                    .MRDATA           (MRDATA),
                    .MREADY           (MREADY),
                    .MERROR           (MERROR)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacLiteMaster
// -----------------------------------------------------------------------------
DmacLiteMaster uDmacLiteMaster        (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .MREADY           (MREADY),
                    .MERROR           (MERROR),
                    .MRDATA           (MRDATA),
                    .BigEndianM       (BigEndianM),
                    .Ch0HWDATA        (Ch0HWDATA),
                    .Ch1HWDATA        (Ch1HWDATA),
                    .Ch2HWDATA        (Ch2HWDATA),
                    .Ch3HWDATA        (Ch3HWDATA),
                    .Ch4HWDATA        (Ch4HWDATA),
                    .Ch5HWDATA        (Ch5HWDATA),
                    .Ch6HWDATA        (Ch6HWDATA),
                    .Ch7HWDATA        (Ch7HWDATA),
                    .ArbHLOCK         (ArbHLOCK),
                    .ArbHPROT         (ArbHPROT),
                    .ArbHSIZE         (ArbHSIZE),
                    .ArbHADDR         (ArbHADDR),
                    .ArbIncrXfer      (ArbIncrXfer),
                    .ArbPriority      (ArbPriority),
                    .ArbXferDir       (ArbXferDir),
                    .ArbXferReq       (ArbXferReq),
                    .ArbNumOfXfers    (ArbNumOfXfers),
                    .AbortXfer        (AbortXfer),
                    .MWDATA           (MWDATA),
                    .MLOCK            (MLOCK),
                    .MPROT            (MPROT),
                    .MBURST           (MBURST),
                    .MTRANS           (MTRANS),
                    .MADDR            (MADDR),
                    .MSIZE            (MSIZE),
                    .MWRITE           (MWRITE),
                    .BusAvlblM        (BusAvlblM),
                    .XferAborted      (XferAborted),
                    .ArbStop          (ArbStop),
                    .ArbDataError     (DataError),
                    .MasterAddress    (MasterAddress),
                    .ChWrData         (ChWrData)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacArbiter
// -----------------------------------------------------------------------------
DmacArbiter uDmacArbiter              (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .ArbStop          (ArbStop),
                    .Ch0ReqM          (Ch0ReqM),
                    .Ch1ReqM          (Ch1ReqM),
                    .Ch2ReqM          (Ch2ReqM),
                    .Ch3ReqM          (Ch3ReqM),
                    .Ch4ReqM          (Ch4ReqM),
                    .Ch5ReqM          (Ch5ReqM),
                    .Ch6ReqM          (Ch6ReqM),
                    .Ch7ReqM          (Ch7ReqM),
                    .Ch0NumOfXfers    (Ch0NumOfXfers),
                    .Ch1NumOfXfers    (Ch1NumOfXfers),
                    .Ch2NumOfXfers    (Ch2NumOfXfers),
                    .Ch3NumOfXfers    (Ch3NumOfXfers),
                    .Ch4NumOfXfers    (Ch4NumOfXfers),
                    .Ch5NumOfXfers    (Ch5NumOfXfers),
                    .Ch6NumOfXfers    (Ch6NumOfXfers),
                    .Ch7NumOfXfers    (Ch7NumOfXfers),
                    .Ch0IncrM         (Ch0IncrM),
                    .Ch1IncrM         (Ch1IncrM),
                    .Ch2IncrM         (Ch2IncrM),
                    .Ch3IncrM         (Ch3IncrM),
                    .Ch4IncrM         (Ch4IncrM),
                    .Ch5IncrM         (Ch5IncrM),
                    .Ch6IncrM         (Ch6IncrM),
                    .Ch7IncrM         (Ch7IncrM),
                    .Ch0AddrM         (Ch0AddrM),
                    .Ch1AddrM         (Ch1AddrM),
                    .Ch2AddrM         (Ch2AddrM),
                    .Ch3AddrM         (Ch3AddrM),
                    .Ch4AddrM         (Ch4AddrM),
                    .Ch5AddrM         (Ch5AddrM),
                    .Ch6AddrM         (Ch6AddrM),
                    .Ch7AddrM         (Ch7AddrM),
                    .Ch0ProtM         (Ch0ProtM),
                    .Ch1ProtM         (Ch1ProtM),
                    .Ch2ProtM         (Ch2ProtM),
                    .Ch3ProtM         (Ch3ProtM),
                    .Ch4ProtM         (Ch4ProtM),
                    .Ch5ProtM         (Ch5ProtM),
                    .Ch6ProtM         (Ch6ProtM),
                    .Ch7ProtM         (Ch7ProtM),
                    .Ch0LockM         (Ch0LockM),
                    .Ch1LockM         (Ch1LockM),
                    .Ch2LockM         (Ch2LockM),
                    .Ch3LockM         (Ch3LockM),
                    .Ch4LockM         (Ch4LockM),
                    .Ch5LockM         (Ch5LockM),
                    .Ch6LockM         (Ch6LockM),
                    .Ch7LockM         (Ch7LockM),
                    .Ch0WidthM        (Ch0WidthM),
                    .Ch1WidthM        (Ch1WidthM),
                    .Ch2WidthM        (Ch2WidthM),
                    .Ch3WidthM        (Ch3WidthM),
                    .Ch4WidthM        (Ch4WidthM),
                    .Ch5WidthM        (Ch5WidthM),
                    .Ch6WidthM        (Ch6WidthM),
                    .Ch7WidthM        (Ch7WidthM),
                    .Ch0DirxnM        (Ch0DirxnM),
                    .Ch1DirxnM        (Ch1DirxnM),
                    .Ch2DirxnM        (Ch2DirxnM),
                    .Ch3DirxnM        (Ch3DirxnM),
                    .Ch4DirxnM        (Ch4DirxnM),
                    .Ch5DirxnM        (Ch5DirxnM),
                    .Ch6DirxnM        (Ch6DirxnM),
                    .Ch7DirxnM        (Ch7DirxnM),
                    .Ch0XferAbort     (Ch0XferAbort),
                    .Ch1XferAbort     (Ch1XferAbort),
                    .Ch2XferAbort     (Ch2XferAbort),
                    .Ch3XferAbort     (Ch3XferAbort),
                    .Ch4XferAbort     (Ch4XferAbort),
                    .Ch5XferAbort     (Ch5XferAbort),
                    .Ch6XferAbort     (Ch6XferAbort),
                    .Ch7XferAbort     (Ch7XferAbort),
                    .ArbXferReq       (ArbXferReq),
                    .ArbNumOfXfers    (ArbNumOfXfers),
                    .ArbIncrXfer      (ArbIncrXfer),
                    .ArbHADDR         (ArbHADDR),
                    .ArbHPROT         (ArbHPROT),
                    .ArbHLOCK         (ArbHLOCK),
                    .ArbHSIZE         (ArbHSIZE),
                    .ArbPriority      (ArbPriority),
                    .ArbXferDir       (ArbXferDir),
                    .AbortXfer        (AbortXfer),
                    .Ch0GntM          (Ch0GntM),
                    .Ch1GntM          (Ch1GntM),
                    .Ch2GntM          (Ch2GntM),
                    .Ch3GntM          (Ch3GntM),
                    .Ch4GntM          (Ch4GntM),
                    .Ch5GntM          (Ch5GntM),
                    .Ch6GntM          (Ch6GntM),
                    .Ch7GntM          (Ch7GntM)
                    );

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
