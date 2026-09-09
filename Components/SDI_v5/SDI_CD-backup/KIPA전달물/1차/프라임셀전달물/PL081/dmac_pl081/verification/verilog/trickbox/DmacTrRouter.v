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
// File Name              : DmacTrRouter.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module is responsible for routing the channel resources
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacTrRouter (
// Inputs
                     HCLK,
                     HRESETn,
                     Ch0Arb1Comb,
                     Ch1Arb1Comb,
                     Ch2Arb1Comb,
                     Ch3Arb1Comb,
                     Ch4Arb1Comb,
                     Ch5Arb1Comb,
                     Ch6Arb1Comb,
                     Ch7Arb1Comb,
                     Ch0Arb2Comb,
                     Ch1Arb2Comb,
                     Ch2Arb2Comb,
                     Ch3Arb2Comb,
                     Ch4Arb2Comb,
                     Ch5Arb2Comb,
                     Ch6Arb2Comb,
                     Ch7Arb2Comb,
                     Ch0AddrBus1,
                     Ch1AddrBus1,
                     Ch2AddrBus1,
                     Ch3AddrBus1,
                     Ch4AddrBus1,
                     Ch5AddrBus1,
                     Ch6AddrBus1,
                     Ch7AddrBus1,
                     Ch0AddrBus2,
                     Ch1AddrBus2,
                     Ch2AddrBus2,
                     Ch3AddrBus2,
                     Ch4AddrBus2,
                     Ch5AddrBus2,
                     Ch6AddrBus2,
                     Ch7AddrBus2,
                     Ch0HProtBus1,
                     Ch1HProtBus1,
                     Ch2HProtBus1,
                     Ch3HProtBus1,
                     Ch4HProtBus1,
                     Ch5HProtBus1,
                     Ch6HProtBus1,
                     Ch7HProtBus1,
                     Ch0HProtBus2,
                     Ch1HProtBus2,
                     Ch2HProtBus2,
                     Ch3HProtBus2,
                     Ch4HProtBus2,
                     Ch5HProtBus2,
                     Ch6HProtBus2,
                     Ch7HProtBus2,
                     Ch0HLockBus1,
                     Ch1HLockBus1,
                     Ch2HLockBus1,
                     Ch3HLockBus1,
                     Ch4HLockBus1,
                     Ch5HLockBus1,
                     Ch6HLockBus1,
                     Ch7HLockBus1,
                     Ch0HLockBus2,
                     Ch1HLockBus2,
                     Ch2HLockBus2,
                     Ch3HLockBus2,
                     Ch4HLockBus2,
                     Ch5HLockBus2,
                     Ch6HLockBus2,
                     Ch7HLockBus2,
                     Ch0AddrIncBus1,
                     Ch1AddrIncBus1,
                     Ch2AddrIncBus1,
                     Ch3AddrIncBus1,
                     Ch4AddrIncBus1,
                     Ch5AddrIncBus1,
                     Ch6AddrIncBus1,
                     Ch7AddrIncBus1,
                     Ch0AddrIncBus2,
                     Ch1AddrIncBus2,
                     Ch2AddrIncBus2,
                     Ch3AddrIncBus2,
                     Ch4AddrIncBus2,
                     Ch5AddrIncBus2,
                     Ch6AddrIncBus2,
                     Ch7AddrIncBus2,
                     Ch0DisableBus1,
                     Ch1DisableBus1,
                     Ch2DisableBus1,
                     Ch3DisableBus1,
                     Ch4DisableBus1,
                     Ch5DisableBus1,
                     Ch6DisableBus1,
                     Ch7DisableBus1,
                     Ch0DisableBus2,
                     Ch1DisableBus2,
                     Ch2DisableBus2,
                     Ch3DisableBus2,
                     Ch4DisableBus2,
                     Ch5DisableBus2,
                     Ch6DisableBus2,
                     Ch7DisableBus2,
                     Ch0BeatCntBus1,
                     Ch1BeatCntBus1,
                     Ch2BeatCntBus1,
                     Ch3BeatCntBus1,
                     Ch4BeatCntBus1,
                     Ch5BeatCntBus1,
                     Ch6BeatCntBus1,
                     Ch7BeatCntBus1,
                     Ch0BeatCntBus2,
                     Ch1BeatCntBus2,
                     Ch2BeatCntBus2,
                     Ch3BeatCntBus2,
                     Ch4BeatCntBus2,
                     Ch5BeatCntBus2,
                     Ch6BeatCntBus2,
                     Ch7BeatCntBus2,
                     Ch0WriteBus1,
                     Ch1WriteBus1,
                     Ch2WriteBus1,
                     Ch3WriteBus1,
                     Ch4WriteBus1,
                     Ch5WriteBus1,
                     Ch6WriteBus1,
                     Ch7WriteBus1,
                     Ch0WriteBus2,
                     Ch1WriteBus2,
                     Ch2WriteBus2,
                     Ch3WriteBus2,
                     Ch4WriteBus2,
                     Ch5WriteBus2,
                     Ch6WriteBus2,
                     Ch7WriteBus2,
                     Ch0HSIZEBus1,
                     Ch1HSIZEBus1,
                     Ch2HSIZEBus1,
                     Ch3HSIZEBus1,
                     Ch4HSIZEBus1,
                     Ch5HSIZEBus1,
                     Ch6HSIZEBus1,
                     Ch7HSIZEBus1,
                     Ch0HSIZEBus2,
                     Ch1HSIZEBus2,
                     Ch2HSIZEBus2,
                     Ch3HSIZEBus2,
                     Ch4HSIZEBus2,
                     Ch5HSIZEBus2,
                     Ch6HSIZEBus2,
                     Ch7HSIZEBus2,
                     StopArb1,
                     StopArb2,
                     Ch0SOFTCLR,
                     Ch1SOFTCLR,
                     Ch2SOFTCLR,
                     Ch3SOFTCLR,
                     Ch4SOFTCLR,
                     Ch5SOFTCLR,
                     Ch6SOFTCLR,
                     Ch7SOFTCLR,
                     Ch0DMACTC,
                     Ch1DMACTC,
                     Ch2DMACTC,
                     Ch3DMACTC,
                     Ch4DMACTC,
                     Ch5DMACTC,
                     Ch6DMACTC,
                     Ch7DMACTC,
                     Ch0DMACCLR,
                     Ch1DMACCLR,
                     Ch2DMACCLR,
                     Ch3DMACCLR,
                     Ch4DMACCLR,
                     Ch5DMACCLR,
                     Ch6DMACCLR,
                     Ch7DMACCLR,
// Outputs
                     ChHLOCKBus1,
                     ChHLOCKBus2,
                     ChWRITEBus1,
                     ChWRITEBus2,
                     ChAddrIncrBus1,
                     ChAddrIncrBus2,
                     ChDisableBus1,
                     ChDisableBus2,
                     ChPriorityBus1,
                     ChPriorityBus2,
                     ChHProtBus1,
                     ChHProtBus2,
                     ChHSIZEBus1,
                     ChHSIZEBus2,
                     ChAddrBus1,
                     ChAddrBus2,
                     ChBeatCountBus1,
                     ChBeatCountBus2,
                     SOFTCLR,
                     DMACCLR,
                     DMACTC
                     );

