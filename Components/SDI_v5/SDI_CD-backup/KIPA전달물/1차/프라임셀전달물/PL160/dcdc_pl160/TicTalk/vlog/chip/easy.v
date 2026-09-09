// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1999 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : easy.v,v
// File Revision       : 1.2
// 
// Release Information : PL160-REL1v1
// 
// ----------------------------------------------------------------------------
// Purpose             : Structural architecture of Example Amba SYstem (easy)
// --=========================================================================--

`timescale 1ns/1ps

module easy (
// External Inputs
        XCLKIN,
        XnGBE,
        Reset,
        XWAIT,

// External Inout
        XD,
      
// External Outputs
        XA,
        XCLK,
        XCSN,
        XOEN,
        XWEN,

// Test signals
        TREQA,
        TREQB,
        TACK,

// Reference Clock
        REFXTAL,

// JTAG signals
        nTRST,
        TCK,
        TDI,
        TMS,
        TDO
        );

`uselib lib=chip lib=sys

// Inputs
input         XCLKIN;  // External clock in
input         REFXTAL; // External Reference clock in
input         XnGBE;   // External global bus enable
input         Reset;   // Power on reset input
input         XWAIT;   // External wait request

// Inouts
inout  [31:0] XD;      // External data bus
      
// Outputs
output [30:0] XA;      // External address bus
output        XCLK;    // External clock out
output  [7:0] XCSN;    // External chip select
output        XOEN;    // External output enable
output  [3:0] XWEN;    // External write enable

// Test signals
input         TREQA;   // Test bus request A
input         TREQB;   // Test bus request B
output        TACK;    // Test acknowledge

// JTAG signals
input         nTRST;   // JTAG connections
input         TCK;
input         TDI;
input         TMS;
output        TDO;


//-----------------------------------------------------------------------------
// Signal declarations
//-----------------------------------------------------------------------------

//--------------------------------------
// Arbiter Signals
//--------------------------------------
wire        AGNTarm;
wire        AGNT001;
wire        AGNT002;
wire        AGNTtic;
wire        AREQarm;
wire        AREQ001;
wire        AREQ002;
wire        AREQtic;
  
//--------------------------------------
// ASB Signals
//--------------------------------------
wire        BCLK;
wire        BERROR;
wire        BLAST;
wire        BnRES;
wire        BWAIT;

wire [31:0] BA;
wire [31:0] BD;

wire  [1:0] BTRAN;
wire        BLOK;
wire  [1:0] BPROT;
wire  [1:0] BSIZE;
wire        BWRITE;

//--------------------------------------
//  Decoder Signals
//--------------------------------------
wire        DSELExtMem;
wire        DSELIntMem;
wire        DSELARMTest;
wire        DSELPeri;
  
//--------------------------------------
// Example System Signals
//--------------------------------------
wire        COMMTX;
wire        COMMRX;
wire        ARMNFIQ;
wire        ARMNIRQ;

wire        TestMode;
wire        TicoutLen;
wire        Ticouten;
wire        Ticinen;

wire        Pause;
wire        Remap;

//--------------------------------------
// APB Signals
//--------------------------------------
wire [31:0] PRDATA;
wire [31:0] PWDATA;
wire [31:0] PADDR;
wire        PWRITE;
wire        PENABLE;
wire        PSELRPC;
wire        PSELCT;
wire        PSELIC;

wire        REFCLK;

assign REFCLK = REFXTAL;

// The APB bridge
apbif u_apbif (
        .BCLK       (BCLK),
        .BnRES      (BnRES),
        .BA         (BA),
        .BWRITE     (BWRITE),
        .DSELPeri   (DSELPeri),
        .BD         (BD),
        .BWAIT      (BWAIT),
        .BERROR     (BERROR),
        .BLAST      (BLAST),
        .PRDATA     (PRDATA),
        .PWDATA     (PWDATA), 
        .PENABLE    (PENABLE),
        .PSELUUT    (PSELUUT), // UUT
        .PSELIC     (PSELIC),  // Interrupt Controller
        .PSELCT     (PSELCT),  // Counter Timer, not used
        .PSELRPC    (PSELRPC), // Remap and Pause
        .PADDR      (PADDR),
        .PWRITE     (PWRITE)
        );

// The ASB master arbiter
arbiter u_arbiter (
        .BCLK       (BCLK),
        .BnRES      (BnRES),
        .BWAIT      (BWAIT),
        .BLOK       (BLOK),
        .AREQarm    (AREQarm), // ARM request
        .AREQtic    (AREQtic), // Test Interface Controller request
        .AREQ001    (AREQ001), // ASB master 001 request
        .AREQ002    (AREQ002), // ASB master 002 request
        .Pause      (Pause),   // Pause mode entered
        .AGNTarm    (AGNTarm), // Grant ARM
        .AGNTtic    (AGNTtic), // Grant Test Interface Controller
        .AGNT001    (AGNT001), // Grant ASB master 001
        .AGNT002    (AGNT002)  // Grant ASB master 002
        );

