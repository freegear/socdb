// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2002 ARM Limited
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
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
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
             XD,

// Outputs
             XA,
             XCSN,
             XOEN,
             XWEN,
             TESTACK,
             TDO
            );

`uselib lib=chip lib=sys lib=uut

// Inputs
input         XCLKIN;          // External clock in
input         nReset;          // Power on reset input
input         TESTREQA;        // Test bus request A
input         TESTREQB;        // Test bus request B
input         nTRST;           // JTAG connections
input         TCK;             // JTAG connections
input         TDI;             // JTAG connections
input         TMS;             // JTAG connections

// Inout
inout  [31:0] XD;              // External data bus

// Outputs
output [30:0] XA;              // External address bus
output  [3:0] XCSN;            // External chip select
output        XOEN;            // External output enable
output  [3:0] XWEN;            // External write enable
output        TESTACK;         // Test acknowledge
output        TDO;             // JTAG connections

// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// AHB Signals
// -----------------------------------------------------------------------------
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
wire [31:0] HRDATAIntMem;
wire        HREADYIntMem;
wire  [1:0] HRESPIntMem;

wire        HSELExtMem;
wire [31:0] HRDATAExtMem;
wire        HREADYExtMem;
wire  [1:0] HRESPExtMem;

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
wire [31:0] HADDRarm = 32'h0000_0000;
wire  [1:0] HTRANSarm = 2'b00;
wire        HWRITEarm = 1'b0;
wire  [2:0] HSIZEarm = 3'b000;
wire  [2:0] HBURSTarm = 3'b000;
wire  [3:0] HPROTarm = 4'b0000;
wire [31:0] HWDATAarm = 32'h0000_0000;
wire        HBUSREQarm = 1'b0;
wire        HLOCKarm = 1'b0;
wire        HGRANTarm;

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

// -----------------------------------------------------------------------------
// APB Signals
// -----------------------------------------------------------------------------
wire        PENABLE;
wire        PSELIC;
wire        PSELUUT;
wire        PSELRPC;
wire [31:0] PADDR;
wire        PWRITE;
wire [31:0] PRDATA;
wire [31:0] PWDATA;

// -----------------------------------------------------------------------------
// Example System Signals
// -----------------------------------------------------------------------------
wire        Remap;
wire        Pause;

wire        TicRead;

wire        nTDOEN;

// -----------------------------------------------------------------------------
// Vectored Interrupt Controller Signals
// -----------------------------------------------------------------------------
wire        SCANENABLE;
wire        SCANINHCLK;
wire        SCANOUTHCLK;
wire        nVICFIQIN;
wire        nVICIRQIN;
wire        nVICFIQ;
wire        nVICIRQ;
wire        nVICSYNCEN;
wire        VICIRQACK;
wire [31:0] VICINTSOURCE;
wire [31:0] VICVECTADDRIN;
wire [31:0] VICVECTADDROUT;
wire        VICFIQINREG;
wire        VICIRQINREG;
wire        VICVECTADDRV;
wire        VICIRQACKOUT;
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// Drive the AHB clock with the external clock input.

assign HCLK             = XCLKIN;

// OR connection of split input to the Arbiter.

assign HSPLIT           = (HSPLIT001 |
                           HSPLIT002 |
                           HSPLIT003 |
                           HSPLIT004);

// Unconnected Arbiter inputs driven LOW

assign HBUSREQ003       = 1'b0;
assign HBUSREQ004       = 1'b0;

assign HLOCK003         = 1'b0;
assign HLOCK004         = 1'b0;

assign HSPLIT001        = 16'h0000;
assign HSPLIT002        = 16'h0000;
assign HSPLIT003        = 16'h0000;
assign HSPLIT004        = 16'h0000;

assign SCANENABLE       = 1'b0;
assign SCANINHCLK       = 1'b0;
assign VICVECTADDRIN    = 32'h0000_0000;
assign nVICFIQIN        = 1'b1;
assign nVICIRQIN        = 1'b1;
assign nVICSYNCEN        = 1'b1;
assign VICIRQACK         = 1'b0;
// -----------------------------------------------------------------------------
// The AHB to APB bridge
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
                    .PSELIC           (PSELIC),  // APB Interrupt
                                                 // Controller
                    .PSELUUT          (PSELUUT), // APB UUT
                    .PSELRPC          (PSELRPC), // Remap and Pause
                    .PADDR            (PADDR),
                    .PWRITE           (PWRITE)
                    );

// -----------------------------------------------------------------------------
// The AHB system arbiter
// -----------------------------------------------------------------------------
Arbiter uArbiter                      (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HTRANS           (HTRANS),
                    .HBURST           (HBURST),
                    .HREADY           (HREADY),
                    .HRESP            (HRESP),

                    .HBUSREQarm       (HBUSREQarm), // Master bus
                                                    // request inputs
                    .HBUSREQtic       (HBUSREQtic),
                    .HBUSREQ003       (HBUSREQ003),
                    .HBUSREQ004       (HBUSREQ004),

                    .HLOCKarm         (HLOCKarm), // Master bus lock
                                                  // request inputs
                    .HLOCKtic         (HLOCKtic),
                    .HLOCK003         (HLOCK003),
                    .HLOCK004         (HLOCK004),

                    .HSPLIT           (HSPLIT), // Slave split inputs

                    .Pause            (Pause), // Pause mode entered

                    .HGRANTarm        (HGRANTarm), // Master bus grant
                                                   // outputs
                    .HGRANTtic        (HGRANTtic),
                    .HGRANT003        (HGRANT003),
                    .HGRANT004        (HGRANT004),

                    .HMASTER          (HMASTER),  // Current bus master
                    .HMASTLOCK        (HMASTLOCK) // Indicates locked
                                                  // sequence of
                                                  // transfers
                    );

// -----------------------------------------------------------------------------
// The system address Decoder
// -----------------------------------------------------------------------------
Decoder uDecoder                      (
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR),

                    .Remap            (Remap),

                    .HSELIntMem       (HSELIntMem),  // Internal Memory
                    .HSELExtMem       (HSELExtMem),  // External Memory
                    .HSELUUT          (HSELUUT),     // AHB UUT
                    .HSELAPBif        (HSELAPBif),   // APB Peripherals
                    .HSELArmTest      (HSELArmTest), // ARM Test
                    .HSELDefault      (HSELDefault)  // Default Slave
                    );

// -----------------------------------------------------------------------------
// The Default Slave is selected when no other slaves are accessed
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
// Central multiplexer - masters to slaves
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
// Central multiplexer - slaves to masters
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
// The bus reset controller
// -----------------------------------------------------------------------------
ResCntl uResCntl                      (
                    .HCLK             (HCLK),
                    .POReset          (nReset), // Power on reset input
                    .HRESETn          (HRESETn)
                    );

// -----------------------------------------------------------------------------
// Instantiation of the AHB UUT
// -----------------------------------------------------------------------------
Vic  uut                              (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HSELVIC          (HSELUUT),
                    .HADDR            (HADDR[11:2]),
                    .HWRITE           (HWRITE),
                    .HREADYIN         (HREADY),
                    .HPROT            (HPROT),
                    .HTRANS           (HTRANS),
                    .HSIZE            (HSIZE),
                    .HWDATA           (HWDATA[31:0]),
                    .VICINTSOURCE     (VICINTSOURCE),
                    .nVICSYNCEN       (nVICSYNCEN),
                    .VICIRQACK        (VICIRQACK),
                    .nVICFIQIN        (nVICFIQIN),
                    .nVICIRQIN        (nVICIRQIN),
                    .VICVECTADDRIN    (VICVECTADDRIN),
                    .VICFIQINREG      (VICFIQINREG),
                    .VICIRQINREG      (VICIRQINREG),
                    .SCANENABLE       (SCANENABLE),
                    .SCANINHCLK       (SCANINHCLK),
                    .HREADYOUT        (HREADYUUT),
                    .HRESP            (HRESP),
                    .HRDATA           (HRDATA[31:0]),
                    .nVICFIQ          (nVICFIQ),
                    .nVICIRQ          (nVICIRQ),
                    .VICVECTADDROUT   (VICVECTADDROUT),
                    .VICVECTADDRV     (VICVECTADDRV),
                    .VICIRQACKOUT     (VICIRQACKOUT),
                    .SCANOUTHCLK      (SCANOUTHCLK)
                    );

// -----------------------------------------------------------------------------
// Instantiation of the Trickbox
// -----------------------------------------------------------------------------
VicTrick uVicTrick                    (
                    .VICVECTADDROUT   (VICVECTADDROUT),
                    .VICIRQ           (nVICIRQ),
                    .VICFIQ           (nVICFIQ),
                    .VICIRQACK        (VICIRQACK),
                    .VICINTSOURCE     (VICINTSOURCE),
                    .VICFIQINREG      (VICFIQINREG),
                    .VICIRQINREG      (VICIRQINREG)
                    ); 
// -----------------------------------------------------------------------------
// The AMBA peripheral bus bridge, reset controller and
// the APB UUT.
// -----------------------------------------------------------------------------
RPS uRPS                              (
                    .PCLK             (HCLK),
                    .PRESETn          (HRESETn),
                    .Pause            (Pause),   // Pause mode entered
                    .Remap            (Remap),   // Reset memory map in
                                                 // use

                    .PENABLE          (PENABLE),
                    .PSELUUT          (PSELUUT), // APB UUT
                    .PSELRPC          (PSELRPC), // Remap and Pause
                    .PADDR            (PADDR),
                    .PWRITE           (PWRITE),
                    .PWDATA           (PWDATA),
                    .PRDATA           (PRDATA)
                    );

// -----------------------------------------------------------------------------
// An example External Bus Interface
// -----------------------------------------------------------------------------
SMI uSMI                              (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HWDATAin         (HWDATA),
                    .HSELExtMem       (HSELExtMem),
                    .HRDATAin         (HRDATA),
                    .HREADYin         (HREADY),

                    .HRDATAout        (HRDATAExtMem),
                    .HREADYout        (HREADYExtMem),
                    .HRESP            (HRESPExtMem),

                    .Remap            (Remap),   // Reset memory map
                                                 // in use
                    .TicRead          (TicRead), // Drive out read data
                    .XD               (XD), // External data bus

                    .XA               (XA),   // External address bus
                    .XCSN             (XCSN), // External chip select
                    .XWEN             (XWEN), // External output enable
                    .XOEN             (XOEN)  // External write enable
                    );

// -----------------------------------------------------------------------------
// The test interface controller
// -----------------------------------------------------------------------------
TIC uTIC                              (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HREADY           (HREADY),
                    .HRESP            (HRESP),
                    .HGRANTtic        (HGRANTtic),

                    .HADDR            (HADDRtic),
                    .HTRANS           (HTRANStic),
                    .HWRITE           (HWRITEtic),
                    .HSIZE            (HSIZEtic),
                    .HBURST           (HBURSTtic),
                    .HPROT            (HPROTtic),
                    .HWDATA           (HWDATAtic),
                    .HBUSREQtic       (HBUSREQtic),
                    .HLOCKtic         (HLOCKtic),

                    .TESTBUS          (XD), // External data bus

                    .TESTREQA         (TESTREQA), // Test bus request A
                    .TESTREQB         (TESTREQB), // Test bus request B

                    .TESTACK          (TESTACK), // Test acknowledge
                    .TicRead          (TicRead)  // Drive out read data
                    );

endmodule

// --================================== End ==================================--
