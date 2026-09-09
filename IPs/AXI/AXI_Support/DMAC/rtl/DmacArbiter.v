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
// File Name              : DmacArbiter.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Internal arbiter to arbitrate requests from Channels and to route
//           selected requests to the AHB Master block.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacArbiter (
// Inputs
                    // AHB System
                    // From Reset and clock generator
                    HCLK,
                    HRESETn,
                    // From Master Interface
                    ArbStop,
                    // From channel side (DmacChannel)
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
// Outputs
                    // To Master Interface
                    ArbXferReq,
                    ArbNumOfXfers,
                    ArbIncrXfer,
                    ArbHPROT,
                    ArbHLOCK,
                    ArbHSIZE,
                    ArbPriority,
                    ArbXferDir,
                    AbortXfer,
                    ArbHADDR,
                    // To Channels (DmacChannel)
                    Ch0GntM,
                    Ch1GntM,
                    Ch2GntM,
                    Ch3GntM,
                    Ch4GntM,
                    Ch5GntM,
                    Ch6GntM,
                    Ch7GntM
                   );

// Inputs
// AHB System
input         HCLK;             // AHB Clock
input         HRESETn;          // AHB Reset
// From Master Interface
input         ArbStop;          // Stops arbitration
// From channel side (DmacChannel)
input         Ch0ReqM;          // Channel 0 request for AHB
input         Ch1ReqM;          // Channel 1 request for AHB
input         Ch2ReqM;          // Channel 2 request for AHB
input         Ch3ReqM;          // Channel 3 request for AHB
input         Ch4ReqM;          // Channel 4 request for AHB
input         Ch5ReqM;          // Channel 5 request for AHB
input         Ch6ReqM;          // Channel 6 request for AHB
input         Ch7ReqM;          // Channel 7 request for AHB
input   [4:0] Ch0NumOfXfers;    // Number of AHB transfers requested by CH 0
input   [4:0] Ch1NumOfXfers;    // Number of AHB transfers requested by CH 1
input   [4:0] Ch2NumOfXfers;    // Number of AHB transfers requested by CH 2
input   [4:0] Ch3NumOfXfers;    // Number of AHB transfers requested by CH 3
input   [4:0] Ch4NumOfXfers;    // Number of AHB transfers requested by CH 4
input   [4:0] Ch5NumOfXfers;    // Number of AHB transfers requested by CH 5
input   [4:0] Ch6NumOfXfers;    // Number of AHB transfers requested by CH 6
input   [4:0] Ch7NumOfXfers;    // Number of AHB transfers requested by CH 7
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
input         Ch0XferAbort;     // Request to abort the AHB transfer from CH 0
input         Ch1XferAbort;     // Request to abort the AHB transfer from CH 1
input         Ch2XferAbort;     // Request to abort the AHB transfer from CH 2
input         Ch3XferAbort;     // Request to abort the AHB transfer from CH 3
input         Ch4XferAbort;     // Request to abort the AHB transfer from CH 4
input         Ch5XferAbort;     // Request to abort the AHB transfer from CH 5
input         Ch6XferAbort;     // Request to abort the AHB transfer from CH 6
input         Ch7XferAbort;     // Request to abort the AHB transfer from CH 7

// Outputs
// To Master Interface
output        ArbXferReq;       // AHB Transfer Request
output  [4:0] ArbNumOfXfers;    // Number of transfers requested
output        ArbIncrXfer;      // Indicates incremental addressing
output  [2:0] ArbHPROT;         // HPROT information
output        ArbHLOCK;         // HLOCK information
output  [2:0] ArbHSIZE;         // HSIZE information
output        ArbPriority;      // Indicates priority of the granted channel
output        ArbXferDir;       // Indicates transfer direction
output        AbortXfer;        // Signal to abort the transfer
output [31:0] ArbHADDR;         // HADDR information
// To Channels (DmacChannel)
output        Ch0GntM;          // Grant for channel 0
output        Ch1GntM;          // Grant for channel 1
output        Ch2GntM;          // Grant for channel 2
output        Ch3GntM;          // Grant for channel 3
output        Ch4GntM;          // Grant for channel 4
output        Ch5GntM;          // Grant for channel 5
output        Ch6GntM;          // Grant for channel 6
output        Ch7GntM;          // Grant for channel 7

