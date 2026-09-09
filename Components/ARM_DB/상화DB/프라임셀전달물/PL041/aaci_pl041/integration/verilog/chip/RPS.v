// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : RPS.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL041-REL1v0
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
            AACIBITCLK,
            AACISDATAIN,
            AACISDATAOUT,
            AACISYNC,
            AACIRESET
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

// AC-LINK signals
input         AACIBITCLK;
input         AACISDATAIN;

output        AACISDATAOUT;
output        AACISYNC;
output        AACIRESET;

// ---------------------------------------------------------------------
//  Signal declarations
// ---------------------------------------------------------------------
wire        nFIQInt = 1'b1;
wire        nIRQInt = 1'b1;
wire [31:0] PRDATAUUT;
wire [31:0] PRDATARPC;

// ---------------------------------------------------------------------
// AACI Signals
// ---------------------------------------------------------------------
wire          nAACIBITCLK;
wire          AACIDMACLRRX;
wire          AACIDMACLRTX;
wire          SCANENABLE;
wire          SCANINPCLK;
wire          SCANINBITCLK;
wire          SCANINnBITCLK;

wire          AACITXINTR1;
wire          AACITXINTR2;
wire          AACITXINTR3;
wire          AACITXINTR4;
wire          AACIRXINTR1;
wire          AACIRXINTR2;
wire          AACIRXINTR3;
wire          AACIRXINTR4;
wire          AACIORINTR1;
wire          AACIORINTR2;
wire          AACIORINTR3;
wire          AACIORINTR4;
wire          AACIURINTR1;
wire          AACIURINTR2;
wire          AACIURINTR3;
wire          AACIURINTR4;
wire          AACITXCINTR1;
wire          AACITXCINTR2;
wire          AACITXCINTR3;
wire          AACITXCINTR4;
wire          AACIRXTOINTR1;
wire          AACIRXTOINTR2;
wire          AACIRXTOINTR3;
wire          AACIRXTOINTR4;
wire          AACIWINTR;
wire          AACIGPIOINTR;
wire          AACIS12RXINTR;
wire          AACIS12TXINTR;
wire          AACIS2RXINTR;
wire          AACIS2TXINTR;
wire          AACIS1RXINTR;
wire          AACIS1TXINTR;
wire          AACIRXTOFEINTR1;
wire          AACIRXTOFEINTR2;
wire          AACIRXTOFEINTR3;
wire          AACIRXTOFEINTR4;
wire          AACIINTR;
wire          AACIDMASREQRX;
wire          AACIDMALSREQRX;
wire          AACIDMABREQRX;
wire          AACIDMALBREQRX;
wire          AACIDMABREQTX;
wire          SCANOUTPCLK;
wire          SCANOUTBITCLK;
wire          SCANOUTnBITCLK;

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg           nAACIBITCLKRST;
reg           nAACIBITCLKRST1;
reg           nAACIBITCLKRST2;
reg           nFAACIBITCLKRST;
reg           nFAACIBITCLKRST1;
reg           nFAACIBITCLKRST2;

// ---------------------------------------------------------------------
//
//  Main body of code
//  =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Tie down non-primary inputs to the AACI to prevent X-propagation
// during netlist simulations.
// ---------------------------------------------------------------------
assign AACIDMACLRRX     = 1'b0;
assign AACIDMACLRTX     = 1'b0;
assign SCANENABLE       = 1'b0;
assign SCANINPCLK       = 1'b0;
assign SCANINBITCLK     = 1'b0;
assign SCANINnBITCLK    = 1'b0;

// ---------------------------------------------------------------------
// Invert AACIBITCLK to gnerate nAACIBITCLK for the AACI
// ---------------------------------------------------------------------
assign nAACIBITCLK      = ~(AACIBITCLK);

