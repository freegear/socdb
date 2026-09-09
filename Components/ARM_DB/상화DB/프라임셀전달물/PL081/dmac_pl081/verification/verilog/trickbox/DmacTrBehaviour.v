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
// File Name              : DmacTrBehaviour.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block is the top level of the Behavioural DMAC.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacTrBehaviour (
// Inputs
                        HCLK,
                        HRESETn,
                        HSELDMAC,
                        HSELDMACTrSlave,
                        HWRITE,
                        HTRANS,
                        HADDR,
                        HSIZE,
                        HWDATA,
                        HREADYIN,
                        HGRANTDMACM1,
                        HGRANTDMACM2,
                        HREADYINM1,
                        HREADYINM2,
                        HRESPM1,
                        HRESPM2,
                        HRDATAM1,
                        HRDATAM2,
                        DMACBREQ,
                        DMACLBREQ,
                        DMACSREQ,
                        DMACLSREQ,
// Outputs
                        HREADYOUT,
                        HRESP,
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
                        DMACCLR,
                        DMACTC,
                        DMACINTERR,
                        DMACINTTC,
                        DMACINTR,
                        DmacTrEn,
                        ReqConfig,
                        GrantCount0,
                        GrantCount1
                        );

// Inputs
input         HCLK;            // AHB clock
input         HRESETn;         // AHB reset
input         HSELDMAC;        // Slave Select for DMAC
input         HSELDMACTrSlave; // Slave Select for Trickbox
input         HWRITE;          // Transfer direction
input         HTRANS;          // Type of transfer on AHB3
input  [20:2] HADDR;           // AHB3 address bus
input   [2:0] HSIZE;           // The width of the transfer on AHB3
input  [31:0] HWDATA;          // AHB3 address bus
input         HREADYIN;        // Transfer done response
input         HGRANTDMACM1;    // AHB bus grant for master1
input         HGRANTDMACM2;    // AHB bus grant for master2
input         HREADYINM1;      // Transfer done response from AHB1
input         HREADYINM2;      // Transfer done response from AHB2
input   [1:0] HRESPM1;         // Transfer response from AHB1
input   [1:0] HRESPM2;         // Transfer response from AHB2
input  [31:0] HRDATAM1;        // Read Data from the AHB1
input  [31:0] HRDATAM2;        // Read Data from the AHB2
input  [15:0] DMACBREQ;        // DMAC burst transfer request
input  [15:0] DMACLBREQ;       // DMAC last burst transfer request
input  [15:0] DMACSREQ;        // DMAC single transfer request
input  [15:0] DMACLSREQ;       // DMAC last single transfer request

// Outputs
output        HREADYOUT;       // Transfer done response to AHB3
output  [1:0] HRESP;           // Transfer response to AHB3
output        HBUSREQDMACM1;   // Bus req signal to the AHB Arb1
output        HBUSREQDMACM2;   // Bus req signal to the AHB Arb2
output        HLOCKDMACM1;     // Indicates locked transfer on AHB1
output        HLOCKDMACM2;     // Indicates locked transfer on AHB2
output  [1:0] HTRANSM1;        // Type of transfer on AHB1
output  [1:0] HTRANSM2;        // Type of transfer on AHB2
output [31:0] HADDRM1;         // AHB1 address bus
output [31:0] HADDRM2;         // AHB2 address bus
output  [2:0] HSIZEM1;         // Width of transfer on AHB1
output  [2:0] HSIZEM2;         // Width of transfer on AHB2
output  [2:0] HBURSTM1;        // Burst length on AHB1
output  [2:0] HBURSTM2;        // Burst length on AHB2
output  [3:0] HPROTM1;         // Protection information on AHB1
output  [3:0] HPROTM2;         // Protection information on AHB2
output        HWRITEM1;        // Transfer direction on AHB1
output        HWRITEM2;        // Transfer direction on AHB2
output [31:0] HWDATAM1;        // Write data to AHB1
output [31:0] HWDATAM2;        // Write data to AHB2
output [15:0] DMACCLR;         // DMAC request clear
output [15:0] DMACTC;          // DMAC terminal count
output        DMACINTERR;      // DMAC error interrupt request
output        DMACINTTC;       // DMAC terminal count interrupt
output        DMACINTR;        // DMAC combined interrupt request
output        DmacTrEn;        // DMAC Trickbox Enable
output [17:0] ReqConfig;       // Trickbox config Reg for Perp/Mem
output [31:0] GrantCount0;     // Trickbox Grant Generation Reg used by AHB
                               // Arbiter0
output [31:0] GrantCount1;     // Trickbox Grant Generation Reg used by AHB
                               // Arbiter1




// Inputs
  wire        HCLK;            // AHB clock
  wire        HRESETn;         // AHB reset
  wire        HSELDMAC;        // Slave Select for DMAC
  wire        HSELDMACTrSlave; // Slave Select for Trickbox
  wire        HWRITE;          // Transfer direction
  wire        HTRANS;          // Type of transfer on AHB3
  wire [20:2] HADDR;           // AHB3 address bus
  wire  [2:0] HSIZE;           // The width of the transfer on AHB3
  wire [31:0] HWDATA;          // AHB3 address bus
  wire        HREADYIN;        // Transfer done response
  wire        HGRANTDMACM1;    // AHB bus grant for master1
  wire        HGRANTDMACM2;    // AHB bus grant for master2
  wire        HREADYINM1;      // Transfer done response from AHB1
  wire        HREADYINM2;      // Transfer done response from AHB2
  wire  [1:0] HRESPM1;         // Transfer response from AHB1
  wire  [1:0] HRESPM2;         // Transfer response from AHB2
  wire [31:0] HRDATAM1;        // Read Data from the AHB1
  wire [31:0] HRDATAM2;        // Read Data from the AHB2
  wire [15:0] DMACBREQ;        // DMAC burst transfer request
  wire [15:0] DMACLBREQ;       // DMAC last burst transfer request
  wire [15:0] DMACSREQ;        // DMAC single transfer request
  wire [15:0] DMACLSREQ;       // DMAC last single transfer request

// Outputs
  wire        HREADYOUT;       // Transfer done response to AHB3
  wire  [1:0] HRESP;           // Transfer response to AHB3
  wire        HBUSREQDMACM1;   // Bus req signal to the AHB Arb1
  wire        HBUSREQDMACM2;   // Bus req signal to the AHB Arb2
  wire        HLOCKDMACM1;     // Indicates locked transfer on AHB1
  wire        HLOCKDMACM2;     // Indicates locked transfer on AHB2
  wire  [1:0] HTRANSM1;        // Type of transfer on AHB1
  wire  [1:0] HTRANSM2;        // Type of transfer on AHB2
  wire [31:0] HADDRM1;         // AHB1 address bus
  wire [31:0] HADDRM2;         // AHB2 address bus
  wire  [2:0] HSIZEM1;         // Width of transfer on AHB1
  wire  [2:0] HSIZEM2;         // Width of transfer on AHB2
  wire  [2:0] HBURSTM1;        // Burst length on AHB1
  wire  [2:0] HBURSTM2;        // Burst length on AHB2
  wire  [3:0] HPROTM1;         // Protection information on AHB1
  wire  [3:0] HPROTM2;         // Protection information on AHB2
  wire        HWRITEM1;        // Transfer direction on AHB1
  wire        HWRITEM2;        // Transfer direction on AHB2
  wire [31:0] HWDATAM1;        // Write data to AHB1
  wire [31:0] HWDATAM2;        // Write data to AHB2
  wire [15:0] DMACCLR;         // DMAC request clear
  wire [15:0] DMACTC;          // DMAC terminal count
  wire        DMACINTERR;      // DMAC error interrupt request
  wire        DMACINTTC;       // DMAC terminal count interrupt
  wire        DMACINTR;        // DMAC combined interrupt request
  wire        DmacTrEn;        // DMAC Trickbox Enable
  wire [17:0] ReqConfig;       // Trickbox config Reg for Perp/Mem
  wire [31:0] GrantCount0;     // Trickbox Grant Generation Reg used by AHB
                               // Arbiter0
  wire [31:0] GrantCount1;     // Trickbox Grant Generation Reg used by AHB
                               // Arbiter1


// -----------------------------------------------------------------------------
//
//                               DmacTrBehaviour
//                               ===============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block is the top level of the DMAC Behaviour. This block instantiates
// the following functional sub-blocks in the DMAC.
//      - DmacTrAhbSlaveIf
//      - DmacTrAhbMaster(2 instances)
//      - DmacTrIntArb(2 instances)
//      - DmacTrChLogic(8 instances)
//      - DmacTrRouter
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        DmacSrcRegWrEn0;
// Write Enable for DMACC0SrcAddr

wire        DmacDstRegWrEn0;
// Write Enable for DMACC0DestAddr

wire        DmacLLIRegWrEn0;
// Write Enable for DMACC0LLIReg

wire        DmacCntlRegWrEn0;
// Write Enable for DMACC0Control

wire        DmacChCnfgWrEn0;
// Write Enable for DMACC0Config

wire        DmacSrcRegWrEn1;
// Write Enable for DMACC1SrcAddr

wire        DmacDstRegWrEn1;
// Write Enable for DMACC1DestAddr

wire        DmacLLIRegWrEn1;
// Write Enable for DMACC1LLIReg

wire        DmacCntlRegWrEn1;
// Write Enable for DMACC1Control

wire        DmacChCnfgWrEn1;
// Write Enable for DMACC1Config

wire        DmacSrcRegWrEn2;
// Write Enable for DMACC2SrcAddr

wire        DmacDstRegWrEn2;
// Write Enable for DMACC2DestAddr

wire        DmacLLIRegWrEn2;
// Write Enable for DMACC2LLIReg

wire        DmacCntlRegWrEn2;
// Write Enable for DMACC2Control

wire        DmacChCnfgWrEn2;
// Write Enable for DMACC2Config

wire        DmacSrcRegWrEn3;
// Write Enable for DMACC3SrcAddr

wire        DmacDstRegWrEn3;
// Write Enable for DMACC3DestAddr

wire        DmacLLIRegWrEn3;
// Write Enable for DMACC3LLIReg

wire        DmacCntlRegWrEn3;
// Write Enable for DMACC3Control

wire        DmacChCnfgWrEn3;
// Write Enable for DMACC3Config

wire        DmacSrcRegWrEn4;
// Write Enable for DMACC4SrcAddr

wire        DmacDstRegWrEn4;
// Write Enable for DMACC4DestAddr

wire        DmacLLIRegWrEn4;
// Write Enable for DMACC4LLIReg

wire        DmacCntlRegWrEn4;
// Write Enable for DMACC4Control