// Inputs
// AHB System
wire          HCLK;             // AHB Clock
wire          HRESETn;          // AHB Reset
// From Master Interface
wire          ArbStop;          // Stops arbitration
// From channel side (DmacChannel)
wire          Ch0ReqM;          // Channel 0 request for AHB
wire          Ch1ReqM;          // Channel 1 request for AHB
wire          Ch2ReqM;          // Channel 2 request for AHB
wire          Ch3ReqM;          // Channel 3 request for AHB
wire          Ch4ReqM;          // Channel 4 request for AHB
wire          Ch5ReqM;          // Channel 5 request for AHB
wire          Ch6ReqM;          // Channel 6 request for AHB
wire          Ch7ReqM;          // Channel 7 request for AHB
wire    [4:0] Ch0NumOfXfers;    // Number of AHB transfers requested by
                                // channel 0
wire    [4:0] Ch1NumOfXfers;    // Number of AHB transfers requested by
                                // channel 1
wire    [4:0] Ch2NumOfXfers;    // Number of AHB transfers requested by
                                // channel 2
wire    [4:0] Ch3NumOfXfers;    // Number of AHB transfers requested by
                                // channel 3
wire    [4:0] Ch4NumOfXfers;    // Number of AHB transfers requested by
                                // channel 4
wire    [4:0] Ch5NumOfXfers;    // Number of AHB transfers requested by
                                // channel 5
wire    [4:0] Ch6NumOfXfers;    // Number of AHB transfers requested by
                                // channel 6
wire    [4:0] Ch7NumOfXfers;    // Number of AHB transfers requested by
                                // channel 7
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

// Outputs
// To Master Interface
reg           ArbXferReq;       // AHB Transfer Request
reg     [4:0] ArbNumOfXfers;    // Number of transfers requested
reg           ArbIncrXfer;      // Indicates incremental addressing
reg     [2:0] ArbHPROT;         // HPROT information
reg           ArbHLOCK;         // HLOCK information
reg     [2:0] ArbHSIZE;         // HSIZE information
reg           ArbPriority;      // Indicates priority of the granted channel
reg           ArbXferDir;       // Indicates transfer direction
reg           AbortXfer;        // Signal to abort the transfer
reg    [31:0] ArbHADDR;         // HADDR information
// To Channels (DmacChannel)
reg           Ch0GntM;          // Grant for channel 0
reg           Ch1GntM;          // Grant for channel 1
reg           Ch2GntM;          // Grant for channel 2
reg           Ch3GntM;          // Grant for channel 3
reg           Ch4GntM;          // Grant for channel 4
reg           Ch5GntM;          // Grant for channel 5
reg           Ch6GntM;          // Grant for channel 6
reg           Ch7GntM;          // Grant for channel 7

// -----------------------------------------------------------------------------
//
//                                 DmacArbiter
//                                 ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// The DmacArbiter performs the function of
// o Passing the channel transfer requests to the Master Interface.
// o Passing the abort-transfer-requests to the Master Interface.
// o Granting one of the channels, if more than one channel has raised a
//   transfer request.
// o Passing the address and control information of the granted channel to the
//   Master Interface.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        iCh0GntM;
// internal copy of Channel 0 grant

wire        iCh1GntM;
// internal copy of Channel 1 grant

wire        iCh2GntM;
// internal copy of Channel 2 grant

wire        iCh3GntM;
// internal copy of Channel 3 grant

wire        iCh4GntM;
// internal copy of Channel 4 grant

wire        iCh5GntM;
// internal copy of Channel 5 grant

wire        iCh6GntM;
// internal copy of Channel 6 grant

