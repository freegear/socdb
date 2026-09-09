// --================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// --------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : tbench.v.rca 
// File Revision       : 1.4 
// 
// Release Information : PrimeCell(TM)-PL022-REL1v2 
// 
// ---------------------------------------------------------------------
// Purpose : Top level of the Ssp Compliance TestBench
//           This file instantiates the Ssp module, the Ssp trickbox
//           and the Read Data Mux.
//
// --=================================================================--

`timescale 1ns/1ps
`include "../tbench/timing.v"
`uselib lib=uut lib=trickbox

module tbench ();

// ---------------------------------------------------------------------
//
//                               tbench
//                               ======
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//  Top level testbench.This file integrates the Ssp, Ssp trickbox and
//  the APB interface modules to enable system level testing.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

// -----------------------------------------------------------------------------
// If the XonPSEL define is set to '0' (default), an 'X' appearing
// on the PSEL line will be converted to '0'. If this define is set
// to '1', the PSEL generated internally by the testbench is passed on
// unmodified.
// -----------------------------------------------------------------------------
`define XonPSEL 1'b0

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------      
wire        PCLK;
wire        PRESETn;
reg  [31:0] PADDR;
wire [31:0] I_PADDR;
wire        PWRITE;
wire        I_PWRITE;
wire        PENABLE;
wire        PSEL;
wire [31:0] PRDATA;
wire [31:0] PWDATA;
wire [31:0] VRG0; 
wire [31:0] VRG1; 
wire [31:0] VRG2; 
wire [31:0] VRG3; 
wire [31:0] VRG4; 
wire [31:0] VRG5; 
wire [31:0] VRG6; 
wire [31:0] VRG7; 
 
wire SSPCLK;
wire SSPTXD; 
wire SSPRXD;  
wire SFRM ;
wire SCLK;
wire nSSPOE;
wire SSPRXINTR;
wire SSPTXINTR;
wire SSPRORINTR;
wire SSPRTINTR;
wire SSPINTR;
wire SSPTXDMASREQ;
wire SSPTXDMABREQ;
wire SSPRXDMASREQ;
wire SSPRXDMABREQ;
wire SSPTXDMACLR;
wire SSPRXDMACLR;
wire SSPFSSOUT;
wire SSPCLKOUT;
wire nSSPCTLOE;
wire SCANIN;
wire SCANINPCLK;
wire SCANINSSPCLK;
wire SCANENABLE;
wire DUMMY;
 
 
wire SSPTXDpad;
wire SFRMpad;
wire SCLKpad; 

wire SFRMTrick;
wire SCLKTrick;
wire SSPTXDTrick;
 
wire SCANMODE;
wire nSSPRST;
 
wire PSELT;
wire I_PSEL;
wire I_PSELT;

wire [31:0] PRDATA1;
wire [31:0] PRDATA0;
wire [15:0] SspRdData;
wire [15:0] TrickRdData;

wire [31:0] ReadFill;
integer     i;

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Function declarations
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// Connect all the scan inputs to '0' to prevent interference with
// functional mode tests.
assign SCANINSSPCLK  = 1'b0;
assign SCANINPCLK    = 1'b0;
assign SCANENABLE    = 1'b0;

assign ReadFill      = 32'b00000000;

