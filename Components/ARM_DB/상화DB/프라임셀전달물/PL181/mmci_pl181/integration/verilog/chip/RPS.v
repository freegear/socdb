// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : RPS.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Structural architecture of Reference Peripherals:
//           Interrupt Controller, Remap and Pause Controller, and
//           Timers modules.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

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

            MMCIFBCLK,
            MMCICMDIN,
            MMCIDATIN,
            MMCICLKOUT,
            MMCICMDOUT,
            MMCIDATOUT,
            nMMCIDATEN,
            nMMCICMDEN,
            MMCIPWR,
            MMCIROD,
            MMCIVDD
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

// MMCI Signals
input         MMCIFBCLK;
input         MMCICMDIN;
input         MMCIDATIN;
output        MMCICLKOUT;
output        MMCICMDOUT;
output        MMCIDATOUT;
output        nMMCIDATEN;
output        nMMCICMDEN;
output        MMCIPWR;
output        MMCIROD;
output [3:0]  MMCIVDD;

// -----------------------------------------------------------------------------
// Constant defined for MCLK Period
// -----------------------------------------------------------------------------
`define MCLK_PERIOD              100

// -----------------------------------------------------------------------------
//  Signal declarations
// -----------------------------------------------------------------------------
wire          nFIQInt = 1'b1;
wire          nIRQInt = 1'b1;
wire  [31:0]  PRDATAUUT;
wire  [31:0]  PRDATARPC;

//--------------------------------------
// MMCI Signals
//--------------------------------------
wire          SCANENABLE;
wire          SCANINPCLK;
wire          SCANINMCLK;
wire          SCANINnMCLK;
wire          SCANINMMCIFBCLK;
wire          MMCIDMACLR;
wire          SCANOUTPCLK;
wire          SCANOUTMCLK;
wire          SCANOUTnMCLK;
wire          SCANOUTMMCIFBCLK;
wire          MMCIINTR0;
wire          MMCIINTR1;
wire          MMCIDMASREQ;
wire          MMCIDMABREQ;
wire          MMCIDMALSREQ;
wire          MMCIDMALBREQ;
wire          nMMCICMDEN;
wire          nMMCIDAT0EN;
wire          nMMCIDATEN;
wire          nMCLK;
wire          nMMCIRSTDel;
wire          MMCIDATOUT;

reg           nMMCIRST;
reg           nMMCIRST1;
reg           nMMCIRST2;
reg           MCLK;

// -----------------------------------------------------------------------------
//
//  Main body of code
//  =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Tie down non-primary inputs to the MMCI to prevent X-propagation
// during netlist simulations.
// -----------------------------------------------------------------------------
assign SCANENABLE       = 1'b0;
assign SCANINPCLK       = 1'b0; 
assign SCANINMCLK       = 1'b0; 
assign SCANINnMCLK      = 1'b0; 
assign SCANINMMCIFBCLK  = 1'b0; 
assign MMCIDMACLR       = 1'b0;

initial
  begin
    MCLK = 1'b0;
  end

always
begin
  MCLK = #((`MCLK_PERIOD)/2) (~MCLK);
end

assign #((`MCLK_PERIOD)/4) nMMCIRSTDel =  nMMCIRST;

assign nMCLK = ~MCLK;

// -----------------------------------------------------------------------------
// Create nMMCIRST by synchronising the negation to MCLK
// -----------------------------------------------------------------------------
always @(posedge MCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nMMCIRST1   <= 1'b0;
  else
    nMMCIRST1   <= 1'b1;
end 

always @(posedge MCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nMMCIRST2   <= 1'b0;
  else
    nMMCIRST2   <= nMMCIRST1;
end 

always @(posedge MCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nMMCIRST    <= 1'b0;
  else
    nMMCIRST    <= nMMCIRST2;
end 

MuxP2B uMuxP2B                        (
                    .PSELUUT          (PSELUUT),
                    .PSELRPC          (PSELRPC),
                    .PRDATAUUT        (PRDATAUUT),
                    .PRDATARPC        (PRDATARPC),
                    .PRDATA           (PRDATA)
                   );

// -----------------------------------------------------------------------------
// The reset and pause controller
// -----------------------------------------------------------------------------
RemPause  uRemPause                   (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PENABLE          (PENABLE),
                    .PSELRPC          (PSELRPC),
                    .PADDR            (PADDR[5:2]),
                    .PWRITE           (PWRITE),
                    .PWDATA           (PWDATA[7:0]),
                    .PRDATA           (PRDATARPC[7:0]),
                    .nFIQ             (nFIQInt),
                    .nIRQ             (nIRQInt),
                    .Pause            (Pause),
                    .Remap            (Remap)
                   );

// -----------------------------------------------------------------------------
// Drive unused output read data bits LOW
// -----------------------------------------------------------------------------
assign PRDATARPC[31:8]  = 24'h0000_00;

// -----------------------------------------------------------------------------
// MMCI instance
// -----------------------------------------------------------------------------
Mmci uut                              (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PSEL             (PSELUUT),
                    .PENABLE          (PENABLE),
                    .PWRITE           (PWRITE),
                    .PADDR            (PADDR[11:2]),
                    .PWDATA           (PWDATA[31:0]),
                    .SCANENABLE       (SCANENABLE),
                    .SCANINPCLK       (SCANINPCLK),
                    .SCANINMCLK       (SCANINMCLK),
                    .SCANINnMCLK      (SCANINnMCLK),
                    .SCANINMMCIFBCLK  (SCANINMMCIFBCLK),
                    .MMCIDMACLR       (MMCIDMACLR),
                    .MCLK             (MCLK),
                    .nMCLK            (nMCLK),
                    .MMCIFBCLK        (MMCIFBCLK),
                    .nMMCIRST         (nMMCIRSTDel),
                    .MMCICMDIN        (MMCICMDIN),
                    .MMCIDATIN        (MMCIDATIN),
                    .PRDATA           (PRDATAUUT),
                    .SCANOUTPCLK      (SCANOUTPCLK),
                    .SCANOUTMCLK      (SCANOUTMCLK),
                    .SCANOUTnMCLK     (SCANOUTnMCLK),
                    .SCANOUTMMCIFBCLK (SCANOUTMMCIFBCLK),
                    .MMCIINTR0        (MMCIINTR0),
                    .MMCIINTR1        (MMCIINTR1),
                    .MMCIDMASREQ      (MMCIDMASREQ),
                    .MMCIDMABREQ      (MMCIDMABREQ),
                    .MMCIDMALSREQ     (MMCIDMALSREQ),
                    .MMCIDMALBREQ     (MMCIDMALBREQ),
                    .MMCICLKOUT       (MMCICLKOUT),
                    .MMCICMDOUT       (MMCICMDOUT),
                    .nMMCICMDEN       (nMMCICMDEN),
                    .MMCIDATOUT       (MMCIDATOUT),
                    .nMMCIDATEN       (nMMCIDATEN),
                    .MMCIPWR          (MMCIPWR),
                    .MMCIROD          (MMCIROD),
                    .MMCIVDD          (MMCIVDD)
                   );

endmodule

// --============================== End ==============================--
