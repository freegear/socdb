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

module DirtyRam8k
  (
   CLK,
   RSTN,
   CEN,
   WEN,
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
  input 		 RSTN;
  input 		 CEN;
  input  [ 7: 0] WEN;
  input  [ 5: 0] A;
  input  [ 7: 0] D;

  output [ 7: 0] Q;

//#
//# Internal Signals
//# ================
//#
   reg [7:0] 	 Q;
   
   reg [63:0] 	 duty0;
   reg [63:0] 	 duty1;
   reg [63:0] 	 duty2;
   reg [63:0] 	 duty3;
   reg [63:0] 	 duty4;
   reg [63:0] 	 duty5;
   reg [63:0] 	 duty6;
   reg [63:0] 	 duty7;
   
   
//#
//# Main Code
//# =========
//#

   // read

   always@(posedge CLK or negedge RSTN) begin
	  if(!RSTN)
		Q <= 8'h00;
	  else
		Q <= {duty7[A],duty6[A],duty5[A],duty4[A],
			  duty3[A],duty2[A],duty1[A],duty0[A]};
   end // always

   // write
   always@(posedge CLK or negedge RSTN) begin
	  if(!RSTN)
		duty0 <= {64{1'b0}};
	  else if(WEN[0] == 1'b0 && CEN == 1'b0)
		duty0[A] <= D[0];
   end // always
   
   always@(posedge CLK or negedge RSTN) begin
	  if(!RSTN)
		duty1 <= {64{1'b0}};
	  else if(WEN[1] == 1'b0 && CEN == 1'b0)
		duty1[A] <= D[1];
   end // always
	  
   always@(posedge CLK or negedge RSTN) begin
	  if(!RSTN)
		duty2 <= {64{1'b0}};
	  else if(WEN[2] == 1'b0 && CEN == 1'b0)
		duty2[A] <= D[2];
   end // always

   always@(posedge CLK or negedge RSTN) begin
	  if(!RSTN)
		duty3 <= {64{1'b0}};
	  else if(WEN[3] == 1'b0 && CEN == 1'b0)
		duty3[A] <= D[3];
   end // always

   always@(posedge CLK or negedge RSTN) begin
	  if(!RSTN)
		duty4 <= {64{1'b0}};
	  else if(WEN[4] == 1'b0 && CEN == 1'b0)
		duty4[A] <= D[4];
   end // always

   always@(posedge CLK or negedge RSTN) begin
	  if(!RSTN)
		duty5 <= {64{1'b0}};
	  else if(WEN[5] == 1'b0 && CEN == 1'b0)
		duty5[A] <= D[5];
   end // always

   always@(posedge CLK or negedge RSTN) begin
	  if(!RSTN)
		duty6 <= {64{1'b0}};
	  else if(WEN[6] == 1'b0 && CEN == 1'b0)
		duty6[A] <= D[6];
   end // always
   
   always@(posedge CLK or negedge RSTN) begin
	  if(!RSTN)
		duty7 <= {64{1'b0}};
	  else if(WEN[7] == 1'b0 && CEN == 1'b0)
		duty7[A] <= D[7];
   end // always

   
   /*
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
*/
endmodule // DirtyRam4k
