// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : ClcdGS.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//  ----------------------------------------------------------------------------
//  Purpose                : LCD greyscaler logic 
//         
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------
module ClcdGS (
// Inputs
               CLCDCLK, 
               nCLCLKRESET, 
               PixelRed, 
               PixelGreen, 
               PixelBlue,
               LcdEn, 
               LcdTFT, 
               FifoEn, 
               PixelAvail, 
               StartRow,
               LcdDual,
               EndFrame, 
               PPL, 
               UpFormFifoFull,
               LpFormFifoFull, 
               AhbMBESyncLclk,

// Outputs

               Toggle,
               PixelEn, 
               UpRGS, 
               UpGGS, 
               UpBGS,
               LpRGS,
               LpGGS,
               LpBGS,
               UpPixelEn, 
               LpPixelEn
              ); 

input         CLCDCLK;        // Clock input
input         nCLCLKRESET;    // system reset input
input         LcdEn;          // Enable Lcd Controller
input         LcdTFT;         // Enable TFT mode
input         LcdDual;        // Enable Dual panel mode
input         FifoEn;         // Fifo read (passive) or enable (TFT) 
input         PixelAvail;     // Pixel valid from palettiser  
input         StartRow;       // Start of active line from timing module
input         EndFrame;       // End frame from timing module
input [9:4]   PPL;            // number of pixels per line
input         UpFormFifoFull; // Upper panel Formatter Fifo Full
input         LpFormFifoFull; // Lower panel Formatter Fifo Full
input [3:0]   PixelRed;       // Palettised pixel data - Red  
input [3:0]   PixelGreen;     // Palettised pixel data - Green 
input [3:0]   PixelBlue;      // Palettised pixel data - Blue
input         AhbMBESyncLclk; // AHB Master Error interrupt

output        PixelEn;        // Pixel Enable to the Unpacker/FIFO
output        UpPixelEn;      // Pixel Enable to Upper Panel Formater
output        LpPixelEn;      // Pixel Enable to Lower Panel Formater
output        UpRGS;          // Upper panel greyscaled pixel out - Red
output        UpGGS;          // Upper panel greyscaled pixel out - Green
output        UpBGS;          // Upper panel greyscaled pixel out - Blue
output        LpRGS;          // Lower panel greyscaled pixel out - Red
output        LpGGS;          // Lower panel greyscaled pixel out - Green
output        LpBGS;          // Lower panel greyscaled pixel out - Blue
output        Toggle;         // Dual Mode Toggle bit to UnPacker

// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module provides 15 shades of greyscaling for each colour.
// In TFT mode the greyscaling logic is bypassed and it generates enable signal
// for the front end of the data path.
// Contains the following logic:
// - State machine to control greyscaling and data path enable.
// - 2,5,9,15 frame phase accumulator(counter).
// - 2,5,9,15 row phase accumulator(counter).
// - 2,5,9,15 coloumn phase accumulator(counter).

// -----------------------------------------------------------------------------
// state machine states
// -----------------------------------------------------------------------------
`define GSIDLE     2'b00    // Idle state
`define GSACTIVE   2'b01    // Active state
`define GSWAITROW  2'b10    // Wait for New row state
`define GSENDFRAME 2'b11    // End of frame state

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire          CLCDCLK;          
// clock input                                      (Module input)

wire          nCLCLKRESET;       
// System reset                                     (Module input)

wire          LcdEn;         
// Enable Lcd controller                            (Module input)

wire          LcdTFT;           
// Enable TFT mode                                  (Module input)

wire          LcdDual;      
// Enable Dual panel mode                           (Module input)

wire          FifoEn;        
// Fifo read (passive) or enable (TFT)              (Module input)

wire          PixelAvail;     
// Pixel valid from palettiser                      (Module input)

wire          StartRow;     
// Start of active line from timing module          (Module input)

wire          EndFrame;     
// End of frame from timing module                  (Module input)

wire  [9:4]   PPL;   
// number of pixels per line                        (Module input)

wire          UpFormFifoFull; 
// Upper panel Formatter Fifo Full                  (Module input)

wire          LpFormFifoFull; 
//Lower panel Formatter Fifo Full                   (Module input)

wire  [3:0]   PixelRed;   
// Palettised pixel data - Red                      (Module input)

wire  [3:0]   PixelGreen; 
// Palettised pixel data - Green                    (Module input)

wire  [3:0]   PixelBlue;  
// Palettised pixel data - Blue                     (Module input)

wire          AhbMBESyncLclk;    
// AHB Master Error interrupt                       (Module input)

wire          RowOp;
// load row counters with the next value

wire          PixelEn;
// enable Unpacker/palettiser                       (Module output)

wire          FormFifFull;
// Output FIFO full: MUX output of LpFormFifoFull and UpFormFifoFull signal

wire           UpPixelEn;
// Pixel valid signal to upper panel formatter      (Module output)

wire           LpPixelEn; 
// Pixel valid signal to lower panel formatter      (Module output)

