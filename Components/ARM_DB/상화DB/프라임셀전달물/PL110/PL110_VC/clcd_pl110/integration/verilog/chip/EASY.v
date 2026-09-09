// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : EASY.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Structural architecture of Example Amba SYstem (EASY)
//
// --=========================================================================--

`timescale 1ns/1ps


module EASY (
             XCLKIN,
             nReset,
             XD,
             XA,
             XCSN,
             XOEN,
             XWEN,
             TESTREQA,
             TESTREQB,
             TESTACK
             );

`uselib lib=chip lib=sys lib=uut

input         XCLKIN;   // External clock in
input         nReset;   // Power on reset input
inout  [31:0] XD;       // External data bus
output [30:0] XA;       // External address bus
output  [3:0] XCSN;     // External chip select
output        XOEN;     // External output enable
output  [3:0] XWEN;     // External write enable
input         TESTREQA; // Test bus request A
input         TESTREQB; // Test bus request B
output        TESTACK;  // Test acknowledge

wire          XCLKIN;   // External clock in
wire          nReset;   // Power on reset input
wire [31:0]   XD;       // External data bus
wire [30:0]   XA;       // External address bus
wire  [3:0]   XCSN;     // External chip select
wire          XOEN;     // External output enable
wire  [3:0]   XWEN;     // External write enable
wire          TESTREQA; // Test bus request A
wire          TESTREQB; // Test bus request B
wire          TESTACK;  // Test acknowledge


// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire        HCLK;
wire        HRESETn;
wire  [1:0] HTRANS;
wire [31:0] HADDR;
wire        HWRITE;
wire  [2:0] HSIZE;
wire  [2:0] HBURST;
wire  [3:0] HPROT;
wire [31:0] HWDATA;
wire  [3:0] HMASTER;
wire        HMASTLOCK;
wire [15:0] HSPLIT;

// Multiplexed slave output signals
wire [31:0] HRDATA;
wire        HREADY;
wire  [1:0] HRESP;

// Slave specific output signals
wire        HSELIntMem;
wire [31:0] HRDATAIntMem = 'b0;
wire        HREADYIntMem = 0;
wire  [1:0] HRESPIntMem = 'b0;

wire        HSELExtMem;
wire [31:0] HRDATAExtMem;
wire        HREADYExtMem;
wire  [1:0] HRESPExtMem;

wire        HSELAPBif;
wire [31:0] HRDATAAPBif;
wire        HREADYAPBif;
wire  [1:0] HRESPAPBif;

wire        HSELArmTest;
wire [31:0] HRDATAArmTest;
wire        HREADYArmTest;
wire  [1:0] HRESPArmTest;

// Clcd Slave Interface signals
wire        HSELClcd;
wire [31:0] HRDATAClcdS;
wire        HREADYOutClcdS;
wire  [1:0] HRESPClcdS;

wire        HSELDefault;
wire        HREADYDefault;
wire  [1:0] HRESPDefault;

wire [15:0] HSPLIT001;
wire [15:0] HSPLIT002;
wire [15:0] HSPLIT003;
wire [15:0] HSPLIT004;

// Master specific signals
wire [31:0] HADDRarm   = 'b0;
wire  [1:0] HTRANSarm  = 'b0;
wire        HWRITEarm  = 'b0;
wire  [2:0] HSIZEarm   = 'b0;
wire  [2:0] HBURSTarm  = 'b0;
wire  [3:0] HPROTarm   = 'b0;
wire [31:0] HWDATAarm  = 'b0;
wire        HBUSREQarm = 'b0;
wire        HLOCKarm   = 'b0;
wire        HGRANTarm  = 'b0;

wire [31:0] HADDRtic;
wire  [1:0] HTRANStic;
wire        HWRITEtic;
wire  [2:0] HSIZEtic;
wire  [2:0] HBURSTtic;
wire  [3:0] HPROTtic;
wire [31:0] HWDATAtic;
wire        HBUSREQtic;
wire        HLOCKtic;
wire        HGRANTtic;

// Clcd AHB Master interface (Read Only) specific signals
wire [31:0] HADDRClcdM;
wire  [1:0] HTRANSClcdM;
wire        HWRITEClcdM;
wire  [2:0] HSIZEClcdM;
wire  [2:0] HBURSTClcdM;
wire  [3:0] HPROTClcdM;
wire [31:0] HWDATAClcdM = 32'h0000;
wire        HBUSREQClcdM;
wire        HLOCKClcdM;
wire        HGRANTClcdM = 1'b0;

wire [31:0] HADDR004;
wire  [1:0] HTRANS004;
wire        HWRITE004;
wire  [2:0] HSIZE004;
wire  [2:0] HBURST004;
wire  [3:0] HPROT004;
wire [31:0] HWDATA004;
wire        HBUSREQ004;
wire        HLOCK004;
wire        HGRANT004;