wire        iCh7GntM;
// internal copy of Channel 7 grant

wire        CombCh0Gnt;
// combinational grant given to channel 0

wire        CombCh1Gnt;
// combinational grant given to channel 1

wire        CombCh2Gnt;
// combinational grant given to channel 2

wire        CombCh3Gnt;
// combinational grant given to channel 3

wire        CombCh4Gnt;
// combinational grant given to channel 4

wire        CombCh5Gnt;
// combinational grant given to channel 5

wire        CombCh6Gnt;
// combinational grant given to channel 6

wire        CombCh7Gnt;
// combinational grant given to channel 7

wire  [4:0] And0NumOfXfers;
// Number of AHB transfers requested by channel 0

wire  [4:0] And1NumOfXfers;
// Number of AHB transfers requested by channel 1

wire  [4:0] And2NumOfXfers;
// Number of AHB transfers requested by channel 2

wire  [4:0] And3NumOfXfers;
// Number of AHB transfers requested by channel 3

wire  [4:0] And4NumOfXfers;
// Number of AHB transfers requested by channel 4

wire  [4:0] And5NumOfXfers;
// Number of AHB transfers requested by channel 5

wire  [4:0] And6NumOfXfers;
// Number of AHB transfers requested by channel 6

wire  [4:0] And7NumOfXfers;
// Number of AHB transfers requested by channel 7

wire        And0IncrM;
// Indicates incrementing transfers are required for channel 0

wire        And1IncrM;
// Indicates incrementing transfers are required for channel 1

wire        And2IncrM;
// Indicates incrementing transfers are required for channel 2

wire        And3IncrM;
// Indicates incrementing transfers are required for channel 3

wire        And4IncrM;
// Indicates incrementing transfers are required for channel 4

wire        And5IncrM;
// Indicates incrementing transfers are required for channel 5

wire        And6IncrM;
// Indicates incrementing transfers are required for channel 6

wire        And7IncrM;
// Indicates incrementing transfers are required for channel 7

wire [31:0] And0AddrM;
// First address for the AHB Access requested by channel 0

wire [31:0] And1AddrM;
// First address for the AHB Access requested by channel 1

wire [31:0] And2AddrM;
// First address for the AHB Access requested by channel 2

wire [31:0] And3AddrM;
// First address for the AHB Access requested by channel 3

wire [31:0] And4AddrM;
// First address for the AHB Access requested by channel 4

wire [31:0] And5AddrM;
// First address for the AHB Access requested by channel 5

wire [31:0] And6AddrM;
// First address for the AHB Access requested by channel 6

wire [31:0] And7AddrM;
// First address for the AHB Access requested by channel 7

wire  [2:0] And0ProtM;
// HPROT information for channel 0

wire  [2:0] And1ProtM;
// HPROT information for channel 1

wire  [2:0] And2ProtM;
// HPROT information for channel 2

wire  [2:0] And3ProtM;
// HPROT information for channel 3

wire  [2:0] And4ProtM;
// HPROT information for channel 4

wire  [2:0] And5ProtM;
// HPROT information for channel 5

wire  [2:0] And6ProtM;
// HPROT information for channel 6

wire  [2:0] And7ProtM;
// HPROT information for channel 7

wire        And0LockM;
// HLOCK information for channel 0

wire        And1LockM;
// HLOCK information for channel 1

wire        And2LockM;
// HLOCK information for channel 2

wire        And3LockM;
// HLOCK information for channel 3

wire        And4LockM;
// HLOCK information for channel 4

wire        And5LockM;
// HLOCK information for channel 5

wire        And6LockM;
// HLOCK information for channel 6

wire        And7LockM;
// HLOCK information for channel 7

wire  [2:0] And0WidthM;
// HSIZE information for channel 0

wire  [2:0] And1WidthM;
// HSIZE information for channel 1

wire  [2:0] And2WidthM;
// HSIZE information for channel 2

wire  [2:0] And3WidthM;
// HSIZE information for channel 3