wire          GSEnable;
// Enable greyscaler

wire          GSEnableInt;
// Internal version of GSEnable

wire          PixCountIncEn;
// Enable Pixel counter incrementing

wire [13:1] GreysU;
// 13 bit greyscales output from the state machine for upper panel 

wire [13:1] GreysL;
// 13 bit greyscales output from the state machine for lower  panel 

wire       IntFormFifoFull;
// Internal Format Fifo Full
 

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg [9:0]     PixCount;
// register for Pixel per line counter

reg [9:0]     NextPixCount;
// D-input of Pixel counter

reg [1:0]     GSState;
// register for greyscaler state machine state

reg [1:0]     NextGSState;
// D-input of greyscaler state register

reg           ClockRow;
// enable signal for row counter clocking

reg           NextClockRow;
// D-input of ClockRow register

reg           LoadRow;  
// load row counters with the new value

reg           NextLoadRow;  
// D-input of LoadRow register

reg           DelPixelEn;
// delayed version of PixelEn signal.
// used as enable for formatter shift register in STN mode.

reg           LcdRun; 
// Lcd Controller is active 

reg           NextLcdRun; 
// D-input of LcdRun register

reg           DGSEnable;
// delayed version of GSEnable

reg           Toggle;
// Dual mode toggle signal

reg           NextToggle;
// D-input of Toggle

reg           LoadCol;  
// Load Column counters with the new value of Row counters

reg          Fp2;
// State register for greyscaler frame phase 2-state state machine

reg   [2:0]  Fp5;
// State register for greyscaler frame phase 5-state state machine

reg   [3:0]  Fp9;
// State register for greyscaler frame phase 9-state state machine

reg   [3:0]  Fp15;
// State register for greyscaler frame phase 15-state state machine
 
reg          Trp2;
//  register for temporary row state

reg   [2:0]  Trp5;
//  register for temporary row state

reg   [3:0]  Trp9;
//  register for temporary row state

reg   [3:0]  Trp15;
//  register for temporary row state

reg          Urp2;
// Register for greyscaler row phase 2-state counter(upper panel)

reg   [2:0]  Urp5;
// Register for greyscaler row phase 5-state counter(upper panel)

reg   [3:0]  Urp9;
// Register for greyscaler row phase 9-state counter(upper panel)

reg   [3:0]  Urp15;
// Register for greyscaler row phase 15-state counter(upper panel)

reg          Ucp2;
// Register for greyscaler coloumn phase 2-state counter(upper panel)

reg   [2:0]  Ucp5;
// Register for greyscaler coloumn phase 5-state counter(upper panel)

reg   [3:0]  Ucp9;
// Register for greyscaler coloumn phase 9-state counter(upper panel)

reg   [3:0]  Ucp15;
// Register for greyscaler coloumn phase 15-state counter(upper panel)

reg          Lrp2;
// Register for greyscaler row phase 2-state counter(lower panel)

reg   [2:0]  Lrp5;
// Register for greyscaler row phase 5-state counter(lower panel)

reg   [3:0]  Lrp9;
// Register for greyscaler row phase 9-state counter(lower panel)

reg   [3:0]  Lrp15;
// Register for greyscaler row phase 15-state counter(lower panel)

reg          Lcp2;
// Register for greyscaler coloumn phase 2-state counter(lower panel)

reg   [2:0]  Lcp5;
// Register for greyscaler coloumn phase 5-state counter(lower panel)

reg   [3:0]  Lcp9;
// Register for greyscaler coloumn phase 9-state counter(lower panel)

reg   [3:0]  Lcp15;
// Register for greyscaler coloumn phase 15-state counter(lower panel)

reg          NextFp2;
// D-input of Fp2 register

reg  [2:0]   NextFp5;
// D-input of Fp5 register

reg  [3:0]   NextFp9;
// D-input of Fp9 register

reg  [3:0]   NextFp15;
// D-input of Fp15 register

reg          NextUrp2;
// D-input of Urp2 register

reg  [2:0]   NextUrp5;
// D-input of Urp5 register

reg  [3:0]   NextUrp9;
// D-input of Urp9 register

reg  [3:0]   NextUrp15;
// D-input of Urp15 register

reg          NextUcp2;
// D-input of Ucp2 register

reg  [2:0]   NextUcp5;
// D-input of Ucp5 register

reg  [3:0]   NextUcp9;
// D-input of Ucp9 register

reg  [3:0]   NextUcp15;
// D-input of Ucp15 register

reg          NextTrp2;
// D-input of Trp2 register

reg  [2:0]   NextTrp5;
// D-input of Trp5 register

reg  [3:0]   NextTrp9;
// D-input of Trp9 register

reg  [3:0]   NextTrp15;
// D-input of Trp15 register

reg          NextLrp2;
// D-input of Lrp2 register

reg  [2:0]   NextLrp5;
// D-input of Lrp5 register

reg  [3:0]   NextLrp9;
// D-input of Lrp9 register

