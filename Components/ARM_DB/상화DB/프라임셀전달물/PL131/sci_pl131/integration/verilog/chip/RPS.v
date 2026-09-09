// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : RPS.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-PL131-REL1v0
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

//SCI - Primary I/O Test Trickbox connections
            SCICLKIN,
            SCIDATAIN,
            SCIDETECT,
            SCIDEACREQ,

            nSCICLKEN,
            nSCICLKOUTEN,
            SCICLKOUT,
            nSCIDATAEN,
            nSCIDATAOUTEN,

            SCIDEACACK,
            SCIVCCEN,
            nSCICARDRST,
            SCIFCB
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

//SCI - Primary I/O Test Trickbox connections
input         SCICLKIN;
input         SCIDATAIN;
input         SCIDETECT;
input         SCIDEACREQ;

output        nSCICLKEN;
output        nSCICLKOUTEN;
output        SCICLKOUT;
output        nSCIDATAEN;
output        nSCIDATAOUTEN;

output        SCIDEACACK;
output        SCIVCCEN;
output        nSCICARDRST;
output        SCIFCB;
 

// ---------------------------------------------------------------------
// Constant defined for MCLK Period
// ---------------------------------------------------------------------
`define SCICLK_PERIOD  100


// ---------------------------------------------------------------------
//  Signal declarations
// ---------------------------------------------------------------------
wire        nFIQInt = 1'b1;
wire        nIRQInt = 1'b1;
wire [31:0] PRDATAUUT;
wire [31:0] PRDATARPC;

// ---------------------------------------------------------------------
// Sci Signals
// ---------------------------------------------------------------------

wire        SCITXDMACLR;
wire        SCIRXDMACLR;
wire        SCANENABLE;
wire        SCANINPCLK;
wire        SCANINSCICLK;


// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg           SCICLK;
reg           nSCIRST1;
reg           nSCIRST2;
reg           nSCIRST;

// ---------------------------------------------------------------------
//
//  Main body of code
//  =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Tie down non-primary inputs to the SCI to prevent X-propagation
// during netlist simulations.
// ---------------------------------------------------------------------
assign SCITXDMACLR  = 1'b0;
assign SCIRXDMACLR  = 1'b0;
assign SCANENABLE   = 1'b0;
assign SCANINPCLK   = 1'b0;
assign SCANINSCICLK = 1'b0;

initial
begin
  SCICLK = 1'b0;
end

always
begin
  SCICLK = #((`SCICLK_PERIOD)/2) (~SCICLK);
end

// ---------------------------------------------------------------------
// Create nSCIRST by synchronising the negation to nSCI
// ---------------------------------------------------------------------
always @(negedge SCICLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nSCIRST1   <= 1'b0;
  else
    nSCIRST1   <= 1'b1;
end 

always @(negedge SCICLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nSCIRST2   <= 1'b0;
  else
    nSCIRST2   <= nSCIRST1;
end 

always @(negedge SCICLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nSCIRST   <= 1'b0;
  else
    nSCIRST   <= nSCIRST2;
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

Sci uut (
// Inputs
          .PCLK              (PCLK), 
          .SCICLK            (SCICLK), 
          .PRESETn           (PRESETn),
          .nSCIRST           (nSCIRST),
          .PSEL              (PSELUUT),
          .PENABLE           (PENABLE),
          .PWRITE            (PWRITE),
          .PADDR             (PADDR[11:2]), 
          .PWDATA            (PWDATA[15:0]),
          .SCIDATAIN         (SCIDATAIN),
          .SCICLKIN          (SCICLKIN),
          .SCIDETECT         (SCIDETECT),
          .SCIDEACREQ        (SCIDEACREQ),

          .SCITXDMACLR       (SCITXDMACLR),
          .SCIRXDMACLR       (SCIRXDMACLR),

          .SCANENABLE        (SCANENABLE),
          .SCANINPCLK        (SCANINPCLK),
          .SCANINSCICLK      (SCANINSCICLK),

// Outputs
          .nSCIDATAOUTEN     (nSCIDATAOUTEN),
          .nSCIDATAEN        (nSCIDATAEN),
          .SCICLKOUT         (SCICLKOUT),
          .nSCICLKOUTEN      (nSCICLKOUTEN),
          .nSCICLKEN         (nSCICLKEN),
          .nSCICARDRST       (nSCICARDRST),
          .SCIFCB            (SCIFCB),
          .SCIVCCEN          (SCIVCCEN),

          .SCIDEACACK        (SCIDEACACK),
          .PRDATA            (PRDATAUUT[15:0]),

          .SCICARDININTR     (),
          .SCICARDOUTINTR    (),
          .SCICARDUPINTR     (),
          .SCICARDDNINTR     (),
          .SCITXERRINTR      (),
          .SCIATRSTOUTINTR   (),
          .SCIATRDTOUTINTR   (),
          .SCIBLKTOUTINTR    (),
          .SCICHTOUTINTR     (),
          .SCIRTOUTINTR      (),
          .SCIRORINTR        (),
          .SCICLKSTPINTR     (),
          .SCICLKACTINTR     (),
          .SCITXTIDEINTR     (),
          .SCIRXTIDEINTR     (),
     
          .SCIINTR           (),


          .SCITXDMASREQ      (),
          .SCITXDMABREQ      (),
          .SCIRXDMASREQ      (),
          .SCIRXDMABREQ      (),

          .SCANOUTPCLK       (),
          .SCANOUTSCICLK     ()
          );         


endmodule

// --============================== End ==============================--
