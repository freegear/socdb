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
// File Name              : DmacTrAhbSlaveIf.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Behavioural DMAC's AHB Slave Interface module. This module is
//           responsible for generating all the Write Enables for the channel.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacTrAhbSlaveIf (
// Inputs
                         // AHB signals
                         HCLK,
                         HRESETn,
                         HSELDMAC,
                         HSELDMACTrSlave,
                         HWRITE,
                         HTRANS,
                         HWDATA,
                         HADDR,
                         HSIZE,
                         HREADYIN,
                         SoftClr,
                         DmacClr,
                         DMACBREQ,
                         DMACLBREQ,
                         DMACSREQ,
                         DMACLSREQ,
// Outputs
                         // AHB signals
                         HREADYOUT,
                         HRESP,
                         // Write Enables for Channel Registers
                         DmacSrcRegWrEn0,
                         DmacDstRegWrEn0,
                         DmacLLIRegWrEn0,
                         DmacCntlRegWrEn0,
                         DmacChCnfgWrEn0,
                         DmacSrcRegWrEn1,
                         DmacDstRegWrEn1,
                         DmacLLIRegWrEn1,
                         DmacCntlRegWrEn1,
                         DmacChCnfgWrEn1,
                         DmacSrcRegWrEn2,
                         DmacDstRegWrEn2,
                         DmacLLIRegWrEn2,
                         DmacCntlRegWrEn2,
                         DmacChCnfgWrEn2,
                         DmacSrcRegWrEn3,
                         DmacDstRegWrEn3,
                         DmacLLIRegWrEn3,
                         DmacCntlRegWrEn3,
                         DmacChCnfgWrEn3,
                         DmacSrcRegWrEn4,
                         DmacDstRegWrEn4,
                         DmacLLIRegWrEn4,
                         DmacCntlRegWrEn4,
                         DmacChCnfgWrEn4,
                         DmacSrcRegWrEn5,
                         DmacDstRegWrEn5,
                         DmacLLIRegWrEn5,
                         DmacCntlRegWrEn5,
                         DmacChCnfgWrEn5,
                         DmacSrcRegWrEn6,
                         DmacDstRegWrEn6,
                         DmacLLIRegWrEn6,
                         DmacCntlRegWrEn6,
                         DmacChCnfgWrEn6,
                         DmacSrcRegWrEn7,
                         DmacDstRegWrEn7,
                         DmacLLIRegWrEn7,
                         DmacCntlRegWrEn7,
                         DmacChCnfgWrEn7,
                         // Request signals to the channels
                         DMACBREQCh,
                         DMACLBREQCh,
                         DMACSREQCh,
                         DMACLSREQCh,
                         SOFTBREQCh,
                         SOFTLBREQCh,
                         SOFTSREQCh,
                         SOFTLSREQCh,
                         // DMAC interrupt request signals
                         ClrIntErr,
                         ClrIntTC,
                         DMACEn,
                         ReqConfig,
                         GrantCount0,
                         GrantCount1,
                         DmacTrEn,
                         MasterEndian1,
                         MasterEndian2
                         );

// Inputs

// AHB signals
input         HCLK;             // AHB clock
input         HRESETn;          // AHB Reset
input         HSELDMAC;         // Slave Select for DMAC
input         HSELDMACTrSlave;  // Trickbox Select from AHB3
input         HWRITE;           // Write signal from AHB3
input         HTRANS;           // Type of transfer on AHB Bit 1 of HTRANS on
                                // AHB
input  [31:0] HWDATA;           // AHB Write Data bus
input  [20:2] HADDR;            // AHB slave address
input   [2:0] HSIZE;            // The width of the transfer on AHB
input         HREADYIN;         // Ready response on AHB from previous Slave
input  [15:0] SoftClr;          // Clear from all the channels for SoftReq
input  [15:0] DmacClr;          // Clear from all the channels
input  [15:0] DMACBREQ;         // DMAC burst transfer request
input  [15:0] DMACLBREQ;        // DMAC last burst transfer request
input  [15:0] DMACSREQ;         // DMAC single transfer request
input  [15:0] DMACLSREQ;        // DMAC last single transfer request

// Outputs

// AHB signals
output        HREADYOUT;        // Transfer response from Trickbox AHB slave
                                // interface when HSELDMACTr is asserted
output  [1:0] HRESP;            // Ready response from Trickbox AHB slave
                                // interface when HSELDMACTr is asserted