wire        DmacChCnfgWrEn4;
// Write Enable for DMACC4Config

wire        DmacSrcRegWrEn5;
// Write Enable for DMACC5SrcAddr

wire        DmacDstRegWrEn5;
// Write Enable for DMACC5DestAddr

wire        DmacLLIRegWrEn5;
// Write Enable for DMACC5LLIReg

wire        DmacCntlRegWrEn5;
// Write Enable for DMACC5Control

wire        DmacChCnfgWrEn5;
// Write Enable for DMACC5Config

wire        DmacSrcRegWrEn6;
// Write Enable for DMACC6SrcAddr

wire        DmacDstRegWrEn6;
// Write Enable for DMACC6DestAddr

wire        DmacLLIRegWrEn6;
// Write Enable for DMACC6LLIReg

wire        DmacCntlRegWrEn6;
// Write Enable for DMACC6Control

wire        DmacChCnfgWrEn6;
// Write Enable for DMACC6Config

wire        DmacSrcRegWrEn7;
// Write Enable for DMACC7SrcAddr

wire        DmacDstRegWrEn7;
// Write Enable for DMACC7DestAddr

wire        DmacLLIRegWrEn7;
// Write Enable for DMACC7LLIReg

wire        DmacCntlRegWrEn7;
// Write Enable for DMACC7Control

wire        DmacChCnfgWrEn7;
// Write Enable for DMACC7Config

wire [15:0] DMACBREQCh;
// DMA burst transfer request

wire [15:0] DMACLBREQCh;
// DMAC last burst transfer request

wire [15:0] DMACSREQCh;
// DMAC single transfer request

wire [15:0] DMACLSREQCh;
// DMAC last single transfer request

wire [15:0] SOFTBREQCh;
// Soft burst transfer request

wire [15:0] SOFTLBREQCh;
// Soft last burst transfer request

wire [15:0] SOFTSREQCh;
// Soft single transfer request

wire [15:0] SOFTLSREQCh;
// Soft last single transfer request

wire  [7:0] ClrIntErr;
// DMAC error interrupt

wire  [7:0] ClrIntTC;
// DMAC terminal count interrupt

wire        DMACEn;
// DMAC Controller Enable

wire        MasterEndian1;
// Endianness bit for master 1

wire        MasterEndian2;
// Endianness bit for master 2

wire        Ch0ReqArb1;
// Channel0 req to Arbiter1

wire        Ch1ReqArb1;
// Channel1 req to Arbiter1

wire        Ch2ReqArb1;
// Channel2 req to Arbiter1

wire        Ch3ReqArb1;
// Channel3 req to Arbiter1

wire        Ch4ReqArb1;
// Channel4 req to Arbiter1

wire        Ch5ReqArb1;
// Channel5 req to Arbiter1

wire        Ch6ReqArb1;
// Channel6 req to Arbiter1

wire        Ch7ReqArb1;
// Channel7 req to Arbiter1

wire        Ch0ReqArb2;
// Channel0 req to Arbiter2

wire        Ch1ReqArb2;
// Channel1 req to Arbiter2

wire        Ch2ReqArb2;
// Channel2 req to Arbiter2

wire        Ch3ReqArb2;
// Channel3 req to Arbiter2

wire        Ch4ReqArb2;
// Channel4 req to Arbiter2

wire        Ch5ReqArb2;
// Channel5 req to Arbiter2

wire        Ch6ReqArb2;
// Channel6 req to Arbiter2

wire        Ch7ReqArb2;
// Channel7 req to Arbiter2

wire        DataValidBus1;
// DataValid info for Channel from Master1

wire        DataValidBus2;
// DataValid info for Channel from Master2

wire [31:0] Ch0HWDATABus1;
// AHB Write Data Bus1 from Channel0

wire [31:0] Ch1HWDATABus1;
// AHB Write Data Bus1 from Channel1

wire [31:0] Ch2HWDATABus1;
// AHB Write Data Bus1 from Channel2

wire [31:0] Ch3HWDATABus1;
// AHB Write Data Bus1 from Channel3

wire [31:0] Ch4HWDATABus1;
// AHB Write Data Bus1 from Channel4

wire [31:0] Ch5HWDATABus1;
// AHB Write Data Bus1 from Channel5

wire [31:0] Ch6HWDATABus1;
// AHB Write Data Bus1 from Channel6

wire [31:0] Ch7HWDATABus1;
// AHB Write Data Bus1 from Channel7

wire [31:0] Ch0HWDATABus2;
// AHB Write Data Bus2 from Channel0

wire [31:0] Ch1HWDATABus2;
// AHB Write Data Bus2 from Channel1

wire [31:0] Ch2HWDATABus2;
// AHB Write Data Bus2 from Channel2

wire [31:0] Ch3HWDATABus2;
// AHB Write Data Bus2 from Channel3

wire [31:0] Ch4HWDATABus2;
// AHB Write Data Bus2 from Channel4

wire [31:0] Ch5HWDATABus2;
// AHB Write Data Bus2 from Channel5

wire [31:0] Ch6HWDATABus2;
// AHB Write Data Bus2 from Channel6

wire [31:0] Ch7HWDATABus2;
// AHB Write Data Bus2 from Channel7

wire        ReqForAhbBus1;
// Indication for Master Interface to put request on Bus1

wire        ReqForAhbBus2;
// Indication for Master Interface to put request on Bus2

wire [31:0] HWDATABus1;
// AHB Write Data bus1

wire [31:0] HWDATABus2;
// AHB Write Data bus1

wire        Ch0CombBus1;
// Channel0 selected(1HCLK Wide)

wire        Ch1CombBus1;
// Channel1 selected(1HCLK Wide)

wire        Ch2CombBus1;
// Channel2 selected(1HCLK Wide)

wire        Ch3CombBus1;
// Channel3 selected(1HCLK Wide)

wire        Ch4CombBus1;
// Channel4 selected(1HCLK Wide)

wire        Ch5CombBus1;
// Channel5 selected(1HCLK Wide)

wire        Ch6CombBus1;
// Channel6 selected(1HCLK Wide)

wire        Ch7CombBus1;
// Channel7 selected(1HCLK Wide)

wire        Ch0CombBus2;
// Channel0 selected(1HCLK Wide)

wire        Ch1CombBus2;
// Channel1 selected(1HCLK Wide)

wire        Ch2CombBus2;
// Channel2 selected(1HCLK Wide)

wire        Ch3CombBus2;
// Channel3 selected(1HCLK Wide)

wire        Ch4CombBus2;
// Channel4 selected(1HCLK Wide)

wire        Ch5CombBus2;
// Channel5 selected(1HCLK Wide)

wire        Ch6CombBus2;
// Channel6 selected(1HCLK Wide)

wire        Ch7CombBus2;
// Channel7 selected(1HCLK Wide)

wire [15:0] SOFTCLR;
// DMAC SoftReq Clear

wire [15:0] iDMACCLR;
// Internal copy of DMAC Clear

wire        ChHLOCKBus1;
// HLOCK for Bus1

wire        ChHLOCKBus2;
// HLOCK for Bus2

wire        ChWRITEBus1;
// HWRITE for Bus1

wire        ChWRITEBus2;
// HWRITE for Bus2

wire  [3:0] ChHProtBus1;
// HPROT for Bus1

wire  [3:0] ChHProtBus2;
// HPROT for Bus2

wire  [2:0] ChHSIZEBus1;
// HSIZE for Bus1

wire  [2:0] ChHSIZEBus2;
// HSIZE for Bus2

wire [31:0] ChAddrBus1;
// Channel Address for Bus1

wire [31:0] ChAddrBus2;
// Channel Address for Bus1

wire        ChAddrIncrBus1;
// Channel Addr Increment for Bus1

wire        ChAddrIncrBus2;
// Channel Addr Increment for Bus2

wire        ChDisableBus1;
// Channel disable for Mas1

wire        ChDisableBus2;
// Channel disable for Mas2

wire        ChPriorityBus1;
// Channel priority for Mas1

wire        ChPriorityBus2;
// Channel priority for Mas2

wire  [4:0] ChBeatCountBus1;
// BeatCount for Mas1

wire  [4:0] ChBeatCountBus2;
// BeatCount for Mas2

wire        DisAckMas1;
// Channel Disable Acknowledge from Master1

wire        DisAckMas2;
// Channel Disable Acknowledge from Master2

wire        StopArb1;
// Stop Arbitration indication from Master1

wire        StopArb2;
// Stop Arbitration indication from Master2

wire        ErrorMas1;
// Error on Master1

wire        ErrorMas2;
// Error on Master1

wire        MREADY1;
// MREADY from Master1

wire        MREADY2;
// MREADY from Master2

wire        Ch0DisableBus1;
// Channel0 Disable for Bus1

wire        Ch0DisableBus2;
// Channel0 Disable for Bus2

wire        Ch1DisableBus1;
// Channel1 Disable for Bus1

wire        Ch1DisableBus2;
// Channel1 Disable for Bus2

wire        Ch2DisableBus1;
// Channel2 Disable for Bus1

wire        Ch2DisableBus2;
// Channel2 Disable for Bus2

wire        Ch3DisableBus1;
// Channel3 Disable for Bus1

wire        Ch3DisableBus2;
// Channel3 Disable for Bus2

wire        Ch4DisableBus1;
// Channel4 Disable for Bus1

wire        Ch4DisableBus2;
// Channel4 Disable for Bus2

wire        Ch5DisableBus1;
// Channel5 Disable for Bus1

wire        Ch5DisableBus2;
// Channel5 Disable for Bus2

wire        Ch6DisableBus1;
// Channel6 Disable for Bus1

wire        Ch6DisableBus2;
// Channel6 Disable for Bus2

wire        Ch7DisableBus1;
// Channel0 Disable for Bus1

wire        Ch7DisableBus2;
// Channel0 Disable for Bus2

wire [31:0] Ch0AddrBus1;
// Channel0 Address on Bus1

wire [31:0] Ch0AddrBus2;
// Channel0 Address on Bus2

wire [31:0] Ch1AddrBus1;
// Channel1 Address on Bus1

wire [31:0] Ch1AddrBus2;
// Channel1 Address on Bus2

wire [31:0] Ch2AddrBus1;
// Channel2 Address on Bus1

wire [31:0] Ch2AddrBus2;
// Channel2 Address on Bus2

wire [31:0] Ch3AddrBus1;
// Channel3 Address on Bus1

wire [31:0] Ch3AddrBus2;
// Channel3 Address on Bus2

wire [31:0] Ch4AddrBus1;
// Channel4 Address on Bus1

wire [31:0] Ch4AddrBus2;
// Channel4 Address on Bus2

