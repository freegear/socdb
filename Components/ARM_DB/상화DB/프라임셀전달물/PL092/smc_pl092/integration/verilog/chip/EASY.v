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
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL092-REL1v1
//
// -----------------------------------------------------------------------------
// Purpose :
//           Structural architecture of Example Amba SYstem (EASY)
//
// --=========================================================================--

`timescale 1ns/1ps

`include "../chip/timing.v"
`include "../chip/timingmaster.v"
`include "../common/defs.v"

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

`uselib lib=chip lib=sys lib=trickbox lib=uut

input         XCLKIN;          // External clock in
input         nReset;          // Power on reset input
inout  [31:0] XD;              // External data bus
output [30:0] XA;              // External address bus
output  [3:0] XCSN;            // External chip select
output        XOEN;            // External output enable
output  [3:0] XWEN;            // External write enable
    
input         TESTREQA;        // Test bus request A
input         TESTREQB;        // Test bus request B
output        TESTACK;         // Test acknowledge

input         nTRST;           // JTAG connections
input         TCK;
input         TDI;
input         TMS;
output        TDO;

// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
// AHB Signals
wire        HCLK;
wire        nHCLK;
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
wire [31:0] HRDATAIntMem;
wire        HREADYIntMem;
wire  [1:0] HRESPIntMem;

wire        HSELExtMem;
wire [31:0] HRDATAExtMem;
wire        HREADYExtMem;
wire  [1:0] HRESPExtMem;

wire        HSELREG;
wire        HSELUUT;
wire [31:0] HRDATAUUT;
wire        HREADYUUT;
wire  [1:0] HRESPUUT;
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
wire [31:0] HADDRarm;
wire  [1:0] HTRANSarm;
wire        HWRITEarm;
wire  [2:0] HSIZEarm;
wire  [2:0] HBURSTarm;
wire  [3:0] HPROTarm;
wire [31:0] HWDATAarm;
wire        HBUSREQarm;
wire        HLOCKarm;
wire        HGRANTarm;

wire [31:0] HADDRtic;
wire  [1:0] HTRANStic;
wire        HWRITEtic;
wire  [2:0] HSIZEtic;
wire  [2:0] HBURSTtic;
wire  [3:0] HPROTtic;
wire [31:0] HRDATAtic;
wire [31:0] HWDATAtic;
wire        HBUSREQtic;
wire        HLOCKtic;
wire        HGRANTtic;
wire        TICBUSREQ;
wire        TICBUSGNT;
wire        iTESTACK;
wire [31:0] TBUSOUT;

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

wire [63:0] HRDATAdly;
wire [63:0] HWDATASlave;

// APB Signals
wire        PENABLE;
wire        PSELIC;
wire        PSELUUT;
wire        PSELRPC;
wire [31:0] PADDR;
wire        PWRITE;
wire [31:0] PWDATA;
wire [31:0] PRDATA;

// Example System Signals
wire        Remap;
wire        Pause;

wire        TicRead;

// Static Memory Controller Signals
wire        SCANENABLE;
wire        SCANINHCLK;
wire        SCANINnHCLK;
wire        SCANOUTHCLK;
wire        SCANOUTnHCLK;
wire        BIGENDIAN;

// External Signals
wire  [1:0] SMMWCS7;
wire        SMWAIT;
wire        CANCELSMWAIT;
wire [31:0] SMDATAIN;
wire [31:0] SMDATAOUT;
wire [25:0] SMADDR;
wire  [7:0] SMCS;
wire  [3:0] nSMDATAEN;
wire        nSMWEN;
wire  [3:0] nSMBLS;
wire        nSMOEN;

wire        MCBUSREQ;
wire [25:0] MCADDR;
wire [31:0] MCDATAOUT;
wire  [3:0] MCDATAEN;
wire        MCBUSGNT;

// External signals related to the EbiSdram
wire        TICBUSGNTEBI;
wire        SMBUSGNTEBI;

wire        EXTBUSMUX;

wire        TICBUSREQEBI;
wire        SMBUSREQEBI;

wire        TICREADEBI;
wire [31:0] TBUSOUTEBI;

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Memory Data Bus multiplexing
// -----------------------------------------------------------------------------
assign XD[7:0]          = (nSMDATAEN[0] == 1'b0) ? SMDATAOUT[7:0]   :
                           8'bzzzzzzzz;

assign XD[15:8]         = (nSMDATAEN[1] == 1'b0) ? SMDATAOUT[15:8]  :
                           8'bzzzzzzzz;

assign XD[23:16]        = (nSMDATAEN[2] == 1'b0) ? SMDATAOUT[23:16] :
                           8'bzzzzzzzz;

assign XD[31:24]        = (nSMDATAEN[3] == 1'b0) ? SMDATAOUT[31:24] :
                           8'bzzzzzzzz;

assign SMDATAIN         = (XD !== 32'hzzzzzzzz) ? XD : 32'h00000000;

// -----------------------------------------------------------------------------
// Drive the AHB clock with the external clock input.
// -----------------------------------------------------------------------------
assign TESTACK          = iTESTACK;
assign HCLK             = XCLKIN;
assign nHCLK            = 1'b0;

// -----------------------------------------------------------------------------
// OR connection of split input to the Arbiter.
// -----------------------------------------------------------------------------
assign HSPLIT           = HSPLIT001 | HSPLIT002 | HSPLIT003 | HSPLIT004;

// -----------------------------------------------------------------------------
// Unconnected Arbiter inputs driven LOW
// -----------------------------------------------------------------------------
assign HBUSREQ003       = 1'b0;
assign HBUSREQ004       = 1'b0;

assign HRDATAUUT        = HRDATAdly[31:0];
assign HWDATASlave      = {32'h00000000, HWDATA};

assign HLOCK003         = 1'b0;
assign HLOCK004         = 1'b0;

assign HSPLIT002        = 16'h0000;
assign HSPLIT003        = 16'h0000;
assign HSPLIT004        = 16'h0000;

assign HRESPIntMem      = 2'b00;
assign HREADYIntMem     = 1'b0;
assign HRDATAIntMem     = 32'h00000000;

assign HADDRarm         = 32'h00000000;
assign HTRANSarm        = 2'b00;
assign HWRITEarm        = 1'b0;
assign HSIZEarm         = 3'b000;
assign HBURSTarm        = 3'b000;
assign HPROTarm         = 4'h0;
assign HWDATAarm        = 32'h00000000;
assign HBUSREQarm       = 1'b0;
assign HLOCKarm         = 1'b0;

//assign HGRANTtic        = 1'b1;
assign TICBUSGNT        = 1'b1;

assign MCBUSREQ         = 1'b0;
assign MCADDR           = 26'b00000000000000000000000000;
assign MCDATAOUT        = 32'h00000000;
assign MCDATAEN         = 4'h0;

assign SCANENABLE       = 1'b0;
assign SCANINHCLK       = 1'b0;
assign SCANINnHCLK      = 1'b0;

assign TICBUSGNTEBI     = 1'b0;

assign SMBUSGNTEBI      = 1'b0;

assign EXTBUSMUX        = 1'b0;

// -----------------------------------------------------------------------------
// The AHB to APB bridge Instantiation
// -----------------------------------------------------------------------------
APBif uAPBif                          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HWDATA           (HWDATA),
                    .HSELAPBif        (HSELAPBif),
                    .HREADYin         (HREADY),
      
                    .HRDATA           (HRDATAAPBif),
                    .HREADYout        (HREADYAPBif),
                    .HRESP            (HRESPAPBif),

                    .PRDATA           (PRDATA),

                    .PWDATA           (PWDATA),
                    .PENABLE          (PENABLE),
                    .PSELIC           (PSELIC),
                    .PSELUUT          (PSELUUT),
                    .PSELRPC          (PSELRPC),
                    .PADDR            (PADDR),
                    .PWRITE           (PWRITE)
                    );

// -----------------------------------------------------------------------------
// The AHB system arbiter Instantiation
// -----------------------------------------------------------------------------
Arbiter uArbiter                      (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HTRANS           (HTRANS),
                    .HBURST           (HBURST),
                    .HREADY           (HREADY),
                    .HRESP            (HRESP),

                    .HBUSREQarm       (HBUSREQarm),
                    .HBUSREQtic       (HBUSREQtic),
                    .HBUSREQ003       (HBUSREQ003),
                    .HBUSREQ004       (HBUSREQ004),

                    .HLOCKarm         (HLOCKarm),
                    .HLOCKtic         (HLOCKtic),
                    .HLOCK003         (HLOCK003),
                    .HLOCK004         (HLOCK004),

                    .HSPLIT           (HSPLIT),

                    .Pause            (Pause),

                    .HGRANTarm        (HGRANTarm),
                    .HGRANTtic        (HGRANTtic),
                    .HGRANT003        (HGRANT003),
                    .HGRANT004        (HGRANT004),

                    .HMASTER          (HMASTER),
                    .HMASTLOCK        (HMASTLOCK)
                    );

// -----------------------------------------------------------------------------
// The system address Decoder Instantiation
// -----------------------------------------------------------------------------
Decoder uDecoder                      (
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR),

                    .Remap            (Remap),

                    .HSELIntMem       (HSELIntMem),
                    .HSELExtMem       (HSELExtMem),
                    .HSELUUT          (HSELUUT),
                    .HSELAPBif        (HSELAPBif),
                    .HSELArmTest      (HSELArmTest),
                    .HSELDefault      (HSELDefault)
                    );

// -----------------------------------------------------------------------------
// The Default Slave Instantiation
// -----------------------------------------------------------------------------
DefaultSlave uDefaultSlave            (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HTRANS           (HTRANS),
                    .HSELDefault      (HSELDefault),
                    .HREADYin         (HREADY),

                    .HREADYout        (HREADYDefault),
                    .HRESP            (HRESPDefault)
                    );

// -----------------------------------------------------------------------------
// Central multiplexer - masters to slaves - Instantiation
// -----------------------------------------------------------------------------
MuxM2S uMuxM2S                        (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HMASTER          (HMASTER),
                    .HREADY           (HREADY),

                    .HADDRarm         (HADDRarm),
                    .HTRANSarm        (HTRANSarm),
                    .HWRITEarm        (HWRITEarm),
                    .HSIZEarm         (HSIZEarm),
                    .HBURSTarm        (HBURSTarm),
                    .HPROTarm         (HPROTarm),
                    .HWDATAarm        (HWDATAarm),

                    .HADDRtic         (HADDRtic),
                    .HTRANStic        (HTRANStic),
                    .HWRITEtic        (HWRITEtic),
                    .HSIZEtic         (HSIZEtic),
                    .HBURSTtic        (HBURSTtic),
                    .HPROTtic         (HPROTtic),
                    .HWDATAtic        (HWDATAtic),

                    .HADDR003         (HADDR003),
                    .HTRANS003        (HTRANS003),
                    .HWRITE003        (HWRITE003),
                    .HSIZE003         (HSIZE003),
                    .HBURST003        (HBURST003),
                    .HPROT003         (HPROT003),
                    .HWDATA003        (HWDATA003),

                    .HADDR004         (HADDR004),
                    .HTRANS004        (HTRANS004),
                    .HWRITE004        (HWRITE004),
                    .HSIZE004         (HSIZE004),
                    .HBURST004        (HBURST004),
                    .HPROT004         (HPROT004),
                    .HWDATA004        (HWDATA004),

                    .HADDR            (HADDR),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HPROT            (HPROT),
                    .HWDATA           (HWDATA)
                    );

// -----------------------------------------------------------------------------
// Central multiplexer - slaves to masters - Instantiation
// -----------------------------------------------------------------------------
MuxS2M uMuxS2M                        (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HSELIntMem       (HSELIntMem),
                    .HSELExtMem       (HSELExtMem),
                    .HSELUUT          (HSELUUT),
                    .HSELAPBif        (HSELAPBif),
                    .HSELArmTest      (HSELArmTest),

                    .HRDATAIntMem     (HRDATAIntMem),
                    .HREADYIntMem     (HREADYIntMem),
                    .HRESPIntMem      (HRESPIntMem),

                    .HRDATAExtMem     (HRDATAExtMem),
                    .HREADYExtMem     (HREADYExtMem),
                    .HRESPExtMem      (HRESPExtMem),

                    .HRDATAUUT        (HRDATAUUT),
                    .HREADYUUT        (HREADYUUT),
                    .HRESPUUT         (HRESPUUT),

                    .HRDATAAPBif      (HRDATAAPBif),
                    .HREADYAPBif      (HREADYAPBif),
                    .HRESPAPBif       (HRESPAPBif),

                    .HRDATAArmTest    (HRDATAArmTest),
                    .HREADYArmTest    (HREADYArmTest),
                    .HRESPArmTest     (HRESPArmTest),

                    .HREADYDefault    (HREADYDefault),
                    .HRESPDefault     (HRESPDefault),

                    .HRDATA           (HRDATA),
                    .HREADY           (HREADY),
                    .HRESP            (HRESP)
                    );

// -----------------------------------------------------------------------------
// The bus reset controller Instantiation
// -----------------------------------------------------------------------------
ResCntl uResCntl                      (
                    .HCLK             (HCLK),
                    .POReset          (nReset),
                    .HRESETn          (HRESETn)
                    );

// -----------------------------------------------------------------------------
// Generic AHB Slave Instantiation
// -----------------------------------------------------------------------------
// defparam uAhbSlave.tclkl   = `Tclkl;
// defparam uAhbSlave.tclkh   = `Tclkh;
// defparam uAhbSlave.tovrdy  = `Tovrdy;
// defparam uAhbSlave.tohrdy  = `Tohrdy;
// defparam uAhbSlave.tovrsp  = `Tovrsp;
// defparam uAhbSlave.tohrsp  = `Tohrsp;
// defparam uAhbSlave.tovsplt = `Tovsplt;
// defparam uAhbSlave.tohsplt = `Tohsplt;
// defparam uAhbSlave.tovdr   = `Tovdr;
// defparam uAhbSlave.tohdr   = `Tohdr;