// Write Enables for Channel Registers
output        DmacSrcRegWrEn0;  // Write Enable for DMACC0SrcAddr
output        DmacDstRegWrEn0;  // Write Enable for DMACC0DestAddr
output        DmacLLIRegWrEn0;  // Write Enable for DMACC0LLIReg
output        DmacCntlRegWrEn0; // Write Enable for DMACC0Control
output        DmacChCnfgWrEn0;  // Write Enable for DMACC0Config
output        DmacSrcRegWrEn1;  // Write Enable for DMACC1SrcAddr
output        DmacDstRegWrEn1;  // Write Enable for DMACC1DestAddr
output        DmacLLIRegWrEn1;  // Write Enable for DMACC1LLIReg
output        DmacCntlRegWrEn1; // Write Enable for DMACC1Control
output        DmacChCnfgWrEn1;  // Write Enable for DMACC1Config
output        DmacSrcRegWrEn2;  // Write Enable for DMACC2SrcAddr
output        DmacDstRegWrEn2;  // Write Enable for DMACC2DestAddr
output        DmacLLIRegWrEn2;  // Write Enable for DMACC2LLIReg
output        DmacCntlRegWrEn2; // Write Enable for DMACC2Control
output        DmacChCnfgWrEn2;  // Write Enable for DMACC2Config
output        DmacSrcRegWrEn3;  // Write Enable for DMACC3SrcAddr
output        DmacDstRegWrEn3;  // Write Enable for DMACC3DestAddr
output        DmacLLIRegWrEn3;  // Write Enable for DMACC3LLIReg
output        DmacCntlRegWrEn3; // Write Enable for DMACC3Control
output        DmacChCnfgWrEn3;  // Write Enable for DMACC3Config
output        DmacSrcRegWrEn4;  // Write Enable for DMACC4SrcAddr
output        DmacDstRegWrEn4;  // Write Enable for DMACC4DestAddr
output        DmacLLIRegWrEn4;  // Write Enable for DMACC4LLIReg
output        DmacCntlRegWrEn4; // Write Enable for DMACC4Control
output        DmacChCnfgWrEn4;  // Write Enable for DMACC4Config
output        DmacSrcRegWrEn5;  // Write Enable for DMACC5SrcAddr
output        DmacDstRegWrEn5;  // Write Enable for DMACC5DestAddr
output        DmacLLIRegWrEn5;  // Write Enable for DMACC5LLIReg
output        DmacCntlRegWrEn5; // Write Enable for DMACC5Control
output        DmacChCnfgWrEn5;  // Write Enable for DMACC5Config
output        DmacSrcRegWrEn6;  // Write Enable for DMACC6SrcAddr
output        DmacDstRegWrEn6;  // Write Enable for DMACC6DestAddr
output        DmacLLIRegWrEn6;  // Write Enable for DMACC6LLIReg
output        DmacCntlRegWrEn6; // Write Enable for DMACC6Control
output        DmacChCnfgWrEn6;  // Write Enable for DMACC6Config
output        DmacSrcRegWrEn7;  // Write Enable for DMACC7SrcAddr
output        DmacDstRegWrEn7;  // Write Enable for DMACC7DestAddr
output        DmacLLIRegWrEn7;  // Write Enable for DMACC7LLIReg
output        DmacCntlRegWrEn7; // Write Enable for DMACC7Control
output        DmacChCnfgWrEn7;  // Write Enable for DMACC7Config

// Request signals to the channels
output [15:0] DMACBREQCh;       // DMAC burst transfer request
output [15:0] DMACLBREQCh;      // DMAC last burst transfer request
output [15:0] DMACSREQCh;       // DMAC single transfer request
output [15:0] DMACLSREQCh;      // DMAC last single transfer request
output [15:0] SOFTBREQCh;       // Soft burst transfer request
output [15:0] SOFTLBREQCh;      // Soft last burst transfer request
output [15:0] SOFTSREQCh;       // Soft single transfer request
output [15:0] SOFTLSREQCh;      // Soft last single transfer request

// DMAC interrupt request signals
output  [7:0] ClrIntErr;        // Clear for DMAC error interrupt
output  [7:0] ClrIntTC;         // Clear for DMAC TC interrupt
output        DMACEn;           // DMAC Controller Enable
output [17:0] ReqConfig;        // Config Reg for Periph/Mem module
output [31:0] GrantCount0;      // Trickbox Grant Generation Reg0
output [31:0] GrantCount1;      // Trickbox Grant Generation Reg1
output        DmacTrEn;         // DMAC Trickbox Enable
output        MasterEndian1;    // Endianness bit for master 1
output        MasterEndian2;    // Endianness bit for master 2




// Inputs

// AHB signals
  wire        HCLK;             // AHB clock
  wire        HRESETn;          // AHB Reset
  wire        HSELDMAC;         // Slave Select for DMAC
  wire        HSELDMACTrSlave;  // Trickbox Select from AHB3
  wire        HWRITE;           // Write signal from AHB3
  wire        HTRANS;           // Type of transfer on AHB Bit 1 of HTRANS on
                                // AHB
  wire [31:0] HWDATA;           // AHB Write Data bus
  wire [20:2] HADDR;            // AHB slave address
  wire  [2:0] HSIZE;            // The width of the transfer on AHB
  wire        HREADYIN;         // Ready response on AHB from previous Slave
  wire [15:0] SoftClr;          // Clear from all the channels for SoftReq
  wire [15:0] DmacClr;          // Clear from all the channels
  wire [15:0] DMACBREQ;         // DMAC burst transfer request
  wire [15:0] DMACLBREQ;        // DMAC last burst transfer request
  wire [15:0] DMACSREQ;         // DMAC single transfer request
  wire [15:0] DMACLSREQ;        // DMAC last single transfer request

// Outputs

// AHB signals
  wire        HREADYOUT;        // Transferr response from Trickbox AHB slave
                                // interface when HSELDMACTr is asserted
  wire  [1:0] HRESP;            // Ready response from Trickbox AHB slave
                                // interface when HSELDMACTr is asserted

