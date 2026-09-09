//---------------------------------------------------------------------------
//  The confidential and proprietary information contained in this file may
//  only be used by a person authorised under and to the extent permitted
//  by a subsisting licensing agreement from ARM Limited.
//
//
//         (C) COPYRIGHT 2003 ARM Limited.
//             ALL RIGHTS RESERVED
//
//  This entire notice must be reproduced on all copies of this file
//  and copies of this file may only be made by a person if such person is
//  permitted to do so under the terms of a subsisting license agreement
//  from ARM Limited.
//
// Filename   : ValidRam8k.v,v
// Date       : 2006/12/19
// Revision   : 1.0
// Release Information : ARM926EJS_r0p5-00rel0 
//
//---------------------------------------------------------------------------

//#
//#                          ValidRam8k
//#                          ============
//#
//# ARM926EJS Valid RAM behavioural model (8 KB default)
//#
//# >Originator :< Kim Rasmussen
//#
//# Revisions
//# =========
//#
//#spec versions
//#
//# Overview
//# ========
//#
//# Very much a behavioural model of the Valid RAM for the Caches.
//#

//#
//# Module Declaration
//# ==================
//#

module ValidRam8k(
   CLK,
   CE,
   WE,
   A,
   D,
   Q
);
//#
//# Local Definitions
//# =================
//#

  parameter word_depth = 16; // 16 valid bits per row/entry
  parameter wordx      = {24{1'bx}};
  
//#
//# Interface Signals
//# =================
//#

  input          CLK;
  input          CE;
  input          WE;
  input  [ 3: 0] A;
  input  [23: 0] D;

  output [23: 0] Q;

//#
//# Internal Signals
//# ================
//#

  reg  [23: 0] mem [word_depth-1:0];
  reg  [23: 0] Qi;

//#
//# Main Code
//# =========
//#

  // always evaluate everything on the rising edge of CLK
  always @(posedge CLK)
  begin : RamMain

    // read/write activity must be initiated
    if (CE == 1'b1) begin
        if (WE == 1'b1) begin
          mem[A[3:0]] = D;
          Qi = #1 mem[A[3:0]];
        end else begin
            Qi = #1 mem[A[3:0]];
        end
    end

  end // RamMain

  // drive Q outputs
  assign Q = Qi;

endmodule // ValidRam8k

//#
//# Design Assumptions and Timing Issues
//# ====================================
//#

