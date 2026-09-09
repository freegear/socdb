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
// File Name              : DmacTrick.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block is the top level of the Dmac Trickbox.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacTrick (
// Inputs
                  // Clock and reset
                  HCLK,
                  HRESETn,
                  // AHB slave signals
                  HSELDMAC,
                  HSELDMACTr,
                  HWRITE,
                  HTRANS,
                  HADDR,
                  HSIZE,
                  HREADYIN,
                  HREADYINM,
                  HWDATA,
                  HRESPMBeh,
                  HRDATAMBeh,
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

// Outputs
                  // AHB master signals
                  HREADYOUT,
                  HRESP,
                  HRDATA,
                  HGRANTDMACM,
                  HREADYOUTM,
                  HRESPM,
                  HRDATAM,
                  // DMA request signals
                  DMACBREQ,
                  DMACLBREQ,
                  DMACSREQ,
                  DMACLSREQ
                  );

// Inputs

// Clock and reset
input         HCLK;             // AHB clock
input         HRESETn;          // AHB reset
// AHB slave signals
input         HSELDMAC;         // Slave Select for DMAC from AHB3
input         HSELDMACTr;       // Trickbox Select from AHB3
input         HWRITE;           // Transfer direction
input         HTRANS;           // Type of transfer on AHB Only HTRANS(1) of the
                                // slave AHB should connect
input  [20:2] HADDR;            // AHB address bus
input   [2:0] HSIZE;            // The width of the transfer on AHB3
input         HREADYIN;         // Transfer done response on AHB3
input         HREADYINM;       // Transfer done response on AHB1
input  [31:0] HWDATA;           // AHB slave write data
input   [1:0] HRESPMBeh;       // Response on AHB1
input  [31:0] HRDATAMBeh;      // Data on AHB1
// AHB master signals
input         HBUSREQDMACM;    // Bus request signal to AHB1
input         HLOCKDMACM;      // HLOCK signal as driven by AHB1
input   [1:0] HTRANSM;         // Type of transfer on AHB1
input  [31:0] HADDRM;          // AHB1 address bus
input   [2:0] HSIZEM;          // Width of transfer on AHB1
input   [2:0] HBURSTM;         // Burst length on AHB1
input   [3:0] HPROTM;          // Protection information on AHB1
input         HWRITEM;         // Transfer direction on AHB1
input  [31:0] HWDATAM;         // Write data on AHB1
// DMA response signals
input  [15:0] DMACCLR;          // DMA request clear
input  [15:0] DMACTC;           // DMA terminal count
// DMA interrupt request signals
input         DMACINTERR;       // DMA error interrupt request
input         DMACINTTC;        // DMA terminal count interrupt request
input         DMACINTR;         // DMA combined interrupt request

// Outputs
// AHB master signals
output        HREADYOUT;        // Transfer done response for AHB3
output  [1:0] HRESP;            // Transfer response for AHB3
output [31:0] HRDATA;           // Read Data for AHB 3
output        HGRANTDMACM;     // AHB bus grant for master1
output        HREADYOUTM;      // Transfer done response for AHB1
output  [1:0] HRESPM;          // Transfer response for AHB1
output [31:0] HRDATAM;         // Read Data for AHB1 Master
// DMA request signals
output [15:0] DMACBREQ;         // DMA burst transfer request
output [15:0] DMACLBREQ;        // DMA last burst transfer request
output [15:0] DMACSREQ;         // DMA single transfer request
output [15:0] DMACLSREQ;        // DMA last single transfer request

// Inputs
// Clock and reset
wire          HCLK;             // AHB clock
wire          HRESETn;          // AHB reset
// AHB slave signals
wire          HSELDMAC;         // Slave Select for DMAC from AHB3
wire          HSELDMACTr;       // Trickbox Select from AHB3
wire          HWRITE;           // Transfer direction
wire          HTRANS;           // Type of transfer on AHB Only HTRANS(1) of the
                                // slave AHB should connect
wire   [20:2] HADDR;            // AHB address bus
wire    [2:0] HSIZE;            // The width of the transfer on AHB3
wire          HREADYIN;         // Transfer done response on AHB3
wire          HREADYINM;       // Transfer done response on AHB1
wire   [31:0] HWDATA;           // AHB slave write data
wire    [1:0] HRESPMBeh;       // Response on AHB1
wire   [31:0] HRDATAMBeh;      // Data on AHB1
// AHB master signals
wire          HBUSREQDMACM;    // Bus request signal to AHB1
wire          HLOCKDMACM;      // HLOCK signal as driven by AHB1
wire    [1:0] HTRANSM;         // Type of transfer on AHB1
wire   [31:0] HADDRM;          // AHB1 address bus
wire    [2:0] HSIZEM;          // Width of transfer on AHB1
wire    [2:0] HBURSTM;         // Burst length on AHB1
wire    [3:0] HPROTM;          // Protection information on AHB1
wire          HWRITEM;         // Transfer direction on AHB1
wire   [31:0] HWDATAM;         // Write data on AHB1
// DMA response signals
wire   [15:0] DMACCLR;          // DMA request clear
wire   [15:0] DMACTC;           // DMA terminal count
// DMA interrupt request signals
wire          DMACINTERR;       // DMA error interrupt request
wire          DMACINTTC;        // DMA terminal count interrupt request
wire          DMACINTR;         // DMA combined interrupt request

// Outputs
// AHB master signals
reg           HREADYOUT;        // Transfer done response for AHB3
reg     [1:0] HRESP;            // Transfer response for AHB3
reg    [31:0] HRDATA;           // Read Data for AHB 3
wire          HGRANTDMACM;     // AHB bus grant for master1
wire          HREADYOUTM;      // Transfer done response for AHB1
wire    [1:0] HRESPM;          // Transfer response for AHB1
wire   [31:0] HRDATAM;         // Read Data for AHB1 Master
// DMA request signals
wire   [15:0] DMACBREQ;         // DMA burst transfer request
wire   [15:0] DMACLBREQ;        // DMA last burst transfer request
wire   [15:0] DMACSREQ;         // DMA single transfer request
wire   [15:0] DMACLSREQ;        // DMA last single transfer request

// Removed/renamed ports at the top level are modified over here.
// For master1 related unused signals
wire          HREADYINM1;
wire    [1:0] HRESPM1Beh;
wire   [31:0] HRDATAM1Beh;
wire          HBUSREQDMACM1;
wire          HLOCKDMACM1;
wire    [1:0] HTRANSM1;
wire   [31:0] HADDRM1;
wire    [2:0] HSIZEM1;
wire    [2:0] HBURSTM1;
wire    [3:0] HPROTM1;
wire          HWRITEM1;
wire   [31:0] HWDATAM1;
reg           HREADYOUTM1;
wire          HGRANTDMACM1;
reg     [1:0] HRESPM1;
reg    [31:0] HRDATAM1;

// For master2 related unused signals
wire          HREADYINM2;
wire    [1:0] HRESPM2Beh;
wire   [31:0] HRDATAM2Beh;
wire          HBUSREQDMACM2;
wire          HLOCKDMACM2;
wire    [1:0] HTRANSM2;
wire   [31:0] HADDRM2;
wire    [2:0] HSIZEM2;
wire    [2:0] HBURSTM2;
wire    [3:0] HPROTM2;
wire          HWRITEM2;
wire   [31:0] HWDATAM2;
reg           HREADYOUTM2;
wire          HGRANTDMACM2;
reg     [1:0] HRESPM2;
reg    [31:0] HRDATAM2;

wire   [31:0] ZEROFILL = 'b0;