// -----------------------------------------------------------------------------
// Use XonPSEL to propagate X on the APB Bus signals.
// -----------------------------------------------------------------------------
assign PSELT  = (!(`XonPSEL) && I_PSELT === 1'bx) ? 1'b0 : I_PSELT;
assign PSEL   = (!(`XonPSEL) && I_PSEL === 1'bx)  ? 1'b0 : I_PSEL;
assign PWRITE = (!(`XonPSEL) && I_PWRITE === 1'bx)  ? 1'b0 : I_PWRITE;
 
always @(I_PADDR)
begin : p_PADDR
  for (i = 0; i < 32; i = i + 1)
    if ((`XonPSEL == 1'b0) && (I_PADDR[i] === 1'bx))
      PADDR[i] = 1'b0;
    else
      PADDR[i] = I_PADDR[i];
end // p_PADDR

// -----------------------------------------------------------------------------
// All the unconnected Virtual Register inputs should be set to zero:
// -----------------------------------------------------------------------------
assign VRG0[31:0] = 32'h00000000;
assign VRG1[31:0] = 32'h00000000;
assign VRG2[31:0] = 32'h00000000;
assign VRG3[31:0] = 32'h00000000;
assign VRG4[31:0] = 32'h00000000;
assign VRG5[31:0] = 32'h00000000;
assign VRG6[31:0] = 32'h00000000;
assign VRG7[31:0] = 32'h00000000;
 
// -----------------------------------------------------------------------------
// Connect setup parameters to the test bench module
// -----------------------------------------------------------------------------
 
//defparam u_apbslv_tb.PRDATA_mask = 32'hFFFFFFFF;
//defparam u_apbslv_tb.INFILE = "infile.bif";
//defparam u_apbslv_tb.Verbosity = 0;
//defparam u_apbslv_tb.HaltOnMismatch = 0;
//defparam u_apbslv_tb.tclks = `Tclks;
//defparam u_apbslv_tb.tclkl = `Tclkl;
//defparam u_apbslv_tb.tclkh = `Tclkh;
 
// -----------------------------------------------------------------------------
// Tri-state control of the SSP Master data and Frame lines
// -----------------------------------------------------------------------------
assign SSPTXDpad = (nSSPOE    == 1'b0) ? SSPTXD    : 1'bz;  
assign SFRMpad   = (nSSPCTLOE == 1'b0) ? SSPFSSOUT : 1'bz;
assign SCLKpad   = (nSSPCTLOE == 1'b0) ? SSPCLKOUT : 1'bz;

// -----------------------------------------------------------------------------
// Tri-state control of the SSP trickbox data line
// -----------------------------------------------------------------------------
assign SSPRXD = SSPTXDTrick;
 
// -----------------------------------------------------------------------------
// APB Slave testbench instantiation
// -----------------------------------------------------------------------------
APBSLAVE_TB u_apbslv_tb (
                        .PRESETn  (PRESETn),
                        .PCLK     (PCLK),
                        .PADDR    (I_PADDR),
                        .PWRITE   (I_PWRITE),
                        .PENABLE  (PENABLE),
                        .PSEL     (I_PSEL),
                        .PSELT    (I_PSELT),
                        .PWDATA   (PWDATA),
                        .PRDATA   (PRDATA),
                        .VRG0     (VRG0), 
                        .VRG1     (VRG1),
                        .VRG2     (VRG2),
                        .VRG3     (VRG3),
                        .VRG4     (VRG4),
                        .VRG5     (VRG5),
                        .VRG6     (VRG6),
                        .VRG7     (VRG7)
                       );
 
// -----------------------------------------------------------------------------
// Ssp instantiation
// -----------------------------------------------------------------------------

Ssp uut    (
// Inputs
            .PCLK             (PCLK),
            .SSPCLK           (PCLK),

            .PRESETn          (PRESETn),
            .nSSPRST          (nSSPRST),

            .PSEL             (PSEL),
            .PENABLE          (PENABLE),
            .PWRITE           (PWRITE),

            .SSPRXD           (SSPRXD),
            .SSPCLKIN         (SCLKTrick),
            .SSPFSSIN         (SFRMTrick),

            .SCANENABLE       (SCANENABLE),
            .SCANINPCLK       (SCANINPCLK),
            .SCANINSSPCLK     (SCANINSSPCLK),

            .PADDR            (PADDR[11:2]),

            .PWDATA           (PWDATA[15:0]),

            .SSPTXDMACLR      (SSPTXDMACLR),
            .SSPRXDMACLR      (SSPRXDMACLR),
// Outputs
            .SSPINTR          (SSPINTR),
            .SSPRXINTR        (SSPRXINTR),
            .SSPTXINTR        (SSPTXINTR),
            .SSPRORINTR       (SSPRORINTR),
            .SSPRTINTR        (SSPRTINTR),

            .SSPFSSOUT        (SSPFSSOUT),
            .SSPCLKOUT        (SSPCLKOUT),

            .SCANOUTPCLK      (DUMMY),
            .SCANOUTSSPCLK    (DUMMY),

            .SSPTXD           (SSPTXD),
            .nSSPOE           (nSSPOE),
            .nSSPCTLOE        (nSSPCTLOE),

            .PRDATA           (SspRdData),

            .SSPTXDMASREQ     (SSPTXDMASREQ),
            .SSPTXDMABREQ     (SSPTXDMABREQ),
            .SSPRXDMASREQ     (SSPRXDMASREQ),
            .SSPRXDMABREQ     (SSPRXDMABREQ)
            );

// -----------------------------------------------------------------------------
// Trickbox instantiation
// -----------------------------------------------------------------------------
SspTrick  u_SspTrick (
                     .PCLK         (PCLK),
                     .PRESETn      (PRESETn),
                     .PSELT        (PSELT),
                     .PENABLE      (PENABLE),
                     .PWRITE       (PWRITE),
                     .PADDR        (PADDR[7:2]),

                     .PWDATA       (PWDATA[15:0]),

                     .SSPRXD       (SSPTXDpad),
                     .SCLKIN       (SCLKpad),
                     .SCLKOUT      (SCLKTrick),
                     .SFRMIN       (SFRMpad),
                     .SFRMOUT      (SFRMTrick),
                     .SSPINTR      (SSPINTR),
                     .SSPRXINTR    (SSPRXINTR),
                     .SSPTXINTR    (SSPTXINTR),
                     .SSPRORINTR   (SSPRORINTR),
                     .SSPRTINTR    (SSPRTINTR),
                     .SSPTXDMASREQ (SSPTXDMASREQ),
                     .SSPTXDMABREQ (SSPTXDMABREQ),
                     .SSPRXDMASREQ (SSPRXDMASREQ),
                     .SSPRXDMABREQ (SSPRXDMABREQ),
                     .SCANMODE     (SCANMODE),
                     .nSSPRST      (nSSPRST),
                     .SSPCLK       (SSPCLK),
                     .SSPTXD       (SSPTXDTrick),
                     .SSPTXDMACLR  (SSPTXDMACLR),
                     .SSPRXDMACLR  (SSPRXDMACLR),      
                     .PRDATA       (TrickRdData)
                    );

assign PRDATA0 = {ReadFill[31:16], SspRdData};
assign PRDATA1 = {ReadFill[31:16], TrickRdData};

// -----------------------------------------------------------------------------
// APB Read Data mux 
// -----------------------------------------------------------------------------
apbmux  u_apbmux (
                 .PCLK      (PCLK),
                 .PRESETn   (PRESETn),
                 .PSEL      (PSEL),
                 .PSELT     (PSELT),
                 .PRData0   (PRDATA0),
                 .PRData1   (PRDATA1),
                 .PRData    (PRDATA)
                );
initial
begin
  $timeformat(-9, 0, " ns", 9);
end

// -----------------------------------------------------------------------------
// Include system task for best/worst case SDF delay annotation.
// -----------------------------------------------------------------------------
// include system task for best/worst case SDF delay annotation.
`ifdef NET_MAX
  initial
  begin
    $sdf_annotate("",uut,,,"MAXIMUM");
  end
  `endif
 
`ifdef NET_MIN
  initial
  begin
    $sdf_annotate("",uut,,,"MINIMUM");
  end
`endif

`ifdef NET_TYP
  initial
  begin
    $sdf_annotate("",uut,,,"TYPICAL");
  end
`endif

/*
initial
begin
  $dumpvars();
  $dumpfile("Sspnet.vcd");
end
*/

endmodule

// --================================= End ===================================--