wire [31:0] Ch5AddrBus1;
// Channel5 Address on Bus1

wire [31:0] Ch5AddrBus2;
// Channel5 Address on Bus2

wire [31:0] Ch6AddrBus1;
// Channel6 Address on Bus1

wire [31:0] Ch6AddrBus2;
// Channel6 Address on Bus2

wire [31:0] Ch7AddrBus1;
// Channel7 Address on Bus1

wire [31:0] Ch7AddrBus2;
// Channel7 Address on Bus2

wire        Ch0HLockBus1;
// Channel0 Lock on Bus1

wire        Ch0HLockBus2;
// Channel0 Lock on Bus2

wire        Ch1HLockBus1;
// Channel1 Lock on Bus1

wire        Ch1HLockBus2;
// Channel1 Lock on Bus2

wire        Ch2HLockBus1;
// Channel2 Lock on Bus1

wire        Ch2HLockBus2;
// Channel2 Lock on Bus2

wire        Ch3HLockBus1;
// Channel3 Lock on Bus1

wire        Ch3HLockBus2;
// Channel3 Lock on Bus2

wire        Ch4HLockBus1;
// Channel4 Lock on Bus1

wire        Ch4HLockBus2;
// Channel4 Lock on Bus2

wire        Ch5HLockBus1;
// Channel5 Lock on Bus1

wire        Ch5HLockBus2;
// Channel5 Lock on Bus2

wire        Ch6HLockBus1;
// Channel6 Lock on Bus1

wire        Ch6HLockBus2;
// Channel6 Lock on Bus2

wire        Ch7HLockBus1;
// Channel7 Lock on Bus1

wire        Ch7HLockBus2;
// Channel7 Lock on Bus2

wire  [3:0] Ch0HProtBus1;
// Channel0 HPROT inf on Bus1

wire  [3:0] Ch0HProtBus2;
// Channel0 HPROT inf on Bus2

wire  [3:0] Ch1HProtBus1;
// Channel1 HPROT inf on Bus1

wire  [3:0] Ch1HProtBus2;
// Channel1 HPROT inf on Bus2

wire  [3:0] Ch2HProtBus1;
// Channel2 HPROT inf on Bus1

wire  [3:0] Ch2HProtBus2;
// Channel2 HPROT inf on Bus2

wire  [3:0] Ch3HProtBus1;
// Channel3 HPROT inf on Bus1

wire  [3:0] Ch3HProtBus2;
// Channel3 HPROT inf on Bus2

wire  [3:0] Ch4HProtBus1;
// Channel4 HPROT inf on Bus1

wire  [3:0] Ch4HProtBus2;
// Channel4 HPROT inf on Bus2

wire  [3:0] Ch5HProtBus1;
// Channel5 HPROT inf on Bus1

wire  [3:0] Ch5HProtBus2;
// Channel5 HPROT inf on Bus2

wire  [3:0] Ch6HProtBus1;
// Channel6 HPROT inf on Bus1

wire  [3:0] Ch6HProtBus2;
// Channel6 HPROT inf on Bus2

wire  [3:0] Ch7HProtBus1;
// Channel7 HPROT inf on Bus1

wire  [3:0] Ch7HProtBus2;
// Channel7 HPROT inf on Bus2

wire  [4:0] Ch0BeatCntBus1;
// Channel0 BeatCount for Bus1

wire  [4:0] Ch0BeatCntBus2;
// Channel0 BeatCount for Bus2

wire  [4:0] Ch1BeatCntBus1;
// Channel1 BeatCount for Bus1

wire  [4:0] Ch1BeatCntBus2;
// Channel1 BeatCount for Bus2

wire  [4:0] Ch2BeatCntBus1;
// Channel2 BeatCount for Bus1

wire  [4:0] Ch2BeatCntBus2;
// Channel2 BeatCount for Bus2

wire  [4:0] Ch3BeatCntBus1;
// Channel3 BeatCount for Bus1

wire  [4:0] Ch3BeatCntBus2;
// Channel3 BeatCount for Bus2

wire  [4:0] Ch4BeatCntBus1;
// Channel4 BeatCount for Bus1

wire  [4:0] Ch4BeatCntBus2;
// Channel4 BeatCount for Bus2

wire  [4:0] Ch5BeatCntBus1;
// Channel5 BeatCount for Bus1

wire  [4:0] Ch5BeatCntBus2;
// Channel5 BeatCount for Bus2

wire  [4:0] Ch6BeatCntBus1;
// Channel6 BeatCount for Bus1

wire  [4:0] Ch6BeatCntBus2;
// Channel6 BeatCount for Bus2

wire  [4:0] Ch7BeatCntBus1;
// Channel7 BeatCount for Bus1

wire  [4:0] Ch7BeatCntBus2;
// Channel7 BeatCount for Bus2

wire        Ch0AddrIncBus1;
// Channel0 Address Incr on Bus1

wire        Ch0AddrIncBus2;
// Channel0 Address Incr on Bus2

wire        Ch1AddrIncBus1;
// Channel1 Address Incr on Bus1

wire        Ch1AddrIncBus2;
// Channel1 Address Incr on Bus2

wire        Ch2AddrIncBus1;
// Channel2 Address Incr on Bus1

wire        Ch2AddrIncBus2;
// Channel2 Address Incr on Bus2

wire        Ch3AddrIncBus1;
// Channel3 Address Incr on Bus1

wire        Ch3AddrIncBus2;
// Channel3 Address Incr on Bus2

wire        Ch4AddrIncBus1;
// Channel4 Address Incr on Bus1

wire        Ch4AddrIncBus2;
// Channel4 Address Incr on Bus2

wire        Ch5AddrIncBus1;
// Channel5 Address Incr on Bus1

wire        Ch5AddrIncBus2;
// Channel5 Address Incr on Bus2

wire        Ch6AddrIncBus1;
// Channel6 Address Incr on Bus1

wire        Ch6AddrIncBus2;
// Channel6 Address Incr on Bus2

wire        Ch7AddrIncBus1;
// Channel7 Address Incr on Bus1

wire        Ch7AddrIncBus2;
// Channel7 Address Incr on Bus2

wire        Ch0WriteBus1;
// Channel0 HWRITE for Bus1

wire        Ch0WriteBus2;
// Channel0 HWRITE for Bus2

wire        Ch1WriteBus1;
// Channel1 HWRITE for Bus1

wire        Ch1WriteBus2;
// Channel1 HWRITE for Bus2

wire        Ch2WriteBus1;
// Channel2 HWRITE for Bus1

wire        Ch2WriteBus2;
// Channel2 HWRITE for Bus2

wire        Ch3WriteBus1;
// Channel3 HWRITE for Bus1

wire        Ch3WriteBus2;
// Channel3 HWRITE for Bus2

wire        Ch4WriteBus1;
// Channel4 HWRITE for Bus1

wire        Ch4WriteBus2;
// Channel4 HWRITE for Bus2

wire        Ch5WriteBus1;
// Channel5 HWRITE for Bus1

wire        Ch5WriteBus2;
// Channel5 HWRITE for Bus2

wire        Ch6WriteBus1;
// Channel6 HWRITE for Bus1

wire        Ch6WriteBus2;
// Channel6 HWRITE for Bus2

wire        Ch7WriteBus1;
// Channel7 HWRITE for Bus1

wire        Ch7WriteBus2;
// Channel7 HWRITE for Bus2

wire  [2:0] Ch0HSIZEBus1;
// Channel0 Hsize for Mas1

wire  [2:0] Ch0HSIZEBus2;
// Channel0 Hsize for Mas2

wire  [2:0] Ch1HSIZEBus1;
// Channel1 Hsize for Mas1

wire  [2:0] Ch1HSIZEBus2;
// Channel1 Hsize for Mas2

wire  [2:0] Ch2HSIZEBus1;
// Channel2 Hsize for Mas1

wire  [2:0] Ch2HSIZEBus2;
// Channel2 Hsize for Mas2

wire  [2:0] Ch3HSIZEBus1;
// Channel3 Hsize for Mas1

wire  [2:0] Ch3HSIZEBus2;
// Channel3 Hsize for Mas2

wire  [2:0] Ch4HSIZEBus1;
// Channel4 Hsize for Mas1

wire  [2:0] Ch4HSIZEBus2;
// Channel4 Hsize for Mas2

wire  [2:0] Ch5HSIZEBus1;
// Channel5 Hsize for Mas1

wire  [2:0] Ch5HSIZEBus2;
// Channel5 Hsize for Mas2

wire  [2:0] Ch6HSIZEBus1;
// Channel6 Hsize for Mas1

wire  [2:0] Ch6HSIZEBus2;
// Channel6 Hsize for Mas2

wire  [2:0] Ch7HSIZEBus1;
// Channel7 Hsize for Mas1

wire  [2:0] Ch7HSIZEBus2;
// Channel7 Hsize for Mas2

wire        Ch0IntTC;
// Channel0 TC Generation

wire        Ch1IntTC;
// Channel1 TC Generation

wire        Ch2IntTC;
// Channel2 TC Generation

wire        Ch3IntTC;
// Channel3 TC Generation

wire        Ch4IntTC;
// Channel4 TC Generation

wire        Ch5IntTC;
// Channel5 TC Generation

wire        Ch6IntTC;
// Channel6 TC Generation

wire        Ch7IntTC;
// Channel7 TC Generation

wire        Ch0IntErr;
// Channel0 Error Generation

wire        Ch1IntErr;
// Channel1 Error Generation

wire        Ch2IntErr;
// Channel2 Error Generation

wire        Ch3IntErr;
// Channel3 Error Generation

wire        Ch4IntErr;
// Channel4 Error Generation

wire        Ch5IntErr;
// Channel5 Error Generation

wire        Ch6IntErr;
// Channel6 Error Generation

wire        Ch7IntErr;
// Channel7 Error Generation

wire [15:0] Ch0SOFTCLR;
// Channel0 SoftReq Clear Generation

wire [15:0] Ch1SOFTCLR;
// Channel1 SoftReq Clear Generation

wire [15:0] Ch2SOFTCLR;
// Channel2 SoftReq Clear Generation

wire [15:0] Ch3SOFTCLR;
// Channel3 SoftReq Clear Generation

wire [15:0] Ch4SOFTCLR;
// Channel4 SoftReq Clear Generation

wire [15:0] Ch5SOFTCLR;
// Channel5 SoftReq Clear Generation

wire [15:0] Ch6SOFTCLR;
// Channel6 SoftReq Clear Generation

wire [15:0] Ch7SOFTCLR;
// Channel7 SoftReq Clear Generation