// ---------------------------------------------------------------------
// Create nAACIBITCLKRST by synchronising the negation to AACIBITCLK
// ---------------------------------------------------------------------
always @(posedge AACIBITCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nAACIBITCLKRST1   <= 1'b0;
  else
    nAACIBITCLKRST1   <= #0.5 1'b1;
end 

always @(posedge AACIBITCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nAACIBITCLKRST2   <= 1'b0;
  else
    nAACIBITCLKRST2   <= #0.5 nAACIBITCLKRST1;
end 

always @(posedge AACIBITCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nAACIBITCLKRST   <= 1'b0;
  else
    nAACIBITCLKRST   <= #0.5 nAACIBITCLKRST2;
end 

// ---------------------------------------------------------------------
// Create nFAACIBITCLKRST by synchronising the negation to nAACIBITCLK
// ---------------------------------------------------------------------
always @(posedge nAACIBITCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nFAACIBITCLKRST1   <= 1'b0;
  else
    nFAACIBITCLKRST1   <= #0.5 1'b1;
end 

always @(posedge nAACIBITCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nFAACIBITCLKRST2   <= 1'b0;
  else
    nFAACIBITCLKRST2   <= #0.5 nFAACIBITCLKRST1;
end 

always @(posedge nAACIBITCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nFAACIBITCLKRST   <= 1'b0;
  else
    nFAACIBITCLKRST   <= #0.5 nFAACIBITCLKRST2;
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

// ---------------------------------------------------------------------
// AACI instance
// ---------------------------------------------------------------------
Aaci uut                              (
                    .PCLK             (PCLK),
                    .AACIBITCLK       (AACIBITCLK),
                    .nAACIBITCLK      (nAACIBITCLK),
                    .PRESETn          (PRESETn),
                    .nAACIBITCLKRST   (nAACIBITCLKRST),
                    .nFAACIBITCLKRST  (nFAACIBITCLKRST),
                    .PSEL             (PSELUUT),
                    .PENABLE          (PENABLE),
                    .PWRITE           (PWRITE),
                    .AACIDMACLRRX     (AACIDMACLRRX),
                    .AACIDMACLRTX     (AACIDMACLRTX),
                    .SCANENABLE       (SCANENABLE),
                    .SCANINPCLK       (SCANINPCLK),
                    .SCANINBITCLK     (SCANINBITCLK),
                    .SCANINnBITCLK    (SCANINnBITCLK),
                    .AACISDATAIN      (AACISDATAIN),
                    .PADDR            (PADDR[11:2]),
                    .PWDATA           (PWDATA),
                    .AACIRESET        (AACIRESET),
                    .AACISYNC         (AACISYNC),
                    .AACITXINTR1      (AACITXINTR1),
                    .AACITXINTR2      (AACITXINTR2),
                    .AACITXINTR3      (AACITXINTR3),
                    .AACITXINTR4      (AACITXINTR4),
                    .AACIRXINTR1      (AACIRXINTR1),
                    .AACIRXINTR2      (AACIRXINTR2),
                    .AACIRXINTR3      (AACIRXINTR3),
                    .AACIRXINTR4      (AACIRXINTR4),
                    .AACIORINTR1      (AACIORINTR1),
                    .AACIORINTR2      (AACIORINTR2),
                    .AACIORINTR3      (AACIORINTR3),
                    .AACIORINTR4      (AACIORINTR4),
                    .AACIURINTR1      (AACIURINTR1),
                    .AACIURINTR2      (AACIURINTR2),
                    .AACIURINTR3      (AACIURINTR3),
                    .AACIURINTR4      (AACIURINTR4),
                    .AACITXCINTR1     (AACITXCINTR1),
                    .AACITXCINTR2     (AACITXCINTR2),
                    .AACITXCINTR3     (AACITXCINTR3),
                    .AACITXCINTR4     (AACITXCINTR4),
                    .AACIRXTOINTR1    (AACIRXTOINTR1),
                    .AACIRXTOINTR2    (AACIRXTOINTR2),
                    .AACIRXTOINTR3    (AACIRXTOINTR3),
                    .AACIRXTOINTR4    (AACIRXTOINTR4),
                    .AACIWINTR        (AACIWINTR),
                    .AACIGPIOINTR     (AACIGPIOINTR),
                    .AACIS12RXINTR    (AACIS12RXINTR),
                    .AACIS12TXINTR    (AACIS12TXINTR),
                    .AACIS2RXINTR     (AACIS2RXINTR),
                    .AACIS2TXINTR     (AACIS2TXINTR),
                    .AACIS1RXINTR     (AACIS1RXINTR),
                    .AACIS1TXINTR     (AACIS1TXINTR),
                    .AACIRXTOFEINTR1  (AACIRXTOFEINTR1),
                    .AACIRXTOFEINTR2  (AACIRXTOFEINTR2),
                    .AACIRXTOFEINTR3  (AACIRXTOFEINTR3),
                    .AACIRXTOFEINTR4  (AACIRXTOFEINTR4),
                    .AACIINTR         (AACIINTR),
                    .AACIDMASREQRX    (AACIDMASREQRX),
                    .AACIDMALSREQRX   (AACIDMALSREQRX),
                    .AACIDMABREQRX    (AACIDMABREQRX),
                    .AACIDMALBREQRX   (AACIDMALBREQRX),
                    .AACIDMABREQTX    (AACIDMABREQTX),
                    .SCANOUTPCLK      (SCANOUTPCLK),
                    .SCANOUTBITCLK    (SCANOUTBITCLK),
                    .SCANOUTnBITCLK   (SCANOUTnBITCLK),
                    .AACISDATAOUT     (AACISDATAOUT),
                    .PRDATA           (PRDATAUUT)
                    );

endmodule

// --============================== End ==============================--