// Write Enables for Channel Registers
  reg         DmacSrcRegWrEn0;  // Write Enable for DMACC0SrcAddr
  reg         DmacDstRegWrEn0;  // Write Enable for DMACC0DestAddr
  reg         DmacLLIRegWrEn0;  // Write Enable for DMACC0LLIReg
  reg         DmacCntlRegWrEn0; // Write Enable for DMACC0Control
  reg         DmacChCnfgWrEn0;  // Write Enable for DMACC0Config
  reg         DmacSrcRegWrEn1;  // Write Enable for DMACC1SrcAddr
  reg         DmacDstRegWrEn1;  // Write Enable for DMACC1DestAddr
  reg         DmacLLIRegWrEn1;  // Write Enable for DMACC1LLIReg
  reg         DmacCntlRegWrEn1; // Write Enable for DMACC1Control
  reg         DmacChCnfgWrEn1;  // Write Enable for DMACC1Config
  reg         DmacSrcRegWrEn2;  // Write Enable for DMACC2SrcAddr
  reg         DmacDstRegWrEn2;  // Write Enable for DMACC2DestAddr
  reg         DmacLLIRegWrEn2;  // Write Enable for DMACC2LLIReg
  reg         DmacCntlRegWrEn2; // Write Enable for DMACC2Control
  reg         DmacChCnfgWrEn2;  // Write Enable for DMACC2Config
  reg         DmacSrcRegWrEn3;  // Write Enable for DMACC3SrcAddr
  reg         DmacDstRegWrEn3;  // Write Enable for DMACC3DestAddr
  reg         DmacLLIRegWrEn3;  // Write Enable for DMACC3LLIReg
  reg         DmacCntlRegWrEn3; // Write Enable for DMACC3Control
  reg         DmacChCnfgWrEn3;  // Write Enable for DMACC3Config
  reg         DmacSrcRegWrEn4;  // Write Enable for DMACC4SrcAddr
  reg         DmacDstRegWrEn4;  // Write Enable for DMACC4DestAddr
  reg         DmacLLIRegWrEn4;  // Write Enable for DMACC4LLIReg
  reg         DmacCntlRegWrEn4; // Write Enable for DMACC4Control
  reg         DmacChCnfgWrEn4;  // Write Enable for DMACC4Config
  reg         DmacSrcRegWrEn5;  // Write Enable for DMACC5SrcAddr
  reg         DmacDstRegWrEn5;  // Write Enable for DMACC5DestAddr
  reg         DmacLLIRegWrEn5;  // Write Enable for DMACC5LLIReg
  reg         DmacCntlRegWrEn5; // Write Enable for DMACC5Control
  reg         DmacChCnfgWrEn5;  // Write Enable for DMACC5Config
  reg         DmacSrcRegWrEn6;  // Write Enable for DMACC6SrcAddr
  reg         DmacDstRegWrEn6;  // Write Enable for DMACC6DestAddr
  reg         DmacLLIRegWrEn6;  // Write Enable for DMACC6LLIReg
  reg         DmacCntlRegWrEn6; // Write Enable for DMACC6Control
  reg         DmacChCnfgWrEn6;  // Write Enable for DMACC6Config
  reg         DmacSrcRegWrEn7;  // Write Enable for DMACC7SrcAddr
  reg         DmacDstRegWrEn7;  // Write Enable for DMACC7DestAddr
  reg         DmacLLIRegWrEn7;  // Write Enable for DMACC7LLIReg
  reg         DmacCntlRegWrEn7; // Write Enable for DMACC7Control
  reg         DmacChCnfgWrEn7;  // Write Enable for DMACC7Config

// Request signals to the channels
  reg  [15:0] DMACBREQCh;       // DMAC burst transfer request
  reg  [15:0] DMACLBREQCh;      // DMAC last burst transfer request
  reg  [15:0] DMACSREQCh;       // DMAC single transfer request
  reg  [15:0] DMACLSREQCh;      // DMAC last single transfer request
  wire [15:0] SOFTBREQCh;       // Soft burst transfer request
  wire [15:0] SOFTLBREQCh;      // Soft last burst transfer request
  wire [15:0] SOFTSREQCh;       // Soft single transfer request
  wire [15:0] SOFTLSREQCh;      // Soft last single transfer request

// DMAC interrupt request signals
  wire  [7:0] ClrIntErr;        // Clear for DMAC error interrupt
  wire  [7:0] ClrIntTC;         // Clear for DMAC TC interrupt
  wire        DMACEn;           // DMAC Controller Enable
  wire [17:0] ReqConfig;        // Config Reg for Periph/Mem module
  wire [31:0] GrantCount0;      // Trickbox Grant Generation Reg0
  wire [31:0] GrantCount1;      // Trickbox Grant Generation Reg1
  wire        DmacTrEn;         // DMAC Trickbox Enable
  wire        MasterEndian1;    // Endianness bit for master 1
  wire        MasterEndian2;    // Endianness bit for master 2


// -----------------------------------------------------------------------------
//
//                              DmacTrAhbSlaveIf
//                              ================
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module is responsible for generating all the Write Enables for the
// channel. The Synchronizers for the peripheral request lines are implemented
// here. The interrupts and clear are generated in this module
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire        iDMACEn;
// Internal copy of DMACEn

wire        ITEN;
// Integration test enable signal

wire  [7:0] iClrIntErr;
// Internal copy of ClrIntErr output

wire  [7:0] NextClrIntErr;
// D input of iClrIntErr flip-flop

wire  [7:0] iClrIntTC;
// Internal copy of ClrIntTC output

wire  [7:0] NextClrIntTC;
// D input of iClrIntTC flip-flop

wire  [3:0] NextDMACConfig;
// D Input of DMACConfig register

wire [15:0] NextDMACSync;
// D Input of DMACSync register

wire  [1:0] NextDMACTCR;
// D Input of DMACTCR register

wire [17:0] NextReqCfg;
// D-Input of iReqConfig

wire [31:0] NextGntCnt0;
// D-Input of iGrantCount0

wire [31:0] NextGntCnt1;
// D-Input of iGrantCount1