wire [15:0] Ch0DMACTC;
// Channel0 TC Generation

wire [15:0] Ch1DMACTC;
// Channel1 TC Generation

wire [15:0] Ch2DMACTC;
// Channel2 TC Generation

wire [15:0] Ch3DMACTC;
// Channel3 TC Generation

wire [15:0] Ch4DMACTC;
// Channel4 TC Generation

wire [15:0] Ch5DMACTC;
// Channel5 TC Generation

wire [15:0] Ch6DMACTC;
// Channel6 TC Generation

wire [15:0] Ch7DMACTC;
// Channel7 TC Generation

wire [15:0] Ch0DMACCLR;
// Channel0 Clear Generation

wire [15:0] Ch1DMACCLR;
// Channel1 Clear Generation

wire [15:0] Ch2DMACCLR;
// Channel2 Clear Generation

wire [15:0] Ch3DMACCLR;
// Channel3 Clear Generation

wire [15:0] Ch4DMACCLR;
// Channel4 Clear Generation

wire [15:0] Ch5DMACCLR;
// Channel5 Clear Generation

wire [15:0] Ch6DMACCLR;
// Channel6 Clear Generation

wire [15:0] Ch7DMACCLR;
// Channel7 Clear Generation

wire        iDMACINTTC;
// Internal copy of DMACINTTC

wire        iDMACINTERR;
// Internal copy of DMACINTERR

wire        iDMACINTR;
// Internal copy of DMACINTR


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
// Instantiation of DmacTrAhbSlaveIf
// -----------------------------------------------------------------------------
DmacTrAhbSlaveIf uDmacTrAhbSlaveIf (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HSELDMAC        (HSELDMAC),
        .HSELDMACTrSlave (HSELDMACTrSlave),
        .HWRITE          (HWRITE),
        .HTRANS          (HTRANS),
        .HWDATA          (HWDATA),
        .HADDR           (HADDR),
        .HSIZE           (HSIZE),
        .HREADYIN        (HREADYIN),
        .SoftClr         (SOFTCLR),
        .DmacClr         (iDMACCLR),
        .DMACBREQ        (DMACBREQ),
        .DMACLBREQ       (DMACLBREQ),
        .DMACSREQ        (DMACSREQ),
        .DMACLSREQ       (DMACLSREQ),
        .HREADYOUT       (HREADYOUT),
        .HRESP           (HRESP),
        .DmacSrcRegWrEn0 (DmacSrcRegWrEn0),
        .DmacDstRegWrEn0 (DmacDstRegWrEn0),
        .DmacLLIRegWrEn0 (DmacLLIRegWrEn0),
        .DmacCntlRegWrEn0(DmacCntlRegWrEn0),
        .DmacChCnfgWrEn0 (DmacChCnfgWrEn0),
        .DmacSrcRegWrEn1 (DmacSrcRegWrEn1),
        .DmacDstRegWrEn1 (DmacDstRegWrEn1),
        .DmacLLIRegWrEn1 (DmacLLIRegWrEn1),
        .DmacCntlRegWrEn1(DmacCntlRegWrEn1),
        .DmacChCnfgWrEn1 (DmacChCnfgWrEn1),
        .DmacSrcRegWrEn2 (DmacSrcRegWrEn2),
        .DmacDstRegWrEn2 (DmacDstRegWrEn2),
        .DmacLLIRegWrEn2 (DmacLLIRegWrEn2),
        .DmacCntlRegWrEn2(DmacCntlRegWrEn2),
        .DmacChCnfgWrEn2 (DmacChCnfgWrEn2),
        .DmacSrcRegWrEn3 (DmacSrcRegWrEn3),
        .DmacDstRegWrEn3 (DmacDstRegWrEn3),
        .DmacLLIRegWrEn3 (DmacLLIRegWrEn3),
        .DmacCntlRegWrEn3(DmacCntlRegWrEn3),
        .DmacChCnfgWrEn3 (DmacChCnfgWrEn3),
        .DmacSrcRegWrEn4 (DmacSrcRegWrEn4),
        .DmacDstRegWrEn4 (DmacDstRegWrEn4),
        .DmacLLIRegWrEn4 (DmacLLIRegWrEn4),
        .DmacCntlRegWrEn4(DmacCntlRegWrEn4),
        .DmacChCnfgWrEn4 (DmacChCnfgWrEn4),
        .DmacSrcRegWrEn5 (DmacSrcRegWrEn5),
        .DmacDstRegWrEn5 (DmacDstRegWrEn5),
        .DmacLLIRegWrEn5 (DmacLLIRegWrEn5),
        .DmacCntlRegWrEn5(DmacCntlRegWrEn5),
        .DmacChCnfgWrEn5 (DmacChCnfgWrEn5),
        .DmacSrcRegWrEn6 (DmacSrcRegWrEn6),
        .DmacDstRegWrEn6 (DmacDstRegWrEn6),
        .DmacLLIRegWrEn6 (DmacLLIRegWrEn6),
        .DmacCntlRegWrEn6(DmacCntlRegWrEn6),
        .DmacChCnfgWrEn6 (DmacChCnfgWrEn6),
        .DmacSrcRegWrEn7 (DmacSrcRegWrEn7),
        .DmacDstRegWrEn7 (DmacDstRegWrEn7),
        .DmacLLIRegWrEn7 (DmacLLIRegWrEn7),
        .DmacCntlRegWrEn7(DmacCntlRegWrEn7),
        .DmacChCnfgWrEn7 (DmacChCnfgWrEn7),
        .DMACBREQCh      (DMACBREQCh),
        .DMACLBREQCh     (DMACLBREQCh),
        .DMACSREQCh      (DMACSREQCh),
        .DMACLSREQCh     (DMACLSREQCh),
        .SOFTBREQCh      (SOFTBREQCh),
        .SOFTLBREQCh     (SOFTLBREQCh),
        .SOFTSREQCh      (SOFTSREQCh),
        .SOFTLSREQCh     (SOFTLSREQCh),
        .ClrIntErr       (ClrIntErr),
        .ClrIntTC        (ClrIntTC),
        .DMACEn          (DMACEn),
        .ReqConfig       (ReqConfig),
        .GrantCount0     (GrantCount0),
        .GrantCount1     (GrantCount1),
        .DmacTrEn        (DmacTrEn),
        .MasterEndian1   (MasterEndian1),
        .MasterEndian2   (MasterEndian2)
           );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrIntArb0
// -----------------------------------------------------------------------------
DmacTrIntArb u0DmacTrIntArb (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .Ch0Req          (Ch0ReqArb1),
        .Ch1Req          (Ch1ReqArb1),
        .Ch2Req          (Ch2ReqArb1),
        .Ch3Req          (Ch3ReqArb1),
        .Ch4Req          (Ch4ReqArb1),
        .Ch5Req          (Ch5ReqArb1),
        .Ch6Req          (Ch6ReqArb1),
        .Ch7Req          (Ch7ReqArb1),
        .StopArb         (StopArb1),
        .Ch0HWDATA       (Ch0HWDATABus1),
        .Ch1HWDATA       (Ch1HWDATABus1),
        .Ch2HWDATA       (Ch2HWDATABus1),
        .Ch3HWDATA       (Ch3HWDATABus1),
        .Ch4HWDATA       (Ch4HWDATABus1),
        .Ch5HWDATA       (Ch5HWDATABus1),
        .Ch6HWDATA       (Ch6HWDATABus1),
        .Ch7HWDATA       (Ch7HWDATABus1),
        .ReqForAhbBus    (ReqForAhbBus1),
        .HWDATA          (HWDATABus1),
        .Ch0Comb         (Ch0CombBus1),
        .Ch1Comb         (Ch1CombBus1),
        .Ch2Comb         (Ch2CombBus1),
        .Ch3Comb         (Ch3CombBus1),
        .Ch4Comb         (Ch4CombBus1),
        .Ch5Comb         (Ch5CombBus1),
        .Ch6Comb         (Ch6CombBus1),
        .Ch7Comb         (Ch7CombBus1)
           );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrIntArb1
// -----------------------------------------------------------------------------
DmacTrIntArb u1DmacTrIntArb (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .Ch0Req          (Ch0ReqArb2),
        .Ch1Req          (Ch1ReqArb2),
        .Ch2Req          (Ch2ReqArb2),
        .Ch3Req          (Ch3ReqArb2),
        .Ch4Req          (Ch4ReqArb2),
        .Ch5Req          (Ch5ReqArb2),
        .Ch6Req          (Ch6ReqArb2),
        .Ch7Req          (Ch7ReqArb2),
        .StopArb         (StopArb2),
        .Ch0HWDATA       (Ch0HWDATABus2),
        .Ch1HWDATA       (Ch1HWDATABus2),
        .Ch2HWDATA       (Ch2HWDATABus2),
        .Ch3HWDATA       (Ch3HWDATABus2),
        .Ch4HWDATA       (Ch4HWDATABus2),
        .Ch5HWDATA       (Ch5HWDATABus2),
        .Ch6HWDATA       (Ch6HWDATABus2),
        .Ch7HWDATA       (Ch7HWDATABus2),
        .ReqForAhbBus    (ReqForAhbBus2),
        .HWDATA          (HWDATABus2),
        .Ch0Comb         (Ch0CombBus2),
        .Ch1Comb         (Ch1CombBus2),
        .Ch2Comb         (Ch2CombBus2),
        .Ch3Comb         (Ch3CombBus2),
        .Ch4Comb         (Ch4CombBus2),
        .Ch5Comb         (Ch5CombBus2),
        .Ch6Comb         (Ch6CombBus2),
        .Ch7Comb         (Ch7CombBus2)
           );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrAhbMaster 1
// -----------------------------------------------------------------------------
DmacTrAhbMaster u1DmacTrAhbMaster (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HGRANTDMACM     (HGRANTDMACM1),
        .HREADYINM       (HREADYINM1),
        .HRESPM          (HRESPM1),
        .ChHLOCK         (ChHLOCKBus1),
        .ChWRITE         (ChWRITEBus1),
        .ReqForAhbBus    (ReqForAhbBus1),
        .ChHPROT         (ChHProtBus1),
        .ChHSIZE         (ChHSIZEBus1),
        .ChAddr          (ChAddrBus1),
        .ChAddrIncr      (ChAddrIncrBus1),
        .ChDisable       (ChDisableBus1),
        .ChPriority      (ChPriorityBus1),
        .ChBeatCount     (ChBeatCountBus1),
        .HWDATA          (HWDATABus1),
        .HBUSREQDMACM    (HBUSREQDMACM1),
        .HLOCKDMACM      (HLOCKDMACM1),
        .HPROTM          (HPROTM1),
        .HBURSTM         (HBURSTM1),
        .HTRANSM         (HTRANSM1),
        .HADDRM          (HADDRM1),
        .HSIZEM          (HSIZEM1),
        .HWRITEM         (HWRITEM1),
        .HWDATAM         (HWDATAM1),
        .DataValid       (DataValidBus1),
        .MREADY          (MREADY1),
        .DisAckMas       (DisAckMas1),
        .StopArb         (StopArb1),
        .ErrorMas        (ErrorMas1)
           );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrAhbMaster 2
