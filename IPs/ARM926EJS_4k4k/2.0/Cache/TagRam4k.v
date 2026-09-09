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
// Filename   : TagRam128k.v,v
// Date       : 2001/10/23 07:49:30
// Revision   : 1.2
// Release Information : ARM926EJS_r0p5-00rel0 
//
//---------------------------------------------------------------------------

//#
//#                          TagRam128k
//#                          ==========
//#
//# ARM926EJS TAG RAM behavioural model (supports 128KB default)
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
//# Very much a behavioural model of the TAG RAM for the Caches.
//#

//#
//# Module Declaration
//# ==================
//#

module TagRam4k(
   CLK,
   CE,
   WE,
   A,
   D,
   Q
);
//#
//# Local Definitions (if any)
//# ==========================
//#

  parameter word_depth = 64;  // do (2x 1024)
  parameter wordx      = {22{1'bx}};
  
//#
//# Interface Signals
//# =================
//#

  input          CLK;
  input          CE;
  input          WE;
  input  [10: 0] A;
  input  [21: 0] D;

  output [21: 0] Q;

//#
//# Internal Signals
//# ================
//#

  reg  [21: 0] mem [word_depth-1:0];
  reg  [21: 0] Qi;

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
          mem[A[5:0]] = D;
          Qi = #1 mem[A[5:0]];
        end else begin
            Qi = #1 mem[A[5:0]];
        end
    end

  end // RamMain

  // drive Q outputs
  assign Q = Qi;
endmodule // TagRam4k

//#
//# Design Assumptions and Timing Issues
//# ====================================
//#

