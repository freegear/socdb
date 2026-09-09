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
// File Name              : DmacTrAhbMaster.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           DMA controller AHB Master Interface module. This is module
//           instantiating the AHB-Lite master for the DMA controller and the
//           Wrapper around it along with the internal arbiter.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacTrAhbMaster (
// Inputs
                        HCLK,
                        HRESETn,
                        HGRANTDMACM,
                        HREADYINM,
                        HRESPM,
                        ChHLOCK,
                        ChWRITE,
                        ReqForAhbBus,
                        ChHPROT,
                        ChHSIZE,
                        ChAddr,
                        ChAddrIncr,
                        ChDisable,
                        ChPriority,
                        ChBeatCount,
                        HWDATA,
// Outputs
                        HBUSREQDMACM,
                        HLOCKDMACM,
                        HPROTM,
                        HBURSTM,
                        HTRANSM,
                        HADDRM,
                        HSIZEM,
                        HWRITEM,
                        HWDATAM,
                        DataValid,
                        MREADY,
                        DisAckMas,
                        StopArb,
                        ErrorMas
                        );

// Inputs
input         HCLK;         // AHB clock
input         HRESETn;      // AHB Reset
input         HGRANTDMACM;  // AHB bus grant for master
input         HREADYINM;    // HREADYIN response from the Slave
input   [1:0] HRESPM;       // HRESP response from the AHB Slave
input         ChHLOCK;      // HLOCK Signal for AHB Bus
input         ChWRITE;      // Write signal for AHB Bus
input         ReqForAhbBus; // Request for AHB Bus from Arbiter
input   [3:0] ChHPROT;      // HPROT information for AHB Bus
input   [2:0] ChHSIZE;      // HSIZE information for AHB Bus
input  [31:0] ChAddr;       // Channel Address for AHB Master
input         ChAddrIncr;   // Address incr info for AHB Mas
input         ChDisable;    // Channel Disable info for AHB Mas
input         ChPriority;   // Channel Priority info from router
input   [4:0] ChBeatCount;  // Channel BeatCount info for Master
input  [31:0] HWDATA;       // Write Data from channel

// Outputs
output        HBUSREQDMACM; // HBUSREQ signal to the protocol checker block
output        HLOCKDMACM;   // Lock Information for the protocol checker block
output  [3:0] HPROTM;       // Protection Info on AHB
output  [2:0] HBURSTM;      // Burst Information
output  [1:0] HTRANSM;      // Type of transfer on AHB
output [31:0] HADDRM;       // Address for Slave
output  [2:0] HSIZEM;       // Width of the AHB data transfer
output        HWRITEM;      // Transfer direction info for Slave
output [31:0] HWDATAM;      // Write Data to AHB Slave
output        DataValid;    // DataValid info for Channel
output        MREADY;       // MREADY for Channel
output        DisAckMas;    // Disable Acknowledge for Channel
output        StopArb;      // Stop Arbitration indication
output        ErrorMas;     // Error Information for Channel




// Inputs
  wire        HCLK;         // AHB clock
  wire        HRESETn;      // AHB Reset
  wire        HGRANTDMACM;  // AHB bus grant for master
  wire        HREADYINM;    // HREADYIN response from the Slave
  wire  [1:0] HRESPM;       // HRESP response from the AHB Slave
  wire        ChHLOCK;      // HLOCK Signal for AHB Bus
  wire        ChWRITE;      // Write signal for AHB Bus
  wire        ReqForAhbBus; // Request for AHB Bus from Arbiter
  wire  [3:0] ChHPROT;      // HPROT information for AHB Bus
  wire  [2:0] ChHSIZE;      // HSIZE information for AHB Bus
  wire [31:0] ChAddr;       // Channel Address for AHB Master
  wire        ChAddrIncr;   // Address incr info for AHB Mas
  wire        ChDisable;    // Channel Disable info for AHB Mas
  wire        ChPriority;   // Channel Priority info from router
  wire  [4:0] ChBeatCount;  // Channel BeatCount info for Master
  wire [31:0] HWDATA;       // Write Data from channel