reg  [3:0]   NextLrp15;
// D-input of Lrp15 register

reg          NextLcp2;
// D-input of Lcp2 register

reg  [2:0]   NextLcp5;
// D-input of Lcp5 register

reg  [3:0]   NextLcp9;
// D-input of Lcp9 register

reg  [3:0]   NextLcp15;
// D-input of Lcp15 register

reg          DelFormFifFull1;
// Delayed internal version of formatter fifo full signal

reg          DelFormFifFull2;
// Delayed internal version of formatter fifo full signal

reg          GspixSelect;
// Greyscaer pixel select signal. this signal is used for de-multiplexing of 
// pixel enable signals.

reg          NextGspixSelect;
// D-input of GspixSelect

// -----------------------------------------------------------------------------
// function for five frame duty cycle frame phase accumulator
// -----------------------------------------------------------------------------
function [2:0]  IncFrame5;
input [2:0] Fp5;
reg [2:0] Result;
begin
  case (Fp5)
    3'b000 :
      Result = 3'b010;
    3'b010 :
      Result = 3'b001;
    3'b001 :
      Result = 3'b100;
    3'b100 :
      Result = 3'b011;
    3'b011 :
      Result = 3'b000;
    default  :
      begin
        Result = 3'b000;
      end
  endcase
 
  IncFrame5 =  Result;
end
endfunction // IncFrame5  
 
// -----------------------------------------------------------------------------
// function for nine frame duty cycle frame phase accumulator
// -----------------------------------------------------------------------------
function [3:0]  IncFrame9;
 
input [3:0] Fp9;
reg [3:0] Result;
begin
  case (Fp9)
    4'b0000 :
      Result = 4'b1001;
    4'b1001 :  
      Result = 4'b0001;
    4'b0001 :  
      Result = 4'b1000;
    4'b1000 :  
      Result = 4'b0010;
    4'b0010 :  
      Result = 4'b1011;
    4'b1011 :  
      Result = 4'b0100;
    4'b0100 :  
      Result = 4'b1010;
    4'b1010 :  
      Result = 4'b0101;
    4'b0101 :  
      Result = 4'b0000;
    default  :
      begin
        Result = 4'b0000;
      end
  endcase
 
  IncFrame9 =  Result;
end
endfunction // IncFrame9
  
 
// -----------------------------------------------------------------------------
// function for fifteen frame duty cycle frame phase accumulator
// -----------------------------------------------------------------------------
function [3:0]  IncFrame15;
 
input [3:0] Fp15;
reg [3:0] Result;
begin
  case (Fp15)
    4'b1111 :
      Result = 4'b0111;
    4'b0111 :
      Result = 4'b1110;
    4'b1110 :
      Result = 4'b0110;
    4'b0110 :
      Result = 4'b1101;
    4'b1101 :
      Result = 4'b0101;
    4'b0101 :
      Result = 4'b1100;
    4'b1100 :
      Result = 4'b0100;
    4'b0100 :
      Result = 4'b1011;
    4'b1011 :
      Result = 4'b0011;
    4'b0011 :
      Result = 4'b1010;
    4'b1010 :
      Result = 4'b0010;
    4'b0010 :
      Result = 4'b1001;
    4'b1001 :
      Result = 4'b0001;
    4'b0001 :
      Result = 4'b1000;
    4'b1000 :
      Result = 4'b1111; 
    default  :
      begin
        Result = 4'b1111;
      end
  endcase
 
  IncFrame15 =  Result;
end
endfunction // IncFrame15

// -----------------------------------------------------------------------------
// function for five frame duty cycle row phase accumulator
// -----------------------------------------------------------------------------
function [2:0]  IncRow5;
 
input [2:0] Rp5;
reg [2:0] Result;
begin
  case (Rp5)
    3'b000 :
      Result = 3'b001;
    3'b001 :
      Result = 3'b011;
    3'b011 :
      Result = 3'b010;
    3'b010 :
      Result = 3'b100;
    3'b100 :
      Result = 3'b000;
    default  :
      begin
        Result = 3'b000;
      end
  endcase
 
  IncRow5 =  Result;
end
endfunction

// -----------------------------------------------------------------------------
// function for nine frame duty cycle row phase accumulator
// -----------------------------------------------------------------------------
function [3:0]  IncRow9;
 
input [3:0] Rp9;
reg [3:0] Result;
begin
  case (Rp9)
    4'b0000 :
      Result = 4'b0010;
    4'b0010 :
      Result = 4'b0101;
    4'b0101 :
      Result = 4'b1000;
    4'b1000 :
      Result = 4'b1010;
    4'b1010 :
      Result = 4'b0001;
    4'b0001 :
      Result = 4'b0100;
    4'b0100 :
      Result = 4'b1001;
    4'b1001 :
      Result = 4'b1011;
    4'b1011 :
      Result = 4'b0000;
    default  :
      begin
        Result = 4'b0000;
      end
  endcase
 
  IncRow9 =  Result;