// -----------------------------------------------------------------------------
DmacTrAhbMaster u2DmacTrAhbMaster (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HGRANTDMACM     (HGRANTDMACM2),
        .HREADYINM       (HREADYINM2),
        .HRESPM          (HRESPM2),
        .ChHLOCK         (ChHLOCKBus2),
        .ChWRITE         (ChWRITEBus2),
        .ReqForAhbBus    (ReqForAhbBus2),
        .ChHPROT         (ChHProtBus2),
        .ChHSIZE         (ChHSIZEBus2),
        .ChAddr          (ChAddrBus2),
        .ChAddrIncr      (ChAddrIncrBus2),
        .ChDisable       (ChDisableBus2),
        .ChPriority      (ChPriorityBus2),
        .ChBeatCount     (ChBeatCountBus2),
        .HWDATA          (HWDATABus2),
        .HBUSREQDMACM    (HBUSREQDMACM2),
        .HLOCKDMACM      (HLOCKDMACM2),
        .HPROTM          (HPROTM2),
        .HBURSTM         (HBURSTM2),
        .HTRANSM         (HTRANSM2),
        .HADDRM          (HADDRM2),
        .HSIZEM          (HSIZEM2),
        .HWRITEM         (HWRITEM2),
        .HWDATAM         (HWDATAM2),
        .DataValid       (DataValidBus2),
        .MREADY          (MREADY2),
        .DisAckMas       (DisAckMas2),
        .StopArb         (StopArb2),
        .ErrorMas        (ErrorMas2)
           );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrChLogic0
// -----------------------------------------------------------------------------
DmacTrChLogic u0DmacTrChLogic (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .ChComb1         (Ch0CombBus1),
        .ChComb2         (Ch0CombBus2),
        .ChSrcAddrWrEn   (DmacSrcRegWrEn0),
        .ChDstAddrWrEn   (DmacDstRegWrEn0),
        .ChControlWrEn   (DmacCntlRegWrEn0),
        .ChLLIWrEn       (DmacLLIRegWrEn0),
        .ChConfigWrEn    (DmacChCnfgWrEn0),
        .HWDATA          (HWDATA),
        .HRDATAM1        (HRDATAM1),
        .HRDATAM2        (HRDATAM2),
        .DataValid1      (DataValidBus1),
        .DataValid2      (DataValidBus2),
        .MREADY1         (MREADY1),
        .MREADY2         (MREADY2),
        .ErrorMas1       (ErrorMas1),
        .ErrorMas2       (ErrorMas2),
        .DisAckMas1      (DisAckMas1),
        .DisAckMas2      (DisAckMas2),
        .MasterEndian1   (MasterEndian1),
        .MasterEndian2   (MasterEndian2),
        .DMACBREQ        (DMACBREQCh),
        .DMACSREQ        (DMACSREQCh),
        .DMACLBREQ       (DMACLBREQCh),
        .DMACLSREQ       (DMACLSREQCh),
        .SOFTBREQ        (SOFTBREQCh),
        .SOFTLBREQ       (SOFTLBREQCh),
        .SOFTSREQ        (SOFTSREQCh),
        .SOFTLSREQ       (SOFTLSREQCh),
        .DMACEn          (DMACEn),
        .DmacTrEn        (DmacTrEn),
        .ClrIntTC        (ClrIntTC[0]),
        .ClrIntErr       (ClrIntErr[0]),
        .ChReqArb1       (Ch0ReqArb1),
        .ChReqArb2       (Ch0ReqArb2),
        .ChDisableBus1   (Ch0DisableBus1),
        .ChDisableBus2   (Ch0DisableBus2),
        .HWDATA1         (Ch0HWDATABus1),
        .HWDATA2         (Ch0HWDATABus2),
        .ChAddrBus1      (Ch0AddrBus1),
        .ChAddrBus2      (Ch0AddrBus2),
        .ChHLockBus1     (Ch0HLockBus1),
        .ChHLockBus2     (Ch0HLockBus2),
        .ChHProtBus1     (Ch0HProtBus1),
        .ChHProtBus2     (Ch0HProtBus2),
        .ChBeatCntBus1   (Ch0BeatCntBus1),
        .ChBeatCntBus2   (Ch0BeatCntBus2),
        .ChAddrIncr1     (Ch0AddrIncBus1),
        .ChAddrIncr2     (Ch0AddrIncBus2),
        .ChWRITEBus1     (Ch0WriteBus1),
        .ChWRITEBus2     (Ch0WriteBus2),
        .ChHSIZEBus1     (Ch0HSIZEBus1),
        .ChHSIZEBus2     (Ch0HSIZEBus2),
        .ChIntTC         (Ch0IntTC),
        .ChIntErr        (Ch0IntErr),
        .SOFTCLR         (Ch0SOFTCLR),
        .DMACTC          (Ch0DMACTC),
        .DMACCLR         (Ch0DMACCLR)
           );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrChLogic1
// -----------------------------------------------------------------------------
DmacTrChLogic u1DmacTrChLogic (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .ChComb1         (Ch1CombBus1),
        .ChComb2         (Ch1CombBus2),
        .ChSrcAddrWrEn   (DmacSrcRegWrEn1),
        .ChDstAddrWrEn   (DmacDstRegWrEn1),
        .ChControlWrEn   (DmacCntlRegWrEn1),
        .ChLLIWrEn       (DmacLLIRegWrEn1),
        .ChConfigWrEn    (DmacChCnfgWrEn1),
        .HWDATA          (HWDATA),
        .HRDATAM1        (HRDATAM1),
        .HRDATAM2        (HRDATAM2),
        .DataValid1      (DataValidBus1),
        .DataValid2      (DataValidBus2),
        .MREADY1         (MREADY1),
        .MREADY2         (MREADY2),
        .ErrorMas1       (ErrorMas1),
        .ErrorMas2       (ErrorMas2),
        .DisAckMas1      (DisAckMas1),
        .DisAckMas2      (DisAckMas2),
        .MasterEndian1   (MasterEndian1),
        .MasterEndian2   (MasterEndian2),
        .DMACBREQ        (DMACBREQCh),
        .DMACSREQ        (DMACSREQCh),
        .DMACLBREQ       (DMACLBREQCh),
        .DMACLSREQ       (DMACLSREQCh),
        .SOFTBREQ        (SOFTBREQCh),
        .SOFTLBREQ       (SOFTLBREQCh),
        .SOFTSREQ        (SOFTSREQCh),
        .SOFTLSREQ       (SOFTLSREQCh),
        .DMACEn          (DMACEn),
        .DmacTrEn        (DmacTrEn),
        .ClrIntTC        (ClrIntTC[1]),
        .ClrIntErr       (ClrIntErr[1]),
        .ChReqArb1       (Ch1ReqArb1),
        .ChReqArb2       (Ch1ReqArb2),
        .ChDisableBus1   (Ch1DisableBus1),
        .ChDisableBus2   (Ch1DisableBus2),
        .HWDATA1         (Ch1HWDATABus1),
        .HWDATA2         (Ch1HWDATABus2),
        .ChAddrBus1      (Ch1AddrBus1),
        .ChAddrBus2      (Ch1AddrBus2),
        .ChHLockBus1     (Ch1HLockBus1),
        .ChHLockBus2     (Ch1HLockBus2),
        .ChHProtBus1     (Ch1HProtBus1),
        .ChHProtBus2     (Ch1HProtBus2),
        .ChBeatCntBus1   (Ch1BeatCntBus1),
        .ChBeatCntBus2   (Ch1BeatCntBus2),
        .ChAddrIncr1     (Ch1AddrIncBus1),
        .ChAddrIncr2     (Ch1AddrIncBus2),
        .ChWRITEBus1     (Ch1WriteBus1),
        .ChWRITEBus2     (Ch1WriteBus2),
        .ChHSIZEBus1     (Ch1HSIZEBus1),
        .ChHSIZEBus2     (Ch1HSIZEBus2),
        .ChIntTC         (Ch1IntTC),
        .ChIntErr        (Ch1IntErr),
        .SOFTCLR         (Ch1SOFTCLR),
        .DMACTC          (Ch1DMACTC),
        .DMACCLR         (Ch1DMACCLR)
           );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrChLogic2
// -----------------------------------------------------------------------------
DmacTrChLogic u2DmacTrChLogic (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .ChComb1         (Ch2CombBus1),
        .ChComb2         (Ch2CombBus2),
        .ChSrcAddrWrEn   (DmacSrcRegWrEn2),
        .ChDstAddrWrEn   (DmacDstRegWrEn2),
        .ChControlWrEn   (DmacCntlRegWrEn2),
        .ChLLIWrEn       (DmacLLIRegWrEn2),
        .ChConfigWrEn    (DmacChCnfgWrEn2),
        .HWDATA          (HWDATA),
        .HRDATAM1        (HRDATAM1),
        .HRDATAM2        (HRDATAM2),
        .DataValid1      (DataValidBus1),
        .DataValid2      (DataValidBus2),
        .MREADY1         (MREADY1),
        .MREADY2         (MREADY2),
        .ErrorMas1       (ErrorMas1),
        .ErrorMas2       (ErrorMas2),
        .DisAckMas1      (DisAckMas1),
        .DisAckMas2      (DisAckMas2),
        .MasterEndian1   (MasterEndian1),
        .MasterEndian2   (MasterEndian2),
        .DMACBREQ        (DMACBREQCh),
        .DMACSREQ        (DMACSREQCh),
        .DMACLBREQ       (DMACLBREQCh),
        .DMACLSREQ       (DMACLSREQCh),
        .SOFTBREQ        (SOFTBREQCh),
        .SOFTLBREQ       (SOFTLBREQCh),
        .SOFTSREQ        (SOFTSREQCh),
        .SOFTLSREQ       (SOFTLSREQCh),
        .DMACEn          (DMACEn),
        .DmacTrEn        (DmacTrEn),
        .ClrIntTC        (ClrIntTC[2]),
        .ClrIntErr       (ClrIntErr[2]),
        .ChReqArb1       (Ch2ReqArb1),
        .ChReqArb2       (Ch2ReqArb2),
        .ChDisableBus1   (Ch2DisableBus1),
        .ChDisableBus2   (Ch2DisableBus2),
        .HWDATA1         (Ch2HWDATABus1),
        .HWDATA2         (Ch2HWDATABus2),
        .ChAddrBus1      (Ch2AddrBus1),
        .ChAddrBus2      (Ch2AddrBus2),
        .ChHLockBus1     (Ch2HLockBus1),
        .ChHLockBus2     (Ch2HLockBus2),
        .ChHProtBus1     (Ch2HProtBus1),
        .ChHProtBus2     (Ch2HProtBus2),
        .ChBeatCntBus1   (Ch2BeatCntBus1),
        .ChBeatCntBus2   (Ch2BeatCntBus2),
        .ChAddrIncr1     (Ch2AddrIncBus1),
        .ChAddrIncr2     (Ch2AddrIncBus2),
        .ChWRITEBus1     (Ch2WriteBus1),
        .ChWRITEBus2     (Ch2WriteBus2),
        .ChHSIZEBus1     (Ch2HSIZEBus1),
        .ChHSIZEBus2     (Ch2HSIZEBus2),
        .ChIntTC         (Ch2IntTC),
        .ChIntErr        (Ch2IntErr),
        .SOFTCLR         (Ch2SOFTCLR),
        .DMACTC          (Ch2DMACTC),
        .DMACCLR         (Ch2DMACCLR)
           );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrChLogic3
