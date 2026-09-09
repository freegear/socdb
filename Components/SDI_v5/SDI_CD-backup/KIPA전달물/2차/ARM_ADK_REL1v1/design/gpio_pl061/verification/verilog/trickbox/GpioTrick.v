// --=================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//----------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : GpioTrick.v.rca
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL061-REL1v0
//
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// Purpose : The Gpio trickbox module performs the following functions:
//           - Generates the input signals for the pins of the Gpio
//           - Generates the input signals for the Alt. Funct. on-chip
//             signals
//           - Reads the status of the output pins and the output enable
//             pins of the Gpio
//           - Reads the status of the output pins and the output enable
//             pins of the Alt. Funct. on-chip signals
//           - Reads the combined and individual interrupt outpus from
//             the Gpio.
// --=================================================================--

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module GpioTrick (
// Inputs
                  PCLK,
                  PRESETn,
                  PENABLE,
                  PSELT,
                  PWRITE,
                  PA,
                  PWData,
                  nGPEN,
                  GPOUT,
                  GPAFIN,
                  GPIOINTR,
                  GPIOMIS,
// Outputs
                  PRData,
                  GPIN,
                  nGPAFEN,
                  GPAFOUT
                 );

// Inputs
input        PCLK;      // APB Clock
input        PRESETn;   // AMBA reset
input        PENABLE;   // APB enable
input        PSELT;     // Trickbox select
input        PWRITE;    // APB write
input  [7:2] PA;        // APB address bus
input  [7:0] PWData;    // APB write databus
input  [7:0] nGPEN;     // GPIO o/p enables
input  [7:0] GPOUT;     // GPIO outputs
input  [7:0] GPAFIN;    // Alt F. inputs
input    GPIOINTR;      // Interrupt output
input  [7:0] GPIOMIS;   // Masked Int Status

// Outputs
output [7:0] PRData;    // APB read databus
output [7:0] GPIN;      // GPIO inputs
output [7:0] nGPAFEN;   // Alt F. o/p enables
output [7:0] GPAFOUT;   // Alt F. outputs

// Inputs
// APB bus signals
wire        PCLK;      // APB Clock
wire        PRESETn;   // AMBA reset
wire        PENABLE;   // APB enable
wire        PSELT;     // Trickbox select
wire        PWRITE;    // APB write
wire  [7:2] PA;        // APB address bus
wire  [7:0] PWData;    // APB write databus

// GPIO lines onto the Pads
wire  [7:0] nGPEN;     // GPIO o/p enables
wire  [7:0] GPOUT;     // GPIO outputs

// Alternate functionality lines
wire  [7:0] GPAFIN;    // Alt F. inputs

// Interrupt output to the Interrupt controller
wire    GPIOINTR;      // Interrupt output
wire  [7:0] GPIOMIS;   // Masked Int Status

// Outputs
// APB bus Output signals
wire [7:0] PRData;    // APB read databus

// GPIO lines onto the Pads
wire [7:0] GPIN;      // GPIO inputs

// Alternate functionality lines
wire [7:0] nGPAFEN;   // Alt F. o/p enables
wire [7:0] GPAFOUT;   // Alt F. outputs

// ---------------------------------------------------------------------
//
//                             GpioTrick
//                             =========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
// The external inputs to the GPIO are generated in this module.
// Inputs to the GPIO are controlled via writes to the appropriate
// registers within the TrickBox.
// The Status of the GPIO Outputs are read through the appropriate
// registers within the TrickBox.
//
// GTENR   : Represents the status of the GPIO Output Enables  :nGPEN
// GTOUT   : Represents the status of the GPIO Outputs         :GPOUT
// GTINR   : Controls via writes the GPIO Inputs               :GPIN
//
// GTAENR  : Controls the GPIO Alt. Funct. Output Enables      :nGPAFEN
// GTAOUTR : Controls the GPIO Alt. Funct. Outputs             :GPAFOUT
// GTAINR  : Represents the status of GPIO Alt. Funct. Inputs  :GPAFIN
//
// GTINT[0]: Represents the status of the Interrupt Output     :GPIOINTR
// GTMIS   : Represents the status of the Masked Int. Outputs  :GPIOMIS
//
//----------------------------------------------------------------------