// Inputs
input         HCLK;            // AHB Clock
input         HRESETn;         // AHB Reset
input         Ch0Arb1Comb;     // Channel0 Selected on Bus1
input         Ch1Arb1Comb;     // Channel1 Selected on Bus1
input         Ch2Arb1Comb;     // Channel2 Selected on Bus1
input         Ch3Arb1Comb;     // Channel3 Selected on Bus1
input         Ch4Arb1Comb;     // Channel4 Selected on Bus1
input         Ch5Arb1Comb;     // Channel5 Selected on Bus1
input         Ch6Arb1Comb;     // Channel6 Selected on Bus1
input         Ch7Arb1Comb;     // Channel7 Selected on Bus1
input         Ch0Arb2Comb;     // Channel0 Selected on Bus2
input         Ch1Arb2Comb;     // Channel1 Selected on Bus2
input         Ch2Arb2Comb;     // Channel2 Selected on Bus2
input         Ch3Arb2Comb;     // Channel3 Selected on Bus2
input         Ch4Arb2Comb;     // Channel4 Selected on Bus2
input         Ch5Arb2Comb;     // Channel5 Selected on Bus2
input         Ch6Arb2Comb;     // Channel6 Selected on Bus2
input         Ch7Arb2Comb;     // Channel7 Selected on Bus2
input  [31:0] Ch0AddrBus1;     // Channel0 Address on Bus1
input  [31:0] Ch1AddrBus1;     // Channel1 Address on Bus1
input  [31:0] Ch2AddrBus1;     // Channel2 Address on Bus1
input  [31:0] Ch3AddrBus1;     // Channel3 Address on Bus1
input  [31:0] Ch4AddrBus1;     // Channel4 Address on Bus1
input  [31:0] Ch5AddrBus1;     // Channel5 Address on Bus1
input  [31:0] Ch6AddrBus1;     // Channel6 Address on Bus1
input  [31:0] Ch7AddrBus1;     // Channel7 Address on Bus1
input  [31:0] Ch0AddrBus2;     // Channel0 Address on Bus2
input  [31:0] Ch1AddrBus2;     // Channel1 Address on Bus2
input  [31:0] Ch2AddrBus2;     // Channel2 Address on Bus2
input  [31:0] Ch3AddrBus2;     // Channel3 Address on Bus2
input  [31:0] Ch4AddrBus2;     // Channel4 Address on Bus2
input  [31:0] Ch5AddrBus2;     // Channel5 Address on Bus2
input  [31:0] Ch6AddrBus2;     // Channel6 Address on Bus2
input  [31:0] Ch7AddrBus2;     // Channel7 Address on Bus2
input   [3:0] Ch0HProtBus1;    // Channel0 HPROT inf on Bus1
input   [3:0] Ch1HProtBus1;    // Channel1 HPROT inf on Bus1
input   [3:0] Ch2HProtBus1;    // Channel2 HPROT inf on Bus1
input   [3:0] Ch3HProtBus1;    // Channel3 HPROT inf on Bus1
input   [3:0] Ch4HProtBus1;    // Channel4 HPROT inf on Bus1
input   [3:0] Ch5HProtBus1;    // Channel5 HPROT inf on Bus1
input   [3:0] Ch6HProtBus1;    // Channel6 HPROT inf on Bus1
input   [3:0] Ch7HProtBus1;    // Channel7 HPROT inf on Bus1
input   [3:0] Ch0HProtBus2;    // Channel0 HPROT inf on Bus2
input   [3:0] Ch1HProtBus2;    // Channel1 HPROT inf on Bus2
input   [3:0] Ch2HProtBus2;    // Channel2 HPROT inf on Bus2
input   [3:0] Ch3HProtBus2;    // Channel3 HPROT inf on Bus2
input   [3:0] Ch4HProtBus2;    // Channel4 HPROT inf on Bus2
input   [3:0] Ch5HProtBus2;    // Channel5 HPROT inf on Bus2
input   [3:0] Ch6HProtBus2;    // Channel6 HPROT inf on Bus2
input   [3:0] Ch7HProtBus2;    // Channel7 HPROT inf on Bus2
input         Ch0HLockBus1;    // Channel0 Lock on Bus1
input         Ch1HLockBus1;    // Channel1 Lock on Bus1
input         Ch2HLockBus1;    // Channel2 Lock on Bus1
input         Ch3HLockBus1;    // Channel3 Lock on Bus1
input         Ch4HLockBus1;    // Channel4 Lock on Bus1
input         Ch5HLockBus1;    // Channel5 Lock on Bus1
input         Ch6HLockBus1;    // Channel6 Lock on Bus1
input         Ch7HLockBus1;    // Channel7 Lock on Bus1
input         Ch0HLockBus2;    // Channel0 Lock on Bus2
input         Ch1HLockBus2;    // Channel1 Lock on Bus2
input         Ch2HLockBus2;    // Channel2 Lock on Bus2
input         Ch3HLockBus2;    // Channel3 Lock on Bus2
input         Ch4HLockBus2;    // Channel4 Lock on Bus2
input         Ch5HLockBus2;    // Channel5 Lock on Bus2
input         Ch6HLockBus2;    // Channel6 Lock on Bus2
input         Ch7HLockBus2;    // Channel7 Lock on Bus2
input         Ch0AddrIncBus1;  // Channel0 Address Incr on Bus1
input         Ch1AddrIncBus1;  // Channel1 Address Incr on Bus1
input         Ch2AddrIncBus1;  // Channel2 Address Incr on Bus1
input         Ch3AddrIncBus1;  // Channel3 Address Incr on Bus1
input         Ch4AddrIncBus1;  // Channel4 Address Incr on Bus1
input         Ch5AddrIncBus1;  // Channel5 Address Incr on Bus1
input         Ch6AddrIncBus1;  // Channel6 Address Incr on Bus1
input         Ch7AddrIncBus1;  // Channel7 Address Incr on Bus1
input         Ch0AddrIncBus2;  // Channel0 Address Incr on Bus2
input         Ch1AddrIncBus2;  // Channel1 Address Incr on Bus2
input         Ch2AddrIncBus2;  // Channel2 Address Incr on Bus2
input         Ch3AddrIncBus2;  // Channel3 Address Incr on Bus2
input         Ch4AddrIncBus2;  // Channel4 Address Incr on Bus2
input         Ch5AddrIncBus2;  // Channel5 Address Incr on Bus2
input         Ch6AddrIncBus2;  // Channel6 Address Incr on Bus2
input         Ch7AddrIncBus2;  // Channel7 Address Incr on Bus2
input         Ch0DisableBus1;  // Channel0 Disable for Bus1
input         Ch1DisableBus1;  // Channel1 Disable for Bus1
input         Ch2DisableBus1;  // Channel2 Disable for Bus1
input         Ch3DisableBus1;  // Channel3 Disable for Bus1
input         Ch4DisableBus1;  // Channel4 Disable for Bus1
input         Ch5DisableBus1;  // Channel5 Disable for Bus1
input         Ch6DisableBus1;  // Channel6 Disable for Bus1
input         Ch7DisableBus1;  // Channel7 Disable for Bus1
input         Ch0DisableBus2;  // Channel0 Disable for Bus2
input         Ch1DisableBus2;  // Channel1 Disable for Bus2
input         Ch2DisableBus2;  // Channel2 Disable for Bus2
input         Ch3DisableBus2;  // Channel3 Disable for Bus2
input         Ch4DisableBus2;  // Channel4 Disable for Bus2
input         Ch5DisableBus2;  // Channel5 Disable for Bus2
input         Ch6DisableBus2;  // Channel6 Disable for Bus2
input         Ch7DisableBus2;  // Channel7 Disable for Bus2
input   [4:0] Ch0BeatCntBus1;  // Channel0 BeatCount for Bus1
input   [4:0] Ch1BeatCntBus1;  // Channel1 BeatCount for Bus1
input   [4:0] Ch2BeatCntBus1;  // Channel2 BeatCount for Bus1
input   [4:0] Ch3BeatCntBus1;  // Channel3 BeatCount for Bus1
input   [4:0] Ch4BeatCntBus1;  // Channel4 BeatCount for Bus1
input   [4:0] Ch5BeatCntBus1;  // Channel5 BeatCount for Bus1
input   [4:0] Ch6BeatCntBus1;  // Channel6 BeatCount for Bus1
input   [4:0] Ch7BeatCntBus1;  // Channel7 BeatCount for Bus1
input   [4:0] Ch0BeatCntBus2;  // Channel0 BeatCount for Bus2
input   [4:0] Ch1BeatCntBus2;  // Channel1 BeatCount for Bus2
input   [4:0] Ch2BeatCntBus2;  // Channel2 BeatCount for Bus2
input   [4:0] Ch3BeatCntBus2;  // Channel3 BeatCount for Bus2
input   [4:0] Ch4BeatCntBus2;  // Channel4 BeatCount for Bus2
input   [4:0] Ch5BeatCntBus2;  // Channel5 BeatCount for Bus2
input   [4:0] Ch6BeatCntBus2;  // Channel6 BeatCount for Bus2
input   [4:0] Ch7BeatCntBus2;  // Channel7 BeatCount for Bus2
input         Ch0WriteBus1;    // Channel0 HWRITE for Bus1
input         Ch1WriteBus1;    // Channel1 HWRITE for Bus1
input         Ch2WriteBus1;    // Channel2 HWRITE for Bus1
input         Ch3WriteBus1;    // Channel3 HWRITE for Bus1
input         Ch4WriteBus1;    // Channel4 HWRITE for Bus1
input         Ch5WriteBus1;    // Channel5 HWRITE for Bus1
input         Ch6WriteBus1;    // Channel6 HWRITE for Bus1
input         Ch7WriteBus1;    // Channel7 HWRITE for Bus1
input         Ch0WriteBus2;    // Channel0 HWRITE for Bus2
input         Ch1WriteBus2;    // Channel1 HWRITE for Bus2
input         Ch2WriteBus2;    // Channel2 HWRITE for Bus2
input         Ch3WriteBus2;    // Channel3 HWRITE for Bus2
input         Ch4WriteBus2;    // Channel4 HWRITE for Bus2
input         Ch5WriteBus2;    // Channel5 HWRITE for Bus2
input         Ch6WriteBus2;    // Channel6 HWRITE for Bus2
input         Ch7WriteBus2;    // Channel7 HWRITE for Bus2
input   [2:0] Ch0HSIZEBus1;    // Channel0 Hsize for Mas1
input   [2:0] Ch1HSIZEBus1;    // Channel1 Hsize for Mas1
input   [2:0] Ch2HSIZEBus1;    // Channel2 Hsize for Mas1
input   [2:0] Ch3HSIZEBus1;    // Channel3 Hsize for Mas1
input   [2:0] Ch4HSIZEBus1;    // Channel4 Hsize for Mas1
input   [2:0] Ch5HSIZEBus1;    // Channel5 Hsize for Mas1
input   [2:0] Ch6HSIZEBus1;    // Channel6 Hsize for Mas1
input   [2:0] Ch7HSIZEBus1;    // Channel7 Hsize for Mas1
input   [2:0] Ch0HSIZEBus2;    // Channel0 Hsize for Mas2
input   [2:0] Ch1HSIZEBus2;    // Channel1 Hsize for Mas2
input   [2:0] Ch2HSIZEBus2;    // Channel2 Hsize for Mas2
input   [2:0] Ch3HSIZEBus2;    // Channel3 Hsize for Mas2
input   [2:0] Ch4HSIZEBus2;    // Channel4 Hsize for Mas2
input   [2:0] Ch5HSIZEBus2;    // Channel5 Hsize for Mas2
input   [2:0] Ch6HSIZEBus2;    // Channel6 Hsize for Mas2
input   [2:0] Ch7HSIZEBus2;    // Channel7 Hsize for Mas2
input         StopArb1;        // Stop Arbitration from Mas1
input         StopArb2;        // Stop Arbitration from Mas2
input  [15:0] Ch0SOFTCLR;      // Channel0 SoftReq Clear Generation
input  [15:0] Ch1SOFTCLR;      // Channel1 SoftClear Generation
input  [15:0] Ch2SOFTCLR;      // Channel2 SoftClear Generation
input  [15:0] Ch3SOFTCLR;      // Channel3 SoftClear Generation
input  [15:0] Ch4SOFTCLR;      // Channel4 SoftClear Generation
input  [15:0] Ch5SOFTCLR;      // Channel5 SoftClear Generation
input  [15:0] Ch6SOFTCLR;      // Channel6 SoftClear Generation
input  [15:0] Ch7SOFTCLR;      // Channel7 SoftClear Generation
input  [15:0] Ch0DMACTC;       // Channel0 TC Generation
input  [15:0] Ch1DMACTC;       // Channel1 TC Generation
input  [15:0] Ch2DMACTC;       // Channel2 TC Generation
input  [15:0] Ch3DMACTC;       // Channel3 TC Generation
input  [15:0] Ch4DMACTC;       // Channel4 TC Generation
input  [15:0] Ch5DMACTC;       // Channel5 TC Generation
input  [15:0] Ch6DMACTC;       // Channel6 TC Generation
input  [15:0] Ch7DMACTC;       // Channel7 TC Generation
input  [15:0] Ch0DMACCLR;      // Channel0 Clear Generation
input  [15:0] Ch1DMACCLR;      // Channel1 Clear Generation
input  [15:0] Ch2DMACCLR;      // Channel2 Clear Generation
input  [15:0] Ch3DMACCLR;      // Channel3 Clear Generation
input  [15:0] Ch4DMACCLR;      // Channel4 Clear Generation
input  [15:0] Ch5DMACCLR;      // Channel5 Clear Generation
input  [15:0] Ch6DMACCLR;      // Channel6 Clear Generation
input  [15:0] Ch7DMACCLR;      // Channel7 Clear Generation

