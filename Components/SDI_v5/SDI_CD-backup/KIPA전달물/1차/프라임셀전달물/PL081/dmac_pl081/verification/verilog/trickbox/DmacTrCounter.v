// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacTrCounter.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This file describes a generic down counter
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacTrCounter (
// Inputs
                      HCLK,
                      HRESETn,
                      CountIn,
                      Load,
                      Enable,
                      Reset,
// Output
                      TerminalCount
                      );

parameter  CounterWidth  = 8;

// Inputs
input                 HCLK;          // AHB Clock
input                 HRESETn;       // AHB Reset
input  [(CounterWidth-1):0]
                      CountIn;       // Count Value
input                 Load;          // To load count value
input                 Enable;        // Counter Enable
input                 Reset;         // Counter Reset

// Output
output                      TerminalCount; // Terminal Count output

// Inputs
  wire                HCLK;          // AHB Clock
  wire                HRESETn;       // AHB Reset
  wire [(CounterWidth-1):0]
                      CountIn;       // Count Value
  wire                Load;          // To load count value
  wire                Enable;        // Counter Enable
  wire                Reset;         // Counter Reset

// Output
  reg                 TerminalCount; // Terminal Count output

// -----------------------------------------------------------------------------
//
//                            DmacTrCounter
//                            =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//        This file contains a generic module of a down counter. The counter
//  loads count when Load signal is asserted. It starts decrementing when enable
//  is kept asserted. It generates terminal count signal when counter reaches
//  zero.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [(CounterWidth - 1): 0] Count;
reg      StartCount;

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Type declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
//  Down Counter
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_CountSeq
  if (HRESETn == 1'b0)
    begin
      TerminalCount    <= 1'b0;
      Count            <= 'b0;
    end
  else
    begin
      if (Reset == 1'b1)
        begin
          TerminalCount    <= 1'b0;
          StartCount       <= 1'b0;
        end
      else
        begin
          if (Load == 1'b1 & CountIn > 'b0)
            begin
              Count            <= CountIn;
              StartCount       <= 1'b1;
            end
          if (Enable == 1'b1)
            begin
              if (StartCount == 1'b1)
                begin
                  if (Count > 'b0)
                    begin
                      Count            <=  (Count) - 1;
                      TerminalCount    <= 1'b0;
                    end
                  else
                    begin
                      TerminalCount    <= 1'b1;
                    end
                end
            end
          else
            begin
              TerminalCount    <= 1'b0;
              StartCount       <= 1'b0;
            end
        end
    end
end // p_CountSeq

// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

endmodule
// --================================= End ===================================--
