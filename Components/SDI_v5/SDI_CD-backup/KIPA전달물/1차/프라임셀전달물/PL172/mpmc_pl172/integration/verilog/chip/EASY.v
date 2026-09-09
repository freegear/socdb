// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : EASY.v.rca
// File Revision          : 1.6
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Structural architecture of Example Amba SYstem (EASY)
//
// --=========================================================================--

`timescale 1ns/1ps


module EASY (
// Inputs
             XCLKIN,
             nReset,
             TESTREQA,
             TESTREQB,
             nTRST,
             TCK,
             TDI,
             TMS,

// Inouts
             XD,

// Outputs
             XA,
             XCSN,
             XOEN,
             XWEN,

             TESTACK,

             TDO
            );

`uselib lib=chip lib=sys lib=trickbox lib=uut

// Inputs
input         XCLKIN;           // External clock in
input         nReset;           // Power on reset input
input         TESTREQA;         // Test bus request A
input         TESTREQB;         // Test bus request B
input         nTRST;            // JTAG connections
input         TCK;              // 
input         TDI;              // 
input         TMS;              // 

// Inouts
inout  [31:0] XD;               // External data bus

// Outputs
output [30:0] XA;               // External address bus
output  [3:0] XCSN;             // External chip select
output        XOEN;             // External output enable
output  [3:0] XWEN;             // External write enable
output        TESTACK;          // Test acknowledge
output        TDO;              // 

// Inputs
  wire        XCLKIN;           // External clock in
  wire        nReset;           // Power on reset input
  wire        TESTREQA;         // Test bus request A
  wire        TESTREQB;         // Test bus request B
  wire        nTRST;            // JTAG connections
  wire        TCK;              // 
  wire        TDI;              // 
  wire        TMS;              // 

// Inouts
  wire [31:0] XD;               // External data bus

// Outputs
  wire [30:0] XA;               // External address bus
  wire  [3:0] XCSN;             // External chip select
  wire        XOEN;             // External output enable
  wire  [3:0] XWEN;             // External write enable
  wire        TESTACK;          // Test acknowledge
  wire        TDO;              // 

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
  wire  [1:0] IntHSEL;
  reg   [1:0] DelHSEL;

// AHB Signals
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

// Open inputs for the AHB Slave ports of the MPMC
  wire        HREADYINREG;
  wire        HTRANSREG;
  wire  [9:0] HADDRREG;
  wire        HWRITEREG;
  wire  [2:0] HSIZEREG;
  wire  [2:0] HBURSTREG;
  wire  [2:0] HPROTREG;
  wire [15:0] HWDATAREG15TO0;
  wire [20:19] HWDATAREG20TO19;
  reg         HSELMPMCREG;

  wire        HREADYIN0;
  wire  [1:0] HTRANS0;
  wire [27:0] HADDR0;
  wire        HWRITE0;
  wire  [2:0] HSIZE0;
  wire  [2:0] HBURST0;
  wire  [3:0] HPROT0;
  wire [31:0] HWDATA0;
  reg         HSELMPMC0G;
  reg   [7:0] HSELMPMC0CS;
  wire        HMASTLOCK0;

  wire        HREADYIN1;
  wire  [1:0] HTRANS1;
  wire [27:0] HADDR1;
  wire        HWRITE1;
  wire  [2:0] HSIZE1;
  wire  [2:0] HBURST1;
  wire  [3:0] HPROT1;
  wire [31:0] HWDATA1;
  reg         HSELMPMC1G;
  reg   [7:0] HSELMPMC1CS;
  wire        HMASTLOCK1;

  wire        HREADYIN2;
  wire  [1:0] HTRANS2;
  wire [27:0] HADDR2;
  wire        HWRITE2;
  wire  [2:0] HSIZE2;
  wire  [2:0] HBURST2;
  wire  [3:0] HPROT2;
  wire [31:0] HWDATA2;
  reg         HSELMPMC2G;
  reg   [7:0] HSELMPMC2CS;
  wire        HMASTLOCK2;

  wire        HREADYIN3;
  wire  [1:0] HTRANS3;
  wire [27:0] HADDR3;
  wire        HWRITE3;
  wire  [2:0] HSIZE3;
  wire  [2:0] HBURST3;
  wire  [3:0] HPROT3;
  wire [31:0] HWDATA3;
  reg         HSELMPMC3G;
  reg   [7:0] HSELMPMC3CS;
  wire        HMASTLOCK3;

