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
//  File Name              : GpioInt.v.rca
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL061-REL1v0
//
//  --------------------------------------------------------------------
//
// ---------------------------------------------------------------------
// Purpose                 : GpioInt is the Interrupt Generation Logic
//                           within the GPIO
//
// =====================================================================

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module GpioInt_jj (
// Inputs
                PCLK,
                PRESETn,

                GPIN,

                nGPIODIR,
                GPIODATA,
                GPINSync2,

                GPIOAFSEL,

                GPIOIS,
                GPIOIEV,
                GPIOIC,
                GPIOIBE,

// Outputs
                GPIORIS
               );
// Inputs
input        PCLK;       // APB clock
input        PRESETn;    // AMBA reset
input  [7:0] GPIN;       // GPIO I/P pin/status
input  [7:0] nGPIODIR;   // GPIO Data Direction
input  [7:0] GPIODATA;   // GPIO Data
input  [7:0] GPINSync2;  // GPIO Synchr. input
input  [7:0] GPIOAFSEL;  // Alt.Funct. select
input  [7:0] GPIOIS;     // GPIO int. sense
input  [7:0] GPIOIEV;    // GPIO int. event
input  [7:0] GPIOIC;     // GPIO int. clear
input  [7:0] GPIOIBE;    // GPIO int. both edge

// Outputs
output [7:0] GPIORIS;    // GPIO RAW int. status

// Inputs
wire        PCLK;       // APB clock
wire        PRESETn;    // AMBA reset
wire  [7:0] GPIN;       // GPIO I/P pin/status
wire  [7:0] nGPIODIR;   // GPIO Data Direction
wire  [7:0] GPIODATA;   // GPIO Data
wire  [7:0] GPINSync2;  // GPIO Synchr. input
wire  [7:0] GPIOAFSEL;  // Alt.Funct. select
wire  [7:0] GPIOIS;     // GPIO int. sense
wire  [7:0] GPIOIEV;    // GPIO int. event
wire  [7:0] GPIOIC;     // GPIO int. clear
wire  [7:0] GPIOIBE;    // GPIO int. both edge

// Outputs
reg   [7:0] GPIORIS;    // GPIO RAW int. status

//----------------------------------------------------------------------
//
//                           GpioInt
//                           =======
//
//----------------------------------------------------------------------
//
// Overview
// ========
// Three dedicated registers in GpioAbpif  allow selecting the source of
// the interrupt, its polarity and edge properties.
//
//   + GPIOIS
//   + GPIOIBE
//   + GPIOIEV
//
// When one or  more  GPIO lines causes  an interrupt,  an individual as
// well as a combined interrupt output are made available.
//
//   + GPIOMIS(i)
//   + GPIOINTR (Combined Interrupt Output)
//
// Software and/or hardware can detect  the source  of the
// interrupt and then  clear the interrupt (edge case only)  in order to
// enable the circuit  for further interrupts.  For a level case,  it is
// assumed that the external source will hold the level `define for the
// interrupt to be recognized by the processor.
//
// Bits set in GPIORIS  will be  immediate confirmation  that conditions
// established in GPIOIS, GPIOIBE and GPIOIEV have been met. This is not
// enough  to trigger  an interrupt.  Consent must be granted  by GPIOIE
// (Interrupt Mask) before any bit can be set on GPIOMIS (Masked interr.
// Status) and thus triggering the activation of GPIOINTR.
//
//----------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire [7:0] Edge;
// Captured Edge matching characteristics set in the Intrrpt. registers

wire [7:0] async_source;
// Synchronized version of data from Asynchronous sources XP, GPAFIN

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg [7:0] CurrentEdgeVal;
// Less Recent Status of pins.                 (synchronized)

reg [7:0] NextEdgeVal;
// Most recent status of pins.                 (synchronized)

reg [7:0] Edge_hold;
// Captured Edge matching characteristics set in the Intrrpt. registers

reg [7:0] NextEdge_hold;
// D-input of Edge register

reg [7:0] PosEdgeDetected;
// Positive (Rising) edge interrupt

reg [7:0] NegEdgeDetected;
// Negative (Falling) edge interrupt

reg [7:0] BothEdges;
// Both edges (Rising OR Falling) interrupt

reg [7:0] SelEdge;
// Edge matching characteristics selected in the Intrrpt. registers

reg [7:0] Level;
// Level matching characteristics selected in the Intrrpt. registers

integer i;
// Internal Loop variable

//----------------------------------------------------------------------
//
// Main body of code
// =================
//
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// Implementation of Edge Detection Logic
//----------------------------------------------------------------------
//
// async_source being 1'b0 indicates that the APB bus is the source
// of data from which the interrupt edge detection logic must detect
// triggering conditions. As this data is already synchronized to
// PCLK the synchronization stage in GpioAfm is by-passed and the
// Data is obtained directly from GPIODATA.

//nGPIODIR: 1=> Input Mode or Hardware Select |0=>Output Mode
assign async_source = nGPIODIR | GPIOAFSEL;