wire  [2:0] And4WidthM;
// HSIZE information for channel 4

wire  [2:0] And5WidthM;
// HSIZE information for channel 5

wire  [2:0] And6WidthM;
// HSIZE information for channel 6

wire  [2:0] And7WidthM;
// HSIZE information for channel 7

wire        And0DirxnM;
// HWRITE information for channel 0

wire        And1DirxnM;
// HWRITE information for channel 1

wire        And2DirxnM;
// HWRITE information for channel 2

wire        And3DirxnM;
// HWRITE information for channel 3

wire        And4DirxnM;
// HWRITE information for channel 4

wire        And5DirxnM;
// HWRITE information for channel 5

wire        And6DirxnM;
// HWRITE information for channel 6

wire        And7DirxnM;
// HWRITE information for channel 7

wire        IArbXferReq;       
// AHB Transfer Request

wire  [4:0] IArbNumOfXfers;    
// Number of transfers requested

wire        IArbIncrXfer;      
// Indicates incremental addressing

wire  [2:0] IArbHPROT;         
// HPROT information

wire        IArbHLOCK;         
// HLOCK information

wire  [2:0] IArbHSIZE;         
// HSIZE information

wire        IArbPriority;      
// Indicates priority of the granted channel

wire        IArbXferDir;       
// Indicates transfer direction

wire        IAbortXfer;        
// Signal to abort the transfer

wire [31:0] IArbHADDR;         
// HADDR information

wire        NxtArbReqMask;
// The D-input of ArbReqMask

wire        NxtArbXferReq;
// The D-input of ArbXferReq

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         ArbReqMask;
// The signal used for masking out the extra request which comes
// due to delay in deassertion of the Request from channel due to
// clocked out Grant signal from the Arbiter

