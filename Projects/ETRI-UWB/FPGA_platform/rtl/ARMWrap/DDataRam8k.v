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
// Filename   : DataRam8k.v,v
// Date       : 2006/12/19 
// Revision   : 1.0
// Release Information : ARM926EJS_r0p5-00rel0 
//
//---------------------------------------------------------------------------

//#
//#                          DataRam8k  
//#                          ===========  
//#
//# ARM926EJS Data RAM behavioural model (default 8KB)
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
//# Very much a behavioural model of the Data RAM for the Caches.
//#

//#
//# Module Declaration
//# ==================
//#

module DDataRam8k(
   CLK,
   CE,
   WE,
   A,
   D,
   Q
);

  input          CLK;
  input          CE;
  input  [ 3: 0] WE;
  input  [ 8: 0] A;       // 512 word
  input  [31: 0] D;

  output [31: 0] Q;

	DataRamPrim DRP0(
		.CLK(CLK),
		.CE(CE),
		.WE(WE[0]),
		.A(A),
		.D(D[7:0]),
		.Q(Q[7:0])
	);

	DataRamPrim DRP1(
		.CLK(CLK),
		.CE(CE),
		.WE(WE[1]),
		.A(A),
		.D(D[15:8]),
		.Q(Q[15:8])
	);

	DataRamPrim DRP2(
		.CLK(CLK),
		.CE(CE),
		.WE(WE[2]),
		.A(A),
		.D(D[23:16]),
		.Q(Q[23:16])
	);

	DataRamPrim DRP3(
		.CLK(CLK),
		.CE(CE),
		.WE(WE[3]),
		.A(A),
		.D(D[31:24]),
		.Q(Q[31:24])
	);

endmodule // DDataRam4k