//--------------------------------------
// APB Signals
//--------------------------------------
wire        PENABLE;
wire        PSELIC;
wire        PSELUUT;
wire        PSELRPC;
wire [31:0] PADDR;
wire        PWRITE;
wire [31:0] PWDATA;
wire [31:0] PRDATA;

//--------------------------------------
// Example System Signals
//--------------------------------------
wire        Remap;
wire        Pause;
wire        TicRead;
wire        nTDOEN;

//--------------------------------------
// CLCD Signals
//--------------------------------------

wire        CLCDCLK;
wire        nCLCDCLK;

wire        CLCDMBEINTR;
wire        CLCDFUFINTR;
wire        CLCDLNBUINTR;
wire        CLCDVCOMPINTR;
wire        CLCDINTR;

// Display signals
wire        CLPOWER;
wire        CLLP;
wire        CLCP;
wire        CLFP;
wire        CLAC;
wire        CLLE;
wire [23:0] CLD;

// Scan Interface signals
wire        SCANENABLE     = 1'b0;
wire        SCANINHCLK     = 1'b0;
wire        SCANINCLCDCLK  = 1'b0;
wire        SCANINnCLCDCLK = 1'b0;
wire        SCANOUTHCLK;
wire        SCANOUTCLCDCLK;
wire        SCANOUTnCLCDCLK;

// Interrupt signals

wire  [1:0] HselNext;

// -----------------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg   [1:0] HselReg;
// ---------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Drive the AHB clock with the external clock input.
// -----------------------------------------------------------------------------
assign HCLK             = XCLKIN;
assign CLCDCLK          = XCLKIN;
assign nCLCDCLK         = ~XCLKIN;

// -----------------------------------------------------------------------------
// OR connection of split input to the Arbiter.
// -----------------------------------------------------------------------------
assign HSPLIT           = HSPLIT001 | HSPLIT002 | HSPLIT003 | HSPLIT004;

// -----------------------------------------------------------------------------
// Unconnected Arbiter inputs driven LOW
// -----------------------------------------------------------------------------
assign HBUSREQ004       = 1'b0;

assign HLOCK004         = 1'b0;

assign HSPLIT001        =  'b0 ;
assign HSPLIT002        =  'b0 ;
assign HSPLIT003        =  'b0 ;
assign HSPLIT004        =  'b0 ;

