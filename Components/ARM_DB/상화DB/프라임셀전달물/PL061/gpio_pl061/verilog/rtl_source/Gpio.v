//  --------------------------------------------------------------------
//  This Confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  --------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : Gpio.v.rca
//  File Revision          : 1.1
//
//  Release Information    : PrimeCell(TM)-PL061-REL1v0
//
//  --------------------------------------------------------------------
//
// ---------------------------------------------------------------------
// Purpose                 : Gpio.v is the top level of the Gpio.
//
// ---------------------------------------------------------------------

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module Gpio (
// Inputs
// APB bus signals
             PCLK,
             PRESETn,
             PSEL,
             PENABLE,
             PWRITE,
             PWDATA,
             PADDR,

// GPIO lines onto the Pads
             GPIN,

// Alternate functionality lines
             nGPAFEN,
             GPAFOUT,

// Outputs
// APB bus signals
             PRDATA,

// GPIO lines onto the Pads
             nGPEN,
             GPOUT,

// Alternate functionality lines
             GPAFIN,

// Interrupt output to the Interrupt controller
             GPIOINTR,
             GPIOMIS,
             SCANENABLE,
             SCANINPCLK,
             SCANOUTPCLK
             );

// Inputs
input        PCLK;                 // APB clock
input        PRESETn;              // AMBA reset
input        PSEL;                 // APB periph select
input        PENABLE;              // APB enable
input        PWRITE;               // APB write
input  [7:0] PWDATA;               // APB write data
input [11:2] PADDR;                // APB address bus
input  [7:0] GPIN;                 // GPIO input
input  [7:0] nGPAFEN;              // Alt. F. o/p enable
input  [7:0] GPAFOUT;              // Alt. Funct. output
input        SCANENABLE;           // Scan Test Mode Enbl
input        SCANINPCLK;           // Scan Chain Input

// Outputs
output [7:0] PRDATA;               // APB read data
output [7:0] nGPEN;                // GPIO o/p enable
output [7:0] GPOUT;                // GPIO output
output [7:0] GPAFIN;               // Alt. Funct. input
output       GPIOINTR;             // Interrupt output
output [7:0] GPIOMIS;              // GPIO Masked Interr.
output       SCANOUTPCLK;          // Scan Chain Output

// Inputs
wire        PCLK;                 // APB clock
wire        PRESETn;              // AMBA reset
wire        PSEL;                 // APB periph select
wire        PENABLE;              // APB enable
wire        PWRITE;               // APB write
wire  [7:0] PWDATA;               // APB write data
wire [11:2] PADDR;                // APB address bus
wire  [7:0] GPIN;                 // GPIO input
wire  [7:0] nGPAFEN;              // Alt. F. o/p enable
wire  [7:0] GPAFOUT;              // Alt. Funct. output
wire        SCANENABLE;           // Scan Test Mode Enbl
wire        SCANINPCLK;           // Scan Chain Input

// Outputs
wire [7:0] PRDATA;               // APB read data
wire [7:0] nGPEN;                // GPIO o/p enable
wire [7:0] GPOUT;                // GPIO output
wire [7:0] GPAFIN;               // Alt. Funct. input
wire       GPIOINTR;             // Interrupt output
wire [7:0] GPIOMIS;              // GPIO Masked Interr.
wire       SCANOUTPCLK;          // Scan Chain Output

// ---------------------------------------------------------------------
//
//                                 Gpio
//                                 ====
//
// ---------------------------------------------------------------------
//
//  Overview
//  ========
//
//  This module is the top level  of the Gpio.  The following blocks are
//  instantiated in this module.
//  1. GpioApbif
//  2. GpioAfm
//  3. GpioInt
//  4. GpioRevAnd
//
// The module GpioRevAnd used as a place-holder cell to mark the
// Revision of the GPIO. It contains a 2 input AND gate. The 2 input
// pins are tied-off at the top level of the hierarchy. These "TieOffs"
// can be identified during layout and re-wired to "VDD" or "VSS"
// if needed.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire [7:0] nGPIODIR;
// GPIO o/p enable

wire [7:0] GPIODATA;
// GPIO o/p pin/status

wire [7:0] GPINSync2;
// GPIO i/p pin/status

wire [7:0] GPIOAFSEL;
// Alt. Funct. selec

wire [7:0] GPIOIS;
// GPIO int. sense

wire [7:0] GPIOIEV;
// GPIO int. event

wire [7:0] GPIOIC;
// GPIO int. clear

wire [7:0] GPIOIBE;
// GPIO interrupt both edges

wire [7:0] GPIORIS;
// GPIO RAW int status

wire       GPIOITCR;

wire [7:0] GPIOITIP1;
wire [7:0] GPIOITIP2;
wire [7:0] GPIOITOP3;

wire [7:0] nGPAFENtst;
wire [7:0] GPAFOUTtst;
wire [7:0] GPAFINtst;

wire [3:0] TieOff1;
// Static input to the block GpioRevAnd

wire [3:0] TieOff2;
// Static input to the block GpioRevAnd

wire [3:0] Revision;
// Output from GpioRevAnd block (Used for register read in GpioApbif)

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

