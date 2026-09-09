//============================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//
//------------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           : Ahb2Ahb.v,v
//  File Revision       : 1.8
//
//  Release Information : ADK_REL1v1
//
//------------------------------------------------------------------------------
//  Purpose             : This is the AHB-AHB Unidirectional Bridge (Top level).
//============================================================================--

`timescale 1ns/1ps

module Ahb2Ahb
  (
   HCLK,
   HRESETn,

   HSELS,
   HADDRS,
   HTRANSS,
   HWRITES,
   HSIZES,
   HBURSTS,
   HPROTS,
   HMASTLOCKS,
   HWDATAS,
   HREADYS,
   HRDATAS,
   HRESPS,
   HREADYOUTS,

   HRDATAM,
   HREADYM,
   HRESPM,
   HGRANTM,
   HADDRM,
   HTRANSM,
   HWRITEM,
   HSIZEM,
   HBURSTM,
   HPROTM,
   HWDATAM,
   HBUSREQM,
   HLOCKM,

   // Scan test dummy signals; not connected until scan insertion 
   SCANENABLE,   // Scan Test Mode Enbl
   SCANINHCLK,   // Scan Chain Input   
   SCANOUTHCLK   // Scan Chain Output     
   );
  
  // Global signals to all sub-modules of the component
  input         HCLK;
  input         HRESETn;

  // Slave Interface signals on AHB1
  input         HSELS;
  input  [31:0] HADDRS;
  input  [1:0]  HTRANSS;
  input         HWRITES;
  input  [2:0]  HSIZES;
  input  [2:0]  HBURSTS;
  input  [3:0]  HPROTS;
  input         HMASTLOCKS;
  input  [31:0] HWDATAS;
  input         HREADYS;

  output [31:0] HRDATAS;
  output [1:0]  HRESPS;
  output        HREADYOUTS;

  // Master Interface signals on AHB2
  input  [31:0] HRDATAM;
  input         HREADYM;
  input  [1:0]  HRESPM;
  input         HGRANTM;

  input         SCANENABLE;
  input         SCANINHCLK;

  output [31:0] HADDRM;
  output [1:0]  HTRANSM;
  output        HWRITEM;
  output [2:0]  HSIZEM;
  output [2:0]  HBURSTM;
  output [3:0]  HPROTM;
  output [31:0] HWDATAM;
  output        HBUSREQM;
  output        HLOCKM;

  output        SCANOUTHCLK;


//----------------------------------------------------------------------
// Signal declarations
//----------------------------------------------------------------------

// Input/Output Signals
  // Global signals
  wire          HCLK;
  wire          HRESETn;

  // Signals from AHB (Slave Interface)
  wire          HSELS;
  wire [31:0]   HADDRS;
  wire [1:0]    HTRANSS;
  wire          HWRITES;
  wire [2:0]    HSIZES;
  wire [2:0]    HBURSTS;
  wire [3:0]    HPROTS;
  wire          HMASTLOCKS;
  wire [31:0]   HWDATAS;
  wire          HREADYS;

  // Signals to AHB (Slave Interface)
  wire [31:0]   HRDATAS;
  wire [1:0]    HRESPS;
  wire          HREADYOUTS;

  // Signals from AHB (Master Interface)
  wire [31:0]   HRDATAM;
  wire          HREADYM;
  wire [1:0]    HRESPM;
  wire          HGRANTM;

  // Signals to AHB (Master Interface)
  wire [31:0]   HADDRM;
  wire [1:0]    HTRANSM;
  wire          HWRITEM;
  wire [2:0]    HSIZEM;
  wire [2:0]    HBURSTM;
  wire [3:0]    HPROTM;
  wire [31:0]   HWDATAM;
  wire          HBUSREQM;
  wire          HLOCKM;

// Internal Signals
  // Internal AHB-Lite Bridge signals.
  wire [2:0]    MBURST;
  wire [1:0]    MTRANS;
  wire [3:0]    MPROT;
  wire [2:0]    MSIZE;
  wire          MWRITE;
  wire          MMASTLOCK;
  wire [31:0]   MADDR;
  wire [31:0]   MWDATA;
  wire [31:0]   MRDATA;
  wire          MREADY;
  wire          MERROR;

  // The SCAN pins on the Lite2AHB wrapper are used during scan insertion,
  //  and are connected to these internal signals.
  wire          TieOffLow;
  wire          iSCANOUTHCLK;  

//----------------------------------------------------------------------
// Beginning of main code
//----------------------------------------------------------------------

  // Instantiation of the Bridge Core
  Ahb2Lite  BrCore
    ( // Global signals.
      .HCLK      (HCLK),
      .HRESETn   (HRESETn),

      // AHB signals connected to the Bridge Slave Interface
      .HSEL      (HSELS),
      .HADDR     (HADDRS),
      .HTRANS    (HTRANSS),
      .HWRITE    (HWRITES),
      .HSIZE     (HSIZES),
      .HBURST    (HBURSTS),
      .HPROT     (HPROTS),
      .HWDATA    (HWDATAS),
      .HRDATA    (HRDATAS),
      .HRESP     (HRESPS),
      .HREADYOUT (HREADYOUTS),
      .HREADY    (HREADYS),
      .HMASTLOCK (HMASTLOCKS),

      // AHB-Lite signals between the Bridge Core and Wrapper
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
      .MERROR    (MERROR)
      );


  // Instantiation of the AHB-Lite to Full AHB Wrapper
  Lite2AHB  AHBWrapper
    ( // Global signals
      .HCLK      (HCLK),
      .HRESETn   (HRESETn),

      // AHB2 input signals
      .HRDATA    (HRDATAM),
      .HREADY    (HREADYM),
      .HRESP     (HRESPM),
      .HGRANT    (HGRANTM),

      // AHB-Lite master signals from the Bridge Core to the Wrapper
      .MADDR     (MADDR),
      .MTRANS    (MTRANS),
      .MWRITE    (MWRITE),
      .MSIZE     (MSIZE),
      .MBURST    (MBURST),
      .MPROT     (MPROT),
      .MMASTLOCK (MMASTLOCK),
      .MWDATA    (MWDATA),

      // AHB2 output signals
      .HADDR     (HADDRM),
      .HTRANS    (HTRANSM),
      .HWRITE    (HWRITEM),
      .HSIZE     (HSIZEM),
      .HBURST    (HBURSTM),
      .HPROT     (HPROTM),
      .HWDATA    (HWDATAM),
      .HBUSREQ   (HBUSREQM),
      .HLOCK     (HLOCKM),

      // AHB-Lite slave signals from the Wrapper to the Bridge Core
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