end
endfunction
 
// -----------------------------------------------------------------------------
// function for fifteen frame duty cycle row phase accumulator
// -----------------------------------------------------------------------------
function [3:0]  IncRow15;
 
input [3:0] Rp15;
reg [3:0] Result;
begin
  case (Rp15)
    4'b1111 :
      Result = 4'b1100;
    4'b1100 :
      Result = 4'b1001;
    4'b1001 :
      Result = 4'b0110;
    4'b0110 :
      Result = 4'b0011;
    4'b0011 :
      Result = 4'b1111;
    4'b1110 :
      Result = 4'b1011;
    4'b1011 :
      Result = 4'b1000;
    4'b1000 :
      Result = 4'b0101;
    4'b0101 :
      Result = 4'b0010;
    4'b0010 :
      Result = 4'b1110;
    4'b1101 :
      Result = 4'b1010;
    4'b1010 :
      Result = 4'b0111;
    4'b0111 :
      Result = 4'b0100;
    4'b0100 :
      Result = 4'b0001;
    4'b0001 :
      Result = 4'b1101;
    default  :
      begin
        Result = 4'b1111;
      end
  endcase
 
  IncRow15 =  Result;
end
endfunction

// -----------------------------------------------------------------------------
// function for five frame duty cycle coloumn phase accumulator
// -----------------------------------------------------------------------------
function [2:0]  IncCol5;
 
input [2:0] Cp5;
reg [2:0] Result;
begin
  case (Cp5)
    3'b000 :
      Result = 3'b001;
    3'b001 :
      Result = 3'b011;
    3'b011 :
      Result = 3'b010;
    3'b010 :
      Result = 3'b100;
    3'b100 :
      Result = 3'b000;
    default  :
      begin
        Result = 3'b000;
      end
  endcase
 
  IncCol5 =  Result;
end
endfunction

// -----------------------------------------------------------------------------
// function for nine frame duty cycle coloumn phase accumulator
// -----------------------------------------------------------------------------
function [3:0]  IncCol9;
 
input [3:0] Cp9;
reg [3:0] Result;
begin
  case (Cp9)
    4'b0000 :
      Result = 4'b0001;
    4'b0001 :
      Result = 4'b0010;
    4'b0010 :
      Result = 4'b0100;
    4'b0100 :
      Result = 4'b0101;
    4'b0101 :
      Result = 4'b1001;
    4'b1001 :
      Result = 4'b1000;
    4'b1000 :
      Result = 4'b1011;
    4'b1011 :
      Result = 4'b1010;
    4'b1010 :
      Result = 4'b0000;
    default  :
      begin
        Result = 4'b0000;
      end
  endcase
 
  IncCol9 =  Result;
end
endfunction

// -----------------------------------------------------------------------------
// function for fifteen frame duty cycle coloumn phase accumulator
// -----------------------------------------------------------------------------
function [3:0]  IncCol15;
 
input [3:0] Cp15;
reg [3:0] Result;
begin
  case (Cp15)
    4'b1111 :
      Result = 4'b1110;
    4'b1110 :
      Result = 4'b1101;
    4'b1101 :
      Result = 4'b1100;
    4'b1100 :
      Result = 4'b1011;
    4'b1011 :
      Result = 4'b1010;
    4'b1010 :
      Result = 4'b1001;
    4'b1001 :
      Result = 4'b1000;
    4'b1000 :
      Result = 4'b0111;
    4'b0111 :
      Result = 4'b0110;
    4'b0110 :
      Result = 4'b0101;
    4'b0101 :
      Result = 4'b0100;
    4'b0100 :
      Result = 4'b0011;
    4'b0011 :
      Result = 4'b0010;
    4'b0010 :
      Result = 4'b0001;
    4'b0001 :
      Result = 4'b1111;
    default  :
      begin
        Result = 4'b1111;
      end
  endcase
 
  IncCol15 =  Result;
end
endfunction

// -----------------------------------------------------------------------------
//  Define the 16 grey-scales, as a function of the outputs of the column
//  phase accumulators
// -----------------------------------------------------------------------------
function [13:1]  Greyscale;
 
input Cp2;
input [2:0] Cp5;
input [3:0] Cp9;
input [3:0] Cp15;
reg [13:1] Result;

begin
  Result[1] = Cp9[1] & Cp9[0];
  Result[2] = Cp5[2];
  Result[3] = Cp15[3] & Cp15[0];
  Result[4] = ~ (Cp9[1] | Cp9[0]);
  Result[5] = Cp5[0];
  Result[6] = Cp9[3];
  Result[7] = Cp2;
  Result[8] = ~ Result[6];
  Result[9] = ~ Result[5];
  Result[10] = ~ Result[4];
  Result[11] = ~ Result[3];
  Result[12] = ~ Result[2];
  Result[13] = ~ Result[1];
  Greyscale =  Result;
end
endfunction
 
