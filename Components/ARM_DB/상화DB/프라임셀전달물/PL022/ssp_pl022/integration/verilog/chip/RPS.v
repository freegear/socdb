// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : RPS.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL022-REL1v2
//
// ---------------------------------------------------------------------
// Purpose :
//           Structural architecture of Reference Peripherals:
//           Interrupt Controller, Remap and Pause Controller, and
//           Timers modules.
//
// --=================================================================--

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module RPS (
            PCLK,
            PRESETn,
            Pause,
            Remap,
            PENABLE,
            PSELUUT,
            PSELRPC,
            PADDR,
            PWRITE,
            PWDATA,
            PRDATA,
            SSPRXD,
            SSPCLKIN,
            SSPFSSIN,

            SSPTXD,
            SSPCLKOUT,
            SSPFSSOUT,
            nSSPCTLOE,
            nSSPOE
           );

`uselib lib=sys lib=uut

input         PCLK;
input         PRESETn;

output        Pause;   // Pause mode entered
output        Remap;   // Reset memory map in use

input         PENABLE;
input         PSELUUT; // Unit Under Test
input         PSELRPC; // Remap and Pause
input  [31:0] PADDR;
input         PWRITE;
input  [31:0] PWDATA;
output [31:0] PRDATA;

//SSP - Primary I/O Test Trickbox connections
input         SSPRXD;
input         SSPCLKIN;
input         SSPFSSIN;

output        SSPTXD;
output        SSPCLKOUT;
output        SSPFSSOUT;
output        nSSPCTLOE;
output        nSSPOE;

// ---------------------------------------------------------------------
// Constant defined for MCLK Period
// ---------------------------------------------------------------------
`define SSPCLK_PERIOD              100


// ---------------------------------------------------------------------
//  Signal declarations
// ---------------------------------------------------------------------
wire        nFIQInt = 1'b1;
wire        nIRQInt = 1'b1;
wire [31:0] PRDATAUUT;
wire [31:0] PRDATARPC;

// ---------------------------------------------------------------------
// Ssp Signals
// ---------------------------------------------------------------------

wire          SSPTXDMACLR;
wire          SSPRXDMACLR;
wire          SSPTXINTR;
wire          SSPRXINTR;
wire          SSPRORINTR;
wire          SSPRTINTR;
wire          SSPINTR;
wire          SSPTXDMASREQ;
wire          SSPTXDMABREQ;
wire          SSPRXDMASREQ;
wire          SSPRXDMABREQ;
wire          SCANENABLE;
wire          SCANINPCLK;
wire          SCANINSSPCLK;
wire          SCANOUTPCLK;
wire          SCANOUTSSPCLK;
  



// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg           SSPCLK;
reg           nSSPRST1;
reg           nSSPRST2;
reg           nSSPRST;

// ---------------------------------------------------------------------
//
//  Main body of code
//  =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Tie down non-primary inputs to the SSP to prevent X-propagation
// during netlist simulations.
// ---------------------------------------------------------------------
assign SSPTXDMACLR  = 1'b0;
assign SSPRXDMACLR  = 1'b0;
assign SCANENABLE   = 1'b0;
assign SCANINPCLK   = 1'b0;
assign SCANINSSPCLK = 1'b0;

initial
begin
  SSPCLK = 1'b0;
end

always
begin
  SSPCLK = #((`SSPCLK_PERIOD)/2) (~SSPCLK);
end

// ---------------------------------------------------------------------
// Create nSSPRST by synchronising the negation to nSSP
// ---------------------------------------------------------------------
always @(negedge SSPCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nSSPRST1   <= 1'b0;
  else
    nSSPRST1   <= 1'b1;
end 

always @(negedge SSPCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nSSPRST2   <= 1'b0;
  else
    nSSPRST2   <= nSSPRST1;
end 

always @(negedge SSPCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nSSPRST   <= 1'b0;
  else
    nSSPRST   <= nSSPRST2;
end 

MuxP2B uMuxP2B                        (
                    .PSELUUT          (PSELUUT),
                    .PSELRPC          (PSELRPC),

                    .PRDATAUUT        (PRDATAUUT),
                    .PRDATARPC        (PRDATARPC),

                    .PRDATA           (PRDATA)
                    );

// ---------------------------------------------------------------------
// The reset and pause controller
// ---------------------------------------------------------------------
RemPause  uRemPause                   (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PENABLE          (PENABLE),
                    .PSELRPC          (PSELRPC),
                    .PADDR            (PADDR[5:2]),
                    .PWRITE           (PWRITE),
                    .PWDATA           (PWDATA[7:0]),
                    .PRDATA           (PRDATARPC[7:0]),

                    .nFIQ             (nFIQInt), // FIQ interrupt input
                    .nIRQ             (nIRQInt), // IRQ interrupt input
                    .Pause            (Pause),   // Pause mode entered
                    .Remap            (Remap)    // Reset memory map in
                                                 // use
                    );

// ---------------------------------------------------------------------
// Drive unused output read data bits LOW
// ---------------------------------------------------------------------
assign PRDATARPC[31:8]  = 24'h0000_00;
assign PRDATAUUT[31:16] = 16'h0000;

Ssp uut           (
                    .PCLK             (PCLK),
                    .SSPCLK           (SSPCLK),
      
                    .PRESETn          (PRESETn),
                    .nSSPRST          (nSSPRST),
      
                    .PSEL             (PSELUUT),
                    .PENABLE          (PENABLE),
                    .PWRITE           (PWRITE),
      
                    .SSPRXD           (SSPRXD),
                    .SSPCLKIN         (SSPCLKIN),
                    .SSPFSSIN         (SSPFSSIN),
      
                    .SCANENABLE       (SCANENABLE),
                    .SCANINPCLK       (SCANINPCLK),
                    .SCANINSSPCLK     (SCANINSSPCLK),
      
                    .PADDR            (PADDR[11:2]),

                    .PWDATA           (PWDATA[15:0]),       

                    .SSPTXDMACLR      (SSPTXDMACLR),
                    .SSPRXDMACLR      (SSPRXDMACLR),
     
                    .SSPINTR          (SSPINTR),
                    .SSPRXINTR        (SSPRXINTR),
                    .SSPTXINTR        (SSPTXINTR),
                    .SSPRORINTR       (SSPRORINTR),
                    .SSPRTINTR        (SSPRTINTR),
      
                    .SSPFSSOUT        (SSPFSSOUT), 
                    .SSPCLKOUT        (SSPCLKOUT),
      
                    .SCANOUTPCLK      (SCANOUTPCLK),
                    .SCANOUTSSPCLK    (SCANOUTSSPCLK),

                    .SSPTXD           (SSPTXD),
                    .nSSPOE           (nSSPOE),
                    .nSSPCTLOE        (nSSPCTLOE),
      
                    .PRDATA           (PRDATAUUT[15:0]),        


                    .SSPTXDMASREQ     (SSPTXDMASREQ),
                    .SSPTXDMABREQ     (SSPTXDMABREQ),
                    .SSPRXDMASREQ     (SSPRXDMASREQ),
                    .SSPRXDMABREQ     (SSPRXDMABREQ)
                   );


endmodule

// --============================== End ==============================--