// Outputs
output        ChHLOCKBus1;     // HLOCK for Bus1
output        ChHLOCKBus2;     // HLOCK for Bus2
output        ChWRITEBus1;     // HWRITE for Bus1
output        ChWRITEBus2;     // HWRITE for Bus2
output        ChAddrIncrBus1;  // Channel Addr Increment for Bus1
output        ChAddrIncrBus2;  // Channel Addr Increment for Bus2
output        ChDisableBus1;   // Channel disable for Mas1
output        ChDisableBus2;   // Channel disable for Bus2
output        ChPriorityBus1;  // Channel priority for Mas1
output        ChPriorityBus2;  // Channel priority for Mas2
output  [3:0] ChHProtBus1;     // HPROT for Bus1
output  [3:0] ChHProtBus2;     // HPROT for Bus2
output  [2:0] ChHSIZEBus1;     // HSIZE for Bus1
output  [2:0] ChHSIZEBus2;     // HSIZE for Bus2
output [31:0] ChAddrBus1;      // Channel Address for Bus1
output [31:0] ChAddrBus2;      // Channel Address for Bus2
output  [4:0] ChBeatCountBus1; // BeatCount for Mas1
output  [4:0] ChBeatCountBus2; // BeatCount for Mas2
output [15:0] SOFTCLR;         // DMAC SoftReq Clear
output [15:0] DMACCLR;         // DMAC Clear
output [15:0] DMACTC;          // DMAC TC