// -----------------------------------------------------------------------------
DmacTrChLogic u3DmacTrChLogic (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .ChComb1         (Ch3CombBus1),
        .ChComb2         (Ch3CombBus2),
        .ChSrcAddrWrEn   (DmacSrcRegWrEn3),
        .ChDstAddrWrEn   (DmacDstRegWrEn3),
        .ChControlWrEn   (DmacCntlRegWrEn3),
        .ChLLIWrEn       (DmacLLIRegWrEn3),
        .ChConfigWrEn    (DmacChCnfgWrEn3),
        .HWDATA          (HWDATA),
        .HRDATAM1        (HRDATAM1),
        .HRDATAM2        (HRDATAM2),
        .DataValid1      (DataValidBus1),
        .DataValid2      (DataValidBus2),
        .MREADY1         (MREADY1),
        .MREADY2         (MREADY2),
        .ErrorMas1       (ErrorMas1),
        .ErrorMas2       (ErrorMas2),
        .DisAckMas1      (DisAckMas1),
        .DisAckMas2      (DisAckMas2),
        .MasterEndian1   (MasterEndian1),
        .MasterEndian2   (MasterEndian2),
        .DMACBREQ        (DMACBREQCh),
        .DMACSREQ        (DMACSREQCh),
        .DMACLBREQ       (DMACLBREQCh),
        .DMACLSREQ       (DMACLSREQCh),
        .SOFTBREQ        (SOFTBREQCh),
        .SOFTLBREQ       (SOFTLBREQCh),
        .SOFTSREQ        (SOFTSREQCh),
        .SOFTLSREQ       (SOFTLSREQCh),
        .DMACEn          (DMACEn),
        .DmacTrEn        (DmacTrEn),
        .ClrIntTC        (ClrIntTC[3]),
        .ClrIntErr       (ClrIntErr[3]),
        .ChReqArb1       (Ch3ReqArb1),
        .ChReqArb2       (Ch3ReqArb2),
        .ChDisableBus1   (Ch3DisableBus1),
        .ChDisableBus2   (Ch3DisableBus2),
        .HWDATA1         (Ch3HWDATABus1),
        .HWDATA2         (Ch3HWDATABus2),
        .ChAddrBus1      (Ch3AddrBus1),
        .ChAddrBus2      (Ch3AddrBus2),
        .ChHLockBus1     (Ch3HLockBus1),
        .ChHLockBus2     (Ch3HLockBus2),
        .ChHProtBus1     (Ch3HProtBus1),
        .ChHProtBus2     (Ch3HProtBus2),
        .ChBeatCntBus1   (Ch3BeatCntBus1),
        .ChBeatCntBus2   (Ch3BeatCntBus2),
        .ChAddrIncr1     (Ch3AddrIncBus1),
        .ChAddrIncr2     (Ch3AddrIncBus2),
        .ChWRITEBus1     (Ch3WriteBus1),
        .ChWRITEBus2     (Ch3WriteBus2),
        .ChHSIZEBus1     (Ch3HSIZEBus1),
        .ChHSIZEBus2     (Ch3HSIZEBus2),
        .ChIntTC         (Ch3IntTC),
        .ChIntErr        (Ch3IntErr),
        .SOFTCLR         (Ch3SOFTCLR),
        .DMACTC          (Ch3DMACTC),
        .DMACCLR         (Ch3DMACCLR)
           );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrChLogic4
// -----------------------------------------------------------------------------
DmacTrChLogic u4DmacTrChLogic (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .ChComb1         (Ch4CombBus1),
        .ChComb2         (Ch4CombBus2),
        .ChSrcAddrWrEn   (DmacSrcRegWrEn4),
        .ChDstAddrWrEn   (DmacDstRegWrEn4),
        .ChControlWrEn   (DmacCntlRegWrEn4),
        .ChLLIWrEn       (DmacLLIRegWrEn4),
        .ChConfigWrEn    (DmacChCnfgWrEn4),
        .HWDATA          (HWDATA),
        .HRDATAM1        (HRDATAM1),
        .HRDATAM2        (HRDATAM2),
        .DataValid1      (DataValidBus1),
        .DataValid2      (DataValidBus2),
        .MREADY1         (MREADY1),
        .MREADY2         (MREADY2),
        .ErrorMas1       (ErrorMas1),
        .ErrorMas2       (ErrorMas2),
        .DisAckMas1      (DisAckMas1),
        .DisAckMas2      (DisAckMas2),
        .MasterEndian1   (MasterEndian1),
        .MasterEndian2   (MasterEndian2),
        .DMACBREQ        (DMACBREQCh),
        .DMACSREQ        (DMACSREQCh),
        .DMACLBREQ       (DMACLBREQCh),
        .DMACLSREQ       (DMACLSREQCh),
        .SOFTBREQ        (SOFTBREQCh),
        .SOFTLBREQ       (SOFTLBREQCh),
        .SOFTSREQ        (SOFTSREQCh),
        .SOFTLSREQ       (SOFTLSREQCh),
        .DMACEn          (DMACEn),
        .DmacTrEn        (DmacTrEn),
        .ClrIntTC        (ClrIntTC[4]),
        .ClrIntErr       (ClrIntErr[4]),
        .ChReqArb1       (Ch4ReqArb1),
        .ChReqArb2       (Ch4ReqArb2),
        .ChDisableBus1   (Ch4DisableBus1),
        .ChDisableBus2   (Ch4DisableBus2),
        .HWDATA1         (Ch4HWDATABus1),
        .HWDATA2         (Ch4HWDATABus2),
        .ChAddrBus1      (Ch4AddrBus1),
        .ChAddrBus2      (Ch4AddrBus2),
        .ChHLockBus1     (Ch4HLockBus1),
        .ChHLockBus2     (Ch4HLockBus2),
        .ChHProtBus1     (Ch4HProtBus1),
        .ChHProtBus2     (Ch4HProtBus2),
        .ChBeatCntBus1   (Ch4BeatCntBus1),
        .ChBeatCntBus2   (Ch4BeatCntBus2),
        .ChAddrIncr1     (Ch4AddrIncBus1),
        .ChAddrIncr2     (Ch4AddrIncBus2),
        .ChWRITEBus1     (Ch4WriteBus1),
        .ChWRITEBus2     (Ch4WriteBus2),
        .ChHSIZEBus1     (Ch4HSIZEBus1),
        .ChHSIZEBus2     (Ch4HSIZEBus2),
        .ChIntTC         (Ch4IntTC),
        .ChIntErr        (Ch4IntErr),
        .SOFTCLR         (Ch4SOFTCLR),
        .DMACTC          (Ch4DMACTC),
        .DMACCLR         (Ch4DMACCLR)
           );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrChLogic5
// -----------------------------------------------------------------------------
DmacTrChLogic u5DmacTrChLogic (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .ChComb1         (Ch5CombBus1),
        .ChComb2         (Ch5CombBus2),
        .ChSrcAddrWrEn   (DmacSrcRegWrEn5),
        .ChDstAddrWrEn   (DmacDstRegWrEn5),
        .ChControlWrEn   (DmacCntlRegWrEn5),
        .ChLLIWrEn       (DmacLLIRegWrEn5),
        .ChConfigWrEn    (DmacChCnfgWrEn5),
        .HWDATA          (HWDATA),
        .HRDATAM1        (HRDATAM1),
        .HRDATAM2        (HRDATAM2),
        .DataValid1      (DataValidBus1),
        .DataValid2      (DataValidBus2),
        .MREADY1         (MREADY1),
        .MREADY2         (MREADY2),
        .ErrorMas1       (ErrorMas1),
        .ErrorMas2       (ErrorMas2),
        .DisAckMas1      (DisAckMas1),
        .DisAckMas2      (DisAckMas2),
        .MasterEndian1   (MasterEndian1),
        .MasterEndian2   (MasterEndian2),
        .DMACBREQ        (DMACBREQCh),
        .DMACSREQ        (DMACSREQCh),
        .DMACLBREQ       (DMACLBREQCh),
        .DMACLSREQ       (DMACLSREQCh),
        .SOFTBREQ        (SOFTBREQCh),
        .SOFTLBREQ       (SOFTLBREQCh),
        .SOFTSREQ        (SOFTSREQCh),
        .SOFTLSREQ       (SOFTLSREQCh),
        .DMACEn          (DMACEn),
        .DmacTrEn        (DmacTrEn),
        .ClrIntTC        (ClrIntTC[5]),
        .ClrIntErr       (ClrIntErr[5]),
        .ChReqArb1       (Ch5ReqArb1),
        .ChReqArb2       (Ch5ReqArb2),
        .ChDisableBus1   (Ch5DisableBus1),
        .ChDisableBus2   (Ch5DisableBus2),
        .HWDATA1         (Ch5HWDATABus1),
        .HWDATA2         (Ch5HWDATABus2),
        .ChAddrBus1      (Ch5AddrBus1),
        .ChAddrBus2      (Ch5AddrBus2),
        .ChHLockBus1     (Ch5HLockBus1),
        .ChHLockBus2     (Ch5HLockBus2),
        .ChHProtBus1     (Ch5HProtBus1),
        .ChHProtBus2     (Ch5HProtBus2),
        .ChBeatCntBus1   (Ch5BeatCntBus1),
        .ChBeatCntBus2   (Ch5BeatCntBus2),
        .ChAddrIncr1     (Ch5AddrIncBus1),
        .ChAddrIncr2     (Ch5AddrIncBus2),
        .ChWRITEBus1     (Ch5WriteBus1),
        .ChWRITEBus2     (Ch5WriteBus2),
        .ChHSIZEBus1     (Ch5HSIZEBus1),
        .ChHSIZEBus2     (Ch5HSIZEBus2),
        .ChIntTC         (Ch5IntTC),
        .ChIntErr        (Ch5IntErr),
        .SOFTCLR         (Ch5SOFTCLR),
        .DMACTC          (Ch5DMACTC),
        .DMACCLR         (Ch5DMACCLR)
           );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrChLogic6
