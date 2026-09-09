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
// File Name              : EASY.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
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
             TESTACK,

             nTRST,
             TCK,
             TDI,
             TMS,
             TDO
             );

`uselib lib=chip lib=sys lib=uut lib=trickbox

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


input         nTRST;    // JTAG connections
input         TCK;      // 
input         TDI;      // 
input         TMS;      // 
output        TDO;      // 



  wire        XCLKIN;   // External clock in
  wire        nReset;   // Power on reset input
  wire [31:0] XD;       // External data bus
  wire [30:0] XA;       // External address bus
  wire  [3:0] XCSN;     // External chip select
  wire        XOEN;     // External output enable
  wire  [3:0] XWEN;     // External write enable
  wire        TESTREQA; // Test bus request A
  wire        TESTREQB; // Test bus request B
  wire        TESTACK;  // Test acknowledge


  wire        nTRST;    // JTAG connections
  wire        TCK;      // 
  wire        TDI;      // 
  wire        TMS;      // 
  wire        TDO;      // 


// -----------------------------------------------------------------------------
//
//                                  EASY
//                                  ====
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//  The EASY microcontroller is an example AMBA system that
// illustrates the interconnections between the blocks that are normally part
// of a typical AMBA system.
//
// The DMAC and the DMAC Integration Trickbox are connected to the
// overall system as shown below :
//
//
//
//  +-----+
//  |     |                      Main AHB Bus
//  | TIC |--------+------------------------------------------------+-----
//  |     |        |                                                |
//  +-----+        |                                                |
//                 |                                                |
//         +-------+----+-+----------+           +----------+-+-----+------+
//         |  AHB Slave | |          |           |          | |  AHB Slave |
//         |  Interface | |          |           |          | |  Interface |
//         +------------+ |          |           | MEMORY   | +------------+
//         |              |  AHB     |   AHB     |          |              |
//         |   D M A C    |MASTER    +-----------+ MODEL    |      DMAC    |
//         |              |          |           |          |  Integration |
//         |              |          |           |          |    Trickbox  |
//         |              |          |           |          |              |
//         |              |          |           |          |              |
//         +--------------+----------+           +----------+--------------+
//
// The Integration trickbox contains two memory models which interface
// to the AHB Master interfaces of the DMAC. The DMAC performs
// transfers from one memory model to the other to prove connectivity
// of the AHB Master ports. In a user system, the trickbox is to be
// replaced with the user's Memory Controllers.
//
// -----------------------------------------------------------------------------

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

wire        HSELUUT;
reg  [31:0] HRDATAUUT;
reg         HREADYUUT;
reg   [1:0] HRESPUUT;

wire [31:0] HRDATADMAC;
wire        HREADYDMAC;
wire  [1:0] HRESPDMAC;

wire [31:0] HRDATAtrick;
wire        HREADYtrick;
wire  [1:0] HRESPtrick;

wire        HSELAPBif;
wire [31:0] HRDATAAPBif;
wire        HREADYAPBif;
wire  [1:0] HRESPAPBif;

wire        HSELArmTest;
wire [31:0] HRDATAArmTest;
wire        HREADYArmTest;
wire  [1:0] HRESPArmTest;

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

wire [31:0] HADDR003;
wire  [1:0] HTRANS003;
wire        HWRITE003;
wire  [2:0] HSIZE003;
wire  [2:0] HBURST003;
wire  [3:0] HPROT003;
wire [31:0] HWDATA003;
wire        HBUSREQ003;
wire        HLOCK003;
wire        HGRANT003;

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
// DMAC Controller Signals
//--------------------------------------
wire        HSELDMAC;

// Master Interface signals
wire        HGRANTDMACM;
wire        HREADYINM;
wire  [1:0] HRESPM;
wire [31:0] HRDATAM;
wire [15:0] DMACBREQ;
wire [15:0] DMACLBREQ;
wire [15:0] DMACSREQ;
wire [15:0] DMACLSREQ;
wire        SCANINHCLK;
wire        SCANENABLE;

wire        HREADYOUT;

wire        HBUSREQDMACM;
wire        HLOCKDMACM;
wire  [1:0] HTRANSM;
wire [31:0] HADDRM;
wire  [2:0] HSIZEM;
wire  [2:0] HBURSTM;
wire  [3:0] HPROTM;
wire        HWRITEM;
wire [31:0] HWDATAM;
wire [15:0] DMACCLR;
wire [15:0] DMACTC;
wire        DMACINTERR;
wire        DMACINTTC;
wire        DMACINTR;
wire        SCANOUTHCLK;

wire  [1:0] HselNext;

// Select for the integration trickbox
wire        HSELDMACTr;

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

assign SCANENABLE       = 1'b0;
assign SCANINHCLK       = 1'b0;

assign DMACBREQ         = 16'b0;
assign DMACLBREQ        = 16'b0;
assign DMACSREQ         = 16'b0;
assign DMACLSREQ        = 16'b0;

// -----------------------------------------------------------------------------
// AHB Slave select generation for the DMAC and the trickbox
// -----------------------------------------------------------------------------
assign HSELDMAC         = HSELUUT & HADDR[28];
assign HSELDMACTr       = HSELUUT & ( ~HADDR[28]);

assign HselNext         = {HSELDMAC, HSELDMACTr};

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
// Driving out the response from the Dmac and trickbox to the AHB1
// -----------------------------------------------------------------------------
always @(HselReg or HRDATADMAC or HRDATAtrick or HRESPDMAC or HRESPtrick or
         HREADYDMAC or HREADYtrick)
begin : p_OutputComb
  case (HselReg)
    2'b01 :
      begin
        HRDATAUUT        = HRDATAtrick;
        HRESPUUT         = HRESPtrick;
        HREADYUUT        = HREADYtrick;
      end
    2'b10 :
      begin
        HRDATAUUT        = HRDATADMAC;
        HRESPUUT         = HRESPDMAC;
        HREADYUUT        = HREADYDMAC;
      end
    default :
      begin
        HRDATAUUT        = {4'b0000, 4'b0000, 4'b0000, 4'b0000, 4'b0000,
                            4'b0000, 4'b0000, 4'b0000};
        HRESPUUT         = 2'b00;
        HREADYUUT        = 1'b1;
      end
  endcase
end // p_OutputComb

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
        .HBUSREQ003      (HBUSREQ003),
        .HBUSREQ004      (HBUSREQ004),
        .HLOCKarm        (HLOCKarm),
        .HLOCKtic        (HLOCKtic),
        .HLOCK003        (HLOCK003),
        .HLOCK004        (HLOCK004),
        .HSPLIT          (HSPLIT),
        .Pause           (Pause),
        .HGRANTarm       (HGRANTarm),
        .HGRANTtic       (HGRANTtic),
        .HGRANT003       (HGRANT003),
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
        .HSELUUT         (HSELUUT),
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
        .HADDR003        (HADDR003),
        .HTRANS003       (HTRANS003),
        .HWRITE003       (HWRITE003),
        .HSIZE003        (HSIZE003),
        .HBURST003       (HBURST003),
        .HPROT003        (HPROT003),
        .HWDATA003       (HWDATA003),
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
        .HSELUUT         (HSELUUT),
        .HSELAPBif       (HSELAPBif),
        .HSELArmTest     (HSELArmTest),
        .HRDATAIntMem    (HRDATAIntMem),
        .HREADYIntMem    (HREADYIntMem),
        .HRESPIntMem     (HRESPIntMem),
        .HRDATAExtMem    (HRDATAExtMem),
        .HREADYExtMem    (HREADYExtMem),
        .HRESPExtMem     (HRESPExtMem),
        .HRDATAUUT       (HRDATAUUT),
        .HREADYUUT       (HREADYUUT),
        .HRESPUUT        (HRESPUUT),
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
// UUT (DMAC) Instantiation
// -----------------------------------------------------------------------------
Dmac uut (
        .HCLK             (HCLK),
        .HRESETn          (HRESETn),
        .HSELDMAC         (HSELDMAC),
        .HWRITE           (HWRITE),
        .HTRANS           (HTRANS[1]),
        .HADDR            (HADDR[11 : 2]),
        .HSIZE            (HSIZE),
        .HREADYIN         (HREADY),
        .HWDATA           (HWDATA),
        .HGRANTDMACM      (HGRANTDMACM),
        .HREADYINM        (HREADYINM),
        .HRESPM           (HRESPM),
        .HRDATAM          (HRDATAM),
        .DMACBREQ         (DMACBREQ),
        .DMACLBREQ        (DMACLBREQ),
        .DMACSREQ         (DMACSREQ),
        .DMACLSREQ        (DMACLSREQ),
        .SCANINHCLK       (SCANINHCLK),
        .SCANENABLE       (SCANENABLE),
        .HREADYOUT        (HREADYDMAC),
        .HRESP            (HRESPDMAC),
        .HRDATA           (HRDATADMAC),
        .HBUSREQDMACM     (HBUSREQDMACM),
        .HLOCKDMACM       (HLOCKDMACM),
        .HTRANSM          (HTRANSM),
        .HADDRM           (HADDRM),
        .HSIZEM           (HSIZEM),
        .HBURSTM          (HBURSTM),
        .HPROTM           (HPROTM),
        .HWRITEM          (HWRITEM),
        .HWDATAM          (HWDATAM),
        .DMACCLR          (DMACCLR),
        .DMACTC           (DMACTC),
        .DMACINTERR       (DMACINTERR),
        .DMACINTTC        (DMACINTTC),
        .DMACINTR         (DMACINTR),
        .SCANOUTHCLK      (SCANOUTHCLK)
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

// -----------------------------------------------------------------------------
// Integration Trickbox Instantiation
// -----------------------------------------------------------------------------
DmacTrickInteg uDmacTrickInteg (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HSELDMACTr      (HSELDMACTr),
        .HWRITE          (HWRITE),
        .HTRANS          (HTRANS[1]),
        .HADDR           (HADDR[20 : 2]),
        .HSIZE           (HSIZE),
        .HREADYIN        (HREADY),
        .HREADYINM       (HREADYINM),
        .HWDATA          (HWDATA),
        .HBUSREQDMAM     (HBUSREQDMACM),
        .HLOCKDMAM       (HLOCKDMACM),
        .HTRANSM         (HTRANSM),
        .HADDRM          (HADDRM),
        .HSIZEM          (HSIZEM),
        .HBURSTM         (HBURSTM),
        .HPROTM          (HPROTM),
        .HWRITEM         (HWRITEM),
        .HWDATAM         (HWDATAM),
        .HREADYOUT       (HREADYtrick),
        .HRESP           (HRESPtrick),
        .HRDATA          (HRDATAtrick),
        .HGRANTDMAM      (HGRANTDMACM),
        .HRESPM          (HRESPM),
        .HREADYOUTM      (HREADYINM),
        .HRDATAM         (HRDATAM)
           );

endmodule
// --================================== End ==================================--
