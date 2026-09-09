/*
 Radix-2 algorithm of quare root.
 
 Project : Enhancer
 File name : sqrt_r2.v
 creaded by : gltee
 created date : 2005.1.5

 notes :
    the delay is no.

 hitory :
 
 */

module sqrt_r2
  (
   quot_bfr           ,
   rad_bfr            , 
   r_org_bfr          ,
   
   quotient           ,
   radicad            ,
   r_org          
   );
   parameter           WIDTH_RAD_ORG = 28;
   parameter           WIDTH_RAD = 14;
   parameter 	       WIDTH_Q = 14;
   parameter 	       WIDTH_ADD = WIDTH_RAD + 3; // 17bit

   // in/out
   input [WIDTH_Q-1:0] quot_bfr; // 14bit
   input [WIDTH_RAD-1:0] rad_bfr; // 13bit
   input [WIDTH_RAD_ORG-1:0] r_org_bfr; // 28bit
   
   output [WIDTH_Q-1:0] quotient; // 14bit
   output [WIDTH_RAD-1:0] radicad; // 14bit
   output [WIDTH_RAD_ORG-1:0] r_org; // 28bit
   
   // internal signals
   wire [WIDTH_ADD-1:0] fgen; // 17bit
   wire [WIDTH_RAD-1+2:0] rad;  // 16bit
   wire [WIDTH_ADD-1:0] rest; // 17bit

   reg [WIDTH_Q-1:0]   quotient; // 14bit
   reg [WIDTH_RAD-1:0] radicad; // 14bit
   reg [WIDTH_RAD_ORG-1:0] r_org; // 28bit
   
   // prepare for the addition.
   
   assign 			   fgen = {3'h7,quot_bfr[WIDTH_RAD-3:0],2'b11};
   assign 			   rad = {rad_bfr,r_org_bfr[WIDTH_RAD_ORG-1:WIDTH_RAD_ORG-2]};
   assign 			   rest = fgen + rad;
   
   always@(r_org_bfr or quot_bfr or rest or rad) begin
	  r_org <= {r_org_bfr[WIDTH_RAD_ORG-3:0],2'b00};
	  quotient <= {quot_bfr[WIDTH_Q-2:0],rest[WIDTH_ADD-1]};
	  
	  if(rest[WIDTH_ADD-1] == 1'b0)
		radicad <= rest[WIDTH_RAD-1:0];
	  else radicad <= rad[WIDTH_RAD-1:0];
   end // always@ (posedge clk or negedge rstb)
   
endmodule // sqrt_r2