// Inputs
  wire        HCLK;            // AHB Clock
  wire        HRESETn;         // AHB Reset
  wire        Ch0Arb1Comb;     // Channel0 Selected on Bus1
  wire        Ch1Arb1Comb;     // Channel1 Selected on Bus1
  wire        Ch2Arb1Comb;     // Channel2 Selected on Bus1
  wire        Ch3Arb1Comb;     // Channel3 Selected on Bus1
  wire        Ch4Arb1Comb;     // Channel4 Selected on Bus1
  wire        Ch5Arb1Comb;     // Channel5 Selected on Bus1
  wire        Ch6Arb1Comb;     // Channel6 Selected on Bus1
  wire        Ch7Arb1Comb;     // Channel7 Selected on Bus1
  wire        Ch0Arb2Comb;     // Channel0 Selected on Bus2
  wire        Ch1Arb2Comb;     // Channel1 Selected on Bus2
  wire        Ch2Arb2Comb;     // Channel2 Selected on Bus2
  wire        Ch3Arb2Comb;     // Channel3 Selected on Bus2
  wire        Ch4Arb2Comb;     // Channel4 Selected on Bus2
  wire        Ch5Arb2Comb;     // Channel5 Selected on Bus2
  wire        Ch6Arb2Comb;     // Channel6 Selected on Bus2
  wire        Ch7Arb2Comb;     // Channel7 Selected on Bus2
  wire [31:0] Ch0AddrBus1;     // Channel0 Address on Bus1
  wire [31:0] Ch1AddrBus1;     // Channel1 Address on Bus1
  wire [31:0] Ch2AddrBus1;     // Channel2 Address on Bus1
  wire [31:0] Ch3AddrBus1;     // Channel3 Address on Bus1
  wire [31:0] Ch4AddrBus1;     // Channel4 Address on Bus1
  wire [31:0] Ch5AddrBus1;     // Channel5 Address on Bus1
  wire [31:0] Ch6AddrBus1;     // Channel6 Address on Bus1
  wire [31:0] Ch7AddrBus1;     // Channel7 Address on Bus1
  wire [31:0] Ch0AddrBus2;     // Channel0 Address on Bus2
  wire [31:0] Ch1AddrBus2;     // Channel1 Address on Bus2
  wire [31:0] Ch2AddrBus2;     // Channel2 Address on Bus2
  wire [31:0] Ch3AddrBus2;     // Channel3 Address on Bus2
  wire [31:0] Ch4AddrBus2;     // Channel4 Address on Bus2
  wire [31:0] Ch5AddrBus2;     // Channel5 Address on Bus2
  wire [31:0] Ch6AddrBus2;     // Channel6 Address on Bus2
  wire [31:0] Ch7AddrBus2;     // Channel7 Address on Bus2
  wire  [3:0] Ch0HProtBus1;    // Channel0 HPROT inf on Bus1
  wire  [3:0] Ch1HProtBus1;    // Channel1 HPROT inf on Bus1
  wire  [3:0] Ch2HProtBus1;    // Channel2 HPROT inf on Bus1
  wire  [3:0] Ch3HProtBus1;    // Channel3 HPROT inf on Bus1
  wire  [3:0] Ch4HProtBus1;    // Channel4 HPROT inf on Bus1
  wire  [3:0] Ch5HProtBus1;    // Channel5 HPROT inf on Bus1
  wire  [3:0] Ch6HProtBus1;    // Channel6 HPROT inf on Bus1
  wire  [3:0] Ch7HProtBus1;    // Channel7 HPROT inf on Bus1
  wire  [3:0] Ch0HProtBus2;    // Channel0 HPROT inf on Bus2
  wire  [3:0] Ch1HProtBus2;    // Channel1 HPROT inf on Bus2
  wire  [3:0] Ch2HProtBus2;    // Channel2 HPROT inf on Bus2
  wire  [3:0] Ch3HProtBus2;    // Channel3 HPROT inf on Bus2
  wire  [3:0] Ch4HProtBus2;    // Channel4 HPROT inf on Bus2
  wire  [3:0] Ch5HProtBus2;    // Channel5 HPROT inf on Bus2
  wire  [3:0] Ch6HProtBus2;    // Channel6 HPROT inf on Bus2
  wire  [3:0] Ch7HProtBus2;    // Channel7 HPROT inf on Bus2
  wire        Ch0HLockBus1;    // Channel0 Lock on Bus1
  wire        Ch1HLockBus1;    // Channel1 Lock on Bus1
  wire        Ch2HLockBus1;    // Channel2 Lock on Bus1
  wire        Ch3HLockBus1;    // Channel3 Lock on Bus1
  wire        Ch4HLockBus1;    // Channel4 Lock on Bus1
  wire        Ch5HLockBus1;    // Channel5 Lock on Bus1
  wire        Ch6HLockBus1;    // Channel6 Lock on Bus1
  wire        Ch7HLockBus1;    // Channel7 Lock on Bus1
  wire        Ch0HLockBus2;    // Channel0 Lock on Bus2
  wire        Ch1HLockBus2;    // Channel1 Lock on Bus2
  wire        Ch2HLockBus2;    // Channel2 Lock on Bus2
  wire        Ch3HLockBus2;    // Channel3 Lock on Bus2
  wire        Ch4HLockBus2;    // Channel4 Lock on Bus2
  wire        Ch5HLockBus2;    // Channel5 Lock on Bus2
  wire        Ch6HLockBus2;    // Channel6 Lock on Bus2
  wire        Ch7HLockBus2;    // Channel7 Lock on Bus2
  wire        Ch0AddrIncBus1;  // Channel0 Address Incr on Bus1
  wire        Ch1AddrIncBus1;  // Channel1 Address Incr on Bus1
  wire        Ch2AddrIncBus1;  // Channel2 Address Incr on Bus1
  wire        Ch3AddrIncBus1;  // Channel3 Address Incr on Bus1
  wire        Ch4AddrIncBus1;  // Channel4 Address Incr on Bus1
  wire        Ch5AddrIncBus1;  // Channel5 Address Incr on Bus1
  wire        Ch6AddrIncBus1;  // Channel6 Address Incr on Bus1
  wire        Ch7AddrIncBus1;  // Channel7 Address Incr on Bus1
  wire        Ch0AddrIncBus2;  // Channel0 Address Incr on Bus2
  wire        Ch1AddrIncBus2;  // Channel1 Address Incr on Bus2
  wire        Ch2AddrIncBus2;  // Channel2 Address Incr on Bus2
  wire        Ch3AddrIncBus2;  // Channel3 Address Incr on Bus2
  wire        Ch4AddrIncBus2;  // Channel4 Address Incr on Bus2
  wire        Ch5AddrIncBus2;  // Channel5 Address Incr on Bus2
  wire        Ch6AddrIncBus2;  // Channel6 Address Incr on Bus2
  wire        Ch7AddrIncBus2;  // Channel7 Address Incr on Bus2
  wire        Ch0DisableBus1;  // Channel0 Disable for Bus1
  wire        Ch1DisableBus1;  // Channel1 Disable for Bus1
  wire        Ch2DisableBus1;  // Channel2 Disable for Bus1
  wire        Ch3DisableBus1;  // Channel3 Disable for Bus1
  wire        Ch4DisableBus1;  // Channel4 Disable for Bus1
  wire        Ch5DisableBus1;  // Channel5 Disable for Bus1
  wire        Ch6DisableBus1;  // Channel6 Disable for Bus1
  wire        Ch7DisableBus1;  // Channel7 Disable for Bus1
  wire        Ch0DisableBus2;  // Channel0 Disable for Bus2
  wire        Ch1DisableBus2;  // Channel1 Disable for Bus2
  wire        Ch2DisableBus2;  // Channel2 Disable for Bus2
  wire        Ch3DisableBus2;  // Channel3 Disable for Bus2
  wire        Ch4DisableBus2;  // Channel4 Disable for Bus2
  wire        Ch5DisableBus2;  // Channel5 Disable for Bus2
  wire        Ch6DisableBus2;  // Channel6 Disable for Bus2
  wire        Ch7DisableBus2;  // Channel7 Disable for Bus2
  wire  [4:0] Ch0BeatCntBus1;  // Channel0 BeatCount for Bus1
  wire  [4:0] Ch1BeatCntBus1;  // Channel1 BeatCount for Bus1
  wire  [4:0] Ch2BeatCntBus1;  // Channel2 BeatCount for Bus1
  wire  [4:0] Ch3BeatCntBus1;  // Channel3 BeatCount for Bus1
  wire  [4:0] Ch4BeatCntBus1;  // Channel4 BeatCount for Bus1
  wire  [4:0] Ch5BeatCntBus1;  // Channel5 BeatCount for Bus1
  wire  [4:0] Ch6BeatCntBus1;  // Channel6 BeatCount for Bus1
  wire  [4:0] Ch7BeatCntBus1;  // Channel7 BeatCount for Bus1
  wire  [4:0] Ch0BeatCntBus2;  // Channel0 BeatCount for Bus2
  wire  [4:0] Ch1BeatCntBus2;  // Channel1 BeatCount for Bus2
  wire  [4:0] Ch2BeatCntBus2;  // Channel2 BeatCount for Bus2
  wire  [4:0] Ch3BeatCntBus2;  // Channel3 BeatCount for Bus2
  wire  [4:0] Ch4BeatCntBus2;  // Channel4 BeatCount for Bus2
  wire  [4:0] Ch5BeatCntBus2;  // Channel5 BeatCount for Bus2
  wire  [4:0] Ch6BeatCntBus2;  // Channel6 BeatCount for Bus2
  wire  [4:0] Ch7BeatCntBus2;  // Channel7 BeatCount for Bus2
  wire        Ch0WriteBus1;    // Channel0 HWRITE for Bus1
  wire        Ch1WriteBus1;    // Channel1 HWRITE for Bus1
  wire        Ch2WriteBus1;    // Channel2 HWRITE for Bus1
  wire        Ch3WriteBus1;    // Channel3 HWRITE for Bus1
  wire        Ch4WriteBus1;    // Channel4 HWRITE for Bus1
  wire        Ch5WriteBus1;    // Channel5 HWRITE for Bus1
  wire        Ch6WriteBus1;    // Channel6 HWRITE for Bus1
  wire        Ch7WriteBus1;    // Channel7 HWRITE for Bus1
  wire        Ch0WriteBus2;    // Channel0 HWRITE for Bus2
  wire        Ch1WriteBus2;    // Channel1 HWRITE for Bus2
  wire        Ch2WriteBus2;    // Channel2 HWRITE for Bus2
  wire        Ch3WriteBus2;    // Channel3 HWRITE for Bus2
  wire        Ch4WriteBus2;    // Channel4 HWRITE for Bus2
  wire        Ch5WriteBus2;    // Channel5 HWRITE for Bus2
  wire        Ch6WriteBus2;    // Channel6 HWRITE for Bus2
  wire        Ch7WriteBus2;    // Channel7 HWRITE for Bus2
  wire  [2:0] Ch0HSIZEBus1;    // Channel0 Hsize for Mas1
  wire  [2:0] Ch1HSIZEBus1;    // Channel1 Hsize for Mas1
  wire  [2:0] Ch2HSIZEBus1;    // Channel2 Hsize for Mas1
  wire  [2:0] Ch3HSIZEBus1;    // Channel3 Hsize for Mas1
  wire  [2:0] Ch4HSIZEBus1;    // Channel4 Hsize for Mas1
  wire  [2:0] Ch5HSIZEBus1;    // Channel5 Hsize for Mas1
  wire  [2:0] Ch6HSIZEBus1;    // Channel6 Hsize for Mas1
  wire  [2:0] Ch7HSIZEBus1;    // Channel7 Hsize for Mas1
  wire  [2:0] Ch0HSIZEBus2;    // Channel0 Hsize for Mas2
  wire  [2:0] Ch1HSIZEBus2;    // Channel1 Hsize for Mas2
  wire  [2:0] Ch2HSIZEBus2;    // Channel2 Hsize for Mas2
  wire  [2:0] Ch3HSIZEBus2;    // Channel3 Hsize for Mas2
  wire  [2:0] Ch4HSIZEBus2;    // Channel4 Hsize for Mas2
  wire  [2:0] Ch5HSIZEBus2;    // Channel5 Hsize for Mas2
  wire  [2:0] Ch6HSIZEBus2;    // Channel6 Hsize for Mas2
  wire  [2:0] Ch7HSIZEBus2;    // Channel7 Hsize for Mas2
  wire        StopArb1;        // Stop Arbitration from Mas1
  wire        StopArb2;        // Stop Arbitration from Mas2
  wire [15:0] Ch0SOFTCLR;      // Channel0 SoftReq Clear Generation
  wire [15:0] Ch1SOFTCLR;      // Channel1 SoftClear Generation
  wire [15:0] Ch2SOFTCLR;      // Channel2 SoftClear Generation
  wire [15:0] Ch3SOFTCLR;      // Channel3 SoftClear Generation
  wire [15:0] Ch4SOFTCLR;      // Channel4 SoftClear Generation
  wire [15:0] Ch5SOFTCLR;      // Channel5 SoftClear Generation
  wire [15:0] Ch6SOFTCLR;      // Channel6 SoftClear Generation
  wire [15:0] Ch7SOFTCLR;      // Channel7 SoftClear Generation
  wire [15:0] Ch0DMACTC;       // Channel0 TC Generation
  wire [15:0] Ch1DMACTC;       // Channel1 TC Generation
  wire [15:0] Ch2DMACTC;       // Channel2 TC Generation
  wire [15:0] Ch3DMACTC;       // Channel3 TC Generation
  wire [15:0] Ch4DMACTC;       // Channel4 TC Generation
  wire [15:0] Ch5DMACTC;       // Channel5 TC Generation
  wire [15:0] Ch6DMACTC;       // Channel6 TC Generation
  wire [15:0] Ch7DMACTC;       // Channel7 TC Generation
  wire [15:0] Ch0DMACCLR;      // Channel0 Clear Generation
  wire [15:0] Ch1DMACCLR;      // Channel1 Clear Generation
  wire [15:0] Ch2DMACCLR;      // Channel2 Clear Generation
  wire [15:0] Ch3DMACCLR;      // Channel3 Clear Generation
  wire [15:0] Ch4DMACCLR;      // Channel4 Clear Generation
  wire [15:0] Ch5DMACCLR;      // Channel5 Clear Generation
  wire [15:0] Ch6DMACCLR;      // Channel6 Clear Generation
  wire [15:0] Ch7DMACCLR;      // Channel7 Clear Generation