// -----------------------------------------------------------------------------
// Registered HSEL outputs are needed to control the slave output
// multiplexers, as the multiplexers must be switched in the cycle
// after the HSEL signals have been driven.
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_HselSeq
  if (HRESETn == 1'b0)
    HselReg          <= ('d0);
  else
    if (HREADY == 1'b1)
      HselReg          <= HselNext;
end // p_HselSeq


// -----------------------------------------------------------------------------
// The AHB to APB bridge Instantiation
// -----------------------------------------------------------------------------
APBif uAPBif (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HADDR           (HADDR),
        .HTRANS          (HTRANS),
        .HWRITE          (HWRITE),
        .HWDATA          (HWDATA),
        .HSELAPBif       (HSELAPBif),
        .HREADYin        (HREADY),
        .HRDATA          (HRDATAAPBif),
        .HREADYout       (HREADYAPBif),
        .HRESP           (HRESPAPBif),
        .PRDATA          (PRDATA),
        .PWDATA          (PWDATA),
        .PENABLE         (PENABLE),
        .PSELIC          (PSELIC),
        .PSELUUT         (PSELUUT),
        .PSELRPC         (PSELRPC),
        .PADDR           (PADDR),
        .PWRITE          (PWRITE)
           );

// -----------------------------------------------------------------------------
// The AHB system arbiter Instantiation
// -----------------------------------------------------------------------------
Arbiter uArbiter (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HTRANS          (HTRANS),
        .HBURST          (HBURST),
        .HREADY          (HREADY),
        .HRESP           (HRESP),
        .HBUSREQarm      (HBUSREQarm),
        .HBUSREQtic      (HBUSREQtic),
        .HBUSREQ003      (HBUSREQClcdM),
        .HBUSREQ004      (HBUSREQ004),
        .HLOCKarm        (HLOCKarm),
        .HLOCKtic        (HLOCKtic),
        .HLOCK003        (HLOCKClcdM),
        .HLOCK004        (HLOCK004),
        .HSPLIT          (HSPLIT),
        .Pause           (Pause),
        .HGRANTarm       (HGRANTarm),
        .HGRANTtic       (HGRANTtic),
        .HGRANT003       (HGRANTClcdM),
        .HGRANT004       (HGRANT004),
        .HMASTER         (HMASTER),
        .HMASTLOCK       (HMASTLOCK)
           );

// -----------------------------------------------------------------------------
// The system address Decoder Instantiation
// -----------------------------------------------------------------------------
Decoder uDecoder (
        .HRESETn         (HRESETn),
        .HADDR           (HADDR),
        .Remap           (Remap),
        .HSELIntMem      (HSELIntMem),
        .HSELExtMem      (HSELExtMem),
        .HSELUUT         (HSELClcd),
        .HSELAPBif       (HSELAPBif),
        .HSELArmTest     (HSELArmTest),
        .HSELDefault     (HSELDefault)
           );

// -----------------------------------------------------------------------------
// The Default Slave Instantiation
// -----------------------------------------------------------------------------
DefaultSlave uDefaultSlave (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HTRANS          (HTRANS),
        .HSELDefault     (HSELDefault),
        .HREADYin        (HREADY),
        .HREADYout       (HREADYDefault),
        .HRESP           (HRESPDefault)
           );

// -----------------------------------------------------------------------------
// Central multiplexer - masters to slaves - Instantiation
// -----------------------------------------------------------------------------
MuxM2S uMuxM2S (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HMASTER         (HMASTER),
        .HREADY          (HREADY),
        .HADDRarm        (HADDRarm),
        .HTRANSarm       (HTRANSarm),
        .HWRITEarm       (HWRITEarm),
        .HSIZEarm        (HSIZEarm),
        .HBURSTarm       (HBURSTarm),
        .HPROTarm        (HPROTarm),
        .HWDATAarm       (HWDATAarm),
        .HADDRtic        (HADDRtic),
        .HTRANStic       (HTRANStic),
        .HWRITEtic       (HWRITEtic),
        .HSIZEtic        (HSIZEtic),
        .HBURSTtic       (HBURSTtic),
        .HPROTtic        (HPROTtic),
        .HWDATAtic       (HWDATAtic),
        .HADDR003        (HADDRClcdM),
        .HTRANS003       (HTRANSClcdM),
        .HWRITE003       (HWRITEClcdM),
        .HSIZE003        (HSIZEClcdM),
        .HBURST003       (HBURSTClcdM),
        .HPROT003        (HPROTClcdM),
        .HWDATA003       (HWDATAClcdM),
        .HADDR004        (HADDR004),
        .HTRANS004       (HTRANS004),
        .HWRITE004       (HWRITE004),
        .HSIZE004        (HSIZE004),
        .HBURST004       (HBURST004),
        .HPROT004        (HPROT004),
        .HWDATA004       (HWDATA004),
        .HADDR           (HADDR),
        .HTRANS          (HTRANS),
        .HWRITE          (HWRITE),
        .HSIZE           (HSIZE),
        .HBURST          (HBURST),
        .HPROT           (HPROT),
        .HWDATA          (HWDATA)
           );

// -----------------------------------------------------------------------------
// Central multiplexer - slaves to masters - Instantiation
// -----------------------------------------------------------------------------
MuxS2M uMuxS2M (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HSELIntMem      (HSELIntMem),
        .HSELExtMem      (HSELExtMem),
        .HSELUUT         (HSELClcd),
        .HSELAPBif       (HSELAPBif),
        .HSELArmTest     (HSELArmTest),
        .HRDATAIntMem    (HRDATAIntMem),
        .HREADYIntMem    (HREADYIntMem),
        .HRESPIntMem     (HRESPIntMem),
        .HRDATAExtMem    (HRDATAExtMem),
        .HREADYExtMem    (HREADYExtMem),
        .HRESPExtMem     (HRESPExtMem),
        .HRDATAUUT       (HRDATAClcdS),
        .HREADYUUT       (HREADYOutClcdS),
        .HRESPUUT        (HRESPClcdS),
        .HRDATAAPBif     (HRDATAAPBif),
        .HREADYAPBif     (HREADYAPBif),
        .HRESPAPBif      (HRESPAPBif),
        .HRDATAArmTest   (HRDATAArmTest),
        .HREADYArmTest   (HREADYArmTest),
        .HRESPArmTest    (HRESPArmTest),
        .HREADYDefault   (HREADYDefault),
        .HRESPDefault    (HRESPDefault),
        .HRDATA          (HRDATA),
        .HREADY          (HREADY),
        .HRESP           (HRESP)
           );

// -----------------------------------------------------------------------------
// The bus reset controller Instantiation
// -----------------------------------------------------------------------------
ResCntl uResCntl (
        .HCLK            (HCLK),
        .POReset         (nReset),
        .HRESETn         (HRESETn)
           );

// -----------------------------------------------------------------------------
// UUT (CLCD PL110) Instantiation
// -----------------------------------------------------------------------------
Clcd uut (
        // Inputs
        .HCLK             (HCLK),
        .CLCDCLK          (CLCDCLK),
        .nCLCDCLK         (nCLCDCLK),
        .HRESETn          (HRESETn),
        .nCLCLKRESET      (HRESETn),
        .HSELCLCD         (HSELClcd),
        .HTRANSS          (HTRANS),
        .HWRITES          (HWRITE),
        .HREADYINS        (HREADY),
        .HRESPM           (HRESP),
        .HREADYINM        (HREADY),
        .HGRANTM          (HGRANTClcdM),
        .HADDRS           (HADDR[11:2]),
        .HWDATAS          (HWDATA),
        .HRDATAM          (HRDATA),
        .SCANENABLE       (SCANENABLE),
        .SCANINHCLK       (SCANINHCLK),
        .SCANINCLCDCLK    (SCANINCLCDCLK),
        .SCANINnCLCDCLK   (SCANINnCLCDCLK),
        
        // Outputs
        .HRESPS           (HRESPClcdS),
        .HREADYOUTS       (HREADYOutClcdS),
        .HTRANSM          (HTRANSClcdM),
        .HWRITEM          (HWRITEClcdM),
        .HSIZEM           (HSIZEClcdM),
        .HBURSTM          (HBURSTClcdM),
        .HBUSREQM         (HBUSREQClcdM),
        .HPROT            (HPROTClcdM),
        .HLOCK            (HLOCKClcdM),
        .CLCDCLKSEL       (CLCDCLKSEL),
        .HADDRM           (HADDRClcdM),
        .HRDATAS          (HRDATAClcdS),
        .CLCDMBEINTR      (CLCDMBEINTR),
        .CLCDFUFINTR      (CLCDFUFINTR),
        .CLCDLNBUINTR     (CLCDLNBUINTR),
        .CLCDVCOMPINTR    (CLCDVCOMPINTR),
        .CLCDINTR         (CLCDINTR),
        .CLPOWER          (CLPOWER),
        .CLLP             (CLLP),
        .CLCP             (CLCP),
        .CLFP             (CLFP),
        .CLAC             (CLAC),
        .CLLE             (CLLE),
        .CLD              (CLD),
        .SCANOUTHCLK      (SCANOUTHCLK),
        .SCANOUTCLCDCLK   (SCANOUTCLCDCLK),
        .SCANOUTnCLCDCLK  (SCANOUTnCLCDCLK)
    );

// -----------------------------------------------------------------------------
// RPS Instantiation
// -----------------------------------------------------------------------------
RPS u_rps (
        .PCLK            (HCLK),
        .PRESETn         (HRESETn),
        .Pause           (Pause),
        .Remap           (Remap),
        .PSELUUT         (PSELUUT),
        .PSELRPC         (PSELRPC),
        .PENABLE         (PENABLE),
        .PADDR           (PADDR),
        .PWRITE          (PWRITE),
        .PWDATA          (PWDATA),
        .PRDATA          (PRDATA)
           );

// -----------------------------------------------------------------------------
// An example External Bus Interface Instantiation
// -----------------------------------------------------------------------------
SMI uSMI (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HADDR           (HADDR),
        .HTRANS          (HTRANS),
        .HWRITE          (HWRITE),
        .HSIZE           (HSIZE),
        .HWDATAin        (HWDATA),
        .HSELExtMem      (HSELExtMem),
        .HRDATAin        (HRDATA),
        .HREADYin        (HREADY),
        .HRDATAout       (HRDATAExtMem),
        .HREADYout       (HREADYExtMem),
        .HRESP           (HRESPExtMem),
        .Remap           (Remap),
        .TicRead         (TicRead),
        .XD              (XD),
        .XA              (XA),
        .XCSN            (XCSN),
        .XOEN            (XOEN),
        .XWEN            (XWEN)
           );

// -----------------------------------------------------------------------------
// The Test Interface Controller Instantiation
// -----------------------------------------------------------------------------
TIC uTIC (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HREADY          (HREADY),
        .HRESP           (HRESP),
        .HGRANTtic       (HGRANTtic),
        .HADDR           (HADDRtic),
        .HTRANS          (HTRANStic),
        .HWRITE          (HWRITEtic),
        .HSIZE           (HSIZEtic),
        .HBURST          (HBURSTtic),
        .HPROT           (HPROTtic),
        .HWDATA          (HWDATAtic),
        .HBUSREQtic      (HBUSREQtic),
        .HLOCKtic        (HLOCKtic),
        .TESTBUS         (XD),
        .TESTREQA        (TESTREQA),
        .TESTREQB        (TESTREQB),
        .TESTACK         (TESTACK),
        .TicRead         (TicRead)
           );


endmodule
// --================================== End ==================================--