// -----------------------------------------------------------------------------
DmacTrChLogic u6DmacTrChLogic (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .ChComb1         (Ch6CombBus1),
        .ChComb2         (Ch6CombBus2),
        .ChSrcAddrWrEn   (DmacSrcRegWrEn6),
        .ChDstAddrWrEn   (DmacDstRegWrEn6),
        .ChControlWrEn   (DmacCntlRegWrEn6),
        .ChLLIWrEn       (DmacLLIRegWrEn6),
        .ChConfigWrEn    (DmacChCnfgWrEn6),
        .HWDATA          (HWDATA),
        .HRDATAM1        (HRDATAM1),
        .HRDATAM2        (HRDATAM2),
        .DataValid1      (DataValidBus1),
        .DataValid2      (DataValidBus2),
        .MREADY1         (MREADY1),
        .MREADY2         (MREADY2),
        .ErrorMas1       (ErrorMas1),
        .ErrorMas2       (ErrorMas2),
        .DisAckMas1      (DisAckMas1),
        .DisAckMas2      (DisAckMas2),
        .MasterEndian1   (MasterEndian1),
        .MasterEndian2   (MasterEndian2),
        .DMACBREQ        (DMACBREQCh),
        .DMACSREQ        (DMACSREQCh),
        .DMACLBREQ       (DMACLBREQCh),
        .DMACLSREQ       (DMACLSREQCh),
        .SOFTBREQ        (SOFTBREQCh),
        .SOFTLBREQ       (SOFTLBREQCh),
        .SOFTSREQ        (SOFTSREQCh),
        .SOFTLSREQ       (SOFTLSREQCh),
        .DMACEn          (DMACEn),
        .DmacTrEn        (DmacTrEn),
        .ClrIntTC        (ClrIntTC[6]),
        .ClrIntErr       (ClrIntErr[6]),
        .ChReqArb1       (Ch6ReqArb1),
        .ChReqArb2       (Ch6ReqArb2),
        .ChDisableBus1   (Ch6DisableBus1),
        .ChDisableBus2   (Ch6DisableBus2),
        .HWDATA1         (Ch6HWDATABus1),
        .HWDATA2         (Ch6HWDATABus2),
        .ChAddrBus1      (Ch6AddrBus1),
        .ChAddrBus2      (Ch6AddrBus2),
        .ChHLockBus1     (Ch6HLockBus1),
        .ChHLockBus2     (Ch6HLockBus2),
        .ChHProtBus1     (Ch6HProtBus1),
        .ChHProtBus2     (Ch6HProtBus2),
        .ChBeatCntBus1   (Ch6BeatCntBus1),
        .ChBeatCntBus2   (Ch6BeatCntBus2),
        .ChAddrIncr1     (Ch6AddrIncBus1),
        .ChAddrIncr2     (Ch6AddrIncBus2),
        .ChWRITEBus1     (Ch6WriteBus1),
        .ChWRITEBus2     (Ch6WriteBus2),
        .ChHSIZEBus1     (Ch6HSIZEBus1),
        .ChHSIZEBus2     (Ch6HSIZEBus2),
        .ChIntTC         (Ch6IntTC),
        .ChIntErr        (Ch6IntErr),
        .SOFTCLR         (Ch6SOFTCLR),
        .DMACTC          (Ch6DMACTC),
        .DMACCLR         (Ch6DMACCLR)
           );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrChLogic7
// -----------------------------------------------------------------------------
DmacTrChLogic u7DmacTrChLogic (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .ChComb1         (Ch7CombBus1),
        .ChComb2         (Ch7CombBus2),
        .ChSrcAddrWrEn   (DmacSrcRegWrEn7),
        .ChDstAddrWrEn   (DmacDstRegWrEn7),
        .ChControlWrEn   (DmacCntlRegWrEn7),
        .ChLLIWrEn       (DmacLLIRegWrEn7),
        .ChConfigWrEn    (DmacChCnfgWrEn7),
        .HWDATA          (HWDATA),
        .HRDATAM1        (HRDATAM1),
        .HRDATAM2        (HRDATAM2),
        .DataValid1      (DataValidBus1),
        .DataValid2      (DataValidBus2),
        .MREADY1         (MREADY1),
        .MREADY2         (MREADY2),
        .ErrorMas1       (ErrorMas1),
        .ErrorMas2       (ErrorMas2),
        .DisAckMas1      (DisAckMas1),
        .DisAckMas2      (DisAckMas2),
        .MasterEndian1   (MasterEndian1),
        .MasterEndian2   (MasterEndian2),
        .DMACBREQ        (DMACBREQCh),
        .DMACSREQ        (DMACSREQCh),
        .DMACLBREQ       (DMACLBREQCh),
        .DMACLSREQ       (DMACLSREQCh),
        .SOFTBREQ        (SOFTBREQCh),
        .SOFTLBREQ       (SOFTLBREQCh),
        .SOFTSREQ        (SOFTSREQCh),
        .SOFTLSREQ       (SOFTLSREQCh),
        .DMACEn          (DMACEn),
        .DmacTrEn        (DmacTrEn),
        .ClrIntTC        (ClrIntTC[7]),
        .ClrIntErr       (ClrIntErr[7]),
        .ChReqArb1       (Ch7ReqArb1),
        .ChReqArb2       (Ch7ReqArb2),
        .ChDisableBus1   (Ch7DisableBus1),
        .ChDisableBus2   (Ch7DisableBus2),
        .HWDATA1         (Ch7HWDATABus1),
        .HWDATA2         (Ch7HWDATABus2),
        .ChAddrBus1      (Ch7AddrBus1),
        .ChAddrBus2      (Ch7AddrBus2),
        .ChHLockBus1     (Ch7HLockBus1),
        .ChHLockBus2     (Ch7HLockBus2),
        .ChHProtBus1     (Ch7HProtBus1),
        .ChHProtBus2     (Ch7HProtBus2),
        .ChBeatCntBus1   (Ch7BeatCntBus1),
        .ChBeatCntBus2   (Ch7BeatCntBus2),
        .ChAddrIncr1     (Ch7AddrIncBus1),
        .ChAddrIncr2     (Ch7AddrIncBus2),
        .ChWRITEBus1     (Ch7WriteBus1),
        .ChWRITEBus2     (Ch7WriteBus2),
        .ChHSIZEBus1     (Ch7HSIZEBus1),
        .ChHSIZEBus2     (Ch7HSIZEBus2),
        .ChIntTC         (Ch7IntTC),
        .ChIntErr        (Ch7IntErr),
        .SOFTCLR         (Ch7SOFTCLR),
        .DMACTC          (Ch7DMACTC),
        .DMACCLR         (Ch7DMACCLR)
           );