AhbSlave uAhbSlave                    (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HWDATA           (HWDATASlave),
                    .HRDATAIn         (HRDATAdly),
                    .HREADYIn         (HREADY),
                    .HSPLITIn         (HSPLIT),
                    .HSEL             (HSELUUT),
                    .HMASTER          (HMASTER),
                    .HMASTLOCK        (HMASTLOCK),
                    .HRESPIn          (HRESP),
                    .HRDATAdly        (HRDATAdly),
                    .HREADYdly        (HREADYUUT),
                    .HRESPdly         (HRESPUUT),
                    .HSPLITdly        (HSPLIT001)
                    );

// -----------------------------------------------------------------------------
// RPS Instantiation
// -----------------------------------------------------------------------------
RPS uRPS                              (
                    .PCLK             (HCLK),
                    .PRESETn          (HRESETn),
                    .Pause            (Pause),
                    .Remap            (Remap),

                    .PSELUUT          (PSELUUT),
                    .PSELRPC          (PSELRPC),

                    .PENABLE          (PENABLE),
                    .PADDR            (PADDR),
                    .PWRITE           (PWRITE),
                    .PWDATA           (PWDATA),
                    .PRDATA           (PRDATA)
                    );

// -----------------------------------------------------------------------------
// SMC and the TIC Module Instantiation
// -----------------------------------------------------------------------------
Smc uut                               (
// Inputs
                    .nHCLK            (nHCLK),
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HREADYIN         (HREADY),
                    .HADDR            (HADDR[28:0]),
                    .HBURST           (HBURST),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HWDATA           (HWDATA),
                    .HSELSMC          (HSELExtMem),
                    .HSELREG          (HSELREG),
                    .HRESPTIC         (HRESP),
                    .HRDATATIC        (HRDATA),
                    .HGRANTTIC        (HGRANTtic),
                    .BIGENDIAN        (BIGENDIAN),
                    .REMAP            (Remap),
                    .TICBUSGNTEBI     (TICBUSGNTEBI),
                    .SMBUSGNTEBI      (SMBUSGNTEBI),
                    .SCANENABLE       (SCANENABLE),
                    .SCANINHCLK       (SCANINHCLK),
                    .SCANINnHCLK      (SCANINnHCLK),
                    .SMWAIT           (SMWAIT),
                    .CANCELSMWAIT     (CANCELSMWAIT),
                    .SMMWCS7          (SMMWCS7),
                    .SMDATAIN         (SMDATAIN),
                    .TESTREQA         (TESTREQA),
                    .TESTREQB         (TESTREQB),
                    .MCBUSREQ         (MCBUSREQ),
                    .MCADDR           (MCADDR),
                    .MCDATAOUT        (MCDATAOUT),
                    .MCDATAEN         (MCDATAEN),
                    .EXTBUSMUX        (EXTBUSMUX),

// Outputs
                    .HRDATA           (HRDATAExtMem),
                    .HREADYOUT        (HREADYExtMem),
                    .HRESP            (HRESPExtMem),
                    .HADDRTIC         (HADDRtic),
                    .HTRANSTIC        (HTRANStic),
                    .HWRITETIC        (HWRITEtic),
                    .HSIZETIC         (HSIZEtic),
                    .HBURSTTIC        (HBURSTtic),
                    .HPROTTIC         (HPROTtic),
                    .HWDATATIC        (HWDATAtic),
                    .HBUSREQTIC       (HBUSREQtic),
                    .HLOCKTIC         (HLOCKtic),
                    .TICBUSREQEBI     (TICBUSREQEBI),
                    .SMBUSREQEBI      (SMBUSREQEBI),
                    .SCANOUTnHCLK     (SCANOUTnHCLK),
                    .SCANOUTHCLK      (SCANOUTHCLK),
                    .SMDATAOUT        (SMDATAOUT),
                    .nSMDATAEN        (nSMDATAEN),
                    .SMADDR           (SMADDR),
                    .SMCS             (SMCS),
                    .nSMBLS           (nSMBLS),
                    .nSMWEN           (nSMWEN),
                    .nSMOEN           (nSMOEN),
                    .TICREADEBI       (TICREADEBI),
                    .TBUSOUTEBI       (TBUSOUTEBI),
                    .TESTACK          (iTESTACK),
                    .MCBUSGNT         (MCBUSGNT)
                    );