// Open outputs of the MPMC AHB Slave ports
  wire [20:0] HRDATAREG;
  wire        HREADYOUTREG;
  wire  [1:0] HRESPREG;

  wire [31:0] HRDATA0;
  wire        HREADYOUT0;
  wire  [1:0] HRESP0;

  wire [31:0] HRDATA1;
  wire        HREADYOUT1;
  wire  [1:0] HRESP1;

  wire [31:0] HRDATA2;
  wire        HREADYOUT2;
  wire  [1:0] HRESP2;

  wire [31:0] HRDATA3;
  wire        HREADYOUT3;
  wire  [1:0] HRESP3;

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
  reg  [31:0] HRDATAUUT;

  reg         HREADYUUT;
  reg   [1:0] HRESPUUT;
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
  reg  [31:0] HADDRarm;

  reg   [1:0] HTRANSarm;

  reg         HWRITEarm;
  reg   [2:0] HSIZEarm;

  reg   [2:0] HBURSTarm;

  reg   [3:0] HPROTarm;

  reg  [31:0] HWDATAarm;

  wire        HBUSREQarm;
  wire        HLOCKarm;
  wire        HGRANTarm;

  wire [31:0] HADDRTIC;
  wire  [1:0] HTRANSTIC;
  wire        HWRITETIC;
  wire  [2:0] HSIZETIC;
  wire  [2:0] HBURSTTIC;
  wire  [3:0] HPROTTIC;
  wire [31:0] HRDATATIC;
  wire [31:0] HWDATATIC;
  wire        HBUSREQTIC;
  wire        HLOCKTIC;
  wire        HGRANTTIC;
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

// Generic AHB Slave signals
  wire [63:0] HRDATAAHBSLV;
  wire        HREADYOUTAHBSLV;
  wire  [1:0] HRESPAHBSLV;
  wire [63:0] HWDATASlave;
  reg         HSELAHBSLAVE;

// -----------------------------------------------------------------------------
// APB Signals
// -----------------------------------------------------------------------------
  wire        PENABLE;
  wire        PSELIC;
  wire        PSELUUT;
  wire        PSELRPC;
  wire [31:0] PADDR;
  wire        PWRITE;
  wire [31:0] PWDATA;
  wire [31:0] PRDATA;

// -----------------------------------------------------------------------------
// Example System Signals
// -----------------------------------------------------------------------------
  wire        Remap;
  wire        Pause;

  wire        TicRead;

// -----------------------------------------------------------------------------
// Static Memory Controller Signals
// -----------------------------------------------------------------------------
  wire        SCANENABLE;
  wire        SCANINHCLK;
  wire        SCANINMPMCCLK;
  wire        SCANINCLKDELAY;
  wire        SCANINFBCLKIN0;
  wire        SCANINFBCLKIN1;
  wire        SCANINFBCLKIN2;
  wire        SCANINFBCLKIN3;
  wire        SCANOUTHCLK;
  wire        SCANOUTMPMCCLK;
  wire        SCANOUTCLKDELAY;
  wire        SCANOUTFBCLKIN0;
  wire        SCANOUTFBCLKIN1;
  wire        SCANOUTFBCLKIN2;
  wire        SCANOUTFBCLKIN3;
  wire        MPMCBIGENDIAN;

