//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : Inport1.v,v
//  File Revision       : 1.9
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Structural sub-block architecture of Example Amba 
//                        SYstem Multi-layer (EASY-ML), connected to BusMatrix
//                        Inport 1. The module contains the following AHB 
//                        devices:
//                       
//                          - File Reader Bus Master (Local master 3)
//                          - Example Bus Master (Local master 1)
//                          - Local Arbiter3
//                          - Local Master-to-Slave multiplexor
//                       
//                        The BusMatrix is the only slave to this module,
//                        therefore the HSELmtrx signal is always driven high.
//                       
//                        The Pause signal is used to remove the bus grant
//                        from the two masters by raising a request on HBUSREQ0
//                        which is assigned to the Dummy Master.
//  --========================================================================--

`timescale 1ns/1ps

module Inport1 (HCLK, HRESETn, nRESETfrbm, HRDATAmtrx, HREADYmtrx, HRESPmtrx,
                HADDR, HBURST, HMASTLOCK, HPROT, HSIZE, HTRANS, HWDATA, HWRITE,
                HSELmtrx, HREADYOUT, Pause, SCANENABLE, SCANINHCLK, 
                SCANOUTHCLK);

  // Stimulus file for the File Reader Bus Master (FRBM)
  parameter StimFileFRBM = "fileStim.frd"; 
  // Enable for Example Bus Master (EgMaster)
  parameter EnableEBM = 1; 
  // EgMaster reads from the Retry Slave (0xD0000000)
  parameter ReadAddrEBM = 'h0D0; 
  // EgMaster writes to the Tube via SMI (0x38000000)
  parameter WriteAddrEBM = 'h038; 
  // Number of cycles between transactions by EgMaster
  parameter InitCountEBM = 10;

  // Common AHB signals
  input         HCLK;
  input         HRESETn;

  // Reset for the FRBM
  input         nRESETfrbm;

  // Matrix AHB connections
  output [31:0] HADDR;
  output [2:0]  HBURST;
  output        HMASTLOCK;
  output [3:0]  HPROT;
  output [2:0]  HSIZE;
  output [1:0]  HTRANS;
  output [31:0] HWDATA;
  output        HWRITE;
  output        HSELmtrx;
  output        HREADYOUT;

  input [31:0]  HRDATAmtrx;
  input         HREADYmtrx;
  input [1:0]   HRESPmtrx;

  // Pause control signal
  input         Pause;

  // Scan test dummy signals; not connected until scan insertion
  input         SCANENABLE;  // Scan Test Mode Enbl
  input         SCANINHCLK;  // Scan Chain Input
  output        SCANOUTHCLK; // Scan Chain Output

  // Port wires
  wire          HCLK;
  wire          HRESETn;

  wire          nRESETfrbm;

  wire [31:0]   HADDR;
  wire [2:0]    HBURST;
  wire          HMASTLOCK;
  wire [3:0]    HPROT;
  wire [2:0]    HSIZE;
  wire [1:0]    HTRANS;
  wire [31:0]   HWDATA;
  wire          HWRITE;
  wire          HSELmtrx;
  wire          HREADYOUT;

  wire [31:0]   HRDATAmtrx;
  wire          HREADYmtrx;
  wire [1:0]    HRESPmtrx;

  wire          Pause;

  wire          SCANENABLE;
  wire          SCANINHCLK;
  wire          SCANOUTHCLK;

//------------------------------------------------------------------------------
// Signal declarations: AHB
//------------------------------------------------------------------------------

// Local Master specific signals
  wire          HBUSREQM0;
  wire          HGRANTM0;
  wire          HLOCKM0;

  wire [31:0]   HADDRM1;
  wire [2:0]    HBURSTM1;
  wire          HBUSREQM1;
  wire          HGRANTM1;
  wire          HLOCKM1;
  wire [3:0]    HPROTM1;
  wire [2:0]    HSIZEM1;
  wire [1:0]    HTRANSM1;
  wire [31:0]   HWDATAM1;
  wire          HWRITEM1;
  
  wire [31:0]   HADDRM2;
  wire [2:0]    HBURSTM2;
  wire          HBUSREQM2;
  wire          HGRANTM2;
  wire          HLOCKM2;
  wire [3:0]    HPROTM2;
  wire [2:0]    HSIZEM2;
  wire [1:0]    HTRANSM2;
  wire [31:0]   HWDATAM2;
  wire          HWRITEM2;
  
  wire [31:0]   HADDRM3;
  wire [2:0]    HBURSTM3;
  wire          HBUSREQM3;
  wire          HGRANTM3;
  wire          HLOCKM3;
  wire [3:0]    HPROTM3;
  wire [2:0]    HSIZEM3;
  wire [1:0]    HTRANSM3;
  wire [31:0]   HWDATAM3;
  wire          HWRITEM3;

// Miscellaneous signals

  wire [3:0]    HMASTER;
  wire [3:0]    HMASTERD;

  wire [1:0]    iHTRANS;
  wire [2:0]    iHBURST;
  wire [15:0]   HSPLIT;

//------------------------------------------------------------------------------
// Signal declarations: Scan chain
//------------------------------------------------------------------------------

  wire          SCANINarb;
  wire          SCANOUTarb;
  wire          SCANINegmst;
  wire          SCANOUTegmst;

//------------------------------------------------------------------------------
// Signal declarations: Tie-offs
//------------------------------------------------------------------------------

  wire          TieOffHi1;


//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// The TieOff signals must be assigned explicitly within the body of the HDL.
// Using initial values (in the signal declaration, above) will not work in
//  Synopsys. Signals are used rather than constants as constants can not be 
//  connected directly to sub-component instantiations
  assign TieOffHi1 = 1'b1;
  
// Example Bus Master instantiated as Local master 1
  EgMaster 
  // synopsys translate_off
    // Parameters (mapped to the top level parameters):
    //   Block enable: EBMenable = EnableEBM, 
    //   Base address read: EBMreadAddr = ReadAddrEBM,
    //   Base address write: EBMwriteAddr = WriteAddrEBM,
    //   Delay between transactions: EBMinitCount = InitCountEBM
    #(EnableEBM, ReadAddrEBM, WriteAddrEBM, InitCountEBM)
  // synopsys translate_on
  uEgMaster 
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HRDATA      (HRDATAmtrx),
     .HREADY      (HREADYmtrx),
     .HRESP       (HRESPmtrx),
     .HGRANT      (HGRANTM1),

     .HADDR       (HADDRM1),
     .HTRANS      (HTRANSM1),
     .HWRITE      (HWRITEM1),
     .HSIZE       (HSIZEM1),
     .HBURST      (HBURSTM1),
     .HPROT       (HPROTM1),
     .HWDATA      (HWDATAM1),
     .HBUSREQ     (HBUSREQM1),
     .HLOCK       (HLOCKM1),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINegmst), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTegmst) // Scan Chain Output
    );
  
// File Reader Bus Master instantiated as Local master 3
  FileReader 
  // synopsys translate_off
    // Parameter (mapped to the top level parameter):
    //   Default file name: InputFileName = StimFileFRBM
    #(StimFileFRBM)
  // synopsys translate_on
  uFileReader 
    (
     .HCLK    (HCLK),
     .HRESETn (nRESETfrbm),  // Not reset via HRESETn, to allow Reset test

     .HGRANT  (HGRANTM3),
     .HREADY  (HREADYmtrx),
     .HRESP   (HRESPmtrx),
     .HRDATA  (HRDATAmtrx),

     .HBUSREQ (HBUSREQM3),
     .HTRANS  (HTRANSM3),
     .HBURST  (HBURSTM3),
     .HPROT   (HPROTM3),
     .HSIZE   (HSIZEM3),
     .HWRITE  (HWRITEM3),
     .HLOCK   (HLOCKM3),
     .HADDR   (HADDRM3),
     .HWDATA  (HWDATAM3)
    );

// Local Arbiter
  Arbiter3 uArbiter 
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HTRANS      (iHTRANS),
     .HBURST      (iHBURST),
     .HREADY      (HREADYmtrx),
     .HRESP       (HRESPmtrx),

     .HBUSREQM3   (HBUSREQM3),
     .HBUSREQM2   (HBUSREQM2),
     .HBUSREQM1   (HBUSREQM1),
     .HBUSREQM0   (HBUSREQM0),

     .HLOCKM3     (HLOCKM3),
     .HLOCKM2     (HLOCKM2),
     .HLOCKM1     (HLOCKM1),
     .HLOCKM0     (HLOCKM0),

     .HSPLIT      (HSPLIT[3:0]),

     .HGRANTM3    (HGRANTM3),
     .HGRANTM2    (HGRANTM2),
     .HGRANTM1    (HGRANTM1),
     .HGRANTM0    (HGRANTM0),

     .HMASTER     (HMASTER),
     .HMASTERD    (HMASTERD),
     .HMASTLOCK   (HMASTLOCK),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINarb),  // Scan Chain Input
     .SCANOUTHCLK (SCANOUTarb)  // Scan Chain Output
    );

  // Pause requests Master 0 (2nd highest priority)
  assign HBUSREQM0 = Pause;

  // Unconnected Arbiter inputs driven LOW
  assign HLOCKM0   = 1'b0;
  assign HLOCKM2   = 1'b0;
  assign HBUSREQM2 = 1'b0;
  assign HSPLIT    = {16{1'b0}};

// Local multiplexer - masters to slaves
  MuxM2S uMuxM2S 
    (
     .HMASTER  (HMASTER),
     .HMASTERD (HMASTERD),

     .HADDRM1  (HADDRM1),
     .HTRANSM1 (HTRANSM1),
     .HWRITEM1 (HWRITEM1),
     .HSIZEM1  (HSIZEM1),
     .HBURSTM1 (HBURSTM1),
     .HPROTM1  (HPROTM1),
     .HWDATAM1 (HWDATAM1),

     .HADDRM2  (HADDRM2),
     .HTRANSM2 (HTRANSM2),
     .HWRITEM2 (HWRITEM2),
     .HSIZEM2  (HSIZEM2),
     .HBURSTM2 (HBURSTM2),
     .HPROTM2  (HPROTM2),
     .HWDATAM2 (HWDATAM2),

     .HADDRM3  (HADDRM3),
     .HTRANSM3 (HTRANSM3),
     .HWRITEM3 (HWRITEM3),
     .HSIZEM3  (HSIZEM3),
     .HBURSTM3 (HBURSTM3),
     .HPROTM3  (HPROTM3),
     .HWDATAM3 (HWDATAM3),

     .HADDR    (HADDR),
     .HTRANS   (iHTRANS),
     .HWRITE   (HWRITE),
     .HSIZE    (HSIZE),
     .HBURST   (iHBURST),
     .HPROT    (HPROT),
     .HWDATA   (HWDATA)
    );

// Drive the BusMatrix select signal HIGH because there are no other
//  slaves present in this module and BusMatrix is also the Default Slave
  assign HSELmtrx = TieOffHi1;

// Drive HREADYOUT with the state of HREADY from the BusMatrix because 
//  it is the Default Slave (see previous comment)
  assign HREADYOUT = HREADYmtrx;

// Connect these Local AHB backbone signals to the module interface
  assign HTRANS = iHTRANS;
  assign HBURST = iHBURST;


endmodule

// --================================= End ===================================--

