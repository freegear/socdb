// --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
// ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : FileReader.v,v
//  File Revision       : 1.8
//  
//  Release Information : ADK_REL1v1
//  
// ----------------------------------------------------------------------------
//  Purpose             : This entity ties together the sub blocks that
//                        form the File Reader Bus Master, namely a AHB-Lite
//                        File Reader Core and AHB-Lite to AHB wrapper.
// --========================================================================--

`timescale 1ns/1ps

module FileReader 
(  
   HCLK,
   HRESETn,
   HGRANT,
   HREADY,
   HRESP,
   HRDATA,
   HBUSREQ,
   HTRANS,
   HBURST,
   HPROT,
   HSIZE,
   HWRITE,
   HLOCK,
   HADDR,
   HWDATA 
);

  parameter     InputFileName = "filestim.frd";  // Default stimulus filename
  
  // Common AHB signals
  input         HCLK;    //  System clock
  input         HRESETn; //  System reset

  // AHB ports
  input         HGRANT;  //  Granted the AHB bus
  input         HREADY;  //  Slave ready signal
  input   [1:0] HRESP;   //  Slave response bus
  input  [31:0] HRDATA;  //  Data from slave to master
  
  output        HBUSREQ; //  AHB request signal
  output  [1:0] HTRANS;  //  Transfer type
  output  [2:0] HBURST;  //  Burst type
  output  [3:0] HPROT;   //  Transfer protection
  output  [2:0] HSIZE;   //  Transfer size
  output        HWRITE;  //  Transfer direction
  output        HLOCK;   //  Transfer is a locked transfer
  output [31:0] HADDR;   //  Transfer address
  output [31:0] HWDATA;  //  Data from master to slave
  
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

  // Input/Output Signals
  wire          HCLK;     
  wire          HRESETn;  
  wire          HGRANT;   
  wire          HREADY;  
  wire    [1:0] HRESP;    
  wire   [31:0] HRDATA;  
  wire          HBUSREQ; 
  wire    [1:0] HTRANS;   
  wire    [2:0] HBURST;   
  wire    [3:0] HPROT;    
  wire    [2:0] HSIZE;    
  wire          HWRITE;   
  wire          HLOCK;    
  wire   [31:0] HADDR;    
  wire   [31:0] HWDATA;  
 
  // AHB-lite Bus Signals
  wire   [31:0] MADDR;
  wire    [1:0] MTRANS;
  wire          MWRITE;
  wire    [2:0] MSIZE;
  wire    [2:0] MBURST;
  wire    [3:0] MPROT;
  wire          MMASTLOCK;
  wire   [31:0] MWDATA;
  wire   [31:0] MRDATA;
  wire          MREADY;
  wire          MERROR;

  // The SCAN pins on the Lite2AHB wrapper are used during scan insertion,
  //  and are connected to these internal signals.
  wire          TieOffLow;
  wire          iSCANOUTHCLK;
  
  // structural

  // Instance of AHB-Lite File Reader connected to internal AHB-Lite system,
  // signal prefix M
  
  FileReadCore  #(InputFileName) U1        // Overriding InputFileName parameter
    (
     // Common AHB signals
     .HCLK (HCLK),
     .HRESETn   (HRESETn),
     // AHB-Lite ports
     .MREADY    (MREADY),
     .MERROR    (MERROR),
     .MRDATA    (MRDATA),
     
     .MTRANS    (MTRANS),
     .MBURST    (MBURST),
     .MPROT     (MPROT),
     .MSIZE     (MSIZE),
     .MWRITE    (MWRITE),
     .MMASTLOCK (MMASTLOCK),
     .MADDR     (MADDR),
     .MWDATA    (MWDATA)
    );

  
  // Instance of AHB Wrapper to convert AHB-Lite bus into fully functional AHB
  // interface, for a multi-master AHB system, signal prefix H
  
  Lite2AHB  U2 
    (
     // Common AHB signals
     .HCLK      (HCLK),
     .HRESETn   (HRESETn),

     // AHB-Lite ports
     .HRDATA    (HRDATA),
     .HREADY    (HREADY),
     .HRESP     (HRESP),
     .HGRANT    (HGRANT),

     .HADDR     (HADDR),
     .HTRANS    (HTRANS),
     .HWRITE    (HWRITE),
     .HSIZE     (HSIZE),
     .HBURST    (HBURST),
     .HPROT     (HPROT),
     .HWDATA    (HWDATA),
     .HBUSREQ   (HBUSREQ),
     .HLOCK     (HLOCK),

     // AHB ports
     .MADDR     (MADDR),
     .MTRANS    (MTRANS),
     .MWRITE    (MWRITE),
     .MSIZE     (MSIZE),
     .MBURST    (MBURST),
     .MPROT     (MPROT),
     .MMASTLOCK (MMASTLOCK),
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

// --================================= End ==================================--