// -----------------------------------------------------------------------------
//  16 input mux to select the greyscale
// -----------------------------------------------------------------------------
function  vidgsmux;
 
input [3:0] Colour;
input [13:1] Greyscale;
reg Result;
begin
  case (Colour)
    4'b0000 :
      Result = 1'b0;
    4'b0001 :
      Result = Greyscale[1];
    4'b0010 :
      Result = Greyscale[2];
    4'b0011 :
      Result = Greyscale[3];
    4'b0100 :
      Result = Greyscale[4];
    4'b0101 :
      Result = Greyscale[5];
    4'b0110 :
      Result = Greyscale[6];
    4'b0111 :
      Result = Greyscale[7];
    4'b1000 :
      Result = Greyscale[8];
    4'b1001 :
      Result = Greyscale[9];
    4'b1010 :
      Result = Greyscale[10];
    4'b1011 :
      Result = Greyscale[11];
    4'b1100 :
      Result = Greyscale[12];
    4'b1101 :
      Result = Greyscale[13];
    4'b1110 :
      Result = 1'b1;
    4'b1111 :
      Result = 1'b1;
    default  :
      begin
        Result = 1'b0;
      end // case: default      
  endcase
 
  vidgsmux =  Result;
end
endfunction

// ---------------------------------------------------------------------------
// combinational process for frame phase accumulator - clocked at frame rate
// ---------------------------------------------------------------------------
always @(LcdEn or EndFrame or Fp2 or Fp5 or Fp9 or Fp15 or Urp2 or Urp5 or
         Urp9 or Urp15 or Trp2 or Trp5 or Trp9 or Trp15 or AhbMBESyncLclk)