// Outputs
  wire        ChHLOCKBus1;     // HLOCK for Bus1
  wire        ChHLOCKBus2;     // HLOCK for Bus2
  wire        ChWRITEBus1;     // HWRITE for Bus1
  wire        ChWRITEBus2;     // HWRITE for Bus2
  wire        ChAddrIncrBus1;  // Channel Addr Increment for Bus1
  wire        ChAddrIncrBus2;  // Channel Addr Increment for Bus2
  wire        ChDisableBus1;   // Channel disable for Mas1
  wire        ChDisableBus2;   // Channel disable for Bus2
  wire        ChPriorityBus1;  // Channel priority for Mas1
  wire        ChPriorityBus2;  // Channel priority for Mas2
  wire  [3:0] ChHProtBus1;     // HPROT for Bus1
  wire  [3:0] ChHProtBus2;     // HPROT for Bus2
  wire  [2:0] ChHSIZEBus1;     // HSIZE for Bus1
  wire  [2:0] ChHSIZEBus2;     // HSIZE for Bus2
  wire [31:0] ChAddrBus1;      // Channel Address for Bus1
  wire [31:0] ChAddrBus2;      // Channel Address for Bus2
  wire  [4:0] ChBeatCountBus1; // BeatCount for Mas1
  wire  [4:0] ChBeatCountBus2; // BeatCount for Mas2
  reg  [15:0] SOFTCLR;         // DMAC SoftReq Clear
  reg  [15:0] DMACCLR;         // DMAC Clear
  reg  [15:0] DMACTC;          // DMAC TC


// -----------------------------------------------------------------------------
//
//                                DmacTrRouter
//                                ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module is responsible for routing the Channel resources on to Bus and
// Vice-Versa. The routing of resources happens when 1HCLK Comb pulse for each
// Channel(From Internal Arbiter) is active. In this module some of the Channel
// resources are registered, so that AHB Master can need not register it.
// These registered contents are flushed when StopArb is sampled low.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         ChHLOCKBus1Reg;
// Registered HLOCK information from channel

reg         NextChHLOCKBus1;
// D-Input of ChHLOCKBus1Reg

reg         CombChHLOCKBus1;
// Signal active for 1 HCLK wide

reg         ChWRITEBus1Reg;
// Registered WRITE information from channel

reg         NextChWRITEBus1;
// D-Input of ChWRITEBus1Reg

reg         CombChWRITEBus1;
// Signal active for 1 HCLK wide

reg         AddrIncBus1Reg;
// Registered AddrIncr information from channel

reg         NextAddrIncBus1;
// D-Input of AddrIncBus1Reg

reg         CombAddrIncBus1;
// Signal active for 1 HCLK wide

reg   [3:0] ChHProtBus1Reg;
// Registered HPROT information from channel

reg   [3:0] NextChHProtBus1;
// D-Input of ChHProtBus1Reg

reg   [3:0] CombChHProtBus1;
// Signal active for 1 HCLK wide

reg         PriBus1Reg;
// Registered Channel priority information from channel

reg         NextPriBus1;
// D-Input of PriBus1Reg

reg         CombPriBus1;
// Signal active for 1 HCLK wide

reg   [2:0] ChHSIZEBus1Reg;
// Registered HSIZE information from channel

reg   [2:0] NextChHSIZEBus1;
// D-Input of ChHSIZEBus1Reg

reg   [2:0] CombChHSIZEBus1;
// Signal active for 1 HCLK wide

reg  [31:0] ChAddrBus1Reg;
// Registered Address information from channel

reg  [31:0] NextChAddrBus1;
// D-Input of ChAddrBus1Reg

reg  [31:0] CombChAddrBus1;
// Signal active for 1 HCLK wide

reg   [4:0] BeatCntBus1Reg;
// Registered BeatCount information from channel

reg   [4:0] NextBeatCntBus1;
// D-Input of BeatCntBus1Reg

reg   [4:0] CombBeatCntBus1;
// Signal active for 1 HCLK wide

reg         ChHLOCKBus2Reg;
// Registered HLOCK information from channel

reg         NextChHLOCKBus2;
// D-Input of ChHLOCKBus2Reg

reg         CombChHLOCKBus2;
// Signal active for 1 HCLK wide

reg         ChWRITEBus2Reg;
// Registered WRITE information from channel

reg         NextChWRITEBus2;
// D-Input of ChWRITEBus2Reg

reg         CombChWRITEBus2;
// Signal active for 1 HCLK wide

reg         AddrIncBus2Reg;
// Registered AddrIncr information from channel

reg         NextAddrIncBus2;
// D-Input of AddrIncBus2Reg

reg         CombAddrIncBus2;
// Signal active for 1 HCLK wide

reg   [3:0] ChHProtBus2Reg;
// Registered HPROT information from channel

reg   [3:0] NextChHProtBus2;
// D-Input of ChHProtBus2Reg

reg   [3:0] CombChHProtBus2;
// Signal active for 1 HCLK wide

reg         PriBus2Reg;
// Registered Channel priority information from channel

reg         NextPriBus2;
// D-Input of PriBus2Reg

reg         CombPriBus2;
// Signal active for 1 HCLK wide

reg   [2:0] ChHSIZEBus2Reg;
// Registered HSIZE information from channel

reg   [2:0] NextChHSIZEBus2;
// D-Input of ChHSIZEBus2Reg

reg   [2:0] CombChHSIZEBus2;
// Signal active for 1 HCLK wide

reg  [31:0] ChAddrBus2Reg;
// Registered Address information from channel

reg  [31:0] NextChAddrBus2;
// D-Input of ChAddrBus2Reg