//----------------------------------------------------------------------
// Implementation of no-toggling input lines
// In the edge interrupt detection logic GPINSync2 represents the
// synchronized level state of the pins.
// When no edges are required to be detected this combinatorial
// process will held the last synchronized value in GPINSync2.
//----------------------------------------------------------------------

always @(GPIOIS or async_source or GPIODATA or
			     GPINSync2 or CurrentEdgeVal)
begin : p_EdgeDetect_comb
  for (i = 7; i >= 0; i = i - 1)
    begin
      if (GPIOIS[i] == 1'b1)  //Level
        NextEdgeVal[i] = CurrentEdgeVal[i];
      else if (async_source[i] == 1'b1) //Trigger,Input or Hardware mode
        NextEdgeVal[i] = GPINSync2[i];
      else                              //Trigger,Output and Software mode
        NextEdgeVal[i] = GPIODATA[i];	
    end
end // p_EdgeDetect_comb;

always @(posedge PCLK or negedge PRESETn)
begin : p_EdgeDetect_seq
 if (PRESETn == 1'b0)
    CurrentEdgeVal <= 8'b00000000;
  else
    CurrentEdgeVal <= NextEdgeVal;
end // p_EdgeDetect_seq;

//-------------------------------------------------------------------
// Decode pos edge, neg edge and both edge interrupts
//-------------------------------------------------------------------

always @(CurrentEdgeVal or NextEdgeVal)
begin : p_PosEdge_comb
  for (i = 7; i >= 0; i = i - 1)
    PosEdgeDetected[i] = NextEdgeVal[i] & (~CurrentEdgeVal[i]);
end // p_PosEdge_comb;

always @(CurrentEdgeVal or NextEdgeVal)
begin : p_NegEdge_comb
  for (i = 7; i >= 0; i = i - 1)
    NegEdgeDetected[i] = (~NextEdgeVal[i]) & CurrentEdgeVal[i];
end // p_NegEdge_comb;

always @(PosEdgeDetected or NegEdgeDetected)
begin : p_BothEdge_comb
  for (i = 7; i >= 0; i = i - 1)
    BothEdges[i] = PosEdgeDetected[i] | NegEdgeDetected[i];
end // p_BothEdge_comb;

//-----------------------------------------------------------------
// Selects edge interrupt. The interrupt always represents by an
// active high signal required by the interrupt controller.
//-----------------------------------------------------------------
always @(GPIOIEV or GPIOIBE or PosEdgeDetected or
                           NegEdgeDetected or BothEdges)
begin : p_SelEdge_comb
  for (i = 7; i >= 0; i = i - 1)
    begin
      if (GPIOIBE[i] == 1'b1)
        SelEdge[i] = BothEdges[i];
      else if (GPIOIEV[i] == 1'b1)
        SelEdge[i] = PosEdgeDetected[i];
      else
        SelEdge[i] = NegEdgeDetected[i];
    end
end // p_SelEdge_comb;

//-----------------------------------------------------------------
// Implementation of Level-Detected Interrupt circuitry
// Holds an active signal while the external device holds the
// appropriate level.
//-----------------------------------------------------------------
always @(GPIN or GPIOIEV)
begin : p_SelLevel_comb
  for (i = 7; i >= 0; i = i - 1)
    begin
      if (GPIOIEV[i] == GPIN[i])
        Level[i] = 1'b1;
      else
        Level[i] = 1'b0;
    end
end // p_SelLevel_comb;

//-----------------------------------------------------------------
// Implementation of Edge-Detected Holding circuitry
// Holds the edge interrupt until the SW clear the interrupt or an
// reset occures
//-----------------------------------------------------------------
always @(SelEdge or Edge_hold or GPIOIC)
begin : p_HoldEdge_comb
  for (i = 7; i >= 0; i = i - 1)
    begin
      if (GPIOIC[i] == 1'b1)
        NextEdge_hold[i] = 1'b0;
      else if (SelEdge[i] == 1'b1)
        NextEdge_hold[i] = 1'b1;
      else
        NextEdge_hold[i] = Edge_hold[i];
    end
end // p_HoldEdge_comb;

always @(posedge PCLK or negedge PRESETn)
begin : p_HoldEdge_seq
 if (PRESETn == 1'b0)
    Edge_hold <= 8'b00000000;
  else
    Edge_hold <= NextEdge_hold;
end // p_HoldEdge_seq;

//-----------------------------------------------------------------
// Implementation of Edge
// Signals and edge event matching the requirements
// and is hold HIGH by the Edge-Detected Holding circuitry.
//-----------------------------------------------------------------

assign Edge = (Edge_hold) | (SelEdge);

//-----------------------------------------------------------------
// Implementation GPIORIS
// Holds the edge interrupt until the SW clear the interrupt or an
// reset occures or it holds the level interrupt while the external
// device drives such level on the pin.
//-----------------------------------------------------------------
always @(Edge or Level or GPIOIS)
begin : p_GpioRis_comb
  for (i = 7; i >= 0; i = i - 1)
    begin
      if (GPIOIS[i] == 1'b0)
        GPIORIS[i] = Edge[i];
      else
        GPIORIS[i] = Level[i];
    end
end // p_GpioRis_comb;

endmodule

//=========================== End of GpioInt =========================--