wire        NextDmacTrEn;
// D-Input of iDmacTrEn

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg   [1:0] iHRESP;
// Internal copy of HRESP

reg   [1:0] NextHRESP;
// D input of iHRESP flip-flop

reg         DmacTCClrWrEn;
// Write enable for DMACIntTCClr

reg         DmacErrClrWrEn;
// Write enable for DMACIntErrClr

reg         DmacITCRWrEn;
// Write enable for DMACTCR

reg         DmacSoftBWrEn;
// Write enable for DMACSoftBReq

reg         DmacSoftSWrEn;
// Write enable for DMACSoftSReq

reg         DmacSoftLBWrEn;
// Write enable for DMACSoftLBReq

reg         DmacSoftLSWrEn;
// Write enable for DMACSoftLSReq

reg         DmacCfgWrEn;
// Write enable for DMACConfig

reg         DmacSyncWrEn;
// Write enable for DMACSync register

reg   [3:0] DmacSlaveState;
// DMAC Slave SM's state Flip Flops

reg   [3:0] NextSlaveState;
// D input of DmacSlaveState flip-flop

reg         iHREADYOUT;
// Internal copy of iHREADYOUT

reg         NextHREADYOUT;
// D input of iHREADYOUT flip-flop

reg  [20:2] AddrBuff;
// Registered version of HADDR

reg  [20:2] NextAddrBuff;
// D Input of AddrBuff

reg  [15:0] DMACSoftSReq;
// Software DMASREQ Request register

reg  [15:0] NextSoftSReq;
// D Input of DMACSoftSReq register

reg  [15:0] DMACSoftBReq;
// Software DMABREQ Request register

reg  [15:0] NextSoftBReq;
// D Input of DMACSoftBReq register

reg  [15:0] DMACSoftLSReq;
// Software DMALSREQ Request register

reg  [15:0] NextSoftLSReq;
// D Input of DMACSoftLSReq register

reg  [15:0] DMACSoftLBReq;
// Software DMALBREQ Request register

reg  [15:0] NextSoftLBReq;
// D Input of DMACSoftLBReq register

reg   [3:0] DMACConfig;
// DMAC config register

reg  [15:0] DMACSync;
// DMAC request synchronisation control register

reg   [1:0] DMACTCR;
// DMAC Test control register

reg  [15:0] DMACSREQSync;
// Double synchronised signal for DMACSREQ

reg  [15:0] DMACBREQSync;
// Double synchronised signal for DMACBREQ

reg  [15:0] DMACLSREQSync;
// Double synchronised signal for DMACLSREQ

reg  [15:0] DMACLBREQSync;
// Double synchronised signal for DMACLBREQ

reg  [15:0] DMACSREQSync1;
// First level of synchronised signal for DMACSREQ

reg  [15:0] DMACBREQSync1;
// First level of synchronised signal for DMACBREQ

reg  [15:0] DMACLSREQSync1;
// First level of synchronised signal for DMACLSREQ

reg  [15:0] DMACLBREQSync1;
// First level of synchronised signal for DMACLBREQ

reg         ReqConfigWrEn;
// Write enable for trickbox ReqConfig register

reg  [17:0] iReqConfig;
// Internal copy of ReqConfig

reg  [31:0] iGrantCount0;
// Internal copy of GrantCount

reg  [31:0] iGrantCount1;
// Internal copy of GrantCount

reg         GntCnt0WrEn;
// Write enable for trickbox GrantCount0 register

reg         GntCnt1WrEn;
// Write enable for trickbox GrantCount1 register

reg         DmacTrWrEn;
// Write enable for Trickbox enable register

reg         iDmacTrEn;
// Internal copy of Trickbox enable

integer i;