// -----------------------------------------------------------------------------
// Package insertion
// -----------------------------------------------------------------------------
`include "DmacTrParams.v"

// -----------------------------------------------------------------------------
//
//                              DmacTrick
//                              =========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block is the top level of the Trickbox. This block instantiates the
// following functional sub-blocks in the trickbox.
//      - DmacTrBehaviour
//      - DmacTrProChkr
//      - DmacTrPeriph
//      - DmacTrMem
//      - DmacTrGntGen
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire          HSELDMACTrSlave;
// Slave Select for Trickbox

wire          HBUSREQM1Tr;
// Bus req signal to the AHB Arb1

wire          HBUSREQM2Tr;
// Bus req signal to the AHB Arb2

wire          HLOCKM1Tr;
// Indicates locked transfer on AHB1

wire          HLOCKM2Tr;
// Indicates locked transfer on AHB2

wire    [1:0] HTRANSM1Tr;
// Type of transfer on AHB1

wire    [1:0] HTRANSM2Tr;
// Type of transfer on AHB2

wire   [31:0] HADDRM1Tr;
// AHB1 address bus

wire   [31:0] HADDRM2Tr;
// AHB2 address bus

wire    [2:0] HSIZEM1Tr;
// Width of transfer on AHB1

wire    [2:0] HSIZEM2Tr;
// Width of transfer on AHB2

wire    [2:0] HBURSTM1Tr;
// Burst length on AHB1

wire    [2:0] HBURSTM2Tr;
// Burst length on AHB2

wire    [3:0] HPROTM1Tr;
// Protection information on AHB1

wire    [3:0] HPROTM2Tr;
// Protection information on AHB2

wire          HWRITEM1Tr;
// Transfer direction on AHB1

wire          HWRITEM2Tr;
// Transfer direction on AHB2

wire   [31:0] HWDATAM1Tr;
// Write data to AHB1

wire   [31:0] HWDATAM2Tr;
// Write data to AHB2

wire   [15:0] DMACCLRTr;
// DMAC request clear

wire   [15:0] DMACTCTr;
// DMAC terminal count

wire          DMACINTERRTr;
// DMAC error interrupt request

wire          DMACINTTCTr;
// DMAC terminal count interrupt

wire          DMACINTRTr;
// DMAC combined interrupt request

wire    [1:0] HTRANSIn;
// Internal copy of HTRANS

wire   [17:0] ReqConfig;
// Trickbox config Reg for Perp/Mem

wire   [31:0] GrantCount0;
// Trickbox Grant Generation Reg used by AHB Arbiter0

wire   [31:0] GrantCount1;
// Trickbox Grant Generation Reg used by AHB Arbiter1

wire          DmacTrEn;
// DMAC Trickbox Enable

// DmacTrickBehaviour output internal signal
wire          HREADYOUTTrIn;
wire    [1:0] HRESPTrIn;

// Memory Module0 signal
wire          HSELREGuM0;
// Register Select of Memory 0

wire          HREADYOUTuM0;
// HREAYOUT of Memory 0

wire    [1:0] HRESPuM0;
// HRESP of Memory 0

wire   [31:0] HRDATAuM0;
// HRDATA of Memory 0

wire          HSELMEMuM0;
// Memory 0 Select signal

wire          HREADYOUTMuM0;
// HREADYOUTM of Memory 0

wire    [1:0] HRESPMuM0;
// HRESPM of Memory 0

wire   [31:0] HRDATAMuM0;
// Read Data of Memory 0

// Memory Module1 signal
wire          HSELREGuM1;
// Register Select of Memory 1

wire          HREADYOUTuM1;
// HREAYOUT of Memory 1

wire    [1:0] HRESPuM1;
// HRESP of Memory 1

wire   [31:0] HRDATAuM1;
// HRDATA of Memory 1

wire          HSELMEMuM1;
// Memory 1 Select signal

wire          HREADYOUTMuM1;
// HREADYOUTM of Memory 1

wire    [1:0] HRESPMuM1;
// HRESPM of Memory 1

wire   [31:0] HRDATAMuM1;
// Read Data of Memory 1

// Peripheral Module1 signal
wire          HSELREGuP0;
// Register Select of Peripheral 0

wire          HREADYOUTuP0;
// HREAYOUT of Peripheral 0

wire    [1:0] HRESPuP0;
// HRESP of Peripheral 0

wire   [31:0] HRDATAuP0;
// HRDATA of Peripheral 0

wire          HSELPERIPHuP0;
// Peripheral 0 Select signal

wire          HREADYOUTMuP0;
// HREADYOUTM of Peripheral 0

wire    [1:0] HRESPMuP0;
// HRESPM of Peripheral 0

wire   [31:0] HRDATAMuP0;
// Read Data of Peripheral 0

// Peripheral Module1 signal
wire          HSELREGuP1;
// Register Select of Peripheral 0

wire          HREADYOUTuP1;
// HREAYOUT of Peripheral 1

wire    [1:0] HRESPuP1;
// HRESP of Peripheral 1

wire   [31:0] HRDATAuP1;
// HRDATA of Peripheral 1

wire          HSELPERIPHuP1;
// Peripheral 1 Select signal

wire          HREADYOUTMuP1;
// HREADYOUTM of Peripheral 1

wire    [1:0] HRESPMuP1;
// HRESPM of Peripheral 1

wire   [31:0] HRDATAMuP1;
// Read Data of Peripheral 1

// Peripheral Module 2 signal
wire          HSELREGuP2;
// Register Select of Peripheral 2

wire          HREADYOUTuP2;
// HREAYOUT of Peripheral 2

wire    [1:0] HRESPuP2;
// HRESP of Peripheral 2

wire   [31:0] HRDATAuP2;
// HRDATA of Peripheral 2

wire          HSELPERIPHuP2;
// Peripheral 2 Select signal

wire          HREADYOUTMuP2;
// HREADYOUTM of Peripheral 2

wire    [1:0] HRESPMuP2;
// HRESPM of Peripheral 2

wire   [31:0] HRDATAMuP2;
// Read Data of Peripheral 2

// Peripheral Module 3 signal
wire          HSELREGuP3;
// Register Select of Peripheral 3

wire          HREADYOUTuP3;
// HREAYOUT of Peripheral 3

wire    [1:0] HRESPuP3;
// HRESP of Peripheral 3

wire   [31:0] HRDATAuP3;
// HRDATA of Peripheral 3

wire          HSELPERIPHuP3;
// Peripheral 3 Select signal

wire          HREADYOUTMuP3;
// HREADYOUTM of Peripheral 3

wire    [1:0] HRESPMuP3;
// HRESPM of Peripheral 3

wire   [31:0] HRDATAMuP3;
// Read Data of Peripheral 3

// Peripheral Module 4 signal
wire          HSELREGuP4;
// Register Select of Peripheral 4

wire          HREADYOUTuP4;
// HREAYOUT of Peripheral 4

wire    [1:0] HRESPuP4;
// HRESP of Peripheral 4

wire   [31:0] HRDATAuP4;
// HRDATA of Peripheral 4

wire          HSELPERIPHuP4;
// Peripheral 4 Select signal

wire          HREADYOUTMuP4;
// HREADYOUTM of Peripheral 4

wire    [1:0] HRESPMuP4;
// HRESPM of Peripheral 4

wire   [31:0] HRDATAMuP4;
// Read Data of Peripheral 4

// Peripheral Module 5 signal
wire          HSELREGuP5;
// Register Select of Peripheral 5

wire          HREADYOUTuP5;
// HREAYOUT of Peripheral 5

wire    [1:0] HRESPuP5;
// HRESP of Peripheral 5

wire   [31:0] HRDATAuP5;
// HRDATA of Peripheral 5

wire          HSELPERIPHuP5;
// Peripheral 5 Select signal

wire          HREADYOUTMuP5;
// HREADYOUTM of Peripheral 5

wire    [1:0] HRESPMuP5;
// HRESPM of Peripheral 5

wire   [31:0] HRDATAMuP5;
// Read Data of Peripheral 5

// Peripheral Module 6 signal
wire          HSELREGuP6;
// Register Select of Peripheral 6

wire          HREADYOUTuP6;
// HREAYOUT of Peripheral 6

wire    [1:0] HRESPuP6;
// HRESP of Peripheral 6

wire   [31:0] HRDATAuP6;
// HRDATA of Peripheral 6

wire          HSELPERIPHuP6;
// Peripheral 6 Select signal

wire          HREADYOUTMuP6;
// HREADYOUTM of Peripheral 6

wire    [1:0] HRESPMuP6;
// HRESPM of Peripheral 6

wire   [31:0] HRDATAMuP6;
// Read Data of Peripheral 6

// Peripheral Module 7 signal
wire          HSELREGuP7;
// Register Select of Peripheral 7

wire          HREADYOUTuP7;
// HREAYOUT of Peripheral 7

wire    [1:0] HRESPuP7;
// HRESP of Peripheral 7

wire   [31:0] HRDATAuP7;
// HRDATA of Peripheral 7

wire          HSELPERIPHuP7;
// Peripheral 7 Select signal

wire          HREADYOUTMuP7;
// HREADYOUTM of Peripheral 7

wire    [1:0] HRESPMuP7;
// HRESPM of Peripheral 7

wire   [31:0] HRDATAMuP7;
// Read Data of Peripheral 7

// Peripheral Module 8 signal
wire          HSELREGuP8;
// Register Select of Peripheral 8

wire          HREADYOUTuP8;
// HREAYOUT of Peripheral 8

wire    [1:0] HRESPuP8;
// HRESP of Peripheral 8

wire   [31:0] HRDATAuP8;
// HRDATA of Peripheral 8

wire          HSELPERIPHuP8;
// Peripheral 8 Select signal

wire          HREADYOUTMuP8;
// HREADYOUTM of Peripheral 8

wire    [1:0] HRESPMuP8;
// HRESPM of Peripheral 8

wire   [31:0] HRDATAMuP8;
// Read Data of Peripheral 8

// Peripheral Module 9 signal
wire          HSELREGuP9;
// Register Select of Peripheral 9

wire          HREADYOUTuP9;
// HREAYOUT of Peripheral 9

wire    [1:0] HRESPuP9;
// HRESP of Peripheral 9

wire   [31:0] HRDATAuP9;
// HRDATA of Peripheral 9

wire          HSELPERIPHuP9;
// Peripheral 9 Select signal

wire          HREADYOUTMuP9;
// HREADYOUTM of Peripheral 9

wire    [1:0] HRESPMuP9;
// HRESPM of Peripheral 9

wire   [31:0] HRDATAMuP9;
// Read Data of Peripheral 9

// Peripheral Module10 signal
wire          HSELREGuP10;
// Register Select of Peripheral 10

wire          HREADYOUTuP10;
// HREAYOUT of Peripheral 10

wire    [1:0] HRESPuP10;
// HRESP of Peripheral 10

wire   [31:0] HRDATAuP10;
// HRDATA of Peripheral 10

wire          HSELPERIPHuP10;
// Peripheral 10 Select signal

wire          HREADYOUTMuP10;
// HREADYOUTM of Peripheral 10

wire    [1:0] HRESPMuP10;
// HRESPM of Peripheral 10

wire   [31:0] HRDATAMuP10;
// Read Data of Peripheral 10

// Peripheral Module 11 signal
wire          HSELREGuP11;
// Register Select of Peripheral 11

wire          HREADYOUTuP11;
// HREAYOUT of Peripheral 11

wire    [1:0] HRESPuP11;
// HRESP of Peripheral 11

wire   [31:0] HRDATAuP11;
// HRDATA of Peripheral 11

wire          HSELPERIPHuP11;
// Peripheral 11 Select signal

wire          HREADYOUTMuP11;
// HREADYOUTM of Peripheral 11

wire    [1:0] HRESPMuP11;
// HRESPM of Peripheral 11

wire   [31:0] HRDATAMuP11;
// Read Data of Peripheral 11

// Peripheral Module 12 signal
wire          HSELREGuP12;
// Register Select of Peripheral 12

wire          HREADYOUTuP12;
// HREAYOUT of Peripheral 12

wire    [1:0] HRESPuP12;
// HRESP of Peripheral 12

wire   [31:0] HRDATAuP12;
// HRDATA of Peripheral 12

wire          HSELPERIPHuP12;
// Peripheral 12 Select signal

wire          HREADYOUTMuP12;
// HREADYOUTM of Peripheral 12

wire    [1:0] HRESPMuP12;
// HRESPM of Peripheral 12

wire   [31:0] HRDATAMuP12;
// Read Data of Peripheral 12

// Peripheral Module 13 signal
wire          HSELREGuP13;
// Register Select of Peripheral 13

wire          HREADYOUTuP13;
// HREAYOUT of Peripheral 13

wire    [1:0] HRESPuP13;
// HRESP of Peripheral 13

wire   [31:0] HRDATAuP13;
// HRDATA of Peripheral 13

wire          HSELPERIPHuP13;
// Peripheral 13 Select signal

wire          HREADYOUTMuP13;
// HREADYOUTM of Peripheral 13

wire    [1:0] HRESPMuP13;
// HRESPM of Peripheral 13

wire   [31:0] HRDATAMuP13;
// Read Data of Peripheral 13

// Peripheral Module 14 signal
wire          HSELREGuP14;
// Register Select of Peripheral 14

wire          HREADYOUTuP14;
// HREAYOUT of Peripheral 14

wire    [1:0] HRESPuP14;
// HRESP of Peripheral 14

wire   [31:0] HRDATAuP14;
// HRDATA of Peripheral 14

wire          HSELPERIPHuP14;
// Peripheral 14 Select signal

wire          HREADYOUTMuP14;
// HREADYOUTM of Peripheral 14

wire    [1:0] HRESPMuP14;
// HRESPM of Peripheral 14

wire   [31:0] HRDATAMuP14;
// Read Data of Peripheral 14

// Peripheral Module 15 signal
wire          HSELREGuP15;
// Register Select of Peripheral 15

wire          HREADYOUTuP15;
// HREAYOUT of Peripheral 15

wire    [1:0] HRESPuP15;
// HRESP of Peripheral 15

wire   [31:0] HRDATAuP15;
// HRDATA of Peripheral 15

wire          HSELPERIPHuP15;
// Peripheral 15 Select signal

wire          HREADYOUTMuP15;
// HREADYOUTM of Peripheral 15

wire    [1:0] HRESPMuP15;
// HRESPM of Peripheral 15

wire   [31:0] HRDATAMuP15;
// Read Data of Peripheral 15

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuM0;
// HADDRM of Memory 0

reg          HWRITEMuM0;
// Memory 0 read/write

reg    [1:0] HTRANSMuM0;
// HTRANSM of Memory 0

reg    [2:0] HSIZEMuM0;
// HSIZEM of Memory 0

reg    [2:0] HBURSTMuM0;
// HBURSTM of Memory 0

reg   [31:0] HWDATAMuM0;
// Write Data of Memory 0

reg           HREADYINMuM0;
// HREADYINM of Memory 0

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuM1;
// HADDRM of Memory 1

reg           HWRITEMuM1;
// Memory 1 read/write

reg    [1:0] HTRANSMuM1;
// HTRANSM of Memory 1

reg    [2:0] HSIZEMuM1;
// HSIZEM of Memory 1

reg    [2:0] HBURSTMuM1;
// HBURSTM of Memory 1

reg   [31:0] HWDATAMuM1;
// Write Data of Memory 1

reg           HREADYINMuM1;
// HREADYINM of Memory 1

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP0;
// HADDRM of Peripheral 0

reg           HWRITEMuP0;
// Peripheral 0 read/write

reg    [1:0] HTRANSMuP0;
// HTRANSM of Peripheral 0

reg    [2:0] HSIZEMuP0;
// HSIZEM of Peripheral 0

reg    [2:0] HBURSTMuP0;
// HBURSTM of Peripheral 0

reg   [31:0] HWDATAMuP0;
// Write Data of Peripheral 0

reg           HREADYINMuP0;
// HREADYINM of Peripheral 0

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP1;
// HADDRM of Peripheral 1

reg           HWRITEMuP1;
// Peripheral 1 read/write

reg    [1:0] HTRANSMuP1;
// HTRANSM of Peripheral 1

reg    [2:0] HSIZEMuP1;
// HSIZEM of Peripheral 1

reg    [2:0] HBURSTMuP1;
// HBURSTM of Peripheral 1

reg   [31:0] HWDATAMuP1;
// Write Data of Peripheral 1

reg           HREADYINMuP1;
// HREADYINM of Peripheral 1

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP2;
// HADDRM of Peripheral 2

reg           HWRITEMuP2;
// Peripheral 2 read/write

reg    [1:0] HTRANSMuP2;
// HTRANSM of Peripheral 2

reg     [2:0] HSIZEMuP2;
// HSIZEM of Peripheral 2

reg     [2:0] HBURSTMuP2;
// HBURSTM of Peripheral 2

reg    [31:0] HWDATAMuP2;
// Write Data of Peripheral 2

reg           HREADYINMuP2;
// HREADYINM of Peripheral 2

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP3;
// HADDRM of Peripheral 3

reg           HWRITEMuP3;
// Peripheral 3 read/write

reg    [1:0] HTRANSMuP3;
// HTRANSM of Peripheral 3

reg      [2:0] HSIZEMuP3;
// HSIZEM of Peripheral 3

reg      [2:0] HBURSTMuP3;
// HBURSTM of Peripheral 3

reg     [31:0] HWDATAMuP3;
// Write Data of Peripheral 3

reg           HREADYINMuP3;
// HREADYINM of Peripheral 3

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP4;
// HADDRM of Peripheral 4

reg           HWRITEMuP4;
// Peripheral 4 read/write

reg     [1:0] HTRANSMuP4;
// HTRANSM of Peripheral 4

reg     [2:0] HSIZEMuP4;
// HSIZEM of Peripheral 4

reg     [2:0] HBURSTMuP4;
// HBURSTM of Peripheral 4

reg    [31:0] HWDATAMuP4;
// Write Data of Peripheral 4

reg           HREADYINMuP4;
// HREADYINM of Peripheral 4

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP5;
// HADDRM of Peripheral 5

reg           HWRITEMuP5;
// Peripheral 5 read/write

reg     [1:0] HTRANSMuP5;
// HTRANSM of Peripheral 5

reg     [2:0] HSIZEMuP5;
// HSIZEM of Peripheral 5

reg     [2:0] HBURSTMuP5;
// HBURSTM of Peripheral 5

reg    [31:0] HWDATAMuP5;
// Write Data of Peripheral 5

reg           HREADYINMuP5;
// HREADYINM of Peripheral 5

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP6;
// HADDRM of Peripheral 6

reg           HWRITEMuP6;
// Peripheral 6 read/write

reg     [1:0] HTRANSMuP6;
// HTRANSM of Peripheral 6

reg     [2:0] HSIZEMuP6;
// HSIZEM of Peripheral 6

reg     [2:0] HBURSTMuP6;
// HBURSTM of Peripheral 6

reg    [31:0] HWDATAMuP6;
// Write Data of Peripheral 6

reg           HREADYINMuP6;
// HREADYINM of Peripheral 6

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP7;
// HADDRM of Peripheral 7

reg           HWRITEMuP7;
// Peripheral 7 read/write

reg     [1:0] HTRANSMuP7;
// HTRANSM of Peripheral 7

reg     [2:0] HSIZEMuP7;
// HSIZEM of Peripheral 7

reg     [2:0] HBURSTMuP7;
// HBURSTM of Peripheral 7

reg    [31:0] HWDATAMuP7;
// Write Data of Peripheral 7

reg           HREADYINMuP7;
// HREADYINM of Peripheral 7

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP8;
// HADDRM of Peripheral 8

reg           HWRITEMuP8;
// Peripheral 8 read/write

reg     [1:0] HTRANSMuP8;
// HTRANSM of Peripheral 8

reg     [2:0] HSIZEMuP8;
// HSIZEM of Peripheral 8

reg     [2:0] HBURSTMuP8;
// HBURSTM of Peripheral 8

reg    [31:0] HWDATAMuP8;
// Write Data of Peripheral 8

reg           HREADYINMuP8;
// HREADYINM of Peripheral 8

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP9;
// HADDRM of Peripheral 9

reg           HWRITEMuP9;
// Peripheral 9 read/write

reg     [1:0] HTRANSMuP9;
// HTRANSM of Peripheral 9

reg     [2:0] HSIZEMuP9;
// HSIZEM of Peripheral 9

reg     [2:0] HBURSTMuP9;
// HBURSTM of Peripheral 9

reg    [31:0] HWDATAMuP9;
// Write Data of Peripheral 9

reg           HREADYINMuP9;
// HREADYINM of Peripheral 9

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP10;
// HADDRM of Peripheral 10

reg           HWRITEMuP10;
// Peripheral 10 read/write

reg     [1:0] HTRANSMuP10;
// HTRANSM of Peripheral 10

reg     [2:0] HSIZEMuP10;
// HSIZEM of Peripheral 10

reg     [2:0] HBURSTMuP10;
// HBURSTM of Peripheral 10

reg    [31:0] HWDATAMuP10;
// Write Data of Peripheral 10

reg           HREADYINMuP10;
// HREADYINM of Peripheral 10

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP11;
// HADDRM of Peripheral 11

reg           HWRITEMuP11;
// Peripheral 11 read/write

reg     [1:0] HTRANSMuP11;
// HTRANSM of Peripheral 11

reg     [2:0] HSIZEMuP11;
// HSIZEM of Peripheral 11

reg     [2:0] HBURSTMuP11;
// HBURSTM of Peripheral 11

reg    [31:0] HWDATAMuP11;
// Write Data of Peripheral 11

reg           HREADYINMuP11;
// HREADYINM of Peripheral 11

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP12;
// HADDRM of Peripheral 12

reg           HWRITEMuP12;
// Peripheral 12 read/write

reg     [1:0] HTRANSMuP12;
// HTRANSM of Peripheral 12

reg     [2:0] HSIZEMuP12;
// HSIZEM of Peripheral 12

reg     [2:0] HBURSTMuP12;
// HBURSTM of Peripheral 12

reg    [31:0] HWDATAMuP12;
// Write Data of Peripheral 12

reg           HREADYINMuP12;
// HREADYINM of Peripheral 12

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP13;
// HADDRM of Peripheral 13

reg           HWRITEMuP13;
// Peripheral 13 read/write

reg     [1:0] HTRANSMuP13;
// HTRANSM of Peripheral 13

reg     [2:0] HSIZEMuP13;
// HSIZEM of Peripheral 13

reg     [2:0] HBURSTMuP13;
// HBURSTM of Peripheral 13

reg    [31:0] HWDATAMuP13;
// Write Data of Peripheral 13

reg           HREADYINMuP13;
// HREADYINM of Peripheral 13

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP14;
// HADDRM of Peripheral 14

reg           HWRITEMuP14;
// Peripheral 14 read/write

reg     [1:0] HTRANSMuP14;
// HTRANSM of Peripheral 14

reg     [2:0] HSIZEMuP14;
// HSIZEM of Peripheral 14

reg     [2:0] HBURSTMuP14;
// HBURSTM of Peripheral 14

reg    [31:0] HWDATAMuP14;
// Write Data of Peripheral 14

reg           HREADYINMuP14;
// HREADYINM of Peripheral 14

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuP15;
// HADDRM of Peripheral 15

reg           HWRITEMuP15;
// Peripheral 15 read/write

reg     [1:0] HTRANSMuP15;
// HTRANSM of Peripheral 15

reg     [2:0] HSIZEMuP15;
// HSIZEM of Peripheral 15

reg     [2:0] HBURSTMuP15;
// HBURSTM of Peripheral 15

reg    [31:0] HWDATAMuP15;
// Write Data of Peripheral 15

reg           HREADYINMuP15;
// HREADYINM of Peripheral 15

reg           RegSyncTr;
// Delayed HSELDMACTrSlave

reg           RegSyncMem0;
// Delayed HSELREG of Memory 0

reg           RegSyncMem1;
// Delayed HSELREG of Memory 1

reg           RegSyncP0;
// Delayed HSELREG of Peripheral 0

reg           RegSyncP1;
// Delayed HSELREG of Peripheral 1

reg           RegSyncP2;
// Delayed HSELREG of Peripheral 2

reg           RegSyncP3;
// Delayed HSELREG of Peripheral 3

reg           RegSyncP4;
// Delayed HSELREG of Peripheral 4

reg           RegSyncP5;
// Delayed HSELREG of Peripheral 5

reg           RegSyncP6;
// Delayed HSELREG of Peripheral 6

reg           RegSyncP7;
// Delayed HSELREG of Peripheral 7

reg           RegSyncP8;
// Delayed HSELREG of Peripheral 8

reg           RegSyncP9;
// Delayed HSELREG of Peripheral 9

reg           RegSyncP10;
// Delayed HSELREG of Peripheral 10

reg           RegSyncP11;
// Delayed HSELREG of Peripheral 11

reg           RegSyncP12;
// Delayed HSELREG of Peripheral 12

reg           RegSyncP13;
// Delayed HSELREG of Peripheral 13

reg           RegSyncP14;
// Delayed HSELREG of Peripheral 14

reg           RegSyncP15;
// Delayed HSELREG of Peripheral 15

reg           SyncMem0;
// Selected State of Memory 0

reg           SyncMem1;
// Selected State of Memory 0

reg           SyncPeriph0;
// Selected State of Peripheral 0

reg           SyncPeriph1;
// Selected State of Peripheral 1

reg           SyncPeriph2;
// Selected State of Peripheral 2

reg           SyncPeriph3;
// Selected State of Peripheral 3

reg           SyncPeriph4;
// Selected State of Peripheral 4

reg           SyncPeriph5;
// Selected State of Peripheral 5

reg           SyncPeriph6;
// Selected State of Peripheral 6

reg           SyncPeriph7;
// Selected State of Peripheral 7

reg           SyncPeriph8;
// Selected State of Peripheral 8

reg           SyncPeriph9;
// Selected State of Peripheral 9

reg           SyncPeriph10;
// Selected State of Peripheral 10

reg           SyncPeriph11;
// Selected State of Peripheral 11

reg           SyncPeriph12;
// Selected State of Peripheral 12

reg           SyncPeriph13;
// Selected State of Peripheral 13

reg           SyncPeriph14;
// Selected State of Peripheral 14

reg           SyncPeriph15;
// Selected State of Peripheral 15

reg           NxtRegSyncTr;
// D input of RegSyncTr

reg           NxtRegSyncMem0;
// D input of RegSyncMem0

reg           NxtRegSyncMem1;
// D input of RegSyncMem1

reg           NxtRegSyncP0;
// D input of RegSyncP0

reg           NxtRegSyncP1;
// D input of RegSyncP1

reg           NxtRegSyncP2;
// D input of RegSyncP2

reg           NxtRegSyncP3;
// D input of RegSyncP3

reg           NxtRegSyncP4;
// D input of RegSyncP4

reg           NxtRegSyncP5;
// D input of RegSyncP5

reg           NxtRegSyncP6;
// D input of RegSyncP6

reg           NxtRegSyncP7;
// D input of RegSyncP7

reg           NxtRegSyncP8;
// D input of RegSyncP8

reg           NxtRegSyncP9;
// D input of RegSyncP9

reg           NxtRegSyncP10;
// D input of RegSyncP10

reg           NxtRegSyncP11;
// D input of RegSyncP11

reg           NxtRegSyncP12;
// D input of RegSyncP12

reg           NxtRegSyncP13;
// D input of RegSyncP13

reg           NxtRegSyncP14;
// D input of RegSyncP14

reg           NxtRegSyncP15;
// D input of RegSyncP15


reg           NxtSyncMem0;
// D input of SyncMem0

reg           NxtSyncMem1;
// D input of SyncMem1

reg           NxtSyncPeriph0;
// D input of SyncPeriph0

reg           NxtSyncPeriph1;
// D input of SyncPeriph1

reg           NxtSyncPeriph2;
// D input of SyncPeriph2

reg           NxtSyncPeriph3;
// D input of SyncPeriph3

reg           NxtSyncPeriph4;
// D input of SyncPeriph4

reg           NxtSyncPeriph5;
// D input of SyncPeriph5

reg           NxtSyncPeriph6;
// D input of SyncPeriph6

reg           NxtSyncPeriph7;
// D input of SyncPeriph7

reg           NxtSyncPeriph8;
// D input of SyncPeriph8

reg           NxtSyncPeriph9;
// D input of SyncPeriph9

reg           NxtSyncPeriph10;
// D input of SyncPeriph10

reg           NxtSyncPeriph11;
// D input of SyncPeriph11

reg           NxtSyncPeriph12;
// D input of SyncPeriph12

reg           NxtSyncPeriph13;
// D input of SyncPeriph13

reg           NxtSyncPeriph14;
// D input of SyncPeriph14

reg           NxtSyncPeriph15;
// D input of SyncPeriph15

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
// Assigning the inputs to the internal copies of the signal to keep the
// modification simple
// -----------------------------------------------------------------------------
assign HREADYINM1       = HREADYINM;
assign HRESPM1Beh       = HRESPMBeh;
assign HRDATAM1Beh      = HRDATAMBeh;
assign HBUSREQDMACM1    = HBUSREQDMACM;
assign HLOCKDMACM1      = HLOCKDMACM;
assign HTRANSM1         = HTRANSM;
assign HADDRM1          = HADDRM;
assign HSIZEM1          = HSIZEM;
assign HBURSTM1         = HBURSTM;
assign HPROTM1          = HPROTM;
assign HWRITEM1         = HWRITEM;
assign HWDATAM1         = HWDATAM;

// -----------------------------------------------------------------------------
// Assigning the internally derived outputs to the actual output ports of the
// signal to keep the modification simple
// -----------------------------------------------------------------------------
assign HGRANTDMACM      = HGRANTDMACM1;
assign HREADYOUTM       = HREADYOUTM1;
assign HRESPM           = HRESPM1;
assign HRDATAM          = HRDATAM1;


// -----------------------------------------------------------------------------
// Assignment of internal signals
// -----------------------------------------------------------------------------
assign HTRANSIn         = {HTRANS, 1'b0};

// -----------------------------------------------------------------------------
// Select signal generation
// -----------------------------------------------------------------------------
// Generation of DMAC Trickbox Slave Select
assign HSELDMACTrSlave  = ((HADDR[20:16] == 5'b00000) & (HSELDMACTr == 1'b1)) ?
                           1'b1 : 1'b0;

// Memory 0 Register Select generation
assign HSELREGuM0       = (HADDR[20:16] == 5'b00001 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Memory 1 Register Select generation
assign HSELREGuM1       = (HADDR[20:16] == 5'b00010 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;


// Peripheral 0 Register Select generation
assign HSELREGuP0       = (HADDR[20:16] == 5'b00011 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Peripheral 1 Register Select generation
assign HSELREGuP1       = (HADDR[20:16] == 5'b00100 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Peripheral 2 Register Select generation
assign HSELREGuP2       = (HADDR[20:16] == 5'b00101 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Peripheral 3 Register Select generation
assign HSELREGuP3       = (HADDR[20:16] == 5'b00110 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Peripheral 4 Register Select generation
assign HSELREGuP4       = (HADDR[20:16] == 5'b00111 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Peripheral 5 Register Select generation
assign HSELREGuP5       = (HADDR[20:16] == 5'b01000 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Peripheral 6 Register Select generation
assign HSELREGuP6       = (HADDR[20:16] == 5'b01001 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Peripheral 7 Register Select generation
assign HSELREGuP7       = (HADDR[20:16] == 5'b01010 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Peripheral 8 Register Select generation
assign HSELREGuP8       = (HADDR[20:16] == 5'b01011 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Peripheral 9 Register Select generation
assign HSELREGuP9       = (HADDR[20:16] == 5'b01100 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Peripheral 10 Register Select generation
assign HSELREGuP10      = (HADDR[20:16] == 5'b01101 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Peripheral 11 Register Select generation
assign HSELREGuP11      = (HADDR[20:16] == 5'b01110 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Peripheral 12 Register Select generation
assign HSELREGuP12      = (HADDR[20:16] == 5'b01111 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Peripheral 13 Register Select generation
assign HSELREGuP13      = (HADDR[20:16] == 5'b10000 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Peripheral 14 Register Select generation
assign HSELREGuP14      = (HADDR[20:16] == 5'b10001 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Peripheral 15 Register Select generation
assign HSELREGuP15      = (HADDR[20:16] == 5'b10010 & HSELDMACTr == 1'b1) ?
                           1'b1 : 1'b0;

// Memory 0 Select signal generation
assign HSELMEMuM0       = (((ReqConfig[0] == 0) && (HADDRM1 >= `M0LOWADDRRANGE)
                             && (HADDRM1 <= `M0HIGHADDRRANGE)) ||
                           ((ReqConfig[0] == 1) && (HADDRM2 >= `M0LOWADDRRANGE)
                             && (HADDRM2  <= `M0HIGHADDRRANGE))) ? 1'b1 : 1'b0;


// Memory 1 Select signal generation
assign HSELMEMuM1       = (((ReqConfig[1] == 0) && (HADDRM1 >= `M1LOWADDRRANGE)
                             && (HADDRM1 <= `M1HIGHADDRRANGE)) ||
                           ((ReqConfig[1] == 1) && (HADDRM2 >= `M1LOWADDRRANGE)
                             && (HADDRM2  <= `M1HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 0 Select signal generation
assign HSELPERIPHuP0    = (((ReqConfig[2] == 0) && (HADDRM1 >= `P0LOWADDRRANGE)
                             && (HADDRM1 <= `P0HIGHADDRRANGE)) ||
                           ((ReqConfig[2] == 1) && (HADDRM2 >= `P0LOWADDRRANGE)
                             && (HADDRM2  <= `P0HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 1 Select signal generation
assign HSELPERIPHuP1    = (((ReqConfig[3] == 0) && (HADDRM1 >= `P1LOWADDRRANGE)
                             && (HADDRM1 <= `P1HIGHADDRRANGE)) ||
                           ((ReqConfig[3] == 1) && (HADDRM2 >= `P1LOWADDRRANGE)
                             && (HADDRM2  <= `P1HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 2 Select signal generation
assign HSELPERIPHuP2    = (((ReqConfig[4] == 0) && (HADDRM1 >= `P2LOWADDRRANGE)
                             && (HADDRM1 <= `P2HIGHADDRRANGE)) ||
                           ((ReqConfig[4] == 1) && (HADDRM2 >= `P2LOWADDRRANGE)
                             && (HADDRM2  <= `P2HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 3 Select signal generation
assign HSELPERIPHuP3    = (((ReqConfig[5] == 0) && (HADDRM1 >= `P3LOWADDRRANGE)
                             && (HADDRM1 <= `P3HIGHADDRRANGE)) ||
                           ((ReqConfig[5] == 1) && (HADDRM2 >= `P3LOWADDRRANGE)
                             && (HADDRM2  <= `P3HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 4 Select signal generation
assign HSELPERIPHuP4    = (((ReqConfig[6] == 0) && (HADDRM1 >= `P4LOWADDRRANGE)
                             && (HADDRM1 <= `P4HIGHADDRRANGE)) ||
                           ((ReqConfig[6] == 1) && (HADDRM2 >= `P4LOWADDRRANGE)
                             && (HADDRM2  <= `P4HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 5 Select signal generation
assign HSELPERIPHuP5   = (((ReqConfig[7] == 0) && (HADDRM1 >= `P5LOWADDRRANGE)
                            && (HADDRM1 <= `P5HIGHADDRRANGE)) ||
                          ((ReqConfig[7] == 1) && (HADDRM2 >= `P5LOWADDRRANGE)
                            && (HADDRM2 <= `P5HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 6 Select signal generation
assign HSELPERIPHuP6   = (((ReqConfig[8] == 0) && (HADDRM1 >= `P6LOWADDRRANGE)
                            && (HADDRM1 <= `P6HIGHADDRRANGE)) ||
                          ((ReqConfig[8] == 1) && (HADDRM2 >= `P6LOWADDRRANGE)
                            && (HADDRM2 <= `P6HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 7 Select signal generation
assign HSELPERIPHuP7   = (((ReqConfig[9] == 0) && (HADDRM1 >= `P7LOWADDRRANGE)
                            && (HADDRM1 <= `P7HIGHADDRRANGE)) ||
                          ((ReqConfig[9] == 1) && (HADDRM2 >= `P7LOWADDRRANGE)
                            && (HADDRM2 <= `P7HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 8 Select signal generation
assign HSELPERIPHuP8 = (((ReqConfig[10] == 0) && (HADDRM1 >= `P8LOWADDRRANGE)
                          && (HADDRM1 <= `P8HIGHADDRRANGE)) ||
                        ((ReqConfig[10] == 1) && (HADDRM2 >= `P8LOWADDRRANGE)
                          && (HADDRM2 <= `P8HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 9 Select signal generation
assign HSELPERIPHuP9 = (((ReqConfig[11] == 0) && (HADDRM1 >= `P9LOWADDRRANGE)
                          && (HADDRM1 <= `P9HIGHADDRRANGE)) ||
                        ((ReqConfig[11] == 1) && (HADDRM2 >= `P9LOWADDRRANGE)
                          && (HADDRM2 <= `P9HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 10 Select signal generation
assign HSELPERIPHuP10 = (((ReqConfig[12] == 0) && (HADDRM1 >= `P10LOWADDRRANGE)
                           && (HADDRM1 <= `P10HIGHADDRRANGE)) ||
                        ((ReqConfig[12] == 1) && (HADDRM2 >= `P10LOWADDRRANGE)
                          && (HADDRM2 <= `P10HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 11 Select signal generation
assign HSELPERIPHuP11 = (((ReqConfig[13] == 0) && (HADDRM1 >= `P11LOWADDRRANGE)
                           && (HADDRM1 <= `P11HIGHADDRRANGE)) ||
                        ((ReqConfig[13] == 1) && (HADDRM2 >= `P11LOWADDRRANGE)
                          && (HADDRM2 <= `P11HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 12 Select signal generation
assign HSELPERIPHuP12 = (((ReqConfig[14] == 0) && (HADDRM1 >= `P12LOWADDRRANGE)
                           && (HADDRM1 <= `P12HIGHADDRRANGE)) ||
                        ((ReqConfig[14] == 1) && (HADDRM2 >= `P12LOWADDRRANGE)
                          && (HADDRM2 <= `P12HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 13 Select signal generation
assign HSELPERIPHuP13 = (((ReqConfig[15] == 0) && (HADDRM1 >= `P13LOWADDRRANGE)
                           && (HADDRM1 <= `P13HIGHADDRRANGE)) ||
                        ((ReqConfig[15] == 1) && (HADDRM2 >= `P13LOWADDRRANGE)
                          && (HADDRM2 <= `P13HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 14 Select signal generation
assign HSELPERIPHuP14 = (((ReqConfig[16] == 0) && (HADDRM1 >= `P14LOWADDRRANGE)
                           && (HADDRM1 <= `P14HIGHADDRRANGE)) ||
                        ((ReqConfig[16] == 1) && (HADDRM2 >= `P14LOWADDRRANGE)
                          && (HADDRM2 <= `P14HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// Peripheral 15 Select signal generation
assign HSELPERIPHuP15 = (((ReqConfig[17] == 0) && (HADDRM1 >= `P15LOWADDRRANGE)
                           && (HADDRM1 <= `P15HIGHADDRRANGE)) ||
                        ((ReqConfig[17] == 1) && (HADDRM2 >= `P15LOWADDRRANGE)
                          && (HADDRM2 <= `P15HIGHADDRRANGE))) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Instantiation of DmacTrBehaviour
// -----------------------------------------------------------------------------
DmacTrBehaviour uDmacTrBehaviour     (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HSELDMAC        (HSELDMAC),
                    .HSELDMACTrSlave (HSELDMACTrSlave),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANS),
                    .HADDR           (HADDR[20 : 2]),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HGRANTDMACM1    (HGRANTDMACM1),
                    .HGRANTDMACM2    (ZEROFILL[0]),
                    .HREADYINM1      (HREADYINM1),
                    .HREADYINM2      (ZEROFILL[0]),
                    .HRESPM1         (HRESPM1Beh),
                    .HRESPM2         (ZEROFILL[1:0]),
                    .HRDATAM1        (HRDATAM1Beh),
                    .HRDATAM2        (ZEROFILL[31:0]),
                    .DMACBREQ        (DMACBREQ),
                    .DMACLBREQ       (DMACLBREQ),
                    .DMACSREQ        (DMACSREQ),
                    .DMACLSREQ       (DMACLSREQ),
                    .HREADYOUT       (HREADYOUTTrIn),
                    .HRESP           (HRESPTrIn),
                    .HBUSREQDMACM1   (HBUSREQM1Tr),
                    .HBUSREQDMACM2   (HBUSREQM2Tr),
                    .HLOCKDMACM1     (HLOCKM1Tr),
                    .HLOCKDMACM2     (HLOCKM2Tr),
                    .HTRANSM1        (HTRANSM1Tr),
                    .HTRANSM2        (HTRANSM2Tr),
                    .HADDRM1         (HADDRM1Tr),
                    .HADDRM2         (HADDRM2Tr),
                    .HSIZEM1         (HSIZEM1Tr),
                    .HSIZEM2         (HSIZEM2Tr),
                    .HBURSTM1        (HBURSTM1Tr),
                    .HBURSTM2        (HBURSTM2Tr),
                    .HPROTM1         (HPROTM1Tr),
                    .HPROTM2         (HPROTM2Tr),
                    .HWRITEM1        (HWRITEM1Tr),
                    .HWRITEM2        (HWRITEM2Tr),
                    .HWDATAM1        (HWDATAM1Tr),
                    .HWDATAM2        (HWDATAM2Tr),
                    .DMACCLR         (DMACCLRTr),
                    .DMACTC          (DMACTCTr),
                    .DMACINTERR      (DMACINTERRTr),
                    .DMACINTTC       (DMACINTTCTr),
                    .DMACINTR        (DMACINTRTr),
                    .DmacTrEn        (DmacTrEn),
                    .ReqConfig       (ReqConfig),
                    .GrantCount0     (GrantCount0),
                    .GrantCount1     (GrantCount1)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrProChkr
// -----------------------------------------------------------------------------
DmacTrProChkr uDmacTrProChkr         (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HBUSREQDMACM    (HBUSREQDMACM1),
                    .HLOCKDMACM      (HLOCKDMACM1),
                    .HTRANSM         (HTRANSM1),
                    .HADDRM          (HADDRM1),
                    .HSIZEM          (HSIZEM1),
                    .HBURSTM         (HBURSTM1),
                    .HPROTM          (HPROTM1),
                    .HWRITEM         (HWRITEM1),
                    .HWDATAM         (HWDATAM1),
                    .DMACCLR         (DMACCLR),
                    .DMACTC          (DMACTC),
                    .DMACINTERR      (DMACINTERR),
                    .DMACINTTC       (DMACINTTC),
                    .DMACINTR        (DMACINTR),
                    .HBUSREQMTr      (HBUSREQM1Tr),
                    .HLOCKMTr        (HLOCKM1Tr),
                    .HTRANSMTr       (HTRANSM1Tr),
                    .HADDRMTr        (HADDRM1Tr),
                    .HSIZEMTr        (HSIZEM1Tr),
                    .HBURSTMTr       (HBURSTM1Tr),
                    .HPROTMTr        (HPROTM1Tr),
                    .HWRITEMTr       (HWRITEM1Tr),
                    .HWDATAMTr       (HWDATAM1Tr),
                    .DMACCLRTr       (DMACCLRTr),
                    .DMACTCTr        (DMACTCTr),
                    .DMACINTERRTr    (DMACINTERRTr),
                    .DMACINTTCTr     (DMACINTTCTr),
                    .DMACINTRTr      (DMACINTRTr),
                    .HREADYINM       (HREADYINM1),
                    .HGRANTDMACM     (HGRANTDMACM1),
                    .DmacTrEn        (DmacTrEn)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrGntGen 0
// -----------------------------------------------------------------------------
DmacTrGntGen u0DmacTrGntGen          (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HBUSREQDMAC     (HBUSREQDMACM1),
                    .HREADYINM       (HREADYINM1),
                    .HBURSTM         (HBURSTM1),
                    .GrantCount      (GrantCount0),
                    .HGRANTDMACM     (HGRANTDMACM1)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrMem 0
// -----------------------------------------------------------------------------
DmacTrMem uM0DmacTrMem               (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuM0),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuM0),
                    .HRESP           (HRESPuM0),
                    .HRDATA          (HRDATAuM0),
                    .HADDRM          (HADDRMuM0),
                    .HSELMEM         (HSELMEMuM0),
                    .HWRITEM         (HWRITEMuM0),
                    .HTRANSM         (HTRANSMuM0),
                    .HBURSTM         (HBURSTMuM0),
                    .HSIZEM          (HSIZEMuM0),
                    .HWDATAM         (HWDATAMuM0),
                    .HREADYINM       (HREADYINMuM0),
                    .HREADYOUTM      (HREADYOUTMuM0),
                    .HRESPM          (HRESPMuM0),
                    .HRDATAM         (HRDATAMuM0)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrMem 1
// -----------------------------------------------------------------------------
DmacTrMem uM1DmacTrMem               (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuM1),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuM1),
                    .HRESP           (HRESPuM1),
                    .HRDATA          (HRDATAuM1),
                    .HADDRM          (HADDRMuM1),
                    .HSELMEM         (HSELMEMuM1),
                    .HWRITEM         (HWRITEMuM1),
                    .HTRANSM         (HTRANSMuM1),
                    .HBURSTM         (HBURSTMuM1),
                    .HSIZEM          (HSIZEMuM1),
                    .HWDATAM         (HWDATAMuM1),
                    .HREADYINM       (HREADYINMuM1),
                    .HREADYOUTM      (HREADYOUTMuM1),
                    .HRESPM          (HRESPMuM1),
                    .HRDATAM         (HRDATAMuM1)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 0
// -----------------------------------------------------------------------------
DmacTrPeriph uP0DmacTrPeriph         (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP0),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP0),
                    .HRESP           (HRESPuP0),
                    .HRDATA          (HRDATAuP0),
                    .HADDRM          (HADDRMuP0),
                    .HSELPERIPH      (HSELPERIPHuP0),
                    .HWRITEM         (HWRITEMuP0),
                    .HTRANSM         (HTRANSMuP0),
                    .HBURSTM         (HBURSTMuP0),
                    .HSIZEM          (HSIZEMuP0),
                    .HWDATAM         (HWDATAMuP0),
                    .DMACTC          (DMACTC[0]),
                    .DMACCLR         (DMACCLR[0]),
                    .HREADYINM       (HREADYINMuP0),
                    .HREADYOUTM      (HREADYOUTMuP0),
                    .HRESPM          (HRESPMuP0),
                    .HRDATAM         (HRDATAMuP0),
                    .DMACSREQ        (DMACSREQ[0]),
                    .DMACBREQ        (DMACBREQ[0]),
                    .DMACLSREQ       (DMACLSREQ[0]),
                    .DMACLBREQ       (DMACLBREQ[0])
                    );
 
// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 1
// -----------------------------------------------------------------------------
DmacTrPeriph uP1DmacTrPeriph         (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP1),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP1),
                    .HRESP           (HRESPuP1),
                    .HRDATA          (HRDATAuP1),
                    .HADDRM          (HADDRMuP1),
                    .HSELPERIPH      (HSELPERIPHuP1),
                    .HWRITEM         (HWRITEMuP1),
                    .HTRANSM         (HTRANSMuP1),
                    .HBURSTM         (HBURSTMuP1),
                    .HSIZEM          (HSIZEMuP1),
                    .HWDATAM         (HWDATAMuP1),
                    .DMACTC          (DMACTC[1]),
                    .DMACCLR         (DMACCLR[1]),
                    .HREADYINM       (HREADYINMuP1),
                    .HREADYOUTM      (HREADYOUTMuP1),
                    .HRESPM          (HRESPMuP1),
                    .HRDATAM         (HRDATAMuP1),
                    .DMACSREQ        (DMACSREQ[1]),
                    .DMACBREQ        (DMACBREQ[1]),
                    .DMACLSREQ       (DMACLSREQ[1]),
                    .DMACLBREQ       (DMACLBREQ[1])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 2
// -----------------------------------------------------------------------------
DmacTrPeriph uP2DmacTrPeriph         (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP2),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP2),
                    .HRESP           (HRESPuP2),
                    .HRDATA          (HRDATAuP2),
                    .HADDRM          (HADDRMuP2),
                    .HSELPERIPH      (HSELPERIPHuP2),
                    .HWRITEM         (HWRITEMuP2),
                    .HTRANSM         (HTRANSMuP2),
                    .HBURSTM         (HBURSTMuP2),
                    .HSIZEM          (HSIZEMuP2),
                    .HWDATAM         (HWDATAMuP2),
                    .DMACTC          (DMACTC[2]),
                    .DMACCLR         (DMACCLR[2]),
                    .HREADYINM       (HREADYINMuP2),
                    .HREADYOUTM      (HREADYOUTMuP2),
                    .HRESPM          (HRESPMuP2),
                    .HRDATAM         (HRDATAMuP2),
                    .DMACSREQ        (DMACSREQ[2]),
                    .DMACBREQ        (DMACBREQ[2]),
                    .DMACLSREQ       (DMACLSREQ[2]),
                    .DMACLBREQ       (DMACLBREQ[2])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 3
// -----------------------------------------------------------------------------
DmacTrPeriph uP3DmacTrPeriph         (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP3),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP3),
                    .HRESP           (HRESPuP3),
                    .HRDATA          (HRDATAuP3),
                    .HADDRM          (HADDRMuP3),
                    .HSELPERIPH      (HSELPERIPHuP3),
                    .HWRITEM         (HWRITEMuP3),
                    .HTRANSM         (HTRANSMuP3),
                    .HBURSTM         (HBURSTMuP3),
                    .HSIZEM          (HSIZEMuP3),
                    .HWDATAM         (HWDATAMuP3),
                    .DMACTC          (DMACTC[3]),
                    .DMACCLR         (DMACCLR[3]),
                    .HREADYINM       (HREADYINMuP3),
                    .HREADYOUTM      (HREADYOUTMuP3),
                    .HRESPM          (HRESPMuP3),
                    .HRDATAM         (HRDATAMuP3),
                    .DMACSREQ        (DMACSREQ[3]),
                    .DMACBREQ        (DMACBREQ[3]),
                    .DMACLSREQ       (DMACLSREQ[3]),
                    .DMACLBREQ       (DMACLBREQ[3])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 4
// -----------------------------------------------------------------------------
DmacTrPeriph uP4DmacTrPeriph         (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP4),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP4),
                    .HRESP           (HRESPuP4),
                    .HRDATA          (HRDATAuP4),
                    .HADDRM          (HADDRMuP4),
                    .HSELPERIPH      (HSELPERIPHuP4),
                    .HWRITEM         (HWRITEMuP4),
                    .HTRANSM         (HTRANSMuP4),
                    .HBURSTM         (HBURSTMuP4),
                    .HSIZEM          (HSIZEMuP4),
                    .HWDATAM         (HWDATAMuP4),
                    .DMACTC          (DMACTC[4]),
                    .DMACCLR         (DMACCLR[4]),
                    .HREADYINM       (HREADYINMuP4),
                    .HREADYOUTM      (HREADYOUTMuP4),
                    .HRESPM          (HRESPMuP4),
                    .HRDATAM         (HRDATAMuP4),
                    .DMACSREQ        (DMACSREQ[4]),
                    .DMACBREQ        (DMACBREQ[4]),
                    .DMACLSREQ       (DMACLSREQ[4]),
                    .DMACLBREQ       (DMACLBREQ[4])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 5
// -----------------------------------------------------------------------------
DmacTrPeriph uP5DmacTrPeriph         (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP5),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP5),
                    .HRESP           (HRESPuP5),
                    .HRDATA          (HRDATAuP5),
                    .HADDRM          (HADDRMuP5),
                    .HSELPERIPH      (HSELPERIPHuP5),
                    .HWRITEM         (HWRITEMuP5),
                    .HTRANSM         (HTRANSMuP5),
                    .HBURSTM         (HBURSTMuP5),
                    .HSIZEM          (HSIZEMuP5),
                    .HWDATAM         (HWDATAMuP5),
                    .DMACTC          (DMACTC[5]),
                    .DMACCLR         (DMACCLR[5]),
                    .HREADYINM       (HREADYINMuP5),
                    .HREADYOUTM      (HREADYOUTMuP5),
                    .HRESPM          (HRESPMuP5),
                    .HRDATAM         (HRDATAMuP5),
                    .DMACSREQ        (DMACSREQ[5]),
                    .DMACBREQ        (DMACBREQ[5]),
                    .DMACLSREQ       (DMACLSREQ[5]),
                    .DMACLBREQ       (DMACLBREQ[5])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 6
// -----------------------------------------------------------------------------
DmacTrPeriph uP6DmacTrPeriph         (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP6),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP6),
                    .HRESP           (HRESPuP6),
                    .HRDATA          (HRDATAuP6),
                    .HADDRM          (HADDRMuP6),
                    .HSELPERIPH      (HSELPERIPHuP6),
                    .HWRITEM         (HWRITEMuP6),
                    .HTRANSM         (HTRANSMuP6),
                    .HBURSTM         (HBURSTMuP6),
                    .HSIZEM          (HSIZEMuP6),
                    .HWDATAM         (HWDATAMuP6),
                    .DMACTC          (DMACTC[6]),
                    .DMACCLR         (DMACCLR[6]),
                    .HREADYINM       (HREADYINMuP6),
                    .HREADYOUTM      (HREADYOUTMuP6),
                    .HRESPM          (HRESPMuP6),
                    .HRDATAM         (HRDATAMuP6),
                    .DMACSREQ        (DMACSREQ[6]),
                    .DMACBREQ        (DMACBREQ[6]),
                    .DMACLSREQ       (DMACLSREQ[6]),
                    .DMACLBREQ       (DMACLBREQ[6])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 7
// -----------------------------------------------------------------------------
DmacTrPeriph uP7DmacTrPeriph         (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP7),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP7),
                    .HRESP           (HRESPuP7),
                    .HRDATA          (HRDATAuP7),
                    .HADDRM          (HADDRMuP7),
                    .HSELPERIPH      (HSELPERIPHuP7),
                    .HWRITEM         (HWRITEMuP7),
                    .HTRANSM         (HTRANSMuP7),
                    .HBURSTM         (HBURSTMuP7),
                    .HSIZEM          (HSIZEMuP7),
                    .HWDATAM         (HWDATAMuP7),
                    .DMACTC          (DMACTC[7]),
                    .DMACCLR         (DMACCLR[7]),
                    .HREADYINM       (HREADYINMuP7),
                    .HREADYOUTM      (HREADYOUTMuP7),
                    .HRESPM          (HRESPMuP7),
                    .HRDATAM         (HRDATAMuP7),
                    .DMACSREQ        (DMACSREQ[7]),
                    .DMACBREQ        (DMACBREQ[7]),
                    .DMACLSREQ       (DMACLSREQ[7]),
                    .DMACLBREQ       (DMACLBREQ[7])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 8
// -----------------------------------------------------------------------------
DmacTrPeriph uP8DmacTrPeriph         (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP8),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP8),
                    .HRESP           (HRESPuP8),
                    .HRDATA          (HRDATAuP8),
                    .HADDRM          (HADDRMuP8),
                    .HSELPERIPH      (HSELPERIPHuP8),
                    .HWRITEM         (HWRITEMuP8),
                    .HTRANSM         (HTRANSMuP8),
                    .HBURSTM         (HBURSTMuP8),
                    .HSIZEM          (HSIZEMuP8),
                    .HWDATAM         (HWDATAMuP8),
                    .DMACTC          (DMACTC[8]),
                    .DMACCLR         (DMACCLR[8]),
                    .HREADYINM       (HREADYINMuP8),
                    .HREADYOUTM      (HREADYOUTMuP8),
                    .HRESPM          (HRESPMuP8),
                    .HRDATAM         (HRDATAMuP8),
                    .DMACSREQ        (DMACSREQ[8]),
                    .DMACBREQ        (DMACBREQ[8]),
                    .DMACLSREQ       (DMACLSREQ[8]),
                    .DMACLBREQ       (DMACLBREQ[8])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 9
// -----------------------------------------------------------------------------
DmacTrPeriph uP9DmacTrPeriph         (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP9),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP9),
                    .HRESP           (HRESPuP9),
                    .HRDATA          (HRDATAuP9),
                    .HADDRM          (HADDRMuP9),
                    .HSELPERIPH      (HSELPERIPHuP9),
                    .HWRITEM         (HWRITEMuP9),
                    .HTRANSM         (HTRANSMuP9),
                    .HBURSTM         (HBURSTMuP9),
                    .HSIZEM          (HSIZEMuP9),
                    .HWDATAM         (HWDATAMuP9),
                    .DMACTC          (DMACTC[9]),
                    .DMACCLR         (DMACCLR[9]),
                    .HREADYINM       (HREADYINMuP9),
                    .HREADYOUTM      (HREADYOUTMuP9),
                    .HRESPM          (HRESPMuP9),
                    .HRDATAM         (HRDATAMuP9),
                    .DMACSREQ        (DMACSREQ[9]),
                    .DMACBREQ        (DMACBREQ[9]),
                    .DMACLSREQ       (DMACLSREQ[9]),
                    .DMACLBREQ       (DMACLBREQ[9])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 10
// -----------------------------------------------------------------------------
DmacTrPeriph uP10DmacTrPeriph         (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP10),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP10),
                    .HRESP           (HRESPuP10),
                    .HRDATA          (HRDATAuP10),
                    .HADDRM          (HADDRMuP10),
                    .HSELPERIPH      (HSELPERIPHuP10),
                    .HWRITEM         (HWRITEMuP10),
                    .HTRANSM         (HTRANSMuP10),
                    .HBURSTM         (HBURSTMuP10),
                    .HSIZEM          (HSIZEMuP10),
                    .HWDATAM         (HWDATAMuP10),
                    .DMACTC          (DMACTC[10]),
                    .DMACCLR         (DMACCLR[10]),
                    .HREADYINM       (HREADYINMuP10),
                    .HREADYOUTM      (HREADYOUTMuP10),
                    .HRESPM          (HRESPMuP10),
                    .HRDATAM         (HRDATAMuP10),
                    .DMACSREQ        (DMACSREQ[10]),
                    .DMACBREQ        (DMACBREQ[10]),
                    .DMACLSREQ       (DMACLSREQ[10]),
                    .DMACLBREQ       (DMACLBREQ[10])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 11
// -----------------------------------------------------------------------------
DmacTrPeriph uP11DmacTrPeriph        (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP11),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP11),
                    .HRESP           (HRESPuP11),
                    .HRDATA          (HRDATAuP11),
                    .HADDRM          (HADDRMuP11),
                    .HSELPERIPH      (HSELPERIPHuP11),
                    .HWRITEM         (HWRITEMuP11),
                    .HTRANSM         (HTRANSMuP11),
                    .HBURSTM         (HBURSTMuP11),
                    .HSIZEM          (HSIZEMuP11),
                    .HWDATAM         (HWDATAMuP11),
                    .DMACTC          (DMACTC[11]),
                    .DMACCLR         (DMACCLR[11]),
                    .HREADYINM       (HREADYINMuP11),
                    .HREADYOUTM      (HREADYOUTMuP11),
                    .HRESPM          (HRESPMuP11),
                    .HRDATAM         (HRDATAMuP11),
                    .DMACSREQ        (DMACSREQ[11]),
                    .DMACBREQ        (DMACBREQ[11]),
                    .DMACLSREQ       (DMACLSREQ[11]),
                    .DMACLBREQ       (DMACLBREQ[11])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 12
// -----------------------------------------------------------------------------
DmacTrPeriph uP12DmacTrPeriph        (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP12),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP12),
                    .HRESP           (HRESPuP12),
                    .HRDATA          (HRDATAuP12),
                    .HADDRM          (HADDRMuP12),
                    .HSELPERIPH      (HSELPERIPHuP12),
                    .HWRITEM         (HWRITEMuP12),
                    .HTRANSM         (HTRANSMuP12),
                    .HBURSTM         (HBURSTMuP12),
                    .HSIZEM          (HSIZEMuP12),
                    .HWDATAM         (HWDATAMuP12),
                    .DMACTC          (DMACTC[12]),
                    .DMACCLR         (DMACCLR[12]),
                    .HREADYINM       (HREADYINMuP12),
                    .HREADYOUTM      (HREADYOUTMuP12),
                    .HRESPM          (HRESPMuP12),
                    .HRDATAM         (HRDATAMuP12),
                    .DMACSREQ        (DMACSREQ[12]),
                    .DMACBREQ        (DMACBREQ[12]),
                    .DMACLSREQ       (DMACLSREQ[12]),
                    .DMACLBREQ       (DMACLBREQ[12])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 13
// -----------------------------------------------------------------------------
DmacTrPeriph uP13DmacTrPeriph        (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP13),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP13),
                    .HRESP           (HRESPuP13),
                    .HRDATA          (HRDATAuP13),
                    .HADDRM          (HADDRMuP13),
                    .HSELPERIPH      (HSELPERIPHuP13),
                    .HWRITEM         (HWRITEMuP13),
                    .HTRANSM         (HTRANSMuP13),
                    .HBURSTM         (HBURSTMuP13),
                    .HSIZEM          (HSIZEMuP13),
                    .HWDATAM         (HWDATAMuP13),
                    .DMACTC          (DMACTC[13]),
                    .DMACCLR         (DMACCLR[13]),
                    .HREADYINM       (HREADYINMuP13),
                    .HREADYOUTM      (HREADYOUTMuP13),
                    .HRESPM          (HRESPMuP13),
                    .HRDATAM         (HRDATAMuP13),
                    .DMACSREQ        (DMACSREQ[13]),
                    .DMACBREQ        (DMACBREQ[13]),
                    .DMACLSREQ       (DMACLSREQ[13]),
                    .DMACLBREQ       (DMACLBREQ[13])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 14
// -----------------------------------------------------------------------------
DmacTrPeriph uP14DmacTrPeriph        (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP14),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP14),
                    .HRESP           (HRESPuP14),
                    .HRDATA          (HRDATAuP14),
                    .HADDRM          (HADDRMuP14),
                    .HSELPERIPH      (HSELPERIPHuP14),
                    .HWRITEM         (HWRITEMuP14),
                    .HTRANSM         (HTRANSMuP14),
                    .HBURSTM         (HBURSTMuP14),
                    .HSIZEM          (HSIZEMuP14),
                    .HWDATAM         (HWDATAMuP14),
                    .DMACTC          (DMACTC[14]),
                    .DMACCLR         (DMACCLR[14]),
                    .HREADYINM       (HREADYINMuP14),
                    .HREADYOUTM      (HREADYOUTMuP14),
                    .HRESPM          (HRESPMuP14),
                    .HRDATAM         (HRDATAMuP14),
                    .DMACSREQ        (DMACSREQ[14]),
                    .DMACBREQ        (DMACBREQ[14]),
                    .DMACLSREQ       (DMACLSREQ[14]),
                    .DMACLBREQ       (DMACLBREQ[14])
                    );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrPeriph 15
// -----------------------------------------------------------------------------
DmacTrPeriph uP15DmacTrPeriph        (
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HADDR           (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
                    .HSELREG         (HSELREGuP15),
                    .HWRITE          (HWRITE),
                    .HTRANS          (HTRANSIn),
                    .HSIZE           (HSIZE),
                    .HWDATA          (HWDATA),
                    .HREADYIN        (HREADYIN),
                    .HREADYOUT       (HREADYOUTuP15),
                    .HRESP           (HRESPuP15),
                    .HRDATA          (HRDATAuP15),
                    .HADDRM          (HADDRMuP15),
                    .HSELPERIPH      (HSELPERIPHuP15),
                    .HWRITEM         (HWRITEMuP15),
                    .HTRANSM         (HTRANSMuP15),
                    .HBURSTM         (HBURSTMuP15),
                    .HSIZEM          (HSIZEMuP15),
                    .HWDATAM         (HWDATAMuP15),
                    .DMACTC          (DMACTC[15]),
                    .DMACCLR         (DMACCLR[15]),
                    .HREADYINM       (HREADYINMuP15),
                    .HREADYOUTM      (HREADYOUTMuP15),
                    .HRESPM          (HRESPMuP15),
                    .HRDATAM         (HRDATAMuP15),
                    .DMACSREQ        (DMACSREQ[15]),
                    .DMACBREQ        (DMACBREQ[15]),
                    .DMACLSREQ       (DMACLSREQ[15]),
                    .DMACLBREQ       (DMACLBREQ[15])
                    );

// -----------------------------------------------------------------------------
// Control Information Latching Block
// -----------------------------------------------------------------------------
always @(ReqConfig or HSELMEMuM0 or HSELMEMuM1 or HSELPERIPHuP0 or
         HSELPERIPHuP1 or HSELPERIPHuP2 or HSELPERIPHuP3 or HSELPERIPHuP4 or
         HSELPERIPHuP5 or HSELPERIPHuP6 or HSELPERIPHuP7 or HSELPERIPHuP8 or
         HSELPERIPHuP9 or HSELPERIPHuP10 or HSELPERIPHuP11 or HSELPERIPHuP12 or
         HSELPERIPHuP13 or HSELPERIPHuP14 or HSELPERIPHuP15 or HADDRM1 or
         HADDRM2 or HWRITEM1 or HWRITEM2 or HSIZEM1 or HSIZEM2 or HBURSTM1 or
         HBURSTM2 or HTRANSM1 or HTRANSM2 or HREADYINM1 or HREADYINM2 or
         SyncMem0 or SyncMem1 or SyncPeriph0 or SyncPeriph1 or SyncPeriph2 or
         SyncPeriph3 or SyncPeriph4 or SyncPeriph5 or SyncPeriph6 or
         SyncPeriph7 or SyncPeriph8 or SyncPeriph9 or SyncPeriph10 or
         SyncPeriph11 or SyncPeriph12 or SyncPeriph13 or SyncPeriph14 or
         SyncPeriph15)
begin : p_ControlInfoComb
     NxtSyncMem0      = SyncMem0;
     NxtSyncMem1      = SyncMem1;
     NxtSyncPeriph0   = SyncPeriph0;
     NxtSyncPeriph1   = SyncPeriph1;
     NxtSyncPeriph2   = SyncPeriph2;
     NxtSyncPeriph3   = SyncPeriph3;
     NxtSyncPeriph4   = SyncPeriph4;
     NxtSyncPeriph5   = SyncPeriph5;
     NxtSyncPeriph6   = SyncPeriph6;
     NxtSyncPeriph7   = SyncPeriph7;
     NxtSyncPeriph8   = SyncPeriph8;
     NxtSyncPeriph9   = SyncPeriph9;
     NxtSyncPeriph10  = SyncPeriph10;
     NxtSyncPeriph11  = SyncPeriph11;
     NxtSyncPeriph12  = SyncPeriph12;
     NxtSyncPeriph13  = SyncPeriph13;
     NxtSyncPeriph14  = SyncPeriph14;
     NxtSyncPeriph15  = SyncPeriph15;

  if (HSELMEMuM0 == 1'b1)
  begin
    if (ReqConfig[0] == 1'b1)
    begin
       HADDRMuM0        = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuM0       = HWRITEM2;
       HTRANSMuM0       = HTRANSM2;
       HSIZEMuM0        = HSIZEM2;
       HBURSTMuM0       = HBURSTM2;
       HREADYINMuM0     = HREADYINM2;
    end
    else
    begin
       HADDRMuM0        = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuM0       = HWRITEM1;
       HTRANSMuM0       = HTRANSM1;
       HSIZEMuM0        = HSIZEM1;
       HBURSTMuM0       = HBURSTM1;
       HREADYINMuM0     = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuM0        = 'b0;
     HWRITEMuM0       = 1'b0;
     HTRANSMuM0       = 'b0;
     HSIZEMuM0        = 'b0;
     HBURSTMuM0       = 'b0;
     HREADYINMuM0     = 1'b0;
  end

  if (ReqConfig[0] == 1'b1)
  begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELMEMuM0 == 1'b1)
      begin
         NxtSyncMem0      = 1'b1;
      end
      else
      begin
         NxtSyncMem0      = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELMEMuM0 == 1'b1)
      begin
         NxtSyncMem0      = 1'b1;
      end
      else
      begin
         NxtSyncMem0      = 1'b0;
      end
    end
  end

  if (HSELMEMuM1 == 1'b1)
  begin
    if (ReqConfig[1] == 1'b1)
    begin
       HADDRMuM1        = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuM1       = HWRITEM2;
       HTRANSMuM1       = HTRANSM2;
       HSIZEMuM1        = HSIZEM2;
       HBURSTMuM1       = HBURSTM2;
       HREADYINMuM1     = HREADYINM2;

    end
    else
    begin
       HADDRMuM1        = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuM1       = HWRITEM1;
       HTRANSMuM1       = HTRANSM1;
       HSIZEMuM1        = HSIZEM1;
       HBURSTMuM1       = HBURSTM1;
       HREADYINMuM1     = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuM1        = 'b0;
     HWRITEMuM1       = 1'b0;
     HTRANSMuM1       = 'b0;
     HSIZEMuM1        = 'b0;
     HBURSTMuM1       = 'b0;
     HREADYINMuM1     = 1'b0;
  end

  if (ReqConfig[1] == 1'b1)
  begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELMEMuM1 == 1'b1)
      begin
         NxtSyncMem1      = 1'b1;
      end
      else
      begin
         NxtSyncMem1      = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELMEMuM1 == 1'b1)
      begin
         NxtSyncMem1      = 1'b1;
      end
      else
      begin
         NxtSyncMem1      = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP0 == 1'b1)
  begin
    if (ReqConfig[2] == 1'b1)
    begin
       HADDRMuP0        = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP0       = HWRITEM2;
       HTRANSMuP0       = HTRANSM2;
       HSIZEMuP0        = HSIZEM2;
       HBURSTMuP0       = HBURSTM2;
       HREADYINMuP0     = HREADYINM2;
    end
    else
    begin
       HADDRMuP0        = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP0       = HWRITEM1;
       HTRANSMuP0       = HTRANSM1;
       HSIZEMuP0        = HSIZEM1;
       HBURSTMuP0       = HBURSTM1;
       HREADYINMuP0     = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP0        = 'b0;
     HWRITEMuP0       = 1'b0;
     HTRANSMuP0       = 'b0;
     HSIZEMuP0        = 'b0;
     HBURSTMuP0       = 'b0;
     HREADYINMuP0     = 1'b0;
  end

  if (ReqConfig[2] == 1'b1)
  begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP0 == 1'b1)
      begin
         NxtSyncPeriph0   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph0   = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP0 == 1'b1)
      begin
         NxtSyncPeriph0   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph0   = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP1 == 1'b1)
  begin
    if (ReqConfig[3] == 1'b1)
    begin
       HADDRMuP1        = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP1       = HWRITEM2;
       HTRANSMuP1       = HTRANSM2;
       HSIZEMuP1        = HSIZEM2;
       HBURSTMuP1       = HBURSTM2;
       HREADYINMuP1     = HREADYINM2;
    end
    else
    begin
       HADDRMuP1        = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP1       = HWRITEM1;
       HTRANSMuP1       = HTRANSM1;
       HSIZEMuP1        = HSIZEM1;
       HBURSTMuP1       = HBURSTM1;
       HREADYINMuP1     = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP1        = 'b0;
     HWRITEMuP1       = 1'b0;
     HTRANSMuP1       = 'b0;
     HSIZEMuP1        = 'b0;
     HBURSTMuP1       = 'b0;
     HREADYINMuP1     = 1'b0;
  end

  if (ReqConfig[3] == 1'b1)
  begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP1 == 1'b1)
      begin
         NxtSyncPeriph1   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph1   = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP1 == 1'b1)
      begin
         NxtSyncPeriph1   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph1   = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP2 == 1'b1)
  begin
    if (ReqConfig[4] == 1'b1)
    begin
       HADDRMuP2        = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP2       = HWRITEM2;
       HTRANSMuP2       = HTRANSM2;
       HSIZEMuP2        = HSIZEM2;
       HBURSTMuP2       = HBURSTM2;
       HREADYINMuP2     = HREADYINM2;
    end
    else
    begin
       HADDRMuP2        = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP2       = HWRITEM1;
       HTRANSMuP2       = HTRANSM1;
       HSIZEMuP2        = HSIZEM1;
       HBURSTMuP2       = HBURSTM1;
       HREADYINMuP2     = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP2        = 'b0;
     HWRITEMuP2       = 1'b0;
     HTRANSMuP2       = 'b0;
     HSIZEMuP2        = 'b0;
     HBURSTMuP2       = 'b0;
     HREADYINMuP2     = 1'b0;
  end

  if (ReqConfig[4] == 1'b1)
  begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP2 == 1'b1)
      begin
         NxtSyncPeriph2   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph2   = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP2 == 1'b1)
      begin
         NxtSyncPeriph2   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph2   = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP3 == 1'b1)
  begin
    if (ReqConfig[5] == 1'b1)
    begin
       HADDRMuP3        = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP3       = HWRITEM2;
       HTRANSMuP3       = HTRANSM2;
       HSIZEMuP3        = HSIZEM2;
       HBURSTMuP3       = HBURSTM2;
       HREADYINMuP3     = HREADYINM2;

    end
    else
    begin
       HADDRMuP3        = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP3       = HWRITEM1;
       HTRANSMuP3       = HTRANSM1;
       HSIZEMuP3        = HSIZEM1;
       HBURSTMuP3       = HBURSTM1;
       HREADYINMuP3     = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP3        = 'b0;
     HWRITEMuP3       = 1'b0;
     HTRANSMuP3       = 'b0;
     HSIZEMuP3        = 'b0;
     HBURSTMuP3       = 'b0;
     HREADYINMuP3     = 1'b0;
  end

  if (ReqConfig[5] == 1'b1)
  begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP3 == 1'b1)
      begin
         NxtSyncPeriph3   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph3   = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP3 == 1'b1)
      begin
         NxtSyncPeriph3   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph3   = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP4 == 1'b1)
  begin
    if (ReqConfig[6] == 1'b1)
    begin
       HADDRMuP4        = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP4       = HWRITEM2;
       HTRANSMuP4       = HTRANSM2;
       HSIZEMuP4        = HSIZEM2;
       HBURSTMuP4       = HBURSTM2;
       HREADYINMuP4     = HREADYINM2;
    end
    else
    begin
       HADDRMuP4        = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP4       = HWRITEM1;
       HTRANSMuP4       = HTRANSM1;
       HSIZEMuP4        = HSIZEM1;
       HBURSTMuP4       = HBURSTM1;
       HREADYINMuP4     = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP4        = 'b0;
     HWRITEMuP4       = 1'b0;
     HTRANSMuP4       = 'b0;
     HSIZEMuP4        = 'b0;
     HBURSTMuP4       = 'b0;
     HREADYINMuP4     = 1'b0;
  end

 if (ReqConfig[6] == 1'b1)
 begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP4 == 1'b1)
      begin
         NxtSyncPeriph4   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph4   = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP4 == 1'b1)
      begin
         NxtSyncPeriph4   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph4   = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP5 == 1'b1)
  begin
    if (ReqConfig[7] == 1'b1)
    begin
       HADDRMuP5        = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP5       = HWRITEM2;
       HTRANSMuP5       = HTRANSM2;
       HSIZEMuP5        = HSIZEM2;
       HBURSTMuP5       = HBURSTM2;
       HREADYINMuP5     = HREADYINM2;
    end
    else
    begin
       HADDRMuP5        = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP5       = HWRITEM1;
       HTRANSMuP5       = HTRANSM1;
       HSIZEMuP5        = HSIZEM1;
       HBURSTMuP5       = HBURSTM1;
       HREADYINMuP5     = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP5        = 'b0;
     HWRITEMuP5       = 1'b0;
     HTRANSMuP5       = 'b0;
     HSIZEMuP5        = 'b0;
     HBURSTMuP5       = 'b0;
     HREADYINMuP5     = 1'b0;
  end

 if (ReqConfig[7] == 1'b1)
 begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP5 == 1'b1)
      begin
         NxtSyncPeriph5   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph5   = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP5 == 1'b1)
      begin
         NxtSyncPeriph5   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph5   = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP6 == 1'b1)
  begin
    if (ReqConfig[8] == 1'b1)
    begin
       HADDRMuP6        = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP6       = HWRITEM2;
       HTRANSMuP6       = HTRANSM2;
       HSIZEMuP6        = HSIZEM2;
       HBURSTMuP6       = HBURSTM2;
       HREADYINMuP6     = HREADYINM2;
    end
    else
    begin
       HADDRMuP6        = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP6       = HWRITEM1;
       HTRANSMuP6       = HTRANSM1;
       HSIZEMuP6        = HSIZEM1;
       HBURSTMuP6       = HBURSTM1;
       HREADYINMuP6     = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP6        = 'b0;
     HWRITEMuP6       = 1'b0;
     HTRANSMuP6       = 'b0;
     HSIZEMuP6        = 'b0;
     HBURSTMuP6       = 'b0;
     HREADYINMuP6     = 1'b0;
  end

  if (ReqConfig[8] == 1'b1)
  begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP6 == 1'b1)
      begin
         NxtSyncPeriph6   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph6   = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP6 == 1'b1)
      begin
         NxtSyncPeriph6   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph6   = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP7 == 1'b1)
  begin
    if (ReqConfig[9] == 1'b1)
    begin
       HADDRMuP7        = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP7       = HWRITEM2;
       HTRANSMuP7       = HTRANSM2;
       HSIZEMuP7        = HSIZEM2;
       HBURSTMuP7       = HBURSTM2;
       HREADYINMuP7     = HREADYINM2;
    end
    else
    begin
       HADDRMuP7        = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP7       = HWRITEM1;
       HTRANSMuP7       = HTRANSM1;
       HSIZEMuP7        = HSIZEM1;
       HBURSTMuP7       = HBURSTM1;
       HREADYINMuP7     = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP7        = 'b0;
     HWRITEMuP7       = 1'b0;
     HTRANSMuP7       = 'b0;
     HSIZEMuP7        = 'b0;
     HBURSTMuP7       = 'b0;
     HREADYINMuP7     = 1'b0;
  end

 if (ReqConfig[9] == 1'b1)
 begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP7 == 1'b1)
      begin
         NxtSyncPeriph7   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph7   = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP7 == 1'b1)
      begin
         NxtSyncPeriph7   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph7   = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP8 == 1'b1)
  begin
    if (ReqConfig[10] == 1'b1)
    begin
       HADDRMuP8        = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP8       = HWRITEM2;
       HTRANSMuP8       = HTRANSM2;
       HSIZEMuP8        = HSIZEM2;
       HBURSTMuP8       = HBURSTM2;
       HREADYINMuP8     = HREADYINM2;
    end
    else
    begin
       HADDRMuP8        = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP8       = HWRITEM1;
       HTRANSMuP8       = HTRANSM1;
       HSIZEMuP8        = HSIZEM1;
       HBURSTMuP8       = HBURSTM1;
       HREADYINMuP8     = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP8        = 'b0;
     HWRITEMuP8       = 1'b0;
     HTRANSMuP8       = 'b0;
     HSIZEMuP8        = 'b0;
     HBURSTMuP8       = 'b0;
     HREADYINMuP8     = 1'b0;
  end

 if (ReqConfig[10] == 1'b1)
 begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP8 == 1'b1)
      begin
         NxtSyncPeriph8   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph8   = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP8 == 1'b1)
      begin
         NxtSyncPeriph8   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph8   = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP9 == 1'b1)
  begin
    if (ReqConfig[11] == 1'b1)
    begin
       HADDRMuP9        = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP9       = HWRITEM2;
       HTRANSMuP9       = HTRANSM2;
       HSIZEMuP9        = HSIZEM2;
       HBURSTMuP9       = HBURSTM2;
       HREADYINMuP9     = HREADYINM2;
    end
    else
    begin
       HADDRMuP9        = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP9       = HWRITEM1;
       HTRANSMuP9       = HTRANSM1;
       HSIZEMuP9        = HSIZEM1;
       HBURSTMuP9       = HBURSTM1;
       HREADYINMuP9     = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP9        = 'b0;
     HWRITEMuP9       = 1'b0;
     HTRANSMuP9       = 'b0;
     HSIZEMuP9        = 'b0;
     HBURSTMuP9       = 'b0;
     HREADYINMuP9     = 1'b0;
  end

 if (ReqConfig[11] == 1'b1)
 begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP9 == 1'b1)
      begin
         NxtSyncPeriph9   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph9   = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP9 == 1'b1)
      begin
         NxtSyncPeriph9   = 1'b1;
      end
      else
      begin
         NxtSyncPeriph9   = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP10 == 1'b1)
  begin
    if (ReqConfig[12] == 1'b1)
    begin
       HADDRMuP10       = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP10      = HWRITEM2;
       HTRANSMuP10      = HTRANSM2;
       HSIZEMuP10       = HSIZEM2;
       HBURSTMuP10      = HBURSTM2;
       HREADYINMuP10    = HREADYINM2;
    end
    else
    begin
       HADDRMuP10       = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP10      = HWRITEM1;
       HTRANSMuP10      = HTRANSM1;
       HSIZEMuP10       = HSIZEM1;
       HBURSTMuP10      = HBURSTM1;
       HREADYINMuP10    = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP10       = 'b0;
     HWRITEMuP10      = 1'b0;
     HTRANSMuP10      = 'b0;
     HSIZEMuP10       = 'b0;
     HBURSTMuP10      = 'b0;
     HREADYINMuP10    = 1'b0;
  end

 if (ReqConfig[12] == 1'b1)
 begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP10 == 1'b1)
      begin
         NxtSyncPeriph10  = 1'b1;
      end
      else
      begin
         NxtSyncPeriph10  = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP10 == 1'b1)
      begin
         NxtSyncPeriph10  = 1'b1;
      end
      else
      begin
         NxtSyncPeriph10  = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP11 == 1'b1)
  begin
    if (ReqConfig[13] == 1'b1)
    begin
       HADDRMuP11       = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP11      = HWRITEM2;
       HTRANSMuP11      = HTRANSM2;
       HSIZEMuP11       = HSIZEM2;
       HBURSTMuP11      = HBURSTM2;
       HREADYINMuP11    = HREADYINM2;
    end
    else
    begin
       HADDRMuP11       = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP11      = HWRITEM1;
       HTRANSMuP11      = HTRANSM1;
       HSIZEMuP11       = HSIZEM1;
       HBURSTMuP11      = HBURSTM1;
       HREADYINMuP11    = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP11       = 'b0;
     HWRITEMuP11      = 1'b0;
     HTRANSMuP11      = 'b0;
     HSIZEMuP11       = 'b0;
     HBURSTMuP11      = 'b0;
     HREADYINMuP11    = 1'b0;
  end

 if (ReqConfig[13] == 1'b1)
 begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP11 == 1'b1)
      begin
         NxtSyncPeriph11  = 1'b1;
      end
      else
      begin
         NxtSyncPeriph11  = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP11 == 1'b1)
      begin
         NxtSyncPeriph11  = 1'b1;
      end
      else
      begin
         NxtSyncPeriph11  = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP12 == 1'b1)
  begin
    if (ReqConfig[14] == 1'b1)
    begin
       HADDRMuP12       = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP12      = HWRITEM2;
       HTRANSMuP12      = HTRANSM2;
       HSIZEMuP12       = HSIZEM2;
       HBURSTMuP12      = HBURSTM2;
       HREADYINMuP12    = HREADYINM2;
    end
    else
    begin
       HADDRMuP12       = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP12      = HWRITEM1;
       HTRANSMuP12      = HTRANSM1;
       HSIZEMuP12       = HSIZEM1;
       HBURSTMuP12      = HBURSTM1;
       HREADYINMuP12    = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP12       = 'b0;
     HWRITEMuP12      = 1'b0;
     HTRANSMuP12      = 'b0;
     HSIZEMuP12       = 'b0;
     HBURSTMuP12      = 'b0;
     HREADYINMuP12    = 1'b0;
  end

 if (ReqConfig[14] == 1'b1)
 begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP12 == 1'b1)
      begin
         NxtSyncPeriph12  = 1'b1;
      end
      else
      begin
         NxtSyncPeriph12  = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP12 == 1'b1)
      begin
         NxtSyncPeriph12  = 1'b1;
      end
      else
      begin
         NxtSyncPeriph12  = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP13 == 1'b1)
  begin
    if (ReqConfig[15] == 1'b1)
    begin
       HADDRMuP13       = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP13      = HWRITEM2;
       HTRANSMuP13      = HTRANSM2;
       HSIZEMuP13       = HSIZEM2;
       HBURSTMuP13      = HBURSTM2;
       HREADYINMuP13    = HREADYINM2;
    end
    else
    begin
       HADDRMuP13       = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP13      = HWRITEM1;
       HTRANSMuP13      = HTRANSM1;
       HSIZEMuP13       = HSIZEM1;
       HBURSTMuP13      = HBURSTM1;
       HREADYINMuP13    = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP13       = 'b0;
     HWRITEMuP13      = 1'b0;
     HTRANSMuP13      = 'b0;
     HSIZEMuP13       = 'b0;
     HBURSTMuP13      = 'b0;
     HREADYINMuP13    = 1'b0;
  end

 if (ReqConfig[15] == 1'b1)
 begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP13 == 1'b1)
      begin
         NxtSyncPeriph13  = 1'b1;
      end
      else
      begin
         NxtSyncPeriph13  = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP13 == 1'b1)
      begin
         NxtSyncPeriph13  = 1'b1;
      end
      else
      begin
         NxtSyncPeriph13  = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP14 == 1'b1)
  begin
    if (ReqConfig[16] == 1'b1)
    begin
       HADDRMuP14       = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP14      = HWRITEM2;
       HTRANSMuP14      = HTRANSM2;
       HSIZEMuP14       = HSIZEM2;
       HBURSTMuP14      = HBURSTM2;
       HREADYINMuP14    = HREADYINM2;
    end
    else
    begin
       HADDRMuP14       = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP14      = HWRITEM1;
       HTRANSMuP14      = HTRANSM1;
       HSIZEMuP14       = HSIZEM1;
       HBURSTMuP14      = HBURSTM1;
       HREADYINMuP14    = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP14       = 'b0;
     HWRITEMuP14      = 1'b0;
     HTRANSMuP14      = 'b0;
     HSIZEMuP14       = 'b0;
     HBURSTMuP14      = 'b0;
     HREADYINMuP14    = 1'b0;
  end

 if (ReqConfig[16] == 1'b1)
 begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP14 == 1'b1)
      begin
         NxtSyncPeriph14  = 1'b1;
      end
      else
      begin
         NxtSyncPeriph14  = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP14 == 1'b1)
      begin
         NxtSyncPeriph14  = 1'b1;
      end
      else
      begin
         NxtSyncPeriph14  = 1'b0;
      end
    end
  end

  if (HSELPERIPHuP15 == 1'b1)
  begin
    if (ReqConfig[17] == 1'b1)
    begin
       HADDRMuP15       = HADDRM2[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP15      = HWRITEM2;
       HTRANSMuP15      = HTRANSM2;
       HSIZEMuP15       = HSIZEM2;
       HBURSTMuP15      = HBURSTM2;
       HREADYINMuP15    = HREADYINM2;
    end
    else
    begin
       HADDRMuP15       = HADDRM1[`MASTERADDRHB:`MASTERADDRLB];
       HWRITEMuP15      = HWRITEM1;
       HTRANSMuP15      = HTRANSM1;
       HSIZEMuP15       = HSIZEM1;
       HBURSTMuP15      = HBURSTM1;
       HREADYINMuP15    = HREADYINM1;
    end
  end
  else
  begin
     HADDRMuP15       = 'b0;
     HWRITEMuP15      = 1'b0;
     HTRANSMuP15      = 'b0;
     HSIZEMuP15       = 'b0;
     HBURSTMuP15      = 'b0;
     HREADYINMuP15    = 1'b0;
  end

 if (ReqConfig[17] == 1'b1)
 begin
    if (HREADYINM2 == 1'b1)
    begin
      if (HSELPERIPHuP15 == 1'b1)
      begin
         NxtSyncPeriph15  = 1'b1;
      end
      else
      begin
         NxtSyncPeriph15  = 1'b0;
      end
    end
  end
  else
  begin
    if (HREADYINM1 == 1'b1)
    begin
      if (HSELPERIPHuP15 == 1'b1)
      begin
         NxtSyncPeriph15  = 1'b1;
      end
      else
      begin
         NxtSyncPeriph15  = 1'b0;
      end
    end
  end

end // p_ControlInfoComb

// -----------------------------------------------------------------------------
// Sync Sequential Block
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SyncSeq
  if (HRESETn == 1'b0)
  begin
     SyncMem0         <= 1'b0;
     SyncMem1         <= 1'b0;
     SyncPeriph0      <= 1'b0;
     SyncPeriph1      <= 1'b0;
     SyncPeriph2      <= 1'b0;
     SyncPeriph3      <= 1'b0;
     SyncPeriph4      <= 1'b0;
     SyncPeriph5      <= 1'b0;
     SyncPeriph6      <= 1'b0;
     SyncPeriph7      <= 1'b0;
     SyncPeriph8      <= 1'b0;
     SyncPeriph9      <= 1'b0;
     SyncPeriph10     <= 1'b0;
     SyncPeriph11     <= 1'b0;
     SyncPeriph12     <= 1'b0;
     SyncPeriph13     <= 1'b0;
     SyncPeriph14     <= 1'b0;
     SyncPeriph15     <= 1'b0;
    end
    else
    begin
     SyncMem0         <= NxtSyncMem0;
     SyncMem1         <= NxtSyncMem1;
     SyncPeriph0      <= NxtSyncPeriph0;
     SyncPeriph1      <= NxtSyncPeriph1;
     SyncPeriph2      <= NxtSyncPeriph2;
     SyncPeriph3      <= NxtSyncPeriph3;
     SyncPeriph4      <= NxtSyncPeriph4;
     SyncPeriph5      <= NxtSyncPeriph5;
     SyncPeriph6      <= NxtSyncPeriph6;
     SyncPeriph7      <= NxtSyncPeriph7;
     SyncPeriph8      <= NxtSyncPeriph8;
     SyncPeriph9      <= NxtSyncPeriph9;
     SyncPeriph10     <= NxtSyncPeriph10;
     SyncPeriph11     <= NxtSyncPeriph11;
     SyncPeriph12     <= NxtSyncPeriph12;
     SyncPeriph13     <= NxtSyncPeriph13;
     SyncPeriph14     <= NxtSyncPeriph14;
     SyncPeriph15     <= NxtSyncPeriph15;
  end
end // p_SyncSeq

// -----------------------------------------------------------------------------
// Read Write Data assignment Block
// -----------------------------------------------------------------------------
always @(SyncMem0 or HREADYOUTMuM0 or HRESPMuM0 or HRDATAMuM0 or SyncMem1 or
         HREADYOUTMuM1 or HRESPMuM1 or HRDATAMuM1 or SyncPeriph0 or
         HREADYOUTMuP0 or HRESPMuP0 or HRDATAMuP0 or SyncPeriph1 or
         HREADYOUTMuP1 or HRESPMuP1 or HRDATAMuP1 or SyncPeriph2 or
         HREADYOUTMuP2 or HRESPMuP2 or HRDATAMuP2 or SyncPeriph3 or
         HREADYOUTMuP3 or HRESPMuP3 or HRDATAMuP3 or SyncPeriph4 or
         HREADYOUTMuP4 or HRESPMuP4 or HRDATAMuP4 or SyncPeriph5 or
         HREADYOUTMuP5 or HRESPMuP5 or HRDATAMuP5 or SyncPeriph6 or
         HREADYOUTMuP6 or HRESPMuP6 or HRDATAMuP6 or SyncPeriph7 or
         HREADYOUTMuP7 or HRESPMuP7 or HRDATAMuP7 or SyncPeriph8 or
         HREADYOUTMuP8 or HRESPMuP8 or HRDATAMuP8 or SyncPeriph9 or
         HREADYOUTMuP9 or HRESPMuP9 or HRDATAMuP9 or SyncPeriph10 or
         HREADYOUTMuP10 or HRESPMuP10 or HRDATAMuP10 or SyncPeriph11 or
         HREADYOUTMuP11 or HRESPMuP11 or HRDATAMuP11 or SyncPeriph12 or
         HREADYOUTMuP12 or HRESPMuP12 or HRDATAMuP12 or SyncPeriph13 or
         HREADYOUTMuP13 or HRESPMuP13 or HRDATAMuP13 or SyncPeriph14 or
         HREADYOUTMuP14 or HRESPMuP14 or HRDATAMuP14 or SyncPeriph15 or
         HREADYOUTMuP15 or HRESPMuP15 or HRDATAMuP15 or HWDATAM2 or HWDATAM1 or
         ReqConfig or HRESETn)
begin : p_DataComb
  if (HRESETn == 1'b0)
  begin
     HREADYOUTM2      = 1'b1;
     HRESPM2          = 'b0;
     HRDATAM2         = 'b0;

     HREADYOUTM1      = 1'b1;
     HRESPM1          = 'b0;
     HRDATAM1         = 'b0;
  end

  if (SyncMem0 == 1'b1)
  begin
    if (ReqConfig[0] == 1'b1)
    begin
       HWDATAMuM0       = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuM0;
       HRESPM2          = HRESPMuM0;
       HRDATAM2         = HRDATAMuM0;
    end
    else
    begin
       HWDATAMuM0       = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuM0;
       HRESPM1          = HRESPMuM0;
       HRDATAM1         = HRDATAMuM0;
    end
  end
  else
  begin
     HWDATAMuM0       = 'b0;
  end

  if (SyncMem1 == 1'b1)
  begin
    if (ReqConfig[1] == 1'b1)
    begin
       HWDATAMuM1       = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuM1;
       HRESPM2          = HRESPMuM1;
       HRDATAM2         = HRDATAMuM1;
    end
    else
    begin
       HWDATAMuM1       = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuM1;
       HRESPM1          = HRESPMuM1;
       HRDATAM1         = HRDATAMuM1;
    end
  end
  else
  begin
     HWDATAMuM1       = 'b0;
  end

  if (SyncPeriph0 == 1'b1)
  begin
    if (ReqConfig[2] == 1'b1)
    begin
       HWDATAMuP0       = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP0;
       HRESPM2          = HRESPMuP0;
       HRDATAM2         = HRDATAMuP0;
    end
    else
    begin
       HWDATAMuP0       = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP0;
       HRESPM1          = HRESPMuP0;
       HRDATAM1         = HRDATAMuP0;
    end
  end
  else
  begin
     HWDATAMuP0       = 'b0;
   end

  if (SyncPeriph1 == 1'b1)
  begin
    if (ReqConfig[3] == 1'b1)
    begin
       HWDATAMuP1       = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP1;
       HRESPM2          = HRESPMuP1;
       HRDATAM2         = HRDATAMuP1;
    end
    else
    begin
       HWDATAMuP1       = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP1;
       HRESPM1          = HRESPMuP1;
       HRDATAM1         = HRDATAMuP1;
    end
  end
  else
  begin
     HWDATAMuP1       = 'b0;
  end

  if (SyncPeriph2 == 1'b1)
  begin
    if (ReqConfig[4] == 1'b1)
    begin
       HWDATAMuP2       = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP2;
       HRESPM2         = HRESPMuP2;
       HRDATAM2        = HRDATAMuP2;
    end
    else
    begin
       HWDATAMuP2       = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP2;
       HRESPM1          = HRESPMuP2;
       HRDATAM1         = HRDATAMuP2;
    end
  end
  else
  begin
     HWDATAMuP2       = 'b0;
  end

  if (SyncPeriph3 == 1'b1)
  begin
    if (ReqConfig[5] == 1'b1)
    begin
       HWDATAMuP3       = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP3;
       HRESPM2          = HRESPMuP3;
       HRDATAM2         = HRDATAMuP3;
    end
    else
    begin
       HWDATAMuP3       = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP3;
       HRESPM1          = HRESPMuP3;
       HRDATAM1         = HRDATAMuP3;
    end
  end
  else
  begin
     HWDATAMuP3       = 'b0;
  end

  if (SyncPeriph4 == 1'b1)
  begin
    if (ReqConfig[6] == 1'b1)
    begin
       HWDATAMuP4       = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP4;
       HRESPM2          = HRESPMuP4;
       HRDATAM2         = HRDATAMuP4;
    end
    else
    begin
       HWDATAMuP4       = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP4;
       HRESPM1          = HRESPMuP4;
       HRDATAM1         = HRDATAMuP4;
    end
  end
  else
  begin
     HWDATAMuP4       = 'b0;
  end

  if (SyncPeriph5 == 1'b1)
  begin
    if (ReqConfig[7] == 1'b1)
    begin
       HWDATAMuP5       = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP5;
       HRESPM2          = HRESPMuP5;
       HRDATAM2         = HRDATAMuP5;
    end
    else
    begin
       HWDATAMuP5       = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP5;
       HRESPM1          = HRESPMuP5;
       HRDATAM1         = HRDATAMuP5;
    end
  end
  else
  begin
     HWDATAMuP5       = 'b0;
  end

  if (SyncPeriph6 == 1'b1)
  begin
    if (ReqConfig[8] == 1'b1)
    begin
       HWDATAMuP6       = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP6;
       HRESPM2          = HRESPMuP6;
       HRDATAM2         = HRDATAMuP6;
    end
    else
    begin
       HWDATAMuP6       = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP6;
       HRESPM1          = HRESPMuP6;
       HRDATAM1         = HRDATAMuP6;
    end
  end
  else
  begin
     HWDATAMuP6       = 'b0;
  end

  if (SyncPeriph7 == 1'b1)
  begin
    if (ReqConfig[9] == 1'b1)
    begin
       HWDATAMuP7       = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP7;
       HRESPM2          = HRESPMuP7;
       HRDATAM2         = HRDATAMuP7;
    end
    else
    begin
       HWDATAMuP7       = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP7;
       HRESPM1          = HRESPMuP7;
       HRDATAM1         = HRDATAMuP7;
    end
  end
  else
  begin
     HWDATAMuP7       = 'b0;
  end

  if (SyncPeriph8 == 1'b1)
  begin
    if (ReqConfig[10] == 1'b1)
    begin
       HWDATAMuP8       = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP8;
       HRESPM2          = HRESPMuP8;
       HRDATAM2         = HRDATAMuP8;
    end
    else
    begin
       HWDATAMuP8       = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP8;
       HRESPM1          = HRESPMuP8;
       HRDATAM1         = HRDATAMuP8;
    end
  end
  else
  begin
     HWDATAMuP8       = 'b0;
  end

  if (SyncPeriph9 == 1'b1)
  begin
    if (ReqConfig[11] == 1'b1)
    begin
       HWDATAMuP9       = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP9;
       HRESPM2          = HRESPMuP9;
       HRDATAM2         = HRDATAMuP9;
    end
    else
    begin
       HWDATAMuP9       = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP9;
       HRESPM1          = HRESPMuP9;
       HRDATAM1         = HRDATAMuP9;
    end
  end
  else
  begin
     HWDATAMuP9       = 'b0;
  end

  if (SyncPeriph10 == 1'b1)
  begin
    if (ReqConfig[12] == 1'b1)
    begin
       HWDATAMuP10      = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP10;
       HRESPM2          = HRESPMuP10;
       HRDATAM2         = HRDATAMuP10;
    end
    else
    begin
       HWDATAMuP10      = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP10;
       HRESPM1          = HRESPMuP10;
       HRDATAM1         = HRDATAMuP10;
    end
  end
  else
  begin
     HWDATAMuP10      = 'b0;
  end

  if (SyncPeriph11 == 1'b1)
  begin
    if (ReqConfig[13] == 1'b1)
    begin
       HWDATAMuP11      = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP11;
       HRESPM2          = HRESPMuP11;
       HRDATAM2         = HRDATAMuP11;
    end
    else
    begin
       HWDATAMuP11      = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP11;
       HRESPM1          = HRESPMuP11;
       HRDATAM1         = HRDATAMuP11;
    end
  end
  else
  begin
     HWDATAMuP11      = 'b0;
  end

  if (SyncPeriph12 == 1'b1)
  begin
    if (ReqConfig[14] == 1'b1)
    begin
       HWDATAMuP12      = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP12;
       HRESPM2          = HRESPMuP12;
       HRDATAM2         = HRDATAMuP12;
    end
    else
    begin
       HWDATAMuP12      = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP12;
       HRESPM1          = HRESPMuP12;
       HRDATAM1         = HRDATAMuP12;
    end
  end
  else
  begin
     HWDATAMuP12      = 'b0;
  end

  if (SyncPeriph13 == 1'b1)
  begin
    if (ReqConfig[15] == 1'b1)
    begin
       HWDATAMuP13      = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP13;
       HRESPM2          = HRESPMuP13;
       HRDATAM2         = HRDATAMuP13;
    end
    else
    begin
       HWDATAMuP13      = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP13;
       HRESPM1          = HRESPMuP13;
       HRDATAM1         = HRDATAMuP13;
    end
  end
  else
  begin
     HWDATAMuP13      = 'b0;
  end

  if (SyncPeriph14 == 1'b1)
  begin
    if (ReqConfig[16] == 1'b1)
    begin
       HWDATAMuP14      = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP14;
       HRESPM2          = HRESPMuP14;
       HRDATAM2         = HRDATAMuP14;
    end
    else
    begin
       HWDATAMuP14      = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP14;
       HRESPM1          = HRESPMuP14;
       HRDATAM1         = HRDATAMuP14;
    end
  end
  else
  begin
     HWDATAMuP14      = 'b0;
  end

  if (SyncPeriph15 == 1'b1)
  begin
    if (ReqConfig[17] == 1'b1)
    begin
       HWDATAMuP15      = HWDATAM2;
       HREADYOUTM2      = HREADYOUTMuP15;
       HRESPM2          = HRESPMuP15;
       HRDATAM2         = HRDATAMuP15;
    end
    else
    begin
       HWDATAMuP15      = HWDATAM1;
       HREADYOUTM1      = HREADYOUTMuP15;
       HRESPM1          = HRESPMuP15;
       HRDATAM1         = HRDATAMuP15;
    end
  end
  else
  begin
     HWDATAMuP15      = 'b0;
  end

end // p_DataComb

// -----------------------------------------------------------------------------
// RegSync Generation Block
// -----------------------------------------------------------------------------
always @(HSELREGuM0 or HSELREGuM1 or HSELREGuP0 or HSELREGuP1 or HSELREGuP2 or
         HSELREGuP3 or HSELREGuP4 or HSELREGuP5 or HSELREGuP6 or HSELREGuP7 or
         HSELREGuP8 or HSELREGuP9 or HSELREGuP10 or HSELREGuP11 or
         HSELREGuP12 or HSELREGuP13 or HSELREGuP14 or HSELREGuP15 or
         RegSyncP0 or RegSyncP1 or RegSyncP2 or RegSyncP3 or RegSyncP4 or
         RegSyncP5 or RegSyncP6 or RegSyncP7 or RegSyncP8 or RegSyncP9 or
         RegSyncP10 or RegSyncP11 or RegSyncP12 or RegSyncP13 or RegSyncP14 or
         RegSyncP15 or RegSyncMem0 or RegSyncMem1 or RegSyncTr or
         HSELDMACTrSlave)
begin : p_RegAssignComb
   NxtRegSyncTr     = RegSyncTr;
   NxtRegSyncMem0   = RegSyncMem0;
   NxtRegSyncMem1   = RegSyncMem1;
   NxtRegSyncP0     = RegSyncP0;
   NxtRegSyncP1     = RegSyncP1;
   NxtRegSyncP2     = RegSyncP2;
   NxtRegSyncP3     = RegSyncP3;
   NxtRegSyncP4     = RegSyncP4;
   NxtRegSyncP5     = RegSyncP5;
   NxtRegSyncP6     = RegSyncP6;
   NxtRegSyncP7     = RegSyncP7;
   NxtRegSyncP8     = RegSyncP8;
   NxtRegSyncP9     = RegSyncP9;
   NxtRegSyncP10    = RegSyncP10;
   NxtRegSyncP11    = RegSyncP11;
   NxtRegSyncP12    = RegSyncP12;
   NxtRegSyncP13    = RegSyncP13;
   NxtRegSyncP14    = RegSyncP14;
   NxtRegSyncP15    = RegSyncP15;

  if (HSELDMACTrSlave == 1'b1)
  begin
     NxtRegSyncTr     = 1'b1;
  end
  else
  begin
     NxtRegSyncTr     = 1'b0;
  end

  if (HSELREGuM0 == 1'b1)
  begin
     NxtRegSyncMem0   = 1'b1;
  end
  else
  begin
     NxtRegSyncMem0   = 1'b0;
  end

  if (HSELREGuM1 == 1'b1)
  begin
     NxtRegSyncMem1   = 1'b1;
  end
  else
  begin
     NxtRegSyncMem1   = 1'b0;
  end

  if (HSELREGuP0 == 1'b1)
  begin
     NxtRegSyncP0     = 1'b1;
  end
  else
  begin
     NxtRegSyncP0     = 1'b0;
  end

  if (HSELREGuP1 == 1'b1)
  begin
     NxtRegSyncP1     = 1'b1;
  end
  else
  begin
     NxtRegSyncP1     = 1'b0;
  end

  if (HSELREGuP2 == 1'b1)
  begin
     NxtRegSyncP2     = 1'b1;
  end
  else
  begin
     NxtRegSyncP2     = 1'b0;
  end

  if (HSELREGuP3 == 1'b1)
  begin
     NxtRegSyncP3     = 1'b1;
  end
  else
  begin
     NxtRegSyncP3     = 1'b0;
  end

  if (HSELREGuP4 == 1'b1)
  begin
     NxtRegSyncP4     = 1'b1;
  end
  else
  begin
     NxtRegSyncP4     = 1'b0;
  end

  if (HSELREGuP5 == 1'b1)
  begin
     NxtRegSyncP5     = 1'b1;
  end
  else
  begin
     NxtRegSyncP5     = 1'b0;
  end

  if (HSELREGuP6 == 1'b1)
  begin
     NxtRegSyncP6     = 1'b1;
  end
  else
  begin
     NxtRegSyncP6     = 1'b0;
  end

  if (HSELREGuP7 == 1'b1)
  begin
     NxtRegSyncP7     = 1'b1;
  end
  else
  begin
     NxtRegSyncP7     = 1'b0;
  end

  if (HSELREGuP8 == 1'b1)
  begin
     NxtRegSyncP8     = 1'b1;
  end
  else
  begin
     NxtRegSyncP8     = 1'b0;
  end

  if (HSELREGuP9 == 1'b1)
  begin
     NxtRegSyncP9     = 1'b1;
  end
  else
  begin
     NxtRegSyncP9     = 1'b0;
  end

  if (HSELREGuP10 == 1'b1)
  begin
     NxtRegSyncP10    = 1'b1;
  end
  else
  begin
     NxtRegSyncP10    = 1'b0;
  end

  if (HSELREGuP11 == 1'b1)
  begin
     NxtRegSyncP11    = 1'b1;
  end
  else
  begin
     NxtRegSyncP11    = 1'b0;
  end

  if (HSELREGuP12 == 1'b1)
  begin
     NxtRegSyncP12    = 1'b1;
  end
  else
  begin
     NxtRegSyncP12    = 1'b0;
  end

  if (HSELREGuP13 == 1'b1)
  begin
     NxtRegSyncP13    = 1'b1;
  end
  else
  begin
     NxtRegSyncP13    = 1'b0;
  end

  if (HSELREGuP14 == 1'b1)
  begin
     NxtRegSyncP14    = 1'b1;
  end
  else
  begin
     NxtRegSyncP14    = 1'b0;
  end

  if (HSELREGuP15 == 1'b1)
  begin
     NxtRegSyncP15    = 1'b1;
  end
  else
  begin
     NxtRegSyncP15    = 1'b0;
  end
end // p_RegAssignComb

// -----------------------------------------------------------------------------
// RegSync Sequential Block
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegSeq
  if (HRESETn == 1'b0)
  begin
     RegSyncTr        <= 1'b0;
     RegSyncMem0      <= 1'b0;
     RegSyncMem1      <= 1'b0;
     RegSyncP0        <= 1'b0;
     RegSyncP1        <= 1'b0;
     RegSyncP2        <= 1'b0;
     RegSyncP3        <= 1'b0;
     RegSyncP4        <= 1'b0;
     RegSyncP5        <= 1'b0;
     RegSyncP6        <= 1'b0;
     RegSyncP7        <= 1'b0;
     RegSyncP8        <= 1'b0;
     RegSyncP9        <= 1'b0;
     RegSyncP10       <= 1'b0;
     RegSyncP11       <= 1'b0;
     RegSyncP12       <= 1'b0;
     RegSyncP13       <= 1'b0;
     RegSyncP14       <= 1'b0;
     RegSyncP15       <= 1'b0;
    end
    else
    begin
     RegSyncTr        <= NxtRegSyncTr;
     RegSyncMem0      <= NxtRegSyncMem0;
     RegSyncMem1      <= NxtRegSyncMem1;
     RegSyncP0        <= NxtRegSyncP0;
     RegSyncP1        <= NxtRegSyncP1;
     RegSyncP2        <= NxtRegSyncP2;
     RegSyncP3        <= NxtRegSyncP3;
     RegSyncP4        <= NxtRegSyncP4;
     RegSyncP5        <= NxtRegSyncP5;
     RegSyncP6        <= NxtRegSyncP6;
     RegSyncP7        <= NxtRegSyncP7;
     RegSyncP8        <= NxtRegSyncP8;
     RegSyncP9        <= NxtRegSyncP9;
     RegSyncP10       <= NxtRegSyncP10;
     RegSyncP11       <= NxtRegSyncP11;
     RegSyncP12       <= NxtRegSyncP12;
     RegSyncP13       <= NxtRegSyncP13;
     RegSyncP14       <= NxtRegSyncP14;
     RegSyncP15       <= NxtRegSyncP15;
  end
end // p_RegSeq

// -----------------------------------------------------------------------------
// Read Write Data combo block.
// -----------------------------------------------------------------------------
always @(RegSyncMem0 or RegSyncMem1 or HREADYOUTuM0 or HREADYOUTuM1 or
         HRESPuM0 or HRESPuM1 or HRDATAuM0 or HRDATAuM1 or RegSyncP0 or
         HREADYOUTuP0 or HRESPuP0 or HRDATAuP0 or RegSyncP1 or HREADYOUTuP1 or
         HRESPuP1 or HRDATAuP1 or RegSyncP2 or HREADYOUTuP2 or HRESPuP2 or
         HRDATAuP2 or RegSyncP3 or HREADYOUTuP3 or HRESPuP3 or HRDATAuP3 or
         RegSyncP4 or HREADYOUTuP4 or HRESPuP4 or HRDATAuP4 or RegSyncP5 or
         HREADYOUTuP5 or HRESPuP5 or HRDATAuP5 or RegSyncP6 or HREADYOUTuP6 or
         HRESPuP6 or HRDATAuP6 or RegSyncP7 or HREADYOUTuP7 or HRESPuP7 or
         HRDATAuP7 or RegSyncP8 or HREADYOUTuP8 or HRESPuP8 or HRDATAuP8 or
         RegSyncP9 or HREADYOUTuP9 or HRESPuP9 or HRDATAuP9 or RegSyncP10 or
         HREADYOUTuP10 or HRESPuP10 or HRDATAuP10 or RegSyncP11 or
         HREADYOUTuP11 or HRESPuP11 or HRDATAuP11 or RegSyncP12 or
         HREADYOUTuP12 or HRESPuP12 or HRDATAuP12 or RegSyncP13 or
         HREADYOUTuP13 or HRESPuP13 or HRDATAuP13 or RegSyncP14 or
         HREADYOUTuP14 or HRESPuP14 or HRDATAuP14 or RegSyncP15 or
         HREADYOUTuP15 or HRESPuP15 or HRDATAuP15 or HRESETn or RegSyncTr or
         HREADYOUTTrIn or HRESPTrIn)
begin : p_RegDataComb

  if (HRESETn == 1'b0)
  begin
     HREADYOUT        = 1'b1;
     HRESP            = 'b0;
     HRDATA           = 'b0;
  end

  if (RegSyncTr == 1'b1)
  begin
     HREADYOUT        = HREADYOUTTrIn;
     HRESP            = HRESPTrIn;
  end

  if (RegSyncMem0 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuM0;
     HRESP            = HRESPuM0;
     HRDATA           = HRDATAuM0;
  end

  if (RegSyncMem1 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuM1;
     HRESP            = HRESPuM1;
     HRDATA           = HRDATAuM1;
  end

  if (RegSyncP0 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP0;
     HRESP            = HRESPuP0;
     HRDATA           = HRDATAuP0;
  end

  if (RegSyncP1 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP1;
     HRESP           = HRESPuP1;
     HRDATA          = HRDATAuP1;
  end

  if (RegSyncP2 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP2;
     HRESP            = HRESPuP2;
     HRDATA           = HRDATAuP2;
  end

  if (RegSyncP3 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP3;
     HRESP            = HRESPuP3;
     HRDATA           = HRDATAuP3;
  end

  if (RegSyncP4 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP4;
     HRESP            = HRESPuP4;
     HRDATA           = HRDATAuP4;
  end

  if (RegSyncP5 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP5;
     HRESP            = HRESPuP5;
     HRDATA           = HRDATAuP5;
  end

  if (RegSyncP6 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP6;
     HRESP            = HRESPuP6;
     HRDATA           = HRDATAuP6;
  end

  if (RegSyncP7 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP7;
     HRESP            = HRESPuP7;
     HRDATA           = HRDATAuP7;
  end

  if (RegSyncP8 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP8;
     HRESP            = HRESPuP8;
     HRDATA           = HRDATAuP8;
  end

  if (RegSyncP9 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP9;
     HRESP            = HRESPuP9;
     HRDATA           = HRDATAuP9;
  end

  if (RegSyncP10 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP10;
     HRESP            = HRESPuP10;
     HRDATA           = HRDATAuP10;
  end

  if (RegSyncP11 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP11;
     HRESP            = HRESPuP11;
     HRDATA           = HRDATAuP11;
  end

  if (RegSyncP12 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP12;
     HRESP            = HRESPuP12;
     HRDATA           = HRDATAuP12;
  end

  if (RegSyncP13 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP13;
     HRESP            = HRESPuP13;
     HRDATA           = HRDATAuP13;
  end

  if (RegSyncP14 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP14;
     HRESP            = HRESPuP14;
     HRDATA           = HRDATAuP14;
  end

  if (RegSyncP15 == 1'b1)
  begin
     HREADYOUT        = HREADYOUTuP15;
     HRESP            = HRESPuP15;
     HRDATA           = HRDATAuP15;
  end
end // p_RegDataComb

endmodule

// --================================== End ==================================--