// -----------------------------------------------------------------------------
// TIC Master Watcher Instantiation
// -----------------------------------------------------------------------------
TicWatcher uTicWatcher                (
                    .TCLK             (HCLK),
                    .RESETn           (HRESETn),
                    .TESTREQA         (TESTREQA),
                    .TESTREQB         (TESTREQB),
                    .TESTACK          (iTESTACK),
                    .TESTBUS          (XD),
    
                    .HADDRTIC         (HADDRtic),
                    .HWRITETIC        (HWRITEtic),
                    .HTRANSTIC        (HTRANStic),
                    .HSIZETIC         (HSIZEtic),
                    .HBURSTTIC        (HBURSTtic),
                    .HPROTTIC         (HPROTtic),
                    .HWDATATIC        (HWDATAtic)
                    );

// defparam ubuswatchmaster.HaltOnMismatch = `FALSE;
// defparam ubuswatchmaster.Verbosity      = `FALSE;
// defparam ubuswatchmaster.Tclk           = `Tclk;
// defparam ubuswatchmaster.Tovtr          = `Tovtr;
// defparam ubuswatchmaster.Tohtr          = `Tohtr;
// defparam ubuswatchmaster.Tova           = `Tova;
// defparam ubuswatchmaster.Toha           = `Toha;
// defparam ubuswatchmaster.Tovctl         = `Tovctl;
// defparam ubuswatchmaster.Tohctl         = `Tohctl;
// defparam ubuswatchmaster.Tovwd          = `Tovwd;
// defparam ubuswatchmaster.Tohwd          = `Tohwd;
// defparam ubuswatchmaster.Tovreq         = `Tovreq;
// defparam ubuswatchmaster.Tohreq         = `Tohreq;
// defparam ubuswatchmaster.Tovlck         = `Tovlck;
// defparam ubuswatchmaster.Tohlck         = `Tohlck;

buswatchmaster ubuswatchmaster        (
// Inputs
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HTRANS           (HTRANS),
                    .HADDR            (HADDR),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HBUSREQx         (HBUSREQtic),
                    .HGRANTx          (HGRANTtic),
                    .HREADY           (HREADY),
                    .HLOCKx           (HLOCKtic),
                    .HWDATA           (HWDATASlave),
                    .HPROT            (HPROT),
                    .HWRITE           (HWRITE),
                    .HRESP            (HRESP),
// Outputs
                    .ResetOver        ()
                    );

endmodule

// --================================ End ====================================--