// External Signals
  wire  [1:0] MPMCSTCS1MW;
  wire        MPMCSTCS0POL;
  wire        MPMCSTCS1POL;
  wire        MPMCSTCS2POL;
  wire        MPMCSTCS3POL;
  wire        MPMCCLK;
  wire        MPMCCLKDELAY;
  wire  [3:0] MPMCCLKOUT;
  wire        MPMCFBCLKIN0;
  wire        MPMCFBCLKIN1;
  wire        MPMCFBCLKIN2;
  wire        MPMCFBCLKIN3;
  wire        nPOR;
  wire  [3:0] MPMCCKEOUT;
  wire  [3:0] MPMCDQMOUT;
  wire  [3:0] nMPMCBLSOUT;
  wire        MPMCTESTIN;
  wire        MPMCSREFACK;
  wire [31:0] MPMCDATAIN;
  wire [31:0] MPMCDATAOUT;
  wire [27:0] MPMCADDROUT;
  wire  [3:0] nMPMCDATAEN;
  wire        nMPMCRASOUT;
  wire        nMPMCCASOUT;
  wire        nMPMCOEOUT;
  wire        nMPMCWEOUT;
  wire        nMPMCRPOUT;
  wire        MPMCRPVHHOUT;
  wire        MPMCSREFREQ;
  wire        MPMCREL1CONFIG;
  wire        MPMCSTCS1PB;
  wire  [3:0] nMPMCSTCSOUT;
  wire  [3:0] nMPMCDYCSOUT;

// EBI related signals
  wire        MPMCEBIREQ;
  wire        MPMCEBIGNT;
  wire        MPMCEBIBACKOFF;

  reg         NxtMPMCEBIGNT;
// D-input for MPMCEBIGNT

  wire        NxtMPMCEBIBACKOFF;
// D-input for MPMCEBIBACKOFF

reg           iMPMCEBIGNT;
// Clked version of MPMCEBIGNT

reg           iMPMCEBIBACKOFF;
// Clked version of MPMCEBIBACKOFF

reg  [1:0] Cntr;
reg  [1:0] NxtCntr;
wire   CntFlag;

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------
initial
begin
  HSELMPMC0G  = 1'b0;
  HSELMPMC0CS = 8'h00;
  HSELMPMC1G  = 1'b0;
  HSELMPMC1CS = 8'h00;
  HSELMPMC2G  = 1'b0;
  HSELMPMC2CS = 8'h00;
  HSELMPMC3G  = 1'b0;
  HSELMPMC3CS = 8'h00;
  HADDRarm    = 32'h00000000;
  HBURSTarm   = 3'b000;
  HPROTarm    = 4'h0;
  HWRITEarm   = 1'b0;
  HWDATAarm   = 32'h00000000;
  HTRANSarm   = 2'b00;
  HSIZEarm    = 3'b000;