// Outputs
  wire        HBUSREQDMACM; // HBUSREQ signal to the protocol checker block
  wire        HLOCKDMACM;   // Lock Information for the protocol checker block
  wire  [3:0] HPROTM;       // Protection Info on AHB
  wire  [2:0] HBURSTM;      // Burst Information
  wire  [1:0] HTRANSM;      // Type of transfer on AHB
  wire [31:0] HADDRM;       // Address for Slave
  wire  [2:0] HSIZEM;       // Width of the AHB data transfer
  wire        HWRITEM;      // Transfer direction info for Slave
  wire [31:0] HWDATAM;      // Write Data to AHB Slave
  wire        DataValid;    // DataValid info for Channel
  wire        MREADY;       // MREADY for Channel
  wire        DisAckMas;    // Disable Acknowledge for Channel
  wire        StopArb;      // Stop Arbitration indication
  wire        ErrorMas;     // Error Information for Channel


// -----------------------------------------------------------------------------
//
//                               DmacTrAhbMaster
//                               ===============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//   This structural block integrates the AHB Lite master interface for the
// DMAC and the wrapper around it to make it full AHB Master interface.
// This block instantiates the following functional sub-blocks.
//   - DmacTrAhbLite
//   - DmacTrMasWrap
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire [31:0] MADDR;
wire  [1:0] MTRANS;
wire        MWRITE;
wire  [2:0] MSIZE;
wire  [2:0] MBURST;
wire  [3:0] MPROT;
wire        MLOCK;
wire        iMREADY;
wire        MERROR;
wire [31:0] HRDATAIN = 'b0;
wire [31:0] MRDATA;

// -----------------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


assign MREADY           = iMREADY;
// -----------------------------------------------------------------------------
// Instantiation of DmacTrMasWrap
// -----------------------------------------------------------------------------
DmacTrMasWrap uDmacTrMasWrap (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HRDATA          (HRDATAIN),
        .HREADY          (HREADYINM),
        .HRESP           (HRESPM),
        .HGRANT          (HGRANTDMACM),
        .HADDR           (HADDRM),
        .HTRANS          (HTRANSM),
        .HWRITE          (HWRITEM),
        .HSIZE           (HSIZEM),
        .HBURST          (HBURSTM),
        .HPROT           (HPROTM),
        .HWDATA          (HWDATAM),
        .HBUSREQ         (HBUSREQDMACM),
        .HLOCK           (HLOCKDMACM),
        .MADDR           (MADDR),
        .MTRANS          (MTRANS),
        .MWRITE          (MWRITE),
        .MSIZE           (MSIZE),
        .MBURST          (MBURST),
        .MPROT           (MPROT),
        .MMASTLOCK       (MLOCK),
        .MWDATA          (HWDATA),
        .MRDATA          (MRDATA),
        .MREADY          (iMREADY),
        .MERROR          (MERROR)
           );

// -----------------------------------------------------------------------------
// Instantiation of DmacTrAhbLite
// -----------------------------------------------------------------------------
DmacTrAhbLite uDmacTrAhbLite (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .MREADY          (iMREADY),
        .MERROR          (MERROR),
        .ChHLOCK         (ChHLOCK),
        .ChWRITE         (ChWRITE),
        .ReqForAhbBus    (ReqForAhbBus),
        .ChHPROT         (ChHPROT),
        .ChHSIZE         (ChHSIZE),
        .ChAddr          (ChAddr),
        .ChAddrIncr      (ChAddrIncr),
        .ChDisable       (ChDisable),
        .ChPriority      (ChPriority),
        .ChBeatCount     (ChBeatCount),
        .MLOCK           (MLOCK),
        .MPROT           (MPROT),
        .MBURST          (MBURST),
        .MTRANS          (MTRANS),
        .MADDR           (MADDR),
        .MSIZE           (MSIZE),
        .MWRITE          (MWRITE),
        .DataValid       (DataValid),
        .DisAckMas       (DisAckMas),
        .StopArb         (StopArb),
        .ErrorMas        (ErrorMas)
           );

endmodule
// --================================== End ==================================--
