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
// Filename   : DirtyRam8k.v,v
// Date       : 2006/12/19
// Revision   : 1.0
// Release Information : ARM926EJS_r0p5-00rel0 
//
//---------------------------------------------------------------------------

//#
//#                          DirtyRam8k
//#                          ============
//#
//# ARM926EJS Dirty RAM behavioural model (128 KB default)
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
//# Very much a behavioural model of the Dirty RAM for the D$.
//#

//#
//# Module Declaration
//# ==================
//#

module DirtyRam8ka(
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

  parameter word_depth = 64;  // 4 cache lines per row/entry
  parameter wordx      = {8{1'bx}};
  parameter bitx       = {1{1'bx}};
  
//#
//# Interface Signals
//# =================
//#

  input          CLK;
  input          CE;
  input  [ 7: 0] WE;
  input  [ 5: 0] A;
  input  [ 7: 0] D;

  output [ 7: 0] Q;

//#
//# Internal Signals
//# ================
//#

//#
//# Main Code
//# =========
//#

  DirtyRamPrim DRP0(
	.CLK(CLK),
	.CE(CE),
	.WE(WE[0]),
	.A(A),
	.D(D[0]),
	.Q(Q[0])
  );

  DirtyRamPrim DRP1(
	.CLK(CLK),
	.CE(CE),
	.WE(WE[1]),
	.A(A),
	.D(D[1]),
	.Q(Q[1])
  );

  DirtyRamPrim DRP2(
	.CLK(CLK),
	.CE(CE),
	.WE(WE[2]),
	.A(A),
	.D(D[2]),
	.Q(Q[2])
  );

  DirtyRamPrim DRP3(
	.CLK(CLK),
	.CE(CE),
	.WE(WE[3]),
	.A(A),
	.D(D[3]),
	.Q(Q[3])
  );

  DirtyRamPrim DRP4(
	.CLK(CLK),
	.CE(CE),
	.WE(WE[4]),
	.A(A),
	.D(D[4]),
	.Q(Q[4])
  );

  DirtyRamPrim DRP5(
	.CLK(CLK),
	.CE(CE),
	.WE(WE[5]),
	.A(A),
	.D(D[5]),
	.Q(Q[5])
  );

  DirtyRamPrim DRP6(
	.CLK(CLK),
	.CE(CE),
	.WE(WE[6]),
	.A(A),
	.D(D[6]),
	.Q(Q[6])
  );

  DirtyRamPrim DRP7(
	.CLK(CLK),
	.CE(CE),
	.WE(WE[7]),
	.A(A),
	.D(D[7]),
	.Q(Q[7])
  );

endmodule // DirtyRam8ka