end
// -----------------------------------------------------------------------------
// Memory Data Bus multiplexing
// -----------------------------------------------------------------------------
assign XD[7:0]          = (nMPMCDATAEN[0] == 1'b0) ? MPMCDATAOUT[7:0]   :
                           8'bzzzzzzzz;

assign XD[15:8]         = (nMPMCDATAEN[1] == 1'b0) ? MPMCDATAOUT[15:8]  :
                           8'bzzzzzzzz;

assign XD[23:16]        = (nMPMCDATAEN[2] == 1'b0) ? MPMCDATAOUT[23:16] :
                           8'bzzzzzzzz;

assign XD[31:24]        = (nMPMCDATAEN[3] == 1'b0) ? MPMCDATAOUT[31:24] :
                           8'bzzzzzzzz;

assign MPMCDATAIN       = (XD !== 32'hzzzzzzzz) ? XD : 32'h00000000;

// -----------------------------------------------------------------------------
// Drive the AHB clock with the external clock input.
// -----------------------------------------------------------------------------
assign TESTACK          = iTESTACK;
assign HCLK             = XCLKIN;

assign nPOR             = nReset;

// -----------------------------------------------------------------------------
// OR connection of split input to the Arbiter.
// -----------------------------------------------------------------------------
assign HSPLIT           = HSPLIT001 | HSPLIT002 | HSPLIT003 | HSPLIT004;

// -----------------------------------------------------------------------------
// Enable the TEST Interface and connect the Test mode signals
// -----------------------------------------------------------------------------
assign MPMCTESTIN       = 1'b1;
assign iTESTACK         = nMPMCWEOUT;

// -----------------------------------------------------------------------------
// Unconnected Arbiter inputs driven LOW
// -----------------------------------------------------------------------------
assign HBUSREQ003       = 1'b0;
assign HBUSREQ004       = 1'b0;

assign HWDATASlave      = {32'h00000000, HWDATA};

assign HLOCK003         = 1'b0;
assign HLOCK004         = 1'b0;

assign HSPLIT002        = 16'h0000;
assign HSPLIT003        = 16'h0000;
assign HSPLIT004        = 16'h0000;

assign SCANENABLE       = 1'b0;
assign SCANINHCLK       = 1'b0;
assign SCANINMPMCCLK    = 4'h0;
assign SCANINFBCLKIN0   = 1'b0;
assign SCANINFBCLKIN1   = 1'b0;
assign SCANINFBCLKIN2   = 1'b0;
assign SCANINFBCLKIN3   = 1'b0;

assign HRDATAExtMem     = HRDATA0;
assign HREADYExtMem     = HREADYOUT0;
assign HRESPExtMem      = HRESP0;

// -----------------------------------------------------------------------------
// Split the HSELUUT range for MPMC and AHBSlave
// -----------------------------------------------------------------------------
always @(HSELUUT or HADDR)
begin : p_AddrDecodeComb
  HSELMPMCREG  = 1'b0;
  HSELAHBSLAVE = 1'b0;

  if (HSELUUT == 1'b1)
    if (HADDR[28] == 1'b0)
      HSELAHBSLAVE = 1'b1;                  // AHBSlave
    else
      HSELMPMCREG  = 1'b1;                  // AHB UUT
  else
    begin
      HSELAHBSLAVE = 1'b0;
      HSELMPMCREG  = 1'b0;
    end
end // p_AddrDecodeComb

assign IntHSEL          = {HSELMPMCREG, HSELAHBSLAVE};

always @(negedge HRESETn or posedge HCLK)
begin : p_DelHSELSeq
  if (HRESETn == 1'b0)
    DelHSEL <= 2'b00;
  else if (HREADY == 1'b1)
    DelHSEL <= IntHSEL;
end // p_DelHSELSeq

always @(DelHSEL or HRDATAAHBSLV or HRESPAHBSLV or HREADYOUTAHBSLV or
                      HRDATAREG or HRESPREG or HREADYOUTREG)
begin : p_RespComb
  case (DelHSEL)
    2'b01   :
      begin
        HRDATAUUT = HRDATAAHBSLV[31:0];
        HRESPUUT  = HRESPAHBSLV;
        HREADYUUT = HREADYOUTAHBSLV;
      end

    2'b10   :
      begin
        HRDATAUUT = {11'b00000000000, HRDATAREG[20:0]};
        HRESPUUT  = HRESPREG;
        HREADYUUT = HREADYOUTREG;
      end

    default :
      begin
        HRDATAUUT = 32'h00000000;
        HRESPUUT  = 2'b00;
        HREADYUUT = 1'b1;
      end
  endcase
end // p_RespComb

// -----------------------------------------------------------------------------
// Assign uut HWDATA
// -----------------------------------------------------------------------------
assign HWDATAREG15TO0   = HWDATA[15:0];
assign HWDATAREG20TO19  = HWDATA[20:19];

// -----------------------------------------------------------------------------
// EBIGNT generator
// -----------------------------------------------------------------------------
always @(MPMCEBIREQ)
begin : p_EbiGntGenComb
  if (MPMCEBIREQ == 1'b1)
    NxtMPMCEBIGNT = 1'b1;
  else
    NxtMPMCEBIGNT = 1'b0;
end //p_EbiGntGenComb

// -----------------------------------------------------------------------------
// Generating the EBIBACKOFF signal
// -----------------------------------------------------------------------------

always @(iMPMCEBIGNT or CntFlag or Cntr)
begin : p_BACKOFFCNTR
  NxtCntr = Cntr;
  if (iMPMCEBIGNT == 1'b0)
    NxtCntr = 2'b11;
  else if (CntFlag != 1'b1)
    NxtCntr = Cntr - 1;
end
// -----------------------------------------------------------------------------
// Counter which assists to raise the BackOff signal
// -----------------------------------------------------------------------------

always @(posedge HCLK or negedge HRESETn)
begin : p_CNTRSeq
  if (HRESETn == 1'b0)
    Cntr = 2'b11;
  else
    Cntr = NxtCntr;
end
// -----------------------------------------------------------------------------
// Flag to indicate the assertion of the BackOff signal
// -----------------------------------------------------------------------------
assign CntFlag = (Cntr == 2'b00) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Assertion of BackOff signal
// -----------------------------------------------------------------------------

always @(CntFlag or iMPMCEBIGNT)
begin : p_BackOffGen
  if(iMPMCEBIGNT == 1'b0)
    iMPMCEBIBACKOFF = 1'b0;
  else if (CntFlag == 1'b1)
    iMPMCEBIBACKOFF = 1'b1;
end

// -----------------------------------------------------------------------------
// Clking the GNT and BACKOFF signals
// -----------------------------------------------------------------------------
always @(negedge nPOR or posedge MPMCCLK)
begin : p_EbiGntSeq
  if (nPOR == 1'b0)
    begin
      iMPMCEBIGNT      <= 1'b1;
      iMPMCEBIBACKOFF  <= 1'b0;
    end
  else
    begin
      iMPMCEBIGNT      <= NxtMPMCEBIGNT;
    end
end //p_EbiGntSeq

assign MPMCEBIGNT      = iMPMCEBIGNT;
assign MPMCEBIBACKOFF  = iMPMCEBIBACKOFF;
assign MPMCCLK = HCLK;
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
                    .HBUSREQtic       (HBUSREQTIC),
                    .HBUSREQ003       (HBUSREQ003),
                    .HBUSREQ004       (HBUSREQ004),

                    .HLOCKarm         (HLOCKarm),
                    .HLOCKtic         (HLOCKTIC),
                    .HLOCK003         (HLOCK003),
                    .HLOCK004         (HLOCK004),

                    .HSPLIT           (HSPLIT),

                    .Pause            (Pause),

                    .HGRANTarm        (HGRANTarm),
                    .HGRANTtic        (HGRANTTIC),
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

                    .HADDRtic         (HADDRTIC),
                    .HTRANStic        (HTRANSTIC),
                    .HWRITEtic        (HWRITETIC),
                    .HSIZEtic         (HSIZETIC),
                    .HBURSTtic        (HBURSTTIC),
                    .HPROTtic         (HPROTTIC),
                    .HWDATAtic        (HWDATATIC),

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
AhbSlave uAhbSlave                    (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HWDATA           (HWDATASlave),
                    .HRDATAIn         (HRDATAAHBSLV),
                    .HREADYIn         (HREADY),
                    .HSPLITIn         (HSPLIT),
                    .HSEL             (HSELAHBSLAVE),
                    .HMASTER          (HMASTER),
                    .HMASTLOCK        (HMASTLOCK),
                    .HRESPIn          (HRESP),
                    .HRDATAdly        (HRDATAAHBSLV),
                    .HREADYdly        (HREADYOUTAHBSLV),
                    .HRESPdly         (HRESPAHBSLV),
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
// MPMC and the TIC Module Instantiation
// -----------------------------------------------------------------------------
Mpmc uut                              (
                    .HCLK             (HCLK),
                    .MPMCCLK          (MPMCCLK),
                    .MPMCCLKDELAY     (MPMCCLKDELAY),
                    .HRESETn          (HRESETn),
                    .nPOR             (nPOR),
                    .MPMCFBCLKIN0     (MPMCFBCLKIN0),
                    .MPMCFBCLKIN1     (MPMCFBCLKIN1),
                    .MPMCFBCLKIN2     (MPMCFBCLKIN2),
                    .MPMCFBCLKIN3     (MPMCFBCLKIN3),
                    .HWRITE0          (HWRITE0),
                    .HTRANS0          (HTRANS0),
                    .HSIZE0           (HSIZE0),
                    .HBURST0          (HBURST0),
                    .HREADYIN0        (HREADYIN0),
                    .HSELMPMC0G       (HSELMPMC0G),
                    .HSELMPMC0CS      (HSELMPMC0CS),
                    .HMASTLOCK0       (HMASTLOCK0),
                    .HADDR0           (HADDR0),
                    .HWDATA0          (HWDATA0),
                    .HWRITE1          (HWRITE1),
                    .HTRANS1          (HTRANS1),
                    .HSIZE1           (HSIZE1),
                    .HBURST1          (HBURST1),
                    .HREADYIN1        (HREADYIN1),
                    .HSELMPMC1G       (HSELMPMC1G),
                    .HSELMPMC1CS      (HSELMPMC1CS),
                    .HMASTLOCK1       (HMASTLOCK1),
                    .HADDR1           (HADDR1),
                    .HWDATA1          (HWDATA1),
                    .HWRITE2          (HWRITE2),
                    .HTRANS2          (HTRANS2),
                    .HSIZE2           (HSIZE2),
                    .HBURST2          (HBURST2),
                    .HREADYIN2        (HREADYIN2),
                    .HSELMPMC2G       (HSELMPMC2G),
                    .HSELMPMC2CS      (HSELMPMC2CS),
                    .HMASTLOCK2       (HMASTLOCK2),
                    .HADDR2           (HADDR2),
                    .HWDATA2          (HWDATA2),
                    .HWRITE3          (HWRITE3),
                    .HTRANS3          (HTRANS3),
                    .HSIZE3           (HSIZE3),
                    .HBURST3          (HBURST3),
                    .HREADYIN3        (HREADYIN3),
                    .HSELMPMC3G       (HSELMPMC3G),
                    .HSELMPMC3CS      (HSELMPMC3CS),
                    .HMASTLOCK3       (HMASTLOCK3),
                    .HADDR3           (HADDR3),
                    .HWDATA3          (HWDATA3),
                    .HWRITEREG        (HWRITE),
                    .HTRANSREG        (HTRANS[1]),
                    .HSIZEREG         (HSIZE),
                    .HREADYINREG      (HREADY),
                    .HSELMPMCREG      (HSELMPMCREG),
                    .HADDRREG         (HADDR[11:2]),
                    .HWDATAREG15TO0   (HWDATAREG15TO0),
                    .HWDATAREG20TO19  (HWDATAREG20TO19), 
                    .HRDATATIC        (HRDATA),
                    .HREADYINTIC      (HREADY),
                    .HGRANTTIC        (HGRANTTIC),
                    .HRESPTIC         (HRESP),
                    .MPMCTESTIN       (MPMCTESTIN),
                    .MPMCDATAIN       (MPMCDATAIN),
                    .MPMCSREFREQ      (MPMCSREFREQ),
                    .MPMCBIGENDIAN    (MPMCBIGENDIAN),
                    .MPMCSTCS1MW      (MPMCSTCS1MW),
                    .MPMCSTCS0POL     (MPMCSTCS0POL),
                    .MPMCSTCS1POL     (MPMCSTCS1POL),
                    .MPMCSTCS2POL     (MPMCSTCS2POL),
                    .MPMCSTCS3POL     (MPMCSTCS3POL),
                    .MPMCSTCS1PB      (MPMCSTCS1PB),
                    .MPMCREL1CONFIG   (MPMCREL1CONFIG),
                    .MPMCTESTREQA     (TESTREQA),
                    .MPMCTESTREQB     (TESTREQB),
                    .SCANINHCLK       (SCANINHCLK),
                    .SCANINMPMCCLK    (SCANINMPMCCLK),
                    .SCANINCLKDELAY   (SCANINCLKDELAY),
                    .SCANINFBCLKIN0   (SCANINFBCLKIN0),
                    .SCANINFBCLKIN1   (SCANINFBCLKIN1),
                    .SCANINFBCLKIN2   (SCANINFBCLKIN2),
                    .SCANINFBCLKIN3   (SCANINFBCLKIN3),
                    .SCANENABLE       (SCANENABLE),

                    .HREADYOUT0       (HREADYOUT0),
                    .HRESP0           (HRESP0),
                    .HRDATA0          (HRDATA0),
                    .HREADYOUT1       (HREADYOUT1),
                    .HRESP1           (HRESP1),
                    .HRDATA1          (HRDATA1),
                    .HREADYOUT2       (HREADYOUT2),
                    .HRESP2           (HRESP2),
                    .HRDATA2          (HRDATA2),
                    .HREADYOUT3       (HREADYOUT3),
                    .HRESP3           (HRESP3),
                    .HRDATA3          (HRDATA3),
                    .HREADYOUTREG     (HREADYOUTREG),
                    .HRESPREG         (HRESPREG),
                    .HRDATAREG        (HRDATAREG),
                    .HWRITETIC        (HWRITETIC),
                    .HTRANSTIC        (HTRANSTIC),
                    .HSIZETIC         (HSIZETIC),
                    .HBURSTTIC        (HBURSTTIC),
                    .HLOCKTIC         (HLOCKTIC),
                    .HPROTTIC         (HPROTTIC),
                    .HBUSREQTIC       (HBUSREQTIC),
                    .HADDRTIC         (HADDRTIC),
                    .HWDATATIC        (HWDATATIC),
                    .MPMCCLKOUT       (MPMCCLKOUT),
                    .MPMCCKEOUT       (MPMCCKEOUT),
                    .MPMCDQMOUT       (MPMCDQMOUT),
                    .nMPMCBLSOUT      (nMPMCBLSOUT),
                    .nMPMCRASOUT      (nMPMCRASOUT),
                    .nMPMCCASOUT      (nMPMCCASOUT),
                    .nMPMCOEOUT       (nMPMCOEOUT),
                    .nMPMCWEOUT       (nMPMCWEOUT),
                    .nMPMCSTCSOUT     (nMPMCSTCSOUT),
                    .nMPMCDYCSOUT     (nMPMCDYCSOUT),
                    .MPMCADDROUT      (MPMCADDROUT),
                    .MPMCDATAOUT      (MPMCDATAOUT),
                    .nMPMCRPOUT       (nMPMCRPOUT),
                    .MPMCRPVHHOUT     (MPMCRPVHHOUT),
                    .nMPMCDATAEN      (nMPMCDATAEN),
                    .MPMCSREFACK      (MPMCSREFACK),
                    .MPMCEBIREQ       (MPMCEBIREQ),
                    .MPMCEBIGNT       (MPMCEBIGNT),
                    .MPMCEBIBACKOFF   (MPMCEBIBACKOFF),
                    .SCANOUTHCLK      (SCANOUTHCLK),
                    .SCANOUTMPMCCLK   (SCANOUTMPMCCLK),
                    .SCANOUTCLKDELAY  (SCANOUTCLKDELAY),
                    .SCANOUTFBCLKIN0  (SCANOUTFBCLKIN0),
                    .SCANOUTFBCLKIN1  (SCANOUTFBCLKIN1),
                    .SCANOUTFBCLKIN2  (SCANOUTFBCLKIN2),
                    .SCANOUTFBCLKIN3  (SCANOUTFBCLKIN3)
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

                    .HADDRTIC         (HADDRTIC),
                    .HWRITETIC        (HWRITETIC),
                    .HTRANSTIC        (HTRANSTIC),
                    .HSIZETIC         (HSIZETIC),
                    .HBURSTTIC        (HBURSTTIC),
                    .HPROTTIC         (HPROTTIC),
                    .HWDATATIC        (HWDATATIC)
                    );

// -----------------------------------------------------------------------------
// AHB Master Watcher Instantiation
// -----------------------------------------------------------------------------
buswatchmaster ubuswatchmaster        (
// Inputs
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HTRANS           (HTRANS),
                    .HADDR            (HADDR),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HBUSREQx         (HBUSREQTIC),
                    .HGRANTx          (HGRANTTIC),
                    .HREADY           (HREADY),
                    .HLOCKx           (HLOCKTIC),
                    .HWDATA           (HWDATASlave),
                    .HPROT            (HPROT),
                    .HWRITE           (HWRITE),
                    .HRESP            (HRESP),
// Outputs
                    .ResetOver        ()
                    );

endmodule

// --================================== End ==================================--