// ---------------------------------------------------------------------
// Assign the Revision number
// ---------------------------------------------------------------------
assign TieOff1          = 4'b0000;
assign TieOff2          = 4'b0000;

// ---------------------------------------------------------------------
// GpioApbif
// This block is the APB interface for the Gpio. This block generates
// the address decodes for the different registers during APB reads and
// writes. It also contains the different registers in the Gpio.
// ---------------------------------------------------------------------
GpioApbif uGpioApbif              (
                    .PCLK         (PCLK),
                    .PRESETn      (PRESETn),
                    .PSEL         (PSEL),
                    .PENABLE      (PENABLE),
                    .PWRITE       (PWRITE),
                    .PWDATA       (PWDATA),
                    .PADDR        (PADDR),
                    .PRDATA       (PRDATA),
                    .nGPIODIR     (nGPIODIR),
                    .GPIODATA     (GPIODATA),
                    .GPINSync2    (GPINSync2),
                    .GPIOAFSEL    (GPIOAFSEL),
                    .GPIOIS       (GPIOIS),
                    .GPIOIEV      (GPIOIEV),
                    .GPIOIC       (GPIOIC),
                    .GPIOIBE      (GPIOIBE),
                    .GPIORIS      (GPIORIS),
                    .GPIOINTR     (GPIOINTR),
                    .GPIOMIS      (GPIOMIS),
                    .GPIOITCR     (GPIOITCR),
                    .GPIOITIP1    (GPIOITIP1),
                    .GPIOITIP2    (GPIOITIP2),
                    .GPIOITOP3    (GPIOITOP3),
                    .nGPAFENtst   (nGPAFENtst),
                    .GPAFOUTtst   (GPAFOUTtst),
                    .GPAFINtst    (GPAFINtst),
                    .Revision     (Revision)
                     );

// ---------------------------------------------------------------------
// GpioAfmis the Alternate Functionality Multiplexer for the Gpio.
//
// ---------------------------------------------------------------------
GpioAfm uGpioAfm                 (
                    .PCLK        (PCLK),
                    .PRESETn     (PRESETn),
                    .GPIOAFSEL   (GPIOAFSEL),
                    .nGPEN       (nGPEN),
                    .GPOUT       (GPOUT),
                    .GPIN        (GPIN),
                    .nGPIODIR    (nGPIODIR),
                    .GPIODATA    (GPIODATA),
                    .GPINSync2   (GPINSync2),
                    .nGPAFEN     (nGPAFEN),
                    .GPAFOUT     (GPAFOUT),
                    .GPAFIN      (GPAFIN),
                    .GPIOITCR    (GPIOITCR),
                    .GPIOITIP1   (GPIOITIP1),
                    .GPIOITIP2   (GPIOITIP2),
                    .GPIOITOP3   (GPIOITOP3),
                    .nGPAFENtst  (nGPAFENtst),
                    .GPAFOUTtst  (GPAFOUTtst),
                    .GPAFINtst   (GPAFINtst)
                     );

// ---------------------------------------------------------------------
// GpioInt is the Interrupt Generation Logic within the GPIO
//
// ---------------------------------------------------------------------
GpioInt uGpioInt               (
                    .PCLK      (PCLK),
                    .PRESETn   (PRESETn),
                    .GPIN      (GPIN),
                    .nGPIODIR  (nGPIODIR),
                    .GPIODATA  (GPIODATA),
                    .GPINSync2 (GPINSync2),
                    .GPIOAFSEL (GPIOAFSEL),
                    .GPIOIS    (GPIOIS),
                    .GPIOIEV   (GPIOIEV),
                    .GPIOIC    (GPIOIC),
                    .GPIOIBE   (GPIOIBE),
                    .GPIORIS   (GPIORIS)
                     );

// ---------------------------------------------------------------------
// 1st instantiation of GpioRevAnd
// ---------------------------------------------------------------------
GpioRevAnd  u0GpioRevAnd        (
                    .TieOff1    (TieOff1[0]),
                    .TieOff2    (TieOff2[0]),
                    .Revision   (Revision[0])
                     );

// ---------------------------------------------------------------------
// 2nd instantiation of GpioRevAnd
// ---------------------------------------------------------------------
GpioRevAnd  u1GpioRevAnd        (
                    .TieOff1    (TieOff1[1]),
                    .TieOff2    (TieOff2[1]),
                    .Revision   (Revision[1])
                     );

// ---------------------------------------------------------------------
// 3rd instantiation of GpioRevAnd
// ---------------------------------------------------------------------
GpioRevAnd  u2GpioRevAnd        (
                    .TieOff1    (TieOff1[2]),
                    .TieOff2    (TieOff2[2]),
                    .Revision   (Revision[2])
                     );

// ---------------------------------------------------------------------
// 4th instantiation of GpioRevAnd
// ---------------------------------------------------------------------
GpioRevAnd  u3GpioRevAnd        (
                    .TieOff1    (TieOff1[3]),
                    .TieOff2    (TieOff2[3]),
                    .Revision   (Revision[3])
                     );

endmodule

// --============================== End ==============================--