// -----------------------------------------------------------------------------
// Instantiation of DmacTrRouter
// -----------------------------------------------------------------------------
DmacTrRouter uDmacTrRouter (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .Ch0Arb1Comb     (Ch0CombBus1),
        .Ch1Arb1Comb     (Ch1CombBus1),
        .Ch2Arb1Comb     (Ch2CombBus1),
        .Ch3Arb1Comb     (Ch3CombBus1),
        .Ch4Arb1Comb     (Ch4CombBus1),
        .Ch5Arb1Comb     (Ch5CombBus1),
        .Ch6Arb1Comb     (Ch6CombBus1),
        .Ch7Arb1Comb     (Ch7CombBus1),
        .Ch0Arb2Comb     (Ch0CombBus2),
        .Ch1Arb2Comb     (Ch1CombBus2),
        .Ch2Arb2Comb     (Ch2CombBus2),
        .Ch3Arb2Comb     (Ch3CombBus2),
        .Ch4Arb2Comb     (Ch4CombBus2),
        .Ch5Arb2Comb     (Ch5CombBus2),
        .Ch6Arb2Comb     (Ch6CombBus2),
        .Ch7Arb2Comb     (Ch7CombBus2),
        .Ch0AddrBus1     (Ch0AddrBus1),
        .Ch1AddrBus1     (Ch1AddrBus1),
        .Ch2AddrBus1     (Ch2AddrBus1),
        .Ch3AddrBus1     (Ch3AddrBus1),
        .Ch4AddrBus1     (Ch4AddrBus1),
        .Ch5AddrBus1     (Ch5AddrBus1),
        .Ch6AddrBus1     (Ch6AddrBus1),
        .Ch7AddrBus1     (Ch7AddrBus1),
        .Ch0AddrBus2     (Ch0AddrBus2),
        .Ch1AddrBus2     (Ch1AddrBus2),
        .Ch2AddrBus2     (Ch2AddrBus2),
        .Ch3AddrBus2     (Ch3AddrBus2),
        .Ch4AddrBus2     (Ch4AddrBus2),
        .Ch5AddrBus2     (Ch5AddrBus2),
        .Ch6AddrBus2     (Ch6AddrBus2),
        .Ch7AddrBus2     (Ch7AddrBus2),
        .Ch0HProtBus1    (Ch0HProtBus1),
        .Ch1HProtBus1    (Ch1HProtBus1),
        .Ch2HProtBus1    (Ch2HProtBus1),
        .Ch3HProtBus1    (Ch3HProtBus1),
        .Ch4HProtBus1    (Ch4HProtBus1),
        .Ch5HProtBus1    (Ch5HProtBus1),
        .Ch6HProtBus1    (Ch6HProtBus1),
        .Ch7HProtBus1    (Ch7HProtBus1),
        .Ch0HProtBus2    (Ch0HProtBus2),
        .Ch1HProtBus2    (Ch1HProtBus2),
        .Ch2HProtBus2    (Ch2HProtBus2),
        .Ch3HProtBus2    (Ch3HProtBus2),
        .Ch4HProtBus2    (Ch4HProtBus2),
        .Ch5HProtBus2    (Ch5HProtBus2),
        .Ch6HProtBus2    (Ch6HProtBus2),
        .Ch7HProtBus2    (Ch7HProtBus2),
        .Ch0HLockBus1    (Ch0HLockBus1),
        .Ch1HLockBus1    (Ch1HLockBus1),
        .Ch2HLockBus1    (Ch2HLockBus1),
        .Ch3HLockBus1    (Ch3HLockBus1),
        .Ch4HLockBus1    (Ch4HLockBus1),
        .Ch5HLockBus1    (Ch5HLockBus1),
        .Ch6HLockBus1    (Ch6HLockBus1),
        .Ch7HLockBus1    (Ch7HLockBus1),
        .Ch0HLockBus2    (Ch0HLockBus2),
        .Ch1HLockBus2    (Ch1HLockBus2),
        .Ch2HLockBus2    (Ch2HLockBus2),
        .Ch3HLockBus2    (Ch3HLockBus2),
        .Ch4HLockBus2    (Ch4HLockBus2),
        .Ch5HLockBus2    (Ch5HLockBus2),
        .Ch6HLockBus2    (Ch6HLockBus2),
        .Ch7HLockBus2    (Ch7HLockBus2),
        .Ch0AddrIncBus1  (Ch0AddrIncBus1),
        .Ch1AddrIncBus1  (Ch1AddrIncBus1),
        .Ch2AddrIncBus1  (Ch2AddrIncBus1),
        .Ch3AddrIncBus1  (Ch3AddrIncBus1),
        .Ch4AddrIncBus1  (Ch4AddrIncBus1),
        .Ch5AddrIncBus1  (Ch5AddrIncBus1),
        .Ch6AddrIncBus1  (Ch6AddrIncBus1),
        .Ch7AddrIncBus1  (Ch7AddrIncBus1),
        .Ch0AddrIncBus2  (Ch0AddrIncBus2),
        .Ch1AddrIncBus2  (Ch1AddrIncBus2),
        .Ch2AddrIncBus2  (Ch2AddrIncBus2),
        .Ch3AddrIncBus2  (Ch3AddrIncBus2),
        .Ch4AddrIncBus2  (Ch4AddrIncBus2),
        .Ch5AddrIncBus2  (Ch5AddrIncBus2),
        .Ch6AddrIncBus2  (Ch6AddrIncBus2),
        .Ch7AddrIncBus2  (Ch7AddrIncBus2),
        .Ch0DisableBus1  (Ch0DisableBus1),
        .Ch1DisableBus1  (Ch1DisableBus1),
        .Ch2DisableBus1  (Ch2DisableBus1),
        .Ch3DisableBus1  (Ch3DisableBus1),
        .Ch4DisableBus1  (Ch4DisableBus1),
        .Ch5DisableBus1  (Ch5DisableBus1),
        .Ch6DisableBus1  (Ch6DisableBus1),
        .Ch7DisableBus1  (Ch7DisableBus1),
        .Ch0DisableBus2  (Ch0DisableBus2),
        .Ch1DisableBus2  (Ch1DisableBus2),
        .Ch2DisableBus2  (Ch2DisableBus2),
        .Ch3DisableBus2  (Ch3DisableBus2),
        .Ch4DisableBus2  (Ch4DisableBus2),
        .Ch5DisableBus2  (Ch5DisableBus2),
        .Ch6DisableBus2  (Ch6DisableBus2),
        .Ch7DisableBus2  (Ch7DisableBus2),
        .Ch0BeatCntBus1  (Ch0BeatCntBus1),
        .Ch1BeatCntBus1  (Ch1BeatCntBus1),
        .Ch2BeatCntBus1  (Ch2BeatCntBus1),
        .Ch3BeatCntBus1  (Ch3BeatCntBus1),
        .Ch4BeatCntBus1  (Ch4BeatCntBus1),
        .Ch5BeatCntBus1  (Ch5BeatCntBus1),
        .Ch6BeatCntBus1  (Ch6BeatCntBus1),
        .Ch7BeatCntBus1  (Ch7BeatCntBus1),
        .Ch0BeatCntBus2  (Ch0BeatCntBus2),
        .Ch1BeatCntBus2  (Ch1BeatCntBus2),
        .Ch2BeatCntBus2  (Ch2BeatCntBus2),
        .Ch3BeatCntBus2  (Ch3BeatCntBus2),
        .Ch4BeatCntBus2  (Ch4BeatCntBus2),
        .Ch5BeatCntBus2  (Ch5BeatCntBus2),
        .Ch6BeatCntBus2  (Ch6BeatCntBus2),
        .Ch7BeatCntBus2  (Ch7BeatCntBus2),
        .Ch0WriteBus1    (Ch0WriteBus1),
        .Ch1WriteBus1    (Ch1WriteBus1),
        .Ch2WriteBus1    (Ch2WriteBus1),
        .Ch3WriteBus1    (Ch3WriteBus1),
        .Ch4WriteBus1    (Ch4WriteBus1),
        .Ch5WriteBus1    (Ch5WriteBus1),
        .Ch6WriteBus1    (Ch6WriteBus1),
        .Ch7WriteBus1    (Ch7WriteBus1),
        .Ch0WriteBus2    (Ch0WriteBus2),
        .Ch1WriteBus2    (Ch1WriteBus2),
        .Ch2WriteBus2    (Ch2WriteBus2),
        .Ch3WriteBus2    (Ch3WriteBus2),
        .Ch4WriteBus2    (Ch4WriteBus2),
        .Ch5WriteBus2    (Ch5WriteBus2),
        .Ch6WriteBus2    (Ch6WriteBus2),
        .Ch7WriteBus2    (Ch7WriteBus2),
        .Ch0HSIZEBus1    (Ch0HSIZEBus1),
        .Ch1HSIZEBus1    (Ch1HSIZEBus1),
        .Ch2HSIZEBus1    (Ch2HSIZEBus1),
        .Ch3HSIZEBus1    (Ch3HSIZEBus1),
        .Ch4HSIZEBus1    (Ch4HSIZEBus1),
        .Ch5HSIZEBus1    (Ch5HSIZEBus1),
        .Ch6HSIZEBus1    (Ch6HSIZEBus1),
        .Ch7HSIZEBus1    (Ch7HSIZEBus1),
        .Ch0HSIZEBus2    (Ch0HSIZEBus2),
        .Ch1HSIZEBus2    (Ch1HSIZEBus2),
        .Ch2HSIZEBus2    (Ch2HSIZEBus2),
        .Ch3HSIZEBus2    (Ch3HSIZEBus2),
        .Ch4HSIZEBus2    (Ch4HSIZEBus2),
        .Ch5HSIZEBus2    (Ch5HSIZEBus2),
        .Ch6HSIZEBus2    (Ch6HSIZEBus2),
        .Ch7HSIZEBus2    (Ch7HSIZEBus2),
        .StopArb1        (StopArb1),
        .StopArb2        (StopArb2),
        .Ch0SOFTCLR      (Ch0SOFTCLR),
        .Ch1SOFTCLR      (Ch1SOFTCLR),
        .Ch2SOFTCLR      (Ch2SOFTCLR),
        .Ch3SOFTCLR      (Ch3SOFTCLR),
        .Ch4SOFTCLR      (Ch4SOFTCLR),
        .Ch5SOFTCLR      (Ch5SOFTCLR),
        .Ch6SOFTCLR      (Ch6SOFTCLR),
        .Ch7SOFTCLR      (Ch7SOFTCLR),
        .Ch0DMACTC       (Ch0DMACTC),
        .Ch1DMACTC       (Ch1DMACTC),
        .Ch2DMACTC       (Ch2DMACTC),
        .Ch3DMACTC       (Ch3DMACTC),
        .Ch4DMACTC       (Ch4DMACTC),
        .Ch5DMACTC       (Ch5DMACTC),
        .Ch6DMACTC       (Ch6DMACTC),
        .Ch7DMACTC       (Ch7DMACTC),
        .Ch0DMACCLR      (Ch0DMACCLR),
        .Ch1DMACCLR      (Ch1DMACCLR),
        .Ch2DMACCLR      (Ch2DMACCLR),
        .Ch3DMACCLR      (Ch3DMACCLR),
        .Ch4DMACCLR      (Ch4DMACCLR),
        .Ch5DMACCLR      (Ch5DMACCLR),
        .Ch6DMACCLR      (Ch6DMACCLR),
        .Ch7DMACCLR      (Ch7DMACCLR),
        .ChHLOCKBus1     (ChHLOCKBus1),
        .ChHLOCKBus2     (ChHLOCKBus2),
        .ChWRITEBus1     (ChWRITEBus1),
        .ChWRITEBus2     (ChWRITEBus2),
        .ChAddrIncrBus1  (ChAddrIncrBus1),
        .ChAddrIncrBus2  (ChAddrIncrBus2),
        .ChDisableBus1   (ChDisableBus1),
        .ChDisableBus2   (ChDisableBus2),
        .ChPriorityBus1  (ChPriorityBus1),
        .ChPriorityBus2  (ChPriorityBus2),
        .ChHProtBus1     (ChHProtBus1),
        .ChHProtBus2     (ChHProtBus2),
        .ChHSIZEBus1     (ChHSIZEBus1),
        .ChHSIZEBus2     (ChHSIZEBus2),
        .ChAddrBus1      (ChAddrBus1),
        .ChAddrBus2      (ChAddrBus2),
        .ChBeatCountBus1 (ChBeatCountBus1),
        .ChBeatCountBus2 (ChBeatCountBus2),
        .SOFTCLR         (SOFTCLR),
        .DMACCLR         (iDMACCLR),
        .DMACTC          (DMACTC)
           );

// -----------------------------------------------------------------------------
// Assign internal copies of signals to output ports
// -----------------------------------------------------------------------------
assign DMACCLR          = iDMACCLR;
assign DMACINTTC        = iDMACINTTC;
assign DMACINTR         = iDMACINTR;
assign DMACINTERR       = iDMACINTERR;

// -----------------------------------------------------------------------------
// ORing of INTTC and INTERR from 8 Channels
// -----------------------------------------------------------------------------
assign iDMACINTTC       = Ch0IntTC | Ch1IntTC | Ch2IntTC | Ch3IntTC | Ch4IntTC |
                          Ch5IntTC | Ch6IntTC | Ch7IntTC;

assign iDMACINTERR      = Ch0IntErr | Ch1IntErr | Ch2IntErr | Ch3IntErr |
                          Ch4IntErr | Ch5IntErr | Ch6IntErr | Ch7IntErr;
// -----------------------------------------------------------------------------
// ORing of INTTC and INTERR
// -----------------------------------------------------------------------------
assign iDMACINTR        = iDMACINTTC | iDMACINTERR;

endmodule
// --================================== End ==================================--