begin : p_FpStateComb
  if ((LcdEn == 1'b0) || (AhbMBESyncLclk == 1'b1))
    begin
      NextFp2   =  1'b0;
      NextFp5   =  3'b000;
      NextFp9   =  4'b0000;
      NextFp15  =  4'b1111;
      NextTrp2  =  1'b0;
      NextTrp5  =  3'b000;
      NextTrp9  =  4'b0000;
      NextTrp15 =  4'b1111;
    end
  else if ((EndFrame & LcdEn) == 1'b1) 
    begin
      NextFp2   = ~ Fp2;
      NextFp5   = IncFrame5(Fp5);
      NextFp9   = IncFrame9(Fp9);
      NextFp15  = IncFrame15(Fp15);
      NextTrp2  = Urp2;
      NextTrp5  = Urp5;
      NextTrp9  = Urp9;
      NextTrp15 = Urp15;
    end
  else
    begin
      NextFp2   = Fp2;
      NextFp5   = Fp5;
      NextFp9   = Fp9;
      NextFp15  = Fp15;
      NextTrp2  = Trp2;
      NextTrp5  = Trp5;
      NextTrp9  = Trp9;
      NextTrp15 = Trp15;
    end
end // p_FpStateComb

// ---------------------------------------------------------------------------
// Sequential process for frame phase accumulator
// ---------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_FpStateSeq 
  if (nCLCLKRESET == 1'b0)
    begin
      Fp2   <= 1'b0;
      Trp2  <= 1'b0;
      Fp5   <= 3'b000;
      Trp5  <= 3'b000;
      Fp9   <= 4'b0000;
      Trp9  <= 4'b0000;
      Fp15  <= 4'b1111;
      Trp15 <= 4'b1111;
    end
  else
    begin
      Fp2   <= NextFp2;
      Trp2  <= NextTrp2;
      Fp5   <= NextFp5;
      Trp5  <= NextTrp5;
      Fp9   <= NextFp9;
      Trp9  <= NextTrp9;
      Fp15  <= NextFp15;
      Trp15 <= NextTrp15;
    end
end // p_FpStateSeq

// ---------------------------------------------------------------------------
// combinational process for row phase accumulator - clocked by row clock
// ---------------------------------------------------------------------------
always @(LoadRow or ClockRow or Fp2 or Fp5 or Fp9 or Fp15 or Trp2 or Trp5 or
         Trp9 or Trp15 or Urp2 or Urp5 or Urp9 or Urp15 or Lrp2 or Lrp5 or 
         Lrp9 or Lrp15 or LcdRun or LcdEn)
begin : p_RpStateComb
  if ((LoadRow & (LcdRun | LcdEn)) == 1'b1)
    begin
      NextUrp2  = Fp2;
      NextUrp5  = Fp5;
      NextUrp9  = Fp9;
      NextUrp15 = Fp15;
      NextLrp2  = Trp2;
      NextLrp5  = Trp5;
      NextLrp9  = Trp9;
      NextLrp15 = Trp15;
    end 
  else if ((ClockRow & LcdRun) == 1'b1) 
    begin
      NextUrp2  = ~ Urp2;
      NextUrp5  = IncRow5 (Urp5);
      NextUrp9  = IncRow9 (Urp9);
      NextUrp15 = IncRow15 (Urp15);
      NextLrp2  = ~ Lrp2;
      NextLrp5  = IncRow5 (Lrp5);
      NextLrp9  = IncRow9 (Lrp9);
      NextLrp15 = IncRow15 (Lrp15);
    end
  else
    begin
      NextUrp2  = Urp2;
      NextUrp5  = Urp5;
      NextUrp9  = Urp9;
      NextUrp15 = Urp15;
      NextLrp2  = Lrp2;
      NextLrp5  = Lrp5;
      NextLrp9  = Lrp9;
      NextLrp15 = Lrp15;
    end
end // p_RpStateComb

// ---------------------------------------------------------------------------
// Sequential process for row phase accumulator
// ---------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_RpStateSeq 
  if (nCLCLKRESET == 1'b0)
    begin
      Urp2  <= 1'b0;
      Lrp2  <= 1'b0;
      Urp5  <= 3'b000;
      Lrp5  <= 3'b000;
      Urp9  <= 4'b0000;
      Lrp9  <= 4'b0000;
      Urp15 <= 4'b1111;
      Lrp15 <= 4'b1111;
    end
  else
    begin
      Urp2  <= NextUrp2;
      Lrp2  <= NextLrp2;
      Urp5  <= NextUrp5;
      Lrp5  <= NextLrp5;
      Urp9  <= NextUrp9;
      Lrp9  <= NextLrp9;
      Urp15 <= NextUrp15;
      Lrp15 <= NextLrp15;
    end
end // p_RpStateSeq

// ---------------------------------------------------------------------------
// combinational process for column phase accumulator - clocked by LCLK
// ---------------------------------------------------------------------------
always @(LoadCol or GSEnable or Urp2 or Urp5 or Urp9 or Urp15 or LcdEn or
         Lrp2 or Lrp5 or Lrp9 or Lrp15 or Ucp2 or Ucp5 or Ucp9 or Ucp15 or
         Lcp2 or Lcp5 or Lcp9 or Lcp15 or LcdRun  or PixCountIncEn) 
begin : p_CpStateComb
  if ((LoadCol & (LcdRun | LcdEn)) == 1'b1)
    begin
      NextUcp2  = Urp2;
      NextUcp5  = Urp5;
      NextUcp9  = Urp9;
      NextUcp15 = Urp15;
      NextLcp2  = Lrp2;
      NextLcp5  = Lrp5;
      NextLcp9  = Lrp9;
      NextLcp15 = Lrp15;
    end
  else if ((GSEnable & LcdRun & PixCountIncEn) == 1'b1)
    begin
      NextUcp2  = ~ Ucp2;
      NextUcp5  = IncCol5 (Ucp5);
      NextUcp9  = IncCol9 (Ucp9);
      NextUcp15 = IncCol15 (Ucp15);
      NextLcp2  = ~ Lcp2;
      NextLcp5  = IncCol5 (Lcp5);
      NextLcp9  = IncCol9 (Lcp9);
      NextLcp15 = IncCol15 (Lcp15);
    end 
  else
    begin
      NextUcp2  = Ucp2;
      NextUcp5  = Ucp5;
      NextUcp9  = Ucp9;
      NextUcp15 = Ucp15;
      NextLcp2  = Lcp2;
      NextLcp5  = Lcp5;
      NextLcp9  = Lcp9;
      NextLcp15 = Lcp15;
    end
end // p_CpStateComb

// ---------------------------------------------------------------------------
// Sequential process for row phase accumulator
// ---------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_CpStateSeq 
  if (nCLCLKRESET == 1'b0)
    begin
      Ucp2  <= 1'b0;
      Lcp2  <= 1'b0;
      Ucp5  <= 3'b000;
      Lcp5  <= 3'b000;
      Ucp9  <= 4'b0000;
      Lcp9  <= 4'b0000;
      Ucp15 <= 4'b1111;
      Lcp15 <= 4'b1111;
    end
  else
    begin
      Ucp2  <= NextUcp2;
      Lcp2  <= NextLcp2;
      Ucp5  <= NextUcp5;
      Lcp5  <= NextLcp5;
      Ucp9  <= NextUcp9;
      Lcp9  <= NextLcp9;
      Ucp15 <= NextUcp15;
      Lcp15 <= NextLcp15;
    end
end // p_CpStateSeq

// ---------------------------------------------------------------------------
//   Greyscaler
// ---------------------------------------------------------------------------
assign  GreysU = Greyscale (Ucp2, Ucp5, Ucp9, Ucp15);
assign  GreysL = Greyscale (Lcp2, Lcp5, Lcp9, Lcp15);

// ---------------------------------------------------------------------------
//  GreyScaler mux. Pass the pixel data in to the greyscaler MUX to obtain
//  1 bit greyscaled pixel.
// ---------------------------------------------------------------------------
assign  UpRGS = vidgsmux (PixelRed, GreysU);
assign  UpGGS = vidgsmux (PixelGreen, GreysU);
assign  UpBGS = vidgsmux (PixelBlue, GreysU);
assign  LpRGS = vidgsmux (PixelRed, GreysL);
assign  LpGGS = vidgsmux (PixelGreen, GreysL);
assign  LpBGS = vidgsmux (PixelBlue, GreysL);

// ---------------------------------------------------------------------------
//   Greyscaler control state machine
// ---------------------------------------------------------------------------
//
// This state machine controls extracting data from the input FIFO/palette,
// greyscaling it, and pushing into the formatter block
//
// ---------------------------------------------------------------------------
always @(AhbMBESyncLclk or GSState or LcdEn or StartRow or PixCount or EndFrame 
         or PixelAvail or IntFormFifoFull or PPL or PixCountIncEn)
begin : p_GStateComb
  NextGSState  =  GSState;
  NextPixCount =  PixCount;
  NextClockRow =  1'b0;
  NextLoadRow  =  1'b0;
  NextLcdRun   =  1'b0;
// ---------------------------------------------------------------------------
// if AHB master Error interrupt is set: Intialise PixCount, ClockRow, LoadRow,
// LcdRun signal to their default value and wait here.
// ---------------------------------------------------------------------------
  if (AhbMBESyncLclk == 1'b1)
    begin
      NextGSState  =  `GSIDLE;
      NextPixCount =  PixCount;
      NextClockRow =  1'b0;
      NextLoadRow  =  1'b0;
      NextLcdRun   =  1'b0;
    end
  else
    case (GSState[1:0])
     `GSIDLE :        
        begin
// ---------------------------------------------------------------------------
// if LcdEn is HIGH and StartRow Pulse is sampled HIGH, set LoadRow = 0, 
// LcdRun = 1 to enable the greyscaler and go to GSACTIVE state. Else wait
// in this state.
// ---------------------------------------------------------------------------
          if ((LcdEn == 1'b1) && (StartRow == 1'b1))
            begin
              NextLoadRow =  1'b0;
              NextGSState =  `GSACTIVE;
              NextLcdRun  =  1'b1;         
            end
          else
            begin
              NextPixCount =  10'b0;
              NextLoadRow  =  1'b1;        
            end
        end
       
     `GSACTIVE :
        begin
          NextLcdRun  =  1'b1;
          if ((PixelAvail == 1'b1) && (IntFormFifoFull == 1'b0))
            begin
// ---------------------------------------------------------------------------
// if Pixel is available in the pipeline and the outfifo is not full and end of
//line is not reached: increment the Pixel Counter when PixCountIncEn is sampled
// HIGH. else reset the pixel counter, issue ClockRow to increment the row phase
// counters and go to GSWAITROW state
// ---------------------------------------------------------------------------
              if (PixCount != {PPL, 4'b1111})
                begin
                  if (PixCountIncEn == 1'b1)
                    NextPixCount =  PixCount + 10'b1;
                end
              else
                begin
                  if (PixCountIncEn == 1'b1)
                    begin             
                      NextPixCount =  10'b0;
                      NextGSState  =  `GSWAITROW;
                      NextClockRow =  1'b1;      
                    end     
                end
            end 
         end 

      `GSWAITROW :
         begin
// ---------------------------------------------------------------------------
// if EndFrame signal is sampled HIGH go to GSENDFRAME state. Else if StartRow
// signal is sampled HIGH to start a new line go to GSACTIVE state.
// ---------------------------------------------------------------------------
           NextLcdRun  =  1'b1;
           if (EndFrame == 1'b1)
             NextGSState =  `GSENDFRAME;          
           else     
             if (StartRow == 1'b1)
                 NextGSState =  `GSACTIVE;
         end 

      `GSENDFRAME :
         begin    
// ---------------------------------------------------------------------------
// Load Row state counter with the frame state counter value. If LcdEn bit HIGH
// go to GSWAITROW state. Else go to GSIDLE state.
// ---------------------------------------------------------------------------
           NextLcdRun  =  1'b1;
           NextLoadRow =  1'b1;
           if (LcdEn == 1'b1)
              NextGSState =  `GSWAITROW;
           else
             begin
               NextGSState =  `GSIDLE;  
               NextLcdRun  =  1'b0;
             end 
         end
      default :
        begin
          NextGSState =  `GSIDLE;
        end
     endcase
end // p_GStateComb

// ---------------------------------------------------------------------------
// Sequential process for the greyscaler state machine 
// ---------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_GStateSeq
  if (nCLCLKRESET == 1'b0)
    begin
      GSState       <= `GSIDLE;
      PixCount[9:0] <= 10'b0;
      ClockRow      <= 1'b0;
      LoadRow       <= 1'b0;
      LcdRun        <= 1'b0;
    end
  else
    begin
      GSState       <= NextGSState;
      PixCount[9:0] <= NextPixCount;
      ClockRow      <= NextClockRow;
      LoadRow       <= NextLoadRow;
      LcdRun        <= NextLcdRun;
    end
end // p_GStateSeq

// ---------------------------------------------------------------------------
// Enable greyscaler only if LcdRun = 1 ,GSState = ACTIVE, pixelavalible from
// palette and outfifo is not full
// ---------------------------------------------------------------------------
assign GSEnableInt = LcdRun & (GSState == `GSACTIVE) & PixelAvail & 
                     (~FormFifFull & (PixCount != {PPL, 4'b1111}));

// ---------------------------------------------------------------------------
// clocked version of GSEnableInt
// ---------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_DGSEnSeq
  if (nCLCLKRESET == 1'b0)
    DGSEnable <=  1'b0;
  else
    DGSEnable <=  GSEnableInt;
end // p_DGSEnSeq

// ---------------------------------------------------------------------------
// TFT mode     : enable data from LcdTiming
// Passive mode : enable data from Greyscaler
// ---------------------------------------------------------------------------
assign  PixelEn = (LcdTFT == 1'b1) ? FifoEn :
                            (LcdDual == 1'b1) ? DGSEnable : GSEnableInt;

// ---------------------------------------------------------------------------
// in dual panel mode: stop greyscaling one clock early to align Toggle signal
// with the pixelEn signal
// ---------------------------------------------------------------------------
assign GSEnable = DelPixelEn;

// -----------------------------------------------------------------------------
// Enable signal to load Row state values in to coloumn state
// -----------------------------------------------------------------------------
assign  RowOp = ClockRow | (LoadRow & ~StartRow);
 
// -----------------------------------------------------------------------------
// Clocked version of load coloumn signal
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_RowOpSeq
  if (nCLCLKRESET == 1'b0)
    LoadCol <= 1'b0;
  else
    LoadCol <= RowOp;
end // p_RowOpSeq

// ---------------------------------------------------------------------------
//Toggle signal to select and greyscale pixels from upper and lower panel path
// in dual panel mode. In single panel mode this signal will be always held LOW
// to select only the upper panel pixel
// ---------------------------------------------------------------------------
always @(Toggle or GSEnableInt or LcdDual)
begin : p_ToggleComb
  NextToggle = Toggle;
  if ((GSEnableInt == 1'b1) && (LcdDual == 1'b1))
    NextToggle =  (~Toggle);
  else
    NextToggle =  1'b0;
end // p_ToggleComb

// -----------------------------------------------------------------------------
// Sequential process for Toggle signal
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_ToggleSeq 
  if (nCLCLKRESET == 1'b0)
    Toggle <=  1'b0;
  else
    Toggle <=  NextToggle;
end // p_ToggleSeq

// -----------------------------------------------------------------------------
// Delayed version of Pixel enable and Formatter Fifo full signals
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_DPEnSeq
  if (nCLCLKRESET == 1'b0)
    begin
      DelFormFifFull1  <=  1'b0;
      DelFormFifFull2  <=  1'b0;
      DelPixelEn       <=  1'b0;
    end
  else
    begin
      DelFormFifFull1  <=  FormFifFull;
      DelFormFifFull2  <=  DelFormFifFull1;
      DelPixelEn       <=  PixelEn;
    end
end // p_DPEnSeq

// -----------------------------------------------------------------------------
// Greyscaler pixel select signal generation. this is used for de-multiplexing
// of pixelEn and formatter fifo full signals in dual panel mode.
// -----------------------------------------------------------------------------
always @(GspixSelect or LcdDual or Toggle)
begin : p_GsPSelComb
  NextGspixSelect = GspixSelect;
  if (LcdDual == 1'b1)
    NextGspixSelect = Toggle;
  else
    NextGspixSelect = 1'b1;
end // p_GsPSelComb

// -----------------------------------------------------------------------------
// Sequential process for GspixSelect signal
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK  or negedge nCLCLKRESET)
begin : p_GsPSelSeq
  if (nCLCLKRESET == 1'b0)
    GspixSelect <= 1'b1;
  else 
    GspixSelect <= NextGspixSelect;
end // p_GsPSelSeq

// -----------------------------------------------------------------------------
// Pixel counter increment enable. In Dual Panel mode incriment pixel count 
// every alternate clock.
// -----------------------------------------------------------------------------
assign PixCountIncEn = (LcdDual == 1'b1) ? (~GspixSelect & DelPixelEn) 
                                        : DelPixelEn;
assign IntFormFifoFull = (LcdDual == 1'b1) ? DelFormFifFull2 : DelFormFifFull1;

// -----------------------------------------------------------------------------
// Muxing of  Pixelenable signals in Dual Panel mode.
// in Single panel mode GspixSelect signal will be always HIGH and hence
// upper panel signals are selected
// -----------------------------------------------------------------------------
assign FormFifFull = (GspixSelect == 1'b1) ? UpFormFifoFull : LpFormFifoFull; 
assign UpPixelEn   = (GspixSelect == 1'b1) ? DelPixelEn     : 1'b0;
assign LpPixelEn   = (GspixSelect == 1'b0) ? DelPixelEn     : 1'b0;
 
endmodule 

// --=========================================================================--
