//===========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//
//-----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           : EgMaster.v,v
//  File Revision       : 1.11
//
//  Release Information : ADK_REL1v1
//
//-----------------------------------------------------------------------------
//  Purpose             : This entity ties together the sub blocks that
//                        form the example bus master, namely an
//                        example AHB-Lite core and AHB-Lite to AHB wrapper.
//===========================================================================--

//-----------------------------------------------------------------------------
// The example bus master is made up of the following blocks:
//
// EgMasterCore - An AHB-Lite bus master capable of initiating a fixed set
//                of read and write burst transfers.
// Lite2AHB     - A wrapper to allow the AHB-Lite master to interface to AHB
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module EgMaster
  (
   HCLK,
   HRESETn,

   HRDATA,
   HREADY,
   HRESP,
   HGRANT,

   HADDR,
   HTRANS,
   HWRITE,
   HSIZE,
   HBURST,
   HPROT,
   HWDATA,
   HBUSREQ,
   HLOCK,

   SCANENABLE,
   SCANINHCLK,
   SCANOUTHCLK
   );

//------------------------------------------------------------------------------
// Default settings for the Example master operation
//------------------------------------------------------------------------------
  // Block enable
  parameter EBMenable    = 1;
  
  // Read base address
  parameter EBMreadAddr  = 8'hD0;
  
  // Write base address
  parameter EBMwriteAddr = 8'hC4;
  
  // Delay between transactions
  parameter EBMinitCount = 10'h004;

//------------------------------------------------------
// AHB signals
//------------------------------------------------------
  // Global signals
  input         HCLK;
  input         HRESETn;

  // Signals from AHB
  input [31:0]  HRDATA;
  input         HREADY;
  input [1:0]   HRESP;
  input         HGRANT;

  // Signals to AHB
  output [31:0] HADDR;
  output [1:0]  HTRANS;
  output        HWRITE;
  output [2:0]  HSIZE;
  output [2:0]  HBURST;
  output [3:0]  HPROT;
  output [31:0] HWDATA;
  output        HBUSREQ;
  output        HLOCK;

  // Scan test dummy signals; not connected until scan insertion    
  input         SCANENABLE;  // Scan Test Mode Enbl
  input         SCANINHCLK;  // Scan Chain Input
  output        SCANOUTHCLK; // Scan Chain Output
  
//----------------------------------------------------------------------
// Signal declarations
//----------------------------------------------------------------------

// Input/Output Signals
  // AHB signals
  wire          HCLK;
  wire          HRESETn;
  wire [31:0]   HRDATA;
  wire          HREADY;
  wire [1:0]    HRESP;
  wire          HGRANT;
  wire [31:0]   HADDR;
  wire [1:0]    HTRANS;
  wire          HWRITE;
  wire [2:0]    HSIZE;
  wire [2:0]    HBURST;
  wire [3:0]    HPROT;
  wire [31:0]   HWDATA;
  wire          HBUSREQ;
  wire          HLOCK;
  wire          SCANENABLE;
  wire          SCANINHCLK;
  wire          SCANOUTHCLK;

// Internal Signals
  // AHB-Lite signals
  wire [31:0]   MRDATA;
  wire          MREADY;
  wire [31:0]   MADDR;
  wire [1:0]    MTRANS;
  wire          MWRITE;
  wire [2:0]    MSIZE;
  wire [2:0]    MBURST;
  wire          MMASTLOCK;
  wire [3:0]    MPROT;
  wire [31:0]   MWDATA;
  wire          MERROR;

  // The SCAN pins on the Lite2AHB wrapper are used during scan insertion,
  //  and are connected to these internal signals.
  wire          TieOffLow;
  wire          iSCANOUTHCLK;  
  
//----------------------------------------------------------------------
// Beginning of main code
//----------------------------------------------------------------------

  // Instantiation of example AHB-Lite Core
  EgMasterCore 
    // These map to the top level parameters
    #(EBMenable, EBMreadAddr, EBMwriteAddr, EBMinitCount) 
  uEgMasterCore
    (
      .HCLK        (HCLK),
      .HRESETn     (HRESETn),

      .MADDR       (MADDR),
      .MBURST      (MBURST),
      .MTRANS      (MTRANS),
      .MPROT       (MPROT),
      .MSIZE       (MSIZE),
      .MWRITE      (MWRITE),
      .MWDATA      (MWDATA),
      .MRDATA      (MRDATA),
      .MMASTLOCK   (MMASTLOCK),
      .MREADY      (MREADY),
      .MERROR      (MERROR)
      );

  // Instantiation of AHB-Lite to AHB Wrapper
  Lite2AHB uLite2AHB
    ( // Common AHB signals
      .HCLK    (HCLK),
      .HRESETn (HRESETn),

      // AHB signals
      .HRDATA  (HRDATA),
      .HREADY  (HREADY),
      .HRESP   (HRESP),
      .HGRANT  (HGRANT),

      .HADDR   (HADDR),
      .HTRANS  (HTRANS),
      .HWRITE  (HWRITE),
      .HSIZE   (HSIZE),
      .HBURST  (HBURST),
      .HPROT   (HPROT),
      .HWDATA  (HWDATA),
      .HBUSREQ (HBUSREQ),
      .HLOCK   (HLOCK),

      // AHB-Lite signals
      .MADDR     (MADDR),
      .MBURST    (MBURST),
      .MTRANS    (MTRANS),
      .MPROT     (MPROT),
      .MMASTLOCK (MMASTLOCK),
      .MSIZE     (MSIZE),
      .MWRITE    (MWRITE),
      .MWDATA    (MWDATA),
      .MRDATA    (MRDATA),
      .MREADY    (MREADY),
      .MERROR    (MERROR),

      // Scan test dummy signals; not connected until scan insertion
      .SCANENABLE  (TieOffLow),    // Scan Test Mode Enbl
      .SCANINHCLK  (TieOffLow),    // Scan Chain Input
      .SCANOUTHCLK (iSCANOUTHCLK)  // Scan Chain Output      
      );

  assign TieOffLow = 1'b0;  // Drive the tie-off signal

endmodule

//================================= End ==============================--
