//  ====================================================================
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
//  File Name              : GpioAfm.v.rca
//  File Revision          : 1.1
//
//  Release Information    : PrimeCell(TM)-PL061-REL1v0
//
//  --------------------------------------------------------------------
//
// ---------------------------------------------------------------------
// Purpose                 : GpioAfm is the Alternate Functionality
//                           Multiplexer for the Gpio.
//
// =====================================================================

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module GpioAfm_jj (
// Inputs
                PCLK,
                PRESETn,
                GPIOAFSEL,
                GPIN,
                nGPIODIR,
                GPIODATA,
                nGPAFEN,
                GPAFOUT,
                GPIOITCR,
                GPIOITIP1,
                GPIOITIP2,
                GPIOITOP3,

// Outputs
                nGPEN,
                GPOUT,
                GPINSync2,
                GPAFIN,
                nGPAFENtst,
                GPAFOUTtst,
                GPAFINtst
                );

// Inputs
input        PCLK;        // APB clock
input        PRESETn;     // AMBA reset
input  [7:0] GPIOAFSEL;   // Alter.Functi. selec
input  [7:0] GPIN;        // GPIO i/p pin/status
input  [7:0] nGPIODIR;    // GPIO o/p enable
input  [7:0] GPIODATA;    // GPIO o/p pin/status
input  [7:0] nGPAFEN;     // GPIO o/p enable
input  [7:0] GPAFOUT;     // GPIO o/p pin/status
input        GPIOITCR;    // GPIO Test Ctrl. reg
input  [7:0] GPIOITIP1;   // Integr. test i/p 1
input  [7:0] GPIOITIP2;   // Integr. test i/p 2
input  [7:0] GPIOITOP3;   // Integr. test o/p 3

// Outputs
output [7:0] nGPEN;       // GPIO o/p enable
output [7:0] GPOUT;       // GPIO o/p pin/status

output [7:0] GPINSync2;   // GPIO i/p pin/status

output [7:0] GPAFIN;      // GPIO i/p pin/status

output [7:0] nGPAFENtst;  // I. test i/p 1 Read
output [7:0] GPAFOUTtst;  // I. test i/p 2 Read
output [7:0] GPAFINtst;   // I. test o/p 3 Read

// Inputs
wire        PCLK;        // APB clock
wire        PRESETn;     // AMBA reset
wire  [7:0] GPIOAFSEL;   // Alter.Functi. selec
wire  [7:0] GPIN;        // GPIO i/p pin/status
wire  [7:0] nGPIODIR;    // GPIO o/p enable
wire  [7:0] GPIODATA;    // GPIO o/p pin/status
wire  [7:0] nGPAFEN;     // GPIO o/p enable
wire  [7:0] GPAFOUT;     // GPIO o/p pin/status
wire        GPIOITCR;    // GPIO Test Ctrl. reg
wire  [7:0] GPIOITIP1;   // Integr. test i/p 1
wire  [7:0] GPIOITIP2;   // Integr. test i/p 2
wire  [7:0] GPIOITOP3;   // Integr. test o/p 3

// Outputs
reg   [7:0] nGPEN;       // GPIO o/p enable
reg   [7:0] GPOUT;       // GPIO o/p pin/status
reg   [7:0] GPINSync2;   // GPIO i/p pin/status

wire  [7:0] GPAFIN;      // GPIO i/p pin/status
wire  [7:0] nGPAFENtst;  // I. test i/p 1 Read
wire  [7:0] GPAFOUTtst;  // I. test i/p 2 Read
wire  [7:0] GPAFINtst;   // I. test o/p 3 Read

// ---------------------------------------------------------------------
//
//                           GpioAfm
//                           =======
//
//----------------------------------------------------------------------
//
// Overview
// ========
// APB interface and alternate functionality lines are multiplexed to
// share GPIO pins. All GPIO lines can be individually configured
// as input or outputs, and interrupts be generated dependent upon their
// level or transitional status.
//
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// Constant Declaration
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// Wire Declarations
//----------------------------------------------------------------------

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg [7:0] GPINSync1;
// GPIN first stage of synchronization

