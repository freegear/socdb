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
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL061-REL1v0
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
            GPIN,
            nGPEN,
            GPOUT
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

// Gpio-signals
input  [7:0]  GPIN;            // GPIO inputs
output [7:0]  nGPEN;           // GPIO o/p enables
output [7:0]  GPOUT;           // GPIO inputs

// ---------------------------------------------------------------------
//  Signal declarations
// ---------------------------------------------------------------------
wire        nFIQInt = 1'b1;
wire        nIRQInt = 1'b1;
wire [31:0] PRDATAUUT;
wire [31:0] PRDATARPC;

// ---------------------------------------------------------------------
// GPIO Signals
// ---------------------------------------------------------------------
wire [7:0]  nGPEN;
wire [7:0]  GPOUT;
wire [7:0]  GPIN;
wire [7:0]  nGPAFEN;
wire [7:0]  GPAFOUT;
wire [7:0]  GPAFIN;
wire        GPIOINTR;
wire [7:0]  GPIOMIS;

// Read Fill vector
wire [31:0] ReadFill;
wire [7:0]  GpioRdData;
wire [7:0]  TrickRdData;

// Scan related signals
wire        SCANENABLE;
wire        SCANINPCLK;
wire        SCANOUTPCLK;

// ---------------------------------------------------------------------
//
//  Main body of code
//  =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Tie down non-primary inputs to the GPIO to prevent X-propagation
// during netlist simulations.
// ---------------------------------------------------------------------
assign SCANENABLE       = 1'b0;
assign SCANINPCLK       = 1'b0;

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
// GPIO instance
// ---------------------------------------------------------------------
Gpio uut                              (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PSEL             (PSELUUT),
                    .PENABLE          (PENABLE),
                    .PWRITE           (PWRITE),
                    .PADDR            (PADDR[11:2]),
                    .PWDATA           (PWDATA[7:0]),
                    .nGPEN            (nGPEN),
                    .GPOUT            (GPOUT),
                    .GPIN             (GPIN),
                    .nGPAFEN          (nGPAFEN),
                    .GPAFOUT          (GPAFOUT),
                    .GPAFIN           (GPAFIN),
                    .GPIOINTR         (GPIOINTR),
                    .GPIOMIS          (GPIOMIS),
                    .SCANENABLE       (SCANENABLE),
                    .SCANINPCLK       (SCANINPCLK),
                    .SCANOUTPCLK      (SCANOUTPCLK),
                    .PRDATA           (GpioRdData)
                   );

assign PRDATAUUT = {24'b000000000000000000000000, GpioRdData};

endmodule

// --============================== End ==============================--