reg  [31:0] CombChAddrBus2;
// Signal active for 1 HCLK wide

reg   [4:0] BeatCntBus2Reg;
// Registered BeatCount information from channel

reg   [4:0] NextBeatCntBus2;
// D-Input of BeatCntBus2Reg

reg   [4:0] CombBeatCntBus2;
// Signal active for 1 HCLK wide

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
// Assigning internal signals to the outputs
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Logic to Route Channel resources to BUS1
// -----------------------------------------------------------------------------
always @(Ch0Arb1Comb or Ch0HLockBus1 or Ch0WriteBus1 or Ch0AddrIncBus1 or
         Ch0HProtBus1 or Ch0HSIZEBus1 or Ch0AddrBus1 or Ch0BeatCntBus1 or
         Ch1Arb1Comb or Ch1HLockBus1 or Ch1WriteBus1 or Ch1AddrIncBus1 or
         Ch1HProtBus1 or Ch1HSIZEBus1 or Ch1AddrBus1 or Ch1BeatCntBus1 or
         Ch2Arb1Comb or Ch2HLockBus1 or Ch2WriteBus1 or Ch2AddrIncBus1 or
         Ch2HProtBus1 or Ch2HSIZEBus1 or Ch2AddrBus1 or Ch2BeatCntBus1 or
         Ch3Arb1Comb or Ch3HLockBus1 or Ch3WriteBus1 or Ch3AddrIncBus1 or
         Ch3HProtBus1 or Ch3HSIZEBus1 or Ch3AddrBus1 or Ch3BeatCntBus1 or
         Ch4Arb1Comb or Ch4HLockBus1 or Ch4WriteBus1 or Ch4AddrIncBus1 or
         Ch4HProtBus1 or Ch4HSIZEBus1 or Ch4AddrBus1 or Ch4BeatCntBus1 or
         Ch5Arb1Comb or Ch5HLockBus1 or Ch5WriteBus1 or Ch5AddrIncBus1 or
         Ch5HProtBus1 or Ch5HSIZEBus1 or Ch5AddrBus1 or Ch5BeatCntBus1 or
         Ch6Arb1Comb or Ch6HLockBus1 or Ch6WriteBus1 or Ch6AddrIncBus1 or
         Ch6HProtBus1 or Ch6HSIZEBus1 or Ch6AddrBus1 or Ch6BeatCntBus1 or
         Ch7Arb1Comb or Ch7HLockBus1 or Ch7WriteBus1 or Ch7AddrIncBus1 or
         Ch7HProtBus1 or Ch7HSIZEBus1 or Ch7AddrBus1 or Ch7BeatCntBus1)