assign AREQarm = 1'b0;

// Example request lines available for new bus master design
assign AREQ001 = 1'b0;
assign AREQ002 = 1'b0;

// The ASB decoder with/without decode cycles
decoder u_decoder (
        .BCLK        (BCLK),
        .BnRES       (BnRES),
        .BSIZE       (BSIZE),
        .BTRAN       (BTRAN),
        .BA          (BA),
        .Remap       (Remap),
        .BWAIT       (BWAIT),
        .BERROR      (BERROR),
        .BLAST       (BLAST),
        .DSELARMTest (DSELARMTest), // Internal memory
        .DSELIntMem  (DSELIntMem),  // External memory
        .DSELExtMem  (DSELExtMem),  // Peripheral bus
        .DSELPeri    (DSELPeri)     // ARM Test
        );  

// On-chip clock driver
pll u_pll (
        .XCLKIN      (XCLKIN),
        .BCLK        (BCLK)
        );

// The bus reset controller
res_cntl u_res_cntl (
        .BCLK        (BCLK),
        .POReset     (Reset), 
        .BnRES       (BnRES)
        );

// The AMBA peripheral bus bridge, interrupt controller, reset controller and
// free running counter.
rps u_rps (
        .BCLK        (BCLK),
        .BnRES       (BnRES),
        .Pause       (Pause),
        .Remap       (Remap),
        .PENABLE     (PENABLE),
        .PSELIC      (PSELIC),
        .PSELUUT     (PSELUUT),
        .PSELRPC     (PSELRPC),
        .PADDR       (PADDR[15:0]),
        .PWRITE      (PWRITE),
        .PWDATA      (PWDATA),
        .PRDATA      (PRDATA),
        .REFCLK      (REFCLK) 
        );

// An example External Bus Interface
smi u_smi ( 
        .BCLK        (BCLK),
        .BnRES       (BnRES),
        .BA          (BA[30:0]),
        .BWRITE      (BWRITE),
        .BSIZE       (BSIZE),
        .DSELExtMem  (DSELExtMem),
        .Remap       (Remap),   
        .BD          (BD),
        .BWAIT       (BWAIT),
        .BLAST       (BLAST),
        .BERROR      (BERROR),

        .TestMode    (TestMode),   // Overide normal operation
        .Ticinen     (Ticinen),    // Drive in write data
        .Ticouten    (Ticouten),   // Latch read data
        .TicoutLen   (TicoutLen),  // Drive out read data
             
        .XWAIT       (XWAIT),      // External wait request
        .XnGBE       (XnGBE),      // External global bus enable
        .XD          (XD),         // External data bus
        .XA          (XA),         // External address bus
        .XCLK        (XCLK),       // External clock out
        .XCSN        (XCSN),       // External chip select
        .XWEN        (XWEN),       // External output enable
        .XOEN        (XOEN)        // External write enable
        );

// The test interface controller
tic u_tic (
        .BCLK        (BCLK),
        .BnRES       (BnRES),
        .BWAIT       (BWAIT),
        .BERROR      (BERROR),
        .BLAST       (BLAST),
        .BD          (BD),
        .AGNTtic     (AGNTtic),
        .AREQtic     (AREQtic),
        .BSIZE       (BSIZE),
        .BTRAN       (BTRAN),
        .BLOK        (BLOK),
        .BPROT       (BPROT),
        .BA          (BA),
        .BWRITE      (BWRITE),

        .TREQA       (TREQA),     // Test bus request A
        .TREQB       (TREQB),     // Test bus request B
        .TACK        (TACK),      // Test acknowledge
        .TestMode    (TestMode),  // Overide normal operation
        .Ticinen     (Ticinen),   // Drive in write data
        .Ticouten    (Ticouten),  // Latch read data
        .TicoutLen   (TicoutLen)  // Drive out read data
        );

// AMBA buswatcher
buswatch u_buswatch (
        .BCLK        (BCLK),
        .BnRES       (BnRES),
        .BLOK        (BLOK),
        .BPROT       (BPROT),
        .BSIZE       (BSIZE),
        .BTRAN       (BTRAN),
        .BWAIT       (BWAIT),
        .BERROR      (BERROR),
        .BLAST       (BLAST),
        .BWRITE      (BWRITE),
        .BA          (BA),
        .BD          (BD)
        );

endmodule

// --================================ End ====================================--