// ---------------------------------------------------------------------
//  Constant declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//  Wire declarations
// ---------------------------------------------------------------------
wire GTENRdec;
// Decode for GTENR register

wire GTOUTdec;
// Decode for GTOUT register

wire GTINRdec;
// Decode for GTINR  register

wire GTAENRdec;
// Decode for GTAENR register

wire GTAOUTRdec;
// Decode for GTAOUTR register

wire GTAINRdec;
// Decode for GTAINR register

wire GTMISdec;
// Decode for GTINT register

wire GTINTdec;
// Decode for GTINT register

// Read enable strobes for internal registers

wire GTENRrd;
// Read enable for GTENR register

wire GTOUTrd;
// Read enable for GTOUT register

wire GTINRrd;
// Read enable for GTINR  register

wire GTAENRrd;
// Read enable for GTAENR register

wire GTAOUTRrd;
// Read enable for GTAOUTR register

wire GTAINRrd;
// Read enable for GTAINR register

wire GTMISrd;
// Read enable for GTINT register

wire GTINTrd;
// Read enable for GTINT register

// Write enable strobes for internal registers

wire GTINRwr;
// Write enable for GTINR register

wire GTAENRwr;
// Write enable for GTAENR register

wire GTAOUTRwr;
// Write enable for GTAOUTR register

// Read Fill Vector
wire  [7:0] ReadFill;

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
// D-input for internal registers

reg  [7:0] NextGTINR;
// D-input for GTINR register

reg  [7:0] NextGTAENR;
// D-input for GTAENR register

reg  [7:0] NextGTAOUTR;
// D-input for GTAOUTR register

// Internal signals

reg  [7:0] GTINR;
// GPIO inputs

reg  [7:0] GTAENR;
// GPIO Alt F. o/p enables

reg  [7:0] GTAOUTR;
// GPIO Alt F. outputs

//----------------------------------------------------------------------
//
// Main body of code
// =================
//
//----------------------------------------------------------------------

// Assign Read Fill Vector
assign ReadFill = 8'b00000000;

//----------------------------------------------------------------------
// Address Decodes
//----------------------------------------------------------------------

