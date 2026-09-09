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
// File Revision          : 1.6
//
// Release Information    : PrimeCell(TM)-PL031-REL1v0
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
            PRDATA
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


// ---------------------------------------------------------------------
// Constant defined for MCLK Period
// ---------------------------------------------------------------------
`define CLK1HZ_PERIOD   1000000000


// ---------------------------------------------------------------------
//  Signal declarations
// ---------------------------------------------------------------------
wire        nFIQInt = 1'b1;
wire        nIRQInt = 1'b1;
wire [31:0] PRDATAUUT;
wire [31:0] PRDATARPC;
wire        SCANENABLE;
wire        SCANINPCLK;
wire        SCANINCLK1HZ;


// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg           CLK1HZ;
reg           nRTCRST1;
reg           nRTCRST2;
reg           nRTCRST;

// ---------------------------------------------------------------------
//
//  Main body of code
//  =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Tie down non-primary inputs to the RTC to prevent X-propagation
// during netlist simulations.
// ---------------------------------------------------------------------
assign SCANENABLE   = 1'b0;
assign SCANINPCLK   = 1'b0;
assign SCANINCLK1HZ = 1'b0;

initial
begin
  CLK1HZ = 1'b0;
end

always
begin
  CLK1HZ = #((`CLK1HZ_PERIOD)/2) (~CLK1HZ);
end

// ---------------------------------------------------------------------
// Create nRTCRST by synchronising the negation to CLK1HZ
// ---------------------------------------------------------------------
always @(negedge CLK1HZ or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nRTCRST1   <= 1'b0;
  else
    nRTCRST1   <= 1'b1;
end 

always @(negedge CLK1HZ or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nRTCRST2   <= 1'b0;
  else
    nRTCRST2   <= nRTCRST1;
end 

always @(negedge CLK1HZ or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nRTCRST   <= 1'b0;
  else
    nRTCRST   <= nRTCRST2;
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

Rtc uut           (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PSEL             (PSELUUT),
                    .PENABLE          (PENABLE),
                    .PWRITE           (PWRITE),
                    .PADDR            (PADDR[11:2]),
                    .PWDATA           (PWDATA[31:0]),
                    .CLK1HZ           (CLK1HZ),
                    .nRTCRST          (nRTCRST),
                    .nPOR             (nRTCRST),
                    .SCANENABLE       (SCANENABLE),
                    .SCANINPCLK       (SCANINPCLK),
                    .SCANINCLK1HZ     (SCANINCLK1HZ),
                    .PRDATA           (PRDATAUUT[31:0]),
                    .RTCINTR          (RTCINTR),
                    .SCANOUTPCLK      (SCANOUTPCLK),
                    .SCANOUTCLK1HZ    (SCANOUTCLK1HZ)
                   );


endmodule

// --============================== End ==============================--
