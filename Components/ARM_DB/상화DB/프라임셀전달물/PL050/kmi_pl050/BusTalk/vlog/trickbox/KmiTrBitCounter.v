//  ----------------------------------------------------------------------------
//  This confidential & proprietary software may be used only
//  as authorised by a licensing agreement from ARM Limited
//  (C) COPYRIGHT 1998 ARM Limited
//  ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised copies
//  & copies may only be made to the extent permitted by a
//  licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version & Release Control Information :
//
//
//  Filename             : $RCSfile :  $
//
//  File Revision        : $Revision : $
//
//  Release Information  : $State : $
//
// ----------------------------------------------------------------------------
// Purpose  : This block implements the 4-bit Bit Counter clocked by the
//           KCLK input ever CounterEn is HIGH. It keeps track of the 
//           number of bits transmitted or received. The Bit Counter can be 
//           reset by deasserting CounterEn signal.
//
// ---------------------------------------------------------------------------
 
`timescale 1ns/1ps

// ---------------------------------------------------------------------------

module KmiTrBitCounter (
                        BnRES,
                        KCLK,
                        CounterEn,
                        BitCount
                       );

input        BnRES;      // APB Reset
input        KCLK;       // Counter Clock
input        CounterEn;  // Counter Enable Signal
output [3:0] BitCount;   // Bit Count Output

// ---------------------------------------------------------------------------
//
//                          KmiTrBitCounter
//                          ===============
//
// ---------------------------------------------------------------------------
//
// Overview
// ========
// This block contains a free running 4-bit counter. It counts up by 1 at the 
// positive edge of KCLK while the CounterEn is HIGH. The BitCounter also 
// goes as input to the KmiTrController state machine.
//
// ---------------------------------------------------------------------------

//------------------------------------------------------------------------------
// wire Declarations
//------------------------------------------------------------------------------
wire [3:0] NextCounter;
// D-Input for Bit Counter

//------------------------------------------------------------------------------
// Register Declarations
//------------------------------------------------------------------------------
reg  [3:0] Counter;
// Internal Bit Counter 

// ----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// ----------------------------------------------------------------------------
 
assign BitCount = Counter;

assign NextCounter = (CounterEn == 1'b0) ? 4'b0000 : 
                     (Counter + 1'b1);

always @ (posedge KCLK or BnRES or CounterEn)
begin : p_CounterComb  
  if (BnRES  == 1'b0) 
    Counter = 4'b0000;
  else if (CounterEn == 1'b0) 
    Counter = 4'b0000;
  else
    Counter = NextCounter;
end  // p_CounterComb

endmodule

// ===================== End of KmiTrBitCounter =============================--