reg [7:0] iGPAFIN;

reg [7:0] GPAFINorig;
// Auxiliar signal image of GPIN when GPIOAFSEL == 1 used for
// integration vectors tests

reg [7:0] iGPAFOUTtst;
// local copy of

reg [7:0] inGPAFENtst;
// local copy of

integer i;
// Internal Loop variable

//----------------------------------------------------------------------
//
// Main body of  code
// ==================
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Implementation of the GPIO Output Enable MUX
//----------------------------------------------------------------------
always @(nGPIODIR or inGPAFENtst or GPIOAFSEL)
begin : p_Gpen_comb
  for (i = 7; i >= 0; i = i - 1)
    begin
      if (GPIOAFSEL[i] == 1'b1)
        nGPEN[i] = inGPAFENtst[i];
      else
        nGPEN[i] = nGPIODIR[i];
    end
end // p_Gpen_comb;

//----------------------------------------------------------------------
// Implementation of the GPIO Output MUX
//----------------------------------------------------------------------

always @(GPIODATA or iGPAFOUTtst or GPIOAFSEL)
begin : p_Gpout_comb
  for (i = 7; i >= 0; i = i - 1)
    begin
      if (GPIOAFSEL[i] == 1'b1)
        GPOUT[i] = iGPAFOUTtst[i];
      else
        GPOUT[i] = GPIODATA[i];
    end
end // p_Gpout_comb;

//----------------------------------------------------------------------
// Implementation of the GPIO APB Input MUX
// GPINSync2 is the synchronized(PCLK) version of GPIN after being
// protected against metastability.
//----------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_GPINsync1_seq
 if (PRESETn == 1'b0)
   GPINSync1 <= 8'b00000000;
 else
   GPINSync1 <= GPIN;
end // p_GPINsync1_seq;

always @(posedge PCLK or negedge PRESETn)
begin : p_GPINsync2_seq
 if (PRESETn == 1'b0)
   GPINSync2 <= 8'b00000000;
 else
   GPINSync2 <= GPINSync1;
end // p_GPINsync2_seq;

//----------------------------------------------------------------------
// Implementation of the GPIO AF Input MUX
//----------------------------------------------------------------------
always @(GPIN or GPIOAFSEL)
begin : p_Gpafinorig_comb
  for (i = 7; i >= 0; i = i - 1)
    begin
      if (GPIOAFSEL[i] == 1'b1)
        GPAFINorig[i] = GPIN[i];
      else
        GPAFINorig[i] = 1'b0;
    end
end // p_Gpafinorig_comb;

//----------------------------------------------------------------------
// Implementation of the GPIO Integr. test i/p 1
//----------------------------------------------------------------------
always @(GPIOITCR or GPIOITIP1 or GPAFOUT)
begin : p_Gpafouttst_comb
  if (GPIOITCR == 1'b1)
    iGPAFOUTtst = GPIOITIP1;
  else
    iGPAFOUTtst = GPAFOUT;
end // p_Gpafouttst_comb;

assign GPAFOUTtst = iGPAFOUTtst;

//----------------------------------------------------------------------
// Implementation of the GPIO Integr. test i/p 2
//----------------------------------------------------------------------

always @(GPIOITCR or GPIOITIP2 or nGPAFEN)
begin : p_nGpafentst_comb
  if (GPIOITCR == 1'b1)
    inGPAFENtst = GPIOITIP2;
  else
    inGPAFENtst = nGPAFEN;
end // p_nGpafentst_comb;

assign nGPAFENtst = inGPAFENtst;

//----------------------------------------------------------------------
// Implementation of the GPIO Integr. test o/p 3
//----------------------------------------------------------------------
always @(GPIOITCR or GPIOITOP3 or GPAFINorig)
begin : p_Gpafin_comb
  if (GPIOITCR == 1'b1)
    iGPAFIN = GPIOITOP3;
  else
    iGPAFIN = GPAFINorig;
end // p_Gpafin_comb;

assign GPAFIN = iGPAFIN;
assign GPAFINtst = iGPAFIN;

endmodule

//=============================End of GpioAfm ========================--
