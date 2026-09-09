// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SsmcPadMux.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module includes the registers and mux that drive the SMC
//           outputs. Including all three registers and the mux in one module
//           will ease timing and avoid glitches.
//
// --=========================================================================--

module SsmcPadMux
  (/*AUTOARG*/
  // Outputs
  SmCtrlOut, 
  // Inputs
  SMMEMCLKDELAY, SMMEMCLK, HRESETn, NextAsynAxs, SmCtrlIn, 
  SmCtrlInit
  );

  parameter MUX_WIDTH = 1;
  
  input SMMEMCLKDELAY;
  input SMMEMCLK;
  input HRESETn;

  input NextAsynAxs;
  input [MUX_WIDTH-1:0] SmCtrlIn;
  input                 SmCtrlInit;
  
  output [MUX_WIDTH-1:0] SmCtrlOut;

  //--------------------------------------------------------------------------
  // Register declarations
  //--------------------------------------------------------------------------
  reg                    AsynAxs;
  reg  [MUX_WIDTH-1:0]   SmCtrlInRegRes;
  reg  [MUX_WIDTH-1:0]   SmCtrlInRegPre;
  wire [MUX_WIDTH-1:0]   SmCtrlInRegDel;
  reg  [MUX_WIDTH-1:0]   SmCtrlInRegDelPre;
  reg  [MUX_WIDTH-1:0]   SmCtrlInRegDelRes;

  //--------------------------------------------------------------------------
  // Wire declarations
  //--------------------------------------------------------------------------
  wire [MUX_WIDTH-1:0]   SmCtrlInReg;

  //--------------------------------------------------------------------------
  // Main Code
  //--------------------------------------------------------------------------
  
  // Mux control signal
  always@(posedge SMMEMCLK or negedge HRESETn)
    begin : p_AsynAxsSeq
      if (!HRESETn)
        AsynAxs <= 1'b1;
      else
        AsynAxs <= NextAsynAxs;
    end

  // Reset Mux input register
  always@(posedge SMMEMCLK or negedge HRESETn)
    begin : p_SmCtrlRegSeq0
      if (!HRESETn)
        SmCtrlInRegRes <= {MUX_WIDTH{1'b0}};
      else
        SmCtrlInRegRes <= SmCtrlIn;
    end

  // Preset Mux input register
  always@(posedge SMMEMCLK or negedge HRESETn)
    begin : p_SmCtrlRegSeq1
      if (!HRESETn)
        SmCtrlInRegPre <=  {MUX_WIDTH{1'b1}};
      else
        SmCtrlInRegPre <= SmCtrlIn;
    end

  // Select either the preset or reset register. This mux will be optimised out
  // during synthesis as SmCtrlInit is tied off at the level above, SsmcPadIf.
  assign SmCtrlInReg = SmCtrlInit ? SmCtrlInRegPre : SmCtrlInRegRes;
                      
  // Mux input register
  always@(posedge SMMEMCLKDELAY or negedge HRESETn)
    begin : p_SmCtrlRegDelResSeq
      if (!HRESETn)
        SmCtrlInRegDelRes <= {MUX_WIDTH{1'b0}};
      else
        SmCtrlInRegDelRes <= SmCtrlInReg;
    end

  // Mux input register
  always@(posedge SMMEMCLKDELAY or negedge HRESETn)
    begin : p_SmCtrlRegDelPreSeq
      if (!HRESETn)
        SmCtrlInRegDelPre <= {MUX_WIDTH{1'b1}};
      else
        SmCtrlInRegDelPre <= SmCtrlInReg;
    end

  assign SmCtrlInRegDel = SmCtrlInit ? SmCtrlInRegDelPre : SmCtrlInRegDelRes;

  assign SmCtrlOut = AsynAxs ? SmCtrlInReg : SmCtrlInRegDel;
             
endmodule // SsmcPadMux