begin : p_Bus1RouteComb
  CombChHLOCKBus1  = 1'b0;
  CombChWRITEBus1  = 1'b0;
  CombAddrIncBus1  = 1'b0;
  CombPriBus1      = 1'b0;
  CombChHProtBus1  = ('d0);
  CombChHSIZEBus1  = ('d0);
  CombChAddrBus1   = ('d0);
  CombBeatCntBus1  = ('d0);
  if (Ch0Arb1Comb == 1'b1)
    begin
      CombChHLOCKBus1  = Ch0HLockBus1;
      CombChWRITEBus1  = Ch0WriteBus1;
      CombAddrIncBus1  = Ch0AddrIncBus1;
      CombPriBus1      = 1'b1;
      CombChHProtBus1  = Ch0HProtBus1;
      CombChHSIZEBus1  = Ch0HSIZEBus1;
      CombChAddrBus1   = Ch0AddrBus1;
      CombBeatCntBus1  = Ch0BeatCntBus1;
    end
  if (Ch1Arb1Comb == 1'b1)
    begin
      CombChHLOCKBus1  = Ch1HLockBus1;
      CombChWRITEBus1  = Ch1WriteBus1;
      CombAddrIncBus1  = Ch1AddrIncBus1;
      CombPriBus1      = 0;
    // This change has been done for 2 channel configuration DMAC variant
    // Where channel 1 is having low priority than channel 0
      CombChHProtBus1  = Ch1HProtBus1;
      CombChHSIZEBus1  = Ch1HSIZEBus1;
      CombChAddrBus1   = Ch1AddrBus1;
      CombBeatCntBus1  = Ch1BeatCntBus1;
    end
  if (Ch2Arb1Comb == 1'b1)
    begin
      CombChHLOCKBus1  = Ch2HLockBus1;
      CombChWRITEBus1  = Ch2WriteBus1;
      CombAddrIncBus1  = Ch2AddrIncBus1;
      CombPriBus1      = 1'b1;
      CombChHProtBus1  = Ch2HProtBus1;
      CombChHSIZEBus1  = Ch2HSIZEBus1;
      CombChAddrBus1   = Ch2AddrBus1;
      CombBeatCntBus1  = Ch2BeatCntBus1;
    end
  if (Ch3Arb1Comb == 1'b1)
    begin
      CombChHLOCKBus1  = Ch3HLockBus1;
      CombChWRITEBus1  = Ch3WriteBus1;
      CombAddrIncBus1  = Ch3AddrIncBus1;
      CombPriBus1      = 1'b1;
      CombChHProtBus1  = Ch3HProtBus1;
      CombChHSIZEBus1  = Ch3HSIZEBus1;
      CombChAddrBus1   = Ch3AddrBus1;
      CombBeatCntBus1  = Ch3BeatCntBus1;
    end
  if (Ch4Arb1Comb == 1'b1)
    begin
      CombChHLOCKBus1  = Ch4HLockBus1;
      CombChWRITEBus1  = Ch4WriteBus1;
      CombAddrIncBus1  = Ch4AddrIncBus1;
      CombPriBus1      = 1'b1;
      CombChHProtBus1  = Ch4HProtBus1;
      CombChHSIZEBus1  = Ch4HSIZEBus1;
      CombChAddrBus1   = Ch4AddrBus1;
      CombBeatCntBus1  = Ch4BeatCntBus1;
    end
  if (Ch5Arb1Comb == 1'b1)
    begin
      CombChHLOCKBus1  = Ch5HLockBus1;
      CombChWRITEBus1  = Ch5WriteBus1;
      CombAddrIncBus1  = Ch5AddrIncBus1;
      CombPriBus1      = 1'b1;
      CombChHProtBus1  = Ch5HProtBus1;
      CombChHSIZEBus1  = Ch5HSIZEBus1;
      CombChAddrBus1   = Ch5AddrBus1;
      CombBeatCntBus1  = Ch5BeatCntBus1;
    end
  if (Ch6Arb1Comb == 1'b1)
    begin
      CombChHLOCKBus1  = Ch6HLockBus1;
      CombChWRITEBus1  = Ch6WriteBus1;
      CombAddrIncBus1  = Ch6AddrIncBus1;
      CombPriBus1      = 1'b0;
      CombChHProtBus1  = Ch6HProtBus1;
      CombChHSIZEBus1  = Ch6HSIZEBus1;
      CombChAddrBus1   = Ch6AddrBus1;
      CombBeatCntBus1  = Ch6BeatCntBus1;
    end
  if (Ch7Arb1Comb == 1'b1)
    begin
      CombChHLOCKBus1  = Ch7HLockBus1;
      CombChWRITEBus1  = Ch7WriteBus1;
      CombAddrIncBus1  = Ch7AddrIncBus1;
      CombPriBus1      = 1'b0;
      CombChHProtBus1  = Ch7HProtBus1;
      CombChHSIZEBus1  = Ch7HSIZEBus1;
      CombChAddrBus1   = Ch7AddrBus1;
      CombBeatCntBus1  = Ch7BeatCntBus1;
    end
end // p_Bus1RouteComb

// -----------------------------------------------------------------------------
// Logic to Route Channel resources to BUS2
// -----------------------------------------------------------------------------
always @(Ch0Arb2Comb or Ch0HLockBus2 or Ch0WriteBus2 or Ch0AddrIncBus2 or
         Ch0HProtBus2 or Ch0HSIZEBus2 or Ch0AddrBus2 or Ch0BeatCntBus2 or
         Ch1Arb2Comb or Ch1HLockBus2 or Ch1WriteBus2 or Ch1AddrIncBus2 or
         Ch1HProtBus2 or Ch1HSIZEBus2 or Ch1AddrBus2 or Ch1BeatCntBus2 or
         Ch2Arb2Comb or Ch2HLockBus2 or Ch2WriteBus2 or Ch2AddrIncBus2 or
         Ch2HProtBus2 or Ch2HSIZEBus2 or Ch2AddrBus2 or Ch2BeatCntBus2 or
         Ch3Arb2Comb or Ch3HLockBus2 or Ch3WriteBus2 or Ch3AddrIncBus2 or
         Ch3HProtBus2 or Ch3HSIZEBus2 or Ch3AddrBus2 or Ch3BeatCntBus2 or
         Ch4Arb2Comb or Ch4HLockBus2 or Ch4WriteBus2 or Ch4AddrIncBus2 or
         Ch4HProtBus2 or Ch4HSIZEBus2 or Ch4AddrBus2 or Ch4BeatCntBus2 or
         Ch5Arb2Comb or Ch5HLockBus2 or Ch5WriteBus2 or Ch5AddrIncBus2 or
         Ch5HProtBus2 or Ch5HSIZEBus2 or Ch5AddrBus2 or Ch5BeatCntBus2 or
         Ch6Arb2Comb or Ch6HLockBus2 or Ch6WriteBus2 or Ch6AddrIncBus2 or
         Ch6HProtBus2 or Ch6HSIZEBus2 or Ch6AddrBus2 or Ch6BeatCntBus2 or
         Ch7Arb2Comb or Ch7HLockBus2 or Ch7WriteBus2 or Ch7AddrIncBus2 or
         Ch7HProtBus2 or Ch7HSIZEBus2 or Ch7AddrBus2 or Ch7BeatCntBus2)
begin : p_Bus2RouteComb
  CombChHLOCKBus2  = 1'b0;
  CombChWRITEBus2  = 1'b0;
  CombAddrIncBus2  = 1'b0;
  CombPriBus2      = 1'b0;
  CombChHProtBus2  = ('d0);
  CombChHSIZEBus2  = ('d0);
  CombChAddrBus2   = ('d0);
  CombBeatCntBus2  = ('d0);
  if (Ch0Arb2Comb == 1'b1)
    begin
      CombChHLOCKBus2  = Ch0HLockBus2;
      CombChWRITEBus2  = Ch0WriteBus2;
      CombAddrIncBus2  = Ch0AddrIncBus2;
      CombPriBus2      = 1'b1;
      CombChHProtBus2  = Ch0HProtBus2;
      CombChHSIZEBus2  = Ch0HSIZEBus2;
      CombChAddrBus2   = Ch0AddrBus2;
      CombBeatCntBus2  = Ch0BeatCntBus2;
    end
  if (Ch1Arb2Comb == 1'b1)
    begin
      CombChHLOCKBus2  = Ch1HLockBus2;
      CombChWRITEBus2  = Ch1WriteBus2;
      CombAddrIncBus2  = Ch1AddrIncBus2;
      CombPriBus2      = 0;
    // This change has been done for 2 channel configuration DMAC variant
    // Where channel 1 is having low priority than channel 0
      CombChHProtBus2  = Ch1HProtBus2;
      CombChHSIZEBus2  = Ch1HSIZEBus2;
      CombChAddrBus2   = Ch1AddrBus2;
      CombBeatCntBus2  = Ch1BeatCntBus2;
    end
  if (Ch2Arb2Comb == 1'b1)
    begin
      CombChHLOCKBus2  = Ch2HLockBus2;
      CombChWRITEBus2  = Ch2WriteBus2;
      CombAddrIncBus2  = Ch2AddrIncBus2;
      CombPriBus2      = 1'b1;
      CombChHProtBus2  = Ch2HProtBus2;
      CombChHSIZEBus2  = Ch2HSIZEBus2;
      CombChAddrBus2   = Ch2AddrBus2;
      CombBeatCntBus2  = Ch2BeatCntBus2;
    end
  if (Ch3Arb2Comb == 1'b1)
    begin
      CombChHLOCKBus2  = Ch3HLockBus2;
      CombChWRITEBus2  = Ch3WriteBus2;
      CombAddrIncBus2  = Ch3AddrIncBus2;
      CombPriBus2      = 1'b1;
      CombChHProtBus2  = Ch3HProtBus2;
      CombChHSIZEBus2  = Ch3HSIZEBus2;
      CombChAddrBus2   = Ch3AddrBus2;
      CombBeatCntBus2  = Ch3BeatCntBus2;
    end
  if (Ch4Arb2Comb == 1'b1)
    begin
      CombChHLOCKBus2  = Ch4HLockBus2;
      CombChWRITEBus2  = Ch4WriteBus2;
      CombAddrIncBus2  = Ch4AddrIncBus2;
      CombPriBus2      = 1'b1;
      CombChHProtBus2  = Ch4HProtBus2;
      CombChHSIZEBus2  = Ch4HSIZEBus2;
      CombChAddrBus2   = Ch4AddrBus2;
      CombBeatCntBus2  = Ch4BeatCntBus2;
    end
  if (Ch5Arb2Comb == 1'b1)
    begin
      CombChHLOCKBus2  = Ch5HLockBus2;
      CombChWRITEBus2  = Ch5WriteBus2;
      CombAddrIncBus2  = Ch5AddrIncBus2;
      CombPriBus2      = 1'b1;
      CombChHProtBus2  = Ch5HProtBus2;
      CombChHSIZEBus2  = Ch5HSIZEBus2;
      CombChAddrBus2   = Ch5AddrBus2;
      CombBeatCntBus2  = Ch5BeatCntBus2;
    end
  if (Ch6Arb2Comb == 1'b1)
    begin
      CombChHLOCKBus2  = Ch6HLockBus2;
      CombChWRITEBus2  = Ch6WriteBus2;
      CombAddrIncBus2  = Ch6AddrIncBus2;
      CombPriBus2      = 1'b0;
      CombChHProtBus2  = Ch6HProtBus2;
      CombChHSIZEBus2  = Ch6HSIZEBus2;
      CombChAddrBus2   = Ch6AddrBus2;
      CombBeatCntBus2  = Ch6BeatCntBus2;
    end
  if (Ch7Arb2Comb == 1'b1)
    begin
      CombChHLOCKBus2  = Ch7HLockBus2;
      CombChWRITEBus2  = Ch7WriteBus2;
      CombAddrIncBus2  = Ch7AddrIncBus2;
      CombPriBus2      = 1'b0;
      CombChHProtBus2  = Ch7HProtBus2;
      CombChHSIZEBus2  = Ch7HSIZEBus2;
      CombChAddrBus2   = Ch7AddrBus2;
      CombBeatCntBus2  = Ch7BeatCntBus2;
    end
end // p_Bus2RouteComb

// -----------------------------------------------------------------------------
// Registering Channel resources which are put on BUS1
// -----------------------------------------------------------------------------
always @(ChHLOCKBus1Reg or ChWRITEBus1Reg or AddrIncBus1Reg or PriBus1Reg or
         ChHProtBus1Reg or ChHSIZEBus1Reg or ChAddrBus1Reg or BeatCntBus1Reg or
         CombChHLOCKBus1 or CombChWRITEBus1 or CombAddrIncBus1 or CombPriBus1 or
         CombChHProtBus1 or CombChHSIZEBus1 or CombChAddrBus1 or
         CombBeatCntBus1 or StopArb1)
begin : p_Bus1RegComb
  NextChHLOCKBus1  = ChHLOCKBus1Reg;
  NextChWRITEBus1  = ChWRITEBus1Reg;
  NextAddrIncBus1  = AddrIncBus1Reg;
  NextPriBus1      = PriBus1Reg;
  NextChHProtBus1  = ChHProtBus1Reg;
  NextChHSIZEBus1  = ChHSIZEBus1Reg;
  NextChAddrBus1   = ChAddrBus1Reg;
  NextBeatCntBus1  = BeatCntBus1Reg;
  if (StopArb1 == 1'b0)
    begin
      NextChHLOCKBus1  = CombChHLOCKBus1;
      NextChWRITEBus1  = CombChWRITEBus1;
      NextAddrIncBus1  = CombAddrIncBus1;
      NextPriBus1      = CombPriBus1;
      NextChHProtBus1  = CombChHProtBus1;
      NextChHSIZEBus1  = CombChHSIZEBus1;
      NextChAddrBus1   = CombChAddrBus1;
      NextBeatCntBus1  = CombBeatCntBus1;
    end
end // p_Bus1RegComb

// -----------------------------------------------------------------------------
// Registering all the next state signals
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_Bus1RegSeq
  if (HRESETn == 1'b0)
    begin
      ChHLOCKBus1Reg   <= 1'b0;
      ChWRITEBus1Reg   <= 1'b0;
      AddrIncBus1Reg   <= 1'b0;
      PriBus1Reg       <= 1'b0;
      ChHProtBus1Reg   <= ('d0);
      ChHSIZEBus1Reg   <= ('d0);
      ChAddrBus1Reg    <= ('d0);
      BeatCntBus1Reg   <= ('d0);
    end
  else
    begin
      ChHLOCKBus1Reg   <= NextChHLOCKBus1;
      ChWRITEBus1Reg   <= NextChWRITEBus1;
      AddrIncBus1Reg   <= NextAddrIncBus1;
      PriBus1Reg       <= NextPriBus1;
      ChHProtBus1Reg   <= NextChHProtBus1;
      ChHSIZEBus1Reg   <= NextChHSIZEBus1;
      ChAddrBus1Reg    <= NextChAddrBus1;
      BeatCntBus1Reg   <= NextBeatCntBus1;
    end
end // p_Bus1RegSeq

// -----------------------------------------------------------------------------
// Routing channel resources on to AHB Master1
// -----------------------------------------------------------------------------
assign ChHLOCKBus1      = NextChHLOCKBus1 | (ChHLOCKBus1Reg & StopArb1);
assign ChWRITEBus1      = NextChWRITEBus1 | (ChWRITEBus1Reg & StopArb1);
assign ChAddrIncrBus1   = NextAddrIncBus1 | (AddrIncBus1Reg & StopArb1);
assign ChDisableBus1    = Ch0DisableBus1 | Ch1DisableBus1 | Ch2DisableBus1 |
                          Ch3DisableBus1 | Ch4DisableBus1 | Ch5DisableBus1 |
                          Ch6DisableBus1 | Ch7DisableBus1;
assign ChPriorityBus1   = NextPriBus1 | (PriBus1Reg & StopArb1);
assign ChHSIZEBus1      = (StopArb1 == 1'b0) ? NextChHSIZEBus1 : ChHSIZEBus1Reg;
assign ChHProtBus1      = (StopArb1 == 1'b0) ? NextChHProtBus1 : ChHProtBus1Reg;
assign ChAddrBus1       = (StopArb1 == 1'b0) ? NextChAddrBus1  : ChAddrBus1Reg;
assign ChBeatCountBus1  = (StopArb1 == 1'b0) ? NextBeatCntBus1 : BeatCntBus1Reg;

// -----------------------------------------------------------------------------
// Registering Channel resources which are put on BUS2
// -----------------------------------------------------------------------------
always @(ChHLOCKBus2Reg or ChWRITEBus2Reg or AddrIncBus2Reg or PriBus2Reg or
         ChHProtBus2Reg or ChHSIZEBus2Reg or ChAddrBus2Reg or BeatCntBus2Reg or
         CombChHLOCKBus2 or CombChWRITEBus2 or CombAddrIncBus2 or CombPriBus2 or
         CombChHProtBus2 or CombChHSIZEBus2 or CombChAddrBus2 or
         CombBeatCntBus2 or StopArb2)
begin : p_Bus2RegComb
  NextChHLOCKBus2  = ChHLOCKBus2Reg;
  NextChWRITEBus2  = ChWRITEBus2Reg;
  NextAddrIncBus2  = AddrIncBus2Reg;
  NextPriBus2      = PriBus2Reg;
  NextChHProtBus2  = ChHProtBus2Reg;
  NextChHSIZEBus2  = ChHSIZEBus2Reg;
  NextChAddrBus2   = ChAddrBus2Reg;
  NextBeatCntBus2  = BeatCntBus2Reg;
  if (StopArb2 == 1'b0)
    begin
      NextChHLOCKBus2  = CombChHLOCKBus2;
      NextChWRITEBus2  = CombChWRITEBus2;
      NextAddrIncBus2  = CombAddrIncBus2;
      NextPriBus2      = CombPriBus2;
      NextChHProtBus2  = CombChHProtBus2;
      NextChHSIZEBus2  = CombChHSIZEBus2;
      NextChAddrBus2   = CombChAddrBus2;
      NextBeatCntBus2  = CombBeatCntBus2;
    end
end // p_Bus2RegComb

// -----------------------------------------------------------------------------
// Routing channel resources on to AHB Master2
// -----------------------------------------------------------------------------
assign ChHLOCKBus2      = NextChHLOCKBus2 | (ChHLOCKBus2Reg & StopArb2);
assign ChWRITEBus2      = NextChWRITEBus2 | (ChWRITEBus2Reg & StopArb2);
assign ChAddrIncrBus2   = NextAddrIncBus2 | (AddrIncBus2Reg & StopArb2);
assign ChDisableBus2    = Ch0DisableBus2 | Ch1DisableBus2 | Ch2DisableBus2 |
                          Ch3DisableBus2 | Ch4DisableBus2 | Ch5DisableBus2 |
                          Ch6DisableBus2 | Ch7DisableBus2;
assign ChPriorityBus2   = NextPriBus2 | (PriBus2Reg & StopArb2);
assign ChHSIZEBus2      = (StopArb2 == 1'b0) ? NextChHSIZEBus2 : ChHSIZEBus2Reg;
assign ChHProtBus2      = (StopArb2 == 1'b0) ? NextChHProtBus2 : ChHProtBus2Reg;
assign ChAddrBus2       = (StopArb2 == 1'b0) ? NextChAddrBus2  : ChAddrBus2Reg;
assign ChBeatCountBus2  = (StopArb2 == 1'b0) ? NextBeatCntBus2 : BeatCntBus2Reg;

// -----------------------------------------------------------------------------
// Registering all the next state signals
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_Bus2RegSeq
  if (HRESETn == 1'b0)
    begin
      ChHLOCKBus2Reg   <= 1'b0;
      ChWRITEBus2Reg   <= 1'b0;
      AddrIncBus2Reg   <= 1'b0;
      PriBus2Reg       <= 1'b0;
      ChHProtBus2Reg   <= ('d0);
      ChHSIZEBus2Reg   <= ('d0);
      ChAddrBus2Reg    <= ('d0);
      BeatCntBus2Reg   <= ('d0);
    end
  else
    begin
      ChHLOCKBus2Reg   <= NextChHLOCKBus2;
      ChWRITEBus2Reg   <= NextChWRITEBus2;
      AddrIncBus2Reg   <= NextAddrIncBus2;
      PriBus2Reg       <= NextPriBus2;
      ChHProtBus2Reg   <= NextChHProtBus2;
      ChHSIZEBus2Reg   <= NextChHSIZEBus2;
      ChAddrBus2Reg    <= NextChAddrBus2;
      BeatCntBus2Reg   <= NextBeatCntBus2;
    end
end // p_Bus2RegSeq

// -----------------------------------------------------------------------------
// Logic to Route SOFTCLR Lines on the Bus
// -----------------------------------------------------------------------------
always @(Ch0SOFTCLR or Ch1SOFTCLR or Ch2SOFTCLR or Ch3SOFTCLR or Ch4SOFTCLR or
         Ch5SOFTCLR or Ch6SOFTCLR or Ch7SOFTCLR)
begin : p_SOFTCLRComb
   SOFTCLR = Ch0SOFTCLR | Ch1SOFTCLR | Ch2SOFTCLR | Ch3SOFTCLR | Ch4SOFTCLR |
             Ch5SOFTCLR | Ch6SOFTCLR | Ch7SOFTCLR;
end // p_SOFTCLRComb

// -----------------------------------------------------------------------------
// Logic to Route DMACCLR Lines on the Bus
// -----------------------------------------------------------------------------
always @(Ch0DMACCLR or Ch1DMACCLR or Ch2DMACCLR or Ch3DMACCLR or Ch4DMACCLR or
         Ch5DMACCLR or Ch6DMACCLR or Ch7DMACCLR)
begin : p_DMACCLRComb
   DMACCLR = Ch0DMACCLR | Ch1DMACCLR | Ch2DMACCLR | Ch3DMACCLR | Ch4DMACCLR |
             Ch5DMACCLR | Ch6DMACCLR | Ch7DMACCLR;
end // p_DMACCLRComb

// -----------------------------------------------------------------------------
// Logic to Route DMACTC Lines on the Bus
// -----------------------------------------------------------------------------
always @(Ch0DMACTC or Ch1DMACTC or Ch2DMACTC or Ch3DMACTC or Ch4DMACTC or
         Ch5DMACTC or Ch6DMACTC or Ch7DMACTC)
begin : p_DMACTCComb
   DMACTC = Ch0DMACTC | Ch1DMACTC | Ch2DMACTC | Ch3DMACTC | Ch4DMACTC |
            Ch5DMACTC | Ch6DMACTC | Ch7DMACTC;
end // p_DMACTCComb

endmodule
// --================================== End ==================================--