//Include Parameters File
`include "DmacParams.v"

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
// The IArbXferReq to the master interface is a logical OR of all the channel
// requests. The channel that will be granted, will be giving out the other
// information like ArbNumofXfer, ArbIncrXfer etc. to the master interface.
// -----------------------------------------------------------------------------
assign IArbXferReq       = Ch0ReqM | Ch1ReqM | Ch2ReqM | Ch3ReqM | Ch4ReqM
                           | Ch5ReqM | Ch6ReqM | Ch7ReqM;

// -----------------------------------------------------------------------------
// The channels can assert IXferAbort only in DATAXFER state. At a time there
// cannot be more than one channel active on the same AHB port. Thus the
// IAbortXfer is an ORed version of all the ChxXferAbort.
// -----------------------------------------------------------------------------
assign IAbortXfer        = Ch0XferAbort | Ch1XferAbort | Ch2XferAbort |
                           Ch3XferAbort | Ch4XferAbort | Ch5XferAbort |
                           Ch6XferAbort | Ch7XferAbort;

// -----------------------------------------------------------------------------
// The following block of statements generates the grant for each channel. The
// priority scheme that has been used for giving grant is 'Fixed Priority'. Thus
// the logic is a priority encoder with the highest priority given to channel 0
// and the lowest to channel 7.
// Moreover, when channel 6 and 7 are granted, the IArbPriority line is
// pulled low, as these channels (6 and 7) are described as lower priority
// channel in DMAC specification.
// -----------------------------------------------------------------------------
assign CombCh0Gnt       = Ch0ReqM;
assign CombCh1Gnt       = ( ~Ch0ReqM) & Ch1ReqM;
assign CombCh2Gnt       = ( ~Ch0ReqM) & ( ~Ch1ReqM) & Ch2ReqM;
assign CombCh3Gnt       = ( ~Ch0ReqM) & ( ~Ch1ReqM) & ( ~Ch2ReqM) &
                           Ch3ReqM;
assign CombCh4Gnt       = ( ~Ch0ReqM) & ( ~Ch1ReqM) & ( ~Ch2ReqM) & (
                           ~Ch3ReqM) & Ch4ReqM;
assign CombCh5Gnt       = ( ~Ch0ReqM) & ( ~Ch1ReqM) & ( ~Ch2ReqM) & (
                           ~Ch3ReqM) & ( ~Ch4ReqM) & Ch5ReqM;
assign CombCh6Gnt       = ( ~Ch0ReqM) & ( ~Ch1ReqM) & ( ~Ch2ReqM) & (
                           ~Ch3ReqM) & ( ~Ch4ReqM) & ( ~Ch5ReqM) &
                           Ch6ReqM;
assign CombCh7Gnt       = ( ~Ch0ReqM) & ( ~Ch1ReqM) & ( ~Ch2ReqM) & (
                           ~Ch3ReqM) & ( ~Ch4ReqM) & ( ~Ch5ReqM) & (
                           ~Ch6ReqM) & Ch7ReqM;

assign IArbPriority      = ~(CombCh6Gnt | CombCh7Gnt);

// -----------------------------------------------------------------------------
// The internal grant to the channels is given, only when ArbStop is LOW. When
// ArbStop is high, none of the channels are granted. All the internal channel-
// grant-lines(iChxGntM) lines are pulled low.
// The internal-arbiter architecture is such that it arbitrates combinationally
// according to the fixed-priority scheme, unless ArbStop is high. Once a
// channel has been granted, then the next phase of arbitration should not start
// till the end of the ongoing transfer. To stop the arbiter from arbitrating
// during the current channel's transfer phase, the signal ArbStop is required.
// -----------------------------------------------------------------------------
// REVIEW the comments above this block in view of addition & ( ~ArbReqMask))
assign iCh0GntM         = CombCh0Gnt & ( ~(ArbStop)) & ( ~(ArbReqMask));
assign iCh1GntM         = CombCh1Gnt & ( ~(ArbStop)) & ( ~(ArbReqMask));
assign iCh2GntM         = CombCh2Gnt & ( ~(ArbStop)) & ( ~(ArbReqMask));
assign iCh3GntM         = CombCh3Gnt & ( ~(ArbStop)) & ( ~(ArbReqMask));
assign iCh4GntM         = CombCh4Gnt & ( ~(ArbStop)) & ( ~(ArbReqMask));
assign iCh5GntM         = CombCh5Gnt & ( ~(ArbStop)) & ( ~(ArbReqMask));
assign iCh6GntM         = CombCh6Gnt & ( ~(ArbStop)) & ( ~(ArbReqMask));
assign iCh7GntM         = CombCh7Gnt & ( ~(ArbStop)) & ( ~(ArbReqMask));

// -----------------------------------------------------------------------------
// The following bunch of statements, assigns the number-of-transfers to an
// intermediate signal (And*NumOfXfers) if the channel is granted. Otherwise a
// zero is assigned to the intermediate signal. The intermediate signals are
// bitwise ORed to generate the final NumOfXfers to be passed to master
// interface.
// -----------------------------------------------------------------------------
assign And0NumOfXfers   = (iCh0GntM == 1'b1) ? Ch0NumOfXfers         :
                           5'b00000;

assign And1NumOfXfers   = (iCh1GntM == 1'b1) ? Ch1NumOfXfers         :
                           5'b00000;

assign And2NumOfXfers   = (iCh2GntM == 1'b1) ? Ch2NumOfXfers         :
                           5'b00000;

assign And3NumOfXfers   = (iCh3GntM == 1'b1) ? Ch3NumOfXfers         :
                           5'b00000;

assign And4NumOfXfers   = (iCh4GntM == 1'b1) ? Ch4NumOfXfers         :
                           5'b00000;

assign And5NumOfXfers   = (iCh5GntM == 1'b1) ? Ch5NumOfXfers         :
                           5'b00000;

assign And6NumOfXfers   = (iCh6GntM == 1'b1) ? Ch6NumOfXfers         :
                           5'b00000;

assign And7NumOfXfers   = (iCh7GntM == 1'b1) ? Ch7NumOfXfers         :
                           5'b00000;

assign IArbNumOfXfers    = And0NumOfXfers | And1NumOfXfers |
                           And2NumOfXfers | And3NumOfXfers |
                           And4NumOfXfers | And5NumOfXfers |
                           And6NumOfXfers | And7NumOfXfers;

// -----------------------------------------------------------------------------
// The following bunch of statements, assigns the incremental-addressing-mode to
// an intermediate signal (And*IncrM) if the channel is granted. Otherwise a
// zero is assigned to the intermediate signal. The intermediate signals are
// ORed to generate the final IncrM to be passed to master interface.
// -----------------------------------------------------------------------------
assign And0IncrM        = (iCh0GntM == 1'b1) ? Ch0IncrM : 1'b0;

assign And1IncrM        = (iCh1GntM == 1'b1) ? Ch1IncrM : 1'b0;

assign And2IncrM        = (iCh2GntM == 1'b1) ? Ch2IncrM : 1'b0;

assign And3IncrM        = (iCh3GntM == 1'b1) ? Ch3IncrM : 1'b0;

assign And4IncrM        = (iCh4GntM == 1'b1) ? Ch4IncrM : 1'b0;

assign And5IncrM        = (iCh5GntM == 1'b1) ? Ch5IncrM : 1'b0;

assign And6IncrM        = (iCh6GntM == 1'b1) ? Ch6IncrM : 1'b0;

assign And7IncrM        = (iCh7GntM == 1'b1) ? Ch7IncrM : 1'b0;

assign IArbIncrXfer      = And0IncrM | And1IncrM | And2IncrM | And3IncrM |
                           And4IncrM | And5IncrM | And6IncrM | And7IncrM;

// -----------------------------------------------------------------------------
// The following bunch of statements, assigns the address to an
// intermediate signal (And*AddrM), if the channel is granted. Otherwise a
// zero is assigned to the intermediate signal. The intermediate signals are
// bitwise ORed to generate the final AddrM to be passed to master interface.
// -----------------------------------------------------------------------------
assign And0AddrM        = (iCh0GntM == 1'b1) ? Ch0AddrM              :
                           32'b00000000000000000000000000000000;

assign And1AddrM        = (iCh1GntM == 1'b1) ? Ch1AddrM              :
                           32'b00000000000000000000000000000000;

assign And2AddrM        = (iCh2GntM == 1'b1) ? Ch2AddrM              :
                           32'b00000000000000000000000000000000;

assign And3AddrM        = (iCh3GntM == 1'b1) ? Ch3AddrM              :
                           32'b00000000000000000000000000000000;

assign And4AddrM        = (iCh4GntM == 1'b1) ? Ch4AddrM              :
                           32'b00000000000000000000000000000000;

assign And5AddrM        = (iCh5GntM == 1'b1) ? Ch5AddrM              :
                           32'b00000000000000000000000000000000;

assign And6AddrM        = (iCh6GntM == 1'b1) ? Ch6AddrM              :
                           32'b00000000000000000000000000000000;

assign And7AddrM        = (iCh7GntM == 1'b1) ? Ch7AddrM              :
                           32'b00000000000000000000000000000000;

assign IArbHADDR         = And0AddrM | And1AddrM | And2AddrM | And3AddrM |
                           And4AddrM | And5AddrM | And6AddrM | And7AddrM;

// -----------------------------------------------------------------------------
// The following bunch of statements, assigns the HPROT status to an
// intermediate signal (And*ProtM), if the channel is granted. Otherwise a
// zero is assigned to the intermediate signal. The intermediate signals are
// bitwise ORed to generate the final ProtM to be passed to master interface.
// -----------------------------------------------------------------------------
assign And0ProtM        = (iCh0GntM == 1'b1) ? Ch0ProtM : 3'b000;

assign And1ProtM        = (iCh1GntM == 1'b1) ? Ch1ProtM : 3'b000;

assign And2ProtM        = (iCh2GntM == 1'b1) ? Ch2ProtM : 3'b000;

assign And3ProtM        = (iCh3GntM == 1'b1) ? Ch3ProtM : 3'b000;

assign And4ProtM        = (iCh4GntM == 1'b1) ? Ch4ProtM : 3'b000;

assign And5ProtM        = (iCh5GntM == 1'b1) ? Ch5ProtM : 3'b000;

assign And6ProtM        = (iCh6GntM == 1'b1) ? Ch6ProtM : 3'b000;

assign And7ProtM        = (iCh7GntM == 1'b1) ? Ch7ProtM : 3'b000;

assign IArbHPROT         = And0ProtM | And1ProtM | And2ProtM | And3ProtM |
                           And4ProtM | And5ProtM | And6ProtM | And7ProtM;

// -----------------------------------------------------------------------------
// The following bunch of statements, assigns the Lock-Status to an
// intermediate signal (And*LockM), if the channel is granted. Otherwise a
// zero is assigned to the intermediate signal. The intermediate signals are
// ORed to generate the final LockM to be passed to master interface.
// -----------------------------------------------------------------------------
assign And0LockM        = (iCh0GntM == 1'b1) ? Ch0LockM : 1'b0;

assign And1LockM        = (iCh1GntM == 1'b1) ? Ch1LockM : 1'b0;

assign And2LockM        = (iCh2GntM == 1'b1) ? Ch2LockM : 1'b0;

assign And3LockM        = (iCh3GntM == 1'b1) ? Ch3LockM : 1'b0;

assign And4LockM        = (iCh4GntM == 1'b1) ? Ch4LockM : 1'b0;

assign And5LockM        = (iCh5GntM == 1'b1) ? Ch5LockM : 1'b0;

assign And6LockM        = (iCh6GntM == 1'b1) ? Ch6LockM : 1'b0;

assign And7LockM        = (iCh7GntM == 1'b1) ? Ch7LockM : 1'b0;

assign IArbHLOCK         = And0LockM | And1LockM | And2LockM | And3LockM |
                           And4LockM | And5LockM | And6LockM | And7LockM;

// -----------------------------------------------------------------------------
// The following bunch of statements, assigns the width-of-transfers to an
// intermediate signal (And*WidthM), if the channel is granted. Otherwise a
// zero is assigned to the intermediate signal. The intermediate signals are
// bitwise ORed to generate the final WidthM to be passed to master interface.
// -----------------------------------------------------------------------------
assign And0WidthM       = (iCh0GntM == 1'b1) ? Ch0WidthM : 3'b000;

assign And1WidthM       = (iCh1GntM == 1'b1) ? Ch1WidthM : 3'b000;

assign And2WidthM       = (iCh2GntM == 1'b1) ? Ch2WidthM : 3'b000;

assign And3WidthM       = (iCh3GntM == 1'b1) ? Ch3WidthM : 3'b000;

assign And4WidthM       = (iCh4GntM == 1'b1) ? Ch4WidthM : 3'b000;

assign And5WidthM       = (iCh5GntM == 1'b1) ? Ch5WidthM : 3'b000;

assign And6WidthM       = (iCh6GntM == 1'b1) ? Ch6WidthM : 3'b000;

assign And7WidthM       = (iCh7GntM == 1'b1) ? Ch7WidthM : 3'b000;

assign IArbHSIZE         = And0WidthM | And1WidthM | And2WidthM |
                           And3WidthM | And4WidthM | And5WidthM |
                           And6WidthM | And7WidthM;

// -----------------------------------------------------------------------------
// The following bunch of statements, assigns the direction-of-transfers to an
// intermediate signal (And*DirxnM), if the channel is granted. Otherwise a
// zero is assigned to the intermediate signal. The intermediate signals are
// ORed to generate the final DirxnM to be passed to master interface.
// -----------------------------------------------------------------------------
assign And0DirxnM       = (iCh0GntM == 1'b1) ? Ch0DirxnM : 1'b0;

assign And1DirxnM       = (iCh1GntM == 1'b1) ? Ch1DirxnM : 1'b0;

assign And2DirxnM       = (iCh2GntM == 1'b1) ? Ch2DirxnM : 1'b0;

assign And3DirxnM       = (iCh3GntM == 1'b1) ? Ch3DirxnM : 1'b0;

assign And4DirxnM       = (iCh4GntM == 1'b1) ? Ch4DirxnM : 1'b0;

assign And5DirxnM       = (iCh5GntM == 1'b1) ? Ch5DirxnM : 1'b0;

assign And6DirxnM       = (iCh6GntM == 1'b1) ? Ch6DirxnM : 1'b0;

assign And7DirxnM       = (iCh7GntM == 1'b1) ? Ch7DirxnM : 1'b0;

assign IArbXferDir       = And0DirxnM | And1DirxnM | And2DirxnM |
                           And3DirxnM | And4DirxnM | And5DirxnM |
                           And6DirxnM | And7DirxnM;

// -----------------------------------------------------------------------------
// Sequential block for p_ChInfoSeq
// -----------------------------------------------------------------------------
always@ (posedge HCLK or negedge HRESETn)
begin: p_ChInfoSeq
  if (HRESETn == 1'b0) 
    begin
      ArbXferReq       <= 1'b0;
      ArbNumOfXfers    <= 5'b00000;
      ArbIncrXfer      <= 1'b0;
      ArbHPROT         <= 3'b000;
      ArbHLOCK         <= 1'b0;
      ArbHSIZE         <= 3'b000;
      ArbPriority      <= 1'b0;
      ArbXferDir       <= 1'b0;
      AbortXfer        <= 1'b0;
      ArbHADDR         <= 32'h00000000;
      ArbReqMask       <= 1'b0;
      Ch0GntM          <= 1'b0;
      Ch1GntM          <= 1'b0;
      Ch2GntM          <= 1'b0;
      Ch3GntM          <= 1'b0;
      Ch4GntM          <= 1'b0;
      Ch5GntM          <= 1'b0;
      Ch6GntM          <= 1'b0;
      Ch7GntM          <= 1'b0;
    end
  else 
    begin
      ArbXferReq       <= NxtArbXferReq;
      ArbNumOfXfers    <= IArbNumOfXfers;
      ArbIncrXfer      <= IArbIncrXfer;
      ArbHPROT         <= IArbHPROT;
      ArbHLOCK         <= IArbHLOCK;
      ArbHSIZE         <= IArbHSIZE;
      ArbPriority      <= IArbPriority;
      ArbXferDir       <= IArbXferDir;
      AbortXfer        <= IAbortXfer;
      ArbHADDR         <= IArbHADDR;
      ArbReqMask       <= NxtArbReqMask;
      Ch0GntM          <= iCh0GntM;
      Ch1GntM          <= iCh1GntM;
      Ch2GntM          <= iCh2GntM;
      Ch3GntM          <= iCh3GntM;
      Ch4GntM          <= iCh4GntM;
      Ch5GntM          <= iCh5GntM;
      Ch6GntM          <= iCh6GntM;
      Ch7GntM          <= iCh7GntM;
    end
end // p_ChInfoSeq

// -----------------------------------------------------------------------------
// Request masking for the request being already been granted : Due to
// one clock register delay of the grant it will be seen one clock later
// by the channel, so it will take one clock more by the channel to de-assert
// request. So to suppress this additional one clock request mask is been
// generated
// -----------------------------------------------------------------------------
assign NxtArbReqMask    = (iCh0GntM | iCh1GntM | iCh2GntM | iCh3GntM |
                     iCh4GntM | iCh5GntM | iCh6GntM | iCh7GntM);

// -----------------------------------------------------------------------------
// The Internal request is masked out if it is alreay granted
// -----------------------------------------------------------------------------
assign NxtArbXferReq    = IArbXferReq & (~(ArbReqMask)) & (~(ArbStop));

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
