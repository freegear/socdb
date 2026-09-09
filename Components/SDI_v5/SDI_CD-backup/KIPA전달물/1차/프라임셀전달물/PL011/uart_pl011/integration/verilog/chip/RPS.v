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
// File Revision          : 1.8
//
// Release Information    : PrimeCell(TM)-PL011-REL1v3
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
            UARTRXD,
            SIRIN,
            nUARTCTS,
            nUARTDCD,
            nUARTDSR,
            nUARTRI,
            UARTTXD,
            nSIROUT,
            nUARTOut2,
            nUARTOut1,
            nUARTRTS,
            nUARTDTR
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

input         UARTRXD;        // UART Receive input
input         SIRIN;          // SiR receive input
input         nUARTCTS;       // Modem CTS
input         nUARTDCD;       // Modem DCD
input         nUARTDSR;       // Modem DSR
input         nUARTRI;        // Modem RI
output        UARTTXD;        // UART Transmit line
output        nSIROUT;        // SiR Transmit line
output        nUARTOut2;      // Modem Out2
output        nUARTOut1;      // Modem Out1
output        nUARTRTS;       // Modem RTS
output        nUARTDTR;       // Modem DTR

// ---------------------------------------------------------------------
// Constant defined for MCLK Period
// ---------------------------------------------------------------------
`define UARTCLK_PERIOD              100


// ---------------------------------------------------------------------
//  Signal declarations
// ---------------------------------------------------------------------
wire        nFIQInt = 1'b1;
wire        nIRQInt = 1'b1;
wire [31:0] PRDATAUUT;
wire [31:0] PRDATARPC;

// ---------------------------------------------------------------------
// Uart Signals
// ---------------------------------------------------------------------

wire UARTTXDMACLR;
wire UARTRXDMACLR;
wire UARTMSINTR;
wire UARTRXINTR;
wire UARTTXINTR;
wire UARTRTINTR;
wire UARTEINTR;
wire UARTINTR;
wire UARTTXDMASREQ;
wire UARTTXDMABREQ;
wire UARTRXDMASREQ;
wire UARTRXDMABREQ;
wire SCANENABLE;
wire SCANINPCLK;
wire SCANINUCLK;
wire SCANOUTPCLK;
wire SCANOUTUCLK;



// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg           nUARTRST1;
reg           nUARTRST2;
reg           nUARTRST;
reg           UARTCLK;

// ---------------------------------------------------------------------
//
//  Main body of code
//  =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Tie down non-primary inputs to the UART to prevent X-propagation
// during netlist simulations.
// ---------------------------------------------------------------------
assign UARTTXDMACLR = 1'b0;
assign UARTRXDMACLR = 1'b0;
assign SCANENABLE   = 1'b0;
assign SCANINPCLK   = 1'b0;
assign SCANINUCLK   = 1'b0;

initial
begin
  UARTCLK = 1'b0;
end

always
begin
  UARTCLK = #((`UARTCLK_PERIOD)/2) (~UARTCLK);
end

// ---------------------------------------------------------------------
// Create nUARTRST by synchronising the negation to nUART
// ---------------------------------------------------------------------
always @(negedge UARTCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nUARTRST1   <= 1'b0;
  else
    nUARTRST1   <= 1'b1;
end 

always @(negedge UARTCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nUARTRST2   <= 1'b0;
  else
    nUARTRST2   <= nUARTRST1;
end 

always @(negedge UARTCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    nUARTRST   <= 1'b0;
  else
    nUARTRST   <= nUARTRST2;
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

Uart uut           (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .nUARTRST         (nUARTRST),
                    .PSEL             (PSELUUT),
                    .PWRITE           (PWRITE),
                    .PENABLE          (PENABLE),
                    .PADDR            (PADDR[11:2]),
                    .PWDATA           (PWDATA[15:0]),
                    .UARTCLK          (UARTCLK),
                    .PRDATA           (PRDATAUUT[15:0]),
                    .nUARTCTS         (nUARTCTS),
                    .nUARTDCD         (nUARTDCD),
                    .nUARTDSR         (nUARTDSR),
                    .nUARTRI          (nUARTRI),
                    .nUARTOut2        (nUARTOut2),
                    .nUARTOut1        (nUARTOut1),
                    .nUARTRTS         (nUARTRTS),
                    .nUARTDTR         (nUARTDTR),
                    .UARTRXD          (UARTRXD),
                    .SIRIN            (SIRIN),
                    .UARTTXDMACLR     (UARTTXDMACLR),
                    .UARTRXDMACLR     (UARTRXDMACLR),
                    .UARTTXDMASREQ    (UARTTXDMASREQ),
                    .UARTTXDMABREQ    (UARTTXDMABREQ),
                    .UARTRXDMASREQ    (UARTRXDMASREQ),
                    .UARTRXDMABREQ    (UARTRXDMABREQ),
                    .UARTMSINTR       (UARTMSINTR),
                    .UARTTXD          (UARTTXD),
                    .UARTRXINTR       (UARTRXINTR),
                    .nSIROUT          (nSIROUT),
                    .UARTTXINTR       (UARTTXINTR),
                    .UARTRTINTR       (UARTRTINTR),
                    .UARTINTR         (UARTINTR),
                    .UARTEINTR        (UARTEINTR),
                    .SCANINPCLK       (SCANINPCLK),
                    .SCANINUCLK       (SCANINUCLK),
                    .SCANOUTPCLK      (SCANOUTPCLK),
                    .SCANOUTUCLK      (SCANOUTUCLK),
                    .SCANENABLE       (SCANENABLE)
                   );


endmodule

// --============================== End ==============================--