// -----------------------------------------------------------------------------
// Package insertion
// -----------------------------------------------------------------------------
`include "DmacTrParams.v"

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
assign HRESP            = iHRESP;
assign HREADYOUT        = iHREADYOUT;
assign DMACEn           = iDMACEn;
assign ReqConfig        = iReqConfig;
assign GrantCount0      = iGrantCount0;
assign GrantCount1      = iGrantCount1;
assign DmacTrEn         = iDmacTrEn;
assign ClrIntErr        = iClrIntErr;
assign ClrIntTC         = iClrIntTC;
assign SOFTBREQCh       = DMACSoftBReq;
assign SOFTLBREQCh      = DMACSoftLBReq;
assign SOFTSREQCh       = DMACSoftSReq;
assign SOFTLSREQCh      = DMACSoftLSReq;

// -----------------------------------------------------------------------------
// Synchronising the requests from the peripherals to the HCLK domain
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_SyncToHClkSeq
  if (HRESETn == 1'b0)
    begin
      DMACSREQSync1    <= ('d0);
      DMACBREQSync1    <= ('d0);
      DMACLSREQSync1   <= ('d0);
      DMACLBREQSync1   <= ('d0);

      DMACSREQSync     <= ('d0);
      DMACBREQSync     <= ('d0);
      DMACLSREQSync    <= ('d0);
      DMACLBREQSync    <= ('d0);
    end
  else
    begin
      DMACSREQSync1    <= DMACSREQ;
      DMACBREQSync1    <= DMACBREQ;
      DMACLSREQSync1   <= DMACLSREQ;
      DMACLBREQSync1   <= DMACLBREQ;
 
      DMACSREQSync     <= DMACSREQSync1;
      DMACBREQSync     <= DMACBREQSync1;
      DMACLSREQSync    <= DMACLSREQSync1;
      DMACLBREQSync    <= DMACLBREQSync1;
    end
end // p_SyncToHClkSeq

// -----------------------------------------------------------------------------
// Muxing to select between Double synchronised and Single Synchronised DMA
// Requests
// -----------------------------------------------------------------------------
always @(DMACSync or DMACSREQSync1 or DMACBREQSync1 or DMACLSREQSync1 or
         DMACLBREQSync1 or DMACSREQSync or DMACBREQSync or DMACLSREQSync or
         DMACLBREQSync)
begin : p_ReqMuxComb
  for (i=0; i<16; i= i+1)
    begin
      if (DMACSync[i] == 1'b1)
        begin
          DMACSREQCh[i]   = DMACSREQSync1[i];
          DMACBREQCh[i]   = DMACBREQSync1[i];
          DMACLSREQCh[i]  = DMACLSREQSync1[i];
          DMACLBREQCh[i]  = DMACLBREQSync1[i];
        end
      else
        begin
          DMACSREQCh[i]   = DMACSREQSync[i];
          DMACBREQCh[i]   = DMACBREQSync[i];
          DMACLSREQCh[i]  = DMACLSREQSync[i];
          DMACLBREQCh[i]  = DMACLBREQSync[i];
        end
    end
end // p_ReqMuxComb

// -----------------------------------------------------------------------------
// Slave state machine registers the data when UUT is accessed, without putting
// out the response. The SM gives out the response when the trickbox AhbSlave
// is accessed.
// -----------------------------------------------------------------------------
always @(HSELDMAC or HSELDMACTrSlave or HWRITE or HTRANS or HADDR or HSIZE or
         HREADYIN or DmacSlaveState or AddrBuff or iHRESP or iHREADYOUT)
begin : p_SlaveSMComb
   NextSlaveState   = DmacSlaveState;
   NextHRESP        = iHRESP;
   NextAddrBuff     = AddrBuff;
   NextHREADYOUT    = iHREADYOUT;
  case (DmacSlaveState)
    `ST_DMAC_SLAVE_IDLE, `ST_DMAC_SLAVE_WRITE, `ST_DMAC_SLAVE_WRITE_TR :
      begin
        if ((HSELDMAC == 1'b1) && (HREADYIN == 1'b1))
          begin
            if (HTRANS == 1'b1)
              begin
                if ((HSIZE == `WORD) && (HWRITE == 1'b1))
                  begin
                    NextSlaveState   = `ST_DMAC_SLAVE_WRITE;
                    NextAddrBuff     = HADDR;
                  end
                else
                  NextSlaveState   = `ST_DMAC_SLAVE_IDLE;
              end
            else
              NextSlaveState   = `ST_DMAC_SLAVE_IDLE;
          end
        else if ((HSELDMACTrSlave == 1'b1) && (HREADYIN == 1'b1))
          begin
            if (HTRANS == 1'b1)
              begin
                if ((HSIZE == `WORD) && (HWRITE == 1'b1))
                  begin
                    NextSlaveState   = `ST_DMAC_SLAVE_WRITE_TR;
                    NextAddrBuff     = HADDR;
                    NextHRESP        = `OKAY_RESP;
                    NextHREADYOUT    = 1'b1;
                  end
                else
                  begin
                    NextSlaveState   = `ST_DMAC_SLAVE_ERROR;
                    NextHRESP        = `ERROR_RESP;
                    NextHREADYOUT    = 1'b0;
                  end
              end
            else
              begin
                NextSlaveState   = `ST_DMAC_SLAVE_IDLE;
                NextHRESP        = `OKAY_RESP;
                NextHREADYOUT    = 1'b1;
              end
          end
        else
          NextSlaveState   = `ST_DMAC_SLAVE_IDLE;
      end

    `ST_DMAC_SLAVE_ERROR :
       begin
         NextSlaveState   = `ST_DMAC_SLAVE_IDLE;
         NextHREADYOUT    = 1'b1;
       end

    default :
      begin
        NextSlaveState   = DmacSlaveState;
        NextHRESP        = iHRESP;
        NextAddrBuff     = AddrBuff;
        NextHREADYOUT    = iHREADYOUT;
      end
  endcase
end // p_SlaveSMComb

// -----------------------------------------------------------------------------
// Clocked Process for DMAC AHB Slave Interface State Machine
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SlaveSMSeq
  if (HRESETn == 1'b0)
    begin
      DmacSlaveState   <= `ST_DMAC_SLAVE_IDLE;
      iHRESP           <= `OKAY_RESP;
      AddrBuff         <= ('d0);
      iHREADYOUT       <= 1'b1;
      iDmacTrEn        <= 1;
    end
  else
    begin
      DmacSlaveState   <= NextSlaveState;
      iHRESP           <= NextHRESP;
      AddrBuff         <= NextAddrBuff;
      iHREADYOUT       <= NextHREADYOUT;
      iDmacTrEn        <= NextDmacTrEn;
    end
end // p_SlaveSMSeq

// -----------------------------------------------------------------------------
// Generation of Write Enables for Trickbox Registers
// -----------------------------------------------------------------------------
always @(DmacSlaveState or AddrBuff)
begin : p_WriteTrComb
   ReqConfigWrEn    = 1'b0;
   GntCnt0WrEn      = 1'b0;
   GntCnt1WrEn      = 1'b0;
   DmacTrWrEn       = 1'b0;
  if (DmacSlaveState == `ST_DMAC_SLAVE_WRITE_TR)
    begin
      case (AddrBuff[20:2])
        `ADDR_DMACTRREQCFG :
           ReqConfigWrEn    = 1'b1;

        `ADDR_DMACTRGRANTCNT0 :
           GntCnt0WrEn      = 1'b1;

        `ADDR_DMACTRGRANTCNT1 :
           GntCnt1WrEn      = 1'b1;

        `ADDR_DMACTRENB :
           DmacTrWrEn       = 1'b1;

        default :
          begin
            ReqConfigWrEn    = 1'b0;
            GntCnt0WrEn      = 1'b0;
            GntCnt1WrEn      = 1'b0;
            DmacTrWrEn       = 1'b0;
          end
      endcase
    end
end // p_WriteTrComb

// -----------------------------------------------------------------------------
// Combinitaonal logic for all Trickbox registers.
// -----------------------------------------------------------------------------
assign NextReqCfg       = (ReqConfigWrEn == 1'b1) ? HWDATA[17:0] : iReqConfig;

assign NextGntCnt0      = (GntCnt0WrEn == 1'b1) ? HWDATA : iGrantCount0;

assign NextGntCnt1      = (GntCnt1WrEn == 1'b1) ? HWDATA : iGrantCount1;

assign NextDmacTrEn     = (DmacTrWrEn == 1'b1) ? HWDATA[0] : iDmacTrEn;

// -----------------------------------------------------------------------------
// Generation of Write Enables for Channel Registers
// -----------------------------------------------------------------------------
always @(DmacSlaveState or AddrBuff or DmacTrEn)
begin : p_WriteEnComb
  DmacTCClrWrEn    = 1'b0;
  DmacErrClrWrEn   = 1'b0;

  DmacSoftBWrEn    = 1'b0;
  DmacSoftLBWrEn   = 1'b0;
  DmacSoftLSWrEn   = 1'b0;
  DmacSoftSWrEn    = 1'b0;
  DmacCfgWrEn      = 1'b0;
  DmacSyncWrEn     = 1'b0;

  DmacSrcRegWrEn0  = 1'b0;
  DmacDstRegWrEn0  = 1'b0;
  DmacLLIRegWrEn0  = 1'b0;
  DmacCntlRegWrEn0 = 1'b0;
  DmacChCnfgWrEn0  = 1'b0;

  DmacSrcRegWrEn1  = 1'b0;
  DmacDstRegWrEn1  = 1'b0;
  DmacLLIRegWrEn1  = 1'b0;
  DmacCntlRegWrEn1 = 1'b0;
  DmacChCnfgWrEn1  = 1'b0;

  DmacSrcRegWrEn2  = 1'b0;
  DmacDstRegWrEn2  = 1'b0;
  DmacLLIRegWrEn2  = 1'b0;
  DmacCntlRegWrEn2 = 1'b0;
  DmacChCnfgWrEn2  = 1'b0;

  DmacSrcRegWrEn3  = 1'b0;
  DmacDstRegWrEn3  = 1'b0;
  DmacLLIRegWrEn3  = 1'b0;
  DmacCntlRegWrEn3 = 1'b0;
  DmacChCnfgWrEn3  = 1'b0;

  DmacSrcRegWrEn4  = 1'b0;
  DmacDstRegWrEn4  = 1'b0;
  DmacLLIRegWrEn4  = 1'b0;
  DmacCntlRegWrEn4 = 1'b0;
  DmacChCnfgWrEn4  = 1'b0;

  DmacSrcRegWrEn5  = 1'b0;
  DmacDstRegWrEn5  = 1'b0;
  DmacLLIRegWrEn5  = 1'b0;
  DmacCntlRegWrEn5 = 1'b0;
  DmacChCnfgWrEn5  = 1'b0;

  DmacSrcRegWrEn6  = 1'b0;
  DmacDstRegWrEn6  = 1'b0;
  DmacLLIRegWrEn6  = 1'b0;
  DmacCntlRegWrEn6 = 1'b0;
  DmacChCnfgWrEn6  = 1'b0;

  DmacSrcRegWrEn7  = 1'b0;
  DmacDstRegWrEn7  = 1'b0;
  DmacLLIRegWrEn7  = 1'b0;
  DmacCntlRegWrEn7 = 1'b0;
  DmacChCnfgWrEn7  = 1'b0;

  DmacITCRWrEn     = 1'b0;

  if ((DmacSlaveState == `ST_DMAC_SLAVE_WRITE) && (DmacTrEn == 1))
    begin
      case (AddrBuff[11:2])
        `ADDR_DMACTCCLR :
           DmacTCClrWrEn    = 1'b1;
        `ADDR_DMACERRCLR :
           DmacErrClrWrEn   = 1'b1;
        `ADDR_DMACSOFTBREQ :
           DmacSoftBWrEn    = 1'b1;
        `ADDR_DMACSOFTSREQ :
           DmacSoftSWrEn    = 1'b1;
        `ADDR_DMACSOFTLBREQ :
           DmacSoftLBWrEn   = 1'b1;
        `ADDR_DMACSOFTLSREQ :
           DmacSoftLSWrEn   = 1'b1;
        `ADDR_DMACCONFIG :
           DmacCfgWrEn      = 1'b1;
        `ADDR_DMACSYNC :
           DmacSyncWrEn     = 1'b1;
        `ADDR_DMACC0SRCADDR :
           DmacSrcRegWrEn0  = 1'b1;
        `ADDR_DMACC0DSTADDR :
           DmacDstRegWrEn0  = 1'b1;
        `ADDR_DMACC0LLIReg :
           DmacLLIRegWrEn0  = 1'b1;
        `ADDR_DMACC0CONTROL :
           DmacCntlRegWrEn0 = 1'b1;
        `ADDR_DMACC0CONFIG :
           DmacChCnfgWrEn0  = 1'b1;
        `ADDR_DMACC1SRCADDR :
           DmacSrcRegWrEn1  = 1'b1;
        `ADDR_DMACC1DSTADDR :
           DmacDstRegWrEn1  = 1'b1;
        `ADDR_DMACC1LLIReg :
           DmacLLIRegWrEn1  = 1'b1;
        `ADDR_DMACC1CONTROL :
           DmacCntlRegWrEn1 = 1'b1;
        `ADDR_DMACC1CONFIG :
           DmacChCnfgWrEn1  = 1'b1;
        `ADDR_DMACC2SRCADDR :
           DmacSrcRegWrEn2  = 1'b1;
        `ADDR_DMACC2DSTADDR :
           DmacDstRegWrEn2  = 1'b1;
        `ADDR_DMACC2LLIReg :
           DmacLLIRegWrEn2  = 1'b1;
        `ADDR_DMACC2CONTROL :
           DmacCntlRegWrEn2 = 1'b1;
        `ADDR_DMACC2CONFIG :
           DmacChCnfgWrEn2  = 1'b1;
        `ADDR_DMACC3SRCADDR :
           DmacSrcRegWrEn3  = 1'b1;
        `ADDR_DMACC3DSTADDR :
           DmacDstRegWrEn3  = 1'b1;
        `ADDR_DMACC3LLIReg :
           DmacLLIRegWrEn3  = 1'b1;
        `ADDR_DMACC3CONTROL :
           DmacCntlRegWrEn3 = 1'b1;
        `ADDR_DMACC3CONFIG :
           DmacChCnfgWrEn3  = 1'b1;
        `ADDR_DMACC4SRCADDR :
           DmacSrcRegWrEn4  = 1'b1;
        `ADDR_DMACC4DSTADDR :
           DmacDstRegWrEn4  = 1'b1;
        `ADDR_DMACC4LLIReg :
           DmacLLIRegWrEn4  = 1'b1;
        `ADDR_DMACC4CONTROL :
           DmacCntlRegWrEn4 = 1'b1;
        `ADDR_DMACC4CONFIG :
           DmacChCnfgWrEn4  = 1'b1;
        `ADDR_DMACC5SRCADDR :
           DmacSrcRegWrEn5  = 1'b1;
        `ADDR_DMACC5DSTADDR :
           DmacDstRegWrEn5  = 1'b1;
        `ADDR_DMACC5LLIReg :
           DmacLLIRegWrEn5  = 1'b1;
        `ADDR_DMACC5CONTROL :
           DmacCntlRegWrEn5 = 1'b1;
        `ADDR_DMACC5CONFIG :
           DmacChCnfgWrEn5  = 1'b1;
        `ADDR_DMACC6SRCADDR :
           DmacSrcRegWrEn6  = 1'b1;
        `ADDR_DMACC6DSTADDR :
           DmacDstRegWrEn6  = 1'b1;
        `ADDR_DMACC6LLIReg :
           DmacLLIRegWrEn6  = 1'b1;
        `ADDR_DMACC6CONTROL :
           DmacCntlRegWrEn6 = 1'b1;
        `ADDR_DMACC6CONFIG :
           DmacChCnfgWrEn6  = 1'b1;
        `ADDR_DMACC7SRCADDR :
           DmacSrcRegWrEn7  = 1'b1;
        `ADDR_DMACC7DSTADDR :
           DmacDstRegWrEn7  = 1'b1;
        `ADDR_DMACC7LLIReg :
           DmacLLIRegWrEn7  = 1'b1;
        `ADDR_DMACC7CONTROL :
           DmacCntlRegWrEn7 = 1'b1;
        `ADDR_DMACC7CONFIG :
           DmacChCnfgWrEn7  = 1'b1;
        `ADDR_DMACTCR :
           DmacITCRWrEn     = 1'b1;
        default :
          begin
            DmacTCClrWrEn    = 1'b0;
            DmacErrClrWrEn   = 1'b0;
         
            DmacSoftBWrEn    = 1'b0;
            DmacSoftLBWrEn   = 1'b0;
            DmacSoftLSWrEn   = 1'b0;
            DmacSoftSWrEn    = 1'b0;
            DmacCfgWrEn      = 1'b0;
            DmacSyncWrEn     = 1'b0;
         
            DmacSrcRegWrEn0  = 1'b0;
            DmacDstRegWrEn0  = 1'b0;
            DmacLLIRegWrEn0  = 1'b0;
            DmacCntlRegWrEn0 = 1'b0;
            DmacChCnfgWrEn0  = 1'b0;
         
            DmacSrcRegWrEn1  = 1'b0;
            DmacDstRegWrEn1  = 1'b0;
            DmacLLIRegWrEn1  = 1'b0;
            DmacCntlRegWrEn1 = 1'b0;
            DmacChCnfgWrEn1  = 1'b0;
         
            DmacSrcRegWrEn2  = 1'b0;
            DmacDstRegWrEn2  = 1'b0;
            DmacLLIRegWrEn2  = 1'b0;
            DmacCntlRegWrEn2 = 1'b0;
            DmacChCnfgWrEn2  = 1'b0;
         
            DmacSrcRegWrEn3  = 1'b0;
            DmacDstRegWrEn3  = 1'b0;
            DmacLLIRegWrEn3  = 1'b0;
            DmacCntlRegWrEn3 = 1'b0;
            DmacChCnfgWrEn3  = 1'b0;
         
            DmacSrcRegWrEn4  = 1'b0;
            DmacDstRegWrEn4  = 1'b0;
            DmacLLIRegWrEn4  = 1'b0;
            DmacCntlRegWrEn4 = 1'b0;
            DmacChCnfgWrEn4  = 1'b0;
         
            DmacSrcRegWrEn5  = 1'b0;
            DmacDstRegWrEn5  = 1'b0;
            DmacLLIRegWrEn5  = 1'b0;
            DmacCntlRegWrEn5 = 1'b0;
            DmacChCnfgWrEn5  = 1'b0;
         
            DmacSrcRegWrEn6  = 1'b0;
            DmacDstRegWrEn6  = 1'b0;
            DmacLLIRegWrEn6  = 1'b0;
            DmacCntlRegWrEn6 = 1'b0;
            DmacChCnfgWrEn6  = 1'b0;
         
            DmacSrcRegWrEn7  = 1'b0;
            DmacDstRegWrEn7  = 1'b0;
            DmacLLIRegWrEn7  = 1'b0;
            DmacCntlRegWrEn7 = 1'b0;
            DmacChCnfgWrEn7  = 1'b0;
         
            DmacITCRWrEn     = 1'b0;
          end
      endcase
    end
end // p_WriteEnComb

// -----------------------------------------------------------------------------
// Assign the DMACTCR register bits to the corresponding signals
// -----------------------------------------------------------------------------
assign ITEN             = DMACTCR[0];

// -----------------------------------------------------------------------------
// Assign the DMACConfig register bits to the corresponding signals
// -----------------------------------------------------------------------------
assign iDMACEn          = DMACConfig[0] & ( ~ITEN);
assign MasterEndian1    = DMACConfig[1];
assign MasterEndian2    = DMACConfig[2];

// -----------------------------------------------------------------------------
// Combinational logic for all writeable registers.
// -----------------------------------------------------------------------------
assign NextDMACConfig   = (DmacCfgWrEn == 1'b1) ? HWDATA[3:0] : DMACConfig;

assign NextDMACSync     = (DmacSyncWrEn == 1'b1) ? HWDATA[15:0] : DMACSync;

assign NextDMACTCR      = (DmacITCRWrEn == 1'b1) ? HWDATA[1:0] : DMACTCR;

assign iClrIntErr       = (DmacErrClrWrEn == 1'b1) ? HWDATA[7:0] : ('d0);

assign iClrIntTC        = (DmacTCClrWrEn == 1'b1) ? HWDATA[7:0] : ('d0);

// -----------------------------------------------------------------------------
// Write logic for Soft Request registers
// -----------------------------------------------------------------------------
always @(DmacClr or DMACSoftBReq or HWDATA or DmacSoftBWrEn or iDMACEn or
         DMACSoftLBReq or DMACSoftSReq or DMACSoftLSReq or DmacSoftSWrEn or
         DmacSoftLBWrEn or DmacSoftLSWrEn or SoftClr)
begin : p_SoftReqWrComb
   NextSoftBReq     = DMACSoftBReq;
   NextSoftLBReq    = DMACSoftLBReq;
   NextSoftSReq     = DMACSoftSReq;
   NextSoftLSReq    = DMACSoftLSReq;
  for (i=0; i<16; i=i + 1)
    begin
      if ((DmacClr[i] == 1'b1) || (iDMACEn == 1'b0) || (SoftClr[i] == 1'b1))
        begin
          NextSoftBReq[i]  = 1'b0;
          NextSoftLBReq[i] = 1'b0;
          NextSoftSReq[i]  = 1'b0;
          NextSoftLSReq[i] = 1'b0;
        end
      else if (DmacSoftBWrEn == 1'b1)
        if (HWDATA[i] == 1'b1)
          NextSoftBReq[i]  = 1'b1;
      else if (DmacSoftSWrEn == 1'b1)
        if (HWDATA[i] == 1'b1)
          NextSoftSReq[i]  = 1'b1;
      else if (DmacSoftLBWrEn == 1'b1)
        if (HWDATA[i] == 1'b1)
          NextSoftLBReq[i] = 1'b1;
      else if (DmacSoftLSWrEn == 1'b1)
        if (HWDATA[i] == 1'b1)
          NextSoftLSReq[i] = 1'b1;
    end

end // p_SoftReqWrComb

// -----------------------------------------------------------------------------
// Sequential process for writeable registers in this module.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SoftReqWrSeq
  if (HRESETn == 1'b0)
    begin
      DMACSoftBReq     <= ('d0);
      DMACSoftLBReq    <= ('d0);
      DMACSoftSReq     <= ('d0);
      DMACSoftLSReq    <= ('d0);
      DMACConfig       <= ('d0);
      DMACSync         <= ('d0);
      DMACTCR          <= ('d0);
      iReqConfig       <= ('d0);
      iGrantCount0     <= ('d0);
      iGrantCount1     <= ('d0);
    end
  else
    begin
      DMACSoftBReq     <= NextSoftBReq;
      DMACSoftLBReq    <= NextSoftLBReq;
      DMACSoftSReq     <= NextSoftSReq;
      DMACSoftLSReq    <= NextSoftLSReq;
      DMACConfig       <= NextDMACConfig;
      DMACSync         <= NextDMACSync;
      DMACTCR          <= NextDMACTCR;
      iReqConfig       <= NextReqCfg;
      iGrantCount0     <= NextGntCnt0;
      iGrantCount1     <= NextGntCnt1;
    end
end // p_SoftReqWrSeq

endmodule
// --================================== End ==================================--