assign GTENRdec   = (PA[4:2] == 'b000) ? 1'b1 : 1'b0;
assign GTOUTdec   = (PA[4:2] == 'b001) ? 1'b1 : 1'b0;
assign GTINRdec   = (PA[4:2] == 'b010) ? 1'b1 : 1'b0;
assign GTAENRdec  = (PA[4:2] == 'b011) ? 1'b1 : 1'b0;
assign GTAOUTRdec = (PA[4:2] == 'b100) ? 1'b1 : 1'b0;
assign GTAINRdec  = (PA[4:2] == 'b101) ? 1'b1 : 1'b0;
assign GTINTdec   = (PA[4:2] == 'b110) ? 1'b1 : 1'b0;
assign GTMISdec   = (PA[4:2] == 'b111) ? 1'b1 : 1'b0;

assign GTENRrd    = PSELT & PENABLE & (~PWRITE) & GTENRdec;
assign GTOUTrd    = PSELT & PENABLE & (~PWRITE) & GTOUTdec;
assign GTINRrd    = PSELT & PENABLE & (~PWRITE) & GTINRdec;
assign GTAENRrd   = PSELT & PENABLE & (~PWRITE) & GTAENRdec;
assign GTAOUTRrd  = PSELT & PENABLE & (~PWRITE) & GTAOUTRdec;
assign GTAINRrd   = PSELT & PENABLE & (~PWRITE) & GTAINRdec;
assign GTINTrd    = PSELT & PENABLE & (~PWRITE) & GTINTdec;
assign GTMISrd    = PSELT & PENABLE & (~PWRITE) & GTMISdec;

assign GTINRwr    = PSELT & PENABLE & PWRITE & GTINRdec;
assign GTAENRwr   = PSELT & PENABLE & PWRITE & GTAENRdec;
assign GTAOUTRwr  = PSELT & PENABLE & PWRITE & GTAOUTRdec;

//----------------------------------------------------------------------
// Implementation of TrickBox Input Register GTINR
//----------------------------------------------------------------------
always @(GTINR or PWData or GTINRwr)
begin : p_GTINRComb
  if (GTINRwr == 1'b1)
    NextGTINR = PWData;
  else
    NextGTINR = GTINR;
end // p_GTINRComb;

always @(posedge PCLK or negedge PRESETn)
begin : p_GTINRSeq
  if (PRESETn == 1'b0)
    GTINR <= 8'b00000000;
  else
    GTINR <= NextGTINR;
end // p_GTINRSeq;

//----------------------------------------------------------------------
// Implementation of TrickBox Input Register GTAENR
//----------------------------------------------------------------------
always @(GTAENR or PWData or GTAENRwr)
begin : p_GTAENRComb
  if (GTAENRwr == 1'b1)
    NextGTAENR = PWData;
  else
    NextGTAENR = GTAENR;
end // p_GTAENRComb;

always @(posedge PCLK or negedge PRESETn)
begin : p_GTAENRSeq
  if (PRESETn == 1'b0)
    GTAENR <= 8'b00000000;
  else
    GTAENR <= NextGTAENR;
end // p_GTAENRSeq;

//----------------------------------------------------------------------
// Implementation of TrickBox Input Register GTAOUTR
//----------------------------------------------------------------------
always @(GTAOUTR or PWData or GTAOUTRwr)
begin : p_GTAOUTRComb
  if (GTAOUTRwr == 1'b1)
    NextGTAOUTR = PWData;
  else
    NextGTAOUTR = GTAOUTR;
end // p_GTAOUTRComb;

always @(posedge PCLK or negedge PRESETn)
begin : p_GTAOUTRSeq
  if (PRESETn == 1'b0)
    GTAOUTR <= 8'b00000000;
  else
    GTAOUTR <= NextGTAOUTR;
end // p_GTAOUTRSeq;

//----------------------------------------------------------------------
// Mux out Read Data onto the APB
//----------------------------------------------------------------------
assign PRData  = (GTENRrd == 1'b1)   ? nGPEN                     :
                 (GTOUTrd == 1'b1)   ? GPOUT                     :
                 (GTINRrd == 1'b1)   ? GTINR                     :
                 (GTAENRrd == 1'b1)  ? GTAENR                    :
                 (GTAOUTRrd == 1'b1) ? GTAOUTR                   :
                 (GTAINRrd == 1'b1)  ? GPAFIN                    :
                 (GTINTrd == 1'b1)   ? {ReadFill[7:1], GPIOINTR} :
                 (GTMISrd == 1'b1)   ?  GPIOMIS                  :
                  ReadFill;

//----------------------------------------------------------------------
// The inputs to the GPIO GPIN are controlled via writes to the GTINR
// register
//----------------------------------------------------------------------
assign GPIN     = GTINR;

//----------------------------------------------------------------------
// The inputs to the GPIO Alt. Funct. Output Enable are controlled via
// writes to the GTAENR register
//----------------------------------------------------------------------

assign nGPAFEN  = GTAENR;

//----------------------------------------------------------------------
// The inputs to the GPIO Alt. Funct. Output are controlled via writes
// to the GTAOUTR register
//----------------------------------------------------------------------

assign GPAFOUT  = GTAOUTR;

endmodule

// ============================== End ================================--
